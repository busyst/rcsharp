use crate::{
    compiler_primitives::{
        DEFAULT_INTEGER_TYPE, PrimitiveInfo, PrimitiveKind, find_primitive_type,
    },
    defs::{
        Attribute, ParsedEnum, ParsedFunction, ParsedImplementation, ParsedStruct, ParsedTrait,
        ParsedVariable, ParserError, ParserResult, Span, Stmt, StmtData, VarType,
    },
    expression_parser::{Expr, ExpressionParser},
};
use rcsharp_lexer::{
    LexerSymbolTable,
    defs::{DUMMY_EOF_TOKEN, Token, TokenData},
};
use std::fmt;
#[derive(Debug, Clone)]
pub enum ParserType {
    Named(String),
    Pointer(Box<ParserType>),
    Function(Box<ParserType>, Box<[ParserType]>),
    NamespaceLink(String, Box<ParserType>),
    Generic(String, Box<[ParserType]>),
    ConstantSizeArray(Box<ParserType>, i128),
}
impl PartialEq for ParserType {
    fn eq(&self, other: &Self) -> bool {
        let lhs = self.peel_namespace();
        let rhs = other.peel_namespace();
        match (lhs, rhs) {
            (Self::Named(l), Self::Named(r)) => l == r,
            (Self::Pointer(l), Self::Pointer(r)) => l == r,
            (Self::Function(lr, la), Self::Function(rr, ra)) => lr == rr && la == ra,
            (Self::Generic(ls, lt), Self::Generic(rs, rt)) => ls == rs && lt == rt,
            (Self::ConstantSizeArray(lt, ls), Self::ConstantSizeArray(rt, rs)) => {
                lt == rt && ls == rs
            }
            _ => false,
        }
    }
}
impl ParserType {
    pub fn as_primitive_type(&self) -> Option<&'static PrimitiveInfo> {
        if let ParserType::Named(name) = self {
            return find_primitive_type(name);
        }
        None
    }
    pub fn as_integer(&self) -> Option<&'static PrimitiveInfo> {
        self.as_primitive_type()
            .filter(|x| x.kind == PrimitiveKind::SignedInt || x.kind == PrimitiveKind::UnsignedInt)
    }
    pub fn as_decimal(&self) -> Option<&'static PrimitiveInfo> {
        self.as_primitive_type()
            .filter(|x| x.kind == PrimitiveKind::Decimal)
    }
    pub fn as_pointer(&self) -> Option<&ParserType> {
        if let ParserType::Pointer(x) = self {
            return Some(&x); // Inner
        }
        None
    }
    pub fn as_function(&self) -> Option<(&ParserType, &[ParserType])> {
        if let ParserType::Function(x, y) = self {
            return Some((&x, &y));
        }
        None
    }
    pub fn as_generic(&self) -> Option<(&str, &[ParserType])> {
        if let ParserType::Generic(x, y) = self {
            return Some((&x, &y));
        }
        None
    }
    fn peel_namespace(&self) -> &Self {
        match self {
            Self::NamespaceLink(_, inner) => inner.peel_namespace(),
            other => other,
        }
    }
}
impl fmt::Display for ParserType {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::Named(n) => f.write_str(n),
            Self::Pointer(inner) => write!(f, "*{inner}"),
            Self::NamespaceLink(ns, inner) => write!(f, "{ns}::{inner}"),
            Self::Generic(name, args) => {
                write!(f, "{name}<")?;
                for (i, a) in args.iter().enumerate() {
                    if i > 0 {
                        write!(f, ", ")?;
                    }
                    write!(f, "{a}")?;
                }
                f.write_str(">")
            }
            Self::Function(ret, params) => {
                write!(f, "fn(")?;
                for (i, p) in params.iter().enumerate() {
                    if i > 0 {
                        write!(f, ", ")?;
                    }
                    write!(f, "{p}")?;
                }
                write!(f, ") -> {ret}")
            }
            Self::ConstantSizeArray(elem, n) => write!(f, "[{elem}; {n}]"),
        }
    }
}
pub struct GeneralParser<'a> {
    tokens: &'a [TokenData],
    symbol_table: &'a LexerSymbolTable,
    cursor: usize,
}
impl<'a> GeneralParser<'a> {
    pub fn new(tokens: &'a [TokenData], symbol_table: &'a LexerSymbolTable) -> Self {
        Self {
            tokens,
            symbol_table,
            cursor: 0,
        }
    }
    #[inline]
    pub fn is_at_end(&self) -> bool {
        self.cursor >= self.tokens.len()
    }
    #[inline]
    fn peek(&self) -> &TokenData {
        self.tokens.get(self.cursor).unwrap_or(&DUMMY_EOF_TOKEN)
    }
    #[inline]
    fn peek_offset(&self, offset: usize) -> &TokenData {
        self.tokens
            .get(self.cursor + offset)
            .unwrap_or(&DUMMY_EOF_TOKEN)
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

    pub fn parse_all(&mut self) -> ParserResult<Vec<StmtData>> {
        let mut stmts = Vec::new();
        while !self.is_at_end() {
            let x = self.parse_toplevel_item()?;
            if let Stmt::Block(blk) = x.stmt {
                stmts.extend(Vec::from(blk));
            } else {
                stmts.push(x);
            }
        }
        Ok(stmts)
    }

    pub fn parse_compiler_only(&mut self) -> ParserResult<Vec<(Span, Attribute)>> {
        let mut hints = vec![];
        while !self.is_at_end() {
            let is_bare_hint = self.peek().token == Token::Hint
                && self.peek_offset(1).token != Token::LSquareBrace;

            if is_bare_hint {
                let StmtData {
                    span,
                    stmt: Stmt::CompilerHint(attr),
                } = self.parse_hint_stmt()?
                else {
                    unreachable!("parse_hint_stmt always returns CompilerHint");
                };
                hints.push((span, attr));
            } else {
                self.advance();
            }
        }
        Ok(hints)
    }
    fn parse_toplevel_item(&mut self) -> ParserResult<StmtData> {
        let mut attributes = Vec::new();
        let mut start_span = self.cursor..self.cursor + 1;

        while self.peek().token == Token::Hint && self.peek_offset(1).token == Token::LSquareBrace {
            attributes.push(self.parse_attribute()?);
        }

        if self.peek().token == Token::Hint && !attributes.is_empty() {
            return Err((start_span, ParserError::OrphanedAttributes));
        }

        if self.peek().token == Token::Hint {
            return self.parse_hint_stmt();
        }

        if let Some(first) = attributes.first() {
            start_span = first.span.clone();
        }

        match self.peek().token.clone() {
            Token::KeywordFunction => self.parse_function(attributes, start_span),
            Token::KeywordStruct => self.parse_struct(attributes, start_span),
            Token::KeywordEnum => self.parse_enum(attributes, start_span),
            Token::KeywordTrait => self.parse_trait(attributes, start_span),
            Token::KeywordImpl => self.parse_impl(attributes, start_span),
            Token::KeywordNamespace => {
                if !attributes.is_empty() {
                    return Err((
                        start_span,
                        ParserError::AttributeError(
                            "Attributes are not allowed on namespaces".into(),
                        ),
                    ));
                }
                self.parse_namespace()
            }
            Token::LBrace => self.parse_top_level_block(),
            Token::KeywordInline => self.parse_with_modifier("inline", attributes),
            Token::KeywordConstExpr => self.parse_with_modifier("constexpr", attributes),
            Token::KeywordPub => self.parse_with_modifier("public", attributes),
            Token::KeywordNoReturn => self.parse_with_modifier("no_return", attributes),
            Token::KeywordExtern => self.parse_with_modifier("extern", attributes),
            Token::KeywordStatic => self.parse_static_let_statement(start_span.start),
            _ => {
                if !attributes.is_empty() {
                    return Err((start_span, ParserError::OrphanedAttributes));
                }
                Err((
                    self.cursor..self.cursor + 1,
                    ParserError::UnexpectedTopLevelToken {
                        found: format!("{:?}", self.peek().token),
                    },
                ))
            }
        }
    }

    fn parse_with_modifier(
        &mut self,
        modifier: &str,
        attributes: Vec<Attribute>,
    ) -> ParserResult<StmtData> {
        self.advance();
        let mut item = self.parse_toplevel_item()?;
        fn count_and_validate(
            stmt: &StmtData,
            modifier: &str,
        ) -> Result<usize, (Span, ParserError)> {
            match &stmt.stmt {
                Stmt::Function(_) | Stmt::Struct(_) | Stmt::Enum(_) => Ok(1),
                Stmt::Block(b) => {
                    let mut count = 0;
                    for x in b.iter() {
                        count += count_and_validate(x, modifier)?;
                    }
                    Ok(count)
                }
                Stmt::CompilerDud | Stmt::CompilerHint(_) => Ok(0),
                _ => Err((
                    stmt.span.clone(),
                    ParserError::InvalidModifier {
                        modifier: modifier.into(),
                        applicable_to: "functions, structs, or enums".into(),
                    },
                )),
            }
        }

        fn apply_rec(
            stmt: &mut StmtData,
            modifier: &str,
            attributes: &mut Option<Vec<Attribute>>,
            count: &mut usize,
            prepend_mod: fn(&mut Box<[String]>, &str),
            prepend_attr: fn(&mut Box<[Attribute]>, Vec<Attribute>),
        ) {
            let mut apply = |prefixes: &mut Box<[String]>, attrs: &mut Box<[Attribute]>| {
                *count -= 1;
                let pass_attrs = if *count == 0 {
                    attributes.take().unwrap_or_default()
                } else {
                    attributes.clone().unwrap_or_default()
                };
                prepend_mod(prefixes, modifier);
                prepend_attr(attrs, pass_attrs);
            };

            match &mut stmt.stmt {
                Stmt::Function(f) => apply(&mut f.prefixes, &mut f.attributes),
                Stmt::Struct(s) => apply(&mut s.prefixes, &mut s.attributes),
                Stmt::Enum(e) => apply(&mut e.prefixes, &mut e.attributes),
                Stmt::Block(b) => {
                    for x in b.iter_mut() {
                        apply_rec(x, modifier, attributes, count, prepend_mod, prepend_attr);
                    }
                }
                _ => {}
            }
        }

        let mut count = count_and_validate(&item, modifier)?;
        let mut attrs_opt = Some(attributes);

        apply_rec(
            &mut item,
            modifier,
            &mut attrs_opt,
            &mut count,
            Self::prepend_modifier,
            Self::prepend_attributes,
        );

        Ok(item)
    }

    fn parse_top_level_block(&mut self) -> ParserResult<StmtData> {
        let start = self.cursor;
        self.advance(); // {
        let mut stmts = vec![];
        while self.peek().token != Token::RBrace {
            let item = self.parse_toplevel_item()?;
            if let Stmt::Block(blk) = item.stmt {
                stmts.extend(Vec::from(blk));
            } else {
                stmts.push(item);
            }
        }
        self.consume(&Token::RBrace)?;
        Ok(StmtData {
            stmt: Stmt::Block(stmts.into_boxed_slice()),
            span: start..self.cursor,
        })
    }
    fn parse_generic_params(&mut self) -> ParserResult<Vec<String>> {
        if self.peek().token != Token::LogicLess {
            return Ok(Vec::new());
        }
        self.advance(); // <

        let mut params = Vec::new();
        loop {
            if self.peek().token == Token::LogicGreater {
                self.advance();
                break;
            }
            params.push(self.consume_name()?);
            match self.peek().token {
                Token::Comma => {
                    self.advance();
                }
                Token::LogicGreater => {}
                _ => {
                    return Err((
                        self.cursor..self.cursor + 1,
                        ParserError::UnexpectedToken {
                            expected: "',' or '>'".into(),
                            found: self.peek().token.clone(),
                        },
                    ));
                }
            }
        }
        Ok(params)
    }
    fn parse_attribute(&mut self) -> ParserResult<Attribute> {
        let start = self.cursor;
        self.advance(); // #
        self.advance(); // [
        let name = self.consume_name()?;
        let args = self.parse_arg_list_parens()?;
        self.consume(&Token::RSquareBrace)?;

        Ok(Attribute {
            name: name.into_boxed_str(),
            arguments: args.into_boxed_slice(),
            span: start..self.cursor,
        })
    }

    fn parse_hint_stmt(&mut self) -> ParserResult<StmtData> {
        let start = self.cursor;
        self.advance(); // #
        let name = self.consume_name()?;
        let args = self.parse_arg_list_parens()?;
        let span = start..self.cursor;

        Ok(StmtData {
            stmt: Stmt::CompilerHint(Attribute {
                name: name.into_boxed_str(),
                arguments: args.into_boxed_slice(),
                span: span.clone(),
            }),
            span,
        })
    }

    fn parse_arg_list_parens(&mut self) -> ParserResult<Vec<Expr>> {
        let mut args = Vec::new();
        if self.peek().token != Token::LParen {
            return Ok(args);
        }
        self.advance(); // (
        while self.peek().token != Token::RParen && !self.is_at_end() {
            args.push(self.parse_expression()?);
            if self.peek().token == Token::Comma {
                self.advance();
            } else {
                break;
            }
        }
        self.consume(&Token::RParen)?;
        Ok(args)
    }
    fn parse_function(
        &mut self,
        attributes: Vec<Attribute>,
        start_span: Span,
    ) -> ParserResult<StmtData> {
        let start = start_span.start;
        self.advance(); // fn
        let name = self.consume_name()?;
        let generic_types = self.parse_generic_params()?;

        self.consume(&Token::LParen)?;
        let mut args = Vec::new();
        if self.peek().token != Token::RParen {
            loop {
                let arg_name = self.consume_name()?;
                self.consume(&Token::Colon)?;
                let arg_type = self.parse_type()?;
                args.push((arg_name, arg_type));
                if self.peek().token != Token::Comma {
                    break;
                }
                self.advance();
            }
        }
        self.consume(&Token::RParen)?;

        let return_type = if self.peek().token == Token::Colon {
            self.advance();
            self.parse_type()?
        } else {
            ParserType::Named("void".to_string())
        };

        if self.peek().token == Token::SemiColon {
            self.advance();
            return Ok(StmtData {
                stmt: Stmt::Function(ParsedFunction {
                    path: Box::from(""),
                    attributes: attributes.into_boxed_slice(),
                    name: name.into(),
                    args: args.into_boxed_slice(),
                    return_type,
                    body: Box::new([]),
                    prefixes: Box::new([]),
                    generic_params: generic_types.into_boxed_slice(),
                }),
                span: start..self.cursor,
            });
        } else if self.peek().token == Token::FatArrow {
            self.advance();
            let expr_start = self.cursor;
            let expr = self.parse_expression()?;
            self.consume(&Token::SemiColon)?;
            return Ok(StmtData {
                stmt: Stmt::Function(ParsedFunction {
                    path: Box::from(""),
                    attributes: attributes.into_boxed_slice(),
                    name: name.into(),
                    args: args.into_boxed_slice(),
                    return_type,
                    body: Box::new([StmtData {
                        stmt: Stmt::Return(Some(expr)),
                        span: expr_start..self.cursor,
                    }]),
                    prefixes: Box::new([]),
                    generic_params: generic_types.into_boxed_slice(),
                }),
                span: start..self.cursor,
            });
        }

        let body = self.parse_block_body()?;

        Ok(StmtData {
            stmt: Stmt::Function(ParsedFunction {
                path: Box::from(""),
                attributes: attributes.into_boxed_slice(),
                name: name.into(),
                args: args.into_boxed_slice(),
                return_type,
                body,
                prefixes: Box::new([]),
                generic_params: generic_types.into_boxed_slice(),
            }),
            span: start..self.cursor,
        })
    }
    fn parse_struct(
        &mut self,
        attributes: Vec<Attribute>,
        start_span: Span,
    ) -> ParserResult<StmtData> {
        let start = start_span.start;
        self.advance(); // struct
        let name = self.consume_name()?;
        let generic_types = self.parse_generic_params()?;
        self.consume(&Token::LBrace)?;

        let mut fields = Vec::with_capacity(4);
        while self.peek().token != Token::RBrace && !self.is_at_end() {
            let field_name = self.consume_name()?;
            self.consume(&Token::Colon)?;
            let field_type = self.parse_type()?;
            fields.push((field_name, field_type));

            if self.peek().token == Token::Comma {
                self.advance();
            } else {
                break;
            }
        }
        self.consume(&Token::RBrace)?;

        Ok(StmtData {
            stmt: Stmt::Struct(ParsedStruct {
                path: "".into(),
                attributes: attributes.into_boxed_slice(),
                name: name.into(),
                fields: fields.into_boxed_slice(),
                generic_params: generic_types.into_boxed_slice(),
                prefixes: Box::new([]),
            }),
            span: start..self.cursor,
        })
    }
    fn parse_namespace(&mut self) -> ParserResult<StmtData> {
        let start = self.cursor;
        self.advance(); // namespace
        let name = self.consume_name()?;
        self.consume(&Token::LBrace)?;
        let mut body = Vec::new();
        while self.peek().token != Token::RBrace {
            let x = self.parse_toplevel_item()?;
            if let Stmt::Block(blk) = x.stmt {
                body.extend(Vec::from(blk));
            } else {
                body.push(x);
            }
        }
        self.consume(&Token::RBrace)?;
        Ok(StmtData {
            stmt: Stmt::Namespace(name, body.into_boxed_slice()),
            span: start..self.cursor,
        })
    }
    fn parse_enum(
        &mut self,
        attributes: Vec<Attribute>,
        start_span: Span,
    ) -> ParserResult<StmtData> {
        let start = start_span.start;
        self.advance(); // enum
        let name = self.consume_name()?;

        let enum_base_type = if self.peek().token == Token::Colon {
            self.advance();
            self.parse_type()?
        } else {
            DEFAULT_INTEGER_TYPE.into()
        };

        self.consume(&Token::LBrace)?;
        let mut values = Vec::with_capacity(8);
        let mut counter = 0;

        while self.peek().token != Token::RBrace && !self.is_at_end() {
            let name = self.consume_name()?;
            let expr = if self.peek().token == Token::Equal {
                self.advance();
                self.parse_expression()?
            } else {
                Expr::Integer(counter)
            };

            values.push((name, expr));
            counter += 1;

            if self.peek().token == Token::Comma {
                self.advance();
            }
        }
        self.consume(&Token::RBrace)?;

        Ok(StmtData {
            stmt: Stmt::Enum(ParsedEnum {
                path: "".into(),
                attributes: attributes.into_boxed_slice(),
                name: name.into(),
                fields: values.into_boxed_slice(),
                enum_type: enum_base_type,
                prefixes: Box::new([]),
            }),
            span: start..self.cursor,
        })
    }

    fn parse_trait(
        &mut self,
        attributes: Vec<Attribute>,
        start_span: Span,
    ) -> ParserResult<StmtData> {
        let start = start_span.start;
        self.advance(); // trait
        let name = self.consume_name()?;
        let generic_types = self.parse_generic_params()?;
        self.consume(&Token::LBrace)?;
        let mut items = vec![];
        while self.peek().token != Token::RBrace && !self.is_at_end() {
            match self.parse_toplevel_item()? {
                StmtData {
                    stmt: Stmt::Function(func),
                    span: _,
                } => {
                    items.push(func);
                }
                _ => unimplemented!(),
            }
        }
        self.consume(&Token::RBrace)?;
        return Ok(StmtData {
            stmt: Stmt::TraitDeclaration(ParsedTrait {
                path: "".into(),
                attributes: attributes.into_boxed_slice(),
                name: name.into(),
                functions: items.into_boxed_slice(),
                generic_params: generic_types.into_boxed_slice(),
                prefixes: Box::new([]),
            }),
            span: start..self.cursor,
        });
    }

    fn parse_impl(
        &mut self,
        attributes: Vec<Attribute>,
        start_span: Span,
    ) -> ParserResult<StmtData> {
        let start = start_span.start;
        self.advance(); // impl
        let implementing = self.parse_type()?;
        let impl_for = if self.peek().token == Token::KeywordFor {
            self.advance();
            self.parse_type()?
        } else {
            implementing.clone()
        };
        let generic_types = self.parse_generic_params()?;
        self.consume(&Token::LBrace)?;
        let mut items = vec![];
        while self.peek().token != Token::RBrace && !self.is_at_end() {
            items.push(self.parse_toplevel_item()?)
        }
        self.consume(&Token::RBrace)?;
        return Ok(StmtData {
            stmt: Stmt::Impl(ParsedImplementation {
                implementing: Box::new(implementing),
                implementing_for: Box::new(impl_for),
                path: "".into(),
                attributes: attributes.into_boxed_slice(),
                body: items.into_boxed_slice(),
                generic_params: generic_types.into_boxed_slice(),
                prefixes: Box::new([]),
            }),
            span: start..self.cursor,
        });
    }
    fn parse_statement(&mut self) -> ParserResult<StmtData> {
        let start = self.cursor;

        match self.peek().token {
            Token::KeywordConst => self.parse_const_let_statement(start),
            Token::KeywordLet => self.parse_let_statement(start),
            Token::KeywordStatic => self.parse_static_let_statement(start),
            Token::KeywordIf => self.parse_if_statement(start),
            Token::KeywordLoop => {
                self.advance();
                let body = self.parse_block_body()?;
                Ok(StmtData {
                    stmt: Stmt::Loop(body),
                    span: start..self.cursor,
                })
            }
            Token::KeywordReturn => {
                self.advance();
                let expr = if self.peek().token != Token::SemiColon {
                    Some(self.parse_expression()?)
                } else {
                    None
                };
                self.consume(&Token::SemiColon)?;
                Ok(StmtData {
                    stmt: Stmt::Return(expr),
                    span: start..self.cursor,
                })
            }
            Token::KeywordBreak => {
                self.advance();
                self.consume(&Token::SemiColon)?;
                Ok(StmtData {
                    stmt: Stmt::Break,
                    span: start..self.cursor,
                })
            }
            Token::KeywordContinue => {
                self.advance();
                self.consume(&Token::SemiColon)?;
                Ok(StmtData {
                    stmt: Stmt::Continue,
                    span: start..self.cursor,
                })
            }
            Token::LBrace => {
                self.advance();
                let mut q = vec![];
                while self.peek().token != Token::RBrace {
                    let stmt = self.parse_statement()?;
                    if stmt.stmt != Stmt::CompilerDud {
                        q.push(stmt);
                    }
                }
                self.advance();
                if q.is_empty() {
                    return Ok(StmtData {
                        stmt: Stmt::CompilerDud,
                        span: start..self.cursor,
                    });
                }
                return Ok(StmtData {
                    stmt: Stmt::Block(q.into()),
                    span: start..self.cursor,
                });
            }
            Token::RBrace | Token::SemiColon => Err((
                self.cursor..self.cursor + 1,
                ParserError::UnexpectedToken {
                    expected: "Statement".into(),
                    found: self.peek().token.clone(),
                },
            )),
            Token::KeywordFor => {
                self.advance();
                let q = self.parse_expression()?;
                self.consume(&Token::KeywordIn)?;
                let e = self.parse_expression()?;
                let body = self.parse_block_body()?;
                return Ok(StmtData {
                    stmt: Stmt::ForLoop(Box::new(q), Box::new(e), body),
                    span: start..self.cursor,
                });
            }
            Token::KeywordWhile => {
                self.advance();
                let q = self.parse_expression()?;
                let body = self.parse_block_body()?;
                return Ok(StmtData {
                    stmt: Stmt::WhileLoop(Box::new(q), body),
                    span: start..self.cursor,
                });
            }
            Token::KeywordDo => {
                self.advance();
                let body = self.parse_block_body()?;
                self.consume(&Token::KeywordWhile)?;
                let q = self.parse_expression()?;
                self.consume(&Token::SemiColon)?;
                return Ok(StmtData {
                    stmt: Stmt::DoWhileLoop(Box::new(q), body),
                    span: start..self.cursor,
                });
            }
            _ => {
                let expr = self.parse_expression()?;
                self.consume(&Token::SemiColon)?;
                Ok(StmtData {
                    stmt: Stmt::Expr(expr),
                    span: start..self.cursor,
                })
            }
        }
    }
    fn parse_const_let_statement(&mut self, start: usize) -> ParserResult<StmtData> {
        self.advance(); // const
        let name = self.consume_name()?;
        self.consume(&Token::Colon)?;
        let var_type = self.parse_type()?;
        self.consume(&Token::Equal)?;
        let initializer = self.parse_expression()?;
        self.consume(&Token::SemiColon)?;
        Ok(StmtData {
            stmt: Stmt::StaticLet(ParsedVariable {
                path: "".into(),
                attributes: Box::new([]),
                name: name.into(),
                var_type,
                prefixes: Box::new([]),
                expr: Some(initializer),
                var_comp_type: VarType::Constant,
            }),
            span: start..self.cursor,
        })
    }
    fn parse_static_let_statement(&mut self, start: usize) -> ParserResult<StmtData> {
        self.advance(); // static
        let name = self.consume_name()?;
        self.consume(&Token::Colon)?;
        let var_type = self.parse_type()?;

        let initializer = if self.peek().token == Token::Equal {
            self.advance();
            Some(self.parse_expression()?)
        } else {
            None
        };

        self.consume(&Token::SemiColon)?;
        Ok(StmtData {
            stmt: Stmt::StaticLet(ParsedVariable {
                path: "".into(),
                attributes: Box::new([]),
                name: name.into(),
                var_type,
                prefixes: Box::new([]),
                expr: initializer,
                var_comp_type: VarType::Static,
            }),
            span: start..self.cursor,
        })
    }
    fn parse_let_statement(&mut self, start: usize) -> ParserResult<StmtData> {
        self.advance(); // let
        let name = self.consume_name()?;
        self.consume(&Token::Colon)?;
        let var_type = self.parse_type()?;
        let initializer = if self.peek().token == Token::Equal {
            self.advance();
            Some(self.parse_expression()?)
        } else {
            None
        };

        self.consume(&Token::SemiColon)?;
        Ok(StmtData {
            stmt: Stmt::Let(ParsedVariable {
                path: "".into(),
                attributes: Box::new([]),
                name: name.into(),
                var_type,
                prefixes: Box::new([]),
                expr: initializer,
                var_comp_type: VarType::Stack,
            }),
            span: start..self.cursor,
        })
    }

    fn parse_if_statement(&mut self, start: usize) -> ParserResult<StmtData> {
        self.advance(); // if
        let condition = self.parse_expression()?;
        let then_body = self.parse_block_body()?;

        let else_branch = if self.peek().token == Token::KeywordElse {
            self.advance();
            if self.peek().token == Token::KeywordIf {
                // Else if
                let else_if_stmt = self.parse_if_statement(self.cursor)?;
                Box::new([else_if_stmt])
            } else {
                // Else
                self.parse_block_body()?
            }
        } else {
            Box::new([])
        };

        Ok(StmtData {
            stmt: Stmt::If(condition, then_body, else_branch),
            span: start..self.cursor,
        })
    }
    #[inline]
    fn parse_type(&mut self) -> ParserResult<ParserType> {
        let mut ep = ExpressionParser::new(self.remaining_tokens(), self.symbol_table);
        let pt = match ep.parse_type() {
            Ok(x) => x,
            Err(mut x) => {
                x.0 = self.cursor + x.0.start..self.cursor + x.0.end;
                return Err(x);
            }
        };
        self.cursor += ep.cursor();
        Ok(pt)
    }

    #[inline]
    fn parse_expression(&mut self) -> ParserResult<Expr> {
        let mut ep = ExpressionParser::new(self.remaining_tokens(), self.symbol_table);
        let expr = match ep.parse_expression() {
            Ok(x) => x,
            Err(mut x) => {
                x.0 = self.cursor + x.0.start..self.cursor + x.0.end;
                return Err(x);
            }
        };
        self.cursor += ep.cursor();
        Ok(expr)
    }
    #[inline]
    fn remaining_tokens(&self) -> &'a [TokenData] {
        if self.cursor < self.tokens.len() {
            &self.tokens[self.cursor..]
        } else {
            &[]
        }
    }
    fn parse_block_body(&mut self) -> ParserResult<Box<[StmtData]>> {
        self.consume(&Token::LBrace)?;
        let mut stmts = Vec::new();
        while self.peek().token != Token::RBrace && !self.is_at_end() {
            if self.peek().token == Token::SemiColon {
                self.advance();
                continue;
            }
            stmts.push(self.parse_statement()?);
        }
        self.consume(&Token::RBrace)?;
        Ok(stmts.into_boxed_slice())
    }
    fn prepend_modifier(prefixes: &mut Box<[String]>, modifier: &str) {
        let mut v = Vec::with_capacity(prefixes.len() + 1);
        v.push(modifier.to_string());
        v.extend_from_slice(prefixes);
        *prefixes = v.into_boxed_slice();
    }

