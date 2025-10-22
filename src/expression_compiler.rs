use crate::{compiler::{get_llvm_type_str, CodeGenContext, CompileError, CompileResult, LLVMOutputHandler, SymbolTable, POINTER_SIZE_IN_BYTES}, compiler_essentials::Variable, expression_parser::{BinaryOp, Expr, UnaryOp}, parser::{ParserType, Stmt}};
#[derive(Debug, Clone, PartialEq)]
pub enum Expected<'a> {
    Type(&'a ParserType),
    Anything,
    NoReturn,
}

#[derive(Debug, Clone, PartialEq)]
pub enum CompiledValue {
    Value {
        llvm_repr: String,
        ptype: ParserType,
    },
    Pointer {
        llvm_repr: String,
        ptype: ParserType,
    },
    Function {
        effective_name: String,
        ptype: ParserType,
    },
    NoReturn,
}
impl CompiledValue {
    pub fn get_type(&self) -> &ParserType {
        match self {
            Self::Value { ptype, .. } => ptype,
            Self::Pointer { ptype, .. } => ptype,
            Self::Function { ptype: ftype, .. } => ftype,
            Self::NoReturn => panic!("Cannot get type of NoReturn value"),
        }
    }
    pub fn get_llvm_repr(&self) -> String {
        match self {
            Self::Value { llvm_repr, .. } => llvm_repr.clone(),
            Self::Pointer { llvm_repr, .. } => llvm_repr.clone(),
            Self::Function { effective_name, .. } => format!("@{}", effective_name),
            Self::NoReturn => panic!("Cannot get LLVM representation of NoReturn value"),
        }
    }
    pub fn get_llvm_repr_with_type(&self, ctx: &CodeGenContext) -> CompileResult<String> {
        let type_str = get_llvm_type_str(self.get_type(), ctx.symbols, &ctx.current_function_path)?;
        let repr = self.get_llvm_repr();
        
        match self {
            Self::Pointer { .. } => Ok(format!("{}* {}", type_str, repr)),
            _ => Ok(format!("{} {}", type_str, repr)),
        }
    }
    
    pub fn clone_with_type(&self, new_type: ParserType) -> Self {
        match self {
            Self::Value { llvm_repr, .. } => Self::Value { llvm_repr: llvm_repr.clone(), ptype: new_type },
            Self::Pointer { llvm_repr, .. } => Self::Pointer { llvm_repr: llvm_repr.clone(), ptype: new_type },
            Self::Function { effective_name, .. } => Self::Function { effective_name: effective_name.clone(), ptype: new_type },
            Self::NoReturn => panic!("with_type is not applicable to NoReturn"),
        }
    }
    pub fn llvm_repr_ref(&self) -> &str {
        match self {
            Self::Value { llvm_repr, .. } => llvm_repr,
            Self::Pointer { llvm_repr, .. } => llvm_repr,
            _ => panic!("Cannot get literal LLVM representation"),
        }
    }
    pub fn is_literal_number(&self) -> bool {
        matches!(self, Self::Value { llvm_repr, .. } if llvm_repr.chars().all(|c| c.is_ascii_digit() || c == '-'))
    }
    pub fn no_return_check(&self) -> CompileResult<()>{
        if *self == Self::NoReturn {
            return Err(CompileError::InvalidExpression(format!("Tried to use void value")));
        }
        Ok(())
    }
}

pub fn compile_expression(expr: &Expr, expected: Expected, ctx: &mut CodeGenContext, output: &mut LLVMOutputHandler) -> CompileResult<CompiledValue> {
    ExpressionCompiler::new(ctx, output).compile_rvalue(expr, expected)
}

struct ExpressionCompiler<'a, 'b> {
    ctx: &'a mut CodeGenContext<'b>,
    output: &'a mut LLVMOutputHandler,
}
impl<'a, 'b> ExpressionCompiler<'a, 'b> {
    fn new(ctx: &'a mut CodeGenContext<'b>, output: &'a mut LLVMOutputHandler) -> Self {
        Self { ctx, output }
    }
    
