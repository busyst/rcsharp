use std::time::Instant;
mod compiler;
use clap::Parser;

use crate::compiler::compile_to_file;
#[derive(Parser, Debug)]
#[command(version, about, long_about = None)]
pub struct CompilationArgs {
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
    let mut args = CompilationArgs::parse();
    args.input = Some(
        args.input
            .unwrap_or_else(|| format!("Z:/ActiveProjects/rcsharp_inf/src/src.rcsharp")),
    );
    args.output = Some(args.output.unwrap_or_else(|| format!("./output.ll")));
    args.executable = true;
    let program_start = Instant::now();

    let _comp_result = compile_to_file(&args);
    let compiled_and_wrote = Instant::now();
    println!("compil\t{:?}", compiled_and_wrote - program_start);
    Ok(())
}
