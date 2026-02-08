use crate::{
    compiler_essentials::{
        CompileResult, CompilerError, CompilerType, Enum, Function, LLVMOutputHandler, LLVMVal,
        Scope, Struct, SymbolTable, Variable,
    },
    expression_compiler::{self, compile_expression_v2, constant_expression_compiler, Expected},
};
use rcsharp_lexer::{Lexer, LexingError};
use rcsharp_parser::{
    compiler_primitives::BOOL_TYPE,
    expression_parser::Expr,
    parser::{GeneralParser, ParserType, Span, Stmt, StmtData},
};
use std::{cell::Cell, collections::HashMap};

pub trait CompilerPass<'a> {
    type Input;
    type Output;
    fn run(&mut self, input: Self::Input, ctx: &mut CompilerContext)
        -> CompileResult<Self::Output>;
}
pub fn compile_to_file(entry_path: &str, output_path: &str) -> CompileResult<()> {
    let x = compile(entry_path)?;
    std::fs::write(output_path, x.1).unwrap();
    let diag = x.0.diagnostics;
    if diag.is_empty() {
        return Ok(());
    }
    Err(CompilerError::Generic(format!("{}", diag.len())).into())
}
pub fn compile(entry_path: &str) -> CompileResult<(CompilerContext, String)> {
    let mut ctx = CompilerContext::default();

    let mut loader = ModuleLoaderPass::default();
    let ast = loader.run(entry_path, &mut ctx)?;

    let mut type_checker = TypeCheckPass::default();
    type_checker.run(&ast, &mut ctx)?;
    let mut optimizer = OptimizerPass::default();
    optimizer.run((), &mut ctx)?;
    let mut codegen = LLVMGenPass::default();
    let llvm_ir = codegen.run((), &mut ctx)?;

    Ok((ctx, llvm_ir))
}
#[derive(Default)]
pub struct CompilerContext {
    pub symbols: SymbolTable,
    pub config: CompilerConfig,
    pub source_manager: SourceManager,
    pub diagnostics: Vec<CompilerError>,
}
#[derive(Default)]
pub struct CompilerConfig {}
#[derive(Default)]
pub struct SourceManager {}
#[derive(Default)]
pub struct ModuleLoaderPass {}
impl<'a> CompilerPass<'a> for ModuleLoaderPass {
    type Input = &'a str;

    type Output = Vec<StmtData>;

    fn run(
        &mut self,
        input: Self::Input,
        _ctx: &mut CompilerContext,
    ) -> CompileResult<Self::Output> {
        let mut stmt_vec = vec![];

        let mut to_runn_throu = vec![input.to_string()];
        let mut runned_throu = vec![];
        while let Some(path) = to_runn_throu.pop() {
            let file_data = std::fs::read_to_string(&path).unwrap();
            let lexed = Lexer::new(&file_data)
                .collect::<Result<Vec<_>, LexingError>>()
                .unwrap();
            let q = rcsharp_parser::parser::GeneralParser::new(&lexed)
                .parse_compiler_only()
                .unwrap();
            for (span, attr) in q.iter() {
                if attr.name_equals("include") {
                    let include_path_expr = attr.one_argument();
                    let Some(Expr::StringConst(include_path)) = include_path_expr else {
                        return Err((
                            span.clone(),
                            CompilerError::InvalidExpression(
                                "Include requires a string argument".into(),
                            ),
                        )
                            .into());
                    };
                    to_runn_throu.push(include_path.to_string());
                }
            }
            runned_throu.push((path, lexed));
        }
        for (_path, tokens) in runned_throu.iter() {
            let mut parse = GeneralParser::new(tokens).parse_all().unwrap();
            stmt_vec.append(&mut parse);
        }
        Ok(stmt_vec)
    }
}
#[derive(Default)]
pub struct TypeCheckPass {}
impl<'a> CompilerPass<'a> for TypeCheckPass {
    type Input = &'a Vec<StmtData>;

    type Output = ();

