define void @main(){
	ret void
}
define void @insert_symbol_into_table(ptr %a0, %struct.SymbolTableEntry %a1){
	br i1 %t555, label %l0, label %l1
l0:
	br label %l1
l1:
	ret void
}
define ptr @get_symbol_from_table(ptr %a0, %struct.PathEx %a1){
	br i1 %t555, label %l0, label %l1
l0:
	br label %l1
l1:
	ret %t555
}
define void @rcsharp_compile(ptr %a0, ptr %a1){
l0:
	br i1 %t555, label %l2, label %l1
l2:
	br label %l0
	br label %l1
l1:
	ret void
}
define void @debug_dump_type(ptr %a0, ptr %a1, ptr %a2){
	br i1 %t555, label %l0, label %l1
l0:
	br label %l2
l1:
	br i1 %t555, label %l0, label %l1
l0:
	br label %l2
l1:
	br i1 %t555, label %l0, label %l1
l0:
	br label %l2
l1:
	br i1 %t555, label %l0, label %l1
l0:
	br label %l2
l1:
	br i1 %t555, label %l0, label %l1
l0:
	br label %l2
l1:
	br i1 %t555, label %l0, label %l1
l0:
	br label %l1
l1:
	br label %l2
l2:
	br label %l2
l2:
	br label %l2
l2:
	br label %l2
l2:
	br label %l2
l2:
	ret void
}
define void @debug_dump_expression(ptr %a0, ptr %a1, ptr %a2){
	br i1 %t555, label %l0, label %l1
l0:
	ret void
	br label %l1
l1:
	br i1 %t555, label %l2, label %l3
l2:
	br i1 %t555, label %l2, label %l3
l2:
	br label %l4
l3:
	br i1 %t555, label %l2, label %l3
l2:
	br label %l3
l3:
	br label %l4
l4:
	ret void
	br label %l3
l3:
	br i1 %t555, label %l9, label %l10
l9:
	ret void
	br label %l10
l10:
	br i1 %t555, label %l11, label %l12
l11:
	ret void
	br label %l12
l12:
	br i1 %t555, label %l13, label %l14
l13:
	br i1 %t555, label %l13, label %l14
l13:
	br label %l14
l14:
	ret void
	br label %l14
l14:
	br i1 %t555, label %l17, label %l18
l17:
	ret void
	br label %l18
l18:
	br i1 %t555, label %l19, label %l20
l19:
	ret void
	br label %l20
l20:
	br i1 %t555, label %l21, label %l22
l21:
	ret void
	br label %l22
l22:
	br i1 %t555, label %l23, label %l24
l23:
	br i1 %t555, label %l23, label %l24
l23:
	br label %l25
l24:
	br label %l25
l25:
	ret void
	br label %l24
l24:
	br i1 %t555, label %l28, label %l29
l28:
	ret void
	br label %l29
l29:
	br i1 %t555, label %l30, label %l31
l30:
	br i1 %t555, label %l30, label %l31
l30:
	br label %l32
l31:
	br i1 %t555, label %l30, label %l31
l30:
	br label %l32
l31:
	br i1 %t555, label %l30, label %l31
l30:
	br label %l32
l31:
	br i1 %t555, label %l30, label %l31
l30:
	br label %l32
l31:
	br i1 %t555, label %l30, label %l31
l30:
	br label %l31
l31:
	br label %l32
l32:
	br label %l32
l32:
	br label %l32
l32:
	br label %l32
l32:
	ret void
	br label %l31
l31:
	br i1 %t555, label %l46, label %l47
l46:
	br i1 %t555, label %l46, label %l47
l46:
	br label %l47
l47:
	ret void
	br label %l47
l47:
	br i1 %t555, label %l50, label %l51
l50:
	ret void
	br label %l51
l51:
	br i1 %t555, label %l52, label %l53
l52:
	ret void
	br label %l53
l53:
	br i1 %t555, label %l54, label %l55
l54:
	ret void
	br label %l55
l55:
	ret void
}
define void @compile_internal_sym_table_prefill(ptr %a0, ptr %a1, ptr %a2, ptr %a3){
l0:
	br i1 %t555, label %l2, label %l1
l2:
	br i1 %t555, label %l3, label %l4
l3:
	br label %l5
l4:
	br i1 %t555, label %l3, label %l4
l3:
	br label %l0
	br label %l5
l4:
	br i1 %t555, label %l3, label %l4
l3:
	br i1 %t555, label %l3, label %l4
l3:
	br label %l5
l4:
	br label %l5
l5:
	br label %l0
	br label %l5
l4:
	br i1 %t555, label %l6, label %l7
l6:
	br i1 %t555, label %l6, label %l7
l6:
	br label %l8
l7:
	br label %l8
l8:
	br label %l0
	br label %l8
l7:
	br i1 %t555, label %l9, label %l10
l9:
	br label %l0
	br label %l11
l10:
	br i1 %t555, label %l9, label %l10
l9:
	br i1 %t555, label %l9, label %l10
l9:
	br label %l10
l10:
	br label %l0
	br label %l11
l10:
	br i1 %t555, label %l11, label %l12
l11:
	br i1 %t555, label %l11, label %l12
l11:
	br i1 %t555, label %l11, label %l12
l11:
	br label %l12
l12:
	br label %l13
l12:
	br i1 %t555, label %l13, label %l14
l13:
	br label %l15
l14:
	br i1 %t555, label %l13, label %l14
l13:
	br label %l14
l14:
	br label %l15
l15:
	br label %l13
l13:
	br label %l0
	br label %l12
l12:
	br label %l11
l11:
	br label %l11
l11:
	br label %l8
l8:
	br label %l5
l5:
	br label %l5
l5:
	br label %l5
l5:
	br label %l0
	br label %l1
l1:
	ret void
}
define void @compile_internal_sym_table(ptr %a0, ptr %a1, ptr %a2, ptr %a3){
l0:
	br i1 %t555, label %l2, label %l1
l2:
	br i1 %t555, label %l3, label %l4
l3:
	br label %l0
	br label %l5
l4:
	br i1 %t555, label %l3, label %l4
l3:
	br label %l0
	br label %l0
	br label %l5
l4:
	br i1 %t555, label %l3, label %l4
l3:
	br i1 %t555, label %l3, label %l4
l3:
	br i1 %t555, label %l3, label %l4
l3:
	br label %l5
l4:
	br label %l5
l5:
	br label %l0
	br label %l4
l4:
	br i1 %t555, label %l8, label %l9
l8:
	br label %l10
l9:
	br label %l10
l10:
	br label %l0
	br label %l5
l4:
	br i1 %t555, label %l11, label %l12
l11:
	br i1 %t555, label %l11, label %l12
l11:
	br label %l0
	br label %l12
l12:
	br label %l0
	br label %l13
l12:
	br i1 %t555, label %l13, label %l14
l13:
	br i1 %t555, label %l13, label %l14
l13:
	br label %l14
l14:
	br label %l0
	br label %l15
l14:
	br i1 %t555, label %l15, label %l16
l15:
	br i1 %t555, label %l15, label %l16
l15:
	br label %l16
l16:
	br label %l0
	br label %l17
l16:
	br i1 %t555, label %l17, label %l18
l17:
	br i1 %t555, label %l17, label %l18
l17:
	br label %l18
l18:
	br i1 %t555, label %l19, label %l20
l19:
	br label %l21
l20:
	br i1 %t555, label %l19, label %l20
l19:
	br i1 %t555, label %l19, label %l20
l19:
	br label %l20
l20:
	br label %l20
l20:
	br label %l21
l21:
	br label %l0
	br label %l18
l18:
	br label %l17
l17:
	br label %l15
l15:
	br label %l13
l13:
	br label %l5
l5:
	br label %l5
l5:
	br label %l5
l5:
	br label %l0
	br label %l1
l1:
	ret void
}
define void @compile_internals.sym_table_push_external(ptr %a0, ptr %a1){
	ret void
}
define void @compile_internals.sym_table_push_static(ptr %a0, ptr %a1){
	ret void
}
define void @compile_internals.sym_table_push_structs(ptr %a0, ptr %a1){
	ret void
}
define void @compile_internals.sym_table_push_structs_generic(ptr %a0, ptr %a1){
	ret void
}
define void @compile_internals.sym_table_push_functions(ptr %a0, ptr %a1){
	ret void
}
define void @compile_internals.compile_body(ptr %a0, i32 %a1, i32 %a2, ptr %a3, ptr %a4, ptr %a5){
l0:
	br i1 %t555, label %l2, label %l1
l2:
	br i1 %t555, label %l3, label %l4
l3:
	br label %l0
	br label %l4
l4:
	br i1 %t555, label %l5, label %l6
l5:
	br i1 %t555, label %l5, label %l6
l5:
	br label %l0
	br label %l6
l6:
	br label %l0
	br label %l6
l6:
	br i1 %t555, label %l9, label %l10
l9:
	br label %l0
	br label %l10
l10:
	br i1 %t555, label %l11, label %l12
l11:
	br i1 %t555, label %l11, label %l12
l11:
	br label %l12
l12:
	br label %l0
	br label %l12
l12:
	br i1 %t555, label %l15, label %l16
l15:
	br i1 %t555, label %l15, label %l16
l15:
	br label %l16
l16:
	br label %l0
	br label %l16
l16:
	br i1 %t555, label %l19, label %l20
l19:
	br label %l0
	br label %l20
l20:
	br i1 %t555, label %l21, label %l22
l21:
	br label %l0
	br label %l22
l22:
	br i1 %t555, label %l23, label %l24
l23:
	br label %l0
	br label %l24
l24:
	br i1 %t555, label %l25, label %l26
l25:
	br i1 %t555, label %l25, label %l26
l25:
	br label %l26
l26:
	br i1 %t555, label %l27, label %l28
l27:
	br label %l28
l28:
	br i1 %t555, label %l29, label %l30
l29:
	br label %l30
l30:
	br label %l0
	br label %l26
l26:
	br i1 %t555, label %l33, label %l34
l33:
	br label %l0
	br label %l34
l34:
	br label %l0
	br label %l0
	br label %l1
l1:
	ret void
}
define void @compile(ptr %a0, ptr %a1, ptr %a2){
	ret void
}
define void @debug_dump_symbol_table(ptr %a0, ptr %a1){
	ret void
}
define %struct.expression_compiler.Expected @expression_compiler.expect_nothing(){
	ret %t555
}
define %struct.expression_compiler.Expected @expression_compiler.expect_anything(){
	ret %t555
}
define %struct.expression_compiler.Expected @expression_compiler.expect_compiler_type(ptr %a0){
	ret %t555
}
define %struct.expression_compiler.CompiledValue @expression_compiler.cv_integer(i64 %a0){
	ret %t555
}
define i32 @expression_compiler.cv_to_register(ptr %a0, ptr %a1, ptr %a2, ptr %a3){
	ret %t555
}
define %struct.expression_compiler.CompiledValue @expression_compiler.compile(ptr %a0, %struct.expression_compiler.Expected %a1, ptr %a2, ptr %a3, ptr %a4){
	ret %t555
}
define %struct.rvalue.Rvalue @expression_compiler.constant_expression_evaluation(ptr %a0, ptr %a1){
	ret %t555
}
define %struct.scope.Scope @scope.new(){
	ret %t555
}
define void @scope.free(ptr %a0){
	ret void
}
define void @scope.add_to_scope(%struct.scope.Variable %a0, ptr %a1){
	ret void
}
define void @scope.enter_scope(ptr %a0){
	ret void
}
define void @scope.exit_scope(ptr %a0){
	br i1 %t555, label %l0, label %l1
l0:
	br label %l1
l1:
l2:
	br i1 %t555, label %l4, label %l3
l4:
	br label %l2
	br label %l3
l3:
	ret void
}
define ptr @scope.find_variable(i16 %a0, ptr %a1){
l0:
	br i1 %t555, label %l2, label %l1
l2:
	br i1 %t555, label %l3, label %l4
l3:
	ret %t555
	br label %l4
l4:
	br label %l0
	br label %l1
l1:
	ret %t555
}
define %struct.comp_type.CompilerType @comp_type.void(){
	ret void
}
define %struct.comp_type.CompilerType @comp_type.def_integer(){
	ret void
}
define %struct.comp_type.CompilerType @comp_type.primitive(ptr %a0){
	ret %t555
}
define %struct.comp_type.CompilerType @comp_type.structure(i32 %a0){
	ret %t555
}
define %struct.comp_type.CompilerType @comp_type.placeholder(i16 %a0){
	ret %t555
}
define %struct.comp_type.CompilerType @comp_type.implementation(i32 %a0, i32 %a1){
	ret %t555
}
define %struct.comp_type.CompilerType @comp_type.pointer(%struct.comp_type.CompilerType %a0, i8 %a1){
	ret %t555
}
define %struct.comp_type.CompilerType @comp_type.constant_array(%struct.comp_type.CompilerType %a0, i32 %a1){
	ret %t555
}
define %struct.comp_type.CompilerType @comp_type.get_compiler_type(ptr %a0, ptr %a1, ptr %a2){
	ret %t555
}
define i1 @comp_type.get_compiler_type_generic(ptr %a0, ptr %a1, ptr %a2, ptr %a3, ptr %a4){
	ret %t555
}
define %struct.comp_type.CompilerType @comp_type.get_compiler_type_internal(ptr %a0, ptr %a1, ptr %a2, ptr %a3){
	br i1 %t555, label %l0, label %l1
l0:
	br i1 %t555, label %l0, label %l1
l0:
	ret %t555
	br label %l1
l1:
	br i1 %t555, label %l2, label %l3
l2:
	br label %l3
l3:
	br i1 %t555, label %l4, label %l5
l4:
	ret %t555
	br label %l5
l5:
	ret %t555
	br label %l2
l1:
	br i1 %t555, label %l6, label %l7
l6:
	ret %t555
	br label %l8
l7:
	br i1 %t555, label %l6, label %l7
l6:
	ret %t555
	br label %l8
l7:
	br i1 %t555, label %l6, label %l7
l6:
	br i1 %t555, label %l6, label %l7
l6:
	br label %l7
l7:
	br i1 %t555, label %l8, label %l9
l8:
	br label %l9
l9:
	br i1 %t555, label %l10, label %l11
l10:
	br label %l11
l11:
	br i1 %t555, label %l12, label %l13
l12:
	br label %l14
l13:
	br label %l14
l14:
	ret %t555
	br label %l8
l7:
	br i1 %t555, label %l15, label %l16
l15:
	br i1 %t555, label %l15, label %l16
l15:
	br label %l16
l16:
	ret %t555
	br label %l16
l16:
	br label %l8
l8:
	br label %l8
l8:
	br label %l8
l8:
	br label %l2
l2:
	ret %t555
}
define i1 @comp_type.get_compiler_type_generic_internal(ptr %a0, ptr %a1, ptr %a2, ptr %a3, ptr %a4, ptr %a5){
	br i1 %t555, label %l0, label %l1
l0:
	br i1 %t555, label %l0, label %l1
l0:
	ret %t555
	br label %l1
l1:
	br i1 %t555, label %l2, label %l3
l2:
	br label %l3
l3:
	br i1 %t555, label %l4, label %l5
l4:
	ret %t555
	br label %l5
l5:
	ret %t555
	br label %l2
l1:
	br i1 %t555, label %l6, label %l7
l6:
	ret %t555
	br label %l8
l7:
	br i1 %t555, label %l6, label %l7
l6:
	ret %t555
	br label %l7
l7:
	br label %l8
l8:
	br label %l2
l2:
	ret %t555
}
define void @comp_type.compiler_type_push(ptr %a0, ptr %a1, ptr %a2, ptr %a3){
	ret void
}
define void @comp_type.compiler_type_push_internal(ptr %a0, ptr %a1, ptr %a2, ptr %a3, i1 %a4){
	br i1 %t555, label %l0, label %l1
l0:
	br label %l2
l1:
	br i1 %t555, label %l0, label %l1
l0:
	br i1 %t555, label %l0, label %l1
l0:
	br i1 %t555, label %l0, label %l1
l0:
	br label %l1
l1:
	br label %l2
l1:
	br i1 %t555, label %l2, label %l3
l2:
	br label %l4
l3:
	br label %l4
l4:
	br label %l2
l2:
	br label %l2
l1:
	br i1 %t555, label %l8, label %l9
l8:
	br label %l10
l9:
	br i1 %t555, label %l8, label %l9
l8:
	br i1 %t555, label %l8, label %l9
l8:
	br i1 %t555, label %l8, label %l9
l8:
	br label %l9
l9:
	br label %l10
l9:
	br label %l10
l10:
	br label %l10
l9:
	br i1 %t555, label %l13, label %l14
l13:
	br label %l14
l14:
	br label %l10
l10:
	br label %l10
l10:
	br label %l2
l2:
	br label %l2
l2:
	ret void
}
define i1 @comp_type.equal(ptr %a0, ptr %a1){
	br i1 %t555, label %l0, label %l1
l0:
	ret %t555
	br label %l1
l1:
	br i1 %t555, label %l2, label %l3
l2:
	ret %t555
	br label %l3
l3:
	ret %t555
}
define void @comp_type.free(ptr %a0){
	br i1 %t555, label %l0, label %l1
l0:
	br label %l1
l1:
	ret void
}
define %struct.rvalue.Rvalue @rvalue.register(i32 %a0){
	ret %t555
}
define %struct.rvalue.Rvalue @rvalue.integer(i64 %a0){
	ret %t555
}
define %struct.rvalue.Rvalue @rvalue.decimal(double %a0){
	ret %t555
}
define %struct.rvalue.Rvalue @rvalue.boolean(i1 %a0){
	ret %t555
}
define %struct.rvalue.Rvalue @rvalue.nil(){
	ret %t555
}
define %struct.rvalue.Rvalue @rvalue.void(){
	ret %t555
}
define %struct.layout.Layout @layout.invalid(){
	ret %t555
}
define %struct.layout.Layout @layout.void(){
	ret %t555
}
define %struct.layout.Layout @layout.one(){
	ret %t555
}
define %struct.layout.Layout @layout.two(){
	ret %t555
}
define %struct.layout.Layout @layout.four(){
	ret %t555
}
define %struct.layout.Layout @layout.eight(){
	ret %t555
}
define i1 @layout.equal(ptr %a0, ptr %a1){
	ret void
}
define void @layout.STATIC_layout(){
	ret void
}
define void @primitives.STATIC_primitives(){
	ret void
}
define ptr @primitives.find_primitive_type(ptr %a0, i32 %a1){
	br i1 %t555, label %l0, label %l1
l0:
	ret %t555
	br label %l1
l1:
	ret %t555
}
define i32 @primitives.find_primitive_type_index(ptr %a0, i32 %a1){
	br i1 %t555, label %l0, label %l1
l0:
	br i1 %t555, label %l0, label %l1
l0:
	ret %t555
	br label %l1
l1:
	br i1 %t555, label %l2, label %l3
l2:
	ret %t555
	br label %l3
l3:
	br label %l1
l1:
	br i1 %t555, label %l6, label %l7
l6:
	br i1 %t555, label %l6, label %l7
l6:
	ret %t555
	br label %l7
l7:
	br i1 %t555, label %l8, label %l9
l8:
	ret %t555
	br label %l9
l9:
	br i1 %t555, label %l10, label %l11
l10:
	ret %t555
	br label %l11
l11:
	br i1 %t555, label %l12, label %l13
l12:
	ret %t555
	br label %l13
l13:
	br i1 %t555, label %l14, label %l15
l14:
	ret %t555
	br label %l15
l15:
	br i1 %t555, label %l16, label %l17
l16:
	ret %t555
	br label %l17
l17:
	br i1 %t555, label %l18, label %l19
l18:
	ret %t555
	br label %l19
l19:
	br i1 %t555, label %l20, label %l21
l20:
	ret %t555
	br label %l21
l21:
	br i1 %t555, label %l22, label %l23
l22:
	ret %t555
	br label %l23
l23:
	br label %l7
l7:
	br i1 %t555, label %l26, label %l27
l26:
	br i1 %t555, label %l26, label %l27
l26:
	ret %t555
	br label %l27
l27:
	br i1 %t555, label %l28, label %l29
l28:
	ret %t555
	br label %l29
l29:
	br label %l27
l27:
	br i1 %t555, label %l32, label %l33
l32:
	br i1 %t555, label %l32, label %l33
l32:
	ret %t555
	br label %l33
l33:
	br i1 %t555, label %l34, label %l35
l34:
	ret %t555
	br label %l35
l35:
	br label %l33
l33:
	ret %t555
}
define void @output.push_instructions(ptr %a0, ptr %a1, ptr %a2){
	ret void
}
define void @output.push_instruction(ptr %a0, ptr %a1, ptr %a2){
	br i1 %t555, label %l0, label %l1
l0:
	br label %l2
l1:
	br i1 %t555, label %l0, label %l1
l0:
	br label %l2
l1:
	br i1 %t555, label %l0, label %l1
l0:
	br label %l2
l1:
	br i1 %t555, label %l0, label %l1
l0:
	br label %l2
l1:
	br i1 %t555, label %l0, label %l1
l0:
	br label %l2
l1:
	br i1 %t555, label %l0, label %l1
l0:
	br label %l2
l1:
	br i1 %t555, label %l0, label %l1
l0:
	br label %l1
l1:
	br label %l2
l2:
	br label %l2
l2:
	br label %l2
l2:
	br label %l2
l2:
	br label %l2
l2:
	br label %l2
l2:
	ret void
}
define %struct.output.LLVMInstruction @output.ret_void(){
	ret %t555
}
define %struct.output.LLVMInstruction @output.unreachable(){
	ret %t555
}
define %struct.output.LLVMInstruction @output.ret(i32 %a0){
	ret %t555
}
define %struct.output.LLVMInstruction @output.label(i32 %a0){
	ret %t555
}
define %struct.output.LLVMInstruction @output.jump_to(i32 %a0){
	ret %t555
}
define %struct.output.LLVMInstruction @output.branch(i32 %a0, i32 %a1, i32 %a2){
	ret %t555
}
define void @__chkstk(){
	ret void
}
define i32 @_fltused(){
	ret %t555
}
define %struct.string.String @process.get_executable_path(){
	ret %t555
}
define %struct.string.String @process.get_executable_env_path(){
l0:
	br i1 %t555, label %l2, label %l1
l2:
	br label %l0
	br label %l1
l1:
	ret %t555
}
define void @process.throw(ptr %a0){
	ret void
}
define ptr @mem.malloc(i64 %a0){
	br i1 %t555, label %l0, label %l1
l0:
	br label %l1
l1:
	ret %t555
}
define ptr @mem.realloc(ptr %a0, i64 %a1){
	br i1 %t555, label %l0, label %l1
l0:
	ret %t555
	br label %l1
l1:
	br i1 %t555, label %l2, label %l3
l2:
	br label %l3
l3:
	ret %t555
}
define void @mem.free(ptr %a0){
	br i1 %t555, label %l0, label %l1
l0:
	br label %l1
l1:
	ret void
}
define void @mem.copy(ptr %a0, ptr %a1, i64 %a2){
	ret void
}
define i32 @mem.compare(ptr %a0, ptr %a1, i64 %a2){
	ret %t555
}
define void @mem.fill(i8 %a0, ptr %a1, i64 %a2){
	ret void
}
define void @mem.zero_fill(ptr %a0, i64 %a1){
	ret void
}
define i64 @mem.get_total_allocated_memory_external(){
	br i1 %t555, label %l0, label %l1
l0:
	br label %l1
l1:
l2:
	br i1 %t555, label %l4, label %l3
l4:
	br i1 %t555, label %l5, label %l6
l5:
	br label %l6
l6:
	br label %l2
	br label %l3
l3:
	ret %t555
}
define ptr @console.get_stdout(){
	br i1 %t555, label %l0, label %l1
l0:
	br label %l1
l1:
	ret %t555
}
define void @console.write(ptr %a0, i32 %a1){
	br i1 %t555, label %l0, label %l1
l0:
	ret void
	br label %l1
l1:
	br i1 %t555, label %l2, label %l3
l2:
	br label %l3
l3:
	ret void
}
define void @console.write_string(ptr %a0){
	br i1 %t555, label %l0, label %l1
l0:
	ret void
	br label %l1
l1:
	br i1 %t555, label %l2, label %l3
l2:
	br label %l3
l3:
	ret void
}
define void @console.writeln(ptr %a0, i32 %a1){
	ret void
}
define void @console.print_char(i8 %a0){
	ret void
}
define void @console.println_i64(i64 %a0){
	br i1 %t555, label %l0, label %l1
l0:
	br label %l2
l1:
	br label %l2
l2:
	ret void
}
define void @console.println_u64(i64 %a0){
	br i1 %t555, label %l0, label %l1
l0:
	ret void
	br label %l1
l1:
l2:
l4:
	br i1 %t555, label %l4, label %l3
	br label %l2
	br label %l3
l3:
	ret void
}
define void @console.println_f64(double %a0){
	br i1 %t555, label %l0, label %l1
l0:
	br label %l1
l1:
	br i1 %t555, label %l2, label %l3
l2:
	br label %l4
l3:
l2:
l4:
	br i1 %t555, label %l4, label %l3
	br label %l2
	br label %l3
l3:
	br label %l4
l4:
	ret void
}
define %struct.string.String @string.from_data(ptr %a0, i32 %a1){
	br i1 %t555, label %l0, label %l1
l0:
	br label %l1
l1:
	ret %t555
}
define %struct.string.String @string.from_c_string(ptr %a0){
	ret %t555
}
define %struct.string.String @string.empty(){
	ret %t555
}
define %struct.string.String @string.with_size(i32 %a0){
	br i1 %t555, label %l0, label %l1
l0:
	br label %l1
l1:
	ret %t555
}
define %struct.string.String @string.clone(ptr %a0){
	ret %t555
}
define void @string.reserve(ptr %a0, i32 %a1){
	br i1 %t555, label %l0, label %l1
l0:
	ret void
	br label %l1
l1:
	br i1 %t555, label %l2, label %l3
l2:
	br label %l3
l3:
l4:
	br i1 %t555, label %l6, label %l5
l6:
	br label %l4
	br label %l5
l5:
	br i1 %t555, label %l7, label %l8
l7:
	br label %l8
l8:
	br i1 %t555, label %l9, label %l10
l9:
	br label %l10
l10:
	ret void
}
define %struct.string.String @string.append_c_string(ptr %a0, ptr %a1){
	br i1 %t555, label %l0, label %l1
l0:
	br label %l1
l1:
	br i1 %t555, label %l2, label %l3
l2:
	br label %l3
l3:
	ret %t555
}
define void @string.append_str(ptr %a0, ptr %a1, i32 %a2){
	br i1 %t555, label %l0, label %l1
l0:
	ret void
	br label %l1
l1:
	br i1 %t555, label %l2, label %l3
l2:
	ret void
	br label %l3
l3:
	ret void
}
define void @string.append(ptr %a0, i8 %a1){
	ret void
}
define void @string.append_u64(ptr %a0, i64 %a1){
	br i1 %t555, label %l0, label %l1
l0:
	ret void
	br label %l1
l1:
l2:
l4:
	br i1 %t555, label %l4, label %l3
	br label %l2
	br label %l3
l3:
	ret void
}
define i1 @string.equal(ptr %a0, ptr %a1){
	br i1 %t555, label %l0, label %l1
l0:
	ret %t555
	br label %l1
l1:
	br i1 %t555, label %l2, label %l3
l2:
	ret %t555
	br label %l3
l3:
	ret %t555
}
define void @string.free(ptr %a0){
	br i1 %t555, label %l0, label %l1
l0:
	br label %l1
l1:
	ret void
}
define void @string.as_c_string_stalloc(ptr %a0, ptr %a1){
	br i1 %t555, label %l0, label %l1
l0:
	br label %l1
l1:
	ret void
}
define i1 @char_utils.is_alnum(i8 %a0){
	ret void
}
define i1 @char_utils.is_alpha(i8 %a0){
	ret %t555
}
define i1 @char_utils.is_cntrl(i8 %a0){
	ret %t555
}
define i1 @char_utils.is_digit(i8 %a0){
	ret %t555
}
define i1 @char_utils.is_graph(i8 %a0){
	ret %t555
}
define i1 @char_utils.is_lower(i8 %a0){
	ret %t555
}
define i1 @char_utils.is_print(i8 %a0){
	ret %t555
}
define i1 @char_utils.is_punct(i8 %a0){
	ret %t555
}
define i1 @char_utils.is_space(i8 %a0){
	ret %t555
}
define i1 @char_utils.is_upper(i8 %a0){
	ret %t555
}
define i1 @char_utils.is_xdigit(i8 %a0){
	ret %t555
}
define i8 @char_utils.to_lower(i8 %a0){
	br i1 %t555, label %l0, label %l1
l0:
	ret %t555
	br label %l1
l1:
	ret %t555
}
define i8 @char_utils.to_upper(i8 %a0){
	br i1 %t555, label %l0, label %l1
l0:
	ret %t555
	br label %l1
l1:
	ret %t555
}
define ptr @string_utils.c_str_copy(ptr %a0, ptr %a1){
l0:
	br i1 %t555, label %l2, label %l1
l2:
	br label %l0
	br label %l1
l1:
	ret %t555
}
define ptr @string_utils.c_str_n_copy(ptr %a0, ptr %a1, i32 %a2){
l0:
	br i1 %t555, label %l2, label %l1
l2:
	br i1 %t555, label %l3, label %l4
l3:
	br label %l1
	br label %l4
l4:
	br label %l0
	br label %l1
l1:
l5:
	br i1 %t555, label %l7, label %l6
l7:
	br label %l5
	br label %l6
l6:
	ret %t555
}
define ptr @string_utils.insert(ptr %a0, ptr %a1, i32 %a2){
	ret %t555
}
define i32 @string_utils.c_str_len(ptr %a0){
l0:
	br i1 %t555, label %l2, label %l1
l2:
	br label %l0
	br label %l1
l1:
	ret %t555
}
define %struct.string.String @string_utils.u64_to_string(i64 %a0){
	br i1 %t555, label %l0, label %l1
l0:
	ret %t555
	br label %l1
l1:
l2:
l4:
	br i1 %t555, label %l4, label %l3
	br label %l2
	br label %l3
l3:
	ret %t555
}
define i32 @stdlib.atoi(ptr %a0){
l0:
	br i1 %t555, label %l2, label %l1
l2:
	br label %l0
	br label %l1
l1:
	br i1 %t555, label %l3, label %l4
l3:
	br label %l5
l4:
	br i1 %t555, label %l3, label %l4
l3:
	br label %l4
l4:
	br label %l5
l5:
l8:
	br i1 %t555, label %l10, label %l9
l10:
	br label %l8
	br label %l9
l9:
	ret %t555
}
define i64 @stdlib.str_to_l(ptr %a0, ptr %a1, i32 %a2){
l0:
	br i1 %t555, label %l2, label %l1
l2:
	br label %l0
	br label %l1
l1:
	br i1 %t555, label %l3, label %l4
l3:
	br label %l5
l4:
	br i1 %t555, label %l3, label %l4
l3:
	br label %l4
l4:
	br label %l5
l5:
	br i1 %t555, label %l8, label %l9
l8:
	br i1 %t555, label %l8, label %l9
l8:
	br i1 %t555, label %l8, label %l9
l8:
	br label %l10
l9:
	br label %l10
l10:
	br label %l10
l9:
	br label %l10
l10:
	br label %l9
l9:
	br i1 %t555, label %l16, label %l17
l16:
	br label %l17
l17:
l18:
	br i1 %t555, label %l20, label %l21
l20:
	br label %l22
l21:
	br i1 %t555, label %l20, label %l21
l20:
	br label %l22
l21:
	br label %l19
	br label %l22
l22:
	br label %l22
l22:
	br i1 %t555, label %l26, label %l27
l26:
	br label %l19
	br label %l27
l27:
	br label %l18
	br label %l19
l19:
	br i1 %t555, label %l28, label %l29
l28:
	br label %l29
l29:
	ret %t555
}
define void @stdlib.srand(i32 %a0){
	ret void
}
define i32 @stdlib.rand(){
	ret %t555
}
define i32 @fs.write_to_file(ptr %a0, ptr %a1, i32 %a2){
	br i1 %t555, label %l0, label %l1
l0:
	ret %t555
	br label %l1
l1:
	ret %t555
}
define %struct.string.String @fs.read_full_file_as_string_string(ptr %a0){
	ret %t555
}
define %struct.string.String @fs.read_full_file_as_string(ptr %a0){
	br i1 %t555, label %l0, label %l1
l0:
	br label %l1
l1:
	br i1 %t555, label %l2, label %l3
l2:
	ret %t555
	br label %l3
l3:
	br i1 %t555, label %l4, label %l5
l4:
	br label %l5
l5:
	ret %t555
}
define i32 @fs.create_file(ptr %a0){
	br i1 %t555, label %l0, label %l1
l0:
	ret %t555
	br label %l1
l1:
	ret %t555
}
define i32 @fs.delete_file(ptr %a0){
	ret %t555
}
define i1 @fs.file_exists(ptr %a0){
	ret %t555
}
define void @tests.run(){
	ret void
}
define void @tests.mem_test(){
	br i1 %t555, label %l0, label %l1
l0:
	br label %l1
l1:
	br i1 %t555, label %l2, label %l3
l2:
	br label %l3
l3:
	ret void
}
define void @tests.string_utils_test(){
	br i1 %t555, label %l0, label %l1
l0:
	br label %l1
l1:
	br i1 %t555, label %l2, label %l3
l2:
	br label %l3
l3:
	br i1 %t555, label %l4, label %l5
l4:
	br label %l5
l5:
	br i1 %t555, label %l6, label %l7
l6:
	br label %l7
l7:
	br i1 %t555, label %l8, label %l9
l8:
	br label %l9
l9:
l10:
	br i1 %t555, label %l12, label %l11
l12:
	br i1 %t555, label %l13, label %l14
l13:
	br label %l14
l14:
	br label %l10
	br label %l11
l11:
	ret void
}
define void @tests.string_test(){
	br i1 %t555, label %l0, label %l1
l0:
	br label %l1
l1:
	br i1 %t555, label %l2, label %l3
l2:
	br label %l3
l3:
	br i1 %t555, label %l4, label %l5
l4:
	br label %l5
l5:
	br i1 %t555, label %l6, label %l7
l6:
	br label %l7
l7:
	br i1 %t555, label %l8, label %l9
l8:
	br label %l9
l9:
	ret void
}
define void @tests.vector_test(){
	br i1 %t555, label %l0, label %l1
l0:
	br label %l1
l1:
	br i1 %t555, label %l2, label %l3
l2:
	br label %l3
l3:
	br i1 %t555, label %l4, label %l5
l4:
	br label %l5
l5:
	br i1 %t555, label %l6, label %l7
l6:
	br label %l7
l7:
	br i1 %t555, label %l8, label %l9
l8:
	br label %l9
l9:
	br i1 %t555, label %l10, label %l11
l10:
	br label %l11
l11:
	br i1 %t555, label %l12, label %l13
l12:
	br label %l13
l13:
	br i1 %t555, label %l14, label %l15
l14:
	br label %l15
l15:
	ret void
}
define void @tests.list_test(){
	br i1 %t555, label %l0, label %l1
l0:
	br label %l1
l1:
	br i1 %t555, label %l2, label %l3
l2:
	br label %l3
l3:
	br i1 %t555, label %l4, label %l5
l4:
	br label %l5
l5:
	br i1 %t555, label %l6, label %l7
l6:
	br label %l7
l7:
	br i1 %t555, label %l8, label %l9
l8:
	br label %l9
l9:
	br i1 %t555, label %l10, label %l11
l10:
	br label %l11
l11:
	br i1 %t555, label %l12, label %l13
l12:
	br label %l13
l13:
	br i1 %t555, label %l14, label %l15
l14:
	br label %l15
l15:
	ret void
}
define void @tests.process_test(){
	br i1 %t555, label %l0, label %l1
l0:
	br label %l1
l1:
	br i1 %t555, label %l2, label %l3
l2:
	br label %l3
l3:
	br i1 %t555, label %l4, label %l5
l4:
	br label %l5
l5:
	br i1 %t555, label %l6, label %l7
l6:
	br label %l7
l7:
	ret void
}
define void @tests.console_test(){
	ret void
}
define void @tests.fs_test(){
	br i1 %t555, label %l0, label %l1
l0:
	br label %l1
l1:
	ret void
}
define void @tests.consume_while(ptr %a0, ptr %a1, ptr %a2){
l0:
	br i1 %t555, label %l2, label %l1
l2:
	br i1 %t555, label %l3, label %l4
l3:
	br label %l5
l4:
	br label %l1
	br label %l5
l5:
	br label %l0
	br label %l1
l1:
	ret void
}
define i1 @tests.not_new_line(i8 %a0){
	ret %t555
}
define i1 @tests.valid_name_token(i8 %a0){
	ret %t555
}
define i1 @tests.is_valid_number_token(i8 %a0){
	ret %t555
}
define void @tests.funny(){
	br i1 %t555, label %l0, label %l1
l0:
	ret void
	br label %l1
l1:
	ret void
}
define i64 @window.WindowProc(ptr %a0, i32 %a1, i64 %a2, i64 %a3){
	br i1 %t555, label %l0, label %l1
l0:
	ret %t555
	br label %l1
l1:
	br i1 %t555, label %l2, label %l3
l2:
	ret %t555
	br label %l3
l3:
	br i1 %t555, label %l4, label %l5
l4:
	br i1 %t555, label %l4, label %l5
l4:
	ret %t555
	br label %l5
l5:
	br label %l5
l5:
	br i1 %t555, label %l8, label %l9
l8:
	ret %t555
	br label %l9
l9:
	br i1 %t555, label %l10, label %l11
l10:
	br i1 %t555, label %l10, label %l11
l10:
	ret %t555
	br label %l11
l11:
	ret %t555
	br label %l11
l11:
	br i1 %t555, label %l14, label %l15
l14:
	ret %t555
	br label %l15
l15:
	br i1 %t555, label %l16, label %l17
l16:
	br i1 %t555, label %l16, label %l17
l16:
	br label %l17
l17:
	ret %t555
	br label %l17
l17:
	ret %t555
}
define ptr @window.load_bitmap_from_file(ptr %a0){
	br i1 %t555, label %l0, label %l1
l0:
	br label %l1
l1:
	ret %t555
}
define void @window.get_bitmap_dimensions(ptr %a0, ptr %a1, ptr %a2){
	ret void
}
define void @window.draw_bitmap(ptr %a0, ptr %a1, i32 %a2, i32 %a3){
	br i1 %t555, label %l0, label %l1
l0:
	ret void
	br label %l1
l1:
	ret void
}
define void @window.draw_bitmap_stretched(ptr %a0, ptr %a1, i32 %a2, i32 %a3, i32 %a4, i32 %a5){
	br i1 %t555, label %l0, label %l1
l0:
	ret void
	br label %l1
l1:
	ret void
}
define i1 @window.is_null(ptr %a0){
	ret %t555
}
define void @window.start(){
	br i1 %t555, label %l0, label %l1
l0:
	br label %l1
l1:
	br i1 %t555, label %l2, label %l3
l2:
	br label %l3
l3:
	br i1 %t555, label %l4, label %l5
l4:
	br label %l5
l5:
l6:
	br i1 %t555, label %l8, label %l7
l8:
	br label %l6
	br label %l7
l7:
	ret void
}
define void @window.start_image_window(ptr %a0){
	br i1 %t555, label %l0, label %l1
l0:
	br label %l1
l1:
	br i1 %t555, label %l2, label %l3
l2:
	br label %l3
l3:
	br i1 %t555, label %l4, label %l5
l4:
	br label %l5
l5:
	br i1 %t555, label %l6, label %l7
l6:
	br label %l7
l7:
l8:
	br i1 %t555, label %l10, label %l9
l10:
	br label %l8
	br label %l9
l9:
	ret void
}
define i1 @is_modifier(i8 %a0){
	ret %t555
}
define %struct.string.String @token_type_to_string(ptr %a0, ptr %a1){
	br i1 %t555, label %l0, label %l1
l0:
	br i1 %t555, label %l0, label %l1
l0:
	ret %t555
	br label %l2
l1:
	br i1 %t555, label %l0, label %l1
l0:
	ret %t555
	br label %l2
l1:
	br i1 %t555, label %l0, label %l1
l0:
	ret %t555
	br label %l2
l1:
	br i1 %t555, label %l0, label %l1
l0:
	ret %t555
	br label %l2
l1:
	br i1 %t555, label %l0, label %l1
l0:
	ret %t555
	br label %l1
l1:
	br label %l2
l2:
	br label %l2
l2:
	br label %l2
l2:
	br label %l2
l2:
	br label %l2
l1:
	br i1 %t555, label %l14, label %l15
l14:
	ret %t555
	br label %l16
l15:
	br i1 %t555, label %l14, label %l15
l14:
	ret %t555
	br label %l16
l15:
	br i1 %t555, label %l14, label %l15
l14:
	ret %t555
	br label %l16
l15:
	br i1 %t555, label %l14, label %l15
l14:
	ret %t555
	br label %l16
l15:
	br i1 %t555, label %l14, label %l15
l14:
	ret %t555
	br label %l15
l15:
	br label %l16
l16:
	br label %l16
l16:
	br label %l16
l16:
	br label %l16
l16:
	br label %l2
l2:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l33
l32:
	br i1 %t555, label %l31, label %l32
l31:
	ret %t555
	br label %l32
l32:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	br label %l33
l33:
	ret %t555
}
define i16 @insert_symbol(ptr %a0, i32 %a1, ptr %a2){
	ret %t555
}
define void @handle_number(ptr %a0, i32 %a1, i32 %a2, ptr %a3, ptr %a4){
	ret void
}
define void @handle_decimal_number(ptr %a0, i32 %a1, i32 %a2, ptr %a3, ptr %a4){
	ret void
}
define void @handle_string(ptr %a0, i32 %a1, i32 %a2, ptr %a3, ptr %a4){
l0:
	br i1 %t555, label %l2, label %l1
l2:
	br i1 %t555, label %l3, label %l4
l3:
	br i1 %t555, label %l3, label %l4
l3:
	br label %l5
l4:
	br i1 %t555, label %l3, label %l4
l3:
	br label %l5
l4:
	br i1 %t555, label %l3, label %l4
l3:
	br label %l5
l4:
	br i1 %t555, label %l3, label %l4
l3:
	br label %l5
l4:
	br i1 %t555, label %l3, label %l4
l3:
	br label %l5
l4:
	br i1 %t555, label %l3, label %l4
l3:
	br label %l5
l4:
	br i1 %t555, label %l3, label %l4
l3:
	br label %l5
l4:
	br i1 %t555, label %l3, label %l4
l3:
	br label %l5
l4:
	br i1 %t555, label %l3, label %l4
l3:
	br label %l5
l4:
	br label %l5
l5:
	br label %l5
l5:
	br label %l5
l5:
	br label %l5
l5:
	br label %l5
l5:
	br label %l5
l5:
	br label %l5
l5:
	br label %l5
l5:
	br label %l5
l5:
	br label %l0
	br label %l4
l4:
	br label %l0
	br label %l1
l1:
	ret void
}
define void @handle_char(ptr %a0, i32 %a1, i32 %a2, ptr %a3, ptr %a4){
	br i1 %t555, label %l0, label %l1
l0:
	br i1 %t555, label %l0, label %l1
l0:
	br label %l2
l1:
	br i1 %t555, label %l0, label %l1
l0:
	br label %l2
l1:
	br i1 %t555, label %l0, label %l1
l0:
	br label %l2
l1:
	br i1 %t555, label %l0, label %l1
l0:
	br label %l2
l1:
	br i1 %t555, label %l0, label %l1
l0:
	br label %l2
l1:
	br i1 %t555, label %l0, label %l1
l0:
	br label %l2
l1:
	br i1 %t555, label %l0, label %l1
l0:
	br label %l2
l1:
	br i1 %t555, label %l0, label %l1
l0:
	br label %l2
l1:
	br label %l2
l2:
	br label %l2
l2:
	br label %l2
l2:
	br label %l2
l2:
	br label %l2
l2:
	br label %l2
l2:
	br label %l2
l2:
	br label %l2
l2:
	br i1 %t555, label %l24, label %l25
l24:
	br label %l25
l25:
	ret void
	br label %l1
l1:
	br i1 %t555, label %l28, label %l29
l28:
	br label %l29
l29:
	ret void
}
define void @handle_symbol(ptr %a0, i32 %a1, i32 %a2, ptr %a3, ptr %a4){
	br i1 %t555, label %l0, label %l1
l0:
	br i1 %t555, label %l0, label %l1
l0:
	ret void
	br label %l1
l1:
	br i1 %t555, label %l2, label %l3
l2:
	ret void
	br label %l3
l3:
	br i1 %t555, label %l4, label %l5
l4:
	ret void
	br label %l5
l5:
	br i1 %t555, label %l6, label %l7
l6:
	ret void
	br label %l7
l7:
	br i1 %t555, label %l8, label %l9
l8:
	ret void
	br label %l9
l9:
	br label %l2
l1:
	br i1 %t555, label %l10, label %l11
l10:
	br i1 %t555, label %l10, label %l11
l10:
	ret void
	br label %l11
l11:
	br i1 %t555, label %l12, label %l13
l12:
	ret void
	br label %l13
l13:
	br i1 %t555, label %l14, label %l15
l14:
	ret void
	br label %l15
l15:
	br label %l12
l11:
	br i1 %t555, label %l16, label %l17
l16:
	br i1 %t555, label %l16, label %l17
l16:
	ret void
	br label %l17
l17:
	br i1 %t555, label %l18, label %l19
l18:
	ret void
	br label %l19
l19:
	br i1 %t555, label %l20, label %l21
l20:
	ret void
	br label %l21
l21:
	br i1 %t555, label %l22, label %l23
l22:
	ret void
	br label %l23
l23:
	br i1 %t555, label %l24, label %l25
l24:
	ret void
	br label %l25
l25:
	br i1 %t555, label %l26, label %l27
l26:
	ret void
	br label %l27
l27:
	br i1 %t555, label %l28, label %l29
l28:
	ret void
	br label %l29
l29:
	br label %l18
l17:
	br i1 %t555, label %l30, label %l31
l30:
	br i1 %t555, label %l30, label %l31
l30:
	ret void
	br label %l31
l31:
	br i1 %t555, label %l32, label %l33
l32:
	ret void
	br label %l33
l33:
	br i1 %t555, label %l34, label %l35
l34:
	ret void
	br label %l35
l35:
	br i1 %t555, label %l36, label %l37
l36:
	ret void
	br label %l37
l37:
	br i1 %t555, label %l38, label %l39
l38:
	ret void
	br label %l39
l39:
	br i1 %t555, label %l40, label %l41
l40:
	ret void
	br label %l41
l41:
	br label %l32
l31:
	br i1 %t555, label %l42, label %l43
l42:
	br i1 %t555, label %l42, label %l43
l42:
	ret void
	br label %l43
l43:
	br i1 %t555, label %l44, label %l45
l44:
	ret void
	br label %l45
l45:
	br i1 %t555, label %l46, label %l47
l46:
	ret void
	br label %l47
l47:
	br i1 %t555, label %l48, label %l49
l48:
	ret void
	br label %l49
l49:
	br i1 %t555, label %l50, label %l51
l50:
	ret void
	br label %l51
l51:
	br label %l44
l43:
	br i1 %t555, label %l52, label %l53
l52:
	br i1 %t555, label %l52, label %l53
l52:
	ret void
	br label %l53
l53:
	br i1 %t555, label %l54, label %l55
l54:
	ret void
	br label %l55
l55:
	br label %l54
l53:
	br i1 %t555, label %l56, label %l57
l56:
	br i1 %t555, label %l56, label %l57
l56:
	ret void
	br label %l57
l57:
	br label %l57
l57:
	br label %l54
l54:
	br label %l44
l44:
	br label %l32
l32:
	br label %l18
l18:
	br label %l12
l12:
	br label %l2
l2:
	ret void
}
define void @lex(ptr %a0, ptr %a1, ptr %a2){
l0:
	br i1 %t555, label %l2, label %l1
l2:
	br i1 %t555, label %l3, label %l4
l3:
	br label %l0
	br label %l4
l4:
	br i1 %t555, label %l5, label %l6
l5:
	br label %l7
l6:
	br label %l7
l7:
	br i1 %t555, label %l8, label %l9
l8:
	br label %l10
l9:
	br label %l10
l10:
	br i1 %t555, label %l11, label %l12
l11:
l11:
	br i1 %t555, label %l13, label %l12
l13:
	br i1 %t555, label %l14, label %l15
l14:
	br label %l11
	br label %l15
l15:
	br label %l12
	br label %l11
	br label %l12
l12:
	br label %l0
	br label %l13
l12:
	br i1 %t555, label %l16, label %l17
l16:
	br i1 %t555, label %l16, label %l17
l16:
	br label %l17
l17:
	br i1 %t555, label %l18, label %l19
l18:
	br i1 %t555, label %l18, label %l19
l18:
	br label %l20
l19:
	br i1 %t555, label %l18, label %l19
l18:
	br label %l19
l19:
	br label %l20
l20:
	br label %l19
l19:
l25:
	br i1 %t555, label %l27, label %l26
l27:
	br i1 %t555, label %l28, label %l29
l28:
	br label %l25
	br label %l29
l29:
	br i1 %t555, label %l30, label %l31
l30:
	br i1 %t555, label %l30, label %l31
l30:
	br label %l25
	br label %l31
l31:
	br label %l31
l31:
	br label %l26
	br label %l25
	br label %l26
l26:
	br i1 %t555, label %l34, label %l35
l34:
	br label %l36
l35:
	br label %l36
l36:
	br label %l0
	br label %l18
l17:
	br i1 %t555, label %l37, label %l38
l37:
l37:
	br i1 %t555, label %l39, label %l38
l39:
	br i1 %t555, label %l40, label %l41
l40:
	br i1 %t555, label %l40, label %l41
l40:
	br label %l37
	br label %l42
l41:
	br label %l38
	br label %l42
l42:
	br label %l41
l41:
	br i1 %t555, label %l45, label %l46
l45:
	br label %l37
	br label %l46
l46:
	br i1 %t555, label %l47, label %l48
l47:
	br label %l48
l48:
	br label %l37
	br label %l37
	br label %l38
l38:
	br label %l0
	br label %l39
l38:
	br i1 %t555, label %l49, label %l50
l49:
l49:
	br i1 %t555, label %l51, label %l50
l51:
	br i1 %t555, label %l52, label %l53
l52:
	br i1 %t555, label %l52, label %l53
l52:
	br label %l49
	br label %l54
l53:
	br label %l50
	br label %l54
l54:
	br label %l53
l53:
	br i1 %t555, label %l57, label %l58
l57:
	br label %l49
	br label %l58
l58:
	br i1 %t555, label %l59, label %l60
l59:
	br label %l60
l60:
	br label %l49
	br label %l49
	br label %l50
l50:
	br label %l0
	br label %l51
l50:
	br i1 %t555, label %l61, label %l62
l61:
l61:
	br i1 %t555, label %l63, label %l62
l63:
	br i1 %t555, label %l64, label %l65
l64:
	br label %l62
	br label %l65
l65:
	br label %l61
	br label %l61
	br label %l62
l62:
	br label %l0
	br label %l63
l62:
	br i1 %t555, label %l66, label %l67
l66:
l66:
	br i1 %t555, label %l68, label %l67
l68:
	br i1 %t555, label %l69, label %l70
l69:
	br i1 %t555, label %l69, label %l70
l69:
	br label %l66
	br label %l70
l70:
	br i1 %t555, label %l71, label %l72
l71:
	br i1 %t555, label %l71, label %l72
l71:
	br label %l67
	br label %l72
l72:
	br label %l66
	br label %l72
l72:
	br label %l70
l70:
	br label %l66
	br label %l67
l67:
	br label %l0
	br label %l67
l67:
	br label %l63
l63:
	br label %l51
l51:
	br label %l39
l39:
	br label %l18
l18:
	br label %l13
l13:
	br i1 %t555, label %l94, label %l95
l94:
	br label %l96
l95:
	br i1 %t555, label %l94, label %l95
l94:
	br label %l96
l95:
	br i1 %t555, label %l94, label %l95
l94:
	br label %l96
l95:
	br i1 %t555, label %l94, label %l95
l94:
	br label %l96
l95:
	br i1 %t555, label %l94, label %l95
l94:
	br label %l96
l95:
	br i1 %t555, label %l94, label %l95
l94:
	br label %l96
l95:
	br i1 %t555, label %l94, label %l95
l94:
	br label %l96
l95:
	br i1 %t555, label %l94, label %l95
l94:
	br i1 %t555, label %l94, label %l95
l94:
	br label %l96
l95:
	br label %l96
l96:
	br label %l96
l95:
	br i1 %t555, label %l97, label %l98
l97:
	br i1 %t555, label %l97, label %l98
l97:
	br label %l99
l98:
	br i1 %t555, label %l97, label %l98
l97:
	br label %l99
l98:
	br label %l99
l99:
	br label %l99
l99:
	br label %l99
l98:
	br i1 %t555, label %l103, label %l104
l103:
	br label %l105
l104:
	br i1 %t555, label %l103, label %l104
l103:
	br label %l105
l104:
	br i1 %t555, label %l103, label %l104
l103:
	br label %l105
l104:
	br i1 %t555, label %l103, label %l104
l103:
	br label %l105
l104:
	br i1 %t555, label %l103, label %l104
l103:
	br label %l105
l104:
	br i1 %t555, label %l103, label %l104
l103:
	br label %l105
l104:
	br i1 %t555, label %l103, label %l104
l103:
	br label %l105
l104:
	br i1 %t555, label %l103, label %l104
l103:
	br i1 %t555, label %l103, label %l104
l103:
	br label %l105
l104:
	br label %l105
l105:
	br label %l105
l104:
	br i1 %t555, label %l106, label %l107
l106:
	br i1 %t555, label %l106, label %l107
l106:
	br label %l108
l107:
	br label %l108
l108:
	br label %l108
l107:
	br i1 %t555, label %l109, label %l110
l109:
	br i1 %t555, label %l109, label %l110
l109:
	br label %l111
l110:
	br label %l111
l111:
	br label %l111
l110:
	br i1 %t555, label %l112, label %l113
l112:
	br i1 %t555, label %l112, label %l113
l112:
	br i1 %t555, label %l112, label %l113
l112:
	br label %l114
l113:
	br label %l114
l114:
	br label %l114
l113:
	br label %l114
l114:
	br label %l114
l113:
	br i1 %t555, label %l118, label %l119
l118:
	br i1 %t555, label %l118, label %l119
l118:
	br label %l120
l119:
	br label %l120
l120:
	br label %l120
l119:
	br i1 %t555, label %l121, label %l122
l121:
	br i1 %t555, label %l121, label %l122
l121:
	br label %l123
l122:
	br label %l123
l123:
	br label %l123
l122:
	br i1 %t555, label %l124, label %l125
l124:
	br label %l126
l125:
	br i1 %t555, label %l124, label %l125
l124:
	br label %l125
l125:
	br label %l126
l126:
	br label %l123
l123:
	br label %l120
l120:
	br label %l114
l114:
	br label %l111
l111:
	br label %l108
l108:
	br label %l105
l105:
	br label %l105
l105:
	br label %l105
l105:
	br label %l105
l105:
	br label %l105
l105:
	br label %l105
l105:
	br label %l105
l105:
	br label %l105
l105:
	br label %l99
l99:
	br label %l96
l96:
	br label %l96
l96:
	br label %l96
l96:
	br label %l96
l96:
	br label %l96
l96:
	br label %l96
l96:
	br label %l96
l96:
	br label %l96
l96:
	br i1 %t555, label %l195, label %l196
l195:
	br label %l0
	br label %l196
l196:
	br label %l0
	br label %l1
l1:
	ret void
}
define i1 @is_prefix_operator(i8 %a0){
	ret %t555
}
define i8 @precedence(i8 %a0){
	br i1 %t555, label %l0, label %l1
l0:
	ret %t555
	br label %l1
l1:
	br i1 %t555, label %l2, label %l3
l2:
	ret %t555
	br label %l3
l3:
	br i1 %t555, label %l4, label %l5
l4:
	ret %t555
	br label %l5
l5:
	br i1 %t555, label %l6, label %l7
l6:
	ret %t555
	br label %l7
l7:
	br i1 %t555, label %l8, label %l9
l8:
	ret %t555
	br label %l9
l9:
	br i1 %t555, label %l10, label %l11
l10:
	ret %t555
	br label %l11
l11:
	br i1 %t555, label %l12, label %l13
l12:
	ret %t555
	br label %l13
l13:
	br i1 %t555, label %l14, label %l15
l14:
	ret %t555
	br label %l15
l15:
	br i1 %t555, label %l16, label %l17
l16:
	ret %t555
	br label %l17
l17:
	br i1 %t555, label %l18, label %l19
l18:
	ret %t555
	br label %l19
l19:
	br i1 %t555, label %l20, label %l21
l20:
	ret %t555
	br label %l21
l21:
	br i1 %t555, label %l22, label %l23
l22:
	ret %t555
	br label %l23
l23:
	br i1 %t555, label %l24, label %l25
l24:
	ret %t555
	br label %l25
l25:
	br i1 %t555, label %l26, label %l27
l26:
	ret %t555
	br label %l27
l27:
	ret %t555
}
define i8 @get_unary_op(i8 %a0){
	br i1 %t555, label %l0, label %l1
l0:
	ret %t555
	br label %l1
l1:
	br i1 %t555, label %l2, label %l3
l2:
	ret %t555
	br label %l3
l3:
	br i1 %t555, label %l4, label %l5
l4:
	ret %t555
	br label %l5
l5:
	br i1 %t555, label %l6, label %l7
l6:
	ret %t555
	br label %l7
l7:
	br i1 %t555, label %l8, label %l9
l8:
	ret %t555
	br label %l9
l9:
	ret %t555
}
define i8 @get_binary_op(i8 %a0){
	br i1 %t555, label %l0, label %l1
l0:
	ret %t555
	br label %l1
l1:
	br i1 %t555, label %l2, label %l3
l2:
	ret %t555
	br label %l3
l3:
	br i1 %t555, label %l4, label %l5
l4:
	ret %t555
	br label %l5
l5:
	br i1 %t555, label %l6, label %l7
l6:
	ret %t555
	br label %l7
l7:
	br i1 %t555, label %l8, label %l9
l8:
	ret %t555
	br label %l9
l9:
	br i1 %t555, label %l10, label %l11
l10:
	ret %t555
	br label %l11
l11:
	br i1 %t555, label %l12, label %l13
l12:
	ret %t555
	br label %l13
l13:
	br i1 %t555, label %l14, label %l15
l14:
	ret %t555
	br label %l15
l15:
	br i1 %t555, label %l16, label %l17
l16:
	ret %t555
	br label %l17
l17:
	br i1 %t555, label %l18, label %l19
l18:
	ret %t555
	br label %l19
l19:
	br i1 %t555, label %l20, label %l21
l20:
	ret %t555
	br label %l21
l21:
	br i1 %t555, label %l22, label %l23
l22:
	ret %t555
	br label %l23
l23:
	br i1 %t555, label %l24, label %l25
l24:
	ret %t555
	br label %l25
l25:
	br i1 %t555, label %l26, label %l27
l26:
	ret %t555
	br label %l27
l27:
	br i1 %t555, label %l28, label %l29
l28:
	ret %t555
	br label %l29
l29:
	br i1 %t555, label %l30, label %l31
l30:
	ret %t555
	br label %l31
l31:
	br i1 %t555, label %l32, label %l33
l32:
	ret %t555
	br label %l33
l33:
	br i1 %t555, label %l34, label %l35
l34:
	ret %t555
	br label %l35
l35:
	br i1 %t555, label %l36, label %l37
l36:
	ret %t555
	br label %l37
l37:
	ret %t555
}
define %struct.Expression @parse_expression_internal(ptr %a0, ptr %a1, i32 %a2, i8 %a3){
	br i1 %t555, label %l0, label %l1
l0:
	br label %l1
l1:
	br i1 %t555, label %l2, label %l3
l2:
	br label %l4
l3:
	br i1 %t555, label %l2, label %l3
l2:
	br label %l4
l3:
	br i1 %t555, label %l2, label %l3
l2:
	br label %l4
l3:
	br i1 %t555, label %l2, label %l3
l2:
	br label %l4
l3:
	br i1 %t555, label %l2, label %l3
l2:
	br label %l4
l3:
	br i1 %t555, label %l2, label %l3
l2:
	br label %l4
l3:
	br i1 %t555, label %l2, label %l3
l2:
	br label %l4
l3:
	br i1 %t555, label %l2, label %l3
l2:
	br label %l4
l3:
	br i1 %t555, label %l2, label %l3
l2:
l2:
	br i1 %t555, label %l4, label %l3
l4:
	br i1 %t555, label %l5, label %l6
l5:
	br label %l7
l6:
	br i1 %t555, label %l5, label %l6
l5:
	br label %l6
l6:
	br label %l7
l7:
	br label %l2
	br label %l3
l3:
	br label %l4
l3:
	br i1 %t555, label %l10, label %l11
l10:
	br label %l12
l11:
	br i1 %t555, label %l10, label %l11
l10:
	br label %l12
l11:
	br label %l12
l12:
	br label %l12
l12:
	br label %l4
l4:
	br label %l4
l4:
	br label %l4
l4:
	br label %l4
l4:
	br label %l4
l4:
	br label %l4
l4:
	br label %l4
l4:
	br label %l4
l4:
	br label %l4
l4:
l43:
	br i1 %t555, label %l45, label %l44
l45:
	br i1 %t555, label %l46, label %l47
l46:
	br label %l44
	br label %l47
l47:
	br i1 %t555, label %l48, label %l49
l48:
	br label %l50
l49:
	br i1 %t555, label %l48, label %l49
l48:
	br label %l49
l49:
	br label %l50
l50:
	br i1 %t555, label %l53, label %l54
l53:
	br label %l44
	br label %l54
l54:
	br i1 %t555, label %l55, label %l56
l55:
	br label %l56
l56:
	br i1 %t555, label %l57, label %l58
l57:
l57:
	br i1 %t555, label %l59, label %l58
l59:
	br i1 %t555, label %l60, label %l61
l60:
	br label %l62
l61:
	br i1 %t555, label %l60, label %l61
l60:
	br label %l61
l61:
	br label %l62
l62:
	br label %l57
	br label %l58
l58:
	br label %l59
l58:
	br i1 %t555, label %l65, label %l66
l65:
	br label %l67
l66:
	br i1 %t555, label %l65, label %l66
l65:
	br i1 %t555, label %l65, label %l66
l65:
l65:
	br i1 %t555, label %l67, label %l66
l67:
	br i1 %t555, label %l68, label %l69
l68:
	br label %l70
l69:
	br i1 %t555, label %l68, label %l69
l68:
	br label %l69
l69:
	br label %l70
l70:
	br label %l65
	br label %l66
l66:
	br label %l67
l66:
	br i1 %t555, label %l73, label %l74
l73:
l73:
	br i1 %t555, label %l75, label %l74
l75:
	br i1 %t555, label %l76, label %l77
l76:
	br label %l78
l77:
	br i1 %t555, label %l76, label %l77
l76:
	br label %l77
l77:
	br label %l78
l78:
	br label %l73
	br label %l74
l74:
	br label %l75
l74:
	br i1 %t555, label %l81, label %l82
l81:
	br label %l82
l82:
	br label %l75
l75:
	br label %l67
l67:
	br label %l67
l66:
	br i1 %t555, label %l89, label %l90
l89:
	br i1 %t555, label %l89, label %l90
l89:
	br label %l90
l90:
	br label %l91
l90:
	br i1 %t555, label %l91, label %l92
l91:
	br label %l93
l92:
	br i1 %t555, label %l91, label %l92
l91:
	br label %l93
l92:
	br i1 %t555, label %l91, label %l92
l91:
	br label %l92
l92:
	br label %l93
l93:
	br label %l93
l93:
	br label %l91
l91:
	br label %l67
l67:
	br label %l67
l67:
	br label %l59
l59:
	br label %l43
	br label %l44
l44:
	ret %t555
}
define %struct.Expression @parse_expression(ptr %a0, ptr %a1, i32 %a2){
	ret %t555
}
define %struct.vector.Vec.struct.Expression @parse_expression_comma(ptr %a0, ptr %a1, i32 %a2){
l0:
	br i1 %t555, label %l2, label %l1
l2:
	br i1 %t555, label %l3, label %l4
l3:
	br label %l5
l4:
	br label %l1
	br label %l5
l5:
	br label %l0
	br label %l1
l1:
	ret %t555
}
define %struct.PathEx @path_to_path_ex(ptr %a0){
	ret %t555
}
define %struct.PathEx @path_to_path_ex_name(ptr %a0, i16 %a1){
	ret %t555
}
define void @append_path(ptr %a0, ptr %a1, ptr %a2){
	ret void
}
define void @append_path_ex(ptr %a0, ptr %a1, ptr %a2){
	ret void
}
define %struct.Type @wrap_in_pointers(%struct.Type %a0, i32 %a1){
	br i1 %t555, label %l0, label %l1
l0:
	ret %t555
	br label %l1
l1:
	br i1 %t555, label %l2, label %l3
l2:
	br label %l3
l3:
	ret %t555
}
define %struct.vector.Vec.struct.Type @parse_generic_args(ptr %a0, ptr %a1, i32 %a2){
l0:
	br i1 %t555, label %l2, label %l1
l2:
	br i1 %t555, label %l3, label %l4
l3:
	br label %l1
	br label %l4
l4:
	br i1 %t555, label %l5, label %l6
l5:
	br label %l6
l6:
	br i1 %t555, label %l7, label %l8
l7:
	br label %l8
l8:
	br i1 %t555, label %l9, label %l10
l9:
	br i1 %t555, label %l9, label %l10
l9:
	br label %l10
l10:
	br i1 %t555, label %l11, label %l12
l11:
	br label %l1
	br label %l12
l12:
	br label %l10
l10:
	br label %l0
	br label %l1
l1:
	ret %t555
}
define %struct.vector.Vec.struct.Type @parse_types_comma(ptr %a0, ptr %a1, i32 %a2, i8 %a3){
l0:
	br i1 %t555, label %l2, label %l1
l2:
	br i1 %t555, label %l3, label %l4
l3:
	br i1 %t555, label %l3, label %l4
l3:
	br label %l1
	br label %l4
l4:
	br label %l5
l4:
	br label %l1
	br label %l5
l5:
	br label %l0
	br label %l1
l1:
	ret %t555
}
define %struct.Type @parse_type_internal(ptr %a0, ptr %a1, i32 %a2){
l0:
	br i1 %t555, label %l2, label %l1
l2:
	br i1 %t555, label %l3, label %l4
l3:
	br label %l5
l4:
	br i1 %t555, label %l3, label %l4
l3:
	br label %l5
l4:
	br label %l1
	br label %l5
l5:
	br label %l5
l5:
	br label %l0
	br label %l1
l1:
	br i1 %t555, label %l9, label %l10
l9:
	br label %l10
l10:
	br i1 %t555, label %l11, label %l12
l11:
	br label %l13
l12:
	br i1 %t555, label %l11, label %l12
l11:
	br label %l13
l12:
	br i1 %t555, label %l11, label %l12
l11:
l11:
	br i1 %t555, label %l13, label %l12
l13:
	br i1 %t555, label %l14, label %l15
l14:
	br label %l15
l15:
	br i1 %t555, label %l16, label %l17
l16:
	br i1 %t555, label %l16, label %l17
l16:
	br label %l17
l17:
	br label %l18
l17:
	br label %l12
	br label %l18
l18:
	br label %l11
	br label %l12
l12:
	br i1 %t555, label %l21, label %l22
l21:
	br label %l23
l22:
	br label %l23
l23:
	br i1 %t555, label %l24, label %l25
l24:
	br label %l26
l25:
	br label %l26
l26:
	br label %l13
l12:
	br label %l13
l13:
	br label %l13
l13:
	br label %l13
l13:
	ret %t555
}
define %struct.Type @parse_type(ptr %a0, ptr %a1, i32 %a2){
	ret %t555
}
define %struct.vector.Vec.struct.Type @parse_types_comma_rparen(ptr %a0, ptr %a1, i32 %a2){
	ret %t555
}
define void @free_type(%struct.Type %a0){
	ret void
}
define void @expect(ptr %a0, ptr %a1, i32 %a2, i8 %a3, ptr %a4){
	br i1 %t555, label %l0, label %l1
l0:
	br label %l1
l1:
	ret void
}
define void @skip_nested(ptr %a0, ptr %a1, i32 %a2, i8 %a3, i8 %a4){
	br i1 %t555, label %l0, label %l1
l0:
	ret void
	br label %l1
l1:
l2:
	br i1 %t555, label %l4, label %l3
l4:
	br i1 %t555, label %l5, label %l6
l5:
	br label %l7
l6:
	br i1 %t555, label %l5, label %l6
l5:
	br label %l6
l6:
	br label %l7
l7:
	br label %l2
	br label %l3
l3:
	ret void
}
define void @skip_if_statement(ptr %a0, ptr %a1, i32 %a2){
l0:
	br i1 %t555, label %l2, label %l1
l2:
	br label %l0
	br label %l1
l1:
	br i1 %t555, label %l3, label %l4
l3:
	br i1 %t555, label %l3, label %l4
l3:
	br label %l5
l4:
	br i1 %t555, label %l3, label %l4
l3:
	br label %l4
l4:
	br label %l5
l5:
	br label %l4
l4:
	ret void
}
define %struct.vector.Vec.struct.Argument @parse_argument_comma(ptr %a0, ptr %a1, i32 %a2){
l0:
	br i1 %t555, label %l2, label %l1
l2:
	br i1 %t555, label %l3, label %l4
l3:
	br label %l4
l4:
	br i1 %t555, label %l5, label %l6
l5:
	br label %l6
l6:
	br i1 %t555, label %l7, label %l8
l7:
	br label %l9
l8:
	br i1 %t555, label %l7, label %l8
l7:
	br label %l8
l8:
	br label %l9
l9:
	br label %l0
	br label %l1
l1:
	ret %t555
}
define %struct.vector.Vec.i16 @parse_generic_params(ptr %a0, ptr %a1, i32 %a2){
	br i1 %t555, label %l0, label %l1
l0:
l0:
	br i1 %t555, label %l2, label %l1
l2:
	br i1 %t555, label %l3, label %l4
l3:
	br label %l5
l4:
	br i1 %t555, label %l3, label %l4
l3:
	br label %l5
l4:
	br label %l5
l5:
	br label %l5
l5:
	br label %l0
	br label %l1
l1:
	br label %l1
l1:
	ret %t555
}
define %struct.vector.Vec.struct.Argument @parse_struct_fields(ptr %a0, ptr %a1, i32 %a2){
l0:
	br i1 %t555, label %l2, label %l1
l2:
	br i1 %t555, label %l3, label %l4
l3:
	br label %l4
l4:
	br i1 %t555, label %l5, label %l6
l5:
	br label %l7
l6:
	br i1 %t555, label %l5, label %l6
l5:
	br label %l6
l6:
	br label %l7
l7:
	br label %l0
	br label %l1
l1:
	ret %t555
}
define %struct.vector.Vec.struct.EnumField @parse_enum_fields(ptr %a0, ptr %a1, i32 %a2){
l0:
	br i1 %t555, label %l2, label %l1
l2:
	br i1 %t555, label %l3, label %l4
l3:
	br label %l4
l4:
	br i1 %t555, label %l5, label %l6
l5:
	br label %l7
l6:
	br label %l7
l7:
	br i1 %t555, label %l8, label %l9
l8:
	br label %l10
l9:
	br i1 %t555, label %l8, label %l9
l8:
	br label %l9
l9:
	br label %l10
l10:
	br label %l0
	br label %l1
l1:
	ret %t555
}
define i1 @is_expression_starter(i8 %a0){
	br i1 %t555, label %l0, label %l1
l0:
	ret %t555
	br label %l1
l1:
	ret %t555
}
define void @parse_body(ptr %a0, i32 %a1, ptr %a2, ptr %a3){
	br i1 %t555, label %l0, label %l1
l0:
	ret void
	br label %l1
l1:
l2:
	br i1 %t555, label %l4, label %l3
l4:
	br i1 %t555, label %l5, label %l6
l5:
	br i1 %t555, label %l5, label %l6
l5:
	br label %l2
	br label %l6
l6:
	br label %l2
	br label %l6
l6:
	br i1 %t555, label %l9, label %l10
l9:
	br i1 %t555, label %l9, label %l10
l9:
	br label %l10
l10:
	br i1 %t555, label %l11, label %l12
l11:
	br label %l13
l12:
	br i1 %t555, label %l11, label %l12
l11:
	br label %l12
l12:
	br label %l13
l13:
	br label %l2
	br label %l10
l10:
	br i1 %t555, label %l18, label %l19
l18:
	br label %l2
	br label %l19
l19:
	br i1 %t555, label %l20, label %l21
l20:
	br label %l2
	br label %l21
l21:
	br i1 %t555, label %l22, label %l23
l22:
	br i1 %t555, label %l22, label %l23
l22:
	br label %l23
l23:
	br i1 %t555, label %l24, label %l25
l24:
	br i1 %t555, label %l24, label %l25
l24:
	br label %l26
l25:
	br i1 %t555, label %l24, label %l25
l24:
	br label %l25
l25:
	br label %l26
l26:
	br label %l25
l25:
	br label %l2
	br label %l23
l23:
	br i1 %t555, label %l33, label %l34
l33:
	br i1 %t555, label %l33, label %l34
l33:
	br label %l34
l34:
	br label %l2
	br label %l34
l34:
	br i1 %t555, label %l37, label %l38
l37:
	br i1 %t555, label %l37, label %l38
l37:
	br label %l38
l38:
	br label %l2
	br label %l38
l38:
	br i1 %t555, label %l41, label %l42
l41:
	br i1 %t555, label %l41, label %l42
l41:
	br label %l42
l42:
	br label %l2
	br label %l42
l42:
	br i1 %t555, label %l45, label %l46
l45:
	br i1 %t555, label %l45, label %l46
l45:
	br label %l46
l46:
	br label %l2
	br label %l46
l46:
	br i1 %t555, label %l49, label %l50
l49:
	br label %l2
	br label %l50
l50:
	br label %l2
	br label %l3
l3:
	ret void
}
define i8 @get_flags(ptr %a0, i32 %a1, i32 %a2){
	br i1 %t555, label %l0, label %l1
l0:
	ret %t555
	br label %l1
l1:
	ret %t555
}
define void @parse(ptr %a0, i32 %a1, ptr %a2, ptr %a3){
	br i1 %t555, label %l0, label %l1
l0:
	ret void
	br label %l1
l1:
l2:
	br i1 %t555, label %l4, label %l3
l4:
	br i1 %t555, label %l5, label %l6
l5:
	br i1 %t555, label %l5, label %l6
l5:
	br label %l6
l6:
	br label %l2
	br label %l6
l6:
	br i1 %t555, label %l9, label %l10
l9:
	br i1 %t555, label %l9, label %l10
l9:
	br label %l10
l10:
	br i1 %t555, label %l11, label %l12
l11:
	br label %l12
l12:
	br i1 %t555, label %l13, label %l14
l13:
	br label %l14
l14:
	br i1 %t555, label %l15, label %l16
l15:
	br label %l16
l16:
	br label %l2
	br label %l10
l10:
	br i1 %t555, label %l19, label %l20
l19:
	br i1 %t555, label %l19, label %l20
l19:
	br label %l20
l20:
	br i1 %t555, label %l21, label %l22
l21:
	br label %l22
l22:
	br i1 %t555, label %l23, label %l24
l23:
l23:
	br i1 %t555, label %l25, label %l24
l25:
	br i1 %t555, label %l26, label %l27
l26:
	br label %l28
l27:
	br label %l28
l28:
	br i1 %t555, label %l29, label %l30
l29:
	br label %l30
l30:
	br label %l23
	br label %l24
l24:
	br label %l24
l24:
	br i1 %t555, label %l33, label %l34
l33:
	br label %l34
l34:
	br i1 %t555, label %l35, label %l36
l35:
	br label %l36
l36:
	br i1 %t555, label %l37, label %l38
l37:
	br label %l39
l38:
	br i1 %t555, label %l37, label %l38
l37:
	br label %l39
l38:
	br i1 %t555, label %l37, label %l38
l37:
	br label %l38
l38:
	br label %l39
l39:
	br label %l39
l39:
	br label %l2
	br label %l20
l20:
	br i1 %t555, label %l47, label %l48
l47:
	br i1 %t555, label %l47, label %l48
l47:
	br label %l48
l48:
	br i1 %t555, label %l49, label %l50
l49:
	br label %l51
l50:
	br label %l51
l51:
	br label %l2
	br label %l48
l48:
	br i1 %t555, label %l54, label %l55
l54:
	br i1 %t555, label %l54, label %l55
l54:
	br label %l55
l55:
	br i1 %t555, label %l56, label %l57
l56:
	br label %l57
l57:
	br i1 %t555, label %l58, label %l59
l58:
	br label %l60
l59:
	br label %l60
l60:
	br label %l2
	br label %l55
l55:
	br i1 %t555, label %l63, label %l64
l63:
	br i1 %t555, label %l63, label %l64
l63:
	br label %l64
l64:
	br i1 %t555, label %l65, label %l66
l65:
	br label %l66
l66:
	br i1 %t555, label %l67, label %l68
l67:
	br label %l69
l68:
	br label %l69
l69:
	br label %l2
	br label %l64
l64:
	br i1 %t555, label %l72, label %l73
l72:
	br label %l2
	br label %l73
l73:
	br i1 %t555, label %l74, label %l75
l74:
	br i1 %t555, label %l74, label %l75
l74:
	br i1 %t555, label %l74, label %l75
l74:
	br label %l75
l75:
	br i1 %t555, label %l76, label %l77
l76:
	br label %l78
l77:
	br i1 %t555, label %l76, label %l77
l76:
	br label %l77
l77:
	br label %l78
l78:
	br label %l2
	br label %l75
l75:
	br label %l75
l75:
	br label %l2
	br label %l3
l3:
	ret void
}
%struct.SymbolTableEntry = type { i32, %struct.PathEx, ptr }
%struct.EnumDefinedField = type { i16, i64 }
%struct.EnumSymbolTableEntry = type { %struct.comp_type.CompilerType, %struct.vector.Vec.struct.EnumDefinedField, i8 }
%struct.StructDefinedField = type { i16, %struct.comp_type.CompilerType }
%struct.StructSymbolTableEntry = type { %struct.vector.Vec.struct.StructDefinedField, %struct.layout.Layout, %struct.string.String, i8 }
%struct.FunctionSymbolTableEntry = type { %struct.vector.Vec.struct.StructDefinedField, %struct.comp_type.CompilerType, %struct.vector.Vec.struct.Stmt, %struct.string.String, i8 }
%struct.GenericFunctionSymbolTableEntry = type { %struct.vector.Vec.struct.GenericStructDefinedField, i1, %struct.comp_type.CompilerType, %struct.vector.Vec.struct.Stmt, %struct.vector.Vec.i16, %struct.vector.Vec.struct.Implementation, %struct.string.String, i8 }
%struct.Implementation = type { %struct.vector.Vec.struct.comp_type.CompilerType, %struct.string.String, %struct.layout.Layout }
%struct.GenericStructDefinedField = type { i16, %struct.comp_type.CompilerType, i1 }
%struct.GenericStructSymbolTableEntry = type { %struct.vector.Vec.struct.GenericStructDefinedField, %struct.vector.Vec.i16, %struct.vector.Vec.struct.Implementation, %struct.string.String, i8 }
%struct.ConstantSymbolTableEntry = type { %struct.comp_type.CompilerType, %struct.rvalue.Rvalue }
%struct.StaticSymbolTableEntry = type { %struct.comp_type.CompilerType, i1, %struct.rvalue.Rvalue }
%struct.SymbolTable = type { %struct.vector.Vec.struct.SymbolTableEntry, ptr }
%struct.expression_compiler.Expected = type { i32, ptr }
%struct.expression_compiler.CompiledValue = type { i32, %struct.comp_type.CompilerType, %struct.rvalue.Rvalue }
%struct.scope.Variable = type { i16, %struct.comp_type.CompilerType, i1 }
%struct.scope.Scope = type { %struct.vector.Vec.struct.scope.Variable, %struct.vector.Vec.i32, i32, i32, i32 }
%struct.comp_type.CompilerType = type { i32, i64 }
%struct.comp_type.PointerCompilerType = type { i8, %struct.comp_type.CompilerType }
%struct.comp_type.ConstantArrayCompilerType = type { i32, %struct.comp_type.CompilerType }
%struct.rvalue.Rvalue = type { i32, i64 }
%struct.layout.Layout = type { i16, i16 }
%struct.primitives.PrimitiveTypeInfo = type { ptr, ptr, %struct.layout.Layout, i32 }
%struct.output.LLVMInstruction = type { i32, i32, i32, i32 }
%struct.mem.PROCESS_HEAP_ENTRY = type { ptr, i32, i8, i8, i16, ptr, i32, i32, i32 }
%struct.string.String = type { ptr, i32, i32 }
%struct.window.POINT = type { i32, i32 }
%struct.window.MSG = type { ptr, i32, i64, i64, i32, %struct.window.POINT }
%struct.window.WNDCLASSEXA = type { i32, i32, ptr, i32, i32, ptr, ptr, ptr, ptr, ptr, ptr, ptr }
%struct.window.RECT = type { i32, i32, i32, i32 }
%struct.window.PAINTSTRUCT = type { ptr, i32, %struct.window.RECT, i32, i32, [19999991 x i8] }
%struct.window.BITMAP = type { i32, i32, i32, i32, i16, i16, ptr }
%struct.TokenData = type { i8, i16, i32 }
%struct.IntegerExpr = type { i16 }
%struct.DecimalExpr = type { i16 }
%struct.CharExpr = type { i16 }
%struct.NameExpr = type { i16 }
%struct.StringConstExpr = type { i16 }
%struct.TypeExpr = type { %struct.Type }
%struct.BinaryOpExpr = type { %struct.Expression, %struct.Expression, i8 }
%struct.UnaryOpExpr = type { %struct.Expression, i8 }
%struct.CastExpr = type { %struct.Expression, %struct.Type }
%struct.MemberAccessExpr = type { %struct.Expression, i16 }
%struct.StaticAccessExpr = type { %struct.Expression, i16 }
%struct.NameWithGenericsExpr = type { %struct.Expression, %struct.vector.Vec.struct.Type }
%struct.CallExpr = type { %struct.Expression, %struct.vector.Vec.struct.Expression, %struct.vector.Vec.struct.Type }
%struct.RangeExpr = type { %struct.Expression, %struct.Expression, i1 }
%struct.IndexExpr = type { %struct.Expression, %struct.Expression }
%struct.ArrayExpr = type { %struct.vector.Vec.struct.Expression }
%struct.StructInitFieldExpr = type { i16, %struct.Expression }
%struct.StructInitExpr = type { %struct.Expression, %struct.vector.Vec.struct.StructInitFieldExpr }
%struct.BoolExpr = type { i1 }
%struct.Expression = type { i32, ptr }
%struct.Path = type { i8, [19999991 x i16] }
%struct.PathEx = type { i8, [19999991 x i16] }
%struct.NamedType = type { i16 }
%struct.PointerType = type { i8, %struct.Type }
%struct.FunctionType = type { %struct.vector.Vec.struct.Type, %struct.Type }
%struct.NamespaceLinkType = type { %struct.Path, %struct.Type }
%struct.GenericType = type { i16, %struct.vector.Vec.struct.Type }
%struct.ConstantSizeArrayType = type { %struct.Type, %struct.Expression }
%struct.Type = type { i32, ptr }
%struct.Argument = type { i16, %struct.Type }
%struct.EnumField = type { i16, i1, %struct.Expression }
%struct.HintNode = type { i16, %struct.vector.Vec.struct.Expression }
%struct.FnNode = type { i16, i8, %struct.vector.Vec.struct.Argument, i1, %struct.Type, %struct.vector.Vec.i16, %struct.vector.Vec.struct.Stmt }
%struct.EnumNode = type { i16, i8, i1, %struct.Type, %struct.vector.Vec.struct.EnumField }
%struct.StructNode = type { i16, i8, %struct.vector.Vec.struct.Argument, %struct.vector.Vec.i16 }
%struct.IfStmt = type { %struct.Expression, %struct.vector.Vec.struct.Stmt, %struct.vector.Vec.struct.Stmt }
%struct.LoopStmt = type { %struct.vector.Vec.struct.Stmt }
%struct.WhileStmt = type { %struct.Expression, %struct.vector.Vec.struct.Stmt }
%struct.DoWhileStmt = type { %struct.Expression, %struct.vector.Vec.struct.Stmt }
%struct.ForStmt = type { %struct.Expression, %struct.Expression, %struct.vector.Vec.struct.Stmt }
%struct.NamespaceNode = type { i16, %struct.vector.Vec.struct.Stmt }
%struct.BlockStmt = type { %struct.vector.Vec.struct.Stmt }
%struct.ReturnNode = type { i1, %struct.Expression }
%struct.ExpressionNode = type { %struct.Expression }
%struct.DeclarationNode = type { i16, i1, %struct.Expression, %struct.Type, i8 }
%struct.Stmt = type { i8, ptr }
%struct.vector.Vec.struct.EnumDefinedField = type { ptr, i32, i32 }
%struct.vector.Vec.struct.StructDefinedField = type { ptr, i32, i32 }
%struct.vector.Vec.struct.Stmt = type { ptr, i32, i32 }
%struct.vector.Vec.struct.GenericStructDefinedField = type { ptr, i32, i32 }
%struct.vector.Vec.i16 = type { ptr, i32, i32 }
%struct.vector.Vec.struct.Implementation = type { ptr, i32, i32 }
%struct.vector.Vec.struct.comp_type.CompilerType = type { ptr, i32, i32 }
%struct.vector.Vec.struct.SymbolTableEntry = type { ptr, i32, i32 }
%struct.vector.Vec.struct.string.String = type { ptr, i32, i32 }
%struct.vector.Vec.struct.output.LLVMInstruction = type { ptr, i32, i32 }
%struct.vector.Vec.struct.scope.Variable = type { ptr, i32, i32 }
%struct.vector.Vec.i32 = type { ptr, i32, i32 }
%struct.vector.Vec.struct.TokenData = type { ptr, i32, i32 }
%struct.vector.Vec.struct.Type = type { ptr, i32, i32 }
%struct.vector.Vec.struct.Expression = type { ptr, i32, i32 }
%struct.vector.Vec.struct.StructInitFieldExpr = type { ptr, i32, i32 }
%struct.vector.Vec.struct.Argument = type { ptr, i32, i32 }
%struct.vector.Vec.struct.EnumField = type { ptr, i32, i32 }
declare dllimport void	@ExitProcess(i32 %a0)
declare dllimport i32	@GetModuleFileNameA(ptr %a0, ptr %a1, i32 %a2)
declare dllimport ptr	@GetProcessHeap()
declare dllimport ptr	@HeapAlloc(ptr %a0, i32 %a1, i64 %a2)
declare dllimport ptr	@HeapReAlloc(ptr %a0, i32 %a1, ptr %a2, i64 %a3)
declare dllimport i32	@HeapFree(ptr %a0, i32 %a1, ptr %a2)
declare dllimport i64	@HeapSize(ptr %a0, i32 %a1, ptr %a2)
declare dllimport i32	@HeapWalk(ptr %a0, ptr %a1)
declare dllimport i32	@HeapLock(ptr %a0)
declare dllimport i32	@HeapUnlock(ptr %a0)
declare dllimport i32	@AllocConsole()
declare dllimport ptr	@GetStdHandle(i32 %a0)
declare dllimport i32	@FreeConsole()
declare dllimport i32	@WriteConsoleA(ptr %a0, ptr %a1, i32 %a2, ptr %a3, ptr %a4)
declare dllimport ptr	@CreateFileA(ptr %a0, i32 %a1, i32 %a2, ptr %a3, i32 %a4, i32 %a5, ptr %a6)
declare dllimport i32	@WriteFile(ptr %a0, ptr %a1, i32 %a2, ptr %a3, ptr %a4)
declare dllimport i32	@ReadFile(ptr %a0, ptr %a1, i32 %a2, ptr %a3, ptr %a4)
declare dllimport i32	@GetFileSizeEx(ptr %a0, ptr %a1)
declare dllimport i32	@CloseHandle(ptr %a0)
declare dllimport i32	@DeleteFileA(ptr %a0)
declare dllimport i32	@GetFileAttributesA(ptr %a0)
declare dllimport i32	@GetFullPathNameA(ptr %a0, i32 %a1, ptr %a2, ptr %a3)
declare dllimport ptr	@PathCombineA(ptr %a0, ptr %a1, ptr %a2)
declare dllimport i16	@RegisterClassA(ptr %a0)
declare dllimport ptr	@CreateWindowExA(i32 %a0, ptr %a1, ptr %a2, i32 %a3, i32 %a4, i32 %a5, i32 %a6, i32 %a7, ptr %a8, ptr %a9, ptr %a10, ptr %a11)
declare dllimport i64	@DefWindowProcA(ptr %a0, i32 %a1, i64 %a2, i64 %a3)
declare dllimport i32	@GetMessageA(ptr %a0, ptr %a1, i32 %a2, i32 %a3)
declare dllimport i32	@TranslateMessage(ptr %a0)
declare dllimport i64	@DispatchMessageA(ptr %a0)
declare dllimport void	@PostQuitMessage(i32 %a0)
declare dllimport ptr	@BeginPaint(ptr %a0, ptr %a1)
declare dllimport i32	@EndPaint(ptr %a0, ptr %a1)
declare dllimport ptr	@GetDC(ptr %a0)
declare dllimport i32	@ReleaseDC(ptr %a0, ptr %a1)
declare dllimport ptr	@LoadCursorA(ptr %a0, ptr %a1)
declare dllimport ptr	@LoadIconA(ptr %a0, ptr %a1)
declare dllimport ptr	@LoadImageA(ptr %a0, ptr %a1, i32 %a2, i32 %a3, i32 %a4, i32 %a5)
declare dllimport i32	@GetClientRect(ptr %a0, ptr %a1)
declare dllimport i32	@InvalidateRect(ptr %a0, ptr %a1, i32 %a2)
declare dllimport i16	@RegisterClassExA(ptr %a0)
declare dllimport i32	@ShowWindow(ptr %a0, i32 %a1)
declare dllimport i64	@SetWindowLongPtrA(ptr %a0, i32 %a1, ptr %a2)
declare dllimport ptr	@GetWindowLongPtrA(ptr %a0, i32 %a1)
declare dllimport ptr	@GetModuleHandleA(ptr %a0)
declare dllimport ptr	@CreateCompatibleDC(ptr %a0)
declare dllimport ptr	@SelectObject(ptr %a0, ptr %a1)
declare dllimport i32	@BitBlt(ptr %a0, i32 %a1, i32 %a2, i32 %a3, i32 %a4, ptr %a5, i32 %a6, i32 %a7, i32 %a8)
declare dllimport i32	@DeleteDC(ptr %a0)
declare dllimport i32	@DeleteObject(ptr %a0)
declare dllimport i32	@GetObjectA(ptr %a0, i32 %a1, ptr %a2)
declare dllimport i32	@SetStretchBltMode(ptr %a0, i32 %a1)
declare dllimport i32	@StretchBlt(ptr %a0, i32 %a1, i32 %a2, i32 %a3, i32 %a4, ptr %a5, i32 %a6, i32 %a7, i32 %a8, i32 %a9, i32 %a10)
@layout.POINTER_LAYOUT = internal global %struct.layout.Layout zeroinitializer
@primitives.VOID_TYPE = internal global ptr zeroinitializer
@primitives.DEFAULT_INTEGER_TYPE = internal global ptr zeroinitializer
@primitives.PRIMITIVE_TYPES_INFO = internal global [19999991 x %struct.primitives.PrimitiveTypeInfo] zeroinitializer
@stdlib.rand_seed = internal global i32 zeroinitializer
