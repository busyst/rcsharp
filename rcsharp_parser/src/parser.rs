use std::fmt;

use rcsharp_lexer::{Token, TokenData};

use crate::{compiler_primitives::{PrimitiveInfo, PrimitiveKind, find_primitive_type}, expression_parser::{Expr, ExpressionParser}};
#[derive(Debug, Clone, Copy, PartialEq)]
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
}

impl fmt::Display for ParserError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Self::UnexpectedToken { expected, found } => 
                write!(f, "Expected token '{}', but found '{}'.", expected, found),
            Self::UnexpectedTopLevelToken { found } => 
                write!(f, "Unexpected token '{}'. Only functions, structs, enums, namespaces, and hints are allowed at the top level.", found),
            Self::InvalidModifier { modifier, applicable_to } => 
                write!(f, "Modifier '{}' is only applicable to {}.", modifier, applicable_to),
            Self::AttributeError(msg) => write!(f, "Attribute error: {}", msg),
            Self::ExpressionError(msg) => write!(f, "Expression parsing error: {}", msg),
            Self::TypeError(msg) => write!(f, "Type parsing error: {}", msg),
            Self::ExpectedIdentifier { found } => write!(f, "Expected Identifier, found '{}'.", found),
            Self::Generic(msg) => write!(f, "{}", msg),
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
                // Safely handle slice bounds
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
    name: Box<str>,
    arguments: Box<[Expr]>
}
impl Attribute {
    pub fn new(name: impl Into<Box<str>>, arguments: impl Into<Box<[Expr]>>) -> Self {
        Self { name: name.into(), arguments: arguments.into() }
    }
    pub fn name_equals(&self, to: &str) -> bool{
        &*self.name == to
    }

