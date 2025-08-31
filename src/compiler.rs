use core::str;
use std::cell::Cell;
use ordered_hash_map::OrderedHashMap;
use crate::{compiler_essentials::{Attribute, Enum, Function, Scope, Struct, Variable}, expression_compiler::{compile_expression, constant_integer_expression_compiler, Expected}, expression_parser::Expr, parser::{ParserType, Stmt}};
pub const POINTER_SIZE_IN_BYTES : u32 = 8;
#[derive(Debug)]
pub enum CompileError {
    Io(std::io::Error),
    DuplicateSymbol(String),
    SymbolNotFound(String),
    TypeMismatch {
        expected: ParserType,
        found: ParserType,
    },
    InvalidStatementInContext(String),
    InvalidExpression(String),
    InvalidEnumBaseType(String),
    Generic(String),
}
impl std::fmt::Display for CompileError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            CompileError::Io(e) => write!(f, "IO Error: {}", e),
            CompileError::DuplicateSymbol(name) => write!(f, "Symbol '{}' is already defined", name),
            CompileError::SymbolNotFound(name) => write!(f, "Symbol '{}' not found in the current scope", name),
            CompileError::TypeMismatch { expected, found } => write!(f, "Type mismatch: expected {:?}, found {:?}", expected, found),
            CompileError::InvalidStatementInContext(stmt) => write!(f, "Statement '{}' is not valid in the current context", stmt),
            CompileError::InvalidExpression(expr) => write!(f, "Invalid expression: {}", expr),
            CompileError::InvalidEnumBaseType(name) => write!(f, "Enum '{}' has an invalid (non-integer) base type", name),
            CompileError::Generic(msg) => write!(f, "Compilation error: {}", msg),
        }
    }
}
impl From<std::io::Error> for CompileError {
    fn from(err: std::io::Error) -> Self {
        CompileError::Io(err)
    }
}

pub type CompileResult<T> = Result<T, CompileError>;

pub fn rcsharp_compile_to_file(stmts: &[Stmt]) -> Result<(), String> {
    match rcsharp_compile(stmts) {
        Ok(llvm_ir) => {
            std::fs::write("output.ll", llvm_ir)
                .map_err(|e| e.to_string())
        }
        Err(e) => Err(e.to_string()),
    }
}

pub fn rcsharp_compile(stmts: &[Stmt]) -> CompileResult<String>  {
    
    let mut symbols = SymbolTable::new();
    let mut output = LLVMOutputHandler::default();
    output.push_str_header("target triple = \"x86_64-pc-windows-msvc\"\n");
    SymbolCollector::collect(stmts, &mut symbols).unwrap();

    compile_structs(&symbols, &mut output)?;
    compile_attributes(&symbols, &mut output)?;
    compile_functions(&symbols, &mut output)?;
    
    Ok(output.build())
}

fn populate_default_types(table: &mut SymbolTable) {
    table.types.insert("i8".to_string(), Struct::new_primitive("i8"));
    table.types.insert("u8".to_string(), Struct::new_primitive("u8"));
    table.types.insert("i16".to_string(), Struct::new_primitive("i16"));
    table.types.insert("u16".to_string(), Struct::new_primitive("u16"));
    table.types.insert("i32".to_string(), Struct::new_primitive("i32"));
    table.types.insert("u32".to_string(), Struct::new_primitive("u32"));
    table.types.insert("i64".to_string(), Struct::new_primitive("i64"));
    table.types.insert("u64".to_string(), Struct::new_primitive("u64"));
    table.types.insert("bool".to_string(), Struct::new_primitive("bool"));
    table.types.insert("void".to_string(), Struct::new_primitive("void"));
}
fn compile_structs(symbols: &SymbolTable, output: &mut LLVMOutputHandler) -> CompileResult<()> {
    let user_defined_structs = symbols.types.values().filter(|s: &&Struct| !s.is_primitive());
    for s in user_defined_structs {
        let field_types: Vec<String> = s.fields
            .iter()
            .map(|(_field_name, field_type)| get_llvm_type_str(field_type, symbols, &s.path))
            .collect::<CompileResult<_>>()?;

        let llvm_struct_name = s.llvm_representation();
        let fields_str = field_types.join(", ");
        let type_definition = format!("{} = type {{ {} }}\n", llvm_struct_name, fields_str);
        output.push_str_header(&type_definition);
    }
    Ok(())
}
fn compile_attributes(symbols: &SymbolTable, output: &mut LLVMOutputHandler) -> CompileResult<()>{
    let imported_funcs = symbols.functions.values().filter(|s| s.attribs.iter().any(|attr| attr.name_equals("DllImport")));
    for function in imported_funcs {
        let return_type_str = get_llvm_type_str(&function.return_type, symbols, &function.path)?;
        let args_string = function.args.iter().map(|x| get_llvm_type_str(&x.1, symbols, &function.path))
            .collect::<CompileResult<Vec<_>>>()?.join(",");
        function.set_as_imported();
        output.push_str_header(&format!("declare dllimport {} @{}({})\n", return_type_str, function.name, args_string));
    }
    Ok(())
}

