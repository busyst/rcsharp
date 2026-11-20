use rcsharp_lexer::defs::TokenKind;
use rcsharp_syntax::Span;

use crate::{
    Parser,
    defs::{
        Attribute, GenericParam, Modifier, ParsedEnum, ParsedFunction, ParsedStruct,
        ParsedVariable, Stmt, StmtData, VarType,
    },
};

impl<'lex, 'src, 'int> Parser<'lex, 'src, 'int> {
    pub fn parse_all(&mut self) -> Vec<StmtData> {
        let mut stmts = Vec::new();
        while let Some(item) = self.next_toplevel_item() {
            if let Stmt::Block(blk) = item.stmt {
                stmts.extend(Vec::from(blk));
            } else {
                stmts.push(item);
            }
        }
        stmts
    }

    pub fn parse_compiler_only(&mut self) -> Vec<(Span, Attribute)> {
        let mut hints = Vec::new();
        while !self.is_eof() {
            let is_bare_hint =
                self.at(TokenKind::Hash) && self.peek_nth(1).kind != TokenKind::LSquareBrace;

            if is_bare_hint {
                match self.parse_hint_stmt() {
                    Ok(StmtData {
                        span,
                        stmt: Stmt::CompilerHint(attr),
                    }) => hints.push((span, attr)),
                    Ok(_) => unreachable!("parse_hint_stmt always returns CompilerHint"),
                    Err(()) => self.synchronize(),
                }
            } else {
                self.bump();
            }
        }
        hints
    }

    pub fn next_toplevel_item(&mut self) -> Option<StmtData> {
        while !self.is_eof() {
            match self.parse_toplevel_item() {
                Ok(stmt) => return Some(stmt),
                Err(()) => self.synchronize(),
            }
        }
        None
    }

    pub(crate) fn parse_comma_separated<T>(
        &mut self,
        closing: TokenKind,
        mut parse_elem: impl FnMut(&mut Self) -> Result<T, ()>,
    ) -> Result<Vec<T>, ()> {
        let mut items = Vec::new();
        while !self.at(closing) && !self.is_eof() {
            items.push(parse_elem(self)?);
            if !self.eat(TokenKind::Comma) {
                break;
            }
        }
        Ok(items)
    }

    fn parse_toplevel_item(&mut self) -> Result<StmtData, ()> {
        let mut attributes = Vec::new();
        let mut start = self.peek().span;

        while self.at(TokenKind::Hash) && self.peek_nth(1).kind == TokenKind::LSquareBrace {
            attributes.push(self.parse_attribute()?);
        }

        if let Some(first) = attributes.first() {
            start = first.span;
        }

        if self.at(TokenKind::Hash) {
            if !attributes.is_empty() {
                let sps = self.peek().span;
                self.error(sps, "Orphaned attributes before compiler hint");
                return Err(());
            }
            return self.parse_hint_stmt();
        }

        match self.peek().kind {
            TokenKind::KeywordFunction => self.parse_function(attributes, start),
            TokenKind::KeywordStruct => self.parse_struct(attributes, start),
            TokenKind::KeywordEnum => self.parse_enum(attributes, start),
            TokenKind::KeywordNamespace => {
                if !attributes.is_empty() {
                    self.error(start, "Attributes are not allowed on namespaces");
                    return Err(());
                }
                self.parse_namespace()
            }
            TokenKind::LBrace => self.parse_top_level_block(),
            TokenKind::KeywordInline => self.parse_with_modifier(Modifier::Inline, attributes),
            TokenKind::KeywordConstExpr => {
                self.parse_with_modifier(Modifier::ConstExpr, attributes)
            }
            TokenKind::KeywordPub => self.parse_with_modifier(Modifier::Public, attributes),
            TokenKind::KeywordExtern => self.parse_with_modifier(Modifier::Extern, attributes),
            TokenKind::KeywordStatic => self.parse_static_let_statement(start, attributes),
            TokenKind::KeywordConst => self.parse_const_let_statement(start, attributes),
            _ => {
                let tok = self.peek();
                let msg = if attributes.is_empty() {
                    format!("Unexpected top-level token: {:?}", tok.kind)
                } else {
                    "Orphaned attributes".to_string()
                };
                self.error(tok.span, &msg);
                Err(())
            }
        }
    }

