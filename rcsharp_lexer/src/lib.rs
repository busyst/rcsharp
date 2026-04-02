pub mod defs;
use crate::defs::{
    DOUBLE_CHAR_TO_TOKEN, LexerError, LexerResult, SINGLE_CHAR_TO_TOKEN, Span, Symbol,
    TRIPLE_CHAR_TO_TOKEN, Token, TokenData, get_keyword,
};
use std::{
    collections::HashMap,
    fs::File,
    io::{BufRead, BufReader, Cursor, Read},
};
const ALLOWED_FILE_SIZE: u64 = 1024 * 1024 * 16; // 16 MB
const STREAM_BUFFER_CAP: usize = 8192; // 8 KB

pub struct LexerSymbolTable {
    strings: Vec<String>,
    indices: HashMap<String, Symbol>,
}
impl LexerSymbolTable {
    pub fn new() -> Self {
        Self {
            strings: Vec::new(),
            indices: HashMap::new(),
        }
    }

    pub fn get_or_intern(&mut self, s: String) -> Symbol {
        if let Some(x) = self.indices.get(&s) {
            return x.clone();
        }
        let len = Symbol::new(self.strings.len().try_into().unwrap());
        self.strings.push(s.clone());
        self.indices.insert(s, len);
        len
    }
    pub fn get(&self, s: &Symbol) -> &str {
        &self.strings[s.index()]
    }
}

