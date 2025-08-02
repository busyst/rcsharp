use crate::{expression_parser::{parse_expression, Expr}, sub_parsers::{parse_function, parse_hint}, token::{Token, TokenData}};
#[derive(Debug, Clone, PartialEq)]
pub enum Stmt {
    Hint(String, Vec<Expr>), // #[...]
    Expr(Expr), // a = 1 + b
    Let(String, ParserType), // let x : ...
    Return(Option<Expr>), // return 0
    Block(Vec<Stmt>), // { ... }
    If(Expr, Box<Stmt>, Option<Box<Stmt>>), // if 1 == 1 {} `else `if` {}`
    Loop(Box<Stmt>), // loop { ... }
    Break, // break
    Continue, // continue
    DirectInsertion(String), // continue
    Function(String, Vec<(String, ParserType)>, ParserType, Box<Stmt>), // fn foo(bar: i8, ...) { ... }
    Struct(String, Vec<(String, ParserType)>), // struct foo { bar : i8, ... }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum ParserType {
    Named(String),
    Ref(Box<ParserType>),
    // return type, arguments
    Fucntion(Box<ParserType>,Vec<ParserType>),
    // Name Fields
    Structure(String,Vec<(String,ParserType)>),
}
#[allow(dead_code)]
impl ParserType {
    pub fn is_simple_type(&self) -> bool {
        if let ParserType::Named(name) = self {
            matches!(name.as_str(),
                "bool" |
                "i8" | "u8" | "i16" | "u16" | "i32" | "u32" | "i64" | "u64" |
                "f32" | "f64"
            )
        } else {
            false
        }
    }

    pub fn is_integer(&self) -> bool {
        if let ParserType::Named(name) = self {
            matches!(name.as_str(), "i8" | "u8" | "i16" | "u16" | "i32" | "u32" | "i64" | "u64")
        } else {
            false
        }
    }
    pub fn is_unsigned_integer(&self) -> bool {
        if let ParserType::Named(name) = self {
            matches!(name.as_str(), "u8" | "u16" | "u32" | "u64" )
        } else {
            false
        }
    }
    
    pub fn is_signed_integer(&self) -> bool {
        if let ParserType::Named(name) = self {
            matches!(name.as_str(), "i8" | "i16" | "i32" | "i64" )
        } else {
            false
        }
    }
    pub fn is_float(&self) -> bool {
        if let ParserType::Named(name) = self {
            matches!(name.as_str(), "f32" | "f64")
        } else {
            false
        }
    }
    pub fn is_void(&self) -> bool {
        if let ParserType::Named(name) = self {
            matches!(name.as_str(), "void")
        } else {
            false
        }
    }
    pub fn to_string(&self) -> String{
        let mut output = String::new();
        match self {
            ParserType::Named(x) => output.push_str(x),
            ParserType::Ref(x) => {output.push_str(&x.to_string()); output.push('*');},
            ParserType::Fucntion(_, _) => {todo!()},
            ParserType::Structure(name, _) => {output.push_str(&format!("%struct.{}", name));},
        }
        return output;
    }
    pub fn to_string_core(&self) -> String{
        let mut output = String::new();
        match self {
            ParserType::Named(x) => output.push_str(x),
            ParserType::Ref(x) => {return x.to_string_core();},
            ParserType::Fucntion(_, _) => {todo!()},
            ParserType::Structure(name, _) => {output.push_str(&name);},
        }
        return output;
    }
    pub fn is_pointer(&self) -> bool{
        match self {
            ParserType::Named(_) => false,
            ParserType::Ref(_) => true,
            ParserType::Fucntion(_, _) => {todo!()},
            ParserType::Structure(_, _) => {todo!()},
        }
    }
    pub fn dereference_once(&self) -> ParserType{
        match self {
            ParserType::Named(_) => panic!("ParserType is Named {:?} that is not dereferencable", self),
            ParserType::Ref(x) => return *x.clone(),
            ParserType::Fucntion(_, _) => {todo!()},
            ParserType::Structure(_, _) => {todo!()},
        }
    }
    pub fn reference_once(&self) -> ParserType{
        ParserType::Ref(Box::new(self.clone()))
    }
}
fn capture_until_tokens<'a>(tokens: &'a [TokenData], delimiters: &[Token]) -> &'a [TokenData] {
    if let Some(pos) = tokens.iter().position(|td| delimiters.contains(&td.token)) {
        &tokens[..pos]
    } else {
        &[]
    }
}
pub fn capture_until_tokens_or_end<'a>(tokens: &'a [TokenData], delimiters: &[Token]) -> &'a [TokenData] {
    if let Some(pos) = tokens.iter().position(|td| delimiters.contains(&td.token)) {
        &tokens[..pos]
    } else {
        tokens
    }
}
pub fn capture_until_token_or_end<'a>(tokens: &'a [TokenData], delimiter: &Token) -> &'a [TokenData] {
    if let Some(pos) = tokens.iter().position(|td| &td.token == delimiter) {
        &tokens[..pos]
    } else {
        tokens
    }
}

