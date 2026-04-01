use crate::compiler::{
    context::{FileID, StringEntry},
    expression::ExpressionCompileResult,
    passes::pass_llvm_gen::CodeGenContext,
    structs::{
        CompiledValue, ContextPath, ContextPathDictionary, ContextPathDictionaryIter,
        ContextPathDictionaryIterMut, ContextPathEnd, LLVMInstruction,
    },
};
use ordered_hash_map::OrderedHashMap;
use rcsharp_lexer::{lex_text, LexerError, Span};
use rcsharp_parser::{
    compiler_primitives::{Layout, PrimitiveInfo, PrimitiveKind, POINTER_SIZED_TYPE, VOID_TYPE},
    parser::{Attribute, ParserType, StmtData},
};
use std::{
    cell::{Cell, RefCell},
    collections::HashMap,
    sync::Arc,
};
#[derive(Debug, Clone, PartialEq)]
pub enum LLVMVal {
    Register(u32),         // %tmp1
    Variable(u32),         // %v1
    VariableName(String),  // %smt
    Global(String),        // @func_name
    ConstantInteger(i128), // 42
    ConstantDecimal(f64),  // 42.0, 0.5
    ConstantBoolean(bool), // true/false
    Null,                  // null
    Void,                  // void
}
impl ToString for LLVMVal {
    fn to_string(&self) -> String {
        match self {
            LLVMVal::Register(id) => format!("%tmp{}", id),
            LLVMVal::Variable(id) => format!("%v{}", id),
            LLVMVal::VariableName(name) => format!("%{}", name),
            LLVMVal::Global(name) => format!("@{}", name),
            LLVMVal::ConstantInteger(val) => format!("{}", val),
            LLVMVal::ConstantDecimal(val) => {
                let f32_precision_val = *val as f32 as f64;
                format!("0x{:016X}", f32_precision_val.to_bits())
            }
            LLVMVal::ConstantBoolean(val) => format!("{}", val),
            LLVMVal::Void => format!("void"),
            LLVMVal::Null => format!("null"),
        }
    }
}

