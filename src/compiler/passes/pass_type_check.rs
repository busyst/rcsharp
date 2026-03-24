use std::collections::HashMap;

use rcsharp_parser::{
    expression_parser::Expr,
    parser::{Stmt, StmtData},
};

use crate::{
    compiler::{
        context::{CompilerContext, ErrorSeverity, FileID},
        passes::{pass_optimizer::constant_expression_compiler, traits::CompilerPass},
        structs::{ContextPath, ContextPathEnd},
    },
    compiler_essentials::{
        CompileResult, CompilerError, CompilerType, Enum, Function, FunctionFlags, LLVMVal, Struct,
        Variable,
    },
};

#[derive(Default)]
pub struct TypeCheckPass {}
impl<'a> CompilerPass<'a> for TypeCheckPass {
    type Input = &'a HashMap<FileID, Vec<StmtData>>;

    type Output = ();

    fn run(
        &mut self,
        input: Self::Input,
        ctx: &mut CompilerContext,
    ) -> CompileResult<Self::Output> {
        let mut worklist = vec![];
        for x in input {
            worklist.push((ContextPath::default(), *x.0, x.1.to_vec()));
        }

        let mut types: Vec<(ContextPath, FileID, rcsharp_parser::parser::ParsedStruct)> = vec![];
        let mut enums: Vec<(ContextPath, FileID, rcsharp_parser::parser::ParsedEnum)> = vec![];
        let mut functions: Vec<(ContextPath, FileID, rcsharp_parser::parser::ParsedFunction)> =
            vec![];
        let mut static_variables: Vec<(
            ContextPath,
            FileID,
            (String, rcsharp_parser::parser::ParserType, Option<Expr>),
        )> = vec![];

        while let Some((path, file_id, body)) = worklist.pop() {
            for x in body {
                match x.stmt {
                    Stmt::Namespace(x, body) => {
                        let full_path = path.to_extended(&x);
                        worklist.push((full_path, file_id.clone(), body.to_vec()));
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
                    Stmt::Static(name, var_type, expression) => {
                        static_variables.push((
                            path.clone(),
                            file_id.clone(),
                            (name, var_type, expression),
                        ));
                    }
                    _ => {}
                }
            }
        }
        for (type_env_path, file_id, parsed_type) in types.iter() {
            let type_path =
                ContextPathEnd::from_context_path(type_env_path.clone(), &parsed_type.name);
            let mut x = Struct::new_placeholder();
            x.file_id = *file_id;
            ctx.symbols.insert_type(type_path, x);
        }
        for (type_env_path, file_id, struct_decl) in types {
            let mut new_alias_types = HashMap::new();
            for prm in &struct_decl.generic_params {
                new_alias_types.insert(
                    prm.clone(),
                    CompilerType::GenericPlaceholder(prm.to_string().into_boxed_str()),
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
                struct_decl.generic_params.clone(),
            );
            x.file_id = file_id;
            let type_path = ContextPathEnd::from_context_path(type_env_path, &struct_decl.name);
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

        for (current_path, _file_id, (name, var_type, _expression)) in static_variables {
            let t = CompilerType::from_parser_type(&var_type, &ctx.symbols, &current_path)?;
            let full_path = ContextPathEnd::from_context_path(current_path, &name);
            ctx.symbols
                .insert_static_var(full_path, Variable::new(t, false, true))?;
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
                0.into(),
                parsed_function.attributes.clone(),
                parsed_function.generic_params.clone(),
            );
            function.file_id = file_id;
            let flags = determine_function_flags(&function, &parsed_function.prefixes)?;
            function.set_flags(flags);
            if function.attributes.iter().any(|x| x.name_equals("no_lazy")) {
                function.increment_usage();
            }

            ctx.symbols.insert_function(full_path, function);
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
