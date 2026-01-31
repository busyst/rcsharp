use rcsharp_parser::{
    compiler_primitives::{BYTE_TYPE, DEFAULT_INTEGER_TYPE},
    expression_parser::Expr,
    parser::ParserType,
};

use crate::{
    compiler_essentials::{CompileResult, CompilerError, CompilerType, LLVMVal},
    expression_compiler::{CompiledValue, Expected, ExpressionCompiler},
};

pub type CompilerFn =
    fn(&mut ExpressionCompiler, &[Expr], &Expected) -> CompileResult<CompiledValue>;
pub type GenericCompilerFn =
    fn(&mut ExpressionCompiler, &[Expr], &[ParserType], &Expected) -> CompileResult<CompiledValue>;

pub const COMPILER_FUNCTIONS: &[(&str, Option<CompilerFn>, Option<GenericCompilerFn>)] = &[
    ("stalloc", Some(stalloc_impl), Some(stalloc_generic_impl)),
    ("size_of", Some(size_of_impl), Some(size_of_generic_impl)),
    ("align_of", Some(align_of_impl), Some(align_of_generic_impl)),
    ("ptr_of", Some(ptr_of_impl), None),
    ("bitcast", None, Some(bitcast_generic_impl)),
    ("asm", Some(asm_impl), None),
];

fn stalloc_impl(
    compiler: &mut ExpressionCompiler,
    given_args: &[Expr],
    _expected: &Expected,
) -> CompileResult<CompiledValue> {
    if given_args.len() != 1 {
        return Err(CompilerError::Generic(format!(
            "stalloc(count) expects exactly 1 argument, but got {}",
            given_args.len()
        ))
        .into());
    }

    let int_type = CompilerType::Primitive(DEFAULT_INTEGER_TYPE);
    let count_val = compiler.compile_rvalue(&given_args[0], Expected::Type(&int_type))?;
    let Ok(count_type) = count_val.try_get_type() else {
        return Err(CompilerError::Generic("stalloc(arg) arg is not a value".into()).into());
    };
    if !count_type.is_integer() {
        return Err(CompilerError::Generic(format!(
            "stalloc(arg); arg must be an integer, but got {:?}",
            count_type
        ))
        .into());
    }

    let utvc = compiler.ctx.acquire_temp_id();
    let count_llvm_type = count_type.llvm_representation(compiler.ctx.symbols)?;

    compiler.output.push_str(&format!(
        "    %tmp{} = alloca i8, {} {}\n",
        utvc,
        count_llvm_type,
        count_val.get_llvm_rep()
    ));

    Ok(CompiledValue::Value {
        llvm_repr: LLVMVal::Register(utvc),
        val_type: CompilerType::Pointer(Box::new(CompilerType::Primitive(BYTE_TYPE))),
    })
}
fn stalloc_generic_impl(
    compiler: &mut ExpressionCompiler,
    given_args: &[Expr],
    given_generic: &[ParserType],
    _expected: &Expected,
) -> CompileResult<CompiledValue> {
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
    let int_type = CompilerType::Primitive(DEFAULT_INTEGER_TYPE);
    let count_val = compiler.compile_rvalue(&given_args[0], Expected::Type(&int_type))?;
    let Ok(count_type) = count_val.try_get_type() else {
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
        compiler.ctx.symbols,
        compiler.ctx.current_path(),
    )?;
    let llvm_type_str = target_type.llvm_representation(compiler.ctx.symbols)?;
    let utvc = compiler.ctx.acquire_temp_id();
    compiler.output.push_str(&format!(
        "    %tmp{} = alloca {}, {} {}\n",
        utvc,
        llvm_type_str,
        count_type.llvm_representation(compiler.ctx.symbols)?,
        count_val.get_llvm_rep()
    ));
    Ok(CompiledValue::Value {
        llvm_repr: LLVMVal::Register(utvc),
        val_type: target_type.reference(),
    })
}

