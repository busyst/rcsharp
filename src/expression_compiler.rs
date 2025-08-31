use crate::{compiler::{get_llvm_type_str, CodeGenContext, CompileError, CompileResult, LLVMOutputHandler, SymbolTable, POINTER_SIZE_IN_BYTES}, expression_parser::{BinaryOp, Expr, UnaryOp}, parser::ParserType};
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
        ftype: ParserType,
    },
    NoReturn,
}
impl CompiledValue {
    pub fn get_type(&self) -> &ParserType {
        match self {
            Self::Value { ptype, .. } => ptype,
            Self::Pointer { ptype, .. } => ptype,
            Self::Function { ftype, .. } => ftype,
            Self::NoReturn => panic!("Cannot get type of NoReturn value"),
        }
    }
    pub fn get_llvm_repr(&self) -> String {
        match self {
            Self::Value { llvm_repr, .. } => llvm_repr.to_string(),
            Self::Pointer { llvm_repr, .. } => llvm_repr.to_string(),
            Self::Function { effective_name, .. } => format!("@{}", effective_name),
            Self::NoReturn => panic!("Cannot get LLVM representation of NoReturn value"),
        }
    }
    pub fn get_llvm_repr_with_type(&self, ctx: &CodeGenContext) -> CompileResult<String> {
        let type_str = get_llvm_type_str(self.get_type(), ctx.symbols, &ctx.current_function_path)?;
        match self {
            CompiledValue::Function {..} => Ok(format!("{} @{}", type_str, self.get_llvm_repr())),
            CompiledValue::Pointer {..} => Ok(format!("{}* {}", type_str, self.get_llvm_repr())),
            _ => Ok(format!("{} {}", type_str, self.get_llvm_repr()))
        }
    }
    pub fn with_type(&self, new_type: ParserType) -> CompiledValue {
        match self {
            CompiledValue::Value { llvm_repr, .. } => CompiledValue::Value { llvm_repr: llvm_repr.clone(), ptype: new_type },
            CompiledValue::Pointer { llvm_repr, .. } => CompiledValue::Pointer { llvm_repr: llvm_repr.clone(), ptype: new_type },
            CompiledValue::Function { effective_name, ..} => CompiledValue::Function { effective_name: effective_name.clone(), ftype: new_type },
            _ => panic!("with_type is not applicable to {:?}, tried to apply {:?}", self, new_type),
        }
    }
    pub fn is_literal_number(&self) -> bool{
        match self {
            CompiledValue::NoReturn => unreachable!(),
            CompiledValue::Function { effective_name:_, ftype:_ } => unreachable!(),
            CompiledValue::Pointer { llvm_repr:_, ptype:_ } => unreachable!(),
            CompiledValue::Value { llvm_repr, ptype:_ } => llvm_repr.chars().next().map(|x| x.is_ascii_digit()).unwrap_or(false),
        }
    }
    pub fn literal_llvm_repr(&self) -> &str{
        match self {
            CompiledValue::NoReturn => unreachable!(),
            CompiledValue::Function { effective_name:_, ftype:_ } => unreachable!(),
            CompiledValue::Pointer { llvm_repr, ptype:_ } => return llvm_repr,
            CompiledValue::Value { llvm_repr, ptype:_ } => return llvm_repr,
        }
    }
}

