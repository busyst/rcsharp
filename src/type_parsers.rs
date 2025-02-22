use crate::{compiler::CompilerContext, parser::ParserVariableType, tokens::Tokens};

pub fn get_type(type_tokens: &[(Tokens,(u32,u32))]) -> ParserVariableType{
    // Helper function to parse more complex inner types
    fn parse_complex_type(tokens: &[(Tokens, (u32, u32))]) -> ParserVariableType {
        // Simple type case
        if tokens.len() == 1 {
            if let Tokens::Name { name_string } = &tokens[0].0 {
                return ParserVariableType::Type(name_string.clone());
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
                Tokens::Name { name_string } if *name_string == "array" => {
                    // Handle array type declaration
                    let inner_tokens = &tokens[1..];
                    return ParserVariableType::ArrayPointer(Box::new(parse_complex_type(inner_tokens)));
                },
                Tokens::Name { name_string } if *name_string == "tuple" => {
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
    if type_tokens.first().is_none(){
        panic!("Type should be declarated!");
    }
    else{
        let x = type_tokens.first().unwrap();
        if type_tokens.len() == 1{
           if let Tokens::Name { name_string } = &x.0{
            _type = ParserVariableType::Type(name_string.clone());
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
                    ParserVariableType::Type(name_string.clone())
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

pub fn get_cvt(x:&ParserVariableType, current_context: &CompilerContext) -> CompilerVariableType{
    if let ParserVariableType::Type(x) = x{
        if let Some(x) = current_context.get_type(&x){
            return x.clone();
        }
        todo!()
    }
    if let ParserVariableType::ArrayStack(x,s) = x{
        if let ParserVariableType::Type(x) = *x.clone(){
            if let Some(x) = current_context.get_type(&x){
                return CompilerVariableType{_type: CompilerVariableTypeEnum::Array((Box::new(x._type().clone()),*s)),members:Vec::new()};
            }
            todo!()
        }
        todo!()
    }
    eprintln!("{:?}",x);
    todo!()
}
#[derive(Clone,Debug, PartialEq)]
pub enum CompilerVariableTypeEnum {
    ValueType(usize),
    Pointer(Box<CompilerVariableTypeEnum>),
    Array((Box<CompilerVariableTypeEnum>,usize)),
}
#[derive(Clone,Debug, PartialEq)]
pub struct CompilerVariableType{
    _type: CompilerVariableTypeEnum,
    members: Vec<(String,String,usize)>,
}

impl CompilerVariableType {
    pub fn new(_type: CompilerVariableTypeEnum, members: Vec<(String,String,usize)>) -> Self {
        Self { _type, members }
    }
    
    pub fn size(&self) -> usize {
        fn get_size(x: &CompilerVariableTypeEnum) -> usize{
            return match x {
                CompilerVariableTypeEnum::ValueType(s) => *s,
                CompilerVariableTypeEnum::Pointer(_) => 2,
                CompilerVariableTypeEnum::Array(s) => get_size(&s.0) * s.1,
            };
        }
        return get_size(&self._type);
    }
    pub fn size_per_entry(&self) -> usize {
        fn get_size_per_entry(x: &CompilerVariableTypeEnum) -> usize{
            return match x {
                CompilerVariableTypeEnum::Array(s) => get_size_per_entry(&s.0),
                CompilerVariableTypeEnum::ValueType(s) => *s,
                CompilerVariableTypeEnum::Pointer(_) => 2,
            };
        }
        return get_size_per_entry(&self._type);
    }
    pub fn _type(&self) -> &CompilerVariableTypeEnum {
        &self._type
    }
    pub fn find_member(&self, member_name:&str) -> &(String,String,usize) {
        if let Some(x) = self.members.iter().find(|x| x.0 == member_name) {
            return x;
        }
        panic!("Member \"{member_name}\" was not found in members of type {self:?}")
    }
}
