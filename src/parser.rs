use crate::{expression_parser::{parse_expression, Expr}, token::{Token, TokenData}};


#[derive(Debug, Clone, PartialEq)]
pub enum Stmt {
    Hint(String, Vec<Expr>),
    Expr(Expr),
    Let(String, ParserType),
    Return(Option<Expr>),
    Block(Vec<Stmt>),
    If(Expr, Box<Stmt>, Option<Box<Stmt>>),
    Loop(Box<Stmt>),
    Break,
    Continue,
    Function(String, Vec<(String, ParserType)>, ParserType, Box<Stmt>),
}
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum ParserType {
    Named(String),
    Ref(Box<ParserType>),
}

fn capture_until_tokens<'a>(tokens: &'a [TokenData], delimiters: &[Token]) -> &'a [TokenData] {
    if let Some(pos) = tokens.iter().position(|td| delimiters.contains(&td.token)) {
        &tokens[..pos]
    } else {
        &[]
    }
}

fn capture_until_token_or_end<'a>(tokens: &'a [TokenData], delimiter: &Token) -> &'a [TokenData] {
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

fn concatenate_slices<T: Clone>(a: &[T], b: &[T]) -> Vec<T> {
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
        Token::KeywordVariable => {
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
            expect(colon_token, &Token::Colon)?;
            offset += 1;

            let remaining_tokens = tokens.get(offset..).ok_or("Unexpected end of input after ':'")?;
            let type_tokens = capture_until_tokens(remaining_tokens, &[Token::Equal, Token::SemiColon]);
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
            expect(semicolon_token, &Token::SemiColon)?;
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
            expect(semi_colon_token, &Token::SemiColon)?;
            Ok((vec![return_stmt], offset + 1))
        }
        Token::KeywordBreak => {
            let semi_colon_token = tokens.get(1).ok_or_else(|| format!("Expected ';' after 'break' at {:?}", current_token_data.loc))?;
            expect(semi_colon_token, &Token::SemiColon)?;
            Ok((vec![Stmt::Break], 2))
        }
        Token::KeywordContinue => {
            let semi_colon_token = tokens.get(1).ok_or_else(|| format!("Expected ';' after 'continue' at {:?}", current_token_data.loc))?;
            expect(semi_colon_token, &Token::SemiColon)?;
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
            
            if expr_tokens.is_empty() {
                if current_token_data.token == Token::SemiColon {
                    return Ok((vec![], 1));
                }
                return Err(format!("Internal parser error: failed to parse expression at {:?}", current_token_data.loc));
            }
            
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


pub fn expect(token: &TokenData, expected: &Token) -> Result<(), String>{
    if token.token != *expected {
       return Err(format!("Expcted {:?}, got {:?}", expected, token)); 
    }
    Ok(())
}
pub fn expect_or(token: &TokenData, expected: &[Token]) -> Result<(), String>{
    if !expected.iter().any(|x| *x == token.token) {
       return Err(format!("Expcted {:?}, got {:?}", expected, token)); 
    }
    Ok(())
}

fn parse_arguments(tokens: &[TokenData]) -> Result<Vec<(String, ParserType)>, String> {
    let mut args = vec![];
    for arg_tokens in tokens.split(|x| x.token == Token::Comma) {
        if arg_tokens.is_empty() {
            continue;
        }
        let mut parts = arg_tokens.split(|x| x.token == Token::Colon);

        let name_part = parts.next().ok_or_else(|| "Expected argument name.".to_string())?;
        if name_part.len() != 1 {
            return Err(format!("Expected a single token for argument name, found {:?}", name_part));
        }
        let name = if let Token::Name(name) = &name_part[0].token {
            name.to_string()
        } else {
            return Err(format!("Expected a name for an argument, got {:?} at {:?}", name_part[0].token, name_part[0].loc));
        };

        let type_part = parts.next().ok_or_else(|| format!("Expected type for argument '{}'", name))?;
        if type_part.is_empty() {
            return Err(format!("Expected type for argument '{}' but found none.", name));
        }
        let arg_type = parse_type(type_part)?;

        args.push((name, arg_type));
    }
    Ok(args)
}

/// Parses a hint attribute (e.g. `#[DllImport(\"user32\")]`)
fn parse_hint(tokens: &[TokenData], statements: &mut Vec<Stmt>) -> Result<usize, String> {
    let mut offset = 1; // Past '#'
    let lsq_brace = tokens.get(offset).ok_or("Expected '[' after '#'")?;
    expect(lsq_brace, &Token::LSquareBrace)?;

    let hint_slice = tokens.get(offset..).ok_or("Unexpected end of input during hint parsing")?;
    let captured_square_braces = capture_delimiters(hint_slice, Token::LSquareBrace, Token::RSquareBrace)?;
    offset += captured_square_braces.len() + 2;

    if captured_square_braces.is_empty() {
        return Err(format!("Hint at {:?} is empty", tokens[0].loc));
    }

    for hint in captured_square_braces.split(|x| x.token == Token::Comma) {
        if hint.is_empty() { continue; }

        if let Token::Name(name) = &hint[0].token {
            let mut args = vec![];
            if hint.get(1).map_or(false, |tok| tok.token == Token::LParen) {
                let paren_slice = hint.get(1..).ok_or("Internal hint parsing error")?;
                let captured_in_parens = capture_delimiters(paren_slice, Token::LParen, Token::RParen)?;
                for arg in captured_in_parens.split(|x| x.token == Token::Comma) {
                    if !arg.is_empty() {
                         args.push(parse_expression(arg)?);
                    }
                }
            }
            statements.push(Stmt::Hint(name.to_string(), args));
        } else {
            return Err(format!("Expected a name for a hint, but got {:?} at {:?}", hint[0].token, hint[0].loc));
        }
    }
    Ok(offset)
}

/// Parses a function definition
fn parse_function(tokens: &[TokenData], statements: &mut Vec<Stmt>) -> Result<usize, String> {
    let mut offset = 1;
    let name = if let Some(Token::Name(name)) = tokens.get(offset).map(|td| &td.token) {
        name.to_string()
    } else {
        return Err(format!("Expected function name after 'fn' keyword at {:?}", tokens[0].loc));
    };
    offset += 1;

    let arg_slice = tokens.get(offset..).ok_or("Unexpected end of input after function name")?;
    let captured_argument_tokens = capture_delimiters(arg_slice, Token::LParen, Token::RParen)?;
    let arguments = parse_arguments(captured_argument_tokens)?;
    offset += captured_argument_tokens.len() + 2;

    let (return_type, return_type_len) = if let Some(tok) = tokens.get(offset) {
        if tok.token == Token::Colon {
            let type_slice = tokens.get(offset + 1..).ok_or("Unexpected end of input after ':' for return type")?;
            let type_tokens = capture_until_tokens(type_slice, &[Token::LBrace, Token::SemiColon]);
            if type_tokens.is_empty() { return Err(format!("Expected return type after ':' at {:?}", tok.loc)); }
            (parse_type(type_tokens)?, type_tokens.len() + 1)
        } else {
            (ParserType::Named("void".to_string()), 0)
        }
    } else {
        (ParserType::Named("void".to_string()), 0)
    };
    offset += return_type_len;
    
    let body_start_token = tokens.get(offset).ok_or("Expected function body or ';' after function signature")?;
    expect_or(body_start_token, &[Token::LBrace, Token::SemiColon])?;

    let (body_stmts, body_len) = if body_start_token.token == Token::LBrace {
        let body_slice = tokens.get(offset..).ok_or("Unexpected end of input when parsing function body")?;
        let body_tokens = capture_delimiters(body_slice, Token::LBrace, Token::RBrace)?;
        (internal_rcsharp(body_tokens)?, body_tokens.len() + 2)
    } else {
        (Vec::new(), 1)
    };
    offset += body_len;

    statements.push(Stmt::Function(name, arguments, return_type, Box::new(Stmt::Block(body_stmts))));
    Ok(offset)
}

pub fn rcsharp(x: &[TokenData]) -> Result<Vec<Stmt>, String> {
    let mut o = vec![];
    let mut i: usize = 0;
    while i < x.len() {
        match &x[i].token {
            Token::Hint => {
                i += parse_hint(&x[i..], &mut o)?;
            }
            Token::KeywordFunction => {
                i += parse_function(&x[i..], &mut o)?;
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