use crate::{
    compiler::passes::{CodeGenContext, CompilerContext, LLVMGenPass},
    compiler_essentials::{
        CompileResult, CompiledLValue, CompilerError, CompilerType, LLVMOutputHandler, LLVMVal,
        Scope, SymbolTable, Variable,
    },
    compiler_functions::COMPILER_FUNCTIONS,
};
use std::collections::HashMap;

use rcsharp_parser::{
    compiler_primitives::{
        BOOL_TYPE, CHAR_TYPE, DEFAULT_DECIMAL_TYPE, DEFAULT_INTEGER_TYPE, POINTER_SIZED_TYPE,
        PRIMITIVE_TYPES_INFO,
    },
    expression_parser::{BinaryOp, Expr, UnaryOp},
    parser::{ParserType, Span, Stmt, StmtData},
};

#[derive(Debug, Clone, PartialEq)]
pub enum Expected<'a> {
    Type(&'a CompilerType),
    Anything,
    NoReturn,
}

#[derive(Debug, Clone, PartialEq)]
pub enum CompiledValue {
    Value {
        llvm_repr: LLVMVal,
        val_type: CompilerType,
    },
    Function {
        internal_id: usize,
    },
    GenericFunction {
        internal_id: usize,
    },
    Type(CompilerType),
    NoReturn {
        program_halt: bool,
    },
}
impl CompiledValue {
    pub fn new_value(llvm_value: LLVMVal, value_type: CompilerType) -> CompiledValue {
        Self::Value {
            llvm_repr: llvm_value,
            val_type: value_type,
        }
    }
    pub fn as_literal_number(&self) -> Option<&i128> {
        if let CompiledValue::Value {
            llvm_repr: LLVMVal::ConstantInteger(val),
            ..
        } = self
        {
            return Some(val);
        }
        None
    }
    pub fn try_get_type(&self) -> CompileResult<&CompilerType> {
        match self {
            Self::Value {
                val_type: ptype, ..
            } => Ok(ptype),
            Self::NoReturn { .. } => {
                Err(CompilerError::Generic("Expression yields no value".into()).into())
            }
            Self::Type(compiler_type) => Ok(compiler_type),
            _ => Err(CompilerError::Generic(format!("Cannot get type of {:?}", self)).into()),
        }
    }
    pub fn try_get_llvm_rep(&self) -> CompileResult<&LLVMVal> {
        match self {
            Self::Value { llvm_repr, .. } => Ok(llvm_repr),
            _ => Err(CompilerError::Generic(format!(
                "Value {:?} has no LLVM representation",
                self
            ))
            .into()),
        }
    }
    pub fn is_program_halt(&self) -> bool {
        match self {
            Self::NoReturn { program_halt, .. } => *program_halt,
            _ => false,
        }
    }
}
pub struct ExpressionCompiler<'a> {
    pub ctx: &'a mut CodeGenContext,
    pub output: &'a mut LLVMOutputHandler,
    pub compctx: &'a mut CompilerContext,
}

impl<'a> ExpressionCompiler<'a> {
    pub fn symbols(&self) -> &SymbolTable {
        &self.compctx.symbols
    }
}

