#[allow(unreachable_code)]
#[cfg(test)]
mod parser_tests {

    use rcsharp_lexer::Lexer;
    use rcsharp_parser::{
        expression_parser::{BinaryOp, Expr},
        parser::{
            GeneralParser, ParsedFunction, ParsedStruct, ParserResult, ParserType, Span, Stmt,
            StmtData,
        },
    };

    fn parse(src: &str) -> ParserResult<Vec<Stmt>> {
        let mut tokens = vec![];
        for x in Lexer::new(&src) {
            match x {
                Ok(x) => tokens.push(x),
                Err(x) => panic!("Lexing error: {:?}", x),
            }
        }

        return Ok(GeneralParser::new(&tokens)
            .parse_all()?
            .into_iter()
            .map(|x| x.stmt)
            .collect::<Vec<Stmt>>());
    }
    #[test]
    fn basic_function() -> ParserResult<()> {
        let fb = parse("fn foo(){}")?;
        let fb1 = parse("fn foo(): void{}")?;
        assert_eq!(
            fb[0],
            Stmt::Function(ParsedFunction {
                name: format!("foo").into_boxed_str(),
                args: Box::new([]),
                return_type: ParserType::Named(format!("void")),
                path: "".to_string().into(),
                body: Box::new([]),
                attributes: Box::new([]),
                prefixes: Box::new([]),
                generic_params: Box::new([])
            })
        );
        assert_eq!(fb, fb1);
        Ok(())
    }
    #[test]
    fn basic_struct() -> ParserResult<()> {
        let fb = parse("struct bar{x:i8}")?;
        let fb1 = parse("struct bar{x:&i8, y: i32}")?;
        assert_eq!(
            fb[0],
            Stmt::Struct(ParsedStruct {
                path: "".into(),
                attributes: Box::new([]),
                name: format!("bar").into_boxed_str(),
                fields: Box::new([(format!("x"), ParserType::Named(format!("i8")))]),
                generic_params: Box::new([]),
                prefixes: Box::new([])
            })
        );
        assert_eq!(
            fb1[0],
            Stmt::Struct(ParsedStruct {
                path: "".into(),
                attributes: Box::new([]),
                name: format!("bar").into_boxed_str(),
                fields: Box::new([
                    (
                        format!("x"),
                        ParserType::Pointer(Box::new(ParserType::Named(format!("i8"))))
                    ),
                    (format!("y"), ParserType::Named(format!("i32")))
                ]),
                generic_params: Box::new([]),
                prefixes: Box::new([])
            })
        );
        Ok(())
    }

