use std::{iter::Zip, sync::Arc};

use crate::compiler_essentials::{CompilerType, LLVMVal};

pub const PATH_SECTION_SEPARATOR: &'static str = ".";
pub type ContextPathDictionaryIter<'a, T> =
    Zip<std::slice::Iter<'a, ContextPathEnd>, std::slice::Iter<'a, T>>;
pub type ContextPathDictionaryIterMut<'a, T> =
    Zip<std::slice::Iter<'a, ContextPathEnd>, std::slice::IterMut<'a, T>>;
#[derive(Debug)]
pub struct ContextPathDictionary<T> {
    keys: Vec<ContextPathEnd>,
    values: Vec<T>,
}

impl<T> ContextPathDictionary<T> {
    pub fn get(&self, entry_path: &ContextPathEnd) -> Option<&T> {
        self.keys
            .binary_search(entry_path)
            .ok()
            .map(|i| &self.values[i])
    }

    pub fn index_of(&self, entry_path: &ContextPathEnd) -> Option<usize> {
        self.keys.binary_search(entry_path).ok()
    }

    pub fn get_mut(&mut self, entry_path: &ContextPathEnd) -> Option<&mut T> {
        self.keys
            .binary_search(entry_path)
            .ok()
            .map(|i| &mut self.values[i])
    }
    // Indexes are not valid after insert
    pub fn insert(&mut self, entry_path: &ContextPathEnd, val: T) -> Option<T> {
        match self.keys.binary_search(entry_path) {
            Ok(index) => Some(std::mem::replace(&mut self.values[index], val)),
            Err(index) => {
                self.keys.insert(index, entry_path.clone());
                self.values.insert(index, val);
                None
            }
        }
    }
    pub fn iter(&self) -> ContextPathDictionaryIter<'_, T> {
        self.keys.iter().zip(self.values.iter())
    }

    pub fn iter_mut(&mut self) -> ContextPathDictionaryIterMut<'_, T> {
        self.keys.iter().zip(self.values.iter_mut())
    }

    pub fn values(&self) -> std::slice::Iter<'_, T> {
        self.values.iter()
    }

    pub fn len(&self) -> usize {
        self.values.len()
    }
}
impl<T> Default for ContextPathDictionary<T> {
    fn default() -> Self {
        Self {
            keys: Vec::new(),
            values: Vec::new(),
        }
    }
}
#[derive(Debug, Clone, Default, PartialEq, Eq, PartialOrd, Ord, Hash)]
pub struct ContextPath {
    path_sections: Vec<Arc<str>>,
}
impl ContextPath {
    pub fn new(path_sections: Vec<Arc<str>>) -> Self {
        Self { path_sections }
    }

    pub fn from_string(path: &str) -> ContextPath {
        if path.is_empty() {
            return Self::default();
        }
        Self {
            path_sections: path.split(PATH_SECTION_SEPARATOR).map(Arc::from).collect(),
        }
    }

    pub fn to_extended(&self, section: &str) -> ContextPath {
        let mut path_sections = self.path_sections.clone();
        path_sections.push(Arc::from(section));
        ContextPath { path_sections }
    }

    pub fn path_sections(&self) -> &[Arc<str>] {
        &self.path_sections
    }

    pub fn is_empty(&self) -> bool {
        self.path_sections.is_empty()
    }
}
impl std::fmt::Display for ContextPath {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        let mut iter = self.path_sections.iter();
        if let Some(first) = iter.next() {
            write!(f, "{}", first)?;
            for part in iter {
                write!(f, "{}{}", PATH_SECTION_SEPARATOR, part)?;
            }
        }
        Ok(())
    }
}

#[derive(Debug, Clone, Default, Eq, PartialEq, PartialOrd, Ord, Hash)]
pub struct ContextPathEnd {
    context_path: ContextPath,
    name: Arc<str>,
}

impl ContextPathEnd {
    pub fn new(context_path: ContextPath, name: Arc<str>) -> Self {
        Self { context_path, name }
    }
    pub fn from_end(name: &str) -> ContextPathEnd {
        Self {
            context_path: ContextPath::default(),
            name: Arc::from(name),
        }
    }
    pub fn from_path(current_path: &str, name: &str) -> ContextPathEnd {
        Self {
            context_path: ContextPath::from_string(current_path),
            name: Arc::from(name),
        }
    }
    pub fn from_full_path(fqp: &str) -> ContextPathEnd {
        if fqp.is_empty() {
            return Self::default();
        }
        let path_sections = fqp
            .split(PATH_SECTION_SEPARATOR)
            .map(Arc::from)
            .collect::<Vec<_>>();
        Self::from_vec(path_sections)
    }

    pub fn from_context_path(context_path: ContextPath, name: &str) -> ContextPathEnd {
        Self {
            context_path,
            name: Arc::from(name),
        }
    }

    pub fn from_vec(mut vec: Vec<Arc<str>>) -> ContextPathEnd {
        if vec.is_empty() {
            panic!("Moron");
        }

        // 7. Use pop instead of remove to avoid shifting memory
        let name = vec.pop().unwrap();

        Self {
            context_path: ContextPath::new(vec),
            name,
        }
    }

    pub fn with_start(&self, starting_with: &ContextPath) -> ContextPathEnd {
        if self.context_path.is_empty() {
            return ContextPathEnd {
                context_path: starting_with.clone(),
                name: self.name.clone(),
            };
        }

        let mut concatedinated = starting_with.path_sections.clone();
        concatedinated.extend_from_slice(&self.context_path.path_sections);

        Self {
            context_path: ContextPath::new(concatedinated),
            name: self.name.clone(),
        }
    }