    fn compile_rvalue(&mut self, expr: &Expr, expected: Expected) -> CompileResult<CompiledValue> {
        match expr {
            Expr::Name(name) => self.compile_name_rvalue(name, expected),
            Expr::Integer(num_str) => self.compile_integer_literal(num_str, expected),
            Expr::Assign(lhs, rhs) => self.compile_assignment(lhs, rhs, expected),
            Expr::Call(callee, args) => self.compile_call(callee, args, expected),
            Expr::MemberAccess(..) => self.compile_member_access_rvalue(expr),
            Expr::Cast(expr, target_type) => self.compile_cast(expr, target_type, expected),
            Expr::BinaryOp(l, op, r) => self.compile_binary_op(l, op, r, expected),
            Expr::UnaryOp(op, operand) => self.compile_unary_op_rvalue(op, operand, expected),
            Expr::StaticAccess(..) => self.compile_static_access_rvalue(expr),
            Expr::StringConst(str_val) => self.compile_string_literal(str_val),
            Expr::Index(..) => self.compile_index_rvalue(expr),
        }
    }
    fn compile_lvalue(&mut self, expr: &Expr) -> CompileResult<CompiledValue> {
        match expr {
            Expr::Name(name) => self.compile_name_lvalue(name),
            Expr::StaticAccess(..) => self.compile_static_access_lvalue(expr),
            Expr::MemberAccess(obj, member) => self.compile_member_access_lvalue(obj, member),
            Expr::UnaryOp(UnaryOp::Deref, operand) => self.compile_deref_lvalue(operand),
            Expr::Index(array, index) => self.compile_index_lvalue(array, index),
            Expr::BinaryOp(..) => self.compile_rvalue(expr, Expected::Anything),
            _ => Err(CompileError::Generic(format!("Expression {:?} is not a valid lvalue", expr))),
        }
    }
    // ----------------------======++$$@RVALUE@$$++======-----------------
    fn compile_binary_op(&mut self, lhs: &Expr, op: &BinaryOp, rhs: &Expr, expected: Expected<'_>) -> Result<CompiledValue, CompileError> {
        debug_assert!(expected != Expected::NoReturn);
        let mut l = self.compile_rvalue(&lhs, Expected::Anything)?;
        debug_assert!(l != CompiledValue::NoReturn);
        let mut r = self.compile_rvalue(&rhs, Expected::Type(l.get_type()))?;
        debug_assert!(r != CompiledValue::NoReturn);
        // Swap them
        if l.is_literal_number() && !r.is_literal_number() 
            && (matches!(op, BinaryOp::Add | BinaryOp::Multiply | BinaryOp::BitAnd | BinaryOp::BitOr | BinaryOp::BitXor | BinaryOp::And | BinaryOp::Or | BinaryOp::Equals)) 
            && r.get_type().dereference_full().is_integer() {
            (r, l) = (l, r);
            r = r.clone_with_type(l.get_type().clone());
        }
        if l.get_type() != r.get_type() {
            if l.get_type().is_pointer() && r.get_type().is_integer() && *op == BinaryOp::Add {  // *(array_pointer + iterator)
                let utvc = self.ctx.aquire_unique_temp_value_counter();
                let pointed_to_type = l.get_type().dereference_once();
                let llvm_pointed_to_type = get_llvm_type_str(&pointed_to_type, self.ctx.symbols, &self.ctx.current_function_path)?;

                self.output.push_str(&format!("    %tmp{} = getelementptr {}, {}* {}, {}\n", utvc, llvm_pointed_to_type, llvm_pointed_to_type, l.get_llvm_repr(), r.get_llvm_repr_with_type(self.ctx)?));
                return Ok(CompiledValue::Value{llvm_repr: format!("%tmp{}",utvc), ptype: l.get_type().clone()});
            }
            return Err(CompileError::Generic(format!("Binary operator '{:?}' cannot be applied to mismatched types '{}' and '{}'",op,l.get_type().to_string(),r.get_type().to_string())));
        }
        
        let ltype = l.get_type();
        if ltype.is_integer() || ltype.is_bool() {
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

            let both_types_llvm_repr = get_llvm_type_str(ltype, self.ctx.symbols, &self.ctx.current_function_name)?;
            let utvc = self.ctx.aquire_unique_temp_value_counter();
            self.output.push_str(&format!("    %tmp{} = {} {} {}, {}\n",utvc, llvm_op, both_types_llvm_repr, l.get_llvm_repr(), r.get_llvm_repr()));

            let result_type = if llvm_op.starts_with("icmp") {
                ParserType::Named("bool".to_string())
            } else {
                l.get_type().clone()
            };

            return Ok(CompiledValue::Value { llvm_repr: format!("%tmp{}",utvc), ptype: result_type });
        }
        
        if ltype.is_pointer() {
            let llvm_op = match op {
                BinaryOp::Equals => "icmp eq",
                BinaryOp::NotEqual => "icmp ne",
                _ => panic!("Operation \"{:?}\" is not permited on pointers", op)
            };
            let utvc = self.ctx.aquire_unique_temp_value_counter();
            self.output.push_str(&format!("    %tmp{} = {} ptr {}, {}\n",utvc, llvm_op, l.get_llvm_repr(), r.get_llvm_repr()));
            return Ok(CompiledValue::Value { llvm_repr: format!("%tmp{}",utvc), ptype: ParserType::Named(format!("bool")) });
        }
        
        return Err(CompileError::Generic(format!("Binary operator \"{:?}\" was not implemted for types \"{:?}\"", op, l)));
    }
    
