use core::str;
use std::cell::Cell;

use ordered_hash_map::OrderedHashMap;

use crate::{compiler_essentials::{Attribute, CompilerType, Function, Scope, Struct, Variable}, expression_compiler::{compile_expression, implicit_cast, Expected}, expression_parser::Expr, parser::{ParserType, Stmt}};
pub fn rcsharp_compile_to_file(x: &[Stmt]) -> Result<(), String> {
    let mut state = CompilerState::default();
    rcsharp_compile(x, &mut state)?;
    let direct_output = state.output.output();
    let mut file = std::fs::File::create("output.ll").map_err(|e| e.to_string())?;
    std::io::Write::write_all(&mut file, direct_output.as_bytes()).map_err(|e| e.to_string())?;

    Ok(())
}



pub fn rcsharp_compile(x: &[Stmt], main_state :&mut CompilerState) -> Result<(), String> {
    main_state.output.push_str_header("target triple = \"x86_64-pc-windows-msvc\"\n");
    populate_default_types(main_state)?;
    pre_compile(x, main_state)?;
    compile_structs(main_state)?;
    compile_attributes(main_state)?;
    compile_functions(main_state)?;
    Ok(())
}
fn pre_compile(x: &[Stmt], state :&mut CompilerState) -> Result<(), String>{
    return recursive_pre_compile(x,"", state);
}
fn recursive_pre_compile(x: &[Stmt], current_path: &str, state: &mut CompilerState) -> Result<(), String>{
    for i in 0..x.len() {
        let statement = &x[i];
        match statement {
            Stmt::Function(n, a, r, b) => {
                let mut atribs_len = 0;
                for j in (0..i).rev() {
                    if matches!(&x[j], Stmt::Hint(_, _)) { atribs_len += 1; } 
                    else { break; }
                }
                let attribs = x[i-atribs_len..i].iter().map(|x| {if let Stmt::Hint(x, y) = x {return Attribute::new(x.clone().into_boxed_str(),y.clone());} else {panic!()}} ).collect::<Vec<_>>();

                let full_name = if current_path.is_empty() {
                    n.clone()
                } else {
                    format!("{}.{}", current_path, n)
                };

                let function = Function::new(
                    current_path.to_string(),
                    n.clone(),
                    a.clone(), 
                    r.clone(), 
                    b.to_vec(), 
                    attribs,
                    Cell::new(0),
                );

                if state.declared_functions.contains_key(&full_name) {
                    return Err(format!("Function '{}' already defined in this scope.", n));
                }
                state.declared_functions.insert(full_name, function);
            },
            Stmt::Struct(n, a) => {
                let full_name = if current_path.is_empty() {
                    n.clone()
                } else {
                    format!("{}.{}", current_path, n)
                };

                let fields = a.clone();
                let struct_pt = (full_name.clone(), fields.iter().map(|x|x.clone()).collect::<Vec<_>>(), vec![]);
                
                if state.declared_types.contains_key(&full_name) {
                     return Err(format!("Type '{}' already defined in this scope.", n));
                }
                state.declared_types.insert(full_name.clone(), Struct::new(current_path.to_string().into_boxed_str(), n.clone().into_boxed_str(), fields, vec![], Cell::new(0)));
                
                state.structures_of_types.insert(full_name.clone(), struct_pt);
            },
            Stmt::Namespace(name, body) =>{
                let new_path = if current_path.is_empty() {
                    name.clone()
                } else {
                    format!("{}.{}", current_path, name)
                };
                recursive_pre_compile(body, &new_path, state)?;
            }
            Stmt::Hint(_, _) => {}
            _ => {return Err(format!("Unexpected statement during pre-compilation: {:?}", statement));}
        }
    }
    Ok(())
}

fn populate_default_types(state: &mut CompilerState) -> Result<(), String> {
    state.declared_types.insert("i8".to_string(), Struct::new_primitive("i8"));
    state.declared_types.insert("u8".to_string(), Struct::new_primitive("u8"));
    state.declared_types.insert("i16".to_string(), Struct::new_primitive("i16"));
    state.declared_types.insert("u16".to_string(), Struct::new_primitive("u16"));
    state.declared_types.insert("i32".to_string(), Struct::new_primitive("i32"));
    state.declared_types.insert("u32".to_string(), Struct::new_primitive("u32"));
    state.declared_types.insert("i64".to_string(), Struct::new_primitive("i64"));
    state.declared_types.insert("u64".to_string(), Struct::new_primitive("u64"));
    state.declared_types.insert("bool".to_string(), Struct::new_primitive("bool"));
    state.declared_types.insert("void".to_string(), Struct::new_primitive("void"));
    Ok(())
}

