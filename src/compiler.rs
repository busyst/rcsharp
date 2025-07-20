use std::collections::HashMap;

use crate::{expression_compiler::compile_expression, expression_parser::Expr, parser::{ParserType, Stmt}};
pub fn rcsharp_compile_to_file(x: &[Stmt]) -> Result<(), String> {
    let direct_output = rcsharp_compile(x)?;
    let mut file = std::fs::File::create("output.ll").map_err(|e| e.to_string())?;
    std::io::Write::write_all(&mut file, direct_output.as_bytes()).map_err(|e| e.to_string())?;

    Ok(())
}

#[derive(Debug, Clone)]
pub struct Function {name:String, args: Vec<(String, ParserType)>, return_type: ParserType, body: Stmt, attribs: Vec<(String, Vec<Expr>)>}
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
                println!("{:?}",n);
                println!("{:?}",&x[0..i]);
                let mut atribs_len= 0;
                for i in (0..i).rev() {
                    if matches!(&x[i], Stmt::Hint(_, _)) {
                        atribs_len += 1;
                    }else {
                        break;
                    }
                }
                let attribs = x[i-atribs_len..i].iter().map(|x| {if let Stmt::Hint(x, y) = x {return (x.clone(),y.clone());} else {panic!()}} ).collect::<Vec<_>>();
                println!("{:?}",atribs_len);
                main_state.functions.push(Function{name:n.clone(), args: a.clone(), return_type: r.clone(), body: *b.clone(), attribs});
            },
            Stmt::Struct(n, a) => {
                println!("{:?}",n);
                println!("{:?}",&x[0..i]);
                let mut atribs_len= 0;
                for i in (0..i).rev() {
                    if matches!(&x[i], Stmt::Hint(_, _)) {
                        atribs_len += 1;
                    }else {
                        break;
                    }
                }
                let attribs = x[i-atribs_len..i].iter().map(|x| {if let Stmt::Hint(x, y) = x {return (x.clone(),y.clone());} else {panic!()}} ).collect::<Vec<_>>();
                println!("{:?}",atribs_len);
                main_state.structs.push(Struct{name: n.clone(), fields: a.clone(), attribs});
            },
            _ => {return Err(format!("Unexpected statement {:?}", statement));}
        }
    }
    compile_attributes(&mut main_state)?;
    compile_functions(&mut main_state)?;
    println!("{:?}", main_state);
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
                    underlying_representation: ParserType::Named(format!($llvm_type)),
                    explicit_casts: $casts,
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
    // Up-casting from a signed type uses sext
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
        }else {
            funcs.push(function.clone());
        }
    }
    state.functions = funcs;
    Ok(())
}
pub fn compile_functions(state :&mut CompilerState) -> Result<(), String>{
    for i in 0..state.functions.len() {
        let function = &state.functions[i];
        let function_name = function.name.clone();
        let mut args_string = String::new();
        for i in 0..function.args.len() {
            args_string.push_str(&format!("{} %{}",function.args[i].1.to_string(), function.args[i].0));
            if i + 1 != function.args.len() {
                args_string.push_str(&", ");
            }
        }
        state.output.push_str(&format!("\ndefine {} @{}({}){{\n", function.return_type.to_string(), function_name, args_string));
        state.current_function = Some(i);
        state.current_variable_stack.clear();
        state.temp_value_counter = 0;
        compile_statement(&function.body.clone(), state).map_err(|x| format!("while compiling function {}\n\r{}",function_name,x))?;

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
            state.output.push_str(&format!("    %{} = alloca {}\n", name, comp_type.underlying_representation.to_string()));
            state.current_variable_stack.insert(name.clone(), comp_type);
        }
        Stmt::Expr(expression) => { compile_expression(expression, None, state).map_err(|x| format!("while compiling expression {:?}\n\r{}",expression,x))?; }
        Stmt::Return(expression) =>{
            if let Some(expression) = expression {
                let expected_type = state.current_function_return_type()?;
                let tmp_idx = compile_expression(expression, Some(&expected_type), state)?;
                if tmp_idx.value_type != expected_type {
                    return Err(format!("Result type \"{}\" of expresion is not equal to return type \"{}\" of function \"{}\"", tmp_idx.value_type.to_string(), expected_type.to_string(), state.current_function_name()?));
                }
                state.output.push_str(&format!("    ret {} %tmp{}\n", expected_type.to_string(), tmp_idx.index));
            }
        }
        Stmt::Hint(_,_) | Stmt::Function(_, _, _, _) | Stmt::Struct(_, _)  => return Err(format!("Statement {:?} was not expected in current context", statement)),
        _ => {},
    }
    Ok(())
}
#[derive(Debug, Clone)]
pub struct CompilerType { pub parser_type: ParserType, pub underlying_representation: ParserType, pub explicit_casts: HashMap<String, Stmt>}
#[derive(Debug, Default)]
pub struct CompilerState{
    pub output: String,
    pub functions: Vec<Function>,
    pub structs: Vec<Struct>,
    pub implemented_types: HashMap<String, CompilerType>,
    current_function: Option<usize>,
    current_variable_stack: HashMap<String, CompilerType>,
    temp_value_counter: usize
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
    
    pub fn get_variable_type(&self, name: &str) -> Result<&CompilerType,String>{
        if self.current_function.is_some() {
            if self.current_variable_stack.contains_key(name) {
                return Ok(&self.current_variable_stack[name]);
            }
            return Err(format!("Variable \"{}\" was not found inside function \"{}\"",name, self.current_function_name()?));
        }
        Err(format!("Tried to get variable \"{}\" outside of function", name))
    }
    pub fn get_compiler_type_from_parser(&self, parser_type: &ParserType) -> Result<CompilerType,String>{
        if let Some(x) = self.implemented_types.get(&parser_type.to_string_core()) {
            let mut pt = x.clone();
            let mut underlying_representation = pt.underlying_representation.clone();
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
            pt.underlying_representation = underlying_representation;
            // if given parser type is ref, than add ref to compiler type
            return Ok(pt);
        }
        Err(format!("Implementation of \"{}\" was not found in current context", parser_type.to_string_core()))
    }
}