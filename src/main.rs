use std::{collections::HashMap, fs::File, io::{Seek, SeekFrom, Write}};

use instructions::Instruction;
use lexer::lex;
use parser::{parse, ParserFactory, ParserVariableType};
use tokens::Tokens;

mod lexer;
mod tokens;
mod instructions;
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








fn clear(){
    let f = File::options().read(true).write(true).create(true).open("a.asm").unwrap();
    f.set_len(0).unwrap();
}
fn write(string:&str){
    let mut f = File::options().read(true).write(true).open("a.asm").unwrap();
    f.seek(SeekFrom::End(0)).unwrap();
    f.write(string.as_bytes()).unwrap();
}
#[derive(Clone,Debug)]
enum CompilerVariableTypeE {
    ValueType(usize),
    Pointer(Box<CompilerVariableTypeE>),
    Array((Box<CompilerVariableTypeE>,usize)),
    Tuple(Vec<CompilerVariableTypeE>),
}
#[derive(Clone,Debug)]
struct CompilerVariableType{
    _type: CompilerVariableTypeE,
    
}

impl CompilerVariableType {
    fn size(&self) -> usize {
        fn get_size(x: &CompilerVariableTypeE) -> usize{
            return match x {
                CompilerVariableTypeE::ValueType(s) => *s,
                CompilerVariableTypeE::Pointer(_) => 2,
                CompilerVariableTypeE::Array(s) => get_size(&s.0) * s.1,
                CompilerVariableTypeE::Tuple(s) => s.iter().map(|x| get_size(x)).sum(),
            };
        }
        return get_size(&self._type);
    }
    fn size_per_entry(&self) -> usize {
        fn get_size_per_entry(x: &CompilerVariableTypeE) -> usize{
            return match x {
                CompilerVariableTypeE::Array(s) => get_size_per_entry(&s.0),
                CompilerVariableTypeE::ValueType(s) => *s,
                CompilerVariableTypeE::Pointer(_) => 2,
                CompilerVariableTypeE::Tuple(s) => s.iter().map(|x| get_size_per_entry(x)).sum(),
            };
        }
        return get_size_per_entry(&self._type);
    }
    fn _type(&self) -> &CompilerVariableTypeE {
        &self._type
    }
}
#[derive(Clone)]
struct CompilerContext{
    current_function_name: String,
    local_variables: HashMap<String, (CompilerVariableType, usize)>,
    declared_types: HashMap<String, CompilerVariableType>,
    loop_index: usize,
    logic_index: usize,
}
fn get_cvt(x:&ParserVariableType,declared_types: &HashMap<String, CompilerVariableType>) -> CompilerVariableType{
    if let ParserVariableType::Type(x) = x{
        if let Some(x) = declared_types.get(x.as_str()){
            return x.clone();
        }
        todo!()
    }
    if let ParserVariableType::ArrayStack(x,s) = x{
        if let ParserVariableType::Type(x) = *x.clone(){
            if let Some(x) = declared_types.get(x.as_str()){
                return CompilerVariableType{_type: CompilerVariableTypeE::Array((Box::new(x._type().clone()),*s))};
            }
            todo!()
        }
        todo!()
    }
    println!("{:?}",x);
    todo!()
}
fn intenal_compile(body:&[Instruction], current_context: &mut CompilerContext){
    // Generate the loop label and increment the loop index
    let mut loop_label = current_context.loop_index.clone();
    for x in body {
        println!("--------");
        println!("{:?}",x);
        match x {
            Instruction::VariableDeclaration { name, _type, expression } =>{
                let cvt = get_cvt(_type,&current_context.declared_types);
                current_context.local_variables.insert(name.to_string(), (cvt.clone(),current_context.local_variables.values().last().and_then(|x| Some(x.1)).unwrap_or(0) + cvt.size()));
                if expression.len() != 0 {
                    let this_var = &current_context.local_variables[name];
                    println!("{:?}",expression);
                    expression_solver(&expression,&current_context.local_variables);
                    if this_var.0.size() == 2{
                        write(&format!("   mov WORD [bp - {}], ax ; VAR {}\n",this_var.1,name));
                    }else  if this_var.0.size() == 1{
                        write(&format!("   mov BYTE [bp - {}], al ; VAR {}\n",this_var.1,name));
                    }

                }
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
                    let mut expr = Vec::new();
                    let mut token_vec = vec![];
                    ParserFactory::new(&operation).gather_with_expect_until_with_zero_closure(&vec![Tokens::Equal,Tokens::ADDEqual,Tokens::SUBEqual,Tokens::MULEqual,Tokens::DIVEqual,Tokens::MODEqual],  &mut token_vec);
                    if let (Tokens::Name { name_string },_) = &operation[0]{
                        let mut operation = operation.clone();
                        if operation[1].0 == Tokens::LSQBrace{
                            let x = ParserFactory::new(operation.split_at(1).1)
                            .gather_with_expect(Tokens::LSQBrace, Tokens::RSQBrace, &mut expr)
                            .total_tokens();
                            for _ in 0..x {
                                operation.remove(1);
                            }
                        }
                        if operation[1].0 == Tokens::ADDEqual{
                            operation[1].0 = Tokens::Equal;
                            for x in token_vec.iter().rev() {
                                operation.insert(2, x.clone());
                            }
                            println!("{:?}",operation);
                            operation.insert(token_vec.len() + 2, (Tokens::ADD,(0,0)));
                            operation.insert(token_vec.len() + 3, (Tokens::LParen,(0,0)));
                            operation.push((Tokens::RParen,(0,0)));
                            println!("{:?}",operation);
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
                            if expr.len() != 0{
                                let var_info = &current_context.local_variables[name_string.as_str()];
                                let element_size = var_info.0.size_per_entry();
                                let array_offset = var_info.1;
                                expression_solver(&expr, &current_context.local_variables); // AX == result
                                write(&format!("   imul ax, {}\n", element_size));
                                write("   mov bx, bp\n");
                                write(&format!("   sub bx, {}\n",array_offset));
                                write("   add bx, ax\n");
                                write("   push bx\n");
                                expression_solver(&operation[2..operation.len()], &current_context.local_variables);
                                write("   pop bx\n");
                                match element_size {
                                    1 => write("   mov BYTE [bx], al\n"),
                                    _ => panic!("Unsupported array element size"),
                                }
                            }else {
                                expression_solver(&operation[2..operation.len()], &current_context.local_variables);
                                if var.0.size_per_entry() == 2{
                                    write(&format!("   mov WORD [bp - {}], ax ; VAR {}\n",var.1,name_string));
                                }else  if var.0.size_per_entry() == 1{
                                    write(&format!("   mov BYTE [bp - {}], al ; VAR {}\n",var.1,name_string));
                                }
                            }
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
                        for x in arguments {
                            let mut new_buff = "   ".to_string();
                            if let Tokens::String { string_content } = &x.0{
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
                                new_buff.push('\n');
                                write(new_buff.as_str());
                            }
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

fn expression_solver(tokens: &[(Tokens, (u32, u32))], local_variables: &HashMap<String, (CompilerVariableType, usize)>) {
    fn generate_nasm(ast: &ExprType,local_variables: &HashMap<String, (CompilerVariableType, usize)>) -> String {
        let mut code = String::new();
    
        match ast {
            ExprType::IntLiteral { num_as_string } => {
                // Load the integer literal into ax
                code.push_str(&format!("   mov ax, {}\n", num_as_string));
            }
            ExprType::Variable { name, size, offset } => {
                // Load the variable from the stack into ax
                match size {
                    2 => code.push_str(&format!("   mov ax, WORD [bp - {}] ; VAR {}\n", offset, name)),
                    1 => code.push_str(&format!("   movzx ax, BYTE [bp - {}] ; VAR {}\n", offset, name)),
                    _ => todo!(),
                }
            }
            ExprType::ArrayAccess { var_name, access_expression } => {

                // Get array metadata
                let var_info = &local_variables[var_name];
                let element_size = var_info.0.size_per_entry();
                let array_offset = var_info.1;

                // Generate code for the array index expression
                code.push_str(&generate_nasm(access_expression,local_variables));
                // Load the array element into ax
                code.push_str(&format!("   imul ax, {}\n", element_size));
                code.push_str("   mov bx, bp\n");
                code.push_str(&format!("   sub bx, {}\n",array_offset));
                code.push_str("   add bx, ax\n");
                code.push_str(&format!("   mov ax, WORD [bx]\n"));
                // Load value from calculated address
                match element_size {
                    1 => code.push_str("   movzx ax, BYTE [bx]\n"),
                    2 => code.push_str("   mov ax, WORD [bx]\n"),
                    4 => code.push_str("   mov ax, WORD [bx]\n   mov dx, WORD [bx+2]\n"),
                    _ => panic!("Unsupported array element size"),
                }
            }
            ExprType::Operation { operation, left, right } => {
                // Generate code for the right operand
                if let Some(right_expr) = right {
                    code.push_str(&generate_nasm(right_expr,local_variables));
                }
    
                // Push ax onto the stack to save the left operand
                code.push_str("   push ax\n");
    
                // Generate code for the left operand
                code.push_str(&generate_nasm(left,local_variables));
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
                    "<<" => {
                        code.push_str("   mov cx, bx\n");
                        code.push_str("   shl ax, cl\n");
                    }
                    // The shift right operation is already correct
                    ">>" => {
                        code.push_str("   mov cx, bx\n");
                        code.push_str("   shr ax, cl\n");
                    }
                    _ => panic!("Unsupported operation: {}", operation),
                }
            }
            ExprType::FunctionCall { name, args } => {
                if args.len() == 1{
                    code.push_str(&generate_nasm(&args[0],local_variables));
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
    fn parse_expression(tokens: &[(Tokens, (u32, u32))], local_variables: &HashMap<String, (CompilerVariableType, usize)>) -> ExprType {
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
                Tokens::ShiftL => "<<",
                Tokens::ShiftR => ">>",
                _ => panic!("Unsupported operator: {:?}", op),
            };
        
            stack.push(ExprType::Operation {
                operation: operation.to_string(),
                left: Box::new(left),
                right: Some(Box::new(right)),
            });
        }
        
        
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
                    if i + 1 < tokens.len() && tokens[i + 1].0 == Tokens::LSQBrace {



                    }
                    // Push a variable onto the stack
                    if let Some((_type, offset)) = &local_variables.get(name_string.as_str()) {
                        stack.push(ExprType::Variable {
                            name: name_string.to_string(),
                            size: _type.size(), 
                            offset: *offset,
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
    
    // Parse the tokens into an ExprType AST
    let ast = parse_expression(tokens, local_variables);

    // Print the AST for debugging
    println!("{:?}", ast);
    write(&generate_nasm(&ast,local_variables));
}

fn compile(instructions: &[Instruction]){
    let mut basic_types:HashMap<String, CompilerVariableType> = HashMap::new();
    basic_types.insert("u8".to_string(), CompilerVariableType { _type: CompilerVariableTypeE::ValueType(1) });
    basic_types.insert("u16".to_string(), CompilerVariableType { _type: CompilerVariableTypeE::ValueType(2) });
    basic_types.insert("u32".to_string(), CompilerVariableType { _type: CompilerVariableTypeE::ValueType(4) });
    basic_types.insert("u64".to_string(), CompilerVariableType { _type: CompilerVariableTypeE::ValueType(8) });
    
    let mut global_context = CompilerContext{loop_index: 0, logic_index: 0,current_function_name: String::new(), declared_types: basic_types,local_variables: HashMap::new()};
    for x in instructions {
        match x {
            Instruction::FunctionCreation { name, return_type, arguments, body } => {
                // Function label
                write(&format!("\n{}:\n", name));
                if name != "main"{
                    // Function prologue
                    write("   push bp\n");
                    write("   mov bp, sp\n");
                }else {
                    write("   mov bp, sp\n");
                }
                write("   sub sp, 16\n"); // PLACE HOLDER PLS FIX PLS Dynamic Stack Allocation TODO
                let mut func_context = global_context.clone();
                func_context.current_function_name = name.clone();
                let mut offset = 0;
                let mut arg_num = 0;
                for arg in arguments {
                    let cvt = get_cvt(&arg.1, &global_context.declared_types);
                    offset += cvt.size(); // use RCSTYPE,
                    if cvt.size() == 2{
                        write(&format!("   mov WORD [bp - {}], dx ; VAR argument N{}: {}\n",offset,arg_num,arg.0));
                    }else  if cvt.size() == 1{
                        write(&format!("   mov BYTE [bp - {}], dl ; VAR argument N{}: {}\n",offset,arg_num,arg.0));
                    }
                    func_context.local_variables.insert(arg.0.to_string(), (get_cvt(&arg.1,&global_context.declared_types),offset));
                    arg_num += 1;
                }
                //println!("{:?}",func_context.local_variables);

                intenal_compile(&body, &mut func_context);
                global_context.loop_index = func_context.loop_index;
                global_context.logic_index = func_context.logic_index;
                if return_type == &ParserVariableType::Void{
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
    write("times 510 - ($ - $$) db 0\ndw 0xAA55\n");
}
// nasm -f bin a.asm -o a.bin && qemu-system-x86_64 -fda a.bin