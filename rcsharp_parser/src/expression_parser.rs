use std::fmt::Write;

use rcsharp_lexer::{
    LexerSymbolTable,
    defs::{DUMMY_EOF_TOKEN, Token, TokenData},
};

use crate::{
    defs::{ParserError, ParserResult},
    parser::ParserType,
};

#[derive(Debug, Clone, PartialEq)]
pub enum Expr {
    Decimal(f64),
    Integer(i128),
    Name(String),
    StringConst(String),
    Type(Box<ParserType>),

    BinaryOp(Box<Expr>, BinaryOp, Box<Expr>),
    UnaryOp(UnaryOp, Box<Expr>),
    Assign(Box<Expr>, Box<Expr>),

    Cast(Box<Expr>, Box<ParserType>),
    MemberAccess(Box<Expr>, String),
    StaticAccess(Box<Expr>, String),

    NameWithGenerics(Box<Expr>, Box<[ParserType]>),

    Call(Box<Expr>, Box<[Expr]>, Option<Box<[ParserType]>>),
    MemberCall(Box<Expr>, String, Box<[Expr]>, Option<Box<[ParserType]>>),
    MacroCall(Box<Expr>, Box<[Expr]>),
    Index(Box<Expr>, Box<Expr>),

    Array(Box<[Expr]>),

    StructInit(Box<Expr>, Box<[(String, Expr)]>),
    Range(Box<Expr>, Box<Expr>, bool),
    Boolean(bool),
    NullPtr,
}
impl Expr {
    pub fn debug_emit(&self) -> String {
        self.debug_emit_inner(0)
    }

    fn debug_emit_inner(&self, depth: u8) -> String {
        let (open, close) = match depth % 3 {
            0 => ("(", ")"),
            1 => ("[", "]"),
            _ => ("{", "}"),
        };
        match self {
            Self::Name(n) => n.clone(),
            Self::Integer(n) => n.to_string(),
            Self::Call(callee, args, None) => {
                let args_str = args
                    .iter()
                    .map(|a| a.debug_emit_inner(1))
                    .collect::<Vec<_>>()
                    .join(", ");
                format!("CALL|[{}]({})|", callee.debug_emit_inner(depth), args_str)
            }
            Self::Call(callee, args, Some(generics)) => {
                let args_str = args
                    .iter()
                    .map(|a| a.debug_emit_inner(1))
                    .collect::<Vec<_>>()
                    .join(", ");
                let x_str = generics
                    .iter()
                    .map(|a| format!("{:?}", a))
                    .collect::<Vec<_>>()
                    .join(", ");
                format!(
                    "CALLGEN{{{}}}|[{}]({})|",
                    x_str,
                    callee.debug_emit_inner(depth),
                    args_str
                )
            }
            Self::MemberAccess(base, member) => {
                format!("{}.{member}", base.debug_emit_inner(depth))
            }
            Self::StaticAccess(base, member) => {
                format!("{}::{member}", base.debug_emit_inner(depth))
            }
            Self::Index(base, idx) => {
                format!(
                    "{}[{}]",
                    base.debug_emit_inner(depth),
                    idx.debug_emit_inner(depth)
                )
            }
            Self::BinaryOp(l, op, r) => format!(
                "{open}{} {op:?} {}{close}",
                l.debug_emit_inner(depth + 1),
                r.debug_emit_inner(depth + 1),
            ),
            _ => format!("{self:?}"),
        }
    }
}
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum BinaryOp {
    Add,
    Subtract,
    Multiply,
    Divide,
    Modulo,
    Equals,
    NotEqual,
    Less,
    LessEqual,
    Greater,
    GreaterEqual,
    And,
    Or,
    BitAnd,
    BitOr,
    BitXor,
    ShiftLeft,
    ShiftRight,
}
impl BinaryOp {
    pub fn is_symmetric(self) -> bool {
        matches!(
            self,
            Self::Add
                | Self::Multiply
                | Self::BitAnd
                | Self::BitOr
                | Self::BitXor
                | Self::And
                | Self::Or
                | Self::Equals
                | Self::NotEqual
        )
    }
}
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum UnaryOp {
    Negate,
    Not,
    Deref,
    Pointer,
}
#[inline]
fn precedence(token: &Token) -> u8 {
    match token {
        Token::Equal | Token::RangeDots | Token::RangeDotsInclusive => 1,
        Token::LogicOr => 2,
        Token::LogicAnd => 3,
        Token::BinaryOr => 4,
        Token::BinaryXor => 5,
        Token::BinaryAnd => 6,
        Token::LogicEqual | Token::LogicNotEqual => 7,
        Token::LogicLess
        | Token::LogicLessEqual
        | Token::LogicGreater
        | Token::LogicGreaterEqual => 8,
        Token::BinaryShiftL | Token::BinaryShiftR => 9,
        Token::Plus | Token::Minus => 10,
        Token::Multiply | Token::Divide | Token::Modulo => 11,
        Token::KeywordAs => 12,
        Token::LogicNot | Token::BinaryNot => 13,
        Token::LParen | Token::LSquareBrace | Token::Dot | Token::DoubleColon => 14,
        _ => 0,
    }
}
const PREFIX_PRECEDENCE: u8 = 13;