fn compile_attributes(state :&mut CompilerState) -> Result<(), String>{
    for function in &state.declared_functions {
        if function.1.attribs.iter().any(|attr| attr.name_equals("DllImport")) {
            let func_return_type_string = state.get_llvm_representation_from_parser_type(&function.1.return_type)?;
            
            let args_string = function.1.args.iter().map(|x| state.get_llvm_representation_from_parser_type(&x.1))
                .collect::<Result<Vec<_>,String>>()?.join(",");
            
            state.declared_functions[function.0].set_as_imported();
            state.output.push_str_header(&format!("declare dllimport {} @{}({})\n", func_return_type_string, function.1.name, args_string));
            continue;
        }
    }
    Ok(())
}
fn compile_structs(main_state: &mut CompilerState) -> Result<(), String> {
    for (_name, act_struct) in main_state.declared_types.iter().filter(|(_k, v)| !v.is_primitive()) {
        let (_, fields, _methods) = &main_state.structures_of_types[_name];
        main_state.current_function_path = act_struct.path.to_string();
        let field_types = fields.iter().map(|x| main_state.get_llvm_representation_from_parser_type(&x.1))
            .collect::<Result<Vec<_>,String>>()?.join(", ");
        
        let llvm_struct_name = act_struct.llvm_representation();
        main_state.output.push_str_header(&format!("{} = type {{{}}}\n", llvm_struct_name, field_types));
    }
    Ok(())
}
fn compile_functions(state :&mut CompilerState) -> Result<(), String>{
    let funcs_to_compile = state.declared_functions.iter().filter(|x| !x.1.is_imported()).map(|x| x.1.clone()).collect::<Vec<_>>();
    for function in funcs_to_compile {
        state.current_function_path = function.path.to_string();
        let function_return_type = state.get_llvm_representation_from_parser_type(&function.return_type)?;
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
            let type_string = state.get_llvm_representation_from_parser_type(arg_type)?;
            let formatted_arg = format!("{} %{}", type_string, arg_name);
            arg_parts.push(formatted_arg);
        }
        let args_string = arg_parts.join(", ");

        state.output.push_str(&format!("\ndefine {} @{}({}){{\n", function_return_type.to_string(), effective_function_name, args_string));
        state.temp_value_counter = Cell::new(0);
        let original_scope = state.current_scope.clone_and_enter();
        for arg in &function.args {
            state.current_scope.add_variable(arg.0.clone(), Variable::new_argument(CompilerType { parser_type: arg.1.clone() }));
        }
        state.current_function_name = function.name.clone();
        state.current_function_path = function.path.clone();
        for x in &function.body.clone() {
            compile_statement(x, state)
            .map_err(|x| format!("while compiling function \"{}\"\n\r{}",state.current_function_name,x))?;
        }
        state.current_scope.swap_and_exit(original_scope);
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
            let comp_type_llvm_repr = state.get_llvm_representation_from_parser_type(var_type)?;
            state.output.push_str(&format!("    %{} = alloca {}\n", name, comp_type_llvm_repr));
            state.current_scope.add_variable(name.clone(), Variable::new(CompilerType { parser_type: var_type.clone() }));
            if let Some(expr) = expr {
                compile_expression(&Expr::Assign(Box::new(Expr::Name(name.clone())), Box::new(expr.clone())), Expected::Type(var_type), state)
                    .map_err(|x| format!("while compiling assign expression {:?}:\n{}", expr, x))?;
                
            }
        }
        Stmt::Expr(expression) => { compile_expression(expression, Expected::NoReturn, state).map_err(|x| format!("while compiling expression {:?}\n\r{}",expression,x))?; }
        Stmt::Return(expression) =>{
            if let Some(expression) = expression {
                let expected_type = state.get_current_function()?.return_type.clone();
                let function_actual_return_type = state.get_llvm_representation_from_parser_type(&expected_type)?;
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
                let original_scope = state.current_scope.clone_and_enter();
                for x in then_stmt {
                    compile_statement(x, state)
                        .map_err(|x| format!("while compiling body of if statement {:?}:\n{}",condition, x))?;
                }
                state.current_scope.swap_and_exit(original_scope);
                state.output.push_str(&format!("    br label %end_if{}\n", logic_u));
                state.output.push_str(&format!("else{}:\n", logic_u));
                let original_scope = state.current_scope.clone_and_enter();
                for stmt in else_stmt {
                    compile_statement(&stmt, state)
                        .map_err(|x| format!("while compiling else body of if statement {:?}:\n{}",condition, x))?;
                }
                state.current_scope.swap_and_exit(original_scope);
                state.output.push_str(&format!("    br label %end_if{}\n", logic_u));
                state.output.push_str(&format!("end_if{}:\n", logic_u));
            }else {
                state.output.push_str(&format!("    br {}, label %then{}, label %end_if{}\n", cond_val.to_repr_with_type(state)?, logic_u, logic_u));
                state.output.push_str(&format!("then{}:\n", logic_u)); 
                let original_scope = state.current_scope.clone_and_enter();
                for x in then_stmt {
                    compile_statement(x, state)
                        .map_err(|x| format!("while compiling body of if statement {:?}:\n{}",condition, x))?;
                }
                state.current_scope.swap_and_exit(original_scope);
                state.output.push_str(&format!("    br label %end_if{}\n", logic_u));
                state.output.push_str(&format!("end_if{}:\n", logic_u));
            }
        }
        Stmt::Loop(statement) =>{
            let lc = state.aquire_unique_logic_counter();
            
            state.output.push_str(&format!("    br label %loop_body{}\n", lc));
            state.output.push_str(&format!("loop_body{}:\n", lc));
            let original_scope = state.current_scope.clone_and_enter();
            state.current_logic_counter_function = lc as u32;
            for x in statement {
                compile_statement(x, state)?;
            }
            state.current_scope.swap_and_exit(original_scope);
            state.current_logic_counter_function = u32::MAX;
            state.output.push_str(&format!("    br label %loop_body{}\n", lc));
            state.output.push_str(&format!("loop_body{}_exit:\n", lc));
        }
        Stmt::Hint(_,_) | Stmt::Function(_, _, _, _) | Stmt::Struct(_, _)  => return Err(format!("Statement {:?} was not expected in current context", statement)),
        _ => panic!("{:?}", statement),
    }
    Ok(())
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
    
    declared_functions: OrderedHashMap<String, Function>,
    declared_types: OrderedHashMap<String, Struct>,

    structures_of_types: OrderedHashMap<String, (String, Vec<(String,ParserType)>, Vec<(String,(ParserType, Vec<ParserType>))>)>,
    
    current_function_path: String,
    current_function_name: String,

    current_scope: Scope,

    temp_value_counter: Cell<u32>,
    logic_counter: Cell<u32>,
    const_vectors_counter: Cell<u32>,

    current_logic_counter_function: u32,
}