impl<'a> Expected<'a> {
    pub fn get_type(&self) -> Option<&'a CompilerType> {
        match self {
            Self::Type(x) => Some(x),
            _ => None,
        }
    }
}
impl CompiledValue {
    pub fn get_llvm_rep(&self) -> &LLVMVal {
        match self {
            Self::Value { llvm_repr, .. } => llvm_repr,
            _ => panic!("{:?}", self),
        }
    }
    pub fn equal_type(&self, other: &CompilerType) -> bool {
        match self {
            Self::Value {
                val_type: ptype, ..
            } => ptype == other,
            _ => false,
        }
    }
}
impl<'a> ExpressionCompiler<'a> {
    fn new(
        ctx: &'a mut crate::compiler::passes::CodeGenContext,
        output: &'a mut LLVMOutputHandler,
        compctx: &'a mut CompilerContext,
    ) -> Self {
        Self {
            ctx,
            output,
            compctx,
        }
    }
    pub fn compile_rvalue(
        &mut self,
        expr: &Expr,
        expected: Expected,
    ) -> CompileResult<CompiledValue> {
        match expr {
            Expr::Name(name) => self.compile_name_rvalue(name, expected),
            Expr::NameWithGenerics(name, generics) => {
                self.compile_name_with_generics_rvalue(name, generics, expected)
            }
            Expr::Integer(num_str) => self.compile_integer_literal(*num_str, expected),
            Expr::Decimal(num_str) => self.compile_decimal_literal(*num_str, expected),
            Expr::Assign(lhs, rhs) => self.compile_assignment(lhs, rhs, expected),
            Expr::Call(callee, args) => self.compile_unified_call(callee, args, None, expected),
            Expr::CallGeneric(callee, args, generic) => {
                self.compile_unified_call(callee, args, Some(generic), expected)
            }

            Expr::MemberAccess(..) => self.compile_member_access_rvalue(expr),
            Expr::Cast(expr, target_type) => self.compile_cast(expr, target_type, expected),
            Expr::BinaryOp(l, op, r) => self.compile_binary_op(l, op, r, expected),
            Expr::UnaryOp(op, operand) => self.compile_unary_op_rvalue(op, operand, expected),
            Expr::StaticAccess(obj, member) => {
                self.compile_static_access_rvalue(obj, member, expected)
            }
            Expr::StringConst(str_val) => self.compile_string_literal(str_val),
            Expr::Index(array, index) => self.compile_index_rvalue(array, index),
            Expr::Boolean(value) => self.compile_boolean(*value),
            Expr::NullPtr => self.compile_null(expected),
            Expr::Type(..) => unreachable!(),
            Expr::Array(..) => unreachable!(),
        }
    }
    // RVAL
    pub fn compile_name_rvalue(
        &mut self,
        name: &str,
        _expected: Expected,
    ) -> CompileResult<CompiledValue> {
        if let Some((variable, id)) = self.ctx.scope.lookup(name) {
            variable.mark_usage(false, false);
            if let Some(val) = variable.try_load_const_llvm_value() {
                return Ok(val);
            }

            let concrete_type = variable.compiler_type.clone();
            let type_str = concrete_type.llvm_representation(self.symbols())?;
            return variable.load_llvm_value(*id, name, self.ctx, &type_str, self.output);
        }

        if let Some(internal_id) = self
            .symbols()
            .get_function_id(&format!("{}.{}", name, self.ctx.current_function_path))
            .or(self.symbols().get_function_id(name))
        {
            return Ok(
                if self
                    .symbols()
                    .get_function_by_id_use(internal_id)
                    .is_generic()
                {
                    CompiledValue::GenericFunction { internal_id }
                } else {
                    CompiledValue::Function { internal_id }
                },
            );
        }
        if let Some(variable) = self
            .symbols()
            .get_static_var(&format!("{}.{}", self.ctx.current_function_path, name))
            .or(self.symbols().get_static_var(name))
            .cloned()
        {
            let mut vtype = variable.compiler_type.clone();
            vtype.substitute_global_aliases(self.symbols())?;
            variable.mark_usage(false, false);
            if let Some(val) = variable.try_load_const_llvm_value() {
                return Ok(val);
            }
            let concrete_type = variable.compiler_type.clone();
            let type_str = concrete_type.llvm_representation(self.symbols())?;
            return variable.load_llvm_value(0, name, self.ctx, &type_str, self.output);
        }
        if let Some(ptype) = PRIMITIVE_TYPES_INFO.iter().find(|x| x.name == name) {
            return Ok(CompiledValue::Type(CompilerType::Primitive(ptype)));
        }
        if let Some(type_id) = self
            .symbols()
            .get_type_id(&format!("{}.{}", self.ctx.current_function_path, name))
            .or(self.symbols().get_type_id(name))
        {
            return Ok(CompiledValue::Type(CompilerType::Struct(type_id)));
        }
        Err(CompilerError::SymbolNotFound(format!(
            "RVAL:Symbol '{}' not found in '{}'",
            name, self.ctx.current_function_path
        ))
        .into())
    }
    fn compile_integer_literal(
        &mut self,
        num: i128,
        expected: Expected,
    ) -> CompileResult<CompiledValue> {
        if let Expected::Type(ptype) = expected {
            if let CompilerType::Primitive(p) = ptype {
                if p.is_integer() {
                    return Ok(CompiledValue::new_value(
                        LLVMVal::ConstantInteger(num),
                        ptype.clone(),
                    ));
                }
                if p.is_bool() {
                    let llvm_repr = if num != 0 { 1 } else { 0 };
                    return Ok(CompiledValue::new_value(
                        LLVMVal::ConstantInteger(llvm_repr),
                        ptype.clone(),
                    ));
                }
            }
            if ptype.is_pointer() && num == 0 {
                return Ok(CompiledValue::new_value(LLVMVal::Null, ptype.clone()));
            }
        }
        Ok(CompiledValue::new_value(
            LLVMVal::ConstantInteger(num),
            CompilerType::Primitive(DEFAULT_INTEGER_TYPE),
        ))
    }
    fn compile_decimal_literal(
        &mut self,
        num_str: f64,
        expected: Expected,
    ) -> CompileResult<CompiledValue> {
        if let Some(x) = expected.get_type().filter(|x| x.is_decimal()) {
            return self.explicit_cast(
                &CompiledValue::new_value(LLVMVal::ConstantDecimal(num_str), x.clone()),
                x,
            );
        };

        Ok(CompiledValue::new_value(
            LLVMVal::ConstantDecimal(num_str),
            CompilerType::Primitive(DEFAULT_DECIMAL_TYPE),
        ))
    }
    fn compile_name_with_generics_rvalue(
        &mut self,
        name: &Box<Expr>,
        generics: &[ParserType],
        _expected: Expected<'_>,
    ) -> CompileResult<CompiledValue> {
        let Expr::Name(fully_qualified_name) = &**name else {
            eprintln!("{:?}", name);
            unimplemented!()
        };
        if let Some(type_id) = self.symbols().get_type_id(fully_qualified_name) {
            let mut q = vec![];
            for x in generics {
                q.push(CompilerType::from_parser_type(
                    &x.clone(),
                    self.symbols(),
                    &self.ctx.current_function_path,
                )?);
            }
            return Ok(CompiledValue::Type(CompilerType::GenericStructInstance(
                type_id,
                self.symbols()
                    .get_type_by_id(type_id)
                    .get_implementation_index(&q)
                    .unwrap(),
            )));
        }
        println!("{:?}", fully_qualified_name);
        unimplemented!();
    }
    fn compile_binary_op(
        &mut self,
        lhs: &Expr,
        op: &BinaryOp,
        rhs: &Expr,
        expected: Expected<'_>,
    ) -> CompileResult<CompiledValue> {
        debug_assert!(expected != Expected::NoReturn);
        if matches!(op, BinaryOp::And | BinaryOp::Or) {
            return self.compile_short_circuit_op(lhs, *op, rhs);
        }
        let left = self.compile_rvalue(lhs, Expected::Anything)?;
        let Ok(ltype) = left.try_get_type().cloned() else {
            return Err(CompilerError::Generic(
                "Left side of binary operation is not value".into(),
            )
            .into());
        };

        let right = self.compile_rvalue(rhs, Expected::Type(&ltype))?;
        let Ok(rtype) = right.try_get_type().cloned() else {
            return Err(CompilerError::Generic(
                "Right side of binary operation is not value".into(),
            )
            .into());
        };

        // Pointer math
        if ltype.is_pointer() && rtype.is_integer() {
            // *(array_pointer + iterator)
            assert!(matches!(op, BinaryOp::Add));
            let utvc = self.ctx.acquire_temp_id();
            let llvm_pointed_to_type = ltype
                .dereference()
                .unwrap()
                .llvm_representation(self.symbols())?;
            let left_ll = (
                ltype.llvm_representation(self.symbols())?,
                left.get_llvm_rep().to_string(),
            );
            let right_ll = (
                rtype.llvm_representation(self.symbols())?,
                right.get_llvm_rep().to_string(),
            );
            self.emit_gep(
                utvc,
                &llvm_pointed_to_type,
                &left_ll.1,
                &[(format!("{} {}", right_ll.0, right_ll.1))],
            );
            return Ok(CompiledValue::new_value(LLVMVal::Register(utvc), ltype));
        }
        if ltype != rtype {
            if ltype.is_pointer() && right.as_literal_number().map(|x| *x == 0).unwrap_or(false) {
            } else if rtype.is_pointer()
                && left.as_literal_number().map(|x| *x == 0).unwrap_or(false)
            {
            } else {
                eprintln!("{:?}", left);
                eprintln!("{:?}", right);
                return Err(CompilerError::TypeMismatch {
                    expected: ltype,
                    found: rtype,
                }
                .into());
            }
        }
        // Boolean math
        if ltype.is_bool() {
            return self.compile_boolean_op(left, op, right);
        }
        // Integer Arithmetic
        if ltype.is_integer() {
            return self.compile_integer_op(left, op, right, ltype);
        }
        if ltype.is_decimal() {
            return self.compile_decimal_op(left, op, right, ltype);
        }
        if ltype.is_pointer() {
            let llvm_op = match op {
                BinaryOp::Equals => "icmp eq",
                BinaryOp::NotEqual => "icmp ne",
                _ => panic!("Operation \"{:?}\" is not permited on pointers", op),
            };
            let utvc = self.ctx.acquire_temp_id();
            self.output.push_function_body(&format!(
                "\t%tmp{} = {} ptr {}, {}\n",
                utvc,
                llvm_op,
                left.get_llvm_rep(),
                right.get_llvm_rep()
            ));
            return Ok(CompiledValue::new_value(
                LLVMVal::Register(utvc),
                CompilerType::Primitive(BOOL_TYPE),
            ));
        }

        Err(CompilerError::Generic(format!(
            "Binary operator \"{:?}\" was not implemted for types \"{:?}\"",
            op, left
        ))
        .into())
    }

