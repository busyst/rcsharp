use std::{cell::{Cell, RefCell}, collections::HashMap};
use ordered_hash_map::OrderedHashMap;
use rcsharp_parser::{compiler_primitives::{Layout, POINTER_SIZED_TYPE, PrimitiveInfo, PrimitiveKind, VOID_TYPE}, parser::{Attribute, ParserType, Span, StmtData}};

use crate::{compiler::{CompileResult, CompilerError, LLVMOutputHandler, SymbolTable}};
pub trait FlagManager {
    fn get_flags(&self) -> &Cell<u8>;

    fn has_flag(&self, flag: u8) -> bool {
        self.get_flags().get() & flag != 0
    }

    fn set_flag(&self, flag: u8) {
        self.get_flags().set(self.get_flags().get() | flag);
    }
}
#[derive(Debug, Clone, PartialEq)]
pub enum LLVMVal {
    Register(u32),    // %tmp1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
    Variable(u32),    // %v1
    VariableName(String),    // %smt
    Global(String),   // @func_name
    ConstantInteger(String), // 42, 0.5
    ConstantDecimal(String), // 42, 0.5
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
            LLVMVal::ConstantInteger(constant) => write!(f, "{}", constant),
            LLVMVal::ConstantDecimal(constant) => {
                let fx = constant.parse::<f64>().unwrap();
                write!(f, "0x{:X}", fx.to_bits())
            },
            LLVMVal::Void => write!(f, "void"),
            LLVMVal::Null => write!(f, "null"),
        }
    }
}

