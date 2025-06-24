use crate::{compiler::CompilerState, expression_parser::{BinaryOp, Expr, UnaryOp}, parser::ParserType};
macro_rules! extract {
    ($e:expr, $p:path) => {
        match $e {
            $p(value) => Some(value),
            _ => None,
        }
    };
}
#[derive(Debug, Clone)]
pub struct TypedValue {
    pub index: usize,
    pub ty: ParserType,
}

pub fn var_cast(from_val: TypedValue, to_type: &ParserType, state: &mut CompilerState) -> Result<TypedValue, String> {
    if from_val.ty == *to_type {
        return Ok(from_val);
    }

    let new_index = state.get_temp_variable_index();
    let from_type_str = CompilerState::get_type_string(&from_val.ty);
    let to_type_str = CompilerState::get_type_string(to_type);
    fn get_integer_bit_width(type_name: &str) -> Result<u32, String> {
        if !type_name.starts_with('i') {
            return Err(format!("Type '{}' is not a standard integer type.", type_name));
        }
        type_name[1..]
            .parse::<u32>()
            .map_err(|_| format!("Could not parse bit width from type name '{}'.", type_name))
    }
    let instruction = match (&from_val.ty, to_type) {
        // Integer-to-integer
        (ParserType::Named(from), ParserType::Named(to)) if from.starts_with('i') && to.starts_with('i') => {
            let from_bits = get_integer_bit_width(from)?;
            let to_bits = get_integer_bit_width(to)?;
            let op = if to_bits > from_bits {
                "sext" // Sign-extend
            } else if to_bits < from_bits {
                "trunc" // Truncate
            } else {
                "bitcast"
            };
            format!("%tmp{new_index} = {op} {from_type_str} %tmp{} to {to_type_str}\n", from_val.index)
        }
        // Integer-to-pointer
        (ParserType::Named(n), ParserType::Ref(_)) if n.starts_with('i') => {
            format!("%tmp{new_index} = inttoptr {from_type_str} %tmp{} to {to_type_str}\n", from_val.index)
        }
        // Pointer-to-integer
        (ParserType::Ref(_), ParserType::Named(n)) if n.starts_with('i') => {
            format!("%tmp{new_index} = ptrtoint {from_type_str} %tmp{} to {to_type_str}\n", from_val.index)
        }
        // Pointer-to-pointer
        (ParserType::Ref(_), ParserType::Ref(_)) => {
            format!("%tmp{new_index} = bitcast {from_type_str} %tmp{} to {to_type_str}\n", from_val.index)
        }
        _ => return Err(format!("Unsupported cast from {:?} to {:?}", from_val.ty, to_type)),
    };

    state.push_str(&instruction);
    Ok(TypedValue { index: new_index, ty: to_type.clone() })
}


