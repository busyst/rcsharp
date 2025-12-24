use std::{cell::{Cell, RefCell}, collections::HashMap};
use ordered_hash_map::OrderedHashMap;
use rcsharp_parser::{compiler_primitives::{Layout, PrimitiveInfo}, parser::{Attribute, ParserType, StmtData}};

use crate::{compiler::{CodeGenContext, CompileResult, LLVMOutputHandler, SymbolTable, get_llvm_type_str, get_llvm_type_str_int, substitute_generic_type}, expression_compiler::{CompiledValue, LLVMVal, size_and_alignment_of_type}};
// ------------------------------------------------------------------------------------
pub trait FlagManager {
    fn get_flags(&self) -> &Cell<u8>;

    fn has_flag(&self, flag: u8) -> bool {
        self.get_flags().get() & flag != 0
    }

    fn set_flag(&self, flag: u8) {
        self.get_flags().set(self.get_flags().get() | flag);
    }
}

#[derive(Debug, Clone)]
pub enum CompilerType {
    Primitive(&'static PrimitiveInfo),
    Pointer(Box<CompilerType>),
    StructType(usize), // index in symbol table
    GenericSubst(Box<str>), // index in symbol table
    GenericStructType(usize, usize), // index in symbol table, index in implementation table
    
    Function(Box<CompilerType>, Box<[CompilerType]>), // return type index in symbol table, arguments indexes in implementation table

}
#[allow(unused)]
impl CompilerType {
    pub fn get_parser_type(&self, symbols: &SymbolTable) -> ParserType {
        match self {
            CompilerType::GenericSubst(name) => ParserType::Named(symbols.alias_types.get(name.as_ref())
            .expect("Invalid generic substitution ").type_name()),

            CompilerType::Primitive(info) => ParserType::Named(info.name.to_string()),
            CompilerType::Pointer(info) => ParserType::Pointer(Box::new(info.get_parser_type(symbols))),
            CompilerType::StructType(idx) => {
                let s = symbols.get_type_by_id(*idx).expect("Invalid struct ID");
                let name_pt = ParserType::Named(s.name.to_string());
                if s.path.is_empty() {
                    name_pt
                } else {
                    ParserType::NamespaceLink(s.path.to_string(), Box::new(name_pt))
                }
            }
            CompilerType::GenericStructType(idx, imp_idx) => {
                let s = symbols.get_type_by_id(*idx).expect("Invalid struct ID");
                let args = s.generic_implementations.borrow();
                let specific_args = &args[*imp_idx];
                ParserType::Named(format!("{}<{}>", s.name, specific_args.len())) 
            }
            CompilerType::Function(idx, imp_idx) => {
                todo!("Get parser type for function with index")
            }
        }
    }
    pub fn llvm_representation(&self, symbols: &SymbolTable) -> CompileResult<String> {
        match self {
            CompilerType::Primitive(info) => Ok(info.llvm_name.to_string()),
            CompilerType::StructType(idx) => Ok(symbols.get_type_by_id(*idx).unwrap().llvm_representation()),
            CompilerType::Pointer(inner) => Ok(format!("{}*", inner.llvm_representation(symbols)?)),
            CompilerType::Function(ret, args) => {
                return Ok("func".into());
            }
            _ => todo!("Get llvm representation for non-primitive type {:?}", self),
        }
    }
    pub fn into(x: &ParserType, symbols: &SymbolTable) -> CompilerType {
        if let Some(pt) = x.as_primitive_type() {
            return CompilerType::Primitive(pt);
        }
        if let Some(internal) = x.as_pointer() {
            return CompilerType::Pointer(Box::new(CompilerType::into(internal, symbols)));
        }
        if let Some((ret, args)) = x.as_function() {
            let ret = CompilerType::into(ret, symbols);
            let args = args.iter().map(|a| CompilerType::into(a, symbols)).collect();
            return CompilerType::Function(Box::new(ret), args);
        }
        let fqn = x.type_name();
        if let Some(idx) = symbols.get_bare_type_id(&fqn) {
            return CompilerType::StructType(idx);
        }
        if symbols.alias_types.contains_key(&fqn) {
            return CompilerType::GenericSubst(fqn.into());
        }
        println!("{:?}", symbols.alias_types);
        panic!("Could not convert parser type to compiler type: {:?} {}", x, fqn)
    }
    pub fn convert_to(x: &[ParserType], symbols: &SymbolTable) -> Vec<CompilerType> {
        x.iter().map(|v| {
            return CompilerType::into(v, symbols);
            panic!("Could not convert parser type to compiler type")
        }).collect()
    }
    pub fn convert_from(x: &[CompilerType], symbols: &SymbolTable) -> Vec<ParserType> {
        x.iter().map(|v| {
            if let CompilerType::Primitive(pt) = v {
                return ParserType::Named(pt.name.to_string());
            }
            panic!("Could not convert parser type to compiler type")
        }).collect()
    }