#[derive(Clone)]
pub enum CompilerType {
    Primitive(&'static PrimitiveInfo),
    Pointer(Box<CompilerType>),
    StructType(usize), // index in symbol table
    GenericSubst(Box<str>), // index in symbol table
    GenericStructType(usize, usize), // index in symbol table, index in implementation table

    GenericStructTypeTemplate(usize, Box<[CompilerType]>), // index in symbol table, implementation template
    
    Function(Box<CompilerType>, Box<[CompilerType]>), // return type index in symbol table, arguments indexes in implementation table
}

impl std::fmt::Debug for CompilerType {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Self::Primitive(arg0) => f.write_str(&format!("@{}", arg0.name)),
            Self::Pointer(arg0) => f.debug_tuple("Pointer").field(arg0).finish(),
            Self::StructType(arg0) => f.debug_tuple("StructType").field(arg0).finish(),
            Self::GenericSubst(arg0) => f.debug_tuple("GenericSubst").field(arg0).finish(),
            Self::GenericStructType(arg0, arg1) => f.debug_tuple("GenericStructType").field(arg0).field(arg1).finish(),
            Self::GenericStructTypeTemplate(arg0, arg1) => f.debug_tuple("GenericStructTypeTemplate").field(arg0).field(arg1).finish(),
            Self::Function(arg0, arg1) => f.debug_tuple("Function").field(arg0).field(arg1).finish(),
        }
    }
}
#[allow(unused)]
impl CompilerType {
    pub fn llvm_representation(&self, symbols: &SymbolTable) -> CompileResult<String> {
        match self {
            CompilerType::Primitive(info) => Ok(info.llvm_name.to_string()),
            CompilerType::StructType(idx) => Ok(symbols.get_type_by_id(*idx).llvm_representation()),
            CompilerType::Pointer(inner) => Ok({
                if let Some(x) = inner.as_primitive() {
                    if x == VOID_TYPE {
                        return Ok(format!("i8*"));
                    }
                }
                format!("{}*", inner.llvm_representation(symbols)?)
            }),
            CompilerType::Function(ret, args) => {
                let ret_llvm = ret.llvm_representation(symbols)?;
                let params_llvm: Vec<String> = args
                    .iter()
                    .map(|param_type| param_type.llvm_representation(symbols))
                    .collect::<CompileResult<Vec<String>>>()?;
                Ok(format!("{} ({})*", ret_llvm, params_llvm.join(", ")))
            }
            CompilerType::GenericStructType(x, y) => {
                let base_type = symbols.get_type_by_id(*x);
                let x = base_type.generic_implementations.borrow().iter().nth(*y).unwrap().clone();
                Ok(format!("%\"{}<{}>\"", base_type.llvm_representation_without_percent(), x.iter().map(|x| x.llvm_representation_in_generic(symbols).unwrap()).collect::<Vec<_>>().join(", ")))
            }
            _ => todo!("Get llvm representation for non-primitive type {:?}", self),
        }
    }
    pub fn llvm_representation_in_generic(&self, symbols: &SymbolTable) -> CompileResult<String> {
        match self {
            CompilerType::GenericStructType(x, y) => {
                let base_type = symbols.get_type_by_id(*x);
                let x = base_type.generic_implementations.borrow().iter().nth(*y).unwrap().clone();
                Ok(format!("%{}<{}>", base_type.llvm_representation_without_percent(), x.iter().map(|x| x.llvm_representation_in_generic(symbols).unwrap()).collect::<Vec<_>>().join(", ")))
            }
            _ => self.llvm_representation(symbols)
        }
    }
    pub fn into(given_type: &ParserType, ctx: &CodeGenContext) -> CompileResult<CompilerType> {
        Self::into_path(given_type, ctx.symbols, ctx.current_function_path())
    }
    pub fn into_path(given_type: &ParserType, symbols: &SymbolTable, current_path: &str) -> CompileResult<CompilerType> {
        if let Some(pt) = given_type.as_primitive_type() {
            return Ok(CompilerType::Primitive(pt));
        }
        if let Some(internal) = given_type.as_pointer() {
            return Ok(CompilerType::Pointer(Box::new(CompilerType::into_path(internal, symbols, current_path)?)));
        }
        if let Some((ret, args)) = given_type.as_function() {
            let ret = CompilerType::into_path(ret, symbols, current_path)?;
            let args = args.iter().map(|a| CompilerType::into_path(a, symbols, current_path)).collect::<CompileResult<Box<_>>>()?;
            return Ok(CompilerType::Function(Box::new(ret), args));
        }
        if let ParserType::Named(name) = given_type {
            if let Some(x) = symbols.get_type_id(format!("{}.{}", current_path, name).as_str()).or(symbols.get_type_id(name)) {
                return Ok(CompilerType::StructType(x));
            } else if let Some(x) = symbols.get_enum_type(format!("{}.{}", current_path, name).as_str()).or(symbols.get_enum_type(name)) {
                return Ok(x.clone());
            }
            else {
                return Ok(CompilerType::GenericSubst(name.clone().into_boxed_str()));
            };
        }
        if let ParserType::Generic(name, gen_args) = given_type {
            let id = if let Some(x) = symbols.get_type_id(format!("{}.{}", current_path, name).as_str()).or(symbols.get_type_id(name)) {
                x
            }else {
                panic!()
            };
            let mut vec_impl = vec![];
            let mut is_full_implementation = true;
            for gen_arg in gen_args {
                let x = CompilerType::into_path(gen_arg, symbols, current_path)?;
                if let CompilerType::GenericSubst(..) = &x {
                    is_full_implementation = false;
                }
                if let CompilerType::GenericStructTypeTemplate(..) = &x {
                    is_full_implementation = false;
                }
                vec_impl.push(x);
            }
            let structure = symbols.get_type_by_id(id);
            
            if is_full_implementation {
                let impl_index = structure.get_implementation_index(&vec_impl).expect("msg");
                return Ok(CompilerType::GenericStructType(id, impl_index));
            }else {
                return Ok(CompilerType::GenericStructTypeTemplate(id, vec_impl.into_boxed_slice()));            
            }
        }
        if let ParserType::NamespaceLink(link, inner) = given_type {
            let mut path = link.to_string();
            let mut inner_cursor = &**inner;
            while let ParserType::NamespaceLink(x, inner) = inner_cursor {
                inner_cursor = &**inner;
                path.push('.');
                path.push_str(x);
            }
            let c = Self::into_path_internal(inner_cursor, symbols, &path, current_path)?;
            return Ok(c);
        }
        println!("{:?}", given_type);
        println!("{:?}", current_path);

        return Err((Span::new(0, 1), CompilerError::Generic("".to_string())));
    }
    fn into_path_internal(given_type: &ParserType, symbols: &SymbolTable, type_path: &str, current_path: &str) -> CompileResult<CompilerType> {
        if let Some((name, gen_args)) = given_type.as_generic() {
            let id = if let Some(x) = symbols.get_type_id(format!("{}.{}", type_path, name).as_str()) {
                x    
            }else {
                panic!()
            };
            let mut vec_impl = vec![];
            let mut is_full_implementation = true;
            for gen_arg in gen_args {
                let x = CompilerType::into_path(gen_arg, symbols, current_path)?;
                if let CompilerType::GenericSubst(..) = &x {
                    is_full_implementation == false;
                }
                if let CompilerType::GenericStructTypeTemplate(..) = &x {
                    is_full_implementation == false;
                }
                vec_impl.push(x);
            }
            let structure = symbols.get_type_by_id(id);
            if is_full_implementation {
                if let Some(impl_index) = structure.generic_implementations.borrow().iter().position(|x| x.iter().eq(vec_impl.iter())) {
                    return Ok(CompilerType::GenericStructType(id, impl_index));                    
                }
                {
                    let mut x = structure.generic_implementations.borrow_mut();
                    x.push(vec_impl.into_boxed_slice());
                    return Ok(CompilerType::GenericStructType(id, x.len() - 1));
                }
            }
            panic!()
        }
        if let ParserType::Named(name) = given_type {
            if let Some(x) = symbols.get_type_id(format!("{}.{}", type_path, name).as_str()) {
                return Ok(CompilerType::StructType(x));
            }
        }
        panic!("{:?} {} {}", given_type, type_path, current_path);
    }
    pub fn with_substituted_generic_types(&self, map: &HashMap<String, CompilerType>, symbols: &SymbolTable) -> CompileResult<Self> {
        let mut s = self.clone();
        s.substitute_generic_types(map, symbols);
        Ok(s)
    }
    pub fn substitute_generic_types(&mut self, map: &HashMap<String, CompilerType>, symbols: &SymbolTable) -> CompileResult<()> {
        match self {
            CompilerType::Primitive(_) | CompilerType::StructType(_) | CompilerType::GenericStructType(_, _) => Ok(()),
            
            CompilerType::GenericSubst(name) => {
                if let Some(replacement) = map.get(name.as_ref()) {
                    *self = replacement.clone();
                    return Ok(());
                }else {
                    Err((Span::empty(), CompilerError::Generic(format!("Key {name} was not found in given hashmap {map:?}"))))
                }
            }
            CompilerType::GenericStructTypeTemplate(template, args) => {
                for arg in args.iter_mut() {
                    arg.substitute_generic_types(map, symbols);
                }
                let all_defined = !args.iter().any(|x| matches!(x, CompilerType::GenericSubst(..)));
                if all_defined {
                    let structure = symbols.get_type_by_id(*template);
                    let impl_id = structure.get_implementation_index(args).expect("msg");
                    *self = CompilerType::GenericStructType(*template, impl_id);
                    return Ok(());
                }else {
                    println!("{:?}", args);
                    unreachable!()
                }
            }
            CompilerType::Function(ret_type, args) => {
                ret_type.substitute_generic_types(map, symbols);
                for arg in args.iter_mut() {
                    arg.substitute_generic_types(map, symbols);
                }
                Ok(())
            }
            CompilerType::Pointer(inner) => inner.substitute_generic_types(map, symbols),
        }
    }
    pub fn is_bool(&self) -> bool {
        self.as_primitive().map(|x| x.is_bool()).unwrap_or(false)
    }
    pub fn is_integer(&self) -> bool {
        self.as_primitive().map(|x| x.is_integer()).unwrap_or(false)
    }
    pub fn is_signed_integer(&self) -> bool {
        self.as_primitive().map(|x| x.is_signed_integer()).unwrap_or(false)
    }
    pub fn is_unsigned_integer(&self) -> bool {
        self.as_primitive().map(|x| x.is_unsigned_integer()).unwrap_or(false)
    }
    pub fn is_pointer(&self) -> bool {
        matches!(self, CompilerType::Pointer(..))
    }
    pub fn is_void(&self) -> bool {
        self.as_primitive().map(|x| x.kind == PrimitiveKind::Void).unwrap_or(false)
    }
    pub fn is_decimal(&self) -> bool {
        self.as_primitive().map(|x| x.kind == PrimitiveKind::Decimal).unwrap_or(false)
    }
    pub fn as_pointer(&self) -> Option<&CompilerType> {
        match self {
            CompilerType::Pointer(x) => return Some(x),
            _ => None
        }
    }
    pub fn as_primitive(&self) -> Option<&'static PrimitiveInfo>{
        match self {
            CompilerType::Primitive(x) => return Some(x),
            _ => None
        }
    }
    pub fn dereference(&self) -> Option<&CompilerType>{
        match self {
            CompilerType::Pointer(x) => Some(&x),
            _ => None
        }
    }
    pub fn reference(self) -> CompilerType{
        CompilerType::Pointer(Box::new(self))
    }
    pub fn size_and_layout(&self, symbols: &SymbolTable) -> Layout{
        match self {
            CompilerType::Primitive(x) =>{
                x.layout
            }
            CompilerType::Pointer(x) =>{
                POINTER_SIZED_TYPE.layout
            }
            CompilerType::GenericStructType(x, y) =>{
                let struct_type = symbols.get_type_by_id(*x);
                let gen_impl = struct_type.generic_implementations.borrow();
                let mut map = HashMap::new();
                for (idx, name) in struct_type.generic_params.iter().enumerate() {
                    map.insert(name.clone(), gen_impl[*y][idx].clone());
                }
                drop(gen_impl);
                let fields = struct_type.fields.iter().map(|x| x.1.with_substituted_generic_types(&map, symbols).map(|x| x.size_and_layout(symbols))).collect::<CompileResult<Vec<_>>>().unwrap();
                let mut current_offset = 0;
                let mut max_alignment = 1;
                for field in fields {
                    let layout_of_type = field;
                    if layout_of_type.align == 0 { continue; }
                    max_alignment = u32::max(max_alignment, layout_of_type.align);
                    let padding = (layout_of_type.align - (current_offset % layout_of_type.align)) % layout_of_type.align;
                    
                    current_offset += padding;
                    current_offset += layout_of_type.size;
                }
                let final_padding = (max_alignment - (current_offset % max_alignment)) % max_alignment;
                let total_size = current_offset + final_padding;
                Layout::new(total_size, max_alignment)
            }
            CompilerType::StructType(x) =>{
                let struct_type = symbols.get_type_by_id(*x);
                if struct_type.layout.get().is_valid() {
                    return struct_type.layout.get();
                }
                let fields = struct_type.fields.iter().map(|x| x.1.size_and_layout(symbols)).collect::<Vec<_>>();
                let mut current_offset = 0;
                let mut max_alignment = 1;
                for field in fields {
                    let layout_of_type = field;
                    if layout_of_type.align == 0 { continue; }
                    max_alignment = u32::max(max_alignment, layout_of_type.align);
                    let padding = (layout_of_type.align - (current_offset % layout_of_type.align)) % layout_of_type.align;
                    
                    current_offset += padding;
                    current_offset += layout_of_type.size;
                }
                let final_padding = (max_alignment - (current_offset % max_alignment)) % max_alignment;
                let total_size = current_offset + final_padding;
                struct_type.layout.set(Layout::new(total_size, max_alignment));
                Layout::new(total_size, max_alignment)
            }
            _ => todo!("{:?}", self)
        }
    }
}
impl PartialEq<CompilerType> for CompilerType {
    fn eq(&self, other: &CompilerType) -> bool {
        match (self, other) {
            (CompilerType::Primitive(a), CompilerType::Primitive(b)) => a.name == b.name,
            (CompilerType::StructType(a), CompilerType::StructType(b)) => a == b,
            (CompilerType::GenericStructType(a1, a2), CompilerType::GenericStructType(b1, b2)) => a1 == b1 && a2 == b2,
            (CompilerType::Function(a1, a2), CompilerType::Function(b1, b2)) => a1 == b1 && a2 == b2,
            (CompilerType::Pointer(lct), CompilerType::Pointer(rct)) => lct == rct,
            _ => false
        }
    }
}
#[derive(Debug, Clone)]
pub struct Enum {
    pub path: Box<str>,
    pub name: Box<str>,
    pub base_type: CompilerType,
    pub fields: Box<[(String, LLVMVal)]>,
    pub attribs: Box<[Attribute]>,
    pub flags: Cell<u8>,
}
impl Enum {
    pub fn new(path: Box<str>, name: Box<str>, base_type: CompilerType, fields: Box<[(String, LLVMVal)]>, attribs: Box<[Attribute]>) -> Self {
        Self { path, name, base_type, fields, attribs, flags: Cell::new(0) }
    }
}
pub mod struct_flags {
    pub const GENERIC: u8 = 64;
    pub const PRIMITIVE_TYPE: u8 = 128;
}
#[derive(Debug, Clone)]
pub struct Struct {
    pub path: Box<str>,
    pub name: Box<str>,
    pub fields: Box<[(String, CompilerType)]>,
    pub generic_params: Box<[String]>,
    pub generic_implementations: RefCell<Vec<Box<[CompilerType]>>>,
    pub attribs: Box<[Attribute]>,
    pub flags: Cell<u8>,
    pub layout: Cell<Layout>
}
impl FlagManager for Struct {
    fn get_flags(&self) -> &Cell<u8> { &self.flags }
}

