use crate::{
    compiler::{
        context::{CompilerContext, ErrorSeverity},
        passes::{
            pass_llvm_gen::LLVMGenPass, pass_module_loader::ModuleLoaderPass,
            pass_optimizer::OptimizerPass, pass_type_check::TypeCheckPass, traits::CompilerPass,
        },
    },
    compiler_essentials::{CompileResult, CompilerError},
};

pub fn compile_to_file(entry_path: &str, output_path: &str) -> CompileResult<()> {
    let (ctx, llvm_ir) = compile(entry_path)?;
    let diag = &ctx.diagnostics;
    let error_count = diag
        .iter()
        .filter(|(sev, _)| matches!(sev, ErrorSeverity::Error | ErrorSeverity::Panic))
        .count();
    if error_count > 0 {
        for (_, err) in diag {
            eprintln!("{}", err);
        }
        return Err(CompilerError::Generic(format!(
            "Compilation failed with {} errors",
            error_count
        ))
        .into());
    }
    let warnings_count = diag
        .iter()
        .filter(|(sev, _)| matches!(sev, ErrorSeverity::Warning))
        .count();
    if warnings_count > 0 {
        for (_, err) in diag {
            eprintln!("{}", err);
        }
    }
    std::fs::write(output_path, llvm_ir).map_err(|e| CompilerError::Generic(e.to_string()))?;
    Ok(())
}
pub fn compile(entry_path: &str) -> CompileResult<(CompilerContext, String)> {
    let mut ctx = CompilerContext::default();
    ctx.config.no_lazy_compile = true;
    let mut loader = ModuleLoaderPass::default();
    let ast = loader.run(entry_path, &mut ctx)?;

    let mut type_checker = TypeCheckPass::default();
    type_checker.run(&ast, &mut ctx)?;
    let mut optimizer = OptimizerPass::default();
    optimizer.run((), &mut ctx)?;
    let mut codegen = LLVMGenPass::default();
    let llvm_ir = match codegen.run((), &mut ctx) {
        Ok(ir) => ir,
        Err(err) => {
            let error_msg = if let Some(_span) = err.span {
                format!(
                    "Error at {}:{{}}:{{}}\n    Message: {}",
                    ctx.source_manager.files[0].path, err.error
                )
            } else {
                format!("Error: {}", err.error)
            };
            ctx.diagnostics.push((
                ErrorSeverity::Error,
                CompilerError::Generic(error_msg.clone()),
            ));
            println!("{}", error_msg);
            return Err(CompilerError::Generic("Codegen failed".into()).into());
        }
    };

    Ok((ctx, llvm_ir))
}