fn compile_functions(symbols: &SymbolTable, output: &mut LLVMOutputHandler) -> CompileResult<()>{
    let functions_to_compile = symbols.functions.values()
        .filter(|f| !f.is_imported());
    let mut cvc = 0;
    for function in functions_to_compile {
        let mut ctx = CodeGenContext::new(symbols, function);
        ctx.const_vectors_counter = Cell::new(cvc);
        compile_single_function(&mut ctx, function, output)?;
        cvc = ctx.const_vectors_counter.get();
    }
    Ok(())
}
fn compile_single_function(
    ctx: &mut CodeGenContext,
    function: &Function,
    output: &mut LLVMOutputHandler,
) -> CompileResult<()> {
    let return_type_str = get_llvm_type_str(&function.return_type, ctx.symbols, &function.path)?;

    let args_str = function.args.iter()
        .map(|(name, ptype)| {
            get_llvm_type_str(ptype, ctx.symbols, &function.path)
                .map(|type_str| format!("{} %{}", type_str, name))
        })
        .collect::<CompileResult<Vec<_>>>()?
        .join(", ");
    
    output.push_str(&format!(
        "\ndefine {} @{}({}) {{\n",
        return_type_str,
        function.effective_name(),
        args_str
    ));

    /*for (arg_name, arg_type) in function.args.iter() { // FOR MUTABLE ARGUMENTS
        let arg_type_str = get_llvm_type_str(arg_type, ctx.symbols, &function.path)?;
        let ptr_name = format!("{}.addr", arg_name);

        output.push_str(&format!("    %{} = alloca {}\n", ptr_name, arg_type_str));
        output.push_str(&format!("    store {} %{}, {}* %{}\n", arg_type_str, arg_name, arg_type_str, ptr_name));

        ctx.scope.add_variable(arg_name.clone(), Variable::new_argument(arg_type.clone(), ptr_name));
    }*/
    for (arg_name, arg_type) in function.args.iter() {
        ctx.scope.add_variable(arg_name.clone(), Variable::new_argument(arg_type.clone()));
    }
    for stmt in function.body.iter(){
        compile_statement(stmt, ctx, output)
            .map_err(|e| CompileError::Generic(format!("In function '{}':\n{}", function.effective_name(), e)))?;
    }
    if !matches!(function.body.last(), Some(Stmt::Return(_))) {
         if function.return_type.is_void() {
            output.push_str("    ret void\n");
        } else {
            output.push_str("\n    unreachable\n");
        }   
    }

    output.push_str("}\n");

    Ok(())
}

