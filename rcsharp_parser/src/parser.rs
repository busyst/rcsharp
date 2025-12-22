use std::fmt;
use rcsharp_lexer::{Token, TokenData};
use crate::{compiler_primitives::{DEFAULT_INTEGER_TYPE, PrimitiveInfo, PrimitiveKind, find_primitive_type}, expression_parser::{Expr, ExpressionParser}};

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Span { pub start: usize, pub end: usize }
impl Span {
    pub fn new(start: usize, end: usize) -> Self {
        Self { start, end }
    }
}
#[derive(Debug, Clone, PartialEq)]
pub enum ParserError {
    UnexpectedToken { expected: String, found: String },
    UnexpectedTopLevelToken { found: String },
    InvalidModifier { modifier: String, applicable_to: String },
    AttributeError(String),
    ExpressionError(String),
    TypeError(String),
    Generic(String),
    ExpectedIdentifier { found: String },
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
            Self::InvalidModifier { modifier, applicable_to } => {
                write!(f, "Modifier '{}' is only applicable to {}.", modifier, applicable_to)
            }
            Self::AttributeError(msg) => write!(f, "Attribute error: {}", msg),
            Self::ExpressionError(msg) => write!(f, "Expression parsing error: {}", msg),
            Self::TypeError(msg) => write!(f, "Type parsing error: {}", msg),
            Self::ExpectedIdentifier { found } => write!(f, "Expected Identifier, found '{}'.", found),
            Self::Generic(msg) => write!(f, "{}", msg),
            Self::OrphanedAttributes(count) => write!(f, "Found {} attribute(s) but no valid item followed them.", count),
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
                let tokens: Vec<_> = token_data[valid_start..valid_end].iter().map(|x| &x.token).collect();
                
                Err(format!("Parser error with tokens:\n{:?}\n{} at {path}:{row}:{column}", tokens, err))
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
    CompilerHint(Attribute), // #...
    Let(String, ParserType, Option<Expr>), // let x : ...
    ConstLet(String, ParserType, Expr), // const x : ...
    Expr(Expr), // a = 1 + b
    If(Expr, Box<[StmtData]>, Box<[StmtData]>), // if 1 == 1 {} `else `if` {}`
    Loop(Box<[StmtData]>), // loop { ... }
    Break, // break
    Continue, // continue
    Return(Option<Expr>), // return ...
    Function(ParsedFunction), // fn foo(bar: i8, ...) ... { ... }
    Struct(ParsedStruct), // struct foo <T> { bar : i8, ... }
    Enum(ParsedEnum), // enum foo 'base_type' { bar = ..., ... }
    Namespace(String, Box<[StmtData]>), // namespace foo { fn bar() ... {...} ... }
}
impl Stmt {
    pub fn recursive_statement_count(&self) -> u64 {
        let one = 1;
        match self {
            Self::If(_, then_b, else_b) => { 
                one + then_b.iter().map(|x| x.stmt.recursive_statement_count()).sum::<u64>() 
                    + else_b.iter().map(|x| x.stmt.recursive_statement_count()).sum::<u64>()
            }
            Self::Loop(body) => { 
                one + body.iter().map(|x| x.stmt.recursive_statement_count()).sum::<u64>()
            }
            Self::Namespace(_, body) => { 
                one + body.iter().map(|x| x.stmt.recursive_statement_count()).sum::<u64>()
            }
            Self::Function(func) => { 
                one + func.body.iter().map(|x| x.stmt.recursive_statement_count()).sum::<u64>()
            }
            _ => one,
        }
    }
    