    pub fn substitute_generic_types(mut self, map: &HashMap<String, ParserType>) {
        match self {
            CompilerType::Primitive(_) | CompilerType::StructType(_) | CompilerType::GenericStructType(_, _) => {}
            
            CompilerType::GenericSubst(name) => {
                if let Some(replacement) = map.get(name.as_ref()) {
                    panic!("Substituted generic type {:?} with {:?}", name, replacement);
                }
                panic!()
            }
            CompilerType::Function(x, mut y) => {
                x.substitute_generic_types(map);
                for mut arg in y {
                    arg.substitute_generic_types(map);
                }
            }
            CompilerType::Pointer(x) => x.substitute_generic_types(map),
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
            _ => false,
        }
    }
}

// ------------------------------------------------------------------------------------
#[derive(Debug, Clone)]
pub struct Enum {
    pub path: Box<str>,
    pub name: Box<str>,
    pub base_type: CompilerType,
    pub fields: Box<[(String, i128)]>,
    pub attribs: Box<[Attribute]>,
    pub flags: Cell<u8>,
}
impl Enum {
    pub fn new(path: Box<str>, name: Box<str>, base_type: CompilerType, fields: Box<[(String, i128)]>, attribs: Box<[Attribute]>) -> Self {
        Self { path, name, base_type, fields, attribs, flags: Cell::new(0) }
    }
}
// ------------------------------------------------------------------------------------
pub mod struct_flags {
    pub const GENERIC: u8 = 64;
    pub const PRIMITIVE_TYPE: u8 = 128;
}
#[derive(Debug, Clone)]
pub struct Struct {
    pub path: Box<str>,
    pub name: Box<str>,
    pub fields: Box<[(String, ParserType)]>,
    pub generic_params: Box<[String]>,
    pub generic_implementations: RefCell<Vec<Box<[ParserType]>>>,
    pub attribs: Box<[Attribute]>,
    pub flags: Cell<u8>,
}
impl FlagManager for Struct {
    fn get_flags(&self) -> &Cell<u8> { &self.flags }
}

impl Struct {
    pub fn new(path: Box<str>, name: Box<str>, fields: Box<[(String, ParserType)]>, attribs: Box<[Attribute]>, generic_params: Box<[String]>) -> Self {
        Self { path, name, fields, attribs, flags: Cell::new(if !generic_params.is_empty() {struct_flags::GENERIC} else {0}), generic_params, generic_implementations: RefCell::new(vec![]) }
    }
    pub fn new_placeholder(path: String, name: String) -> Struct {
        Self { path: path.into(), name: name.into(), fields: Box::new([]), generic_params: Box::new([]), generic_implementations: RefCell::new(vec![]), attribs: Box::new([]), flags: Cell::new(0) }
    }
    pub fn new_primitive(name: &str) -> Self {
        Self { path : "".into(), name: name.into(), fields : Box::new([]), attribs: Box::new([]), flags: Cell::new(struct_flags::PRIMITIVE_TYPE), generic_params: Box::new([]), generic_implementations: RefCell::new(vec![]) }
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

    pub fn full_path(&self) -> Box<str> {
        if self.path.is_empty() {
            self.name.clone()
        } else {
            format!("{}.{}", self.path, self.name).into()
        }
    }
}

pub struct StructView<'a>{
    r#struct : &'a Struct,
    fields: Vec<(String, ParserType)>,
    size_and_alligment: Layout,
    implementation_index: isize
}
impl<'a> StructView<'a> {
    pub fn new_unspec(r#struct: &'a Struct) -> Self {
        Self { r#struct, fields: Vec::new(),  size_and_alligment: Layout::new_not_valid(), implementation_index: -1 }
    }
    pub fn new(r#struct: &'a Struct) -> Self {
        if r#struct.is_generic() {
            panic!("Tried to get struct view of generic type without specifying generic parameters")
        }
        Self { r#struct, fields: Vec::new(), size_and_alligment: Layout::new_not_valid(), implementation_index: -1}
    }
    pub fn new_generic(r#struct: &'a Struct, map: &HashMap<String, ParserType>) -> Self {
        if !r#struct.is_generic() {
            panic!("This type is not generic: {}", r#struct.full_path())
        }
        let all_generics_defined = r#struct.generic_params.iter().all(|x| map.contains_key(x));
        if !all_generics_defined {
            let definded = r#struct.generic_params.iter().filter(|x| map.contains_key(x.as_str())).cloned().collect::<Vec<_>>();
            let undefinded = r#struct.generic_params.iter().filter(|x| !map.contains_key(x.as_str())).cloned().collect::<Vec<_>>();
            panic!("Not all generic types defined in current context for struct {}:\nDefined({}):{}\nUndefined({}):{}",
                r#struct.full_path(),
                definded.len(), definded.join("\n"),
                undefinded.len(), undefinded.join("\n"),
            )
        }
        let implementation = r#struct.generic_params.iter().map(|x| map.get(x).unwrap().clone()).collect::<Box<_>>();
        if implementation.len() != r#struct.generic_params.len() {
            panic!("Tried to get struct view of generic type with invalid count of generic parameters provided {}, needed {}", implementation.len(), r#struct.generic_params.len())
        }
        let implementation_index;
        {
            let mut brw = r#struct.generic_implementations.borrow_mut(); 
            if let Some(idx) = brw.iter().position(|x| x.iter().eq(implementation.iter())) {
                implementation_index = idx as isize;
            } else {
                implementation_index = brw.len() as isize;
                brw.push(implementation);
            }
        }
        let mut fields = r#struct.fields.to_vec();
        for x in fields.iter_mut() {
            x.1 = substitute_generic_type(&x.1, map);
        }
        Self { r#struct, fields, size_and_alligment: Layout::new_not_valid(), implementation_index }
    }
    pub fn calculate_size(&mut self, ctx : &mut CodeGenContext<'_>) -> Layout {
        if self.size_and_alligment.is_valid(){
            return self.size_and_alligment;
        }
        let mut current_offset = 0;
        let mut max_alignment = 1;
        for (_name, field_type) in self.field_types() {
            let layout_of_type = size_and_alignment_of_type(&field_type, ctx);
            if layout_of_type.align == 0 { continue; }
            max_alignment = u32::max(max_alignment, layout_of_type.align);
            let padding = (layout_of_type.align - (current_offset % layout_of_type.align)) % layout_of_type.align;
            
            current_offset += padding;
            current_offset += layout_of_type.size;
        }
        let final_padding = (max_alignment - (current_offset % max_alignment)) % max_alignment;
        let total_size = current_offset + final_padding;
        self.size_and_alligment = Layout::new(total_size, max_alignment);
        Layout::new(total_size, max_alignment)
    }
    pub fn definition(&self) -> &'a Struct {
        self.r#struct
    }
    pub fn field_types(&self) -> &[(String, ParserType)] {
        if !self.is_generic() {
            return &self.r#struct.fields;
        }
        self.fields.as_slice()
    }
    pub fn is_generic(&self) -> bool {
        self.r#struct.is_generic()
    }
    pub fn path(&self) -> &str {
        &self.r#struct.path
    }
    pub fn llvm_representation(&self, symbols: &SymbolTable) -> String {
        if self.r#struct.is_generic() {
            let x = self.implementation_index as usize;
            let i = self.r#struct.generic_implementations.borrow().get(x).unwrap().iter()
            .map(|x| get_llvm_type_str_int(x, symbols, &self.definition().path)).collect::<CompileResult<Vec<_>>>().unwrap().join(", ");

            return format!("%\"{}<{}>\"", self.r#struct.llvm_representation_without_percent(), i);
        }
        self.r#struct.llvm_representation()
    } 
    pub fn generic_params(&self) -> &[String] {
        &self.r#struct.generic_params
    }
    pub fn parser_type(&self) -> ParserType {
        if self.path().is_empty() {
            return ParserType::Named(self.r#struct.name.to_string());
        }else {
            return ParserType::NamespaceLink(self.path().to_string(), Box::new(ParserType::Named(self.r#struct.name.to_string())));
        }
    }
}

// ------------------------------------------------------------------------------------
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
    pub args: Box<[(String, ParserType)]>,
    pub return_type: ParserType,
    pub body: Box<[StmtData]>,
    pub attribs: Box<[Attribute]>,
    flags: Cell<u8>,

    pub generic_params: Box<[String]>,
    pub generic_implementations: RefCell<Vec<Box<[ParserType]>>>,
    pub times_used: Cell<usize>,
}
impl FlagManager for Function {
    fn get_flags(&self) -> &Cell<u8> { &self.flags }
}

impl Function {
    pub fn new(path: Box<str>, name: Box<str>, args: Box<[(String, ParserType)]>, return_type: ParserType, body: Box<[StmtData]>, flags: Cell<u8>, attribs: Box<[Attribute]>, generic_params: Box<[String]>) -> Self {
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
}
pub struct FunctionView<'a> {
    func: &'a Function,
    args: Vec<(String, ParserType)>,
    return_type: ParserType,
}
impl<'a> FunctionView<'a> {
    pub fn new_unspec(func: &'a Function) -> Self {
        Self {
            func,
            args: func.args.to_vec(),
            return_type: func.return_type.clone(),
        }
    }
    pub fn new(func: &'a Function) -> Self {
        if func.is_generic() {
            panic!("Tried to get function view of generic function without specifying generic parameters: {}", func.name())
        } 
        Self {
            func,
            args: func.args.to_vec(),
            return_type: func.return_type.clone(),
        }
    }
    pub fn new_generic(func: &'a Function, map: &HashMap<String, ParserType>) -> Self {
        if !func.is_generic() {
            panic!("This function is not generic: {}", func.name)
        }
        let all_generics_defined = func.generic_params.iter().all(|x| map.contains_key(x));
        
        if !all_generics_defined {
            let defined = func.generic_params.iter()
                .filter(|x| map.contains_key(x.as_str()))
                .cloned()
                .collect::<Vec<_>>();
            let undefined = func.generic_params.iter()
                .filter(|x| !map.contains_key(x.as_str()))
                .cloned()
                .collect::<Vec<_>>();
                
            panic!("Not all generic types defined in current context for function {}:\nDefined({}):{}\nUndefined({}):{}",
                func.name,
                defined.len(), defined.join(", "),
                undefined.len(), undefined.join(", "),
            )
        }

        let implementation = func.generic_params.iter()
            .map(|x| map.get(x).unwrap().clone())
            .collect::<Box<_>>();

        {
            let mut brw = func.generic_implementations.borrow_mut();
            if !brw.iter().any(|x| x.iter().eq(implementation.iter())) {
                brw.push(implementation);
            }
        }

        let mut args = func.args.to_vec();
        for arg in args.iter_mut() {
            arg.1 = substitute_generic_type(&arg.1, map);
        }

        let return_type = substitute_generic_type(&func.return_type, map);

        Self {
            func,
            args,
            return_type,
        }
    }

    pub fn args(&self) -> &[(String, ParserType)] {
        &self.args
    }
    pub fn path(&self) -> &str {
        &self.func.path
    }

    pub fn return_type(&self) -> &ParserType {
        &self.return_type
    }

    pub fn body(&self) -> &[StmtData] {
        &self.func.body
    }

    pub fn llvm_name(&self) -> Box<str> {
        if self.func.is_imported(){
            self.func.name.clone()
        }else{
            self.full_path()
        }
    }
    
    pub fn is_inline(&self) -> bool {
        self.func.is_inline()
    }

    pub fn generic_params(&self) -> &[String] {
        &self.func.generic_params
    }
    
    pub fn definition(&self) -> &'a Function {
        self.func
    }
    pub fn full_path(&self) -> Box<str> {
        if self.func.path.is_empty() {
            self.func.name.clone()
        }else{
            format!("{}.{}", self.func.path, self.func.name).into_boxed_str()
        }
    }
    pub fn get_type(&self) -> ParserType {
        ParserType::Function(Box::new(self.return_type.clone()), self.args.iter().map(|x| x.1.clone()).collect::<Vec<_>>().into_boxed_slice())
    }
    pub fn get_compiled_value(&self, symbol_table: &SymbolTable) -> CompiledValue{
        if self.func.is_generic(){
            return CompiledValue::GenericFunction { internal_id: symbol_table.get_bare_function_id(&self.full_path().as_ref(), false).expect("Function not found in symbol table") };
        }
        CompiledValue::Function { internal_id: symbol_table.get_bare_function_id(&self.full_path().as_ref(), false).expect("Function not found in symbol table") }
    }
}
// ------------------------------------------------------------------------------------
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
    compiler_type: ParserType,
    flags: Cell<u8>,
    value: RefCell<Option<LLVMVal>>,
}
impl FlagManager for Variable {
    fn get_flags(&self) -> &Cell<u8> { &self.flags }
}

impl Variable {
    pub fn new(comp_type: ParserType, is_const: bool) -> Self {
        let flags = if is_const { variable_flags::CONSTANT } else { 0 };
        Self {
            compiler_type: comp_type,
            flags: Cell::new(flags),
            value: RefCell::new(None),
        }
    }
    pub fn new_argument(comp_type: ParserType) -> Self {
        Self {
            compiler_type: comp_type,
            flags: Cell::new(variable_flags::ARGUMENT),
            value: RefCell::new(None),
        }
    }
    pub fn new_alias(comp_type: ParserType) -> Self {
        Self {
            compiler_type: comp_type,
            flags: Cell::new(variable_flags::ARGUMENT | variable_flags::ALIAS_VALUE),
            value: RefCell::new(None),
        }
    }

    pub fn get_type(&self, write: bool, modify_content: bool) -> &ParserType {
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

    pub fn compiler_type(&self) -> &ParserType {
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
        let ptype = self.compiler_type.clone();
        let type_str = get_llvm_type_str(&ptype, ctx.symbols, &ctx.current_function_path)?;
        let temp_id = ctx.aquire_unique_temp_value_counter();

        output.push_str(&format!(
            "    %tmp{} = load {}, {}* %v{}\n",
            temp_id, type_str, type_str, var_id
        ));
        Ok(LLVMVal::Register(temp_id))
    }
}

// ------------------------------------------------------------------------------------
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