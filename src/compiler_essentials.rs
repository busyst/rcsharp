use std::{cell::{Cell, RefCell}, collections::HashMap};
use ordered_hash_map::OrderedHashMap;

use crate::{compiler::{CodeGenContext, substitute_generic_type}, compiler_primitives::Layout, expression_compiler::size_and_alignment_of_type, expression_parser::Expr, parser::{ParserType, Stmt}};

// ------------------------------------------------------------------------------------
#[derive(Debug, Clone)]
pub struct Enum {
    pub path: Box<str>,
    pub name: Box<str>,
    pub base_type: ParserType,
    pub fields: Box<[(String, i128)]>,
    
    pub attribs: Box<[Attribute]>, 
    pub flags: Cell<u8>
}

impl Enum {
    pub fn new(path: Box<str>, name: Box<str>, base_type: ParserType, fields: Box<[(String, i128)]>, attribs: Box<[Attribute]>) -> Self {
        Self { path, name, base_type, fields, attribs, flags: Cell::new(0) }
    }
}

// ------------------------------------------------------------------------------------
#[derive(Debug, Clone, PartialEq)]
pub struct Attribute {
    name: Box<str>,
    arguments: Box<[Expr]>
}
impl Attribute {
    pub fn new(name: Box<str>, arguments: Box<[Expr]>) -> Self {
        Self { name, arguments }
    }
    pub fn name_equals(&self, to: &str) -> bool{
        self.name == to.into()
    }

    /// Ensures that attribute has only one argument, and returns it.
    pub fn one_argument(&self) -> Result<&Expr, String> {
        if self.arguments.len() == 1 {
            Ok(&self.arguments[0])
        } else {
            Err(format!(
                "Attribute {} should have only one argument, but it has {}",
                self.name,
                self.arguments.len()
            ))
        }
    }
}

// ------------------------------------------------------------------------------------

pub enum StructFlags {
    Generic = 64,
    PrimitiveType = 128,
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
impl Struct {
    pub fn new(path: Box<str>, name: Box<str>, fields: Box<[(String, ParserType)]>, attribs: Box<[Attribute]>, generic_params: Box<[String]>) -> Self {
        let flags = if !generic_params.is_empty() {StructFlags::Generic as u8} else {0};
        Self { path, name, fields, attribs, flags: Cell::new(flags), generic_params, generic_implementations: RefCell::new(vec![]) }
    }
    pub fn new_primitive(name: &str) -> Self {
        Self { path : "".into(), name: name.into(), fields : Box::new([]), attribs: Box::new([]), flags: Cell::new(StructFlags::PrimitiveType as u8), generic_params: Box::new([]), generic_implementations: RefCell::new(vec![]) }
    }

    pub fn is_primitive(&self) -> bool { self.flags.get() & StructFlags::PrimitiveType as u8 != 0 }
    pub fn is_generic(&self) -> bool { self.flags.get() & StructFlags::Generic as u8 != 0 }
    pub fn set_as_generic(&self) { self.flags.set(self.flags.get() | StructFlags::Generic as u8);}
    pub fn llvm_representation(&self) -> String {
        if self.is_primitive() {
            self.name.to_string()
        } else if self.path.is_empty() {
            format!("%struct.{}", self.name)
        } else {
            format!("%struct.{}.{}", self.path, self.name)
        }
    }
    
