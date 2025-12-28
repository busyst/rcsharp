use std::{collections::{HashMap, HashSet, VecDeque}, io::Read};

use ordered_hash_map::OrderedHashMap;
use rcsharp_lexer::lex_string_with_file_context;
use rcsharp_parser::{compiler_primitives::{BOOL_TYPE}, expression_parser::Expr, parser::{Attribute, GeneralParser, ParsedEnum, ParsedFunction, ParsedStruct, ParserResultExt, ParserType, Span, Stmt, StmtData}};

use crate::{compiler_essentials::{CodeGenContext, CompilerType, Enum, FlagManager, Function, LLVMVal, Struct, Variable, function_flags, struct_flags}, expression_compiler::{Expected, compile_expression, constant_expression_compiler}};

pub const LAZY_FUNCTION_COMPILE : bool = false; // For now false
pub const APPEND_DEBUG_FUNCTION_INFO : bool = true;
pub const DONT_INSERT_REDUNDAND_STRINGS : bool = true;
pub const INTERGER_EXPRESION_OPTIMISATION : bool = true;
pub type CompileResult<T> = Result<T, (Span, CompilerError)>;
#[derive(Debug)]
pub enum CompilerError {
    Generic(String),
    Io(std::io::Error),
    InvalidExpression(String),
    SymbolNotFound(String),
    TypeMismatch { expected: CompilerType, found: CompilerType },
    InvalidStatementInContext(String),
}
impl From<std::io::Error> for CompilerError {
    fn from(err: std::io::Error) -> Self {
        CompilerError::Io(err)
    }
}