    fn compile_call(&mut self, callee: &Expr, given_args: &[Expr], expected: Expected<'_>) -> Result<CompiledValue, CompileError> {
        if let Some(x) = self.compiler_function_calls(callee, given_args, &expected) {
            return x;
        }
        let l: CompiledValue = self.compile_lvalue(callee)?;
        if let CompiledValue::Function { effective_name, ptype: ParserType::Function(return_type, required_arguments)} = &l {
            if required_arguments.len() != given_args.len() {
                return Err(CompileError::Generic(format!("Amount of arguments provided '{}' does not equal to amount requested by function '{}'", required_arguments.len(), given_args.len())));
            }

            let func = self.ctx.symbols.get_function(&effective_name, &self.ctx.current_function_path)?;
            let return_type_repr = get_llvm_type_str(&return_type, self.ctx.symbols, &func.path)?;
            if func.is_inline() {
                if func.body.is_empty() {
                    if func.return_type.is_void() {
                        return Ok(CompiledValue::NoReturn);
                    }
                    return Err(CompileError::Generic(format!("Inline function '{}' body was empty but return type is not void", func.name)));
                }
                let inline_exit = self.ctx.aquire_unique_logic_counter();
                let return_tmp = self.ctx.aquire_unique_temp_value_counter();
                if !func.return_type.is_void() {
                    self.output.push_str(&format!("    %iv{} = alloca {}\n", return_tmp, return_type_repr));
                }
                let mut prepared_args = vec![];
                for i in 0..required_arguments.len() {
                    let x = self.compile_rvalue(&given_args[i], Expected::Type(&required_arguments[i]))?;
                    if x.get_type() != &required_arguments[i] {
                        return CompileResult::Err(CompileError::InvalidExpression(format!("{:?} vs {:?} type missmatch with {}th argument", x.get_type(), &required_arguments[i], i + 1)));
                    }
                    let arg_name = &func.args[i].0;
                    match &x {
                        CompiledValue::Value { llvm_repr, ptype } =>{
                            if llvm_repr.chars().nth(0).map(|x| x.is_digit(10)).unwrap_or(false) {
                                // Number
                                let utvc = self.ctx.aquire_unique_temp_value_counter();
                                self.output.push_str(&format!("    %tmp{} = add {} {}, 0\n",utvc, ptype.to_string(), llvm_repr));
                                prepared_args.push((arg_name, ptype.clone(), utvc));
                                continue;
                            }
                            if llvm_repr.chars().nth(1).map(|x| x == 'v').unwrap_or(false) {
                                // Variable
                                let utvc = self.ctx.aquire_unique_temp_value_counter();
                                let repr = get_llvm_type_str(&ptype, self.ctx.symbols, &func.path)?;
                                self.output.push_str(&format!("    %tmp{} = bitcast {}* {} to {}*\n",utvc, repr, llvm_repr, repr));
                                prepared_args.push((arg_name, ptype.clone(), utvc));
                                continue;
                            }
                            // Tmp val
                            let n = llvm_repr[4..].parse::<u32>().unwrap();
                            prepared_args.push((arg_name, ptype.clone(), n));
                        }
                        _ => panic!()
                    }
                }

                let lp = self.ctx.current_function_path.clone();
                self.ctx.current_function_path = func.path.to_string();
                let ls = self.ctx.scope.clone();
                self.ctx.scope.clear();
                for arg in prepared_args {
                    self.ctx.scope.add_variable(arg.0.to_string(), Variable::new_alias(arg.1.clone()), arg.2);
                }
                for x in &func.body {
                    match x {
                        Stmt::Let(name, var_type, expr) =>{
                            let llvm_type = get_llvm_type_str(var_type, self.ctx.symbols, &self.ctx.current_function_path)?;
                            let x = self.ctx.aquire_unique_temp_value_counter() + u32::MAX / 2; // Hack
                            self.ctx.scope.add_variable(name.clone(), Variable::new(var_type.clone(), false), x); 
                            self.output.push_str(&format!("    %v{} = alloca {}; var: {}\n", x, llvm_type, name));

                            if let Some(init_expr) = expr {
                                let assignment = Expr::Assign(
                                    Box::new(Expr::Name(name.clone())),
                                    Box::new(init_expr.clone())
                                );
                                compile_expression(&assignment, Expected::NoReturn, self.ctx, self.output)?;
                            }
                        }
                        Stmt::Return(x) =>{
                            assert!(!(!x.is_none() && func.return_type.is_void()));
                            assert!(!(x.is_none() && !func.return_type.is_void()));
                            if let Some(x) = x {
                                let expected_type = &func.return_type;
                                let value = compile_expression(x, Expected::Type(expected_type), self.ctx, self.output)?;
                                
                                let llvm_type_str = get_llvm_type_str(expected_type, self.ctx.symbols, &self.ctx.current_function_path)?;
                                self.output.push_str(&format!("    store {} {}, {}* %iv{}\n", llvm_type_str, value.get_llvm_repr(), llvm_type_str, return_tmp));
                                continue;
                            }
                            self.output.push_str(&format!("    br label %inline_exit{}\n",inline_exit));
                        }
                        _ => crate::compiler::compile_statement(x, self.ctx, self.output)?,
                    }
                }
                self.output.push_str(&format!("    br label %inline_exit{}\n",inline_exit));
                self.output.push_str(&format!("inline_exit{}:\n", inline_exit));
                self.ctx.scope.swap_and_exit(ls);
                self.ctx.current_function_path = lp;

                if return_type.is_void() {
                    return Ok(CompiledValue::NoReturn);
                }
                let rv_utvc = self.ctx.aquire_unique_temp_value_counter();
                self.output.push_str(&format!("    %tmp{} = load {}, {}* %iv{}\n",rv_utvc,return_type_repr,return_type_repr,return_tmp));
                return Ok(CompiledValue::Value { llvm_repr: format!("%tmp{}", rv_utvc), ptype: func.return_type.clone() });
            }

            let mut compiled_arguments = vec![];
            for i in 0..required_arguments.len() {
                let x = self.compile_rvalue(&given_args[i], Expected::Type(&required_arguments[i]))?;
                if x.get_type() != &required_arguments[i] {
                    return CompileResult::Err(CompileError::InvalidExpression(format!("{:?} vs {:?} type missmatch with {}th argument", x.get_type(), &required_arguments[i], i + 1)));
                }
                compiled_arguments.push(x.get_llvm_repr_with_type(self.ctx)?);
            }
            let arg_string = compiled_arguments.join(", ");

            if return_type.is_void() {
                self.output.push_str(&format!("    call void @{}({})\n", func.get_llvm_repr(), arg_string));
                return Ok(CompiledValue::NoReturn);
            }
            if expected != Expected::NoReturn {
                let utvc = self.ctx.aquire_unique_temp_value_counter();
                self.output.push_str(&format!("    %tmp{} = call {} @{}({})\n", utvc, return_type_repr, func.get_llvm_repr(), arg_string));
                return Ok(CompiledValue::Value { llvm_repr: format!("%tmp{}", utvc), ptype: *return_type.clone() });
            }
            self.output.push_str(&format!("    call {} @{}({})\n", return_type_repr, func.get_llvm_repr(), arg_string));
            return Ok(CompiledValue::NoReturn);
        }
        if let CompiledValue::Pointer { llvm_repr, ptype: ParserType::Function(return_type, required_arguments) } = &l {
            if required_arguments.len() != given_args.len() {
                return Err(CompileError::Generic(format!("Amount of arguments provided '{}' does not equal to amount requested by function '{}'", required_arguments.len(), given_args.len())));
            }
            let mut compiled_arguments = vec![];
            for i in 0..required_arguments.len() {
                let x = self.compile_rvalue(&given_args[i], Expected::Type(&required_arguments[i]))?;
                if x.get_type() != &required_arguments[i] {
                    return CompileResult::Err(CompileError::InvalidExpression(format!("{:?} vs {:?} type missmatch with {}th argument", x.get_type(), &required_arguments[i], i + 1)));
                }
                compiled_arguments.push(x.get_llvm_repr_with_type(self.ctx)?);
            }
            let arg_string = compiled_arguments.join(", ");

            if return_type.is_void() {
                self.output.push_str(&format!("    call void {}({})\n", llvm_repr, arg_string));
                return Ok(CompiledValue::NoReturn);
            }

            let utvc = self.ctx.aquire_unique_temp_value_counter();
            let return_type_repr = get_llvm_type_str(&return_type, self.ctx.symbols, &self.ctx.current_function_path)?;
            self.output.push_str(&format!("    %tmp{} = call {} {}({})\n", utvc, return_type_repr, llvm_repr, arg_string));
            return Ok(CompiledValue::Value { llvm_repr: format!("%tmp{}", utvc), ptype: *return_type.clone() });
        }
        return Err(CompileError::Generic(format!("Left hand side expression is not function call it is: {:?}", callee)));
    }

