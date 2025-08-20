use core::str;
use std::collections::HashMap;

use ordered_hash_map::OrderedHashMap;

use crate::{expression_compiler::{compile_expression, implicit_cast, Expected}, expression_parser::{BinaryOp, Expr}, parser::{ParserType, Stmt}};
pub fn rcsharp_compile_to_file(x: &[Stmt]) -> Result<(), String> {
    let mut state = CompilerState::default();
    rcsharp_compile(x, &mut state)?;
    let direct_output = state.output.output();
    let mut file = std::fs::File::create("output.ll").map_err(|e| e.to_string())?;
    std::io::Write::write_all(&mut file, direct_output.as_bytes()).map_err(|e| e.to_string())?;

    Ok(())
}
#[derive(Debug, Clone)]
pub struct Function {pub path:String, pub name:String, pub args: Vec<(String, ParserType)>, pub return_type: ParserType, pub body: Vec<Stmt>, pub attribs: Vec<(String, Vec<Expr>)>}
impl Function {
    pub fn effective_name(&self) -> String {
        let output = if self.path.is_empty() {
            self.name.clone()
        }else{
            let mut o = self.path.clone();
            o.push('.');
            o.push_str(&self.name);
            o
        };
        return output;
    }
}
#[derive(Debug, Clone)]
#[allow(dead_code)]
pub struct Struct {name:String, fields: Vec<(String, ParserType)>, attribs: Vec<(String, Vec<Expr>)>}
#[derive(Debug, Default, Clone)]
pub struct Namespace {
    pub functions: HashMap<String, Function>,
    pub types: HashMap<String, ParserType>,
    pub sub_namespaces: HashMap<String, Namespace>,
}



pub fn rcsharp_compile(x: &[Stmt], main_state :&mut CompilerState) -> Result<(), String> {
    main_state.output.push_str_header("target triple = \"x86_64-pc-windows-msvc\"\n");
    populate_default_types(main_state)?;
    pre_compile(x, main_state)?;
    compile_structs(main_state)?;
    let funcs = compile_attributes(main_state)?;
    compile_functions(funcs, main_state)?;
    Ok(())
}
fn pre_compile(x: &[Stmt], state :&mut CompilerState) -> Result<(), String>{
    let mut ns = state.root_namespace.clone();
    recursive_pre_compile(x, &mut ns, "", state)?;
    state.root_namespace = ns;
    Ok(())
}
fn recursive_pre_compile(x: &[Stmt], current_ns: &mut Namespace, current_path: &str, state: &mut CompilerState) -> Result<(), String>{
    for i in 0..x.len() {
        let statement = &x[i];
        match statement {
            Stmt::Function(n, a, r, b) => {
                let mut atribs_len = 0;
                for j in (0..i).rev() {
                    if matches!(&x[j], Stmt::Hint(_, _)) { atribs_len += 1; } 
                    else { break; }
                }
                let attribs = x[i-atribs_len..i].iter().map(|x| {if let Stmt::Hint(x, y) = x {return (x.clone(),y.clone());} else {panic!()}} ).collect::<Vec<_>>();

                let full_name = if current_path.is_empty() {
                    n.clone()
                } else {
                    format!("{}.{}", current_path, n)
                };

                let function = Function {
                    path: current_path.to_string(),
                    name: n.clone(),
                    args: a.clone(), 
                    return_type: r.clone(), 
                    body: b.to_vec(), 
                    attribs,
                };

                if current_ns.functions.insert(n.clone(), function.clone()).is_some() {
                    return Err(format!("Function '{}' already defined in this scope.", n));
                }
                state.declared_functions.insert(full_name, function);
            },
            Stmt::Struct(n, a) => {
                let full_name = if current_path.is_empty() {
                    n.clone()
                } else {
                    format!("{}::{}", current_path, n)
                };

                let fields = a.clone();
                let struct_pt = (full_name.clone(), fields.iter().map(|x|x.clone()).collect::<Vec<_>>(), vec![]);
                
                let compiler_type = CompilerType { 
                    parser_type: ParserType::Named(full_name.clone()),
                    llvm_representation: ParserType::Named(format!("%struct.{}", full_name.replace("::", "."))), 
                    struct_representation : struct_pt,
                    explicit_casts: HashMap::new(), _binary_operations: HashMap::new() 
                };
                if current_ns.types.insert(n.clone(), ParserType::Named(full_name.clone())).is_some() {
                     return Err(format!("Type '{}' already defined in this scope.", n));
                }
                state.implemented_types.insert(full_name.clone(), compiler_type);
            },
            Stmt::Namespace(name, body) =>{
                let sub_ns = current_ns.sub_namespaces.entry(name.clone()).or_default();
                let new_path = if current_path.is_empty() {
                    name.clone()
                } else {
                    format!("{}.{}", current_path, name)
                };
                recursive_pre_compile(body, sub_ns, &new_path, state)?;
            }
            Stmt::Hint(_, _) => {}
            _ => {return Err(format!("Unexpected statement during pre-compilation: {:?}", statement));}
        }
    }
    Ok(())
}