#[derive(Clone)]
pub enum CompilerType {
    Primitive(&'static PrimitiveInfo),
    Pointer(Box<CompilerType>),
    ConstantArray(usize, Box<CompilerType>),
    Struct(usize), // index in symbol table
    GenericPlaceholder(Box<str>),
    GenericStructInstance(usize, usize), // index in symbol table, index in implementation table
    GenericStructTemplate(usize, Box<[CompilerType]>), // index in symbol table, implementation template
    Function(Box<CompilerType>, Box<[CompilerType]>), // return type index in symbol table, arguments indexes in implementation table
}

impl Default for CompilerType {
    fn default() -> Self {
        Self::Primitive(VOID_TYPE)
    }
}
impl std::fmt::Debug for CompilerType {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Self::Primitive(info) => write!(f, "#{}", info.name),
            Self::Pointer(inner) => f.debug_tuple("Pointer").field(inner).finish(),
            Self::ConstantArray(size, inner) => f
                .debug_tuple("ConstantArray")
                .field(size)
                .field(inner)
                .finish(),
            Self::Struct(id) => f.debug_tuple("Struct").field(id).finish(),
            Self::GenericPlaceholder(name) => {
                f.debug_tuple("GenericPlaceholder").field(name).finish()
            }
            Self::GenericStructInstance(id, impl_idx) => f
                .debug_tuple("GenericStructInstance")
                .field(id)
                .field(impl_idx)
                .finish(),
            Self::GenericStructTemplate(id, args) => f
                .debug_tuple("GenericStructTemplate")
                .field(id)
                .field(args)
                .finish(),
            Self::Function(ret, args) => f.debug_tuple("Function").field(ret).field(args).finish(),
        }
    }
}
impl PartialEq for CompilerType {
    fn eq(&self, other: &Self) -> bool {
        match (self, other) {
            (Self::Primitive(a), Self::Primitive(b)) => a.name == b.name,
            (Self::Struct(a), Self::Struct(b)) => a == b,
            (
                Self::GenericStructInstance(id_a, impl_a),
                Self::GenericStructInstance(id_b, impl_b),
            ) => id_a == id_b && impl_a == impl_b,
            (Self::Function(ret_a, args_a), Self::Function(ret_b, args_b)) => {
                ret_a == ret_b && args_a == args_b
            }
            (Self::Pointer(a), Self::Pointer(b)) => a == b,
            _ => false,
        }
    }
}
#[allow(unused)]
impl CompilerType {
    pub fn llvm_representation(&self, symbols: &SymbolTable) -> ExpressionCompileResult<String> {
        match self {
            Self::Primitive(info) => Ok(info.llvm_name.to_string()),
            Self::Struct(idx) => Ok(symbols.get_type_by_id(*idx).llvm_representation()),
            Self::Pointer(inner) => {
                if let Some(prim) = inner.as_primitive() {
                    if prim == VOID_TYPE {
                        return Ok("i8*".to_string());
                    }
                }
                Ok(format!("{}*", inner.llvm_representation(symbols)?))
            }
            Self::Function(ret, args) => {
                let ret_llvm = ret.llvm_representation(symbols)?;
                let params_llvm = args
                    .iter()
                    .map(|param| param.llvm_representation(symbols))
                    .collect::<ExpressionCompileResult<Vec<_>>>()?;
                Ok(format!("{} ({})", ret_llvm, params_llvm.join(", ")))
            }
            Self::GenericStructInstance(base_id, impl_idx) => {
                let base_type = symbols.get_type_by_id(*base_id);
                let impl_args = base_type
                    .generic_implementations
                    .borrow()
                    .get(*impl_idx)
                    .unwrap()
                    .clone();

                let arg_reprs = impl_args
                    .iter()
                    .map(|arg| arg.llvm_representation_in_generic(symbols))
                    .collect::<ExpressionCompileResult<Vec<_>>>()?;

                Ok(format!(
                    "%\"{}<{}>\"",
                    base_type.llvm_representation_without_percent(),
                    arg_reprs.join(", ")
                ))
            }
            Self::GenericStructInstance(base_id, impl_idx) => {
                let base_type = symbols.get_type_by_id(*base_id);
                let impl_args = base_type
                    .generic_implementations
                    .borrow()
                    .get(*impl_idx)
                    .unwrap()
                    .clone();

                let arg_reprs = impl_args
                    .iter()
                    .map(|arg| arg.llvm_representation_in_generic(symbols))
                    .collect::<ExpressionCompileResult<Vec<_>>>()?;

                Ok(format!(
                    "%\"{}<{}>\"",
                    base_type.llvm_representation_without_percent(),
                    arg_reprs.join(", ")
                ))
            }
            Self::ConstantArray(size, inner) => Ok(format!(
                "[{} x {}]",
                size,
                inner.llvm_representation(symbols)?
            )),
            _ => Err(CompilerError::Generic(format!("Cannot get LLVM repr for {:?}", self)).into()),
        }
    }
    pub fn llvm_representation_in_generic(
        &self,
        symbols: &SymbolTable,
    ) -> ExpressionCompileResult<String> {
        match self {
            Self::GenericStructInstance(base_id, impl_idx) => {
                let base_type = symbols.get_type_by_id(*base_id);
                let impl_args = base_type
                    .generic_implementations
                    .borrow()
                    .get(*impl_idx)
                    .unwrap()
                    .clone();

                let arg_reprs = impl_args
                    .iter()
                    .map(|arg| arg.llvm_representation_in_generic(symbols))
                    .collect::<ExpressionCompileResult<Vec<_>>>()?;

                Ok(format!(
                    "%{}<{}>",
                    base_type.llvm_representation_without_percent(),
                    arg_reprs.join(", ")
                ))
            }
            _ => self.llvm_representation(symbols),
        }
    }
    pub fn from_parser_type(
        given_type: &ParserType,
        symbols: &SymbolTable,
        current_path: &ContextPath,
    ) -> ExpressionCompileResult<CompilerType> {
        if let Some(pt) = given_type.as_primitive_type() {
            return Ok(Self::Primitive(pt));
        }
        if let Some(inner) = given_type.as_pointer() {
            let inner_type = Self::from_parser_type(inner, symbols, current_path)?;
            return Ok(Self::Pointer(Box::new(inner_type)));
        }
        if let Some((ret, args)) = given_type.as_function() {
            let ret_type = Self::from_parser_type(ret, symbols, current_path)?;
            let arg_types = args
                .iter()
                .map(|a| Self::from_parser_type(a, symbols, current_path))
                .collect::<ExpressionCompileResult<Box<_>>>()?;
            return Ok(Self::Function(Box::new(ret_type), arg_types));
        }
        if let ParserType::Named(name) = given_type {
            let glob_path = ContextPathEnd::from_context_path(current_path.clone(), name);
            let local_path = ContextPathEnd::from_path("", name);

            if let Some(id) = symbols
                .get_type_id_by_path(&glob_path)
                .or_else(|| symbols.get_type_id_by_path(&local_path))
            {
                return Ok(Self::Struct(id));
            }

            if let Some(enum_def) = symbols
                .get_enum_by_path(&glob_path)
                .or_else(|| symbols.get_enum_by_path(&local_path))
            {
                return Ok(enum_def.base_type.clone());
            }

            if let Some(alias) = symbols.alias_types().get(name) {
                return Ok(alias.clone());
            }

            return Ok(Self::GenericPlaceholder(name.clone().into_boxed_str()));
        }
        if let ParserType::Generic(name, args) = given_type {
            let glob_path = ContextPathEnd::from_context_path(current_path.clone(), name);
            let local_path = ContextPathEnd::from_path("", name);
            let id = symbols
                .get_type_id_by_path(&glob_path)
                .or_else(|| symbols.get_type_id_by_path(&local_path))
                .expect(&format!("Generic type {} not found", name));

            let mut compiled_args = Vec::new();
            let mut is_concrete = true;

            for arg in args {
                let compiled_arg = Self::from_parser_type(arg, symbols, current_path)?;
                if matches!(
                    compiled_arg,
                    Self::GenericPlaceholder(_) | Self::GenericStructTemplate(..)
                ) {
                    is_concrete = false;
                }
                compiled_args.push(compiled_arg);
            }

            if is_concrete {
                let structure = symbols.get_type_by_id(id);
                let impl_index = structure
                    .get_implementation_index(&compiled_args)
                    .expect("Failed to get implementation index");
                return Ok(Self::GenericStructInstance(id, impl_index));
            } else {
                return Ok(Self::GenericStructTemplate(
                    id,
                    compiled_args.into_boxed_slice(),
                ));
            }
        }
        if let ParserType::NamespaceLink(link, inner) = given_type {
            let mut path_builder = vec![Arc::from(link.to_string().into_boxed_str())];
            let mut current = &**inner;
            while let ParserType::NamespaceLink(next_segment, next_inner) = current {
                path_builder.push(Arc::from(next_segment.to_string().into_boxed_str()));
                current = &**next_inner;
            }
            return Self::resolve_namespaced_type(
                current,
                symbols,
                &ContextPath::new(path_builder),
                current_path,
            );
        }
        if let ParserType::ConstantSizeArray(inner, size) = given_type {
            let inner_type = Self::from_parser_type(inner, symbols, current_path)?;
            return Ok(Self::ConstantArray(*size as usize, Box::new(inner_type)));
        }
        panic!("Unknown type format: {:?}", given_type);
    }
    fn resolve_namespaced_type(
        given_type: &ParserType,
        symbols: &SymbolTable,
        namespace_path: &ContextPath,
        context_path: &ContextPath,
    ) -> ExpressionCompileResult<Self> {
        if let Some((name, args)) = given_type.as_generic() {
            let glob_path = ContextPathEnd::from_context_path(namespace_path.clone(), name);
            let id = symbols
                .get_type_id_by_path(&glob_path)
                .expect(&format!("Type {} not found", glob_path.to_string()));

            let mut compiled_args = Vec::new();
            let mut is_concrete = true;

            for arg in args {
                let compiled_arg = Self::from_parser_type(arg, symbols, context_path)?;
                if matches!(
                    compiled_arg,
                    Self::GenericPlaceholder(_) | Self::GenericStructTemplate(..)
                ) {
                    is_concrete = false;
                }
                compiled_args.push(compiled_arg);
            }

            if is_concrete {
                let structure = symbols.get_type_by_id(id);
                let impl_idx = structure.ensure_generic_implementation(&compiled_args);
                return Ok(Self::GenericStructInstance(id, impl_idx));
            }
            panic!("Cannot handle non-concrete generic namespace resolution yet");
        }

        if let ParserType::Named(name) = given_type {
            let glob_path = ContextPathEnd::from_context_path(namespace_path.clone(), name);
            if let Some(id) = symbols.get_type_id_by_path(&glob_path) {
                return Ok(Self::Struct(id));
            }
            panic!("Type {} not found", glob_path.to_string());
        }

        panic!(
            "Invalid namespaced type: {:?} in {:?}",
            given_type, namespace_path
        );
    }

