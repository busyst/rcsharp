use logos::{Logos, Lexer as LogosLexer, Span};
use std::fmt;
// AI assisted, somehow works. Further improvements needed.

#[derive(Debug, Default, Clone, Copy, PartialEq, Eq)]
pub struct Location {
    pub row: u32,
    pub col: u32,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct TokenData {
    pub token: Token,
    pub span: Span,
    pub loc: Location,
}
impl TokenData {
    pub fn expect_name_token(&self) -> Result<String, String>{
        if let Token::Name(str) = &self.token{
            return Ok(str.to_string());
        }
        Err(format!("Expected name token, found {:?} at {:?}", self.token, self.loc))
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct LexingError {
    pub span: Span,
    pub loc: Location,
}

impl fmt::Display for LexingError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(
            f,
            "Invalid token at row {}, col {}",
            self.loc.row, self.loc.col
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
    DummyToken,
    #[regex(r"[a-zA-Z_]\w*", |lex| lex.slice().to_string().into_boxed_str())]
    Name(Box<str>),
    #[regex(r"\d+", |lex| lex.slice().to_string().into_boxed_str())]
    Integer(Box<str>),
    #[regex(r#""([^"\\]|\\.)*""#, unescape_string)]
    String(Box<str>),
    
    #[regex(r"'([^'\\]|\\.)'", |lex| lex.slice().to_string().into_boxed_str())]
    Char(Box<str>),
}

pub struct Lexer<'source> {
    logos: LogosLexer<'source, Token>,
    loc: Location,
}

impl<'source> Lexer<'source> {
    pub fn new(source: &'source str) -> Self {
        Self {
            logos: Token::lexer(source),
            loc: Location { row: 1, col: 1 },
        }
    }
    fn advance_loc(&mut self, slice: &str) {
        let newlines = slice.bytes().filter(|&b| b == b'\n').count();
        if newlines > 0 {
            self.loc.row += newlines as u32;
            let last_newline = slice.rfind('\n').unwrap();
            self.loc.col = slice[last_newline + 1..].chars().count() as u32 + 1;
        } else {
            self.loc.col += slice.chars().count() as u32;
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

            let start_loc = self.loc;

            self.advance_loc(slice);

            match token_result {
                Err(_) => {
                    let err = LexingError { span, loc: start_loc };
                    return Some(Err(err));
                }
                
                Ok(Token::Whitespace) | Ok(Token::Newline) | Ok(Token::LineComment) | Ok(Token::BlockComment) => {
                    continue;
                }
                
                Ok(token) => {
                    return Some(Ok(TokenData {
                        token,
                        span,
                        loc: start_loc,
                    }));
                }
            }
        }
    }
}
fn unescape_string(lex: &mut logos::Lexer<Token>) -> Box<str> {
    let slice = lex.slice();
    let content = &slice[1..slice.len() - 1];

    let mut unescaped = String::with_capacity(content.len());
    let mut chars = content.chars();

    while let Some(c) = chars.next() {
        if c == '\\' {
            match chars.next() {
                Some('n') => unescaped.push('\n'),
                Some('t') => unescaped.push('\t'),
                Some('r') => unescaped.push('\r'),
                Some('\\') => unescaped.push('\\'),
                Some('"') => unescaped.push('"'),
                Some(other) => unescaped.push(other),
                None => break,
            }
        } else {
            unescaped.push(c);
        }
    }

    unescaped.into_boxed_str()
}