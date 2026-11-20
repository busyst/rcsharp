use rcsharp_parser::defs::{
    Expr, ParserType,
    Stmt::{self},
    StmtData,
};
use rcsharp_syntax::{CompilerPath, Diagnostic, DiagnosticType, Interner, Symbol};

use crate::{
    def::{
        CompTypeImplementationIndex, CompilerIR, ConstantValue, LabelID, Layout, ReferenceTo,
        RegisterID, TypeImplementationEntry, TypeIndex, TypeType, VariableID,
    },
    llvm_ir_conversion::{write_all_statics, write_all_used_types, SignatureHolder},
    CompilationArgs,
};
pub struct CompilationState {
    pub diagnostics: Vec<Diagnostic>,
}

impl CompilationState {
    pub fn new() -> Self {
        Self {
            diagnostics: Vec::new(),
        }
    }
    pub fn dump_diagnostics(&mut self) {
        if self.diagnostics.is_empty() {
            return;
        }
        self.diagnostics.clear();
    }
    pub fn has_errors(&self) -> bool {
        self.diagnostics
            .iter()
            .any(|d| matches!(d.kind, DiagnosticType::Error | DiagnosticType::Fatal))
    }
}

pub fn compile_to_file(args: &CompilationArgs) -> CompilationState {
    let mut interner = Interner::new();
    let mut compiler = CompilationState::new();

    let parsed_files = match compiler.load(&args.input.clone().unwrap(), &mut interner) {
        Ok(pf) => pf,
        Err(_) => return compiler,
    };
    let sym_table = match compiler.register(&parsed_files, interner) {
        Ok(pf) => pf,
        Err(_) => return compiler,
    };
    let fuller_sym_table = match compiler.resolve(&parsed_files, sym_table) {
        Ok(pf) => pf,
        Err(_) => return compiler,
    };
    let even_more_fuller_sym_table =
        match compiler.constant_resolve(&parsed_files, fuller_sym_table) {
            Ok(pf) => pf,
            Err(_) => return compiler,
        };

    compiler.dump_diagnostics();
    println!("Compilation successful!");

    println!("Types: {}", even_more_fuller_sym_table.type_vector.len());
    println!(
        "Implementations: {}",
        even_more_fuller_sym_table.type_implementation_vector.len()
    );
    let mut output = std::fs::OpenOptions::new()
        .create(true)
        .read(true)
        .write(true)
        .truncate(true)
        .open(args.output.clone().unwrap())
        .unwrap();
    let mut signatures = SignatureHolder::new(
        even_more_fuller_sym_table.type_implementation_vector.len(),
        even_more_fuller_sym_table.svar_vector.len(),
        0,
    );
    write_all_used_types(
        &mut output,
        &mut signatures.type_signatures,
        &even_more_fuller_sym_table,
        true,
    );
    write_all_statics(
        &mut output,
        &mut signatures,
        &even_more_fuller_sym_table,
        true,
    );

    return compiler;
}

pub enum FunctionTypeAssociation {
    Compiler(fn(ReferenceTo, (ReferenceTo, CompTypeImplementationIndex), &mut Vec<CompilerIR>)),
}
pub struct TypeVectorEntry {
    pub members: Vec<(Symbol, CompTypeImplementationIndex)>,
    pub associated_functions: Vec<(String, FunctionTypeAssociation)>,
    pub path: CompilerPath,
    pub type_type: TypeType,
    pub layout: Layout,
}
pub struct FunctionVectorEntry {
    pub args: Box<[(Symbol, CompTypeImplementationIndex)]>,
    pub return_type: CompTypeImplementationIndex,
    pub path: CompilerPath,
    pub llvm_signature: String,
    pub body: Box<[CompilerIR]>,
    pub is_generic: bool,
}
pub struct EnumVectorEntry {
    pub base_type: CompTypeImplementationIndex,
    pub path: CompilerPath,
    pub associated_functions: Vec<(String, FunctionTypeAssociation)>,
    pub fields: Box<[(Symbol, ConstantValue)]>,
}
pub struct StaticVariableEntry {
    pub var_type: CompTypeImplementationIndex,
    pub path: CompilerPath,
    pub expression: Option<Expr>,
}
pub struct ConstantVariableEntry {
    pub var_type: CompTypeImplementationIndex,
    pub path: CompilerPath,
    pub expression: ConstantValue,
}
#[derive(Default)]
pub struct SymbolTable {
    pub type_vector: Vec<TypeVectorEntry>,
    pub type_implementation_vector: Vec<TypeImplementationEntry>,
    pub function_vector: Vec<FunctionVectorEntry>,
    pub enum_vector: Vec<EnumVectorEntry>,
    pub svar_vector: Vec<StaticVariableEntry>,
    pub cvar_vector: Vec<ConstantVariableEntry>,
    pub generic_indexes: Vec<Symbol>,
    pub interner: Interner,
}