    fn prepend_attributes(attrs: &mut Box<[Attribute]>, mut new_attrs: Vec<Attribute>) {
        if new_attrs.is_empty() {
            return;
        }
        new_attrs.extend_from_slice(attrs);
        *attrs = new_attrs.into_boxed_slice();
    }
}
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parser_type_namespace_link_transparent() {
        let plain = ParserType::Named("i32".into());
        let linked =
            ParserType::NamespaceLink("ns".into(), Box::new(ParserType::Named("i32".into())));
        assert_eq!(plain, linked);
        assert_eq!(linked, plain);
    }

    #[test]
    fn parser_type_display() {
        let t = ParserType::Pointer(Box::new(ParserType::Named("i32".into())));
        assert_eq!(t.to_string(), "*i32");

        let arr = ParserType::ConstantSizeArray(Box::new(ParserType::Named("u8".into())), 16);
        assert_eq!(arr.to_string(), "[u8; 16]");
    }

    #[test]
    fn attribute_one_argument() {
        let zero_args = Attribute {
            name: "test".into(),
            arguments: Box::new([]),
            span: 0..0,
        };
        assert!(zero_args.one_argument().is_none());
    }

    #[test]
    fn recursive_statement_count_leaf() {
        assert_eq!(Stmt::Break.recursive_statement_count(), 1);
        assert_eq!(Stmt::CompilerDud.recursive_statement_count(), 1);
    }

    #[test]
    fn prepend_modifier_ordering() {
        let mut prefixes: Box<[String]> = vec!["pub".into()].into_boxed_slice();
        GeneralParser::prepend_modifier(&mut prefixes, "inline");
        assert_eq!(&*prefixes, &["inline".to_string(), "pub".to_string()]);
    }
}
