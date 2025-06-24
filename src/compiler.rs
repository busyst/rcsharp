use std::{collections::{HashMap, HashSet}, fs::File, io::Write};

use crate::{expression_compiler::{compile_expression_rec, var_cast, TypedValue}, expression_parser::{Expr, UnaryOp}, parser::{ParserType, Stmt}};
macro_rules! extract {
    ($e:expr, $p:path) => {
        match $e {
            $p(value) => Some(value),
            _ => None,
        }
    };
}
// This function handles expressions that can appear as statements, like assignments.
pub fn compile_statement_expression(t: &Expr, state: &mut CompilerState) -> Result<TypedValue, String> {
    match t {
        Expr::Assign(left, right) => {
            // Compile the right-hand side first.
            // We don't know the exact type of the LHS yet, so we compile RHS without a hint.
            let rhs_val = compile_expression_rec(right, None, state)?;

            // Now, handle the left-hand side. It must be a valid "l-value".
            match &**left {
                Expr::Name(name) => {
                    // Case 1: Simple variable assignment: `x = ...`
                    let var_info = state.find_variable(name)?.clone();
                    let final_rhs_val = var_cast(rhs_val, &var_info.ty, state)?;
                    let var_type_str = CompilerState::get_type_string(&var_info.ty);
                    state.push_str(&format!("store {} %tmp{}, {}* %{}\n", var_type_str, final_rhs_val.index, var_type_str, var_info.llvm_name));
                    Ok(final_rhs_val)
                }
                Expr::UnaryOp(UnaryOp::Deref, ptr_expr) => {
                    // Case 2: Pointer dereference assignment: `*p = ...`
                    let ptr_val = compile_expression_rec(ptr_expr, None, state)?;
                    let value_type = if let ParserType::Ref(inner) = &ptr_val.ty {
                        *inner.clone()
                    } else {
                        return Err(format!("Cannot assign to a dereferenced non-pointer of type {:?}", ptr_val.ty));
                    };

                    let final_rhs_val = var_cast(rhs_val, &value_type, state)?;
                    let value_type_str = CompilerState::get_type_string(&value_type);
                    let ptr_type_str = CompilerState::get_type_string(&ptr_val.ty);
                    state.push_str(&format!("store {} %tmp{}, {} %tmp{}\n", value_type_str, final_rhs_val.index, ptr_type_str, ptr_val.index));
                    Ok(final_rhs_val)
                }
                Expr::Index(base_expr, index_expr) => {
                    // Case 3: Pointer/Array index assignment: `ptr[idx] = ...`
                    let base_ptr_val = compile_expression_rec(base_expr, None, state)?;
                    let element_type = if let ParserType::Ref(inner) = &base_ptr_val.ty {
                        *inner.clone()
                    } else {
                        return Err(format!("Cannot index a non-pointer type: {:?}", base_ptr_val.ty));
                    };

                    let index_val = compile_expression_rec(index_expr, Some(&ParserType::Named("i64".into())), state)?;

                    // Generate getelementptr to find the address of the element
                    let mi = state.get_temp_variable_index();
                    let element_type_str = CompilerState::get_type_string(&element_type);
                    let ptr_type_str = CompilerState::get_type_string(&base_ptr_val.ty);
                    let index_type_str = CompilerState::get_type_string(&index_val.ty);

                    state.push_str(&format!(
                        "%tmp{} = getelementptr inbounds {}, {} %tmp{}, {} %tmp{}\n",
                        mi, element_type_str, ptr_type_str, base_ptr_val.index, index_type_str, index_val.index
                    ));
                    
                    let element_ptr = TypedValue { index: mi, ty: base_ptr_val.ty.clone() };

                    // Cast RHS to the element's type and store it at the calculated address
                    let final_rhs_val = var_cast(rhs_val, &element_type, state)?;
                    state.push_str(&format!("store {} %tmp{}, {} %tmp{}\n", element_type_str, final_rhs_val.index, ptr_type_str, element_ptr.index));
                    Ok(final_rhs_val)
                }
                _ => Err(format!("Assignment target must be a variable, dereferenced pointer, or array index. Found {:?}", left)),
            }
        }
        // For other expressions, just compile them recursively.
        _ => compile_expression_rec(t, None, state),
    }
}
pub fn compile_body(s: &Stmt, state: &mut CompilerState) -> Result<(), String> {
    // This function is now fully recursive and handles any statement type directly.
    match s {
        Stmt::Block(stmts) => {
            // If the statement is a block, compile each statement inside it recursively.
            for stmt in stmts {
                compile_body(stmt, state)?;
            }
        }
        Stmt::Return(maybe_expr) => {
            let (func_return_type, _) = state.current_function.as_ref()
                .ok_or("Cannot use 'return' outside of a function.")?
                .clone();

            if let Some(expr) = maybe_expr {
                 if func_return_type == ParserType::Named("void".to_string()) {
                    return Err("Cannot return a value from a void function.".to_string());
                }
                let ret_val = compile_statement_expression(expr, state)?;
                let final_ret_val = if ret_val.ty != func_return_type {
                    var_cast(ret_val, &func_return_type, state)?
                } else {
                    ret_val
                };
                let ret_type_str = CompilerState::get_type_string(&func_return_type);
                state.push_str(&format!("ret {} %tmp{}\n", ret_type_str, final_ret_val.index));
            } else {
                if func_return_type != ParserType::Named("void".to_string()) {
                    return Err(format!("Function must return a value of type {:?}, but returned void.", func_return_type));
                }
                state.push_str("ret void\n");
            }
        }
        Stmt::Let(name, typ) => {
            state.insert_variable(name.clone(), typ.clone(), name.clone());
            let type_str = CompilerState::get_type_string(typ);
            state.push_str(&format!("%{} = alloca {}\n", name, type_str));
        }
        Stmt::Expr(expr) => {
            // The result of a standalone expression is discarded.
            let _ = compile_statement_expression(expr, state)?;
        }
        Stmt::Break => {
            let break_label = state.loop_context.last()
                .ok_or("'break' used outside of a loop.")?
                .1.clone();
            state.push_str(&format!("br label %{}\n", break_label));
        }
        Stmt::Continue => {
            let continue_label = state.loop_context.last()
                .ok_or("'continue' used outside of a loop.")?
                .0.clone();
            state.push_str(&format!("br label %{}\n", continue_label));
        }
        Stmt::If(condition, then_block, else_block) => {
            let mut cond_val = compile_expression_rec(condition, None, state)?;
            
            if cond_val.ty != ParserType::Named("i1".to_string()) {
                let cond_type_str = CompilerState::get_type_string(&cond_val.ty);
                let new_mi = state.get_temp_variable_index();
                state.push_str(&format!("%tmp{} = icmp ne {} %tmp{}, 0\n", new_mi, cond_type_str, cond_val.index));
                cond_val = TypedValue { index: new_mi, ty: ParserType::Named("i1".to_string()) };
            }

            let then_label = state.get_unique_label("if.then");
            let else_label = state.get_unique_label("if.else");
            let end_label = state.get_unique_label("if.end");

            let false_target = if else_block.is_some() { &else_label } else { &end_label };
            
            state.push_str(&format!("br i1 %tmp{}, label %{}, label %{}\n", cond_val.index, then_label, false_target));

            // Compile the 'then' block.
            state.push_str(&format!("{}:\n", then_label));
            compile_body(then_block, state)?;
            state.push_str(&format!("br label %{}\n", end_label));

            // Compile 'else' block if it exists.
            if let Some(else_b) = else_block {
                state.push_str(&format!("{}:\n", else_label));
                // This recursive call now works correctly for both `else {..}` and `else if ..`
                compile_body(else_b, state)?;
                state.push_str(&format!("br label %{}\n", end_label));
            }

            state.push_str(&format!("{}:\n", end_label));
        }
        Stmt::Loop(body) => {
            let loop_header_label = state.get_unique_label("loop.header");
            let loop_body_label = state.get_unique_label("loop.body");
            let loop_end_label = state.get_unique_label("loop.end");

            state.loop_context.push((loop_header_label.clone(), loop_end_label.clone()));

            state.push_str(&format!("br label %{}\n", loop_header_label));
            
            state.push_str(&format!("{}:\n", loop_header_label));
            state.push_str(&format!("br label %{}\n", loop_body_label));
            
            state.push_str(&format!("{}:\n", loop_body_label));
            compile_body(body, state)?;
            state.push_str(&format!("br label %{}\n", loop_header_label));

            state.push_str(&format!("{}:\n", loop_end_label));

            state.loop_context.pop();
        }
        // These are handled before function compilation starts.
        // We add them here for completeness, though they shouldn't be reached inside a function body.
        Stmt::Hint(_, _) => return Err("Hints are not allowed inside function bodies.".to_string()),
        Stmt::Function(_, _, _, _) => return Err("Nested functions are not supported.".to_string()),
    }
    Ok(())
}
pub fn compile_function(
    name: &String,
    arguments: &[(String, ParserType)],
    return_type: &ParserType,
    body: &Stmt,
    state: &mut CompilerState,
) -> Result<(), String> {
    let type_str = CompilerState::get_type_string(return_type);
    
    // argument list for the function signature
    let args_str: String = arguments
        .iter()
        .map(|(arg_name, ty)| {
            format!("{} %{}", CompilerState::get_type_string(ty), arg_name)
        })
        .collect::<Vec<String>>()
        .join(", ");
    
    state.push_str(&format!("define {} @{}({}) {{\n", type_str, name, args_str));
    state.push_str("entry:\n");

    for (arg_name, arg_type) in arguments {
        let arg_type_str = CompilerState::get_type_string(arg_type);
    
        let ptr_name = format!("{}.addr", arg_name);
        state.push_str(&format!("%{} = alloca {}, align 4\n", ptr_name, arg_type_str));
        state.push_str(&format!("store {} %{}, {}* %{}\n", arg_type_str, arg_name, arg_type_str, ptr_name));

        state.insert_variable(arg_name.clone(), arg_type.clone(), ptr_name);
    }

    compile_body(body, state)?;
    
    // Ensure termination
    if !state.direct_output.trim_end().ends_with("}") {
        if return_type == &ParserType::Named("void".to_string()) {
            state.push_str("ret void\n");
        } else {
            state.push_str("unreachable\n");
        }
    }
    state.push_str("}\n");
    Ok(())
}
pub fn rcsharp_compile_to_file(x: &[Stmt]) -> Result<(), String> {
    let direct_output = rcsharp_compile(x)?;
    let mut file = File::create("output.ll").map_err(|e| e.to_string())?;
    file.write_all(direct_output.as_bytes()).map_err(|e| e.to_string())?;

    Ok(())
}

