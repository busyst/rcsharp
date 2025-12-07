use core::str;
use std::cell::Cell;
use std::collections::{HashMap, HashSet, VecDeque};
use std::{io::Read};
use ordered_hash_map::OrderedHashMap;
use rcsharp_lexer::lex_string_with_file_context;
use rcsharp_parser::compiler_primitives::{PRIMITIVE_TYPES_INFO, find_primitive_type};
use rcsharp_parser::expression_parser::Expr;
use rcsharp_parser::parser::{Attribute, GeneralParser, ParsedFunction, ParserType, Stmt};
use crate::compiler_essentials::{Enum, Function, FunctionFlags, FunctionView, Scope, Struct, StructView, Variable};
use crate::expression_compiler::{Expected, compile_expression, constant_integer_expression_compiler};

pub const LAZY_FUNCTION_COMPILE : bool = true;
pub const APPEND_DEBUG_FUNCTION_INFO : bool = true;
pub const DONT_INSERT_REDUNDAND_STRINGS : bool = true;

#[derive(Debug)]
pub enum CompileError {
    Io(std::io::Error),
    DuplicateSymbol(String),
    SymbolNotFound(String),
    TypeMismatch {
        expected: ParserType,
        found: ParserType,
    },
    InvalidStatementInContext(String),
    InvalidExpression(String),
    InvalidEnumBaseType(String),
    Generic(String),
}
impl std::fmt::Display for CompileError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            CompileError::Io(e) => write!(f, "IO Error: {}", e),
            CompileError::DuplicateSymbol(name) => write!(f, "Symbol '{}' is already defined", name),
            CompileError::SymbolNotFound(name) => write!(f, "Symbol '{}' not found in the current scope", name),
            CompileError::TypeMismatch { expected, found } => write!(f, "Type mismatch: expected {:?}, found {:?}", expected.debug_type_name(), found.debug_type_name()),
            CompileError::InvalidStatementInContext(stmt) => write!(f, "Statement '{}' is not valid in the current context", stmt),
            CompileError::InvalidExpression(expr) => write!(f, "Invalid expression: {}", expr),
            CompileError::InvalidEnumBaseType(name) => write!(f, "Enum '{}' has an invalid (non-integer) base type", name),
            CompileError::Generic(msg) => write!(f, "Compilation error: {}", msg),
        }
    }
}
impl From<std::io::Error> for CompileError {
    fn from(err: std::io::Error) -> Self {
        CompileError::Io(err)
    }
}
pub type CompileResult<T> = Result<T, CompileError>;

pub fn rcsharp_compile_to_file(stmts: &[Stmt], full_path: &str) -> Result<(), String> {
    match rcsharp_compile(stmts, full_path) {
        Ok(llvm_ir) => {
            std::fs::write("output.ll", llvm_ir.build())
                .map_err(|e| e.to_string())
        }
        Err(e) => Err(e.to_string()),
    }
}