    pub fn context_path(&self) -> &ContextPath {
        &self.context_path
    }

    pub fn name(&self) -> &str {
        &self.name
    }
}
impl std::fmt::Display for ContextPathEnd {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        if self.context_path.is_empty() {
            write!(f, "{}", self.name)
        } else {
            write!(
                f,
                "{}{PATH_SECTION_SEPARATOR}{}",
                self.context_path, self.name
            )
        }
    }
}
#[derive(Debug)]
pub enum LLVMInstruction {
    Store {
        value: LLVMVal,
        value_type: CompilerType,
        ptr: LLVMVal,
    },
    Load {
        target_reg: u32,
        ptr: LLVMVal,
        result_type: CompilerType,
    },
    GetElementPtr {
        target_reg: u32,
        base_type: CompilerType,
        ptr: LLVMVal,
        indices: Vec<(LLVMVal, CompilerType)>,
    },
    GetElementPtrExt {
        target_reg: u32,
        base_type: CompilerType,
        result_type: CompilerType,
        ptr: LLVMVal,
        indices: Vec<(LLVMVal, CompilerType)>,
    },
    BinaryOp {
        target_reg: u32,
        op: &'static str,
        op_type: CompilerType,
        lhs: LLVMVal,
        rhs: LLVMVal,
    },
    Cast {
        target_reg: u32,
        op: String,
        from_type: CompilerType,
        from_val: LLVMVal,
        to_type: CompilerType,
    },
    Call {
        target_reg: Option<u32>,
        callee: LLVMVal,
        args: Vec<(LLVMVal, CompilerType)>,
        result_type: CompilerType,
    },
    AllocateVar {
        target_reg: u32,
        alloc_type: CompilerType,
    },
    AllocateStack {
        target_reg: u32,
        alloc_type: CompilerType,
        count_type: CompilerType,
        count: LLVMVal,
    },
    Label {
        name: String,
    },
    Jump {
        label: String,
    },
    Phi {
        target_reg: u32,
        result_type: CompilerType,
        incoming: Vec<(LLVMVal, String)>,
    },
    Unreachable,
    Return {
        return_type: CompilerType,
        value: LLVMVal,
    },
    ReturnVoid,
    Debug(String),
    Branch {
        condition_val: LLVMVal,
        then_label_name: String,
        else_label_name: String,
    },
    Empty,
}

use crate::{compiler::expression::ExpressionCompileResult, compiler_essentials::CompilerError};

#[derive(Debug, Clone, PartialEq)]
pub enum Expected<'a> {
    Type(&'a CompilerType),
    Anything,
    NoReturn,
}

#[derive(Debug, Clone, PartialEq)]
pub enum CompiledValue {
    Value {
        llvm_repr: LLVMVal,
        val_type: CompilerType,
    },
    Function {
        internal_id: usize,
    },
    GenericFunction {
        internal_id: usize,
    },
    StructValue {
        fields: Box<[LLVMVal]>,
        val_type: CompilerType,
    },
    Type(CompilerType),
    NoReturn {
        program_halt: bool,
    },
}
impl CompiledValue {
    pub fn new_value(llvm_value: LLVMVal, value_type: CompilerType) -> CompiledValue {
        Self::Value {
            llvm_repr: llvm_value,
            val_type: value_type,
        }
    }
    pub fn as_literal_number(&self) -> Option<&i128> {
        if let CompiledValue::Value {
            llvm_repr: LLVMVal::ConstantInteger(val),
            ..
        } = self
        {
            return Some(val);
        }
        None
    }
    pub fn get_type(&self) -> Option<&CompilerType> {
        match self {
            Self::Value {
                val_type: ptype, ..
            } => Some(ptype),
            Self::StructValue {
                fields: _,
                val_type,
            } => Some(val_type),
            _ => None,
        }
    }
    pub fn try_get_llvm_rep(&self) -> ExpressionCompileResult<&LLVMVal> {
        match self {
            Self::Value { llvm_repr, .. } => Ok(llvm_repr),
            _ => Err(CompilerError::Generic(format!(
                "Value {:?} has no LLVM representation",
                self
            ))
            .into()),
        }
    }
    pub fn is_program_halt(&self) -> bool {
        match self {
            Self::NoReturn { program_halt, .. } => *program_halt,
            _ => false,
        }
    }
    pub fn with_type(self, value_type: CompilerType) -> Self {
        match self {
            Self::Value { llvm_repr, .. } => Self::Value {
                llvm_repr,
                val_type: value_type,
            },
            _ => todo!(),
        }
    }
}

impl<'a> Expected<'a> {
    pub fn get_type(&self) -> Option<&'a CompilerType> {
        match self {
            Self::Type(x) => Some(x),
            _ => None,
        }
    }
}

impl CompiledValue {
    pub fn get_llvm_rep(&self) -> &LLVMVal {
        match self {
            Self::Value { llvm_repr, .. } => llvm_repr,
            _ => panic!("{:?}", self),
        }
    }
    pub fn equal_type(&self, other: &CompilerType) -> bool {
        match self {
            Self::Value {
                val_type: ptype, ..
            } => ptype == other,
            Self::StructValue {
                val_type: ptype, ..
            } => ptype == other,
            _ => false,
        }
    }
}