pub fn capture_delimiters<'a>(
    tokens: &'a [TokenData],
    left: Token,
    right: Token,
) -> Result<&'a [TokenData], String> {
    fn token_to_str(token: &Token) -> String {
        match token {
            Token::LParen => "(".to_string(),
            Token::RParen => ")".to_string(),
            Token::LBrace => "{".to_string(),
            Token::RBrace => "}".to_string(),
            Token::LSquareBrace => "[".to_string(),
            Token::RSquareBrace => "]".to_string(),
            // Fallback to debug representation for other tokens
            _ => format!("{:?}", token),
        }
    }
    // --- Guard Clauses: Handle initial errors cleanly ---

    if tokens.is_empty() {
        return Err(format!(
            "Expected an opening '{}' but found the end of the input.",
            token_to_str(&left)
        ));
    }

    let first_token = &tokens[0];
    if first_token.token != left {
        return Err(format!(
            "Expected an opening '{}' but found '{}' at {:?}.",
            token_to_str(&left),
            token_to_str(&first_token.token),
            first_token.loc
        ));
    }

    // --- Main Logic: Find the matching delimiter ---

    let mut balance = 1; // Start at 1, since we've already matched the first `left` token.

    // Iterate through the rest of the slice.
    for i in 1..tokens.len() {
        let current_token = &tokens[i].token;

        if *current_token == left {
            balance += 1;
        } else if *current_token == right {
            balance -= 1;
        }

        // If balance is 0, we've found our matching closing delimiter.
        if balance == 0 {
            // The content is the slice from after the opening `left`
            // up to (but not including) the closing `right`.
            return Ok(&tokens[1..i]);
        }
    }

    // If the loop finishes but balance is not 0, the opening delimiter was never closed.
    Err(format!(
        "The opening '{}' at {:?} was never closed.",
        token_to_str(&left),
        first_token.loc
    ))
}

pub fn concatenate_slices<T: Clone>(a: &[T], b: &[T]) -> Vec<T> {
    let mut result = Vec::with_capacity(a.len() + b.len());
    result.extend_from_slice(a);
    result.extend_from_slice(b);
    result
}

/// Parses a type
pub fn parse_type(tokens: &[TokenData]) -> Result<ParserType, String> {
    if tokens.is_empty() {
        return Err("Expected a type, but found end of input.".to_string());
    }
    match &tokens[0].token {
        Token::LogicAnd => {
            if tokens.len() == 1 {
                return Err(format!(
                    "Found '&&' at {:?} but no type follows.",
                    tokens[0].loc
                ));
            }
            let inner_type = parse_type(&tokens[1..])?;
            Ok(ParserType::Ref(Box::new(ParserType::Ref(Box::new(inner_type)))))
        }
        Token::BinaryAnd => {
            if tokens.len() == 1 {
                return Err(format!(
                    "Found '&' at {:?} but no type follows.",
                    tokens[0].loc
                ));
            }
            let inner_type = parse_type(&tokens[1..])?;
            Ok(ParserType::Ref(Box::new(inner_type)))
        }
        Token::Name(x) => {
            if tokens.len() > 1 {
                return Err(format!(
                    "Unexpected token {:?} after type name '{}' at {:?}.",
                    tokens[1].token, x, tokens[1].loc
                ));
            }
            Ok(ParserType::Named(x.to_string()))
        }
        other => Err(format!(
            "Expected a type name or '&' but found {:?} at {:?}",
            other, tokens[0].loc
        )),
    }
}

