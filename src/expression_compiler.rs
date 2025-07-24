use crate::{compiler::CompilerState, expression_parser::{BinaryOp, Expr, UnaryOp}, parser::{ParserType, Stmt}};
#[derive(Debug, Clone)]
pub struct CompiledTempValue{pub index:usize, pub value_type: ParserType}
pub fn type_from_expression(x: &Expr) -> Result<ParserType, String>{
    match x {
        Expr::Name(n) => return Ok(ParserType::Named(n.clone())),
        _ => todo!("{:?}",x)
    }
} 
pub fn explicit_cast(value: &CompiledTempValue, to: &ParserType, state: &mut CompilerState) -> Result<CompiledTempValue, String>{
    let ltype = state.get_compiler_type_from_parser(&value.value_type)?;
    let rtype = state.get_compiler_type_from_parser(&to)?;
    let ltype_true_string = ltype.underlying_representation.to_string();
    let rtype_true_string = rtype.underlying_representation.to_string();
    match (&value.value_type, to) {
        (ParserType::Named(_), ParserType::Named(_)) => {
            let utvc = state.aquire_unique_temp_value_counter();
            if let Some(ltype) = state.implemented_types.get(&value.value_type.to_string_core()) {
                if !state.implemented_types.contains_key(&to.to_string_core()) {
                    return Err(format!("Type \"{:?}\" was not found among implemented types",to));
                }
                if let Some(cast_statement) = ltype.explicit_casts.get(&to.to_string_core()) {
                    match cast_statement {
                        Stmt::DirectInsertion(x) =>{
                            let result = x.replace("{o}", &utvc.to_string())
                            .replace("{v}", &value.index.to_string());
                            state.output.push_str(&result);
                            //println!("{:?}", to);
                            return Ok(CompiledTempValue { index: utvc, value_type: to.clone() });
                        }
                        _ => todo!(),
                    }
                };
                return Err(format!("No explicit cast exists from type \"{:?}\" to \"{:?}\".", value.value_type, to));
            }
            return Err(format!("Cannot cast from unknown type \"{:?}\" to {:?}", value.value_type, to));
        }
        (ParserType::Named(_),ParserType::Ref(_)) => {
            if !ltype.parser_type.is_integer() {
                return Err(format!("Cannot convert from non-integer type to pointer"));
            }
            let utvc = state.aquire_unique_temp_value_counter();
            state.output.push_str(&format!("    %tmp{} = inttoptr {} %tmp{} to {}\n",utvc, ltype_true_string, value.index.to_string(), rtype_true_string));
            return Ok(CompiledTempValue { index: utvc, value_type: to.clone() });
        }
        (ParserType::Ref(_),ParserType::Named(_)) => {
            if !ltype.parser_type.is_integer() {
                return Err(format!("Cannot convert from pointer to non-integer type"));
            }
            let utvc = state.aquire_unique_temp_value_counter();
            state.output.push_str(&format!("    %tmp{} = ptrtoint {} %tmp{} to {}\n",utvc, ltype_true_string, value.index.to_string(), rtype_true_string));
            return Ok(CompiledTempValue { index: utvc, value_type: to.clone() });
        }
        (ParserType::Ref(_),ParserType::Ref(_)) => {
            let utvc = state.aquire_unique_temp_value_counter();
            state.output.push_str(&format!("    %tmp{} = bitcast {} %tmp{} to {}\n",utvc, ltype_true_string, value.index, rtype_true_string));
            return Ok(CompiledTempValue { index: utvc, value_type: to.clone() });
        }
        _ => {todo!()}
    }
}
pub fn implisit_cast(value: &CompiledTempValue, to: &ParserType, _state: &mut CompilerState) -> Result<CompiledTempValue, String>{
    match (&value.value_type, to) {
        _ => return Err(format!("Unable to implisitly cast from \"{:?}\" to \"{:?}\"", &value.value_type, to))
    }
}
pub fn compile_rvalue(right: &Expr, expected_type: Option<&ParserType>, state: &mut CompilerState) -> Result<CompiledTempValue, String>{
    match right {
        Expr::Integer(num) =>{
            let utvc = state.aquire_unique_temp_value_counter();
            if let Some(x) = expected_type {
                if x.is_integer() {
                    let q = state.get_compiler_type_from_parser(x).unwrap();
                    state.output.push_str(&format!("    %tmp{} = add {} {}, 0\n", utvc, q.underlying_representation.to_string(), num));
                    return Ok(CompiledTempValue{index: utvc, value_type: x.clone()});
                }
            }
            state.output.push_str(&format!("    %tmp{} = add i64 {}, 0\n", utvc, num));
            return Ok(CompiledTempValue{index: utvc, value_type: ParserType::Named(format!("i64"))});
        }
        Expr::Name(name) =>{
            let utvc = state.aquire_unique_temp_value_counter();
            if let Ok(var) = state.get_variable_type(&name) {
                let var_actual_type = var.parser_type.clone();
                let var_repr_type = var.underlying_representation.clone();

                state.output.push_str(&format!("    %tmp{} = load {}, {}* %{}\n", utvc, var_repr_type.to_string(), var_repr_type.to_string(), name));
                return Ok(CompiledTempValue{index: utvc, value_type: var_actual_type.clone()});   
            }
            if let Ok(var) = state.get_argument_type(&name) {
                let var_actual_type = var.parser_type.clone();
                let var_repr_type = var.underlying_representation.clone();

                state.output.push_str(&format!("    %tmp{} = load {}, {}* %{}.addr\n", utvc, var_repr_type.to_string(), var_repr_type.to_string(), name));
                return Ok(CompiledTempValue{index: utvc, value_type: var_actual_type.clone()});   
            }
            return Err(format!("Variable {} was not found un current context", name));
        }
        Expr::Cast(expression, desired_type) =>{
            let result = compile_rvalue(expression, Some(desired_type), state)?;
            if result.value_type == *desired_type {
                return Ok(result);
            }
            return explicit_cast(&result, desired_type, state);
        }
        Expr::BinaryOp(left, op, right) => {
            let l = compile_rvalue(&left, None, state)?;
            let mut r = compile_rvalue(&right, None, state)?;
            if l.value_type.is_integer() && r.value_type.is_integer() && l.value_type != r.value_type {
                r = implisit_cast(&r, &l.value_type, state)?;
            }
            if l.value_type != r.value_type {
                return Err(format!("Binary operator '{:?}' cannot be applied to mismatched types '{}' and '{}'",op,l.value_type.to_string(),r.value_type.to_string()));
            }
            if l.value_type == r.value_type {
                if l.value_type.is_integer() {

                    let utvc = state.aquire_unique_temp_value_counter();
                    let llvm_type = state.get_compiler_type_from_parser(&l.value_type)?.underlying_representation.to_string();
                    
                    let is_signed = l.value_type.is_signed_integer();

                    let llvm_op = match op {
                        BinaryOp::Add => "add",
                        BinaryOp::Subtract => "sub",
                        BinaryOp::Multiply => "mul",
                        BinaryOp::Divide => if is_signed { "sdiv" } else { "udiv" },
                        BinaryOp::Modulo => if is_signed { "srem" } else { "urem" },

                        BinaryOp::Equal => "icmp eq",
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

                    state.output.push_str(&format!("    %tmp{} = {} {} %tmp{}, %tmp{}\n",utvc, llvm_op, llvm_type, l.index, r.index));
                    let result_type = if llvm_op.starts_with("icmp") {
                        ParserType::Named("bool".to_string())
                    } else {
                        l.value_type.clone()
                    };
                    return Ok(CompiledTempValue { index: utvc, value_type: result_type });
                }
                return Err(format!("Binary operator \"{:?}\" was not implemted for types \"{}\"", op, l.value_type.to_string()));
            }
            return Err(format!("Binary operator \"{:?}\" cannot be applied to types \"{}\" and \"{}\"",op, l.value_type.to_string(), r.value_type.to_string()));
        }
        Expr::UnaryOp(op, expr) =>{
            match op {
                UnaryOp::Not => {
                    let value = compile_rvalue(expr, None, state)?;
                    let utvc = state.aquire_unique_temp_value_counter();
                    if value.value_type.to_string() == "bool" {
                        state.output.push_str(&format!("    %tmp{} = xor i1 %tmp{}, 1\n", utvc, value.index));
                        return Ok(CompiledTempValue { index: utvc, value_type: value.value_type });
                    }
                    if value.value_type.is_integer() {
                    let llvm_type = state.get_compiler_type_from_parser(&value.value_type)?.underlying_representation.to_string();
                        state.output.push_str(&format!("    %tmp{} = xor {} %tmp{}, -1\n",utvc, llvm_type, value.index));
                        return Ok(CompiledTempValue { index: utvc, value_type: value.value_type });
                    }
                    return Err(format!("Unary NOT '!' operator cannot be applied to type '{}'.",value.value_type.to_string()));
                }
                UnaryOp::Negate => {
                    let value = compile_rvalue(expr, None, state)?;
                    let utvc = state.aquire_unique_temp_value_counter();
                    if value.value_type.is_signed_integer() {
                        let llvm_type = state.get_compiler_type_from_parser(&value.value_type)?.underlying_representation.to_string();
                        // In LLVM, integer negation is performed by subtracting from 0.
                        state.output.push_str(&format!( "    %tmp{} = sub {} 0, %tmp{}\n",utvc, llvm_type, value.index));
                        return Ok(CompiledTempValue { index: utvc, value_type: value.value_type });
                    }
                    if value.value_type.is_unsigned_integer() {
                        return Err(format!("Unary negation '-' cannot be applied to unsigned integer type '{}'. Cast to a signed integer first.",value.value_type.to_string()));
                    }
                    return Err(format!("Unary negation '-' cannot be applied to type '{}'.",value.value_type.to_string()));
                }
                UnaryOp::Deref =>{
                    let value = compile_rvalue(expr, expected_type, state)?;
                    let value_type = &value.value_type;
                    if !value_type.is_pointer() {
                        return Err(format!("Tried to dereference non pointer value {:?}", &value));
                    }
                    let value_deref_type = value.value_type.dereference_once();
                    let underlying_type_representation= state.get_compiler_type_from_parser(&value_deref_type)?.underlying_representation.to_string();
                    let utvc = state.aquire_unique_temp_value_counter();
                    state.output.push_str(&format!("    %tmp{} = load {}, {}* %tmp{}\n",utvc, underlying_type_representation, underlying_type_representation, value.index));
                    return Ok(CompiledTempValue{index: utvc, value_type: value_deref_type});
                }
                UnaryOp::Ref => {
                    let lvalue = compile_lvalue(expr, state)?;
                    let referenced_type = lvalue.value_type.reference_once();
                    return Ok(CompiledTempValue {
                        index: lvalue.index,
                        value_type: referenced_type,
                    });
                }
            }
        }
        Expr::Call(left, args) =>{
            //println!("{:?}",left);
            if Expr::Name(format!("sizeof")) == **left {
                let size = if args.len() == 1 { state.get_compiler_type_from_parser(&type_from_expression(&args[0])?)?.sizeof(state) } else { return Err(format!("Only 1 argument is allowed. Example: sizeof(&i32);"));};
                let utvc = state.aquire_unique_temp_value_counter();
                if let Some(x) = expected_type {
                    if x.is_integer() {
                        let q = state.get_compiler_type_from_parser(x).unwrap();
                        state.output.push_str(&format!("    %tmp{} = add {} {}, 0\n", utvc, q.underlying_representation.to_string(), size));
                        return Ok(CompiledTempValue{index: utvc, value_type: x.clone()});
                    }
                }
                state.output.push_str(&format!("    %tmp{} = add i64 {}, 0\n",utvc, size));
                return Ok(CompiledTempValue{index: utvc, value_type: ParserType::Named(format!("i64"))}); 
            }
            if Expr::Name(format!("stalloc")) == **left {
                let right = if args.len() == 1 { &args[0] } else { return Err(format!("Only 1 argument is allowed. Example: stalloc(32);"));};
                let r_val = compile_rvalue(right, Some(&ParserType::Named(format!("i64"))), state)?;

                let utvc = state.aquire_unique_temp_value_counter();
                state.output.push_str(&format!("    %tmp{} = alloca i8, i64 %tmp{}\n",utvc, r_val.index));
                return Ok(CompiledTempValue{index: utvc, value_type: ParserType::Ref(Box::new(ParserType::Named(format!("i8"))))}); 
            }
            let call_address = compile_lvalue(left, state)?;
            if let ParserType::Fucntion(return_type, args_type) = call_address.value_type {
                if args_type.len() != args.len() {
                    return Err(format!("Amount of arguments given, does not respond with the amount required"));
                }
                let mut comps = vec![];
                for i in 0..args.len() {
                    let arg = &args[i];
                    let mut x = compile_rvalue(arg, Some(&args_type[i]),state)?;
                    if x.value_type != args_type[i] {
                        x = implisit_cast(&x, &args_type[i], state)?;
                    }
                    comps.push(x);
                }
                let args = comps.iter().map(|x| format!("{} %tmp{}",x.value_type.to_string(), x.index)).collect::<Vec<_>>().join(",");
                let utvc = state.aquire_unique_temp_value_counter();
                state.output.push_str(&format!("    %tmp{} = call {} %tmp{}({})\n",utvc, return_type.to_string(), call_address.index, args));
                return Ok(CompiledTempValue{index: utvc, value_type: *return_type}); 
            }
            return Err(format!("Tried to call non-function type"));
        }
        _ => todo!("{:?}", right)
    }
}
fn compile_lvalue(left: &Expr, state: &mut CompilerState) -> Result<CompiledTempValue, String>{
    let utvc = state.aquire_unique_temp_value_counter();
    match left {
        Expr::Name(name) => {
            if let Ok(var) = state.get_variable_type(&name) {
                let var_actual_type = var.parser_type.clone();
                let var_repr_type = var.underlying_representation.clone();

                state.output.push_str(&format!("    %tmp{} = getelementptr {}, {}* %{}\n", utvc, var_repr_type.to_string(), var_repr_type.to_string(), name));
                return Ok(CompiledTempValue{index: utvc, value_type: var_actual_type});
            }
            if let Ok(var) = state.get_argument_type(&name) {
                let var_actual_type = var.parser_type.clone();
                let var_repr_type = var.underlying_representation.clone();

                state.output.push_str(&format!("    %tmp{} = getelementptr {}, {}* %{}.addr\n", utvc, var_repr_type.to_string(), var_repr_type.to_string(), name));
                return Ok(CompiledTempValue{index: utvc, value_type: var_actual_type});
            }
            if let Ok(func) = state.get_function(&name) {
                let name = &func.name;
                let args = &func.args;
                let args_string = args.iter().map(|x| x.1.to_string()).collect::<Vec<_>>().join(",");
                let return_type = func.return_type.clone();
                let args_copy = args.iter().map(|x|x.1.clone()).collect::<Vec<_>>();
                state.output.push_str(&format!("    %tmp{} = bitcast {}({})* @{} to ptr\n", utvc, return_type.to_string(), args_string, name));
                return Ok(CompiledTempValue{index: utvc, value_type: ParserType::Fucntion(Box::new(return_type), args_copy)});
            }
            return Err(format!("Name \"{}\" does not respond to function name or variable name in current context",name));
        }
        Expr::UnaryOp(op, expr) =>{
            match op {
                UnaryOp::Deref =>{
                    let pointer_val = compile_rvalue(expr, None, state)?;
                    if !pointer_val.value_type.is_pointer() {
                        return Err(format!("Cannot dereference a non-pointer type: {:?}", pointer_val.value_type));
                    }
                    let lvalue_type = pointer_val.value_type.dereference_once();
                    return Ok(CompiledTempValue{index: pointer_val.index, value_type: lvalue_type});
                }
                _ => todo!()
            }
        }
        _ => todo!()
    }
}
pub fn compile_expression(expression: &Expr, expected_type: Option<&ParserType>, state: &mut CompilerState) -> Result<CompiledTempValue, String> {
    //println!("Expression {:?}", expression);
    match expression {
        Expr::UnaryOp(_, _) | Expr::Name(_) | Expr::Integer(_) | Expr::Call(_, _) | Expr::BinaryOp(_, _, _) =>{
            return compile_rvalue(&expression, expected_type, state);
        }
        Expr::Assign(left, right) => {
            let l = compile_lvalue(&left, state)?;
            let mut r = compile_rvalue(&right, expected_type, state)?;
            let val_type =  &l.value_type;
            if val_type != &r.value_type {
                r = implisit_cast(&r, &l.value_type, state)?;
            }
            let l_ut = state.get_compiler_type_from_parser(&l.value_type)?;
            state.output.push_str(&format!("    store {} %tmp{}, {}* %tmp{}\n",l_ut.underlying_representation.to_string(),r.index, l_ut.underlying_representation.to_string(), l.index));
            
            return Ok(r.clone());
        }
        Expr::Cast(expression, desired_type) =>{
            let result = compile_rvalue(expression, Some(desired_type), state)?;
            if result.value_type == *desired_type {
                return Ok(result);
            }
            return explicit_cast(&result, desired_type, state);
        }
        _ => {}
    }
    todo!("{:?}",expression);
}