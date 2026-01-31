use crate::{
    compiler_primitives::{
        DEFAULT_INTEGER_TYPE, PrimitiveInfo, PrimitiveKind, find_primitive_type,
    },
    expression_parser::{Expr, ExpressionParser},
};
use rcsharp_lexer::{Token, TokenData};
use std::fmt;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Span {
    pub start: usize,
    pub end: usize,
}
impl Span {
    pub fn new(start: usize, end: usize) -> Self {
        Self { start, end }
    }
    pub fn empty() -> Self {
        Self { start: 0, end: 0 }
    }
}
#[derive(Debug, Clone, PartialEq)]
pub enum ParserError {
    UnexpectedToken {
        expected: String,
        found: String,
    },
    UnexpectedTopLevelToken {
        found: String,
    },
    InvalidModifier {
        modifier: String,
        applicable_to: String,
    },
    AttributeError(String),
    ExpressionError(String),
    TypeError(String),
    Generic(String),
    ExpectedIdentifier {
        found: String,
    },
    OrphanedAttributes(usize),
}

impl fmt::Display for ParserError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::UnexpectedToken { expected, found } => {
                write!(f, "Expected token '{}', but found '{}'.", expected, found)
            }
            Self::UnexpectedTopLevelToken { found } => write!(
                f,
                "Unexpected token '{}'. Only functions, structs, enums, namespaces, and hints are allowed at the top level.",
                found
            ),
            Self::InvalidModifier {
                modifier,
                applicable_to,
            } => {
                write!(
                    f,
                    "Modifier '{}' is only applicable to {}.",
                    modifier, applicable_to
                )
            }
            Self::AttributeError(msg) => write!(f, "Attribute error: {}", msg),
            Self::ExpressionError(msg) => write!(f, "Expression parsing error: {}", msg),
            Self::TypeError(msg) => write!(f, "Type parsing error: {}", msg),
            Self::ExpectedIdentifier { found } => {
                write!(f, "Expected Identifier, found '{}'.", found)
            }
            Self::Generic(msg) => write!(f, "{}", msg),
            Self::OrphanedAttributes(count) => write!(
                f,
                "Found {} attribute(s) but no valid item followed them.",
                count
            ),
        }
    }
}

pub type ParserResult<T> = Result<T, (Span, (usize, usize), ParserError)>;

pub trait ParserResultExt<T> {
    fn unwrap_error_extended(self, token_data: &[TokenData], path: &str) -> Result<T, String>;
}

impl<T> ParserResultExt<T> for ParserResult<T> {
    fn unwrap_error_extended(self, token_data: &[TokenData], path: &str) -> Result<T, String> {
        match self {
            Ok(v) => Ok(v),
            Err((span, (row, column), err)) => {
                let valid_end = span.end.min(token_data.len());
                let valid_start = span.start.min(valid_end);
                let tokens: Vec<_> = token_data[valid_start..valid_end]
                    .iter()
                    .map(|x| &x.token)
                    .collect();

                Err(format!(
                    "Parser error with tokens:\n{:?}\n{} at {path}:{row}:{column}",
                    tokens, err
                ))
            }
        }
    }
}

#[derive(Debug, Clone, PartialEq)]
pub struct Attribute {
    pub name: Box<str>,
    pub arguments: Box<[Expr]>,
    pub span: Span,
}

impl Attribute {
    pub fn name_equals(&self, to: &str) -> bool {
        &*self.name == to
    }

    pub fn one_argument(&self) -> Option<&Expr> {
        if self.arguments.len() == 1 {
            Some(&self.arguments[0])
        } else {
            None
        }
    }
}

#[derive(Debug, Clone, PartialEq)]
pub struct ParsedStruct {
    pub path: Box<str>,
    pub attributes: Box<[Attribute]>,
    pub name: Box<str>,
    pub fields: Box<[(String, ParserType)]>,
    pub generic_params: Box<[String]>,
    pub prefixes: Box<[String]>,
}

#[derive(Debug, Clone, PartialEq)]
pub struct ParsedEnum {
    pub path: Box<str>,
    pub attributes: Box<[Attribute]>,
    pub name: Box<str>,
    pub fields: Box<[(String, Expr)]>,
    pub enum_type: ParserType,
    pub prefixes: Box<[String]>,
}

