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
    let ltype_true_string = ltype.llvm_representation.to_string();
    let rtype_true_string = rtype.llvm_representation.to_string();
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
            if !rtype.parser_type.is_integer() { 
                return Err(format!("Cannot convert from pointer to non-integer type '{}'", to.to_string()));
            }
            let utvc = state.aquire_unique_temp_value_counter();
            state.output.push_str(&format!("    %tmp{} = ptrtoint {} %tmp{} to {}\n",utvc, ltype_true_string, value.index.to_string(), rtype_true_string));
            return Ok(CompiledTempValue { index: utvc, value_type: rtype.parser_type });
        }
        (ParserType::Ref(_),ParserType::Ref(_)) => {
            let utvc = state.aquire_unique_temp_value_counter();
            state.output.push_str(&format!("    %tmp{} = bitcast {} %tmp{} to {}\n",utvc, ltype_true_string, value.index, rtype_true_string));
            return Ok(CompiledTempValue { index: utvc, value_type: rtype.parser_type });
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
                    state.output.push_str(&format!("    %tmp{} = add {} {}, 0\n", utvc, q.llvm_representation.to_string(), num));
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
                let var_repr_type = var.llvm_representation.clone();

                state.output.push_str(&format!("    %tmp{} = load {}, {}* %{}\n", utvc, var_repr_type.to_string(), var_repr_type.to_string(), name));
                return Ok(CompiledTempValue{index: utvc, value_type: var_actual_type.clone()});   
            }
            if let Ok(var) = state.get_argument_type(&name) {
                let var_actual_type = var.parser_type.clone();
                let var_repr_type = var.llvm_representation.clone();

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
                r = implisit_cast(&r, &l.value_type, state).map_err(|x| format!("while compiling binary expression !{:?}! !{:?}! !{:?}\n{}", left, op, right, x))?;
            }
            if l.value_type != r.value_type {
                return Err(format!("Binary operator '{:?}' cannot be applied to mismatched types '{}' and '{}'",op,l.value_type.to_string(),r.value_type.to_string()));
            }
            if l.value_type == r.value_type {
                if l.value_type.is_integer() {

                    let utvc = state.aquire_unique_temp_value_counter();
                    let llvm_type = state.get_compiler_type_from_parser(&l.value_type)?.llvm_representation.to_string();
                    
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
                if l.value_type.is_pointer() {
                    let utvc = state.aquire_unique_temp_value_counter();
                    let llvm_op = match op {
                        BinaryOp::Equal => "icmp eq",
                        BinaryOp::NotEqual => "icmp ne",
                        _ => panic!("Operation \"{:?}\" is not permited on pointers", op)
                    };
                    state.output.push_str(&format!("    %tmp{} = {} ptr %tmp{}, %tmp{}\n",utvc, llvm_op, l.index, r.index));
                    return Ok(CompiledTempValue { index: utvc, value_type: ParserType::Named("bool".to_string()) });
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
                        let llvm_type = state.get_compiler_type_from_parser(&value.value_type)?.llvm_representation.to_string();
                        state.output.push_str(&format!("    %tmp{} = icmp eq {} %tmp{}, 0\n", utvc, llvm_type, value.index));
                        return Ok(CompiledTempValue { index: utvc, value_type: ParserType::Named("bool".to_string()) });
                    }
                    return Err(format!("Unary NOT '!' operator cannot be applied to type '{}'.",value.value_type.to_string()));
                }
                UnaryOp::Negate => {
                    let value = compile_rvalue(expr, None, state)?;
                    let utvc = state.aquire_unique_temp_value_counter();
                    if value.value_type.is_signed_integer() {
                        let llvm_type = state.get_compiler_type_from_parser(&value.value_type)?.llvm_representation.to_string();
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
                    let underlying_type_representation= state.get_compiler_type_from_parser(&value_deref_type)?.llvm_representation.to_string();
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
            if Expr::Name(format!("sizeof")) == **left {
                let size = if args.len() == 1 { state.get_compiler_type_from_parser(&type_from_expression(&args[0])?)?.sizeof(state) } else { return Err(format!("Only 1 argument is allowed. Example: sizeof(&i32);"));};
                let utvc = state.aquire_unique_temp_value_counter();
                if let Some(x) = expected_type {
                    if x.is_integer() {
                        let q = state.get_compiler_type_from_parser(x).unwrap();
                        state.output.push_str(&format!("    %tmp{} = add {} {}, 0\n", utvc, q.llvm_representation.to_string(), size));
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
                let return_type = state.get_compiler_type_from_parser(&return_type)?;
                if args_type.len() != args.len() {
                    return Err(format!("Amount of arguments given, does not respond with the amount required"));
                }
                let mut comps = vec![];
                for i in 0..args.len() {
                    let arg = &args[i];
                    let mut x = compile_rvalue(arg, Some(&args_type[i]),state)?;
                    if x.value_type != args_type[i] {
                        x = implisit_cast(&x, &args_type[i], state).map_err(|x| format!("while calling function !{:?}!\n{}", left, x))?;
                    }
                    comps.push(x);
                }
                let mut arg_parts = Vec::new();
                for x in comps {
                    let compiler_type = state.get_compiler_type_from_parser(&x.value_type)?;
                    let type_string = compiler_type.llvm_representation.to_string();
                    let formatted_arg = format!("{} %tmp{}", type_string, x.index);
                    arg_parts.push(formatted_arg);
                }
                let args_string = arg_parts.join(",");
                if !return_type.parser_type.is_void() {
                    let utvc = state.aquire_unique_temp_value_counter();
                    state.output.push_str(&format!("    %tmp{} = call {} %tmp{}({})\n",utvc, return_type.llvm_representation.to_string(), call_address.index, args_string));
                    return Ok(CompiledTempValue{index: utvc, value_type: return_type.parser_type}); 
                }
                state.output.push_str(&format!("    call void %tmp{}({})\n", call_address.index, args_string));
                return Ok(CompiledTempValue{index: 0, value_type: return_type.parser_type});
            }
            return Err(format!("Tried to call non-function type"));
        }
        Expr::Member(x, y) =>{
            let member_lvalue = compile_lvalue(&Expr::Member(x.clone(), y.clone()), state)?;
            let utvc = state.aquire_unique_temp_value_counter();
            let member_type_repr = state.get_compiler_type_from_parser(&member_lvalue.value_type)?.llvm_representation.to_string();
            state.output.push_str(&format!("    %tmp{} = load {}, {}* %tmp{}\n",utvc, member_type_repr, member_type_repr, member_lvalue.index));
            return Ok(CompiledTempValue { index: utvc, value_type: member_lvalue.value_type });
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
                let var_repr_type = var.llvm_representation.clone();

                state.output.push_str(&format!("    %tmp{} = getelementptr inbounds {}, {}* %{}, i32 0\n", utvc, var_repr_type.to_string(), var_repr_type.to_string(), name));
                return Ok(CompiledTempValue{index: utvc, value_type: var_actual_type});
            }
            if let Ok(var) = state.get_argument_type(&name) {
                let var_actual_type = var.parser_type.clone();
                let var_repr_type = var.llvm_representation.clone();

                state.output.push_str(&format!("    %tmp{} = getelementptr inbounds {}, {}* %{}.addr, i32 0\n", utvc, var_repr_type.to_string(), var_repr_type.to_string(), name));
                return Ok(CompiledTempValue{index: utvc, value_type: var_actual_type});
            }
            if let Ok(func) = state.get_function(&name) {
                let name = &func.name;
                let args = &func.args;
                let return_type = state.get_compiler_type_from_parser(&func.return_type)?;
                let mut arg_parts = Vec::new();
                for (_, arg_type) in args {
                    let compiler_type = state.get_compiler_type_from_parser(arg_type)?;
                    let type_string = compiler_type.llvm_representation.to_string();
                    let formatted_arg = format!("{}", type_string);
                    arg_parts.push(formatted_arg);
                }
                let args_string = arg_parts.join(",");
                let args_copy = args.iter().map(|x|x.1.clone()).collect::<Vec<_>>();
                state.output.push_str(&format!("    %tmp{} = bitcast {}({})* @{} to ptr\n", utvc, return_type.llvm_representation.to_string(), args_string, name));
                return Ok(CompiledTempValue{index: utvc, value_type: ParserType::Fucntion(Box::new(return_type.parser_type), args_copy)});
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
        Expr::Member(x, y) =>{
            let l = compile_lvalue(x, state)?;
            let var_type = state.get_compiler_type_from_parser(&l.value_type)?;
            if let ParserType::Structure(_, args) = var_type.struct_representation {
                let index = args.iter().position(|x| x.0 == *y).ok_or(format!("Member \"{}\" was not found inside structure \"{}\"", y, var_type.parser_type.to_string()))?;
                let mut offset = 0;
                for i in 0..index {
                    let arg_size = state.get_compiler_type_from_parser(&args[i].1)?.sizeof(state);
                    offset += arg_size;
                }
                state.output.push_str(&format!("    %tmp{} = getelementptr i8, {} %tmp{}, i64 {}\n",utvc, "ptr", l.index, offset));
                return Ok(CompiledTempValue { index: utvc, value_type: args[index].1.clone() });
            }
            todo!()
        }
        _ => todo!()
    }
}
pub fn compile_expression(expression: &Expr, expected_type: Option<&ParserType>, state: &mut CompilerState) -> Result<CompiledTempValue, String> {
    //println!("Expression {:?}", expression);
    match expression {
        Expr::UnaryOp(_, _) | Expr::Name(_) | Expr::Integer(_) | Expr::Call(_, _) | Expr::BinaryOp(_, _, _) | Expr::Member(_, _) =>{
            return compile_rvalue(&expression, expected_type, state);
        }
        Expr::Assign(left, right) => {
            let l = compile_lvalue(&left, state)?;
            let mut r = compile_rvalue(&right, Some(&l.value_type), state)?;
            let val_type =  &l.value_type;
            if val_type != &r.value_type {
                r = implisit_cast(&r, &l.value_type, state).map_err(|x| format!("while assigning !{:?}! !EQUAL! !{:?}\n{}", left, right, x))?;
            }
            let l_ut = state.get_compiler_type_from_parser(&l.value_type)?;
            state.output.push_str(&format!("    store {} %tmp{}, {}* %tmp{}\n",l_ut.llvm_representation.to_string(),r.index, l_ut.llvm_representation.to_string(), l.index));
            
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