
/*
use std::{path, process::Command};
pub fn generate_lib_with_dlltool(dll_path: &str, lib_path: &str) -> Result<(), String> {
    let name = path::Path::new(dll_path).file_stem().unwrap().to_str().unwrap().to_string() + ".def";
    // 3. Call llvm-dlltool to generate the .lib file
    // You might need to specify the full path to llvm-dlltool.exe
    let output = Command::new("./gendef")
    .arg("-f")
    .arg(dll_path)
    .output()?;
        if !output.status.success() {
        return Err(for!(
            "gendef failed: {}",
            String::from_utf8_lossy(&output.stderr)
        ));
    }
    let output = Command::new("llvm-dlltool")
        .arg("-m")
        .arg("i386:x86-64")
        .arg("-D")
        .arg(dll_path)
        .arg("-d")
        .arg(name)
        .arg("-l")
        .arg(lib_path)
        .output()?;

    if !output.status.success() {
        return Err(anyhow::anyhow!(
            "llvm-dlltool failed:
            err:{}
            out:{}",
            String::from_utf8_lossy(&output.stderr),
            String::from_utf8_lossy(&output.stdout),
        ));
    }
    println!("Successfully generated {:?}", lib_path);
    Ok(())
}

*/