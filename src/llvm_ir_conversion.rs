use std::{fs::File, io::Write};

use crate::{
    compiler::SymbolTable,
    intermediate_representation::{
        CompilerTypeImplementationIndex, TypeImplementationEntry, TypeIndex, TypeType,
    },
};

fn mangle(sig: &str) -> String {
    sig.trim_start_matches('%').replace('*', "p")
}

fn human_readable_types(signature_vector: &mut [String], sym_table: &SymbolTable) {
    for (idx, tie) in sym_table.type_implementation_vector.iter().enumerate() {
        if let TypeImplementationEntry::Normal(base) = tie {
            let tve = &sym_table.type_vector[base.as_index()];
            if let TypeType::Compiler(..) = tve.type_type {
                continue;
            }
            signature_vector[idx] = tve
                .path
                .0
                .iter()
                .map(|x| sym_table.interner.get(*x))
                .collect::<Vec<_>>()
                .join(".");
            signature_vector[idx].insert(0, '%');
        }
    }
}
pub fn fill_default(signature_vector: &mut [String], sym_table: &SymbolTable) {
    for (idx, tie) in sym_table.type_implementation_vector.iter().enumerate() {
        if let TypeImplementationEntry::Normal(TypeIndex(base)) = tie {
            if let TypeType::Compiler(c) = sym_table.type_vector[*base].type_type {
                signature_vector[idx] = c.to_string();
            }
        }
    }
}

fn resolve(
    index: CompilerTypeImplementationIndex,
    signature_vector: &mut [String],
    sym_table: &SymbolTable,
    generic_args: Option<&[String]>,
    typed_pointers: bool,
) -> Option<String> {
    if !signature_vector[index.as_index()].is_empty() {
        return Some(signature_vector[index.as_index()].clone());
    }

    let result = match &sym_table.type_implementation_vector[index.as_index()] {
        TypeImplementationEntry::Normal(x) => format!("%{}", x.0),

        TypeImplementationEntry::Pointered { base, pointered } => {
            if !typed_pointers {
                "ptr".to_string()
            } else {
                let inner = if matches!(
                    &sym_table.type_implementation_vector[base.as_index()],
                    TypeImplementationEntry::Normal(TypeIndex(0))
                ) {
                    "i8".to_string()
                } else {
                    resolve(
                        *base,
                        signature_vector,
                        sym_table,
                        generic_args,
                        typed_pointers,
                    )?
                };
                format!("{}{}", inner, "*".repeat(*pointered as usize))
            }
        }

        TypeImplementationEntry::GenericImplementation {
            base,
            implementation,
        } => {
            let mut parts = Vec::with_capacity(implementation.len());
            for &arg in implementation.iter() {
                let s = resolve(
                    arg,
                    signature_vector,
                    sym_table,
                    generic_args,
                    typed_pointers,
                )?;
                parts.push(mangle(&s));
            }
            let q = sym_table.type_vector[base.as_index()]
                .path
                .0
                .iter()
                .map(|x| sym_table.interner.get(*x))
                .collect::<Vec<_>>()
                .join(".");

            format!("%{}_{}", mangle(&q), parts.join("."))
        }

        TypeImplementationEntry::GenericParameter(param_index) => {
            generic_args?.get(*param_index)?.clone()
        }

        TypeImplementationEntry::Enum(x) => resolve(
            sym_table.enum_vector[*x].base_type,
            signature_vector,
            sym_table,
            generic_args,
            typed_pointers,
        )?,

        TypeImplementationEntry::ConstantSizeArray { base, size } => {
            let inner = resolve(
                *base,
                signature_vector,
                sym_table,
                generic_args,
                typed_pointers,
            )?;
            format!("[{} x {}]", size, inner)
        }

        TypeImplementationEntry::Function {
            arguments,
            return_type,
        } => {
            let ret = resolve(
                *return_type,
                signature_vector,
                sym_table,
                generic_args,
                typed_pointers,
            )?;
            let mut args = Vec::with_capacity(arguments.len());
            for &a in arguments.iter() {
                args.push(resolve(
                    a,
                    signature_vector,
                    sym_table,
                    generic_args,
                    typed_pointers,
                )?);
            }
            if typed_pointers {
                format!("{} ({})*", ret, args.join(", "))
            } else {
                "ptr".to_string()
            }
        }
    };

    if generic_args.is_none() {
        signature_vector[index.as_index()] = result.clone();
    }
    Some(result)
}

