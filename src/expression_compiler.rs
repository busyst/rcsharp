use std::{collections::HashMap};

use rcsharp_parser::{compiler_primitives::{DEFAULT_DECIMAL_TYPE, DEFAULT_INTEGER_TYPE, BOOL_TYPE, BYTE_TYPE, CHAR_TYPE, Layout}, expression_parser::{BinaryOp, Expr, UnaryOp}, parser::{ParserType, Stmt}};
use crate::{compiler::{CodeGenContext, CompileError, CompileResult, INTERGER_EXPRESION_OPTIMISATION, LLVMOutputHandler, SymbolTable, get_llvm_type_str, substitute_generic_type}, compiler_essentials::{FunctionView, StructView, Variable}};

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
    Type(&'a ParserType),
    Anything,
    NoReturn,
}
impl<'a> Expected<'a> {
    pub fn get_type(&self) -> Option<&'a ParserType>{
        match self {
            Self::Type(x) => Some(x),
            _ => None
        }
    }
}
#[derive(Debug, Clone, PartialEq)]
pub enum LLVMVal {
    Register(u32),    // %tmp1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
    Variable(u32),    // %v1
    VariableName(String),    // %smt
    Global(String),   // @func_name
    Constant(String), // 42, 0.5
    Null, // null
    Void, // void
}
impl std::fmt::Display for LLVMVal {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            LLVMVal::Register(id) => write!(f, "%tmp{}", id),
            LLVMVal::Variable(id) => write!(f, "%v{}", id),
            LLVMVal::VariableName(name) => write!(f, "%{}", name),
            LLVMVal::Global(name) => write!(f, "@{}", name),
            LLVMVal::Constant(constant) => write!(f, "{}", constant),
            LLVMVal::Void => write!(f, "void"),
            LLVMVal::Null => write!(f, "null"),
        }
    }
}
#[derive(Debug, Clone, PartialEq)]
pub enum CompiledValue {
    Value {
        llvm_repr: LLVMVal,
        ptype: ParserType,
    },
    Pointer {
        llvm_repr: LLVMVal,
        ptype: ParserType,
    },
    Function {
        effective_internal_name: String,
    },
    GenericFunction {
        effective_internal_name: String,
    },
    GenericFunctionImplementation {
        effective_internal_name: String,
        types: Box<[ParserType]>,
    },
    NoReturn,
}

impl CompiledValue {
    pub fn get_type(&self) -> &ParserType {
        match self {
            Self::Value { ptype, .. } => ptype,
            Self::Pointer { ptype, .. } => ptype,
            Self::Function { .. } => panic!("Why"),
            Self::GenericFunction { .. } => panic!("Why Generic"),
            Self::GenericFunctionImplementation { .. } => panic!("Why Generic Implementation"),
            Self::NoReturn => panic!("Cannot get type of NoReturn value"),
        }
    }
    pub fn get_llvm_repr_with_type(&self, ctx: &CodeGenContext) -> CompileResult<String> {
        let type_str = get_llvm_type_str(self.get_type(), ctx.symbols, &ctx.current_function_path)?;
        let repr = self.get_llvm_rep();
        
        match self {
            Self::Pointer { .. } => Ok(format!("{}* {}", type_str, repr)),
            _ => Ok(format!("{} {}", type_str, repr)),
        }
    }
    pub fn get_llvm_rep(&self) -> &LLVMVal{
        match self {
            Self::Value { llvm_repr, ..} => llvm_repr,
            Self::Pointer { llvm_repr, ..} => llvm_repr,
            _ => panic!()
        }
    }
    pub fn clone_with_type(&self, new_type: ParserType) -> Self {
        match self {
            Self::Value { llvm_repr, .. } => Self::Value { llvm_repr: llvm_repr.clone(), ptype: new_type },
            Self::Pointer { llvm_repr, .. } => Self::Pointer { llvm_repr: llvm_repr.clone(), ptype: new_type },
            Self::Function { .. } => self.clone(),
            Self::GenericFunction { .. } => self.clone(),
            Self::GenericFunctionImplementation { .. } => self.clone(),
            Self::NoReturn => panic!("with_type is not applicable to NoReturn"),
        }
    }
    pub fn is_literally_number(&self) -> bool {
        if let CompiledValue::Value { llvm_repr: LLVMVal::Constant(x), ..} = self {
            return x.chars().all(|c| c.is_ascii_digit() || c == '-');
        }
        false
    }
    pub fn no_return_check(&self) -> CompileResult<()>{
        if *self == Self::NoReturn {
            return Err(CompileError::InvalidExpression("Tried to use void value".to_string()));
        }
        Ok(())
    }
}

