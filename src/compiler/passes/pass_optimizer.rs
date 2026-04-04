use std::collections::HashSet;

use rcsharp_parser::{
    defs::{Stmt, StmtData},
    expression_parser::{BinaryOp, Expr, UnaryOp},
};

use crate::{
    compiler::{
        context::{CompilerConfig, CompilerContext},
        passes::traits::CompilerPass,
        structs::LLVMInstruction,
    },
    compiler_essentials::{CompileResult, LLVMVal},
    compiler_functions::COMPILER_FUNCTIONS,
};

#[derive(Default)]
pub struct OptimizerPass {}
impl<'a> CompilerPass<'a> for OptimizerPass {
    type Input = ();

    type Output = ();

    fn run(&mut self, _: Self::Input, ctx: &mut CompilerContext) -> CompileResult<Self::Output> {
        for func in ctx.symbols.functions_iter_mut() {
            if !func.1.body.is_empty() {
                self.optimize_block(&mut func.1.body)?;
                self.remove_unreachable_code(&mut func.1.body)?;
            }
        }
        Ok(())
    }
}
impl OptimizerPass {
    fn optimize_block(&mut self, body: &mut [StmtData]) -> CompileResult<()> {
        for stmt_data in body.iter_mut() {
            match &mut stmt_data.stmt {
                Stmt::Expr(expr) => self.optimize_expression_tree(expr),
                Stmt::StaticLet(var) | Stmt::ConstLet(var) | Stmt::Let(var) => {
                    if let Some(x) = &mut var.expr {
                        self.optimize_expression_tree(x)
                    }
                }
                Stmt::Return(Some(expr)) => self.optimize_expression_tree(expr),

                Stmt::If(cond, then_block, else_block) => {
                    self.optimize_expression_tree(cond);
                    if let Expr::Boolean(val) = cond {
                        if *val {
                            self.optimize_block(then_block)?;
                            stmt_data.stmt = Stmt::Block(then_block.clone());
                            println!("OPT: Pruned dead ELSE branch (cond is true)");
                        } else {
                            self.optimize_block(else_block)?;
                            stmt_data.stmt = Stmt::Block(else_block.clone());
                            println!("OPT: Pruned dead THEN branch (cond is false)");
                        }
                        continue;
                    }
                    self.optimize_block(then_block)?;
                    self.optimize_block(else_block)?;
                    if matches!(cond, Expr::UnaryOp(UnaryOp::Not, _)) && !else_block.is_empty() {
                        if let Expr::UnaryOp(UnaryOp::Not, inner) = cond {
                            std::mem::swap(then_block, else_block);
                            *cond = *inner.clone();
                            println!("OPT: Simplified if(!x) by swapping branches");
                        }
                    } else if then_block.is_empty() && !else_block.is_empty() {
                        std::mem::swap(then_block, else_block);
                        *cond = Expr::UnaryOp(UnaryOp::Not, Box::new(cond.clone()));
                        println!("OPT: Swapped empty IF body with ELSE");
                    }
                }

                Stmt::Loop(block) => self.optimize_block(block)?,
                Stmt::Block(block) => self.optimize_block(block)?,
                _ => {}
            }
        }
        Ok(())
    }
    fn optimize_expression_tree(&mut self, expr: &mut Expr) {
        match expr {
            Expr::BinaryOp(left, _, right) => {
                self.optimize_expression_tree(left);
                self.optimize_expression_tree(right);
            }
            Expr::UnaryOp(_, inner) => {
                self.optimize_expression_tree(inner);
            }
            Expr::Call(name, args) => {
                if let Expr::Name(x) = &**name {
                    if let Some((Some(f), _)) = COMPILER_FUNCTIONS
                        .iter()
                        .find(|(name, _, _, _)| name == x)
                        .map(|x| x.3)
                        .flatten()
                    {
                        let Ok(ex) = f(args) else {
                            return;
                        };
                        *expr = ex;
                        return;
                    }
                }
                for arg in args {
                    self.optimize_expression_tree(arg);
                }
            }
            Expr::CallGeneric(name, args, pt) => {
                if let Expr::Name(x) = &**name {
                    if let Some((_, Some(f))) = COMPILER_FUNCTIONS
                        .iter()
                        .find(|(name, _, _, _)| name == x)
                        .map(|x| x.3)
                        .flatten()
                    {
                        let Ok(ex) = f(args, pt) else {
                            return;
                        };
                        *expr = ex;
                        return;
                    }
                }
                for arg in args {
                    self.optimize_expression_tree(arg);
                }
            }
            Expr::MemberAccess(inner, _) => {
                self.optimize_expression_tree(inner);
            }
            Expr::Index(arr, idx) => {
                self.optimize_expression_tree(arr);
                self.optimize_expression_tree(idx);
            }
            _ => {}
        }

        if let Some(optimized) = constant_expression_optimizer_base(expr) {
            println!(
                "Opt: Folded {} -> {}",
                expr.debug_emit(),
                optimized.debug_emit()
            );
            *expr = optimized;
        }
    }
    fn remove_unreachable_code(&mut self, body: &mut Box<[StmtData]>) -> CompileResult<()> {
        if let Some(termination_index) = body
            .iter()
            .position(|x| matches!(x.stmt, Stmt::Return(..) | Stmt::Break | Stmt::Continue))
        {
            if termination_index < body.len() - 1 {
                let saved_count = body.len() - (termination_index + 1);
                println!("OPT: Removed {} unreachable statements", saved_count);

                let (keep, _) = body.split_at(termination_index + 1);
                *body = keep.to_vec().into_boxed_slice();
            }
        }
        for stmt in body.iter_mut() {
            match &mut stmt.stmt {
                Stmt::Loop(inner) => self.remove_unreachable_code(inner)?,
                Stmt::If(_, then_block, else_block) => {
                    self.remove_unreachable_code(then_block)?;
                    self.remove_unreachable_code(else_block)?;
                }
                _ => {}
            }
        }

        Ok(())
    }

