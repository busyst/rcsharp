use rcsharp_lexer::defs::TokenKind;

use crate::{
    Parser,
    defs::{BinaryOp, Expr, ParserType, UnaryOp},
};

const PREFIX_PRECEDENCE: u8 = 14;

impl<'lex, 'src, 'int> Parser<'lex, 'src, 'int> {
    #[inline]
    fn precedence(&mut self) -> u8 {
        match self.peek().kind {
            TokenKind::Equal => 1,
            TokenKind::RangeDots | TokenKind::RangeDotsInclusive => 2,
            TokenKind::LogicOr => 3,
            TokenKind::LogicAnd => 4,
            TokenKind::BinaryOr => 5,
            TokenKind::BinaryXor => 6,
            TokenKind::BinaryAnd => 7,
            TokenKind::LogicEqual | TokenKind::LogicNotEqual => 8,
            TokenKind::LogicLess
            | TokenKind::LogicLessEqual
            | TokenKind::LogicGreater
            | TokenKind::LogicGreaterEqual => 9,
            TokenKind::BinaryShiftL | TokenKind::BinaryShiftR => 10,
            TokenKind::Plus | TokenKind::Minus => 11,
            TokenKind::Multiply | TokenKind::Divide | TokenKind::Modulo => 12,
            TokenKind::KeywordAs => 13,
            TokenKind::LogicNot if self.peek_nth(1).kind == TokenKind::LParen => 15,
            TokenKind::LParen
            | TokenKind::LSquareBrace
            | TokenKind::Dot
            | TokenKind::DoubleColon => 15,
            _ => 0,
        }
    }

    pub fn parse_expression(&mut self) -> Result<Expr, ()> {
        self.parse_with_precedence(0)
    }

    fn parse_with_precedence(&mut self, min_precedence: u8) -> Result<Expr, ()> {
        let mut left = self.parse_prefix()?;
        loop {
            if self.precedence() <= min_precedence {
                break;
            }
            left = self.parse_infix(left)?;
        }
        Ok(left)
    }

    fn parse_prefix(&mut self) -> Result<Expr, ()> {
        let tok = self.bump();
        match tok.kind {
            TokenKind::Integer(sym) => Ok(Expr::Integer(sym)),
            TokenKind::Char(ch) => Ok(Expr::Char(ch)),
            TokenKind::Decimal(sym) => Ok(Expr::Decimal(sym)),
            TokenKind::String(sym) => Ok(Expr::StringConst(sym)),
            TokenKind::Name(sym) => Ok(Expr::Name(sym)),

            TokenKind::KeywordTrue => Ok(Expr::Boolean(true)),
            TokenKind::KeywordFalse => Ok(Expr::Boolean(false)),
            TokenKind::KeywordNull => Ok(Expr::NullPtr),

            TokenKind::LParen => {
                let expr = self.parse_with_precedence(0)?;
                self.expect(TokenKind::RParen, "Expected ')'")?;
                Ok(expr)
            }

            TokenKind::Minus => self.parse_unary(UnaryOp::Negate),
            TokenKind::LogicNot => self.parse_unary(UnaryOp::Not),
            TokenKind::BinaryNot => self.parse_unary(UnaryOp::BitNot),
            TokenKind::Multiply => self.parse_unary(UnaryOp::Deref),
            TokenKind::BinaryAnd => self.parse_unary(UnaryOp::Pointer),

            // `&&expr` -> `&(&expr)`
            TokenKind::LogicAnd => {
                let inner = self.parse_unary(UnaryOp::Pointer)?;
                Ok(Expr::UnaryOp(UnaryOp::Pointer, Box::new(inner)))
            }

            TokenKind::LSquareBrace => self.parse_array_literal(),

            _ => {
                self.error(
                    tok.span,
                    &format!("Expected expression, found {:?}", tok.kind),
                );
                Err(())
            }
        }
    }

    fn parse_unary(&mut self, op: UnaryOp) -> Result<Expr, ()> {
        let operand = self.parse_with_precedence(PREFIX_PRECEDENCE)?;
        Ok(Expr::UnaryOp(op, Box::new(operand)))
    }

