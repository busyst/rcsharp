use std::collections::{HashMap, HashSet};

use rcsharp_parser::defs::{ParserType, Stmt, StmtData};
use rcsharp_syntax::{CompilerPath, Diagnostic, SourceFile, Span, Symbol};

use crate::{
    compiler::{CompilationState, SymbolTable, SINTEGER32_TYPE_ID, VOID_TYPE_ID},
    def::{CompTypeImplementationIndex, Layout, TypeImplementationEntry, TypeIndex, TypeType},
    loader::ParsedFile,
};

#[derive(Clone, Copy, PartialEq, Eq)]
enum LayoutState {
    Unvisited,
    Visiting,
    Visited,
}

struct ResolveCtx<'a> {
    state: &'a mut CompilationState,
    table: SymbolTable,
    struct_generic_counts: HashMap<usize, usize>,
    struct_locations: Vec<Option<(SourceFile, Span)>>,
}

impl<'a> ResolveCtx<'a> {
    fn error(&mut self, file: &SourceFile, span: Span, msg: &str) {
        self.state
            .diagnostics
            .push(Diagnostic::error(file, msg, span));
    }

    fn format_path(&self, path: &CompilerPath) -> String {
        path.0
            .iter()
            .map(|sym| self.table.interner.get(*sym))
            .collect::<Vec<_>>()
            .join("::")
    }

    fn intern_impl(&mut self, tie: TypeImplementationEntry) -> CompTypeImplementationIndex {
        if let Some(idx) = self
            .table
            .type_implementation_vector
            .iter()
            .position(|x| *x == tie)
        {
            return CompTypeImplementationIndex::new(idx);
        }
        let idx = self.table.type_implementation_vector.len();
        self.table.type_implementation_vector.push(tie);
        CompTypeImplementationIndex::new(idx)
    }

    fn lookup_type_entry(
        &self,
        loc: &CompilerPath,
        glob: &CompilerPath,
    ) -> Option<TypeImplementationEntry> {
        if loc.0.len() == 1 {
            if let Some(gen_idx) = self
                .table
                .generic_indexes
                .iter()
                .position(|x| *x == loc.0[0])
            {
                return Some(TypeImplementationEntry::GenericParameter(gen_idx));
            }
        }

        #[inline]
        fn matches_scoped_path(entry: &[Symbol], scope: &[Symbol], loc: &[Symbol]) -> bool {
            entry.len() == scope.len() + loc.len()
                && entry[..scope.len()] == *scope
                && entry[scope.len()..] == *loc
        }

        for prefix_len in (0..=glob.0.len()).rev() {
            let scope = &glob.0[..prefix_len];

            if let Some(struct_index) = self
                .table
                .type_vector
                .iter()
                .position(|x| matches_scoped_path(&x.path.0, scope, &loc.0))
            {
                return Some(TypeImplementationEntry::Normal(TypeIndex(struct_index)));
            }

            if let Some(enum_index) = self
                .table
                .enum_vector
                .iter()
                .position(|x| matches_scoped_path(&x.path.0, scope, &loc.0))
            {
                return Some(TypeImplementationEntry::Enum(enum_index));
            }
        }

        None
    }