pub fn rcsharp_compile(x: &[Stmt]) -> Result<String, String> {
    let mut aux_state = CompilerState::new();
    let mut main_index = None;
    let mut skip_next_function = false;
    let mut funcs = vec![];
    for i in 0..x.len() {
        let stmt = &x[i];
        match stmt {
            Stmt::Function(name, args,return_type , _) => {
                if skip_next_function {
                    skip_next_function = false;
                    continue;
                }
                aux_state.local_functions.insert(name.clone(), (return_type.clone(),args.iter().map(|x| x.1.clone()).collect()));
                if name == "main" && args.len() == 0 {
                    main_index = Some(i);
                }else {
                    funcs.push(i);
                }
                println!("Function {:?} Argumets: {:?} Return Type: {:?}", name, args, return_type);
            }
            Stmt::Hint(name, args) =>{
                match name.as_str() {
                    "DllImport" =>{
                        #[allow(unused)]
                        let path = extract!(&args[0], Expr::StringConst).unwrap();
                        let next_function = &x[i..].iter().find(|x| matches!(x, Stmt::Function(_,_,_,_))).expect("Function affected by this hint was not found");
                        if let Stmt::Function(name, args, return_type, _) = next_function {
                            aux_state.local_functions.insert(name.clone(), (return_type.clone(),args.iter().map(|x| x.1.clone()).collect()));
                            aux_state.push_str(&format!("declare dllimport "));
                            // Push return type and function name
                            aux_state.push_type(return_type);
                            aux_state.push_str(&format!(" @{}(", name));
                            for i in 0..args.len() {
                                let arg = &args[i];
                                aux_state.push_type(&arg.1);
                                if i != args.len() - 1 {
                                    aux_state.push_str(",");
                                }
                            }
                            aux_state.push_str(")\n");
                            aux_state.extern_functions.insert(name.clone());
                            skip_next_function = true;
                        }
                    }
                    _ => todo!()
                }
            }
            _ => {}
        }
    }
    if main_index.is_none() {
        return Err(format!("Main function was not found"));
    }
    let main_index = main_index.unwrap();
    let main = &x[main_index];
    let mut main_state = CompilerState::new();
    main_state.extern_functions = aux_state.extern_functions;
    main_state.local_functions = aux_state.local_functions;
    main_state.local_variables = aux_state.local_variables;
    main_state.push_str(&aux_state.direct_output);
    match main {
        Stmt::Function(n, a, rt, bdy) => {
            main_state.current_function = Some((rt.clone(),a.clone()));
            compile_function(n, &a,rt,&bdy, &mut main_state)?;
        }
        _ => panic!()
    }
    for idx in &funcs {
        match &x[*idx] {
            Stmt::Function(n, a, rt, bdy) => {
                let mut current_state = main_state.clone(); 
                current_state.local_variables.clear(); // Clear for each function!
                current_state.current_function = Some((rt.clone(),a.clone()));
                current_state.temp_variable_index = 0;
                current_state.direct_output.clear();
                
                compile_function(n, a, rt, bdy, &mut current_state)?;
                main_state.const_strings = current_state.const_strings;
                main_state.direct_output.push_str(&current_state.direct_output);
            }
            _ => panic!()
        }
    }
    // Add string constants to the end of the file.
    let const_strings = main_state.const_strings.clone();
    for (i, s) in const_strings.iter().enumerate() {
        // Calculate length from the raw string bytes + null terminator.
        let len_with_null = s.as_bytes().len() + 1;
        
        // Escape special characters only for printing inside the c"..." literal.
        let c_str = s.replace('\\', "\\5C")
                       .replace('"', "\\22")
                       .replace('\n', "\\0A")
                       .replace('\r', "\\0D");
                       
        main_state.push_str(&format!(
            "@.str{} = private unnamed_addr constant [{} x i8] c\"{}\\00\", align 1\n",
            i, len_with_null, c_str
        ));
    }

    Ok(main_state.direct_output)
}
#[derive(Debug, Clone)]
pub struct VariableInfo {
    pub ty: ParserType,
    pub llvm_name: String, // The name of the LLVM pointer (%var.addr)
}

