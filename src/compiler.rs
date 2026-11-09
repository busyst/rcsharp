use std::{
    cell::Cell,
    collections::HashSet,
    num::{NonZeroU64, NonZeroU8},
    path::{Path, PathBuf},
};

use rcsharp_lexer::{defs::LexerSymbolIndex, lex_file, LexerSymbolTable};
use rcsharp_parser::{
    compiler_primitives::Layout,
    defs::{
        Stmt::{self, ConstLet, Enum, Function, Namespace, StaticLet, Struct},
        StmtData,
    },
    expression_parser::Expr,
    parser::{self, ParserType},
};

use crate::CompilationArgs;
pub struct CompilationState {}
impl CompilationState {
    pub fn empty() -> CompilationState {
        CompilationState {}
    }
}
pub fn compile_to_file(args: &CompilationArgs) -> CompilationState {
    let mut result = CompilationState::empty();
    let mut lexer_symbol_table = LexerSymbolTable::new();
    let mut compiled_files = HashSet::new();
    let mut statements = vec![];

    lex_and_parse_files(
        args.input.as_ref().unwrap(),
        &mut lexer_symbol_table,
        &mut compiled_files,
        &mut statements,
        &mut result,
    );
    let filled_symbol_table = fill_symbol_table(
        &mut statements,
        CompilerPath { data: vec![] },
        lexer_symbol_table,
    );
    println!("Types: {}", filled_symbol_table.type_vector.len());
    println!(
        "Implementations: {}",
        filled_symbol_table.type_implementation_vector.len()
    );
    return result;
}

