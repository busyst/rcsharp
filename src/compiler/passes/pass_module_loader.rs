use std::{collections::HashSet, path::Path};

use ordered_hash_map::OrderedHashMap;
use rcsharp_lexer::{lex_file, LexerSymbolTable};
use rcsharp_parser::{defs::StmtData, expression_parser::Expr, parser::GeneralParser};

use crate::{
    compiler::{
        context::{CompilerContext, FileID},
        passes::traits::CompilerPass,
    },
    compiler_essentials::{CompileResult, CompilerError},
};

#[derive(Default)]
pub struct ModuleLoaderPass {}
impl<'a> CompilerPass<'a> for ModuleLoaderPass {
    type Input = &'a str;

    type Output = OrderedHashMap<FileID, Vec<StmtData>>;

    fn run(
        &mut self,
        input: Self::Input,
        ctx: &mut CompilerContext,
    ) -> CompileResult<Self::Output> {
        let main_file = Path::new(input);
        if !main_file.exists() {
            return Err(CompilerError::Generic(format!(
                "Main file was not found on path:{}",
                input
            ))
            .into());
        }

        let mut to_runn_throu = vec![std::path::absolute(main_file)
            .unwrap()
            .to_str()
            .unwrap()
            .to_string()];

        let mut runned_throu = vec![];
        let mut visited = HashSet::new();
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
                    return Err(CompilerError::ParserError(path, err).into());
                }
            };
            let mut pending_includes = vec![];
            for (span, attr) in q.iter() {
                if attr.name_equals("include") {
                    let include_path_expr = attr.one_argument();
                    let Some(Expr::StringConst(include_path)) = include_path_expr else {
                        return Err((
                            span.clone(),
                            CompilerError::Generic("Include requires a string argument".into()),
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

                    pending_includes.push(
                        std::path::absolute(&file)
                            .unwrap()
                            .to_str()
                            .unwrap()
                            .to_string(),
                    );
                }
            }
            pending_includes.sort();
            for include_path in pending_includes.into_iter().rev() {
                to_runn_throu.push(include_path);
            }
            runned_throu.push((path, lexed));
        }

        runned_throu.sort_by(|a, b| a.0.cmp(&b.0));

        let mut stmt_vec = OrderedHashMap::new();
        for (path, tokens) in runned_throu.iter() {
            let parsed = match GeneralParser::new(tokens, &symbol).parse_all() {
                Ok(parse) => parse,
                Err(err) => {
                    return Err(CompilerError::ParserError(path.to_string(), err).into());
                }
            };
            match stmt_vec.insert(ctx.source_manager.get_file_handle(&path), parsed) {
                Some(x) => panic!("{:?}", x),
                None => {}
            }
        }
        Ok(stmt_vec)
    }
}
