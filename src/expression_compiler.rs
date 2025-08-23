use crate::{compiler::CompilerState, expression_parser::{BinaryOp, Expr, UnaryOp}, parser::ParserType};
#[derive(Debug, Clone, PartialEq)]
pub enum Expected<'a> {
    Type(&'a ParserType),
    Anything,
    NoReturn,
}
#[derive(Debug, Clone, PartialEq)]
pub enum CompiledResult {
    TempValue(u32, ParserType),
    Integer(String, ParserType),
    Argument(String, ParserType),
    Function(String, ParserType, u8),
    NoReturn,
}

impl CompiledResult {
    pub fn get_type(&self) -> &ParserType{
        match self {
            CompiledResult::TempValue(_, x) => x,
            CompiledResult::Integer(_, x) => x,
            CompiledResult::Argument(_, x) => x,
            CompiledResult::Function(_, x, _) => x,
            CompiledResult::NoReturn => unreachable!("Called get_type on NoReturn, catch it beforehand"),
        }
    }
    pub fn equal_types(&self, with: &CompiledResult) -> bool {
        debug_assert_ne!(*self, CompiledResult::NoReturn);
        debug_assert_ne!(*with, CompiledResult::NoReturn);
        return self.get_type() == with.get_type();
    }
    pub fn equal_to_type(&self, to: &ParserType) -> bool{
        match self {
            CompiledResult::TempValue(_, x) => x == to,
            CompiledResult::Integer(_, x) => x == to,
            CompiledResult::Argument(_, x) => x == to,
            CompiledResult::Function(_, x, _) => x == to,
            CompiledResult::NoReturn => unreachable!("Called equal_to_type on NoReturn, catch it beforehand"),
        }
    }
    /// `%x`
    pub fn to_repr(&self) -> String{
        match self {
            CompiledResult::TempValue(uid, _) => format!("%tmp{}", uid),
            CompiledResult::Integer(name, _) => format!("{}", name),
            CompiledResult::Argument(name, _) => format!("%{}", name),
            CompiledResult::Function(name, _, _) => format!("@{}", name),
            CompiledResult::NoReturn => unreachable!("Tried to get llvm string representation of no return value, catch it beforehand"),
        }
    }
    /// `i8* %x`
    pub fn to_repr_with_type(&self, state: &CompilerState) -> Result<String, String>{
        match self {
            CompiledResult::TempValue(uid, typ) => Ok(format!("{} %tmp{}", state.get_llvm_representation_from_parser_type(typ)?, uid)),
            CompiledResult::Integer(name, typ) => Ok(format!("{} {}", state.get_llvm_representation_from_parser_type(typ)?, name)),
            CompiledResult::Argument(name, typ) => Ok(format!("{} %{}", state.get_llvm_representation_from_parser_type(typ)?, name)),
            CompiledResult::Function(name, typ, _) => Ok(format!("{} @{}",state.get_llvm_representation_from_parser_type(typ)?, name)),
            CompiledResult::NoReturn => unreachable!("Tried to get llvm string representation with type of no return value, catch it beforehand"),
        }
    }  
    pub fn get_or_allocate_temp_value_index(&self, state: &mut CompilerState) -> Result<u32, String>{
        match self {
            CompiledResult::TempValue(uid, _) => Ok(uid.clone()),
            CompiledResult::Integer(_, _) => Err(format!("Tried to get temp value index from integer")),
            CompiledResult::Function(_, _, _) => Err(format!("Tried to get temp value index from function")),
            CompiledResult::Argument(a, _) => {
                let utvc = state.aquire_unique_temp_value_counter();
                let val = state.get_variable(a)?;
                state.output.push_str(&format!("%tmp{} = add {} %{} , 0", utvc, state.get_llvm_representation_from_parser_type(&val.get_type(false, false).parser_type)?, a));
                Ok(utvc)
            },
            CompiledResult::NoReturn => unreachable!("Should not be called on NoReturn, catch it beforehand"),
        }
    }
    pub fn set_type(&mut self, new_type: ParserType){
        match self {
            CompiledResult::TempValue(_, t) => *t = new_type,
            CompiledResult::Integer(_, t) => *t = new_type,
            CompiledResult::Argument(_, t) => *t = new_type,
            CompiledResult::Function(_, t, _) => *t = new_type,
            CompiledResult::NoReturn => {},
        }
    }
    pub fn with_type(&self, new_type: ParserType) -> CompiledResult{
        match self {
            CompiledResult::TempValue(x, _) => CompiledResult::TempValue(x.clone(), new_type),
            CompiledResult::Integer(x, _) => CompiledResult::Integer(x.clone(), new_type),
            CompiledResult::Function(x, _, y) => CompiledResult::Function(x.clone(), new_type , *y),
            CompiledResult::Argument(x, _) => CompiledResult::Argument(x.clone(), new_type),
            CompiledResult::NoReturn => CompiledResult::NoReturn,
        }
    }
}

