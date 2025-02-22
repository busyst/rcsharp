use std::{collections::{HashMap, HashSet}, fs::File, io::Write};
use crate::{instructions::Instruction, parser::{ParserFactory, ParserVariableType}, tokens::Tokens, type_parsers::{get_cvt, CompilerVariableType, CompilerVariableTypeEnum}};
use ordered_hash_map::OrderedHashMap;
#[allow(dead_code)]
#[derive(Debug,Clone)]
pub enum ASMConvEnum {
    Label(String),
    Push(String),
    Pop(String),
    Mov(String,String),
    MovToAlpha(String),
    MovFromAlpha(String),
    CMP(String,String),
    SOP(String,String),
    BOP(String,String,String),
    ASMINSERT(String),
    JMP(String),
    JNE(String),
    JE(String),
    CALL(String),
    OP(String),
    Comment(String),
}

pub fn clear(){
    let f = File::options().read(true).write(true).create(true).open("main.asm").unwrap();
    f.set_len(0).unwrap();
}

#[derive(Clone)]
pub struct CompilerContext{
    asm: Vec<ASMConvEnum>,
    current_function_name: String,
    local_variables: OrderedHashMap<String, (CompilerVariableType, usize)>,
    declared_types: HashMap<String, CompilerVariableType>,
    loop_index: usize,
    logic_index: usize,

    stack_offset: usize,
}
impl CompilerContext {
    pub fn get_variable_or_panic(&self, name: &str) -> &(CompilerVariableType, usize){
        if let Some(x) = self.local_variables.get(name) {
            return x;
        }
        panic!("Value {name} not found in this context!");
    }
    pub fn get_type_or_panic(&self, name: &str) -> &CompilerVariableType{
        if let Some(x) = self.declared_types.get(name) {
            return x;
        }
        panic!("Type {name} not found in this context!");
    }
    pub fn get_type(&self, name: &str) -> Option<&CompilerVariableType>{
        self.declared_types.get(name)
    }
    pub fn get_variable(&self, name: &str) -> Option<&(CompilerVariableType, usize)>{
        self.local_variables.get(name)
    }
    pub fn add_variable(&mut self, name: String, var: CompilerVariableType) -> usize{
        if self.local_variables.contains_key(&name){
            panic!("Variable \"{}\" is already used in current context. TODO: problem with compiler",name);
        }
        self.stack_offset += &var.size();
        self.local_variables.insert(name, (var, self.stack_offset.clone()));
        self.stack_offset
    }
    pub fn add_asm(&mut self, asm: ASMConvEnum){
        self.asm.push(asm);
    }
}