impl Struct {
    pub fn new(path: Box<str>, name: Box<str>, fields: Box<[(String, CompilerType)]>, attribs: Box<[Attribute]>, generic_params: Box<[String]>) -> Self {
        Self { path, name, fields, attribs, flags: Cell::new(if !generic_params.is_empty() {struct_flags::GENERIC} else {0}), generic_params, generic_implementations: RefCell::new(vec![]), layout: Cell::new(Layout::new_not_valid()) }
    }
    pub fn new_placeholder(path: String, name: String, flags: u8) -> Struct {
        Self { path: path.into(), name: name.into(), fields: Box::new([]), generic_params: Box::new([]), generic_implementations: RefCell::new(vec![]), attribs: Box::new([]), flags: Cell::new(flags), layout: Cell::new(Layout::new_not_valid()) }
    }

    pub fn is_primitive(&self) -> bool { self.has_flag(struct_flags::PRIMITIVE_TYPE) }
    pub fn is_generic(&self) -> bool { self.has_flag(struct_flags::GENERIC) }
    pub fn set_as_generic(&self) { self.set_flag(struct_flags::GENERIC); }
    pub fn llvm_representation(&self) -> String {
        if self.is_primitive() {
            return self.name.to_string();
        }
        if self.path.is_empty() {
            format!("%struct.{}", self.name)
        } else {
            format!("%struct.{}.{}", self.path, self.name)
        }
    }
    pub fn llvm_representation_without_percent(&self) -> String {
        if self.is_primitive() {
            return self.name.to_string();
        }
        if self.path.is_empty() {
            format!("struct.{}", self.name)
        } else {
            format!("struct.{}.{}", self.path, self.name)
        }
    }
    pub fn llvm_repr_index(&self, impl_index: usize, symbols: &SymbolTable) -> Box<str> {
        assert!(!self.is_primitive());
        let x= if self.path.is_empty() {
            format!("struct.{}", self.name)
        } else {
            format!("struct.{}.{}", self.path, self.name)
        };
        let a = &self.generic_implementations.borrow()[impl_index];
        format!("%\"{}<{}>\"", x, a.iter().map(|x| x.llvm_representation_in_generic(symbols).unwrap()).collect::<Vec<_>>().join(", ")).into_boxed_str()
    }
    pub fn full_path(&self) -> Box<str> {
        if self.path.is_empty() {
            self.name.clone()
        } else {
            format!("{}.{}", self.path, self.name).into()
        }
    }
    pub fn get_implementation_index(&self, given_generics: &[CompilerType]) -> Option<usize> {
        if !self.is_generic() {
            panic!("{} {} ALERT", self.path, self.name);
        }
        let generic_impl = self.generic_implementations.borrow();
        if !generic_impl.is_empty() {
            if generic_impl[0].len() != given_generics.len() {
                return None;
            }
        }
        if let Some(pos) = generic_impl.iter().position(|x| given_generics.eq(&**x)) {
            Some(pos)
        }else {
            drop(generic_impl);
            let mut generic_impl = self.generic_implementations.borrow_mut();
            generic_impl.push(given_generics.to_vec().into());
            Some(generic_impl.len() - 1)
        }
    }
}
pub mod function_flags {
    pub const GENERIC: u8 = 8;
    pub const PUBLIC: u8 = 16;
    pub const INLINE: u8 = 32;
    pub const CONST_EXPRESSION: u8 = 64;
    pub const IMPORTED: u8 = 128;
}
#[derive(Debug, Clone)]
pub struct Function {
    pub path: Box<str>,
    pub name: Box<str>,
    pub args: Box<[(String, CompilerType)]>,
    pub return_type: CompilerType,
    pub body: Box<[StmtData]>,
    pub attribs: Box<[Attribute]>,
    flags: Cell<u8>,