fn populate_default_types(state: &mut CompilerState) -> Result<(), String> {
    // Was AI assisted
    macro_rules! define_type {
        ($state:expr, $name:expr, $llvm_type:expr, $casts:expr) => {
            $state.implemented_types.insert(
                format!($name),
                CompilerType {
                    parser_type: ParserType::Named(format!($name)),
                    llvm_representation: ParserType::Named(format!($llvm_type)),
                    struct_representation: (format!($llvm_type), vec![], vec![]),
                    explicit_casts: $casts,
                    _binary_operations: HashMap::new(),
                },
            );
        };
    }
    // === bool ===
    let mut bool_casts = HashMap::new();
    bool_casts.insert(format!("i8"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = zext i1 {{v}} to i8\n")));
    bool_casts.insert(format!("u8"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = zext i1 {{v}} to i8\n")));
    bool_casts.insert(format!("i16"), Stmt::DirectInsertion(format!("    %tmp{{o}} = zext i1 {{v}} to i16\n")));
    bool_casts.insert(format!("u16"), Stmt::DirectInsertion(format!("    %tmp{{o}} = zext i1 {{v}} to i16\n")));
    bool_casts.insert(format!("i32"), Stmt::DirectInsertion(format!("    %tmp{{o}} = zext i1 {{v}} to i32\n")));
    bool_casts.insert(format!("u32"), Stmt::DirectInsertion(format!("    %tmp{{o}} = zext i1 {{v}} to i32\n")));
    bool_casts.insert(format!("i64"), Stmt::DirectInsertion(format!("    %tmp{{o}} = zext i1 {{v}} to i64\n")));
    bool_casts.insert(format!("u64"), Stmt::DirectInsertion(format!("    %tmp{{o}} = zext i1 {{v}} to i64\n")));
    define_type!(state, "bool", "i1", bool_casts);

    // === i8 ===
    let mut i8_casts = HashMap::new();
    i8_casts.insert(format!("bool"), Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i8 {{v}} to i1\n")));
    i8_casts.insert(format!("u8"),   Stmt::DirectInsertion(format!("    %tmp{{o}} = bitcast i8 {{v}} to i8\n")));
    i8_casts.insert(format!("i16"), Stmt::DirectInsertion(format!("    %tmp{{o}} = sext i8 {{v}} to i16\n")));
    i8_casts.insert(format!("u16"), Stmt::DirectInsertion(format!("    %tmp{{o}} = sext i8 {{v}} to i16\n")));
    i8_casts.insert(format!("i32"), Stmt::DirectInsertion(format!("    %tmp{{o}} = sext i8 {{v}} to i32\n")));
    i8_casts.insert(format!("u32"), Stmt::DirectInsertion(format!("    %tmp{{o}} = sext i8 {{v}} to i32\n")));
    i8_casts.insert(format!("i64"), Stmt::DirectInsertion(format!("    %tmp{{o}} = sext i8 {{v}} to i64\n")));
    i8_casts.insert(format!("u64"), Stmt::DirectInsertion(format!("    %tmp{{o}} = sext i8 {{v}} to i64\n")));
    define_type!(state, "i8", "i8", i8_casts);

    // === u8 ===
    let mut u8_casts = HashMap::new();
    u8_casts.insert(format!("bool"), Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i8 {{v}} to i1\n")));
    u8_casts.insert(format!("i8"),   Stmt::DirectInsertion(format!("    %tmp{{o}} = bitcast i8 {{v}} to i8\n")));
    u8_casts.insert(format!("i16"), Stmt::DirectInsertion(format!("    %tmp{{o}} = zext i8 {{v}} to i16\n")));
    u8_casts.insert(format!("u16"), Stmt::DirectInsertion(format!("    %tmp{{o}} = zext i8 {{v}} to i16\n")));
    u8_casts.insert(format!("i32"), Stmt::DirectInsertion(format!("    %tmp{{o}} = zext i8 {{v}} to i32\n")));
    u8_casts.insert(format!("u32"), Stmt::DirectInsertion(format!("    %tmp{{o}} = zext i8 {{v}} to i32\n")));
    u8_casts.insert(format!("i64"), Stmt::DirectInsertion(format!("    %tmp{{o}} = zext i8 {{v}} to i64\n")));
    u8_casts.insert(format!("u64"), Stmt::DirectInsertion(format!("    %tmp{{o}} = zext i8 {{v}} to i64\n")));
    define_type!(state, "u8", "i8", u8_casts);

    // === i16 ===
    let mut i16_casts = HashMap::new();
    i16_casts.insert(format!("bool"), Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i16 {{v}} to i1\n")));
    i16_casts.insert(format!("i8"),   Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i16 {{v}} to i8\n")));
    i16_casts.insert(format!("u8"),   Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i16 {{v}} to i8\n")));
    i16_casts.insert(format!("u16"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = bitcast i16 {{v}} to i16\n")));
    i16_casts.insert(format!("i32"), Stmt::DirectInsertion(format!("    %tmp{{o}} = sext i16 {{v}} to i32\n")));
    i16_casts.insert(format!("u32"), Stmt::DirectInsertion(format!("    %tmp{{o}} = sext i16 {{v}} to i32\n")));
    i16_casts.insert(format!("i64"), Stmt::DirectInsertion(format!("    %tmp{{o}} = sext i16 {{v}} to i64\n")));
    i16_casts.insert(format!("u64"), Stmt::DirectInsertion(format!("    %tmp{{o}} = sext i16 {{v}} to i64\n")));
    define_type!(state, "i16", "i16", i16_casts);

    // === u16 ===
    let mut u16_casts = HashMap::new();
    u16_casts.insert(format!("bool"), Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i16 {{v}} to i1\n")));
    u16_casts.insert(format!("i8"),   Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i16 {{v}} to i8\n")));
    u16_casts.insert(format!("u8"),   Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i16 {{v}} to i8\n")));
    u16_casts.insert(format!("i16"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = bitcast i16 {{v}} to i16\n")));
    u16_casts.insert(format!("i32"), Stmt::DirectInsertion(format!("    %tmp{{o}} = zext i16 {{v}} to i32\n")));
    u16_casts.insert(format!("u32"), Stmt::DirectInsertion(format!("    %tmp{{o}} = zext i16 {{v}} to i32\n")));
    u16_casts.insert(format!("i64"), Stmt::DirectInsertion(format!("    %tmp{{o}} = zext i16 {{v}} to i64\n")));
    u16_casts.insert(format!("u64"), Stmt::DirectInsertion(format!("    %tmp{{o}} = zext i16 {{v}} to i64\n")));
    define_type!(state, "u16", "i16", u16_casts);

    // === i32 ===
    let mut i32_casts = HashMap::new();
    i32_casts.insert(format!("bool"), Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i32 {{v}} to i1\n")));
    i32_casts.insert(format!("i8"),   Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i32 {{v}} to i8\n")));
    i32_casts.insert(format!("u8"),   Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i32 {{v}} to i8\n")));
    i32_casts.insert(format!("i16"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i32 {{v}} to i16\n")));
    i32_casts.insert(format!("u16"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i32 {{v}} to i16\n")));
    i32_casts.insert(format!("u32"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = bitcast i32 {{v}} to i32\n")));
    i32_casts.insert(format!("i64"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = sext i32 {{v}} to i64\n")));
    i32_casts.insert(format!("u64"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = sext i32 {{v}} to i64\n")));
    define_type!(state, "i32", "i32", i32_casts);

    // === u32 ===
    let mut u32_casts = HashMap::new();
    u32_casts.insert(format!("bool"), Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i32 {{v}} to i1\n")));
    u32_casts.insert(format!("i8"),   Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i32 {{v}} to i8\n")));
    u32_casts.insert(format!("u8"),   Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i32 {{v}} to i8\n")));
    u32_casts.insert(format!("i16"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i32 {{v}} to i16\n")));
    u32_casts.insert(format!("u16"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i32 {{v}} to i16\n")));
    u32_casts.insert(format!("i32"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = bitcast i32 {{v}} to i32\n")));
    u32_casts.insert(format!("i64"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = zext i32 {{v}} to i64\n")));
    u32_casts.insert(format!("u64"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = zext i32 {{v}} to i64\n")));
    define_type!(state, "u32", "i32", u32_casts);

    // === i64 ===
    let mut i64_casts = HashMap::new();
    i64_casts.insert(format!("bool"), Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i64 {{v}} to i1\n")));
    i64_casts.insert(format!("i8"),   Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i64 {{v}} to i8\n")));
    i64_casts.insert(format!("u8"),   Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i64 {{v}} to i8\n")));
    i64_casts.insert(format!("i16"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i64 {{v}} to i16\n")));
    i64_casts.insert(format!("u16"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i64 {{v}} to i16\n")));
    i64_casts.insert(format!("i32"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i64 {{v}} to i32\n")));
    i64_casts.insert(format!("u32"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i64 {{v}} to i32\n")));
    i64_casts.insert(format!("u64"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = bitcast i64 {{v}} to i64\n")));
    define_type!(state, "i64", "i64", i64_casts);

    // === u64 ===
    let mut u64_casts = HashMap::new();
    u64_casts.insert(format!("bool"), Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i64 {{v}} to i1\n")));
    u64_casts.insert(format!("i8"),   Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i64 {{v}} to i8\n")));
    u64_casts.insert(format!("u8"),   Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i64 {{v}} to i8\n")));
    u64_casts.insert(format!("i16"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i64 {{v}} to i16\n")));
    u64_casts.insert(format!("u16"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i64 {{v}} to i16\n")));
    u64_casts.insert(format!("i32"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i64 {{v}} to i32\n")));
    u64_casts.insert(format!("u32"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i64 {{v}} to i32\n")));
    u64_casts.insert(format!("i64"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = bitcast i64 {{v}} to i64\n")));
    define_type!(state, "u64", "i64", u64_casts);

    define_type!(state, "void", "void", HashMap::new());
    Ok(())
}

fn compile_attributes(state :&mut CompilerState) -> Result<Vec<Function>, String>{
    let all_functions= state.declared_functions.clone();
    let mut functions_to_compile = vec![];
    for function in all_functions {
        if function.1.attribs.iter().any(|x| x.0 == "DllImport") {
            let func_return_type_string = state.get_llvm_representation_from_parser_type(&function.1.return_type)?;
            let args_string = function.1.args.iter().map(|x| state.get_llvm_representation_from_parser_type(&x.1))
                .collect::<Result<Vec<_>,String>>()?.join(",");
            
            state.output.push_str_header(&format!("declare dllimport {} @{}({})\n", func_return_type_string, function.1.name, args_string));
            state.imported_functions.insert(function.0, function.1.clone());
            continue;
        }
        functions_to_compile.push(function.1.clone());
    }
    Ok(functions_to_compile)
}
fn compile_structs(main_state: &mut CompilerState) -> Result<(), String> {
    for (_name, compiler_type) in main_state.implemented_types.iter().filter(|(_k, v)| !v.parser_type.is_simple_type()) {
        let (_, fields, _methods) = &compiler_type.struct_representation;
        
        let field_types = fields.iter().map(|x| main_state.get_llvm_representation_from_parser_type(&x.1))
            .collect::<Result<Vec<_>,String>>()?.join(", ");
        
        let llvm_struct_name = &compiler_type.llvm_representation.to_string();
        main_state.output.push_str_header(&format!("{} = type {{{}}}\n", llvm_struct_name, field_types));
    }
    Ok(())
}
fn compile_functions(funcs: Vec<Function>, state :&mut CompilerState) -> Result<(), String>{
    for function in funcs {
        let function_return_type = state.get_compiler_type_from_parser(&function.return_type)?.llvm_representation;
        let effective_function_name = if function.path.is_empty(){
            function.name.clone()
        }else{
            let mut x = function.path.clone();
            x.push('.');
            x.push_str(&function.name);
            x
        };
        let mut arg_parts = Vec::new();
        for (arg_name, arg_type) in &function.args {
            let compiler_type = state.get_compiler_type_from_parser(arg_type)?;
            let type_string = compiler_type.llvm_representation.to_string();
            let formatted_arg = format!("{} %{}", type_string, arg_name);
            arg_parts.push(formatted_arg);
        }
        let args_string = arg_parts.join(", ");

        state.output.push_str(&format!("\ndefine {} @{}({}){{\n", function_return_type.to_string(), effective_function_name, args_string));
        
        state.current_variable_stack.clear();
        state.current_function_arguments.clear();
        state.temp_value_counter = 0;

        for arg in &function.args {
            let val_type = state.get_compiler_type_from_parser(&arg.1)?;
            state.current_function_arguments.insert(arg.0.clone(), val_type);
        }
        state.current_function_name = function.name.clone();
        state.current_function_path = function.path.clone();
        for x in &function.body.clone() {
            compile_statement(x, state)
            .map_err(|x| format!("while compiling function \"{}\"\n\r{}",state.current_function_name,x))?;
        }
        if function_return_type.to_string() == "void" {
            state.output.push_str(&format!("    ret void\n"));
        }
        state.output.push_str(&format!("\n    unreachable\n}}\n"));
    }
    Ok(())
}
fn compile_statement(statement: &Stmt, state :&mut CompilerState) -> Result<(), String>{
    match &statement {
        Stmt::Let(name, var_type, expr) => {
            let comp_type = state.get_compiler_type_from_parser(var_type)?;
            state.output.push_str(&format!("    %{} = alloca {}\n", name, comp_type.llvm_representation.to_string()));
            state.current_variable_stack.insert(name.clone(), comp_type);
            if let Some(expr) = expr {
                compile_expression(&Expr::Assign(Box::new(Expr::Name(name.clone())), Box::new(expr.clone())), Expected::Type(var_type), state)
                    .map_err(|x| format!("while compiling assign expression {:?}:\n{}", expr, x))?;
                
            }
        }
        Stmt::Expr(expression) => { compile_expression(expression, Expected::NoReturn, state).map_err(|x| format!("while compiling expression {:?}\n\r{}",expression,x))?; }
        Stmt::Return(expression) =>{
            if let Some(expression) = expression {
                let expected_type = state.get_current_function()?.return_type.clone();
                let function_actual_return_type = state.get_compiler_type_from_parser(&expected_type)?.llvm_representation;
                let tmp_idx = compile_expression(expression, Expected::Type(&expected_type), state)
                    .map_err(|x| format!("while compiling expression in return statement {:?}:\n{}", expression, x))?;
                if !tmp_idx.equal_to_type(&expected_type) {
                    return Err(format!("Result type \"{:?}\" of expresion is not equal to return type \"{:?}\" of function \"{}\"", tmp_idx, function_actual_return_type, state.get_current_function()?.effective_name()));
                }
                state.output.push_str(&format!("    ret {} {}\n", function_actual_return_type.to_string(), tmp_idx.to_repr()));
            }else {
                let expected_type = &state.get_current_function()?.return_type;
                if *expected_type != ParserType::Named(format!("void")) {
                    return Err(format!("Returning empty expression in non void function"));
                }
                state.output.push_str(&format!("    ret void\n"));
            }
        }
        Stmt::Continue => {state.output.push_str(&format!("    br label %loop_body{}\n", state.current_logic_counter_function));}
        Stmt::Break => {state.output.push_str(&format!("    br label %loop_body{}_exit\n", state.current_logic_counter_function));}
        Stmt::If(condition, then_stmt, else_stmt) => {
            let expected_type = ParserType::Named(format!("bool"));
            let mut cond_val = compile_expression(condition, Expected::Type(&expected_type), state)
            .map_err(|x| format!("while compiling expression in if statement {:?}:\n{}",condition, x))?;
            let logic_u = state.aquire_unique_logic_counter();
            if !cond_val.equal_to_type(&expected_type) {
                cond_val = implicit_cast(&cond_val, &expected_type, state)?
            }
            if !else_stmt.is_empty() {
                state.output.push_str(&format!("    br {}, label %then{}, label %else{}\n", cond_val.to_repr_with_type(state)?, logic_u, logic_u));
                state.output.push_str(&format!("then{}:\n", logic_u));
                for x in then_stmt {
                    compile_statement(x, state)
                        .map_err(|x| format!("while compiling body of if statement {:?}:\n{}",condition, x))?;
                }
                state.output.push_str(&format!("    br label %end_if{}\n", logic_u));
                state.output.push_str(&format!("else{}:\n", logic_u));
                for stmt in else_stmt {
                    compile_statement(&stmt, state)
                        .map_err(|x| format!("while compiling else body of if statement {:?}:\n{}",condition, x))?;
                }
                state.output.push_str(&format!("    br label %end_if{}\n", logic_u));
                state.output.push_str(&format!("end_if{}:\n", logic_u));
            }else {
                state.output.push_str(&format!("    br {}, label %then{}, label %end_if{}\n", cond_val.to_repr_with_type(state)?, logic_u, logic_u));
                state.output.push_str(&format!("then{}:\n", logic_u)); 
                for x in then_stmt {
                    compile_statement(x, state)
                        .map_err(|x| format!("while compiling body of if statement {:?}:\n{}",condition, x))?;
                }
                state.output.push_str(&format!("    br label %end_if{}\n", logic_u));
                state.output.push_str(&format!("end_if{}:\n", logic_u));
            }
        }
        Stmt::Loop(statement) =>{
            let lc = state.aquire_unique_logic_counter();
            
            state.output.push_str(&format!("    br label %loop_body{}\n", lc));
            state.output.push_str(&format!("loop_body{}:\n", lc));

            state.current_logic_counter_function = lc as u32;
            for x in statement {
                compile_statement(x, state)?;
            }
            state.current_logic_counter_function = u32::MAX;
            state.output.push_str(&format!("    br label %loop_body{}\n", lc));
            state.output.push_str(&format!("loop_body{}_exit:\n", lc));
        }
        Stmt::Hint(_,_) | Stmt::Function(_, _, _, _) | Stmt::Struct(_, _)  => return Err(format!("Statement {:?} was not expected in current context", statement)),
        _ => panic!("{:?}", statement),
    }
    Ok(())
}

#[derive(Debug, Clone)]
pub struct CompilerType { pub parser_type: ParserType, pub llvm_representation: ParserType, pub struct_representation: (String, Vec<(String,ParserType)>, Vec<(String,(ParserType, Vec<ParserType>))>), pub explicit_casts: HashMap<String, Stmt>,  pub _binary_operations: HashMap<BinaryOp, HashMap<String, String>>, }
impl CompilerType { 
    pub fn sizeof(&self, state :&CompilerState) -> u32 { 
        match &self.llvm_representation {
            ParserType::Named(x) => {
                match x.as_str() {
                    "i8" => 1, 
                    "i16" => 2, 
                    "i32" => 4, 
                    "i64" => 8,
                    
                    "f32" => 4, 
                    "f64" => 8,
                    _ => {
                        if let Some(t) = x.split(|x| x == '.').nth(1) {
                            if state.implemented_types.contains_key(t) {
                                let var_struct_representation = &state.implemented_types[t].struct_representation.1;
                                let struct_size = var_struct_representation.iter().map(|x| state.get_compiler_type_from_parser(&x.1).unwrap().sizeof(state)).sum();
                                return struct_size;
                            }
                        }
                        todo!("{:?}", x)
                    }
                }
            }
            ParserType::Pointer(_) => 8,
            _ => todo!("{:?}", self.llvm_representation)
        }
    }
}
#[derive(Debug, Default)]
pub struct LLVMOutputHandler{
    output_header: String,
    output_main: String,
}
impl LLVMOutputHandler {
    pub fn push_str(&mut self, x: &str){
        self.output_main.push_str(x);
    }
    pub fn push_str_header(&mut self, x: &str){
        self.output_header.push_str(x);
    }
    pub fn output(&self) -> String{
        let mut x = self.output_header.clone();
        x.push('\n');
        x.push_str(&self.output_main);
        return x;
    }
}
#[derive(Debug, Default)]
pub struct CompilerState{
    pub output: LLVMOutputHandler,
    
    pub root_namespace: Namespace,

    pub imported_functions: OrderedHashMap<String, Function>,
    pub declared_functions: OrderedHashMap<String, Function>,
    pub implemented_types: OrderedHashMap<String, CompilerType>,
    
    current_function_path: String,
    current_function_name: String,

    current_variable_stack: OrderedHashMap<String, CompilerType>,
    current_function_arguments: OrderedHashMap<String, CompilerType>,

    temp_value_counter: u32,
    logic_counter: u32,
    const_vectors_counter: u32,
    current_logic_counter_function: u32,
}
impl CompilerState {
    fn get_namespace_from_path(&self, path: &str) -> Result<&Namespace, String>{
        if path.is_empty() || path == "root" {
            return Ok(&self.root_namespace);
        }
        let mut node = &self.root_namespace;
        let mut iter = 0;
        for x in path.split(|x| x == '.') {
            if iter == 0 && x == "root" {
                iter += 1;
                continue;
            }
            if x.is_empty() {
                continue;
            }
            if !node.sub_namespaces.contains_key(x) {
                return Err(format!("Sub-Namespace \"{}\" does not exist on path \"{}\"", x, path));
            }
            node = &node.sub_namespaces[x];
            iter+=1;
        }
        return Ok(node);
    }
    pub fn get_function_from_path(&self, path: &str, func_name: &str) -> Result<&Function, String>{
        let ns = self.get_namespace_from_path(path)?;
        let func = ns.functions.get(func_name).ok_or(format!("Current function was not found inside current namespace path"))?;
        return Ok(func);
    }
    pub fn get_current_function(&self) -> Result<&Function, String>{
        let ns = self.get_namespace_from_path(&self.current_function_path)?;
        let func = ns.functions.get(&self.current_function_name).ok_or(format!("Current function was not found inside current namespace path"))?;
        return Ok(func);
    } 
    pub fn get_current_path(&self) -> &str{
        return &self.current_function_path;
    } 
    pub fn set_current_path(&mut self, path: &str) {
        self.current_function_path = path.to_string();
    }
    pub fn get_variable_type(&self, name: &str) -> Result<&CompilerType,String>{
        if self.current_variable_stack.contains_key(name) {
            return Ok(&self.current_variable_stack[name]);
        }
        return Err(format!("Variable \"{}\" was not found inside function \"{}\"",name, self.current_function_name));
    }
    pub fn get_argument_type(&self, name: &str) -> Result<&CompilerType,String>{
        if self.current_function_arguments.contains_key(name) {
            return Ok(&self.current_function_arguments[name]);
        }
        return Err(format!("Variable or Argument \"{}\" was not found inside function \"{}\"",name, self.current_function_name));
    }

    pub fn get_compiler_type_from_parser(&self, parser_type: &ParserType) -> Result<CompilerType,String>{
        let mut t= parser_type.clone();
        while t.is_pointer() {
            t = t.dereference_once();
        }
        
        if let Some(x) = self.implemented_types.get(&t.to_string()) {
            let mut pt = x.clone();
            let mut underlying_representation = pt.llvm_representation.clone();
            let mut pv = parser_type.clone();
            loop {
                if let ParserType::Pointer(r) = pv {
                    pv = *r.clone();
                    underlying_representation = ParserType::Pointer(Box::new(underlying_representation));
                    continue;
                }
                break;
            }
            pt.parser_type = parser_type.clone();
            pt.llvm_representation = underlying_representation;
            // if given parser type is ref, than add ref to compiler type
            return Ok(pt);
        }
        Err(format!("Implementation of \"{:?}\" was not found in current context", parser_type))
    }

    pub fn get_llvm_representation_from_parser_type(&self, parser_type: &ParserType) -> Result<String, String>{
        match parser_type {
            ParserType::Function(return_type, param_types) =>{
                let ret_llvm = self.get_llvm_representation_from_parser_type(return_type)?;
                let params_llvm: Vec<String> = param_types.iter()
                    .map(|param_type| self.get_llvm_representation_from_parser_type(param_type))
                    .collect::<Result<Vec<String>, String>>()?;
                let params_str = params_llvm.join(", "); 
                Ok(format!("{} ({})", ret_llvm, params_str))
            }
            ParserType::Named(type_name) =>{
                if let Some(x) = self.implemented_types.get(type_name) {
                    return Ok(x.llvm_representation.to_string());
                }
                Err(format!("Implementation of \"{:?}\" was not found in current context", parser_type))
            }
            ParserType::Pointer(x) =>{
                let mut inside_value = self.get_llvm_representation_from_parser_type(x)?;
                inside_value.push('*');
                return Ok(inside_value);
            }
        }
    }

    pub fn aquire_unique_temp_value_counter(&mut self) -> u32{
        self.temp_value_counter += 1;
        self.temp_value_counter - 1
    }
    pub fn aquire_unique_logic_counter(&mut self) -> u32{
        self.logic_counter += 1;
        self.logic_counter - 1
    }
    pub fn aquire_unique_const_vector_counter(&mut self) -> u32{
        self.const_vectors_counter += 1;
        self.const_vectors_counter - 1
    }

}