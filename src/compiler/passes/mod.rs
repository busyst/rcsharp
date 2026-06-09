use rcsharp_lexer::{lex_text, LexerSymbolTable};

use crate::{
    compiler::{
        context::{CompileOutputType, CompilerContext, ErrorSeverity},
        passes::{
            pass_llvm_gen::LLVMGenPass, pass_module_loader::ModuleLoaderPass,
            pass_optimizer::OptimizerPass, pass_type_check::TypeCheckPass, traits::CompilerPass,
        },
    },
    compiler_essentials::{CompileResult, CompilerError},
    Args,
};

pub mod pass_llvm_gen;
pub mod pass_module_loader;
pub mod pass_optimizer;
pub mod pass_type_check;
pub mod traits;

pub fn compile_to_file(args: &Args) -> CompileResult<()> {
    let (ctx, llvm_ir) = compile(args)?;
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
    std::fs::write(args.output.as_ref().unwrap(), llvm_ir)
        .map_err(|e| CompilerError::Generic(e.to_string()))?;
    Ok(())
}
pub fn compile(args: &Args) -> CompileResult<(CompilerContext, String)> {
    let mut ctx = CompilerContext::default();
    ctx.config.no_lazy_compile = true;
    if args.executable {
        ctx.config.compile_to = CompileOutputType::Executable;
    } else if args.is_dynamic_library {
        ctx.config.compile_to = CompileOutputType::DynamicLibrary;
    } else if args.is_library {
        ctx.config.compile_to = CompileOutputType::Library;
    } else {
        ctx.config.compile_to = CompileOutputType::None;
    }
    ctx.config.llvm_typeless_pointers = false;
    let mut loader = ModuleLoaderPass::default();
    let ast = loader.run(args.input.as_ref().unwrap(), &mut ctx)?;

    let mut type_checker = TypeCheckPass::default();
    type_checker.run(&ast, &mut ctx)?;
    let mut optimizer = OptimizerPass::default();
    optimizer.run((), &mut ctx)?;
    let mut codegen = LLVMGenPass::default();
    let llvm_ir = match codegen.run((), &mut ctx) {
        Ok(ir) => ir,
        Err(err) => {
            let mut message = String::new();
            message.push_str(&format!("{}\n", err.error));
            message.push_str("Stack Trace:\n");
            for (span, name) in &err.call_stack {
                message.push_str(&format!("At {}:{} {}\n", span.start, span.end, name));
            }
            if err.function_id != usize::MAX {
                let func = ctx.symbols.get_function_by_id(err.function_id);
                let file_id = func.file_id.clone();
                let file = &ctx.source_manager.files[file_id - 1];
                let mut tokens = vec![];
                let mut symbol_table = LexerSymbolTable::new();
                lex_text(&file.content, &mut tokens, &mut symbol_table).unwrap();
                let q = &tokens[err.call_stack.get(0).cloned().unwrap().0];
                let e = q.first().map(|x| x.span.start).unwrap_or(0);
                let r = q.last().map(|x| x.span.end).unwrap_or(0);
                println!("{:?}", &file.content[e..r]);
            }
            println!("{}", message);
            return Err(CompilerError::Generic("Codegen failed".into()).into());
        }
    };

    Ok((ctx, llvm_ir))
}