    pub generic_params: Box<[String]>,
    pub generic_implementations: RefCell<Vec<Box<[CompilerType]>>>,
    pub times_used: Cell<usize>,
}
impl FlagManager for Function {
    fn get_flags(&self) -> &Cell<u8> { &self.flags }
}

impl Function {
    pub fn new(path: Box<str>, name: Box<str>, args: Box<[(String, CompilerType)]>, return_type: CompilerType, body: Box<[StmtData]>, flags: Cell<u8>, attribs: Box<[Attribute]>, generic_params: Box<[String]>) -> Self {
        Self { path, name, args, return_type, body, attribs, flags, generic_params, generic_implementations: RefCell::new(vec![]), times_used: Cell::new(0) }
    }
    pub fn is_generic(&self) -> bool { self.has_flag(function_flags::GENERIC) }
    pub fn is_imported(&self) -> bool { self.has_flag(function_flags::IMPORTED) }
    pub fn is_inline(&self) -> bool { self.has_flag(function_flags::INLINE) }

    pub fn is_normal(&self) -> bool { !(self.is_generic() || self.is_inline() || self.is_imported()) }
    pub fn set_as_imported(&self) { self.set_flag(function_flags::IMPORTED);}
    
    pub fn path(&self) -> &str { &self.path }
    pub fn name(&self) -> &str { &self.name }
    pub fn use_fn(&self) { self.times_used.replace(self.times_used.get() + 1); }
    pub fn full_path(&self) -> Box<str> {
        if self.path.is_empty() {
            self.name.clone()
        } else {
            format!("{}.{}", self.path, self.name).into()
        }
    }
    pub fn get_implementation_index(&self, given_generics: &[CompilerType]) -> Option<usize> {
        if !self.is_generic() {
            panic!("{} {} ALERT", self.path, self.name);
        }
        if given_generics.iter().any(|x| matches!(x, CompilerType::GenericSubst(..))) {
            panic!("{} {} ALERT", self.path, self.name);
        }
        let generic_impl = self.generic_implementations.borrow();
        if !generic_impl.is_empty() {
            if generic_impl[0].len() != given_generics.len() {
                return None;
            }
        }
        if let Some(pos) = generic_impl.iter().position(|x| given_generics.eq(&**x)) {
            Some(pos)
        }else {
            drop(generic_impl);
            let mut generic_impl = self.generic_implementations.borrow_mut();
            generic_impl.push(given_generics.to_vec().into());
            Some(generic_impl.len() - 1)
        }
    }
    pub fn call_path_impl_index(&self, impl_index: usize, symbols: &SymbolTable) -> Box<str> {
        let x= if self.path.is_empty() {
            self.name.clone()
        } else {
            format!("{}.{}", self.path, self.name).into()
        };
        let a = &self.generic_implementations.borrow()[impl_index];
        format!("\"{}<{}>\"", x, a.iter().map(|x| x.llvm_representation_in_generic(symbols).unwrap()).collect::<Vec<_>>().join(", ")).into_boxed_str()
    }
    pub fn get_type(&self) -> CompilerType {
        CompilerType::Function(Box::new(self.return_type.clone()), self.args.iter().map(|x| x.1.clone()).collect::<Box<_>>())
    }

}
pub mod variable_flags {
    pub const HAS_READ: u8 = 1;
    pub const HAS_WROTE: u8 = 2;
    pub const MODIFIED_CONTENT: u8 = 4;
    pub const ALIAS_VALUE: u8 = 32;
    pub const CONSTANT: u8 = 64;
    pub const ARGUMENT: u8 = 128;
}
#[derive(Debug, Clone)]
pub struct Variable {
    compiler_type: CompilerType,
    flags: Cell<u8>,
    value: RefCell<Option<LLVMVal>>,
}
impl FlagManager for Variable {
    fn get_flags(&self) -> &Cell<u8> { &self.flags }
}