pub fn lex_file(
    path: &str,
    tokens: &mut Vec<TokenData>,
    symbol_table: &mut LexerSymbolTable,
) -> LexerResult<()> {
    fn metadata_check(path: &str, file: &File) -> LexerResult<u64> {
        let metadata = file.metadata().map_err(LexerError::IoError)?;
        if metadata.is_dir() {
            return Err(LexerError::FileIsDirectory(path.to_string()));
        }
        Ok(metadata.len())
    }
    let file = File::open(path).map_err(|_| LexerError::FileNotFound(path.to_string()))?;
    let file_size = metadata_check(path, &file)?;

    let mut reader: Box<dyn BufRead> = if file_size < ALLOWED_FILE_SIZE {
        let mut content = String::new();
        let mut f = file;
        f.read_to_string(&mut content)
            .map_err(LexerError::IoError)?;
        Box::new(Cursor::new(content))
    } else {
        Box::new(BufReader::new(file))
    };

    lex_stream(&mut reader, tokens, symbol_table)?;
    //debug_lex_emit(tokens, symbol_table);
    Ok(())
}
pub fn lex_text(
    content: &str,
    tokens: &mut Vec<TokenData>,
    symbol_table: &mut LexerSymbolTable,
) -> LexerResult<()> {
    let mut reader = Box::new(Cursor::new(content));
    lex_stream(&mut reader, tokens, symbol_table)?;
    //debug_lex_emit(tokens, symbol_table);
    Ok(())
}
fn lex_stream(
    reader: &mut dyn BufRead,
    tokens: &mut Vec<TokenData>,
    symbol_table: &mut LexerSymbolTable,
) -> LexerResult<()> {
    let mut buf = Box::new([0; STREAM_BUFFER_CAP]);

    let mut global_offset = 0;
    let mut buf_write_start = 0;
    let mut input_buffer = String::with_capacity(2 * STREAM_BUFFER_CAP);
    loop {
        let n_read = reader
            .read(&mut buf[buf_write_start..])
            .map_err(LexerError::IoError)?;

        if n_read == 0 {
            while !input_buffer.is_empty() {
                let len_before = input_buffer.len();
                process_chunk(&mut input_buffer, true, tokens, symbol_table, global_offset)?;
                let len_after = input_buffer.len();
                let consumed = len_before - len_after;
                global_offset += consumed;

                if consumed == 0 {
                    if !input_buffer.is_empty() {
                        println!("Final/Residual token: {}", input_buffer);
                    }
                    break;
                }
            }
            break;
        }

        let total_bytes_in_buffer = buf_write_start + n_read;

        let valid_len = match std::str::from_utf8(&buf[..total_bytes_in_buffer]) {
            Ok(_) => total_bytes_in_buffer,
            Err(e) => {
                if let Some(_) = e.error_len() {
                    return Err(LexerError::UnexpectedEOF(
                        "Invalid UTF-8 encoding encountered".to_string(),
                    ));
                }
                e.valid_up_to()
            }
        };

        let valid_str = unsafe { std::str::from_utf8_unchecked(&buf[..valid_len]) };
        input_buffer.push_str(valid_str);

        loop {
            let len_before_process = input_buffer.len();
            process_chunk(
                &mut input_buffer,
                false,
                tokens,
                symbol_table,
                global_offset,
            )?;
            let len_after_process = input_buffer.len();
            let consumed_bytes = len_before_process - len_after_process;
            global_offset += consumed_bytes;

            if consumed_bytes == 0 {
                break;
            }
        }

        let leftovers = total_bytes_in_buffer - valid_len;
        if leftovers > 0 {
            buf.copy_within(valid_len..total_bytes_in_buffer, 0);
        }
        buf_write_start = leftovers;
    }
    Ok(())
}
fn process_chunk(
    input: &mut String,
    is_eof: bool,
    tokens: &mut Vec<TokenData>,
    symbols: &mut LexerSymbolTable,
    global_offset: usize,
) -> LexerResult<()> {
    let mut total_consumed = 0;
    loop {
        let current_input = &input[total_consumed..];
        let readonly_input = current_input.trim_start();
        let skipped_whitespace = current_input.len() - readonly_input.len();

        total_consumed += skipped_whitespace;

        if readonly_input.is_empty() {
            break;
        }

        let base_offset = global_offset + total_consumed;
        let mut consumed = 0;
        let first = readonly_input.chars().next().unwrap();

        if first.is_alphabetic() || first == '_' {
            let mut end = 0;
            for (i, c) in readonly_input.char_indices() {
                if !c.is_alphanumeric() && c != '_' {
                    end = i;
                    break;
                }
            }
            if end == 0 {
                end = readonly_input.len();
                if !is_eof {
                    break;
                }
            }
            identifier_token(
                &readonly_input[..end],
                base_offset..base_offset + end,
                tokens,
                symbols,
            );
            consumed = end;
        } else if first.is_ascii_digit()
            || (first == '-'
                && readonly_input
                    .chars()
                    .nth(1)
                    .map_or(false, |c| c.is_ascii_digit()))
        {
            let n = parse_number(readonly_input, is_eof, base_offset, tokens, symbols)?;
            if n == 0 {
                break;
            }
            consumed = n;
        } else if readonly_input.starts_with("/*") {
            if let Some(pos) = readonly_input.find("*/") {
                consumed = pos + 2;
            } else {
                if is_eof {
                    consumed = readonly_input.len();
                } else {
                    break;
                }
            }
        } else if readonly_input.starts_with("//") {
            if let Some(pos) = readonly_input.find('\n') {
                consumed = pos + 1;
            } else {
                if is_eof {
                    consumed = readonly_input.len();
                } else {
                    break;
                }
            }
        } else if first == '"' {
            let mut end = 0;
            let mut escaped = false;
            for (i, c) in readonly_input.char_indices().skip(1) {
                if escaped {
                    escaped = false;
                } else if c == '\\' {
                    escaped = true;
                } else if c == '"' {
                    end = i + 1;
                    break;
                }
            }
            if end == 0 {
                if is_eof {
                    return Err(LexerError::UnclosedString(
                        base_offset..base_offset + readonly_input.len(),
                    ));
                } else {
                    break;
                }
            }
            string_token(
                &readonly_input[1..end - 1],
                base_offset + 1..base_offset + end - 1,
                tokens,
                symbols,
            )?;
            consumed = end;
        } else if first == '\'' {
            let mut end = 0;
            let mut escaped = false;
            for (i, c) in readonly_input.char_indices().skip(1) {
                if escaped {
                    escaped = false;
                } else if c == '\\' {
                    escaped = true;
                } else if c == '\'' {
                    end = i + 1;
                    break;
                }
            }
            if end == 0 {
                if is_eof {
                    return Err(LexerError::UnclosedChar(
                        base_offset..base_offset + readonly_input.len(),
                    ));
                } else {
                    break;
                }
            }
            char_token(
                &readonly_input[1..end - 1],
                base_offset + 1..base_offset + end - 1,
                tokens,
                symbols,
            )?;
            consumed = end;
        } else {
            if !is_eof && readonly_input.len() < 3 {
                break;
            }
            let mut matched = false;
            if readonly_input.len() >= 3 {
                let mut chars = readonly_input.chars();
                let c1 = chars.next().unwrap();
                let c2 = chars.next().unwrap();
                let c3 = chars.next().unwrap();
                if let Some(tok) = TRIPLE_CHAR_TO_TOKEN.get(&(c1, c2, c3)) {
                    let len = c1.len_utf8() + c2.len_utf8() + c3.len_utf8();
                    push_single(tok.clone(), base_offset, 0, len, tokens);
                    consumed = len;
                    matched = true;
                }
            }
            if !matched && readonly_input.len() >= 2 {
                let mut chars = readonly_input.chars();
                let c1 = chars.next().unwrap();
                let c2 = chars.next().unwrap();
                if let Some(tok) = DOUBLE_CHAR_TO_TOKEN.get(&(c1, c2)) {
                    let len = c1.len_utf8() + c2.len_utf8();
                    push_single(tok.clone(), base_offset, 0, len, tokens);
                    consumed = len;
                    matched = true;
                }
            }
            if !matched {
                let c1 = readonly_input.chars().next().unwrap();
                if let Some(tok) = SINGLE_CHAR_TO_TOKEN.get(&c1) {
                    let len = c1.len_utf8();
                    push_single(tok.clone(), base_offset, 0, len, tokens);
                    consumed = len;
                    matched = true;
                }
            }
            if !matched {
                let c1 = readonly_input.chars().next().unwrap();
                return Err(LexerError::UnexpectedCharacter(
                    base_offset..base_offset + c1.len_utf8(),
                ));
            }
        }

        total_consumed += consumed;
    }

    if total_consumed > 0 {
        input.drain(..total_consumed);
    }
    Ok(())
}
fn parse_number(
    readonly_input: &str,
    is_eof: bool,
    base_offset: usize,
    tokens: &mut Vec<TokenData>,
    symbols: &mut LexerSymbolTable,
) -> LexerResult<usize> {
    let mut chars = readonly_input.char_indices().peekable();
    let first = chars.next().unwrap().1;
    if first == '-' {
        chars.next();
    }

    while let Some(&(_, c)) = chars.peek() {
        if c.is_ascii_alphanumeric() || c == '_' {
            chars.next();
        } else if c == '.' {
            let mut lookahead = chars.clone();
            lookahead.next();
            if let Some(&(_, next_c)) = lookahead.peek() {
                if next_c == '.' {
                    break;
                } else if next_c.is_ascii_digit() {
                    chars.next();
                } else {
                    break;
                }
            } else if !is_eof {
                return Ok(0);
            } else {
                chars.next();
            }
        } else {
            break;
        }
    }

    let end = chars
        .peek()
        .map(|&(i, _)| i)
        .unwrap_or(readonly_input.len());
    if end == readonly_input.len() && !is_eof {
        return Ok(0);
    }

    number_token(
        &readonly_input[..end],
        base_offset..base_offset + end,
        tokens,
        symbols,
    )?;
    Ok(end)
}
fn push_single(token: Token, offset: usize, start: usize, len: usize, tokens: &mut Vec<TokenData>) {
    tokens.push(TokenData {
        token,
        span: (offset + start)..(offset + start + len),
    });
}
fn identifier_token(
    ident_str: &str,
    span: Span,
    tokens: &mut Vec<TokenData>,
    symbols: &mut LexerSymbolTable,
) {
    if let Some(token) = get_keyword(ident_str) {
        tokens.push(TokenData { token, span });
        return;
    }
    tokens.push(TokenData {
        token: Token::Name(symbols.get_or_intern(ident_str.to_string())),
        span,
    });
}
fn number_token(
    number_str: &str,
    span: Span,
    tokens: &mut Vec<TokenData>,
    symbols: &mut LexerSymbolTable,
) -> LexerResult<()> {
    if number_str.contains('.') {
        tokens.push(TokenData {
            token: Token::Decimal(
                symbols.get_or_intern(
                    number_str
                        .parse::<f64>()
                        .map_err(|_| {
                            LexerError::InvalidNumber(number_str.to_string(), span.clone())
                        })?
                        .to_string(),
                ),
            ),
            span,
        });
    } else {
        let s = number_str;
        let (is_neg, s_without_sign) = if let Some(stripped) = s.strip_prefix('-') {
            (true, stripped)
        } else {
            (false, s)
        };
        let (radix, digits) = if let Some(stripped) = s_without_sign.strip_prefix("0x") {
            (16, stripped)
        } else if let Some(stripped) = s_without_sign.strip_prefix("0b") {
            (2, stripped)
        } else if let Some(stripped) = s_without_sign.strip_prefix("0o") {
            (8, stripped)
        } else {
            (10, s_without_sign)
        };

        let abs_val = u128::from_str_radix(digits, radix)
            .map_err(|_| LexerError::InvalidNumber(number_str.to_string(), span.clone()))?;

        let val = if is_neg {
            (abs_val as i128).wrapping_neg()
        } else {
            abs_val as i128
        };
        tokens.push(TokenData {
            token: Token::Integer(symbols.get_or_intern(val.to_string())),
            span,
        });
    }
    Ok(())
}
fn string_token(
    string_str: &str,
    span: Span,
    tokens: &mut Vec<TokenData>,
    symbols: &mut LexerSymbolTable,
) -> LexerResult<()> {
    let q = unescape_content(string_str, &span)?;
    tokens.push(TokenData {
        span,
        token: Token::String(symbols.get_or_intern(q)),
    });
    Ok(())
}
fn char_token(
    content_str: &str,
    span: Span,
    tokens: &mut Vec<TokenData>,
    _symbols: &mut LexerSymbolTable,
) -> LexerResult<()> {
    let unescaped = unescape_content(content_str, &span)?;
    let mut chars = unescaped.chars();

    let c = match chars.next() {
        Some(c) => c,
        None => return Err(LexerError::InvalidCharLiteral(span)),
    };

    if chars.next().is_some() {
        return Err(LexerError::InvalidCharLiteral(span));
    }

    tokens.push(TokenData {
        span,
        token: Token::Char(c),
    });

    Ok(())
}
fn unescape_content(content: &str, span: &Span) -> LexerResult<String> {
    let mut unescaped = String::with_capacity(content.len());
    let mut chars = content.chars().peekable();

    while let Some(c) = chars.next() {
        if c != '\\' {
            unescaped.push(c);
            continue;
        }

        let next_char = match chars.next() {
            Some(n) => n,
            None => return Err(LexerError::InvalidEscapeSequence(span.clone())),
        };

        match next_char {
            'n' => unescaped.push('\n'),
            'v' => unescaped.push('\x0B'),
            'f' => unescaped.push('\x0C'),
            't' => unescaped.push('\t'),
            'r' => unescaped.push('\r'),
            '\\' => unescaped.push('\\'),
            '"' => unescaped.push('"'),
            '\'' => unescaped.push('\''),
            '0'..='7' => {
                let mut octal = String::with_capacity(3);
                octal.push(next_char);
                for _ in 0..2 {
                    if let Some(&c) = chars.peek() {
                        if ('0'..='7').contains(&c) {
                            octal.push(c);
                            chars.next();
                        } else {
                            break;
                        }
                    }
                }
                if let Ok(byte) = u8::from_str_radix(&octal, 8) {
                    unescaped.push(byte as char);
                } else {
                    return Err(LexerError::InvalidEscapeSequence(span.clone()));
                }
            }
            'x' => {
                let mut hex = String::with_capacity(2);
                for _ in 0..2 {
                    if let Some(&c) = chars.peek() {
                        if c.is_ascii_hexdigit() {
                            hex.push(c);
                            chars.next();
                        } else {
                            break;
                        }
                    }
                }
                if hex.len() == 2 {
                    if let Ok(byte) = u8::from_str_radix(&hex, 16) {
                        unescaped.push(byte as char);
                        continue;
                    }
                }
                return Err(LexerError::InvalidEscapeSequence(span.clone()));
            }
            'u' => {
                if chars.next() != Some('{') {
                    return Err(LexerError::InvalidEscapeSequence(span.clone()));
                }
                let mut hex = String::new();
                let mut closed = false;
                while let Some(&c) = chars.peek() {
                    if c == '}' {
                        chars.next();
                        closed = true;
                        break;
                    }
                    if c.is_ascii_hexdigit() {
                        hex.push(c);
                        chars.next();
                    } else {
                        break;
                    }
                }
                if !closed {
                    return Err(LexerError::InvalidEscapeSequence(span.clone()));
                }
                if let Ok(code) = u32::from_str_radix(&hex, 16) {
                    if let Some(c) = std::char::from_u32(code) {
                        unescaped.push(c);
                        continue;
                    }
                }
                return Err(LexerError::InvalidEscapeSequence(span.clone()));
            }
            _ => return Err(LexerError::InvalidEscapeSequence(span.clone())),
        }
    }

    Ok(unescaped)
}
