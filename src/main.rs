use std::{fs::File, io::Write, path::Path, process::Command};

use compiler::{clear, compile};
use instructions::Instruction;
use lexer::lex;
use parser::parse;


mod lexer;
mod tokens;
mod instructions;
mod parser;
mod compiler;
mod type_parsers;
pub const DEBUG: bool = true;

// implement complex return values


fn main() {
    if DEBUG {
        let tests = vec![
            ("1_basics", "basic_test"),
            ("2_arrays", "array_test"),
            ("3_structs", "struct_test"),
        ];
        for (dir, name) in tests {
            let path = format!("./tests/{}/{}.rsc", dir, name);
            let asm_out = format!("./tests/{}/{}.asm", dir, name);
            compile_file(&path, &asm_out);
            test(&asm_out);
        }
    }
    compile_file("./main.rcs","./main.asm");
}
fn test(file_path: &str) -> bool {
    // Check if the file exists
    if !Path::new(file_path).exists() {
        eprintln!("Error: File '{}' does not exist.", file_path);
        return false;
    }

    // Assemble the file using NASM
    let output = Command::new("nasm")
        .arg("-f") // Specify output format
        .arg("bin") // 16-bit binary format
        .arg("-o") // Output file
        .arg("output.bin") // Temporary output file name
        .arg(file_path) // Input file
        .output()
        .expect("Failed to execute NASM");

    // Check if NASM succeeded
    if !output.status.success() {
        let error = String::from_utf8(output.stderr).expect("Invalid UTF-8");
        eprintln!("NASM Error: {}", error);
        return false;
    }

    // Check if the binary file was generated
    if !Path::new("output.bin").exists() {
        eprintln!("Error: Binary file was not generated.");
        return false;
    }

    // If the binary was generated, delete it
    if let Err(err) = std::fs::remove_file("output.bin") {
        eprintln!("Error deleting binary file: {}", err);
        return false;
    }

    println!("Test succeeded: Binary generated and deleted.");
    true
}
fn compile_file(path: &str,output: &str){
    let x = lex(std::fs::canonicalize(Path::new(path).to_str().unwrap()).unwrap().to_str().unwrap()).unwrap_or_else(|e| {
        eprintln!("Error during lexing: {}", e); 
        std::process::exit(1);
    });
    File::options().read(false).write(true).create(true).truncate(true).open("lexer_output.txt").unwrap().write(format!("{:?}",x).as_bytes()).unwrap();
    let y = parse(&x);
    File::options().read(false).write(true).create(true).truncate(true).open("parser_output.txt").unwrap().write(format!("{:?}",y).as_bytes()).unwrap();

    clear();
    compile(&y);
    if output != "./main.asm"{
        std::fs::copy(std::fs::canonicalize(Path::new("./main.asm").to_str().unwrap()).unwrap().to_str().unwrap(), Path::new(output).to_str().unwrap()).unwrap();
        std::fs::remove_file(std::fs::canonicalize(Path::new("./main.asm").to_str().unwrap()).unwrap().to_str().unwrap()).unwrap();
    }
}