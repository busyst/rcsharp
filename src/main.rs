use std::{io::Read, process::exit};

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
    let src = {let mut buf = String::new(); std::fs::File::open("./src.rcsharp").unwrap().read_to_string(&mut buf).unwrap(); buf};
    let tokens = Lexer::new(&src).map(|x| 
        match x {
            Ok(x) => x,
            Err(err) => {eprintln!("ERROR: {} | Span: {:?} | Slice: {:?}", err,err.span,&src[err.span.clone()]); exit(-1)},
        }
    ).collect::<Vec<_>>();

    let y = rcsharp_parser(&tokens)?;
    
    if let Err(err) = rcsharp_compile_to_file(&y) {
        eprintln!("{}",err);
        return Err(format!(""));
    };
    
    Ok(())
}