    pub fn with_substituted_generics(
        &self,
        map: &HashMap<String, CompilerType>,
        symbols: &SymbolTable,
    ) -> ExpressionCompileResult<Self> {
        let mut cloned = self.clone();
        cloned.substitute_generics(map, symbols)?;
        Ok(cloned)
    }
    pub fn substitute_global_aliases(
        &mut self,
        symbols: &SymbolTable,
    ) -> ExpressionCompileResult<()> {
        self.substitute_generics(symbols.alias_types(), symbols)
    }
    pub fn substitute_generics(
        &mut self,
        map: &HashMap<String, CompilerType>,
        symbols: &SymbolTable,
    ) -> ExpressionCompileResult<()> {
        match self {
            Self::Primitive(_) | Self::Struct(_) | Self::GenericStructInstance(_, _) => Ok(()),
            Self::GenericPlaceholder(name) => {
                if let Some(replacement) = map.get(name.as_ref()) {
                    *self = replacement.clone();
                    Ok(())
                } else {
                    return Err(CompilerError::Generic(format!(
                        "Generic placeholder {} not found in substitution map",
                        name,
                    ))
                    .into());
                }
            }
            Self::GenericStructTemplate(template_id, args) => {
                for arg in args.iter_mut() {
                    arg.substitute_generics(map, symbols)?;
                }

                let is_fully_defined = !args
                    .iter()
                    .any(|x| matches!(x, Self::GenericPlaceholder(_)));

                if is_fully_defined {
                    let structure = symbols.get_type_by_id(*template_id);
                    let impl_idx = structure
                        .get_implementation_index(args)
                        .expect("Failed to get implementation");
                    *self = Self::GenericStructInstance(*template_id, impl_idx);
                }
                Ok(())
            }
            Self::Function(ret, args) => {
                ret.substitute_generics(map, symbols)?;
                for arg in args.iter_mut() {
                    arg.substitute_generics(map, symbols)?;
                }
                Ok(())
            }
            Self::ConstantArray(_, inner) => inner.substitute_generics(map, symbols),
            Self::Pointer(inner) => inner.substitute_generics(map, symbols),
        }
    }

    pub fn is_same_ground_type_struct(&self, type_id: usize) -> bool {
        match self {
            Self::Pointer(inner) => inner.is_same_ground_type_struct(type_id),
            Self::Struct(id) => *id == type_id,
            Self::GenericStructInstance(id, _) => *id == type_id,
            Self::GenericStructTemplate(id, _) => *id == type_id,
            _ => false,
        }
    }
    pub fn is_same_base_type(&self, type_id: &CompilerType) -> bool {
        match self {
            Self::Pointer(inner) => {
                inner.is_same_base_type(type_id) || type_id.is_same_base_type(inner)
            }
            Self::ConstantArray(_, x) => **x == *type_id,
            x => *x == *type_id,
        }
    }
    pub fn is_bool(&self) -> bool {
        self.as_primitive().map(|x| x.is_bool()).unwrap_or(false)
    }
    pub fn is_integer(&self) -> bool {
        self.as_primitive().map(|x| x.is_integer()).unwrap_or(false)
    }
    pub fn is_signed_integer(&self) -> bool {
        self.as_primitive()
            .map(|x| x.is_signed_integer())
            .unwrap_or(false)
    }
    pub fn is_unsigned_integer(&self) -> bool {
        self.as_primitive()
            .map(|x| x.is_unsigned_integer())
            .unwrap_or(false)
    }
    pub fn is_pointer(&self) -> bool {
        matches!(self, CompilerType::Pointer(..))
    }
    pub fn is_void(&self) -> bool {
        self.as_primitive()
            .map(|x| x.kind == PrimitiveKind::Void)
            .unwrap_or(false)
    }
    pub fn is_decimal(&self) -> bool {
        self.as_primitive()
            .map(|x| x.kind == PrimitiveKind::Decimal)
            .unwrap_or(false)
    }

    pub fn is_function(&self) -> bool {
        match self {
            Self::Function(..) => true,
            _ => false,
        }
    }
    pub fn as_pointer(&self) -> Option<&CompilerType> {
        match self {
            Self::Pointer(x) => Some(x),
            _ => None,
        }
    }
    pub fn as_primitive(&self) -> Option<&'static PrimitiveInfo> {
        match self {
            Self::Primitive(x) => Some(x),
            _ => None,
        }
    }
    pub fn as_constant_array(&self) -> Option<(usize, &CompilerType)> {
        match self {
            Self::ConstantArray(x, y) => Some((*x, &**y)),
            _ => None,
        }
    }
    pub fn dereference(&self) -> Option<&CompilerType> {
        match self {
            Self::Pointer(x) => Some(x),
            _ => None,
        }
    }
    pub fn reference(self) -> CompilerType {
        Self::Pointer(Box::new(self))
    }
    pub fn calculate_layout(&self, symbols: &SymbolTable) -> Layout {
        match self {
            Self::Primitive(info) => info.layout,
            Self::Pointer(_) => POINTER_SIZED_TYPE.layout,
            Self::Struct(id) => {
                let structure = symbols.get_type_by_id(*id);
                if structure.is_generic() {
                    panic!(
                        "Cannot calculate layout for generic struct {:?}",
                        structure.full_path()
                    );
                }
                if let Some(layout) = structure.get_cached_layout() {
                    return layout;
                }
                let layout = Self::compute_struct_layout(
                    structure.fields.iter().map(|f| f.1.clone()),
                    symbols,
                );
                structure.set_cached_layout(layout);
                layout
            }
            Self::GenericStructInstance(id, impl_idx) => {
                let structure = symbols.get_type_by_id(*id);
                let impl_args = &structure.generic_implementations.borrow()[*impl_idx];

                let mut sub_map = HashMap::new();
                for (i, param_name) in structure.generic_params.iter().enumerate() {
                    sub_map.insert(param_name.clone(), impl_args[i].clone());
                }

                let concretized_fields = structure
                    .fields
                    .iter()
                    .map(|(_, ty)| ty.with_substituted_generics(&sub_map, symbols).unwrap());

                Self::compute_struct_layout(concretized_fields, symbols)
            }
            Self::ConstantArray(count, y) => {
                let mut x = y.calculate_layout(symbols);
                if x.align > 0 {
                    let padding = (x.align - (x.size % x.align)) % x.align;
                    x.size = (x.size + padding) * (*count as u32);
                } else {
                    x.size *= *count as u32;
                }
                x
            }
            _ => panic!("Cannot calculate layout for {:?}", self),
        }
    }
    fn compute_struct_layout(
        fields: impl Iterator<Item = CompilerType>,
        symbols: &SymbolTable,
    ) -> Layout {
        let mut current_offset = 0;
        let mut max_align = 1;

        for field_type in fields {
            let layout = field_type.calculate_layout(symbols);
            if layout.align == 0 {
                continue;
            }

            max_align = u32::max(max_align, layout.align);
            let padding = (layout.align - (current_offset % layout.align)) % layout.align;

            current_offset += padding + layout.size;
        }

        let final_padding = (max_align - (current_offset % max_align)) % max_align;
        Layout::new(current_offset + final_padding, max_align)
    }
    pub fn is_bitcast_compatible(&self, other: &CompilerType, symbols: &SymbolTable) -> bool {
        if self.is_pointer() && other.is_pointer() {
            return true;
        }
        self.calculate_layout(symbols).size == other.calculate_layout(symbols).size
    }

    pub fn is_generic_dependent(&self) -> bool {
        match self {
            Self::GenericPlaceholder(_) | Self::GenericStructTemplate(..) => true,
            Self::Pointer(inner) => inner.is_generic_dependent(),
            Self::ConstantArray(_, inner) => inner.is_generic_dependent(),
            Self::Function(ret, args) => {
                ret.is_generic_dependent() || args.iter().any(|a| a.is_generic_dependent())
            }
            _ => false,
        }
    }
}
#[derive(Debug, Clone)]
pub struct Enum {
    pub full_path: ContextPathEnd,
    pub base_type: CompilerType,
    pub fields: Box<[(String, LLVMVal)]>,
    pub flags: Cell<u8>,
    pub attributes: Box<[Attribute]>,
    pub file_id: FileID,
}
impl Enum {
    pub fn new(
        full_name: ContextPathEnd,
        base_type: CompilerType,
        fields: Box<[(String, LLVMVal)]>,
        attribs: Box<[Attribute]>,
    ) -> Self {
        Self {
            full_path: full_name,
            base_type,
            fields,
            attributes: attribs,
            flags: Cell::new(0),
            file_id: 0,
        }
    }
}
#[derive(Debug, Clone, Copy, Default)]
pub struct StructFlags {
    pub is_generic: bool,
    pub is_primitive: bool,
}

