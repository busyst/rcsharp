use crate::{compiler::rcsharp_compile_to_file, parser::rcsharp_parser, token::Lexer};
mod token;
mod expression_parser;
mod expression_compiler;
mod parser;
mod sub_parsers;
mod compiler;
mod parser_test;
mod compiler_tests;

fn main() -> Result<(), String> {
    //let dll_path = r#"c:\Windows\System32\kernel32.dll"#;
    //let lib_path = "./kernel32.lib";
    //rcsharp::generate_lib_with_dlltool(&dll_path, &lib_path).unwrap();
    let src = r#"
        #[DllImport("kernel32.dll")]
        fn GetProcessHeap(): &i32;
        #[DllImport("kernel32.dll")]
        fn HeapAlloc(hHeap: &i32, dwFlags: i32, dwBytes: i64): &i8;
        
        fn malloc(size:i64) : &i8{
            return HeapAlloc(GetProcessHeap(), 0 as i32, size);
        }
        fn malloc_zero(size:i64) : &i8{
            return HeapAlloc(GetProcessHeap(), 8 as i32, size);
        }
        fn main(): i32 {
            let x: i32 = 0 as i32;
            return x;
        }
    "#;
    let mut tokens = Vec::new();
    for result in Lexer::new(src) {
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
    let y = rcsharp_parser(&tokens)?;
    if let Err(err) = rcsharp_compile_to_file(&y) {
        eprintln!("{}",err);
        return Err(format!(""));
    };
    
    Ok(())
}



