


use crate::{compiler::rcsharp_compile_to_file, parser::rcsharp, token::Lexer};
mod token;
mod expression_parser;
mod expression_compiler;
mod parser;
mod compiler;

fn main() -> Result<(), String> {
    //let dll_path = Path::new(r#"c:\Windows\System32\opengl32.dll"#);
    //let lib_path = Path::new("./opengl32.lib");
    //generate_lib_from_dll(&dll_path, &lib_path)
    //    .with_context(|| format!("Failed to generate .lib for {}", dll_path.display())).unwrap();
    //return Ok(());
    let src = r#"
        #[DllImport("kernel32.dll")]
        fn AllocConsole(): i32;

        #[DllImport("kernel32.dll")]
        fn FreeConsole(): i32;

        #[DllImport("kernel32.dll")]
        fn ExitProcess(code:i32): void;

        #[DllImport("kernel32.dll")]
        fn GetStdHandle(nStdHandle: i32): &i32;

        #[DllImport("kernel32.dll")]
        fn WriteConsoleA(
            hConsoleOutput: &i32,
            lpBuffer: &i8,
            nNumberOfCharsToWrite: i32,
            lpNumberOfCharsWritten: &i32,
            lpReserved: &i32
        ): i32;


        #[DllImport("kernel32.dll")]
        fn ReadConsoleA(
            hConsoleInput: &i32,
            lpBuffer: &i8,
            nNumberOfCharsToRead: i32,
            lpNumberOfCharsRead: &i32,
            pInputControl: &i32
        ): i32;

        #[DllImport("kernel32.dll")]
        fn GetProcessHeap(): &i32;



        #[DllImport("kernel32.dll")]
        fn HeapAlloc(hHeap: &i32, dwFlags: i32, dwBytes: i64): &i8;

        #[DllImport("kernel32.dll")]
        fn HeapFree(hHeap: &i32, dwFlags: i32, lpMem: &i8): i32;
        fn __chkstk(){
            // That is moronic
        }
        fn get_stdout() : &i32 {
            let stdout_handle: &i32 = GetStdHandle(-11 as i32);
            if (&stdout_handle) == -1{
                ExitProcess(-1);
            }
            return stdout_handle;
        }
        fn get_stdin() : &i32 {
            let stdin_handle: &i32 = GetStdHandle(-10 as i32);
            if (&stdin_handle) == -1{
                ExitProcess(-1);
            }
            return stdin_handle;
        }
        fn malloc(size:i32) : &i8{
            let process_heap: &i32 = GetProcessHeap();
            let buffer: &i8 = HeapAlloc(process_heap, 0, size);
            return buffer;
        }
        fn malloc_zero(size:i32) : &i8{
            let process_heap: &i32 = GetProcessHeap();
            let buffer: &i8 = HeapAlloc(process_heap, 8, size);
            return buffer;
        }
        fn free(buffer: &i8) {
            let process_heap: &i32 = GetProcessHeap();
            HeapFree(process_heap, 0, buffer);
        }
        fn write(buffer: &i8, len: i32){
            let stdout_handle: &i32 = get_stdout();
            WriteConsoleA(stdout_handle, buffer, len, 0 as &i32, 0 as &i32);
        }
        fn read_key() : i8{
            let stdin_handle: &i32 = get_stdin();
            let read: i32 = 0;
            let input_buffer : i8 = 0;
            ReadConsoleA(stdin_handle, &input_buffer, 1, &read, 0);
            return input_buffer;
        }
        fn echo(): void {
            let BUFFER_SIZE: i32 = 1024;

            let input_buffer: &i8 = malloc(BUFFER_SIZE);

            let number_of_chars_read: i32 = 0;

            let stdin_handle: &i32 = get_stdin();

            ReadConsoleA(
                stdin_handle,          
                input_buffer,          
                BUFFER_SIZE,           
                &number_of_chars_read, 
                0                      
            );
            write(input_buffer, number_of_chars_read);
            free(input_buffer);
        }
        fn mem_copy(dest: &i8, src : &i8, len : i32){
            let i : i32 = 0;
            loop{
                if i >= len{
                    break;
                }
                (*&dest[i]) = src[i];
                i = i + 1;
            }
        }
        fn main(): i32 {
            AllocConsole();
            let prompt_msg: &i8 = "Please type something and press Enter:\n\r";
            let buffer : &i8 = malloc(38);
            let x: &i8 = "esaelP";
            
            mem_copy(buffer,prompt_msg,38);
            mem_copy(buffer,x,6);
            write(buffer, 38);

            echo();

            //write("\nPress any key to exit...", 26);
            //read_key();
            
            FreeConsole();
            ExitProcess(0);

            return 0; 
        }
    "#;
    let lexer = Lexer::new(src);
    let mut tokens = Vec::new();
    for result in lexer {
        match result {
            Ok(token_data) => {
                tokens.push(token_data);
            }
            Err(lexing_error) => {
                eprintln!(
                    "ERROR: {} | Span: {:?} | Slice: {:?}",
                    lexing_error,
                    lexing_error.span,
                    &src[lexing_error.span.clone()]
                );
                return Err(format!("Error during compilation"));
            }
        }
    }
    let y = rcsharp(&tokens)?;
    rcsharp_compile_to_file(&y)?;
    Ok(())
}


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
    
    use crate::{expression_parser::{BinaryOp, Expr, UnaryOp}, parser::{internal_rcsharp, rcsharp, ParserType, Stmt}, token::{Lexer, TokenData}};
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
        let y = rcsharp(&x).unwrap();
        assert_eq!(y.len(), 1);
        assert_eq!(y[0], Stmt::Function(format!("x"), vec![], ParserType::Named(format!("void")), Box::new(Stmt::Block(vec![]))));
    }
    #[test]
    fn function_type() {
        let x = tokenize("fn x() : &void {}");
        let y = rcsharp(&x).unwrap();
        assert_eq!(y.len(), 1);
        assert_eq!(y[0], Stmt::Function(format!("x"), vec![], ParserType::Ref(Box::new(ParserType::Named(format!("void")))), Box::new(Stmt::Block(vec![]))));
    }
    #[test]
    fn function_argumets() {
        let x = tokenize("fn x(x: &void, y: u64) : &void {}");
        let y = rcsharp(&x).unwrap();
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
#[cfg(test)]
mod compiler_tests {
    use crate::compiler::rcsharp_compile;
    use crate::parser::rcsharp;
    use crate::token::Lexer;
    
    fn compile_source_to_string(source: &str) -> Result<String, String> {
        let tokens: Vec<_> = Lexer::new(source).map(|t| t.unwrap()).collect();
        let output = rcsharp_compile(&rcsharp(&tokens)?)?;
        
        Ok(output)
    }

    #[test]
    fn test_simple_main_return() {
        let source = "fn main(): i32 { return 42; }";
        let llvm_ir = compile_source_to_string(source).unwrap();
        assert!(llvm_ir.contains("define i32 @main()"));
        assert!(llvm_ir.contains("add i32 42, 0"));
        assert!(llvm_ir.contains("ret i32 %tmp"));
    }

    #[test]
    fn test_variable_declaration_and_assignment() {
        let source = "
        fn main(): i32 {
            let x: i32;
            x = 10;
            return x;
        }";
        let llvm_ir = compile_source_to_string(source).unwrap();
        assert!(llvm_ir.contains("%x = alloca i32"));
        assert!(llvm_ir.contains("add i32 10, 0"));
        assert!(llvm_ir.contains("store i32 %tmp"));
        assert!(llvm_ir.contains("i32* %x"));
        assert!(llvm_ir.contains("load i32, i32* %x"));
        assert!(llvm_ir.contains("ret i32 %tmp"));
    }

    #[test]
    fn test_basic_arithmetic() {
        let source = "
        fn main(): i32 {
            let a: i32 = 5;
            let b: i32 = 3;
            return a - b;
        }";
        let llvm_ir = compile_source_to_string(source).unwrap();
        assert!(llvm_ir.contains("%a = alloca i32"));
        assert!(llvm_ir.contains("%b = alloca i32"));
        // Check for storing the literals
        assert!(llvm_ir.contains("store i32 %tmp")); // stores 5 in a
        assert!(llvm_ir.contains("store i32 %tmp")); // stores 3 in b
        // Check that both variables are loaded into temporaries for the operation
        assert!(llvm_ir.contains("load i32, i32* %a"));
        assert!(llvm_ir.contains("load i32, i32* %b"));
        // Check for the 'sub' instruction on the loaded temporaries
        assert!(llvm_ir.contains("sub i32 %tmp"));
    }
    
    #[test]
    fn test_address_of_and_pointers() {
        // Use the correct '&i32' syntax for pointer types
        let source = "
        fn main(): i32 {
            let var: i32;
            let ptr: &i32 = &var;
            return 0;
        }";
        let llvm_ir = compile_source_to_string(source).unwrap();

        assert!(llvm_ir.contains("%var = alloca i32"));
        assert!(llvm_ir.contains("%ptr = alloca i32*"));
        assert!(llvm_ir.contains("bitcast i32* %var to i32*"));
        assert!(llvm_ir.contains("store i32* %tmp")); 
        assert!(llvm_ir.contains("i32** %ptr"));
    }

    #[test]
    fn test_simple_function_call() {
        let source = "
        fn do_nothing() {}

        fn main(): i32 {
            do_nothing();
            return 0;
        }";
        let llvm_ir = compile_source_to_string(source).unwrap();
        
        assert!(llvm_ir.contains("define void @do_nothing()"));
        assert!(llvm_ir.contains("define i32 @main()"));
        // The call itself is direct, no temporaries needed for a void call with no args.
        assert!(llvm_ir.contains("call void @do_nothing()"));
    }

    #[test]
    fn test_function_call_with_args_and_return() {
        let source = "
        fn add(a: i32, b: i32): i32 {
            return a + b;
        }

        fn main(): i32 {
            return add(10, 20);
        }";
        let llvm_ir = compile_source_to_string(source).unwrap();

        // Check for the correct function signature of 'add'. The arguments are allocated on the stack.
        assert!(llvm_ir.contains("define i32 @add(i32 %a, i32 %b)"));
        // Check main function
        assert!(llvm_ir.contains("define i32 @main()"));
        // Check that temporaries are created for the literal arguments 10 and 20
        assert!(llvm_ir.contains("add i32 10, 0"));
        assert!(llvm_ir.contains("add i32 20, 0"));
        // Check that the call uses the temporaries
        assert!(llvm_ir.contains("call i32 @add(i32 %tmp"));
    }

    #[test]
    fn test_explicit_casting() {
        let source = "
        fn main(): i64 {
            let x: i32 = 100;
            let y: i64 = x as i64;
            return y;
        }";
        let llvm_ir = compile_source_to_string(source).unwrap();

        assert!(llvm_ir.contains("%x = alloca i32"));
        assert!(llvm_ir.contains("%y = alloca i64"));
        // The compiler will first load `x` into a temporary.
        assert!(llvm_ir.contains("load i32, i32* %x"));
        // Then, it will sign-extend that temporary into a new temporary.
        assert!(llvm_ir.contains("sext i32 %tmp"));
        assert!(llvm_ir.contains("to i64"));
        // This new temporary is then stored in `y`.
        assert!(llvm_ir.contains("store i64 %tmp"));
        assert!(llvm_ir.contains("i64* %y"));
    }

    #[test]
    fn test_dll_import_declaration() {
        // Use the correct '&i8' syntax for pointer types
        let source = r#"
        #[DllImport("user32.dll")]
        fn MessageBoxA(hwnd: i32, text: &i8, caption: &i8, uType: i32): i32;

        fn main(): i32 {
            return 0;
        }"#;
        let llvm_ir = compile_source_to_string(source).unwrap();

        // The assertion is still correct, as the parser translates `&i8` to the LLVM type `i8*`
        let expected_decl = "declare dllimport i32 @MessageBoxA(i32,i8*,i8*,i32)";
        assert!(llvm_ir.contains(expected_decl));
        
        // Ensure the function body was NOT generated
        assert!(!llvm_ir.contains("define i32 @MessageBoxA"));
    }

    #[test]
    fn test_string_literal() {
        // Use the correct '&i8' syntax for pointer types
        let source = r#"
        fn main(): i32 {
            let message: &i8 = "Hello, World!";
            return 0;
        }"#;
        let llvm_ir = compile_source_to_string(source).unwrap();
        println!("{:?}",llvm_ir);
        // 1. Check for the global constant string definition.
        assert!(llvm_ir.contains(r#"@.str0 = private unnamed_addr constant [14 x i8] c"Hello, World!\00""#));
        // 2. Check for getelementptr to get the address of the first character into a temporary.
        assert!(llvm_ir.contains("getelementptr inbounds [14 x i8], [14 x i8]* @.str0, i64 0, i64 0"));
        // 3. Check that the pointer is stored in the 'message' variable.
        //    The destination address is i8** because we're storing a pointer into the pointer's location.
        assert!(llvm_ir.contains("store i8* %tmp"));
        assert!(llvm_ir.contains("i8** %message"));
    }
}