pub struct ExpressionParser<'a> {
    tokens: &'a [TokenData],
    symbol_table: &'a LexerSymbolTable,
    cursor: usize,
    pending_gt: bool,
}

impl<'a> ExpressionParser<'a> {
    pub fn new(tokens: &'a [TokenData], symbol_table: &'a LexerSymbolTable) -> Self {
        Self {
            tokens,
            symbol_table,
            cursor: 0,
            pending_gt: false,
        }
    }
    #[inline]
    pub fn is_at_end(&self) -> bool {
        self.cursor >= self.tokens.len()
    }

    #[inline]
    pub fn cursor(&self) -> usize {
        self.cursor
    }
    #[inline]
    fn peek(&self) -> &TokenData {
        self.tokens.get(self.cursor).unwrap_or(&DUMMY_EOF_TOKEN)
    }

    #[inline]
    fn advance(&mut self) -> &TokenData {
        match self.tokens.get(self.cursor) {
            Some(t) => {
                self.cursor += 1;
                t
            }
            None => &DUMMY_EOF_TOKEN,
        }
    }
    #[inline]
    fn consume(&mut self, expected: &Token) -> ParserResult<&TokenData> {
        if &self.peek().token == expected {
            Ok(self.advance())
        } else {
            Err((
                self.cursor..self.cursor + 1,
                if *expected == Token::SemiColon {
                    ParserError::ExpectedSemicolon
                } else {
                    ParserError::UnexpectedToken {
                        expected: format!("{expected:?}"),
                        found: self.peek().token.clone(),
                    }
                },
            ))
        }
    }

    #[inline]
    fn consume_name(&mut self) -> ParserResult<String> {
        match &self.peek().token {
            Token::Name(sym) => {
                let name = self.symbol_table.get(sym).to_string();
                self.cursor += 1;
                Ok(name)
            }
            _ => Err((
                self.cursor..self.cursor + 1,
                ParserError::ExpectedIdentifier,
            )),
        }
    }
    pub fn parse_expression(&mut self) -> ParserResult<Expr> {
        self.parse_with_precedence(0)
    }

    fn parse_with_precedence(&mut self, min_precedence: u8) -> ParserResult<Expr> {
        let mut left = self.parse_prefix()?;
        loop {
            if precedence(&self.peek().token) <= min_precedence {
                break;
            }
            left = self.parse_infix(left)?;
        }
        Ok(left)
    }

    fn parse_prefix(&mut self) -> ParserResult<Expr> {
        let span = self.cursor..self.cursor + 1;
        let token = self.advance().token.clone();

        match token {
            Token::Integer(sym) => Ok(Expr::Integer(sym.to_integer(self.symbol_table))),
            Token::Char(c) => Ok(Expr::Integer(c as i128)),
            Token::Decimal(sym) => Ok(Expr::Decimal(sym.to_decimal(self.symbol_table))),
            Token::String(sym) => Ok(Expr::StringConst(sym.to_string(self.symbol_table))),
            Token::Name(sym) => Ok(Expr::Name(self.symbol_table.get(&sym).to_string())),

            Token::KeywordTrue => Ok(Expr::Boolean(true)),
            Token::KeywordFalse => Ok(Expr::Boolean(false)),
            Token::KeywordNull => Ok(Expr::NullPtr),

            Token::LParen => {
                let expr = self.parse_with_precedence(0)?;
                self.consume(&Token::RParen)?;
                Ok(expr)
            }

            Token::Minus => self.parse_unary(UnaryOp::Negate),
            Token::LogicNot => self.parse_unary(UnaryOp::Not),
            Token::Multiply => self.parse_unary(UnaryOp::Deref),
            Token::BinaryAnd => self.parse_unary(UnaryOp::Pointer),

            // `&&expr` → `&(&expr)` — double-reference shorthand.
            Token::LogicAnd => {
                let inner = self.parse_prefix()?;
                Ok(Expr::UnaryOp(
                    UnaryOp::Pointer,
                    Box::new(Expr::UnaryOp(UnaryOp::Pointer, Box::new(inner))),
                ))
            }

            Token::LSquareBrace => self.parse_array_literal(),

            _ => Err((
                span,
                ParserError::UnexpectedToken {
                    expected: "expression".into(),
                    found: token,
                },
            )),
        }
    }
    fn parse_unary(&mut self, op: UnaryOp) -> ParserResult<Expr> {
        let operand = self.parse_with_precedence(PREFIX_PRECEDENCE)?;
        Ok(Expr::UnaryOp(op, Box::new(operand)))
    }