pub fn compile_expression(expr: &Expr, expected: Expected, ctx: &mut CodeGenContext, output: &mut LLVMOutputHandler) -> CompileResult<CompiledValue> {
    let mut compiler = ExpressionCompiler { ctx, output };
    let value = compiler.compile_rvalue(expr, expected)?;
    Ok(value)
}
struct ExpressionCompiler<'a, 'b> {
    ctx: &'a mut CodeGenContext<'b>,
    output: &'a mut LLVMOutputHandler,
}
impl<'a, 'b> ExpressionCompiler<'a, 'b> {
    fn compile_rvalue(&mut self, expr: &Expr, expected: Expected) -> CompileResult<CompiledValue> {
        match expr {
            Expr::Name(name) =>{ // ---
                debug_assert!(expected != Expected::NoReturn);
                if let Ok(variable) = self.ctx.scope.get_variable(name) { // Local or (potentialy) static/constant variable
                    let var_type = variable.get_type(false, false);
                    if variable.is_argument() {
                        return Ok(CompiledValue::Value {
                            llvm_repr: format!("%{}", name),
                            ptype: variable.compiler_type.clone(),
                        });
                    }
                    
                    let var_representation = get_llvm_type_str(&var_type, self.ctx.symbols, &self.ctx.current_function_path)?;
                    let utvc = self.ctx.aquire_unique_temp_value_counter();
                    self.output.push_str(&format!("    %tmp{} = load {}, {}* %{}\n", utvc, var_representation, var_representation, name));

                    return Ok(CompiledValue::Value {
                        llvm_repr: format!("%tmp{}", utvc),
                        ptype: variable.compiler_type.clone(),
                    });
                }
                if let Ok(function) = self.ctx.symbols.get_function(name, &self.ctx.current_function_path) {
                    return Ok(CompiledValue::Function {
                        effective_name: function.effective_name(),
                        ftype: function.get_type()
                    });
                }
                return Err(CompileError::SymbolNotFound(format!("Symbol '{}' was not found in current namespace '{}'", name, self.ctx.current_function_path)));
            }
            Expr::Integer(num) =>{ // ---
                debug_assert!(expected != Expected::NoReturn);
                if let Expected::Type(x) = expected {
                    if x.is_integer() {
                        return Ok(CompiledValue::Value {llvm_repr: num.clone(), ptype: x.clone()});
                    }
                    if x.is_bool() {
                        let llvm_repr = if num != "0" { format!("1") } else { format!("0") };
                        return Ok(CompiledValue::Value {llvm_repr, ptype: x.clone()});
                    }
                    if x.is_pointer() && num == "0" {
                        return Ok(CompiledValue::Value {llvm_repr: format!("null"), ptype: x.clone()});
                    }
                }
                return Ok(CompiledValue::Value {llvm_repr: num.clone(), ptype: ParserType::Named(format!("i64"))});
            }
            
            Expr::Assign(lhs, rhs) => { // --
                let l = self.compile_lvalue(&lhs)?;
                debug_assert_ne!(l, CompiledValue::NoReturn);
                if !matches!(l, CompiledValue::Pointer { llvm_repr: _, ptype: _ }) {
                    return CompileResult::Err(CompileError::InvalidExpression(format!("{:?} does not give pointer to value as a result", lhs)));
                }
                let r = self.compile_rvalue(&rhs, Expected::Type(l.get_type()))?;
                debug_assert_ne!(r, CompiledValue::NoReturn);
                if l.get_type() != r.get_type() {
                    return CompileResult::Err(CompileError::InvalidExpression(format!("{:?} type missmatch with left side {:?}", rhs, l)));
                }
                self.output.push_str(&format!("    store {}, {}\n", r.get_llvm_repr_with_type(self.ctx)?, l.get_llvm_repr_with_type(self.ctx)?));
                if matches!(expected, Expected::NoReturn) {
                    return Ok(CompiledValue::NoReturn);
                }
                return Ok(r);
            }

            Expr::Call(callee, given_args) =>{ // ---
                if let Some(x) = self.compiler_function_calls(&callee, given_args, expected) {
                    return x;
                }
                let l: CompiledValue = self.compile_lvalue(callee)?;
                if let CompiledValue::Function { effective_name, ftype: ParserType::Function(return_type, required_arguments)} = &l {
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
                    let func = self.ctx.symbols.get_function(&effective_name, &self.ctx.current_function_path)?;
                    let arg_string = compiled_arguments.join(", ");
                    if return_type.is_void() {
                        self.output.push_str(&format!("    call void @{}({})\n", func.get_llvm_repr(), arg_string));
                        return Ok(CompiledValue::NoReturn);
                    }

                    let utvc = self.ctx.aquire_unique_temp_value_counter();
                    let return_type_repr = get_llvm_type_str(&return_type, self.ctx.symbols, &func.path)?;
                    self.output.push_str(&format!("    %tmp{} = call {} @{}({})\n", utvc, return_type_repr, func.get_llvm_repr(), arg_string));
                    return Ok(CompiledValue::Value { llvm_repr: format!("%tmp{}", utvc), ptype: *return_type.clone() });
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
                return Err(CompileError::Generic(format!("Left hand side expression is not function call")));
            }
            
            Expr::MemberAccess(..) =>{ // --- 
                debug_assert!(expected != Expected::NoReturn);
                let member_lvalue = self.compile_lvalue(expr)?;
                let utvc = self.ctx.aquire_unique_temp_value_counter();
                let member_type = get_llvm_type_str(&member_lvalue.get_type(), self.ctx.symbols, &self.ctx.current_function_path)?;
                self.output.push_str(&format!("    %tmp{} = load {}, {}* {}\n",utvc, member_type, member_type, member_lvalue.get_llvm_repr()));
                Ok(CompiledValue::Value { llvm_repr: format!("%tmp{}", utvc), ptype: member_lvalue.get_type().clone() })
            }
            
            Expr::Cast(lhe, rht) =>{ // ---
                debug_assert!(expected != Expected::NoReturn);
                let result = self.compile_rvalue(lhe, Expected::Type(rht))?;
                if result.get_type() == rht {
                    return Ok(result);
                }
                return explicit_cast(&result, rht, self.ctx, self.output);
            }

            Expr::BinaryOp(lhs, op, rhs) =>{ // ---
                debug_assert!(expected != Expected::NoReturn);
                let mut l = self.compile_rvalue(&lhs, Expected::Anything)?;
                debug_assert!(l != CompiledValue::NoReturn);
                let mut r = self.compile_rvalue(&rhs, Expected::Type(l.get_type()))?;
                debug_assert!(r != CompiledValue::NoReturn);
                // Swap them
                if l.is_literal_number() && !r.is_literal_number() && (matches!(op, BinaryOp::Add | BinaryOp::Multiply | BinaryOp::BitAnd | BinaryOp::BitOr | BinaryOp::BitXor | BinaryOp::And | BinaryOp::Or | BinaryOp::Equals)) {
                    (r, l) = (l, r);
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
            
            Expr::UnaryOp(op, lht) =>{ // ---
                match op {
                    UnaryOp::Deref =>{
                        let value = self.compile_rvalue(lht, expected)?;
                        debug_assert!(value != CompiledValue::NoReturn);
                        if !value.get_type().is_pointer() {
                            return Err(CompileError::Generic(format!("Tried to dereference non pointer value {:?}", &value)));
                        }
                        let value_deref_type = value.get_type().dereference_once();
                        let underlying_type_representation= get_llvm_type_str(&value_deref_type, self.ctx.symbols, &self.ctx.current_function_path)?;
                        let utvc = self.ctx.aquire_unique_temp_value_counter();
                        self.output.push_str(&format!("    %tmp{} = load {}, {}* {}\n",utvc, underlying_type_representation, underlying_type_representation, value.get_llvm_repr()));
                        return Ok(CompiledValue::Value { llvm_repr: format!("%tmp{}", utvc), ptype: value_deref_type });
                    }
                    UnaryOp::Pointer => {
                        let value = self.compile_lvalue(&lht)?;
                        debug_assert!(value != CompiledValue::NoReturn);
                        let referenced_type = value.get_type().reference_once();
                        return Ok(CompiledValue::Value { llvm_repr: value.get_llvm_repr().to_string(), ptype: referenced_type });
                    }
                    UnaryOp::Negate =>{
                        let value = self.compile_rvalue(lht, expected)?;
                        debug_assert!(value != CompiledValue::NoReturn);
                        if !value.get_type().is_integer() {
                            return Err(CompileError::Generic(format!("Cannot negate non integer type")));
                        }
                        if value.is_literal_number() {
                            return Ok(CompiledValue::Value { llvm_repr: (-value.literal_llvm_repr().parse::<i128>().unwrap()).to_string(), ptype: value.get_type().clone() });
                        }
                        let repr = get_llvm_type_str(value.get_type(), self.ctx.symbols, &self.ctx.current_function_name)?;
                        let utvc =self.ctx.aquire_unique_temp_value_counter();
                        self.output.push_str(&format!("    %tmp{} = sub {} 0, {}", utvc, repr, value.get_llvm_repr()));
                        return Ok(CompiledValue::Value { llvm_repr: format!("%tmp{}", utvc), ptype: value.get_type().clone() });
                    }
                    UnaryOp::Not =>{
                        let value = self.compile_rvalue(lht, Expected::Anything)?;
                        debug_assert!(value != CompiledValue::NoReturn);
                        /*if value.get_type().is_integer() {
                            //    let llvm_type = state.get_llvm_representation_from_parser_type(&value.get_type())?;
                            //    state.output.push_str(&format!("    %tmp{} = icmp eq {} {}, 0\n", utvc, llvm_type, value.to_repr()));
                            //    return Ok(CompiledValue::TempValue(utvc, ParserType::Named("bool".to_string())));
                            
                        }*/
                        if !value.get_type().is_bool() {
                            return Err(CompileError::InvalidExpression(format!("Tried to use NOT operation on non-boolean:\n{:?}",lht)));
                        }
                        let utvc = self.ctx.aquire_unique_temp_value_counter();
                        self.output.push_str(&format!("    %tmp{} = xor i1 {}, 1\n", utvc, value.get_llvm_repr()));
                        return Ok(CompiledValue::Value { llvm_repr: format!("%tmp{}", utvc), ptype: value.get_type().clone() });
                    }
                }
            }
            
            Expr::StaticAccess(_, y) => { // ---
                let path = self.get_path_from_expr(expr);
                if let Ok(variable) = self.ctx.scope.get_variable(&path) {
                    return Ok(CompiledValue::Pointer {
                        llvm_repr: format!("%{}", &path),
                        ptype: variable.compiler_type.clone(),
                    });
                }
                if let Ok(function) = self.ctx.symbols.get_function(&path, &self.ctx.current_function_path) {
                    return Ok(CompiledValue::Function {
                        effective_name: function.effective_name(),
                        ftype: function.get_type()
                    });
                }
                let enum_path = self.get_enum_from_expr(expr);
                if let Some(r#enum) = self.ctx.symbols.enums.get(&enum_path) {
                    return Ok(CompiledValue::Value {
                        llvm_repr: format!("{}", r#enum.fields.iter().find(|x| x.0 == *y).unwrap().1),
                        ptype: r#enum.base_type.clone()
                    });
                }
                return Err(CompileError::SymbolNotFound(format!("Symbol with path '{}' was not found", path)));
            }
            Expr::StringConst(str_val) => self.compile_string_literal(str_val),
            Expr::Index(_, _) =>{
                let result = self.compile_lvalue(expr)?;
                let llvm_array_type = get_llvm_type_str(result.get_type(), self.ctx.symbols, &self.ctx.current_function_path)?;
                let r_utvc = self.ctx.aquire_unique_temp_value_counter();
                self.output.push_str(&format!("    %tmp{} = load {}, {}\n",r_utvc, llvm_array_type, result.get_llvm_repr_with_type(self.ctx)?));
                return Ok(CompiledValue::Value { llvm_repr: format!("%tmp{}", r_utvc), ptype: result.get_type().clone() });
            }
        }
    }
    fn compile_lvalue(&mut self, expr: &Expr) -> CompileResult<CompiledValue> {
        match expr {
            Expr::Name(name) =>{ // ---
                if let Ok(variable) = self.ctx.scope.get_variable(name) {
                    return Ok(CompiledValue::Pointer {
                        llvm_repr: format!("%{}", name),
                        ptype: variable.compiler_type.clone(),
                    });
                }
                if let Ok(function) = self.ctx.symbols.get_function(&name, &self.ctx.current_function_path) {
                    return Ok(CompiledValue::Function {
                        effective_name: function.effective_name(),
                        ftype: function.get_type()
                    });
                }
                return Err(CompileError::SymbolNotFound(format!("Unable to find '{name}' as a lvalue in current context")));
            }
            
            Expr::StaticAccess(_, _) => { // ---
                let path = self.get_path_from_expr(expr);
                if let Ok(variable) = self.ctx.scope.get_variable(&path) {
                    return Ok(CompiledValue::Pointer {
                        llvm_repr: format!("%{}", &path),
                        ptype: variable.compiler_type.clone(),
                    });
                }

                if let Ok(function) = self.ctx.symbols.get_function(&path, &self.ctx.current_function_path) {
                    return Ok(CompiledValue::Function {
                        effective_name: function.effective_name(),
                        ftype: function.get_type()
                    });
                }
                return Err(CompileError::SymbolNotFound(format!("Path '{}' was found not leading to any symbol in current context", path)));
            }
            
            Expr::MemberAccess(obj, member) => { // ---
                let base_lval = self.compile_lvalue(obj)?;
                debug_assert!(base_lval != CompiledValue::NoReturn);
                let struct_type = base_lval.get_type().dereference_full();

                let (struct_fqn, fields) = self.ctx.symbols.get_struct_representation(&struct_type, &self.ctx.current_function_path)?;

                let field_index = fields.iter().position(|(name, _)| name == member)
                    .ok_or_else(|| CompileError::Generic(format!("Member '{}' not found in struct '{}'", member, struct_fqn)))?;

                let field_ptype = &fields[field_index].1;
                let llvm_struct_type = get_llvm_type_str(&struct_type, self.ctx.symbols, &self.ctx.current_function_path)?;

                let gep_ptr_reg = format!("%tmp{}", self.ctx.aquire_unique_temp_value_counter());
                
                self.output.push_str(&format!("    {} = getelementptr inbounds {}, {}* {}, i32 0, i32 {}\n",
                    gep_ptr_reg, llvm_struct_type, llvm_struct_type, base_lval.get_llvm_repr(), field_index
                ));

                Ok(CompiledValue::Pointer { llvm_repr: gep_ptr_reg, ptype: field_ptype.clone() })
            }
            
            Expr::UnaryOp(op, lht) =>{ // ---
                match op {
                    UnaryOp::Deref =>{
                        let pointer_rval = self.compile_rvalue(lht, Expected::Anything)?;
                        debug_assert!(pointer_rval != CompiledValue::NoReturn);

                        if !pointer_rval.get_type().is_pointer() {
                            return Err(CompileError::Generic(format!("Cannot dereference a non-pointer type: {:?} for expression {:?}", pointer_rval.get_type(), expr)));
                        }
                        
                        let lvalue_type = pointer_rval.get_type().dereference_once();
                        return Ok(CompiledValue::Pointer { 
                            llvm_repr: pointer_rval.get_llvm_repr(), 
                            ptype: lvalue_type 
                        });
                    }
                    _ => return Err(CompileError::Generic(format!("UnaryOp {:?} not defined for lvalue expression: {:?}", op, expr)))
                }
            }
            
            Expr::BinaryOp(_, _, _) => {self.compile_rvalue(expr, Expected::Anything)}
            Expr::Index(indexee, index_expr) =>{
                let l = self.compile_rvalue(indexee, Expected::Anything)?;
                debug_assert!(l != CompiledValue::NoReturn);
                if !l.get_type().is_pointer() {
                    return Err(CompileError::InvalidExpression(format!("Cannot apply indexing operator `[]` to type '{:?}'", l.get_type())));
                }
                let r = self.compile_rvalue(index_expr, Expected::Type(&ParserType::Named(format!("i64"))))?;
                debug_assert!(r != CompiledValue::NoReturn);
                if !r.get_type().is_integer() {
                    return Err(CompileError::InvalidExpression(format!("Index expression must evaluate to an integer, but got '{:?}'", r.get_type())));
                }
                let base_type = l.get_type().dereference_once();

                let llvm_array_type = get_llvm_type_str(&base_type, self.ctx.symbols, &self.ctx.current_function_path)?;
                let size_of_l_item = self.sizeof_from_type(&base_type)?;
                let r_scaled = self.ctx.aquire_unique_temp_value_counter();
                self.output.push_str(&format!("    %tmp{} = mul {}, {}", r_scaled ,r.get_llvm_repr_with_type(self.ctx)?, size_of_l_item));
                let gep_ptr_reg = self.ctx.aquire_unique_temp_value_counter();
                self.output.push_str(&format!(
                    "    %tmp{} = getelementptr inbounds {}, {}* {}, {}\n",
                    gep_ptr_reg,
                    llvm_array_type,
                    llvm_array_type,
                    l.get_llvm_repr(),
                    CompiledValue::Value { llvm_repr: format!("%tmp{}", r_scaled), ptype: r.get_type().clone() }.get_llvm_repr_with_type(self.ctx)?
                ));
                return Ok(CompiledValue::Pointer { llvm_repr: format!("%tmp{}", gep_ptr_reg), ptype: base_type });
            }
            _ => Err(CompileError::Generic(format!("Expression {:?} is not a valid lvalue", expr))),
        }
    }
    fn compile_string_literal(&mut self, str_val: &str) -> CompileResult<CompiledValue> { // ---
        let str_len = str_val.len() + 1;
        let const_id = self.ctx.aquire_unique_const_vector_counter();
        let const_name = format!("@.str.{}", const_id);

        self.output.push_str_header(&format!(
            "{} = private unnamed_addr constant [{} x i8] c\"{}\\00\"\n",
            const_name, str_len, str_val.replace("\"", "\\22")
        ));
        let ptr_reg = self.ctx.aquire_unique_temp_value_counter();
        self.output.push_str(&format!(
            "    %tmp{} = getelementptr inbounds [{} x i8], [{} x i8]* {}, i64 0, i64 0\n",
            ptr_reg, str_len, str_len, const_name
        ));
        Ok(CompiledValue::Value {
            llvm_repr: format!("%tmp{}", ptr_reg),
            ptype: ParserType::Pointer(Box::new(ParserType::Named("i8".to_string()))),
        })
    }
    fn compiler_function_calls(&mut self, callee: &Box<Expr>, given_args: &Box<[Expr]>, expected: Expected) -> Option<CompileResult<CompiledValue>>{ // --

        if let Expr::Name(x) = &**callee {
            match x.as_str() {
                "sizeof" =>{
                    debug_assert!(expected != Expected::NoReturn);
                    if given_args.len() != 1 { return Some(Err(CompileError::Generic(format!("sizeof expects exactly 1 type argument. Example: sizeof(i32);"))));}
                    if let Ok(sizeof) = self.sizeof_from_expression(&given_args[0]){
                        if let Expected::Type(pt) = expected {
                            if pt.is_integer() {
                                return Some(Ok(CompiledValue::Value { llvm_repr: sizeof.to_string(), ptype: pt.clone() }));
                            }
                        }
                        return Some(Ok(CompiledValue::Value { llvm_repr: sizeof.to_string(), ptype: ParserType::Named(format!("i64")) }));
                    }
                    return Some(Err(CompileError::Generic(format!("Unable to calculate sizeof structure given by this expression '{:?}'", given_args[0]))));
                }
                "stalloc" =>{
                    debug_assert!(expected != Expected::NoReturn);
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
    fn sizeof_from_type(&mut self, parser_type: &ParserType) -> CompileResult<u32>{
        match parser_type {
            ParserType::Pointer(..) => return Ok(POINTER_SIZE_IN_BYTES),
            ParserType::Function(..) => return Err(CompileError::Generic(format!(""))),
            ParserType::Named(name) => {
                match name.as_str() {
                    "i8" | "u8" => return Ok(1),
                    "i16" | "u16" => return Ok(2),
                    "i32" | "u32" => return Ok(4),
                    "i64" | "u64" => return Ok(8),
                    _ => {}
                }
                let x = self.ctx.symbols.get_type(&self.ctx.fully_qualified_name(name))?;
                return x.get_size_of(self.ctx.symbols);
            }
            ParserType::NamespaceLink(..) => {
                let path = parser_type.get_absolute_path_or(&self.ctx.current_function_path);
                let x = self.ctx.symbols.get_type(&path)?;
                return x.get_size_of(self.ctx.symbols);
            }
        }
    }
    
    fn get_path_from_expr(&self, expr: &Expr) -> String{
        if let Expr::StaticAccess(x, y) = expr {
            let nx = self.get_path_from_expr(x);
            return format!("{}.{}", nx, y);
        }
        if let Expr::Name(n) = expr {
            return n.clone();
        }
        panic!("{:?}", expr)
    }
    fn get_enum_from_expr(&self, expr: &Expr) -> String{
        if let Expr::StaticAccess(x, _) = expr {
            if self.ctx.current_function_path.is_empty() {
                return self.get_path_from_expr(x);
            }else {
                return format!("{}.{}", self.ctx.current_function_path, self.get_path_from_expr(x));
            }
        }
        if let Expr::Name(n) = expr {
            return n.clone();
        }
        panic!("{:?}", expr)
    }
}

pub fn constant_integer_expression_compiler(expression: &Expr, symbols: &SymbolTable) -> Result<i128, String>{
    match expression {
        Expr::Integer(x) => Ok(x.parse::<i128>().unwrap()),
        Expr::BinaryOp(l, op, r) =>{
            let lv = constant_integer_expression_compiler(&l, symbols)?;
            let rv = constant_integer_expression_compiler(&r, symbols)?;
            match op {
                BinaryOp::BitOr => {
                    return Ok(lv | rv);
                }
                _ => panic!("{:?}",op)
            }
        }
        
        _ => Err(format!("\ndfghfghfgdhfd{:?}", expression))
    }
}

pub fn explicit_cast(value: &CompiledValue, to: &ParserType, ctx: &mut CodeGenContext, output: &mut LLVMOutputHandler) -> CompileResult<CompiledValue>{
    debug_assert!(*value != CompiledValue::NoReturn);
    let ltype = value.get_type();
    match (&ltype, to) {
        (ParserType::Named(_), ParserType::Named(_)) => {
            if let Some((ln, rn)) = ltype.is_both_integers(to) {
                if ln == rn {
                    return Ok(value.with_type(to.clone()));
                }
                let utvc = ctx.aquire_unique_temp_value_counter();
                if ltype.is_unsigned_integer() {
                    if ln < rn {
                        output.push_str(&format!("    %tmp{} = zext i{} {} to i{}\n", utvc, ln, value.get_llvm_repr(),  rn));
                    }else {
                        output.push_str(&format!("    %tmp{} = trunc i{} {} to i{}\n", utvc, ln, value.get_llvm_repr(),  rn));
                    }
                }else {
                    if ln < rn {
                        output.push_str(&format!("    %tmp{} = sext i{} {} to i{}\n", utvc, ln, value.get_llvm_repr(), rn));
                    }else {
                        output.push_str(&format!("    %tmp{} = trunc i{} {} to i{}\n", utvc, ln, value.get_llvm_repr(), rn));
                    }
                }
                return Ok(CompiledValue::Value { llvm_repr: format!("%tmp{}",utvc), ptype: to.clone()});
            }
            return Err(CompileError::Generic(format!("No explicit cast exists from type \"{:?}\" to \"{:?}\".", value, to)));
        }
        (ParserType::Named(_),ParserType::Pointer(_)) => {
            if !ltype.is_integer() {
                return Err(CompileError::Generic(format!("Cannot convert from non-integer type to pointer")));
            }
            let utvc = ctx.aquire_unique_temp_value_counter();
            output.push_str(&format!("    %tmp{} = inttoptr {} to {}\n",utvc, value.get_llvm_repr_with_type(ctx)?, get_llvm_type_str(to, ctx.symbols, &ctx.current_function_path)?));
            return CompileResult::Ok(CompiledValue::Value { llvm_repr: format!("%tmp{}",utvc), ptype: to.clone()});
        }
        (ParserType::Pointer(_),ParserType::Named(_)) => {
            if !to.is_integer() { 
                return Err(CompileError::Generic(format!("Cannot convert from pointer to non-integer type '{}'", to.to_string())));
            }
            let utvc = ctx.aquire_unique_temp_value_counter();
            output.push_str(&format!("    %tmp{} = ptrtoint {} to {}\n",utvc, value.get_llvm_repr_with_type(ctx)?, get_llvm_type_str(to, ctx.symbols, &ctx.current_function_path)?));
            return CompileResult::Ok(CompiledValue::Value { llvm_repr: format!("%tmp{}",utvc), ptype: to.clone()});
        }
        (ParserType::Pointer(_),ParserType::Pointer(_)) => {
            let utvc = ctx.aquire_unique_temp_value_counter();
            output.push_str(&format!("    %tmp{} = bitcast {} to {}\n",utvc, value.get_llvm_repr_with_type(ctx)?, get_llvm_type_str(to, ctx.symbols, &ctx.current_function_path)?));
            return CompileResult::Ok(CompiledValue::Value { llvm_repr: format!("%tmp{}",utvc), ptype: to.clone()});
        }
        
        _ => {unreachable!()}
    }
}
