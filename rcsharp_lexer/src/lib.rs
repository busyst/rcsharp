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
    KeywordBreak,
    KeywordContinue,
    KeywordReturn,
    KeywordThis,
    KeywordOperator,
    KeywordNamespace,
    KeywordTrue,
    KeywordFalse,
    KeywordNull,

    DummyToken,
    Name(Symbol),
    Integer(i128),
    Decimal(f64),
    String(Symbol),
    Char(char),
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
const ALLOWED_FILE_SIZE: u64 = 1024 * 1024 * 16; // 16 MB
#[derive(Debug)]
pub enum LexerResultError {
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
pub type LexerResult<T> = Result<T, LexerResultError>;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Symbol(usize);
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
        let metadata = file.metadata().map_err(LexerResultError::IoError)?;
        if metadata.is_dir() {
            return Err(LexerResultError::FileIsDirectory(path.to_string()));
        }
        Ok(metadata.len())
    }
    let file = File::open(path).map_err(|_| LexerResultError::FileNotFound(path.to_string()))?;
    let file_size = metadata_check(path, &file)?;

    let mut reader: Box<dyn BufRead> = if file_size < ALLOWED_FILE_SIZE {
        let mut content = String::new();
        let mut f = file;
        f.read_to_string(&mut content)
            .map_err(LexerResultError::IoError)?;
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
    // Just for debug safety, panic less often
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
                Token::Integer(val) => str.push_str(&val.to_string()),
                Token::Decimal(val) => str.push_str(&val.to_string()),
                Token::Hint => str.push_str("#"),
                Token::Comma => str.push_str(", "),
                Token::Dot => str.push_str("."),
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
            .map_err(LexerResultError::IoError)?;

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
                    return Err(LexerResultError::UnexpectedEOF(
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
        *input = String::new();
        return Ok(());
    }
    let base_offset = global_offset + (input.len() - readonly_input.len());

    let mut last_consumed_byte_index = 0;
    let mut chars = readonly_input.char_indices().peekable();

    while let Some((idx, char)) = chars.next() {
        if char.is_whitespace() {
            continue;
        }
        if char.is_alphabetic() || char == '_' {
            let mut name_end = 0;
            while let Some((idx, char)) = chars.peek() {
                if !(char.is_alphabetic() || char.is_digit(10) || *char == '_') {
                    name_end = *idx;
                    break;
                }
                chars.next();
            }
            if name_end == 0 && is_eof {
                name_end = readonly_input.len();
            }
            if name_end != 0 {
                identifier_token(
                    &readonly_input[..name_end],
                    base_offset..(base_offset + name_end), // was 0..name_end
                    tokens,
                    symbols,
                );
                last_consumed_byte_index = name_end;
                break;
            } else {
                break;
            }
        } else if char.is_digit(10) {
            let mut number_end = 0;
            if let Some(&(_pk_idx, pk_char)) = chars.peek() {
                if matches!(pk_char, 'x' | 'X' | 'b' | 'B' | 'o' | 'O') {
                    chars.next();
                }
            } else if !is_eof {
                break;
            }

            while let Some((idx, char)) = chars.peek() {
                if !(char.is_digit(16) || *char == '_' || *char == '.') {
                    number_end = *idx;
                    break;
                }
                chars.next();
            }
            if number_end == 0 && is_eof {
                number_end = readonly_input.len();
            }
            if number_end != 0 {
                number_token(
                    &readonly_input[..number_end],
                    base_offset..(base_offset + number_end),
                    tokens,
                )?;
                last_consumed_byte_index = number_end;
                break;
            } else {
                break;
            }
        } else if char == '-' {
            if let Some(&(_pk_idx, pk_char)) = chars.peek() {
                if pk_char.is_digit(10) {
                    let mut number_end = 0;
                    if let Some(&(_pk_idx, pk_char)) = chars.peek() {
                        if matches!(pk_char, 'x' | 'X' | 'b' | 'B' | 'o' | 'O') {
                            chars.next();
                        }
                    } else if !is_eof {
                        break;
                    }

                    while let Some((idx, char)) = chars.peek() {
                        if !(char.is_digit(16) || *char == '_' || *char == '.') {
                            number_end = *idx;
                            break;
                        }
                        chars.next();
                    }
                    if number_end == 0 && is_eof {
                        number_end = readonly_input.len();
                    }
                    if number_end != 0 {
                        number_token(&readonly_input[..number_end], 0..number_end, tokens)?;
                        last_consumed_byte_index = number_end;
                        break;
                    } else {
                        break;
                    }
                }
            } else if !is_eof {
                break;
            }
            push_single(Token::Minus, base_offset + idx, 0, char.len_utf8(), tokens);
            last_consumed_byte_index = char.len_utf8();
            break;
        } else if char == '/' {
            let pk = chars.peek();
            if pk.is_none() {
                if is_eof {
                    tokens.push(TokenData {
                        token: Token::Divide,
                        span: 0..char.len_utf8(),
                    });
                    last_consumed_byte_index = char.len_utf8();
                }
                break;
            }
            let pk = pk.unwrap();
            match pk.1 {
                '*' => {
                    chars.next();
                    let mut multi_line_comment_end = 0;
                    let mut current_char = (idx, char);
                    while let Some((idx, char)) = chars.peek() {
                        if *char == '/' {
                            if current_char.1 == '*' {
                                multi_line_comment_end = *idx + 1;
                                break;
                            }
                        }
                        current_char = chars.next().unwrap();
                    }
                    if multi_line_comment_end != 0 {
                        last_consumed_byte_index = multi_line_comment_end;
                        break;
                    } else if is_eof {
                        last_consumed_byte_index = readonly_input.len();
                        break;
                    } else {
                        break;
                    }
                }
                '/' => {
                    chars.next();
                    let mut single_line_comment_end = 0;
                    while let Some((idx, char)) = chars.peek() {
                        if *char == '\n' {
                            single_line_comment_end = *idx + 1;
                            break;
                        }
                        chars.next();
                    }
                    if single_line_comment_end != 0 {
                        last_consumed_byte_index = single_line_comment_end;
                        break;
                    } else if is_eof {
                        last_consumed_byte_index = readonly_input.len();
                        break;
                    } else {
                        break;
                    }
                }
                _ => {
                    tokens.push(TokenData {
                        token: Token::Divide,
                        span: 0..char.len_utf8(),
                    });
                    last_consumed_byte_index = char.len_utf8();
                    break;
                }
            }
        } else if char == '"' {
            let mut string_end = 0;
            let mut current_char = (idx, char);
            while let Some((idx, char)) = chars.peek() {
                if *char == '"' {
                    if current_char.1 != '\\' {
                        string_end = *idx + 1;
                        break;
                    }
                }
                current_char = chars.next().unwrap();
            }
            if string_end == 0 && is_eof {
                return Err(LexerResultError::UnclosedString(
                    base_offset..(base_offset + readonly_input.len()),
                ));
            }
            if string_end != 0 {
                string_token(
                    &readonly_input[1..string_end - 1],
                    (base_offset + 1)..(base_offset + string_end - 1),
                    tokens,
                    symbols,
                );
                last_consumed_byte_index = string_end;
                break;
            } else {
                break;
            }
        } else if char == '\'' {
            let mut char_end = 0;
            let mut current_char = (idx, char);
            while let Some((idx, char)) = chars.peek() {
                if *char == '\'' {
                    if current_char.1 != '\\' {
                        char_end = *idx + 1;
                        break;
                    }
                }
                if current_char.1 == '\\' {
                    current_char = chars.next().unwrap();
                    current_char.1 = '\0';
                } else {
                    current_char = chars.next().unwrap();
                }
            }
            if char_end == 0 && is_eof {
                return Err(LexerResultError::UnclosedChar(0..readonly_input.len()));
            }
            if char_end != 0 {
                char_token(
                    &readonly_input[1..char_end - 1],
                    (base_offset + 1)..(base_offset + char_end - 1),
                    tokens,
                    symbols,
                )?;
                last_consumed_byte_index = char_end;
                break;
            } else {
                break;
            }
        } else {
            let t = tokens.len();
            match char {
                '#' => push_single(Token::Hint, base_offset + idx, 0, char.len_utf8(), tokens),
                '{' => push_single(Token::LBrace, base_offset + idx, 0, char.len_utf8(), tokens),
                '}' => push_single(Token::RBrace, base_offset + idx, 0, char.len_utf8(), tokens),
                '[' => push_single(
                    Token::LSquareBrace,
                    base_offset + idx,
                    0,
                    char.len_utf8(),
                    tokens,
                ),
                ']' => push_single(
                    Token::RSquareBrace,
                    base_offset + idx,
                    0,
                    char.len_utf8(),
                    tokens,
                ),
                '(' => push_single(Token::LParen, base_offset + idx, 0, char.len_utf8(), tokens),
                ')' => push_single(Token::RParen, base_offset + idx, 0, char.len_utf8(), tokens),
                ';' => push_single(
                    Token::SemiColon,
                    base_offset + idx,
                    0,
                    char.len_utf8(),
                    tokens,
                ),
                '.' => push_single(Token::Dot, base_offset + idx, 0, char.len_utf8(), tokens),
                ',' => push_single(Token::Comma, base_offset + idx, 0, char.len_utf8(), tokens),
                '+' => push_single(Token::Plus, base_offset + idx, 0, char.len_utf8(), tokens),
                '-' => push_single(Token::Minus, base_offset + idx, 0, char.len_utf8(), tokens),
                '*' => push_single(
                    Token::Multiply,
                    base_offset + idx,
                    0,
                    char.len_utf8(),
                    tokens,
                ),
                '%' => push_single(Token::Modulo, base_offset + idx, 0, char.len_utf8(), tokens),
                '^' => push_single(
                    Token::BinaryXor,
                    base_offset + idx,
                    0,
                    char.len_utf8(),
                    tokens,
                ),
                _ => {}
            };
            if tokens.len() != t {
                last_consumed_byte_index = char.len_utf8();
                break;
            }
            if let Some(&(_pk_idx, pk_char)) = chars.peek() {
                match (char, pk_char) {
                    (':', ':') => {
                        push_single(Token::DoubleColon, base_offset + idx, 0, 2, tokens);
                        last_consumed_byte_index = 2;
                    }
                    (':', _) => {
                        push_single(Token::Colon, base_offset + idx, 0, 1, tokens);
                        last_consumed_byte_index = 1;
                    }
                    ('<', '<') => {
                        push_single(Token::BinaryShiftL, base_offset + idx, 0, 2, tokens);
                        last_consumed_byte_index = 2;
                    }
                    ('<', '=') => {
                        push_single(Token::LogicLessEqual, base_offset + idx, 0, 2, tokens);
                        last_consumed_byte_index = 2;
                    }
                    ('<', _) => {
                        push_single(Token::LogicLess, base_offset + idx, 0, 1, tokens);
                        last_consumed_byte_index = 1;
                    }
                    ('>', '>') => {
                        push_single(Token::BinaryShiftR, base_offset + idx, 0, 2, tokens);
                        last_consumed_byte_index = 2;
                    }
                    ('>', '=') => {
                        push_single(Token::LogicGreaterEqual, base_offset + idx, 0, 2, tokens);
                        last_consumed_byte_index = 2;
                    }
                    ('>', _) => {
                        push_single(Token::LogicGreater, base_offset + idx, 0, 1, tokens);
                        last_consumed_byte_index = 1;
                    }
                    ('=', '=') => {
                        push_single(Token::LogicEqual, base_offset + idx, 0, 2, tokens);
                        last_consumed_byte_index = 2;
                    }
                    ('=', _) => {
                        push_single(Token::Equal, base_offset + idx, 0, 1, tokens);
                        last_consumed_byte_index = 1;
                    }
                    ('!', '=') => {
                        push_single(Token::LogicNotEqual, base_offset + idx, 0, 2, tokens);
                        last_consumed_byte_index = 2;
                    }
                    ('!', _) => {
                        push_single(Token::LogicNot, base_offset + idx, 0, 1, tokens);
                        last_consumed_byte_index = 1;
                    }
                    ('&', '&') => {
                        push_single(Token::LogicAnd, base_offset + idx, 0, 2, tokens);
                        last_consumed_byte_index = 2;
                    }
                    ('&', _) => {
                        push_single(Token::BinaryAnd, base_offset + idx, 0, 1, tokens);
                        last_consumed_byte_index = 1;
                    }
                    ('|', '|') => {
                        push_single(Token::LogicOr, base_offset + idx, 0, 2, tokens);
                        last_consumed_byte_index = 2;
                    }
                    ('|', _) => {
                        push_single(Token::BinaryOr, base_offset + idx, 0, 1, tokens);
                        last_consumed_byte_index = 1;
                    }
                    _ => {
                        return Err(LexerResultError::UnexpectedCharacter(
                            base_offset + idx..base_offset + idx + 1,
                        ));
                    }
                }
            } else if is_eof {
                match char {
                    ':' => {
                        push_single(Token::Colon, base_offset + idx, 0, 1, tokens);
                        last_consumed_byte_index = 1;
                    }
                    '<' => {
                        push_single(Token::LogicLess, base_offset + idx, 0, 1, tokens);
                        last_consumed_byte_index = 1;
                    }
                    '>' => {
                        push_single(Token::LogicGreater, base_offset + idx, 0, 1, tokens);
                        last_consumed_byte_index = 1;
                    }
                    '=' => {
                        push_single(Token::Equal, base_offset + idx, 0, 1, tokens);
                        last_consumed_byte_index = 1;
                    }
                    '!' => {
                        push_single(Token::LogicNot, base_offset + idx, 0, 1, tokens);
                        last_consumed_byte_index = 1;
                    }
                    '&' => {
                        push_single(Token::BinaryAnd, base_offset + idx, 0, 1, tokens);
                        last_consumed_byte_index = 1;
                    }
                    '|' => {
                        push_single(Token::BinaryOr, base_offset + idx, 0, 1, tokens);
                        last_consumed_byte_index = 1;
                    }
                    _ => {
                        todo!("{:?}", readonly_input);
                    }
                }
            } else {
                break;
            }
            if last_consumed_byte_index != 0 {
                break;
            }
        }
    }
    let fin = (input.len() - readonly_input.len()) + last_consumed_byte_index;
    if fin > 0 {
        input.drain(..fin);
    }
    Ok(())
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
pub fn number_token(number_str: &str, span: Span, tokens: &mut Vec<TokenData>) -> LexerResult<()> {
    if number_str.contains('.') {
        let val = number_str
            .parse::<f64>()
            .map_err(|_| LexerResultError::InvalidNumber(number_str.to_string(), span.clone()))?;
        tokens.push(TokenData {
            token: Token::Decimal(val),
            span,
        });
    } else {
        let s = number_str.replace('_', "");
        let (is_neg, s_without_sign) = if let Some(stripped) = s.strip_prefix('-') {
            (true, stripped)
        } else {
            (false, s.as_str())
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
        let v = if is_neg {
            (abs_val as i128).wrapping_neg()
        } else {
            abs_val as i128
        };
        tokens.push(TokenData {
            token: Token::Integer(v),
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
            None => return Err(LexerResultError::UnclosedChar(span)),
        },
        Some(c) => c,
        None => return Err(LexerResultError::UnclosedChar(span)),
    };

    if chars.next().is_some() {
        return Err(LexerResultError::InvalidCharLiteral(span));
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