    pub(crate) fn full_path(&self) -> Box<str> {
        if self.path.is_empty() {
            return self.name.to_string().into_boxed_str();
        }
        format!("{}.{}", self.path, self.name).into()
    }
}

pub struct StructView<'a>{
    r#struct : &'a Struct,
    fields: Vec<(String, ParserType)>,
    size_and_alligment: Layout,
}
impl<'a> StructView<'a> {
    pub fn new_unspec(r#struct: &'a Struct) -> Self {
        Self { r#struct, fields: Vec::new(),  size_and_alligment: Layout::new_not_valid() }
    }
    pub fn new(r#struct: &'a Struct) -> Self {
        if r#struct.is_generic() {
            panic!("Tried to get struct view of generic type without specifying generic parameters")
        }
        Self { r#struct, fields: Vec::new(), size_and_alligment: Layout::new_not_valid()}
    }
    pub fn new_generic(r#struct: &'a Struct, map: &HashMap<String, ParserType>) -> Self {
        if !r#struct.is_generic() {
            panic!("This type is not generic: {}", r#struct.full_path())
        }
        let all_generics_defined = r#struct.generic_params.iter().map(|x| map.contains_key(x)).all(|x| x == true);
        if !all_generics_defined {
            let definded = r#struct.generic_params.iter().filter(|x| map.contains_key(x.as_str())).cloned().collect::<Vec<_>>();
            let undefinded = r#struct.generic_params.iter().filter(|x| !map.contains_key(x.as_str())).cloned().collect::<Vec<_>>();
            panic!("Not all generic types defined in current context:\nDefined({}):{}\nUndefined({}):{}",
                definded.len(), definded.join("\n"),
                undefinded.len(), undefinded.join("\n"),
            )
        }
        let implementation = r#struct.generic_params.iter().map(|x| map.get(x).unwrap().clone()).collect::<Box<_>>();
        if implementation.len() != r#struct.generic_params.len() {
            panic!("Tried to get struct view of generic type with invalid count of generic parameters provided {}, needed {}", implementation.len(), r#struct.generic_params.len())
        }
        let mut fields = r#struct.fields.to_vec();
        {
            let mut brw = r#struct.generic_implementations.borrow_mut(); 
            if !brw.iter().any(|x| x.iter().eq(implementation.iter())) {
                brw.push(implementation);
            }
            for x in fields.iter_mut() {
                x.1 = substitute_generic_type(&x.1, map);
            }
        }
        
        Self { r#struct, fields, size_and_alligment: Layout::new_not_valid() }
    }
    pub fn calculate_size(&mut self, ctx : &mut CodeGenContext<'_>) -> Layout {
        if self.size_and_alligment.is_valid(){
            return self.size_and_alligment;
        }
        let mut current_offset = 0;
        let mut max_alignment = 1;
        for (_name, field_type) in self.field_types() {
            let layout_of_type = size_and_alignment_of_type(field_type, ctx);
            //println!("Calculating layout for field type: {}", field_type.debug_type_name());
            if layout_of_type.align == 0 { continue; }
            max_alignment = u32::max(max_alignment, layout_of_type.align);
            let padding = (layout_of_type.align - (current_offset % layout_of_type.align)) % layout_of_type.align;
            
            current_offset += padding;
            current_offset += layout_of_type.size;
        }
        let final_padding = (max_alignment - (current_offset % max_alignment)) % max_alignment;
        let total_size = current_offset + final_padding;
        self.size_and_alligment = Layout::new(total_size, max_alignment);
        return Layout::new(total_size, max_alignment);
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
    pub fn llvm_representation(&self) -> String {
        self.r#struct.llvm_representation()
    } 
    pub fn generic_params(&self) -> &Box<[String]> {
        &self.r#struct.generic_params
    }
    
}

// ------------------------------------------------------------------------------------
#[repr(u8)]
pub enum FunctionFlags {
    Imported = 128,
    ConstExpression = 64,
    Inline = 32,
    Public = 16,
    Generic = 8,
}
#[derive(Debug, Clone)]
pub struct Function {
    pub path: Box<str>,
    pub name: Box<str>,
    pub args: Box<[(String, ParserType)]>, 
    pub return_type: ParserType,
    pub body: Box<[Stmt]>,
    pub attribs: Box<[Attribute]>, 
    flags: Cell<u8>,

    pub generic_params: Box<[String]>,
    pub generic_implementations: RefCell<Vec<Box<[ParserType]>>>,
}
impl Function {
    pub fn new(path: Box<str>, name: Box<str>, args: Box<[(String, ParserType)]>, return_type: ParserType, body: Box<[Stmt]>, flags: Cell<u8>, attribs: Box<[Attribute]>, generic_params: Box<[String]>) -> Self {
        Self { path, name, args, return_type, body, attribs, flags, generic_params, generic_implementations: RefCell::new(vec![]) }
    }
    
    pub fn effective_name(&self) -> Box<str> {
        
        if self.path.is_empty() {
            self.name.clone()
        }else{
            let mut o = self.path.to_string();
            o.push('.');
            o.push_str(&self.name);
            o.into_boxed_str()
        }
    }
    
    pub fn is_generic(&self) -> bool { self.flags.get() & FunctionFlags::Generic as u8 != 0 }
    pub fn is_imported(&self) -> bool { self.flags.get() & FunctionFlags::Imported as u8 != 0 }
    pub fn is_inline(&self) -> bool { self.flags.get() & FunctionFlags::Inline as u8 != 0 }
    pub fn set_as_imported(&self) { self.flags.set(self.flags.get() | FunctionFlags::Imported as u8);}
    pub fn flags(&self) -> u8 { self.flags.get() }
    
    pub fn get_type(&self) -> ParserType {
        ParserType::Function(Box::new(self.return_type.clone()), self.args.iter().map(|x| x.1.clone()).collect::<Vec<_>>().into_boxed_slice())
    }
    
    pub fn path(&self) -> &str {
        &self.path
    }
    
    pub fn name(&self) -> &str {
        &self.name
    }
    
    pub fn llvm_name(&self) -> Box<str> {
        if self.is_imported(){
            self.name.clone()
        }else{
            self.effective_name()
        }
    }
}

// ------------------------------------------------------------------------------------
#[repr(u8)]
pub enum VariableFlags {
    HasRead = 1,
    HasWrote = 2,
    ModifiedContent = 4,
    AliasValue = 32,
    Constant = 64,
    Argument = 128,
}
#[derive(Debug, Clone)]
pub struct Variable{
    pub compiler_type: ParserType,
    pub flags: Cell<u8>,
}
impl Variable {
    pub fn new(comp_type: ParserType, is_const: bool) -> Self {
        let flags = if is_const { VariableFlags::Constant as u8 } else { 0 };
        Self { compiler_type: comp_type, flags: Cell::new(flags) }
    }
    pub fn new_argument(comp_type: ParserType) -> Self {
        Self { compiler_type: comp_type, flags: Cell::new(VariableFlags::Argument as u8) }
    }
    pub fn new_alias(comp_type: ParserType) -> Self {
        Self { compiler_type: comp_type, flags: Cell::new(VariableFlags::Argument as u8 | VariableFlags::AliasValue as u8) }
    }
    pub fn get_type(&self, write: bool, modify_content: bool) -> &ParserType{
        if write {
            self.flags.replace(self.flags.get() | VariableFlags::HasWrote as u8);
        }else {
            self.flags.replace(self.flags.get() | VariableFlags::HasRead as u8);
        }
        if modify_content {
            self.flags.replace(self.flags.get() | VariableFlags::ModifiedContent as u8);
        }
        &self.compiler_type
    }
    
    pub fn is_argument(&self) -> bool {
        self.flags.get() & VariableFlags::Argument as u8 != 0
    }
    // Used only in inlining
    pub fn is_alias_value(&self) -> bool {
        self.flags.get() & VariableFlags::AliasValue as u8 != 0
    }

    pub fn has_read(&self) -> bool{
        self.flags.get() & VariableFlags::HasRead as u8 != 0
    }
    pub fn has_wrote(&self) -> bool{
        self.flags.get() & VariableFlags::HasWrote as u8 != 0
    }
    pub fn modified(&self) -> bool{
        self.flags.get() & VariableFlags::ModifiedContent as u8 != 0
    }
    pub fn unusual_flags_to_string(&self) -> String{
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
}

// ------------------------------------------------------------------------------------
#[derive(Debug, Clone, Default)]
pub struct Scope{
    upper_scope_variables: OrderedHashMap<String, (Variable, u32)>,
    current_scope_variables: OrderedHashMap<String, (Variable, u32)>,
    loop_index: Option<u32>,
}
impl Scope {
    pub fn new(upper_scope_variables: OrderedHashMap<String, (Variable, u32)>, current_scope_variables: OrderedHashMap<String, (Variable, u32)>, loop_index: Option<u32>) -> Self {
        Self { upper_scope_variables, current_scope_variables, loop_index }
    }
    pub fn empty() -> Self {
        Self { upper_scope_variables: OrderedHashMap::new(), current_scope_variables: OrderedHashMap::new(), loop_index: None }
    }
    
    pub fn clear(&mut self){
        self.current_scope_variables.clear();
        self.upper_scope_variables.clear();
    }
    pub fn get_variable(&self, name: &str) -> Option<&(Variable, u32)>{
        if self.current_scope_variables.contains_key(name) {
            return Some(&self.current_scope_variables[name]);
        }
        if self.upper_scope_variables.contains_key(name) {
            return Some(&self.upper_scope_variables[name]);
        }
        None
    }
    pub fn add_variable(&mut self, name: String, variable: Variable, unique_value_tag: u32) {
        if self.current_scope_variables.contains_key(&name) {
            let var = self.current_scope_variables.remove(&name).unwrap();
            self.leave_scope((&name, &var));
        }
        self.current_scope_variables.insert(name, (variable, unique_value_tag));
    }
    pub fn leave_scope(&self, _variable: (&String, &(Variable, u32))){
        //println!("Variable {}, has left scope.\nFlags:\t{}", variable.0, variable.1.0.unusual_flags_to_string());
    }
    
    pub fn swap_and_exit(&mut self, original_scope: Scope) {
        for var in &self.upper_scope_variables {
            let original_flags = if original_scope.upper_scope_variables.contains_key(var.0) {
                &original_scope.upper_scope_variables[var.0].0.flags
            }else{
                &original_scope.current_scope_variables[var.0].0.flags
            };
            original_flags.set(original_flags.get() | var.1.0.flags.get());
        }

        for var in self.current_scope_variables.iter().rev() {
            self.leave_scope(var)
        }
        self.current_scope_variables = original_scope.current_scope_variables;
        self.upper_scope_variables = original_scope.upper_scope_variables;
        self.loop_index = original_scope.loop_index;
    }
    pub fn clone_and_enter(&mut self) -> Scope{
        let sc = self.clone();
        
        let mut new_scope = self.current_scope_variables.clone();
        for x in &self.upper_scope_variables {
            if !new_scope.contains_key(x.0) {
                new_scope.insert(x.0.clone(), x.1.clone());
            }
        }
        self.upper_scope_variables = new_scope;
        self.current_scope_variables.clear();
        sc
    }
    
    pub fn loop_index(&self) -> Option<u32> {
        self.loop_index
    }
    
    pub fn set_loop_index(&mut self, loop_index: Option<u32>) {
        self.loop_index = loop_index;
    }
}