    pub fn optimize_llvm_instructions(
        mut vec: Vec<LLVMInstruction>,
        _cfg: &CompilerConfig,
    ) -> Vec<LLVMInstruction> {
        Self::remove_unnecesary_labels(&mut vec);
        vec
    }
    fn remove_unnecesary_labels(vec: &mut Vec<LLVMInstruction>) {
        let mut one: HashSet<String> = HashSet::new();
        let mut mult: HashSet<String> = HashSet::new();
        for (idx, x) in vec.iter().enumerate() {
            match x {
                LLVMInstruction::Jump { label } => {
                    if mult.contains(label) {
                        continue;
                    }
                    if vec
                        .get(idx + 1)
                        .filter(|x| {
                            if let LLVMInstruction::Label { name: n_label } = *x {
                                *n_label == *label
                            } else {
                                false
                            }
                        })
                        .is_none()
                    {
                        mult.insert(label.clone());
                        continue;
                    }
                    if one.contains(label) {
                        mult.insert(label.clone());
                        one.remove(label);
                        continue;
                    }
                    one.insert(label.clone());
                }
                LLVMInstruction::Branch {
                    condition_val: _,
                    then_label_name,
                    else_label_name,
                } => {
                    one.remove(then_label_name);
                    mult.insert(then_label_name.clone());
                    one.remove(else_label_name);
                    mult.insert(else_label_name.clone());
                }
                LLVMInstruction::Phi {
                    target_reg: _,
                    result_type: _,
                    incoming,
                } => {
                    for (_, label) in incoming {
                        one.remove(label);
                        mult.insert(label.clone());
                    }
                }
                _ => {}
            }
        }
        for x in vec {
            match x {
                LLVMInstruction::Label { name } => {
                    if !mult.contains(name) {
                        *x = LLVMInstruction::Empty;
                    }
                }
                LLVMInstruction::Jump { label } => {
                    if !mult.contains(label) {
                        *x = LLVMInstruction::Empty;
                    }
                }
                _ => {}
            }
        }
    }
}

