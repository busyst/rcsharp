use std::{collections::HashMap, fs::File, io::{Seek, SeekFrom, Write}};

use lexer::lex;
use parser::parse;
use tokens::Tokens;

mod lexer;
mod tokens;
mod parser;

fn main() {
    let x = lex("main.rcs").unwrap_or_else(|e| {
        eprintln!("Error during lexing: {}", e);
        std::process::exit(1);
    });
    File::options().read(false).write(true).create(true).open("lexer_output.txt").unwrap().write(format!("{:?}",x).as_bytes()).unwrap();
    let y = parse(&x);
    File::options().read(false).write(true).create(true).open("parser_output.txt").unwrap().write(format!("{:?}",y).as_bytes()).unwrap();

    clear();
    compile(&y);
}
#[derive(Debug, Clone, PartialEq)]
pub enum RCSType {
    Void,
    Type(Box<String>),
    Array(Box<RCSType>),
    Tuple(Vec<RCSType>),
}

#[derive(Debug, Clone, PartialEq)]
enum Instruction {
    FunctionCreation { name: String, return_type: RCSType, arguments: Vec<(String,RCSType)>, body: Vec<Instruction>},
    FunctionCall { name: String, arguments: Vec<(Tokens, (u32, u32))>},
    MacroCall { name: String, arguments: Vec<(Tokens, (u32, u32))>},
    //FunctionDeclaration { name: String, arguments: Vec<(Tokens,(u32,u32))>},
    IfElse { condition: Vec<(Tokens, (u32, u32))>, if_body: Vec<Instruction>, else_body: Option<Vec<Instruction>> },
    Return { expression: Vec<(Tokens, (u32, u32))> },

    Operation { operation: Vec<(Tokens,(u32,u32))> },
    Loop { body: Vec<Instruction> },
    Break,
    Continue,

    VariableDeclaration { name: String, _type: RCSType, expression: Vec<(Tokens,(u32,u32))> },
}