    fn resolve_type(
        &mut self,
        parser_type: &ParserType,
        scope: &CompilerPath,
        file: &SourceFile,
        span: Span,
    ) -> Result<CompTypeImplementationIndex, ()> {
        match parser_type {
            ParserType::Named(lsi) => {
                let Some(tie) = self.lookup_type_entry(lsi, scope) else {
                    let name = self.format_path(lsi);
                    self.error(file, span, &format!("Unknown type '{}'", name));
                    return Err(());
                };

                if let TypeImplementationEntry::Normal(TypeIndex(struct_idx)) = tie {
                    if self.table.type_vector[struct_idx].type_type == TypeType::Generic {
                        let name = self.format_path(lsi);
                        let expected = self
                            .struct_generic_counts
                            .get(&struct_idx)
                            .copied()
                            .unwrap_or(0);
                        self.error(
                            file,
                            span,
                            &format!(
                                "Generic struct '{}' requires {} type argument(s)",
                                name, expected
                            ),
                        );
                        return Err(());
                    }
                }

                Ok(self.intern_impl(tie))
            }

            ParserType::Generic(lsi, arguments) => {
                let Some(tie) = self.lookup_type_entry(lsi, scope) else {
                    let name = self.format_path(lsi);
                    self.error(file, span, &format!("Unknown generic type '{}'", name));
                    return Err(());
                };

                let TypeImplementationEntry::Normal(base @ TypeIndex(struct_idx)) = tie else {
                    let name = self.format_path(lsi);
                    self.error(file, span, &format!("'{}' is not a generic struct", name));
                    return Err(());
                };

                if self.table.type_vector[struct_idx].type_type != TypeType::Generic {
                    let name = self.format_path(lsi);
                    self.error(
                        file,
                        span,
                        &format!("Struct '{}' does not take generic arguments", name),
                    );
                    return Err(());
                }

                let expected = self
                    .struct_generic_counts
                    .get(&struct_idx)
                    .copied()
                    .unwrap_or(0);
                if arguments.len() != expected {
                    let name = self.format_path(lsi);
                    self.error(
                        file,
                        span,
                        &format!(
                            "Struct '{}' expects {} generic argument(s), got {}",
                            name,
                            expected,
                            arguments.len()
                        ),
                    );
                    return Err(());
                }

                let mut resolved_args = Vec::with_capacity(arguments.len());
                let mut failed = false;
                for arg in arguments.iter() {
                    match self.resolve_type(arg, scope, file, span) {
                        Ok(ty) => resolved_args.push(ty),
                        Err(()) => failed = true,
                    }
                }
                if failed {
                    return Err(());
                }

                Ok(
                    self.intern_impl(TypeImplementationEntry::GenericImplementation {
                        base,
                        implementation: resolved_args.into_boxed_slice(),
                    }),
                )
            }

            ParserType::Pointer(internal_type) => {
                let mut current = internal_type.as_ref();
                let mut pointered: u8 = 1;
                while let ParserType::Pointer(inner) = current {
                    pointered = pointered.checked_add(1).ok_or_else(|| {
                        self.error(
                            file,
                            span,
                            "Pointer indirection exceeds maximum depth (255)",
                        );
                    })?;
                    current = inner;
                }
                let base = self.resolve_type(current, scope, file, span)?;
                Ok(self.intern_impl(TypeImplementationEntry::Pointered { base, pointered }))
            }

            ParserType::ConstantSizeArray(base_type, len) => {
                let base = self.resolve_type(base_type, scope, file, span)?;
                if base == VOID_TYPE_ID {
                    self.error(file, span, "Array element type cannot be 'void'");
                    return Err(());
                }
                Ok(self
                    .intern_impl(TypeImplementationEntry::ConstantSizeArray { base, size: *len }))
            }

            ParserType::Function(func_return, arguments) => {
                let return_type = self.resolve_type(func_return, scope, file, span)?;
                let mut args = Vec::with_capacity(arguments.len());
                let mut failed = false;

                for arg in arguments.iter() {
                    match self.resolve_type(arg, scope, file, span) {
                        Ok(ty) if ty == VOID_TYPE_ID => {
                            self.error(file, span, "Function parameter type cannot be 'void'");
                            failed = true;
                        }
                        Ok(ty) => args.push(ty),
                        Err(()) => failed = true,
                    }
                }
                if failed {
                    return Err(());
                }

                Ok(self.intern_impl(TypeImplementationEntry::Function {
                    arguments: args.into_boxed_slice(),
                    return_type,
                }))
            }
        }
    }

