use core::fmt;
use std::fmt::Write;

use rcsharp_lexer::{Token, TokenData};

use crate::parser::{ParserError, ParserResult, ParserType, Span};
#[derive(Debug, Clone, PartialEq)] 
pub enum Expr {
    Decimal(String),
    Integer(String),
    Name(String),
    StringConst(String),
    Type(ParserType),

    BinaryOp(Box<Expr>, BinaryOp, Box<Expr>),
    UnaryOp(UnaryOp, Box<Expr>),
    Assign(Box<Expr>, Box<Expr>),
    
    Cast(Box<Expr>, ParserType),
    MemberAccess(Box<Expr>, String), 
    StaticAccess(Box<Expr>, String),
    
    NameWithGenerics(Box<Expr>, Box<[ParserType]>),
    
    Call(Box<Expr>, Box<[Expr]>),
    CallGeneric(Box<Expr>, Box<[Expr]>, Box<[ParserType]>),
    Index(Box<Expr>, Box<Expr>),

    Array(Box<[Expr]>),

    Boolean(bool),
    NullPtr,
}
impl Expr {
    pub fn debug_emit(&self) -> String {
        self.debug_emit_int(0)
    }
    fn debug_emit_int(&self, d: u8) -> String {
        let ob = match d % 3 { 0 => "(", 1 => "[", 2 => "{", _ => unreachable!() };
        let cb = match d % 3 { 0 => ")", 1 => "]", 2 => "}", _ => unreachable!() };
        match self {
            Self::Name(n) => n.to_string(),
            Self::Integer(n) => n.to_string(),
            Self::MemberAccess(x, y) => format!("{}.{}", x.debug_emit_int(d), y),
            Self::Index(x, y) => format!("{}[{}]", x.debug_emit_int(d), y.debug_emit_int(d)),
            Self::BinaryOp(l, op, r) => format!("{ob}{} {:?} {}{cb}", l.debug_emit_int(d + 1), op, r.debug_emit_int(d + 1)),
            _ => format!("{:?}", self)
        }
    }
}
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum BinaryOp {
    Add, Subtract, Multiply, Divide, Modulo,
    Equals, NotEqual, Less, LessEqual, Greater, GreaterEqual,
    And, Or, BitAnd, BitOr, BitXor, ShiftLeft, ShiftRight,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum UnaryOp {
    Negate, Not, Deref, Pointer,
}
#[inline(always)]
fn get_precedence(token: &Token) -> u8 {
    match token {
        Token::Equal => 1,
        Token::LogicOr => 2,
        Token::LogicAnd => 3,
        Token::BinaryOr => 4,
        Token::BinaryXor => 5,
        Token::BinaryAnd => 6,
        Token::LogicEqual | Token::LogicNotEqual => 7,
        Token::LogicLess | Token::LogicLessEqual | Token::LogicGreater | Token::LogicGreaterEqual => 8,
        Token::BinaryShiftL | Token::BinaryShiftR => 9,
        Token::Plus | Token::Minus => 10,
        Token::Multiply | Token::Divide | Token::Modulo => 11,
        Token::KeywordAs => 12,
        Token::LogicNot | Token::BinaryNot => 13,
        Token::LParen | Token::LSquareBrace | Token::Dot | Token::DoubleColon => 14,
        _ => 0,
    }
}

pub struct ExpressionParser<'a> {
    tokens: &'a [TokenData],
    cursor: usize,
    len: usize,
    pending_gt: bool,
}
impl<'a> ExpressionParser<'a> {
    pub fn new(tokens: &'a [TokenData]) -> Self {
        Self { tokens, cursor: 0, len: tokens.len(), pending_gt: false  }
    }
    #[inline(always)]
    pub fn is_at_end(&self) -> bool {
        self.cursor >= self.len
    }
    