fn parse_statement(tokens: &[TokenData]) -> Result<(Vec<Stmt>, usize), String> {
    if tokens.is_empty() {
        return Ok((vec![], 0));
    }
    let current_token_data = &tokens[0];
    match &tokens[0].token {
        Token::KeywordVariableDeclaration => {
            let mut stmts = Vec::new();
            let mut offset = 1;

            let name_token = tokens.get(offset).ok_or("Expected variable name after 'let'")?;
            let name = if let Token::Name(name) = &name_token.token {
                name.to_string()
            } else {
                return Err(format!("Expected variable name, found {:?} at {:?}", name_token.token, name_token.loc));
            };
            offset += 1;

            let colon_token = tokens.get(offset).ok_or(format!("Expected ':' after variable name '{}'", name))?;
            colon_token.expect(&Token::Colon)?;
            offset += 1;

            let remaining_tokens = tokens.get(offset..).ok_or("Unexpected end of input after ':'")?;
            let type_tokens = capture_until_tokens_or_end(remaining_tokens, &[Token::Equal, Token::SemiColon]);
            if type_tokens.is_empty() {
                return Err(format!("Expected type definition after ':' at {:?}", colon_token.loc));
            }
            let parsed_type = parse_type(type_tokens)?;
            offset += type_tokens.len();

            stmts.push(Stmt::Let(name.clone(), parsed_type));

            if let Some(next_token) = tokens.get(offset) {
                if next_token.token == Token::Equal {
                    offset += 1; // Consume '='

                    let remaining_tokens = tokens.get(offset..).ok_or("Unexpected end of input after '='")?;
                    let value_tokens = capture_until_token_or_end(remaining_tokens, &Token::SemiColon);
                    if value_tokens.is_empty() {
                        return Err(format!("Expected expression after '=' at {:?}", next_token.loc));
                    }

                    let synthesized_lhs = [
                        TokenData { token: Token::Name(name.into()), loc: name_token.loc, span: name_token.span.clone() },
                        TokenData { token: Token::Equal, loc: next_token.loc, span: next_token.span.clone() }
                    ];
                    let full_expr_tokens = concatenate_slices(&synthesized_lhs, value_tokens);
                    stmts.push(Stmt::Expr(parse_expression(&full_expr_tokens)?));
                    offset += value_tokens.len();
                }
            }

            let semicolon_token = tokens.get(offset).ok_or("Expected ';' at end of statement")?;
            semicolon_token.expect(&Token::SemiColon)?;
            offset += 1;
            Ok((stmts, offset))
        }
        Token::KeywordIf => {
            let mut offset = 1;

            let condition_tokens = capture_until_tokens(&tokens[offset..], &[Token::LBrace]);
            if condition_tokens.is_empty() {
                return Err(format!("Expected a condition expression for 'if' statement at {:?}", tokens[0].loc));
            }
            let condition_expr = parse_expression(condition_tokens)?;
            offset += condition_tokens.len();

            let then_body_tokens = capture_delimiters(&tokens[offset..], Token::LBrace, Token::RBrace)?;
            let then_stmt = Stmt::Block(internal_rcsharp(then_body_tokens)?);
            offset += then_body_tokens.len() + 2;

            let mut else_stmt = None;
            if tokens.get(offset).map_or(false, |t| t.token == Token::KeywordElse) {
                offset += 1;
                let (mut stmts, consumed) = parse_statement(&tokens[offset..])?;
                if stmts.len() != 1 {
                    return Err(format!("'else' must be followed by a single 'if' or a block statement, but found a construct that produced {} statements.", stmts.len()));
                }
                else_stmt = Some(Box::new(stmts.pop().unwrap()));
                offset += consumed;
            }

            let final_stmt = Stmt::If(condition_expr, Box::new(then_stmt), else_stmt);
            Ok((vec![final_stmt], offset))
        }
        Token::KeywordLoop => {
            let remaining = tokens.get(1..).ok_or_else(|| format!("Expected '{{' after 'loop' at {:?}", current_token_data.loc))?;
            let body_tokens = capture_delimiters(remaining, Token::LBrace, Token::RBrace)?;
            let body_stmts = internal_rcsharp(body_tokens)?;
            let loop_stmt = Stmt::Loop(Box::new(Stmt::Block(body_stmts)));
            let consumed = 1 + body_tokens.len() + 2;
            Ok((vec![loop_stmt], consumed))
        }
        Token::KeywordReturn => {
            let remaining = tokens.get(1..).ok_or_else(|| format!("Expected ';' or expression after 'return' at {:?}", current_token_data.loc))?;
            let expr_tokens = capture_until_token_or_end(remaining, &Token::SemiColon);

            let return_stmt = if expr_tokens.is_empty() {
                Stmt::Return(None)
            } else {
                Stmt::Return(Some(parse_expression(expr_tokens)?))
            };
            
            let offset = 1 + expr_tokens.len();
            let semi_colon_token = tokens.get(offset).ok_or("Expected ';' at the end of the return statement.")?;
            semi_colon_token.expect(&Token::SemiColon)?;
            Ok((vec![return_stmt], offset + 1))
        }
        Token::KeywordBreak => {
            let semi_colon_token = tokens.get(1).ok_or_else(|| format!("Expected ';' after 'break' at {:?}", current_token_data.loc))?;
            semi_colon_token.expect(&Token::SemiColon)?;
            Ok((vec![Stmt::Break], 2))
        }
        Token::KeywordContinue => {
            let semi_colon_token = tokens.get(1).ok_or_else(|| format!("Expected ';' after 'continue' at {:?}", current_token_data.loc))?;
            semi_colon_token.expect(&Token::SemiColon)?;
            Ok((vec![Stmt::Continue], 2))
        }
        Token::LBrace => {
            let body_tokens = capture_delimiters(tokens, Token::LBrace, Token::RBrace)?;
            let stmts = internal_rcsharp(body_tokens)?;
            let block_stmt = Stmt::Block(stmts);
            let consumed = body_tokens.len() + 2;
            Ok((vec![block_stmt], consumed))
        }
        Token::KeywordStruct | Token::KeywordAs | Token::KeywordElse | Token::KeywordFunction => {
            Err(format!("Unexpected keyword {:?} inside a code block at {:?}", current_token_data.token, current_token_data.loc))
        }
        _ => {
            let expr_tokens = capture_until_token_or_end(tokens, &Token::SemiColon);
            
            /*if expr_tokens.is_empty() { // it is imposible isnt it?
                if current_token_data.token == Token::SemiColon {
                    return Ok((vec![], 1));
                }
                return Err(format!("Internal parser error: failed to parse expression at {:?}", current_token_data.loc));
            }*/
            
            let expr_stmt = Stmt::Expr(parse_expression(expr_tokens)?);
            let mut offset = expr_tokens.len();
            if tokens.get(offset).map_or(false, |t| t.token == Token::SemiColon) {
                offset += 1;
            }
            Ok((vec![expr_stmt], offset))
        }
    }
}