    fn parse_array_literal(&mut self) -> ParserResult<Expr> {
        let mut elements = Vec::new();
        if self.peek().token != Token::RSquareBrace {
            loop {
                elements.push(self.parse_expression()?);
                if self.peek().token == Token::Comma {
                    self.advance();
                } else {
                    break;
                }
            }
        }
        self.consume(&Token::RSquareBrace)?;
        Ok(Expr::Array(elements.into_boxed_slice()))
    }
    fn parse_infix(&mut self, left: Expr) -> ParserResult<Expr> {
        match &self.peek().token {
            Token::Plus
            | Token::Minus
            | Token::Multiply
            | Token::Divide
            | Token::Modulo
            | Token::LogicEqual
            | Token::LogicNotEqual
            | Token::LogicLess
            | Token::LogicLessEqual
            | Token::LogicGreater
            | Token::LogicGreaterEqual
            | Token::LogicAnd
            | Token::LogicOr
            | Token::BinaryAnd
            | Token::BinaryOr
            | Token::BinaryXor
            | Token::BinaryShiftL
            | Token::BinaryShiftR
            | Token::Equal => self.parse_binary(left),

            Token::LogicNot => self.parse_macro_call(left),
            Token::LParen => self.parse_call(left),
            Token::LSquareBrace => self.parse_index(left),
            Token::Dot => self.parse_member_access(left),
            Token::DoubleColon => self.parse_static_access_or_generic_call(left),
            Token::KeywordAs => self.parse_cast(left),
            Token::RangeDots => self.parse_range(left, false),
            Token::RangeDotsInclusive => self.parse_range(left, true),

            _ => Err((
                self.cursor..self.cursor + 1,
                ParserError::UnexpectedToken {
                    expected: "infix operator".into(),
                    found: self.peek().token.clone(),
                },
            )),
        }
    }
    fn parse_binary(&mut self, left: Expr) -> ParserResult<Expr> {
        let op_token = self.advance().token.clone();
        let prec = precedence(&op_token);

        // Assignment is right-associative.
        if op_token == Token::Equal {
            let right = self.parse_with_precedence(prec - 1)?;
            return Ok(Expr::Assign(Box::new(left), Box::new(right)));
        }

        let op = Self::token_to_binary_op(&op_token)
            .expect("token filtered by parse_infix to be a binary operator");

        let right = self.parse_with_precedence(prec)?;
        Ok(Expr::BinaryOp(Box::new(left), op, Box::new(right)))
    }
    fn parse_call(&mut self, callee: Expr) -> ParserResult<Expr> {
        self.advance(); // (
        let args = self.parse_comma_separated_exprs(&Token::RParen)?;
        self.consume(&Token::RParen)?;
        Ok(Expr::Call(Box::new(callee), args.into_boxed_slice(), None))
    }
    fn parse_macro_call(&mut self, callee: Expr) -> ParserResult<Expr> {
        self.advance(); // !
        self.consume(&Token::LParen)?; // (
        let args = self.parse_comma_separated_exprs(&Token::RParen)?;
        self.consume(&Token::RParen)?;
        Ok(Expr::MacroCall(Box::new(callee), args.into_boxed_slice()))
    }

    fn parse_index(&mut self, left: Expr) -> ParserResult<Expr> {
        self.consume(&Token::LSquareBrace)?;
        let idx = self.parse_with_precedence(0)?;
        self.consume(&Token::RSquareBrace)?;
        Ok(Expr::Index(Box::new(left), Box::new(idx)))
    }