impl Variable {
    pub fn new(comp_type: CompilerType, is_const: bool) -> Self {
        let flags = if is_const { variable_flags::CONSTANT } else { 0 };
        Self {
            compiler_type: comp_type,
            flags: Cell::new(flags),
            value: RefCell::new(None),
        }
    }
    pub fn new_argument(comp_type: CompilerType) -> Self {
        Self {
            compiler_type: comp_type,
            flags: Cell::new(variable_flags::ARGUMENT),
            value: RefCell::new(None),
        }
    }
    pub fn new_alias(comp_type: CompilerType, value: Option<LLVMVal>) -> Self {
        Self {
            compiler_type: comp_type,
            flags: Cell::new(variable_flags::ARGUMENT | variable_flags::ALIAS_VALUE),
            value: RefCell::new(value),
        }
    }

    pub fn get_type(&self, write: bool, modify_content: bool) -> &CompilerType {
        if self.is_constant() && (write || modify_content) {
            panic!("Tried to mark constant variable as read or written");
        }

        let mut current = self.flags.get();
        if write {
            current |= variable_flags::HAS_WROTE;
        } else {
            current |= variable_flags::HAS_READ;
        }
        if modify_content {
            current |= variable_flags::MODIFIED_CONTENT;
        }
        self.flags.set(current);

        &self.compiler_type
    }
    pub fn is_argument(&self) -> bool { self.has_flag(variable_flags::ARGUMENT) }
    pub fn is_alias_value(&self) -> bool { self.has_flag(variable_flags::ALIAS_VALUE) }
    pub fn is_constant(&self) -> bool { self.has_flag(variable_flags::CONSTANT) }
    pub fn has_read(&self) -> bool { self.has_flag(variable_flags::HAS_READ) }
    pub fn has_wrote(&self) -> bool { self.has_flag(variable_flags::HAS_WROTE) }
    pub fn modified(&self) -> bool { self.has_flag(variable_flags::MODIFIED_CONTENT) }
    