    fn compile_name_rvalue(&mut self, name: &str, _expected: Expected) -> CompileResult<CompiledValue> {
        if let Ok((variable, id)) = self.ctx.scope.get_variable(name) {
            variable.get_type(false, false);
            let ptype = variable.compiler_type.clone();
            if variable.is_argument() {
                let llvm_repr = if variable.is_alias_value() {
                    format!("%tmp{}", id)
                } else {
                    format!("%{}", name)
                };
                return Ok(CompiledValue::Value { llvm_repr, ptype });
            }

            let type_str = get_llvm_type_str(&ptype, self.ctx.symbols, &self.ctx.current_function_path)?;
            let temp_id = self.ctx.aquire_unique_temp_value_counter();
            self.output.push_str(&format!("    %tmp{} = load {}, {}* %v{}\n", temp_id, type_str, type_str, id));
            return Ok(CompiledValue::Value { llvm_repr: format!("%tmp{}", temp_id), ptype });
        }
        
        if let Ok(function) = self.ctx.symbols.get_function(name, &self.ctx.current_function_path) {
            return Ok(CompiledValue::Function {
                effective_name: function.effective_name().to_string(),
                ptype: function.get_type(),
            });
        }

        Err(CompileError::SymbolNotFound(format!("Symbol '{}' not found in '{}'", name, self.ctx.current_function_path)))
    }
    fn compile_integer_literal(&mut self, num_str: &str, expected: Expected) -> CompileResult<CompiledValue> {
        if let Expected::Type(ptype) = expected {
            if ptype.is_integer() {
                return Ok(CompiledValue::Value { llvm_repr: num_str.to_string(), ptype: ptype.clone() });
            }
            if ptype.is_bool() {
                let llvm_repr = if num_str != "0" { "1" } else { "0" }.to_string();
                return Ok(CompiledValue::Value { llvm_repr, ptype: ptype.clone() });
            }
            if ptype.is_pointer() && num_str == "0" {
                return Ok(CompiledValue::Value { llvm_repr: "null".to_string(), ptype: ptype.clone() });
            }
        }
        Ok(CompiledValue::Value { llvm_repr: num_str.to_string(), ptype: ParserType::Named("i64".to_string()) })
    }
    fn compile_assignment(&mut self, lhs: &Expr, rhs: &Expr, expected: Expected) -> CompileResult<CompiledValue> {
        let left_ptr = self.compile_lvalue(lhs)?;
        if !matches!(left_ptr, CompiledValue::Pointer { .. }) {
            return Err(CompileError::InvalidExpression(format!("{:?} does not yield a valid lvalue", lhs)));
        }

        let right_val = self.compile_rvalue(rhs, Expected::Type(left_ptr.get_type()))?;
        if left_ptr.get_type() != right_val.get_type() {
            return Err(CompileError::InvalidExpression(format!("Type mismatch in assignment: {:?} and {:?}", left_ptr.get_type(), right_val.get_type())));
        }
        let left_str = left_ptr.get_llvm_repr_with_type(self.ctx)?;
        let right_str = right_val.get_llvm_repr_with_type(self.ctx)?;
        self.output.push_str(&format!("    store {}, {}\n", right_str, left_str));

        if matches!(expected, Expected::NoReturn) {
            Ok(CompiledValue::NoReturn)
        } else {
            Ok(right_val)
        }
    }
    fn compile_member_access_rvalue(&mut self, expr: &Expr) -> CompileResult<CompiledValue> {
        let member_ptr = self.compile_lvalue(expr)?;
        let temp_id = self.ctx.aquire_unique_temp_value_counter();
        let ptype = member_ptr.get_type().clone();
        let type_str = get_llvm_type_str(&ptype, self.ctx.symbols, &self.ctx.current_function_path)?;
        self.output.push_str(&format!("    %tmp{} = load {}, {}* {}\n", temp_id, type_str, type_str, member_ptr.get_llvm_repr()));
        Ok(CompiledValue::Value { llvm_repr: format!("%tmp{}", temp_id), ptype })
    }
    