#[derive(Debug, Clone)]
pub struct CompilerState {
    const_strings: Vec<String>,
    local_functions: HashMap<String, (ParserType, Vec<ParserType>)>,
    local_variables: HashMap<String, VariableInfo>,
    extern_functions: HashSet<String>,
    current_function: Option<(ParserType, Vec<(String, ParserType)>)>,
    temp_variable_index: usize,
    label_index: usize,
    loop_context: Vec<(String, String)>,
    direct_output: String,
}
impl CompilerState {
    pub fn new() -> Self {
        Self {
            const_strings: Vec::new(),
            local_functions: HashMap::new(),
            local_variables: HashMap::new(),
            extern_functions: HashSet::new(),
            current_function: None,
            temp_variable_index: 0,
            direct_output: String::new(),
            label_index: 0,
            loop_context: vec![]
        }
    }
    
    pub fn get_temp_variable_index(&mut self) -> usize {
        let index = self.temp_variable_index;
        self.temp_variable_index += 1;
        index
    }
    pub fn get_unique_label(&mut self, name: &  str) -> String {
        let index = self.label_index;
        self.label_index += 1;
        format!("{}.{}", name, index)
    }
    pub fn is_extern_function(&self, name: &String) -> bool {
        self.extern_functions.contains(name)
    }
    pub fn add_constant_string(&mut self, s: String) -> (usize, usize) {
        // The length is ALWAYS the raw byte length + 1 for the null terminator.
        let len_with_null = s.as_bytes().len() + 1;

        // Check if the raw string already exists to avoid duplicates.
        if let Some(pos) = self.const_strings.iter().position(|cs| *cs == s) {
            // If it exists, return its index and the correctly calculated length.
            return (pos, len_with_null);
        }

        // If new, store the raw string and return its new index and length.
        self.const_strings.push(s);
        (self.const_strings.len() - 1, len_with_null)
    }

    pub fn push_str(&mut self, s: &str) {
        self.direct_output.push_str(s);
    }
    
    pub fn push_type(&mut self, _type: &ParserType) {
        self.push_str(&Self::get_type_string(_type));
    }

    pub fn get_type_string(_type: &ParserType) -> String {
        match _type {
            ParserType::Named(x) => x.clone(),
            ParserType::Ref(inner) => format!("{}*", Self::get_type_string(inner)),
        }
    }
    
    pub fn find_variable(&self, name: &String) -> Result<&VariableInfo, String> {
        self.local_variables
            .get(name)
            .ok_or_else(|| format!("Variable \"{}\" was not found in the current scope.", name))
    }
    
    pub fn find_function(&self, name: &String) -> Result<&(ParserType, Vec<ParserType>), String> {
        self.local_functions
            .get(name)
            .ok_or_else(|| format!("Function \"{}\" was not found.", name))
    }
    
    pub fn insert_variable(&mut self, source_name: String, ty: ParserType, llvm_name: String) {
        self.local_variables.insert(source_name, VariableInfo { ty, llvm_name });
    }
}