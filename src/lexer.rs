use std::{collections::HashMap, fs::File, io::Read};

use crate::tokens::Tokens;

pub fn lex(file_path: &str) -> Result<Vec<(Tokens,(u32,u32))>, String> {
    let mut keyword = HashMap::new();
    keyword.insert("fn", Tokens::FnKeyword);
    keyword.insert("let", Tokens::CreateVariableKeyword);
    keyword.insert("loop", Tokens::LoopKeyword);
    keyword.insert("if", Tokens::IfKeyword);
    keyword.insert("else", Tokens::ElseKeyword);
    keyword.insert("break", Tokens::BreakKeyword);
    keyword.insert("continue", Tokens::ContinueKeyword);
    keyword.insert("return", Tokens::ReturnKeyword);
    
    let mut x = HashMap::new();
    x.insert('(', Tokens::LParen);
    x.insert(')', Tokens::RParen);
    x.insert('{', Tokens::LBrace);
    x.insert('}', Tokens::RBrace);
    x.insert('[', Tokens::LSQBrace);
    x.insert(']', Tokens::RSQBrace);
    x.insert(':', Tokens::Colon);
    x.insert(';', Tokens::Semicolon);
    x.insert(',', Tokens::Comma);
    x.insert('.', Tokens::Dot);
    
    let mut str = String::new();
    let mut a = File::open(file_path).unwrap();
    a.read_to_string(&mut str).unwrap();
    let chars: Vec<char> = str.chars().collect();

    let mut line = 0;
    let mut line_index_start = 0;
    let mut i = 0;
    
    let mut vec: Vec<(Tokens,(u32,u32))> = vec![];
    while i < chars.len() {
        match chars[i] {
            '\0' => break,
            ' ' | '\t' | '\r' => { i += 1; }
            '\n' => { 
                i += 1; 
                line += 1; 
                line_index_start = i; 
            }
            '=' => {
                i += 1;
                if i < chars.len() && chars[i] == '=' {
                    vec.push((Tokens::COMPEqual, ((i - 1 - line_index_start) as u32, line)));
                    i += 1;
                }else {
                    vec.push((Tokens::Equal, ((i - 1 - line_index_start) as u32, line)));
                }
                
            }
            '>' => {
                i += 1;
                if i < chars.len() && chars[i] == '=' {
                    vec.push((Tokens::COMPEqualGreater, ((i - 1 - line_index_start) as u32, line)));
                    i += 1;
                }else {
                    vec.push((Tokens::COMPGreater, ((i - 1 - line_index_start) as u32, line)));
                }
            }
            '<' => {
                i += 1;
                if i < chars.len() && chars[i] == '=' {
                    vec.push((Tokens::COMPEqualLess, ((i - 1 - line_index_start) as u32, line)));
                    i += 1;
                }else {
                    vec.push((Tokens::COMPLess, ((i - 1 - line_index_start) as u32, line)));
                }
            }
            '!' => {
                i += 1;
                if i < chars.len() && chars[i] == '=' {
                    vec.push((Tokens::COMPNOTEqual, ((i - 1 - line_index_start) as u32, line)));
                    i += 1;
                    continue;
                }
                vec.push((Tokens::ExclamationMark, ((i - 1 - line_index_start) as u32, line)));
                //vec.push((Tokens::Equal, ((i - 1 - line_index_start) as u32, line)));
            }
            '+' => {
                i += 1;
                if i < chars.len() && chars[i] == '=' {
                    vec.push((Tokens::ADDEqual, ((i - 1 - line_index_start) as u32, line)));
                    i += 1;
                } else {
                    vec.push((Tokens::ADD, ((i - 1 - line_index_start) as u32, line)));
                }
            }
            '-' => {
                i += 1;
                if i < chars.len() && chars[i] == '=' {
                    vec.push((Tokens::SUBEqual, ((i - 1 - line_index_start) as u32, line)));
                    i += 1;
                } else if i < chars.len() && chars[i] == '>' {
                    vec.push((Tokens::Pointer, ((i - 1 - line_index_start) as u32, line)));
                    i += 1;
                } else {
                    vec.push((Tokens::SUB, ((i - 1 - line_index_start) as u32, line)));
                }
            }
            '*' => {
                i += 1;
                if i < chars.len() && chars[i] == '=' {
                    vec.push((Tokens::MULEqual, ((i - 1 - line_index_start) as u32, line)));
                    i += 1;
                } else {
                    vec.push((Tokens::MUL, ((i - 1 - line_index_start) as u32, line)));
                }
            }
            '/' => {
                i += 1;
                if i < chars.len() && chars[i] == '=' {
                    vec.push((Tokens::DIVEqual, ((i - 1 - line_index_start) as u32, line)));
                    i += 1;
                } else if i < chars.len() && chars[i] == '/' {
                    loop {
                        if i >= chars.len() {
                            break;
                        }else if chars[i] == '\n' {
                            break;
                        }
                        
                        i+=1;
                    }
                }
                 else {
                    vec.push((Tokens::DIV, ((i - 1 - line_index_start) as u32, line)));
                }
            }
            '%' => {
                i += 1;
                if i < chars.len() && chars[i] == '=' {
                    vec.push((Tokens::MODEqual, ((i - 1 - line_index_start) as u32, line)));
                    i += 1;
                } else {
                    vec.push((Tokens::MOD, ((i - 1 - line_index_start) as u32, line)));
                }
            }
            '"' => {
                let mut string_content = Box::new(String::new());
                loop {
                    i+=1;
                    if i >= chars.len() {
                        break;
                    }else if chars[i] == '"' {
                        i+=1;
                        break;
                    }
                    string_content.push(chars[i]);
                }
                vec.push((Tokens::String { string_content }, ((i - 1 - line_index_start) as u32, line)));
            }
            c => {
                if let Some(token) = x.get(&c) {
                    vec.push((token.clone(), ((i - line_index_start) as u32, line)));
                    i += 1;
                } else if c.is_alphabetic() {
                    let start_pos = i - line_index_start;
                    let mut word = String::new();
                    word.push(c);
                    i += 1;
                    
                    while i < chars.len() && (chars[i].is_alphanumeric() || chars[i] == '_') {
                        word.push(chars[i]);
                        i += 1;
                    }
                    if let Some(token) = keyword.get(word.as_str()) {
                        vec.push((token.clone(), (start_pos as u32, line)));
                    } else {
                        vec.push((Tokens::Name { name_string: Box::new(word) }, (start_pos as u32, line)));
                    }
                } else if c.is_numeric() || (c == '0' && i + 1 < chars.len() && (chars[i + 1] == 'x' || chars[i + 1] == 'b')) {
                    let start_pos = i - line_index_start;
                    let mut number = String::new();
                    number.push(c);
                    i += 1;
                    
                    // If we encounter a '0' followed by 'x' or 'b', handle hexadecimal or binary numbers
                    if c == '0' && (chars[i] == 'x' || chars[i] == 'b') {
                        number.push(chars[i]);
                        i += 1;
                
                        // Now, collect the actual digits for the number (hex or binary)
                        while i < chars.len() {
                            if chars[i].is_digit(16) || (chars[i] == 'a' || chars[i] == 'A' || chars[i] == 'f' || chars[i] == 'F') {
                                // For hex values, we allow 0-9, a-f, A-F
                                number.push(chars[i]);
                            } else if chars[i].is_digit(2) {
                                // For binary, we only allow 0 or 1
                                number.push(chars[i]);
                            } else {
                                break;
                            }
                            i += 1;
                        }
                    } else {
                        // Normal number parsing (just for numbers not starting with '0x' or '0b')
                        while i < chars.len() {
                            if chars[i].is_numeric() && !chars[i].is_whitespace() {
                                number.push(chars[i]);
                            } else {
                                break;
                            }
                            i += 1;
                        }
                    }
                
                    vec.push((Tokens::Number { number_as_string: Box::new(number) }, (start_pos as u32, line)));
                } else {
                    todo!()
                }
            }
        }
    }    
    Ok(vec)
}