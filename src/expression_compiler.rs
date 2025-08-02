use crate::{compiler::{CompilerState, CompilerType}, expression_parser::{BinaryOp, Expr, UnaryOp}, parser::{ParserType, Stmt}};
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum Expected<'a> {
    Type(&'a ParserType),
    Anything,
    NoReturn,
}
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum CompiledResult {
    TempValue(usize, ParserType),
    Integer(String, ParserType),
    Function(String, ParserType),
    NoReturn,
}
impl CompiledResult {
    pub fn equal_to_type(&self, to: &ParserType) -> bool{
        match self {
            CompiledResult::TempValue(_, x) => x == to,
            CompiledResult::Integer(_, x) => x == to,
            CompiledResult::Function(_, x) => x == to,
            CompiledResult::NoReturn => false,
        }
    }
    pub fn get_type(&self) -> &ParserType{
        match self {
            CompiledResult::TempValue(_, x) => x,
            CompiledResult::Integer(_, x) => x,
            CompiledResult::Function(_, x) => x,
            CompiledResult::NoReturn => panic!(),
        }
    }
    pub fn get_expected_type(&self) -> Expected{
        match self {
            CompiledResult::TempValue(_, x) => Expected::Type(x),
            CompiledResult::Integer(_, x) => Expected::Type(x),
            CompiledResult::Function(_, x) => Expected::Type(x),
            CompiledResult::NoReturn => Expected::NoReturn,
        }
    }
    pub fn equal_types(&self, with: &CompiledResult) -> bool{
        match (self, with) {
            (CompiledResult::NoReturn, CompiledResult::NoReturn) => true, // thats true, but this shouldnt happen 
            (CompiledResult::NoReturn, _) | (_, CompiledResult::NoReturn) => false,
            (CompiledResult::TempValue(_, x), CompiledResult::TempValue(_, y)) => x == y,

            (CompiledResult::TempValue(_, x), CompiledResult::Integer(_, y)) => x == y,
            (CompiledResult::Integer(_, x), CompiledResult::TempValue(_, y)) => x == y,
            (CompiledResult::Integer(_, x), CompiledResult::Integer(_, y)) => x == y,
            _ => false
        }
    }
    pub fn to_repr(&self) -> String{
        match self {
            CompiledResult::TempValue(uid, _) => format!("%tmp{}", uid),
            CompiledResult::Integer(name, _) => format!("{}", name),
            CompiledResult::Function(name, _) => format!("@{}", name),
            CompiledResult::NoReturn => panic!("Tried to get llvm string representation of no return value"),
        }
    }
    pub fn to_repr_with_type(&self, state: &CompilerState) -> Result<String, String>{
        match self {
            CompiledResult::TempValue(uid, typ) => Ok(format!("{} %tmp{}", state.get_compiler_type_from_parser(typ)?.llvm_representation.to_string(), uid)),
            CompiledResult::Integer(name, typ) => Ok(format!("{} {}", state.get_compiler_type_from_parser(typ)?.llvm_representation.to_string(), name)),
            CompiledResult::Function(name, _) => Ok(format!("@{} -------asd", name)),
            CompiledResult::NoReturn => Err(format!("Tried to get llvm string representation of no return value")),
        }
    }    
    pub fn get_temp_value_index(&self) -> Result<usize, String>{
        match self {
            CompiledResult::TempValue(uid, _) => Ok(uid.clone()),
            CompiledResult::Integer(_, _) => Err(format!("Tried to get temp value index from integer")),
            CompiledResult::Function(_, _) => Err(format!("Tried to get temp value index from function")),
            CompiledResult::NoReturn => Err(format!("Tried to get llvm string representation of no return value")),
        }
    }
    pub fn compiler_type(&self, state: &CompilerState) -> Result<CompilerType, String>{
        match self {
            CompiledResult::TempValue(_, typ) => return state.get_compiler_type_from_parser(typ),
            CompiledResult::Integer(_, typ) => return state.get_compiler_type_from_parser(typ),
            CompiledResult::Function(_, typ) => return state.get_compiler_type_from_parser(typ),
            CompiledResult::NoReturn => Err(format!("Tried to get llvm string representation of no return value")),
        }
    }
}