    fn parse_member_access(&mut self, left: Expr) -> ParserResult<Expr> {
        self.consume(&Token::Dot)?;
        let name = self.consume_name()?;
        if self.peek().token == Token::LParen {
            self.advance();
            let args = self.parse_comma_separated_exprs(&Token::RParen)?;
            self.consume(&Token::RParen)?;
            return Ok(Expr::MemberCall(
                Box::new(left),
                name,
                args.into_boxed_slice(),
                None,
            ));
        }
        Ok(Expr::MemberAccess(Box::new(left), name))
    }

    fn parse_cast(&mut self, left: Expr) -> ParserResult<Expr> {
        self.consume(&Token::KeywordAs)?;
        Ok(Expr::Cast(Box::new(left), Box::new(self.parse_type()?)))
    }
    fn parse_range(
        &mut self,
        left: Expr,
        inclusive: bool,
    ) -> Result<Expr, (std::ops::Range<usize>, ParserError)> {
        self.advance(); // ..
        let e = self.parse_expression()?;
        Ok(Expr::Range(Box::new(left), Box::new(e), inclusive))
    }

    fn parse_static_access_or_generic_call(&mut self, left: Expr) -> ParserResult<Expr> {
        self.advance(); // ::
        if self.peek().token == Token::LogicLess {
            return self.parse_generic_args_for_call(left);
        }
        if self.peek().token == Token::LBrace {
            return self.parse_struct_init(left);
        }
        Ok(Expr::StaticAccess(Box::new(left), self.consume_name()?))
    }
    fn parse_struct_init(&mut self, left: Expr) -> ParserResult<Expr> {
        self.advance(); // {
        let mut fields = Vec::with_capacity(4);
        while self.peek().token != Token::RBrace && !self.is_at_end() {
            let field_name = self.consume_name()?;
            let now = self.advance();
            if !matches!(now.token, Token::Equal | Token::Colon) {
                return Err((
                    now.span.clone(),
                    ParserError::Generic(format!(
                        "In struct init expected ':' or '=' after field name"
                    )),
                ));
            };
            let field_expr = self.parse_expression()?;
            fields.push((field_name, field_expr));

            if self.peek().token == Token::Comma {
                self.advance();
            } else {
                break;
            }
        }
        self.consume(&Token::RBrace)?;
        Ok(Expr::StructInit(Box::new(left), fields.into_boxed_slice()))
    }
    fn parse_generic_args_for_call(&mut self, callee: Expr) -> ParserResult<Expr> {
        self.consume(&Token::LogicLess)?;
        let generic_types = self.parse_generic_type_list()?;

        match &self.peek().token {
            Token::SemiColon => {
                let path = expr_to_type_path(&callee);
                Ok(Expr::Type(Box::new(ParserType::Generic(
                    path,
                    generic_types.into_boxed_slice(),
                ))))
            }
            Token::LParen => {
                self.advance(); // (
                let args = self.parse_comma_separated_exprs(&Token::RParen)?;
                self.consume(&Token::RParen)?;
                Ok(Expr::Call(
                    Box::new(callee),
                    args.into_boxed_slice(),
                    Some(generic_types.into_boxed_slice()),
                ))
            }
            _ => {
                if self.peek().token == Token::LBrace {
                    self.advance(); // {
                    let mut fields = Vec::with_capacity(4);
                    while self.peek().token != Token::RBrace && !self.is_at_end() {
                        let field_name = self.consume_name()?;
                        self.consume(&Token::Colon)?;
                        let field_type = self.parse_expression()?;
                        fields.push((field_name, field_type));

                        if self.peek().token == Token::Comma {
                            self.advance();
                        } else {
                            break;
                        }
                    }
                    self.consume(&Token::RBrace)?;
                    Ok(Expr::StructInit(
                        Box::new(Expr::NameWithGenerics(
                            Box::new(callee),
                            generic_types.into_boxed_slice(),
                        )),
                        fields.into_boxed_slice(),
                    ))
                } else {
                    Ok(Expr::NameWithGenerics(
                        Box::new(callee),
                        generic_types.into_boxed_slice(),
                    ))
                }
            }
        }
    }
    pub fn parse_type(&mut self) -> ParserResult<ParserType> {
        // Count leading `&` / `&&` pointer sigils.
        let mut pointer_depth: u32 = 0;
        loop {
            match self.peek().token {
                Token::BinaryAnd => {
                    pointer_depth += 1;
                    self.advance();
                }
                Token::LogicAnd => {
                    pointer_depth += 2;
                    self.advance();
                }
                _ => break,
            }
        }

        let mut ty = match self.peek().token {
            Token::KeywordFunction => self.parse_function_type()?,
            Token::LSquareBrace => self.parse_array_type()?,
            _ => self.parse_named_or_generic_type()?,
        };

        for _ in 0..pointer_depth {
            ty = ParserType::Pointer(Box::new(ty));
        }
        Ok(ty)
    }