fn compile_statement(stmt: &Stmt, ctx: &mut CodeGenContext, output: &mut LLVMOutputHandler) -> CompileResult<()>{
    match &stmt {
        Stmt::Let(name, var_type, expr) => {
            let llvm_type = get_llvm_type_str(var_type, ctx.symbols, &ctx.current_function_path)?;
            output.push_str(&format!("    %{} = alloca {}\n", name, llvm_type));
            ctx.scope.add_variable(name.clone(), Variable::new(var_type.clone()));

            if let Some(init_expr) = expr {
                let assignment = Expr::Assign(
                    Box::new(Expr::Name(name.clone())),
                    Box::new(init_expr.clone())
                );
                compile_expression(&assignment, Expected::Type(var_type), ctx, output)?;
            }
        }
        Stmt::Expr(expression) => {
            compile_expression(expression, Expected::NoReturn, ctx, output)?;
        }
        Stmt::Return(expression) => {
            let func = ctx.get_current_function()?;
            if let Some(expr) = expression {
                let expected_type = &func.return_type;
                let value = compile_expression(expr, Expected::Type(expected_type), ctx, output)?;
                
                let llvm_type_str = get_llvm_type_str(expected_type, ctx.symbols, &ctx.current_function_path)?;
                output.push_str(&format!("    ret {} {}\n", llvm_type_str, value.get_llvm_repr()));
            } else {
                if !func.return_type.is_void() {
                    return Err(CompileError::Generic("Cannot return without a value from a non-void function.".to_string()));
                }
                output.push_str("    ret void\n");
            }
        }
        Stmt::Continue => {
            if let Some(li) = ctx.scope.loop_index() {
                output.push_str(&format!("    br label %loop_body{}\n", li));
                return Ok(());
            }
            return Err(CompileError::InvalidStatementInContext(format!("Tried to continue without loop")));
        }
        Stmt::Break => {
            if let Some(li) = ctx.scope.loop_index() {
                output.push_str(&format!("    br label %loop_body{}_exit\n", li));
                return Ok(());
            }
            return Err(CompileError::InvalidStatementInContext(format!("Tried to break without loop")));
        }
        Stmt::If(condition, then_body, else_body) => {
            let bool_type = ParserType::Named("bool".to_string());
            let cond_val = compile_expression(condition, Expected::Type(&bool_type), ctx, output)?;

            if cond_val.get_type() != &bool_type {
                return Err(CompileError::InvalidExpression(format!("'{:?}' must result in bool, instead resulted in {:?}", condition, cond_val.get_type())));
            }

            let logic_id = ctx.aquire_unique_logic_counter();
            let then_label = format!("then{}", logic_id);
            let else_label = format!("else{}", logic_id);
            let end_label = format!("endif{}", logic_id);
            
            let target_else = if else_body.is_empty() { &end_label } else { &else_label };
            output.push_str(&format!("    br i1 {}, label %{}, label %{}\n", cond_val.get_llvm_repr(), then_label, target_else));

            output.push_str(&format!("{}:\n", then_label));
            let original_scope = ctx.scope.clone_and_enter();
            for then_stmt in then_body {
                compile_statement(then_stmt, ctx, output)?;
            }
            ctx.scope.swap_and_exit(original_scope);
            output.push_str(&format!("    br label %{}\n", end_label));

            if !else_body.is_empty() {
                output.push_str(&format!("{}:\n", else_label));
                let original_scope = ctx.scope.clone_and_enter();
                for else_stmt in else_body {
                    compile_statement(else_stmt, ctx, output)?;
                }
                ctx.scope.swap_and_exit(original_scope);
                output.push_str(&format!("    br label %{}\n", end_label));
            }

            output.push_str(&format!("{}:\n", end_label));
        }
        Stmt::Loop(statement) =>{
            let lc = ctx.aquire_unique_logic_counter();
            
            output.push_str(&format!("    br label %loop_body{}\n", lc));
            output.push_str(&format!("loop_body{}:\n", lc));
            let original_scope = ctx.scope.clone_and_enter();
            ctx.scope.set_loop_index(Some(lc));
            for x in statement {
                compile_statement(x, ctx, output)?;
            }
            ctx.scope.swap_and_exit(original_scope);
            output.push_str(&format!("    br label %loop_body{}\n", lc));
            output.push_str(&format!("loop_body{}_exit:\n", lc));
        }
        Stmt::Function(..) | Stmt::Struct(..) | Stmt::Enum(..) | Stmt::Namespace(..) | Stmt::Hint(..) => {
            return Err(CompileError::InvalidStatementInContext(format!("{:?}", stmt)));
        }
        _ => panic!("{:?}", stmt),
    }
    Ok(())
}