impl StructFlags {
    fn to_byte(&self) -> u8 {
        let mut b = 0;
        if self.is_generic {
            b |= 64;
        }
        if self.is_primitive {
            b |= 128;
        }
        b
    }

    fn from_byte(b: u8) -> Self {
        Self {
            is_generic: (b & 64) != 0,
            is_primitive: (b & 128) != 0,
        }
    }
}
#[allow(unused)]
#[derive(Debug, Clone)]
pub struct Struct {
    full_path: ContextPathEnd,
    pub fields: Box<[(String, CompilerType)]>,
    pub generic_params: Box<[String]>,
    pub generic_implementations: RefCell<Vec<Box<[CompilerType]>>>,
    attributes: Box<[Attribute]>,
    flags: Cell<u8>,
    cached_layout: RefCell<Option<Layout>>,
    pub file_id: FileID,
}

impl Struct {
    pub fn new(
        path: ContextPathEnd,
        fields: Box<[(String, CompilerType)]>,
        attributes: Box<[Attribute]>,
        generic_params: Box<[String]>,
    ) -> Self {
        let flags = StructFlags {
            is_generic: !generic_params.is_empty(),
            is_primitive: false,
        };

        Self {
            full_path: path,
            fields,
            attributes,
            generic_params,
            generic_implementations: RefCell::new(vec![]),
            flags: Cell::new(flags.to_byte()),
            cached_layout: RefCell::new(None),
            file_id: 0,
        }
    }
    pub fn new_placeholder() -> Self {
        Self {
            full_path: ContextPathEnd::default(),
            fields: Box::new([]),
            generic_params: Box::new([]),
            generic_implementations: RefCell::new(vec![]),
            attributes: Box::new([]),
            flags: Cell::new(0),
            cached_layout: RefCell::new(None),
            file_id: 0,
        }
    }

    fn get_flags(&self) -> StructFlags {
        StructFlags::from_byte(self.flags.get())
    }

    pub fn is_primitive(&self) -> bool {
        self.get_flags().is_primitive
    }

    pub fn is_generic(&self) -> bool {
        self.get_flags().is_generic
    }
    pub fn llvm_representation(&self) -> String {
        assert!(!self.is_generic());
        if self.is_primitive() {
            self.name().to_string()
        } else {
            format!("%{}", self.llvm_representation_without_percent())
        }
    }

    pub fn llvm_representation_without_percent(&self) -> String {
        if self.is_primitive() {
            self.name().to_string()
        } else {
            format!("struct.{}", self.full_path().to_string())
        }
    }
    pub fn llvm_repr_index(&self, impl_index: usize, symbols: &SymbolTable) -> Box<str> {
        assert!(self.is_generic());
        debug_assert!(impl_index < self.generic_implementations.borrow().len());
        let base_name = format!("struct.{}", self.full_path().to_string());

        let implementations = self.generic_implementations.borrow();
        let generic_args = implementations.get(impl_index).unwrap();

        let type_names = generic_args
            .iter()
            .map(|t| {
                t.llvm_representation_in_generic(symbols)
                    .expect("Failed to get generic type representation")
            })
            .collect::<Vec<_>>()
            .join(", ");

        format!("%\"{}<{}>\"", base_name, type_names).into_boxed_str()
    }

    pub fn get_implementation_index(&self, generics: &[CompilerType]) -> Option<usize> {
        assert!(self.is_generic());
        if self.generic_params.len() != generics.len() {
            return None;
        }

        let impls = self.generic_implementations.borrow();
        if let Some(idx) = impls.iter().position(|existing| generics.eq(&**existing)) {
            return Some(idx);
        }

        drop(impls);
        let mut mut_impls = self.generic_implementations.borrow_mut();
        mut_impls.push(generics.to_vec().into_boxed_slice());
        Some(mut_impls.len() - 1)
    }
    pub fn full_path(&self) -> &ContextPathEnd {
        &self.full_path
    }
    pub fn ensure_generic_implementation(&self, generics: &[CompilerType]) -> usize {
        self.get_implementation_index(generics).unwrap()
    }
    pub fn get_cached_layout(&self) -> Option<Layout> {
        *self.cached_layout.borrow()
    }
    pub fn set_cached_layout(&self, layout: Layout) {
        assert!(!self.is_generic());
        assert!(self.cached_layout.borrow().is_none());
        *self.cached_layout.borrow_mut() = Some(layout);
    }

    pub fn name(&self) -> &str {
        &self.full_path.name()
    }

    pub fn get_field(&self, member: &str) -> Option<(usize, &CompilerType)> {
        self.fields
            .iter()
            .enumerate()
            .find(|x| x.1 .0 == member)
            .map(|x| (x.0, &x.1 .1))
    }
}
#[derive(Debug, Clone, Copy, Default)]
pub struct FunctionFlags {
    pub is_generic: bool,
    pub is_public: bool,
    pub is_inline: bool,
    pub is_const_expression: bool,
    pub is_external: bool,
    pub is_program_halt: bool,
}

impl FunctionFlags {
    fn to_byte(&self) -> u8 {
        let mut b = 0;
        if self.is_program_halt {
            b |= 4;
        }
        if self.is_generic {
            b |= 8;
        }
        if self.is_public {
            b |= 16;
        }
        if self.is_inline {
            b |= 32;
        }
        if self.is_const_expression {
            b |= 64;
        }
        if self.is_external {
            b |= 128;
        }
        b
    }

