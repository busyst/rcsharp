#[cfg(test)]
mod parser_tests {

    use crate::{expression_parser::{BinaryOp, Expr}, parser::{GeneralParser, ParserType, Stmt}};

    fn parse(src: &str) -> Result<Vec<Stmt>, String>{
        let mut tokens = vec![];
        for x in crate::token::Lexer::new(&src) {
            match x {
                Ok(x) => tokens.push(x),
                Err(x) => return Err(format!("{x}")),
            }
        }

        return GeneralParser::new(&tokens).parse_all();
    }
    #[test]
    fn basic_hint() -> Result<(), String> {
        let hb = parse("#[hint]")?;
        let h1 = parse("#[hint(a)]")?;
        let h2 = parse("#[hint(a + 1)]")?;
        let h3 = parse("#[hint(a + 1, 2, 3)]")?;
        assert_eq!(hb[0], Stmt::Hint(format!("hint"), vec![]));
        assert_eq!(h1[0], Stmt::Hint(format!("hint"), vec![Expr::Name(format!("a"))]));
        assert_eq!(h2[0], Stmt::Hint(format!("hint"), vec![Expr::BinaryOp(Box::new(Expr::Name(format!("a"))), BinaryOp::Add, Box::new(Expr::Integer(format!("1"))))]));
        assert_eq!(h3[0], Stmt::Hint(format!("hint"), vec![Expr::BinaryOp(Box::new(Expr::Name(format!("a"))), BinaryOp::Add, Box::new(Expr::Integer(format!("1")))), Expr::Integer(format!("2")), Expr::Integer(format!("3"))]));
        Ok(())
    }
    #[test]
    fn basic_function() -> Result<(), String> {
        let fb = parse("fn foo(){}")?;
        let fb1 = parse("fn foo(): void{}")?;
        assert_eq!(fb[0],Stmt::Function(format!("foo"), vec![], ParserType::Named(format!("void")), vec![]));
        assert_eq!(fb, fb1);
        Ok(())
    }
    #[test]
    fn basic_struct() -> Result<(), String> {
        let fb = parse("struct bar{x:i8}")?;
        let fb1 = parse("struct bar{x:&i8, y: i32}")?;
        assert_eq!(fb[0],Stmt::Struct(format!("bar"), vec![(format!("x"), ParserType::Named(format!("i8")))]));
        assert_eq!(fb1[0],Stmt::Struct(format!("bar"), vec![(format!("x"), ParserType::Pointer(Box::new(ParserType::Named(format!("i8"))))), (format!("y"), ParserType::Named(format!("i32")))]));
        Ok(())
    }
    
