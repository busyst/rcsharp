use rcsharp_lexer::{Token, TokenData};

use crate::{compiler_primitives::{PrimitiveInfo, PrimitiveKind, find_primitive_type}, expression_parser::{Expr, ExpressionParser}};

#[derive(Debug, Clone, PartialEq)]
pub struct Attribute {
    name: Box<str>,
    arguments: Box<[Expr]>
}
impl Attribute {
    pub fn new(name: Box<str>, arguments: Box<[Expr]>) -> Self {
        Self { name, arguments }
    }
    pub fn name_equals(&self, to: &str) -> bool{
        self.name == to.into()
    }

    /// Ensures that attribute has only one argument, and returns it.
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
pub struct ParsedFunction {
    pub path: Box<str>,
    pub attributes: Box<[Attribute]>,
    pub name: Box<str>,
    pub args: Box<[(String, ParserType)]>,
    pub return_type: ParserType,
    pub body: Box<[Stmt]>,
    pub prefixes: Box<[String]>,
    pub generic_params: Box<[String]>,
}
impl ParsedFunction {
    pub fn new_parse(name: Box<str>, args: Box<[(String, ParserType)]>, return_type: ParserType, body: Box<[Stmt]>) -> ParsedFunction {
        ParsedFunction { path: String::new().into(), attributes: Box::new([]), name, args, return_type, body, prefixes: Box::new([]), generic_params: Box::new([]) }
    }
    pub fn new_parse_generic(name: Box<str>, args: Box<[(String, ParserType)]>, return_type: ParserType, body: Box<[Stmt]>, generic_params: Box<[String]>) -> ParsedFunction {
        ParsedFunction { path: String::new().into(), attributes: Box::new([]), name, args, return_type, body, prefixes: Box::new([]), generic_params }
    }
}

#[derive(Debug, Clone, PartialEq)]
pub enum Stmt {
    Hint(String, Box<[Expr]>), // #[...]
    
    Let(String, ParserType, Option<Expr>), // let x : ...
    
    Expr(Expr), // a = 1 + b
    
    If(Expr, Box<[Stmt]>, Box<[Stmt]>), // if 1 == 1 {} `else `if` {}`

    Loop(Box<[Stmt]>), // loop { ... }

    Break, // break
    Continue, // continue
    Return(Option<Expr>), // return ...

