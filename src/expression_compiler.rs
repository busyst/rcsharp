use std::collections::HashMap;

use rcsharp_parser::{compiler_primitives::{BOOL_TYPE, BYTE_TYPE, CHAR_TYPE, DEFAULT_DECIMAL_TYPE, DEFAULT_INTEGER_TYPE}, expression_parser::{BinaryOp, Expr, UnaryOp}, parser::{ParserType, Span, Stmt, StmtData}};
use crate::{compiler::{CompileResult, CompilerError, INTERGER_EXPRESION_OPTIMISATION, LLVMOutputHandler}, compiler_essentials::{CodeGenContext, CompilerType, LLVMVal, Variable}};

type CompilerFn = fn(&mut ExpressionCompiler, &[Expr], &Expected) -> CompileResult<CompiledValue>;
type GenericCompilerFn = fn(&mut ExpressionCompiler, &[Expr], &[ParserType], &Expected) -> CompileResult<CompiledValue>;
const COMPILER_FUNCTIONS: &[(&'static str, Option<CompilerFn>, Option<GenericCompilerFn>)] = &[
    ("stalloc", Some(stalloc_impl), Some(stalloc_generic_impl)),
    ("sizeof", Some(sizeof_impl), Some(sizeof_generic_impl)),
    ("alignof", Some(alignof_impl), Some(alignof_generic_impl)),
    ("ptr_of", Some(ptr_of_impl), None),
    ("bitcast", None, Some(bitcast_generic_impl)),
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
    pub fn is_literally_number(&self) -> bool {
        if let CompiledValue::Value { llvm_repr: LLVMVal::ConstantInteger(_), ..} = self {
            return true;
        }
        false
    }
}
pub struct ExpressionCompiler<'a, 'b> {
    ctx: &'a mut CodeGenContext<'b>,
    output: &'a mut LLVMOutputHandler,
}
impl<'a> Expected<'a> {
    pub fn get_type(&self) -> Option<&'a CompilerType>{
        match self {
            Self::Type(x) => Some(x),
            _ => None
        }
    }
}
impl CompiledValue {
    pub fn get_type(&self) -> &CompilerType {
        match self {
            Self::Value { ptype, .. } => ptype,
            Self::Pointer { ptype, .. } => ptype,
            Self::Function { .. } => panic!("Why"),
            Self::GenericFunction { .. } => panic!("Why Generic"),
            Self::GenericFunctionImplementation { .. } => panic!("Why Generic Implementation"),
            Self::NoReturn => panic!("Cannot get type of NoReturn value"),
        }
    }
    pub fn get_llvm_rep(&self) -> &LLVMVal{
        match self {
            Self::Value { llvm_repr, ..} => llvm_repr,
            Self::Pointer { llvm_repr, ..} => llvm_repr,
            _ => panic!("{:?}", self)
        }
    }
}
impl<'a, 'b> ExpressionCompiler<'a, 'b> {
    fn new(ctx: &'a mut CodeGenContext<'b>, output: &'a mut LLVMOutputHandler) -> Self {
        Self { ctx, output }
    }
    fn compile_rvalue(&mut self, expr: &Expr, expected: Expected) -> CompileResult<CompiledValue>{
        match expr {
            Expr::Name(name) => self.compile_name_rvalue(name, expected),
            Expr::NameWithGenerics(name, generics) => self.compile_name_with_generics_rvalue(name, generics, expected),
            Expr::Integer(num_str) => self.compile_integer_literal(num_str, expected),
            Expr::Decimal(num_str) => self.compile_decimal_literal(num_str, expected),
            Expr::Assign(lhs, rhs) => self.compile_assignment(lhs, rhs, expected),
            Expr::Call(callee, args) => self.compile_call(callee, args, expected),
            Expr::CallGeneric(callee, args, generic) => self.compile_call_generic(callee, args, generic, expected),
            Expr::MemberAccess(..) => self.compile_member_access_rvalue(expr),
            Expr::Cast(expr, target_type) => self.compile_cast(expr, target_type, expected),
            Expr::BinaryOp(l, op, r) => self.compile_binary_op(l, op, r, expected),
            Expr::UnaryOp(op, operand) => self.compile_unary_op_rvalue(op, operand, expected),
            Expr::StaticAccess(obj, member) => self.compile_static_access_rvalue(obj, member, expected),
            Expr::StringConst(str_val) => self.compile_string_literal(str_val),
            Expr::Index(..) => self.compile_index_rvalue(expr),
            Expr::Boolean(value) => self.compile_boolean(*value),
            Expr::NullPtr => self.compile_null(expected),
            Expr::Type(..) => unreachable!(),
        }
    }
    // RVAL
    fn compile_name_rvalue(&mut self, name: &str, _expected: Expected) -> CompileResult<CompiledValue> {
        if let Some((variable, id)) = self.ctx.scope.get_variable(name) {
            let mut vtype = variable.get_type(false, false).clone();
            vtype.substitute_generic_types(&self.ctx.symbols.alias_types, &self.ctx.symbols)?;
            let llvm_repr = variable.get_llvm_value(*id, name, self.ctx, self.output)?;
            return Ok(CompiledValue::Value { llvm_repr, ptype: vtype });
        }
        
        if let Some(function) = self.ctx.symbols.get_function_id(&format!("{}.{}", name, self.ctx.current_function_path())).or(self.ctx.symbols.get_function_id(name)) {
            return Ok(
                if self.ctx.symbols.get_function_by_id(function).is_generic() {
                    CompiledValue::GenericFunction { internal_id: function }
                } else {
                    CompiledValue::Function { internal_id: function }
                }
            );
        }
        Err((Span::empty(), CompilerError::SymbolNotFound(format!("RVAL:Symbol '{}' not found in '{}'", name, self.ctx.current_function))))
    }
    fn compile_integer_literal(&mut self, num_str: &str, expected: Expected) -> CompileResult<CompiledValue> {
        if let Expected::Type(ptype) = expected {
            if let CompilerType::Primitive(p) = ptype {
                if p.is_integer() {
                    return Ok(CompiledValue::Value { llvm_repr: LLVMVal::ConstantInteger(num_str.to_string()), ptype: ptype.clone() });
                }
                if p.is_bool() {
                    let llvm_repr = if num_str != "0" { "1" } else { "0" }.to_string();
                    return Ok(CompiledValue::Value { llvm_repr: LLVMVal::ConstantInteger(llvm_repr.to_string()), ptype: ptype.clone() });
                }
            }
            if ptype.is_pointer() && num_str == "0" {
                return Ok(CompiledValue::Value { llvm_repr: LLVMVal::Null, ptype: ptype.clone() });
            }

        }
        Ok(CompiledValue::Value { llvm_repr: LLVMVal::ConstantInteger(num_str.to_string()), ptype: CompilerType::Primitive(DEFAULT_INTEGER_TYPE) })
    }
    #[allow(unused_variables)]
    fn compile_name_with_generics_rvalue(&mut self, name: &Box<Expr>, generics: &[ParserType], expected: Expected<'_>) -> CompileResult<CompiledValue> {
        todo!()
    }
    fn compile_binary_op(&mut self, lhs: &Expr, op: &BinaryOp, rhs: &Expr, expected: Expected<'_>) -> CompileResult<CompiledValue> {
        debug_assert!(expected != Expected::NoReturn);
        if INTERGER_EXPRESION_OPTIMISATION {
            if let Ok(llvm_repr) = constant_expression_compiler(&Expr::BinaryOp(Box::new(lhs.clone()), *op, Box::new(rhs.clone()))) {
                if let Some(ptype) = expected.get_type().cloned() {
                    return Ok(CompiledValue::Value { llvm_repr, ptype });
                }
                return Ok(CompiledValue::Value { llvm_repr, ptype: CompilerType::Primitive(DEFAULT_INTEGER_TYPE) });
            } 
              
        }
        let mut left = self.compile_rvalue(lhs, Expected::Anything)?;
        debug_assert!(left != CompiledValue::NoReturn);
        let mut right = self.compile_rvalue(rhs, Expected::Type(left.get_type()))?;
        debug_assert!(right != CompiledValue::NoReturn);

        // Swap them
        // 10 + x == x + 10
        if left.is_literally_number() && !right.is_literally_number() 
            && (matches!(op, BinaryOp::Add | BinaryOp::Multiply | BinaryOp::BitAnd | BinaryOp::BitOr | BinaryOp::BitXor | BinaryOp::And | BinaryOp::Or | BinaryOp::Equals)) 
            {
            (right, left) = (left, right);
        }
        // Pointer math
        if left.get_type().is_pointer() && right.get_type().is_integer() {  // *(array_pointer + iterator)
            assert!(matches!(op, BinaryOp::Add));
            let utvc = self.ctx.aquire_unique_temp_value_counter();
            let llvm_pointed_to_type = left.get_type().dereference().unwrap().llvm_representation(self.ctx.symbols)?;
            let left_ll = (left.get_type().llvm_representation(self.ctx.symbols)?, left.get_llvm_rep().to_string());
            let right_ll = (right.get_type().llvm_representation(self.ctx.symbols)?, right.get_llvm_rep().to_string());
            self.output.push_str(&format!("    %tmp{} = getelementptr {}, {} {}, {} {}\n", utvc, llvm_pointed_to_type, left_ll.0, left_ll.1, right_ll.0, right_ll.1));
            return Ok(CompiledValue::Value{llvm_repr: LLVMVal::Register(utvc), ptype: left.get_type().clone()});
        }
        if left.get_type() != right.get_type() {
            println!("{:?}", left);
            println!("{:?}", right);
            return Err((Span::empty(), CompilerError::Generic(format!("Binary operator '{:?}' cannot be applied to mismatched types '{:?}' and '{:?}'", op, left.get_type(), right.get_type()))));
        }
        
        let ltype = left.get_type();
        // Boolean math
        if ltype.is_bool() {
            let llvm_op = match op {
                BinaryOp::And => "and",
                BinaryOp::Or => "or",
                _ => todo!("{:?}", op)
            };
            let utvc = self.ctx.aquire_unique_temp_value_counter();
            self.output.push_str(&format!("    %tmp{} = {} {} {}, {}\n", utvc, llvm_op, BOOL_TYPE.llvm_name, left.get_llvm_rep(), right.get_llvm_rep()));
            return Ok(CompiledValue::Value { llvm_repr: LLVMVal::Register(utvc), ptype: CompilerType::Primitive(BOOL_TYPE) });
        }
        // Integer Arithmetic
        if ltype.is_integer() {
            let is_signed = ltype.is_signed_integer();

            let llvm_op = match op {
                BinaryOp::Add => "add",
                BinaryOp::Subtract => "sub",
                BinaryOp::Multiply => "mul",
                BinaryOp::Divide => if is_signed { "sdiv" } else { "udiv" },
                BinaryOp::Modulo => if is_signed { "srem" } else { "urem" },

                BinaryOp::Equals => "icmp eq",
                BinaryOp::NotEqual => "icmp ne",
                BinaryOp::Less => if is_signed { "icmp slt" } else { "icmp ult" },

                BinaryOp::LessEqual => if is_signed { "icmp sle" } else { "icmp ule" },
                BinaryOp::Greater => if is_signed { "icmp sgt" } else { "icmp ugt" },
                BinaryOp::GreaterEqual => if is_signed { "icmp sge" } else { "icmp uge" },

                BinaryOp::BitAnd => "and",
                BinaryOp::BitOr => "or",
                BinaryOp::BitXor => "xor",

                BinaryOp::ShiftLeft => "shl",
                BinaryOp::ShiftRight => if is_signed { "ashr" } else { "lshr" },

                BinaryOp::And => "and",
                BinaryOp::Or => "or",
            };

            let both_types_llvm_repr = ltype.llvm_representation(self.ctx.symbols)?;
            let utvc = self.ctx.aquire_unique_temp_value_counter();
            self.output.push_str(&format!("    %tmp{} = {} {} {}, {}\n",utvc, llvm_op, both_types_llvm_repr, left.get_llvm_rep(), right.get_llvm_rep()));

            let result_type = if llvm_op.starts_with("icmp") {
                CompilerType::Primitive(BOOL_TYPE)
            } else {
                left.get_type().clone()
            };

            return Ok(CompiledValue::Value { llvm_repr: LLVMVal::Register(utvc), ptype: result_type });
        }
        if ltype.is_decimal() {
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

                _ => todo!("unsupported binary operator for float"),
            };
            let both_types_llvm_repr = ltype.llvm_representation(self.ctx.symbols)?;
            let utvc = self.ctx.aquire_unique_temp_value_counter();
            self.output.push_str(&format!("    %tmp{} = {} {} {}, {}\n",utvc, llvm_op, both_types_llvm_repr, left.get_llvm_rep(), right.get_llvm_rep()));
            let result_type = if llvm_op.starts_with("fcmp") {
                CompilerType::Primitive(BOOL_TYPE)
            } else {
                left.get_type().clone()
            };
            return Ok(CompiledValue::Value { llvm_repr: LLVMVal::Register(utvc), ptype: result_type });
        }
        if ltype.is_pointer() {
            let llvm_op = match op {
                BinaryOp::Equals => "icmp eq",
                BinaryOp::NotEqual => "icmp ne",
                _ => panic!("Operation \"{:?}\" is not permited on pointers", op)
            };
            let utvc = self.ctx.aquire_unique_temp_value_counter();
            self.output.push_str(&format!("    %tmp{} = {} ptr {}, {}\n",utvc, llvm_op, left.get_llvm_rep(), right.get_llvm_rep()));
            return Ok(CompiledValue::Value { llvm_repr: LLVMVal::Register(utvc), ptype: CompilerType::Primitive(BOOL_TYPE) });
        }
        
