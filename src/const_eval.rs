use rcsharp_parser::defs::{BinaryOp, Expr, Stmt, StmtData, UnaryOp};
use rcsharp_syntax::{CompilerPath, Diagnostic, SourceFile, Span, Symbol};

use crate::{
    compiler::{CompilationState, SymbolTable},
    def::ConstantValue,
    loader::ParsedFile,
};

#[derive(Clone, Copy, PartialEq, Eq)]
enum EvalState {
    Unvisited,
    Visiting,
    Evaluated,
}

struct ConstAst {
    scope: CompilerPath,
    file: SourceFile,
    span: Span,
    expr: Expr,
}

struct EnumAst {
    scope: CompilerPath,
    file: SourceFile,
    span: Span,
    fields: Vec<(Symbol, Option<Expr>)>,
}

struct ConstEvalCtx<'a> {
    state: &'a mut CompilationState,
    table: SymbolTable,
    const_asts: Vec<Option<ConstAst>>,
    const_states: Vec<EvalState>,
    enum_asts: Vec<Option<EnumAst>>,
    enum_states: Vec<Vec<EvalState>>,
}

impl<'a> ConstEvalCtx<'a> {
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

    fn collect_items(&mut self, statement: &StmtData, file: &SourceFile, path: &CompilerPath) {
        match &statement.stmt {
            Stmt::Namespace(ns, body) => {
                let extended = path.extended(*ns);
                for item in body.iter() {
                    self.collect_items(item, file, &extended);
                }
            }
            Stmt::Block(stmts) => {
                for item in stmts.iter() {
                    self.collect_items(item, file, path);
                }
            }
            Stmt::ConstLet(ps) => {
                let full_path = path.extended(ps.name);
                let Some(idx) = self
                    .table
                    .cvar_vector
                    .iter()
                    .position(|x| x.path == full_path)
                else {
                    return;
                };

                let Some(expr) = ps.expr.clone() else {
                    self.error(
                        file,
                        statement.span,
                        "Constant declaration requires an initializer",
                    );
                    self.const_states[idx] = EvalState::Evaluated;
                    return;
                };

                self.const_asts[idx] = Some(ConstAst {
                    scope: path.clone(),
                    file: file.clone(),
                    span: statement.span,
                    expr,
                });
            }
            Stmt::Enum(ps) => {
                let full_path = path.extended(ps.name);
                let Some(idx) = self
                    .table
                    .enum_vector
                    .iter()
                    .position(|x| x.path == full_path)
                else {
                    return;
                };

                self.table.enum_vector[idx].fields = ps
                    .fields
                    .iter()
                    .map(|(name, _)| (*name, ConstantValue::Integer(0)))
                    .collect::<Vec<_>>()
                    .into_boxed_slice();

                self.enum_states[idx] = vec![EvalState::Unvisited; ps.fields.len()];
                self.enum_asts[idx] = Some(EnumAst {
                    scope: path.clone(),
                    file: file.clone(),
                    span: statement.span,
                    fields: ps.fields.to_vec(),
                });
            }
            Stmt::StaticLet(ps) => {
                let full_path = path.extended(ps.name);
                if let Some(idx) = self
                    .table
                    .svar_vector
                    .iter()
                    .position(|x| x.path == full_path)
                {
                    self.table.svar_vector[idx].expression = ps.expr.clone();
                }
            }
            _ => {}
        }
    }

    fn eval_const(&mut self, idx: usize) -> Result<ConstantValue, ()> {
        match self.const_states[idx] {
            EvalState::Evaluated => return Ok(self.table.cvar_vector[idx].expression),
            EvalState::Visiting => {
                if let Some(ast) = &self.const_asts[idx] {
                    let file = ast.file.clone();
                    let span = ast.span;
                    let name = self.format_path(&self.table.cvar_vector[idx].path);
                    self.error(
                        &file,
                        span,
                        &format!("Cyclic constant definition involving '{}'", name),
                    );
                }
                return Err(());
            }
            EvalState::Unvisited => {}
        }

        let Some(ast) = self.const_asts[idx].as_ref() else {
            return Err(());
        };
        let scope = ast.scope.clone();
        let file = ast.file.clone();
        let span = ast.span;
        let expr = ast.expr.clone();

        self.const_states[idx] = EvalState::Visiting;
        let val = self.eval_expr(&expr, &scope, &file, span);

        match val {
            Ok(v) => {
                self.table.cvar_vector[idx].expression = v;
                self.const_states[idx] = EvalState::Evaluated;
                Ok(v)
            }
            Err(()) => {
                self.const_states[idx] = EvalState::Evaluated;
                Err(())
            }
        }
    }

