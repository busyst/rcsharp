#[cfg(test)]
mod parser_tests {
    macro_rules! name_t {
        ($name:expr) => {
            Box::new(Expr::Name(format!($name)))
        };
    }
    macro_rules! int_t {
        ($name:expr) => {
            Box::new(Expr::Integer(format!($name)))
        };
    }
    
    use crate::{expression_parser::{BinaryOp, Expr, UnaryOp}, parser::{internal_rcsharp, rcsharp_parser, ParserType, Stmt}, token::{Lexer, TokenData}};
    fn tokenize(x: &str) -> Vec<TokenData>{
        Lexer::new(x).map(|x| x.unwrap()).collect::<Vec<_>>()
    }

    #[test]
    fn assigment_basic() {
        let x = tokenize("let y: u8 = x;");
        let y = internal_rcsharp(&x).unwrap();
        assert_eq!(y.len(), 2);
        assert_eq!(y[0], Stmt::Let(format!("y"), ParserType::Named(format!("u8"))));
        assert_eq!(y[1], Stmt::Expr(Expr::Assign(name_t!("y"), name_t!("x"))));
    }
    #[test]
    fn assigment_operation() {
        let x = tokenize("let y: u8 = x + 2;");
        let y = internal_rcsharp(&x).unwrap();
        assert_eq!(y.len(), 2);
        assert_eq!(y[0], Stmt::Let(format!("y"), ParserType::Named(format!("u8"))));
        assert_eq!(y[1], Stmt::Expr(Expr::Assign(name_t!("y"), Box::new(Expr::BinaryOp(name_t!("x"), BinaryOp::Add, int_t!("2"))))));
    }
    #[test]
    fn assigment_pointer() {
        let x = tokenize("let y: &u8 = &x;");
        let y = internal_rcsharp(&x).unwrap();
        assert_eq!(y.len(), 2);
        assert_eq!(y[0], Stmt::Let(format!("y"), ParserType::Ref(Box::new(ParserType::Named(format!("u8"))))));
        assert_eq!(y[1], Stmt::Expr(Expr::Assign(name_t!("y"), Box::new(Expr::UnaryOp(UnaryOp::Ref, name_t!("x"))))));
    }
    #[test]
    fn function_simple() {
        let x = tokenize("fn x(){}");
        let y = rcsharp_parser(&x).unwrap();
        assert_eq!(y.len(), 1);
        assert_eq!(y[0], Stmt::Function(format!("x"), vec![], ParserType::Named(format!("void")), Box::new(Stmt::Block(vec![]))));
    }
    #[test]
    fn function_type() {
        let x = tokenize("fn x() : &void {}");
        let y = rcsharp_parser(&x).unwrap();
        assert_eq!(y.len(), 1);
        assert_eq!(y[0], Stmt::Function(format!("x"), vec![], ParserType::Ref(Box::new(ParserType::Named(format!("void")))), Box::new(Stmt::Block(vec![]))));
    }
    #[test]
    fn function_argumets() {
        let x = tokenize("fn x(x: &void, y: u64) : &void {}");
        let y = rcsharp_parser(&x).unwrap();
        assert_eq!(y.len(), 1);
        assert_eq!(y[0], Stmt::Function(
            format!("x"),
            vec![(format!("x"), ParserType::Ref(Box::new(ParserType::Named(format!("void"))))),(format!("y"), ParserType::Named(format!("u64")))], 
            ParserType::Ref(Box::new(ParserType::Named(format!("void")))), 
            Box::new(Stmt::Block(vec![])))
        );
    }
    #[test]
    fn expresion_basic() {
        let x = tokenize("x + 2");
        let y = internal_rcsharp(&x).unwrap();
        assert_eq!(y.len(), 1);
        assert_eq!(y[0], Stmt::Expr(Expr::BinaryOp(name_t!("x"), BinaryOp::Add, int_t!("2"))));
    }
    #[test]
    fn expression_sophisticated_1() {
        let x = tokenize("((3 + 1) * 4)");
        let y = internal_rcsharp(&x).unwrap();
        assert_eq!(y.len(), 1);
        assert_eq!(y[0], Stmt::Expr(Expr::BinaryOp(Box::new(Expr::BinaryOp(int_t!("3"), BinaryOp::Add, int_t!("1"))), BinaryOp::Multiply, int_t!("4"))));
    }
    #[test]
    fn expression_sophisticated_2() {
        let x = tokenize("( (9 / 3) * (2 + 1) )");
        let y = internal_rcsharp(&x).unwrap();
        assert_eq!(y.len(), 1);
        assert_eq!(y[0], Stmt::Expr(Expr::BinaryOp(
            Box::new(Expr::BinaryOp(int_t!("9"), BinaryOp::Divide, int_t!("3"))),
            BinaryOp::Multiply,
            Box::new(Expr::BinaryOp(int_t!("2"), BinaryOp::Add, int_t!("1")))
        )));
    }
    #[test]
    fn expression_edge_1() {
        let x = tokenize("(1 + 2 + 3 + 4 + 5)");
        let y = internal_rcsharp(&x).unwrap();
        assert_eq!(y.len(), 1);
        assert_eq!(y[0], Stmt::Expr(Expr::BinaryOp(
            Box::new(Expr::BinaryOp(
                Box::new(Expr::BinaryOp(
                    Box::new(Expr::BinaryOp(int_t!("1"), BinaryOp::Add, int_t!("2"))),
                    BinaryOp::Add,
                    int_t!("3")
                )),
                BinaryOp::Add,
                int_t!("4")
            )),
            BinaryOp::Add,
            int_t!("5")
        )));
    }

    #[test]
    fn expression_edge_2() {
        let x = tokenize("( (1 + 2) * (3 + 4) )");
        let y = internal_rcsharp(&x).unwrap();
        assert_eq!(y.len(), 1);
        assert_eq!(y[0], Stmt::Expr(Expr::BinaryOp(
            Box::new(Expr::BinaryOp(int_t!("1"), BinaryOp::Add, int_t!("2"))),
            BinaryOp::Multiply,
            Box::new(Expr::BinaryOp(int_t!("3"), BinaryOp::Add, int_t!("4")))
        )));
    }
}