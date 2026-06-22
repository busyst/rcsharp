%struct.SymbolTableEntry = type { i32, %struct.PathEx, i32 }
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
%struct.SymbolTable = type { %struct.vector.Vec.struct.SymbolTableEntry, %struct.vector.Vec.struct.string.String*, %struct.vector.Vec.struct.FunctionSymbolTableEntry, %struct.vector.Vec.struct.GenericFunctionSymbolTableEntry, %struct.vector.Vec.struct.StructSymbolTableEntry, %struct.vector.Vec.struct.GenericStructSymbolTableEntry, %struct.vector.Vec.struct.EnumSymbolTableEntry, %struct.vector.Vec.struct.ConstantSymbolTableEntry, %struct.vector.Vec.struct.StaticSymbolTableEntry }
%struct.expression_compiler.Expected = type { i32, %struct.comp_type.CompilerType* }
%struct.expression_compiler.CompiledValue = type { i32, %struct.comp_type.CompilerType, %struct.rvalue.Rvalue }
%struct.scope.Variable = type { i16, %struct.comp_type.CompilerType, i1, i1, i1 }
%struct.scope.Scope = type { %struct.vector.Vec.struct.scope.Variable, %struct.vector.Vec.i32, i32, i32, i32 }
%struct.comp_type.CompilerType = type { i8, i8, i32, i64 }
%struct.comp_type.PointerCompilerType = type { i8, %struct.comp_type.CompilerType }
%struct.comp_type.ConstantArrayCompilerType = type { i32, %struct.comp_type.CompilerType }
%struct.rvalue.Rvalue = type { i32, i64 }
%struct.layout.Layout = type { i16, i16 }
%struct.primitives.PrimitiveTypeInfo = type { i8*, i8*, %struct.layout.Layout, i32 }
%struct.output.LLVMInstruction = type { i32, [19999991 x i8] }
%struct.mem.PROCESS_HEAP_ENTRY = type { ptr, i32, i8, i8, i16, ptr, i32, i32, i32 }
%struct.string.String = type { i8*, i32, i32 }
%struct.window.POINT = type { i32, i32 }
%struct.window.MSG = type { ptr, i32, i64, i64, i32, %struct.window.POINT }
%struct.window.WNDCLASSEXA = type { i32, i32, ptr, i32, i32, ptr, ptr, ptr, ptr, i8*, i8*, ptr }
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
%struct.list.List.i32 = type { ptr, ptr, i32 }
%struct.list.ListNode.i32 = type { ptr, ptr }
%struct.vector.Vec.struct.EnumDefinedField = type { ptr, i32, i32 }
%struct.vector.Vec.struct.StructDefinedField = type { ptr, i32, i32 }
%struct.vector.Vec.struct.Stmt = type { ptr, i32, i32 }
%struct.vector.Vec.struct.GenericStructDefinedField = type { ptr, i32, i32 }
%struct.vector.Vec.i16 = type { ptr, i32, i32 }
%struct.vector.Vec.struct.Implementation = type { ptr, i32, i32 }
%struct.vector.Vec.struct.comp_type.CompilerType = type { ptr, i32, i32 }
%struct.vector.Vec.struct.SymbolTableEntry = type { ptr, i32, i32 }
%struct.vector.Vec.struct.string.String = type { ptr, i32, i32 }
%struct.vector.Vec.struct.FunctionSymbolTableEntry = type { ptr, i32, i32 }
%struct.vector.Vec.struct.GenericFunctionSymbolTableEntry = type { ptr, i32, i32 }
%struct.vector.Vec.struct.StructSymbolTableEntry = type { ptr, i32, i32 }
%struct.vector.Vec.struct.GenericStructSymbolTableEntry = type { ptr, i32, i32 }
%struct.vector.Vec.struct.EnumSymbolTableEntry = type { ptr, i32, i32 }
%struct.vector.Vec.struct.ConstantSymbolTableEntry = type { ptr, i32, i32 }
%struct.vector.Vec.struct.StaticSymbolTableEntry = type { ptr, i32, i32 }
%struct.vector.Vec.struct.output.LLVMInstruction = type { ptr, i32, i32 }
%struct.vector.Vec.struct.scope.Variable = type { ptr, i32, i32 }
%struct.vector.Vec.i32 = type { ptr, i32, i32 }
%struct.vector.Vec.struct.TokenData = type { ptr, i32, i32 }
%struct.vector.Vec.struct.Type = type { ptr, i32, i32 }
%struct.vector.Vec.struct.Expression = type { ptr, i32, i32 }
%struct.vector.Vec.struct.StructInitFieldExpr = type { ptr, i32, i32 }
%struct.vector.Vec.struct.Argument = type { ptr, i32, i32 }
%struct.vector.Vec.struct.EnumField = type { ptr, i32, i32 }
%struct.vector.Vec.void = type { ptr, i32, i32 }
%struct.vector.Vec.i8 = type { ptr, i32, i32 }
declare dllimport void	@process.ExitProcess(i32 %a0)
declare dllimport i32	@process.GetModuleFileNameA(i8* %a0, i8* %a1, i32 %a2)
declare dllimport i32*	@mem.GetProcessHeap()
declare dllimport ptr	@mem.HeapAlloc(i32* %a0, i32 %a1, i64 %a2)
declare dllimport ptr	@mem.HeapReAlloc(i32* %a0, i32 %a1, ptr %a2, i64 %a3)
declare dllimport i32	@mem.HeapFree(i32* %a0, i32 %a1, ptr %a2)
declare dllimport i64	@mem.HeapSize(i32* %a0, i32 %a1, i8* %a2)
declare dllimport i32	@mem.HeapWalk(i32* %a0, %struct.mem.PROCESS_HEAP_ENTRY* %a1)
declare dllimport i32	@mem.HeapLock(i32* %a0)
declare dllimport i32	@mem.HeapUnlock(i32* %a0)
declare dllimport i32	@console.AllocConsole()
declare dllimport i8*	@console.GetStdHandle(i32 %a0)
declare dllimport i32	@console.FreeConsole()
declare dllimport i32	@console.WriteConsoleA(i8* %a0, i8* %a1, i32 %a2, i32* %a3, i8* %a4)
declare dllimport ptr	@fs.CreateFileA(i8* %a0, i32 %a1, i32 %a2, i8* %a3, i32 %a4, i32 %a5, i8* %a6)
declare dllimport i32	@fs.WriteFile(ptr %a0, i8* %a1, i32 %a2, i32* %a3, i8* %a4)
declare dllimport i32	@fs.ReadFile(ptr %a0, i8* %a1, i32 %a2, i32* %a3, i8* %a4)
declare dllimport i32	@fs.GetFileSizeEx(ptr %a0, i64* %a1)
declare dllimport i32	@fs.CloseHandle(ptr %a0)
declare dllimport i32	@fs.DeleteFileA(i8* %a0)
declare dllimport i32	@fs.GetFileAttributesA(i8* %a0)
declare dllimport i32	@fs.GetFullPathNameA(i8* %a0, i32 %a1, i8* %a2, i8* %a3)
declare dllimport i8*	@fs.PathCombineA(i8* %a0, i8* %a1, i8* %a2)
declare dllimport i16	@window.RegisterClassA(%struct.window.WNDCLASSEXA* %a0)
declare dllimport ptr	@window.CreateWindowExA(i32 %a0, i8* %a1, i8* %a2, i32 %a3, i32 %a4, i32 %a5, i32 %a6, i32 %a7, ptr %a8, ptr %a9, ptr %a10, ptr %a11)
declare dllimport i64	@window.DefWindowProcA(ptr %a0, i32 %a1, i64 %a2, i64 %a3)
declare dllimport i32	@window.GetMessageA(%struct.window.MSG* %a0, ptr %a1, i32 %a2, i32 %a3)
declare dllimport i32	@window.TranslateMessage(%struct.window.MSG* %a0)
declare dllimport i64	@window.DispatchMessageA(%struct.window.MSG* %a0)
declare dllimport void	@window.PostQuitMessage(i32 %a0)
declare dllimport ptr	@window.BeginPaint(ptr %a0, %struct.window.PAINTSTRUCT* %a1)
declare dllimport i32	@window.EndPaint(ptr %a0, %struct.window.PAINTSTRUCT* %a1)
declare dllimport ptr	@window.GetDC(ptr %a0)
declare dllimport i32	@window.ReleaseDC(ptr %a0, ptr %a1)
declare dllimport ptr	@window.LoadCursorA(ptr %a0, i8* %a1)
declare dllimport ptr	@window.LoadIconA(ptr %a0, i8* %a1)
declare dllimport ptr	@window.LoadImageA(ptr %a0, i8* %a1, i32 %a2, i32 %a3, i32 %a4, i32 %a5)
declare dllimport i32	@window.GetClientRect(ptr %a0, %struct.window.RECT* %a1)
declare dllimport i32	@window.InvalidateRect(ptr %a0, %struct.window.RECT* %a1, i32 %a2)
declare dllimport i16	@window.RegisterClassExA(%struct.window.WNDCLASSEXA* %a0)
declare dllimport i32	@window.ShowWindow(ptr %a0, i32 %a1)
declare dllimport i64	@window.SetWindowLongPtrA(ptr %a0, i32 %a1, ptr %a2)
declare dllimport ptr	@window.GetWindowLongPtrA(ptr %a0, i32 %a1)
declare dllimport ptr	@window.GetModuleHandleA(i8* %a0)
declare dllimport ptr	@window.CreateCompatibleDC(ptr %a0)
declare dllimport ptr	@window.SelectObject(ptr %a0, ptr %a1)
declare dllimport i32	@window.BitBlt(ptr %a0, i32 %a1, i32 %a2, i32 %a3, i32 %a4, ptr %a5, i32 %a6, i32 %a7, i32 %a8)
declare dllimport i32	@window.DeleteDC(ptr %a0)
declare dllimport i32	@window.DeleteObject(ptr %a0)
declare dllimport i32	@window.GetObjectA(ptr %a0, i32 %a1, %struct.window.BITMAP* %a2)
declare dllimport i32	@window.SetStretchBltMode(ptr %a0, i32 %a1)
declare dllimport i32	@window.StretchBlt(ptr %a0, i32 %a1, i32 %a2, i32 %a3, i32 %a4, ptr %a5, i32 %a6, i32 %a7, i32 %a8, i32 %a9, i32 %a10)
@layout.POINTER_LAYOUT = internal global %struct.layout.Layout zeroinitializer
@primitives.VOID_TYPE = internal global %struct.primitives.PrimitiveTypeInfo* zeroinitializer
@primitives.DEFAULT_INTEGER_TYPE = internal global %struct.primitives.PrimitiveTypeInfo* zeroinitializer
@primitives.DEFAULT_BOOL_TYPE = internal global %struct.primitives.PrimitiveTypeInfo* zeroinitializer
@primitives.DEFAULT_DECIMAL_TYPE = internal global %struct.primitives.PrimitiveTypeInfo* zeroinitializer
@primitives.PRIMITIVE_TYPES_INFO = internal global [19999991 x %struct.primitives.PrimitiveTypeInfo] zeroinitializer
@stdlib.rand_seed = internal global i32 zeroinitializer
define void @main(){
	ret void
}
define void @insert_symbol_into_table(%struct.SymbolTable* %a0, %struct.SymbolTableEntry %a1){
	%t2 = alloca %struct.SymbolTableEntry
	%t3 = add i32 1337, 0
	br i1 %t3, label %l0, label %l1
l0:
	br label %l1
l1:
	ret void
}
define %struct.SymbolTableEntry* @get_symbol_from_table(%struct.SymbolTable* %a0, %struct.PathEx %a1){
	%t2 = alloca %struct.PathEx
	%t3 = add i32 1337, 0
	br i1 %t3, label %l0, label %l1
l0:
	br label %l1
l1:
	%t4 = alloca %struct.SymbolTableEntry*
	%t5 = alloca i32
	%t6 = inttoptr i64 0 to ptr
	ret %t6
}
define void @rcsharp_compile(i8* %a0, i8* %a1){
	%t2 = alloca i8*
	%t3 = alloca i8*
	%t4 = alloca i32
	%t5 = alloca i32
	%t6 = alloca %struct.string.String
	%t7 = alloca %struct.vector.Vec.struct.string.String
	%t8 = alloca %struct.vector.Vec.struct.Stmt
	%t9 = alloca %struct.vector.Vec.struct.string.String
	%t10 = alloca i32
l0:
	%t11 = add i32 1337, 0
	br i1 %t11, label %l2, label %l1
l2:
	%t12 = alloca %struct.string.String
	%t13 = alloca %struct.vector.Vec.struct.TokenData
	%t14 = alloca %struct.vector.Vec.struct.Stmt
	br label %l0
	br label %l1
l1:
	%t15 = alloca %struct.string.String
	%t16 = alloca i8*
	%t17 = alloca i8*
	%t18 = alloca i32
	ret void
}
define void @debug_dump_type(%struct.Type* %a0, %struct.vector.Vec.struct.string.String* %a1, %struct.string.String* %a2){
	%t3 = alloca %struct.string.String*
	%t4 = add i32 1337, 0
	br i1 %t4, label %l0, label %l1
l0:
	%t5 = alloca %struct.NamedType*
	br label %l2
l1:
	%t6 = add i32 1337, 0
	br i1 %t6, label %l3, label %l4
l3:
	%t7 = alloca %struct.PointerType*
	%t8 = alloca %struct.Type*
	br label %l5
l4:
	%t9 = add i32 1337, 0
	br i1 %t9, label %l6, label %l7
l6:
	%t10 = alloca %struct.FunctionType*
	br label %l8
l7:
	%t11 = add i32 1337, 0
	br i1 %t11, label %l9, label %l10
l9:
	%t12 = alloca %struct.NamespaceLinkType*
	%t13 = alloca %struct.Type*
	br label %l11
l10:
	%t14 = add i32 1337, 0
	br i1 %t14, label %l12, label %l13
l12:
	%t15 = alloca %struct.GenericType*
	br label %l14
l13:
	%t16 = add i32 1337, 0
	br i1 %t16, label %l15, label %l16
l15:
	%t17 = alloca %struct.ConstantSizeArrayType*
	br label %l16
l16:
	br label %l14
l14:
	br label %l11
l11:
	br label %l8
l8:
	br label %l5
l5:
	br label %l2
l2:
	ret void
}
define void @debug_dump_expression(%struct.Expression* %a0, %struct.vector.Vec.struct.string.String* %a1, %struct.string.String* %a2){
	%t3 = add i32 1337, 0
	br i1 %t3, label %l0, label %l1
l0:
	%t4 = alloca %struct.IntegerExpr*
	ret void
	br label %l1
l1:
	%t5 = add i32 1337, 0
	br i1 %t5, label %l2, label %l3
l2:
	%t6 = alloca %struct.CharExpr*
	%t7 = add i32 1337, 0
	br i1 %t7, label %l4, label %l5
l4:
	br label %l6
l5:
	%t8 = add i32 1337, 0
	br i1 %t8, label %l7, label %l8
l7:
	br label %l8
l8:
	br label %l6
l6:
	ret void
	br label %l3
l3:
	%t9 = add i32 1337, 0
	br i1 %t9, label %l9, label %l10
l9:
	ret void
	br label %l10
l10:
	%t10 = add i32 1337, 0
	br i1 %t10, label %l11, label %l12
l11:
	%t11 = alloca %struct.StringConstExpr*
	ret void
	br label %l12
l12:
	%t12 = add i32 1337, 0
	br i1 %t12, label %l13, label %l14
l13:
	%t13 = alloca %struct.CallExpr*
	%t14 = add i32 1337, 0
	br i1 %t14, label %l15, label %l16
l15:
	br label %l16
l16:
	ret void
	br label %l14
l14:
	%t15 = add i32 1337, 0
	br i1 %t15, label %l17, label %l18
l17:
	%t16 = alloca %struct.StaticAccessExpr*
	ret void
	br label %l18
l18:
	%t17 = add i32 1337, 0
	br i1 %t17, label %l19, label %l20
l19:
	%t18 = alloca %struct.MemberAccessExpr*
	ret void
	br label %l20
l20:
	%t19 = add i32 1337, 0
	br i1 %t19, label %l21, label %l22
l21:
	%t20 = alloca %struct.CastExpr*
	ret void
	br label %l22
l22:
	%t21 = add i32 1337, 0
	br i1 %t21, label %l23, label %l24
l23:
	%t22 = alloca %struct.BinaryOpExpr*
	ret void
	br label %l24
l24:
	%t23 = add i32 1337, 0
	br i1 %t23, label %l25, label %l26
l25:
	%t24 = alloca %struct.UnaryOpExpr*
	%t25 = add i32 1337, 0
	br i1 %t25, label %l27, label %l28
l27:
	br label %l29
l28:
	%t26 = add i32 1337, 0
	br i1 %t26, label %l30, label %l31
l30:
	br label %l32
l31:
	%t27 = add i32 1337, 0
	br i1 %t27, label %l33, label %l34
l33:
	br label %l35
l34:
	%t28 = add i32 1337, 0
	br i1 %t28, label %l36, label %l37
l36:
	br label %l38
l37:
	%t29 = add i32 1337, 0
	br i1 %t29, label %l39, label %l40
l39:
	br label %l40
l40:
	br label %l38
l38:
	br label %l35
l35:
	br label %l32
l32:
	br label %l29
l29:
	ret void
	br label %l26
l26:
	%t30 = add i32 1337, 0
	br i1 %t30, label %l41, label %l42
l41:
	%t31 = alloca %struct.RangeExpr*
	%t32 = add i32 1337, 0
	br i1 %t32, label %l43, label %l44
l43:
	br label %l44
l44:
	ret void
	br label %l42
l42:
	%t33 = add i32 1337, 0
	br i1 %t33, label %l45, label %l46
l45:
	%t34 = alloca %struct.IndexExpr*
	ret void
	br label %l46
l46:
	%t35 = add i32 1337, 0
	br i1 %t35, label %l47, label %l48
l47:
	%t36 = alloca %struct.NameWithGenericsExpr*
	ret void
	br label %l48
l48:
	%t37 = add i32 1337, 0
	br i1 %t37, label %l49, label %l50
l49:
	%t38 = alloca %struct.StructInitExpr*
	ret void
	br label %l50
l50:
	ret void
}
define void @compile_internal_sym_table_prefill(%struct.Path* %a0, %struct.vector.Vec.struct.Stmt* %a1, %struct.SymbolTable* %a2, %struct.string.String* %a3){
	%t4 = alloca i32
	%t5 = alloca i32
	%t6 = alloca %struct.vector.Vec.struct.string.String*
	%t7 = alloca %struct.string.String*
l0:
	%t8 = add i32 1337, 0
	br i1 %t8, label %l2, label %l1
l2:
	%t9 = alloca %struct.Stmt*
	%t10 = add i32 1337, 0
	br i1 %t10, label %l3, label %l4
l3:
	br label %l5
l4:
	%t11 = add i32 1337, 0
	br i1 %t11, label %l6, label %l7
l6:
	br label %l0
	br label %l8
l7:
	%t12 = add i32 1337, 0
	br i1 %t12, label %l9, label %l10
l9:
	%t13 = alloca %struct.FnNode*
	%t14 = alloca %struct.PathEx
	%t15 = alloca %struct.SymbolTableEntry
	%t16 = add i32 1337, 0
	br i1 %t16, label %l12, label %l13
l12:
	br label %l14
l13:
	br label %l14
l14:
	br label %l0
	br label %l11
l10:
	%t17 = add i32 1337, 0
	br i1 %t17, label %l15, label %l16
l15:
	%t18 = alloca %struct.StructNode*
	%t19 = alloca %struct.PathEx
	%t20 = alloca %struct.SymbolTableEntry
	%t21 = add i32 1337, 0
	br i1 %t21, label %l18, label %l19
l18:
	%t22 = alloca %struct.string.String
	%t23 = alloca %struct.GenericStructSymbolTableEntry
	br label %l20
l19:
	%t24 = alloca %struct.string.String
	%t25 = alloca %struct.StructSymbolTableEntry
	br label %l20
l20:
	br label %l0
	br label %l17
l16:
	%t26 = add i32 1337, 0
	br i1 %t26, label %l21, label %l22
l21:
	%t27 = alloca %struct.EnumNode*
	%t28 = alloca %struct.PathEx
	%t29 = alloca %struct.SymbolTableEntry
	br label %l0
	br label %l23
l22:
	%t30 = add i32 1337, 0
	br i1 %t30, label %l24, label %l25
l24:
	%t31 = alloca %struct.NamespaceNode*
	%t32 = alloca %struct.Path
	%t33 = add i32 1337, 0
	br i1 %t33, label %l27, label %l28
l27:
	br label %l28
l28:
	br label %l0
	br label %l26
l25:
	%t34 = add i32 1337, 0
	br i1 %t34, label %l29, label %l30
l29:
	%t35 = alloca %struct.DeclarationNode*
	%t36 = alloca %struct.PathEx
	%t37 = alloca %struct.SymbolTableEntry
	%t38 = add i32 1337, 0
	br i1 %t38, label %l31, label %l32
l31:
	%t39 = add i32 1337, 0
	br i1 %t39, label %l34, label %l35
l34:
	br label %l35
l35:
	br label %l33
l32:
	%t40 = add i32 1337, 0
	br i1 %t40, label %l36, label %l37
l36:
	br label %l38
l37:
	%t41 = add i32 1337, 0
	br i1 %t41, label %l39, label %l40
l39:
	br label %l40
l40:
	br label %l38
l38:
	br label %l33
l33:
	br label %l0
	br label %l30
l30:
	br label %l26
l26:
	br label %l23
l23:
	br label %l17
l17:
	br label %l11
l11:
	br label %l8
l8:
	br label %l5
l5:
	br label %l0
	br label %l1
l1:
	ret void
}
define void @compile_internal_sym_table(%struct.Path* %a0, %struct.vector.Vec.struct.Stmt* %a1, %struct.SymbolTable* %a2, %struct.string.String* %a3){
	%t4 = alloca i32
	%t5 = alloca i32
	%t6 = alloca %struct.vector.Vec.struct.string.String*
	%t7 = alloca %struct.string.String*
	%t8 = alloca %struct.PathEx
l0:
	%t9 = add i32 1337, 0
	br i1 %t9, label %l2, label %l1
l2:
	%t10 = alloca %struct.Stmt*
	%t11 = add i32 1337, 0
	br i1 %t11, label %l3, label %l4
l3:
	%t12 = alloca %struct.HintNode*
	br label %l0
	br label %l5
l4:
	%t13 = add i32 1337, 0
	br i1 %t13, label %l6, label %l7
l6:
	br label %l0
	%t14 = alloca %struct.HintNode*
	br label %l0
	br label %l8
l7:
	%t15 = add i32 1337, 0
	br i1 %t15, label %l9, label %l10
l9:
	%t16 = alloca %struct.FnNode*
	%t17 = alloca %struct.PathEx
	%t18 = alloca %struct.SymbolTableEntry*
	%t19 = alloca %struct.string.String
	%t20 = add i32 1337, 0
	br i1 %t20, label %l12, label %l13
l12:
	%t21 = alloca %struct.GenericFunctionSymbolTableEntry
	%t22 = add i32 1337, 0
	br i1 %t22, label %l14, label %l15
l14:
	br label %l15
l15:
	br label %l0
	br label %l13
l13:
	%t23 = alloca %struct.FunctionSymbolTableEntry
	%t24 = add i32 1337, 0
	br i1 %t24, label %l16, label %l17
l16:
	br label %l17
l17:
	br label %l0
	br label %l11
l10:
	%t25 = add i32 1337, 0
	br i1 %t25, label %l18, label %l19
l18:
	%t26 = alloca %struct.StructNode*
	%t27 = alloca %struct.PathEx
	%t28 = alloca %struct.SymbolTableEntry*
	%t29 = add i32 1337, 0
	br i1 %t29, label %l21, label %l22
l21:
	%t30 = alloca %struct.GenericStructSymbolTableEntry*
	br label %l0
	br label %l22
l22:
	%t31 = alloca %struct.StructSymbolTableEntry*
	br label %l0
	br label %l20
l19:
	%t32 = add i32 1337, 0
	br i1 %t32, label %l23, label %l24
l23:
	%t33 = alloca %struct.EnumNode*
	%t34 = alloca %struct.PathEx
	%t35 = alloca %struct.SymbolTableEntry*
	%t36 = alloca %struct.EnumSymbolTableEntry
	%t37 = add i32 1337, 0
	br i1 %t37, label %l26, label %l27
l26:
	br label %l27
l27:
	%t38 = alloca i64
	br label %l0
	br label %l25
l24:
	%t39 = add i32 1337, 0
	br i1 %t39, label %l28, label %l29
l28:
	%t40 = alloca %struct.NamespaceNode*
	%t41 = alloca %struct.Path
	%t42 = add i32 1337, 0
	br i1 %t42, label %l31, label %l32
l31:
	br label %l32
l32:
	br label %l0
	br label %l30
l29:
	%t43 = add i32 1337, 0
	br i1 %t43, label %l33, label %l34
l33:
	%t44 = alloca %struct.DeclarationNode*
	%t45 = alloca %struct.PathEx
	%t46 = alloca %struct.SymbolTableEntry*
	%t47 = add i32 1337, 0
	br i1 %t47, label %l35, label %l36
l35:
	br label %l36
l36:
	%t48 = add i32 1337, 0
	br i1 %t48, label %l37, label %l38
l37:
	%t49 = alloca %struct.ConstantSymbolTableEntry
	br label %l39
l38:
	%t50 = add i32 1337, 0
	br i1 %t50, label %l40, label %l41
l40:
	%t51 = alloca %struct.StaticSymbolTableEntry
	%t52 = add i32 1337, 0
	br i1 %t52, label %l42, label %l43
l42:
	br label %l43
l43:
	br label %l41
l41:
	br label %l39
l39:
	br label %l0
	br label %l34
l34:
	br label %l30
l30:
	br label %l25
l25:
	br label %l20
l20:
	br label %l11
l11:
	br label %l8
l8:
	br label %l5
l5:
	br label %l0
	br label %l1
l1:
	ret void
}
define void @compile_internals.sym_table_push_external(%struct.SymbolTable* %a0, %struct.string.String* %a1){
	%t2 = alloca i32
	%t3 = alloca %struct.SymbolTableEntry*
	%t4 = alloca %struct.string.String*
	ret void
}
define void @compile_internals.sym_table_push_static(%struct.SymbolTable* %a0, %struct.string.String* %a1){
	%t2 = alloca i32
	%t3 = alloca %struct.SymbolTableEntry*
	%t4 = alloca %struct.string.String*
	ret void
}
define void @compile_internals.sym_table_push_structs(%struct.SymbolTable* %a0, %struct.string.String* %a1){
	%t2 = alloca i32
	%t3 = alloca %struct.SymbolTableEntry*
	%t4 = alloca %struct.string.String*
	ret void
}
define void @compile_internals.sym_table_push_structs_generic(%struct.SymbolTable* %a0, %struct.string.String* %a1){
	%t2 = alloca i32
	%t3 = alloca %struct.SymbolTableEntry*
	%t4 = alloca %struct.string.String*
	ret void
}
define void @compile_internals.sym_table_push_functions(%struct.SymbolTable* %a0, %struct.string.String* %a1){
	%t2 = alloca i32
	%t3 = alloca %struct.SymbolTableEntry*
	%t4 = alloca %struct.string.String*
	ret void
}
define void @compile_internals.compile_body(%struct.vector.Vec.struct.Stmt* %a0, i32 %a1, i32 %a2, %struct.scope.Scope* %a3, %struct.SymbolTable* %a4, %struct.vector.Vec.struct.output.LLVMInstruction* %a5){
	%t6 = alloca %struct.SymbolTableEntry*
	%t7 = alloca %struct.PathEx
	%t8 = alloca %struct.Path
	%t9 = alloca %struct.PathEx
	%t10 = alloca i32
	%t11 = alloca i32
l0:
	%t12 = add i32 1337, 0
	br i1 %t12, label %l2, label %l1
l2:
	%t13 = alloca %struct.Stmt*
	%t14 = add i32 1337, 0
	br i1 %t14, label %l3, label %l4
l3:
	%t15 = alloca %struct.DeclarationNode*
	%t16 = alloca %struct.Type*
	%t17 = alloca %struct.comp_type.CompilerType
	%t18 = alloca %struct.scope.Variable
	%t19 = add i32 1337, 0
	br i1 %t19, label %l5, label %l6
l5:
	br label %l7
l6:
	%t20 = add i32 1337, 0
	br i1 %t20, label %l8, label %l9
l8:
	br label %l9
l9:
	br label %l7
l7:
	%t21 = alloca i32
	%t22 = alloca %struct.string.String*
	%t23 = add i32 1337, 0
	br i1 %t23, label %l10, label %l11
l10:
	%t24 = alloca %struct.expression_compiler.CompiledValue
	br label %l11
l11:
	br label %l0
	br label %l4
l4:
	%t25 = add i32 1337, 0
	br i1 %t25, label %l12, label %l13
l12:
	%t26 = alloca %struct.ReturnNode*
	%t27 = add i32 1337, 0
	br i1 %t27, label %l14, label %l15
l14:
	br label %l0
	br label %l15
l15:
	%t28 = alloca %struct.expression_compiler.CompiledValue
	%t29 = alloca i32
	br label %l0
	br label %l13
l13:
	%t30 = add i32 1337, 0
	br i1 %t30, label %l16, label %l17
l16:
	%t31 = alloca %struct.ExpressionNode*
	%t32 = alloca %struct.expression_compiler.CompiledValue
	br label %l0
	br label %l17
l17:
	%t33 = add i32 1337, 0
	br i1 %t33, label %l18, label %l19
l18:
	%t34 = add i32 1337, 0
	br i1 %t34, label %l20, label %l21
l20:
	br label %l21
l21:
	br label %l0
	br label %l19
l19:
	%t35 = add i32 1337, 0
	br i1 %t35, label %l22, label %l23
l22:
	%t36 = add i32 1337, 0
	br i1 %t36, label %l24, label %l25
l24:
	br label %l25
l25:
	br label %l0
	br label %l23
l23:
	%t37 = add i32 1337, 0
	br i1 %t37, label %l26, label %l27
l26:
	%t38 = alloca %struct.LoopStmt*
	%t39 = alloca i32
	%t40 = alloca i32
	%t41 = alloca i32
	br label %l0
	br label %l27
l27:
	%t42 = add i32 1337, 0
	br i1 %t42, label %l28, label %l29
l28:
	%t43 = alloca %struct.WhileStmt*
	%t44 = alloca i32
	%t45 = alloca i32
	%t46 = alloca i32
	%t47 = alloca i32
	%t48 = alloca %struct.expression_compiler.CompiledValue
	%t49 = alloca i32
	br label %l0
	br label %l29
l29:
	%t50 = add i32 1337, 0
	br i1 %t50, label %l30, label %l31
l30:
	%t51 = alloca %struct.DoWhileStmt*
	%t52 = alloca i32
	%t53 = alloca i32
	%t54 = alloca i32
	%t55 = alloca i32
	%t56 = alloca %struct.expression_compiler.CompiledValue
	%t57 = alloca i32
	br label %l0
	br label %l31
l31:
	%t58 = add i32 1337, 0
	br i1 %t58, label %l32, label %l33
l32:
	%t59 = alloca %struct.IfStmt*
	%t60 = alloca i32
	%t61 = alloca %struct.expression_compiler.CompiledValue
	%t62 = alloca i32
	%t63 = alloca i32
	%t64 = alloca i32
	%t65 = alloca i32
	%t66 = add i32 1337, 0
	br i1 %t66, label %l34, label %l35
l34:
	br label %l35
l35:
	%t67 = add i32 1337, 0
	br i1 %t67, label %l36, label %l37
l36:
	br label %l37
l37:
	br label %l0
	br label %l33
l33:
	%t68 = add i32 1337, 0
	br i1 %t68, label %l38, label %l39
l38:
	%t69 = alloca %struct.ForStmt*
	br label %l0
	br label %l39
l39:
	br label %l0
	br label %l0
	br label %l1
l1:
	ret void
}
define void @compile(%struct.vector.Vec.struct.Stmt* %a0, %struct.vector.Vec.struct.string.String* %a1, %struct.string.String* %a2){
	%t3 = alloca %struct.SymbolTable
	%t4 = alloca %struct.Path
	%t5 = alloca %struct.string.String
	ret void
}
define void @debug_dump_symbol_table(%struct.SymbolTable* %a0, %struct.string.String* %a1){
	%t2 = alloca i32
	%t3 = alloca %struct.SymbolTableEntry*
	%t4 = alloca %struct.string.String*
	ret void
}
define %struct.expression_compiler.Expected @expression_compiler.expect_nothing(){
	%t0 = alloca void
	%t1 = add i32 1337, 0
	ret %t1
}
define %struct.expression_compiler.Expected @expression_compiler.expect_anything(){
	%t0 = alloca void
	%t1 = add i32 1337, 0
	ret %t1
}
define %struct.expression_compiler.Expected @expression_compiler.expect_compiler_type(%struct.comp_type.CompilerType* %a0){
	%t1 = alloca void
	%t2 = add i32 1337, 0
	ret %t2
}
define %struct.expression_compiler.CompiledValue @expression_compiler.cv_integer(i64 %a0){
	%t1 = alloca void
	%t2 = add i32 1337, 0
	ret %t2
}
define %struct.expression_compiler.CompiledValue @expression_compiler.cv_bool(i1 %a0){
	%t1 = alloca void
	%t2 = add i32 1337, 0
	ret %t2
}
define %struct.expression_compiler.CompiledValue @expression_compiler.cv_null_untyped(){
	%t0 = alloca void
	%t1 = add i32 1337, 0
	ret %t1
}
define i32 @expression_compiler.cv_to_register(%struct.expression_compiler.CompiledValue* %a0, %struct.scope.Scope* %a1, %struct.SymbolTable* %a2, %struct.vector.Vec.struct.output.LLVMInstruction* %a3, %struct.PathEx* %a4){
	%t5 = add i32 1337, 0
	br i1 %t5, label %l0, label %l1
l0:
	br label %l1
l1:
	%t6 = add i32 1337, 0
	br i1 %t6, label %l2, label %l3
l2:
	%t7 = add i32 1337, 0
	ret %t7
	br label %l4
l3:
	%t8 = add i32 1337, 0
	br i1 %t8, label %l5, label %l6
l5:
	%t9 = alloca i32
	%t10 = alloca %struct.string.String*
	%t11 = add i32 1337, 0
	ret %t11
	br label %l7
l6:
	%t12 = add i32 1337, 0
	br i1 %t12, label %l8, label %l9
l8:
	%t13 = alloca i32
	%t14 = alloca %struct.string.String*
	%t15 = add i32 1337, 0
	ret %t15
	br label %l9
l9:
	br label %l7
l7:
	br label %l4
l4:
	%t16 = add i32 1337, 0
	ret %t16
}
define %struct.expression_compiler.CompiledValue @expression_compiler.compile(%struct.Expression* %a0, %struct.expression_compiler.Expected %a1, %struct.scope.Scope* %a2, %struct.SymbolTable* %a3, %struct.vector.Vec.struct.output.LLVMInstruction* %a4, %struct.PathEx* %a5){
	%t6 = add i32 1337, 0
	ret %t6
}
define %struct.expression_compiler.CompiledValue @expression_compiler.compile_rval(%struct.Expression* %a0, %struct.expression_compiler.Expected %a1, %struct.scope.Scope* %a2, %struct.SymbolTable* %a3, %struct.vector.Vec.struct.output.LLVMInstruction* %a4, %struct.PathEx* %a5){
	%t6 = alloca void
	%t7 = add i32 1337, 0
	br i1 %t7, label %l0, label %l1
l0:
	%t8 = alloca %struct.BoolExpr*
	%t9 = add i32 1337, 0
	ret %t9
	br label %l1
l1:
	%t10 = add i32 1337, 0
	br i1 %t10, label %l2, label %l3
l2:
	%t11 = add i32 1337, 0
	br i1 %t11, label %l4, label %l5
l4:
	%t12 = add i32 1337, 0
	ret %t12
	br label %l6
l5:
	%t13 = add i32 1337, 0
	br i1 %t13, label %l7, label %l8
l7:
	%t14 = add i32 1337, 0
	ret %t14
	br label %l8
l8:
	br label %l6
l6:
	br label %l3
l3:
	%t15 = add i32 1337, 0
	ret %t15
}
define %struct.expression_compiler.CompiledValue @expression_compiler.compile_lval(%struct.Expression* %a0, %struct.scope.Scope* %a1, %struct.SymbolTable* %a2, %struct.vector.Vec.struct.output.LLVMInstruction* %a3, %struct.PathEx* %a4){
	%t5 = add i32 1337, 0
	ret %t5
}
define %struct.rvalue.Rvalue @expression_compiler.constant_expression_evaluation(%struct.Expression* %a0, %struct.SymbolTable* %a1, %struct.PathEx* %a2){
	%t3 = add i32 1337, 0
	ret %t3
}
define %struct.scope.Scope @scope.new(){
	%t0 = alloca void
	%t1 = add i32 1337, 0
	ret %t1
}
define void @scope.free(%struct.scope.Scope* %a0){
	ret void
}
define void @scope.add_to_scope(%struct.scope.Scope* %a0, %struct.scope.Variable %a1){
	ret void
}
define void @scope.enter_scope(%struct.scope.Scope* %a0){
	ret void
}
define void @scope.exit_scope(%struct.scope.Scope* %a0){
	%t1 = alloca i32
	%t2 = add i32 1337, 0
	br i1 %t2, label %l0, label %l1
l0:
	br label %l1
l1:
l2:
	%t3 = add i32 1337, 0
	br i1 %t3, label %l4, label %l3
l4:
	%t4 = alloca void
	br label %l2
	br label %l3
l3:
	ret void
}
define %struct.scope.Variable* @scope.last_variable(i16 %a0, %struct.scope.Scope* %a1){
	%t2 = alloca i32
	%t3 = add i32 1337, 0
	br i1 %t3, label %l0, label %l1
l0:
	%t4 = inttoptr i64 0 to ptr
	ret %t4
	br label %l1
l1:
	%t5 = add i32 1337, 0
	ret %t5
}
define %struct.scope.Variable* @scope.find_variable(i16 %a0, %struct.scope.Scope* %a1){
	%t2 = alloca i32
	%t3 = alloca i32
l0:
	%t4 = add i32 1337, 0
	br i1 %t4, label %l2, label %l1
l2:
	%t5 = alloca ptr
	%t6 = add i32 1337, 0
	br i1 %t6, label %l3, label %l4
l3:
	%t7 = add i32 1337, 0
	ret %t7
	br label %l4
l4:
	br label %l0
	br label %l1
l1:
	%t8 = inttoptr i64 0 to ptr
	ret %t8
}
define %struct.comp_type.CompilerType @comp_type.void(){
	%t0 = add i32 1337, 0
	ret %t0
}
define %struct.comp_type.CompilerType @comp_type.def_integer(){
	%t0 = add i32 1337, 0
	ret %t0
}
define %struct.comp_type.CompilerType @comp_type.def_bool(){
	%t0 = add i32 1337, 0
	ret %t0
}
define %struct.comp_type.CompilerType @comp_type.def_decimal(){
	%t0 = add i32 1337, 0
	ret %t0
}
define %struct.comp_type.CompilerType @comp_type.def_pointer(){
	%t0 = alloca void
	%t1 = add i32 1337, 0
	ret %t1
}
define %struct.comp_type.CompilerType @comp_type.primitive(%struct.primitives.PrimitiveTypeInfo* %a0){
	%t1 = alloca void
	%t2 = add i32 1337, 0
	ret %t2
}
define %struct.comp_type.CompilerType @comp_type.structure(i32 %a0){
	%t1 = alloca void
	%t2 = add i32 1337, 0
	ret %t2
}
define %struct.comp_type.CompilerType @comp_type.placeholder(i16 %a0){
	%t1 = alloca void
	%t2 = add i32 1337, 0
	ret %t2
}
define %struct.comp_type.CompilerType @comp_type.implementation(i32 %a0, i32 %a1){
	%t2 = alloca void
	%t3 = add i32 1337, 0
	ret %t3
}
define %struct.comp_type.CompilerType @comp_type.pointer(%struct.comp_type.CompilerType %a0, i8 %a1){
	%t2 = alloca void
	%t3 = add i32 1337, 0
	ret %t3
}
define %struct.comp_type.CompilerType @comp_type.constant_array(%struct.comp_type.CompilerType %a0, i32 %a1){
	%t2 = alloca void
	%t3 = alloca ptr
	%t4 = add i32 1337, 0
	ret %t4
}
define %struct.comp_type.CompilerType @comp_type.get_compiler_type(%struct.Type* %a0, %struct.Path* %a1, %struct.SymbolTable* %a2){
	%t3 = alloca %struct.Path
	%t4 = add i32 1337, 0
	ret %t4
}
define i1 @comp_type.get_compiler_type_generic(%struct.Type* %a0, %struct.Path* %a1, %struct.SymbolTable* %a2, %struct.vector.Vec.i16* %a3, %struct.comp_type.CompilerType* %a4){
	%t5 = alloca %struct.Path
	%t6 = add i32 1337, 0
	ret %t6
}
define %struct.comp_type.CompilerType @comp_type.get_compiler_type_internal(%struct.Type* %a0, %struct.Path* %a1, %struct.Path* %a2, %struct.SymbolTable* %a3){
	%t4 = add i32 1337, 0
	br i1 %t4, label %l0, label %l1
l0:
	%t5 = alloca %struct.NamedType*
	%t6 = alloca %struct.string.String*
	%t7 = alloca %struct.primitives.PrimitiveTypeInfo*
	%t8 = add i32 1337, 0
	br i1 %t8, label %l3, label %l4
l3:
	%t9 = add i32 1337, 0
	ret %t9
	br label %l4
l4:
	%t10 = alloca %struct.PathEx
	%t11 = alloca %struct.SymbolTableEntry*
	%t12 = add i32 1337, 0
	br i1 %t12, label %l5, label %l6
l5:
	%t13 = alloca %struct.PathEx
	%t14 = alloca %struct.SymbolTableEntry*
	br label %l6
l6:
	%t15 = add i32 1337, 0
	br i1 %t15, label %l7, label %l8
l7:
	%t16 = add i32 1337, 0
	ret %t16
	br label %l8
l8:
	%t17 = alloca i32
	%t18 = add i32 1337, 0
	ret %t18
	br label %l2
l1:
	%t19 = add i32 1337, 0
	br i1 %t19, label %l9, label %l10
l9:
	%t20 = alloca %struct.PointerType*
	%t21 = alloca void
	%t22 = add i32 1337, 0
	ret %t22
	br label %l11
l10:
	%t23 = add i32 1337, 0
	br i1 %t23, label %l12, label %l13
l12:
	%t24 = alloca %struct.NamespaceLinkType*
	%t25 = add i32 1337, 0
	ret %t25
	br label %l14
l13:
	%t26 = add i32 1337, 0
	br i1 %t26, label %l15, label %l16
l15:
	%t27 = alloca %struct.GenericType*
	%t28 = alloca %struct.string.String*
	%t29 = alloca %struct.primitives.PrimitiveTypeInfo*
	%t30 = add i32 1337, 0
	br i1 %t30, label %l18, label %l19
l18:
	br label %l19
l19:
	%t31 = alloca %struct.PathEx
	%t32 = alloca %struct.SymbolTableEntry*
	%t33 = add i32 1337, 0
	br i1 %t33, label %l20, label %l21
l20:
	%t34 = alloca %struct.PathEx
	%t35 = alloca %struct.SymbolTableEntry*
	br label %l21
l21:
	%t36 = add i32 1337, 0
	br i1 %t36, label %l22, label %l23
l22:
	br label %l23
l23:
	%t37 = alloca i32
	%t38 = alloca %struct.vector.Vec.void
	%t39 = alloca %struct.GenericStructSymbolTableEntry*
	%t40 = alloca i32
	%t41 = add i32 1337, 0
	br i1 %t41, label %l24, label %l25
l24:
	%t42 = alloca %struct.Implementation
	%t43 = alloca %struct.PathEx
	br label %l26
l25:
	br label %l26
l26:
	%t44 = add i32 1337, 0
	ret %t44
	br label %l17
l16:
	%t45 = add i32 1337, 0
	br i1 %t45, label %l27, label %l28
l27:
	%t46 = alloca %struct.ConstantSizeArrayType*
	%t47 = alloca void
	%t48 = alloca %struct.PathEx
	%t49 = alloca %struct.rvalue.Rvalue
	%t50 = add i32 1337, 0
	br i1 %t50, label %l29, label %l30
l29:
	br label %l30
l30:
	%t51 = add i32 1337, 0
	ret %t51
	br label %l28
l28:
	br label %l17
l17:
	br label %l14
l14:
	br label %l11
l11:
	br label %l2
l2:
	%t52 = add i32 1337, 0
	ret %t52
}
define i1 @comp_type.get_compiler_type_generic_internal(%struct.Type* %a0, %struct.Path* %a1, %struct.Path* %a2, %struct.SymbolTable* %a3, %struct.vector.Vec.i16* %a4, %struct.comp_type.CompilerType* %a5){
	%t6 = add i32 1337, 0
	br i1 %t6, label %l0, label %l1
l0:
	%t7 = alloca %struct.NamedType*
	%t8 = alloca %struct.string.String*
	%t9 = alloca %struct.primitives.PrimitiveTypeInfo*
	%t10 = add i32 1337, 0
	br i1 %t10, label %l3, label %l4
l3:
	%t11 = add i1 0, 0
	ret %t11
	br label %l4
l4:
	%t12 = alloca %struct.PathEx
	%t13 = alloca %struct.SymbolTableEntry*
	%t14 = add i32 1337, 0
	br i1 %t14, label %l5, label %l6
l5:
	%t15 = alloca %struct.PathEx
	%t16 = alloca %struct.SymbolTableEntry*
	br label %l6
l6:
	%t17 = add i32 1337, 0
	br i1 %t17, label %l7, label %l8
l7:
	%t18 = add i1 0, 0
	ret %t18
	br label %l8
l8:
	%t19 = alloca i32
	%t20 = add i1 0, 0
	ret %t20
	br label %l2
l1:
	%t21 = add i32 1337, 0
	br i1 %t21, label %l9, label %l10
l9:
	%t22 = alloca %struct.PointerType*
	%t23 = alloca void
	%t24 = alloca i1
	%t25 = add i32 1337, 0
	ret %t25
	br label %l11
l10:
	%t26 = add i32 1337, 0
	br i1 %t26, label %l12, label %l13
l12:
	%t27 = alloca %struct.NamespaceLinkType*
	%t28 = alloca void
	%t29 = alloca i1
	%t30 = add i32 1337, 0
	ret %t30
	br label %l13
l13:
	br label %l11
l11:
	br label %l2
l2:
	%t31 = add i1 0, 0
	ret %t31
}
define void @comp_type.compiler_type_push(%struct.comp_type.CompilerType* %a0, %struct.PathEx* %a1, %struct.SymbolTable* %a2, %struct.string.String* %a3){
	ret void
}
define void @comp_type.compiler_type_push_internal(%struct.comp_type.CompilerType* %a0, %struct.PathEx* %a1, %struct.SymbolTable* %a2, %struct.string.String* %a3, i1 %a4){
	%t5 = add i32 1337, 0
	br i1 %t5, label %l0, label %l1
l0:
	%t6 = alloca %struct.primitives.PrimitiveTypeInfo*
	%t7 = add i32 1337, 0
	br i1 %t7, label %l3, label %l4
l3:
	ret void
	br label %l5
l4:
	br label %l5
l5:
	br label %l2
l1:
	%t8 = add i32 1337, 0
	br i1 %t8, label %l6, label %l7
l6:
	%t9 = alloca i32
	%t10 = alloca %struct.SymbolTableEntry*
	%t11 = add i32 1337, 0
	br i1 %t11, label %l9, label %l10
l9:
	%t12 = alloca %struct.StructSymbolTableEntry*
	%t13 = add i32 1337, 0
	br i1 %t13, label %l12, label %l13
l12:
	br label %l13
l13:
	br label %l11
l10:
	%t14 = add i32 1337, 0
	br i1 %t14, label %l14, label %l15
l14:
	%t15 = alloca %struct.EnumSymbolTableEntry*
	br label %l15
l15:
	br label %l11
l11:
	br label %l8
l7:
	%t16 = add i32 1337, 0
	br i1 %t16, label %l16, label %l17
l16:
	%t17 = alloca i32
	%t18 = alloca i32
	%t19 = alloca %struct.SymbolTableEntry*
	%t20 = alloca %struct.GenericStructSymbolTableEntry*
	%t21 = alloca %struct.Implementation*
	%t22 = add i32 1337, 0
	br i1 %t22, label %l19, label %l20
l19:
	br label %l20
l20:
	br label %l18
l17:
	%t23 = add i32 1337, 0
	br i1 %t23, label %l21, label %l22
l21:
	%t24 = alloca ptr
	br label %l22
l22:
	br label %l18
l18:
	br label %l8
l8:
	br label %l2
l2:
	%t25 = add i32 1337, 0
	br i1 %t25, label %l23, label %l24
l23:
	br label %l24
l24:
	ret void
}
define %struct.comp_type.CompilerType @comp_type.clone(%struct.comp_type.CompilerType* %a0){
	%t1 = alloca void
	%t2 = add i32 1337, 0
	ret %t2
}
define i1 @comp_type.equal(%struct.comp_type.CompilerType* %a0, %struct.comp_type.CompilerType* %a1){
	%t2 = add i32 1337, 0
	br i1 %t2, label %l0, label %l1
l0:
	%t3 = add i1 0, 0
	ret %t3
	br label %l1
l1:
	%t4 = add i32 1337, 0
	br i1 %t4, label %l2, label %l3
l2:
	%t5 = alloca ptr
	%t6 = alloca ptr
	%t7 = add i32 1337, 0
	ret %t7
	br label %l3
l3:
	%t8 = add i32 1337, 0
	ret %t8
}
define void @comp_type.free(%struct.comp_type.CompilerType* %a0){
	%t1 = add i32 1337, 0
	br i1 %t1, label %l0, label %l1
l0:
	%t2 = alloca ptr
	br label %l1
l1:
	ret void
}
define %struct.rvalue.Rvalue @rvalue.register(i32 %a0){
	%t1 = alloca void
	%t2 = add i32 1337, 0
	ret %t2
}
define %struct.rvalue.Rvalue @rvalue.integer(i64 %a0){
	%t1 = alloca void
	%t2 = add i32 1337, 0
	ret %t2
}
define %struct.rvalue.Rvalue @rvalue.decimal(double %a0){
	%t1 = alloca void
	%t2 = add i32 1337, 0
	ret %t2
}
define %struct.rvalue.Rvalue @rvalue.boolean(i1 %a0){
	%t1 = alloca void
	%t2 = add i32 1337, 0
	ret %t2
}
define %struct.rvalue.Rvalue @rvalue.nil(){
	%t0 = alloca void
	%t1 = add i32 1337, 0
	ret %t1
}
define %struct.rvalue.Rvalue @rvalue.void(){
	%t0 = alloca void
	%t1 = add i32 1337, 0
	ret %t1
}
define %struct.layout.Layout @layout.invalid(){
	%t0 = alloca void
	%t1 = add i32 1337, 0
	ret %t1
}
define %struct.layout.Layout @layout.void(){
	%t0 = alloca void
	%t1 = add i32 1337, 0
	ret %t1
}
define %struct.layout.Layout @layout.one(){
	%t0 = alloca void
	%t1 = add i32 1337, 0
	ret %t1
}
define %struct.layout.Layout @layout.two(){
	%t0 = alloca void
	%t1 = add i32 1337, 0
	ret %t1
}
define %struct.layout.Layout @layout.four(){
	%t0 = alloca void
	%t1 = add i32 1337, 0
	ret %t1
}
define %struct.layout.Layout @layout.eight(){
	%t0 = alloca void
	%t1 = add i32 1337, 0
	ret %t1
}
define i1 @layout.equal(%struct.layout.Layout* %a0, %struct.layout.Layout* %a1){
	%t2 = add i32 1337, 0
	ret %t2
}
define void @layout.STATIC_layout(){
	ret void
}
define void @primitives.STATIC_primitives(){
	%t0 = alloca void
	%t1 = alloca void
	%t2 = alloca void
	%t3 = alloca void
	%t4 = alloca void
	%t5 = alloca void
	%t6 = alloca void
	%t7 = alloca void
	%t8 = alloca void
	%t9 = alloca void
	%t10 = alloca void
	%t11 = alloca void
	%t12 = alloca void
	%t13 = alloca void
	%t14 = alloca void
	ret void
}
define %struct.primitives.PrimitiveTypeInfo* @primitives.find_primitive_type(i8* %a0, i32 %a1){
	%t2 = alloca i32
	%t3 = add i32 1337, 0
	br i1 %t3, label %l0, label %l1
l0:
	%t4 = inttoptr i64 0 to ptr
	ret %t4
	br label %l1
l1:
	%t5 = add i32 1337, 0
	ret %t5
}
define i32 @primitives.find_primitive_type_index(i8* %a0, i32 %a1){
	%t2 = add i32 1337, 0
	br i1 %t2, label %l0, label %l1
l0:
	%t3 = add i32 1337, 0
	br i1 %t3, label %l2, label %l3
l2:
	%t4 = add i32 1337, 0
	ret %t4
	br label %l3
l3:
	%t5 = add i32 1337, 0
	br i1 %t5, label %l4, label %l5
l4:
	%t6 = add i32 1337, 0
	ret %t6
	br label %l5
l5:
	br label %l1
l1:
	%t7 = add i32 1337, 0
	br i1 %t7, label %l6, label %l7
l6:
	%t8 = add i32 1337, 0
	br i1 %t8, label %l8, label %l9
l8:
	%t9 = add i32 1337, 0
	ret %t9
	br label %l9
l9:
	%t10 = add i32 1337, 0
	br i1 %t10, label %l10, label %l11
l10:
	%t11 = add i32 1337, 0
	ret %t11
	br label %l11
l11:
	%t12 = add i32 1337, 0
	br i1 %t12, label %l12, label %l13
l12:
	%t13 = add i32 1337, 0
	ret %t13
	br label %l13
l13:
	%t14 = add i32 1337, 0
	br i1 %t14, label %l14, label %l15
l14:
	%t15 = add i32 1337, 0
	ret %t15
	br label %l15
l15:
	%t16 = add i32 1337, 0
	br i1 %t16, label %l16, label %l17
l16:
	%t17 = add i32 1337, 0
	ret %t17
	br label %l17
l17:
	%t18 = add i32 1337, 0
	br i1 %t18, label %l18, label %l19
l18:
	%t19 = add i32 1337, 0
	ret %t19
	br label %l19
l19:
	%t20 = add i32 1337, 0
	br i1 %t20, label %l20, label %l21
l20:
	%t21 = add i32 1337, 0
	ret %t21
	br label %l21
l21:
	%t22 = add i32 1337, 0
	br i1 %t22, label %l22, label %l23
l22:
	%t23 = add i32 1337, 0
	ret %t23
	br label %l23
l23:
	%t24 = add i32 1337, 0
	br i1 %t24, label %l24, label %l25
l24:
	%t25 = add i32 1337, 0
	ret %t25
	br label %l25
l25:
	br label %l7
l7:
	%t26 = add i32 1337, 0
	br i1 %t26, label %l26, label %l27
l26:
	%t27 = add i32 1337, 0
	br i1 %t27, label %l28, label %l29
l28:
	%t28 = add i32 1337, 0
	ret %t28
	br label %l29
l29:
	%t29 = add i32 1337, 0
	br i1 %t29, label %l30, label %l31
l30:
	%t30 = add i32 1337, 0
	ret %t30
	br label %l31
l31:
	br label %l27
l27:
	%t31 = add i32 1337, 0
	br i1 %t31, label %l32, label %l33
l32:
	%t32 = add i32 1337, 0
	br i1 %t32, label %l34, label %l35
l34:
	%t33 = add i32 1337, 0
	ret %t33
	br label %l35
l35:
	%t34 = add i32 1337, 0
	br i1 %t34, label %l36, label %l37
l36:
	%t35 = add i32 1337, 0
	ret %t35
	br label %l37
l37:
	br label %l33
l33:
	%t36 = add i32 1337, 0
	ret %t36
}
define void @output.push_instructions(%struct.vector.Vec.struct.output.LLVMInstruction* %a0, %struct.SymbolTable* %a1, %struct.string.String* %a2){
	ret void
}
define void @output.push_instruction(%struct.output.LLVMInstruction* %a0, %struct.SymbolTable* %a1, %struct.string.String* %a2){
	%t3 = add i32 1337, 0
	br i1 %t3, label %l0, label %l1
l0:
	br label %l2
l1:
	%t4 = add i32 1337, 0
	br i1 %t4, label %l3, label %l4
l3:
	br label %l5
l4:
	%t5 = add i32 1337, 0
	br i1 %t5, label %l6, label %l7
l6:
	br label %l8
l7:
	%t6 = add i32 1337, 0
	br i1 %t6, label %l9, label %l10
l9:
	%t7 = alloca i32
	br label %l11
l10:
	%t8 = add i32 1337, 0
	br i1 %t8, label %l12, label %l13
l12:
	%t9 = alloca i32
	br label %l14
l13:
	%t10 = add i32 1337, 0
	br i1 %t10, label %l15, label %l16
l15:
	%t11 = alloca i32
	%t12 = alloca i32
	%t13 = alloca i32
	br label %l17
l16:
	%t14 = add i32 1337, 0
	br i1 %t14, label %l18, label %l19
l18:
	%t15 = alloca i32
	br label %l20
l19:
	%t16 = add i32 1337, 0
	br i1 %t16, label %l21, label %l22
l21:
	%t17 = alloca %struct.string.String*
	%t18 = add i32 1337, 0
	br i1 %t18, label %l24, label %l25
l24:
	br label %l25
l25:
	br label %l23
l22:
	%t19 = add i32 1337, 0
	br i1 %t19, label %l26, label %l27
l26:
	%t20 = alloca i32
	%t21 = alloca i32
	%t22 = alloca i32
	%t23 = alloca i8*
	%t24 = alloca %struct.string.String*
	br label %l28
l27:
	%t25 = add i32 1337, 0
	br i1 %t25, label %l29, label %l30
l29:
	%t26 = alloca i32
	%t27 = alloca i32
	%t28 = alloca i8*
	%t29 = alloca %struct.string.String*
	%t30 = alloca %struct.string.String*
	br label %l31
l30:
	%t31 = add i32 1337, 0
	br i1 %t31, label %l32, label %l33
l32:
	%t32 = alloca i32
	%t33 = alloca i32
	%t34 = alloca %struct.string.String*
	br label %l34
l33:
	%t35 = add i32 1337, 0
	br i1 %t35, label %l35, label %l36
l35:
	%t36 = alloca i32
	%t37 = alloca i64
	%t38 = alloca %struct.string.String*
	br label %l37
l36:
	%t39 = add i32 1337, 0
	br i1 %t39, label %l38, label %l39
l38:
	%t40 = alloca i32
	%t41 = alloca %struct.string.String*
	br label %l40
l39:
	%t42 = add i32 1337, 0
	br i1 %t42, label %l41, label %l42
l41:
	%t43 = alloca i32
	%t44 = alloca i32
	%t45 = alloca %struct.string.String*
	br label %l43
l42:
	%t46 = add i32 1337, 0
	br i1 %t46, label %l44, label %l45
l44:
	%t47 = alloca i32
	%t48 = alloca i32
	%t49 = alloca i32
	%t50 = alloca %struct.string.String*
	br label %l46
l45:
	%t51 = add i32 1337, 0
	br i1 %t51, label %l47, label %l48
l47:
	%t52 = alloca i32
	%t53 = alloca i32
	%t54 = alloca i32
	%t55 = alloca %struct.string.String*
	br label %l49
l48:
	%t56 = add i32 1337, 0
	br i1 %t56, label %l50, label %l51
l50:
	%t57 = alloca i32
	%t58 = alloca %struct.string.String*
	br label %l51
l51:
	br label %l49
l49:
	br label %l46
l46:
	br label %l43
l43:
	br label %l40
l40:
	br label %l37
l37:
	br label %l34
l34:
	br label %l31
l31:
	br label %l28
l28:
	br label %l23
l23:
	br label %l20
l20:
	br label %l17
l17:
	br label %l14
l14:
	br label %l11
l11:
	br label %l8
l8:
	br label %l5
l5:
	br label %l2
l2:
	ret void
}
define %struct.output.LLVMInstruction @output.ret_void(){
	%t0 = alloca void
	%t1 = add i32 1337, 0
	ret %t1
}
define %struct.output.LLVMInstruction @output.unreachable(){
	%t0 = alloca void
	%t1 = add i32 1337, 0
	ret %t1
}
define %struct.output.LLVMInstruction @output.ret(i32 %a0){
	%t1 = alloca void
	%t2 = add i32 1337, 0
	ret %t2
}
define %struct.output.LLVMInstruction @output.label(i32 %a0){
	%t1 = alloca void
	%t2 = add i32 1337, 0
	ret %t2
}
define %struct.output.LLVMInstruction @output.jump_to(i32 %a0){
	%t1 = alloca void
	%t2 = add i32 1337, 0
	ret %t2
}
define %struct.output.LLVMInstruction @output.branch(i32 %a0, i32 %a1, i32 %a2){
	%t3 = alloca void
	%t4 = add i32 1337, 0
	ret %t4
}
define %struct.output.LLVMInstruction @output.alloc_stack(i32 %a0, i32 %a1, %struct.string.String* %a2){
	%t3 = alloca void
	%t4 = add i32 1337, 0
	ret %t4
}
define %struct.output.LLVMInstruction @output.alloc(i32 %a0, %struct.string.String* %a1){
	%t2 = alloca void
	%t3 = add i32 1337, 0
	ret %t3
}
define %struct.output.LLVMInstruction @output.binary_operator(i32 %a0, i8* %a1, %struct.string.String* %a2, i32 %a3, i32 %a4){
	%t5 = alloca void
	%t6 = add i32 1337, 0
	ret %t6
}
define %struct.output.LLVMInstruction @output.cast(i32 %a0, i8* %a1, %struct.string.String* %a2, %struct.string.String* %a3, i32 %a4){
	%t5 = alloca void
	%t6 = add i32 1337, 0
	ret %t6
}
define %struct.output.LLVMInstruction @output.load(i32 %a0, %struct.string.String* %a1, i32 %a2){
	%t3 = alloca void
	%t4 = add i32 1337, 0
	ret %t4
}
define %struct.output.LLVMInstruction @output.load_integer(i32 %a0, %struct.string.String* %a1, i64 %a2){
	%t3 = alloca void
	%t4 = add i32 1337, 0
	ret %t4
}
define %struct.output.LLVMInstruction @output.load_null(i32 %a0, %struct.string.String* %a1){
	%t2 = alloca void
	%t3 = add i32 1337, 0
	ret %t3
}
define %struct.output.LLVMInstruction @output.store(i32 %a0, %struct.string.String* %a1, i32 %a2){
	%t3 = alloca void
	%t4 = add i32 1337, 0
	ret %t4
}
define %struct.output.LLVMInstruction @output.get_element_ptr(i32 %a0, %struct.string.String* %a1, i32 %a2, i32 %a3){
	%t4 = alloca void
	%t5 = add i32 1337, 0
	ret %t5
}
define %struct.output.LLVMInstruction @output.get_element_ptr_in_array(i32 %a0, %struct.string.String* %a1, i32 %a2, i32 %a3){
	%t4 = alloca void
	%t5 = add i32 1337, 0
	ret %t5
}
define %struct.output.LLVMInstruction @output.return_op(%struct.string.String* %a0, i32 %a1){
	%t2 = alloca void
	%t3 = add i32 1337, 0
	ret %t3
}
define void @__chkstk(){
	ret void
}
define i32 @_fltused(){
	%t0 = add i32 1337, 0
	ret %t0
}
define %struct.string.String @process.get_executable_path(){
	%t0 = alloca i32
	%t1 = alloca %struct.string.String
	%t2 = alloca i32
	%t3 = add i32 1337, 0
	ret %t3
}
define %struct.string.String @process.get_executable_env_path(){
	%t0 = alloca %struct.string.String
	%t1 = alloca i32
l0:
	%t2 = add i32 1337, 0
	br i1 %t2, label %l2, label %l1
l2:
	br label %l0
	br label %l1
l1:
	%t3 = add i32 1337, 0
	ret %t3
}
define void @process.throw(i8* %a0){
	%t1 = alloca i32
	%t2 = alloca i8*
	ret void
}
define ptr @mem.malloc(i64 %a0){
	%t1 = alloca ptr
	%t2 = add i32 1337, 0
	br i1 %t2, label %l0, label %l1
l0:
	br label %l1
l1:
	%t3 = add i32 1337, 0
	ret %t3
}
define ptr @mem.realloc(ptr %a0, i64 %a1){
	%t2 = add i32 1337, 0
	br i1 %t2, label %l0, label %l1
l0:
	%t3 = add i32 1337, 0
	ret %t3
	br label %l1
l1:
	%t4 = alloca ptr
	%t5 = add i32 1337, 0
	br i1 %t5, label %l2, label %l3
l2:
	br label %l3
l3:
	%t6 = add i32 1337, 0
	ret %t6
}
define void @mem.free(ptr %a0){
	%t1 = add i32 1337, 0
	br i1 %t1, label %l0, label %l1
l0:
	br label %l1
l1:
	ret void
}
define void @mem.copy(i8* %a0, i8* %a1, i64 %a2){
	ret void
}
define i32 @mem.compare(i8* %a0, i8* %a1, i64 %a2){
	%t3 = add i32 1337, 0
	ret %t3
}
define void @mem.fill(i8 %a0, i8* %a1, i64 %a2){
	ret void
}
define void @mem.zero_fill(i8* %a0, i64 %a1){
	ret void
}
define i64 @mem.get_total_allocated_memory_external(){
	%t0 = alloca i32*
	%t1 = alloca i64
	%t2 = alloca void
	%t3 = add i32 1337, 0
	br i1 %t3, label %l0, label %l1
l0:
	br label %l1
l1:
l2:
	%t4 = add i32 1337, 0
	br i1 %t4, label %l4, label %l3
l4:
	%t5 = add i32 1337, 0
	br i1 %t5, label %l5, label %l6
l5:
	br label %l6
l6:
	br label %l2
	br label %l3
l3:
	%t6 = add i32 1337, 0
	ret %t6
}
define i8* @console.get_stdout(){
	%t0 = alloca i8*
	%t1 = add i32 1337, 0
	br i1 %t1, label %l0, label %l1
l0:
	br label %l1
l1:
	%t2 = add i32 1337, 0
	ret %t2
}
define void @console.write(i8* %a0, i32 %a1){
	%t2 = add i32 1337, 0
	br i1 %t2, label %l0, label %l1
l0:
	ret void
	br label %l1
l1:
	%t3 = alloca i32
	%t4 = add i32 1337, 0
	br i1 %t4, label %l2, label %l3
l2:
	br label %l3
l3:
	ret void
}
define void @console.write_string(%struct.string.String* %a0){
	%t1 = add i32 1337, 0
	br i1 %t1, label %l0, label %l1
l0:
	ret void
	br label %l1
l1:
	%t2 = alloca i32
	%t3 = add i32 1337, 0
	br i1 %t3, label %l2, label %l3
l2:
	br label %l3
l3:
	ret void
}
define void @console.writeln(i8* %a0, i32 %a1){
	%t2 = alloca i32
	%t3 = alloca i8
	ret void
}
define void @console.print_char(i8 %a0){
	%t1 = alloca i8
	ret void
}
define void @console.println_i64(i64 %a0){
	%t1 = add i32 1337, 0
	br i1 %t1, label %l0, label %l1
l0:
	br label %l2
l1:
	br label %l2
l2:
	ret void
}
define void @console.println_u64(i64 %a0){
	%t1 = alloca i8*
	%t2 = alloca i32
	%t3 = add i32 1337, 0
	br i1 %t3, label %l0, label %l1
l0:
	ret void
	br label %l1
l1:
	%t4 = alloca i64
l2:
l4:
	%t5 = add i32 1337, 0
	br i1 %t5, label %l4, label %l3
	br label %l2
	br label %l3
l3:
	%t6 = alloca i8*
	%t7 = alloca i32
	ret void
}
define void @console.println_f64(double %a0){
	%t1 = alloca i32
	%t2 = alloca double
	%t3 = add i32 1337, 0
	br i1 %t3, label %l0, label %l1
l0:
	br label %l1
l1:
	%t4 = alloca double
	%t5 = alloca i64
	%t6 = alloca double
	%t7 = add i32 1337, 0
	br i1 %t7, label %l2, label %l3
l2:
	br label %l4
l3:
	%t8 = alloca i8*
	%t9 = alloca i32
	%t10 = alloca i64
l5:
l7:
	%t11 = add i32 1337, 0
	br i1 %t11, label %l7, label %l6
	br label %l5
	br label %l6
l6:
	%t12 = alloca i8*
	%t13 = alloca i32
	br label %l4
l4:
	ret void
}
define %struct.string.String @string.from_data(i8* %a0, i32 %a1){
	%t2 = alloca void
	%t3 = add i32 1337, 0
	br i1 %t3, label %l0, label %l1
l0:
	br label %l1
l1:
	%t4 = add i32 1337, 0
	ret %t4
}
define %struct.string.String @string.from_c_string(i8* %a0){
	%t1 = add i32 1337, 0
	ret %t1
}
define %struct.string.String @string.empty(){
	%t0 = alloca void
	%t1 = add i32 1337, 0
	ret %t1
}
define %struct.string.String @string.with_size(i32 %a0){
	%t1 = alloca void
	%t2 = add i32 1337, 0
	br i1 %t2, label %l0, label %l1
l0:
	br label %l1
l1:
	%t3 = add i32 1337, 0
	ret %t3
}
define %struct.string.String @string.clone(%struct.string.String* %a0){
	%t1 = add i32 1337, 0
	ret %t1
}
define void @string.reserve(%struct.string.String* %a0, i32 %a1){
	%t2 = add i32 1337, 0
	br i1 %t2, label %l0, label %l1
l0:
	ret void
	br label %l1
l1:
	%t3 = alloca i32
	%t4 = add i32 1337, 0
	br i1 %t4, label %l2, label %l3
l2:
	br label %l3
l3:
l4:
	%t5 = add i32 1337, 0
	br i1 %t5, label %l6, label %l5
l6:
	br label %l4
	br label %l5
l5:
	%t6 = alloca i8*
	%t7 = add i32 1337, 0
	br i1 %t7, label %l7, label %l8
l7:
	br label %l8
l8:
	%t8 = add i32 1337, 0
	br i1 %t8, label %l9, label %l10
l9:
	br label %l10
l10:
	ret void
}
define %struct.string.String @string.append_c_string(%struct.string.String* %a0, i8* %a1){
	%t2 = alloca i32
	%t3 = alloca void
	%t4 = add i32 1337, 0
	br i1 %t4, label %l0, label %l1
l0:
	br label %l1
l1:
	%t5 = add i32 1337, 0
	br i1 %t5, label %l2, label %l3
l2:
	br label %l3
l3:
	%t6 = add i32 1337, 0
	ret %t6
}
define void @string.append_str(%struct.string.String* %a0, i8* %a1, i32 %a2){
	%t3 = add i32 1337, 0
	br i1 %t3, label %l0, label %l1
l0:
	ret void
	br label %l1
l1:
	%t4 = add i32 1337, 0
	br i1 %t4, label %l2, label %l3
l2:
	ret void
	br label %l3
l3:
	ret void
}
define void @string.append(%struct.string.String* %a0, i8 %a1){
	ret void
}
define void @string.append_u64(%struct.string.String* %a0, i64 %a1){
	%t2 = add i32 1337, 0
	br i1 %t2, label %l0, label %l1
l0:
	ret void
	br label %l1
l1:
	%t3 = alloca i32
	%t4 = alloca i8*
	%t5 = alloca i64
l2:
l4:
	%t6 = add i32 1337, 0
	br i1 %t6, label %l4, label %l3
	br label %l2
	br label %l3
l3:
	%t7 = alloca i8*
	%t8 = alloca i32
	ret void
}
define i1 @string.equal(%struct.string.String* %a0, %struct.string.String* %a1){
	%t2 = add i32 1337, 0
	br i1 %t2, label %l0, label %l1
l0:
	%t3 = add i1 0, 0
	ret %t3
	br label %l1
l1:
	%t4 = add i32 1337, 0
	br i1 %t4, label %l2, label %l3
l2:
	%t5 = add i1 1, 0
	ret %t5
	br label %l3
l3:
	%t6 = add i32 1337, 0
	ret %t6
}
define void @string.free(%struct.string.String* %a0){
	%t1 = add i32 1337, 0
	br i1 %t1, label %l0, label %l1
l0:
	br label %l1
l1:
	ret void
}
define void @string.as_c_string_stalloc(%struct.string.String* %a0, i8* %a1){
	%t2 = add i32 1337, 0
	br i1 %t2, label %l0, label %l1
l0:
	br label %l1
l1:
	ret void
}
define i1 @char_utils.is_alnum(i8 %a0){
	%t1 = add i32 1337, 0
	ret %t1
}
define i1 @char_utils.is_alpha(i8 %a0){
	%t1 = add i32 1337, 0
	ret %t1
}
define i1 @char_utils.is_cntrl(i8 %a0){
	%t1 = add i32 1337, 0
	ret %t1
}
define i1 @char_utils.is_digit(i8 %a0){
	%t1 = add i32 1337, 0
	ret %t1
}
define i1 @char_utils.is_graph(i8 %a0){
	%t1 = add i32 1337, 0
	ret %t1
}
define i1 @char_utils.is_lower(i8 %a0){
	%t1 = add i32 1337, 0
	ret %t1
}
define i1 @char_utils.is_print(i8 %a0){
	%t1 = add i32 1337, 0
	ret %t1
}
define i1 @char_utils.is_punct(i8 %a0){
	%t1 = add i32 1337, 0
	ret %t1
}
define i1 @char_utils.is_space(i8 %a0){
	%t1 = add i32 1337, 0
	ret %t1
}
define i1 @char_utils.is_upper(i8 %a0){
	%t1 = add i32 1337, 0
	ret %t1
}
define i1 @char_utils.is_xdigit(i8 %a0){
	%t1 = add i32 1337, 0
	ret %t1
}
define i8 @char_utils.to_lower(i8 %a0){
	%t1 = add i32 1337, 0
	br i1 %t1, label %l0, label %l1
l0:
	%t2 = add i32 1337, 0
	ret %t2
	br label %l1
l1:
	%t3 = add i32 1337, 0
	ret %t3
}
define i8 @char_utils.to_upper(i8 %a0){
	%t1 = add i32 1337, 0
	br i1 %t1, label %l0, label %l1
l0:
	%t2 = add i32 1337, 0
	ret %t2
	br label %l1
l1:
	%t3 = add i32 1337, 0
	ret %t3
}
define i8* @string_utils.c_str_copy(i8* %a0, i8* %a1){
	%t2 = alloca i32
l0:
	%t3 = add i32 1337, 0
	br i1 %t3, label %l2, label %l1
l2:
	br label %l0
	br label %l1
l1:
	%t4 = add i32 1337, 0
	ret %t4
}
define i8* @string_utils.c_str_n_copy(i8* %a0, i8* %a1, i32 %a2){
	%t3 = alloca i32
l0:
	%t4 = add i32 1337, 0
	br i1 %t4, label %l2, label %l1
l2:
	%t5 = add i32 1337, 0
	br i1 %t5, label %l3, label %l4
l3:
	br label %l1
	br label %l4
l4:
	br label %l0
	br label %l1
l1:
l5:
	%t6 = add i32 1337, 0
	br i1 %t6, label %l7, label %l6
l7:
	br label %l5
	br label %l6
l6:
	%t7 = add i32 1337, 0
	ret %t7
}
define i8* @string_utils.insert(i8* %a0, i8* %a1, i32 %a2){
	%t3 = alloca i32
	%t4 = alloca i32
	%t5 = alloca i8*
	%t6 = add i32 1337, 0
	ret %t6
}
define i32 @string_utils.c_str_len(i8* %a0){
	%t1 = alloca i32
l0:
	%t2 = add i32 1337, 0
	br i1 %t2, label %l2, label %l1
l2:
	br label %l0
	br label %l1
l1:
	%t3 = add i32 1337, 0
	ret %t3
}
define %struct.string.String @string_utils.u64_to_string(i64 %a0){
	%t1 = alloca i32
	%t2 = add i32 1337, 0
	br i1 %t2, label %l0, label %l1
l0:
	%t3 = alloca i8
	%t4 = add i32 1337, 0
	ret %t4
	br label %l1
l1:
	%t5 = alloca i8*
	%t6 = alloca i64
l2:
l4:
	%t7 = add i32 1337, 0
	br i1 %t7, label %l4, label %l3
	br label %l2
	br label %l3
l3:
	%t8 = alloca i8*
	%t9 = alloca i32
	%t10 = add i32 1337, 0
	ret %t10
}
define i32 @stdlib.atoi(i8* %a0){
	%t1 = alloca i32
	%t2 = alloca i32
	%t3 = alloca i32
l0:
	%t4 = add i32 1337, 0
	br i1 %t4, label %l2, label %l1
l2:
	br label %l0
	br label %l1
l1:
	%t5 = add i32 1337, 0
	br i1 %t5, label %l3, label %l4
l3:
	br label %l5
l4:
	%t6 = add i32 1337, 0
	br i1 %t6, label %l6, label %l7
l6:
	br label %l7
l7:
	br label %l5
l5:
l8:
	%t7 = add i32 1337, 0
	br i1 %t7, label %l10, label %l9
l10:
	br label %l8
	br label %l9
l9:
	%t8 = add i32 1337, 0
	ret %t8
}
define i64 @stdlib.str_to_l(i8* %a0, i8** %a1, i32 %a2){
	%t3 = alloca i32
l0:
	%t4 = add i32 1337, 0
	br i1 %t4, label %l2, label %l1
l2:
	br label %l0
	br label %l1
l1:
	%t5 = alloca i64
	%t6 = add i32 1337, 0
	br i1 %t6, label %l3, label %l4
l3:
	br label %l5
l4:
	%t7 = add i32 1337, 0
	br i1 %t7, label %l6, label %l7
l6:
	br label %l7
l7:
	br label %l5
l5:
	%t8 = alloca i32
	%t9 = add i32 1337, 0
	br i1 %t9, label %l8, label %l9
l8:
	%t10 = add i32 1337, 0
	br i1 %t10, label %l10, label %l11
l10:
	%t11 = add i32 1337, 0
	br i1 %t11, label %l13, label %l14
l13:
	br label %l15
l14:
	br label %l15
l15:
	br label %l12
l11:
	br label %l12
l12:
	br label %l9
l9:
	%t12 = add i32 1337, 0
	br i1 %t12, label %l16, label %l17
l16:
	br label %l17
l17:
	%t13 = alloca i64
	%t14 = alloca i32
l18:
	%t15 = alloca i8
	%t16 = add i32 1337, 0
	br i1 %t16, label %l20, label %l21
l20:
	br label %l22
l21:
	%t17 = add i32 1337, 0
	br i1 %t17, label %l23, label %l24
l23:
	br label %l25
l24:
	br label %l19
	br label %l25
l25:
	br label %l22
l22:
	%t18 = add i32 1337, 0
	br i1 %t18, label %l26, label %l27
l26:
	br label %l19
	br label %l27
l27:
	br label %l18
	br label %l19
l19:
	%t19 = add i32 1337, 0
	br i1 %t19, label %l28, label %l29
l28:
	br label %l29
l29:
	%t20 = add i32 1337, 0
	ret %t20
}
define void @stdlib.srand(i32 %a0){
	ret void
}
define i32 @stdlib.rand(){
	%t0 = add i32 1337, 0
	ret %t0
}
define i32 @fs.write_to_file(i8* %a0, i8* %a1, i32 %a2){
	%t3 = alloca i32
	%t4 = alloca i32
	%t5 = alloca i32
	%t6 = alloca ptr
	%t7 = add i32 1337, 0
	br i1 %t7, label %l0, label %l1
l0:
	%t8 = add i32 1337, 0
	ret %t8
	br label %l1
l1:
	%t9 = alloca i32
	%t10 = alloca i32
	%t11 = add i32 1337, 0
	ret %t11
}
define %struct.string.String @fs.read_full_file_as_string_string(%struct.string.String* %a0){
	%t1 = alloca i8*
	%t2 = add i32 1337, 0
	ret %t2
}
define %struct.string.String @fs.read_full_file_as_string(i8* %a0){
	%t1 = alloca i32
	%t2 = alloca i32
	%t3 = alloca ptr
	%t4 = add i32 1337, 0
	br i1 %t4, label %l0, label %l1
l0:
	br label %l1
l1:
	%t5 = alloca i64
	%t6 = add i32 1337, 0
	br i1 %t6, label %l2, label %l3
l2:
	%t7 = add i32 1337, 0
	ret %t7
	br label %l3
l3:
	%t8 = alloca %struct.string.String
	%t9 = alloca i32
	%t10 = alloca i32
	%t11 = add i32 1337, 0
	br i1 %t11, label %l4, label %l5
l4:
	br label %l5
l5:
	%t12 = add i32 1337, 0
	ret %t12
}
define i32 @fs.create_file(i8* %a0){
	%t1 = alloca ptr
	%t2 = add i32 1337, 0
	br i1 %t2, label %l0, label %l1
l0:
	%t3 = add i32 1337, 0
	ret %t3
	br label %l1
l1:
	%t4 = add i32 1337, 0
	ret %t4
}
define i32 @fs.delete_file(i8* %a0){
	%t1 = add i32 1337, 0
	ret %t1
}
define i1 @fs.file_exists(i8* %a0){
	%t1 = alloca i32
	%t2 = alloca i32
	%t3 = add i32 1337, 0
	ret %t3
}
define void @tests.run(){
	%t0 = alloca i64
	%t1 = alloca i64
	%t2 = alloca i64
	ret void
}
define void @tests.mem_test(){
	%t0 = alloca i64
	%t1 = alloca i8*
	%t2 = add i32 1337, 0
	br i1 %t2, label %l0, label %l1
l0:
	br label %l1
l1:
	%t3 = alloca i8*
	%t4 = add i32 1337, 0
	br i1 %t4, label %l2, label %l3
l2:
	br label %l3
l3:
	ret void
}
define void @tests.string_utils_test(){
	%t0 = add i32 1337, 0
	br i1 %t0, label %l0, label %l1
l0:
	br label %l1
l1:
	%t1 = add i32 1337, 0
	br i1 %t1, label %l2, label %l3
l2:
	br label %l3
l3:
	%t2 = add i32 1337, 0
	br i1 %t2, label %l4, label %l5
l4:
	br label %l5
l5:
	%t3 = add i32 1337, 0
	br i1 %t3, label %l6, label %l7
l6:
	br label %l7
l7:
	%t4 = add i32 1337, 0
	br i1 %t4, label %l8, label %l9
l8:
	br label %l9
l9:
	%t5 = alloca i8*
	%t6 = alloca i8*
	%t7 = alloca i32
l10:
	%t8 = add i32 1337, 0
	br i1 %t8, label %l12, label %l11
l12:
	%t9 = add i32 1337, 0
	br i1 %t9, label %l13, label %l14
l13:
	br label %l14
l14:
	br label %l10
	br label %l11
l11:
	ret void
}
define void @tests.string_test(){
	%t0 = alloca %struct.string.String
	%t1 = alloca %struct.string.String
	%t2 = alloca %struct.string.String
	%t3 = add i32 1337, 0
	br i1 %t3, label %l0, label %l1
l0:
	br label %l1
l1:
	%t4 = add i32 1337, 0
	br i1 %t4, label %l2, label %l3
l2:
	br label %l3
l3:
	%t5 = add i32 1337, 0
	br i1 %t5, label %l4, label %l5
l4:
	br label %l5
l5:
	%t6 = alloca %struct.string.String
	%t7 = alloca %struct.string.String
	%t8 = add i32 1337, 0
	br i1 %t8, label %l6, label %l7
l6:
	br label %l7
l7:
	%t9 = add i32 1337, 0
	br i1 %t9, label %l8, label %l9
l8:
	br label %l9
l9:
	ret void
}
define void @tests.vector_test(){
	%t0 = alloca %struct.vector.Vec.i8
	%t1 = add i32 1337, 0
	br i1 %t1, label %l0, label %l1
l0:
	br label %l1
l1:
	%t2 = add i32 1337, 0
	br i1 %t2, label %l2, label %l3
l2:
	br label %l3
l3:
	%t3 = add i32 1337, 0
	br i1 %t3, label %l4, label %l5
l4:
	br label %l5
l5:
	%t4 = add i32 1337, 0
	br i1 %t4, label %l6, label %l7
l6:
	br label %l7
l7:
	%t5 = add i32 1337, 0
	br i1 %t5, label %l8, label %l9
l8:
	br label %l9
l9:
	%t6 = alloca i8*
	%t7 = add i32 1337, 0
	br i1 %t7, label %l10, label %l11
l10:
	br label %l11
l11:
	%t8 = add i32 1337, 0
	br i1 %t8, label %l12, label %l13
l12:
	br label %l13
l13:
	%t9 = add i32 1337, 0
	br i1 %t9, label %l14, label %l15
l14:
	br label %l15
l15:
	ret void
}
define void @tests.list_test(){
	%t0 = alloca %struct.list.List.i32
	%t1 = add i32 1337, 0
	br i1 %t1, label %l0, label %l1
l0:
	br label %l1
l1:
	%t2 = add i32 1337, 0
	br i1 %t2, label %l2, label %l3
l2:
	br label %l3
l3:
	%t3 = add i32 1337, 0
	br i1 %t3, label %l4, label %l5
l4:
	br label %l5
l5:
	%t4 = alloca %struct.list.ListNode.i32*
	%t5 = add i32 1337, 0
	br i1 %t5, label %l6, label %l7
l6:
	br label %l7
l7:
	%t6 = add i32 1337, 0
	br i1 %t6, label %l8, label %l9
l8:
	br label %l9
l9:
	%t7 = add i32 1337, 0
	br i1 %t7, label %l10, label %l11
l10:
	br label %l11
l11:
	%t8 = add i32 1337, 0
	br i1 %t8, label %l12, label %l13
l12:
	br label %l13
l13:
	%t9 = add i32 1337, 0
	br i1 %t9, label %l14, label %l15
l14:
	br label %l15
l15:
	ret void
}
define void @tests.process_test(){
	%t0 = alloca %struct.string.String
	%t1 = alloca %struct.string.String
	%t2 = add i32 1337, 0
	br i1 %t2, label %l0, label %l1
l0:
	br label %l1
l1:
	%t3 = add i32 1337, 0
	br i1 %t3, label %l2, label %l3
l2:
	br label %l3
l3:
	%t4 = add i32 1337, 0
	br i1 %t4, label %l4, label %l5
l4:
	br label %l5
l5:
	%t5 = add i32 1337, 0
	br i1 %t5, label %l6, label %l7
l6:
	br label %l7
l7:
	ret void
}
define void @tests.console_test(){
	ret void
}
define void @tests.fs_test(){
	%t0 = alloca %struct.string.String
	%t1 = alloca %struct.string.String
	%t2 = alloca %struct.string.String
	%t3 = alloca i8*
	%t4 = alloca %struct.string.String
	%t5 = add i32 1337, 0
	br i1 %t5, label %l0, label %l1
l0:
	br label %l1
l1:
	ret void
}
define void @tests.consume_while(%struct.string.String* %a0, i32* %a1, ptr %a2){
l0:
	%t3 = add i32 1337, 0
	br i1 %t3, label %l2, label %l1
l2:
	%t4 = alloca i8
	%t5 = add i32 1337, 0
	br i1 %t5, label %l3, label %l4
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
	%t1 = add i32 1337, 0
	ret %t1
}
define i1 @tests.valid_name_token(i8 %a0){
	%t1 = add i32 1337, 0
	ret %t1
}
define i1 @tests.is_valid_number_token(i8 %a0){
	%t1 = add i32 1337, 0
	ret %t1
}
define void @tests.funny(){
	%t0 = alloca i8*
	%t1 = add i32 1337, 0
	br i1 %t1, label %l0, label %l1
l0:
	ret void
	br label %l1
l1:
	%t2 = alloca %struct.string.String
	%t3 = alloca i8
	%t4 = alloca i8
	%t5 = alloca i32
	%t6 = alloca %struct.vector.Vec.struct.string.String
	%t7 = alloca %struct.vector.Vec.void
	ret void
}
define i64 @window.WindowProc(ptr %a0, i32 %a1, i64 %a2, i64 %a3){
	%t4 = add i32 1337, 0
	br i1 %t4, label %l0, label %l1
l0:
	%t5 = add i32 1337, 0
	ret %t5
	br label %l1
l1:
	%t6 = add i32 1337, 0
	br i1 %t6, label %l2, label %l3
l2:
	%t7 = add i32 1337, 0
	ret %t7
	br label %l3
l3:
	%t8 = add i32 1337, 0
	br i1 %t8, label %l4, label %l5
l4:
	%t9 = add i32 1337, 0
	br i1 %t9, label %l6, label %l7
l6:
	%t10 = add i32 1337, 0
	ret %t10
	br label %l7
l7:
	br label %l5
l5:
	%t11 = add i32 1337, 0
	br i1 %t11, label %l8, label %l9
l8:
	%t12 = add i32 1337, 0
	ret %t12
	br label %l9
l9:
	%t13 = add i32 1337, 0
	br i1 %t13, label %l10, label %l11
l10:
	%t14 = alloca i64
	%t15 = add i32 1337, 0
	br i1 %t15, label %l12, label %l13
l12:
	%t16 = add i32 1337, 0
	ret %t16
	br label %l13
l13:
	%t17 = add i32 1337, 0
	ret %t17
	br label %l11
l11:
	%t18 = add i32 1337, 0
	br i1 %t18, label %l14, label %l15
l14:
	%t19 = add i32 1337, 0
	ret %t19
	br label %l15
l15:
	%t20 = add i32 1337, 0
	br i1 %t20, label %l16, label %l17
l16:
	%t21 = alloca void
	%t22 = alloca ptr
	%t23 = alloca ptr
	%t24 = add i32 1337, 0
	br i1 %t24, label %l18, label %l19
l18:
	br label %l19
l19:
	%t25 = add i32 1337, 0
	ret %t25
	br label %l17
l17:
	%t26 = add i32 1337, 0
	ret %t26
}
define ptr @window.load_bitmap_from_file(i8* %a0){
	%t1 = add i32 1337, 0
	br i1 %t1, label %l0, label %l1
l0:
	br label %l1
l1:
	%t2 = add i32 1337, 0
	ret %t2
}
define void @window.get_bitmap_dimensions(ptr %a0, i32* %a1, i32* %a2){
	%t3 = alloca void
	ret void
}
define void @window.draw_bitmap(ptr %a0, ptr %a1, i32 %a2, i32 %a3){
	%t4 = add i32 1337, 0
	br i1 %t4, label %l0, label %l1
l0:
	ret void
	br label %l1
l1:
	%t5 = alloca ptr
	%t6 = alloca ptr
	%t7 = alloca void
	ret void
}
define void @window.draw_bitmap_stretched(ptr %a0, ptr %a1, i32 %a2, i32 %a3, i32 %a4, i32 %a5){
	%t6 = add i32 1337, 0
	br i1 %t6, label %l0, label %l1
l0:
	ret void
	br label %l1
l1:
	%t7 = alloca ptr
	%t8 = alloca ptr
	%t9 = alloca void
	ret void
}
define i1 @window.is_null(ptr %a0){
	%t1 = add i32 1337, 0
	ret %t1
}
define void @window.start(){
	%t0 = alloca i32
	%t1 = alloca ptr
	%t2 = add i32 1337, 0
	br i1 %t2, label %l0, label %l1
l0:
	br label %l1
l1:
	%t3 = alloca i8*
	%t4 = alloca void
	%t5 = add i32 1337, 0
	br i1 %t5, label %l2, label %l3
l2:
	br label %l3
l3:
	%t6 = alloca i8*
	%t7 = alloca ptr
	%t8 = add i32 1337, 0
	br i1 %t8, label %l4, label %l5
l4:
	br label %l5
l5:
	%t9 = alloca void
l6:
	%t10 = add i32 1337, 0
	br i1 %t10, label %l8, label %l7
l8:
	br label %l6
	br label %l7
l7:
	ret void
}
define void @window.start_image_window(i8* %a0){
	%t1 = alloca ptr
	%t2 = add i32 1337, 0
	br i1 %t2, label %l0, label %l1
l0:
	br label %l1
l1:
	%t3 = alloca ptr
	%t4 = add i32 1337, 0
	br i1 %t4, label %l2, label %l3
l2:
	br label %l3
l3:
	%t5 = alloca i32
	%t6 = alloca i32
	%t7 = alloca i8*
	%t8 = alloca void
	%t9 = add i32 1337, 0
	br i1 %t9, label %l4, label %l5
l4:
	br label %l5
l5:
	%t10 = alloca ptr
	%t11 = add i32 1337, 0
	br i1 %t11, label %l6, label %l7
l6:
	br label %l7
l7:
	%t12 = alloca void
	%t13 = alloca void
l8:
	%t14 = add i32 1337, 0
	br i1 %t14, label %l10, label %l9
l10:
	br label %l8
	br label %l9
l9:
	ret void
}
define i1 @is_modifier(i8 %a0){
	%t1 = add i32 1337, 0
	ret %t1
}
define %struct.string.String @token_type_to_string(%struct.TokenData* %a0, %struct.vector.Vec.struct.string.String* %a1){
	%t2 = add i32 1337, 0
	br i1 %t2, label %l0, label %l1
l0:
	%t3 = add i32 1337, 0
	br i1 %t3, label %l3, label %l4
l3:
	%t4 = add i32 1337, 0
	ret %t4
	br label %l5
l4:
	%t5 = add i32 1337, 0
	br i1 %t5, label %l6, label %l7
l6:
	%t6 = add i32 1337, 0
	ret %t6
	br label %l8
l7:
	%t7 = add i32 1337, 0
	br i1 %t7, label %l9, label %l10
l9:
	%t8 = add i32 1337, 0
	ret %t8
	br label %l11
l10:
	%t9 = add i32 1337, 0
	br i1 %t9, label %l12, label %l13
l12:
	%t10 = add i32 1337, 0
	ret %t10
	br label %l14
l13:
	%t11 = add i32 1337, 0
	br i1 %t11, label %l15, label %l16
l15:
	%t12 = add i32 1337, 0
	ret %t12
	br label %l16
l16:
	br label %l14
l14:
	br label %l11
l11:
	br label %l8
l8:
	br label %l5
l5:
	br label %l2
l1:
	%t13 = add i32 1337, 0
	br i1 %t13, label %l17, label %l18
l17:
	%t14 = add i32 1337, 0
	ret %t14
	br label %l19
l18:
	%t15 = add i32 1337, 0
	br i1 %t15, label %l20, label %l21
l20:
	%t16 = add i32 1337, 0
	ret %t16
	br label %l22
l21:
	%t17 = add i32 1337, 0
	br i1 %t17, label %l23, label %l24
l23:
	%t18 = add i32 1337, 0
	ret %t18
	br label %l25
l24:
	%t19 = add i32 1337, 0
	br i1 %t19, label %l26, label %l27
l26:
	%t20 = add i32 1337, 0
	ret %t20
	br label %l28
l27:
	%t21 = add i32 1337, 0
	br i1 %t21, label %l29, label %l30
l29:
	%t22 = add i32 1337, 0
	ret %t22
	br label %l30
l30:
	br label %l28
l28:
	br label %l25
l25:
	br label %l22
l22:
	br label %l19
l19:
	br label %l2
l2:
	%t23 = add i32 1337, 0
	br i1 %t23, label %l31, label %l32
l31:
	%t24 = add i32 1337, 0
	ret %t24
	br label %l33
l32:
	%t25 = add i32 1337, 0
	br i1 %t25, label %l34, label %l35
l34:
	%t26 = add i32 1337, 0
	ret %t26
	br label %l36
l35:
	%t27 = add i32 1337, 0
	br i1 %t27, label %l37, label %l38
l37:
	%t28 = add i32 1337, 0
	ret %t28
	br label %l39
l38:
	%t29 = add i32 1337, 0
	br i1 %t29, label %l40, label %l41
l40:
	%t30 = add i32 1337, 0
	ret %t30
	br label %l42
l41:
	%t31 = add i32 1337, 0
	br i1 %t31, label %l43, label %l44
l43:
	%t32 = add i32 1337, 0
	ret %t32
	br label %l45
l44:
	%t33 = add i32 1337, 0
	br i1 %t33, label %l46, label %l47
l46:
	%t34 = add i32 1337, 0
	ret %t34
	br label %l48
l47:
	%t35 = add i32 1337, 0
	br i1 %t35, label %l49, label %l50
l49:
	%t36 = add i32 1337, 0
	ret %t36
	br label %l51
l50:
	%t37 = add i32 1337, 0
	br i1 %t37, label %l52, label %l53
l52:
	%t38 = add i32 1337, 0
	ret %t38
	br label %l54
l53:
	%t39 = add i32 1337, 0
	br i1 %t39, label %l55, label %l56
l55:
	%t40 = add i32 1337, 0
	ret %t40
	br label %l57
l56:
	%t41 = add i32 1337, 0
	br i1 %t41, label %l58, label %l59
l58:
	%t42 = add i32 1337, 0
	ret %t42
	br label %l60
l59:
	%t43 = add i32 1337, 0
	br i1 %t43, label %l61, label %l62
l61:
	%t44 = add i32 1337, 0
	ret %t44
	br label %l63
l62:
	%t45 = add i32 1337, 0
	br i1 %t45, label %l64, label %l65
l64:
	%t46 = add i32 1337, 0
	ret %t46
	br label %l66
l65:
	%t47 = add i32 1337, 0
	br i1 %t47, label %l67, label %l68
l67:
	%t48 = add i32 1337, 0
	ret %t48
	br label %l69
l68:
	%t49 = add i32 1337, 0
	br i1 %t49, label %l70, label %l71
l70:
	%t50 = add i32 1337, 0
	ret %t50
	br label %l72
l71:
	%t51 = add i32 1337, 0
	br i1 %t51, label %l73, label %l74
l73:
	%t52 = add i32 1337, 0
	ret %t52
	br label %l75
l74:
	%t53 = add i32 1337, 0
	br i1 %t53, label %l76, label %l77
l76:
	%t54 = add i32 1337, 0
	ret %t54
	br label %l78
l77:
	%t55 = add i32 1337, 0
	br i1 %t55, label %l79, label %l80
l79:
	%t56 = add i32 1337, 0
	ret %t56
	br label %l81
l80:
	%t57 = add i32 1337, 0
	br i1 %t57, label %l82, label %l83
l82:
	%t58 = add i32 1337, 0
	ret %t58
	br label %l84
l83:
	%t59 = add i32 1337, 0
	br i1 %t59, label %l85, label %l86
l85:
	%t60 = add i32 1337, 0
	ret %t60
	br label %l87
l86:
	%t61 = add i32 1337, 0
	br i1 %t61, label %l88, label %l89
l88:
	%t62 = add i32 1337, 0
	ret %t62
	br label %l90
l89:
	%t63 = add i32 1337, 0
	br i1 %t63, label %l91, label %l92
l91:
	%t64 = add i32 1337, 0
	ret %t64
	br label %l93
l92:
	%t65 = add i32 1337, 0
	br i1 %t65, label %l94, label %l95
l94:
	%t66 = add i32 1337, 0
	ret %t66
	br label %l96
l95:
	%t67 = add i32 1337, 0
	br i1 %t67, label %l97, label %l98
l97:
	%t68 = add i32 1337, 0
	ret %t68
	br label %l99
l98:
	%t69 = add i32 1337, 0
	br i1 %t69, label %l100, label %l101
l100:
	%t70 = add i32 1337, 0
	ret %t70
	br label %l102
l101:
	%t71 = add i32 1337, 0
	br i1 %t71, label %l103, label %l104
l103:
	%t72 = add i32 1337, 0
	ret %t72
	br label %l105
l104:
	%t73 = add i32 1337, 0
	br i1 %t73, label %l106, label %l107
l106:
	%t74 = add i32 1337, 0
	ret %t74
	br label %l108
l107:
	%t75 = add i32 1337, 0
	br i1 %t75, label %l109, label %l110
l109:
	%t76 = add i32 1337, 0
	ret %t76
	br label %l111
l110:
	%t77 = add i32 1337, 0
	br i1 %t77, label %l112, label %l113
l112:
	%t78 = add i32 1337, 0
	ret %t78
	br label %l114
l113:
	%t79 = add i32 1337, 0
	br i1 %t79, label %l115, label %l116
l115:
	%t80 = add i32 1337, 0
	ret %t80
	br label %l117
l116:
	%t81 = add i32 1337, 0
	br i1 %t81, label %l118, label %l119
l118:
	%t82 = add i32 1337, 0
	ret %t82
	br label %l120
l119:
	%t83 = add i32 1337, 0
	br i1 %t83, label %l121, label %l122
l121:
	%t84 = add i32 1337, 0
	ret %t84
	br label %l123
l122:
	%t85 = add i32 1337, 0
	br i1 %t85, label %l124, label %l125
l124:
	%t86 = add i32 1337, 0
	ret %t86
	br label %l126
l125:
	%t87 = add i32 1337, 0
	br i1 %t87, label %l127, label %l128
l127:
	%t88 = add i32 1337, 0
	ret %t88
	br label %l129
l128:
	%t89 = add i32 1337, 0
	br i1 %t89, label %l130, label %l131
l130:
	%t90 = add i32 1337, 0
	ret %t90
	br label %l132
l131:
	%t91 = add i32 1337, 0
	br i1 %t91, label %l133, label %l134
l133:
	%t92 = add i32 1337, 0
	ret %t92
	br label %l135
l134:
	%t93 = add i32 1337, 0
	br i1 %t93, label %l136, label %l137
l136:
	%t94 = add i32 1337, 0
	ret %t94
	br label %l138
l137:
	%t95 = add i32 1337, 0
	br i1 %t95, label %l139, label %l140
l139:
	%t96 = add i32 1337, 0
	ret %t96
	br label %l141
l140:
	%t97 = add i32 1337, 0
	br i1 %t97, label %l142, label %l143
l142:
	%t98 = add i32 1337, 0
	ret %t98
	br label %l144
l143:
	%t99 = add i32 1337, 0
	br i1 %t99, label %l145, label %l146
l145:
	%t100 = add i32 1337, 0
	ret %t100
	br label %l147
l146:
	%t101 = add i32 1337, 0
	br i1 %t101, label %l148, label %l149
l148:
	%t102 = add i32 1337, 0
	ret %t102
	br label %l150
l149:
	%t103 = add i32 1337, 0
	br i1 %t103, label %l151, label %l152
l151:
	%t104 = add i32 1337, 0
	ret %t104
	br label %l153
l152:
	%t105 = add i32 1337, 0
	br i1 %t105, label %l154, label %l155
l154:
	%t106 = add i32 1337, 0
	ret %t106
	br label %l156
l155:
	%t107 = add i32 1337, 0
	br i1 %t107, label %l157, label %l158
l157:
	%t108 = add i32 1337, 0
	ret %t108
	br label %l159
l158:
	%t109 = add i32 1337, 0
	br i1 %t109, label %l160, label %l161
l160:
	%t110 = add i32 1337, 0
	ret %t110
	br label %l162
l161:
	%t111 = add i32 1337, 0
	br i1 %t111, label %l163, label %l164
l163:
	%t112 = add i32 1337, 0
	ret %t112
	br label %l165
l164:
	%t113 = add i32 1337, 0
	br i1 %t113, label %l166, label %l167
l166:
	%t114 = add i32 1337, 0
	ret %t114
	br label %l168
l167:
	%t115 = add i32 1337, 0
	br i1 %t115, label %l169, label %l170
l169:
	%t116 = add i32 1337, 0
	ret %t116
	br label %l171
l170:
	%t117 = add i32 1337, 0
	br i1 %t117, label %l172, label %l173
l172:
	%t118 = add i32 1337, 0
	ret %t118
	br label %l174
l173:
	%t119 = add i32 1337, 0
	br i1 %t119, label %l175, label %l176
l175:
	%t120 = add i32 1337, 0
	ret %t120
	br label %l177
l176:
	%t121 = add i32 1337, 0
	br i1 %t121, label %l178, label %l179
l178:
	%t122 = add i32 1337, 0
	ret %t122
	br label %l180
l179:
	%t123 = add i32 1337, 0
	br i1 %t123, label %l181, label %l182
l181:
	%t124 = add i32 1337, 0
	ret %t124
	br label %l183
l182:
	%t125 = add i32 1337, 0
	br i1 %t125, label %l184, label %l185
l184:
	%t126 = add i32 1337, 0
	ret %t126
	br label %l186
l185:
	%t127 = add i32 1337, 0
	br i1 %t127, label %l187, label %l188
l187:
	%t128 = add i32 1337, 0
	ret %t128
	br label %l189
l188:
	%t129 = add i32 1337, 0
	br i1 %t129, label %l190, label %l191
l190:
	%t130 = add i32 1337, 0
	ret %t130
	br label %l192
l191:
	%t131 = add i32 1337, 0
	br i1 %t131, label %l193, label %l194
l193:
	%t132 = add i32 1337, 0
	ret %t132
	br label %l195
l194:
	%t133 = add i32 1337, 0
	br i1 %t133, label %l196, label %l197
l196:
	%t134 = add i32 1337, 0
	ret %t134
	br label %l198
l197:
	%t135 = add i32 1337, 0
	br i1 %t135, label %l199, label %l200
l199:
	%t136 = add i32 1337, 0
	ret %t136
	br label %l201
l200:
	%t137 = add i32 1337, 0
	br i1 %t137, label %l202, label %l203
l202:
	%t138 = add i32 1337, 0
	ret %t138
	br label %l204
l203:
	%t139 = add i32 1337, 0
	br i1 %t139, label %l205, label %l206
l205:
	%t140 = add i32 1337, 0
	ret %t140
	br label %l207
l206:
	%t141 = add i32 1337, 0
	br i1 %t141, label %l208, label %l209
l208:
	%t142 = add i32 1337, 0
	ret %t142
	br label %l210
l209:
	%t143 = add i32 1337, 0
	br i1 %t143, label %l211, label %l212
l211:
	%t144 = add i32 1337, 0
	ret %t144
	br label %l213
l212:
	%t145 = add i32 1337, 0
	br i1 %t145, label %l214, label %l215
l214:
	%t146 = add i32 1337, 0
	ret %t146
	br label %l216
l215:
	%t147 = add i32 1337, 0
	br i1 %t147, label %l217, label %l218
l217:
	%t148 = add i32 1337, 0
	ret %t148
	br label %l218
l218:
	br label %l216
l216:
	br label %l213
l213:
	br label %l210
l210:
	br label %l207
l207:
	br label %l204
l204:
	br label %l201
l201:
	br label %l198
l198:
	br label %l195
l195:
	br label %l192
l192:
	br label %l189
l189:
	br label %l186
l186:
	br label %l183
l183:
	br label %l180
l180:
	br label %l177
l177:
	br label %l174
l174:
	br label %l171
l171:
	br label %l168
l168:
	br label %l165
l165:
	br label %l162
l162:
	br label %l159
l159:
	br label %l156
l156:
	br label %l153
l153:
	br label %l150
l150:
	br label %l147
l147:
	br label %l144
l144:
	br label %l141
l141:
	br label %l138
l138:
	br label %l135
l135:
	br label %l132
l132:
	br label %l129
l129:
	br label %l126
l126:
	br label %l123
l123:
	br label %l120
l120:
	br label %l117
l117:
	br label %l114
l114:
	br label %l111
l111:
	br label %l108
l108:
	br label %l105
l105:
	br label %l102
l102:
	br label %l99
l99:
	br label %l96
l96:
	br label %l93
l93:
	br label %l90
l90:
	br label %l87
l87:
	br label %l84
l84:
	br label %l81
l81:
	br label %l78
l78:
	br label %l75
l75:
	br label %l72
l72:
	br label %l69
l69:
	br label %l66
l66:
	br label %l63
l63:
	br label %l60
l60:
	br label %l57
l57:
	br label %l54
l54:
	br label %l51
l51:
	br label %l48
l48:
	br label %l45
l45:
	br label %l42
l42:
	br label %l39
l39:
	br label %l36
l36:
	br label %l33
l33:
	%t149 = add i32 1337, 0
	ret %t149
}
define i16 @insert_symbol(i8* %a0, i32 %a1, %struct.vector.Vec.struct.string.String* %a2){
	%t3 = alloca i16
	%t4 = add i32 1337, 0
	ret %t4
}
define void @handle_number(i8* %a0, i32 %a1, i32 %a2, %struct.vector.Vec.struct.TokenData* %a3, %struct.vector.Vec.struct.string.String* %a4){
	%t5 = alloca i16
	%t6 = alloca %struct.TokenData
	ret void
}
define void @handle_decimal_number(i8* %a0, i32 %a1, i32 %a2, %struct.vector.Vec.struct.TokenData* %a3, %struct.vector.Vec.struct.string.String* %a4){
	%t5 = alloca i16
	%t6 = alloca %struct.TokenData
	ret void
}
define void @handle_string(i8* %a0, i32 %a1, i32 %a2, %struct.vector.Vec.struct.TokenData* %a3, %struct.vector.Vec.struct.string.String* %a4){
	%t5 = alloca i32
	%t6 = alloca i8*
	%t7 = alloca i8*
	%t8 = alloca i32
	%t9 = alloca i32
l0:
	%t10 = add i32 1337, 0
	br i1 %t10, label %l2, label %l1
l2:
	%t11 = alloca i8
	%t12 = add i32 1337, 0
	br i1 %t12, label %l3, label %l4
l3:
	%t13 = alloca i8
	%t14 = alloca i8
	%t15 = add i32 1337, 0
	br i1 %t15, label %l5, label %l6
l5:
	br label %l7
l6:
	%t16 = add i32 1337, 0
	br i1 %t16, label %l8, label %l9
l8:
	br label %l10
l9:
	%t17 = add i32 1337, 0
	br i1 %t17, label %l11, label %l12
l11:
	br label %l13
l12:
	%t18 = add i32 1337, 0
	br i1 %t18, label %l14, label %l15
l14:
	br label %l16
l15:
	%t19 = add i32 1337, 0
	br i1 %t19, label %l17, label %l18
l17:
	br label %l19
l18:
	%t20 = add i32 1337, 0
	br i1 %t20, label %l20, label %l21
l20:
	br label %l22
l21:
	%t21 = add i32 1337, 0
	br i1 %t21, label %l23, label %l24
l23:
	br label %l25
l24:
	%t22 = add i32 1337, 0
	br i1 %t22, label %l26, label %l27
l26:
	br label %l28
l27:
	%t23 = add i32 1337, 0
	br i1 %t23, label %l29, label %l30
l29:
	br label %l31
l30:
	%t24 = alloca i8*
	br label %l31
l31:
	br label %l28
l28:
	br label %l25
l25:
	br label %l22
l22:
	br label %l19
l19:
	br label %l16
l16:
	br label %l13
l13:
	br label %l10
l10:
	br label %l7
l7:
	br label %l0
	br label %l4
l4:
	br label %l0
	br label %l1
l1:
	%t25 = alloca i16
	%t26 = alloca %struct.TokenData
	ret void
}
define void @handle_char(i8* %a0, i32 %a1, i32 %a2, %struct.vector.Vec.struct.TokenData* %a3, %struct.vector.Vec.struct.string.String* %a4){
	%t5 = alloca i32
	%t6 = alloca i8*
	%t7 = alloca i8
	%t8 = add i32 1337, 0
	br i1 %t8, label %l0, label %l1
l0:
	%t9 = alloca i8
	%t10 = alloca i16
	%t11 = add i32 1337, 0
	br i1 %t11, label %l2, label %l3
l2:
	br label %l4
l3:
	%t12 = add i32 1337, 0
	br i1 %t12, label %l5, label %l6
l5:
	br label %l7
l6:
	%t13 = add i32 1337, 0
	br i1 %t13, label %l8, label %l9
l8:
	br label %l10
l9:
	%t14 = add i32 1337, 0
	br i1 %t14, label %l11, label %l12
l11:
	br label %l13
l12:
	%t15 = add i32 1337, 0
	br i1 %t15, label %l14, label %l15
l14:
	br label %l16
l15:
	%t16 = add i32 1337, 0
	br i1 %t16, label %l17, label %l18
l17:
	br label %l19
l18:
	%t17 = add i32 1337, 0
	br i1 %t17, label %l20, label %l21
l20:
	br label %l22
l21:
	%t18 = add i32 1337, 0
	br i1 %t18, label %l23, label %l24
l23:
	br label %l25
l24:
	br label %l25
l25:
	br label %l22
l22:
	br label %l19
l19:
	br label %l16
l16:
	br label %l13
l13:
	br label %l10
l10:
	br label %l7
l7:
	br label %l4
l4:
	%t19 = alloca %struct.TokenData
	%t20 = add i32 1337, 0
	br i1 %t20, label %l26, label %l27
l26:
	br label %l27
l27:
	ret void
	br label %l1
l1:
	%t21 = add i32 1337, 0
	br i1 %t21, label %l28, label %l29
l28:
	br label %l29
l29:
	%t22 = alloca %struct.TokenData
	ret void
}
define void @handle_symbol(i8* %a0, i32 %a1, i32 %a2, %struct.vector.Vec.struct.TokenData* %a3, %struct.vector.Vec.struct.string.String* %a4){
	%t5 = alloca i32
	%t6 = alloca i8*
	%t7 = add i32 1337, 0
	br i1 %t7, label %l0, label %l1
l0:
	%t8 = add i32 1337, 0
	br i1 %t8, label %l3, label %l4
l3:
	%t9 = alloca %struct.TokenData
	ret void
	br label %l4
l4:
	%t10 = add i32 1337, 0
	br i1 %t10, label %l5, label %l6
l5:
	%t11 = alloca %struct.TokenData
	ret void
	br label %l6
l6:
	%t12 = add i32 1337, 0
	br i1 %t12, label %l7, label %l8
l7:
	%t13 = alloca %struct.TokenData
	ret void
	br label %l8
l8:
	%t14 = add i32 1337, 0
	br i1 %t14, label %l9, label %l10
l9:
	%t15 = alloca %struct.TokenData
	ret void
	br label %l10
l10:
	%t16 = add i32 1337, 0
	br i1 %t16, label %l11, label %l12
l11:
	%t17 = alloca %struct.TokenData
	ret void
	br label %l12
l12:
	br label %l2
l1:
	%t18 = add i32 1337, 0
	br i1 %t18, label %l13, label %l14
l13:
	%t19 = add i32 1337, 0
	br i1 %t19, label %l16, label %l17
l16:
	%t20 = alloca %struct.TokenData
	ret void
	br label %l17
l17:
	%t21 = add i32 1337, 0
	br i1 %t21, label %l18, label %l19
l18:
	%t22 = alloca %struct.TokenData
	ret void
	br label %l19
l19:
	%t23 = add i32 1337, 0
	br i1 %t23, label %l20, label %l21
l20:
	%t24 = alloca %struct.TokenData
	ret void
	br label %l21
l21:
	br label %l15
l14:
	%t25 = add i32 1337, 0
	br i1 %t25, label %l22, label %l23
l22:
	%t26 = add i32 1337, 0
	br i1 %t26, label %l25, label %l26
l25:
	%t27 = alloca %struct.TokenData
	ret void
	br label %l26
l26:
	%t28 = add i32 1337, 0
	br i1 %t28, label %l27, label %l28
l27:
	%t29 = alloca %struct.TokenData
	ret void
	br label %l28
l28:
	%t30 = add i32 1337, 0
	br i1 %t30, label %l29, label %l30
l29:
	%t31 = alloca %struct.TokenData
	ret void
	br label %l30
l30:
	%t32 = add i32 1337, 0
	br i1 %t32, label %l31, label %l32
l31:
	%t33 = alloca %struct.TokenData
	ret void
	br label %l32
l32:
	%t34 = add i32 1337, 0
	br i1 %t34, label %l33, label %l34
l33:
	%t35 = alloca %struct.TokenData
	ret void
	br label %l34
l34:
	%t36 = add i32 1337, 0
	br i1 %t36, label %l35, label %l36
l35:
	%t37 = alloca %struct.TokenData
	ret void
	br label %l36
l36:
	%t38 = add i32 1337, 0
	br i1 %t38, label %l37, label %l38
l37:
	%t39 = alloca %struct.TokenData
	ret void
	br label %l38
l38:
	br label %l24
l23:
	%t40 = add i32 1337, 0
	br i1 %t40, label %l39, label %l40
l39:
	%t41 = add i32 1337, 0
	br i1 %t41, label %l42, label %l43
l42:
	%t42 = alloca %struct.TokenData
	ret void
	br label %l43
l43:
	%t43 = add i32 1337, 0
	br i1 %t43, label %l44, label %l45
l44:
	%t44 = alloca %struct.TokenData
	ret void
	br label %l45
l45:
	%t45 = add i32 1337, 0
	br i1 %t45, label %l46, label %l47
l46:
	%t46 = alloca %struct.TokenData
	ret void
	br label %l47
l47:
	%t47 = add i32 1337, 0
	br i1 %t47, label %l48, label %l49
l48:
	%t48 = alloca %struct.TokenData
	ret void
	br label %l49
l49:
	%t49 = add i32 1337, 0
	br i1 %t49, label %l50, label %l51
l50:
	%t50 = alloca %struct.TokenData
	ret void
	br label %l51
l51:
	%t51 = add i32 1337, 0
	br i1 %t51, label %l52, label %l53
l52:
	%t52 = alloca %struct.TokenData
	ret void
	br label %l53
l53:
	br label %l41
l40:
	%t53 = add i32 1337, 0
	br i1 %t53, label %l54, label %l55
l54:
	%t54 = add i32 1337, 0
	br i1 %t54, label %l57, label %l58
l57:
	%t55 = alloca %struct.TokenData
	ret void
	br label %l58
l58:
	%t56 = add i32 1337, 0
	br i1 %t56, label %l59, label %l60
l59:
	%t57 = alloca %struct.TokenData
	ret void
	br label %l60
l60:
	%t58 = add i32 1337, 0
	br i1 %t58, label %l61, label %l62
l61:
	%t59 = alloca %struct.TokenData
	ret void
	br label %l62
l62:
	%t60 = add i32 1337, 0
	br i1 %t60, label %l63, label %l64
l63:
	%t61 = alloca %struct.TokenData
	ret void
	br label %l64
l64:
	%t62 = add i32 1337, 0
	br i1 %t62, label %l65, label %l66
l65:
	%t63 = alloca %struct.TokenData
	ret void
	br label %l66
l66:
	br label %l56
l55:
	%t64 = add i32 1337, 0
	br i1 %t64, label %l67, label %l68
l67:
	%t65 = add i32 1337, 0
	br i1 %t65, label %l70, label %l71
l70:
	%t66 = alloca %struct.TokenData
	ret void
	br label %l71
l71:
	%t67 = add i32 1337, 0
	br i1 %t67, label %l72, label %l73
l72:
	%t68 = alloca %struct.TokenData
	ret void
	br label %l73
l73:
	br label %l69
l68:
	%t69 = add i32 1337, 0
	br i1 %t69, label %l74, label %l75
l74:
	%t70 = add i32 1337, 0
	br i1 %t70, label %l76, label %l77
l76:
	%t71 = alloca %struct.TokenData
	ret void
	br label %l77
l77:
	br label %l75
l75:
	br label %l69
l69:
	br label %l56
l56:
	br label %l41
l41:
	br label %l24
l24:
	br label %l15
l15:
	br label %l2
l2:
	%t72 = alloca i16
	%t73 = alloca %struct.TokenData
	ret void
}
define void @lex(%struct.string.String* %a0, %struct.vector.Vec.struct.TokenData* %a1, %struct.vector.Vec.struct.string.String* %a2){
	%t3 = alloca i32
l0:
	%t4 = add i32 1337, 0
	br i1 %t4, label %l2, label %l1
l2:
	%t5 = alloca i8
	%t6 = add i32 1337, 0
	br i1 %t6, label %l3, label %l4
l3:
	br label %l0
	br label %l4
l4:
	%t7 = alloca i8
	%t8 = add i32 1337, 0
	br i1 %t8, label %l5, label %l6
l5:
	br label %l7
l6:
	br label %l7
l7:
	%t9 = alloca i8
	%t10 = add i32 1337, 0
	br i1 %t10, label %l8, label %l9
l8:
	br label %l10
l9:
	br label %l10
l10:
	%t11 = add i32 1337, 0
	br i1 %t11, label %l11, label %l12
l11:
	%t12 = alloca i32
l14:
	%t13 = add i32 1337, 0
	br i1 %t13, label %l16, label %l15
l16:
	%t14 = add i32 1337, 0
	br i1 %t14, label %l17, label %l18
l17:
	br label %l14
	br label %l18
l18:
	br label %l15
	br label %l14
	br label %l15
l15:
	br label %l0
	br label %l13
l12:
	%t15 = add i32 1337, 0
	br i1 %t15, label %l19, label %l20
l19:
	%t16 = alloca i32
	%t17 = add i32 1337, 0
	br i1 %t17, label %l22, label %l23
l22:
	br label %l23
l23:
	%t18 = add i32 1337, 0
	br i1 %t18, label %l24, label %l25
l24:
	%t19 = add i32 1337, 0
	br i1 %t19, label %l26, label %l27
l26:
	br label %l28
l27:
	%t20 = add i32 1337, 0
	br i1 %t20, label %l29, label %l30
l29:
	br label %l30
l30:
	br label %l28
l28:
	br label %l25
l25:
	%t21 = alloca i1
l31:
	%t22 = add i32 1337, 0
	br i1 %t22, label %l33, label %l32
l33:
	%t23 = add i32 1337, 0
	br i1 %t23, label %l34, label %l35
l34:
	br label %l31
	br label %l35
l35:
	%t24 = add i32 1337, 0
	br i1 %t24, label %l36, label %l37
l36:
	%t25 = add i32 1337, 0
	br i1 %t25, label %l38, label %l39
l38:
	br label %l31
	br label %l39
l39:
	br label %l37
l37:
	br label %l32
	br label %l31
	br label %l32
l32:
	%t26 = add i32 1337, 0
	br i1 %t26, label %l40, label %l41
l40:
	br label %l42
l41:
	br label %l42
l42:
	br label %l0
	br label %l21
l20:
	%t27 = add i32 1337, 0
	br i1 %t27, label %l43, label %l44
l43:
	%t28 = alloca i32
	%t29 = alloca i1
l46:
	%t30 = add i32 1337, 0
	br i1 %t30, label %l48, label %l47
l48:
	%t31 = add i32 1337, 0
	br i1 %t31, label %l49, label %l50
l49:
	%t32 = add i32 1337, 0
	br i1 %t32, label %l51, label %l52
l51:
	br label %l46
	br label %l53
l52:
	br label %l47
	br label %l53
l53:
	br label %l50
l50:
	%t33 = add i32 1337, 0
	br i1 %t33, label %l54, label %l55
l54:
	br label %l46
	br label %l55
l55:
	%t34 = add i32 1337, 0
	br i1 %t34, label %l56, label %l57
l56:
	br label %l57
l57:
	br label %l46
	br label %l46
	br label %l47
l47:
	br label %l0
	br label %l45
l44:
	%t35 = add i32 1337, 0
	br i1 %t35, label %l58, label %l59
l58:
	%t36 = alloca i32
	%t37 = alloca i1
l61:
	%t38 = add i32 1337, 0
	br i1 %t38, label %l63, label %l62
l63:
	%t39 = add i32 1337, 0
	br i1 %t39, label %l64, label %l65
l64:
	%t40 = add i32 1337, 0
	br i1 %t40, label %l66, label %l67
l66:
	br label %l61
	br label %l68
l67:
	br label %l62
	br label %l68
l68:
	br label %l65
l65:
	%t41 = add i32 1337, 0
	br i1 %t41, label %l69, label %l70
l69:
	br label %l61
	br label %l70
l70:
	%t42 = add i32 1337, 0
	br i1 %t42, label %l71, label %l72
l71:
	br label %l72
l72:
	br label %l61
	br label %l61
	br label %l62
l62:
	br label %l0
	br label %l60
l59:
	%t43 = add i32 1337, 0
	br i1 %t43, label %l73, label %l74
l73:
	%t44 = alloca i32
l76:
	%t45 = add i32 1337, 0
	br i1 %t45, label %l78, label %l77
l78:
	%t46 = add i32 1337, 0
	br i1 %t46, label %l79, label %l80
l79:
	br label %l77
	br label %l80
l80:
	br label %l76
	br label %l76
	br label %l77
l77:
	%t47 = alloca i32
	br label %l0
	br label %l75
l74:
	%t48 = add i32 1337, 0
	br i1 %t48, label %l81, label %l82
l81:
	%t49 = alloca i32
	%t50 = alloca i32
	%t51 = alloca i1
l83:
	%t52 = add i32 1337, 0
	br i1 %t52, label %l85, label %l84
l85:
	%t53 = add i32 1337, 0
	br i1 %t53, label %l86, label %l87
l86:
	%t54 = add i32 1337, 0
	br i1 %t54, label %l88, label %l89
l88:
	br label %l83
	br label %l89
l89:
	%t55 = add i32 1337, 0
	br i1 %t55, label %l90, label %l91
l90:
	%t56 = add i32 1337, 0
	br i1 %t56, label %l92, label %l93
l92:
	br label %l84
	br label %l93
l93:
	br label %l83
	br label %l91
l91:
	br label %l87
l87:
	br label %l83
	br label %l84
l84:
	%t57 = alloca i32
	br label %l0
	br label %l82
l82:
	br label %l75
l75:
	br label %l60
l60:
	br label %l45
l45:
	br label %l21
l21:
	br label %l13
l13:
	%t58 = alloca i8
	%t59 = add i32 1337, 0
	br i1 %t59, label %l94, label %l95
l94:
	br label %l96
l95:
	%t60 = add i32 1337, 0
	br i1 %t60, label %l97, label %l98
l97:
	br label %l99
l98:
	%t61 = add i32 1337, 0
	br i1 %t61, label %l100, label %l101
l100:
	br label %l102
l101:
	%t62 = add i32 1337, 0
	br i1 %t62, label %l103, label %l104
l103:
	br label %l105
l104:
	%t63 = add i32 1337, 0
	br i1 %t63, label %l106, label %l107
l106:
	br label %l108
l107:
	%t64 = add i32 1337, 0
	br i1 %t64, label %l109, label %l110
l109:
	br label %l111
l110:
	%t65 = add i32 1337, 0
	br i1 %t65, label %l112, label %l113
l112:
	br label %l114
l113:
	%t66 = add i32 1337, 0
	br i1 %t66, label %l115, label %l116
l115:
	%t67 = add i32 1337, 0
	br i1 %t67, label %l118, label %l119
l118:
	br label %l120
l119:
	br label %l120
l120:
	br label %l117
l116:
	%t68 = add i32 1337, 0
	br i1 %t68, label %l121, label %l122
l121:
	%t69 = add i32 1337, 0
	br i1 %t69, label %l124, label %l125
l124:
	br label %l126
l125:
	%t70 = add i32 1337, 0
	br i1 %t70, label %l127, label %l128
l127:
	br label %l129
l128:
	br label %l129
l129:
	br label %l126
l126:
	br label %l123
l122:
	%t71 = add i32 1337, 0
	br i1 %t71, label %l130, label %l131
l130:
	br label %l132
l131:
	%t72 = add i32 1337, 0
	br i1 %t72, label %l133, label %l134
l133:
	br label %l135
l134:
	%t73 = add i32 1337, 0
	br i1 %t73, label %l136, label %l137
l136:
	br label %l138
l137:
	%t74 = add i32 1337, 0
	br i1 %t74, label %l139, label %l140
l139:
	br label %l141
l140:
	%t75 = add i32 1337, 0
	br i1 %t75, label %l142, label %l143
l142:
	br label %l144
l143:
	%t76 = add i32 1337, 0
	br i1 %t76, label %l145, label %l146
l145:
	br label %l147
l146:
	%t77 = add i32 1337, 0
	br i1 %t77, label %l148, label %l149
l148:
	br label %l150
l149:
	%t78 = add i32 1337, 0
	br i1 %t78, label %l151, label %l152
l151:
	%t79 = add i32 1337, 0
	br i1 %t79, label %l154, label %l155
l154:
	br label %l156
l155:
	br label %l156
l156:
	br label %l153
l152:
	%t80 = add i32 1337, 0
	br i1 %t80, label %l157, label %l158
l157:
	%t81 = add i32 1337, 0
	br i1 %t81, label %l160, label %l161
l160:
	br label %l162
l161:
	br label %l162
l162:
	br label %l159
l158:
	%t82 = add i32 1337, 0
	br i1 %t82, label %l163, label %l164
l163:
	%t83 = add i32 1337, 0
	br i1 %t83, label %l166, label %l167
l166:
	br label %l168
l167:
	br label %l168
l168:
	br label %l165
l164:
	%t84 = add i32 1337, 0
	br i1 %t84, label %l169, label %l170
l169:
	%t85 = add i32 1337, 0
	br i1 %t85, label %l172, label %l173
l172:
	%t86 = add i32 1337, 0
	br i1 %t86, label %l175, label %l176
l175:
	br label %l177
l176:
	br label %l177
l177:
	br label %l174
l173:
	br label %l174
l174:
	br label %l171
l170:
	%t87 = add i32 1337, 0
	br i1 %t87, label %l178, label %l179
l178:
	%t88 = add i32 1337, 0
	br i1 %t88, label %l181, label %l182
l181:
	br label %l183
l182:
	br label %l183
l183:
	br label %l180
l179:
	%t89 = add i32 1337, 0
	br i1 %t89, label %l184, label %l185
l184:
	%t90 = add i32 1337, 0
	br i1 %t90, label %l187, label %l188
l187:
	br label %l189
l188:
	br label %l189
l189:
	br label %l186
l185:
	%t91 = add i32 1337, 0
	br i1 %t91, label %l190, label %l191
l190:
	br label %l192
l191:
	%t92 = add i32 1337, 0
	br i1 %t92, label %l193, label %l194
l193:
	br label %l194
l194:
	br label %l192
l192:
	br label %l186
l186:
	br label %l180
l180:
	br label %l171
l171:
	br label %l165
l165:
	br label %l159
l159:
	br label %l153
l153:
	br label %l150
l150:
	br label %l147
l147:
	br label %l144
l144:
	br label %l141
l141:
	br label %l138
l138:
	br label %l135
l135:
	br label %l132
l132:
	br label %l123
l123:
	br label %l117
l117:
	br label %l114
l114:
	br label %l111
l111:
	br label %l108
l108:
	br label %l105
l105:
	br label %l102
l102:
	br label %l99
l99:
	br label %l96
l96:
	%t93 = add i32 1337, 0
	br i1 %t93, label %l195, label %l196
l195:
	%t94 = alloca %struct.TokenData
	br label %l0
	br label %l196
l196:
	br label %l0
	br label %l1
l1:
	ret void
}
define i1 @is_prefix_operator(i8 %a0){
	%t1 = add i32 1337, 0
	ret %t1
}
define i8 @precedence(i8 %a0){
	%t1 = add i32 1337, 0
	br i1 %t1, label %l0, label %l1
l0:
	%t2 = add i32 1337, 0
	ret %t2
	br label %l1
l1:
	%t3 = add i32 1337, 0
	br i1 %t3, label %l2, label %l3
l2:
	%t4 = add i32 1337, 0
	ret %t4
	br label %l3
l3:
	%t5 = add i32 1337, 0
	br i1 %t5, label %l4, label %l5
l4:
	%t6 = add i32 1337, 0
	ret %t6
	br label %l5
l5:
	%t7 = add i32 1337, 0
	br i1 %t7, label %l6, label %l7
l6:
	%t8 = add i32 1337, 0
	ret %t8
	br label %l7
l7:
	%t9 = add i32 1337, 0
	br i1 %t9, label %l8, label %l9
l8:
	%t10 = add i32 1337, 0
	ret %t10
	br label %l9
l9:
	%t11 = add i32 1337, 0
	br i1 %t11, label %l10, label %l11
l10:
	%t12 = add i32 1337, 0
	ret %t12
	br label %l11
l11:
	%t13 = add i32 1337, 0
	br i1 %t13, label %l12, label %l13
l12:
	%t14 = add i32 1337, 0
	ret %t14
	br label %l13
l13:
	%t15 = add i32 1337, 0
	br i1 %t15, label %l14, label %l15
l14:
	%t16 = add i32 1337, 0
	ret %t16
	br label %l15
l15:
	%t17 = add i32 1337, 0
	br i1 %t17, label %l16, label %l17
l16:
	%t18 = add i32 1337, 0
	ret %t18
	br label %l17
l17:
	%t19 = add i32 1337, 0
	br i1 %t19, label %l18, label %l19
l18:
	%t20 = add i32 1337, 0
	ret %t20
	br label %l19
l19:
	%t21 = add i32 1337, 0
	br i1 %t21, label %l20, label %l21
l20:
	%t22 = add i32 1337, 0
	ret %t22
	br label %l21
l21:
	%t23 = add i32 1337, 0
	br i1 %t23, label %l22, label %l23
l22:
	%t24 = add i32 1337, 0
	ret %t24
	br label %l23
l23:
	%t25 = add i32 1337, 0
	br i1 %t25, label %l24, label %l25
l24:
	%t26 = add i32 1337, 0
	ret %t26
	br label %l25
l25:
	%t27 = add i32 1337, 0
	br i1 %t27, label %l26, label %l27
l26:
	%t28 = add i32 1337, 0
	ret %t28
	br label %l27
l27:
	%t29 = add i32 1337, 0
	ret %t29
}
define i8 @get_unary_op(i8 %a0){
	%t1 = add i32 1337, 0
	br i1 %t1, label %l0, label %l1
l0:
	%t2 = add i32 1337, 0
	ret %t2
	br label %l1
l1:
	%t3 = add i32 1337, 0
	br i1 %t3, label %l2, label %l3
l2:
	%t4 = add i32 1337, 0
	ret %t4
	br label %l3
l3:
	%t5 = add i32 1337, 0
	br i1 %t5, label %l4, label %l5
l4:
	%t6 = add i32 1337, 0
	ret %t6
	br label %l5
l5:
	%t7 = add i32 1337, 0
	br i1 %t7, label %l6, label %l7
l6:
	%t8 = add i32 1337, 0
	ret %t8
	br label %l7
l7:
	%t9 = add i32 1337, 0
	br i1 %t9, label %l8, label %l9
l8:
	%t10 = add i32 1337, 0
	ret %t10
	br label %l9
l9:
	%t11 = add i32 1337, 0
	ret %t11
}
define i8 @get_binary_op(i8 %a0){
	%t1 = add i32 1337, 0
	br i1 %t1, label %l0, label %l1
l0:
	%t2 = add i32 1337, 0
	ret %t2
	br label %l1
l1:
	%t3 = add i32 1337, 0
	br i1 %t3, label %l2, label %l3
l2:
	%t4 = add i32 1337, 0
	ret %t4
	br label %l3
l3:
	%t5 = add i32 1337, 0
	br i1 %t5, label %l4, label %l5
l4:
	%t6 = add i32 1337, 0
	ret %t6
	br label %l5
l5:
	%t7 = add i32 1337, 0
	br i1 %t7, label %l6, label %l7
l6:
	%t8 = add i32 1337, 0
	ret %t8
	br label %l7
l7:
	%t9 = add i32 1337, 0
	br i1 %t9, label %l8, label %l9
l8:
	%t10 = add i32 1337, 0
	ret %t10
	br label %l9
l9:
	%t11 = add i32 1337, 0
	br i1 %t11, label %l10, label %l11
l10:
	%t12 = add i32 1337, 0
	ret %t12
	br label %l11
l11:
	%t13 = add i32 1337, 0
	br i1 %t13, label %l12, label %l13
l12:
	%t14 = add i32 1337, 0
	ret %t14
	br label %l13
l13:
	%t15 = add i32 1337, 0
	br i1 %t15, label %l14, label %l15
l14:
	%t16 = add i32 1337, 0
	ret %t16
	br label %l15
l15:
	%t17 = add i32 1337, 0
	br i1 %t17, label %l16, label %l17
l16:
	%t18 = add i32 1337, 0
	ret %t18
	br label %l17
l17:
	%t19 = add i32 1337, 0
	br i1 %t19, label %l18, label %l19
l18:
	%t20 = add i32 1337, 0
	ret %t20
	br label %l19
l19:
	%t21 = add i32 1337, 0
	br i1 %t21, label %l20, label %l21
l20:
	%t22 = add i32 1337, 0
	ret %t22
	br label %l21
l21:
	%t23 = add i32 1337, 0
	br i1 %t23, label %l22, label %l23
l22:
	%t24 = add i32 1337, 0
	ret %t24
	br label %l23
l23:
	%t25 = add i32 1337, 0
	br i1 %t25, label %l24, label %l25
l24:
	%t26 = add i32 1337, 0
	ret %t26
	br label %l25
l25:
	%t27 = add i32 1337, 0
	br i1 %t27, label %l26, label %l27
l26:
	%t28 = add i32 1337, 0
	ret %t28
	br label %l27
l27:
	%t29 = add i32 1337, 0
	br i1 %t29, label %l28, label %l29
l28:
	%t30 = add i32 1337, 0
	ret %t30
	br label %l29
l29:
	%t31 = add i32 1337, 0
	br i1 %t31, label %l30, label %l31
l30:
	%t32 = add i32 1337, 0
	ret %t32
	br label %l31
l31:
	%t33 = add i32 1337, 0
	br i1 %t33, label %l32, label %l33
l32:
	%t34 = add i32 1337, 0
	ret %t34
	br label %l33
l33:
	%t35 = add i32 1337, 0
	br i1 %t35, label %l34, label %l35
l34:
	%t36 = add i32 1337, 0
	ret %t36
	br label %l35
l35:
	%t37 = add i32 1337, 0
	br i1 %t37, label %l36, label %l37
l36:
	%t38 = add i32 1337, 0
	ret %t38
	br label %l37
l37:
	%t39 = add i32 1337, 0
	ret %t39
}
define %struct.Expression @parse_expression_internal(%struct.TokenData* %a0, i32* %a1, i32 %a2, i8 %a3){
	%t4 = add i32 1337, 0
	br i1 %t4, label %l0, label %l1
l0:
	br label %l1
l1:
	%t5 = alloca %struct.Expression
	%t6 = alloca i8
	%t7 = add i32 1337, 0
	br i1 %t7, label %l2, label %l3
l2:
	%t8 = alloca %struct.IntegerExpr*
	br label %l4
l3:
	%t9 = add i32 1337, 0
	br i1 %t9, label %l5, label %l6
l5:
	%t10 = alloca %struct.CharExpr*
	br label %l7
l6:
	%t11 = add i32 1337, 0
	br i1 %t11, label %l8, label %l9
l8:
	%t12 = alloca %struct.DecimalExpr*
	br label %l10
l9:
	%t13 = add i32 1337, 0
	br i1 %t13, label %l11, label %l12
l11:
	%t14 = alloca %struct.NameExpr*
	br label %l13
l12:
	%t15 = add i32 1337, 0
	br i1 %t15, label %l14, label %l15
l14:
	%t16 = alloca %struct.StringConstExpr*
	br label %l16
l15:
	%t17 = add i32 1337, 0
	br i1 %t17, label %l17, label %l18
l17:
	%t18 = alloca %struct.BoolExpr*
	br label %l19
l18:
	%t19 = add i32 1337, 0
	br i1 %t19, label %l20, label %l21
l20:
	%t20 = alloca %struct.BoolExpr*
	br label %l22
l21:
	%t21 = add i32 1337, 0
	br i1 %t21, label %l23, label %l24
l23:
	br label %l25
l24:
	%t22 = add i32 1337, 0
	br i1 %t22, label %l26, label %l27
l26:
	%t23 = alloca %struct.ArrayExpr*
l29:
	%t24 = add i32 1337, 0
	br i1 %t24, label %l31, label %l30
l31:
	%t25 = add i32 1337, 0
	br i1 %t25, label %l32, label %l33
l32:
	br label %l34
l33:
	%t26 = add i32 1337, 0
	br i1 %t26, label %l35, label %l36
l35:
	br label %l36
l36:
	br label %l34
l34:
	br label %l29
	br label %l30
l30:
	br label %l28
l27:
	%t27 = add i32 1337, 0
	br i1 %t27, label %l37, label %l38
l37:
	%t28 = alloca %struct.UnaryOpExpr*
	br label %l39
l38:
	%t29 = add i32 1337, 0
	br i1 %t29, label %l40, label %l41
l40:
	br label %l42
l41:
	br label %l42
l42:
	br label %l39
l39:
	br label %l28
l28:
	br label %l25
l25:
	br label %l22
l22:
	br label %l19
l19:
	br label %l16
l16:
	br label %l13
l13:
	br label %l10
l10:
	br label %l7
l7:
	br label %l4
l4:
l43:
	%t30 = add i32 1337, 0
	br i1 %t30, label %l45, label %l44
l45:
	%t31 = alloca i8
	%t32 = alloca i1
	%t33 = add i32 1337, 0
	br i1 %t33, label %l46, label %l47
l46:
	br label %l44
	br label %l47
l47:
	%t34 = add i32 1337, 0
	br i1 %t34, label %l48, label %l49
l48:
	br label %l50
l49:
	%t35 = add i32 1337, 0
	br i1 %t35, label %l51, label %l52
l51:
	br label %l52
l52:
	br label %l50
l50:
	%t36 = alloca i8
	%t37 = add i32 1337, 0
	br i1 %t37, label %l53, label %l54
l53:
	br label %l44
	br label %l54
l54:
	%t38 = add i32 1337, 0
	br i1 %t38, label %l55, label %l56
l55:
	br label %l56
l56:
	%t39 = add i32 1337, 0
	br i1 %t39, label %l57, label %l58
l57:
	%t40 = alloca %struct.CallExpr*
l60:
	%t41 = add i32 1337, 0
	br i1 %t41, label %l62, label %l61
l62:
	%t42 = add i32 1337, 0
	br i1 %t42, label %l63, label %l64
l63:
	br label %l65
l64:
	%t43 = add i32 1337, 0
	br i1 %t43, label %l66, label %l67
l66:
	br label %l67
l67:
	br label %l65
l65:
	br label %l60
	br label %l61
l61:
	br label %l59
l58:
	%t44 = add i32 1337, 0
	br i1 %t44, label %l68, label %l69
l68:
	%t45 = alloca %struct.IndexExpr*
	br label %l70
l69:
	%t46 = add i32 1337, 0
	br i1 %t46, label %l71, label %l72
l71:
	%t47 = add i32 1337, 0
	br i1 %t47, label %l74, label %l75
l74:
	%t48 = alloca %struct.NameWithGenericsExpr*
l77:
	%t49 = add i32 1337, 0
	br i1 %t49, label %l79, label %l78
l79:
	%t50 = add i32 1337, 0
	br i1 %t50, label %l80, label %l81
l80:
	br label %l82
l81:
	%t51 = add i32 1337, 0
	br i1 %t51, label %l83, label %l84
l83:
	br label %l84
l84:
	br label %l82
l82:
	br label %l77
	br label %l78
l78:
	br label %l76
l75:
	%t52 = add i32 1337, 0
	br i1 %t52, label %l85, label %l86
l85:
	%t53 = alloca %struct.StructInitExpr*
l88:
	%t54 = add i32 1337, 0
	br i1 %t54, label %l90, label %l89
l90:
	%t55 = alloca i16
	%t56 = alloca %struct.StructInitFieldExpr
	%t57 = add i32 1337, 0
	br i1 %t57, label %l91, label %l92
l91:
	br label %l93
l92:
	%t58 = add i32 1337, 0
	br i1 %t58, label %l94, label %l95
l94:
	br label %l95
l95:
	br label %l93
l93:
	br label %l88
	br label %l89
l89:
	br label %l87
l86:
	%t59 = alloca %struct.StaticAccessExpr*
	%t60 = add i32 1337, 0
	br i1 %t60, label %l96, label %l97
l96:
	br label %l97
l97:
	br label %l87
l87:
	br label %l76
l76:
	br label %l73
l72:
	%t61 = add i32 1337, 0
	br i1 %t61, label %l98, label %l99
l98:
	%t62 = alloca %struct.MemberAccessExpr*
	%t63 = add i32 1337, 0
	br i1 %t63, label %l101, label %l102
l101:
	br label %l102
l102:
	br label %l100
l99:
	%t64 = add i32 1337, 0
	br i1 %t64, label %l103, label %l104
l103:
	%t65 = alloca %struct.CastExpr*
	br label %l105
l104:
	%t66 = add i32 1337, 0
	br i1 %t66, label %l106, label %l107
l106:
	%t67 = alloca %struct.RangeExpr*
	br label %l108
l107:
	%t68 = alloca i8
	%t69 = add i32 1337, 0
	br i1 %t69, label %l109, label %l110
l109:
	br label %l110
l110:
	%t70 = alloca %struct.BinaryOpExpr*
	br label %l108
l108:
	br label %l105
l105:
	br label %l100
l100:
	br label %l73
l73:
	br label %l70
l70:
	br label %l59
l59:
	br label %l43
	br label %l44
l44:
	%t71 = add i32 1337, 0
	ret %t71
}
define %struct.Expression @parse_expression(%struct.TokenData* %a0, i32* %a1, i32 %a2){
	%t3 = add i32 1337, 0
	ret %t3
}
define %struct.vector.Vec.struct.Expression @parse_expression_comma(%struct.TokenData* %a0, i32* %a1, i32 %a2){
	%t3 = alloca %struct.vector.Vec.struct.Expression
l0:
	%t4 = add i32 1337, 0
	br i1 %t4, label %l2, label %l1
l2:
	%t5 = alloca %struct.Expression
	%t6 = add i32 1337, 0
	br i1 %t6, label %l3, label %l4
l3:
	br label %l5
l4:
	br label %l1
	br label %l5
l5:
	br label %l0
	br label %l1
l1:
	%t7 = add i32 1337, 0
	ret %t7
}
define %struct.PathEx @path_to_path_ex(%struct.Path* %a0){
	%t1 = alloca %struct.PathEx
	%t2 = add i32 1337, 0
	ret %t2
}
define %struct.PathEx @path_to_path_ex_name(%struct.Path* %a0, i16 %a1){
	%t2 = alloca %struct.PathEx
	%t3 = add i32 1337, 0
	ret %t3
}
define void @append_path(%struct.PathEx* %a0, %struct.string.String* %a1, %struct.string.String* %a2){
	ret void
}
define void @append_path_ex(%struct.PathEx* %a0, %struct.string.String* %a1, %struct.string.String* %a2){
	ret void
}
define %struct.Type @wrap_in_pointers(%struct.Type %a0, i32 %a1){
	%t2 = add i32 1337, 0
	br i1 %t2, label %l0, label %l1
l0:
	%t3 = add i32 1337, 0
	ret %t3
	br label %l1
l1:
	%t4 = add i32 1337, 0
	br i1 %t4, label %l2, label %l3
l2:
	br label %l3
l3:
	%t5 = alloca %struct.PointerType*
	%t6 = alloca %struct.Type
	%t7 = add i32 1337, 0
	ret %t7
}
define %struct.vector.Vec.struct.Type @parse_generic_args(%struct.TokenData* %a0, i32* %a1, i32 %a2){
	%t3 = alloca %struct.vector.Vec.struct.Type
l0:
	%t4 = add i32 1337, 0
	br i1 %t4, label %l2, label %l1
l2:
	%t5 = alloca i8
	%t6 = add i32 1337, 0
	br i1 %t6, label %l3, label %l4
l3:
	br label %l1
	br label %l4
l4:
	%t7 = add i32 1337, 0
	br i1 %t7, label %l5, label %l6
l5:
	br label %l6
l6:
	%t8 = add i32 1337, 0
	br i1 %t8, label %l7, label %l8
l7:
	br label %l8
l8:
	%t9 = add i32 1337, 0
	br i1 %t9, label %l9, label %l10
l9:
	%t10 = add i32 1337, 0
	br i1 %t10, label %l11, label %l12
l11:
	br label %l12
l12:
	%t11 = add i32 1337, 0
	br i1 %t11, label %l13, label %l14
l13:
	br label %l1
	br label %l14
l14:
	br label %l10
l10:
	br label %l0
	br label %l1
l1:
	%t12 = add i32 1337, 0
	ret %t12
}
define %struct.vector.Vec.struct.Type @parse_types_comma(%struct.TokenData* %a0, i32* %a1, i32 %a2, i8 %a3){
	%t4 = alloca %struct.vector.Vec.struct.Type
l0:
	%t5 = add i32 1337, 0
	br i1 %t5, label %l2, label %l1
l2:
	%t6 = add i32 1337, 0
	br i1 %t6, label %l3, label %l4
l3:
	%t7 = add i32 1337, 0
	br i1 %t7, label %l6, label %l7
l6:
	br label %l1
	br label %l7
l7:
	br label %l5
l4:
	br label %l1
	br label %l5
l5:
	br label %l0
	br label %l1
l1:
	%t8 = add i32 1337, 0
	ret %t8
}
define %struct.Type @parse_type_internal(%struct.TokenData* %a0, i32* %a1, i32 %a2){
	%t3 = alloca i32
l0:
	%t4 = add i32 1337, 0
	br i1 %t4, label %l2, label %l1
l2:
	%t5 = add i32 1337, 0
	br i1 %t5, label %l3, label %l4
l3:
	br label %l5
l4:
	%t6 = add i32 1337, 0
	br i1 %t6, label %l6, label %l7
l6:
	br label %l8
l7:
	br label %l1
	br label %l8
l8:
	br label %l5
l5:
	br label %l0
	br label %l1
l1:
	%t7 = add i32 1337, 0
	br i1 %t7, label %l9, label %l10
l9:
	br label %l10
l10:
	%t8 = alloca %struct.Type
	%t9 = alloca i8
	%t10 = add i32 1337, 0
	br i1 %t10, label %l11, label %l12
l11:
	%t11 = alloca %struct.vector.Vec.struct.Type
	%t12 = alloca %struct.Type
	%t13 = alloca %struct.FunctionType*
	br label %l13
l12:
	%t14 = add i32 1337, 0
	br i1 %t14, label %l14, label %l15
l14:
	%t15 = alloca %struct.Type
	%t16 = alloca %struct.Expression
	%t17 = alloca %struct.ConstantSizeArrayType*
	br label %l16
l15:
	%t18 = add i32 1337, 0
	br i1 %t18, label %l17, label %l18
l17:
	%t19 = alloca %struct.Path
l20:
	%t20 = add i32 1337, 0
	br i1 %t20, label %l22, label %l21
l22:
	%t21 = add i32 1337, 0
	br i1 %t21, label %l23, label %l24
l23:
	br label %l24
l24:
	%t22 = add i32 1337, 0
	br i1 %t22, label %l25, label %l26
l25:
	%t23 = add i32 1337, 0
	br i1 %t23, label %l28, label %l29
l28:
	br label %l29
l29:
	br label %l27
l26:
	br label %l21
	br label %l27
l27:
	br label %l20
	br label %l21
l21:
	%t24 = alloca i16
	%t25 = alloca %struct.Type
	%t26 = add i32 1337, 0
	br i1 %t26, label %l30, label %l31
l30:
	%t27 = alloca %struct.vector.Vec.struct.Type
	%t28 = alloca %struct.GenericType*
	br label %l32
l31:
	%t29 = alloca %struct.NamedType*
	br label %l32
l32:
	%t30 = add i32 1337, 0
	br i1 %t30, label %l33, label %l34
l33:
	%t31 = alloca %struct.NamespaceLinkType*
	br label %l35
l34:
	br label %l35
l35:
	br label %l19
l18:
	br label %l19
l19:
	br label %l16
l16:
	br label %l13
l13:
	%t32 = add i32 1337, 0
	ret %t32
}
define %struct.Type @parse_type(%struct.TokenData* %a0, i32* %a1, i32 %a2){
	%t3 = add i32 1337, 0
	ret %t3
}
define %struct.vector.Vec.struct.Type @parse_types_comma_rparen(%struct.TokenData* %a0, i32* %a1, i32 %a2){
	%t3 = add i32 1337, 0
	ret %t3
}
define void @free_type(%struct.Type %a0){
	ret void
}
define void @expect(%struct.TokenData* %a0, i32* %a1, i32 %a2, i8 %a3, i8* %a4){
	%t5 = add i32 1337, 0
	br i1 %t5, label %l0, label %l1
l0:
	%t6 = alloca %struct.string.String
	br label %l1
l1:
	ret void
}
define void @skip_nested(%struct.TokenData* %a0, i32* %a1, i32 %a2, i8 %a3, i8 %a4){
	%t5 = add i32 1337, 0
	br i1 %t5, label %l0, label %l1
l0:
	ret void
	br label %l1
l1:
	%t6 = alloca i32
l2:
	%t7 = add i32 1337, 0
	br i1 %t7, label %l4, label %l3
l4:
	%t8 = add i32 1337, 0
	br i1 %t8, label %l5, label %l6
l5:
	br label %l7
l6:
	%t9 = add i32 1337, 0
	br i1 %t9, label %l8, label %l9
l8:
	br label %l9
l9:
	br label %l7
l7:
	br label %l2
	br label %l3
l3:
	ret void
}
define void @skip_if_statement(%struct.TokenData* %a0, i32* %a1, i32 %a2){
l0:
	%t3 = add i32 1337, 0
	br i1 %t3, label %l2, label %l1
l2:
	br label %l0
	br label %l1
l1:
	%t4 = add i32 1337, 0
	br i1 %t4, label %l3, label %l4
l3:
	%t5 = add i32 1337, 0
	br i1 %t5, label %l5, label %l6
l5:
	br label %l7
l6:
	%t6 = add i32 1337, 0
	br i1 %t6, label %l8, label %l9
l8:
	br label %l9
l9:
	br label %l7
l7:
	br label %l4
l4:
	ret void
}
define %struct.vector.Vec.struct.Argument @parse_argument_comma(%struct.TokenData* %a0, i32* %a1, i32 %a2){
	%t3 = alloca %struct.vector.Vec.struct.Argument
l0:
	%t4 = add i32 1337, 0
	br i1 %t4, label %l2, label %l1
l2:
	%t5 = alloca %struct.Argument
	%t6 = add i32 1337, 0
	br i1 %t6, label %l3, label %l4
l3:
	br label %l4
l4:
	%t7 = add i32 1337, 0
	br i1 %t7, label %l5, label %l6
l5:
	br label %l6
l6:
	%t8 = add i32 1337, 0
	br i1 %t8, label %l7, label %l8
l7:
	br label %l9
l8:
	%t9 = add i32 1337, 0
	br i1 %t9, label %l10, label %l11
l10:
	br label %l11
l11:
	br label %l9
l9:
	br label %l0
	br label %l1
l1:
	%t10 = add i32 1337, 0
	ret %t10
}
define %struct.vector.Vec.i16 @parse_generic_params(%struct.TokenData* %a0, i32* %a1, i32 %a2){
	%t3 = alloca %struct.vector.Vec.i16
	%t4 = add i32 1337, 0
	br i1 %t4, label %l0, label %l1
l0:
l2:
	%t5 = add i32 1337, 0
	br i1 %t5, label %l4, label %l3
l4:
	%t6 = add i32 1337, 0
	br i1 %t6, label %l5, label %l6
l5:
	br label %l7
l6:
	%t7 = add i32 1337, 0
	br i1 %t7, label %l8, label %l9
l8:
	br label %l10
l9:
	br label %l10
l10:
	br label %l7
l7:
	br label %l2
	br label %l3
l3:
	br label %l1
l1:
	%t8 = add i32 1337, 0
	ret %t8
}
define %struct.vector.Vec.struct.Argument @parse_struct_fields(%struct.TokenData* %a0, i32* %a1, i32 %a2){
	%t3 = alloca %struct.vector.Vec.struct.Argument
l0:
	%t4 = add i32 1337, 0
	br i1 %t4, label %l2, label %l1
l2:
	%t5 = alloca %struct.Argument
	%t6 = add i32 1337, 0
	br i1 %t6, label %l3, label %l4
l3:
	br label %l4
l4:
	%t7 = add i32 1337, 0
	br i1 %t7, label %l5, label %l6
l5:
	br label %l7
l6:
	%t8 = add i32 1337, 0
	br i1 %t8, label %l8, label %l9
l8:
	br label %l9
l9:
	br label %l7
l7:
	br label %l0
	br label %l1
l1:
	%t9 = add i32 1337, 0
	ret %t9
}
define %struct.vector.Vec.struct.EnumField @parse_enum_fields(%struct.TokenData* %a0, i32* %a1, i32 %a2){
	%t3 = alloca %struct.vector.Vec.struct.EnumField
l0:
	%t4 = add i32 1337, 0
	br i1 %t4, label %l2, label %l1
l2:
	%t5 = alloca %struct.EnumField
	%t6 = add i32 1337, 0
	br i1 %t6, label %l3, label %l4
l3:
	br label %l4
l4:
	%t7 = add i32 1337, 0
	br i1 %t7, label %l5, label %l6
l5:
	br label %l7
l6:
	br label %l7
l7:
	%t8 = add i32 1337, 0
	br i1 %t8, label %l8, label %l9
l8:
	br label %l10
l9:
	%t9 = add i32 1337, 0
	br i1 %t9, label %l11, label %l12
l11:
	br label %l12
l12:
	br label %l10
l10:
	br label %l0
	br label %l1
l1:
	%t10 = add i32 1337, 0
	ret %t10
}
define i1 @is_expression_starter(i8 %a0){
	%t1 = add i32 1337, 0
	br i1 %t1, label %l0, label %l1
l0:
	%t2 = add i1 1, 0
	ret %t2
	br label %l1
l1:
	%t3 = add i32 1337, 0
	ret %t3
}
define void @parse_body(%struct.TokenData* %a0, i32 %a1, %struct.vector.Vec.struct.string.String* %a2, %struct.vector.Vec.struct.Stmt* %a3){
	%t4 = add i32 1337, 0
	br i1 %t4, label %l0, label %l1
l0:
	ret void
	br label %l1
l1:
	%t5 = alloca i32
	%t6 = alloca %struct.TokenData*
	%t7 = alloca i32
l2:
	%t8 = add i32 1337, 0
	br i1 %t8, label %l4, label %l3
l4:
	%t9 = alloca i8
	%t10 = add i32 1337, 0
	br i1 %t10, label %l5, label %l6
l5:
	%t11 = add i32 1337, 0
	br i1 %t11, label %l7, label %l8
l7:
	%t12 = alloca %struct.ReturnNode*
	%t13 = alloca %struct.Stmt
	br label %l2
	br label %l8
l8:
	%t14 = alloca %struct.Expression
	%t15 = alloca %struct.ReturnNode*
	%t16 = alloca %struct.Stmt
	br label %l2
	br label %l6
l6:
	%t17 = add i32 1337, 0
	br i1 %t17, label %l9, label %l10
l9:
	%t18 = alloca i16
	%t19 = alloca %struct.Type
	%t20 = alloca i1
	%t21 = alloca %struct.Expression
	%t22 = add i32 1337, 0
	br i1 %t22, label %l11, label %l12
l11:
	%t23 = alloca %struct.Expression
	br label %l12
l12:
	%t24 = alloca %struct.DeclarationNode*
	%t25 = add i32 1337, 0
	br i1 %t25, label %l13, label %l14
l13:
	br label %l15
l14:
	%t26 = add i32 1337, 0
	br i1 %t26, label %l16, label %l17
l16:
	br label %l17
l17:
	br label %l15
l15:
	%t27 = alloca %struct.Stmt
	br label %l2
	br label %l10
l10:
	%t28 = add i32 1337, 0
	br i1 %t28, label %l18, label %l19
l18:
	%t29 = alloca %struct.Stmt
	br label %l2
	br label %l19
l19:
	%t30 = add i32 1337, 0
	br i1 %t30, label %l20, label %l21
l20:
	%t31 = alloca %struct.Stmt
	br label %l2
	br label %l21
l21:
	%t32 = add i32 1337, 0
	br i1 %t32, label %l22, label %l23
l22:
	%t33 = alloca %struct.Expression
	%t34 = add i32 1337, 0
	br i1 %t34, label %l24, label %l25
l24:
	br label %l25
l25:
	%t35 = alloca i32
	%t36 = alloca i32
	%t37 = alloca %struct.vector.Vec.struct.Stmt
	%t38 = alloca %struct.vector.Vec.struct.Stmt
	%t39 = add i32 1337, 0
	br i1 %t39, label %l26, label %l27
l26:
	%t40 = add i32 1337, 0
	br i1 %t40, label %l28, label %l29
l28:
	%t41 = alloca i32
	%t42 = alloca i32
	%t43 = alloca i32
	br label %l30
l29:
	%t44 = add i32 1337, 0
	br i1 %t44, label %l31, label %l32
l31:
	br label %l32
l32:
	%t45 = alloca i32
	%t46 = alloca i32
	br label %l30
l30:
	br label %l27
l27:
	%t47 = alloca %struct.IfStmt*
	%t48 = alloca %struct.Stmt
	br label %l2
	br label %l23
l23:
	%t49 = add i32 1337, 0
	br i1 %t49, label %l33, label %l34
l33:
	%t50 = alloca %struct.Expression
	%t51 = add i32 1337, 0
	br i1 %t51, label %l35, label %l36
l35:
	br label %l36
l36:
	%t52 = alloca i32
	%t53 = alloca i32
	%t54 = alloca %struct.vector.Vec.struct.Stmt
	%t55 = alloca %struct.WhileStmt*
	%t56 = alloca %struct.Stmt
	br label %l2
	br label %l34
l34:
	%t57 = add i32 1337, 0
	br i1 %t57, label %l37, label %l38
l37:
	%t58 = add i32 1337, 0
	br i1 %t58, label %l39, label %l40
l39:
	br label %l40
l40:
	%t59 = alloca i32
	%t60 = alloca i32
	%t61 = alloca %struct.vector.Vec.struct.Stmt
	%t62 = alloca %struct.LoopStmt*
	%t63 = alloca %struct.Stmt
	br label %l2
	br label %l38
l38:
	%t64 = add i32 1337, 0
	br i1 %t64, label %l41, label %l42
l41:
	%t65 = add i32 1337, 0
	br i1 %t65, label %l43, label %l44
l43:
	br label %l44
l44:
	%t66 = alloca i32
	%t67 = alloca i32
	%t68 = alloca %struct.vector.Vec.struct.Stmt
	%t69 = alloca %struct.Expression
	%t70 = alloca %struct.DoWhileStmt*
	%t71 = alloca %struct.Stmt
	br label %l2
	br label %l42
l42:
	%t72 = add i32 1337, 0
	br i1 %t72, label %l45, label %l46
l45:
	%t73 = alloca %struct.Expression
	%t74 = alloca %struct.Expression
	%t75 = add i32 1337, 0
	br i1 %t75, label %l47, label %l48
l47:
	br label %l48
l48:
	%t76 = alloca i32
	%t77 = alloca i32
	%t78 = alloca %struct.vector.Vec.struct.Stmt
	%t79 = alloca %struct.ForStmt*
	%t80 = alloca %struct.Stmt
	br label %l2
	br label %l46
l46:
	%t81 = add i32 1337, 0
	br i1 %t81, label %l49, label %l50
l49:
	%t82 = alloca %struct.Expression
	%t83 = alloca %struct.ExpressionNode*
	%t84 = alloca %struct.Stmt
	br label %l2
	br label %l50
l50:
	br label %l2
	br label %l3
l3:
	ret void
}
define i8 @get_flags(%struct.TokenData* %a0, i32 %a1, i32 %a2){
	%t3 = add i32 1337, 0
	br i1 %t3, label %l0, label %l1
l0:
	%t4 = add i32 1337, 0
	ret %t4
	br label %l1
l1:
	%t5 = alloca i8
	%t6 = add i32 1337, 0
	ret %t6
}
define void @parse(%struct.TokenData* %a0, i32 %a1, %struct.vector.Vec.struct.string.String* %a2, %struct.vector.Vec.struct.Stmt* %a3){
	%t4 = add i32 1337, 0
	br i1 %t4, label %l0, label %l1
l0:
	ret void
	br label %l1
l1:
	%t5 = alloca i32
	%t6 = alloca i32
	%t7 = alloca i32
	%t8 = alloca %struct.TokenData*
l2:
	%t9 = add i32 1337, 0
	br i1 %t9, label %l4, label %l3
l4:
	%t10 = alloca i8
	%t11 = add i32 1337, 0
	br i1 %t11, label %l5, label %l6
l5:
	%t12 = add i32 1337, 0
	br i1 %t12, label %l7, label %l8
l7:
	br label %l8
l8:
	br label %l2
	br label %l6
l6:
	%t13 = add i32 1337, 0
	br i1 %t13, label %l9, label %l10
l9:
	%t14 = alloca i1
	%t15 = add i32 1337, 0
	br i1 %t15, label %l11, label %l12
l11:
	br label %l12
l12:
	%t16 = add i32 1337, 0
	br i1 %t16, label %l13, label %l14
l13:
	br label %l14
l14:
	%t17 = alloca i16
	%t18 = alloca %struct.vector.Vec.struct.Expression
	%t19 = add i32 1337, 0
	br i1 %t19, label %l15, label %l16
l15:
	br label %l16
l16:
	%t20 = alloca i8
	%t21 = add i32 1337, 0
	br i1 %t21, label %l17, label %l18
l17:
	br label %l18
l18:
	%t22 = alloca %struct.HintNode*
	%t23 = alloca %struct.Stmt
	br label %l2
	br label %l10
l10:
	%t24 = add i32 1337, 0
	br i1 %t24, label %l19, label %l20
l19:
	%t25 = alloca i8
	%t26 = add i32 1337, 0
	br i1 %t26, label %l21, label %l22
l21:
	br label %l22
l22:
	%t27 = alloca i16
	%t28 = add i32 1337, 0
	br i1 %t28, label %l23, label %l24
l23:
	br label %l24
l24:
	%t29 = alloca %struct.vector.Vec.i16
	%t30 = add i32 1337, 0
	br i1 %t30, label %l25, label %l26
l25:
l27:
	%t31 = add i32 1337, 0
	br i1 %t31, label %l29, label %l28
l29:
	%t32 = add i32 1337, 0
	br i1 %t32, label %l30, label %l31
l30:
	br label %l32
l31:
	br label %l32
l32:
	%t33 = add i32 1337, 0
	br i1 %t33, label %l33, label %l34
l33:
	br label %l34
l34:
	br label %l27
	br label %l28
l28:
	br label %l26
l26:
	%t34 = alloca %struct.vector.Vec.struct.Argument
	%t35 = add i32 1337, 0
	br i1 %t35, label %l35, label %l36
l35:
	br label %l36
l36:
	%t36 = alloca i1
	%t37 = alloca %struct.Type
	%t38 = add i32 1337, 0
	br i1 %t38, label %l37, label %l38
l37:
	br label %l38
l38:
	%t39 = alloca %struct.vector.Vec.struct.Stmt
	%t40 = add i32 1337, 0
	br i1 %t40, label %l39, label %l40
l39:
	%t41 = alloca i32
	%t42 = alloca i32
	br label %l41
l40:
	%t43 = add i32 1337, 0
	br i1 %t43, label %l42, label %l43
l42:
	%t44 = alloca %struct.ReturnNode*
	%t45 = alloca %struct.Stmt
	br label %l44
l43:
	%t46 = add i32 1337, 0
	br i1 %t46, label %l45, label %l46
l45:
	br label %l46
l46:
	br label %l44
l44:
	br label %l41
l41:
	%t47 = alloca %struct.FnNode*
	%t48 = alloca %struct.Stmt
	br label %l2
	br label %l20
l20:
	%t49 = add i32 1337, 0
	br i1 %t49, label %l47, label %l48
l47:
	%t50 = alloca i8
	%t51 = add i32 1337, 0
	br i1 %t51, label %l49, label %l50
l49:
	br label %l50
l50:
	%t52 = alloca i16
	%t53 = alloca %struct.vector.Vec.struct.Stmt
	%t54 = add i32 1337, 0
	br i1 %t54, label %l51, label %l52
l51:
	%t55 = alloca i32
	%t56 = alloca i32
	br label %l53
l52:
	br label %l53
l53:
	%t57 = alloca %struct.NamespaceNode*
	%t58 = alloca %struct.Stmt
	br label %l2
	br label %l48
l48:
	%t59 = add i32 1337, 0
	br i1 %t59, label %l54, label %l55
l54:
	%t60 = alloca i8
	%t61 = add i32 1337, 0
	br i1 %t61, label %l56, label %l57
l56:
	br label %l57
l57:
	%t62 = alloca i16
	%t63 = alloca %struct.Type
	%t64 = alloca i1
	%t65 = add i32 1337, 0
	br i1 %t65, label %l58, label %l59
l58:
	br label %l59
l59:
	%t66 = alloca %struct.vector.Vec.struct.EnumField
	%t67 = add i32 1337, 0
	br i1 %t67, label %l60, label %l61
l60:
	br label %l62
l61:
	br label %l62
l62:
	%t68 = alloca %struct.EnumNode*
	%t69 = alloca %struct.Stmt
	br label %l2
	br label %l55
l55:
	%t70 = add i32 1337, 0
	br i1 %t70, label %l63, label %l64
l63:
	%t71 = alloca i8
	%t72 = add i32 1337, 0
	br i1 %t72, label %l65, label %l66
l65:
	br label %l66
l66:
	%t73 = alloca i16
	%t74 = alloca %struct.vector.Vec.i16
	%t75 = add i32 1337, 0
	br i1 %t75, label %l67, label %l68
l67:
	br label %l68
l68:
	%t76 = alloca %struct.vector.Vec.struct.Argument
	%t77 = add i32 1337, 0
	br i1 %t77, label %l69, label %l70
l69:
	br label %l71
l70:
	br label %l71
l71:
	%t78 = alloca %struct.StructNode*
	%t79 = alloca %struct.Stmt
	br label %l2
	br label %l64
l64:
	%t80 = add i32 1337, 0
	br i1 %t80, label %l72, label %l73
l72:
	%t81 = alloca i8
	%t82 = alloca i32
	%t83 = alloca %struct.vector.Vec.struct.Stmt
	%t84 = alloca i32
	br label %l2
	br label %l73
l73:
	%t85 = add i32 1337, 0
	br i1 %t85, label %l74, label %l75
l74:
	%t86 = add i32 1337, 0
	br i1 %t86, label %l76, label %l77
l76:
	%t87 = alloca i8
	%t88 = alloca i16
	%t89 = alloca %struct.Type
	%t90 = alloca i1
	%t91 = alloca %struct.Expression
	%t92 = add i32 1337, 0
	br i1 %t92, label %l78, label %l79
l78:
	%t93 = alloca %struct.Expression
	br label %l79
l79:
	%t94 = alloca %struct.DeclarationNode*
	%t95 = add i32 1337, 0
	br i1 %t95, label %l80, label %l81
l80:
	br label %l82
l81:
	%t96 = add i32 1337, 0
	br i1 %t96, label %l83, label %l84
l83:
	br label %l84
l84:
	br label %l82
l82:
	%t97 = alloca %struct.Stmt
	br label %l2
	br label %l77
l77:
	br label %l75
l75:
	br label %l2
	br label %l3
l3:
	ret void
}