    fn eval_enum_variant(
        &mut self,
        enum_idx: usize,
        field_idx: usize,
    ) -> Result<ConstantValue, ()> {
        match self.enum_states[enum_idx][field_idx] {
            EvalState::Evaluated => return Ok(self.table.enum_vector[enum_idx].fields[field_idx].1),
            EvalState::Visiting => {
                if let Some(ast) = &self.enum_asts[enum_idx] {
                    let file = ast.file.clone();
                    let span = ast.span;
                    let enum_name = self.format_path(&self.table.enum_vector[enum_idx].path);
                    let field_name = self.table.interner.get(ast.fields[field_idx].0);
                    self.error(
                        &file,
                        span,
                        &format!("Cyclic enum variant '{}::{}'", enum_name, field_name),
                    );
                }
                return Err(());
            }
            EvalState::Unvisited => {}
        }

        let Some(ast) = self.enum_asts[enum_idx].as_ref() else {
            return Err(());
        };
        let scope = ast.scope.clone();
        let file = ast.file.clone();
        let span = ast.span;
        let maybe_expr = ast.fields[field_idx].1.clone();

        self.enum_states[enum_idx][field_idx] = EvalState::Visiting;

        let val = match maybe_expr {
            Some(expr) => self.eval_expr(&expr, &scope, &file, span),
            None => {
                if field_idx == 0 {
                    Ok(ConstantValue::Integer(0))
                } else {
                    match self.eval_enum_variant(enum_idx, field_idx - 1)? {
                        ConstantValue::Integer(prev) => prev
                            .checked_add(1)
                            .map(ConstantValue::Integer)
                            .ok_or_else(|| {
                                self.error(&file, span, "Enum variant value overflows i64");
                            }),
                        _ => {
                            self.error(
                                &file,
                                span,
                                "Cannot auto-increment non-integer enum variant",
                            );
                            Err(())
                        }
                    }
                }
            }
        };

        match val {
            Ok(v) => {
                self.table.enum_vector[enum_idx].fields[field_idx].1 = v;
                self.enum_states[enum_idx][field_idx] = EvalState::Evaluated;
                Ok(v)
            }
            Err(()) => {
                self.enum_states[enum_idx][field_idx] = EvalState::Evaluated;
                Err(())
            }
        }
    }

    fn lookup_const(&self, loc: &[Symbol], scope: &CompilerPath) -> Option<usize> {
        for prefix_len in (0..=scope.0.len()).rev() {
            let prefix = &scope.0[..prefix_len];
            if let Some(idx) = self.table.cvar_vector.iter().position(|c| {
                c.path.0.len() == prefix.len() + loc.len()
                    && c.path.0[..prefix.len()] == *prefix
                    && c.path.0[prefix.len()..] == *loc
            }) {
                return Some(idx);
            }
        }
        None
    }

    fn lookup_enum(&self, loc: &[Symbol], scope: &CompilerPath) -> Option<usize> {
        for prefix_len in (0..=scope.0.len()).rev() {
            let prefix = &scope.0[..prefix_len];
            if let Some(idx) = self.table.enum_vector.iter().position(|e| {
                e.path.0.len() == prefix.len() + loc.len()
                    && e.path.0[..prefix.len()] == *prefix
                    && e.path.0[prefix.len()..] == *loc
            }) {
                return Some(idx);
            }
        }
        None
    }

    fn flatten_static_path(expr: &Expr) -> Option<Vec<Symbol>> {
        match expr {
            Expr::Name(sym) => Some(vec![*sym]),
            Expr::StaticAccess(lhs, sym) => {
                let mut parts = Self::flatten_static_path(lhs)?;
                parts.push(*sym);
                Some(parts)
            }
            _ => None,
        }
    }

