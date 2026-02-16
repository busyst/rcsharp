use crate::{
    compiler::{
        context::CompilerContext,
        passes::{
            pass_llvm_gen::LLVMGenPass, pass_module_loader::ModuleLoaderPass,
            pass_optimizer::OptimizerPass, pass_type_check::TypeCheckPass, traits::CompilerPass,
        },
    },
    compiler_essentials::{CompileResult, CompilerError},
};

pub fn compile_to_file(entry_path: &str, output_path: &str) -> CompileResult<()> {
    let x = compile(entry_path)?;
    std::fs::write(output_path, x.1).unwrap();
    let diag = x.0.diagnostics;
    if diag.is_empty() {
        return Ok(());
    }
    Err(CompilerError::Generic(format!("{}", diag.len())).into())
}
pub fn compile(entry_path: &str) -> CompileResult<(CompilerContext, String)> {
    let mut ctx = CompilerContext::default();

    let mut loader = ModuleLoaderPass::default();
    let ast = loader.run(entry_path, &mut ctx)?;

    let mut type_checker = TypeCheckPass::default();
    type_checker.run(&ast, &mut ctx)?;
    let mut optimizer = OptimizerPass::default();
    optimizer.run((), &mut ctx)?;
    let mut codegen = LLVMGenPass::default();
    let llvm_ir = match codegen.run((), &mut ctx) {
        Ok(x) => x,
        Err(x) => {
            let x = if let Some(span) = x.span {
                let loc = ctx.source_manager.get_debug_loc(&span);
                let snippet = ctx.source_manager.get_source_slice(&span).unwrap_or("<?>");
                format!(
                    "Error at {} :\n    Code: {}\n    Message: {}",
                    loc, snippet, x.error
                )
            } else {
                format!("{:#?}", x.error)
            };
            println!("{}", x);
            return Err(CompilerError::Generic(format!("Error")).into());
        }
    };

    Ok((ctx, llvm_ir))
}