    fn parse_with_modifier(
        &mut self,
        modifier: Modifier,
        attributes: Vec<Attribute>,
    ) -> Result<StmtData, ()> {
        self.bump();
        let mut item = self.parse_toplevel_item()?;

        fn count_and_validate(
            parser: &mut Parser<'_, '_, '_>,
            stmt: &StmtData,
            modifier: Modifier,
        ) -> Result<usize, ()> {
            match &stmt.stmt {
                Stmt::Function(_)
                | Stmt::Struct(_)
                | Stmt::Enum(_)
                | Stmt::StaticLet(_)
                | Stmt::ConstLet(_) => Ok(1),
                Stmt::Block(b) => {
                    let mut count = 0;
                    for x in b.iter() {
                        count += count_and_validate(parser, x, modifier)?;
                    }
                    Ok(count)
                }
                Stmt::CompilerDud | Stmt::CompilerHint(_) => Ok(0),
                _ => {
                    parser.error(
                        stmt.span,
                        &format!(
                            "Modifier '{:?}' is only applicable to functions, structs, enums, or variables",modifier
                        ),
                    );
                    Err(())
                }
            }
        }

        fn apply_rec(
            stmt: &mut StmtData,
            modifier: Modifier,
            attributes: &mut Option<Vec<Attribute>>,
            count: &mut usize,
        ) {
            let mut apply = |prefixes: &mut Box<[Modifier]>, attrs: &mut Box<[Attribute]>| {
                *count -= 1;
                let pass_attrs = if *count == 0 {
                    attributes.take().unwrap_or_default()
                } else {
                    attributes.clone().unwrap_or_default()
                };
                Parser::prepend_modifier(prefixes, modifier);
                Parser::prepend_attributes(attrs, pass_attrs);
            };

            match &mut stmt.stmt {
                Stmt::Function(f) => apply(&mut f.prefixes, &mut f.attributes),
                Stmt::Struct(s) => apply(&mut s.prefixes, &mut s.attributes),
                Stmt::Enum(e) => apply(&mut e.prefixes, &mut e.attributes),
                Stmt::StaticLet(v) | Stmt::ConstLet(v) => {
                    apply(&mut v.prefixes, &mut v.attributes);
                }
                Stmt::Block(b) => {
                    for x in b.iter_mut() {
                        apply_rec(x, modifier, attributes, count);
                    }
                }
                _ => {}
            }
        }

        let mut count = count_and_validate(self, &item, modifier)?;
        let mut attrs_opt = Some(attributes);
        apply_rec(&mut item, modifier, &mut attrs_opt, &mut count);
        Ok(item)
    }

    fn parse_top_level_block(&mut self) -> Result<StmtData, ()> {
        let start = self.bump().span; // {
        let mut stmts = Vec::new();
        while !self.at(TokenKind::RBrace) && !self.is_eof() {
            match self.parse_toplevel_item() {
                Ok(item) => {
                    if let Stmt::Block(blk) = item.stmt {
                        stmts.extend(Vec::from(blk));
                    } else {
                        stmts.push(item);
                    }
                }
                Err(()) => self.synchronize(),
            }
        }
        self.expect(TokenKind::RBrace, "Expected '}'")?;
        Ok(StmtData {
            stmt: Stmt::Block(stmts.into_boxed_slice()),
            span: self.span_from(start),
        })
    }

    fn parse_generic_params(&mut self) -> Result<Vec<GenericParam>, ()> {
        if !self.eat(TokenKind::LogicLess) {
            return Ok(Vec::new());
        }
        let params = self.parse_comma_separated(TokenKind::LogicGreater, |p| {
            let (name, _) = p.expect_name("Expected generic parameter name")?;
            let bounds = if p.eat(TokenKind::Colon) {
                let mut bounds = Vec::new();
                loop {
                    let (b, _) = p.expect_name("Expected trait bound name")?;
                    bounds.push(b);
                    if !p.eat(TokenKind::Plus) {
                        break;
                    }
                }
                bounds
            } else {
                Vec::new()
            };
            Ok(GenericParam { name, bounds })
        })?;
        self.expect(
            TokenKind::LogicGreater,
            "Expected '>' after generic parameters",
        )?;
        Ok(params)
    }

    fn parse_attribute(&mut self) -> Result<Attribute, ()> {
        let start = self.bump().span; // #
        self.expect(TokenKind::LSquareBrace, "Expected '[' after '#'")?;
        let (name, _) = self.expect_name("Expected attribute name")?;
        let args = self.parse_arg_list_parens()?;
        self.expect(TokenKind::RSquareBrace, "Expected ']' after attribute")?;

        Ok(Attribute {
            name,
            arguments: args.into_boxed_slice(),
            span: self.span_from(start),
        })
    }

