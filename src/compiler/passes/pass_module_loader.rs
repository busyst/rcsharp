use rcsharp_lexer::{Lexer, LexingError};
use rcsharp_parser::{
    expression_parser::Expr,
    parser::{GeneralParser, StmtData},
};

use crate::{
    compiler::{context::CompilerContext, passes::traits::CompilerPass},
    compiler_essentials::{CompileResult, CompilerError},
};

#[derive(Default)]
pub struct ModuleLoaderPass {}
impl<'a> CompilerPass<'a> for ModuleLoaderPass {
    type Input = &'a str;

    type Output = Vec<StmtData>;

    fn run(
        &mut self,
        input: Self::Input,
        ctx: &mut CompilerContext,
    ) -> CompileResult<Self::Output> {
        let mut stmt_vec = vec![];

        let mut to_runn_throu = vec![input.to_string()];
        let mut runned_throu = vec![];
        let mut offset = 0;
        while let Some(path) = to_runn_throu.pop() {
            let file_data = std::fs::read_to_string(&path).unwrap();
            ctx.source_manager
                .add_file(&path, file_data.clone(), offset);
            let mut lexed = match Lexer::new(&file_data).collect::<Result<Vec<_>, LexingError>>() {
                Ok(x) => x,
                Err(err) => panic!(
                    "Lexing error at {}:{}:{} '{}'",
                    path,
                    err.row,
                    err.col,
                    &file_data[err.span.start..err.span.end]
                ),
            };
            let q = match rcsharp_parser::parser::GeneralParser::new(&lexed).parse_compiler_only() {
                Ok(x) => x,
                Err(err) => {
                    return Err(CompilerError::Generic(format!(
                        "Parsing error {}\nAt {}:{}:{}",
                        err.2, path, err.1 .0, err.1 .1
                    ))
                    .into());
                }
            };
            for (span, attr) in q.iter() {
                if attr.name_equals("include") {
                    let include_path_expr = attr.one_argument();
                    let Some(Expr::StringConst(include_path)) = include_path_expr else {
                        return Err((
                            span.clone(),
                            CompilerError::InvalidExpression(
                                "Include requires a string argument".into(),
                            ),
                        )
                            .into());
                    };
                    to_runn_throu.push(include_path.to_string());
                }
            }
            if offset != 0 {
                for x in lexed.iter_mut() {
                    x.span.start += offset;
                    x.span.end += offset;
                }
            }
            offset += lexed.len();
            runned_throu.push((path, lexed));
        }
        for (_path, tokens) in runned_throu.iter() {
            let mut parse = match GeneralParser::new(tokens).parse_all() {
                Ok(parse) => parse,
                Err(err) => {
                    return Err(CompilerError::Generic(format!(
                        "Parsing error {}\nAt {}:{}:{}",
                        err.2, _path, err.1 .0, err.1 .1
                    ))
                    .into());
                }
            };
            stmt_vec.append(&mut parse);
        }
        Ok(stmt_vec)
    }
}
