use std::ops::Range;

use crate::{compiler_essentials::{Attribute, FunctionFlags}, expression_parser::{Expr, ExpressionParser}, token::{Token, TokenData}};
pub const PRIMITIVE_TYPES: &[&str] = &[
    "void", "bool",
    "i8", "i16", "i32", "i64",
    "u8", "u16", "u32", "u64",
    "f32", "f64"
];
pub const PRIMITIVE_TYPES_SIZE: &[u32] = &[
    0, 1,
    1, 2, 4, 8, 1, 2, 4, 8,
    4, 8
];
pub const PRIMITIVE_TYPES_ALIGNMENT: &[u32] = &[
    1, 1,          // void (alignment 1 is a safe default), bool
    1, 2, 4, 8,    // i8, i16, i32, i64
    1, 2, 4, 8,    // u8, u16, u32, u64
    4, 8           // f32, f64
];
pub const LLVM_PRIMITIVE_TYPES: &[&str] = &[
    "void", "i1",
    "i8", "i16", "i32", "i64", 
    "i8", "i16", "i32", "i64",
    "float", "double"
];
pub const INTEGERS_TYPES: Range<usize> = 2..10;
pub const SIGNED_TYPES: Range<usize> = 2..6;
pub const UNSIGNED_TYPES: Range<usize> = 6..10;
pub const FLOAT_TYPES: Range<usize> = 10..12;

