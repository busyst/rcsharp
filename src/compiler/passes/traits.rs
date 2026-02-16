use crate::{compiler::context::CompilerContext, compiler_essentials::CompileResult};

pub trait CompilerPass<'a> {
    type Input;
    type Output;
    fn run(&mut self, input: Self::Input, ctx: &mut CompilerContext)
        -> CompileResult<Self::Output>;
}
