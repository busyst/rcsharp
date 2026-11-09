use rcsharp_lexer::defs::{LexerSymbolIndex, Token};

use crate::{expression_parser::Expr, parser::ParserType};

pub(crate) type Span = std::ops::Range<usize>;

#[derive(Debug, Clone, PartialEq)]
pub enum ParserError {
    ExpectedSemicolon,
    UnexpectedToken {
        expected: String,
        found: Token,
    },
    UnexpectedTopLevelToken {
        found: String,
    },
    InvalidModifier {
        modifier: String,
        applicable_to: String,
    },
    AttributeError(String),
    ExpressionError(String),
    TypeError(String),
    Generic(String),
    ExpectedIdentifier,
    OrphanedAttributes,
    UnclosedBlock,
}

pub type ParserResult<T> = Result<T, (Span, ParserError)>;
#[derive(Debug, Clone, PartialEq)]
pub struct Attribute {
    pub name: LexerSymbolIndex,
    pub arguments: Box<[Expr]>,
    pub span: Span,
}
impl Attribute {
    pub fn one_argument(&self) -> Option<&Expr> {
        match self.arguments.as_ref() {
            [arg] => Some(arg),
            _ => None,
        }
    }
}
#[derive(Debug, Clone, PartialEq)]
pub struct GenericParam {
    pub name: LexerSymbolIndex,
    pub bounds: Vec<LexerSymbolIndex>,
}
#[derive(Debug, Clone, PartialEq)]
pub struct ParsedStruct {
    pub attributes: Box<[Attribute]>,
    pub name: LexerSymbolIndex,
    pub members: Box<[(LexerSymbolIndex, ParserType)]>,
    pub generic_params: Box<[GenericParam]>,
    pub prefixes: Box<[String]>,
}
#[derive(Debug, Clone, PartialEq)]
pub struct ParsedEnum {
    pub attributes: Box<[Attribute]>,
    pub name: LexerSymbolIndex,
    pub fields: Box<[(LexerSymbolIndex, Option<Expr>)]>,
    pub enum_type: Option<ParserType>,
    pub prefixes: Box<[String]>,
}
//#[derive(Debug, Clone, PartialEq)]
//pub struct ParsedTrait {
//    pub path: Box<str>,
//    pub attributes: Box<[Attribute]>,
//    pub name: Box<str>,
//    pub functions: Box<[ParsedFunction]>,
//    pub generic_params: Box<[GenericParam]>,
//    pub prefixes: Box<[String]>,
//}
//#[derive(Debug, Clone, PartialEq)]
//pub struct ParsedImplementation {
//    pub trait_name: Option<Box<ParserType>>,
//    pub implementing_for: Box<ParserType>,
//    pub path: Box<str>,
//    pub attributes: Box<[Attribute]>,
//    pub body: Box<[StmtData]>,
//    pub generic_params: Box<[GenericParam]>,
//    pub prefixes: Box<[String]>,
//}
#[derive(Debug, Clone, PartialEq)]
pub struct ParsedFunction {
    pub attributes: Box<[Attribute]>,
    pub name: LexerSymbolIndex,
    pub args: Box<[(LexerSymbolIndex, ParserType)]>,
    pub return_type: Option<ParserType>,
    pub body: Box<[StmtData]>,
    pub prefixes: Box<[String]>,
    pub generic_params: Box<[GenericParam]>,
}
#[derive(Debug, Clone, PartialEq)]
pub enum VarType {
    Stack,
    Static,
    Constant,
}
#[derive(Debug, Clone, PartialEq)]
pub struct ParsedVariable {
    pub attributes: Box<[Attribute]>,
    pub name: LexerSymbolIndex,
    pub var_type: ParserType,
    pub prefixes: Box<[String]>,
    pub expr: Option<Expr>,
    pub var_comp_type: VarType,
}
#[derive(Debug, Clone, PartialEq)]
pub enum Stmt {
    CompilerHint(Attribute),                      // #...
    Let(ParsedVariable),                          // let x : ...
    ConstLet(ParsedVariable),                     // const x : ...
    StaticLet(ParsedVariable),                    // static x : ...
    Expr(Expr),                                   // a = 1 + b
    If(Expr, Box<[StmtData]>, Box<[StmtData]>),   // if 1 == 1 {} `else `if` {}`
    Loop(Box<[StmtData]>),                        // loop { ... }
    WhileLoop(Expr, Box<[StmtData]>),             // while ... { ... }
    DoWhileLoop(Expr, Box<[StmtData]>),           // do { ... } while ...;
    ForLoop(Expr, Expr, Box<[StmtData]>),         // for ... in ... { ... }
    Break,                                        // break
    Continue,                                     // continue
    Return(Option<Expr>),                         // return ...
    Function(ParsedFunction),                     // fn foo(bar: i8, ...) ... { ... }
    Struct(ParsedStruct),                         // struct foo <T> { bar : i8, ... }
    Enum(ParsedEnum),                             // enum foo 'base_type' { bar = ..., ... }
    Namespace(LexerSymbolIndex, Box<[StmtData]>), // namespace foo { fn bar(...): ... {...} ... }
    //Impl(ParsedImplementation),                     // impl Foo { fn bar(...): ... {...} ...}
    //TraitDeclaration(ParsedTrait),                  // trait Foo { fn bar(...): ...; ... }
    Block(Box<[StmtData]>), // ; { ... }
    Debug(String),          // ; 'debug statement'
    CompilerDud,            // ; does absolutely nothing
}
impl Stmt {
    pub fn recursive_statement_count(&self) -> u64 {
        let one = 1;
        match self {
            Self::If(_, then_b, else_b) => {
                one + then_b
                    .iter()
                    .map(|x| x.stmt.recursive_statement_count())
                    .sum::<u64>()
                    + else_b
                        .iter()
                        .map(|x| x.stmt.recursive_statement_count())
                        .sum::<u64>()
            }
            Self::Namespace(_, body)
            | Self::Loop(body)
            | Self::WhileLoop(_, body)
            | Self::DoWhileLoop(_, body)
            | Self::ForLoop(_, _, body)
            | Self::Block(body) => {
                one + body
                    .iter()
                    .map(|x| x.stmt.recursive_statement_count())
                    .sum::<u64>()
            }
            //Self::Impl(imp) => {
            //    one + imp
            //        .body
            //        .iter()
            //        .map(|x| x.stmt.recursive_statement_count())
            //        .sum::<u64>()
            //}
            Self::Function(func) => {
                one + func
                    .body
                    .iter()
                    .map(|x| x.stmt.recursive_statement_count())
                    .sum::<u64>()
            }
            //Self::TraitDeclaration(tr) => {
            //    one + tr
            //        .functions
            //        .iter()
            //        .map(|f| {
            //            1 + f
            //                .body
            //                .iter()
            //                .map(|x| x.stmt.recursive_statement_count())
            //                .sum::<u64>()
            //        })
            //        .sum::<u64>()
            //}
            _ => one,
        }
    }

    pub fn with_dummy_span(self) -> StmtData {
        StmtData {
            stmt: self,
            span: 0..0,
        }
    }
}
#[derive(Debug, Clone, PartialEq)]
pub struct StmtData {
    pub stmt: Stmt,
    pub span: Span,
}