    fn parse_array_literal(&mut self) -> Result<Expr, ()> {
        let elements =
            self.parse_comma_separated(TokenKind::RSquareBrace, Self::parse_expression)?;
        self.expect(TokenKind::RSquareBrace, "Expected ']' after array literal")?;
        Ok(Expr::Array(elements.into_boxed_slice()))
    }

    fn parse_infix(&mut self, left: Expr) -> Result<Expr, ()> {
        let tok = self.peek();
        match tok.kind {
            TokenKind::Plus
            | TokenKind::Minus
            | TokenKind::Multiply
            | TokenKind::Divide
            | TokenKind::Modulo
            | TokenKind::LogicEqual
            | TokenKind::LogicNotEqual
            | TokenKind::LogicLess
            | TokenKind::LogicLessEqual
            | TokenKind::LogicGreater
            | TokenKind::LogicGreaterEqual
            | TokenKind::LogicAnd
            | TokenKind::LogicOr
            | TokenKind::BinaryAnd
            | TokenKind::BinaryOr
            | TokenKind::BinaryXor
            | TokenKind::BinaryShiftL
            | TokenKind::BinaryShiftR
            | TokenKind::Equal => self.parse_binary(left),

            TokenKind::LogicNot => self.parse_macro_call(left),
            TokenKind::LParen => self.parse_call(left),
            TokenKind::LSquareBrace => self.parse_index(left),
            TokenKind::Dot => self.parse_member_access(left),
            TokenKind::DoubleColon => self.parse_static_access_or_generic_call(left),
            TokenKind::KeywordAs => self.parse_cast(left),
            TokenKind::RangeDots => self.parse_range(left, false),
            TokenKind::RangeDotsInclusive => self.parse_range(left, true),

            _ => {
                self.error(
                    tok.span,
                    &format!("Expected infix operator, found {:?}", tok.kind),
                );
                Err(())
            }
        }
    }

    fn parse_binary(&mut self, left: Expr) -> Result<Expr, ()> {
        let prec = self.precedence();
        let op_tok = self.bump();

        if op_tok.kind == TokenKind::Equal {
            let right = self.parse_with_precedence(prec - 1)?;
            return Ok(Expr::Assign(Box::new(left), Box::new(right)));
        }

        let op = Self::token_to_binary_op(op_tok.kind)
            .expect("token filtered by parse_infix to be a binary operator");
        let right = self.parse_with_precedence(prec)?;
        Ok(Expr::BinaryOp(Box::new(left), op, Box::new(right)))
    }

    fn parse_call(&mut self, callee: Expr) -> Result<Expr, ()> {
        self.bump(); // (
        let args = self.parse_comma_separated(TokenKind::RParen, Self::parse_expression)?;
        self.expect(TokenKind::RParen, "Expected ')' after call arguments")?;
        Ok(Expr::Call(Box::new(callee), args.into_boxed_slice(), None))
    }

    fn parse_macro_call(&mut self, callee: Expr) -> Result<Expr, ()> {
        self.bump(); // !
        self.expect(TokenKind::LParen, "Expected '(' in macro call")?;
        let args = self.parse_comma_separated(TokenKind::RParen, Self::parse_expression)?;
        self.expect(TokenKind::RParen, "Expected ')' after macro arguments")?;
        Ok(Expr::MacroCall(Box::new(callee), args.into_boxed_slice()))
    }

    fn parse_index(&mut self, left: Expr) -> Result<Expr, ()> {
        self.bump(); // [
        let idx = self.parse_expression()?;
        self.expect(TokenKind::RSquareBrace, "Expected ']' after index")?;
        Ok(Expr::Index(Box::new(left), Box::new(idx)))
    }