pub fn get_llvm_type_str(
    ptype: &ParserType,
    symbols: &SymbolTable,
    current_namespace: &str,
) -> CompileResult<String> {
    match ptype {
        ParserType::Named(name) => match name.as_str() {
            "void" => Ok("void".to_string()),
            "bool" => Ok("i1".to_string()),
            "i8" | "u8" => Ok("i8".to_string()),
            "i16" | "u16" => Ok("i16".to_string()),
            "i32" | "u32" => Ok("i32".to_string()),
            "i64" | "u64" => Ok("i64".to_string()),
            "f32" => Ok("f32".to_string()),
            "f64" => Ok("f64".to_string()),
            _ => {
                let fqn = ptype.get_absolute_path_or(current_namespace);
                if symbols.types.contains_key(&fqn) {
                    Ok(format!("%struct.{}", fqn))
                } else if symbols.enums.contains_key(&fqn) {
                    let enum_info = &symbols.enums[&fqn];
                    get_llvm_type_str(&enum_info.base_type, symbols, current_namespace)
                }
                else {
                    Err(CompileError::SymbolNotFound(fqn))
                }
            }
        },
        ParserType::Pointer(inner_type) => {
            if inner_type.is_void() {
                Ok("i8*".to_string())
            } else {
                let inner_llvm_type = get_llvm_type_str(inner_type, symbols, current_namespace)?;
                Ok(format!("{}*", inner_llvm_type))
            }
        }
        ParserType::Function(return_type, param_types) => {
            let ret_llvm = get_llvm_type_str(return_type, symbols, current_namespace)?;
            let params_llvm: Vec<String> = param_types
                .iter()
                .map(|param_type| get_llvm_type_str(param_type, symbols, current_namespace))
                .collect::<CompileResult<Vec<String>>>()?;
            Ok(format!("{} ({})*", ret_llvm, params_llvm.join(", ")))
        }
        ParserType::NamespaceLink(_, _) => {
            let fqn = ptype.get_absolute_path_or(current_namespace);
            if symbols.types.contains_key(&fqn) {
                Ok(format!("%struct.{}", fqn))
            } else if symbols.enums.contains_key(&fqn) {
                let enum_info = &symbols.enums[&fqn];
                get_llvm_type_str(&enum_info.base_type, symbols, current_namespace)
            }
            else {
                Err(CompileError::SymbolNotFound(fqn))
            }
        }
    }
}


#[derive(Debug, Default)]
pub struct LLVMOutputHandler{
    header: String,
    main: String,
}
impl LLVMOutputHandler {
    pub fn push_str(&mut self, s: &str) {
        self.main.push_str(s);
    }
    pub fn push_str_header(&mut self, s: &str) {
        self.header.push_str(s);
    }
    pub fn build(self) -> String {
        format!("{}\n{}", self.header, self.main)
    }
}


