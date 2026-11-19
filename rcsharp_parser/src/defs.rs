use rcsharp_syntax::{Span, Symbol};

#[derive(Debug, Clone)]
pub enum ParserType {
    Named(Symbol),
    Pointer(Box<ParserType>),
    Function(Box<ParserType>, Box<[ParserType]>),
    NamespaceLink(Symbol, Box<ParserType>),
    Generic(Symbol, Box<[ParserType]>),
    ConstantSizeArray(Box<ParserType>, u64),
}

impl PartialEq for ParserType {
    fn eq(&self, other: &Self) -> bool {
        let lhs = self.peel_namespace();
        let rhs = other.peel_namespace();
        match (lhs, rhs) {
            (Self::Named(l), Self::Named(r)) => l == r,
            (Self::Pointer(l), Self::Pointer(r)) => l == r,
            (Self::Function(lr, la), Self::Function(rr, ra)) => lr == rr && la == ra,
            (Self::Generic(ls, lt), Self::Generic(rs, rt)) => ls == rs && lt == rt,
            (Self::ConstantSizeArray(lt, ls), Self::ConstantSizeArray(rt, rs)) => {
                lt == rt && ls == rs
            }
            _ => false,
        }
    }
}

impl ParserType {
    pub fn as_pointer(&self) -> Option<&ParserType> {
        match self {
            ParserType::Pointer(x) => Some(x),
            _ => None,
        }
    }

    pub fn as_function(&self) -> Option<(&ParserType, &[ParserType])> {
        match self {
            ParserType::Function(r, a) => Some((r, a)),
            _ => None,
        }
    }

    pub fn as_generic(&self) -> Option<(&Symbol, &[ParserType])> {
        match self {
            ParserType::Generic(s, t) => Some((s, t)),
            _ => None,
        }
    }

    fn peel_namespace(&self) -> &Self {
        match self {
            Self::NamespaceLink(_, inner) => inner.peel_namespace(),
            other => other,
        }
    }
}

#[derive(Debug, Clone, PartialEq)]
pub struct Attribute {
    pub name: Symbol,
    pub arguments: Box<[Expr]>,
    pub span: Span,
}

#[derive(Debug, Clone, PartialEq)]
pub struct GenericParam {
    pub name: Symbol,
    pub bounds: Vec<Symbol>,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum VarType {
    Constant,
    Static,
    Stack,
}

#[derive(Debug, Clone, PartialEq)]
pub struct ParsedVariable {
    pub attributes: Box<[Attribute]>,
    pub name: Symbol,
    pub var_type: ParserType,
    pub prefixes: Box<[String]>,
    pub expr: Option<Expr>,
    pub var_comp_type: VarType,
}

#[derive(Debug, Clone, PartialEq)]
pub struct ParsedFunction {
    pub attributes: Box<[Attribute]>,
    pub name: Symbol,
    pub args: Box<[(Symbol, ParserType)]>,
    pub return_type: Option<ParserType>,
    pub body: Box<[StmtData]>,
    pub prefixes: Box<[String]>,
    pub generic_params: Box<[GenericParam]>,
}

#[derive(Debug, Clone, PartialEq)]
pub struct ParsedStruct {
    pub attributes: Box<[Attribute]>,
    pub name: Symbol,
    pub members: Box<[(Symbol, ParserType)]>,
    pub generic_params: Box<[GenericParam]>,
    pub prefixes: Box<[String]>,
}

#[derive(Debug, Clone, PartialEq)]
pub struct ParsedEnum {
    pub attributes: Box<[Attribute]>,
    pub name: Symbol,
    pub fields: Box<[(Symbol, Option<Expr>)]>,
    pub enum_type: Option<ParserType>,
    pub prefixes: Box<[String]>,
}

#[derive(Debug, Clone, PartialEq)]
pub struct StmtData {
    pub stmt: Stmt,
    pub span: Span,
}

#[derive(Debug, Clone, PartialEq)]
pub enum Stmt {
    Block(Box<[StmtData]>),
    Namespace(Symbol, Box<[StmtData]>),
    Function(ParsedFunction),
    Struct(ParsedStruct),
    Enum(ParsedEnum),
    Let(ParsedVariable),
    StaticLet(ParsedVariable),
    ConstLet(ParsedVariable),
    If(Expr, Box<[StmtData]>, Box<[StmtData]>),
    Loop(Box<[StmtData]>),
    WhileLoop(Expr, Box<[StmtData]>),
    DoWhileLoop(Expr, Box<[StmtData]>),
    ForLoop(Expr, Expr, Box<[StmtData]>),
    Return(Option<Expr>),
    Break,
    Continue,
    Expr(Expr),
    CompilerHint(Attribute),
    CompilerDud,
}

#[derive(Debug, Clone, PartialEq)]
pub enum Expr {
    Decimal(Symbol),
    Integer(Symbol),
    Char(char),
    Name(Symbol),
    StringConst(Symbol),
    Type(Box<ParserType>),

    BinaryOp(Box<Expr>, BinaryOp, Box<Expr>),
    UnaryOp(UnaryOp, Box<Expr>),
    Assign(Box<Expr>, Box<Expr>),

    Cast(Box<Expr>, Box<ParserType>),
    MemberAccess(Box<Expr>, Symbol),
    StaticAccess(Box<Expr>, Symbol),

    NameWithGenerics(Box<Expr>, Box<[ParserType]>),
    Call(Box<Expr>, Box<[Expr]>, Option<Box<[ParserType]>>),
    MemberCall(Box<Expr>, Symbol, Box<[Expr]>, Option<Box<[ParserType]>>),
    MacroCall(Box<Expr>, Box<[Expr]>),
    Index(Box<Expr>, Box<Expr>),

    Array(Box<[Expr]>),
    StructInit(Box<Expr>, Box<[(Symbol, Expr)]>),
    Range(Box<Expr>, Box<Expr>, bool),
    Boolean(bool),
    NullPtr,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum BinaryOp {
    Add,
    Subtract,
    Multiply,
    Divide,
    Modulo,
    Equals,
    NotEqual,
    Less,
    LessEqual,
    Greater,
    GreaterEqual,
    And,
    Or,
    BitAnd,
    BitOr,
    BitXor,
    ShiftLeft,
    ShiftRight,
}

impl BinaryOp {
    pub fn is_symmetric(self) -> bool {
        matches!(
            self,
            Self::Add
                | Self::Multiply
                | Self::BitAnd
                | Self::BitOr
                | Self::BitXor
                | Self::And
                | Self::Or
                | Self::Equals
                | Self::NotEqual
        )
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum UnaryOp {
    Negate,
    Not,
    BitNot,
    Deref,
    Pointer,
}