    fn run(
        &mut self,
        input: Self::Input,
        ctx: &mut CompilerContext,
    ) -> CompileResult<Self::Output> {
        let mut to_runn_throu: Vec<(String, &[StmtData])> = vec![(format!(""), input.as_slice())];
        let get_full_path = |x: &str, y: &str| {
            if x == "" {
                return y.to_string();
            }
            format!("{}.{}", x, y)
        };
        let mut runned_throu: Vec<(String, &[StmtData])> = vec![];
        let mut types = vec![];
        let mut enums = vec![];
        let mut static_variables = vec![];
        let mut functions = vec![];
        while let Some((path, body)) = to_runn_throu.pop() {
            for x in body {
                match &x.stmt {
                    Stmt::Namespace(x, body) => {
                        to_runn_throu.push((get_full_path(&path, x), body));
                    }
                    Stmt::Struct(x) => {
                        types.push((path.clone(), x));
                    }
                    Stmt::Function(x) => {
                        functions.push((path.clone(), x));
                    }
                    Stmt::Enum(x) => {
                        enums.push((path.clone(), x));
                    }
                    Stmt::Static(name, var_type, expression) => {
                        static_variables.push((path.clone(), (name, var_type, expression)));
                    }
                    _ => {}
                }
            }
            runned_throu.push((path, body));
        }
        for (current_path, parsed_type) in types.iter() {
            let full_path = get_full_path(current_path, &parsed_type.name);
            ctx.symbols
                .insert_type(&full_path, Struct::new_placeholder());
        }
        for (current_path, parsed_type) in types.iter() {
            let str = parsed_type;
            let full_path = get_full_path(current_path, &parsed_type.name);
            let mut compiler_struct_fields = vec![];
            let mut new_alias_types = HashMap::new();
            for prm in &str.generic_params {
                new_alias_types.insert(
                    prm.clone(),
                    CompilerType::GenericPlaceholder(prm.to_string().into_boxed_str()),
                );
            }
            ctx.symbols.set_alias_types(new_alias_types);
            for (name, attr_type) in str.fields.iter() {
                if let Some(pt) = attr_type.as_primitive_type() {
                    compiler_struct_fields.push((name.to_string(), CompilerType::Primitive(pt)));
                    continue;
                }
                compiler_struct_fields.push((
                    name.to_string(),
                    CompilerType::from_parser_type(&attr_type, &ctx.symbols, current_path)?,
                ));
            }
            ctx.symbols.insert_type(
                &full_path,
                Struct::new(
                    current_path.clone().into_boxed_str(),
                    str.name.clone(),
                    compiler_struct_fields.into_boxed_slice(),
                    str.attributes.clone(),
                    str.generic_params.clone(),
                ),
            );
        }
        for (current_path, parsed_enum) in enums.iter() {
            let full_path = get_full_path(current_path, &parsed_enum.name);
            let mut compiler_enum_fields = vec![];
            let Some(x) = parsed_enum.enum_type.as_integer() else {
                todo!("")
            };
            for (field_name, field_expr) in &parsed_enum.fields {
                if let Expr::Integer(int) = &field_expr {
                    compiler_enum_fields
                        .push((field_name.to_string(), LLVMVal::ConstantInteger(*int)));
                    continue;
                }
                compiler_enum_fields.push((
                    field_name.to_string(),
                    constant_expression_compiler(&field_expr)?,
                ));
            }
            ctx.symbols.insert_enum(
                &full_path,
                Enum::new(
                    current_path.clone().into_boxed_str(),
                    parsed_enum.name.clone(),
                    CompilerType::Primitive(x),
                    compiler_enum_fields.into_boxed_slice(),
                    parsed_enum.attributes.clone(),
                ),
            );
        }
        for (current_path, (name, var_type, _expresson)) in static_variables.iter() {
            let full_path = get_full_path(current_path, name);
            let t = CompilerType::from_parser_type(*var_type, &ctx.symbols, &full_path)?;
            ctx.symbols
                .insert_static_var(name, Variable::new(t, false, false))?;
        }
        for (current_path, parsed_function) in functions.iter() {
            let return_type = CompilerType::from_parser_type(
                &parsed_function.return_type,
                &ctx.symbols,
                &current_path,
            )?;
            let args = parsed_function
                .args
                .iter()
                .map(|x| {
                    (
                        x.0.clone(),
                        CompilerType::from_parser_type(&x.1, &ctx.symbols, &current_path).unwrap(),
                    )
                })
                .collect::<Box<[_]>>();
            let function = Function::new(
                current_path.clone().into_boxed_str(),
                parsed_function.name.clone(),
                args,
                return_type,
                parsed_function.body.clone(),
                0.into(),
                parsed_function.attributes.clone(),
                parsed_function.generic_params.clone(),
            );
            let mut base = function.get_flags();
            let function_prefixes = &parsed_function.prefixes;
            if function_prefixes.iter().any(|x| x.as_str() == "extern")
                || function
                    .attributes
                    .iter()
                    .any(|x| x.name_equals("DllImport"))
            {
                base.is_external = true;
            }
            if function.attributes.iter().any(|x| x.name_equals("no_lazy")) {
                function.increment_usage();
            }
            if function_prefixes.iter().any(|x| x.as_str() == "public") {
                base.is_public = true;
            }
            if function_prefixes.iter().any(|x| x.as_str() == "inline") {
                base.is_inline = true;
            }
            if function_prefixes.iter().any(|x| x.as_str() == "constexpr") {
                base.is_const_expression = true;
            }
            if function_prefixes.iter().any(|x| x.as_str() == "no_return") {
                if !function.return_type.is_void() {
                    return Err(CompilerError::Generic(format!(
                        "Function '{}' is marked as no_return but has a non-void return type",
                        function.full_path()
                    ))
                    .into());
                }
                base.is_program_halt = true;
            }
            if !function.generic_params.is_empty() {
                base.is_generic = true;
            }
            function.set_flags(base);
            ctx.symbols
                .insert_function(&function.full_path().to_string(), function);
        }

        Ok(())
    }
}
#[derive(Default)]
pub struct OptimizerPass {}
impl<'a> CompilerPass<'a> for OptimizerPass {
    type Input = ();