    fn compile_short_circuit_op(
        &mut self,
        lhs: &Expr,
        op: BinaryOp,
        rhs: &Expr,
    ) -> CompileResult<CompiledValue> {
        let left = self.compile_rvalue(lhs, Expected::Type(&CompilerType::Primitive(BOOL_TYPE)))?;
        let Ok(ltype) = left.try_get_type() else {
            return Err(CompilerError::Generic(
                "Left side of binary operation is not value".into(),
            )
            .into());
        };
        if !ltype.is_bool() {
            return Err(CompilerError::TypeMismatch {
                expected: CompilerType::Primitive(BOOL_TYPE),
                found: ltype.clone(),
            }
            .into());
        }
        let logic_id = self.ctx.acquire_label_id();
        let result_ptr_reg = self.ctx.acquire_temp_id();

        self.output
            .push_function_intro(&format!("\t%tmp{} = alloca i1\n", result_ptr_reg));

        self.emit_store(
            left.get_llvm_rep(),
            &LLVMVal::Register(result_ptr_reg),
            "i1",
        );

        let label_eval_rhs = format!("logic_rhs_{}", logic_id);
        let label_end = format!("logic_end_{}", logic_id);

        match op {
            BinaryOp::And => {
                self.output.push_function_body(&format!(
                    "\tbr i1 {}, label %{}, label %{}\n",
                    left.get_llvm_rep(),
                    label_eval_rhs,
                    label_end
                ));
            }
            BinaryOp::Or => {
                self.output.push_function_body(&format!(
                    "\tbr i1 {}, label %{}, label %{}\n",
                    left.get_llvm_rep(),
                    label_end,
                    label_eval_rhs
                ));
            }
            _ => unreachable!("compile_short_circuit_op called with non-logic operator"),
        }
        self.output.emit_label(&label_eval_rhs);
        self.ctx.current_block_name = label_eval_rhs;
        let right =
            self.compile_rvalue(rhs, Expected::Type(&CompilerType::Primitive(BOOL_TYPE)))?;
        let Ok(rtype) = right.try_get_type() else {
            return Err(CompilerError::Generic(
                "Right side of binary operation is not value".into(),
            )
            .into());
        };
        if !rtype.is_bool() {
            return Err(CompilerError::TypeMismatch {
                expected: CompilerType::Primitive(BOOL_TYPE),
                found: rtype.clone(),
            }
            .into());
        }

        self.emit_store(
            right.get_llvm_rep(),
            &LLVMVal::Register(result_ptr_reg),
            "i1",
        );

        self.output.emit_unconditional_jump_to(&label_end);

        self.output.emit_label(&label_end);
        self.ctx.current_block_name = label_end;

        let final_reg = self.ctx.acquire_temp_id();
        self.emit_load(final_reg as usize, &LLVMVal::Register(result_ptr_reg), "i1");

        Ok(CompiledValue::new_value(
            LLVMVal::Register(final_reg),
            CompilerType::Primitive(BOOL_TYPE),
        ))
    }
    fn compile_boolean_op(
        &mut self,
        left: CompiledValue,
        op: &BinaryOp,
        right: CompiledValue,
    ) -> CompileResult<CompiledValue> {
        let llvm_op = match op {
            BinaryOp::And => "and",
            BinaryOp::Or => "or",
            BinaryOp::BitAnd => "and",
            BinaryOp::BitOr => "or",
            BinaryOp::BitXor => "xor",
            BinaryOp::Equals => "icmp eq",
            BinaryOp::NotEqual => "icmp ne",
            _ => {
                return Err(CompilerError::Generic(format!(
                    "Unsupported boolean binary operator: {:?}",
                    op
                ))
                .into())
            }
        };
        let utvc = self.emit_binary_op(
            llvm_op,
            BOOL_TYPE.llvm_name,
            left.try_get_llvm_rep()?,
            right.try_get_llvm_rep()?,
        );
        return Ok(CompiledValue::new_value(
            LLVMVal::Register(utvc),
            CompilerType::Primitive(BOOL_TYPE),
        ));
    }
    fn compile_integer_op(
        &mut self,
        left: CompiledValue,
        op: &BinaryOp,
        right: CompiledValue,
        ltype: CompilerType,
    ) -> CompileResult<CompiledValue> {
        let is_signed = ltype.is_signed_integer();

        let llvm_op = match op {
            BinaryOp::Add => "add",
            BinaryOp::Subtract => "sub",
            BinaryOp::Multiply => "mul",
            BinaryOp::Divide => {
                if is_signed {
                    "sdiv"
                } else {
                    "udiv"
                }
            }
            BinaryOp::Modulo => {
                if is_signed {
                    "srem"
                } else {
                    "urem"
                }
            }

            BinaryOp::Equals => "icmp eq",
            BinaryOp::NotEqual => "icmp ne",
            BinaryOp::Less => {
                if is_signed {
                    "icmp slt"
                } else {
                    "icmp ult"
                }
            }

            BinaryOp::LessEqual => {
                if is_signed {
                    "icmp sle"
                } else {
                    "icmp ule"
                }
            }
            BinaryOp::Greater => {
                if is_signed {
                    "icmp sgt"
                } else {
                    "icmp ugt"
                }
            }
            BinaryOp::GreaterEqual => {
                if is_signed {
                    "icmp sge"
                } else {
                    "icmp uge"
                }
            }

            BinaryOp::BitAnd => "and",
            BinaryOp::BitOr => "or",
            BinaryOp::BitXor => "xor",

            BinaryOp::ShiftLeft => "shl",
            BinaryOp::ShiftRight => {
                if is_signed {
                    "ashr"
                } else {
                    "lshr"
                }
            }

            BinaryOp::And => "and",
            BinaryOp::Or => "or",
        };
        let both_types_llvm_repr = ltype.llvm_representation(self.symbols())?;
        let utvc = self.emit_binary_op(
            llvm_op,
            &both_types_llvm_repr,
            left.try_get_llvm_rep()?,
            right.try_get_llvm_rep()?,
        );

        let result_type = if llvm_op.starts_with("icmp") {
            CompilerType::Primitive(BOOL_TYPE)
        } else {
            ltype.clone()
        };

        return Ok(CompiledValue::new_value(
            LLVMVal::Register(utvc),
            result_type,
        ));
    }
    fn compile_decimal_op(
        &mut self,
        left: CompiledValue,
        op: &BinaryOp,
        right: CompiledValue,
        ltype: CompilerType,
    ) -> CompileResult<CompiledValue> {
        let llvm_op = match op {
            BinaryOp::Add => "fadd",
            BinaryOp::Subtract => "fsub",
            BinaryOp::Multiply => "fmul",
            BinaryOp::Divide => "fdiv",
            BinaryOp::Modulo => "frem",

            BinaryOp::Equals => "fcmp oeq",
            BinaryOp::NotEqual => "fcmp one",
            BinaryOp::Less => "fcmp olt",
            BinaryOp::LessEqual => "fcmp ole",
            BinaryOp::Greater => "fcmp ogt",
            BinaryOp::GreaterEqual => "fcmp oge",

            _ => {
                return Err(CompilerError::Generic(format!(
                    "Unsupported decimal binary operator: {:?}",
                    op
                ))
                .into())
            }
        };
        let both_types_llvm_repr = ltype.llvm_representation(self.symbols())?;
        let utvc = self.emit_binary_op(
            llvm_op,
            &both_types_llvm_repr,
            left.try_get_llvm_rep()?,
            right.try_get_llvm_rep()?,
        );
        let result_type = if llvm_op.starts_with("fcmp") {
            CompilerType::Primitive(BOOL_TYPE)
        } else {
            ltype
        };
        return Ok(CompiledValue::new_value(
            LLVMVal::Register(utvc),
            result_type,
        ));
    }
    fn compile_assignment(
        &mut self,
        lhs: &Expr,
        rhs: &Expr,
        expected: Expected,
    ) -> CompileResult<CompiledValue> {
        let left_ptr = self.compile_lvalue(lhs, true, false)?;
        let right_val = self.compile_rvalue(rhs, Expected::Type(&left_ptr.value_type))?;
        let Ok(rtype) = right_val.try_get_type() else {
            return Err(CompilerError::Generic(
                "Right side of binary operation is not value".into(),
            )
            .into());
        };
        if left_ptr.value_type != *rtype {
            eprintln!("LEFT TYPE: {:?}", left_ptr.value_type);
            eprintln!("RIGHT TYPE: {:?}", rtype);
            return Err(CompilerError::InvalidExpression(format!(
                "Type mismatch in assignment: {:?} and {:?}",
                left_ptr.value_type, rtype
            ))
            .into());
        }
        let type_repr = left_ptr.value_type.llvm_representation(self.symbols())?;
        self.emit_store(
            right_val.try_get_llvm_rep()?,
            &left_ptr.location,
            &type_repr,
        );

        if matches!(expected, Expected::NoReturn) {
            Ok(CompiledValue::NoReturn {
                program_halt: false,
            })
        } else {
            Ok(right_val)
        }
    }
    fn compile_unified_call(
        &mut self,
        callee: &Expr,
        given_args: &[Expr],
        given_generics: Option<&[ParserType]>,
        expected: Expected<'_>,
    ) -> CompileResult<CompiledValue> {
        if let Some(generics) = given_generics {
            if let Some(x) =
                self.compiler_function_calls_generic(callee, given_args, generics, &expected)
            {
                return x;
            }
        } else {
            if let Some(x) = self.compiler_function_calls(callee, given_args, &expected) {
                return x;
            }
        }

        let lvalue = self.compile_lvalue(callee, false, false)?;
        let mut program_halt = false;
        let (required_arguments, return_type, llvm_call_site, inline_body_info) = {
            if let CompilerType::Function(ret, args) = lvalue.value_type {
                if let Some(id) = lvalue.function_id {
                    let func = self.symbols().get_function_by_id(id);
                    program_halt = func.is_program_halt();
                    if let Some(generics) = given_generics {
                        let generic_types = generics
                            .iter()
                            .map(|x| {
                                CompilerType::from_parser_type(
                                    x,
                                    self.symbols(),
                                    &self.ctx.current_function_path,
                                )
                            })
                            .collect::<CompileResult<Vec<_>>>()?;

                        let impl_index = func
                            .get_generic_implementation_index(&generic_types)
                            .unwrap();

                        let ft = func
                            .get_def_by_implementation_index(impl_index, self.symbols())
                            .unwrap();

                        (
                            ft.1.to_vec(),
                            *ft.0.clone(),
                            format!(
                                "@{}",
                                func.get_implementation_name(impl_index, self.symbols())
                            ),
                            None,
                        )
                    } else if func.is_inline() {
                        (
                            func.args.iter().map(|(_, t)| t.clone()).collect(),
                            func.return_type.clone(),
                            String::new(),
                            Some((func.args.clone(), func.body.clone(), id)),
                        )
                    } else {
                        (
                            args.to_vec(),
                            *ret.clone(),
                            lvalue.location.to_string(),
                            None,
                        )
                    }
                } else {
                    if given_generics.is_some() {
                        return Err(CompilerError::Generic(
                            "Cannot apply generics to function pointer".into(),
                        )
                        .into());
                    }
                    (
                        args.to_vec(),
                        *ret.clone(),
                        lvalue.location.to_string(),
                        None,
                    )
                }
            } else {
                panic!("Lvalue for call was not a function: {:?}", lvalue);
            }
        };

        if let Some((func_args_def, body, func_id)) = inline_body_info {
            let p = self
                .symbols()
                .get_function_by_id(func_id)
                .path()
                .to_string();
            return self.perform_inline_expansion(
                given_args,
                &func_args_def,
                &return_type,
                &body,
                p,
            );
        }

        let mut arg_string = vec![];
        for (i, ..) in required_arguments.iter().enumerate() {
            let argument_rvalue =
                self.compile_rvalue(&given_args[i], Expected::Type(&required_arguments[i]))?;
            let Ok(argument_type) = argument_rvalue.try_get_type() else {
                return Err(CompilerError::Generic("Argument is not a value".into()).into());
            };
            if *argument_type != required_arguments[i] {
                return CompileResult::Err(
                    CompilerError::InvalidExpression(format!(
                        "{:?} vs {:?} type missmatch with {}th argument",
                        argument_type,
                        &required_arguments[i],
                        i + 1
                    ))
                    .into(),
                );
            }
            arg_string.push(format!(
                "{} {}",
                argument_type.llvm_representation(self.symbols())?,
                argument_rvalue.get_llvm_rep()
            ));
        }

        let arg_string = arg_string.join(", ");
        let return_type_repr = return_type.llvm_representation(self.symbols())?;

        if return_type.is_void() {
            self.output
                .push_function_body(&format!("\tcall void {}({})\n", llvm_call_site, arg_string));
            return Ok(CompiledValue::NoReturn { program_halt });
        }

        if expected != Expected::NoReturn {
            let utvc = self.ctx.acquire_temp_id();
            self.output.push_function_body(&format!(
                "\t%tmp{} = call {} {}({})\n",
                utvc, return_type_repr, llvm_call_site, arg_string
            ));
            return Ok(CompiledValue::new_value(
                LLVMVal::Register(utvc),
                return_type.clone(),
            ));
        }

        self.output.push_function_body(&format!(
            "\tcall {} {}({})\n",
            return_type_repr, llvm_call_site, arg_string
        ));
        Ok(CompiledValue::NoReturn { program_halt })
    }
    fn perform_inline_expansion(
        &mut self,
        given_args: &[Expr],
        func_args: &[(String, CompilerType)],
        func_return_type: &CompilerType,
        body: &[StmtData],
        current_function_path: String,
    ) -> CompileResult<CompiledValue> {
        if body.is_empty() {
            if func_return_type.is_void() {
                return Ok(CompiledValue::NoReturn {
                    program_halt: false,
                });
            }
            return Err(CompilerError::Generic(
                "Inline function body was empty but return type is not void".to_string(),
            )
            .into());
        }

        let inline_exit_handle = self.ctx.acquire_label_id();
        let return_tmp = if !func_return_type.is_void() {
            let return_utvc = self.ctx.acquire_temp_id();
            let return_llvm = func_return_type.llvm_representation(self.symbols())?;
            self.output
                .push_function_body(&format!("\t%tmp{} = alloca {}\n", return_utvc, return_llvm));
            Some((return_utvc, return_llvm))
        } else {
            None
        };

        let mut prepared_args = vec![];
        for (idx, expr) in given_args.iter().enumerate() {
            let argument_rvalue = self.compile_rvalue(expr, Expected::Type(&func_args[idx].1))?;
            let Ok(argument_type) = argument_rvalue.try_get_type() else {
                return Err(CompilerError::Generic("Argument is not a value".into()).into());
            };
            if argument_type != &func_args[idx].1 {
                return Err(CompilerError::InvalidExpression(format!(
                    "{:?} vs {:?} type missmatch with {}th argument",
                    argument_type,
                    &func_args[idx].1,
                    idx + 1
                ))
                .into());
            }
            prepared_args.push(argument_rvalue);
        }

        let lp = self.ctx.current_function_path.clone();
        let og_scope = self.ctx.scope.clone();

        self.ctx.current_function_path = current_function_path.to_string();

        let mut gener = LLVMGenPass::default();
        for (idx, arg) in prepared_args.iter().enumerate() {
            let var = Variable::new(arg.try_get_type().unwrap().clone(), true, false);
            var.set_constant_value(Some(arg.get_llvm_rep().clone()));
            self.ctx.scope.define(func_args[idx].0.clone(), var, 0);
        }

        let mut terminated = false;

        for x in body {
            match &x.stmt {
                Stmt::Return(opt_expr) => {
                    let return_type = func_return_type;
                    if opt_expr.is_some() && return_type.is_void() {
                        return Err(CompilerError::Generic(
                            "This inline function does not return anything".to_string(),
                        )
                        .into());
                    }
                    if let Some(expr) = opt_expr {
                        let return_tmp = return_tmp.as_ref().unwrap();
                        let value = self.compile_rvalue(expr, Expected::Type(return_type))?;
                        let Ok(value_type) = value.try_get_type() else {
                            return Err(CompilerError::Generic(
                                "Right side of binary operation is not value".into(),
                            )
                            .into());
                        };
                        if value_type != return_type {
                            return Err(CompilerError::TypeMismatch {
                                expected: return_type.clone(),
                                found: value_type.clone(),
                            }
                            .into());
                        }
                        let llvm_type_str = &return_tmp.1;
                        self.emit_store(
                            value.try_get_llvm_rep()?,
                            &LLVMVal::Register(return_tmp.0),
                            llvm_type_str,
                        );
                    } else if !return_type.is_void() {
                        return Err(CompilerError::Generic(
                            "Cannot return without a value from a non-void function.".to_string(),
                        )
                        .into());
                    }

                    self.output.push_function_body(&format!(
                        "\tbr label %inline_exit{}\n",
                        inline_exit_handle
                    ));
                    terminated = true;
                    break;
                }
                _ => {
                    //gener.compile_statement(x, self.output, self.compctx)?;
                }
            }
        }

        if !terminated {
            self.output
                .emit_unconditional_jump_to(&format!("inline_exit{}", inline_exit_handle));
        }
        self.output
            .emit_label(&format!("inline_exit{}", inline_exit_handle));

        self.ctx.scope = og_scope;
        self.ctx.current_function_path = lp;
        self.ctx.current_block_name = format!("inline_exit{}", inline_exit_handle);
        if let Some((id, var_llvm_type)) = return_tmp {
            let rv_utvc = self.ctx.acquire_temp_id();
            self.emit_load(rv_utvc as usize, &LLVMVal::Register(id), &var_llvm_type);
            return Ok(CompiledValue::new_value(
                LLVMVal::Register(rv_utvc),
                func_return_type.clone(),
            ));
        }
        Ok(CompiledValue::NoReturn {
            program_halt: false,
        })
    }
    fn compile_unary_op_rvalue(
        &mut self,
        op: &UnaryOp,
        operand_expr: &Expr,
        expected: Expected,
    ) -> CompileResult<CompiledValue> {
        match op {
            UnaryOp::Deref => {
                let value_rval = self.compile_rvalue(operand_expr, expected)?;
                let Ok(value_type) = value_rval.try_get_type() else {
                    return Err(CompilerError::Generic(
                        "Right side of unary operation is not value".into(),
                    )
                    .into());
                };
                if !value_type.is_pointer() {
                    return Err(CompilerError::Generic(format!(
                        "Cannot dereference non-pointer value {:?}",
                        value_rval
                    ))
                    .into());
                }
                let pointed_to_type = value_type.dereference().unwrap();
                let type_str = pointed_to_type.llvm_representation(self.symbols())?;
                let temp_id = self.ctx.acquire_temp_id();
                self.emit_load(temp_id as usize, value_rval.try_get_llvm_rep()?, &type_str);
                Ok(CompiledValue::new_value(
                    LLVMVal::Register(temp_id),
                    pointed_to_type.clone(),
                ))
            }
            UnaryOp::Pointer => {
                // lvalue.get_llvm_repr()
                let lvalue = self.compile_lvalue(operand_expr, false, false)?;
                let ptype = lvalue.value_type.clone().reference();
                Ok(CompiledValue::new_value(lvalue.location.clone(), ptype))
            }
            UnaryOp::Negate => {
                let value_rval = self.compile_rvalue(operand_expr, expected)?;
                let Ok(value_type) = value_rval.try_get_type() else {
                    return Err(CompilerError::Generic(
                        "Right side of unary operation is not value".into(),
                    )
                    .into());
                };
                if !value_type.is_integer() && !value_type.is_decimal() {
                    return Err(CompilerError::Generic(
                        "Cannot negate non-integer type".to_string(),
                    )
                    .into());
                }
                if let Some(cnst) = value_rval.as_literal_number() {
                    let num = -*cnst;
                    return Ok(CompiledValue::new_value(
                        LLVMVal::ConstantInteger(num),
                        value_type.clone(),
                    ));
                }
                let type_str = value_type.llvm_representation(self.symbols())?;
                let temp_id = if value_type.is_decimal() {
                    self.emit_binary_op(
                        "fsub",
                        &type_str,
                        &&LLVMVal::ConstantDecimal(0.0),
                        value_rval.get_llvm_rep(),
                    )
                } else {
                    self.emit_binary_op(
                        "sub",
                        &type_str,
                        &LLVMVal::ConstantInteger(0),
                        value_rval.get_llvm_rep(),
                    )
                };

                Ok(CompiledValue::new_value(
                    LLVMVal::Register(temp_id),
                    value_type.clone(),
                ))
            }
            UnaryOp::Not => {
                let value_rval = self.compile_rvalue(
                    operand_expr,
                    Expected::Type(&CompilerType::Primitive(BOOL_TYPE)),
                )?;
                let Ok(value_type) = value_rval.try_get_type() else {
                    return Err(CompilerError::Generic(
                        "Right side of unary operation is not value".into(),
                    )
                    .into());
                };
                if !value_type.is_bool() {
                    return Err(CompilerError::InvalidExpression(
                        "Logical NOT can only be applied to booleans".to_string(),
                    )
                    .into());
                }
                let temp_id = self.emit_binary_op(
                    "xor",
                    "i1",
                    &LLVMVal::ConstantInteger(1),
                    value_rval.get_llvm_rep(),
                );
                Ok(CompiledValue::new_value(
                    LLVMVal::Register(temp_id),
                    value_type.clone(),
                ))
            }
        }
    }
    fn compile_static_access_rvalue(
        &mut self,
        expr: &Expr,
        member: &str,
        expected: Expected,
    ) -> CompileResult<CompiledValue> {
        let mut path = vec![member];
        let mut cursor = expr;
        while let Expr::StaticAccess(x, y) = cursor {
            cursor = x;
            path.push(y);
        }
        let Expr::Name(core) = expr else {
            return Err(CompilerError::Generic("Expected name".into()).into());
        };
        let enum_path = if path.len() == 1 {
            core.clone()
        } else {
            format!(
                "{}.{}",
                core,
                path.iter()
                    .skip(1)
                    .rev()
                    .map(|x| x.to_string())
                    .collect::<Vec<_>>()
                    .join(".")
            )
        };
        if let Some(x) = self
            .symbols()
            .get_enum(&format!("{}.{}", self.ctx.current_function_path, enum_path))
            .or(self.symbols().get_enum(&enum_path))
        {
            let e = x
                .fields
                .iter()
                .filter(|x| x.0 == member)
                .nth(0)
                .expect("msg");
            return Ok(CompiledValue::new_value(e.1.clone(), x.base_type.clone()));
        }

        let full_path = format!(
            "{}.{}",
            core,
            path.iter()
                .rev()
                .map(|x| x.to_string())
                .collect::<Vec<_>>()
                .join(".")
        );

        self.compile_name_rvalue(&full_path, expected)
    }
    fn compile_member_access_rvalue(&mut self, expr: &Expr) -> CompileResult<CompiledValue> {
        let member_ptr = self.compile_lvalue(expr, false, false)?;
        let temp_id = self.ctx.acquire_temp_id();
        let ptype = member_ptr
            .value_type
            .with_substituted_generics(self.symbols().alias_types(), self.symbols())?;
        let type_str = ptype.llvm_representation(self.symbols())?;
        self.emit_load(temp_id as usize, &member_ptr.location, &type_str);
        Ok(CompiledValue::new_value(LLVMVal::Register(temp_id), ptype))
    }

