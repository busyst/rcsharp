use crate::{parser::ParserVariableType, tokens::Tokens};

#[derive(Debug, Clone, PartialEq)]
pub enum Instruction {
    FunctionCreation { name: String, return_type: ParserVariableType, arguments: Vec<(String,ParserVariableType)>, body: Vec<Instruction>},
    FunctionCall { name: String, arguments: Vec<(Tokens, (u32, u32))>},
    MacroCall { name: String, arguments: Vec<(Tokens, (u32, u32))>},
    IfElse { condition: Vec<(Tokens, (u32, u32))>, if_body: Vec<Instruction>, else_body: Option<Vec<Instruction>> },
    Return { expression: Vec<(Tokens, (u32, u32))> },

    Operation { operation: Vec<(Tokens,(u32,u32))> },
    Loop { body: Vec<Instruction> },
    Break,
    Continue,

    VariableDeclaration { name: String, _type: ParserVariableType, expression: Vec<(Tokens,(u32,u32))> },
    StructDeclaration { name: String, fields: Vec<(String,ParserVariableType)>},
}
