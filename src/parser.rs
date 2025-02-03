use crate::{tokens::Tokens, Instruction};

pub fn parse(tokens: &[(Tokens,(u32,u32))]) -> Vec<Instruction> {
    let mut instructions = vec![];
    let mut i = 0;
    loop {
        let first_instruction = tokens.get(i);
        if first_instruction.is_none() { break; }
        let (first_instruction,second_instruction) = (first_instruction.unwrap(),tokens.get(i+1).unwrap_or(&(Tokens::Semicolon,(0,0))));
        //debug_print(&tokens.split_at(i).1.iter().map(|s|s.clone()).collect::<Vec<_>>());
        match (first_instruction,second_instruction) {
            ((Tokens::FnKeyword,_),(Tokens::Name { name_string: _ },_)) =>{
                let mut name = String::new();
                let mut args_tokens = vec![];
                let mut return_type_tokens = vec![];
                let mut body = vec![];
                let total = ParserFactory::new(tokens.split_at(i).1) // unoptimised for clarity reasons
                .expect(Tokens::FnKeyword).next()
                .expect_name(&mut name).next()
                .gather_with_expect(Tokens::LParen, Tokens::RParen,&mut args_tokens)
                .if_token_then(Tokens::Pointer, |x| {
                    x.next();
                    x.gather_with_expect_until(Tokens::LBrace, &mut return_type_tokens);
                    x.back();
                }).expect(Tokens::LBrace)
                .gather_with_expect(Tokens::LBrace, Tokens::RBrace,&mut body)
                .total_tokens();
                let mut arguments = vec![];
                if args_tokens.len() != 0{
                    let mut i = 0;
                    loop {
                        if i >= args_tokens.len(){
                            break;
                        }
                        let mut name = String::new();
                        let mut type_tokens = vec![];
                        i += ParserFactory::new(&args_tokens.split_at(i).1)
                        .expect_name(&mut name).next()
                        .expect(Tokens::Colon).next()
                        .gather_with_expect_until_and_zero(Tokens::Comma, Tokens::LParen,Tokens::RParen, &mut type_tokens).total_tokens();
                        arguments.push((name,get_type(&type_tokens)));
                    }
                }
                let return_type : ParserVariableType = if return_type_tokens.len() == 0{
                    ParserVariableType::Void
                }else{
                    get_type(&return_type_tokens)
                };

                let body = parse(&body);

                i += total;
                instructions.push(Instruction::FunctionCreation { name, return_type, arguments, body });

            }
            ((Tokens::IfKeyword,_),_) =>{
                let mut expr_toks = vec![];
                let mut body_tokens = vec![];
                i += ParserFactory::new(tokens.split_at(i).1)
                .expect(Tokens::IfKeyword).next()
                .gather_with_expect_until(Tokens::LBrace, &mut expr_toks).back()
                .gather_with_expect(Tokens::LBrace, Tokens::RBrace, &mut body_tokens)
                .total_tokens();
                let if_body = parse(&body_tokens);
                let mut eb_i = Vec::new();
                while i < tokens.len() && tokens[i].0 == Tokens::ElseKeyword  {
                    if i + 1 < tokens.len() && tokens[i + 1].0 == Tokens::IfKeyword {
                        let mut expr_toks = vec![];
                        let mut body_toks = vec![];
                        i += ParserFactory::new(tokens.split_at(i).1)
                        .expect(Tokens::ElseKeyword).next()
                        .expect(Tokens::IfKeyword).next()
                        .gather_with_expect_until_and_zero(Tokens::LBrace, Tokens::LParen, Tokens::RParen, &mut expr_toks).back()
                        .gather_with_expect(Tokens::LBrace, Tokens::RBrace, &mut body_toks)
                        .total_tokens();
                        eb_i.push((expr_toks, parse(&body_toks)));
                    }else {
                        let mut body = vec![];
                        i += ParserFactory::new(tokens.split_at(i).1)
                        .expect(Tokens::ElseKeyword).next()
                        .gather_with_expect(Tokens::LBrace, Tokens::RBrace, &mut body)
                        .total_tokens();
                        eb_i.push((Vec::new(),parse(&body)));
                        break;
                    }
                }
                
                let mut else_body: Option<Vec<Instruction>> = None;
                if eb_i.len() != 0 {
                    for x in eb_i.into_iter().rev() {
                        if x.0.len() == 0 {
                            else_body = Some(x.1);
                        }else {
                            else_body = Some(vec![Instruction::IfElse { condition: x.0, if_body: x.1, else_body: else_body }]);
                        }
                    }
                }
                instructions.push(Instruction::IfElse { condition: expr_toks, if_body, else_body });
            }
            ((Tokens::CreateVariableKeyword,_),(Tokens::Name { name_string: _ },_)) =>{
                
                let mut name = String::new();
                let mut type_decl_tokens = vec![];
                let mut expression = vec![];
                i+= ParserFactory::new(tokens.split_at(i).1)
                .expect(Tokens::CreateVariableKeyword).next()
                .expect_name(&mut name).next()
                .expect(Tokens::Colon).next()
                .gather_with_expect_until_with_zero_closure(&vec![Tokens::Equal,Tokens::Semicolon],&mut type_decl_tokens).back()
                .gather_with_expect_until(Tokens::Semicolon, &mut expression)
                .total_tokens();
                if expression.first().and_then(|x| Some(x.0.clone())) == Some(Tokens::Equal){
                    expression.remove(0);
                }
                println!("{:?}",type_decl_tokens);
                println!("{:?}",expression);
                let _type = get_type(&type_decl_tokens);
                instructions.push(Instruction::VariableDeclaration { name, _type, expression });
            }
            ((Tokens::Name { name_string: _ },_),(Tokens::LParen,_)) =>{
                let mut name = String::new();
                let mut arguments = vec![];
                i += ParserFactory::new(tokens.split_at(i).1)
                .expect_name(&mut name).next()
                .gather_with_expect_until_and_zero(Tokens::Semicolon,Tokens::LParen, Tokens::RParen, &mut arguments)
                .total_tokens();
                instructions.push(Instruction::FunctionCall { name, arguments });
            }
            ((Tokens::Name { name_string: _ },_),(Tokens::ExclamationMark,_)) =>{
                let mut name = String::new();
                let mut arguments = vec![];
                i += ParserFactory::new(tokens.split_at(i).1)
                .expect_name(&mut name).next()
                .expect(Tokens::ExclamationMark).next()
                .gather_with_expect_until_and_zero(Tokens::Semicolon,Tokens::LParen, Tokens::RParen, &mut arguments)
                .total_tokens();
                arguments.remove(arguments.len() - 1);
                arguments.remove(0);
                println!("{:?}",arguments);
                instructions.push(Instruction::MacroCall { name, arguments });
            }
            ((Tokens::ReturnKeyword,_),_) =>{
                let mut expression = vec![];
                i += ParserFactory::new(tokens.split_at(i).1)
                .expect(Tokens::ReturnKeyword).next()
                .gather_with_expect_until_and_zero(Tokens::Semicolon,Tokens::LParen, Tokens::RParen, &mut expression)
                .total_tokens();
                instructions.push(Instruction::Return { expression });
            }
            ((Tokens::LoopKeyword,_),(Tokens::LBrace,_)) =>{
                let mut body_tokens = vec![];
                i += ParserFactory::new(tokens.split_at(i).1)
                .expect(Tokens::LoopKeyword).next()
                .gather_with_expect(Tokens::LBrace, Tokens::RBrace, &mut body_tokens)
                .total_tokens();
                let body = parse(&body_tokens);
                instructions.push(Instruction::Loop { body });
            }
            ((Tokens::BreakKeyword,_),x) => if x.0 != Tokens::Semicolon { panic!("Break should be followed by semicolon ';'") } else {instructions.push(Instruction::Break); i+=2;}
            ((Tokens::ContinueKeyword,_),x) => if x.0 != Tokens::Semicolon { panic!("Continue should be followed by semicolon ';'") } else {instructions.push(Instruction::Continue); i+=2;}
            _ => {
                let mut expr_tokens = vec![];
                i += ParserFactory::new(tokens.split_at(i).1)
                .gather_with_expect_until_and_zero(Tokens::Semicolon,Tokens::LParen, Tokens::RParen, &mut expr_tokens)
                .total_tokens();
                instructions.push(Instruction::Operation { operation: expr_tokens });
            }
        }
    }
    return instructions;
}

