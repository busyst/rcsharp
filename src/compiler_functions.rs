use rcsharp_parser::{
    compiler_primitives::{find_primitive_type, BYTE_TYPE, POINTER_SIZED_TYPE, VOID_TYPE},
    expression_parser::Expr,
    parser::ParserType,
};

use crate::{
    compiler::{
        expression::{ExpressionCompileResult, ExpressionCompiler, LValueAccess},
        structs::{CompiledValue, Expected, LLVMInstruction},
    },
    compiler_essentials::{CompilerError, CompilerType, LLVMVal},
};

pub type CompilerFn = fn(
    &ExpressionCompiler,
    &[Expr],
    &Expected,
) -> ExpressionCompileResult<(CompiledValue, Vec<LLVMInstruction>)>;
pub type GenericCompilerFn = fn(
    &ExpressionCompiler,
    &[Expr],
    &[ParserType],
    &Expected,
) -> ExpressionCompileResult<(CompiledValue, Vec<LLVMInstruction>)>;

pub const COMPILER_FUNCTIONS: &[(&str, Option<CompilerFn>, Option<GenericCompilerFn>, bool)] = &[
    (
        "stalloc",
        Some(stalloc_impl),
        Some(stalloc_generic_impl),
        false,
    ),
    (
        "size_of",
        Some(size_of_impl),
        Some(size_of_generic_impl),
        true,
    ),
    (
        "align_of",
        Some(align_of_impl),
        Some(align_of_generic_impl),
        true,
    ),
    ("ptr_of", Some(ptr_of_impl), None, false),
    ("bitcast", None, Some(bitcast_generic_impl), false),
    ("asm", Some(asm_impl), None, false),
];

fn stalloc_impl(
    compiler: &ExpressionCompiler,
    given_args: &[Expr],
    _expected: &Expected,
) -> ExpressionCompileResult<(CompiledValue, Vec<LLVMInstruction>)> {
    if given_args.len() != 1 {
        return Err(CompilerError::Generic(format!(
            "stalloc(count) expects exactly 1 argument, but got {}",
            given_args.len()
        ))
        .into());
    }

    let int_type = CompilerType::Primitive(POINTER_SIZED_TYPE);
    let (count_val, mut instruct) =
        compiler.compile_rvalue(&given_args[0], Expected::Type(&int_type))?;
    let Some(count_type) = count_val.get_type() else {
        return Err(CompilerError::Generic("stalloc(arg) arg is not a value".into()).into());
    };
    if !count_type.is_integer() {
        return Err(CompilerError::Generic(format!(
            "stalloc(arg); arg must be an integer, but got {:?}",
            count_type
        ))
        .into());
    }

    let utvc = compiler.ctx().acquire_temp_id();
    instruct.push(LLVMInstruction::AllocateStack {
        target_reg: utvc,
        alloc_type: CompilerType::Primitive(BYTE_TYPE),
        count: count_val.get_llvm_rep().clone(),
        count_type: count_type.clone(),
    });
    Ok((
        CompiledValue::new_value(
            LLVMVal::Register(utvc),
            CompilerType::Pointer(Box::new(CompilerType::Primitive(BYTE_TYPE))),
        ),
        instruct,
    ))
}
fn stalloc_generic_impl(
    compiler: &ExpressionCompiler,
    given_args: &[Expr],
    given_generic: &[ParserType],
    _expected: &Expected,
) -> ExpressionCompileResult<(CompiledValue, Vec<LLVMInstruction>)> {
    if given_generic.len() != 1 {
        return Err(CompilerError::Generic(format!(
            "stalloc<T>(arg) expects exactly 1 generic type, but got {}",
            given_generic.len()
        ))
        .into());
    }
    if given_args.len() != 1 {
        return Err(CompilerError::Generic(format!(
            "stalloc<T>(arg) expects exactly 1 argument (arg), but got {}",
            given_args.len()
        ))
        .into());
    }
    let int_type = CompilerType::Primitive(POINTER_SIZED_TYPE);
    let (count_val, mut instruct) =
        compiler.compile_rvalue(&given_args[0], Expected::Type(&int_type))?;
    let Some(count_type) = count_val.get_type() else {
        return Err(CompilerError::Generic("stalloc<T>(arg) arg is not a value".into()).into());
    };
    if !count_type.is_integer() {
        return Err(CompilerError::Generic(format!(
            "stalloc<T>(arg); arg must be an integer, but got {:?}",
            count_type
        ))
        .into());
    }

    let target_type = CompilerType::from_parser_type(
        &given_generic[0],
        compiler.symbols(),
        &compiler.ctx().current_function_path,
    )?;
    let utvc = compiler.ctx().acquire_temp_id();
    instruct.push(LLVMInstruction::AllocateStack {
        target_reg: utvc,
        alloc_type: target_type.clone(),
        count: count_val.get_llvm_rep().clone(),
        count_type: count_type.clone(),
    });
    println!(
        "STALLOC RETURNS {:?}",
        CompiledValue::new_value(LLVMVal::Register(utvc), target_type.clone().reference())
    );
    Ok((
        CompiledValue::new_value(LLVMVal::Register(utvc), target_type.reference()),
        instruct,
    ))
}

