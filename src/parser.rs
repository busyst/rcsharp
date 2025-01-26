use crate::{get_type, lexer::Tokens, Instruction, RCSType};

pub fn parse(tokens: &[(Tokens,(u32,u32))]) -> Vec<Instruction> {
    let mut instructions = vec![];
    let mut i = 0;
    loop {
        let first_instruction = tokens.get(i);
        if first_instruction.is_none() { break; }
        let (first_instruction,second_instruction) = (first_instruction.unwrap(),tokens.get(i+1).unwrap_or(&(Tokens::Semicolon,(0,0))));
        //debug_print(&tokens.split_at(i).1.iter().map(|s|s.clone()).collect::<Vec<_>>());
        match (first_instruction,second_instruction) {
            ((Tokens::FnKeyword,_),(Tokens::Name { name_string },_)) =>{
                println!("{}",name_string);
                let mut arguments = vec![];
                let arguments_toks = gather_until_zero(tokens, i + 3, Tokens::LParen, Tokens::RParen, 1);
                
                println!("{:?}",arguments_toks);
                let mut s = 0;
                if arguments_toks.len()!= 0{
                    loop {  
                        if let (Tokens::Name { name_string },_) = &arguments_toks[s]{
                            if let (Tokens::Colon,_) = &arguments_toks[s + 1]{
                                let a= gather_until(&arguments_toks, s + 2, Tokens::Comma);
                                let arg_type = get_type(&a);
                                
                                println!("{:?}",arg_type);
                                arguments.push((name_string.to_string(),arg_type));
                                s += a.len() + 2;
                                if s >= arguments_toks.len(){
                                    break;
                                }
                                continue;
                            }
                        }
                        panic!("{:?}",arguments_toks)
                    }
                }

                i += arguments_toks.len();
                let return_type_toks = gather_until(tokens, i + 4, Tokens::LBrace);
                let return_type : RCSType;
                if return_type_toks.len() == 0{
                    return_type = RCSType::Void;
                }else {
                    if return_type_toks[0].0 != Tokens::Point{
                        panic!("Parser error: When declaring function with return value, use \"fn a() -> usize {{}}\" template")
                    }
                    return_type = get_type(&return_type_toks[1..return_type_toks.len()]);
                }
                i += return_type_toks.len();
                let toks = gather_until_zero(tokens,i + 5,Tokens::LBrace,Tokens::RBrace,1);
                i += toks.len() + 6;
                println!("{:?}",toks);
                let body = parse(&toks);
                instructions.push(Instruction::FunctionCreation { name: name_string.to_string(), return_type, arguments, body });

            }
            ((Tokens::IfKeyword,_),_) =>{
                let expr_toks = gather_until(tokens,i + 1,Tokens::LBrace);
                i += expr_toks.len() + 2;

                let toks = gather_until_zero(tokens,i,Tokens::LBrace,Tokens::RBrace,1);
                let if_body = parse(&toks);
                i += 1 + toks.len();
                let else_body: Option<Vec<Instruction>> =
                if i < tokens.len() && tokens[i].0 == Tokens::ElseKeyword {
                    let toks = gather_until_zero(tokens,i + 2,Tokens::LBrace,Tokens::RBrace,1);
                    i += 3 + toks.len();
                    Some(parse(&toks))
                }else{
                    None
                };
                instructions.push(Instruction::IfElse { condition: expr_toks, if_body, else_body });
            }
            ((Tokens::CreateVariableKeyword,_),(Tokens::Name { name_string },_)) =>{
                let toks = gather_until(tokens,i,Tokens::Semicolon);
                let type_tokens = gather_until(&toks,3,Tokens::Equal);

                let _type = get_type(&type_tokens);
                
                let expression = gather_until(&toks,4 + type_tokens.len(),Tokens::Semicolon);
                instructions.push(Instruction::VariableDeclaration { name: name_string.to_string(), _type, expression: parse(&expression) });
                i += toks.len() + 1;
            }
            ((Tokens::Name { name_string },_),(Tokens::LParen,_)) =>{
                let toks: Vec<(Tokens, (u32, u32))> = gather_until_zero(tokens,i + 2,Tokens::LParen,Tokens::RParen,1);
                println!("{:?}",toks);
                i += toks.len() + 4;
                instructions.push(Instruction::FunctionCall { name: name_string.to_string(), arguments: toks });

            }
            ((Tokens::ReturnKeyword,_),_) =>{
                let expression: Vec<(Tokens, (u32, u32))> = gather_until(&tokens,i + 1,Tokens::Semicolon);
                println!("{:?}",expression);
                i += expression.len() + 2;
                instructions.push(Instruction::Return { value: expression });
            }
            ((Tokens::LoopKeyword,_),(Tokens::LBrace,_)) =>{
                let toks = gather_until_zero(tokens,i + 2,Tokens::LBrace,Tokens::RBrace,1);
                i += 3 + toks.len();
                let body = parse(&toks);
                instructions.push(Instruction::Loop { body });
            }
            ((Tokens::BreakKeyword,_),x) => if x.0 != Tokens::Semicolon { panic!("Break should be followed by semicolon ';'") } else {instructions.push(Instruction::Break); i+=2;}
            ((Tokens::ContinueKeyword,_),x) => if x.0 != Tokens::Semicolon { panic!("Continue should be followed by semicolon ';'") } else {instructions.push(Instruction::Continue); i+=2;}
            _ => {
                let toks = gather_until(tokens,i,Tokens::Semicolon);
                i += toks.len() + 1;
                if toks.len() == 0{
                    println!("{:?}",first_instruction);
                    println!("{:?}",second_instruction);
                    panic!();
                }
                instructions.push(Instruction::Operation { operation: toks});
            }
        }
    }
    return instructions;
}



fn gather_until(tokens: &[(Tokens,(u32,u32))], start_from: usize, until: Tokens,) -> Vec<(Tokens, (u32, u32))> { 
    let mut x = vec![];

    let mut i = start_from;
    while i < tokens.len() {
        let current_token = &tokens[i];
        match &current_token.0 {
            _ if current_token.0 == until => {
                return x;
            }
            _ => {
                x.push(current_token.clone());
            }
        }
        i += 1;
    }

    x
}
fn gather_until_zero(tokens: &[(Tokens,(u32,u32))], start_from: usize, plus: Tokens, minus: Tokens, start_val: u32) -> Vec<(Tokens, (u32, u32))> { 
    if start_val == 0 {
        return vec![];
    }
    let mut u = start_val;
    let mut x = vec![];

    let mut i = start_from;
    while i < tokens.len() {
        let current_token = &tokens[i];
        match &current_token.0 {
            _ if current_token.0 == plus => {
                u += 1;
                x.push(current_token.clone());
            }
            _ if current_token.0 == minus => {
                u -= 1;
                if u <= 0 {
                    return x;
                }
                x.push(current_token.clone());
            }
            _ => {
                x.push(current_token.clone());
            }
        }
        i += 1;
    }

    x
}