    pub fn unusual_flags_to_string(&self) -> String {
        let mut output = String::new();
        if !self.has_read() {
            output.push_str("Unread\t");
        }
        if !self.is_argument() || self.has_wrote() {
            if !self.has_wrote() && !self.modified() {
                output.push_str("Unwritten\\Unmodified\t");
            }
            if self.is_argument() {
                output.push_str("Argument\t");
            }
        }
        output
    }
    pub fn set_value(&self, value: Option<LLVMVal>) {
        self.value.replace(value);
    }

    pub fn value(&self) -> &RefCell<Option<LLVMVal>> {
        &self.value
    }

    pub fn compiler_type(&self) -> &CompilerType {
        &self.compiler_type
    }
    pub fn get_llvm_value(&self, var_id: u32, var_name: &str, ctx: &CodeGenContext, output: &mut LLVMOutputHandler) -> CompileResult<LLVMVal> {
        if let Some(val) = self.value.borrow().as_ref() {
            return Ok(val.clone());
        }
        if self.is_argument() {
            let llvm_repr = if self.is_alias_value() {
                LLVMVal::Register(var_id)
            } else {
                LLVMVal::VariableName(var_name.to_string())
            };
            return Ok(llvm_repr);
        }
        let type_str = {let mut x = self.compiler_type.clone(); x.substitute_generic_types(&ctx.symbols.alias_types, ctx.symbols)?; x}.llvm_representation(ctx.symbols)?;
        let temp_id = ctx.aquire_unique_temp_value_counter();

        output.push_str(&format!(
            "    %tmp{} = load {}, {}* %v{}\n",
            temp_id, type_str, type_str, var_id
        ));
        Ok(LLVMVal::Register(temp_id))
    }
}
#[derive(Debug, Clone)]
struct ScopeLayer {
    variables: OrderedHashMap<String, (Variable, u32)>,
    loop_index: Option<u32>,
}
#[derive(Debug, Clone)]
pub struct Scope {
    layers: Vec<ScopeLayer>,
}
impl Default for Scope {
    fn default() -> Self {
        Self::new()
    }
}

