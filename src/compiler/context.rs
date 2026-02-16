use std::path::PathBuf;

use rcsharp_parser::parser::Span;

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
#[derive(Default)]
pub struct SourceManager {
    files: Vec<SourceFile>,
    total_len: usize,
}

impl SourceManager {
    /// Adds a file to the source manager.
    /// Should be called by ModuleLoaderPass when a file is read.
    pub fn add_file(&mut self, path: &str, content: String, start_offset: usize) {
        let len = content.len();
        let end_offset = start_offset + len;

        // Pre-calculate line start positions for fast lookups later
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

    /// Resolves a Span to a location string (File:Line:Col)
    pub fn get_debug_loc(&self, span: &Span) -> String {
        if let Some((file, line, col)) = self.resolve_span(span.start) {
            format!("{}:{}:{}", file.path, line, col)
        } else {
            format!("unknown location (offset {})", span.start)
        }
    }

    /// Gets the actual source code snippet for a specific span
    pub fn get_source_slice(&self, span: &Span) -> Option<&str> {
        let file = self.find_file(span.start)?;

        // Localize the offsets
        let local_start = span.start.checked_sub(file.start_offset)?;
        let local_end = span.end.checked_sub(file.start_offset)?;

        if local_start <= local_end && local_end <= file.content.len() {
            Some(&file.content[local_start..local_end])
        } else {
            None
        }
    }

    /// Resolves a global byte offset to (FileReference, LineNumber, ColumnNumber)
    /// Line and Column are 1-based.
    fn resolve_span(&self, global_offset: usize) -> Option<(&SourceFile, usize, usize)> {
        let file = self.find_file(global_offset)?;

        let local_offset = global_offset - file.start_offset;

        // Binary search to find the line number
        let line_idx = match file.line_starts.binary_search(&local_offset) {
            Ok(idx) => idx,      // Exact match (start of line)
            Err(idx) => idx - 1, // Within the previous line
        };

        let line_start_index = file.line_starts[line_idx];
        let column = local_offset - line_start_index + 1;
        let line = line_idx + 1;

        Some((file, line, column))
    }

    fn find_file(&self, global_offset: usize) -> Option<&SourceFile> {
        // Find which file contains this offset.
        // Since offsets are strictly increasing, we can look for the file
        // where start_offset <= global_offset < end_offset
        self.files
            .iter()
            .find(|f| global_offset >= f.start_offset && global_offset < f.end_offset)
    }
}
struct SourceFile {
    path: String,
    /// The source code content
    content: String,
    /// The global start offset of this file in the virtual token stream
    start_offset: usize,
    /// The global end offset
    end_offset: usize,
    /// Indices of the start of each line within the `content`
    line_starts: Vec<usize>,
}
