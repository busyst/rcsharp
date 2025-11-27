use std::{io::Read, time::Instant};
use crate::{compiler::rcsharp_compile_to_file};
use rcsharp_lexer::{lex_file_with_context};
use rcsharp_parser::parser::GeneralParser;

pub mod expression_compiler;
pub mod compiler;
pub mod compiler_essentials;
pub mod tests;

pub const ALLOW_EXTENTION_FUNCTIONS: bool = false;
pub const USE_MULTIPLY_AS_POINTER_IN_TYPES: bool = true;


fn main() -> Result<(), String> {
	
	let full_path = "./src.rcsharp";
	let program_start = Instant::now();
	let base_structs_and_functions = {let mut buf = String::new(); std::fs::File::open(&full_path).map_err(|e| e.to_string())?.read_to_string(&mut buf).map_err(|e| e.to_string())?; buf};
	let file1_read = Instant::now();
	let all_tokens = lex_file_with_context(&base_structs_and_functions, &full_path)?;
	let file1_lexed = Instant::now();

	let y = GeneralParser::new(&all_tokens).parse_all()?;
	let tokens_parsed = Instant::now();
	
	rcsharp_compile_to_file(&y, &full_path)?;
	let compiled_and_wrote = Instant::now();
	println!("\t\tBase Source");
	println!("read \t{:?}", file1_read - program_start);
	println!("lexed\t{:?}", file1_lexed - file1_read);
	println!("tokens\t{:?}", all_tokens.len());
	println!("lex spd\t{:?}ns/per token", ((file1_lexed - file1_read).as_nanos()) / all_tokens.len() as u128);
	println!("\npars\t{:?}", tokens_parsed - file1_lexed);
	println!("pars\t{:?}ns/per token", ((tokens_parsed - file1_lexed).as_nanos()) / all_tokens.len() as u128);
	println!("pars\t{:?} statements", y.iter().map(|x| x.recursive_statement_count()).sum::<u64>());
	println!("pars\t{:?} top level statements", y.len());
	println!("compil\t{:?}", compiled_and_wrote - tokens_parsed);
	Ok(())
}


