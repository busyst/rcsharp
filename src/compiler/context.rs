use std::{cell::RefCell, path::PathBuf};

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
    pub strings_header: RefCell<Vec<StringEntry>>,
}
#[derive(Default)]
pub struct CompilerConfig {
    pub optimization_level: u8,
    pub include_paths: Vec<PathBuf>,
    pub emit_debug_info: bool,
    pub no_lazy_compile: bool,
    pub target_triple: String,
}
#[derive(Debug, Default)]
pub struct SourceManager {
    pub files: Vec<SourceFile>,
    pub total_len: usize,
}
pub type FileID = usize;
impl SourceManager {
    pub fn get_file_handle(&self, path: &str) -> FileID {
        self.files.iter().position(|x| x.path == path).unwrap() + 1
    }
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
impl CompilerContext {
    pub fn add_to_strings_header_(&self, string: &str) -> usize {
        let mut strings_header = self.strings_header.borrow_mut();
        if let Some(id) = strings_header.iter().position(|entry| match entry {
            StringEntry::Owned(s) => s == &string,
            StringEntry::Suffix { content, .. } => content == &string,
        }) {
            return id;
        }

        let suffix_match = strings_header.iter().enumerate().find_map(|(idx, entry)| {
            let (existing_str, actual_parent_idx, base_offset) = match entry {
                StringEntry::Owned(s) => (s, idx, 0),
                StringEntry::Suffix {
                    parent_index,
                    byte_offset,
                    content,
                    ..
                } => (content, *parent_index, *byte_offset),
            };

            if existing_str.ends_with(&string) && existing_str.len() > string.len() {
                let offset_diff = existing_str.len() - string.len();
                let absolute_offset = base_offset + offset_diff;
                Some((actual_parent_idx, absolute_offset))
            } else {
                None
            }
        });

        if let Some((parent_index, byte_offset)) = suffix_match {
            let len_with_null = string.len() + 1;
            strings_header.push(StringEntry::Suffix {
                parent_index,
                byte_offset,
                length_with_null: len_with_null,
                content: string.to_string(),
            });
            return strings_header.len() - 1;
        }
        strings_header.push(StringEntry::Owned(string.to_string()));
        let new_index = strings_header.len() - 1;
        for i in 0..new_index {
            if let StringEntry::Owned(old_content) = &strings_header[i] {
                if string.ends_with(old_content) && string.len() > old_content.len() {
                    let offset = string.len() - old_content.len();
                    let len_with_null = old_content.len() + 1;
                    strings_header[i] = StringEntry::Suffix {
                        parent_index: new_index,
                        byte_offset: offset,
                        length_with_null: len_with_null,
                        content: old_content.clone(),
                    };
                }
            }
        }
        new_index
    }
}
#[derive(PartialEq)]
pub enum StringEntry {
    Owned(String),
    Suffix {
        parent_index: usize,
        byte_offset: usize,
        length_with_null: usize,
        content: String,
    },
}
