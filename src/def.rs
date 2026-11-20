use rcsharp_syntax::Symbol;

// ------------------------------------ Memory
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Layout {
    pub size: u64,
    pub align: u64,
}
impl Layout {
    pub const INVALID: Layout = Layout { size: 0, align: 0 };
    pub const fn new(size: u64, align: u64) -> Layout {
        return Layout { size, align };
    }
}
// ------------------------------------ Id's
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
pub struct VariableID(pub u32);
impl VariableID {
    pub fn next_id(&mut self) -> Self {
        let current = *self;
        self.0 += 1;
        current
    }
}
#[derive(Debug, Clone, Copy, PartialEq)]
pub struct RegisterID(u32);
impl RegisterID {
    pub const fn new(id: u32) -> Self {
        Self { 0: id }
    }
    pub fn next_register(&mut self) -> Self {
        let current = *self;
        self.0 += 1;
        current
    }
}

// ------------------------------------ Compiler Type
#[derive(Debug, Clone, PartialEq)]
pub enum TypeImplementationEntry {
    Normal(TypeIndex),
    Enum(usize),
    Pointered {
        base: CompTypeImplementationIndex,
        pointered: u8,
    },
    GenericImplementation {
        base: TypeIndex,
        implementation: Box<[CompTypeImplementationIndex]>,
    },
    Function {
        arguments: Box<[CompTypeImplementationIndex]>,
        return_type: CompTypeImplementationIndex,
    },
    ConstantSizeArray {
        base: CompTypeImplementationIndex,
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

#[derive(Debug, Clone, Copy, PartialEq)]
pub struct TypeIndex(pub usize);
impl TypeIndex {
    pub const fn as_index(&self) -> usize {
        return self.0;
    }
}
#[derive(Debug, Clone, Copy, PartialEq)]
pub struct CompTypeImplementationIndex(usize);
impl CompTypeImplementationIndex {
    pub const fn new(id: usize) -> Self {
        Self { 0: id }
    }
    pub const fn index(&self) -> usize {
        return self.0;
    }
}

// ------------------------------------ Instructions
#[derive(Debug, Clone)]
pub enum CompilerIR {
    DeclareVariable {
        id: VariableID,
        var_type: CompTypeImplementationIndex,
    },
    DeclareStatic {
        name: Symbol,
        id: u64,
        var_type: CompTypeImplementationIndex,
    },
    DeclareConstant {
        name: Symbol,
        var_type: CompTypeImplementationIndex,
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
    Register(RegisterID),
    Variable(VariableID),
    Static(u64),
    Constant(u64),
    Integer(Symbol),
    Boolean(bool),
    Decimal(Symbol),
    Char(char),
    StringConst(Symbol),
    NullPtr,
    Type(CompTypeImplementationIndex),
}
// ------------------------------------ const Rvalue
#[derive(Debug, Clone, Copy)]
pub enum ConstantValue {
    Char(char),
    Boolean(bool),
    Integer(i64),
    Decimal(f64),
    StringConst(Symbol),
}