fn is_global_hint(name: &str) -> bool {
    matches!(name, "include" | "-pop")
}
pub fn rcsharp_compile(stmts: &[Stmt], absolute_file_path: &str) -> CompileResult<LLVMOutputHandler>  {
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
pub fn substitute_generic_type(template_type: &ParserType, type_map: &HashMap<String, ParserType>) -> ParserType {
    if type_map.is_empty() {
        return template_type.clone();
    }
    match template_type {
        ParserType::Named(name) => {
            if let Some(concrete_type) = type_map.get(name) {
                concrete_type.clone()
            } else {
                template_type.clone()
            }
        }
        ParserType::Pointer(inner) => {
            ParserType::Pointer(Box::new(substitute_generic_type(inner, type_map)))
        }
        ParserType::Generic(name, args) => {
            let concrete_args = args.iter()
            .map(|arg| substitute_generic_type(arg, type_map))
            .collect::<Box<[_]>>();
            ParserType::Generic(name.clone(), concrete_args)
        }
        ParserType::Function(ret_type, param_types) => {
            let sub_ret = substitute_generic_type(ret_type, type_map);
            let sub_params = param_types.iter().map(|p| substitute_generic_type(p, type_map)).collect();
            ParserType::Function(Box::new(sub_ret), sub_params)
        }
        ParserType::NamespaceLink(name, q) => {
            let sub = substitute_generic_type(q, type_map);
            if sub.is_primitive_type() {
                return sub;
            }
            if matches!(sub, ParserType::NamespaceLink(_, _)) {
                return sub;
            }
            ParserType::NamespaceLink(name.clone(), Box::new(sub))
        }
    }
}

fn handle_generics(symbols: &mut SymbolTable, output: &mut LLVMOutputHandler) -> CompileResult<()> {
    let mut implemented = vec![];
    loop {
        let mut new = false;
        for (full_path, function) in symbols.functions.iter().filter(|x| x.1.is_generic()) {
            let gi = function.generic_implementations.borrow().clone();
            symbols.alias_types.clear();
            for x in &gi {
                if implemented.iter().any(|c: &(String, Box<[ParserType]>)| c.0 == *full_path && c.1 == *x) {
                    continue;
                }
                if function.generic_params.len() != x.len() {
                    return Err(CompileError::Generic(format!(
                        "Generic struct '{}' expects {} type arguments, but {} were provided.",
                        full_path, function.generic_params.len(), x.len()
                    )));
                }
                new = true;
                let current_namespace = function.path();
                let mut type_map = HashMap::new();
                for (ind, prm) in function.generic_params.iter().enumerate() {
                    type_map.insert(prm.clone(), x[ind].clone());
                    symbols.alias_types.insert(prm.clone(), x[ind].clone());
                }
                let llvm_struct_name = format!("{}<{}>", full_path, x.iter().map(|x| get_llvm_type_str(x, symbols, current_namespace)).collect::<CompileResult<Vec<_>>>()?.join(", "));
                let mut q= function.clone();
                for x in q.args.iter_mut() {
                    x.1 = substitute_generic_type(&x.1, &type_map);
                }
                q.return_type = substitute_generic_type(&q.return_type, &type_map);
                compile_function_body(&q, &llvm_struct_name, symbols, output)?;
                implemented.push((full_path.clone(), x.clone()));
                symbols.alias_types.clear();
            }
        }
        for (name, r#struct) in symbols.types.iter().filter(|x| x.1.is_generic()) {
            let gi = r#struct.generic_implementations.borrow().clone();
            for x in &gi {
                if implemented.iter().any(|c: &(String, Box<[ParserType]>)| c.0 == *name && c.1 == *x) {
                    continue;
                }
                if r#struct.generic_params.len() != x.len() {
                    return Err(CompileError::Generic(format!(
                        "Generic struct '{}' expects {} type arguments, but {} were provided.",
                        name, r#struct.generic_params.len(), x.len()
                    )));
                }
                new = true;
                let mut type_map = HashMap::new();
                for (ind, prm) in r#struct.generic_params.iter().enumerate() {
                    type_map.insert(prm.clone(), x[ind].clone());
                    symbols.alias_types.insert(prm.clone(), x[ind].clone());
                }
                let current_path = r#struct.path.to_string();
                let struct_name = r#struct.name.to_string();
                let full_path = if current_path.is_empty() { struct_name.clone() } else { format!("{}.{}", current_path, struct_name) };
                let llvm_struct_name = format!("{}<{}>", full_path, x.iter().map(|x| get_llvm_type_str_int(&substitute_generic_type(x, &type_map), symbols, &current_path)).collect::<CompileResult<Vec<_>>>()?.join(", "));
                let l = r#struct.fields.iter().map(|x| get_llvm_type_str(&substitute_generic_type(&x.1, &type_map), symbols, &current_path)).collect::<CompileResult<Vec<_>>>()?.join(", ");
                
                let type_definition = format!("%\"struct.{}\" = type {{ {} }}\n", llvm_struct_name, l);
                output.header.push_str(&type_definition);
                implemented.push((name.clone(), x.clone()));
            }
        }
        
        if !new {
            break;
        }
    }
    Ok(())
}
fn collect(stmts: &[Stmt], 
    enums: &mut Vec<(String, Box<[Attribute]>, (String, ParserType, Box<[(String, Expr)]>))>, 
    structs : &mut Vec<(String, Box<[Attribute]>, (String, Box<[(String, ParserType)]>), Box<[String]>)>, 
    functions : &mut Vec<ParsedFunction>,
) -> CompileResult<()>{
    let mut statements: VecDeque<Stmt> = stmts.to_vec().into();

    let mut stack_hints = vec![];
    let mut current_path = Vec::new();
    let mut included_files = HashSet::new();

    while !statements.is_empty() {
        while let Some(x) = statements.pop_front() {
            if let Stmt::Hint(h, ex) = x {
                if is_global_hint(&h) {
                    if h == "include" {
                        if let Some(Expr::StringConst(include_path)) = ex.first() {
                            if included_files.contains(include_path) {
                                continue;
                            }
                            included_files.insert(include_path.clone());

                            let mut file = std::fs::File::open(include_path)?;
                            let mut buf = String::new();
                            file.read_to_string(&mut buf)?;
                            let lex = lex_string_with_file_context(&buf,include_path).unwrap();
                            let par = GeneralParser::new(&lex).parse_all().unwrap();
                            for stmt in par.into_iter().rev() {
                                statements.push_front(stmt);
                            }
                        }
                    } else if h == "-pop" {
                        current_path.pop();
                    }
                }else {
                    stack_hints.push(Attribute::new(h.into(), ex));
                }
                continue;
            }
            if let Stmt::Namespace(namespace, body) = x {
                if !stack_hints.is_empty() {
                    return Err(CompileError::Generic("Hints are not applicable to namespaces".to_string()));
                }
                current_path.push(namespace);
                statements.push_front(Stmt::Hint("-pop".to_string(), Box::new([])));
                for stmt in body.iter().rev() {
                    statements.push_front(stmt.clone());
                }
                continue;
            }
            if let Stmt::Struct(struct_name, fields, generic_args) = x {
                structs.push((current_path.join("."), stack_hints.clone().into_boxed_slice(), (struct_name, fields), generic_args));
                stack_hints.clear();
                continue;
            }
            if let Stmt::Function(mut x) = x {
                
                x.path = current_path.join(".").into();
                x.attributes = stack_hints.clone().into_boxed_slice();
                functions.push(x);
                stack_hints.clear();
                continue;
            }
            if let Stmt::Enum(enum_name, enum_type, fields) = x {
                enums.push((current_path.join("."), stack_hints.clone().into_boxed_slice(), (enum_name, enum_type.unwrap_or(ParserType::Named("i32".to_string())), fields)));
                stack_hints.clear();
                continue;
            }
            return Err(CompileError::InvalidStatementInContext(format!("{:?}", x)));
        }
    }
    Ok(())
}
fn handle_types(structs : Vec<(String, Box<[Attribute]>, (String, Box<[(String, ParserType)]>), Box<[String]>)>, symbols: &mut SymbolTable, output: &mut LLVMOutputHandler) -> CompileResult<()>{ 
    let mut registered_types = vec![];
    for (path, _, (struct_name, _), _) in &structs {
        registered_types.push((path.clone(), struct_name.clone()));
    }
    for (current_path, _, (struct_name, _), _) in &structs {
        let full_path = if current_path.is_empty() { struct_name.clone() } else { format!("{}.{}", current_path, struct_name) };
        symbols.types.insert(full_path.clone(), Struct::new_primitive("name"));
    }
    for (current_path, attrs, (struct_name, fields), generics) in structs {
        let mut compiler_struct_fields = vec![];
        let full_path = if current_path.is_empty() { struct_name.clone() } else { format!("{}.{}", current_path, struct_name) };
        symbols.alias_types.clear();
        for prm in &generics {
            symbols.alias_types.insert(prm.clone(), ParserType::Named(prm.clone()));
        }
        for (name, attr_type) in fields {
            if matches!(attr_type.dereference_full(), ParserType::Generic(_, _)) {
                compiler_struct_fields.push((name, qualify_type(&attr_type, &current_path, symbols) ));
                continue;
            }
            let dereferenced_type = attr_type.dereference_full();
            if !dereferenced_type.is_primitive_type() {
                if let ParserType::Named(named) = dereferenced_type {
                    let is_found = registered_types.iter().any(|(p, n)| {
                        (p == &current_path || p.is_empty()) && n == named
                    });

                    if !is_found && generics.is_empty() {
                        return Err(CompileError::SymbolNotFound(format!(
                            "Type '{}' for field '{}' in struct '{}' was not found.",
                            named, name, struct_name
                        )));
                    }
                }

            }
            compiler_struct_fields.push((name, qualify_type(&attr_type, &current_path, symbols) ));
        }
        symbols.types.insert(full_path, Struct::new(current_path.into(), struct_name.into(), compiler_struct_fields.into(), attrs, generics.clone()));
    }
    symbols.alias_types.clear();
    let user_defined_structs: Vec<&Struct> = symbols.types.values()
        .filter(|s: &&Struct| !s.is_primitive() && !s.is_generic())
        .collect();
    for s in user_defined_structs {
        let field_types: Vec<String> = s.fields
            .iter()
            .map(|(_field_name, field_type)| get_llvm_type_str(field_type, symbols, &s.path))
            .collect::<CompileResult<_>>()?;
        let llvm_struct_name = s.llvm_representation();
        let fields_str = field_types.join(", ");
        let type_definition = format!("{} = type {{ {} }}\n", llvm_struct_name, fields_str);
        output.push_str_header(&type_definition);
    }
    Ok(())
}
fn handle_enums(enums : Vec<(String, Box<[Attribute]>, (String, ParserType, Box<[(String, Expr)]>))>, symbols: &mut SymbolTable, _output: &mut LLVMOutputHandler) -> CompileResult<()>{ 
    let mut registered_enums = vec![];
    for s in &enums {
        //let full_path = if s.0.is_empty() { s.2.0.clone() } else { format!("{}.{}", s.0, s.2.0) };
        registered_enums.push((s.0.clone(), s.2.0.clone()));
        //output.push_str(&format!("enum_{}\n", full_path));
    }
    for (current_path, attrs, (enum_name, enum_type, fields)) in enums {
        let full_path = if current_path.is_empty() { enum_name.clone() } else { format!("{}.{}", current_path, enum_name) };
        let mut compiler_enum_fields = vec![];
        let enum_type = qualify_type(&enum_type, &current_path, symbols);
        if !enum_type.as_integer().is_some() {
            todo!("Not yet supported!")
        }
        for (field_name, field_expr) in fields {
            if let Expr::Integer(int) = &field_expr {
                compiler_enum_fields.push((field_name, int.parse::<i128>().unwrap()));
                continue;
            }
            if let Ok(int) = constant_integer_expression_compiler(&field_expr, symbols) {
                compiler_enum_fields.push((field_name, int));
                continue;
            }
            todo!("Expr {:?}", field_expr);
        }
        symbols.enums.insert(full_path, Enum::new(current_path.into_boxed_str(), enum_name.into_boxed_str(), enum_type, compiler_enum_fields.into_boxed_slice(), attrs));
    }
    Ok(())
}
fn handle_functions(functions : Vec<ParsedFunction>, symbols: &mut SymbolTable, _: &mut LLVMOutputHandler) -> CompileResult<()>{
    let mut registered_funcs = vec![];
    for s in &functions {
        let full_path = if s.path.is_empty() { s.name.to_string() } else { format!("{}.{}", s.path, s.name) };
        //output.push_str(&format!(";func_{}\n", full_path));
        registered_funcs.push(full_path);
    }
    for pf in functions {
        let current_path = pf.path;
        let function_name = pf.name;
        let function_prefixes = pf.prefixes;
        let function_attrs = pf.attributes;
        let function_generics = pf.generic_params;
        let function_body = pf.body;
        let return_type = qualify_type(&pf.return_type, &current_path, symbols);
        let args = pf.args.iter().map(|x| (x.0.clone(), qualify_type(&x.1, &current_path, symbols))).collect::<Box<[_]>>();
        let full_path = if current_path.is_empty() { function_name.to_string() } else { format!("{}.{}", current_path, function_name) };
        
        let mut flags = 0;
        if function_prefixes.iter().any(|x| x.as_str() == "public") {
            flags |= FunctionFlags::Public as u8;
        }
        if function_prefixes.iter().any(|x| x.as_str() == "inline") {
            flags |= FunctionFlags::Inline as u8;
        }
        if function_prefixes.iter().any(|x| x.as_str() == "constexpr") {
            flags |= FunctionFlags::ConstExpression as u8;
        }
        if function_attrs.iter().any(|x| x.name_equals("DllImport")) {
            flags |= FunctionFlags::Imported as u8;
        }
        if !function_generics.is_empty() {
            flags |= FunctionFlags::Generic as u8;
        }
        let function = Function::new(current_path, function_name, args, return_type, function_body, flags.into(), function_attrs, function_generics);
        symbols.functions.insert(full_path, function);
    }
    Ok(())
}
fn qualify_type(ty: &ParserType, current_path: &str, symbols: &SymbolTable) -> ParserType {
    if current_path.is_empty() {
        return ty.clone();
    }

    match ty {
        ParserType::Named(name)=> {
            if symbols.get_type(name).is_some() || symbols.alias_types.contains_key(name) {
                ty.clone()
            }
            else {
                nest_type_in_namespace_path(current_path, ty.clone())
            }
        }
        ParserType::Generic(_, _) =>{
            if symbols.get_type(&ty.type_name()).is_some()  {
                return ty.clone();
            }
            let ty = nest_type_in_namespace_path(current_path, ty.clone());
            return ty;
        }
        ParserType::Pointer(inner) => {
            ParserType::Pointer(Box::new(qualify_type(inner, current_path, symbols)))
        }
        ParserType::Function(ret_type, param_types) => {
            let qualified_ret = qualify_type(ret_type, current_path, symbols);
            let qualified_params = param_types.iter()
                .map(|p| qualify_type(p, current_path, symbols))
                .collect();
            ParserType::Function(Box::new(qualified_ret), qualified_params)
        }
        ParserType::NamespaceLink(_, _) => ty.clone(),
    }
}
fn nest_type_in_namespace_path(path: &str, base_type: ParserType) -> ParserType {
    path.rsplit('.')
        .fold(base_type, |inner_type, path_part| {
            ParserType::NamespaceLink(path_part.to_string(), Box::new(inner_type))
        })
}
fn populate_default_types(table: &mut SymbolTable) {
    for primitive in PRIMITIVE_TYPES_INFO {
        table.types.insert(primitive.name.to_string(), Struct::new_primitive(primitive.name));
    }
}
fn collect_local_variables<'a>(stmts: &'a [Stmt], vars: &mut Vec<(&'a String, &'a ParserType)>) {
    for stmt in stmts {
        match stmt {
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
fn compile_function_body(function: &Function, full_function_name: &str, symbols: &SymbolTable, output: &mut LLVMOutputHandler) -> CompileResult<()>{
    let current_namespace = &function.path;
    let rt = get_llvm_type_str(&function.return_type, symbols, current_namespace)?;
    let mut ctx = CodeGenContext::new(symbols, function);

    let args_str = function.args.iter()
    .map(|(name, ptype)| {
        get_llvm_type_str(ptype, ctx.symbols, &function.path)
            .map(|type_str| format!("{} %{}", type_str, name))
    })
    .collect::<CompileResult<Vec<_>>>()?
    .join(", ");

    output.push_str(&format!("define {} @\"{}\"({}){{\n", rt, full_function_name , args_str)); 
    let mut statically_declared_vars = vec![];
    collect_local_variables(&function.body, &mut statically_declared_vars);
    for (arg_name, arg_type) in function.args.iter() {
        ctx.scope.add_variable(arg_name.clone(), Variable::new_argument(arg_type.clone()), 0);
    }
    for x in statically_declared_vars.iter().enumerate() {
        let llvm_type = get_llvm_type_str(x.1.1, symbols, function.path())?;
        output.push_str(&format!("    %v{} = alloca {}; var: {}\n", x.0, llvm_type, x.1.0));
    }

    for stmt in function.body.iter(){
        //break;
        compile_statement(stmt, &mut ctx, output)
            .map_err(|e| CompileError::Generic(format!("In function '{}':\n{}", function.name(), e)))?;
    }
    if !matches!(function.body.last(), Some(Stmt::Return(_))) {
        if function.return_type.is_void() {
            output.push_str("    ret void\n");
        } else {
            output.push_str("\n    unreachable\n");
        }   
    }
    output.push_str("}\n");
    Ok(())
}
fn compile(symbols: &mut SymbolTable, output: &mut LLVMOutputHandler) -> CompileResult<()>{    
    for (full_path, function) in symbols.functions.iter().filter(|x| x.1.is_normal()) {
        compile_function_body(function, full_path, symbols, output)?;
    }
    if APPEND_DEBUG_FUNCTION_INFO {
        for (full_path, function) in symbols.functions.iter() {
            output.push_str_tail(&format!(";fn {} used times {}\n", full_path, function.times_used.get()));
        }
    }
    for (_, function) in symbols.functions.iter().filter(|x| x.1.is_imported()) {
        if LAZY_FUNCTION_COMPILE && function.times_used.get() == 0 {
            continue;
        }
        // declare dllimport i32 @GetModuleFileNameA(i8*,i8*,i32)
        let current_namespace = &function.path;
        let rt = get_llvm_type_str(&function.return_type, symbols, current_namespace)?;
        let args = function.args.iter().map(|x| get_llvm_type_str(&x.1, symbols, current_namespace)).collect::<CompileResult<Vec<_>>>()?.join(",");
        output.push_str_include_header(&format!("declare dllimport {} @{}({})\n", rt, function.name() , args));
    }
    Ok(())
}
pub fn compile_statement(stmt: &Stmt, ctx: &mut CodeGenContext, output: &mut LLVMOutputHandler) -> CompileResult<()>{
    match &stmt {
        Stmt::Let(name, var_type, expr) => {
            let x = ctx.aquire_unique_variable_index();
            ctx.scope.add_variable(name.clone(), Variable::new(qualify_type(&substitute_generic_type(var_type, &ctx.symbols.alias_types), &ctx.current_function_path, ctx.symbols), false), x);
            // output.push_str(&format!("    %v{} = alloca {}; var: {}\n", x, llvm_type, name));

            if let Some(init_expr) = expr {
                let assignment = Expr::Assign(
                    Box::new(Expr::Name(name.clone())),
                    Box::new(init_expr.clone())
                );
                compile_expression(&assignment, Expected::NoReturn, ctx, output)?;
            }
        }
        Stmt::Expr(expression) => {
            compile_expression(expression, Expected::NoReturn, ctx, output)?;
        }
        Stmt::Return(expression) => {
            let func = ctx.get_current_function().ok_or(CompileError::Generic(format!("Curent function couldnt be found path.name:({}.{})",ctx.current_function_path,ctx.current_function_name)))?;
            let return_type = &substitute_generic_type(func.return_type(), &ctx.symbols.alias_types);
            if expression.is_some() && return_type.is_void() {
                return Err(CompileError::Generic(format!("Function {} does not return anything", func.full_path())));
            }
            if let Some(expr) = expression {
                let value = compile_expression(expr, Expected::Type(return_type), ctx, output)?;
                if value.get_type() != return_type {
                    return Err(CompileError::TypeMismatch { expected: return_type.clone(), found: value.get_type().clone() });
                }
                let llvm_type_str = get_llvm_type_str(return_type, ctx.symbols, &ctx.current_function_path)?;
                output.push_str(&format!("    ret {} {}\n", llvm_type_str, value.get_llvm_repr()));
            } else {
                if !return_type.is_void() {
                    return Err(CompileError::Generic("Cannot return without a value from a non-void function.".to_string()));
                }
                output.push_str("    ret void\n");
            }
        }
        Stmt::Continue => {
            if let Some(li) = ctx.scope.loop_index() {
                output.push_str(&format!("    br label %loop_body{}\n", li));
                return Ok(());
            }
            return Err(CompileError::InvalidStatementInContext("Tried to continue without loop".to_string()));
        }
        Stmt::Break => {
            if let Some(li) = ctx.scope.loop_index() {
                output.push_str(&format!("    br label %loop_body{}_exit\n", li));
                return Ok(());
            }
            return Err(CompileError::InvalidStatementInContext("Tried to break without loop".to_string()));
        }
        Stmt::If(condition, then_body, else_body) => {
            let bool_type = ParserType::Named("bool".to_string());
            let cond_val = compile_expression(condition, Expected::Type(&bool_type), ctx, output)?;

            if cond_val.get_type() != &bool_type {
                return Err(CompileError::InvalidExpression(format!("'{:?}' must result in bool, instead resulted in {:?}", condition, cond_val.get_type())));
            }

            let logic_id = ctx.aquire_unique_logic_counter();
            let then_label = format!("then{}", logic_id);
            let else_label = format!("else{}", logic_id);
            let end_label = format!("endif{}", logic_id);
            
            let target_else = if else_body.is_empty() { &end_label } else { &else_label };
            output.push_str(&format!("    br i1 {}, label %{}, label %{}\n", cond_val.get_llvm_repr(), then_label, target_else));

            output.push_str(&format!("{}:\n", then_label));
            let original_scope = ctx.scope.clone_and_enter();
            for then_stmt in then_body {
                compile_statement(then_stmt, ctx, output)?;
            }
            ctx.scope.swap_and_exit(original_scope);
            output.push_str(&format!("    br label %{}\n", end_label));

            if !else_body.is_empty() {
                output.push_str(&format!("{}:\n", else_label));
                let original_scope = ctx.scope.clone_and_enter();
                for else_stmt in else_body {
                    compile_statement(else_stmt, ctx, output)?;
                }
                ctx.scope.swap_and_exit(original_scope);
                output.push_str(&format!("    br label %{}\n", end_label));
            }

            output.push_str(&format!("{}:\n", end_label));
        }
        Stmt::Loop(statement) =>{
            let lc = ctx.aquire_unique_logic_counter();
            
            output.push_str(&format!("    br label %loop_body{}\n", lc));
            output.push_str(&format!("loop_body{}:\n", lc));
            let original_scope = ctx.scope.clone_and_enter();
            ctx.scope.set_loop_index(Some(lc));
            for x in statement {
                compile_statement(x, ctx, output)?;
            }
            ctx.scope.swap_and_exit(original_scope);
            output.push_str(&format!("    br label %loop_body{}\n", lc));
            output.push_str(&format!("loop_body{}_exit:\n", lc));
        }
        Stmt::Function(..) | Stmt::Struct(..) | Stmt::Enum(..) | Stmt::Namespace(..) | Stmt::Hint(..) => {
            return Err(CompileError::InvalidStatementInContext(format!("{:?}", stmt)));
        }
    }
    Ok(())
}

pub fn get_llvm_type_str(
    ptype: &ParserType,
    symbols: &SymbolTable,
    current_namespace: &str,
) -> CompileResult<String> {
    match ptype {
        ParserType::Pointer(inner_type) => {
            if inner_type.is_void() {
                return Ok("i8*".to_string());
            }
            return Ok(format!("{}*", get_llvm_type_str(inner_type, symbols, current_namespace)?));
        }
        ParserType::Function(return_type, param_types) => {
            let ret_llvm = get_llvm_type_str(return_type, symbols, current_namespace)?;
            let params_llvm: Vec<String> = param_types
                .iter()
                .map(|param_type| get_llvm_type_str(param_type, symbols, current_namespace))
                .collect::<CompileResult<Vec<String>>>()?;
            return Ok(format!("{} ({})*", ret_llvm, params_llvm.join(", ")));
        }
        ParserType::Named(name) => {
            if let Some(x) = symbols.alias_types.get(name) {
                if ParserType::Named(name.clone()) == *x {
                    panic!()
                }
                return get_llvm_type_str(x, symbols, current_namespace);
            }

            if let Some(info) = find_primitive_type(name.as_str()) {
                return Ok(info.llvm_name.to_string());
            }
            let abs = ptype.get_absolute_path_or(current_namespace);
            let rel = ptype.type_name();
            if let Some(x) = symbols.types.get(&abs) {
                return Ok(x.llvm_representation());
            }
            if let Some(enm) = symbols.enums.get(&abs) {
                return get_llvm_type_str(&enm.base_type, symbols, current_namespace);
            }

            if let Some(x) = symbols.types.get(&rel) {
                return Ok(x.llvm_representation());
            }
            if let Some(enm) = symbols.enums.get(&rel) {
                return get_llvm_type_str(&enm.base_type, symbols, current_namespace);
            }
        }
        ParserType::NamespaceLink(x, c) => {
            let mut path = format!("{x}");
            let mut g = c.as_ref();
            while let ParserType::NamespaceLink(link, c) = g {
                path.push_str(&format!(".{}", link));
                g = c.as_ref();
            }
            return get_llvm_type_str(g, symbols, &path);
        }
        ParserType::Generic(_, generic_args) => {
            let concrete_types = generic_args
                .iter()
                .map(|arg| substitute_generic_type(arg, &symbols.alias_types))
                .collect::<Box<[ParserType]>>();
            let absolute_path = ptype.get_absolute_path_or(current_namespace);
            let relative_name = ptype.type_name();
            let lookups = [
                (absolute_path.as_str(), absolute_path.as_str()),
                (&relative_name, &relative_name),
            ];
            for (lookup_key, type_name_for_string) in lookups {
                if let Some(type_info) = symbols.types.get(lookup_key) {
                    {
                        let mut implementations = type_info.generic_implementations.borrow_mut();
                        if !implementations.iter().any(|existing| existing.as_ref() == concrete_types.as_ref()) {
                            implementations.push(concrete_types.clone());
                        }
                    }
                    let arg_type_strings = concrete_types
                        .iter()
                        .map(|arg| get_llvm_type_str_int(arg, symbols, current_namespace))
                        .collect::<CompileResult<Vec<_>>>()?
                        .join(", ");

                    // Format the final LLVM type string and return.
                    return Ok(format!("%\"struct.{}<{}>\"", type_name_for_string, arg_type_strings));
                }
            }
            return Err(CompileError::Generic(format!(
                "Could not find definition for generic type '{:?}'",
                ptype
            )));
        }
    }
    Err(CompileError::Generic(format!("GENERIC LLVM ERROR {:?}", ptype)))
}
pub fn get_llvm_type_str_int(
    ptype: &ParserType,
    symbols: &SymbolTable,
    current_namespace: &str,
) -> CompileResult<String> {
    match ptype {
        ParserType::Generic(_, generic_args) => {
            let concrete_types = generic_args
                .iter()
                .map(|arg| substitute_generic_type(arg, &symbols.alias_types))
                .collect::<Box<[ParserType]>>();
            let absolute_path = ptype.get_absolute_path_or(current_namespace);
            let relative_name = ptype.type_name();
            let lookups = [
                (absolute_path.as_str(), absolute_path.as_str()),
                (&relative_name, &relative_name),
            ];
            for (lookup_key, type_name_for_string) in lookups {
                if let Some(type_info) = symbols.types.get(lookup_key) {
                    {
                        let mut implementations = type_info.generic_implementations.borrow_mut();
                        if !implementations.iter().any(|existing| existing.as_ref() == concrete_types.as_ref()) {
                            implementations.push(concrete_types.clone());
                        }
                    }
                    let arg_type_strings = concrete_types
                        .iter()
                        .map(|arg| get_llvm_type_str_int(arg, symbols, current_namespace))
                        .collect::<CompileResult<Vec<_>>>()?
                        .join(", ");

                    // Format the final LLVM type string and return.
                    return Ok(format!("struct.{}<{}>", type_name_for_string, arg_type_strings));
                }
            }


            Err(CompileError::Generic(format!(
                "Could not find definition for generic type '{:?}'",
                ptype
            )))
        }
        _ => get_llvm_type_str(ptype, symbols, current_namespace),
    }
}


#[derive(Debug, Default)]
pub struct LLVMOutputHandler{
    header: String,
    strings_header: Vec<String>,
    include_header: String,
    main: String,
    tail: String,
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
    pub fn push_str_tail(&mut self, s: &str) {
        self.tail.push_str(s);
    }
    pub fn add_to_strings_header(&mut self, string: String) -> usize{
        if DONT_INSERT_REDUNDAND_STRINGS {
            if let Some(id) = self.strings_header.iter().position(|x| x == string.as_str()) {
                return id;
            }
        }
        self.strings_header.push(string);
        return self.strings_header.len() - 1;
    }
    pub fn build(self) -> String {
        let x = self.strings_header.iter().enumerate().map(|(index,x)|{
            let escaped_val = x.replace("\"", "\\22")
                .replace("\n", "\\0A")
                .replace("\r", "\\0D")
                .replace("\t", "\\09");
            let str_len = x.len() + 1;
            format!("@.str.{} = private unnamed_addr constant [{} x i8] c\"{}\\00\"", index, str_len, escaped_val)
        }).collect::<Vec<String>>().join("\n");

        format!("{}\n{}\n{}\n{}\n{}", self.header, self.include_header, x, self.main, self.tail)
    }
}


#[derive(Debug, Default)]
pub struct SymbolTable {
    pub functions: OrderedHashMap<String, Function>,
    pub types: OrderedHashMap<String, Struct>,
    pub alias_types: HashMap<String, ParserType>,
    pub enums: OrderedHashMap<String, Enum>,
}
impl SymbolTable {
    pub fn new() -> Self {
        let mut table = Self::default();
        populate_default_types(&mut table);
        table
    }
    pub fn get_bare_function<'a>(&'a self, fqn: &str, current_namespace: &str, increment_use: bool) -> Option<FunctionView<'a>> {
        if let Some(x) = self.functions.get(&format!("{}.{}", current_namespace, fqn)).or(self.functions.get(fqn)) {
            if increment_use {
                x.use_fn();
            }
            return Some(FunctionView::new_unspec(x));
        }
        None
    }
    pub fn get_function<'a>(&'a self, fqn: &str, current_namespace: &str) -> Option<FunctionView<'a>> {
        if let Some(x) = self.get_bare_function(fqn, current_namespace, true) {
            if x.definition().is_generic() {
                return Some(FunctionView::new_generic(x.definition(),  &self.alias_types));
            }
            return Some(x);
        }
        None
    }
    pub fn get_generic_function<'a>(&'a self, fqn: &str, current_namespace: &str, aliases: &HashMap<String, ParserType>) -> Option<FunctionView<'a>> {
        self.get_bare_function(fqn, current_namespace, true).filter(|x| x.definition().is_generic()).map(|x| FunctionView::new_generic(x.definition(), aliases))
    }

    pub fn get_bare_type<'a>(&'a self, fqn: &str) -> Option<StructView<'a>> {
        self.types.get(fqn).map(|x| StructView::new_unspec(x))
    }
    pub fn get_type<'a>(&'a self, fqn: &str) -> Option<StructView<'a>> {
        if let Some(x) = self.get_bare_type(fqn) {
            if x.definition().is_generic() {
                return Some(StructView::new_generic(x.definition(),  &self.alias_types));
            }
            return Some(x);
        }
        None
    }
    pub fn get_generic_type<'a>(&'a self, fqn: &str, aliases: &HashMap<String, ParserType>) -> Option<StructView<'a>> {
        self.get_bare_type(fqn).filter(|x| x.definition().is_generic()).map(|x| StructView::new_generic(x.definition(), aliases))
    }

    pub fn get_abs_path(struct_type: &ParserType, current_namespace: &str) -> String {
        debug_assert!(!struct_type.is_primitive_type());
        debug_assert!(!struct_type.is_pointer());
        if let ParserType::NamespaceLink(s, y) = struct_type {
            return format!("{}.{}", s, y.type_name());
        }
        if let ParserType::Named(n) = struct_type{
            if current_namespace.is_empty() {
                return n.to_string();
            }else {
                return format!("{}.{}", current_namespace, n);
            }
        };
        if let ParserType::Generic(n, _) = struct_type{
            if current_namespace.is_empty() {
                return n.to_string();
            }else {
                return format!("{}.{}", current_namespace, n);
            }
        };
        todo!()
    }
}