    fn collect_struct_metadata(
        &mut self,
        statement: &StmtData,
        file: &SourceFile,
        path: &CompilerPath,
    ) {
        match &statement.stmt {
            Stmt::Namespace(ns, body) => {
                let extended = path.extended(*ns);
                for item in body.iter() {
                    self.collect_struct_metadata(item, file, &extended);
                }
            }
            Stmt::Block(stmts) => {
                for item in stmts.iter() {
                    self.collect_struct_metadata(item, file, path);
                }
            }
            Stmt::Struct(ps) => {
                let struct_path = path.extended(ps.name);
                if let Some(idx) = self
                    .table
                    .type_vector
                    .iter()
                    .position(|x| x.path == struct_path)
                {
                    self.struct_locations[idx] = Some((file.clone(), statement.span));
                    if !ps.generic_params.is_empty() {
                        self.struct_generic_counts
                            .insert(idx, ps.generic_params.len());
                    }
                }
            }
            _ => {}
        }
    }

    fn walk_resolve(&mut self, statement: &StmtData, file: &SourceFile, path: &CompilerPath) {
        match &statement.stmt {
            Stmt::Namespace(ns, body) => {
                let extended = path.extended(*ns);
                for item in body.iter() {
                    self.walk_resolve(item, file, &extended);
                }
            }
            Stmt::Block(stmts) => {
                for item in stmts.iter() {
                    self.walk_resolve(item, file, path);
                }
            }
            Stmt::Struct(ps) => {
                let struct_path = path.extended(ps.name);
                let Some(struct_index) = self
                    .table
                    .type_vector
                    .iter()
                    .position(|x| x.path == struct_path)
                else {
                    return;
                };

                self.table.generic_indexes.clear();
                for p in ps.generic_params.iter() {
                    self.table.generic_indexes.push(p.name);
                }

                let mut seen_members = HashSet::with_capacity(ps.members.len());
                let mut resolved_members = Vec::with_capacity(ps.members.len());

                for (member_name, member_type) in ps.members.iter() {
                    if !seen_members.insert(*member_name) {
                        let name = self.table.interner.get(*member_name);
                        self.error(
                            file,
                            statement.span,
                            &format!("Duplicate struct field '{}'", name),
                        );
                        continue;
                    }
                    if let Ok(ii) = self.resolve_type(member_type, path, file, statement.span) {
                        if ii == VOID_TYPE_ID {
                            let name = self.table.interner.get(*member_name);
                            self.error(
                                file,
                                statement.span,
                                &format!("Struct field '{}' cannot have type 'void'", name),
                            );
                            continue;
                        }
                        resolved_members.push((*member_name, ii));
                    }
                }

                self.table.type_vector[struct_index].members = resolved_members;
                self.table.generic_indexes.clear();
            }
            Stmt::Function(ps) => {
                let func_path = path.extended(ps.name);
                let Some(func_index) = self
                    .table
                    .function_vector
                    .iter()
                    .position(|x| x.path == func_path)
                else {
                    return;
                };

                self.table.generic_indexes.clear();
                for p in ps.generic_params.iter() {
                    self.table.generic_indexes.push(p.name);
                }

                let return_type = match &ps.return_type {
                    Some(ret) => self
                        .resolve_type(ret, path, file, statement.span)
                        .unwrap_or(VOID_TYPE_ID),
                    None => VOID_TYPE_ID,
                };

                let mut seen_args = HashSet::with_capacity(ps.args.len());
                let mut resolved_args = Vec::with_capacity(ps.args.len());

                for (arg_name, arg_type) in ps.args.iter() {
                    if !seen_args.insert(*arg_name) {
                        let name = self.table.interner.get(*arg_name);
                        self.error(
                            file,
                            statement.span,
                            &format!("Duplicate parameter name '{}'", name),
                        );
                        continue;
                    }
                    if let Ok(ii) = self.resolve_type(arg_type, path, file, statement.span) {
                        if ii == VOID_TYPE_ID {
                            let name = self.table.interner.get(*arg_name);
                            self.error(
                                file,
                                statement.span,
                                &format!("Parameter '{}' cannot have type 'void'", name),
                            );
                            continue;
                        }
                        resolved_args.push((*arg_name, ii));
                    }
                }

                self.table.function_vector[func_index].return_type = return_type;
                self.table.function_vector[func_index].args = resolved_args.into_boxed_slice();
                self.table.generic_indexes.clear();
            }
            Stmt::Enum(ps) => {
                let enum_path = path.extended(ps.name);
                let Some(enum_index) = self
                    .table
                    .enum_vector
                    .iter()
                    .position(|x| x.path == enum_path)
                else {
                    return;
                };

                let base_type = match &ps.enum_type {
                    Some(ty) => match self.resolve_type(ty, path, file, statement.span) {
                        Ok(ii) if ii == VOID_TYPE_ID => {
                            self.error(file, statement.span, "Enum base type cannot be 'void'");
                            SINTEGER32_TYPE_ID
                        }
                        Ok(ii) => ii,
                        Err(()) => SINTEGER32_TYPE_ID,
                    },
                    None => SINTEGER32_TYPE_ID,
                };

                let mut seen_fields = HashSet::with_capacity(ps.fields.len());
                for (fname, _) in ps.fields.iter() {
                    if !seen_fields.insert(*fname) {
                        let name = self.table.interner.get(*fname);
                        self.error(
                            file,
                            statement.span,
                            &format!("Duplicate enum variant '{}'", name),
                        );
                    }
                }

                self.table.enum_vector[enum_index].base_type = base_type;
            }
            Stmt::StaticLet(ps) => {
                let var_path = path.extended(ps.name);
                let Some(var_index) = self
                    .table
                    .svar_vector
                    .iter()
                    .position(|x| x.path == var_path)
                else {
                    return;
                };

                if let Ok(ii) = self.resolve_type(&ps.var_type, path, file, statement.span) {
                    if ii == VOID_TYPE_ID {
                        self.error(
                            file,
                            statement.span,
                            "Static variable cannot have type 'void'",
                        );
                    } else {
                        self.table.svar_vector[var_index].var_type = ii;
                    }
                }
            }
            Stmt::ConstLet(ps) => {
                let var_path = path.extended(ps.name);
                let Some(var_index) = self
                    .table
                    .cvar_vector
                    .iter()
                    .position(|x| x.path == var_path)
                else {
                    return;
                };

                if let Ok(ii) = self.resolve_type(&ps.var_type, path, file, statement.span) {
                    if ii == VOID_TYPE_ID {
                        self.error(file, statement.span, "Constant cannot have type 'void'");
                    } else {
                        self.table.cvar_vector[var_index].var_type = ii;
                    }
                }
            }
            _ => {}
        }
    }