    fn from_byte(b: u8) -> Self {
        Self {
            is_program_halt: (b & 4) != 0,
            is_generic: (b & 8) != 0,
            is_public: (b & 16) != 0,
            is_inline: (b & 32) != 0,
            is_const_expression: (b & 64) != 0,
            is_external: (b & 128) != 0,
        }
    }
}

#[derive(Debug, Clone)]
pub struct Function {
    full_path: ContextPathEnd,
    pub args: Box<[(String, CompilerType)]>,
    pub return_type: CompilerType,
    pub body: Box<[StmtData]>,
    pub attributes: Box<[Attribute]>,
    flags: Cell<u8>,

    pub generic_params: Box<[String]>,
    pub generic_implementations: RefCell<Vec<Box<[CompilerType]>>>,
    pub usage_count: Cell<usize>,
    pub file_id: FileID,
}
impl Function {
    pub fn new(
        path: ContextPathEnd,
        args: Box<[(String, CompilerType)]>,
        return_type: CompilerType,
        body: Box<[StmtData]>,
        initial_flags: u8,
        attributes: Box<[Attribute]>,
        generic_params: Box<[String]>,
    ) -> Self {
        Self {
            full_path: path,
            args,
            return_type,
            body,
            attributes,
            flags: Cell::new(initial_flags),
            generic_params,
            generic_implementations: RefCell::new(vec![]),
            usage_count: Cell::new(0),
            file_id: 0,
        }
    }
    pub fn get_flags(&self) -> FunctionFlags {
        FunctionFlags::from_byte(self.flags.get())
    }
    pub fn is_normal(&self) -> bool {
        !self.get_flags().is_generic && !self.get_flags().is_external && !self.get_flags().is_inline
    }
    pub fn is_generic(&self) -> bool {
        self.get_flags().is_generic
    }
    pub fn is_external(&self) -> bool {
        self.get_flags().is_external
    }
    pub fn is_inline(&self) -> bool {
        self.get_flags().is_inline
    }

    pub fn is_program_halt(&self) -> bool {
        self.get_flags().is_program_halt
    }
    pub fn set_flags(&self, flags: FunctionFlags) {
        self.flags.set(flags.to_byte());
    }
    pub fn name(&self) -> &str {
        &self.full_path.name()
    }
    pub fn path(&self) -> &ContextPath {
        &self.full_path.context_path()
    }
    pub fn full_path(&self) -> &ContextPathEnd {
        &self.full_path
    }

    pub fn increment_usage(&self) {
        self.usage_count.replace(self.usage_count.get() + 1);
    }
    pub fn get_signature_type(&self) -> CompilerType {
        CompilerType::Function(
            Box::new(self.return_type.clone()),
            self.args.iter().map(|(_, ty)| ty.clone()).collect(),
        )
    }
    pub fn get_generic_implementation_index(&self, generics: &[CompilerType]) -> Option<usize> {
        assert!(self.is_generic());
        if generics
            .iter()
            .any(|t| matches!(t, CompilerType::GenericPlaceholder(_)))
        {
            panic!("Cannot implement generic function with placeholders");
        }
        if self.generic_params.len() != generics.len() {
            return None;
        }
        let impls = self.generic_implementations.borrow();
        if let Some(idx) = impls.iter().position(|existing| generics.eq(&**existing)) {
            return Some(idx);
        }
        drop(impls);
        let mut mut_impls = self.generic_implementations.borrow_mut();
        mut_impls.push(generics.to_vec().into());
        Some(mut_impls.len() - 1)
    }
    pub fn get_implementation_name(&self, impl_idx: usize, symbols: &SymbolTable) -> String {
        let impls = self.generic_implementations.borrow();
        let args = &impls[impl_idx];
        let arg_names = args
            .iter()
            .map(|t| t.llvm_representation_in_generic(symbols).unwrap())
            .collect::<Vec<_>>()
            .join(", ");

        format!("\"{}<{}>\"", self.full_path().to_string(), arg_names)
    }
    pub fn get_concretized_signature(
        &self,
        impl_index: usize,
        symbols: &SymbolTable,
    ) -> ExpressionCompileResult<CompilerType> {
        assert!(self.is_generic());
        let x = self.get_def_by_implementation_index(impl_index, symbols)?;
        Ok(CompilerType::Function(x.0, x.1))
    }
    pub fn get_def_by_implementation_index(
        &self,
        impl_idx: usize,
        symbols: &SymbolTable,
    ) -> ExpressionCompileResult<(Box<CompilerType>, Box<[CompilerType]>)> {
        assert!(self.is_generic());
        let impls = self.generic_implementations.borrow();
        let args = &impls[impl_idx];
        let mut map = HashMap::new();
        for (i, name) in self.generic_params.iter().enumerate() {
            map.insert(name.clone(), args[i].clone());
        }
        Ok((
            Box::new(self.return_type.with_substituted_generics(&map, symbols)?),
            self.args
                .iter()
                .map(|(_, ty)| ty.with_substituted_generics(&map, symbols))
                .collect::<ExpressionCompileResult<Box<_>>>()?,
        ))
    }
    pub fn attribs(&self) -> &[Attribute] {
        &self.attributes
    }
}
#[derive(Debug, Clone, Copy, Default)]
pub struct VariableFlags {
    pub read: bool,
    pub written: bool,
    pub modified_content: bool,
    pub static_storage: bool,
    pub inline: bool,
    pub is_alias: bool,
    pub is_constant: bool,
}
#[derive(Debug, Clone)]
pub struct Variable {
    pub compiler_type: CompilerType,
    flags: Cell<u8>,
    value: RefCell<Option<LLVMVal>>,
}
impl VariableFlags {
    fn to_byte(&self) -> u8 {
        let mut b = 0;
        if self.read {
            b |= 1;
        }
        if self.written {
            b |= 2;
        }
        if self.modified_content {
            b |= 4;
        }
        if self.static_storage {
            b |= 8;
        }
        if self.inline {
            b |= 16;
        }
        if self.is_alias {
            b |= 32;
        }
        if self.is_constant {
            b |= 64;
        }
        b
    }

