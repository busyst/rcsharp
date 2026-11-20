use std::collections::{HashMap, HashSet};

use rcsharp_parser::defs::{GenericParam, Stmt, StmtData};
use rcsharp_syntax::{CompilerPath, Diagnostic, Interner, SourceFile, Span};

use crate::{
    compiler::{
        CompilationState, ConstantVariableEntry, EnumVectorEntry, FunctionVectorEntry,
        StaticVariableEntry, SymbolTable, TypeVectorEntry, GENERIC_PARAMETERS_COUNT, VOID_TYPE_ID,
    },
    def::{ConstantValue, Layout, TypeImplementationEntry, TypeIndex, TypeType},
    loader::ParsedFile,
};
struct RegisterCtx<'a> {
    state: &'a mut CompilationState,
    table: SymbolTable,
    /// Types and  enums
    type_paths: HashMap<CompilerPath, Option<(SourceFile, Span)>>,
    /// Functions, statics, and constants
    value_paths: HashMap<CompilerPath, (SourceFile, Span)>,
}
impl<'a> RegisterCtx<'a> {
    fn error(&mut self, file: &SourceFile, span: Span, msg: &str) {
        self.state
            .diagnostics
            .push(Diagnostic::error(file, msg, span));
    }

    fn check_duplicate_type(&mut self, path: &CompilerPath, file: &SourceFile, span: Span) -> bool {
        if self.type_paths.contains_key(path) {
            let name = self.table.interner.get(*path.0.last().unwrap());
            self.error(file, span, &format!("Duplicate type definition '{}'", name));
            return false;
        }
        self.type_paths
            .insert(path.clone(), Some((file.clone(), span)));
        true
    }

    fn check_duplicate_value(
        &mut self,
        path: &CompilerPath,
        file: &SourceFile,
        span: Span,
    ) -> bool {
        if self.value_paths.contains_key(path) {
            let name = self.table.interner.get(*path.0.last().unwrap());
            self.error(
                file,
                span,
                &format!("Duplicate symbol definition '{}'", name),
            );
            return false;
        }
        self.value_paths.insert(path.clone(), (file.clone(), span));
        true
    }

    fn validate_generic_params(&mut self, params: &[GenericParam], file: &SourceFile, span: Span) {
        if params.len() > GENERIC_PARAMETERS_COUNT {
            self.error(
                file,
                span,
                &format!(
                    "Generic parameter count ({}) exceeds maximum ({})",
                    params.len(),
                    GENERIC_PARAMETERS_COUNT
                ),
            );
        }

        let mut seen = HashSet::with_capacity(params.len());
        for p in params {
            if !seen.insert(p.name) {
                let name = self.table.interner.get(p.name);
                self.error(
                    file,
                    span,
                    &format!("Duplicate generic parameter '{}'", name),
                );
            }
        }
    }

    fn walk(&mut self, statement: &StmtData, file: &SourceFile, path: &CompilerPath) {
        match &statement.stmt {
            Stmt::Namespace(ns_name, body) => {
                let extended_path = path.extended(*ns_name);
                if self.type_paths.contains_key(&extended_path) {
                    let name = self.table.interner.get(*ns_name);
                    self.error(
                        file,
                        statement.span,
                        &format!(
                            "Namespace '{}' conflicts with a type of the same path",
                            name
                        ),
                    );
                }
                for item in body.iter() {
                    self.walk(item, file, &extended_path);
                }
            }
            Stmt::Block(stmts) => {
                for item in stmts.iter() {
                    self.walk(item, file, path);
                }
            }
            Stmt::Struct(ps) => {
                let full_path = path.extended(ps.name);
                self.validate_generic_params(&ps.generic_params, file, statement.span);
                if self.check_duplicate_type(&full_path, file, statement.span) {
                    let type_type = if ps.generic_params.is_empty() {
                        TypeType::Normal
                    } else {
                        TypeType::Generic
                    };
                    self.table.type_vector.push(TypeVectorEntry {
                        members: vec![],
                        associated_functions: vec![],
                        path: full_path,
                        layout: Layout::INVALID,
                        type_type,
                    });
                }
            }
            Stmt::Enum(ps) => {
                let full_path = path.extended(ps.name);
                if self.check_duplicate_type(&full_path, file, statement.span) {
                    self.table.enum_vector.push(EnumVectorEntry {
                        base_type: VOID_TYPE_ID,
                        fields: vec![].into_boxed_slice(),
                        associated_functions: vec![],
                        path: full_path,
                    });
                }
            }
            Stmt::Function(ps) => {
                let full_path = path.extended(ps.name);
                self.validate_generic_params(&ps.generic_params, file, statement.span);
                if self.check_duplicate_value(&full_path, file, statement.span) {
                    self.table.function_vector.push(FunctionVectorEntry {
                        llvm_signature: String::new(),
                        path: full_path,
                        return_type: VOID_TYPE_ID,
                        args: vec![].into_boxed_slice(),
                        body: vec![].into_boxed_slice(),
                        is_generic: !ps.generic_params.is_empty(),
                    });
                }
            }
            Stmt::StaticLet(ps) => {
                let full_path = path.extended(ps.name);
                if self.check_duplicate_value(&full_path, file, statement.span) {
                    self.table.svar_vector.push(StaticVariableEntry {
                        var_type: VOID_TYPE_ID,
                        path: full_path,
                        expression: None,
                    });
                }
            }
            Stmt::ConstLet(ps) => {
                let full_path = path.extended(ps.name);
                if self.check_duplicate_value(&full_path, file, statement.span) {
                    self.table.cvar_vector.push(ConstantVariableEntry {
                        var_type: VOID_TYPE_ID,
                        path: full_path,
                        expression: ConstantValue::Integer(0),
                    });
                }
            }
            Stmt::CompilerDud | Stmt::CompilerHint(_) => {}
            _ => {
                self.error(
                    file,
                    statement.span,
                    "Unexpected statement at top-level or namespace scope",
                );
            }
        }
    }
}
impl CompilationState {
    pub fn register(
        &mut self,
        files: &[ParsedFile],
        interner: Interner,
    ) -> Result<SymbolTable, ()> {
        let table = default_symbol_table(interner);

        let mut type_paths = HashMap::with_capacity(table.type_vector.len());
        for ty in &table.type_vector {
            type_paths.insert(ty.path.clone(), None);
        }

        let mut ctx = RegisterCtx {
            state: self,
            table,
            type_paths,
            value_paths: HashMap::new(),
        };

        let root = CompilerPath::default();
        for ParsedFile(file, stmts) in files {
            for stmt in stmts {
                ctx.walk(stmt, file, &root);
            }
        }

        let table = ctx.table;
        if self.has_errors() {
            Err(())
        } else {
            Ok(table)
        }
    }
}

pub fn default_symbol_table(lexer_symbol_table: Interner) -> SymbolTable {
    let mut table: SymbolTable = SymbolTable::default();
    table.interner = lexer_symbol_table;

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
            path: CompilerPath::default().extended(table.interner.intern_string(name)),
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