    fn compile_cast(&mut self, expr: &Expr, target_type: &ParserType, expected: Expected) -> CompileResult<CompiledValue> {
        let value = self.compile_rvalue(expr, expected)?;
        if value.get_type() == target_type {
            return Ok(value);
        }
        explicit_cast(&value, target_type, self.ctx, self.output)
    }
    fn compile_unary_op_rvalue(&mut self, op: &UnaryOp, operand_expr: &Expr, expected: Expected) -> CompileResult<CompiledValue> {
        match op {
            UnaryOp::Deref => {
                let value = self.compile_rvalue(operand_expr, expected)?;
                if !value.get_type().is_pointer() {
                    return Err(CompileError::Generic(format!("Cannot dereference non-pointer value {:?}", value)));
                }
                let pointed_to_type = value.get_type().dereference_once();
                let type_str = get_llvm_type_str(&pointed_to_type, self.ctx.symbols, &self.ctx.current_function_path)?;
                let temp_id = self.ctx.aquire_unique_temp_value_counter();
                self.output.push_str(&format!("    %tmp{} = load {}, {}* {}\n", temp_id, type_str, type_str, value.get_llvm_repr()));
                Ok(CompiledValue::Value { llvm_repr: format!("%tmp{}", temp_id), ptype: pointed_to_type.clone() })
            }
            UnaryOp::Pointer => {
                let lvalue = self.compile_lvalue(operand_expr)?;
                let ptype = lvalue.get_type().clone().reference_once();
                Ok(CompiledValue::Value { llvm_repr: lvalue.get_llvm_repr(), ptype })
            }
            UnaryOp::Negate => {
                let value = self.compile_rvalue(operand_expr, expected)?;
                if !value.get_type().is_integer() {
                    return Err(CompileError::Generic("Cannot negate non-integer type".to_string()));
                }
                if value.is_literal_number() {
                    let num = -value.llvm_repr_ref().parse::<i128>().unwrap();
                    return Ok(CompiledValue::Value { llvm_repr: num.to_string(), ptype: value.get_type().clone() });
                }
                let type_str = get_llvm_type_str(value.get_type(), self.ctx.symbols, &self.ctx.current_function_name)?;
                let temp_id = self.ctx.aquire_unique_temp_value_counter();
                self.output.push_str(&format!("    %tmp{} = sub {} 0, {}\n", temp_id, type_str, value.get_llvm_repr()));
                Ok(CompiledValue::Value { llvm_repr: format!("%tmp{}", temp_id), ptype: value.get_type().clone() })
            }
            UnaryOp::Not => {
                let value = self.compile_rvalue(operand_expr, Expected::Type(&ParserType::Named("bool".to_string())))?;
                if !value.get_type().is_bool() {
                    return Err(CompileError::InvalidExpression("Logical NOT can only be applied to booleans".to_string()));
                }
                let temp_id = self.ctx.aquire_unique_temp_value_counter();
                self.output.push_str(&format!("    %tmp{} = xor i1 {}, 1\n", temp_id, value.get_llvm_repr()));
                Ok(CompiledValue::Value { llvm_repr: format!("%tmp{}", temp_id), ptype: value.get_type().clone() })
            }
        }
    }