impl CompilerState {
    pub fn get_function_from_path(&self, path: &str, func_name: &str) -> Result<&Function, String>{
        let path = if path.is_empty() { func_name } else { &format!("{}.{}",path, func_name)};
        let func = self.declared_functions.get(path).ok_or(format!("Current function was not found inside current namespace path"))?;
        return Ok(func);
    }
    pub fn get_current_function(&self) -> Result<&Function, String>{
        let path = if self.current_function_path.is_empty() { &self.current_function_name } else { &format!("{}.{}",self.current_function_path, self.current_function_name)};
        let func = self.declared_functions.get(path).ok_or(format!("Current function was not found inside current namespace path"))?;
        return Ok(func);
    } 
    pub fn get_current_path(&self) -> &str{
        return &self.current_function_path;
    } 
    pub fn set_current_path(&mut self, path: &str) {
        self.current_function_path = path.to_string();
    }
    pub fn get_variable(&self, name: &str) -> Result<&Variable,String>{
        return self.current_scope.get_variable(name).map_err(|x| format!("Inside function'{}'\n{}", self.current_function_name, x));
    }

    pub fn get_llvm_representation_from_parser_type(&self, parser_type: &ParserType) -> Result<String, String>{
        let true_path = parser_type.get_absolute_path_or(&self.current_function_path);
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
                if self.declared_types.contains_key(type_name) {
                    match type_name.as_str() {
                        "void" => return Ok(format!("void")),
                        "bool" => return Ok(format!("i1")),
                        "i8" | "u8" => return Ok(format!("i8")),
                        "i16" | "u16" => return Ok(format!("i16")),
                        "i32" | "u32" => return Ok(format!("i32")),
                        "i64" | "u64" => return Ok(format!("i64")),
                        "f32" => return Ok(format!("f32")),
                        "f64" => return Ok(format!("f64")),
                        n => return Ok(format!("%struct.{}", n))
                    }
                }
                if self.declared_types.contains_key(&true_path) {
                    return Ok(format!("%struct.{}", true_path))
                }
                Err(format!("Implementation of \"{:?}\" was not found in current context '{}/{}', lfpt", parser_type, self.current_function_path, self.current_function_name))
            }
            ParserType::Pointer(x) =>{
                let mut inside_value = self.get_llvm_representation_from_parser_type(x)?;
                inside_value.push('*');
                return Ok(inside_value);
            }
            ParserType::NamespaceLink(x, y) => {
                return Ok(format!("%struct.{}.{}", x, y.to_string()))
            }
        }
    }
    pub fn get_struct_representaition_from_parser_type(&self, parser_type: &ParserType) -> Result<&(String, Vec<(String,ParserType)>, Vec<(String,(ParserType, Vec<ParserType>))>),String>{
        match parser_type {
            ParserType::Function(_, _) => Err(format!("Functions do not posses ablility to be structures")),
            ParserType::Pointer(_) => Err(format!("Pointers are not structures")),
            ParserType::Named(struct_name) =>{
                if self.structures_of_types.contains_key(struct_name) {
                    return Ok(&self.structures_of_types[struct_name]);
                }
                let true_path = parser_type.get_absolute_path_or(&self.current_function_path);
                if self.structures_of_types.contains_key(&true_path) {
                    return Ok(&self.structures_of_types[&true_path]);
                }
                Err(format!("Structural implementation of {} was not found in current context", struct_name))
            }
            ParserType::NamespaceLink(_, _) => {
                let abs_path = parser_type.get_absolute_path_or(&self.current_function_path);
                if self.structures_of_types.contains_key(&abs_path) {
                    return Ok(&self.structures_of_types[&abs_path]);
                }
                Err(format!("Structural implementation of {} was not found in current context", abs_path))
            }
        }
    }
    pub fn get_sizeof(&self, parser_type: &ParserType) -> Result<u32, String> {
        match parser_type {
            ParserType::Pointer(_) => return Ok(8),
            ParserType::Function(_, _) => unreachable!(),
            ParserType::Named(type_name) =>{
                if self.declared_types.contains_key(type_name) {
                    match type_name.as_str() {
                        "void" => unreachable!(),
                        "bool" => return Ok(1),
                        "i8" | "u8" => return Ok(1),
                        "i16" | "u16" => return Ok(2),
                        "i32" | "u32" => return Ok(4),
                        "i64" | "u64" => return Ok(8),
                        "f32" => return Ok(4),
                        "f64" => return Ok(8),
                        _ => {
                            let x = self.get_struct_representaition_from_parser_type(parser_type)?;
                            return Ok(x.1.iter().map(|x| self.get_sizeof(&x.1)).collect::<Result<Vec<_>,String>>()?.iter().sum());
                        }
                    }
                }
                let absolute_path = parser_type.get_absolute_path_or(&self.current_function_path);
                if self.declared_types.contains_key(&absolute_path) {
                    let x = self.get_struct_representaition_from_parser_type(parser_type)?;
                    return Ok(x.1.iter().map(|x| self.get_sizeof(&x.1)).collect::<Result<Vec<_>,String>>()?.iter().sum());
                }
                return Err(format!("Type '{}' was not found in current context, szof", type_name));
            }
            ParserType::NamespaceLink(_, _) => {
                let absolute_path = parser_type.get_absolute_path_or(&self.current_function_path);
                if self.declared_types.contains_key(&absolute_path) {
                    let x = self.get_struct_representaition_from_parser_type(parser_type)?;
                    return Ok(x.1.iter().map(|x| self.get_sizeof(&x.1)).collect::<Result<Vec<_>,String>>()?.iter().sum());
                }
                return Err(format!("Type '{}' was not found in current context, szof", absolute_path));
            }
        }
    }
    
    pub fn aquire_unique_temp_value_counter(&self) -> u32{
        self.temp_value_counter.replace(self.temp_value_counter.get() + 1)
    }
    pub fn aquire_unique_logic_counter(&mut self) -> u32{
        self.logic_counter.replace(self.logic_counter.get() + 1)
    }
    pub fn aquire_unique_const_vector_counter(&mut self) -> u32{
        self.const_vectors_counter.replace(self.const_vectors_counter.get() + 1)
    }

}