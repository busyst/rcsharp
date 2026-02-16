use std::time::Instant;

use crate::compiler::base::compile_to_file;
pub mod compiler;
pub mod compiler_essentials;
pub mod compiler_functions;
pub mod expression_compiler;
pub mod tests;
fn main() -> Result<(), ()> {
    let full_path = std::env::args()
        .nth(1)
        .unwrap_or("./src.rcsharp".to_string());
    let output_full_path = std::env::args().nth(2).unwrap_or("./output.ll".to_string());
    let program_start = Instant::now();

    if let Err(err) = compile_to_file(full_path.as_str(), &output_full_path) {
        eprintln!("{}", err.error);
        return Err(());
    }
    let compiled_and_wrote = Instant::now();
    println!("compil\t{:?}", compiled_and_wrote - program_start);
    Ok(())
}
