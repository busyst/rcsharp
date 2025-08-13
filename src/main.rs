use std::{io::Read, process::exit};

use crate::{compiler::rcsharp_compile_to_file, parser::GeneralParser, token::Lexer};
mod token;
mod expression_parser;
mod expression_compiler;
mod parser;
mod compiler;
mod parser_test;
mod compiler_tests;

pub const ALLOW_EXTENTION_FUNCTIONS: bool = false;
pub const USE_MULTIPLY_AS_POINTER_IN_TYPES: bool = true;

fn main() {
    //let dll_path = r#"c:\Windows\System32\kernel32.dll"#;
    //let lib_path = "./kernel32.lib";
    //rcsharp::generate_lib_with_dlltool(&dll_path, &lib_path).unwrap();
    let src = {let mut buf = String::new(); std::fs::File::open("./src_base_structs.rcsharp").unwrap().read_to_string(&mut buf).unwrap(); buf};
    let mut tokens = Lexer::new(&src).map(|x| 
        match x {
            Ok(x) => x,
            Err(err) => {eprintln!("ERROR: {} | Span: {:?} | Slice: {:?}", err,err.span,&src[err.span.clone()]); exit(-1)},
        }
    ).collect::<Vec<_>>();
    
    let src = {let mut buf = String::new(); std::fs::File::open("./src.rcsharp").unwrap().read_to_string(&mut buf).unwrap(); buf};
    for x in Lexer::new(&src) {
        match x {
            Ok(x) => tokens.push(x),
            Err(err) => {eprintln!("ERROR: {} | Span: {:?} | Slice: {:?}", err,err.span,&src[err.span.clone()]); exit(-1)},
        }
    }

    let y = GeneralParser::new(&tokens).parse_all();
    if let Err(err) = y {
        eprintln!("{}",err);
        return;
    };
    let y = y.unwrap();
    if let Err(err) = rcsharp_compile_to_file(&y) {
        eprintln!("{}",err);
        return;
    };
}


