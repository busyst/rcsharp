use std::{
    collections::HashMap,
    error::Error,
    num::NonZeroU32,
    path::{Path, PathBuf},
    str::FromStr,
};

#[derive(Debug, Clone)]
pub struct SourceFile {
    pub path: PathBuf,
}
impl SourceFile {
    pub fn unspecified() -> Self {
        Self {
            path: PathBuf::new(),
        }
    }
    pub fn from_path_str(path: &str) -> Self {
        Self {
            path: PathBuf::from_str(path).unwrap(),
        }
    }
    pub fn enviroment_path(&self) -> &Path {
        self.path.parent().unwrap_or_else(|| Path::new(""))
    }
    pub fn absolute_path(&self) -> PathBuf {
        if self.path.is_absolute() {
            self.path.clone()
        } else {
            std::fs::canonicalize(&self.path).unwrap()
        }
    }
}

#[derive(Clone, Copy, PartialEq, Eq, Hash, Debug)]
pub struct Span {
    pub start: u32,
    pub end: u32,
}
impl Span {
    pub fn new(start: usize, end: usize) -> Self {
        Self {
            start: start.try_into().unwrap(),
            end: end.try_into().unwrap(),
        }
    }
    pub fn to(self, o: Span) -> Span {
        Span {
            start: self.start,
            end: o.end,
        }
    }
}

#[derive(Debug, Clone, Copy, Hash, PartialEq, Eq)]
pub struct Symbol(pub NonZeroU32);
#[derive(Default)]
pub struct Interner {
    strings: Vec<Box<str>>,
    map: HashMap<Box<str>, Symbol>,
}
impl Interner {
    pub fn new() -> Self {
        Self::default()
    }
    pub fn intern(&mut self, s: &str) -> Symbol {
        if let Some(&sym) = self.map.get(s) {
            return sym;
        }
        self.strings.push(s.into());
        let sym = Symbol(NonZeroU32::new(self.strings.len() as u32).unwrap());
        self.map.insert(s.into(), sym);
        sym
    }

    pub fn resolve(&self, sym: Symbol) -> &str {
        &self.strings[sym.0.get() as usize - 1]
    }
    pub fn get(&self, sym: Symbol) -> &str {
        self.resolve(sym)
    }

    pub fn intern_number(&mut self, num: &str) -> Symbol {
        if num.contains('_') {
            let cleaned = num.replace('_', "");
            self.intern(&cleaned)
        } else {
            self.intern(num)
        }
    }
}
pub enum DiagnosticType {
    Info,
    Warning,
    Error,
    Fatal,
}
pub struct Diagnostic {
    kind: DiagnosticType,
    source_file: SourceFile,
    message: String,
    span: Span,
    err: Option<Box<dyn Error>>,
}
impl Diagnostic {
    pub fn fatal(
        file: &SourceFile,
        msg: &str,
        err: impl std::error::Error + 'static,
    ) -> Vec<Diagnostic> {
        vec![Diagnostic {
            kind: DiagnosticType::Fatal,
            source_file: file.clone(),
            message: msg.to_string(),
            span: Span { start: 0, end: 0 },
            err: Some(Box::new(err)),
        }]
    }
    pub fn error(file: &SourceFile, msg: &str, span: Span) -> Diagnostic {
        Diagnostic {
            kind: DiagnosticType::Error,
            source_file: file.clone(),
            message: msg.to_string(),
            span,
            err: None,
        }
    }
}