fn size_of_impl(
    compiler: &mut ExpressionCompiler,
    given_args: &[Expr],
    expected: &Expected,
) -> CompileResult<CompiledValue> {
    if given_args.len() != 1 {
        return Err(CompilerError::Generic(format!(
            "size_of(Type) expects exactly 1 argument, but got {}",
            given_args.len()
        ))
        .into());
    }
    let value = compiler.compile_rvalue(&given_args[0], Expected::Anything)?;
    let Ok(value_type) = value.try_get_type() else {
        return Err(CompilerError::Generic("size_of(Type) Type is not a type".into()).into());
    };
    let size = value_type.calculate_layout(compiler.ctx.symbols).size;
    Ok(CompiledValue::Value {
        llvm_repr: LLVMVal::ConstantInteger(size as i128),
        val_type: expected
            .get_type()
            .filter(|x| x.is_integer())
            .unwrap_or(&CompilerType::Primitive(DEFAULT_INTEGER_TYPE))
            .clone(),
    })
}
fn size_of_generic_impl(
    compiler: &mut ExpressionCompiler,
    given_args: &[Expr],
    given_generic: &[ParserType],
    expected: &Expected,
) -> CompileResult<CompiledValue> {
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
        compiler.ctx.symbols,
        compiler.ctx.current_path(),
    )?;
    target_type.substitute_global_aliases(compiler.ctx.symbols)?;
    let size = target_type.calculate_layout(compiler.ctx.symbols).size;
    Ok(CompiledValue::Value {
        llvm_repr: LLVMVal::ConstantInteger(size as i128),
        val_type: expected
            .get_type()
            .filter(|x| x.is_integer())
            .unwrap_or(&CompilerType::Primitive(DEFAULT_INTEGER_TYPE))
            .clone(),
    })
}

fn ptr_of_impl(
    compiler: &mut ExpressionCompiler,
    given_args: &[Expr],
    _expected: &Expected,
) -> CompileResult<CompiledValue> {
    if given_args.len() != 1 {
        return Err(CompilerError::Generic(format!(
            "ptr_of(variable) expects exactly 1 argument, but got {}",
            given_args.len()
        ))
        .into());
    }

    let lvalue = compiler.compile_lvalue(&given_args[0], false, false)?;
    match lvalue.location {
        LLVMVal::Global(x) => {
            if matches!(lvalue.value_type, CompilerType::Function(..)) {
                return Ok(CompiledValue::Value {
                    llvm_repr: LLVMVal::Global(x.clone()),
                    val_type: lvalue.value_type.clone().reference(),
                });
            }
        }
        LLVMVal::Variable(x) => {
            return Ok(CompiledValue::Value {
                llvm_repr: LLVMVal::Variable(x),
                val_type: lvalue.value_type.clone().reference(),
            });
        }
        _ => {
            unimplemented!("{:?}", lvalue);
        }
    }
    unimplemented!("");
    /*
    match lvalue {
        CompiledValue::Pointer { llvm_repr, ptype } => Ok(CompiledValue::Value {
            llvm_repr,
            ptype: ptype.reference(),
        }),
        CompiledValue::Function { internal_id } => {
            let func = compiler.ctx.symbols.get_function_by_id(internal_id);
            if func.is_external() {
                return Err(CompilerError::Generic(format!(
                    "Cannot get pointer of external function: {}",
                    func.full_path()
                ))
                .into());
            }
            if func.is_inline() {
                return Err(CompilerError::Generic(format!(
                    "Cannot get pointer of inline function: {}",
                    func.full_path()
                ))
                .into());
            }
            Ok(CompiledValue::Value {
                llvm_repr: LLVMVal::Global(func.full_path().to_string()),
                ptype: func.get_type().reference(),
            })
        }
        CompiledValue::GenericFunctionImplementation { internal_id, types } => {
            let func = compiler.ctx.symbols.get_function_by_id(internal_id);
            let ind = func.get_implementation_index(&types).expect("msg");
            let name = func.call_path_impl_index(ind, compiler.ctx.symbols);

            let mut type_map = HashMap::new();
            for (ind, prm) in func.generic_params.iter().enumerate() {
                type_map.insert(prm.clone(), types[ind].clone());
            }

            let ptype = func
                .get_type()
                .with_substituted_generic_types(&type_map, compiler.ctx.symbols)?
                .reference();
            Ok(CompiledValue::Value {
                llvm_repr: LLVMVal::Global(name.to_string()),
                ptype,
            })
        }
        _ => Err(CompilerError::Generic(format!(
            "Cannot take the address of an R-value or non-addressable expression: {:?}",
            given_args[0]
        ))
        .into()),
    }
     */
}