    type Output = ();

    fn run(&mut self, _: Self::Input, ctx: &mut CompilerContext) -> CompileResult<Self::Output> {
        self.expression_optimisation(ctx)?;
        self.statements_after_return_optimisation(ctx)?;
        Ok(())
    }
}
impl OptimizerPass {
    fn expression_optimisation(&mut self, ctx: &mut CompilerContext) -> CompileResult<()> {
        let mut exprs = vec![];
        for func in ctx.symbols.functions_iter_mut() {
            for x in &mut func.1 .1.body {
                match &mut x.stmt {
                    Stmt::Expr(expr) => exprs.push(expr),
                    Stmt::ConstLet(_, _, expr) => exprs.push(expr),
                    Stmt::Static(_, _, expr) => {
                        if let Some(expr) = expr {
                            exprs.push(expr)
                        }
                    }
                    Stmt::Let(_, _, expr) => {
                        if let Some(expr) = expr {
                            exprs.push(expr)
                        }
                    }
                    Stmt::Return(expr) => {
                        if let Some(expr) = expr {
                            exprs.push(expr)
                        }
                    }
                    Stmt::If(expr, ..) => exprs.push(expr),
                    _ => {}
                }
            }
        }
        for expr in exprs {
            if let Some(x) = expression_compiler::constant_expression_optimizer_base(expr) {
                println!("Opt FROM EXPR:{}", expr.debug_emit());
                println!("Opt TO EXPR:{}", x.debug_emit());
                *expr = x;
            }
        }

        Ok(())
    }
    fn statements_after_return_optimisation(
        &mut self,
        ctx: &mut CompilerContext,
    ) -> CompileResult<()> {
        let mut bodies = vec![];
        for func in ctx.symbols.functions_iter_mut() {
            if !func.1 .1.body.is_empty() {
                bodies.push(&mut func.1 .1.body);
            }
        }
        while let Some(body) = bodies.pop() {
            if let Some(end) = body
                .iter()
                .position(|x| {
                    matches!(x.stmt, Stmt::Return(..))
                        || x.stmt == Stmt::Break
                        || x.stmt == Stmt::Continue
                })
                .filter(|pos| *pos != body.len() - 1)
            {
                println!("Saving:{}", body.len() - end);
                *body = body.split_at(end).0.to_vec().into_boxed_slice();
            };
            for statement in body {
                match &mut statement.stmt {
                    Stmt::Loop(x) => {
                        if !x.is_empty() {
                            bodies.push(x)
                        }
                    }
                    Stmt::If(_, x, y) => {
                        if !x.is_empty() {
                            bodies.push(x)
                        }
                        if !y.is_empty() {
                            bodies.push(y)
                        }
                    }
                    _ => {}
                }
            }
        }
        Ok(())
    }
}
#[derive(Default)]
pub struct LLVMGenPass {
    cgctx: CodeGenContext,
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
    fn emit_external(
        &mut self,
        builder: &mut LLVMOutputHandler,
        ctx: &mut CompilerContext,
    ) -> CompileResult<()> {
        for x in ctx
            .symbols
            .functions_iter()
            .filter(|x| x.1 .1.is_external() && x.1 .1.usage_count.get() >= 1)
        {
            let func = &x.1 .1;
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
            .filter(|x| !x.1 .1.is_external() && x.1 .1.usage_count.get() > 0)
        {
            builder.push_footer(&format!(
                ";func {} {:?}\n",
                x.0,
                x.1 .1
                    .attributes
                    .iter()
                    .map(|x| x.name.to_string())
                    .collect::<Vec<_>>()
            ));
        }
        for x in ctx.symbols.types_iter().filter(|x| {
            (x.1 .1.is_generic() && !x.1 .1.generic_implementations.borrow().is_empty())
                || (!x.1 .1.is_generic())
        }) {
            builder.push_footer(&format!(";type {}\n", x.0));
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
                "@{} = internal global {} zeroinitializer",
                path,
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
        for (path, (_, r#type)) in ctx.symbols.types_iter().filter(|x| !x.1 .1.is_generic()) {
            let field_types = r#type
                .fields
                .iter()
                .map(|(_field_name, field_type)| field_type.llvm_representation(&ctx.symbols))
                .collect::<CompileResult<Vec<_>>>()?
                .join(", ");
            builder.push_header(&format!("%struct.{} = type {{ {} }}\n", path, field_types));
        }
        let mut done = HashMap::new();
        loop {
            let mut new = false;
            for (_, (id, r#type)) in ctx.symbols.types_iter().filter(|x| x.1 .1.is_generic()) {
                let imps_len = { r#type.generic_implementations.borrow().len() };
                if imps_len == 0 {
                    continue;
                }
                if done.get(id).filter(|x| **x == imps_len).is_some() {
                    continue;
                }
                let from_index = done.insert(*id, imps_len).unwrap_or(0);
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
        let Some(main) = ctx.symbols.get_function_id("main") else {
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
                for (_, (id, _)) in ctx.symbols.functions_iter().filter(|x| {
                    x.1 .1.usage_count.get() != 0
                        && !x.1 .1.is_generic()
                        && !x.1 .1.is_external()
                        && !x.1 .1.is_inline()
                }) {
                    if done.iter().any(|x| *x == *id) {
                        continue;
                    }
                    to_do.push(*id);
                }
            }
            let mut new = false;
            for (_, (id, func)) in ctx.symbols.functions_iter().filter(|x| {
                x.1 .1.usage_count.get() != 0
                    && x.1 .1.is_generic()
                    && !x.1 .1.is_external()
                    && !x.1 .1.is_inline()
            }) {
                let imps_len = { func.generic_implementations.borrow().len() };
                if imps_len == 0 {
                    continue;
                }
                if done_generics.get(id).filter(|x| **x == imps_len).is_some() {
                    continue;
                }
                let from_index = done_generics.insert(*id, imps_len).unwrap_or(0);
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
                        func.path().to_string(),
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
                    &function_path,
                    &full_function_name,
                    return_type,
                    args,
                    &body.into_boxed_slice(),
                    builder,
                    ctx,
                )?;
            }
            for (_, (id, _)) in ctx.symbols.functions_iter().filter(|x| {
                x.1 .1.usage_count.get() != 0
                    && !x.1 .1.is_generic()
                    && !x.1 .1.is_external()
                    && !x.1 .1.is_inline()
            }) {
                if done.iter().any(|x| *x == *id) {
                    continue;
                }
                new = true;
                to_do.push(*id);
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
                function.path().to_string(),
                return_type,
                args,
                body,
            )
        };
        self.compile_function_base(
            &path,
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
        function_path: &str,
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
        self.cgctx.current_function_path = function_path.to_string();
        self.cgctx.current_function_return_type = return_type.clone();
        self.cgctx.var_counter.set(0);
        self.cgctx.temp_counter.set(0);
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
            self.compile_statement(stmt, builder, ctx)?;
        }
        if !return_type.is_void() {
            builder.emit_line_body("unreachable");
        } else {
            builder.emit_unconditional_jump_to(&self.cgctx.return_label_name);
        }
        builder.emit_label(&self.cgctx.return_label_name);
        let x = self.cgctx.scope.pop_layer(&mut ctx.symbols);
        for x in x {
            self.compile_statement(
                &StmtData {
                    stmt: x,
                    span: Span::empty(),
                },
                builder,
                ctx,
            )?;
        }
        if return_type.is_void() {
            builder.emit_ret_void();
        } else {
            if self.cgctx.pending_returns.is_empty() {
                builder.emit_line_body("unreachable");
            } else {
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
        self.span = statement.span;
        match &statement.stmt {
            Stmt::Debug(comment) => {
                builder.emit_comment(&comment);
                Ok(false)
            }
            Stmt::If(x, y, z) => Ok(self.compile_if_statement(x, y, z, builder, ctx)?),
            Stmt::Return(x) => Ok(self.compile_return(x, builder, ctx)?),
            Stmt::Expr(x) => Ok(compile_expression_v2(
                x,
                Expected::NoReturn,
                self.span,
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
                )?;
                Ok(false)
            }
            Stmt::Static(name, var_type, z) => {
                self.compile_var_decl((name, var_type, z, false, true), builder, ctx)?;
                Ok(false)
            }
            Stmt::Let(name, var_type, z) => {
                self.compile_var_decl((name, var_type, z, false, false), builder, ctx)?;
                Ok(false)
            }
            Stmt::Loop(inside) => {
                self.compile_loop(inside, builder, ctx)?;
                Ok(false)
            }
            Stmt::Continue => match self.cgctx.scope.current_loop_tag() {
                Some(li) => {
                    builder.emit_unconditional_jump_to(&format!("loop_body{}", li));
                    return Ok(false);
                }
                None => {
                    return Err((
                        self.span,
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
                        self.span,
                        CompilerError::Generic("Tried to break without loop".to_string()),
                    )
                        .into())
                }
            },
            Stmt::CompilerHint(..) => panic!(),
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
        let bool_type = CompilerType::Primitive(BOOL_TYPE);
        let cond_result = compile_expression_v2(
            expr,
            Expected::Type(&bool_type),
            self.span,
            &mut self.cgctx,
            ctx,
            builder,
        )?;
        let Ok(cond_val_type) = cond_result.try_get_type() else {
            return Err(
                CompilerError::Generic("Right side of if condition is not value".into()).into(),
            );
        };
        if *cond_val_type != bool_type {
            return Err((
                self.span,
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
        let target_else = if r#else.is_empty() {
            &end_label
        } else {
            &else_label
        };
        builder.push_function_body(&format!(
            "\tbr i1 {}, label %{}, label %{}\n",
            cond_result.get_llvm_rep(),
            then_label,
            target_else
        ));
        builder.emit_label(&then_label);
        self.cgctx.current_block_name = then_label;
        self.cgctx.scope.push_layer();
        for then_stmt in then {
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
                    span: self.span,
                },
                builder,
                ctx,
            )?;
        }
        builder.emit_unconditional_jump_to(&end_label);
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
                        span: self.span,
                    },
                    builder,
                    ctx,
                )?;
            }
        }
        builder.emit_unconditional_jump_to(&end_label);
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
                    self.span,
                    &mut self.cgctx,
                    ctx,
                    builder,
                )?;
                if !result.equal_type(&return_type) {
                    return Err(CompilerError::TypeMismatch {
                        expected: return_type,
                        found: result.try_get_type().unwrap().clone(),
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
                    self.span,
                    CompilerError::Generic(format!(
                        "Function {} does not return anything, but got expression:{}",
                        self.cgctx.current_function_path,
                        expr.as_ref().unwrap().debug_emit()
                    )),
                )
                    .into());
            }
            (false, true) => {
                return Err((
                    self.span,
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
                LLVMVal::Variable(x),
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
            self.span,
            &mut self.cgctx,
            ctx,
            builder,
        )?;
        let Ok(result_type) = result.try_get_type() else {
            return Err(
                CompilerError::Generic("Right side of const let is not a value".into()).into(),
            );
        };
        if *result_type != *variable.compiler_type() {
            return Err((
                self.span,
                CompilerError::TypeMismatch {
                    expected: variable.compiler_type().clone(),
                    found: result_type.clone(),
                },
            )
                .into());
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
            result.get_llvm_rep(),
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
            self.compile_statement(
                &StmtData {
                    stmt: x,
                    span: Span::empty(),
                },
                builder,
                ctx,
            )?;
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
    pub current_function_path: String,
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