#[derive(Debug, Clone, PartialEq)]
pub struct ParsedFunction {
    pub path: Box<str>,
    pub attributes: Box<[Attribute]>,
    pub name: Box<str>,
    pub args: Box<[(String, ParserType)]>,
    pub return_type: ParserType,
    pub body: Box<[StmtData]>,
    pub prefixes: Box<[String]>,
    pub generic_params: Box<[String]>,
}
#[derive(Debug, Clone, PartialEq)]
pub enum Stmt {
    CompilerHint(Attribute),                    // #...
    Let(String, ParserType, Option<Expr>),      // let x : ...
    ConstLet(String, ParserType, Expr),         // const x : ...
    Static(String, ParserType, Option<Expr>),   // const x : ...
    Expr(Expr),                                 // a = 1 + b
    If(Expr, Box<[StmtData]>, Box<[StmtData]>), // if 1 == 1 {} `else `if` {}`
    Loop(Box<[StmtData]>),                      // loop { ... }
    Break,                                      // break
    Continue,                                   // continue
    Return(Option<Expr>),                       // return ...
    Function(ParsedFunction),                   // fn foo(bar: i8, ...) ... { ... }
    Struct(ParsedStruct),                       // struct foo <T> { bar : i8, ... }
    Enum(ParsedEnum),                           // enum foo 'base_type' { bar = ..., ... }
    Namespace(String, Box<[StmtData]>),         // namespace foo { fn bar() ... {...} ... }
    Debug(String),                              // ; 'debug statement'
}
impl Stmt {
    pub fn recursive_statement_count(&self) -> u64 {
        let one = 1;
        match self {
            Self::If(_, then_b, else_b) => {
                one + then_b
                    .iter()
                    .map(|x| x.stmt.recursive_statement_count())
                    .sum::<u64>()
                    + else_b
                        .iter()
                        .map(|x| x.stmt.recursive_statement_count())
                        .sum::<u64>()
            }
            Self::Namespace(_, body) | Self::Loop(body) => {
                one + body
                    .iter()
                    .map(|x| x.stmt.recursive_statement_count())
                    .sum::<u64>()
            }
            Self::Function(func) => {
                one + func
                    .body
                    .iter()
                    .map(|x| x.stmt.recursive_statement_count())
                    .sum::<u64>()
            }
            _ => one,
        }
    }

    pub fn dummy_data(self) -> StmtData {
        StmtData {
            stmt: self,
            span: Span { start: 0, end: 0 },
        }
    }
}

#[derive(Debug, Clone, PartialEq)]
pub struct StmtData {
    pub stmt: Stmt,
    pub span: Span,
}

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
        match (self, other) {
            (Self::Named(l), Self::Named(r)) => l == r,
            (Self::Pointer(l), Self::Pointer(r)) => l == r,
            (Self::Function(lr, la), Self::Function(rr, ra)) => lr == rr && la == ra,
            (Self::NamespaceLink(ls, lt), Self::NamespaceLink(rs, rt)) => ls == rs && lt == rt,
            (Self::Generic(ls, lt), Self::Generic(rs, rt)) => ls == rs && lt == rt,

            (Self::NamespaceLink(_, l), r) => r.eq(l),
            (l, Self::NamespaceLink(_, r)) => l.eq(r),
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
}