    fn parse_hint_stmt(&mut self) -> Result<StmtData, ()> {
        let start = self.bump().span; // #
        let (name, _) = self.expect_name("Expected compiler hint name after '#'")?;
        let args = self.parse_arg_list_parens()?;
        let span = self.span_from(start);

        Ok(StmtData {
            stmt: Stmt::CompilerHint(Attribute {
                name,
                arguments: args.into_boxed_slice(),
                span,
            }),
            span,
        })
    }

    fn parse_arg_list_parens(&mut self) -> Result<Vec<crate::defs::Expr>, ()> {
        if !self.eat(TokenKind::LParen) {
            return Ok(Vec::new());
        }
        let args = self.parse_comma_separated(TokenKind::RParen, Self::parse_expression)?;
        self.expect(TokenKind::RParen, "Expected ')' after arguments")?;
        Ok(args)
    }

    fn parse_function(&mut self, attributes: Vec<Attribute>, start: Span) -> Result<StmtData, ()> {
        self.bump(); // fn
        let (name, _) = self.expect_name("Expected function name")?;
        let generic_params = self.parse_generic_params()?;

        self.expect(TokenKind::LParen, "Expected '(' after function name")?;
        let args = self.parse_comma_separated(TokenKind::RParen, |p| {
            let (arg_name, _) = p.expect_name("Expected parameter name")?;
            p.expect(TokenKind::Colon, "Expected ':' after parameter name")?;
            let arg_type = p.parse_type()?;
            Ok((arg_name, arg_type))
        })?;
        self.expect(TokenKind::RParen, "Expected ')' after parameters")?;

        let return_type = if self.eat(TokenKind::Colon) {
            Some(self.parse_type()?)
        } else {
            None
        };

        let body = if self.eat(TokenKind::SemiColon) {
            Box::new([])
        } else if self.eat(TokenKind::FatArrow) {
            let expr_start = self.peek().span;
            let expr = self.parse_expression()?;
            self.expect_semicolon()?;
            Box::new([StmtData {
                stmt: Stmt::Return(Some(expr)),
                span: self.span_from(expr_start),
            }])
        } else {
            self.parse_block_body()?
        };

        Ok(StmtData {
            stmt: Stmt::Function(ParsedFunction {
                attributes: attributes.into_boxed_slice(),
                name,
                args: args.into_boxed_slice(),
                return_type,
                body,
                prefixes: Box::new([]),
                generic_params: generic_params.into_boxed_slice(),
            }),
            span: self.span_from(start),
        })
    }

    fn parse_struct(&mut self, attributes: Vec<Attribute>, start: Span) -> Result<StmtData, ()> {
        self.bump(); // struct
        let (name, _) = self.expect_name("Expected struct name")?;
        let generic_params = self.parse_generic_params()?;
        self.expect(TokenKind::LBrace, "Expected '{' after struct header")?;

        let fields = self.parse_comma_separated(TokenKind::RBrace, |p| {
            let (field_name, _) = p.expect_name("Expected field name")?;
            p.expect(TokenKind::Colon, "Expected ':' after field name")?;
            let field_type = p.parse_type()?;
            Ok((field_name, field_type))
        })?;
        self.expect(TokenKind::RBrace, "Expected '}' after struct fields")?;

        Ok(StmtData {
            stmt: Stmt::Struct(ParsedStruct {
                attributes: attributes.into_boxed_slice(),
                name,
                members: fields.into_boxed_slice(),
                generic_params: generic_params.into_boxed_slice(),
                prefixes: Box::new([]),
            }),
            span: self.span_from(start),
        })
    }

    fn parse_namespace(&mut self) -> Result<StmtData, ()> {
        let start = self.bump().span; // namespace
        let (name, _) = self.expect_name("Expected namespace name")?;
        self.expect(TokenKind::LBrace, "Expected '{' after namespace name")?;

        let mut body = Vec::new();
        while !self.at(TokenKind::RBrace) && !self.is_eof() {
            match self.parse_toplevel_item() {
                Ok(item) => {
                    if let Stmt::Block(blk) = item.stmt {
                        body.extend(Vec::from(blk));
                    } else {
                        body.push(item);
                    }
                }
                Err(()) => self.synchronize(),
            }
        }
        self.expect(TokenKind::RBrace, "Expected '}' after namespace body")?;

        Ok(StmtData {
            stmt: Stmt::Namespace(name, body.into_boxed_slice()),
            span: self.span_from(start),
        })
    }

