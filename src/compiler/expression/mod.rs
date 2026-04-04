use std::{collections::HashMap, sync::Arc};

use rcsharp_parser::{
    compiler_primitives::{
        find_primitive_type, BOOL_TYPE, CHAR_TYPE, DEFAULT_DECIMAL_TYPE, DEFAULT_INTEGER_TYPE,
        POINTER_SIZED_TYPE,
    },
    defs::{Stmt, StmtData},
    expression_parser::{expr_to_type_path, BinaryOp, Expr, UnaryOp},
    parser::ParserType,
};

use crate::{
    compiler::{
        context::CompilerContext,
        passes::pass_llvm_gen::{CodeGenContext, LLVMGenPass},
        structs::{CompiledValue, ContextPath, ContextPathEnd, Expected, LLVMInstruction},
    },
    compiler_essentials::{
        CompiledLValue, CompilerError, CompilerType, LLVMVal, SymbolTable, Variable,
    },
    compiler_functions::{COMPILER_FUNCTIONS, COMPILER_MACROS},
};
pub type ExpressionCompileResult<T> = Result<T, CompilerError>;
#[derive(PartialEq, Eq)]
pub enum LValueAccess {
    Read,
    Write,
    ModifyContent,
}
pub struct ExpressionCompiler<'a> {
    ctx: &'a CodeGenContext,
    compctx: &'a CompilerContext,
}

