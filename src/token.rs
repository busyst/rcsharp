use logos::{Logos, Lexer as LogosLexer, Span};
use std::fmt;

// --- Step 1: Define structs for location and error reporting ---

/// Represents a location in the source code (1-based).
#[derive(Debug, Default, Clone, Copy, PartialEq, Eq)]
pub struct Location {
    pub row: u32,
    pub col: u32,
}

/// A token bundled with its location information.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct TokenData {
    pub token: Token,
    /// The byte range in the source string.
    pub span: Span,
    /// The starting location (row, col) of the token.
    pub loc: Location,
}

/// An error that occurred during lexing.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct LexingError {
    /// The byte range of the invalid token.
    pub span: Span,
    /// The location (row, col) where the error occurred.
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


// --- Step 2: Modify the Token enum ---
// We remove the `#[logos(skip...)]` attributes and add variants for whitespace and comments.
#[derive(Logos, Debug, Clone, PartialEq, Eq)]
pub enum Token {
    // --- SKIPPABLE TOKENS (now explicit) ---
    #[regex(r"[ \t\f]+")]
    Whitespace,

    #[token("\n")]
    Newline,

    #[regex(r"//[^\n]*")]
    LineComment,

    #[regex(r"/\*([^*]|\*[^/])*\*/")]
    BlockComment,

    // --- ORIGINAL TOKENS (unchanged) ---
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
    #[token("let")] KeywordVariable,
    #[token("as")] KeywordAs,
    #[token("if")] KeywordIf,
    #[token("else")] KeywordElse,
    #[token("struct")] KeywordStruct,
    #[token("loop")] KeywordLoop,
    #[token("break")] KeywordBreak,
    #[token("continue")] KeywordContinue,
    #[token("return")] KeywordReturn,
    UnaryOpMark,
    DummyToken,

    #[regex(r"[a-zA-Z_][a-zA-Z0-9_]*", |lex| lex.slice().to_string().into_boxed_str())]
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

    /// Helper function to advance the location based on the token's text.
    fn advance_loc(&mut self, slice: &str) {
        let newlines = slice.bytes().filter(|&b| b == b'\n').count();
        if newlines > 0 {
            self.loc.row += newlines as u32;
            // The new column is the number of chars after the last newline.
            let last_newline = slice.rfind('\n').unwrap(); // Safe due to check above
            self.loc.col = slice[last_newline + 1..].chars().count() as u32 + 1;
        } else {
            // No newlines, just advance the column by the number of chars.
            self.loc.col += slice.chars().count() as u32;
        }
    }
}

// --- Step 4: Implement the Iterator trait for our Lexer ---
impl<'source> Iterator for Lexer<'source> {
    type Item = Result<TokenData, LexingError>;

    fn next(&mut self) -> Option<Self::Item> {
        loop {
            // Get the next token from logos, or None if we're at the end.
            let token_result = self.logos.next()?;
            let span = self.logos.span();
            let slice = self.logos.slice();

            // The location of the *current* token is what we have *before* advancing.
            let start_loc = self.loc;

            // Now, advance our internal location counter for the *next* token.
            self.advance_loc(slice);

            match token_result {
                // On error, create our custom error type with location info.
                Err(_) => {
                    let err = LexingError { span, loc: start_loc };
                    return Some(Err(err));
                }
                
                // For tokens we want to skip, we just loop again.
                // The location has been advanced, so we're ready for the next one.
                Ok(Token::Whitespace) | Ok(Token::Newline) | Ok(Token::LineComment) | Ok(Token::BlockComment) => {
                    continue;
                }
                
                // This is a "real" token, so we bundle it and return.
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
    // Slice off the surrounding quotes, which the regex guarantees are present.
    let content = &slice[1..slice.len() - 1];

    let mut unescaped = String::with_capacity(content.len());
    let mut chars = content.chars();

    while let Some(c) = chars.next() {
        if c == '\\' {
            // It's an escape sequence. Look at the next character.
            match chars.next() {
                Some('n') => unescaped.push('\n'),
                Some('t') => unescaped.push('\t'),
                Some('r') => unescaped.push('\r'),
                Some('\\') => unescaped.push('\\'),
                Some('"') => unescaped.push('"'),
                // For any other character following a backslash,
                // we just push that character.
                Some(other) => unescaped.push(other),
                // This case handles a dangling backslash at the end of the string.
                None => break,
            }
        } else {
            // It's a regular character.
            unescaped.push(c);
        }
    }

    unescaped.into_boxed_str()
}