fn internal_compile(body:&[Instruction], mut current_context: &mut CompilerContext){
    // Generate the loop label and increment the loop index
    let mut loop_label = current_context.loop_index.clone();
    for x in body {
        match x {
            Instruction::VariableDeclaration { name, _type } =>{
                current_context.add_variable(name.to_string(), get_cvt(_type,&current_context));
            }
            Instruction::Loop { body } => {
                loop_label = current_context.loop_index.clone();
                // Generate the loop label and increment the loop index
                current_context.add_asm(ASMConvEnum::Label(format!(".{}.Loop{}",current_context.current_function_name, loop_label)));
                current_context.loop_index += 1;

                // Compile the body of the loop
                internal_compile(body, current_context);

                // After the loop body, generate jump and exit labels
                current_context.add_asm(ASMConvEnum::JMP(format!(".{}.Loop{}",current_context.current_function_name, loop_label)));
                current_context.add_asm(ASMConvEnum::Label(format!(".{}.Loop{}_EXIT",current_context.current_function_name, loop_label)));
            }
            Instruction::Return { expression: value } =>{
                if let Some(value) = value{
                    expression_solver(value, &mut current_context);
                }
                current_context.add_asm(ASMConvEnum::JMP(format!(".exit_{}",current_context.current_function_name)));
            }
            Instruction::Break => {
                // Generate jump to exit the current loop
                current_context.add_asm(ASMConvEnum::JMP(format!(".{}.Loop{}_EXIT",current_context.current_function_name, loop_label - 1)));
            }
            Instruction::Continue => {
                // Generate jump to continue the current loop
                current_context.add_asm(ASMConvEnum::JMP(format!(".{}.Loop{}",current_context.current_function_name, loop_label - 1)));
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
                        expression_solver(&args_vectors[0], &mut current_context);
                        current_context.add_asm(ASMConvEnum::Mov("dx".to_string(),"ax".to_string()));
                    }
                }
                current_context.add_asm(ASMConvEnum::CALL(name.to_string()));
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
                        let var = current_context.get_variable_or_panic(name_string).clone();
                        if _array {
                            let element_size = var.0.size_per_entry();
                            let array_offset = var.1;
                            current_context.add_asm(ASMConvEnum::Comment(format!("Array {name_string} access")));
                            // Calculate index and scale it
                            expression_solver(&expr, &mut current_context); // Result in AX
                            if element_size != 1 {
                                current_context.add_asm(ASMConvEnum::BOP("imul".to_string(), "ax".to_string(), element_size.to_string()));
                            }

                            // Compute element address
                            current_context.add_asm(ASMConvEnum::Mov("bx".to_string(), "bp".to_string()));
                            current_context.add_asm(ASMConvEnum::BOP("add".to_string(), "bx".to_string(), element_size.to_string()));
                            current_context.add_asm(ASMConvEnum::BOP("sub".to_string(), "bx".to_string(), array_offset.to_string()));
                            current_context.add_asm(ASMConvEnum::BOP("add".to_string(), "bx".to_string(), "ax".to_string()));
                            // Evaluate value to store
                            current_context.add_asm(ASMConvEnum::Comment(format!("Array {name_string} index calculation")));

                            expression_solver(&operation[2..operation.len()], &mut current_context);
                            // Store based on element size
                            match element_size {
                                1 => current_context.add_asm(ASMConvEnum::Mov("BYTE [bx]".to_string(), "al".to_string())),
                                2 => current_context.add_asm(ASMConvEnum::Mov("WORD [bx]".to_string(), "ax".to_string())),
                                _ => panic!("Unsupported array element size"),
                            }
                        }else if _struct {
                            let mut q = vec![];
                            for i in 2..token_vec.len() {
                                if token_vec[i].0 != Tokens::Dot{
                                    if let Tokens::Name { name_string } = &token_vec[i].0{
                                        q.push(name_string.to_string());
                                    }
                                }
                            }

                            let mut x = var.0.find_member(&q[0]);
                            let mut a = &current_context.declared_types[x.1.as_str()];
                            let mut offset = 0;
                            offset += x.2;
                            for i in 1..q.len() {
                                x = a.find_member(&q[i]);
                                a = &current_context.declared_types[x.1.as_str()];
                                offset += x.2;
                            }
                            offset += a.size();
                            let a = a.clone();
                            expression_solver(&operation[2..operation.len()], &mut current_context);
                            write_result_into_var(&a,var.1 - var.0.size() + offset,name_string,&mut current_context.asm);
                            
                        }else {
                            expression_solver(&operation[2..operation.len()], &mut current_context);
                            let var = var.clone();
                            write_result_into_var(&var.0,var.1,name_string,&mut current_context.asm);
                        }
                    }
                }
                
            }
            Instruction::IfElse { condition, if_body, else_body } =>{
                current_context.add_asm(ASMConvEnum::Comment("if statement".to_string()));
                expression_solver(condition, &mut current_context);
                current_context.add_asm(ASMConvEnum::CMP("ax".to_string(),1.to_string()));
                let cli = current_context.logic_index;
                current_context.add_asm(ASMConvEnum::JNE(format!(".{}.L_E{}",current_context.current_function_name,cli)));
                internal_compile(if_body, current_context);
                if else_body.is_some(){
                    current_context.add_asm(ASMConvEnum::JMP(format!(".{}.L_EE{}",current_context.current_function_name,current_context.logic_index + 1)));
                }
                current_context.add_asm(ASMConvEnum::Label(format!(".{}.L_E{}",current_context.current_function_name,cli)));
                current_context.logic_index+=1;
                let li = current_context.logic_index;
                if let Some(else_body) = else_body {
                    current_context.add_asm(ASMConvEnum::Comment("else statement".to_string()));
                    internal_compile(else_body, current_context);
                    current_context.add_asm(ASMConvEnum::Label(format!(".{}.L_EE{}",current_context.current_function_name,li)));
                    current_context.logic_index+=1;
                };
                current_context.add_asm(ASMConvEnum::Comment("end if statement".to_string()));

            }
            Instruction::MacroCall{ name, arguments } =>{
                match name.as_str() {
                    "asm" => {
                        for x in arguments {
                            let mut new_buff = String::new();
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
                                        let var = current_context.get_variable_or_panic(var_name.as_str());
                                        new_buff.push_str(&format!("[bp - {}]",var.1 + var.0.size()));
                                        continue;
                                    }
                                    new_buff.push(char.clone());
                                }
                                current_context.add_asm(ASMConvEnum::ASMINSERT(new_buff.to_string()));
                            }
                        }
                    }
                    _ => {}
                }
            }
            _ => {},
        }
    }
}
fn write_result_into_var(var:&CompilerVariableType, offset:usize, name: &str, asm_instrs: &mut Vec<ASMConvEnum>){
    asm_instrs.push(ASMConvEnum::Comment(format!("assign to variable '{}'",name)));
    if var.size_per_entry() == 2 {
        asm_instrs.push(ASMConvEnum::MovFromAlpha(format!("WORD [bp - {}]",offset)));
    }else if var.size_per_entry() == 1 {
        asm_instrs.push(ASMConvEnum::MovFromAlpha(format!("BYTE [bp - {}]",offset)));
    }else {
        panic!("{:?}",var);
    }
}