fn get_type(type_tokens: &[(Tokens,(u32,u32))]) -> RCSType{
    // Helper function to parse more complex inner types
    fn parse_complex_type(tokens: &[(Tokens, (u32, u32))]) -> RCSType {
        // Simple type case
        if tokens.len() == 1 {
            if let Tokens::Name { name_string } = &tokens[0].0 {
                return RCSType::Type(Box::new(*name_string.clone()));
            }
        }

        // Handle array type
        if let Some((Tokens::LSQBrace, _)) = tokens.first() {
            let inner_tokens = &tokens[1..tokens.len()-1];
            return RCSType::Array(Box::new(parse_complex_type(inner_tokens)));
        }

        // Handle tuple type
        if let Some((Tokens::LParen, _)) = tokens.first() {
            let inner_tokens = &tokens[1..tokens.len()-1];
            let mut tuple_types = Vec::new();
            let mut current_type = Vec::new();

            for token in inner_tokens {
                match token.0 {
                    Tokens::Comma => {
                        // Complete current type and add to tuple types
                        if !current_type.is_empty() {
                            tuple_types.push(parse_complex_type(&current_type));
                            current_type.clear();
                        }
                    },
                    _ => current_type.push(token.clone())
                }
            }

            // Add last type if exists
            if !current_type.is_empty() {
                tuple_types.push(parse_complex_type(&current_type));
            }

            return RCSType::Tuple(tuple_types);
        }

        // Nested complex types
        if tokens.len() > 1 {
            // Check for nested array or tuple
            match &tokens[0].0 {
                Tokens::Name { name_string } if **name_string == "array" => {
                    // Handle array type declaration
                    let inner_tokens = &tokens[1..];
                    return RCSType::Array(Box::new(parse_complex_type(inner_tokens)));
                },
                Tokens::Name { name_string } if **name_string == "tuple" => {
                    // Handle tuple type declaration
                    let inner_tokens = &tokens[1..];
                    let mut tuple_types = Vec::new();
                    let mut current_type = Vec::new();

                    for token in inner_tokens {
                        match token.0 {
                            Tokens::Comma => {
                                if !current_type.is_empty() {
                                    tuple_types.push(parse_complex_type(&current_type));
                                    current_type.clear();
                                }
                            },
                            _ => current_type.push(token.clone())
                        }
                    }

                    // Add last type if exists
                    if !current_type.is_empty() {
                        tuple_types.push(parse_complex_type(&current_type));
                    }

                    return RCSType::Tuple(tuple_types);
                },
                _ => {}
            }
        }

        // Fallback for unrecognized type patterns
        panic!("Complex type parsing failed: {:?}", tokens);
    }

    // Helper function to parse tuple types
    fn parse_tuple_types(tokens: &[(Tokens, (u32, u32))]) -> Vec<RCSType> {
        let mut types = Vec::new();
        let mut current_type = Vec::new();

        for token in tokens {
            match token.0 {
                Tokens::Comma => {
                    // Complete current type and add to types
                    if !current_type.is_empty() {
                        types.push(parse_complex_type(&current_type));
                        current_type.clear();
                    }
                },
                _ => current_type.push(token.clone())
            }
        }

        // Add last type if exists
        if !current_type.is_empty() {
            types.push(parse_complex_type(&current_type));
        }

        types
    }


    let _type: RCSType;
    if type_tokens.first().is_none(){
        panic!("Type should be declarated!");
    }
    else{
        let x = type_tokens.first().unwrap();
        if type_tokens.len() == 1{
           if let Tokens::Name { name_string } = &x.0{
            _type = RCSType::Type(Box::new(*name_string.clone()));
           }else {
            panic!("Type was not specified! Fix that! Around {:?}",type_tokens[0].1);
           }
        }else if let Tokens::LSQBrace = &x.0  {
            let inner_tokens = &type_tokens[1..type_tokens.len()-1];
            if inner_tokens.is_empty() {
                panic!("Empty array type");
            }
            let inner_type = if inner_tokens.len() == 1 {
                if let Tokens::Name { name_string } = &inner_tokens[0].0 {
                    RCSType::Type(Box::new(*name_string.clone()))
                } else {
                    panic!("Invalid array inner type")
                }
            } else {
                // More complex inner type (like tuple)
                parse_complex_type(inner_tokens)
            };
            _type = RCSType::Array(Box::new(inner_type));
        }else if let Tokens::LParen = &x.0  {
            let inner_tokens = &type_tokens[1..type_tokens.len()-1];
            if inner_tokens.is_empty() {
                panic!("Empty tuple type");
            }
            // Parse tuple inner types
            let tuple_types = parse_tuple_types(inner_tokens);
            _type = RCSType::Tuple(tuple_types);
        }
        else {
            panic!("");
        }
        
    }
    _type
}