    fn compile_index_rvalue(&mut self, array: &Expr, index: &Expr) -> CompileResult<CompiledValue> {
        let l = self.compile_index_lvalue(array, index, false, false)?;
        let ltype = l.value_type;
        let lrepr = l.location;
        let temp_id = self.ctx.acquire_temp_id();
        let type_str = ltype.llvm_representation(self.symbols())?;
        self.emit_load(temp_id as usize, &lrepr, &type_str);
        return Ok(CompiledValue::new_value(
            LLVMVal::Register(temp_id),
            ltype.clone(),
        ));
    }
    fn compile_cast(
        &mut self,
        expr: &Expr,
        target_type: &ParserType,
        expected: Expected,
    ) -> CompileResult<CompiledValue> {
        let mut target_type = CompilerType::from_parser_type(
            target_type,
            self.symbols(),
            &self.ctx.current_function_path,
        )?;
        target_type.substitute_global_aliases(self.symbols())?;
        let value_rval = self.compile_rvalue(expr, expected)?;
        let Ok(value_type) = value_rval.try_get_type() else {
            return Err(CompilerError::Generic("Argument is not a value".into()).into());
        };
        if *value_type == target_type {
            return Ok(value_rval);
        }

        self.explicit_cast(&value_rval, &target_type)
    }
    fn compile_boolean(&mut self, value: bool) -> CompileResult<CompiledValue> {
        Ok(CompiledValue::new_value(
            LLVMVal::ConstantBoolean(value),
            CompilerType::Primitive(BOOL_TYPE),
        ))
    }
    fn compile_null(&mut self, expected: Expected<'_>) -> CompileResult<CompiledValue> {
        if let Some(ptype) = expected.get_type().and_then(|x| x.as_pointer()) {
            return Ok(CompiledValue::new_value(
                LLVMVal::Null,
                CompilerType::Pointer(Box::new(ptype.clone())),
            ));
        }
        Err(CompilerError::Generic("Wrong use of null".to_string()).into())
    }
    fn compile_string_literal(&mut self, str_val: &str) -> CompileResult<CompiledValue> {
        // ---
        let const_id = self.output.add_to_strings_header(str_val.to_string());
        Ok(CompiledValue::new_value(
            LLVMVal::Global(format!(".str.{}", const_id)),
            CompilerType::Pointer(Box::new(CompilerType::Primitive(CHAR_TYPE))),
        ))
    }
    // lval
    pub fn compile_lvalue(
        &mut self,
        expr: &Expr,
        write: bool,
        modify_content: bool,
    ) -> CompileResult<CompiledLValue> {
        match expr {
            Expr::Name(name) => self.compile_name_lvalue(name, write, modify_content),
            Expr::NameWithGenerics(name, generics) => {
                self.compile_name_with_generics_lvalue(name, generics, write, modify_content)
            }
            Expr::StaticAccess(obj, member) => {
                self.compile_static_access_lvalue(obj, member, write, modify_content)
            }
            Expr::MemberAccess(obj, member) => {
                self.compile_member_access_lvalue(obj, member, write, modify_content)
            }
            Expr::UnaryOp(UnaryOp::Deref, operand) => {
                self.compile_deref_lvalue(operand, write, modify_content)
            }
            Expr::Index(array, index) => {
                self.compile_index_lvalue(array, index, write, modify_content)
            }
            //Expr::BinaryOp(..) => self.compile_rvalue(expr, Expected::Anything),
            //Expr::Type(r_type) => self.compile_type(r_type),
            _ => Err(CompilerError::Generic(format!(
                "Expression {:?} is not a valid lvalue",
                expr
            ))
            .into()),
        }
    }
    pub fn compile_name_lvalue(
        &mut self,
        name: &str,
        write: bool,
        modify_content: bool,
    ) -> CompileResult<CompiledLValue> {
        if let Some((variable, id)) = self.ctx.scope.lookup(name) {
            variable.mark_usage(write, modify_content);
            let ptype = variable.compiler_type.clone();
            if variable.get_flags().is_constant {
                if ptype.is_pointer() {
                    if write {
                        return Err(CompilerError::Generic(format!(
                            "Cannot assign to constant variable '{}'",
                            name
                        ))
                        .into());
                    }
                    return Ok(CompiledLValue::new(
                        variable.value().borrow().clone().unwrap(),
                        ptype,
                        false,
                    ));
                }
                panic!(
                    "Constant variable '{}' should not be accessed as an lvalue",
                    name
                );
                //let x = variable.value().borrow().clone().ok_or_else(|| CompileError::InvalidExpression(format!("Constant variable '{}' has no value assigned", name)))?;
                // Allocate if not allocated yet
                //return Ok(CompiledValue::Pointer { llvm_repr: x, ptype });
            }
            let llvm_repr = LLVMVal::Variable(*id);
            return Ok(CompiledLValue::new(llvm_repr, ptype, true));
        }
        if let Some(function) = self
            .symbols()
            .get_function_id(&format!("{}.{}", self.ctx.current_function_path, name))
            .or(self.symbols().get_function_id(name))
        {
            self.symbols().get_function_by_id_use(function);
            return Ok(CompiledLValue::from_function(function, self.symbols())?);
        }
        if let Some(variable) = self
            .symbols()
            .get_static_var(&format!("{}.{}", self.ctx.current_function_path, name))
            .or(self.symbols().get_static_var(name))
        {
            let llvm_repr = LLVMVal::Global(name.to_string());
            variable.mark_usage(write, modify_content);
            return Ok(CompiledLValue::new(
                llvm_repr,
                variable.compiler_type.clone(),
                true,
            ));
        }
        eprintln!("Current Path: {}", self.ctx.current_function_path);
        Err(CompilerError::SymbolNotFound(format!("Lvalue '{}' not found", name)).into())
    }
    fn compile_name_with_generics_lvalue(
        &mut self,
        name: &Expr,
        generics: &[ParserType],
        write: bool,
        modify_content: bool,
    ) -> CompileResult<CompiledLValue> {
        let x = self.compile_lvalue(name, write, modify_content)?;
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
                return Ok(x);
            }
        }
        Err(CompilerError::Generic(format!(
            "Lvalue with generics '{:?}' is not a generic function",
            name
        ))
        .into())
    }
    fn compile_member_access_lvalue(
        &mut self,
        obj: &Expr,
        member: &str,
        write: bool,
        modify_content: bool,
    ) -> CompileResult<CompiledLValue> {
        let obj_lvalue = self.compile_lvalue(obj, false, write || modify_content)?;

        let (base_ptr_repr, mut struct_type) = if obj_lvalue.value_type.is_pointer() {
            let obj_rvalue = self.compile_rvalue(obj, Expected::Anything)?;
            let Ok(obj_type) = obj_rvalue.try_get_type() else {
                return Err(CompilerError::Generic(
                    "Object in member access is not a value".into(),
                )
                .into());
            };
            let internal_type = obj_type.dereference().unwrap();
            (obj_rvalue.get_llvm_rep().clone(), internal_type.clone())
        } else {
            (obj_lvalue.location.clone(), obj_lvalue.value_type.clone())
        };
        struct_type.substitute_global_aliases(self.symbols())?;
        match struct_type {
            CompilerType::Struct(id) => {
                let given_struct = self.symbols().get_type_by_id(id);
                let index = given_struct
                    .fields
                    .iter()
                    .position(|x| x.0 == member)
                    .expect("Member not found");
                let field_type = given_struct.fields[index].1.clone();

                let llvm_struct_type = given_struct.llvm_representation();
                let utvc = self.ctx.acquire_temp_id();
                self.emit_gep(
                    utvc,
                    &llvm_struct_type,
                    &base_ptr_repr.to_string(),
                    &[format!("i32 0"), format!("i32 {}", index)],
                );
                return Ok(CompiledLValue::new(
                    LLVMVal::Register(utvc),
                    field_type.clone(),
                    true,
                ));
            }
            CompilerType::GenericStructInstance(id, implementation_id) => {
                let given_struct = self.symbols().get_type_by_id(id);
                let index = given_struct
                    .fields
                    .iter()
                    .position(|x| x.0 == member)
                    .expect("Member not found");
                let mut field_type = given_struct.fields[index].1.clone();
                let implementation =
                    given_struct.generic_implementations.borrow()[implementation_id].clone();
                let mut type_map = HashMap::new();
                for (ind, prm) in given_struct.generic_params.iter().enumerate() {
                    type_map.insert(prm.clone(), implementation[ind].clone());
                }
                field_type.substitute_generics(&type_map, self.symbols())?;

                let llvm_struct_type = given_struct
                    .llvm_repr_index(implementation_id, self.symbols())
                    .to_string();

                let utvc = self.ctx.acquire_temp_id();
                self.emit_gep(
                    utvc,
                    &llvm_struct_type,
                    &base_ptr_repr.to_string(),
                    &[format!("i32 0"), format!("i32 {}", index)],
                );
                return Ok(CompiledLValue::new(
                    LLVMVal::Register(utvc),
                    field_type.clone(),
                    true,
                ));
            }
            _ => {
                return Err(CompilerError::Generic(format!(
                    "Cannot access member '{}' of non-struct type {:?}",
                    member, struct_type
                ))
                .into())
            }
        }
    }
    fn compile_index_lvalue(
        &mut self,
        array_expr: &Expr,
        index_expr: &Expr,
        _write: bool,
        _modify_content: bool,
    ) -> CompileResult<CompiledLValue> {
        let array_rval = self.compile_lvalue(array_expr, false, _modify_content)?;
        if let Some((size, base)) = array_rval.value_type.as_constant_array() {
            let index_val = self.compile_rvalue(
                index_expr,
                Expected::Type(&CompilerType::Primitive(DEFAULT_INTEGER_TYPE)),
            )?;
            let Ok(index_type) = index_val.try_get_type() else {
                return Err(CompilerError::Generic("Index is not a value".into()).into());
            };
            if let Some(x) = index_val.as_literal_number() {
                if *x as usize >= size {
                    return Err(CompilerError::Generic(format!(
                        "Trying to read value outside of bound of constant array"
                    ))
                    .into());
                }
            }
            let llvm_array_type = array_rval.value_type.llvm_representation(self.symbols())?;

            let return_reg_ind = self.ctx.acquire_temp_id();
            self.emit_gep(
                return_reg_ind,
                &llvm_array_type,
                &array_rval.location.to_string(),
                &[
                    format!("i32 0"),
                    format!(
                        "{} {}",
                        index_type.llvm_representation(self.symbols())?,
                        index_val.get_llvm_rep()
                    ),
                ],
            );
            return Ok(CompiledLValue::new(
                LLVMVal::Register(return_reg_ind),
                base.clone(),
                true,
            ));
        }

        let array_rval = self.compile_rvalue(array_expr, Expected::Anything)?;
        let Ok(array_type) = array_rval.try_get_type() else {
            return Err(CompilerError::Generic("Array is not a value".into()).into());
        };
        let Some(base_type) = array_type.as_pointer() else {
            return Err(CompilerError::InvalidExpression(format!(
                "Cannot index non-pointer type {:?}",
                array_type
            ))
            .into());
        };

        let index_val = self.compile_rvalue(
            index_expr,
            Expected::Type(&CompilerType::Primitive(POINTER_SIZED_TYPE)),
        )?;
        let Ok(index_type) = index_val.try_get_type() else {
            return Err(CompilerError::Generic("Index is not a value".into()).into());
        };
        if !index_type.is_integer() {
            return Err(CompilerError::InvalidExpression(format!(
                "Index must be an integer, but it is {:?}",
                index_type
            ))
            .into());
        }

        let llvm_base_type = base_type.llvm_representation(self.symbols())?;

        let temp_id = self.ctx.acquire_temp_id();
        let gep_ptr_reg = LLVMVal::Register(temp_id);
        self.emit_gep(
            temp_id,
            &llvm_base_type,
            &array_rval.get_llvm_rep().to_string(),
            &[format!(
                "{} {}",
                index_type.llvm_representation(self.symbols())?,
                index_val.get_llvm_rep()
            )],
        );
        Ok(CompiledLValue::new(gep_ptr_reg, base_type.clone(), true))
    }
    fn compile_static_access_lvalue(
        &mut self,
        expr: &Expr,
        member: &str,
        write: bool,
        modify_content: bool,
    ) -> CompileResult<CompiledLValue> {
        let mut path = vec![member];
        let mut cursor = expr;
        while let Expr::StaticAccess(x, y) = cursor {
            cursor = x;
            path.push(y);
        }
        let Expr::Name(core) = expr else {
            return Err(CompilerError::Generic("Expected name".into()).into());
        };
        let full_path = format!(
            "{}.{}",
            core,
            path.iter()
                .rev()
                .map(|x| x.to_string())
                .collect::<Vec<_>>()
                .join(".")
        );
        self.compile_name_lvalue(&full_path, write, modify_content)
    }
    fn compile_deref_lvalue(
        &mut self,
        operand: &Expr,
        _write: bool,
        _modify_content: bool,
    ) -> CompileResult<CompiledLValue> {
        let pointer_rval = self.compile_rvalue(operand, Expected::Anything)?;
        let Ok(pointer_type) = pointer_rval.try_get_type() else {
            return Err(
                CompilerError::Generic("Dereferenced operand is not a value".into()).into(),
            );
        };
        if !pointer_type.is_pointer() {
            return Err(CompilerError::Generic(format!(
                "Cannot dereference non-pointer type: {:?}",
                pointer_type
            ))
            .into());
        }
        let ptype = pointer_type.dereference().unwrap();
        let llvm_repr = &pointer_rval;
        return Ok(CompiledLValue::new(
            llvm_repr.get_llvm_rep().clone(),
            ptype.clone(),
            true,
        ));
    }
    // --------------------------
    fn explicit_cast(
        &mut self,
        value: &CompiledValue,
        to_type: &CompilerType,
    ) -> CompileResult<CompiledValue> {
        let Ok(value_type) = value.try_get_type() else {
            return Err(CompilerError::Generic("Casting value is not a type".into()).into());
        };
        if *value_type == *to_type {
            return Ok(value.clone());
        }

        if let (Some(from_info), Some(to_info)) =
            (value_type.as_primitive(), to_type.as_primitive())
        {
            if from_info.is_integer() && to_info.is_integer() {
                if from_info.layout == to_info.layout {
                    return Ok(CompiledValue::new_value(
                        value.get_llvm_rep().clone(),
                        CompilerType::Primitive(to_info),
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

                let utvc = self.emit_cast(
                    op,
                    from_info.llvm_name,
                    &value.get_llvm_rep().to_string(),
                    to_info.llvm_name,
                );
                return Ok(CompiledValue::new_value(
                    LLVMVal::Register(utvc),
                    CompilerType::Primitive(to_info),
                ));
            } else if from_info.is_decimal() && to_info.is_decimal() {
                if from_info.layout == to_info.layout {
                    return Ok(CompiledValue::new_value(
                        value.get_llvm_rep().clone(),
                        CompilerType::Primitive(to_info),
                    ));
                }
                let op = if from_info.layout.size < to_info.layout.size {
                    "fpext"
                } else {
                    "fptrunc"
                };
                let utvc = self.emit_cast(
                    op,
                    from_info.llvm_name,
                    &value.get_llvm_rep().to_string(),
                    to_info.llvm_name,
                );
                return Ok(CompiledValue::new_value(
                    LLVMVal::Register(utvc),
                    CompilerType::Primitive(to_info),
                ));
            } else if from_info.is_integer() && to_info.is_decimal() {
                let op = if from_info.is_unsigned_integer() {
                    "uitofp"
                } else {
                    "sitofp"
                };
                let utvc = self.emit_cast(
                    op,
                    from_info.llvm_name,
                    &value.get_llvm_rep().to_string(),
                    to_info.llvm_name,
                );
                return Ok(CompiledValue::new_value(
                    LLVMVal::Register(utvc),
                    CompilerType::Primitive(to_info),
                ));
            } else if from_info.is_decimal() && to_info.is_integer() {
                if let LLVMVal::ConstantDecimal(x) = value.get_llvm_rep() {
                    return Ok(CompiledValue::new_value(
                        LLVMVal::ConstantInteger(*x as i128),
                        CompilerType::Primitive(to_info),
                    ));
                }
                let op = if to_type.is_unsigned_integer() {
                    "fptoui"
                } else {
                    "fptosi"
                };
                let utvc = self.emit_cast(
                    op,
                    from_info.llvm_name,
                    &value.get_llvm_rep().to_string(),
                    to_info.llvm_name,
                );
                return Ok(CompiledValue::new_value(
                    LLVMVal::Register(utvc),
                    CompilerType::Primitive(to_info),
                ));
            } else if from_info.is_bool() && to_info.is_integer() {
                let utvc = self.emit_cast(
                    "zext",
                    from_info.llvm_name,
                    &value.get_llvm_rep().to_string(),
                    to_info.llvm_name,
                );
                return Ok(CompiledValue::new_value(
                    LLVMVal::Register(utvc),
                    CompilerType::Primitive(to_info),
                ));
            }
        } else if value_type.is_pointer() && to_type.is_pointer() {
            return Ok(CompiledValue::new_value(
                value.get_llvm_rep().clone(),
                to_type.clone(),
            ));
        }
        panic!("{:?} {:?}", value, to_type)
    }
    fn compiler_function_calls(
        &mut self,
        callee: &Expr,
        given_args: &[Expr],
        expected: &Expected,
    ) -> Option<CompileResult<CompiledValue>> {
        // --
        if let Expr::Name(name) = callee {
            if let Some((_, Some(func_ptr), _)) = COMPILER_FUNCTIONS
                .iter()
                .find(|(n, _, _)| n == &name.as_str())
            {
                return Some(func_ptr(self, given_args, expected));
            }
        }
        None
    }
    fn compiler_function_calls_generic(
        &mut self,
        callee: &Expr,
        given_args: &[Expr],
        given_generic: &[ParserType],
        expected: &Expected,
    ) -> Option<CompileResult<CompiledValue>> {
        // --
        if let Expr::Name(name) = callee {
            if let Some((_, _, Some(generic_ptr))) = COMPILER_FUNCTIONS
                .iter()
                .find(|(n, _, _)| n == &name.as_str())
            {
                return Some(generic_ptr(self, given_args, given_generic, expected));
            }
        }
        None
    }
}
impl<'a> ExpressionCompiler<'a> {
    pub fn emit_store(&mut self, value: &LLVMVal, ptr: &LLVMVal, type_repr: &str) {
        self.output.push_function_body(&format!(
            "\tstore {} {}, {}* {}\n",
            type_repr, value, type_repr, ptr
        ));
    }
    pub fn emit_load(&mut self, target_reg: usize, ptr: &LLVMVal, type_repr: &str) {
        self.output.push_function_body(&format!(
            "\t%tmp{} = load {}, {}* {}\n",
            target_reg, type_repr, type_repr, ptr
        ));
    }
    pub fn emit_binary_op(
        &mut self,
        op: &str,
        type_repr: &str,
        lhs: &LLVMVal,
        rhs: &LLVMVal,
    ) -> u32 {
        let utvc = self.ctx.acquire_temp_id();
        self.output.push_function_body(&format!(
            "\t%tmp{} = {} {} {}, {}\n",
            utvc, op, type_repr, lhs, rhs
        ));
        utvc
    }
    pub fn emit_gep(
        &mut self,
        result_reg: u32,
        type_str: &str,
        base_ptr: &str,
        indices: &[String],
    ) {
        let indices_str = indices.join(", ");
        self.output.push_function_body(&format!(
            "\t%tmp{} = getelementptr inbounds {}, {}* {}, {}\n",
            result_reg, type_str, type_str, base_ptr, indices_str
        ));
    }
    pub fn emit_cast(&mut self, op: &str, from_type: &str, from_val: &str, to_type: &str) -> u32 {
        let utvc = self.ctx.acquire_temp_id();
        self.output.push_function_body(&format!(
            "\t%tmp{} = {} {} {} to {}\n",
            utvc, op, from_type, from_val, to_type
        ));
        utvc
    }
}
pub fn constant_expression_compiler(expr: &Expr) -> CompileResult<LLVMVal> {
    match expr {
        Expr::Integer(x) => Ok(LLVMVal::ConstantInteger(*x)),
        Expr::Boolean(b) => Ok(LLVMVal::ConstantInteger(if *b { 1 } else { 0 })),
        Expr::Decimal(x) => Ok(LLVMVal::ConstantDecimal(*x)),
        Expr::BinaryOp(lhs, op, rhs) => fold_binary_op(lhs, op, rhs),
        _ => Err(
            CompilerError::Generic(format!("Unsupported constant expression: {:?}", expr)).into(),
        ),
    }
}
fn fold_binary_op(lhs: &Expr, op: &BinaryOp, rhs: &Expr) -> CompileResult<LLVMVal> {
    let l_val = constant_expression_compiler(lhs)?;
    let r_val = constant_expression_compiler(rhs)?;

    match (l_val, r_val) {
        (LLVMVal::ConstantInteger(l), LLVMVal::ConstantInteger(r)) => {
            let res = match op {
                BinaryOp::Add => l.wrapping_add(r),
                BinaryOp::Subtract => l.wrapping_sub(r),
                BinaryOp::Multiply => l.wrapping_mul(r),
                BinaryOp::Divide => l.checked_div(r).unwrap_or(0),
                BinaryOp::Modulo => l.checked_rem(r).unwrap_or(0),
                BinaryOp::And | BinaryOp::BitAnd => l & r,
                BinaryOp::Or | BinaryOp::BitOr => l | r,
                BinaryOp::BitXor => l ^ r,
                BinaryOp::ShiftLeft => l.wrapping_shl(r as u32),
                BinaryOp::ShiftRight => l.wrapping_shr(r as u32),
                // Comparisons
                BinaryOp::Equals => return Ok(LLVMVal::ConstantBoolean(l == r)),
                BinaryOp::NotEqual => return Ok(LLVMVal::ConstantBoolean(l != r)),
                BinaryOp::Less => return Ok(LLVMVal::ConstantBoolean(l < r)),
                BinaryOp::LessEqual => return Ok(LLVMVal::ConstantBoolean(l <= r)),
                BinaryOp::Greater => return Ok(LLVMVal::ConstantBoolean(l > r)),
                BinaryOp::GreaterEqual => return Ok(LLVMVal::ConstantBoolean(l >= r)),
            };
            Ok(LLVMVal::ConstantInteger(res))
        }
        // Identity
        (l, r) => {
            if l == r {
                match op {
                    BinaryOp::Subtract | BinaryOp::BitXor => {
                        return Ok(LLVMVal::ConstantInteger(0))
                    }
                    BinaryOp::Equals | BinaryOp::GreaterEqual | BinaryOp::LessEqual => {
                        return Ok(LLVMVal::ConstantBoolean(true))
                    }
                    BinaryOp::NotEqual | BinaryOp::Less | BinaryOp::Greater => {
                        return Ok(LLVMVal::ConstantBoolean(false))
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
                        return Ok(l)
                    }
                    BinaryOp::Multiply if v == 1 => return Ok(l),
                    BinaryOp::Multiply | BinaryOp::BitAnd if v == 0 => return Ok(r), // 0
                    _ => {}
                }
            }
            Err(
                CompilerError::Generic("Constant folding failed on non-constants".to_string())
                    .into(),
            )
        }
    }
}
pub fn constant_expression_optimizer_base(expr: &Expr) -> Option<Expr> {
    match expr {
        Expr::Integer(..) | Expr::Boolean(..) | Expr::Decimal(..) => None,
        Expr::BinaryOp(lhs, op, rhs) => {
            if let Ok(LLVMVal::ConstantInteger(val)) = constant_expression_compiler(expr) {
                return Some(Expr::Integer(val));
            }
            let opt_l = constant_expression_optimizer_base(lhs);
            let opt_r = constant_expression_optimizer_base(rhs);
            if opt_l.is_none() && opt_r.is_none() {
                if matches!(**lhs, Expr::Integer(..)) && op.symetrical() {
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

pub fn compile_expression_v2(
    expr: &Expr,
    expected: Expected,
    span: Span,
    ctx: &mut crate::compiler::passes::CodeGenContext,
    compctx: &mut CompilerContext,
    output: &mut LLVMOutputHandler,
) -> CompileResult<CompiledValue> {
    ExpressionCompiler::new(ctx, output, compctx)
        .compile_rvalue(expr, expected)
        .map_err(|mut x| {
            x.extend_first_span(&format!("in expression {}", expr.debug_emit()), span);
            x
        })
}
