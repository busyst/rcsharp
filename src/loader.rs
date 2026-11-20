use std::{
    collections::HashSet,
    fs::read,
    path::{Path, PathBuf},
};

use rcsharp_lexer::Lexer;
use rcsharp_parser::{
    defs::{Expr, Stmt, StmtData},
    parse_full,
};
use rcsharp_syntax::{Diagnostic, Interner, SourceFile};

use crate::compiler::CompilationState;
pub struct ParsedFile(pub SourceFile, pub Vec<StmtData>);
impl CompilationState {
    pub fn load(
        &mut self,
        input_file_path: &str,
        interner: &mut Interner,
    ) -> Result<Vec<ParsedFile>, ()> {
        let initial_path = std::fs::canonicalize(input_file_path)
            .unwrap_or_else(|_| PathBuf::from(input_file_path))
            .to_string_lossy()
            .trim_start_matches(r"\\?\")
            .to_string();

        let mut output = vec![];
        let mut visited_paths = HashSet::new();
        let mut paths_to_visit = vec![initial_path];
        let mut major_fuck_up = false;
        while let Some(path) = paths_to_visit.pop() {
            visited_paths.insert(path.clone());
            let source_file = SourceFile::from_path_str(&path);
            let src_data = match read(&path) {
                Ok(data) => data,
                Err(err) => {
                    self.diagnostics.push(Diagnostic::fatal(
                        &source_file,
                        "Unable to read file",
                        err,
                    ));
                    continue;
                }
            };
            let src = match std::str::from_utf8(&src_data) {
                Ok(s) => s,
                Err(err) => {
                    self.diagnostics.push(Diagnostic::fatal(
                        &source_file,
                        "Unable to decode file in UTF-8 encoding",
                        err,
                    ));
                    break;
                }
            };
            let mut lexer = Lexer::new(src, interner);
            let (mut stmts, mut diag) = parse_full(&source_file, &mut lexer);
            self.diagnostics.append(&mut diag);
            major_fuck_up |= self.has_errors();
            let current_dir = source_file.enviroment_path();
            for x in stmts.iter_mut() {
                if let Stmt::CompilerHint(hint) = &x.stmt {
                    if interner.get(hint.name) == "include" {
                        if let Some(Expr::StringConst(inc_path)) = hint.arguments.get(0) {
                            let target = Path::new(interner.get(*inc_path));

                            let combined = if target.is_absolute() {
                                target.to_path_buf()
                            } else {
                                current_dir.join(target)
                            };

                            let full_path = std::fs::canonicalize(&combined)
                                .unwrap_or(combined)
                                .to_string_lossy()
                                .trim_start_matches(r"\\?\")
                                .to_string();

                            if !visited_paths.contains(&full_path) {
                                visited_paths.insert(full_path.clone());
                                paths_to_visit.push(full_path);
                            }
                        }
                    }
                    x.stmt = Stmt::CompilerDud;
                }
            }

            stmts.retain(|x| x.stmt != Stmt::CompilerDud);
            output.push(ParsedFile(source_file, stmts));
        }

        if major_fuck_up {
            return Err(());
        }
        Ok(output)
    }
}
