use std::path::Path;

use rcsharp_lexer::{lex_file, LexerSymbolTable};
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

        let main_file = Path::new(input);
        if !main_file.exists() {
            return Err(CompilerError::Generic("Main file was not found".to_string()).into());
        }

        let mut to_runn_throu = vec![std::path::absolute(main_file)
            .unwrap()
            .to_str()
            .unwrap()
            .to_string()];

        let mut runned_throu = vec![];
        let mut visited = std::collections::HashSet::new();
        let mut offset = 0;
        let mut symbol = LexerSymbolTable::new();
        while let Some(path) = to_runn_throu.pop() {
            if !visited.insert(path.clone()) {
                continue;
            }

            let file_data = std::fs::read_to_string(&path).unwrap();
            ctx.source_manager
                .add_file(&path, file_data.clone(), offset);
            offset += file_data.len();
            let mut lexed = vec![];
            match lex_file(&path, &mut lexed, &mut symbol) {
                Ok(()) => {}
                Err(err) => {
                    return Err(CompilerError::LexerError(path, err).into());
                }
            };
            let q = match rcsharp_parser::parser::GeneralParser::new(&lexed, &symbol)
                .parse_compiler_only()
            {
                Ok(x) => x,
                Err(err) => {
                    return Err(CompilerError::Generic(format!(
                        "Parsing error {}\nAt {}::",
                        err.1, path
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

                    let base_dir = Path::new(&path).parent().unwrap_or_else(|| Path::new(""));
                    let file = base_dir.join(include_path);

                    if !file.exists() {
                        return Err(CompilerError::Generic(format!(
                            "File {} was not found",
                            include_path
                        ))
                        .into());
                    }

                    to_runn_throu.push(
                        std::path::absolute(&file)
                            .unwrap()
                            .to_str()
                            .unwrap()
                            .to_string(),
                    );
                }
            }
            runned_throu.push((path, lexed));
        }

        for (_path, tokens) in runned_throu.iter() {
            let mut parse = match GeneralParser::new(tokens, &symbol).parse_all() {
                Ok(parse) => parse,
                Err(err) => {
                    let rc = ctx
                        .source_manager
                        .files
                        .iter()
                        .find(|x| x.path == *_path)
                        .map(|x| &x.content)
                        .unwrap();
                    return Err(CompilerError::Generic(format!(
                        "Parsing error {}\nAt {} {}",
                        err.1,
                        _path,
                        &rc[err.0.start..err.0.end]
                    ))
                    .into());
                }
            };
            stmt_vec.append(&mut parse);
        }
        Ok(stmt_vec)
    }
}