    #[inline(always)]
    pub fn cursor(&self) -> usize {
        self.cursor
    }
    #[inline(always)]
    fn peek(&self) -> &TokenData {
        if self.cursor < self.len {
            unsafe { self.tokens.get_unchecked(self.cursor) }
        } else {
            static DUMMY_EOF: TokenData = TokenData { 
                token: Token::DummyToken, span: 0..0, row: 0, col: 0
            };
            &DUMMY_EOF
        }
    }
    #[inline(always)]
    fn peek_span(&self) -> Span {
        if self.cursor < self.len {
            let t = unsafe { self.tokens.get_unchecked(self.cursor) };
            Span::new(t.span.start, t.span.end)
        } else if self.len > 0 {
            let last = unsafe { self.tokens.get_unchecked(self.len - 1) };
            Span::new(last.span.end, last.span.end)
        } else {
            Span::new(0, 0)
        }
    }
    #[inline(always)]
    fn advance(&mut self) -> &TokenData {
        if self.cursor < self.len {
            self.cursor += 1;
            unsafe { self.tokens.get_unchecked(self.cursor - 1) }
        } else {
            self.peek()
        }
    }
    #[inline(always)]
    fn consume(&mut self, expected: &Token) -> ParserResult<&TokenData> {
        let token_data = self.peek();
        if &token_data.token == expected {
            Ok(self.advance())
        } else {
            Err((
                self.peek_span(),
                (token_data.row as usize, token_data.col as usize),
                ParserError::UnexpectedToken {
                    expected: format!("{:?}", expected),
                    found: format!("{:?}", token_data.token)
                }
            ))
        }
    }
    #[inline]
    fn consume_name(&mut self) -> ParserResult<String> {
        let token_data = self.peek();
        match &token_data.token {
            Token::Name(name) => {
                let s = name.to_string();
                self.cursor += 1;
                Ok(s)
            },
            _ => {
                let found = format!("{:?}", token_data.token);
                Err((
                    self.peek_span(),
                    (token_data.row as usize, token_data.col as usize),
                    ParserError::ExpectedIdentifier { found }
                ))
            }
        }
    }
    pub fn parse_expression(&mut self) -> ParserResult<Expr> {
        self.parse_expression_with_precedence(0)
    }

    fn parse_expression_with_precedence(&mut self, min_precedence: u8) -> ParserResult<Expr> {
        let mut left = self.parse_prefix()?;
        loop {
            let token_data = self.peek();
            let precedence = get_precedence(&token_data.token);
            if precedence <= min_precedence {
                break;
            }

            left = self.parse_infix(left)?;
        }

        Ok(left)
    }
    