#[derive(Debug, Default)]
pub struct SymbolTable {
    pub functions: OrderedHashMap<String, Function>,
    pub types: OrderedHashMap<String, Struct>,
    pub enums: OrderedHashMap<String, Enum>,
}
pub struct CodeGenContext<'a> {
    pub symbols: &'a SymbolTable,
    pub current_function_path: String,
    pub current_function_name: String,
    pub scope: Scope,

    temp_value_counter: Cell<u32>,
    logic_counter: Cell<u32>,
    const_vectors_counter: Cell<u32>,
}
impl<'a> CodeGenContext<'a> {
    pub fn new(symbols: &'a SymbolTable, function: &Function) -> Self {
        Self {
            symbols,
            current_function_path: function.path.clone(),
            current_function_name: function.name.clone(),
            scope: Scope::default(),
            temp_value_counter: Cell::new(0),
            logic_counter: Cell::new(0),
            const_vectors_counter: Cell::new(0),
        }
    }
    pub fn get_current_function(&self) -> CompileResult<&'a Function> {
        self.symbols.get_function(&self.current_function_name, &self.current_function_path)
    }
    pub fn fully_qualified_name(&self, name: &str) -> String {
        if self.current_function_path.is_empty() {
            name.to_string()
        } else {
            format!("{}.{}", self.current_function_path, name)
        }
    }
    pub fn aquire_unique_temp_value_counter(&self) -> u32{
        self.temp_value_counter.replace(self.temp_value_counter.get() + 1)
    }
    pub fn aquire_unique_logic_counter(&mut self) -> u32{
        self.logic_counter.replace(self.logic_counter.get() + 1)
    }
    pub fn aquire_unique_const_vector_counter(&mut self) -> u32{
        self.const_vectors_counter.replace(self.const_vectors_counter.get() + 1)
    }
}
impl SymbolTable {
    pub fn new() -> Self {
        let mut table = Self::default();
        populate_default_types(&mut table);
        table
    }
    pub fn get_function(&self, fqn: &str, current_namespace: &str) -> CompileResult<&Function> {
        if let Some(r#fn) = self.functions.get(&format!("{}.{}", current_namespace, fqn)) {
            return Ok(r#fn);
        }
        if let Some(r#fn) = self.functions.get(fqn) {
            return Ok(r#fn);
        }
        return Err(CompileError::SymbolNotFound(format!("Function '{}' was not found in namespace '{}'", fqn, current_namespace)));
    }
    pub fn get_type(&self, fqn: &str) -> CompileResult<&Struct> {
        self.types.get(fqn).ok_or_else(|| CompileError::SymbolNotFound(fqn.to_string()))
    }
    pub fn get_abs_path(struct_type: &ParserType, current_namespace: &str) -> String {
        debug_assert!(!struct_type.is_primitive_type());
        debug_assert!(!struct_type.is_pointer());
        if let ParserType::NamespaceLink(s, y) = struct_type {
            return format!("{}.{}", s, y.to_string());
        }
        if let ParserType::Named(n) = struct_type{
            if current_namespace.is_empty() {
                return n.to_string();
            }else {
                return format!("{}.{}", current_namespace, n);
            }
        };
        unreachable!()
    }
    pub fn get_struct_representation(&self, struct_type: &ParserType, current_namespace: &str) -> CompileResult<(&Box<str>, &Box<[(String, ParserType)]>)> {
        debug_assert!(!struct_type.is_primitive_type());
        debug_assert!(!struct_type.is_pointer());
        let x = self.types.get(&SymbolTable::get_abs_path(struct_type, current_namespace)).ok_or(CompileError::SymbolNotFound(format!("Type:{:?}, Namespace {}",struct_type, current_namespace)))?;
        return Ok((&x.name, &x.fields));
    }
}

pub struct SymbolCollector<'a> {
    symbols: &'a mut SymbolTable,
    current_path: String,
}
impl<'a> SymbolCollector<'a> {
    pub fn collect(stmts: &[Stmt], symbols: &'a mut SymbolTable) -> CompileResult<()> {
        let mut collector = Self {
            symbols,
            current_path: "".to_string(),
        };
        collector.walk_statements(stmts)?;
        Ok(())
    }

