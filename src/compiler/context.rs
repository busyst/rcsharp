use std::path::PathBuf;

use crate::compiler_essentials::{CompilerError, SymbolTable};
pub enum ErrorSeverity {
    Warning,
    Error,
    Panic,
}
#[derive(Default)]
pub struct CompilerContext {
    pub symbols: SymbolTable,
    pub config: CompilerConfig,
    pub source_manager: SourceManager,
    pub diagnostics: Vec<(ErrorSeverity, CompilerError)>,
}
#[derive(Default)]
pub struct CompilerConfig {
    pub optimization_level: u8,
    pub include_paths: Vec<PathBuf>,
    pub emit_debug_info: bool,
    pub target_triple: String,
}
#[derive(Debug, Default)]
pub struct SourceManager {
    pub files: Vec<SourceFile>,
    pub total_len: usize,
}

impl SourceManager {
    pub fn add_file(&mut self, path: &str, content: String, start_offset: usize) {
        let len = content.len();
        let end_offset = start_offset + len;

        let mut line_starts = vec![0];
        for (i, char) in content.char_indices() {
            if char == '\n' {
                line_starts.push(i + 1);
            }
        }

        self.files.push(SourceFile {
            path: path.to_string(),
            content,
            start_offset,
            end_offset,
            line_starts,
        });

        if end_offset > self.total_len {
            self.total_len = end_offset;
        }
    }
}
#[derive(Debug)]
pub struct SourceFile {
    pub path: String,
    pub content: String,
    pub start_offset: usize,
    pub end_offset: usize,
    pub line_starts: Vec<usize>,
}