        Err((Span::empty(), CompilerError::Generic(format!("Binary operator \"{:?}\" was not implemted for types \"{:?}\"", op, left))))
    }
    fn compile_decimal_literal(&mut self, num_str: &str, expected: Expected) -> CompileResult<CompiledValue> {
        if let Some(x) = expected.get_type().filter(|x| x.is_decimal()) {
            return self.explicit_cast(&CompiledValue::Value { llvm_repr: LLVMVal::ConstantDecimal(num_str.to_string()), ptype: x.clone() }, x);
        };

        Ok(CompiledValue::Value { llvm_repr: LLVMVal::ConstantDecimal(num_str.to_string()), ptype: CompilerType::Primitive(DEFAULT_DECIMAL_TYPE) })
    }
    fn compile_assignment(&mut self, lhs: &Expr, rhs: &Expr, expected: Expected) -> CompileResult<CompiledValue> {
        let left_ptr = self.compile_lvalue(lhs, true, true)?;
        assert_ne!(left_ptr, CompiledValue::NoReturn);
        if !matches!(left_ptr, CompiledValue::Pointer { .. }) {
            return Err((Span::empty(), CompilerError::InvalidExpression(format!("{:?} does not yield a valid lvalue", lhs))));
        }
        let right_val = self.compile_rvalue(rhs, Expected::Type(left_ptr.get_type()))?;
        assert_ne!(right_val, CompiledValue::NoReturn);
        if left_ptr.get_type() != right_val.get_type() {
            println!("LEFT TYPE: {:?}", left_ptr.get_type());
            println!("RIGHT TYPE: {:?}", right_val.get_type());
            return Err((Span::empty(), CompilerError::InvalidExpression(format!("Type mismatch in assignment: {:?} and {:?}", left_ptr.get_type(), right_val.get_type()))));
        }
        let left_str = left_ptr.get_llvm_rep();
        let right_str = right_val.get_llvm_rep();
        let t = left_ptr.get_type().llvm_representation(self.ctx.symbols)?;
        self.output.push_str(&format!("    store {} {}, {}* {}\n", t, right_str, t, left_str));

        if matches!(expected, Expected::NoReturn) {
            Ok(CompiledValue::NoReturn)
        } else {
            Ok(right_val)
        }
    }
    fn compile_call(&mut self, callee: &Expr, given_args: &[Expr], expected: Expected<'_>) -> CompileResult<CompiledValue> {
        if let Some(x) = self.compiler_function_calls(callee, given_args, &expected) {
            return x;
        }
        let x = self.compile_lvalue(callee, false, false)?;
        let (required_arguments, return_type, llvm_call_site) = if let CompiledValue::Function { internal_id} = x {
            let func = self.ctx.symbols.get_function_by_id(internal_id);
            if func.is_inline() {
                return self.compile_call_inline(given_args, &func.args, &func.return_type, &func.body, internal_id);
            }
            (func.args.iter().map(|x| x.1.clone()).collect::<Box<_>>(),
            func.return_type.clone(),
            if !func.is_imported(){format!("@{}", func.full_path())} else { LLVMVal::Global(func.name().to_string()).to_string() })
        }else if let CompiledValue::Pointer { llvm_repr, ptype: CompilerType::Function(func_return_type, func_args)} = x {
            (func_args, *func_return_type, llvm_repr.to_string())
        }else {
            panic!();
        };
        let mut arg_string = vec![];
        for (i, ..) in required_arguments.iter().enumerate() {
            let x = self.compile_rvalue(&given_args[i], Expected::Type(&required_arguments[i]))?;
            if *x.get_type() != required_arguments[i] {
                return CompileResult::Err((Span::empty(), CompilerError::InvalidExpression(format!("{:?} vs {:?} type missmatch with {}th argument", x.get_type(), &required_arguments[i], i + 1))));
            }
            arg_string.push(format!("{} {}", x.get_type().llvm_representation(self.ctx.symbols)?, x.get_llvm_rep()));
        }
        let arg_string = arg_string.join(", ");
        let return_type_repr = return_type.llvm_representation(self.ctx.symbols)?;
        if return_type.is_void() {
            self.output.push_str(&format!("    call void {}({})\n", llvm_call_site, arg_string));
            return Ok(CompiledValue::NoReturn);
        }
        if expected != Expected::NoReturn {
            let utvc = self.ctx.aquire_unique_temp_value_counter();
            self.output.push_str(&format!("    %tmp{} = call {} {}({})\n", utvc, return_type_repr, llvm_call_site, arg_string));
            return Ok(CompiledValue::Value { llvm_repr: LLVMVal::Register(utvc), ptype: return_type.clone() });
        }
        self.output.push_str(&format!("    call {} {}({})\n", return_type_repr, llvm_call_site, arg_string));
        return Ok(CompiledValue::NoReturn);
    }
    
    fn compile_call_inline(&mut self, given_args: &[Expr], func_args: &[(String, CompilerType)], func_return_type: &CompilerType, body: &[StmtData], current_function_id: usize) -> CompileResult<CompiledValue> {
        if body.is_empty() {
            if func_return_type.is_void() {
                return Ok(CompiledValue::NoReturn);
            }
            return Err((Span::empty(), CompilerError::Generic(format!("Inline function body was empty but return type is not void"))));
        }
        let inline_exit = self.ctx.aquire_unique_logic_counter();
        let return_tmp = if !func_return_type.is_void() {
            let return_utvc = self.ctx.aquire_unique_temp_value_counter();
            let return_llvm = func_return_type.llvm_representation(self.ctx.symbols)?;
            self.output.push_str(&format!("    %iv{} = alloca {}\n", return_utvc, return_llvm));
            Some((return_utvc, return_llvm))
        }else {
            None
        };
        let mut prepared_args = vec![];
        for (idx, expr) in given_args.iter().enumerate() {
            let x = self.compile_rvalue(expr, Expected::Type(&func_args[idx].1))?;
            if x.get_type() != &func_args[idx].1 {
                return Err((Span::empty(), CompilerError::InvalidExpression(format!("{:?} vs {:?} type missmatch with {}th argument", x.get_type(), &func_args[idx].1, idx + 1))));
            }
            prepared_args.push(x);
        }

        let lp = self.ctx.current_function;
        let og_scope = self.ctx.scope.clone();
        
        self.ctx.scope.clear();
        self.ctx.current_function = current_function_id;

        for (idx, arg) in prepared_args.iter().enumerate() {
            let var = Variable::new(arg.get_type().clone(), false);
            var.set_value(Some(arg.get_llvm_rep().clone()));
            self.ctx.scope.add_variable(func_args[idx].0.clone(), var, 0);
        }
        for (idx, x) in body.iter().enumerate() {
            match &x.stmt {
                Stmt::Let(name, var_type, expr) =>{
                    let x = self.ctx.aquire_unique_variable_index() + u32::MAX / 2; // Hack
                    let var_type = CompilerType::into_path(var_type, self.ctx.symbols, self.ctx.current_function_path())?;
                    let var = Variable::new(var_type.clone(), false);

                    let llvm_type = var_type.llvm_representation(self.ctx.symbols)?;
                    self.ctx.scope.add_variable(name.clone(), Variable::new(var_type.clone(), false), x); 
                    self.output.push_str(&format!("    %v{} = alloca {}; var: {}\n", x, llvm_type, name));

                    if let Some(init_expr) = expr {
                        let result = compile_expression(init_expr, Expected::Type(&var_type), self.ctx, self.output)?;
                        if &var_type != result.get_type() {
                            return Err((Span::empty(), CompilerError::InvalidExpression(format!("Type mismatch in assignment: {:?} and {:?}", var_type, result))));
                        }
                        self.ctx.scope.add_variable(name.clone(), var, x);
                        self.output.push_str(&format!("    store {} {}, {}* {}\n", llvm_type, result.get_llvm_rep(), llvm_type, LLVMVal::Variable(x)));
                    }else {
                        self.ctx.scope.add_variable(name.clone(), var, x);
                    }
                }
                Stmt::Return(opt_expr) =>{
                    let return_type = func_return_type;
                    if opt_expr.is_some() && return_type.is_void() {
                        return Err((Span::empty(), CompilerError::Generic(format!("This inline function does not return anything"))));
                    }
                    if let Some(expr) = opt_expr {
                        let return_tmp = return_tmp.as_ref().unwrap();
                        let value = compile_expression(expr, Expected::Type(&return_type), self.ctx, self.output)?;
                        if value.get_type() != return_type {
                            return Err((Span::empty(), CompilerError::TypeMismatch { expected: return_type.clone(), found: value.get_type().clone() }));
                        }
                        let llvm_type_str = &return_tmp.1;
                        self.output.push_str(&format!("    store {} {}, {}* %iv{}\n", llvm_type_str, value.get_llvm_rep(), llvm_type_str, return_tmp.0));
                    } else {
                        if !return_type.is_void() {
                            return Err((Span::empty(), CompilerError::Generic("Cannot return without a value from a non-void function.".to_string())));
                        }
                    }
                    if idx == body.len() - 1 {
                        break;
                    }
                    self.output.push_str(&format!("    br label %inline_exit{}\n",inline_exit));
                }
                _ => crate::compiler::compile_statement(&x, self.ctx, self.output)?,
            }
        }
        self.output.push_str(&format!("    br label %inline_exit{}\n",inline_exit));
        self.output.push_str(&format!("inline_exit{}:\n", inline_exit));

        self.ctx.scope = og_scope;
        self.ctx.current_function = lp;
        if let Some((id, var_llvm_type)) = return_tmp {
            let rv_utvc = self.ctx.aquire_unique_temp_value_counter();
            self.output.push_str(&format!("    %tmp{} = load {}, {}* %iv{}\n", rv_utvc, var_llvm_type, var_llvm_type, id));
            return Ok(CompiledValue::Value { llvm_repr: LLVMVal::Register(rv_utvc), ptype: func_return_type.clone() });
        }
        return Ok(CompiledValue::NoReturn);
    }
    fn compile_call_generic(&mut self, callee: &Expr, given_args: &[Expr], given_generic: &[ParserType], expected: Expected<'_>) -> CompileResult<CompiledValue> {
        if let Some(x) = self.compiler_function_calls_generic(callee, given_args, given_generic, &expected) {
            return x;
        }
        let x = self.compile_lvalue(callee, false, false)?;
        let (required_arguments, return_type, llvm_call_site) = if let CompiledValue::GenericFunction { internal_id} = x {
            let function = self.ctx.symbols.get_function_by_id(internal_id);
            let mut type_map = HashMap::new();
            for (ind, prm) in function.generic_params.iter().enumerate() {
                let mut x = CompilerType::into(&given_generic[ind], self.ctx)?;
                x.substitute_generic_types(&self.ctx.symbols.alias_types, self.ctx.symbols)?;
                type_map.insert(prm.clone(), x);
            }
            if function.is_inline() {
                todo!("{:?}", function)
            }
            let mut x= function.return_type.clone();
            x.substitute_generic_types(&type_map, self.ctx.symbols)?;
            let mut subst_generics = given_generic.iter().map(|x| CompilerType::into(x, self.ctx)).collect::<CompileResult<Box<_>>>()?;
            for x in subst_generics.iter_mut() {
                x.substitute_generic_types(&type_map, self.ctx.symbols)?;
            }
            let impl_index = function.get_implementation_index(&subst_generics).expect("msg");
            let call_site = format!("@{}", function.call_path_impl_index(impl_index, self.ctx.symbols));
            (function.args.iter().map(|x| x.1.with_substituted_generic_types(&type_map, self.ctx.symbols)).collect::<CompileResult<Box<_>>>()?,
            function.return_type.with_substituted_generic_types(&type_map, self.ctx.symbols)?,
            call_site)
        }else {
            todo!()
        };

        let mut arg_string = vec![];
        for (i, ..) in required_arguments.iter().enumerate() {
            let x = self.compile_rvalue(&given_args[i], Expected::Type(&required_arguments[i]))?;
            if *x.get_type() != required_arguments[i] {
                return CompileResult::Err((Span::empty(), CompilerError::InvalidExpression(format!("{:?} vs {:?} type missmatch with {}th argument", x.get_type(), &required_arguments[i], i + 1))));
            }
            arg_string.push(format!("{} {}", x.get_type().llvm_representation(self.ctx.symbols)?, x.get_llvm_rep()));
        }
        let arg_string = arg_string.join(", ");
        let return_type_repr = return_type.llvm_representation(self.ctx.symbols)?;
        if return_type.is_void() {
            self.output.push_str(&format!("    call void {}({})\n", llvm_call_site, arg_string));
            return Ok(CompiledValue::NoReturn);
        }
        if expected != Expected::NoReturn {
            let utvc = self.ctx.aquire_unique_temp_value_counter();
            self.output.push_str(&format!("    %tmp{} = call {} {}({})\n", utvc, return_type_repr, llvm_call_site, arg_string));
            return Ok(CompiledValue::Value { llvm_repr: LLVMVal::Register(utvc), ptype: return_type.clone() });
        }
        self.output.push_str(&format!("    call {} {}({})\n", return_type_repr, llvm_call_site, arg_string));
        return Ok(CompiledValue::NoReturn);
    }
    
    fn compile_unary_op_rvalue(&mut self, op: &UnaryOp, operand_expr: &Expr, expected: Expected) -> CompileResult<CompiledValue> {
        match op {
            UnaryOp::Deref => {
                let value = self.compile_rvalue(operand_expr, expected)?;
                if !value.get_type().is_pointer() {
                    return Err((Span::empty(), CompilerError::Generic(format!("Cannot dereference non-pointer value {:?}", value))));
                }
                let pointed_to_type = value.get_type().dereference().unwrap();
                let type_str = pointed_to_type.llvm_representation(self.ctx.symbols)?;
                let temp_id = self.ctx.aquire_unique_temp_value_counter();
                self.output.push_str(&format!("    %tmp{} = load {}, {}* {}\n", temp_id, type_str, type_str, value.get_llvm_rep()));
                Ok(CompiledValue::Value { llvm_repr: LLVMVal::Register(temp_id), ptype: pointed_to_type.clone() })
            }
            UnaryOp::Pointer => { // lvalue.get_llvm_repr()
                let lvalue = self.compile_lvalue(operand_expr, false, false)?;
                if let CompiledValue::Function { internal_id} = &lvalue {
                    let func = self.ctx.symbols.get_function_by_id(*internal_id);
                    return Ok(CompiledValue::Value { llvm_repr: LLVMVal::Global(func.full_path().to_string()), ptype: func.get_type().reference() });
                }
                let ptype = lvalue.get_type().clone().reference();
                Ok(CompiledValue::Value { llvm_repr: lvalue.get_llvm_rep().clone(), ptype })
            }
            UnaryOp::Negate => {
                let value = self.compile_rvalue(operand_expr, expected)?;
                if !value.get_type().is_integer() && !value.get_type().is_decimal() {
                    return Err((Span::empty(), CompilerError::Generic("Cannot negate non-integer type".to_string())));
                }
                if value.is_literally_number() {
                    if let LLVMVal::ConstantInteger(cnst) = value.get_llvm_rep() {
                        let num = -cnst.parse::<i128>().unwrap();
                        return Ok(CompiledValue::Value { llvm_repr: LLVMVal::ConstantInteger(num.to_string()), ptype: value.get_type().clone() });
                    }
                    todo!()
                }
                let type_str = value.get_type().llvm_representation(self.ctx.symbols)?;
                let temp_id = self.ctx.aquire_unique_temp_value_counter();
                if value.get_type().is_decimal() {
                    self.output.push_str(&format!("    %tmp{} = fsub {} 0.0, {}\n", temp_id, type_str, value.get_llvm_rep()));
                }else{
                    self.output.push_str(&format!("    %tmp{} = sub {} 0, {}\n", temp_id, type_str, value.get_llvm_rep()));
                }
                
                Ok(CompiledValue::Value { llvm_repr: LLVMVal::Register(temp_id), ptype: value.get_type().clone() })
            }
            UnaryOp::Not => {
                let value = self.compile_rvalue(operand_expr, Expected::Type(&CompilerType::Primitive(BOOL_TYPE)))?;
                if !value.get_type().is_bool() {
                    return Err((Span::empty(), CompilerError::InvalidExpression("Logical NOT can only be applied to booleans".to_string())));
                }
                let temp_id = self.ctx.aquire_unique_temp_value_counter();
                self.output.push_str(&format!("    %tmp{} = xor i1 {}, 1\n", temp_id, value.get_llvm_rep()));
                Ok(CompiledValue::Value { llvm_repr: LLVMVal::Register(temp_id), ptype: value.get_type().clone() })
            }
        }
    }
    fn compile_static_access_rvalue(&mut self, expr: &Expr, member: &str, expected: Expected) -> CompileResult<CompiledValue> {
        let mut path= vec![member];
        let mut cursor = expr;
        while let Expr::StaticAccess(x, y) = cursor {
            cursor = &x;
            path.push(y);
        }
        let core = if let Expr::Name(x) = expr {
            x
        }else { todo!() };
        let enum_path = if path.len() == 1 {
            core.clone()
        }else {
            format!("{}.{}", core, path.iter().skip(1).rev().map(|x| x.to_string()).collect::<Vec<_>>().join("."))
        };
        if let Some(x) = self.ctx.symbols.enums.get(&format!("{}.{}", self.ctx.current_function_path(), enum_path)).or(self.ctx.symbols.enums.get(&enum_path)) {
            let e = x.fields.iter().filter(|x| x.0 == member).nth(0).expect("msg");
            return Ok(CompiledValue::Value { llvm_repr: e.1.clone(), ptype: x.base_type.clone() });
        }

        let full_path = format!("{}.{}", core, path.iter().rev().map(|x| x.to_string()).collect::<Vec<_>>().join("."));
        
        self.compile_name_rvalue(&full_path, expected)
    }
    fn compile_member_access_rvalue(&mut self, expr: &Expr) -> CompileResult<CompiledValue> {
        let member_ptr = self.compile_lvalue(expr, false, false)?;
        let temp_id = self.ctx.aquire_unique_temp_value_counter();
        let mut ptype = member_ptr.get_type().clone();
        ptype.substitute_generic_types(&self.ctx.symbols.alias_types, self.ctx.symbols)?;
        let type_str = ptype.llvm_representation(self.ctx.symbols)?;
        self.output.push_str(&format!("    %tmp{} = load {}, {}* {}\n", temp_id, type_str, type_str, member_ptr.get_llvm_rep()));
        Ok(CompiledValue::Value { llvm_repr: LLVMVal::Register(temp_id), ptype })
    }
    fn compile_index_rvalue(&mut self, expr: &Expr) -> CompileResult<CompiledValue> {
        let ptr = self.compile_lvalue(expr, false, false)?;
        let ptype = ptr.get_type().clone();
        let type_str = ptype.llvm_representation(self.ctx.symbols)?;
        let temp_id = self.ctx.aquire_unique_temp_value_counter();
        self.output.push_str(&format!("    %tmp{} = load {}, {}* {}\n", temp_id, type_str, type_str, ptr.get_llvm_rep()));
        Ok(CompiledValue::Value { llvm_repr: LLVMVal::Register(temp_id), ptype })
    }
    fn compile_cast(&mut self, expr: &Expr, target_type: &ParserType, expected: Expected) -> CompileResult<CompiledValue> {
        let mut target_type = CompilerType::into_path(target_type, self.ctx.symbols, self.ctx.current_function_path())?;
        target_type.substitute_generic_types(&self.ctx.symbols.alias_types, self.ctx.symbols)?;
        let value = self.compile_rvalue(expr, expected)?;

        if value.get_type() == &target_type {
            return Ok(value);
        }
        
        self.explicit_cast(&value, &target_type)
    }
    fn compile_boolean(&mut self, value: bool) -> CompileResult<CompiledValue> {
        return Ok(CompiledValue::Value { llvm_repr: LLVMVal::Constant(format!("{}", value as i8)), ptype: CompilerType::Primitive(BOOL_TYPE) });
    }
    fn compile_null(&mut self, expected: Expected<'_>) -> CompileResult<CompiledValue> {
        if let Some(ptype) = expected.get_type().map(|x| x.as_pointer()).flatten() {
            return Ok(CompiledValue::Value { llvm_repr: LLVMVal::Null, ptype: CompilerType::Pointer(Box::new(ptype.clone())) });
        }
        return Err((Span::empty(), CompilerError::Generic("Wrong use of null".to_string())));
    }
    fn compile_string_literal(&mut self, str_val: &str) -> CompileResult<CompiledValue> { // ---
        let const_id = self.output.add_to_strings_header(str_val.to_string());
        return Ok(CompiledValue::Value { llvm_repr: LLVMVal::Global(format!(".str.{}", const_id)), ptype: CompilerType::Pointer(Box::new(CompilerType::Primitive(CHAR_TYPE)))});
    }
    // lval
    fn compile_lvalue(&mut self, expr: &Expr, write: bool, modify_content: bool) -> CompileResult<CompiledValue> {
        match expr {
            Expr::Name(name) => self.compile_name_lvalue(name, write, modify_content),
            Expr::NameWithGenerics(name, generics) => self.compile_name_with_generics_lvalue(name, generics, write, modify_content),
            Expr::StaticAccess(obj, member) => self.compile_static_access_lvalue(obj, member, write, modify_content),
            Expr::MemberAccess(obj, member) => self.compile_member_access_lvalue(obj, member, write, modify_content),
            Expr::UnaryOp(UnaryOp::Deref, operand) => self.compile_deref_lvalue(operand, write, modify_content),
            Expr::Index(array, index) => self.compile_index_lvalue(array, index, write, modify_content),
            //Expr::BinaryOp(..) => self.compile_rvalue(expr, Expected::Anything),
            //Expr::Type(r_type) => self.compile_type(r_type),
            _ => Err((Span::empty(), CompilerError::Generic(format!("Expression {:?} is not a valid lvalue", expr)))),
        }
    }
    fn compile_name_lvalue(&mut self, name: &str, write: bool, modify_content: bool) -> CompileResult<CompiledValue> {
        if let Some((variable, id)) = self.ctx.scope.get_variable(name) {
            let ptype = variable.get_type(write, modify_content).clone();
            if variable.is_constant() {
                panic!("Constant variable '{}' should not be accessed as an lvalue", name);
                //let x = variable.value().borrow().clone().ok_or_else(|| CompileError::InvalidExpression(format!("Constant variable '{}' has no value assigned", name)))?;
                // Allocate if not allocated yet
                //return Ok(CompiledValue::Pointer { llvm_repr: x, ptype });
            }
            let llvm_repr = if variable.is_argument() {
                if variable.is_alias_value() { LLVMVal::Register(*id) } else { LLVMVal::VariableName(name.to_string()) }
            } else {
                LLVMVal::Variable(*id)
            };
            return Ok(CompiledValue::Pointer { llvm_repr, ptype });
        }
        if let Some(function) = self.ctx.symbols.get_function_id(&format!("{}.{}", self.ctx.current_function_path(), name)).or(self.ctx.symbols.get_function_id(name)) {
            return Ok(
                if self.ctx.symbols.get_function_by_id(function).is_generic() {
                    CompiledValue::GenericFunction { internal_id: function }
                } else {
                    CompiledValue::Function { internal_id: function }
                }
            );
        }
        println!("{:?}", self.ctx.symbols.functions.iter().map(|x| x.0).cloned().collect::<Vec<_>>());
        println!("{:?}", self.ctx.current_function_path());
        Err((Span::empty(), CompilerError::SymbolNotFound(format!("Lvalue '{}' not found", name))))
    }
    fn compile_name_with_generics_lvalue(&mut self, name: &Expr, generics: &[ParserType], write: bool, modify_content: bool) -> CompileResult<CompiledValue> {
        let x = self.compile_lvalue(name, write, modify_content)?;
        if let CompiledValue::GenericFunction { internal_id } = x {
            if generics.is_empty() {
                return Err((Span::empty(), CompilerError::Generic(format!("Generic function '{}' requires generic parameters", internal_id))));
            }
            let _func = self.ctx.symbols.get_function_by_id(internal_id);
            
            return Ok(CompiledValue::GenericFunctionImplementation { internal_id, types: generics.iter().map(|x| CompilerType::into(x, self.ctx)).collect::<CompileResult<Box<_>>>()? });
        }
        Err((Span::empty(), CompilerError::Generic(format!("Lvalue with generics '{:?}' is not a generic function", name))))
    }
    fn compile_member_access_lvalue(&mut self, obj: &Expr, member: &str, write: bool, modify_content: bool) -> CompileResult<CompiledValue> {
        let obj_lvalue = self.compile_lvalue(obj, false, write || modify_content)?;
        
        let (base_ptr_repr, mut struct_type) = if obj_lvalue.get_type().is_pointer() {
            let obj_rvalue = self.compile_rvalue(obj, Expected::Anything)?;
            let internal_type = obj_rvalue.get_type().dereference().expect("Should");
            (obj_rvalue.get_llvm_rep().clone(), internal_type.clone())
        } else {
            (obj_lvalue.get_llvm_rep().clone(), obj_lvalue.get_type().clone())
        };
        struct_type.substitute_generic_types(&self.ctx.symbols.alias_types, self.ctx.symbols)?;
        match struct_type {
            CompilerType::StructType(id) => {
                let given_struct = self.ctx.symbols.get_type_by_id(id);
                let index = given_struct.fields.iter().position(|x| x.0 == member).expect("Member not found");
                let field_type = &given_struct.fields[index].1;

                let llvm_struct_type = given_struct.llvm_representation();
                let utvc = self.ctx.aquire_unique_temp_value_counter();
                let result_reg = LLVMVal::Register(utvc);
                self.output.push_str(&format!(
                    "    %tmp{} = getelementptr inbounds {}, {}* {}, i32 0, i32 {}\n",
                    utvc,
                    llvm_struct_type,
                    llvm_struct_type,
                    base_ptr_repr,
                    index,
                ));
                Ok(CompiledValue::Pointer { llvm_repr: result_reg, ptype: field_type.clone() })
            },
            CompilerType::GenericStructType(id, implementation_id) =>{
                let given_struct = self.ctx.symbols.get_type_by_id(id);
                let index = given_struct.fields.iter().position(|x| x.0 == member).expect("Member not found");
                let mut field_type = given_struct.fields[index].1.clone();
                let implementation = &given_struct.generic_implementations.borrow()[implementation_id];
                let mut type_map = HashMap::new();
                for (ind, prm) in given_struct.generic_params.iter().enumerate() {
                    type_map.insert(prm.clone(), implementation[ind].clone());
                }
                field_type.substitute_generic_types(&type_map, self.ctx.symbols)?;

                let llvm_struct_type = given_struct.llvm_repr_index(implementation_id, self.ctx.symbols);
                let utvc = self.ctx.aquire_unique_temp_value_counter();
                let result_reg = LLVMVal::Register(utvc);
                self.output.push_str(&format!(
                    "    %tmp{} = getelementptr inbounds {}, {}* {}, i32 0, i32 {}\n",
                    utvc,
                    llvm_struct_type,
                    llvm_struct_type,
                    base_ptr_repr,
                    index,
                ));
                Ok(CompiledValue::Pointer { llvm_repr: result_reg, ptype: field_type })
            }
            _ => todo!("{:?}", struct_type)
        }
    }
    fn compile_index_lvalue(&mut self, array_expr: &Expr, index_expr: &Expr, _write: bool, _modify_content: bool) -> CompileResult<CompiledValue> {
        let array_rval = self.compile_rvalue(array_expr, Expected::Anything)?; 
        if !array_rval.get_type().is_pointer() {
            return Err((Span::empty(), CompilerError::InvalidExpression(format!("Cannot index non-pointer type {:?}", array_rval.get_type()))));
        }

        let index_val = self.compile_rvalue(index_expr, Expected::Type(&CompilerType::Primitive(DEFAULT_INTEGER_TYPE)))?;
        if !index_val.get_type().is_integer() {
            return Err((Span::empty(), CompilerError::InvalidExpression(format!("Index must be an integer, but got {:?}", index_val.get_type()))));
        }

        let base_type = array_rval.get_type().dereference().expect("msg");
        let llvm_base_type = base_type.llvm_representation(self.ctx.symbols)?;
        
        let temp_id = self.ctx.aquire_unique_temp_value_counter();
        let gep_ptr_reg = LLVMVal::Register(temp_id);
        
        self.output.push_str(&format!(
            "    {} = getelementptr inbounds {}, {} {}, {} {}\n",
            gep_ptr_reg, 
            llvm_base_type,
            array_rval.get_type().llvm_representation(self.ctx.symbols)?,
            array_rval.get_llvm_rep(),
            index_val.get_type().llvm_representation(self.ctx.symbols)?,
            index_val.get_llvm_rep(),
        ));
        Ok(CompiledValue::Pointer { llvm_repr: gep_ptr_reg, ptype: base_type.clone() })
    }
    fn compile_static_access_lvalue(&mut self, expr: &Expr, member: &str, write: bool, modify_content: bool) -> CompileResult<CompiledValue> {
        let mut path= vec![member];
        let mut cursor = expr;
        while let Expr::StaticAccess(x, y) = cursor {
            cursor = &x;
            path.push(y);
        }
        let core = if let Expr::Name(x) = expr {
            x
        }else { todo!() };
        let full_path = format!("{}.{}", core, path.iter().rev().map(|x| x.to_string()).collect::<Vec<_>>().join("."));
        self.compile_name_lvalue(&full_path, write, modify_content)
    }
    fn compile_deref_lvalue(&mut self, operand: &Expr, _write: bool, _modify_content: bool) -> CompileResult<CompiledValue> {
        let pointer_rval = self.compile_rvalue(operand, Expected::Anything)?;
        if !pointer_rval.get_type().is_pointer() {
            return Err((Span::empty(), CompilerError::Generic(format!("Cannot dereference non-pointer type: {:?}", pointer_rval.get_type()))));
        }
        let ptype = pointer_rval.get_type().dereference().expect("msg");
        let llvm_repr = &pointer_rval;
        Ok(CompiledValue::Pointer { llvm_repr: llvm_repr.get_llvm_rep().clone(), ptype:ptype.clone() })
    }
    
    // --------------------------
    fn explicit_cast(
        &mut self,
        value: &CompiledValue,
        to_type: &CompilerType,
    ) -> CompileResult<CompiledValue> {
        if value.get_type() == to_type {
            return Ok(value.clone());
        }
        if let (Some(from_info), Some(to_info)) = (value.get_type().as_primitive(), to_type.as_primitive()) {
            if from_info.is_integer() && to_info.is_integer() {
                if from_info.layout == to_info.layout {
                    return Ok(CompiledValue::Value { llvm_repr: value.get_llvm_rep().clone(), ptype: CompilerType::Primitive(to_info) });
                }
                let op = if from_info.layout.size < to_info.layout.size {
                    if from_info.is_unsigned_integer() { "zext" } else { "sext" } 
                } else {"trunc"};
                
                let utvc = self.ctx.aquire_unique_temp_value_counter();
                self.output.push_str(&format!("    %tmp{utvc} = {} {} {} to {}\n", op, from_info.llvm_name, value.get_llvm_rep(), to_info.llvm_name));
                return Ok(CompiledValue::Value { llvm_repr: LLVMVal::Register(utvc), ptype: CompilerType::Primitive(to_info) });
            }else if from_info.is_decimal() && to_info.is_decimal() {
                if from_info.layout == to_info.layout {
                    return Ok(CompiledValue::Value { llvm_repr: value.get_llvm_rep().clone(), ptype: CompilerType::Primitive(to_info) });
                }
                let op = if from_info.layout.size < to_info.layout.size {"fpext"} else {"fptrunc"};
                let utvc = self.ctx.aquire_unique_temp_value_counter();
                self.output.push_str(&format!("    %tmp{utvc} = {} {} {} to {}\n", op, from_info.llvm_name, value.get_llvm_rep(), to_info.llvm_name));
                return Ok(CompiledValue::Value { llvm_repr: LLVMVal::Register(utvc), ptype: CompilerType::Primitive(to_info) });
            } else if from_info.is_integer() && to_info.is_decimal()  {
                let op = if from_info.is_unsigned_integer() { "uitofp" } else { "sitofp" };
                let utvc = self.ctx.aquire_unique_temp_value_counter();
                self.output.push_str(&format!("    %tmp{utvc} = {} {} {} to {}\n", op, from_info.llvm_name, value.get_llvm_rep(), to_info.llvm_name));
                return Ok(CompiledValue::Value { llvm_repr: LLVMVal::Register(utvc), ptype: CompilerType::Primitive(to_info) });
            } else if from_info.is_decimal() && to_info.is_integer()  {
                let op = if to_type.is_unsigned_integer() { "fptoui" } else { "fptosi" };
                let utvc = self.ctx.aquire_unique_temp_value_counter();
                self.output.push_str(&format!("    %tmp{utvc} = {} {} {} to {}\n", op, from_info.llvm_name, value.get_llvm_rep(), to_info.llvm_name));
                return Ok(CompiledValue::Value { llvm_repr: LLVMVal::Register(utvc), ptype: CompilerType::Primitive(to_info) });
            }
            else if from_info.is_bool() && to_info.is_integer(){
                let utvc = self.ctx.aquire_unique_temp_value_counter();
                self.output.push_str(&format!("    %tmp{utvc} = zext i1 {} to {}\n", value.get_llvm_rep(), to_info.llvm_name));
                return Ok(CompiledValue::Value { llvm_repr: LLVMVal::Register(utvc), ptype: CompilerType::Primitive(to_info) });
            }
        }else if value.get_type().is_pointer() && to_type.is_pointer() {
            return Ok(CompiledValue::Value { llvm_repr: value.get_llvm_rep().clone(), ptype: to_type.clone() });
        }
        panic!("{:?} {:?}", value, to_type)
    }
    fn compiler_function_calls(&mut self, callee: &Expr, given_args: &[Expr], expected: &Expected) -> Option<CompileResult<CompiledValue>>{ // --
        if let Expr::Name(name) = callee {
            if let Some((_, Some(func_ptr), _)) = COMPILER_FUNCTIONS.iter().find(|(n, _, _)| n == &name.as_str()) {
                return Some(func_ptr(self, given_args, expected));
            }
        }
        None
    }
    fn compiler_function_calls_generic(&mut self, callee: &Expr, given_args: &[Expr], given_generic: &[ParserType], expected: &Expected) -> Option<CompileResult<CompiledValue>>{ // --
        if let Expr::Name(name) = callee {
            if let Some((_, _, Some(generic_ptr))) = COMPILER_FUNCTIONS.iter().find(|(n, _, _)| n == &name.as_str()) {
                return Some(generic_ptr(self, given_args, given_generic, expected));
            }
        }
        None
    }
}
pub fn constant_expression_compiler(expr: &Expr) -> CompileResult<LLVMVal>{
    match expr {
        Expr::Integer(x) => Ok(LLVMVal::ConstantInteger(x.clone())),
        Expr::Decimal(x) => Ok(LLVMVal::ConstantDecimal(x.clone())),
        Expr::BinaryOp(x, op,y) =>{
            let l = constant_expression_compiler(x)?;
            let r = constant_expression_compiler(y)?;
            if let (LLVMVal::ConstantInteger(l), LLVMVal::ConstantInteger(r)) = (l, r) {
                let l = l.parse::<i128>().unwrap();
                let r = r.parse::<i128>().unwrap();
                let v = match op {
                    BinaryOp::Add => l + r,
                    BinaryOp::Subtract => l - r,
                    BinaryOp::Multiply => l * r,
                    BinaryOp::Divide => l / r,
                    BinaryOp::Modulo => l % r,
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
                    BinaryOp::ShiftLeft => l << r,
                    BinaryOp::ShiftRight => l >> r,
                };
                return Ok(LLVMVal::ConstantInteger(v.to_string()));
            }
            todo!()
        }
        _ => Err((Span::empty(), CompilerError::Generic(format!("Unsuported in constant {:?}", expr)))),
    }
}


