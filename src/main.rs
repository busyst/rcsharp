use std::{io::Read, process::exit, time::Instant};
use crate::{compiler::rcsharp_compile_to_file, parser::GeneralParser, token::Lexer};

pub mod token;
pub mod expression_parser;
pub mod expression_compiler;
pub mod parser;
pub mod compiler;
pub mod compiler_essentials;
mod tests;

pub const ALLOW_EXTENTION_FUNCTIONS: bool = false;
pub const USE_MULTIPLY_AS_POINTER_IN_TYPES: bool = true;

fn main() -> Result<(),()> {
    //let dll_path = r#"c:\Windows\System32\kernel32.dll"#;
    //let lib_path = "./kernel32.lib";
    //rcsharp::generate_lib_with_dlltool(&dll_path, &lib_path).unwrap();
    
    let program_start = Instant::now();
    let base_structs_and_functions = {let mut buf = String::new(); std::fs::File::open("./src_base_structs.rcsharp").unwrap().read_to_string(&mut buf).unwrap(); buf};
    let file1_read = Instant::now();
    let mut all_tokens = Lexer::new(&base_structs_and_functions).map(|x| 
        match x {
            Ok(x) => x,
            Err(err) => {eprintln!("ERROR: {} | Span: {:?} | Slice: {:?}", err,err.span,&base_structs_and_functions[err.span.clone()]); exit(-1)},
        }
    ).collect::<Vec<_>>();
    let file1_lexed = Instant::now();
    let src = {let mut buf = String::new(); std::fs::File::open("./src.rcsharp").unwrap().read_to_string(&mut buf).unwrap(); buf};
    let file2_read = Instant::now();
    for x in Lexer::new(&src) {
        match x {
            Ok(x) => all_tokens.push(x),
            Err(err) => {eprintln!("ERROR: {} | Span: {:?} | Slice: {:?}", err,err.span,&src[err.span.clone()]); exit(-1)},
        }
    }
    let file2_lexed = Instant::now();

    let y = GeneralParser::new(&all_tokens).parse_all();
    if let Err(err) = y {
        eprintln!("{}",err);
        return Err(());
    };
    let tokens_parsed = Instant::now();
    let y = y.unwrap();
    
    if let Err(err) = rcsharp_compile_to_file(&y) {
        eprintln!("{}",err);
        return Err(());
    };
    let compiled_and_wrote = Instant::now();
    println!("\t\tBase structs");
    println!("read \t{:?}", file1_read - program_start);
    println!("lexed\t{:?}", file1_lexed - file1_read);
    println!("\t\tSource");
    println!("read \t{:?}", file2_read - file1_lexed);
    println!("lexed\t{:?}", file2_lexed - file2_read);
    println!("\t\tBoth");
    println!("tokens\t{:?}", all_tokens.len());
    println!("lex spd\t{:?}ns/per token", ((file2_lexed - file2_read).as_nanos() + (file1_lexed - file1_read).as_nanos()) / all_tokens.len() as u128);
    println!("\npars\t{:?}", tokens_parsed - file2_lexed);
    println!("pars\t{:?}ns/per token", ((tokens_parsed - file2_lexed).as_nanos()) / all_tokens.len() as u128);
    println!("pars\t{:?} statements", y.iter().map(|x| x.recursive_statement_count()).sum::<u64>());
    println!("pars\t{:?} top level statements", y.len());
    println!("compil\t{:?}", compiled_and_wrote - tokens_parsed);
    return Ok(());
}