    #[test]
    fn function_declaration() -> ParserResult<()> {
        let src = "fn DoSomething(val: i32): &i8;";
        let ast = parse(src)?;

        let expected = Stmt::Function(ParsedFunction {
            name: "DoSomething".to_string().into_boxed_str(),
            args: Box::new([("val".to_string(), ParserType::Named("i32".to_string()))]),
            return_type: ParserType::Pointer(Box::new(ParserType::Named("i8".to_string()))),
            attributes: Box::new([]),
            body: Box::new([]),
            path: "".to_string().into(),
            prefixes: Box::new([]),
            generic_params: Box::new([]),
        });

        assert_eq!(ast.len(), 1);
        assert_eq!(ast[0], expected);
        Ok(())
    }
    #[test]
    fn let_statement() -> ParserResult<()> {
        let s1_src = "fn f() { let x: i32; }";
        let s2_src = "fn f() { let y: &i8 = 1 + 2; }";

        let ast1 = parse(s1_src)?;
        let ast2 = parse(s2_src)?;

        let expected_stmt1 = Stmt::Let("x".to_string(), ParserType::Named("i32".to_string()), None);
        if let Stmt::Function(func) = &ast1[0] {
            assert_eq!(func.body.len(), 1);
            assert_eq!(func.body[0].stmt, expected_stmt1);
        } else {
            panic!("Expected Function, got {:?}", ast1[0])
        }

        let expected_stmt2 = Stmt::Let(
            "y".to_string(),
            ParserType::Pointer(Box::new(ParserType::Named("i8".to_string()))),
            Some(Expr::BinaryOp(
                Box::new(Expr::Integer("1".to_string())),
                BinaryOp::Add,
                Box::new(Expr::Integer("2".to_string())),
            )),
        );
        if let Stmt::Function(func) = &ast2[0] {
            assert_eq!(func.body.len(), 1);
            assert_eq!(func.body[0].stmt, expected_stmt2);
        } else {
            return Err(panic!("Expected Function, got {:?}", ast2[0]));
        }

        Ok(())
    }
    #[test]
    fn if_else_statement() -> ParserResult<()> {
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
                Box::new(Expr::Integer("1".to_string())),
            ),
            Box::new([StmtData {
                stmt: Stmt::Return(None),
                span: Span::new(12, 14),
            }]),
            Box::new([]),
        );
        if let Stmt::Function(func) = &ast1[0] {
            assert_eq!(func.body[0].stmt, expected_if1);
        } else {
            return Err(panic!("Expected Function, got {:?}", ast1[0]));
        }

        let expected_if2 = Stmt::If(
            Expr::Name("a".to_string()),
            Box::new([]),
            Box::new([Stmt::Expr(Expr::Assign(
                Box::new(Expr::Name("a".to_string())),
                Box::new(Expr::Integer("1".to_string())),
            ))
            .dummy_data()]),
        );
        if let Stmt::Function(func) = &ast2[0] {
            assert_eq!(func.body[0].stmt, expected_if2);
        } else {
            return Err(panic!("Expected Function, got {:?}", ast2[0]));
        }

        let expected_if3 = Stmt::If(
            Expr::Name("a".to_string()),
            Box::new([]),
            Box::new([
                Stmt::If(Expr::Name("b".to_string()), Box::new([]), Box::new([])).dummy_data(),
            ]),
        );
        if let Stmt::Function(func) = &ast3[0] {
            assert_eq!(func.body[0].stmt, expected_if3);
        } else {
            return Err(panic!("Expected Function, got {:?}", ast3[0]));
        }

        Ok(())
    }
    #[test]
    fn loop_break_continue() -> ParserResult<()> {
        let src = "fn f() { loop { break; continue; } }";
        let ast = parse(src)?;

        let expected = Stmt::Loop(Box::new([
            StmtData {
                stmt: Stmt::Break,
                span: Span::new(7, 9),
            },
            StmtData {
                stmt: Stmt::Continue,
                span: Span::new(9, 11),
            },
        ]));

        if let Stmt::Function(func) = &ast[0] {
            assert_eq!(func.body.len(), 1);
            assert_eq!(func.body[0].stmt, expected);
        } else {
            return Err(panic!("Expected Function, got {:?}", ast[0]));
        }
        Ok(())
    }
    #[test]
    fn return_statement() -> ParserResult<()> {
        let s1_src = "fn f() { return; }";
        let s2_src = "fn f() { return 1 + 1; }";

        let ast1 = parse(s1_src)?;
        let ast2 = parse(s2_src)?;

        let expected_return1 = Stmt::Return(None);
        if let Stmt::Function(func) = &ast1[0] {
            assert_eq!(func.body[0].stmt, expected_return1);
        } else {
            return Err(panic!("Expected Function, got {:?}", ast1[0]));
        }

        let expected_return2 = Stmt::Return(Some(Expr::BinaryOp(
            Box::new(Expr::Integer("1".to_string())),
            BinaryOp::Add,
            Box::new(Expr::Integer("1".to_string())),
        )));
        if let Stmt::Function(func) = &ast2[0] {
            assert_eq!(func.body[0].stmt, expected_return2);
        } else {
            return Err(panic!("Expected Function, got {:?}", ast2[0]));
        }

        Ok(())
    }
    #[test]
    fn expression_statement() -> ParserResult<()> {
        let s1_src = "fn f() { a = b; }";
        let s2_src = "fn f() { my_func(a, 1); }";

        let ast1 = parse(s1_src)?;
        let ast2 = parse(s2_src)?;

        let expected_expr1 = Stmt::Expr(Expr::Assign(
            Box::new(Expr::Name("a".to_string())),
            Box::new(Expr::Name("b".to_string())),
        ));
        if let Stmt::Function(func) = &ast1[0] {
            assert_eq!(func.body[0].stmt, expected_expr1);
        } else {
            return Err(panic!("Expected Function, got {:?}", ast1[0]));
        }

        let expected_expr2 = Stmt::Expr(Expr::Call(
            Box::new(Expr::Name("my_func".to_string())),
            Box::new([Expr::Name("a".to_string()), Expr::Integer("1".to_string())]),
        ));
        if let Stmt::Function(func) = &ast2[0] {
            assert_eq!(func.body[0].stmt, expected_expr2);
        } else {
            return Err(panic!("Expected Function, got {:?}", ast2[0]));
        }

        Ok(())
    }
    #[test]
    fn pointer_types() -> ParserResult<()> {
        let s1_src = "fn f(p: &i32) {}";
        let s2_src = "fn f(p: &&i32) {}";

        let ast1 = parse(s1_src)?;
        let ast2 = parse(s2_src)?;

        let expected_type1 = ParserType::Pointer(Box::new(ParserType::Named("i32".to_string())));
        if let Stmt::Function(func) = &ast1[0] {
            assert_eq!(func.args[0].1, expected_type1);
        } else {
            return Err(panic!("Expected Function, got {:?}", ast1[0]));
        }

        let expected_type2 = ParserType::Pointer(Box::new(ParserType::Pointer(Box::new(
            ParserType::Named("i32".to_string()),
        ))));
        if let Stmt::Function(func) = &ast2[0] {
            assert_eq!(func.args[0].1, expected_type2);
        } else {
            return Err(panic!("Expected Function, got {:?}", ast2[0]));
        }

        Ok(())
    }
    #[test]
    fn complex_expression_and_types() -> ParserResult<()> {
        let src = "fn f() { list.foot.next_node = new_node; }";
        let ast = parse(src)?;
        let expected_stmt = Stmt::Expr(Expr::Assign(
            Box::new(Expr::MemberAccess(
                Box::new(Expr::MemberAccess(
                    Box::new(Expr::Name("list".to_string())),
                    "foot".to_string(),
                )),
                "next_node".to_string(),
            )),
            Box::new(Expr::Name("new_node".to_string())),
        ));

        if let Stmt::Function(func) = &ast[0] {
            assert_eq!(func.body[0].stmt, expected_stmt);
        } else {
            return Err(panic!("Expected Function, got {:?}", ast[0]));
        }

        Ok(())
    }
}
