use std::{
    cell::{Cell, RefCell},
    collections::HashMap,
};

use rcsharp_parser::{
    compiler_primitives::BOOL_TYPE,
    expression_parser::Expr,
    parser::{ParserType, Span, Stmt, StmtData},
};

use crate::{
    compiler::{
        context::CompilerContext,
        expression::{
            compile_expression, ExpressionCompileResult, ExpressionCompiler, LValueAccess,
        },
        passes::traits::CompilerPass,
        structs::{CompiledValue, ContextPath, ContextPathEnd, Expected, LLVMInstruction},
    },
    compiler_essentials::{
        CompileResult, CompilerError, CompilerType, LLVMOutputHandler, LLVMVal, Scope, Variable,
    },
};

#[derive(Default)]
pub struct LLVMGenPass {
    pub cgctx: CodeGenContext,
    span: Span,
}
impl<'a> CompilerPass<'a> for LLVMGenPass {
    type Input = ();

    type Output = String;

    fn run(
        &mut self,
        _input: Self::Input,
        ctx: &mut CompilerContext,
    ) -> CompileResult<Self::Output> {
        if ctx.config.no_lazy_compile {
            for x in ctx.symbols.functions_iter() {
                x.1.increment_usage();
            }
        }
        let mut builder = LLVMOutputHandler::default();
        self.emit_static_vars(&mut builder, ctx)?;
        self.compile_functions(&mut builder, ctx)?;
        self.emit_types(&mut builder, ctx)?;
        self.emit_external(&mut builder, ctx)?;
        self.emit_debug_info(&mut builder, ctx)?;
        return Ok(builder.build(ctx.strings_header.take()));
    }
}
impl LLVMGenPass {
    pub fn new(cgctx: CodeGenContext, span: Span) -> Self {
        Self { cgctx, span }
    }