    fn from_byte(b: u8) -> Self {
        Self {
            read: (b & 1) != 0,
            written: (b & 2) != 0,
            modified_content: (b & 4) != 0,
            static_storage: (b & 8) != 0,
            inline: (b & 16) != 0,
            is_alias: (b & 32) != 0,
            is_constant: (b & 64) != 0,
        }
    }
}
impl Variable {
    pub fn new(compiler_type: CompilerType, is_const: bool, is_static: bool) -> Self {
        Self::with_flags(
            compiler_type,
            VariableFlags {
                is_constant: is_const,
                static_storage: is_static,
                ..Default::default()
            },
        )
    }
    fn with_flags(compiler_type: CompilerType, flags: VariableFlags) -> Self {
        Self {
            compiler_type,
            flags: Cell::new(flags.to_byte()),
            value: RefCell::new(None),
        }
    }
    pub fn get_flags(&self) -> VariableFlags {
        VariableFlags::from_byte(self.flags.get())
    }
    pub fn update_flags<F>(&self, f: F)
    where
        F: FnOnce(&mut VariableFlags),
    {
        let mut flags = self.get_flags();
        f(&mut flags);
        self.flags.set(flags.to_byte());
    }
    pub fn mark_usage(&self, is_write: bool, modifies_content: bool) {
        if self.get_flags().is_constant && is_write {
            panic!("Attempted to write to constant variable");
        }
        self.update_flags(|f| {
            if is_write {
                f.written = true;
            } else {
                f.read = true;
            }
            if modifies_content {
                f.modified_content = true;
            }
        });
    }
    pub fn set_constant_value(&self, value: Option<LLVMVal>) {
        *self.value.borrow_mut() = value;
    }
    pub fn value(&self) -> &RefCell<Option<LLVMVal>> {
        &self.value
    }
    pub fn compiler_type(&self) -> &CompilerType {
        &self.compiler_type
    }
    pub fn try_load_const_llvm_value(&self) -> Option<CompiledValue> {
        self.value
            .borrow()
            .as_ref()
            .map(|val| CompiledValue::new_value(val.clone(), self.compiler_type().clone()))
    }
    pub fn load_llvm_value(
        &self,
        var_id: u32,
        var_name: &str,
        ctx: &CodeGenContext,
        var_type: CompilerType,
    ) -> ExpressionCompileResult<(CompiledValue, Vec<LLVMInstruction>)> {
        let flags = self.get_flags();
        let temp_id = ctx.acquire_temp_id();
        let mut instruct = vec![];

        if flags.static_storage {
            instruct.push(LLVMInstruction::Load {
                target_reg: temp_id,
                ptr: LLVMVal::Global(var_name.to_string()),
                result_type: var_type,
            });
        } else {
            instruct.push(LLVMInstruction::Load {
                target_reg: temp_id,
                ptr: LLVMVal::Variable(var_id),
                result_type: var_type,
            });
        }

        Ok((
            CompiledValue::new_value(LLVMVal::Register(temp_id), self.compiler_type.clone()),
            instruct,
        ))
    }
}
#[derive(Debug, Clone)]
struct ScopeLayer {
    variables: OrderedHashMap<String, (Variable, u32)>,
    loop_tag: Option<u32>,
}
#[derive(Clone)]
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
                loop_tag: None,
            }],
        }
    }
    pub fn lookup(&self, name: &str) -> Option<&(Variable, u32)> {
        for layer in self.layers.iter().rev() {
            if let Some(var) = layer.variables.get(name) {
                return Some(var);
            }
        }
        None
    }
    pub fn define(
        &mut self,
        name: String,
        variable: Variable,
        id: u32,
        table: &SymbolTable,
    ) -> Vec<LLVMInstruction> {
        let current = self.layers.last_mut().expect("Scope stack underflow");
        if let Some(prev_value) = current.variables.insert(name.clone(), (variable, id)) {
            return Self::leave_scope((&name, &prev_value), table);
        }
        vec![]
    }
    pub fn push_layer(&mut self) {
        let current_loop = self.layers.last().and_then(|l| l.loop_tag);
        self.layers.push(ScopeLayer {
            variables: OrderedHashMap::new(),
            loop_tag: current_loop,
        });
    }
    pub fn pop_layer(&mut self, table: &SymbolTable) -> Vec<LLVMInstruction> {
        if self.layers.len() == 1 {
            panic!("Cannot pop global scope");
        }
        let layer = self.layers.pop().unwrap();
        let mut on_scope_exit = vec![];
        for var in layer.variables.iter().rev() {
            on_scope_exit.append(&mut Self::leave_scope(var, table));
        }
        return on_scope_exit;
    }
    pub fn drop_current_scope(&mut self, table: &SymbolTable) -> Vec<LLVMInstruction> {
        let layer = self.layers.last_mut().unwrap();
        let mut on_scope_exit = vec![];
        for var in layer.variables.iter().rev() {
            on_scope_exit.append(&mut Self::leave_scope(var, table));
        }
        layer.variables.clear();
        return on_scope_exit;
    }
    pub fn current_loop_tag(&self) -> Option<u32> {
        self.layers.last().and_then(|l| l.loop_tag)
    }

    pub fn set_loop_tag(&mut self, tag: Option<u32>) {
        if let Some(layer) = self.layers.last_mut() {
            layer.loop_tag = tag;
        }
    }

    fn leave_scope(var: (&String, &(Variable, u32)), _table: &SymbolTable) -> Vec<LLVMInstruction> {
        if var.1 .0.compiler_type().is_pointer() {
            return vec![];
        }
        if var
            .1
             .0
            .compiler_type()
            .as_primitive()
            .map(|x| !x.is_droppable())
            .unwrap_or(false)
        {
            return vec![];
        }
        vec![LLVMInstruction::Debug(format!(
            "Variable {} is out.",
            var.0
        ))]
    }

    pub fn deep(&self) -> usize {
        self.layers.len()
    }

    pub fn pop_layer_immutable<'a>(&self, symbols: &'a SymbolTable) -> Vec<LLVMInstruction> {
        let layer = self.layers.last().unwrap();
        let mut on_scope_exit = vec![];
        for var in layer.variables.iter().rev() {
            on_scope_exit.append(&mut Self::leave_scope(var, symbols));
        }
        return on_scope_exit;
    }
}

pub type CompileResult<T> = Result<T, CompilerErrorWrapper>;
#[derive(Debug)]
pub struct CompilerErrorWrapper {
    pub error: CompilerError,
    pub span: Option<Span>,
    pub call_stack: Vec<(Span, String)>,
    pub function_id: usize,
}

impl From<CompilerError> for CompilerErrorWrapper {
    fn from(error: CompilerError) -> Self {
        Self {
            error,
            span: None,
            call_stack: vec![],
            function_id: usize::MAX,
        }
    }
}

impl From<(Span, CompilerError)> for CompilerErrorWrapper {
    fn from((span, error): (Span, CompilerError)) -> Self {
        Self {
            error,
            span: Some(span),
            call_stack: vec![],
            function_id: usize::MAX,
        }
    }
}