fn size_of_impl(
    compiler: &ExpressionCompiler,
    given_args: &[Expr],
    expected: &Expected,
) -> ExpressionCompileResult<(CompiledValue, Vec<LLVMInstruction>)> {
    if given_args.len() != 1 {
        return Err(CompilerError::Generic(format!(
            "size_of(Type) expects exactly 1 argument, but got {}",
            given_args.len()
        ))
        .into());
    }
    let (value, instruct) = compiler.compile_rvalue(&given_args[0], Expected::Anything)?;
    let Some(value_type) = value.get_type() else {
        return Err(CompilerError::Generic("size_of(Type) Type is not a type".into()).into());
    };
    let size = value_type.calculate_layout(compiler.symbols()).size;
    Ok((
        CompiledValue::new_value(
            LLVMVal::ConstantInteger(size as i128),
            expected
                .get_type()
                .filter(|x| x.is_integer())
                .unwrap_or(&CompilerType::Primitive(POINTER_SIZED_TYPE))
                .clone(),
        ),
        instruct,
    ))
}
fn size_of_generic_impl(
    compiler: &ExpressionCompiler,
    given_args: &[Expr],
    given_generic: &[ParserType],
    expected: &Expected,
) -> ExpressionCompileResult<(CompiledValue, Vec<LLVMInstruction>)> {
    if given_generic.len() != 1 {
        return Err(CompilerError::Generic(format!(
            "size_of<T>() expects exactly 1 generic type, but got {}",
            given_generic.len()
        ))
        .into());
    }
    if !given_args.is_empty() {
        return Err(CompilerError::Generic(format!(
            "size_of<T>() expects 0 arguments, but got {}",
            given_args.len()
        ))
        .into());
    }
    let mut target_type = CompilerType::from_parser_type(
        &given_generic[0],
        compiler.symbols(),
        &compiler.ctx().current_function_path,
    )?;
    target_type.substitute_global_aliases(compiler.symbols())?;
    let size = target_type.calculate_layout(compiler.symbols()).size;
    Ok((
        CompiledValue::new_value(
            LLVMVal::ConstantInteger(size as i128),
            expected
                .get_type()
                .filter(|x| x.is_integer())
                .unwrap_or(&CompilerType::Primitive(POINTER_SIZED_TYPE))
                .clone(),
        ),
        vec![],
    ))
}

fn ptr_of_impl(
    compiler: &ExpressionCompiler,
    given_args: &[Expr],
    _expected: &Expected,
) -> ExpressionCompileResult<(CompiledValue, Vec<LLVMInstruction>)> {
    if given_args.len() != 1 {
        return Err(CompilerError::Generic(format!(
            "ptr_of(variable) expects exactly 1 argument, but got {}",
            given_args.len()
        ))
        .into());
    }

    let (lvalue, instruct) = compiler.compile_lvalue(&given_args[0], LValueAccess::Read)?;
    match lvalue.location {
        LLVMVal::Global(x) => {
            if matches!(lvalue.value_type, CompilerType::Function(..)) {
                return Ok((
                    CompiledValue::new_value(
                        LLVMVal::Global(x.clone()),
                        lvalue.value_type.clone().reference(),
                    ),
                    instruct,
                ));
            }
        }
        LLVMVal::Variable(x) => {
            return Ok((
                CompiledValue::new_value(
                    LLVMVal::Variable(x),
                    lvalue.value_type.clone().reference(),
                ),
                instruct,
            ));
        }

        _ => {
            unimplemented!("{:?}", lvalue);
        }
    }
    unimplemented!("")
}