    fn parse_enum(&mut self, attributes: Vec<Attribute>, start: Span) -> Result<StmtData, ()> {
        self.bump(); // enum
        let (name, _) = self.expect_name("Expected enum name")?;

        let enum_type = if self.eat(TokenKind::Colon) {
            Some(self.parse_type()?)
        } else {
            None
        };

        self.expect(TokenKind::LBrace, "Expected '{' after enum header")?;
        let values = self.parse_comma_separated(TokenKind::RBrace, |p| {
            let (variant_name, _) = p.expect_name("Expected enum variant name")?;
            let expr = if p.eat(TokenKind::Equal) {
                Some(p.parse_expression()?)
            } else {
                None
            };
            Ok((variant_name, expr))
        })?;
        self.expect(TokenKind::RBrace, "Expected '}' after enum variants")?;

        Ok(StmtData {
            stmt: Stmt::Enum(ParsedEnum {
                attributes: attributes.into_boxed_slice(),
                name,
                fields: values.into_boxed_slice(),
                enum_type,
                prefixes: Box::new([]),
            }),
            span: self.span_from(start),
        })
    }

    pub(crate) fn parse_block_body(&mut self) -> Result<Box<[StmtData]>, ()> {
        self.expect(TokenKind::LBrace, "Expected '{'")?;
        let mut stmts = Vec::new();
        while !self.at(TokenKind::RBrace) && !self.is_eof() {
            if self.eat(TokenKind::SemiColon) {
                continue;
            }
            match self.parse_statement() {
                Ok(stmt) => {
                    if stmt.stmt != Stmt::CompilerDud {
                        stmts.push(stmt);
                    }
                }
                Err(()) => self.synchronize(),
            }
        }
        self.expect(TokenKind::RBrace, "Expected '}'")?;
        Ok(stmts.into_boxed_slice())
    }

    fn parse_statement(&mut self) -> Result<StmtData, ()> {
        let start = self.peek().span;

        match self.peek().kind {
            TokenKind::KeywordConst => self.parse_const_let_statement(start, Vec::new()),
            TokenKind::KeywordLet => self.parse_let_statement(start),
            TokenKind::KeywordStatic => self.parse_static_let_statement(start, Vec::new()),
            TokenKind::KeywordIf => self.parse_if_statement(start),
            TokenKind::KeywordLoop => {
                self.bump();
                let body = self.parse_block_body()?;
                Ok(StmtData {
                    stmt: Stmt::Loop(body),
                    span: self.span_from(start),
                })
            }
            TokenKind::KeywordReturn => {
                self.bump();
                let expr = if !self.at(TokenKind::SemiColon) {
                    Some(self.parse_expression()?)
                } else {
                    None
                };
                self.expect_semicolon()?;
                Ok(StmtData {
                    stmt: Stmt::Return(expr),
                    span: self.span_from(start),
                })
            }
            TokenKind::KeywordBreak => {
                self.bump();
                self.expect_semicolon()?;
                Ok(StmtData {
                    stmt: Stmt::Break,
                    span: self.span_from(start),
                })
            }
            TokenKind::KeywordContinue => {
                self.bump();
                self.expect_semicolon()?;
                Ok(StmtData {
                    stmt: Stmt::Continue,
                    span: self.span_from(start),
                })
            }
            TokenKind::LBrace => {
                let stmts = self.parse_block_body()?;
                let stmt = if stmts.is_empty() {
                    Stmt::CompilerDud
                } else {
                    Stmt::Block(stmts)
                };
                Ok(StmtData {
                    stmt,
                    span: self.span_from(start),
                })
            }
            TokenKind::RBrace | TokenKind::SemiColon => {
                let tok = self.peek();
                self.error(
                    tok.span,
                    &format!("Expected statement, found {:?}", tok.kind),
                );
                Err(())
            }
            TokenKind::KeywordFor => {
                self.bump();
                let binding = self.parse_expression()?;
                self.expect(TokenKind::KeywordIn, "Expected 'in' in for loop")?;
                let iter = self.parse_expression()?;
                let body = self.parse_block_body()?;
                Ok(StmtData {
                    stmt: Stmt::ForLoop(binding, iter, body),
                    span: self.span_from(start),
                })
            }
            TokenKind::KeywordWhile => {
                self.bump();
                let cond = self.parse_expression()?;
                let body = self.parse_block_body()?;
                Ok(StmtData {
                    stmt: Stmt::WhileLoop(cond, body),
                    span: self.span_from(start),
                })
            }
            TokenKind::KeywordDo => {
                self.bump();
                let body = self.parse_block_body()?;
                self.expect(TokenKind::KeywordWhile, "Expected 'while' after do block")?;
                let cond = self.parse_expression()?;
                self.expect_semicolon()?;
                Ok(StmtData {
                    stmt: Stmt::DoWhileLoop(cond, body),
                    span: self.span_from(start),
                })
            }
            _ => {
                let expr = self.parse_expression()?;
                self.expect_semicolon()?;
                Ok(StmtData {
                    stmt: Stmt::Expr(expr),
                    span: self.span_from(start),
                })
            }
        }
    }