    fn eval_expr(
        &mut self,
        expr: &Expr,
        scope: &CompilerPath,
        file: &SourceFile,
        span: Span,
    ) -> Result<ConstantValue, ()> {
        match expr {
            Expr::Integer(sym) => match self.table.interner.integer_value(*sym) {
                Ok(n) => Ok(ConstantValue::Integer(n)),
                Err(err) => {
                    self.state.diagnostics.push(Diagnostic::error_w_error(
                        file,
                        "Invalid integer literal in constant expression",
                        span,
                        err,
                    ));
                    Err(())
                }
            },
            Expr::Decimal(sym) => {
                let raw = self.table.interner.get(*sym);
                match raw.parse::<f64>() {
                    Ok(f) => Ok(ConstantValue::Decimal(f)),
                    Err(err) => {
                        self.state.diagnostics.push(Diagnostic::error_w_error(
                            file,
                            "Invalid decimal literal in constant expression",
                            span,
                            err,
                        ));
                        Err(())
                    }
                }
            }
            Expr::Char(ch) => Ok(ConstantValue::Char(*ch)),
            Expr::Boolean(b) => Ok(ConstantValue::Boolean(*b)),

            Expr::Name(sym) => {
                if let Some(idx) = self.lookup_const(&[*sym], scope) {
                    return self.eval_const(idx);
                }
                let name = self.table.interner.get(*sym);
                self.error(
                    file,
                    span,
                    &format!("Unknown constant '{}' in constant expression", name),
                );
                Err(())
            }

            Expr::StaticAccess(lhs, member) => {
                let Some(mut full) = Self::flatten_static_path(lhs) else {
                    self.error(file, span, "Invalid path in constant expression");
                    return Err(());
                };

                if let Some(enum_idx) = self.lookup_enum(&full, scope) {
                    if let Some(field_idx) = self.table.enum_vector[enum_idx]
                        .fields
                        .iter()
                        .position(|(name, _)| *name == *member)
                    {
                        return self.eval_enum_variant(enum_idx, field_idx);
                    }
                    let enum_name = self.format_path(&self.table.enum_vector[enum_idx].path);
                    let member_name = self.table.interner.get(*member);
                    self.error(
                        file,
                        span,
                        &format!("Enum '{}' has no variant '{}'", enum_name, member_name),
                    );
                    return Err(());
                }

                full.push(*member);
                if let Some(const_idx) = self.lookup_const(&full, scope) {
                    return self.eval_const(const_idx);
                }

                let joined = full
                    .iter()
                    .map(|s| self.table.interner.get(*s))
                    .collect::<Vec<_>>()
                    .join("::");
                self.error(
                    file,
                    span,
                    &format!("Unknown constant or enum variant '{}'", joined),
                );
                Err(())
            }

            Expr::UnaryOp(op, inner) => {
                let val = self.eval_expr(inner, scope, file, span)?;
                match (op, val) {
                    (UnaryOp::Negate, ConstantValue::Integer(n)) => n
                        .checked_neg()
                        .map(ConstantValue::Integer)
                        .ok_or_else(|| self.error(file, span, "Integer overflow in unary '-'")),
                    (UnaryOp::Negate, ConstantValue::Decimal(f)) => Ok(ConstantValue::Decimal(-f)),
                    (UnaryOp::BitNot, ConstantValue::Integer(n)) => Ok(ConstantValue::Integer(!n)),
                    (UnaryOp::Not, ConstantValue::Boolean(b)) => Ok(ConstantValue::Boolean(!b)),
                    _ => {
                        self.error(
                            file,
                            span,
                            "Invalid operand type for unary constant operator",
                        );
                        Err(())
                    }
                }
            }

            Expr::BinaryOp(lhs, op, rhs) => {
                let l = self.eval_expr(lhs, scope, file, span)?;
                let r = self.eval_expr(rhs, scope, file, span)?;
                self.eval_binary(*op, l, r, file, span)
            }

            Expr::Cast(inner, _) => self.eval_expr(inner, scope, file, span),

            _ => {
                self.error(file, span, "Expression is not a compile-time constant");
                Err(())
            }
        }
    }

