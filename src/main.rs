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

        /*fn malloc_zero(size:i32) : &i8{
            let process_heap: &i32 = GetProcessHeap();
            let buffer: &i8 = HeapAlloc(process_heap, 8, size);
            return buffer;
        }*/
        fn main(): i64 {
            let x1 : u32 = 1235 as u32;
            let x2 : u32 = 1235 as u32;
            let y1 : &i64 = (&x1) as &i64;
            let y2 : &i64 = (&x2) as &i64;
            let z1 : i64 = y1 as i64;
            let z2 : i64 = y2 as i64;
            return z1;
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