    fn parse_const_let_statement(
        &mut self,
        start: Span,
        attributes: Vec<Attribute>,
    ) -> Result<StmtData, ()> {
        self.bump(); // const
        let (name, _) = self.expect_name("Expected constant name")?;
        self.expect(TokenKind::Colon, "Expected ':' after constant name")?;
        let var_type = self.parse_type()?;
        self.expect(TokenKind::Equal, "Expected '=' for const initialization")?;
        let initializer = self.parse_expression()?;
        self.expect_semicolon()?;
        Ok(StmtData {
            stmt: Stmt::ConstLet(ParsedVariable {
                attributes: attributes.into_boxed_slice(),
                name,
                var_type,
                prefixes: Box::new([]),
                expr: Some(initializer),
                var_comp_type: VarType::Constant,
            }),
            span: self.span_from(start),
        })
    }

    fn parse_static_let_statement(
        &mut self,
        start: Span,
        attributes: Vec<Attribute>,
    ) -> Result<StmtData, ()> {
        self.bump(); // static
        let (name, _) = self.expect_name("Expected static variable name")?;
        self.expect(TokenKind::Colon, "Expected ':' after variable name")?;
        let var_type = self.parse_type()?;
        let initializer = if self.eat(TokenKind::Equal) {
            Some(self.parse_expression()?)
        } else {
            None
        };
        self.expect_semicolon()?;
        Ok(StmtData {
            stmt: Stmt::StaticLet(ParsedVariable {
                attributes: attributes.into_boxed_slice(),
                name,
                var_type,
                prefixes: Box::new([]),
                expr: initializer,
                var_comp_type: VarType::Static,
            }),
            span: self.span_from(start),
        })
    }

    fn parse_let_statement(&mut self, start: Span) -> Result<StmtData, ()> {
        self.bump(); // let
        let (name, _) = self.expect_name("Expected variable name")?;
        self.expect(TokenKind::Colon, "Expected ':' after variable name")?;
        let var_type = self.parse_type()?;
        let initializer = if self.eat(TokenKind::Equal) {
            Some(self.parse_expression()?)
        } else {
            None
        };
        self.expect_semicolon()?;
        Ok(StmtData {
            stmt: Stmt::Let(ParsedVariable {
                attributes: Box::new([]),
                name,
                var_type,
                prefixes: Box::new([]),
                expr: initializer,
                var_comp_type: VarType::Stack,
            }),
            span: self.span_from(start),
        })
    }

    fn parse_if_statement(&mut self, start: Span) -> Result<StmtData, ()> {
        self.bump(); // if
        let condition = self.parse_expression()?;
        let then_body = self.parse_block_body()?;

        let else_branch = if self.eat(TokenKind::KeywordElse) {
            if self.at(TokenKind::KeywordIf) {
                let else_if_start = self.peek().span;
                let else_if_stmt = self.parse_if_statement(else_if_start)?;
                Box::new([else_if_stmt])
            } else {
                self.parse_block_body()?
            }
        } else {
            Box::new([])
        };

        Ok(StmtData {
            stmt: Stmt::If(condition, then_body, else_branch),
            span: self.span_from(start),
        })
    }

    fn prepend_modifier(prefixes: &mut Box<[Modifier]>, modifier: Modifier) {
        let mut v = Vec::with_capacity(prefixes.len() + 1);
        v.push(modifier);
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