    fn parse_prefix(&mut self) -> ParserResult<Expr> {
        let token_data = self.advance();
        match &token_data.token {
            Token::Integer(val) => Ok(Expr::Integer(val.to_string())),
            Token::Char(val) => Ok(Expr::Integer((*val as u64).to_string())),
            Token::Decimal(val) => Ok(Expr::Decimal(val.to_string())),
            Token::String(val) => Ok(Expr::StringConst(val.to_string())),
            Token::Name(name) => Ok(Expr::Name(name.to_string())),
            
            Token::KeywordTrue => Ok(Expr::Boolean(true)),
            Token::KeywordFalse => Ok(Expr::Boolean(false)),
            Token::KeywordNull => Ok(Expr::NullPtr),

            Token::LParen => {
                let expr = self.parse_expression_with_precedence(0)?;
                self.consume(&Token::RParen)?;
                Ok(expr)
            }

            Token::Minus => self.parse_unary(UnaryOp::Negate),
            Token::LogicNot => self.parse_unary(UnaryOp::Not),
            Token::Multiply => self.parse_unary(UnaryOp::Deref),
            Token::BinaryAnd => self.parse_unary(UnaryOp::Pointer),
            Token::LogicAnd => {
                let inner = self.parse_prefix()?;
                Ok(Expr::UnaryOp(UnaryOp::Pointer, Box::new(Expr::UnaryOp(UnaryOp::Pointer, Box::new(inner)))))
            },
            Token::LSquareBrace =>{
                // tmt = [...]
                let mut args = Vec::new();
                if self.peek().token != Token::RSquareBrace {
                    loop {
                        args.push(self.parse_expression()?);
                        if self.peek().token == Token::Comma {
                            self.advance();
                        } else {
                            break;
                        }
                    }
                }
                self.consume(&Token::RSquareBrace)?;
                Ok(Expr::Array(args.into_boxed_slice()))
            }
            _ => {
                let t = token_data.clone();
                Err((Span::new(t.span.start, t.span.end), (t.row as usize, t.col as usize), ParserError::UnexpectedToken {
                    expected: "expression".to_string(),
                    found: format!("{:?}", t.token)
                }))
            },
        }
    }
    fn parse_unary(&mut self, op: UnaryOp) -> ParserResult<Expr> {
        const PREFIX_PRECEDENCE: u8 = 13;
        let right = self.parse_expression_with_precedence(PREFIX_PRECEDENCE)?;
        Ok(Expr::UnaryOp(op, Box::new(right)))
    }
    fn parse_infix(&mut self, left: Expr) -> ParserResult<Expr> {
        let token_kind = &self.peek().token;
        match token_kind {
            Token::Plus | Token::Minus | Token::Multiply | Token::Divide | Token::Modulo |
            Token::LogicEqual | Token::LogicNotEqual | Token::LogicLess | Token::LogicLessEqual |
            Token::LogicGreater | Token::LogicGreaterEqual | Token::LogicAnd | Token::LogicOr |
            Token::BinaryAnd | Token::BinaryOr | Token::BinaryXor | Token::BinaryShiftL | Token::BinaryShiftR |
            Token::Equal => self.parse_binary(left),
            
            Token::LParen => self.parse_call(left),

            Token::LSquareBrace => self.parse_index(left),
            
            Token::Dot => self.parse_member_access(left),
            Token::DoubleColon => self.parse_static_access_or_generic_call(left),

            Token::KeywordAs => self.parse_cast(left),
            _ => {
                let t = self.peek();
                Err((self.peek_span(), (t.row as usize, t.col as usize), ParserError::UnexpectedToken {
                    expected: "infix operator".to_string(),
                    found: format!("{:?}", t.token)
                }))
            }
        }
    }
    fn parse_binary(&mut self, left: Expr) -> ParserResult<Expr> {
        let op_token = self.advance().clone();
        let precedence = get_precedence(&op_token.token);

        let op = match op_token.token {
            Token::Plus => BinaryOp::Add,
            Token::Minus => BinaryOp::Subtract,
            Token::Multiply => BinaryOp::Multiply,
            Token::Divide => BinaryOp::Divide,
            Token::Modulo => BinaryOp::Modulo,
            Token::LogicEqual => BinaryOp::Equals,
            Token::LogicNotEqual => BinaryOp::NotEqual,
            Token::LogicLess => BinaryOp::Less,
            Token::LogicLessEqual => BinaryOp::LessEqual,
            Token::LogicGreater => BinaryOp::Greater,
            Token::LogicGreaterEqual => BinaryOp::GreaterEqual,
            Token::LogicAnd => BinaryOp::And,
            Token::LogicOr => BinaryOp::Or,
            Token::BinaryAnd => BinaryOp::BitAnd,
            Token::BinaryOr => BinaryOp::BitOr,
            Token::BinaryXor => BinaryOp::BitXor,
            Token::BinaryShiftL => BinaryOp::ShiftLeft,
            Token::BinaryShiftR => BinaryOp::ShiftRight,

            Token::Equal => {
                let right = self.parse_expression_with_precedence(precedence)?;
                return Ok(Expr::Assign(Box::new(left), Box::new(right)));
            }
            _ => unreachable!("Filtered in parse_infix"),
        };
        
        let right = self.parse_expression_with_precedence(precedence)?;
        Ok(Expr::BinaryOp(Box::new(left), op, Box::new(right)))
    }

    fn parse_call(&mut self, callee: Expr) -> ParserResult<Expr> {
        self.advance();
        let mut args = Vec::new();
        if self.peek().token != Token::RParen {
            loop {
                args.push(self.parse_expression()?);
                if self.peek().token == Token::Comma {
                    self.advance();
                } else {
                    break;
                }
            }
        }
        self.consume(&Token::RParen)?;
        Ok(Expr::Call(Box::new(callee), args.into_boxed_slice()))
    }
    fn parse_static_access_or_generic_call(&mut self, left: Expr) -> ParserResult<Expr> {
        self.advance(); // consume ::
        if self.peek().token == Token::LogicLess {
            return self.parse_generic_args_for_call(left);
        }
        let member_name = self.consume_name()?;
        Ok(Expr::StaticAccess(Box::new(left), member_name))
    }