fn clear(){
    let f = File::options().read(true).write(true).create(true).open("a.asm").unwrap();
    f.set_len(0).unwrap();
}
fn write(string:&str){
    let mut f = File::options().read(true).write(true).open("a.asm").unwrap();
    f.seek(SeekFrom::End(0)).unwrap();
    f.write(string.as_bytes()).unwrap();
}
#[derive(Clone)]
struct CompilerContext{
    current_function_name: String,
    local_variables: HashMap<String, (RCSType, usize)>,
    loop_index: usize,
    logic_index: usize,
}
fn intenal_compile(body:&[Instruction], current_context: &mut CompilerContext){
    // Generate the loop label and increment the loop index
    let mut loop_label = current_context.loop_index.clone();
    for x in body {
        println!("--------");
        println!("{:?}",x);
        match x {
            Instruction::VariableDeclaration { name, _type, expression } =>{
                current_context.local_variables.insert(name.to_string(), (_type.clone(),current_context.local_variables.values().last().and_then(|x| Some(x.1)).unwrap_or(0) + 2));
                let this_var = &current_context.local_variables[name];
                expression_solver(&expression,&current_context.local_variables);
                write(&format!("   mov WORD [bp - {}], ax ; VAR {}\n",this_var.1,name));

            }
            Instruction::Loop { body } => {
                loop_label = current_context.loop_index.clone();
                // Generate the loop label and increment the loop index
                write(&format!("_Loop{}:\n", loop_label));
                current_context.loop_index += 1;

                // Compile the body of the loop
                intenal_compile(body, current_context);

                // After the loop body, generate jump and exit labels
                write(&format!("   jmp _Loop{}\n", loop_label));
                write(&format!("_Loop{}_EXIT:\n", loop_label));
            }
            Instruction::Return { expression: value } =>{
                if value.len() != 0{
                    expression_solver(value, &current_context.local_variables);
                }else {
                    write("   xor ax,ax\n");
                }

                write(&format!("   jmp _exit_{}\n",current_context.current_function_name));
            }
            Instruction::Break => {
                // Generate jump to exit the current loop
                write(&format!("   jmp _Loop{}_EXIT\n", loop_label - 1));
            }
            Instruction::Continue => {
                // Generate jump to continue the current loop
                write(&format!("   jmp _Loop{}\n", loop_label - 1));
            }
            Instruction::FunctionCall { name, arguments } => {
                if arguments.len() !=0{
                    let mut args_vectors = vec![];
                    let mut last_arg_comma = 0;
                    for i in 0..arguments.len() {
                        if arguments[i].0 == Tokens::Comma{
                            args_vectors.push(arguments[last_arg_comma..i].to_vec());
                            last_arg_comma = i + 1;
                        }
                    }
                    if last_arg_comma != arguments.len(){
                        args_vectors.push(arguments[last_arg_comma..arguments.len()].to_vec());
                    }
                    if args_vectors.len() > 0{
                        if args_vectors.len() != 1{
                            todo!()
                        }
                        expression_solver(&args_vectors[0], &current_context.local_variables);
                        write(&format!("   mov dx, ax ; load arg 0 to call {} \n",name));
                    }
                }
                write(&format!("   call {} \n",name));
            }
            Instruction::Operation { operation } =>{
                if operation.len() > 2{
                    if let (Tokens::Name { name_string },_) = &operation[0]{
                        let mut operation = operation.clone();
                        if operation[1].0 == Tokens::ADDEqual{
                            operation[1].0 = Tokens::Equal;
                            operation.insert(2, (Tokens::Name { name_string: name_string.clone() },(0,0)));
                            operation.insert(3, (Tokens::ADD,(0,0)));
                            operation.insert(4, (Tokens::LParen,(0,0)));
                            operation.push((Tokens::RParen,(0,0)));
                        }else if operation[1].0 == Tokens::SUBEqual{
                            operation[1].0 = Tokens::Equal;
                            operation.insert(2, (Tokens::Name { name_string: name_string.clone() },(0,0)));
                            operation.insert(3, (Tokens::SUB,(0,0)));
                            operation.insert(4, (Tokens::LParen,(0,0)));
                            operation.push((Tokens::RParen,(0,0)));
                        }else if operation[1].0 == Tokens::MULEqual{
                            operation[1].0 = Tokens::Equal;
                            operation.insert(2, (Tokens::Name { name_string: name_string.clone() },(0,0)));
                            operation.insert(3, (Tokens::MUL,(0,0)));
                            operation.insert(4, (Tokens::LParen,(0,0)));
                            operation.push((Tokens::RParen,(0,0)));
                        }else if operation[1].0 == Tokens::DIVEqual{
                            operation[1].0 = Tokens::Equal;
                            operation.insert(2, (Tokens::Name { name_string: name_string.clone() },(0,0)));
                            operation.insert(3, (Tokens::DIV,(0,0)));
                            operation.insert(4, (Tokens::LParen,(0,0)));
                            operation.push((Tokens::RParen,(0,0)));
                        }else if operation[1].0 == Tokens::MODEqual{
                            operation[1].0 = Tokens::Equal;
                            operation.insert(2, (Tokens::Name { name_string: name_string.clone() },(0,0)));
                            operation.insert(3, (Tokens::MOD,(0,0)));
                            operation.insert(4, (Tokens::LParen,(0,0)));
                            operation.push((Tokens::RParen,(0,0)));
                        }
                        if operation[1].0 == Tokens::Equal{
                            let var = &current_context.local_variables[name_string.as_str()];
                            expression_solver(&operation[2..operation.len()], &current_context.local_variables);
                            write(&format!("   mov [bp - {}], ax\n",var.1));
                        }
                    }
                }else {
                    panic!("{:?}",operation);
                }
            }
            Instruction::IfElse { condition, if_body, else_body } =>{
                write("   ; if statement\n");
                expression_solver(condition, &current_context.local_variables);
                write("   cmp ax, 1\n");
                let cli = current_context.logic_index;
                write(&format!("   jne .L_E{}\n",cli));
                intenal_compile(if_body, current_context);
                if else_body.is_some(){
                    write(&format!("   jmp .L_EE{}\n",current_context.logic_index + 1));
                }
                write(&format!(".L_E{}:\n",cli));
                current_context.logic_index+=1;
                let li = current_context.logic_index;
                if let Some(else_body) = else_body {
                    write("   ; else statement\n");
                    intenal_compile(else_body, current_context);
                    write(&format!(".L_EE{}:\n",li));
                    current_context.logic_index+=1;
                };
                write("   ; end if statement\n");
            }
            Instruction::MacroCall{ name, arguments } =>{
                
                match name.as_str() {
                    "asm" => {
                        if let Some((Tokens::String { string_content },_)) = arguments.get(0) {
                            let mut new_buff = String::new();
                            let mut c = string_content.chars().into_iter();
                            while let Some(char) = c.next() {
                                let char = &char;
                                if char == &'{' {
                                    let mut var_name = String::new();
                                    //c.next();
                                    while let Some(c) = c.next() {
                                        if c == '}'{
                                            break;
                                        }
                                        var_name.push(c);
                                    }
                                    new_buff.push_str(&format!("[bp - {}]",current_context.local_variables[var_name.as_str()].1));
                                    continue;
                                }
                                new_buff.push(char.clone());
                            }
                            write(new_buff.as_str());
                        }
                    }
                    _ => {}
                }
            }
            _ => {
                
            },
        }
    }
}