    fn eval_binary(
        &mut self,
        op: BinaryOp,
        lhs: ConstantValue,
        rhs: ConstantValue,
        file: &SourceFile,
        span: Span,
    ) -> Result<ConstantValue, ()> {
        match (lhs, rhs) {
            (ConstantValue::Integer(a), ConstantValue::Integer(b)) => match op {
                BinaryOp::Add => a
                    .checked_add(b)
                    .map(ConstantValue::Integer)
                    .ok_or_else(|| self.error(file, span, "Integer overflow in constant '+'")),
                BinaryOp::Subtract => a
                    .checked_sub(b)
                    .map(ConstantValue::Integer)
                    .ok_or_else(|| self.error(file, span, "Integer overflow in constant '-'")),
                BinaryOp::Multiply => a
                    .checked_mul(b)
                    .map(ConstantValue::Integer)
                    .ok_or_else(|| self.error(file, span, "Integer overflow in constant '*'")),
                BinaryOp::Divide => {
                    if b == 0 {
                        self.error(file, span, "Division by zero in constant expression");
                        return Err(());
                    }
                    a.checked_div(b)
                        .map(ConstantValue::Integer)
                        .ok_or_else(|| self.error(file, span, "Integer overflow in constant '/'"))
                }
                BinaryOp::Modulo => {
                    if b == 0 {
                        self.error(file, span, "Modulo by zero in constant expression");
                        return Err(());
                    }
                    a.checked_rem(b)
                        .map(ConstantValue::Integer)
                        .ok_or_else(|| self.error(file, span, "Integer overflow in constant '%'"))
                }
                BinaryOp::BitAnd => Ok(ConstantValue::Integer(a & b)),
                BinaryOp::BitOr => Ok(ConstantValue::Integer(a | b)),
                BinaryOp::BitXor => Ok(ConstantValue::Integer(a ^ b)),
                BinaryOp::ShiftLeft => {
                    let shift = u32::try_from(b).ok().filter(|&s| s < 64).ok_or_else(|| {
                        self.error(file, span, "Invalid shift amount in constant '<<'")
                    })?;
                    Ok(ConstantValue::Integer(a.wrapping_shl(shift)))
                }
                BinaryOp::ShiftRight => {
                    let shift = u32::try_from(b).ok().filter(|&s| s < 64).ok_or_else(|| {
                        self.error(file, span, "Invalid shift amount in constant '>>'")
                    })?;
                    Ok(ConstantValue::Integer(a.wrapping_shr(shift)))
                }
                BinaryOp::Equals => Ok(ConstantValue::Boolean(a == b)),
                BinaryOp::NotEqual => Ok(ConstantValue::Boolean(a != b)),
                BinaryOp::Less => Ok(ConstantValue::Boolean(a < b)),
                BinaryOp::LessEqual => Ok(ConstantValue::Boolean(a <= b)),
                BinaryOp::Greater => Ok(ConstantValue::Boolean(a > b)),
                BinaryOp::GreaterEqual => Ok(ConstantValue::Boolean(a >= b)),
                _ => {
                    self.error(file, span, "Invalid binary operator for integer constants");
                    Err(())
                }
            },
            (ConstantValue::Decimal(a), ConstantValue::Decimal(b)) => match op {
                BinaryOp::Add => Ok(ConstantValue::Decimal(a + b)),
                BinaryOp::Subtract => Ok(ConstantValue::Decimal(a - b)),
                BinaryOp::Multiply => Ok(ConstantValue::Decimal(a * b)),
                BinaryOp::Divide => Ok(ConstantValue::Decimal(a / b)),
                BinaryOp::Equals => Ok(ConstantValue::Boolean(a == b)),
                BinaryOp::NotEqual => Ok(ConstantValue::Boolean(a != b)),
                BinaryOp::Less => Ok(ConstantValue::Boolean(a < b)),
                BinaryOp::LessEqual => Ok(ConstantValue::Boolean(a <= b)),
                BinaryOp::Greater => Ok(ConstantValue::Boolean(a > b)),
                BinaryOp::GreaterEqual => Ok(ConstantValue::Boolean(a >= b)),
                _ => {
                    self.error(file, span, "Invalid binary operator for decimal constants");
                    Err(())
                }
            },
            (ConstantValue::Boolean(a), ConstantValue::Boolean(b)) => match op {
                BinaryOp::And => Ok(ConstantValue::Boolean(a && b)),
                BinaryOp::Or => Ok(ConstantValue::Boolean(a || b)),
                BinaryOp::Equals => Ok(ConstantValue::Boolean(a == b)),
                BinaryOp::NotEqual => Ok(ConstantValue::Boolean(a != b)),
                _ => {
                    self.error(file, span, "Invalid binary operator for boolean constants");
                    Err(())
                }
            },
            _ => {
                self.error(
                    file,
                    span,
                    "Mismatched or unsupported constant operand types",
                );
                Err(())
            }
        }
    }
}

impl CompilationState {
    pub fn constant_resolve(
        &mut self,
        files: &[ParsedFile],
        sym_table: SymbolTable,
    ) -> Result<SymbolTable, ()> {
        let cvar_len = sym_table.cvar_vector.len();
        let enum_len = sym_table.enum_vector.len();

        let mut ctx = ConstEvalCtx {
            state: self,
            table: sym_table,
            const_asts: (0..cvar_len).map(|_| None).collect(),
            const_states: vec![EvalState::Unvisited; cvar_len],
            enum_asts: (0..enum_len).map(|_| None).collect(),
            enum_states: vec![Vec::new(); enum_len],
        };

        let root = CompilerPath::default();
        for ParsedFile(file, stmts) in files {
            for stmt in stmts {
                ctx.collect_items(stmt, file, &root);
            }
        }

        for i in 0..cvar_len {
            let _ = ctx.eval_const(i);
        }

        for e_idx in 0..enum_len {
            let field_count = ctx.table.enum_vector[e_idx].fields.len();
            for f_idx in 0..field_count {
                let _ = ctx.eval_enum_variant(e_idx, f_idx);
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
