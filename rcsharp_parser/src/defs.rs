use rcsharp_syntax::{CompilerPath, Span, Symbol};

#[derive(Debug, Clone, PartialEq)]
pub enum ParserType {
    Named(CompilerPath),
    Pointer(Box<ParserType>),
    Function(Box<ParserType>, Box<[ParserType]>),
    Generic(CompilerPath, Box<[ParserType]>),
    ConstantSizeArray(Box<ParserType>, u64),
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
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum Modifier {
    Public,
    Inline,
    ConstExpr,
    Extern,
}
#[derive(Debug, Clone, PartialEq)]
pub struct ParsedVariable {
    pub attributes: Box<[Attribute]>,
    pub name: Symbol,
    pub var_type: ParserType,
    pub prefixes: Box<[Modifier]>,
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
    pub prefixes: Box<[Modifier]>,
    pub generic_params: Box<[GenericParam]>,
}

#[derive(Debug, Clone, PartialEq)]
pub struct ParsedStruct {
    pub attributes: Box<[Attribute]>,
    pub name: Symbol,
    pub members: Box<[(Symbol, ParserType)]>,
    pub generic_params: Box<[GenericParam]>,
    pub prefixes: Box<[Modifier]>,
}

#[derive(Debug, Clone, PartialEq)]
pub struct ParsedEnum {
    pub attributes: Box<[Attribute]>,
    pub name: Symbol,
    pub fields: Box<[(Symbol, Option<Expr>)]>,
    pub enum_type: Option<ParserType>,
    pub prefixes: Box<[Modifier]>,
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
