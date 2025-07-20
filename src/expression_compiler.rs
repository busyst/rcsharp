use crate::{compiler::CompilerState, expression_parser::{Expr, UnaryOp}, parser::{ParserType, Stmt}};
#[derive(Debug, Clone)]
pub struct CompiledTempValue{pub index:usize, pub value_type: ParserType}
pub fn explicit_cast(value: &CompiledTempValue, to: &ParserType, state: &mut CompilerState) -> Result<CompiledTempValue, String>{
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
                            println!("{:?}", to);
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
            let utvc = state.aquire_unique_temp_value_counter();
            state.output.push_str(&format!("    %tmp{} = inttoptr {} %tmp{} to {}\n",utvc, value.value_type.to_string(), value.index.to_string(), to.to_string()));
            //return Err(format!("Todo \"{:?}\" to \"{:?}\"", &value.value_type, to))
            return Ok(CompiledTempValue { index: utvc, value_type: to.clone() });
        }
        (ParserType::Ref(_),ParserType::Named(_)) => {
            let utvc = state.aquire_unique_temp_value_counter();
            state.output.push_str(&format!("    %tmp{} = ptrtoint {} %tmp{} to {}\n",utvc, value.value_type.to_string(), value.index.to_string(), to.to_string()));
            return Ok(CompiledTempValue { index: utvc, value_type: to.clone() });
        }
        (ParserType::Ref(_),ParserType::Ref(_)) => {
            return Ok(CompiledTempValue { index: value.index, value_type: to.clone() });
        }
    }
}
pub fn implisit_cast(value: &CompiledTempValue, to: &ParserType, state: &mut CompilerState) -> Result<CompiledTempValue, String>{

    match (&value.value_type, to) {
        _ => return Err(format!("Unable to implisitly cast from \"{:?}\" to \"{:?}\"", &value.value_type, to))
    }
}
pub fn compile_rvalue(right: &Expr, expected_type: Option<&ParserType>, state: &mut CompilerState) -> Result<CompiledTempValue, String>{
    match right {
        Expr::Integer(num) =>{
            let utvc = state.aquire_unique_temp_value_counter();
            //if let Some(expected_type) = expected_type {
            //    state.output.push_str(&format!("    %tmp{} = add {} {}, 0\n", utvc, expected_type.to_string(), num));
            //    return Ok(CompiledTempValue{index: utvc, value_type: expected_type.clone()});
            //}
            state.output.push_str(&format!("    %tmp{} = add i64 {}, 0\n", utvc, num));
            return Ok(CompiledTempValue{index: utvc, value_type: ParserType::Named(format!("i64"))});
        }
        Expr::Name(name) =>{
            let utvc = state.aquire_unique_temp_value_counter();
            let var = state.get_variable_type(&name)?;
            let var_actual_type = var.parser_type.clone();
            let var_repr_type = var.underlying_representation.clone();

            state.output.push_str(&format!("    %tmp{} = load {}, {}* %{}\n", utvc, var_repr_type.to_string(), var_repr_type.to_string(), name));
            return Ok(CompiledTempValue{index: utvc, value_type: var_actual_type.clone()});
        }
        Expr::Cast(expression, desired_type) =>{
            let result = compile_rvalue(expression, Some(desired_type), state)?;
            if result.value_type == *desired_type {
                return Ok(result);
            }
            return explicit_cast(&result, desired_type, state);
        }
        Expr::UnaryOp(op, expr) =>{
            match op {
                UnaryOp::Deref =>{
                    let value = compile_rvalue(expr, expected_type, state)?;
                    let value_type = &value.value_type;
                    if !value_type.is_pointer() {
                        return Err(format!("Tried to dereference non pointer value {:?}", &value));
                    }
                    let value_deref_type = value.value_type.dereference_once();
                    let utvc = state.aquire_unique_temp_value_counter();
                    state.output.push_str(&format!("    %tmp{} = load {}, {}* %tmp{}\n",utvc, value_deref_type.to_string(), value_deref_type.to_string(), value.index));
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
                _ => todo!()
            }
        }
        _ => todo!()
    }
}
fn compile_lvalue(left: &Expr, state: &mut CompilerState) -> Result<CompiledTempValue, String>{
    let utvc = state.aquire_unique_temp_value_counter();
    match left {
        Expr::Name(name) => {
            let var = state.get_variable_type(&name)?;
            let var_actual_type = var.parser_type.clone();
            let var_repr_type = var.underlying_representation.clone();

            state.output.push_str(&format!("    %tmp{} = getelementptr {}, {}* %{}\n", utvc, var_repr_type.to_string(), var_repr_type.to_string(), name));
            return Ok(CompiledTempValue{index: utvc, value_type: var_actual_type});
        }
        _ => {}
    }
    todo!("{:?}",left);
}
pub fn compile_expression(expression: &Expr, expected_type: Option<&ParserType>, state: &mut CompilerState) -> Result<CompiledTempValue, String> {
    println!("{:?}", expression);
    match expression {
        Expr::Integer(_) =>{
            return compile_rvalue(expression, expected_type, state);
        }
        Expr::Name(_) =>{
            return compile_rvalue(expression, expected_type, state);
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
        Expr::UnaryOp(_, _) =>{
            return compile_rvalue(&expression, None, state);
        }
        _ => {}
    }
    todo!("{:?}",expression);
}