pub const VOID_TYPE: &&'static str = &PRIMITIVE_TYPES[0];
pub const BOOL_TYPE: &&'static str = &PRIMITIVE_TYPES[1];
#[derive(Debug, Clone, PartialEq)]
pub struct ParsedFunction {
    pub path: Box<str>,
    pub attributes: Box<[Attribute]>,
    pub name: Box<str>,
    pub args: Box<[(String, ParserType)]>,
    pub return_type: ParserType,
    pub body: Box<[Stmt]>,
    pub flags: u8,
    pub generic_params: Box<[String]>,
}
impl ParsedFunction {
    pub fn new_parse(name: Box<str>, args: Box<[(String, ParserType)]>, return_type: ParserType, body: Box<[Stmt]>) -> ParsedFunction {
        ParsedFunction { path: String::new().into(), attributes: Box::new([]), name, args, return_type, body, flags: 0, generic_params: Box::new([]) }
    }
    pub fn new_parse_generic(name: Box<str>, args: Box<[(String, ParserType)]>, return_type: ParserType, body: Box<[Stmt]>, generic_params: Box<[String]>) -> ParsedFunction {
        ParsedFunction { path: String::new().into(), attributes: Box::new([]), name, args, return_type, body, flags: FunctionFlags::Generic as u8, generic_params }
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
    Function(Box<ParserType>,Box<[ParserType]>),
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
    pub fn is_primitive_type(&self) -> bool {
        if let ParserType::Named(name) = self {
            return PRIMITIVE_TYPES.contains(&name.as_str());
        }
        false
    }
    pub fn as_primitive_type(&self) -> Option<&str> {
        if let ParserType::Named(name) = self {
            if PRIMITIVE_TYPES.contains(&name.as_str()) {
                return Some(name.as_str());
            }
        }
        None
    }

    pub fn is_integer(&self) -> bool {
        if let ParserType::Named(name) = self {
            return PRIMITIVE_TYPES[INTEGERS_TYPES].contains(&name.as_str());
        }
        false
    }
    pub fn is_unsigned_integer(&self) -> bool {
        if let ParserType::Named(name) = self {
            return PRIMITIVE_TYPES[UNSIGNED_TYPES].contains(&name.as_str());
        }
        false
    }
    pub fn is_signed_integer(&self) -> bool {
        if let ParserType::Named(name) = self {
            return PRIMITIVE_TYPES[SIGNED_TYPES].contains(&name.as_str());
        }
        false
    }
    pub fn is_float(&self) -> bool {
        if let ParserType::Named(name) = self {
            return PRIMITIVE_TYPES[FLOAT_TYPES].contains(&name.as_str());
        }
        false
    }
    pub fn is_bool(&self) -> bool{
        if let ParserType::Named(name) = self {
            return name == BOOL_TYPE;
        }
        false
    }
    pub fn is_void(&self) -> bool {
        if let ParserType::Named(name) = self {
            return name == VOID_TYPE;
        }
        false
    }
    pub fn is_pointer(&self) -> bool{
        return matches!(self, ParserType::Pointer(_));
    }

    pub fn is_both_integers(&self, other: &ParserType) -> Option<(u32, u32)> {
        if self.is_integer() && other.is_integer() {
            let ln = self.to_string()[1..].parse::<u32>().unwrap();
            let rn = other.to_string()[1..].parse::<u32>().unwrap();
            return Some((ln, rn));
        }
        None
    }
    pub fn reference_once(self) -> ParserType{
        ParserType::Pointer(Box::new(self))
    }
    pub fn dereference_once(&self) -> &ParserType{
        match self {
            ParserType::Pointer(x) => &x,
            _ => return self,
        }
    }
    pub fn dereference_full(&self) -> &ParserType{
        match self {
            ParserType::Pointer(x) => &x.dereference_full(),
            _ => return self,
        }
    }
    pub fn delink(&self) -> &ParserType {
        match self {
            ParserType::NamespaceLink(_, c) => c.delink(),
            _ => return self,
        }
    }
    pub fn to_string(&self) -> String{
        let mut output = String::new();
        match self {
            ParserType::Named(x) => output.push_str(x),
            ParserType::Pointer(x) => {output.push_str(&x.to_string()); output.push('*');},
            ParserType::Function(return_type, _) => {output.push_str(&return_type.to_string());},
            ParserType::NamespaceLink(x, y) => {output.push_str(&format!("{}.{}", x, y.to_string()));}
            ParserType::Generic(x, _) => {output.push_str(&format!("{}", x));}
        }
        return output;
    }
    pub fn get_absolute_path_or(&self, current_fallback: &str) -> String{
        match self {
            ParserType::NamespaceLink(x, y) =>{
                return format!("{}.{}", x, y.to_string());
            }
            ParserType::Named(x) =>{
                if current_fallback.is_empty() || self.is_primitive_type() {
                    return format!("{}", x.clone());
                }else {
                    return format!("{}.{}",current_fallback, x.clone());
                }
            }
            ParserType::Generic(x, _) =>{
                if current_fallback.is_empty() || self.is_primitive_type() {
                    return format!("{}", x.clone());
                }else {
                    return format!("{}.{}",current_fallback, x.clone());
                }
            }
            _ => self.to_string(),
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
                    func.flags |= FunctionFlags::Inline as u8;
                    return Ok(x);
                }
                Err(format!("Keyword Inline only applicable to functions"))
            }
            Token::KeywordConstExpr =>{
                self.advance();
                let mut x = self.parse_toplevel_item()?;
                if let Stmt::Function(func) = &mut x {
                    func.flags |= FunctionFlags::ConstExpression as u8;
                    return Ok(x);
                }
                Err(format!("Keyword Inline only applicable to functions"))
            }
            Token::KeywordPub =>{
                self.advance();
                let mut x = self.parse_toplevel_item()?;
                if let Stmt::Function(func) = &mut x {
                    func.flags |= FunctionFlags::ConstExpression as u8;
                    return Ok(x);
                }
                Err(format!("Keyword Inline only applicable to functions"))
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
        let body = self.parse_block_body()?;
        
        if generic_types.len() != 0 {
            return Ok(Stmt::Function(ParsedFunction::new_parse_generic(name.into(), args.into_boxed_slice(), return_type, body, generic_types.into())));
        }
        return Ok(Stmt::Function(ParsedFunction::new_parse(name.into(), args.into_boxed_slice(), return_type, body)));
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
        return Ok(Stmt::Namespace(x, body.into_boxed_slice()));
    }
    fn parse_enum(&mut self) -> Result<Stmt, String> {
        self.consume(&Token::KeywordEnum)?;
        let name = self.advance().expect_name_token()?;
        let enum_base_type ;
        if self.peek().token == Token::Colon {
            self.advance();
            enum_base_type = Some(self.parse_type()?);
        }else {
            enum_base_type = None;
        }
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
            Token::KeywordVariableDeclaration => self.parse_let_statement(),
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
                let else_body = self.parse_block_body()?;
                else_body
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
        return pt;
    }
    fn parse_expression(&mut self) -> Result<Expr, String> {
        let mut expr_parser = ExpressionParser::new(&self.tokens[self.cursor..]);
        let expr = expr_parser.parse_expression()?;
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