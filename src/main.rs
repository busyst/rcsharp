use crate::compiler::rcsharp_compile_to_file;
use rcsharp_lexer::lex_file_with_context;
use rcsharp_parser::parser::{GeneralParser, ParserResultExt};
use std::{io::Read, process, time::Instant};

pub mod compiler;
pub mod compiler_essentials;
pub mod expression_compiler;
pub mod tests;
fn main() -> Result<(), String> {
    let full_path = std::env::args()
        .nth(1)
        .unwrap_or("./src.rcsharp".to_string());
    let output_full_path = std::env::args().nth(2).unwrap_or("./output.ll".to_string());
    let program_start = Instant::now();
    let base_structs_and_functions = {
        let mut buf = String::new();
        std::fs::File::open(full_path.as_str())
            .map_err(|e| e.to_string())?
            .read_to_string(&mut buf)
            .map_err(|e| e.to_string())?;
        buf
    };
    let file1_read = Instant::now();
    let all_tokens = lex_file_with_context(&base_structs_and_functions, full_path.as_str())?;
    let file1_lexed = Instant::now();

    let y = GeneralParser::new(&all_tokens)
        .parse_all()
        .unwrap_error_extended(&all_tokens, &full_path)
        .map_err(|x| {
            println!("{}", x);
            String::new()
        })?;
    let tokens_parsed = Instant::now();

    rcsharp_compile_to_file(&y, full_path.as_str(), &output_full_path)
        .map_err(|mut err_str| {
            println!("SPAN:{:?}", err_str.span);
            if let Some(span) = err_str.span.clone() {
                let (start_row, start_column) =
                    (all_tokens[span.start].row, all_tokens[span.start].col);
                err_str.extend(&format!(
                    "Location {}:{}:{}",
                    full_path.as_str(),
                    start_row,
                    start_column
                ));
                println!("{}", err_str.error);
            } else {
                println!("{}", err_str.error);
            }
            process::exit(-1)
        })
        .unwrap();
    let compiled_and_wrote = Instant::now();
    println!("\t\tBase Source");
    println!("read \t{:?}", file1_read - program_start);
    println!("lexed\t{:?}", file1_lexed - file1_read);
    println!("tokens\t{:?}", all_tokens.len());
    println!(
        "lex spd\t{:?}ns/per token",
        ((file1_lexed - file1_read).as_nanos()) / all_tokens.len() as u128
    );
    println!("\npars\t{:?}", tokens_parsed - file1_lexed);
    println!(
        "pars\t{:?}ns/per token",
        ((tokens_parsed - file1_lexed).as_nanos()) / all_tokens.len() as u128
    );
    println!(
        "pars\t{:?} statements",
        y.iter()
            .map(|x| x.stmt.recursive_statement_count())
            .sum::<u64>()
    );
    println!("pars\t{:?} top level statements", y.len());
    println!("compil\t{:?}", compiled_and_wrote - tokens_parsed);
    Ok(())
}
