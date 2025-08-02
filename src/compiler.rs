use std::collections::HashMap;

use crate::{expression_compiler::{compile_expression, implicit_cast, Expected}, expression_parser::{BinaryOp, Expr}, parser::{ParserType, Stmt}};
pub fn rcsharp_compile_to_file(x: &[Stmt]) -> Result<(), String> {
    let direct_output = rcsharp_compile(x)?;
    let mut file = std::fs::File::create("output.ll").map_err(|e| e.to_string())?;
    std::io::Write::write_all(&mut file, direct_output.as_bytes()).map_err(|e| e.to_string())?;

    Ok(())
}

#[derive(Debug, Clone)]
pub struct Function {pub name:String,pub args: Vec<(String, ParserType)>,pub return_type: ParserType,pub body: Stmt,pub attribs: Vec<(String, Vec<Expr>)>}
#[derive(Debug, Clone)]
#[allow(dead_code)]
pub struct Struct {name:String, fields: Vec<(String, ParserType)>, attribs: Vec<(String, Vec<Expr>)>}
pub fn rcsharp_compile(x: &[Stmt]) -> Result<String, String> {
    let mut main_state = CompilerState::default();
    main_state.output.push_str("target triple = \"x86_64-pc-windows-msvc\"\n");
    populate_default_types(&mut main_state)?;
    for i in 0..x.len() {
        let statement = &x[i];
        match statement {
            Stmt::Hint(_, _) => {}
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
                main_state.functions.push(Function{name:n.clone(), args: a.clone(), return_type: r.clone(), body: *b.clone(), attribs});
            },
            Stmt::Struct(n, a) => {
                let mut atribs_len= 0;
                for i in (0..i).rev() {
                    if matches!(&x[i], Stmt::Hint(_, _)) {
                        atribs_len += 1;
                    }else {
                        break;
                    }
                }
                let attribs = x[i-atribs_len..i].iter().map(|x| {if let Stmt::Hint(x, y) = x {return (x.clone(),y.clone());} else {panic!()}} ).collect::<Vec<_>>();
                main_state.structs.push(Struct{name: n.clone(), fields: a.clone(), attribs});
            },
            _ => {return Err(format!("Unexpected statement {:?}", statement));}
        }
    }
    compile_attributes(&mut main_state)?;
    compile_structs(&mut main_state)?;
    compile_functions(&mut main_state)?;
    Ok(main_state.output)
}

