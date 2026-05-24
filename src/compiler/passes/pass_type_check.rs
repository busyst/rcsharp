use crate::{
    compiler::{
        context::{CompilerContext, ErrorSeverity, FileID},
        passes::{pass_optimizer::constant_expression_compiler, traits::CompilerPass},
        structs::{ContextPath, ContextPathEnd},
    },
    compiler_essentials::{
        CompileResult, CompiledTrait, CompiledTraitImpl, CompilerError, CompilerType, Enum,
        Function, FunctionFlags, LLVMVal, Struct, TraitMethodSignature, Variable,
    },
};
use ordered_hash_map::OrderedHashMap;
use rcsharp_parser::{
    defs::{
        ParsedEnum, ParsedFunction, ParsedImplementation, ParsedStruct, ParsedTrait,
        ParsedVariable, Stmt, StmtData,
    },
    expression_parser::Expr,
};
use std::collections::HashMap;
pub fn sort_by_context_path_file_id<T, F>(items: &mut [(ContextPath, FileID, T)], name: F)
where
    F: for<'a> Fn(&'a T) -> &'a str,
{
    items.sort_by(|a, b| (&a.0, name(&a.2), a.1).cmp(&(&b.0, name(&b.2), b.1)));
}

#[derive(Default)]
pub struct TypeCheckPass {}
impl<'a> CompilerPass<'a> for TypeCheckPass {
    type Input = &'a OrderedHashMap<FileID, Vec<StmtData>>;

    type Output = ();