impl<'a> ExpressionCompiler<'a> {
    pub fn new(ctx: &'a CodeGenContext, compctx: &'a CompilerContext) -> Self {
        Self { ctx, compctx }
    }
    pub fn compile_rvalue(
        &self,
        expr: &Expr,
        expected: Expected,
    ) -> ExpressionCompileResult<(CompiledValue, Vec<LLVMInstruction>)> {
        match expr {
            Expr::Name(name) => {
                self.compile_name_rvalue(ContextPathEnd::from_path("", name), expected)
            }
            Expr::StaticAccess(obj, member) => {
                self.compile_static_access_rvalue(obj, member, expected)
            }
            Expr::Integer(num) => self.compile_integer_literal(*num, expected),
            Expr::Decimal(num) => Ok(self.compile_decimal_literal(*num, expected)),
            Expr::Boolean(val) => self.compile_boolean_literal(*val, expected),
            Expr::StringConst(s) => self.compile_string_literal(s, expected),
            Expr::NullPtr => self.compile_nullptr(expected),
            Expr::UnaryOp(op, operand_expr) => {
                self.compile_unary_op_rvalue(op, operand_expr, expected)
            }
            Expr::Index(array, index) => self.compile_index_rvalue(array, index),
            Expr::BinaryOp(lhs, op, rhs) => self.compile_binary_op(lhs, op, rhs, expected),
            Expr::StructInit(name, inits) => self.compile_struct_init(name, inits),
            Expr::MemberAccess(obj, member) => self.compile_member_access_rvalue(obj, member),
            Expr::Call(callee, args) => self.compile_call(callee, args, None, expected),
            Expr::MacroCall(callee, args) => self.compile_macro_call(callee, args, expected),
            Expr::CallGeneric(callee, args, generics) => {
                self.compile_call(callee, args, Some(generics), expected)
            }
            Expr::Assign(lhs, rhs) => self.compile_assignment(lhs, rhs, expected),
            Expr::Cast(expr, target_type) => self.compile_cast(expr, target_type, expected),
            _ => Err(CompilerError::Generic(format!("Not a rvalue {:?}", expr))),
        }
    }
    pub fn compile_name_rvalue(
        &self,
        name: ContextPathEnd,
        _expected: Expected,
    ) -> ExpressionCompileResult<(CompiledValue, Vec<LLVMInstruction>)> {
        let name_str = name.to_string();
        if let Some((var, id)) = self.ctx.scope.lookup(&name_str) {
            var.mark_usage(false, false);
            if var.get_flags().is_constant {
                return Ok((
                    CompiledValue::new_value(
                        var.value().borrow().clone().unwrap(),
                        var.compiler_type().clone(),
                    ),
                    vec![],
                ));
            }
            let mut var_type = var.compiler_type().clone();
            var_type.substitute_global_aliases(self.symbols())?;
            return var.load_llvm_value(*id, &name_str, self.ctx(), var_type);
        }
        if let Some(internal_id) = self.resolve_path(&name, |s, p| s.get_function_id_by_path(p)) {
            return Ok((
                if self
                    .symbols()
                    .get_function_by_id_use(internal_id)
                    .is_generic()
                {
                    CompiledValue::GenericFunction { internal_id }
                } else {
                    CompiledValue::Function { internal_id }
                },
                vec![],
            ));
        }
        if let Some((path, variable)) = self.resolve_path(&name, |s, p| s.get_static_by_path(p)) {
            let mut vtype = variable.compiler_type.clone();
            vtype.substitute_global_aliases(self.symbols())?;
            variable.mark_usage(false, false);
            if let Some(val) = variable.try_load_const_llvm_value() {
                return Ok((val, vec![]));
            }
            let mut var_type = variable.compiler_type().clone();
            var_type.substitute_global_aliases(self.symbols())?;
            return variable.load_llvm_value(0, &path.to_string(), self.ctx, var_type);
        }
        if let Some((path, variable)) = self.resolve_path(&name, |s, p| s.get_const_by_path(p)) {
            let mut vtype = variable.compiler_type.clone();
            vtype.substitute_global_aliases(self.symbols())?;
            variable.mark_usage(false, false);
            if let Some(val) = variable.try_load_const_llvm_value() {
                return Ok((val, vec![]));
            }
            let mut var_type = variable.compiler_type().clone();
            var_type.substitute_global_aliases(self.symbols())?;
            return variable.load_llvm_value(0, &path.to_string(), self.ctx, var_type);
        }
        if let Some(ptype) = find_primitive_type(&name.to_string()) {
            return Ok((CompiledValue::Type(CompilerType::Primitive(ptype)), vec![]));
        }
        if let Some(type_id) = self.resolve_path(&name, |s, p| s.get_type_id_by_path(p)) {
            return Ok((CompiledValue::Type(CompilerType::Struct(type_id)), vec![]));
        }
        panic!("{}", name)
    }
    fn compile_static_access_rvalue(
        &self,
        expr: &Expr,
        member: &str,
        _expected: Expected,
    ) -> ExpressionCompileResult<(CompiledValue, Vec<LLVMInstruction>)> {
        let mut path = vec![member];
        let mut cursor = expr;
        while let Expr::StaticAccess(x, y) = cursor {
            cursor = &**x;
            path.push(y);
        }
        let Expr::Name(base) = cursor else {
            return Err(CompilerError::Generic(format!(
                "Expected name in static access"
            )));
        };
        path.push(base);

        let func_path = ContextPath::from_string(&self.ctx.current_function_path.to_string());
        let field = path.first().unwrap();
        let enum_path = ContextPathEnd::from_vec(
            path.iter()
                .skip(1)
                .rev()
                .map(|x| Arc::from(x.to_string()))
                .collect(),
        );

        if let Some(x) = self
            .symbols()
            .get_enum_by_path(&enum_path.with_start(&func_path))
            .or_else(|| self.symbols().get_enum_by_path(&enum_path))
        {
            return Ok((
                CompiledValue::Value {
                    llvm_repr: x
                        .fields
                        .iter()
                        .find(|f| f.0 == **field)
                        .map(|f| f.1.clone())
                        .unwrap(),
                    val_type: x.base_type.clone(),
                },
                vec![],
            ));
        }
        let rel_path =
            ContextPathEnd::from_vec(path.iter().rev().map(|x| Arc::from(*x)).collect::<Vec<_>>());
        let abs_path = rel_path.with_start(&self.ctx.current_function_path);

        if let Some((path, variable)) = self
            .symbols()
            .get_static_by_path(&abs_path)
            .or_else(|| self.symbols().get_static_by_path(&rel_path))
        {
            let mut vtype = variable.compiler_type.clone();
            vtype.substitute_global_aliases(self.symbols())?;
            variable.mark_usage(false, false);
            if let Some(val) = variable.try_load_const_llvm_value() {
                return Ok((val, vec![]));
            }
            let mut var_type = variable.compiler_type().clone();
            var_type.substitute_global_aliases(self.symbols())?;
            return variable.load_llvm_value(0, &path.to_string(), self.ctx, var_type);
        }
        if let Some((path, variable)) = self
            .symbols()
            .get_const_by_path(&abs_path)
            .or_else(|| self.symbols().get_const_by_path(&rel_path))
        {
            let mut vtype = variable.compiler_type.clone();
            vtype.substitute_global_aliases(self.symbols())?;
            variable.mark_usage(false, false);
            if let Some(val) = variable.try_load_const_llvm_value() {
                return Ok((val, vec![]));
            }
            let mut var_type = variable.compiler_type().clone();
            var_type.substitute_global_aliases(self.symbols())?;
            return variable.load_llvm_value(0, &path.to_string(), self.ctx, var_type);
        }
        Err(CompilerError::Generic(format!(
            "Invalid path {}/{}",
            abs_path, rel_path
        )))
    }
    fn compile_integer_literal(
        &self,
        num: i128,
        expected: Expected,
    ) -> ExpressionCompileResult<(CompiledValue, Vec<LLVMInstruction>)> {
        let val_type = expected
            .get_type()
            .filter(|t| t.is_integer())
            .cloned()
            .unwrap_or_else(|| CompilerType::Primitive(DEFAULT_INTEGER_TYPE));

        Ok((
            CompiledValue::new_value(LLVMVal::ConstantInteger(num), val_type),
            vec![],
        ))
    }
    fn compile_decimal_literal(
        &self,
        num: f64,
        expected: Expected,
    ) -> (CompiledValue, Vec<LLVMInstruction>) {
        let val_type = expected
            .get_type()
            .filter(|t| t.is_decimal())
            .cloned()
            .unwrap_or_else(|| CompilerType::Primitive(DEFAULT_DECIMAL_TYPE));
        (
            CompiledValue::new_value(LLVMVal::ConstantDecimal(num), val_type),
            vec![],
        )
    }
    fn compile_nullptr(
        &self,
        expected: Expected,
    ) -> ExpressionCompileResult<(CompiledValue, Vec<LLVMInstruction>)> {
        let ptr_type = expected.get_type().ok_or_else(|| {
            CompilerError::Generic(
                "Cannot infer type of 'null'. An explicit cast is needed.".to_string(),
            )
        })?;
        if !ptr_type.is_pointer() {
            return Err(CompilerError::Generic(format!(
                "Expected a pointer type for 'null', but context expects '{:?}'",
                ptr_type
            )));
        }
        Ok((
            CompiledValue::new_value(LLVMVal::Null, ptr_type.clone()),
            vec![],
        ))
    }
    fn compile_boolean_literal(
        &self,
        val: bool,
        _expected: Expected,
    ) -> ExpressionCompileResult<(CompiledValue, Vec<LLVMInstruction>)> {
        Ok((
            CompiledValue::new_value(
                LLVMVal::ConstantBoolean(val),
                CompilerType::Primitive(BOOL_TYPE),
            ),
            vec![],
        ))
    }
    fn compile_string_literal(
        &self,
        str_val: &String,
        _expected: Expected,
    ) -> ExpressionCompileResult<(CompiledValue, Vec<LLVMInstruction>)> {
        let const_id = self.compctx.add_to_strings_header_(str_val);

        let val_type = CompilerType::Pointer(Box::new(CompilerType::Primitive(CHAR_TYPE)));
        let llvm_val = LLVMVal::Global(format!(".str.{}", const_id));
        Ok((CompiledValue::new_value(llvm_val, val_type), vec![]))
    }
    fn compile_unary_op_rvalue(
        &self,
        op: &UnaryOp,
        operand_expr: &Expr,
        expected: Expected,
    ) -> ExpressionCompileResult<(CompiledValue, Vec<LLVMInstruction>)> {
        match op {
            UnaryOp::Deref => {
                let (lval, instructions) =
                    self.compile_deref_lvalue(operand_expr, LValueAccess::Read)?;
                let pointee_type = lval.value_type;
                let target_reg = self.ctx.acquire_temp_id();

                let load_instructions = vec![LLVMInstruction::Load {
                    target_reg,
                    ptr: lval.location,
                    result_type: pointee_type.clone(),
                }];

                let mut combined_instructions = instructions;
                combined_instructions.extend(load_instructions);
                Ok((
                    CompiledValue::new_value(LLVMVal::Register(target_reg), pointee_type),
                    combined_instructions,
                ))
            }
            UnaryOp::Pointer => {
                let (lval, instructions) = self.compile_lvalue(operand_expr, LValueAccess::Read)?;
                let ptr_type = lval.value_type.reference();
                Ok((
                    CompiledValue::new_value(lval.location, ptr_type),
                    instructions,
                ))
            }
            UnaryOp::Negate => {
                let (val, mut instructions) = self.compile_rvalue(operand_expr, expected)?;
                let val_type = val.get_type().unwrap();
                let llvm_val = val.try_get_llvm_rep()?;

                let target_reg = self.ctx.acquire_temp_id();
                let (op_str, zero) = if val_type.is_decimal() {
                    ("fsub", LLVMVal::ConstantDecimal(0.0))
                } else if val_type.is_integer() {
                    ("sub", LLVMVal::ConstantInteger(0))
                } else {
                    return Err(CompilerError::Generic(format!(
                        "Cannot negate type {:?}",
                        val_type
                    )));
                };

                instructions.push(LLVMInstruction::BinaryOp {
                    target_reg,
                    op: op_str,
                    op_type: val_type.clone(),
                    lhs: zero,
                    rhs: llvm_val.clone(),
                });

                Ok((
                    CompiledValue::new_value(LLVMVal::Register(target_reg), val_type.clone()),
                    instructions,
                ))
            }
            UnaryOp::Not => {
                let (value_rval, mut instr) = self.compile_rvalue(
                    operand_expr,
                    Expected::Type(&CompilerType::Primitive(BOOL_TYPE)),
                )?;
                let Some(value_type) = value_rval.get_type() else {
                    return Err(CompilerError::Generic(format!(
                        "Right side of unary operation is not value"
                    )));
                };
                if !value_type.is_bool() {
                    return Err(CompilerError::Generic(format!(
                        "Logical NOT can only be applied to booleans"
                    )));
                }
                let target_reg = self.ctx.acquire_temp_id();
                instr.push(LLVMInstruction::BinaryOp {
                    target_reg,
                    op: "xor",
                    op_type: CompilerType::Primitive(BOOL_TYPE),
                    lhs: LLVMVal::ConstantInteger(1),
                    rhs: value_rval.get_llvm_rep().clone(),
                });
                Ok((
                    CompiledValue::new_value(LLVMVal::Register(target_reg), value_type.clone()),
                    instr,
                ))
            }
        }
    }
    fn compile_index_rvalue(
        &self,
        array: &Expr,
        index: &Expr,
    ) -> ExpressionCompileResult<(CompiledValue, Vec<LLVMInstruction>)> {
        let (lvalue, mut instructions) =
            self.compile_index_lvalue(array, index, LValueAccess::Read)?;

        Ok((
            lvalue.load_rvalue(self.ctx, &mut instructions),
            instructions,
        ))
    }
    fn compile_member_access_rvalue(
        &self,
        obj: &Expr,
        member: &str,
    ) -> ExpressionCompileResult<(CompiledValue, Vec<LLVMInstruction>)> {
        let (lvalue, mut instructions) =
            self.compile_member_access_lvalue(obj, member, LValueAccess::Read)?;

        Ok((
            lvalue.load_rvalue(self.ctx, &mut instructions),
            instructions,
        ))
    }
    fn compile_struct_init(
        &self,
        name_struct: &Expr,
        inits: &[(String, Expr)],
    ) -> ExpressionCompileResult<(CompiledValue, Vec<LLVMInstruction>)> {
        let fqn = expr_to_type_path(name_struct);
        let Some(id) = self
            .symbols()
            .get_type_id_by_path(&ContextPathEnd::from_context_path(
                self.ctx.current_function_path.clone(),
                &fqn,
            ))
            .or_else(|| {
                self.symbols()
                    .get_type_id_by_path(&&ContextPathEnd::from_full_path(&fqn))
            })
        else {
            return Err(CompilerError::Generic(format!(
                "Struct {:?} not found",
                fqn
            )));
        };

        let mut t = None;
        let r#type = self.symbols().get_type_by_id(id);
        let fields = if r#type.is_generic() {
            let Expr::NameWithGenerics(_x, gen) = name_struct else {
                return Err(CompilerError::Generic("Expected generic parameters".into()));
            };
            let mut map = HashMap::new();
            let mut v = vec![];
            for (ind, prm) in r#type.generic_params.iter().enumerate() {
                let p = CompilerType::from_parser_type(
                    &gen[ind],
                    self.symbols(),
                    &self.ctx.current_function_path,
                )?;
                map.insert(prm.clone(), p.clone());
                v.push(p);
            }
            let q = r#type.get_implementation_index(&v);
            t = q;