pub fn type_from_expression(x: &Expr) -> Result<ParserType, String>{
    match x {
        Expr::Name(n) => return Ok(ParserType::Named(n.clone())),
        Expr::UnaryOp(UnaryOp::Ref, x) => return Ok(ParserType::Ref(Box::new(type_from_expression(&x)?))),
        _ => todo!("{:?}",x)
    }
} 
pub fn explicit_cast(value: &CompiledResult, to: &ParserType, state: &mut CompilerState) -> Result<CompiledResult, String>{
    let ltype = value.compiler_type(state)?;
    let rtype = state.get_compiler_type_from_parser(&to)?;
    let rtype_true_string = rtype.llvm_representation.to_string();
    match (&ltype.parser_type, to) {
        (ParserType::Named(_), ParserType::Named(_)) => {
            if let CompiledResult::Integer(i, _) = value {
                if to.is_integer() {
                    return Ok(CompiledResult::Integer(i.clone(), to.clone()));
                }
            }
            let utvc = state.aquire_unique_temp_value_counter();
            if !state.implemented_types.contains_key(&to.to_string_core()) {
                return Err(format!("Type \"{:?}\" was not found among implemented types",to));
            }
            if let Some(cast_statement) = ltype.explicit_casts.get(&to.to_string_core()) {
                match cast_statement {
                    Stmt::DirectInsertion(x) =>{
                        let ltvi = value.get_temp_value_index()?;
                        let result = x.replace("{o}", &utvc.to_string())
                        .replace("{v}", &ltvi.to_string());
                        state.output.push_str(&result);
                        return Ok(CompiledResult::TempValue(utvc, to.clone()));
                    }
                    _ => todo!(),
                }
            };
            return Err(format!("No explicit cast exists from type \"{:?}\" to \"{:?}\".", value, to));
        }
        (ParserType::Named(_),ParserType::Ref(_)) => {
            if !ltype.parser_type.is_integer() {
                return Err(format!("Cannot convert from non-integer type to pointer"));
            }
            let utvc = state.aquire_unique_temp_value_counter();
            state.output.push_str(&format!("    %tmp{} = inttoptr {} to {}\n",utvc, value.to_repr_with_type(state)?, rtype_true_string));
            return Ok(CompiledResult::TempValue(utvc, to.clone()));
        }
        (ParserType::Ref(_),ParserType::Named(_)) => {
            if !rtype.parser_type.is_integer() { 
                return Err(format!("Cannot convert from pointer to non-integer type '{}'", to.to_string()));
            }
            let utvc = state.aquire_unique_temp_value_counter();
            state.output.push_str(&format!("    %tmp{} = ptrtoint {} to {}\n",utvc, value.to_repr_with_type(state)?, rtype_true_string));
            return Ok(CompiledResult::TempValue(utvc, to.clone()));
        }
        (ParserType::Ref(_),ParserType::Ref(_)) => {
            let utvc = state.aquire_unique_temp_value_counter();
            state.output.push_str(&format!("    %tmp{} = bitcast {} to {}\n",utvc, value.to_repr_with_type(state)?, rtype_true_string));
            return Ok(CompiledResult::TempValue(utvc, to.clone()));
        }
        _ => {todo!()}
    }
}
pub fn implicit_cast(value: &CompiledResult, to: &ParserType, _state: &mut CompilerState) -> Result<CompiledResult, String>{
    Err(format!("Unable to implisitly cast from \"{:?}\" to \"{:?}\"", &value, to))
}
pub fn compile_rvalue(right: &Expr, expected_type: Expected, state: &mut CompilerState) -> Result<CompiledResult, String>{
    match right {
        Expr::Integer(num) =>{
            if let Expected::Type(x) = expected_type {
                if x.is_integer() {
                    return Ok(CompiledResult::Integer(num.clone(), x.clone()));
                }
                if x.is_pointer() && num == "0" {
                    return Ok(CompiledResult::Integer(format!("null"), x.clone()));
                }
                if x.is_pointer(){
                    let utvc = state.aquire_unique_temp_value_counter();
                    let comp_type = state.get_compiler_type_from_parser(x)?;
                    state.output.push_str(&format!("    %tmp{} = inttoptr i64 {} to {}", utvc, num, comp_type.llvm_representation.to_string()));
                    return Ok(CompiledResult::TempValue(utvc, x.clone()));
                }
            }
            return Ok(CompiledResult::Integer(num.clone(), ParserType::Named(format!("i64"))));
        }
        Expr::Name(name) =>{
            let utvc = state.aquire_unique_temp_value_counter();
            if let Ok(var) = state.get_variable_type(&name) {
                let var_actual_type = var.parser_type.clone();
                let var_repr_type = var.llvm_representation.clone();

                state.output.push_str(&format!("    %tmp{} = load {}, {}* %{}\n", utvc, var_repr_type.to_string(), var_repr_type.to_string(), name));
                return Ok(CompiledResult::TempValue(utvc, var_actual_type));
            }
            if let Ok(var) = state.get_argument_type(&name) {
                let var_actual_type = var.parser_type.clone();
                let var_repr_type = var.llvm_representation.clone();

                state.output.push_str(&format!("    %tmp{} = load {}, {}* %{}.addr\n", utvc, var_repr_type.to_string(), var_repr_type.to_string(), name));
                return Ok(CompiledResult::TempValue(utvc, var_actual_type));  
            }
            return Err(format!("Variable {} was not found un current context", name));
        }
        Expr::Cast(expression, desired_type) =>{
            let result = compile_rvalue(expression, Expected::Type(desired_type), state)?;
            if result.equal_to_type(desired_type) {
                return Ok(result);
            }
            return explicit_cast(&result, desired_type, state);
        }
        Expr::BinaryOp(left, op, right) => {
            let l = compile_rvalue(&left, Expected::Anything, state)?;
            let mut r = compile_rvalue(&right, Expected::Type(&l.get_type()), state)?;
            //if l.value_type.is_integer() && r.value_type.is_integer() && l.value_type != r.value_type {
            //    r = implisit_cast(&r, &l.value_type, state).map_err(|x| format!("while compiling binary expression !{:?}! !{:?}! !{:?}\n{}", left, op, right, x))?;
            //}
            if !l.equal_types(&r) {
                if l.get_type().is_pointer() && r.get_type().is_integer() {
                    let utvc = state.aquire_unique_temp_value_counter();
                    let pointed_to_type = l.get_type().dereference_once();
                    let llvm_pointed_to_type = state.get_compiler_type_from_parser(&pointed_to_type)?
                                                .llvm_representation.to_string();

                    state.output.push_str(&format!("    %tmp{} = getelementptr {}, {}* {}, i64 {}\n",utvc, llvm_pointed_to_type, llvm_pointed_to_type, l.to_repr(), r.to_repr()));
                    return Ok(CompiledResult::TempValue(utvc, l.get_type().clone()));
                }
                return Err(format!("Binary operator '{:?}' cannot be applied to mismatched types '{}' and '{}'",op,l.get_type().to_string(),r.get_type().to_string()));
            }

            if l.equal_types(&r) {
                if l.get_type().is_integer() {

                    let utvc = state.aquire_unique_temp_value_counter();
                    let compiler_type = l.compiler_type(state)?;
                    
                    let is_signed = compiler_type.parser_type.is_signed_integer();

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

                    state.output.push_str(&format!("    %tmp{} = {} {} {}, {}\n",utvc, llvm_op, compiler_type.llvm_representation.to_string(), l.to_repr(), r.to_repr()));
                    let result_type = if llvm_op.starts_with("icmp") {
                        ParserType::Named("bool".to_string())
                    } else {
                        l.get_type().clone()
                    };
                    return Ok(CompiledResult::TempValue(utvc, result_type));
                }
                if l.get_type().is_pointer() {
                    let utvc = state.aquire_unique_temp_value_counter();
                    let llvm_op = match op {
                        BinaryOp::Equal => "icmp eq",
                        BinaryOp::NotEqual => "icmp ne",
                        _ => panic!("Operation \"{:?}\" is not permited on pointers", op)
                    };
                    state.output.push_str(&format!("    %tmp{} = {} ptr {}, {}\n",utvc, llvm_op, l.to_repr(), r.to_repr()));
                    return Ok(CompiledResult::TempValue(utvc, ParserType::Named("bool".to_string())));
                }
                return Err(format!("Binary operator \"{:?}\" was not implemted for types \"{:?}\"", op, l));
            }

            return Err(format!("Binary operator \"{:?}\" cannot be applied to types \"{:?}\" and \"{:?}\"",op, l, r));
        }
        Expr::UnaryOp(op, expr) =>{
            match op {
                UnaryOp::Not => {
                    let value = compile_rvalue(expr, Expected::Anything, state)?;
                    let utvc = state.aquire_unique_temp_value_counter();
                    if value.get_type().to_string() == "bool" {
                        state.output.push_str(&format!("    %tmp{} = xor i1 {}, 1\n", utvc, value.to_repr()));
                        return Ok(CompiledResult::TempValue(utvc, value.get_type().clone()));
                    }
                    if value.get_type().is_integer() {
                        let llvm_type = state.get_compiler_type_from_parser(&value.get_type())?.llvm_representation.to_string();
                        state.output.push_str(&format!("    %tmp{} = icmp eq {} {}, 0\n", utvc, llvm_type, value.to_repr()));
                        return Ok(CompiledResult::TempValue(utvc, ParserType::Named("bool".to_string())));
                    }
                    return Err(format!("Unary NOT '!' operator cannot be applied to type '{:?}'.",value));
                }
                UnaryOp::Negate => {
                    let value = compile_rvalue(expr, Expected::Anything, state)?;
                    if value.get_type().is_signed_integer() {
                        if let CompiledResult::Integer(x, t) = value {
                            return Ok(CompiledResult::Integer(x.parse::<i128>().unwrap().wrapping_neg().to_string(), t));
                        }
                        let utvc = state.aquire_unique_temp_value_counter();
                        let llvm_type = state.get_compiler_type_from_parser(value.get_type())?.llvm_representation.to_string();
                        // In LLVM, integer negation is performed by subtracting from 0.
                        state.output.push_str(&format!( "    %tmp{} = sub {} 0, {}\n",utvc, llvm_type, value.to_repr()));
                        return Ok(CompiledResult::TempValue(utvc, value.get_type().clone()));
                    }
                    if value.get_type().is_unsigned_integer() {
                        return Err(format!("Unary negation '-' cannot be applied to unsigned integer type '{:?}'. Cast to a signed integer first.",value));
                    }
                    return Err(format!("Unary negation '-' cannot be applied to type '{:?}'.",value));
                }
                UnaryOp::Deref =>{
                    let value = compile_rvalue(expr, expected_type, state)?;
                    if !value.get_type().is_pointer() {
                        return Err(format!("Tried to dereference non pointer value {:?}", &value));
                    }
                    let value_deref_type = value.get_type().dereference_once();
                    let underlying_type_representation= state.get_compiler_type_from_parser(&value_deref_type)?.llvm_representation.to_string();
                    let utvc = state.aquire_unique_temp_value_counter();
                    state.output.push_str(&format!("    %tmp{} = load {}, {}* {}\n",utvc, underlying_type_representation, underlying_type_representation, value.to_repr()));
                    return Ok(CompiledResult::TempValue(utvc, value_deref_type));
                }
                UnaryOp::Ref => {
                    let lvalue = compile_lvalue(expr, state)?;
                    let referenced_type = lvalue.get_type().reference_once();
                    return Ok(CompiledResult::TempValue(lvalue.get_temp_value_index()?, referenced_type));
                }
            }
        }
        Expr::Call(left, args) =>{
            if Expr::Name(format!("sizeof")) == **left {
                let size = if args.len() == 1 { state.get_compiler_type_from_parser(&type_from_expression(&args[0])?)?.sizeof(state) } else { return Err(format!("Only 1 argument is allowed. Example: sizeof(&i32);"));};
                if let Expected::Type(x) = expected_type {
                    if x.is_integer() {
                        return Ok(CompiledResult::Integer(size.to_string(), x.clone()));
                    }
                }
                return Ok(CompiledResult::Integer(size.to_string(), ParserType::Named(format!("i64"))));
            }
            if Expr::Name(format!("stalloc")) == **left {
                let right = if args.len() == 1 { &args[0] } else { return Err(format!("Only 1 argument is allowed. Example: stalloc(32);"));};
                let r_val = compile_rvalue(right, Expected::Type(&ParserType::Named(format!("i64"))), state)?;

                let utvc = state.aquire_unique_temp_value_counter();
                state.output.push_str(&format!("    %tmp{} = alloca i8, i64 {}\n",utvc, r_val.to_repr()));
                return Ok(CompiledResult::TempValue(utvc, ParserType::Ref(Box::new(ParserType::Named(format!("i8"))))));
            }
            let call_address = compile_lvalue(left, state)?;
            if let ParserType::Fucntion(return_type, args_type) = call_address.get_type() {
                if args_type.len() != args.len() {
                    return Err(format!("Amount of arguments given {}, does not respond with the amount required {}", args_type.len(), args.len()));
                }
                let mut comps = vec![];
                for i in 0..args.len() {
                    let mut x = compile_rvalue(&args[i], Expected::Type(&args_type[i]),state)?;
                    if *x.get_type() != args_type[i] {
                        x = implicit_cast(&x, &args_type[i], state).map_err(|x| format!("while calling function !{:?}!\n{}", left, x))?;
                    }
                    comps.push(x);
                }
                
                let mut arg_parts = Vec::new();
                for x in comps {arg_parts.push(x.to_repr_with_type(state)?);}

                let return_type = state.get_compiler_type_from_parser(&return_type)?;
                
                let args_string = arg_parts.join(",");
                if Expected::NoReturn == expected_type {
                    state.output.push_str(&format!("    call {} {}({})\n", return_type.llvm_representation.to_string(), call_address.to_repr(), args_string));
                    return Ok(CompiledResult::NoReturn);
                }
                if return_type.parser_type.is_void() {
                    state.output.push_str(&format!("    call void {}({})\n", call_address.to_repr(), args_string));
                    return Ok(CompiledResult::NoReturn);
                }
                let utvc = state.aquire_unique_temp_value_counter();
                state.output.push_str(&format!("    %tmp{} = call {} {}({})\n",utvc, return_type.llvm_representation.to_string(), call_address.to_repr(), args_string));
                return Ok(CompiledResult::TempValue(utvc, return_type.parser_type));
            }
            return Err(format!("Tried to call non-function type"));
        }
        Expr::Member(x, y) =>{
            let member_lvalue = compile_lvalue(&Expr::Member(x.clone(), y.clone()), state)?;
            let utvc = state.aquire_unique_temp_value_counter();
            let member_type_repr = state.get_compiler_type_from_parser(&member_lvalue.get_type())?.llvm_representation.to_string();
            state.output.push_str(&format!("    %tmp{} = load {}, {}* {}\n",utvc, member_type_repr, member_type_repr, member_lvalue.to_repr()));
            return Ok(CompiledResult::TempValue(utvc, member_lvalue.get_type().clone()));
        }
        _ => todo!("{:?}", right)
    }
}
fn compile_lvalue(left: &Expr, state: &mut CompilerState) -> Result<CompiledResult, String>{
    match left {
        Expr::Name(name) => {
            
            let utvc = state.aquire_unique_temp_value_counter();
            if let Ok(var) = state.get_variable_type(&name) {
                let var_actual_type = var.parser_type.clone();
                let var_repr_type = var.llvm_representation.clone();

                state.output.push_str(&format!("    %tmp{} = getelementptr inbounds {}, {}* %{}, i32 0\n", utvc, var_repr_type.to_string(), var_repr_type.to_string(), name));
                return Ok(CompiledResult::TempValue(utvc, var_actual_type));
            }
            if let Ok(var) = state.get_argument_type(&name) {
                let var_actual_type = var.parser_type.clone();
                let var_repr_type = var.llvm_representation.clone();

                state.output.push_str(&format!("    %tmp{} = getelementptr inbounds {}, {}* %{}.addr, i32 0\n", utvc, var_repr_type.to_string(), var_repr_type.to_string(), name));
                return Ok(CompiledResult::TempValue(utvc, var_actual_type));
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
                let args_copy = args.iter().map(|x|x.1.clone()).collect::<Vec<_>>();
                
                let args_string = arg_parts.join(",");
                //state.output.push_str(&format!("    %tmp{} = bitcast {}({})* @{} to ptr\n", utvc, return_type.llvm_representation.to_string(), args_string, name));
                return Ok(CompiledResult::Function(name.clone(), ParserType::Fucntion(Box::new(return_type.parser_type), args_copy)));
            }
            return Err(format!("Name \"{}\" does not respond to function name or variable name in current context",name));
        }
        Expr::UnaryOp(op, expr) =>{
            match op {
                UnaryOp::Deref =>{
                    let pointer_val = compile_rvalue(expr, Expected::Anything, state)?;
                    if !pointer_val.get_type().is_pointer() {
                        return Err(format!("Cannot dereference a non-pointer type: {:?}", pointer_val.get_type()));
                    }
                    let lvalue_type = pointer_val.get_type().dereference_once();
                    return Ok(CompiledResult::TempValue(pointer_val.get_temp_value_index()?, lvalue_type));
                }
                _ => todo!()
            }
        }
        Expr::Member(x, y) =>{
            let base_lval = compile_lvalue(x, state)?;
            let mut aggregate_ptr_tmp = base_lval.get_temp_value_index()?;
            let mut aggregate_type = base_lval.get_type().clone();
            while aggregate_type.is_pointer() {
                let pointer_to_load_type = aggregate_type;
                let pointer_to_load_llvm_type = state.get_compiler_type_from_parser(&pointer_to_load_type)?.llvm_representation.to_string();
                
                let utvc_load = state.aquire_unique_temp_value_counter();
                state.output.push_str(&format!(
                    "    %tmp{} = load {}, {}* %tmp{}\n",
                    utvc_load, pointer_to_load_llvm_type, pointer_to_load_llvm_type, aggregate_ptr_tmp
                ));
                aggregate_ptr_tmp = utvc_load;
                aggregate_type = pointer_to_load_type.dereference_once();
            }
            let struct_compiler_type = state.get_compiler_type_from_parser(&aggregate_type)?;
            if let ParserType::Structure(struct_name, fields) = &struct_compiler_type.struct_representation {
                let field_index = fields.iter().position(|(name, _)| name == y)
                    .ok_or_else(|| format!("Member '{}' not found in struct '{}'", y, struct_name))?;

                let struct_llvm_type_str = struct_compiler_type.llvm_representation.to_string();
                let utvc_gep = state.aquire_unique_temp_value_counter();
                
                state.output.push_str(&format!("    %tmp{} = getelementptr inbounds {}, {}* %tmp{}, i32 0, i32 {}\n",
                    utvc_gep, struct_llvm_type_str, struct_llvm_type_str, aggregate_ptr_tmp, field_index
                ));
                return Ok(CompiledResult::TempValue(utvc_gep, fields[field_index].1.clone()));
            }
            return Err(format!("Cannot access member '{}' on non-struct type '{}'", y, aggregate_type.to_string()));
        }
        _ => todo!()
    }
}


pub fn compile_expression(expression: &Expr, expected_type: Expected, state: &mut CompilerState) -> Result<CompiledResult, String> {

    match expression {
        Expr::UnaryOp(_, _) | Expr::Name(_) | Expr::Integer(_) | Expr::Call(_, _) | Expr::BinaryOp(_, _, _) | Expr::Member(_, _) | Expr::Cast(_, _) =>{
            return compile_rvalue(&expression, expected_type, state);
        }
        Expr::Assign(left, right) => {
            let l = compile_lvalue(&left, state)?;
            let mut r = compile_rvalue(&right, l.get_expected_type(), state)?;
            if !l.equal_types(&r) {
                r = implicit_cast(&r, &l.get_type(), state).map_err(|x| format!("while assigning !{:?}! !EQUAL! !{:?}\n{}", left, right, x))?;
            }
            let l_ut = state.get_compiler_type_from_parser(&l.get_type())?;
            state.output.push_str(&format!("    store {}, {}* {}\n",r.to_repr_with_type(state)?, l_ut.llvm_representation.to_string(), l.to_repr()));
            
            return Ok(CompiledResult::NoReturn);
        }
        _ => {}
    }
    todo!("{:?}",expression);
}