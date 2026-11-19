pub mod defs;
use rcsharp_syntax::{Diagnostic, Interner, SourceFile};

use crate::defs::{
    DOUBLE_CHAR_TO_TOKEN, SINGLE_CHAR_TO_TOKEN, TRIPLE_CHAR_TO_TOKEN, Token, get_keyword,
};
use std::{
    fs::{self},
    str::Chars,
};

pub struct Lexer<'src, 'int> {
    src: &'src str,
    chars: Chars<'src>,
    interner: &'int mut Interner,
    diags: Vec<Diagnostic>,
}

impl<'src, 'int> Lexer<'src, 'int> {
    pub fn new(src: &'src str, interner: &'int mut Interner) -> Self {
        Self {
            src,
            chars: src.chars(),
            interner,
            diags: Vec::new(),
        }
    }
    fn pos(&self) -> usize {
        self.src.len() - self.chars.as_str().len()
    }
    fn rest(&self) -> &'src str {
        self.chars.as_str()
    }
    fn peek(&self) -> Option<char> {
        self.chars.clone().next()
    }
    fn peek_second(&self) -> Option<char> {
        let mut iter = self.chars.clone();
        iter.next();
        iter.next()
    }
    fn bump(&mut self) -> Option<char> {
        self.chars.next()
    }
    fn eat_while(&mut self, mut pred: impl FnMut(char) -> bool) {
        while let Some(c) = self.peek() {
            if !pred(c) {
                break;
            }
            self.bump();
        }
    }
    fn lex_number(&mut self, start: usize, first: char) -> Token {
        if first == '0' {
            let radix_pred: Option<fn(char) -> bool> = match self.peek() {
                Some('b') => Some(|c| c == '0' || c == '1'),
                Some('o') => Some(|c| ('0'..='7').contains(&c)),
                Some('x') => Some(|c| c.is_ascii_hexdigit()),
                _ => None,
            };
            if let Some(is_digit) = radix_pred {
                if self.peek_second().is_some_and(is_digit) {
                    self.bump();
                    self.eat_while(|c| is_digit(c) || c == '_');
                    let sym = self.interner.intern_number(&self.src[start..self.pos()]);
                    return Token::Integer(sym);
                }
            }
        }

        self.eat_while(|c| c.is_ascii_digit() || c == '_');

        let mut is_float = false;
        if self.peek() == Some('.') && self.peek_second().is_some_and(|c| c.is_ascii_digit()) {
            is_float = true;
            self.bump();
            self.eat_while(|c| c.is_ascii_digit() || c == '_');
        }

        let sym = self.interner.intern_number(&self.src[start..self.pos()]);
        if is_float {
            Token::Decimal(sym)
        } else {
            Token::Integer(sym)
        }
    }
    fn lex_quoted(&mut self, start: usize, quote: char, what: &str) -> Option<&'src str> {
        let src = self.src;
        let mut escaped = false;
        loop {
            match self.bump() {
                None => {
                    self.error(&format!("Unterminated {what}"), start, src.len());
                    return None;
                }
                Some(_) if escaped => escaped = false,
                Some('\\') => escaped = true,
                Some(c) if c == quote => return Some(&src[start + 1..self.pos() - 1]),
                Some(_) => {}
            }
        }
    }
    fn next_token(&mut self) -> Token {
        loop {
            self.eat_while(|c| c.is_whitespace());
            let start = self.pos();
            let Some(c) = self.bump() else {
                return Token::EOF;
            };

            if c.is_ascii_digit() {
                return self.lex_number(start, c);
            }
            if c.is_alphabetic() || c == '_' {
                self.eat_while(|c| c.is_alphanumeric() || c == '_');
                let src = self.src;
                let text = &src[start..self.pos()];
                return match get_keyword(text) {
                    Some(tok) => tok,
                    None => Token::Name(self.interner.intern(text)),
                };
            }
            if c == '"' {
                let Some(raw) = self.lex_quoted(start, '"', "string literal") else {
                    continue;
                };
                match Self::unescape_content(raw) {
                    Some(s) => {
                        return Token::String(self.interner.intern(&s));
                    }
                    None => {
                        let end = self.pos();
                        self.error("Invalid escape sequence", start, end);
                        continue;
                    }
                }
            }
            if c == '\'' {
                let Some(raw) = self.lex_quoted(start, '\'', "char literal") else {
                    continue;
                };
                let end = self.pos();
                match Self::unescape_content(raw) {
                    Some(s) => {
                        let mut it = s.chars();
                        match (it.next(), it.next()) {
                            (Some(ch), None) => return Token::Char(ch as u32),
                            _ => self.error("Invalid char literal", start, end),
                        }
                    }
                    None => self.error("Invalid escape sequence", start, end),
                }
                continue;
            }
            if c == '/' {
                match self.peek() {
                    Some('/') => {
                        self.eat_while(|c| c != '\n');
                        continue;
                    }
                    Some('*') => {
                        self.bump();
                        match self.rest().find("*/") {
                            Some(i) => {
                                self.chars = self.src[self.pos() + i + 2..].chars();
                            }
                            None => {
                                self.chars = self.src[self.src.len()..].chars();
                                self.diags.push(Diagnostic::error(
                                    &SourceFile::unspecified(),
                                    "Unterminated block comment",
                                    rcsharp_syntax::Span::new(start, self.src.len()),
                                ));
                            }
                        }
                        continue;
                    }
                    _ => {}
                }
            }
            if let (Some(c2), Some(c3)) = (self.peek(), self.peek_second()) {
                if let Some(tok) = TRIPLE_CHAR_TO_TOKEN.get(&(c, c2, c3)) {
                    self.bump();
                    self.bump();
                    return tok.clone();
                }
            }
            if let Some(c2) = self.peek() {
                if let Some(tok) = DOUBLE_CHAR_TO_TOKEN.get(&(c, c2)) {
                    self.bump();
                    return tok.clone();
                }
            }
            if let Some(tok) = SINGLE_CHAR_TO_TOKEN.get(&c) {
                return tok.clone();
            }
            self.diags.push(Diagnostic::error(
                &SourceFile::unspecified(),
                &format!("Unexpected character: {:?}", c),
                rcsharp_syntax::Span::new(start, self.pos()),
            ));
        }
    }
    fn unescape_content(content: &str) -> Option<String> {
        let mut out = String::with_capacity(content.len());
        let mut chars = content.chars().peekable();

        while let Some(c) = chars.next() {
            if c != '\\' {
                out.push(c);
                continue;
            }
            match chars.next()? {
                'n' => out.push('\n'),
                'v' => out.push('\x0B'),
                'f' => out.push('\x0C'),
                't' => out.push('\t'),
                'r' => out.push('\r'),
                '\\' => out.push('\\'),
                '"' => out.push('"'),
                '\'' => out.push('\''),
                d @ '0'..='7' => {
                    let mut oct = String::from(d);
                    for _ in 0..2 {
                        match chars.peek() {
                            Some(&c) if ('0'..='7').contains(&c) => {
                                oct.push(c);
                                chars.next();
                            }
                            _ => break,
                        }
                    }
                    out.push(u8::from_str_radix(&oct, 8).ok()? as char);
                }
                'x' => {
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
                    if hex.len() != 2 {
                        return None;
                    }
                    out.push(u8::from_str_radix(&hex, 16).ok()? as char);
                }
                'u' => {
                    if chars.next()? != '{' {
                        return None;
                    }
                    let mut hex = String::new();
                    loop {
                        match chars.next()? {
                            '}' => break,
                            c if c.is_ascii_hexdigit() => hex.push(c),
                            _ => return None,
                        }
                    }
                    out.push(char::from_u32(u32::from_str_radix(&hex, 16).ok()?)?);
                }
                _ => return None,
            }
        }
        Some(out)
    }
    fn error(&mut self, msg: &str, start: usize, end: usize) {
        self.diags.push(Diagnostic::error(
            &SourceFile::unspecified(),
            msg,
            rcsharp_syntax::Span::new(start, end),
        ));
    }
}
impl Iterator for Lexer<'_, '_> {
    type Item = Token;

    fn next(&mut self) -> Option<Token> {
        match self.next_token() {
            Token::EOF => None,
            tok => Some(tok),
        }
    }
}
pub fn lex(
    src_file: &SourceFile,
    interner: &mut Interner,
) -> (Vec<Token>, Vec<Diagnostic>) {
    let src_data = match fs::read(&src_file.path) {
        Ok(data) => data,
        Err(err) => {
            return (
                vec![],
                Diagnostic::fatal(src_file, "Unable to read file", err),
            );
        }
    };
    let src = match std::str::from_utf8(&src_data) {
        Ok(s) => s,
        Err(err) => {
            return (
                vec![],
                Diagnostic::fatal(src_file, "Unable to decode file in UTF-8 encoding", err),
            );
        }
    };
    let mut lexer = Lexer::new(src, interner);
    let tokens: Vec<Token> = lexer.by_ref().collect();
    (tokens, lexer.diags)
}
