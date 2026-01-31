// TODO phi
use std::{
    collections::{HashMap, HashSet, VecDeque},
    io::Read,
    time::{Duration, Instant},
};

use rcsharp_lexer::lex_string_with_file_context;
use rcsharp_parser::{
    compiler_primitives::BOOL_TYPE,
    expression_parser::Expr,
    parser::{
        Attribute, GeneralParser, ParsedEnum, ParsedFunction, ParsedStruct, ParserType, Span, Stmt,
        StmtData,
    },
};

use crate::{
    compiler_essentials::{
        CodeGenContext, CompileResult, CompileResultExt, CompilerError, CompilerType, Enum,
        Function, LLVMOutputHandler, LLVMVal, Struct, SymbolTable, Variable,
    },
    expression_compiler::{compile_expression, constant_expression_compiler, Expected},
};

pub const LAZY_FUNCTION_COMPILE: bool = true;
pub const APPEND_DEBUG_FUNCTION_INFO: bool = true;
pub const DONT_INSERT_REDUNDAND_STRINGS: bool = true;
pub const INTERGER_EXPRESION_OPTIMISATION: bool = true;
pub const DONT_COMPILE_AFTER_RETURN: bool = true;

pub fn rcsharp_compile_to_file(
    stmts: &[StmtData],
    full_path: &str,
    output_path: &str,
) -> CompileResult<()> {
    match rcsharp_compile(stmts, full_path) {
        Ok(llvm_ir) => std::fs::write(output_path, llvm_ir.build())
            .map_err(|e| (Span::empty(), e.into()).into()),
        Err(mut e) => Err({
            e.extend(&format!("while compiling file {}", full_path));
            e
        }),
    }
}
pub fn rcsharp_compile(
    stmts: &[StmtData],
    absolute_file_path: &str,
) -> CompileResult<LLVMOutputHandler> {
    let time_point = Instant::now();
    let mut symbols = SymbolTable::default();
    let mut output = LLVMOutputHandler::default();
    output.push_str_header("target triple = \"x86_64-pc-windows-msvc\"\n");
    output.push_str_header(&format!(";{}\n", absolute_file_path));
    let mut enums = vec![];
    let mut structs = vec![];
    let mut functions = vec![];
    let mut staticly_declared_variables = vec![];
    collect(
        stmts,
        &mut enums,
        &mut structs,
        &mut functions,
        &mut staticly_declared_variables,
    )
    .extend("while collecting compiler statements")?;
    let collecting = time_point.elapsed();
    let time_point = Instant::now();
    handle_types(structs, &mut symbols, &mut output).extend("while compiling types definitions")?;
    handle_enums(enums, &mut symbols, &mut output).extend("while compiling enums definitions")?;
    handle_functions(functions, &mut symbols, &mut output)
        .extend("while compiling function definitions")?;
    handle_staticly_declared_variables(staticly_declared_variables, &mut symbols, &mut output)?;
    if LAZY_FUNCTION_COMPILE {
        lazy_compile(&mut symbols, &mut output)?;
    } else {
        let mut gen_implemented_funcs = HashMap::new();
        let mut gen_implemented_types = HashMap::new();
        compile(&mut symbols, &mut output)?;
        while handle_generics(
            &mut gen_implemented_funcs,
            &mut gen_implemented_types,
            &mut symbols,
            &mut output,
        )
        .unwrap_or(false)
        {}
    }
    let compiling = time_point.elapsed();
    println!("Collecting {:?}", collecting);
    println!("Compiling {:?}", compiling);
    Ok(output)
}