#[derive(Debug)]
pub enum CompilerError {
    Generic(String),
    FunctionCompilation(Box<CompilerError>, usize),
    Io(std::io::Error),
    LexerError(String, rcsharp_lexer::LexerError),
    ParserError(String, (Span, rcsharp_parser::parser::ParserError)),
}
impl CompilerError {
    pub fn extend(&self, extention_message: &str) -> CompilerError {
        Self::Generic(format!("{}\n{}", self, extention_message))
    }
}
impl std::fmt::Display for CompilerError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Self::Io(io) => io.fmt(f),
            Self::FunctionCompilation(..) => {
                todo!()
            }
            Self::LexerError(path, error) => {
                writeln!(f, "Lexer error during compilation:")?;
                let file = std::fs::read_to_string(path).unwrap();

                match error {
                    LexerError::UnexpectedCharacter(range) => {
                        let c = &file[..range.start];
                        let row = c.chars().filter(|x| *x == '\n').count();
                        let col = c
                            .char_indices()
                            .filter(|x| x.1 == '\n')
                            .last()
                            .map(|x| range.start - x.0)
                            .unwrap_or(range.start);
                        return writeln!(
                            f,
                            "Unexpected character:{:?}\n\rat {}:{}:{}",
                            &file[range.clone()],
                            path,
                            row + 1,
                            col
                        );
                    }
                    _ => unimplemented!("{:?}", error),
                }
            }
            Self::ParserError(path, (range, error)) => {
                writeln!(f, "Lexer error during compilation:")?;
                let file = std::fs::read_to_string(path).unwrap();
                let mut tokens = vec![];
                let mut symbol_table = rcsharp_lexer::LexerSymbolTable::new();
                lex_text(&file, &mut tokens, &mut symbol_table).unwrap();
                let token_span = &tokens[range.start..range.end];
                match error {
                    rcsharp_parser::parser::ParserError::OrphanedAttributes => {
                        let src_start = token_span.first().map(|x| x.span.start).unwrap_or(0);
                        let src_end = token_span.last().map(|x| x.span.end).unwrap_or(0);
                        let c = &file[..src_start];
                        let row = c.chars().filter(|x| *x == '\n').count();
                        let col = c
                            .char_indices()
                            .filter(|x| x.1 == '\n')
                            .last()
                            .map(|x| src_start - x.0)
                            .unwrap_or(src_start);
                        return writeln!(
                            f,
                            "Orphaned attr:{:?}\n\rat {}:{}:{}",
                            &file[src_start..src_end],
                            path,
                            row + 1,
                            col
                        );
                    }
                    rcsharp_parser::parser::ParserError::ExpectedIdentifier => {
                        let src_start = token_span.first().map(|x| x.span.start).unwrap_or(0);
                        let src_end = token_span.last().map(|x| x.span.end).unwrap_or(0);
                        let c = &file[..src_start];
                        let row = c.chars().filter(|x| *x == '\n').count();
                        let col = c
                            .char_indices()
                            .filter(|x| x.1 == '\n')
                            .last()
                            .map(|x| src_start - x.0)
                            .unwrap_or(src_start);
                        return writeln!(
                            f,
                            "Expected name but found:{:?}\n\rat {}:{}:{}",
                            &file[src_start..src_end],
                            path,
                            row + 1,
                            col
                        );
                    }
                    rcsharp_parser::parser::ParserError::UnexpectedToken { expected, found } => {
                        let src_start = token_span.first().map(|x| x.span.start).unwrap_or(0);
                        let src_end = token_span.last().map(|x| x.span.end).unwrap_or(0);
                        let c = &file[..src_start];
                        let row = c.chars().filter(|x| *x == '\n').count();
                        let col = c
                            .char_indices()
                            .filter(|x| x.1 == '\n')
                            .last()
                            .map(|x| src_start - x.0)
                            .unwrap_or(src_start);
                        return writeln!(
                            f,
                            "Expected {} but found:{:?} (is {:?})\n\rat {}:{}:{}",
                            expected,
                            found,
                            &file[src_start..src_end],
                            path,
                            row + 1,
                            col
                        );
                    }
                    rcsharp_parser::parser::ParserError::ExpectedSemicolon => {
                        let src_start = token_span.first().map(|x| x.span.start).unwrap_or(0);
                        let src_end = token_span.last().map(|x| x.span.end).unwrap_or(0);
                        let c = &file[..src_start];
                        let row = c.chars().filter(|x| *x == '\n').count();
                        let col = c
                            .char_indices()
                            .filter(|x| x.1 == '\n')
                            .last()
                            .map(|x| src_start - x.0)
                            .unwrap_or(src_start);
                        return writeln!(
                            f,
                            "Expected ';' but found:{:?}\n\rat {}:{}:{}",
                            &file[src_start..src_end],
                            path,
                            row + 1,
                            col
                        );
                    }

                    _ => unimplemented!("{:?}", error),
                }
            }

            Self::Generic(msg) => write!(f, "{}", msg),
        }
    }
}

impl From<std::io::Error> for CompilerError {
    fn from(e: std::io::Error) -> Self {
        Self::Io(e)
    }
}
#[derive(Debug)]
pub struct CompiledLValue {
    pub location: LLVMVal,
    pub value_type: CompilerType,
    pub is_mutable: bool,
    pub function_id: Option<usize>,
}
impl CompiledLValue {
    pub fn new(location: LLVMVal, value_type: CompilerType, is_mutable: bool) -> Self {
        Self {
            location,
            value_type,
            is_mutable,
            function_id: None,
        }
    }
    pub fn from_function(id: usize, symbols: &SymbolTable) -> ExpressionCompileResult<Self> {
        let func = symbols.get_function_by_id(id);
        let location = if func.is_generic() {
            LLVMVal::ConstantInteger(id as i128)
        } else if func.is_external() {
            LLVMVal::Global(func.name().to_string())
        } else {
            LLVMVal::Global(func.full_path.to_string())
        };

        Ok(Self {
            location,
            value_type: func.get_signature_type(),
            is_mutable: false,
            function_id: Some(id),
        })
    }
}

#[derive(Default)]
pub struct LLVMOutputHandler {
    header: String,
    global_variables: String,
    include_header: String,
    main: String,
    footer: String,

    function_intro: String,
    function_body: String,
}
impl LLVMOutputHandler {
    pub fn push_main(&mut self, s: &str) {
        self.main.push_str(s);
    }
    pub fn push_function_intro(&mut self, s: &str) {
        self.function_intro.push_str(s);
    }
    pub fn push_function_body(&mut self, s: &str) {
        self.function_body.push_str(s);
    }
    pub fn push_header_include(&mut self, s: &str) {
        self.include_header.push_str(s);
    }
    pub fn push_header(&mut self, s: &str) {
        self.header.push_str(s);
    }
    pub fn push_global_variables(&mut self, s: &str) {
        self.global_variables.push_str(s);
    }
    pub fn push_footer(&mut self, s: &str) {
        self.footer.push_str(s);
    }