pub fn compile_expression(expr: &Expr, expected: Expected, ctx: &mut CodeGenContext, output: &mut LLVMOutputHandler) -> CompileResult<CompiledValue> {
    ExpressionCompiler::new(ctx, output).compile_rvalue(expr, expected).map_err(|x| 
        (x.0, CompilerError::Generic(format!("{:?}\nin expression: {}", x.1 , expr.debug_emit())))
    )
}

fn stalloc_impl(
    compiler: &mut ExpressionCompiler, 
    given_args: &[Expr], 
    _expected: &Expected
) -> CompileResult<CompiledValue> {
    if given_args.len() != 1 {
        return Err((Span::empty(),CompilerError::Generic(format!(
            "stalloc(count) expects exactly 1 argument, but got {}", 
            given_args.len()
        ))));
    }

    let int_type = CompilerType::Primitive(DEFAULT_INTEGER_TYPE);
    let count_val = compiler.compile_rvalue(&given_args[0], Expected::Type(&int_type))?;
    
    if !count_val.get_type().is_integer() {
        return Err((Span::empty(),CompilerError::Generic(format!(
            "stalloc count must be an integer, but got {:?}", 
            count_val.get_type()
        ))));
    }

    let utvc = compiler.ctx.aquire_unique_temp_value_counter();
    let count_llvm_type = count_val.get_type().llvm_representation(compiler.ctx.symbols)?;

    compiler.output.push_str(&format!(
        "    %tmp{} = alloca i8, {} {}\n", 
        utvc, 
        count_llvm_type,
        count_val.get_llvm_rep()
    ));
    
    Ok(CompiledValue::Value { 
        llvm_repr: LLVMVal::Register(utvc), 
        ptype: CompilerType::Pointer(Box::new(CompilerType::Primitive(BYTE_TYPE))) 
    })
}
#[allow(unused)]
fn sizeof_impl(
    compiler: &mut ExpressionCompiler, 
    given_args: &[Expr], 
    expected: &Expected
) -> CompileResult<CompiledValue> {
    if given_args.len() != 1 {
        return Err((Span::empty(), CompilerError::Generic(format!(
            "sizeof(Type) expects exactly 1 argument, but got {}", 
            given_args.len()
        ))));
    }
    todo!()
    /*
     let sizeof_type = expr_to_parser_type(&given_args[0], compiler.ctx)?;
    let resolved_type = substitute_generic_type(&sizeof_type, &compiler.ctx.symbols.alias_types);
    let size = size_of_from_parser_type_pt(&resolved_type, compiler.ctx);

    let ptype = expected.get_type()
        .filter(|pt| pt.is_integer())
        .cloned()
        .unwrap_or_else(|| DEFAULT_INTEGER_TYPE.into());
        
    return Ok(CompiledValue::Value { 
        llvm_repr: LLVMVal::Constant(size.to_string()), 
        ptype 
    });
     */
}
fn sizeof_generic_impl(
    compiler: &mut ExpressionCompiler, 
    given_args: &[Expr], 
    given_generic: &[ParserType], 
    expected: &Expected
) -> CompileResult<CompiledValue> {
    if given_generic.len() != 1 {
        return Err((Span::empty(), CompilerError::Generic(format!(
            "sizeof<T>() expects exactly 1 generic type, but got {}",
            given_generic.len()
        ))));
    }
    if !given_args.is_empty() {
        return Err((Span::empty(), CompilerError::Generic(format!(
            "sizeof<T>() expects 0 arguments, but got {}",
            given_args.len()
        ))));
    }
    let mut target_type = CompilerType::into_path(&given_generic[0], compiler.ctx.symbols, compiler.ctx.current_function_path())?;
    target_type.substitute_generic_types(&compiler.ctx.symbols.alias_types, compiler.ctx.symbols)?;
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
        llvm_repr: LLVMVal::ConstantInteger(size.to_string()), 
        ptype: return_ptype
    })
}
fn stalloc_generic_impl(
    compiler: &mut ExpressionCompiler, 
    given_args: &[Expr], 
    given_generic: &[ParserType], 
    _expected: &Expected
) -> CompileResult<CompiledValue> {
    if given_generic.len() != 1 {
        return Err((Span::empty(), CompilerError::Generic(format!(
            "stalloc<T>(count) expects exactly 1 generic type, but got {}",
            given_generic.len()
        ))));
    }
    if given_args.len() != 1 {
        return Err((Span::empty(), CompilerError::Generic(format!(
            "stalloc<T>(count) expects exactly 1 argument (count), but got {}",
            given_args.len()
        ))));
    }
    let int_type = CompilerType::Primitive(DEFAULT_INTEGER_TYPE);
    let count_val = compiler.compile_rvalue(&given_args[0], Expected::Type(&int_type))?;
    if !count_val.get_type().is_integer() {
        return Err((Span::empty(), CompilerError::Generic(format!(
            "stalloc count must be an integer, but got {:?}",
            count_val.get_type()
        ))));
    }

    let target_type = CompilerType::into_path(&given_generic[0], compiler.ctx.symbols, compiler.ctx.current_function_path())?;
    let llvm_type_str = target_type.llvm_representation(compiler.ctx.symbols)?;
    let utvc = compiler.ctx.aquire_unique_temp_value_counter();
    compiler.output.push_str(&format!(
        "    %tmp{} = alloca {}, {} {}\n",
        utvc,
        llvm_type_str,
        count_val.get_type().llvm_representation(compiler.ctx.symbols)?,
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
    _expected: &Expected
) -> CompileResult<CompiledValue> {
    if given_args.len() != 1 {
        return Err((Span::empty(), CompilerError::Generic(format!(
            "ptr_of(variable) expects exactly 1 argument, but got {}", 
            given_args.len()
        ))));
    }

    let lvalue = compiler.compile_lvalue(&given_args[0], false, false)?;
    match lvalue {
        CompiledValue::Pointer { llvm_repr, ptype } => {
            Ok(CompiledValue::Value { 
                llvm_repr, 
                ptype: ptype.reference()
            })
        },
        CompiledValue::Function { internal_id } => {
            let func = compiler.ctx.symbols.get_function_by_id(internal_id);
            Ok(CompiledValue::Value { 
                llvm_repr: LLVMVal::Global(func.full_path().to_string()), 
                ptype: func.get_type().reference()
            })
        },
        CompiledValue::GenericFunctionImplementation { internal_id, types } =>{
            let func = compiler.ctx.symbols.get_function_by_id(internal_id); // todo
            let ind = func.get_implementation_index(&types).expect("msg");
            let name = func.call_path_impl_index(ind, compiler.ctx.symbols);
            Ok(CompiledValue::Value { 
                llvm_repr: LLVMVal::Global(name.to_string()), 
                ptype: func.get_type().reference()
            })
        }
        _ => Err((Span::empty(),CompilerError::Generic(format!(
            "Cannot take the address of an R-value or non-addressable expression: {:?}", 
            given_args[0]
        ))))
    }
}
#[allow(unused)]
fn alignof_impl(
    compiler: &mut ExpressionCompiler, 
    given_args: &[Expr], 
    expected: &Expected
) -> CompileResult<CompiledValue> {
    todo!()
}
#[allow(unused)]
fn alignof_generic_impl(
    compiler: &mut ExpressionCompiler, 
    given_args: &[Expr], 
    given_generic: &[ParserType], 
    expected: &Expected
) -> CompileResult<CompiledValue> {
    todo!()
}
// Done
fn bitcast_generic_impl(
    compiler: &mut ExpressionCompiler, 
    given_args: &[Expr], 
    given_generic: &[ParserType], 
    _expected: &Expected
) -> CompileResult<CompiledValue> {
    if given_generic.len() != 1 {
        return Err((Span::empty(),CompilerError::Generic(format!(
            "bitcast<T>(value) expects exactly 1 generic target type, but got {}",
            given_generic.len()
        ))));
    }
    if given_args.len() != 1 {
        return Err((Span::empty(),CompilerError::Generic(format!(
            "bitcast<T>(value) expects exactly 1 argument, but got {}",
            given_args.len()
        ))));
    }
    let source_val = compiler.compile_rvalue(&given_args[0], Expected::Anything)?;
    let target_type = CompilerType::into_path(&given_generic[0], compiler.ctx.symbols, compiler.ctx.current_function_path())?;
    
    let src_layout = source_val.get_type().size_and_layout(compiler.ctx.symbols);
    let dst_layout = target_type.size_and_layout(compiler.ctx.symbols);
    if src_layout.size != dst_layout.size && !source_val.get_type().is_pointer() && !target_type.is_pointer() {
        return Err((Span::empty(), CompilerError::Generic(format!(
            "bitcast size mismatch: cannot cast from {:?} ({} bytes) to {:?} ({} bytes)",
            source_val.get_type(), src_layout.size,
            target_type, dst_layout.size
        ))));
    }
    if source_val.get_type().is_pointer() ^ target_type.is_pointer() {
        let (from_t, from_v) = (source_val.get_type().llvm_representation(compiler.ctx.symbols)?, source_val.get_llvm_rep().to_string());
        let to_str = target_type.llvm_representation(compiler.ctx.symbols)?;
        let utvc = compiler.ctx.aquire_unique_temp_value_counter();
        if source_val.get_type().is_pointer() {
            compiler.output.push_str(&format!(
                "    %tmp{} = ptrtoint {} {} to {}\n",
                utvc,
                from_t,
                from_v,
                to_str
            ));
            return Ok(CompiledValue::Value {
                llvm_repr: LLVMVal::Register(utvc),
                ptype: target_type,
            });
        }else {
            compiler.output.push_str(&format!(
                "    %tmp{} = inttoptr {} {} to {}\n",
                utvc,
                from_t,
                from_v,
                to_str
            ));
            return Ok(CompiledValue::Value {
                llvm_repr: LLVMVal::Register(utvc),
                ptype: target_type,
            });
        }
    }
    let src_llvm_type = source_val.get_type().llvm_representation(compiler.ctx.symbols)?;
    let dst_llvm_type = target_type.llvm_representation(compiler.ctx.symbols)?;
    let utvc = compiler.ctx.aquire_unique_temp_value_counter();

    compiler.output.push_str(&format!(
        "    %tmp{} = bitcast {} {} to {}\n",
        utvc,
        src_llvm_type,
        source_val.get_llvm_rep(),
        dst_llvm_type
    ));

    Ok(CompiledValue::Value {
        llvm_repr: LLVMVal::Register(utvc),
        ptype: target_type,
    })
}