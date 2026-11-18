use std::{
    collections::HashSet,
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

use crate::{
    intermediate_representation::{
        CompilerIR, CompilerPath, CompilerTypeImplementationIndex, ConstantValue, LabelID,
        ReferenceTo, TypeImplementationEntry, TypeIndex, TypeType, VariableID,
    },
    llvm_ir_conversion::{write_all_statics, write_all_used_types, SignatureHolder},
    CompilationArgs,
};
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
    let filled_symbol_table =
        fill_symbol_table(&mut statements, CompilerPath::default(), lexer_symbol_table);
    statements.clear();
    println!("Types: {}", filled_symbol_table.type_vector.len());
    println!(
        "Implementations: {}",
        filled_symbol_table.type_implementation_vector.len()
    );
    let mut output = std::fs::OpenOptions::new()
        .create(true)
        .read(true)
        .write(true)
        .truncate(true)
        .open(args.output.clone().unwrap())
        .unwrap();
    let mut signatures = SignatureHolder::new(
        filled_symbol_table.type_implementation_vector.len(),
        filled_symbol_table.var_vector.len(),
        0,
    );
    write_all_used_types(
        &mut output,
        &mut signatures.type_signatures,
        &filled_symbol_table,
        true,
    );
    write_all_statics(&mut output, &mut signatures, &filled_symbol_table, true);

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

pub enum FunctionTypeAssociation {
    Compiler(fn(ReferenceTo, (ReferenceTo, CompilerTypeImplementationIndex), &mut Vec<CompilerIR>)),
}
pub struct TypeVectorEntry {
    pub members: Vec<(LexerSymbolIndex, CompilerTypeImplementationIndex)>,
    pub associated_functions: Vec<(String, FunctionTypeAssociation)>,
    pub path: CompilerPath,
    pub type_type: TypeType,
    pub layout: Layout,
}
pub struct FunctionVectorEntry {
    args: Box<[(LexerSymbolIndex, CompilerTypeImplementationIndex)]>,
    return_type: CompilerTypeImplementationIndex,
    path: CompilerPath,
    llvm_signature: String,
    body: Box<[CompilerIR]>,
    is_generic: bool,
}
pub struct EnumVectorEntry {
    pub base_type: CompilerTypeImplementationIndex,
    path: CompilerPath,
    associated_functions: Vec<(String, FunctionTypeAssociation)>,
    fields: Box<[(LexerSymbolIndex, ConstantValue)]>,
}
pub struct StaticOrConstantVariableEntry {
    pub var_type: CompilerTypeImplementationIndex,
    pub path: CompilerPath,
    pub expression: Option<Expr>,
    pub is_static: bool,
}
#[derive(Default)]
pub struct SymbolTable {
    pub type_vector: Vec<TypeVectorEntry>,
    pub type_implementation_vector: Vec<TypeImplementationEntry>,
    pub function_vector: Vec<FunctionVectorEntry>,
    pub enum_vector: Vec<EnumVectorEntry>,
    pub var_vector: Vec<StaticOrConstantVariableEntry>,
    pub generic_indexes: Vec<LexerSymbolIndex>,
    pub lexer: LexerSymbolTable,
}

fn fill_symbol_table(
    statements: &[StmtData],
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
            let extended_path = path.extended(*x);
            for x in y {
                fill_symbol_table_from_statement_part_1(x, table, &extended_path);
            }
        }
        Struct(ps) => {
            table.type_vector.push(TypeVectorEntry {
                members: vec![],
                associated_functions: vec![],
                path: path.extended(ps.name),
                layout: Layout::INVALID,
                type_type: TypeType::Normal,
            });
        }
        Function(ps) => {
            table.function_vector.push(FunctionVectorEntry {
                llvm_signature: String::new(),
                path: path.extended(ps.name),
                return_type: VOID_TYPE_ID,
                args: vec![].into_boxed_slice(),
                body: vec![].into_boxed_slice(),
                is_generic: false,
            });
        }
        Enum(ps) => {
            table.enum_vector.push(EnumVectorEntry {
                base_type: VOID_TYPE_ID,
                fields: vec![].into_boxed_slice(),
                associated_functions: vec![],
                path: path.extended(ps.name),
            });
        }
        StaticLet(ps) => {
            table.var_vector.push(StaticOrConstantVariableEntry {
                var_type: VOID_TYPE_ID,
                path: path.extended(ps.name),
                expression: None,
                is_static: true,
            });
        }
        ConstLet(ps) => {
            table.var_vector.push(StaticOrConstantVariableEntry {
                var_type: VOID_TYPE_ID,
                path: path.extended(ps.name),
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
            let extended_path = path.extended(*x);
            for x in y {
                fill_symbol_table_from_statement_part_2(x, table, &extended_path);
            }
        }
        Struct(ps) => {
            if !ps.generic_params.is_empty() {
                if ps.generic_params.len() >= GENERIC_PARAMETERS_COUNT {
                    println!(
                        "Amount of arguments of struct {:?} exeeds max({})\tSkipped.",
                        ps, GENERIC_PARAMETERS_COUNT
                    );
                    return;
                }
                for p in &ps.generic_params {
                    table.generic_indexes.push(p.name);
                }
            }
            let struct_path = path.extended(ps.name);
            let struct_index = table
                .type_vector
                .iter()
                .position(|x| x.path == struct_path)
                .unwrap();
            table.type_vector[struct_index].type_type = if ps.generic_params.is_empty() {
                TypeType::Normal
            } else {
                TypeType::Generic
            };
            for (member_name, member_type) in ps.members.iter() {
                let ii = get_impl_index_struct(&member_type, path, table).unwrap();
                let type_entry = &mut table.type_vector[struct_index];
                type_entry.members.push((*member_name, ii));
            }

            table.generic_indexes.clear();
            //    layout: Layout::INVALID,
            // Attributes, prefixes, and generic params
        }
        Function(ps) => {
            if !ps.generic_params.is_empty() {
                if ps.generic_params.len() >= GENERIC_PARAMETERS_COUNT {
                    println!(
                        "Amount of arguments of function {:?} exeeds max({})\tSkipped.",
                        ps, GENERIC_PARAMETERS_COUNT
                    );
                    return;
                }
                for p in &ps.generic_params {
                    table.generic_indexes.push(p.name);
                }
            }
            let function_path = path.extended(ps.name);
            let func_index = table
                .function_vector
                .iter()
                .position(|x| x.path == function_path)
                .unwrap();

            if let Some(x) = &ps.return_type {
                let ii = get_impl_index_struct(&x, path, table).unwrap();
                table.function_vector[func_index].return_type = ii;
            } else {
                table.function_vector[func_index].return_type = VOID_TYPE_ID;
            }
            let mut args = vec![];
            for x in &ps.args {
                args.push((
                    x.0.clone(),
                    get_impl_index_struct(&x.1, path, table).unwrap(),
                ));
            }
            let mut fscope = FunctionScope::new(FIRST_DYNAMIC_LABEL, FUNC_RETURN_LABEL);
            for (name, ty) in args.iter() {
                fscope.add_variable(*name, *ty);
            }
            table.function_vector[func_index].args = args.into_boxed_slice();

            let mut fbody = vec![];
            fbody.push(CompilerIR::Label(FUNC_ENTRY_LABEL));
            stmts_to_ir(&ps.body, path, table, &mut fscope, &mut fbody);
            fbody.push(CompilerIR::Label(FUNC_RETURN_LABEL));
            fbody.push(CompilerIR::ExitBody);

            table.function_vector[func_index].body = fbody.into_boxed_slice();

            table.generic_indexes.clear();

            // Attributes, prefixes, and generic params
        }
        Enum(ps) => {
            let enum_path = path.extended(ps.name);
            let enum_index = table
                .enum_vector
                .iter()
                .position(|x| x.path == enum_path)
                .unwrap();

            let mut fields = vec![];
            let mut last_value = ConstantValue::Integer(0);
            for (fname, fexpr) in ps.fields.iter() {
                if let Some(expr) = fexpr {
                    let l = ConstantValue::from_expression(expr, path, table);
                    fields.push((*fname, l));
                    last_value = l;
                } else {
                    let l = last_value.increment();
                    fields.push((*fname, l));
                    last_value = l;
                }
            }

            if let Some(x) = &ps.enum_type {
                let ii = get_impl_index_struct(&x, path, table).unwrap();
                table.enum_vector[enum_index].base_type = ii;
            } else {
                table.enum_vector[enum_index].base_type = SINTEGER32_TYPE_ID;
            }
            //let mut fscope = FunctionScope::new(0, 0);
            //table.enum_vector[enum_index].fields = ps
            //    .fields
            //    .iter()
            //    .map(|x| (x.0, ))
            //    .collect();
            // Attributes and prefixes
        }
        StaticLet(ps) => {
            let var_path = path.extended(ps.name);
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
            let var_path = path.extended(ps.name);
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

#[derive(Debug, Clone)]
struct FunctionScope {
    current_label: LabelID,
    layers: Vec<(
        Vec<(
            LexerSymbolIndex,
            VariableID,
            CompilerTypeImplementationIndex,
        )>,
        Option<(LabelID, LabelID)>,
        LabelID,
    )>,
    next_var_id: VariableID,
}
impl FunctionScope {
    pub fn new(current_label: LabelID, return_label: LabelID) -> FunctionScope {
        Self {
            current_label: current_label,
            layers: vec![(vec![], None, return_label)],
            next_var_id: VariableID(0),
        }
    }
    pub fn alloc_label(&mut self) -> LabelID {
        self.current_label.next_id()
    }
    pub fn enter_scope(&mut self, loop_labels: Option<(LabelID, LabelID)>) {
        self.layers.push((vec![], loop_labels, self.return_label()));
    }
    pub fn enter_scope_inherit_loop(&mut self) {
        self.layers.push((
            vec![],
            self.layers.last().and_then(|x| x.1),
            self.return_label(),
        ));
    }
    pub fn leave_scope(&mut self) {
        self.layers.pop();
    }
    pub fn add_variable(
        &mut self,
        name: LexerSymbolIndex,
        type_index: CompilerTypeImplementationIndex,
    ) -> VariableID {
        let id = self.next_var_id.next_id();
        self.layers
            .last_mut()
            .unwrap()
            .0
            .push((name, id, type_index));
        id
    }
    pub fn get_variable(
        &self,
        var_name: LexerSymbolIndex,
    ) -> Option<(VariableID, CompilerTypeImplementationIndex)> {
        for layer in self.layers.iter().rev() {
            for var in layer.0.iter().rev() {
                if var.0 == var_name {
                    return Some((var.1, var.2));
                }
            }
        }
        return None;
    }
    pub fn return_label(&self) -> LabelID {
        self.layers.last().map(|x| x.2).unwrap()
    }
    pub fn entry_label(&self) -> Option<LabelID> {
        self.layers.last().and_then(|x| x.1).map(|x| x.0)
    }
    pub fn exit_label(&self) -> Option<LabelID> {
        self.layers.last().and_then(|x| x.1).and_then(|x| Some(x.1))
    }
}
fn stmts_to_ir(
    body: &[StmtData],
    path: &CompilerPath,
    symbol_table: &mut SymbolTable,
    fscope: &mut FunctionScope,
    output: &mut Vec<CompilerIR>,
) {
    for x in body.iter() {
        match &x.stmt {
            Stmt::Let(var) => {
                let var_type = get_impl_index_struct(&var.var_type, path, symbol_table).unwrap();
                let rhs = var
                    .expr
                    .as_ref()
                    .map(|e| expression_to_ir(e, path, symbol_table, fscope, output));
                let id = fscope.add_variable(var.name, var_type);
                output.push(CompilerIR::DeclareVariable { id, var_type });
                if let Some(rhs) = rhs {
                    output.push(CompilerIR::Assign(ReferenceTo::Variable(id), rhs));
                }
            }
            Stmt::ConstLet(var) => {
                let expr =
                    ConstantValue::from_expression(var.expr.as_ref().unwrap(), path, symbol_table);
                output.push(CompilerIR::DeclareConstant {
                    name: var.name,
                    var_type: get_impl_index_struct(&var.var_type, path, symbol_table).unwrap(),
                    expr,
                });
            }
            Stmt::StaticLet(var) => {
                let var_type = get_impl_index_struct(&var.var_type, path, symbol_table).unwrap();
                let rhs = var
                    .expr
                    .as_ref()
                    .map(|e| expression_to_ir(e, path, symbol_table, fscope, output));
                let id = fscope.add_variable(var.name, var_type);
                output.push(CompilerIR::DeclareStatic {
                    name: var.name,
                    id,
                    var_type,
                });
                if let Some(rhs) = rhs {
                    output.push(CompilerIR::Assign(ReferenceTo::Variable(id), rhs));
                }
            }
            Stmt::Return(expr) => {
                if let Some(expr) = &expr {
                    let result = expression_to_ir(expr, path, symbol_table, fscope, output);
                    output.push(CompilerIR::PresentResult(result));
                }
                output.push(CompilerIR::JumpTo(fscope.return_label()));
            }
            Stmt::If(expr, then_d, else_d) => {
                let cond = expression_to_ir(expr, path, symbol_table, fscope, output);
                output.push(CompilerIR::Test(cond));
                let block_else_entry = fscope.alloc_label();
                let block_exit_label = fscope.alloc_label();
                output.push(CompilerIR::JumpToIfNot(block_else_entry));
                fscope.enter_scope_inherit_loop();
                stmts_to_ir(then_d, path, symbol_table, fscope, output);
                fscope.leave_scope();
                output.push(CompilerIR::JumpTo(block_exit_label));
                output.push(CompilerIR::Label(block_else_entry));
                fscope.enter_scope_inherit_loop();
                stmts_to_ir(else_d, path, symbol_table, fscope, output);
                fscope.leave_scope();
                output.push(CompilerIR::Label(block_exit_label));
            }
            Stmt::WhileLoop(expr, body) => {
                let block_entry = fscope.alloc_label();
                let block_exit = fscope.alloc_label();
                output.push(CompilerIR::Label(block_entry));
                let cond = expression_to_ir(expr, path, symbol_table, fscope, output);
                output.push(CompilerIR::Test(cond));
                output.push(CompilerIR::JumpToIfNot(block_exit));
                fscope.enter_scope(Some((block_entry, block_exit)));
                stmts_to_ir(body, path, symbol_table, fscope, output);
                fscope.leave_scope();
                output.push(CompilerIR::JumpTo(block_entry));
                output.push(CompilerIR::Label(block_exit));
            }
            Stmt::DoWhileLoop(expr, body) => {
                let block_entry = fscope.alloc_label();
                let block_cond = fscope.alloc_label();
                let block_exit = fscope.alloc_label();
                output.push(CompilerIR::Label(block_entry));

                fscope.enter_scope(Some((block_cond, block_exit)));
                stmts_to_ir(body, path, symbol_table, fscope, output);
                fscope.leave_scope();

                output.push(CompilerIR::Label(block_cond));
                let cond = expression_to_ir(expr, path, symbol_table, fscope, output);
                output.push(CompilerIR::Test(cond));
                output.push(CompilerIR::JumpToIf(block_entry));
                output.push(CompilerIR::Label(block_exit));
            }
            Stmt::Loop(body) => {
                let block_entry = fscope.alloc_label();
                let block_exit = fscope.alloc_label();
                output.push(CompilerIR::Label(block_entry));
                fscope.enter_scope(Some((block_entry, block_exit)));
                stmts_to_ir(body, path, symbol_table, fscope, output);
                fscope.leave_scope();
                output.push(CompilerIR::JumpTo(block_entry));
                output.push(CompilerIR::Label(block_exit));
            }
            Stmt::Block(body) => {
                fscope.enter_scope_inherit_loop();
                stmts_to_ir(body, path, symbol_table, fscope, output);
                fscope.leave_scope();
            }
            Stmt::Expr(e) => _ = expression_to_ir(e, path, symbol_table, fscope, output),
            Stmt::Continue => output.push(CompilerIR::JumpTo(fscope.entry_label().unwrap())),
            Stmt::Break => output.push(CompilerIR::JumpTo(fscope.exit_label().unwrap())),
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
            return CompilerTypeImplementationIndex::new(struct_impl);
        }
        let idx = symbol_table.type_implementation_vector.len();
        symbol_table.type_implementation_vector.push(tie);
        return CompilerTypeImplementationIndex::new(idx);
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
            let concat_path = path.extended(*lsi);
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
                .position(|x| x.path.0.len() == 1 && x.path.0[0] == *lsi)
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
                    TypeImplementationEntry::Normal(TypeIndex(struct_index)),
                    symbol_table,
                ));
            } else if let Some(struct_index) = symbol_table
                .type_vector
                .iter()
                .position(|x| x.path.0.len() == 1 && x.path.0[0] == *lsi)
            {
                return Some(return_format(
                    TypeImplementationEntry::Normal(TypeIndex(struct_index)),
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
                    TypeImplementationEntry::Pointered { base, pointered },
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
                    .collect::<Option<Box<[CompilerTypeImplementationIndex]>>>()?;
                let mut path = data.clone();
                path.push(*lsi);
                if let Some(base) = symbol_table
                    .type_vector
                    .iter()
                    .position(|x| x.path.0.iter().eq(path.iter()))
                {
                    return Some(return_format(
                        TypeImplementationEntry::GenericImplementation {
                            base: TypeIndex(base),
                            implementation: args,
                        },
                        symbol_table,
                    ));
                }
                return None;
            }
            let extended = path.extended_slice(&data);
            if let Some(base) = get_impl_index_struct(current_pointer, &extended, symbol_table) {
                return Some(base);
            }
            if let Some(base) = get_impl_index_struct(
                current_pointer,
                &CompilerPath(data.into_boxed_slice()),
                symbol_table,
            ) {
                return Some(base);
            }
            return None;
        }
        ParserType::ConstantSizeArray(base_type, len) => {
            if let Some(base) = get_impl_index_struct(base_type, path, symbol_table) {
                return Some(return_format(
                    TypeImplementationEntry::ConstantSizeArray { base, size: *len },
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
                    .collect::<Option<Box<[CompilerTypeImplementationIndex]>>>()
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
            let concat_path = path.extended(*lsi);
            let struct_index = symbol_table
                .type_vector
                .iter()
                .position(|x| x.path == concat_path)
                .or_else(|| {
                    symbol_table
                        .type_vector
                        .iter()
                        .position(|x| x.path.0.len() == 1 && x.path.0[0] == *lsi)
                })?;

            let args = arguments
                .iter()
                .map(|x| get_impl_index_struct(x, path, symbol_table))
                .collect::<Option<Box<[CompilerTypeImplementationIndex]>>>()?;

            return Some(return_format(
                TypeImplementationEntry::GenericImplementation {
                    base: TypeIndex(struct_index),
                    implementation: args,
                },
                symbol_table,
            ));
        }
    }
}
fn expression_to_ir(
    expr: &Expr,
    path: &CompilerPath,
    symbol_table: &mut SymbolTable,
    fscope: &FunctionScope,
    output: &mut Vec<CompilerIR>,
) -> ReferenceTo {
    match expr {
        Expr::Name(idx) => {
            if let Some((var_index, ..)) = fscope.get_variable(*idx) {
                return ReferenceTo::Variable(var_index);
            }
            return ReferenceTo::Register(0);
        }
        Expr::Integer(i) => return ReferenceTo::Integer(*i as i64),
        Expr::Decimal(d) => return ReferenceTo::Decimal(*d),
        Expr::Assign(l, r) => {
            let ro = expression_to_ir(r, path, symbol_table, fscope, output);
            let lo = expression_to_ir(l, path, symbol_table, fscope, output);
            output.push(CompilerIR::Assign(lo, ro.clone()));
            return ro;
        }
        _ => {
            println!("{:?}", expr);
            return ReferenceTo::Register(0);
        }
    }
}

fn default_symbol_table(lexer_symbol_table: LexerSymbolTable) -> SymbolTable {
    let mut table: SymbolTable = SymbolTable::default();
    table.lexer = lexer_symbol_table;

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
    for (name, sig, size, align) in primitives.iter() {
        table.type_vector.push(TypeVectorEntry {
            members: vec![],
            associated_functions: vec![],
            path: CompilerPath::default().extended(table.lexer.get_or_intern(name.to_string())),
            layout: Layout::new(*size, *align),
            type_type: TypeType::Compiler(sig),
        });
        table
            .type_implementation_vector
            .push(TypeImplementationEntry::Normal(TypeIndex(
                table.type_vector.len() - 1,
            )));
    }
    return table;
}

const FUNC_ENTRY_LABEL: LabelID = LabelID::new(0);
const FUNC_RETURN_LABEL: LabelID = LabelID::new(1);
const FIRST_DYNAMIC_LABEL: LabelID = LabelID::new(2);

pub const GENERIC_PARAMETERS_COUNT: usize = 16;
pub const VOID_TYPE_ID: CompilerTypeImplementationIndex = CompilerTypeImplementationIndex::new(0);
pub const SINTEGER32_TYPE_ID: CompilerTypeImplementationIndex =
    CompilerTypeImplementationIndex::new(6);