pub fn rcsharp_compile_to_file(stmts: &[StmtData], full_path: &str) -> Result<(), String> {
    match rcsharp_compile(stmts, full_path) {
        Ok(llvm_ir) => {
            std::fs::write("output.ll", llvm_ir.build())
                .map_err(|e| e.to_string())
        }
        Err(e) => Err(format!("{:?}\n---------\nSTATEMENTS:\n{:?}", e.1, e.0.start..e.0.end)),
    }
}
pub fn rcsharp_compile(stmts: &[StmtData], absolute_file_path: &str) -> CompileResult<LLVMOutputHandler>  {
    let mut symbols = SymbolTable::new();
    let mut output = LLVMOutputHandler::default();
    output.push_str_header("target triple = \"x86_64-pc-windows-msvc\"\n");
    output.push_str_header(&format!(";{}\n", absolute_file_path));
    let mut enums = vec![];
    let mut structs = vec![];
    let mut functions = vec![];

    collect(stmts, &mut enums, &mut structs, &mut functions)?;
    handle_types(structs, &mut symbols, &mut output)?;
    handle_enums(enums, &mut symbols, &mut output)?;
    handle_functions(functions, &mut symbols, &mut output)?;
    compile(&mut symbols, &mut output)?;
    handle_generics(&mut symbols, &mut output)?;
    Ok(output)
}
fn collect(stmts: &[StmtData], 
    enums: &mut Vec<ParsedEnum>,
    structs : &mut Vec<ParsedStruct>,
    functions : &mut Vec<ParsedFunction>,
) -> CompileResult<()>{
    let mut statements: VecDeque<StmtData> = stmts.iter().cloned().collect(); 

    let mut current_path = Vec::new();
    let mut included_files: HashSet<String> = HashSet::new();

    while !statements.is_empty() {
        while let Some(x) = statements.pop_front() {
            if let Stmt::CompilerHint(attr) = &x.stmt {
                if attr.name_equals("include") {
                    if let Some(x) = attr.one_argument() {
                        if let Expr::StringConst(include_path) = x {
                            if included_files.contains(include_path) {
                                continue;
                            }
                            included_files.insert(include_path.clone());

                            let mut file = std::fs::File::open(include_path).unwrap();
                            let mut buf = String::new();
                            file.read_to_string(&mut buf).unwrap();
                            let lex = lex_string_with_file_context(&buf,include_path).unwrap();
                            let par = GeneralParser::new(&lex).parse_all().unwrap_error_extended(&lex, include_path).map_err(|x| {println!("{}", x); String::new()}).unwrap();
                            for stmt in par.into_iter().rev() {
                                statements.push_front(stmt);
                            }
                            continue;
                        }
                    }
                }
                if attr.name_equals("-pop") {
                    current_path.pop();
                    continue;
                }
                
                panic!("Invalid compiler hint in global context: {:?}", attr);
            }
            if let Stmt::Namespace(namespace, body) = x.stmt {
                current_path.push(namespace);
                statements.push_front(Stmt::CompilerHint(Attribute { name: "-pop".into(), arguments: Box::new([]), span: Span { start: 0, end: 0 } }).dummy_data());
                for stmt in body.iter().rev() {
                    statements.push_front(stmt.clone());
                }
                continue;
            }
            if let Stmt::Struct(mut parsed_struct) = x.stmt {
                parsed_struct.path = current_path.join(".").into();
                structs.push(parsed_struct);
                continue;
            }
            if let Stmt::Function(mut x) = x.stmt {
                x.path = current_path.join(".").into();
                functions.push(x);
                continue;
            }
            if let Stmt::Enum(mut parsed_enum) = x.stmt {
                parsed_enum.path = current_path.join(", ").into();
                enums.push(parsed_enum);
                continue;
            }
            
            return Err((x.span.clone(), CompilerError::InvalidStatementInContext(format!("{:?}", x))));
        }
    }
    Ok(())
}
fn handle_types(structs : Vec<ParsedStruct>, symbols: &mut SymbolTable, output: &mut LLVMOutputHandler) -> CompileResult<()>{
    let mut registered_types = vec![];
    for str in &structs {
        registered_types.push((str.path.to_string(), str.name.to_string()));
        let full_path = if str.path.is_empty() { str.name.to_string() } else { format!("{}.{}", str.path, str.name) };
        symbols.insert_type(&full_path, Struct::new_placeholder(str.path.to_string(), str.name.to_string(), if str.generic_params.is_empty() {
            0
        } else {
            struct_flags::GENERIC
        }));
    }

    for str in structs {
        let mut compiler_struct_fields = vec![];
        let path = str.path;
        let full_path = if path.is_empty() { str.name.to_string() } else { format!("{}.{}", path, str.name) };
        symbols.alias_types.clear();
        for prm in &str.generic_params {
            symbols.alias_types.insert(prm.clone(), CompilerType::GenericSubst(prm.to_string().into_boxed_str()));
        }
        for (name, attr_type) in str.fields {
            if let Some(pt) = attr_type.as_primitive_type() {
                compiler_struct_fields.push((name, CompilerType::Primitive(pt)));
                continue;
            }
            compiler_struct_fields.push((name, CompilerType::into_path(&attr_type, symbols, &path)?));
        }
        symbols.insert_type(&full_path, Struct::new(path, str.name, compiler_struct_fields.into_boxed_slice(), str.attributes, str.generic_params.clone()));
    }
    symbols.alias_types.clear();
    let user_defined_structs: Vec<&Struct> = symbols.types.values().map(|x| &x.1)
        .filter(|s: &&Struct| !s.is_primitive() && !s.is_generic())
        .collect();
    for s in user_defined_structs {
        let field_types: Vec<String> = s.fields
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
fn handle_enums(enums : Vec<ParsedEnum>, symbols: &mut SymbolTable, _output: &mut LLVMOutputHandler) -> CompileResult<()>{ 
    let mut registered_enums = vec![];
    for s in &enums {
        //let full_path = if s.0.is_empty() { s.2.0.clone() } else { format!("{}.{}", s.0, s.2.0) };
        registered_enums.push((s.path.clone(), s.name.clone()));
        //output.push_str(&format!("enum_{}\n", full_path));
    }
    for enm in enums {
        let (current_path, attrs, (enum_name, enum_type, fields)) = (enm.path, enm.attributes, (enm.name, enm.enum_type, enm.fields));
        let full_path = if current_path.is_empty() { enum_name.to_string() } else { format!("{}.{}", current_path, enum_name) };
        let mut compiler_enum_fields = vec![];
        if let Some(x) = enum_type.as_integer() {
            for (field_name, field_expr) in fields {
                if let Expr::Integer(int) = &field_expr {
                    compiler_enum_fields.push((field_name, LLVMVal::Constant(int.parse::<i128>().unwrap().to_string())));
                    continue;
                }
                compiler_enum_fields.push((field_name, constant_expression_compiler(&field_expr)?));
            }
            symbols.enums.insert(full_path, Enum::new(current_path, enum_name, CompilerType::Primitive(x), compiler_enum_fields.into_boxed_slice(), attrs));
            continue;
        }
        todo!("Not yet supported!")
    }
    Ok(())
}
fn handle_functions(functions : Vec<ParsedFunction>, symbols: &mut SymbolTable, _: &mut LLVMOutputHandler) -> CompileResult<()>{
    let mut registered_funcs = vec![];
    for s in &functions {
        let full_path = if s.path.is_empty() { s.name.to_string() } else { format!("{}.{}", s.path, s.name) };
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

        let args = pf.args.iter().map(|x| (x.0.clone(), CompilerType::into_path(&x.1, symbols, &current_path).unwrap() )).collect::<Box<[_]>>();
        let full_path = if current_path.is_empty() { function_name.to_string() } else { format!("{}.{}", current_path, function_name) };
        let function = Function::new(current_path, function_name, args, return_type, function_body, 0.into(), function_attrs, function_generics);
        if function_prefixes.iter().any(|x| x.as_str() == "public") {
            function.set_flag(function_flags::PUBLIC as u8);
        }
        if function_prefixes.iter().any(|x| x.as_str() == "inline") {
            function.set_flag(function_flags::INLINE as u8);
        }
        if function_prefixes.iter().any(|x| x.as_str() == "constexpr") {
            function.set_flag(function_flags::CONST_EXPRESSION as u8);
        }
        if function.attribs.iter().any(|x| x.name_equals("DllImport")) {
            function.set_flag(function_flags::IMPORTED as u8);
        }
        if !function.generic_params.is_empty() {
            function.set_flag(function_flags::GENERIC as u8);
        }
        symbols.insert_function(&full_path, function);
    }
    Ok(())
}
fn compile(symbols: &mut SymbolTable, output: &mut LLVMOutputHandler) -> CompileResult<()>{
    for (full_path, (id, _function)) in symbols.functions.iter().filter(|x| x.1.1.is_normal()) {
        compile_function_body(*id, full_path, symbols, output)?;
    }
    if APPEND_DEBUG_FUNCTION_INFO {
        for (full_path, (_id, function)) in symbols.functions.iter() {
            output.push_str_footer(&format!(";fn {} used times {}\n", full_path, function.times_used.get()));
        }
    }
    for (_, (_id, function)) in symbols.functions.iter().filter(|x| x.1.1.is_imported()) {
        if LAZY_FUNCTION_COMPILE && function.times_used.get() == 0 {
            continue;
        }
        // declare dllimport i32 @GetModuleFileNameA(i8*,i8*,i32)
        let rt = function.return_type.llvm_representation(symbols)?;
        let args = function.args.iter().map(|x| x.1.llvm_representation(symbols)).collect::<CompileResult<Vec<_>>>()?.join(", ");
        output.push_str_include_header(&format!("declare dllimport {} @{}({})\n", rt, function.name() , args));
    }
    Ok(())
}
fn compile_function_body(function_id: usize, full_function_name: &str, symbols: &SymbolTable, output: &mut LLVMOutputHandler) -> CompileResult<()>{
    fn collect_local_variables<'a>(stmts: &'a [StmtData], vars: &mut Vec<(&'a String, &'a ParserType)>) {
        for stmt in stmts {
            match &stmt.stmt {
                Stmt::Let(name, var_type, _) => {
                    vars.push((name, var_type));
                }
                Stmt::If(_, then_body, else_body) => {
                    collect_local_variables(then_body, vars);
                    collect_local_variables(else_body, vars);
                }
                Stmt::Loop(body) => {
                    collect_local_variables(body, vars);
                }
                _ => {}
            }
        }
    }
    let function = symbols.get_function_by_id(function_id);
    let current_namespace = &function.path;
    let mut rt = function.return_type.clone();
    rt.substitute_generic_types(&symbols.alias_types, symbols)?;
    let rt = rt.llvm_representation(symbols)?;
    let mut ctx = CodeGenContext::new(symbols, function_id);

    let args_str = function.args.iter()
    .map(|(name, ptype)| {
        {let mut ptype = ptype.clone(); ptype.substitute_generic_types(&symbols.alias_types, symbols)?; ptype}.llvm_representation(symbols)
            .map(|type_str| format!("{} %{}", type_str, name))
    })
    .collect::<CompileResult<Vec<_>>>()?
    .join(", ");

    output.push_str(&format!("define {} @{}({}){{\n", rt, full_function_name , args_str)); 
    let mut statically_declared_vars = vec![];
    collect_local_variables(&function.body, &mut statically_declared_vars);
    
    for (arg_name, arg_type) in function.args.iter() {
        let mut arg_type = arg_type.clone();
        arg_type.substitute_generic_types(&symbols.alias_types, symbols)?;
        ctx.scope.add_variable(arg_name.clone(), Variable::new_argument(arg_type), 0);
    }
    for (index, (name, ptype)) in statically_declared_vars.iter().enumerate() {
        let mut llvm_type = CompilerType::into_path(ptype, symbols, current_namespace)?;
        llvm_type.substitute_generic_types(&symbols.alias_types, symbols)?;
        let llvm_type = llvm_type.llvm_representation(symbols)?;
        output.push_str(&format!("    %v{} = alloca {}; var: {}\n", index, llvm_type, name));
    }

    for stmt in function.body.iter(){
        compile_statement(&stmt, &mut ctx, output)?;
    }
    if !matches!(function.body.last().map(|x| &x.stmt), Some(Stmt::Return(_))) {
        if function.return_type.is_void() {
            output.push_str("    ret void\n");
        } else {
            output.push_str("\n    unreachable\n");
        }   
    }
    output.push_str("}\n");
    Ok(())
}
pub fn compile_statement(stmt: &StmtData, ctx: &mut CodeGenContext, output: &mut LLVMOutputHandler) -> CompileResult<()>{
    let curent_function = ctx.symbols.get_function_by_id(ctx.current_function);
    let current_function_path = &curent_function.path;
    match &stmt.stmt {
        Stmt::ConstLet(name, var_type, expr) => {
            let var_type = CompilerType::into_path(var_type, ctx.symbols, current_function_path)?;
            let var = Variable::new(var_type.clone(), true);
            var.set_value(Some(compile_expression(expr, Expected::Type(&var_type), ctx, output)?.get_llvm_rep().clone()));
            ctx.scope.add_variable(name.clone(), var, 0);
        }
        Stmt::Let(name, var_type, expr) => {
            let x = ctx.aquire_unique_variable_index();
            let mut var_type = CompilerType::into_path(var_type, ctx.symbols, current_function_path)?;
            var_type.substitute_generic_types(&ctx.symbols.alias_types, ctx.symbols)?;
            let var = Variable::new(var_type.clone(), false);
            if let Some(init_expr) = expr {
                let result = compile_expression(init_expr, Expected::Type(&var_type), ctx, output)?;
                if &var_type != result.get_type() {
                    return Err((stmt.span, CompilerError::InvalidExpression(format!("Type mismatch in assignment: {:?} and {:?}", var_type, result))));
                }
                ctx.scope.add_variable(name.clone(), var, x);
                let t = var_type.llvm_representation(ctx.symbols)?;
                output.push_str(&format!("    store {} {}, {}* {}\n", t, result.get_llvm_rep(), t, LLVMVal::Variable(x)));
            }else {
                ctx.scope.add_variable(name.clone(), var, x);
            }

        }
        Stmt::Expr(expression) => {
            compile_expression(expression, Expected::NoReturn, ctx, output).map_err(|x| (stmt.span, x.1))?;
        }
        Stmt::Loop(statement) =>{
            let lc = ctx.aquire_unique_logic_counter();
            
            output.push_str(&format!("    br label %loop_body{}\n", lc));
            output.push_str(&format!("loop_body{}:\n", lc));
            ctx.scope.enter_scope();
            ctx.scope.set_loop_index(Some(lc));
            for x in statement {
                compile_statement(&x, ctx, output)?;
            }
            ctx.scope.exit_scope();
            output.push_str(&format!("    br label %loop_body{}\n", lc));
            output.push_str(&format!("loop_body{}_exit:\n", lc));
        }
        Stmt::Continue => {
            if let Some(li) = ctx.scope.loop_index() {
                output.push_str(&format!("    br label %loop_body{}\n", li));
                return Ok(());
            }
            return Err((stmt.span, CompilerError::InvalidStatementInContext("Tried to continue without loop".to_string())));
        }
        Stmt::Break => {
            if let Some(li) = ctx.scope.loop_index() {
                output.push_str(&format!("    br label %loop_body{}_exit\n", li));
                return Ok(());
            }
            return Err((stmt.span, CompilerError::InvalidStatementInContext("Tried to break without loop".to_string())));
        }
        Stmt::Return(opt_expr) =>{
            let func = ctx.symbols.get_function_by_id(ctx.current_function);
            let return_type = {let mut a = func.return_type.clone(); a.substitute_generic_types(&ctx.symbols.alias_types, ctx.symbols)?; a};
            if opt_expr.is_some() && return_type.is_void() {
                return Err((stmt.span, CompilerError::Generic(format!("Function {} does not return anything", format!("{}.{}", func.path() , func.name())))));
            }
            if let Some(expr) = opt_expr {
                let value = compile_expression(expr, Expected::Type(&return_type), ctx, output)?;
                if value.get_type() != &return_type {
                    return Err((stmt.span, CompilerError::TypeMismatch { expected: return_type.clone(), found: value.get_type().clone() }));
                }
                let llvm_type_str = return_type.llvm_representation(ctx.symbols)?;
                output.push_str(&format!("    ret {} {}\n", llvm_type_str, value.get_llvm_rep()));
            } else {
                if !return_type.is_void() {
                    return Err((stmt.span, CompilerError::Generic("Cannot return without a value from a non-void function.".to_string())));
                }
                output.push_str("    ret void\n");
            }
        }
        Stmt::If(condition, then_body, else_body) => {
            let bool_type = CompilerType::Primitive(BOOL_TYPE);
            let cond_val = compile_expression(condition, Expected::Type(&bool_type), ctx, output)?;

            if cond_val.get_type() != &bool_type {
                return Err((stmt.span, CompilerError::InvalidExpression(format!("'{:?}' must result in bool, instead resulted in {:?}", condition, cond_val.get_type()))));
            }

            let logic_id = ctx.aquire_unique_logic_counter();
            let then_label = format!("then{}", logic_id);
            let else_label = format!("else{}", logic_id);
            let end_label = format!("endif{}", logic_id);
            
            let target_else = if else_body.is_empty() { &end_label } else { &else_label };
            output.push_str(&format!("    br i1 {}, label %{}, label %{}\n", cond_val.get_llvm_rep(), then_label, target_else));

            output.push_str(&format!("{}:\n", then_label));
            ctx.scope.enter_scope();
            for then_stmt in then_body {
                compile_statement(&then_stmt, ctx, output)?;
            }
            ctx.scope.exit_scope();
            output.push_str(&format!("    br label %{}\n", end_label));

            if !else_body.is_empty() {
                output.push_str(&format!("{}:\n", else_label));
                ctx.scope.enter_scope();
                for else_stmt in else_body {
                    compile_statement(&else_stmt, ctx, output)?;
                }
                ctx.scope.exit_scope();
                output.push_str(&format!("    br label %{}\n", end_label));
            }

            output.push_str(&format!("{}:\n", end_label));
        }
        Stmt::Function(..) | Stmt::Struct(..) | Stmt::Enum(..) | Stmt::Namespace(..) | Stmt::CompilerHint(..) => {
            return Err((stmt.span, CompilerError::InvalidStatementInContext(format!("{:?}", stmt))));
        }
    }
    Ok(())
}
fn handle_generics(symbols: &mut SymbolTable, output: &mut LLVMOutputHandler) -> CompileResult<()> {
    let mut implemented_funcs = HashMap::new();
    let mut implemented_types = HashMap::new();
    for (_, (id, _)) in symbols.functions.iter().filter(|x| x.1.1.is_generic()) {
        implemented_funcs.insert(*id, 0usize);
    }
    for (_, (id, _)) in symbols.types.iter().filter(|x| x.1.1.is_generic()) {
        implemented_types.insert(*id, 0usize);
    }
    loop {
        let mut new= false;
        for (id, func) in symbols.functions.values().filter(|x| x.1.is_generic()) {
            let gi = func.generic_implementations.borrow();
            let len = gi.len();
            drop(gi);
            if let Some(x) = implemented_funcs.get_mut(id) {
                if *x != len{
                    new = true;
                    let cursor = *x;
                    for impl_ind in cursor..len {
                        let x= func.call_path_impl_index(impl_ind, symbols);
                        let gi = func.generic_implementations.borrow();
                        let mut type_map = HashMap::new();
                        for (ind, prm) in func.generic_params.iter().enumerate() {
                            type_map.insert(prm.clone(), gi[impl_ind][ind].clone());
                        }
                        drop(gi);
                        symbols.alias_types = type_map;
                        compile_function_body(*id, &x, symbols, output)?;
                    }

                    *x = len;

                }
            }else {
                unreachable!()
            }
        }
        for (id, sym_type) in symbols.types.values().filter(|x| x.1.is_generic()) {
            let gi = sym_type.generic_implementations.borrow();
            let len = gi.len();
            drop(gi);
            if let Some(x) = implemented_types.get_mut(id) {
                if *x != len{
                    new = true;
                    let cursor = *x;
                    for impl_ind in cursor..len {
                        let x= sym_type.llvm_repr_index(impl_ind, symbols);
                        let gi = sym_type.generic_implementations.borrow();
                        let mut type_map = HashMap::new();
                        for (ind, prm) in sym_type.generic_params.iter().enumerate() {
                            type_map.insert(prm.clone(), gi[impl_ind][ind].clone());
                        }
                        drop(gi);
                        let internals: String = sym_type.fields.iter().map(|x| {let mut c = x.1.clone(); c.substitute_generic_types(&type_map, symbols).and_then(|()| c.llvm_representation(symbols))}).collect::<CompileResult<Vec<_>>>()?.join(", ");
                        output.push_str_header(&format!("{} = type {{ {} }}\n", x, internals));

                    }
                    *x = len;
                }
            }else {
                unreachable!()
            }
        }
        
        if !new {
            break;
        }
    }
    Ok(())
}

#[derive(Debug, PartialEq)]
enum StringEntry {
    Owned(String),
    Suffix {
        parent_index: usize,
        byte_offset: usize,
        length_with_null: usize,
        content: String,
    },
}

#[derive(Debug, Default)]
pub struct LLVMOutputHandler{
    header: String,
    strings_header: Vec<StringEntry>,
    include_header: String,
    main: String,
    footer: String,
}
impl LLVMOutputHandler {
    pub fn push_str(&mut self, s: &str) {
        self.main.push_str(s);
    }
    pub fn push_str_include_header(&mut self, s: &str) {
        self.include_header.push_str(s);
    }
    pub fn push_str_header(&mut self, s: &str) {
        self.header.push_str(s);
    }
    pub fn push_str_footer(&mut self, s: &str) {
        self.footer.push_str(s);
    }
    pub fn add_to_strings_header(&mut self, string: String) -> usize{
        if DONT_INSERT_REDUNDAND_STRINGS {
            if let Some(id) = self.strings_header.iter().position(|entry| {
                match entry {
                    StringEntry::Owned(s) => s == &string,
                    StringEntry::Suffix { content, .. } => content == &string,
                }
            }) {
                return id;
            }
            
            let suffix_match = self.strings_header.iter().enumerate().find_map(|(idx, entry)| {
                let (existing_str, actual_parent_idx, base_offset) = match entry {
                    StringEntry::Owned(s) => (s, idx, 0),
                    StringEntry::Suffix { parent_index, byte_offset, content, .. } => (content, *parent_index, *byte_offset),
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
                            length_with_null : len_with_null,
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

        format!("{}\n{}\n{}\n{}\n{}", self.header, self.include_header, definitions, self.main, self.footer)
    }
}


#[derive(Debug, Default)]
pub struct SymbolTable {
    pub functions: OrderedHashMap<String, (usize, Function)>,
    pub types: OrderedHashMap<String, (usize, Struct)>,
    pub alias_types: HashMap<String, CompilerType>,
    pub enums: OrderedHashMap<String, Enum>,
}
impl SymbolTable {
    pub fn new() -> Self {
        Self::default()
    }
    
    pub fn get_type_by_id(&self, type_id: usize) -> &Struct {
        self.types.values().filter(|x| x.0 == type_id).nth(0).map(|x| &x.1).expect("Unexpected")
    }
    
    pub fn get_function_by_id(&self, function_id: usize) -> &Function {
        self.functions.values().filter(|x| x.0 == function_id).nth(0).map(|x| &x.1).expect("Unexpected")
    }
    
    pub fn get_type_id(&self, fqn: &str) -> Option<usize> {
        self.types.iter().position(|x| x.0 == fqn)
    }
    pub fn get_enum_type(&self, fqn: &str) -> Option<&CompilerType> {
        self.enums.iter().filter(|x| x.0 == fqn).nth(0).map(|x| &x.1.base_type)
    }
    pub fn get_function_id(&self, fqn: &str) -> Option<usize> {
        self.functions.iter().position(|x| x.0 == fqn)
    }
    pub fn insert_type(&mut self, full_path: &str, structure: Struct) {
        if let Some(x) = self.types.get_mut(full_path) {
            x.1 = structure;
            return;
        }
        self.types.insert(full_path.to_string(), (self.types.len(), structure));
    }
    pub fn insert_function(&mut self, full_path: &str, function: Function) {
        if let Some(x) = self.functions.get_mut(full_path) {
            x.1 = function;
            return;
        }
        self.functions.insert(full_path.to_string(), (self.functions.len(), function));
    }
}
