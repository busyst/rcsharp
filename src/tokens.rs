#[derive(Debug, Clone, PartialEq)]
pub enum Tokens {
    FnKeyword,
    CreateVariableKeyword,
    LoopKeyword,
    IfKeyword,
    ElseKeyword,
    BreakKeyword,
    ContinueKeyword,
    ReturnKeyword,
    String { string_content: Box<String> },
    Name { name_string: Box<String> },
    Number { number_as_string: Box<String> },

    LParen,   // (
    RParen,   // )
    LBrace,    // {
    RBrace,    // }
    LSQBrace,  // [
    RSQBrace,  // ]
    Colon,     // :
    Semicolon, // ;
    Comma, // ,
    Dot, // .

    Equal, // =

    ADD,   // +
    SUB,   // -
    MUL,   // *
    DIV,   // *
    MOD,   // %

    ADDEqual, // +=
    SUBEqual, // -=
    MULEqual, // *=
    DIVEqual, // /=
    MODEqual, // %=

    COMPEqual, // ==
    COMPNOTEqual, // !=
    COMPGreater, // >
    COMPLess, // <
    COMPEqualGreater, // >=
    COMPEqualLess, // <=

    Exclamation, // !
    Point, // ->
}
impl Tokens {
    pub fn is_operator(&self) -> bool {
        matches!(
            self,
            Tokens::ADD
                | Tokens::SUB
                | Tokens::MUL
                | Tokens::DIV
                | Tokens::MOD
                | Tokens::COMPEqual
                | Tokens::COMPNOTEqual
                | Tokens::COMPGreater
                | Tokens::COMPLess
                | Tokens::COMPEqualGreater
                | Tokens::COMPEqualLess
        )
    }
    pub fn precedence(&self) -> u8 {
        match self {
            Tokens::MUL | Tokens::DIV | Tokens::MOD => 3,
            Tokens::ADD | Tokens::SUB => 2,
            Tokens::COMPEqual
            | Tokens::COMPNOTEqual
            | Tokens::COMPGreater
            | Tokens::COMPLess
            | Tokens::COMPEqualGreater
            | Tokens::COMPEqualLess => 1,
            _ => 0,
        }
    }
}