    pub fn build(self, strings_header: Vec<StringEntry>) -> String {
        let definitions = strings_header.iter().enumerate().map(|(index, entry)| {
            match entry {
                StringEntry::Owned(s) => {
                    let escaped_val = s.replace("\"", "\\22")
                        .replace("\n", "\\0A")
                        .replace("\r", "\\0D")
                        .replace("\t", "\\09");
                    let str_len = s.len() + 1;
                    format!("@.str.{} = private unnamed_addr constant [{} x i8] c\"{}\\00\"", index, str_len, escaped_val)
                }
                StringEntry::Suffix { parent_index, byte_offset, length_with_null, .. } => {
                    let mut root_index = *parent_index;
                    let mut total_offset = *byte_offset;
                    let mut loops = 0;
                    while let StringEntry::Suffix { parent_index: next_p, byte_offset: next_off, .. } = &strings_header[root_index] {
                        root_index = *next_p;
                        total_offset += next_off;
                        loops += 1;
                        if loops > 100 { panic!("Circular string dependency detected at index {}", index); }
                    }
                    let root_len = match &strings_header[root_index] {
                        StringEntry::Owned(s) => s.len() + 1,
                        _ => panic!("String dependency chain did not end in Owned at index {}", root_index),
                    };
                    format!(
                        "@.str.{} = private unnamed_addr alias [{} x i8], [{} x i8]* bitcast (i8* getelementptr inbounds ([{} x i8], [{} x i8]* @.str.{}, i64 0, i64 {}) to [{} x i8]*)",
                        index,
                        length_with_null,
                        length_with_null,
                        root_len, root_len, root_index, total_offset,
                        length_with_null
                    )
                }
            }
        }).collect::<Vec<String>>().join("\n");

        format!(
            "{}\n{}\n{}\n{}\n{}\n{}",
            self.header,
            self.include_header,
            definitions,
            self.global_variables,
            self.main,
            self.footer
        )
    }

    pub fn start_function(
        &mut self,
        return_type_llvm: &str,
        full_function_name: &str,
        args_str: &str,
        attrs_str: &str,
    ) {
        self.push_main(&format!(
            "define {} @{}({}){}{{\n",
            return_type_llvm, full_function_name, args_str, attrs_str
        ));
    }

    pub fn end_function(&mut self) {
        self.push_main(&self.function_intro.clone());
        self.push_main(&self.function_body.clone());
        self.push_main("}\n");
        self.function_intro.clear();
        self.function_body.clear();
    }

    pub fn emit_line_body(&mut self, format: &str) {
        self.push_function_body(&format!("\t{}\n", format));
    }
    pub fn emit_ret_void(&mut self) {
        self.push_function_body(&format!("\tret void\n"));
    }

    pub fn emit_unconditional_jump_to(&mut self, label_name: &str) {
        self.push_function_body(&format!("\tbr label %{label_name}\n"));
    }

    pub fn emit_label(&mut self, label_name: &str) {
        self.push_function_body(&format!("{label_name}:\n"));
    }
    pub fn emit_label_intro(&mut self, label_name: &str) {
        self.push_function_intro(&format!("{label_name}:\n"));
    }
    pub fn emit_comment(&mut self, comment: &str) {
        self.push_function_body(&format!("; {comment}\n"));
    }
}

#[derive(Default)]
pub struct SymbolTable {
    functions: ContextPathDictionary<Function>,
    types: ContextPathDictionary<Struct>,
    alias_types: HashMap<String, CompilerType>,
    enums: ContextPathDictionary<Enum>,
    static_variables: ContextPathDictionary<Variable>,
}
impl SymbolTable {
    pub fn get_type_by_id(&self, type_id: usize) -> &Struct {
        self.types.values().nth(type_id).expect("Unexpected")
    }
    pub fn get_function_by_id(&self, function_id: usize) -> &Function {
        let Some(func) = self.functions.values().nth(function_id) else {
            unreachable!()
        };
        func
    }
    pub fn get_function_by_id_use(&self, function_id: usize) -> &Function {
        let Some(func) = self.functions.values().nth(function_id) else {
            unreachable!()
        };
        func.increment_usage();
        func
    }
    pub fn get_type_id_by_path(&self, fqn: &ContextPathEnd) -> Option<usize> {
        self.types.index_of(&fqn)
    }
    pub fn get_function_id_by_path(&self, fqn: &ContextPathEnd) -> Option<usize> {
        self.functions.index_of(&fqn)
    }
    pub fn get_enum_by_path(&self, fqn: &ContextPathEnd) -> Option<&Enum> {
        self.enums.get(&fqn)
    }
    pub fn get_static_by_path<'a>(
        &'a self,
        fqn: &'a ContextPathEnd,
    ) -> Option<(&'a ContextPathEnd, &'a Variable)> {
        self.static_variables.get(&fqn).map(|x| (fqn, x))
    }
    pub fn insert_type(&mut self, full_path: ContextPathEnd, structure: Struct) {
        if let Some(x) = self.types.get_mut(&full_path) {
            *x = structure;
            (*x).full_path = full_path;
            return;
        }
        let mut structure_type = structure;
        structure_type.full_path = full_path.clone();
        self.types.insert(&full_path, structure_type);
    }
    pub fn insert_function(&mut self, full_path: ContextPathEnd, function_type: Function) {
        if let Some(x) = self.functions.get_mut(&full_path) {
            *x = function_type;
            (*x).full_path = full_path;
            return;
        }
        let mut function_type = function_type;
        function_type.full_path = full_path.clone();
        self.functions.insert(&full_path, function_type);
    }
    pub fn insert_enum(&mut self, full_path: ContextPathEnd, enum_type: Enum) {
        if let Some(x) = self.enums.get_mut(&full_path) {
            *x = enum_type;
            (*x).full_path = full_path;
            return;
        }
        let mut enum_type = enum_type;
        enum_type.full_path = full_path.clone();
        self.enums.insert(&full_path, enum_type);
    }
    pub fn set_alias_types(&mut self, hm: HashMap<String, CompilerType>) {
        self.alias_types = hm
    }
    pub fn insert_static_var(
        &mut self,
        full_path: ContextPathEnd,
        variable: Variable,
    ) -> CompileResult<()> {
        if let Some(_) = self.static_variables.insert(&full_path, variable) {
            return Err(CompilerError::Generic(format!(
                "Static variable with name {} already exists!",
                full_path.to_string()
            ))
            .into());
        }
        return Ok(());
    }

    pub fn functions_iter(&self) -> ContextPathDictionaryIter<'_, Function> {
        self.functions.iter()
    }
    pub fn functions_iter_mut(&mut self) -> ContextPathDictionaryIterMut<'_, Function> {
        self.functions.iter_mut()
    }
    pub fn types_iter(&self) -> ContextPathDictionaryIter<'_, Struct> {
        self.types.iter()
    }
    pub fn static_vars_iter(&self) -> ContextPathDictionaryIter<'_, Variable> {
        self.static_variables.iter()
    }
    pub fn alias_types(&self) -> &HashMap<String, CompilerType> {
        &self.alias_types
    }
}
