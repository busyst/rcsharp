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
    
    Call(Box<Expr>, Box<[Expr]>),
    CallGeneric(Box<Expr>, Box<[Expr]>, Box<[ParserType]>),
    Index(Box<Expr>, Box<Expr>),
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
}
impl<'a> ExpressionParser<'a> {
    pub fn new(tokens: &'a [TokenData]) -> Self {
        Self { tokens, cursor: 0 }
    }

    pub fn is_at_end(&self) -> bool {
        self.cursor >= self.tokens.len()
    }

    pub fn cursor(&self) -> usize {
        self.cursor
    }

    fn peek(&self) -> &TokenData {
        static DUMMY_EOF: TokenData = TokenData { 
            token: Token::DummyToken,
            span: 0..0,
            row: 0,
            col: 0
        };
        self.tokens.get(self.cursor).unwrap_or(&DUMMY_EOF)
    }
    fn peek_span(&self) -> Span {
        Span::new(self.cursor, self.cursor + 1)
    }
    
    fn advance(&mut self) -> &TokenData {
        if !self.is_at_end() {
            self.cursor += 1;
        }
        &self.tokens[self.cursor - 1]
    }
    fn consume(&mut self, expected: &Token) -> ParserResult<&TokenData> {
        let token_data = self.peek();
        if &token_data.token != expected {
            return Err((
                self.peek_span(),
                (token_data.row as usize, token_data.col as usize),
                ParserError::UnexpectedToken {
                    expected: format!("{:?}", expected),
                    found: format!("{:?}", token_data.token)
                }
            ));
        }
        Ok(self.advance())
    }
    fn consume_name(&mut self) -> ParserResult<String> {
        let token_data = self.peek();
        match &token_data.token {
            Token::Name(name) => {
                let name = name.to_string();
                self.advance();
                Ok(name)
            },
            _ => {
                let found = format!("{:?}", token_data.token);
                Err((
                    Span::new(self.cursor, self.cursor + 1),
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

        while !self.is_at_end() && min_precedence < get_precedence(&self.peek().token) {
            left = self.parse_infix(left)?;
        }

        Ok(left)
    }
    
    fn parse_prefix(&mut self) -> ParserResult<Expr> {
        let token_data = self.advance().clone();
        match &token_data.token {
            Token::Integer(val) => Ok(Expr::Integer(val.to_string())),
            Token::Char(val) => Ok(Expr::Integer((val.parse::<char>().unwrap() as u64).to_string())),
            Token::Decimal(val) => Ok(Expr::Decimal(val.to_string())),
            Token::String(val) => Ok(Expr::StringConst(val.to_string())),
            Token::Name(name) => Ok(Expr::Name(name.to_string())),

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
                Ok(Expr::UnaryOp(UnaryOp::Pointer, Box::new(Expr::UnaryOp(UnaryOp::Pointer, Box::new(self.parse_prefix()?)))))
            },
            _ => Err((self.peek_span(), (token_data.row as usize, token_data.col as usize), ParserError::UnexpectedToken {
                expected: "expression".to_string(),
                found: format!("{:?}", token_data.token)
            })),
        }
    }
    fn parse_unary(&mut self, op: UnaryOp) -> ParserResult<Expr> {
        let precedence = 13;
        let right = self.parse_expression_with_precedence(precedence)?;
        Ok(Expr::UnaryOp(op, Box::new(right)))
    }
    fn parse_infix(&mut self, left: Expr) -> ParserResult<Expr> {
        let token_data = &self.peek().clone();
        match &token_data.token {
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
            _ => Err((self.peek_span(), (token_data.row as usize, token_data.col as usize), ParserError::UnexpectedToken {
                expected: "expression".to_string(),
                found: format!("{:?}", token_data.token)
            })),
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
            _ => return Err((self.peek_span(), (op_token.row as usize, op_token.col as usize), ParserError::UnexpectedToken {
                expected: "binary operator".to_string(),
                found: format!("{:?}", op_token.token)
            })),
        };
        
        let right = self.parse_expression_with_precedence(precedence)?;
        Ok(Expr::BinaryOp(Box::new(left), op, Box::new(right)))
    }

    fn parse_call(&mut self, callee: Expr) -> ParserResult<Expr> {
        self.consume(&Token::LParen)?;
        if callee == Expr::Name("sizeof".to_string()) {
            let t = self.parse_type()?;
            self.consume(&Token::RParen)?; 
            return Ok(Expr::Call(Box::new(callee), Box::new([Expr::Type(t)])));
        }
        let mut args = Vec::new();
        if self.peek().token != Token::RParen {
            loop {
                args.push(self.parse_expression()?);
                if self.peek().token != Token::Comma {
                    break;
                }
                self.advance();
            }
        }

        self.consume(&Token::RParen)?;
        Ok(Expr::Call(Box::new(callee), args.into_boxed_slice()))
    }
    fn parse_generic_call(&mut self, callee: Expr) -> ParserResult<Expr> {
        self.advance();
        self.consume(&Token::DoubleColon)?;
        self.consume(&Token::LogicLess)?;
        let mut generic_types = vec![];
        loop {
            if self.peek().token == Token::LogicGreater {
                self.advance();
                break;
            }
            if self.peek().token == Token::BinaryShiftR {
                todo!()
            }
            let t= self.parse_type()?;
            generic_types.push(t);
            if self.peek().token == Token::Comma {
                self.advance();
            }
        }
        if self.peek().token == Token::SemiColon {
            return Ok(Expr::Type(ParserType::Generic(exprtoparsertype(&callee), generic_types.into())));
        }
        self.consume(&Token::LParen)?;
        let mut args = Vec::new();
        if self.peek().token != Token::RParen {
            loop {
                args.push(self.parse_expression()?);
                if self.peek().token != Token::Comma {
                    break;
                }
                self.advance();
            }
        }

        self.consume(&Token::RParen)?;
        Ok(Expr::CallGeneric(Box::new(callee), args.into(), generic_types.into()))
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
        if self.peek().token == Token::LogicAnd {
            self.advance();
            Ok(ParserType::Pointer(Box::new(ParserType::Pointer(Box::new(self.parse_type()?)))))
        }
        else if self.peek().token == Token::BinaryAnd {
            self.advance();
            Ok(ParserType::Pointer(Box::new(self.parse_type()?)))
        }
        else if self.peek().token == Token::KeywordFunction {
            self.advance();
            self.consume(&Token::LParen)?;

            let mut arguments = vec![];
            
            
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
            Ok(ParserType::Function(return_type, arguments.into_boxed_slice()))
        }
        else {
            let link_or_name = self.consume_name()?;
            if self.peek().token == Token::DoubleColon {
                self.advance();
                return Ok(ParserType::NamespaceLink(link_or_name, Box::new(self.parse_type()?)))
            }
            if self.peek().token == Token::LogicLess {
                self.consume(&Token::LogicLess)?;
                let mut generic_types = vec![];
                loop {
                    if self.peek().token == Token::LogicGreater {
                        self.advance();
                        break;
                    }
                    if self.peek().token == Token::BinaryShiftR {
                        todo!()
                    }
                    let t= self.parse_type()?;
                    generic_types.push(t);
                    if self.peek().token == Token::Comma {
                        self.advance();
                    }
                    
                }
                return Ok(ParserType::Generic(link_or_name, generic_types.into_boxed_slice()));
            }
            Ok(ParserType::Named(link_or_name))
        }
    }
    fn parse_static_access_or_generic_call(&mut self, left: Expr) -> ParserResult<Expr> {
        self.consume(&Token::DoubleColon)?;
        if self.peek().token == Token::LogicLess {
            self.cursor -= 2;
            return self.parse_generic_call(left);
        }
        let member_name = self.consume_name()?;

        Ok(Expr::StaticAccess(Box::new(left), member_name))
    }
}

fn exprtoparsertype(callee: &Expr) -> String {
    if let Expr::Name(x) = callee {
        return x.to_string();
    }
    if let Expr::StaticAccess(x, y) = callee {
        return format!("{}.{}", exprtoparsertype(x), y);
    }
    todo!("{:?}", callee)
}