//pub fn fill_llvm_ir_from_implementation<'a>(
//    index: CompilerTypeImplementationIndex,
//    signature_vector: &'a mut [String],
//    sym_table: &SymbolTable,
//    typed_pointers: bool,
//) -> Option<&'a str> {
//    resolve(index, signature_vector, sym_table, None, typed_pointers)?;
//    Some(&signature_vector[index])
//}

pub fn write_all_used_types(
    output: &mut File,
    signature_vector: &mut [String],
    sym_table: &SymbolTable,
    human_readable: bool,
) {
    let typed_pointers = true;

    fill_default(signature_vector, sym_table);
    if human_readable {
        human_readable_types(signature_vector, sym_table);
    }

    for idx in 0..sym_table.type_implementation_vector.len() {
        let _ = resolve(
            CompilerTypeImplementationIndex::new(idx),
            signature_vector,
            sym_table,
            None,
            typed_pointers,
        );
    }

    for (idx, tie) in sym_table.type_implementation_vector.iter().enumerate() {
        match tie {
            TypeImplementationEntry::Normal(base) => {
                let tve = &sym_table.type_vector[base.as_index()];
                if tve.type_type != TypeType::Normal {
                    continue;
                }
                let mut fields = Vec::with_capacity(tve.members.len());
                for t in tve.members.iter() {
                    fields.push(
                        resolve(t.1, signature_vector, sym_table, None, typed_pointers)
                            .unwrap_or_else(|| {
                                panic!("unresolvable field type in {}", signature_vector[idx])
                            }),
                    );
                }
                writeln!(
                    output,
                    "{} = type {{ {} }}",
                    signature_vector[idx],
                    fields.join(", ")
                )
                .unwrap();
            }

            TypeImplementationEntry::GenericImplementation {
                base,
                implementation,
            } => {
                let tve = &sym_table.type_vector[base.as_index()];

                if tve.type_type != TypeType::Generic {
                    todo!()
                }
                if implementation.is_empty() || signature_vector[idx].is_empty() {
                    continue;
                }

                let mut args = Vec::with_capacity(implementation.len());
                let mut concrete = true;
                for &a in implementation.iter() {
                    match resolve(a, signature_vector, sym_table, None, typed_pointers) {
                        Some(s) => args.push(s),
                        None => {
                            concrete = false;
                            break;
                        }
                    }
                }
                if !concrete {
                    continue;
                }

                let mut fields = Vec::with_capacity(tve.members.len());
                for t in tve.members.iter() {
                    fields.push(
                        resolve(
                            t.1,
                            signature_vector,
                            sym_table,
                            Some(&args),
                            typed_pointers,
                        )
                        .unwrap_or_else(|| {
                            panic!("unresolvable field type in {}", signature_vector[idx])
                        }),
                    );
                }
                writeln!(
                    output,
                    "{} = type {{ {} }}",
                    signature_vector[idx],
                    fields.join(", ")
                )
                .unwrap();
            }

            _ => {}
        }
    }
}

pub fn write_all_statics(
    output: &mut File,
    signatures: &mut SignatureHolder,
    sym_table: &SymbolTable,
    human_readable: bool,
) {
    for (idx, tie) in sym_table.svar_vector.iter().enumerate() {
        signatures.static_var_signatures[idx] = if human_readable {
            tie.path
                .0
                .iter()
                .map(|x| sym_table.interner.get(*x))
                .collect::<Vec<_>>()
                .join(".")
        } else {
            format!("t{}", idx)
        };
        writeln!(
            output,
            "@{} = internal global {} zeroinitializer",
            signatures.static_var_signatures[idx],
            signatures.type_signatures[tie.var_type.as_index()]
        )
        .unwrap();
    }
}
#[derive(Debug, Default)]
pub struct SignatureHolder {
    pub type_signatures: Box<[String]>,
    pub static_var_signatures: Box<[String]>,
    pub function_signatures: Box<[String]>,
}

impl SignatureHolder {
    pub fn new(type_count: usize, static_var_count: usize, function_count: usize) -> Self {
        Self {
            type_signatures: {
                let mut x = vec![];
                x.resize(type_count, String::new());
                x.into_boxed_slice()
            },
            static_var_signatures: {
                let mut x = vec![];
                x.resize(static_var_count, String::new());
                x.into_boxed_slice()
            },
            function_signatures: {
                let mut x = vec![];
                x.resize(function_count, String::new());
                x.into_boxed_slice()
            },
        }
    }
}