#[derive(Debug, Clone)]
struct FunctionScope {
    current_label: LabelID,
    current_register: RegisterID,
    layers: Vec<(
        Vec<(Symbol, VariableID, CompTypeImplementationIndex)>,
        Option<(LabelID, LabelID)>,
        LabelID,
    )>,
    next_var_id: VariableID,
}
impl FunctionScope {
    pub fn new(
        current_label: LabelID,
        return_label: LabelID,
        starting_register: RegisterID,
    ) -> FunctionScope {
        Self {
            current_label: current_label,
            current_register: starting_register,
            layers: vec![(vec![], None, return_label)],
            next_var_id: VariableID(0),
        }
    }
    pub fn alloc_label(&mut self) -> LabelID {
        self.current_label.next_id()
    }
    pub fn alloc_register(&mut self) -> RegisterID {
        self.current_register.next_register()
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
        name: Symbol,
        type_index: CompTypeImplementationIndex,
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
        var_name: Symbol,
    ) -> Option<(VariableID, CompTypeImplementationIndex)> {
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
                let expr = ConstantValue::Integer(0);
                //ConstantValue::from_expression(var.expr.as_ref().unwrap(), path, symbol_table);
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
                symbol_table.svar_vector.push(StaticVariableEntry {
                    var_type,
                    path: path.extended(var.name),
                    expression: None,
                });
                let id = (symbol_table.svar_vector.len() - 1) as u64;
                output.push(CompilerIR::DeclareStatic {
                    name: var.name,
                    id,
                    var_type,
                });
                if let Some(rhs) = rhs {
                    output.push(CompilerIR::Assign(ReferenceTo::Static(id), rhs));
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
            Stmt::Enum(..) | Stmt::Struct(..) | Stmt::Function(..) => {
                panic!("Wrong scope diddy blud 💀💀💀 (todo, shouldn't be)")
            }
            _ => {}
        }
    }
}
fn get_impl_index_struct(
    parser_type: &ParserType,
    path: &CompilerPath,
    symbol_table: &mut SymbolTable,
) -> Option<CompTypeImplementationIndex> {
    fn intern_impl(
        tie: TypeImplementationEntry,
        symbol_table: &mut SymbolTable,
    ) -> CompTypeImplementationIndex {
        if let Some(idx) = symbol_table
            .type_implementation_vector
            .iter()
            .position(|x| *x == tie)
        {
            return CompTypeImplementationIndex::new(idx);
        }
        let idx = symbol_table.type_implementation_vector.len();
        symbol_table.type_implementation_vector.push(tie);
        CompTypeImplementationIndex::new(idx)
    }

    #[inline]
    fn matches_scoped_path(entry: &[Symbol], scope: &[Symbol], loc: &[Symbol]) -> bool {
        entry.len() == scope.len() + loc.len()
            && entry[..scope.len()] == *scope
            && entry[scope.len()..] == *loc
    }

    fn lookup(
        loc: &CompilerPath,
        glob: &CompilerPath,
        symbol_table: &SymbolTable,
    ) -> Option<TypeImplementationEntry> {
        if loc.0.len() == 1 {
            if let Some(gen_param_index) = symbol_table
                .generic_indexes
                .iter()
                .position(|x| *x == loc.0[0])
            {
                return Some(TypeImplementationEntry::GenericParameter(gen_param_index));
            }
        }

        for prefix_len in (0..=glob.0.len()).rev() {
            let scope = &glob.0[..prefix_len];

            if let Some(struct_index) = symbol_table
                .type_vector
                .iter()
                .position(|x| matches_scoped_path(&x.path.0, scope, &loc.0))
            {
                return Some(TypeImplementationEntry::Normal(TypeIndex(struct_index)));
            }

            if let Some(enum_index) = symbol_table
                .enum_vector
                .iter()
                .position(|x| matches_scoped_path(&x.path.0, scope, &loc.0))
            {
                return Some(TypeImplementationEntry::Enum(enum_index));
            }
        }

        None
    }

    match parser_type {
        ParserType::Named(lsi) => {
            lookup(lsi, path, symbol_table).map(|tie| intern_impl(tie, symbol_table))
        }
        ParserType::Pointer(internal_type) => {
            let mut current_pointer = internal_type.as_ref();
            let mut pointered: u8 = 1;
            while let ParserType::Pointer(inner) = current_pointer {
                pointered = pointered.checked_add(1)?;
                current_pointer = inner;
            }
            let base = get_impl_index_struct(current_pointer, path, symbol_table)?;
            Some(intern_impl(
                TypeImplementationEntry::Pointered { base, pointered },
                symbol_table,
            ))
        }
        ParserType::ConstantSizeArray(base_type, len) => {
            let base = get_impl_index_struct(base_type, path, symbol_table)?;
            Some(intern_impl(
                TypeImplementationEntry::ConstantSizeArray { base, size: *len },
                symbol_table,
            ))
        }
        ParserType::Function(func_return, arguments) => {
            let return_type = get_impl_index_struct(func_return, path, symbol_table)?;
            let args = arguments
                .iter()
                .map(|x| get_impl_index_struct(x, path, symbol_table))
                .collect::<Option<Box<[CompTypeImplementationIndex]>>>()?;
            Some(intern_impl(
                TypeImplementationEntry::Function {
                    arguments: args,
                    return_type,
                },
                symbol_table,
            ))
        }
        ParserType::Generic(lsi, arguments) => {
            let TypeImplementationEntry::Normal(base) = lookup(lsi, path, symbol_table)? else {
                return None;
            };
            let implementation = arguments
                .iter()
                .map(|x| get_impl_index_struct(x, path, symbol_table))
                .collect::<Option<Box<[CompTypeImplementationIndex]>>>()?;
            Some(intern_impl(
                TypeImplementationEntry::GenericImplementation {
                    base,
                    implementation,
                },
                symbol_table,
            ))
        }
    }
}
fn expression_to_ir(
    expr: &Expr,
    path: &CompilerPath,
    symbol_table: &mut SymbolTable,
    fscope: &mut FunctionScope,
    output: &mut Vec<CompilerIR>,
) -> ReferenceTo {
    match expr {
        Expr::Name(idx) => {
            if let Some((var_index, ..)) = fscope.get_variable(*idx) {
                return ReferenceTo::Variable(var_index);
            }
            return ReferenceTo::Register(fscope.alloc_register());
        }
        Expr::Integer(i) => return ReferenceTo::Integer(*i), // *i as i64
        Expr::Decimal(d) => return ReferenceTo::Decimal(*d), // RODO *d
        Expr::Char(d) => return ReferenceTo::Char(*d),
        Expr::Boolean(b) => return ReferenceTo::Boolean(*b),
        Expr::StringConst(s) => return ReferenceTo::StringConst(*s),
        Expr::NullPtr => return ReferenceTo::NullPtr,

        Expr::Assign(l, r) => {
            let ro = expression_to_ir(r, path, symbol_table, fscope, output);
            let lo = expression_to_ir(l, path, symbol_table, fscope, output);
            output.push(CompilerIR::Assign(lo, ro.clone()));
            return ro;
        }
        Expr::Cast(expr, to) => {
            let to_type = get_impl_index_struct(to, path, symbol_table).unwrap();
            let ro = expression_to_ir(expr, path, symbol_table, fscope, output);
            let result = ReferenceTo::Register(fscope.alloc_register());
            output.push(CompilerIR::CompilerCall {
                operation: "into",
                result,
                arguments: Box::new([ro, ReferenceTo::Type(to_type)]),
            });
            return result;
        }
        Expr::UnaryOp(..) => {
            return ReferenceTo::Register(fscope.alloc_register());
        }
        Expr::Call(..) => {
            return ReferenceTo::Register(fscope.alloc_register());
        }
        Expr::MemberCall(..) => {
            return ReferenceTo::Register(fscope.alloc_register());
        }
        Expr::StructInit(..) => {
            return ReferenceTo::Register(fscope.alloc_register());
        }
        Expr::BinaryOp(..) => {
            return ReferenceTo::Register(fscope.alloc_register());
        }
        Expr::Index(..) => {
            return ReferenceTo::Register(fscope.alloc_register());
        }
        Expr::MemberAccess(..) => {
            return ReferenceTo::Register(fscope.alloc_register());
        }
        Expr::StaticAccess(..) => {
            return ReferenceTo::Register(fscope.alloc_register());
        }
        Expr::Array(..) => {
            return ReferenceTo::Register(fscope.alloc_register());
        }
        Expr::Type(e) => {
            return ReferenceTo::Type(get_impl_index_struct(e, path, symbol_table).unwrap());
        }
        Expr::NameWithGenerics(..) => {
            todo!()
        }
        Expr::MacroCall(..) | Expr::Range(..) => {
            unimplemented!()
        }
    }
}

const FUNC_ENTRY_LABEL: LabelID = LabelID::new(0);
const FUNC_RETURN_LABEL: LabelID = LabelID::new(1);
const FIRST_DYNAMIC_LABEL: LabelID = LabelID::new(2);

pub const GENERIC_PARAMETERS_COUNT: usize = 16;
pub const VOID_TYPE_ID: CompTypeImplementationIndex = CompTypeImplementationIndex::new(0);
pub const SINTEGER32_TYPE_ID: CompTypeImplementationIndex = CompTypeImplementationIndex::new(6);
