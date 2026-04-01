pub type Span = std::ops::Range<usize>;
use std::{
    collections::HashMap,
    fs::File,
    io::{BufRead, BufReader, Cursor, Read, Write},
};

#[derive(Debug, Clone, PartialEq)]
pub struct TokenData {
    pub token: Token,
    pub span: Span,
}

#[derive(Debug, Clone, PartialEq)]
pub enum Token {
    LParen,
    RParen,
    LBrace,
    RBrace,
    LSquareBrace,
    RSquareBrace,
    Colon,
    DoubleColon,
    SemiColon,
    Comma,
    Dot,
    RangeDots,
    RangeDotsInclusive,
    FatArrow,
    Hint,

    Equal,
    Plus,
    Minus,
    Multiply,
    Divide,
    Modulo,
    LogicNot,
    LogicEqual,
    LogicNotEqual,
    LogicOr,
    LogicAnd,
    LogicGreater,
    LogicGreaterEqual,
    LogicLess,
    LogicLessEqual,
    BinaryNot,
    BinaryOr,
    BinaryAnd,
    BinaryXor,
    BinaryShiftL,
    BinaryShiftR,

    KeywordPub,
    KeywordInline,
    KeywordConst,
    KeywordConstExpr,
    KeywordExtern,
    KeywordNoReturn,
    KeywordMatch,
    KeywordFunction,
    KeywordLet,
    KeywordStatic,
    KeywordAs,
    KeywordIf,
    KeywordElse,
    KeywordStruct,
    KeywordEnum,
    KeywordLoop,
    KeywordFor,
    KeywordDo,
    KeywordIn,
    KeywordWhile,
    KeywordBreak,
    KeywordContinue,
    KeywordReturn,
    KeywordThis,
    KeywordOperator,
    KeywordNamespace,
    KeywordTrue,
    KeywordFalse,
    KeywordNull,

    Name(Symbol),
    Integer(Symbol),
    Decimal(Symbol),
    String(Symbol),
    Char(char),
    DummyToken,
}
const KEYWORDS_TO_TOKENS: phf::Map<&'static str, Token> = phf::phf_map!(
    "pub"       => Token::KeywordPub,
    "inline"    => Token::KeywordInline,
    "const"     => Token::KeywordConst,
    "constexpr" => Token::KeywordConstExpr,
    "extern"    => Token::KeywordExtern,
    "no_return"  => Token::KeywordNoReturn,
    "match"     => Token::KeywordMatch,
    "fn"        => Token::KeywordFunction,
    "let"       => Token::KeywordLet,
    "static"    => Token::KeywordStatic,
    "as"        => Token::KeywordAs,
    "if"        => Token::KeywordIf,
    "else"      => Token::KeywordElse,
    "struct"    => Token::KeywordStruct,
    "enum"      => Token::KeywordEnum,
    "loop"      => Token::KeywordLoop,
    "for"      => Token::KeywordFor,
    "in"      => Token::KeywordIn,
    "do"      => Token::KeywordDo,
    "while"      => Token::KeywordWhile,
    "break"     => Token::KeywordBreak,
    "continue"  => Token::KeywordContinue,
    "return"    => Token::KeywordReturn,
    "this"      => Token::KeywordThis,
    "operator"  => Token::KeywordOperator,
    "namespace" => Token::KeywordNamespace,
    "true"      => Token::KeywordTrue,
    "false"     => Token::KeywordFalse,
    "null"      => Token::KeywordNull,
);
const SINGLE_CHAR_TO_TOKEN: phf::Map<char, Token> = phf::phf_map!(
    '#' => Token::Hint,
    '{' => Token::LBrace, '}' => Token::RBrace,
    '[' => Token::LSquareBrace, ']' => Token::RSquareBrace,
    '(' => Token::LParen, ')' => Token::RParen,
    ';' => Token::SemiColon, ',' => Token::Comma,
    '+' => Token::Plus, '-' => Token::Minus,
    '*' => Token::Multiply, '/' => Token::Divide,
    '%' => Token::Modulo, '^' => Token::BinaryXor,
    ':' => Token::Colon, '<' => Token::LogicLess,
    '>' => Token::LogicGreater, '=' => Token::Equal,
    '!' => Token::LogicNot, '|' => Token::BinaryOr,
    '&' => Token::BinaryAnd, '.' => Token::Dot,
);

