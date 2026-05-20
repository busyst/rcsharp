use std::time::Instant;

use crate::compiler::passes::compile_to_file;
pub mod compiler;
pub mod compiler_essentials;
pub mod compiler_functions;
use clap::Parser;
#[derive(Parser, Debug)]
#[command(version, about, long_about = None)]
pub struct Args {
    #[arg(short, long)]
    input: Option<String>,
    #[arg(short, long)]
    output: Option<String>,
    #[arg(short = 'L', long)]
    is_library: bool,
    #[arg(short = 'D', long)]
    is_dynamic_library: bool,
    #[arg(short = 'E', long)]
    executable: bool,
}
fn main() -> Result<(), ()> {
    let mut args = Args::parse();
    args.input = Some(args.input.unwrap_or_else(|| format!("./src.rcsharp")));
    args.output = Some(args.output.unwrap_or_else(|| format!("./output.ll")));
    args.executable = true;
    let program_start = Instant::now();

    if let Err(err) = compile_to_file(&args) {
        eprintln!("{}", err.error);
        return Err(());
    }
    let compiled_and_wrote = Instant::now();
    println!("compil\t{:?}", compiled_and_wrote - program_start);
    Ok(())
}