    pub fn dummy_data(self) -> StmtData {
        StmtData { stmt: self, span: Span { start: 0, end: 0 } }
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
        self.as_primitive_type().filter(|x| x.kind == PrimitiveKind::SignedInt || x.kind == PrimitiveKind::UnsignedInt)
    }
    pub fn as_decimal(&self) -> Option<&'static PrimitiveInfo> {
        self.as_primitive_type().filter(|x| x.kind == PrimitiveKind::Decimal)
    }
    pub fn as_pointer(&self) -> Option<&ParserType>{
        if let ParserType::Pointer(x) = self {
            return Some(&x); // Inner
        }
        None
    }
    pub fn as_function(&self) -> Option<(&ParserType, &[ParserType])>{
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


    pub fn is_integer(&self) -> bool {
        self.as_primitive_type().map_or(false, |x| {
            matches!(x.kind, PrimitiveKind::SignedInt | PrimitiveKind::UnsignedInt)
        })
    }
    
    pub fn is_signed_integer(&self) -> bool {
        self.as_primitive_type().map_or(false, |x| matches!(x.kind, PrimitiveKind::SignedInt))
    }

    pub fn is_unsigned_integer(&self) -> bool {
        self.as_primitive_type().map_or(false, |x| matches!(x.kind, PrimitiveKind::UnsignedInt))
    }

    pub fn is_decimal(&self) -> bool {
        self.as_primitive_type().map_or(false, |x| matches!(x.kind, PrimitiveKind::Decimal))
    }
    
    pub fn is_bool(&self) -> bool {
        self.as_primitive_type().map_or(false, |x| matches!(x.kind, PrimitiveKind::Bool))
    }

    pub fn is_void(&self) -> bool {
        self.as_primitive_type().map_or(false, |x| matches!(x.kind, PrimitiveKind::Void))
    }

    pub fn is_pointer(&self) -> bool {
        matches!(self, ParserType::Pointer(_))
    }

    pub fn is_function(&self) -> bool {
        matches!(self, ParserType::Function(_, _))
    }

    pub fn is_generic(&self) -> bool {
        matches!(self, ParserType::Generic(_, _))
    }

    pub fn is_primitive_type(&self) -> bool {
        self.as_primitive_type().is_some()
    }

    pub fn as_both_integers(&self, other: &ParserType) -> Option<(&'static PrimitiveInfo, &'static PrimitiveInfo)> {
        if let (Some(x),Some(y)) = (self.as_integer(), other.as_integer()) {
            return Some((x,y));
        }
        None
    }
    pub fn as_both_decimals(&self, other: &ParserType) -> Option<(&'static PrimitiveInfo, &'static PrimitiveInfo)> {
        if let (Some(x),Some(y)) = (self.as_decimal(), other.as_decimal()) {
            return Some((x,y));
        }
        None
    }

    
    // Helper
    pub fn self_reference_once(self) -> ParserType{
        ParserType::Pointer(Box::new(self))
    }
    pub fn try_dereference_once(&self) -> &ParserType{
        match self {
            ParserType::Pointer(x) => x,
            _ => self,
        }
    }
    pub fn dereference_full(&self) -> &ParserType{
        match self {
            ParserType::Pointer(x) => x.dereference_full(),
            _ => self,
        }
    }
    pub fn full_delink(&self) -> &ParserType {
        match self {
            ParserType::NamespaceLink(_, c) => c.full_delink(),
            _ => self,
        }
    }
    pub fn type_name(&self) -> String{
        match self {
            ParserType::Named(name) => name.to_string(),
            ParserType::Generic(name, _) => name.to_string(),
            ParserType::NamespaceLink(link, core) => format!("{}.{}", link, core.type_name()),
            _ => panic!("{:?}", self)
        }
    }
    pub fn debug_type_name(&self) -> String{
        match self {
            ParserType::Named(name) => name.to_string(),
            ParserType::Generic(name, _) => name.to_string(),
            ParserType::NamespaceLink(link, core) => format!("{}.{}", link, core.type_name()),
            ParserType::Function(ret, args) => format!("fn({}) :{}", args.iter().map(|x| x.debug_type_name()).collect::<Vec<_>>().join(", "), ret.debug_type_name() ),
            ParserType::Pointer(core) => format!("*{}", core.debug_type_name()),
        }
    }
    pub fn get_absolute_path_or(&self, current_path: &str) -> String{
        match self {
            ParserType::NamespaceLink(x, y) =>{
                format!("{}.{}", x, y.type_name())
            }
            ParserType::Named(x) =>{
                if current_path.is_empty() || self.is_primitive_type() {
                    x.clone().to_string()
                }else {
                    format!("{}.{}", current_path, x.clone())
                }
            }
            ParserType::Generic(x, _) =>{
                if current_path.is_empty() || self.is_primitive_type() {
                    x.clone().to_string()
                }else {
                    format!("{}.{}",current_path, x.clone())
                }
            }
            _ => panic!("Cannot get abs type of {:?}", self),
        }
    }
}