pub struct GeneralParser<'a> {
    tokens: &'a [TokenData],
    cursor: usize,
    len: usize,
}
impl<'a> GeneralParser<'a> {
    pub fn new(tokens: &'a [TokenData]) -> Self {
        Self {
            tokens,
            cursor: 0,
            len: tokens.len(),
        }
    }
    #[inline(always)]
    pub fn is_at_end(&self) -> bool {
        self.cursor >= self.len
    }
    #[inline(always)]
    fn peek(&self) -> &TokenData {
        if self.cursor < self.len {
            unsafe { self.tokens.get_unchecked(self.cursor) }
        } else {
            static DUMMY_EOF: TokenData = TokenData {
                token: Token::DummyToken,
                span: 0..0,
                col: 0,
                row: 0,
            };
            &DUMMY_EOF
        }
    }
    #[inline(always)]
    fn peek_offset(&self, offset: usize) -> &TokenData {
        if self.cursor + offset < self.len {
            unsafe { self.tokens.get_unchecked(self.cursor + offset) }
        } else {
            static DUMMY_EOF: TokenData = TokenData {
                token: Token::DummyToken,
                span: 0..0,
                col: 0,
                row: 0,
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
                    found: format!("{:?}", token_data.token),
                },
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
            }
            _ => {
                let found = format!("{:?}", token_data.token);
                Err((
                    self.peek_span(),
                    (token_data.row as usize, token_data.col as usize),
                    ParserError::ExpectedIdentifier { found },
                ))
            }
        }
    }
    pub fn parse_all(&mut self) -> ParserResult<Vec<StmtData>> {
        let mut statements = Vec::with_capacity(self.len / 4);
        while !self.is_at_end() {
            statements.push(self.parse_toplevel_item()?);
        }
        Ok(statements)
    }

    fn parse_toplevel_item(&mut self) -> ParserResult<StmtData> {
        let mut attributes = Vec::new();
        let mut start_span = self.peek_span();

        while self.peek().token == Token::Hint {
            let next_token = self.peek_offset(1);
            if next_token.token == Token::LSquareBrace {
                attributes.push(self.parse_attribute()?);
            } else {
                if !attributes.is_empty() {
                    let t = self.peek();
                    return Err((
                        start_span,
                        (t.row as usize, t.col as usize),
                        ParserError::OrphanedAttributes(attributes.len()),
                    ));
                }
                return self.parse_hint_stmt();
            }
        }
        if let Some(first) = attributes.first() {
            start_span = first.span;
        }

        let token_data = self.peek().clone();
        match &token_data.token {
            Token::KeywordFunction => self.parse_function(attributes, start_span),
            Token::KeywordStruct => self.parse_struct(attributes, start_span),
            Token::KeywordEnum => self.parse_enum(attributes, start_span),
            Token::KeywordNamespace => {
                if !attributes.is_empty() {
                    return Err((
                        start_span,
                        (token_data.row as usize, token_data.col as usize),
                        ParserError::AttributeError(
                            "Attributes are not allowed on namespaces".into(),
                        ),
                    ));
                }
                self.parse_namespace()
            }

            Token::KeywordInline => self.parse_with_modifier("inline", attributes),
            Token::KeywordConstExpr => self.parse_with_modifier("constexpr", attributes),
            Token::KeywordPub => self.parse_with_modifier("public", attributes),
            Token::KeywordNoReturn => self.parse_with_modifier("no_return", attributes),
            Token::KeywordExtern => self.parse_with_modifier("extern", attributes),
            Token::KeywordStatic => self.parse_static_let_statement(start_span.start),
            _ => {
                if !attributes.is_empty() {
                    return Err((
                        start_span,
                        (token_data.row as usize, token_data.col as usize),
                        ParserError::OrphanedAttributes(attributes.len()),
                    ));
                }
                let t = self.peek();
                Err((
                    self.peek_span(),
                    (token_data.row as usize, token_data.col as usize),
                    ParserError::UnexpectedTopLevelToken {
                        found: format!("{:?}", t.token),
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
        let token_data = self.peek().clone();
        self.advance();

        let mut item = self.parse_toplevel_item()?;
        match &mut item.stmt {
            Stmt::Function(func) => {
                Self::inject_modifier_and_attrs(
                    &mut func.prefixes,
                    &mut func.attributes,
                    modifier,
                    attributes,
                );
                Ok(item)
            }
            Stmt::Struct(strct) => {
                Self::inject_modifier_and_attrs(
                    &mut strct.prefixes,
                    &mut strct.attributes,
                    modifier,
                    attributes,
                );
                Ok(item)
            }
            Stmt::Enum(enm) => {
                Self::inject_modifier_and_attrs(
                    &mut enm.prefixes,
                    &mut enm.attributes,
                    modifier,
                    attributes,
                );
                Ok(item)
            }
            _ => Err((
                item.span,
                (token_data.row as usize, token_data.col as usize),
                ParserError::InvalidModifier {
                    modifier: modifier.into(),
                    applicable_to: "functions, structs, or enums".into(),
                },
            )),
        }
    }
    fn inject_modifier_and_attrs(
        prefixes: &mut Box<[String]>,
        attrs: &mut Box<[Attribute]>,
        modifier: &str,
        new_attrs: Vec<Attribute>,
    ) {
        let mut p = Vec::with_capacity(prefixes.len() + 1);
        p.extend_from_slice(prefixes);
        p.push(modifier.to_string());
        *prefixes = p.into_boxed_slice();

        if !new_attrs.is_empty() {
            let mut combined = new_attrs;
            combined.extend_from_slice(attrs);
            *attrs = combined.into_boxed_slice();
        }
    }
    fn parse_generic_params(&mut self) -> ParserResult<Vec<String>> {
        if self.peek().token != Token::LogicLess {
            return Ok(Vec::new());
        }
        self.advance();

        let mut generic_types = Vec::new();
        loop {
            if self.peek().token == Token::LogicGreater {
                self.advance();
                break;
            }
            generic_types.push(self.consume_name()?);
            let t = self.peek();
            match t.token {
                Token::Comma => {
                    self.advance();
                }
                Token::LogicGreater => {}
                _ => {
                    return Err((
                        self.peek_span(),
                        (t.row as usize, t.col as usize),
                        ParserError::UnexpectedToken {
                            expected: ", or >".into(),
                            found: format!("{:?}", t.token),
                        },
                    ));
                }
            }
        }
        Ok(generic_types)
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
            span: Span::new(start, self.cursor),
        })
    }
    fn parse_hint_stmt(&mut self) -> ParserResult<StmtData> {
        let start = self.cursor;
        self.advance(); // #
        let name = self.consume_name()?;
        let args = self.parse_arg_list_parens()?;

        Ok(StmtData {
            stmt: Stmt::CompilerHint(Attribute {
                name: name.into_boxed_str(),
                arguments: args.into_boxed_slice(),
                span: Span::new(start, self.cursor),
            }),
            span: Span::new(start, self.cursor),
        })
    }
    fn parse_arg_list_parens(&mut self) -> ParserResult<Vec<Expr>> {
        let mut args = Vec::new();
        if self.peek().token == Token::LParen {
            self.advance();
            while self.peek().token != Token::RParen && !self.is_at_end() {
                args.push(self.parse_expression()?);
                if self.peek().token == Token::Comma {
                    self.advance();
                } else {
                    break;
                }
            }
            self.consume(&Token::RParen)?;
        }
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
                span: Span::new(start, self.cursor),
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
            span: Span::new(start, self.cursor),
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
            span: Span::new(start, self.cursor),
        })
    }
    fn parse_namespace(&mut self) -> ParserResult<StmtData> {
        let start = self.cursor;
        self.advance(); // namespace
        let name = self.consume_name()?;
        self.consume(&Token::LBrace)?;
        let mut body = Vec::new();
        loop {
            if self.peek().token == Token::RBrace {
                break;
            }
            body.push(self.parse_toplevel_item()?);
        }
        self.consume(&Token::RBrace)?;
        Ok(StmtData {
            stmt: Stmt::Namespace(name, body.into_boxed_slice()),
            span: Span::new(start, self.cursor),
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
            span: Span::new(start, self.cursor),
        })
    }

    fn parse_statement(&mut self) -> ParserResult<StmtData> {
        let start = self.cursor;

        match self.peek().token {
            Token::KeywordConst => self.parse_const_let_statement(start),
            Token::KeywordVariableDeclaration => self.parse_let_statement(start),
            Token::KeywordStatic => self.parse_static_let_statement(start),
            Token::KeywordIf => self.parse_if_statement(start),
            Token::KeywordLoop => {
                self.advance();
                let body = self.parse_block_body()?;
                Ok(StmtData {
                    stmt: Stmt::Loop(body),
                    span: Span::new(start, self.cursor),
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
                    span: Span::new(start, self.cursor),
                })
            }
            Token::KeywordBreak => {
                self.advance();
                self.consume(&Token::SemiColon)?;
                Ok(StmtData {
                    stmt: Stmt::Break,
                    span: Span::new(start, self.cursor),
                })
            }
            Token::KeywordContinue => {
                self.advance();
                self.consume(&Token::SemiColon)?;
                Ok(StmtData {
                    stmt: Stmt::Continue,
                    span: Span::new(start, self.cursor),
                })
            }
            Token::LBrace | Token::RBrace | Token::SemiColon => {
                let t = self.peek();
                Err((
                    self.peek_span(),
                    (t.row as usize, t.col as usize),
                    ParserError::UnexpectedToken {
                        expected: "Statement".into(),
                        found: format!("{:?} at {}:{}", t.token, t.row, t.col),
                    },
                ))
            }
            _ => {
                let expr = self.parse_expression()?;
                self.consume(&Token::SemiColon)?;
                Ok(StmtData {
                    stmt: Stmt::Expr(expr),
                    span: Span::new(start, self.cursor),
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
            stmt: Stmt::ConstLet(name, var_type, initializer),
            span: Span::new(start, self.cursor),
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
            stmt: Stmt::Static(name, var_type, initializer),
            span: Span::new(start, self.cursor),
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
            stmt: Stmt::Let(name, var_type, initializer),
            span: Span::new(start, self.cursor),
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
            span: Span::new(start, self.cursor),
        })
    }
    #[inline(always)]
    fn parse_type(&mut self) -> ParserResult<ParserType> {
        let remaining = if self.cursor < self.len {
            &self.tokens[self.cursor..]
        } else {
            &[]
        };
        let mut ep = ExpressionParser::new(remaining);
        let pt = ep.parse_type()?;
        self.cursor += ep.cursor();
        Ok(pt)
    }
    #[inline(always)]
    fn parse_expression(&mut self) -> ParserResult<Expr> {
        let remaining = if self.cursor < self.len {
            &self.tokens[self.cursor..]
        } else {
            &[]
        };
        let mut expr_parser = ExpressionParser::new(remaining);
        let expr = expr_parser.parse_expression()?;
        self.cursor += expr_parser.cursor();
        Ok(expr)
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
}