pub fn compile_expression(expr: &Expr, expected: Expected, ctx: &mut CodeGenContext, output: &mut LLVMOutputHandler) -> CompileResult<CompiledValue> {
    ExpressionCompiler::new(ctx, output).compile_rvalue(expr, expected).map_err(|x| 
        CompileError::Generic(format!("{}\nin expression: {:?}",x , expr))
    )
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
            Expr::StaticAccess(..) => self.compile_static_access_rvalue(expr),
            Expr::StringConst(str_val) => self.compile_string_literal(str_val),
            Expr::Index(..) => self.compile_index_rvalue(expr),
            Expr::Type(..) => unreachable!(),
            Expr::Boolean(value) => self.compile_boolean(*value),
            Expr::NullPtr => self.compile_null(expected),
        }
    }
    fn compile_lvalue(&mut self, expr: &Expr, write: bool, modify_content: bool) -> CompileResult<CompiledValue> {
        match expr {
            Expr::Name(name) => self.compile_name_lvalue(name, write, modify_content),
            Expr::NameWithGenerics(name, generics) => self.compile_name_with_generics_lvalue(name, generics, write, modify_content),
            Expr::StaticAccess(..) => self.compile_static_access_lvalue(expr, write, modify_content),
            Expr::MemberAccess(obj, member) => self.compile_member_access_lvalue(obj, member, write, modify_content),
            Expr::UnaryOp(UnaryOp::Deref, operand) => self.compile_deref_lvalue(operand, write, modify_content),
            Expr::Index(array, index) => self.compile_index_lvalue(array, index, write, modify_content),
            Expr::BinaryOp(..) => self.compile_rvalue(expr, Expected::Anything),
            Expr::Type(r_type) => self.compile_type(r_type),
            _ => Err(CompileError::Generic(format!("Expression {:?} is not a valid lvalue", expr))),
        }
    }
    // ----------------------======++$$@RVALUE@$$++======-----------------
    fn compile_boolean(&mut self, value: bool) -> CompileResult<CompiledValue> {
        return Ok(CompiledValue::Value { llvm_repr: LLVMVal::Constant(format!("{}", value as i8)), ptype: BOOL_TYPE.into() });
    }
    fn compile_null(&mut self, expected: Expected<'_>) -> CompileResult<CompiledValue> {
        if let Some(ptype) = expected.get_type().map(|x| x.as_pointer()).flatten() {
            return Ok(CompiledValue::Value { llvm_repr: LLVMVal::Null, ptype: ParserType::Pointer(Box::new(ptype.clone())) });
        }
        return Err(CompileError::Generic("Wrong use of null".to_string()));
    }
    fn compile_binary_op(&mut self, lhs: &Expr, op: &BinaryOp, rhs: &Expr, expected: Expected<'_>) -> CompileResult<CompiledValue> {
        debug_assert!(expected != Expected::NoReturn);
        if INTERGER_EXPRESION_OPTIMISATION {
            if let Ok(x) = constant_integer_expression_compiler(&Expr::BinaryOp(Box::new(lhs.clone()), *op, Box::new(rhs.clone())), self.ctx.symbols) {
                if let Some(ptype) = expected.get_type().cloned() {
                    return Ok(CompiledValue::Value { llvm_repr: LLVMVal::Constant(x.to_string()), ptype });
                }
                return Ok(CompiledValue::Value { llvm_repr: LLVMVal::Constant(x.to_string()), ptype: DEFAULT_INTEGER_TYPE.into() });
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
            && right.get_type().dereference_full().is_integer() {
            (right, left) = (left, right);
            right = right.clone_with_type(left.get_type().clone());
        }
        // Pointer math
        if left.get_type().is_pointer() && right.get_type().is_integer() {  // *(array_pointer + iterator)
            assert!(matches!(op, BinaryOp::Add));
            let utvc = self.ctx.aquire_unique_temp_value_counter();
            let pointed_to_type = left.get_type().try_dereference_once();
            let llvm_pointed_to_type = get_llvm_type_str(pointed_to_type, self.ctx.symbols, &self.ctx.current_function_path)?;

            self.output.push_str(&format!("    %tmp{} = getelementptr {}, {}, {}\n", utvc, llvm_pointed_to_type, left.get_llvm_repr_with_type(self.ctx)?, right.get_llvm_repr_with_type(self.ctx)?));
            return Ok(CompiledValue::Value{llvm_repr: LLVMVal::Register(utvc), ptype: left.get_type().clone()});
        }
        if left.get_type() != right.get_type() {
            return Err(CompileError::Generic(format!("Binary operator '{:?}' cannot be applied to mismatched types '{}' and '{}'", op, left.get_type().debug_type_name(), right.get_type().debug_type_name())));
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
            return Ok(CompiledValue::Value { llvm_repr: LLVMVal::Register(utvc), ptype: BOOL_TYPE.into() });
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

            let both_types_llvm_repr = get_llvm_type_str(ltype, self.ctx.symbols, &self.ctx.current_function_name)?;
            let utvc = self.ctx.aquire_unique_temp_value_counter();
            self.output.push_str(&format!("    %tmp{} = {} {} {}, {}\n",utvc, llvm_op, both_types_llvm_repr, left.get_llvm_rep(), right.get_llvm_rep()));

            let result_type = if llvm_op.starts_with("icmp") {
                BOOL_TYPE.into()
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
            let both_types_llvm_repr = get_llvm_type_str(ltype, self.ctx.symbols, &self.ctx.current_function_name)?;
            let utvc = self.ctx.aquire_unique_temp_value_counter();
            self.output.push_str(&format!("    %tmp{} = {} {} {}, {}\n",utvc, llvm_op, both_types_llvm_repr, left.get_llvm_rep(), right.get_llvm_rep()));
            let result_type = if llvm_op.starts_with("fcmp") {
                BOOL_TYPE.into()
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
            return Ok(CompiledValue::Value { llvm_repr: LLVMVal::Register(utvc), ptype: BOOL_TYPE.into() });
        }
        
        Err(CompileError::Generic(format!("Binary operator \"{:?}\" was not implemted for types \"{:?}\"", op, left)))
    }
    fn compile_call_generic(&mut self, callee: &Expr, given_args: &[Expr], given_generic: &[ParserType], expected: Expected<'_>) -> CompileResult<CompiledValue> {
        if let Some(x) = self.compiler_function_calls_generic(callee, given_args, given_generic, &expected) {
            return x;
        }
        let l: CompiledValue = self.compile_lvalue(callee, false, false)?;
        if let CompiledValue::GenericFunction { effective_internal_name: effective_name} = &l {
            
            let func = self.ctx.symbols.get_bare_function(effective_name, &self.ctx.current_function_path, false)
                .ok_or(CompileError::Generic(format!("Function (effective path):({}) couldnt be found inside:({}.{})",effective_name,self.ctx.current_function_path, self.ctx.current_function_name)))?;
            let required_arguments = func.args().iter().map(|x| x.1.clone()).collect::<Vec<_>>();
            if func.generic_params().len() != given_generic.len() {
                return Err(CompileError::Generic(format!("Amount of generic params provided '{}' does not equal to amount requested by function '{}'", required_arguments.len(), given_args.len())));
            }
            let given_generic = given_generic.iter().map(|x| substitute_generic_type(x, &self.ctx.symbols.alias_types)).collect::<Vec<_>>();
            
            
            let mut type_map = HashMap::new();
            for (ind, prm) in func.generic_params().iter().enumerate() {
                if self.ctx.symbols.get_bare_type(given_generic[ind].type_name().as_str()).is_none() {
                    type_map.insert(prm.clone(), ParserType::NamespaceLink(self.ctx.current_function_path.to_string(), Box::new(given_generic[ind].clone())));
                }else {
                    type_map.insert(prm.clone(), given_generic[ind].clone());
                }
            }

            let func = self.ctx.symbols.get_generic_function(effective_name, &self.ctx.current_function_path, &type_map)
                .ok_or(CompileError::Generic(format!("Function (effective path):({}) couldnt be found inside:({}.{})",effective_name,self.ctx.current_function_path, self.ctx.current_function_name)))?;
            
            let symbols = self.ctx.symbols;
            let current_namespace = &self.ctx.current_function_path;
            
            let llvm_struct_name = format!("{}<{}>", func.llvm_name(), given_generic.iter().map(|x| get_llvm_type_str(x, symbols, current_namespace)).collect::<CompileResult<Vec<_>>>()?.join(", "));
            
            

            let return_type_repr = get_llvm_type_str(func.return_type(), symbols, current_namespace)?;
            let mut compiled_arguments = vec![];
            let required_arguments = required_arguments.iter().map(|x| substitute_generic_type(x, &type_map)).collect::<Vec<_>>();
            for i in 0..required_arguments.len() {
                let sub = substitute_generic_type(&required_arguments[i], &self.ctx.symbols.alias_types);
                let x = self.compile_rvalue(&given_args[i], Expected::Type(&sub))?;
                if *x.get_type() != sub {
                    return CompileResult::Err(CompileError::InvalidExpression(format!("Expected {:?} vs got {:?} type missmatch with {}th argument", required_arguments[i].debug_type_name(), x.get_type().debug_type_name(), i + 1)));
                }
                compiled_arguments.push(x.get_llvm_repr_with_type(self.ctx)?);
            }
            let arg_string = compiled_arguments.join(", ");

            if func.return_type().is_void() {
                self.output.push_str(&format!("    call void @\"{}\"({})\n", llvm_struct_name, arg_string));
                return Ok(CompiledValue::NoReturn);
            }
            if expected != Expected::NoReturn {
                let utvc = self.ctx.aquire_unique_temp_value_counter();
                self.output.push_str(&format!("    %tmp{} = call {} @\"{}\"({})\n", utvc, return_type_repr, llvm_struct_name, arg_string));
                return Ok(CompiledValue::Value { llvm_repr: LLVMVal::Register(utvc), ptype: func.return_type().clone() });
            }
            self.output.push_str(&format!("    call {} @\"{}\"({})\n", return_type_repr, llvm_struct_name, arg_string));
            return Ok(CompiledValue::NoReturn);
        }
        Err(CompileError::Generic(String::new()))
    }
    fn compile_call(&mut self, callee: &Expr, given_args: &[Expr], expected: Expected<'_>) -> CompileResult<CompiledValue> {
        if let Some(x) = self.compiler_function_calls(callee, given_args, &expected) {
            return x;
        }
        let l: CompiledValue = self.compile_lvalue(callee, false, false)?;
        if let CompiledValue::Function { effective_internal_name: effective_name} = &l {
            let func = self.ctx.symbols.get_bare_function(effective_name, &self.ctx.current_function_path, false)
                .ok_or(CompileError::Generic(format!("Function ({}) not found", effective_name)))?;
            let required_arguments = func.args().iter().map(|x| x.1.clone()).collect::<Vec<_>>();
            let return_type = func.return_type();
            if required_arguments.len() != given_args.len() {
                return Err(CompileError::Generic(format!("Argument count mismatch: expected {}, got {}", required_arguments.len(), given_args.len())));
            }
            let return_type_repr = get_llvm_type_str(return_type, self.ctx.symbols, func.path())?;
            
            if func.is_inline() {
                if func.body().is_empty() {
                    if func.return_type().is_void() {
                        return Ok(CompiledValue::NoReturn);
                    }
                    return Err(CompileError::Generic(format!("Inline function '{}' body was empty but return type is not void", func.full_path())));
                }
                let inline_exit = self.ctx.aquire_unique_logic_counter();
                let return_tmp = self.ctx.aquire_unique_temp_value_counter();
                if !func.return_type().is_void() {
                    self.output.push_str(&format!("    %iv{} = alloca {}\n", return_tmp, return_type_repr));
                }
                let mut prepared_args = vec![];
                for i in 0..required_arguments.len() {
                    let x = self.compile_rvalue(&given_args[i], Expected::Type(&required_arguments[i]))?;
                    let arg_name = &func.args()[i].0;
                    match &x {
                        CompiledValue::Value { llvm_repr, ptype } =>{
                            match llvm_repr {
                                LLVMVal::Variable(_) =>{
                                    let utvc = self.ctx.aquire_unique_temp_value_counter();
                                    let repr = get_llvm_type_str(ptype, self.ctx.symbols, func.path())?;
                                    self.output.push_str(&format!("    %tmp{} = bitcast {}* {} to {}*\n", utvc, repr, llvm_repr, repr));
                                    prepared_args.push((arg_name, ptype.clone(), utvc));
                                }
                                LLVMVal::Register(n) =>{
                                    prepared_args.push((arg_name, ptype.clone(), *n));
                                }
                                _ => todo!("{:?}", llvm_repr)
                            }
                            continue;
                        }
                        _ => panic!()
                    }
                }

                let lp = self.ctx.current_function_path.clone();
                self.ctx.current_function_path = func.path().to_string();
                let og_scope = self.ctx.scope.clone();
                self.ctx.scope.clear();
                for arg in prepared_args {
                    self.ctx.scope.add_variable(arg.0.to_string(), Variable::new_alias(arg.1.clone()), arg.2);
                }
                for x in func.body() {
                    match &x.stmt {
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
                            assert!(x.is_none() || !func.return_type().is_void());
                            assert!(!x.is_none() || func.return_type().is_void());
                            if let Some(x) = x {
                                let expected_type = func.return_type();
                                let value = compile_expression(x, Expected::Type(expected_type), self.ctx, self.output)?;
                                
                                let llvm_type_str = get_llvm_type_str(expected_type, self.ctx.symbols, &self.ctx.current_function_path)?;
                                self.output.push_str(&format!("    store {} {}, {}* %iv{}\n", llvm_type_str, value.get_llvm_rep(), llvm_type_str, return_tmp));
                                continue;
                            }
                            self.output.push_str(&format!("    br label %inline_exit{}\n",inline_exit));
                        }
                        _ => crate::compiler::compile_statement(&x.stmt, self.ctx, self.output)?,
                    }
                }
                self.output.push_str(&format!("    br label %inline_exit{}\n",inline_exit));
                self.output.push_str(&format!("inline_exit{}:\n", inline_exit));
                self.ctx.scope = og_scope;
                self.ctx.current_function_path = lp;

                if return_type.is_void() {
                    return Ok(CompiledValue::NoReturn);
                }
                let rv_utvc = self.ctx.aquire_unique_temp_value_counter();
                self.output.push_str(&format!("    %tmp{} = load {}, {}* %iv{}\n",rv_utvc,return_type_repr,return_type_repr,return_tmp));
                return Ok(CompiledValue::Value { llvm_repr: LLVMVal::Register(rv_utvc), ptype: func.return_type().clone() });
            }
            
            let mut evaluated_args = Vec::new();
            for (iter, ptype) in required_arguments.iter().enumerate() {
                let val = self.compile_rvalue(&given_args[iter], Expected::Type(ptype))?;
                if val.get_type() != ptype {
                    return CompileResult::Err(CompileError::InvalidExpression(format!("{:?} vs {:?} type missmatch with {}th argument", val.get_type(), ptype, iter + 1)));
                }
                evaluated_args.push(val);
            }
            
            let arg_string = evaluated_args.iter().map(|x| x.get_llvm_repr_with_type(self.ctx)).collect::<CompileResult<Vec<_>>>()?.join(", ");
            if return_type.is_void() {
                self.output.push_str(&format!("    call void @{}({})\n", func.llvm_name(), arg_string));
                return Ok(CompiledValue::NoReturn);
            }
            if expected != Expected::NoReturn {
                let utvc = self.ctx.aquire_unique_temp_value_counter();
                self.output.push_str(&format!("    %tmp{} = call {} @{}({})\n", utvc, return_type_repr, func.llvm_name(), arg_string));
                return Ok(CompiledValue::Value { llvm_repr: LLVMVal::Register(utvc), ptype: return_type.clone() });
            }
            self.output.push_str(&format!("    call {} @{}({})\n", return_type_repr, func.llvm_name(), arg_string));
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
            let return_type_repr = get_llvm_type_str(return_type, self.ctx.symbols, &self.ctx.current_function_path)?;
            self.output.push_str(&format!("    %tmp{} = call {} {}({})\n", utvc, return_type_repr, llvm_repr, arg_string));
            return Ok(CompiledValue::Value { llvm_repr: LLVMVal::Register(utvc), ptype: *return_type.clone() });
        }
        Err(CompileError::Generic(format!("Left hand side expression is not function call it is: {:?}", callee)))
    }
    fn compile_name_rvalue(&mut self, name: &str, _expected: Expected) -> CompileResult<CompiledValue> {
        if let Some((variable, id)) = self.ctx.scope.get_variable(name) {
            let vtype = variable.get_type(false, false);
            let llvm_repr = variable.get_llvm_value(*id, name, self.ctx, self.output)?;
            return Ok(CompiledValue::Value { llvm_repr, ptype: vtype.clone() });
        }
        
        if let Some(function) = self.ctx.symbols.get_function(name, &self.ctx.current_function_path) {
            return Ok(function.get_compiled_value());
        }

        Err(CompileError::SymbolNotFound(format!("Symbol '{}' not found in '{}'", name, self.ctx.current_function_path)))
    }
    #[allow(unused_variables)]
    fn compile_name_with_generics_rvalue(&mut self, name: &Box<Expr>, generics: &[ParserType], expected: Expected<'_>) -> CompileResult<CompiledValue> {
        todo!()
    }
    fn compile_integer_literal(&mut self, num_str: &str, expected: Expected) -> CompileResult<CompiledValue> {
        if let Expected::Type(ptype) = expected {
            if ptype.is_integer() {
                return Ok(CompiledValue::Value { llvm_repr: LLVMVal::Constant(num_str.to_string()), ptype: ptype.clone() });
            }
            if ptype.is_bool() {
                let llvm_repr = if num_str != "0" { "1" } else { "0" }.to_string();
                return Ok(CompiledValue::Value { llvm_repr: LLVMVal::Constant(llvm_repr.to_string()), ptype: ptype.clone() });
            }
            if ptype.is_pointer() && num_str == "0" {
                return Ok(CompiledValue::Value { llvm_repr: LLVMVal::Null, ptype: ptype.clone() });
            }
        }
        Ok(CompiledValue::Value { llvm_repr: LLVMVal::Constant(num_str.to_string()), ptype: DEFAULT_INTEGER_TYPE.into() })
    }
    fn compile_decimal_literal(&mut self, num_str: &str, expected: Expected) -> CompileResult<CompiledValue> {
        let bits = num_str.parse::<f64>().unwrap().to_bits();
        if let Some(x) = expected.get_type().filter(|x| x.is_decimal()) {
            return explicit_cast(&CompiledValue::Value { llvm_repr: LLVMVal::Constant(format!("0x{:X}", bits)), ptype: x.clone() }, x, self.ctx, self.output);
        };

        Ok(CompiledValue::Value { llvm_repr: LLVMVal::Constant(format!("0x{:X}", bits)), ptype: DEFAULT_DECIMAL_TYPE.into() })
    }
    fn compile_assignment(&mut self, lhs: &Expr, rhs: &Expr, expected: Expected) -> CompileResult<CompiledValue> {
        let left_ptr = self.compile_lvalue(lhs, true, true)?;
        if !matches!(left_ptr, CompiledValue::Pointer { .. }) {
            return Err(CompileError::InvalidExpression(format!("{:?} does not yield a valid lvalue", lhs)));
        }
        let right_val = self.compile_rvalue(rhs, Expected::Type(left_ptr.get_type()))?;
        if left_ptr.get_type() != right_val.get_type() {
            return Err(CompileError::InvalidExpression(format!("Type mismatch in assignment: {:?} and {:?}", left_ptr.get_type().debug_type_name(), right_val.get_type().debug_type_name())));
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
        let member_ptr = self.compile_lvalue(expr, false, false)?;
        let temp_id = self.ctx.aquire_unique_temp_value_counter();
        let ptype = substitute_generic_type(member_ptr.get_type(), &self.ctx.symbols.alias_types);
        let type_str = get_llvm_type_str(&ptype, self.ctx.symbols, &self.ctx.current_function_path)?;
        self.output.push_str(&format!("    %tmp{} = load {}, {}* {}\n", temp_id, type_str, type_str, member_ptr.get_llvm_rep()));
        Ok(CompiledValue::Value { llvm_repr: LLVMVal::Register(temp_id), ptype })
    }
    
    fn compile_cast(&mut self, expr: &Expr, target_type: &ParserType, expected: Expected) -> CompileResult<CompiledValue> {
        let value = match expected {
            Expected::Type(t) => {
                self.compile_rvalue(expr, Expected::Type(&substitute_generic_type(t, &self.ctx.symbols.alias_types)))?
            }
            _ => self.compile_rvalue(expr, expected)?,
        };
        
        let target_type = &substitute_generic_type(target_type, &self.ctx.symbols.alias_types);
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
                let pointed_to_type = value.get_type().try_dereference_once();
                let type_str = get_llvm_type_str(pointed_to_type, self.ctx.symbols, &self.ctx.current_function_path)?;
                let temp_id = self.ctx.aquire_unique_temp_value_counter();
                self.output.push_str(&format!("    %tmp{} = load {}, {}* {}\n", temp_id, type_str, type_str, value.get_llvm_rep()));
                Ok(CompiledValue::Value { llvm_repr: LLVMVal::Register(temp_id), ptype: pointed_to_type.clone() })
            }
            UnaryOp::Pointer => { // lvalue.get_llvm_repr()
                let lvalue = self.compile_lvalue(operand_expr, false, false)?;
                if let CompiledValue::Function { effective_internal_name} = &lvalue {
                    let func = self.ctx.symbols.get_bare_function(effective_internal_name, &self.ctx.current_function_path, false).unwrap();
                    return Ok(CompiledValue::Value { llvm_repr: LLVMVal::Global(effective_internal_name.clone()), ptype: func.get_type().self_reference_once() });
                }
                let ptype = lvalue.get_type().clone().self_reference_once();
                Ok(CompiledValue::Value { llvm_repr: lvalue.get_llvm_rep().clone(), ptype })
            }
            UnaryOp::Negate => {
                let value = self.compile_rvalue(operand_expr, expected)?;
                if !value.get_type().is_integer() && !value.get_type().is_decimal() {
                    return Err(CompileError::Generic("Cannot negate non-integer type".to_string()));
                }
                if value.is_literally_number() {
                    if let LLVMVal::Constant(cnst) = value.get_llvm_rep() {
                        let num = -cnst.parse::<i128>().unwrap();
                        return Ok(CompiledValue::Value { llvm_repr: LLVMVal::Constant(num.to_string()), ptype: value.get_type().clone() });
                    }
                    todo!()
                }
                let type_str = get_llvm_type_str(value.get_type(), self.ctx.symbols, &self.ctx.current_function_name)?;
                let temp_id = self.ctx.aquire_unique_temp_value_counter();
                if value.get_type().is_decimal() {
                    self.output.push_str(&format!("    %tmp{} = fsub {} 0.0, {}\n", temp_id, type_str, value.get_llvm_rep()));
                }else{
                    self.output.push_str(&format!("    %tmp{} = sub {} 0, {}\n", temp_id, type_str, value.get_llvm_rep()));
                }
                
                Ok(CompiledValue::Value { llvm_repr: LLVMVal::Register(temp_id), ptype: value.get_type().clone() })
            }
            UnaryOp::Not => {
                let value = self.compile_rvalue(operand_expr, Expected::Type(&BOOL_TYPE.into()))?;
                if !value.get_type().is_bool() {
                    return Err(CompileError::InvalidExpression("Logical NOT can only be applied to booleans".to_string()));
                }
                let temp_id = self.ctx.aquire_unique_temp_value_counter();
                self.output.push_str(&format!("    %tmp{} = xor i1 {}, 1\n", temp_id, value.get_llvm_rep()));
                Ok(CompiledValue::Value { llvm_repr: LLVMVal::Register(temp_id), ptype: value.get_type().clone() })
            }
        }
    }

    fn compile_static_access_rvalue(&mut self, expr: &Expr) -> CompileResult<CompiledValue> {
        let path = get_path_from_expr(expr);
        
        if let Some((variable, _)) = self.ctx.scope.get_variable(&path) {
            return Ok(CompiledValue::Pointer { llvm_repr: LLVMVal::VariableName(path.to_string()), ptype: variable.compiler_type().clone() });
        }
        
        if let Some(function) = self.ctx.symbols.get_function(&path, &self.ctx.current_function_path) {
            return Ok(function.get_compiled_value());
        }

        if let Some((enum_path, member_name)) = path.rsplit_once('.') {
            let qualified_enum_path = format!("{}.{}", self.ctx.current_function_path, enum_path);
            if let Some(r#enum) = self.ctx.symbols.enums.get(&qualified_enum_path) {
                if let Some((_, val)) = r#enum.fields.iter().find(|(name, _)| name == member_name) {
                    return Ok(CompiledValue::Value { llvm_repr: LLVMVal::Constant(val.to_string()), ptype: r#enum.base_type.clone() });
                }
            }
        }

        Err(CompileError::SymbolNotFound(format!("Symbol '{}' not found", path)))
    }
    fn compile_index_rvalue(&mut self, expr: &Expr) -> CompileResult<CompiledValue> {
        let ptr = self.compile_lvalue(expr, false, false)?;
        let ptype = ptr.get_type().clone();
        let type_str = get_llvm_type_str(&ptype, self.ctx.symbols, &self.ctx.current_function_path)?;
        let temp_id = self.ctx.aquire_unique_temp_value_counter();
        let ptr_str = ptr.get_llvm_repr_with_type(self.ctx)?;
        self.output.push_str(&format!("    %tmp{} = load {}, {}\n", temp_id, type_str, ptr_str));
        Ok(CompiledValue::Value { llvm_repr: LLVMVal::Register(temp_id), ptype })
    }
    fn compile_string_literal(&mut self, str_val: &str) -> CompileResult<CompiledValue> { // ---
        //let str_len = str_val.len() + 1;
        let const_id = self.output.add_to_strings_header(str_val.to_string());
        //let ptr_id = self.ctx.aquire_unique_temp_value_counter();
        return Ok(CompiledValue::Value { llvm_repr: LLVMVal::Global(format!(".str.{}", const_id)), ptype: ParserType::Pointer(Box::new(CHAR_TYPE.into())) });
        /*self.output.push_str(&format!("    %tmp{} = getelementptr inbounds [{} x i8], [{} x i8]* @.str.{}, i64 0, i64 0\n", ptr_id, str_len, str_len, const_id));
        Ok(CompiledValue::Value {
            llvm_repr: LLVMVal::Register(ptr_id),
            ptype: ParserType::Pointer(Box::new(CHAR_TYPE.into())),
        })*/
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
    // ----------------------======++$$@LVALUE@$$++======-----------------
    fn compile_name_lvalue(&mut self, name: &str, write: bool, modify_content: bool) -> CompileResult<CompiledValue> {
        if let Some((variable, id)) = self.ctx.scope.get_variable(name) {
            let ptype = variable.get_type(write, modify_content).clone();
            if variable.is_constant() {
                panic!("Constant variable '{}' should not be accessed as an lvalue", name);
                let x = variable.value().borrow().clone().ok_or_else(|| CompileError::InvalidExpression(format!("Constant variable '{}' has no value assigned", name)))?;
                // Allocate in not allocated yet
                return Ok(CompiledValue::Pointer { llvm_repr: x, ptype });
            }
            let llvm_repr = if variable.is_argument() {
                if variable.is_alias_value() { LLVMVal::Register(*id) } else { LLVMVal::VariableName(name.to_string()) }
            } else {
                LLVMVal::Variable(*id)
            };
            return Ok(CompiledValue::Pointer { llvm_repr, ptype });
        }
        if let Some(function) = self.ctx.symbols.get_bare_function(name, &self.ctx.current_function_path, true) {
            return Ok(function.get_compiled_value());
        }
        Err(CompileError::SymbolNotFound(format!("Lvalue '{}' not found", name)))
    }
    fn compile_name_with_generics_lvalue(&mut self, name: &Expr, generics: &[ParserType], write: bool, modify_content: bool) -> CompileResult<CompiledValue> {
        let x = self.compile_lvalue(name, write, modify_content)?;
        if let CompiledValue::GenericFunction { effective_internal_name } = x {
            if generics.is_empty() {
                return Err(CompileError::Generic(format!("Generic function '{}' requires generic parameters", effective_internal_name)));
            }
            let _func = self.ctx.symbols.get_bare_function(&effective_internal_name, &self.ctx.current_function_path, false)
                .ok_or(CompileError::Generic(format!("Function (effective path):({}) couldnt be found inside:({}.{})",effective_internal_name,self.ctx.current_function_path, self.ctx.current_function_name)))?;
            return Ok(CompiledValue::GenericFunctionImplementation { effective_internal_name, types: generics.to_vec().into_boxed_slice() });
        }
        Err(CompileError::Generic(format!("Lvalue with generics '{:?}' is not a generic function", name)))
    }
    fn compile_static_access_lvalue(&mut self, expr: &Expr, write: bool, modify_content: bool) -> CompileResult<CompiledValue> {
        let path = get_path_from_expr(expr);
        if let Some((variable, _)) = self.ctx.scope.get_variable(&path) {
            let ptype = variable.get_type(write, modify_content).clone();
            return Ok(CompiledValue::Pointer { llvm_repr: LLVMVal::VariableName(path.to_string()), ptype });
        }
        if let Some(function) = self.ctx.symbols.get_bare_function(&path, &self.ctx.current_function_path, true) {
            return Ok(function.get_compiled_value());
        }
        Err(CompileError::SymbolNotFound(format!("Static symbol '{}' not found", path)))
    }
    fn compile_member_access_lvalue(&mut self, obj: &Expr, member: &str, write: bool, modify_content: bool) -> CompileResult<CompiledValue> {
        let obj_lvalue = self.compile_lvalue(obj, false, write || modify_content)?;
        
        let (base_ptr_repr, struct_type) = if obj_lvalue.get_type().is_pointer() {
            let obj_rvalue = self.compile_rvalue(obj, Expected::Anything)?;
            let internal_type = obj_rvalue.get_type().try_dereference_once();
            (obj_rvalue.get_llvm_rep().clone(), internal_type.clone())
        } else {
            (obj_lvalue.get_llvm_rep().clone(), obj_lvalue.get_type().clone())
        };
        let resolved_type = substitute_generic_type(&struct_type, &self.ctx.symbols.alias_types);
        let abs_path = SymbolTable::get_abs_path(&resolved_type, &self.ctx.current_function_path);

        let struct_symbol = self.ctx.symbols.get_bare_type(&abs_path)
            .ok_or_else(|| CompileError::SymbolNotFound(format!("Struct definition '{}' not found", abs_path)))?;
        let view = if struct_symbol.is_generic() {
            let generic_args = match resolved_type.dereference_full().full_delink() {
                ParserType::Generic(_, args) => args,
                _ => return Err(CompileError::Generic(format!("Type '{}' is defined as generic but usage suggests otherwise", abs_path)))
            };
            let generic_params = struct_symbol.generic_params();
            if generic_args.len() != generic_params.len() {
                return Err(CompileError::Generic(format!("Generic parameter count mismatch for struct '{}'. Expected {}, got {}", abs_path, generic_params.len(), generic_args.len())));
            }
            let mut type_map = HashMap::new();
            for (i, param) in generic_params.iter().enumerate() {
                type_map.insert(param.clone(), generic_args[i].clone());
            }
            StructView::new_generic(struct_symbol.definition(), &type_map)
        }else {
            StructView::new(struct_symbol.definition())
        };
        let fields = view.field_types();
        let (index, field_type) = fields.iter().enumerate()
            .find(|(_, (name, _))| name == member)
            .map(|(i, (_, ftype))| (i, ftype.clone()))
            .ok_or_else(|| CompileError::Generic(format!("Member '{}' not found in struct '{}'", member, abs_path)))?;
        
        let llvm_struct_type = view.llvm_representation(self.ctx.symbols);
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
    fn compile_deref_lvalue(&mut self, operand: &Expr, _write: bool, _modify_content: bool) -> CompileResult<CompiledValue> {
        let pointer_rval = self.compile_rvalue(operand, Expected::Anything)?;
        if !pointer_rval.get_type().is_pointer() {
            return Err(CompileError::Generic(format!("Cannot dereference non-pointer type: {:?}", pointer_rval.get_type())));
        }
        let ptype = pointer_rval.get_type().try_dereference_once();
        let llvm_repr = &pointer_rval;
        Ok(CompiledValue::Pointer { llvm_repr: llvm_repr.get_llvm_rep().clone(), ptype:ptype.clone() })
    }
    fn compile_index_lvalue(&mut self, array_expr: &Expr, index_expr: &Expr, _write: bool, _modify_content: bool) -> CompileResult<CompiledValue> {
        let array_rval = self.compile_rvalue(array_expr, Expected::Anything)?; 
        if !array_rval.get_type().is_pointer() {
            return Err(CompileError::InvalidExpression(format!("Cannot index non-pointer type {:?}", array_rval.get_type())));
        }

        let index_val = self.compile_rvalue(index_expr, Expected::Type(&DEFAULT_INTEGER_TYPE.into()))?;
        if !index_val.get_type().is_integer() {
            return Err(CompileError::InvalidExpression(format!("Index must be an integer, but got {:?}", index_val.get_type())));
        }

        let base_type = array_rval.get_type().try_dereference_once();
        let llvm_base_type = get_llvm_type_str(base_type, self.ctx.symbols, &self.ctx.current_function_path)?;
        
        let temp_id = self.ctx.aquire_unique_temp_value_counter();
        let gep_ptr_reg = LLVMVal::Register(temp_id);
        
        self.output.push_str(&format!(
            "    {} = getelementptr inbounds {}, {}, {}\n",
            gep_ptr_reg, 
            llvm_base_type, 
            array_rval.get_llvm_repr_with_type(self.ctx)?, 
            index_val.get_llvm_repr_with_type(self.ctx)?
        ));
        Ok(CompiledValue::Pointer { llvm_repr: gep_ptr_reg, ptype: base_type.clone() })
    }
    
    fn compile_type(&mut self, r_type: &ParserType) -> CompileResult<CompiledValue> {
        if let ParserType::Generic(x, given_generic) = r_type {
            let q = self.compile_name_lvalue(x, false, false)?;
            if !q.get_type().is_function() {
                return Err(CompileError::Generic(format!("{} is not a function", r_type.debug_type_name())));
            }
            if let Some(func) = self.ctx.symbols.get_bare_function(x, &self.ctx.current_function_path, true) {
                let mut type_map = HashMap::new();
                for (ind, prm) in func.generic_params().iter().enumerate() {
                    if self.ctx.symbols.get_bare_type(given_generic[ind].type_name().as_str()).is_none() {
                        panic!()
                    }
                    type_map.insert(prm.clone(), given_generic[ind].clone());
                }
                let x = self.ctx.symbols.get_generic_function(x, &self.ctx.current_function_path, &type_map).unwrap();
                let llvm_struct_name = format!("\"{}<{}>\"", func.llvm_name(), x.definition().generic_params.iter().map(|x| get_llvm_type_str(type_map.get(x).unwrap(), self.ctx.symbols, &self.ctx.current_function_path)).collect::<CompileResult<Vec<_>>>()?.join(", "));
                
                return Ok(CompiledValue::Function { effective_internal_name: llvm_struct_name });
            }

        }
        panic!()
    }
}

fn get_path_from_expr(expr: &Expr) -> String {
    match expr {
        Expr::Name(n) => n.clone(),
        Expr::StaticAccess(base, member) => format!("{}.{}", get_path_from_expr(base), member),
        _ => panic!("Cannot extract path from {:?}", expr),
    }
}
pub fn size_of_from_parser_type(ptype: &ParserType, ctx: &mut CodeGenContext) -> u32 {
    size_and_alignment_of_type(ptype, ctx).size
}
pub fn size_and_alignment_of_type(ptype: &ParserType, ctx: &mut CodeGenContext) -> Layout{
    assert!(!matches!(ptype, ParserType::Function(_, _)));
    if let Some(internal) = ptype.as_pointer() {
        get_llvm_type_str(internal, ctx.symbols, &ctx.current_function_path).unwrap(); // Ensure valid type - THE HACK
        return Layout::new(8, 8);
    }
    if let Some(info) = ptype.as_primitive_type() {
        return info.layout;
    }
    // not a pointer
    // not a primitive
    let bare = ctx.symbols.get_bare_type(&format!("{}.{}", ctx.current_function_path, ptype.type_name())).or(ctx.symbols.get_bare_type(&ptype.type_name()));
    if bare.is_none() {
        panic!("Type not found {:?}", ptype)
    }
    let bare = bare.unwrap();
    if let Some((_, imp)) = ptype.full_delink().as_generic() {
        let mut type_map = HashMap::new();
        for (ind, prm) in bare.generic_params().iter().enumerate() {
            type_map.insert(prm.clone(), imp[ind].clone());
        }
        StructView::new_generic(bare.definition(), &type_map).calculate_size(ctx)
    }else {
        // not a generic
        StructView::new(bare.definition()).calculate_size(ctx)
    }
}
pub fn constant_integer_expression_compiler_llvm_var(expression: &Expr, _symbols: &SymbolTable) -> CompileResult<LLVMVal> {
    constant_integer_expression_compiler(expression, _symbols).map(|x| LLVMVal::Constant(x.to_string()))
}
pub fn constant_integer_expression_compiler(expression: &Expr, _symbols: &SymbolTable) -> CompileResult<i128> {
    match expression {
        Expr::Integer(x) => Ok(x.parse().expect("Invalid integer literal in const expression")),
        Expr::BinaryOp(l, op, r) => {
            let left_val = constant_integer_expression_compiler(l, _symbols)?;
            let right_val = constant_integer_expression_compiler(r, _symbols)?;
            match op {
                BinaryOp::BitOr => Ok(left_val | right_val),
                BinaryOp::BitAnd => Ok(left_val & right_val),
                BinaryOp::BitXor => Ok(left_val ^ right_val),
                BinaryOp::Add => Ok(left_val + right_val),
                BinaryOp::Subtract => Ok(left_val - right_val),
                BinaryOp::Multiply => Ok(left_val * right_val),
                BinaryOp::Divide => Ok(left_val / right_val),
                BinaryOp::Modulo => Ok(left_val % right_val),
                _ => Err(CompileError::Generic(format!("Unsupported constant binary operator: {:?}", op))),
            }
        }
        _ => Err(CompileError::Generic(format!("Unsupported constant expression: {:?}", expression))),
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
    let llvm_repr = LLVMVal::Register(temp_id);

    let instruction = match (from_type, to_type) {
        (ParserType::Named(_), ParserType::Named(_)) => {
            if let Some((from_info, to_info)) = from_type.as_both_integers(to_type) {
                if from_info.layout == to_info.layout {
                    return Ok(value.clone_with_type(to_type.clone()));
                }
                let op = if from_info.layout.size < to_info.layout.size {
                if from_type.is_unsigned_integer() { "zext" } else { "sext" } } else {"trunc"};
                format!("{} {} {} to {}", op, from_info.llvm_name, value.get_llvm_rep(), to_info.llvm_name)
            } else if let Some((from_info, to_info)) = from_type.as_both_decimals(to_type){
                if from_info.layout == to_info.layout {
                    return Ok(value.clone_with_type(to_type.clone()));
                }
                if from_info.layout == to_info.layout { return Ok(value.clone_with_type(to_type.clone()));}
                let op = if from_info.layout.size < to_info.layout.size {"fpext"} else {"fptrunc"};
                format!("{} {} {} to {}", op, from_info.llvm_name, value.get_llvm_rep(), to_info.llvm_name)
            } else if let (Some(from_info), Some(to_info)) = (from_type.as_integer(), to_type.as_decimal())  {
                let op = if from_type.is_unsigned_integer() { "uitofp" } else { "sitofp" };
                format!("{} {} {} to {}", op, from_info.llvm_name, value.get_llvm_rep(), to_info.llvm_name)
            } else if let (Some(from_info), Some(to_info)) = (from_type.as_decimal(), to_type.as_integer())  {
                let op = if to_type.is_unsigned_integer() { "fptoui" } else { "fptosi" };
                format!("{} {} {} to {}", op, from_info.llvm_name, value.get_llvm_rep(), to_info.llvm_name)
            }
            else if from_type.is_bool() {
                if let Some(to_info) = to_type.as_integer() {
                    format!("zext i1 {} to {}", value.get_llvm_rep(), to_info.llvm_name)
                }else {
                    return Err(CompileError::Generic(format!("Invalid cast from {:?} to {:?}", from_type, to_type)));
                }
            }
            else {
                return Err(CompileError::Generic(format!("Invalid cast from {:?} to {:?}", from_type, to_type)));
            }
            
        }
        (ParserType::Named(_), ParserType::Pointer(_)) if from_type.is_integer() => {
            return Err(CompileError::Generic(format!("Use bitcast to cast from {:?} to {:?}", from_type, to_type)));
        }
        (ParserType::Pointer(_), ParserType::Named(_)) if to_type.is_integer() => {
            return Err(CompileError::Generic(format!("Use bitcast to cast from {:?} to {:?}", from_type, to_type)));
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
pub fn expr_to_parser_type(expr: &Expr, ctx: &mut CodeGenContext) -> CompileResult<ParserType>{
    if let Expr::UnaryOp(UnaryOp::Pointer, e) = expr {
        return expr_to_parser_type(&e, ctx).map(|x| ParserType::Pointer(Box::new(x)));
    }
    if let Expr::Name(name) = expr {
        if let Some(t) = ctx.symbols.get_bare_type(&name) {
            return Ok(t.parser_type());
        }
    }
    todo!("{:?}", expr)
}


fn sizeof_impl(
    compiler: &mut ExpressionCompiler, 
    given_args: &[Expr], 
    expected: &Expected
) -> CompileResult<CompiledValue> {
    if given_args.len() != 1 {
        return Err(CompileError::Generic(format!(
            "sizeof(Type) expects exactly 1 argument, but got {}", 
            given_args.len()
        )));
    }
    let sizeof_type = expr_to_parser_type(&given_args[0], compiler.ctx)?;
    let resolved_type = substitute_generic_type(&sizeof_type, &compiler.ctx.symbols.alias_types);
    let size = size_of_from_parser_type(&resolved_type, compiler.ctx);

    let ptype = expected.get_type()
        .filter(|pt| pt.is_integer())
        .cloned()
        .unwrap_or_else(|| DEFAULT_INTEGER_TYPE.into());
        
    return Ok(CompiledValue::Value { 
        llvm_repr: LLVMVal::Constant(size.to_string()), 
        ptype 
    });
}
fn stalloc_impl(
    compiler: &mut ExpressionCompiler, 
    given_args: &[Expr], 
    _expected: &Expected
) -> CompileResult<CompiledValue> {
    if given_args.len() != 1 {
        return Err(CompileError::Generic(format!(
            "stalloc(count) expects exactly 1 argument, but got {}", 
            given_args.len()
        )));
    }

    let int_type = DEFAULT_INTEGER_TYPE.into();
    let count_val = compiler.compile_rvalue(&given_args[0], Expected::Type(&int_type))?;
    
    if !count_val.get_type().is_integer() {
        return Err(CompileError::Generic(format!(
            "stalloc count must be an integer, but got {:?}", 
            count_val.get_type().debug_type_name()
        )));
    }

    let utvc = compiler.ctx.aquire_unique_temp_value_counter();
    let count_llvm_type = get_llvm_type_str(
        count_val.get_type(), 
        compiler.ctx.symbols, 
        &compiler.ctx.current_function_path
    )?;

    compiler.output.push_str(&format!(
        "    %tmp{} = alloca i8, {} {}\n", 
        utvc, 
        count_llvm_type,
        count_val.get_llvm_rep()
    ));
    
    Ok(CompiledValue::Value { 
        llvm_repr: LLVMVal::Register(utvc), 
        ptype: ParserType::Pointer(Box::new(BYTE_TYPE.into())) 
    })
}
fn sizeof_generic_impl(
    compiler: &mut ExpressionCompiler, 
    given_args: &[Expr], 
    given_generic: &[ParserType], 
    expected: &Expected
) -> CompileResult<CompiledValue> {
    if given_generic.len() != 1 {
        return Err(CompileError::Generic(format!(
            "sizeof<T>() expects exactly 1 generic type, but got {}",
            given_generic.len()
        )));
    }
    if !given_args.is_empty() {
        return Err(CompileError::Generic(format!(
            "sizeof<T>() expects 0 arguments, but got {}",
            given_args.len()
        )));
    }
    let target_type = substitute_generic_type(&given_generic[0], &compiler.ctx.symbols.alias_types);
    let size = size_of_from_parser_type(&target_type, compiler.ctx);
    let return_ptype = if let Expected::Type(pt) = expected {
        if pt.is_integer() {
            (*pt).clone()
        } else {
            DEFAULT_INTEGER_TYPE.into()
        }
    } else {
        DEFAULT_INTEGER_TYPE.into()
    };
    Ok(CompiledValue::Value {
        llvm_repr: LLVMVal::Constant(size.to_string()),
        ptype: return_ptype,
    })
}
fn stalloc_generic_impl(
    compiler: &mut ExpressionCompiler, 
    given_args: &[Expr], 
    given_generic: &[ParserType], 
    _expected: &Expected
) -> CompileResult<CompiledValue> {
    if given_generic.len() != 1 {
        return Err(CompileError::Generic(format!(
            "stalloc<T>(count) expects exactly 1 generic type, but got {}",
            given_generic.len()
        )));
    }
    if given_args.len() != 1 {
        return Err(CompileError::Generic(format!(
            "stalloc<T>(count) expects exactly 1 argument (count), but got {}",
            given_args.len()
        )));
    }
    let int_type = DEFAULT_INTEGER_TYPE.into();
    let count_val = compiler.compile_rvalue(&given_args[0], Expected::Type(&int_type))?;
    if !count_val.get_type().is_integer() {
        return Err(CompileError::Generic(format!(
            "stalloc count must be an integer, but got {:?}",
            count_val.get_type().debug_type_name()
        )));
    }
    let target_type = substitute_generic_type(&given_generic[0], &compiler.ctx.symbols.alias_types);
    let llvm_type_str = get_llvm_type_str(
        &target_type, 
        compiler.ctx.symbols, 
        &compiler.ctx.current_function_path
    )?;
    let utvc = compiler.ctx.aquire_unique_temp_value_counter();
    compiler.output.push_str(&format!(
        "    %tmp{} = alloca {}, {} {}\n",
        utvc,
        llvm_type_str,
        get_llvm_type_str(count_val.get_type(), compiler.ctx.symbols, &compiler.ctx.current_function_path)?,
        count_val.get_llvm_rep()
    ));
    Ok(CompiledValue::Value {
        llvm_repr: LLVMVal::Register(utvc),
        ptype: target_type.self_reference_once(),
    })
}

fn ptr_of_impl(
    compiler: &mut ExpressionCompiler, 
    given_args: &[Expr], 
    _expected: &Expected
) -> CompileResult<CompiledValue> {
    if given_args.len() != 1 {
        return Err(CompileError::Generic(format!(
            "ptr_of(variable) expects exactly 1 argument, but got {}", 
            given_args.len()
        )));
    }

    let lvalue = compiler.compile_lvalue(&given_args[0], false, false)?;

    match lvalue {
        CompiledValue::Pointer { llvm_repr, ptype } => {
            Ok(CompiledValue::Value { 
                llvm_repr, 
                ptype: ptype.self_reference_once()
            })
        },
        CompiledValue::Function { effective_internal_name } => {
            let func = compiler.ctx.symbols.get_bare_function(&effective_internal_name, &compiler.ctx.current_function_path, false)
                .ok_or(CompileError::Generic(format!("Function not found: {}", effective_internal_name)))?;
            
            Ok(CompiledValue::Value { 
                llvm_repr: LLVMVal::Global(effective_internal_name), 
                ptype: func.get_type().self_reference_once()
            })
        },
        CompiledValue::GenericFunctionImplementation { effective_internal_name, types } =>{
            let func = compiler.ctx.symbols.get_bare_function(&effective_internal_name, &compiler.ctx.current_function_path, false)
                .ok_or(CompileError::Generic(format!("Function not found: {}", effective_internal_name)))?;
            let mut type_map = HashMap::new();
            for (ind, prm) in func.generic_params().iter().enumerate() {
                type_map.insert(prm.clone(), types[ind].clone());
            }
            let generic_func = FunctionView::new_generic(func.definition(), &type_map);
            let ftype = generic_func.get_type();
            let llvm_struct_name = format!("\"{}<{}>\"", func.llvm_name(), types.iter().map(|x| get_llvm_type_str(x, compiler.ctx.symbols, &compiler.ctx.current_function_path)).collect::<CompileResult<Vec<_>>>()?.join(", "));
            Ok(CompiledValue::Value { 
                llvm_repr: LLVMVal::Global(llvm_struct_name), 
                ptype: ftype.self_reference_once()
            })
        }
        _ => Err(CompileError::Generic(format!(
            "Cannot take the address of an R-value or non-addressable expression: {:?}", 
            given_args[0]
        )))
    }
}

fn alignof_impl(
    compiler: &mut ExpressionCompiler, 
    given_args: &[Expr], 
    expected: &Expected
) -> CompileResult<CompiledValue> {
    if given_args.len() != 1 {
        return Err(CompileError::Generic(format!(
            "alignof(Type) expects exactly 1 argument, but got {}", 
            given_args.len()
        )));
    }

    if let Expr::Type(alignof_type) = &given_args[0] {
        let resolved_type = substitute_generic_type(alignof_type, &compiler.ctx.symbols.alias_types);
        let alignment = size_and_alignment_of_type(&resolved_type, compiler.ctx).align;

        let ptype = expected.get_type()
            .filter(|pt| pt.is_integer())
                .cloned()
                .unwrap_or_else(|| DEFAULT_INTEGER_TYPE.into());
            
        return Ok(CompiledValue::Value { 
            llvm_repr: LLVMVal::Constant(alignment.to_string()), 
            ptype 
        });
    }

    Err(CompileError::Generic(format!(
        "alignof() requires a Type literal (e.g., alignof(i32)), but got expression: {:?}", 
        given_args[0]
    )))
}

fn alignof_generic_impl(
    compiler: &mut ExpressionCompiler, 
    given_args: &[Expr], 
    given_generic: &[ParserType], 
    expected: &Expected
) -> CompileResult<CompiledValue> {
    if given_generic.len() != 1 {
        return Err(CompileError::Generic(format!(
            "alignof<T>() expects exactly 1 generic type, but got {}",
            given_generic.len()
        )));
    }
    if !given_args.is_empty() {
        return Err(CompileError::Generic(format!(
            "alignof<T>() expects 0 arguments, but got {}",
            given_args.len()
        )));
    }
    let target_type = substitute_generic_type(&given_generic[0], &compiler.ctx.symbols.alias_types);
    let alignment = size_and_alignment_of_type(&target_type, compiler.ctx).align;
    
    let return_ptype = if let Expected::Type(pt) = expected {
        if pt.is_integer() {
            (*pt).clone()
        } else {
            DEFAULT_INTEGER_TYPE.into()
        }
    } else {
        DEFAULT_INTEGER_TYPE.into()
    };

    Ok(CompiledValue::Value {
        llvm_repr: LLVMVal::Constant(alignment.to_string()),
        ptype: return_ptype,
    })
}

fn bitcast_generic_impl(
    compiler: &mut ExpressionCompiler, 
    given_args: &[Expr], 
    given_generic: &[ParserType], 
    _expected: &Expected
) -> CompileResult<CompiledValue> {
    if given_generic.len() != 1 {
        return Err(CompileError::Generic(format!(
            "bitcast<T>(value) expects exactly 1 generic target type, but got {}",
            given_generic.len()
        )));
    }
    if given_args.len() != 1 {
        return Err(CompileError::Generic(format!(
            "bitcast<T>(value) expects exactly 1 argument, but got {}",
            given_args.len()
        )));
    }

    let target_type = substitute_generic_type(&given_generic[0], &compiler.ctx.symbols.alias_types);
    let source_val = compiler.compile_rvalue(&given_args[0], Expected::Anything)?;

    let src_layout = size_and_alignment_of_type(source_val.get_type(), compiler.ctx);
    let dst_layout = size_and_alignment_of_type(&target_type, compiler.ctx);
    if src_layout.size != dst_layout.size && !source_val.get_type().is_pointer() && !target_type.is_pointer() {
        return Err(CompileError::Generic(format!(
            "bitcast size mismatch: cannot cast from {:?} ({} bytes) to {:?} ({} bytes)",
            source_val.get_type().debug_type_name(), src_layout.size,
            target_type.debug_type_name(), dst_layout.size
        )));
    }
    if source_val.get_type().is_pointer() ^ target_type.is_pointer() {
        let from_str = source_val.get_llvm_repr_with_type(compiler.ctx)?;
        let to_str = get_llvm_type_str(&target_type, compiler.ctx.symbols, &compiler.ctx.current_function_path)?;
        let utvc = compiler.ctx.aquire_unique_temp_value_counter();
        if source_val.get_type().is_pointer() {
            compiler.output.push_str(&format!(
                "    %tmp{} = ptrtoint {} to {}\n",
                utvc,
                from_str,
                to_str
            ));
            return Ok(CompiledValue::Value {
                llvm_repr: LLVMVal::Register(utvc),
                ptype: target_type,
            });
        }else {
            compiler.output.push_str(&format!(
                "    %tmp{} = inttoptr {} to {}\n",
                utvc,
                from_str,
                to_str
            ));
            return Ok(CompiledValue::Value {
                llvm_repr: LLVMVal::Register(utvc),
                ptype: target_type,
            });
        }
    }
    let src_llvm_type = get_llvm_type_str(source_val.get_type(), compiler.ctx.symbols, &compiler.ctx.current_function_path)?;
    let dst_llvm_type = get_llvm_type_str(&target_type, compiler.ctx.symbols, &compiler.ctx.current_function_path)?;
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