#[derive(Debug)]
pub enum ExprType {
    IntLiteral { num_as_string: String },
    Variable { name: String, size: usize, offset: usize },
    ArrayAccess { var_name: String, access_expression: Box<ExprType> },
    Operation { operation: String, left: Box<ExprType>, right: Option<Box<ExprType>> },
    FunctionCall { name: String, args: Vec<ExprType> }, // New variant for function calls
}
fn generate_nasm(ast: &ExprType) -> String {
    let mut code = String::new();

    match ast {
        ExprType::IntLiteral { num_as_string } => {
            // Load the integer literal into ax
            code.push_str(&format!("   mov ax, {}\n", num_as_string));
        }
        ExprType::Variable { name, size, offset } => {
            // Load the variable from the stack into ax
            code.push_str(&format!("   mov ax, WORD [bp - {}] ; VAR {}\n", offset, name));
        }
        ExprType::ArrayAccess { var_name, access_expression } => {
            // Generate code for the array index expression
            code.push_str(&generate_nasm(access_expression));
            // Multiply the index by 2 (since each element is 2 bytes)
            code.push_str("   shl ax, 1\n");
            // Load the array element into ax
            code.push_str(&format!("   add ax, {}\n", var_name));
            code.push_str("   mov ax, WORD [ax]\n");
        }
        ExprType::Operation { operation, left, right } => {
            // Generate code for the right operand
            if let Some(right_expr) = right {
                code.push_str(&generate_nasm(right_expr));
            }

            // Push ax onto the stack to save the left operand
            code.push_str("   push ax\n");

            // Generate code for the left operand
            code.push_str(&generate_nasm(left));
            // Pop the left operand into bx
            code.push_str("   pop bx\n");
            // Perform the operation
            match operation.as_str() {
                "+" => code.push_str("   add ax, bx\n"),
                "-" => {
                    code.push_str("   sub ax, bx\n");
                },
                "*" => code.push_str("   imul ax, bx\n"),
                "/" => {
                    code.push_str("   cwd\n"); // Sign-extend ax into dx
                    code.push_str("   idiv bx\n"); // Divide ax by bx
                }
                "%" => {
                    code.push_str("   cwd\n"); // Sign-extend ax into dx
                    code.push_str("   idiv bx\n"); // Divide ax by bx
                    code.push_str("   mov ax, dx\n"); // Remainder is in dx
                }
                "==" => {
                    code.push_str("   cmp ax, bx\n");
                    code.push_str("   sete al\n"); // Set al to 1 if equal, else 0
                    code.push_str("   movzx ax, al\n"); // Zero-extend al to ax
                }
                "!=" => {
                    code.push_str("   cmp ax, bx\n");
                    code.push_str("   setne al\n"); // Set al to 1 if not equal, else 0
                    code.push_str("   movzx ax, al\n"); // Zero-extend al to ax
                }
                ">" => {
                    code.push_str("   cmp ax, bx\n");
                    code.push_str("   setg al\n"); // Set al to 1 if greater, else 0
                    code.push_str("   movzx ax, al\n"); // Zero-extend al to ax
                }
                "<" => {
                    code.push_str("   cmp ax, bx\n");
                    code.push_str("   setl al\n"); // Set al to 1 if less, else 0
                    code.push_str("   movzx ax, al\n"); // Zero-extend al to ax
                }
                ">=" => {
                    code.push_str("   cmp ax, bx\n");
                    code.push_str("   setge al\n"); // Set al to 1 if greater or equal, else 0
                    code.push_str("   movzx ax, al\n"); // Zero-extend al to ax
                }
                "<=" => {
                    code.push_str("   cmp ax, bx\n");
                    code.push_str("   setle al\n"); // Set al to 1 if less or equal, else 0
                    code.push_str("   movzx ax, al\n"); // Zero-extend al to ax
                }
                _ => panic!("Unsupported operation: {}", operation),
            }
        }
        ExprType::FunctionCall { name, args } => {
            if args.len() == 1{
                code.push_str(&generate_nasm(&args[0]));
                code.push_str("   mov dx, ax\n");
            }else if args.len() != 0 {
                todo!()
            }
            // Call the function
            //code.push_str("   push dx\n");
            code.push_str(&format!("   call {}\n", name));
            // Clean up the stack after the function call (remove arguments)
            //code.push_str(&format!("   add sp, {}\n", args.len() * 2)); // Assuming 2 bytes per argument
        }
    }

    code
}

