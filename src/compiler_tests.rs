#[cfg(test)]
mod compiler_tests {
    use crate::compiler::rcsharp_compile;
    use crate::parser::rcsharp_parser;
    use crate::token::Lexer;
    
    fn compile_source_to_string(source: &str) -> Result<String, String> {
        let tokens: Vec<_> = Lexer::new(source).map(|t| t.unwrap()).collect();
        let output = rcsharp_compile(&rcsharp_parser(&tokens)?)?;
        
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
            return 0 as i32;
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
            return 0 as i32;
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

        assert!(llvm_ir.contains("define i32 @add(i32 %a, i32 %b)"));

        assert!(llvm_ir.contains("define i32 @main()"));

        assert!(llvm_ir.contains("add i32 10, 0"));
        assert!(llvm_ir.contains("add i32 20, 0"));

        assert!(llvm_ir.contains("call i32 %tmp0(i32 %tmp"));
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
