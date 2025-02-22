use crate::{parser::ParserVariableType, tokens::Tokens};

/// Represents different types of executable instructions or language constructs
/// in the abstract syntax tree (AST). Each variant corresponds to a distinct
/// programming language construct with associated metadata and child instructions.
#[derive(Debug, Clone, PartialEq)]
pub enum Instruction {
    /**
     * 
     */
    CompilerHint {
        name: String,
        arguments: Vec<(Tokens,(u32,u32))>,
    },
    /**
     * Represents a function definition (declaration and implementation).
     * 
     * Example:
     * ```rust
     * fn foo(...) -> ... {
     *     ...
     * }
     * ```
     * 
     * Fields:
     * - `name`: Identifier name of the function
     * - `return_type`: The declared return type of the function
     * - `arguments`: Parameter list with (name, type) tuples representing function parameters
     * - `body`: Block of instructions comprising the function implementation
     */
    FunctionCreation {
        name: String,
        return_type: ParserVariableType,
        arguments: Vec<(String, ParserVariableType)>,
        body: Vec<Instruction>
    },

    /**
     * Represents a function invocation expression.
     * 
     * Example: `foo(...);`
     * Fields:
     * - `name`: Callee identifier
     * - `arguments`: Vector of argument expressions with source code positions.
     *   Each argument is preserved as tokens with (line, column) location information
     *   for error reporting and debugging purposes.
     */
    FunctionCall {
        name: String,
        arguments: Vec<(Tokens, (u32, u32))>
    },

    /**
     * Represents a macro invocation, similar to function call but with
        macro-specific semantics.
     */
    MacroCall {
        name: String,
        arguments: Vec<(Tokens, (u32, u32))>
    },

    /**
     * Conditional control flow construct with optional else block.
     * 
     * Example: `if x == 2 {...} else {...}`
     * Fields:
     * - `condition`: Token stream representing expression with source positions
     * - `if_body`: Instructions to execute if condition evaluates to true
     * - `else_body`: Optional block for else clause (`None` if no else block exists)
     */
    IfElse {
        condition: Vec<(Tokens, (u32, u32))>,
        if_body: Vec<Instruction>,
        else_body: Option<Vec<Instruction>>
    },

    /**
     * Return statement for exiting a function with optional value.
     * 
     * Examples: `return x + 2;`, `return;`
     * Fields:
     * - `expression`: Token stream representing return value expression with
     *   source positions. Empty vector indicates void return.
     */
    Return {
        expression: Option<Vec<(Tokens, (u32, u32))>>
    },

    /**
     * Generic operation/expression node for various computations.
     *
     * Examples: `a + b`, `a + (b == 2)`
     * Used for expressions, including:
     * - Arithmetic operations
     * - Assignment statements
     * - Boolean expressions
     * - Method chaining
     * 
     * Fields:
     * - `operation`: Token stream with source positions representing the operation
     */
    Operation {
        operation: Vec<(Tokens, (u32, u32))>
    },

    /**
     * Loop control structure representing an infinite loop.
     * Example: `loop {...}`
     * Field:
     * - `body`: Block of instructions to execute repeatedly
     */
    Loop {
        body: Vec<Instruction>
    },

    /// Breaks out of the nearest enclosing loop construct
    Break,

    /// Skips to next iteration of nearest enclosing loop
    Continue,

    /**
     * Variable declaration without initialization.
     * 
     * Example: `let x: u8;`
     * 
     * Fields:
     * - `name`: Variable identifier
     * - `_type`: Declared variable type
     */
    VariableDeclaration {
        name: String,
        _type: ParserVariableType
    },

    /**
     * Composite type declaration.
     * 
     * Example:
     * ```rust
     * struct Point {
     *     x: u16,
     *     y: u16
     * }
     * ```
     * 
     * Fields:
     * - `name`: Struct type identifier
     * - `fields`: Vector of (field_name, field_type) tuples
     */
    StructDeclaration {
        name: String,
        fields: Vec<(String, ParserVariableType)>
    },
}