    fn walk_statements(&mut self, stmts: &[Stmt]) -> CompileResult<()> {
        for (i, statement) in stmts.iter().enumerate() {
            if matches!(statement, Stmt::Hint(_, _)) {
                continue;
            }

            let attributes = self.collect_preceding_attributes(stmts, i);      
            match statement {
                Stmt::Function(n, a, r, b) => self.collect_function(n, a, r, b, attributes)?,
                Stmt::Struct(n, a) => self.collect_struct(n, a, attributes)?,
                Stmt::Enum(n, base, entries) => self.collect_enum(n, base, entries, attributes)?,
                Stmt::Namespace(n, body) => {
                    let new_path = if self.current_path.is_empty() { n.clone() } else { format!("{}.{}", self.current_path, n) };
                    let old_path = std::mem::replace(&mut self.current_path, new_path);
                    self.walk_statements(body)?;
                    self.current_path = old_path;
                }
                _ => return Err(CompileError::InvalidStatementInContext(format!("{:?}", statement))),
            }
        }
        Ok(())
    }
    fn collect_preceding_attributes(&self, stmts: &[Stmt], item_index: usize) -> Box<[Attribute]> {
        stmts[..item_index]
            .iter()
            .rev()
            .take_while(|stmt| matches!(stmt, Stmt::Hint(_, _)))
            .filter_map(|stmt| {
                if let Stmt::Hint(name, args) = stmt {
                    Some(Attribute::new(name.clone().into(), args.to_vec()))
                } else {
                    None
                }
            })
            .collect()
    }
    fn collect_function(&mut self, name: &str, args: &[(String, ParserType)], ret: &ParserType, body: &[Stmt], attribs: Box<[Attribute]>) -> CompileResult<()> {
        let fqn = if self.current_path.is_empty() { name.to_string() } else { format!("{}.{}", self.current_path, name) };
        if self.symbols.functions.contains_key(&fqn) {
            return Err(CompileError::DuplicateSymbol(fqn));
        }
        let qualified_return_type = self.qualify_type(ret);
        let qualified_args = args.iter()
            .map(|(arg_name, arg_type)| (arg_name.clone(), self.qualify_type(arg_type)))
            .collect::<Vec<_>>()
            .into_boxed_slice();

        let function = Function::new(
            self.current_path.clone(),
            name.to_string(),
            qualified_args,
            qualified_return_type,
            body.to_vec().into_boxed_slice(),
            attribs,
        );
        self.symbols.functions.insert(fqn, function);
        Ok(())
    }
    fn collect_struct(&mut self, name: &str, fields: &[(String, ParserType)], attribs: Box<[Attribute]>) -> CompileResult<()> {
        let fqn = if self.current_path.is_empty() { name.to_string() } else { format!("{}.{}", self.current_path, name) };
        if self.symbols.types.contains_key(&fqn) {
            return Err(CompileError::DuplicateSymbol(fqn));
        }
        let qualified_fields = fields.iter()
            .map(|(field_name, field_type)| (field_name.clone(), self.qualify_type(field_type)))
            .collect::<Vec<_>>()
            .into_boxed_slice();
        let new_struct = Struct::new(
            self.current_path.clone().into(),
            name.to_string().into(),
            qualified_fields,
            attribs
        );
        self.symbols.types.insert(fqn, new_struct);
        Ok(())
    }
    fn collect_enum(&mut self, name: &str, base: &Option<ParserType>, entries: &[(String, Expr)], attributes: Box<[Attribute]>) -> CompileResult<()> {
        let fqn = if self.current_path.is_empty() { name.to_string() } else { format!("{}.{}", self.current_path, name) };
        if self.symbols.types.contains_key(&fqn) {
            return Err(CompileError::DuplicateSymbol(fqn));
        }
        if base.as_ref().map(|x| !x.is_integer()).unwrap_or(false) {
            return Err(CompileError::InvalidEnumBaseType(format!("Enum '{}' base type must be (un)signed integer", name)));
        }
        let new_enum = Enum::new(
            self.current_path.clone().into(),
            name.to_string().into(),
            base.as_ref().unwrap_or(&ParserType::Named(format!("i64"))).clone(),
            entries.iter().map(|x| (x.0.clone(), constant_integer_expression_compiler(&x.1, &self.symbols).unwrap())).collect::<Vec<_>>().into_boxed_slice(),
            attributes
        );
        self.symbols.enums.insert(fqn, new_enum);
        Ok(())
    }


    fn qualify_type(&self, ty: &ParserType) -> ParserType {
        if self.current_path.is_empty() {
            return ty.clone();
        }

        match ty {
            ParserType::Named(_) => {
                if ty.is_primitive_type() {
                    ty.clone()
                } else {
                    self.nest_type_in_namespace_path(&self.current_path, ty.clone())
                }
            }
            ParserType::Pointer(inner) => {
                ParserType::Pointer(Box::new(self.qualify_type(inner)))
            }
            ParserType::Function(ret_type, param_types) => {
                let qualified_ret = self.qualify_type(ret_type);
                let qualified_params = param_types.iter()
                    .map(|p| self.qualify_type(p))
                    .collect();
                ParserType::Function(Box::new(qualified_ret), qualified_params)
            }
            ParserType::NamespaceLink(_, _) => ty.clone(),
        }
    }
    fn nest_type_in_namespace_path(&self, path: &str, base_type: ParserType) -> ParserType {
        path.rsplit('.')
            .fold(base_type, |inner_type, path_part| {
                ParserType::NamespaceLink(path_part.to_string(), Box::new(inner_type))
            })
    }
}