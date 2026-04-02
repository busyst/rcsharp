use crate::LexerSymbolTable;
use std::io::Write;
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
    KeywordTrait,
    KeywordImpl,
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

pub const KEYWORDS_TO_TOKENS: phf::Map<&'static str, Token> = phf::phf_map!(
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
    "trait" => Token::KeywordTrait,
    "impl" => Token::KeywordImpl,
    "true"      => Token::KeywordTrue,
    "false"     => Token::KeywordFalse,
    "null"      => Token::KeywordNull,
);
pub const SINGLE_CHAR_TO_TOKEN: phf::Map<char, Token> = phf::phf_map!(
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

pub const DOUBLE_CHAR_TO_TOKEN: phf::Map<(char, char), Token> = phf::phf_map!(
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

pub const TRIPLE_CHAR_TO_TOKEN: phf::Map<(char, char, char), Token> = phf::phf_map!(
    ('.', '.', '=') => Token::RangeDotsInclusive,
);
#[derive(Debug, Clone, Copy, PartialEq)]
pub struct Symbol(u32);
impl Symbol {
    pub fn new(ind: u32) -> Self {
        Self(ind)
    }
    pub fn to_integer(self, symbol_table: &LexerSymbolTable) -> i128 {
        let s = symbol_table.get(&self);
        unsafe { s.parse::<i128>().unwrap_unchecked() }
    }
    pub fn to_decimal(self, symbol_table: &LexerSymbolTable) -> f64 {
        let s = symbol_table.get(&self);
        unsafe { s.parse::<f64>().unwrap_unchecked() }
    }
    pub fn to_string(self, symbol_table: &LexerSymbolTable) -> String {
        symbol_table.get(&self).to_string()
    }
    pub fn index(&self) -> usize {
        self.0 as usize
    }
}
pub(crate) type Span = std::ops::Range<usize>;

#[derive(Debug, Clone, PartialEq)]
pub struct TokenData {
    pub token: Token,
    pub span: Span,
}
pub static DUMMY_EOF_TOKEN: TokenData = TokenData {
    token: Token::DummyToken,
    span: 0..0,
};
pub fn get_keyword(ident: &str) -> Option<Token> {
    KEYWORDS_TO_TOKENS.get(ident).cloned()
}
pub fn debug_lex_emit(tokens: &Vec<TokenData>, symbol_table: &LexerSymbolTable) {
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
                    str.push_str(&symbol_table.get(symbol));
                }
                Token::String(symbol) => {
                    str.push_str(&format!("\"{}\"", symbol_table.get(symbol)));
                }
                Token::Integer(symbol) => {
                    str.push_str(&format!("\"{}\"", symbol_table.get(symbol)));
                }
                Token::Decimal(symbol) => {
                    str.push_str(&format!("\"{}\"", symbol_table.get(symbol)));
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
#[derive(Debug)]
pub enum LexerError {
    FileNotFound(String),
    FileIsDirectory(String),
    IoError(std::io::Error),
    UnexpectedEOF(String),
    InvalidUtf8,
    UnclosedString(Span),
    UnclosedChar(Span),
    UnclosedComment(Span),
    InvalidNumber(String, Span),
    InvalidCharLiteral(Span),
    InvalidEscapeSequence(Span),
    UnexpectedCharacter(Span),
}
pub type LexerResult<T> = Result<T, LexerError>;
