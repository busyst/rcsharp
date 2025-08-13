use crate::{expression_parser::{Expr, ExpressionParser}, token::{Token, TokenData}};
#[derive(Debug, Clone, PartialEq)]
pub enum Stmt {
    Hint(String, Vec<Expr>), // #[...]
    
    Let(String, ParserType, Option<Expr>), // let x : ...
    
    Expr(Expr), // a = 1 + b
    
    Block(Vec<Stmt>), // { ... }
    
    If(Expr, Vec<Stmt>, Option<Box<Stmt>>), // if 1 == 1 {} `else `if` {}`
    Loop(Vec<Stmt>), // loop { ... }

    Break, // break
    Continue, // continue
    Return(Option<Expr>), // return ...
    
    DirectInsertion(String), // continue
    
    Function(String, Vec<(String, ParserType)>, ParserType, Vec<Stmt>), // fn foo(bar: i8, ...) { ... }
    Struct(String, Vec<(String, ParserType)>), // struct foo { bar : i8, ... }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum ParserType {
    Named(String),
    Pointer(Box<ParserType>),
    // return type, arguments
    Fucntion(Box<ParserType>,Vec<ParserType>),
    // Name Fields Embeded Functions(NAME, [RETURN TYPE, ARGUMENTS])
    Structure(Box<String>,Vec<(String,ParserType)>,Vec<(String,(ParserType, Vec<ParserType>))>),
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
    pub fn peek(&self) -> &TokenData {
        const DUMMY_EOF: TokenData = TokenData { 
            token: Token::DummyToken,
            span: 0..0,
            loc: crate::token::Location { row: 0, col: 0 } 
        };
        self.tokens.get(self.cursor).unwrap_or(&DUMMY_EOF)
    }
    pub fn advance(&mut self) -> &TokenData {
        if !self.is_at_end() {
            self.cursor += 1;
        }
        &self.tokens[self.cursor - 1]
    }
    pub fn consume(&mut self, expected: &Token) -> Result<&TokenData, String> {
        let token_data = self.peek();
        if &token_data.token != expected {
            return Err(format!("Expected token {:?}, but found {:?}", expected, token_data));
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
            _ => Err(format!(
                    "Unexpected token {:?} at {:?} in top-level scope. Only functions, structs, and hints are allowed.",
                    self.peek().token, self.peek().loc
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
                args.push(self.parse_sub_expression()?);
                if self.peek().token == Token::Comma {
                    self.advance(); 
                } else {
                    break;
                }
            }
            self.consume(&Token::RParen)?;
        }
        self.consume(&Token::RSquareBrace)?;
        Ok(Stmt::Hint(name, args))
    } 
    fn parse_function(&mut self) -> Result<Stmt, String> {
        self.consume(&Token::KeywordFunction)?;
        let name = self.advance().expect_name_token()?;
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
            return Ok(Stmt::Function(name, args, return_type, vec![]));
        }
        let body = self.parse_block_as_stmt()?;
        Ok(Stmt::Function(name, args, return_type, body))
    }  
    fn parse_struct(&mut self) -> Result<Stmt, String> {
        self.consume(&Token::KeywordStruct)?;
        let name = self.advance().expect_name_token()?;
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
        Ok(Stmt::Struct(name, fields))
    }
    fn parse_type(&mut self) -> Result<ParserType, String> {
        if self.peek().token == Token::LogicAnd {
            self.advance();
            Ok(ParserType::Pointer(Box::new(ParserType::Pointer(Box::new(self.parse_type()?)))))
        }
        else if self.peek().token == Token::BinaryAnd {
            self.advance();
            Ok(ParserType::Pointer(Box::new(self.parse_type()?)))
        }
        else if self.peek().token == Token::Multiply && crate::USE_MULTIPLY_AS_POINTER_IN_TYPES {
            self.advance();
            Ok(ParserType::Pointer(Box::new(self.parse_type()?)))
        }
        else {
            Ok(ParserType::Named(self.advance().expect_name_token()?))
        }
    }
    fn parse_block_as_stmt(&mut self) -> Result<Vec<Stmt>, String> {
        self.consume(&Token::LBrace)?;
        let mut stmts = Vec::new();
        while self.peek().token != Token::RBrace && !self.is_at_end() {
            stmts.push(self.parse_statement()?);
        }
        self.consume(&Token::RBrace)?;
        Ok(stmts)
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
            Token::LBrace => {panic!()/*self.parse_block_as_stmt() */},
            Token::SemiColon => {
                self.advance();
                panic!()
            }
            _ => { 
                let expr = self.parse_expression()?;
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
            let rhs = self.parse_sub_expression()?;
            initializer = Some(rhs);
        }

        self.consume(&Token::SemiColon)?;
        Ok(Stmt::Let(name, var_type, initializer))
    }
    fn parse_if_statement(&mut self) -> Result<Stmt, String> {
        self.consume(&Token::KeywordIf)?;
        let condition = self.parse_sub_expression()?;
        let then_body = self.parse_block_body()?;
        let mut else_branch: Option<Box<Stmt>> = None;
        if self.peek().token == Token::KeywordElse {
            self.advance();
            
            if self.peek().token == Token::KeywordIf {
                let else_if_stmt = self.parse_if_statement()?;
                else_branch = Some(Box::new(else_if_stmt));
            } else {
                let else_body = self.parse_block_body()?;
                else_branch = Some(Box::new(Stmt::Block(else_body)));
            }
        }
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
            return_expr = Some(self.parse_sub_expression()?);
        }
        