    #[test]
    fn function_declaration() -> Result<(), String> {
        let src = "fn DoSomething(val: i32): &i8;";
        let ast = parse(src)?;

        let expected = Stmt::Function(
            "DoSomething".to_string(),
            vec![("val".to_string(), ParserType::Named("i32".to_string()))],
            ParserType::Pointer(Box::new(ParserType::Named("i8".to_string()))),
            vec![]
        );

        assert_eq!(ast.len(), 1);
        assert_eq!(ast[0], expected);
        Ok(())
    }
    #[test]
    fn let_statement() -> Result<(), String> {
        let s1_src = "fn f() { let x: i32; }";
        let s2_src = "fn f() { let y: &i8 = 1 + 2; }";

        let ast1 = parse(s1_src)?;
        let ast2 = parse(s2_src)?;

        let expected_stmt1 = Stmt::Let(
            "x".to_string(),
            ParserType::Named("i32".to_string()),
            None
        );
        if let Stmt::Function(_, _, _, body) = &ast1[0] {
            assert_eq!(body.len(), 1);
            assert_eq!(body[0], expected_stmt1);
        } else {
            return Err(format!("Expected Function, got {:?}", ast1[0]));
        }

        let expected_stmt2 = Stmt::Let(
            "y".to_string(),
            ParserType::Pointer(Box::new(ParserType::Named("i8".to_string()))),
            Some(Expr::BinaryOp(
                Box::new(Expr::Integer("1".to_string())),
                BinaryOp::Add,
                Box::new(Expr::Integer("2".to_string()))
            ))
        );
        if let Stmt::Function(_, _, _, body) = &ast2[0] {
            assert_eq!(body.len(), 1);
            assert_eq!(body[0], expected_stmt2);
        } else {
            return Err(format!("Expected Function, got {:?}", ast2[0]));
        }

        Ok(())
    }
    #[test]
    fn if_else_statement() -> Result<(), String> {
        let s1_src = "fn f() { if (a == 1) { return; } }";
        let s2_src = "fn f() { if (a) {} else { a = 1; } }";
        let s3_src = "fn f() { if (a) {} else if (b) {} else {} }";

        let ast1 = parse(s1_src)?;
        let ast2 = parse(s2_src)?;
        let ast3 = parse(s3_src)?;

        let expected_if1 = Stmt::If(
            Expr::BinaryOp(
                Box::new(Expr::Name("a".to_string())),
                BinaryOp::Equals,
                Box::new(Expr::Integer("1".to_string()))
            ),
            vec![Stmt::Return(None)],
            None
        );
        if let Stmt::Function(_, _, _, body) = &ast1[0] {
            assert_eq!(body[0], expected_if1);
        } else {
            return Err(format!("Expected Function, got {:?}", ast1[0]));
        }

        let expected_if2 = Stmt::If(
            Expr::Name("a".to_string()),
            vec![],
            Some(Box::new(Stmt::Block(vec![
                Stmt::Expr(Expr::Assign(
                    Box::new(Expr::Name("a".to_string())),
                    Box::new(Expr::Integer("1".to_string()))
                ))
            ])))
        );
         if let Stmt::Function(_, _, _, body) = &ast2[0] {
            assert_eq!(body[0], expected_if2);
        } else {
            return Err(format!("Expected Function, got {:?}", ast2[0]));
        }
        
        let expected_if3 = Stmt::If(
            Expr::Name("a".to_string()),
            vec![],
            Some(Box::new(Stmt::If(
                Expr::Name("b".to_string()),
                vec![],
                Some(Box::new(Stmt::Block(vec![])))
            )))
        );
        if let Stmt::Function(_, _, _, body) = &ast3[0] {
            assert_eq!(body[0], expected_if3);
        } else {
            return Err(format!("Expected Function, got {:?}", ast3[0]));
        }

        Ok(())
    }
        #[test]
    fn loop_break_continue() -> Result<(), String> {
        let src = "fn f() { loop { break; continue; } }";
        let ast = parse(src)?;

        let expected = Stmt::Loop(vec![
            Stmt::Break,
            Stmt::Continue
        ]);

        if let Stmt::Function(_, _, _, body) = &ast[0] {
            assert_eq!(body.len(), 1);
            assert_eq!(body[0], expected);
        } else {
            return Err(format!("Expected Function, got {:?}", ast[0]));
        }
        Ok(())
    }
    #[test]
    fn return_statement() -> Result<(), String> {
        let s1_src = "fn f() { return; }";
        let s2_src = "fn f() { return 1 + 1; }";

        let ast1 = parse(s1_src)?;
        let ast2 = parse(s2_src)?;

        let expected_return1 = Stmt::Return(None);
        if let Stmt::Function(_, _, _, body) = &ast1[0] {
            assert_eq!(body[0], expected_return1);
        } else {
            return Err(format!("Expected Function, got {:?}", ast1[0]));
        }

        let expected_return2 = Stmt::Return(Some(Expr::BinaryOp(
            Box::new(Expr::Integer("1".to_string())),
            BinaryOp::Add,
            Box::new(Expr::Integer("1".to_string()))
        )));
        if let Stmt::Function(_, _, _, body) = &ast2[0] {
            assert_eq!(body[0], expected_return2);
        } else {
            return Err(format!("Expected Function, got {:?}", ast2[0]));
        }

        Ok(())
    }
    #[test]
    fn expression_statement() -> Result<(), String> {
        let s1_src = "fn f() { a = b; }";
        let s2_src = "fn f() { my_func(a, 1); }";

        let ast1 = parse(s1_src)?;
        let ast2 = parse(s2_src)?;

        let expected_expr1 = Stmt::Expr(Expr::Assign(
            Box::new(Expr::Name("a".to_string())),
            Box::new(Expr::Name("b".to_string()))
        ));
        if let Stmt::Function(_, _, _, body) = &ast1[0] {
            assert_eq!(body[0], expected_expr1);
        } else {
            return Err(format!("Expected Function, got {:?}", ast1[0]));
        }

        let expected_expr2 = Stmt::Expr(Expr::Call(
            Box::new(Expr::Name("my_func".to_string())),
            vec![
                Expr::Name("a".to_string()),
                Expr::Integer("1".to_string())
            ]
        ));
        if let Stmt::Function(_, _, _, body) = &ast2[0] {
            assert_eq!(body[0], expected_expr2);
        } else {
            return Err(format!("Expected Function, got {:?}", ast2[0]));
        }

        Ok(())
    }
    #[test]
    fn pointer_types() -> Result<(), String> {
        let s1_src = "fn f(p: &i32) {}";
        let s2_src = "fn f(p: &&i32) {}";

        let ast1 = parse(s1_src)?;
        let ast2 = parse(s2_src)?;

        let expected_type1 = ParserType::Pointer(Box::new(ParserType::Named("i32".to_string())));
        if let Stmt::Function(_, args, _, _) = &ast1[0] {
            assert_eq!(args[0].1, expected_type1);
        } else {
            return Err(format!("Expected Function, got {:?}", ast1[0]));
        }

        let expected_type2 = ParserType::Pointer(Box::new(
            ParserType::Pointer(Box::new(
                ParserType::Named("i32".to_string())
            ))
        ));
        if let Stmt::Function(_, args, _, _) = &ast2[0] {
            assert_eq!(args[0].1, expected_type2);
        } else {
            return Err(format!("Expected Function, got {:?}", ast2[0]));
        }
        
        Ok(())
    }
    #[test]
    fn complex_expression_and_types() -> Result<(), String> {
        // This test uses constructs from the example code provided
        let src = "fn f() { list.foot.next_node = new_node; }";
        let ast = parse(src)?;

        // Test: list.foot.next_node = new_node;
        let expected_stmt = Stmt::Expr(
            Expr::Assign(
                Box::new(Expr::MemberAccess(
                    Box::new(Expr::MemberAccess(
                        Box::new(Expr::Name("list".to_string())),
                        "foot".to_string()
                    )),
                    "next_node".to_string()
                )),
                Box::new(Expr::Name("new_node".to_string()))
            )
        );

        if let Stmt::Function(_, _, _, body) = &ast[0] {
            assert_eq!(body[0], expected_stmt);
        } else {
            return Err(format!("Expected Function, got {:?}", ast[0]));
        }

        Ok(())
    }
}