fn align_of_impl(
    compiler: &ExpressionCompiler,
    given_args: &[Expr],
    expected: &Expected,
) -> ExpressionCompileResult<(CompiledValue, Vec<LLVMInstruction>)> {
    if given_args.len() != 1 {
        return Err(CompilerError::Generic(format!(
            "align_of(Type) expects exactly 1 argument, but got {}",
            given_args.len()
        ))
        .into());
    }
    let (value, instruct) = compiler.compile_rvalue(&given_args[0], Expected::Anything)?;
    let Some(value_type) = value.get_type() else {
        return Err(CompilerError::Generic("align_of(Type) is not a type".into()).into());
    };
    let size = value_type.calculate_layout(compiler.symbols()).align;
    Ok((
        CompiledValue::new_value(
            LLVMVal::ConstantInteger(size as i128),
            expected
                .get_type()
                .filter(|x| x.is_integer())
                .unwrap_or(&CompilerType::Primitive(POINTER_SIZED_TYPE))
                .clone(),
        ),
        instruct,
    ))
}
#[allow(unused)]
fn align_of_generic_impl(
    compiler: &ExpressionCompiler,
    given_args: &[Expr],
    given_generic: &[ParserType],
    expected: &Expected,
) -> ExpressionCompileResult<(CompiledValue, Vec<LLVMInstruction>)> {
    if given_generic.len() != 1 {
        return Err(CompilerError::Generic(format!(
            "size_of<T>() expects exactly 1 generic type, but got {}",
            given_generic.len()
        ))
        .into());
    }
    if !given_args.is_empty() {
        return Err(CompilerError::Generic(format!(
            "size_of<T>() expects 0 arguments, but got {}",
            given_args.len()
        ))
        .into());
    }
    let mut target_type = CompilerType::from_parser_type(
        &given_generic[0],
        compiler.symbols(),
        &compiler.ctx().current_function_path,
    )?;
    target_type.substitute_global_aliases(compiler.symbols())?;
    let align = target_type.calculate_layout(compiler.symbols()).align;
    Ok((
        CompiledValue::new_value(
            LLVMVal::ConstantInteger(align as i128),
            expected
                .get_type()
                .filter(|x| x.is_integer())
                .unwrap_or(&CompilerType::Primitive(POINTER_SIZED_TYPE))
                .clone(),
        ),
        vec![],
    ))
}
// Done
fn bitcast_generic_impl(
    compiler: &ExpressionCompiler,
    given_args: &[Expr],
    given_generic: &[ParserType],
    _expected: &Expected,
) -> ExpressionCompileResult<(CompiledValue, Vec<LLVMInstruction>)> {
    if given_generic.len() != 1 {
        return Err(CompilerError::Generic(format!(
            "{} needs exactly 1 generic argument, but got {}",
            "bitcast<T>(value)",
            given_generic.len(),
        ))
        .into());
    }
    if given_args.len() != 1 {
        return Err(CompilerError::Generic(format!(
            "{} needs exactly 1 argument, but got {}",
            "bitcast<T>(value)",
            given_args.len()
        ))
        .into());
    }
    let target_type = CompilerType::from_parser_type(
        &given_generic[0],
        compiler.symbols(),
        &compiler.ctx().current_function_path,
    )?;
    let (source_val, mut instruct) =
        compiler.compile_rvalue(&given_args[0], Expected::Type(&target_type))?;
    let Some(source_type) = source_val.get_type() else {
        return Err(CompilerError::Generic("bitcast source is not a value".into()).into());
    };
    if source_type.is_pointer() && target_type.is_pointer() {
        return Ok((source_val.with_type(target_type), instruct));
    }
    if source_type == &target_type {
        return Ok((source_val, instruct));
    } else {
        let q = CompilerType::Pointer(Box::new(CompilerType::Primitive(
            find_primitive_type("i8").unwrap(),
        )));
        let w = CompilerType::Pointer(Box::new(CompilerType::Primitive(
            find_primitive_type("u8").unwrap(),
        )));
        let e = CompilerType::Pointer(Box::new(CompilerType::Primitive(VOID_TYPE)));
        if target_type == e && source_val.equal_type(&q) || source_val.equal_type(&w) {
            return Ok((source_val.with_type(target_type), instruct));
        }
    }
    if !source_type.is_bitcast_compatible(&target_type, compiler.symbols()) {
        println!("{:?}", given_args);
        return Err(CompilerError::Generic(format!(
            "bitcast size mismatch: cannot cast from {:?} to {:?}",
            source_type, target_type
        ))
        .into());
    }
    if source_type.is_pointer() ^ target_type.is_pointer() {
        if source_type.is_pointer() {
            let utvc = compiler.ctx().acquire_temp_id();
            instruct.push(LLVMInstruction::Cast {
                target_reg: utvc,
                op: format!("ptrtoint"),
                from_type: source_type.clone(),
                from_val: source_val.get_llvm_rep().clone(),
                to_type: target_type.clone(),
            });
            return Ok((
                CompiledValue::new_value(LLVMVal::Register(utvc), target_type),
                instruct,
            ));
        } else {
            let utvc = compiler.ctx().acquire_temp_id();

            if LLVMVal::ConstantInteger(0) == *source_val.get_llvm_rep() {
                return Ok((
                    CompiledValue::new_value(LLVMVal::Null, target_type.clone()),
                    instruct,
                ));
            }
            instruct.push(LLVMInstruction::Cast {
                target_reg: utvc,
                op: format!("inttoptr"),
                from_type: source_type.clone(),
                from_val: source_val.get_llvm_rep().clone(),
                to_type: target_type.clone(),
            });
            return Ok((
                CompiledValue::new_value(LLVMVal::Register(utvc), target_type),
                instruct,
            ));
        }
    }
    if source_type.is_integer() ^ target_type.is_integer()
        && source_type.is_decimal() ^ target_type.is_decimal()
    {
        if source_type.is_decimal() {
            // decimal to int
            if let CompiledValue::Value {
                llvm_repr: LLVMVal::ConstantDecimal(x),
                ..
            } = source_val
            {
                return Ok((
                    CompiledValue::new_value(
                        LLVMVal::ConstantInteger(f64::to_bits(x).cast_signed() as i128),
                        target_type,
                    ),
                    instruct,
                ));
            }
        } else {
            // int to decimal
            if let CompiledValue::Value {
                llvm_repr: LLVMVal::ConstantInteger(x),
                ..
            } = source_val
            {
                return Ok((
                    CompiledValue::new_value(
                        LLVMVal::ConstantDecimal(f64::from_bits(i64::cast_unsigned(x as i64))),
                        target_type,
                    ),
                    instruct,
                ));
            }
        }
    }
    let utvc = compiler.ctx().acquire_temp_id();
    instruct.push(LLVMInstruction::Cast {
        target_reg: utvc,
        op: format!("bitcast"),
        from_type: source_type.clone(),
        from_val: source_val.get_llvm_rep().clone(),
        to_type: target_type.clone(),
    });
    return Ok((
        CompiledValue::new_value(LLVMVal::Register(utvc), target_type),
        instruct,
    ));
}
// Usage: asm("add rax, rbx", [["rax", foo]], [["rax", foo], ["rbx", bar]], ["flags"]);
// Instruction: "add rax, rbx" RAX = RAX + RBX
// Output: [["rax", foo]]
// Input: [["rax", foo], ["rbx", bar]]
// Clobbers: ["flags"]
fn asm_impl(
    _compiler: &ExpressionCompiler,
    given_args: &[Expr],
    _expected: &Expected,
) -> ExpressionCompileResult<(CompiledValue, Vec<LLVMInstruction>)> {
    if given_args.len() != 4 {
        return Err(CompilerError::Generic(format!(
            "asm_impl(variable) expects exactly 4 arguments, but got {}",
            given_args.len()
        ))
        .into());
    }
    if *_expected != Expected::NoReturn {
        return Err(CompilerError::Generic(
            "asm() blocks currently do not support returning values directly. Use output operands."
                .into(),
        )
        .into());
    }
    /*
    let asm_template_str = match &given_args[0] {
        Expr::StringConst(s) => s.clone(),
        _ => {
            return Err(CompilerError::Generic(
                "asm() arg 1 (code) must be a string literal.".to_string(),
            )
            .into())
        }
    };
    let mut parse_operands = |arg_index: usize,
                              is_output: bool|
     -> ExpressionCompileResult<Vec<(String, String, String)>> {
        let arg_expr = &given_args[arg_index];
        match arg_expr {
            Expr::Array(arr) => {
                let mut results: Vec<(String, String, String)> = Vec::new();
                for (i, expr) in arr.iter().enumerate() {
                    if let Expr::Array(inner) = expr {
                        if inner.len() != 2 {
                            return Err(CompilerError::Generic(format!(
                                "asm() arg {} index {} must be a pair ['constraint', variable]",
                                arg_index + 1,
                                i
                            ))
                            .into());
                        }

                        let constraint = match &inner[0] {
                            Expr::StringConst(s) => s.clone(),
                            _ => {
                                return Err(CompilerError::Generic(
                                    "Operand constraint must be a string".into(),
                                )
                                .into())
                            }
                        };

                        let (llvm_value, llvm_type) = if let Expr::Name(name) = &inner[1] {
                            if is_output {
                                let (lvalue, instruct) = compiler.compile_name_lvalue(
                                    ContextPathEnd::from_path("", name),
                                    LValueAccess::Write,
                                )?;
                                (
                                    lvalue.location.to_string(),
                                    lvalue.value_type.llvm_representation(compiler.symbols())?,
                                )
                            } else {
                                let (rvalue, instruct) = compiler.compile_name_rvalue(
                                    ContextPathEnd::from_path("", name),
                                    Expected::Anything,
                                )?;
                                (
                                    rvalue.get_llvm_rep().to_string(),
                                    rvalue
                                        .get_type()
                                        .unwrap()
                                        .llvm_representation(compiler.symbols())?,
                                )
                            }
                        } else {
                            return Err(CompilerError::Generic(
                                "Operand variable must be a name".into(),
                            )
                            .into());
                        };

                        results.push((constraint, llvm_value, llvm_type));
                    } else {
                        return Err(CompilerError::Generic(format!(
                            "asm() arg {} must be an array of arrays",
                            arg_index + 1
                        ))
                        .into());
                    }
                }
                Ok(results)
            }
            _ => Err(CompilerError::Generic(format!(
                "asm() arg {} must be an array",
                arg_index + 1
            ))
            .into()),
        }
    };
    let outputs = parse_operands(1, true)?;
    let inputs = parse_operands(2, false)?;
    let inp = inputs
        .iter()
        .map(|x| format!("{{{}}}", x.0))
        .collect::<Vec<_>>()
        .join(",");
    let flags = match &given_args[3] {
        Expr::Array(args) => args
            .iter()
            .map(|arg| match arg {
                Expr::StringConst(s) => Ok(format!("~{{{}}}", s)),
                _ => Err(CompilerError::Generic(
                    "asm() arg 1 (code) must be a string literal.".to_string(),
                )
                .into()),
            })
            .collect::<ExpressionCompileResult<Vec<String>>>()?,
        _ => panic!("Unexpected arg"),
    }
    .join(",");
    /*
    if let Some((register, var_pointer, var_type)) = outputs.first() {
        assert!(outputs.len() == 1);
        let utvc = compiler.ctx().acquire_temp_id();
        compiler.output.push_function_body(&format!(
            "\t%asm{utvc} = call {} asm sideeffect inteldialect \"{}\", \"{}\"({})\n",
            var_type,
            asm_template_str,
            format!(
                "={{{register}}},{}",
                if !inp.is_empty() {
                    format!("{},{}", inp, flags)
                } else {
                    flags
                }
            ),
            inputs
                .iter()
                .map(|x| format!("{} {}", x.2, x.1))
                .collect::<Vec<_>>()
                .join(", ")
        ));
        /*
        compiler.emit_store(
            &LLVMVal::VariableName(format!("asm{}", utvc)),
            var_pointer,
            var_type,
        );*/

        compiler.output.push_function_body(&format!(
            "\tstore {} {}, {}* {}\n",
            var_type,
            format!("%asm{utvc}"),
            var_type,
            var_pointer
        ));
    } else {
        compiler.output.push_function_body(&format!(
            "\tcall {} asm sideeffect inteldialect \"{}\", \"{}\"({})\n",
            "void",
            asm_template_str,
            if !inp.is_empty() {
                format!("{},{}", inp, flags)
            } else {
                flags
            },
            inputs
                .iter()
                .map(|x| format!("{} {}", x.2, x.1))
                .collect::<Vec<_>>()
                .join(", ")
        ));
    } */
    */
    Ok((
        CompiledValue::NoReturn {
            program_halt: false,
        },
        vec![],
    ))
}
