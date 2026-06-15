%struct.SymbolTableEntry = type { i32, %struct.PathEx, void* }
%struct.EnumDefinedField = type { void, i64 }
%struct.EnumSymbolTableEntry = type { %struct.CompilerType, %struct.vector.Vec.., i8 }
%struct.StructDefinedField = type { void, %struct.CompilerType }
%struct.StructSymbolTableEntry = type { %struct.vector.Vec.., %struct.Layout, %struct.string.String, i8 }
%struct.FunctionSymbolTableEntry = type { %struct.vector.Vec.., %struct.CompilerType, %struct.vector.Vec.., i8 }
%struct.GenericFunctionSymbolTableEntry = type { %struct.vector.Vec.., i1, %struct.CompilerType, %struct.vector.Vec.., %struct.vector.Vec.., %struct.vector.Vec.., i8 }
%struct.GenericStructDefinedField = type { void, %struct.CompilerType, i1 }
%struct.GenericStructSymbolTableEntry = type { %struct.vector.Vec.., %struct.vector.Vec.., %struct.vector.Vec.., %struct.string.String, i8 }
%struct.ConstantSymbolTableEntry = type { %struct.CompilerType, %struct.Rvalue }
%struct.StaticSymbolTableEntry = type { %struct.CompilerType, i1, %struct.Rvalue }
%struct.SymbolTable = type { %struct.vector.Vec.., %struct.vector.Vec..* }
%struct.Variable = type { i16 }
%struct.Scope = type { %struct.vector.Vec.., %struct.vector.Vec.. }
%struct.PointerCompilerType = type { i8, %struct.CompilerType }
%struct.GenericImplementationCompilerType = type { i16, i16 }
%struct.CompilerType = type { i32, void* }
%struct.Rvalue = type { i32, void* }
%struct.Layout = type { void, void }
%struct.PrimitiveTypeInfo = type { i8*, i8*, %struct.Layout, i32 }
%struct.mem.PROCESS_HEAP_ENTRY = type { void*, i16, i8, i8, void, void*, i16, i16, i16 }
%struct.string.String = type { i8*, i32, i32 }
%struct.window.POINT = type { i32, i32 }
%struct.window.MSG = type { void*, i16, i64, i64, i16, %struct.window.POINT }
%struct.window.WNDCLASSEXA = type { i16, i16, void*, i32, i32, void*, void*, void*, void*, i8*, i8*, void* }
%struct.window.RECT = type { i32, i32, i32, i32 }
%struct.window.PAINTSTRUCT = type { void*, i32, %struct.window.RECT, i32, i32, void }
%struct.window.BITMAP = type { i32, i32, i32, i32, void, void, void* }
%struct.TokenData = type { i8, void, i16 }
%struct.IntegerExpr = type { void }
%struct.DecimalExpr = type { void }
%struct.CharExpr = type { void }
%struct.NameExpr = type { void }
%struct.StringConstExpr = type { void }
%struct.TypeExpr = type { %struct.Type }
%struct.BinaryOpExpr = type { %struct.Expression, %struct.Expression, i8 }
%struct.UnaryOpExpr = type { %struct.Expression, i8 }
%struct.CastExpr = type { %struct.Expression, %struct.Type }
%struct.MemberAccessExpr = type { %struct.Expression, void }
%struct.StaticAccessExpr = type { %struct.Expression, void }
%struct.NameWithGenericsExpr = type { %struct.Expression, %struct.vector.Vec.. }
%struct.CallExpr = type { %struct.Expression, %struct.vector.Vec.., %struct.vector.Vec.. }
%struct.RangeExpr = type { %struct.Expression, %struct.Expression, i1 }
%struct.IndexExpr = type { %struct.Expression, %struct.Expression }
%struct.ArrayExpr = type { %struct.vector.Vec.. }
%struct.StructInitFieldExpr = type { void, %struct.Expression }
%struct.StructInitExpr = type { %struct.Expression, %struct.vector.Vec.. }
%struct.BoolExpr = type { i1 }
%struct.Expression = type { i32, void* }
%struct.Path = type { i8, void }
%struct.PathEx = type { i8, void }
%struct.NamedType = type { void }
%struct.PointerType = type { i8, %struct.Type }
%struct.FunctionType = type { %struct.vector.Vec.., %struct.Type }
%struct.NamespaceLinkType = type { %struct.Path, %struct.Type }
%struct.GenericType = type { void, %struct.vector.Vec.. }
%struct.ConstantSizeArrayType = type { %struct.Type, %struct.Expression }
%struct.Type = type { i32, void* }
%struct.Argument = type { void, %struct.Type }
%struct.EnumField = type { void, i1, %struct.Expression }
%struct.HintNode = type { void, %struct.vector.Vec.. }
%struct.FnNode = type { void, i8, %struct.vector.Vec.., i1, %struct.Type, %struct.vector.Vec.., %struct.vector.Vec.. }
%struct.EnumNode = type { void, i8, i1, %struct.Type, %struct.vector.Vec.. }
%struct.StructNode = type { void, i8, %struct.vector.Vec.., %struct.vector.Vec.. }
%struct.IfStmt = type { %struct.Expression, %struct.vector.Vec.., %struct.vector.Vec.. }
%struct.LoopStmt = type { %struct.vector.Vec.. }
%struct.WhileStmt = type { %struct.Expression, %struct.vector.Vec.. }
%struct.DoWhileStmt = type { %struct.Expression, %struct.vector.Vec.. }
%struct.ForStmt = type { %struct.Expression, %struct.Expression, %struct.vector.Vec.. }
%struct.NamespaceNode = type { void, %struct.vector.Vec.. }
%struct.BlockStmt = type { %struct.vector.Vec.. }
%struct.ReturnNode = type { i1, %struct.Expression }
%struct.ExpressionNode = type { %struct.Expression }
%struct.DeclarationNode = type { void, i1, %struct.Expression, %struct.Type, i8 }
%struct.Stmt = type { i8, void* }
%struct.list.List = type { i32*, i32*, i16 }
%struct.list.ListNode = type { , i32* }
%struct.vector.Vec = type { *, i16, i16 }
declare dllimport void	@ExitProcess(i32 %t0)
declare dllimport i16	@GetModuleFileNameA(i8* %t0, i8* %t1, i16 %t2)
declare dllimport i32*	@GetProcessHeap()
declare dllimport void*	@HeapAlloc(i32* %t0, i32 %t1, i64 %t2)
declare dllimport void*	@HeapReAlloc(i32* %t0, i32 %t1, void* %t2, i64 %t3)
declare dllimport i32	@HeapFree(i32* %t0, i32 %t1, void* %t2)
declare dllimport i64	@HeapSize(i32* %t0, i32 %t1, i8* %t2)
declare dllimport i32	@HeapWalk(i32* %t0, %struct.mem.PROCESS_HEAP_ENTRY* %t1)
declare dllimport i32	@HeapLock(i32* %t0)
declare dllimport i32	@HeapUnlock(i32* %t0)
declare dllimport i32	@AllocConsole()
declare dllimport i8*	@GetStdHandle(i32 %t0)
declare dllimport i32	@FreeConsole()
declare dllimport i32	@WriteConsoleA(i8* %t0, i8* %t1, i32 %t2, i32* %t3, i8* %t4)
declare dllimport void*	@CreateFileA(i8* %t0, i16 %t1, i16 %t2, i8* %t3, i16 %t4, i16 %t5, i8* %t6)
declare dllimport i32	@WriteFile(void* %t0, i8* %t1, i16 %t2, i16* %t3, i8* %t4)
declare dllimport i32	@ReadFile(void* %t0, i8* %t1, i16 %t2, i16* %t3, i8* %t4)
declare dllimport i32	@GetFileSizeEx(void* %t0, i64* %t1)
declare dllimport i32	@CloseHandle(void* %t0)
declare dllimport i32	@DeleteFileA(i8* %t0)
declare dllimport i16	@GetFileAttributesA(i8* %t0)
declare dllimport i32	@GetFullPathNameA(i8* %t0, i32 %t1, i8* %t2, i8* %t3)
declare dllimport i8*	@PathCombineA(i8* %t0, i8* %t1, i8* %t2)
declare dllimport void	@RegisterClassA(%struct.window.WNDCLASSEXA* %t0)
declare dllimport void*	@CreateWindowExA(i16 %t0, i8* %t1, i8* %t2, i16 %t3, i32 %t4, i32 %t5, i32 %t6, i32 %t7, void* %t8, void* %t9, void* %t10, void* %t11)
declare dllimport i64	@DefWindowProcA(void* %t0, i16 %t1, i64 %t2, i64 %t3)
declare dllimport i32	@GetMessageA(%struct.window.MSG* %t0, void* %t1, i16 %t2, i16 %t3)
declare dllimport i32	@TranslateMessage(%struct.window.MSG* %t0)
declare dllimport i64	@DispatchMessageA(%struct.window.MSG* %t0)
declare dllimport void	@PostQuitMessage(i32 %t0)
declare dllimport void*	@BeginPaint(void* %t0, %struct.window.PAINTSTRUCT* %t1)
declare dllimport i32	@EndPaint(void* %t0, %struct.window.PAINTSTRUCT* %t1)
declare dllimport void*	@GetDC(void* %t0)
declare dllimport i32	@ReleaseDC(void* %t0, void* %t1)
declare dllimport void*	@LoadCursorA(void* %t0, i8* %t1)
declare dllimport void*	@LoadIconA(void* %t0, i8* %t1)
declare dllimport void*	@LoadImageA(void* %t0, i8* %t1, i16 %t2, i32 %t3, i32 %t4, i16 %t5)
declare dllimport i32	@GetClientRect(void* %t0, %struct.window.RECT* %t1)
declare dllimport i32	@InvalidateRect(void* %t0, %struct.window.RECT* %t1, i32 %t2)
declare dllimport void	@RegisterClassExA(%struct.window.WNDCLASSEXA* %t0)
declare dllimport i32	@ShowWindow(void* %t0, i32 %t1)
declare dllimport i64	@SetWindowLongPtrA(void* %t0, i32 %t1, void* %t2)
declare dllimport void*	@GetWindowLongPtrA(void* %t0, i32 %t1)
declare dllimport void*	@GetModuleHandleA(i8* %t0)
declare dllimport void*	@CreateCompatibleDC(void* %t0)
declare dllimport void*	@SelectObject(void* %t0, void* %t1)
declare dllimport i32	@BitBlt(void* %t0, i32 %t1, i32 %t2, i32 %t3, i32 %t4, void* %t5, i32 %t6, i32 %t7, i16 %t8)
declare dllimport i32	@DeleteDC(void* %t0)
declare dllimport i32	@DeleteObject(void* %t0)
declare dllimport i32	@GetObjectA(void* %t0, i32 %t1, %struct.window.BITMAP* %t2)
declare dllimport i32	@SetStretchBltMode(void* %t0, i32 %t1)
declare dllimport i32	@StretchBlt(void* %t0, i32 %t1, i32 %t2, i32 %t3, i32 %t4, void* %t5, i32 %t6, i32 %t7, i32 %t8, i32 %t9, i16 %t10)
@POINTER_LAYOUT = internal global %struct.Layout zeroinitializer
@VOID_TYPE = internal global %struct.PrimitiveTypeInfo* zeroinitializer
@DEFAULT_INTEGER_TYPE = internal global %struct.PrimitiveTypeInfo* zeroinitializer
@PRIMITIVE_TYPES_INFO = internal global void zeroinitializer
@stdlib.rand_seed = internal global i16 zeroinitializer
