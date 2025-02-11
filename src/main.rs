use std::{collections::HashMap, fs::File, io::{Seek, SeekFrom, Write}, path::Path, process::Command};

use instructions::Instruction;
use lexer::lex;
use ordered_hash_map::OrderedHashMap;
use parser::{parse, ParserFactory, ParserVariableType};
use tokens::Tokens;

mod lexer;
mod tokens;
mod instructions;
mod parser;
pub const debug: bool = true;

fn main() {
    if debug {
        let tests = vec![
            ("1_basics", "basic_test"),
            ("2_arrays", "array_test"),
            ("3_structs", "struct_test"),
        ];
        for (dir, name) in tests {
            let path = format!("./tests/{}/{}.rsc", dir, name);
            let asm_out = format!("./tests/{}/{}.asm", dir, name);
            compile_file(&path, &asm_out);
            test(&asm_out);
        }
    }
    compile_file("./main.rcs","./main.asm");
}
fn test(file_path: &str) -> bool {
    // Check if the file exists
    if !Path::new(file_path).exists() {
        eprintln!("Error: File '{}' does not exist.", file_path);
        return false;
    }

    // Assemble the file using NASM
    let output = Command::new("nasm")
        .arg("-f") // Specify output format
        .arg("bin") // 16-bit binary format
        .arg("-o") // Output file
        .arg("output.bin") // Temporary output file name
        .arg(file_path) // Input file
        .output()
        .expect("Failed to execute NASM");

    // Check if NASM succeeded
    if !output.status.success() {
        let error = String::from_utf8(output.stderr).expect("Invalid UTF-8");
        eprintln!("NASM Error: {}", error);
        return false;
    }

    // Check if the binary file was generated
    if !Path::new("output.bin").exists() {
        eprintln!("Error: Binary file was not generated.");
        return false;
    }

    // If the binary was generated, delete it
    if let Err(err) = std::fs::remove_file("output.bin") {
        eprintln!("Error deleting binary file: {}", err);
        return false;
    }

    println!("Test succeeded: Binary generated and deleted.");
    true
}
fn compile_file(path: &str,output: &str){
    let x = lex(std::fs::canonicalize(Path::new(path).to_str().unwrap()).unwrap().to_str().unwrap()).unwrap_or_else(|e| {
        eprintln!("Error during lexing: {}", e); 
        std::process::exit(1);
    });
    File::options().read(false).write(true).create(true).truncate(true).open("lexer_output.txt").unwrap().write(format!("{:?}",x).as_bytes()).unwrap();
    let y = parse(&x);
    File::options().read(false).write(true).create(true).truncate(true).open("parser_output.txt").unwrap().write(format!("{:?}",y).as_bytes()).unwrap();

    clear();
    compile(&y);
    if output != "./main.asm"{
        std::fs::copy(std::fs::canonicalize(Path::new("./main.asm").to_str().unwrap()).unwrap().to_str().unwrap(), Path::new(output).to_str().unwrap()).unwrap();
        std::fs::remove_file(std::fs::canonicalize(Path::new("./main.asm").to_str().unwrap()).unwrap().to_str().unwrap()).unwrap();
    }
}

fn clear(){
    let f = File::options().read(true).write(true).create(true).open("main.asm").unwrap();
    f.set_len(0).unwrap();
}
fn write(string:&str){
    let mut f = File::options().read(true).write(true).open("main.asm").unwrap();
    f.seek(SeekFrom::End(0)).unwrap();
    f.write(string.as_bytes()).unwrap();
}
#[derive(Clone,Debug, PartialEq)]
enum CompilerVariableTypeEnum {
    ValueType(usize),
    Pointer(Box<CompilerVariableTypeEnum>),
    Array((Box<CompilerVariableTypeEnum>,usize)),
}
#[derive(Clone,Debug, PartialEq)]
struct CompilerVariableType{
    _type: CompilerVariableTypeEnum,
    members: Vec<(String,String,usize)>,
    
}

