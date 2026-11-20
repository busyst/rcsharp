use std::{
    borrow::Cow,
    collections::HashMap,
    error::Error,
    num::{NonZeroU32, ParseFloatError, ParseIntError},
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
    pub const fn new(start: u32, end: u32) -> Self {
        Self { start, end }
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
impl Symbol {
    fn index(&self) -> usize {
        self.0.get() as usize - 1
    }
}
#[derive(Debug, Clone, Copy, Hash, PartialEq, Eq)]
pub struct Identifier {
    pub name: Symbol,
    pub span: Span,
}
#[derive(Default)]
pub struct Interner {
    strings: Vec<Box<str>>,
    map: HashMap<Box<str>, Symbol>,
}
impl Interner {
    pub fn new() -> Self {
        Self::default()
    }
    pub fn intern_string(&mut self, s: &str) -> Symbol {
        if let Some(&sym) = self.map.get(s) {
            return sym;
        }
        self.strings.push(s.into());
        let sym = Symbol(NonZeroU32::new(self.strings.len() as u32).unwrap());
        self.map.insert(s.into(), sym);
        sym
    }

    pub fn lookup(&self, s: &str) -> Option<Symbol> {
        self.map.get(s).copied()
    }
    #[inline]
    pub fn resolve(&self, sym: Symbol) -> &str {
        &self.strings[sym.index()]
    }
    #[inline]
    pub fn get(&self, sym: Symbol) -> &str {
        self.resolve(sym)
    }

    pub fn intern_integer(&mut self, num: &str) -> Symbol {
        let canon: Cow<str> = if num.bytes().any(|b| b == b'_' || b.is_ascii_uppercase()) {
            Cow::Owned(
                num.chars()
                    .filter(|&c| c != '_')
                    .map(|c| c.to_ascii_lowercase())
                    .collect(),
            )
        } else {
            Cow::Borrowed(num)
        };
        self.intern_string(&canon)
    }
    pub fn intern_decimal(&mut self, num: &str) -> Symbol {
        if num.contains('_') {
            let cleaned: String = num.chars().filter(|&c| c != '_').collect();
            self.intern_string(&cleaned)
        } else {
            self.intern_string(num)
        }
    }
    pub fn integer_value(&self, sym: Symbol) -> Result<i64, ParseIntError> {
        let s = self.resolve(sym);
        let (digits, radix) = match s.get(..2) {
            Some("0b") => (&s[2..], 2),
            Some("0o") => (&s[2..], 8),
            Some("0x") => (&s[2..], 16),
            _ => (s, 10),
        };
        i64::from_str_radix(digits, radix)
    }

    pub fn decimal_value(&self, sym: Symbol) -> Result<f64, ParseFloatError> {
        self.resolve(sym).parse()
    }
}
#[derive(Debug, PartialEq, Eq)]
pub enum DiagnosticType {
    Info,
    Warning,
    Error,
    Fatal,
}
#[allow(dead_code)]
#[derive(Debug)]
pub struct Diagnostic {
    pub kind: DiagnosticType,
    pub source_file: SourceFile,
    message: String,
    span: Span,
    err: Option<Box<dyn Error>>,
}
impl Diagnostic {
    pub fn fatal(
        file: &SourceFile,
        msg: &str,
        err: impl std::error::Error + 'static,
    ) -> Diagnostic {
        Diagnostic {
            kind: DiagnosticType::Fatal,
            source_file: file.clone(),
            message: msg.to_string(),
            span: Span { start: 0, end: 0 },
            err: Some(Box::new(err)),
        }
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
    pub fn error_w_error(
        file: &SourceFile,
        msg: &str,
        span: Span,
        err: impl std::error::Error + 'static,
    ) -> Diagnostic {
        Diagnostic {
            kind: DiagnosticType::Error,
            source_file: file.clone(),
            message: msg.to_string(),
            span,
            err: Some(Box::new(err)),
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Hash, Default)]
pub struct CompilerPath(pub Box<[Symbol]>);
impl CompilerPath {
    pub fn single(sym: Symbol) -> Self {
        Self(Box::new([sym]))
    }

    #[inline]
    pub fn last(&self) -> Option<Symbol> {
        self.0.last().copied()
    }

    pub fn extended(&self, with: Symbol) -> Self {
        let mut temp = Vec::with_capacity(self.0.len() + 1);
        temp.extend_from_slice(&self.0);
        temp.push(with);
        Self(temp.into_boxed_slice())
    }

    pub fn extended_slice(&self, with: &[Symbol]) -> Self {
        let mut temp = Vec::with_capacity(self.0.len() + with.len());
        temp.extend_from_slice(&self.0);
        temp.extend_from_slice(with);
        Self(temp.into_boxed_slice())
    }
}
impl From<Symbol> for CompilerPath {
    fn from(sym: Symbol) -> Self {
        Self::single(sym)
    }
}
