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
            let lexed = Lexer::new(&file_data).collect::<Result<Vec<_>, LexingError>>();
            let mut lexed = if let Ok(x) = lexed {
                x
            } else {
                let err = lexed.err().unwrap();

                panic!("{}", &file_data[err.span.start..err.span.end])
            };
            let q = rcsharp_parser::parser::GeneralParser::new(&lexed)
                .parse_compiler_only()
                .unwrap();
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
                    x.span.start = x.span.start + offset;
                    x.span.end = x.span.end + offset;
                }
            }
            offset = lexed.last().map(|x| x.span.end).unwrap_or(0);
            runned_throu.push((path, lexed));
        }
        for (_path, tokens) in runned_throu.iter() {
            let parse = GeneralParser::new(tokens).parse_all();

            let mut parse = if let Ok(parse) = parse {
                parse
            } else {
                let err = parse.err().unwrap();
                panic!("{:#?}", err.2)
            };
            stmt_vec.append(&mut parse);
        }
        Ok(stmt_vec)
    }
}