fn handle_staticly_declared_variables(
    staticly_declared_variables: Vec<(String, String, ParserType, Option<Expr>)>,
    symbols: &mut SymbolTable,
    output: &mut LLVMOutputHandler,
) -> CompileResult<()> {
    for x in &staticly_declared_variables {
        let fp = if x.0.is_empty() {
            x.1.clone()
        } else {
            format!("{}.{}", x.0, x.1)
        };
        let t = CompilerType::from_parser_type(&x.2, symbols, &x.0)?;
        output.push_str_global(&format!(
            "@{} = internal global {} zeroinitializer",
            fp,
            t.llvm_representation(symbols)?
        ));
        symbols.insert_static_var(&fp, Variable::new_static(t, false))?;
    }
    Ok(())
}
fn collect(
    stmts: &[StmtData],
    enums: &mut Vec<ParsedEnum>,
    structs: &mut Vec<ParsedStruct>,
    functions: &mut Vec<ParsedFunction>,
    staticly_declared_variables: &mut Vec<(String, String, ParserType, Option<Expr>)>,
) -> CompileResult<()> {
    let mut statements: VecDeque<StmtData> = stmts.iter().cloned().collect();
    let initial_count = statements.len();
    let mut deep_statements_collected: u64 = statements
        .iter()
        .map(|x| x.stmt.recursive_statement_count())
        .sum();
    let mut total_processed_nodes = 0;
    let mut file_reading_time = Duration::new(0, 0);
    let mut lexing_time = Duration::new(0, 0);
    let mut parsing_time = Duration::new(0, 0);

    let mut current_path_segments: Vec<String> = Vec::new();
    let mut path_buffer = String::new();
    let mut included_files: HashSet<String> = HashSet::new();

    while let Some(stmt_data) = statements.pop_front() {
        total_processed_nodes += 1;
        match stmt_data.stmt {
            Stmt::CompilerHint(attr) => {
                if attr.name_equals("include") {
                    let include_path_expr = attr.one_argument();
                    if let Some(Expr::StringConst(include_path)) = include_path_expr {
                        if included_files.contains(include_path) {
                            continue;
                        }
                        included_files.insert(include_path.clone());

                        let q = Instant::now();
                        let mut file = std::fs::File::open(include_path).map_err(|e| {
                            (
                                stmt_data.span,
                                CompilerError::Generic(format!(
                                    "Failed to open file '{}': {}",
                                    include_path, e
                                )),
                            )
                        })?;

                        let mut buf = String::new();
                        file.read_to_string(&mut buf).map_err(|e| {
                            (
                                stmt_data.span,
                                CompilerError::Generic(format!(
                                    "Failed to read file '{}': {}",
                                    include_path, e
                                )),
                            )
                        })?;
                        file_reading_time += q.elapsed();
                        let q = Instant::now();
                        let lex =
                            lex_string_with_file_context(&buf, include_path).map_err(|_| {
                                (
                                    stmt_data.span,
                                    CompilerError::Generic(format!(
                                        "Lexer error in '{}'",
                                        include_path
                                    )),
                                )
                            })?;
                        lexing_time += q.elapsed();
                        let q = Instant::now();
                        let parsed_stmts = GeneralParser::new(&lex).parse_all().map_err(|e| {
                            {
                                (
                                    stmt_data.span,
                                    CompilerError::Generic(format!(
                                        "Parser error inside included file on location {}:{}:{}",
                                        include_path, e.1 .0, e.1 .1
                                    )),
                                )
                            }
                        })?;
                        parsing_time += q.elapsed();
                        for stmt in parsed_stmts.into_iter().rev() {
                            statements.push_front(stmt);
                        }
                    } else {
                        return Err((
                            stmt_data.span,
                            CompilerError::InvalidExpression(
                                "Include requires a string argument".into(),
                            ),
                        )
                            .into());
                    }
                } else if attr.name_equals("-pop") {
                    current_path_segments.pop();
                    path_buffer = current_path_segments.join(".");
                } else {
                    return Err((
                        stmt_data.span,
                        CompilerError::Generic(format!("Unknown global attribute: {:?}", attr)),
                    )
                        .into());
                }
            }
            Stmt::Namespace(namespace, body) => {
                current_path_segments.push(namespace);
                path_buffer = current_path_segments.join(".");
                let pop_hint = Stmt::CompilerHint(Attribute {
                    name: "-pop".into(),
                    arguments: Box::new([]),
                    span: Span { start: 0, end: 0 }, // Dummy span
                })
                .dummy_data();
                statements.push_front(pop_hint);
                deep_statements_collected += body
                    .iter()
                    .map(|x| x.stmt.recursive_statement_count())
                    .sum::<u64>();
                for stmt in body.iter().rev() {
                    statements.push_front(stmt.clone());
                }
            }
            Stmt::Struct(mut parsed_struct) => {
                parsed_struct.path = path_buffer.clone().into();
                structs.push(parsed_struct);
            }
            Stmt::Function(mut parsed_func) => {
                parsed_func.path = path_buffer.clone().into();
                functions.push(parsed_func);
            }
            Stmt::Enum(mut parsed_enum) => {
                parsed_enum.path = path_buffer.clone().into();
                enums.push(parsed_enum);
            }
            Stmt::Static(x, y, z) => {
                staticly_declared_variables.push((path_buffer.clone().into(), x, y, z));
            }
            _ => {
                return Err((
                    stmt_data.span,
                    CompilerError::Generic(format!("Invalid statement {:?}", stmt_data.stmt)),
                )
                    .into());
            }
        }
    }
    println!("Initial top level statements: {}", initial_count);
    println!("Total nodes processed: {}", total_processed_nodes);
    println!(
        "Deep recursive statement count: {}",
        deep_statements_collected
    );
    println!("Additional File Reading Time: {:?}", file_reading_time);
    println!("Additional Lexing Time: {:?}", lexing_time);
    println!("Additional Parsing Time: {:?}", parsing_time);
    Ok(())
}
fn handle_types(
    structs: Vec<ParsedStruct>,
    symbols: &mut SymbolTable,
    output: &mut LLVMOutputHandler,
) -> CompileResult<()> {
    let mut registered_types = vec![];
    for str in &structs {
        registered_types.push((str.path.to_string(), str.name.to_string()));
        let full_path = resolve_full_path(&str.path, &str.name);
        symbols.insert_type(
            &full_path,
            Struct::new_placeholder(str.path.to_string(), str.name.to_string(), false),
        );
    }

    for str in structs {
        let mut compiler_struct_fields = vec![];
        let path = str.path;
        let full_path = resolve_full_path(&path, &str.name);
        let mut new_alias_types = HashMap::new();
        for prm in &str.generic_params {
            new_alias_types.insert(
                prm.clone(),
                CompilerType::GenericPlaceholder(prm.to_string().into_boxed_str()),
            );
        }
        symbols.set_alias_types(new_alias_types);
        for (name, attr_type) in str.fields {
            if let Some(pt) = attr_type.as_primitive_type() {
                compiler_struct_fields.push((name, CompilerType::Primitive(pt)));
                continue;
            }
            compiler_struct_fields.push((
                name,
                CompilerType::from_parser_type(&attr_type, symbols, &path)?,
            ));
        }
        symbols.insert_type(
            &full_path,
            Struct::new(
                path,
                str.name,
                compiler_struct_fields.into_boxed_slice(),
                str.attributes,
                str.generic_params.clone(),
            ),
        );
    }
    symbols.set_alias_types(HashMap::new());
    let user_defined_structs: Vec<&Struct> = symbols
        .types_iter()
        .map(|x| &x.1 .1)
        .filter(|s: &&Struct| !s.is_primitive() && !s.is_generic())
        .collect();
    for s in user_defined_structs {
        let field_types: Vec<String> = s
            .fields
            .iter()
            .map(|(_field_name, field_type)| field_type.llvm_representation(symbols))
            .collect::<CompileResult<_>>()?;
        let llvm_struct_name = s.llvm_representation();
        let fields_str = field_types.join(", ");
        let type_definition = format!("{} = type {{ {} }}\n", llvm_struct_name, fields_str);
        output.push_str_header(&type_definition);
    }
    Ok(())
}
fn handle_enums(
    enums: Vec<ParsedEnum>,
    symbols: &mut SymbolTable,
    _output: &mut LLVMOutputHandler,
) -> CompileResult<()> {
    let mut registered_enums = vec![];
    for s in &enums {
        //let full_path = if s.0.is_empty() { s.2.0.clone() } else { format!("{}.{}", s.0, s.2.0) };
        registered_enums.push((s.path.clone(), s.name.clone()));
        //output.push_str(&format!("enum_{}\n", full_path));
    }
    for enm in enums {
        let (current_path, attrs, (enum_name, enum_type, fields)) = (
            enm.path,
            enm.attributes,
            (enm.name, enm.enum_type, enm.fields),
        );
        let full_path = resolve_full_path(&current_path, &enum_name);
        let mut compiler_enum_fields = vec![];
        if let Some(x) = enum_type.as_integer() {
            for (field_name, field_expr) in fields {
                if let Expr::Integer(int) = &field_expr {
                    compiler_enum_fields.push((field_name, LLVMVal::ConstantInteger(*int)));
                    continue;
                }
                compiler_enum_fields.push((field_name, constant_expression_compiler(&field_expr)?));
            }
            symbols.insert_enum(
                &full_path,
                Enum::new(
                    current_path,
                    enum_name,
                    CompilerType::Primitive(x),
                    compiler_enum_fields.into_boxed_slice(),
                    attrs,
                ),
            );
            continue;
        }
        unimplemented!("Not yet supported!")
    }
    Ok(())
}
fn handle_functions(
    functions: Vec<ParsedFunction>,
    symbols: &mut SymbolTable,
    output: &mut LLVMOutputHandler,
) -> CompileResult<()> {
    let mut registered_funcs = vec![];
    for p_func in &functions {
        let full_path = resolve_full_path(&p_func.path, &p_func.name);
        registered_funcs.push(full_path);
    }
    for pf in functions {
        let current_path = pf.path;
        let function_name = pf.name;
        let function_prefixes = pf.prefixes;
        let function_attrs = pf.attributes;
        let function_generics = pf.generic_params;
        let function_body = pf.body;
        let return_type = CompilerType::from_parser_type(&pf.return_type, symbols, &current_path)?;

        let args = pf
            .args
            .iter()
            .map(|x| {
                (
                    x.0.clone(),
                    CompilerType::from_parser_type(&x.1, symbols, &current_path).unwrap(),
                )
            })
            .collect::<Box<[_]>>();
        let function = Function::new(
            current_path,
            function_name,
            args,
            return_type,
            function_body,
            0.into(),
            function_attrs,
            function_generics,
        );
        let mut base = function.get_flags();
        if function_prefixes.iter().any(|x| x.as_str() == "public") {
            base.is_public = true;
        }
        if function_prefixes.iter().any(|x| x.as_str() == "inline") {
            base.is_inline = true;
        }
        if function_prefixes.iter().any(|x| x.as_str() == "constexpr") {
            base.is_const_expression = true;
        }
        if !function.generic_params.is_empty() {
            base.is_generic = true;
        }
        function.set_flags(base);
        symbols.insert_function(&function.full_path().to_string(), function);
    }
    for x in symbols.functions_iter() {
        fn_attribs_handler(&x.1 .1, x.1 .0, symbols, output)?;
    }
    Ok(())
}
fn lazy_compile(symbols: &mut SymbolTable, output: &mut LLVMOutputHandler) -> CompileResult<()> {
    let mut implemented_funcs = HashSet::new();
    let mut implement_funcs = Vec::new();

    let mut gen_implemented_funcs = HashMap::new();
    let mut gen_implemented_types = HashMap::new();

    let main_id = symbols
        .get_function_id("main")
        .expect("Expected function main");
    implement_funcs.push(main_id);
    while let Some(id) = implement_funcs.pop() {
        handle_generics(
            &mut gen_implemented_funcs,
            &mut gen_implemented_types,
            symbols,
            output,
        )?;
        implemented_funcs.insert(id);
        let func = symbols.get_function_by_id(id);
        compile_function_body(id, &func.full_path(), symbols, output)?;
        for x in symbols
            .functions_iter()
            .filter(|x| x.1 .1.is_normal() && x.1 .1.usage_count.get() > 0)
        {
            if !implemented_funcs.contains(&x.1 .0) && !implement_funcs.contains(&x.1 .0) {
                implement_funcs.push(x.1 .0);
            }
        }
    }
    while handle_generics(
        &mut gen_implemented_funcs,
        &mut gen_implemented_types,
        symbols,
        output,
    )
    .unwrap_or(false)
    {}
    for (_, (_id, function)) in symbols.functions_iter().filter(|x| x.1 .1.is_external()) {
        if function.usage_count.get() == 0 {
            continue;
        }
        // declare dllimport i32 @GetModuleFileNameA(i8*,i8*,i32)
        let rt = function.return_type.llvm_representation(symbols)?;
        let args = function
            .args
            .iter()
            .map(|x| x.1.llvm_representation(symbols))
            .collect::<CompileResult<Vec<_>>>()?
            .join(", ");
        output.push_str_include_header(&format!(
            "declare dllimport {} @{}({})\n",
            rt,
            function.name(),
            args
        ));
    }
    if APPEND_DEBUG_FUNCTION_INFO {
        for (full_path, (_id, function)) in symbols.functions_iter() {
            output.push_str_footer(&format!(
                ";fn {} used times {}\n",
                full_path,
                function.usage_count.get()
            ));
        }
    }
    Ok(())
}
fn compile(symbols: &mut SymbolTable, output: &mut LLVMOutputHandler) -> CompileResult<()> {
    for (full_path, (id, _function)) in symbols.functions_iter().filter(|x| x.1 .1.is_normal()) {
        compile_function_body(*id, full_path, symbols, output)?;
    }
    if APPEND_DEBUG_FUNCTION_INFO {
        for (full_path, (_id, function)) in symbols.functions_iter() {
            output.push_str_footer(&format!(
                ";fn {} used times {}\n",
                full_path,
                function.usage_count.get()
            ));
        }
    }
    for (_, (_id, function)) in symbols.functions_iter().filter(|x| x.1 .1.is_external()) {
        // declare dllimport i32 @GetModuleFileNameA(i8*,i8*,i32)
        let rt = function.return_type.llvm_representation(symbols)?;
        let args = function
            .args
            .iter()
            .map(|x| x.1.llvm_representation(symbols))
            .collect::<CompileResult<Vec<_>>>()?
            .join(", ");
        output.push_str_include_header(&format!(
            "declare dllimport {} @{}({})\n",
            rt,
            function.name(),
            args
        ));
    }
    Ok(())
}
fn compile_function_body(
    function_id: usize,
    full_function_name: &str,
    symbols: &SymbolTable,
    output: &mut LLVMOutputHandler,
) -> CompileResult<()> {
    let function = symbols.get_function_by_id(function_id);
    let mut rt = function.return_type.clone();
    rt.substitute_generics(&symbols.alias_types(), symbols)?;
    let return_type_llvm = rt.llvm_representation(symbols)?;
    let mut ctx = CodeGenContext::new(symbols, function_id);
    ctx.scope.push_layer();
    let args_str = function
        .args
        .iter()
        .map(|(name, ptype)| {
            {
                let mut ptype = ptype.clone();
                ptype.substitute_generics(&symbols.alias_types(), symbols)?;
                ptype
            }
            .llvm_representation(symbols)
            .map(|type_str| format!("{} %{}", type_str, name))
        })
        .collect::<CompileResult<Vec<_>>>()?
        .join(", ");
    output.start_function(return_type_llvm, full_function_name, args_str);

    for (arg_name, arg_type) in function.args.iter() {
        if ctx.scope.lookup(arg_name).is_some() {
            return Err(CompilerError::Generic(format!(
                "You declared argument '{}' twice",
                arg_name
            ))
            .into());
        }
        let mut arg_type = arg_type.clone();
        arg_type.substitute_generics(&symbols.alias_types(), symbols)?;
        ctx.scope.define(
            arg_name.clone(),
            Variable::new_argument(arg_type),
            0,
            symbols,
        );
    }

    for stmt in function.body.iter() {
        compile_statement(stmt, &mut ctx, output).extend(&format!(
            "while compiling function '{}'",
            full_function_name
        ))?;
        if DONT_COMPILE_AFTER_RETURN && matches!(stmt.stmt, Stmt::Return(..)) {
            break;
        };
    }
    let x = ctx.scope.pop_layer(&mut ctx.symbols);
    for x in x {
        compile_statement(
            &StmtData {
                stmt: x,
                span: Span::empty(),
            },
            &mut ctx,
            output,
        )
        .extend("While closing context in function")?;
    }
    if !matches!(function.body.last().map(|x| &x.stmt), Some(Stmt::Return(_))) {
        if function.return_type.is_void() {
            output.push_str("    ret void\n");
        } else {
            output.push_str("\n    unreachable\n");
        }
    }
    output.end_function();
    Ok(())
}
pub fn compile_statement(
    stmt: &StmtData,
    ctx: &mut CodeGenContext,
    output: &mut LLVMOutputHandler,
) -> CompileResult<()> {
    let current_function_path = ctx.current_path();
    match &stmt.stmt {
        Stmt::ConstLet(name, var_type, expr) => {
            let mut var_type =
                CompilerType::from_parser_type(var_type, ctx.symbols, current_function_path)?;
            var_type.substitute_generics(&ctx.symbols.alias_types(), ctx.symbols)?;
            let var = Variable::new(var_type.clone(), true);

            let result =
                compile_expression(expr, Expected::Type(&var_type), stmt.span, ctx, output)?;
            let Ok(result_type) = result.try_get_type() else {
                return Err(CompilerError::Generic(
                    "Right side of const let is not a value".into(),
                )
                .into());
            };
            if *result_type != var_type {
                return Err((
                    stmt.span,
                    CompilerError::TypeMismatch {
                        expected: var_type,
                        found: result_type.clone(),
                    },
                )
                    .into());
            }
            var.set_constant_value(Some(result.get_llvm_rep().clone()));
            ctx.scope.define(name.clone(), var, 0, ctx.symbols);
        }
        Stmt::Let(name, var_type, expr) => {
            let mut var_type =
                CompilerType::from_parser_type(var_type, ctx.symbols, current_function_path)?;
            var_type.substitute_generics(&ctx.symbols.alias_types(), ctx.symbols)?;
            let var = Variable::new(var_type.clone(), false);
            let x = ctx.acquire_var_id();
            output.push_function_intro(&format!(
                "    %v{} = alloca {}; var: {}\n",
                x,
                var_type.llvm_representation(ctx.symbols)?,
                name
            ));
            match expr {
                Some(init_expr) => {
                    let result = compile_expression(
                        init_expr,
                        Expected::Type(&var_type),
                        stmt.span,
                        ctx,
                        output,
                    )?;
                    let Ok(result_type) = result.try_get_type() else {
                        return Err(CompilerError::Generic(
                            "Right side of let is not a value".into(),
                        )
                        .into());
                    };
                    if *result_type != var_type {
                        return Err((
                            stmt.span,
                            CompilerError::TypeMismatch {
                                expected: var_type,
                                found: result_type.clone(),
                            },
                        )
                            .into());
                    }
                    ctx.scope.define(name.clone(), var, x, ctx.symbols);
                    let t = var_type.llvm_representation(ctx.symbols)?;
                    output.push_str(&format!(
                        "    store {} {}, {}* {}\n",
                        t,
                        result.get_llvm_rep(),
                        t,
                        LLVMVal::Variable(x)
                    ));
                }
                None => {
                    ctx.scope.define(name.clone(), var, x, ctx.symbols);
                }
            }
        }
        Stmt::Static(_name, var_type, _expr) => {
            let mut var_type =
                CompilerType::from_parser_type(var_type, ctx.symbols, current_function_path)?;
            var_type.substitute_generics(&ctx.symbols.alias_types(), ctx.symbols)?;
            let _var = Variable::new_static(var_type.clone(), false);
            unimplemented!("Not yet supported!")
        }

        Stmt::Expr(expression) => {
            compile_expression(expression, Expected::NoReturn, stmt.span, ctx, output)?;
        }
        Stmt::Loop(statement) => {
            let lc = ctx.acquire_label_id();

            output.push_str(&format!("    br label %loop_body{}\n", lc));
            output.push_str(&format!("loop_body{}:\n", lc));
            ctx.scope.push_layer();
            ctx.scope.set_loop_tag(Some(lc));
            for x in statement {
                compile_statement(x, ctx, output)?;
                if DONT_COMPILE_AFTER_RETURN && matches!(x.stmt, Stmt::Return(..)) {
                    break;
                };
            }
            output.push_str(&format!("    br label %loop_body{}\n", lc));
            output.push_str(&format!("loop_body{}_exit:\n", lc));
            let x = ctx.scope.pop_layer(&mut ctx.symbols);
            for x in x {
                compile_statement(
                    &StmtData {
                        stmt: x,
                        span: stmt.span,
                    },
                    ctx,
                    output,
                )
                .extend("While closing context in loop")?;
            }
        }
        Stmt::Continue => match ctx.scope.current_loop_tag() {
            Some(li) => {
                output.push_str(&format!("    br label %loop_body{}\n", li));
                return Ok(());
            }
            None => {
                return Err((
                    stmt.span,
                    CompilerError::Generic("Tried to continue without loop".to_string()),
                )
                    .into())
            }
        },
        Stmt::Break => match ctx.scope.current_loop_tag() {
            Some(li) => {
                output.push_str(&format!("    br label %loop_body{}_exit\n", li));
                return Ok(());
            }
            None => {
                return Err((
                    stmt.span,
                    CompilerError::Generic("Tried to break without loop".to_string()),
                )
                    .into())
            }
        },
        Stmt::Return(opt_expr) => {
            let function = ctx.current_function();
            let return_type = {
                function
                    .return_type
                    .with_substituted_generics(&ctx.symbols.alias_types(), ctx.symbols)?
            };
            if opt_expr.is_some() && return_type.is_void() {
                return Err((
                    stmt.span,
                    CompilerError::Generic(format!(
                        "Function {} does not return anything",
                        function.full_path()
                    )),
                )
                    .into());
            }
            if let Some(expr) = opt_expr {
                let result_value =
                    compile_expression(expr, Expected::Type(&return_type), stmt.span, ctx, output)?;
                let Ok(result_type) = result_value.try_get_type() else {
                    return Err(
                        CompilerError::Generic("Return expression is not a value".into()).into(),
                    );
                };
                if *result_type != return_type {
                    return Err((
                        stmt.span,
                        CompilerError::TypeMismatch {
                            expected: return_type.clone(),
                            found: result_type.clone(),
                        },
                    )
                        .into());
                }
                let x = ctx.scope.drop_current_scope(&mut ctx.symbols);
                for x in x {
                    compile_statement(
                        &StmtData {
                            stmt: x,
                            span: stmt.span,
                        },
                        ctx,
                        output,
                    )
                    .extend("While closing context during return")?;
                }
                let llvm_type_str = return_type.llvm_representation(ctx.symbols)?;
                output.push_str(&format!(
                    "    ret {} {}\n",
                    llvm_type_str,
                    result_value.get_llvm_rep()
                ));
            } else {
                if !return_type.is_void() {
                    return Err((
                        stmt.span,
                        CompilerError::Generic(
                            "Cannot return without a value from a non-void function.".to_string(),
                        ),
                    )
                        .into());
                }
                output.push_str("    ret void\n");
            }
        }
        Stmt::If(condition, then_body, else_body) => {
            let bool_type = CompilerType::Primitive(BOOL_TYPE);
            let cond_val = compile_expression(
                condition,
                Expected::Type(&bool_type),
                stmt.span,
                ctx,
                output,
            )?;
            let Ok(cond_val_type) = cond_val.try_get_type() else {
                return Err(CompilerError::Generic(
                    "Right side of if condition is not value".into(),
                )
                .into());
            };
            if *cond_val_type != bool_type {
                return Err((
                    stmt.span,
                    CompilerError::InvalidExpression(format!(
                        "'{:?}' must result in bool, instead resulted in {:?}",
                        condition, cond_val_type
                    )),
                )
                    .into());
            }

            let logic_id = ctx.acquire_label_id();
            let then_label = format!("then{}", logic_id);
            let else_label = format!("else{}", logic_id);
            let end_label = format!("endif{}", logic_id);

            let target_else = if else_body.is_empty() {
                &end_label
            } else {
                &else_label
            };
            output.push_str(&format!(
                "    br i1 {}, label %{}, label %{}\n",
                cond_val.get_llvm_rep(),
                then_label,
                target_else
            ));

            output.push_str(&format!("{}:\n", then_label));
            ctx.scope.push_layer();
            for then_stmt in then_body {
                compile_statement(then_stmt, ctx, output)?;
                if DONT_COMPILE_AFTER_RETURN && matches!(then_stmt.stmt, Stmt::Return(..)) {
                    break;
                };
            }
            let x = ctx.scope.pop_layer(&mut ctx.symbols);
            for x in x {
                compile_statement(
                    &StmtData {
                        stmt: x,
                        span: stmt.span,
                    },
                    ctx,
                    output,
                )
                .extend("While closing context in if statement")?;
            }
            output.push_str(&format!("    br label %{}\n", end_label));

            if !else_body.is_empty() {
                output.push_str(&format!("{}:\n", else_label));
                ctx.scope.push_layer();
                for else_stmt in else_body {
                    compile_statement(else_stmt, ctx, output)?;
                    if DONT_COMPILE_AFTER_RETURN && matches!(else_stmt.stmt, Stmt::Return(..)) {
                        break;
                    };
                }
                let x = ctx.scope.pop_layer(&mut ctx.symbols);
                for x in x {
                    compile_statement(
                        &StmtData {
                            stmt: x,
                            span: stmt.span,
                        },
                        ctx,
                        output,
                    )
                    .extend("While closing context in else statement")?;
                }
                output.push_str(&format!("    br label %{}\n", end_label));
            }

            output.push_str(&format!("{}:\n", end_label));
        }
        Stmt::Debug(x) => output.push_str(&format!("    ;DEBUG: {}\n", x)),
        Stmt::Function(..)
        | Stmt::Struct(..)
        | Stmt::Enum(..)
        | Stmt::Namespace(..)
        | Stmt::CompilerHint(..) => {
            return Err((
                stmt.span,
                CompilerError::Generic(format!("Invalid statement {:?}", stmt)),
            )
                .into());
        }
    }
    Ok(())
}
fn handle_generics(
    implemented_funcs: &mut HashMap<usize, usize>,
    implemented_types: &mut HashMap<usize, usize>,
    symbols: &mut SymbolTable,
    output: &mut LLVMOutputHandler,
) -> CompileResult<bool> {
    let mut any_new = false;
    loop {
        let mut new = false;
        let mut func_impl_queue = Vec::new();
        let mut type_impl_queue = Vec::new();
        for (id, func) in symbols.functions_iter().map(|x| x.1) {
            if !func.is_generic() {
                continue;
            }
            let impls = func.generic_implementations.borrow();
            let total_impls = impls.len();
            let processed_count = *implemented_funcs.get(id).unwrap_or(&0);
            if total_impls > processed_count {
                for i in processed_count..total_impls {
                    func_impl_queue.push((*id, i, impls[i].clone()));
                }
                implemented_funcs.insert(*id, total_impls);
                new = true;
            }
        }
        for (id, strct) in symbols.types_iter().map(|x| x.1) {
            if !strct.is_generic() {
                continue;
            }

            let impls = strct.generic_implementations.borrow();
            let total_impls = impls.len();

            let processed_count = *implemented_types.get(id).unwrap_or(&0);

            if total_impls > processed_count {
                for i in processed_count..total_impls {
                    type_impl_queue.push((*id, i, impls[i].clone()));
                }
                implemented_types.insert(*id, total_impls);
                new = true;
            }
        }
        if !new {
            break;
        }
        any_new = true;
        for (id, impl_index, concrete_types) in func_impl_queue {
            let (specialized_name, generic_params) = {
                let func = symbols.get_function_by_id(id);
                (
                    func.get_implementation_name(impl_index, symbols),
                    func.generic_params.clone(),
                )
            };
            let mut type_map = HashMap::new();
            for (idx, prm) in generic_params.iter().enumerate() {
                if let Some(concrete_type) = concrete_types.get(idx) {
                    type_map.insert(prm.clone(), concrete_type.clone());
                }
            }
            symbols.set_alias_types(type_map);
            compile_function_body(id, &specialized_name, symbols, output)?;
        }
        symbols.set_alias_types(HashMap::new());
        for (id, impl_index, concrete_types) in type_impl_queue {
            let (specialized_name, generic_params, fields) = {
                let strct = symbols.get_type_by_id(id);
                (
                    strct.llvm_repr_index(impl_index, symbols),
                    strct.generic_params.clone(),
                    strct.fields.clone(),
                )
            };
            let mut type_map = HashMap::new();
            for (idx, prm) in generic_params.iter().enumerate() {
                if let Some(concrete_type) = concrete_types.get(idx) {
                    type_map.insert(prm.clone(), concrete_type.clone());
                }
            }
            let mut field_strings = Vec::new();
            for (_, field_type) in fields.iter() {
                let substituted_type = field_type.with_substituted_generics(&type_map, symbols)?;
                field_strings.push(substituted_type.llvm_representation(symbols)?);
            }
            let body = field_strings.join(", ");
            output.push_str_header(&format!("{} = type {{ {} }}\n", specialized_name, body));
        }
    }
    Ok(any_new)
}
fn fn_attribs_handler(
    function: &Function,
    _function_id: usize,
    symbols: &SymbolTable,
    _output: &mut LLVMOutputHandler,
) -> CompileResult<()> {
    for x in function.attribs() {
        match &*x.name {
            "DllImport" => {
                let mut x = function.get_flags();
                x.is_external = true;
                function.set_flags(x);
            }
            "no_lazy" => {
                if function.usage_count.get() == 0 {
                    function.increment_usage();
                }
            }
            "ExtentionOf" => {
                let expr = x.one_argument().expect("Expected ony one argument");
                if let Some(arg) = function.args.get(0).map(|x| &x.1) {
                    if let Expr::Name(name) = expr {
                        let x = symbols
                            .get_type_id(&format!("{}.{}", function.path(), name))
                            .or(symbols.get_type_id(name))
                            .expect(format!("Expected type '{}' for ExtentionOf", name).as_str());
                        if arg.is_same_base_type(x) {
                            continue;
                        }
                        panic!("{} {:?} {}", function.full_path(), arg, x);
                    }
                    panic!("{}:{:?}", function.full_path(), expr);
                }
                panic!("{}:{:?}", function.full_path(), function.args);
            }
            _ => panic!("{:?}", x),
        }
    }
    Ok(())
}

fn resolve_full_path(path: &str, name: &str) -> String {
    if path.is_empty() {
        name.to_string()
    } else {
        format!("{}.{}", path, name)
    }
}