impl Scope {
    pub fn new() -> Self {
        Self {
            layers: vec![ScopeLayer {
                variables: OrderedHashMap::new(),
                loop_index: None,
            }],
        }
    }

    pub fn clear(&mut self) {
        self.layers.clear();
        self.layers.push(ScopeLayer {
            variables: OrderedHashMap::new(),
            loop_index: None,
        });
    }
    pub fn get_variable(&self, name: &str) -> Option<&(Variable, u32)> {
        for layer in self.layers.iter().rev() {
            if let Some(var) = layer.variables.get(name) {
                return Some(var);
            }
        }
        None
    }
    pub fn add_variable(&mut self, name: String, variable: Variable, unique_value_tag: u32) {
        let current_layer = self.layers.last_mut().expect("Scope stack is empty");
        
        if current_layer.variables.contains_key(&name) {
            let var = current_layer.variables.remove(&name).unwrap();
            self.leave_scope((&name, &var));
        }

        let current_layer = self.layers.last_mut().expect("Scope stack is empty");
        current_layer.variables.insert(name, (variable, unique_value_tag));
    }
    pub fn leave_scope(&self, _variable: (&String, &(Variable, u32))){
        //println!("Variable {}, has left scope.\nFlags:\t{}", variable.0, variable.1.0.unusual_flags_to_string());
    }
    pub fn enter_scope(&mut self) {
        let current_loop_index = self.loop_index();
        self.layers.push(ScopeLayer { variables: OrderedHashMap::new(), loop_index: current_loop_index });
    }
    pub fn exit_scope(&mut self) {
        if self.layers.len() <= 1 {
            panic!("Attempted to drop the global scope");
        }

        let layer = self.layers.pop().unwrap();

        for var in layer.variables.iter().rev() {
            self.leave_scope(var);
        }
    }
    pub fn loop_index(&self) -> Option<u32> {
        self.layers.last().and_then(|l| l.loop_index)
    }

