use std::collections::HashMap;

use crate::{
    compiler::{LLVMOutputHandler, DONT_COMPILE_AFTER_RETURN, INTERGER_EXPRESION_OPTIMISATION},
    compiler_essentials::{
        CodeGenContext, CompileResult, CompiledLValue, CompilerError, CompilerType, LLVMVal,
        Variable,
    },
};
use rcsharp_parser::{
    compiler_primitives::{
        BOOL_TYPE, BYTE_TYPE, CHAR_TYPE, DEFAULT_DECIMAL_TYPE, DEFAULT_INTEGER_TYPE,
        POINTER_SIZED_TYPE,
    },
    expression_parser::{BinaryOp, Expr, UnaryOp},
    parser::{ParserType, Span, Stmt, StmtData},
};

pub type CompilerFn =
    fn(&mut ExpressionCompiler, &[Expr], &Expected) -> CompileResult<CompiledValue>;
pub type GenericCompilerFn =
    fn(&mut ExpressionCompiler, &[Expr], &[ParserType], &Expected) -> CompileResult<CompiledValue>;

const COMPILER_FUNCTIONS: &[(&str, Option<CompilerFn>, Option<GenericCompilerFn>)] = &[
    ("stalloc", Some(stalloc_impl), Some(stalloc_generic_impl)),
    ("size_of", Some(size_of_impl), Some(size_of_generic_impl)),
    ("align_of", Some(align_of_impl), Some(align_of_generic_impl)),
    ("ptr_of", Some(ptr_of_impl), None),
    ("bitcast", None, Some(bitcast_generic_impl)),
    ("asm", Some(asm_impl), None),
];

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
        ptype: CompilerType,
    },
    Pointer {
        llvm_repr: LLVMVal,
        ptype: CompilerType,
    },
    Function {
        internal_id: usize,
    },
    GenericFunction {
        internal_id: usize,
    },
    GenericFunctionImplementation {
        internal_id: usize,
        types: Box<[CompilerType]>,
    },
    NoReturn,
}
impl CompiledValue {
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
            Self::Value { ptype, .. } | Self::Pointer { ptype, .. } => Ok(ptype),
            Self::NoReturn => {
                Err(CompilerError::Generic("Expression yields no value".into()).into())
            }
            _ => Err(CompilerError::Generic(format!("Cannot get type of {:?}", self)).into()),
        }
    }

    pub fn try_get_llvm_rep(&self) -> CompileResult<&LLVMVal> {
        match self {
            Self::Value { llvm_repr, .. } | Self::Pointer { llvm_repr, .. } => Ok(llvm_repr),
            _ => Err(CompilerError::Generic(format!(
                "Value {:?} has no LLVM representation",
                self
            ))
            .into()),
        }
    }
}
pub struct ExpressionCompiler<'a, 'b> {
    ctx: &'a mut CodeGenContext<'b>,
    output: &'a mut LLVMOutputHandler,
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
            Self::Pointer { llvm_repr, .. } => llvm_repr,
            _ => panic!("{:?}", self),
        }
    }
    pub fn equal_type(&self, other: &CompilerType) -> bool {
        match self {
            Self::Value { ptype, .. } => ptype == other,
            Self::Pointer { ptype, .. } => ptype == other,
            _ => false,
        }
    }
}
impl<'a, 'b> ExpressionCompiler<'a, 'b> {
    fn new(ctx: &'a mut CodeGenContext<'b>, output: &'a mut LLVMOutputHandler) -> Self {
        Self { ctx, output }
    }
    fn compile_rvalue(&mut self, expr: &Expr, expected: Expected) -> CompileResult<CompiledValue> {
        match expr {
            Expr::Name(name) => self.compile_name_rvalue(name, expected),
            Expr::NameWithGenerics(name, generics) => {
                self.compile_name_with_generics_rvalue(name, generics, expected)
            }
            Expr::Integer(num_str) => self.compile_integer_literal(*num_str, expected),
            Expr::Decimal(num_str) => self.compile_decimal_literal(*num_str, expected),
            Expr::Assign(lhs, rhs) => self.compile_assignment(lhs, rhs, expected),
            Expr::Call(callee, args) => self.compile_call(callee, args, expected),
            Expr::CallGeneric(callee, args, generic) => {
                self.compile_call_generic(callee, args, generic, expected)
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
    fn compile_name_rvalue(
        &mut self,
        name: &str,
        _expected: Expected,
    ) -> CompileResult<CompiledValue> {
        if let Some((variable, id)) = self.ctx.scope.get_variable(name) {
            variable.get_type(false, false);
            return variable.get_llvm_value(*id, name, self.ctx, self.output);
        }

        if let Some(function) = self
            .ctx
            .symbols
            .get_function_id(&format!("{}.{}", name, self.ctx.current_function_path()))
            .or(self.ctx.symbols.get_function_id(name))
        {
            return Ok(
                if self
                    .ctx
                    .symbols
                    .get_function_by_id_use(function)
                    .is_generic()
                {
                    CompiledValue::GenericFunction {
                        internal_id: function,
                    }
                } else {
                    CompiledValue::Function {
                        internal_id: function,
                    }
                },
            );
        }
        if let Some(variable) = self
            .ctx
            .symbols
            .get_static_var(&format!("{}.{}", self.ctx.current_function_path(), name))
            .or(self.ctx.symbols.get_static_var(name))
        {
            let mut vtype = variable.get_type(false, false).clone();
            vtype.substitute_generic_types_global_aliases(self.ctx.symbols)?;
            return variable.get_llvm_value(1666337, name, self.ctx, self.output);
        }
        Err(CompilerError::SymbolNotFound(format!(
            "RVAL:Symbol '{}' not found in '{}'",
            name, self.ctx.current_function
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
                    return Ok(CompiledValue::Value {
                        llvm_repr: LLVMVal::ConstantInteger(num),
                        ptype: ptype.clone(),
                    });
                }
                if p.is_bool() {
                    let llvm_repr = if num != 0 { 1 } else { 0 };
                    return Ok(CompiledValue::Value {
                        llvm_repr: LLVMVal::ConstantInteger(llvm_repr),
                        ptype: ptype.clone(),
                    });
                }
            }
            if ptype.is_pointer() && num == 0 {
                return Ok(CompiledValue::Value {
                    llvm_repr: LLVMVal::Null,
                    ptype: ptype.clone(),
                });
            }
        }
        Ok(CompiledValue::Value {
            llvm_repr: LLVMVal::ConstantInteger(num),
            ptype: CompilerType::Primitive(DEFAULT_INTEGER_TYPE),
        })
    }
    fn compile_decimal_literal(
        &mut self,
        num_str: f64,
        expected: Expected,
    ) -> CompileResult<CompiledValue> {
        if let Some(x) = expected.get_type().filter(|x| x.is_decimal()) {
            return self.explicit_cast(
                &CompiledValue::Value {
                    llvm_repr: LLVMVal::ConstantDecimal(num_str),
                    ptype: x.clone(),
                },
                x,
            );
        };

        Ok(CompiledValue::Value {
            llvm_repr: LLVMVal::ConstantDecimal(num_str),
            ptype: CompilerType::Primitive(DEFAULT_DECIMAL_TYPE),
        })
    }
    #[allow(unused_variables)]
    fn compile_name_with_generics_rvalue(
        &mut self,
        name: &Box<Expr>,
        generics: &[ParserType],
        expected: Expected<'_>,
    ) -> CompileResult<CompiledValue> {
        unimplemented!()
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
        let mut left = self.compile_rvalue(lhs, Expected::Anything)?;
        debug_assert!(left != CompiledValue::NoReturn);

        let mut right = self.compile_rvalue(rhs, Expected::Type(left.try_get_type()?))?;
        debug_assert!(right != CompiledValue::NoReturn);

        if INTERGER_EXPRESION_OPTIMISATION {
            if let (Some(x), Some(y)) = (left.as_literal_number(), right.as_literal_number()) {
                if let Ok(llvm_repr) = constant_expression_compiler(&Expr::BinaryOp(
                    Box::new(Expr::Integer(*x)),
                    *op,
                    Box::new(Expr::Integer(*y)),
                )) {
                    if let Some(ptype) = expected.get_type().filter(|x| x.is_integer()).cloned() {
                        return Ok(CompiledValue::Value { llvm_repr, ptype });
                    }
                    let ptype = match op {
                        BinaryOp::Equals
                        | BinaryOp::NotEqual
                        | BinaryOp::Less
                        | BinaryOp::LessEqual
                        | BinaryOp::Greater
                        | BinaryOp::GreaterEqual => CompilerType::Primitive(BOOL_TYPE),
                        _ => CompilerType::Primitive(DEFAULT_INTEGER_TYPE),
                    };
                    return Ok(CompiledValue::Value { llvm_repr, ptype });
                }
            }
        }

        // Swap them
        // 10 + x == x + 10
        if left.as_literal_number().is_some()
            && right.as_literal_number().is_none()
            && (matches!(
                op,
                BinaryOp::Add
                    | BinaryOp::Multiply
                    | BinaryOp::BitAnd
                    | BinaryOp::BitOr
                    | BinaryOp::BitXor
                    | BinaryOp::And
                    | BinaryOp::Or
                    | BinaryOp::Equals
                    | BinaryOp::NotEqual
            ))
        {
            (right, left) = (left, right);
        }
        if left.get_llvm_rep() == right.get_llvm_rep() {
            match op {
                BinaryOp::Subtract | BinaryOp::Modulo | BinaryOp::BitXor => {
                    return Ok(CompiledValue::Value {
                        llvm_repr: LLVMVal::ConstantInteger(0),
                        ptype: left.try_get_type()?.clone(),
                    })
                }
                BinaryOp::Divide => {
                    return Ok(CompiledValue::Value {
                        llvm_repr: LLVMVal::ConstantInteger(1),
                        ptype: left.try_get_type()?.clone(),
                    })
                }
                BinaryOp::BitOr | BinaryOp::BitAnd => return Ok(left),
                BinaryOp::Equals | BinaryOp::GreaterEqual | BinaryOp::LessEqual => {
                    return self.compile_boolean(true)
                }
                BinaryOp::NotEqual | BinaryOp::Less | BinaryOp::Greater => {
                    return self.compile_boolean(false)
                }
                _ => {}
            }
        }
        if let Some(v) = right.as_literal_number() {
            let is_zero = *v == 0;
            let is_one = *v == 1;
            match op {
                BinaryOp::Add => {
                    if is_zero {
                        return Ok(left);
                    }
                } // x + 0 = x
                BinaryOp::Subtract => {
                    if is_zero {
                        return Ok(left);
                    }
                } // x - 0 = x
                BinaryOp::Multiply => {
                    if is_zero {
                        return Ok(right);
                    } // x * 0 = 0
                    if is_one {
                        return Ok(left);
                    } // x * 1 = x
                }
                BinaryOp::Divide => {
                    if is_one {
                        return Ok(left);
                    }
                } // x / 1 = x
                BinaryOp::Modulo => {
                    if is_one {
                        return Ok(CompiledValue::Value {
                            llvm_repr: LLVMVal::ConstantInteger(0),
                            ptype: left.try_get_type()?.clone(),
                        });
                    }
                } // x % 1 = 0
                BinaryOp::BitAnd => {
                    if is_zero {
                        return Ok(right);
                    } // x & 0 = 0
                }
                BinaryOp::BitOr => {
                    if is_zero {
                        return Ok(left);
                    } // x | 0 = x
                }
                BinaryOp::BitXor => {
                    if is_zero {
                        return Ok(left);
                    } // x ^ 0 = x
                }
                BinaryOp::ShiftLeft | BinaryOp::ShiftRight => {
                    if is_zero {
                        return Ok(left);
                    } // x << 0 = x
                }
                _ => {}
            }
        }

        // Pointer math
        if left.try_get_type()?.is_pointer() && right.try_get_type()?.is_integer() {
            // *(array_pointer + iterator)
            assert!(matches!(op, BinaryOp::Add));
            let utvc = self.ctx.aquire_unique_temp_value_counter();
            let llvm_pointed_to_type = left
                .try_get_type()?
                .dereference()
                .unwrap()
                .llvm_representation(self.ctx.symbols)?;
            let left_ll = (
                left.try_get_type()?.llvm_representation(self.ctx.symbols)?,
                left.get_llvm_rep().to_string(),
            );
            let right_ll = (
                right
                    .try_get_type()?
                    .llvm_representation(self.ctx.symbols)?,
                right.get_llvm_rep().to_string(),
            );
            self.emit_gep(
                utvc,
                &llvm_pointed_to_type,
                &left_ll.1,
                &[(format!("{} {}", right_ll.0, right_ll.1))],
            );
            return Ok(CompiledValue::Value {
                llvm_repr: LLVMVal::Register(utvc),
                ptype: left.try_get_type()?.clone(),
            });
        }
        if left.try_get_type()? != right.try_get_type()? {
            if left.try_get_type()?.is_pointer()
                && right.as_literal_number().map(|x| *x == 0).unwrap_or(false)
            {
            } else if right.try_get_type()?.is_pointer()
                && left.as_literal_number().map(|x| *x == 0).unwrap_or(false)
            {
            } else {
                println!("{:?}", left);
                println!("{:?}", right);
                return Err(CompilerError::TypeMismatch {
                    expected: left.try_get_type()?.clone(),
                    found: right.try_get_type()?.clone(),
                }
                .into());
            }
        }

        let ltype = left.try_get_type()?;
        // Boolean math
        if ltype.is_bool() {
            return self.compile_boolean_op(left, op, right);
        }
        // Integer Arithmetic
        if ltype.is_integer() {
            return self.compile_integer_op(left, op, right);
        }
        if ltype.is_decimal() {
            return self.compile_decimal_op(left, op, right);
        }
        if ltype.is_pointer() {
            let llvm_op = match op {
                BinaryOp::Equals => "icmp eq",
                BinaryOp::NotEqual => "icmp ne",
                _ => panic!("Operation \"{:?}\" is not permited on pointers", op),
            };
            let utvc = self.ctx.aquire_unique_temp_value_counter();
            self.output.push_str(&format!(
                "    %tmp{} = {} ptr {}, {}\n",
                utvc,
                llvm_op,
                left.get_llvm_rep(),
                right.get_llvm_rep()
            ));
            return Ok(CompiledValue::Value {
                llvm_repr: LLVMVal::Register(utvc),
                ptype: CompilerType::Primitive(BOOL_TYPE),
            });
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
        if !left.try_get_type()?.is_bool() {
            return Err(CompilerError::TypeMismatch {
                expected: CompilerType::Primitive(BOOL_TYPE),
                found: left.try_get_type()?.clone(),
            }
            .into());
        }
        let logic_id = self.ctx.aquire_unique_logic_counter();
        let result_ptr_reg = self.ctx.aquire_unique_temp_value_counter();

        self.output
            .push_function_intro(&format!("    %tmp{} = alloca i1\n", result_ptr_reg));

        self.emit_store(
            left.get_llvm_rep(),
            &LLVMVal::Register(result_ptr_reg),
            "i1",
        );

        let label_eval_rhs = format!("logic_rhs_{}", logic_id);
        let label_end = format!("logic_end_{}", logic_id);

        match op {
            BinaryOp::And => {
                self.output.push_str(&format!(
                    "    br i1 {}, label %{}, label %{}\n",
                    left.get_llvm_rep(),
                    label_eval_rhs,
                    label_end
                ));
            }
            BinaryOp::Or => {
                self.output.push_str(&format!(
                    "    br i1 {}, label %{}, label %{}\n",
                    left.get_llvm_rep(),
                    label_end,
                    label_eval_rhs
                ));
            }
            _ => unreachable!("compile_short_circuit_op called with non-logic operator"),
        }
        self.output.push_str(&format!("{}:\n", label_eval_rhs));
        let right =
            self.compile_rvalue(rhs, Expected::Type(&CompilerType::Primitive(BOOL_TYPE)))?;

        if !right.try_get_type()?.is_bool() {
            return Err(CompilerError::TypeMismatch {
                expected: CompilerType::Primitive(BOOL_TYPE),
                found: right.try_get_type()?.clone(),
            }
            .into());
        }

        self.emit_store(
            right.get_llvm_rep(),
            &LLVMVal::Register(result_ptr_reg),
            "i1",
        );

        self.output
            .push_str(&format!("    br label %{}\n", label_end));

        self.output.push_str(&format!("{}:\n", label_end));

        let final_reg = self.ctx.aquire_unique_temp_value_counter();
        self.emit_load(final_reg as usize, &LLVMVal::Register(result_ptr_reg), "i1");

        Ok(CompiledValue::Value {
            llvm_repr: LLVMVal::Register(final_reg),
            ptype: CompilerType::Primitive(BOOL_TYPE),
        })
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
        return Ok(CompiledValue::Value {
            llvm_repr: LLVMVal::Register(utvc),
            ptype: CompilerType::Primitive(BOOL_TYPE),
        });
    }
    fn compile_integer_op(
        &mut self,
        left: CompiledValue,
        op: &BinaryOp,
        right: CompiledValue,
    ) -> CompileResult<CompiledValue> {
        let ltype = left.try_get_type()?;
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
        let both_types_llvm_repr = ltype.llvm_representation(self.ctx.symbols)?;
        let utvc = self.emit_binary_op(
            llvm_op,
            &both_types_llvm_repr,
            left.try_get_llvm_rep()?,
            right.try_get_llvm_rep()?,
        );

        let result_type = if llvm_op.starts_with("icmp") {
            CompilerType::Primitive(BOOL_TYPE)
        } else {
            left.try_get_type()?.clone()
        };

        return Ok(CompiledValue::Value {
            llvm_repr: LLVMVal::Register(utvc),
            ptype: result_type,
        });
    }
    fn compile_decimal_op(
        &mut self,
        left: CompiledValue,
        op: &BinaryOp,
        right: CompiledValue,
    ) -> CompileResult<CompiledValue> {
        let ltype = left.try_get_type()?;
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
        let both_types_llvm_repr = ltype.llvm_representation(self.ctx.symbols)?;
        let utvc = self.emit_binary_op(
            llvm_op,
            &both_types_llvm_repr,
            left.try_get_llvm_rep()?,
            right.try_get_llvm_rep()?,
        );
        let result_type = if llvm_op.starts_with("fcmp") {
            CompilerType::Primitive(BOOL_TYPE)
        } else {
            left.try_get_type()?.clone()
        };
        return Ok(CompiledValue::Value {
            llvm_repr: LLVMVal::Register(utvc),
            ptype: result_type,
        });
    }
    fn compile_assignment(
        &mut self,
        lhs: &Expr,
        rhs: &Expr,
        expected: Expected,
    ) -> CompileResult<CompiledValue> {
        let left_ptr = self.compile_lvalue(lhs, true, false)?;
        let right_val = self.compile_rvalue(rhs, Expected::Type(left_ptr.get_type()))?;
        assert_ne!(right_val, CompiledValue::NoReturn);
        if left_ptr.get_type() != right_val.try_get_type()? {
            println!("LEFT TYPE: {:?}", left_ptr.get_type());
            println!("RIGHT TYPE: {:?}", right_val.try_get_type()?);
            return Err(CompilerError::InvalidExpression(format!(
                "Type mismatch in assignment: {:?} and {:?}",
                left_ptr.get_type(),
                right_val.try_get_type()?
            ))
            .into());
        }
        let type_repr = left_ptr.get_type().llvm_representation(self.ctx.symbols)?;
        self.emit_store(
            right_val.try_get_llvm_rep()?,
            left_ptr.get_llvm_rep(),
            &type_repr,
        );

        if matches!(expected, Expected::NoReturn) {
            Ok(CompiledValue::NoReturn)
        } else {
            Ok(right_val)
        }
    }
    fn compile_call(
        &mut self,
        callee: &Expr,
        given_args: &[Expr],
        expected: Expected<'_>,
    ) -> CompileResult<CompiledValue> {
        if let Some(x) = self.compiler_function_calls(callee, given_args, &expected) {
            return x;
        }
        let x = self.compile_lvalue(callee, false, false)?;
        let (required_arguments, return_type, llvm_call_site) = {
            if let CompilerType::Function(ret, args) = x.get_type() {
                if let Some(id) = x.id {
                    let func = self.ctx.symbols.get_function_by_id(id);
                    if func.is_inline() {
                        return self.compile_call_inline(
                            given_args,
                            &func.args,
                            &func.return_type,
                            &func.body,
                            id,
                        );
                    }
                }
                (args.to_vec(), *ret.clone(), x.get_llvm_rep())
            } else {
                panic!("{:?}", x);
            }
        };
        let mut arg_string = vec![];
        for (i, ..) in required_arguments.iter().enumerate() {
            let x = self.compile_rvalue(&given_args[i], Expected::Type(&required_arguments[i]))?;
            if *x.try_get_type()? != required_arguments[i] {
                return CompileResult::Err(
                    CompilerError::InvalidExpression(format!(
                        "{:?} vs {:?} type missmatch with {}th argument",
                        x.try_get_type()?,
                        &required_arguments[i],
                        i + 1
                    ))
                    .into(),
                );
            }
            arg_string.push(format!(
                "{} {}",
                x.try_get_type()?.llvm_representation(self.ctx.symbols)?,
                x.get_llvm_rep()
            ));
        }
        let arg_string = arg_string.join(", ");
        let return_type_repr = return_type.llvm_representation(self.ctx.symbols)?;
        if return_type.is_void() {
            self.output.push_str(&format!(
                "    call void {}({})\n",
                llvm_call_site, arg_string
            ));
            return Ok(CompiledValue::NoReturn);
        }
        if expected != Expected::NoReturn {
            let utvc = self.ctx.aquire_unique_temp_value_counter();
            self.output.push_str(&format!(
                "    %tmp{} = call {} {}({})\n",
                utvc, return_type_repr, llvm_call_site, arg_string
            ));
            return Ok(CompiledValue::Value {
                llvm_repr: LLVMVal::Register(utvc),
                ptype: return_type.clone(),
            });
        }
        self.output.push_str(&format!(
            "    call {} {}({})\n",
            return_type_repr, llvm_call_site, arg_string
        ));
        Ok(CompiledValue::NoReturn)
    }

    fn compile_call_inline(
        &mut self,
        given_args: &[Expr],
        func_args: &[(String, CompilerType)],
        func_return_type: &CompilerType,
        body: &[StmtData],
        current_function_id: usize,
    ) -> CompileResult<CompiledValue> {
        if body.is_empty() {
            if func_return_type.is_void() {
                return Ok(CompiledValue::NoReturn);
            }
            return Err(CompilerError::Generic(
                "Inline function body was empty but return type is not void".to_string(),
            )
            .into());
        }

        let inline_exit_handle = self.ctx.aquire_unique_logic_counter();
        let return_tmp = if !func_return_type.is_void() {
            let return_utvc = self.ctx.aquire_unique_temp_value_counter();
            let return_llvm = func_return_type.llvm_representation(self.ctx.symbols)?;
            self.output.push_str(&format!(
                "    %tmp{} = alloca {}\n",
                return_utvc, return_llvm
            ));
            Some((return_utvc, return_llvm))
        } else {
            None
        };
        let mut prepared_args = vec![];
        for (idx, expr) in given_args.iter().enumerate() {
            let x = self.compile_rvalue(expr, Expected::Type(&func_args[idx].1))?;
            if x.try_get_type()? != &func_args[idx].1 {
                return Err(CompilerError::InvalidExpression(format!(
                    "{:?} vs {:?} type missmatch with {}th argument",
                    x.try_get_type()?,
                    &func_args[idx].1,
                    idx + 1
                ))
                .into());
            }
            prepared_args.push(x);
        }

        let lp = self.ctx.current_function;
        let og_scope = self.ctx.scope.clone();

        self.ctx.scope.clear();
        self.ctx.current_function = current_function_id;

        for (idx, arg) in prepared_args.iter().enumerate() {
            let var = Variable::new(arg.try_get_type()?.clone(), true);
            var.set_value(Some(arg.get_llvm_rep().clone()));
            self.ctx
                .scope
                .add_variable(func_args[idx].0.clone(), var, 0);
        }
        for (idx, x) in body.iter().enumerate() {
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
                        if value.try_get_type()? != return_type {
                            return Err(CompilerError::TypeMismatch {
                                expected: return_type.clone(),
                                found: value.try_get_type()?.clone(),
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
                    if idx == body.len() - 1 {
                        break;
                    }
                    self.output.push_str(&format!(
                        "    br label %inline_exit{}\n",
                        inline_exit_handle
                    ));
                    if DONT_COMPILE_AFTER_RETURN && matches!(x.stmt, Stmt::Return(..)) {
                        break;
                    };
                }
                _ => crate::compiler::compile_statement(x, self.ctx, self.output)?,
            }
        }
        self.output.push_str(&format!(
            "    br label %inline_exit{}\n",
            inline_exit_handle
        ));
        self.output
            .push_str(&format!("inline_exit{}:\n", inline_exit_handle));

        self.ctx.scope = og_scope;
        self.ctx.current_function = lp;
        if let Some((id, var_llvm_type)) = return_tmp {
            let rv_utvc = self.ctx.aquire_unique_temp_value_counter();
            self.emit_load(rv_utvc as usize, &LLVMVal::Register(id), &var_llvm_type);
            return Ok(CompiledValue::Value {
                llvm_repr: LLVMVal::Register(rv_utvc),
                ptype: func_return_type.clone(),
            });
        }
        Ok(CompiledValue::NoReturn)
    }
    fn compile_call_generic(
        &mut self,
        callee: &Expr,
        given_args: &[Expr],
        given_generic: &[ParserType],
        expected: Expected<'_>,
    ) -> CompileResult<CompiledValue> {
        if let Some(x) =
            self.compiler_function_calls_generic(callee, given_args, given_generic, &expected)
        {
            return x;
        }
        let x = self.compile_lvalue(callee, false, false)?;
        let (required_arguments, return_type, llvm_call_site) = {
            if let CompilerType::Function(..) = x.get_type() {
                if let Some(id) = x.id {
                    let func = self.ctx.symbols.get_function_by_id(id);
                    println!("{:?}", given_generic);
                    println!(
                        "{:?}",
                        &given_generic
                            .iter()
                            .map(|x| CompilerType::into(x, self.ctx))
                            .collect::<CompileResult<Vec<_>>>()?
                    );

                    let func_id = func
                        .get_implementation_index(
                            &given_generic
                                .iter()
                                .map(|x| CompilerType::into(x, self.ctx))
                                .collect::<CompileResult<Vec<_>>>()?,
                        )
                        .unwrap();
                    let ft = func
                        .get_def_by_implementation_index(func_id, self.ctx.symbols)
                        .unwrap();
                    (
                        ft.1.to_vec(),
                        *ft.0.clone(),
                        func.get_implementation_name(func_id, self.ctx.symbols),
                    )
                } else {
                    unreachable!();
                }
            } else {
                panic!("{:?}", x);
            }
        };
        let mut arg_string = vec![];
        for (i, ..) in required_arguments.iter().enumerate() {
            let x = self.compile_rvalue(&given_args[i], Expected::Type(&required_arguments[i]))?;
            if *x.try_get_type()? != required_arguments[i] {
                return CompileResult::Err(
                    CompilerError::InvalidExpression(format!(
                        "{:?} vs {:?} type missmatch with {}th argument",
                        x.try_get_type()?,
                        &required_arguments[i],
                        i + 1
                    ))
                    .into(),
                );
            }
            arg_string.push(format!(
                "{} {}",
                x.try_get_type()?.llvm_representation(self.ctx.symbols)?,
                x.get_llvm_rep()
            ));
        }
        let arg_string = arg_string.join(", ");
        let return_type_repr = return_type.llvm_representation(self.ctx.symbols)?;
        if return_type.is_void() {
            self.output.push_str(&format!(
                "    call void @{}({})\n",
                llvm_call_site, arg_string
            ));
            return Ok(CompiledValue::NoReturn);
        }
        if expected != Expected::NoReturn {
            let utvc = self.ctx.aquire_unique_temp_value_counter();
            self.output.push_str(&format!(
                "    %tmp{} = call {} @{}({})\n",
                utvc, return_type_repr, llvm_call_site, arg_string
            ));
            return Ok(CompiledValue::Value {
                llvm_repr: LLVMVal::Register(utvc),
                ptype: return_type.clone(),
            });
        }
        self.output.push_str(&format!(
            "    call {} {}({})\n",
            return_type_repr, llvm_call_site, arg_string
        ));
        Ok(CompiledValue::NoReturn)
    }

    fn compile_unary_op_rvalue(
        &mut self,
        op: &UnaryOp,
        operand_expr: &Expr,
        expected: Expected,
    ) -> CompileResult<CompiledValue> {
        match op {
            UnaryOp::Deref => {
                let value = self.compile_rvalue(operand_expr, expected)?;
                if !value.try_get_type()?.is_pointer() {
                    return Err(CompilerError::Generic(format!(
                        "Cannot dereference non-pointer value {:?}",
                        value
                    ))
                    .into());
                }
                let pointed_to_type = value.try_get_type()?.dereference().unwrap();
                let type_str = pointed_to_type.llvm_representation(self.ctx.symbols)?;
                let temp_id = self.ctx.aquire_unique_temp_value_counter();
                self.emit_load(temp_id as usize, value.try_get_llvm_rep()?, &type_str);
                Ok(CompiledValue::Value {
                    llvm_repr: LLVMVal::Register(temp_id),
                    ptype: pointed_to_type.clone(),
                })
            }
            UnaryOp::Pointer => {
                // lvalue.get_llvm_repr()
                let lvalue = self.compile_lvalue(operand_expr, false, false)?;
                let ptype = lvalue.get_type().clone().reference();
                Ok(CompiledValue::Value {
                    llvm_repr: lvalue.get_llvm_rep().clone(),
                    ptype,
                })
            }
            UnaryOp::Negate => {
                let value = self.compile_rvalue(operand_expr, expected)?;
                if !value.try_get_type()?.is_integer() && !value.try_get_type()?.is_decimal() {
                    return Err(CompilerError::Generic(
                        "Cannot negate non-integer type".to_string(),
                    )
                    .into());
                }
                if let Some(cnst) = value.as_literal_number() {
                    let num = -*cnst;
                    return Ok(CompiledValue::Value {
                        llvm_repr: LLVMVal::ConstantInteger(num),
                        ptype: value.try_get_type()?.clone(),
                    });
                }
                let type_str = value
                    .try_get_type()?
                    .llvm_representation(self.ctx.symbols)?;
                let temp_id = if value.try_get_type()?.is_decimal() {
                    self.emit_binary_op(
                        "fsub",
                        &type_str,
                        &&LLVMVal::ConstantDecimal(0.0),
                        value.get_llvm_rep(),
                    )
                } else {
                    self.emit_binary_op(
                        "sub",
                        &type_str,
                        &LLVMVal::ConstantInteger(0),
                        value.get_llvm_rep(),
                    )
                };

                Ok(CompiledValue::Value {
                    llvm_repr: LLVMVal::Register(temp_id),
                    ptype: value.try_get_type()?.clone(),
                })
            }
            UnaryOp::Not => {
                let value = self.compile_rvalue(
                    operand_expr,
                    Expected::Type(&CompilerType::Primitive(BOOL_TYPE)),
                )?;
                if !value.try_get_type()?.is_bool() {
                    return Err(CompilerError::InvalidExpression(
                        "Logical NOT can only be applied to booleans".to_string(),
                    )
                    .into());
                }
                let temp_id = self.emit_binary_op(
                    "xor",
                    "i1",
                    &LLVMVal::ConstantInteger(1),
                    value.get_llvm_rep(),
                );
                Ok(CompiledValue::Value {
                    llvm_repr: LLVMVal::Register(temp_id),
                    ptype: value.try_get_type()?.clone(),
                })
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
            .ctx
            .symbols
            .get_enum(&format!(
                "{}.{}",
                self.ctx.current_function_path(),
                enum_path
            ))
            .or(self.ctx.symbols.get_enum(&enum_path))
        {
            let e = x
                .fields
                .iter()
                .filter(|x| x.0 == member)
                .nth(0)
                .expect("msg");
            return Ok(CompiledValue::Value {
                llvm_repr: e.1.clone(),
                ptype: x.base_type.clone(),
            });
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
        let temp_id = self.ctx.aquire_unique_temp_value_counter();
        let ptype = member_ptr
            .get_type()
            .with_substituted_generic_types(self.ctx.symbols.alias_types(), self.ctx.symbols)?;
        let type_str = ptype.llvm_representation(self.ctx.symbols)?;
        self.emit_load(temp_id as usize, member_ptr.get_llvm_rep(), &type_str);
        Ok(CompiledValue::Value {
            llvm_repr: LLVMVal::Register(temp_id),
            ptype,
        })
    }

    fn compile_index_rvalue(&mut self, array: &Expr, index: &Expr) -> CompileResult<CompiledValue> {
        let l = self.compile_index_lvalue(array, index, false, false)?;
        let ltype = l.get_type();
        let lrepr = l.get_llvm_rep();
        let temp_id = self.ctx.aquire_unique_temp_value_counter();
        let type_str = ltype.llvm_representation(self.ctx.symbols)?;
        self.emit_load(temp_id as usize, lrepr, &type_str);
        return Ok(CompiledValue::Value {
            llvm_repr: LLVMVal::Register(temp_id),
            ptype: ltype.clone(),
        });
    }
    fn compile_cast(
        &mut self,
        expr: &Expr,
        target_type: &ParserType,
        expected: Expected,
    ) -> CompileResult<CompiledValue> {
        let mut target_type = CompilerType::into_path(
            target_type,
            self.ctx.symbols,
            self.ctx.current_function_path(),
        )?;
        target_type.substitute_generic_types_global_aliases(self.ctx.symbols)?;
        let value = self.compile_rvalue(expr, expected)?;

        if value.try_get_type()? == &target_type {
            return Ok(value);
        }

        self.explicit_cast(&value, &target_type)
    }
    fn compile_boolean(&mut self, value: bool) -> CompileResult<CompiledValue> {
        Ok(CompiledValue::Value {
            llvm_repr: LLVMVal::ConstantBoolean(value),
            ptype: CompilerType::Primitive(BOOL_TYPE),
        })
    }
    fn compile_null(&mut self, expected: Expected<'_>) -> CompileResult<CompiledValue> {
        if let Some(ptype) = expected.get_type().and_then(|x| x.as_pointer()) {
            return Ok(CompiledValue::Value {
                llvm_repr: LLVMVal::Null,
                ptype: CompilerType::Pointer(Box::new(ptype.clone())),
            });
        }
        Err(CompilerError::Generic("Wrong use of null".to_string()).into())
    }
    fn compile_string_literal(&mut self, str_val: &str) -> CompileResult<CompiledValue> {
        // ---
        let const_id = self.output.add_to_strings_header(str_val.to_string());
        Ok(CompiledValue::Value {
            llvm_repr: LLVMVal::Global(format!(".str.{}", const_id)),
            ptype: CompilerType::Pointer(Box::new(CompilerType::Primitive(CHAR_TYPE))),
        })
    }
    // lval
    fn compile_lvalue(
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
    fn compile_name_lvalue(
        &mut self,
        name: &str,
        write: bool,
        modify_content: bool,
    ) -> CompileResult<CompiledLValue> {
        if let Some((variable, id)) = self.ctx.scope.get_variable(name) {
            let ptype = variable.get_type(write, modify_content).clone();
            if variable.is_constant() {
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
            let llvm_repr = if variable.is_argument() {
                LLVMVal::VariableName(name.to_string())
            } else {
                LLVMVal::Variable(*id)
            };
            return Ok(CompiledLValue::new(llvm_repr, ptype, true));
        }
        if let Some(function) = self
            .ctx
            .symbols
            .get_function_id(&format!("{}.{}", self.ctx.current_function_path(), name))
            .or(self.ctx.symbols.get_function_id(name))
        {
            self.ctx.symbols.get_function_by_id_use(function);
            return Ok(CompiledLValue::new_fn(function, self.ctx.symbols)?);
        }
        if let Some(variable) = self
            .ctx
            .symbols
            .get_static_var(&format!("{}.{}", self.ctx.current_function_path(), name))
            .or(self.ctx.symbols.get_static_var(name))
        {
            let llvm_repr = LLVMVal::Global(name.to_string());

            return Ok(CompiledLValue::new(
                llvm_repr,
                variable.get_type(write, modify_content).clone(),
                true,
            ));
        }
        println!("{:?}", self.ctx.current_function_path());
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
        if x.get_type().is_generic() {
            if let LLVMVal::ConstantInteger(internal_id) = x.get_llvm_rep() {
                let internal_id = *internal_id as usize;
                if generics.is_empty() {
                    return Err(CompilerError::Generic(format!(
                        "Generic function '{}' requires generic parameters",
                        internal_id
                    ))
                    .into());
                }
                let _func = self.ctx.symbols.get_function_by_id_use(internal_id);
                let mut tp = _func.get_type();
                if !_func.is_generic() {
                    return Err(CompilerError::Generic(format!("")).into());
                }
                let mut map = HashMap::new();
                let mut t = vec![];
                for (i, x) in _func.generic_params.iter().enumerate() {
                    let mut ct = CompilerType::into(&generics[i], self.ctx)?;
                    t.push(ct.clone());
                    ct.substitute_generic_types_global_aliases(self.ctx.symbols)?;
                    map.insert(x.to_string(), ct);
                }
                tp.substitute_generic_types(&map, self.ctx.symbols)?;
                let impl_index = _func.get_implementation_index(&t).unwrap();

                let mut x = CompiledLValue::new(
                    LLVMVal::Global(
                        _func
                            .get_implementation_name(impl_index, self.ctx.symbols)
                            .into_string(),
                    ),
                    tp,
                    false,
                );
                x.id = Some(internal_id);
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

        let (base_ptr_repr, mut struct_type) = if obj_lvalue.get_type().is_pointer() {
            let obj_rvalue = self.compile_rvalue(obj, Expected::Anything)?;
            let internal_type = obj_rvalue.try_get_type()?.dereference().expect("Should");
            (obj_rvalue.get_llvm_rep().clone(), internal_type.clone())
        } else {
            (
                obj_lvalue.get_llvm_rep().clone(),
                obj_lvalue.get_type().clone(),
            )
        };
        struct_type.substitute_generic_types_global_aliases(self.ctx.symbols)?;
        match struct_type {
            CompilerType::StructType(id) => {
                let given_struct = self.ctx.symbols.get_type_by_id(id);
                let index = given_struct
                    .fields
                    .iter()
                    .position(|x| x.0 == member)
                    .expect("Member not found");
                let field_type = &given_struct.fields[index].1;

                let llvm_struct_type = given_struct.llvm_representation();
                let utvc = self.ctx.aquire_unique_temp_value_counter();
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
            CompilerType::GenericStructType(id, implementation_id) => {
                let given_struct = self.ctx.symbols.get_type_by_id(id);
                let index = given_struct
                    .fields
                    .iter()
                    .position(|x| x.0 == member)
                    .expect("Member not found");
                let mut field_type = given_struct.fields[index].1.clone();
                let implementation =
                    &given_struct.generic_implementations.borrow()[implementation_id];
                let mut type_map = HashMap::new();
                for (ind, prm) in given_struct.generic_params.iter().enumerate() {
                    type_map.insert(prm.clone(), implementation[ind].clone());
                }
                field_type.substitute_generic_types(&type_map, self.ctx.symbols)?;

                let llvm_struct_type =
                    given_struct.llvm_repr_index(implementation_id, self.ctx.symbols);
                let utvc = self.ctx.aquire_unique_temp_value_counter();
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
        if let Some((size, base)) = array_rval.get_type().as_constant_array() {
            let index_val = self.compile_rvalue(
                index_expr,
                Expected::Type(&CompilerType::Primitive(DEFAULT_INTEGER_TYPE)),
            )?;
            if let Some(x) = index_val.as_literal_number() {
                if *x as usize >= size {
                    return Err(CompilerError::Generic(format!(
                        "Trying to read value outside of bound of constant array"
                    ))
                    .into());
                }
            }
            let llvm_array_type = array_rval
                .get_type()
                .llvm_representation(self.ctx.symbols)?;

            let return_reg_ind = self.ctx.aquire_unique_temp_value_counter();
            self.emit_gep(
                return_reg_ind,
                &llvm_array_type,
                &array_rval.get_llvm_rep().to_string(),
                &[
                    format!("i32 0"),
                    format!(
                        "{} {}",
                        index_val
                            .try_get_type()?
                            .llvm_representation(self.ctx.symbols)?,
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
        let Some(base_type) = array_rval.try_get_type()?.as_pointer() else {
            return Err(CompilerError::InvalidExpression(format!(
                "Cannot index non-pointer type {:?}",
                array_rval.try_get_type()?
            ))
            .into());
        };

        let index_val = self.compile_rvalue(
            index_expr,
            Expected::Type(&CompilerType::Primitive(POINTER_SIZED_TYPE)),
        )?;

        if !index_val.try_get_type()?.is_integer() {
            return Err(CompilerError::InvalidExpression(format!(
                "Index must be an integer, but got {:?}",
                index_val.try_get_type()?
            ))
            .into());
        }

        let llvm_base_type = base_type.llvm_representation(self.ctx.symbols)?;

        let temp_id = self.ctx.aquire_unique_temp_value_counter();
        let gep_ptr_reg = LLVMVal::Register(temp_id);
        self.emit_gep(
            temp_id,
            &llvm_base_type,
            &array_rval.get_llvm_rep().to_string(),
            &[format!(
                "{} {}",
                index_val
                    .try_get_type()?
                    .llvm_representation(self.ctx.symbols)?,
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
        if !pointer_rval.try_get_type()?.is_pointer() {
            return Err(CompilerError::Generic(format!(
                "Cannot dereference non-pointer type: {:?}",
                pointer_rval.try_get_type()?
            ))
            .into());
        }
        let ptype = pointer_rval.try_get_type()?.dereference().expect("msg");
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
        let lval_type = value.try_get_type()?;
        if lval_type == to_type {
            return Ok(value.clone());
        }

        if let (Some(from_info), Some(to_info)) =
            (value.try_get_type()?.as_primitive(), to_type.as_primitive())
        {
            if from_info.is_integer() && to_info.is_integer() {
                if from_info.layout == to_info.layout {
                    return Ok(CompiledValue::Value {
                        llvm_repr: value.get_llvm_rep().clone(),
                        ptype: CompilerType::Primitive(to_info),
                    });
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
                return Ok(CompiledValue::Value {
                    llvm_repr: LLVMVal::Register(utvc),
                    ptype: CompilerType::Primitive(to_info),
                });
            } else if from_info.is_decimal() && to_info.is_decimal() {
                if from_info.layout == to_info.layout {
                    return Ok(CompiledValue::Value {
                        llvm_repr: value.get_llvm_rep().clone(),
                        ptype: CompilerType::Primitive(to_info),
                    });
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
                return Ok(CompiledValue::Value {
                    llvm_repr: LLVMVal::Register(utvc),
                    ptype: CompilerType::Primitive(to_info),
                });
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
                return Ok(CompiledValue::Value {
                    llvm_repr: LLVMVal::Register(utvc),
                    ptype: CompilerType::Primitive(to_info),
                });
            } else if from_info.is_decimal() && to_info.is_integer() {
                if let LLVMVal::ConstantDecimal(x) = value.get_llvm_rep() {
                    return Ok(CompiledValue::Value {
                        llvm_repr: LLVMVal::ConstantInteger(*x as i128),
                        ptype: CompilerType::Primitive(to_info),
                    });
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
                return Ok(CompiledValue::Value {
                    llvm_repr: LLVMVal::Register(utvc),
                    ptype: CompilerType::Primitive(to_info),
                });
            } else if from_info.is_bool() && to_info.is_integer() {
                let utvc = self.emit_cast(
                    "zext",
                    from_info.llvm_name,
                    &value.get_llvm_rep().to_string(),
                    to_info.llvm_name,
                );
                return Ok(CompiledValue::Value {
                    llvm_repr: LLVMVal::Register(utvc),
                    ptype: CompilerType::Primitive(to_info),
                });
            }
        } else if value.try_get_type()?.is_pointer() && to_type.is_pointer() {
            return Ok(CompiledValue::Value {
                llvm_repr: value.get_llvm_rep().clone(),
                ptype: to_type.clone(),
            });
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
impl<'a, 'b> ExpressionCompiler<'a, 'b> {
    fn emit_store(&mut self, value: &LLVMVal, ptr: &LLVMVal, type_repr: &str) {
        self.output.push_str(&format!(
            "    store {} {}, {}* {}\n",
            type_repr, value, type_repr, ptr
        ));
    }
    fn emit_load(&mut self, target_reg: usize, ptr: &LLVMVal, type_repr: &str) {
        self.output.push_str(&format!(
            "    %tmp{} = load {}, {}* {}\n",
            target_reg, type_repr, type_repr, ptr
        ));
    }
    fn emit_binary_op(&mut self, op: &str, type_repr: &str, lhs: &LLVMVal, rhs: &LLVMVal) -> u32 {
        let utvc = self.ctx.aquire_unique_temp_value_counter();
        self.output.push_str(&format!(
            "    %tmp{} = {} {} {}, {}\n",
            utvc, op, type_repr, lhs, rhs
        ));
        utvc
    }
    fn emit_gep(&mut self, result_reg: u32, type_str: &str, base_ptr: &str, indices: &[String]) {
        let indices_str = indices.join(", ");
        self.output.push_str(&format!(
            "    %tmp{} = getelementptr inbounds {}, {}* {}, {}\n",
            result_reg, type_str, type_str, base_ptr, indices_str
        ));
    }
    fn emit_cast(&mut self, op: &str, from_type: &str, from_val: &str, to_type: &str) -> u32 {
        let utvc = self.ctx.aquire_unique_temp_value_counter();
        self.output.push_str(&format!(
            "    %tmp{} = {} {} {} to {}\n",
            utvc, op, from_type, from_val, to_type
        ));
        utvc
    }
}

pub fn constant_expression_compiler(expr: &Expr) -> CompileResult<LLVMVal> {
    match expr {
        Expr::Integer(x) => Ok(LLVMVal::ConstantInteger(x.clone())),
        Expr::Boolean(b) => Ok(LLVMVal::ConstantInteger(if *b { 1 } else { 0 })),
        Expr::Decimal(x) => Ok(LLVMVal::ConstantDecimal(x.clone())),
        Expr::BinaryOp(x, op, y) => {
            let l = constant_expression_compiler(x)?;
            let r = constant_expression_compiler(y)?;
            if let (LLVMVal::ConstantInteger(l), LLVMVal::ConstantInteger(r)) = (l, r) {
                let v = match op {
                    BinaryOp::Add => l.wrapping_add(r),
                    BinaryOp::Subtract => l.wrapping_sub(r),
                    BinaryOp::Multiply => l.wrapping_mul(r),
                    BinaryOp::Divide => l.checked_div(r).unwrap_or(0),
                    BinaryOp::Modulo => l.checked_rem(r).unwrap_or(0),
                    BinaryOp::Equals => (l == r) as i128,
                    BinaryOp::NotEqual => (l != r) as i128,
                    BinaryOp::Less => (l < r) as i128,
                    BinaryOp::LessEqual => (l <= r) as i128,
                    BinaryOp::Greater => (l > r) as i128,
                    BinaryOp::GreaterEqual => (l >= r) as i128,
                    BinaryOp::And => (l != 0 && r != 0) as i128,
                    BinaryOp::Or => (l != 0 || r != 0) as i128,
                    BinaryOp::BitAnd => l & r,
                    BinaryOp::BitOr => l | r,
                    BinaryOp::BitXor => l ^ r,
                    BinaryOp::ShiftLeft => l.wrapping_shl(r as u32),
                    BinaryOp::ShiftRight => l.wrapping_shr(r as u32),
                };
                return Ok(LLVMVal::ConstantInteger(v));
            }

            Err(CompilerError::Generic("Unsupported constant fold operands".to_string()).into())
        }
        _ => Err(CompilerError::Generic(format!("Unsuported in constant {:?}", expr)).into()),
    }
}

pub fn compile_expression(
    expr: &Expr,
    expected: Expected,
    span: Span,
    ctx: &mut CodeGenContext,
    output: &mut LLVMOutputHandler,
) -> CompileResult<CompiledValue> {
    ExpressionCompiler::new(ctx, output)
        .compile_rvalue(expr, expected)
        .map_err(|mut x| {
            x.extend_first_span(&format!("in expression {}", expr.debug_emit()), span);
            x
        })
}

fn stalloc_impl(
    compiler: &mut ExpressionCompiler,
    given_args: &[Expr],
    _expected: &Expected,
) -> CompileResult<CompiledValue> {
    if given_args.len() != 1 {
        return Err(CompilerError::Generic(format!(
            "stalloc(count) expects exactly 1 argument, but got {}",
            given_args.len()
        ))
        .into());
    }

    let int_type = CompilerType::Primitive(DEFAULT_INTEGER_TYPE);
    let count_val = compiler.compile_rvalue(&given_args[0], Expected::Type(&int_type))?;

    if !count_val.try_get_type()?.is_integer() {
        return Err(CompilerError::Generic(format!(
            "stalloc count must be an integer, but got {:?}",
            count_val.try_get_type()?
        ))
        .into());
    }

    let utvc = compiler.ctx.aquire_unique_temp_value_counter();
    let count_llvm_type = count_val
        .try_get_type()?
        .llvm_representation(compiler.ctx.symbols)?;

    compiler.output.push_str(&format!(
        "    %tmp{} = alloca i8, {} {}\n",
        utvc,
        count_llvm_type,
        count_val.get_llvm_rep()
    ));

    Ok(CompiledValue::Value {
        llvm_repr: LLVMVal::Register(utvc),
        ptype: CompilerType::Pointer(Box::new(CompilerType::Primitive(BYTE_TYPE))),
    })
}
#[allow(unused)]
fn size_of_impl(
    compiler: &mut ExpressionCompiler,
    given_args: &[Expr],
    expected: &Expected,
) -> CompileResult<CompiledValue> {
    if given_args.len() != 1 {
        return Err(CompilerError::Generic(format!(
            "size_of(Type) expects exactly 1 argument, but got {}",
            given_args.len()
        ))
        .into());
    }
    let val = compiler.compile_rvalue(&given_args[0], Expected::Anything)?;
    let size = val
        .try_get_type()?
        .size_and_layout(compiler.ctx.symbols)
        .size;
    Ok(CompiledValue::Value {
        llvm_repr: LLVMVal::ConstantInteger(size as i128),
        ptype: CompilerType::Primitive(DEFAULT_INTEGER_TYPE),
    })
}
fn size_of_generic_impl(
    compiler: &mut ExpressionCompiler,
    given_args: &[Expr],
    given_generic: &[ParserType],
    expected: &Expected,
) -> CompileResult<CompiledValue> {
    if given_generic.len() != 1 {
        return Err(CompilerError::Generic(format!(
            "size_of<T>() expects exactly 1 generic type, but got {}",
            given_generic.len()
        ))
        .into());
    }
    if !given_args.is_empty() {
        return Err(CompilerError::Generic(format!(
            "size_of<T>() expects 0 arguments, but got {}",
            given_args.len()
        ))
        .into());
    }
    let mut target_type = CompilerType::into_path(
        &given_generic[0],
        compiler.ctx.symbols,
        compiler.ctx.current_function_path(),
    )?;
    target_type.substitute_generic_types_global_aliases(compiler.ctx.symbols)?;
    let size = target_type.size_and_layout(compiler.ctx.symbols).size;
    let return_ptype = if let Expected::Type(pt) = expected {
        if pt.is_integer() {
            (*pt).clone()
        } else {
            CompilerType::Primitive(DEFAULT_INTEGER_TYPE)
        }
    } else {
        CompilerType::Primitive(DEFAULT_INTEGER_TYPE)
    };
    Ok(CompiledValue::Value {
        llvm_repr: LLVMVal::ConstantInteger(size as i128),
        ptype: return_ptype,
    })
}
fn stalloc_generic_impl(
    compiler: &mut ExpressionCompiler,
    given_args: &[Expr],
    given_generic: &[ParserType],
    _expected: &Expected,
) -> CompileResult<CompiledValue> {
    if given_generic.len() != 1 {
        return Err(CompilerError::Generic(format!(
            "stalloc<T>(count) expects exactly 1 generic type, but got {}",
            given_generic.len()
        ))
        .into());
    }
    if given_args.len() != 1 {
        return Err(CompilerError::Generic(format!(
            "stalloc<T>(count) expects exactly 1 argument (count), but got {}",
            given_args.len()
        ))
        .into());
    }
    let int_type = CompilerType::Primitive(DEFAULT_INTEGER_TYPE);
    let count_val = compiler.compile_rvalue(&given_args[0], Expected::Type(&int_type))?;
    if !count_val.try_get_type()?.is_integer() {
        return Err(CompilerError::Generic(format!(
            "stalloc count must be an integer, but got {:?}",
            count_val.try_get_type()?
        ))
        .into());
    }

    let target_type = CompilerType::into_path(
        &given_generic[0],
        compiler.ctx.symbols,
        compiler.ctx.current_function_path(),
    )?;
    let llvm_type_str = target_type.llvm_representation(compiler.ctx.symbols)?;
    let utvc = compiler.ctx.aquire_unique_temp_value_counter();
    compiler.output.push_str(&format!(
        "    %tmp{} = alloca {}, {} {}\n",
        utvc,
        llvm_type_str,
        count_val
            .try_get_type()?
            .llvm_representation(compiler.ctx.symbols)?,
        count_val.get_llvm_rep()
    ));
    Ok(CompiledValue::Value {
        llvm_repr: LLVMVal::Register(utvc),
        ptype: target_type.reference(),
    })
}

fn ptr_of_impl(
    compiler: &mut ExpressionCompiler,
    given_args: &[Expr],
    _expected: &Expected,
) -> CompileResult<CompiledValue> {
    if given_args.len() != 1 {
        return Err(CompilerError::Generic(format!(
            "ptr_of(variable) expects exactly 1 argument, but got {}",
            given_args.len()
        ))
        .into());
    }

    let lvalue = compiler.compile_lvalue(&given_args[0], false, false)?;
    if let LLVMVal::Global(x) = lvalue.get_llvm_rep() {
        if matches!(lvalue.get_type(), CompilerType::Function(..)) {
            println!("{:?}", lvalue.get_type().clone().reference());
            println!("{:?}", given_args[0]);
            return Ok(CompiledValue::Value {
                llvm_repr: LLVMVal::Global(x.clone()),
                ptype: lvalue.get_type().clone().reference(),
            });
        }
    }
    if let LLVMVal::Variable(x) = lvalue.get_llvm_rep() {
        return Ok(CompiledValue::Value {
            llvm_repr: LLVMVal::Variable(*x),
            ptype: lvalue.get_type().clone().reference(),
        });
    }

    unimplemented!("{:?}", lvalue);
    /*
    match lvalue {
        CompiledValue::Pointer { llvm_repr, ptype } => Ok(CompiledValue::Value {
            llvm_repr,
            ptype: ptype.reference(),
        }),
        CompiledValue::Function { internal_id } => {
            let func = compiler.ctx.symbols.get_function_by_id(internal_id);
            if func.is_external() {
                return Err(CompilerError::Generic(format!(
                    "Cannot get pointer of external function: {}",
                    func.full_path()
                ))
                .into());
            }
            if func.is_inline() {
                return Err(CompilerError::Generic(format!(
                    "Cannot get pointer of inline function: {}",
                    func.full_path()
                ))
                .into());
            }
            Ok(CompiledValue::Value {
                llvm_repr: LLVMVal::Global(func.full_path().to_string()),
                ptype: func.get_type().reference(),
            })
        }
        CompiledValue::GenericFunctionImplementation { internal_id, types } => {
            let func = compiler.ctx.symbols.get_function_by_id(internal_id);
            let ind = func.get_implementation_index(&types).expect("msg");
            let name = func.call_path_impl_index(ind, compiler.ctx.symbols);

            let mut type_map = HashMap::new();
            for (ind, prm) in func.generic_params.iter().enumerate() {
                type_map.insert(prm.clone(), types[ind].clone());
            }

            let ptype = func
                .get_type()
                .with_substituted_generic_types(&type_map, compiler.ctx.symbols)?
                .reference();
            Ok(CompiledValue::Value {
                llvm_repr: LLVMVal::Global(name.to_string()),
                ptype,
            })
        }
        _ => Err(CompilerError::Generic(format!(
            "Cannot take the address of an R-value or non-addressable expression: {:?}",
            given_args[0]
        ))
        .into()),
    }
     */
}
#[allow(unused)]
fn align_of_impl(
    compiler: &mut ExpressionCompiler,
    given_args: &[Expr],
    expected: &Expected,
) -> CompileResult<CompiledValue> {
    if given_args.len() != 1 {
        return Err(CompilerError::Generic(format!(
            "align_of(Type) expects exactly 1 argument, but got {}",
            given_args.len()
        ))
        .into());
    }
    let val = compiler.compile_rvalue(&given_args[0], Expected::Anything)?;
    let size = val
        .try_get_type()?
        .size_and_layout(compiler.ctx.symbols)
        .align;
    Ok(CompiledValue::Value {
        llvm_repr: LLVMVal::ConstantInteger(size as i128),
        ptype: CompilerType::Primitive(DEFAULT_INTEGER_TYPE),
    })
}
#[allow(unused)]
fn align_of_generic_impl(
    compiler: &mut ExpressionCompiler,
    given_args: &[Expr],
    given_generic: &[ParserType],
    expected: &Expected,
) -> CompileResult<CompiledValue> {
    if given_generic.len() != 1 {
        return Err(CompilerError::Generic(format!(
            "size_of<T>() expects exactly 1 generic type, but got {}",
            given_generic.len()
        ))
        .into());
    }
    if !given_args.is_empty() {
        return Err(CompilerError::Generic(format!(
            "size_of<T>() expects 0 arguments, but got {}",
            given_args.len()
        ))
        .into());
    }
    let mut target_type = CompilerType::into_path(
        &given_generic[0],
        compiler.ctx.symbols,
        compiler.ctx.current_function_path(),
    )?;
    target_type.substitute_generic_types_global_aliases(compiler.ctx.symbols)?;
    let align = target_type.size_and_layout(compiler.ctx.symbols).align;
    let return_ptype = if let Expected::Type(pt) = expected {
        if pt.is_integer() {
            (*pt).clone()
        } else {
            CompilerType::Primitive(DEFAULT_INTEGER_TYPE)
        }
    } else {
        CompilerType::Primitive(DEFAULT_INTEGER_TYPE)
    };
    Ok(CompiledValue::Value {
        llvm_repr: LLVMVal::ConstantInteger(align as i128),
        ptype: return_ptype,
    })
}
// Done
fn bitcast_generic_impl(
    compiler: &mut ExpressionCompiler,
    given_args: &[Expr],
    given_generic: &[ParserType],
    _expected: &Expected,
) -> CompileResult<CompiledValue> {
    if given_generic.len() != 1 {
        return Err(CompilerError::CompilerFunctionGenericCountMissmatch(
            "bitcast<T>(value)",
            1,
            given_generic.len(),
        )
        .into());
    }
    if given_args.len() != 1 {
        return Err(CompilerError::CompilerFunctionArgumentCountMissmatch(
            "bitcast<T>(value)",
            1,
            given_args.len(),
        )
        .into());
    }
    let source_val = compiler.compile_rvalue(&given_args[0], Expected::Anything)?;
    let source_type = source_val.try_get_type()?;
    let target_type = CompilerType::into_path(
        &given_generic[0],
        compiler.ctx.symbols,
        compiler.ctx.current_function_path(),
    )?;

    if !source_type.is_bitcast_compatible(&target_type, compiler.ctx.symbols) {
        return Err(CompilerError::Generic(format!(
            "bitcast size mismatch: cannot cast from {:?} to {:?}",
            source_type, target_type
        ))
        .into());
    }
    if source_type.is_pointer() ^ target_type.is_pointer() {
        let (from_t, from_v) = (
            source_type.llvm_representation(compiler.ctx.symbols)?,
            source_val.get_llvm_rep().to_string(),
        );
        let to_str = target_type.llvm_representation(compiler.ctx.symbols)?;
        if source_type.is_pointer() {
            let utvc = compiler.emit_cast("ptrtoint", &from_t, &from_v, &to_str);
            return Ok(CompiledValue::Value {
                llvm_repr: LLVMVal::Register(utvc),
                ptype: target_type,
            });
        } else {
            if from_v.parse::<i128>().map(|x| x == 0).unwrap_or(false) {
                return Ok(CompiledValue::Value {
                    llvm_repr: LLVMVal::Null,
                    ptype: target_type.clone(),
                });
            }
            let utvc = compiler.emit_cast("inttoptr", &from_t, &from_v, &to_str);
            return Ok(CompiledValue::Value {
                llvm_repr: LLVMVal::Register(utvc),
                ptype: target_type,
            });
        }
    }
    if source_type.is_integer() ^ target_type.is_integer()
        && source_type.is_decimal() ^ target_type.is_decimal()
    {
        if source_type.is_decimal() {
            // decimal to int
            if let CompiledValue::Value {
                llvm_repr: LLVMVal::ConstantDecimal(x),
                ptype: _,
            } = source_val
            {
                return Ok(CompiledValue::Value {
                    llvm_repr: LLVMVal::ConstantInteger(f64::to_bits(x).cast_signed() as i128),
                    ptype: target_type,
                });
            }
        } else {
            // int to decimal
            if let CompiledValue::Value {
                llvm_repr: LLVMVal::ConstantInteger(x),
                ptype: _,
            } = source_val
            {
                return Ok(CompiledValue::Value {
                    llvm_repr: LLVMVal::ConstantDecimal(f64::from_bits(i64::cast_unsigned(
                        x as i64,
                    ))),
                    ptype: target_type,
                });
            }
        }
    }
    let src_llvm_type = source_type.llvm_representation(compiler.ctx.symbols)?;
    let dst_llvm_type = target_type.llvm_representation(compiler.ctx.symbols)?;
    let utvc = compiler.emit_cast(
        "bitcast",
        &src_llvm_type,
        &source_val.get_llvm_rep().to_string(),
        &dst_llvm_type,
    );

    Ok(CompiledValue::Value {
        llvm_repr: LLVMVal::Register(utvc),
        ptype: target_type,
    })
}
// Usage: asm("add rax, rbx", [["rax", foo]], [["rax", foo], ["rbx", bar]], ["flags"]);
// Instruction: "add rax, rbx" RAX = RAX + RBX
// Output: [["rax", foo]]
// Input: [["rax", foo], ["rbx", bar]]
// Clobbers: ["flags"]
fn asm_impl(
    compiler: &mut ExpressionCompiler,
    given_args: &[Expr],
    _expected: &Expected,
) -> CompileResult<CompiledValue> {
    if given_args.len() != 4 {
        return Err(CompilerError::Generic(format!(
            "asm_impl(variable) expects exactly 4 arguments, but got {}",
            given_args.len()
        ))
        .into());
    }
    if *_expected != Expected::NoReturn {
        return Err(CompilerError::Generic(
            "asm() blocks currently do not support returning values directly. Use output operands."
                .into(),
        )
        .into());
    }
    let asm_template_str = match &given_args[0] {
        Expr::StringConst(s) => s.clone(),
        _ => {
            return Err(CompilerError::Generic(
                "asm() arg 1 (code) must be a string literal.".to_string(),
            )
            .into())
        }
    };
    let mut parse_operands =
        |arg_index: usize, is_output: bool| -> CompileResult<Vec<(String, String, String)>> {
            let arg_expr = &given_args[arg_index];
            match arg_expr {
                Expr::Array(arr) => {
                    let mut results: Vec<(String, String, String)> = Vec::new();
                    for (i, expr) in arr.iter().enumerate() {
                        if let Expr::Array(inner) = expr {
                            if inner.len() != 2 {
                                return Err(CompilerError::Generic(format!(
                                    "asm() arg {} index {} must be a pair ['constraint', variable]",
                                    arg_index + 1,
                                    i
                                ))
                                .into());
                            }

                            let constraint = match &inner[0] {
                                Expr::StringConst(s) => s.clone(),
                                _ => {
                                    return Err(CompilerError::Generic(
                                        "Operand constraint must be a string".into(),
                                    )
                                    .into())
                                }
                            };

                            let (llvm_value, llvm_type) = if let Expr::Name(name) = &inner[1] {
                                if is_output {
                                    let lvalue = compiler.compile_name_lvalue(name, true, true)?;
                                    (
                                        lvalue.get_llvm_rep().to_string(),
                                        lvalue
                                            .get_type()
                                            .llvm_representation(compiler.ctx.symbols)?,
                                    )
                                } else {
                                    let rvalue =
                                        compiler.compile_name_rvalue(name, Expected::Anything)?;
                                    (
                                        rvalue.get_llvm_rep().to_string(),
                                        rvalue
                                            .try_get_type()?
                                            .llvm_representation(compiler.ctx.symbols)?,
                                    )
                                }
                            } else {
                                return Err(CompilerError::Generic(
                                    "Operand variable must be a name".into(),
                                )
                                .into());
                            };

                            results.push((constraint, llvm_value, llvm_type));
                        } else {
                            return Err(CompilerError::Generic(format!(
                                "asm() arg {} must be an array of arrays",
                                arg_index + 1
                            ))
                            .into());
                        }
                    }
                    Ok(results)
                }
                _ => Err(CompilerError::Generic(format!(
                    "asm() arg {} must be an array",
                    arg_index + 1
                ))
                .into()),
            }
        };
    let outputs = parse_operands(1, true)?;
    let inputs = parse_operands(2, false)?;
    let inp = inputs
        .iter()
        .map(|x| format!("{{{}}}", x.0))
        .collect::<Vec<_>>()
        .join(",");
    let flags = match &given_args[3] {
        Expr::Array(args) => args
            .iter()
            .map(|arg| match arg {
                Expr::StringConst(s) => Ok(format!("~{{{}}}", s)),
                _ => Err(CompilerError::Generic(
                    "asm() arg 1 (code) must be a string literal.".to_string(),
                )
                .into()),
            })
            .collect::<CompileResult<Vec<String>>>()?,
        _ => panic!("Unexpected arg"),
    }
    .join(",");
    if let Some((register, var_pointer, var_type)) = outputs.first() {
        assert!(outputs.len() == 1);
        println!("{:?}", var_pointer);
        let utvc = compiler.ctx.aquire_unique_temp_value_counter();
        compiler.output.push_str(&format!(
            "    %asm{utvc} = call {} asm sideeffect inteldialect \"{}\", \"{}\"({})\n",
            var_type,
            asm_template_str,
            format!(
                "={{{register}}},{}",
                if !inp.is_empty() {
                    format!("{},{}", inp, flags)
                } else {
                    flags
                }
            ),
            inputs
                .iter()
                .map(|x| format!("{} {}", x.2, x.1))
                .collect::<Vec<_>>()
                .join(", ")
        ));
        /*
        compiler.emit_store(
            &LLVMVal::VariableName(format!("asm{}", utvc)),
            var_pointer,
            var_type,
        );*/

        compiler.output.push_str(&format!(
            "    store {} {}, {}* {}\n",
            var_type,
            format!("%asm{utvc}"),
            var_type,
            var_pointer
        ));
    } else {
        compiler.output.push_str(&format!(
            "    call {} asm sideeffect inteldialect \"{}\", \"{}\"({})\n",
            "void",
            asm_template_str,
            if !inp.is_empty() {
                format!("{},{}", inp, flags)
            } else {
                flags
            },
            inputs
                .iter()
                .map(|x| format!("{} {}", x.2, x.1))
                .collect::<Vec<_>>()
                .join(", ")
        ));
    }
    Ok(CompiledValue::NoReturn)
}