    fn parse_member_access(&mut self, left: Expr) -> Result<Expr, ()> {
        self.bump(); // .
        let (name, _) = self.expect_name("Expected member name after '.'")?;
        if self.eat(TokenKind::LParen) {
            let args = self.parse_comma_separated(TokenKind::RParen, Self::parse_expression)?;
            self.expect(TokenKind::RParen, "Expected ')' after method arguments")?;
            return Ok(Expr::MemberCall(
                Box::new(left),
                name,
                args.into_boxed_slice(),
                None,
            ));
        }
        Ok(Expr::MemberAccess(Box::new(left), name))
    }

    fn parse_cast(&mut self, left: Expr) -> Result<Expr, ()> {
        self.bump(); // as
        Ok(Expr::Cast(Box::new(left), Box::new(self.parse_type()?)))
    }

    fn parse_range(&mut self, left: Expr, inclusive: bool) -> Result<Expr, ()> {
        let prec = self.precedence();
        self.bump(); // .. or ..=
        let right = self.parse_with_precedence(prec)?;
        Ok(Expr::Range(Box::new(left), Box::new(right), inclusive))
    }

    fn parse_static_access_or_generic_call(&mut self, left: Expr) -> Result<Expr, ()> {
        self.bump(); // ::
        if self.at(TokenKind::LogicLess) {
            return self.parse_generic_args_for_call(left);
        }
        if self.at(TokenKind::LBrace) {
            return self.parse_struct_init(left);
        }
        let (name, _) = self.expect_name("Expected identifier after '::'")?;
        Ok(Expr::StaticAccess(Box::new(left), name))
    }

    fn parse_struct_init(&mut self, left: Expr) -> Result<Expr, ()> {
        self.bump(); // {
        let fields = self.parse_comma_separated(TokenKind::RBrace, |p| {
            let (field_name, _) = p.expect_name("Expected field name in struct initializer")?;
            let sep = p.bump();
            if !matches!(sep.kind, TokenKind::Equal | TokenKind::Colon) {
                p.error(
                    sep.span,
                    "In struct init expected ':' or '=' after field name",
                );
                return Err(());
            }
            let field_expr = p.parse_expression()?;
            Ok((field_name, field_expr))
        })?;
        self.expect(TokenKind::RBrace, "Expected '}' after struct initializer")?;
        Ok(Expr::StructInit(Box::new(left), fields.into_boxed_slice()))
    }

    fn parse_generic_args_for_call(&mut self, callee: Expr) -> Result<Expr, ()> {
        self.bump(); // <
        let generic_types = self.parse_generic_type_list()?;

        if self.eat(TokenKind::LParen) {
            let args = self.parse_comma_separated(TokenKind::RParen, Self::parse_expression)?;
            self.expect(TokenKind::RParen, "Expected ')' after call arguments")?;
            Ok(Expr::Call(
                Box::new(callee),
                args.into_boxed_slice(),
                Some(generic_types.into_boxed_slice()),
            ))
        } else if self.at(TokenKind::LBrace) {
            self.parse_struct_init(Expr::NameWithGenerics(
                Box::new(callee),
                generic_types.into_boxed_slice(),
            ))
        } else {
            Ok(Expr::NameWithGenerics(
                Box::new(callee),
                generic_types.into_boxed_slice(),
            ))
        }
    }

    // --- Types ---

    pub fn parse_type(&mut self) -> Result<ParserType, ()> {
        let mut pointer_depth: u32 = 0;
        loop {
            match self.peek().kind {
                TokenKind::BinaryAnd => {
                    pointer_depth += 1;
                    self.bump();
                }
                TokenKind::LogicAnd => {
                    pointer_depth += 2;
                    self.bump();
                }
                _ => break,
            }
        }

        let mut ty = match self.peek().kind {
            TokenKind::KeywordFunction => self.parse_function_type()?,
            TokenKind::LSquareBrace => self.parse_array_type()?,
            _ => self.parse_named_or_generic_type()?,
        };

        for _ in 0..pointer_depth {
            ty = ParserType::Pointer(Box::new(ty));
        }
        Ok(ty)
    }

