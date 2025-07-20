use crate::{expression_parser::parse_expression, parser::{capture_delimiters, capture_until_tokens_or_end, internal_rcsharp, parse_type, ParserType, Stmt}, token::{Token, TokenData}};

pub fn parse_arguments(tokens: &[TokenData]) -> Result<Vec<(String, ParserType)>, String> {
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
pub fn parse_hint(tokens: &[TokenData], statements: &mut Vec<Stmt>) -> Result<usize, String> {
    let mut offset = 1; // Past '#'
    let lsq_brace = tokens.get(offset).ok_or("Expected '[' after '#'")?;
    lsq_brace.expect(&Token::LSquareBrace)?;

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
pub fn parse_function(tokens: &[TokenData], statements: &mut Vec<Stmt>) -> Result<usize, String> {
    let mut offset = 1;
    let name = tokens.get(offset)
    .ok_or(&format!("Expected function name token after function keyword {:?}", tokens[0].loc))?.expect_name_token()?;

    offset += 1;

    let arg_slice = tokens.get(offset..).ok_or("Unexpected end of input after function name")?;
    let captured_argument_tokens = capture_delimiters(arg_slice, Token::LParen, Token::RParen)?;
    let arguments = parse_arguments(captured_argument_tokens)?;
    offset += captured_argument_tokens.len() + 2;

    let (return_type, return_type_len) = if let Some(tok) = tokens.get(offset) {
        if tok.token == Token::Colon {
            let type_slice = tokens.get(offset + 1..).ok_or("Unexpected end of input after ':' for return type")?;
            let type_tokens = capture_until_tokens_or_end(type_slice, &[Token::LBrace, Token::SemiColon]);
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
    body_start_token.expect_or(&[Token::LBrace, Token::SemiColon])?;

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