    fn run(
        &mut self,
        input: Self::Input,
        ctx: &mut CompilerContext,
    ) -> CompileResult<Self::Output> {
        let mut worklist = vec![];
        for (file_id, body) in input {
            worklist.push((ContextPath::default(), *file_id, body.to_vec()));
        }

        let mut traits: Vec<(ContextPath, FileID, ParsedTrait)> = vec![];
        let mut implementations: Vec<(ContextPath, FileID, ParsedImplementation)> = vec![];
        let mut types: Vec<(ContextPath, FileID, ParsedStruct)> = vec![];
        let mut enums: Vec<(ContextPath, FileID, ParsedEnum)> = vec![];
        let mut functions: Vec<(ContextPath, FileID, ParsedFunction)> = vec![];
        let mut static_variables: Vec<(ContextPath, FileID, ParsedVariable)> = vec![];
        let mut consts: Vec<(ContextPath, FileID, ParsedVariable)> = vec![];

        while let Some((path, file_id, body)) = worklist.pop() {
            let mut namespace_work = vec![];
            for x in body {
                match x.stmt {
                    Stmt::Namespace(x, body) => {
                        let full_path = path.to_extended(&x);
                        namespace_work.push((full_path, body.to_vec()));
                    }
                    Stmt::Struct(x) => {
                        types.push((path.clone(), file_id.clone(), x));
                    }
                    Stmt::Function(x) => {
                        functions.push((path.clone(), file_id.clone(), x));
                    }
                    Stmt::Enum(x) => {
                        enums.push((path.clone(), file_id.clone(), x));
                    }
                    Stmt::TraitDeclaration(x) => {
                        traits.push((path.clone(), file_id.clone(), x));
                    }
                    Stmt::Impl(x) => {
                        implementations.push((path.clone(), file_id.clone(), x));
                    }
                    Stmt::StaticLet(var) => {
                        static_variables.push((path.clone(), file_id.clone(), var));
                    }
                    Stmt::ConstLet(var) => {
                        consts.push((path.clone(), file_id.clone(), var));
                    }
                    _ => {}
                }
            }
            namespace_work.sort_by(|a, b| a.0.cmp(&b.0));
            for (full_path, body) in namespace_work {
                worklist.push((full_path, file_id, body));
            }
        }

        sort_by_context_path_file_id(&mut types, |s| &*s.name);
        sort_by_context_path_file_id(&mut enums, |e| &*e.name);
        sort_by_context_path_file_id(&mut traits, |t| &*t.name);
        sort_by_context_path_file_id(&mut functions, |f| &*f.name);
        sort_by_context_path_file_id(&mut static_variables, |v| &*v.name);
        sort_by_context_path_file_id(&mut consts, |v| &*v.name);
        implementations.sort_by(|a, b| {
            (&a.0, a.2.implementing_for.to_string(), a.1).cmp(&(
                &b.0,
                b.2.implementing_for.to_string(),
                b.1,
            ))
        });

        for (type_env_path, file_id, parsed_type) in types.iter() {
            let type_path =
                ContextPathEnd::from_context_path(type_env_path.clone(), &parsed_type.name);
            let generic_params = parsed_type
                .generic_params
                .iter()
                .map(|p| p.name.clone())
                .collect::<Vec<_>>()
                .into_boxed_slice();
            let mut x = Struct::new_placeholder_with_generics(generic_params);
            x.file_id = *file_id;
            ctx.symbols.insert_type(type_path, x);
        }
        ctx.symbols.set_alias_types(HashMap::new());
        for (enum_env_path, file_id, parsed_enum) in enums {
            let backing_type = parsed_enum.enum_type.as_integer().ok_or_else(|| {
                CompilerError::Generic(
                    format!(
                        "Enum '{}' must have an integer backing type",
                        parsed_enum.name
                    )
                    .into(),
                )
            })?;

            let mut compiler_enum_fields = Vec::with_capacity(parsed_enum.fields.len());

            for (field_name, field_expr) in &parsed_enum.fields {
                let val = if let Expr::Integer(int) = field_expr {
                    LLVMVal::ConstantInteger(*int)
                } else {
                    constant_expression_compiler(field_expr).ok_or_else(|| {
                        CompilerError::Generic(
                            "Failed to evaluate constant expression for enum field".into(),
                        )
                    })?
                };
                compiler_enum_fields.push((field_name.to_string(), val));
            }

            let enum_path = ContextPathEnd::from_context_path(enum_env_path, &parsed_enum.name);
            let mut en = Enum::new(
                ContextPathEnd::default(), // Handled by insert
                CompilerType::Primitive(backing_type),
                compiler_enum_fields.into_boxed_slice(),
                parsed_enum.attributes.clone(),
            );
            en.file_id = file_id;
            ctx.symbols.insert_enum(enum_path, en);
        }
        for (type_env_path, file_id, struct_decl) in types {
            let mut new_alias_types = HashMap::new();
            for prm in &struct_decl.generic_params {
                new_alias_types.insert(
                    prm.name.clone(),
                    CompilerType::GenericPlaceholder(prm.name.clone().into_boxed_str()),
                );
            }
            ctx.symbols.set_alias_types(new_alias_types);

            let mut compiler_struct_fields = Vec::with_capacity(struct_decl.fields.len());

            for (name, attr_type) in struct_decl.fields.iter() {
                let field_type = if let Some(pt) = attr_type.as_primitive_type() {
                    CompilerType::Primitive(pt)
                } else {
                    CompilerType::from_parser_type(attr_type, &ctx.symbols, &type_env_path)?
                };
                compiler_struct_fields.push((name.to_string(), field_type));
            }
            let mut x = Struct::new(
                ContextPathEnd::default(),
                compiler_struct_fields.into_boxed_slice(),
                struct_decl.attributes.clone(),
                struct_decl
                    .generic_params
                    .iter()
                    .map(|p| p.name.clone())
                    .collect::<Vec<_>>()
                    .into_boxed_slice(),
            );
            x.file_id = file_id;
            let type_path = ContextPathEnd::from_context_path(type_env_path, &struct_decl.name);
            ctx.symbols.insert_type(type_path, x);
        }
        ctx.symbols.set_alias_types(HashMap::new());

        for (trait_env_path, file_id, parsed_trait) in traits {
            let mut methods = vec![];
            for method in parsed_trait.functions.iter() {
                let has_self = method
                    .args
                    .first()
                    .map(|(n, _)| n == "self")
                    .unwrap_or(false);
                let self_is_ref = if has_self {
                    matches!(method.args[0].1.as_pointer(), Some(_))
                } else {
                    false
                };
                let mut resolved_args = Vec::with_capacity(method.args.len());
                for (name, parser_type) in method.args.iter() {
                    let ct =
                        CompilerType::from_parser_type(parser_type, &ctx.symbols, &trait_env_path)?;
                    resolved_args.push((name.clone(), ct));
                }
                let return_type = CompilerType::from_parser_type(
                    &method.return_type,
                    &ctx.symbols,
                    &trait_env_path,
                )?;
                methods.push(TraitMethodSignature {
                    name: method.name.clone(),
                    args: resolved_args.into_boxed_slice(),
                    return_type,
                    has_self,
                    self_is_ref,
                });
            }
            let trait_path = ContextPathEnd::from_context_path(trait_env_path, &parsed_trait.name);
            let compiled_trait = CompiledTrait {
                full_path: trait_path.clone(),
                generic_params: parsed_trait
                    .generic_params
                    .iter()
                    .map(|p| p.name.clone())
                    .collect::<Vec<_>>()
                    .into_boxed_slice(),
                methods: methods.into_boxed_slice(),
                file_id,
            };
            ctx.symbols.insert_trait(trait_path, compiled_trait);
        }

        for (current_path, _file_id, var) in static_variables {
            let t = CompilerType::from_parser_type(&var.var_type, &ctx.symbols, &current_path)?;
            let full_path = ContextPathEnd::from_context_path(current_path, &var.name);
            ctx.symbols
                .insert_static_var(full_path, Variable::new(t, false, true))?;
        }
        for (current_path, _file_id, var) in consts {
            let t = CompilerType::from_parser_type(&var.var_type, &ctx.symbols, &current_path)?;
            let full_path = ContextPathEnd::from_context_path(current_path, &var.name);
            let c_var = Variable::new(t, true, false);
            let Some(expr) = var.expr else {
                return Err(CompilerError::Generic(format!("Const must have expression")).into());
            };
            let Some(expr) = constant_expression_compiler(&expr) else {
                return Err(CompilerError::Generic(format!(
                    "Expression {} did nit compiled to constant",
                    expr.debug_emit()
                ))
                .into());
            };
            c_var.set_constant_value(Some(expr));
            ctx.symbols.insert_const(full_path, c_var)?;
        }
        for (current_path, file_id, parsed_function) in functions {
            let return_type = CompilerType::from_parser_type(
                &parsed_function.return_type,
                &ctx.symbols,
                &current_path,
            )?;
            let mut args_vec = Vec::with_capacity(parsed_function.args.len());
            for (name, type_expr) in &parsed_function.args {
                let arg_type =
                    CompilerType::from_parser_type(type_expr, &ctx.symbols, &current_path)?;
                args_vec.push((name.clone(), arg_type));
            }
            let args = args_vec.into_boxed_slice();

            let full_path = ContextPathEnd::from_context_path(current_path, &parsed_function.name);
            let b = type_check_function_body(&parsed_function.body, &return_type, &args, ctx)
                .unwrap_or(parsed_function.body.clone());
            let mut function = Function::new(
                ContextPathEnd::default(),
                args,
                return_type,
                b,
                FunctionFlags::default(),
                parsed_function.attributes.clone(),
                parsed_function
                    .generic_params
                    .iter()
                    .map(|p| p.name.clone())
                    .collect::<Vec<_>>()
                    .into_boxed_slice(),
                std::collections::HashMap::new(),
            );
            function.file_id = file_id;
            let flags = determine_function_flags(&function, &parsed_function.prefixes)?;
            function.set_flags(flags);
            if function.attributes.iter().any(|x| x.name_equals("no_lazy")) {
                function.increment_usage();
            }

            ctx.symbols.insert_function(full_path, function);
        }

        for (impl_env_path, file_id, parsed_impl) in implementations {
            let for_type = CompilerType::from_parser_type(
                &parsed_impl.implementing_for,
                &ctx.symbols,
                &impl_env_path,
            )?;
            let for_type_id = match &for_type {
                CompilerType::Struct(id) => *id,
                _ => {
                    return Err(CompilerError::Generic(format!(
                        "impl target must be a struct type, got {:?}",
                        for_type
                    ))
                    .into())
                }
            };
            let for_type_path = ctx.symbols.get_type_by_id(for_type_id).full_path().clone();

            let mut self_alias = ctx.symbols.alias_types().clone();
            self_alias.insert("Self".to_string(), for_type.clone());
            ctx.symbols.set_alias_types(self_alias);

            let trait_id_opt = if let Some(trait_type) = &parsed_impl.trait_name {
                let trait_path_str = match trait_type.as_ref() {
                    rcsharp_parser::parser::ParserType::Named(name) => name.clone(),
                    other => format!("{}", other),
                };
                let rel_path = ContextPathEnd::from_path("", &trait_path_str);
                let abs_path = rel_path.with_start(&impl_env_path);
                ctx.symbols
                    .get_trait_id_by_path(&abs_path)
                    .or_else(|| ctx.symbols.get_trait_id_by_path(&rel_path))
            } else {
                None
            };

            let mut method_fn_ids: HashMap<Box<str>, usize> = HashMap::new();
            for stmt in parsed_impl.body.iter() {
                if let Stmt::Function(func_def) = &stmt.stmt {
                    let return_type = CompilerType::from_parser_type(
                        &func_def.return_type,
                        &ctx.symbols,
                        &impl_env_path,
                    )?;
                    let mut args_vec = Vec::with_capacity(func_def.args.len());
                    for (name, type_expr) in func_def.args.iter() {
                        let arg_type = CompilerType::from_parser_type(
                            type_expr,
                            &ctx.symbols,
                            &impl_env_path,
                        )?;
                        args_vec.push((name.clone(), arg_type));
                    }
                    let method_path = if trait_id_opt.is_some() {
                        let trait_name = parsed_impl.trait_name.as_ref().unwrap();
                        let trait_name_str = match trait_name.as_ref() {
                            rcsharp_parser::parser::ParserType::Named(n) => n.clone(),
                            other => format!("{}", other),
                        };
                        ContextPathEnd::from_full_path(&format!(
                            "{}.{}.{}",
                            trait_name_str,
                            for_type_path.to_string(),
                            func_def.name
                        ))
                    } else {
                        ContextPathEnd::from_full_path(&format!(
                            "{}.{}",
                            for_type_path.to_string(),
                            func_def.name
                        ))
                    };

                    let mut function = Function::new(
                        ContextPathEnd::default(),
                        args_vec.into_boxed_slice(),
                        return_type,
                        func_def.body.clone(),
                        FunctionFlags::default(),
                        func_def.attributes.clone(),
                        func_def
                            .generic_params
                            .iter()
                            .map(|p| p.name.clone())
                            .collect::<Vec<_>>()
                            .into_boxed_slice(),
                        std::collections::HashMap::new(),
                    );
                    function.file_id = file_id;
                    ctx.symbols.insert_function(method_path.clone(), function);
                    let fn_id = ctx.symbols.get_function_id_by_path(&method_path).unwrap();
                    method_fn_ids.insert(func_def.name.clone(), fn_id);
                }
            }

            if let Some(trait_id) = trait_id_opt {
                {
                    let trait_def = ctx.symbols.get_trait_by_id(trait_id);
                    for required_method in trait_def.methods.iter() {
                        if !method_fn_ids.contains_key(&required_method.name) {
                            return Err(CompilerError::Generic(format!(
                                "impl is missing required trait method '{}'",
                                required_method.name
                            ))
                            .into());
                        }
                    }
                }
                ctx.symbols.push_trait_impl(CompiledTraitImpl {
                    trait_id,
                    for_type_id,
                    method_fn_ids,
                });
            }
            ctx.symbols
                .set_alias_types(std::collections::HashMap::new());
        }

        Ok(())
    }
}
fn type_check_function_body(
    body: &[StmtData],
    return_type: &CompilerType,
    _args: &[(String, CompilerType)],
    ctx: &mut CompilerContext,
) -> Option<Box<[StmtData]>> {
    let mut new_body = None;
    if return_type.is_void() {
        if body
            .last()
            .map(|x| matches!(x.stmt, Stmt::Return(..)))
            .unwrap_or(false)
        {
            let mut x = new_body.unwrap_or(body.to_vec());
            while x
                .last()
                .map(|x| matches!(x.stmt, Stmt::Return(..)))
                .unwrap_or(false)
            {
                let r = x.remove(x.len() - 1);
                if !matches!(r.stmt, Stmt::Return(None)) {
                    ctx.diagnostics.push((
                        ErrorSeverity::Error,
                        CompilerError::Generic(format!(
                            "TCFB: Trying to return something in void function"
                        )),
                    ));
                } else {
                    ctx.diagnostics.push((
                        ErrorSeverity::Warning,
                        CompilerError::Generic(format!(
                            "TCFB: Unnecesary return {}:{}",
                            r.span.start, r.span.end
                        )),
                    ));
                }
            }
            new_body = Some(x)
        }
    }

    if let Some(x) = new_body {
        Some(x.into_boxed_slice())
    } else {
        None
    }
}
fn determine_function_flags(
    function: &Function,
    prefixes: &[String],
) -> CompileResult<FunctionFlags> {
    let mut flags = function.get_flags();

    for prefix in prefixes {
        match prefix.as_str() {
            "public" => flags.is_public = true,
            "inline" => flags.is_inline = true,
            "constexpr" => flags.is_const_expression = true,
            "extern" => flags.is_external = true,
            "no_return" => {
                if !function.return_type.is_void() {
                    return Err(CompilerError::Generic(format!(
                        "Function '{}' is marked as no_return but has a non-void return type",
                        function.full_path().to_string()
                    ))
                    .into());
                }
                flags.is_program_halt = true;
            }
            _ => {}
        }
    }

    if function
        .attributes
        .iter()
        .any(|x| x.name_equals("DllImport"))
    {
        flags.is_external = true;
    }

    if !function.generic_params.is_empty() {
        flags.is_generic = true;
    }

    Ok(flags)
}
