use std::{
    collections::{HashMap, HashSet, VecDeque},
    io::Read,
    time::{Duration, Instant},
};

use ordered_hash_map::OrderedHashMap;
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
        function_flags, struct_flags, CodeGenContext, CompileResult, CompileResultExt,
        CompilerError, CompilerType, Enum, FlagManager, Function, LLVMVal, Struct, Variable,
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
        let t = CompilerType::into_path(&x.2, symbols, &x.0)?;
        output.push_str_global(&format!(
            "@{} = internal global {} zeroinitializer",
            fp,
            t.llvm_representation(symbols)?
        ));
        println!("ST:{}", fp);
        symbols
            .static_variables
            .insert(fp, Variable::new_static(t, false));
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
                            println!("{:?}", e);
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
                            CompilerError::InvalidStatementInContext(
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
                        CompilerError::InvalidStatementInContext(format!(
                            "Unknown global attribute: {:?}",
                            attr
                        )),
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
                    CompilerError::InvalidStatementInContext(format!("{:?}", stmt_data.stmt)),
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
        let full_path = if str.path.is_empty() {
            str.name.to_string()
        } else {
            format!("{}.{}", str.path, str.name)
        };
        symbols.insert_type(
            &full_path,
            Struct::new_placeholder(
                str.path.to_string(),
                str.name.to_string(),
                if str.generic_params.is_empty() {
                    0
                } else {
                    struct_flags::GENERIC
                },
            ),
        );
    }

    for str in structs {
        let mut compiler_struct_fields = vec![];
        let path = str.path;
        let full_path = if path.is_empty() {
            str.name.to_string()
        } else {
            format!("{}.{}", path, str.name)
        };
        symbols.alias_types.clear();
        for prm in &str.generic_params {
            symbols.alias_types.insert(
                prm.clone(),
                CompilerType::GenericSubst(prm.to_string().into_boxed_str()),
            );
        }
        for (name, attr_type) in str.fields {
            if let Some(pt) = attr_type.as_primitive_type() {
                compiler_struct_fields.push((name, CompilerType::Primitive(pt)));
                continue;
            }
            compiler_struct_fields
                .push((name, CompilerType::into_path(&attr_type, symbols, &path)?));
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
    symbols.alias_types.clear();
    let user_defined_structs: Vec<&Struct> = symbols
        .types
        .values()
        .map(|x| &x.1)
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
        let full_path = if current_path.is_empty() {
            enum_name.to_string()
        } else {
            format!("{}.{}", current_path, enum_name)
        };
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
        todo!("Not yet supported!")
    }
    Ok(())
}
fn handle_functions(
    functions: Vec<ParsedFunction>,
    symbols: &mut SymbolTable,
    output: &mut LLVMOutputHandler,
) -> CompileResult<()> {
    let mut registered_funcs = vec![];
    for s in &functions {
        let full_path = if s.path.is_empty() {
            s.name.to_string()
        } else {
            format!("{}.{}", s.path, s.name)
        };
        registered_funcs.push(full_path);
    }
    for pf in functions {
        let current_path = pf.path;
        let function_name = pf.name;
        let function_prefixes = pf.prefixes;
        let function_attrs = pf.attributes;
        let function_generics = pf.generic_params;
        let function_body = pf.body;
        let return_type = CompilerType::into_path(&pf.return_type, symbols, &current_path)?;

        let args = pf
            .args
            .iter()
            .map(|x| {
                (
                    x.0.clone(),
                    CompilerType::into_path(&x.1, symbols, &current_path).unwrap(),
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

        if function_prefixes.iter().any(|x| x.as_str() == "public") {
            function.set_flag(function_flags::PUBLIC);
        }
        if function_prefixes.iter().any(|x| x.as_str() == "inline") {
            function.set_flag(function_flags::INLINE);
        }
        if function_prefixes.iter().any(|x| x.as_str() == "constexpr") {
            function.set_flag(function_flags::CONST_EXPRESSION);
        }
        if !function.generic_params.is_empty() {
            function.set_flag(function_flags::GENERIC);
        }
        symbols.insert_function(&function.full_path().to_string(), function);
    }
    for x in &symbols.functions {
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
            .functions
            .iter()
            .filter(|x| x.1 .1.is_normal() && x.1 .1.times_used.get() > 0)
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
    for (_, (_id, function)) in symbols.functions.iter().filter(|x| x.1 .1.is_external()) {
        if function.times_used.get() == 0 {
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
        for (full_path, (_id, function)) in symbols.functions.iter() {
            output.push_str_footer(&format!(
                ";fn {} used times {}\n",
                full_path,
                function.times_used.get()
            ));
        }
    }
    Ok(())
}
fn compile(symbols: &mut SymbolTable, output: &mut LLVMOutputHandler) -> CompileResult<()> {
    for (full_path, (id, _function)) in symbols.functions.iter().filter(|x| x.1 .1.is_normal()) {
        compile_function_body(*id, full_path, symbols, output)?;
    }
    if APPEND_DEBUG_FUNCTION_INFO {
        for (full_path, (_id, function)) in symbols.functions.iter() {
            output.push_str_footer(&format!(
                ";fn {} used times {}\n",
                full_path,
                function.times_used.get()
            ));
        }
    }
    for (_, (_id, function)) in symbols.functions.iter().filter(|x| x.1 .1.is_external()) {
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
    rt.substitute_generic_types(&symbols.alias_types, symbols)?;
    let rt = rt.llvm_representation(symbols)?;
    let mut ctx = CodeGenContext::new(symbols, function_id);

    let args_str = function
        .args
        .iter()
        .map(|(name, ptype)| {
            {
                let mut ptype = ptype.clone();
                ptype.substitute_generic_types(&symbols.alias_types, symbols)?;
                ptype
            }
            .llvm_representation(symbols)
            .map(|type_str| format!("{} %{}", type_str, name))
        })
        .collect::<CompileResult<Vec<_>>>()?
        .join(", ");

    output.push_main(&format!(
        "define {} @{}({}){{\n",
        rt, full_function_name, args_str
    ));

    for (arg_name, arg_type) in function.args.iter() {
        let mut arg_type = arg_type.clone();
        arg_type.substitute_generic_types(&symbols.alias_types, symbols)?;
        ctx.scope
            .add_variable(arg_name.clone(), Variable::new_argument(arg_type), 0);
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
    if !matches!(function.body.last().map(|x| &x.stmt), Some(Stmt::Return(_))) {
        if function.return_type.is_void() {
            output.push_str("    ret void\n");
        } else {
            output.push_str("\n    unreachable\n");
        }
    }
    output.push_main(&output.function_intro.clone());
    output.push_main(&output.function_body.clone());
    output.push_main("}\n");
    output.function_intro.clear();
    output.function_body.clear();
    Ok(())
}
pub fn compile_statement(
    stmt: &StmtData,
    ctx: &mut CodeGenContext,
    output: &mut LLVMOutputHandler,
) -> CompileResult<()> {
    let current_function_path = ctx.current_function_path();
    match &stmt.stmt {
        Stmt::ConstLet(name, var_type, expr) => {
            let mut var_type =
                CompilerType::into_path(var_type, ctx.symbols, current_function_path)?;
            var_type.substitute_generic_types(&ctx.symbols.alias_types, ctx.symbols)?;
            let var = Variable::new(var_type.clone(), true);

            let result =
                compile_expression(expr, Expected::Type(&var_type), stmt.span, ctx, output)?;
            if *result.get_type() != var_type {
                return Err((
                    stmt.span,
                    CompilerError::InvalidExpression(format!(
                        "Type mismatch in assignment: {:?} and {:?}",
                        var_type, result
                    )),
                )
                    .into());
            }
            var.set_value(Some(result.get_llvm_rep().clone()));
            ctx.scope.add_variable(name.clone(), var, 0);
        }
        Stmt::Let(name, var_type, expr) => {
            let mut var_type =
                CompilerType::into_path(var_type, ctx.symbols, current_function_path)?;
            var_type.substitute_generic_types(&ctx.symbols.alias_types, ctx.symbols)?;
            let var = Variable::new(var_type.clone(), false);
            let x = ctx.aquire_unique_variable_index();
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
                    if &var_type != result.get_type() {
                        return Err((
                            stmt.span,
                            CompilerError::InvalidExpression(format!(
                                "Type mismatch in assignment: {:?} and {:?}",
                                var_type, result
                            )),
                        )
                            .into());
                    }
                    ctx.scope.add_variable(name.clone(), var, x);
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
                    ctx.scope.add_variable(name.clone(), var, x);
                }
            }
        }
        Stmt::Static(_name, var_type, _expr) => {
            let mut var_type =
                CompilerType::into_path(var_type, ctx.symbols, current_function_path)?;
            var_type.substitute_generic_types(&ctx.symbols.alias_types, ctx.symbols)?;
            let _var = Variable::new_static(var_type.clone(), false);
            todo!()
        }

        Stmt::Expr(expression) => {
            compile_expression(expression, Expected::NoReturn, stmt.span, ctx, output)?;
        }
        Stmt::Loop(statement) => {
            let lc = ctx.aquire_unique_logic_counter();

            output.push_str(&format!("    br label %loop_body{}\n", lc));
            output.push_str(&format!("loop_body{}:\n", lc));
            ctx.scope.enter_scope();
            ctx.scope.set_loop_index(Some(lc));
            for x in statement {
                compile_statement(x, ctx, output)?;
                if DONT_COMPILE_AFTER_RETURN && matches!(x.stmt, Stmt::Return(..)) {
                    break;
                };
            }
            ctx.scope.exit_scope();
            output.push_str(&format!("    br label %loop_body{}\n", lc));
            output.push_str(&format!("loop_body{}_exit:\n", lc));
        }
        Stmt::Continue => match ctx.scope.loop_index() {
            Some(li) => {
                output.push_str(&format!("    br label %loop_body{}\n", li));
                return Ok(());
            }
            None => {
                return Err((
                    stmt.span,
                    CompilerError::InvalidStatementInContext(
                        "Tried to continue without loop".to_string(),
                    ),
                )
                    .into())
            }
        },
        Stmt::Break => match ctx.scope.loop_index() {
            Some(li) => {
                output.push_str(&format!("    br label %loop_body{}_exit\n", li));
                return Ok(());
            }
            None => {
                return Err((
                    stmt.span,
                    CompilerError::InvalidStatementInContext(
                        "Tried to break without loop".to_string(),
                    ),
                )
                    .into())
            }
        },
        Stmt::Return(opt_expr) => {
            let function = ctx.current_function();
            let return_type = {
                function
                    .return_type
                    .with_substituted_generic_types(&ctx.symbols.alias_types, ctx.symbols)?
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
                let value =
                    compile_expression(expr, Expected::Type(&return_type), stmt.span, ctx, output)?;
                if value.get_type() != &return_type {
                    return Err((
                        stmt.span,
                        CompilerError::TypeMismatch {
                            expected: return_type.clone(),
                            found: value.get_type().clone(),
                        },
                    )
                        .into());
                }
                let llvm_type_str = return_type.llvm_representation(ctx.symbols)?;
                output.push_str(&format!(
                    "    ret {} {}\n",
                    llvm_type_str,
                    value.get_llvm_rep()
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

            if cond_val.get_type() != &bool_type {
                return Err((
                    stmt.span,
                    CompilerError::InvalidExpression(format!(
                        "'{:?}' must result in bool, instead resulted in {:?}",
                        condition,
                        cond_val.get_type()
                    )),
                )
                    .into());
            }

            let logic_id = ctx.aquire_unique_logic_counter();
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
            ctx.scope.enter_scope();
            for then_stmt in then_body {
                compile_statement(then_stmt, ctx, output)?;
                if DONT_COMPILE_AFTER_RETURN && matches!(then_stmt.stmt, Stmt::Return(..)) {
                    break;
                };
            }
            ctx.scope.exit_scope();
            output.push_str(&format!("    br label %{}\n", end_label));

            if !else_body.is_empty() {
                output.push_str(&format!("{}:\n", else_label));
                ctx.scope.enter_scope();
                for else_stmt in else_body {
                    compile_statement(else_stmt, ctx, output)?;
                    if DONT_COMPILE_AFTER_RETURN && matches!(else_stmt.stmt, Stmt::Return(..)) {
                        break;
                    };
                }
                ctx.scope.exit_scope();
                output.push_str(&format!("    br label %{}\n", end_label));
            }

            output.push_str(&format!("{}:\n", end_label));
        }
        Stmt::Function(..)
        | Stmt::Struct(..)
        | Stmt::Enum(..)
        | Stmt::Namespace(..)
        | Stmt::CompilerHint(..) => {
            return Err((
                stmt.span,
                CompilerError::InvalidStatementInContext(format!("{:?}", stmt)),
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
        for (id, func) in symbols.functions.values() {
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
        for (id, strct) in symbols.types.values() {
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
                    func.call_path_impl_index(impl_index, symbols),
                    func.generic_params.clone(),
                )
            };
            let mut type_map = HashMap::new();
            for (idx, prm) in generic_params.iter().enumerate() {
                if let Some(concrete_type) = concrete_types.get(idx) {
                    type_map.insert(prm.clone(), concrete_type.clone());
                }
            }
            symbols.alias_types = type_map;
            compile_function_body(id, &specialized_name, symbols, output)?;
        }
        symbols.alias_types.clear();
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
                let substituted_type =
                    field_type.with_substituted_generic_types(&type_map, symbols)?;
                field_strings.push(substituted_type.llvm_representation(symbols)?);
            }
            let body = field_strings.join(", ");
            output.push_str_header(&format!("{} = type {{ {} }}\n", specialized_name, body));
        }
    }
    Ok(any_new)
}
#[allow(unused)]
fn fn_attribs_handler(
    function: &Function,
    function_id: usize,
    symbols: &SymbolTable,
    output: &mut LLVMOutputHandler,
) -> CompileResult<()> {
    for x in function.attribs() {
        match &*x.name {
            "DllImport" => {
                function.set_flag(function_flags::EXTERNAL);
            }
            "no_lazy" => {
                if function.times_used.get() == 0 {
                    function.use_fn();
                }
            }
            "ExtentionOf" => {
                let expr = x.one_argument().expect("Expected ony one argument");
                if let Some(arg) = function.args.get(0).map(|x| &x.1) {
                    if let Expr::Name(name) = expr {
                        let x = symbols
                            .get_type_id(&format!("{}.{}", function.path(), name))
                            .or(symbols.get_type_id(name))
                            .expect("Type not found");
                        if arg.is_base_equal_to(x) {
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

#[derive(PartialEq)]
enum StringEntry {
    Owned(String),
    Suffix {
        parent_index: usize,
        byte_offset: usize,
        length_with_null: usize,
        content: String,
    },
}

#[derive(Default)]
pub struct LLVMOutputHandler {
    header: String,
    global_variables: String,
    strings_header: Vec<StringEntry>,
    include_header: String,
    main: String,
    footer: String,

    function_intro: String,
    function_body: String,
}
impl LLVMOutputHandler {
    pub fn push_str(&mut self, s: &str) {
        self.function_body.push_str(s);
    }
    pub fn push_main(&mut self, s: &str) {
        self.main.push_str(s);
    }
    pub fn push_function_intro(&mut self, s: &str) {
        self.function_intro.push_str(s);
    }
    pub fn push_str_include_header(&mut self, s: &str) {
        self.include_header.push_str(s);
    }
    pub fn push_str_header(&mut self, s: &str) {
        self.header.push_str(s);
    }
    pub fn push_str_global(&mut self, s: &str) {
        self.global_variables.push_str(s);
    }
    pub fn push_str_footer(&mut self, s: &str) {
        self.footer.push_str(s);
    }
    pub fn add_to_strings_header(&mut self, string: String) -> usize {
        if DONT_INSERT_REDUNDAND_STRINGS {
            if let Some(id) = self.strings_header.iter().position(|entry| match entry {
                StringEntry::Owned(s) => s == &string,
                StringEntry::Suffix { content, .. } => content == &string,
            }) {
                return id;
            }

            let suffix_match = self
                .strings_header
                .iter()
                .enumerate()
                .find_map(|(idx, entry)| {
                    let (existing_str, actual_parent_idx, base_offset) = match entry {
                        StringEntry::Owned(s) => (s, idx, 0),
                        StringEntry::Suffix {
                            parent_index,
                            byte_offset,
                            content,
                            ..
                        } => (content, *parent_index, *byte_offset),
                    };

                    if existing_str.ends_with(&string) && existing_str.len() > string.len() {
                        let offset_diff = existing_str.len() - string.len();
                        let absolute_offset = base_offset + offset_diff;
                        Some((actual_parent_idx, absolute_offset))
                    } else {
                        None
                    }
                });

            if let Some((parent_index, byte_offset)) = suffix_match {
                let len_with_null = string.len() + 1;
                self.strings_header.push(StringEntry::Suffix {
                    parent_index,
                    byte_offset,
                    length_with_null: len_with_null,
                    content: string,
                });
                return self.strings_header.len() - 1;
            }
        }
        self.strings_header.push(StringEntry::Owned(string.clone()));
        let new_index = self.strings_header.len() - 1;
        if DONT_INSERT_REDUNDAND_STRINGS {
            for i in 0..new_index {
                if let StringEntry::Owned(old_content) = &self.strings_header[i] {
                    if string.ends_with(old_content) && string.len() > old_content.len() {
                        let offset = string.len() - old_content.len();
                        let len_with_null = old_content.len() + 1;
                        self.strings_header[i] = StringEntry::Suffix {
                            parent_index: new_index,
                            byte_offset: offset,
                            length_with_null: len_with_null,
                            content: old_content.clone(),
                        };
                    }
                }
            }
        }
        new_index
    }
    pub fn build(self) -> String {
        let definitions = self.strings_header.iter().enumerate().map(|(index, entry)| {
            match entry {
                StringEntry::Owned(s) => {
                    let escaped_val = s.replace("\"", "\\22")
                        .replace("\n", "\\0A")
                        .replace("\r", "\\0D")
                        .replace("\t", "\\09");
                    let str_len = s.len() + 1;
                    format!("@.str.{} = private unnamed_addr constant [{} x i8] c\"{}\\00\"", index, str_len, escaped_val)
                }
                StringEntry::Suffix { parent_index, byte_offset, length_with_null, .. } => {
                    let mut root_index = *parent_index;
                    let mut total_offset = *byte_offset;
                    let mut loops = 0;
                    while let StringEntry::Suffix { parent_index: next_p, byte_offset: next_off, .. } = &self.strings_header[root_index] {
                        root_index = *next_p;
                        total_offset += next_off;
                        loops += 1;
                        if loops > 100 { panic!("Circular string dependency detected at index {}", index); }
                    }
                    let root_len = match &self.strings_header[root_index] {
                        StringEntry::Owned(s) => s.len() + 1,
                        _ => panic!("String dependency chain did not end in Owned at index {}", root_index),
                    };
                    format!(
                        "@.str.{} = private unnamed_addr alias [{} x i8], [{} x i8]* bitcast (i8* getelementptr inbounds ([{} x i8], [{} x i8]* @.str.{}, i64 0, i64 {}) to [{} x i8]*)",
                        index,
                        length_with_null,
                        length_with_null,
                        root_len, root_len, root_index, total_offset,
                        length_with_null
                    )
                }
            }
        }).collect::<Vec<String>>().join("\n");

        format!(
            "{}\n{}\n{}\n{}\n{}\n{}",
            self.header,
            self.include_header,
            definitions,
            self.global_variables,
            self.main,
            self.footer
        )
    }
}

#[derive(Default)]
pub struct SymbolTable {
    functions: OrderedHashMap<String, (usize, Function)>,
    types: OrderedHashMap<String, (usize, Struct)>,
    alias_types: HashMap<String, CompilerType>,
    enums: OrderedHashMap<String, (usize, Enum)>,
    static_variables: OrderedHashMap<String, Variable>,
}
impl SymbolTable {
    pub fn get_type_by_id(&self, type_id: usize) -> &Struct {
        self.types
            .values()
            .filter(|x| x.0 == type_id)
            .nth(0)
            .map(|x| &x.1)
            .expect("Unexpected")
    }
    pub fn get_function_by_id(&self, function_id: usize) -> &Function {
        if let Some(func) = self
            .functions
            .values()
            .filter(|x| x.0 == function_id)
            .nth(0)
        {
            return &func.1;
        }
        unreachable!()
    }
    pub fn get_function_by_id_use(&self, function_id: usize) -> &Function {
        if let Some(func) = self
            .functions
            .values()
            .filter(|x| x.0 == function_id)
            .nth(0)
        {
            func.1.use_fn();
            return &func.1;
        }
        unreachable!()
    }
    pub fn get_enum_by_id(&self, enum_id: usize) -> &Enum {
        self.enums
            .values()
            .filter(|x| x.0 == enum_id)
            .nth(0)
            .map(|x| &x.1)
            .expect("Unexpected")
    }

    pub fn get_type_id(&self, fqn: &str) -> Option<usize> {
        self.types.iter().position(|x| x.0 == fqn)
    }
    pub fn get_function_id(&self, fqn: &str) -> Option<usize> {
        self.functions.iter().position(|x| x.0 == fqn)
    }
    pub fn get_enum_id(&self, fqn: &str) -> Option<usize> {
        self.enums.iter().position(|x| x.0 == fqn)
    }

    pub fn get_type(&self, fqn: &str) -> Option<&Struct> {
        self.get_type_id(fqn).map(|x| self.get_type_by_id(x))
    }
    pub fn get_function(&self, fqn: &str) -> Option<&Function> {
        self.get_function_id(fqn)
            .map(|x| self.get_function_by_id(x))
    }
    pub fn get_enum(&self, fqn: &str) -> Option<&Enum> {
        self.get_enum_id(fqn).map(|x| self.get_enum_by_id(x))
    }
    pub fn get_static_var(&self, fqn: &str) -> Option<&Variable> {
        self.static_variables.get(fqn)
    }
    pub fn insert_type(&mut self, full_path: &str, structure: Struct) {
        if let Some(x) = self.types.get_mut(full_path) {
            x.1 = structure;
            return;
        }
        self.types
            .insert(full_path.to_string(), (self.types.len(), structure));
    }
    pub fn insert_function(&mut self, full_path: &str, function: Function) {
        if let Some(x) = self.functions.get_mut(full_path) {
            x.1 = function;
            return;
        }
        self.functions
            .insert(full_path.to_string(), (self.functions.len(), function));
    }
    pub fn insert_enum(&mut self, full_path: &str, enum_type: Enum) {
        if let Some(x) = self.enums.get_mut(full_path) {
            x.1 = enum_type;
            return;
        }
        self.enums
            .insert(full_path.to_string(), (self.enums.len(), enum_type));
    }
    pub fn alias_types(&self) -> &HashMap<String, CompilerType> {
        &self.alias_types
    }
}
