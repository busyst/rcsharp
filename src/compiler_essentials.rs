use std::cell::Cell;

use ordered_hash_map::OrderedHashMap;

use crate::{compiler::{CompileResult, SymbolTable, POINTER_SIZE_IN_BYTES}, expression_parser::Expr, parser::{ParserType, Stmt}};

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
#[derive(Debug, Clone)]
pub struct Attribute {
    name: Box<str>,
    arguments: Vec<Expr>
}
impl Attribute {
    pub fn new(name: Box<str>, arguments: Vec<Expr>) -> Self {
        Self { name, arguments }
    }
    pub fn name_equals(&self, to: &str) -> bool{
        self.name == to.into()
    }
    /// Ensures that attribute has only one argument, and returns it
    pub fn one_argument(&self) -> Result<&Expr, String>{
        self.arguments.get(0).and_then(|x| if self.arguments.len() == 1 {Some(x)} else {None}).ok_or(format!("Atribute {} should have only one argument, it has {} arguments", self.name, self.arguments.len()))
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
    
    pub attribs: Box<[Attribute]>, 
    pub flags: Cell<u8>
}
impl Struct {
    pub fn new(path: Box<str>, name: Box<str>, fields: Box<[(String, ParserType)]>, attribs: Box<[Attribute]>) -> Self {
        Self { path, name, fields, attribs, flags: Cell::new(0) }
    }
    pub fn new_primitive(name: &str) -> Self {
        Self { path : "".to_string().into_boxed_str(), name: name.to_string().into_boxed_str(), fields : Box::new([]), attribs: Box::new([]), flags: Cell::new(StructFlags::PrimitiveType as u8) }
    }
    pub fn new_generic(path: Box<str>, name: Box<str>, fields: Box<[(String, ParserType)]>, attribs: Box<[Attribute]>) -> Self {
        Self { path, name, fields, attribs, flags: Cell::new(StructFlags::Generic as u8) }
    }
    pub fn is_primitive(&self) -> bool { self.flags.get() & StructFlags::PrimitiveType as u8 != 0 }
    pub fn is_generic(&self) -> bool { self.flags.get() & StructFlags::Generic as u8 != 0 }
    pub fn llvm_representation(&self) -> String { 
        if self.is_primitive() {
            self.name.to_string()
        }else {
            if self.path.is_empty() {
                format!("%struct.{}", self.name)
            }else {
                format!("%struct.{}.{}", self.path, self.name)
            }
        }
    }
    pub fn get_size_of(&self, symbols: &SymbolTable) -> CompileResult<u32>{
        match self.name.as_ref() {
            "i8" | "u8" => Ok(1),
            "i16" | "u16" => Ok(2),
            "i32" | "u32" => Ok(4),
            "i64" | "u64" => Ok(8),
            _ => {
                let mut sum = 0;
                for field in &self.fields {
                    if field.1.is_pointer() {
                        sum += POINTER_SIZE_IN_BYTES;
                        continue;
                    }
                    if field.1.is_primitive_type() {
                        sum += match field.1.to_string().as_str() {
                            "void" => panic!("Size of void type is unknown, obviously"),
                            "i8" | "u8" | "bool" => 1,
                            "i16" | "u16" => 2,
                            "i32" | "u32" => 4,
                            "i64" | "u64" => 8,
                            _ => unreachable!(),
                        };
                        continue;
                    }
                    if let Ok(r#struct) = symbols.get_type(&field.1.to_string()) {
                        sum += r#struct.get_size_of(symbols)?;
                        continue;
                    }
                    panic!("{:?}", field)
                }
                return Ok(sum);
            }
        }
    }
}

// ------------------------------------------------------------------------------------
pub enum FunctionFlags {
    Imported = 128,
}
#[derive(Debug, Clone)]
pub struct Function {
    pub path: String,
    pub name: String,
    pub args: Box<[(String, ParserType)]>, 
    pub return_type: ParserType,
    pub body: Box<[Stmt]>,
    pub attribs: Box<[Attribute]>, 
    flags: Cell<u8>
}
impl Function {
    pub fn new(path: String, name: String, args: Box<[(String, ParserType)]>, return_type: ParserType, body: Box<[Stmt]>, attribs: Box<[Attribute]>) -> Self {
        Self { path, name, args, return_type, body, attribs, flags: Cell::new(0) }
    }
    
    pub fn effective_name(&self) -> String {
        let output = if self.path.is_empty() {
            self.name.clone()
        }else{
            let mut o = self.path.clone();
            o.push('.');
            o.push_str(&self.name);
            o
        };
        return output;
    }
    
    pub fn is_imported(&self) -> bool { self.flags.get() & FunctionFlags::Imported as u8 != 0 }
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
    pub fn get_llvm_repr(&self) -> String {
        if self.is_imported(){
            self.name.clone()
        }else{
            self.effective_name()
        }
    }
}

// ------------------------------------------------------------------------------------
pub enum VariableFlags {
    HasRead = 1,
    HasWrote = 2,
    ModifiedContent = 4,
    Constant = 64,
    Argument = 128,
}
#[derive(Debug, Clone)]
pub struct Variable{
    pub compiler_type: ParserType,
    pub flags: Cell<u8>
}
impl Variable {
    pub fn new(comp_type: ParserType) -> Self {
        Self { compiler_type: comp_type, flags: Cell::new(0) }
    }
    pub fn new_argument(comp_type: ParserType) -> Self {
        Self { compiler_type: comp_type, flags: Cell::new(VariableFlags::Argument as u8) }
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
    upper_scope_variables: OrderedHashMap<String, Variable>,
    current_scope_variables: OrderedHashMap<String, Variable>,
    loop_index: Option<u32>,
}
impl Scope {
    pub fn new(upper_scope_variables: OrderedHashMap<String, Variable>, current_scope_variables: OrderedHashMap<String, Variable>, loop_index: Option<u32>) -> Self {
        Self { upper_scope_variables, current_scope_variables, loop_index }
    }


    pub fn empty() -> Self {
        Self { upper_scope_variables: OrderedHashMap::new(), current_scope_variables: OrderedHashMap::new(), loop_index: None }
    }
    pub fn get_variable(&self, name: &str) -> Result<&Variable,String>{
        if self.current_scope_variables.contains_key(name) {
            return Ok(&self.current_scope_variables[name]);
        }
        if self.upper_scope_variables.contains_key(name) {
            return Ok(&self.upper_scope_variables[name]);
        }
        return Err(format!("Variable \"{}\" was not found inside current scope",name));
    }
    pub fn add_variable(&mut self, name: String, variable: Variable) {
        if self.current_scope_variables.contains_key(&name) {
            let var = self.current_scope_variables.remove(&name).unwrap();
            self.leave_scope((&name, &var));
        }
        self.current_scope_variables.insert(name, variable);
    }
    pub fn leave_scope(&self, variable: (&String, &Variable)){
        if variable.1.unusual_flags_to_string().is_empty() {
            return;
        }
        println!("Variable {}, has left scope.\nFlags:\t{}", variable.0, variable.1.unusual_flags_to_string());
    }
    
    pub fn swap_and_exit(&mut self, original_scope: Scope) {
        for var in &self.upper_scope_variables {
            let original_flags = if original_scope.upper_scope_variables.contains_key(var.0) {
                &original_scope.upper_scope_variables[var.0].flags
            }else{
                &original_scope.current_scope_variables[var.0].flags
            };
            original_flags.set(original_flags.get() | var.1.flags.get());
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