    fn parse_function_type(&mut self) -> ParserResult<ParserType> {
        self.advance(); // fn
        self.consume(&Token::LParen)?;

        let mut params = Vec::with_capacity(4);
        if self.peek().token != Token::RParen {
            loop {
                params.push(self.parse_type()?);
                if self.peek().token == Token::RParen {
                    break;
                }
                self.consume(&Token::Comma)?;
            }
        }
        self.consume(&Token::RParen)?;
        self.consume(&Token::Colon)?;
        let return_type = self.parse_type()?;
        Ok(ParserType::Function(
            Box::new(return_type),
            params.into_boxed_slice(),
        ))
    }

    fn parse_array_type(&mut self) -> ParserResult<ParserType> {
        self.advance(); // [
        let elem_type = self.parse_type()?;
        self.consume(&Token::SemiColon)?;

        let size = match &self.advance().token {
            Token::Integer(n) => n.to_integer(self.symbol_table),
            _ => {
                return Err((
                    self.cursor..self.cursor + 1,
                    ParserError::TypeError("expected integer constant for array size".into()),
                ));
            }
        };
        self.consume(&Token::RSquareBrace)?;
        Ok(ParserType::ConstantSizeArray(
            Box::new(elem_type),
            size as i128,
        ))
    }

    fn parse_named_or_generic_type(&mut self) -> ParserResult<ParserType> {
        let name = self.consume_name()?;

        match &self.peek().token {
            Token::DoubleColon => {
                self.advance();
                let inner = self.parse_type()?;
                Ok(ParserType::NamespaceLink(name, Box::new(inner)))
            }
            Token::LogicLess => {
                self.advance(); // <
                let args = self.parse_generic_type_list()?;
                Ok(ParserType::Generic(name, args.into_boxed_slice()))
            }
            _ => Ok(ParserType::Named(name)),
        }
    }
    fn parse_comma_separated_exprs(&mut self, terminator: &Token) -> ParserResult<Vec<Expr>> {
        let mut items = Vec::new();
        if &self.peek().token == terminator {
            return Ok(items);
        }
        loop {
            items.push(self.parse_expression()?);
            if self.peek().token == Token::Comma {
                self.advance();
            } else {
                break;
            }
        }
        Ok(items)
    }
    fn consume_closing_gt(&mut self) -> bool {
        match self.peek().token {
            Token::LogicGreater => {
                self.advance();
                true
            }
            Token::BinaryShiftR => {
                // `>>` shared between two nested generic lists: consume only half.
                if self.pending_gt {
                    self.pending_gt = false;
                    self.advance();
                } else {
                    self.pending_gt = true;
                }
                true
            }
            _ => false,
        }
    }
    fn parse_generic_type_list(&mut self) -> ParserResult<Vec<ParserType>> {
        let mut types = Vec::new();
        loop {
            if self.consume_closing_gt() {
                break;
            }
            types.push(self.parse_type()?);
            match self.peek().token {
                Token::Comma => {
                    self.advance();
                }
                Token::LogicGreater | Token::BinaryShiftR => {}
                _ => break,
            }
        }
        Ok(types)
    }
    fn token_to_binary_op(token: &Token) -> Option<BinaryOp> {
        Some(match token {
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
            _ => return None,
        })
    }
}
pub fn expr_to_type_path(expr: &Expr) -> String {
    let mut buf = String::new();
    write_expr_path(&mut buf, expr);
    buf
}
fn write_expr_path(w: &mut String, expr: &Expr) {
    match expr {
        Expr::Name(n) => w.push_str(n),
        Expr::NameWithGenerics(n, ..) => write_expr_path(w, n),
        Expr::StaticAccess(base, member) => {
            write_expr_path(w, base);
            let _ = write!(w, ".{member}");
        }
        _ => w.push_str("<?>"),
    }
}