    fn parse_generic_args_for_call(&mut self, callee: Expr) -> ParserResult<Expr> {
        self.consume(&Token::LogicLess)?;
        let mut generic_types = Vec::with_capacity(2);
        
        loop {
            if self.peek().token == Token::BinaryShiftR {
                if self.pending_gt {
                    self.pending_gt = false;
                    self.advance();
                } else {
                    self.pending_gt = true;
                }
                break;
            }
            if self.peek().token == Token::LogicGreater {
                self.advance();
                break;
            }

            generic_types.push(self.parse_type()?);

            match self.peek().token {
                Token::Comma => { self.advance(); },
                Token::LogicGreater | Token::BinaryShiftR => {},
                _ => break, // unexpected, loop will likely terminate or fail in next check
            }
        }

        let next_token = &self.peek().token;

        if next_token == &Token::SemiColon {
            let path_str = expr_to_type_path(&callee);
            return Ok(Expr::Type(ParserType::Generic(path_str, generic_types.into_boxed_slice())));
        }

        if next_token == &Token::LParen {
            self.advance(); // consume LParen
            let mut args = Vec::new();
            if self.peek().token != Token::RParen {
                loop {
                    args.push(self.parse_expression()?);
                    if self.peek().token == Token::Comma {
                        self.advance();
                    } else {
                        break;
                    }
                }
            }
            self.consume(&Token::RParen)?;
            return Ok(Expr::CallGeneric(Box::new(callee), args.into_boxed_slice(), generic_types.into_boxed_slice()));
        }

        Ok(Expr::NameWithGenerics(Box::new(callee), generic_types.into_boxed_slice()))
    }
    fn parse_index(&mut self, left: Expr) -> ParserResult<Expr> {
        self.consume(&Token::LSquareBrace)?;
        let index_expr = self.parse_expression_with_precedence(0)?;
        self.consume(&Token::RSquareBrace)?;
        Ok(Expr::Index(Box::new(left), Box::new(index_expr)))
    }
    fn parse_member_access(&mut self, left: Expr) -> ParserResult<Expr> {
        self.consume(&Token::Dot)?;
        let member_name = self.consume_name()?;
        Ok(Expr::MemberAccess(Box::new(left), member_name))
    }

    fn parse_cast(&mut self, left: Expr) -> ParserResult<Expr> {
        self.consume(&Token::KeywordAs)?;
        Ok(Expr::Cast(Box::new(left), self.parse_type()?))
    }
    pub fn parse_type(&mut self) -> ParserResult<ParserType> {
        let mut pointer_depth = 0;
        loop {
            match self.peek().token {
                Token::BinaryAnd => {
                    pointer_depth += 1;
                    self.advance();
                },
                Token::LogicAnd => {
                    pointer_depth += 2;
                    self.advance();
                },
                _ => break,
            }
        }

        let mut t = if self.peek().token == Token::KeywordFunction {
            self.advance();
            self.consume(&Token::LParen)?;

            let mut arguments = Vec::with_capacity(4);
            if self.peek().token != Token::RParen {
                loop {
                    arguments.push(self.parse_type()?);
                    if self.peek().token == Token::RParen {
                        break;
                    }
                    self.consume(&Token::Comma)?;
                }
            }
            self.consume(&Token::RParen)?;
            self.consume(&Token::Colon)?;
            let return_type = Box::new(self.parse_type()?);
            ParserType::Function(return_type, arguments.into_boxed_slice())
        } else {
            let link_or_name = self.consume_name()?;
            let next = &self.peek().token;
            
            if next == &Token::DoubleColon {
                self.advance();
                ParserType::NamespaceLink(link_or_name, Box::new(self.parse_type()?))
            } else if next == &Token::LogicLess {
                self.advance(); // Consume <
                let mut generic_types = Vec::new();
                loop {
                    if self.peek().token == Token::BinaryShiftR {
                        if self.pending_gt {
                            self.pending_gt = false;
                            self.advance();
                        } else {
                            self.pending_gt = true;
                        }
                        break;
                    }
                    if self.peek().token == Token::LogicGreater {
                        self.advance();
                        break;
                    }
                    
                    generic_types.push(self.parse_type()?);
                    
                    if self.peek().token == Token::Comma {
                        self.advance();
                    }
                }
                ParserType::Generic(link_or_name, generic_types.into_boxed_slice())
            } else {
                ParserType::Named(link_or_name)
            }
        };

        for _ in 0..pointer_depth {
            t = ParserType::Pointer(Box::new(t));
        }
        
        Ok(t)
    }
}
fn expr_to_type_path(callee: &Expr) -> String {
    let mut s = String::new();
    let _ = write_expr_path(&mut s, callee);
    s
}
fn write_expr_path(w: &mut String, expr: &Expr) -> fmt::Result {
    match expr {
        Expr::Name(x) => w.write_str(x),
        Expr::StaticAccess(base, member) => {
            write_expr_path(w, base)?;
            write!(w, ".{}", member)
        }
        _ => w.write_str("<?>"),
    }
}