pub struct CodeGenContext<'a> {
    pub symbols: &'a SymbolTable,
    pub current_function_path: String,
    pub current_function_name: String,
    pub scope: Scope,

    temp_value_counter: Cell<u32>,
    variable_counter: Cell<u32>,
    logic_counter: Cell<u32>,
}
impl<'a> CodeGenContext<'a> {
    pub fn new(symbols: &'a SymbolTable, function: &Function) -> Self {
        Self {
            symbols,
            current_function_path: function.path.to_string(),
            current_function_name: function.name.to_string(),
            scope: Scope::default(),
            temp_value_counter: Cell::new(0),
            variable_counter: Cell::new(0),
            logic_counter: Cell::new(0),
        }
    }
    pub fn get_current_function(&self) -> Option<FunctionView<'a>> {
        self.symbols.get_bare_function(&self.current_function_name, &self.current_function_path, false)
    }
    pub fn aquire_unique_temp_value_counter(&self) -> u32{
        self.temp_value_counter.replace(self.temp_value_counter.get() + 1)
    }
    pub fn aquire_unique_variable_index(&self) -> u32{
        self.variable_counter.replace(self.variable_counter.get() + 1)
    }
    pub fn aquire_unique_logic_counter(&self) -> u32{
        self.logic_counter.replace(self.logic_counter.get() + 1)
    }
}