pub fn populate_default_types(state: &mut CompilerState) -> Result<(), String> {
    // Was AI assisted
    macro_rules! define_type {
        ($state:expr, $name:expr, $llvm_type:expr, $casts:expr) => {
            $state.implemented_types.insert(
                format!($name),
                CompilerType {
                    parser_type: ParserType::Named(format!($name)),
                    llvm_representation: ParserType::Named(format!($llvm_type)),
                    struct_representation: ParserType::Structure(format!($llvm_type),vec![]),
                    explicit_casts: $casts,
                    _binary_operations: HashMap::new(),
                },
            );
        };
    }
    // === bool ===
    let mut bool_casts = HashMap::new();
    bool_casts.insert(format!("i8"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = zext i1 %tmp{{v}} to i8\n")));
    bool_casts.insert(format!("u8"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = zext i1 %tmp{{v}} to i8\n")));
    bool_casts.insert(format!("i16"), Stmt::DirectInsertion(format!("    %tmp{{o}} = zext i1 %tmp{{v}} to i16\n")));
    bool_casts.insert(format!("u16"), Stmt::DirectInsertion(format!("    %tmp{{o}} = zext i1 %tmp{{v}} to i16\n")));
    bool_casts.insert(format!("i32"), Stmt::DirectInsertion(format!("    %tmp{{o}} = zext i1 %tmp{{v}} to i32\n")));
    bool_casts.insert(format!("u32"), Stmt::DirectInsertion(format!("    %tmp{{o}} = zext i1 %tmp{{v}} to i32\n")));
    bool_casts.insert(format!("i64"), Stmt::DirectInsertion(format!("    %tmp{{o}} = zext i1 %tmp{{v}} to i64\n")));
    bool_casts.insert(format!("u64"), Stmt::DirectInsertion(format!("    %tmp{{o}} = zext i1 %tmp{{v}} to i64\n")));
    define_type!(state, "bool", "i1", bool_casts);

    // === i8 ===
    let mut i8_casts = HashMap::new();
    i8_casts.insert(format!("bool"), Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i8 %tmp{{v}} to i1\n")));
    i8_casts.insert(format!("u8"),   Stmt::DirectInsertion(format!("    %tmp{{o}} = bitcast i8 %tmp{{v}} to i8\n")));
    i8_casts.insert(format!("i16"), Stmt::DirectInsertion(format!("    %tmp{{o}} = sext i8 %tmp{{v}} to i16\n")));
    i8_casts.insert(format!("u16"), Stmt::DirectInsertion(format!("    %tmp{{o}} = sext i8 %tmp{{v}} to i16\n")));
    i8_casts.insert(format!("i32"), Stmt::DirectInsertion(format!("    %tmp{{o}} = sext i8 %tmp{{v}} to i32\n")));
    i8_casts.insert(format!("u32"), Stmt::DirectInsertion(format!("    %tmp{{o}} = sext i8 %tmp{{v}} to i32\n")));
    i8_casts.insert(format!("i64"), Stmt::DirectInsertion(format!("    %tmp{{o}} = sext i8 %tmp{{v}} to i64\n")));
    i8_casts.insert(format!("u64"), Stmt::DirectInsertion(format!("    %tmp{{o}} = sext i8 %tmp{{v}} to i64\n")));
    define_type!(state, "i8", "i8", i8_casts);

    // === u8 ===
    let mut u8_casts = HashMap::new();
    u8_casts.insert(format!("bool"), Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i8 %tmp{{v}} to i1\n")));
    u8_casts.insert(format!("i8"),   Stmt::DirectInsertion(format!("    %tmp{{o}} = bitcast i8 %tmp{{v}} to i8\n")));
    u8_casts.insert(format!("i16"), Stmt::DirectInsertion(format!("    %tmp{{o}} = zext i8 %tmp{{v}} to i16\n")));
    u8_casts.insert(format!("u16"), Stmt::DirectInsertion(format!("    %tmp{{o}} = zext i8 %tmp{{v}} to i16\n")));
    u8_casts.insert(format!("i32"), Stmt::DirectInsertion(format!("    %tmp{{o}} = zext i8 %tmp{{v}} to i32\n")));
    u8_casts.insert(format!("u32"), Stmt::DirectInsertion(format!("    %tmp{{o}} = zext i8 %tmp{{v}} to i32\n")));
    u8_casts.insert(format!("i64"), Stmt::DirectInsertion(format!("    %tmp{{o}} = zext i8 %tmp{{v}} to i64\n")));
    u8_casts.insert(format!("u64"), Stmt::DirectInsertion(format!("    %tmp{{o}} = zext i8 %tmp{{v}} to i64\n")));
    define_type!(state, "u8", "i8", u8_casts);

    // === i16 ===
    let mut i16_casts = HashMap::new();
    i16_casts.insert(format!("bool"), Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i16 %tmp{{v}} to i1\n")));
    i16_casts.insert(format!("i8"),   Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i16 %tmp{{v}} to i8\n")));
    i16_casts.insert(format!("u8"),   Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i16 %tmp{{v}} to i8\n")));
    i16_casts.insert(format!("u16"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = bitcast i16 %tmp{{v}} to i16\n")));
    i16_casts.insert(format!("i32"), Stmt::DirectInsertion(format!("    %tmp{{o}} = sext i16 %tmp{{v}} to i32\n")));
    i16_casts.insert(format!("u32"), Stmt::DirectInsertion(format!("    %tmp{{o}} = sext i16 %tmp{{v}} to i32\n")));
    i16_casts.insert(format!("i64"), Stmt::DirectInsertion(format!("    %tmp{{o}} = sext i16 %tmp{{v}} to i64\n")));
    i16_casts.insert(format!("u64"), Stmt::DirectInsertion(format!("    %tmp{{o}} = sext i16 %tmp{{v}} to i64\n")));
    define_type!(state, "i16", "i16", i16_casts);

    // === u16 ===
    let mut u16_casts = HashMap::new();
    u16_casts.insert(format!("bool"), Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i16 %tmp{{v}} to i1\n")));
    u16_casts.insert(format!("i8"),   Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i16 %tmp{{v}} to i8\n")));
    u16_casts.insert(format!("u8"),   Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i16 %tmp{{v}} to i8\n")));
    u16_casts.insert(format!("i16"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = bitcast i16 %tmp{{v}} to i16\n")));
    u16_casts.insert(format!("i32"), Stmt::DirectInsertion(format!("    %tmp{{o}} = zext i16 %tmp{{v}} to i32\n")));
    u16_casts.insert(format!("u32"), Stmt::DirectInsertion(format!("    %tmp{{o}} = zext i16 %tmp{{v}} to i32\n")));
    u16_casts.insert(format!("i64"), Stmt::DirectInsertion(format!("    %tmp{{o}} = zext i16 %tmp{{v}} to i64\n")));
    u16_casts.insert(format!("u64"), Stmt::DirectInsertion(format!("    %tmp{{o}} = zext i16 %tmp{{v}} to i64\n")));
    define_type!(state, "u16", "i16", u16_casts);

    // === i32 ===
    let mut i32_casts = HashMap::new();
    i32_casts.insert(format!("bool"), Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i32 %tmp{{v}} to i1\n")));
    i32_casts.insert(format!("i8"),   Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i32 %tmp{{v}} to i8\n")));
    i32_casts.insert(format!("u8"),   Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i32 %tmp{{v}} to i8\n")));
    i32_casts.insert(format!("i16"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i32 %tmp{{v}} to i16\n")));
    i32_casts.insert(format!("u16"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i32 %tmp{{v}} to i16\n")));
    i32_casts.insert(format!("u32"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = bitcast i32 %tmp{{v}} to i32\n")));
    i32_casts.insert(format!("i64"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = sext i32 %tmp{{v}} to i64\n")));
    i32_casts.insert(format!("u64"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = sext i32 %tmp{{v}} to i64\n")));
    define_type!(state, "i32", "i32", i32_casts);

    // === u32 ===
    let mut u32_casts = HashMap::new();
    u32_casts.insert(format!("bool"), Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i32 %tmp{{v}} to i1\n")));
    u32_casts.insert(format!("i8"),   Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i32 %tmp{{v}} to i8\n")));
    u32_casts.insert(format!("u8"),   Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i32 %tmp{{v}} to i8\n")));
    u32_casts.insert(format!("i16"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i32 %tmp{{v}} to i16\n")));
    u32_casts.insert(format!("u16"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i32 %tmp{{v}} to i16\n")));
    u32_casts.insert(format!("i32"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = bitcast i32 %tmp{{v}} to i32\n")));
    u32_casts.insert(format!("i64"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = zext i32 %tmp{{v}} to i64\n")));
    u32_casts.insert(format!("u64"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = zext i32 %tmp{{v}} to i64\n")));
    define_type!(state, "u32", "i32", u32_casts);

    // === i64 ===
    let mut i64_casts = HashMap::new();
    i64_casts.insert(format!("bool"), Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i64 %tmp{{v}} to i1\n")));
    i64_casts.insert(format!("i8"),   Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i64 %tmp{{v}} to i8\n")));
    i64_casts.insert(format!("u8"),   Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i64 %tmp{{v}} to i8\n")));
    i64_casts.insert(format!("i16"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i64 %tmp{{v}} to i16\n")));
    i64_casts.insert(format!("u16"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i64 %tmp{{v}} to i16\n")));
    i64_casts.insert(format!("i32"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i64 %tmp{{v}} to i32\n")));
    i64_casts.insert(format!("u32"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i64 %tmp{{v}} to i32\n")));
    i64_casts.insert(format!("u64"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = bitcast i64 %tmp{{v}} to i64\n")));
    define_type!(state, "i64", "i64", i64_casts);

    // === u64 ===
    let mut u64_casts = HashMap::new();
    u64_casts.insert(format!("bool"), Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i64 %tmp{{v}} to i1\n")));
    u64_casts.insert(format!("i8"),   Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i64 %tmp{{v}} to i8\n")));
    u64_casts.insert(format!("u8"),   Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i64 %tmp{{v}} to i8\n")));
    u64_casts.insert(format!("i16"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i64 %tmp{{v}} to i16\n")));
    u64_casts.insert(format!("u16"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i64 %tmp{{v}} to i16\n")));
    u64_casts.insert(format!("i32"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i64 %tmp{{v}} to i32\n")));
    u64_casts.insert(format!("u32"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = trunc i64 %tmp{{v}} to i32\n")));
    u64_casts.insert(format!("i64"),  Stmt::DirectInsertion(format!("    %tmp{{o}} = bitcast i64 %tmp{{v}} to i64\n")));
    define_type!(state, "u64", "i64", u64_casts);

    define_type!(state, "void", "void", HashMap::new());
    Ok(())
}
pub fn compile_attributes(state :&mut CompilerState) -> Result<(), String>{
    let mut funcs = vec![];

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
            state.output.push_str(&format!("declare dllimport {} @{}({})\n", func_return_type_string, function.name, args_string));
            state.declared_functions.push(function.clone());
        }else {
            state.declared_functions.push(function.clone());
            funcs.push(function.clone());
        }
    }
    state.functions = funcs;
    Ok(())
}
fn compile_structs(main_state: &mut CompilerState) -> Result<(), String> {
    for parsed_struct in &main_state.structs {
        let name = &parsed_struct.name;
        let fields = &parsed_struct.fields;
        let struct_pt = ParserType::Structure(name.clone(),fields.iter().map(|x|x.clone()).collect::<Vec<_>>());

        main_state.implemented_types.insert(name.clone(), CompilerType { 
            parser_type: ParserType::Named(name.clone()),
            llvm_representation: ParserType::Named(format!("%struct.{}", name.clone())), 
            struct_representation : struct_pt,
            explicit_casts: HashMap::new(), _binary_operations: HashMap::new() 
        });
    }
    for parsed_struct in &main_state.structs {
        let name = &parsed_struct.name;
        let fields = &parsed_struct.fields;
        let fields = fields.iter().map(|x| main_state.get_compiler_type_from_parser(&x.1).unwrap().llvm_representation.to_string())
        .collect::<Vec<_>>().join(",");
        main_state.output.push_str(&format!("%struct.{} = type {{{}}}\n", name, fields));
    }
    Ok(())
}
pub fn compile_functions(state :&mut CompilerState) -> Result<(), String>{
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
        state.current_function = Some(i);
        state.current_variable_stack.clear();
        state.temp_value_counter = 0;
        for arg in &function.args {
            let val_type = state.get_compiler_type_from_parser(&arg.1)?;
            state.output.push_str(&format!("    %{}.addr = alloca {}\n", arg.0, val_type.llvm_representation.to_string()));
            state.output.push_str(&format!("    store {} %{}, {}* %{}.addr\n", val_type.llvm_representation.to_string(), arg.0, val_type.llvm_representation.to_string(), arg.0));
            state.current_function_arguments.insert(arg.0.clone(), val_type);
        }
        compile_statement(&function.body.clone(), state).map_err(|x| format!("while compiling function {}\n\r{}",function_name,x))?;
        if function_return_type.to_string() == "void" {
            state.output.push_str(&format!("    ret void\n"));
        }
        state.output.push_str(&format!("\n    unreachable\n}}\n"));
    }
    Ok(())
}
pub fn compile_statement(statement: &Stmt,state :&mut CompilerState) -> Result<(), String>{
    match &statement {
        Stmt::Block(statement) => {
            for statement in statement {
                compile_statement(statement, state)?;
            }
        }
        Stmt::Let(name, var_type) => {
            let comp_type = state.get_compiler_type_from_parser(var_type)?;
            state.output.push_str(&format!("    %{} = alloca {}\n", name, comp_type.llvm_representation.to_string()));
            state.current_variable_stack.insert(name.clone(), comp_type);
        }
        Stmt::Expr(expression) => { compile_expression(expression, Expected::NoReturn, state).map_err(|x| format!("while compiling expression {:?}\n\r{}",expression,x))?; }
        Stmt::Return(expression) =>{
            if let Some(expression) = expression {
                let expected_type = state.current_function_return_type()?;
                let function_actual_return_type = state.get_compiler_type_from_parser(&expected_type)?.llvm_representation;
                let tmp_idx = compile_expression(expression, Expected::Type(&expected_type), state)?;
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
        Stmt::Continue => {state.output.push_str(&format!("    br label %loop_body{}\n", state.current_logic_counter_function.unwrap()));}
        Stmt::Break => {state.output.push_str(&format!("    br label %loop_body{}_exit\n", state.current_logic_counter_function.unwrap()));}
        Stmt::If(condition, then_stmt, else_stmt) => {
            let expected_type = ParserType::Named(format!("bool"));
            let mut cond_val = compile_expression(condition, Expected::Type(&expected_type), state)
            .map_err(|x| format!("while compiling expression in if statement {:?}:\n{}",condition, x))?;
            let logic_u = state.aquire_unique_logic_counter();
            if !cond_val.equal_to_type(&expected_type) {
                cond_val = implicit_cast(&cond_val, &expected_type, state)?
            }
            if let Some(stmt) = else_stmt {
                state.output.push_str(&format!("    br {}, label %then{}, label %else{}\n", cond_val.to_repr_with_type(state)?, logic_u, logic_u));
                state.output.push_str(&format!("then{}:\n", logic_u));
                compile_statement(&then_stmt, state)
                .map_err(|x| format!("while compiling body of if statement {:?}:\n{}",condition, x))?;
                state.output.push_str(&format!("    br label %end_if{}\n", logic_u));
                state.output.push_str(&format!("else{}:\n", logic_u));

                compile_statement(&stmt, state)
                .map_err(|x| format!("while compiling else body of if statement {:?}:\n{}",condition, x))?;
                state.output.push_str(&format!("    br label %end_if{}\n", logic_u));
                state.output.push_str(&format!("end_if{}:\n", logic_u));
            }else {
                state.output.push_str(&format!("    br {}, label %then{}, label %end_if{}\n", cond_val.to_repr_with_type(state)?, logic_u, logic_u));
                state.output.push_str(&format!("then{}:\n", logic_u)); 
                compile_statement(&then_stmt, state)
                .map_err(|x| format!("while compiling body of if statement {:?}:\n{}",condition, x))?;
                state.output.push_str(&format!("    br label %end_if{}\n", logic_u));
                state.output.push_str(&format!("end_if{}:\n", logic_u));
            }
        }
        Stmt::Loop(statement) =>{
            let lc = state.aquire_unique_logic_counter();
            
            state.output.push_str(&format!("    br label %loop_body{}\n", lc));
            state.output.push_str(&format!("loop_body{}:\n", lc));

            state.current_logic_counter_function = Some(lc);
            compile_statement(statement, state)?;
            state.current_logic_counter_function = None;
            state.output.push_str(&format!("    br label %loop_body{}\n", lc));
            state.output.push_str(&format!("loop_body{}_exit:\n", lc));
        }
        Stmt::Hint(_,_) | Stmt::Function(_, _, _, _) | Stmt::Struct(_, _)  => return Err(format!("Statement {:?} was not expected in current context", statement)),
        _ => panic!("{:?}", statement),
    }
    Ok(())
}
#[derive(Debug, Clone)]
pub struct CompilerType { pub parser_type: ParserType, pub llvm_representation: ParserType, pub struct_representation: ParserType, pub explicit_casts: HashMap<String, Stmt>,  pub _binary_operations: HashMap<BinaryOp, HashMap<String, String>>, }
impl CompilerType { 
    pub fn sizeof(&self, state :&mut CompilerState) -> u32 { 
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
                                if let ParserType::Structure(_, f) = &state.implemented_types[t].struct_representation.clone() {
                                    return f.iter().map(|x| state.get_compiler_type_from_parser(&x.1).unwrap().sizeof(state)).sum();
                                }
                            }

                        }
                        todo!("{:?}", x)
                    }
                }
            }
            ParserType::Ref(_) => 8,
            _ => todo!("{:?}", self.llvm_representation)
        }
    } 
}
#[derive(Debug, Default)]
pub struct CompilerState{
    pub output: String,
    pub functions: Vec<Function>,
    pub declared_functions: Vec<Function>,
    pub structs: Vec<Struct>,
    pub implemented_types: HashMap<String, CompilerType>,

    current_function: Option<usize>,
    current_logic_counter_function: Option<usize>,
    current_variable_stack: HashMap<String, CompilerType>,
    pub current_function_arguments: HashMap<String, CompilerType>,
    temp_value_counter: usize,
    logic_counter: usize,
}
impl CompilerState {
    pub fn current_function_return_type(&self) -> Result<ParserType,String>{
        let idx = self.current_function.ok_or(format!("Tried to get current function return type outside of function"))?;
        let function = &self.functions[idx];
        return Ok(function.return_type.clone());
    }
    pub fn current_function_name(&self) -> Result<String,String>{
        let idx = self.current_function.ok_or(format!("Tried to get current function return type outside of function"))?;
        let function = &self.functions[idx];
        return Ok(function.name.clone());
    }
    pub fn aquire_unique_temp_value_counter(&mut self) -> usize{
        self.temp_value_counter += 1;
        self.temp_value_counter - 1
    }
    pub fn aquire_unique_logic_counter(&mut self) -> usize{
        self.logic_counter += 1;
        self.logic_counter - 1
    }
    pub fn get_variable_type(&self, name: &str) -> Result<&CompilerType,String>{
        if self.current_function.is_some() {
            if self.current_variable_stack.contains_key(name) {
                return Ok(&self.current_variable_stack[name]);
            }
            return Err(format!("Variable \"{}\" was not found inside function \"{}\"",name, self.current_function_name()?));
        }
        Err(format!("Tried to get variable \"{}\" outside of function", name))
    }
    pub fn get_argument_type(&self, name: &str) -> Result<&CompilerType,String>{
        if self.current_function.is_some() {
            if self.current_function_arguments.contains_key(name) {
                return Ok(&self.current_function_arguments[name]);
            }
            return Err(format!("Argument \"{}\" was not found inside function \"{}\"",name, self.current_function_name()?));
        }
        Err(format!("Tried to get argument \"{}\" outside of function", name))
    }
    pub fn get_compiler_type_from_parser(&self, parser_type: &ParserType) -> Result<CompilerType,String>{
        if let Some(x) = self.implemented_types.get(&parser_type.to_string_core()) {
            let mut pt = x.clone();
            let mut underlying_representation = pt.llvm_representation.clone();
            let mut pv = parser_type.clone();
            loop {
                if let ParserType::Ref(r) = pv {
                    pv = *r.clone();
                    underlying_representation = ParserType::Ref(Box::new(underlying_representation));
                    continue;
                }
                break;
            }
            pt.parser_type = parser_type.clone();
            pt.llvm_representation = underlying_representation;
            // if given parser type is ref, than add ref to compiler type
            return Ok(pt);
        }
        Err(format!("Implementation of \"{}\" was not found in current context", parser_type.to_string_core()))
    }
    pub fn get_function(&self, name: &str) -> Result<&Function,String>{
        if let Some(f) = self.declared_functions.iter().find(|x| x.name == name){
            return Ok(f);
        }
        Err(format!("Function \"{}\" was not found in current context", name))
    }
}