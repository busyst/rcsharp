use rcsharp_parser::{
    expression_parser::{Expr, UnaryOp},
    parser::{Stmt, StmtData},
};

use crate::{
    compiler::{context::CompilerContext, passes::traits::CompilerPass},
    compiler_essentials::CompileResult,
    expression_compiler::constant_expression_optimizer_base,
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
                Stmt::ConstLet(_, _, expr) => self.optimize_expression_tree(expr),
                Stmt::Let(_, _, Some(expr)) => self.optimize_expression_tree(expr),
                Stmt::Static(_, _, Some(expr)) => self.optimize_expression_tree(expr),
                Stmt::Return(Some(expr)) => self.optimize_expression_tree(expr),

                Stmt::If(cond, then_block, else_block) => {
                    self.optimize_expression_tree(cond);
                    if let Expr::Boolean(val) = cond {
                        return Ok(if *val {
                            self.optimize_block(then_block)?;
                            stmt_data.stmt = Stmt::Block(then_block.clone());
                            println!("OPT: Pruned dead ELSE branch (cond is true)");
                        } else {
                            self.optimize_block(else_block)?;
                            stmt_data.stmt = Stmt::Block(else_block.clone());
                            println!("OPT: Pruned dead THEN branch (cond is false)");
                        });
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
            Expr::Call(_, args) => {
                for arg in args {
                    self.optimize_expression_tree(arg);
                }
            }
            Expr::CallGeneric(_, args, ..) => {
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
}
