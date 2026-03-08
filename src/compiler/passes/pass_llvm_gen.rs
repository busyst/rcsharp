use std::{cell::Cell, collections::HashMap};

use rcsharp_parser::{
    compiler_primitives::BOOL_TYPE,
    expression_parser::Expr,
    parser::{ParserType, Span, Stmt, StmtData},
};

use crate::{
    compiler::{
        context::CompilerContext,
        passes::traits::CompilerPass,
        structs::{ContextPath, ContextPathEnd},
    },
    compiler_essentials::{
        CompileResult, CompileResultExt, CompilerError, CompilerType, LLVMOutputHandler, LLVMVal,
        Scope, Variable,
    },
    expression_compiler::{compile_expression_v2, CompiledValue, Expected, ExpressionCompiler},
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
        return Ok(builder.build());
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
                .collect::<CompileResult<Vec<_>>>()?
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
                .collect::<CompileResult<Vec<_>>>()?
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
                        .collect::<CompileResult<Vec<_>>>()?
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
            for f in ctx.symbols.functions_iter() {
                println!("{}", f.0.to_string());
            }
            return Err(CompilerError::Generic(format!(
                "Function 'main' was not found! Dumped all function names"
            ))
            .into());
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
                        .collect::<CompileResult<Vec<_>>>()?;
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
                .collect::<CompileResult<Vec<_>>>()?;

            let body = function.body.clone();
            (
                full_function_name,
                function.path().clone(),
                return_type,
                args,
                body,
            )
        };
        self.compile_function_base(
            path,
            &full_function_name,
            return_type,
            args,
            &body,
            builder,
            ctx,
        )?;
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
    ) -> CompileResult<()> {
        let symbols = &ctx.symbols;
        let return_type_llvm = return_type.llvm_representation(symbols)?;

        let args_str = args
            .iter()
            .map(|(name, ptype)| {
                ptype
                    .llvm_representation(symbols)
                    .map(|type_str| format!("{} %{}", type_str, name))
            })
            .collect::<CompileResult<Vec<_>>>()?
            .join(", ");
        builder.start_function(&return_type_llvm, full_function_name, &args_str);
        builder.emit_label_intro("entry");
        self.cgctx.scope = Scope::new();
        self.cgctx.current_function_path = function_path;
        self.cgctx.current_function_return_type = return_type.clone();
        self.cgctx.var_counter.set(0);
        self.cgctx.temp_counter.set(0);
        self.cgctx.label_counter.set(0);
        self.cgctx.scope.push_layer();
        self.cgctx.current_block_name = "entry".to_string();
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
            self.cgctx.scope.define(arg_name.clone(), var, 0);
        }
        let fx = body.clone();
        for stmt in fx.iter() {
            self.compile_statement(stmt, builder, ctx).extend(&format!(
                "During compilation of function '{}':namespace('{}')",
                full_function_name,
                self.cgctx.current_function_path.to_string()
            ))?;
        }
        if return_type.is_void() {
            builder.emit_unconditional_jump_to(&self.cgctx.return_label_name);
            builder.emit_label(&self.cgctx.return_label_name);
        } else if self.cgctx.pending_returns.is_empty() {
            builder.emit_line_body("unreachable");
        } else {
            builder.emit_label(&self.cgctx.return_label_name);
        }
        let x = self.cgctx.scope.pop_layer(&mut ctx.symbols);
        for x in x {
            self.compile_statement(&x.with_dummy_span(), builder, ctx)?;
        }
        if return_type.is_void() {
            builder.emit_ret_void();
        } else {
            if self.cgctx.pending_returns.is_empty() {
            } else {
                if self.cgctx.pending_returns.len() > 1 {
                    let phi_ops = self
                        .cgctx
                        .pending_returns
                        .iter()
                        .map(|(val, blk)| format!("[ {}, %{} ]", val, blk))
                        .collect::<Vec<_>>()
                        .join(", ");
                    builder.emit_line_body(&format!(
                        "%final_ret = phi {} {}",
                        return_type_llvm, phi_ops
                    ));
                    builder.emit_line_body(&format!("ret {} %final_ret", return_type_llvm));
                } else {
                    builder.emit_line_body(&format!(
                        "ret {} {}",
                        return_type_llvm, self.cgctx.pending_returns[0].0
                    ));
                }
            }
        }
        builder.end_function();
        Ok(())
    }
    pub fn compile_statement(
        &mut self,
        statement: &StmtData,
        builder: &mut LLVMOutputHandler,
        ctx: &mut CompilerContext,
    ) -> CompileResult<bool> {
        self.span = statement.span.clone();
        match &statement.stmt {
            Stmt::Debug(comment) => {
                builder.emit_comment(&comment);
                Ok(false)
            }
            Stmt::If(x, y, z) => Ok(self
                .compile_if_statement(x, y, z, builder, ctx)
                .extend(&format!("During compilation of if statement"))?),
            Stmt::Block(x) => {
                self.compile_block(x, builder, ctx)
                    .extend(&format!("During compilation of block"))?;
                Ok(false)
            }
            Stmt::Return(x) => Ok(self
                .compile_return(x, builder, ctx)
                .extend(&format!("During compilation of return statement"))?),
            Stmt::Expr(x) => Ok(compile_expression_v2(
                x,
                Expected::NoReturn,
                self.span.clone(),
                &mut self.cgctx,
                ctx,
                builder,
            )?
            .is_program_halt()),
            Stmt::ConstLet(name, var_type, z) => {
                self.compile_var_decl(
                    (name, var_type, &Some(z.clone()), true, false),
                    builder,
                    ctx,
                )
                .extend_set_span_if_none(
                    &format!("During declaration of constant {}", name),
                    self.span.clone(),
                )?;
                Ok(false)
            }
            Stmt::Static(name, var_type, z) => {
                self.compile_var_decl((name, var_type, z, false, true), builder, ctx)
                    .extend_set_span_if_none(
                        &format!("During declaration of static variable {}", name),
                        self.span.clone(),
                    )?;
                Ok(false)
            }
            Stmt::Let(name, var_type, z) => {
                self.compile_var_decl((name, var_type, z, false, false), builder, ctx)
                    .extend_set_span_if_none(
                        &format!("During declaration of variable {}", name),
                        self.span.clone(),
                    )?;
                Ok(false)
            }
            Stmt::Loop(inside) => {
                self.compile_loop(inside, builder, ctx)
                    .extend(&format!("Inside loop"))?;
                Ok(false)
            }
            Stmt::Continue => match self.cgctx.scope.current_loop_tag() {
                Some(li) => {
                    builder.emit_unconditional_jump_to(&format!("loop_body{}", li));
                    return Ok(false);
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
                    builder.emit_unconditional_jump_to(&format!("loop_body{}_exit", li));
                    return Ok(true);
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
            Stmt::CompilerDud => Ok(false),
            _ => unimplemented!("{:?}", statement),
        }
    }
    fn compile_if_statement(
        &mut self,
        expr: &Expr,
        r#then: &[StmtData],
        r#else: &[StmtData],
        builder: &mut LLVMOutputHandler,
        ctx: &mut CompilerContext,
    ) -> CompileResult<bool> {
        if r#then.is_empty() && r#else.is_empty() {
            return Ok(false);
        }
        let bool_type = CompilerType::Primitive(BOOL_TYPE);
        let cond_result = compile_expression_v2(
            expr,
            Expected::Type(&bool_type),
            self.span.clone(),
            &mut self.cgctx,
            ctx,
            builder,
        )?;
        let Some(cond_val_type) = cond_result.get_type() else {
            return Err(
                CompilerError::Generic("Right side of if condition is not value".into()).into(),
            );
        };
        if *cond_val_type != bool_type {
            return Err((
                self.span.clone(),
                CompilerError::InvalidExpression(format!(
                    "'{:?}' must result in bool, instead resulted in {:?}",
                    expr.debug_emit(),
                    cond_val_type
                )),
            )
                .into());
        }
        if false {
            if let LLVMVal::ConstantBoolean(_boolean) = cond_result.get_llvm_rep() {
                return Ok(false);
            }
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
        builder.push_function_body(&format!(
            "\tbr i1 {}, label %{}, label %{}\n",
            cond_result.get_llvm_rep().to_string(),
            target_then,
            target_else
        ));
        if !r#then.is_empty() {
            builder.emit_label(&then_label);
            self.cgctx.current_block_name = then_label;
            self.cgctx.scope.push_layer();
            for then_stmt in then {
                let end_compile = self.compile_statement(then_stmt, builder, ctx)?;
                if end_compile {
                    break;
                };
            }
            let exit_stmts = self.cgctx.scope.pop_layer(&mut ctx.symbols);
            for x in exit_stmts {
                self.compile_statement(
                    &StmtData {
                        stmt: x,
                        span: self.span.clone(),
                    },
                    builder,
                    ctx,
                )?;
            }
            if then
                .last()
                .map(|x| !matches!(x.stmt, Stmt::Return(..) | Stmt::Break | Stmt::Continue))
                .unwrap_or(false)
            {
                builder.emit_unconditional_jump_to(&end_label);
            }
        }

        if !r#else.is_empty() {
            builder.emit_label(&else_label);
            self.cgctx.current_block_name = else_label;
            self.cgctx.scope.push_layer();
            for then_stmt in r#else {
                let end_compile = self.compile_statement(then_stmt, builder, ctx)?;
                if end_compile {
                    break;
                };
            }
            let x = self.cgctx.scope.pop_layer(&mut ctx.symbols);
            for x in x {
                self.compile_statement(
                    &StmtData {
                        stmt: x,
                        span: self.span.clone(),
                    },
                    builder,
                    ctx,
                )?;
            }
        }
        if r#else
            .last()
            .map(|x| !matches!(x.stmt, Stmt::Return(..) | Stmt::Break | Stmt::Continue))
            .unwrap_or(false)
        {
            builder.emit_unconditional_jump_to(&end_label);
        }
        builder.emit_label(&end_label);
        self.cgctx.current_block_name = end_label;
        Ok(false)
    }
    fn compile_return(
        &mut self,
        expr: &Option<Expr>,
        builder: &mut LLVMOutputHandler,
        ctx: &mut CompilerContext,
    ) -> CompileResult<bool> {
        let return_type = self.cgctx.current_function_return_type.clone();
        match (expr.is_some(), !return_type.is_void()) {
            (true, true) => {
                let expr = expr.as_ref().unwrap();
                let result = compile_expression_v2(
                    expr,
                    Expected::Type(&return_type),
                    self.span.clone(),
                    &mut self.cgctx,
                    ctx,
                    builder,
                )?;
                if !result.equal_type(&return_type) {
                    return Err(CompilerError::TypeMismatch {
                        expected: return_type,
                        found: result.get_type().unwrap().clone(),
                    }
                    .into());
                }
                self.cgctx.pending_returns.push((
                    result.get_llvm_rep().to_string(),
                    self.cgctx.current_block_name.to_string(),
                ));
                builder.emit_unconditional_jump_to(&self.cgctx.return_label_name);
            }
            (false, false) => {
                builder.emit_unconditional_jump_to(&self.cgctx.return_label_name);
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
        Ok(true)
    }
    fn compile_var_decl(
        &mut self,
        var: (&String, &ParserType, &Option<Expr>, bool, bool),
        builder: &mut LLVMOutputHandler,
        ctx: &mut CompilerContext,
    ) -> CompileResult<()> {
        let (name, p_type, expr, is_const, is_static) = var;
        let var_type = CompilerType::from_parser_type(
            p_type,
            &ctx.symbols,
            &self.cgctx.current_function_path,
        )?;
        let variable = Variable::new(var_type, is_const, is_static);
        let id = if !is_const && !is_static {
            let x = self.cgctx.acquire_var_id();
            builder.push_function_intro(&format!(
                "\t{} = alloca {}; var: {}\n",
                LLVMVal::Variable(x).to_string(),
                variable.compiler_type().llvm_representation(&ctx.symbols)?,
                name
            ));
            x
        } else {
            0
        };

        let Some(expression) = expr else {
            self.cgctx.scope.define(name.clone(), variable, id);
            return Ok(());
        };

        let result = compile_expression_v2(
            expression,
            Expected::Type(&variable.compiler_type()),
            self.span.clone(),
            &mut self.cgctx,
            ctx,
            builder,
        )?;
        if !result.equal_type(&variable.compiler_type()) {
            let Some(result_type) = result.get_type() else {
                return Err(CompilerError::Generic(
                    "Right side of const let is not a value".into(),
                )
                .into());
            };
            return Err((
                self.span.clone(),
                CompilerError::TypeMismatch {
                    expected: variable.compiler_type().clone(),
                    found: result_type.clone(),
                },
            )
                .into());
        }
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
                    self.cgctx.scope.define(name.clone(), variable, id);
                    let f = ctx.symbols.get_type_by_id(tid).fields.clone();
                    for (x, expr) in f.iter().zip(fields.iter()) {
                        let q =
                            x.1.with_substituted_generics(&type_map, &ctx.symbols)?
                                .llvm_representation(&ctx.symbols)
                                .unwrap();
                        let mut ec = ExpressionCompiler::new(&mut self.cgctx, builder, ctx);
                        let l = ec.compile_lvalue(
                            &Expr::MemberAccess(Box::new(Expr::Name(name.clone())), x.0.clone()),
                            false,
                            true,
                        )?;
                        ec.emit_store(expr, &l.location, &q);
                    }
                    return Ok(());
                };
                self.cgctx.scope.define(name.clone(), variable, id);
                let f = ctx.symbols.get_type_by_id(x).fields.clone();
                for (x, expr) in f.iter().zip(fields.iter()) {
                    let q = x.1.llvm_representation(&ctx.symbols).unwrap();
                    let mut ec = ExpressionCompiler::new(&mut self.cgctx, builder, ctx);
                    let l = ec.compile_lvalue(
                        &Expr::MemberAccess(Box::new(Expr::Name(name.clone())), x.0.clone()),
                        false,
                        true,
                    )?;
                    ec.emit_store(expr, &l.location, &q);
                }
                return Ok(());
            }
        }
        if is_const {
            variable.set_constant_value(Some(result.get_llvm_rep().clone()));
            self.cgctx.scope.define(name.clone(), variable, id);
            return Ok(());
        }
        let t = variable.compiler_type().llvm_representation(&ctx.symbols)?;
        self.cgctx.scope.define(name.clone(), variable, id);
        let ptr_reg = format!("%v{}", id);
        builder.emit_line_body(&format!(
            "store {} {}, {}* {}",
            t,
            result.get_llvm_rep().to_string(),
            t,
            ptr_reg
        ));
        Ok(())
    }
    fn compile_loop(
        &mut self,
        inside: &[StmtData],
        builder: &mut LLVMOutputHandler,
        ctx: &mut CompilerContext,
    ) -> CompileResult<()> {
        let lc = self.cgctx.acquire_label_id();
        builder.emit_unconditional_jump_to(&format!("loop_body{}", lc));
        builder.emit_label(&format!("loop_body{}", lc));
        self.cgctx.scope.push_layer();
        self.cgctx.scope.set_loop_tag(Some(lc));
        self.cgctx.current_block_name = format!("loop_body{}", lc);
        for x in inside {
            self.compile_statement(x, builder, ctx)?;
        }

        builder.emit_unconditional_jump_to(&format!("loop_body{}", lc));
        builder.emit_label(&format!("loop_body{}_exit", lc));
        self.cgctx.current_block_name = format!("loop_body{}_exit", lc);
        let x = self.cgctx.scope.pop_layer(&mut ctx.symbols);
        for x in x {
            self.compile_statement(&x.with_dummy_span(), builder, ctx)?;
        }
        Ok(())
    }
    fn compile_block(
        &mut self,
        inside: &[StmtData],
        builder: &mut LLVMOutputHandler,
        ctx: &mut CompilerContext,
    ) -> CompileResult<()> {
        let lc = self.cgctx.acquire_label_id();
        self.cgctx.scope.push_layer();
        self.cgctx.current_block_name = format!("block{}", lc);
        for x in inside {
            self.compile_statement(x, builder, ctx)?;
        }

        let x = self.cgctx.scope.pop_layer(&mut ctx.symbols);
        for x in x {
            self.compile_statement(&x.with_dummy_span(), builder, ctx)?;
        }
        Ok(())
    }
}
#[derive(Default)]
pub struct CodeGenContext {
    pub scope: Scope,
    pub current_block_name: String,
    pub pending_returns: Vec<(String, String)>,
    pub return_label_name: String,
    pub temp_counter: Cell<u32>,
    pub var_counter: Cell<u32>,
    pub label_counter: Cell<u32>,

    pub current_function_return_type: CompilerType,
    pub current_function_path: ContextPath,
}
impl CodeGenContext {
    pub fn set_current_block(&mut self, name: String) {
        self.current_block_name = name;
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