const DOUBLE_CHAR_TO_TOKEN: phf::Map<(char, char), Token> = phf::phf_map!(
    (':', ':') => Token::DoubleColon,
    ('<', '<') => Token::BinaryShiftL,
    ('<', '=') => Token::LogicLessEqual,
    ('>', '>') => Token::BinaryShiftR,
    ('>', '=') => Token::LogicGreaterEqual,
    ('=', '>') => Token::FatArrow,
    ('=', '=') => Token::LogicEqual,
    ('!', '=') => Token::LogicNotEqual,
    ('|', '|') => Token::LogicOr,
    ('&', '&') => Token::LogicAnd,
    ('.', '.') => Token::RangeDots,
);

const TRIPLE_CHAR_TO_TOKEN: phf::Map<(char, char, char), Token> = phf::phf_map!(
    ('.', '.', '=') => Token::RangeDotsInclusive,
);
const ALLOWED_FILE_SIZE: u64 = 1024 * 1024 * 16; // 16 MB
#[derive(Debug)]
pub enum LexerError {
    FileNotFound(String),
    FileIsDirectory(String),
    IoError(std::io::Error),
    UnexpectedEOF(String),
    InvalidUtf8,
    UnclosedString(Span),
    UnclosedChar(Span),
    InvalidNumber(String, Span),
    InvalidCharLiteral(Span),
    UnexpectedCharacter(Span),
}
pub type LexerResult<T> = Result<T, LexerError>;
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Symbol(usize);
impl Symbol {
    pub fn to_integer(self, symbol_table: &LexerSymbolTable) -> i128 {
        let s = symbol_table.get(&self);
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
        let abs_val = u128::from_str_radix(digits, radix).unwrap();
        let val = if is_neg {
            (abs_val as i128).wrapping_neg()
        } else {
            abs_val as i128
        };
        val
    }
    pub fn to_decimal(self, symbol_table: &LexerSymbolTable) -> f64 {
        symbol_table.get(&self).parse::<f64>().unwrap()
    }
    pub fn to_string(self, symbol_table: &LexerSymbolTable) -> String {
        symbol_table.get(&self).to_string()
    }
}
pub struct LexerSymbolTable {
    pub strings: Vec<String>,
    indices: HashMap<String, usize>,
}
impl LexerSymbolTable {
    pub fn new() -> Self {
        Self {
            strings: Vec::new(),
            indices: HashMap::new(),
        }
    }