    pub fn one_argument(&self) -> Result<&Expr, String> {
        if self.arguments.len() == 1 {
            Ok(&self.arguments[0])
        } else {
            Err(format!(
                "Attribute {} should have only one argument, but it has {}",
                self.name,
                self.arguments.len()
            ))
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

impl ParsedStruct {
    pub fn new_parse(
        path: impl Into<Box<str>>, 
        attributes: impl Into<Box<[Attribute]>>, 
        name: impl Into<Box<str>>, 
        fields: impl Into<Box<[(String, ParserType)]>>, 
        generic_params: impl Into<Box<[String]>>
    ) -> Self {
        ParsedStruct {
            path: path.into(), 
            attributes: attributes.into(), 
            name: name.into(), 
            fields: fields.into(), 
            generic_params: generic_params.into(), 
            prefixes: Box::new([])
        }
    }
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

impl ParsedEnum {
    pub fn new_parse(
        path: impl Into<Box<str>>, 
        name: impl Into<Box<str>>, 
        fields: impl Into<Box<[(String, Expr)]>>, 
        enum_type: ParserType
    ) -> Self {
        ParsedEnum {
            path: path.into(), 
            attributes: Box::new([]), 
            name: name.into(), 
            fields: fields.into(), 
            enum_type, 
            prefixes: Box::new([])
        }
    }
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
impl ParsedFunction {
    pub fn new_parse(
        name: impl Into<Box<str>>, 
        args: impl Into<Box<[(String, ParserType)]>>, 
        return_type: ParserType, 
        body: impl Into<Box<[StmtData]>>,
        generic_params: impl Into<Box<[String]>>
    ) -> Self {
        ParsedFunction { 
            path: String::new().into(), 
            attributes: Box::new([]), 
            name: name.into(), 
            args: args.into(), 
            return_type, 
            body: body.into(), 
            prefixes: Box::new([]), 
            generic_params: generic_params.into() 
        }
    }
}

#[derive(Debug, Clone, PartialEq)]
pub enum Stmt {
    Hint(String, Box<[Expr]>), // #[...]
    Let(String, ParserType, Option<Expr>), // let x : ...
    Expr(Expr), // a = 1 + b
    If(Expr, Box<[StmtData]>, Box<[StmtData]>), // if 1 == 1 {} `else `if` {}`
    Loop(Box<[StmtData]>), // loop { ... }
    Break, // break
    Continue, // continue
    Return(Option<Expr>), // return ...
    Function(ParsedFunction), // fn foo(bar: i8, ...) ... { ... }
    Struct(String, Box<[(String, ParserType)]>, Box<[String]>), // struct foo <T> { bar : i8, ... }
    Enum(String, Option<ParserType>, Box<[(String, Expr)]>), // enum foo 'base_type' { bar = ..., ... }
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
    Function(Box<ParserType>, Box<[ParserType]>), // return type, arguments
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


    pub fn is_primitive_type(&self) -> bool {
        self.as_primitive_type().is_some()
    }
    pub fn is_integer(&self) -> bool {
        self.as_integer().is_some()
    }
    pub fn is_unsigned_integer(&self) -> bool {
        self.as_primitive_type().filter(|x| x.kind == PrimitiveKind::UnsignedInt).is_some()
    }
    pub fn is_signed_integer(&self) -> bool {
        self.as_primitive_type().filter(|x| x.kind == PrimitiveKind::SignedInt).is_some()
    }

    pub fn is_decimal(&self) -> bool {
        self.as_decimal().is_some()
    }
    pub fn is_bool(&self) -> bool{
        self.as_primitive_type().filter(|x| x.kind == PrimitiveKind::Bool).is_some()
    }
    pub fn is_void(&self) -> bool{
        self.as_primitive_type().filter(|x| x.kind == PrimitiveKind::Void).is_some()
    }

    pub fn is_pointer(&self) -> bool{
        matches!(self, ParserType::Pointer(_))
    }
    pub fn is_function(&self) -> bool {
        matches!(self, ParserType::Function(..))
    }
    pub fn is_generic(&self) -> bool {
        matches!(self, ParserType::Generic(..))
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
    
    pub fn is_at_end(&self) -> bool {
        self.cursor >= self.tokens.len()
    }
    fn peek(&self) -> &TokenData {
        static DUMMY_EOF: TokenData = TokenData { 
            token: Token::DummyToken, 
            span: 0..0, 
            col: 0, 
            row: 0 
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
    
    pub fn parse_all(&mut self) -> ParserResult<Vec<StmtData>> {
        let mut statements = Vec::new();
        while !self.is_at_end() {
            statements.push(self.parse_toplevel_item()?);
        }
        Ok(statements)
    }
    
    fn parse_toplevel_item(&mut self) -> ParserResult<StmtData> {
        let token_data = self.peek().clone();
        match &token_data.token {
            Token::Hint => self.parse_hint(),
            Token::KeywordFunction => self.parse_function(),
            Token::KeywordStruct => self.parse_struct(),
            Token::KeywordEnum => self.parse_enum(),
            Token::KeywordNamespace => self.parse_namespace(),
            
            // Handle modifiers
            Token::KeywordInline => self.parse_with_modifier("inline"),
            Token::KeywordConstExpr => self.parse_with_modifier("constexpr"),
            Token::KeywordPub => self.parse_with_modifier("public"),
            
            _ => {
                let t = self.peek();
                Err((
                    self.peek_span(),
                    (token_data.row as usize, token_data.col as usize),
                    ParserError::UnexpectedTopLevelToken { 
                        found: format!("{:?}", t.token)
                    }
                ))
            },
        }
    }
    
    fn parse_with_modifier(&mut self, modifier: &str) -> ParserResult<StmtData> {
        let token_data = self.peek().clone();
        self.advance();
        
        let mut item = self.parse_toplevel_item()?;
        if let Stmt::Function(func) = &mut item.stmt {
            let mut p = func.prefixes.to_vec(); 
            p.push(modifier.to_string());
            func.prefixes = p.into_boxed_slice();
            Ok(item)
        } else {
            Err((
                item.span, 
                (token_data.row as usize, token_data.col as usize), 
                ParserError::InvalidModifier { 
                    modifier: modifier.into(), 
                    applicable_to: "functions".into() 
                }
            ))
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
                if self.peek().token == Token::BinaryShiftR {
                   todo!("Handle nested generics ending with >>")
                }
                
                generic_types.push(self.consume_name()?);
                
                if self.peek().token == Token::Comma {
                    self.advance();
                }
            }
        }
        Ok(generic_types)
    }
    
    fn parse_hint(&mut self) -> ParserResult<StmtData> {
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
        Ok(StmtData { 
            stmt: Stmt::Hint(name, args.into_boxed_slice()), 
            span: Span::new(start, self.cursor) 
        })
    } 

    fn parse_function(&mut self) -> ParserResult<StmtData> {
        let start = self.cursor;
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
                stmt: Stmt::Function(ParsedFunction::new_parse(name, args, return_type, *Box::new([]), generic_types)), 
                span: Span::new(start, self.cursor) 
            });
        } 
        
        let body = self.parse_block_body()?;
        
        Ok(StmtData { 
            stmt: Stmt::Function(ParsedFunction::new_parse(name, args, return_type, body, generic_types)), 
            span: Span::new(start, self.cursor) 
        })
    }  
    
    fn parse_struct(&mut self) -> ParserResult<StmtData> {
        let start = self.cursor;
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
            stmt: Stmt::Struct(name, fields.into_boxed_slice(), generic_types.into_boxed_slice()),
            span: Span::new(start, self.cursor)
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
            span: Span::new(start, self.cursor)
        })
    }
    
    fn parse_enum(&mut self) -> ParserResult<StmtData> {
        let start = self.cursor;
        self.consume(&Token::KeywordEnum)?;
        let name = self.consume_name()?;
        let enum_base_type = if self.peek().token == Token::Colon {
            self.advance();
            Some(self.parse_type()?)
        } else {
           None
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
            stmt: Stmt::Enum(name, enum_base_type, values.into_boxed_slice()),
            span: Span::new(start, self.cursor)
        })
    }
    
    fn parse_statement(&mut self) -> ParserResult<StmtData> {
        let start = self.cursor;
        let token_data = self.peek().clone();
        
        match &self.peek().token {
            Token::KeywordVariableDeclaration => self.parse_let_statement(),
            Token::KeywordIf => self.parse_if_statement(),
            Token::KeywordLoop => self.parse_loop_statement(),
            Token::KeywordReturn => self.parse_return_statement(),
            Token::KeywordBreak => {
                self.advance();
                self.consume(&Token::SemiColon)?;
                Ok(StmtData { stmt: Stmt::Break, span: Span::new(start, self.cursor) })
            }
            Token::KeywordContinue => {
                self.advance();
                self.consume(&Token::SemiColon)?;
                Ok(StmtData { stmt: Stmt::Continue, span: Span::new(start, self.cursor) })
            }
            Token::LBrace | Token::RBrace | Token::SemiColon => {
                Err((
                    self.peek_span(),  
                    (token_data.row as usize, token_data.col as usize), 
                    ParserError::UnexpectedToken { 
                        expected: "Statement".into(), 
                        found: format!("{:?} at {}:{}", self.peek().token, self.peek().row, self.peek().col) 
                    }
                ))
            },
            _ => {
                let expr = self.parse_expression()?;
                self.consume(&Token::SemiColon)?;
                Ok(StmtData { stmt: Stmt::Expr(expr), span: Span::new(start, self.cursor) })
            }
        }
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
            span: Span::new(start, self.cursor)
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
            span: Span::new(start, self.cursor)
        })
    }

    fn parse_loop_statement(&mut self) -> ParserResult<StmtData> {
        let start = self.cursor;
        self.consume(&Token::KeywordLoop)?;
        let body = self.parse_block_body()?;
        Ok(StmtData {
            stmt: Stmt::Loop(body),
            span: Span::new(start, self.cursor)
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
            span: Span::new(start, self.cursor)
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