#[derive(Debug, Clone, PartialEq)]
pub enum ParserVariableType {
    Void,
    Type(Box<String>),
    ArrayPointer(Box<ParserVariableType>),
    ArrayStack(Box<ParserVariableType>,usize),
    Tuple(Vec<ParserVariableType>),
}
pub struct ParserFactory<'a> {
    tokens: &'a [(Tokens, (u32, u32))],
    index: usize,
    offset: usize,
}
impl<'a> ParserFactory<'a> {
    pub fn new(tokens: &'a [(Tokens, (u32, u32))]) -> Self {
        Self { tokens, index: 0, offset: 0 }
    }
    pub fn peek(&self) -> &(Tokens, (u32, u32)) {
        if self.index + self.offset >= self.tokens.len() {
            panic!("Unexpected end of tokens");
        }
        &self.tokens[self.index + self.offset]
    }
    pub fn next(&mut self) -> &mut Self {
        if self.index + self.offset + 1 >= self.tokens.len() {
            panic!("Unexpected end of tokens");
        }
        self.offset += 1;
        self
    }
    
    pub fn back(&mut self) -> &mut Self{
        if self.offset.checked_sub(1).is_none() {
            panic!("Attempted underflow");
        }
        self.offset -= 1;
        self
    }
    pub fn expect(&mut self, expected: Tokens) -> &mut Self {
        let pos = self.index + self.offset;
        if pos >= self.tokens.len() {
            panic!("Unexpected end of tokens, expected: {:?}", expected);
        }
        
        if self.tokens[pos].0 != expected {
            panic!("Expected {:?}, found {:?}", expected, self.tokens[pos]);
        }
        self
    }
    pub fn expect_name(&mut self, name: &mut String) -> &mut Self {
        let pos = self.index + self.offset;
        if pos >= self.tokens.len() {
            panic!("Unexpected end of tokens, expected name token");
        }
        if let Tokens::Name { name_string } = &self.tokens[pos].0 {
            name.clear();
            name.push_str(&name_string);
        }else {
            panic!("Expected name, found {:?}", self.tokens[pos]);
        }
        self
    }
    pub fn if_token_then(&mut self, expected: Tokens, action: impl FnOnce(&mut Self)) -> &mut Self {
        let pos = self.index + self.offset;
        if pos >= self.tokens.len() {
            panic!("Unexpected end of tokens, expected: {:?}", expected);
        }
    
        // Check if the current token matches the expected token
        if self.tokens[pos].0 == expected {
            // If it matches, execute the provided action
            action(self);
        }
    
        // Return self for chaining
        self
    }
    pub fn gather_with_expect(&mut self,expected_plus_token: Tokens,minus_token: Tokens, token_vec: &mut Vec<(Tokens,(u32,u32))>) -> &mut Self {
        let mut score = 1;
        self.expect(expected_plus_token.clone()).next();
  
        let mut i = self.index + self.offset;
        while i < self.tokens.len() {
            let current_token = &self.tokens[i];
            match &current_token.0 {
                _ if current_token.0 == expected_plus_token => {
                    score += 1;
                    token_vec.push(current_token.clone());
                }
                _ if current_token.0 == minus_token => {
                    score -= 1;
                    if score <= 0 {
                        break;
                    }
                    token_vec.push(current_token.clone());
                }
                _ => {
                    token_vec.push(current_token.clone());
                }
            }
            i += 1;
        }
        self.offset = i - self.index + 1;
        self
    }
    pub fn gather_with_expect_until(&mut self,until: Tokens, token_vec: &mut Vec<(Tokens,(u32,u32))>) -> &mut Self {
        let mut i = self.index + self.offset;
        while i < self.tokens.len() {
            let current_token = &self.tokens[i];
            match &current_token.0 {
                _ if current_token.0 == until => {
                    break;
                }
                _ => {
                    token_vec.push(current_token.clone());
                }
            }
            i += 1;
        }
        self.offset = i - self.index + 1;
        self
    }
    pub fn gather_with_expect_until_with_zero_closure(&mut self,until: &[Tokens], token_vec: &mut Vec<(Tokens,(u32,u32))>) -> &mut Self {
        let mut x = 0;
        let mut y = 0;
        let mut z = 0;
        let mut i = self.index + self.offset;
        while i < self.tokens.len() {
            let current_token = &self.tokens[i];
            match &current_token.0 {
                _ if current_token.0 == Tokens::LParen => { x +=1; token_vec.push(current_token.clone()) },
                _ if current_token.0 == Tokens::RParen => { x -=1; token_vec.push(current_token.clone()) },
                _ if current_token.0 == Tokens::LBrace => { y +=1; token_vec.push(current_token.clone()) },
                _ if current_token.0 == Tokens::RBrace => { y -=1; token_vec.push(current_token.clone()) },
                _ if current_token.0 == Tokens::LSQBrace => { z +=1; token_vec.push(current_token.clone()) },
                _ if current_token.0 == Tokens::RSQBrace => { z -=1; token_vec.push(current_token.clone()) },
                _ if until.iter().any(|x| *x == current_token.0) && (x == 0 && y == 0 && z == 0) => {
                    break;
                }
                _ => {
                    token_vec.push(current_token.clone());
                }
            }
            i += 1;
        }
        self.offset = i - self.index + 1;
        self
    }
    pub fn gather_with_expect_until_array(&mut self,until: &[Tokens], token_vec: &mut Vec<(Tokens,(u32,u32))>) -> &mut Self {
        let mut i = self.index + self.offset;
        while i < self.tokens.len() {
            let current_token = &self.tokens[i];
            let mut _break = false;
            for x in until {
                if &current_token.0 == x{
                    _break = true;
                    break;
                }
            }
            if _break{
                break;
            }
            token_vec.push(current_token.clone());
            i += 1;
        }
        self.offset = i - self.index + 1;
        self
    }
    pub fn gather_with_expect_until_and_zero(&mut self,until: Tokens,expected_plus_token: Tokens,minus_token: Tokens, token_vec: &mut Vec<(Tokens,(u32,u32))>) -> &mut Self {
        let mut score = 0;
        
        let mut i = self.index + self.offset;
        while i < self.tokens.len() {
            let current_token = &self.tokens[i];
            match &current_token.0 {
                _ if current_token.0 == expected_plus_token => {
                    score += 1;
                    token_vec.push(current_token.clone());
                }
                _ if current_token.0 == minus_token => {
                    score -= 1;
                    token_vec.push(current_token.clone());
                }
                _ => {
                    if score ==0 && current_token.0 == until{
                        break;
                    }
                    token_vec.push(current_token.clone());
                }
            }
            i += 1;
        }
        self.offset = i - self.index + 1;
        self
    }
    pub fn total_tokens(&self) -> usize{
        self.offset
    }
}



