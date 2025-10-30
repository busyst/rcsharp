use std::cell::{Cell, RefCell};

use ordered_hash_map::OrderedHashMap;

use crate::{compiler::{CompileError, CompileResult, SymbolTable, POINTER_SIZE_IN_BYTES}, expression_parser::Expr, parser::{ParserType, Stmt, PRIMITIVE_TYPES, PRIMITIVE_TYPES_SIZE}};

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
    pub fn get_size_of(&self, symbols: &SymbolTable) -> CompileResult<u32>{
        if self.is_generic() {
            return Err(CompileError::Generic("Cannot get the size of a generic type template.".to_string()));
        }
        if let Some(idx) = PRIMITIVE_TYPES.iter().position(|&x| x == self.name.as_ref()) {
            let size = PRIMITIVE_TYPES_SIZE[idx];
            if size == 0 {
                return Err(CompileError::Generic(format!("Trying to get size of zero-sized type '{}'", self.name)));
            }
            return Ok(size);
        }
        let mut sum = 0;
        for (field_name, field_type) in &self.fields {
            if field_type.is_pointer() {
                sum += POINTER_SIZE_IN_BYTES;
            } 
            else if let Some(pt) = field_type.as_primitive_type() {
                if let Some(idx) = PRIMITIVE_TYPES.iter().position(|x| *x == pt) {
                    let size = PRIMITIVE_TYPES_SIZE[idx];
                    if size == 0 {
                        return Err(CompileError::Generic(format!("Trying to get size of zero-sized type '{}'", self.name)));
                    }
                    sum += size;
                }
            }
            else {
                let r#struct = symbols.get_type(&field_type.to_string())
                    .ok_or(CompileError::SymbolNotFound(format!("In struct '{}', cannot resolve type for field '{}'", self.name, field_name)))?;
                sum += r#struct.get_size_of(symbols)?;
            }

        }
        return Ok(sum);
    }
    
    pub(crate) fn full_path(&self) -> Box<str> {
        if self.path.is_empty() {
            return self.name.to_string().into_boxed_str();
        }
        format!("{}.{}", self.path, self.name).into()
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
        let output = if self.path.is_empty() {
            self.name.clone()
        }else{
            let mut o = self.path.to_string();
            o.push('.');
            o.push_str(&self.name);
            o.into_boxed_str()
        };
        return output;
    }
    
    pub fn is_generic(&self) -> bool { self.flags.get() & FunctionFlags::Generic as u8 != 0 }
    pub fn is_imported(&self) -> bool { self.flags.get() & FunctionFlags::Imported as u8 != 0 }
    pub fn is_inline(&self) -> bool { self.flags.get() & FunctionFlags::Inline as u8 != 0 }
    pub fn set_as_imported(&self) { self.flags.set(self.flags.get() | FunctionFlags::Imported as u8);}
    pub fn flags(&self) -> u8 { self.flags.get() }
    
    pub(crate) fn get_type(&self) -> ParserType {
        ParserType::Function(Box::new(self.return_type.clone()), self.args.iter().map(|x| x.1.clone()).collect::<Vec<_>>().into_boxed_slice())
    }
    
    pub fn path(&self) -> &str {
        &self.path
    }
    
    pub fn name(&self) -> &str {
        &self.name
    }
    pub fn get_llvm_repr(&self) -> Box<str> {
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
        return &self.compiler_type;
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
            output.push_str(&format!("Unread\t"));
        }
        if !(self.is_argument() && !self.has_wrote()) {
            if !self.has_wrote() && !self.modified() {
                output.push_str(&format!("Unwritten\\Unmodified\t"));
            }
            if self.is_argument() {
                output.push_str(&format!("Argument\t"));
            }
        }

        return output;
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
    pub fn leave_scope(&self, variable: (&String, &(Variable, u32))){
        if variable.1.0.unusual_flags_to_string().is_empty() {
            return;
        }
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
        return sc;
    }
    
    pub fn loop_index(&self) -> Option<u32> {
        self.loop_index
    }
    
    pub fn set_loop_index(&mut self, loop_index: Option<u32>) {
        self.loop_index = loop_index;
    }
}