    fn emit_external(
        &mut self,
        builder: &mut LLVMOutputHandler,
        ctx: &mut CompilerContext,
    ) -> CompileResult<()> {
        for x in ctx
            .symbols
            .functions_iter()
            .filter(|x| x.1.is_external() && x.1.usage_count.get() >= 1)
        {
            let func = &x.1;
            let return_llvm = func.return_type.llvm_representation(&ctx.symbols)?;
            let name_llvm = func.name();
            let args_llvm = func
                .args
                .iter()
                .map(|(name, ptype)| {
                    ptype
                        .llvm_representation(&ctx.symbols)
                        .map(|x| format!("{} %{}", x, name))
                })
                .collect::<ExpressionCompileResult<Vec<_>>>()?
                .join(", ");
            builder.push_header(&format!(
                "declare dllimport {} @{}({})\n",
                return_llvm, name_llvm, args_llvm
            ));
        }
        Ok(())
    }
    fn emit_debug_info(
        &mut self,
        builder: &mut LLVMOutputHandler,
        ctx: &mut CompilerContext,
    ) -> CompileResult<()> {
        for x in ctx
            .symbols
            .functions_iter()
            .filter(|x| !x.1.is_external() && x.1.usage_count.get() > 0)
        {
            builder.push_footer(&format!(
                ";func {} {:?}\n",
                x.0.to_string(),
                x.1.attributes
                    .iter()
                    .map(|x| x.name.to_string())
                    .collect::<Vec<_>>()
            ));
        }
        for x in ctx.symbols.types_iter().filter(|x| {
            (x.1.is_generic() && !x.1.generic_implementations.borrow().is_empty())
                || (!x.1.is_generic())
        }) {
            builder.push_footer(&format!(";type {}\n", x.0.to_string()));
        }
        Ok(())
    }
    fn emit_static_vars(
        &mut self,
        builder: &mut LLVMOutputHandler,
        ctx: &mut CompilerContext,
    ) -> CompileResult<()> {
        for (path, var) in ctx.symbols.static_vars_iter() {
            builder.push_global_variables(&format!(
                "@{} = internal global {} zeroinitializer\n",
                path.to_string(),
                var.compiler_type().llvm_representation(&ctx.symbols)?
            ));
        }
        Ok(())
    }
    fn emit_types(
        &mut self,
        builder: &mut LLVMOutputHandler,
        ctx: &mut CompilerContext,
    ) -> CompileResult<()> {
        for (path, r#type) in ctx.symbols.types_iter().filter(|x| !x.1.is_generic()) {
            let field_types = r#type
                .fields
                .iter()
                .map(|(_field_name, field_type)| field_type.llvm_representation(&ctx.symbols))
                .collect::<ExpressionCompileResult<Vec<_>>>()?
                .join(", ");
            builder.push_header(&format!(
                "%struct.{} = type {{ {} }}\n",
                path.to_string(),
                field_types
            ));
        }
        let mut done = HashMap::new();
        loop {
            let mut new = false;
            for (full_path, r#type) in ctx.symbols.types_iter().filter(|x| x.1.is_generic()) {
                let imps_len = { r#type.generic_implementations.borrow().len() };
                if imps_len == 0 {
                    continue;
                }
                let index = ctx
                    .symbols
                    .types_iter()
                    .position(|x| x.0 == full_path)
                    .unwrap();

                if done.get(&index).filter(|x| **x == imps_len).is_some() {
                    continue;
                }
                let from_index = done.insert(index, imps_len).unwrap_or(0);
                for ind in from_index..imps_len {
                    new = true;
                    let name = r#type.llvm_repr_index(ind, &ctx.symbols);
                    let implementation = { r#type.generic_implementations.borrow()[ind].clone() };
                    let mut type_map = HashMap::new();
                    for (idx, prm) in r#type.generic_params.iter().enumerate() {
                        if let Some(concrete_type) = implementation.get(idx) {
                            type_map.insert(prm.clone(), concrete_type.clone());
                        }
                    }
                    let fields_string = r#type
                        .fields
                        .iter()
                        .map(|x| {
                            x.1.with_substituted_generics(&type_map, &ctx.symbols)
                                .map(|x| x.llvm_representation(&ctx.symbols))
                                .flatten()
                        })
                        .collect::<ExpressionCompileResult<Vec<_>>>()?
                        .join(", ");
                    builder.push_header(&format!("{} = type {{ {} }}\n", name, fields_string));
                }
            }
            if !new {
                break;
            }
        }
        Ok(())
    }

    fn compile_functions(
        &mut self,
        builder: &mut LLVMOutputHandler,
        ctx: &mut CompilerContext,
    ) -> CompileResult<()> {
        let Some(main) = ctx
            .symbols
            .get_function_id_by_path(&ContextPathEnd::from_path("", "main"))
        else {
            return Err(CompilerError::Generic(format!("Function 'main' was not found!")).into());
        };
        let mut to_do = vec![main];
        let mut done = vec![];

        let mut done_generics = HashMap::new();
        let mut to_do_generics = vec![];
        loop {
            while let Some(c_id) = to_do.pop() {
                self.compile_function(c_id, builder, ctx)?;
                done.push(c_id);
                if !to_do.is_empty() {
                    continue;
                }
                for (path, _) in ctx.symbols.functions_iter().filter(|x| {
                    x.1.usage_count.get() != 0
                        && !x.1.is_generic()
                        && !x.1.is_external()
                        && !x.1.is_inline()
                }) {
                    let index = ctx
                        .symbols
                        .functions_iter()
                        .position(|x| x.0 == path)
                        .unwrap();
                    if done.iter().any(|x| *x == index) {
                        continue;
                    }
                    to_do.push(index);
                }
            }
            let mut new = false;
            for (path, func) in ctx.symbols.functions_iter().filter(|x| {
                x.1.usage_count.get() != 0
                    && x.1.is_generic()
                    && !x.1.is_external()
                    && !x.1.is_inline()
            }) {
                let imps_len = { func.generic_implementations.borrow().len() };
                if imps_len == 0 {
                    continue;
                }
                let index = ctx
                    .symbols
                    .functions_iter()
                    .position(|x| x.0 == path)
                    .unwrap();
                if done_generics
                    .get(&index)
                    .filter(|x| **x == imps_len)
                    .is_some()
                {
                    continue;
                }
                let from_index = done_generics.insert(index, imps_len).unwrap_or(0);
                for ind in from_index..imps_len {
                    new = true;
                    let implementation = { func.generic_implementations.borrow()[ind].clone() };
                    let mut type_map = HashMap::new();
                    for (idx, prm) in func.generic_params.iter().enumerate() {
                        if let Some(concrete_type) = implementation.get(idx) {
                            type_map.insert(prm.clone(), concrete_type.clone());
                        }
                    }
                    let mut return_type = func.return_type.clone();
                    return_type.substitute_generics(&type_map, &ctx.symbols)?;

                    let args = func
                        .args
                        .iter()
                        .map(|(name, ptype)| {
                            ptype
                                .with_substituted_generics(&type_map, &ctx.symbols)
                                .map(|x| (name.clone(), x))
                        })
                        .collect::<ExpressionCompileResult<Vec<_>>>()?;
                    to_do_generics.push((
                        type_map,
                        func.path().clone(),
                        func.get_implementation_name(ind, &ctx.symbols),
                        return_type,
                        args,
                        func.body.to_vec(),
                    ));
                }
            }
            while let Some((type_map, function_path, full_function_name, return_type, args, body)) =
                to_do_generics.pop()
            {
                ctx.symbols.set_alias_types(type_map);
                self.compile_function_base(
                    function_path,
                    &full_function_name,
                    return_type,
                    args,
                    &body.into_boxed_slice(),
                    builder,
                    ctx,
                )?;
            }
            for (path, _) in ctx.symbols.functions_iter().filter(|x| {
                x.1.usage_count.get() != 0
                    && !x.1.is_generic()
                    && !x.1.is_external()
                    && !x.1.is_inline()
            }) {
                let index = ctx
                    .symbols
                    .functions_iter()
                    .position(|x| x.0 == path)
                    .unwrap();
                if done.iter().any(|x| *x == index) {
                    continue;
                }
                new = true;
                to_do.push(index);
            }
            if !new {
                break;
            }
        }
        Ok(())
    }
    fn compile_function(
        &mut self,
        function_id: usize,
        builder: &mut LLVMOutputHandler,
        ctx: &mut CompilerContext,
    ) -> CompileResult<()> {
        let (full_function_name, path, return_type, args, body) = {
            let function = ctx.symbols.get_function_by_id_use(function_id);
            assert!(!function.is_generic());

            let full_function_name = function.full_path().to_string();

            let mut return_type = function.return_type.clone();
            return_type.substitute_generics(&ctx.symbols.alias_types(), &ctx.symbols)?;

            let args = function
                .args
                .iter()
                .map(|(name, ptype)| {
                    ptype
                        .with_substituted_generics(&ctx.symbols.alias_types(), &ctx.symbols)
                        .map(|x| (name.clone(), x))
                })
                .collect::<ExpressionCompileResult<Vec<_>>>()?;

            let body = function.body.clone();
            (
                full_function_name,
                function.path().clone(),
                return_type,
                args,
                body,
            )
        };
        match self.compile_function_base(
            path,
            &full_function_name,
            return_type,
            args,
            &body,
            builder,
            ctx,
        ) {
            Ok(_) => {}
            Err(mut err) => {
                err.function_id = function_id;
                return Err(err);
            }
        }
        Ok(())
    }
    fn compile_function_base(
        &mut self,
        function_path: ContextPath,
        full_function_name: &str,
        return_type: CompilerType,
        args: Vec<(String, CompilerType)>,
        body: &Box<[StmtData]>,
        builder: &mut LLVMOutputHandler,
        ctx: &mut CompilerContext,
    ) -> CompileResult<Vec<LLVMInstruction>> {
        let symbols = &ctx.symbols;
        let return_type_llvm = return_type.llvm_representation(symbols)?;

        let args_str = args
            .iter()
            .map(|(name, ptype)| {
                ptype
                    .llvm_representation(symbols)
                    .map(|type_str| format!("{} %{}", type_str, name))
            })
            .collect::<ExpressionCompileResult<Vec<_>>>()?
            .join(", ");
        let mut instructions = vec![];
        builder.start_function(&return_type_llvm, full_function_name, &args_str);
        instructions.push(LLVMInstruction::Label {
            name: format!("entry"),
        });
        self.cgctx.scope = Scope::new();
        self.cgctx.current_function_path = function_path;
        self.cgctx.current_function_return_type = return_type.clone();
        self.cgctx.var_counter.set(0);
        self.cgctx.temp_counter.set(0);
        self.cgctx.label_counter.set(0);
        self.cgctx.scope.push_layer();
        self.cgctx.set_current_block_name("entry".to_string());
        self.cgctx.pending_returns = Vec::new();
        self.cgctx.return_label_name = "func_exit".to_string();

        for (arg_name, arg_type) in args.iter() {
            if self.cgctx.scope.lookup(arg_name).is_some() {
                return Err(CompilerError::Generic(format!(
                    "You declared argument '{}' twice",
                    arg_name
                ))
                .into());
            }
            let mut arg_type = arg_type.clone();
            arg_type.substitute_generics(&symbols.alias_types(), symbols)?;
            let var = Variable::new(arg_type, true, false);
            var.set_constant_value(Some(LLVMVal::VariableName(arg_name.clone())));
            (self
                .cgctx
                .scope
                .define(arg_name.clone(), var, 0, symbols)
                .len()
                == 0)
                .then_some(())
                .expect("Should not");
        }
        let fx = body.clone();
        for stmt in fx.iter() {
            match self.compile_statement(stmt, ctx) {
                Ok((mut x, s)) => {
                    instructions.append(&mut x);
                    if s {
                        break;
                    }
                }
                Err(mut x) => {
                    x.call_stack.push((0..0, full_function_name.to_string()));
                    return Err(x);
                }
            }
        }
        if return_type.is_void() {
            instructions.push(LLVMInstruction::Jump {
                label: self.cgctx.return_label_name.to_string(),
            });
            instructions.push(LLVMInstruction::Label {
                name: self.cgctx.return_label_name.to_string(),
            });
        } else if self.cgctx.pending_returns.is_empty() {
            instructions.push(LLVMInstruction::Unreachable);
        } else {
            instructions.push(LLVMInstruction::Label {
                name: self.cgctx.return_label_name.to_string(),
            });
        }
        instructions.append(&mut self.cgctx.scope.pop_layer(&mut ctx.symbols));
        if return_type.is_void() {
            instructions.push(LLVMInstruction::ReturnVoid);
        } else {
            if self.cgctx.pending_returns.is_empty() {
            } else {
                if self.cgctx.pending_returns.len() > 1 {
                    let phi_ops = self
                        .cgctx
                        .pending_returns
                        .iter()
                        .cloned()
                        .collect::<Vec<_>>();
                    let utvc = self.cgctx.acquire_temp_id();
                    instructions.push(LLVMInstruction::Phi {
                        target_reg: utvc,
                        result_type: return_type.clone(),
                        incoming: phi_ops,
                    });
                    instructions.push(LLVMInstruction::Return {
                        return_type: return_type.clone(),
                        value: LLVMVal::Register(utvc),
                    });
                } else {
                    instructions.push(LLVMInstruction::Return {
                        return_type: return_type.clone(),
                        value: self.cgctx.pending_returns[0].0.clone(),
                    });
                }
            }
        }
        Self::compile_instructions(instructions, ctx, builder)?;
        builder.end_function();
        Ok(vec![])
    }
    pub fn compile_statement(
        &mut self,
        statement: &StmtData,
        ctx: &CompilerContext,
    ) -> CompileResult<(Vec<LLVMInstruction>, bool)> {
        self.span = statement.span.clone();
        match &statement.stmt {
            Stmt::Debug(comment) => Ok((vec![LLVMInstruction::Debug(comment.to_string())], false)),
            Stmt::If(x, y, z) => self.compile_if_statement(x, y, z, ctx),
            Stmt::Block(x) => self.compile_block(x, ctx),
            Stmt::Return(x) => self.compile_return(x, ctx),
            Stmt::Expr(x) => match compile_expression(x, Expected::NoReturn, &self.cgctx, ctx) {
                Ok(val) => {
                    return Ok((val.1, val.0.is_program_halt()));
                }
                Err(err) => {
                    let mut x: crate::compiler_essentials::CompilerErrorWrapper = err.into();
                    x.call_stack
                        .push((statement.span.clone(), format!("expression")));
                    return Err(x);
                }
            },
            Stmt::ConstLet(name, var_type, z) => {
                self.compile_var_decl((name, var_type, &Some(z.clone()), true, false), ctx)
            }
            Stmt::Static(name, var_type, z) => {
                self.compile_var_decl((name, var_type, z, false, true), ctx)
            }

            Stmt::Let(name, var_type, z) => {
                self.compile_var_decl((name, var_type, z, false, false), ctx)
            }
            Stmt::Loop(inside) => self.compile_loop(inside, ctx),
            Stmt::Continue => match self.cgctx.scope.current_loop_tag() {
                Some(li) => {
                    return Ok((
                        vec![LLVMInstruction::Jump {
                            label: format!("loop_body{}", li),
                        }],
                        true,
                    ));
                }
                None => {
                    return Err((
                        self.span.clone(),
                        CompilerError::Generic("Tried to continue without loop".to_string()),
                    )
                        .into())
                }
            },
            Stmt::Break => match self.cgctx.scope.current_loop_tag() {
                Some(li) => {
                    return Ok((
                        vec![LLVMInstruction::Jump {
                            label: format!("loop_body{}_exit", li),
                        }],
                        true,
                    ));
                }
                None => {
                    return Err((
                        self.span.clone(),
                        CompilerError::Generic("Tried to break without loop".to_string()),
                    )
                        .into())
                }
            },
            Stmt::CompilerHint(..) => panic!(),
            Stmt::CompilerDud => Ok((Vec::new(), false)),
            _ => unimplemented!("{:?}", statement),
        }
    }
    fn compile_if_statement(
        &mut self,
        expr: &Expr,
        r#then: &[StmtData],
        r#else: &[StmtData],
        ctx: &CompilerContext,
    ) -> CompileResult<(Vec<LLVMInstruction>, bool)> {
        let bool_type = CompilerType::Primitive(BOOL_TYPE);
        if r#then.is_empty() && r#else.is_empty() {
            compile_expression(expr, Expected::Type(&bool_type), &self.cgctx, ctx)?;
            return Ok((Vec::new(), false));
        }
        let (cond_result, mut instr) =
            compile_expression(expr, Expected::Type(&bool_type), &self.cgctx, ctx)?;
        let Some(cond_val_type) = cond_result.get_type() else {
            return Err(
                CompilerError::Generic("Right side of if condition is not value".into()).into(),
            );
        };
        if *cond_val_type != bool_type {
            return Err((
                self.span.clone(),
                CompilerError::Generic(format!(
                    "'{:?}' must result in bool, instead resulted in {:?}",
                    expr.debug_emit(),
                    cond_val_type
                )),
            )
                .into());
        }
        let logic_id = self.cgctx.acquire_label_id();
        let then_label = format!("then{}", logic_id);
        let else_label = format!("else{}", logic_id);
        let end_label = format!("endif{}", logic_id);
        let target_then = if r#then.is_empty() {
            &end_label
        } else {
            &then_label
        };
        let target_else = if r#else.is_empty() {
            &end_label
        } else {
            &else_label
        };
        instr.push(LLVMInstruction::Branch {
            condition_val: cond_result.get_llvm_rep().clone(),
            then_label_name: target_then.to_string(),
            else_label_name: target_else.to_string(),
        });
        if !r#then.is_empty() {
            instr.push(LLVMInstruction::Label {
                name: then_label.to_string(),
            });
            self.cgctx.set_current_block_name(then_label.to_string());
            self.cgctx.scope.push_layer();
            for then_stmt in then {
                let (mut s_instructions, end_compile) = self.compile_statement(then_stmt, ctx)?;
                instr.append(&mut s_instructions);
                if end_compile {
                    break;
                };
            }
            instr.append(&mut self.cgctx.scope.pop_layer(&ctx.symbols));
            if then
                .last()
                .map(|x| !matches!(x.stmt, Stmt::Return(..) | Stmt::Break | Stmt::Continue))
                .unwrap_or(false)
            {
                instr.push(LLVMInstruction::Jump {
                    label: end_label.to_string(),
                });
            }
        }

        if !r#else.is_empty() {
            instr.push(LLVMInstruction::Label {
                name: else_label.to_string(),
            });
            self.cgctx.set_current_block_name(else_label.to_string());
            self.cgctx.scope.push_layer();
            for then_stmt in r#else {
                let (mut s_instructions, end_compile) = self.compile_statement(then_stmt, ctx)?;
                instr.append(&mut s_instructions);
                if end_compile {
                    break;
                };
            }
            instr.append(&mut self.cgctx.scope.pop_layer(&ctx.symbols));
        }
        if r#else
            .last()
            .map(|x| !matches!(x.stmt, Stmt::Return(..) | Stmt::Break | Stmt::Continue))
            .unwrap_or(false)
        {
            instr.push(LLVMInstruction::Jump {
                label: end_label.to_string(),
            });
        }
        instr.push(LLVMInstruction::Label {
            name: end_label.to_string(),
        });
        self.cgctx.set_current_block_name(end_label.to_string());
        Ok((instr, false))
    }
    fn compile_return(
        &mut self,
        expr: &Option<Expr>,
        ctx: &CompilerContext,
    ) -> CompileResult<(Vec<LLVMInstruction>, bool)> {
        let return_type = self.cgctx.current_function_return_type.clone();
        match (expr.is_some(), !return_type.is_void()) {
            (true, true) => {
                let expr = expr.as_ref().unwrap();
                let (result, mut instr) =
                    compile_expression(expr, Expected::Type(&return_type), &self.cgctx, ctx)?;
                if !result.equal_type(&return_type) {
                    return Err(CompilerError::Generic(format!("TypeMismatch")).into());
                }

                self.cgctx.push_return(result.get_llvm_rep().clone());
                instr.push(LLVMInstruction::Jump {
                    label: self.cgctx.return_label_name.to_string(),
                });
                return Ok((instr, true));
            }
            (false, false) => {
                return Ok((
                    vec![LLVMInstruction::Jump {
                        label: self.cgctx.return_label_name.to_string(),
                    }],
                    true,
                ));
            }
            (true, false) => {
                return Err((
                    self.span.clone(),
                    CompilerError::Generic(format!(
                        "Function {} does not return anything, but got expression:{}",
                        self.cgctx.current_function_path.to_string(),
                        expr.as_ref().unwrap().debug_emit()
                    )),
                )
                    .into());
            }
            (false, true) => {
                return Err((
                    self.span.clone(),
                    CompilerError::Generic(
                        "Cannot return without a value from a non-void function.".to_string(),
                    ),
                )
                    .into());
            }
        }
    }
    fn compile_var_decl(
        &mut self,
        var: (&String, &ParserType, &Option<Expr>, bool, bool),
        ctx: &CompilerContext,
    ) -> CompileResult<(Vec<LLVMInstruction>, bool)> {
        let (name, p_type, expr, is_const, is_static) = var;
        let var_type = CompilerType::from_parser_type(
            p_type,
            &ctx.symbols,
            &self.cgctx.current_function_path,
        )?;
        let variable = Variable::new(var_type.clone(), is_const, is_static);
        let mut instructions = Vec::new();
        let id = if !is_const && !is_static {
            let x = self.cgctx.acquire_var_id();
            instructions.push(LLVMInstruction::AllocateVar {
                target_reg: x,
                alloc_type: var_type.clone(),
            });
            x
        } else {
            0
        };

        let Some(expression) = expr else {
            instructions.append(&mut self.cgctx.scope.define(
                name.clone(),
                variable,
                id,
                &ctx.symbols,
            ));
            return Ok((instructions, false));
        };
        let (result, mut instr) = compile_expression(
            expression,
            Expected::Type(&variable.compiler_type()),
            &self.cgctx,
            ctx,
        )?;
        if !result.equal_type(&variable.compiler_type()) {
            let Some(_result_type) = result.get_type() else {
                return Err(CompilerError::Generic(
                    "Right side of const let is not a value".into(),
                )
                .into());
            };
            eprintln!("{}", expression.debug_emit());
            return Err((
                self.span.clone(),
                CompilerError::Generic(format!(
                    "Type missmatch {:?} vs {:?}",
                    result.get_type().unwrap(),
                    variable.compiler_type()
                )),
            )
                .into());
        }
        instructions.append(&mut instr);
        if result
            .get_type()
            .map(|x| !x.as_primitive().is_some() && !x.is_pointer())
            .unwrap_or(false)
        {
            if let CompiledValue::StructValue { fields, val_type } = result {
                let CompilerType::Struct(x) = val_type else {
                    let CompilerType::GenericStructInstance(tid, y) = val_type else {
                        todo!();
                    };
                    let mut type_map = HashMap::new();
                    let q = ctx
                        .symbols
                        .get_type_by_id(tid)
                        .generic_implementations
                        .borrow();
                    for (idx, x) in ctx
                        .symbols
                        .get_type_by_id(tid)
                        .generic_params
                        .iter()
                        .enumerate()
                    {
                        type_map.insert(x.clone(), (q[y][idx]).clone());
                    }
                    drop(q);
                    instructions.append(&mut self.cgctx.scope.define(
                        name.clone(),
                        variable,
                        id,
                        &ctx.symbols,
                    ));
                    let f = ctx.symbols.get_type_by_id(tid).fields.clone();
                    for (x, expr) in f.iter().zip(fields.iter()) {
                        let ec = ExpressionCompiler::new(&mut self.cgctx, ctx);
                        let (t, mut instruc) = ec.compile_lvalue(
                            &Expr::MemberAccess(Box::new(Expr::Name(name.clone())), x.0.clone()),
                            LValueAccess::ModifyContent,
                        )?;
                        instruc.push(LLVMInstruction::Store {
                            value: expr.clone(),
                            value_type: t.value_type,
                            ptr: t.location,
                        });
                        instructions.append(&mut instruc);
                    }
                    return Ok((instructions, false));
                };
                instructions.append(&mut self.cgctx.scope.define(
                    name.clone(),
                    variable,
                    id,
                    &ctx.symbols,
                ));
                let f = ctx.symbols.get_type_by_id(x).fields.clone();
                for (x, expr) in f.iter().zip(fields.iter()) {
                    let ec = ExpressionCompiler::new(&mut self.cgctx, ctx);
                    let (t, mut instruc) = ec.compile_lvalue(
                        &Expr::MemberAccess(Box::new(Expr::Name(name.clone())), x.0.clone()),
                        LValueAccess::ModifyContent,
                    )?;
                    instruc.push(LLVMInstruction::Store {
                        value: expr.clone(),
                        value_type: t.value_type,
                        ptr: t.location,
                    });
                    instructions.append(&mut instruc);
                }
                return Ok((instructions, false));
            }
        }
        if is_const {
            variable.set_constant_value(Some(result.get_llvm_rep().clone()));
            instructions.append(&mut self.cgctx.scope.define(
                name.clone(),
                variable,
                id,
                &ctx.symbols,
            ));
            return Ok((instructions, false));
        }
        instructions.append(
            &mut self
                .cgctx
                .scope
                .define(name.clone(), variable, id, &ctx.symbols),
        );
        instructions.push(LLVMInstruction::Store {
            value: result.get_llvm_rep().clone(),
            value_type: var_type,
            ptr: LLVMVal::Variable(id),
        });
        Ok((instructions, false))
    }
    fn compile_loop(
        &mut self,
        inside: &[StmtData],
        ctx: &CompilerContext,
    ) -> CompileResult<(Vec<LLVMInstruction>, bool)> {
        let lc = self.cgctx.acquire_label_id();
        let mut instructions = vec![
            LLVMInstruction::Jump {
                label: format!("loop_body{}", lc),
            },
            LLVMInstruction::Label {
                name: format!("loop_body{}", lc),
            },
        ];
        self.cgctx.scope.push_layer();
        self.cgctx.scope.set_loop_tag(Some(lc));
        self.cgctx
            .set_current_block_name(format!("loop_body{}", lc));
        let mut terminated = false;
        for x in inside {
            let (mut instr, brk) = self.compile_statement(x, ctx)?;
            instructions.append(&mut instr);
            if brk {
                terminated = true;
                break;
            }
        }
        if !terminated {
            instructions.push(LLVMInstruction::Jump {
                label: format!("loop_body{}", lc),
            });
        }
        instructions.push(LLVMInstruction::Label {
            name: format!("loop_body{}_exit", lc),
        });

        self.cgctx
            .set_current_block_name(format!("loop_body{}_exit", lc));
        instructions.append(&mut self.cgctx.scope.pop_layer(&ctx.symbols));
        Ok((instructions, false))
    }
    fn compile_block(
        &mut self,
        inside: &[StmtData],
        ctx: &CompilerContext,
    ) -> CompileResult<(Vec<LLVMInstruction>, bool)> {
        //let lc = self.cgctx.acquire_label_id();
        self.cgctx.scope.push_layer();
        let mut instructions = Vec::new();
        for x in inside {
            let (mut instr, brk) = self.compile_statement(x, ctx)?;
            instructions.append(&mut instr);
            if brk {
                break;
            }
        }

        instructions.append(&mut self.cgctx.scope.pop_layer(&ctx.symbols));
        Ok((instructions, false))
    }

    pub fn compile_instructions(
        vec: Vec<LLVMInstruction>,
        ctx: &mut CompilerContext,
        builder: &mut LLVMOutputHandler,
    ) -> CompileResult<()> {
        let vec =
            crate::compiler::passes::pass_optimizer::OptimizerPass::optimize_llvm_instructions(
                vec,
                &ctx.config,
            );
        for x in vec {
            match x {
                LLVMInstruction::AllocateVar {
                    target_reg,
                    alloc_type,
                } => {
                    let alloc_type_llvm = alloc_type.llvm_representation(&ctx.symbols)?;
                    builder.push_function_intro(&format!(
                        "\t%v{} = alloca {}\n",
                        target_reg, alloc_type_llvm,
                    ));
                }
                LLVMInstruction::AllocateStack {
                    target_reg,
                    alloc_type,
                    count_type,
                    count,
                } => {
                    let alloc_type_llvm = alloc_type.llvm_representation(&ctx.symbols)?;
                    let count_type_llvm = count_type.llvm_representation(&ctx.symbols)?;
                    builder.push_function_body(&format!(
                        "\t%tmp{} = alloca {}, {} {}\n",
                        target_reg,
                        alloc_type_llvm,
                        count_type_llvm,
                        count.to_string()
                    ));
                }
                LLVMInstruction::Cast {
                    target_reg,
                    op,
                    from_type,
                    from_val,
                    to_type,
                } => {
                    let from_type_llvm = from_type.llvm_representation(&ctx.symbols)?;
                    let to_type_llvm = to_type.llvm_representation(&ctx.symbols)?;
                    builder.push_function_body(&format!(
                        "\t%tmp{} = {} {} {} to {}\n",
                        target_reg,
                        op,
                        from_type_llvm,
                        from_val.to_string(),
                        to_type_llvm,
                    ));
                }
                LLVMInstruction::BinaryOp {
                    target_reg,
                    op,
                    op_type,
                    lhs,
                    rhs,
                } => {
                    let op_type_llvm = if op_type.is_pointer() {
                        op_type.llvm_representation(&ctx.symbols)?;
                        "ptr".to_string()
                    } else {
                        op_type.llvm_representation(&ctx.symbols)?
                    };
                    builder.push_function_body(&format!(
                        "\t%tmp{} = {} {} {}, {}\n",
                        target_reg,
                        op,
                        op_type_llvm,
                        lhs.to_string(),
                        rhs.to_string(),
                    ));
                }
                LLVMInstruction::Load {
                    target_reg,
                    ptr,
                    result_type,
                } => {
                    let result_type_llvm = result_type.llvm_representation(&ctx.symbols)?;
                    builder.push_function_body(&format!(
                        "\t%tmp{} = load {}, {}* {}\n",
                        target_reg,
                        result_type_llvm,
                        result_type_llvm,
                        ptr.to_string()
                    ));
                }
                LLVMInstruction::Phi {
                    target_reg,
                    result_type,
                    incoming,
                } => {
                    let result_type_llvm = result_type.llvm_representation(&ctx.symbols)?;
                    builder.push_function_body(&format!(
                        "\t%tmp{} = phi {} {}\n",
                        target_reg,
                        result_type_llvm,
                        incoming
                            .iter()
                            .map(|x| format!("[{}, %{}]", x.0.to_string(), x.1))
                            .collect::<Vec<_>>()
                            .join(", ")
                    ));
                }
                LLVMInstruction::GetElementPtr {
                    target_reg,
                    base_type,
                    ptr,
                    indices,
                } => {
                    let base_type_llvm = base_type.llvm_representation(&ctx.symbols)?;
                    let ind_llvm = indices
                        .iter()
                        .map(|x| {
                            x.1.llvm_representation(&ctx.symbols)
                                .map(|y| format!("{} {}", y, x.0.to_string()))
                        })
                        .collect::<ExpressionCompileResult<Vec<_>>>()?
                        .join(", ");
                    builder.push_function_body(&format!(
                        "\t%tmp{} = getelementptr inbounds {}, {}* {}, {}\n",
                        target_reg,
                        base_type_llvm,
                        base_type_llvm,
                        ptr.to_string(),
                        ind_llvm
                    ));
                }
                LLVMInstruction::GetElementPtrExt {
                    target_reg,
                    base_type,
                    result_type,
                    ptr,
                    indices,
                } => {
                    let base_type_llvm = base_type.llvm_representation(&ctx.symbols)?;
                    let result_type_llvm = result_type.llvm_representation(&ctx.symbols)?;
                    let ind_llvm = indices
                        .iter()
                        .map(|x| {
                            x.1.llvm_representation(&ctx.symbols)
                                .map(|y| format!("{} {}", y, x.0.to_string()))
                        })
                        .collect::<ExpressionCompileResult<Vec<_>>>()?
                        .join(", ");
                    builder.push_function_body(&format!(
                        "\t%tmp{} = getelementptr inbounds {}, {}* {}, {}\n",
                        target_reg,
                        result_type_llvm,
                        base_type_llvm,
                        ptr.to_string(),
                        ind_llvm
                    ));
                }
                LLVMInstruction::Call {
                    target_reg,
                    callee,
                    args,
                    result_type,
                } => {
                    let args_llvm = args
                        .iter()
                        .map(|x| {
                            x.1.llvm_representation(&ctx.symbols)
                                .map(|y| format!("{} {}", y, x.0.to_string()))
                        })
                        .collect::<ExpressionCompileResult<Vec<_>>>()?
                        .join(", ");
                    let result_type_llvm = result_type.llvm_representation(&ctx.symbols)?;
                    if let Some(target_reg) = target_reg {
                        builder.push_function_body(&format!(
                            "\t%tmp{} = call {} {}({})\n",
                            target_reg,
                            result_type_llvm,
                            callee.to_string(),
                            args_llvm,
                        ));
                    } else {
                        builder.push_function_body(&format!(
                            "\tcall {} {}({})\n",
                            result_type_llvm,
                            callee.to_string(),
                            args_llvm,
                        ));
                    }
                }
                LLVMInstruction::Store {
                    value,
                    value_type,
                    ptr,
                } => {
                    let result_type_llvm = value_type.llvm_representation(&ctx.symbols)?;
                    builder.push_function_body(&format!(
                        "\tstore {} {}, {}* {}\n",
                        result_type_llvm,
                        value.to_string(),
                        result_type_llvm,
                        ptr.to_string()
                    ));
                }
                LLVMInstruction::Jump { label } => {
                    builder.push_function_body(&format!("\tbr label %{}\n", label))
                }
                LLVMInstruction::Branch {
                    condition_val,
                    then_label_name,
                    else_label_name,
                } => builder.push_function_body(&format!(
                    "\tbr i1 {}, label %{}, label %{}\n",
                    condition_val.to_string(),
                    then_label_name,
                    else_label_name
                )),
                LLVMInstruction::Label { name } => {
                    if name == "entry" {
                        builder.push_function_intro("entry:\n")
                    } else {
                        builder.push_function_body(&format!("{}:\n", name))
                    }
                }
                LLVMInstruction::Return { return_type, value } => {
                    let return_type_llvm = return_type.llvm_representation(&ctx.symbols)?;
                    builder.push_function_body(&format!(
                        "\tret {} {}\n",
                        return_type_llvm,
                        value.to_string()
                    ))
                }
                LLVMInstruction::ReturnVoid => builder.push_function_body("\tret void\n"),
                LLVMInstruction::Debug(x) => builder.push_function_body(&format!("; {}\n", x)),
                LLVMInstruction::Unreachable => builder.push_function_body("\tunreachable\n"),
                //_ => builder.push_function_body(&format!("\t;{:?} DEBUG\n", x)),
            }
        }
        Ok(())
    }
}

#[derive(Default)]
pub struct CodeGenContext {
    pub scope: Scope,
    pub current_block_name: RefCell<String>,
    pub pending_returns: Vec<(LLVMVal, String)>,
    pub return_label_name: String,

    pub temp_counter: Cell<u32>,
    pub string_counter: Cell<u32>,
    pub var_counter: Cell<u32>,
    pub label_counter: Cell<u32>,

    pub current_function_return_type: CompilerType,
    pub current_function_path: ContextPath,
}
impl CodeGenContext {
    pub fn set_current_block_name(&self, name: String) {
        self.current_block_name.replace(name);
    }
    pub fn push_return(&mut self, val: LLVMVal) {
        self.pending_returns
            .push((val, self.current_block_name.borrow().clone()));
    }
    pub fn acquire_temp_id(&self) -> u32 {
        self.temp_counter.replace(self.temp_counter.get() + 1)
    }
    pub fn acquire_label_id(&self) -> u32 {
        self.label_counter.replace(self.label_counter.get() + 1)
    }
    pub fn acquire_var_id(&self) -> u32 {
        self.var_counter.replace(self.var_counter.get() + 1)
    }
}