pub fn type_from_expression(x: &Expr) -> Result<ParserType, String>{
    match x {
        Expr::Name(n) => return Ok(ParserType::Named(n.clone())),
        Expr::UnaryOp(UnaryOp::Pointer, x) => return Ok(ParserType::Pointer(Box::new(type_from_expression(&x)?))),
        Expr::StaticAccess(x, y) => return Ok(ParserType::NamespaceLink( type_from_expression(x)?.to_string(), Box::new(ParserType::Named(y.to_string())))),
        _ => todo!("{:?}",x)
    }
}

pub fn explicit_cast(value: &CompiledResult, to: &ParserType, state: &mut CompilerState) -> Result<CompiledResult, String>{
    let ltype = value.get_type();
    if matches!(value, CompiledResult::Integer(_, _)) && to.is_integer() {
        return Ok(value.with_type(to.clone()));
    }
    match (&ltype, to) {
        (ParserType::Named(_), ParserType::Named(_)) => {
            if let Some((ln, rn)) = ltype.both_integers(to) {
                if ln == rn {
                    return Ok(value.with_type(to.clone()));
                }
                let utvc = state.aquire_unique_temp_value_counter();
                if ltype.is_unsigned_integer() {
                    if ln < rn {
                        state.output.push_str(&format!("    %tmp{} = zext i{} {} to i{}", utvc, ln, value.to_repr(),  rn));
                    }else {
                        state.output.push_str(&format!("    %tmp{} = trunc i{} {} to i{}", utvc, ln, value.to_repr(),  rn));
                    }
                }else {
                    if ln < rn {
                        state.output.push_str(&format!("    %tmp{} = sext i{} {} to i{}", utvc, ln, value.to_repr(), rn));
                    }else {
                        state.output.push_str(&format!("    %tmp{} = trunc i{} {} to i{}", utvc, ln, value.to_repr(), rn));
                    }
                }
                return Ok(CompiledResult::TempValue(utvc, to.clone()));
            }
            return Err(format!("No explicit cast exists from type \"{:?}\" to \"{:?}\".", value, to));
        }
        (ParserType::Named(_),ParserType::Pointer(_)) => {
            if !ltype.is_integer() {
                return Err(format!("Cannot convert from non-integer type to pointer"));
            }
            let utvc = state.aquire_unique_temp_value_counter();
            state.output.push_str(&format!("    %tmp{} = inttoptr {} to {}\n",utvc, value.to_repr_with_type(state)?, state.get_llvm_representation_from_parser_type(to)?));
            return Ok(CompiledResult::TempValue(utvc, to.clone()));
        }
        (ParserType::Pointer(_),ParserType::Named(_)) => {
            if !to.is_integer() { 
                return Err(format!("Cannot convert from pointer to non-integer type '{}'", to.to_string()));
            }
            let utvc = state.aquire_unique_temp_value_counter();
            state.output.push_str(&format!("    %tmp{} = ptrtoint {} to {}\n",utvc, value.to_repr_with_type(state)?, state.get_llvm_representation_from_parser_type(to)?));
            return Ok(CompiledResult::TempValue(utvc, to.clone()));
        }
        (ParserType::Pointer(_),ParserType::Pointer(_)) => {
            let utvc = state.aquire_unique_temp_value_counter();
            state.output.push_str(&format!("    %tmp{} = bitcast {} to {}\n",utvc, value.to_repr_with_type(state)?, state.get_llvm_representation_from_parser_type(to)?));
            return Ok(CompiledResult::TempValue(utvc, to.clone()));
        }
        
        _ => {unreachable!()}
    }
}
pub fn implicit_cast(value: &CompiledResult, to: &ParserType, _state: &mut CompilerState) -> Result<CompiledResult, String>{
    Err(format!("Unable to implisitly cast from \"{:?}\" to \"{:?}\"", &value, to))
}

