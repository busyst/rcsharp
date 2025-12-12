use logos::{Logos, Lexer as LogosLexer, Span};
use std::fmt;

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct TokenData {
    pub token: Token,
    pub span: Span,
    pub row: u32,
    pub col: u32,
}
impl TokenData {
    pub fn expect_name_token(&self) -> Result<String, String>{
        if let Token::Name(str) = &self.token{
            return Ok(str.to_string());
        }
        Err(format!("Expected name token, found {:?} at {}:{}", self.token, self.row, self.col))
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct LexingError {
    pub span: Span,
    pub row: u32,
    pub col: u32,
}

impl fmt::Display for LexingError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(
            f,
            "Invalid token at row {}, col {}",
            self.row, self.col
        )
    }
}
impl std::error::Error for LexingError {}

#[derive(Logos, Debug, Clone, PartialEq, Eq)]
pub enum Token {
    #[regex(r"[ \t\f\r]+")]
    Whitespace,

    #[token("\n")]
    Newline,

    #[regex(r"//[^\n]*")]
    LineComment,

    #[regex(r"/\*([^*]|\*[^/])*\*/")]
    BlockComment,

    #[token("(")] LParen,
    #[token(")")] RParen,
    #[token("{")] LBrace,
    #[token("}")] RBrace,
    #[token("[")] LSquareBrace,
    #[token("]")] RSquareBrace,
    #[token(":")] Colon,
    #[token("::")] DoubleColon,
    #[token(";")] SemiColon,
    #[token(",")] Comma,
    #[token(".")] Dot,
    #[token("#")] Hint,

    #[token("=")] Equal,
    #[token("+")] Plus,
    #[token("-")] Minus,
    #[token("*")] Multiply,
    #[token("/")] Divide,
    #[token("%")] Modulo,

    #[token("!")] LogicNot,
    #[token("==")] LogicEqual,
    #[token("!=")] LogicNotEqual,
    #[token("||")] LogicOr,
    #[token("&&")] LogicAnd,
    #[token(">")] LogicGreater,
    #[token(">=")] LogicGreaterEqual,
    #[token("<")] LogicLess,
    #[token("<=")] LogicLessEqual,

    #[token("~")] BinaryNot,
    #[token("|")] BinaryOr,
    #[token("&")] BinaryAnd,
    #[token("^")] BinaryXor,
    #[token("<<")] BinaryShiftL,
    #[token(">>")] BinaryShiftR,

    #[token("pub")] KeywordPub,
    #[token("inline")] KeywordInline,
    #[token("const")] KeywordConst,
    #[token("constexpr")] KeywordConstExpr,
    #[token("match")] KeywordMatch,
    
    #[token("fn")] KeywordFunction,
    #[token("let")] KeywordVariableDeclaration,
    #[token("as")] KeywordAs,
    #[token("if")] KeywordIf,
    #[token("else")] KeywordElse,
    #[token("struct")] KeywordStruct,
    #[token("enum")] KeywordEnum,
    #[token("loop")] KeywordLoop,
    #[token("break")] KeywordBreak,
    #[token("continue")] KeywordContinue,
    #[token("return")] KeywordReturn,
    #[token("this")] KeywordThis,
    #[token("operator")] KeywordOperator,
    #[token("namespace")] KeywordNamespace,
    #[token("true")] KeywordTrue,
    #[token("false")] KeywordFalse,
    DummyToken,
    #[regex(r"[a-zA-Z_]\w*", |lex| lex.slice().to_string().into_boxed_str())]
    Name(Box<str>),
    #[regex(r"0x[0-9a-fA-F]+|0b[01]+|\d+", unhex_num)]
    Integer(Box<str>),
    #[regex(r"[0-9]+\.[0-9]+", undecimal_num)]
    Decimal(Box<str>),
    #[regex(r#""([^"\\]|\\.)*""#, unescape_string)]
    String(Box<str>),
    
    #[regex(r"'([^'\\]|\\.)*'", unescape_char)]
    Char(i32),
}

pub struct Lexer<'source> {
    logos: LogosLexer<'source, Token>,
    pub row: u32,
    pub col: u32
}
impl<'source> Lexer<'source> {
    pub fn new(source: &'source str) -> Self {
        Self {
            logos: Token::lexer(source),
            col: 1,
            row: 1
        }
    }
    fn advance_loc(&mut self, slice: &str) {
        let newlines = slice.bytes().filter(|&b| b == b'\n').count();
        if newlines > 0 {
            self.row += newlines as u32;
            let last_newline = slice.rfind('\n').unwrap();
            self.col = slice[last_newline + 1..].chars().count() as u32 + 1;
        } else {
            self.col += slice.chars().count() as u32;
        }
    }
}
impl<'source> Iterator for Lexer<'source> {
    type Item = Result<TokenData, LexingError>;