    Function(ParsedFunction), // fn foo(bar: i8, ...) ... { ... }
    Struct(String, Box<[(String, ParserType)]>, Box<[String]>), // struct foo <T> { bar : i8, ... }
    Enum(String, Option<ParserType>, Box<[(String, Expr)]>), // enum foo 'base_type' { bar = ..., ... }
    Namespace(String, Box<[Stmt]>), // namespace foo { fn bar() ... {...} ... }
}
impl Stmt {
    pub fn recursive_statement_count(&self) -> u64{
        match self {
            Self::Break => 1,
            Self::Continue => 1,
            Self::Enum(_, _, _) => 1,
            Self::Hint(_, _) => 1,
            Self::Let(_, _, _) => 1,
            Self::Expr(_) => 1,
            Self::If(_, x, y) => { 1 + x.iter().map(|x| x.recursive_statement_count()).sum::<u64>() + y.iter().map(|x| x.recursive_statement_count()).sum::<u64>()}
            Self::Loop(x) => { 1 + x.iter().map(|x| x.recursive_statement_count()).sum::<u64>()}
            Self::Namespace(_, x) => { 1 + x.iter().map(|x| x.recursive_statement_count()).sum::<u64>()}
            Self::Return(_) => 1,
            Self::Function(func) => { 1 + func.body.iter().map(|x| x.recursive_statement_count()).sum::<u64>()}
            Self::Struct(_, _, _) => 1,
        }
    }
}
#[derive(Debug, Clone)]
pub enum ParserType {
    Named(String),
    Pointer(Box<ParserType>),
    // return type, arguments
    Function(Box<ParserType>, Box<[ParserType]>),
    NamespaceLink(String, Box<ParserType>),
    Generic(String, Box<[ParserType]>),
}
impl PartialEq for ParserType {
    fn eq(&self, other: &Self) -> bool {
        match (self, other) {
            (Self::Named(l0), Self::Named(r0)) => l0 == r0,
            (Self::Pointer(l0), Self::Pointer(r0)) => l0 == r0,
            (Self::Function(l0, l1), Self::Function(r0, r1)) => l0 == r0 && l1 == r1,
            (Self::NamespaceLink(l0, l1), Self::NamespaceLink(r0, r1)) => l0 == r0 && l1 == r1,
            (Self::Generic(l0, l1), Self::Generic(r0, r1)) => l0 == r0 && l1 == r1,

            (Self::NamespaceLink(_, l), r) => r.eq(l),
            (l, Self::NamespaceLink(_, r)) => l.eq(r),
            _ => false,
        }
    }
}
impl ParserType {
    pub fn as_primitive_type(&self) -> Option<&'static PrimitiveInfo> {
        if let ParserType::Named(name) = self {
            return find_primitive_type(&name);
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
            ParserType::Named(name) => format!("{}", name.to_string()),
            ParserType::Generic(name, _) => format!("{}", name.to_string()),
            ParserType::NamespaceLink(link, core) => format!("{}.{}", link, core.type_name()),
            _ => panic!("{:?}", self)
        }
    }
    pub fn debug_type_name(&self) -> String{
        match self {
            ParserType::Named(name) => format!("{}", name.to_string()),
            ParserType::Generic(name, _) => format!("{}", name.to_string()),
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
        const DUMMY_EOF: TokenData = TokenData { 
            token: Token::DummyToken,
            span: 0..0,
            col: 0,
            row: 0
        };
        self.tokens.get(self.cursor).unwrap_or(&DUMMY_EOF)
    }
    fn advance(&mut self) -> &TokenData {
        if !self.is_at_end() {
            self.cursor += 1;
        }
        &self.tokens[self.cursor - 1]
    }
    fn consume(&mut self, expected: &Token) -> Result<&TokenData, String> {
        let token_data = self.peek();
        if &token_data.token != expected {
            return Err(format!(
                "Expected token {:?}, found {:?} at row {}, col {}",
                expected,
                token_data.token,
                token_data.row,
                token_data.col
            ));
        }
        Ok(self.advance())
    }
    pub fn parse_all(&mut self) -> Result<Vec<Stmt>, String> {
        let mut statements = Vec::new();
        while !self.is_at_end() {
            statements.push(self.parse_toplevel_item()?);
        }
        Ok(statements)
    }
    
    fn parse_toplevel_item(&mut self) -> Result<Stmt, String> {
        match &self.peek().token {
            Token::Hint => self.parse_hint(),
            Token::KeywordFunction => self.parse_function(),
            Token::KeywordStruct => self.parse_struct(),
            Token::KeywordEnum => self.parse_enum(),
            Token::KeywordNamespace => self.parse_namespace(),
            Token::KeywordInline =>{
                self.advance();
                let mut x = self.parse_toplevel_item()?;
                if let Stmt::Function(func) = &mut x {
                    let mut p = func.prefixes.to_vec(); p.push(format!("inline"));
                    func.prefixes = p.into_boxed_slice();
                    return Ok(x);
                }
                Err("Keyword Inline only applicable to functions".to_string())
            }
            Token::KeywordConstExpr =>{
                self.advance();
                let mut x = self.parse_toplevel_item()?;
                if let Stmt::Function(func) = &mut x {
                    let mut p = func.prefixes.to_vec(); p.push(format!("constexpr"));
                    func.prefixes = p.into_boxed_slice();
                    return Ok(x);
                }
                Err("Keyword Inline only applicable to functions".to_string())
            }
            Token::KeywordPub =>{
                self.advance();
                let mut x = self.parse_toplevel_item()?;
                if let Stmt::Function(func) = &mut x {
                    let mut p = func.prefixes.to_vec(); p.push(format!("public"));
                    func.prefixes = p.into_boxed_slice();
                    return Ok(x);
                }
                Err("Keyword Inline only applicable to functions".to_string())
            }
            _ => Err(format!(
                    "Unexpected token {:?} at {}:{} in top-level scope. Only functions, structs, and hints are allowed.",
                    self.peek().token, self.peek().row, self.peek().col
                )),
        }
    }
    fn parse_hint(&mut self) -> Result<Stmt, String> {
        self.consume(&Token::Hint)?;
        self.consume(&Token::LSquareBrace)?;
        let name = self.advance().expect_name_token()?;
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
        Ok(Stmt::Hint(name, args.into_boxed_slice()))
    } 
    fn parse_function(&mut self) -> Result<Stmt, String> {
        self.consume(&Token::KeywordFunction)?;
        let name = self.advance().expect_name_token()?;
        let mut generic_types = vec![];
        if self.peek().token == Token::LogicLess {
            self.advance();
            loop {
                if self.peek().token == Token::LogicGreater {
                    self.advance();
                    break;
                }
                if self.peek().token == Token::BinaryShiftR {
                    todo!()
                }
                let t= self.advance().expect_name_token()?;
                generic_types.push(t);
                if self.peek().token == Token::Comma {
                    self.advance();
                }
                
            }
        }
        self.consume(&Token::LParen)?;
        let mut args = Vec::new();
        if self.peek().token != Token::RParen {
            loop {
                let arg_name = self.advance().expect_name_token()?;
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
            return Ok(Stmt::Function(ParsedFunction::new_parse(name.into_boxed_str(), args.into_boxed_slice(), return_type, Box::new([]))));
        } 
        let body = self.parse_block_body().map_err(|x| format!("{x}\nIn function '{name}'\n"))?;
        
        if !generic_types.is_empty() {
            return Ok(Stmt::Function(ParsedFunction::new_parse_generic(name.into(), args.into_boxed_slice(), return_type, body, generic_types.into())));
        }
        Ok(Stmt::Function(ParsedFunction::new_parse(name.into(), args.into_boxed_slice(), return_type, body)))
    }  
    fn parse_struct(&mut self) -> Result<Stmt, String> {
        self.consume(&Token::KeywordStruct)?;
        let name = self.advance().expect_name_token()?;
        let mut generic_types = vec![];
        if self.peek().token == Token::LogicLess {
            self.advance();
            loop {
                if self.peek().token == Token::LogicGreater {
                    self.advance();
                    break;
                }
                if self.peek().token == Token::BinaryShiftR {
                    todo!()
                }
                let t= self.advance().expect_name_token()?;
                generic_types.push(t);
                if self.peek().token == Token::Comma {
                    self.advance();
                }
                
            }
        }
        self.consume(&Token::LBrace)?;
        
        let mut fields = Vec::new();
        while self.peek().token != Token::RBrace && !self.is_at_end() {
            let field_name = self.advance().expect_name_token()?;
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
        Ok(Stmt::Struct(name, fields.into_boxed_slice(), generic_types.into_boxed_slice()))
    }    
    fn parse_namespace(&mut self) -> Result<Stmt, String> {
        self.consume(&Token::KeywordNamespace)?;
        let x= self.advance().expect_name_token()?;
        self.consume(&Token::LBrace)?;
        let mut body = vec![];
        loop {
            if self.peek().token == Token::RBrace {
                break;
            }
            body.push(self.parse_toplevel_item()?);
        }
        self.consume(&Token::RBrace)?;
        Ok(Stmt::Namespace(x, body.into_boxed_slice()))
    }
    fn parse_enum(&mut self) -> Result<Stmt, String> {
        self.consume(&Token::KeywordEnum)?;
        let name = self.advance().expect_name_token()?;
        let enum_base_type = if self.peek().token == Token::Colon {
            self.advance();
            Some(self.parse_type()?)
        }else {
           None
        };
        self.consume(&Token::LBrace)?;
        let mut values = vec![];
        let mut counter = 0;
        loop {
            if self.peek().token == Token::RBrace {
                break;
            }
            let name = self.advance().expect_name_token()?;
            if self.peek().token == Token::Equal {
                self.advance();
                let mut prsr= ExpressionParser::new(&self.tokens[self.cursor..]);
                let expr = prsr.parse_expression()?;
                self.cursor += prsr.cursor();
                values.push((name, expr));
                if self.peek().token == Token::Comma {
                    self.advance();
                }
                continue;
            }

            values.push((name, Expr::Integer(counter.to_string())));
            counter+=1;
            if self.peek().token == Token::Comma {
                self.advance();
                continue;
            }
        }
        self.consume(&Token::RBrace)?;
        Ok(Stmt::Enum(name, enum_base_type, values.into_boxed_slice()))
    }
    fn parse_statement(&mut self) -> Result<Stmt, String> {
        match &self.peek().token {
            Token::KeywordVariableDeclaration => self.parse_let_statement().map_err(|x| format!("{x}\nIn variable declaration")),
            Token::KeywordIf => self.parse_if_statement(),
            Token::KeywordLoop => self.parse_loop_statement(),
            Token::KeywordReturn => self.parse_return_statement(),
            Token::KeywordBreak => {
                self.advance();
                self.consume(&Token::SemiColon)?;
                Ok(Stmt::Break)
            }
            Token::KeywordContinue => {
                self.advance();
                self.consume(&Token::SemiColon)?;
                Ok(Stmt::Continue)
            }
            Token::LBrace | Token::RBrace | Token::SemiColon => {unreachable!("Congratulations! I broke parser!")},
            _ => { 
                let expr = self.parse_expression()?;
                self.consume(&Token::SemiColon)?;
                Ok(Stmt::Expr(expr))
            }
        }
    }
    fn parse_let_statement(&mut self) -> Result<Stmt, String> {
        self.consume(&Token::KeywordVariableDeclaration)?;
        let name = self.advance().expect_name_token()?;
        self.consume(&Token::Colon)?;
        let var_type = self.parse_type()?;
        
        let mut initializer: Option<Expr> = None;
        if self.peek().token == Token::Equal {
            self.consume(&Token::Equal)?;
            let rhs = self.parse_expression()?;
            initializer = Some(rhs);
        }

        self.consume(&Token::SemiColon)?;
        Ok(Stmt::Let(name, var_type, initializer))
    }
    fn parse_if_statement(&mut self) -> Result<Stmt, String> {
        self.consume(&Token::KeywordIf)?;
        let condition = self.parse_expression()?;
        let then_body = self.parse_block_body()?;
        let else_branch =
        if self.peek().token == Token::KeywordElse {
            self.advance();
            
            if self.peek().token == Token::KeywordIf {
                let else_if_stmt = self.parse_if_statement()?;
                Box::new([else_if_stmt])
            } else {
                
                self.parse_block_body()?
            }
        }else{
            Box::new([])
        };
        Ok(Stmt::If(condition, then_body, else_branch))
    }
    fn parse_loop_statement(&mut self) -> Result<Stmt, String> {
        self.consume(&Token::KeywordLoop)?;
        let body = self.parse_block_body()?;
        Ok(Stmt::Loop(body))
    }
    fn parse_return_statement(&mut self) -> Result<Stmt, String> {
        self.consume(&Token::KeywordReturn)?;
        let mut return_expr: Option<Expr> = None;
        
        if self.peek().token != Token::SemiColon {
            return_expr = Some(self.parse_expression()?);
        }
        
        self.consume(&Token::SemiColon)?;
        Ok(Stmt::Return(return_expr))
    }
    fn parse_type(&mut self) -> Result<ParserType, String> {
        let mut ep = ExpressionParser::new(&self.tokens[self.cursor..]);
        let pt = ep.parse_type();
        self.cursor += ep.cursor();
        pt
    }
    fn parse_expression(&mut self) -> Result<Expr, String> {
        let mut expr_parser = ExpressionParser::new(&self.tokens[self.cursor..]);
        let expr = expr_parser.parse_expression().map_err(|x| format!("{x}\nwhile parsing expression:\n"))?;
        self.cursor += expr_parser.cursor();
        Ok(expr)
    }
    fn parse_block_body(&mut self) -> Result<Box<[Stmt]>, String> {
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