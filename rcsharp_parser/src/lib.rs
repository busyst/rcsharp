use std::collections::VecDeque;

use rcsharp_lexer::{
    Lexer,
    defs::{Token, TokenKind},
};
use rcsharp_syntax::{Diagnostic, SourceFile, Span, Symbol};

use crate::defs::StmtData;

pub mod defs;
pub mod expression_parser;
pub mod parser;

pub struct Parser<'lex, 'src, 'int> {
    pub(crate) src_file: &'lex SourceFile,
    pub(crate) src: &'lex mut Lexer<'src, 'int>,
    buffer: VecDeque<Token>,
    pub(crate) last_span: Span,
    pub(crate) pending_gt: bool,
    pub diags: Vec<Diagnostic>,
    panic_mode: bool,
}

impl<'lex, 'src, 'int> Parser<'lex, 'src, 'int> {
    pub fn new(src_file: &'lex SourceFile, src: &'lex mut Lexer<'src, 'int>) -> Self {
        Self {
            src_file,
            src,
            buffer: VecDeque::new(),
            last_span: Span::new(0, 0),
            pending_gt: false,
            diags: Vec::new(),
            panic_mode: false,
        }
    }

    // --- Cursor & Lookahead ---

    pub fn peek_nth(&mut self, n: usize) -> Token {
        while self.buffer.len() <= n {
            if let Some(last) = self.buffer.back() {
                if last.kind == TokenKind::EOF {
                    return *last;
                }
            }
            self.buffer.push_back(self.src.next_token());
        }
        self.buffer[n]
    }

    #[inline]
    pub fn peek(&mut self) -> Token {
        self.peek_nth(0)
    }

    #[inline]
    pub fn at(&mut self, kind: TokenKind) -> bool {
        self.peek().kind == kind
    }

    #[inline]
    pub fn is_eof(&mut self) -> bool {
        self.at(TokenKind::EOF)
    }

    pub fn bump(&mut self) -> Token {
        let tok = self
            .buffer
            .pop_front()
            .unwrap_or_else(|| self.src.next_token());
        if tok.kind != TokenKind::EOF {
            self.last_span = tok.span;
        }
        tok
    }

    pub fn eat(&mut self, kind: TokenKind) -> bool {
        if self.at(kind) {
            self.bump();
            true
        } else {
            false
        }
    }

    pub fn eat_while(&mut self, mut pred: impl FnMut(&TokenKind) -> bool) {
        while !self.is_eof() && pred(&self.peek().kind) {
            self.bump();
        }
    }

    #[inline]
    pub fn span_from(&self, start: Span) -> Span {
        start.to(self.last_span)
    }

    // --- Diagnostics & Error Recovery ---

    pub fn error(&mut self, span: Span, msg: &str) {
        if self.panic_mode {
            return;
        }
        self.panic_mode = true;
        self.diags.push(Diagnostic::error(self.src_file, msg, span));
    }

    pub fn expect(&mut self, expected: TokenKind, msg: &str) -> Result<Token, ()> {
        let tok = self.peek();
        if tok.kind == expected {
            Ok(self.bump())
        } else {
            self.error(tok.span, msg);
            Err(())
        }
    }

    pub fn expect_semicolon(&mut self) -> Result<Token, ()> {
        self.expect(TokenKind::SemiColon, "Expected ';'")
    }

    pub fn expect_name(&mut self, msg: &str) -> Result<(Symbol, Span), ()> {
        let tok = self.peek();
        match tok.kind {
            TokenKind::Name(sym) => {
                self.bump();
                Ok((sym, tok.span))
            }
            _ => {
                self.error(tok.span, msg);
                Err(())
            }
        }
    }

    pub fn synchronize(&mut self) {
        self.panic_mode = false;
        self.pending_gt = false;
        while !self.is_eof() {
            if self.eat(TokenKind::SemiColon) {
                return;
            }
            match self.peek().kind {
                TokenKind::RBrace
                | TokenKind::Hash
                | TokenKind::KeywordNamespace
                | TokenKind::KeywordPub
                | TokenKind::KeywordInline
                | TokenKind::KeywordConstExpr
                | TokenKind::KeywordExtern
                | TokenKind::KeywordFunction
                | TokenKind::KeywordStruct
                | TokenKind::KeywordEnum
                | TokenKind::KeywordTrait
                | TokenKind::KeywordImpl
                | TokenKind::KeywordStatic
                | TokenKind::KeywordConst
                | TokenKind::KeywordLet
                | TokenKind::KeywordReturn
                | TokenKind::KeywordIf
                | TokenKind::KeywordWhile
                | TokenKind::KeywordFor
                | TokenKind::KeywordLoop
                | TokenKind::KeywordMatch => return,
                _ => {
                    self.bump();
                }
            }
        }
    }
}

impl Iterator for Parser<'_, '_, '_> {
    type Item = StmtData;

    fn next(&mut self) -> Option<StmtData> {
        self.next_toplevel_item()
    }
}

pub fn parse_full<'src, 'int>(
    src_file: &SourceFile,
    lexer: &mut Lexer<'src, 'int>,
) -> (Vec<StmtData>, Vec<Diagnostic>) {
    let mut parser = Parser::new(src_file, lexer);
    let statements = parser.parse_all();
    (statements, parser.diags)
}