fn compile_rvalue(right: &Expr, expected_type: Expected, state: &mut CompilerState) -> Result<CompiledResult, String>{
    match right {
        Expr::Integer(num) =>{
            if let Expected::Type(x) = expected_type {
                if x.is_integer() {
                    return Ok(CompiledResult::Integer(num.clone(), x.clone()));
                }
                if x.is_pointer() && num == "0" {
                    return Ok(CompiledResult::Integer(format!("null"), x.clone()));
                }
            }
            return Ok(CompiledResult::Integer(num.clone(), ParserType::Named(format!("i64"))));
        }
        Expr::Name(name) =>{
            if let Ok(var) = state.get_variable(&name) {
                let var_comp_type = var.get_type(false, false);
                let var_pars_type = var_comp_type.parser_type.clone();
                if var.is_argument() {
                    return Ok(CompiledResult::Argument(name.clone(), var_pars_type)); 
                }
                let var_representation = state.get_llvm_representation_from_parser_type(&var_pars_type)?;
                let utvc = state.aquire_unique_temp_value_counter();
                state.output.push_str(&format!("    %tmp{} = load {}, {}* %{}\n", utvc, var_representation, var_representation, name));
                return Ok(CompiledResult::TempValue(utvc, var_pars_type));
            }
            return Err(format!("Variable/Argument/Function {} was not found in current context", name));
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
            let r = compile_rvalue(&right, Expected::Type(&l.get_type()), state)?;

            let ltype = l.get_type();

            if !l.equal_types(&r) {
                if l.get_type().is_pointer() && r.get_type().is_integer() {
                    let utvc = state.aquire_unique_temp_value_counter();
                    let pointed_to_type = l.get_type().dereference_once();
                    let llvm_pointed_to_type = state.get_llvm_representation_from_parser_type(&pointed_to_type)?;

                    state.output.push_str(&format!("    %tmp{} = getelementptr {}, {}* {}, i64 {}\n", utvc, llvm_pointed_to_type, llvm_pointed_to_type, l.to_repr(), r.to_repr()));
                    return Ok(CompiledResult::TempValue(utvc, l.get_type().clone()));
                }
                return Err(format!("Binary operator '{:?}' cannot be applied to mismatched types '{}' and '{}'",op,l.get_type().to_string(),r.get_type().to_string()));
            }

            if l.equal_types(&r) {
                if ltype.is_integer() || ltype.is_bool() {

                    let utvc = state.aquire_unique_temp_value_counter();
                    
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

                    let repr = state.get_llvm_representation_from_parser_type(ltype)?;
                    state.output.push_str(&format!("    %tmp{} = {} {} {}, {}\n",utvc, llvm_op, repr, l.to_repr(), r.to_repr()));
                    let result_type = if llvm_op.starts_with("icmp") {
                        ParserType::Named("bool".to_string())
                    } else {
                        l.get_type().clone()
                    };
                    return Ok(CompiledResult::TempValue(utvc, result_type));
                }
                if ltype.is_pointer() {
                    let utvc = state.aquire_unique_temp_value_counter();
                    let llvm_op = match op {
                        BinaryOp::Equals => "icmp eq",
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
                        let llvm_type = state.get_llvm_representation_from_parser_type(&value.get_type())?;
                        state.output.push_str(&format!("    %tmp{} = icmp eq {} {}, 0\n", utvc, llvm_type, value.to_repr()));
                        return Ok(CompiledResult::TempValue(utvc, ParserType::Named("bool".to_string())));
                    }
                    return Err(format!("Unary NOT '!' operator cannot be applied to type '{:?}'.",value));
                }
                UnaryOp::Negate => {
                    let value = compile_rvalue(expr, Expected::Anything, state)?;
                    if value.get_type().is_signed_integer() {
                        if let CompiledResult::Integer(x, t) = &value {
                            let int = x.parse::<i128>().unwrap();
                            let negated_int = int.wrapping_neg();
                            let negated_int_string = negated_int.to_string();
                            if Expected::Type(&t) == expected_type {
                                return Ok(CompiledResult::Integer(negated_int_string, t.clone()));
                            }else if Expected::Anything == expected_type{
                                return Ok(CompiledResult::Integer(negated_int_string, t.clone()));
                            }else if let Expected::Type(ty) = expected_type {
                                if ty.is_integer() {
                                    return Ok(CompiledResult::Integer(negated_int_string, ty.clone()));
                                }else if ty.is_pointer() {
                                    let utvc = state.aquire_unique_temp_value_counter();
                                    let llvm_type = state.get_llvm_representation_from_parser_type(ty)?;
                                    state.output.push_str(&format!("    %tmp{} = inttoptr i64 {} to {}\n",utvc, 0u64.wrapping_sub(int as u64).to_string(), llvm_type));
                                    return Ok(CompiledResult::TempValue(utvc, ty.clone()));
                                }
                            }
                            return implicit_cast(&value, &t, state);
                        }
                        let utvc = state.aquire_unique_temp_value_counter();
                        let llvm_type = state.get_llvm_representation_from_parser_type(value.get_type())?;

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
                    let underlying_type_representation= state.get_llvm_representation_from_parser_type(&value_deref_type)?;
                    let utvc = state.aquire_unique_temp_value_counter();
                    state.output.push_str(&format!("    %tmp{} = load {}, {}* {}\n",utvc, underlying_type_representation, underlying_type_representation, value.to_repr()));
                    return Ok(CompiledResult::TempValue(utvc, value_deref_type));
                }
                UnaryOp::Pointer => {
                    let mut lvalue = compile_lvalue(expr, false, false, state)?;
                    let referenced_type = lvalue.get_type().reference_once();
                    lvalue.set_type(referenced_type);
                    return Ok(lvalue);
                }
            }
        }
        Expr::Call(left, args) =>{
            if let Expr::Name(func_name) = &**left {
                if func_name == "sizeof" {
                    if args.len() != 1 { return Err(format!("sizeof expects exactly 1 type argument. Example: sizeof(i32);"));}
                    let size = state.get_sizeof(&type_from_expression(&args[0])?)?;
                    if let Expected::Type(x) = expected_type {
                        if x.is_integer() { return Ok(CompiledResult::Integer(size.to_string(), x.clone())); }
                    }
                    return Ok(CompiledResult::Integer(size.to_string(), ParserType::Named(format!("i64"))));
                }
                if func_name == "stalloc" {
                    if args.len() != 1 { return Err(format!("stalloc expects exactly 1 size argument. Example: stalloc(32);"));};
                    let r_val = compile_rvalue(&args[0], Expected::Type(&ParserType::Named(format!("i64"))), state)?;
                    let utvc = state.aquire_unique_temp_value_counter();
                    state.output.push_str(&format!("    %tmp{} = alloca i8, i64 {}\n",utvc, r_val.to_repr()));
                    return Ok(CompiledResult::TempValue(utvc, ParserType::Pointer(Box::new(ParserType::Named(format!("i8"))))));
                }
            }
            
            let call_address = compile_lvalue(left, false, false, state)?;
            if let ParserType::Function(return_type, args_type) = call_address.get_type() {
                let mut args = args.clone();
                if let Expr::MemberAccess(instance, _) = left.as_ref() {
                    if crate::ALLOW_EXTENTION_FUNCTIONS {
                        args.insert(0, Expr::UnaryOp(UnaryOp::Pointer, instance.clone()));
                    }else {
                        return Err(format!("Extention function use is not allowed"));
                    }
                }
                if args_type.len() != args.len() {
                    return Err(format!("Amount of arguments given {}, does not respond with the amount required {}", args.len(), args_type.len(),));
                }
                let mut comps = vec![];
                for i in 0..args.len() {
                    let mut x = compile_rvalue(&args[i], Expected::Type(&args_type[i]),state)?;
                    if !x.equal_to_type(&args_type[i]) {
                        x = implicit_cast(&x, &args_type[i], state).map_err(|x| format!("while calling function !{:?}!\n{}", left, x))?;
                    }
                    comps.push(x);
                }
                
                let mut arg_parts = Vec::new();
                for x in comps {arg_parts.push(x.to_repr_with_type(state)?);}

                let return_type_repr = state.get_llvm_representation_from_parser_type(&return_type)?;
                
                let args_string = arg_parts.join(",");
                if Expected::NoReturn == expected_type {
                    state.output.push_str(&format!("    call {} {}({})\n", return_type_repr, call_address.to_repr(), args_string));
                    return Ok(CompiledResult::NoReturn);
                }
                if return_type.is_void() {
                    state.output.push_str(&format!("    call void {}({})\n", call_address.to_repr(), args_string));
                    return Ok(CompiledResult::NoReturn);
                }
                let utvc = state.aquire_unique_temp_value_counter();
                state.output.push_str(&format!("    %tmp{} = call {} {}({})\n",utvc, return_type_repr, call_address.to_repr(), args_string));
                return Ok(CompiledResult::TempValue(utvc, *return_type.clone()));
            }
            return Err(format!("Tried to call non-function type"));
        }
        Expr::MemberAccess(x, y) =>{
            let member_lvalue = compile_lvalue(&Expr::MemberAccess(x.clone(), y.clone()), false, false, state)?;
            let utvc = state.aquire_unique_temp_value_counter();
            let member_type_repr = state.get_llvm_representation_from_parser_type(&member_lvalue.get_type())?;
            state.output.push_str(&format!("    %tmp{} = load {}, {}* {}\n",utvc, member_type_repr, member_type_repr, member_lvalue.to_repr()));
            return Ok(CompiledResult::TempValue(utvc, member_lvalue.get_type().clone()));
        }
        Expr::StringConst(x) => {
            let unique_constant_string_counter = state.aquire_unique_const_vector_counter();
            state.output.push_str_header(&format!("@.str{} = internal constant [{} x i8] c\"{}\\00\"\n", unique_constant_string_counter, x.len() + 1, x));
            let utvc = state.aquire_unique_temp_value_counter();
            state.output.push_str(&format!("    %tmp{} = getelementptr inbounds [{} x i8], ptr @.str{}, i64 0, i64 0\n", utvc, x.len() + 1, unique_constant_string_counter));
            return Ok(CompiledResult::TempValue(utvc, ParserType::Pointer(Box::new(ParserType::Named(format!("i8"))))));
        }
        _ => todo!("{:?}", right)
    }
}
fn compile_lvalue(left: &Expr, write_to_address: bool, modify_content: bool, state: &mut CompilerState) -> Result<CompiledResult, String>{
    match left {
        Expr::Name(name) => {
            if let Ok(var) = state.get_variable(&name) { // Variable
                let var_comp_type = var.get_type(write_to_address, modify_content);
                let var_pars_type = var_comp_type.parser_type.clone();
                if var.is_argument() {
                    if write_to_address {
                        return Err(format!("Tried to rewrite data of argument {}", name));
                    }
                    return Ok(CompiledResult::Argument(name.clone(), var_pars_type));
                }
                let var_representation = state.get_llvm_representation_from_parser_type(&var_pars_type)?;
                let utvc = state.aquire_unique_temp_value_counter();
                state.output.push_str(&format!("    %tmp{} = getelementptr inbounds {}, {}* %{}, i32 0\n", utvc, var_representation, var_representation, name));
                return Ok(CompiledResult::TempValue(utvc, var_pars_type));
            }
            if let Ok(func) = state.get_function_from_path(state.get_current_path(), &name) { // Function
                let func_type = ParserType::Function(
                    Box::new(func.return_type.clone()),
                    func.args.iter().map(|(_, t)| t.clone()).collect()
                );
                if func.is_imported() {
                    return Ok(CompiledResult::Function(func.name.clone(), func_type, func.flags()));
                }
                return Ok(CompiledResult::Function(func.effective_name(), func_type, func.flags()));
            }
            return Err(format!("Name \"{}\" does not respond to function, argument or variable name in current context",name));
        }
        Expr::UnaryOp(op, expr) =>{
            match op {
                UnaryOp::Deref =>{
                    let mut pointer_val = compile_rvalue(expr, Expected::Anything, state)?;
                    if !pointer_val.get_type().is_pointer() {
                        return Err(format!("Cannot dereference a non-pointer type: {:?}", pointer_val.get_type()));
                    }
                    let lvalue_type = pointer_val.get_type().dereference_once();
                    pointer_val.set_type(lvalue_type);
                    return Ok(pointer_val);
                }
                UnaryOp::Pointer =>{
                    let pointer_val = compile_lvalue(expr, write_to_address, false, state)?;
                    let var_repr_type = state.get_llvm_representation_from_parser_type(pointer_val.get_type())?;
                    let utvc = state.aquire_unique_temp_value_counter();
                    state.output.push_str(&format!("    %tmp{} = load {}*, {}", utvc, var_repr_type, pointer_val.to_repr_with_type(state)?));
                    
                    return Ok(CompiledResult::TempValue(utvc, pointer_val.get_type().reference_once()));
                }
                _ => return Err(format!("{:?} {:?}", op, expr))
            }
        }
        Expr::MemberAccess(x, y) =>{
            let base_lval = compile_lvalue(x, false, write_to_address, state)?;
            if base_lval.get_type().is_pointer() {
                let t = base_lval.get_type().dereference_once();
                let utvc_gep = state.aquire_unique_temp_value_counter();
                let struct_compiler_type = state.get_struct_representaition_from_parser_type(&t)?;
                
                let struct_name = &struct_compiler_type.0;
                let fields = &struct_compiler_type.1;

                if let Some(field_index) = fields.iter().position(|(name, _)| name == y){
                    let struct_llvm_type_str = state.get_llvm_representation_from_parser_type(&t)?;
                    let field_type = fields[field_index].1.clone();
                    state.output.push_str(&format!("    %tmp{} = getelementptr inbounds {}, {}* {}, i32 0, i32 {}\n",
                        utvc_gep, struct_llvm_type_str, struct_llvm_type_str, base_lval.to_repr(), field_index
                    ));
                    return Ok(CompiledResult::TempValue(utvc_gep, field_type));
                }
                return Err(format!("Member/Extended function was '{}' not found in struct '{}'", y, struct_name));
            }
            let mut aggregate_type = base_lval.get_type().clone();
            let mut aggregate_ptr_tmp = base_lval.get_or_allocate_temp_value_index(state)?;
            while aggregate_type.is_pointer() {
                let pointer_to_load_type = aggregate_type;
                let pointer_to_load_llvm_type = state.get_llvm_representation_from_parser_type(&pointer_to_load_type)?;
                
                let utvc_load = state.aquire_unique_temp_value_counter();
                state.output.push_str(&format!(
                    "    %tmp{} = load {}, {}* %tmp{}\n",
                    utvc_load, pointer_to_load_llvm_type, pointer_to_load_llvm_type, aggregate_ptr_tmp
                ));
                aggregate_ptr_tmp = utvc_load;
                aggregate_type = pointer_to_load_type.dereference_once();
            }
            let struct_compiler_type = state.get_struct_representaition_from_parser_type(&aggregate_type)?;

            let struct_name = &struct_compiler_type.0;
            let fields = &struct_compiler_type.1;
            let extentions = &struct_compiler_type.2;
            if let Some(field_index) = fields.iter().position(|(name, _)| name == y){
                let struct_llvm_type_str = state.get_llvm_representation_from_parser_type(&aggregate_type)?;
                let utvc_gep = state.aquire_unique_temp_value_counter();
                let field_type = fields[field_index].1.clone();
                state.output.push_str(&format!("    %tmp{} = getelementptr inbounds {}, {}* %tmp{}, i32 0, i32 {}\n",
                    utvc_gep, struct_llvm_type_str, struct_llvm_type_str, aggregate_ptr_tmp, field_index
                ));
                return Ok(CompiledResult::TempValue(utvc_gep, field_type));
            }
            if let Some(extention_index) = extentions.iter().position(|(name, _)| name == y) {
                let x = extentions[extention_index].clone();
                return Ok(CompiledResult::Function(x.0.clone(), ParserType::Function(Box::new(x.1.0), x.1.1), 0));
            }
            return Err(format!("Member/Extended function was '{}' not found in struct '{}'", y, struct_name));
        }
        Expr::StaticAccess(x, y) =>{
            let mut path = String::new();
            if let Expr::Name(ns) = &**x {
                path.push_str(&ns);
            }else {
                fn rec(x: &Box::<Expr>, out: &mut String){
                    match x.as_ref() {
                        Expr::Name(x) => out.push_str(&x),
                        Expr::StaticAccess(x, y) => {rec(x, out); out.push('.'); out.push_str(&y)},
                        _ => panic!()
                    }
                }
                rec(x, &mut path);
            }
            let x = state.get_current_path().to_string();
            state.set_current_path(&path);
            let r= compile_lvalue(&Expr::Name(y.clone()), write_to_address, modify_content, state)?;
            state.set_current_path(&x);
            return Ok(r);
        }
        _ => todo!("{:?}", left)
    }
}

pub fn compile_expression(expression: &Expr, expected_type: Expected, state: &mut CompilerState) -> Result<CompiledResult, String> {
    match expression {
        Expr::Assign(left, right) => {
            let l = compile_lvalue(&left, true, true, state)?;
            let mut r = compile_rvalue(&right, Expected::Type(l.get_type()), state)?;
            if !l.equal_types(&r) {
                r = implicit_cast(&r, &l.get_type(), state).map_err(|x| format!("while assigning !{:?}! !EQUAL! !{:?}\n{}", left, right, x))?;
            }
            let l_ut = state.get_llvm_representation_from_parser_type(&l.get_type())?;

            state.output.push_str(&format!("    store {}, {}* {}\n", r.to_repr_with_type(state)?, l_ut, l.to_repr()));
            
            return Ok(CompiledResult::NoReturn);
        }
        _ =>{
            return compile_rvalue(&expression, expected_type, state);
        }
    }
}