        self.consume(&Token::SemiColon)?;
        Ok(Stmt::Return(return_expr))
    }
    fn parse_expression(&mut self) -> Result<Expr, String> {
        let mut prsr= ExpressionParser::new(&self.tokens[self.cursor..]);
        let x = prsr.parse_expression()?;
        self.cursor += prsr.position();
        self.consume(&Token::SemiColon)?;
        return Ok(x);
    }
    fn parse_sub_expression(&mut self) -> Result<Expr, String> {
        let mut expr_parser = ExpressionParser::new(&self.tokens[self.cursor..]);
        let expr = expr_parser.parse_expression()?;
        self.cursor += expr_parser.position();
        Ok(expr)
    }
    fn parse_block_body(&mut self) -> Result<Vec<Stmt>, String> {
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
        Ok(stmts)
    }
}

#[allow(dead_code)]
impl ParserType {
    pub fn is_simple_type(&self) -> bool {
        if let ParserType::Named(name) = self {
            matches!(name.as_str(),
                "bool" |
                "i8" | "u8" | "i16" | "u16" | "i32" | "u32" | "i64" | "u64" |
                "f32" | "f64"
            )
        } else {
            false
        }
    }

    pub fn is_integer(&self) -> bool {
        if let ParserType::Named(name) = self {
            matches!(name.as_str(), "i8" | "u8" | "i16" | "u16" | "i32" | "u32" | "i64" | "u64")
        } else {
            false
        }
    }
    pub fn is_unsigned_integer(&self) -> bool {
        if let ParserType::Named(name) = self {
            matches!(name.as_str(), "u8" | "u16" | "u32" | "u64" )
        } else {
            false
        }
    }
    
    pub fn is_signed_integer(&self) -> bool {
        if let ParserType::Named(name) = self {
            matches!(name.as_str(), "i8" | "i16" | "i32" | "i64" )
        } else {
            false
        }
    }
    pub fn is_float(&self) -> bool {
        if let ParserType::Named(name) = self {
            matches!(name.as_str(), "f32" | "f64")
        } else {
            false
        }
    }
    pub fn is_void(&self) -> bool {
        if let ParserType::Named(name) = self {
            matches!(name.as_str(), "void")
        } else {
            false
        }
    }
    pub fn is_pointer(&self) -> bool{
        match self {
            ParserType::Named(_) => false,
            ParserType::Pointer(_) => true,
            ParserType::Fucntion(_, _) => {todo!()},
            ParserType::Structure(_, _, _) => {todo!()},
        }
    }
    pub fn to_string(&self) -> String{
        let mut output = String::new();
        match self {
            ParserType::Named(x) => output.push_str(x),
            ParserType::Pointer(x) => {output.push_str(&x.to_string()); output.push('*');},
            ParserType::Fucntion(_, _) => {todo!()},
            ParserType::Structure(name, _, _) => {output.push_str(&format!("%struct.{}", name));},
        }
        return output;
    }
    pub fn to_string_core(&self) -> String{
        let mut output = String::new();
        match self {
            ParserType::Named(x) => output.push_str(x),
            ParserType::Pointer(x) => {return x.to_string_core();},
            ParserType::Fucntion(_, _) => {todo!()},
            ParserType::Structure(name, _, _) => {output.push_str(&name);},
        }
        return output;
    }
    
    pub fn dereference_once(&self) -> ParserType{
        match self {
            ParserType::Named(_) => panic!("ParserType is Named {:?} that is not dereferencable", self),
            ParserType::Pointer(x) => return *x.clone(),
            ParserType::Fucntion(_, _) => {todo!()},
            ParserType::Structure(_, _, _) => {todo!()},
        }
    }
    pub fn reference_once(&self) -> ParserType{
        ParserType::Pointer(Box::new(self.clone()))
    }
}