pub fn get_type(type_tokens: &[(Tokens,(u32,u32))]) -> ParserVariableType{
    // Helper function to parse more complex inner types
    fn parse_complex_type(tokens: &[(Tokens, (u32, u32))]) -> ParserVariableType {
        // Simple type case
        if tokens.len() == 1 {
            if let Tokens::Name { name_string } = &tokens[0].0 {
                return ParserVariableType::Type(Box::new(*name_string.clone()));
            }
        }

        // Handle array type
        if let Some((Tokens::LSQBrace, _)) = tokens.first() {
            let inner_tokens = &tokens[1..tokens.len()-1];
            return ParserVariableType::ArrayPointer(Box::new(parse_complex_type(inner_tokens)));
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

            return ParserVariableType::Tuple(tuple_types);
        }

        // Nested complex types
        if tokens.len() > 1 {
            // Check for nested array or tuple
            match &tokens[0].0 {
                Tokens::Name { name_string } if **name_string == "array" => {
                    // Handle array type declaration
                    let inner_tokens = &tokens[1..];
                    return ParserVariableType::ArrayPointer(Box::new(parse_complex_type(inner_tokens)));
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

                    return ParserVariableType::Tuple(tuple_types);
                },
                _ => {}
            }
        }

        // Fallback for unrecognized type patterns
        panic!("Complex type parsing failed: {:?}", tokens);
    }

    // Helper function to parse tuple types
    fn parse_tuple_types(tokens: &[(Tokens, (u32, u32))]) -> Vec<ParserVariableType> {
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


    let _type: ParserVariableType;
    println!("{:?}",type_tokens);
    if type_tokens.first().is_none(){
        panic!("Type should be declarated!");
    }
    else{
        let x = type_tokens.first().unwrap();
        if type_tokens.len() == 1{
           if let Tokens::Name { name_string } = &x.0{
            _type = ParserVariableType::Type(Box::new(*name_string.clone()));
           }else {
            panic!("Type was not specified! Fix that! Around {:?}",type_tokens[0].1);
           }
        }else if let Tokens::LSQBrace = &x.0  {
            let inner_tokens = &type_tokens[1..type_tokens.len()-1];
            if inner_tokens.is_empty() {
                panic!("Empty array type");
            }
            if inner_tokens.len() == 3{
                if let (Tokens::Name { name_string },_) = &inner_tokens[0]{
                    if let (Tokens::Number { number_as_string },_) = &inner_tokens[2]{
                        return ParserVariableType::ArrayStack(Box::new(ParserVariableType::Type(name_string.clone())), number_as_string.to_string().parse::<usize>().unwrap());
                    }
                }
            }
            let inner_type = if inner_tokens.len() == 1 {
                if let Tokens::Name { name_string } = &inner_tokens[0].0 {
                    ParserVariableType::Type(Box::new(*name_string.clone()))
                } else {
                    panic!("Invalid array inner type")
                }
            } else {
                // More complex inner type (like tuple)
                parse_complex_type(inner_tokens)
            };
            _type = ParserVariableType::ArrayPointer(Box::new(inner_type));
        }else if let Tokens::LParen = &x.0  {
            let inner_tokens = &type_tokens[1..type_tokens.len()-1];
            if inner_tokens.is_empty() {
                panic!("Empty tuple type");
            }
            // Parse tuple inner types
            let tuple_types = parse_tuple_types(inner_tokens);
            _type = ParserVariableType::Tuple(tuple_types);
        }
        else {
            panic!("");
        }
        
    }
    _type
}