    fn next(&mut self) -> Option<Self::Item> {
        loop {
            let token_result = self.logos.next()?;
            let span = self.logos.span();
            let slice = self.logos.slice();

            let start_loc_c = self.col;
            let start_loc_r = self.row;

            self.advance_loc(slice);

            match token_result {
                Err(_) => {
                    let err = LexingError { span, col: start_loc_c, row: start_loc_r };
                    return Some(Err(err));
                }
                Ok(Token::Whitespace) | Ok(Token::Newline) | Ok(Token::LineComment) | Ok(Token::BlockComment) => {
                    continue;
                }
                Ok(token) => {
                    return Some(Ok(TokenData {
                        token,
                        span,
                        col: start_loc_c,
                        row: start_loc_r
                    }));
                }
            }
        }
    }
}

fn unescape_string(lex: &mut logos::Lexer<Token>) -> Box<str> {
    let slice = lex.slice();
    let content = &slice[1..slice.len() - 1];
    unescape_content(content, true).into_boxed_str()
}
fn unescape_char(lex: &mut logos::Lexer<Token>) -> i32 {
    let slice = lex.slice();
    let content = &slice[1..slice.len() - 1];
    let unescaped = unescape_content(content, false);
    
    let mut chars = unescaped.chars();
    let first = chars.next().expect("Character literal cannot be empty");
    
    if chars.next().is_some() {
        panic!("Character literal may only contain one character");
    }
    
    first as i32
}
fn unhex_num(lex: &mut logos::Lexer<Token>) -> Box<str> {
    let slice = lex.slice();
    if slice.len() < 2 {
        return slice.to_string().into_boxed_str();
    }
    
    let mut chars = slice.chars();
    let second_char = chars.nth(1).unwrap();
    
    if second_char == 'x' {
        let b = i128::from_str_radix(&slice[2..], 16).unwrap();
        return b.to_string().into_boxed_str();
    }
    if second_char == 'b' {
        let b = i128::from_str_radix(&slice[2..], 2).unwrap();
        return b.to_string().into_boxed_str();
    }
    
    slice.to_string().into_boxed_str()
}
fn undecimal_num(lex: &mut logos::Lexer<Token>) -> Box<str> {
    let slice = lex.slice();
    if let Ok(x) = slice.parse::<f64>() {
        return format!("{:.32}", x).to_string().into_boxed_str();
    }
    panic!("Unparsable decimal! {}", slice);
}

fn unescape_content(content: &str, is_string: bool) -> String {
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

fn handle_hex_escape(chars: &mut std::iter::Peekable<std::str::Chars>, unescaped: &mut String) {
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

    if hex.len() == 2 && let Ok(byte) = u8::from_str_radix(&hex, 16) {
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
fn handle_unicode_escape(chars: &mut std::iter::Peekable<std::str::Chars>, unescaped: &mut String) {
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

    if let Ok(code) = u32::from_str_radix(&hex, 16) && let Some(c) = std::char::from_u32(code) {
        unescaped.push(c);
        return;
    }
    unescaped.push_str("\\u{");
    unescaped.push_str(&hex);
    unescaped.push('}');
}

pub fn lex_file_with_context(source_path: &str, filename: &str) -> Result<Vec<TokenData>, String> {
	Lexer::new(source_path)
		.collect::<Result<Vec<_>, LexingError>>()
		.map_err(|err| {
			let full_slice = &source_path[err.span.clone()];
			let (display_slice, remainder_info) = if full_slice.len() > 60 {
				(&full_slice[..60], format!("\n... and {} more symbols", full_slice.len() - 60))
			} else {
				(full_slice, String::new())
			};
			format!(
				"Lexing error in {}:{}:{} | Span: {:?}\nProblem:\n'{}'{}",
				filename, err.row, err.col, err.span, display_slice, remainder_info
			)
		})
}
pub fn lex_string_with_file_context(source: &str, filename: &str) -> Result<Vec<TokenData>, String> {
	Lexer::new(source)
		.collect::<Result<Vec<_>, LexingError>>()
		.map_err(|err| {
			let full_slice = &source[err.span.clone()];
			let (display_slice, remainder_info) = if full_slice.len() > 60 {
				(&full_slice[..60], format!("\n... and {} more symbols", full_slice.len() - 60))
			} else {
				(full_slice, String::new())
			};
			format!(
				"Lexing error in {}:{}:{} | Span: {:?}\nProblem:\n'{}'{}",
				filename, err.row, err.col, err.span, display_slice, remainder_info
			)
		})
}