    fn compute_all_layouts(&mut self) {
        let count = self.table.type_vector.len();
        let mut states = vec![LayoutState::Unvisited; count];
        for i in 0..count {
            if matches!(self.table.type_vector[i].type_type, TypeType::Normal) {
                let _ = self.compute_struct_layout(i, &mut states);
            } else if matches!(self.table.type_vector[i].type_type, TypeType::Compiler(_)) {
                states[i] = LayoutState::Visited;
            }
        }
    }

    fn compute_struct_layout(
        &mut self,
        struct_idx: usize,
        states: &mut [LayoutState],
    ) -> Result<Layout, ()> {
        match states[struct_idx] {
            LayoutState::Visited => return Ok(self.table.type_vector[struct_idx].layout),
            LayoutState::Visiting => {
                let name = self.format_path(&self.table.type_vector[struct_idx].path);
                if let Some((file, span)) = self.struct_locations[struct_idx].clone() {
                    self.error(
                        &file,
                        span,
                        &format!("Recursive struct '{}' has infinite size", name),
                    );
                }
                return Err(());
            }
            LayoutState::Unvisited => {}
        }

        states[struct_idx] = LayoutState::Visiting;

        let member_types: Vec<_> = self.table.type_vector[struct_idx]
            .members
            .iter()
            .map(|(_, ty)| *ty)
            .collect();

        let mut offset: u64 = 0;
        let mut max_align: u64 = 1;

        for member_ty in member_types {
            let layout = self.compute_impl_layout(member_ty, &[], states, struct_idx)?;
            let align = layout.align.max(1);
            offset = offset.next_multiple_of(align);
            offset = offset.saturating_add(layout.size);
            max_align = max_align.max(align);
        }

        let total_size = offset.next_multiple_of(max_align);
        let final_layout = Layout::new(total_size, max_align);
        self.table.type_vector[struct_idx].layout = final_layout;
        states[struct_idx] = LayoutState::Visited;

        Ok(final_layout)
    }