pub fn internal_rcsharp(x: &[TokenData]) -> Result<Vec<Stmt>, String>{
    let mut o = vec![]; 
    let mut i: usize = 0;
    while i < x.len() {
        let (mut stmts, consumed) = parse_statement(&x[i..])?;
        if consumed == 0 {
            if i < x.len() {
                return Err(format!("Parser failed to advance at token: {:?}", x[i]));
            }
            break;
        }
        o.append(&mut stmts);
        i += consumed;
    }
    Ok(o)
}
fn parse_struct(tokens: &[TokenData], statements: &mut Vec<Stmt>) -> Result<usize, String> {
    let struct_name = tokens.get(1).ok_or(format!("Expected struct name token after struct keyword {:?}", tokens[0].loc))?.expect_name_token()?;
    let fields_tokens = capture_delimiters(&tokens[2..], Token::LBrace, Token::RBrace)?;
    let fields = fields_tokens.split(|x| x.token == Token::Comma).filter(|x| x.len() != 0);
    let mut struct_fields = vec![];
    //println!("Struct {} at {:?}", struct_name,  tokens[0].loc);
    for field in fields {
        let name = field.first().unwrap().expect_name_token()?;
        field.get(1).ok_or("Expected \':\' after name of field")?.expect(&Token::Colon)?;
        let field_type = parse_type(&field[2..])?;
        //println!("  {:?} : {:?}", name, field_type);
        struct_fields.push((name,field_type));
    }
    statements.push(Stmt::Struct(struct_name, struct_fields));
    return Ok(fields_tokens.len() + 4);
}

pub fn rcsharp_parser(x: &[TokenData]) -> Result<Vec<Stmt>, String> {
    let mut o = vec![];
    let mut i: usize = 0;
    while i < x.len() { // General parsing
        match &x[i].token {
            Token::Hint => { // #[...]
                i += parse_hint(&x[i..], &mut o)?;
            }
            Token::KeywordFunction => { // fn foo(...){...}
                i += parse_function(&x[i..], &mut o)?;
            }
            Token::KeywordStruct => { // struct bar{a:i8,...}
                i += parse_struct(&x[i..], &mut o)?;
            }
            _ => {
                return Err(format!(
                    "Unexpected token {:?} at {:?} in top-level scope. Only functions and hints are allowed.",
                    x[i].token, x[i].loc
                ));
            }
        }
    }
    Ok(o)
}