            let mut fs = vec![];
            for x in r#type.fields.iter() {
                fs.push((
                    x.0.clone(),
                    x.1.with_substituted_generics(&map, self.symbols())?,
                ));
            }
            fs.into_boxed_slice()
        } else {
            r#type.fields.clone()
        };

        if fields.len() != inits.len() {
            let f: Vec<_> = fields
                .iter()
                .filter(|x| !inits.iter().any(|y| x.0 == y.0))
                .collect();
            return Err(CompilerError::Generic(format!("Missing fields: {:#?}", f)));
        }

        let mut vec_fields = Vec::with_capacity(fields.len());
        vec_fields.resize(fields.len(), LLVMVal::Null);
        let mut instructions = vec![];

        for init_expr in inits.iter() {
            let defined_field = fields
                .iter()
                .position(|provided_init| provided_init.0 == init_expr.0)
                .expect("Field should exist due to previous length and presence checks");
            let def_type = &fields[defined_field];
            let (compiled_field, field_instr) =
                self.compile_rvalue(&init_expr.1, Expected::Type(&def_type.1))?;
            instructions.extend(field_instr);
            vec_fields[defined_field] = compiled_field.try_get_llvm_rep()?.clone();
        }

        let val_type = if let Some(x) = t {
            CompilerType::GenericStructInstance(id, x)
        } else {
            CompilerType::Struct(id)
        };

        Ok((
            CompiledValue::StructValue {
                fields: vec_fields.into_boxed_slice(),
                val_type,
            },
            instructions,
        ))
    }

    fn compile_binary_op(
        &self,
        lhs: &Expr,
        op: &BinaryOp,
        rhs: &Expr,
        expected: Expected,
    ) -> ExpressionCompileResult<(CompiledValue, Vec<LLVMInstruction>)> {
        if matches!(op, BinaryOp::And | BinaryOp::Or) {
            return self.compile_short_circuit_op(lhs, *op, rhs);
        }
        let (left_val, mut instructions) = self.compile_rvalue(lhs, expected.clone())?;
        let ltype = left_val.get_type().cloned().ok_or_else(|| {
            CompilerError::Generic("Left side of binary operation is not a value".into())
        })?;

        let (right_val, right_instructions) = self.compile_rvalue(rhs, Expected::Type(&ltype))?;
        instructions.extend(right_instructions);

        let rtype = right_val.get_type().cloned().ok_or_else(|| {
            CompilerError::Generic("Right side of binary operation is not a value".into())
        })?;

        if ltype.is_pointer() && rtype.is_integer() {
            if !matches!(op, BinaryOp::Add | BinaryOp::Subtract) {
                return Err(CompilerError::Generic(format!(
                    "Operation {:?} is not permitted on pointers",
                    op
                )));
            }
            let mut index_val = right_val.try_get_llvm_rep()?.clone();
            if matches!(op, BinaryOp::Subtract) {
                let neg_reg = self.ctx.acquire_temp_id();
                instructions.push(LLVMInstruction::BinaryOp {
                    target_reg: neg_reg,
                    op: "sub",
                    op_type: rtype.clone(),
                    lhs: LLVMVal::ConstantInteger(0),
                    rhs: index_val,
                });
                index_val = LLVMVal::Register(neg_reg);
            }
            let target_reg = self.ctx.acquire_temp_id();
            let pointee_type = ltype.dereference().unwrap();
            instructions.push(LLVMInstruction::GetElementPtr {
                target_reg,
                base_type: pointee_type.clone(),
                ptr: left_val.try_get_llvm_rep()?.clone(),
                indices: vec![(index_val, rtype.clone())],
            });
            return Ok((
                CompiledValue::new_value(LLVMVal::Register(target_reg), ltype),
                instructions,
            ));
        }

        if ltype.is_pointer() && rtype.is_pointer() {
            let llvm_op = match op {
                BinaryOp::Equals => "icmp eq",
                BinaryOp::NotEqual => "icmp ne",
                _ => {
                    return Err(CompilerError::Generic(format!(
                        "Operation {:?} is not permitted on pointers",
                        op
                    )))
                }
            };
            let target_reg = self.ctx.acquire_temp_id();
            instructions.push(LLVMInstruction::BinaryOp {
                target_reg,
                op: llvm_op,
                op_type: ltype.clone(),
                lhs: left_val.try_get_llvm_rep()?.clone(),
                rhs: right_val.try_get_llvm_rep()?.clone(),
            });
            return Ok((
                CompiledValue::new_value(
                    LLVMVal::Register(target_reg),
                    CompilerType::Primitive(BOOL_TYPE),
                ),
                instructions,
            ));
        }

        if ltype != rtype {
            if ltype.is_pointer()
                && right_val
                    .as_literal_number()
                    .map(|x| *x == 0)
                    .unwrap_or(false)
            {
            } else if rtype.is_pointer()
                && left_val
                    .as_literal_number()
                    .map(|x| *x == 0)
                    .unwrap_or(false)
            {
            } else {
                return Err(CompilerError::Generic("Type Mismatch in binary op".into()));
            }
        }

        let llvm_op = match op {
            BinaryOp::Add => {
                if ltype.is_decimal() {
                    "fadd"
                } else {
                    "add"
                }
            }
            BinaryOp::Subtract => {
                if ltype.is_decimal() {
                    "fsub"
                } else {
                    "sub"
                }
            }
            BinaryOp::Multiply => {
                if ltype.is_decimal() {
                    "fmul"
                } else {
                    "mul"
                }
            }
            BinaryOp::Divide => {
                if ltype.is_decimal() {
                    "fdiv"
                } else if ltype.is_signed_integer() {
                    "sdiv"
                } else {
                    "udiv"
                }
            }
            BinaryOp::Modulo => {
                if ltype.is_decimal() {
                    "frem"
                } else if ltype.is_signed_integer() {
                    "srem"
                } else {
                    "urem"
                }
            }
            BinaryOp::BitAnd | BinaryOp::And => "and",
            BinaryOp::BitOr | BinaryOp::Or => "or",
            BinaryOp::BitXor => "xor",
            BinaryOp::ShiftLeft => "shl",
            BinaryOp::ShiftRight => {
                if ltype.is_signed_integer() {
                    "ashr"
                } else {
                    "lshr"
                }
            }
            BinaryOp::Equals => {
                if ltype.is_decimal() {
                    "fcmp oeq"
                } else {
                    "icmp eq"
                }
            }
            BinaryOp::NotEqual => {
                if ltype.is_decimal() {
                    "fcmp one"
                } else {
                    "icmp ne"
                }
            }
            BinaryOp::Less => {
                if ltype.is_decimal() {
                    "fcmp olt"
                } else if ltype.is_signed_integer() {
                    "icmp slt"
                } else {
                    "icmp ult"
                }
            }
            BinaryOp::LessEqual => {
                if ltype.is_decimal() {
                    "fcmp ole"
                } else if ltype.is_signed_integer() {
                    "icmp sle"
                } else {
                    "icmp ule"
                }
            }
            BinaryOp::Greater => {
                if ltype.is_decimal() {
                    "fcmp ogt"
                } else if ltype.is_signed_integer() {
                    "icmp sgt"
                } else {
                    "icmp ugt"
                }
            }
            BinaryOp::GreaterEqual => {
                if ltype.is_decimal() {
                    "fcmp oge"
                } else if ltype.is_signed_integer() {
                    "icmp sge"
                } else {
                    "icmp uge"
                }
            }
        };

        let target_reg = self.ctx.acquire_temp_id();
        instructions.push(LLVMInstruction::BinaryOp {
            target_reg,
            op: llvm_op,
            op_type: ltype.clone(),
            lhs: left_val.try_get_llvm_rep()?.clone(),
            rhs: right_val.try_get_llvm_rep()?.clone(),
        });

        let result_type = if llvm_op.starts_with("icmp") || llvm_op.starts_with("fcmp") {
            CompilerType::Primitive(BOOL_TYPE)
        } else {
            ltype
        };

        Ok((
            CompiledValue::new_value(LLVMVal::Register(target_reg), result_type),
            instructions,
        ))
    }
    fn compile_short_circuit_op(
        &self,
        lhs: &Expr,
        op: BinaryOp,
        rhs: &Expr,
    ) -> ExpressionCompileResult<(CompiledValue, Vec<LLVMInstruction>)> {
        let (left, mut instructions) =
            self.compile_rvalue(lhs, Expected::Type(&CompilerType::Primitive(BOOL_TYPE)))?;
        let Some(ltype) = left.get_type() else {
            return Err(CompilerError::Generic(
                "Left side of binary operation is not value".into(),
            )
            .into());
        };
        if !ltype.is_bool() {
            return Err(CompilerError::Generic(format!("Not Boolean")).into());
        }
        let after_lv = self.ctx.current_block_name.borrow().clone();
        let logic_id = self.ctx.acquire_label_id();

        let label_eval_rhs = format!("logic_rhs_{}", logic_id);
        let label_end = format!("logic_end_{}", logic_id);

        match op {
            BinaryOp::And => {
                instructions.push(LLVMInstruction::Branch {
                    condition_val: left.get_llvm_rep().clone(),
                    then_label_name: label_eval_rhs.clone(),
                    else_label_name: label_end.clone(),
                });
            }
            BinaryOp::Or => {
                instructions.push(LLVMInstruction::Branch {
                    condition_val: left.get_llvm_rep().clone(),
                    then_label_name: label_end.clone(),
                    else_label_name: label_eval_rhs.clone(),
                });
            }
            _ => unreachable!("compile_short_circuit_op called with non-logic operator"),
        }
        instructions.push(LLVMInstruction::Label {
            name: label_eval_rhs.to_string(),
        });
        self.ctx.set_current_block_name(label_eval_rhs.clone());
        let (right, mut r_instructions) =
            self.compile_rvalue(rhs, Expected::Type(&CompilerType::Primitive(BOOL_TYPE)))?;
        instructions.append(&mut r_instructions);
        let after_rv = self.ctx.current_block_name.borrow().clone();
        let Some(rtype) = right.get_type() else {
            return Err(CompilerError::Generic(
                "Right side of binary operation is not value".into(),
            )
            .into());
        };
        if !rtype.is_bool() {
            return Err(CompilerError::Generic(format!("Not boolean")).into());
        }
        instructions.push(LLVMInstruction::Jump {
            label: label_end.clone(),
        });
        instructions.push(LLVMInstruction::Label {
            name: label_end.clone(),
        });

        self.ctx.set_current_block_name(label_end.clone());
        let final_reg = self.ctx.acquire_temp_id();
        instructions.push(LLVMInstruction::Phi {
            target_reg: final_reg,
            result_type: CompilerType::Primitive(BOOL_TYPE),
            incoming: vec![
                (left.get_llvm_rep().clone(), after_lv),
                (right.get_llvm_rep().clone(), after_rv),
            ],
        });
        Ok((
            CompiledValue::new_value(
                LLVMVal::Register(final_reg),
                CompilerType::Primitive(BOOL_TYPE),
            ),
            instructions,
        ))
    }
    fn perform_inline_expansion(
        &self,
        compiled_args: &[(LLVMVal, CompilerType)],
        func_args: &[(String, CompilerType)],
        func_return_type: &CompilerType,
        body: &[StmtData],
        func_id: usize,
    ) -> ExpressionCompileResult<(CompiledValue, Vec<LLVMInstruction>)> {
        if body.is_empty() {
            if func_return_type.is_void() {
                return Ok((
                    CompiledValue::NoReturn {
                        program_halt: false,
                    },
                    vec![],
                ));
            }
            return Err(CompilerError::Generic(
                "Inline function body was empty but return type is not void".to_string(),
            ));
        }
        let func = self.compctx.symbols.get_function_by_id(func_id);
        let inline_id = self.ctx.acquire_label_id();
        let mut code_gen_ctx = CodeGenContext::default();
        code_gen_ctx.current_function_return_type = func_return_type.clone();
        code_gen_ctx.label_counter.set(self.ctx.label_counter.get());
        code_gen_ctx.temp_counter.set(self.ctx.temp_counter.get());
        code_gen_ctx.var_counter.set(self.ctx.var_counter.get());
        code_gen_ctx.return_label_name = format!("inl_exit{}", inline_id);
        code_gen_ctx.set_current_block_name(format!("inl_entry{}", inline_id));
        code_gen_ctx.current_function_path = func.path().clone();

        let mut instructions = vec![];

        instructions.push(LLVMInstruction::Jump {
            label: format!("inl_entry{}", inline_id),
        });
        instructions.push(LLVMInstruction::Label {
            name: format!("inl_entry{}", inline_id),
        });

        for (idx, (arg_val, arg_type)) in compiled_args.iter().enumerate() {
            let var = Variable::new(arg_type.clone(), true, false);
            var.set_constant_value(Some(arg_val.clone()));
            code_gen_ctx
                .scope
                .define(func_args[idx].0.clone(), var, 0, &self.compctx.symbols);
        }

        let mut gen = LLVMGenPass::new(code_gen_ctx, 0..0);
        for x in body {
            let (stmt_inst, brk) = gen.compile_statement(x, self.compctx).unwrap();
            instructions.extend(stmt_inst);
            if brk {
                break;
            }
        }

        if body
            .last()
            .map(|x| !matches!(x.stmt, Stmt::Return(..)))
            .unwrap_or(false)
        {
            instructions.push(LLVMInstruction::Jump {
                label: format!("inl_exit{}", inline_id),
            });
        }
        instructions.push(LLVMInstruction::Label {
            name: format!("inl_exit{}", inline_id),
        });

        self.ctx.label_counter.set(gen.cgctx.label_counter.get());
        self.ctx.temp_counter.set(gen.cgctx.temp_counter.get());
        self.ctx.var_counter.set(gen.cgctx.var_counter.get());

        self.ctx
            .set_current_block_name(format!("inl_exit{}", inline_id));
        if func_return_type.is_void() {
            return Ok((
                CompiledValue::NoReturn {
                    program_halt: false,
                },
                instructions,
            ));
        }
        if gen.cgctx.pending_returns.len() == 1 {
            return Ok((
                CompiledValue::new_value(
                    gen.cgctx.pending_returns[0].0.clone(),
                    func_return_type.clone(),
                ),
                instructions,
            ));
        }
        let phi_uid = self.ctx.acquire_temp_id();
        let incoming = gen.cgctx.pending_returns.clone();

        instructions.push(LLVMInstruction::Phi {
            target_reg: phi_uid,
            result_type: func_return_type.clone(),
            incoming,
        });

        Ok((
            CompiledValue::new_value(LLVMVal::Register(phi_uid), func_return_type.clone()),
            instructions,
        ))
    }
    fn compile_call(
        &self,
        callee_expr: &Expr,
        args: &[Expr],
        generics: Option<&[ParserType]>,
        expected: Expected,
    ) -> ExpressionCompileResult<(CompiledValue, Vec<LLVMInstruction>)> {
        if let Expr::Name(name) = callee_expr {
            if generics.is_some() {
                if let Some((_, _, Some(func_ptr), _)) = COMPILER_FUNCTIONS
                    .iter()
                    .find(|(n, _, _, _)| n == &name.as_str())
                {
                    return func_ptr(self, args, generics.unwrap(), &expected);
                }
            } else {
                if let Some((_, Some(func_ptr), _, _)) = COMPILER_FUNCTIONS
                    .iter()
                    .find(|(n, _, _, _)| n == &name.as_str())
                {
                    return func_ptr(self, args, &expected);
                }
            }
        }
        let (mut callee_lval, mut instructions) =
            self.compile_lvalue(callee_expr, LValueAccess::Read)?;
        let (return_type, param_types, inline_body_info) = {
            if let Some(x) = callee_lval.function_id {
                let func = self.compctx.symbols.get_function_by_id(x);
                let inl = func.is_inline().then_some((&func.args, &func.body, x));
                if func.is_generic() {
                    let Some(generics) = generics else {
                        return Err(CompilerError::Generic(format!(
                            "Calling generic function without giving generic types"
                        )));
                    };
                    let generics = generics
                        .iter()
                        .map(|x| {
                            CompilerType::from_parser_type(
                                x,
                                self.symbols(),
                                &self.ctx.current_function_path,
                            )
                        })
                        .collect::<ExpressionCompileResult<Vec<_>>>()?;
                    let Some(iid) = func.get_generic_implementation_index(&generics) else {
                        return Err(CompilerError::Generic(format!("TODO FIX THIS GEN IMPL")));
                    };
                    callee_lval.location =
                        LLVMVal::Global(func.get_implementation_name(iid, self.symbols()));
                    func.get_def_by_implementation_index(iid, self.symbols())
                        .map(|x| (*x.0, x.1, inl))
                        .unwrap()
                } else if let CompilerType::Function(ret, params) = &callee_lval.value_type {
                    (*ret.clone(), params.clone(), inl)
                } else {
                    return Err(CompilerError::Generic(format!(
                        "Is not callable {:?}",
                        callee_lval.value_type
                    )));
                }
            } else if let CompilerType::Function(ret, params) = &callee_lval.value_type {
                (*ret.clone(), params.clone(), None)
            } else {
                return Err(CompilerError::Generic(format!(
                    "Is not callable {:?}",
                    callee_lval.value_type
                )));
            }
        };
        if args.len() != param_types.len() {
            return Err(CompilerError::Generic(format!(
                "Argument count mismatch {} vs {}",
                param_types.len(),
                args.len()
            )));
        }
        let mut compiled_args = vec![];
        for (idx, arg_expr) in args.iter().enumerate() {
            let (arg_val, arg_instructions) =
                self.compile_rvalue(arg_expr, Expected::Type(&param_types[idx]))?;
            if !arg_val.equal_type(&param_types[idx]) {
                return Err(CompilerError::Generic(format!(
                    "Type missmatch in {} argument:({:?} vs {:?})",
                    idx + 1,
                    arg_val.get_type().unwrap(),
                    param_types[idx]
                )));
            }
            instructions.extend(arg_instructions);
            compiled_args.push((
                arg_val.try_get_llvm_rep()?.clone(),
                param_types[idx].clone(),
            ));
        }
        if let Some((func_args_def, body, func_id)) = inline_body_info {
            let (inline_val, inline_instr) = self.perform_inline_expansion(
                &compiled_args,
                &func_args_def,
                &return_type,
                &body,
                func_id,
            )?;
            instructions.extend(inline_instr);
            return Ok((inline_val, instructions));
        }

        if return_type.is_void() {
            instructions.push(LLVMInstruction::Call {
                target_reg: None,
                callee: callee_lval.location,
                args: compiled_args,
                result_type: return_type,
            });
            Ok((
                CompiledValue::NoReturn {
                    program_halt: false,
                },
                instructions,
            ))
        } else {
            if let Expected::NoReturn = expected {
                instructions.push(LLVMInstruction::Call {
                    target_reg: None,
                    callee: callee_lval.location,
                    args: compiled_args,
                    result_type: return_type,
                });
                Ok((
                    CompiledValue::NoReturn {
                        program_halt: false,
                    },
                    instructions,
                ))
            } else {
                let target_reg = self.ctx.acquire_temp_id();
                instructions.push(LLVMInstruction::Call {
                    target_reg: Some(target_reg),
                    callee: callee_lval.location,
                    args: compiled_args,
                    result_type: return_type.clone(),
                });
                Ok((
                    CompiledValue::new_value(LLVMVal::Register(target_reg), return_type),
                    instructions,
                ))
            }
        }
    }
    fn compile_macro_call(
        &self,
        callee_expr: &Expr,
        args: &[Expr],
        expected: Expected,
    ) -> ExpressionCompileResult<(CompiledValue, Vec<LLVMInstruction>)> {
        if let Expr::Name(name) = callee_expr {
            if let Some((_, func_ptr)) = COMPILER_MACROS.iter().find(|(n, _)| n == &name.as_str()) {
                let (exp, mut m_instr) = func_ptr(self, args, &expected)?;
                let (ret, mut instr) = self.compile_rvalue(&exp, expected)?;
                instr.append(&mut m_instr);
                return Ok((ret, instr));
            }
        }
        unimplemented!("{:?}", callee_expr.debug_emit())
    }
    fn compile_assignment(
        &self,
        lhs: &Expr,
        rhs: &Expr,
        expected: Expected,
    ) -> ExpressionCompileResult<(CompiledValue, Vec<LLVMInstruction>)> {
        let (left_lval, mut instructions) = self.compile_lvalue(lhs, LValueAccess::Write)?;

        let (right_val, rhs_instructions) =
            self.compile_rvalue(rhs, Expected::Type(&left_lval.value_type))?;
        instructions.extend(rhs_instructions);

        let rtype = right_val.get_type().unwrap();
        if left_lval.value_type != *rtype {
            return Err(CompilerError::Generic(format!(
                "Type mismatch {:?} vs {:?}",
                left_lval.value_type, rtype
            )));
        }

        instructions.push(LLVMInstruction::Store {
            value: right_val.try_get_llvm_rep()?.clone(),
            value_type: rtype.clone(),
            ptr: left_lval.location,
        });

        if matches!(expected, Expected::NoReturn) {
            Ok((
                CompiledValue::NoReturn {
                    program_halt: false,
                },
                instructions,
            ))
        } else {
            Ok((right_val, instructions))
        }
    }
    fn compile_cast(
        &self,
        expr: &Expr,
        target_type: &ParserType,
        expected: Expected,
    ) -> ExpressionCompileResult<(CompiledValue, Vec<LLVMInstruction>)> {
        let mut target_type = CompilerType::from_parser_type(
            target_type,
            self.symbols(),
            &self.ctx.current_function_path,
        )?;
        target_type.substitute_global_aliases(self.symbols())?;
        let (value_rval, mut instr) = self.compile_rvalue(expr, expected)?;
        let Some(value_type) = value_rval.get_type() else {
            return Err(CompilerError::Generic("Argument is not a value".into()).into());
        };
        if *value_type == target_type {
            return Ok((value_rval, instr));
        }
        let (val, mut inst) = self.explicit_cast(&value_rval, &target_type)?;
        instr.append(&mut inst);
        Ok((val, instr))
    }
    fn explicit_cast(
        &self,
        value: &CompiledValue,
        to_type: &CompilerType,
    ) -> ExpressionCompileResult<(CompiledValue, Vec<LLVMInstruction>)> {
        let Some(value_type) = value.get_type() else {
            return Err(CompilerError::Generic("Casting value is not a type".into()).into());
        };
        if *value_type == *to_type {
            return Ok((value.clone(), vec![]));
        }

        if let (Some(from_info), Some(to_info)) =
            (value_type.as_primitive(), to_type.as_primitive())
        {
            if from_info.is_integer() && to_info.is_integer() {
                if from_info.layout == to_info.layout || value.as_literal_number().is_some() {
                    return Ok((
                        CompiledValue::new_value(
                            value.get_llvm_rep().clone(),
                            CompilerType::Primitive(to_info),
                        ),
                        vec![],
                    ));
                }
                let op = if from_info.layout.size < to_info.layout.size {
                    if from_info.is_unsigned_integer() {
                        "zext"
                    } else {
                        "sext"
                    }
                } else {
                    "trunc"
                };

                let utvc = self.ctx.acquire_temp_id();
                return Ok((
                    CompiledValue::new_value(
                        LLVMVal::Register(utvc),
                        CompilerType::Primitive(to_info),
                    ),
                    vec![LLVMInstruction::Cast {
                        target_reg: utvc,
                        op: op.to_string(),
                        from_type: CompilerType::Primitive(from_info),
                        from_val: value.get_llvm_rep().clone(),
                        to_type: CompilerType::Primitive(to_info),
                    }],
                ));
            } else if from_info.is_decimal() && to_info.is_decimal() {
                if from_info.layout == to_info.layout {
                    return Ok((
                        CompiledValue::new_value(
                            value.get_llvm_rep().clone(),
                            CompilerType::Primitive(to_info),
                        ),
                        vec![],
                    ));
                }
                let op = if from_info.layout.size < to_info.layout.size {
                    "fpext"
                } else {
                    "fptrunc"
                };
                let utvc = self.ctx.acquire_temp_id();
                return Ok((
                    CompiledValue::new_value(
                        LLVMVal::Register(utvc),
                        CompilerType::Primitive(to_info),
                    ),
                    vec![LLVMInstruction::Cast {
                        target_reg: utvc,
                        op: op.to_string(),
                        from_type: CompilerType::Primitive(from_info),
                        from_val: value.get_llvm_rep().clone(),
                        to_type: CompilerType::Primitive(to_info),
                    }],
                ));
            } else if from_info.is_integer() && to_info.is_decimal() {
                let op = if from_info.is_unsigned_integer() {
                    "uitofp"
                } else {
                    "sitofp"
                };
                let utvc = self.ctx.acquire_temp_id();
                return Ok((
                    CompiledValue::new_value(
                        LLVMVal::Register(utvc),
                        CompilerType::Primitive(to_info),
                    ),
                    vec![LLVMInstruction::Cast {
                        target_reg: utvc,
                        op: op.to_string(),
                        from_type: CompilerType::Primitive(from_info),
                        from_val: value.get_llvm_rep().clone(),
                        to_type: CompilerType::Primitive(to_info),
                    }],
                ));
            } else if from_info.is_decimal() && to_info.is_integer() {
                if let LLVMVal::ConstantDecimal(x) = value.get_llvm_rep() {
                    return Ok((
                        CompiledValue::new_value(
                            LLVMVal::ConstantInteger(*x as i128),
                            CompilerType::Primitive(to_info),
                        ),
                        vec![],
                    ));
                }
                let op = if to_type.is_unsigned_integer() {
                    "fptoui"
                } else {
                    "fptosi"
                };
                let utvc = self.ctx.acquire_temp_id();
                return Ok((
                    CompiledValue::new_value(
                        LLVMVal::Register(utvc),
                        CompilerType::Primitive(to_info),
                    ),
                    vec![LLVMInstruction::Cast {
                        target_reg: utvc,
                        op: op.to_string(),
                        from_type: CompilerType::Primitive(from_info),
                        from_val: value.get_llvm_rep().clone(),
                        to_type: CompilerType::Primitive(to_info),
                    }],
                ));
            } else if from_info.is_bool() && to_info.is_integer() {
                let utvc = self.ctx.acquire_temp_id();
                return Ok((
                    CompiledValue::new_value(
                        LLVMVal::Register(utvc),
                        CompilerType::Primitive(to_info),
                    ),
                    vec![LLVMInstruction::Cast {
                        target_reg: utvc,
                        op: "zext".to_string(),
                        from_type: CompilerType::Primitive(from_info),
                        from_val: value.get_llvm_rep().clone(),
                        to_type: CompilerType::Primitive(to_info),
                    }],
                ));
            }
        } else if value_type.is_pointer() && to_type.is_pointer() {
            return Ok((
                CompiledValue::new_value(value.get_llvm_rep().clone(), to_type.clone()),
                vec![],
            ));
        }

        return Err(CompilerError::Generic(format!(
            "Cannot explicitly cast {:?} to {:?}",
            value_type, to_type
        ))
        .into());
    }
    pub fn compile_lvalue(
        &self,
        expr: &Expr,
        access: LValueAccess,
    ) -> ExpressionCompileResult<(CompiledLValue, Vec<LLVMInstruction>)> {
        match expr {
            Expr::Name(name) => self.compile_name_lvalue(ContextPathEnd::from_end(name), access),
            Expr::NameWithGenerics(name, generics) => {
                self.compile_name_with_generics_lvalue(name, generics, access)
            }
            Expr::StaticAccess(inner, member) => {
                self.compile_static_access_lvalue(inner, member, access)
            }
            Expr::UnaryOp(UnaryOp::Deref, val) => self.compile_deref_lvalue(val, access),
            Expr::Index(array, index) => self.compile_index_lvalue(array, index, access),
            Expr::MemberAccess(obj, member) => {
                self.compile_member_access_lvalue(obj, member, access)
            }
            _ => Err(CompilerError::Generic(format!("Not a lvalue {:?}", expr))),
        }
    }
    pub fn compile_name_lvalue(
        &self,
        name: ContextPathEnd,
        access: LValueAccess,
    ) -> ExpressionCompileResult<(CompiledLValue, Vec<LLVMInstruction>)> {
        let name_str = name.to_string();
        if let Some((var, id)) = self.ctx.scope.lookup(&name_str) {
            if access == LValueAccess::Write && var.get_flags().is_constant {
                return Err(CompilerError::Generic(format!(
                    "Tried to assign to const {}",
                    name_str
                )));
            }
            var.mark_usage(
                access == LValueAccess::Write,
                access == LValueAccess::ModifyContent,
            );
            if var.get_flags().is_constant {
                let ptype = var.compiler_type();
                return Ok((
                    CompiledLValue::new(
                        var.value().borrow().clone().unwrap(),
                        ptype.clone(),
                        false,
                    ),
                    vec![],
                ));
            }
            return Ok((
                CompiledLValue::new(
                    LLVMVal::Variable(*id),
                    var.compiler_type().clone(),
                    !var.get_flags().is_constant,
                ),
                vec![],
            ));
        }
        let fqn_local = name.with_start(&self.ctx.current_function_path);
        if let Some(fid) = self
            .symbols()
            .get_function_id_by_path(&fqn_local)
            .or_else(|| self.symbols().get_function_id_by_path(&name))
        {
            //let func = self.symbols().get_function_by_id_use(fid);
            return Ok((CompiledLValue::from_function(fid, self.symbols())?, vec![]));
        }
        if let Some((var_path, var)) = self
            .compctx
            .symbols
            .get_static_by_path(&fqn_local)
            .or_else(|| self.compctx.symbols.get_static_by_path(&name))
        {
            return Ok((
                CompiledLValue::new(
                    LLVMVal::Global(var_path.to_string()),
                    var.compiler_type().clone(),
                    true,
                ),
                vec![],
            ));
        }
        Err(CompilerError::Generic(format!(
            "{} was not found",
            name_str
        )))
    }
    fn compile_name_with_generics_lvalue(
        &self,
        name: &Expr,
        generics: &[ParserType],
        access: LValueAccess,
    ) -> ExpressionCompileResult<(CompiledLValue, Vec<LLVMInstruction>)> {
        let (x, instruct) = self.compile_lvalue(name, access)?;
        if x.value_type.is_generic_dependent() {
            if let LLVMVal::ConstantInteger(internal_id) = x.location {
                let internal_id = internal_id as usize;
                if generics.is_empty() {
                    return Err(CompilerError::Generic(format!(
                        "Generic function '{}' requires generic parameters",
                        internal_id
                    ))
                    .into());
                }
                let _func = self.symbols().get_function_by_id_use(internal_id);
                let mut tp = _func.get_signature_type();
                if !_func.is_generic() {
                    return Err(CompilerError::Generic(format!("Function is not generic")).into());
                }
                let mut map = HashMap::new();
                let mut generic_types = vec![];
                for (i, x) in _func.generic_params.iter().enumerate() {
                    let mut ct = CompilerType::from_parser_type(
                        &generics[i],
                        self.symbols(),
                        &self.ctx.current_function_path,
                    )?;
                    generic_types.push(ct.clone());
                    ct.substitute_global_aliases(self.symbols())?;
                    map.insert(x.to_string(), ct);
                }
                tp.substitute_generics(&map, self.symbols())?;
                let impl_index = _func
                    .get_generic_implementation_index(&generic_types)
                    .unwrap();

                let mut x = CompiledLValue::new(
                    LLVMVal::Global(_func.get_implementation_name(impl_index, self.symbols())),
                    tp,
                    false,
                );
                x.function_id = Some(internal_id);
                return Ok((x, instruct));
            }
        }
        Err(CompilerError::Generic(format!(
            "Lvalue with generics '{:?}' is not a generic function",
            name
        ))
        .into())
    }
    fn compile_static_access_lvalue(
        &self,
        expr: &Expr,
        member: &str,
        access: LValueAccess,
    ) -> ExpressionCompileResult<(CompiledLValue, Vec<LLVMInstruction>)> {
        let mut path = vec![member];
        let mut cursor = expr;
        while let Expr::StaticAccess(x, y) = cursor {
            cursor = x;
            path.push(y);
        }
        let Expr::Name(base) = cursor else {
            return Err(CompilerError::Generic(format!(
                "Static access must start with a name, found {:?}",
                cursor
            )));
        };
        path.push(base);

        let full_path = ContextPathEnd::from_vec(
            path.iter()
                .rev()
                .map(|s| Arc::from(s.to_string()))
                .collect(),
        );
        self.compile_name_lvalue(full_path, access)
    }
    fn compile_deref_lvalue(
        &self,
        operand: &Expr,
        _access: LValueAccess,
    ) -> ExpressionCompileResult<(CompiledLValue, Vec<LLVMInstruction>)> {
        let (r_val, instructions) = self.compile_rvalue(operand, Expected::Anything)?;
        let r_type = r_val
            .get_type()
            .ok_or_else(|| CompilerError::Generic("Dereferenced value has no type".to_string()))?;

        let pointee_type = r_type.dereference().ok_or_else(|| {
            CompilerError::Generic(format!("Cannot deref non pointer {:?}", r_type))
        })?;

        Ok((
            CompiledLValue::new(
                r_val.try_get_llvm_rep()?.clone(),
                pointee_type.clone(),
                true,
            ),
            instructions,
        ))
    }
    fn compile_index_lvalue(
        &self,
        array_expr: &Expr,
        index_expr: &Expr,
        access: LValueAccess,
    ) -> ExpressionCompileResult<(CompiledLValue, Vec<LLVMInstruction>)> {
        let (larray_val, mut instructions) = self.compile_lvalue(
            array_expr,
            if access == LValueAccess::Read {
                LValueAccess::Read
            } else {
                LValueAccess::ModifyContent
            },
        )?;
        let (index_val, mut index_instructions) = self.compile_rvalue(
            index_expr,
            Expected::Type(&CompilerType::Primitive(POINTER_SIZED_TYPE)),
        )?;

        let index_llvm_val = index_val.try_get_llvm_rep()?.clone();
        let index_type = index_val.get_type().unwrap().clone();

        if let Some((size, base_type)) = larray_val.value_type.as_constant_array() {
            instructions.append(&mut index_instructions);
            if !larray_val.is_mutable && access != LValueAccess::Read {
                return Err(CompilerError::Generic(
                    "Cannot mutate elements of a constant inline array".into(),
                ));
            }
            if let LLVMVal::ConstantInteger(x) = index_val.get_llvm_rep() {
                if *x == 0 {
                    return Ok((
                        CompiledLValue::new(larray_val.location, base_type.clone(), true),
                        instructions,
                    ));
                } else if *x >= size as i128 {
                    return Err(CompilerError::Generic(format!(
                        "Tried to access oob area of constant array"
                    )));
                }
            }
            let target_reg = self.ctx.acquire_temp_id();
            instructions.push(LLVMInstruction::GetElementPtr {
                target_reg,
                base_type: larray_val.value_type.clone(),
                ptr: larray_val.location,
                indices: vec![
                    (
                        LLVMVal::ConstantInteger(0),
                        CompilerType::Primitive(DEFAULT_INTEGER_TYPE),
                    ),
                    (index_llvm_val, index_type),
                ],
            });

            return Ok((
                CompiledLValue::new(LLVMVal::Register(target_reg), base_type.clone(), true),
                instructions,
            ));
        }
        if let Some(internal) = larray_val.value_type.as_pointer() {
            let (lr, mut instr) = self.compile_rvalue(array_expr, Expected::Anything)?;
            index_instructions.append(&mut instr);
            if index_llvm_val == LLVMVal::ConstantInteger(0) {
                return Ok((
                    CompiledLValue::new(lr.get_llvm_rep().clone(), internal.clone(), true),
                    index_instructions,
                ));
            }
            let target_reg = self.ctx.acquire_temp_id();
            index_instructions.push(LLVMInstruction::GetElementPtr {
                target_reg,
                base_type: internal.clone(),
                ptr: lr.get_llvm_rep().clone(),
                indices: vec![(index_llvm_val, index_type)],
            });
            return Ok((
                CompiledLValue::new(LLVMVal::Register(target_reg), internal.clone(), true),
                index_instructions,
            ));
        } else {
            panic!("{:?} {:?} {:?}", array_expr, larray_val, index_val);
        }
    }
    fn compile_member_access_lvalue(
        &self,
        obj_expr: &Expr,
        member: &str,
        access: LValueAccess,
    ) -> ExpressionCompileResult<(CompiledLValue, Vec<LLVMInstruction>)> {
        let (obj_lval, mut instructions) = self.compile_lvalue(
            obj_expr,
            if access == LValueAccess::Read {
                LValueAccess::Read
            } else {
                LValueAccess::ModifyContent
            },
        )?;
        let (base_ptr_repr, struct_type) = if obj_lval.value_type.is_pointer() {
            let (obj_rvalue, mut inst) = self.compile_rvalue(obj_expr, Expected::Anything)?;
            let Some(obj_type) = obj_rvalue.get_type() else {
                return Err(CompilerError::Generic(
                    "Object in member access is not a value".into(),
                )
                .into());
            };
            instructions.append(&mut inst);
            let internal_type = obj_type.dereference().unwrap();
            (obj_rvalue.get_llvm_rep().clone(), internal_type.clone())
        } else {
            (obj_lval.location.clone(), obj_lval.value_type.clone())
        };

        if let CompilerType::GenericStructInstance(x, y) = struct_type {
            let given_struct = self.symbols().get_type_by_id(x);
            let (position, field) = given_struct.get_field(member).unwrap();
            let implementation = given_struct.generic_implementations.borrow()[y].clone();
            let mut type_map = HashMap::new();
            for (ind, prm) in given_struct.generic_params.iter().enumerate() {
                type_map.insert(prm.clone(), implementation[ind].clone());
            }
            let mut field_type = field.clone();
            field_type.substitute_generics(&type_map, self.symbols())?;
            if position == 0 {
                return Ok((
                    CompiledLValue::new(base_ptr_repr, field_type.clone(), true),
                    instructions,
                ));
            }
            let utvc = self.ctx.acquire_temp_id();
            instructions.push(LLVMInstruction::GetElementPtrExt {
                target_reg: utvc,
                base_type: struct_type.clone(),
                result_type: struct_type.clone(),
                ptr: base_ptr_repr,
                indices: vec![
                    (
                        LLVMVal::ConstantInteger(0),
                        CompilerType::Primitive(DEFAULT_INTEGER_TYPE),
                    ),
                    (
                        LLVMVal::ConstantInteger(position as i128),
                        CompilerType::Primitive(DEFAULT_INTEGER_TYPE),
                    ),
                ],
            });
            return Ok((
                CompiledLValue::new(LLVMVal::Register(utvc), field_type.clone(), true),
                instructions,
            ));
        }
        if let CompilerType::Struct(x) = struct_type {
            let given_struct = self.symbols().get_type_by_id(x);
            let Some((position, field_type)) = given_struct.get_field(member) else {
                return Err(CompilerError::Generic(format!(
                    "Field '{}' was not found inside struct '{}'",
                    member,
                    given_struct.full_path()
                )));
            };
            if position == 0 {
                return Ok((
                    CompiledLValue::new(base_ptr_repr, field_type.clone(), true),
                    instructions,
                ));
            }
            let utvc = self.ctx.acquire_temp_id();
            instructions.push(LLVMInstruction::GetElementPtrExt {
                target_reg: utvc,
                base_type: struct_type.clone(),
                result_type: struct_type.clone(),
                ptr: base_ptr_repr,
                indices: vec![
                    (
                        LLVMVal::ConstantInteger(0),
                        CompilerType::Primitive(DEFAULT_INTEGER_TYPE),
                    ),
                    (
                        LLVMVal::ConstantInteger(position as i128),
                        CompilerType::Primitive(DEFAULT_INTEGER_TYPE),
                    ),
                ],
            });
            return Ok((
                CompiledLValue::new(LLVMVal::Register(utvc), field_type.clone(), true),
                instructions,
            ));
        }
        panic!("{:?}.{}\n {:?}", obj_expr, member, obj_lval);
    }
    pub fn symbols(&self) -> &SymbolTable {
        &self.compctx.symbols
    }
    pub fn ctx(&self) -> &'a CodeGenContext {
        self.ctx
    }
    fn resolve_path<'b, T, F>(&'b self, path_end: &ContextPathEnd, lookup_fn: F) -> Option<T>
    where
        F: Fn(&'b SymbolTable, &ContextPathEnd) -> Option<T>,
    {
        let abs_path = path_end.with_start(&self.ctx.current_function_path);
        lookup_fn(self.symbols(), &abs_path).or_else(|| lookup_fn(self.symbols(), path_end))
    }
}
pub fn compile_expression(
    expr: &Expr,
    expected: Expected,
    ctx: &CodeGenContext,
    compctx: &CompilerContext,
) -> ExpressionCompileResult<(CompiledValue, Vec<LLVMInstruction>)> {
    let ec = ExpressionCompiler::new(ctx, compctx);
    match ec.compile_rvalue(expr, expected) {
        Ok(x) => Ok(x),
        Err(x) => {
            println!("{:?}", expr);
            Err(x)
        }
    }
}
