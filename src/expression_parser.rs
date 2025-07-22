use crate::{parser::{capture_delimiters, ParserType}, token::{Token, TokenData}};

#[derive(Debug, Clone, PartialEq, Eq)] 
pub enum Expr {
    Integer(String),
    Name(String),

    BinaryOp(Box<Expr>, BinaryOp, Box<Expr>),
    UnaryOp(UnaryOp, Box<Expr>),
    Assign(Box<Expr>, Box<Expr>),
    
    Cast(Box<Expr>, ParserType),
    Member(Box<Expr>, String), 
    StringConst(String),
    Call(Box<Expr>, Vec<Expr>),
    Index(Box<Expr>, Box<Expr>),
}

#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub enum BinaryOp {
    Add, Subtract, Multiply, Divide, Modulo,
    Equal, NotEqual, Less, LessEqual, Greater, GreaterEqual,
    And, Or, BitAnd, BitOr, BitXor, ShiftLeft, ShiftRight,
}
#[derive(Debug, Clone, PartialEq, Eq, Hash)]
pub enum UnaryOp { // Prefix
    Negate, Not, Deref, Ref,
}

pub fn precedence(x: &Token) -> usize {
    match x {
        Token::Dot => 15, // Correctly high precedence for member access

        Token::KeywordAs => 14,

        Token::LogicNot => 13,
        
        Token::Multiply => 13,
        Token::Divide => 13,
        Token::Modulo => 13,
        
        Token::Plus => 12,
        Token::Minus => 12,
        
        Token::BinaryShiftL => 11,
        Token::BinaryShiftR => 11,
        
        Token::BinaryAnd => 8,
        
        Token::BinaryXor => 7,
        
        Token::BinaryOr => 6,
        
        Token::LogicLess => 9,
        Token::LogicLessEqual => 9,
        Token::LogicGreater => 9,
        Token::LogicGreaterEqual => 9,
        
        Token::LogicEqual => 8,
        Token::LogicNotEqual => 8,
        
        Token::LogicAnd => 5,
        
        Token::LogicOr => 4,
        
        Token::Equal => 1,
        
        _ => 0,
    }
}
pub fn parse_type_expression(exp: &Expr) -> ParserType{
    match exp {
        Expr::Name(x) => return ParserType::Named(x.to_string()),
        Expr::UnaryOp(UnaryOp::Ref, exp) => return ParserType::Ref(Box::new(parse_type_expression(exp))),
        _ => panic!("Expresion {:?} was not expected during parsing of type", exp),
    }
}