pub fn constant_expression_optimizer_base(expr: &Expr) -> Option<Expr> {
    match expr {
        Expr::Integer(..) | Expr::Boolean(..) | Expr::Decimal(..) => None,
        Expr::UnaryOp(op, inner) => {
            if let Some(x) = constant_expression_compiler(expr) {
                match x {
                    LLVMVal::ConstantInteger(val) => return Some(Expr::Integer(val)),
                    LLVMVal::ConstantBoolean(val) => return Some(Expr::Boolean(val)),
                    LLVMVal::ConstantDecimal(val) => return Some(Expr::Decimal(val)),
                    _ => {}
                }
            }
            let opt_e = constant_expression_optimizer_base(inner);
            if let Some(new_inner) = opt_e {
                Some(Expr::UnaryOp(*op, Box::new(new_inner)))
            } else {
                None
            }
        }
        Expr::BinaryOp(lhs, op, rhs) => {
            if let Some(x) = constant_expression_compiler(expr) {
                match x {
                    LLVMVal::ConstantInteger(val) => return Some(Expr::Integer(val)),
                    LLVMVal::ConstantBoolean(val) => return Some(Expr::Boolean(val)),
                    LLVMVal::ConstantDecimal(val) => return Some(Expr::Decimal(val)),
                    _ => {}
                }
            }
            let opt_l = constant_expression_optimizer_base(lhs);
            let opt_r = constant_expression_optimizer_base(rhs);
            if opt_l.is_none() && opt_r.is_none() {
                if matches!(**lhs, Expr::Integer(..))
                    && !matches!(**rhs, Expr::Integer(..))
                    && op.is_symmetric()
                {
                    return Some(Expr::BinaryOp(rhs.clone(), *op, lhs.clone()));
                }
                return None;
            }
            let final_l = opt_l.map(Box::new).unwrap_or_else(|| lhs.clone());
            let final_r = opt_r.map(Box::new).unwrap_or_else(|| rhs.clone());
            Some(Expr::BinaryOp(final_l, *op, final_r))
        }
        Expr::Assign(lhs, rhs) => constant_expression_optimizer_base(rhs)
            .map(|new_rhs| Expr::Assign(lhs.clone(), Box::new(new_rhs))),
        Expr::Index(arr, idx) => constant_expression_optimizer_base(idx)
            .map(|new_idx| Expr::Index(arr.clone(), Box::new(new_idx))),
        Expr::Call(callee, args) => {
            let mut changed = false;
            let new_args = args
                .iter()
                .map(|arg| {
                    if let Some(opt) = constant_expression_optimizer_base(arg) {
                        changed = true;
                        opt
                    } else {
                        arg.clone()
                    }
                })
                .collect();

            if changed {
                Some(Expr::Call(callee.clone(), new_args))
            } else {
                None
            }
        }
        _ => None,
    }
}
pub fn constant_expression_compiler(expr: &Expr) -> Option<LLVMVal> {
    match expr {
        Expr::Integer(x) => Some(LLVMVal::ConstantInteger(*x)),
        Expr::Boolean(b) => Some(LLVMVal::ConstantBoolean(*b)),
        Expr::Decimal(x) => Some(LLVMVal::ConstantDecimal(*x)),
        Expr::BinaryOp(lhs, op, rhs) => fold_binary_op(lhs, op, rhs),
        Expr::UnaryOp(op, rhs) => fold_unary_op(op, rhs),
        _ => None,
    }
}
fn fold_binary_op(lhs: &Expr, op: &BinaryOp, rhs: &Expr) -> Option<LLVMVal> {
    let l_val = constant_expression_compiler(lhs)?;
    let r_val = constant_expression_compiler(rhs)?;

    match (l_val, r_val) {
        (LLVMVal::ConstantInteger(l), LLVMVal::ConstantInteger(r)) => {
            let res = match op {
                BinaryOp::Add => l.wrapping_add(r),
                BinaryOp::Subtract => l.wrapping_sub(r),
                BinaryOp::Multiply => l.wrapping_mul(r),
                BinaryOp::Divide => l.checked_div(r)?,
                BinaryOp::Modulo => l.checked_rem(r)?,
                BinaryOp::And | BinaryOp::BitAnd => l & r,
                BinaryOp::Or | BinaryOp::BitOr => l | r,
                BinaryOp::BitXor => l ^ r,
                BinaryOp::ShiftLeft => l.wrapping_shl(r as u32),
                BinaryOp::ShiftRight => l.wrapping_shr(r as u32),
                // Comparisons
                BinaryOp::Equals => return Some(LLVMVal::ConstantBoolean(l == r)),
                BinaryOp::NotEqual => return Some(LLVMVal::ConstantBoolean(l != r)),
                BinaryOp::Less => return Some(LLVMVal::ConstantBoolean(l < r)),
                BinaryOp::LessEqual => return Some(LLVMVal::ConstantBoolean(l <= r)),
                BinaryOp::Greater => return Some(LLVMVal::ConstantBoolean(l > r)),
                BinaryOp::GreaterEqual => return Some(LLVMVal::ConstantBoolean(l >= r)),
            };
            Some(LLVMVal::ConstantInteger(res))
        }
        (LLVMVal::ConstantDecimal(l), LLVMVal::ConstantDecimal(r)) => {
            let res = match op {
                BinaryOp::Add => l + r,
                BinaryOp::Subtract => l - r,
                BinaryOp::Multiply => l * r,
                BinaryOp::Divide => l / r,
                BinaryOp::Modulo => l % r,
                // Comparisons
                BinaryOp::Equals => return Some(LLVMVal::ConstantBoolean(l == r)),
                BinaryOp::NotEqual => return Some(LLVMVal::ConstantBoolean(l != r)),
                BinaryOp::Less => return Some(LLVMVal::ConstantBoolean(l < r)),
                BinaryOp::LessEqual => return Some(LLVMVal::ConstantBoolean(l <= r)),
                BinaryOp::Greater => return Some(LLVMVal::ConstantBoolean(l > r)),
                BinaryOp::GreaterEqual => return Some(LLVMVal::ConstantBoolean(l >= r)),
                _ => return None,
            };
            Some(LLVMVal::ConstantDecimal(res))
        }
        (LLVMVal::ConstantBoolean(l), LLVMVal::ConstantBoolean(r)) => {
            let res = match op {
                BinaryOp::And | BinaryOp::BitAnd => l & r,
                BinaryOp::Or | BinaryOp::BitOr => l | r,
                BinaryOp::BitXor => l ^ r,
                // Comparisons
                BinaryOp::Equals => return Some(LLVMVal::ConstantBoolean(l == r)),
                BinaryOp::NotEqual => return Some(LLVMVal::ConstantBoolean(l != r)),
                BinaryOp::Less => return Some(LLVMVal::ConstantBoolean(l < r)),
                BinaryOp::LessEqual => return Some(LLVMVal::ConstantBoolean(l <= r)),
                BinaryOp::Greater => return Some(LLVMVal::ConstantBoolean(l > r)),
                BinaryOp::GreaterEqual => return Some(LLVMVal::ConstantBoolean(l >= r)),
                _ => return None,
            };
            Some(LLVMVal::ConstantBoolean(res))
        }
        // Identity
        (l, r) => {
            if l == r {
                match op {
                    BinaryOp::Subtract | BinaryOp::BitXor => {
                        return Some(LLVMVal::ConstantInteger(0))
                    }
                    BinaryOp::Equals | BinaryOp::GreaterEqual | BinaryOp::LessEqual => {
                        return Some(LLVMVal::ConstantBoolean(true))
                    }
                    BinaryOp::NotEqual | BinaryOp::Less | BinaryOp::Greater => {
                        return Some(LLVMVal::ConstantBoolean(false))
                    }
                    _ => {}
                }
            }

            if let LLVMVal::ConstantInteger(v) = r {
                match op {
                    BinaryOp::Add
                    | BinaryOp::Subtract
                    | BinaryOp::BitOr
                    | BinaryOp::BitXor
                    | BinaryOp::ShiftLeft
                    | BinaryOp::ShiftRight
                        if v == 0 =>
                    {
                        return Some(l)
                    }
                    BinaryOp::Multiply if v == 1 => return Some(l),
                    BinaryOp::Multiply | BinaryOp::BitAnd if v == 0 => return Some(r), // 0
                    _ => {}
                }
            }
            None
        }
    }
}
fn fold_unary_op(op: &UnaryOp, rhs: &Expr) -> Option<LLVMVal> {
    let r_val = constant_expression_compiler(rhs)?;
    match r_val {
        LLVMVal::ConstantInteger(r) => match op {
            UnaryOp::Negate => Some(LLVMVal::ConstantInteger(-r)),
            _ => None,
        },
        LLVMVal::ConstantDecimal(r) => match op {
            UnaryOp::Negate => Some(LLVMVal::ConstantDecimal(-r)),
            _ => None,
        },
        LLVMVal::ConstantBoolean(r) => match op {
            UnaryOp::Not => Some(LLVMVal::ConstantBoolean(!r)),
            _ => None,
        },
        _ => None,
    }
}