pub struct GeneralParser<'a> {
    tokens: &'a [TokenData],
    cursor: usize,
}
impl<'a> GeneralParser<'a> {
    pub fn new(tokens: &'a [TokenData]) -> Self {
        Self { tokens, cursor: 0 }
    }
    #[inline]
    pub fn is_at_end(&self) -> bool {
        self.cursor >= self.tokens.len()
    }
    fn peek(&self) -> &TokenData {
        static DUMMY_EOF: TokenData = TokenData {
            token: Token::DummyToken,
            span: 0..0,
            col: 0,
            row: 0,
        };
        self.tokens.get(self.cursor).unwrap_or(&DUMMY_EOF)
    }

    fn peek_span(&self) -> Span {
        if self.is_at_end() {
            if let Some(last) = self.tokens.last() {
                return Span::new(last.span.end, last.span.end);
            }
            return Span::new(0, 0);
        }
        let t = self.peek();
        Span::new(t.span.start, t.span.end)
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
                    found: format!("{:?}", token_data.token),
                },
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
        let mut statements = Vec::new();
        while !self.is_at_end() {
            statements.push(self.parse_toplevel_item()?);
        }
        Ok(statements)
    }
    
    fn parse_toplevel_item(&mut self) -> ParserResult<StmtData> {
       let mut attributes = Vec::new();
        let mut start_span = self.peek_span();

        while self.peek().token == Token::Hint {
            let cur = self.cursor;
            if let Ok(x) = self.parse_attribute_or_hint() {
                attributes.push(x);
            }else {
                self.cursor = cur;
                if let Ok(x) = self.parse_hint() {
                    let span = x.span.clone();
                    return Ok(StmtData {
                        stmt: Stmt::CompilerHint(x),
                        span: span,
                    });
                }
                let x = self.peek_span();
                let (r,c) = (self.peek().row as usize, self.peek().col as usize);
                return Err((x, (r,c), ParserError::Generic(format!(""))));
            }
        }
        if let Some(first) = attributes.first() {
            start_span = first.span;
        }
        
        let token_data = self.peek().clone();
        match &token_data.token {
            Token::KeywordFunction => self.parse_function(attributes),
            Token::KeywordStruct => self.parse_struct(attributes),
            Token::KeywordEnum => self.parse_enum(attributes),
            Token::KeywordNamespace => {
                 if !attributes.is_empty() {
                     return Err((start_span, (token_data.row as usize, token_data.col as usize), ParserError::AttributeError("Attributes are not allowed on namespaces".into())));
                 }
                 self.parse_namespace()
            },
            
            Token::KeywordInline => self.parse_with_modifier("inline", attributes),
            Token::KeywordConstExpr => self.parse_with_modifier("constexpr", attributes),
            Token::KeywordPub => self.parse_with_modifier("public", attributes),
            
            _ => {
                if !attributes.is_empty() {
                     return Err((
                        start_span,
                        (token_data.row as usize, token_data.col as usize),
                        ParserError::OrphanedAttributes(attributes.len())
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
            },
        }
    }
    
    fn parse_with_modifier(&mut self, modifier: &str, attributes: Vec<Attribute>) -> ParserResult<StmtData> {
        let token_data = self.peek().clone();
        self.advance();

        let mut item = self.parse_toplevel_item()?;
        
        match &mut item.stmt {
            Stmt::Function(func) => {
                let mut p = func.prefixes.to_vec();
                p.push(modifier.to_string());
                func.prefixes = p.into_boxed_slice();

                if !attributes.is_empty() {
                    let mut combined = attributes;
                    combined.extend(func.attributes.iter().cloned());
                    func.attributes = combined.into_boxed_slice();
                }
                Ok(item)
            }
            Stmt::Struct(strct) => {
                 let mut p = strct.prefixes.to_vec();
                p.push(modifier.to_string());
                strct.prefixes = p.into_boxed_slice();
                 if !attributes.is_empty() {
                    let mut combined = attributes;
                    combined.extend(strct.attributes.iter().cloned());
                    strct.attributes = combined.into_boxed_slice();
                }
                Ok(item)
            }
            Stmt::Enum(enm) => {
                 let mut p = enm.prefixes.to_vec();
                p.push(modifier.to_string());
                enm.prefixes = p.into_boxed_slice();
                 if !attributes.is_empty() {
                    let mut combined = attributes;
                    combined.extend(enm.attributes.iter().cloned());
                    enm.attributes = combined.into_boxed_slice();
                }
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
    
    fn parse_generic_params(&mut self) -> ParserResult<Vec<String>> {
        let mut generic_types = vec![];
        if self.peek().token == Token::LogicLess {
            self.advance();
            loop {
                if self.peek().token == Token::LogicGreater {
                    self.advance();
                    break;
                }
                
                generic_types.push(self.consume_name()?);

                if self.peek().token == Token::Comma {
                    self.advance();
                } else if self.peek().token != Token::LogicGreater {
                     let t = self.peek();
                     return Err((self.peek_span(), (t.row as usize, t.col as usize), 
                        ParserError::UnexpectedToken{ expected: ", or >".into(), found: format!("{:?}", t.token) }));
                }
            }
        }
        Ok(generic_types)
    }
    fn parse_attribute_or_hint(&mut self) -> ParserResult<Attribute> {
        let start = self.cursor;
        self.consume(&Token::Hint)?;
        self.consume(&Token::LSquareBrace)?;
        let name = self.consume_name()?;
        let mut args = vec![];
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
        self.consume(&Token::RSquareBrace)?;
        Ok(Attribute {
            name: name.into_boxed_str(),
            arguments: args.into_boxed_slice(),
            span: Span::new(start, self.cursor),
        })
    }
    fn parse_hint(&mut self) -> ParserResult<Attribute> {
        let start = self.cursor;
        self.consume(&Token::Hint)?;
        let name = self.consume_name()?;
        let mut args = vec![];
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
        Ok(Attribute {
            name: name.into_boxed_str(),
            arguments: args.into_boxed_slice(),
            span: Span::new(start, self.cursor),
        })
    }

    fn parse_function(&mut self, attributes: Vec<Attribute>) -> ParserResult<StmtData> {
        let start = attributes.first().map(|x: &Attribute| x.span.start).unwrap_or(self.cursor);
        self.consume(&Token::KeywordFunction)?;
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

        let mut return_type = ParserType::Named("void".to_string());
        if self.peek().token == Token::Colon {
            self.advance();
            return_type = self.parse_type()?;
        }

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
    fn parse_struct(&mut self, attributes: Vec<Attribute>) -> ParserResult<StmtData> {
        let start = attributes.first().map(|x| x.span.start).unwrap_or(self.cursor);
        self.consume(&Token::KeywordStruct)?;
        let name = self.consume_name()?;

        let generic_types = self.parse_generic_params()?;

        self.consume(&Token::LBrace)?;

        let mut fields = Vec::new();
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
        self.consume(&Token::KeywordNamespace)?;
        let x = self.consume_name()?;
        self.consume(&Token::LBrace)?;
        let mut body = vec![];
        loop {
            if self.peek().token == Token::RBrace {
                break;
            }
            body.push(self.parse_toplevel_item()?);
        }
        self.consume(&Token::RBrace)?;
        Ok(StmtData {
            stmt: Stmt::Namespace(x, body.into_boxed_slice()),
            span: Span::new(start, self.cursor),
        })
    }
    fn parse_enum(&mut self, attributes: Vec<Attribute>) -> ParserResult<StmtData> {
        let start = attributes.first().map(|x| x.span.start).unwrap_or(self.cursor);
        self.consume(&Token::KeywordEnum)?;
        let name = self.consume_name()?;
        
        let enum_base_type = if self.peek().token == Token::Colon {
            self.advance();
            self.parse_type()?
        } else {
            DEFAULT_INTEGER_TYPE.into()
        };

        self.consume(&Token::LBrace)?;
        let mut values = vec![];
        let mut counter = 0;

        while self.peek().token != Token::RBrace && !self.is_at_end() {
            let name = self.consume_name()?;

            let expr = if self.peek().token == Token::Equal {
                self.advance();
                self.parse_expression()?
            } else {
                Expr::Integer(counter.to_string())
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
        let token_data = self.peek().clone();

        match &self.peek().token {
            Token::KeywordConst => self.parse_const_let_statement(),
            Token::KeywordVariableDeclaration => self.parse_let_statement(),
            Token::KeywordIf => self.parse_if_statement(),
            Token::KeywordLoop => self.parse_loop_statement(),
            Token::KeywordReturn => self.parse_return_statement(),
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
            Token::LBrace | Token::RBrace | Token::SemiColon => Err((
                self.peek_span(),
                (token_data.row as usize, token_data.col as usize),
                ParserError::UnexpectedToken {
                    expected: "Statement".into(),
                    found: format!("{:?} at {}:{}", self.peek().token, self.peek().row, self.peek().col),
                },
            )),
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
    fn parse_const_let_statement(&mut self) -> ParserResult<StmtData> {
        let start = self.cursor;
        self.consume(&Token::KeywordConst)?;
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
    fn parse_let_statement(&mut self) -> ParserResult<StmtData> {
        let start = self.cursor;
        self.consume(&Token::KeywordVariableDeclaration)?;
        let name = self.consume_name()?;
        self.consume(&Token::Colon)?;
        let var_type = self.parse_type()?;

        let mut initializer: Option<Expr> = None;
        if self.peek().token == Token::Equal {
            self.consume(&Token::Equal)?;
            initializer = Some(self.parse_expression()?);
        }

        self.consume(&Token::SemiColon)?;
        Ok(StmtData {
            stmt: Stmt::Let(name, var_type, initializer),
            span: Span::new(start, self.cursor),
        })
    }

    fn parse_if_statement(&mut self) -> ParserResult<StmtData> {
        let start = self.cursor;
        self.consume(&Token::KeywordIf)?;
        let condition = self.parse_expression()?;
        let then_body = self.parse_block_body()?;

        let else_branch = if self.peek().token == Token::KeywordElse {
            self.advance();
            if self.peek().token == Token::KeywordIf {
                let else_if_stmt = self.parse_if_statement()?;
                Box::new([else_if_stmt])
            } else {
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
    fn parse_loop_statement(&mut self) -> ParserResult<StmtData> {
        let start = self.cursor;
        self.consume(&Token::KeywordLoop)?;
        let body = self.parse_block_body()?;
        Ok(StmtData {
            stmt: Stmt::Loop(body),
            span: Span::new(start, self.cursor),
        })
    }

    fn parse_return_statement(&mut self) -> ParserResult<StmtData> {
        let start = self.cursor;
        self.consume(&Token::KeywordReturn)?;
        let mut return_expr: Option<Expr> = None;

        if self.peek().token != Token::SemiColon {
            return_expr = Some(self.parse_expression()?);
        }

        self.consume(&Token::SemiColon)?;
        Ok(StmtData {
            stmt: Stmt::Return(return_expr),
            span: Span::new(start, self.cursor),
        })
    }

    fn parse_type(&mut self) -> ParserResult<ParserType> {
        let mut ep = ExpressionParser::new(&self.tokens[self.cursor..]);
        let pt = ep.parse_type()?;
        self.cursor += ep.cursor();
        Ok(pt)
    }

    fn parse_expression(&mut self) -> ParserResult<Expr> {
        let mut expr_parser = ExpressionParser::new(&self.tokens[self.cursor..]);
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