fn expression_solver(tokens: &[(Tokens, (u32, u32))], local_variables: &HashMap<String, (RCSType, usize)>) {
    // Parse the tokens into an ExprType AST
    let ast = parse_expression(tokens, local_variables);

    // Print the AST for debugging
    println!("{:?}", ast);
    write(&generate_nasm(&ast));
}

fn parse_expression(tokens: &[(Tokens, (u32, u32))], local_variables: &HashMap<String, (RCSType, usize)>) -> ExprType {
    println!("{:?}",tokens);
    let mut stack: Vec<ExprType> = Vec::new();
    let mut operators: Vec<Tokens> = Vec::new();
    let mut i = 0;
    while i < tokens.len() {
        let token = &tokens[i].0;
        match token {
            Tokens::Number { number_as_string } => {
                // Push an integer literal onto the stack
                stack.push(ExprType::IntLiteral {
                    num_as_string: number_as_string.to_string(),
                });
            }
            Tokens::Name { name_string } => {
                if i + 1 < tokens.len() && tokens[i + 1].0 == Tokens::LParen {
                    let mut args = Vec::new();
                    let mut depth = 0;
                    let mut arg_start = i + 2;
                    let mut arg_end = arg_start;
                    
                    // Parse arguments
                    while arg_end < tokens.len() {
                        match &tokens[arg_end].0 {
                            Tokens::LParen => depth += 1,
                            Tokens::RParen => {
                                if depth == 0 {
                                    if arg_end > arg_start {
                                        // Parse the argument expression
                                        let arg_tokens = &tokens[arg_start..arg_end];
                                        args.push(parse_expression(arg_tokens, local_variables));
                                    }
                                    break;
                                }
                                depth -= 1;
                            }
                            Tokens::Comma => {
                                if depth == 0 {
                                    // Parse the argument expression
                                    let arg_tokens = &tokens[arg_start..arg_end];
                                    args.push(parse_expression(arg_tokens, local_variables));
                                    arg_start = arg_end + 1;
                                }
                            }
                            _ => {}
                        }
                        arg_end += 1;
                    }
                    
                    stack.push(ExprType::FunctionCall {
                        name: *name_string.clone(),
                        args,
                    });
                    
                    i = arg_end + 1;
                    continue;
                }
                // Push a variable onto the stack
                if let Some(&(_, offset)) = local_variables.get(name_string.as_str()) {
                    stack.push(ExprType::Variable {
                        name: name_string.to_string(),
                        size: 2, 
                        offset,
                    });
                } else {
                    panic!("Undefined variable: {}\nExpression: {:?}", name_string, tokens);
                }
            }
            Tokens::LParen => {
                // Push a left parenthesis onto the operators stack
                operators.push(Tokens::LParen);
            }
            Tokens::RParen => {
                // Evaluate all operators until a left parenthesis is encountered
                while let Some(op) = operators.pop() {
                    if op == Tokens::LParen {
                        break;
                    }
                    evaluate_operator(&mut stack, op);
                }
            }
            Tokens::LSQBrace => {
                // Handle array access
                operators.push(Tokens::LSQBrace);
            }
            Tokens::RSQBrace => {
                // Evaluate the array access expression
                while let Some(op) = operators.pop() {
                    if op == Tokens::LSQBrace {
                        break;
                    }
                    evaluate_operator(&mut stack, op);
                }
                // Pop the array access expression and the variable name
                if let Some(access_expr) = stack.pop() {
                    if let ExprType::Variable { name, size, offset } = stack.pop().unwrap() {
                        stack.push(ExprType::ArrayAccess {
                            var_name: name,
                            access_expression: Box::new(access_expr),
                        });
                    } else {
                        panic!("Invalid array access");
                    }
                } else {
                    panic!("Invalid array access");
                }
            }
            
            _ => {
                // Handle operators
                if token.is_operator() {
                    while let Some(top_op) = operators.last() {
                        if top_op.is_operator() && top_op.precedence() >= token.precedence() {
                            let op = operators.pop().unwrap();
                            evaluate_operator(&mut stack, op);
                        } else {
                            break;
                        }
                    }
                    operators.push(token.clone());
                }
            }
        }
        i += 1;
    }

    // Evaluate any remaining operators
    while let Some(op) = operators.pop() {
        evaluate_operator(&mut stack, op);
    }

    // The final result should be on the stack
    stack.pop().expect("Invalid expression")
}