    pub fn set_loop_index(&mut self, loop_index: Option<u32>) {
        if let Some(layer) = self.layers.last_mut() {
            layer.loop_index = loop_index;
        }
    }
}


pub struct CodeGenContext<'a> {
    pub symbols: &'a SymbolTable,
    pub current_function: usize,
    pub scope: Scope,

    temp_value_counter: Cell<u32>,
    variable_counter: Cell<u32>,
    logic_counter: Cell<u32>,
}
impl<'a> CodeGenContext<'a> {
    pub fn new(symbols: &'a SymbolTable, function: usize) -> Self {
        Self {
            symbols,
            current_function: function,
            scope: Scope::new(),
            temp_value_counter: Cell::new(0),
            variable_counter: Cell::new(0),
            logic_counter: Cell::new(0),
        }
    }
    pub fn current_function_path(&self) -> &str{
        &self.symbols.get_function_by_id(self.current_function).path
    }
    pub fn aquire_unique_temp_value_counter(&self) -> u32{
        self.temp_value_counter.replace(self.temp_value_counter.get() + 1)
    }
    pub fn aquire_unique_variable_index(&self) -> u32{
        self.variable_counter.replace(self.variable_counter.get() + 1)
    }
    pub fn aquire_unique_logic_counter(&self) -> u32{
        self.logic_counter.replace(self.logic_counter.get() + 1)
    }
}