    fn compute_impl_layout(
        &mut self,
        ty: CompTypeImplementationIndex,
        generic_args: &[CompTypeImplementationIndex],
        states: &mut [LayoutState],
        owner_struct: usize,
    ) -> Result<Layout, ()> {
        let entry = self.table.type_implementation_vector[ty.index()].clone();
        match entry {
            TypeImplementationEntry::Normal(TypeIndex(idx)) => {
                self.compute_struct_layout(idx, states)
            }
            TypeImplementationEntry::Enum(enum_idx) => {
                let base_ty = self.table.enum_vector[enum_idx].base_type;
                self.compute_impl_layout(base_ty, generic_args, states, owner_struct)
            }
            TypeImplementationEntry::GenericParameter(param_idx) => {
                if let Some(&arg_ty) = generic_args.get(param_idx) {
                    self.compute_impl_layout(arg_ty, &[], states, owner_struct)
                } else {
                    Ok(Layout::INVALID)
                }
            }
            TypeImplementationEntry::Pointered { .. }
            | TypeImplementationEntry::Function { .. } => Ok(Layout::new(8, 8)),
            TypeImplementationEntry::ConstantSizeArray { base, size } => {
                let elem = self.compute_impl_layout(base, generic_args, states, owner_struct)?;
                let total = elem.size.checked_mul(size).ok_or_else(|| {
                    if let Some((file, span)) = self.struct_locations[owner_struct].clone() {
                        self.error(&file, span, "Array type size overflows 64-bit layout");
                    }
                })?;
                Ok(Layout::new(total, elem.align))
            }
            TypeImplementationEntry::GenericImplementation {
                base: TypeIndex(idx),
                implementation,
            } => {
                if states[idx] == LayoutState::Visiting {
                    let name = self.format_path(&self.table.type_vector[idx].path);
                    if let Some((file, span)) = self.struct_locations[owner_struct].clone() {
                        self.error(
                            &file,
                            span,
                            &format!("Recursive generic struct '{}' has infinite size", name),
                        );
                    }
                    return Err(());
                }

                states[idx] = LayoutState::Visiting;
                let member_types: Vec<_> = self.table.type_vector[idx]
                    .members
                    .iter()
                    .map(|(_, ty)| *ty)
                    .collect();

                let mut offset: u64 = 0;
                let mut max_align: u64 = 1;
                for m_ty in member_types {
                    let layout =
                        self.compute_impl_layout(m_ty, &implementation, states, owner_struct)?;
                    let align = layout.align.max(1);
                    offset = offset.next_multiple_of(align).saturating_add(layout.size);
                    max_align = max_align.max(align);
                }
                states[idx] = LayoutState::Unvisited;

                Ok(Layout::new(offset.next_multiple_of(max_align), max_align))
            }
        }
    }
}

impl CompilationState {
    pub fn resolve(
        &mut self,
        files: &[ParsedFile],
        sym_table: SymbolTable,
    ) -> Result<SymbolTable, ()> {
        let struct_count = sym_table.type_vector.len();
        let mut ctx = ResolveCtx {
            state: self,
            table: sym_table,
            struct_generic_counts: HashMap::new(),
            struct_locations: vec![None; struct_count],
        };

        let root = CompilerPath::default();

        for ParsedFile(file, stmts) in files {
            for stmt in stmts {
                ctx.collect_struct_metadata(stmt, file, &root);
            }
        }

        for ParsedFile(file, stmts) in files {
            for stmt in stmts {
                ctx.walk_resolve(stmt, file, &root);
            }
        }

        if !ctx.state.has_errors() {
            ctx.compute_all_layouts();
        }

        let table = ctx.table;
        if self.has_errors() {
            Err(())
        } else {
            Ok(table)
        }
    }
}