    pub fn get_or_intern(&mut self, s: &str) -> Symbol {
        Symbol(*self.indices.entry(s.to_string()).or_insert_with(|| {
            self.strings.push(s.to_string());
            self.strings.len() - 1
        }))
    }
    pub fn get(&self, s: &Symbol) -> &str {
        &self.strings[s.0]
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
#[allow(dead_code)]
fn debug_lex_emit(tokens: &Vec<TokenData>, symbol_table: &LexerSymbolTable) {
    if let Ok(mut file) = std::fs::OpenOptions::new()
        .create(true)
        .truncate(true)
        .write(true)
        .open("./debug_lexer")
    {
        let mut str = String::new();
        for token_data in tokens {
            match &token_data.token {
                Token::Name(symbol) => {
                    str.push_str(&symbol_table.strings[symbol.0]);
                }
                Token::String(symbol) => {
                    str.push_str(&format!("\"{}\"", symbol_table.strings[symbol.0]));
                }
                Token::Integer(symbol) => {
                    str.push_str(&format!("\"{}\"", symbol_table.strings[symbol.0]));
                }
                Token::Decimal(symbol) => {
                    str.push_str(&format!("\"{}\"", symbol_table.strings[symbol.0]));
                }
                Token::Hint => str.push_str("#"),
                Token::Comma => str.push_str(", "),
                Token::Dot => str.push_str("."),
                Token::RangeDots => str.push_str(".."),
                Token::LParen => str.push_str("("),
                Token::RParen => str.push_str(")"),
                Token::Colon => str.push_str(":"),
                Token::LogicLess => str.push_str("<"),
                Token::LogicLessEqual => str.push_str("<="),
                Token::BinaryShiftL => str.push_str("<<"),
                Token::LogicGreater => str.push_str(">"),
                Token::LogicGreaterEqual => str.push_str(">="),
                Token::BinaryShiftR => str.push_str(">>"),
                Token::LogicNot => str.push_str("!"),
                Token::Equal => str.push_str("="),
                Token::LogicEqual => str.push_str("=="),
                Token::LogicNotEqual => str.push_str("!="),
                Token::Plus => str.push_str("+"),
                Token::Minus => str.push_str("-"),
                Token::Multiply => str.push_str("*"),
                Token::Divide => str.push_str("/"),
                Token::Modulo => str.push_str("%"),
                Token::BinaryAnd => str.push_str("&"),
                Token::LogicAnd => str.push_str("&&"),
                Token::BinaryOr => str.push_str("|"),
                Token::LogicOr => str.push_str("||"),
                Token::DoubleColon => str.push_str("::"),
                Token::SemiColon => str.push_str(";\n"),
                Token::LSquareBrace => str.push_str("["),
                Token::RSquareBrace => str.push_str("]"),
                Token::LBrace => str.push_str(" {\n"),
                Token::RBrace => str.push_str("\n}\n"),
                _ => {
                    if let Some(d) = KEYWORDS_TO_TOKENS
                        .entries()
                        .find(|x| *x.1 == token_data.token)
                        .map(|x| x.0)
                    {
                        str.push_str(&format!("{} ", d));
                        continue;
                    }
                    str.push_str(&format!(" {:?} ", token_data.token));
                }
            }
        }
        let _ = file.write(str.as_bytes());
    }
}
pub fn lex_stream(
    reader: &mut dyn BufRead,
    tokens: &mut Vec<TokenData>,
    symbol_table: &mut LexerSymbolTable,
) -> LexerResult<()> {
    const CAP: usize = 256;
    let mut buf = Box::new([0; CAP]);

    let mut global_offset = 0;
    let mut buf_write_start = 0;
    let mut input_buffer = String::with_capacity(2 * CAP);
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
    let readonly_input = input.trim_start();
    if readonly_input.is_empty() {
        if is_eof {
            input.clear();
        }
        return Ok(());
    }

    let base_offset = global_offset + (input.len() - readonly_input.len());
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
                return Ok(());
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
            return Ok(());
        }
        consumed = n;
    } else if readonly_input.starts_with("/*") {
        if let Some(pos) = readonly_input.find("*/") {
            consumed = pos + 2;
        } else {
            if is_eof {
                consumed = readonly_input.len();
            } else {
                return Ok(());
            }
        }
    } else if readonly_input.starts_with("//") {
        if let Some(pos) = readonly_input.find('\n') {
            consumed = pos + 1;
        } else {
            if is_eof {
                consumed = readonly_input.len();
            } else {
                return Ok(());
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
                return Ok(());
            }
        }
        string_token(
            &readonly_input[1..end - 1],
            base_offset + 1..base_offset + end - 1,
            tokens,
            symbols,
        );
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
                return Ok(());
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
            return Ok(());
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

    let fin = (input.len() - readonly_input.len()) + consumed;
    if fin > 0 {
        input.drain(..fin);
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
pub fn identifier_token(
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
        token: Token::Name(symbols.get_or_intern(ident_str)),
        span,
    });
}
pub fn number_token(
    number_str: &str,
    span: Span,
    tokens: &mut Vec<TokenData>,
    symbols: &mut LexerSymbolTable,
) -> LexerResult<()> {
    if number_str.contains('.') {
        let s = number_str.replace('_', "");
        tokens.push(TokenData {
            token: Token::Decimal(symbols.get_or_intern(&s)),
            span,
        });
    } else {
        let s = number_str.replace('_', "");
        tokens.push(TokenData {
            token: Token::Integer(symbols.get_or_intern(&s)),
            span,
        });
    }
    Ok(())
}
pub fn string_token(
    string_str: &str,
    span: Span,
    tokens: &mut Vec<TokenData>,
    symbols: &mut LexerSymbolTable,
) {
    fn unescape_content(content: &str, is_string: bool) -> String {
        fn handle_hex_escape(
            chars: &mut std::iter::Peekable<std::str::Chars>,
            unescaped: &mut String,
        ) {
            let mut hex = String::with_capacity(2);
            for _ in 0..2 {
                match chars.peek() {
                    Some(&c) if c.is_ascii_hexdigit() => {
                        hex.push(c);
                        chars.next();
                    }
                    _ => break,
                }
            }

            if hex.len() == 2
                && let Ok(byte) = u8::from_str_radix(&hex, 16)
            {
                unescaped.push(byte as char);
                return;
            }
            unescaped.push_str("\\x");
            unescaped.push_str(&hex);
        }
        fn handle_octal_escape(
            first_digit: char,
            chars: &mut std::iter::Peekable<std::str::Chars>,
            unescaped: &mut String,
        ) {
            let mut octal = String::with_capacity(3);
            octal.push(first_digit);

            for _ in 0..2 {
                match chars.peek() {
                    Some(&c) if ('0'..='7').contains(&c) => {
                        octal.push(c);
                        chars.next();
                    }
                    _ => break,
                }
            }

            if let Ok(byte) = u8::from_str_radix(&octal, 8) {
                unescaped.push(byte as char);
            } else {
                unescaped.push('\\');
                unescaped.push_str(&octal);
            }
        }
        fn handle_unicode_escape(
            chars: &mut std::iter::Peekable<std::str::Chars>,
            unescaped: &mut String,
        ) {
            match chars.next() {
                Some('{') => {}
                _ => {
                    unescaped.push_str("\\u");
                    return;
                }
            }

            let mut hex = String::new();
            while let Some(&c) = chars.peek() {
                if c == '}' {
                    chars.next();
                    break;
                }
                if c.is_ascii_hexdigit() {
                    hex.push(c);
                    chars.next();
                } else {
                    break;
                }
            }

            if let Ok(code) = u32::from_str_radix(&hex, 16)
                && let Some(c) = std::char::from_u32(code)
            {
                unescaped.push(c);
                return;
            }
            unescaped.push_str("\\u{");
            unescaped.push_str(&hex);
            unescaped.push('}');
        }

        let mut unescaped = String::with_capacity(content.len());
        let mut chars = content.chars().peekable();

        while let Some(c) = chars.next() {
            if c != '\\' {
                unescaped.push(c);
                if !is_string {
                    break; // For char literals, only process first character
                }
                continue;
            }

            let next_char = match chars.next() {
                Some(n) => n,
                None => {
                    unescaped.push('\\');
                    break;
                }
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
                'x' => handle_hex_escape(&mut chars, &mut unescaped),
                '0'..='7' => handle_octal_escape(next_char, &mut chars, &mut unescaped),
                'u' => handle_unicode_escape(&mut chars, &mut unescaped),
                _ => {
                    unescaped.push('\\');
                    unescaped.push(next_char);
                }
            }

            if !is_string {
                break; // For char literals, only process first escape sequence
            }
        }

        unescaped
    }
    let q = unescape_content(string_str, true);
    tokens.push(TokenData {
        span,
        token: Token::String(symbols.get_or_intern(&q)),
    });
}
pub fn char_token(
    content_str: &str,
    span: Span,
    tokens: &mut Vec<TokenData>,
    _symbols: &mut LexerSymbolTable,
) -> LexerResult<()> {
    let mut chars = content_str.chars();

    let c = match chars.next() {
        Some('\\') => match chars.next() {
            Some('n') => '\n',
            Some('r') => '\r',
            Some('t') => '\t',
            Some('\\') => '\\',
            Some('0') => '\0',
            Some('\'') => '\'',
            Some('"') => '"',
            Some(other) => other,
            None => return Err(LexerError::UnclosedChar(span)),
        },
        Some(c) => c,
        None => return Err(LexerError::UnclosedChar(span)),
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
fn get_keyword(ident: &str) -> Option<Token> {
    KEYWORDS_TO_TOKENS.get(ident).cloned()
}