pub fn parse_expression(x: &[TokenData]) ->  Result<Expr, String>{
    if x.is_empty() {
        return Err(format!("Expresion length is 0"));
    }
    let mut output: Vec<&Token> = vec![];
    let mut stack: Vec<&Token> = vec![];
    let mut aux: Vec<(usize, Expr)> = vec![];
    let mut i = 0;
    while i < x.len() {
        let current_token = &x[i].token;
        let next_token = x.get(i + 1).map(|x| &x.token).unwrap_or(&Token::KeywordStruct);
        match current_token {
            Token::LParen => { stack.push(current_token);}
            Token::LSquareBrace => { stack.push(current_token);}
            Token::RParen => {
                while let Some(last) = stack.last() {
                    if **last == Token::LParen {
                        break;
                    }
                    output.push(stack.pop().unwrap());
                }
                stack.pop();
            }
            Token::RSquareBrace => {
                while let Some(last) = stack.last() {
                    if **last == Token::LSquareBrace { break; }
                    output.push(stack.pop().unwrap());
                }
                if stack.pop().is_none() {
                    return Err("Mismatched ']' bracket.".to_string());
                }
                // Push a Dot token to act as the "index" operator in our RPN.
                output.push(&Token::IndexToken);
            }
            Token::Integer(_) => output.push(current_token),
            Token::Name(name) => {
                if *next_token == Token::LParen { // x(...
                    let arguments_tokens = capture_delimiters(&x[i + 1..], Token::LParen, Token::RParen)?;
                    let mut args = vec![];
                    if !arguments_tokens.is_empty() {
                        for arg_tokens in arguments_tokens.split(|x| x.token == Token::Comma) {
                            match parse_expression(arg_tokens) {
                                Ok(x) => args.push(x),
                                Err(x) => return Err(format!("Error while parsing argument tokens {:?} : {}", arg_tokens.iter().collect::<Vec<_>>(), x)),
                            }
                        }
                    }
                    aux.push((output.len(), Expr::Call(Box::new(Expr::Name(name.to_string())), args)));
                    output.push(&Token::DummyToken);
                    i += arguments_tokens.len() + 2; // +2 for parens, not 3
                    continue;
                }
                output.push(current_token)
            },
            _=> {
                if precedence(current_token) > 0 {
                    // Check if operator is unary (e.g., "-x", "*x", "&x").
                    let mut is_unary = false;

                    if matches!(current_token, Token::Minus | Token::Multiply | Token::BinaryAnd | Token::LogicNot) {
                        let prev_token = x.get(i.wrapping_sub(1)).map(|td| &td.token);
                        if i == 0 || prev_token.map_or(false, |t| *t == Token::LParen || *t == Token::LSquareBrace || precedence(t) > 0) {
                            is_unary = true;
                        }
                    }
                    
                    if is_unary {
                        stack.push(&Token::UnaryOpMark);
                    }
                    let current_prio = precedence(current_token);

                    let is_current_right_assoc = *current_token == Token::Equal;

                    while let Some(top) = stack.last() {
                        if **top == Token::LParen || **top == Token::LSquareBrace {
                            break;
                        }
                        
                        let top_prio = precedence(top);
                        if top_prio > 0 {
                            if (!is_current_right_assoc && current_prio <= top_prio) || (is_current_right_assoc && current_prio < top_prio) {
                                let op = stack.pop().unwrap();
                                output.push(op);
                                
                                if let Some(&&Token::UnaryOpMark) = stack.last() {
                                    output.push(stack.pop().unwrap());
                                }
                            } else {
                                break;
                            }
                        } else {
                            break;
                        }
                    }
                    stack.push(current_token);
                } else {
                    output.push(current_token);
                }
            }
        }
        i+=1;
    }
    while let Some(op) = stack.pop() {
        output.push(op);
    }
    if output.len() == 1 {
        let t = output[0];
        match t {
            Token::Name(x) => return Ok(Expr::Name(x.to_string())),
            Token::Integer(x) => return Ok(Expr::Integer(x.to_string())),
            Token::Char(x) => return Ok(Expr::Integer((x.chars().nth(0).unwrap() as u64).to_string())),
            Token::String(x) => return Ok(Expr::StringConst(x.to_string())),
            Token::DummyToken => { return Ok(aux[0].1.clone());}
            _ => todo!("This expresion is not covered by your license: {:?}", t)
        }
    }
    fn rec_tree_builder(x: &[&Token], aux: &Vec<(usize, Expr)>, absolute_operation_index_in_output_vector: &mut usize) -> Result<Expr, String> {
        println!("{:?}", x);
        if *absolute_operation_index_in_output_vector >= x.len() {
            return Err("Index out of bounds".to_string());
        }
        let mut unary = false;
        if *x[*absolute_operation_index_in_output_vector] == Token::UnaryOpMark {
            unary = true;
            if *absolute_operation_index_in_output_vector == 0 {
                return Err("Unexpected unary operator at start".to_string());
            }
            *absolute_operation_index_in_output_vector -= 1;
        }
        let op = x[*absolute_operation_index_in_output_vector];
        match op {
            Token::Name(name) => return Ok(Expr::Name(name.to_string())),
            Token::Integer(val) => return Ok(Expr::Integer(val.to_string())),
            Token::String(str) => return Ok(Expr::StringConst(str.to_string())),
            Token::Char(c) => return Ok(Expr::Integer((c.chars().nth(0).unwrap() as u64).to_string())),
            Token::DummyToken => {
                for (pos, expr) in aux {
                    if *pos == *absolute_operation_index_in_output_vector {
                        return Ok(expr.clone());
                    }
                }
                return Err("DummyToken without corresponding function call".to_string());
            }
            _ => {}
        }
        if precedence(op) == 0 {
            panic!("Unexpected token in RPN stream: {:?}", op);
        }
        if *absolute_operation_index_in_output_vector == 0 {
            return Err("Not enough operands for operator".to_string());
        }
        *absolute_operation_index_in_output_vector -= 1;
        let right_op = rec_tree_builder(x, aux, absolute_operation_index_in_output_vector)?;
        if unary {
            // Handle unary operators
            let unary_op = match op {
                Token::Minus => UnaryOp::Negate,
                Token::Multiply => UnaryOp::Deref,
                Token::BinaryAnd => UnaryOp::Ref,
                Token::LogicNot => UnaryOp::Not,
                _ => return Err(format!("Unsupported unary operator: {:?}", op)),
            };
            return Ok(Expr::UnaryOp(unary_op, Box::new(right_op)));
        }
        *absolute_operation_index_in_output_vector -= 1;
        let left_op = rec_tree_builder(x, aux, absolute_operation_index_in_output_vector)?;
        
        let binary_expr = match op {
            Token::Plus => Expr::BinaryOp(Box::new(left_op), BinaryOp::Add, Box::new(right_op)),
            Token::Minus => Expr::BinaryOp(Box::new(left_op), BinaryOp::Subtract, Box::new(right_op)),
            Token::Multiply => Expr::BinaryOp(Box::new(left_op), BinaryOp::Multiply, Box::new(right_op)),
            Token::Divide => Expr::BinaryOp(Box::new(left_op), BinaryOp::Divide, Box::new(right_op)),
            Token::Modulo => Expr::BinaryOp(Box::new(left_op), BinaryOp::Modulo, Box::new(right_op)),
            Token::LogicEqual => Expr::BinaryOp(Box::new(left_op), BinaryOp::Equal, Box::new(right_op)),
            Token::LogicNotEqual => Expr::BinaryOp(Box::new(left_op), BinaryOp::NotEqual, Box::new(right_op)),
            Token::LogicLessEqual => Expr::BinaryOp(Box::new(left_op), BinaryOp::LessEqual, Box::new(right_op)),
            Token::LogicLess => Expr::BinaryOp(Box::new(left_op), BinaryOp::Less, Box::new(right_op)),
            Token::LogicGreaterEqual => Expr::BinaryOp(Box::new(left_op), BinaryOp::GreaterEqual, Box::new(right_op)),
            Token::LogicGreater => Expr::BinaryOp(Box::new(left_op), BinaryOp::Greater, Box::new(right_op)),
            Token::LogicAnd => Expr::BinaryOp(Box::new(left_op), BinaryOp::And, Box::new(right_op)),
            Token::LogicOr => Expr::BinaryOp(Box::new(left_op), BinaryOp::Or, Box::new(right_op)),
            Token::BinaryAnd => Expr::BinaryOp(Box::new(left_op), BinaryOp::BitAnd, Box::new(right_op)),
            Token::BinaryOr => Expr::BinaryOp(Box::new(left_op), BinaryOp::BitOr, Box::new(right_op)),
            Token::BinaryXor => Expr::BinaryOp(Box::new(left_op), BinaryOp::BitXor, Box::new(right_op)),
            Token::BinaryShiftL => Expr::BinaryOp(Box::new(left_op), BinaryOp::ShiftLeft, Box::new(right_op)),
            Token::BinaryShiftR => Expr::BinaryOp(Box::new(left_op), BinaryOp::ShiftRight, Box::new(right_op)),
            Token::Equal => Expr::Assign(Box::new(left_op), Box::new(right_op)),
            Token::KeywordAs => Expr::Cast(Box::new(left_op), parse_type_expression(&right_op)),
            Token::IndexToken => Expr::Index(Box::new(left_op), Box::new(right_op)),
            Token::Dot => {
                if let Expr::Name(member_name) = right_op {
                    Expr::Member(Box::new(left_op), member_name)
                } else {
                    return Err(format!("Expected a member name after '.', but found expression {:?}", right_op));
                }
            },

            _ => return Err(format!("Unsupported binary operator: {:?}", op)),
        };
        
        return Ok(binary_expr);
    }
    let mut i = output.len() - 1;
    let x = rec_tree_builder(&output, &aux, &mut i)?;
    return Ok(x);
}