fn align_of_impl(
    compiler: &mut ExpressionCompiler,
    given_args: &[Expr],
    expected: &Expected,
) -> CompileResult<CompiledValue> {
    if given_args.len() != 1 {
        return Err(CompilerError::Generic(format!(
            "align_of(Type) expects exactly 1 argument, but got {}",
            given_args.len()
        ))
        .into());
    }
    let value = compiler.compile_rvalue(&given_args[0], Expected::Anything)?;
    let Ok(value_type) = value.try_get_type() else {
        return Err(CompilerError::Generic("align_of(Type) is not a type".into()).into());
    };
    let size = value_type.calculate_layout(compiler.ctx.symbols).align;
    Ok(CompiledValue::Value {
        llvm_repr: LLVMVal::ConstantInteger(size as i128),
        val_type: expected
            .get_type()
            .filter(|x| x.is_integer())
            .unwrap_or(&CompilerType::Primitive(DEFAULT_INTEGER_TYPE))
            .clone(),
    })
}
#[allow(unused)]
fn align_of_generic_impl(
    compiler: &mut ExpressionCompiler,
    given_args: &[Expr],
    given_generic: &[ParserType],
    expected: &Expected,
) -> CompileResult<CompiledValue> {
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
        compiler.ctx.symbols,
        compiler.ctx.current_path(),
    )?;
    target_type.substitute_global_aliases(compiler.ctx.symbols)?;
    let align = target_type.calculate_layout(compiler.ctx.symbols).align;
    let return_ptype = if let Expected::Type(pt) = expected {
        if pt.is_integer() {
            (*pt).clone()
        } else {
            CompilerType::Primitive(DEFAULT_INTEGER_TYPE)
        }
    } else {
        CompilerType::Primitive(DEFAULT_INTEGER_TYPE)
    };
    Ok(CompiledValue::Value {
        llvm_repr: LLVMVal::ConstantInteger(align as i128),
        val_type: return_ptype,
    })
}
// Done
fn bitcast_generic_impl(
    compiler: &mut ExpressionCompiler,
    given_args: &[Expr],
    given_generic: &[ParserType],
    _expected: &Expected,
) -> CompileResult<CompiledValue> {
    if given_generic.len() != 1 {
        return Err(CompilerError::ArgumentCountMismatch(format!(
            "{} needs exactly 1 generic argument, but got {}",
            "bitcast<T>(value)",
            given_generic.len(),
        ))
        .into());
    }
    if given_args.len() != 1 {
        return Err(CompilerError::ArgumentCountMismatch(format!(
            "{} needs exactly 1 argument, but got {}",
            "bitcast<T>(value)",
            given_args.len()
        ))
        .into());
    }
    let source_val = compiler.compile_rvalue(&given_args[0], Expected::Anything)?;
    let Ok(source_type) = source_val.try_get_type() else {
        return Err(CompilerError::Generic("bitcast source is not a value".into()).into());
    };
    let target_type = CompilerType::from_parser_type(
        &given_generic[0],
        compiler.ctx.symbols,
        compiler.ctx.current_path(),
    )?;

    if !source_type.is_bitcast_compatible(&target_type, compiler.ctx.symbols) {
        return Err(CompilerError::Generic(format!(
            "bitcast size mismatch: cannot cast from {:?} to {:?}",
            source_type, target_type
        ))
        .into());
    }
    if source_type.is_pointer() ^ target_type.is_pointer() {
        let (from_t, from_v) = (
            source_type.llvm_representation(compiler.ctx.symbols)?,
            source_val.get_llvm_rep().to_string(),
        );
        let to_str = target_type.llvm_representation(compiler.ctx.symbols)?;
        if source_type.is_pointer() {
            let utvc = compiler.emit_cast("ptrtoint", &from_t, &from_v, &to_str);
            return Ok(CompiledValue::Value {
                llvm_repr: LLVMVal::Register(utvc),
                val_type: target_type,
            });
        } else {
            if from_v.parse::<i128>().map(|x| x == 0).unwrap_or(false) {
                return Ok(CompiledValue::Value {
                    llvm_repr: LLVMVal::Null,
                    val_type: target_type.clone(),
                });
            }
            let utvc = compiler.emit_cast("inttoptr", &from_t, &from_v, &to_str);
            return Ok(CompiledValue::Value {
                llvm_repr: LLVMVal::Register(utvc),
                val_type: target_type,
            });
        }
    }
    if source_type.is_integer() ^ target_type.is_integer()
        && source_type.is_decimal() ^ target_type.is_decimal()
    {
        if source_type.is_decimal() {
            // decimal to int
            if let CompiledValue::Value {
                llvm_repr: LLVMVal::ConstantDecimal(x),
                val_type: _,
            } = source_val
            {
                return Ok(CompiledValue::Value {
                    llvm_repr: LLVMVal::ConstantInteger(f64::to_bits(x).cast_signed() as i128),
                    val_type: target_type,
                });
            }
        } else {
            // int to decimal
            if let CompiledValue::Value {
                llvm_repr: LLVMVal::ConstantInteger(x),
                val_type: _,
            } = source_val
            {
                return Ok(CompiledValue::Value {
                    llvm_repr: LLVMVal::ConstantDecimal(f64::from_bits(i64::cast_unsigned(
                        x as i64,
                    ))),
                    val_type: target_type,
                });
            }
        }
    }
    let src_llvm_type = source_type.llvm_representation(compiler.ctx.symbols)?;
    let dst_llvm_type = target_type.llvm_representation(compiler.ctx.symbols)?;
    let utvc = compiler.emit_cast(
        "bitcast",
        &src_llvm_type,
        &source_val.get_llvm_rep().to_string(),
        &dst_llvm_type,
    );

    Ok(CompiledValue::Value {
        llvm_repr: LLVMVal::Register(utvc),
        val_type: target_type,
    })
}
// Usage: asm("add rax, rbx", [["rax", foo]], [["rax", foo], ["rbx", bar]], ["flags"]);
// Instruction: "add rax, rbx" RAX = RAX + RBX
// Output: [["rax", foo]]
// Input: [["rax", foo], ["rbx", bar]]
// Clobbers: ["flags"]
fn asm_impl(
    compiler: &mut ExpressionCompiler,
    given_args: &[Expr],
    _expected: &Expected,
) -> CompileResult<CompiledValue> {
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
    let asm_template_str = match &given_args[0] {
        Expr::StringConst(s) => s.clone(),
        _ => {
            return Err(CompilerError::Generic(
                "asm() arg 1 (code) must be a string literal.".to_string(),
            )
            .into())
        }
    };
    let mut parse_operands =
        |arg_index: usize, is_output: bool| -> CompileResult<Vec<(String, String, String)>> {
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
                                    let lvalue = compiler.compile_name_lvalue(name, true, true)?;
                                    (
                                        lvalue.location.to_string(),
                                        lvalue
                                            .value_type
                                            .llvm_representation(compiler.ctx.symbols)?,
                                    )
                                } else {
                                    let rvalue =
                                        compiler.compile_name_rvalue(name, Expected::Anything)?;
                                    (
                                        rvalue.get_llvm_rep().to_string(),
                                        rvalue
                                            .try_get_type()?
                                            .llvm_representation(compiler.ctx.symbols)?,
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
            .collect::<CompileResult<Vec<String>>>()?,
        _ => panic!("Unexpected arg"),
    }
    .join(",");
    if let Some((register, var_pointer, var_type)) = outputs.first() {
        assert!(outputs.len() == 1);
        let utvc = compiler.ctx.acquire_temp_id();
        compiler.output.push_str(&format!(
            "    %asm{utvc} = call {} asm sideeffect inteldialect \"{}\", \"{}\"({})\n",
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

        compiler.output.push_str(&format!(
            "    store {} {}, {}* {}\n",
            var_type,
            format!("%asm{utvc}"),
            var_type,
            var_pointer
        ));
    } else {
        compiler.output.push_str(&format!(
            "    call {} asm sideeffect inteldialect \"{}\", \"{}\"({})\n",
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
    }
    Ok(CompiledValue::NoReturn)
}