fn evaluate_operator(stack: &mut Vec<ExprType>, op: Tokens) {
    let right = stack.pop().expect("Missing operand");
    let left = stack.pop().expect("Missing operand");

    let operation = match op {
        Tokens::ADD => "+",
        Tokens::SUB => "-",
        Tokens::MUL => "*",
        Tokens::DIV => "/",
        Tokens::MOD => "%",
        Tokens::COMPEqual => "==",
        Tokens::COMPNOTEqual => "!=",
        Tokens::COMPGreater => ">",
        Tokens::COMPLess => "<",
        Tokens::COMPEqualGreater => ">=",
        Tokens::COMPEqualLess => "<=",
        _ => panic!("Unsupported operator: {:?}", op),
    };

    stack.push(ExprType::Operation {
        operation: operation.to_string(),
        left: Box::new(left),
        right: Some(Box::new(right)),
    });
}

fn compile(instructions: &[Instruction]){
    let mut global_context = CompilerContext{loop_index: 0, logic_index: 0,current_function_name: String::new(),local_variables: HashMap::new()};
    for x in instructions {
        match x {
            Instruction::FunctionCreation { name, return_type, arguments, body } => {
                // Function label
                write(&format!("\n{}:\n", name));
                if name != "main"{
                    // Function prologue
                    write("   push bp\n");
                    write("   mov bp, sp\n");
                }
                write("   sub sp, 16\n"); // PLACE HOLDER PLS FIX PLS
                let mut func_context = global_context.clone();
                func_context.current_function_name = name.clone();
                let mut offset = 0;
                for arg in arguments {
                    offset += 2; // use RCSTYPE, 
                    write(&format!("   mov WORD [bp - {}], dx ; argument {}:{} \n",offset, func_context.local_variables.len() + 1, arg.0));
                    func_context.local_variables.insert(arg.0.to_string(), (arg.1.clone(),offset));
                }
                println!("{:?}",func_context.local_variables);

                intenal_compile(&body, &mut func_context);
                global_context.loop_index = func_context.loop_index;
                global_context.logic_index = func_context.logic_index;
                if return_type == &RCSType::Void{
                    write("   xor ax, ax\n");
                }
                if name != "main"{
                    // Function prologue
                    write(&format!("   _exit_{}:\n", name));
                    write("   mov sp, bp\n");
                    write("   pop bp\n");
                    write("   ret\n\n");
                }else {
                    write("   cli\n");
                    write("   hlt\n");
                }
            },
            _ => todo!("{:?}",x),
        }
    }
    // Only to test bootloader
    write("times 510-($-$$) db 0 ; Pad the rest of the boot sector with zeros\n");
    write("dw 0xAA55             ; Boot signature \n");
}
// nasm -f bin a.asm -o a.bin && qemu-system-x86_64 -fda a.bin