fn lex_and_parse_files(
    file_path: &str,
    lexer_symbol_table: &mut LexerSymbolTable,
    compiled_files: &mut HashSet<String>,
    statements: &mut Vec<StmtData>,
    _: &mut CompilationState,
) -> CompilationState {
    let initial_path = std::fs::canonicalize(file_path)
        .unwrap_or_else(|_| PathBuf::from(file_path))
        .to_string_lossy()
        .trim_start_matches(r"\\?\")
        .to_string();

    let mut queue = vec![initial_path.clone()];
    compiled_files.insert(initial_path);

    while let Some(path) = queue.pop() {
        let current_dir = Path::new(&path).parent().unwrap_or_else(|| Path::new(""));

        let mut tokens = vec![];
        lex_file(&path, &mut tokens, lexer_symbol_table).unwrap();
        let all = parser::GeneralParser::new(&tokens, &lexer_symbol_table)
            .parse_all()
            .unwrap();

        for mut x in all {
            if let Stmt::CompilerHint(hint) = x.stmt {
                if lexer_symbol_table.get(hint.name) == "include" {
                    if let Some(Expr::StringConst(inc_path)) = hint.arguments.get(0) {
                        let target = Path::new(lexer_symbol_table.get(*inc_path));

                        let combined = if target.is_absolute() {
                            target.to_path_buf()
                        } else {
                            current_dir.join(target)
                        };

                        let full_path = std::fs::canonicalize(&combined)
                            .unwrap_or(combined)
                            .to_string_lossy()
                            .trim_start_matches(r"\\?\")
                            .to_string();

                        if !compiled_files.contains(&full_path) {
                            compiled_files.insert(full_path.clone());
                            queue.push(full_path);
                        }
                    }
                }
                x.stmt = Stmt::CompilerDud;
            }
            statements.push(x);
        }
    }

    CompilationState::empty()
}

pub type CompilerTypeImplementationIndex = usize;
pub type LabelID = u32;
#[derive(Debug)]
pub enum CompilerIR {
    DeclareVariable {
        name: LexerSymbolIndex,
        var_type: CompilerTypeImplementationIndex,
    },
    DeclareStatic {
        name: LexerSymbolIndex,
        var_type: CompilerTypeImplementationIndex,
    },
    DeclareConstant {
        name: LexerSymbolIndex,
        var_type: CompilerTypeImplementationIndex,
        expr: Expr,
    },
    Evaluate(Expr),
    Test(Expr),
    Label(LabelID),
    JumpTo(LabelID),
    JumpToIf(LabelID),
    JumpToIfNot(LabelID),
    ExitBody,
}
pub enum FunctionTypeAssociation {
    Compiler(fn(CompilerTypeImplementationIndex, &mut Vec<CompilerIR>)),
}
#[derive(Debug, Clone, PartialEq)]
pub struct CompilerPath {
    data: Vec<LexerSymbolIndex>,
}
#[derive(Debug, Clone, PartialEq)]
enum TypeImplementationEntry {
    Normal(usize),
    Enum(usize),
    Pointered {
        base: usize,
        pointered: NonZeroU8,
    },
    GenericImplementation {
        base: usize,
        implementation: Box<[usize]>,
    },
    Function {
        arguments: Box<[usize]>,
        return_type: usize,
    },
    ConstantSizeArray {
        base: usize,
        size: NonZeroU64,
    },
    GenericParameter(usize),
}
struct TypeVectorEntry {
    llvm_signature: String,
    members: Vec<(LexerSymbolIndex, CompilerTypeImplementationIndex)>,
    associated_functions: Vec<(String, FunctionTypeAssociation)>,
    path: CompilerPath,
    layout: Layout,
}
struct FunctionVectorEntry {
    argument_name_types: Box<[(LexerSymbolIndex, CompilerTypeImplementationIndex)]>,
    return_type: CompilerTypeImplementationIndex,
    path: CompilerPath,
    llvm_signature: String,
    body: Box<[CompilerIR]>,
}
struct EnumVectorEntry {
    base_type: CompilerTypeImplementationIndex,
    path: CompilerPath,
    asscoiated_functions: Vec<(String, FunctionTypeAssociation)>,
    fields: Box<[(LexerSymbolIndex, Option<Expr>)]>,
}
struct StaticOrConstantVariableEntry {
    var_type: CompilerTypeImplementationIndex,
    path: CompilerPath,
    expression: Option<Expr>,
    is_static: bool,
}
#[derive(Default)]
struct SymbolTable {
    type_vector: Vec<TypeVectorEntry>,
    type_implementation_vector: Vec<TypeImplementationEntry>,
    function_vector: Vec<FunctionVectorEntry>,
    enum_vector: Vec<EnumVectorEntry>,
    var_vector: Vec<StaticOrConstantVariableEntry>,
    generic_indexes: Vec<LexerSymbolIndex>,
    lexer: LexerSymbolTable,
}

fn fill_symbol_table(
    statements: &mut Vec<StmtData>,
    path: CompilerPath,
    lexer_symbol_table: LexerSymbolTable,
) -> SymbolTable {
    let mut table: SymbolTable = default_symbol_table(lexer_symbol_table);

    for x in statements.iter() {
        fill_symbol_table_from_statement_part_1(x, &mut table, &path);
    }
    for x in statements.iter() {
        fill_symbol_table_from_statement_part_2(x, &mut table, &path);
    }
    statements.clear();

    table
}
// Fills paths only, everything else default
fn fill_symbol_table_from_statement_part_1(
    statement: &StmtData,
    table: &mut SymbolTable,
    path: &CompilerPath,
) {
    match &statement.stmt {
        Namespace(x, y) => {
            let mut np = path.clone();
            np.data.push(*x);
            for x in y {
                fill_symbol_table_from_statement_part_1(x, table, &np);
            }
        }
        Struct(ps) => {
            let mut struct_path = path.clone();
            struct_path.data.push(ps.name);
            table.type_vector.push(TypeVectorEntry {
                llvm_signature: String::new(),
                members: vec![],
                associated_functions: vec![],
                path: struct_path,
                layout: Layout::INVALID,
            });
        }
        Function(ps) => {
            let mut function_path = path.clone();
            function_path.data.push(ps.name);
            table.function_vector.push(FunctionVectorEntry {
                llvm_signature: String::new(),
                path: function_path,
                return_type: 0,
                argument_name_types: vec![].into_boxed_slice(),
                body: vec![].into_boxed_slice(),
            });
        }
        Enum(ps) => {
            let mut enum_path = path.clone();
            enum_path.data.push(ps.name);
            table.enum_vector.push(EnumVectorEntry {
                base_type: 0,
                fields: vec![].into_boxed_slice(),
                asscoiated_functions: vec![],
                path: enum_path,
            });
        }
        StaticLet(ps) => {
            let mut var_path = path.clone();
            var_path.data.push(ps.name);
            table.var_vector.push(StaticOrConstantVariableEntry {
                var_type: 0,
                path: var_path,
                expression: None,
                is_static: true,
            });
        }
        ConstLet(ps) => {
            let mut var_path = path.clone();
            var_path.data.push(ps.name);
            table.var_vector.push(StaticOrConstantVariableEntry {
                var_type: 0,
                path: var_path,
                expression: None,
                is_static: false,
            });
        }
        _ => {}
    }
}
// Fills types of functions and enums and members of other structs, along with types of constant and static fields.
fn fill_symbol_table_from_statement_part_2(
    statement: &StmtData,
    table: &mut SymbolTable,
    path: &CompilerPath,
) {
    match &statement.stmt {
        Namespace(x, y) => {
            let mut np = path.clone();
            np.data.push(*x);
            for x in y {
                fill_symbol_table_from_statement_part_2(x, table, &np);
            }
        }
        Struct(ps) => {
            if !ps.generic_params.is_empty() {
                for p in &ps.generic_params {
                    table.generic_indexes.push(p.name);
                }
            }
            let mut struct_path = path.clone();
            struct_path.data.push(ps.name);
            let struct_index = table
                .type_vector
                .iter()
                .position(|x| x.path == struct_path)
                .unwrap();
            for m in ps.members.iter() {
                let ii = get_impl_index_struct(&m.1, path, table).unwrap();
                let type_entry = &mut table.type_vector[struct_index];
                type_entry.members.push((m.0, ii));
            }
            table.generic_indexes.clear();
            // llvm_signature: String::new()
            //    layout: Layout::INVALID,
            // Attributes, prefixes, and generic params
        }
        Function(ps) => {
            if !ps.generic_params.is_empty() {
                for p in &ps.generic_params {
                    table.generic_indexes.push(p.name);
                }
            }
            let mut function_path = path.clone();
            function_path.data.push(ps.name);
            let func_index = table
                .function_vector
                .iter()
                .position(|x| x.path == function_path)
                .unwrap();

            if let Some(x) = &ps.return_type {
                let ii = get_impl_index_struct(&x, path, table).unwrap();
                table.function_vector[func_index].return_type = ii;
            } else {
                table.function_vector[func_index].return_type = 0;
            }
            let mut args = vec![];
            for x in &ps.args {
                args.push((
                    x.0.clone(),
                    get_impl_index_struct(&x.1, path, table).unwrap(),
                ));
            }
            table.function_vector[func_index].argument_name_types = args.into_boxed_slice();
            let mut fscope = FunctionScope::default();
            fscope.current_label.set(2);
            fscope.entry_label = 0;
            fscope.exit_label = 1;
            fscope.return_label = 1;
            let mut fbody = vec![];
            fbody.push(CompilerIR::Label(0));
            stmts_to_ir(&ps.body, path, table, &fscope, &mut fbody);
            fbody.push(CompilerIR::Label(1));
            fbody.push(CompilerIR::ExitBody);

            table.function_vector[func_index].body = fbody.into_boxed_slice();

            table.generic_indexes.clear();

            // Attributes, prefixes, and generic params
        }
        Enum(ps) => {
            let mut enum_path = path.clone();
            enum_path.data.push(ps.name);
            let enum_index = table
                .enum_vector
                .iter()
                .position(|x| x.path == enum_path)
                .unwrap();

            if let Some(x) = &ps.enum_type {
                let ii = get_impl_index_struct(&x, path, table).unwrap();
                table.enum_vector[enum_index].base_type = ii;
            } else {
                table.enum_vector[enum_index].base_type = 0;
            }
            table.enum_vector[enum_index].fields = ps.fields.clone();
            // Attributes and prefixes
        }
        StaticLet(ps) => {
            let mut var_path = path.clone();
            var_path.data.push(ps.name);
            let var_index = table
                .var_vector
                .iter()
                .position(|x| x.path == var_path)
                .unwrap();
            table.var_vector[var_index].var_type =
                get_impl_index_struct(&ps.var_type, path, table).unwrap();
            // Attributes and prefixes
        }
        ConstLet(ps) => {
            let mut var_path = path.clone();
            var_path.data.push(ps.name);
            let var_index = table
                .var_vector
                .iter()
                .position(|x| x.path == var_path)
                .unwrap();
            table.var_vector[var_index].var_type =
                get_impl_index_struct(&ps.var_type, path, table).unwrap();
            // Attributes and prefixes
        }
        _ => {}
    }
}
#[derive(Debug, Default, Clone)]
struct FunctionScope {
    current_label: Cell<LabelID>,
    entry_label: LabelID,
    exit_label: LabelID,
    return_label: LabelID,
}
fn stmts_to_ir(
    body: &[StmtData],
    path: &CompilerPath,
    symbol_table: &mut SymbolTable,
    fscope: &FunctionScope,
    output: &mut Vec<CompilerIR>,
) {
    for x in body.iter() {
        match &x.stmt {
            Stmt::Let(var) => {
                output.push(CompilerIR::DeclareVariable {
                    name: var.name,
                    var_type: get_impl_index_struct(&var.var_type, path, symbol_table).unwrap(),
                });
                if let Some(expr) = &var.expr {
                    output.push(CompilerIR::Evaluate(Expr::Assign(
                        Box::new(Expr::Name(var.name)),
                        Box::new(expr.clone()),
                    )));
                }
            }
            Stmt::ConstLet(var) => {
                output.push(CompilerIR::DeclareConstant {
                    name: var.name,
                    var_type: get_impl_index_struct(&var.var_type, path, symbol_table).unwrap(),
                    expr: var.expr.clone().unwrap(),
                });
            }
            Stmt::StaticLet(var) => {
                output.push(CompilerIR::DeclareStatic {
                    name: var.name,
                    var_type: get_impl_index_struct(&var.var_type, path, symbol_table).unwrap(),
                });
                if let Some(expr) = &var.expr {
                    output.push(CompilerIR::Evaluate(Expr::Assign(
                        Box::new(Expr::Name(var.name)),
                        Box::new(expr.clone()),
                    )));
                }
            }
            Stmt::Return(e) => {
                if let Some(expr) = &e {
                    output.push(CompilerIR::Evaluate(expr.clone()));
                }
                output.push(CompilerIR::JumpTo(fscope.return_label));
            }
            Stmt::If(e, then_d, else_d) => {
                output.push(CompilerIR::Test(e.clone()));
                let block_else_entry = fscope.current_label.replace(fscope.current_label.get() + 1);
                let block_exit_label = fscope.current_label.replace(fscope.current_label.get() + 1);
                output.push(CompilerIR::JumpToIfNot(block_else_entry));
                let scope = fscope.clone();
                stmts_to_ir(then_d, path, symbol_table, &scope, output);
                fscope.current_label.set(scope.current_label.get());
                output.push(CompilerIR::JumpTo(block_exit_label));
                output.push(CompilerIR::Label(block_else_entry));
                let scope = fscope.clone();
                stmts_to_ir(else_d, path, symbol_table, &scope, output);
                fscope.current_label.set(scope.current_label.get());
                output.push(CompilerIR::Label(block_exit_label));
            }
            Stmt::WhileLoop(e, body) => {
                let block_entry = fscope.current_label.replace(fscope.current_label.get() + 1);
                let block_exit = fscope.current_label.replace(fscope.current_label.get() + 1);
                output.push(CompilerIR::Label(block_entry));
                output.push(CompilerIR::Test(e.clone()));
                output.push(CompilerIR::JumpToIfNot(block_exit));
                let mut scope = fscope.clone();
                scope.entry_label = block_entry;
                scope.exit_label = block_exit;
                stmts_to_ir(body, path, symbol_table, &scope, output);
                fscope.current_label.set(scope.current_label.get());
                output.push(CompilerIR::JumpTo(block_entry));
                output.push(CompilerIR::Label(block_exit));
            }
            Stmt::DoWhileLoop(e, body) => {
                let block_entry = fscope.current_label.replace(fscope.current_label.get() + 1);
                let block_cond = fscope.current_label.replace(fscope.current_label.get() + 1);
                let block_exit = fscope.current_label.replace(fscope.current_label.get() + 1);
                output.push(CompilerIR::Label(block_entry));

                let mut scope = fscope.clone();
                scope.entry_label = block_cond;
                scope.exit_label = block_exit;
                stmts_to_ir(body, path, symbol_table, &scope, output);
                fscope.current_label.set(scope.current_label.get());

                output.push(CompilerIR::Label(block_cond));
                output.push(CompilerIR::Test(e.clone()));
                output.push(CompilerIR::JumpToIf(block_entry));
                output.push(CompilerIR::Label(block_exit));
            }
            Stmt::Loop(body) => {
                let block_entry = fscope.current_label.replace(fscope.current_label.get() + 1);
                let block_exit = fscope.current_label.replace(fscope.current_label.get() + 1);
                output.push(CompilerIR::Label(block_entry));
                let mut scope = fscope.clone();
                scope.entry_label = block_entry;
                scope.exit_label = block_exit;
                stmts_to_ir(body, path, symbol_table, &scope, output);
                fscope.current_label.set(scope.current_label.get());
                output.push(CompilerIR::JumpTo(block_entry));
                output.push(CompilerIR::Label(block_exit));
            }
            Stmt::Block(body) => {
                let scope = fscope.clone();
                stmts_to_ir(body, path, symbol_table, &scope, output);
                fscope.current_label.set(scope.current_label.get());
            }

            Stmt::Expr(e) => output.push(CompilerIR::Evaluate(e.clone())),
            Stmt::Break => output.push(CompilerIR::JumpTo(fscope.exit_label)),
            Stmt::Continue => output.push(CompilerIR::JumpTo(fscope.entry_label)),
            _ => {}
        }
    }
}
fn get_impl_index_struct(
    parser_type: &ParserType,
    path: &CompilerPath,
    symbol_table: &mut SymbolTable,
) -> Option<CompilerTypeImplementationIndex> {
    fn return_format(
        tie: TypeImplementationEntry,
        symbol_table: &mut SymbolTable,
    ) -> CompilerTypeImplementationIndex {
        if let Some(struct_impl) = symbol_table
            .type_implementation_vector
            .iter()
            .position(|x| *x == tie)
        {
            return struct_impl;
        }
        let idx = symbol_table.type_implementation_vector.len();
        symbol_table.type_implementation_vector.push(tie);
        return idx;
    }
    match parser_type {
        ParserType::Named(lsi) => {
            if let Some(gen_parm_index) = symbol_table.generic_indexes.iter().position(|x| x == lsi)
            {
                return Some(return_format(
                    TypeImplementationEntry::GenericParameter(gen_parm_index),
                    symbol_table,
                ));
            }
            let mut concat_path = path.clone();
            concat_path.data.push(*lsi);
            if let Some(enum_index) = symbol_table
                .enum_vector
                .iter()
                .position(|x| x.path == concat_path)
            {
                return Some(return_format(
                    TypeImplementationEntry::Enum(enum_index),
                    symbol_table,
                ));
            }
            if let Some(enum_index) = symbol_table
                .enum_vector
                .iter()
                .position(|x| x.path.data.len() == 1 && x.path.data[0] == *lsi)
            {
                return Some(return_format(
                    TypeImplementationEntry::Enum(enum_index),
                    symbol_table,
                ));
            }

            if let Some(struct_index) = symbol_table
                .type_vector
                .iter()
                .position(|x| x.path == concat_path)
            {
                return Some(return_format(
                    TypeImplementationEntry::Normal(struct_index),
                    symbol_table,
                ));
            } else if let Some(struct_index) = symbol_table
                .type_vector
                .iter()
                .position(|x| x.path.data.len() == 1 && x.path.data[0] == *lsi)
            {
                return Some(return_format(
                    TypeImplementationEntry::Normal(struct_index),
                    symbol_table,
                ));
            };

            return None;
        }
        ParserType::Pointer(internal_type) => {
            let mut current_pointer = internal_type.as_ref();
            let mut pointered: u8 = 1;
            while let ParserType::Pointer(x) = current_pointer {
                if pointered == 255 {
                    todo!("Why?");
                }
                pointered += 1;
                current_pointer = x;
            }
            if let Some(base) = get_impl_index_struct(current_pointer, path, symbol_table) {
                return Some(return_format(
                    TypeImplementationEntry::Pointered {
                        base,
                        pointered: NonZeroU8::try_from(pointered).unwrap(),
                    },
                    symbol_table,
                ));
            }
            return None;
        }
        ParserType::NamespaceLink(top_link, internal_type) => {
            let mut data = vec![*top_link];
            let mut current_pointer = internal_type.as_ref();
            while let ParserType::NamespaceLink(x, iitype) = current_pointer {
                data.insert(0, *x);
                current_pointer = iitype;
            }
            if let ParserType::Generic(lsi, arguments) = current_pointer {
                let args = arguments
                    .iter()
                    .map(|x| get_impl_index_struct(x, path, symbol_table))
                    .collect::<Option<Box<[usize]>>>()?;
                let mut path = data.clone();
                path.push(*lsi);
                if let Some(base) = symbol_table
                    .type_vector
                    .iter()
                    .position(|x| x.path.data == path)
                {
                    return Some(return_format(
                        TypeImplementationEntry::GenericImplementation {
                            base,
                            implementation: args,
                        },
                        symbol_table,
                    ));
                }
                return None;
            }
            let mut extend = path.data.clone();
            extend.extend(data.iter());

            if let Some(base) =
                get_impl_index_struct(current_pointer, &CompilerPath { data }, symbol_table)
            {
                return Some(base);
            }

            if let Some(base) = get_impl_index_struct(
                current_pointer,
                &CompilerPath { data: extend },
                symbol_table,
            ) {
                return Some(base);
            }
            return None;
        }
        ParserType::ConstantSizeArray(base_type, len) => {
            if let Some(base) = get_impl_index_struct(base_type, path, symbol_table) {
                return Some(return_format(
                    TypeImplementationEntry::ConstantSizeArray {
                        base,
                        size: NonZeroU64::try_from(*len).unwrap(),
                    },
                    symbol_table,
                ));
            }
            return None;
        }
        ParserType::Function(func_return, arguments) => {
            if let Some(return_type) = get_impl_index_struct(func_return, path, symbol_table) {
                if let Some(args) = arguments
                    .iter()
                    .map(|x| get_impl_index_struct(x, path, symbol_table))
                    .collect::<Option<Box<[usize]>>>()
                {
                    return Some(return_format(
                        TypeImplementationEntry::Function {
                            arguments: args,
                            return_type,
                        },
                        symbol_table,
                    ));
                }
            }

            return None;
        }
        ParserType::Generic(lsi, arguments) => {
            let mut concat_path = path.clone();
            concat_path.data.push(*lsi);
            let struct_index = symbol_table
                .type_vector
                .iter()
                .position(|x| x.path == concat_path)
                .or_else(|| {
                    symbol_table
                        .type_vector
                        .iter()
                        .position(|x| x.path.data.len() == 1 && x.path.data[0] == *lsi)
                })?;

            let args = arguments
                .iter()
                .map(|x| get_impl_index_struct(x, path, symbol_table))
                .collect::<Option<Box<[usize]>>>()?;

            return Some(return_format(
                TypeImplementationEntry::GenericImplementation {
                    base: struct_index,
                    implementation: args,
                },
                symbol_table,
            ));
        }
    }
}

fn default_symbol_table(lexer_symbol_table: LexerSymbolTable) -> SymbolTable {
    let mut table: SymbolTable = SymbolTable::default();
    table.lexer = lexer_symbol_table;

    for i in 0..GENERIC_PARAMETERS_COUNT {
        table.type_vector.push(TypeVectorEntry {
            llvm_signature: format!("{}", i),
            members: vec![],
            associated_functions: vec![],
            path: CompilerPath { data: vec![] },
            layout: Layout::new(0, 0),
        });
    }

    let primitives = [
        // (name, llvm_sig, size, align)
        ("void", "void", 0, 1),
        ("bool", "i1", 1, 1),
        ("i8", "i8", 1, 1),
        ("u8", "i8", 1, 1),
        ("i16", "i16", 2, 2),
        ("u16", "i16", 2, 2),
        ("i32", "i32", 4, 4),
        ("u32", "i32", 4, 4),
        ("i64", "i64", 8, 8),
        ("u64", "i64", 8, 8),
        ("isize", "i64", 8, 8),
        ("usize", "i64", 8, 8),
        ("f16", "half", 2, 2),
        ("f32", "float", 4, 4),
        ("f64", "double", 8, 8),
    ];
    for (index, (name, sig, size, align)) in primitives.iter().enumerate() {
        table.type_vector.push(TypeVectorEntry {
            llvm_signature: sig.to_string(),
            members: vec![],
            associated_functions: vec![],
            path: CompilerPath {
                data: vec![table.lexer.get_or_intern(name.to_string())],
            },
            layout: Layout::new(*size, *align),
        });
        table
            .type_implementation_vector
            .push(TypeImplementationEntry::Normal(
                GENERIC_PARAMETERS_COUNT as usize + index,
            ));
    }
    return table;
}

pub const GENERIC_PARAMETERS_COUNT: u8 = 16;
