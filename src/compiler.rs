use core::str;
use std::collections::HashMap;

use crate::{expression_compiler::{compile_expression, implicit_cast, Expected}, expression_parser::{BinaryOp, Expr}, parser::{ParserType, Stmt}};
pub fn rcsharp_compile_to_file(x: &[Stmt]) -> Result<(), String> {
    let direct_output = rcsharp_compile(x)?;
    let mut file = std::fs::File::create("output.ll").map_err(|e| e.to_string())?;
    std::io::Write::write_all(&mut file, direct_output.as_bytes()).map_err(|e| e.to_string())?;

    Ok(())
}

#[derive(Debug, Clone)]
pub struct Function {pub name:String, pub args: Vec<(String, ParserType)>,pub return_type: ParserType, pub body: Vec<Stmt>,pub attribs: Vec<(String, Vec<Expr>)>}
#[derive(Debug, Clone)]
#[allow(dead_code)]
pub struct Struct {name:String, fields: Vec<(String, ParserType)>, attribs: Vec<(String, Vec<Expr>)>}
pub fn rcsharp_compile(x: &[Stmt]) -> Result<String, String> {
    let mut main_state = CompilerState::default();
    //main_state.output.push_str("target triple = \"x86_64-pc-windows-msvc\"\n");
    populate_default_types(&mut main_state)?;
    for i in 0..x.len() {
        let statement = &x[i];
        match statement {
            Stmt::Hint(x, y) => {
                match x.as_str() {
                    "include" => {
                        if let Expr::StringConst(x) = &y[0] {
                            main_state.output.push_str_header(&format!(";include {}\n", x));
                        }
                    }
                    _ => {}
                }
            }
            Stmt::Function(n, a, r, b) => {
                let mut atribs_len= 0;
                for i in (0..i).rev() {
                    if matches!(&x[i], Stmt::Hint(_, _)) {
                        atribs_len += 1;
                    }else {
                        break;
                    }
                }
                let attribs = x[i-atribs_len..i].iter().map(|x| {if let Stmt::Hint(x, y) = x {return (x.clone(),y.clone());} else {panic!()}} ).collect::<Vec<_>>();
                main_state.functions.push(Function{name:n.clone(), args: a.clone(), return_type: r.clone(), body: b.to_vec(), attribs});
            },
            Stmt::Struct(n, a) => {
                /*let mut atribs_len= 0;
                for i in (0..i).rev() {
                    if matches!(&x[i], Stmt::Hint(_, _)) {
                        atribs_len += 1;
                    }else {
                        break;
                    }
                }*/
                //let attribs = x[i-atribs_len..i].iter().map(|x| {if let Stmt::Hint(x, y) = x {return (x.clone(),y.clone());} else {panic!()}} ).collect::<Vec<_>>();
                let name = n.clone();
                let fields = a.clone();
                let struct_pt = (name.clone(),fields.iter().map(|x|x.clone()).collect::<Vec<_>>(), vec![]);

                main_state.implemented_types.insert(name.clone(), CompilerType { 
                    parser_type: ParserType::Named(name.clone()),
                    llvm_representation: ParserType::Named(format!("%struct.{}", name.clone())), 
                    struct_representation : struct_pt,
                    explicit_casts: HashMap::new(), _binary_operations: HashMap::new() 
                });
            },
            _ => {return Err(format!("Unexpected statement {:?}", statement));}
        }
    }
    compile_structs(&mut main_state)?;
    compile_attributes(&mut main_state)?;
    compile_functions(&mut main_state)?;
    Ok(main_state.output.output())
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
fn compile_attributes(state :&mut CompilerState) -> Result<(), String>{
    let mut funcs = vec![];
    let mut extention_funcs_to_structs = vec![];
    for function in &state.functions {
        if let Some(_) =  function.attribs.iter().find(|x| x.0 == "DllImport") {
            let mut args_string = String::new();
            let func_return_type_string = function.return_type.to_string();
            for i in 0..function.args.len() {
                args_string.push_str(&function.args[i].1.to_string());
                if i + 1 != function.args.len() {
                    args_string.push_str(&", ");
                }
            }
            state.output.push_str_header(&format!("declare dllimport {} @{}({})\n", func_return_type_string, function.name, args_string));
            state.declared_functions.push(function.clone());
        }else if let Some(i) =  function.attribs.iter().find(|x| x.0 == "ExtentionOf") {
            if i.1.is_empty() {
                return Err(format!("Extention should not be empty"));
            }
            if i.1.len() != 1 {
                return Err(format!("Extention should have only 1 argument, type that will be extended"));
            }
            let function_name = &function.name;
            let extended_type = crate::expression_compiler::type_from_expression(&i.1[0])?;
            if extended_type.is_pointer() {
                return Err(format!("You cant extend pointer to type"));
            }
            let _x = state.get_compiler_type_from_parser(&extended_type)
                .map_err(|_| format!("Type \"{}\" was not found to extend in current context", extended_type.to_string()))?;
            
            if function.args.is_empty() || function.args[0].1 != extended_type.reference_once() {
                return Err(format!("Function \"{}\" is extention of \"{}\" struct, this function should have reference to value as first argument. Ex:\n[ExtentionOf(i32)]\nfn foo(val: &i32, ...){{...}}", function_name, extended_type.to_string()));
            }
            extention_funcs_to_structs.push((extended_type, function));
            state.declared_functions.push(function.clone());
            funcs.push(function.clone());
        }
        else {
            state.declared_functions.push(function.clone());
            funcs.push(function.clone());
        }
    }
    for x in extention_funcs_to_structs {
        let _extended_type = state.get_compiler_type_from_parser(&x.0)?;
        let extention_function = x.1;
        let x = &mut state.implemented_types.get_mut(&x.0.to_string()).unwrap().struct_representation;
        x.2.push((extention_function.name.clone(), (extention_function.return_type.clone(), extention_function.args.iter().map(|x| x.1.clone()).collect::<Vec<_>>())));
    }
    state.functions = funcs;
    Ok(())
}
fn compile_structs(main_state: &mut CompilerState) -> Result<(), String> {
    for parsed_struct in main_state.implemented_types.iter().filter(|x| !x.1.parser_type.is_simple_type()).map(|x| x.1.struct_representation.clone()) {
        let name = &parsed_struct.0;
        let fields = &parsed_struct.1;
        let fields = fields.iter().map(|x| main_state.get_llvm_representation_from_parser_type(&x.1))
        .collect::<Result<Vec<_>,String>>()?.join(",");
        main_state.output.push_str_header(&format!("%struct.{} = type {{{}}}\n", name, fields));
    }
    Ok(())
}
fn compile_functions(state :&mut CompilerState) -> Result<(), String>{
    for i in 0..state.functions.len() {
        let function = &state.functions[i];
        let function_name = function.name.clone();
        let function_return_type = state.get_compiler_type_from_parser(&function.return_type)?.llvm_representation;
        let mut arg_parts = Vec::new();
        for (arg_name, arg_type) in &function.args {
            let compiler_type = state.get_compiler_type_from_parser(arg_type)?;
            let type_string = compiler_type.llvm_representation.to_string();
            let formatted_arg = format!("{} %{}", type_string, arg_name);
            arg_parts.push(formatted_arg);
        }
        let args_string = arg_parts.join(", ");
        state.output.push_str(&format!("\ndefine {} @{}({}){{\n", function_return_type.to_string(), function_name, args_string));
        state.current_function = i as u32;
        state.current_variable_stack.clear();
        state.temp_value_counter = 0;
        for arg in &function.args {
            let val_type = state.get_compiler_type_from_parser(&arg.1)?;
            //state.output.push_str(&format!("    %{}.addr = alloca {}\n", arg.0, val_type.llvm_representation.to_string()));
            //state.output.push_str(&format!("    store {} %{}, {}* %{}.addr\n", val_type.llvm_representation.to_string(), arg.0, val_type.llvm_representation.to_string(), arg.0));
            state.current_function_arguments.insert(arg.0.clone(), val_type);
        }
        for x in &function.body.clone() {
            compile_statement(x, state)
            .map_err(|x| format!("while compiling function {}\n\r{}",function_name,x))?;
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
                let expected_type = state.current_function_return_type()?;
                let function_actual_return_type = state.get_compiler_type_from_parser(&expected_type)?.llvm_representation;
                let tmp_idx = compile_expression(expression, Expected::Type(&expected_type), state)
                    .map_err(|x| format!("while compiling expression in return statement {:?}:\n{}", expression, x))?;
                if !tmp_idx.equal_to_type(&expected_type) {
                    return Err(format!("Result type \"{:?}\" of expresion is not equal to return type \"{:?}\" of function \"{}\"", tmp_idx, function_actual_return_type, state.current_function_name()?));
                }
                state.output.push_str(&format!("    ret {} {}\n", function_actual_return_type.to_string(), tmp_idx.to_repr()));
            }else {
                let expected_type = state.current_function_return_type()?;
                if expected_type != ParserType::Named(format!("void")) {
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

    pub functions: Vec<Function>,
    pub declared_functions: Vec<Function>,
    
    pub implemented_types: HashMap<String, CompilerType>,

    current_function: u32,
    current_logic_counter_function: u32,
    current_variable_stack: HashMap<String, CompilerType>,
    current_function_arguments: HashMap<String, CompilerType>,

    const_vectors_counter: usize,
    temp_value_counter: usize,
    logic_counter: usize,
}
impl CompilerState {
    pub fn current_function_return_type(&self) -> Result<ParserType,String>{
        let idx = self.current_function;
        let function = &self.functions[idx as usize];
        return Ok(function.return_type.clone());
    }
    pub fn current_function_name(&self) -> Result<String,String>{
        let idx = self.current_function;
        let function = &self.functions[idx as usize];
        return Ok(function.name.clone());
    }
    pub fn aquire_unique_temp_value_counter(&mut self) -> usize{
        self.temp_value_counter += 1;
        self.temp_value_counter - 1
    }
    pub fn aquire_unique_logic_counter(&mut self) -> usize{
        self.const_vectors_counter += 1;
        self.const_vectors_counter - 1
    }
    pub fn aquire_unique_const_vector_counter(&mut self) -> usize{
        self.logic_counter += 1;
        self.logic_counter - 1
    }
    pub fn get_variable_type(&self, name: &str) -> Result<&CompilerType,String>{
        if self.current_variable_stack.contains_key(name) {
            return Ok(&self.current_variable_stack[name]);
        }
        return Err(format!("Variable \"{}\" was not found inside function \"{}\"",name, self.current_function_name()?));
    }
    pub fn get_argument_type(&self, name: &str) -> Result<&CompilerType,String>{
        if self.current_function_arguments.contains_key(name) {
            return Ok(&self.current_function_arguments[name]);
        }
        return Err(format!("Variable or Argument \"{}\" was not found inside function \"{}\"",name, self.current_function_name()?));
    }
    pub fn get_variable_or_argument_type(&self, name: &str) -> Result<&CompilerType,String>{
        if self.current_variable_stack.contains_key(name) {
            return Ok(&self.current_variable_stack[name]);
        }
        if self.current_function_arguments.contains_key(name) {
            return Ok(&self.current_function_arguments[name]);
        }
        return Err(format!("Argument \"{}\" was not found inside function \"{}\"",name, self.current_function_name()?));
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
    pub fn get_function(&self, name: &str) -> Result<&Function,String>{
        if let Some(f) = self.declared_functions.iter().find(|x| x.name == name){
            return Ok(f);
        }
        Err(format!("Function \"{}\" was not found in current context", name))
    }
}