pub fn compile_expression_rec(
    t: &Expr,
    expected_type: Option<&ParserType>,
    state: &mut CompilerState,
) -> Result<TypedValue, String> {
    match t {
        Expr::Index(base, index) => {
            let base_ptr_val = compile_expression_rec(base, None, state)?;
            
            let element_type = if let ParserType::Ref(inner) = &base_ptr_val.ty {
                *inner.clone()
            } else {
                return Err(format!("Cannot index a non-pointer type: {:?}", base_ptr_val.ty));
            };

            let index_val = compile_expression_rec(index, Some(&ParserType::Named("i64".into())), state)?;

            let gep_mi = state.get_temp_variable_index();
            let element_type_str = CompilerState::get_type_string(&element_type);
            let ptr_type_str = CompilerState::get_type_string(&base_ptr_val.ty);
            let index_type_str = CompilerState::get_type_string(&index_val.ty);

            state.push_str(&format!(
                "%tmp{} = getelementptr inbounds {}, {} %tmp{}, {} %tmp{}\n",
                gep_mi, element_type_str, ptr_type_str, base_ptr_val.index, index_type_str, index_val.index
            ));
            
            let load_mi = state.get_temp_variable_index();
            // Note: The original was missing a space between the type and the pointer register
            state.push_str(&format!(
                "%tmp{} = load {}, {} %tmp{}\n",
                load_mi, element_type_str, ptr_type_str, gep_mi
            ));

            Ok(TypedValue { index: load_mi, ty: element_type })
        }

        Expr::Integer(integer_string) => {
            let mi = state.get_temp_variable_index();

            if let Some(ParserType::Ref(_)) = expected_type {
                state.push_str(&format!("%tmp{}_i64 = add i64 {}, 0\n", mi, integer_string));
                let ty_str = CompilerState::get_type_string(&expected_type.unwrap());
                state.push_str(&format!("%tmp{} = inttoptr i64 %tmp{}_i64 to {}\n", mi, mi, ty_str));
                return Ok(TypedValue { index: mi, ty: expected_type.unwrap().clone() });
            } else {
                let mut ty = ParserType::Named("i32".to_string());
                 if let Some(ParserType::Named(name)) = expected_type {
                    if name.starts_with('i') {
                        ty = expected_type.unwrap().clone();
                    }
                }
                let ty_str = CompilerState::get_type_string(&ty);
                state.push_str(&format!("%tmp{} = add {} {}, 0\n", mi, ty_str, integer_string));
                return Ok(TypedValue { index: mi, ty });
            }
        }
        Expr::Name(name) => {
            let mi = state.get_temp_variable_index();
            let var_info = state.find_variable(name)?.clone();
            let llvm_type_str = CompilerState::get_type_string(&var_info.ty);
            state.push_str(&format!("%tmp{} = load {}, {}* %{}\n", mi, llvm_type_str, llvm_type_str, var_info.llvm_name));
            Ok(TypedValue { index: mi, ty: var_info.ty.clone() })
        }
        Expr::BinaryOp(left, op, right) => {
            let l_val = compile_expression_rec(left, None, state)?;
            let r_val = compile_expression_rec(right, Some(&l_val.ty), state)?;

            let final_r_val = if l_val.ty != r_val.ty {
                var_cast(r_val, &l_val.ty, state)?
            } else {
                r_val
            };

            let mi = state.get_temp_variable_index();
            let op_type_str = CompilerState::get_type_string(&l_val.ty);
            let (op_str, result_ty) = match op {
                BinaryOp::Add => ("add", l_val.ty.clone()),
                BinaryOp::Subtract => ("sub", l_val.ty.clone()),
                BinaryOp::Multiply => ("mul", l_val.ty.clone()),
                BinaryOp::Divide => ("sdiv", l_val.ty.clone()),
                BinaryOp::Modulo => ("srem", l_val.ty.clone()),
                BinaryOp::Equal => ("icmp eq", ParserType::Named("i1".to_string())),
                BinaryOp::NotEqual => ("icmp ne", ParserType::Named("i1".to_string())),
                BinaryOp::Less => ("icmp slt", ParserType::Named("i1".to_string())),
                BinaryOp::LessEqual => ("icmp sle", ParserType::Named("i1".to_string())),
                BinaryOp::Greater => ("icmp sgt", ParserType::Named("i1".to_string())),
                BinaryOp::GreaterEqual => ("icmp sge", ParserType::Named("i1".to_string())),
                _ => panic!()
            };

            state.push_str(&format!("%tmp{} = {} {} %tmp{}, %tmp{}\n", mi, op_str, op_type_str, l_val.index, final_r_val.index));
            Ok(TypedValue { index: mi, ty: result_ty })
        }

        Expr::UnaryOp(operation, expression) => {
            match operation {
                UnaryOp::Ref => {
                    // An "lvalue" is an expression that refers to a memory location. We can take its address.
                    // Examples: variables (`x`), array indexing (`a[i]`), pointer dereferencing (`*p`).
                    // An "rvalue" is a temporary value (e.g., `x + 1`) that we cannot take the address of.
                    let lvalue_address = match &**expression {
                        Expr::Name(name) => {
                            // The address of a variable is the pointer to its storage (alloca).
                            let var_info = state.find_variable(name)?.clone();
                            let pointer_type = ParserType::Ref(Box::new(var_info.ty.clone()));
                            let pointer_type_str = CompilerState::get_type_string(&pointer_type);
                            
                            let mi = state.get_temp_variable_index();
                            let source_ptr_type_str = format!("{}*", CompilerState::get_type_string(&var_info.ty));

                            // A bitcast is a simple way to copy the pointer value into a temporary register.
                            // e.g., `%tmp1 = bitcast i32* %my_var to i32*`
                            state.push_str(&format!(
                                "%tmp{} = bitcast {} %{} to {}\n",
                                mi, source_ptr_type_str, var_info.llvm_name, pointer_type_str
                            ));

                            Ok(TypedValue {
                                index: mi,
                                ty: pointer_type,
                            })
                        }
                        Expr::Index(base, index) => {
                            // The address of `base[index]` is the result of `getelementptr`, without the subsequent `load`.
                            let base_ptr_val = compile_expression_rec(base, None, state)?;
                            
                            let element_type = if let ParserType::Ref(inner) = &base_ptr_val.ty {
                                *inner.clone()
                            } else {
                                return Err(format!("Cannot index a non-pointer type: {:?}", base_ptr_val.ty));
                            };

                            let index_val = compile_expression_rec(index, Some(&ParserType::Named("i64".into())), state)?;

                            let gep_mi = state.get_temp_variable_index();
                            let element_type_str = CompilerState::get_type_string(&element_type);
                            let ptr_type_str = CompilerState::get_type_string(&base_ptr_val.ty);
                            let index_type_str = CompilerState::get_type_string(&index_val.ty);

                            state.push_str(&format!(
                                "%tmp{} = getelementptr inbounds {}, {} %tmp{}, {} %tmp{}\n",
                                gep_mi, element_type_str, ptr_type_str, base_ptr_val.index, index_type_str, index_val.index
                            ));
                            
                            Ok(TypedValue { index: gep_mi, ty: base_ptr_val.ty.clone() })
                        }
                        _ => Err(format!("The address-of operator '&' can only be applied to an lvalue (a variable, array index, or dereference), not to {:?}", expression)),
                    }?;

                    Ok(lvalue_address)
                }

                UnaryOp::Deref => {
                    let ptr_val = compile_expression_rec(expression, None, state)?;
                    let inner_type = match &ptr_val.ty {
                        ParserType::Ref(inner) => (**inner).clone(),
                        _ => return Err(format!("Cannot dereference a non-pointer type: {:?}", ptr_val.ty)),
                    };
                    let mi = state.get_temp_variable_index();
                    let inner_type_str = CompilerState::get_type_string(&inner_type);
                    let ptr_type_str = CompilerState::get_type_string(&ptr_val.ty);
                    state.push_str(&format!("%tmp{} = load {}, {} %tmp{}\n", mi, inner_type_str, ptr_type_str, ptr_val.index));
                    Ok(TypedValue { index: mi, ty: inner_type })
                }

                UnaryOp::Not => {
                    let i1_type = ParserType::Named("i1".to_string());
                    let mut operand_val = compile_expression_rec(expression, Some(&i1_type), state)?;
                    if operand_val.ty != i1_type {
                        let operand_type_str = CompilerState::get_type_string(&operand_val.ty);
                        let new_mi = state.get_temp_variable_index();
                        state.push_str(&format!("%tmp{} = icmp ne {} %tmp{}, 0\n", new_mi, operand_type_str, operand_val.index));
                        operand_val = TypedValue { index: new_mi, ty: i1_type.clone() };
                    }
                    let mi = state.get_temp_variable_index();
                    state.push_str(&format!("%tmp{} = xor i1 %tmp{}, true\n", mi, operand_val.index));
                    Ok(TypedValue { index: mi, ty: i1_type })
                }
                UnaryOp::Negate => {
                    let operand_val = compile_expression_rec(expression, None, state)?;
                    if !CompilerState::get_type_string(&operand_val.ty).starts_with('i') {
                         return Err(format!("Arithmetic negation '-' can only be applied to integers, not to {:?}", operand_val.ty));
                    }
                    let mi = state.get_temp_variable_index();
                    let op_type_str = CompilerState::get_type_string(&operand_val.ty);
                    state.push_str(&format!("%tmp{} = sub nsw {} 0, %tmp{}\n", mi, op_type_str, operand_val.index));
                    Ok(TypedValue { index: mi, ty: operand_val.ty })
                }
            }
        }
        Expr::Call(func_expr, args) => {
            let name = extract!(&**func_expr, Expr::Name)
                .ok_or_else(|| format!("Function calls must be by simple name, found {:?}", func_expr))?
                .clone();
            let (return_type, arg_types) = state.find_function(&name)?.clone();

            if args.len() != arg_types.len() {
                return Err(format!("Function '{}' expected {} arguments, but {} were provided", name, arg_types.len(), args.len()));
            }

            let mut compiled_args = Vec::with_capacity(args.len());
            for (i, arg_expr) in args.iter().enumerate() {
                let expected_arg_type = &arg_types[i];
                let compiled_arg = compile_expression_rec(arg_expr, Some(expected_arg_type), state)?;
                let final_arg = if compiled_arg.ty != *expected_arg_type {
                    var_cast(compiled_arg, expected_arg_type, state)?
                } else {
                    compiled_arg
                };
                compiled_args.push(final_arg);
            }
            let mi = state.get_temp_variable_index();
            let args_str = compiled_args
                .iter()
                .map(|arg| format!("{} %tmp{}", CompilerState::get_type_string(&arg.ty), arg.index))
                .collect::<Vec<String>>()
                .join(", ");

            if return_type == ParserType::Named("void".to_string()) {
                state.push_str(&format!("call void @{}({})\n", name, args_str));
            } else {
                let return_type_str = CompilerState::get_type_string(&return_type);
                state.push_str(&format!("%tmp{} = call {} @{}({})\n", mi, return_type_str, name, args_str));
            }

            let result_val = TypedValue { index: mi, ty: return_type };
            if let Some(expected) = expected_type {
                if result_val.ty != *expected {
                    return var_cast(result_val, expected, state);
                }
            }
            Ok(result_val)
        }
        Expr::Cast(expression_to_cast, target_type) => {
            let resulting_value = compile_expression_rec(
                expression_to_cast,
                Some(target_type),
                state
            )?;
            if &resulting_value.ty == target_type {
                Ok(resulting_value)
            } else {
                var_cast(resulting_value, target_type, state)
            }
        }
        Expr::StringConst(x) => {
            let (const_idx, const_len) = state.add_constant_string(x.clone());
            let mi = state.get_temp_variable_index();
            state.push_str(&format!("%tmp{} = getelementptr inbounds [{} x i8], [{} x i8]* @.str{}, i64 0, i64 0\n", mi, const_len, const_len, const_idx));
            let str_ptr_type = ParserType::Ref(Box::new(ParserType::Named("i8".to_string())));
            Ok(TypedValue { index: mi, ty: str_ptr_type })
        }
        
        _ => Err(format!("Unsupported expression type: {:?}", t)),
    }
}