use crate::compiler::SymbolTable;
use rcsharp_parser::defs::Expr;
use rcsharp_syntax::Symbol;
use std::ops::Add;

// ------------------------------------ Indexes and id's
#[derive(Debug, Clone, Copy, PartialEq)]
pub struct VariableID(pub u32);
impl VariableID {
    pub fn next_id(&mut self) -> Self {
        let current = *self;
        self.0 += 1;
        current
    }
}

#[derive(Debug, Clone, Copy, PartialEq)]
pub struct LabelID(u32);
impl LabelID {
    pub const fn new(id: u32) -> Self {
        Self { 0: id }
    }
    pub fn next_id(&mut self) -> Self {
        let current = *self;
        self.0 += 1;
        current
    }
}
#[derive(Debug, Clone, Copy, PartialEq)]
pub struct CompilerTypeImplementationIndex(usize);
impl CompilerTypeImplementationIndex {
    pub const fn new(id: usize) -> Self {
        Self { 0: id }
    }
    pub const fn as_index(&self) -> usize {
        return self.0;
    }
}
// ------------------------------------ Instructions
#[derive(Debug, Clone)]
pub enum CompilerIR {
    DeclareVariable {
        id: VariableID,
        var_type: CompilerTypeImplementationIndex,
    },
    DeclareStatic {
        name: Symbol,
        id: VariableID,
        var_type: CompilerTypeImplementationIndex,
    },
    DeclareConstant {
        name: Symbol,
        var_type: CompilerTypeImplementationIndex,
        expr: ConstantValue,
    },

    Test(ReferenceTo),
    Label(LabelID),
    JumpTo(LabelID),
    JumpToIf(LabelID),
    JumpToIfNot(LabelID),

    Assign(ReferenceTo, ReferenceTo),
    PresentResult(ReferenceTo),
    ExitBody,
    CompilerCall {
        operation: &'static str,
        result: ReferenceTo,
        arguments: Box<[ReferenceTo]>,
    },
}
// ------------------------------------ Reference (or Rvalue)
#[derive(Debug, Clone, Copy)]
pub enum ReferenceTo {
    Register(u64),
    Variable(VariableID),
    Static(u64),
    Constant(u64),
    Integer(Symbol),
    Boolean(bool),
    Decimal(Symbol),
    Char(char),
    StringConst(Symbol),
    NullPtr,
    Type(CompilerTypeImplementationIndex),
}
// ------------------------------------ const Rvalue
#[derive(Debug, Clone, Copy)]
pub enum ConstantValue {
    Integer(i64),
    Decimal(f64),
    StringConst(Symbol),
}
impl ConstantValue {
    pub fn increment(&self) -> ConstantValue {
        match self {
            ConstantValue::Integer(i) => ConstantValue::Integer(i.wrapping_add(1)),
            ConstantValue::Decimal(d) => ConstantValue::Decimal(d.add(1.0)),
            ConstantValue::StringConst(..) => panic!("Cannot increment string constant"),
        }
    }
    pub fn from_expression(
        expr: &Expr,
        _path: &CompilerPath,
        _symbol_table: &mut SymbolTable,
    ) -> Self {
        match expr {
            Expr::Integer(i) => {
                ConstantValue::Integer(_symbol_table.interner.integer_value(*i).unwrap())
            }
            _ => ConstantValue::Integer(0),
        }
    }
}
// ------------------------------------ target of call (Lvalue)
#[derive(Debug, Clone, Copy)]
pub enum CallTo {
    Register(u64),
}
// ------------------------------------ Type related
#[derive(Debug, Clone, Copy, PartialEq)]
pub struct TypeIndex(pub usize);
impl TypeIndex {
    pub const fn as_index(&self) -> usize {
        return self.0;
    }
}
// ------------------------------------ Compiler type
#[derive(Debug, Clone, PartialEq)]
pub enum TypeImplementationEntry {
    Normal(TypeIndex),
    Enum(usize),
    Pointered {
        base: CompilerTypeImplementationIndex,
        pointered: u8,
    },
    GenericImplementation {
        base: TypeIndex,
        implementation: Box<[CompilerTypeImplementationIndex]>,
    },
    Function {
        arguments: Box<[CompilerTypeImplementationIndex]>,
        return_type: CompilerTypeImplementationIndex,
    },
    ConstantSizeArray {
        base: CompilerTypeImplementationIndex,
        size: u64,
    },
    GenericParameter(usize),
}
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum TypeType {
    Normal,
    Generic,
    Compiler(&'static str),
}
// ------------------------------------ Compiler path
#[derive(Debug, Clone, PartialEq, Default)]
pub struct CompilerPath(pub Box<[Symbol]>);
impl CompilerPath {
    pub fn extended(&self, with: Symbol) -> Self {
        let mut temp = self.0.to_vec();
        temp.push(with);
        return Self(temp.into_boxed_slice());
    }
    pub fn extended_slice(&self, with: &[Symbol]) -> Self {
        let mut temp = self.0.to_vec();
        temp.extend_from_slice(with);
        return Self(temp.into_boxed_slice());
    }
}
