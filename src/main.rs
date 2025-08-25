use std::{io::Read, time::Instant};
use crate::{compiler::rcsharp_compile_to_file, parser::GeneralParser, token::{Lexer, LexingError, TokenData}};

pub mod token;
pub mod expression_parser;
pub mod expression_compiler;
pub mod parser;
pub mod compiler;
pub mod compiler_essentials;
mod tests;

pub const ALLOW_EXTENTION_FUNCTIONS: bool = false;
pub const USE_MULTIPLY_AS_POINTER_IN_TYPES: bool = true;

fn lex_with_context(source: &str, filename: &str) -> Result<Vec<TokenData>, String> {
	Lexer::new(source)
		.collect::<Result<Vec<_>, LexingError>>()
		.map_err(|err| {
			let slice = &source[err.span.clone()];
			format!(
				"Lexing error in {} at row {}, col {} | Span: {:?} | Slice: {:?}",
				filename, err.loc.row, err.loc.col, err.span, slice
			)
		})
}

fn main() -> Result<(), String> {
	let args: Vec<_> = std::env::args().collect();
	if args.contains(&format!("-Q")) {
		let quick_source = {
			let mut buf = String::new();
			std::fs::File::open("./src.quick.rcsharp").map_err(|e| e.to_string())?.read_to_string(&mut buf).map_err(|e| e.to_string())?;
			buf
		};
		let quick = lex_with_context(&quick_source, "src.quick.rcsharp")?;
		let quick = GeneralParser::new(&quick).parse_all()?;
		rcsharp_compile_to_file(&quick)?;
		return Ok(());
	}
	//let dll_path = r#"c:\\Windows\\System32\\kernel32.dll"#;
	//let lib_path = "./kernel32.lib";
	//rcsharp::generate_lib_with_dlltool(&dll_path, &lib_path).unwrap();
	
	let program_start = Instant::now();
	let base_structs_and_functions = {let mut buf = String::new(); std::fs::File::open("./src_base_structs.rcsharp").map_err(|e| e.to_string())?.read_to_string(&mut buf).map_err(|e| e.to_string())?; buf};
	let file1_read = Instant::now();
	let mut all_tokens = lex_with_context(&base_structs_and_functions, "src_base_structs.rcsharp")?;
	let file1_lexed = Instant::now();
	let src = {let mut buf = String::new(); std::fs::File::open("./src.rcsharp").map_err(|e| e.to_string())?.read_to_string(&mut buf).map_err(|e| e.to_string())?; buf};
	let file2_read = Instant::now();
	let mut src_tokens = lex_with_context(&src, "src.rcsharp")?;
	all_tokens.append(&mut src_tokens);
	let file2_lexed = Instant::now();

	let y = GeneralParser::new(&all_tokens).parse_all()?;
	let tokens_parsed = Instant::now();
	
	rcsharp_compile_to_file(&y)?;
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