    fn parse_function_type(&mut self) -> Result<ParserType, ()> {
        self.bump(); // fn
        self.expect(TokenKind::LParen, "Expected '(' in function type")?;
        let params = self.parse_comma_separated(TokenKind::RParen, Self::parse_type)?;
        self.expect(TokenKind::RParen, "Expected ')' in function type")?;
        self.expect(TokenKind::Colon, "Expected ':' before function return type")?;
        let return_type = self.parse_type()?;
        Ok(ParserType::Function(
            Box::new(return_type),
            params.into_boxed_slice(),
        ))
    }

    fn parse_array_type(&mut self) -> Result<ParserType, ()> {
        self.bump(); // [
        let elem_type = self.parse_type()?;
        self.expect_semicolon()?;

        let size_tok = self.bump();
        let size = match size_tok.kind {
            TokenKind::Integer(_sym) => {
                // TODO: expose interner lookup on Lexer to decode `sym` into u64
                1984u64
            }
            _ => {
                self.error(size_tok.span, "Expected integer constant for array size");
                return Err(());
            }
        };
        self.expect(TokenKind::RSquareBrace, "Expected ']' after array size")?;
        Ok(ParserType::ConstantSizeArray(Box::new(elem_type), size))
    }

    fn parse_named_or_generic_type(&mut self) -> Result<ParserType, ()> {
        let (name, _) = self.expect_name("Expected type name")?;
        if self.eat(TokenKind::DoubleColon) {
            let inner = self.parse_type()?;
            Ok(ParserType::NamespaceLink(name, Box::new(inner)))
        } else if self.eat(TokenKind::LogicLess) {
            let args = self.parse_generic_type_list()?;
            Ok(ParserType::Generic(name, args.into_boxed_slice()))
        } else {
            Ok(ParserType::Named(name))
        }
    }

    fn consume_closing_gt(&mut self) -> bool {
        match self.peek().kind {
            TokenKind::LogicGreater => {
                self.bump();
                true
            }
            TokenKind::BinaryShiftR => {
                if self.pending_gt {
                    self.pending_gt = false;
                    self.bump();
                } else {
                    self.pending_gt = true;
                }
                true
            }
            _ => false,
        }
    }

    fn parse_generic_type_list(&mut self) -> Result<Vec<ParserType>, ()> {
        let mut types = Vec::new();
        loop {
            if self.consume_closing_gt() {
                break;
            }
            if self.is_eof() {
                let sps = self.peek().span;
                self.error(sps, "Unterminated generic argument list");
                return Err(());
            }
            types.push(self.parse_type()?);
            match self.peek().kind {
                TokenKind::Comma => {
                    self.bump();
                }
                TokenKind::LogicGreater | TokenKind::BinaryShiftR => {}
                _ => {
                    let tok = self.peek();
                    self.error(tok.span, "Expected ',' or '>' in generic argument list");
                    return Err(());
                }
            }
        }
        Ok(types)
    }

    fn token_to_binary_op(kind: TokenKind) -> Option<BinaryOp> {
        Some(match kind {
            TokenKind::Plus => BinaryOp::Add,
            TokenKind::Minus => BinaryOp::Subtract,
            TokenKind::Multiply => BinaryOp::Multiply,
            TokenKind::Divide => BinaryOp::Divide,
            TokenKind::Modulo => BinaryOp::Modulo,
            TokenKind::LogicEqual => BinaryOp::Equals,
            TokenKind::LogicNotEqual => BinaryOp::NotEqual,
            TokenKind::LogicLess => BinaryOp::Less,
            TokenKind::LogicLessEqual => BinaryOp::LessEqual,
            TokenKind::LogicGreater => BinaryOp::Greater,
            TokenKind::LogicGreaterEqual => BinaryOp::GreaterEqual,
            TokenKind::LogicAnd => BinaryOp::And,
            TokenKind::LogicOr => BinaryOp::Or,
            TokenKind::BinaryAnd => BinaryOp::BitAnd,
            TokenKind::BinaryOr => BinaryOp::BitOr,
            TokenKind::BinaryXor => BinaryOp::BitXor,
            TokenKind::BinaryShiftL => BinaryOp::ShiftLeft,
            TokenKind::BinaryShiftR => BinaryOp::ShiftRight,
            _ => return None,
        })
    }
}