impl CompilerVariableType {
    fn size(&self) -> usize {
        fn get_size(x: &CompilerVariableTypeEnum) -> usize{
            return match x {
                CompilerVariableTypeEnum::ValueType(s) => *s,
                CompilerVariableTypeEnum::Pointer(_) => 2,
                CompilerVariableTypeEnum::Array(s) => get_size(&s.0) * s.1,
            };
        }
        return get_size(&self._type);
    }
    fn size_per_entry(&self) -> usize {
        fn get_size_per_entry(x: &CompilerVariableTypeEnum) -> usize{
            return match x {
                CompilerVariableTypeEnum::Array(s) => get_size_per_entry(&s.0),
                CompilerVariableTypeEnum::ValueType(s) => *s,
                CompilerVariableTypeEnum::Pointer(_) => 2,
            };
        }
        return get_size_per_entry(&self._type);
    }
    fn _type(&self) -> &CompilerVariableTypeEnum {
        &self._type
    }
}
#[derive(Clone)]
struct CompilerContext{
    current_function_name: String,
    local_variables: OrderedHashMap<String, (CompilerVariableType, usize)>,
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
                return CompilerVariableType{_type: CompilerVariableTypeEnum::Array((Box::new(x._type().clone()),*s)),members:Vec::new()};
            }
            todo!()
        }
        todo!()
    }
    eprintln!("{:?}",x);
    todo!()
}
fn intenal_compile(body:&[Instruction], current_context: &mut CompilerContext){
    // Generate the loop label and increment the loop index
    let mut loop_label = current_context.loop_index.clone();
    for x in body {
        match x {
            Instruction::VariableDeclaration { name, _type, expression } =>{
                let cvt = get_cvt(_type,&current_context.declared_types);
                current_context.local_variables.insert(name.to_string(), (cvt.clone(),current_context.local_variables.values().last().and_then(|x| Some(x.1)).unwrap_or(0) + cvt.size()));
                if expression.len() != 0 {
                    let this_var = &current_context.local_variables[name];
                    expression_solver(&expression,&current_context);
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
                    expression_solver(value, &current_context);
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
                if arguments.len() !=0 {
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
                        expression_solver(&args_vectors[0], &current_context);
                        write(&format!("   mov dx, ax ; load arg 0 to call {} \n",name));
                    }
                }
                write(&format!("   call {} \n",name));
            }
            Instruction::Operation { operation } =>{
                if operation.len() <= 2{
                    panic!("{:?}",operation);
                }
                let mut _array = false;
                let mut _struct = false;
                let qwer = vec![Tokens::Equal,Tokens::ADDEqual,Tokens::SUBEqual,Tokens::MULEqual,Tokens::DIVEqual,Tokens::MODEqual];

                let mut expr = vec![];
                let mut token_vec = vec![];
                ParserFactory::new(&operation).gather_with_expect_until_with_zero_closure(&qwer,  &mut token_vec);
                if let (Tokens::Name { name_string },_) = &operation[0]{
                    let mut operation = operation.clone();
                    if operation[1].0 == Tokens::LSQBrace{
                        let x = ParserFactory::new(operation.split_at(1).1)
                        .gather_with_expect(Tokens::LSQBrace, Tokens::RSQBrace, &mut expr)
                        .total_tokens();
                        for _ in 0..x {
                            operation.remove(1);
                        }
                        _array = true;
                    }
                    if operation[1].0 == Tokens::Dot{
                        for _ in 0..token_vec.len() - 1 {
                            operation.remove(1);
                        }
                        _struct = true;
                    }
                    
                    for i in 1..qwer.len() {
                        if operation[1].0 == qwer[i]{
                            let rewq = vec![Tokens::ADD,Tokens::SUB,Tokens::MUL,Tokens::DIV,Tokens::MOD];
                            operation[1].0 = Tokens::Equal;
                            for x in token_vec.iter().rev() {
                                operation.insert(2, x.clone());
                            }
                            operation.insert(token_vec.len() + 2, (rewq[i - 1].clone(),(0,0)));
                            operation.insert(token_vec.len() + 3, (Tokens::LParen,(0,0)));
                            operation.push((Tokens::RParen,(0,0)));
                            break;
                        }
                    }
                    
                    if operation[1].0 == Tokens::Equal{
                        let var = &current_context.local_variables[name_string.as_str()];
                        if _array{
                            let var_info = &current_context.local_variables[name_string.as_str()];
                            let element_size = var_info.0.size_per_entry();
                            let array_offset = var_info.1;
                            expression_solver(&expr, &current_context); // AX == result
                            write(&format!("   imul ax, {}\n", element_size));
                            write("   mov bx, bp\n");
                            write(&format!("   sub bx, {}\n",array_offset));
                            write("   add bx, ax\n");
                            write("   push bx\n");
                            expression_solver(&operation[2..operation.len()], &current_context);
                            write("   pop bx\n");
                            match element_size {
                                2 => write("   mov WORD [bx], ax\n"),
                                1 => write("   mov BYTE [bx], al\n"),
                                _ => panic!("Unsupported array element size"),
                            }
                        }else if _struct {
                            let var_info = &current_context.local_variables[name_string.as_str()];
                            let mut q = vec![];
                            for i in 2..token_vec.len() {
                                if token_vec[i].0 != Tokens::Dot{
                                    if let Tokens::Name { name_string } = &token_vec[i].0{
                                        q.push(name_string.to_string());
                                    }
                                }
                            }

                            let mut x = var_info.0.members.iter().find(|x| x.0 == q[0]).unwrap();
                            let mut a = &current_context.declared_types[x.1.as_str()];
                            let mut offset = 0;
                            offset += x.2;
                            for i in 1..q.len() {
                                x = a.members.iter().find(|x| x.0.as_str() == q[i]).unwrap();
                                a = &current_context.declared_types[x.1.as_str()];
                                offset += x.2;
                            }
                            offset += a.size();
                            expression_solver(&operation[2..operation.len()], &current_context);
                            write_reuslt_into_var(a,var.1 - var.0.size() + offset,name_string);

                        }else {
                            expression_solver(&operation[2..operation.len()], &current_context);
                            write_reuslt_into_var(&var.0,var.1,name_string);
                        }
                    }
                }
                
            }
            Instruction::IfElse { condition, if_body, else_body } =>{
                write("   ; if statement\n");
                expression_solver(condition, &current_context);
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
                                        new_buff.push_str(&format!("[bp - {}]",current_context.local_variables[var_name.as_str()].1 + current_context.local_variables[var_name.as_str()].0.size()));
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
fn write_reuslt_into_var(var:&CompilerVariableType, offset:usize, name: &str){
    if var.size_per_entry() == 2{
        write(&format!("   mov WORD [bp - {}], ax ; VAR {}\n",offset,name));
    }else  if var.size_per_entry() == 1{
        write(&format!("   mov BYTE [bp - {}], al ; VAR {}\n",offset,name));
    }else {
        panic!("{:?}",var);
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

fn expression_solver(tokens: &[(Tokens, (u32, u32))], current_context: &CompilerContext) {
    fn generate_nasm(ast: &ExprType,local_variables: &OrderedHashMap<String, (CompilerVariableType, usize)>) -> String {
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
    fn parse_expression(tokens: &[(Tokens, (u32, u32))], current_context: &CompilerContext) -> ExprType {
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
                                            args.push(parse_expression(arg_tokens, current_context));
                                        }
                                        break;
                                    }
                                    depth -= 1;
                                }
                                Tokens::Comma => {
                                    if depth == 0 {
                                        // Parse the argument expression
                                        let arg_tokens = &tokens[arg_start..arg_end];
                                        args.push(parse_expression(arg_tokens, current_context));
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
                    else if i + 1 < tokens.len() && tokens[i + 1].0 == Tokens::Dot {
                        let var_info = &current_context.local_variables[name_string.as_str()];
                        let mut q = vec![];
                        for i in i + 2..tokens.len() {
                            if let Tokens::Name { name_string } = &tokens[i].0{
                                q.push(name_string.to_string());
                            }else if i % 2 == 1 {
                                if Tokens::Dot != tokens[i].0{
                                    break;
                                }
                            }
                        }
                        println!("{q:?}");
                        let mut offset = var_info.1 - var_info.0.size();
                        let mut x = var_info.0.members.iter().find(|x| x.0 == q[0]).unwrap();
                        let mut a = &current_context.declared_types[x.1.as_str()];
                        offset += x.2;
                        for i in 1..q.len() {
                            x = a.members.iter().find(|x| x.0.as_str() == q[i]).unwrap();
                            a = &current_context.declared_types[x.1.as_str()];
                            offset += x.2;
                        }
                        offset += a.size();
                        println!("{offset:?}");
                        println!("{a:?}");
                        println!("{var_info:?}");
                        stack.push(ExprType::Variable {
                            name: name_string.to_string(),
                            size: a.size(), 
                            offset,
                        });
                        i += 2 * q.len() + 1;
                        continue;
                    }
                    // Push a variable onto the stack
                    if let Some((_type, offset)) = &current_context.local_variables.get(name_string.as_str()) {
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
    let ast = parse_expression(tokens, current_context);
    write(&generate_nasm(&ast,&current_context.local_variables));
}

fn compile(instructions: &[Instruction]){
    let mut basic_types:HashMap<String, CompilerVariableType> = HashMap::new();
    basic_types.insert("u8".to_string(), CompilerVariableType { _type: CompilerVariableTypeEnum::ValueType(1), members: vec![] });
    basic_types.insert("u16".to_string(), CompilerVariableType { _type: CompilerVariableTypeEnum::ValueType(2), members: vec![("lh".to_string(),"u8".to_string(),0),("uh".to_string(),"u8".to_string(),1)] });
    basic_types.insert("u32".to_string(), CompilerVariableType { _type: CompilerVariableTypeEnum::ValueType(4), members: vec![] });
    basic_types.insert("u64".to_string(), CompilerVariableType { _type: CompilerVariableTypeEnum::ValueType(8), members: vec![] });
    //let mut declared_functions = HashMap::new();
    //let mut declared_structs = HashMap::new();
    let mut n_instructions = vec![];
    for x in instructions {
        match x {
            Instruction::StructDeclaration { name, fields } => {
                let mut total_size = 0;
                let mut offset = 0;
                let mut members: Vec<(String, String, usize)> = vec![];
                for x in fields {
                    let _type: CompilerVariableType = get_cvt(&x.1, &basic_types);
                    let found_type: (&String, &CompilerVariableType) = basic_types.iter().find(|y| {_type == *y.1}).unwrap();
                    total_size += found_type.1.size();
                    members.push((x.0.to_string(),found_type.0.to_string(),offset));
                    offset += found_type.1.size();
                }
                println!("{:?}",members);
                basic_types.insert(name.to_string(), CompilerVariableType { _type: CompilerVariableTypeEnum::ValueType(total_size), members});
                //basic_types.insert(name, CompilerVariableType {_type: })
            }
            _ => {n_instructions.push(x);},
        }
    }
    let mut global_context = CompilerContext{loop_index: 0, logic_index: 0,current_function_name: String::new(), declared_types: basic_types, local_variables: OrderedHashMap::new()};
    for x in n_instructions {
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
                if arguments.len() != 0{
                    if arguments.len() >= 1{
                        let arg = &arguments[0];
                        let cvt = get_cvt(&arg.1, &global_context.declared_types);
                        func_context.local_variables.insert(arg.0.to_string(), (get_cvt(&arg.1,&global_context.declared_types),offset));
                        offset += cvt.size();
                        match cvt.size() {
                            2 => {write(&format!("   mov WORD [bp - {}], dx ; VAR argument N{}: {}\n",offset,0,arg.0));}
                            1 => {write(&format!("   mov BYTE [bp - {}], dl ; VAR argument N{}: {}\n",offset,0,arg.0));}
                            _ => {panic!("")}
                        }
                    }
                }

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