    fn compile_static_access_rvalue(&mut self, expr: &Expr) -> CompileResult<CompiledValue> {
        let path = get_path_from_expr(expr);
        
        if let Ok((variable, _)) = self.ctx.scope.get_variable(&path) {
            return Ok(CompiledValue::Pointer { llvm_repr: format!("%{}", &path), ptype: variable.compiler_type.clone() });
        }
        
        if let Ok(function) = self.ctx.symbols.get_function(&path, &self.ctx.current_function_path) {
            return Ok(CompiledValue::Function { effective_name: function.effective_name().to_string(), ptype: function.get_type() });
        }

        if let Some((enum_path, member_name)) = path.rsplit_once('.') {
            let qualified_enum_path = format!("{}.{}", self.ctx.current_function_path, enum_path);
            if let Some(r#enum) = self.ctx.symbols.enums.get(&qualified_enum_path) {
                if let Some((_, val)) = r#enum.fields.iter().find(|(name, _)| name == member_name) {
                    return Ok(CompiledValue::Value { llvm_repr: val.to_string(), ptype: r#enum.base_type.clone() });
                }
            }
        }

        Err(CompileError::SymbolNotFound(format!("Symbol '{}' not found", path)))
    }
    fn compile_index_rvalue(&mut self, expr: &Expr) -> CompileResult<CompiledValue> {
        let ptr = self.compile_lvalue(expr)?;
        let ptype = ptr.get_type().clone();
        let type_str = get_llvm_type_str(&ptype, self.ctx.symbols, &self.ctx.current_function_path)?;
        let temp_id = self.ctx.aquire_unique_temp_value_counter();
        let ptr_str = ptr.get_llvm_repr_with_type(self.ctx)?;
        self.output.push_str(&format!("    %tmp{} = load {}, {}\n", temp_id, type_str, ptr_str));
        Ok(CompiledValue::Value { llvm_repr: format!("%tmp{}", temp_id), ptype })
    }
    fn compile_string_literal(&mut self, str_val: &str) -> CompileResult<CompiledValue> { // ---
        let str_len = str_val.len() + 1;
        let const_id = self.ctx.aquire_unique_const_vector_counter();
        let const_name = format!("@.str.{}", const_id);
        let escaped_val = str_val.replace("\"", "\\22")
            .replace("\n", "\\0A")
            .replace("\r", "\\0D")
            .replace("\t", "\\09");
        self.output.push_str_header(&format!(
            "{} = private unnamed_addr constant [{} x i8] c\"{}\\00\"\n",
            const_name, str_len, escaped_val
        ));
        let ptr_id = self.ctx.aquire_unique_temp_value_counter();
        self.output.push_str(&format!("    %tmp{} = getelementptr inbounds [{} x i8], [{} x i8]* {}, i64 0, i64 0\n", ptr_id, str_len, str_len, const_name));
        Ok(CompiledValue::Value {
            llvm_repr: format!("%tmp{}", ptr_id),
            ptype: ParserType::Pointer(Box::new(ParserType::Named("i8".to_string()))),
        })
    }
    fn compiler_function_calls(&mut self, callee: &Expr, given_args: &[Expr], expected: &Expected) -> Option<CompileResult<CompiledValue>>{ // --

        if let Expr::Name(x) = callee {
            match x.as_str() {
                "sizeof" =>{
                    debug_assert!(*expected != Expected::NoReturn);
                    if given_args.len() != 1 { return Some(Err(CompileError::Generic(format!("sizeof expects exactly 1 type argument. Example: sizeof(i32);"))));}
                    if let Ok(sizeof) = self.sizeof_from_expression(&given_args[0]){
                        if let Expected::Type(pt) = expected {
                            if pt.is_integer() {
                                return Some(Ok(CompiledValue::Value { llvm_repr: sizeof.to_string(), ptype: (*pt).clone() }));
                            }
                        }
                        return Some(Ok(CompiledValue::Value { llvm_repr: sizeof.to_string(), ptype: ParserType::Named(format!("i64")) }));
                    }
                    return Some(Err(CompileError::Generic(format!("Unable to calculate sizeof structure given by this expression '{:?}'", given_args[0]))));
                }
                "stalloc" =>{
                    debug_assert!(*expected != Expected::NoReturn);
                    if given_args.len() != 1 { return Some(Err(CompileError::Generic(format!("sizeof expects exactly 1 type argument. Example: sizeof(i32);"))));}
                    if let Ok(r_val) = self.compile_rvalue(&given_args[0], Expected::Type(&ParserType::Named(format!("i64")))) {
                        let utvc = self.ctx.aquire_unique_temp_value_counter();
                        self.output.push_str(&format!("    %tmp{} = alloca i8, i64 {}\n",utvc, r_val.get_llvm_repr()));
                        return Some(Ok(CompiledValue::Value { llvm_repr: format!("%tmp{}", utvc), ptype: ParserType::Pointer(Box::new(ParserType::Named(format!("i8")))) }));
                    }
                    return Some(Err(CompileError::Generic(format!("Unable to get i64 from this expression '{:?}'", given_args[0]))));
                }
                _ => {}
            }
        }
        None
    }
    // ----------------------======++$$@LVALUE@$$++======-----------------
    fn compile_name_lvalue(&mut self, name: &str) -> CompileResult<CompiledValue> {
        if let Ok((variable, id)) = self.ctx.scope.get_variable(name) {
            let ptype = variable.compiler_type.clone();
            let llvm_repr = if variable.is_argument() {
                if variable.is_alias_value() { format!("%tmp{}", id) } else { format!("%{}", name) }
            } else {
                format!("%v{}", id)
            };
            return Ok(CompiledValue::Pointer { llvm_repr, ptype });
        }
        if let Ok(function) = self.ctx.symbols.get_function(name, &self.ctx.current_function_path) {
            return Ok(CompiledValue::Function { effective_name: function.effective_name().to_string(), ptype: function.get_type() });
        }
        Err(CompileError::SymbolNotFound(format!("Lvalue '{}' not found", name)))
    }
    fn compile_static_access_lvalue(&mut self, expr: &Expr) -> CompileResult<CompiledValue> {
        let path = get_path_from_expr(expr);
        if let Ok((variable, _)) = self.ctx.scope.get_variable(&path) {
            return Ok(CompiledValue::Pointer { llvm_repr: format!("%{}", &path), ptype: variable.compiler_type.clone() });
        }
        if let Ok(function) = self.ctx.symbols.get_function(&path, &self.ctx.current_function_path) {
            return Ok(CompiledValue::Function { effective_name: function.effective_name().to_string(), ptype: function.get_type() });
        }
        Err(CompileError::SymbolNotFound(format!("Static symbol '{}' not found", path)))
    }
    fn compile_member_access_lvalue(&mut self, obj: &Expr, member: &str) -> CompileResult<CompiledValue> {
        let obj_lvalue = self.compile_lvalue(obj)?;

        let (base_ptr_repr, struct_type_to_index) = if obj_lvalue.get_type().is_pointer() {
            let obj_rvalue = self.compile_rvalue(obj, Expected::Anything)?;
            let struct_type = obj_rvalue.get_type().dereference_once().clone();
            (obj_rvalue.get_llvm_repr(), struct_type)
        } else {
            let struct_type = obj_lvalue.get_type().clone();
            (obj_lvalue.get_llvm_repr(), struct_type)
        };
        let (struct_fqn, fields) = self.ctx.symbols.get_struct_representation(&struct_type_to_index, &self.ctx.current_function_path)?;
        let field_index = fields.iter().position(|(name, _)| name == member)
            .ok_or_else(|| CompileError::Generic(format!("Member '{}' not found in struct '{}'", member, struct_fqn)))?;
        
        let field_ptype = &fields[field_index].1;
        let llvm_struct_type = get_llvm_type_str(&struct_type_to_index, self.ctx.symbols, &self.ctx.current_function_path)?;
        
        let gep_id = self.ctx.aquire_unique_temp_value_counter();
        let gep_result_reg = format!("%tmp{}", gep_id);
        
        let llvm_struct_ptr_type = format!("{}*", llvm_struct_type);

        self.output.push_str(&format!(
            "    {} = getelementptr inbounds {}, {} {}, i32 0, i32 {}\n",
            gep_result_reg, 
            llvm_struct_type,
            llvm_struct_ptr_type,
            base_ptr_repr,
            field_index
        ));

        Ok(CompiledValue::Pointer { llvm_repr: gep_result_reg, ptype: field_ptype.clone() })
    }
    fn compile_deref_lvalue(&mut self, operand: &Expr) -> CompileResult<CompiledValue> {
        let pointer_rval = self.compile_rvalue(operand, Expected::Anything)?;
        if !pointer_rval.get_type().is_pointer() {
            return Err(CompileError::Generic(format!("Cannot dereference non-pointer type: {:?}", pointer_rval.get_type())));
        }
        let ptype = pointer_rval.get_type().dereference_once();
        Ok(CompiledValue::Pointer { llvm_repr: pointer_rval.get_llvm_repr(), ptype:ptype.clone() })
    }
    fn compile_index_lvalue(&mut self, array_expr: &Expr, index_expr: &Expr) -> CompileResult<CompiledValue> {
        let array_rval = self.compile_rvalue(array_expr, Expected::Anything)?; 
        if !array_rval.get_type().is_pointer() {
            return Err(CompileError::InvalidExpression(format!("Cannot index non-pointer type {:?}", array_rval.get_type())));
        }

        let index_val = self.compile_rvalue(index_expr, Expected::Type(&ParserType::Named("i64".to_string())))?;
        if !index_val.get_type().is_integer() {
            return Err(CompileError::InvalidExpression(format!("Index must be an integer, but got {:?}", index_val.get_type())));
        }

        let base_type = array_rval.get_type().dereference_once();
        let llvm_base_type = get_llvm_type_str(&base_type, self.ctx.symbols, &self.ctx.current_function_path)?;
        
        let temp_id = self.ctx.aquire_unique_temp_value_counter();
        let gep_ptr_reg = format!("%tmp{}", temp_id);
        
        self.output.push_str(&format!(
            "    {} = getelementptr inbounds {}, {}* {}, {}\n",
            gep_ptr_reg, 
            llvm_base_type, 
            llvm_base_type, 
            array_rval.get_llvm_repr(), 
            index_val.get_llvm_repr_with_type(self.ctx)?
        ));
        Ok(CompiledValue::Pointer { llvm_repr: gep_ptr_reg, ptype: base_type.clone() })
    }
    
    fn sizeof_from_expression(&mut self, expr: &Expr) -> CompileResult<u32>{
        match expr {
            Expr::Name(name) =>{
                let full_name = self.ctx.fully_qualified_name(name);
                if let Ok(x) = self.ctx.symbols.get_type(&full_name) {
                    return Ok(x.get_size_of(self.ctx.symbols)?);
                }
                if let Ok(x) = self.ctx.symbols.get_type(name) {
                    return Ok(x.get_size_of(self.ctx.symbols)?);
                }
            }
            Expr::StaticAccess(x, y) =>{
                let full_name = if let Expr::Name(x) = &**x {
                    format!("{}.{}",x, y)
                }else{
                    panic!("{:?}", x);
                };
                if let Ok(x) = self.ctx.symbols.get_type(&full_name) {
                    return Ok(x.get_size_of(self.ctx.symbols)?);
                }
            }
            Expr::UnaryOp(UnaryOp::Pointer, _) => return Ok(POINTER_SIZE_IN_BYTES),
            _ => {}
        }
        return Err(CompileError::InvalidExpression(format!("Unable to get size of type behind expression: {:?}", expr)));
    }
}

fn get_path_from_expr(expr: &Expr) -> String {
    match expr {
        Expr::Name(n) => n.clone(),
        Expr::StaticAccess(base, member) => format!("{}.{}", get_path_from_expr(base), member),
        _ => panic!("Cannot extract path from {:?}", expr),
    }
}

pub fn constant_integer_expression_compiler(expression: &Expr, symbols: &SymbolTable) -> Result<i128, String> {
    match expression {
        Expr::Integer(x) => Ok(x.parse().expect("Invalid integer literal in const expression")),
        Expr::BinaryOp(l, op, r) => {
            let left_val = constant_integer_expression_compiler(l, symbols)?;
            let right_val = constant_integer_expression_compiler(r, symbols)?;
            match op {
                BinaryOp::BitOr => Ok(left_val | right_val),
                BinaryOp::BitAnd => Ok(left_val & right_val),
                BinaryOp::BitXor => Ok(left_val ^ right_val),
                BinaryOp::Add => Ok(left_val + right_val),
                BinaryOp::Subtract => Ok(left_val - right_val),
                BinaryOp::Multiply => Ok(left_val * right_val),
                BinaryOp::Divide => Ok(left_val / right_val),
                BinaryOp::Modulo => Ok(left_val % right_val),
                _ => Err(format!("Unsupported constant binary operator: {:?}", op)),
            }
        }
        _ => Err(format!("Unsupported constant expression: {:?}", expression)),
    }
}
fn explicit_cast(
    value: &CompiledValue,
    to_type: &ParserType,
    ctx: &mut CodeGenContext,
    output: &mut LLVMOutputHandler,
) -> CompileResult<CompiledValue> {
    let from_type = value.get_type();
    let temp_id = ctx.aquire_unique_temp_value_counter();
    let llvm_repr = format!("%tmp{}", temp_id);

    let instruction = match (from_type, to_type) {
        (ParserType::Named(_), ParserType::Named(_)) => {
            if let Some((from_bits, to_bits)) = from_type.is_both_integers(to_type) {
                if from_bits == to_bits {
                    return Ok(value.clone_with_type(to_type.clone()));
                }
                let op = if from_bits < to_bits {
                    if from_type.is_unsigned_integer() { "zext" } else { "sext" }
                } else {
                    "trunc"
                };
                format!("{} i{} {} to i{}", op, from_bits, value.get_llvm_repr(), to_bits)
            } else {
                return Err(CompileError::Generic(format!("Invalid integer cast from {:?} to {:?}", from_type, to_type)));
            }
        }
        (ParserType::Named(n), ParserType::Pointer(_)) if n.starts_with('i') || n.starts_with('u') => {
            let from_str = value.get_llvm_repr_with_type(ctx)?;
            let to_str = get_llvm_type_str(to_type, ctx.symbols, &ctx.current_function_path)?;
            format!("inttoptr {} to {}", from_str, to_str)
        }
        (ParserType::Pointer(_), ParserType::Named(n)) if n.starts_with('i') || n.starts_with('u') => {
            let from_str = value.get_llvm_repr_with_type(ctx)?;
            let to_str = get_llvm_type_str(to_type, ctx.symbols, &ctx.current_function_path)?;
            format!("ptrtoint {} to {}", from_str, to_str)
        }
        (ParserType::Pointer(_), ParserType::Pointer(_)) => {
            let from_str = value.get_llvm_repr_with_type(ctx)?;
            let to_str = get_llvm_type_str(to_type, ctx.symbols, &ctx.current_function_path)?;
            format!("bitcast {} to {}", from_str, to_str)
        }
        _ => {
            return Err(CompileError::Generic(format!("No explicit cast from {:?} to {:?}", from_type, to_type)));
        }
    };
    
    output.push_str(&format!("    {} = {}\n", llvm_repr, instruction));
    Ok(CompiledValue::Value { llvm_repr, ptype: to_type.clone() })
}