fn expression_solver(tokens: &[(Tokens, (u32, u32))], current_context: &mut CompilerContext) {
    #[derive(Debug)]
    enum ExprType {
        IntLiteral { num_as_string: String },
        Variable { name: String },
        StructMemberAccess { var_name: String, size: usize, offset: usize },
        ArrayAccess { var_name: String, access_expression: Box<ExprType> },
        Operation { operation: String, left: Box<ExprType>, right: Option<Box<ExprType>> },
        FunctionCall { name: String, args: Vec<ExprType> }, // New variant for function calls
    }

    fn generate_nasm(ast: &ExprType,current_context: &mut CompilerContext) {
        match ast {
            ExprType::IntLiteral { num_as_string } => {
                // Load the integer literal into ax
                current_context.add_asm(ASMConvEnum::MovToAlpha(format!("WORD {}",num_as_string)));
            }
            ExprType::Variable { name } => {
                let var_info = &current_context.get_variable_or_panic(name);
                match var_info.0._type() {
                    CompilerVariableTypeEnum::ValueType(1) => current_context.add_asm(ASMConvEnum::MovToAlpha(format!("BYTE [bp - {}]",var_info.1))),
                    CompilerVariableTypeEnum::ValueType(2) => current_context.add_asm(ASMConvEnum::MovToAlpha(format!("WORD [bp - {}]",var_info.1))),
                    _ => todo!()
                }
            }
            ExprType::StructMemberAccess { var_name, size, offset } => {
                current_context.add_asm(ASMConvEnum::Comment(format!("load value from struct {var_name}")));
                match size {
                    1 => current_context.add_asm(ASMConvEnum::MovToAlpha(format!("BYTE [bp - {}]",offset))),
                    2 => current_context.add_asm(ASMConvEnum::MovToAlpha(format!("WORD [bp - {}]",offset))),
                    _ => todo!()
                }
            }
            ExprType::ArrayAccess { var_name, access_expression } => {
                // Get array metadata
                let var_info = &current_context.get_variable_or_panic(var_name);
                let element_size = var_info.0.size_per_entry();
                let array_offset = var_info.1;

                // Calculate index and scale it
                generate_nasm(access_expression, current_context); // Result in AX
                if element_size != 1 {
                    current_context.add_asm(ASMConvEnum::BOP("imul".to_string(), "ax".to_string(), element_size.to_string()));
                }

                // Compute element address
                current_context.add_asm(ASMConvEnum::Mov("bx".to_string(), "bp".to_string()));
                current_context.add_asm(ASMConvEnum::BOP("add".to_string(), "bx".to_string(), element_size.to_string()));
                current_context.add_asm(ASMConvEnum::BOP("sub".to_string(), "bx".to_string(), array_offset.to_string()));
                current_context.add_asm(ASMConvEnum::BOP("add".to_string(), "bx".to_string(), "ax".to_string()));

                // Load based on element size
                match element_size {
                    1 => current_context.add_asm(ASMConvEnum::MovToAlpha("BYTE [bx]".to_string())),
                    2 => current_context.add_asm(ASMConvEnum::MovToAlpha("WORD [bx]".to_string())),
                    _ => panic!("Unsupported array element size"),
                }
            }
            ExprType::Operation { operation, left, right } => {
                // Generate code for the right operand
                if let Some(right_expr) = right {
                    generate_nasm(right_expr,current_context);
                }
    
                // Push ax onto the stack to save the left operand
                current_context.add_asm(ASMConvEnum::Push("ax".to_string()));
                // Generate code for the left operand
                generate_nasm(left,current_context);
                // Pop the left operand into bx
                current_context.add_asm(ASMConvEnum::Pop("bx".to_string()));
                // Perform the operation
                match operation.as_str() {
                    "+" => current_context.add_asm(ASMConvEnum::BOP("add".to_string(),"ax".to_string(), "bx".to_string())),
                    "-" => current_context.add_asm(ASMConvEnum::BOP("sub".to_string(),"ax".to_string(), "bx".to_string())),
                    "*" => current_context.add_asm(ASMConvEnum::BOP("imul".to_string(),"ax".to_string(), "bx".to_string())),
                    "/" => {
                        current_context.add_asm(ASMConvEnum::OP("cwd".to_string())); // Sign-extend ax into dx
                        current_context.add_asm(ASMConvEnum::SOP("idiv".to_string(),"bx".to_string())); // Divide ax by bx
                    }
                    "%" => {
                        current_context.add_asm(ASMConvEnum::OP("cwd".to_string())); // Sign-extend ax into dx
                        current_context.add_asm(ASMConvEnum::SOP("idiv".to_string(),"bx".to_string())); // Divide ax by bx
                        current_context.add_asm(ASMConvEnum::Mov("ax".to_string(),"dx".to_string()));
                    }
                    "==" => {
                        current_context.add_asm(ASMConvEnum::BOP("cmp".to_string(),"ax".to_string(), "bx".to_string()));
                        current_context.add_asm(ASMConvEnum::SOP("sete".to_string(),"al".to_string())); // Set al to 1 if equal, else 0
                        current_context.add_asm(ASMConvEnum::ASMINSERT("movzx ax, al".to_string())); // Zero-extend al to ax
                    }
                    "!=" => {
                        current_context.add_asm(ASMConvEnum::BOP("cmp".to_string(),"ax".to_string(), "bx".to_string()));
                        current_context.add_asm(ASMConvEnum::SOP("setne".to_string(),"al".to_string())); // Set al to 1 if not equal, else 0
                        current_context.add_asm(ASMConvEnum::ASMINSERT("movzx ax, al".to_string())); // Zero-extend al to ax
                    }
                    ">" => {
                        current_context.add_asm(ASMConvEnum::BOP("cmp".to_string(),"ax".to_string(), "bx".to_string()));
                        current_context.add_asm(ASMConvEnum::SOP("setg".to_string(),"al".to_string())); // Set al to 1 if greater, else 0
                        current_context.add_asm(ASMConvEnum::ASMINSERT("movzx ax, al".to_string())); // Zero-extend al to ax
                    }
                    "<" => {
                        current_context.add_asm(ASMConvEnum::BOP("cmp".to_string(),"ax".to_string(), "bx".to_string()));
                        current_context.add_asm(ASMConvEnum::SOP("setl".to_string(),"al".to_string())); // Set al to 1 if less, else 0
                        current_context.add_asm(ASMConvEnum::ASMINSERT("movzx ax, al".to_string())); // Zero-extend al to ax
                    }
                    ">=" => {
                        current_context.add_asm(ASMConvEnum::BOP("cmp".to_string(),"ax".to_string(), "bx".to_string()));
                        current_context.add_asm(ASMConvEnum::SOP("setge".to_string(),"al".to_string())); // Set al to 1 if greater or equal, else 0
                        current_context.add_asm(ASMConvEnum::ASMINSERT("movzx ax, al".to_string())); // Zero-extend al to ax
                    }
                    "<=" => {
                        current_context.add_asm(ASMConvEnum::BOP("cmp".to_string(),"ax".to_string(), "bx".to_string()));
                        current_context.add_asm(ASMConvEnum::SOP("setle".to_string(),"al".to_string())); // Set al to 1 if less or equal, else 0
                        current_context.add_asm(ASMConvEnum::ASMINSERT("movzx ax, al".to_string())); // Zero-extend al to ax
                    }
                    "<<" => {
                        current_context.add_asm(ASMConvEnum::Mov("cx".to_string(), "bx".to_string()));
                        current_context.add_asm(ASMConvEnum::BOP("shl".to_string(),"ax".to_string(), "cl".to_string()));
                    }
                    // The shift right operation is already correct
                    ">>" => {
                        current_context.add_asm(ASMConvEnum::Mov("cx".to_string(), "bx".to_string()));
                        current_context.add_asm(ASMConvEnum::BOP("shr".to_string(),"ax".to_string(), "cl".to_string()));
                    }
                    _ => panic!("Unsupported operation: {}", operation),
                }
            }
            ExprType::FunctionCall { name, args } => {
                if args.len() == 1{
                    generate_nasm(&args[0],current_context);
                    current_context.add_asm(ASMConvEnum::Mov("dx".to_string(), "ax".to_string()));
                }else if args.len() != 0 {
                    todo!()
                }
                // Call the function
                //code.push_str("   push dx\n");
                current_context.add_asm(ASMConvEnum::CALL(name.to_string()));
                // Clean up the stack after the function call (remove arguments)
                //code.push_str(&format!("   add sp, {}\n", args.len() * 2)); // Assuming 2 bytes per argument
            }
        }
    }
    fn parse_expression(tokens: &[(Tokens, (u32, u32))], current_context: &mut CompilerContext) -> ExprType {
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
                            name: name_string.clone(),
                            args,
                        });
                        
                        i = arg_end + 1;
                        continue;
                    }
                    else if i + 1 < tokens.len() && tokens[i + 1].0 == Tokens::Dot {
                        let var_info = &current_context.get_variable_or_panic(name_string);
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
                        //println!("{q:?}");
                        let mut offset = var_info.1 - var_info.0.size();
                        let mut x = var_info.0.find_member(&q[0]);
                        let mut a = &current_context.declared_types[x.1.as_str()];
                        offset += x.2;
                        for i in 1..q.len() {
                            x = a.find_member(&q[i]);
                            a = &current_context.declared_types[x.1.as_str()];
                            offset += x.2;
                        }
                        offset += a.size();
                        stack.push(ExprType::StructMemberAccess {
                            var_name: name_string.to_string(),
                            offset,
                            size: a.size()
                        });
                        i += 2 * q.len() + 1;
                        continue;
                    }
                    // Push a variable onto the stack
                    
                    if let Some((_type, _)) = &current_context.get_variable(name_string) {
                        stack.push(ExprType::Variable {
                            name: name_string.to_string(),
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
                        if let ExprType::Variable { name } = stack.pop().unwrap() {
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
    let ast = parse_expression(tokens,current_context);
    generate_nasm(&ast,current_context);
}

pub fn compile(instructions: &[Instruction]){
    let mut basic_types:HashMap<String, CompilerVariableType> = HashMap::new();
    basic_types.insert("u8".to_string(), CompilerVariableType::new(CompilerVariableTypeEnum::ValueType(1), vec![]));
    basic_types.insert("u16".to_string(), CompilerVariableType::new(CompilerVariableTypeEnum::ValueType(2), vec![("lh".to_string(),"u8".to_string(),0),("uh".to_string(),"u8".to_string(),1)] ));
    basic_types.insert("u32".to_string(), CompilerVariableType::new(CompilerVariableTypeEnum::ValueType(4), vec![]));
    basic_types.insert("u64".to_string(), CompilerVariableType::new(CompilerVariableTypeEnum::ValueType(8), vec![]));
    let mut global_context = CompilerContext{loop_index: 0, asm: Vec::new(), logic_index: 0,current_function_name: String::new(), declared_types: basic_types, local_variables: OrderedHashMap::new(), stack_offset: 0};
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
                    let _type: CompilerVariableType = get_cvt(&x.1, &global_context);
                    let found_type: (&String, &CompilerVariableType) = global_context.declared_types.iter().find(|y| {_type == *y.1}).unwrap();
                    total_size += found_type.1.size();
                    members.push((x.0.to_string(),found_type.0.to_string(),offset));
                    offset += found_type.1.size();
                }
                global_context.declared_types.insert(name.to_string(), CompilerVariableType::new(CompilerVariableTypeEnum::ValueType(total_size), members));
            }
            _ => {n_instructions.push(x);},
        }
    }
    
    for x in n_instructions {
        match x {
            Instruction::CompilerHint { name, arguments } =>{
                match name.as_str() {
                    "global" =>{
                        for x in arguments {
                            if let (Tokens::Name { name_string },_) = x {
                                global_context.add_asm(ASMConvEnum::ASMINSERT(format!("global {}", name_string)));
                            }
                        }
                    },
                    _ => {}
                }
            }
            Instruction::FunctionCreation { name, return_type, arguments, body } => {
                let mut func_context = CompilerContext{asm:Vec::new(),current_function_name: name.clone(),declared_types: global_context.declared_types.clone(), local_variables:global_context.local_variables.clone(),logic_index:global_context.logic_index,loop_index:global_context.loop_index,stack_offset:global_context.stack_offset};
                // Function label
                global_context.add_asm(ASMConvEnum::Label(name.to_string()));
                global_context.add_asm(ASMConvEnum::Push(format!("bp")));
                global_context.add_asm(ASMConvEnum::Mov(format!("bp"),format!("sp")));
                let a = func_context.asm.len();
                
                func_context.current_function_name = name.clone();
                let mut offset = 0;
                if arguments.len() != 0{
                    if arguments.len() >= 1{
                        let arg = &arguments[0];
                        let cvt = get_cvt(&arg.1, &global_context);
                        func_context.local_variables.insert(arg.0.to_string(), (get_cvt(&arg.1,&global_context),offset));
                        offset += cvt.size();
                        match cvt.size() {
                            2 => {func_context.asm.push(ASMConvEnum::Mov(format!("WORD [bp - {offset}]"),"dx".to_string()));}
                            1 => {func_context.asm.push(ASMConvEnum::Mov(format!("BYTE [bp - {offset}]"),"dl".to_string()));}
                            _ => {panic!("")}
                        }
                    }
                }

                internal_compile(&body, &mut func_context);
                let var_offset = func_context.local_variables.iter().last().map_or(0, |x| x.1.1 + x.1.0.size());
                //println!("{}",var_offset);
                func_context.asm.insert(a,ASMConvEnum::BOP("sub".to_string(),"sp".to_string(),var_offset.to_string()));
                global_context.loop_index = func_context.loop_index;
                global_context.logic_index = func_context.logic_index;
                if return_type == &ParserVariableType::Void{
                    func_context.asm.push(ASMConvEnum::BOP("xor".to_string(),"ax".to_string(),"ax".to_string()));
                }
                func_context.asm.push(ASMConvEnum::Label(format!(".exit_{}", name)));
                // Function prologue
                if name == "main"{
                    func_context.asm.push(ASMConvEnum::OP(format!("cli")));
                    func_context.asm.push(ASMConvEnum::OP(format!("hlt")));
                }else {
                    func_context.asm.push(ASMConvEnum::Mov(format!("sp"),format!("bp")));
                    func_context.asm.push(ASMConvEnum::Pop(format!("bp")));
                    func_context.asm.push(ASMConvEnum::OP(format!("ret")));
                }
                for i in func_context.asm {
                    global_context.add_asm(i);
                }
                

            },

            _ => todo!("{:?}",x),
        }
        println!("{:?}",global_context.asm);
        let mut labels = HashMap::new(); 
        let mut used_labels = HashSet::new(); 
        for i in 0..global_context.asm.len() {
            let x = &global_context.asm[i];
            match x {
                ASMConvEnum::Label(x) => {labels.insert(x,i);},
                ASMConvEnum::JMP(x) => {used_labels.insert(x);},
                ASMConvEnum::JE(x) => {used_labels.insert(x);},
                ASMConvEnum::JNE(x) => {used_labels.insert(x);},
                ASMConvEnum::CALL(x) => {used_labels.insert(x);},
                _ => {}
            }
        }
        println!("{labels:?}");
        println!("{used_labels:?}");
        let mut fs = File::create("./main.asm").unwrap();
        for x in &global_context.asm {
            match x {
                ASMConvEnum::Label(x) => _ = fs.write(format!("{}:\n",x).as_bytes()).unwrap(),
                ASMConvEnum::Comment(x) => _ = fs.write(format!("   ;{}\n",x).as_bytes()).unwrap(),
                ASMConvEnum::Mov(x,y) => _ = fs.write(format!("   mov {}, {}\n",x,y).as_bytes()).unwrap(),
                ASMConvEnum::OP(x) => _ = fs.write(format!("   {}\n",x).as_bytes()).unwrap(),
                ASMConvEnum::Pop(x) => _ = fs.write(format!("   pop {}\n",x).as_bytes()).unwrap(),
                ASMConvEnum::Push(x) => _ = fs.write(format!("   push {}\n",x).as_bytes()).unwrap(),
                ASMConvEnum::JMP(x) => _ = fs.write(format!("   jmp {}\n",x).as_bytes()).unwrap(),
                ASMConvEnum::JNE(x) => _ = fs.write(format!("   jne {}\n",x).as_bytes()).unwrap(),
                ASMConvEnum::JE(x) => _ = fs.write(format!("   je {}\n",x).as_bytes()).unwrap(),
                ASMConvEnum::CALL(x) => _ = fs.write(format!("   call {}\n",x).as_bytes()).unwrap(), 
                ASMConvEnum::ASMINSERT(x) => _ = fs.write(format!("   {}\n",x).as_bytes()).unwrap(), 
                ASMConvEnum::BOP(op,x,y) => _ = fs.write(format!("   {op} {x}, {y}\n").as_bytes()).unwrap(),
                ASMConvEnum::SOP(op,x) => _ = fs.write(format!("   {op} {x}\n").as_bytes()).unwrap(),
                ASMConvEnum::CMP(x,y) => _ = fs.write(format!("   cmp {x},{y}\n").as_bytes()).unwrap(),
                ASMConvEnum::MovFromAlpha(x) =>{
                    if x.starts_with("WORD") {
                        fs.write(format!("   mov {}, ax\n",x).as_bytes()).unwrap();
                    }else if x.starts_with("BYTE") {
                        fs.write(format!("   mov {}, al\n",x).as_bytes()).unwrap();
                    }else {
                        panic!("You moron")
                    }
                }
                ASMConvEnum::MovToAlpha(x) =>{
                    if x.starts_with("WORD") {
                        fs.write(format!("   mov ax, {}\n",x).as_bytes()).unwrap();
                    }else if x.starts_with("BYTE") {
                        fs.write(format!("   movzx ax, {}\n",x).as_bytes()).unwrap();
                    }else {
                        panic!("You moron {}",x);
                    }
                }
            }
        }
    }
}