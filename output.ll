%struct.Argument = type { i16, %struct.Type }
%struct.ArrayExpr = type { %"struct.vector.Vec<%struct.Expression>" }
%struct.BinaryOpExpr = type { %struct.Expression, %struct.Expression, i8 }
%struct.BlockStmt = type { %"struct.vector.Vec<%struct.Stmt>" }
%struct.BoolExpr = type { i1 }
%struct.CallExpr = type { %struct.Expression, %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Type>" }
%struct.CastExpr = type { %struct.Expression, %struct.Type }
%struct.CharExpr = type { i16 }
%struct.CompilerType = type { i32, i8* }
%struct.ConstantSizeArrayType = type { %struct.Type, %struct.Expression }
%struct.ConstantSymbolTableEntry = type { %struct.CompilerType, %struct.Rvalue }
%struct.DecimalExpr = type { i16 }
%struct.DeclarationNode = type { i16, i1, %struct.Expression, %struct.Type, i8 }
%struct.DoWhileStmt = type { %struct.Expression, %"struct.vector.Vec<%struct.Stmt>" }
%struct.EnumDefinedField = type { i16, i64 }
%struct.EnumField = type { i16, i1, %struct.Expression }
%struct.EnumNode = type { i16, i8, i1, %struct.Type, %"struct.vector.Vec<%struct.EnumField>" }
%struct.EnumSymbolTableEntry = type { %struct.CompilerType, %"struct.vector.Vec<%struct.EnumDefinedField>", i8 }
%struct.Expression = type { i32, i8* }
%struct.ExpressionNode = type { %struct.Expression }
%struct.FnNode = type { i16, i8, %"struct.vector.Vec<%struct.Argument>", i1, %struct.Type, %"struct.vector.Vec<ui16>", %"struct.vector.Vec<%struct.Stmt>" }
%struct.ForStmt = type { %struct.Expression, %struct.Expression, %"struct.vector.Vec<%struct.Stmt>" }
%struct.FunctionSymbolTableEntry = type { %"struct.vector.Vec<%struct.StructDefinedField>", %struct.CompilerType, %"struct.vector.Vec<%struct.Stmt>", i8 }
%struct.FunctionType = type { %"struct.vector.Vec<%struct.Type>", %struct.Type }
%struct.GenericFunctionSymbolTableEntry = type { %"struct.vector.Vec<%struct.GenericStructDefinedField>", i1, %struct.CompilerType, %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<ui16>", %"struct.vector.Vec<%struct.vector.Vec<%struct.CompilerType>>", i8 }
%struct.GenericImplementationCompilerType = type { i32, i32 }
%struct.GenericStructDefinedField = type { i16, %struct.CompilerType, i1 }
%struct.GenericStructSymbolTableEntry = type { %"struct.vector.Vec<%struct.GenericStructDefinedField>", %"struct.vector.Vec<ui16>", %"struct.vector.Vec<%struct.vector.Vec<%struct.CompilerType>>", %struct.string.String, i8 }
%struct.GenericType = type { i16, %"struct.vector.Vec<%struct.Type>" }
%struct.HintNode = type { i16, %"struct.vector.Vec<%struct.Expression>" }
%struct.IfStmt = type { %struct.Expression, %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>" }
%struct.IndexExpr = type { %struct.Expression, %struct.Expression }
%struct.IntegerExpr = type { i16 }
%struct.Layout = type { i16, i16 }
%struct.LoopStmt = type { %"struct.vector.Vec<%struct.Stmt>" }
%struct.MemberAccessExpr = type { %struct.Expression, i16 }
%struct.NameExpr = type { i16 }
%struct.NameWithGenericsExpr = type { %struct.Expression, %"struct.vector.Vec<%struct.Type>" }
%struct.NamedType = type { i16 }
%struct.NamespaceLinkType = type { %struct.Path, %struct.Type }
%struct.NamespaceNode = type { i16, %"struct.vector.Vec<%struct.Stmt>" }
%struct.Path = type { i8, [8 x i16] }
%struct.PathEx = type { i8, [12 x i16] }
%struct.PointerCompilerType = type { i8, %struct.CompilerType }
%struct.PointerType = type { i8, %struct.Type }
%struct.PrimitiveTypeInfo = type { i8*, i8*, %struct.Layout, i32 }
%struct.RangeExpr = type { %struct.Expression, %struct.Expression, i1 }
%struct.ReturnNode = type { i1, %struct.Expression }
%struct.Rvalue = type { i32, i8* }
%struct.Scope = type { %"struct.vector.Vec<%struct.Variable>", %"struct.vector.Vec<ui32>" }
%struct.StaticAccessExpr = type { %struct.Expression, i16 }
%struct.StaticSymbolTableEntry = type { %struct.CompilerType, i1, %struct.Rvalue }
%struct.Stmt = type { i8, i8* }
%struct.StringConstExpr = type { i16 }
%struct.StructDefinedField = type { i16, %struct.CompilerType }
%struct.StructInitExpr = type { %struct.Expression, %"struct.vector.Vec<%struct.StructInitFieldExpr>" }
%struct.StructInitFieldExpr = type { i16, %struct.Expression }
%struct.StructNode = type { i16, i8, %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<ui16>" }
%struct.StructSymbolTableEntry = type { %"struct.vector.Vec<%struct.StructDefinedField>", %struct.Layout, %struct.string.String, i8 }
%struct.SymbolTable = type { %"struct.vector.Vec<%struct.SymbolTableEntry>", %"struct.vector.Vec<%struct.string.String>"* }
%struct.SymbolTableEntry = type { i32, %struct.PathEx, i8* }
%struct.TokenData = type { i8, i16, i32 }
%struct.Type = type { i32, i8* }
%struct.TypeExpr = type { %struct.Type }
%struct.UnaryOpExpr = type { %struct.Expression, i8 }
%struct.Variable = type { i32 }
%struct.WhileStmt = type { %struct.Expression, %"struct.vector.Vec<%struct.Stmt>" }
%struct.mem.PROCESS_HEAP_ENTRY = type { i8*, i32, i8, i8, i16, i8*, i32, i32, i32 }
%struct.string.String = type { i8*, i32, i32 }
%struct.window.BITMAP = type { i32, i32, i32, i32, i16, i16, i8* }
%struct.window.MSG = type { i8*, i32, i64, i64, i32, %struct.window.POINT }
%struct.window.PAINTSTRUCT = type { i8*, i32, %struct.window.RECT, i32, i32, [32 x i8] }
%struct.window.POINT = type { i32, i32 }
%struct.window.RECT = type { i32, i32, i32, i32 }
%struct.window.WNDCLASSEXA = type { i32, i32, i64 (i8*, i32, i64, i64)*, i32, i32, i8*, i8*, i8*, i8*, i8*, i8*, i8* }
%"struct.list.List<i32>" = type { %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"*, i32 }
%"struct.list.ListNode<i32>" = type { i32, %"struct.list.ListNode<i32>"* }
%"struct.vector.Vec<%struct.Expression>" = type { %struct.Expression*, i32, i32 }
%"struct.vector.Vec<%struct.Stmt>" = type { %struct.Stmt*, i32, i32 }
%"struct.vector.Vec<%struct.Type>" = type { %struct.Type*, i32, i32 }
%"struct.vector.Vec<%struct.EnumField>" = type { %struct.EnumField*, i32, i32 }
%"struct.vector.Vec<%struct.EnumDefinedField>" = type { %struct.EnumDefinedField*, i32, i32 }
%"struct.vector.Vec<%struct.Argument>" = type { %struct.Argument*, i32, i32 }
%"struct.vector.Vec<ui16>" = type { i16*, i32, i32 }
%"struct.vector.Vec<%struct.StructDefinedField>" = type { %struct.StructDefinedField*, i32, i32 }
%"struct.vector.Vec<%struct.GenericStructDefinedField>" = type { %struct.GenericStructDefinedField*, i32, i32 }
%"struct.vector.Vec<%struct.CompilerType>" = type { %struct.CompilerType*, i32, i32 }
%"struct.vector.Vec<%struct.vector.Vec<%struct.CompilerType>>" = type { %"struct.vector.Vec<%struct.CompilerType>"*, i32, i32 }
%"struct.vector.Vec<%struct.Variable>" = type { %struct.Variable*, i32, i32 }
%"struct.vector.Vec<ui32>" = type { i32*, i32, i32 }
%"struct.vector.Vec<%struct.StructInitFieldExpr>" = type { %struct.StructInitFieldExpr*, i32, i32 }
%"struct.vector.Vec<%struct.SymbolTableEntry>" = type { %struct.SymbolTableEntry*, i32, i32 }
%"struct.vector.Vec<%struct.string.String>" = type { %struct.string.String*, i32, i32 }
%"struct.vector.Vec<%struct.TokenData>" = type { %struct.TokenData*, i32, i32 }
%"struct.vector.Vec<i8>" = type { i8*, i32, i32 }
%"struct.vector.Vec<i64>" = type { i64*, i32, i32 }
declare dllimport i32 @AllocConsole()
declare dllimport i32 @FreeConsole()
declare dllimport i8* @GetStdHandle(i32 %nStdHandle)
declare dllimport i32 @WriteConsoleA(i8* %hConsoleOutput, i8* %lpBuffer, i32 %nNumberOfCharsToWrite, i32* %lpNumberOfCharsWritten, i8* %lpReserved)
declare dllimport i32 @CloseHandle(i8* %hObject)
declare dllimport i8* @CreateFileA(i8* %lpFileName, i32 %dwDesiredAccess, i32 %dwShareMode, i8* %lpSecurityAttributes, i32 %dwCreationDisposition, i32 %dwFlagsAndAttributes, i8* %hTemplateFile)
declare dllimport i32 @DeleteFileA(i8* %lpFileName)
declare dllimport i32 @GetFileAttributesA(i8* %lpFileName)
declare dllimport i32 @GetFileSizeEx(i8* %hFile, i64* %lpFileSize)
declare dllimport i32 @GetFullPathNameA(i8* %lpFileName, i32 %nBufferLength, i8* %lpBuffer, i8* %lpFilePart)
declare dllimport i8* @PathCombineA(i8* %pszDest, i8* %pszDir, i8* %pszFile)
declare dllimport i32 @ReadFile(i8* %hFile, i8* %lpBuffer, i32 %nNumberOfBytesToRead, i32* %lpNumberOfBytesRead, i8* %lpOverlapped)
declare dllimport i32 @WriteFile(i8* %hFile, i8* %lpBuffer, i32 %nNumberOfBytesToWrite, i32* %lpNumberOfBytesWritten, i8* %lpOverlapped)
declare dllimport i32* @GetProcessHeap()
declare dllimport i8* @HeapAlloc(i32* %hHeap, i32 %dwFlags, i64 %dwBytes)
declare dllimport i32 @HeapFree(i32* %hHeap, i32 %dwFlags, i8* %lpMem)
declare dllimport i32 @HeapLock(i32* %hHeap)
declare dllimport i8* @HeapReAlloc(i32* %hHeap, i32 %dwFlags, i8* %lpMem, i64 %dwBytes)
declare dllimport i64 @HeapSize(i32* %hHeap, i32 %dwFlags, i8* %lpMem)
declare dllimport i32 @HeapUnlock(i32* %hHeap)
declare dllimport i32 @HeapWalk(i32* %hHeap, %struct.mem.PROCESS_HEAP_ENTRY* %lpEntry)
declare dllimport void @ExitProcess(i32 %code)
declare dllimport i32 @GetModuleFileNameA(i8* %hModule, i8* %lpFilename, i32 %nSize)
declare dllimport i8* @BeginPaint(i8* %hWnd, %struct.window.PAINTSTRUCT* %lpPaint)
declare dllimport i32 @BitBlt(i8* %hdc, i32 %x, i32 %y, i32 %cx, i32 %cy, i8* %hdcSrc, i32 %x1, i32 %y1, i32 %rop)
declare dllimport i8* @CreateCompatibleDC(i8* %hdc)
declare dllimport i8* @CreateWindowExA(i32 %dwExStyle, i8* %lpClassName, i8* %lpWindowName, i32 %dwStyle, i32 %x, i32 %y, i32 %nWidth, i32 %nHeight, i8* %hWndParent, i8* %hMenu, i8* %hInstance, i8* %lpParam)
declare dllimport i64 @DefWindowProcA(i8* %hWnd, i32 %Msg, i64 %wParam, i64 %lParam)
declare dllimport i32 @DeleteDC(i8* %hdc)
declare dllimport i32 @DeleteObject(i8* %hObject)
declare dllimport i64 @DispatchMessageA(%struct.window.MSG* %lpMsg)
declare dllimport i32 @EndPaint(i8* %hWnd, %struct.window.PAINTSTRUCT* %lpPaint)
declare dllimport i32 @GetClientRect(i8* %hWnd, %struct.window.RECT* %lpRect)
declare dllimport i8* @GetDC(i8* %hWnd)
declare dllimport i32 @GetMessageA(%struct.window.MSG* %lpMsg, i8* %hWnd, i32 %wMsgFilterMin, i32 %wMsgFilterMax)
declare dllimport i8* @GetModuleHandleA(i8* %lpModuleName)
declare dllimport i32 @GetObjectA(i8* %h, i32 %c, %struct.window.BITMAP* %pv)
declare dllimport i8* @GetWindowLongPtrA(i8* %hWnd, i32 %nIndex)
declare dllimport i32 @InvalidateRect(i8* %hWnd, %struct.window.RECT* %lpRect, i32 %bErase)
declare dllimport i8* @LoadCursorA(i8* %hInstance, i8* %lpCursorName)
declare dllimport i8* @LoadIconA(i8* %hInstance, i8* %lpIconName)
declare dllimport i8* @LoadImageA(i8* %hInst, i8* %name, i32 %type, i32 %cx, i32 %cy, i32 %fuLoad)
declare dllimport void @PostQuitMessage(i32 %nExitCode)
declare dllimport i16 @RegisterClassA(%struct.window.WNDCLASSEXA* %lpWndClass)
declare dllimport i16 @RegisterClassExA(%struct.window.WNDCLASSEXA* %lpwcx)
declare dllimport i32 @ReleaseDC(i8* %hWnd, i8* %hDC)
declare dllimport i8* @SelectObject(i8* %hdc, i8* %h)
declare dllimport i32 @SetStretchBltMode(i8* %hdc, i32 %mode)
declare dllimport i64 @SetWindowLongPtrA(i8* %hWnd, i32 %nIndex, i8* %dwNewLong)
declare dllimport i32 @ShowWindow(i8* %hWnd, i32 %nCmdShow)
declare dllimport i32 @StretchBlt(i8* %hdcDest, i32 %xDest, i32 %yDest, i32 %wDest, i32 %hDest, i8* %hdcSrc, i32 %xSrc, i32 %ySrc, i32 %wSrc, i32 %hSrc, i32 %rop)
declare dllimport i32 @TranslateMessage(%struct.window.MSG* %lpMsg)


@.str.0 = private unnamed_addr constant [32 x i8] c"D:/Projects/rcsharp/src.rcsharp\00"
@.str.1 = private unnamed_addr constant [33 x i8] c"D:/Projects/rcsharp/output_v2.ll\00"
@.str.2 = private unnamed_addr constant [48 x i8] c"Window error: StartError::GetModuleHandleFailed\00"
@.str.3 = private unnamed_addr constant [42 x i8] c"Failed to load image. not valid .BMP file\00"
@.str.4 = private unnamed_addr constant [21 x i8] c"BorderlessImageClass\00"
@.str.5 = private unnamed_addr constant [46 x i8] c"Window error: StartError::RegisterClassFailed\00"
@.str.6 = private unnamed_addr constant [12 x i8] c"ImageWindow\00"
@.str.7 = private unnamed_addr constant [45 x i8] c"Window error: StartError::CreateWindowFailed\00"
@.str.8 = private unnamed_addr constant [14 x i8] c"MyWindowClass\00"
@.str.9 = private unnamed_addr constant [14 x i8] c"Hello, World!\00"
@.str.10 = private unnamed_addr constant [37 x i8] c"File not found! While loading Bitmap\00"
@.str.11 = private unnamed_addr constant [14 x i8] c"vector_test: \00"
@.str.12 = private unnamed_addr constant [24 x i8] c"vector_test: new failed\00"
@.str.13 = private unnamed_addr constant [33 x i8] c"vector_test: initial push failed\00"
@.str.14 = private unnamed_addr constant [36 x i8] c"vector_test: initial content failed\00"
@.str.15 = private unnamed_addr constant [28 x i8] c"vector_test: realloc failed\00"
@.str.16 = private unnamed_addr constant [36 x i8] c"vector_test: realloc content failed\00"
@.str.17 = private unnamed_addr constant [3 x i8] c"AB\00"
@.str.18 = private unnamed_addr constant [37 x i8] c"vector_test: push_bulk length failed\00"
@.str.19 = private unnamed_addr constant [38 x i8] c"vector_test: push_bulk content failed\00"
@.str.20 = private unnamed_addr constant [25 x i8] c"vector_test: free failed\00"
@.str.21 = private unnamed_addr constant [3 x i8] c"OK\00"
@.str.22 = private unnamed_addr constant [20 x i8] c"string_utils_test: \00"
@.str.23 = private unnamed_addr constant [5 x i8] c"test\00"
@.str.24 = private unnamed_addr constant [36 x i8] c"string_utils_test: c_str_len failed\00"
@.str.25 = private unnamed_addr alias [1 x i8], [1 x i8]* bitcast (i8* getelementptr inbounds ([32 x i8], [32 x i8]* @.str.0, i64 0, i64 31) to [1 x i8]*)
@.str.26 = private unnamed_addr constant [42 x i8] c"string_utils_test: c_str_len empty failed\00"
@.str.27 = private unnamed_addr constant [32 x i8] c"char_utils: charis_digit failed\00"
@.str.28 = private unnamed_addr constant [28 x i8] c"char_utils: is_alpha failed\00"
@.str.29 = private unnamed_addr constant [29 x i8] c"char_utils: is_xdigit failed\00"
@.str.30 = private unnamed_addr constant [3 x i8] c"ac\00"
@.str.31 = private unnamed_addr alias [2 x i8], [2 x i8]* bitcast (i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.259, i64 0, i64 2) to [2 x i8]*)
@.str.32 = private unnamed_addr constant [4 x i8] c"abc\00"
@.str.33 = private unnamed_addr constant [33 x i8] c"string_utils_test: insert failed\00"
@.str.34 = private unnamed_addr constant [14 x i8] c"string_test: \00"
@.str.35 = private unnamed_addr constant [6 x i8] c"hello\00"
@.str.36 = private unnamed_addr alias [6 x i8], [6 x i8]* bitcast (i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.41, i64 0, i64 6) to [6 x i8]*)
@.str.37 = private unnamed_addr constant [41 x i8] c"string_test: from_c_string length failed\00"
@.str.38 = private unnamed_addr constant [40 x i8] c"string_test: equal positive case failed\00"
@.str.39 = private unnamed_addr constant [40 x i8] c"string_test: equal negative case failed\00"
@.str.40 = private unnamed_addr alias [7 x i8], [7 x i8]* bitcast (i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.41, i64 0, i64 5) to [7 x i8]*)
@.str.41 = private unnamed_addr constant [12 x i8] c"hello world\00"
@.str.42 = private unnamed_addr constant [34 x i8] c"string_test: concat length failed\00"
@.str.43 = private unnamed_addr constant [35 x i8] c"string_test: concat content failed\00"
@.str.44 = private unnamed_addr constant [20 x i8] c"test malloc delta: \00"
@.str.45 = private unnamed_addr constant [15 x i8] c"process_test: \00"
@.str.46 = private unnamed_addr constant [49 x i8] c"process_test: get_executable_path returned empty\00"
@.str.47 = private unnamed_addr constant [53 x i8] c"process_test: get_executable_env_path returned empty\00"
@.str.48 = private unnamed_addr constant [53 x i8] c"process_test: env path is not shorter than full path\00"
@.str.49 = private unnamed_addr constant [53 x i8] c"process_test: env path does not end with a backslash\00"
@.str.50 = private unnamed_addr constant [18 x i8] c"Executable Path: \00"
@.str.51 = private unnamed_addr constant [19 x i8] c"Environment Path: \00"
@.str.52 = private unnamed_addr constant [11 x i8] c"mem_test: \00"
@.str.53 = private unnamed_addr constant [24 x i8] c"mem_test: malloc failed\00"
@.str.54 = private unnamed_addr constant [35 x i8] c"mem_test: fill verification failed\00"
@.str.55 = private unnamed_addr constant [40 x i8] c"mem_test: zero_fill verification failed\00"
@.str.56 = private unnamed_addr constant [33 x i8] c"mem_test: malloc for copy failed\00"
@.str.57 = private unnamed_addr constant [35 x i8] c"mem_test: copy verification failed\00"
@.str.58 = private unnamed_addr constant [12 x i8] c"list_test: \00"
@.str.59 = private unnamed_addr constant [22 x i8] c"list_test: new failed\00"
@.str.60 = private unnamed_addr constant [41 x i8] c"list_test: length incorrect after extend\00"
@.str.61 = private unnamed_addr constant [33 x i8] c"list_test: walk length incorrect\00"
@.str.62 = private unnamed_addr constant [36 x i8] c"list_test: data mismatch for node 1\00"
@.str.63 = private unnamed_addr constant [36 x i8] c"list_test: data mismatch for node 2\00"
@.str.64 = private unnamed_addr constant [36 x i8] c"list_test: data mismatch for node 3\00"
@.str.65 = private unnamed_addr constant [33 x i8] c"list_test: foot pointer mismatch\00"
@.str.66 = private unnamed_addr constant [23 x i8] c"list_test: free failed\00"
@.str.67 = private unnamed_addr constant [45 x i8] c"D:\Projects\rcsharp\src_base_structs.rcsharp\00"
@.str.68 = private unnamed_addr constant [10 x i8] c"fs_test: \00"
@.str.69 = private unnamed_addr constant [47 x i8] c"The quick brown fox jumps over crazy lost dog.\00"
@.str.70 = private unnamed_addr constant [9 x i8] c"test.txt\00"
@.str.71 = private unnamed_addr constant [38 x i8] c"Filesystem test failed, data mismatch\00"
@.str.72 = private unnamed_addr constant [15 x i8] c"\0Aconsole_test:\00"
@.str.73 = private unnamed_addr constant [26 x i8] c"--- VISUAL TEST START ---\00"
@.str.74 = private unnamed_addr constant [22 x i8] c"Printing i64(12345): \00"
@.str.75 = private unnamed_addr constant [23 x i8] c"Printing i64(-67890): \00"
@.str.76 = private unnamed_addr constant [18 x i8] c"Printing i64(0): \00"
@.str.77 = private unnamed_addr constant [27 x i8] c"Printing u64(9876543210): \00"
@.str.78 = private unnamed_addr constant [24 x i8] c"--- VISUAL TEST END ---\00"
@.str.79 = private unnamed_addr constant [12 x i8] c"Exception: \00"
@.str.80 = private unnamed_addr constant [15 x i8] c"Realloc failed\00"
@.str.81 = private unnamed_addr constant [14 x i8] c"Out of memory\00"
@.str.82 = private unnamed_addr constant [33 x i8] c"Failed to lock heap for walking.\00"
@.str.83 = private unnamed_addr constant [17 x i8] c"File not found: \00"
@.str.84 = private unnamed_addr constant [17 x i8] c"File read failed\00"
@.str.85 = private unnamed_addr constant [3 x i8] c"0\0A\00"
@.str.86 = private unnamed_addr constant [26 x i8] c"stdout handle was invalid\00"
@.str.87 = private unnamed_addr constant [9 x i8] c" = type \00"
@.str.88 = private unnamed_addr constant [3 x i8] c"{ \00"
@.str.89 = private unnamed_addr constant [3 x i8] c", \00"
@.str.90 = private unnamed_addr constant [4 x i8] c" }\0A\00"
@.str.91 = private unnamed_addr alias [2 x i8], [2 x i8]* bitcast (i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.95, i64 0, i64 1) to [2 x i8]*)
@.str.92 = private unnamed_addr constant [20 x i8] c" = internal global \00"
@.str.93 = private unnamed_addr constant [18 x i8] c" zeroinitializer\0A\00"
@.str.94 = private unnamed_addr constant [19 x i8] c"declare dllimport \00"
@.str.95 = private unnamed_addr constant [3 x i8] c"\09@\00"
@.str.96 = private unnamed_addr alias [2 x i8], [2 x i8]* bitcast (i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.306, i64 0, i64 2) to [2 x i8]*)
@.str.97 = private unnamed_addr constant [4 x i8] c" %t\00"
@.str.98 = private unnamed_addr alias [2 x i8], [2 x i8]* bitcast (i8* getelementptr inbounds ([52 x i8], [52 x i8]* @.str.187, i64 0, i64 50) to [2 x i8]*)
@.str.99 = private unnamed_addr alias [2 x i8], [2 x i8]* bitcast (i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.85, i64 0, i64 1) to [2 x i8]*)
@.str.100 = private unnamed_addr constant [37 x i8] c"Pointer depth exceeds maximum of 255\00"
@.str.101 = private unnamed_addr constant [5 x i8] c"CHAR\00"
@.str.102 = private unnamed_addr constant [5 x i8] c"NAME\00"
@.str.103 = private unnamed_addr constant [7 x i8] c"STRING\00"
@.str.104 = private unnamed_addr constant [8 x i8] c"INTEGER\00"
@.str.105 = private unnamed_addr constant [8 x i8] c"DECIMAL\00"
@.str.106 = private unnamed_addr constant [2 x i8] c"{\00"
@.str.107 = private unnamed_addr constant [2 x i8] c"}\00"
@.str.108 = private unnamed_addr constant [2 x i8] c"[\00"
@.str.109 = private unnamed_addr constant [2 x i8] c"]\00"
@.str.110 = private unnamed_addr alias [2 x i8], [2 x i8]* bitcast (i8* getelementptr inbounds ([15 x i8], [15 x i8]* @.str.72, i64 0, i64 13) to [2 x i8]*)
@.str.111 = private unnamed_addr constant [3 x i8] c"::\00"
@.str.112 = private unnamed_addr constant [2 x i8] c";\00"
@.str.113 = private unnamed_addr constant [2 x i8] c",\00"
@.str.114 = private unnamed_addr alias [2 x i8], [2 x i8]* bitcast (i8* getelementptr inbounds ([47 x i8], [47 x i8]* @.str.69, i64 0, i64 45) to [2 x i8]*)
@.str.115 = private unnamed_addr alias [3 x i8], [3 x i8]* bitcast (i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.168, i64 0, i64 8) to [3 x i8]*)
@.str.116 = private unnamed_addr constant [4 x i8] c"..=\00"
@.str.117 = private unnamed_addr constant [3 x i8] c"=>\00"
@.str.118 = private unnamed_addr alias [2 x i8], [2 x i8]* bitcast (i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.237, i64 0, i64 32) to [2 x i8]*)
@.str.119 = private unnamed_addr alias [2 x i8], [2 x i8]* bitcast (i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.116, i64 0, i64 2) to [2 x i8]*)
@.str.120 = private unnamed_addr constant [2 x i8] c"+\00"
@.str.121 = private unnamed_addr alias [2 x i8], [2 x i8]* bitcast (i8* getelementptr inbounds ([26 x i8], [26 x i8]* @.str.73, i64 0, i64 24) to [2 x i8]*)
@.str.122 = private unnamed_addr constant [2 x i8] c"*\00"
@.str.123 = private unnamed_addr constant [2 x i8] c"/\00"
@.str.124 = private unnamed_addr alias [2 x i8], [2 x i8]* bitcast (i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.317, i64 0, i64 1) to [2 x i8]*)
@.str.125 = private unnamed_addr alias [2 x i8], [2 x i8]* bitcast (i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.9, i64 0, i64 12) to [2 x i8]*)
@.str.126 = private unnamed_addr constant [3 x i8] c"==\00"
@.str.127 = private unnamed_addr constant [3 x i8] c"!=\00"
@.str.128 = private unnamed_addr constant [3 x i8] c"||\00"
@.str.129 = private unnamed_addr constant [3 x i8] c"&&\00"
@.str.130 = private unnamed_addr alias [2 x i8], [2 x i8]* bitcast (i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.117, i64 0, i64 1) to [2 x i8]*)
@.str.131 = private unnamed_addr constant [3 x i8] c">=\00"
@.str.132 = private unnamed_addr constant [2 x i8] c"<\00"
@.str.133 = private unnamed_addr constant [3 x i8] c"<=\00"
@.str.134 = private unnamed_addr constant [2 x i8] c"~\00"
@.str.135 = private unnamed_addr alias [2 x i8], [2 x i8]* bitcast (i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.128, i64 0, i64 1) to [2 x i8]*)
@.str.136 = private unnamed_addr alias [2 x i8], [2 x i8]* bitcast (i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.129, i64 0, i64 1) to [2 x i8]*)
@.str.137 = private unnamed_addr constant [2 x i8] c"^\00"
@.str.138 = private unnamed_addr constant [4 x i8] c"PUB\00"
@.str.139 = private unnamed_addr constant [7 x i8] c"INLINE\00"
@.str.140 = private unnamed_addr constant [6 x i8] c"CONST\00"
@.str.141 = private unnamed_addr constant [7 x i8] c"EXTERN\00"
@.str.142 = private unnamed_addr constant [6 x i8] c"MATCH\00"
@.str.143 = private unnamed_addr constant [3 x i8] c"FN\00"
@.str.144 = private unnamed_addr constant [4 x i8] c"LET\00"
@.str.145 = private unnamed_addr constant [7 x i8] c"STATIC\00"
@.str.146 = private unnamed_addr constant [3 x i8] c"AS\00"
@.str.147 = private unnamed_addr constant [3 x i8] c"IF\00"
@.str.148 = private unnamed_addr constant [5 x i8] c"ELSE\00"
@.str.149 = private unnamed_addr constant [6 x i8] c"TRAIT\00"
@.str.150 = private unnamed_addr constant [5 x i8] c"IMPL\00"
@.str.151 = private unnamed_addr constant [7 x i8] c"STRUCT\00"
@.str.152 = private unnamed_addr constant [5 x i8] c"ENUM\00"
@.str.153 = private unnamed_addr constant [5 x i8] c"LOOP\00"
@.str.154 = private unnamed_addr constant [4 x i8] c"FOR\00"
@.str.155 = private unnamed_addr alias [3 x i8], [3 x i8]* bitcast (i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.327, i64 0, i64 2) to [3 x i8]*)
@.str.156 = private unnamed_addr constant [3 x i8] c"IN\00"
@.str.157 = private unnamed_addr constant [6 x i8] c"WHILE\00"
@.str.158 = private unnamed_addr constant [6 x i8] c"BREAK\00"
@.str.159 = private unnamed_addr constant [9 x i8] c"CONTINUE\00"
@.str.160 = private unnamed_addr constant [7 x i8] c"RETURN\00"
@.str.161 = private unnamed_addr constant [5 x i8] c"THIS\00"
@.str.162 = private unnamed_addr constant [9 x i8] c"OPERATOR\00"
@.str.163 = private unnamed_addr constant [10 x i8] c"NAMESPACE\00"
@.str.164 = private unnamed_addr constant [5 x i8] c"TRUE\00"
@.str.165 = private unnamed_addr constant [6 x i8] c"FALSE\00"
@.str.166 = private unnamed_addr constant [5 x i8] c"NULL\00"
@.str.167 = private unnamed_addr constant [14 x i8] c"UNKNOWN_TOKEN\00"
@.str.168 = private unnamed_addr constant [11 x i8] c"Loading...\00"
@.str.169 = private unnamed_addr constant [16 x i8] c"Reading File...\00"
@.str.170 = private unnamed_addr constant [8 x i8] c"include\00"
@.str.171 = private unnamed_addr constant [42 x i8] c"include directive must have only one path\00"
@.str.172 = private unnamed_addr alias [2 x i8], [2 x i8]* bitcast (i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.202, i64 0, i64 3) to [2 x i8]*)
@.str.173 = private unnamed_addr alias [3 x i8], [3 x i8]* bitcast (i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.324, i64 0, i64 4) to [3 x i8]*)
@.str.174 = private unnamed_addr constant [23 x i8] c"Unrecognized directive\00"
@.str.175 = private unnamed_addr constant [10 x i8] c"Loaded...\00"
@.str.176 = private unnamed_addr constant [17 x i8] c"Project Files...\00"
@.str.177 = private unnamed_addr constant [14 x i8] c"Sym Vec Len: \00"
@.str.178 = private unnamed_addr constant [13 x i8] c"Compiling...\00"
@.str.179 = private unnamed_addr constant [44 x i8] c"Unexpected end of tokens while parsing type\00"
@.str.180 = private unnamed_addr constant [41 x i8] c"Expected '(' after 'fn' in function type\00"
@.str.181 = private unnamed_addr constant [50 x i8] c"Expected ')' to close function type argument list\00"
@.str.182 = private unnamed_addr constant [49 x i8] c"Expected ':' before return type in function type\00"
@.str.183 = private unnamed_addr constant [38 x i8] c"Expected ';' in fixed-size array type\00"
@.str.184 = private unnamed_addr constant [44 x i8] c"Expected ']' to close fixed-size array type\00"
@.str.185 = private unnamed_addr constant [56 x i8] c"Qualified type path exceeds maximum depth of 8 segments\00"
@.str.186 = private unnamed_addr constant [49 x i8] c"Expected identifier after '::' in qualified type\00"
@.str.187 = private unnamed_addr constant [52 x i8] c"Expected a type (unexpected token in type position)\00"
@.str.188 = private unnamed_addr constant [29 x i8] c"Expected '{' for struct body\00"
@.str.189 = private unnamed_addr constant [20 x i8] c"Expected field name\00"
@.str.190 = private unnamed_addr constant [30 x i8] c"Expected ':' after field name\00"
@.str.191 = private unnamed_addr constant [39 x i8] c"Expected ',' or '}' after struct field\00"
@.str.192 = private unnamed_addr constant [31 x i8] c"Expected '}' after struct body\00"
@.str.193 = private unnamed_addr constant [36 x i8] c"Expected generic type name or comma\00"
@.str.194 = private unnamed_addr constant [38 x i8] c"Expected '>' after generic parameters\00"
@.str.195 = private unnamed_addr constant [13 x i8] c"Not expected\00"
@.str.196 = private unnamed_addr constant [55 x i8] c"Unexpected end of tokens inside generic type arguments\00"
@.str.197 = private unnamed_addr constant [51 x i8] c"Expected ',' or '>' between generic type arguments\00"
@.str.198 = private unnamed_addr constant [39 x i8] c"Unexpected end of tokens in expression\00"
@.str.199 = private unnamed_addr constant [44 x i8] c"Expected ')' after parenthesized expression\00"
@.str.200 = private unnamed_addr constant [37 x i8] c"Expected ',' or ']' in array literal\00"
@.str.201 = private unnamed_addr constant [33 x i8] c"Expected ']' after array literal\00"
@.str.202 = private unnamed_addr constant [5 x i8] c"---\09\00"
@.str.203 = private unnamed_addr constant [6 x i8] c"\09---\0A\00"
@.str.204 = private unnamed_addr constant [51 x i8] c"Invalid expression syntax: Unexpected prefix token\00"
@.str.205 = private unnamed_addr constant [42 x i8] c"Expected ',' or ')' in function arguments\00"
@.str.206 = private unnamed_addr constant [38 x i8] c"Expected ')' after function arguments\00"
@.str.207 = private unnamed_addr constant [31 x i8] c"Expected ']' after array index\00"
@.str.208 = private unnamed_addr constant [41 x i8] c"Expected ',' or '>' in generic arguments\00"
@.str.209 = private unnamed_addr constant [37 x i8] c"Expected '>' after generic arguments\00"
@.str.210 = private unnamed_addr constant [45 x i8] c"Expected field name in struct initialization\00"
@.str.211 = private unnamed_addr constant [45 x i8] c"Expected ',' or '}' in struct initialization\00"
@.str.212 = private unnamed_addr constant [41 x i8] c"Expected '}' after struct initialization\00"
@.str.213 = private unnamed_addr constant [32 x i8] c"Expected member name after '::'\00"
@.str.214 = private unnamed_addr constant [31 x i8] c"Expected member name after '.'\00"
@.str.215 = private unnamed_addr constant [27 x i8] c"Expected '{' for enum body\00"
@.str.216 = private unnamed_addr constant [27 x i8] c"Expected enum variant name\00"
@.str.217 = private unnamed_addr constant [39 x i8] c"Expected ',' or '}' after enum variant\00"
@.str.218 = private unnamed_addr constant [29 x i8] c"Expected '}' after enum body\00"
@.str.219 = private unnamed_addr constant [37 x i8] c"Expected ';' after return expression\00"
@.str.220 = private unnamed_addr constant [58 x i8] c"Expected variable name after variable declaration keyword\00"
@.str.221 = private unnamed_addr constant [58 x i8] c"Expected ':' after variable deflaration to indicate type.\00"
@.str.222 = private unnamed_addr constant [49 x i8] c"Expected ';' at the end of variable declaration.\00"
@.str.223 = private unnamed_addr constant [25 x i8] c"Expected ';' after break\00"
@.str.224 = private unnamed_addr constant [28 x i8] c"Expected ';' after continue\00"
@.str.225 = private unnamed_addr constant [41 x i8] c"Expected '{' as the begining of if body.\00"
@.str.226 = private unnamed_addr constant [24 x i8] c"Expected '{' after else\00"
@.str.227 = private unnamed_addr constant [44 x i8] c"Expected '{' as the begining of while body.\00"
@.str.228 = private unnamed_addr constant [31 x i8] c"Expected while after do block.\00"
@.str.229 = private unnamed_addr constant [49 x i8] c"Expected semicolon after do {} while expression.\00"
@.str.230 = private unnamed_addr constant [41 x i8] c"Expected in after name in for structure.\00"
@.str.231 = private unnamed_addr constant [42 x i8] c"Expected '{' as the begining of for body.\00"
@.str.232 = private unnamed_addr constant [39 x i8] c"Expected ';' at the end of expression.\00"
@.str.233 = private unnamed_addr constant [6 x i8] c"todo!\00"
@.str.234 = private unnamed_addr constant [23 x i8] c"Expected argument name\00"
@.str.235 = private unnamed_addr constant [33 x i8] c"Expected ':' after argument name\00"
@.str.236 = private unnamed_addr constant [35 x i8] c"Expected ',' or ')' after argument\00"
@.str.237 = private unnamed_addr constant [34 x i8] c"Expected name after hint symbol #\00"
@.str.238 = private unnamed_addr constant [37 x i8] c"Expected ')' after arguments in hint\00"
@.str.239 = private unnamed_addr constant [42 x i8] c"Expected ']' after arguments in attribute\00"
@.str.240 = private unnamed_addr constant [34 x i8] c"Expected function name after 'fn'\00"
@.str.241 = private unnamed_addr constant [40 x i8] c"Expected '(' or '<' after function name\00"
@.str.242 = private unnamed_addr constant [11 x i8] c"TODO ERROR\00"
@.str.243 = private unnamed_addr constant [39 x i8] c"Expected ';' after expression function\00"
@.str.244 = private unnamed_addr constant [24 x i8] c"Expected namespace name\00"
@.str.245 = private unnamed_addr constant [40 x i8] c"Expected namespace body after namespace\00"
@.str.246 = private unnamed_addr constant [19 x i8] c"Expected enum name\00"
@.str.247 = private unnamed_addr constant [21 x i8] c"Expected struct name\00"
@.str.248 = private unnamed_addr constant [6 x i8] c"@@@@\0A\00"
@.str.249 = private unnamed_addr constant [34 x i8] c"--UNEXPECTED TOKEN in TOP SCOPE--\00"
@.str.250 = private unnamed_addr constant [9 x i8] c"ACHTUNG:\00"
@.str.251 = private unnamed_addr constant [24 x i8] c"Character not expected!\00"
@.str.252 = private unnamed_addr constant [27 x i8] c"Duplicate symbols detected\00"
@.str.253 = private unnamed_addr constant [3 x i8] c"if\00"
@.str.254 = private unnamed_addr constant [3 x i8] c"do\00"
@.str.255 = private unnamed_addr constant [3 x i8] c"as\00"
@.str.256 = private unnamed_addr constant [3 x i8] c"in\00"
@.str.257 = private unnamed_addr constant [3 x i8] c"fn\00"
@.str.258 = private unnamed_addr constant [4 x i8] c"let\00"
@.str.259 = private unnamed_addr constant [4 x i8] c"pub\00"
@.str.260 = private unnamed_addr constant [4 x i8] c"for\00"
@.str.261 = private unnamed_addr constant [5 x i8] c"true\00"
@.str.262 = private unnamed_addr constant [5 x i8] c"loop\00"
@.str.263 = private unnamed_addr constant [5 x i8] c"this\00"
@.str.264 = private unnamed_addr constant [5 x i8] c"null\00"
@.str.265 = private unnamed_addr alias [5 x i8], [5 x i8]* bitcast (i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str.226, i64 0, i64 19) to [5 x i8]*)
@.str.266 = private unnamed_addr constant [5 x i8] c"enum\00"
@.str.267 = private unnamed_addr constant [5 x i8] c"impl\00"
@.str.268 = private unnamed_addr constant [6 x i8] c"const\00"
@.str.269 = private unnamed_addr alias [6 x i8], [6 x i8]* bitcast (i8* getelementptr inbounds ([33 x i8], [33 x i8]* @.str.65, i64 0, i64 27) to [6 x i8]*)
@.str.270 = private unnamed_addr constant [6 x i8] c"trait\00"
@.str.271 = private unnamed_addr constant [6 x i8] c"while\00"
@.str.272 = private unnamed_addr alias [6 x i8], [6 x i8]* bitcast (i8* getelementptr inbounds ([25 x i8], [25 x i8]* @.str.223, i64 0, i64 19) to [6 x i8]*)
@.str.273 = private unnamed_addr constant [6 x i8] c"false\00"
@.str.274 = private unnamed_addr constant [7 x i8] c"inline\00"
@.str.275 = private unnamed_addr constant [7 x i8] c"extern\00"
@.str.276 = private unnamed_addr constant [7 x i8] c"static\00"
@.str.277 = private unnamed_addr constant [7 x i8] c"struct\00"
@.str.278 = private unnamed_addr constant [7 x i8] c"return\00"
@.str.279 = private unnamed_addr alias [9 x i8], [9 x i8]* bitcast (i8* getelementptr inbounds ([28 x i8], [28 x i8]* @.str.224, i64 0, i64 19) to [9 x i8]*)
@.str.280 = private unnamed_addr alias [9 x i8], [9 x i8]* bitcast (i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str.284, i64 0, i64 14) to [9 x i8]*)
@.str.281 = private unnamed_addr alias [10 x i8], [10 x i8]* bitcast (i8* getelementptr inbounds ([40 x i8], [40 x i8]* @.str.245, i64 0, i64 30) to [10 x i8]*)
@.str.282 = private unnamed_addr constant [26 x i8] c"Invalid escape character!\00"
@.str.283 = private unnamed_addr constant [17 x i8] c"Char is too long\00"
@.str.284 = private unnamed_addr constant [23 x i8] c"Invalid unary operator\00"
@.str.285 = private unnamed_addr constant [22 x i8] c"Path with length zero\00"
@.str.286 = private unnamed_addr constant [13 x i8] c"TODO GENERIC\00"
@.str.287 = private unnamed_addr constant [15 x i8] c"Name not found\00"
@.str.288 = private unnamed_addr constant [24 x i8] c"Invalid binary operator\00"
@.str.289 = private unnamed_addr constant [15 x i8] c"TODO free_type\00"
@.str.290 = private unnamed_addr constant [3 x i8] c"i8\00"
@.str.291 = private unnamed_addr constant [3 x i8] c"u8\00"
@.str.292 = private unnamed_addr constant [4 x i8] c"i16\00"
@.str.293 = private unnamed_addr constant [4 x i8] c"i32\00"
@.str.294 = private unnamed_addr constant [4 x i8] c"i64\00"
@.str.295 = private unnamed_addr constant [4 x i8] c"u32\00"
@.str.296 = private unnamed_addr constant [4 x i8] c"u64\00"
@.str.297 = private unnamed_addr constant [4 x i8] c"f16\00"
@.str.298 = private unnamed_addr constant [4 x i8] c"f32\00"
@.str.299 = private unnamed_addr constant [4 x i8] c"f64\00"
@.str.300 = private unnamed_addr constant [5 x i8] c"void\00"
@.str.301 = private unnamed_addr constant [5 x i8] c"bool\00"
@.str.302 = private unnamed_addr constant [6 x i8] c"usize\00"
@.str.303 = private unnamed_addr constant [6 x i8] c"isize\00"
@.str.304 = private unnamed_addr constant [5 x i8] c"-->\09\00"
@.str.305 = private unnamed_addr constant [6 x i8] c"\09<--\0A\00"
@.str.306 = private unnamed_addr constant [4 x i8] c"fn(\00"
@.str.307 = private unnamed_addr constant [5 x i8] c") : \00"
@.str.308 = private unnamed_addr constant [3 x i8] c"; \00"
@.str.309 = private unnamed_addr constant [7 x i8] c";enum \00"
@.str.310 = private unnamed_addr alias [3 x i8], [3 x i8]* bitcast (i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.11, i64 0, i64 11) to [3 x i8]*)
@.str.311 = private unnamed_addr constant [9 x i8] c";struct \00"
@.str.312 = private unnamed_addr constant [11 x i8] c";constant \00"
@.str.313 = private unnamed_addr constant [4 x i8] c" = \00"
@.str.314 = private unnamed_addr constant [8 x i8] c"define \00"
@.str.315 = private unnamed_addr alias [11 x i8], [11 x i8]* bitcast (i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str.94, i64 0, i64 8) to [11 x i8]*)
@.str.316 = private unnamed_addr constant [3 x i8] c" @\00"
@.str.317 = private unnamed_addr constant [3 x i8] c" %\00"
@.str.318 = private unnamed_addr constant [5 x i8] c" as \00"
@.str.319 = private unnamed_addr constant [14 x i8] c"Not expected!\00"
@.str.320 = private unnamed_addr constant [52 x i8] c"INCLUDE ALREADY HANDLED, OTHERS ARE NOT IMPLEMENTED\00"
@.str.321 = private unnamed_addr constant [27 x i8] c"Nested namespaces too deep\00"
@.str.322 = private unnamed_addr constant [25 x i8] c"constant must have value\00"
@.str.323 = private unnamed_addr constant [32 x i8] c"let is not allowed in top scope\00"
@.str.324 = private unnamed_addr constant [7 x i8] c"@@@@\0A\0D\00"
@.str.325 = private unnamed_addr constant [25 x i8] c"--UNEXPECTED STATEMENT--\00"
@.str.326 = private unnamed_addr constant [8 x i8] c"struct.\00"
@.str.327 = private unnamed_addr constant [5 x i8] c"TODO\00"
@.str.328 = private unnamed_addr constant [45 x i8] c"compile_internal_sym_table_prefill fucked up\00"
@.str.329 = private unnamed_addr constant [8 x i8] c"\09const \00"
@.str.330 = private unnamed_addr constant [9 x i8] c"\09static \00"
@.str.331 = private unnamed_addr constant [6 x i8] c"\09let \00"
@.str.332 = private unnamed_addr alias [4 x i8], [4 x i8]* bitcast (i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.307, i64 0, i64 1) to [4 x i8]*)
@.str.333 = private unnamed_addr constant [9 x i8] c"\09return \00"
@.str.334 = private unnamed_addr constant [5 x i8] c"\09if \00"
@.str.335 = private unnamed_addr alias [4 x i8], [4 x i8]* bitcast (i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.336, i64 0, i64 7) to [4 x i8]*)
@.str.336 = private unnamed_addr constant [11 x i8] c"\09} else {\0A\00"
@.str.337 = private unnamed_addr constant [4 x i8] c"\09}\0A\00"
@.str.338 = private unnamed_addr constant [8 x i8] c"\09loop{\0A\00"
@.str.339 = private unnamed_addr constant [8 x i8] c"\09while \00"
@.str.340 = private unnamed_addr alias [3 x i8], [3 x i8]* bitcast (i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.336, i64 0, i64 8) to [3 x i8]*)
@.str.341 = private unnamed_addr constant [6 x i8] c"\09for \00"
@.str.342 = private unnamed_addr constant [5 x i8] c" in \00"
@.str.343 = private unnamed_addr constant [6 x i8] c"\09do{\0A\00"
@.str.344 = private unnamed_addr constant [9 x i8] c"\09}while \00"
@.str.345 = private unnamed_addr constant [3 x i8] c";\0A\00"
@.str.346 = private unnamed_addr constant [12 x i8] c"\09\09continue\0A\00"
@.str.347 = private unnamed_addr constant [9 x i8] c"\09\09break\0A\00"
@.str.348 = private unnamed_addr constant [30 x i8] c"--UNEXPECTED STATEMENT-- BDOY\00"
@.str.349 = private unnamed_addr constant [3 x i8] c"i1\00"
@.str.350 = private unnamed_addr constant [4 x i8] c"u16\00"
@.str.351 = private unnamed_addr constant [5 x i8] c"half\00"
@.str.352 = private unnamed_addr constant [6 x i8] c"float\00"
@.str.353 = private unnamed_addr constant [7 x i8] c"double\00"
@.str.354 = private unnamed_addr constant [32 x i8] c"Poping from vector of zero size\00"
@DEFAULT_INTEGER_TYPE = internal global %struct.PrimitiveTypeInfo* zeroinitializer
@POINTER_LAYOUT = internal global %struct.Layout zeroinitializer
@PRIMITIVE_TYPES_INFO = internal global [15 x %struct.PrimitiveTypeInfo] zeroinitializer
@VOID_TYPE = internal global %struct.PrimitiveTypeInfo* zeroinitializer
@stdlib.rand_seed = internal global i32 zeroinitializer

define void @mainCRTStartup(){
	call void @main()
	unreachable
}
define void @main(){
	call void @rcsharp_compile(i8* @.str.0, i8* @.str.1)
	ret void
}
define void @window.start_image_window(i8* %imagePath){
	%v0 = alloca i32
	%v1 = alloca i32
	%v2 = alloca %struct.window.WNDCLASSEXA
	%v3 = alloca %struct.window.RECT
	%v4 = alloca %struct.window.MSG
	%tmp0 = call i8* @GetModuleHandleA(i8* null)
	%tmp1 = icmp eq i8* %tmp0, null
	br i1 %tmp1, label %then1, label %endif1
then1:
	call void @process.throw(i8* @.str.2)
	br label %endif1
endif1:
	%tmp2 = call i8* @window.load_bitmap_from_file(i8* %imagePath)
	%tmp3 = icmp eq i8* %tmp2, null
	br i1 %tmp3, label %then2, label %endif2
then2:
	call void @process.throw(i8* @.str.3)
	br label %endif2
endif2:
	store i32 0, i32* %v0
	store i32 0, i32* %v1
	call void @window.get_bitmap_dimensions(i8* %tmp2, i32* %v0, i32* %v1)
	%tmp4 = or i32 2, 1
	%tmp5 = add i32 5, 1
	%tmp6 = sext i32 %tmp5 to i64
	%tmp7 = inttoptr i64 %tmp6 to i8*
	store i32 80, i32* %v2
	%tmp8 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v2, i32 0, i32 1
	store i32 %tmp4, i32* %tmp8
	%tmp9 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v2, i32 0, i32 2
	store i64 (i8*, i32, i64, i64)* @window.WindowProc, i64 (i8*, i32, i64, i64)** %tmp9
	%tmp10 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v2, i32 0, i32 3
	store i32 0, i32* %tmp10
	%tmp11 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v2, i32 0, i32 4
	store i32 0, i32* %tmp11
	%tmp12 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v2, i32 0, i32 5
	store i8* %tmp0, i8** %tmp12
	%tmp13 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v2, i32 0, i32 6
	store i8* null, i8** %tmp13
	%tmp14 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v2, i32 0, i32 7
	store i8* null, i8** %tmp14
	%tmp15 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v2, i32 0, i32 8
	store i8* %tmp7, i8** %tmp15
	%tmp16 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v2, i32 0, i32 9
	store i8* null, i8** %tmp16
	%tmp17 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v2, i32 0, i32 10
	store i8* @.str.4, i8** %tmp17
	%tmp18 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v2, i32 0, i32 11
	store i8* null, i8** %tmp18
	%tmp19 = call i16 @RegisterClassExA(%struct.window.WNDCLASSEXA* %v2)
	%tmp20 = icmp eq i16 %tmp19, 0
	br i1 %tmp20, label %then3, label %endif3
then3:
	call void @process.throw(i8* @.str.5)
	br label %endif3
endif3:
	%tmp21 = or i32 2147483648, 268435456
	%tmp22 = load i32, i32* %v0
	%tmp23 = load i32, i32* %v1
	%tmp24 = call i8* @CreateWindowExA(i32 8, i8* @.str.4, i8* @.str.6, i32 %tmp21, i32 100, i32 100, i32 %tmp22, i32 %tmp23, i8* null, i8* null, i8* %tmp0, i8* null)
	%tmp25 = icmp eq i8* %tmp24, null
	br i1 %tmp25, label %then5, label %endif5
then5:
	call void @process.throw(i8* @.str.7)
	br label %endif5
endif5:
	call i64 @SetWindowLongPtrA(i8* %tmp24, i32 -21, i8* %tmp2)
	call i32 @ShowWindow(i8* %tmp24, i32 5)
	call i32 @GetClientRect(i8* %tmp24, %struct.window.RECT* %v3)
	call i32 @InvalidateRect(i8* %tmp24, %struct.window.RECT* %v3, i32 1)
	br label %loop_start6
loop_start6:
	%tmp26 = call i32 @GetMessageA(%struct.window.MSG* %v4, i8* null, i32 0, i32 0)
	%tmp27 = icmp sgt i32 %tmp26, 0
	br i1 %tmp27, label %endif7, label %else7
else7:
	br label %loop_body6_exit
endif7:
	call i32 @TranslateMessage(%struct.window.MSG* %v4)
	call i64 @DispatchMessageA(%struct.window.MSG* %v4)
	br label %loop_start6
loop_body6_exit:
; Variable msg is out.
; Variable rect is out.
; Variable wc is out.
	ret void
}
define void @window.start(){
	%v0 = alloca %struct.window.WNDCLASSEXA
	%v1 = alloca %struct.window.MSG
	%tmp0 = call i8* @GetModuleHandleA(i8* null)
	%tmp1 = icmp eq i8* %tmp0, null
	br i1 %tmp1, label %then1, label %endif1
then1:
	call void @process.throw(i8* @.str.2)
	br label %endif1
endif1:
	%tmp2 = or i32 2, 1
	%tmp3 = add i32 5, 1
	%tmp4 = sext i32 %tmp3 to i64
	%tmp5 = inttoptr i64 %tmp4 to i8*
	store i32 80, i32* %v0
	%tmp6 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v0, i32 0, i32 1
	store i32 %tmp2, i32* %tmp6
	%tmp7 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v0, i32 0, i32 2
	store i64 (i8*, i32, i64, i64)* @window.WindowProc, i64 (i8*, i32, i64, i64)** %tmp7
	%tmp8 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v0, i32 0, i32 3
	store i32 0, i32* %tmp8
	%tmp9 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v0, i32 0, i32 4
	store i32 0, i32* %tmp9
	%tmp10 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v0, i32 0, i32 5
	store i8* %tmp0, i8** %tmp10
	%tmp11 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v0, i32 0, i32 6
	store i8* null, i8** %tmp11
	%tmp12 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v0, i32 0, i32 7
	store i8* null, i8** %tmp12
	%tmp13 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v0, i32 0, i32 8
	store i8* %tmp5, i8** %tmp13
	%tmp14 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v0, i32 0, i32 9
	store i8* null, i8** %tmp14
	%tmp15 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v0, i32 0, i32 10
	store i8* @.str.8, i8** %tmp15
	%tmp16 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v0, i32 0, i32 11
	store i8* null, i8** %tmp16
	%tmp17 = call i16 @RegisterClassExA(%struct.window.WNDCLASSEXA* %v0)
	%tmp18 = icmp eq i16 %tmp17, 0
	br i1 %tmp18, label %then2, label %endif2
then2:
	call void @process.throw(i8* @.str.5)
	br label %endif2
endif2:
	%tmp19 = call i8* @CreateWindowExA(i32 0, i8* @.str.8, i8* @.str.9, i32 13565952, i32 2147483648, i32 2147483648, i32 800, i32 600, i8* null, i8* null, i8* %tmp0, i8* null)
	%tmp20 = icmp eq i8* %tmp19, null
	br i1 %tmp20, label %then4, label %endif4
then4:
	call void @process.throw(i8* @.str.7)
	br label %endif4
endif4:
	call i32 @ShowWindow(i8* %tmp19, i32 5)
	br label %loop_start5
loop_start5:
	%tmp21 = call i32 @GetMessageA(%struct.window.MSG* %v1, i8* null, i32 0, i32 0)
	%tmp22 = icmp sgt i32 %tmp21, 0
	br i1 %tmp22, label %endif6, label %else6
else6:
	br label %loop_body5_exit
endif6:
	call i32 @TranslateMessage(%struct.window.MSG* %v1)
	call i64 @DispatchMessageA(%struct.window.MSG* %v1)
	br label %loop_start5
loop_body5_exit:
; Variable msg is out.
; Variable wc is out.
	ret void
}
define i8* @window.load_bitmap_from_file(i8* %path){
	%tmp0 = call i1 @fs.file_exists(i8* %path)
	%tmp1 = xor i1 1, %tmp0
	br i1 %tmp1, label %then0, label %endif0
then0:
	call void @process.throw(i8* @.str.10)
	br label %endif0
endif0:
	%tmp2 = call i8* @LoadImageA(i8* null, i8* %path, i32 0, i32 0, i32 0, i32 16)
	ret i8* %tmp2
}
define void @window.get_bitmap_dimensions(i8* %hBitmap, i32* %width, i32* %height){
	%v0 = alloca %struct.window.BITMAP
	call i32 @GetObjectA(i8* %hBitmap, i32 32, %struct.window.BITMAP* %v0)
	%tmp0 = getelementptr inbounds %struct.window.BITMAP, %struct.window.BITMAP* %v0, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	store i32 %tmp1, i32* %width
	%tmp2 = getelementptr inbounds %struct.window.BITMAP, %struct.window.BITMAP* %v0, i32 0, i32 2
	%tmp3 = load i32, i32* %tmp2
	store i32 %tmp3, i32* %height
; Variable bm is out.
	ret void
}
define void @window.draw_bitmap_stretched(i8* %hdc, i8* %hBitmap, i32 %x, i32 %y, i32 %width, i32 %height){
	%v0 = alloca %struct.window.BITMAP
	%tmp0 = icmp eq i8* %hBitmap, null
	br i1 %tmp0, label %then0, label %endif0
then0:
	br label %func_exit
endif0:
	%tmp1 = call i8* @CreateCompatibleDC(i8* %hdc)
	%tmp2 = call i8* @SelectObject(i8* %tmp1, i8* %hBitmap)
	call i32 @GetObjectA(i8* %hBitmap, i32 32, %struct.window.BITMAP* %v0)
	call i32 @SetStretchBltMode(i8* %hdc, i32 3)
	%tmp3 = getelementptr inbounds %struct.window.BITMAP, %struct.window.BITMAP* %v0, i32 0, i32 1
	%tmp4 = load i32, i32* %tmp3
	%tmp5 = getelementptr inbounds %struct.window.BITMAP, %struct.window.BITMAP* %v0, i32 0, i32 2
	%tmp6 = load i32, i32* %tmp5
	call i32 @StretchBlt(i8* %hdc, i32 %x, i32 %y, i32 %width, i32 %height, i8* %tmp1, i32 0, i32 0, i32 %tmp4, i32 %tmp6, i32 13369376)
	call i8* @SelectObject(i8* %tmp1, i8* %tmp2)
	call i32 @DeleteDC(i8* %tmp1)
	br label %func_exit
func_exit:
; Variable bm is out.
	ret void
}
define void @window.draw_bitmap(i8* %hdc, i8* %hBitmap, i32 %x, i32 %y){
	%v0 = alloca %struct.window.BITMAP
	%tmp0 = icmp eq i8* %hBitmap, null
	br i1 %tmp0, label %then0, label %endif0
then0:
	br label %func_exit
endif0:
	%tmp1 = call i8* @CreateCompatibleDC(i8* %hdc)
	%tmp2 = call i8* @SelectObject(i8* %tmp1, i8* %hBitmap)
	call i32 @GetObjectA(i8* %hBitmap, i32 32, %struct.window.BITMAP* %v0)
	%tmp3 = getelementptr inbounds %struct.window.BITMAP, %struct.window.BITMAP* %v0, i32 0, i32 1
	%tmp4 = load i32, i32* %tmp3
	%tmp5 = getelementptr inbounds %struct.window.BITMAP, %struct.window.BITMAP* %v0, i32 0, i32 2
	%tmp6 = load i32, i32* %tmp5
	call i32 @BitBlt(i8* %hdc, i32 %x, i32 %y, i32 %tmp4, i32 %tmp6, i8* %tmp1, i32 0, i32 0, i32 13369376)
	call i8* @SelectObject(i8* %tmp1, i8* %tmp2)
	call i32 @DeleteDC(i8* %tmp1)
	br label %func_exit
func_exit:
; Variable bm is out.
	ret void
}
define i64 @window.WindowProc(i8* %hWnd, i32 %uMsg, i64 %wParam, i64 %lParam){
	%v0 = alloca %struct.window.PAINTSTRUCT
	%tmp0 = icmp eq i32 %uMsg, 16
	br i1 %tmp0, label %then0, label %endif0
then0:
	call void @PostQuitMessage(i32 0)
	br label %func_exit
endif0:
	%tmp1 = icmp eq i32 %uMsg, 2
	br i1 %tmp1, label %then1, label %endif1
then1:
	call void @PostQuitMessage(i32 0)
	br label %func_exit
endif1:
	%tmp2 = icmp eq i32 %uMsg, 256
	br i1 %tmp2, label %then2, label %endif2
then2:
	%tmp3 = icmp eq i64 %wParam, 27
	br i1 %tmp3, label %then3, label %endif3
then3:
	call void @PostQuitMessage(i32 0)
	br label %func_exit
endif3:
	%tmp4 = trunc i64 %wParam to i8
	call void @console.print_char(i8 %tmp4)
	br label %endif2
endif2:
	%tmp5 = icmp eq i32 %uMsg, 8
	br i1 %tmp5, label %then4, label %endif4
then4:
	call void @PostQuitMessage(i32 0)
	br label %func_exit
endif4:
	%tmp6 = icmp eq i32 %uMsg, 132
	br i1 %tmp6, label %then5, label %endif5
then5:
	%tmp7 = call i64 @DefWindowProcA(i8* %hWnd, i32 %uMsg, i64 %wParam, i64 %lParam)
	%tmp8 = icmp eq i64 %tmp7, 1
	br i1 %tmp8, label %then6, label %endif6
then6:
	br label %func_exit
endif6:
	br label %func_exit
endif5:
	%tmp9 = icmp eq i32 %uMsg, 163
	br i1 %tmp9, label %then7, label %endif7
then7:
	br label %func_exit
endif7:
	%tmp10 = icmp eq i32 %uMsg, 15
	br i1 %tmp10, label %then8, label %endif8
then8:
	%tmp11 = call i8* @BeginPaint(i8* %hWnd, %struct.window.PAINTSTRUCT* %v0)
	%tmp12 = call i8* @GetWindowLongPtrA(i8* %hWnd, i32 -21)
	%tmp13 = icmp ne i8* %tmp12, null
	br i1 %tmp13, label %then9, label %endif9
then9:
	call void @window.draw_bitmap(i8* %tmp11, i8* %tmp12, i32 0, i32 0)
	br label %endif9
endif9:
	call i32 @EndPaint(i8* %hWnd, %struct.window.PAINTSTRUCT* %v0)
	br label %func_exit
; Variable ps is out.
endif8:
	%tmp14 = call i64 @DefWindowProcA(i8* %hWnd, i32 %uMsg, i64 %wParam, i64 %lParam)
	br label %func_exit
func_exit:
	%tmp15 = phi i64 [0, %then0], [0, %then1], [0, %then3], [0, %then4], [2, %then6], [%tmp7, %endif6], [0, %then7], [0, %endif9], [%tmp14, %endif8]
	ret i64 %tmp15
}
define void @tests.vector_test(){
entry:
	%v0 = alloca %"struct.vector.Vec<i8>"
	call void @console.write(i8* @.str.11, i32 13)
	%tmp0 = call %"struct.vector.Vec<i8>" @"vector.new<i8>"()
	store %"struct.vector.Vec<i8>" %tmp0, %"struct.vector.Vec<i8>"* %v0
	%tmp1 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 1
	%tmp2 = load i32, i32* %tmp1
	%tmp3 = icmp ne i32 %tmp2, 0
	br i1 %tmp3, label %logic_end_0, label %logic_rhs_0
logic_rhs_0:
	%tmp4 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 2
	%tmp5 = load i32, i32* %tmp4
	%tmp6 = icmp ne i32 %tmp5, 0
	br label %logic_end_0
logic_end_0:
	%tmp7 = phi i1 [%tmp3, %entry], [%tmp6, %logic_rhs_0]
	br i1 %tmp7, label %then1, label %endif1
then1:
	call void @process.throw(i8* @.str.12)
	br label %endif1
endif1:
	call void @"vector.push<i8>"(%"struct.vector.Vec<i8>"* %v0, i8 10)
	call void @"vector.push<i8>"(%"struct.vector.Vec<i8>"* %v0, i8 20)
	call void @"vector.push<i8>"(%"struct.vector.Vec<i8>"* %v0, i8 30)
	call void @"vector.push<i8>"(%"struct.vector.Vec<i8>"* %v0, i8 40)
	%tmp8 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 1
	%tmp9 = load i32, i32* %tmp8
	%tmp10 = icmp ne i32 %tmp9, 4
	br i1 %tmp10, label %logic_end_2, label %logic_rhs_2
logic_rhs_2:
	%tmp11 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 2
	%tmp12 = load i32, i32* %tmp11
	%tmp13 = icmp ne i32 %tmp12, 4
	br label %logic_end_2
logic_end_2:
	%tmp14 = phi i1 [%tmp10, %endif1], [%tmp13, %logic_rhs_2]
	br i1 %tmp14, label %then3, label %endif3
then3:
	call void @process.throw(i8* @.str.13)
	br label %endif3
endif3:
	%tmp15 = load i8*, i8** %v0
	%tmp16 = load i8, i8* %tmp15
	%tmp17 = icmp ne i8 %tmp16, 10
	br i1 %tmp17, label %logic_end_4, label %logic_rhs_4
logic_rhs_4:
	%tmp18 = load i8*, i8** %v0
	%tmp19 = getelementptr inbounds i8, i8* %tmp18, i64 3
	%tmp20 = load i8, i8* %tmp19
	%tmp21 = icmp ne i8 %tmp20, 40
	br label %logic_end_4
logic_end_4:
	%tmp22 = phi i1 [%tmp17, %endif3], [%tmp21, %logic_rhs_4]
	br i1 %tmp22, label %then5, label %endif5
then5:
	call void @process.throw(i8* @.str.14)
	br label %endif5
endif5:
	call void @"vector.push<i8>"(%"struct.vector.Vec<i8>"* %v0, i8 50)
	%tmp23 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 1
	%tmp24 = load i32, i32* %tmp23
	%tmp25 = icmp ne i32 %tmp24, 5
	br i1 %tmp25, label %logic_end_6, label %logic_rhs_6
logic_rhs_6:
	%tmp26 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 2
	%tmp27 = load i32, i32* %tmp26
	%tmp28 = icmp ne i32 %tmp27, 8
	br label %logic_end_6
logic_end_6:
	%tmp29 = phi i1 [%tmp25, %endif5], [%tmp28, %logic_rhs_6]
	br i1 %tmp29, label %then7, label %endif7
then7:
	call void @process.throw(i8* @.str.15)
	br label %endif7
endif7:
	%tmp30 = load i8*, i8** %v0
	%tmp31 = getelementptr inbounds i8, i8* %tmp30, i64 4
	%tmp32 = load i8, i8* %tmp31
	%tmp33 = icmp ne i8 %tmp32, 50
	br i1 %tmp33, label %logic_end_8, label %logic_rhs_8
logic_rhs_8:
	%tmp34 = load i8*, i8** %v0
	%tmp35 = load i8, i8* %tmp34
	%tmp36 = icmp ne i8 %tmp35, 10
	br label %logic_end_8
logic_end_8:
	%tmp37 = phi i1 [%tmp33, %endif7], [%tmp36, %logic_rhs_8]
	br i1 %tmp37, label %then9, label %endif9
then9:
	call void @process.throw(i8* @.str.16)
	br label %endif9
endif9:
	call void @"vector.push_bulk<i8>"(%"struct.vector.Vec<i8>"* %v0, i8* @.str.17, i32 2)
	%tmp38 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 1
	%tmp39 = load i32, i32* %tmp38
	%tmp40 = icmp ne i32 %tmp39, 7
	br i1 %tmp40, label %then10, label %endif10
then10:
	call void @process.throw(i8* @.str.18)
	br label %endif10
endif10:
	%tmp41 = load i8*, i8** %v0
	%tmp42 = getelementptr inbounds i8, i8* %tmp41, i64 5
	%tmp43 = load i8, i8* %tmp42
	%tmp44 = icmp ne i8 %tmp43, 65
	br i1 %tmp44, label %logic_end_11, label %logic_rhs_11
logic_rhs_11:
	%tmp45 = load i8*, i8** %v0
	%tmp46 = getelementptr inbounds i8, i8* %tmp45, i64 6
	%tmp47 = load i8, i8* %tmp46
	%tmp48 = icmp ne i8 %tmp47, 66
	br label %logic_end_11
logic_end_11:
	%tmp49 = phi i1 [%tmp44, %endif10], [%tmp48, %logic_rhs_11]
	br i1 %tmp49, label %then12, label %endif12
then12:
	call void @process.throw(i8* @.str.19)
	br label %endif12
endif12:
	call void @"vector.free<i8>"(%"struct.vector.Vec<i8>"* %v0)
	%tmp50 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 1
	%tmp51 = load i32, i32* %tmp50
	%tmp52 = icmp ne i32 %tmp51, 0
	br i1 %tmp52, label %logic_end_13, label %logic_rhs_13
logic_rhs_13:
	%tmp53 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 2
	%tmp54 = load i32, i32* %tmp53
	%tmp55 = icmp ne i32 %tmp54, 0
	br label %logic_end_13
logic_end_13:
	%tmp56 = phi i1 [%tmp52, %endif12], [%tmp55, %logic_rhs_13]
	br i1 %tmp56, label %logic_end_14, label %logic_rhs_14
logic_rhs_14:
	%tmp57 = load i8*, i8** %v0
	%tmp58 = icmp ne i8* %tmp57, null
	br label %logic_end_14
logic_end_14:
	%tmp59 = phi i1 [%tmp56, %logic_end_13], [%tmp58, %logic_rhs_14]
	br i1 %tmp59, label %then15, label %endif15
then15:
	call void @process.throw(i8* @.str.20)
	br label %endif15
endif15:
	call void @console.writeln(i8* @.str.21, i32 2)
; Variable v is out.
	ret void
}
define i1 @tests.valid_name_token(i8 %c){
	br label %inl_entry0
inl_entry0:
	%tmp0 = icmp sge i8 %c, 97
	br i1 %tmp0, label %logic_rhs_1, label %logic_end_1
logic_rhs_1:
	%tmp1 = icmp sle i8 %c, 122
	br label %logic_end_1
logic_end_1:
	%tmp2 = phi i1 [%tmp0, %inl_entry0], [%tmp1, %logic_rhs_1]
	br i1 %tmp2, label %logic_end_2, label %logic_rhs_2
logic_rhs_2:
	%tmp3 = icmp sge i8 %c, 65
	br i1 %tmp3, label %logic_rhs_3, label %logic_end_3
logic_rhs_3:
	%tmp4 = icmp sle i8 %c, 90
	br label %logic_end_3
logic_end_3:
	%tmp5 = phi i1 [%tmp3, %logic_rhs_2], [%tmp4, %logic_rhs_3]
	br label %logic_end_2
logic_end_2:
	%tmp6 = phi i1 [%tmp2, %logic_end_1], [%tmp5, %logic_end_3]
	br label %inl_exit0
inl_exit0:
	br i1 %tmp6, label %logic_end_4, label %logic_rhs_4
logic_rhs_4:
	br label %inl_entry5
inl_entry5:
	%tmp7 = icmp sge i8 %c, 48
	br i1 %tmp7, label %logic_rhs_6, label %logic_end_6
logic_rhs_6:
	%tmp8 = icmp sle i8 %c, 57
	br label %logic_end_6
logic_end_6:
	%tmp9 = phi i1 [%tmp7, %inl_entry5], [%tmp8, %logic_rhs_6]
	br label %inl_exit5
inl_exit5:
	br label %logic_end_4
logic_end_4:
	%tmp10 = phi i1 [%tmp6, %inl_exit0], [%tmp9, %inl_exit5]
	br i1 %tmp10, label %logic_end_7, label %logic_rhs_7
logic_rhs_7:
	%tmp11 = icmp eq i8 %c, 95
	br label %logic_end_7
logic_end_7:
	%tmp12 = phi i1 [%tmp10, %logic_end_4], [%tmp11, %logic_rhs_7]
	ret i1 %tmp12
}
define void @tests.string_utils_test(){
	%v0 = alloca i32
	call void @console.write(i8* @.str.22, i32 19)
	%tmp0 = call i32 @string_utils.c_str_len(i8* @.str.23)
	%tmp1 = icmp ne i32 %tmp0, 4
	br i1 %tmp1, label %then0, label %endif0
then0:
	call void @process.throw(i8* @.str.24)
	br label %endif0
endif0:
	%tmp2 = call i32 @string_utils.c_str_len(i8* @.str.25)
	%tmp3 = icmp ne i32 %tmp2, 0
	br i1 %tmp3, label %then1, label %endif1
then1:
	call void @process.throw(i8* @.str.26)
	br label %endif1
endif1:
	br label %inl_entry2
inl_entry2:
	%tmp4 = icmp sge i8 55, 48
	br i1 %tmp4, label %logic_rhs_3, label %logic_end_3
logic_rhs_3:
	%tmp5 = icmp sle i8 55, 57
	br label %logic_end_3
logic_end_3:
	%tmp6 = phi i1 [%tmp4, %inl_entry2], [%tmp5, %logic_rhs_3]
	br label %inl_exit2
inl_exit2:
	%tmp7 = xor i1 1, %tmp6
	br i1 %tmp7, label %logic_end_4, label %logic_rhs_4
logic_rhs_4:
	br label %inl_entry5
inl_entry5:
	%tmp8 = icmp sge i8 98, 48
	br i1 %tmp8, label %logic_rhs_6, label %logic_end_6
logic_rhs_6:
	%tmp9 = icmp sle i8 98, 57
	br label %logic_end_6
logic_end_6:
	%tmp10 = phi i1 [%tmp8, %inl_entry5], [%tmp9, %logic_rhs_6]
	br label %inl_exit5
inl_exit5:
	br label %logic_end_4
logic_end_4:
	%tmp11 = phi i1 [%tmp7, %inl_exit2], [%tmp10, %inl_exit5]
	br i1 %tmp11, label %then7, label %endif7
then7:
	call void @process.throw(i8* @.str.27)
	br label %endif7
endif7:
	br label %inl_entry8
inl_entry8:
	%tmp12 = icmp sge i8 97, 97
	br i1 %tmp12, label %logic_rhs_9, label %logic_end_9
logic_rhs_9:
	%tmp13 = icmp sle i8 97, 122
	br label %logic_end_9
logic_end_9:
	%tmp14 = phi i1 [%tmp12, %inl_entry8], [%tmp13, %logic_rhs_9]
	br i1 %tmp14, label %logic_end_10, label %logic_rhs_10
logic_rhs_10:
	%tmp15 = icmp sge i8 97, 65
	br i1 %tmp15, label %logic_rhs_11, label %logic_end_11
logic_rhs_11:
	%tmp16 = icmp sle i8 97, 90
	br label %logic_end_11
logic_end_11:
	%tmp17 = phi i1 [%tmp15, %logic_rhs_10], [%tmp16, %logic_rhs_11]
	br label %logic_end_10
logic_end_10:
	%tmp18 = phi i1 [%tmp14, %logic_end_9], [%tmp17, %logic_end_11]
	br label %inl_exit8
inl_exit8:
	%tmp19 = xor i1 1, %tmp18
	br i1 %tmp19, label %logic_end_12, label %logic_rhs_12
logic_rhs_12:
	br label %inl_entry13
inl_entry13:
	%tmp20 = icmp sge i8 57, 97
	br i1 %tmp20, label %logic_rhs_14, label %logic_end_14
logic_rhs_14:
	%tmp21 = icmp sle i8 57, 122
	br label %logic_end_14
logic_end_14:
	%tmp22 = phi i1 [%tmp20, %inl_entry13], [%tmp21, %logic_rhs_14]
	br i1 %tmp22, label %logic_end_15, label %logic_rhs_15
logic_rhs_15:
	%tmp23 = icmp sge i8 57, 65
	br i1 %tmp23, label %logic_rhs_16, label %logic_end_16
logic_rhs_16:
	%tmp24 = icmp sle i8 57, 90
	br label %logic_end_16
logic_end_16:
	%tmp25 = phi i1 [%tmp23, %logic_rhs_15], [%tmp24, %logic_rhs_16]
	br label %logic_end_15
logic_end_15:
	%tmp26 = phi i1 [%tmp22, %logic_end_14], [%tmp25, %logic_end_16]
	br label %inl_exit13
inl_exit13:
	br label %logic_end_12
logic_end_12:
	%tmp27 = phi i1 [%tmp19, %inl_exit8], [%tmp26, %inl_exit13]
	br i1 %tmp27, label %then17, label %endif17
then17:
	call void @process.throw(i8* @.str.28)
	br label %endif17
endif17:
	br label %inl_entry19
inl_entry19:
	%tmp28 = icmp sge i8 70, 48
	br i1 %tmp28, label %logic_rhs_20, label %logic_end_20
logic_rhs_20:
	%tmp29 = icmp sle i8 70, 57
	br label %logic_end_20
logic_end_20:
	%tmp30 = phi i1 [%tmp28, %inl_entry19], [%tmp29, %logic_rhs_20]
	br label %inl_exit19
inl_exit19:
	br i1 %tmp30, label %logic_end_21, label %logic_rhs_21
logic_rhs_21:
	%tmp31 = icmp sge i8 70, 97
	br i1 %tmp31, label %logic_rhs_22, label %logic_end_22
logic_rhs_22:
	%tmp32 = icmp sle i8 70, 102
	br label %logic_end_22
logic_end_22:
	%tmp33 = phi i1 [%tmp31, %logic_rhs_21], [%tmp32, %logic_rhs_22]
	br label %logic_end_21
logic_end_21:
	%tmp34 = phi i1 [%tmp30, %inl_exit19], [%tmp33, %logic_end_22]
	br i1 %tmp34, label %logic_end_23, label %logic_rhs_23
logic_rhs_23:
	%tmp35 = icmp sge i8 70, 65
	br i1 %tmp35, label %logic_rhs_24, label %logic_end_24
logic_rhs_24:
	%tmp36 = icmp sle i8 70, 70
	br label %logic_end_24
logic_end_24:
	%tmp37 = phi i1 [%tmp35, %logic_rhs_23], [%tmp36, %logic_rhs_24]
	br label %logic_end_23
logic_end_23:
	%tmp38 = phi i1 [%tmp34, %logic_end_21], [%tmp37, %logic_end_24]
	br label %inl_exit18
inl_exit18:
	%tmp39 = xor i1 1, %tmp38
	br i1 %tmp39, label %logic_end_25, label %logic_rhs_25
logic_rhs_25:
	br label %inl_entry27
inl_entry27:
	%tmp40 = icmp sge i8 71, 48
	br i1 %tmp40, label %logic_rhs_28, label %logic_end_28
logic_rhs_28:
	%tmp41 = icmp sle i8 71, 57
	br label %logic_end_28
logic_end_28:
	%tmp42 = phi i1 [%tmp40, %inl_entry27], [%tmp41, %logic_rhs_28]
	br label %inl_exit27
inl_exit27:
	br i1 %tmp42, label %logic_end_29, label %logic_rhs_29
logic_rhs_29:
	%tmp43 = icmp sge i8 71, 97
	br i1 %tmp43, label %logic_rhs_30, label %logic_end_30
logic_rhs_30:
	%tmp44 = icmp sle i8 71, 102
	br label %logic_end_30
logic_end_30:
	%tmp45 = phi i1 [%tmp43, %logic_rhs_29], [%tmp44, %logic_rhs_30]
	br label %logic_end_29
logic_end_29:
	%tmp46 = phi i1 [%tmp42, %inl_exit27], [%tmp45, %logic_end_30]
	br i1 %tmp46, label %logic_end_31, label %logic_rhs_31
logic_rhs_31:
	%tmp47 = icmp sge i8 71, 65
	br i1 %tmp47, label %logic_rhs_32, label %logic_end_32
logic_rhs_32:
	%tmp48 = icmp sle i8 71, 70
	br label %logic_end_32
logic_end_32:
	%tmp49 = phi i1 [%tmp47, %logic_rhs_31], [%tmp48, %logic_rhs_32]
	br label %logic_end_31
logic_end_31:
	%tmp50 = phi i1 [%tmp46, %logic_end_29], [%tmp49, %logic_end_32]
	br label %inl_exit26
inl_exit26:
	br label %logic_end_25
logic_end_25:
	%tmp51 = phi i1 [%tmp39, %inl_exit18], [%tmp50, %inl_exit26]
	br i1 %tmp51, label %then33, label %endif33
then33:
	call void @process.throw(i8* @.str.29)
	br label %endif33
endif33:
	%tmp52 = call i8* @string_utils.insert(i8* @.str.30, i8* @.str.31, i32 1)
	store i32 0, i32* %v0
	br label %loop_start34
loop_start34:
	%tmp53 = load i32, i32* %v0
	%tmp54 = getelementptr inbounds i8, i8* %tmp52, i32 %tmp53
	%tmp55 = load i8, i8* %tmp54
	%tmp56 = icmp ne i8 %tmp55, 0
	br i1 %tmp56, label %logic_end_35, label %logic_rhs_35
logic_rhs_35:
	%tmp57 = load i32, i32* %v0
	%tmp58 = getelementptr inbounds i8, i8* @.str.32, i32 %tmp57
	%tmp59 = load i8, i8* %tmp58
	%tmp60 = icmp ne i8 %tmp59, 0
	br label %logic_end_35
logic_end_35:
	%tmp61 = phi i1 [%tmp56, %loop_start34], [%tmp60, %logic_rhs_35]
	br i1 %tmp61, label %endif36, label %else36
else36:
	br label %loop_body34_exit
endif36:
	%tmp62 = load i32, i32* %v0
	%tmp63 = getelementptr inbounds i8, i8* %tmp52, i32 %tmp62
	%tmp64 = load i8, i8* %tmp63
	%tmp65 = load i32, i32* %v0
	%tmp66 = getelementptr inbounds i8, i8* @.str.32, i32 %tmp65
	%tmp67 = load i8, i8* %tmp66
	%tmp68 = icmp ne i8 %tmp64, %tmp67
	br i1 %tmp68, label %then37, label %endif37
then37:
	call void @process.throw(i8* @.str.33)
	br label %endif37
endif37:
	%tmp69 = load i32, i32* %v0
	%tmp70 = add i32 %tmp69, 1
	store i32 %tmp70, i32* %v0
	br label %loop_start34
loop_body34_exit:
	call void @mem.free(i8* %tmp52)
	call void @console.writeln(i8* @.str.21, i32 2)
	ret void
}
define void @tests.string_test(){
	%v0 = alloca %struct.string.String
	%v1 = alloca %struct.string.String
	%v2 = alloca %struct.string.String
	%v3 = alloca %struct.string.String
	%v4 = alloca %struct.string.String
	call void @console.write(i8* @.str.34, i32 13)
	%tmp0 = call %struct.string.String @string.from_c_string(i8* @.str.35)
	store %struct.string.String %tmp0, %struct.string.String* %v0
	%tmp1 = call %struct.string.String @string.from_c_string(i8* @.str.35)
	store %struct.string.String %tmp1, %struct.string.String* %v1
	%tmp2 = call %struct.string.String @string.from_c_string(i8* @.str.36)
	store %struct.string.String %tmp2, %struct.string.String* %v2
	%tmp3 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	%tmp4 = load i32, i32* %tmp3
	%tmp5 = icmp ne i32 %tmp4, 5
	br i1 %tmp5, label %then0, label %endif0
then0:
	call void @process.throw(i8* @.str.37)
	br label %endif0
endif0:
	%tmp6 = call i1 @string.equal(%struct.string.String* %v0, %struct.string.String* %v1)
	%tmp7 = xor i1 1, %tmp6
	br i1 %tmp7, label %then1, label %endif1
then1:
	call void @process.throw(i8* @.str.38)
	br label %endif1
endif1:
	%tmp8 = call i1 @string.equal(%struct.string.String* %v0, %struct.string.String* %v2)
	br i1 %tmp8, label %then2, label %endif2
then2:
	call void @process.throw(i8* @.str.39)
	br label %endif2
endif2:
	%tmp9 = call %struct.string.String @string.append_c_string(%struct.string.String* %v0, i8* @.str.40)
	store %struct.string.String %tmp9, %struct.string.String* %v3
	%tmp10 = call %struct.string.String @string.from_c_string(i8* @.str.41)
	store %struct.string.String %tmp10, %struct.string.String* %v4
	%tmp11 = getelementptr inbounds %struct.string.String, %struct.string.String* %v3, i32 0, i32 1
	%tmp12 = load i32, i32* %tmp11
	%tmp13 = icmp ne i32 %tmp12, 11
	br i1 %tmp13, label %then3, label %endif3
then3:
	call void @process.throw(i8* @.str.42)
	br label %endif3
endif3:
	%tmp14 = call i1 @string.equal(%struct.string.String* %v3, %struct.string.String* %v4)
	%tmp15 = xor i1 1, %tmp14
	br i1 %tmp15, label %then4, label %endif4
then4:
	call void @process.throw(i8* @.str.43)
	br label %endif4
endif4:
	call void @string.free(%struct.string.String* %v0)
	call void @string.free(%struct.string.String* %v1)
	call void @string.free(%struct.string.String* %v2)
	call void @string.free(%struct.string.String* %v3)
	call void @string.free(%struct.string.String* %v4)
	call void @console.writeln(i8* @.str.21, i32 2)
; Variable s5 is out.
; Variable s4 is out.
; Variable s3 is out.
; Variable s2 is out.
; Variable s1 is out.
	ret void
}
define void @tests.run(){
	%tmp0 = call i64 @mem.get_total_allocated_memory_external()
	call void @tests.mem_test()
	call void @tests.string_utils_test()
	call void @tests.string_test()
	call void @tests.vector_test()
	call void @tests.list_test()
	call void @tests.process_test()
	call void @tests.console_test()
	call void @tests.fs_test()
	call void @tests.funny()
	%tmp1 = call i64 @mem.get_total_allocated_memory_external()
	%tmp2 = sub i64 %tmp1, %tmp0
	call void @console.write(i8* @.str.44, i32 19)
	call void @console.println_i64(i64 %tmp2)
	ret void
}
define void @tests.process_test(){
	%v0 = alloca %struct.string.String
	%v1 = alloca %struct.string.String
	call void @console.write(i8* @.str.45, i32 14)
	%tmp0 = call %struct.string.String @process.get_executable_path()
	store %struct.string.String %tmp0, %struct.string.String* %v0
	%tmp1 = call %struct.string.String @process.get_executable_env_path()
	store %struct.string.String %tmp1, %struct.string.String* %v1
	%tmp2 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	%tmp3 = load i32, i32* %tmp2
	%tmp4 = icmp sle i32 %tmp3, 0
	br i1 %tmp4, label %then0, label %endif0
then0:
	call void @process.throw(i8* @.str.46)
	br label %endif0
endif0:
	%tmp5 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 1
	%tmp6 = load i32, i32* %tmp5
	%tmp7 = icmp sle i32 %tmp6, 0
	br i1 %tmp7, label %then1, label %endif1
then1:
	call void @process.throw(i8* @.str.47)
	br label %endif1
endif1:
	%tmp8 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 1
	%tmp9 = load i32, i32* %tmp8
	%tmp10 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	%tmp11 = load i32, i32* %tmp10
	%tmp12 = icmp sge i32 %tmp9, %tmp11
	br i1 %tmp12, label %then2, label %endif2
then2:
	call void @process.throw(i8* @.str.48)
	br label %endif2
endif2:
	%tmp13 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 1
	%tmp14 = load i32, i32* %tmp13
	%tmp15 = sub i32 %tmp14, 1
	%tmp16 = load i8*, i8** %v1
	%tmp17 = getelementptr inbounds i8, i8* %tmp16, i32 %tmp15
	%tmp18 = load i8, i8* %tmp17
	%tmp19 = icmp ne i8 %tmp18, 92
	br i1 %tmp19, label %then3, label %endif3
then3:
	call void @process.throw(i8* @.str.49)
	br label %endif3
endif3:
	call void @console.write(i8* @.str.50, i32 17)
	%tmp20 = load i8*, i8** %v0
	%tmp21 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	%tmp22 = load i32, i32* %tmp21
	call void @console.writeln(i8* %tmp20, i32 %tmp22)
	call void @console.write(i8* @.str.51, i32 18)
	%tmp23 = load i8*, i8** %v1
	%tmp24 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 1
	%tmp25 = load i32, i32* %tmp24
	call void @console.writeln(i8* %tmp23, i32 %tmp25)
	call void @string.free(%struct.string.String* %v0)
	call void @string.free(%struct.string.String* %v1)
	call void @console.writeln(i8* @.str.21, i32 2)
; Variable env_path is out.
; Variable full_path is out.
	ret void
}
define i1 @tests.not_new_line(i8 %c){
	%tmp0 = icmp ne i8 %c, 10
	ret i1 %tmp0
}
define void @tests.mem_test(){
	%v0 = alloca i64
	%v1 = alloca i64
	%v2 = alloca i64
	call void @console.write(i8* @.str.52, i32 10)
	%tmp0 = call i8* @mem.malloc(i64 16)
	%tmp1 = icmp eq i8* %tmp0, null
	br i1 %tmp1, label %then0, label %endif0
then0:
	call void @process.throw(i8* @.str.53)
	br label %endif0
endif0:
	call void @mem.fill(i8 88, i8* %tmp0, i64 16)
	store i64 0, i64* %v0
	br label %loop_cond1
loop_cond1:
	%tmp2 = load i64, i64* %v0
	%tmp3 = icmp sge i64 %tmp2, 16
	br i1 %tmp3, label %then2, label %endif2
then2:
	br label %loop_body1_exit
endif2:
	%tmp4 = load i64, i64* %v0
	%tmp5 = getelementptr inbounds i8, i8* %tmp0, i64 %tmp4
	%tmp6 = load i8, i8* %tmp5
	%tmp7 = icmp ne i8 %tmp6, 88
	br i1 %tmp7, label %then3, label %endif3
then3:
	call void @process.throw(i8* @.str.54)
	br label %endif3
endif3:
	%tmp8 = load i64, i64* %v0
	%tmp9 = add i64 %tmp8, 1
	store i64 %tmp9, i64* %v0
	br label %loop_cond1
loop_body1_exit:
	call void @mem.zero_fill(i8* %tmp0, i64 16)
	store i64 0, i64* %v1
	br label %loop_cond4
loop_cond4:
	%tmp10 = load i64, i64* %v1
	%tmp11 = icmp sge i64 %tmp10, 16
	br i1 %tmp11, label %then5, label %endif5
then5:
	br label %loop_body4_exit
endif5:
	%tmp12 = load i64, i64* %v1
	%tmp13 = getelementptr inbounds i8, i8* %tmp0, i64 %tmp12
	%tmp14 = load i8, i8* %tmp13
	%tmp15 = icmp ne i8 %tmp14, 0
	br i1 %tmp15, label %then6, label %endif6
then6:
	call void @process.throw(i8* @.str.55)
	br label %endif6
endif6:
	%tmp16 = load i64, i64* %v1
	%tmp17 = add i64 %tmp16, 1
	store i64 %tmp17, i64* %v1
	br label %loop_cond4
loop_body4_exit:
	%tmp18 = call i8* @mem.malloc(i64 16)
	%tmp19 = icmp eq i8* %tmp18, null
	br i1 %tmp19, label %then7, label %endif7
then7:
	call void @process.throw(i8* @.str.56)
	br label %endif7
endif7:
	call void @mem.fill(i8 89, i8* %tmp18, i64 16)
	call void @mem.copy(i8* %tmp18, i8* %tmp0, i64 16)
	store i64 0, i64* %v2
	br label %loop_cond8
loop_cond8:
	%tmp20 = load i64, i64* %v2
	%tmp21 = icmp sge i64 %tmp20, 16
	br i1 %tmp21, label %then9, label %endif9
then9:
	br label %loop_body8_exit
endif9:
	%tmp22 = load i64, i64* %v2
	%tmp23 = getelementptr inbounds i8, i8* %tmp0, i64 %tmp22
	%tmp24 = load i8, i8* %tmp23
	%tmp25 = icmp ne i8 %tmp24, 89
	br i1 %tmp25, label %then10, label %endif10
then10:
	call void @process.throw(i8* @.str.57)
	br label %endif10
endif10:
	%tmp26 = load i64, i64* %v2
	%tmp27 = add i64 %tmp26, 1
	store i64 %tmp27, i64* %v2
	br label %loop_cond8
loop_body8_exit:
	call void @mem.free(i8* %tmp0)
	call void @mem.free(i8* %tmp18)
	call void @console.writeln(i8* @.str.21, i32 2)
	ret void
}
define void @tests.list_test(){
entry:
	%v0 = alloca %"struct.list.List<i32>"
	%v1 = alloca %"struct.list.ListNode<i32>"*
	call void @console.write(i8* @.str.58, i32 11)
	%tmp0 = call %"struct.list.List<i32>" @"list.new<i32>"()
	store %"struct.list.List<i32>" %tmp0, %"struct.list.List<i32>"* %v0
	%tmp1 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %v0, i32 0, i32 2
	%tmp2 = load i32, i32* %tmp1
	%tmp3 = icmp ne i32 %tmp2, 0
	br i1 %tmp3, label %logic_end_0, label %logic_rhs_0
logic_rhs_0:
	%tmp4 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v0
	%tmp5 = icmp ne %"struct.list.ListNode<i32>"* %tmp4, null
	br label %logic_end_0
logic_end_0:
	%tmp6 = phi i1 [%tmp3, %entry], [%tmp5, %logic_rhs_0]
	br i1 %tmp6, label %then1, label %endif1
then1:
	call void @process.throw(i8* @.str.59)
	br label %endif1
endif1:
	call void @"list.extend<i32>"(%"struct.list.List<i32>"* %v0, i32 100)
	call void @"list.extend<i32>"(%"struct.list.List<i32>"* %v0, i32 200)
	call void @"list.extend<i32>"(%"struct.list.List<i32>"* %v0, i32 300)
	%tmp7 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %v0, i32 0, i32 2
	%tmp8 = load i32, i32* %tmp7
	%tmp9 = icmp ne i32 %tmp8, 3
	br i1 %tmp9, label %then2, label %endif2
then2:
	call void @process.throw(i8* @.str.60)
	br label %endif2
endif2:
	%tmp10 = call i32 @"list.walk<i32>"(%"struct.list.List<i32>"* %v0)
	%tmp11 = icmp ne i32 %tmp10, 3
	br i1 %tmp11, label %then3, label %endif3
then3:
	call void @process.throw(i8* @.str.61)
	br label %endif3
endif3:
	%tmp12 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v0
	store %"struct.list.ListNode<i32>"* %tmp12, %"struct.list.ListNode<i32>"** %v1
	%tmp13 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v1
	%tmp14 = load i32, i32* %tmp13
	%tmp15 = icmp ne i32 %tmp14, 100
	br i1 %tmp15, label %then4, label %endif4
then4:
	call void @process.throw(i8* @.str.62)
	br label %endif4
endif4:
	%tmp16 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v1
	%tmp17 = getelementptr inbounds %"struct.list.ListNode<i32>", %"struct.list.ListNode<i32>"* %tmp16, i32 0, i32 1
	%tmp18 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %tmp17
	store %"struct.list.ListNode<i32>"* %tmp18, %"struct.list.ListNode<i32>"** %v1
	%tmp19 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v1
	%tmp20 = load i32, i32* %tmp19
	%tmp21 = icmp ne i32 %tmp20, 200
	br i1 %tmp21, label %then5, label %endif5
then5:
	call void @process.throw(i8* @.str.63)
	br label %endif5
endif5:
	%tmp22 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v1
	%tmp23 = getelementptr inbounds %"struct.list.ListNode<i32>", %"struct.list.ListNode<i32>"* %tmp22, i32 0, i32 1
	%tmp24 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %tmp23
	store %"struct.list.ListNode<i32>"* %tmp24, %"struct.list.ListNode<i32>"** %v1
	%tmp25 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v1
	%tmp26 = load i32, i32* %tmp25
	%tmp27 = icmp ne i32 %tmp26, 300
	br i1 %tmp27, label %then6, label %endif6
then6:
	call void @process.throw(i8* @.str.64)
	br label %endif6
endif6:
	%tmp28 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v1
	%tmp29 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %v0, i32 0, i32 1
	%tmp30 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %tmp29
	%tmp31 = icmp ne %"struct.list.ListNode<i32>"* %tmp28, %tmp30
	br i1 %tmp31, label %then7, label %endif7
then7:
	call void @process.throw(i8* @.str.65)
	br label %endif7
endif7:
	call void @"list.free<i32>"(%"struct.list.List<i32>"* %v0)
	%tmp32 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %v0, i32 0, i32 2
	%tmp33 = load i32, i32* %tmp32
	%tmp34 = icmp ne i32 %tmp33, 0
	br i1 %tmp34, label %logic_end_8, label %logic_rhs_8
logic_rhs_8:
	%tmp35 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v0
	%tmp36 = icmp ne %"struct.list.ListNode<i32>"* %tmp35, null
	br label %logic_end_8
logic_end_8:
	%tmp37 = phi i1 [%tmp34, %endif7], [%tmp36, %logic_rhs_8]
	br i1 %tmp37, label %then9, label %endif9
then9:
	call void @process.throw(i8* @.str.66)
	br label %endif9
endif9:
	call void @console.writeln(i8* @.str.21, i32 2)
; Variable l is out.
	ret void
}
define i1 @tests.is_valid_number_token(i8 %c){
	br label %inl_entry0
inl_entry0:
	%tmp0 = icmp sge i8 %c, 48
	br i1 %tmp0, label %logic_rhs_1, label %logic_end_1
logic_rhs_1:
	%tmp1 = icmp sle i8 %c, 57
	br label %logic_end_1
logic_end_1:
	%tmp2 = phi i1 [%tmp0, %inl_entry0], [%tmp1, %logic_rhs_1]
	br label %inl_exit0
inl_exit0:
	br i1 %tmp2, label %logic_end_2, label %logic_rhs_2
logic_rhs_2:
	br label %inl_entry4
inl_entry4:
	%tmp3 = icmp sge i8 %c, 48
	br i1 %tmp3, label %logic_rhs_5, label %logic_end_5
logic_rhs_5:
	%tmp4 = icmp sle i8 %c, 57
	br label %logic_end_5
logic_end_5:
	%tmp5 = phi i1 [%tmp3, %inl_entry4], [%tmp4, %logic_rhs_5]
	br label %inl_exit4
inl_exit4:
	br i1 %tmp5, label %logic_end_6, label %logic_rhs_6
logic_rhs_6:
	%tmp6 = icmp sge i8 %c, 97
	br i1 %tmp6, label %logic_rhs_7, label %logic_end_7
logic_rhs_7:
	%tmp7 = icmp sle i8 %c, 102
	br label %logic_end_7
logic_end_7:
	%tmp8 = phi i1 [%tmp6, %logic_rhs_6], [%tmp7, %logic_rhs_7]
	br label %logic_end_6
logic_end_6:
	%tmp9 = phi i1 [%tmp5, %inl_exit4], [%tmp8, %logic_end_7]
	br i1 %tmp9, label %logic_end_8, label %logic_rhs_8
logic_rhs_8:
	%tmp10 = icmp sge i8 %c, 65
	br i1 %tmp10, label %logic_rhs_9, label %logic_end_9
logic_rhs_9:
	%tmp11 = icmp sle i8 %c, 70
	br label %logic_end_9
logic_end_9:
	%tmp12 = phi i1 [%tmp10, %logic_rhs_8], [%tmp11, %logic_rhs_9]
	br label %logic_end_8
logic_end_8:
	%tmp13 = phi i1 [%tmp9, %logic_end_6], [%tmp12, %logic_end_9]
	br label %inl_exit3
inl_exit3:
	br label %logic_end_2
logic_end_2:
	%tmp14 = phi i1 [%tmp2, %inl_exit0], [%tmp13, %inl_exit3]
	br i1 %tmp14, label %logic_end_10, label %logic_rhs_10
logic_rhs_10:
	%tmp15 = icmp eq i8 %c, 95
	br label %logic_end_10
logic_end_10:
	%tmp16 = phi i1 [%tmp14, %logic_end_2], [%tmp15, %logic_rhs_10]
	ret i1 %tmp16
}
define void @tests.funny(){
	%v0 = alloca %struct.string.String
	%v1 = alloca i8
	%v2 = alloca i8
	%v3 = alloca i32
	%v4 = alloca %"struct.vector.Vec<%struct.string.String>"
	%v5 = alloca %"struct.vector.Vec<i64>"
	%v6 = alloca i32
	%v7 = alloca %struct.string.String
	%v8 = alloca %struct.string.String
	%v9 = alloca %struct.string.String
	%v10 = alloca i32
	%tmp0 = call i32 @fs.create_file(i8* @.str.67)
	%tmp1 = icmp eq i32 %tmp0, 1
	br i1 %tmp1, label %then0, label %endif0
then0:
	call i32 @fs.delete_file(i8* @.str.67)
	br label %func_exit
endif0:
	%tmp2 = call %struct.string.String @fs.read_full_file_as_string(i8* @.str.67)
	store %struct.string.String %tmp2, %struct.string.String* %v0
	%tmp3 = call %"struct.vector.Vec<%struct.string.String>" @"vector.new<%struct.string.String>"()
	store %"struct.vector.Vec<%struct.string.String>" %tmp3, %"struct.vector.Vec<%struct.string.String>"* %v4
	%tmp4 = call %"struct.vector.Vec<i64>" @"vector.new<i64>"()
	store %"struct.vector.Vec<i64>" %tmp4, %"struct.vector.Vec<i64>"* %v5
	%tmp5 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	%tmp6 = load i32, i32* %tmp5
	store i32 0, i32* %v6
	br label %loop_cond1
loop_cond1:
	%tmp7 = load i32, i32* %v6
	%tmp8 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	%tmp9 = load i32, i32* %tmp8
	%tmp10 = icmp sge i32 %tmp7, %tmp9
	br i1 %tmp10, label %then2, label %endif2
then2:
	br label %loop_body1_exit
endif2:
	%tmp11 = load i32, i32* %v6
	%tmp12 = load i8*, i8** %v0
	%tmp13 = getelementptr inbounds i8, i8* %tmp12, i32 %tmp11
	%tmp14 = load i8, i8* %tmp13
	store i8 %tmp14, i8* %v1
	%tmp15 = load i8, i8* %v1
	%tmp16 = icmp eq i8 %tmp15, 32
	br i1 %tmp16, label %logic_end_3, label %logic_rhs_3
logic_rhs_3:
	%tmp17 = load i8, i8* %v1
	%tmp18 = icmp eq i8 %tmp17, 9
	br label %logic_end_3
logic_end_3:
	%tmp19 = phi i1 [%tmp16, %endif2], [%tmp18, %logic_rhs_3]
	br i1 %tmp19, label %logic_end_4, label %logic_rhs_4
logic_rhs_4:
	%tmp20 = load i8, i8* %v1
	%tmp21 = icmp eq i8 %tmp20, 13
	br label %logic_end_4
logic_end_4:
	%tmp22 = phi i1 [%tmp19, %logic_end_3], [%tmp21, %logic_rhs_4]
	br i1 %tmp22, label %logic_end_5, label %logic_rhs_5
logic_rhs_5:
	%tmp23 = load i8, i8* %v1
	%tmp24 = icmp eq i8 %tmp23, 10
	br label %logic_end_5
logic_end_5:
	%tmp25 = phi i1 [%tmp22, %logic_end_4], [%tmp24, %logic_rhs_5]
	br i1 %tmp25, label %then6, label %endif6
then6:
	%tmp26 = load i32, i32* %v6
	%tmp27 = add i32 %tmp26, 1
	store i32 %tmp27, i32* %v6
	br label %loop_body1
endif6:
	%tmp28 = load i32, i32* %v6
	%tmp29 = add i32 %tmp28, 1
	%tmp30 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	%tmp31 = load i32, i32* %tmp30
	%tmp32 = icmp slt i32 %tmp29, %tmp31
	br i1 %tmp32, label %then7, label %else7
then7:
	%tmp33 = load i32, i32* %v6
	%tmp34 = add i32 %tmp33, 1
	%tmp35 = load i8*, i8** %v0
	%tmp36 = getelementptr inbounds i8, i8* %tmp35, i32 %tmp34
	%tmp37 = load i8, i8* %tmp36
	store i8 %tmp37, i8* %v2
	br label %endif7
else7:
	store i8 0, i8* %v2
	br label %endif7
endif7:
	%tmp38 = load i8, i8* %v1
	%tmp39 = icmp eq i8 %tmp38, 47
	br i1 %tmp39, label %logic_rhs_8, label %logic_end_8
logic_rhs_8:
	%tmp40 = load i8, i8* %v2
	%tmp41 = icmp eq i8 %tmp40, 47
	br label %logic_end_8
logic_end_8:
	%tmp42 = phi i1 [%tmp39, %endif7], [%tmp41, %logic_rhs_8]
	br i1 %tmp42, label %then9, label %endif9
then9:
	call void @tests.consume_while(%struct.string.String* %v0, i32* %v6, i1 (i8)* @tests.not_new_line)
	br label %loop_body1
endif9:
	%tmp43 = load i8, i8* %v1
	br label %inl_entry10
inl_entry10:
	%tmp44 = icmp sge i8 %tmp43, 48
	br i1 %tmp44, label %logic_rhs_11, label %logic_end_11
logic_rhs_11:
	%tmp45 = icmp sle i8 %tmp43, 57
	br label %logic_end_11
logic_end_11:
	%tmp46 = phi i1 [%tmp44, %inl_entry10], [%tmp45, %logic_rhs_11]
	br i1 %tmp46, label %then12, label %endif12
then12:
	%tmp47 = load i32, i32* %v6
	store i32 %tmp47, i32* %v3
	%tmp48 = load i8, i8* %v2
	%tmp49 = icmp eq i8 %tmp48, 120
	br i1 %tmp49, label %logic_end_13, label %logic_rhs_13
logic_rhs_13:
	%tmp50 = load i8, i8* %v2
	%tmp51 = icmp eq i8 %tmp50, 98
	br label %logic_end_13
logic_end_13:
	%tmp52 = phi i1 [%tmp49, %then12], [%tmp51, %logic_rhs_13]
	br i1 %tmp52, label %then14, label %endif14
then14:
	%tmp53 = load i32, i32* %v6
	%tmp54 = add i32 %tmp53, 2
	store i32 %tmp54, i32* %v6
	br label %endif14
endif14:
	call void @tests.consume_while(%struct.string.String* %v0, i32* %v6, i1 (i8)* @tests.is_valid_number_token)
	%tmp55 = load i32, i32* %v6
	%tmp56 = load i32, i32* %v3
	%tmp57 = sub i32 %tmp55, %tmp56
	%tmp58 = call %struct.string.String @string.with_size(i32 %tmp57)
	store %struct.string.String %tmp58, %struct.string.String* %v7
	%tmp59 = load i8*, i8** %v0
	%tmp60 = load i32, i32* %v3
	%tmp61 = getelementptr inbounds i8, i8* %tmp59, i32 %tmp60
	%tmp62 = load i8*, i8** %v7
	%tmp63 = getelementptr inbounds %struct.string.String, %struct.string.String* %v7, i32 0, i32 1
	%tmp64 = load i32, i32* %tmp63
	%tmp65 = sext i32 %tmp64 to i64
	call void @mem.copy(i8* %tmp61, i8* %tmp62, i64 %tmp65)
	%tmp66 = load %struct.string.String, %struct.string.String* %v7
	call void @"vector.push<%struct.string.String>"(%"struct.vector.Vec<%struct.string.String>"* %v4, %struct.string.String %tmp66)
	br label %loop_body1
; Variable temp_string is out.
endif12:
	%tmp67 = load i8, i8* %v1
	br label %inl_entry15
inl_entry15:
	%tmp68 = icmp sge i8 %tmp67, 97
	br i1 %tmp68, label %logic_rhs_16, label %logic_end_16
logic_rhs_16:
	%tmp69 = icmp sle i8 %tmp67, 122
	br label %logic_end_16
logic_end_16:
	%tmp70 = phi i1 [%tmp68, %inl_entry15], [%tmp69, %logic_rhs_16]
	br i1 %tmp70, label %logic_end_17, label %logic_rhs_17
logic_rhs_17:
	%tmp71 = icmp sge i8 %tmp67, 65
	br i1 %tmp71, label %logic_rhs_18, label %logic_end_18
logic_rhs_18:
	%tmp72 = icmp sle i8 %tmp67, 90
	br label %logic_end_18
logic_end_18:
	%tmp73 = phi i1 [%tmp71, %logic_rhs_17], [%tmp72, %logic_rhs_18]
	br label %logic_end_17
logic_end_17:
	%tmp74 = phi i1 [%tmp70, %logic_end_16], [%tmp73, %logic_end_18]
	br label %inl_exit15
inl_exit15:
	br i1 %tmp74, label %logic_end_19, label %logic_rhs_19
logic_rhs_19:
	%tmp75 = load i8, i8* %v1
	%tmp76 = icmp eq i8 %tmp75, 95
	br label %logic_end_19
logic_end_19:
	%tmp77 = phi i1 [%tmp74, %inl_exit15], [%tmp76, %logic_rhs_19]
	br i1 %tmp77, label %then20, label %endif20
then20:
	%tmp78 = load i32, i32* %v6
	store i32 %tmp78, i32* %v3
	call void @tests.consume_while(%struct.string.String* %v0, i32* %v6, i1 (i8)* @tests.valid_name_token)
	%tmp79 = load i32, i32* %v6
	%tmp80 = load i32, i32* %v3
	%tmp81 = sub i32 %tmp79, %tmp80
	%tmp82 = call %struct.string.String @string.with_size(i32 %tmp81)
	store %struct.string.String %tmp82, %struct.string.String* %v8
	%tmp83 = load i8*, i8** %v0
	%tmp84 = load i32, i32* %v3
	%tmp85 = getelementptr inbounds i8, i8* %tmp83, i32 %tmp84
	%tmp86 = load i8*, i8** %v8
	%tmp87 = getelementptr inbounds %struct.string.String, %struct.string.String* %v8, i32 0, i32 1
	%tmp88 = load i32, i32* %tmp87
	%tmp89 = sext i32 %tmp88 to i64
	call void @mem.copy(i8* %tmp85, i8* %tmp86, i64 %tmp89)
	%tmp90 = load %struct.string.String, %struct.string.String* %v8
	call void @"vector.push<%struct.string.String>"(%"struct.vector.Vec<%struct.string.String>"* %v4, %struct.string.String %tmp90)
	br label %loop_body1
; Variable temp_string is out.
endif20:
	%tmp91 = load i8, i8* %v1
	%tmp92 = icmp eq i8 %tmp91, 34
	br i1 %tmp92, label %then21, label %endif21
then21:
	%tmp93 = load i32, i32* %v6
	store i32 %tmp93, i32* %v3
	br label %loop_start22
loop_start22:
	%tmp94 = load i32, i32* %v6
	%tmp95 = add i32 %tmp94, 1
	store i32 %tmp95, i32* %v6
	%tmp96 = load i32, i32* %v6
	%tmp97 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	%tmp98 = load i32, i32* %tmp97
	%tmp99 = icmp sge i32 %tmp96, %tmp98
	br i1 %tmp99, label %then23, label %endif23
then23:
	br label %loop_body22_exit
endif23:
	%tmp100 = load i32, i32* %v6
	%tmp101 = load i8*, i8** %v0
	%tmp102 = getelementptr inbounds i8, i8* %tmp101, i32 %tmp100
	%tmp103 = load i8, i8* %tmp102
	%tmp104 = icmp eq i8 %tmp103, 34
	br i1 %tmp104, label %then24, label %endif24
then24:
	%tmp105 = load i32, i32* %v6
	%tmp106 = add i32 %tmp105, 1
	store i32 %tmp106, i32* %v6
	br label %loop_body22_exit
endif24:
	br label %loop_start22
loop_body22_exit:
	%tmp107 = load i32, i32* %v6
	%tmp108 = load i32, i32* %v3
	%tmp109 = sub i32 %tmp107, %tmp108
	%tmp110 = call %struct.string.String @string.with_size(i32 %tmp109)
	store %struct.string.String %tmp110, %struct.string.String* %v9
	%tmp111 = load i8*, i8** %v0
	%tmp112 = load i32, i32* %v3
	%tmp113 = getelementptr inbounds i8, i8* %tmp111, i32 %tmp112
	%tmp114 = load i8*, i8** %v9
	%tmp115 = getelementptr inbounds %struct.string.String, %struct.string.String* %v9, i32 0, i32 1
	%tmp116 = load i32, i32* %tmp115
	%tmp117 = sext i32 %tmp116 to i64
	call void @mem.copy(i8* %tmp113, i8* %tmp114, i64 %tmp117)
	%tmp118 = load %struct.string.String, %struct.string.String* %v9
	call void @"vector.push<%struct.string.String>"(%"struct.vector.Vec<%struct.string.String>"* %v4, %struct.string.String %tmp118)
	br label %loop_body1
; Variable temp_string is out.
endif21:
	%tmp119 = load i8, i8* %v1
	%tmp120 = icmp eq i8 %tmp119, 39
	br i1 %tmp120, label %then25, label %endif25
then25:
	%tmp121 = load i32, i32* %v6
	%tmp122 = add i32 %tmp121, 1
	store i32 %tmp122, i32* %v6
	br label %loop_body1
endif25:
	%tmp123 = load i8, i8* %v1
	%tmp124 = icmp eq i8 %tmp123, 40
	br i1 %tmp124, label %then26, label %endif26
then26:
	%tmp125 = load i32, i32* %v6
	%tmp126 = add i32 %tmp125, 1
	store i32 %tmp126, i32* %v6
	br label %loop_body1
endif26:
	%tmp127 = load i8, i8* %v1
	%tmp128 = icmp eq i8 %tmp127, 41
	br i1 %tmp128, label %then27, label %endif27
then27:
	%tmp129 = load i32, i32* %v6
	%tmp130 = add i32 %tmp129, 1
	store i32 %tmp130, i32* %v6
	br label %loop_body1
endif27:
	%tmp131 = load i8, i8* %v1
	%tmp132 = icmp eq i8 %tmp131, 123
	br i1 %tmp132, label %then28, label %endif28
then28:
	%tmp133 = load i32, i32* %v6
	%tmp134 = add i32 %tmp133, 1
	store i32 %tmp134, i32* %v6
	br label %loop_body1
endif28:
	%tmp135 = load i8, i8* %v1
	%tmp136 = icmp eq i8 %tmp135, 125
	br i1 %tmp136, label %then29, label %endif29
then29:
	%tmp137 = load i32, i32* %v6
	%tmp138 = add i32 %tmp137, 1
	store i32 %tmp138, i32* %v6
	br label %loop_body1
endif29:
	%tmp139 = load i8, i8* %v1
	%tmp140 = icmp eq i8 %tmp139, 91
	br i1 %tmp140, label %then30, label %endif30
then30:
	%tmp141 = load i32, i32* %v6
	%tmp142 = add i32 %tmp141, 1
	store i32 %tmp142, i32* %v6
	br label %loop_body1
endif30:
	%tmp143 = load i8, i8* %v1
	%tmp144 = icmp eq i8 %tmp143, 93
	br i1 %tmp144, label %then31, label %endif31
then31:
	%tmp145 = load i32, i32* %v6
	%tmp146 = add i32 %tmp145, 1
	store i32 %tmp146, i32* %v6
	br label %loop_body1
endif31:
	%tmp147 = load i8, i8* %v1
	%tmp148 = icmp eq i8 %tmp147, 61
	br i1 %tmp148, label %then32, label %endif32
then32:
	%tmp149 = load i8, i8* %v2
	%tmp150 = icmp eq i8 %tmp149, 61
	br i1 %tmp150, label %then33, label %endif33
then33:
	%tmp151 = load i32, i32* %v6
	%tmp152 = add i32 %tmp151, 2
	store i32 %tmp152, i32* %v6
	br label %loop_body1
endif33:
	%tmp153 = load i32, i32* %v6
	%tmp154 = add i32 %tmp153, 1
	store i32 %tmp154, i32* %v6
	br label %loop_body1
endif32:
	%tmp155 = load i8, i8* %v1
	%tmp156 = icmp eq i8 %tmp155, 58
	br i1 %tmp156, label %then34, label %endif34
then34:
	%tmp157 = load i8, i8* %v2
	%tmp158 = icmp eq i8 %tmp157, 58
	br i1 %tmp158, label %then35, label %endif35
then35:
	%tmp159 = load i32, i32* %v6
	%tmp160 = add i32 %tmp159, 2
	store i32 %tmp160, i32* %v6
	br label %loop_body1
endif35:
	%tmp161 = load i32, i32* %v6
	%tmp162 = add i32 %tmp161, 1
	store i32 %tmp162, i32* %v6
	br label %loop_body1
endif34:
	%tmp163 = load i8, i8* %v1
	%tmp164 = icmp eq i8 %tmp163, 124
	br i1 %tmp164, label %then36, label %endif36
then36:
	%tmp165 = load i8, i8* %v2
	%tmp166 = icmp eq i8 %tmp165, 124
	br i1 %tmp166, label %then37, label %endif37
then37:
	%tmp167 = load i32, i32* %v6
	%tmp168 = add i32 %tmp167, 2
	store i32 %tmp168, i32* %v6
	br label %loop_body1
endif37:
	%tmp169 = load i32, i32* %v6
	%tmp170 = add i32 %tmp169, 1
	store i32 %tmp170, i32* %v6
	br label %loop_body1
endif36:
	%tmp171 = load i8, i8* %v1
	%tmp172 = icmp eq i8 %tmp171, 38
	br i1 %tmp172, label %then38, label %endif38
then38:
	%tmp173 = load i8, i8* %v2
	%tmp174 = icmp eq i8 %tmp173, 38
	br i1 %tmp174, label %then39, label %endif39
then39:
	%tmp175 = load i32, i32* %v6
	%tmp176 = add i32 %tmp175, 2
	store i32 %tmp176, i32* %v6
	br label %loop_body1
endif39:
	%tmp177 = load i32, i32* %v6
	%tmp178 = add i32 %tmp177, 1
	store i32 %tmp178, i32* %v6
	br label %loop_body1
endif38:
	%tmp179 = load i8, i8* %v1
	%tmp180 = icmp eq i8 %tmp179, 62
	br i1 %tmp180, label %then40, label %endif40
then40:
	%tmp181 = load i8, i8* %v2
	%tmp182 = icmp eq i8 %tmp181, 61
	br i1 %tmp182, label %then41, label %endif41
then41:
	%tmp183 = load i32, i32* %v6
	%tmp184 = add i32 %tmp183, 2
	store i32 %tmp184, i32* %v6
	br label %loop_body1
endif41:
	%tmp185 = load i32, i32* %v6
	%tmp186 = add i32 %tmp185, 1
	store i32 %tmp186, i32* %v6
	br label %loop_body1
endif40:
	%tmp187 = load i8, i8* %v1
	%tmp188 = icmp eq i8 %tmp187, 60
	br i1 %tmp188, label %then42, label %endif42
then42:
	%tmp189 = load i8, i8* %v2
	%tmp190 = icmp eq i8 %tmp189, 61
	br i1 %tmp190, label %then43, label %endif43
then43:
	%tmp191 = load i32, i32* %v6
	%tmp192 = add i32 %tmp191, 2
	store i32 %tmp192, i32* %v6
	br label %loop_body1
endif43:
	%tmp193 = load i32, i32* %v6
	%tmp194 = add i32 %tmp193, 1
	store i32 %tmp194, i32* %v6
	br label %loop_body1
endif42:
	%tmp195 = load i8, i8* %v1
	%tmp196 = icmp eq i8 %tmp195, 35
	br i1 %tmp196, label %then44, label %endif44
then44:
	%tmp197 = load i32, i32* %v6
	%tmp198 = add i32 %tmp197, 1
	store i32 %tmp198, i32* %v6
	br label %loop_body1
endif44:
	%tmp199 = load i8, i8* %v1
	%tmp200 = icmp eq i8 %tmp199, 59
	br i1 %tmp200, label %then45, label %endif45
then45:
	%tmp201 = load i32, i32* %v6
	%tmp202 = add i32 %tmp201, 1
	store i32 %tmp202, i32* %v6
	br label %loop_body1
endif45:
	%tmp203 = load i8, i8* %v1
	%tmp204 = icmp eq i8 %tmp203, 46
	br i1 %tmp204, label %then46, label %endif46
then46:
	%tmp205 = load i32, i32* %v6
	%tmp206 = add i32 %tmp205, 1
	store i32 %tmp206, i32* %v6
	br label %loop_body1
endif46:
	%tmp207 = load i8, i8* %v1
	%tmp208 = icmp eq i8 %tmp207, 44
	br i1 %tmp208, label %then47, label %endif47
then47:
	%tmp209 = load i32, i32* %v6
	%tmp210 = add i32 %tmp209, 1
	store i32 %tmp210, i32* %v6
	br label %loop_body1
endif47:
	%tmp211 = load i8, i8* %v1
	%tmp212 = icmp eq i8 %tmp211, 43
	br i1 %tmp212, label %then48, label %endif48
then48:
	%tmp213 = load i32, i32* %v6
	%tmp214 = add i32 %tmp213, 1
	store i32 %tmp214, i32* %v6
	br label %loop_body1
endif48:
	%tmp215 = load i8, i8* %v1
	%tmp216 = icmp eq i8 %tmp215, 45
	br i1 %tmp216, label %then49, label %endif49
then49:
	%tmp217 = load i32, i32* %v6
	%tmp218 = add i32 %tmp217, 1
	store i32 %tmp218, i32* %v6
	br label %loop_body1
endif49:
	%tmp219 = load i8, i8* %v1
	%tmp220 = icmp eq i8 %tmp219, 42
	br i1 %tmp220, label %then50, label %endif50
then50:
	%tmp221 = load i32, i32* %v6
	%tmp222 = add i32 %tmp221, 1
	store i32 %tmp222, i32* %v6
	br label %loop_body1
endif50:
	%tmp223 = load i8, i8* %v1
	%tmp224 = icmp eq i8 %tmp223, 47
	br i1 %tmp224, label %then51, label %endif51
then51:
	%tmp225 = load i32, i32* %v6
	%tmp226 = add i32 %tmp225, 1
	store i32 %tmp226, i32* %v6
	br label %loop_body1
endif51:
	%tmp227 = load i8, i8* %v1
	%tmp228 = icmp eq i8 %tmp227, 37
	br i1 %tmp228, label %then52, label %endif52
then52:
	%tmp229 = load i32, i32* %v6
	%tmp230 = add i32 %tmp229, 1
	store i32 %tmp230, i32* %v6
	br label %loop_body1
endif52:
	%tmp231 = load i8, i8* %v1
	%tmp232 = icmp eq i8 %tmp231, 33
	br i1 %tmp232, label %then53, label %endif53
then53:
	%tmp233 = load i32, i32* %v6
	%tmp234 = add i32 %tmp233, 1
	store i32 %tmp234, i32* %v6
	br label %loop_body1
endif53:
	%tmp235 = load i8, i8* %v1
	%tmp236 = icmp eq i8 %tmp235, 126
	br i1 %tmp236, label %then54, label %endif54
then54:
	%tmp237 = load i32, i32* %v6
	%tmp238 = add i32 %tmp237, 1
	store i32 %tmp238, i32* %v6
	br label %loop_body1
endif54:
	%tmp239 = load i8, i8* %v1
	%tmp240 = icmp eq i8 %tmp239, 92
	br i1 %tmp240, label %then55, label %endif55
then55:
	%tmp241 = load i32, i32* %v6
	%tmp242 = add i32 %tmp241, 1
	store i32 %tmp242, i32* %v6
	br label %loop_body1
endif55:
	%tmp243 = load i8, i8* %v1
	call void @console.print_char(i8 %tmp243)
	call void @console.print_char(i8 10)
	%tmp244 = load i32, i32* %v6
	%tmp245 = add i32 %tmp244, 1
	store i32 %tmp245, i32* %v6
	br label %loop_body1
loop_body1:
	%tmp246 = load i32, i32* %v6
	%tmp247 = add i32 %tmp246, 1
	store i32 %tmp247, i32* %v6
	br label %loop_cond1
loop_body1_exit:
	%tmp248 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %v4, i32 0, i32 1
	%tmp249 = load i32, i32* %tmp248
	store i32 0, i32* %v10
	br label %loop_cond56
loop_cond56:
	%tmp250 = load i32, i32* %v10
	%tmp251 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %v4, i32 0, i32 1
	%tmp252 = load i32, i32* %tmp251
	%tmp253 = icmp uge i32 %tmp250, %tmp252
	br i1 %tmp253, label %then57, label %endif57
then57:
	br label %loop_body56_exit
endif57:
	%tmp254 = load i32, i32* %v10
	%tmp255 = load %struct.string.String*, %struct.string.String** %v4
	%tmp256 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp255, i32 %tmp254
	call void @string.free(%struct.string.String* %tmp256)
	%tmp257 = load i32, i32* %v10
	%tmp258 = add i32 %tmp257, 1
	store i32 %tmp258, i32* %v10
	%tmp259 = load i32, i32* %v10
	%tmp260 = add i32 %tmp259, 1
	store i32 %tmp260, i32* %v10
	br label %loop_cond56
loop_body56_exit:
	call void @"vector.free<%struct.string.String>"(%"struct.vector.Vec<%struct.string.String>"* %v4)
	call void @string.free(%struct.string.String* %v0)
	br label %func_exit
func_exit:
; Variable tokens is out.
; Variable data is out.
; Variable file is out.
	ret void
}
define void @tests.fs_test(){
	%v0 = alloca %struct.string.String
	%v1 = alloca %struct.string.String
	%v2 = alloca %struct.string.String
	%v3 = alloca %struct.string.String
	call void @console.write(i8* @.str.68, i32 9)
	%tmp0 = call %struct.string.String @string.from_c_string(i8* @.str.69)
	store %struct.string.String %tmp0, %struct.string.String* %v0
	%tmp1 = call %struct.string.String @process.get_executable_env_path()
	store %struct.string.String %tmp1, %struct.string.String* %v1
	%tmp2 = call %struct.string.String @string.append_c_string(%struct.string.String* %v1, i8* @.str.70)
	store %struct.string.String %tmp2, %struct.string.String* %v2
	%tmp3 = getelementptr inbounds %struct.string.String, %struct.string.String* %v2, i32 0, i32 1
	%tmp4 = load i32, i32* %tmp3
	%tmp5 = add i32 %tmp4, 1
	%tmp6 = sext i32 %tmp5 to i64
	%tmp7 = alloca i8, i64 %tmp6
	%tmp8 = getelementptr inbounds %struct.string.String, %struct.string.String* %v2, i32 0, i32 1
	%tmp9 = load i32, i32* %tmp8
	%tmp10 = icmp sgt i32 %tmp9, 0
	br i1 %tmp10, label %then1, label %endif1
then1:
	%tmp11 = load i8*, i8** %v2
	%tmp12 = getelementptr inbounds %struct.string.String, %struct.string.String* %v2, i32 0, i32 1
	%tmp13 = load i32, i32* %tmp12
	%tmp14 = sext i32 %tmp13 to i64
	call void @mem.copy(i8* %tmp11, i8* %tmp7, i64 %tmp14)
	br label %endif1
endif1:
	%tmp15 = getelementptr inbounds %struct.string.String, %struct.string.String* %v2, i32 0, i32 1
	%tmp16 = load i32, i32* %tmp15
	%tmp17 = getelementptr inbounds i8, i8* %tmp7, i32 %tmp16
	store i8 0, i8* %tmp17
	call i32 @fs.create_file(i8* %tmp7)
	call i32 @fs.delete_file(i8* %tmp7)
	call i32 @fs.create_file(i8* %tmp7)
	%tmp18 = load i8*, i8** %v0
	%tmp19 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	%tmp20 = load i32, i32* %tmp19
	call i32 @fs.write_to_file(i8* %tmp7, i8* %tmp18, i32 %tmp20)
	%tmp21 = call %struct.string.String @fs.read_full_file_as_string(i8* %tmp7)
	store %struct.string.String %tmp21, %struct.string.String* %v3
	%tmp22 = call i1 @string.equal(%struct.string.String* %v0, %struct.string.String* %v3)
	%tmp23 = xor i1 1, %tmp22
	br i1 %tmp23, label %then2, label %endif2
then2:
	call void @process.throw(i8* @.str.71)
	br label %endif2
endif2:
	call i32 @fs.delete_file(i8* %tmp7)
	call void @string.free(%struct.string.String* %v3)
	call void @string.free(%struct.string.String* %v2)
	call void @string.free(%struct.string.String* %v1)
	call void @string.free(%struct.string.String* %v0)
	call void @console.writeln(i8* @.str.21, i32 2)
; Variable read is out.
; Variable new_file_path is out.
; Variable env_path is out.
; Variable data is out.
	ret void
}
define void @tests.consume_while(%struct.string.String* %file, i32* %iterator, i1 (i8)* %condition){
	br label %loop_start0
loop_start0:
	%tmp0 = load i32, i32* %iterator
	%tmp1 = getelementptr inbounds %struct.string.String, %struct.string.String* %file, i32 0, i32 1
	%tmp2 = load i32, i32* %tmp1
	%tmp3 = icmp slt i32 %tmp0, %tmp2
	br i1 %tmp3, label %endif1, label %else1
else1:
	br label %loop_body0_exit
endif1:
	%tmp4 = load i32, i32* %iterator
	%tmp5 = load i8*, i8** %file
	%tmp6 = getelementptr inbounds i8, i8* %tmp5, i32 %tmp4
	%tmp7 = load i8, i8* %tmp6
	%tmp8 = call i1 %condition(i8 %tmp7)
	br i1 %tmp8, label %then2, label %else2
then2:
	%tmp9 = load i32, i32* %iterator
	%tmp10 = add i32 %tmp9, 1
	store i32 %tmp10, i32* %iterator
	br label %endif2
else2:
	br label %loop_body0_exit
endif2:
	br label %loop_start0
loop_body0_exit:
	ret void
}
define void @tests.console_test(){
	call void @console.writeln(i8* @.str.72, i32 14)
	call void @console.writeln(i8* @.str.73, i32 25)
	call void @console.write(i8* @.str.74, i32 21)
	call void @console.println_i64(i64 12345)
	call void @console.write(i8* @.str.75, i32 22)
	call void @console.println_i64(i64 -67890)
	call void @console.write(i8* @.str.76, i32 17)
	call void @console.println_i64(i64 0)
	call void @console.write(i8* @.str.77, i32 26)
	call void @console.println_u64(i64 9876543210)
	call void @console.writeln(i8* @.str.78, i32 23)
	call void @console.writeln(i8* @.str.21, i32 2)
	ret void
}
define %struct.string.String @string_utils.u64_to_string(i64 %n){
	%v0 = alloca i32
	%v1 = alloca i8
	%v2 = alloca i64
	store i32 20, i32* %v0
	%tmp0 = icmp eq i64 %n, 0
	br i1 %tmp0, label %then0, label %endif0
then0:
	store i8 48, i8* %v1
	%tmp1 = call %struct.string.String @string.from_data(i8* %v1, i32 1)
	br label %func_exit
endif0:
	%tmp2 = alloca i8, i64 21
	store i64 %n, i64* %v2
	br label %loop_start1
loop_start1:
	%tmp3 = load i32, i32* %v0
	%tmp4 = getelementptr inbounds i8, i8* %tmp2, i32 %tmp3
	%tmp5 = load i64, i64* %v2
	%tmp6 = urem i64 %tmp5, 10
	%tmp7 = trunc i64 %tmp6 to i8
	%tmp8 = add i8 %tmp7, 48
	store i8 %tmp8, i8* %tmp4
	%tmp9 = load i64, i64* %v2
	%tmp10 = udiv i64 %tmp9, 10
	store i64 %tmp10, i64* %v2
	%tmp11 = load i32, i32* %v0
	%tmp12 = sub i32 %tmp11, 1
	store i32 %tmp12, i32* %v0
	%tmp13 = load i64, i64* %v2
	%tmp14 = icmp ne i64 %tmp13, 0
	br i1 %tmp14, label %endif2, label %else2
else2:
	br label %loop_body1_exit
endif2:
	br label %loop_start1
loop_body1_exit:
	%tmp15 = load i32, i32* %v0
	%tmp16 = add i32 %tmp15, 1
	%tmp17 = getelementptr inbounds i8, i8* %tmp2, i32 %tmp16
	%tmp18 = load i32, i32* %v0
	%tmp19 = sub i32 20, %tmp18
	%tmp20 = call %struct.string.String @string.from_data(i8* %tmp17, i32 %tmp19)
	br label %func_exit
func_exit:
	%tmp21 = phi %struct.string.String [%tmp1, %then0], [%tmp20, %loop_body1_exit]
	ret %struct.string.String %tmp21
}
define i8* @string_utils.insert(i8* %src1, i8* %src2, i32 %index){
	%tmp0 = call i32 @string_utils.c_str_len(i8* %src1)
	%tmp1 = call i32 @string_utils.c_str_len(i8* %src2)
	%tmp2 = add i32 %tmp0, %tmp1
	%tmp3 = add i32 %tmp2, 1
	%tmp4 = sext i32 %tmp3 to i64
	%tmp5 = call i8* @mem.malloc(i64 %tmp4)
	%tmp6 = sext i32 %index to i64
	call void @mem.copy(i8* %src1, i8* %tmp5, i64 %tmp6)
	%tmp7 = getelementptr inbounds i8, i8* %tmp5, i32 %index
	%tmp8 = sext i32 %tmp1 to i64
	call void @mem.copy(i8* %src2, i8* %tmp7, i64 %tmp8)
	%tmp9 = getelementptr inbounds i8, i8* %src1, i32 %index
	%tmp10 = getelementptr inbounds i8, i8* %tmp5, i32 %index
	%tmp11 = getelementptr inbounds i8, i8* %tmp10, i32 %tmp1
	%tmp12 = sub i32 %tmp0, %index
	%tmp13 = sext i32 %tmp12 to i64
	call void @mem.copy(i8* %tmp9, i8* %tmp11, i64 %tmp13)
	%tmp14 = add i32 %tmp0, %tmp1
	%tmp15 = getelementptr inbounds i8, i8* %tmp5, i32 %tmp14
	store i8 0, i8* %tmp15
	ret i8* %tmp5
}
define i8* @string_utils.c_str_n_copy(i8* %dest, i8* %src, i32 %n){
	%v0 = alloca i32
	store i32 0, i32* %v0
	br label %loop_start0
loop_start0:
	%tmp0 = load i32, i32* %v0
	%tmp1 = icmp slt i32 %tmp0, %n
	br i1 %tmp1, label %endif1, label %else1
else1:
	br label %loop_body0_exit
endif1:
	%tmp2 = load i32, i32* %v0
	%tmp3 = getelementptr inbounds i8, i8* %dest, i32 %tmp2
	%tmp4 = load i32, i32* %v0
	%tmp5 = getelementptr inbounds i8, i8* %src, i32 %tmp4
	%tmp6 = load i8, i8* %tmp5
	store i8 %tmp6, i8* %tmp3
	%tmp7 = load i32, i32* %v0
	%tmp8 = getelementptr inbounds i8, i8* %src, i32 %tmp7
	%tmp9 = load i8, i8* %tmp8
	%tmp10 = icmp eq i8 %tmp9, 0
	br i1 %tmp10, label %then2, label %endif2
then2:
	br label %loop_body0_exit
endif2:
	%tmp11 = load i32, i32* %v0
	%tmp12 = add i32 %tmp11, 1
	store i32 %tmp12, i32* %v0
	br label %loop_start0
loop_body0_exit:
	br label %loop_start3
loop_start3:
	%tmp13 = load i32, i32* %v0
	%tmp14 = icmp slt i32 %tmp13, %n
	br i1 %tmp14, label %endif4, label %else4
else4:
	br label %loop_body3_exit
endif4:
	%tmp15 = load i32, i32* %v0
	%tmp16 = getelementptr inbounds i8, i8* %dest, i32 %tmp15
	store i8 0, i8* %tmp16
	%tmp17 = load i32, i32* %v0
	%tmp18 = add i32 %tmp17, 1
	store i32 %tmp18, i32* %v0
	br label %loop_start3
loop_body3_exit:
	ret i8* %dest
}
define i32 @string_utils.c_str_len(i8* %str){
	%v0 = alloca i32
	store i32 0, i32* %v0
	br label %loop_start0
loop_start0:
	%tmp0 = load i32, i32* %v0
	%tmp1 = getelementptr inbounds i8, i8* %str, i32 %tmp0
	%tmp2 = load i8, i8* %tmp1
	%tmp3 = icmp ne i8 %tmp2, 0
	br i1 %tmp3, label %endif1, label %else1
else1:
	br label %loop_body0_exit
endif1:
	%tmp4 = load i32, i32* %v0
	%tmp5 = add i32 %tmp4, 1
	store i32 %tmp5, i32* %v0
	br label %loop_start0
loop_body0_exit:
	%tmp6 = load i32, i32* %v0
	ret i32 %tmp6
}
define i8* @string_utils.c_str_copy(i8* %dest, i8* %src){
	%v0 = alloca i32
	store i32 0, i32* %v0
	br label %loop_start0
loop_start0:
	%tmp0 = load i32, i32* %v0
	%tmp1 = getelementptr inbounds i8, i8* %src, i32 %tmp0
	%tmp2 = load i8, i8* %tmp1
	%tmp3 = icmp ne i8 %tmp2, 0
	br i1 %tmp3, label %endif1, label %else1
else1:
	br label %loop_body0_exit
endif1:
	%tmp4 = load i32, i32* %v0
	%tmp5 = getelementptr inbounds i8, i8* %dest, i32 %tmp4
	%tmp6 = load i32, i32* %v0
	%tmp7 = getelementptr inbounds i8, i8* %src, i32 %tmp6
	%tmp8 = load i8, i8* %tmp7
	store i8 %tmp8, i8* %tmp5
	%tmp9 = load i32, i32* %v0
	%tmp10 = add i32 %tmp9, 1
	store i32 %tmp10, i32* %v0
	br label %loop_start0
loop_body0_exit:
	ret i8* %dest
}
define %struct.string.String @string.with_size(i32 %size){
	%v0 = alloca %struct.string.String
	store i8* null, i8** %v0
	%tmp0 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	store i32 0, i32* %tmp0
	%tmp1 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 2
	store i32 0, i32* %tmp1
	%tmp2 = icmp sgt i32 %size, 0
	br i1 %tmp2, label %then0, label %endif0
then0:
	%tmp3 = add i32 %size, 1
	%tmp4 = sext i32 %tmp3 to i64
	%tmp5 = call i8* @mem.malloc(i64 %tmp4)
	store i8* %tmp5, i8** %v0
	%tmp6 = load i8*, i8** %v0
	%tmp7 = sext i32 %size to i64
	call void @mem.zero_fill(i8* %tmp6, i64 %tmp7)
	br label %endif0
endif0:
	%tmp8 = load %struct.string.String, %struct.string.String* %v0
; Variable x is out.
	ret %struct.string.String %tmp8
}
define void @string.reserve(%struct.string.String* %str, i32 %required_capacity){
	%v0 = alloca i32
	%v1 = alloca i8*
	%tmp0 = getelementptr inbounds %struct.string.String, %struct.string.String* %str, i32 0, i32 2
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = icmp sge i32 %tmp1, %required_capacity
	br i1 %tmp2, label %then0, label %endif0
then0:
	br label %func_exit
endif0:
	store i32 8, i32* %v0
	%tmp3 = getelementptr inbounds %struct.string.String, %struct.string.String* %str, i32 0, i32 2
	%tmp4 = load i32, i32* %tmp3
	%tmp5 = icmp ne i32 %tmp4, 0
	br i1 %tmp5, label %then1, label %endif1
then1:
	%tmp6 = getelementptr inbounds %struct.string.String, %struct.string.String* %str, i32 0, i32 2
	%tmp7 = load i32, i32* %tmp6
	%tmp8 = mul i32 %tmp7, 2
	store i32 %tmp8, i32* %v0
	br label %endif1
endif1:
	br label %loop_start2
loop_start2:
	%tmp9 = load i32, i32* %v0
	%tmp10 = icmp slt i32 %tmp9, %required_capacity
	br i1 %tmp10, label %endif3, label %else3
else3:
	br label %loop_body2_exit
endif3:
	%tmp11 = load i32, i32* %v0
	%tmp12 = mul i32 %tmp11, 2
	store i32 %tmp12, i32* %v0
	br label %loop_start2
loop_body2_exit:
	%tmp13 = load i32, i32* %v0
	%tmp14 = sext i32 %tmp13 to i64
	%tmp15 = call i8* @mem.malloc(i64 %tmp14)
	store i8* %tmp15, i8** %v1
	%tmp16 = getelementptr inbounds %struct.string.String, %struct.string.String* %str, i32 0, i32 1
	%tmp17 = load i32, i32* %tmp16
	%tmp18 = icmp sgt i32 %tmp17, 0
	br i1 %tmp18, label %then4, label %endif4
then4:
	%tmp19 = load i8*, i8** %str
	%tmp20 = load i8*, i8** %v1
	%tmp21 = getelementptr inbounds %struct.string.String, %struct.string.String* %str, i32 0, i32 1
	%tmp22 = load i32, i32* %tmp21
	%tmp23 = sext i32 %tmp22 to i64
	call void @mem.copy(i8* %tmp19, i8* %tmp20, i64 %tmp23)
	br label %endif4
endif4:
	%tmp24 = load i8*, i8** %str
	%tmp25 = icmp ne i8* %tmp24, null
	br i1 %tmp25, label %then5, label %endif5
then5:
	%tmp26 = load i8*, i8** %str
	call void @mem.free(i8* %tmp26)
	br label %endif5
endif5:
	%tmp27 = load i8*, i8** %v1
	store i8* %tmp27, i8** %str
	%tmp28 = getelementptr inbounds %struct.string.String, %struct.string.String* %str, i32 0, i32 2
	%tmp29 = load i32, i32* %v0
	store i32 %tmp29, i32* %tmp28
	br label %func_exit
func_exit:
	ret void
}
define %struct.string.String @string.from_data(i8* %data, i32 %len){
	%v0 = alloca %struct.string.String
	store i8* null, i8** %v0
	%tmp0 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	store i32 %len, i32* %tmp0
	%tmp1 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 2
	store i32 %len, i32* %tmp1
	%tmp2 = icmp sgt i32 %len, 0
	br i1 %tmp2, label %then0, label %endif0
then0:
	%tmp3 = sext i32 %len to i64
	%tmp4 = call i8* @mem.malloc(i64 %tmp3)
	store i8* %tmp4, i8** %v0
	%tmp5 = load i8*, i8** %v0
	%tmp6 = sext i32 %len to i64
	call void @mem.copy(i8* %data, i8* %tmp5, i64 %tmp6)
	%tmp7 = load i8*, i8** %v0
	%tmp8 = getelementptr inbounds i8, i8* %tmp7, i32 %len
	store i8 0, i8* %tmp8
	br label %endif0
endif0:
	%tmp9 = load %struct.string.String, %struct.string.String* %v0
; Variable x is out.
	ret %struct.string.String %tmp9
}
define %struct.string.String @string.from_c_string(i8* %c_string){
	%tmp0 = call i32 @string_utils.c_str_len(i8* %c_string)
	%tmp1 = call %struct.string.String @string.from_data(i8* %c_string, i32 %tmp0)
	ret %struct.string.String %tmp1
}
define void @string.free(%struct.string.String* %str){
	%tmp0 = load i8*, i8** %str
	%tmp1 = icmp ne i8* %tmp0, null
	br i1 %tmp1, label %then0, label %endif0
then0:
	%tmp2 = load i8*, i8** %str
	call void @mem.free(i8* %tmp2)
	br label %endif0
endif0:
	%tmp3 = getelementptr inbounds %struct.string.String, %struct.string.String* %str, i32 0, i32 1
	store i32 0, i32* %tmp3
	store i8* null, i8** %str
	ret void
}
define i1 @string.equal(%struct.string.String* %first, %struct.string.String* %second){
	%tmp0 = getelementptr inbounds %struct.string.String, %struct.string.String* %first, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = getelementptr inbounds %struct.string.String, %struct.string.String* %second, i32 0, i32 1
	%tmp3 = load i32, i32* %tmp2
	%tmp4 = icmp ne i32 %tmp1, %tmp3
	br i1 %tmp4, label %then0, label %endif0
then0:
	br label %func_exit
endif0:
	%tmp5 = getelementptr inbounds %struct.string.String, %struct.string.String* %first, i32 0, i32 1
	%tmp6 = load i32, i32* %tmp5
	%tmp7 = icmp eq i32 %tmp6, 0
	br i1 %tmp7, label %then1, label %endif1
then1:
	br label %func_exit
endif1:
	%tmp8 = load i8*, i8** %first
	%tmp9 = load i8*, i8** %second
	%tmp10 = getelementptr inbounds %struct.string.String, %struct.string.String* %first, i32 0, i32 1
	%tmp11 = load i32, i32* %tmp10
	%tmp12 = sext i32 %tmp11 to i64
	%tmp13 = call i32 @mem.compare(i8* %tmp8, i8* %tmp9, i64 %tmp12)
	%tmp14 = icmp eq i32 %tmp13, 0
	br label %func_exit
func_exit:
	%tmp15 = phi i1 [false, %then0], [true, %then1], [%tmp14, %endif1]
	ret i1 %tmp15
}
define %struct.string.String @string.empty(){
	%v0 = alloca %struct.string.String
	store i8* null, i8** %v0
	%tmp0 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	store i32 0, i32* %tmp0
	%tmp1 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 2
	store i32 0, i32* %tmp1
	%tmp2 = load %struct.string.String, %struct.string.String* %v0
; Variable x is out.
	ret %struct.string.String %tmp2
}
define %struct.string.String @string.clone(%struct.string.String* %src){
	%tmp0 = load i8*, i8** %src
	%tmp1 = getelementptr inbounds %struct.string.String, %struct.string.String* %src, i32 0, i32 1
	%tmp2 = load i32, i32* %tmp1
	%tmp3 = call %struct.string.String @string.from_data(i8* %tmp0, i32 %tmp2)
	ret %struct.string.String %tmp3
}
define void @string.append_str(%struct.string.String* %src_string, i8* %buffer, i32 %buffer_len){
	%tmp0 = icmp eq i32 %buffer_len, 0
	br i1 %tmp0, label %then0, label %endif0
then0:
	br label %func_exit
endif0:
	%tmp1 = icmp eq i32 %buffer_len, 1
	br i1 %tmp1, label %then1, label %endif1
then1:
	%tmp2 = load i8, i8* %buffer
	call void @string.append(%struct.string.String* %src_string, i8 %tmp2)
	br label %func_exit
endif1:
	%tmp3 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 1
	%tmp4 = load i32, i32* %tmp3
	%tmp5 = add i32 %tmp4, %buffer_len
	call void @string.reserve(%struct.string.String* %src_string, i32 %tmp5)
	%tmp6 = load i8*, i8** %src_string
	%tmp7 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 1
	%tmp8 = load i32, i32* %tmp7
	%tmp9 = sext i32 %tmp8 to i64
	%tmp10 = getelementptr inbounds i8, i8* %tmp6, i64 %tmp9
	%tmp11 = sext i32 %buffer_len to i64
	call void @mem.copy(i8* %buffer, i8* %tmp10, i64 %tmp11)
	%tmp12 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 1
	%tmp13 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 1
	%tmp14 = load i32, i32* %tmp13
	%tmp15 = add i32 %tmp14, %buffer_len
	store i32 %tmp15, i32* %tmp12
	br label %func_exit
func_exit:
	ret void
}
define %struct.string.String @string.append_c_string(%struct.string.String* %src_string, i8* %c_string){
	%tmp0 = call i32 @string_utils.c_str_len(i8* %c_string)
	call void @string.append_str(%struct.string.String* %src_string, i8* %c_string, i32 %tmp0)
	unreachable
}
define void @string.append(%struct.string.String* %src_string, i8 %ch){
	%tmp0 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = add i32 %tmp1, 1
	call void @string.reserve(%struct.string.String* %src_string, i32 %tmp2)
	%tmp3 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 1
	%tmp4 = load i32, i32* %tmp3
	%tmp5 = sext i32 %tmp4 to i64
	%tmp6 = load i8*, i8** %src_string
	%tmp7 = getelementptr inbounds i8, i8* %tmp6, i64 %tmp5
	store i8 %ch, i8* %tmp7
	%tmp8 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 1
	%tmp9 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 1
	%tmp10 = load i32, i32* %tmp9
	%tmp11 = add i32 %tmp10, 1
	store i32 %tmp11, i32* %tmp8
	ret void
}
define i64 @stdlib.str_to_l(i8* %str, i8** %endptr, i32 %base){
	%v0 = alloca i32
	%v1 = alloca i64
	%v2 = alloca i32
	%v3 = alloca i64
	%v4 = alloca i32
	store i32 0, i32* %v0
	br label %loop_start0
loop_start0:
	%tmp0 = load i32, i32* %v0
	%tmp1 = getelementptr inbounds i8, i8* %str, i32 %tmp0
	%tmp2 = load i8, i8* %tmp1
	br label %inl_entry1
inl_entry1:
	%tmp3 = icmp eq i8 %tmp2, 32
	br i1 %tmp3, label %logic_end_2, label %logic_rhs_2
logic_rhs_2:
	%tmp4 = icmp eq i8 %tmp2, 9
	br label %logic_end_2
logic_end_2:
	%tmp5 = phi i1 [%tmp3, %inl_entry1], [%tmp4, %logic_rhs_2]
	br i1 %tmp5, label %logic_end_3, label %logic_rhs_3
logic_rhs_3:
	%tmp6 = icmp eq i8 %tmp2, 10
	br label %logic_end_3
logic_end_3:
	%tmp7 = phi i1 [%tmp5, %logic_end_2], [%tmp6, %logic_rhs_3]
	br i1 %tmp7, label %logic_end_4, label %logic_rhs_4
logic_rhs_4:
	%tmp8 = icmp eq i8 %tmp2, 11
	br label %logic_end_4
logic_end_4:
	%tmp9 = phi i1 [%tmp7, %logic_end_3], [%tmp8, %logic_rhs_4]
	br i1 %tmp9, label %logic_end_5, label %logic_rhs_5
logic_rhs_5:
	%tmp10 = icmp eq i8 %tmp2, 12
	br label %logic_end_5
logic_end_5:
	%tmp11 = phi i1 [%tmp9, %logic_end_4], [%tmp10, %logic_rhs_5]
	br i1 %tmp11, label %logic_end_6, label %logic_rhs_6
logic_rhs_6:
	%tmp12 = icmp eq i8 %tmp2, 13
	br label %logic_end_6
logic_end_6:
	%tmp13 = phi i1 [%tmp11, %logic_end_5], [%tmp12, %logic_rhs_6]
	br i1 %tmp13, label %endif7, label %else7
else7:
	br label %loop_body0_exit
endif7:
	%tmp14 = load i32, i32* %v0
	%tmp15 = add i32 %tmp14, 1
	store i32 %tmp15, i32* %v0
	br label %loop_start0
loop_body0_exit:
	store i64 1, i64* %v1
	%tmp16 = load i32, i32* %v0
	%tmp17 = getelementptr inbounds i8, i8* %str, i32 %tmp16
	%tmp18 = load i8, i8* %tmp17
	%tmp19 = icmp eq i8 %tmp18, 43
	br i1 %tmp19, label %then8, label %else8
then8:
	%tmp20 = load i32, i32* %v0
	%tmp21 = add i32 %tmp20, 1
	store i32 %tmp21, i32* %v0
	br label %endif8
else8:
	%tmp22 = load i32, i32* %v0
	%tmp23 = getelementptr inbounds i8, i8* %str, i32 %tmp22
	%tmp24 = load i8, i8* %tmp23
	%tmp25 = icmp eq i8 %tmp24, 45
	br i1 %tmp25, label %then9, label %endif9
then9:
	store i64 -1, i64* %v1
	%tmp26 = load i32, i32* %v0
	%tmp27 = add i32 %tmp26, 1
	store i32 %tmp27, i32* %v0
	br label %endif9
endif9:
	br label %endif8
endif8:
	store i32 %base, i32* %v2
	%tmp28 = load i32, i32* %v2
	%tmp29 = icmp eq i32 %tmp28, 0
	br i1 %tmp29, label %then10, label %endif10
then10:
	%tmp30 = load i32, i32* %v0
	%tmp31 = getelementptr inbounds i8, i8* %str, i32 %tmp30
	%tmp32 = load i8, i8* %tmp31
	%tmp33 = icmp eq i8 %tmp32, 48
	br i1 %tmp33, label %then11, label %else11
then11:
	%tmp34 = load i32, i32* %v0
	%tmp35 = add i32 %tmp34, 1
	%tmp36 = getelementptr inbounds i8, i8* %str, i32 %tmp35
	%tmp37 = load i8, i8* %tmp36
	br label %inl_entry13
inl_entry13:
	%tmp38 = icmp sge i8 %tmp37, 65
	br i1 %tmp38, label %logic_rhs_14, label %logic_end_14
logic_rhs_14:
	%tmp39 = icmp sle i8 %tmp37, 90
	br label %logic_end_14
logic_end_14:
	%tmp40 = phi i1 [%tmp38, %inl_entry13], [%tmp39, %logic_rhs_14]
	br i1 %tmp40, label %then15, label %endif15
then15:
	%tmp41 = add i8 %tmp37, 32
	br label %inl_exit12
endif15:
	br label %inl_exit12
inl_exit12:
	%tmp42 = phi i8 [%tmp41, %then15], [%tmp37, %endif15]
	%tmp43 = icmp eq i8 %tmp42, 120
	br i1 %tmp43, label %then16, label %else16
then16:
	store i32 16, i32* %v2
	br label %endif16
else16:
	store i32 8, i32* %v2
	br label %endif16
endif16:
	br label %endif11
else11:
	store i32 10, i32* %v2
	br label %endif11
endif11:
	br label %endif10
endif10:
	%tmp44 = load i32, i32* %v2
	%tmp45 = icmp eq i32 %tmp44, 16
	br i1 %tmp45, label %logic_rhs_17, label %logic_end_17
logic_rhs_17:
	%tmp46 = load i32, i32* %v0
	%tmp47 = getelementptr inbounds i8, i8* %str, i32 %tmp46
	%tmp48 = load i8, i8* %tmp47
	%tmp49 = icmp eq i8 %tmp48, 48
	br label %logic_end_17
logic_end_17:
	%tmp50 = phi i1 [%tmp45, %endif10], [%tmp49, %logic_rhs_17]
	br i1 %tmp50, label %logic_rhs_18, label %logic_end_18
logic_rhs_18:
	%tmp51 = load i32, i32* %v0
	%tmp52 = add i32 %tmp51, 1
	%tmp53 = getelementptr inbounds i8, i8* %str, i32 %tmp52
	%tmp54 = load i8, i8* %tmp53
	br label %inl_entry20
inl_entry20:
	%tmp55 = icmp sge i8 %tmp54, 65
	br i1 %tmp55, label %logic_rhs_21, label %logic_end_21
logic_rhs_21:
	%tmp56 = icmp sle i8 %tmp54, 90
	br label %logic_end_21
logic_end_21:
	%tmp57 = phi i1 [%tmp55, %inl_entry20], [%tmp56, %logic_rhs_21]
	br i1 %tmp57, label %then22, label %endif22
then22:
	%tmp58 = add i8 %tmp54, 32
	br label %inl_exit19
endif22:
	br label %inl_exit19
inl_exit19:
	%tmp59 = phi i8 [%tmp58, %then22], [%tmp54, %endif22]
	%tmp60 = icmp eq i8 %tmp59, 120
	br label %logic_end_18
logic_end_18:
	%tmp61 = phi i1 [%tmp50, %logic_end_17], [%tmp60, %inl_exit19]
	br i1 %tmp61, label %then23, label %endif23
then23:
	%tmp62 = load i32, i32* %v0
	%tmp63 = add i32 %tmp62, 2
	store i32 %tmp63, i32* %v0
	br label %endif23
endif23:
	store i64 0, i64* %v3
	br label %loop_start24
loop_start24:
	%tmp64 = load i32, i32* %v0
	%tmp65 = getelementptr inbounds i8, i8* %str, i32 %tmp64
	%tmp66 = load i8, i8* %tmp65
	br label %inl_entry25
inl_entry25:
	%tmp67 = icmp sge i8 %tmp66, 48
	br i1 %tmp67, label %logic_rhs_26, label %logic_end_26
logic_rhs_26:
	%tmp68 = icmp sle i8 %tmp66, 57
	br label %logic_end_26
logic_end_26:
	%tmp69 = phi i1 [%tmp67, %inl_entry25], [%tmp68, %logic_rhs_26]
	br i1 %tmp69, label %then27, label %else27
then27:
	%tmp70 = sub i8 %tmp66, 48
	%tmp71 = sext i8 %tmp70 to i32
	store i32 %tmp71, i32* %v4
	br label %endif27
else27:
	br label %inl_entry28
inl_entry28:
	%tmp72 = icmp sge i8 %tmp66, 97
	br i1 %tmp72, label %logic_rhs_29, label %logic_end_29
logic_rhs_29:
	%tmp73 = icmp sle i8 %tmp66, 122
	br label %logic_end_29
logic_end_29:
	%tmp74 = phi i1 [%tmp72, %inl_entry28], [%tmp73, %logic_rhs_29]
	br i1 %tmp74, label %logic_end_30, label %logic_rhs_30
logic_rhs_30:
	%tmp75 = icmp sge i8 %tmp66, 65
	br i1 %tmp75, label %logic_rhs_31, label %logic_end_31
logic_rhs_31:
	%tmp76 = icmp sle i8 %tmp66, 90
	br label %logic_end_31
logic_end_31:
	%tmp77 = phi i1 [%tmp75, %logic_rhs_30], [%tmp76, %logic_rhs_31]
	br label %logic_end_30
logic_end_30:
	%tmp78 = phi i1 [%tmp74, %logic_end_29], [%tmp77, %logic_end_31]
	br i1 %tmp78, label %then32, label %else32
then32:
	br label %inl_entry34
inl_entry34:
	%tmp79 = icmp sge i8 %tmp66, 65
	br i1 %tmp79, label %logic_rhs_35, label %logic_end_35
logic_rhs_35:
	%tmp80 = icmp sle i8 %tmp66, 90
	br label %logic_end_35
logic_end_35:
	%tmp81 = phi i1 [%tmp79, %inl_entry34], [%tmp80, %logic_rhs_35]
	br i1 %tmp81, label %then36, label %endif36
then36:
	%tmp82 = add i8 %tmp66, 32
	br label %inl_exit33
endif36:
	br label %inl_exit33
inl_exit33:
	%tmp83 = phi i8 [%tmp82, %then36], [%tmp66, %endif36]
	%tmp84 = sub i8 %tmp83, 97
	%tmp85 = add i8 %tmp84, 10
	%tmp86 = sext i8 %tmp85 to i32
	store i32 %tmp86, i32* %v4
	br label %endif32
else32:
	br label %loop_body24_exit
endif32:
	br label %endif27
endif27:
	%tmp87 = load i32, i32* %v4
	%tmp88 = load i32, i32* %v2
	%tmp89 = icmp sge i32 %tmp87, %tmp88
	br i1 %tmp89, label %then37, label %endif37
then37:
	br label %loop_body24_exit
endif37:
	%tmp90 = load i64, i64* %v3
	%tmp91 = load i32, i32* %v2
	%tmp92 = sext i32 %tmp91 to i64
	%tmp93 = mul i64 %tmp90, %tmp92
	%tmp94 = load i32, i32* %v4
	%tmp95 = sext i32 %tmp94 to i64
	%tmp96 = add i64 %tmp93, %tmp95
	store i64 %tmp96, i64* %v3
	%tmp97 = load i32, i32* %v0
	%tmp98 = add i32 %tmp97, 1
	store i32 %tmp98, i32* %v0
	br label %loop_start24
loop_body24_exit:
	%tmp99 = icmp ne i8** %endptr, null
	br i1 %tmp99, label %then38, label %endif38
then38:
	%tmp100 = load i32, i32* %v0
	%tmp101 = sext i32 %tmp100 to i64
	%tmp102 = getelementptr inbounds i8, i8* %str, i64 %tmp101
	store i8* %tmp102, i8** %endptr
	br label %endif38
endif38:
	%tmp103 = load i64, i64* %v3
	%tmp104 = load i64, i64* %v1
	%tmp105 = mul i64 %tmp103, %tmp104
	ret i64 %tmp105
}
define void @stdlib.srand(i32 %seed){
	store i32 %seed, i32* @stdlib.rand_seed
	ret void
}
define i32 @stdlib.rand(){
	%tmp0 = load i32, i32* @stdlib.rand_seed
	%tmp1 = mul i32 %tmp0, 1103515245
	%tmp2 = add i32 %tmp1, 12345
	store i32 %tmp2, i32* @stdlib.rand_seed
	%tmp3 = load i32, i32* @stdlib.rand_seed
	%tmp4 = udiv i32 %tmp3, 65536
	%tmp5 = urem i32 %tmp4, 32768
	ret i32 %tmp5
}
define i32 @stdlib.atoi(i8* %str){
	%v0 = alloca i32
	%v1 = alloca i32
	%v2 = alloca i32
	store i32 0, i32* %v0
	store i32 1, i32* %v1
	store i32 0, i32* %v2
	br label %loop_start0
loop_start0:
	%tmp0 = load i32, i32* %v2
	%tmp1 = getelementptr inbounds i8, i8* %str, i32 %tmp0
	%tmp2 = load i8, i8* %tmp1
	br label %inl_entry1
inl_entry1:
	%tmp3 = icmp eq i8 %tmp2, 32
	br i1 %tmp3, label %logic_end_2, label %logic_rhs_2
logic_rhs_2:
	%tmp4 = icmp eq i8 %tmp2, 9
	br label %logic_end_2
logic_end_2:
	%tmp5 = phi i1 [%tmp3, %inl_entry1], [%tmp4, %logic_rhs_2]
	br i1 %tmp5, label %logic_end_3, label %logic_rhs_3
logic_rhs_3:
	%tmp6 = icmp eq i8 %tmp2, 10
	br label %logic_end_3
logic_end_3:
	%tmp7 = phi i1 [%tmp5, %logic_end_2], [%tmp6, %logic_rhs_3]
	br i1 %tmp7, label %logic_end_4, label %logic_rhs_4
logic_rhs_4:
	%tmp8 = icmp eq i8 %tmp2, 11
	br label %logic_end_4
logic_end_4:
	%tmp9 = phi i1 [%tmp7, %logic_end_3], [%tmp8, %logic_rhs_4]
	br i1 %tmp9, label %logic_end_5, label %logic_rhs_5
logic_rhs_5:
	%tmp10 = icmp eq i8 %tmp2, 12
	br label %logic_end_5
logic_end_5:
	%tmp11 = phi i1 [%tmp9, %logic_end_4], [%tmp10, %logic_rhs_5]
	br i1 %tmp11, label %logic_end_6, label %logic_rhs_6
logic_rhs_6:
	%tmp12 = icmp eq i8 %tmp2, 13
	br label %logic_end_6
logic_end_6:
	%tmp13 = phi i1 [%tmp11, %logic_end_5], [%tmp12, %logic_rhs_6]
	br i1 %tmp13, label %endif7, label %else7
else7:
	br label %loop_body0_exit
endif7:
	%tmp14 = load i32, i32* %v2
	%tmp15 = add i32 %tmp14, 1
	store i32 %tmp15, i32* %v2
	br label %loop_start0
loop_body0_exit:
	%tmp16 = load i32, i32* %v2
	%tmp17 = getelementptr inbounds i8, i8* %str, i32 %tmp16
	%tmp18 = load i8, i8* %tmp17
	%tmp19 = icmp eq i8 %tmp18, 45
	br i1 %tmp19, label %then8, label %else8
then8:
	store i32 -1, i32* %v1
	%tmp20 = load i32, i32* %v2
	%tmp21 = add i32 %tmp20, 1
	store i32 %tmp21, i32* %v2
	br label %endif8
else8:
	%tmp22 = load i32, i32* %v2
	%tmp23 = getelementptr inbounds i8, i8* %str, i32 %tmp22
	%tmp24 = load i8, i8* %tmp23
	%tmp25 = icmp eq i8 %tmp24, 43
	br i1 %tmp25, label %then9, label %endif9
then9:
	%tmp26 = load i32, i32* %v2
	%tmp27 = add i32 %tmp26, 1
	store i32 %tmp27, i32* %v2
	br label %endif9
endif9:
	br label %endif8
endif8:
	br label %loop_start10
loop_start10:
	%tmp28 = load i32, i32* %v2
	%tmp29 = getelementptr inbounds i8, i8* %str, i32 %tmp28
	%tmp30 = load i8, i8* %tmp29
	br label %inl_entry11
inl_entry11:
	%tmp31 = icmp sge i8 %tmp30, 48
	br i1 %tmp31, label %logic_rhs_12, label %logic_end_12
logic_rhs_12:
	%tmp32 = icmp sle i8 %tmp30, 57
	br label %logic_end_12
logic_end_12:
	%tmp33 = phi i1 [%tmp31, %inl_entry11], [%tmp32, %logic_rhs_12]
	br i1 %tmp33, label %endif13, label %else13
else13:
	br label %loop_body10_exit
endif13:
	%tmp34 = load i32, i32* %v0
	%tmp35 = mul i32 %tmp34, 10
	%tmp36 = load i32, i32* %v2
	%tmp37 = getelementptr inbounds i8, i8* %str, i32 %tmp36
	%tmp38 = load i8, i8* %tmp37
	%tmp39 = sub i8 %tmp38, 48
	%tmp40 = sext i8 %tmp39 to i32
	%tmp41 = add i32 %tmp35, %tmp40
	store i32 %tmp41, i32* %v0
	%tmp42 = load i32, i32* %v2
	%tmp43 = add i32 %tmp42, 1
	store i32 %tmp43, i32* %v2
	br label %loop_start10
loop_body10_exit:
	%tmp44 = load i32, i32* %v0
	%tmp45 = load i32, i32* %v1
	%tmp46 = mul i32 %tmp44, %tmp45
	ret i32 %tmp46
}
define void @process.throw(i8* %exception){
	%tmp0 = call i32 @string_utils.c_str_len(i8* %exception)
	call i32 @AllocConsole()
	%tmp1 = call i8* @GetStdHandle(i32 -11)
	call void @console.writeln(i8* @.str.79, i32 11)
	call void @console.writeln(i8* %exception, i32 %tmp0)
	call void @ExitProcess(i32 -1)
	ret void
}
define %struct.string.String @process.get_executable_path(){
	%v0 = alloca %struct.string.String
	%tmp0 = call %struct.string.String @string.with_size(i32 260)
	store %struct.string.String %tmp0, %struct.string.String* %v0
	%tmp1 = load i8*, i8** %v0
	%tmp2 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	%tmp3 = load i32, i32* %tmp2
	%tmp4 = call i32 @GetModuleFileNameA(i8* null, i8* %tmp1, i32 %tmp3)
	%tmp5 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	store i32 %tmp4, i32* %tmp5
	%tmp6 = load %struct.string.String, %struct.string.String* %v0
; Variable string is out.
	ret %struct.string.String %tmp6
}
define %struct.string.String @process.get_executable_env_path(){
	%v0 = alloca %struct.string.String
	%v1 = alloca i32
	%tmp0 = call %struct.string.String @process.get_executable_path()
	store %struct.string.String %tmp0, %struct.string.String* %v0
	%tmp1 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	%tmp2 = load i32, i32* %tmp1
	%tmp3 = sub i32 %tmp2, 1
	store i32 %tmp3, i32* %v1
	br label %loop_start0
loop_start0:
	%tmp4 = load i32, i32* %v1
	%tmp5 = icmp sge i32 %tmp4, 0
	br i1 %tmp5, label %logic_rhs_1, label %logic_end_1
logic_rhs_1:
	%tmp6 = load i32, i32* %v1
	%tmp7 = load i8*, i8** %v0
	%tmp8 = getelementptr inbounds i8, i8* %tmp7, i32 %tmp6
	%tmp9 = load i8, i8* %tmp8
	%tmp10 = icmp ne i8 %tmp9, 92
	br label %logic_end_1
logic_end_1:
	%tmp11 = phi i1 [%tmp5, %loop_start0], [%tmp10, %logic_rhs_1]
	br i1 %tmp11, label %endif2, label %else2
else2:
	br label %loop_body0_exit
endif2:
	%tmp12 = load i32, i32* %v1
	%tmp13 = sub i32 %tmp12, 1
	store i32 %tmp13, i32* %v1
	br label %loop_start0
loop_body0_exit:
	%tmp14 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	%tmp15 = load i32, i32* %v1
	%tmp16 = add i32 %tmp15, 1
	store i32 %tmp16, i32* %tmp14
	%tmp17 = load %struct.string.String, %struct.string.String* %v0
; Variable string is out.
	ret %struct.string.String %tmp17
}
define void @mem.zero_fill(i8* %dest, i64 %len){
	call void @mem.fill(i8 0, i8* %dest, i64 %len)
	ret void
}
define i8* @mem.realloc(i8* %ptr, i64 %size){
	%tmp0 = icmp eq i8* %ptr, null
	br i1 %tmp0, label %then0, label %endif0
then0:
	%tmp1 = call i8* @mem.malloc(i64 %size)
	br label %func_exit
endif0:
	%tmp2 = call i32* @GetProcessHeap()
	%tmp3 = call i8* @HeapReAlloc(i32* %tmp2, i32 0, i8* %ptr, i64 %size)
	%tmp4 = icmp eq i8* %tmp3, null
	br i1 %tmp4, label %then1, label %endif1
then1:
	call void @process.throw(i8* @.str.80)
	br label %endif1
endif1:
	br label %func_exit
func_exit:
	%tmp5 = phi i8* [%tmp1, %then0], [%tmp3, %endif1]
	ret i8* %tmp5
}
define i8* @mem.malloc(i64 %size){
	%tmp0 = call i32* @GetProcessHeap()
	%tmp1 = call i8* @HeapAlloc(i32* %tmp0, i32 0, i64 %size)
	%tmp2 = icmp eq i8* %tmp1, null
	br i1 %tmp2, label %then0, label %endif0
then0:
	call void @process.throw(i8* @.str.81)
	br label %endif0
endif0:
	ret i8* %tmp1
}
define i64 @mem.get_total_allocated_memory_external(){
	%v0 = alloca i64
	%v1 = alloca %struct.mem.PROCESS_HEAP_ENTRY
	%tmp0 = call i32* @GetProcessHeap()
	store i64 0, i64* %v0
	store i8* null, i8** %v1
	%tmp1 = call i32 @HeapLock(i32* %tmp0)
	%tmp2 = icmp eq i32 %tmp1, 0
	br i1 %tmp2, label %then0, label %endif0
then0:
	call void @process.throw(i8* @.str.82)
	br label %endif0
endif0:
	br label %loop_start1
loop_start1:
	%tmp3 = call i32 @HeapWalk(i32* %tmp0, %struct.mem.PROCESS_HEAP_ENTRY* %v1)
	%tmp4 = icmp ne i32 %tmp3, 0
	br i1 %tmp4, label %endif2, label %else2
else2:
	br label %loop_body1_exit
endif2:
	%tmp5 = getelementptr inbounds %struct.mem.PROCESS_HEAP_ENTRY, %struct.mem.PROCESS_HEAP_ENTRY* %v1, i32 0, i32 4
	%tmp6 = load i16, i16* %tmp5
	%tmp7 = and i16 %tmp6, 4
	%tmp8 = icmp ne i16 %tmp7, 0
	br i1 %tmp8, label %then3, label %endif3
then3:
	%tmp9 = load i64, i64* %v0
	%tmp10 = getelementptr inbounds %struct.mem.PROCESS_HEAP_ENTRY, %struct.mem.PROCESS_HEAP_ENTRY* %v1, i32 0, i32 1
	%tmp11 = load i32, i32* %tmp10
	%tmp12 = zext i32 %tmp11 to i64
	%tmp13 = add i64 %tmp9, %tmp12
	store i64 %tmp13, i64* %v0
	br label %endif3
endif3:
	br label %loop_start1
loop_body1_exit:
	call i32 @HeapUnlock(i32* %tmp0)
	%tmp14 = load i64, i64* %v0
; Variable entry is out.
	ret i64 %tmp14
}
define void @mem.free(i8* %ptr){
	%tmp0 = icmp ne i8* %ptr, null
	br i1 %tmp0, label %then0, label %endif0
then0:
	%tmp1 = call i32* @GetProcessHeap()
	call i32 @HeapFree(i32* %tmp1, i32 0, i8* %ptr)
	br label %endif0
endif0:
	ret void
}
define void @mem.fill(i8 %val, i8* %dest, i64 %len){
	call void @"mem.default_fill<i8>"(i8 %val, i8* %dest, i64 %len)
	ret void
}
define void @mem.copy(i8* %src, i8* %dest, i64 %len){
	%v0 = alloca i64
	store i64 0, i64* %v0
	br label %loop_cond0
loop_cond0:
	%tmp0 = load i64, i64* %v0
	%tmp1 = icmp sge i64 %tmp0, %len
	br i1 %tmp1, label %then1, label %endif1
then1:
	br label %loop_body0_exit
endif1:
	%tmp2 = load i64, i64* %v0
	%tmp3 = getelementptr inbounds i8, i8* %dest, i64 %tmp2
	%tmp4 = load i64, i64* %v0
	%tmp5 = getelementptr inbounds i8, i8* %src, i64 %tmp4
	%tmp6 = load i8, i8* %tmp5
	store i8 %tmp6, i8* %tmp3
	%tmp7 = load i64, i64* %v0
	%tmp8 = add i64 %tmp7, 1
	store i64 %tmp8, i64* %v0
	br label %loop_cond0
loop_body0_exit:
	ret void
}
define i32 @mem.compare(i8* %left, i8* %right, i64 %len){
	%v0 = alloca i64
	store i64 0, i64* %v0
	br label %loop_cond0
loop_cond0:
	%tmp0 = load i64, i64* %v0
	%tmp1 = icmp sge i64 %tmp0, %len
	br i1 %tmp1, label %then1, label %endif1
then1:
	br label %loop_body0_exit
endif1:
	%tmp2 = load i64, i64* %v0
	%tmp3 = getelementptr inbounds i8, i8* %left, i64 %tmp2
	%tmp4 = load i8, i8* %tmp3
	%tmp5 = load i64, i64* %v0
	%tmp6 = getelementptr inbounds i8, i8* %right, i64 %tmp5
	%tmp7 = load i8, i8* %tmp6
	%tmp8 = icmp slt i8 %tmp4, %tmp7
	br i1 %tmp8, label %then2, label %endif2
then2:
	br label %func_exit
endif2:
	%tmp9 = load i64, i64* %v0
	%tmp10 = getelementptr inbounds i8, i8* %left, i64 %tmp9
	%tmp11 = load i8, i8* %tmp10
	%tmp12 = load i64, i64* %v0
	%tmp13 = getelementptr inbounds i8, i8* %right, i64 %tmp12
	%tmp14 = load i8, i8* %tmp13
	%tmp15 = icmp sgt i8 %tmp11, %tmp14
	br i1 %tmp15, label %then3, label %endif3
then3:
	br label %func_exit
endif3:
	%tmp16 = load i64, i64* %v0
	%tmp17 = add i64 %tmp16, 1
	store i64 %tmp17, i64* %v0
	br label %loop_cond0
loop_body0_exit:
	br label %func_exit
func_exit:
	%tmp18 = phi i32 [-1, %then2], [1, %then3], [0, %loop_body0_exit]
	ret i32 %tmp18
}
define i32 @fs.write_to_file(i8* %path, i8* %content, i32 %content_len){
	%v0 = alloca i32
	%tmp0 = call i8* @CreateFileA(i8* %path, i32 1073741824, i32 0, i8* null, i32 2, i32 128, i8* null)
	%tmp1 = inttoptr i64 -1 to i8*
	%tmp2 = icmp eq i8* %tmp0, %tmp1
	br i1 %tmp2, label %then0, label %endif0
then0:
	br label %func_exit
endif0:
	store i32 0, i32* %v0
	%tmp3 = call i32 @WriteFile(i8* %tmp0, i8* %content, i32 %content_len, i32* %v0, i8* null)
	call i32 @CloseHandle(i8* %tmp0)
	%tmp4 = icmp ne i32 %tmp3, 0
	br i1 %tmp4, label %logic_rhs_1, label %logic_end_1
logic_rhs_1:
	%tmp5 = load i32, i32* %v0
	%tmp6 = icmp eq i32 %tmp5, %content_len
	br label %logic_end_1
logic_end_1:
	%tmp7 = phi i1 [%tmp4, %endif0], [%tmp6, %logic_rhs_1]
	%tmp8 = zext i1 %tmp7 to i32
	br label %func_exit
func_exit:
	%tmp9 = phi i32 [0, %then0], [%tmp8, %logic_end_1]
	ret i32 %tmp9
}
define %struct.string.String @fs.read_full_file_as_string(i8* %path){
	%v0 = alloca i64
	%v1 = alloca %struct.string.String
	%v2 = alloca i32
	%tmp0 = call i8* @CreateFileA(i8* %path, i32 2147483648, i32 1, i8* null, i32 3, i32 128, i8* null)
	%tmp1 = inttoptr i64 -1 to i8*
	%tmp2 = icmp eq i8* %tmp0, %tmp1
	br i1 %tmp2, label %then0, label %endif0
then0:
	%tmp3 = call i8* @string_utils.insert(i8* @.str.83, i8* %path, i32 16)
	call void @process.throw(i8* %tmp3)
	br label %endif0
endif0:
	store i64 0, i64* %v0
	%tmp4 = call i32 @GetFileSizeEx(i8* %tmp0, i64* %v0)
	%tmp5 = icmp eq i32 %tmp4, 0
	br i1 %tmp5, label %then1, label %endif1
then1:
	call i32 @CloseHandle(i8* %tmp0)
	%tmp6 = call %struct.string.String @string.empty()
	br label %func_exit
endif1:
	%tmp7 = load i64, i64* %v0
	%tmp8 = trunc i64 %tmp7 to i32
	%tmp9 = call %struct.string.String @string.with_size(i32 %tmp8)
	store %struct.string.String %tmp9, %struct.string.String* %v1
	store i32 0, i32* %v2
	%tmp10 = load i8*, i8** %v1
	%tmp11 = load i64, i64* %v0
	%tmp12 = trunc i64 %tmp11 to i32
	%tmp13 = call i32 @ReadFile(i8* %tmp0, i8* %tmp10, i32 %tmp12, i32* %v2, i8* null)
	call i32 @CloseHandle(i8* %tmp0)
	%tmp14 = icmp eq i32 %tmp13, 0
	br i1 %tmp14, label %then2, label %endif2
then2:
	call void @string.free(%struct.string.String* %v1)
	call void @process.throw(i8* @.str.84)
	br label %endif2
endif2:
	%tmp15 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 1
	%tmp16 = load i64, i64* %v0
	%tmp17 = trunc i64 %tmp16 to i32
	store i32 %tmp17, i32* %tmp15
	%tmp18 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 1
	%tmp19 = load i32, i32* %tmp18
	%tmp20 = load i8*, i8** %v1
	%tmp21 = getelementptr inbounds i8, i8* %tmp20, i32 %tmp19
	store i8 0, i8* %tmp21
	%tmp22 = load %struct.string.String, %struct.string.String* %v1
	br label %func_exit
func_exit:
; Variable buffer is out.
	%tmp23 = phi %struct.string.String [%tmp6, %then1], [%tmp22, %endif2]
	ret %struct.string.String %tmp23
}
define i1 @fs.file_exists(i8* %path){
	%tmp0 = call i32 @GetFileAttributesA(i8* %path)
	%tmp1 = icmp ne i32 %tmp0, 4294967295
	ret i1 %tmp1
}
define i32 @fs.delete_file(i8* %path){
	%tmp0 = call i32 @DeleteFileA(i8* %path)
	ret i32 %tmp0
}
define i32 @fs.create_file(i8* %path){
	%tmp0 = call i8* @CreateFileA(i8* %path, i32 1073741824, i32 0, i8* null, i32 1, i32 128, i8* null)
	%tmp1 = inttoptr i64 -1 to i8*
	%tmp2 = icmp eq i8* %tmp0, %tmp1
	br i1 %tmp2, label %then0, label %endif0
then0:
	br label %func_exit
endif0:
	call i32 @CloseHandle(i8* %tmp0)
	br label %func_exit
func_exit:
	%tmp3 = phi i32 [0, %then0], [1, %endif0]
	ret i32 %tmp3
}
define void @console.writeln(i8* %buffer, i32 %len){
	%v0 = alloca i32
	%v1 = alloca i8
	call void @console.write(i8* %buffer, i32 %len)
	store i8 10, i8* %v1
	%tmp0 = call i8* @console.get_stdout()
	call i32 @WriteConsoleA(i8* %tmp0, i8* %v1, i32 1, i32* %v0, i8* null)
	ret void
}
define void @console.write_string(%struct.string.String* %str){
	%v0 = alloca i32
	%tmp0 = getelementptr inbounds %struct.string.String, %struct.string.String* %str, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = icmp eq i32 %tmp1, 0
	br i1 %tmp2, label %then0, label %endif0
then0:
	br label %func_exit
endif0:
	%tmp3 = call i8* @console.get_stdout()
	%tmp4 = load i8*, i8** %str
	%tmp5 = getelementptr inbounds %struct.string.String, %struct.string.String* %str, i32 0, i32 1
	%tmp6 = load i32, i32* %tmp5
	call i32 @WriteConsoleA(i8* %tmp3, i8* %tmp4, i32 %tmp6, i32* %v0, i8* null)
	%tmp7 = getelementptr inbounds %struct.string.String, %struct.string.String* %str, i32 0, i32 1
	%tmp8 = load i32, i32* %tmp7
	%tmp9 = load i32, i32* %v0
	%tmp10 = icmp ne i32 %tmp8, %tmp9
	br i1 %tmp10, label %then1, label %endif1
then1:
	call void @ExitProcess(i32 -2)
	br label %endif1
endif1:
	br label %func_exit
func_exit:
	ret void
}
define void @console.write(i8* %buffer, i32 %len){
	%v0 = alloca i32
	%tmp0 = icmp eq i32 %len, 0
	br i1 %tmp0, label %then0, label %endif0
then0:
	br label %func_exit
endif0:
	%tmp1 = call i8* @console.get_stdout()
	call i32 @WriteConsoleA(i8* %tmp1, i8* %buffer, i32 %len, i32* %v0, i8* null)
	%tmp2 = load i32, i32* %v0
	%tmp3 = icmp ne i32 %len, %tmp2
	br i1 %tmp3, label %then1, label %endif1
then1:
	call void @ExitProcess(i32 -2)
	br label %endif1
endif1:
	br label %func_exit
func_exit:
	ret void
}
define void @console.println_u64(i64 %n){
	%v0 = alloca i32
	%v1 = alloca i64
	%tmp0 = alloca i8, i64 22
	store i32 20, i32* %v0
	%tmp1 = icmp eq i64 %n, 0
	br i1 %tmp1, label %then0, label %endif0
then0:
	call void @console.write(i8* @.str.85, i32 2)
	br label %func_exit
endif0:
	store i64 %n, i64* %v1
	br label %loop_start1
loop_start1:
	%tmp2 = load i32, i32* %v0
	%tmp3 = getelementptr inbounds i8, i8* %tmp0, i32 %tmp2
	%tmp4 = load i64, i64* %v1
	%tmp5 = urem i64 %tmp4, 10
	%tmp6 = trunc i64 %tmp5 to i8
	%tmp7 = add i8 %tmp6, 48
	store i8 %tmp7, i8* %tmp3
	%tmp8 = load i64, i64* %v1
	%tmp9 = udiv i64 %tmp8, 10
	store i64 %tmp9, i64* %v1
	%tmp10 = load i32, i32* %v0
	%tmp11 = sub i32 %tmp10, 1
	store i32 %tmp11, i32* %v0
	%tmp12 = load i64, i64* %v1
	%tmp13 = icmp ne i64 %tmp12, 0
	br i1 %tmp13, label %endif2, label %else2
else2:
	br label %loop_body1_exit
endif2:
	br label %loop_start1
loop_body1_exit:
	%tmp14 = getelementptr inbounds i8, i8* %tmp0, i64 21
	store i8 10, i8* %tmp14
	%tmp15 = load i32, i32* %v0
	%tmp16 = add i32 %tmp15, 1
	%tmp17 = getelementptr inbounds i8, i8* %tmp0, i32 %tmp16
	%tmp18 = load i32, i32* %v0
	%tmp19 = sub i32 21, %tmp18
	call void @console.write(i8* %tmp17, i32 %tmp19)
	br label %func_exit
func_exit:
	ret void
}
define void @console.println_i64(i64 %n){
	%tmp0 = icmp sge i64 %n, 0
	br i1 %tmp0, label %then0, label %else0
then0:
	call void @console.println_u64(i64 %n)
	br label %endif0
else0:
	call void @console.print_char(i8 45)
	%tmp1 = sub i64 0, %n
	call void @console.println_u64(i64 %tmp1)
	br label %endif0
endif0:
	ret void
}
define void @console.println_f64(double %n){
	%v0 = alloca double
	%v1 = alloca double
	%v2 = alloca i32
	%v3 = alloca double
	%v4 = alloca i8*
	%v5 = alloca i32
	%v6 = alloca i64
	%v7 = alloca i8*
	%v8 = alloca i32
	%v9 = alloca i32
	%v10 = alloca i64
	store double %n, double* %v0
	%tmp0 = fcmp olt double %n, 0x0000000000000000
	br i1 %tmp0, label %then0, label %endif0
then0:
	call void @console.print_char(i8 45)
	%tmp1 = load double, double* %v0
	%tmp2 = fsub double 0x0000000000000000, %tmp1
	store double %tmp2, double* %v0
	br label %endif0
endif0:
	store double 0x3FE0000000000000, double* %v1
	store i32 0, i32* %v2
	br label %loop_cond1
loop_cond1:
	%tmp3 = load i32, i32* %v2
	%tmp4 = icmp sge i32 %tmp3, 6
	br i1 %tmp4, label %then2, label %endif2
then2:
	br label %loop_body1_exit
endif2:
	%tmp5 = load double, double* %v1
	%tmp6 = fdiv double %tmp5, 0x4024000000000000
	store double %tmp6, double* %v1
	%tmp7 = load i32, i32* %v2
	%tmp8 = add i32 %tmp7, 1
	store i32 %tmp8, i32* %v2
	br label %loop_cond1
loop_body1_exit:
	%tmp9 = load double, double* %v0
	%tmp10 = load double, double* %v1
	%tmp11 = fadd double %tmp9, %tmp10
	store double %tmp11, double* %v0
	%tmp12 = load double, double* %v0
	%tmp13 = fptoui double %tmp12 to i64
	%tmp14 = load double, double* %v0
	%tmp15 = uitofp i64 %tmp13 to double
	%tmp16 = fsub double %tmp14, %tmp15
	store double %tmp16, double* %v3
	%tmp17 = icmp eq i64 %tmp13, 0
	br i1 %tmp17, label %then3, label %else3
then3:
	call void @console.print_char(i8 48)
	br label %endif3
else3:
	%tmp18 = alloca i8, i64 21
	store i8* %tmp18, i8** %v4
	store i32 20, i32* %v5
	store i64 %tmp13, i64* %v6
	br label %loop_start4
loop_start4:
	%tmp19 = load i32, i32* %v5
	%tmp20 = load i8*, i8** %v4
	%tmp21 = getelementptr inbounds i8, i8* %tmp20, i32 %tmp19
	%tmp22 = load i64, i64* %v6
	%tmp23 = urem i64 %tmp22, 10
	%tmp24 = trunc i64 %tmp23 to i8
	%tmp25 = add i8 %tmp24, 48
	store i8 %tmp25, i8* %tmp21
	%tmp26 = load i64, i64* %v6
	%tmp27 = udiv i64 %tmp26, 10
	store i64 %tmp27, i64* %v6
	%tmp28 = load i32, i32* %v5
	%tmp29 = sub i32 %tmp28, 1
	store i32 %tmp29, i32* %v5
	%tmp30 = load i64, i64* %v6
	%tmp31 = icmp ne i64 %tmp30, 0
	br i1 %tmp31, label %endif5, label %else5
else5:
	br label %loop_body4_exit
endif5:
	br label %loop_start4
loop_body4_exit:
	%tmp32 = load i32, i32* %v5
	%tmp33 = add i32 %tmp32, 1
	%tmp34 = load i8*, i8** %v4
	%tmp35 = getelementptr inbounds i8, i8* %tmp34, i32 %tmp33
	store i8* %tmp35, i8** %v7
	%tmp36 = load i32, i32* %v5
	%tmp37 = sub i32 20, %tmp36
	store i32 %tmp37, i32* %v8
	%tmp38 = load i8*, i8** %v7
	%tmp39 = load i32, i32* %v8
	call void @console.write(i8* %tmp38, i32 %tmp39)
	br label %endif3
endif3:
	call void @console.print_char(i8 46)
	store i32 0, i32* %v9
	br label %loop_cond6
loop_cond6:
	%tmp40 = load i32, i32* %v9
	%tmp41 = icmp sge i32 %tmp40, 6
	br i1 %tmp41, label %then7, label %endif7
then7:
	br label %loop_body6_exit
endif7:
	%tmp42 = load double, double* %v3
	%tmp43 = fmul double %tmp42, 0x4024000000000000
	store double %tmp43, double* %v3
	%tmp44 = load double, double* %v3
	%tmp45 = fptoui double %tmp44 to i64
	store i64 %tmp45, i64* %v10
	%tmp46 = load i64, i64* %v10
	%tmp47 = trunc i64 %tmp46 to i8
	%tmp48 = add i8 %tmp47, 48
	call void @console.print_char(i8 %tmp48)
	%tmp49 = load double, double* %v3
	%tmp50 = load i64, i64* %v10
	%tmp51 = uitofp i64 %tmp50 to double
	%tmp52 = fsub double %tmp49, %tmp51
	store double %tmp52, double* %v3
	%tmp53 = load i32, i32* %v9
	%tmp54 = add i32 %tmp53, 1
	store i32 %tmp54, i32* %v9
	br label %loop_cond6
loop_body6_exit:
	call void @console.print_char(i8 10)
	ret void
}
define void @console.print_char(i8 %n){
	%v0 = alloca i8
	store i8 %n, i8* %v0
	call void @console.write(i8* %v0, i32 1)
	ret void
}
define i8* @console.get_stdout(){
	%v0 = alloca i8*
	%tmp0 = call i8* @GetStdHandle(i32 -11)
	store i8* %tmp0, i8** %v0
	%tmp1 = load i8*, i8** %v0
	%tmp2 = inttoptr i64 -1 to i8*
	%tmp3 = icmp eq i8* %tmp1, %tmp2
	br i1 %tmp3, label %then0, label %endif0
then0:
	call void @process.throw(i8* @.str.86)
	br label %endif0
endif0:
	%tmp4 = load i8*, i8** %v0
	ret i8* %tmp4
}
define void @compile_internals.sym_table_push_structs_generic(%struct.SymbolTable* %symbol_table, %struct.string.String* %stdout){
	%v0 = alloca i32
	%v1 = alloca i32
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.SymbolTableEntry>", %"struct.vector.Vec<%struct.SymbolTableEntry>"* %symbol_table, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = load %struct.SymbolTableEntry*, %struct.SymbolTableEntry** %symbol_table
	%tmp3 = getelementptr inbounds %struct.SymbolTable, %struct.SymbolTable* %symbol_table, i32 0, i32 1
	%tmp4 = getelementptr inbounds %struct.SymbolTable, %struct.SymbolTable* %symbol_table, i32 0, i32 1
	%tmp5 = load %"struct.vector.Vec<%struct.string.String>"*, %"struct.vector.Vec<%struct.string.String>"** %tmp4
	%tmp6 = load %struct.string.String*, %struct.string.String** %tmp5
	store i32 0, i32* %v0
	br label %loop_cond0
loop_cond0:
	%tmp7 = load i32, i32* %v0
	%tmp8 = icmp uge i32 %tmp7, %tmp1
	br i1 %tmp8, label %then1, label %endif1
then1:
	br label %loop_body0_exit
endif1:
	%tmp9 = load i32, i32* %v0
	%tmp10 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp2, i32 %tmp9
	%tmp11 = load i32, i32* %tmp10
	%tmp12 = and i32 %tmp11, 7
	%tmp13 = icmp eq i32 %tmp12, 3
	br i1 %tmp13, label %then2, label %endif2
then2:
	%tmp14 = load i32, i32* %v0
	%tmp15 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp2, i32 %tmp14
	%tmp16 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp15, i32 0, i32 2
	%tmp17 = load i8*, i8** %tmp16
	call void @string.append(%struct.string.String* %stdout, i8 37)
	%tmp18 = getelementptr inbounds %struct.GenericStructSymbolTableEntry, %struct.GenericStructSymbolTableEntry* %tmp17, i32 0, i32 3
	%tmp19 = load i8*, i8** %tmp18
	%tmp20 = getelementptr inbounds %struct.GenericStructSymbolTableEntry, %struct.GenericStructSymbolTableEntry* %tmp17, i32 0, i32 3
	%tmp21 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp20, i32 0, i32 1
	%tmp22 = load i32, i32* %tmp21
	call void @string.append_str(%struct.string.String* %stdout, i8* %tmp19, i32 %tmp22)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.87, i32 8)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.88, i32 2)
	%tmp23 = getelementptr inbounds %"struct.vector.Vec<%struct.GenericStructDefinedField>", %"struct.vector.Vec<%struct.GenericStructDefinedField>"* %tmp17, i32 0, i32 1
	%tmp24 = load i32, i32* %tmp23
	store i32 0, i32* %v1
	br label %loop_cond3
loop_cond3:
	%tmp25 = load i32, i32* %v1
	%tmp26 = getelementptr inbounds %"struct.vector.Vec<%struct.GenericStructDefinedField>", %"struct.vector.Vec<%struct.GenericStructDefinedField>"* %tmp17, i32 0, i32 1
	%tmp27 = load i32, i32* %tmp26
	%tmp28 = icmp uge i32 %tmp25, %tmp27
	br i1 %tmp28, label %then4, label %endif4
then4:
	br label %loop_body3_exit
endif4:
	%tmp29 = load i32, i32* %v1
	%tmp30 = load %struct.GenericStructDefinedField*, %struct.GenericStructDefinedField** %tmp17
	%tmp31 = getelementptr inbounds %struct.GenericStructDefinedField, %struct.GenericStructDefinedField* %tmp30, i32 %tmp29
	%tmp32 = getelementptr inbounds %struct.GenericStructDefinedField, %struct.GenericStructDefinedField* %tmp31, i32 0, i32 1
	%tmp33 = load i32, i32* %v0
	%tmp34 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp2, i32 %tmp33
	%tmp35 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp34, i32 0, i32 1
	call void @compiler_type_push(%struct.CompilerType* %tmp32, %struct.PathEx* %tmp35, %struct.SymbolTable* %symbol_table, %struct.string.String* %stdout)
	%tmp36 = load i32, i32* %v1
	%tmp37 = getelementptr inbounds %"struct.vector.Vec<%struct.GenericStructDefinedField>", %"struct.vector.Vec<%struct.GenericStructDefinedField>"* %tmp17, i32 0, i32 1
	%tmp38 = load i32, i32* %tmp37
	%tmp39 = sub i32 %tmp38, 1
	%tmp40 = icmp ne i32 %tmp36, %tmp39
	br i1 %tmp40, label %then5, label %endif5
then5:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.89, i32 2)
	br label %endif5
endif5:
	%tmp41 = load i32, i32* %v1
	%tmp42 = add i32 %tmp41, 1
	store i32 %tmp42, i32* %v1
	br label %loop_cond3
loop_body3_exit:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.90, i32 3)
	br label %endif2
endif2:
	%tmp43 = load i32, i32* %v0
	%tmp44 = add i32 %tmp43, 1
	store i32 %tmp44, i32* %v0
	br label %loop_cond0
loop_body0_exit:
	ret void
}
define void @compile_internals.sym_table_push_structs(%struct.SymbolTable* %symbol_table, %struct.string.String* %stdout){
	%v0 = alloca i32
	%v1 = alloca i32
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.SymbolTableEntry>", %"struct.vector.Vec<%struct.SymbolTableEntry>"* %symbol_table, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = load %struct.SymbolTableEntry*, %struct.SymbolTableEntry** %symbol_table
	%tmp3 = getelementptr inbounds %struct.SymbolTable, %struct.SymbolTable* %symbol_table, i32 0, i32 1
	%tmp4 = getelementptr inbounds %struct.SymbolTable, %struct.SymbolTable* %symbol_table, i32 0, i32 1
	%tmp5 = load %"struct.vector.Vec<%struct.string.String>"*, %"struct.vector.Vec<%struct.string.String>"** %tmp4
	%tmp6 = load %struct.string.String*, %struct.string.String** %tmp5
	store i32 0, i32* %v0
	br label %loop_cond0
loop_cond0:
	%tmp7 = load i32, i32* %v0
	%tmp8 = icmp uge i32 %tmp7, %tmp1
	br i1 %tmp8, label %then1, label %endif1
then1:
	br label %loop_body0_exit
endif1:
	%tmp9 = load i32, i32* %v0
	%tmp10 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp2, i32 %tmp9
	%tmp11 = load i32, i32* %tmp10
	%tmp12 = and i32 %tmp11, 7
	%tmp13 = icmp eq i32 %tmp12, 2
	br i1 %tmp13, label %then2, label %endif2
then2:
	%tmp14 = load i32, i32* %v0
	%tmp15 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp2, i32 %tmp14
	%tmp16 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp15, i32 0, i32 2
	%tmp17 = load i8*, i8** %tmp16
	call void @string.append(%struct.string.String* %stdout, i8 37)
	%tmp18 = getelementptr inbounds %struct.StructSymbolTableEntry, %struct.StructSymbolTableEntry* %tmp17, i32 0, i32 2
	%tmp19 = load i8*, i8** %tmp18
	%tmp20 = getelementptr inbounds %struct.StructSymbolTableEntry, %struct.StructSymbolTableEntry* %tmp17, i32 0, i32 2
	%tmp21 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp20, i32 0, i32 1
	%tmp22 = load i32, i32* %tmp21
	call void @string.append_str(%struct.string.String* %stdout, i8* %tmp19, i32 %tmp22)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.87, i32 8)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.88, i32 2)
	%tmp23 = getelementptr inbounds %"struct.vector.Vec<%struct.StructDefinedField>", %"struct.vector.Vec<%struct.StructDefinedField>"* %tmp17, i32 0, i32 1
	%tmp24 = load i32, i32* %tmp23
	store i32 0, i32* %v1
	br label %loop_cond3
loop_cond3:
	%tmp25 = load i32, i32* %v1
	%tmp26 = getelementptr inbounds %"struct.vector.Vec<%struct.StructDefinedField>", %"struct.vector.Vec<%struct.StructDefinedField>"* %tmp17, i32 0, i32 1
	%tmp27 = load i32, i32* %tmp26
	%tmp28 = icmp uge i32 %tmp25, %tmp27
	br i1 %tmp28, label %then4, label %endif4
then4:
	br label %loop_body3_exit
endif4:
	%tmp29 = load i32, i32* %v1
	%tmp30 = load %struct.StructDefinedField*, %struct.StructDefinedField** %tmp17
	%tmp31 = getelementptr inbounds %struct.StructDefinedField, %struct.StructDefinedField* %tmp30, i32 %tmp29
	%tmp32 = getelementptr inbounds %struct.StructDefinedField, %struct.StructDefinedField* %tmp31, i32 0, i32 1
	%tmp33 = load i32, i32* %v0
	%tmp34 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp2, i32 %tmp33
	%tmp35 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp34, i32 0, i32 1
	call void @compiler_type_push(%struct.CompilerType* %tmp32, %struct.PathEx* %tmp35, %struct.SymbolTable* %symbol_table, %struct.string.String* %stdout)
	%tmp36 = load i32, i32* %v1
	%tmp37 = getelementptr inbounds %"struct.vector.Vec<%struct.StructDefinedField>", %"struct.vector.Vec<%struct.StructDefinedField>"* %tmp17, i32 0, i32 1
	%tmp38 = load i32, i32* %tmp37
	%tmp39 = sub i32 %tmp38, 1
	%tmp40 = icmp ne i32 %tmp36, %tmp39
	br i1 %tmp40, label %then5, label %endif5
then5:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.89, i32 2)
	br label %endif5
endif5:
	%tmp41 = load i32, i32* %v1
	%tmp42 = add i32 %tmp41, 1
	store i32 %tmp42, i32* %v1
	br label %loop_cond3
loop_body3_exit:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.90, i32 3)
	br label %endif2
endif2:
	%tmp43 = load i32, i32* %v0
	%tmp44 = add i32 %tmp43, 1
	store i32 %tmp44, i32* %v0
	br label %loop_cond0
loop_body0_exit:
	ret void
}
define void @compile_internals.sym_table_push_static(%struct.SymbolTable* %symbol_table, %struct.string.String* %stdout){
	%v0 = alloca i32
	%v1 = alloca %struct.PathEx
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.SymbolTableEntry>", %"struct.vector.Vec<%struct.SymbolTableEntry>"* %symbol_table, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = load %struct.SymbolTableEntry*, %struct.SymbolTableEntry** %symbol_table
	%tmp3 = getelementptr inbounds %struct.SymbolTable, %struct.SymbolTable* %symbol_table, i32 0, i32 1
	%tmp4 = getelementptr inbounds %struct.SymbolTable, %struct.SymbolTable* %symbol_table, i32 0, i32 1
	%tmp5 = load %"struct.vector.Vec<%struct.string.String>"*, %"struct.vector.Vec<%struct.string.String>"** %tmp4
	%tmp6 = load %struct.string.String*, %struct.string.String** %tmp5
	store i32 0, i32* %v0
	br label %loop_cond0
loop_cond0:
	%tmp7 = load i32, i32* %v0
	%tmp8 = icmp uge i32 %tmp7, %tmp1
	br i1 %tmp8, label %then1, label %endif1
then1:
	br label %loop_body0_exit
endif1:
	%tmp9 = load i32, i32* %v0
	%tmp10 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp2, i32 %tmp9
	%tmp11 = load i32, i32* %tmp10
	%tmp12 = and i32 %tmp11, 7
	%tmp13 = icmp eq i32 %tmp12, 5
	br i1 %tmp13, label %then2, label %endif2
then2:
	%tmp14 = load i32, i32* %v0
	%tmp15 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp2, i32 %tmp14
	%tmp16 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp15, i32 0, i32 2
	%tmp17 = load i8*, i8** %tmp16
	%tmp18 = load i32, i32* %v0
	%tmp19 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp2, i32 %tmp18
	%tmp20 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp19, i32 0, i32 1
	%tmp21 = load %struct.PathEx, %struct.PathEx* %tmp20
	store %struct.PathEx %tmp21, %struct.PathEx* %v1
	%tmp22 = load i8, i8* %v1
	%tmp23 = sub i8 %tmp22, 1
	store i8 %tmp23, i8* %v1
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.91, i32 1)
	%tmp24 = load i32, i32* %v0
	%tmp25 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp2, i32 %tmp24
	%tmp26 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp25, i32 0, i32 1
	call void @append_path_ex(%struct.PathEx* %tmp26, %struct.string.String* %tmp6, %struct.string.String* %stdout)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.92, i32 19)
	call void @compiler_type_push(%struct.CompilerType* %tmp17, %struct.PathEx* %v1, %struct.SymbolTable* %symbol_table, %struct.string.String* %stdout)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.93, i32 17)
; Variable loc is out.
	br label %endif2
endif2:
	%tmp27 = load i32, i32* %v0
	%tmp28 = add i32 %tmp27, 1
	store i32 %tmp28, i32* %v0
	br label %loop_cond0
loop_body0_exit:
	ret void
}
define void @compile_internals.sym_table_push_external(%struct.SymbolTable* %symbol_table, %struct.string.String* %stdout){
	%v0 = alloca i32
	%v1 = alloca %struct.PathEx
	%v2 = alloca %struct.PathEx
	%v3 = alloca i32
	%v4 = alloca %struct.string.String
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.SymbolTableEntry>", %"struct.vector.Vec<%struct.SymbolTableEntry>"* %symbol_table, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = load %struct.SymbolTableEntry*, %struct.SymbolTableEntry** %symbol_table
	%tmp3 = getelementptr inbounds %struct.SymbolTable, %struct.SymbolTable* %symbol_table, i32 0, i32 1
	%tmp4 = getelementptr inbounds %struct.SymbolTable, %struct.SymbolTable* %symbol_table, i32 0, i32 1
	%tmp5 = load %"struct.vector.Vec<%struct.string.String>"*, %"struct.vector.Vec<%struct.string.String>"** %tmp4
	%tmp6 = load %struct.string.String*, %struct.string.String** %tmp5
	store i32 0, i32* %v0
	br label %loop_cond0
loop_cond0:
	%tmp7 = load i32, i32* %v0
	%tmp8 = icmp uge i32 %tmp7, %tmp1
	br i1 %tmp8, label %then1, label %endif1
then1:
	br label %loop_body0_exit
endif1:
	%tmp9 = load i32, i32* %v0
	%tmp10 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp2, i32 %tmp9
	%tmp11 = load i32, i32* %tmp10
	%tmp12 = and i32 %tmp11, 7
	%tmp13 = icmp eq i32 %tmp12, 0
	br i1 %tmp13, label %then2, label %endif2
then2:
	%tmp14 = load i32, i32* %v0
	%tmp15 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp2, i32 %tmp14
	%tmp16 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp15, i32 0, i32 2
	%tmp17 = load i8*, i8** %tmp16
	%tmp18 = load i32, i32* %v0
	%tmp19 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp2, i32 %tmp18
	%tmp20 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp19, i32 0, i32 1
	%tmp21 = load %struct.PathEx, %struct.PathEx* %tmp20
	store %struct.PathEx %tmp21, %struct.PathEx* %v1
	%tmp22 = load i8, i8* %v1
	%tmp23 = sub i8 %tmp22, 1
	store i8 %tmp23, i8* %v1
	%tmp24 = getelementptr inbounds %struct.FunctionSymbolTableEntry, %struct.FunctionSymbolTableEntry* %tmp17, i32 0, i32 3
	%tmp25 = load i8, i8* %tmp24
	%tmp26 = and i8 %tmp25, 4
	%tmp27 = icmp eq i8 %tmp26, 0
	br i1 %tmp27, label %then3, label %endif3
then3:
	br label %loop_body0
endif3:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.94, i32 18)
	%tmp28 = getelementptr inbounds %struct.FunctionSymbolTableEntry, %struct.FunctionSymbolTableEntry* %tmp17, i32 0, i32 1
	call void @compiler_type_push(%struct.CompilerType* %tmp28, %struct.PathEx* %v1, %struct.SymbolTable* %symbol_table, %struct.string.String* %stdout)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.95, i32 2)
	%tmp29 = load i32, i32* %v0
	%tmp30 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp2, i32 %tmp29
	%tmp31 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp30, i32 0, i32 1
	%tmp32 = load %struct.PathEx, %struct.PathEx* %tmp31
	store %struct.PathEx %tmp32, %struct.PathEx* %v2
	%tmp33 = getelementptr inbounds %struct.PathEx, %struct.PathEx* %v2, i32 0, i32 1
	%tmp34 = getelementptr inbounds %struct.PathEx, %struct.PathEx* %v2, i32 0, i32 1
	%tmp35 = load i8, i8* %v2
	%tmp36 = sub i8 %tmp35, 1
	%tmp37 = getelementptr inbounds [12 x i16], [12 x i16]* %tmp34, i32 0, i8 %tmp36
	%tmp38 = load i16, i16* %tmp37
	store i16 %tmp38, i16* %tmp33
	store i8 1, i8* %v2
	call void @append_path_ex(%struct.PathEx* %v2, %struct.string.String* %tmp6, %struct.string.String* %stdout)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.96, i32 1)
	%tmp39 = getelementptr inbounds %"struct.vector.Vec<%struct.StructDefinedField>", %"struct.vector.Vec<%struct.StructDefinedField>"* %tmp17, i32 0, i32 1
	%tmp40 = load i32, i32* %tmp39
	store i32 0, i32* %v3
	br label %loop_cond4
loop_cond4:
	%tmp41 = load i32, i32* %v3
	%tmp42 = getelementptr inbounds %"struct.vector.Vec<%struct.StructDefinedField>", %"struct.vector.Vec<%struct.StructDefinedField>"* %tmp17, i32 0, i32 1
	%tmp43 = load i32, i32* %tmp42
	%tmp44 = icmp uge i32 %tmp41, %tmp43
	br i1 %tmp44, label %then5, label %endif5
then5:
	br label %loop_body4_exit
endif5:
	%tmp45 = load i32, i32* %v3
	%tmp46 = load %struct.StructDefinedField*, %struct.StructDefinedField** %tmp17
	%tmp47 = getelementptr inbounds %struct.StructDefinedField, %struct.StructDefinedField* %tmp46, i32 %tmp45
	%tmp48 = getelementptr inbounds %struct.StructDefinedField, %struct.StructDefinedField* %tmp47, i32 0, i32 1
	call void @compiler_type_push(%struct.CompilerType* %tmp48, %struct.PathEx* %v1, %struct.SymbolTable* %symbol_table, %struct.string.String* %stdout)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.97, i32 3)
	%tmp49 = load i32, i32* %v3
	%tmp50 = zext i32 %tmp49 to i64
	%tmp51 = call %struct.string.String @string_utils.u64_to_string(i64 %tmp50)
	store %struct.string.String %tmp51, %struct.string.String* %v4
	%tmp52 = load i8*, i8** %v4
	%tmp53 = getelementptr inbounds %struct.string.String, %struct.string.String* %v4, i32 0, i32 1
	%tmp54 = load i32, i32* %tmp53
	call void @string.append_str(%struct.string.String* %stdout, i8* %tmp52, i32 %tmp54)
	call void @string.free(%struct.string.String* %v4)
	%tmp55 = load i32, i32* %v3
	%tmp56 = getelementptr inbounds %"struct.vector.Vec<%struct.StructDefinedField>", %"struct.vector.Vec<%struct.StructDefinedField>"* %tmp17, i32 0, i32 1
	%tmp57 = load i32, i32* %tmp56
	%tmp58 = sub i32 %tmp57, 1
	%tmp59 = icmp ne i32 %tmp55, %tmp58
	br i1 %tmp59, label %then6, label %endif6
then6:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.89, i32 2)
	br label %endif6
endif6:
	%tmp60 = load i32, i32* %v3
	%tmp61 = add i32 %tmp60, 1
	store i32 %tmp61, i32* %v3
	br label %loop_cond4
loop_body4_exit:
; Variable n is out.
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.98, i32 1)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.99, i32 1)
; Variable q is out.
; Variable loc is out.
	br label %endif2
endif2:
	br label %loop_body0
loop_body0:
	%tmp62 = load i32, i32* %v0
	%tmp63 = add i32 %tmp62, 1
	store i32 %tmp63, i32* %v0
	br label %loop_cond0
loop_body0_exit:
	ret void
}
define %struct.Type @wrap_in_pointers(%struct.Type %base, i32 %depth){
	%v0 = alloca %struct.PointerType*
	%v1 = alloca %struct.Type
	%tmp0 = icmp eq i32 %depth, 0
	br i1 %tmp0, label %then0, label %endif0
then0:
	br label %func_exit
endif0:
	%tmp1 = icmp ugt i32 %depth, 255
	br i1 %tmp1, label %then1, label %endif1
then1:
	call void @process.throw(i8* @.str.100)
	br label %endif1
endif1:
	%tmp2 = call i8* @mem.malloc(i64 24)
	store %struct.PointerType* %tmp2, %struct.PointerType** %v0
	%tmp3 = load %struct.PointerType*, %struct.PointerType** %v0
	%tmp4 = trunc i32 %depth to i8
	store i8 %tmp4, i8* %tmp3
	%tmp5 = load %struct.PointerType*, %struct.PointerType** %v0
	%tmp6 = getelementptr inbounds %struct.PointerType, %struct.PointerType* %tmp5, i32 0, i32 1
	store %struct.Type %base, %struct.Type* %tmp6
	store i32 1, i32* %v1
	%tmp7 = getelementptr inbounds %struct.Type, %struct.Type* %v1, i32 0, i32 1
	%tmp8 = load %struct.PointerType*, %struct.PointerType** %v0
	store i8* %tmp8, i8** %tmp7
	%tmp9 = load %struct.Type, %struct.Type* %v1
	br label %func_exit
func_exit:
; Variable wrapper is out.
; Variable base is out.
	%tmp10 = phi %struct.Type [%base, %then0], [%tmp9, %endif1]
	ret %struct.Type %tmp10
}
define %struct.string.String @token_type_to_string(%struct.TokenData* %val, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector){
	%tmp0 = icmp ne %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, null
	br i1 %tmp0, label %then0, label %else0
then0:
	%tmp1 = load i8, i8* %val
	%tmp2 = icmp eq i8 %tmp1, 65
	br i1 %tmp2, label %then1, label %else1
then1:
	%tmp3 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %val, i32 0, i32 1
	%tmp4 = load i16, i16* %tmp3
	%tmp5 = load %struct.string.String*, %struct.string.String** %symbol_vector
	%tmp6 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp5, i16 %tmp4
	%tmp7 = call %struct.string.String @string.clone(%struct.string.String* %tmp6)
	br label %func_exit
else1:
	%tmp8 = load i8, i8* %val
	%tmp9 = icmp eq i8 %tmp8, 68
	br i1 %tmp9, label %then2, label %else2
then2:
	%tmp10 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %val, i32 0, i32 1
	%tmp11 = load i16, i16* %tmp10
	%tmp12 = load %struct.string.String*, %struct.string.String** %symbol_vector
	%tmp13 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp12, i16 %tmp11
	%tmp14 = call %struct.string.String @string.clone(%struct.string.String* %tmp13)
	br label %func_exit
else2:
	%tmp15 = load i8, i8* %val
	%tmp16 = icmp eq i8 %tmp15, 66
	br i1 %tmp16, label %then3, label %else3
then3:
	%tmp17 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %val, i32 0, i32 1
	%tmp18 = load i16, i16* %tmp17
	%tmp19 = load %struct.string.String*, %struct.string.String** %symbol_vector
	%tmp20 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp19, i16 %tmp18
	%tmp21 = call %struct.string.String @string.clone(%struct.string.String* %tmp20)
	br label %func_exit
else3:
	%tmp22 = load i8, i8* %val
	%tmp23 = icmp eq i8 %tmp22, 67
	br i1 %tmp23, label %then4, label %else4
then4:
	%tmp24 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %val, i32 0, i32 1
	%tmp25 = load i16, i16* %tmp24
	%tmp26 = load %struct.string.String*, %struct.string.String** %symbol_vector
	%tmp27 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp26, i16 %tmp25
	%tmp28 = call %struct.string.String @string.clone(%struct.string.String* %tmp27)
	br label %func_exit
else4:
	%tmp29 = load i8, i8* %val
	%tmp30 = icmp eq i8 %tmp29, 69
	br i1 %tmp30, label %then5, label %endif5
then5:
	%tmp31 = call %struct.string.String @string.from_c_string(i8* @.str.101)
	br label %func_exit
endif5:
	br label %endif0
else0:
	%tmp32 = load i8, i8* %val
	%tmp33 = icmp eq i8 %tmp32, 65
	br i1 %tmp33, label %then6, label %else6
then6:
	%tmp34 = call %struct.string.String @string.from_c_string(i8* @.str.102)
	br label %func_exit
else6:
	%tmp35 = load i8, i8* %val
	%tmp36 = icmp eq i8 %tmp35, 68
	br i1 %tmp36, label %then7, label %else7
then7:
	%tmp37 = call %struct.string.String @string.from_c_string(i8* @.str.103)
	br label %func_exit
else7:
	%tmp38 = load i8, i8* %val
	%tmp39 = icmp eq i8 %tmp38, 66
	br i1 %tmp39, label %then8, label %else8
then8:
	%tmp40 = call %struct.string.String @string.from_c_string(i8* @.str.104)
	br label %func_exit
else8:
	%tmp41 = load i8, i8* %val
	%tmp42 = icmp eq i8 %tmp41, 67
	br i1 %tmp42, label %then9, label %else9
then9:
	%tmp43 = call %struct.string.String @string.from_c_string(i8* @.str.105)
	br label %func_exit
else9:
	%tmp44 = load i8, i8* %val
	%tmp45 = icmp eq i8 %tmp44, 69
	br i1 %tmp45, label %then10, label %endif10
then10:
	%tmp46 = call %struct.string.String @string.from_c_string(i8* @.str.101)
	br label %func_exit
endif10:
	br label %endif0
endif0:
	%tmp47 = load i8, i8* %val
	%tmp48 = icmp eq i8 %tmp47, 0
	br i1 %tmp48, label %then11, label %else11
then11:
	%tmp49 = call %struct.string.String @string.from_c_string(i8* @.str.96)
	br label %func_exit
else11:
	%tmp50 = load i8, i8* %val
	%tmp51 = icmp eq i8 %tmp50, 1
	br i1 %tmp51, label %then12, label %else12
then12:
	%tmp52 = call %struct.string.String @string.from_c_string(i8* @.str.98)
	br label %func_exit
else12:
	%tmp53 = load i8, i8* %val
	%tmp54 = icmp eq i8 %tmp53, 2
	br i1 %tmp54, label %then13, label %else13
then13:
	%tmp55 = call %struct.string.String @string.from_c_string(i8* @.str.106)
	br label %func_exit
else13:
	%tmp56 = load i8, i8* %val
	%tmp57 = icmp eq i8 %tmp56, 3
	br i1 %tmp57, label %then14, label %else14
then14:
	%tmp58 = call %struct.string.String @string.from_c_string(i8* @.str.107)
	br label %func_exit
else14:
	%tmp59 = load i8, i8* %val
	%tmp60 = icmp eq i8 %tmp59, 4
	br i1 %tmp60, label %then15, label %else15
then15:
	%tmp61 = call %struct.string.String @string.from_c_string(i8* @.str.108)
	br label %func_exit
else15:
	%tmp62 = load i8, i8* %val
	%tmp63 = icmp eq i8 %tmp62, 5
	br i1 %tmp63, label %then16, label %else16
then16:
	%tmp64 = call %struct.string.String @string.from_c_string(i8* @.str.109)
	br label %func_exit
else16:
	%tmp65 = load i8, i8* %val
	%tmp66 = icmp eq i8 %tmp65, 6
	br i1 %tmp66, label %then17, label %else17
then17:
	%tmp67 = call %struct.string.String @string.from_c_string(i8* @.str.110)
	br label %func_exit
else17:
	%tmp68 = load i8, i8* %val
	%tmp69 = icmp eq i8 %tmp68, 7
	br i1 %tmp69, label %then18, label %else18
then18:
	%tmp70 = call %struct.string.String @string.from_c_string(i8* @.str.111)
	br label %func_exit
else18:
	%tmp71 = load i8, i8* %val
	%tmp72 = icmp eq i8 %tmp71, 8
	br i1 %tmp72, label %then19, label %else19
then19:
	%tmp73 = call %struct.string.String @string.from_c_string(i8* @.str.112)
	br label %func_exit
else19:
	%tmp74 = load i8, i8* %val
	%tmp75 = icmp eq i8 %tmp74, 9
	br i1 %tmp75, label %then20, label %else20
then20:
	%tmp76 = call %struct.string.String @string.from_c_string(i8* @.str.113)
	br label %func_exit
else20:
	%tmp77 = load i8, i8* %val
	%tmp78 = icmp eq i8 %tmp77, 10
	br i1 %tmp78, label %then21, label %else21
then21:
	%tmp79 = call %struct.string.String @string.from_c_string(i8* @.str.114)
	br label %func_exit
else21:
	%tmp80 = load i8, i8* %val
	%tmp81 = icmp eq i8 %tmp80, 11
	br i1 %tmp81, label %then22, label %else22
then22:
	%tmp82 = call %struct.string.String @string.from_c_string(i8* @.str.115)
	br label %func_exit
else22:
	%tmp83 = load i8, i8* %val
	%tmp84 = icmp eq i8 %tmp83, 12
	br i1 %tmp84, label %then23, label %else23
then23:
	%tmp85 = call %struct.string.String @string.from_c_string(i8* @.str.116)
	br label %func_exit
else23:
	%tmp86 = load i8, i8* %val
	%tmp87 = icmp eq i8 %tmp86, 13
	br i1 %tmp87, label %then24, label %else24
then24:
	%tmp88 = call %struct.string.String @string.from_c_string(i8* @.str.117)
	br label %func_exit
else24:
	%tmp89 = load i8, i8* %val
	%tmp90 = icmp eq i8 %tmp89, 14
	br i1 %tmp90, label %then25, label %else25
then25:
	%tmp91 = call %struct.string.String @string.from_c_string(i8* @.str.118)
	br label %func_exit
else25:
	%tmp92 = load i8, i8* %val
	%tmp93 = icmp eq i8 %tmp92, 15
	br i1 %tmp93, label %then26, label %else26
then26:
	%tmp94 = call %struct.string.String @string.from_c_string(i8* @.str.119)
	br label %func_exit
else26:
	%tmp95 = load i8, i8* %val
	%tmp96 = icmp eq i8 %tmp95, 16
	br i1 %tmp96, label %then27, label %else27
then27:
	%tmp97 = call %struct.string.String @string.from_c_string(i8* @.str.120)
	br label %func_exit
else27:
	%tmp98 = load i8, i8* %val
	%tmp99 = icmp eq i8 %tmp98, 17
	br i1 %tmp99, label %then28, label %else28
then28:
	%tmp100 = call %struct.string.String @string.from_c_string(i8* @.str.121)
	br label %func_exit
else28:
	%tmp101 = load i8, i8* %val
	%tmp102 = icmp eq i8 %tmp101, 18
	br i1 %tmp102, label %then29, label %else29
then29:
	%tmp103 = call %struct.string.String @string.from_c_string(i8* @.str.122)
	br label %func_exit
else29:
	%tmp104 = load i8, i8* %val
	%tmp105 = icmp eq i8 %tmp104, 19
	br i1 %tmp105, label %then30, label %else30
then30:
	%tmp106 = call %struct.string.String @string.from_c_string(i8* @.str.123)
	br label %func_exit
else30:
	%tmp107 = load i8, i8* %val
	%tmp108 = icmp eq i8 %tmp107, 20
	br i1 %tmp108, label %then31, label %else31
then31:
	%tmp109 = call %struct.string.String @string.from_c_string(i8* @.str.124)
	br label %func_exit
else31:
	%tmp110 = load i8, i8* %val
	%tmp111 = icmp eq i8 %tmp110, 21
	br i1 %tmp111, label %then32, label %else32
then32:
	%tmp112 = call %struct.string.String @string.from_c_string(i8* @.str.125)
	br label %func_exit
else32:
	%tmp113 = load i8, i8* %val
	%tmp114 = icmp eq i8 %tmp113, 22
	br i1 %tmp114, label %then33, label %else33
then33:
	%tmp115 = call %struct.string.String @string.from_c_string(i8* @.str.126)
	br label %func_exit
else33:
	%tmp116 = load i8, i8* %val
	%tmp117 = icmp eq i8 %tmp116, 23
	br i1 %tmp117, label %then34, label %else34
then34:
	%tmp118 = call %struct.string.String @string.from_c_string(i8* @.str.127)
	br label %func_exit
else34:
	%tmp119 = load i8, i8* %val
	%tmp120 = icmp eq i8 %tmp119, 24
	br i1 %tmp120, label %then35, label %else35
then35:
	%tmp121 = call %struct.string.String @string.from_c_string(i8* @.str.128)
	br label %func_exit
else35:
	%tmp122 = load i8, i8* %val
	%tmp123 = icmp eq i8 %tmp122, 25
	br i1 %tmp123, label %then36, label %else36
then36:
	%tmp124 = call %struct.string.String @string.from_c_string(i8* @.str.129)
	br label %func_exit
else36:
	%tmp125 = load i8, i8* %val
	%tmp126 = icmp eq i8 %tmp125, 26
	br i1 %tmp126, label %then37, label %else37
then37:
	%tmp127 = call %struct.string.String @string.from_c_string(i8* @.str.130)
	br label %func_exit
else37:
	%tmp128 = load i8, i8* %val
	%tmp129 = icmp eq i8 %tmp128, 27
	br i1 %tmp129, label %then38, label %else38
then38:
	%tmp130 = call %struct.string.String @string.from_c_string(i8* @.str.131)
	br label %func_exit
else38:
	%tmp131 = load i8, i8* %val
	%tmp132 = icmp eq i8 %tmp131, 28
	br i1 %tmp132, label %then39, label %else39
then39:
	%tmp133 = call %struct.string.String @string.from_c_string(i8* @.str.132)
	br label %func_exit
else39:
	%tmp134 = load i8, i8* %val
	%tmp135 = icmp eq i8 %tmp134, 29
	br i1 %tmp135, label %then40, label %else40
then40:
	%tmp136 = call %struct.string.String @string.from_c_string(i8* @.str.133)
	br label %func_exit
else40:
	%tmp137 = load i8, i8* %val
	%tmp138 = icmp eq i8 %tmp137, 30
	br i1 %tmp138, label %then41, label %else41
then41:
	%tmp139 = call %struct.string.String @string.from_c_string(i8* @.str.134)
	br label %func_exit
else41:
	%tmp140 = load i8, i8* %val
	%tmp141 = icmp eq i8 %tmp140, 31
	br i1 %tmp141, label %then42, label %else42
then42:
	%tmp142 = call %struct.string.String @string.from_c_string(i8* @.str.135)
	br label %func_exit
else42:
	%tmp143 = load i8, i8* %val
	%tmp144 = icmp eq i8 %tmp143, 32
	br i1 %tmp144, label %then43, label %else43
then43:
	%tmp145 = call %struct.string.String @string.from_c_string(i8* @.str.136)
	br label %func_exit
else43:
	%tmp146 = load i8, i8* %val
	%tmp147 = icmp eq i8 %tmp146, 33
	br i1 %tmp147, label %then44, label %else44
then44:
	%tmp148 = call %struct.string.String @string.from_c_string(i8* @.str.137)
	br label %func_exit
else44:
	%tmp149 = load i8, i8* %val
	%tmp150 = icmp eq i8 %tmp149, 36
	br i1 %tmp150, label %then45, label %else45
then45:
	%tmp151 = call %struct.string.String @string.from_c_string(i8* @.str.138)
	br label %func_exit
else45:
	%tmp152 = load i8, i8* %val
	%tmp153 = icmp eq i8 %tmp152, 37
	br i1 %tmp153, label %then46, label %else46
then46:
	%tmp154 = call %struct.string.String @string.from_c_string(i8* @.str.139)
	br label %func_exit
else46:
	%tmp155 = load i8, i8* %val
	%tmp156 = icmp eq i8 %tmp155, 38
	br i1 %tmp156, label %then47, label %else47
then47:
	%tmp157 = call %struct.string.String @string.from_c_string(i8* @.str.140)
	br label %func_exit
else47:
	%tmp158 = load i8, i8* %val
	%tmp159 = icmp eq i8 %tmp158, 39
	br i1 %tmp159, label %then48, label %else48
then48:
	%tmp160 = call %struct.string.String @string.from_c_string(i8* @.str.141)
	br label %func_exit
else48:
	%tmp161 = load i8, i8* %val
	%tmp162 = icmp eq i8 %tmp161, 40
	br i1 %tmp162, label %then49, label %else49
then49:
	%tmp163 = call %struct.string.String @string.from_c_string(i8* @.str.142)
	br label %func_exit
else49:
	%tmp164 = load i8, i8* %val
	%tmp165 = icmp eq i8 %tmp164, 41
	br i1 %tmp165, label %then50, label %else50
then50:
	%tmp166 = call %struct.string.String @string.from_c_string(i8* @.str.143)
	br label %func_exit
else50:
	%tmp167 = load i8, i8* %val
	%tmp168 = icmp eq i8 %tmp167, 42
	br i1 %tmp168, label %then51, label %else51
then51:
	%tmp169 = call %struct.string.String @string.from_c_string(i8* @.str.144)
	br label %func_exit
else51:
	%tmp170 = load i8, i8* %val
	%tmp171 = icmp eq i8 %tmp170, 43
	br i1 %tmp171, label %then52, label %else52
then52:
	%tmp172 = call %struct.string.String @string.from_c_string(i8* @.str.145)
	br label %func_exit
else52:
	%tmp173 = load i8, i8* %val
	%tmp174 = icmp eq i8 %tmp173, 44
	br i1 %tmp174, label %then53, label %else53
then53:
	%tmp175 = call %struct.string.String @string.from_c_string(i8* @.str.146)
	br label %func_exit
else53:
	%tmp176 = load i8, i8* %val
	%tmp177 = icmp eq i8 %tmp176, 45
	br i1 %tmp177, label %then54, label %else54
then54:
	%tmp178 = call %struct.string.String @string.from_c_string(i8* @.str.147)
	br label %func_exit
else54:
	%tmp179 = load i8, i8* %val
	%tmp180 = icmp eq i8 %tmp179, 46
	br i1 %tmp180, label %then55, label %else55
then55:
	%tmp181 = call %struct.string.String @string.from_c_string(i8* @.str.148)
	br label %func_exit
else55:
	%tmp182 = load i8, i8* %val
	%tmp183 = icmp eq i8 %tmp182, 47
	br i1 %tmp183, label %then56, label %else56
then56:
	%tmp184 = call %struct.string.String @string.from_c_string(i8* @.str.149)
	br label %func_exit
else56:
	%tmp185 = load i8, i8* %val
	%tmp186 = icmp eq i8 %tmp185, 48
	br i1 %tmp186, label %then57, label %else57
then57:
	%tmp187 = call %struct.string.String @string.from_c_string(i8* @.str.150)
	br label %func_exit
else57:
	%tmp188 = load i8, i8* %val
	%tmp189 = icmp eq i8 %tmp188, 49
	br i1 %tmp189, label %then58, label %else58
then58:
	%tmp190 = call %struct.string.String @string.from_c_string(i8* @.str.151)
	br label %func_exit
else58:
	%tmp191 = load i8, i8* %val
	%tmp192 = icmp eq i8 %tmp191, 50
	br i1 %tmp192, label %then59, label %else59
then59:
	%tmp193 = call %struct.string.String @string.from_c_string(i8* @.str.152)
	br label %func_exit
else59:
	%tmp194 = load i8, i8* %val
	%tmp195 = icmp eq i8 %tmp194, 51
	br i1 %tmp195, label %then60, label %else60
then60:
	%tmp196 = call %struct.string.String @string.from_c_string(i8* @.str.153)
	br label %func_exit
else60:
	%tmp197 = load i8, i8* %val
	%tmp198 = icmp eq i8 %tmp197, 52
	br i1 %tmp198, label %then61, label %else61
then61:
	%tmp199 = call %struct.string.String @string.from_c_string(i8* @.str.154)
	br label %func_exit
else61:
	%tmp200 = load i8, i8* %val
	%tmp201 = icmp eq i8 %tmp200, 53
	br i1 %tmp201, label %then62, label %else62
then62:
	%tmp202 = call %struct.string.String @string.from_c_string(i8* @.str.155)
	br label %func_exit
else62:
	%tmp203 = load i8, i8* %val
	%tmp204 = icmp eq i8 %tmp203, 54
	br i1 %tmp204, label %then63, label %else63
then63:
	%tmp205 = call %struct.string.String @string.from_c_string(i8* @.str.156)
	br label %func_exit
else63:
	%tmp206 = load i8, i8* %val
	%tmp207 = icmp eq i8 %tmp206, 55
	br i1 %tmp207, label %then64, label %else64
then64:
	%tmp208 = call %struct.string.String @string.from_c_string(i8* @.str.157)
	br label %func_exit
else64:
	%tmp209 = load i8, i8* %val
	%tmp210 = icmp eq i8 %tmp209, 56
	br i1 %tmp210, label %then65, label %else65
then65:
	%tmp211 = call %struct.string.String @string.from_c_string(i8* @.str.158)
	br label %func_exit
else65:
	%tmp212 = load i8, i8* %val
	%tmp213 = icmp eq i8 %tmp212, 57
	br i1 %tmp213, label %then66, label %else66
then66:
	%tmp214 = call %struct.string.String @string.from_c_string(i8* @.str.159)
	br label %func_exit
else66:
	%tmp215 = load i8, i8* %val
	%tmp216 = icmp eq i8 %tmp215, 58
	br i1 %tmp216, label %then67, label %else67
then67:
	%tmp217 = call %struct.string.String @string.from_c_string(i8* @.str.160)
	br label %func_exit
else67:
	%tmp218 = load i8, i8* %val
	%tmp219 = icmp eq i8 %tmp218, 59
	br i1 %tmp219, label %then68, label %else68
then68:
	%tmp220 = call %struct.string.String @string.from_c_string(i8* @.str.161)
	br label %func_exit
else68:
	%tmp221 = load i8, i8* %val
	%tmp222 = icmp eq i8 %tmp221, 60
	br i1 %tmp222, label %then69, label %else69
then69:
	%tmp223 = call %struct.string.String @string.from_c_string(i8* @.str.162)
	br label %func_exit
else69:
	%tmp224 = load i8, i8* %val
	%tmp225 = icmp eq i8 %tmp224, 61
	br i1 %tmp225, label %then70, label %else70
then70:
	%tmp226 = call %struct.string.String @string.from_c_string(i8* @.str.163)
	br label %func_exit
else70:
	%tmp227 = load i8, i8* %val
	%tmp228 = icmp eq i8 %tmp227, 62
	br i1 %tmp228, label %then71, label %else71
then71:
	%tmp229 = call %struct.string.String @string.from_c_string(i8* @.str.164)
	br label %func_exit
else71:
	%tmp230 = load i8, i8* %val
	%tmp231 = icmp eq i8 %tmp230, 63
	br i1 %tmp231, label %then72, label %else72
then72:
	%tmp232 = call %struct.string.String @string.from_c_string(i8* @.str.165)
	br label %func_exit
else72:
	%tmp233 = load i8, i8* %val
	%tmp234 = icmp eq i8 %tmp233, 64
	br i1 %tmp234, label %then73, label %endif73
then73:
	%tmp235 = call %struct.string.String @string.from_c_string(i8* @.str.166)
	br label %func_exit
endif73:
	br label %endif11
endif11:
	%tmp236 = call %struct.string.String @string.from_c_string(i8* @.str.167)
	br label %func_exit
func_exit:
	%tmp237 = phi %struct.string.String [%tmp7, %then1], [%tmp14, %then2], [%tmp21, %then3], [%tmp28, %then4], [%tmp31, %then5], [%tmp34, %then6], [%tmp37, %then7], [%tmp40, %then8], [%tmp43, %then9], [%tmp46, %then10], [%tmp49, %then11], [%tmp52, %then12], [%tmp55, %then13], [%tmp58, %then14], [%tmp61, %then15], [%tmp64, %then16], [%tmp67, %then17], [%tmp70, %then18], [%tmp73, %then19], [%tmp76, %then20], [%tmp79, %then21], [%tmp82, %then22], [%tmp85, %then23], [%tmp88, %then24], [%tmp91, %then25], [%tmp94, %then26], [%tmp97, %then27], [%tmp100, %then28], [%tmp103, %then29], [%tmp106, %then30], [%tmp109, %then31], [%tmp112, %then32], [%tmp115, %then33], [%tmp118, %then34], [%tmp121, %then35], [%tmp124, %then36], [%tmp127, %then37], [%tmp130, %then38], [%tmp133, %then39], [%tmp136, %then40], [%tmp139, %then41], [%tmp142, %then42], [%tmp145, %then43], [%tmp148, %then44], [%tmp151, %then45], [%tmp154, %then46], [%tmp157, %then47], [%tmp160, %then48], [%tmp163, %then49], [%tmp166, %then50], [%tmp169, %then51], [%tmp172, %then52], [%tmp175, %then53], [%tmp178, %then54], [%tmp181, %then55], [%tmp184, %then56], [%tmp187, %then57], [%tmp190, %then58], [%tmp193, %then59], [%tmp196, %then60], [%tmp199, %then61], [%tmp202, %then62], [%tmp205, %then63], [%tmp208, %then64], [%tmp211, %then65], [%tmp214, %then66], [%tmp217, %then67], [%tmp220, %then68], [%tmp223, %then69], [%tmp226, %then70], [%tmp229, %then71], [%tmp232, %then72], [%tmp235, %then73], [%tmp236, %endif11]
	ret %struct.string.String %tmp237
}
define void @skip_nested(%struct.TokenData* %tokens, i32* %index, i32 %len, i8 %open, i8 %close){
	%v0 = alloca i32
	%tmp0 = load i32, i32* %index
	%tmp1 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp0
	%tmp2 = load i8, i8* %tmp1
	%tmp3 = icmp ne i8 %tmp2, %open
	br i1 %tmp3, label %then0, label %endif0
then0:
	br label %func_exit
endif0:
	%tmp4 = load i32, i32* %index
	%tmp5 = add i32 %tmp4, 1
	store i32 %tmp5, i32* %index
	store i32 1, i32* %v0
	br label %loop_start1
loop_start1:
	%tmp6 = load i32, i32* %index
	%tmp7 = icmp ult i32 %tmp6, %len
	br i1 %tmp7, label %logic_rhs_2, label %logic_end_2
logic_rhs_2:
	%tmp8 = load i32, i32* %v0
	%tmp9 = icmp sgt i32 %tmp8, 0
	br label %logic_end_2
logic_end_2:
	%tmp10 = phi i1 [%tmp7, %loop_start1], [%tmp9, %logic_rhs_2]
	br i1 %tmp10, label %endif3, label %else3
else3:
	br label %loop_body1_exit
endif3:
	%tmp11 = load i32, i32* %index
	%tmp12 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp11
	%tmp13 = load i8, i8* %tmp12
	%tmp14 = icmp eq i8 %tmp13, %open
	br i1 %tmp14, label %then4, label %else4
then4:
	%tmp15 = load i32, i32* %v0
	%tmp16 = add i32 %tmp15, 1
	store i32 %tmp16, i32* %v0
	br label %endif4
else4:
	%tmp17 = load i32, i32* %index
	%tmp18 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp17
	%tmp19 = load i8, i8* %tmp18
	%tmp20 = icmp eq i8 %tmp19, %close
	br i1 %tmp20, label %then5, label %endif5
then5:
	%tmp21 = load i32, i32* %v0
	%tmp22 = sub i32 %tmp21, 1
	store i32 %tmp22, i32* %v0
	br label %endif5
endif5:
	br label %endif4
endif4:
	%tmp23 = load i32, i32* %index
	%tmp24 = add i32 %tmp23, 1
	store i32 %tmp24, i32* %index
	br label %loop_start1
loop_body1_exit:
	br label %func_exit
func_exit:
	ret void
}
define void @skip_if_statement(%struct.TokenData* %tokens, i32* %index, i32 %len){
	%tmp0 = load i32, i32* %index
	%tmp1 = add i32 %tmp0, 1
	store i32 %tmp1, i32* %index
	br label %loop_start0
loop_start0:
	%tmp2 = load i32, i32* %index
	%tmp3 = icmp ult i32 %tmp2, %len
	br i1 %tmp3, label %logic_rhs_1, label %logic_end_1
logic_rhs_1:
	%tmp4 = load i32, i32* %index
	%tmp5 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp4
	%tmp6 = load i8, i8* %tmp5
	%tmp7 = icmp ne i8 %tmp6, 2
	br label %logic_end_1
logic_end_1:
	%tmp8 = phi i1 [%tmp3, %loop_start0], [%tmp7, %logic_rhs_1]
	br i1 %tmp8, label %endif2, label %else2
else2:
	br label %loop_body0_exit
endif2:
	%tmp9 = load i32, i32* %index
	%tmp10 = add i32 %tmp9, 1
	store i32 %tmp10, i32* %index
	br label %loop_start0
loop_body0_exit:
	call void @skip_nested(%struct.TokenData* %tokens, i32* %index, i32 %len, i8 2, i8 3)
	%tmp11 = load i32, i32* %index
	%tmp12 = icmp ult i32 %tmp11, %len
	br i1 %tmp12, label %logic_rhs_3, label %logic_end_3
logic_rhs_3:
	%tmp13 = load i32, i32* %index
	%tmp14 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp13
	%tmp15 = load i8, i8* %tmp14
	%tmp16 = icmp eq i8 %tmp15, 46
	br label %logic_end_3
logic_end_3:
	%tmp17 = phi i1 [%tmp12, %loop_body0_exit], [%tmp16, %logic_rhs_3]
	br i1 %tmp17, label %then4, label %endif4
then4:
	%tmp18 = load i32, i32* %index
	%tmp19 = add i32 %tmp18, 1
	store i32 %tmp19, i32* %index
	%tmp20 = load i32, i32* %index
	%tmp21 = icmp ult i32 %tmp20, %len
	br i1 %tmp21, label %logic_rhs_5, label %logic_end_5
logic_rhs_5:
	%tmp22 = load i32, i32* %index
	%tmp23 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp22
	%tmp24 = load i8, i8* %tmp23
	%tmp25 = icmp eq i8 %tmp24, 45
	br label %logic_end_5
logic_end_5:
	%tmp26 = phi i1 [%tmp21, %then4], [%tmp25, %logic_rhs_5]
	br i1 %tmp26, label %then6, label %else6
then6:
	call void @skip_if_statement(%struct.TokenData* %tokens, i32* %index, i32 %len)
	br label %endif6
else6:
	%tmp27 = load i32, i32* %index
	%tmp28 = icmp ult i32 %tmp27, %len
	br i1 %tmp28, label %logic_rhs_7, label %logic_end_7
logic_rhs_7:
	%tmp29 = load i32, i32* %index
	%tmp30 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp29
	%tmp31 = load i8, i8* %tmp30
	%tmp32 = icmp eq i8 %tmp31, 2
	br label %logic_end_7
logic_end_7:
	%tmp33 = phi i1 [%tmp28, %else6], [%tmp32, %logic_rhs_7]
	br i1 %tmp33, label %then8, label %endif8
then8:
	call void @skip_nested(%struct.TokenData* %tokens, i32* %index, i32 %len, i8 2, i8 3)
	br label %endif8
endif8:
	br label %endif6
endif6:
	br label %endif4
endif4:
	ret void
}
define void @rcsharp_compile(i8* %input_file_path, i8* %output_file_path){
	%v0 = alloca i8*
	%v1 = alloca i32
	%v2 = alloca i8*
	%v3 = alloca %struct.string.String
	%v4 = alloca %"struct.vector.Vec<%struct.string.String>"
	%v5 = alloca %"struct.vector.Vec<%struct.Stmt>"
	%v6 = alloca %"struct.vector.Vec<%struct.string.String>"
	%v7 = alloca i32
	%v8 = alloca %struct.string.String
	%v9 = alloca %"struct.vector.Vec<%struct.TokenData>"
	%v10 = alloca %"struct.vector.Vec<%struct.Stmt>"
	%v11 = alloca i32
	%v12 = alloca i8*
	%v13 = alloca %struct.string.String
	%v14 = alloca i1
	%v15 = alloca i32
	%v16 = alloca i32
	%v17 = alloca %struct.string.String
	%v18 = alloca i8*
	%v19 = alloca i32
	%v20 = alloca i8*
	%tmp0 = alloca i8, i64 255
	%tmp1 = call i32 @GetFullPathNameA(i8* %input_file_path, i32 255, i8* %tmp0, i8* %v0)
	store i32 0, i32* %v1
	br label %loop_cond0
loop_cond0:
	%tmp2 = load i32, i32* %v1
	%tmp3 = icmp sge i32 %tmp2, %tmp1
	br i1 %tmp3, label %then1, label %endif1
then1:
	br label %loop_body0_exit
endif1:
	%tmp4 = ptrtoint i8* %tmp0 to i64
	%tmp5 = load i32, i32* %v1
	%tmp6 = sext i32 %tmp5 to i64
	%tmp7 = add i64 %tmp4, %tmp6
	%tmp8 = inttoptr i64 %tmp7 to i8*
	store i8* %tmp8, i8** %v2
	%tmp9 = load i8*, i8** %v2
	%tmp10 = load i8, i8* %tmp9
	%tmp11 = icmp eq i8 %tmp10, 47
	br i1 %tmp11, label %then2, label %endif2
then2:
	%tmp12 = load i8*, i8** %v2
	store i8 92, i8* %tmp12
	br label %endif2
endif2:
	%tmp13 = load i32, i32* %v1
	%tmp14 = add i32 %tmp13, 1
	store i32 %tmp14, i32* %v1
	br label %loop_cond0
loop_body0_exit:
	%tmp15 = load i8*, i8** %v0
	%tmp16 = ptrtoint i8* %tmp15 to i64
	%tmp17 = ptrtoint i8* %tmp0 to i64
	%tmp18 = sub i64 %tmp16, %tmp17
	%tmp19 = trunc i64 %tmp18 to i32
	%tmp20 = sext i32 %tmp19 to i64
	call void @console.println_i64(i64 %tmp20)
	%tmp21 = call i32 @string_utils.c_str_len(i8* %input_file_path)
	%tmp22 = call i32 @string_utils.c_str_len(i8* %output_file_path)
	%tmp23 = call %struct.string.String @string.from_data(i8* %tmp0, i32 %tmp19)
	store %struct.string.String %tmp23, %struct.string.String* %v3
	call void @console.write_string(%struct.string.String* %v3)
	%tmp24 = call %"struct.vector.Vec<%struct.string.String>" @"vector.new<%struct.string.String>"()
	store %"struct.vector.Vec<%struct.string.String>" %tmp24, %"struct.vector.Vec<%struct.string.String>"* %v4
	%tmp25 = call %struct.string.String @string.from_c_string(i8* %tmp0)
	call void @"vector.push<%struct.string.String>"(%"struct.vector.Vec<%struct.string.String>"* %v4, %struct.string.String %tmp25)
	call void @console.writeln(i8* @.str.168, i32 10)
	%tmp26 = call %"struct.vector.Vec<%struct.Stmt>" @"vector.new<%struct.Stmt>"()
	store %"struct.vector.Vec<%struct.Stmt>" %tmp26, %"struct.vector.Vec<%struct.Stmt>"* %v5
	%tmp27 = call %"struct.vector.Vec<%struct.string.String>" @"vector.new<%struct.string.String>"()
	store %"struct.vector.Vec<%struct.string.String>" %tmp27, %"struct.vector.Vec<%struct.string.String>"* %v6
	store i32 0, i32* %v7
	br label %loop_start3
loop_start3:
	%tmp28 = load i32, i32* %v7
	%tmp29 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %v4, i32 0, i32 1
	%tmp30 = load i32, i32* %tmp29
	%tmp31 = icmp ult i32 %tmp28, %tmp30
	br i1 %tmp31, label %endif4, label %else4
else4:
	br label %loop_body3_exit
endif4:
	call void @console.writeln(i8* @.str.169, i32 15)
	%tmp32 = load i32, i32* %v7
	%tmp33 = load %struct.string.String*, %struct.string.String** %v4
	%tmp34 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp33, i32 %tmp32
	call void @console.write_string(%struct.string.String* %tmp34)
	call void @console.write(i8* @.str.99, i32 1)
	%tmp35 = load i32, i32* %v7
	%tmp36 = load %struct.string.String*, %struct.string.String** %v4
	%tmp37 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp36, i32 %tmp35
	%tmp38 = load i8*, i8** %tmp37
	%tmp39 = call %struct.string.String @fs.read_full_file_as_string(i8* %tmp38)
	store %struct.string.String %tmp39, %struct.string.String* %v8
	%tmp40 = call %"struct.vector.Vec<%struct.TokenData>" @"vector.new<%struct.TokenData>"()
	store %"struct.vector.Vec<%struct.TokenData>" %tmp40, %"struct.vector.Vec<%struct.TokenData>"* %v9
	call void @lex(%struct.string.String* %v8, %"struct.vector.Vec<%struct.TokenData>"* %v9, %"struct.vector.Vec<%struct.string.String>"* %v6)
	call void @string.free(%struct.string.String* %v8)
	%tmp41 = call %"struct.vector.Vec<%struct.Stmt>" @"vector.new<%struct.Stmt>"()
	store %"struct.vector.Vec<%struct.Stmt>" %tmp41, %"struct.vector.Vec<%struct.Stmt>"* %v10
	%tmp42 = load %struct.TokenData*, %struct.TokenData** %v9
	%tmp43 = getelementptr inbounds %"struct.vector.Vec<%struct.TokenData>", %"struct.vector.Vec<%struct.TokenData>"* %v9, i32 0, i32 1
	%tmp44 = load i32, i32* %tmp43
	call void @parse(%struct.TokenData* %tmp42, i32 %tmp44, %"struct.vector.Vec<%struct.string.String>"* %v6, %"struct.vector.Vec<%struct.Stmt>"* %v10)
	%tmp45 = getelementptr inbounds %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %v10, i32 0, i32 1
	%tmp46 = load i32, i32* %tmp45
	store i32 0, i32* %v11
	br label %loop_cond5
loop_cond5:
	%tmp47 = load i32, i32* %v11
	%tmp48 = getelementptr inbounds %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %v10, i32 0, i32 1
	%tmp49 = load i32, i32* %tmp48
	%tmp50 = icmp uge i32 %tmp47, %tmp49
	br i1 %tmp50, label %then6, label %endif6
then6:
	br label %loop_body5_exit
endif6:
	%tmp51 = load i32, i32* %v11
	%tmp52 = load %struct.Stmt*, %struct.Stmt** %v10
	%tmp53 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp52, i32 %tmp51
	%tmp54 = load i8, i8* %tmp53
	%tmp55 = icmp eq i8 %tmp54, 0
	br i1 %tmp55, label %then7, label %endif7
then7:
	%tmp56 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp53, i32 0, i32 1
	%tmp57 = load i8*, i8** %tmp56
	%tmp58 = load %struct.string.String*, %struct.string.String** %v6
	%tmp59 = load i16, i16* %tmp57
	%tmp60 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp58, i16 %tmp59
	%tmp61 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp60, i32 0, i32 1
	%tmp62 = load i32, i32* %tmp61
	%tmp63 = icmp eq i32 %tmp62, 7
	br i1 %tmp63, label %logic_rhs_8, label %logic_end_8
logic_rhs_8:
	%tmp64 = load i16, i16* %tmp57
	%tmp65 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp58, i16 %tmp64
	%tmp66 = load i8*, i8** %tmp65
	%tmp67 = call i32 @mem.compare(i8* %tmp66, i8* @.str.170, i64 7)
	%tmp68 = icmp eq i32 %tmp67, 0
	br label %logic_end_8
logic_end_8:
	%tmp69 = phi i1 [%tmp63, %then7], [%tmp68, %logic_rhs_8]
	br i1 %tmp69, label %then9, label %else9
then9:
	%tmp70 = getelementptr inbounds %struct.HintNode, %struct.HintNode* %tmp57, i32 0, i32 1
	%tmp71 = getelementptr inbounds %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Expression>"* %tmp70, i32 0, i32 1
	%tmp72 = load i32, i32* %tmp71
	%tmp73 = icmp ne i32 %tmp72, 1
	br i1 %tmp73, label %then10, label %endif10
then10:
	call void @process.throw(i8* @.str.171)
	br label %endif10
endif10:
	%tmp75 = getelementptr inbounds %struct.HintNode, %struct.HintNode* %tmp57, i32 0, i32 1
	%tmp76 = load %struct.Expression*, %struct.Expression** %tmp75
	%tmp77 = load i32, i32* %tmp76
	%tmp78 = icmp ne i32 %tmp77, 4
	br i1 %tmp78, label %then11, label %endif11
then11:
	call void @process.throw(i8* @.str.171)
	br label %endif11
endif11:
	%tmp79 = getelementptr inbounds %struct.Expression, %struct.Expression* %tmp76, i32 0, i32 1
	%tmp80 = load i8*, i8** %tmp79
	%tmp81 = alloca i8, i64 255
	%tmp82 = load i16, i16* %tmp80
	%tmp83 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp58, i16 %tmp82
	%tmp84 = load i8*, i8** %tmp83
	call i32 @GetFullPathNameA(i8* %tmp84, i32 255, i8* %tmp81, i8* %v12)
	%tmp85 = call %struct.string.String @string.from_c_string(i8* %tmp81)
	store %struct.string.String %tmp85, %struct.string.String* %v13
	call void @console.write(i8* @.str.172, i32 1)
	call void @console.write_string(%struct.string.String* %v13)
	call void @console.write(i8* @.str.173, i32 2)
	store i1 false, i1* %v14
	%tmp86 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %v4, i32 0, i32 1
	%tmp87 = load i32, i32* %tmp86
	store i32 0, i32* %v15
	br label %loop_cond12
loop_cond12:
	%tmp88 = load i32, i32* %v15
	%tmp89 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %v4, i32 0, i32 1
	%tmp90 = load i32, i32* %tmp89
	%tmp91 = icmp uge i32 %tmp88, %tmp90
	br i1 %tmp91, label %then13, label %endif13
then13:
	br label %loop_body12_exit
endif13:
	%tmp92 = load i32, i32* %v15
	%tmp93 = load %struct.string.String*, %struct.string.String** %v4
	%tmp94 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp93, i32 %tmp92
	%tmp95 = call i1 @string.equal(%struct.string.String* %v13, %struct.string.String* %tmp94)
	br i1 %tmp95, label %then14, label %endif14
then14:
	store i1 true, i1* %v14
	br label %loop_body12_exit
endif14:
	%tmp96 = load i32, i32* %v15
	%tmp97 = add i32 %tmp96, 1
	store i32 %tmp97, i32* %v15
	br label %loop_cond12
loop_body12_exit:
	%tmp98 = load i1, i1* %v14
	%tmp99 = xor i1 1, %tmp98
	br i1 %tmp99, label %then15, label %else15
then15:
	%tmp100 = load %struct.string.String, %struct.string.String* %v13
	call void @"vector.push<%struct.string.String>"(%"struct.vector.Vec<%struct.string.String>"* %v4, %struct.string.String %tmp100)
	br label %endif15
else15:
	call void @string.free(%struct.string.String* %v13)
	br label %endif15
endif15:
	br label %loop_body5
; Variable abs_inc_path is out.
else9:
	call void @process.throw(i8* @.str.174)
	br label %endif7
endif7:
	%tmp101 = load %struct.Stmt, %struct.Stmt* %tmp53
	call void @"vector.push<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %v5, %struct.Stmt %tmp101)
	br label %loop_body5
loop_body5:
	%tmp102 = load i32, i32* %v11
	%tmp103 = add i32 %tmp102, 1
	store i32 %tmp103, i32* %v11
	br label %loop_cond5
loop_body5_exit:
	call void @"vector.free<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %v10)
	%tmp104 = load i32, i32* %v7
	%tmp105 = add i32 %tmp104, 1
	store i32 %tmp105, i32* %v7
	br label %loop_start3
loop_body3_exit:
; Variable statement_vector is out.
; Variable token_vector is out.
; Variable file_data is out.
	call void @console.writeln(i8* @.str.175, i32 9)
	call void @console.writeln(i8* @.str.176, i32 16)
	call void @console.write(i8* @.str.177, i32 13)
	%tmp106 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %v6, i32 0, i32 1
	%tmp107 = load i32, i32* %tmp106
	%tmp108 = zext i32 %tmp107 to i64
	call void @console.println_u64(i64 %tmp108)
	%tmp109 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %v4, i32 0, i32 1
	%tmp110 = load i32, i32* %tmp109
	store i32 0, i32* %v16
	br label %loop_cond16
loop_cond16:
	%tmp111 = load i32, i32* %v16
	%tmp112 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %v4, i32 0, i32 1
	%tmp113 = load i32, i32* %tmp112
	%tmp114 = icmp uge i32 %tmp111, %tmp113
	br i1 %tmp114, label %then17, label %endif17
then17:
	br label %loop_body16_exit
endif17:
	call void @console.write(i8* @.str.172, i32 1)
	%tmp115 = load i32, i32* %v16
	%tmp116 = load %struct.string.String*, %struct.string.String** %v4
	%tmp117 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp116, i32 %tmp115
	call void @console.write_string(%struct.string.String* %tmp117)
	call void @console.write(i8* @.str.99, i32 1)
	%tmp118 = load i32, i32* %v16
	%tmp119 = add i32 %tmp118, 1
	store i32 %tmp119, i32* %v16
	br label %loop_cond16
loop_body16_exit:
	%tmp120 = getelementptr inbounds %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %v5, i32 0, i32 1
	%tmp121 = load i32, i32* %tmp120
	%tmp122 = zext i32 %tmp121 to i64
	call void @console.println_i64(i64 %tmp122)
	call void @console.writeln(i8* @.str.178, i32 12)
	%tmp123 = call %struct.string.String @string.empty()
	store %struct.string.String %tmp123, %struct.string.String* %v17
	call void @compile(%"struct.vector.Vec<%struct.Stmt>"* %v5, %"struct.vector.Vec<%struct.string.String>"* %v6, %struct.string.String* %v17)
	%tmp124 = alloca i8, i64 255
	%tmp125 = call i32 @GetFullPathNameA(i8* %output_file_path, i32 255, i8* %tmp124, i8* %v18)
	store i32 0, i32* %v19
	br label %loop_cond18
loop_cond18:
	%tmp126 = load i32, i32* %v19
	%tmp127 = icmp sge i32 %tmp126, %tmp125
	br i1 %tmp127, label %then19, label %endif19
then19:
	br label %loop_body18_exit
endif19:
	%tmp128 = ptrtoint i8* %tmp124 to i64
	%tmp129 = load i32, i32* %v19
	%tmp130 = sext i32 %tmp129 to i64
	%tmp131 = add i64 %tmp128, %tmp130
	%tmp132 = inttoptr i64 %tmp131 to i8*
	store i8* %tmp132, i8** %v20
	%tmp133 = load i8*, i8** %v20
	%tmp134 = load i8, i8* %tmp133
	%tmp135 = icmp eq i8 %tmp134, 47
	br i1 %tmp135, label %then20, label %endif20
then20:
	%tmp136 = load i8*, i8** %v20
	store i8 92, i8* %tmp136
	br label %endif20
endif20:
	%tmp137 = load i32, i32* %v19
	%tmp138 = add i32 %tmp137, 1
	store i32 %tmp138, i32* %v19
	br label %loop_cond18
loop_body18_exit:
	%tmp139 = load i8*, i8** %v17
	%tmp140 = getelementptr inbounds %struct.string.String, %struct.string.String* %v17, i32 0, i32 1
	%tmp141 = load i32, i32* %tmp140
	call i32 @fs.write_to_file(i8* %tmp124, i8* %tmp139, i32 %tmp141)
	call void @ExitProcess(i32 0)
; Variable stdout is out.
; Variable symbol_vector is out.
; Variable main_statement_vector is out.
; Variable file_stack is out.
; Variable base_env is out.
	ret void
}
define i8 @precedence(i8 %token){
entry:
	%tmp0 = icmp eq i8 %token, 15
	br i1 %tmp0, label %logic_end_0, label %logic_rhs_0
logic_rhs_0:
	%tmp1 = icmp eq i8 %token, 11
	br label %logic_end_0
logic_end_0:
	%tmp2 = phi i1 [%tmp0, %entry], [%tmp1, %logic_rhs_0]
	br i1 %tmp2, label %logic_end_1, label %logic_rhs_1
logic_rhs_1:
	%tmp3 = icmp eq i8 %token, 12
	br label %logic_end_1
logic_end_1:
	%tmp4 = phi i1 [%tmp2, %logic_end_0], [%tmp3, %logic_rhs_1]
	br i1 %tmp4, label %then2, label %endif2
then2:
	br label %func_exit
endif2:
	%tmp5 = icmp eq i8 %token, 24
	br i1 %tmp5, label %then3, label %endif3
then3:
	br label %func_exit
endif3:
	%tmp6 = icmp eq i8 %token, 25
	br i1 %tmp6, label %then4, label %endif4
then4:
	br label %func_exit
endif4:
	%tmp7 = icmp eq i8 %token, 31
	br i1 %tmp7, label %then5, label %endif5
then5:
	br label %func_exit
endif5:
	%tmp8 = icmp eq i8 %token, 33
	br i1 %tmp8, label %then6, label %endif6
then6:
	br label %func_exit
endif6:
	%tmp9 = icmp eq i8 %token, 32
	br i1 %tmp9, label %then7, label %endif7
then7:
	br label %func_exit
endif7:
	%tmp10 = icmp eq i8 %token, 22
	br i1 %tmp10, label %logic_end_8, label %logic_rhs_8
logic_rhs_8:
	%tmp11 = icmp eq i8 %token, 23
	br label %logic_end_8
logic_end_8:
	%tmp12 = phi i1 [%tmp10, %endif7], [%tmp11, %logic_rhs_8]
	br i1 %tmp12, label %then9, label %endif9
then9:
	br label %func_exit
endif9:
	%tmp13 = icmp eq i8 %token, 28
	br i1 %tmp13, label %logic_end_10, label %logic_rhs_10
logic_rhs_10:
	%tmp14 = icmp eq i8 %token, 29
	br label %logic_end_10
logic_end_10:
	%tmp15 = phi i1 [%tmp13, %endif9], [%tmp14, %logic_rhs_10]
	br i1 %tmp15, label %logic_end_11, label %logic_rhs_11
logic_rhs_11:
	%tmp16 = icmp eq i8 %token, 26
	br label %logic_end_11
logic_end_11:
	%tmp17 = phi i1 [%tmp15, %logic_end_10], [%tmp16, %logic_rhs_11]
	br i1 %tmp17, label %logic_end_12, label %logic_rhs_12
logic_rhs_12:
	%tmp18 = icmp eq i8 %token, 27
	br label %logic_end_12
logic_end_12:
	%tmp19 = phi i1 [%tmp17, %logic_end_11], [%tmp18, %logic_rhs_12]
	br i1 %tmp19, label %then13, label %endif13
then13:
	br label %func_exit
endif13:
	%tmp20 = icmp eq i8 %token, 34
	br i1 %tmp20, label %logic_end_14, label %logic_rhs_14
logic_rhs_14:
	%tmp21 = icmp eq i8 %token, 35
	br label %logic_end_14
logic_end_14:
	%tmp22 = phi i1 [%tmp20, %endif13], [%tmp21, %logic_rhs_14]
	br i1 %tmp22, label %then15, label %endif15
then15:
	br label %func_exit
endif15:
	%tmp23 = icmp eq i8 %token, 16
	br i1 %tmp23, label %logic_end_16, label %logic_rhs_16
logic_rhs_16:
	%tmp24 = icmp eq i8 %token, 17
	br label %logic_end_16
logic_end_16:
	%tmp25 = phi i1 [%tmp23, %endif15], [%tmp24, %logic_rhs_16]
	br i1 %tmp25, label %then17, label %endif17
then17:
	br label %func_exit
endif17:
	%tmp26 = icmp eq i8 %token, 18
	br i1 %tmp26, label %logic_end_18, label %logic_rhs_18
logic_rhs_18:
	%tmp27 = icmp eq i8 %token, 19
	br label %logic_end_18
logic_end_18:
	%tmp28 = phi i1 [%tmp26, %endif17], [%tmp27, %logic_rhs_18]
	br i1 %tmp28, label %logic_end_19, label %logic_rhs_19
logic_rhs_19:
	%tmp29 = icmp eq i8 %token, 20
	br label %logic_end_19
logic_end_19:
	%tmp30 = phi i1 [%tmp28, %logic_end_18], [%tmp29, %logic_rhs_19]
	br i1 %tmp30, label %then20, label %endif20
then20:
	br label %func_exit
endif20:
	%tmp31 = icmp eq i8 %token, 44
	br i1 %tmp31, label %then21, label %endif21
then21:
	br label %func_exit
endif21:
	%tmp32 = icmp eq i8 %token, 21
	br i1 %tmp32, label %logic_end_22, label %logic_rhs_22
logic_rhs_22:
	%tmp33 = icmp eq i8 %token, 30
	br label %logic_end_22
logic_end_22:
	%tmp34 = phi i1 [%tmp32, %endif21], [%tmp33, %logic_rhs_22]
	br i1 %tmp34, label %then23, label %endif23
then23:
	br label %func_exit
endif23:
	%tmp35 = icmp eq i8 %token, 0
	br i1 %tmp35, label %logic_end_24, label %logic_rhs_24
logic_rhs_24:
	%tmp36 = icmp eq i8 %token, 4
	br label %logic_end_24
logic_end_24:
	%tmp37 = phi i1 [%tmp35, %endif23], [%tmp36, %logic_rhs_24]
	br i1 %tmp37, label %logic_end_25, label %logic_rhs_25
logic_rhs_25:
	%tmp38 = icmp eq i8 %token, 10
	br label %logic_end_25
logic_end_25:
	%tmp39 = phi i1 [%tmp37, %logic_end_24], [%tmp38, %logic_rhs_25]
	br i1 %tmp39, label %logic_end_26, label %logic_rhs_26
logic_rhs_26:
	%tmp40 = icmp eq i8 %token, 7
	br label %logic_end_26
logic_end_26:
	%tmp41 = phi i1 [%tmp39, %logic_end_25], [%tmp40, %logic_rhs_26]
	br i1 %tmp41, label %then27, label %endif27
then27:
	br label %func_exit
endif27:
	br label %func_exit
func_exit:
	%tmp42 = phi i8 [1, %then2], [2, %then3], [3, %then4], [4, %then5], [5, %then6], [6, %then7], [7, %then9], [8, %then13], [9, %then15], [10, %then17], [11, %then20], [12, %then21], [13, %then23], [14, %then27], [0, %endif27]
	ret i8 %tmp42
}
define %struct.PathEx @path_to_path_ex_name(%struct.Path* %path, i16 %name){
	%v0 = alloca %struct.PathEx
	%tmp0 = call %struct.PathEx @path_to_path_ex(%struct.Path* %path)
	store %struct.PathEx %tmp0, %struct.PathEx* %v0
	%tmp1 = getelementptr inbounds %struct.PathEx, %struct.PathEx* %v0, i32 0, i32 1
	%tmp2 = load i8, i8* %v0
	%tmp3 = getelementptr inbounds [12 x i16], [12 x i16]* %tmp1, i32 0, i8 %tmp2
	store i16 %name, i16* %tmp3
	%tmp4 = load i8, i8* %v0
	%tmp5 = add i8 %tmp4, 1
	store i8 %tmp5, i8* %v0
	%tmp6 = load %struct.PathEx, %struct.PathEx* %v0
; Variable output is out.
	ret %struct.PathEx %tmp6
}
define %struct.PathEx @path_to_path_ex(%struct.Path* %path){
	%v0 = alloca %struct.PathEx
	%tmp0 = getelementptr inbounds %struct.Path, %struct.Path* %path, i32 0, i32 1
	%tmp1 = getelementptr inbounds %struct.PathEx, %struct.PathEx* %v0, i32 0, i32 1
	%tmp2 = mul i64 2, 8
	call void @mem.copy(i8* %tmp0, i8* %tmp1, i64 %tmp2)
	%tmp3 = load i8, i8* %path
	store i8 %tmp3, i8* %v0
	%tmp4 = load %struct.PathEx, %struct.PathEx* %v0
; Variable output is out.
	ret %struct.PathEx %tmp4
}
define %"struct.vector.Vec<%struct.Type>" @parse_types_comma_rparen(%struct.TokenData* %token_array, i32* %index, i32 %len){
	%tmp0 = call %"struct.vector.Vec<%struct.Type>" @parse_types_comma(%struct.TokenData* %token_array, i32* %index, i32 %len, i8 1)
	ret %"struct.vector.Vec<%struct.Type>" %tmp0
}
define %"struct.vector.Vec<%struct.Type>" @parse_types_comma(%struct.TokenData* %token_array, i32* %index, i32 %len, i8 %stop){
	%v0 = alloca %"struct.vector.Vec<%struct.Type>"
	%tmp0 = call %"struct.vector.Vec<%struct.Type>" @"vector.new<%struct.Type>"()
	store %"struct.vector.Vec<%struct.Type>" %tmp0, %"struct.vector.Vec<%struct.Type>"* %v0
	br label %loop_start0
loop_start0:
	%tmp1 = load i32, i32* %index
	%tmp2 = icmp ult i32 %tmp1, %len
	br i1 %tmp2, label %logic_rhs_1, label %logic_end_1
logic_rhs_1:
	%tmp3 = load i32, i32* %index
	%tmp4 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp3
	%tmp5 = load i8, i8* %tmp4
	%tmp6 = icmp ne i8 %tmp5, %stop
	br label %logic_end_1
logic_end_1:
	%tmp7 = phi i1 [%tmp2, %loop_start0], [%tmp6, %logic_rhs_1]
	br i1 %tmp7, label %endif2, label %else2
else2:
	br label %loop_body0_exit
endif2:
	%tmp8 = call %struct.Type @parse_type_internal(%struct.TokenData* %token_array, i32* %index, i32 %len)
	call void @"vector.push<%struct.Type>"(%"struct.vector.Vec<%struct.Type>"* %v0, %struct.Type %tmp8)
	%tmp9 = load i32, i32* %index
	%tmp10 = icmp ult i32 %tmp9, %len
	br i1 %tmp10, label %logic_rhs_3, label %logic_end_3
logic_rhs_3:
	%tmp11 = load i32, i32* %index
	%tmp12 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp11
	%tmp13 = load i8, i8* %tmp12
	%tmp14 = icmp eq i8 %tmp13, 9
	br label %logic_end_3
logic_end_3:
	%tmp15 = phi i1 [%tmp10, %endif2], [%tmp14, %logic_rhs_3]
	br i1 %tmp15, label %then4, label %else4
then4:
	%tmp16 = load i32, i32* %index
	%tmp17 = add i32 %tmp16, 1
	store i32 %tmp17, i32* %index
	%tmp18 = load i32, i32* %index
	%tmp19 = icmp ult i32 %tmp18, %len
	br i1 %tmp19, label %logic_rhs_5, label %logic_end_5
logic_rhs_5:
	%tmp20 = load i32, i32* %index
	%tmp21 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp20
	%tmp22 = load i8, i8* %tmp21
	%tmp23 = icmp eq i8 %tmp22, %stop
	br label %logic_end_5
logic_end_5:
	%tmp24 = phi i1 [%tmp19, %then4], [%tmp23, %logic_rhs_5]
	br i1 %tmp24, label %then6, label %endif6
then6:
	br label %loop_body0_exit
endif6:
	br label %endif4
else4:
	br label %loop_body0_exit
endif4:
	br label %loop_start0
loop_body0_exit:
	%tmp25 = load %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %v0
; Variable output is out.
	ret %"struct.vector.Vec<%struct.Type>" %tmp25
}
define %struct.Type @parse_type_internal(%struct.TokenData* %token_array, i32* %index, i32 %len){
	%v0 = alloca i32
	%v1 = alloca %struct.Type
	%v2 = alloca %"struct.vector.Vec<%struct.Type>"
	%v3 = alloca %struct.Type
	%v4 = alloca %struct.FunctionType*
	%v5 = alloca %struct.Type
	%v6 = alloca %struct.Expression
	%v7 = alloca %struct.ConstantSizeArrayType*
	%v8 = alloca %struct.Path
	%v9 = alloca i16
	%v10 = alloca %struct.Type
	%v11 = alloca %"struct.vector.Vec<%struct.Type>"
	%v12 = alloca %struct.GenericType*
	%v13 = alloca %struct.NamedType*
	%v14 = alloca %struct.NamespaceLinkType*
	store i32 0, i32* %v0
	br label %loop_start0
loop_start0:
	%tmp0 = load i32, i32* %index
	%tmp1 = icmp ult i32 %tmp0, %len
	br i1 %tmp1, label %endif1, label %else1
else1:
	br label %loop_body0_exit
endif1:
	%tmp2 = load i32, i32* %index
	%tmp3 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp2
	%tmp4 = load i8, i8* %tmp3
	%tmp5 = icmp eq i8 %tmp4, 32
	br i1 %tmp5, label %then2, label %else2
then2:
	%tmp6 = load i32, i32* %v0
	%tmp7 = add i32 %tmp6, 1
	store i32 %tmp7, i32* %v0
	%tmp8 = load i32, i32* %index
	%tmp9 = add i32 %tmp8, 1
	store i32 %tmp9, i32* %index
	br label %endif2
else2:
	%tmp10 = load i32, i32* %index
	%tmp11 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp10
	%tmp12 = load i8, i8* %tmp11
	%tmp13 = icmp eq i8 %tmp12, 25
	br i1 %tmp13, label %then3, label %else3
then3:
	%tmp14 = load i32, i32* %v0
	%tmp15 = add i32 %tmp14, 2
	store i32 %tmp15, i32* %v0
	%tmp16 = load i32, i32* %index
	%tmp17 = add i32 %tmp16, 1
	store i32 %tmp17, i32* %index
	br label %endif3
else3:
	br label %loop_body0_exit
endif3:
	br label %endif2
endif2:
	br label %loop_start0
loop_body0_exit:
	%tmp18 = load i32, i32* %index
	%tmp19 = icmp uge i32 %tmp18, %len
	br i1 %tmp19, label %then4, label %endif4
then4:
	call void @process.throw(i8* @.str.179)
	br label %endif4
endif4:
	%tmp20 = load i32, i32* %index
	%tmp21 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp20
	%tmp22 = load i8, i8* %tmp21
	%tmp23 = icmp eq i8 %tmp22, 41
	br i1 %tmp23, label %then5, label %else5
then5:
	%tmp24 = load i32, i32* %index
	%tmp25 = add i32 %tmp24, 1
	store i32 %tmp25, i32* %index
	call void @expect(%struct.TokenData* %token_array, i32* %index, i32 %len, i8 0, i8* @.str.180)
	%tmp26 = call %"struct.vector.Vec<%struct.Type>" @parse_types_comma(%struct.TokenData* %token_array, i32* %index, i32 %len, i8 1)
	store %"struct.vector.Vec<%struct.Type>" %tmp26, %"struct.vector.Vec<%struct.Type>"* %v2
	call void @expect(%struct.TokenData* %token_array, i32* %index, i32 %len, i8 1, i8* @.str.181)
	call void @expect(%struct.TokenData* %token_array, i32* %index, i32 %len, i8 6, i8* @.str.182)
	%tmp27 = call %struct.Type @parse_type_internal(%struct.TokenData* %token_array, i32* %index, i32 %len)
	store %struct.Type %tmp27, %struct.Type* %v3
	%tmp28 = call i8* @mem.malloc(i64 32)
	store %struct.FunctionType* %tmp28, %struct.FunctionType** %v4
	%tmp29 = load %struct.FunctionType*, %struct.FunctionType** %v4
	%tmp30 = load %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %v2
	store %"struct.vector.Vec<%struct.Type>" %tmp30, %"struct.vector.Vec<%struct.Type>"* %tmp29
	%tmp31 = load %struct.FunctionType*, %struct.FunctionType** %v4
	%tmp32 = getelementptr inbounds %struct.FunctionType, %struct.FunctionType* %tmp31, i32 0, i32 1
	%tmp33 = load %struct.Type, %struct.Type* %v3
	store %struct.Type %tmp33, %struct.Type* %tmp32
	store i32 2, i32* %v1
	%tmp34 = getelementptr inbounds %struct.Type, %struct.Type* %v1, i32 0, i32 1
	%tmp35 = load %struct.FunctionType*, %struct.FunctionType** %v4
	store i8* %tmp35, i8** %tmp34
; Variable ret is out.
; Variable args is out.
	br label %endif5
else5:
	%tmp36 = icmp eq i8 %tmp22, 4
	br i1 %tmp36, label %then6, label %else6
then6:
	%tmp37 = load i32, i32* %index
	%tmp38 = add i32 %tmp37, 1
	store i32 %tmp38, i32* %index
	%tmp39 = call %struct.Type @parse_type_internal(%struct.TokenData* %token_array, i32* %index, i32 %len)
	store %struct.Type %tmp39, %struct.Type* %v5
	call void @expect(%struct.TokenData* %token_array, i32* %index, i32 %len, i8 8, i8* @.str.183)
	%tmp40 = call %struct.Expression @parse_expression_internal(%struct.TokenData* %token_array, i32* %index, i32 %len, i8 0)
	store %struct.Expression %tmp40, %struct.Expression* %v6
	call void @expect(%struct.TokenData* %token_array, i32* %index, i32 %len, i8 5, i8* @.str.184)
	%tmp41 = call i8* @mem.malloc(i64 32)
	store %struct.ConstantSizeArrayType* %tmp41, %struct.ConstantSizeArrayType** %v7
	%tmp42 = load %struct.ConstantSizeArrayType*, %struct.ConstantSizeArrayType** %v7
	%tmp43 = load %struct.Type, %struct.Type* %v5
	store %struct.Type %tmp43, %struct.Type* %tmp42
	%tmp44 = load %struct.ConstantSizeArrayType*, %struct.ConstantSizeArrayType** %v7
	%tmp45 = getelementptr inbounds %struct.ConstantSizeArrayType, %struct.ConstantSizeArrayType* %tmp44, i32 0, i32 1
	%tmp46 = load %struct.Expression, %struct.Expression* %v6
	store %struct.Expression %tmp46, %struct.Expression* %tmp45
	store i32 5, i32* %v1
	%tmp47 = getelementptr inbounds %struct.Type, %struct.Type* %v1, i32 0, i32 1
	%tmp48 = load %struct.ConstantSizeArrayType*, %struct.ConstantSizeArrayType** %v7
	store i8* %tmp48, i8** %tmp47
; Variable size_expr is out.
; Variable inner is out.
	br label %endif6
else6:
	%tmp49 = icmp eq i8 %tmp22, 65
	br i1 %tmp49, label %then7, label %else7
then7:
	store i8 0, i8* %v8
	br label %loop_start8
loop_start8:
	%tmp50 = load i32, i32* %index
	%tmp51 = icmp ult i32 %tmp50, %len
	br i1 %tmp51, label %logic_rhs_9, label %logic_end_9
logic_rhs_9:
	%tmp52 = load i32, i32* %index
	%tmp53 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp52
	%tmp54 = load i8, i8* %tmp53
	%tmp55 = icmp eq i8 %tmp54, 65
	br label %logic_end_9
logic_end_9:
	%tmp56 = phi i1 [%tmp51, %loop_start8], [%tmp55, %logic_rhs_9]
	br i1 %tmp56, label %endif10, label %else10
else10:
	br label %loop_body8_exit
endif10:
	%tmp57 = load i8, i8* %v8
	%tmp58 = icmp uge i8 %tmp57, 8
	br i1 %tmp58, label %then11, label %endif11
then11:
	call void @process.throw(i8* @.str.185)
	br label %endif11
endif11:
	%tmp59 = getelementptr inbounds %struct.Path, %struct.Path* %v8, i32 0, i32 1
	%tmp60 = load i8, i8* %v8
	%tmp61 = getelementptr inbounds [8 x i16], [8 x i16]* %tmp59, i32 0, i8 %tmp60
	%tmp62 = load i32, i32* %index
	%tmp63 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp62
	%tmp64 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp63, i32 0, i32 1
	%tmp65 = load i16, i16* %tmp64
	store i16 %tmp65, i16* %tmp61
	%tmp66 = load i8, i8* %v8
	%tmp67 = add i8 %tmp66, 1
	store i8 %tmp67, i8* %v8
	%tmp68 = load i32, i32* %index
	%tmp69 = add i32 %tmp68, 1
	store i32 %tmp69, i32* %index
	%tmp70 = load i32, i32* %index
	%tmp71 = icmp ult i32 %tmp70, %len
	br i1 %tmp71, label %logic_rhs_12, label %logic_end_12
logic_rhs_12:
	%tmp72 = load i32, i32* %index
	%tmp73 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp72
	%tmp74 = load i8, i8* %tmp73
	%tmp75 = icmp eq i8 %tmp74, 7
	br label %logic_end_12
logic_end_12:
	%tmp76 = phi i1 [%tmp71, %endif11], [%tmp75, %logic_rhs_12]
	br i1 %tmp76, label %then13, label %else13
then13:
	%tmp77 = load i32, i32* %index
	%tmp78 = add i32 %tmp77, 1
	%tmp79 = icmp uge i32 %tmp78, %len
	br i1 %tmp79, label %logic_end_14, label %logic_rhs_14
logic_rhs_14:
	%tmp80 = load i32, i32* %index
	%tmp81 = add i32 %tmp80, 1
	%tmp82 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp81
	%tmp83 = load i8, i8* %tmp82
	%tmp84 = icmp ne i8 %tmp83, 65
	br label %logic_end_14
logic_end_14:
	%tmp85 = phi i1 [%tmp79, %then13], [%tmp84, %logic_rhs_14]
	br i1 %tmp85, label %then15, label %endif15
then15:
	call void @process.throw(i8* @.str.186)
	br label %endif15
endif15:
	%tmp86 = load i32, i32* %index
	%tmp87 = add i32 %tmp86, 1
	store i32 %tmp87, i32* %index
	br label %endif13
else13:
	br label %loop_body8_exit
endif13:
	br label %loop_start8
loop_body8_exit:
	%tmp88 = getelementptr inbounds %struct.Path, %struct.Path* %v8, i32 0, i32 1
	%tmp89 = load i8, i8* %v8
	%tmp90 = sub i8 %tmp89, 1
	%tmp91 = getelementptr inbounds [8 x i16], [8 x i16]* %tmp88, i32 0, i8 %tmp90
	%tmp92 = load i16, i16* %tmp91
	store i16 %tmp92, i16* %v9
	%tmp93 = load i8, i8* %v8
	%tmp94 = sub i8 %tmp93, 1
	store i8 %tmp94, i8* %v8
	%tmp95 = load i32, i32* %index
	%tmp96 = icmp ult i32 %tmp95, %len
	br i1 %tmp96, label %logic_rhs_16, label %logic_end_16
logic_rhs_16:
	%tmp97 = load i32, i32* %index
	%tmp98 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp97
	%tmp99 = load i8, i8* %tmp98
	%tmp100 = icmp eq i8 %tmp99, 28
	br label %logic_end_16
logic_end_16:
	%tmp101 = phi i1 [%tmp96, %loop_body8_exit], [%tmp100, %logic_rhs_16]
	br i1 %tmp101, label %then17, label %else17
then17:
	%tmp102 = load i32, i32* %index
	%tmp103 = add i32 %tmp102, 1
	store i32 %tmp103, i32* %index
	%tmp104 = call %"struct.vector.Vec<%struct.Type>" @parse_generic_args(%struct.TokenData* %token_array, i32* %index, i32 %len)
	store %"struct.vector.Vec<%struct.Type>" %tmp104, %"struct.vector.Vec<%struct.Type>"* %v11
	%tmp105 = call i8* @mem.malloc(i64 24)
	store %struct.GenericType* %tmp105, %struct.GenericType** %v12
	%tmp106 = load %struct.GenericType*, %struct.GenericType** %v12
	%tmp107 = load i16, i16* %v9
	store i16 %tmp107, i16* %tmp106
	%tmp108 = load %struct.GenericType*, %struct.GenericType** %v12
	%tmp109 = getelementptr inbounds %struct.GenericType, %struct.GenericType* %tmp108, i32 0, i32 1
	%tmp110 = load %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %v11
	store %"struct.vector.Vec<%struct.Type>" %tmp110, %"struct.vector.Vec<%struct.Type>"* %tmp109
	store i32 4, i32* %v10
	%tmp111 = getelementptr inbounds %struct.Type, %struct.Type* %v10, i32 0, i32 1
	%tmp112 = load %struct.GenericType*, %struct.GenericType** %v12
	store i8* %tmp112, i8** %tmp111
; Variable gen_args is out.
	br label %endif17
else17:
	%tmp113 = call i8* @mem.malloc(i64 2)
	store %struct.NamedType* %tmp113, %struct.NamedType** %v13
	%tmp114 = load %struct.NamedType*, %struct.NamedType** %v13
	%tmp115 = load i16, i16* %v9
	store i16 %tmp115, i16* %tmp114
	store i32 0, i32* %v10
	%tmp116 = getelementptr inbounds %struct.Type, %struct.Type* %v10, i32 0, i32 1
	%tmp117 = load %struct.NamedType*, %struct.NamedType** %v13
	store i8* %tmp117, i8** %tmp116
	br label %endif17
endif17:
	%tmp118 = load i8, i8* %v8
	%tmp119 = icmp ugt i8 %tmp118, 0
	br i1 %tmp119, label %then18, label %else18
then18:
	%tmp120 = call i8* @mem.malloc(i64 40)
	store %struct.NamespaceLinkType* %tmp120, %struct.NamespaceLinkType** %v14
	%tmp121 = load %struct.NamespaceLinkType*, %struct.NamespaceLinkType** %v14
	%tmp122 = load %struct.Path, %struct.Path* %v8
	store %struct.Path %tmp122, %struct.Path* %tmp121
	%tmp123 = load %struct.NamespaceLinkType*, %struct.NamespaceLinkType** %v14
	%tmp124 = getelementptr inbounds %struct.NamespaceLinkType, %struct.NamespaceLinkType* %tmp123, i32 0, i32 1
	%tmp125 = load %struct.Type, %struct.Type* %v10
	store %struct.Type %tmp125, %struct.Type* %tmp124
	store i32 3, i32* %v1
	%tmp126 = getelementptr inbounds %struct.Type, %struct.Type* %v1, i32 0, i32 1
	%tmp127 = load %struct.NamespaceLinkType*, %struct.NamespaceLinkType** %v14
	store i8* %tmp127, i8** %tmp126
	br label %endif18
else18:
	%tmp128 = load %struct.Type, %struct.Type* %v10
	store %struct.Type %tmp128, %struct.Type* %v1
	br label %endif18
endif18:
; Variable rval is out.
; Variable path is out.
	br label %endif7
else7:
	call void @process.throw(i8* @.str.187)
	br label %endif7
endif7:
	br label %endif6
endif6:
	br label %endif5
endif5:
	%tmp129 = load %struct.Type, %struct.Type* %v1
	%tmp130 = load i32, i32* %v0
	%tmp131 = call %struct.Type @wrap_in_pointers(%struct.Type %tmp129, i32 %tmp130)
; Variable t is out.
	ret %struct.Type %tmp131
}
define %struct.Type @parse_type(%struct.TokenData* %token_array, i32* %index, i32 %len){
	%tmp0 = call %struct.Type @parse_type_internal(%struct.TokenData* %token_array, i32* %index, i32 %len)
	ret %struct.Type %tmp0
}
define %"struct.vector.Vec<%struct.Argument>" @parse_struct_fields(%struct.TokenData* %token_array, i32* %index, i32 %len){
	%v0 = alloca %"struct.vector.Vec<%struct.Argument>"
	%v1 = alloca %struct.Argument
	%tmp0 = call %"struct.vector.Vec<%struct.Argument>" @"vector.new<%struct.Argument>"()
	store %"struct.vector.Vec<%struct.Argument>" %tmp0, %"struct.vector.Vec<%struct.Argument>"* %v0
	call void @expect(%struct.TokenData* %token_array, i32* %index, i32 %len, i8 2, i8* @.str.188)
	br label %loop_start0
loop_start0:
	%tmp1 = load i32, i32* %index
	%tmp2 = icmp ult i32 %tmp1, %len
	br i1 %tmp2, label %logic_rhs_1, label %logic_end_1
logic_rhs_1:
	%tmp3 = load i32, i32* %index
	%tmp4 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp3
	%tmp5 = load i8, i8* %tmp4
	%tmp6 = icmp ne i8 %tmp5, 3
	br label %logic_end_1
logic_end_1:
	%tmp7 = phi i1 [%tmp2, %loop_start0], [%tmp6, %logic_rhs_1]
	br i1 %tmp7, label %endif2, label %else2
else2:
	br label %loop_body0_exit
endif2:
	%tmp8 = load i32, i32* %index
	%tmp9 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp8
	%tmp10 = load i8, i8* %tmp9
	%tmp11 = icmp ne i8 %tmp10, 65
	br i1 %tmp11, label %then3, label %endif3
then3:
	call void @process.throw(i8* @.str.189)
	br label %endif3
endif3:
	%tmp12 = load i32, i32* %index
	%tmp13 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp12
	%tmp14 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp13, i32 0, i32 1
	%tmp15 = load i16, i16* %tmp14
	store i16 %tmp15, i16* %v1
	%tmp16 = load i32, i32* %index
	%tmp17 = add i32 %tmp16, 1
	store i32 %tmp17, i32* %index
	call void @expect(%struct.TokenData* %token_array, i32* %index, i32 %len, i8 6, i8* @.str.190)
	%tmp18 = getelementptr inbounds %struct.Argument, %struct.Argument* %v1, i32 0, i32 1
	%tmp19 = call %struct.Type @parse_type(%struct.TokenData* %token_array, i32* %index, i32 %len)
	store %struct.Type %tmp19, %struct.Type* %tmp18
	%tmp20 = load %struct.Argument, %struct.Argument* %v1
	call void @"vector.push<%struct.Argument>"(%"struct.vector.Vec<%struct.Argument>"* %v0, %struct.Argument %tmp20)
	%tmp21 = load i32, i32* %index
	%tmp22 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp21
	%tmp23 = load i8, i8* %tmp22
	%tmp24 = icmp eq i8 %tmp23, 9
	br i1 %tmp24, label %then4, label %else4
then4:
	%tmp25 = load i32, i32* %index
	%tmp26 = add i32 %tmp25, 1
	store i32 %tmp26, i32* %index
	br label %endif4
else4:
	%tmp27 = load i32, i32* %index
	%tmp28 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp27
	%tmp29 = load i8, i8* %tmp28
	%tmp30 = icmp ne i8 %tmp29, 3
	br i1 %tmp30, label %then5, label %endif5
then5:
	call void @process.throw(i8* @.str.191)
	br label %endif5
endif5:
	br label %endif4
endif4:
	br label %loop_start0
loop_body0_exit:
; Variable field is out.
	call void @expect(%struct.TokenData* %token_array, i32* %index, i32 %len, i8 3, i8* @.str.192)
	%tmp31 = load %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %v0
; Variable fields is out.
	ret %"struct.vector.Vec<%struct.Argument>" %tmp31
}
define %"struct.vector.Vec<ui16>" @parse_generic_params(%struct.TokenData* %token_array, i32* %index, i32 %len){
	%v0 = alloca %"struct.vector.Vec<ui16>"
	%tmp0 = call %"struct.vector.Vec<ui16>" @"vector.new<ui16>"()
	store %"struct.vector.Vec<ui16>" %tmp0, %"struct.vector.Vec<ui16>"* %v0
	%tmp1 = load i32, i32* %index
	%tmp2 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp1
	%tmp3 = load i8, i8* %tmp2
	%tmp4 = icmp eq i8 %tmp3, 28
	br i1 %tmp4, label %then0, label %endif0
then0:
	%tmp5 = load i32, i32* %index
	%tmp6 = add i32 %tmp5, 1
	store i32 %tmp6, i32* %index
	br label %loop_start1
loop_start1:
	%tmp7 = load i32, i32* %index
	%tmp8 = icmp ult i32 %tmp7, %len
	br i1 %tmp8, label %logic_rhs_2, label %logic_end_2
logic_rhs_2:
	%tmp9 = load i32, i32* %index
	%tmp10 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp9
	%tmp11 = load i8, i8* %tmp10
	%tmp12 = icmp ne i8 %tmp11, 26
	br label %logic_end_2
logic_end_2:
	%tmp13 = phi i1 [%tmp8, %loop_start1], [%tmp12, %logic_rhs_2]
	br i1 %tmp13, label %endif3, label %else3
else3:
	br label %loop_body1_exit
endif3:
	%tmp14 = load i32, i32* %index
	%tmp15 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp14
	%tmp16 = load i8, i8* %tmp15
	%tmp17 = icmp eq i8 %tmp16, 65
	br i1 %tmp17, label %then4, label %else4
then4:
	%tmp18 = load i32, i32* %index
	%tmp19 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp18
	%tmp20 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp19, i32 0, i32 1
	%tmp21 = load i16, i16* %tmp20
	call void @"vector.push<ui16>"(%"struct.vector.Vec<ui16>"* %v0, i16 %tmp21)
	%tmp22 = load i32, i32* %index
	%tmp23 = add i32 %tmp22, 1
	store i32 %tmp23, i32* %index
	br label %endif4
else4:
	%tmp24 = load i32, i32* %index
	%tmp25 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp24
	%tmp26 = load i8, i8* %tmp25
	%tmp27 = icmp eq i8 %tmp26, 9
	br i1 %tmp27, label %then5, label %else5
then5:
	%tmp28 = load i32, i32* %index
	%tmp29 = add i32 %tmp28, 1
	store i32 %tmp29, i32* %index
	br label %endif5
else5:
	call void @process.throw(i8* @.str.193)
	br label %endif5
endif5:
	br label %endif4
endif4:
	br label %loop_start1
loop_body1_exit:
	call void @expect(%struct.TokenData* %token_array, i32* %index, i32 %len, i8 26, i8* @.str.194)
	br label %endif0
endif0:
	%tmp30 = load %"struct.vector.Vec<ui16>", %"struct.vector.Vec<ui16>"* %v0
; Variable generics is out.
	ret %"struct.vector.Vec<ui16>" %tmp30
}
define %"struct.vector.Vec<%struct.Type>" @parse_generic_args(%struct.TokenData* %token_array, i32* %index, i32 %len){
	%v0 = alloca %"struct.vector.Vec<%struct.Type>"
	%tmp0 = call %"struct.vector.Vec<%struct.Type>" @"vector.new<%struct.Type>"()
	store %"struct.vector.Vec<%struct.Type>" %tmp0, %"struct.vector.Vec<%struct.Type>"* %v0
	br label %loop_start0
loop_start0:
	%tmp1 = load i32, i32* %index
	%tmp2 = icmp ult i32 %tmp1, %len
	br i1 %tmp2, label %endif1, label %else1
else1:
	br label %loop_body0_exit
endif1:
	%tmp3 = load i32, i32* %index
	%tmp4 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp3
	%tmp5 = load i8, i8* %tmp4
	%tmp6 = icmp eq i8 %tmp5, 26
	br i1 %tmp6, label %then2, label %endif2
then2:
	%tmp7 = load i32, i32* %index
	%tmp8 = add i32 %tmp7, 1
	store i32 %tmp8, i32* %index
	br label %loop_body0_exit
endif2:
	%tmp9 = icmp eq i8 %tmp5, 35
	br i1 %tmp9, label %then3, label %endif3
then3:
	call void @process.throw(i8* @.str.195)
	br label %endif3
endif3:
	%tmp10 = load i32, i32* %index
	%tmp11 = icmp uge i32 %tmp10, %len
	br i1 %tmp11, label %then4, label %endif4
then4:
	call void @process.throw(i8* @.str.196)
	br label %endif4
endif4:
	%tmp12 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %v0, i32 0, i32 1
	%tmp13 = load i32, i32* %tmp12
	%tmp14 = icmp ugt i32 %tmp13, 0
	br i1 %tmp14, label %then5, label %endif5
then5:
	%tmp15 = load i32, i32* %index
	%tmp16 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp15
	%tmp17 = load i8, i8* %tmp16
	%tmp18 = icmp ne i8 %tmp17, 9
	br i1 %tmp18, label %then6, label %endif6
then6:
	call void @process.throw(i8* @.str.197)
	br label %endif6
endif6:
	%tmp19 = load i32, i32* %index
	%tmp20 = add i32 %tmp19, 1
	store i32 %tmp20, i32* %index
	%tmp21 = load i32, i32* %index
	%tmp22 = icmp ult i32 %tmp21, %len
	br i1 %tmp22, label %logic_rhs_7, label %logic_end_7
logic_rhs_7:
	%tmp23 = load i32, i32* %index
	%tmp24 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp23
	%tmp25 = load i8, i8* %tmp24
	%tmp26 = icmp eq i8 %tmp25, 26
	br label %logic_end_7
logic_end_7:
	%tmp27 = phi i1 [%tmp22, %endif6], [%tmp26, %logic_rhs_7]
	br i1 %tmp27, label %then8, label %endif8
then8:
	%tmp28 = load i32, i32* %index
	%tmp29 = add i32 %tmp28, 1
	store i32 %tmp29, i32* %index
	br label %loop_body0_exit
endif8:
	br label %endif5
endif5:
	%tmp30 = call %struct.Type @parse_type_internal(%struct.TokenData* %token_array, i32* %index, i32 %len)
	call void @"vector.push<%struct.Type>"(%"struct.vector.Vec<%struct.Type>"* %v0, %struct.Type %tmp30)
	br label %loop_start0
loop_body0_exit:
	%tmp31 = load %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %v0
; Variable args is out.
	ret %"struct.vector.Vec<%struct.Type>" %tmp31
}
define %struct.Expression @parse_expression_internal(%struct.TokenData* %tokens, i32* %index, i32 %len, i8 %min_precedence){
	%v0 = alloca %struct.Expression
	%v1 = alloca %struct.IntegerExpr*
	%v2 = alloca %struct.CharExpr*
	%v3 = alloca %struct.DecimalExpr*
	%v4 = alloca %struct.NameExpr*
	%v5 = alloca %struct.StringConstExpr*
	%v6 = alloca %struct.BoolExpr*
	%v7 = alloca %struct.BoolExpr*
	%v8 = alloca %struct.ArrayExpr*
	%v9 = alloca %struct.UnaryOpExpr*
	%v10 = alloca i32
	%v11 = alloca %struct.string.String
	%v12 = alloca i8
	%v13 = alloca i1
	%v14 = alloca %struct.CallExpr*
	%v15 = alloca %struct.IndexExpr*
	%v16 = alloca %struct.NameWithGenericsExpr*
	%v17 = alloca %struct.StructInitExpr*
	%v18 = alloca i16
	%v19 = alloca %struct.StructInitFieldExpr
	%v20 = alloca %struct.StaticAccessExpr*
	%v21 = alloca %struct.MemberAccessExpr*
	%v22 = alloca %struct.CastExpr*
	%v23 = alloca %struct.RangeExpr*
	%v24 = alloca i8
	%v25 = alloca %struct.BinaryOpExpr*
	%tmp0 = load i32, i32* %index
	%tmp1 = icmp uge i32 %tmp0, %len
	br i1 %tmp1, label %then0, label %endif0
then0:
	call void @process.throw(i8* @.str.198)
	br label %endif0
endif0:
	%tmp2 = load i32, i32* %index
	%tmp3 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp2
	%tmp4 = load i8, i8* %tmp3
	%tmp5 = icmp eq i8 %tmp4, 66
	br i1 %tmp5, label %then1, label %else1
then1:
	%tmp6 = call i8* @mem.malloc(i64 2)
	store %struct.IntegerExpr* %tmp6, %struct.IntegerExpr** %v1
	%tmp7 = load %struct.IntegerExpr*, %struct.IntegerExpr** %v1
	%tmp8 = load i32, i32* %index
	%tmp9 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp8
	%tmp10 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp9, i32 0, i32 1
	%tmp11 = load i16, i16* %tmp10
	store i16 %tmp11, i16* %tmp7
	store i32 0, i32* %v0
	%tmp12 = getelementptr inbounds %struct.Expression, %struct.Expression* %v0, i32 0, i32 1
	%tmp13 = load %struct.IntegerExpr*, %struct.IntegerExpr** %v1
	store i8* %tmp13, i8** %tmp12
	%tmp14 = load i32, i32* %index
	%tmp15 = add i32 %tmp14, 1
	store i32 %tmp15, i32* %index
	br label %endif1
else1:
	%tmp16 = icmp eq i8 %tmp4, 69
	br i1 %tmp16, label %then2, label %else2
then2:
	%tmp17 = call i8* @mem.malloc(i64 2)
	store %struct.CharExpr* %tmp17, %struct.CharExpr** %v2
	%tmp18 = load %struct.CharExpr*, %struct.CharExpr** %v2
	%tmp19 = load i32, i32* %index
	%tmp20 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp19
	%tmp21 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp20, i32 0, i32 1
	%tmp22 = load i16, i16* %tmp21
	store i16 %tmp22, i16* %tmp18
	store i32 1, i32* %v0
	%tmp23 = getelementptr inbounds %struct.Expression, %struct.Expression* %v0, i32 0, i32 1
	%tmp24 = load %struct.CharExpr*, %struct.CharExpr** %v2
	store i8* %tmp24, i8** %tmp23
	%tmp25 = load i32, i32* %index
	%tmp26 = add i32 %tmp25, 1
	store i32 %tmp26, i32* %index
	br label %endif2
else2:
	%tmp27 = icmp eq i8 %tmp4, 67
	br i1 %tmp27, label %then3, label %else3
then3:
	%tmp28 = call i8* @mem.malloc(i64 2)
	store %struct.DecimalExpr* %tmp28, %struct.DecimalExpr** %v3
	%tmp29 = load %struct.DecimalExpr*, %struct.DecimalExpr** %v3
	%tmp30 = load i32, i32* %index
	%tmp31 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp30
	%tmp32 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp31, i32 0, i32 1
	%tmp33 = load i16, i16* %tmp32
	store i16 %tmp33, i16* %tmp29
	store i32 2, i32* %v0
	%tmp34 = getelementptr inbounds %struct.Expression, %struct.Expression* %v0, i32 0, i32 1
	%tmp35 = load %struct.DecimalExpr*, %struct.DecimalExpr** %v3
	store i8* %tmp35, i8** %tmp34
	%tmp36 = load i32, i32* %index
	%tmp37 = add i32 %tmp36, 1
	store i32 %tmp37, i32* %index
	br label %endif3
else3:
	%tmp38 = icmp eq i8 %tmp4, 65
	br i1 %tmp38, label %then4, label %else4
then4:
	%tmp39 = call i8* @mem.malloc(i64 2)
	store %struct.NameExpr* %tmp39, %struct.NameExpr** %v4
	%tmp40 = load %struct.NameExpr*, %struct.NameExpr** %v4
	%tmp41 = load i32, i32* %index
	%tmp42 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp41
	%tmp43 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp42, i32 0, i32 1
	%tmp44 = load i16, i16* %tmp43
	store i16 %tmp44, i16* %tmp40
	store i32 3, i32* %v0
	%tmp45 = getelementptr inbounds %struct.Expression, %struct.Expression* %v0, i32 0, i32 1
	%tmp46 = load %struct.NameExpr*, %struct.NameExpr** %v4
	store i8* %tmp46, i8** %tmp45
	%tmp47 = load i32, i32* %index
	%tmp48 = add i32 %tmp47, 1
	store i32 %tmp48, i32* %index
	br label %endif4
else4:
	%tmp49 = icmp eq i8 %tmp4, 68
	br i1 %tmp49, label %then5, label %else5
then5:
	%tmp50 = call i8* @mem.malloc(i64 2)
	store %struct.StringConstExpr* %tmp50, %struct.StringConstExpr** %v5
	%tmp51 = load %struct.StringConstExpr*, %struct.StringConstExpr** %v5
	%tmp52 = load i32, i32* %index
	%tmp53 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp52
	%tmp54 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp53, i32 0, i32 1
	%tmp55 = load i16, i16* %tmp54
	store i16 %tmp55, i16* %tmp51
	store i32 4, i32* %v0
	%tmp56 = getelementptr inbounds %struct.Expression, %struct.Expression* %v0, i32 0, i32 1
	%tmp57 = load %struct.StringConstExpr*, %struct.StringConstExpr** %v5
	store i8* %tmp57, i8** %tmp56
	%tmp58 = load i32, i32* %index
	%tmp59 = add i32 %tmp58, 1
	store i32 %tmp59, i32* %index
	br label %endif5
else5:
	%tmp60 = icmp eq i8 %tmp4, 62
	br i1 %tmp60, label %then6, label %else6
then6:
	%tmp61 = call i8* @mem.malloc(i64 1)
	store %struct.BoolExpr* %tmp61, %struct.BoolExpr** %v6
	%tmp62 = load %struct.BoolExpr*, %struct.BoolExpr** %v6
	store i1 true, i1* %tmp62
	store i32 17, i32* %v0
	%tmp63 = getelementptr inbounds %struct.Expression, %struct.Expression* %v0, i32 0, i32 1
	%tmp64 = load %struct.BoolExpr*, %struct.BoolExpr** %v6
	store i8* %tmp64, i8** %tmp63
	%tmp65 = load i32, i32* %index
	%tmp66 = add i32 %tmp65, 1
	store i32 %tmp66, i32* %index
	br label %endif6
else6:
	%tmp67 = icmp eq i8 %tmp4, 63
	br i1 %tmp67, label %then7, label %else7
then7:
	%tmp68 = call i8* @mem.malloc(i64 1)
	store %struct.BoolExpr* %tmp68, %struct.BoolExpr** %v7
	%tmp69 = load %struct.BoolExpr*, %struct.BoolExpr** %v7
	store i1 false, i1* %tmp69
	store i32 17, i32* %v0
	%tmp70 = getelementptr inbounds %struct.Expression, %struct.Expression* %v0, i32 0, i32 1
	%tmp71 = load %struct.BoolExpr*, %struct.BoolExpr** %v7
	store i8* %tmp71, i8** %tmp70
	%tmp72 = load i32, i32* %index
	%tmp73 = add i32 %tmp72, 1
	store i32 %tmp73, i32* %index
	br label %endif7
else7:
	%tmp74 = icmp eq i8 %tmp4, 0
	br i1 %tmp74, label %then8, label %else8
then8:
	%tmp75 = load i32, i32* %index
	%tmp76 = add i32 %tmp75, 1
	store i32 %tmp76, i32* %index
	%tmp77 = call %struct.Expression @parse_expression_internal(%struct.TokenData* %tokens, i32* %index, i32 %len, i8 0)
	store %struct.Expression %tmp77, %struct.Expression* %v0
	call void @expect(%struct.TokenData* %tokens, i32* %index, i32 %len, i8 1, i8* @.str.199)
	br label %endif8
else8:
	%tmp78 = icmp eq i8 %tmp4, 4
	br i1 %tmp78, label %then9, label %else9
then9:
	%tmp79 = load i32, i32* %index
	%tmp80 = add i32 %tmp79, 1
	store i32 %tmp80, i32* %index
	%tmp81 = call i8* @mem.malloc(i64 16)
	store %struct.ArrayExpr* %tmp81, %struct.ArrayExpr** %v8
	%tmp82 = load %struct.ArrayExpr*, %struct.ArrayExpr** %v8
	%tmp83 = call %"struct.vector.Vec<%struct.Expression>" @"vector.new<%struct.Expression>"()
	store %"struct.vector.Vec<%struct.Expression>" %tmp83, %"struct.vector.Vec<%struct.Expression>"* %tmp82
	br label %loop_start10
loop_start10:
	%tmp84 = load i32, i32* %index
	%tmp85 = icmp ult i32 %tmp84, %len
	br i1 %tmp85, label %logic_rhs_11, label %logic_end_11
logic_rhs_11:
	%tmp86 = load i32, i32* %index
	%tmp87 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp86
	%tmp88 = load i8, i8* %tmp87
	%tmp89 = icmp ne i8 %tmp88, 5
	br label %logic_end_11
logic_end_11:
	%tmp90 = phi i1 [%tmp85, %loop_start10], [%tmp89, %logic_rhs_11]
	br i1 %tmp90, label %endif12, label %else12
else12:
	br label %loop_body10_exit
endif12:
	%tmp91 = load %struct.ArrayExpr*, %struct.ArrayExpr** %v8
	%tmp92 = call %struct.Expression @parse_expression_internal(%struct.TokenData* %tokens, i32* %index, i32 %len, i8 0)
	call void @"vector.push<%struct.Expression>"(%"struct.vector.Vec<%struct.Expression>"* %tmp91, %struct.Expression %tmp92)
	%tmp93 = load i32, i32* %index
	%tmp94 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp93
	%tmp95 = load i8, i8* %tmp94
	%tmp96 = icmp eq i8 %tmp95, 9
	br i1 %tmp96, label %then13, label %else13
then13:
	%tmp97 = load i32, i32* %index
	%tmp98 = add i32 %tmp97, 1
	store i32 %tmp98, i32* %index
	br label %endif13
else13:
	%tmp99 = load i32, i32* %index
	%tmp100 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp99
	%tmp101 = load i8, i8* %tmp100
	%tmp102 = icmp ne i8 %tmp101, 5
	br i1 %tmp102, label %then14, label %endif14
then14:
	call void @process.throw(i8* @.str.200)
	br label %endif14
endif14:
	br label %endif13
endif13:
	br label %loop_start10
loop_body10_exit:
	call void @expect(%struct.TokenData* %tokens, i32* %index, i32 %len, i8 5, i8* @.str.201)
	store i32 14, i32* %v0
	%tmp103 = getelementptr inbounds %struct.Expression, %struct.Expression* %v0, i32 0, i32 1
	%tmp104 = load %struct.ArrayExpr*, %struct.ArrayExpr** %v8
	store i8* %tmp104, i8** %tmp103
	br label %endif9
else9:
	%tmp105 = call i1 @is_prefix_operator(i8 %tmp4)
	br i1 %tmp105, label %then15, label %else15
then15:
	%tmp106 = load i32, i32* %index
	%tmp107 = add i32 %tmp106, 1
	store i32 %tmp107, i32* %index
	%tmp108 = call i8* @mem.malloc(i64 24)
	store %struct.UnaryOpExpr* %tmp108, %struct.UnaryOpExpr** %v9
	%tmp109 = load %struct.UnaryOpExpr*, %struct.UnaryOpExpr** %v9
	%tmp110 = getelementptr inbounds %struct.UnaryOpExpr, %struct.UnaryOpExpr* %tmp109, i32 0, i32 1
	%tmp111 = call i8 @get_unary_op(i8 %tmp4)
	store i8 %tmp111, i8* %tmp110
	%tmp112 = load %struct.UnaryOpExpr*, %struct.UnaryOpExpr** %v9
	%tmp113 = call %struct.Expression @parse_expression_internal(%struct.TokenData* %tokens, i32* %index, i32 %len, i8 13)
	store %struct.Expression %tmp113, %struct.Expression* %tmp112
	store i32 7, i32* %v0
	%tmp114 = getelementptr inbounds %struct.Expression, %struct.Expression* %v0, i32 0, i32 1
	%tmp115 = load %struct.UnaryOpExpr*, %struct.UnaryOpExpr** %v9
	store i8* %tmp115, i8** %tmp114
	br label %endif15
else15:
	%tmp116 = icmp eq i8 %tmp4, 64
	br i1 %tmp116, label %then16, label %else16
then16:
	store i32 18, i32* %v0
	%tmp117 = getelementptr inbounds %struct.Expression, %struct.Expression* %v0, i32 0, i32 1
	store i8* null, i8** %tmp117
	%tmp118 = load i32, i32* %index
	%tmp119 = add i32 %tmp118, 1
	store i32 %tmp119, i32* %index
	br label %endif16
else16:
	store i32 0, i32* %v10
	br label %loop_cond17
loop_cond17:
	%tmp120 = load i32, i32* %v10
	%tmp121 = icmp uge i32 %tmp120, 3
	br i1 %tmp121, label %then18, label %endif18
then18:
	br label %loop_body17_exit
endif18:
	%tmp122 = load i32, i32* %index
	%tmp123 = load i32, i32* %v10
	%tmp124 = add i32 %tmp122, %tmp123
	%tmp125 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp124
	%tmp126 = call %struct.string.String @token_type_to_string(%struct.TokenData* %tmp125, %"struct.vector.Vec<%struct.string.String>"* null)
	store %struct.string.String %tmp126, %struct.string.String* %v11
	call void @console.write(i8* @.str.202, i32 4)
	call void @console.write_string(%struct.string.String* %v11)
	call void @console.write(i8* @.str.203, i32 5)
	call void @string.free(%struct.string.String* %v11)
	%tmp127 = load i32, i32* %v10
	%tmp128 = add i32 %tmp127, 1
	store i32 %tmp128, i32* %v10
	br label %loop_cond17
loop_body17_exit:
; Variable q is out.
	call void @process.throw(i8* @.str.204)
	br label %endif16
endif16:
	br label %endif15
endif15:
	br label %endif9
endif9:
	br label %endif8
endif8:
	br label %endif7
endif7:
	br label %endif6
endif6:
	br label %endif5
endif5:
	br label %endif4
endif4:
	br label %endif3
endif3:
	br label %endif2
endif2:
	br label %endif1
endif1:
	br label %loop_start19
loop_start19:
	%tmp129 = load i32, i32* %index
	%tmp130 = icmp ult i32 %tmp129, %len
	br i1 %tmp130, label %endif20, label %else20
else20:
	br label %loop_body19_exit
endif20:
	%tmp131 = load i32, i32* %index
	%tmp132 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp131
	%tmp133 = load i8, i8* %tmp132
	store i8 %tmp133, i8* %v12
	store i1 false, i1* %v13
	%tmp134 = load i8, i8* %v12
	%tmp135 = icmp eq i8 %tmp134, 8
	br i1 %tmp135, label %logic_end_21, label %logic_rhs_21
logic_rhs_21:
	%tmp136 = load i8, i8* %v12
	%tmp137 = icmp eq i8 %tmp136, 9
	br label %logic_end_21
logic_end_21:
	%tmp138 = phi i1 [%tmp135, %endif20], [%tmp137, %logic_rhs_21]
	br i1 %tmp138, label %logic_end_22, label %logic_rhs_22
logic_rhs_22:
	%tmp139 = load i8, i8* %v12
	%tmp140 = icmp eq i8 %tmp139, 1
	br label %logic_end_22
logic_end_22:
	%tmp141 = phi i1 [%tmp138, %logic_end_21], [%tmp140, %logic_rhs_22]
	br i1 %tmp141, label %logic_end_23, label %logic_rhs_23
logic_rhs_23:
	%tmp142 = load i8, i8* %v12
	%tmp143 = icmp eq i8 %tmp142, 3
	br label %logic_end_23
logic_end_23:
	%tmp144 = phi i1 [%tmp141, %logic_end_22], [%tmp143, %logic_rhs_23]
	br i1 %tmp144, label %logic_end_24, label %logic_rhs_24
logic_rhs_24:
	%tmp145 = load i8, i8* %v12
	%tmp146 = icmp eq i8 %tmp145, 5
	br label %logic_end_24
logic_end_24:
	%tmp147 = phi i1 [%tmp144, %logic_end_23], [%tmp146, %logic_rhs_24]
	br i1 %tmp147, label %then25, label %endif25
then25:
	br label %loop_body19_exit
endif25:
	%tmp148 = load i8, i8* %v12
	%tmp149 = icmp eq i8 %tmp148, 28
	br i1 %tmp149, label %logic_rhs_26, label %logic_end_26
logic_rhs_26:
	%tmp150 = load i32, i32* %index
	%tmp151 = add i32 %tmp150, 1
	%tmp152 = icmp ult i32 %tmp151, %len
	br label %logic_end_26
logic_end_26:
	%tmp153 = phi i1 [%tmp149, %endif25], [%tmp152, %logic_rhs_26]
	br i1 %tmp153, label %logic_rhs_27, label %logic_end_27
logic_rhs_27:
	%tmp154 = load i32, i32* %index
	%tmp155 = add i32 %tmp154, 1
	%tmp156 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp155
	%tmp157 = load i8, i8* %tmp156
	%tmp158 = icmp eq i8 %tmp157, 28
	br label %logic_end_27
logic_end_27:
	%tmp159 = phi i1 [%tmp153, %logic_end_26], [%tmp158, %logic_rhs_27]
	br i1 %tmp159, label %then28, label %else28
then28:
	store i8 34, i8* %v12
	store i1 true, i1* %v13
	br label %endif28
else28:
	%tmp160 = load i8, i8* %v12
	%tmp161 = icmp eq i8 %tmp160, 26
	br i1 %tmp161, label %logic_rhs_29, label %logic_end_29
logic_rhs_29:
	%tmp162 = load i32, i32* %index
	%tmp163 = add i32 %tmp162, 1
	%tmp164 = icmp ult i32 %tmp163, %len
	br label %logic_end_29
logic_end_29:
	%tmp165 = phi i1 [%tmp161, %else28], [%tmp164, %logic_rhs_29]
	br i1 %tmp165, label %logic_rhs_30, label %logic_end_30
logic_rhs_30:
	%tmp166 = load i32, i32* %index
	%tmp167 = add i32 %tmp166, 1
	%tmp168 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp167
	%tmp169 = load i8, i8* %tmp168
	%tmp170 = icmp eq i8 %tmp169, 26
	br label %logic_end_30
logic_end_30:
	%tmp171 = phi i1 [%tmp165, %logic_end_29], [%tmp170, %logic_rhs_30]
	br i1 %tmp171, label %then31, label %endif31
then31:
	store i8 35, i8* %v12
	store i1 true, i1* %v13
	br label %endif31
endif31:
	br label %endif28
endif28:
	%tmp172 = load i8, i8* %v12
	%tmp173 = call i8 @precedence(i8 %tmp172)
	%tmp174 = icmp eq i8 %tmp173, 0
	br i1 %tmp174, label %logic_end_32, label %logic_rhs_32
logic_rhs_32:
	%tmp175 = icmp ult i8 %tmp173, %min_precedence
	br label %logic_end_32
logic_end_32:
	%tmp176 = phi i1 [%tmp174, %endif28], [%tmp175, %logic_rhs_32]
	br i1 %tmp176, label %then33, label %endif33
then33:
	br label %loop_body19_exit
endif33:
	%tmp177 = load i32, i32* %index
	%tmp178 = add i32 %tmp177, 1
	store i32 %tmp178, i32* %index
	%tmp179 = load i1, i1* %v13
	br i1 %tmp179, label %then34, label %endif34
then34:
	%tmp180 = load i32, i32* %index
	%tmp181 = add i32 %tmp180, 1
	store i32 %tmp181, i32* %index
	br label %endif34
endif34:
	%tmp182 = load i8, i8* %v12
	%tmp183 = icmp eq i8 %tmp182, 0
	br i1 %tmp183, label %then35, label %else35
then35:
	%tmp184 = call i8* @mem.malloc(i64 48)
	store %struct.CallExpr* %tmp184, %struct.CallExpr** %v14
	%tmp185 = load %struct.CallExpr*, %struct.CallExpr** %v14
	%tmp186 = load %struct.Expression, %struct.Expression* %v0
	store %struct.Expression %tmp186, %struct.Expression* %tmp185
	%tmp187 = load %struct.CallExpr*, %struct.CallExpr** %v14
	%tmp188 = getelementptr inbounds %struct.CallExpr, %struct.CallExpr* %tmp187, i32 0, i32 1
	%tmp189 = call %"struct.vector.Vec<%struct.Expression>" @"vector.new<%struct.Expression>"()
	store %"struct.vector.Vec<%struct.Expression>" %tmp189, %"struct.vector.Vec<%struct.Expression>"* %tmp188
	%tmp190 = load %struct.CallExpr*, %struct.CallExpr** %v14
	%tmp191 = getelementptr inbounds %struct.CallExpr, %struct.CallExpr* %tmp190, i32 0, i32 2
	%tmp192 = call %"struct.vector.Vec<%struct.Type>" @"vector.new<%struct.Type>"()
	store %"struct.vector.Vec<%struct.Type>" %tmp192, %"struct.vector.Vec<%struct.Type>"* %tmp191
	br label %loop_start36
loop_start36:
	%tmp193 = load i32, i32* %index
	%tmp194 = icmp ult i32 %tmp193, %len
	br i1 %tmp194, label %logic_rhs_37, label %logic_end_37
logic_rhs_37:
	%tmp195 = load i32, i32* %index
	%tmp196 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp195
	%tmp197 = load i8, i8* %tmp196
	%tmp198 = icmp ne i8 %tmp197, 1
	br label %logic_end_37
logic_end_37:
	%tmp199 = phi i1 [%tmp194, %loop_start36], [%tmp198, %logic_rhs_37]
	br i1 %tmp199, label %endif38, label %else38
else38:
	br label %loop_body36_exit
endif38:
	%tmp200 = load %struct.CallExpr*, %struct.CallExpr** %v14
	%tmp201 = getelementptr inbounds %struct.CallExpr, %struct.CallExpr* %tmp200, i32 0, i32 1
	%tmp202 = call %struct.Expression @parse_expression_internal(%struct.TokenData* %tokens, i32* %index, i32 %len, i8 0)
	call void @"vector.push<%struct.Expression>"(%"struct.vector.Vec<%struct.Expression>"* %tmp201, %struct.Expression %tmp202)
	%tmp203 = load i32, i32* %index
	%tmp204 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp203
	%tmp205 = load i8, i8* %tmp204
	%tmp206 = icmp eq i8 %tmp205, 9
	br i1 %tmp206, label %then39, label %else39
then39:
	%tmp207 = load i32, i32* %index
	%tmp208 = add i32 %tmp207, 1
	store i32 %tmp208, i32* %index
	br label %endif39
else39:
	%tmp209 = load i32, i32* %index
	%tmp210 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp209
	%tmp211 = load i8, i8* %tmp210
	%tmp212 = icmp ne i8 %tmp211, 1
	br i1 %tmp212, label %then40, label %endif40
then40:
	call void @process.throw(i8* @.str.205)
	br label %endif40
endif40:
	br label %endif39
endif39:
	br label %loop_start36
loop_body36_exit:
	call void @expect(%struct.TokenData* %tokens, i32* %index, i32 %len, i8 1, i8* @.str.206)
	store i32 12, i32* %v0
	%tmp213 = getelementptr inbounds %struct.Expression, %struct.Expression* %v0, i32 0, i32 1
	%tmp214 = load %struct.CallExpr*, %struct.CallExpr** %v14
	store i8* %tmp214, i8** %tmp213
	br label %endif35
else35:
	%tmp215 = load i8, i8* %v12
	%tmp216 = icmp eq i8 %tmp215, 4
	br i1 %tmp216, label %then41, label %else41
then41:
	%tmp217 = call i8* @mem.malloc(i64 32)
	store %struct.IndexExpr* %tmp217, %struct.IndexExpr** %v15
	%tmp218 = load %struct.IndexExpr*, %struct.IndexExpr** %v15
	%tmp219 = load %struct.Expression, %struct.Expression* %v0
	store %struct.Expression %tmp219, %struct.Expression* %tmp218
	%tmp220 = load %struct.IndexExpr*, %struct.IndexExpr** %v15
	%tmp221 = getelementptr inbounds %struct.IndexExpr, %struct.IndexExpr* %tmp220, i32 0, i32 1
	%tmp222 = call %struct.Expression @parse_expression_internal(%struct.TokenData* %tokens, i32* %index, i32 %len, i8 0)
	store %struct.Expression %tmp222, %struct.Expression* %tmp221
	call void @expect(%struct.TokenData* %tokens, i32* %index, i32 %len, i8 5, i8* @.str.207)
	store i32 13, i32* %v0
	%tmp223 = getelementptr inbounds %struct.Expression, %struct.Expression* %v0, i32 0, i32 1
	%tmp224 = load %struct.IndexExpr*, %struct.IndexExpr** %v15
	store i8* %tmp224, i8** %tmp223
	br label %endif41
else41:
	%tmp225 = load i8, i8* %v12
	%tmp226 = icmp eq i8 %tmp225, 7
	br i1 %tmp226, label %then42, label %else42
then42:
	%tmp227 = load i32, i32* %index
	%tmp228 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp227
	%tmp229 = load i8, i8* %tmp228
	%tmp230 = icmp eq i8 %tmp229, 28
	br i1 %tmp230, label %then43, label %else43
then43:
	%tmp231 = load i32, i32* %index
	%tmp232 = add i32 %tmp231, 1
	store i32 %tmp232, i32* %index
	%tmp233 = call i8* @mem.malloc(i64 32)
	store %struct.NameWithGenericsExpr* %tmp233, %struct.NameWithGenericsExpr** %v16
	%tmp234 = load %struct.NameWithGenericsExpr*, %struct.NameWithGenericsExpr** %v16
	%tmp235 = load %struct.Expression, %struct.Expression* %v0
	store %struct.Expression %tmp235, %struct.Expression* %tmp234
	%tmp236 = load %struct.NameWithGenericsExpr*, %struct.NameWithGenericsExpr** %v16
	%tmp237 = getelementptr inbounds %struct.NameWithGenericsExpr, %struct.NameWithGenericsExpr* %tmp236, i32 0, i32 1
	%tmp238 = call %"struct.vector.Vec<%struct.Type>" @"vector.new<%struct.Type>"()
	store %"struct.vector.Vec<%struct.Type>" %tmp238, %"struct.vector.Vec<%struct.Type>"* %tmp237
	br label %loop_start44
loop_start44:
	%tmp239 = load i32, i32* %index
	%tmp240 = icmp ult i32 %tmp239, %len
	br i1 %tmp240, label %logic_rhs_45, label %logic_end_45
logic_rhs_45:
	%tmp241 = load i32, i32* %index
	%tmp242 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp241
	%tmp243 = load i8, i8* %tmp242
	%tmp244 = icmp ne i8 %tmp243, 26
	br label %logic_end_45
logic_end_45:
	%tmp245 = phi i1 [%tmp240, %loop_start44], [%tmp244, %logic_rhs_45]
	br i1 %tmp245, label %endif46, label %else46
else46:
	br label %loop_body44_exit
endif46:
	%tmp246 = load %struct.NameWithGenericsExpr*, %struct.NameWithGenericsExpr** %v16
	%tmp247 = getelementptr inbounds %struct.NameWithGenericsExpr, %struct.NameWithGenericsExpr* %tmp246, i32 0, i32 1
	%tmp248 = call %struct.Type @parse_type(%struct.TokenData* %tokens, i32* %index, i32 %len)
	call void @"vector.push<%struct.Type>"(%"struct.vector.Vec<%struct.Type>"* %tmp247, %struct.Type %tmp248)
	%tmp249 = load i32, i32* %index
	%tmp250 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp249
	%tmp251 = load i8, i8* %tmp250
	%tmp252 = icmp eq i8 %tmp251, 9
	br i1 %tmp252, label %then47, label %else47
then47:
	%tmp253 = load i32, i32* %index
	%tmp254 = add i32 %tmp253, 1
	store i32 %tmp254, i32* %index
	br label %endif47
else47:
	%tmp255 = load i32, i32* %index
	%tmp256 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp255
	%tmp257 = load i8, i8* %tmp256
	%tmp258 = icmp ne i8 %tmp257, 26
	br i1 %tmp258, label %then48, label %endif48
then48:
	call void @process.throw(i8* @.str.208)
	br label %endif48
endif48:
	br label %endif47
endif47:
	br label %loop_start44
loop_body44_exit:
	call void @expect(%struct.TokenData* %tokens, i32* %index, i32 %len, i8 26, i8* @.str.209)
	store i32 11, i32* %v0
	%tmp259 = getelementptr inbounds %struct.Expression, %struct.Expression* %v0, i32 0, i32 1
	%tmp260 = load %struct.NameWithGenericsExpr*, %struct.NameWithGenericsExpr** %v16
	store i8* %tmp260, i8** %tmp259
	br label %endif43
else43:
	%tmp261 = load i32, i32* %index
	%tmp262 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp261
	%tmp263 = load i8, i8* %tmp262
	%tmp264 = icmp eq i8 %tmp263, 2
	br i1 %tmp264, label %then49, label %else49
then49:
	%tmp265 = load i32, i32* %index
	%tmp266 = add i32 %tmp265, 1
	store i32 %tmp266, i32* %index
	%tmp267 = call i8* @mem.malloc(i64 32)
	store %struct.StructInitExpr* %tmp267, %struct.StructInitExpr** %v17
	%tmp268 = load %struct.StructInitExpr*, %struct.StructInitExpr** %v17
	%tmp269 = load %struct.Expression, %struct.Expression* %v0
	store %struct.Expression %tmp269, %struct.Expression* %tmp268
	%tmp270 = load %struct.StructInitExpr*, %struct.StructInitExpr** %v17
	%tmp271 = getelementptr inbounds %struct.StructInitExpr, %struct.StructInitExpr* %tmp270, i32 0, i32 1
	%tmp272 = call %"struct.vector.Vec<%struct.StructInitFieldExpr>" @"vector.new<%struct.StructInitFieldExpr>"()
	store %"struct.vector.Vec<%struct.StructInitFieldExpr>" %tmp272, %"struct.vector.Vec<%struct.StructInitFieldExpr>"* %tmp271
	br label %loop_start50
loop_start50:
	%tmp273 = load i32, i32* %index
	%tmp274 = icmp ult i32 %tmp273, %len
	br i1 %tmp274, label %logic_rhs_51, label %logic_end_51
logic_rhs_51:
	%tmp275 = load i32, i32* %index
	%tmp276 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp275
	%tmp277 = load i8, i8* %tmp276
	%tmp278 = icmp ne i8 %tmp277, 3
	br label %logic_end_51
logic_end_51:
	%tmp279 = phi i1 [%tmp274, %loop_start50], [%tmp278, %logic_rhs_51]
	br i1 %tmp279, label %endif52, label %else52
else52:
	br label %loop_body50_exit
endif52:
	%tmp280 = load i32, i32* %index
	%tmp281 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp280
	%tmp282 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp281, i32 0, i32 1
	%tmp283 = load i16, i16* %tmp282
	store i16 %tmp283, i16* %v18
	call void @expect(%struct.TokenData* %tokens, i32* %index, i32 %len, i8 65, i8* @.str.210)
	call void @expect(%struct.TokenData* %tokens, i32* %index, i32 %len, i8 6, i8* @.str.190)
	%tmp284 = load i16, i16* %v18
	store i16 %tmp284, i16* %v19
	%tmp285 = getelementptr inbounds %struct.StructInitFieldExpr, %struct.StructInitFieldExpr* %v19, i32 0, i32 1
	%tmp286 = call %struct.Expression @parse_expression_internal(%struct.TokenData* %tokens, i32* %index, i32 %len, i8 0)
	store %struct.Expression %tmp286, %struct.Expression* %tmp285
	%tmp287 = load %struct.StructInitExpr*, %struct.StructInitExpr** %v17
	%tmp288 = getelementptr inbounds %struct.StructInitExpr, %struct.StructInitExpr* %tmp287, i32 0, i32 1
	%tmp289 = load %struct.StructInitFieldExpr, %struct.StructInitFieldExpr* %v19
	call void @"vector.push<%struct.StructInitFieldExpr>"(%"struct.vector.Vec<%struct.StructInitFieldExpr>"* %tmp288, %struct.StructInitFieldExpr %tmp289)
	%tmp290 = load i32, i32* %index
	%tmp291 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp290
	%tmp292 = load i8, i8* %tmp291
	%tmp293 = icmp eq i8 %tmp292, 9
	br i1 %tmp293, label %then53, label %else53
then53:
	%tmp294 = load i32, i32* %index
	%tmp295 = add i32 %tmp294, 1
	store i32 %tmp295, i32* %index
	br label %endif53
else53:
	%tmp296 = load i32, i32* %index
	%tmp297 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp296
	%tmp298 = load i8, i8* %tmp297
	%tmp299 = icmp ne i8 %tmp298, 3
	br i1 %tmp299, label %then54, label %endif54
then54:
	call void @process.throw(i8* @.str.211)
	br label %endif54
endif54:
	br label %endif53
endif53:
	br label %loop_start50
loop_body50_exit:
; Variable fe is out.
	call void @expect(%struct.TokenData* %tokens, i32* %index, i32 %len, i8 3, i8* @.str.212)
	store i32 15, i32* %v0
	%tmp300 = getelementptr inbounds %struct.Expression, %struct.Expression* %v0, i32 0, i32 1
	%tmp301 = load %struct.StructInitExpr*, %struct.StructInitExpr** %v17
	store i8* %tmp301, i8** %tmp300
	br label %endif49
else49:
	%tmp302 = call i8* @mem.malloc(i64 24)
	store %struct.StaticAccessExpr* %tmp302, %struct.StaticAccessExpr** %v20
	%tmp303 = load %struct.StaticAccessExpr*, %struct.StaticAccessExpr** %v20
	%tmp304 = load %struct.Expression, %struct.Expression* %v0
	store %struct.Expression %tmp304, %struct.Expression* %tmp303
	%tmp305 = load i32, i32* %index
	%tmp306 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp305
	%tmp307 = load i8, i8* %tmp306
	%tmp308 = icmp ne i8 %tmp307, 65
	br i1 %tmp308, label %then55, label %endif55
then55:
	call void @process.throw(i8* @.str.213)
	br label %endif55
endif55:
	%tmp309 = load %struct.StaticAccessExpr*, %struct.StaticAccessExpr** %v20
	%tmp310 = getelementptr inbounds %struct.StaticAccessExpr, %struct.StaticAccessExpr* %tmp309, i32 0, i32 1
	%tmp311 = load i32, i32* %index
	%tmp312 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp311
	%tmp313 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp312, i32 0, i32 1
	%tmp314 = load i16, i16* %tmp313
	store i16 %tmp314, i16* %tmp310
	%tmp315 = load i32, i32* %index
	%tmp316 = add i32 %tmp315, 1
	store i32 %tmp316, i32* %index
	store i32 10, i32* %v0
	%tmp317 = getelementptr inbounds %struct.Expression, %struct.Expression* %v0, i32 0, i32 1
	%tmp318 = load %struct.StaticAccessExpr*, %struct.StaticAccessExpr** %v20
	store i8* %tmp318, i8** %tmp317
	br label %endif49
endif49:
	br label %endif43
endif43:
	br label %endif42
else42:
	%tmp319 = load i8, i8* %v12
	%tmp320 = icmp eq i8 %tmp319, 10
	br i1 %tmp320, label %then56, label %else56
then56:
	%tmp321 = call i8* @mem.malloc(i64 24)
	store %struct.MemberAccessExpr* %tmp321, %struct.MemberAccessExpr** %v21
	%tmp322 = load %struct.MemberAccessExpr*, %struct.MemberAccessExpr** %v21
	%tmp323 = load %struct.Expression, %struct.Expression* %v0
	store %struct.Expression %tmp323, %struct.Expression* %tmp322
	%tmp324 = load i32, i32* %index
	%tmp325 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp324
	%tmp326 = load i8, i8* %tmp325
	%tmp327 = icmp ne i8 %tmp326, 65
	br i1 %tmp327, label %then57, label %endif57
then57:
	call void @process.throw(i8* @.str.214)
	br label %endif57
endif57:
	%tmp328 = load %struct.MemberAccessExpr*, %struct.MemberAccessExpr** %v21
	%tmp329 = getelementptr inbounds %struct.MemberAccessExpr, %struct.MemberAccessExpr* %tmp328, i32 0, i32 1
	%tmp330 = load i32, i32* %index
	%tmp331 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp330
	%tmp332 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp331, i32 0, i32 1
	%tmp333 = load i16, i16* %tmp332
	store i16 %tmp333, i16* %tmp329
	%tmp334 = load i32, i32* %index
	%tmp335 = add i32 %tmp334, 1
	store i32 %tmp335, i32* %index
	store i32 9, i32* %v0
	%tmp336 = getelementptr inbounds %struct.Expression, %struct.Expression* %v0, i32 0, i32 1
	%tmp337 = load %struct.MemberAccessExpr*, %struct.MemberAccessExpr** %v21
	store i8* %tmp337, i8** %tmp336
	br label %endif56
else56:
	%tmp338 = load i8, i8* %v12
	%tmp339 = icmp eq i8 %tmp338, 44
	br i1 %tmp339, label %then58, label %else58
then58:
	%tmp340 = call i8* @mem.malloc(i64 32)
	store %struct.CastExpr* %tmp340, %struct.CastExpr** %v22
	%tmp341 = load %struct.CastExpr*, %struct.CastExpr** %v22
	%tmp342 = load %struct.Expression, %struct.Expression* %v0
	store %struct.Expression %tmp342, %struct.Expression* %tmp341
	%tmp343 = load %struct.CastExpr*, %struct.CastExpr** %v22
	%tmp344 = getelementptr inbounds %struct.CastExpr, %struct.CastExpr* %tmp343, i32 0, i32 1
	%tmp345 = call %struct.Type @parse_type(%struct.TokenData* %tokens, i32* %index, i32 %len)
	store %struct.Type %tmp345, %struct.Type* %tmp344
	store i32 8, i32* %v0
	%tmp346 = getelementptr inbounds %struct.Expression, %struct.Expression* %v0, i32 0, i32 1
	%tmp347 = load %struct.CastExpr*, %struct.CastExpr** %v22
	store i8* %tmp347, i8** %tmp346
	br label %endif58
else58:
	%tmp348 = load i8, i8* %v12
	%tmp349 = icmp eq i8 %tmp348, 11
	br i1 %tmp349, label %logic_end_59, label %logic_rhs_59
logic_rhs_59:
	%tmp350 = load i8, i8* %v12
	%tmp351 = icmp eq i8 %tmp350, 12
	br label %logic_end_59
logic_end_59:
	%tmp352 = phi i1 [%tmp349, %else58], [%tmp351, %logic_rhs_59]
	br i1 %tmp352, label %then60, label %else60
then60:
	%tmp353 = call i8* @mem.malloc(i64 40)
	store %struct.RangeExpr* %tmp353, %struct.RangeExpr** %v23
	%tmp354 = load %struct.RangeExpr*, %struct.RangeExpr** %v23
	%tmp355 = load %struct.Expression, %struct.Expression* %v0
	store %struct.Expression %tmp355, %struct.Expression* %tmp354
	%tmp356 = load %struct.RangeExpr*, %struct.RangeExpr** %v23
	%tmp357 = getelementptr inbounds %struct.RangeExpr, %struct.RangeExpr* %tmp356, i32 0, i32 2
	%tmp358 = load i8, i8* %v12
	%tmp359 = icmp eq i8 %tmp358, 12
	store i1 %tmp359, i1* %tmp357
	%tmp360 = load %struct.RangeExpr*, %struct.RangeExpr** %v23
	%tmp361 = getelementptr inbounds %struct.RangeExpr, %struct.RangeExpr* %tmp360, i32 0, i32 1
	%tmp362 = call %struct.Expression @parse_expression_internal(%struct.TokenData* %tokens, i32* %index, i32 %len, i8 %tmp173)
	store %struct.Expression %tmp362, %struct.Expression* %tmp361
	store i32 16, i32* %v0
	%tmp363 = getelementptr inbounds %struct.Expression, %struct.Expression* %v0, i32 0, i32 1
	%tmp364 = load %struct.RangeExpr*, %struct.RangeExpr** %v23
	store i8* %tmp364, i8** %tmp363
	br label %endif60
else60:
	%tmp365 = add i8 %tmp173, 1
	store i8 %tmp365, i8* %v24
	%tmp366 = load i8, i8* %v12
	%tmp367 = icmp eq i8 %tmp366, 15
	br i1 %tmp367, label %then61, label %endif61
then61:
	store i8 %tmp173, i8* %v24
	br label %endif61
endif61:
	%tmp368 = call i8* @mem.malloc(i64 40)
	store %struct.BinaryOpExpr* %tmp368, %struct.BinaryOpExpr** %v25
	%tmp369 = load %struct.BinaryOpExpr*, %struct.BinaryOpExpr** %v25
	%tmp370 = load %struct.Expression, %struct.Expression* %v0
	store %struct.Expression %tmp370, %struct.Expression* %tmp369
	%tmp371 = load %struct.BinaryOpExpr*, %struct.BinaryOpExpr** %v25
	%tmp372 = getelementptr inbounds %struct.BinaryOpExpr, %struct.BinaryOpExpr* %tmp371, i32 0, i32 2
	%tmp373 = load i8, i8* %v12
	%tmp374 = call i8 @get_binary_op(i8 %tmp373)
	store i8 %tmp374, i8* %tmp372
	%tmp375 = load %struct.BinaryOpExpr*, %struct.BinaryOpExpr** %v25
	%tmp376 = getelementptr inbounds %struct.BinaryOpExpr, %struct.BinaryOpExpr* %tmp375, i32 0, i32 1
	%tmp377 = load i8, i8* %v24
	%tmp378 = call %struct.Expression @parse_expression_internal(%struct.TokenData* %tokens, i32* %index, i32 %len, i8 %tmp377)
	store %struct.Expression %tmp378, %struct.Expression* %tmp376
	store i32 6, i32* %v0
	%tmp379 = getelementptr inbounds %struct.Expression, %struct.Expression* %v0, i32 0, i32 1
	%tmp380 = load %struct.BinaryOpExpr*, %struct.BinaryOpExpr** %v25
	store i8* %tmp380, i8** %tmp379
	br label %endif60
endif60:
	br label %endif58
endif58:
	br label %endif56
endif56:
	br label %endif42
endif42:
	br label %endif41
endif41:
	br label %endif35
endif35:
	br label %loop_start19
loop_body19_exit:
	%tmp381 = load %struct.Expression, %struct.Expression* %v0
; Variable expr is out.
	ret %struct.Expression %tmp381
}
define %"struct.vector.Vec<%struct.Expression>" @parse_expression_comma(%struct.TokenData* %token_array, i32* %index, i32 %len){
	%v0 = alloca %"struct.vector.Vec<%struct.Expression>"
	%v1 = alloca %struct.Expression
	%tmp0 = call %"struct.vector.Vec<%struct.Expression>" @"vector.new<%struct.Expression>"()
	store %"struct.vector.Vec<%struct.Expression>" %tmp0, %"struct.vector.Vec<%struct.Expression>"* %v0
	br label %loop_start0
loop_start0:
	%tmp1 = load i32, i32* %index
	%tmp2 = icmp ult i32 %tmp1, %len
	br i1 %tmp2, label %logic_rhs_1, label %logic_end_1
logic_rhs_1:
	%tmp3 = load i32, i32* %index
	%tmp4 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp3
	%tmp5 = load i8, i8* %tmp4
	%tmp6 = icmp ne i8 %tmp5, 1
	br label %logic_end_1
logic_end_1:
	%tmp7 = phi i1 [%tmp2, %loop_start0], [%tmp6, %logic_rhs_1]
	br i1 %tmp7, label %endif2, label %else2
else2:
	br label %loop_body0_exit
endif2:
	%tmp8 = call %struct.Expression @parse_expression(%struct.TokenData* %token_array, i32* %index, i32 %len)
	store %struct.Expression %tmp8, %struct.Expression* %v1
	%tmp9 = load %struct.Expression, %struct.Expression* %v1
	call void @"vector.push<%struct.Expression>"(%"struct.vector.Vec<%struct.Expression>"* %v0, %struct.Expression %tmp9)
	%tmp10 = load i32, i32* %index
	%tmp11 = icmp ult i32 %tmp10, %len
	br i1 %tmp11, label %logic_rhs_3, label %logic_end_3
logic_rhs_3:
	%tmp12 = load i32, i32* %index
	%tmp13 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp12
	%tmp14 = load i8, i8* %tmp13
	%tmp15 = icmp eq i8 %tmp14, 9
	br label %logic_end_3
logic_end_3:
	%tmp16 = phi i1 [%tmp11, %endif2], [%tmp15, %logic_rhs_3]
	br i1 %tmp16, label %then4, label %else4
then4:
	%tmp17 = load i32, i32* %index
	%tmp18 = add i32 %tmp17, 1
	store i32 %tmp18, i32* %index
	br label %endif4
else4:
	br label %loop_body0_exit
endif4:
	br label %loop_start0
loop_body0_exit:
; Variable expr is out.
	%tmp19 = load %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Expression>"* %v0
; Variable output is out.
	ret %"struct.vector.Vec<%struct.Expression>" %tmp19
}
define %struct.Expression @parse_expression(%struct.TokenData* %token_array, i32* %index, i32 %len){
	%tmp0 = call %struct.Expression @parse_expression_internal(%struct.TokenData* %token_array, i32* %index, i32 %len, i8 0)
	ret %struct.Expression %tmp0
}
define %"struct.vector.Vec<%struct.EnumField>" @parse_enum_fields(%struct.TokenData* %token_array, i32* %index, i32 %len){
	%v0 = alloca %"struct.vector.Vec<%struct.EnumField>"
	%v1 = alloca %struct.EnumField
	%tmp0 = call %"struct.vector.Vec<%struct.EnumField>" @"vector.new<%struct.EnumField>"()
	store %"struct.vector.Vec<%struct.EnumField>" %tmp0, %"struct.vector.Vec<%struct.EnumField>"* %v0
	call void @expect(%struct.TokenData* %token_array, i32* %index, i32 %len, i8 2, i8* @.str.215)
	br label %loop_start0
loop_start0:
	%tmp1 = load i32, i32* %index
	%tmp2 = icmp ult i32 %tmp1, %len
	br i1 %tmp2, label %logic_rhs_1, label %logic_end_1
logic_rhs_1:
	%tmp3 = load i32, i32* %index
	%tmp4 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp3
	%tmp5 = load i8, i8* %tmp4
	%tmp6 = icmp ne i8 %tmp5, 3
	br label %logic_end_1
logic_end_1:
	%tmp7 = phi i1 [%tmp2, %loop_start0], [%tmp6, %logic_rhs_1]
	br i1 %tmp7, label %endif2, label %else2
else2:
	br label %loop_body0_exit
endif2:
	%tmp8 = load i32, i32* %index
	%tmp9 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp8
	%tmp10 = load i8, i8* %tmp9
	%tmp11 = icmp ne i8 %tmp10, 65
	br i1 %tmp11, label %then3, label %endif3
then3:
	call void @process.throw(i8* @.str.216)
	br label %endif3
endif3:
	%tmp12 = load i32, i32* %index
	%tmp13 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp12
	%tmp14 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp13, i32 0, i32 1
	%tmp15 = load i16, i16* %tmp14
	store i16 %tmp15, i16* %v1
	%tmp16 = load i32, i32* %index
	%tmp17 = add i32 %tmp16, 1
	store i32 %tmp17, i32* %index
	%tmp18 = load i32, i32* %index
	%tmp19 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp18
	%tmp20 = load i8, i8* %tmp19
	%tmp21 = icmp eq i8 %tmp20, 15
	br i1 %tmp21, label %then4, label %else4
then4:
	%tmp22 = load i32, i32* %index
	%tmp23 = add i32 %tmp22, 1
	store i32 %tmp23, i32* %index
	%tmp24 = getelementptr inbounds %struct.EnumField, %struct.EnumField* %v1, i32 0, i32 1
	store i1 true, i1* %tmp24
	%tmp25 = getelementptr inbounds %struct.EnumField, %struct.EnumField* %v1, i32 0, i32 2
	%tmp26 = call %struct.Expression @parse_expression(%struct.TokenData* %token_array, i32* %index, i32 %len)
	store %struct.Expression %tmp26, %struct.Expression* %tmp25
	br label %endif4
else4:
	%tmp27 = getelementptr inbounds %struct.EnumField, %struct.EnumField* %v1, i32 0, i32 1
	store i1 false, i1* %tmp27
	br label %endif4
endif4:
	%tmp28 = load %struct.EnumField, %struct.EnumField* %v1
	call void @"vector.push<%struct.EnumField>"(%"struct.vector.Vec<%struct.EnumField>"* %v0, %struct.EnumField %tmp28)
	%tmp29 = load i32, i32* %index
	%tmp30 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp29
	%tmp31 = load i8, i8* %tmp30
	%tmp32 = icmp eq i8 %tmp31, 9
	br i1 %tmp32, label %then5, label %else5
then5:
	%tmp33 = load i32, i32* %index
	%tmp34 = add i32 %tmp33, 1
	store i32 %tmp34, i32* %index
	br label %endif5
else5:
	%tmp35 = load i32, i32* %index
	%tmp36 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp35
	%tmp37 = load i8, i8* %tmp36
	%tmp38 = icmp ne i8 %tmp37, 3
	br i1 %tmp38, label %then6, label %endif6
then6:
	call void @process.throw(i8* @.str.217)
	br label %endif6
endif6:
	br label %endif5
endif5:
	br label %loop_start0
loop_body0_exit:
; Variable field is out.
	call void @expect(%struct.TokenData* %token_array, i32* %index, i32 %len, i8 3, i8* @.str.218)
	%tmp39 = load %"struct.vector.Vec<%struct.EnumField>", %"struct.vector.Vec<%struct.EnumField>"* %v0
; Variable fields is out.
	ret %"struct.vector.Vec<%struct.EnumField>" %tmp39
}
define void @parse_body(%struct.TokenData* %token_array, i32 %token_len, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %"struct.vector.Vec<%struct.Stmt>"* %statement_vector){
	%v0 = alloca i32
	%v1 = alloca %struct.Stmt
	%v2 = alloca %struct.Expression
	%v3 = alloca %struct.Stmt
	%v4 = alloca %struct.Type
	%v5 = alloca i1
	%v6 = alloca %struct.Expression
	%v7 = alloca %struct.Expression
	%v8 = alloca %struct.Stmt
	%v9 = alloca %struct.Stmt
	%v10 = alloca %struct.Stmt
	%v11 = alloca %struct.Expression
	%v12 = alloca %"struct.vector.Vec<%struct.Stmt>"
	%v13 = alloca %"struct.vector.Vec<%struct.Stmt>"
	%v14 = alloca i32
	%v15 = alloca %struct.Stmt
	%v16 = alloca %struct.Expression
	%v17 = alloca %"struct.vector.Vec<%struct.Stmt>"
	%v18 = alloca %struct.Stmt
	%v19 = alloca %"struct.vector.Vec<%struct.Stmt>"
	%v20 = alloca %struct.Stmt
	%v21 = alloca %"struct.vector.Vec<%struct.Stmt>"
	%v22 = alloca %struct.Expression
	%v23 = alloca %struct.Stmt
	%v24 = alloca %struct.Expression
	%v25 = alloca %struct.Expression
	%v26 = alloca %"struct.vector.Vec<%struct.Stmt>"
	%v27 = alloca %struct.Stmt
	%v28 = alloca %struct.Expression
	%v29 = alloca %struct.Stmt
	%v30 = alloca i32
	%v31 = alloca %struct.string.String
	%tmp0 = icmp eq i32 %token_len, 0
	br i1 %tmp0, label %then0, label %endif0
then0:
	br label %func_exit
endif0:
	store i32 0, i32* %v0
	br label %loop_start1
loop_start1:
	%tmp1 = load i32, i32* %v0
	%tmp2 = icmp ult i32 %tmp1, %token_len
	br i1 %tmp2, label %endif2, label %else2
else2:
	br label %loop_body1_exit
endif2:
	%tmp3 = load i32, i32* %v0
	%tmp4 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp3
	%tmp5 = load i8, i8* %tmp4
	%tmp6 = icmp eq i8 %tmp5, 58
	br i1 %tmp6, label %then3, label %endif3
then3:
	%tmp7 = load i32, i32* %v0
	%tmp8 = add i32 %tmp7, 1
	store i32 %tmp8, i32* %v0
	%tmp9 = load i32, i32* %v0
	%tmp10 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp9
	%tmp11 = load i8, i8* %tmp10
	%tmp12 = icmp eq i8 %tmp11, 8
	br i1 %tmp12, label %then4, label %endif4
then4:
	%tmp13 = load i32, i32* %v0
	%tmp14 = add i32 %tmp13, 1
	store i32 %tmp14, i32* %v0
	%tmp15 = call i8* @mem.malloc(i64 24)
	store i1 false, i1* %tmp15
	store i8 10, i8* %v1
	%tmp16 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %v1, i32 0, i32 1
	store i8* %tmp15, i8** %tmp16
	%tmp17 = load %struct.Stmt, %struct.Stmt* %v1
	call void @"vector.push<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %statement_vector, %struct.Stmt %tmp17)
	br label %loop_body1
; Variable stmt is out.
endif4:
	%tmp18 = call %struct.Expression @parse_expression(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	store %struct.Expression %tmp18, %struct.Expression* %v2
	call void @expect(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 8, i8* @.str.219)
	%tmp19 = call i8* @mem.malloc(i64 24)
	store i1 true, i1* %tmp19
	%tmp20 = getelementptr inbounds %struct.ReturnNode, %struct.ReturnNode* %tmp19, i32 0, i32 1
	%tmp21 = load %struct.Expression, %struct.Expression* %v2
	store %struct.Expression %tmp21, %struct.Expression* %tmp20
	store i8 10, i8* %v3
	%tmp22 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %v3, i32 0, i32 1
	store i8* %tmp19, i8** %tmp22
	%tmp23 = load %struct.Stmt, %struct.Stmt* %v3
	call void @"vector.push<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %statement_vector, %struct.Stmt %tmp23)
	br label %loop_body1
; Variable stmt is out.
; Variable expr is out.
endif3:
	%tmp24 = icmp eq i8 %tmp5, 38
	br i1 %tmp24, label %logic_end_5, label %logic_rhs_5
logic_rhs_5:
	%tmp25 = icmp eq i8 %tmp5, 42
	br label %logic_end_5
logic_end_5:
	%tmp26 = phi i1 [%tmp24, %endif3], [%tmp25, %logic_rhs_5]
	br i1 %tmp26, label %logic_end_6, label %logic_rhs_6
logic_rhs_6:
	%tmp27 = icmp eq i8 %tmp5, 43
	br label %logic_end_6
logic_end_6:
	%tmp28 = phi i1 [%tmp26, %logic_end_5], [%tmp27, %logic_rhs_6]
	br i1 %tmp28, label %then7, label %endif7
then7:
	%tmp29 = load i32, i32* %v0
	%tmp30 = add i32 %tmp29, 1
	store i32 %tmp30, i32* %v0
	%tmp31 = load i32, i32* %v0
	%tmp32 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp31
	%tmp33 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp32, i32 0, i32 1
	%tmp34 = load i16, i16* %tmp33
	call void @expect(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 65, i8* @.str.220)
	call void @expect(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 6, i8* @.str.221)
	%tmp35 = call %struct.Type @parse_type(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	store %struct.Type %tmp35, %struct.Type* %v4
	store i1 false, i1* %v5
	%tmp36 = load i32, i32* %v0
	%tmp37 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp36
	%tmp38 = load i8, i8* %tmp37
	%tmp39 = icmp eq i8 %tmp38, 15
	br i1 %tmp39, label %then8, label %endif8
then8:
	%tmp40 = load i32, i32* %v0
	%tmp41 = add i32 %tmp40, 1
	store i32 %tmp41, i32* %v0
	%tmp42 = call %struct.Expression @parse_expression(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	store %struct.Expression %tmp42, %struct.Expression* %v7
	%tmp43 = load %struct.Expression, %struct.Expression* %v7
	store %struct.Expression %tmp43, %struct.Expression* %v6
	store i1 true, i1* %v5
; Variable x is out.
	br label %endif8
endif8:
	call void @expect(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 8, i8* @.str.222)
	%tmp44 = call i8* @mem.malloc(i64 48)
	store i16 %tmp34, i16* %tmp44
	%tmp45 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp44, i32 0, i32 3
	%tmp46 = load %struct.Type, %struct.Type* %v4
	store %struct.Type %tmp46, %struct.Type* %tmp45
	%tmp47 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp44, i32 0, i32 1
	%tmp48 = load i1, i1* %v5
	store i1 %tmp48, i1* %tmp47
	%tmp49 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp44, i32 0, i32 2
	%tmp50 = load %struct.Expression, %struct.Expression* %v6
	store %struct.Expression %tmp50, %struct.Expression* %tmp49
	%tmp51 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp44, i32 0, i32 4
	store i8 0, i8* %tmp51
	%tmp52 = icmp eq i8 %tmp5, 38
	br i1 %tmp52, label %then9, label %else9
then9:
	%tmp53 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp44, i32 0, i32 4
	store i8 2, i8* %tmp53
	br label %endif9
else9:
	%tmp54 = icmp eq i8 %tmp5, 43
	br i1 %tmp54, label %then10, label %endif10
then10:
	%tmp55 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp44, i32 0, i32 4
	store i8 1, i8* %tmp55
	br label %endif10
endif10:
	br label %endif9
endif9:
	store i8 1, i8* %v8
	%tmp56 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %v8, i32 0, i32 1
	store i8* %tmp44, i8** %tmp56
	%tmp57 = load %struct.Stmt, %struct.Stmt* %v8
	call void @"vector.push<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %statement_vector, %struct.Stmt %tmp57)
	br label %loop_body1
; Variable stmt is out.
; Variable expr is out.
; Variable type is out.
endif7:
	%tmp58 = icmp eq i8 %tmp5, 56
	br i1 %tmp58, label %then11, label %endif11
then11:
	%tmp59 = load i32, i32* %v0
	%tmp60 = add i32 %tmp59, 1
	store i32 %tmp60, i32* %v0
	call void @expect(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 8, i8* @.str.223)
	store i8 8, i8* %v9
	%tmp61 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %v9, i32 0, i32 1
	store i8* null, i8** %tmp61
	%tmp62 = load %struct.Stmt, %struct.Stmt* %v9
	call void @"vector.push<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %statement_vector, %struct.Stmt %tmp62)
	br label %loop_body1
; Variable stmt is out.
endif11:
	%tmp63 = icmp eq i8 %tmp5, 57
	br i1 %tmp63, label %then12, label %endif12
then12:
	%tmp64 = load i32, i32* %v0
	%tmp65 = add i32 %tmp64, 1
	store i32 %tmp65, i32* %v0
	call void @expect(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 8, i8* @.str.224)
	store i8 9, i8* %v10
	%tmp66 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %v10, i32 0, i32 1
	store i8* null, i8** %tmp66
	%tmp67 = load %struct.Stmt, %struct.Stmt* %v10
	call void @"vector.push<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %statement_vector, %struct.Stmt %tmp67)
	br label %loop_body1
; Variable stmt is out.
endif12:
	%tmp68 = icmp eq i8 %tmp5, 45
	br i1 %tmp68, label %then13, label %endif13
then13:
	%tmp69 = load i32, i32* %v0
	%tmp70 = add i32 %tmp69, 1
	store i32 %tmp70, i32* %v0
	%tmp71 = call %struct.Expression @parse_expression(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	store %struct.Expression %tmp71, %struct.Expression* %v11
	%tmp72 = load i32, i32* %v0
	%tmp73 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp72
	%tmp74 = load i8, i8* %tmp73
	%tmp75 = icmp ne i8 %tmp74, 2
	br i1 %tmp75, label %then14, label %endif14
then14:
	call void @process.throw(i8* @.str.225)
	br label %endif14
endif14:
	%tmp76 = load i32, i32* %v0
	%tmp77 = add i32 %tmp76, 1
	call void @skip_nested(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 2, i8 3)
	%tmp78 = load i32, i32* %v0
	%tmp79 = sub i32 %tmp78, 1
	%tmp80 = sub i32 %tmp79, %tmp77
	%tmp81 = call %"struct.vector.Vec<%struct.Stmt>" @"vector.new<%struct.Stmt>"()
	store %"struct.vector.Vec<%struct.Stmt>" %tmp81, %"struct.vector.Vec<%struct.Stmt>"* %v12
	%tmp82 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp77
	call void @parse_body(%struct.TokenData* %tmp82, i32 %tmp80, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %"struct.vector.Vec<%struct.Stmt>"* %v12)
	%tmp83 = call %"struct.vector.Vec<%struct.Stmt>" @"vector.new<%struct.Stmt>"()
	store %"struct.vector.Vec<%struct.Stmt>" %tmp83, %"struct.vector.Vec<%struct.Stmt>"* %v13
	%tmp84 = load i32, i32* %v0
	%tmp85 = icmp ult i32 %tmp84, %token_len
	br i1 %tmp85, label %logic_rhs_15, label %logic_end_15
logic_rhs_15:
	%tmp86 = load i32, i32* %v0
	%tmp87 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp86
	%tmp88 = load i8, i8* %tmp87
	%tmp89 = icmp eq i8 %tmp88, 46
	br label %logic_end_15
logic_end_15:
	%tmp90 = phi i1 [%tmp85, %endif14], [%tmp89, %logic_rhs_15]
	br i1 %tmp90, label %then16, label %endif16
then16:
	%tmp91 = load i32, i32* %v0
	%tmp92 = add i32 %tmp91, 1
	store i32 %tmp92, i32* %v0
	%tmp93 = load i32, i32* %v0
	%tmp94 = icmp ult i32 %tmp93, %token_len
	br i1 %tmp94, label %logic_rhs_17, label %logic_end_17
logic_rhs_17:
	%tmp95 = load i32, i32* %v0
	%tmp96 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp95
	%tmp97 = load i8, i8* %tmp96
	%tmp98 = icmp eq i8 %tmp97, 45
	br label %logic_end_17
logic_end_17:
	%tmp99 = phi i1 [%tmp94, %then16], [%tmp98, %logic_rhs_17]
	br i1 %tmp99, label %then18, label %else18
then18:
	%tmp100 = load i32, i32* %v0
	%tmp101 = load i32, i32* %v0
	store i32 %tmp101, i32* %v14
	call void @skip_if_statement(%struct.TokenData* %token_array, i32* %v14, i32 %token_len)
	%tmp102 = load i32, i32* %v14
	%tmp103 = sub i32 %tmp102, %tmp100
	%tmp104 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp100
	call void @parse_body(%struct.TokenData* %tmp104, i32 %tmp103, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %"struct.vector.Vec<%struct.Stmt>"* %v13)
	%tmp105 = load i32, i32* %v14
	store i32 %tmp105, i32* %v0
	br label %endif18
else18:
	%tmp106 = load i32, i32* %v0
	%tmp107 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp106
	%tmp108 = load i8, i8* %tmp107
	%tmp109 = icmp ne i8 %tmp108, 2
	br i1 %tmp109, label %then19, label %endif19
then19:
	call void @process.throw(i8* @.str.226)
	br label %endif19
endif19:
	%tmp110 = load i32, i32* %v0
	%tmp111 = add i32 %tmp110, 1
	call void @skip_nested(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 2, i8 3)
	%tmp112 = load i32, i32* %v0
	%tmp113 = sub i32 %tmp112, 1
	%tmp114 = sub i32 %tmp113, %tmp111
	%tmp115 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp111
	call void @parse_body(%struct.TokenData* %tmp115, i32 %tmp114, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %"struct.vector.Vec<%struct.Stmt>"* %v13)
	br label %endif18
endif18:
	br label %endif16
endif16:
	%tmp116 = call i8* @mem.malloc(i64 48)
	%tmp117 = load %struct.Expression, %struct.Expression* %v11
	store %struct.Expression %tmp117, %struct.Expression* %tmp116
	%tmp118 = getelementptr inbounds %struct.IfStmt, %struct.IfStmt* %tmp116, i32 0, i32 1
	%tmp119 = load %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %v12
	store %"struct.vector.Vec<%struct.Stmt>" %tmp119, %"struct.vector.Vec<%struct.Stmt>"* %tmp118
	%tmp120 = getelementptr inbounds %struct.IfStmt, %struct.IfStmt* %tmp116, i32 0, i32 2
	%tmp121 = load %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %v13
	store %"struct.vector.Vec<%struct.Stmt>" %tmp121, %"struct.vector.Vec<%struct.Stmt>"* %tmp120
	store i8 3, i8* %v15
	%tmp122 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %v15, i32 0, i32 1
	store i8* %tmp116, i8** %tmp122
	%tmp123 = load %struct.Stmt, %struct.Stmt* %v15
	call void @"vector.push<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %statement_vector, %struct.Stmt %tmp123)
	br label %loop_body1
; Variable stmt is out.
; Variable else_body is out.
; Variable then_body is out.
; Variable expression is out.
endif13:
	%tmp124 = icmp eq i8 %tmp5, 55
	br i1 %tmp124, label %then20, label %endif20
then20:
	%tmp125 = load i32, i32* %v0
	%tmp126 = add i32 %tmp125, 1
	store i32 %tmp126, i32* %v0
	%tmp127 = call %struct.Expression @parse_expression(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	store %struct.Expression %tmp127, %struct.Expression* %v16
	%tmp128 = load i32, i32* %v0
	%tmp129 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp128
	%tmp130 = load i8, i8* %tmp129
	%tmp131 = icmp ne i8 %tmp130, 2
	br i1 %tmp131, label %then21, label %endif21
then21:
	call void @process.throw(i8* @.str.227)
	br label %endif21
endif21:
	%tmp132 = load i32, i32* %v0
	%tmp133 = add i32 %tmp132, 1
	call void @skip_nested(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 2, i8 3)
	%tmp134 = load i32, i32* %v0
	%tmp135 = sub i32 %tmp134, 1
	%tmp136 = sub i32 %tmp135, %tmp133
	%tmp137 = call %"struct.vector.Vec<%struct.Stmt>" @"vector.new<%struct.Stmt>"()
	store %"struct.vector.Vec<%struct.Stmt>" %tmp137, %"struct.vector.Vec<%struct.Stmt>"* %v17
	%tmp138 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp133
	call void @parse_body(%struct.TokenData* %tmp138, i32 %tmp136, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %"struct.vector.Vec<%struct.Stmt>"* %v17)
	%tmp139 = call i8* @mem.malloc(i64 32)
	%tmp140 = load %struct.Expression, %struct.Expression* %v16
	store %struct.Expression %tmp140, %struct.Expression* %tmp139
	%tmp141 = getelementptr inbounds %struct.WhileStmt, %struct.WhileStmt* %tmp139, i32 0, i32 1
	%tmp142 = load %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %v17
	store %"struct.vector.Vec<%struct.Stmt>" %tmp142, %"struct.vector.Vec<%struct.Stmt>"* %tmp141
	store i8 5, i8* %v18
	%tmp143 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %v18, i32 0, i32 1
	store i8* %tmp139, i8** %tmp143
	%tmp144 = load %struct.Stmt, %struct.Stmt* %v18
	call void @"vector.push<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %statement_vector, %struct.Stmt %tmp144)
	br label %loop_body1
; Variable stmt is out.
; Variable body is out.
; Variable expression is out.
endif20:
	%tmp145 = icmp eq i8 %tmp5, 51
	br i1 %tmp145, label %then22, label %endif22
then22:
	%tmp146 = load i32, i32* %v0
	%tmp147 = add i32 %tmp146, 1
	store i32 %tmp147, i32* %v0
	%tmp148 = load i32, i32* %v0
	%tmp149 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp148
	%tmp150 = load i8, i8* %tmp149
	%tmp151 = icmp ne i8 %tmp150, 2
	br i1 %tmp151, label %then23, label %endif23
then23:
	call void @process.throw(i8* @.str.227)
	br label %endif23
endif23:
	%tmp152 = load i32, i32* %v0
	%tmp153 = add i32 %tmp152, 1
	call void @skip_nested(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 2, i8 3)
	%tmp154 = load i32, i32* %v0
	%tmp155 = sub i32 %tmp154, 1
	%tmp156 = sub i32 %tmp155, %tmp153
	%tmp157 = call %"struct.vector.Vec<%struct.Stmt>" @"vector.new<%struct.Stmt>"()
	store %"struct.vector.Vec<%struct.Stmt>" %tmp157, %"struct.vector.Vec<%struct.Stmt>"* %v19
	%tmp158 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp153
	call void @parse_body(%struct.TokenData* %tmp158, i32 %tmp156, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %"struct.vector.Vec<%struct.Stmt>"* %v19)
	%tmp159 = call i8* @mem.malloc(i64 16)
	%tmp160 = load %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %v19
	store %"struct.vector.Vec<%struct.Stmt>" %tmp160, %"struct.vector.Vec<%struct.Stmt>"* %tmp159
	store i8 4, i8* %v20
	%tmp161 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %v20, i32 0, i32 1
	store i8* %tmp159, i8** %tmp161
	%tmp162 = load %struct.Stmt, %struct.Stmt* %v20
	call void @"vector.push<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %statement_vector, %struct.Stmt %tmp162)
	br label %loop_body1
; Variable stmt is out.
; Variable body is out.
endif22:
	%tmp163 = icmp eq i8 %tmp5, 53
	br i1 %tmp163, label %then24, label %endif24
then24:
	%tmp164 = load i32, i32* %v0
	%tmp165 = add i32 %tmp164, 1
	store i32 %tmp165, i32* %v0
	%tmp166 = load i32, i32* %v0
	%tmp167 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp166
	%tmp168 = load i8, i8* %tmp167
	%tmp169 = icmp ne i8 %tmp168, 2
	br i1 %tmp169, label %then25, label %endif25
then25:
	call void @process.throw(i8* @.str.227)
	br label %endif25
endif25:
	%tmp170 = load i32, i32* %v0
	%tmp171 = add i32 %tmp170, 1
	call void @skip_nested(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 2, i8 3)
	%tmp172 = load i32, i32* %v0
	%tmp173 = sub i32 %tmp172, 1
	%tmp174 = sub i32 %tmp173, %tmp171
	%tmp175 = call %"struct.vector.Vec<%struct.Stmt>" @"vector.new<%struct.Stmt>"()
	store %"struct.vector.Vec<%struct.Stmt>" %tmp175, %"struct.vector.Vec<%struct.Stmt>"* %v21
	%tmp176 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp171
	call void @parse_body(%struct.TokenData* %tmp176, i32 %tmp174, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %"struct.vector.Vec<%struct.Stmt>"* %v21)
	call void @expect(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 55, i8* @.str.228)
	%tmp177 = call %struct.Expression @parse_expression(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	store %struct.Expression %tmp177, %struct.Expression* %v22
	call void @expect(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 8, i8* @.str.229)
	%tmp178 = call i8* @mem.malloc(i64 32)
	%tmp179 = load %struct.Expression, %struct.Expression* %v22
	store %struct.Expression %tmp179, %struct.Expression* %tmp178
	%tmp180 = getelementptr inbounds %struct.DoWhileStmt, %struct.DoWhileStmt* %tmp178, i32 0, i32 1
	%tmp181 = load %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %v21
	store %"struct.vector.Vec<%struct.Stmt>" %tmp181, %"struct.vector.Vec<%struct.Stmt>"* %tmp180
	store i8 6, i8* %v23
	%tmp182 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %v23, i32 0, i32 1
	store i8* %tmp178, i8** %tmp182
	%tmp183 = load %struct.Stmt, %struct.Stmt* %v23
	call void @"vector.push<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %statement_vector, %struct.Stmt %tmp183)
	br label %loop_body1
; Variable stmt is out.
; Variable expression is out.
; Variable body is out.
endif24:
	%tmp184 = icmp eq i8 %tmp5, 52
	br i1 %tmp184, label %then26, label %endif26
then26:
	%tmp185 = load i32, i32* %v0
	%tmp186 = add i32 %tmp185, 1
	store i32 %tmp186, i32* %v0
	%tmp187 = call %struct.Expression @parse_expression(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	store %struct.Expression %tmp187, %struct.Expression* %v24
	call void @expect(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 54, i8* @.str.230)
	%tmp188 = call %struct.Expression @parse_expression(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	store %struct.Expression %tmp188, %struct.Expression* %v25
	%tmp189 = load i32, i32* %v0
	%tmp190 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp189
	%tmp191 = load i8, i8* %tmp190
	%tmp192 = icmp ne i8 %tmp191, 2
	br i1 %tmp192, label %then27, label %endif27
then27:
	call void @process.throw(i8* @.str.231)
	br label %endif27
endif27:
	%tmp193 = load i32, i32* %v0
	%tmp194 = add i32 %tmp193, 1
	call void @skip_nested(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 2, i8 3)
	%tmp195 = load i32, i32* %v0
	%tmp196 = sub i32 %tmp195, 1
	%tmp197 = sub i32 %tmp196, %tmp194
	%tmp198 = call %"struct.vector.Vec<%struct.Stmt>" @"vector.new<%struct.Stmt>"()
	store %"struct.vector.Vec<%struct.Stmt>" %tmp198, %"struct.vector.Vec<%struct.Stmt>"* %v26
	%tmp199 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp194
	call void @parse_body(%struct.TokenData* %tmp199, i32 %tmp197, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %"struct.vector.Vec<%struct.Stmt>"* %v26)
	%tmp200 = call i8* @mem.malloc(i64 48)
	%tmp201 = load %struct.Expression, %struct.Expression* %v24
	store %struct.Expression %tmp201, %struct.Expression* %tmp200
	%tmp202 = getelementptr inbounds %struct.ForStmt, %struct.ForStmt* %tmp200, i32 0, i32 1
	%tmp203 = load %struct.Expression, %struct.Expression* %v25
	store %struct.Expression %tmp203, %struct.Expression* %tmp202
	%tmp204 = getelementptr inbounds %struct.ForStmt, %struct.ForStmt* %tmp200, i32 0, i32 2
	%tmp205 = load %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %v26
	store %"struct.vector.Vec<%struct.Stmt>" %tmp205, %"struct.vector.Vec<%struct.Stmt>"* %tmp204
	store i8 7, i8* %v27
	%tmp206 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %v27, i32 0, i32 1
	store i8* %tmp200, i8** %tmp206
	%tmp207 = load %struct.Stmt, %struct.Stmt* %v27
	call void @"vector.push<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %statement_vector, %struct.Stmt %tmp207)
	br label %loop_body1
; Variable stmt is out.
; Variable body is out.
; Variable in_expr is out.
; Variable iter_expr is out.
endif26:
	%tmp208 = call i1 @is_expression_starter(i8 %tmp5)
	br i1 %tmp208, label %then28, label %endif28
then28:
	%tmp209 = call %struct.Expression @parse_expression(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	store %struct.Expression %tmp209, %struct.Expression* %v28
	call void @expect(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 8, i8* @.str.232)
	%tmp210 = call i8* @mem.malloc(i64 16)
	%tmp211 = load %struct.Expression, %struct.Expression* %v28
	store %struct.Expression %tmp211, %struct.Expression* %tmp210
	store i8 2, i8* %v29
	%tmp212 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %v29, i32 0, i32 1
	store i8* %tmp210, i8** %tmp212
	%tmp213 = load %struct.Stmt, %struct.Stmt* %v29
	call void @"vector.push<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %statement_vector, %struct.Stmt %tmp213)
	br label %loop_body1
; Variable stmt is out.
; Variable expression is out.
endif28:
	store i32 0, i32* %v30
	br label %loop_cond29
loop_cond29:
	%tmp214 = load i32, i32* %v30
	%tmp215 = icmp uge i32 %tmp214, 3
	br i1 %tmp215, label %then30, label %endif30
then30:
	br label %loop_body29_exit
endif30:
	%tmp216 = load i32, i32* %v0
	%tmp217 = load i32, i32* %v30
	%tmp218 = add i32 %tmp216, %tmp217
	%tmp219 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp218
	%tmp220 = call %struct.string.String @token_type_to_string(%struct.TokenData* %tmp219, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector)
	store %struct.string.String %tmp220, %struct.string.String* %v31
	call void @console.write(i8* @.str.202, i32 4)
	call void @console.write_string(%struct.string.String* %v31)
	call void @console.write(i8* @.str.203, i32 5)
	call void @string.free(%struct.string.String* %v31)
	%tmp221 = load i32, i32* %v30
	%tmp222 = add i32 %tmp221, 1
	store i32 %tmp222, i32* %v30
	br label %loop_cond29
loop_body29_exit:
; Variable q is out.
	call void @process.throw(i8* @.str.233)
	br label %loop_body1
loop_body1:
	br label %loop_start1
loop_body1_exit:
	br label %func_exit
func_exit:
	ret void
}
define %"struct.vector.Vec<%struct.Argument>" @parse_argument_comma(%struct.TokenData* %token_array, i32* %index, i32 %len){
	%v0 = alloca %"struct.vector.Vec<%struct.Argument>"
	%v1 = alloca %struct.Argument
	%tmp0 = call %"struct.vector.Vec<%struct.Argument>" @"vector.new<%struct.Argument>"()
	store %"struct.vector.Vec<%struct.Argument>" %tmp0, %"struct.vector.Vec<%struct.Argument>"* %v0
	br label %loop_start0
loop_start0:
	%tmp1 = load i32, i32* %index
	%tmp2 = icmp ult i32 %tmp1, %len
	br i1 %tmp2, label %logic_rhs_1, label %logic_end_1
logic_rhs_1:
	%tmp3 = load i32, i32* %index
	%tmp4 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp3
	%tmp5 = load i8, i8* %tmp4
	%tmp6 = icmp ne i8 %tmp5, 1
	br label %logic_end_1
logic_end_1:
	%tmp7 = phi i1 [%tmp2, %loop_start0], [%tmp6, %logic_rhs_1]
	br i1 %tmp7, label %endif2, label %else2
else2:
	br label %loop_body0_exit
endif2:
	%tmp8 = load i32, i32* %index
	%tmp9 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp8
	%tmp10 = load i8, i8* %tmp9
	%tmp11 = icmp ne i8 %tmp10, 65
	br i1 %tmp11, label %then3, label %endif3
then3:
	call void @process.throw(i8* @.str.234)
	br label %endif3
endif3:
	%tmp12 = load i32, i32* %index
	%tmp13 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp12
	%tmp14 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp13, i32 0, i32 1
	%tmp15 = load i16, i16* %tmp14
	store i16 %tmp15, i16* %v1
	%tmp16 = load i32, i32* %index
	%tmp17 = add i32 %tmp16, 1
	store i32 %tmp17, i32* %index
	%tmp18 = load i32, i32* %index
	%tmp19 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp18
	%tmp20 = load i8, i8* %tmp19
	%tmp21 = icmp ne i8 %tmp20, 6
	br i1 %tmp21, label %then4, label %endif4
then4:
	call void @process.throw(i8* @.str.235)
	br label %endif4
endif4:
	%tmp22 = load i32, i32* %index
	%tmp23 = add i32 %tmp22, 1
	store i32 %tmp23, i32* %index
	%tmp24 = getelementptr inbounds %struct.Argument, %struct.Argument* %v1, i32 0, i32 1
	%tmp25 = call %struct.Type @parse_type(%struct.TokenData* %token_array, i32* %index, i32 %len)
	store %struct.Type %tmp25, %struct.Type* %tmp24
	%tmp26 = load %struct.Argument, %struct.Argument* %v1
	call void @"vector.push<%struct.Argument>"(%"struct.vector.Vec<%struct.Argument>"* %v0, %struct.Argument %tmp26)
	%tmp27 = load i32, i32* %index
	%tmp28 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp27
	%tmp29 = load i8, i8* %tmp28
	%tmp30 = icmp eq i8 %tmp29, 9
	br i1 %tmp30, label %then5, label %else5
then5:
	%tmp31 = load i32, i32* %index
	%tmp32 = add i32 %tmp31, 1
	store i32 %tmp32, i32* %index
	br label %endif5
else5:
	%tmp33 = load i32, i32* %index
	%tmp34 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp33
	%tmp35 = load i8, i8* %tmp34
	%tmp36 = icmp ne i8 %tmp35, 1
	br i1 %tmp36, label %then6, label %endif6
then6:
	call void @process.throw(i8* @.str.236)
	br label %endif6
endif6:
	br label %endif5
endif5:
	br label %loop_start0
loop_body0_exit:
; Variable arg is out.
	%tmp37 = load %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %v0
; Variable output is out.
	ret %"struct.vector.Vec<%struct.Argument>" %tmp37
}
define void @parse(%struct.TokenData* %token_array, i32 %token_len, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %"struct.vector.Vec<%struct.Stmt>"* %statement_vector){
	%v0 = alloca i32
	%v1 = alloca i32
	%v2 = alloca i1
	%v3 = alloca %"struct.vector.Vec<%struct.Expression>"
	%v4 = alloca i8
	%v5 = alloca %struct.Stmt
	%v6 = alloca %"struct.vector.Vec<ui16>"
	%v7 = alloca %"struct.vector.Vec<%struct.Argument>"
	%v8 = alloca i1
	%v9 = alloca %struct.Type
	%v10 = alloca %"struct.vector.Vec<%struct.Stmt>"
	%v11 = alloca %struct.Stmt
	%v12 = alloca %struct.Stmt
	%v13 = alloca %"struct.vector.Vec<%struct.Stmt>"
	%v14 = alloca %struct.Stmt
	%v15 = alloca %struct.Type
	%v16 = alloca i1
	%v17 = alloca %"struct.vector.Vec<%struct.EnumField>"
	%v18 = alloca %struct.Stmt
	%v19 = alloca %"struct.vector.Vec<ui16>"
	%v20 = alloca %"struct.vector.Vec<%struct.Argument>"
	%v21 = alloca %struct.Stmt
	%v22 = alloca %"struct.vector.Vec<%struct.Stmt>"
	%v23 = alloca i32
	%v24 = alloca %struct.Type
	%v25 = alloca i1
	%v26 = alloca %struct.Expression
	%v27 = alloca %struct.Expression
	%v28 = alloca %struct.Stmt
	%v29 = alloca i32
	%v30 = alloca %struct.string.String
	%tmp0 = icmp eq i32 %token_len, 0
	br i1 %tmp0, label %then0, label %endif0
then0:
	br label %func_exit
endif0:
	store i32 0, i32* %v0
	store i32 4294967295, i32* %v1
	br label %loop_start1
loop_start1:
	%tmp1 = load i32, i32* %v0
	%tmp2 = icmp ult i32 %tmp1, %token_len
	br i1 %tmp2, label %endif2, label %else2
else2:
	br label %loop_body1_exit
endif2:
	%tmp3 = load i32, i32* %v0
	%tmp4 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp3
	%tmp5 = load i8, i8* %tmp4
	%tmp6 = call i1 @is_modifier(i8 %tmp5)
	br i1 %tmp6, label %then3, label %endif3
then3:
	%tmp7 = load i32, i32* %v1
	%tmp8 = icmp eq i32 %tmp7, 4294967295
	br i1 %tmp8, label %then4, label %endif4
then4:
	%tmp9 = load i32, i32* %v0
	store i32 %tmp9, i32* %v1
	br label %endif4
endif4:
	%tmp10 = load i32, i32* %v0
	%tmp11 = add i32 %tmp10, 1
	store i32 %tmp11, i32* %v0
	br label %loop_body1
endif3:
	%tmp12 = icmp eq i8 %tmp5, 14
	br i1 %tmp12, label %then5, label %endif5
then5:
	store i32 4294967295, i32* %v1
	%tmp13 = load i32, i32* %v0
	%tmp14 = add i32 %tmp13, 1
	store i32 %tmp14, i32* %v0
	store i1 false, i1* %v2
	%tmp15 = load i32, i32* %v0
	%tmp16 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp15
	%tmp17 = load i8, i8* %tmp16
	%tmp18 = icmp eq i8 %tmp17, 4
	br i1 %tmp18, label %then6, label %endif6
then6:
	store i1 true, i1* %v2
	%tmp19 = load i32, i32* %v0
	%tmp20 = add i32 %tmp19, 1
	store i32 %tmp20, i32* %v0
	br label %endif6
endif6:
	%tmp21 = load i32, i32* %v0
	%tmp22 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp21
	%tmp23 = load i8, i8* %tmp22
	%tmp24 = icmp ne i8 %tmp23, 65
	br i1 %tmp24, label %then7, label %endif7
then7:
	call void @process.throw(i8* @.str.237)
	br label %endif7
endif7:
	%tmp25 = load i32, i32* %v0
	%tmp26 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp25
	%tmp27 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp26, i32 0, i32 1
	%tmp28 = load i16, i16* %tmp27
	%tmp29 = load i32, i32* %v0
	%tmp30 = add i32 %tmp29, 1
	store i32 %tmp30, i32* %v0
	%tmp31 = call %"struct.vector.Vec<%struct.Expression>" @"vector.new<%struct.Expression>"()
	store %"struct.vector.Vec<%struct.Expression>" %tmp31, %"struct.vector.Vec<%struct.Expression>"* %v3
	%tmp32 = load i32, i32* %v0
	%tmp33 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp32
	%tmp34 = load i8, i8* %tmp33
	%tmp35 = icmp eq i8 %tmp34, 0
	br i1 %tmp35, label %then8, label %endif8
then8:
	%tmp36 = load i32, i32* %v0
	%tmp37 = add i32 %tmp36, 1
	store i32 %tmp37, i32* %v0
	%tmp38 = call %"struct.vector.Vec<%struct.Expression>" @parse_expression_comma(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	store %"struct.vector.Vec<%struct.Expression>" %tmp38, %"struct.vector.Vec<%struct.Expression>"* %v3
	call void @expect(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 1, i8* @.str.238)
	br label %endif8
endif8:
	store i8 0, i8* %v4
	%tmp39 = load i1, i1* %v2
	br i1 %tmp39, label %then9, label %endif9
then9:
	call void @expect(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 5, i8* @.str.239)
	store i8 20, i8* %v4
	br label %endif9
endif9:
	%tmp40 = call i8* @mem.malloc(i64 24)
	store i16 %tmp28, i16* %tmp40
	%tmp41 = getelementptr inbounds %struct.HintNode, %struct.HintNode* %tmp40, i32 0, i32 1
	%tmp42 = load %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Expression>"* %v3
	store %"struct.vector.Vec<%struct.Expression>" %tmp42, %"struct.vector.Vec<%struct.Expression>"* %tmp41
	%tmp43 = load i8, i8* %v4
	store i8 %tmp43, i8* %v5
	%tmp44 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %v5, i32 0, i32 1
	store i8* %tmp40, i8** %tmp44
	%tmp45 = load %struct.Stmt, %struct.Stmt* %v5
	call void @"vector.push<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %statement_vector, %struct.Stmt %tmp45)
	br label %loop_body1
; Variable stmt is out.
; Variable exprs is out.
endif5:
	%tmp46 = icmp eq i8 %tmp5, 41
	br i1 %tmp46, label %then10, label %endif10
then10:
	%tmp47 = load i32, i32* %v0
	%tmp48 = load i32, i32* %v1
	%tmp49 = call i8 @get_flags(%struct.TokenData* %token_array, i32 %tmp47, i32 %tmp48)
	store i32 4294967295, i32* %v1
	%tmp50 = load i32, i32* %v0
	%tmp51 = add i32 %tmp50, 1
	store i32 %tmp51, i32* %v0
	%tmp52 = load i32, i32* %v0
	%tmp53 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp52
	%tmp54 = load i8, i8* %tmp53
	%tmp55 = icmp ne i8 %tmp54, 65
	br i1 %tmp55, label %then11, label %endif11
then11:
	call void @process.throw(i8* @.str.240)
	br label %endif11
endif11:
	%tmp56 = load i32, i32* %v0
	%tmp57 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp56
	%tmp58 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp57, i32 0, i32 1
	%tmp59 = load i16, i16* %tmp58
	%tmp60 = load i32, i32* %v0
	%tmp61 = add i32 %tmp60, 1
	store i32 %tmp61, i32* %v0
	%tmp62 = load i32, i32* %v0
	%tmp63 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp62
	%tmp64 = load i8, i8* %tmp63
	%tmp65 = icmp ne i8 %tmp64, 0
	br i1 %tmp65, label %logic_rhs_12, label %logic_end_12
logic_rhs_12:
	%tmp66 = load i32, i32* %v0
	%tmp67 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp66
	%tmp68 = load i8, i8* %tmp67
	%tmp69 = icmp ne i8 %tmp68, 28
	br label %logic_end_12
logic_end_12:
	%tmp70 = phi i1 [%tmp65, %endif11], [%tmp69, %logic_rhs_12]
	br i1 %tmp70, label %then13, label %endif13
then13:
	call void @process.throw(i8* @.str.241)
	br label %endif13
endif13:
	%tmp71 = call %"struct.vector.Vec<ui16>" @"vector.new<ui16>"()
	store %"struct.vector.Vec<ui16>" %tmp71, %"struct.vector.Vec<ui16>"* %v6
	%tmp72 = load i32, i32* %v0
	%tmp73 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp72
	%tmp74 = load i8, i8* %tmp73
	%tmp75 = icmp eq i8 %tmp74, 28
	br i1 %tmp75, label %then14, label %endif14
then14:
	%tmp76 = load i32, i32* %v0
	%tmp77 = add i32 %tmp76, 1
	store i32 %tmp77, i32* %v0
	br label %loop_start15
loop_start15:
	%tmp78 = load i32, i32* %v0
	%tmp79 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp78
	%tmp80 = load i8, i8* %tmp79
	%tmp81 = icmp ne i8 %tmp80, 26
	br i1 %tmp81, label %endif16, label %else16
else16:
	br label %loop_body15_exit
endif16:
	%tmp82 = load i32, i32* %v0
	%tmp83 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp82
	%tmp84 = load i8, i8* %tmp83
	%tmp85 = icmp eq i8 %tmp84, 65
	br i1 %tmp85, label %then17, label %else17
then17:
	%tmp86 = load i32, i32* %v0
	%tmp87 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp86
	%tmp88 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp87, i32 0, i32 1
	%tmp89 = load i16, i16* %tmp88
	call void @"vector.push<ui16>"(%"struct.vector.Vec<ui16>"* %v6, i16 %tmp89)
	br label %endif17
else17:
	call void @process.throw(i8* @.str.242)
	br label %endif17
endif17:
	%tmp90 = load i32, i32* %v0
	%tmp91 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp90
	%tmp92 = load i8, i8* %tmp91
	%tmp93 = icmp eq i8 %tmp92, 9
	br i1 %tmp93, label %then18, label %endif18
then18:
	%tmp94 = load i32, i32* %v0
	%tmp95 = add i32 %tmp94, 1
	store i32 %tmp95, i32* %v0
	br label %endif18
endif18:
	%tmp96 = load i32, i32* %v0
	%tmp97 = add i32 %tmp96, 1
	store i32 %tmp97, i32* %v0
	br label %loop_start15
loop_body15_exit:
	%tmp98 = load i32, i32* %v0
	%tmp99 = add i32 %tmp98, 1
	store i32 %tmp99, i32* %v0
	br label %endif14
endif14:
	%tmp100 = load i32, i32* %v0
	%tmp101 = add i32 %tmp100, 1
	store i32 %tmp101, i32* %v0
	%tmp102 = call %"struct.vector.Vec<%struct.Argument>" @parse_argument_comma(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	store %"struct.vector.Vec<%struct.Argument>" %tmp102, %"struct.vector.Vec<%struct.Argument>"* %v7
	%tmp103 = load i32, i32* %v0
	%tmp104 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp103
	%tmp105 = load i8, i8* %tmp104
	%tmp106 = icmp ne i8 %tmp105, 1
	br i1 %tmp106, label %then19, label %endif19
then19:
	call void @process.throw(i8* @.str.206)
	br label %endif19
endif19:
	%tmp107 = load i32, i32* %v0
	%tmp108 = add i32 %tmp107, 1
	store i32 %tmp108, i32* %v0
	store i1 false, i1* %v8
	%tmp109 = load i32, i32* %v0
	%tmp110 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp109
	%tmp111 = load i8, i8* %tmp110
	%tmp112 = icmp eq i8 %tmp111, 6
	br i1 %tmp112, label %then20, label %endif20
then20:
	%tmp113 = load i32, i32* %v0
	%tmp114 = add i32 %tmp113, 1
	store i32 %tmp114, i32* %v0
	%tmp115 = call %struct.Type @parse_type(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	store %struct.Type %tmp115, %struct.Type* %v9
	store i1 true, i1* %v8
	br label %endif20
endif20:
	%tmp116 = call %"struct.vector.Vec<%struct.Stmt>" @"vector.new<%struct.Stmt>"()
	store %"struct.vector.Vec<%struct.Stmt>" %tmp116, %"struct.vector.Vec<%struct.Stmt>"* %v10
	%tmp117 = load i32, i32* %v0
	%tmp118 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp117
	%tmp119 = load i8, i8* %tmp118
	%tmp120 = icmp eq i8 %tmp119, 2
	br i1 %tmp120, label %then21, label %else21
then21:
	%tmp121 = load i32, i32* %v0
	%tmp122 = add i32 %tmp121, 1
	call void @skip_nested(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 2, i8 3)
	%tmp123 = load i32, i32* %v0
	%tmp124 = sub i32 %tmp123, 1
	%tmp125 = sub i32 %tmp124, %tmp122
	%tmp126 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp122
	call void @parse_body(%struct.TokenData* %tmp126, i32 %tmp125, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %"struct.vector.Vec<%struct.Stmt>"* %v10)
	br label %endif21
else21:
	%tmp127 = load i32, i32* %v0
	%tmp128 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp127
	%tmp129 = load i8, i8* %tmp128
	%tmp130 = icmp eq i8 %tmp129, 13
	br i1 %tmp130, label %then22, label %else22
then22:
	%tmp131 = load i32, i32* %v0
	%tmp132 = add i32 %tmp131, 1
	store i32 %tmp132, i32* %v0
	%tmp133 = call i8* @mem.malloc(i64 24)
	%tmp134 = getelementptr inbounds %struct.ReturnNode, %struct.ReturnNode* %tmp133, i32 0, i32 1
	%tmp135 = call %struct.Expression @parse_expression(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	store %struct.Expression %tmp135, %struct.Expression* %tmp134
	call void @expect(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 8, i8* @.str.243)
	store i8 10, i8* %v11
	%tmp136 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %v11, i32 0, i32 1
	store i8* %tmp133, i8** %tmp136
	%tmp137 = load %struct.Stmt, %struct.Stmt* %v11
	call void @"vector.push<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %v10, %struct.Stmt %tmp137)
; Variable stmt is out.
	br label %endif22
else22:
	%tmp138 = load i32, i32* %v0
	%tmp139 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp138
	%tmp140 = load i8, i8* %tmp139
	%tmp141 = icmp eq i8 %tmp140, 8
	br i1 %tmp141, label %then23, label %endif23
then23:
	%tmp142 = load i32, i32* %v0
	%tmp143 = add i32 %tmp142, 1
	store i32 %tmp143, i32* %v0
	br label %endif23
endif23:
	br label %endif22
endif22:
	br label %endif21
endif21:
	%tmp144 = call i8* @mem.malloc(i64 80)
	store i16 %tmp59, i16* %tmp144
	%tmp145 = getelementptr inbounds %struct.FnNode, %struct.FnNode* %tmp144, i32 0, i32 2
	%tmp146 = load %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %v7
	store %"struct.vector.Vec<%struct.Argument>" %tmp146, %"struct.vector.Vec<%struct.Argument>"* %tmp145
	%tmp147 = getelementptr inbounds %struct.FnNode, %struct.FnNode* %tmp144, i32 0, i32 3
	%tmp148 = load i1, i1* %v8
	store i1 %tmp148, i1* %tmp147
	%tmp149 = getelementptr inbounds %struct.FnNode, %struct.FnNode* %tmp144, i32 0, i32 4
	%tmp150 = load %struct.Type, %struct.Type* %v9
	store %struct.Type %tmp150, %struct.Type* %tmp149
	%tmp151 = getelementptr inbounds %struct.FnNode, %struct.FnNode* %tmp144, i32 0, i32 5
	%tmp152 = load %"struct.vector.Vec<ui16>", %"struct.vector.Vec<ui16>"* %v6
	store %"struct.vector.Vec<ui16>" %tmp152, %"struct.vector.Vec<ui16>"* %tmp151
	%tmp153 = getelementptr inbounds %struct.FnNode, %struct.FnNode* %tmp144, i32 0, i32 6
	%tmp154 = load %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %v10
	store %"struct.vector.Vec<%struct.Stmt>" %tmp154, %"struct.vector.Vec<%struct.Stmt>"* %tmp153
	%tmp155 = getelementptr inbounds %struct.FnNode, %struct.FnNode* %tmp144, i32 0, i32 1
	store i8 %tmp49, i8* %tmp155
	store i8 11, i8* %v12
	%tmp156 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %v12, i32 0, i32 1
	store i8* %tmp144, i8** %tmp156
	%tmp157 = load %struct.Stmt, %struct.Stmt* %v12
	call void @"vector.push<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %statement_vector, %struct.Stmt %tmp157)
	br label %loop_body1
; Variable stmt is out.
; Variable nodes is out.
; Variable ret_type is out.
; Variable args is out.
; Variable generic is out.
endif10:
	%tmp158 = icmp eq i8 %tmp5, 61
	br i1 %tmp158, label %then24, label %endif24
then24:
	%tmp159 = load i32, i32* %v0
	%tmp160 = load i32, i32* %v1
	%tmp161 = call i8 @get_flags(%struct.TokenData* %token_array, i32 %tmp159, i32 %tmp160)
	store i32 4294967295, i32* %v1
	%tmp162 = load i32, i32* %v0
	%tmp163 = add i32 %tmp162, 1
	store i32 %tmp163, i32* %v0
	%tmp164 = load i32, i32* %v0
	%tmp165 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp164
	%tmp166 = load i8, i8* %tmp165
	%tmp167 = icmp ne i8 %tmp166, 65
	br i1 %tmp167, label %then25, label %endif25
then25:
	call void @process.throw(i8* @.str.244)
	br label %endif25
endif25:
	%tmp168 = load i32, i32* %v0
	%tmp169 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp168
	%tmp170 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp169, i32 0, i32 1
	%tmp171 = load i16, i16* %tmp170
	%tmp172 = load i32, i32* %v0
	%tmp173 = add i32 %tmp172, 1
	store i32 %tmp173, i32* %v0
	%tmp174 = call %"struct.vector.Vec<%struct.Stmt>" @"vector.new<%struct.Stmt>"()
	store %"struct.vector.Vec<%struct.Stmt>" %tmp174, %"struct.vector.Vec<%struct.Stmt>"* %v13
	%tmp175 = load i32, i32* %v0
	%tmp176 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp175
	%tmp177 = load i8, i8* %tmp176
	%tmp178 = icmp eq i8 %tmp177, 2
	br i1 %tmp178, label %then26, label %else26
then26:
	%tmp179 = load i32, i32* %v0
	%tmp180 = add i32 %tmp179, 1
	call void @skip_nested(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 2, i8 3)
	%tmp181 = load i32, i32* %v0
	%tmp182 = sub i32 %tmp181, 1
	%tmp183 = sub i32 %tmp182, %tmp180
	%tmp184 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp180
	call void @parse(%struct.TokenData* %tmp184, i32 %tmp183, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %"struct.vector.Vec<%struct.Stmt>"* %v13)
	br label %endif26
else26:
	call void @process.throw(i8* @.str.245)
	br label %endif26
endif26:
	%tmp185 = call i8* @mem.malloc(i64 24)
	store i16 %tmp171, i16* %tmp185
	%tmp186 = getelementptr inbounds %struct.NamespaceNode, %struct.NamespaceNode* %tmp185, i32 0, i32 1
	%tmp187 = load %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %v13
	store %"struct.vector.Vec<%struct.Stmt>" %tmp187, %"struct.vector.Vec<%struct.Stmt>"* %tmp186
	store i8 14, i8* %v14
	%tmp188 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %v14, i32 0, i32 1
	store i8* %tmp185, i8** %tmp188
	%tmp189 = load %struct.Stmt, %struct.Stmt* %v14
	call void @"vector.push<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %statement_vector, %struct.Stmt %tmp189)
	br label %loop_body1
; Variable stmt is out.
; Variable nodes is out.
endif24:
	%tmp190 = icmp eq i8 %tmp5, 50
	br i1 %tmp190, label %then27, label %endif27
then27:
	%tmp191 = load i32, i32* %v0
	%tmp192 = load i32, i32* %v1
	%tmp193 = call i8 @get_flags(%struct.TokenData* %token_array, i32 %tmp191, i32 %tmp192)
	store i32 4294967295, i32* %v1
	%tmp194 = load i32, i32* %v0
	%tmp195 = add i32 %tmp194, 1
	store i32 %tmp195, i32* %v0
	%tmp196 = load i32, i32* %v0
	%tmp197 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp196
	%tmp198 = load i8, i8* %tmp197
	%tmp199 = icmp ne i8 %tmp198, 65
	br i1 %tmp199, label %then28, label %endif28
then28:
	call void @process.throw(i8* @.str.246)
	br label %endif28
endif28:
	%tmp200 = load i32, i32* %v0
	%tmp201 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp200
	%tmp202 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp201, i32 0, i32 1
	%tmp203 = load i16, i16* %tmp202
	%tmp204 = load i32, i32* %v0
	%tmp205 = add i32 %tmp204, 1
	store i32 %tmp205, i32* %v0
	store i1 false, i1* %v16
	%tmp206 = load i32, i32* %v0
	%tmp207 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp206
	%tmp208 = load i8, i8* %tmp207
	%tmp209 = icmp eq i8 %tmp208, 6
	br i1 %tmp209, label %then29, label %endif29
then29:
	%tmp210 = load i32, i32* %v0
	%tmp211 = add i32 %tmp210, 1
	store i32 %tmp211, i32* %v0
	%tmp212 = call %struct.Type @parse_type(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	store %struct.Type %tmp212, %struct.Type* %v15
	store i1 true, i1* %v16
	br label %endif29
endif29:
	%tmp213 = call %"struct.vector.Vec<%struct.EnumField>" @"vector.new<%struct.EnumField>"()
	store %"struct.vector.Vec<%struct.EnumField>" %tmp213, %"struct.vector.Vec<%struct.EnumField>"* %v17
	%tmp214 = load i32, i32* %v0
	%tmp215 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp214
	%tmp216 = load i8, i8* %tmp215
	%tmp217 = icmp eq i8 %tmp216, 2
	br i1 %tmp217, label %then30, label %else30
then30:
	%tmp218 = call %"struct.vector.Vec<%struct.EnumField>" @parse_enum_fields(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	store %"struct.vector.Vec<%struct.EnumField>" %tmp218, %"struct.vector.Vec<%struct.EnumField>"* %v17
	br label %endif30
else30:
	call void @process.throw(i8* @.str.215)
	br label %endif30
endif30:
	%tmp219 = call i8* @mem.malloc(i64 40)
	store i16 %tmp203, i16* %tmp219
	%tmp220 = getelementptr inbounds %struct.EnumNode, %struct.EnumNode* %tmp219, i32 0, i32 2
	%tmp221 = load i1, i1* %v16
	store i1 %tmp221, i1* %tmp220
	%tmp222 = getelementptr inbounds %struct.EnumNode, %struct.EnumNode* %tmp219, i32 0, i32 3
	%tmp223 = load %struct.Type, %struct.Type* %v15
	store %struct.Type %tmp223, %struct.Type* %tmp222
	%tmp224 = getelementptr inbounds %struct.EnumNode, %struct.EnumNode* %tmp219, i32 0, i32 4
	%tmp225 = load %"struct.vector.Vec<%struct.EnumField>", %"struct.vector.Vec<%struct.EnumField>"* %v17
	store %"struct.vector.Vec<%struct.EnumField>" %tmp225, %"struct.vector.Vec<%struct.EnumField>"* %tmp224
	%tmp226 = getelementptr inbounds %struct.EnumNode, %struct.EnumNode* %tmp219, i32 0, i32 1
	store i8 %tmp193, i8* %tmp226
	store i8 13, i8* %v18
	%tmp227 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %v18, i32 0, i32 1
	store i8* %tmp219, i8** %tmp227
	%tmp228 = load %struct.Stmt, %struct.Stmt* %v18
	call void @"vector.push<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %statement_vector, %struct.Stmt %tmp228)
	br label %loop_body1
; Variable stmt is out.
; Variable fields is out.
; Variable enum_type is out.
endif27:
	%tmp229 = icmp eq i8 %tmp5, 49
	br i1 %tmp229, label %then31, label %endif31
then31:
	%tmp230 = load i32, i32* %v0
	%tmp231 = load i32, i32* %v1
	%tmp232 = call i8 @get_flags(%struct.TokenData* %token_array, i32 %tmp230, i32 %tmp231)
	store i32 4294967295, i32* %v1
	%tmp233 = load i32, i32* %v0
	%tmp234 = add i32 %tmp233, 1
	store i32 %tmp234, i32* %v0
	%tmp235 = load i32, i32* %v0
	%tmp236 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp235
	%tmp237 = load i8, i8* %tmp236
	%tmp238 = icmp ne i8 %tmp237, 65
	br i1 %tmp238, label %then32, label %endif32
then32:
	call void @process.throw(i8* @.str.247)
	br label %endif32
endif32:
	%tmp239 = load i32, i32* %v0
	%tmp240 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp239
	%tmp241 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp240, i32 0, i32 1
	%tmp242 = load i16, i16* %tmp241
	%tmp243 = load i32, i32* %v0
	%tmp244 = add i32 %tmp243, 1
	store i32 %tmp244, i32* %v0
	%tmp245 = call %"struct.vector.Vec<ui16>" @"vector.new<ui16>"()
	store %"struct.vector.Vec<ui16>" %tmp245, %"struct.vector.Vec<ui16>"* %v19
	%tmp246 = load i32, i32* %v0
	%tmp247 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp246
	%tmp248 = load i8, i8* %tmp247
	%tmp249 = icmp eq i8 %tmp248, 28
	br i1 %tmp249, label %then33, label %endif33
then33:
	%tmp250 = call %"struct.vector.Vec<ui16>" @parse_generic_params(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	store %"struct.vector.Vec<ui16>" %tmp250, %"struct.vector.Vec<ui16>"* %v19
	br label %endif33
endif33:
	%tmp251 = call %"struct.vector.Vec<%struct.Argument>" @"vector.new<%struct.Argument>"()
	store %"struct.vector.Vec<%struct.Argument>" %tmp251, %"struct.vector.Vec<%struct.Argument>"* %v20
	%tmp252 = load i32, i32* %v0
	%tmp253 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp252
	%tmp254 = load i8, i8* %tmp253
	%tmp255 = icmp eq i8 %tmp254, 2
	br i1 %tmp255, label %then34, label %else34
then34:
	%tmp256 = call %"struct.vector.Vec<%struct.Argument>" @parse_struct_fields(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	store %"struct.vector.Vec<%struct.Argument>" %tmp256, %"struct.vector.Vec<%struct.Argument>"* %v20
	br label %endif34
else34:
	call void @process.throw(i8* @.str.188)
	br label %endif34
endif34:
	%tmp257 = call i8* @mem.malloc(i64 40)
	store i16 %tmp242, i16* %tmp257
	%tmp258 = getelementptr inbounds %struct.StructNode, %struct.StructNode* %tmp257, i32 0, i32 2
	%tmp259 = load %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %v20
	store %"struct.vector.Vec<%struct.Argument>" %tmp259, %"struct.vector.Vec<%struct.Argument>"* %tmp258
	%tmp260 = getelementptr inbounds %struct.StructNode, %struct.StructNode* %tmp257, i32 0, i32 3
	%tmp261 = load %"struct.vector.Vec<ui16>", %"struct.vector.Vec<ui16>"* %v19
	store %"struct.vector.Vec<ui16>" %tmp261, %"struct.vector.Vec<ui16>"* %tmp260
	%tmp262 = getelementptr inbounds %struct.StructNode, %struct.StructNode* %tmp257, i32 0, i32 1
	store i8 %tmp232, i8* %tmp262
	store i8 12, i8* %v21
	%tmp263 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %v21, i32 0, i32 1
	store i8* %tmp257, i8** %tmp263
	%tmp264 = load %struct.Stmt, %struct.Stmt* %v21
	call void @"vector.push<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %statement_vector, %struct.Stmt %tmp264)
	br label %loop_body1
; Variable stmt is out.
; Variable fields is out.
; Variable generics is out.
endif31:
	%tmp265 = load i32, i32* %v0
	%tmp266 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp265
	%tmp267 = load i8, i8* %tmp266
	%tmp268 = icmp eq i8 %tmp267, 2
	br i1 %tmp268, label %then35, label %endif35
then35:
	%tmp269 = load i32, i32* %v0
	%tmp270 = load i32, i32* %v1
	%tmp271 = call i8 @get_flags(%struct.TokenData* %token_array, i32 %tmp269, i32 %tmp270)
	store i32 4294967295, i32* %v1
	%tmp272 = load i32, i32* %v0
	call void @skip_nested(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 2, i8 3)
	%tmp273 = call %"struct.vector.Vec<%struct.Stmt>" @"vector.new<%struct.Stmt>"()
	store %"struct.vector.Vec<%struct.Stmt>" %tmp273, %"struct.vector.Vec<%struct.Stmt>"* %v22
	%tmp274 = load i32, i32* %v0
	%tmp275 = sub i32 %tmp274, 1
	%tmp276 = add i32 %tmp272, 1
	%tmp277 = sub i32 %tmp275, %tmp276
	%tmp278 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp272
	%tmp279 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp278, i32 1
	call void @parse(%struct.TokenData* %tmp279, i32 %tmp277, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %"struct.vector.Vec<%struct.Stmt>"* %v22)
	%tmp280 = getelementptr inbounds %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %v22, i32 0, i32 1
	%tmp281 = load i32, i32* %tmp280
	store i32 0, i32* %v23
	br label %loop_cond36
loop_cond36:
	%tmp282 = load i32, i32* %v23
	%tmp283 = getelementptr inbounds %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %v22, i32 0, i32 1
	%tmp284 = load i32, i32* %tmp283
	%tmp285 = icmp uge i32 %tmp282, %tmp284
	br i1 %tmp285, label %then37, label %endif37
then37:
	br label %loop_body36_exit
endif37:
	%tmp286 = load i32, i32* %v23
	%tmp287 = load %struct.Stmt*, %struct.Stmt** %v22
	%tmp288 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp287, i32 %tmp286
	%tmp289 = load i8, i8* %tmp288
	%tmp290 = icmp eq i8 %tmp289, 12
	br i1 %tmp290, label %then38, label %else38
then38:
	%tmp291 = load i32, i32* %v23
	%tmp292 = load %struct.Stmt*, %struct.Stmt** %v22
	%tmp293 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp292, i32 %tmp291
	%tmp294 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp293, i32 0, i32 1
	%tmp295 = load i8*, i8** %tmp294
	%tmp296 = getelementptr inbounds %struct.StructNode, %struct.StructNode* %tmp295, i32 0, i32 1
	%tmp297 = getelementptr inbounds %struct.StructNode, %struct.StructNode* %tmp295, i32 0, i32 1
	%tmp298 = load i8, i8* %tmp297
	%tmp299 = or i8 %tmp298, %tmp271
	store i8 %tmp299, i8* %tmp296
	br label %endif38
else38:
	%tmp300 = load i32, i32* %v23
	%tmp301 = load %struct.Stmt*, %struct.Stmt** %v22
	%tmp302 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp301, i32 %tmp300
	%tmp303 = load i8, i8* %tmp302
	%tmp304 = icmp eq i8 %tmp303, 11
	br i1 %tmp304, label %then39, label %else39
then39:
	%tmp305 = load i32, i32* %v23
	%tmp306 = load %struct.Stmt*, %struct.Stmt** %v22
	%tmp307 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp306, i32 %tmp305
	%tmp308 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp307, i32 0, i32 1
	%tmp309 = load i8*, i8** %tmp308
	%tmp310 = getelementptr inbounds %struct.FnNode, %struct.FnNode* %tmp309, i32 0, i32 1
	%tmp311 = getelementptr inbounds %struct.FnNode, %struct.FnNode* %tmp309, i32 0, i32 1
	%tmp312 = load i8, i8* %tmp311
	%tmp313 = or i8 %tmp312, %tmp271
	store i8 %tmp313, i8* %tmp310
	br label %endif39
else39:
	%tmp314 = load i32, i32* %v23
	%tmp315 = load %struct.Stmt*, %struct.Stmt** %v22
	%tmp316 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp315, i32 %tmp314
	%tmp317 = load i8, i8* %tmp316
	%tmp318 = icmp eq i8 %tmp317, 13
	br i1 %tmp318, label %then40, label %endif40
then40:
	%tmp319 = load i32, i32* %v23
	%tmp320 = load %struct.Stmt*, %struct.Stmt** %v22
	%tmp321 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp320, i32 %tmp319
	%tmp322 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp321, i32 0, i32 1
	%tmp323 = load i8*, i8** %tmp322
	%tmp324 = getelementptr inbounds %struct.EnumNode, %struct.EnumNode* %tmp323, i32 0, i32 1
	%tmp325 = getelementptr inbounds %struct.EnumNode, %struct.EnumNode* %tmp323, i32 0, i32 1
	%tmp326 = load i8, i8* %tmp325
	%tmp327 = or i8 %tmp326, %tmp271
	store i8 %tmp327, i8* %tmp324
	br label %endif40
endif40:
	br label %endif39
endif39:
	br label %endif38
endif38:
	%tmp328 = load i32, i32* %v23
	%tmp329 = load %struct.Stmt*, %struct.Stmt** %v22
	%tmp330 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp329, i32 %tmp328
	%tmp331 = load %struct.Stmt, %struct.Stmt* %tmp330
	call void @"vector.push<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %statement_vector, %struct.Stmt %tmp331)
	%tmp332 = load i32, i32* %v23
	%tmp333 = add i32 %tmp332, 1
	store i32 %tmp333, i32* %v23
	br label %loop_cond36
loop_body36_exit:
	br label %loop_body1
; Variable m is out.
endif35:
	%tmp334 = load i32, i32* %v1
	%tmp335 = icmp ne i32 %tmp334, 4294967295
	br i1 %tmp335, label %then41, label %endif41
then41:
	%tmp336 = load i32, i32* %v0
	%tmp337 = sub i32 %tmp336, 1
	%tmp338 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp337
	%tmp339 = load i8, i8* %tmp338
	%tmp340 = icmp eq i8 %tmp339, 38
	br i1 %tmp340, label %logic_end_42, label %logic_rhs_42
logic_rhs_42:
	%tmp341 = load i32, i32* %v0
	%tmp342 = sub i32 %tmp341, 1
	%tmp343 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp342
	%tmp344 = load i8, i8* %tmp343
	%tmp345 = icmp eq i8 %tmp344, 43
	br label %logic_end_42
logic_end_42:
	%tmp346 = phi i1 [%tmp340, %then41], [%tmp345, %logic_rhs_42]
	br i1 %tmp346, label %then43, label %endif43
then43:
	%tmp347 = load i32, i32* %v0
	%tmp348 = sub i32 %tmp347, 1
	%tmp349 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp348
	%tmp350 = load i8, i8* %tmp349
	%tmp351 = load i32, i32* %v0
	%tmp352 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp351
	%tmp353 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp352, i32 0, i32 1
	%tmp354 = load i16, i16* %tmp353
	call void @expect(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 65, i8* @.str.220)
	call void @expect(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 6, i8* @.str.221)
	%tmp355 = call %struct.Type @parse_type(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	store %struct.Type %tmp355, %struct.Type* %v24
	store i1 false, i1* %v25
	%tmp356 = load i32, i32* %v0
	%tmp357 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp356
	%tmp358 = load i8, i8* %tmp357
	%tmp359 = icmp eq i8 %tmp358, 15
	br i1 %tmp359, label %then44, label %endif44
then44:
	%tmp360 = load i32, i32* %v0
	%tmp361 = add i32 %tmp360, 1
	store i32 %tmp361, i32* %v0
	%tmp362 = call %struct.Expression @parse_expression(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	store %struct.Expression %tmp362, %struct.Expression* %v27
	%tmp363 = load %struct.Expression, %struct.Expression* %v27
	store %struct.Expression %tmp363, %struct.Expression* %v26
	store i1 true, i1* %v25
; Variable x is out.
	br label %endif44
endif44:
	call void @expect(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 8, i8* @.str.222)
	%tmp364 = call i8* @mem.malloc(i64 48)
	store i16 %tmp354, i16* %tmp364
	%tmp365 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp364, i32 0, i32 3
	%tmp366 = load %struct.Type, %struct.Type* %v24
	store %struct.Type %tmp366, %struct.Type* %tmp365
	%tmp367 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp364, i32 0, i32 1
	%tmp368 = load i1, i1* %v25
	store i1 %tmp368, i1* %tmp367
	%tmp369 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp364, i32 0, i32 2
	%tmp370 = load %struct.Expression, %struct.Expression* %v26
	store %struct.Expression %tmp370, %struct.Expression* %tmp369
	%tmp371 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp364, i32 0, i32 4
	store i8 0, i8* %tmp371
	%tmp372 = icmp eq i8 %tmp350, 38
	br i1 %tmp372, label %then45, label %else45
then45:
	%tmp373 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp364, i32 0, i32 4
	store i8 2, i8* %tmp373
	br label %endif45
else45:
	%tmp374 = icmp eq i8 %tmp350, 43
	br i1 %tmp374, label %then46, label %endif46
then46:
	%tmp375 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp364, i32 0, i32 4
	store i8 1, i8* %tmp375
	br label %endif46
endif46:
	br label %endif45
endif45:
	store i8 1, i8* %v28
	%tmp376 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %v28, i32 0, i32 1
	store i8* %tmp364, i8** %tmp376
	%tmp377 = load %struct.Stmt, %struct.Stmt* %v28
	call void @"vector.push<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %statement_vector, %struct.Stmt %tmp377)
	store i32 4294967295, i32* %v1
	br label %loop_body1
; Variable stmt is out.
; Variable expr is out.
; Variable type is out.
endif43:
	br label %endif41
endif41:
	store i32 0, i32* %v29
	br label %loop_cond47
loop_cond47:
	%tmp378 = load i32, i32* %v29
	%tmp379 = icmp uge i32 %tmp378, 3
	br i1 %tmp379, label %then48, label %endif48
then48:
	br label %loop_body47_exit
endif48:
	%tmp380 = load i32, i32* %v0
	%tmp381 = load i32, i32* %v29
	%tmp382 = add i32 %tmp380, %tmp381
	%tmp383 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp382
	%tmp384 = call %struct.string.String @token_type_to_string(%struct.TokenData* %tmp383, %"struct.vector.Vec<%struct.string.String>"* null)
	store %struct.string.String %tmp384, %struct.string.String* %v30
	call void @console.write_string(%struct.string.String* %v30)
	call void @console.write(i8* @.str.248, i32 5)
	call void @string.free(%struct.string.String* %v30)
	%tmp385 = load i32, i32* %v29
	%tmp386 = add i32 %tmp385, 1
	store i32 %tmp386, i32* %v29
	br label %loop_cond47
loop_body47_exit:
; Variable q is out.
	call void @process.throw(i8* @.str.249)
	br label %loop_body1
loop_body1:
	br label %loop_start1
loop_body1_exit:
	br label %func_exit
func_exit:
	ret void
}
define %struct.Scope @new_scope(){
	%v0 = alloca %struct.Scope
	%tmp0 = call %"struct.vector.Vec<%struct.Variable>" @"vector.new<%struct.Variable>"()
	%tmp1 = call %"struct.vector.Vec<ui32>" @"vector.new<ui32>"()
	store %"struct.vector.Vec<%struct.Variable>" %tmp0, %"struct.vector.Vec<%struct.Variable>"* %v0
	%tmp2 = getelementptr inbounds %struct.Scope, %struct.Scope* %v0, i32 0, i32 1
	store %"struct.vector.Vec<ui32>" %tmp1, %"struct.vector.Vec<ui32>"* %tmp2
	%tmp3 = load %struct.Scope, %struct.Scope* %v0
; Variable scope is out.
	ret %struct.Scope %tmp3
}
define void @lex(%struct.string.String* %data, %"struct.vector.Vec<%struct.TokenData>"* %token_vector, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector){
	%v0 = alloca i32
	%v1 = alloca i8
	%v2 = alloca i8
	%v3 = alloca i8
	%v4 = alloca i32
	%v5 = alloca i32
	%v6 = alloca i1
	%v7 = alloca i32
	%v8 = alloca i1
	%v9 = alloca i32
	%v10 = alloca i1
	%v11 = alloca i32
	%v12 = alloca i32
	%v13 = alloca i32
	%v14 = alloca i32
	%v15 = alloca i1
	%v16 = alloca i32
	%v17 = alloca i8
	%v18 = alloca %struct.TokenData
	store i32 0, i32* %v0
	br label %loop_start0
loop_start0:
	%tmp0 = load i32, i32* %v0
	%tmp1 = getelementptr inbounds %struct.string.String, %struct.string.String* %data, i32 0, i32 1
	%tmp2 = load i32, i32* %tmp1
	%tmp3 = icmp ult i32 %tmp0, %tmp2
	br i1 %tmp3, label %endif1, label %else1
else1:
	br label %loop_body0_exit
endif1:
	%tmp4 = load i32, i32* %v0
	%tmp5 = load i8*, i8** %data
	%tmp6 = getelementptr inbounds i8, i8* %tmp5, i32 %tmp4
	%tmp7 = load i8, i8* %tmp6
	store i8 %tmp7, i8* %v1
	%tmp8 = load i8, i8* %v1
	%tmp9 = icmp eq i8 %tmp8, 32
	br i1 %tmp9, label %logic_end_2, label %logic_rhs_2
logic_rhs_2:
	%tmp10 = load i8, i8* %v1
	br label %inl_entry3
inl_entry3:
	%tmp11 = icmp sge i8 %tmp10, 0
	br i1 %tmp11, label %logic_rhs_4, label %logic_end_4
logic_rhs_4:
	%tmp12 = icmp sle i8 %tmp10, 31
	br label %logic_end_4
logic_end_4:
	%tmp13 = phi i1 [%tmp11, %inl_entry3], [%tmp12, %logic_rhs_4]
	br i1 %tmp13, label %logic_end_5, label %logic_rhs_5
logic_rhs_5:
	%tmp14 = icmp eq i8 %tmp10, 127
	br label %logic_end_5
logic_end_5:
	%tmp15 = phi i1 [%tmp13, %logic_end_4], [%tmp14, %logic_rhs_5]
	br label %inl_exit3
inl_exit3:
	br label %logic_end_2
logic_end_2:
	%tmp16 = phi i1 [%tmp9, %endif1], [%tmp15, %inl_exit3]
	br i1 %tmp16, label %then6, label %endif6
then6:
	%tmp17 = load i32, i32* %v0
	%tmp18 = add i32 %tmp17, 1
	store i32 %tmp18, i32* %v0
	br label %loop_body0
endif6:
	store i8 0, i8* %v2
	%tmp19 = load i32, i32* %v0
	%tmp20 = add i32 %tmp19, 1
	%tmp21 = getelementptr inbounds %struct.string.String, %struct.string.String* %data, i32 0, i32 1
	%tmp22 = load i32, i32* %tmp21
	%tmp23 = icmp ult i32 %tmp20, %tmp22
	br i1 %tmp23, label %then7, label %else7
then7:
	%tmp24 = load i32, i32* %v0
	%tmp25 = add i32 %tmp24, 1
	%tmp26 = load i8*, i8** %data
	%tmp27 = getelementptr inbounds i8, i8* %tmp26, i32 %tmp25
	%tmp28 = load i8, i8* %tmp27
	store i8 %tmp28, i8* %v2
	br label %endif7
else7:
	store i8 0, i8* %v2
	br label %endif7
endif7:
	store i8 0, i8* %v3
	%tmp29 = load i32, i32* %v0
	%tmp30 = add i32 %tmp29, 2
	%tmp31 = getelementptr inbounds %struct.string.String, %struct.string.String* %data, i32 0, i32 1
	%tmp32 = load i32, i32* %tmp31
	%tmp33 = icmp ult i32 %tmp30, %tmp32
	br i1 %tmp33, label %then8, label %else8
then8:
	%tmp34 = load i32, i32* %v0
	%tmp35 = add i32 %tmp34, 2
	%tmp36 = load i8*, i8** %data
	%tmp37 = getelementptr inbounds i8, i8* %tmp36, i32 %tmp35
	%tmp38 = load i8, i8* %tmp37
	store i8 %tmp38, i8* %v3
	br label %endif8
else8:
	store i8 0, i8* %v3
	br label %endif8
endif8:
	%tmp39 = load i8, i8* %v1
	br label %inl_entry9
inl_entry9:
	%tmp40 = icmp sge i8 %tmp39, 97
	br i1 %tmp40, label %logic_rhs_10, label %logic_end_10
logic_rhs_10:
	%tmp41 = icmp sle i8 %tmp39, 122
	br label %logic_end_10
logic_end_10:
	%tmp42 = phi i1 [%tmp40, %inl_entry9], [%tmp41, %logic_rhs_10]
	br i1 %tmp42, label %logic_end_11, label %logic_rhs_11
logic_rhs_11:
	%tmp43 = icmp sge i8 %tmp39, 65
	br i1 %tmp43, label %logic_rhs_12, label %logic_end_12
logic_rhs_12:
	%tmp44 = icmp sle i8 %tmp39, 90
	br label %logic_end_12
logic_end_12:
	%tmp45 = phi i1 [%tmp43, %logic_rhs_11], [%tmp44, %logic_rhs_12]
	br label %logic_end_11
logic_end_11:
	%tmp46 = phi i1 [%tmp42, %logic_end_10], [%tmp45, %logic_end_12]
	br label %inl_exit9
inl_exit9:
	br i1 %tmp46, label %logic_end_13, label %logic_rhs_13
logic_rhs_13:
	%tmp47 = load i8, i8* %v1
	%tmp48 = icmp eq i8 %tmp47, 95
	br label %logic_end_13
logic_end_13:
	%tmp49 = phi i1 [%tmp46, %inl_exit9], [%tmp48, %logic_rhs_13]
	br i1 %tmp49, label %then14, label %else14
then14:
	%tmp50 = load i32, i32* %v0
	%tmp51 = add i32 %tmp50, 1
	store i32 %tmp51, i32* %v4
	br label %loop_start15
loop_start15:
	%tmp52 = load i32, i32* %v4
	%tmp53 = getelementptr inbounds %struct.string.String, %struct.string.String* %data, i32 0, i32 1
	%tmp54 = load i32, i32* %tmp53
	%tmp55 = icmp ult i32 %tmp52, %tmp54
	br i1 %tmp55, label %endif16, label %else16
else16:
	br label %loop_body15_exit
endif16:
	%tmp56 = load i32, i32* %v4
	%tmp57 = load i8*, i8** %data
	%tmp58 = getelementptr inbounds i8, i8* %tmp57, i32 %tmp56
	%tmp59 = load i8, i8* %tmp58
	br label %inl_entry18
inl_entry18:
	%tmp60 = icmp sge i8 %tmp59, 97
	br i1 %tmp60, label %logic_rhs_19, label %logic_end_19
logic_rhs_19:
	%tmp61 = icmp sle i8 %tmp59, 122
	br label %logic_end_19
logic_end_19:
	%tmp62 = phi i1 [%tmp60, %inl_entry18], [%tmp61, %logic_rhs_19]
	br i1 %tmp62, label %logic_end_20, label %logic_rhs_20
logic_rhs_20:
	%tmp63 = icmp sge i8 %tmp59, 65
	br i1 %tmp63, label %logic_rhs_21, label %logic_end_21
logic_rhs_21:
	%tmp64 = icmp sle i8 %tmp59, 90
	br label %logic_end_21
logic_end_21:
	%tmp65 = phi i1 [%tmp63, %logic_rhs_20], [%tmp64, %logic_rhs_21]
	br label %logic_end_20
logic_end_20:
	%tmp66 = phi i1 [%tmp62, %logic_end_19], [%tmp65, %logic_end_21]
	br label %inl_exit18
inl_exit18:
	br i1 %tmp66, label %logic_end_22, label %logic_rhs_22
logic_rhs_22:
	br label %inl_entry23
inl_entry23:
	%tmp67 = icmp sge i8 %tmp59, 48
	br i1 %tmp67, label %logic_rhs_24, label %logic_end_24
logic_rhs_24:
	%tmp68 = icmp sle i8 %tmp59, 57
	br label %logic_end_24
logic_end_24:
	%tmp69 = phi i1 [%tmp67, %inl_entry23], [%tmp68, %logic_rhs_24]
	br label %inl_exit23
inl_exit23:
	br label %logic_end_22
logic_end_22:
	%tmp70 = phi i1 [%tmp66, %inl_exit18], [%tmp69, %inl_exit23]
	br label %inl_exit17
inl_exit17:
	br i1 %tmp70, label %logic_end_25, label %logic_rhs_25
logic_rhs_25:
	%tmp71 = load i32, i32* %v4
	%tmp72 = load i8*, i8** %data
	%tmp73 = getelementptr inbounds i8, i8* %tmp72, i32 %tmp71
	%tmp74 = load i8, i8* %tmp73
	%tmp75 = icmp eq i8 %tmp74, 95
	br label %logic_end_25
logic_end_25:
	%tmp76 = phi i1 [%tmp70, %inl_exit17], [%tmp75, %logic_rhs_25]
	br i1 %tmp76, label %then26, label %endif26
then26:
	%tmp77 = load i32, i32* %v4
	%tmp78 = add i32 %tmp77, 1
	store i32 %tmp78, i32* %v4
	br label %loop_body15
endif26:
	br label %loop_body15_exit
loop_body15:
	br label %loop_start15
loop_body15_exit:
	%tmp79 = load i8*, i8** %data
	%tmp80 = load i32, i32* %v0
	%tmp81 = load i32, i32* %v4
	call void @handle_symbol(i8* %tmp79, i32 %tmp80, i32 %tmp81, %"struct.vector.Vec<%struct.TokenData>"* %token_vector, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector)
	%tmp82 = load i32, i32* %v4
	store i32 %tmp82, i32* %v0
	br label %loop_body0
else14:
	%tmp83 = load i8, i8* %v1
	br label %inl_entry27
inl_entry27:
	%tmp84 = icmp sge i8 %tmp83, 48
	br i1 %tmp84, label %logic_rhs_28, label %logic_end_28
logic_rhs_28:
	%tmp85 = icmp sle i8 %tmp83, 57
	br label %logic_end_28
logic_end_28:
	%tmp86 = phi i1 [%tmp84, %inl_entry27], [%tmp85, %logic_rhs_28]
	br label %inl_exit27
inl_exit27:
	br i1 %tmp86, label %logic_end_29, label %logic_rhs_29
logic_rhs_29:
	%tmp87 = load i8, i8* %v1
	%tmp88 = icmp eq i8 %tmp87, 45
	br i1 %tmp88, label %logic_rhs_30, label %logic_end_30
logic_rhs_30:
	%tmp89 = load i8, i8* %v2
	br label %inl_entry31
inl_entry31:
	%tmp90 = icmp sge i8 %tmp89, 48
	br i1 %tmp90, label %logic_rhs_32, label %logic_end_32
logic_rhs_32:
	%tmp91 = icmp sle i8 %tmp89, 57
	br label %logic_end_32
logic_end_32:
	%tmp92 = phi i1 [%tmp90, %inl_entry31], [%tmp91, %logic_rhs_32]
	br label %inl_exit31
inl_exit31:
	br label %logic_end_30
logic_end_30:
	%tmp93 = phi i1 [%tmp88, %logic_rhs_29], [%tmp92, %inl_exit31]
	br label %logic_end_29
logic_end_29:
	%tmp94 = phi i1 [%tmp86, %inl_exit27], [%tmp93, %logic_end_30]
	br i1 %tmp94, label %then33, label %else33
then33:
	%tmp95 = load i32, i32* %v0
	%tmp96 = add i32 %tmp95, 1
	store i32 %tmp96, i32* %v5
	%tmp97 = load i8, i8* %v1
	%tmp98 = icmp eq i8 %tmp97, 45
	br i1 %tmp98, label %then34, label %endif34
then34:
	%tmp99 = load i8, i8* %v2
	store i8 %tmp99, i8* %v1
	br label %endif34
endif34:
	%tmp100 = load i8, i8* %v1
	%tmp101 = icmp eq i8 %tmp100, 48
	br i1 %tmp101, label %then35, label %endif35
then35:
	%tmp102 = load i8, i8* %v2
	%tmp103 = icmp eq i8 %tmp102, 120
	br i1 %tmp103, label %then36, label %else36
then36:
	%tmp104 = load i32, i32* %v5
	%tmp105 = add i32 %tmp104, 1
	store i32 %tmp105, i32* %v5
	br label %endif36
else36:
	%tmp106 = load i8, i8* %v2
	%tmp107 = icmp eq i8 %tmp106, 98
	br i1 %tmp107, label %then37, label %endif37
then37:
	%tmp108 = load i32, i32* %v5
	%tmp109 = add i32 %tmp108, 1
	store i32 %tmp109, i32* %v5
	br label %endif37
endif37:
	br label %endif36
endif36:
	br label %endif35
endif35:
	store i1 false, i1* %v6
	br label %loop_start38
loop_start38:
	%tmp110 = load i32, i32* %v5
	%tmp111 = getelementptr inbounds %struct.string.String, %struct.string.String* %data, i32 0, i32 1
	%tmp112 = load i32, i32* %tmp111
	%tmp113 = icmp ult i32 %tmp110, %tmp112
	br i1 %tmp113, label %endif39, label %else39
else39:
	br label %loop_body38_exit
endif39:
	%tmp114 = load i32, i32* %v5
	%tmp115 = load i8*, i8** %data
	%tmp116 = getelementptr inbounds i8, i8* %tmp115, i32 %tmp114
	%tmp117 = load i8, i8* %tmp116
	br label %inl_entry41
inl_entry41:
	%tmp118 = icmp sge i8 %tmp117, 48
	br i1 %tmp118, label %logic_rhs_42, label %logic_end_42
logic_rhs_42:
	%tmp119 = icmp sle i8 %tmp117, 57
	br label %logic_end_42
logic_end_42:
	%tmp120 = phi i1 [%tmp118, %inl_entry41], [%tmp119, %logic_rhs_42]
	br label %inl_exit41
inl_exit41:
	br i1 %tmp120, label %logic_end_43, label %logic_rhs_43
logic_rhs_43:
	%tmp121 = icmp sge i8 %tmp117, 97
	br i1 %tmp121, label %logic_rhs_44, label %logic_end_44
logic_rhs_44:
	%tmp122 = icmp sle i8 %tmp117, 102
	br label %logic_end_44
logic_end_44:
	%tmp123 = phi i1 [%tmp121, %logic_rhs_43], [%tmp122, %logic_rhs_44]
	br label %logic_end_43
logic_end_43:
	%tmp124 = phi i1 [%tmp120, %inl_exit41], [%tmp123, %logic_end_44]
	br i1 %tmp124, label %logic_end_45, label %logic_rhs_45
logic_rhs_45:
	%tmp125 = icmp sge i8 %tmp117, 65
	br i1 %tmp125, label %logic_rhs_46, label %logic_end_46
logic_rhs_46:
	%tmp126 = icmp sle i8 %tmp117, 70
	br label %logic_end_46
logic_end_46:
	%tmp127 = phi i1 [%tmp125, %logic_rhs_45], [%tmp126, %logic_rhs_46]
	br label %logic_end_45
logic_end_45:
	%tmp128 = phi i1 [%tmp124, %logic_end_43], [%tmp127, %logic_end_46]
	br label %inl_exit40
inl_exit40:
	br i1 %tmp128, label %logic_end_47, label %logic_rhs_47
logic_rhs_47:
	%tmp129 = load i32, i32* %v5
	%tmp130 = load i8*, i8** %data
	%tmp131 = getelementptr inbounds i8, i8* %tmp130, i32 %tmp129
	%tmp132 = load i8, i8* %tmp131
	%tmp133 = icmp eq i8 %tmp132, 95
	br label %logic_end_47
logic_end_47:
	%tmp134 = phi i1 [%tmp128, %inl_exit40], [%tmp133, %logic_rhs_47]
	br i1 %tmp134, label %then48, label %endif48
then48:
	%tmp135 = load i32, i32* %v5
	%tmp136 = add i32 %tmp135, 1
	store i32 %tmp136, i32* %v5
	br label %loop_body38
endif48:
	%tmp137 = load i32, i32* %v5
	%tmp138 = load i8*, i8** %data
	%tmp139 = getelementptr inbounds i8, i8* %tmp138, i32 %tmp137
	%tmp140 = load i8, i8* %tmp139
	%tmp141 = icmp eq i8 %tmp140, 46
	br i1 %tmp141, label %then49, label %endif49
then49:
	%tmp142 = load i1, i1* %v6
	%tmp143 = xor i1 1, %tmp142
	br i1 %tmp143, label %then50, label %endif50
then50:
	store i1 true, i1* %v6
	%tmp144 = load i32, i32* %v5
	%tmp145 = add i32 %tmp144, 1
	store i32 %tmp145, i32* %v5
	br label %loop_body38
endif50:
	br label %endif49
endif49:
	br label %loop_body38_exit
loop_body38:
	br label %loop_start38
loop_body38_exit:
	%tmp146 = load i1, i1* %v6
	br i1 %tmp146, label %then51, label %else51
then51:
	%tmp147 = load i8*, i8** %data
	%tmp148 = load i32, i32* %v0
	%tmp149 = load i32, i32* %v5
	call void @handle_decimal_number(i8* %tmp147, i32 %tmp148, i32 %tmp149, %"struct.vector.Vec<%struct.TokenData>"* %token_vector, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector)
	br label %endif51
else51:
	%tmp150 = load i8*, i8** %data
	%tmp151 = load i32, i32* %v0
	%tmp152 = load i32, i32* %v5
	call void @handle_number(i8* %tmp150, i32 %tmp151, i32 %tmp152, %"struct.vector.Vec<%struct.TokenData>"* %token_vector, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector)
	br label %endif51
endif51:
	%tmp153 = load i32, i32* %v5
	store i32 %tmp153, i32* %v0
	br label %loop_body0
else33:
	%tmp154 = load i8, i8* %v1
	%tmp155 = icmp eq i8 %tmp154, 34
	br i1 %tmp155, label %then52, label %else52
then52:
	%tmp156 = load i32, i32* %v0
	%tmp157 = add i32 %tmp156, 1
	store i32 %tmp157, i32* %v7
	store i1 false, i1* %v8
	br label %loop_start53
loop_start53:
	%tmp158 = load i32, i32* %v7
	%tmp159 = getelementptr inbounds %struct.string.String, %struct.string.String* %data, i32 0, i32 1
	%tmp160 = load i32, i32* %tmp159
	%tmp161 = icmp ult i32 %tmp158, %tmp160
	br i1 %tmp161, label %endif54, label %else54
else54:
	br label %loop_body53_exit
endif54:
	%tmp162 = load i32, i32* %v7
	%tmp163 = load i8*, i8** %data
	%tmp164 = getelementptr inbounds i8, i8* %tmp163, i32 %tmp162
	%tmp165 = load i8, i8* %tmp164
	%tmp166 = icmp eq i8 %tmp165, 34
	br i1 %tmp166, label %then55, label %endif55
then55:
	%tmp167 = load i1, i1* %v8
	br i1 %tmp167, label %then56, label %else56
then56:
	store i1 false, i1* %v8
	%tmp168 = load i32, i32* %v7
	%tmp169 = add i32 %tmp168, 1
	store i32 %tmp169, i32* %v7
	br label %loop_body53
else56:
	%tmp170 = load i32, i32* %v7
	%tmp171 = add i32 %tmp170, 1
	store i32 %tmp171, i32* %v7
	br label %loop_body53_exit
	br label %endif55
endif55:
	%tmp172 = load i32, i32* %v7
	%tmp173 = load i8*, i8** %data
	%tmp174 = getelementptr inbounds i8, i8* %tmp173, i32 %tmp172
	%tmp175 = load i8, i8* %tmp174
	%tmp176 = icmp eq i8 %tmp175, 92
	br i1 %tmp176, label %then57, label %endif57
then57:
	%tmp177 = load i1, i1* %v8
	%tmp178 = xor i1 1, %tmp177
	store i1 %tmp178, i1* %v8
	%tmp179 = load i32, i32* %v7
	%tmp180 = add i32 %tmp179, 1
	store i32 %tmp180, i32* %v7
	br label %loop_body53
endif57:
	%tmp181 = load i1, i1* %v8
	br i1 %tmp181, label %then58, label %endif58
then58:
	store i1 false, i1* %v8
	br label %endif58
endif58:
	%tmp182 = load i32, i32* %v7
	%tmp183 = add i32 %tmp182, 1
	store i32 %tmp183, i32* %v7
	br label %loop_body53
loop_body53:
	br label %loop_start53
loop_body53_exit:
	%tmp184 = load i8*, i8** %data
	%tmp185 = load i32, i32* %v0
	%tmp186 = load i32, i32* %v7
	call void @handle_string(i8* %tmp184, i32 %tmp185, i32 %tmp186, %"struct.vector.Vec<%struct.TokenData>"* %token_vector, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector)
	%tmp187 = load i32, i32* %v7
	store i32 %tmp187, i32* %v0
	br label %loop_body0
else52:
	%tmp188 = load i8, i8* %v1
	%tmp189 = icmp eq i8 %tmp188, 39
	br i1 %tmp189, label %then59, label %else59
then59:
	%tmp190 = load i32, i32* %v0
	%tmp191 = add i32 %tmp190, 1
	store i32 %tmp191, i32* %v9
	store i1 false, i1* %v10
	br label %loop_start60
loop_start60:
	%tmp192 = load i32, i32* %v9
	%tmp193 = getelementptr inbounds %struct.string.String, %struct.string.String* %data, i32 0, i32 1
	%tmp194 = load i32, i32* %tmp193
	%tmp195 = icmp ult i32 %tmp192, %tmp194
	br i1 %tmp195, label %endif61, label %else61
else61:
	br label %loop_body60_exit
endif61:
	%tmp196 = load i32, i32* %v9
	%tmp197 = load i8*, i8** %data
	%tmp198 = getelementptr inbounds i8, i8* %tmp197, i32 %tmp196
	%tmp199 = load i8, i8* %tmp198
	%tmp200 = icmp eq i8 %tmp199, 39
	br i1 %tmp200, label %then62, label %endif62
then62:
	%tmp201 = load i1, i1* %v10
	br i1 %tmp201, label %then63, label %else63
then63:
	store i1 false, i1* %v10
	%tmp202 = load i32, i32* %v9
	%tmp203 = add i32 %tmp202, 1
	store i32 %tmp203, i32* %v9
	br label %loop_body60
else63:
	%tmp204 = load i32, i32* %v9
	%tmp205 = add i32 %tmp204, 1
	store i32 %tmp205, i32* %v9
	br label %loop_body60_exit
	br label %endif62
endif62:
	%tmp206 = load i32, i32* %v9
	%tmp207 = load i8*, i8** %data
	%tmp208 = getelementptr inbounds i8, i8* %tmp207, i32 %tmp206
	%tmp209 = load i8, i8* %tmp208
	%tmp210 = icmp eq i8 %tmp209, 92
	br i1 %tmp210, label %then64, label %endif64
then64:
	%tmp211 = load i1, i1* %v10
	%tmp212 = xor i1 1, %tmp211
	store i1 %tmp212, i1* %v10
	%tmp213 = load i32, i32* %v9
	%tmp214 = add i32 %tmp213, 1
	store i32 %tmp214, i32* %v9
	br label %loop_body60
endif64:
	%tmp215 = load i1, i1* %v10
	br i1 %tmp215, label %then65, label %endif65
then65:
	store i1 false, i1* %v10
	br label %endif65
endif65:
	%tmp216 = load i32, i32* %v9
	%tmp217 = add i32 %tmp216, 1
	store i32 %tmp217, i32* %v9
	br label %loop_body60
loop_body60:
	br label %loop_start60
loop_body60_exit:
	%tmp218 = load i8*, i8** %data
	%tmp219 = load i32, i32* %v0
	%tmp220 = load i32, i32* %v9
	call void @handle_char(i8* %tmp218, i32 %tmp219, i32 %tmp220, %"struct.vector.Vec<%struct.TokenData>"* %token_vector, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector)
	%tmp221 = load i32, i32* %v9
	store i32 %tmp221, i32* %v0
	br label %loop_body0
else59:
	%tmp222 = load i8, i8* %v1
	%tmp223 = icmp eq i8 %tmp222, 47
	br i1 %tmp223, label %logic_rhs_66, label %logic_end_66
logic_rhs_66:
	%tmp224 = load i8, i8* %v2
	%tmp225 = icmp eq i8 %tmp224, 47
	br label %logic_end_66
logic_end_66:
	%tmp226 = phi i1 [%tmp223, %else59], [%tmp225, %logic_rhs_66]
	br i1 %tmp226, label %then67, label %else67
then67:
	%tmp227 = load i32, i32* %v0
	%tmp228 = add i32 %tmp227, 2
	store i32 %tmp228, i32* %v11
	br label %loop_start68
loop_start68:
	%tmp229 = load i32, i32* %v11
	%tmp230 = getelementptr inbounds %struct.string.String, %struct.string.String* %data, i32 0, i32 1
	%tmp231 = load i32, i32* %tmp230
	%tmp232 = icmp ult i32 %tmp229, %tmp231
	br i1 %tmp232, label %endif69, label %else69
else69:
	br label %loop_body68_exit
endif69:
	%tmp233 = load i32, i32* %v11
	%tmp234 = load i8*, i8** %data
	%tmp235 = getelementptr inbounds i8, i8* %tmp234, i32 %tmp233
	%tmp236 = load i8, i8* %tmp235
	%tmp237 = icmp eq i8 %tmp236, 10
	br i1 %tmp237, label %then70, label %endif70
then70:
	%tmp238 = load i32, i32* %v11
	%tmp239 = add i32 %tmp238, 1
	store i32 %tmp239, i32* %v11
	br label %loop_body68_exit
endif70:
	%tmp240 = load i32, i32* %v11
	%tmp241 = add i32 %tmp240, 1
	store i32 %tmp241, i32* %v11
	br label %loop_start68
loop_body68_exit:
	%tmp242 = load i32, i32* %v11
	%tmp243 = load i32, i32* %v0
	%tmp244 = sub i32 %tmp242, %tmp243
	store i32 %tmp244, i32* %v12
	%tmp245 = load i32, i32* %v11
	store i32 %tmp245, i32* %v0
	br label %loop_body0
else67:
	%tmp246 = load i8, i8* %v1
	%tmp247 = icmp eq i8 %tmp246, 47
	br i1 %tmp247, label %logic_rhs_71, label %logic_end_71
logic_rhs_71:
	%tmp248 = load i8, i8* %v2
	%tmp249 = icmp eq i8 %tmp248, 42
	br label %logic_end_71
logic_end_71:
	%tmp250 = phi i1 [%tmp247, %else67], [%tmp249, %logic_rhs_71]
	br i1 %tmp250, label %then72, label %endif72
then72:
	%tmp251 = load i32, i32* %v0
	%tmp252 = add i32 %tmp251, 2
	store i32 %tmp252, i32* %v13
	store i32 1, i32* %v14
	store i1 false, i1* %v15
	br label %loop_start73
loop_start73:
	%tmp253 = load i32, i32* %v13
	%tmp254 = getelementptr inbounds %struct.string.String, %struct.string.String* %data, i32 0, i32 1
	%tmp255 = load i32, i32* %tmp254
	%tmp256 = icmp ult i32 %tmp253, %tmp255
	br i1 %tmp256, label %endif74, label %else74
else74:
	br label %loop_body73_exit
endif74:
	%tmp257 = load i32, i32* %v13
	%tmp258 = add i32 %tmp257, 1
	%tmp259 = getelementptr inbounds %struct.string.String, %struct.string.String* %data, i32 0, i32 1
	%tmp260 = load i32, i32* %tmp259
	%tmp261 = icmp ult i32 %tmp258, %tmp260
	br i1 %tmp261, label %then75, label %endif75
then75:
	%tmp262 = load i32, i32* %v13
	%tmp263 = load i8*, i8** %data
	%tmp264 = getelementptr inbounds i8, i8* %tmp263, i32 %tmp262
	%tmp265 = load i8, i8* %tmp264
	%tmp266 = icmp eq i8 %tmp265, 47
	br i1 %tmp266, label %logic_rhs_76, label %logic_end_76
logic_rhs_76:
	%tmp267 = load i32, i32* %v13
	%tmp268 = add i32 %tmp267, 1
	%tmp269 = load i8*, i8** %data
	%tmp270 = getelementptr inbounds i8, i8* %tmp269, i32 %tmp268
	%tmp271 = load i8, i8* %tmp270
	%tmp272 = icmp eq i8 %tmp271, 42
	br label %logic_end_76
logic_end_76:
	%tmp273 = phi i1 [%tmp266, %then75], [%tmp272, %logic_rhs_76]
	br i1 %tmp273, label %then77, label %endif77
then77:
	%tmp274 = load i32, i32* %v14
	%tmp275 = add i32 %tmp274, 1
	store i32 %tmp275, i32* %v14
	%tmp276 = load i32, i32* %v13
	%tmp277 = add i32 %tmp276, 2
	store i32 %tmp277, i32* %v13
	br label %loop_body73
endif77:
	%tmp278 = load i32, i32* %v13
	%tmp279 = load i8*, i8** %data
	%tmp280 = getelementptr inbounds i8, i8* %tmp279, i32 %tmp278
	%tmp281 = load i8, i8* %tmp280
	%tmp282 = icmp eq i8 %tmp281, 42
	br i1 %tmp282, label %logic_rhs_78, label %logic_end_78
logic_rhs_78:
	%tmp283 = load i32, i32* %v13
	%tmp284 = add i32 %tmp283, 1
	%tmp285 = load i8*, i8** %data
	%tmp286 = getelementptr inbounds i8, i8* %tmp285, i32 %tmp284
	%tmp287 = load i8, i8* %tmp286
	%tmp288 = icmp eq i8 %tmp287, 47
	br label %logic_end_78
logic_end_78:
	%tmp289 = phi i1 [%tmp282, %endif77], [%tmp288, %logic_rhs_78]
	br i1 %tmp289, label %then79, label %endif79
then79:
	%tmp290 = load i32, i32* %v14
	%tmp291 = sub i32 %tmp290, 1
	store i32 %tmp291, i32* %v14
	%tmp292 = load i32, i32* %v13
	%tmp293 = add i32 %tmp292, 2
	store i32 %tmp293, i32* %v13
	%tmp294 = load i32, i32* %v14
	%tmp295 = icmp eq i32 %tmp294, 0
	br i1 %tmp295, label %then80, label %endif80
then80:
	br label %loop_body73_exit
endif80:
	br label %loop_body73
endif79:
	br label %endif75
endif75:
	%tmp296 = load i32, i32* %v13
	%tmp297 = add i32 %tmp296, 1
	store i32 %tmp297, i32* %v13
	br label %loop_body73
loop_body73:
	br label %loop_start73
loop_body73_exit:
	%tmp298 = load i32, i32* %v13
	%tmp299 = load i32, i32* %v0
	%tmp300 = sub i32 %tmp298, %tmp299
	store i32 %tmp300, i32* %v16
	%tmp301 = load i32, i32* %v13
	store i32 %tmp301, i32* %v0
	br label %loop_body0
endif72:
	store i8 70, i8* %v17
	%tmp302 = load i8, i8* %v1
	%tmp303 = icmp eq i8 %tmp302, 35
	br i1 %tmp303, label %then81, label %else81
then81:
	store i8 14, i8* %v17
	%tmp304 = load i32, i32* %v0
	%tmp305 = add i32 %tmp304, 1
	store i32 %tmp305, i32* %v0
	br label %endif81
else81:
	%tmp306 = load i8, i8* %v1
	%tmp307 = icmp eq i8 %tmp306, 40
	br i1 %tmp307, label %then82, label %else82
then82:
	store i8 0, i8* %v17
	%tmp308 = load i32, i32* %v0
	%tmp309 = add i32 %tmp308, 1
	store i32 %tmp309, i32* %v0
	br label %endif82
else82:
	%tmp310 = load i8, i8* %v1
	%tmp311 = icmp eq i8 %tmp310, 41
	br i1 %tmp311, label %then83, label %else83
then83:
	store i8 1, i8* %v17
	%tmp312 = load i32, i32* %v0
	%tmp313 = add i32 %tmp312, 1
	store i32 %tmp313, i32* %v0
	br label %endif83
else83:
	%tmp314 = load i8, i8* %v1
	%tmp315 = icmp eq i8 %tmp314, 123
	br i1 %tmp315, label %then84, label %else84
then84:
	store i8 2, i8* %v17
	%tmp316 = load i32, i32* %v0
	%tmp317 = add i32 %tmp316, 1
	store i32 %tmp317, i32* %v0
	br label %endif84
else84:
	%tmp318 = load i8, i8* %v1
	%tmp319 = icmp eq i8 %tmp318, 125
	br i1 %tmp319, label %then85, label %else85
then85:
	store i8 3, i8* %v17
	%tmp320 = load i32, i32* %v0
	%tmp321 = add i32 %tmp320, 1
	store i32 %tmp321, i32* %v0
	br label %endif85
else85:
	%tmp322 = load i8, i8* %v1
	%tmp323 = icmp eq i8 %tmp322, 91
	br i1 %tmp323, label %then86, label %else86
then86:
	store i8 4, i8* %v17
	%tmp324 = load i32, i32* %v0
	%tmp325 = add i32 %tmp324, 1
	store i32 %tmp325, i32* %v0
	br label %endif86
else86:
	%tmp326 = load i8, i8* %v1
	%tmp327 = icmp eq i8 %tmp326, 93
	br i1 %tmp327, label %then87, label %else87
then87:
	store i8 5, i8* %v17
	%tmp328 = load i32, i32* %v0
	%tmp329 = add i32 %tmp328, 1
	store i32 %tmp329, i32* %v0
	br label %endif87
else87:
	%tmp330 = load i8, i8* %v1
	%tmp331 = icmp eq i8 %tmp330, 58
	br i1 %tmp331, label %then88, label %else88
then88:
	%tmp332 = load i8, i8* %v2
	%tmp333 = icmp eq i8 %tmp332, 58
	br i1 %tmp333, label %then89, label %else89
then89:
	store i8 7, i8* %v17
	%tmp334 = load i32, i32* %v0
	%tmp335 = add i32 %tmp334, 2
	store i32 %tmp335, i32* %v0
	br label %endif89
else89:
	store i8 6, i8* %v17
	%tmp336 = load i32, i32* %v0
	%tmp337 = add i32 %tmp336, 1
	store i32 %tmp337, i32* %v0
	br label %endif89
endif89:
	br label %endif88
else88:
	%tmp338 = load i8, i8* %v1
	%tmp339 = icmp eq i8 %tmp338, 61
	br i1 %tmp339, label %then90, label %else90
then90:
	%tmp340 = load i8, i8* %v2
	%tmp341 = icmp eq i8 %tmp340, 61
	br i1 %tmp341, label %then91, label %else91
then91:
	store i8 22, i8* %v17
	%tmp342 = load i32, i32* %v0
	%tmp343 = add i32 %tmp342, 2
	store i32 %tmp343, i32* %v0
	br label %endif91
else91:
	%tmp344 = load i8, i8* %v2
	%tmp345 = icmp eq i8 %tmp344, 62
	br i1 %tmp345, label %then92, label %else92
then92:
	store i8 13, i8* %v17
	%tmp346 = load i32, i32* %v0
	%tmp347 = add i32 %tmp346, 2
	store i32 %tmp347, i32* %v0
	br label %endif92
else92:
	store i8 15, i8* %v17
	%tmp348 = load i32, i32* %v0
	%tmp349 = add i32 %tmp348, 1
	store i32 %tmp349, i32* %v0
	br label %endif92
endif92:
	br label %endif91
endif91:
	br label %endif90
else90:
	%tmp350 = load i8, i8* %v1
	%tmp351 = icmp eq i8 %tmp350, 59
	br i1 %tmp351, label %then93, label %else93
then93:
	store i8 8, i8* %v17
	%tmp352 = load i32, i32* %v0
	%tmp353 = add i32 %tmp352, 1
	store i32 %tmp353, i32* %v0
	br label %endif93
else93:
	%tmp354 = load i8, i8* %v1
	%tmp355 = icmp eq i8 %tmp354, 44
	br i1 %tmp355, label %then94, label %else94
then94:
	store i8 9, i8* %v17
	%tmp356 = load i32, i32* %v0
	%tmp357 = add i32 %tmp356, 1
	store i32 %tmp357, i32* %v0
	br label %endif94
else94:
	%tmp358 = load i8, i8* %v1
	%tmp359 = icmp eq i8 %tmp358, 43
	br i1 %tmp359, label %then95, label %else95
then95:
	store i8 16, i8* %v17
	%tmp360 = load i32, i32* %v0
	%tmp361 = add i32 %tmp360, 1
	store i32 %tmp361, i32* %v0
	br label %endif95
else95:
	%tmp362 = load i8, i8* %v1
	%tmp363 = icmp eq i8 %tmp362, 45
	br i1 %tmp363, label %then96, label %else96
then96:
	store i8 17, i8* %v17
	%tmp364 = load i32, i32* %v0
	%tmp365 = add i32 %tmp364, 1
	store i32 %tmp365, i32* %v0
	br label %endif96
else96:
	%tmp366 = load i8, i8* %v1
	%tmp367 = icmp eq i8 %tmp366, 42
	br i1 %tmp367, label %then97, label %else97
then97:
	store i8 18, i8* %v17
	%tmp368 = load i32, i32* %v0
	%tmp369 = add i32 %tmp368, 1
	store i32 %tmp369, i32* %v0
	br label %endif97
else97:
	%tmp370 = load i8, i8* %v1
	%tmp371 = icmp eq i8 %tmp370, 47
	br i1 %tmp371, label %then98, label %else98
then98:
	store i8 19, i8* %v17
	%tmp372 = load i32, i32* %v0
	%tmp373 = add i32 %tmp372, 1
	store i32 %tmp373, i32* %v0
	br label %endif98
else98:
	%tmp374 = load i8, i8* %v1
	%tmp375 = icmp eq i8 %tmp374, 37
	br i1 %tmp375, label %then99, label %else99
then99:
	store i8 20, i8* %v17
	%tmp376 = load i32, i32* %v0
	%tmp377 = add i32 %tmp376, 1
	store i32 %tmp377, i32* %v0
	br label %endif99
else99:
	%tmp378 = load i8, i8* %v1
	%tmp379 = icmp eq i8 %tmp378, 33
	br i1 %tmp379, label %then100, label %else100
then100:
	%tmp380 = load i8, i8* %v2
	%tmp381 = icmp eq i8 %tmp380, 61
	br i1 %tmp381, label %then101, label %else101
then101:
	store i8 23, i8* %v17
	%tmp382 = load i32, i32* %v0
	%tmp383 = add i32 %tmp382, 2
	store i32 %tmp383, i32* %v0
	br label %endif101
else101:
	store i8 21, i8* %v17
	%tmp384 = load i32, i32* %v0
	%tmp385 = add i32 %tmp384, 1
	store i32 %tmp385, i32* %v0
	br label %endif101
endif101:
	br label %endif100
else100:
	%tmp386 = load i8, i8* %v1
	%tmp387 = icmp eq i8 %tmp386, 38
	br i1 %tmp387, label %then102, label %else102
then102:
	%tmp388 = load i8, i8* %v2
	%tmp389 = icmp eq i8 %tmp388, 38
	br i1 %tmp389, label %then103, label %else103
then103:
	store i8 25, i8* %v17
	%tmp390 = load i32, i32* %v0
	%tmp391 = add i32 %tmp390, 2
	store i32 %tmp391, i32* %v0
	br label %endif103
else103:
	store i8 32, i8* %v17
	%tmp392 = load i32, i32* %v0
	%tmp393 = add i32 %tmp392, 1
	store i32 %tmp393, i32* %v0
	br label %endif103
endif103:
	br label %endif102
else102:
	%tmp394 = load i8, i8* %v1
	%tmp395 = icmp eq i8 %tmp394, 124
	br i1 %tmp395, label %then104, label %else104
then104:
	%tmp396 = load i8, i8* %v2
	%tmp397 = icmp eq i8 %tmp396, 124
	br i1 %tmp397, label %then105, label %else105
then105:
	store i8 24, i8* %v17
	%tmp398 = load i32, i32* %v0
	%tmp399 = add i32 %tmp398, 2
	store i32 %tmp399, i32* %v0
	br label %endif105
else105:
	store i8 31, i8* %v17
	%tmp400 = load i32, i32* %v0
	%tmp401 = add i32 %tmp400, 1
	store i32 %tmp401, i32* %v0
	br label %endif105
endif105:
	br label %endif104
else104:
	%tmp402 = load i8, i8* %v1
	%tmp403 = icmp eq i8 %tmp402, 46
	br i1 %tmp403, label %then106, label %else106
then106:
	%tmp404 = load i8, i8* %v2
	%tmp405 = icmp eq i8 %tmp404, 46
	br i1 %tmp405, label %then107, label %else107
then107:
	%tmp406 = load i8, i8* %v3
	%tmp407 = icmp eq i8 %tmp406, 61
	br i1 %tmp407, label %then108, label %else108
then108:
	store i8 12, i8* %v17
	%tmp408 = load i32, i32* %v0
	%tmp409 = add i32 %tmp408, 3
	store i32 %tmp409, i32* %v0
	br label %endif108
else108:
	store i8 11, i8* %v17
	%tmp410 = load i32, i32* %v0
	%tmp411 = add i32 %tmp410, 2
	store i32 %tmp411, i32* %v0
	br label %endif108
endif108:
	br label %endif107
else107:
	store i8 10, i8* %v17
	%tmp412 = load i32, i32* %v0
	%tmp413 = add i32 %tmp412, 1
	store i32 %tmp413, i32* %v0
	br label %endif107
endif107:
	br label %endif106
else106:
	%tmp414 = load i8, i8* %v1
	%tmp415 = icmp eq i8 %tmp414, 60
	br i1 %tmp415, label %then109, label %else109
then109:
	%tmp416 = load i8, i8* %v2
	%tmp417 = icmp eq i8 %tmp416, 61
	br i1 %tmp417, label %then110, label %else110
then110:
	store i8 29, i8* %v17
	%tmp418 = load i32, i32* %v0
	%tmp419 = add i32 %tmp418, 2
	store i32 %tmp419, i32* %v0
	br label %endif110
else110:
	store i8 28, i8* %v17
	%tmp420 = load i32, i32* %v0
	%tmp421 = add i32 %tmp420, 1
	store i32 %tmp421, i32* %v0
	br label %endif110
endif110:
	br label %endif109
else109:
	%tmp422 = load i8, i8* %v1
	%tmp423 = icmp eq i8 %tmp422, 62
	br i1 %tmp423, label %then111, label %else111
then111:
	%tmp424 = load i8, i8* %v2
	%tmp425 = icmp eq i8 %tmp424, 61
	br i1 %tmp425, label %then112, label %else112
then112:
	store i8 27, i8* %v17
	%tmp426 = load i32, i32* %v0
	%tmp427 = add i32 %tmp426, 2
	store i32 %tmp427, i32* %v0
	br label %endif112
else112:
	store i8 26, i8* %v17
	%tmp428 = load i32, i32* %v0
	%tmp429 = add i32 %tmp428, 1
	store i32 %tmp429, i32* %v0
	br label %endif112
endif112:
	br label %endif111
else111:
	%tmp430 = load i8, i8* %v1
	%tmp431 = icmp eq i8 %tmp430, 94
	br i1 %tmp431, label %then113, label %else113
then113:
	store i8 33, i8* %v17
	%tmp432 = load i32, i32* %v0
	%tmp433 = add i32 %tmp432, 1
	store i32 %tmp433, i32* %v0
	br label %endif113
else113:
	%tmp434 = load i8, i8* %v1
	%tmp435 = icmp eq i8 %tmp434, 126
	br i1 %tmp435, label %then114, label %endif114
then114:
	store i8 30, i8* %v17
	%tmp436 = load i32, i32* %v0
	%tmp437 = add i32 %tmp436, 1
	store i32 %tmp437, i32* %v0
	br label %endif114
endif114:
	br label %endif113
endif113:
	br label %endif111
endif111:
	br label %endif109
endif109:
	br label %endif106
endif106:
	br label %endif104
endif104:
	br label %endif102
endif102:
	br label %endif100
endif100:
	br label %endif99
endif99:
	br label %endif98
endif98:
	br label %endif97
endif97:
	br label %endif96
endif96:
	br label %endif95
endif95:
	br label %endif94
endif94:
	br label %endif93
endif93:
	br label %endif90
endif90:
	br label %endif88
endif88:
	br label %endif87
endif87:
	br label %endif86
endif86:
	br label %endif85
endif85:
	br label %endif84
endif84:
	br label %endif83
endif83:
	br label %endif82
endif82:
	br label %endif81
endif81:
	%tmp438 = load i8, i8* %v17
	%tmp439 = icmp ne i8 %tmp438, 70
	br i1 %tmp439, label %then115, label %endif115
then115:
	%tmp440 = load i8, i8* %v17
	%tmp441 = load i32, i32* %v0
	store i8 %tmp440, i8* %v18
	%tmp442 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v18, i32 0, i32 1
	store i16 0, i16* %tmp442
	%tmp443 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v18, i32 0, i32 2
	store i32 %tmp441, i32* %tmp443
	%tmp444 = load %struct.TokenData, %struct.TokenData* %v18
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %token_vector, %struct.TokenData %tmp444)
	br label %loop_body0
; Variable temp is out.
endif115:
	call void @console.write(i8* @.str.250, i32 8)
	%tmp445 = load i32, i32* %v0
	%tmp446 = zext i32 %tmp445 to i64
	call void @console.println_i64(i64 %tmp446)
	%tmp447 = load i32, i32* %v0
	%tmp448 = load i8*, i8** %data
	%tmp449 = getelementptr inbounds i8, i8* %tmp448, i32 %tmp447
	%tmp450 = load i8, i8* %tmp449
	%tmp451 = sext i8 %tmp450 to i64
	call void @console.println_i64(i64 %tmp451)
	call void @process.throw(i8* @.str.251)
	br label %loop_body0
loop_body0:
	br label %loop_start0
loop_body0_exit:
	ret void
}
define i1 @is_prefix_operator(i8 %token){
entry:
	%tmp0 = icmp eq i8 %token, 17
	br i1 %tmp0, label %logic_end_0, label %logic_rhs_0
logic_rhs_0:
	%tmp1 = icmp eq i8 %token, 16
	br label %logic_end_0
logic_end_0:
	%tmp2 = phi i1 [%tmp0, %entry], [%tmp1, %logic_rhs_0]
	br i1 %tmp2, label %logic_end_1, label %logic_rhs_1
logic_rhs_1:
	%tmp3 = icmp eq i8 %token, 21
	br label %logic_end_1
logic_end_1:
	%tmp4 = phi i1 [%tmp2, %logic_end_0], [%tmp3, %logic_rhs_1]
	br i1 %tmp4, label %logic_end_2, label %logic_rhs_2
logic_rhs_2:
	%tmp5 = icmp eq i8 %token, 30
	br label %logic_end_2
logic_end_2:
	%tmp6 = phi i1 [%tmp4, %logic_end_1], [%tmp5, %logic_rhs_2]
	br i1 %tmp6, label %logic_end_3, label %logic_rhs_3
logic_rhs_3:
	%tmp7 = icmp eq i8 %token, 32
	br label %logic_end_3
logic_end_3:
	%tmp8 = phi i1 [%tmp6, %logic_end_2], [%tmp7, %logic_rhs_3]
	br i1 %tmp8, label %logic_end_4, label %logic_rhs_4
logic_rhs_4:
	%tmp9 = icmp eq i8 %token, 18
	br label %logic_end_4
logic_end_4:
	%tmp10 = phi i1 [%tmp8, %logic_end_3], [%tmp9, %logic_rhs_4]
	ret i1 %tmp10
}
define i1 @is_modifier(i8 %val){
entry:
	%tmp0 = icmp eq i8 %val, 36
	br i1 %tmp0, label %logic_end_0, label %logic_rhs_0
logic_rhs_0:
	%tmp1 = icmp eq i8 %val, 37
	br label %logic_end_0
logic_end_0:
	%tmp2 = phi i1 [%tmp0, %entry], [%tmp1, %logic_rhs_0]
	br i1 %tmp2, label %logic_end_1, label %logic_rhs_1
logic_rhs_1:
	%tmp3 = icmp eq i8 %val, 38
	br label %logic_end_1
logic_end_1:
	%tmp4 = phi i1 [%tmp2, %logic_end_0], [%tmp3, %logic_rhs_1]
	br i1 %tmp4, label %logic_end_2, label %logic_rhs_2
logic_rhs_2:
	%tmp5 = icmp eq i8 %val, 39
	br label %logic_end_2
logic_end_2:
	%tmp6 = phi i1 [%tmp4, %logic_end_1], [%tmp5, %logic_rhs_2]
	br i1 %tmp6, label %logic_end_3, label %logic_rhs_3
logic_rhs_3:
	%tmp7 = icmp eq i8 %val, 43
	br label %logic_end_3
logic_end_3:
	%tmp8 = phi i1 [%tmp6, %logic_end_2], [%tmp7, %logic_rhs_3]
	ret i1 %tmp8
}
define i1 @is_expression_starter(i8 %token){
entry:
	%tmp0 = icmp eq i8 %token, 65
	br i1 %tmp0, label %logic_end_0, label %logic_rhs_0
logic_rhs_0:
	%tmp1 = icmp eq i8 %token, 66
	br label %logic_end_0
logic_end_0:
	%tmp2 = phi i1 [%tmp0, %entry], [%tmp1, %logic_rhs_0]
	br i1 %tmp2, label %logic_end_1, label %logic_rhs_1
logic_rhs_1:
	%tmp3 = icmp eq i8 %token, 67
	br label %logic_end_1
logic_end_1:
	%tmp4 = phi i1 [%tmp2, %logic_end_0], [%tmp3, %logic_rhs_1]
	br i1 %tmp4, label %logic_end_2, label %logic_rhs_2
logic_rhs_2:
	%tmp5 = icmp eq i8 %token, 68
	br label %logic_end_2
logic_end_2:
	%tmp6 = phi i1 [%tmp4, %logic_end_1], [%tmp5, %logic_rhs_2]
	br i1 %tmp6, label %logic_end_3, label %logic_rhs_3
logic_rhs_3:
	%tmp7 = icmp eq i8 %token, 69
	br label %logic_end_3
logic_end_3:
	%tmp8 = phi i1 [%tmp6, %logic_end_2], [%tmp7, %logic_rhs_3]
	br i1 %tmp8, label %logic_end_4, label %logic_rhs_4
logic_rhs_4:
	%tmp9 = icmp eq i8 %token, 62
	br label %logic_end_4
logic_end_4:
	%tmp10 = phi i1 [%tmp8, %logic_end_3], [%tmp9, %logic_rhs_4]
	br i1 %tmp10, label %logic_end_5, label %logic_rhs_5
logic_rhs_5:
	%tmp11 = icmp eq i8 %token, 63
	br label %logic_end_5
logic_end_5:
	%tmp12 = phi i1 [%tmp10, %logic_end_4], [%tmp11, %logic_rhs_5]
	br i1 %tmp12, label %logic_end_6, label %logic_rhs_6
logic_rhs_6:
	%tmp13 = icmp eq i8 %token, 64
	br label %logic_end_6
logic_end_6:
	%tmp14 = phi i1 [%tmp12, %logic_end_5], [%tmp13, %logic_rhs_6]
	br i1 %tmp14, label %logic_end_7, label %logic_rhs_7
logic_rhs_7:
	%tmp15 = icmp eq i8 %token, 59
	br label %logic_end_7
logic_end_7:
	%tmp16 = phi i1 [%tmp14, %logic_end_6], [%tmp15, %logic_rhs_7]
	br i1 %tmp16, label %logic_end_8, label %logic_rhs_8
logic_rhs_8:
	%tmp17 = icmp eq i8 %token, 0
	br label %logic_end_8
logic_end_8:
	%tmp18 = phi i1 [%tmp16, %logic_end_7], [%tmp17, %logic_rhs_8]
	br i1 %tmp18, label %logic_end_9, label %logic_rhs_9
logic_rhs_9:
	%tmp19 = icmp eq i8 %token, 4
	br label %logic_end_9
logic_end_9:
	%tmp20 = phi i1 [%tmp18, %logic_end_8], [%tmp19, %logic_rhs_9]
	br i1 %tmp20, label %logic_end_10, label %logic_rhs_10
logic_rhs_10:
	%tmp21 = icmp eq i8 %token, 10
	br label %logic_end_10
logic_end_10:
	%tmp22 = phi i1 [%tmp20, %logic_end_9], [%tmp21, %logic_rhs_10]
	br i1 %tmp22, label %then11, label %endif11
then11:
	br label %func_exit
endif11:
	%tmp23 = call i1 @is_prefix_operator(i8 %token)
	br label %func_exit
func_exit:
	%tmp24 = phi i1 [true, %then11], [%tmp23, %endif11]
	ret i1 %tmp24
}
define void @insert_symbol_into_table(%struct.SymbolTable* %table, %struct.SymbolTableEntry %entry){
	%v0 = alloca %struct.SymbolTableEntry
; Variable entry is out.
	store %struct.SymbolTableEntry %entry, %struct.SymbolTableEntry* %v0
	%tmp0 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %v0, i32 0, i32 1
	%tmp1 = load %struct.PathEx, %struct.PathEx* %tmp0
	%tmp2 = call %struct.SymbolTableEntry* @get_symbol_from_table(%struct.SymbolTable* %table, %struct.PathEx %tmp1)
	%tmp3 = icmp ne %struct.SymbolTableEntry* %tmp2, null
	br i1 %tmp3, label %then0, label %endif0
then0:
	call void @process.throw(i8* @.str.252)
	br label %endif0
endif0:
	%tmp4 = load %struct.SymbolTableEntry, %struct.SymbolTableEntry* %v0
	call void @"vector.push<%struct.SymbolTableEntry>"(%"struct.vector.Vec<%struct.SymbolTableEntry>"* %table, %struct.SymbolTableEntry %tmp4)
; Variable entry is out.
	ret void
}
define i16 @insert_symbol(i8* %data, i32 %len, %"struct.vector.Vec<%struct.string.String>"* %symbols){
	%v0 = alloca i32
	%v1 = alloca i16
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %symbols, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	store i32 0, i32* %v0
	br label %loop_cond0
loop_cond0:
	%tmp2 = load i32, i32* %v0
	%tmp3 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %symbols, i32 0, i32 1
	%tmp4 = load i32, i32* %tmp3
	%tmp5 = icmp uge i32 %tmp2, %tmp4
	br i1 %tmp5, label %then1, label %endif1
then1:
	br label %loop_body0_exit
endif1:
	%tmp6 = load i32, i32* %v0
	%tmp7 = load %struct.string.String*, %struct.string.String** %symbols
	%tmp8 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp7, i32 %tmp6
	%tmp9 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp8, i32 0, i32 1
	%tmp10 = load i32, i32* %tmp9
	%tmp11 = icmp ne i32 %tmp10, %len
	br i1 %tmp11, label %then2, label %endif2
then2:
	br label %loop_body0
endif2:
	%tmp12 = load i32, i32* %v0
	%tmp13 = load %struct.string.String*, %struct.string.String** %symbols
	%tmp14 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp13, i32 %tmp12
	%tmp15 = load i8*, i8** %tmp14
	%tmp16 = sext i32 %len to i64
	%tmp17 = call i32 @mem.compare(i8* %data, i8* %tmp15, i64 %tmp16)
	%tmp18 = icmp eq i32 %tmp17, 0
	br i1 %tmp18, label %then3, label %endif3
then3:
	%tmp19 = load i32, i32* %v0
	%tmp20 = trunc i32 %tmp19 to i16
	br label %func_exit
endif3:
	br label %loop_body0
loop_body0:
	%tmp21 = load i32, i32* %v0
	%tmp22 = add i32 %tmp21, 1
	store i32 %tmp22, i32* %v0
	br label %loop_cond0
loop_body0_exit:
	%tmp23 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %symbols, i32 0, i32 1
	%tmp24 = load i32, i32* %tmp23
	%tmp25 = trunc i32 %tmp24 to i16
	store i16 %tmp25, i16* %v1
	%tmp26 = call %struct.string.String @string.from_data(i8* %data, i32 %len)
	call void @"vector.push<%struct.string.String>"(%"struct.vector.Vec<%struct.string.String>"* %symbols, %struct.string.String %tmp26)
	%tmp27 = load i16, i16* %v1
	br label %func_exit
func_exit:
	%tmp28 = phi i16 [%tmp20, %then3], [%tmp27, %loop_body0_exit]
	ret i16 %tmp28
}
define void @handle_symbol(i8* %data, i32 %start, i32 %end, %"struct.vector.Vec<%struct.TokenData>"* %tokens, %"struct.vector.Vec<%struct.string.String>"* %symbols){
	%v0 = alloca %struct.TokenData
	%v1 = alloca %struct.TokenData
	%v2 = alloca %struct.TokenData
	%v3 = alloca %struct.TokenData
	%v4 = alloca %struct.TokenData
	%v5 = alloca %struct.TokenData
	%v6 = alloca %struct.TokenData
	%v7 = alloca %struct.TokenData
	%v8 = alloca %struct.TokenData
	%v9 = alloca %struct.TokenData
	%v10 = alloca %struct.TokenData
	%v11 = alloca %struct.TokenData
	%v12 = alloca %struct.TokenData
	%v13 = alloca %struct.TokenData
	%v14 = alloca %struct.TokenData
	%v15 = alloca %struct.TokenData
	%v16 = alloca %struct.TokenData
	%v17 = alloca %struct.TokenData
	%v18 = alloca %struct.TokenData
	%v19 = alloca %struct.TokenData
	%v20 = alloca %struct.TokenData
	%v21 = alloca %struct.TokenData
	%v22 = alloca %struct.TokenData
	%v23 = alloca %struct.TokenData
	%v24 = alloca %struct.TokenData
	%v25 = alloca %struct.TokenData
	%v26 = alloca %struct.TokenData
	%v27 = alloca %struct.TokenData
	%v28 = alloca %struct.TokenData
	%v29 = alloca i16
	%v30 = alloca %struct.TokenData
	%tmp0 = sub i32 %end, %start
	%tmp1 = getelementptr inbounds i8, i8* %data, i32 %start
	%tmp2 = icmp eq i32 %tmp0, 2
	br i1 %tmp2, label %then0, label %else0
then0:
	%tmp3 = call i32 @mem.compare(i8* %tmp1, i8* @.str.253, i64 2)
	%tmp4 = icmp eq i32 %tmp3, 0
	br i1 %tmp4, label %then1, label %endif1
then1:
	store i8 45, i8* %v0
	%tmp5 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v0, i32 0, i32 1
	store i16 0, i16* %tmp5
	%tmp6 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v0, i32 0, i32 2
	store i32 %start, i32* %tmp6
	%tmp7 = load %struct.TokenData, %struct.TokenData* %v0
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp7)
	br label %func_exit
; Variable temp is out.
endif1:
	%tmp8 = call i32 @mem.compare(i8* %tmp1, i8* @.str.254, i64 2)
	%tmp9 = icmp eq i32 %tmp8, 0
	br i1 %tmp9, label %then2, label %endif2
then2:
	store i8 53, i8* %v1
	%tmp10 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v1, i32 0, i32 1
	store i16 0, i16* %tmp10
	%tmp11 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v1, i32 0, i32 2
	store i32 %start, i32* %tmp11
	%tmp12 = load %struct.TokenData, %struct.TokenData* %v1
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp12)
	br label %func_exit
; Variable temp is out.
endif2:
	%tmp13 = call i32 @mem.compare(i8* %tmp1, i8* @.str.255, i64 2)
	%tmp14 = icmp eq i32 %tmp13, 0
	br i1 %tmp14, label %then3, label %endif3
then3:
	store i8 44, i8* %v2
	%tmp15 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v2, i32 0, i32 1
	store i16 0, i16* %tmp15
	%tmp16 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v2, i32 0, i32 2
	store i32 %start, i32* %tmp16
	%tmp17 = load %struct.TokenData, %struct.TokenData* %v2
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp17)
	br label %func_exit
; Variable temp is out.
endif3:
	%tmp18 = call i32 @mem.compare(i8* %tmp1, i8* @.str.256, i64 2)
	%tmp19 = icmp eq i32 %tmp18, 0
	br i1 %tmp19, label %then4, label %endif4
then4:
	store i8 54, i8* %v3
	%tmp20 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v3, i32 0, i32 1
	store i16 0, i16* %tmp20
	%tmp21 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v3, i32 0, i32 2
	store i32 %start, i32* %tmp21
	%tmp22 = load %struct.TokenData, %struct.TokenData* %v3
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp22)
	br label %func_exit
; Variable temp is out.
endif4:
	%tmp23 = call i32 @mem.compare(i8* %tmp1, i8* @.str.257, i64 2)
	%tmp24 = icmp eq i32 %tmp23, 0
	br i1 %tmp24, label %then5, label %endif5
then5:
	store i8 41, i8* %v4
	%tmp25 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v4, i32 0, i32 1
	store i16 0, i16* %tmp25
	%tmp26 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v4, i32 0, i32 2
	store i32 %start, i32* %tmp26
	%tmp27 = load %struct.TokenData, %struct.TokenData* %v4
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp27)
	br label %func_exit
; Variable temp is out.
endif5:
	br label %endif0
else0:
	%tmp28 = icmp eq i32 %tmp0, 3
	br i1 %tmp28, label %then6, label %else6
then6:
	%tmp29 = call i32 @mem.compare(i8* %tmp1, i8* @.str.258, i64 3)
	%tmp30 = icmp eq i32 %tmp29, 0
	br i1 %tmp30, label %then7, label %endif7
then7:
	store i8 42, i8* %v5
	%tmp31 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v5, i32 0, i32 1
	store i16 0, i16* %tmp31
	%tmp32 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v5, i32 0, i32 2
	store i32 %start, i32* %tmp32
	%tmp33 = load %struct.TokenData, %struct.TokenData* %v5
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp33)
	br label %func_exit
; Variable temp is out.
endif7:
	%tmp34 = call i32 @mem.compare(i8* %tmp1, i8* @.str.259, i64 3)
	%tmp35 = icmp eq i32 %tmp34, 0
	br i1 %tmp35, label %then8, label %endif8
then8:
	store i8 36, i8* %v6
	%tmp36 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v6, i32 0, i32 1
	store i16 0, i16* %tmp36
	%tmp37 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v6, i32 0, i32 2
	store i32 %start, i32* %tmp37
	%tmp38 = load %struct.TokenData, %struct.TokenData* %v6
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp38)
	br label %func_exit
; Variable temp is out.
endif8:
	%tmp39 = call i32 @mem.compare(i8* %tmp1, i8* @.str.260, i64 3)
	%tmp40 = icmp eq i32 %tmp39, 0
	br i1 %tmp40, label %then9, label %endif9
then9:
	store i8 52, i8* %v7
	%tmp41 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v7, i32 0, i32 1
	store i16 0, i16* %tmp41
	%tmp42 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v7, i32 0, i32 2
	store i32 %start, i32* %tmp42
	%tmp43 = load %struct.TokenData, %struct.TokenData* %v7
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp43)
	br label %func_exit
; Variable temp is out.
endif9:
	br label %endif6
else6:
	%tmp44 = icmp eq i32 %tmp0, 4
	br i1 %tmp44, label %then10, label %else10
then10:
	%tmp45 = call i32 @mem.compare(i8* %tmp1, i8* @.str.261, i64 4)
	%tmp46 = icmp eq i32 %tmp45, 0
	br i1 %tmp46, label %then11, label %endif11
then11:
	store i8 62, i8* %v8
	%tmp47 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v8, i32 0, i32 1
	store i16 0, i16* %tmp47
	%tmp48 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v8, i32 0, i32 2
	store i32 %start, i32* %tmp48
	%tmp49 = load %struct.TokenData, %struct.TokenData* %v8
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp49)
	br label %func_exit
; Variable temp is out.
endif11:
	%tmp50 = call i32 @mem.compare(i8* %tmp1, i8* @.str.262, i64 4)
	%tmp51 = icmp eq i32 %tmp50, 0
	br i1 %tmp51, label %then12, label %endif12
then12:
	store i8 51, i8* %v9
	%tmp52 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v9, i32 0, i32 1
	store i16 0, i16* %tmp52
	%tmp53 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v9, i32 0, i32 2
	store i32 %start, i32* %tmp53
	%tmp54 = load %struct.TokenData, %struct.TokenData* %v9
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp54)
	br label %func_exit
; Variable temp is out.
endif12:
	%tmp55 = call i32 @mem.compare(i8* %tmp1, i8* @.str.263, i64 4)
	%tmp56 = icmp eq i32 %tmp55, 0
	br i1 %tmp56, label %then13, label %endif13
then13:
	store i8 59, i8* %v10
	%tmp57 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v10, i32 0, i32 1
	store i16 0, i16* %tmp57
	%tmp58 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v10, i32 0, i32 2
	store i32 %start, i32* %tmp58
	%tmp59 = load %struct.TokenData, %struct.TokenData* %v10
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp59)
	br label %func_exit
; Variable temp is out.
endif13:
	%tmp60 = call i32 @mem.compare(i8* %tmp1, i8* @.str.264, i64 4)
	%tmp61 = icmp eq i32 %tmp60, 0
	br i1 %tmp61, label %then14, label %endif14
then14:
	store i8 64, i8* %v11
	%tmp62 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v11, i32 0, i32 1
	store i16 0, i16* %tmp62
	%tmp63 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v11, i32 0, i32 2
	store i32 %start, i32* %tmp63
	%tmp64 = load %struct.TokenData, %struct.TokenData* %v11
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp64)
	br label %func_exit
; Variable temp is out.
endif14:
	%tmp65 = call i32 @mem.compare(i8* %tmp1, i8* @.str.265, i64 4)
	%tmp66 = icmp eq i32 %tmp65, 0
	br i1 %tmp66, label %then15, label %endif15
then15:
	store i8 46, i8* %v12
	%tmp67 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v12, i32 0, i32 1
	store i16 0, i16* %tmp67
	%tmp68 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v12, i32 0, i32 2
	store i32 %start, i32* %tmp68
	%tmp69 = load %struct.TokenData, %struct.TokenData* %v12
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp69)
	br label %func_exit
; Variable temp is out.
endif15:
	%tmp70 = call i32 @mem.compare(i8* %tmp1, i8* @.str.266, i64 4)
	%tmp71 = icmp eq i32 %tmp70, 0
	br i1 %tmp71, label %then16, label %endif16
then16:
	store i8 50, i8* %v13
	%tmp72 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v13, i32 0, i32 1
	store i16 0, i16* %tmp72
	%tmp73 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v13, i32 0, i32 2
	store i32 %start, i32* %tmp73
	%tmp74 = load %struct.TokenData, %struct.TokenData* %v13
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp74)
	br label %func_exit
; Variable temp is out.
endif16:
	%tmp75 = call i32 @mem.compare(i8* %tmp1, i8* @.str.267, i64 4)
	%tmp76 = icmp eq i32 %tmp75, 0
	br i1 %tmp76, label %then17, label %endif17
then17:
	store i8 48, i8* %v14
	%tmp77 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v14, i32 0, i32 1
	store i16 0, i16* %tmp77
	%tmp78 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v14, i32 0, i32 2
	store i32 %start, i32* %tmp78
	%tmp79 = load %struct.TokenData, %struct.TokenData* %v14
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp79)
	br label %func_exit
; Variable temp is out.
endif17:
	br label %endif10
else10:
	%tmp80 = icmp eq i32 %tmp0, 5
	br i1 %tmp80, label %then18, label %else18
then18:
	%tmp81 = call i32 @mem.compare(i8* %tmp1, i8* @.str.268, i64 5)
	%tmp82 = icmp eq i32 %tmp81, 0
	br i1 %tmp82, label %then19, label %endif19
then19:
	store i8 38, i8* %v15
	%tmp83 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v15, i32 0, i32 1
	store i16 0, i16* %tmp83
	%tmp84 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v15, i32 0, i32 2
	store i32 %start, i32* %tmp84
	%tmp85 = load %struct.TokenData, %struct.TokenData* %v15
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp85)
	br label %func_exit
; Variable temp is out.
endif19:
	%tmp86 = call i32 @mem.compare(i8* %tmp1, i8* @.str.269, i64 5)
	%tmp87 = icmp eq i32 %tmp86, 0
	br i1 %tmp87, label %then20, label %endif20
then20:
	store i8 40, i8* %v16
	%tmp88 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v16, i32 0, i32 1
	store i16 0, i16* %tmp88
	%tmp89 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v16, i32 0, i32 2
	store i32 %start, i32* %tmp89
	%tmp90 = load %struct.TokenData, %struct.TokenData* %v16
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp90)
	br label %func_exit
; Variable temp is out.
endif20:
	%tmp91 = call i32 @mem.compare(i8* %tmp1, i8* @.str.270, i64 5)
	%tmp92 = icmp eq i32 %tmp91, 0
	br i1 %tmp92, label %then21, label %endif21
then21:
	store i8 47, i8* %v17
	%tmp93 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v17, i32 0, i32 1
	store i16 0, i16* %tmp93
	%tmp94 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v17, i32 0, i32 2
	store i32 %start, i32* %tmp94
	%tmp95 = load %struct.TokenData, %struct.TokenData* %v17
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp95)
	br label %func_exit
; Variable temp is out.
endif21:
	%tmp96 = call i32 @mem.compare(i8* %tmp1, i8* @.str.271, i64 5)
	%tmp97 = icmp eq i32 %tmp96, 0
	br i1 %tmp97, label %then22, label %endif22
then22:
	store i8 55, i8* %v18
	%tmp98 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v18, i32 0, i32 1
	store i16 0, i16* %tmp98
	%tmp99 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v18, i32 0, i32 2
	store i32 %start, i32* %tmp99
	%tmp100 = load %struct.TokenData, %struct.TokenData* %v18
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp100)
	br label %func_exit
; Variable temp is out.
endif22:
	%tmp101 = call i32 @mem.compare(i8* %tmp1, i8* @.str.272, i64 5)
	%tmp102 = icmp eq i32 %tmp101, 0
	br i1 %tmp102, label %then23, label %endif23
then23:
	store i8 56, i8* %v19
	%tmp103 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v19, i32 0, i32 1
	store i16 0, i16* %tmp103
	%tmp104 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v19, i32 0, i32 2
	store i32 %start, i32* %tmp104
	%tmp105 = load %struct.TokenData, %struct.TokenData* %v19
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp105)
	br label %func_exit
; Variable temp is out.
endif23:
	%tmp106 = call i32 @mem.compare(i8* %tmp1, i8* @.str.273, i64 5)
	%tmp107 = icmp eq i32 %tmp106, 0
	br i1 %tmp107, label %then24, label %endif24
then24:
	store i8 63, i8* %v20
	%tmp108 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v20, i32 0, i32 1
	store i16 0, i16* %tmp108
	%tmp109 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v20, i32 0, i32 2
	store i32 %start, i32* %tmp109
	%tmp110 = load %struct.TokenData, %struct.TokenData* %v20
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp110)
	br label %func_exit
; Variable temp is out.
endif24:
	br label %endif18
else18:
	%tmp111 = icmp eq i32 %tmp0, 6
	br i1 %tmp111, label %then25, label %else25
then25:
	%tmp112 = call i32 @mem.compare(i8* %tmp1, i8* @.str.274, i64 6)
	%tmp113 = icmp eq i32 %tmp112, 0
	br i1 %tmp113, label %then26, label %endif26
then26:
	store i8 37, i8* %v21
	%tmp114 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v21, i32 0, i32 1
	store i16 0, i16* %tmp114
	%tmp115 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v21, i32 0, i32 2
	store i32 %start, i32* %tmp115
	%tmp116 = load %struct.TokenData, %struct.TokenData* %v21
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp116)
	br label %func_exit
; Variable temp is out.
endif26:
	%tmp117 = call i32 @mem.compare(i8* %tmp1, i8* @.str.275, i64 6)
	%tmp118 = icmp eq i32 %tmp117, 0
	br i1 %tmp118, label %then27, label %endif27
then27:
	store i8 39, i8* %v22
	%tmp119 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v22, i32 0, i32 1
	store i16 0, i16* %tmp119
	%tmp120 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v22, i32 0, i32 2
	store i32 %start, i32* %tmp120
	%tmp121 = load %struct.TokenData, %struct.TokenData* %v22
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp121)
	br label %func_exit
; Variable temp is out.
endif27:
	%tmp122 = call i32 @mem.compare(i8* %tmp1, i8* @.str.276, i64 6)
	%tmp123 = icmp eq i32 %tmp122, 0
	br i1 %tmp123, label %then28, label %endif28
then28:
	store i8 43, i8* %v23
	%tmp124 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v23, i32 0, i32 1
	store i16 0, i16* %tmp124
	%tmp125 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v23, i32 0, i32 2
	store i32 %start, i32* %tmp125
	%tmp126 = load %struct.TokenData, %struct.TokenData* %v23
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp126)
	br label %func_exit
; Variable temp is out.
endif28:
	%tmp127 = call i32 @mem.compare(i8* %tmp1, i8* @.str.277, i64 6)
	%tmp128 = icmp eq i32 %tmp127, 0
	br i1 %tmp128, label %then29, label %endif29
then29:
	store i8 49, i8* %v24
	%tmp129 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v24, i32 0, i32 1
	store i16 0, i16* %tmp129
	%tmp130 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v24, i32 0, i32 2
	store i32 %start, i32* %tmp130
	%tmp131 = load %struct.TokenData, %struct.TokenData* %v24
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp131)
	br label %func_exit
; Variable temp is out.
endif29:
	%tmp132 = call i32 @mem.compare(i8* %tmp1, i8* @.str.278, i64 6)
	%tmp133 = icmp eq i32 %tmp132, 0
	br i1 %tmp133, label %then30, label %endif30
then30:
	store i8 58, i8* %v25
	%tmp134 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v25, i32 0, i32 1
	store i16 0, i16* %tmp134
	%tmp135 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v25, i32 0, i32 2
	store i32 %start, i32* %tmp135
	%tmp136 = load %struct.TokenData, %struct.TokenData* %v25
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp136)
	br label %func_exit
; Variable temp is out.
endif30:
	br label %endif25
else25:
	%tmp137 = icmp eq i32 %tmp0, 8
	br i1 %tmp137, label %then31, label %else31
then31:
	%tmp138 = call i32 @mem.compare(i8* %tmp1, i8* @.str.279, i64 8)
	%tmp139 = icmp eq i32 %tmp138, 0
	br i1 %tmp139, label %then32, label %endif32
then32:
	store i8 57, i8* %v26
	%tmp140 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v26, i32 0, i32 1
	store i16 0, i16* %tmp140
	%tmp141 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v26, i32 0, i32 2
	store i32 %start, i32* %tmp141
	%tmp142 = load %struct.TokenData, %struct.TokenData* %v26
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp142)
	br label %func_exit
; Variable temp is out.
endif32:
	%tmp143 = call i32 @mem.compare(i8* %tmp1, i8* @.str.280, i64 8)
	%tmp144 = icmp eq i32 %tmp143, 0
	br i1 %tmp144, label %then33, label %endif33
then33:
	store i8 60, i8* %v27
	%tmp145 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v27, i32 0, i32 1
	store i16 0, i16* %tmp145
	%tmp146 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v27, i32 0, i32 2
	store i32 %start, i32* %tmp146
	%tmp147 = load %struct.TokenData, %struct.TokenData* %v27
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp147)
	br label %func_exit
; Variable temp is out.
endif33:
	br label %endif31
else31:
	%tmp148 = icmp eq i32 %tmp0, 9
	br i1 %tmp148, label %then34, label %endif34
then34:
	%tmp149 = call i32 @mem.compare(i8* %tmp1, i8* @.str.281, i64 9)
	%tmp150 = icmp eq i32 %tmp149, 0
	br i1 %tmp150, label %then35, label %endif35
then35:
	store i8 61, i8* %v28
	%tmp151 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v28, i32 0, i32 1
	store i16 0, i16* %tmp151
	%tmp152 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v28, i32 0, i32 2
	store i32 %start, i32* %tmp152
	%tmp153 = load %struct.TokenData, %struct.TokenData* %v28
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp153)
	br label %func_exit
; Variable temp is out.
endif35:
	br label %endif34
endif34:
	br label %endif31
endif31:
	br label %endif25
endif25:
	br label %endif18
endif18:
	br label %endif10
endif10:
	br label %endif6
endif6:
	br label %endif0
endif0:
	%tmp154 = call i16 @insert_symbol(i8* %tmp1, i32 %tmp0, %"struct.vector.Vec<%struct.string.String>"* %symbols)
	store i16 %tmp154, i16* %v29
	%tmp155 = load i16, i16* %v29
	store i8 65, i8* %v30
	%tmp156 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v30, i32 0, i32 1
	store i16 %tmp155, i16* %tmp156
	%tmp157 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v30, i32 0, i32 2
	store i32 %start, i32* %tmp157
	%tmp158 = load %struct.TokenData, %struct.TokenData* %v30
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp158)
	br label %func_exit
func_exit:
; Variable temp is out.
	ret void
}
define void @handle_string(i8* %data, i32 %start, i32 %end, %"struct.vector.Vec<%struct.TokenData>"* %tokens, %"struct.vector.Vec<%struct.string.String>"* %symbols){
	%v0 = alloca i32
	%v1 = alloca i32
	%v2 = alloca i8
	%v3 = alloca i8
	%v4 = alloca i8
	%v5 = alloca i16
	%v6 = alloca %struct.TokenData
	%tmp0 = sub i32 %end, %start
	%tmp1 = sub i32 %tmp0, 2
	%tmp2 = getelementptr inbounds i8, i8* %data, i32 %start
	%tmp3 = getelementptr inbounds i8, i8* %tmp2, i32 1
	%tmp4 = alloca i8, i32 %tmp1
	%tmp5 = add i32 %start, 1
	store i32 %tmp5, i32* %v0
	store i32 0, i32* %v1
	br label %loop_start0
loop_start0:
	%tmp6 = load i32, i32* %v0
	%tmp7 = sub i32 %end, 1
	%tmp8 = icmp ult i32 %tmp6, %tmp7
	br i1 %tmp8, label %endif1, label %else1
else1:
	br label %loop_body0_exit
endif1:
	%tmp9 = load i32, i32* %v0
	%tmp10 = getelementptr inbounds i8, i8* %data, i32 %tmp9
	%tmp11 = load i8, i8* %tmp10
	store i8 %tmp11, i8* %v2
	%tmp12 = load i8, i8* %v2
	%tmp13 = icmp eq i8 %tmp12, 92
	br i1 %tmp13, label %then2, label %endif2
then2:
	%tmp14 = load i32, i32* %v0
	%tmp15 = add i32 %tmp14, 1
	%tmp16 = getelementptr inbounds i8, i8* %data, i32 %tmp15
	%tmp17 = load i8, i8* %tmp16
	store i8 %tmp17, i8* %v3
	%tmp18 = load i8, i8* %v3
	%tmp19 = icmp eq i8 %tmp18, 92
	br i1 %tmp19, label %then3, label %else3
then3:
	store i8 92, i8* %v4
	br label %endif3
else3:
	%tmp20 = load i8, i8* %v3
	%tmp21 = icmp eq i8 %tmp20, 110
	br i1 %tmp21, label %then4, label %else4
then4:
	store i8 10, i8* %v4
	br label %endif4
else4:
	%tmp22 = load i8, i8* %v3
	%tmp23 = icmp eq i8 %tmp22, 114
	br i1 %tmp23, label %then5, label %else5
then5:
	store i8 13, i8* %v4
	br label %endif5
else5:
	%tmp24 = load i8, i8* %v3
	%tmp25 = icmp eq i8 %tmp24, 116
	br i1 %tmp25, label %then6, label %else6
then6:
	store i8 9, i8* %v4
	br label %endif6
else6:
	%tmp26 = load i8, i8* %v3
	%tmp27 = icmp eq i8 %tmp26, 39
	br i1 %tmp27, label %then7, label %else7
then7:
	store i8 39, i8* %v4
	br label %endif7
else7:
	%tmp28 = load i8, i8* %v3
	%tmp29 = icmp eq i8 %tmp28, 34
	br i1 %tmp29, label %then8, label %else8
then8:
	store i8 34, i8* %v4
	br label %endif8
else8:
	%tmp30 = load i8, i8* %v3
	%tmp31 = icmp eq i8 %tmp30, 118
	br i1 %tmp31, label %then9, label %else9
then9:
	store i8 11, i8* %v4
	br label %endif9
else9:
	%tmp32 = load i8, i8* %v3
	%tmp33 = icmp eq i8 %tmp32, 102
	br i1 %tmp33, label %then10, label %else10
then10:
	store i8 12, i8* %v4
	br label %endif10
else10:
	%tmp34 = load i8, i8* %v3
	%tmp35 = icmp eq i8 %tmp34, 48
	br i1 %tmp35, label %then11, label %else11
then11:
	store i8 0, i8* %v4
	br label %endif11
else11:
	%tmp36 = getelementptr inbounds i8, i8* %data, i32 %start
	%tmp37 = getelementptr inbounds i8, i8* %tmp36, i32 1
	%tmp38 = load i8, i8* %v3
	%tmp39 = sext i8 %tmp38 to i64
	call void @console.println_i64(i64 %tmp39)
	call void @console.writeln(i8* %tmp37, i32 %tmp1)
	call void @process.throw(i8* @.str.282)
	br label %endif11
endif11:
	br label %endif10
endif10:
	br label %endif9
endif9:
	br label %endif8
endif8:
	br label %endif7
endif7:
	br label %endif6
endif6:
	br label %endif5
endif5:
	br label %endif4
endif4:
	br label %endif3
endif3:
	%tmp40 = load i32, i32* %v1
	%tmp41 = getelementptr inbounds i8, i8* %tmp4, i32 %tmp40
	%tmp42 = load i8, i8* %v4
	store i8 %tmp42, i8* %tmp41
	%tmp43 = load i32, i32* %v1
	%tmp44 = add i32 %tmp43, 1
	store i32 %tmp44, i32* %v1
	%tmp45 = load i32, i32* %v0
	%tmp46 = add i32 %tmp45, 2
	store i32 %tmp46, i32* %v0
	br label %loop_body0
endif2:
	%tmp47 = load i32, i32* %v1
	%tmp48 = getelementptr inbounds i8, i8* %tmp4, i32 %tmp47
	%tmp49 = load i8, i8* %v2
	store i8 %tmp49, i8* %tmp48
	%tmp50 = load i32, i32* %v1
	%tmp51 = add i32 %tmp50, 1
	store i32 %tmp51, i32* %v1
	%tmp52 = load i32, i32* %v0
	%tmp53 = add i32 %tmp52, 1
	store i32 %tmp53, i32* %v0
	br label %loop_body0
loop_body0:
	br label %loop_start0
loop_body0_exit:
	%tmp54 = call i16 @insert_symbol(i8* %tmp3, i32 %tmp1, %"struct.vector.Vec<%struct.string.String>"* %symbols)
	store i16 %tmp54, i16* %v5
	%tmp55 = load i16, i16* %v5
	store i8 68, i8* %v6
	%tmp56 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v6, i32 0, i32 1
	store i16 %tmp55, i16* %tmp56
	%tmp57 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v6, i32 0, i32 2
	store i32 %start, i32* %tmp57
	%tmp58 = load %struct.TokenData, %struct.TokenData* %v6
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp58)
; Variable temp is out.
	ret void
}
define void @handle_number(i8* %data, i32 %start, i32 %end, %"struct.vector.Vec<%struct.TokenData>"* %tokens, %"struct.vector.Vec<%struct.string.String>"* %symbols){
	%v0 = alloca i16
	%v1 = alloca %struct.TokenData
	%tmp0 = getelementptr inbounds i8, i8* %data, i32 %start
	%tmp1 = sub i32 %end, %start
	%tmp2 = call i16 @insert_symbol(i8* %tmp0, i32 %tmp1, %"struct.vector.Vec<%struct.string.String>"* %symbols)
	store i16 %tmp2, i16* %v0
	%tmp3 = load i16, i16* %v0
	store i8 66, i8* %v1
	%tmp4 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v1, i32 0, i32 1
	store i16 %tmp3, i16* %tmp4
	%tmp5 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v1, i32 0, i32 2
	store i32 %start, i32* %tmp5
	%tmp6 = load %struct.TokenData, %struct.TokenData* %v1
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp6)
; Variable temp is out.
	ret void
}
define void @handle_decimal_number(i8* %data, i32 %start, i32 %end, %"struct.vector.Vec<%struct.TokenData>"* %tokens, %"struct.vector.Vec<%struct.string.String>"* %symbols){
	%v0 = alloca i16
	%v1 = alloca %struct.TokenData
	%tmp0 = getelementptr inbounds i8, i8* %data, i32 %start
	%tmp1 = sub i32 %end, %start
	%tmp2 = call i16 @insert_symbol(i8* %tmp0, i32 %tmp1, %"struct.vector.Vec<%struct.string.String>"* %symbols)
	store i16 %tmp2, i16* %v0
	%tmp3 = load i16, i16* %v0
	store i8 67, i8* %v1
	%tmp4 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v1, i32 0, i32 1
	store i16 %tmp3, i16* %tmp4
	%tmp5 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v1, i32 0, i32 2
	store i32 %start, i32* %tmp5
	%tmp6 = load %struct.TokenData, %struct.TokenData* %v1
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp6)
; Variable temp is out.
	ret void
}
define void @handle_char(i8* %data, i32 %start, i32 %end, %"struct.vector.Vec<%struct.TokenData>"* %tokens, %"struct.vector.Vec<%struct.string.String>"* %symbols){
	%v0 = alloca i8
	%v1 = alloca i16
	%v2 = alloca %struct.TokenData
	%v3 = alloca %struct.TokenData
	%tmp0 = sub i32 %end, %start
	%tmp1 = sub i32 %tmp0, 2
	%tmp2 = getelementptr inbounds i8, i8* %data, i32 %start
	%tmp3 = getelementptr inbounds i8, i8* %tmp2, i32 1
	%tmp4 = load i8, i8* %tmp3
	%tmp5 = icmp eq i8 %tmp4, 92
	br i1 %tmp5, label %then0, label %endif0
then0:
	%tmp6 = getelementptr inbounds i8, i8* %tmp3, i32 1
	%tmp7 = load i8, i8* %tmp6
	store i8 %tmp7, i8* %v0
	%tmp8 = load i8, i8* %v0
	%tmp9 = icmp eq i8 %tmp8, 92
	br i1 %tmp9, label %then1, label %else1
then1:
	store i16 92, i16* %v1
	br label %endif1
else1:
	%tmp10 = load i8, i8* %v0
	%tmp11 = icmp eq i8 %tmp10, 110
	br i1 %tmp11, label %then2, label %else2
then2:
	store i16 10, i16* %v1
	br label %endif2
else2:
	%tmp12 = load i8, i8* %v0
	%tmp13 = icmp eq i8 %tmp12, 114
	br i1 %tmp13, label %then3, label %else3
then3:
	store i16 13, i16* %v1
	br label %endif3
else3:
	%tmp14 = load i8, i8* %v0
	%tmp15 = icmp eq i8 %tmp14, 116
	br i1 %tmp15, label %then4, label %else4
then4:
	store i16 9, i16* %v1
	br label %endif4
else4:
	%tmp16 = load i8, i8* %v0
	%tmp17 = icmp eq i8 %tmp16, 39
	br i1 %tmp17, label %then5, label %else5
then5:
	store i16 39, i16* %v1
	br label %endif5
else5:
	%tmp18 = load i8, i8* %v0
	%tmp19 = icmp eq i8 %tmp18, 118
	br i1 %tmp19, label %then6, label %else6
then6:
	store i16 11, i16* %v1
	br label %endif6
else6:
	%tmp20 = load i8, i8* %v0
	%tmp21 = icmp eq i8 %tmp20, 102
	br i1 %tmp21, label %then7, label %else7
then7:
	store i16 12, i16* %v1
	br label %endif7
else7:
	%tmp22 = load i8, i8* %v0
	%tmp23 = icmp eq i8 %tmp22, 48
	br i1 %tmp23, label %then8, label %else8
then8:
	store i16 0, i16* %v1
	br label %endif8
else8:
	call void @console.writeln(i8* %tmp3, i32 %tmp1)
	call void @process.throw(i8* @.str.282)
	br label %endif8
endif8:
	br label %endif7
endif7:
	br label %endif6
endif6:
	br label %endif5
endif5:
	br label %endif4
endif4:
	br label %endif3
endif3:
	br label %endif2
endif2:
	br label %endif1
endif1:
	%tmp24 = load i16, i16* %v1
	store i8 69, i8* %v2
	%tmp25 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v2, i32 0, i32 1
	store i16 %tmp24, i16* %tmp25
	%tmp26 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v2, i32 0, i32 2
	store i32 %start, i32* %tmp26
	%tmp27 = load %struct.TokenData, %struct.TokenData* %v2
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp27)
	%tmp28 = icmp sgt i32 %tmp1, 2
	br i1 %tmp28, label %then9, label %endif9
then9:
	call void @process.throw(i8* @.str.283)
	br label %endif9
endif9:
	br label %func_exit
; Variable temp is out.
endif0:
	%tmp29 = icmp ne i32 %tmp1, 1
	br i1 %tmp29, label %then10, label %endif10
then10:
	call void @process.throw(i8* @.str.283)
	br label %endif10
endif10:
	%tmp30 = sext i8 %tmp4 to i16
	store i8 69, i8* %v3
	%tmp31 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v3, i32 0, i32 1
	store i16 %tmp30, i16* %tmp31
	%tmp32 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v3, i32 0, i32 2
	store i32 %start, i32* %tmp32
	%tmp33 = load %struct.TokenData, %struct.TokenData* %v3
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp33)
	br label %func_exit
func_exit:
; Variable temp is out.
	ret void
}
define i8 @get_unary_op(i8 %token){
	%tmp0 = icmp eq i8 %token, 17
	br i1 %tmp0, label %then0, label %endif0
then0:
	br label %func_exit
endif0:
	%tmp1 = icmp eq i8 %token, 21
	br i1 %tmp1, label %then1, label %endif1
then1:
	br label %func_exit
endif1:
	%tmp2 = icmp eq i8 %token, 18
	br i1 %tmp2, label %then2, label %endif2
then2:
	br label %func_exit
endif2:
	%tmp3 = icmp eq i8 %token, 32
	br i1 %tmp3, label %then3, label %endif3
then3:
	br label %func_exit
endif3:
	%tmp4 = icmp eq i8 %token, 30
	br i1 %tmp4, label %then4, label %endif4
then4:
	br label %func_exit
endif4:
	call void @process.throw(i8* @.str.284)
	br label %func_exit
func_exit:
	%tmp5 = phi i8 [0, %then0], [1, %then1], [2, %then2], [3, %then3], [4, %then4], [0, %endif4]
	ret i8 %tmp5
}
define %struct.SymbolTableEntry* @get_symbol_from_table(%struct.SymbolTable* %table, %struct.PathEx %path){
	%v0 = alloca %struct.PathEx
	%v1 = alloca i32
	%v2 = alloca i1
	%v3 = alloca i8
; Variable path is out.
	store %struct.PathEx %path, %struct.PathEx* %v0
	%tmp0 = load i8, i8* %v0
	%tmp1 = icmp eq i8 %tmp0, 0
	br i1 %tmp1, label %then0, label %endif0
then0:
	call void @process.throw(i8* @.str.285)
	br label %endif0
endif0:
	%tmp2 = load %struct.SymbolTableEntry*, %struct.SymbolTableEntry** %table
	%tmp3 = getelementptr inbounds %"struct.vector.Vec<%struct.SymbolTableEntry>", %"struct.vector.Vec<%struct.SymbolTableEntry>"* %table, i32 0, i32 1
	%tmp4 = load i32, i32* %tmp3
	store i32 0, i32* %v1
	br label %loop_cond1
loop_cond1:
	%tmp5 = load i32, i32* %v1
	%tmp6 = icmp uge i32 %tmp5, %tmp4
	br i1 %tmp6, label %then2, label %endif2
then2:
	br label %loop_body1_exit
endif2:
	%tmp7 = load i32, i32* %v1
	%tmp8 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp2, i32 %tmp7
	%tmp9 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp8, i32 0, i32 1
	%tmp10 = load i8, i8* %tmp9
	%tmp11 = load i8, i8* %v0
	%tmp12 = icmp ne i8 %tmp10, %tmp11
	br i1 %tmp12, label %then3, label %endif3
then3:
	br label %loop_body1
endif3:
	%tmp13 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp8, i32 0, i32 1
	%tmp14 = getelementptr inbounds %struct.PathEx, %struct.PathEx* %tmp13, i32 0, i32 1
	%tmp15 = load i16, i16* %tmp14
	%tmp16 = getelementptr inbounds %struct.PathEx, %struct.PathEx* %v0, i32 0, i32 1
	%tmp17 = load i16, i16* %tmp16
	%tmp18 = icmp ne i16 %tmp15, %tmp17
	br i1 %tmp18, label %then4, label %endif4
then4:
	br label %loop_body1
endif4:
	store i1 true, i1* %v2
	store i8 1, i8* %v3
	br label %loop_cond5
loop_cond5:
	%tmp19 = load i8, i8* %v3
	%tmp20 = icmp uge i8 %tmp19, %tmp10
	br i1 %tmp20, label %then6, label %endif6
then6:
	br label %loop_body5_exit
endif6:
	%tmp21 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp8, i32 0, i32 1
	%tmp22 = getelementptr inbounds %struct.PathEx, %struct.PathEx* %tmp21, i32 0, i32 1
	%tmp23 = load i8, i8* %v3
	%tmp24 = getelementptr inbounds [12 x i16], [12 x i16]* %tmp22, i32 0, i8 %tmp23
	%tmp25 = load i16, i16* %tmp24
	%tmp26 = getelementptr inbounds %struct.PathEx, %struct.PathEx* %v0, i32 0, i32 1
	%tmp27 = load i8, i8* %v3
	%tmp28 = getelementptr inbounds [12 x i16], [12 x i16]* %tmp26, i32 0, i8 %tmp27
	%tmp29 = load i16, i16* %tmp28
	%tmp30 = icmp ne i16 %tmp25, %tmp29
	br i1 %tmp30, label %then7, label %endif7
then7:
	store i1 false, i1* %v2
	br label %loop_body5_exit
endif7:
	%tmp31 = load i8, i8* %v3
	%tmp32 = add i8 %tmp31, 1
	store i8 %tmp32, i8* %v3
	br label %loop_cond5
loop_body5_exit:
	%tmp33 = load i1, i1* %v2
	%tmp34 = xor i1 1, %tmp33
	br i1 %tmp34, label %then8, label %endif8
then8:
	br label %loop_body1
endif8:
	br label %func_exit
loop_body1:
	%tmp35 = load i32, i32* %v1
	%tmp36 = add i32 %tmp35, 1
	store i32 %tmp36, i32* %v1
	br label %loop_cond1
loop_body1_exit:
	br label %func_exit
func_exit:
; Variable path is out.
	%tmp37 = phi %struct.SymbolTableEntry* [%tmp8, %endif8], [null, %loop_body1_exit]
	ret %struct.SymbolTableEntry* %tmp37
}
define i8 @get_flags(%struct.TokenData* %token_array, i32 %index, i32 %mod_index){
	%v0 = alloca i8
	%v1 = alloca i32
	%tmp0 = icmp eq i32 %mod_index, 4294967295
	br i1 %tmp0, label %then0, label %endif0
then0:
	br label %func_exit
endif0:
	store i8 0, i8* %v0
	store i32 %mod_index, i32* %v1
	br label %loop_cond1
loop_cond1:
	%tmp1 = load i32, i32* %v1
	%tmp2 = icmp uge i32 %tmp1, %index
	br i1 %tmp2, label %then2, label %endif2
then2:
	br label %loop_body1_exit
endif2:
	%tmp3 = load i32, i32* %v1
	%tmp4 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp3
	%tmp5 = load i8, i8* %tmp4
	%tmp6 = icmp eq i8 %tmp5, 36
	br i1 %tmp6, label %then3, label %else3
then3:
	%tmp7 = load i8, i8* %v0
	%tmp8 = or i8 %tmp7, 1
	store i8 %tmp8, i8* %v0
	br label %endif3
else3:
	%tmp9 = load i32, i32* %v1
	%tmp10 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp9
	%tmp11 = load i8, i8* %tmp10
	%tmp12 = icmp eq i8 %tmp11, 39
	br i1 %tmp12, label %then4, label %else4
then4:
	%tmp13 = load i8, i8* %v0
	%tmp14 = or i8 %tmp13, 4
	store i8 %tmp14, i8* %v0
	br label %endif4
else4:
	%tmp15 = load i32, i32* %v1
	%tmp16 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp15
	%tmp17 = load i8, i8* %tmp16
	%tmp18 = icmp eq i8 %tmp17, 37
	br i1 %tmp18, label %then5, label %else5
then5:
	%tmp19 = load i8, i8* %v0
	%tmp20 = or i8 %tmp19, 2
	store i8 %tmp20, i8* %v0
	br label %endif5
else5:
	%tmp21 = load i32, i32* %v1
	%tmp22 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp21
	%tmp23 = load i8, i8* %tmp22
	%tmp24 = icmp eq i8 %tmp23, 43
	br i1 %tmp24, label %then6, label %endif6
then6:
	%tmp25 = load i8, i8* %v0
	%tmp26 = or i8 %tmp25, 16
	store i8 %tmp26, i8* %v0
	br label %endif6
endif6:
	br label %endif5
endif5:
	br label %endif4
endif4:
	br label %endif3
endif3:
	%tmp27 = load i32, i32* %v1
	%tmp28 = add i32 %tmp27, 1
	store i32 %tmp28, i32* %v1
	br label %loop_cond1
loop_body1_exit:
	%tmp29 = load i8, i8* %v0
	br label %func_exit
func_exit:
	%tmp30 = phi i8 [0, %then0], [%tmp29, %loop_body1_exit]
	ret i8 %tmp30
}
define %struct.CompilerType @get_compiler_type_internal(%struct.Type* %type, %struct.Path* %l_path, %struct.Path* %g_path, %struct.SymbolTable* %table){
	%v0 = alloca %struct.CompilerType
	%v1 = alloca %struct.SymbolTableEntry*
	%v2 = alloca %struct.CompilerType
	%v3 = alloca %struct.CompilerType
	%v4 = alloca %struct.CompilerType
	%v5 = alloca %struct.SymbolTableEntry*
	%v6 = alloca %"struct.vector.Vec<%struct.CompilerType>"
	%v7 = alloca i32
	%v8 = alloca i32
	%v9 = alloca i32
	%v10 = alloca %struct.CompilerType
	%v11 = alloca %struct.CompilerType
	%tmp0 = load i32, i32* %type
	%tmp1 = icmp eq i32 %tmp0, 0
	br i1 %tmp1, label %then0, label %else0
then0:
	%tmp2 = getelementptr inbounds %struct.Type, %struct.Type* %type, i32 0, i32 1
	%tmp3 = load i8*, i8** %tmp2
	%tmp7 = load i16, i16* %tmp3
	%tmp8 = getelementptr inbounds %struct.SymbolTable, %struct.SymbolTable* %table, i32 0, i32 1
	%tmp9 = getelementptr inbounds %struct.SymbolTable, %struct.SymbolTable* %table, i32 0, i32 1
	%tmp10 = load %"struct.vector.Vec<%struct.string.String>"*, %"struct.vector.Vec<%struct.string.String>"** %tmp9
	%tmp11 = load %struct.string.String*, %struct.string.String** %tmp10
	%tmp12 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp11, i16 %tmp7
	%tmp13 = load i8*, i8** %tmp12
	%tmp14 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp12, i32 0, i32 1
	%tmp15 = load i32, i32* %tmp14
	%tmp16 = call i32 @find_primitive_type(i8* %tmp13, i32 %tmp15)
	%tmp17 = icmp ne i32 %tmp16, -1
	br i1 %tmp17, label %then1, label %endif1
then1:
	%tmp18 = getelementptr inbounds [15 x %struct.PrimitiveTypeInfo], [15 x %struct.PrimitiveTypeInfo]* @PRIMITIVE_TYPES_INFO, i32 0, i32 %tmp16
	store i32 0, i32* %v0
	%tmp19 = getelementptr inbounds %struct.CompilerType, %struct.CompilerType* %v0, i32 0, i32 1
	store i8* %tmp18, i8** %tmp19
	%tmp20 = load %struct.CompilerType, %struct.CompilerType* %v0
	br label %func_exit
; Variable x is out.
endif1:
	%tmp21 = load i16, i16* %tmp3
	%tmp22 = call %struct.PathEx @path_to_path_ex_name(%struct.Path* %l_path, i16 %tmp21)
	%tmp23 = call %struct.SymbolTableEntry* @get_symbol_from_table(%struct.SymbolTable* %table, %struct.PathEx %tmp22)
	store %struct.SymbolTableEntry* %tmp23, %struct.SymbolTableEntry** %v1
	%tmp24 = load %struct.SymbolTableEntry*, %struct.SymbolTableEntry** %v1
	%tmp25 = icmp eq %struct.SymbolTableEntry* %tmp24, null
	br i1 %tmp25, label %then2, label %endif2
then2:
	%tmp26 = load i16, i16* %tmp3
	%tmp27 = call %struct.PathEx @path_to_path_ex_name(%struct.Path* %g_path, i16 %tmp26)
	%tmp28 = call %struct.SymbolTableEntry* @get_symbol_from_table(%struct.SymbolTable* %table, %struct.PathEx %tmp27)
	store %struct.SymbolTableEntry* %tmp28, %struct.SymbolTableEntry** %v1
; Variable p is out.
	br label %endif2
endif2:
	%tmp29 = load %struct.SymbolTableEntry*, %struct.SymbolTableEntry** %v1
	%tmp30 = icmp eq %struct.SymbolTableEntry* %tmp29, null
	br i1 %tmp30, label %then3, label %endif3
then3:
	%tmp31 = load %struct.PrimitiveTypeInfo*, %struct.PrimitiveTypeInfo** @VOID_TYPE
	store i32 0, i32* %v2
	%tmp32 = getelementptr inbounds %struct.CompilerType, %struct.CompilerType* %v2, i32 0, i32 1
	store i8* %tmp31, i8** %tmp32
	%tmp33 = load %struct.CompilerType, %struct.CompilerType* %v2
	br label %func_exit
; Variable x is out.
endif3:
	%tmp34 = load %struct.SymbolTableEntry*, %struct.SymbolTableEntry** %v1
	%tmp35 = ptrtoint %struct.SymbolTableEntry* %tmp34 to i64
	%tmp36 = load %struct.SymbolTableEntry*, %struct.SymbolTableEntry** %table
	%tmp37 = ptrtoint %struct.SymbolTableEntry* %tmp36 to i64
	%tmp38 = sub i64 %tmp35, %tmp37
	%tmp39 = udiv i64 %tmp38, 40
	%tmp40 = trunc i64 %tmp39 to i32
	%tmp41 = zext i32 %tmp40 to i64
	%tmp42 = inttoptr i64 %tmp41 to i8*
	store i32 2, i32* %v3
	%tmp43 = getelementptr inbounds %struct.CompilerType, %struct.CompilerType* %v3, i32 0, i32 1
	store i8* %tmp42, i8** %tmp43
	%tmp44 = load %struct.CompilerType, %struct.CompilerType* %v3
	br label %func_exit
; Variable x is out.
; Variable p is out.
else0:
	%tmp45 = load i32, i32* %type
	%tmp46 = icmp eq i32 %tmp45, 1
	br i1 %tmp46, label %then4, label %else4
then4:
	%tmp47 = getelementptr inbounds %struct.Type, %struct.Type* %type, i32 0, i32 1
	%tmp48 = load i8*, i8** %tmp47
	%tmp49 = getelementptr inbounds %struct.PointerType, %struct.PointerType* %tmp48, i32 0, i32 1
	%tmp50 = call %struct.CompilerType @get_compiler_type_internal(%struct.Type* %tmp49, %struct.Path* %l_path, %struct.Path* %g_path, %struct.SymbolTable* %table)
	%tmp51 = call i8* @mem.malloc(i64 24)
	%tmp52 = load i8, i8* %tmp48
	store i8 %tmp52, i8* %tmp51
	%tmp53 = getelementptr inbounds %struct.PointerCompilerType, %struct.PointerCompilerType* %tmp51, i32 0, i32 1
	store %struct.CompilerType %tmp50, %struct.CompilerType* %tmp53
	store i32 1, i32* %v4
	%tmp54 = getelementptr inbounds %struct.CompilerType, %struct.CompilerType* %v4, i32 0, i32 1
	store i8* %tmp51, i8** %tmp54
	%tmp55 = load %struct.CompilerType, %struct.CompilerType* %v4
	br label %func_exit
; Variable x is out.
; Variable inner is out.
else4:
	%tmp56 = load i32, i32* %type
	%tmp57 = icmp eq i32 %tmp56, 3
	br i1 %tmp57, label %then5, label %else5
then5:
	%tmp58 = getelementptr inbounds %struct.Type, %struct.Type* %type, i32 0, i32 1
	%tmp59 = load i8*, i8** %tmp58
	%tmp60 = getelementptr inbounds %struct.NamespaceLinkType, %struct.NamespaceLinkType* %tmp59, i32 0, i32 1
	%tmp61 = call %struct.CompilerType @get_compiler_type_internal(%struct.Type* %tmp60, %struct.Path* %tmp59, %struct.Path* %g_path, %struct.SymbolTable* %table)
	br label %func_exit
else5:
	%tmp62 = load i32, i32* %type
	%tmp63 = icmp eq i32 %tmp62, 4
	br i1 %tmp63, label %then6, label %endif6
then6:
	%tmp64 = getelementptr inbounds %struct.Type, %struct.Type* %type, i32 0, i32 1
	%tmp65 = load i8*, i8** %tmp64
	%tmp69 = load i16, i16* %tmp65
	%tmp70 = getelementptr inbounds %struct.SymbolTable, %struct.SymbolTable* %table, i32 0, i32 1
	%tmp71 = getelementptr inbounds %struct.SymbolTable, %struct.SymbolTable* %table, i32 0, i32 1
	%tmp72 = load %"struct.vector.Vec<%struct.string.String>"*, %"struct.vector.Vec<%struct.string.String>"** %tmp71
	%tmp73 = load %struct.string.String*, %struct.string.String** %tmp72
	%tmp74 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp73, i16 %tmp69
	%tmp75 = load i8*, i8** %tmp74
	%tmp76 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp74, i32 0, i32 1
	%tmp77 = load i32, i32* %tmp76
	%tmp78 = call i32 @find_primitive_type(i8* %tmp75, i32 %tmp77)
	%tmp79 = icmp ne i32 %tmp78, -1
	br i1 %tmp79, label %then7, label %endif7
then7:
	call void @process.throw(i8* @.str.286)
	br label %endif7
endif7:
	%tmp80 = load i16, i16* %tmp65
	%tmp81 = call %struct.PathEx @path_to_path_ex_name(%struct.Path* %l_path, i16 %tmp80)
	%tmp82 = call %struct.SymbolTableEntry* @get_symbol_from_table(%struct.SymbolTable* %table, %struct.PathEx %tmp81)
	store %struct.SymbolTableEntry* %tmp82, %struct.SymbolTableEntry** %v5
	%tmp83 = load %struct.SymbolTableEntry*, %struct.SymbolTableEntry** %v5
	%tmp84 = icmp eq %struct.SymbolTableEntry* %tmp83, null
	br i1 %tmp84, label %then8, label %endif8
then8:
	%tmp85 = load i16, i16* %tmp65
	%tmp86 = call %struct.PathEx @path_to_path_ex_name(%struct.Path* %g_path, i16 %tmp85)
	%tmp87 = call %struct.SymbolTableEntry* @get_symbol_from_table(%struct.SymbolTable* %table, %struct.PathEx %tmp86)
	store %struct.SymbolTableEntry* %tmp87, %struct.SymbolTableEntry** %v5
; Variable p is out.
	br label %endif8
endif8:
	%tmp88 = load %struct.SymbolTableEntry*, %struct.SymbolTableEntry** %v5
	%tmp89 = icmp eq %struct.SymbolTableEntry* %tmp88, null
	br i1 %tmp89, label %then9, label %endif9
then9:
	call void @process.throw(i8* @.str.287)
	br label %endif9
endif9:
	%tmp90 = load %struct.SymbolTableEntry*, %struct.SymbolTableEntry** %v5
	%tmp91 = ptrtoint %struct.SymbolTableEntry* %tmp90 to i64
	%tmp92 = load %struct.SymbolTableEntry*, %struct.SymbolTableEntry** %table
	%tmp93 = ptrtoint %struct.SymbolTableEntry* %tmp92 to i64
	%tmp94 = sub i64 %tmp91, %tmp93
	%tmp95 = udiv i64 %tmp94, 40
	%tmp96 = trunc i64 %tmp95 to i32
	%tmp97 = call %"struct.vector.Vec<%struct.CompilerType>" @"vector.new<%struct.CompilerType>"()
	store %"struct.vector.Vec<%struct.CompilerType>" %tmp97, %"struct.vector.Vec<%struct.CompilerType>"* %v6
	%tmp98 = getelementptr inbounds %struct.GenericType, %struct.GenericType* %tmp65, i32 0, i32 1
	%tmp99 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %tmp98, i32 0, i32 1
	%tmp100 = load i32, i32* %tmp99
	store i32 0, i32* %v7
	br label %loop_cond10
loop_cond10:
	%tmp101 = load i32, i32* %v7
	%tmp102 = getelementptr inbounds %struct.GenericType, %struct.GenericType* %tmp65, i32 0, i32 1
	%tmp103 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %tmp102, i32 0, i32 1
	%tmp104 = load i32, i32* %tmp103
	%tmp105 = icmp uge i32 %tmp101, %tmp104
	br i1 %tmp105, label %then11, label %endif11
then11:
	br label %loop_body10_exit
endif11:
	%tmp107 = load i32, i32* %v7
	%tmp108 = getelementptr inbounds %struct.GenericType, %struct.GenericType* %tmp65, i32 0, i32 1
	%tmp109 = load %struct.Type*, %struct.Type** %tmp108
	%tmp110 = getelementptr inbounds %struct.Type, %struct.Type* %tmp109, i32 %tmp107
	%tmp111 = call %struct.CompilerType @get_compiler_type(%struct.Type* %tmp110, %struct.Path* %g_path, %struct.SymbolTable* %table)
	call void @"vector.push<%struct.CompilerType>"(%"struct.vector.Vec<%struct.CompilerType>"* %v6, %struct.CompilerType %tmp111)
	%tmp112 = load i32, i32* %v7
	%tmp113 = add i32 %tmp112, 1
	store i32 %tmp113, i32* %v7
	br label %loop_cond10
loop_body10_exit:
	%tmp114 = load %struct.SymbolTableEntry*, %struct.SymbolTableEntry** %v5
	%tmp115 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp114, i32 0, i32 2
	%tmp116 = load i8*, i8** %tmp115
	store i32 65535, i32* %v8
	%tmp117 = getelementptr inbounds %struct.GenericStructSymbolTableEntry, %struct.GenericStructSymbolTableEntry* %tmp116, i32 0, i32 2
	%tmp118 = getelementptr inbounds %"struct.vector.Vec<%struct.vector.Vec<%struct.CompilerType>>", %"struct.vector.Vec<%struct.vector.Vec<%struct.CompilerType>>"* %tmp117, i32 0, i32 1
	%tmp119 = load i32, i32* %tmp118
	store i32 0, i32* %v9
	br label %loop_cond12
loop_cond12:
	%tmp120 = load i32, i32* %v9
	%tmp121 = getelementptr inbounds %struct.GenericStructSymbolTableEntry, %struct.GenericStructSymbolTableEntry* %tmp116, i32 0, i32 2
	%tmp122 = getelementptr inbounds %"struct.vector.Vec<%struct.vector.Vec<%struct.CompilerType>>", %"struct.vector.Vec<%struct.vector.Vec<%struct.CompilerType>>"* %tmp121, i32 0, i32 1
	%tmp123 = load i32, i32* %tmp122
	%tmp124 = icmp uge i32 %tmp120, %tmp123
	br i1 %tmp124, label %then13, label %endif13
then13:
	br label %loop_body12_exit
endif13:
	%tmp125 = load i32, i32* %v9
	%tmp126 = add i32 %tmp125, 1
	store i32 %tmp126, i32* %v9
	br label %loop_cond12
loop_body12_exit:
	%tmp127 = load i32, i32* %v8
	%tmp128 = icmp eq i32 %tmp127, 65535
	br i1 %tmp128, label %then14, label %else14
then14:
	%tmp129 = getelementptr inbounds %struct.GenericStructSymbolTableEntry, %struct.GenericStructSymbolTableEntry* %tmp116, i32 0, i32 2
	%tmp130 = getelementptr inbounds %"struct.vector.Vec<%struct.vector.Vec<%struct.CompilerType>>", %"struct.vector.Vec<%struct.vector.Vec<%struct.CompilerType>>"* %tmp129, i32 0, i32 1
	%tmp131 = load i32, i32* %tmp130
	store i32 %tmp131, i32* %v8
	%tmp132 = load i32, i32* %v8
	%tmp133 = zext i32 %tmp132 to i64
	call void @console.println_u64(i64 %tmp133)
	%tmp134 = getelementptr inbounds %struct.GenericStructSymbolTableEntry, %struct.GenericStructSymbolTableEntry* %tmp116, i32 0, i32 2
	%tmp135 = load %"struct.vector.Vec<%struct.CompilerType>", %"struct.vector.Vec<%struct.CompilerType>"* %v6
	call void @"vector.push<%struct.vector.Vec<%struct.CompilerType>>"(%"struct.vector.Vec<%struct.vector.Vec<%struct.CompilerType>>"* %tmp134, %"struct.vector.Vec<%struct.CompilerType>" %tmp135)
	br label %endif14
else14:
	call void @"vector.free<%struct.CompilerType>"(%"struct.vector.Vec<%struct.CompilerType>"* %v6)
	br label %endif14
endif14:
	%tmp136 = call i8* @mem.malloc(i64 8)
	store i32 %tmp96, i32* %tmp136
	%tmp137 = getelementptr inbounds %struct.GenericImplementationCompilerType, %struct.GenericImplementationCompilerType* %tmp136, i32 0, i32 1
	%tmp138 = load i32, i32* %v8
	store i32 %tmp138, i32* %tmp137
	store i32 4, i32* %v10
	%tmp139 = getelementptr inbounds %struct.CompilerType, %struct.CompilerType* %v10, i32 0, i32 1
	store i8* %tmp136, i8** %tmp139
	%tmp140 = load %struct.CompilerType, %struct.CompilerType* %v10
	br label %func_exit
; Variable x is out.
; Variable c is out.
; Variable p is out.
endif6:
	br label %endif0
endif0:
	%tmp141 = load %struct.PrimitiveTypeInfo*, %struct.PrimitiveTypeInfo** @VOID_TYPE
	store i32 0, i32* %v11
	%tmp142 = getelementptr inbounds %struct.CompilerType, %struct.CompilerType* %v11, i32 0, i32 1
	store i8* %tmp141, i8** %tmp142
	%tmp143 = load %struct.CompilerType, %struct.CompilerType* %v11
	br label %func_exit
func_exit:
; Variable x is out.
	%tmp144 = phi %struct.CompilerType [%tmp20, %then1], [%tmp33, %then3], [%tmp44, %endif3], [%tmp55, %then4], [%tmp61, %then5], [%tmp140, %endif14], [%tmp143, %endif0]
	ret %struct.CompilerType %tmp144
}
define i1 @get_compiler_type_generic_internal(%struct.Type* %type, %struct.Path* %l_path, %struct.Path* %g_path, %struct.SymbolTable* %table, %"struct.vector.Vec<ui16>"* %generics, %struct.CompilerType* %output){
	%v0 = alloca %struct.CompilerType
	%v1 = alloca i32
	%v2 = alloca %struct.CompilerType
	%v3 = alloca %struct.PathEx
	%v4 = alloca %struct.CompilerType
	%v5 = alloca %struct.PathEx
	%v6 = alloca %struct.CompilerType
	%v7 = alloca %struct.CompilerType
	%v8 = alloca %struct.CompilerType
	%v9 = alloca %struct.CompilerType
	%v10 = alloca %struct.CompilerType
	%tmp0 = load i32, i32* %type
	%tmp1 = icmp eq i32 %tmp0, 0
	br i1 %tmp1, label %then0, label %else0
then0:
	%tmp2 = getelementptr inbounds %struct.Type, %struct.Type* %type, i32 0, i32 1
	%tmp3 = load i8*, i8** %tmp2
	%tmp7 = load i16, i16* %tmp3
	%tmp8 = getelementptr inbounds %struct.SymbolTable, %struct.SymbolTable* %table, i32 0, i32 1
	%tmp9 = getelementptr inbounds %struct.SymbolTable, %struct.SymbolTable* %table, i32 0, i32 1
	%tmp10 = load %"struct.vector.Vec<%struct.string.String>"*, %"struct.vector.Vec<%struct.string.String>"** %tmp9
	%tmp11 = load %struct.string.String*, %struct.string.String** %tmp10
	%tmp12 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp11, i16 %tmp7
	%tmp13 = load i8*, i8** %tmp12
	%tmp14 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp12, i32 0, i32 1
	%tmp15 = load i32, i32* %tmp14
	%tmp16 = call i32 @find_primitive_type(i8* %tmp13, i32 %tmp15)
	%tmp17 = icmp ne i32 %tmp16, -1
	br i1 %tmp17, label %then1, label %endif1
then1:
	%tmp18 = getelementptr inbounds [15 x %struct.PrimitiveTypeInfo], [15 x %struct.PrimitiveTypeInfo]* @PRIMITIVE_TYPES_INFO, i32 0, i32 %tmp16
	store i32 0, i32* %v0
	%tmp19 = getelementptr inbounds %struct.CompilerType, %struct.CompilerType* %v0, i32 0, i32 1
	store i8* %tmp18, i8** %tmp19
	%tmp20 = load %struct.CompilerType, %struct.CompilerType* %v0
	store %struct.CompilerType %tmp20, %struct.CompilerType* %output
	br label %func_exit
; Variable x is out.
endif1:
	%tmp21 = getelementptr inbounds %"struct.vector.Vec<ui16>", %"struct.vector.Vec<ui16>"* %generics, i32 0, i32 1
	%tmp22 = load i32, i32* %tmp21
	store i32 0, i32* %v1
	br label %loop_cond2
loop_cond2:
	%tmp23 = load i32, i32* %v1
	%tmp24 = getelementptr inbounds %"struct.vector.Vec<ui16>", %"struct.vector.Vec<ui16>"* %generics, i32 0, i32 1
	%tmp25 = load i32, i32* %tmp24
	%tmp26 = icmp uge i32 %tmp23, %tmp25
	br i1 %tmp26, label %then3, label %endif3
then3:
	br label %loop_body2_exit
endif3:
	%tmp27 = load i32, i32* %v1
	%tmp28 = load i16*, i16** %generics
	%tmp29 = getelementptr inbounds i16, i16* %tmp28, i32 %tmp27
	%tmp30 = load i16, i16* %tmp29
	%tmp31 = load i16, i16* %tmp3
	%tmp32 = icmp eq i16 %tmp30, %tmp31
	br i1 %tmp32, label %then4, label %endif4
then4:
	%tmp33 = load i16, i16* %tmp3
	%tmp34 = zext i16 %tmp33 to i64
	%tmp35 = inttoptr i64 %tmp34 to i8*
	store i32 3, i32* %v2
	%tmp36 = getelementptr inbounds %struct.CompilerType, %struct.CompilerType* %v2, i32 0, i32 1
	store i8* %tmp35, i8** %tmp36
	%tmp37 = load %struct.CompilerType, %struct.CompilerType* %v2
	store %struct.CompilerType %tmp37, %struct.CompilerType* %output
	br label %func_exit
; Variable x is out.
endif4:
	%tmp38 = load i32, i32* %v1
	%tmp39 = add i32 %tmp38, 1
	store i32 %tmp39, i32* %v1
	br label %loop_cond2
loop_body2_exit:
	%tmp40 = load i16, i16* %tmp3
	%tmp41 = call %struct.PathEx @path_to_path_ex_name(%struct.Path* %l_path, i16 %tmp40)
	store %struct.PathEx %tmp41, %struct.PathEx* %v3
	%tmp42 = load %struct.PathEx, %struct.PathEx* %v3
	%tmp43 = call %struct.SymbolTableEntry* @get_symbol_from_table(%struct.SymbolTable* %table, %struct.PathEx %tmp42)
	%tmp44 = icmp ne %struct.SymbolTableEntry* %tmp43, null
	br i1 %tmp44, label %then5, label %endif5
then5:
	%tmp45 = ptrtoint %struct.SymbolTableEntry* %tmp43 to i64
	%tmp46 = load %struct.SymbolTableEntry*, %struct.SymbolTableEntry** %table
	%tmp47 = ptrtoint %struct.SymbolTableEntry* %tmp46 to i64
	%tmp48 = sub i64 %tmp45, %tmp47
	%tmp49 = udiv i64 %tmp48, 40
	%tmp50 = trunc i64 %tmp49 to i32
	%tmp51 = zext i32 %tmp50 to i64
	%tmp52 = inttoptr i64 %tmp51 to i8*
	store i32 2, i32* %v4
	%tmp53 = getelementptr inbounds %struct.CompilerType, %struct.CompilerType* %v4, i32 0, i32 1
	store i8* %tmp52, i8** %tmp53
	%tmp54 = load %struct.CompilerType, %struct.CompilerType* %v4
	store %struct.CompilerType %tmp54, %struct.CompilerType* %output
	br label %func_exit
; Variable x is out.
endif5:
	%tmp55 = load i16, i16* %tmp3
	%tmp56 = call %struct.PathEx @path_to_path_ex_name(%struct.Path* %g_path, i16 %tmp55)
; Variable p is out.
	store %struct.PathEx %tmp56, %struct.PathEx* %v5
	%tmp57 = load %struct.PathEx, %struct.PathEx* %v5
	%tmp58 = call %struct.SymbolTableEntry* @get_symbol_from_table(%struct.SymbolTable* %table, %struct.PathEx %tmp57)
	%tmp59 = icmp ne %struct.SymbolTableEntry* %tmp58, null
	br i1 %tmp59, label %then6, label %endif6
then6:
	%tmp60 = ptrtoint %struct.SymbolTableEntry* %tmp58 to i64
	%tmp61 = load %struct.SymbolTableEntry*, %struct.SymbolTableEntry** %table
	%tmp62 = ptrtoint %struct.SymbolTableEntry* %tmp61 to i64
	%tmp63 = sub i64 %tmp60, %tmp62
	%tmp64 = udiv i64 %tmp63, 40
	%tmp65 = trunc i64 %tmp64 to i32
	%tmp66 = zext i32 %tmp65 to i64
	%tmp67 = inttoptr i64 %tmp66 to i8*
	store i32 2, i32* %v6
	%tmp68 = getelementptr inbounds %struct.CompilerType, %struct.CompilerType* %v6, i32 0, i32 1
	store i8* %tmp67, i8** %tmp68
	%tmp69 = load %struct.CompilerType, %struct.CompilerType* %v6
	store %struct.CompilerType %tmp69, %struct.CompilerType* %output
	br label %func_exit
; Variable x is out.
endif6:
; Variable p is out.
	br label %endif0
else0:
	%tmp70 = load i32, i32* %type
	%tmp71 = icmp eq i32 %tmp70, 1
	br i1 %tmp71, label %then7, label %else7
then7:
	%tmp72 = getelementptr inbounds %struct.Type, %struct.Type* %type, i32 0, i32 1
	%tmp73 = load i8*, i8** %tmp72
	%tmp74 = getelementptr inbounds %struct.PointerType, %struct.PointerType* %tmp73, i32 0, i32 1
	%tmp75 = call i1 @get_compiler_type_generic_internal(%struct.Type* %tmp74, %struct.Path* %l_path, %struct.Path* %g_path, %struct.SymbolTable* %table, %"struct.vector.Vec<ui16>"* %generics, %struct.CompilerType* %v7)
	%tmp76 = call i8* @mem.malloc(i64 24)
	%tmp77 = load i8, i8* %tmp73
	store i8 %tmp77, i8* %tmp76
	%tmp78 = getelementptr inbounds %struct.PointerCompilerType, %struct.PointerCompilerType* %tmp76, i32 0, i32 1
	%tmp79 = load %struct.CompilerType, %struct.CompilerType* %v7
	store %struct.CompilerType %tmp79, %struct.CompilerType* %tmp78
	store i32 1, i32* %v8
	%tmp80 = getelementptr inbounds %struct.CompilerType, %struct.CompilerType* %v8, i32 0, i32 1
	store i8* %tmp76, i8** %tmp80
	%tmp81 = load %struct.CompilerType, %struct.CompilerType* %v8
	store %struct.CompilerType %tmp81, %struct.CompilerType* %output
	br label %func_exit
; Variable x is out.
; Variable inner is out.
else7:
	%tmp82 = load i32, i32* %type
	%tmp83 = icmp eq i32 %tmp82, 3
	br i1 %tmp83, label %then8, label %endif8
then8:
	%tmp84 = getelementptr inbounds %struct.Type, %struct.Type* %type, i32 0, i32 1
	%tmp85 = load i8*, i8** %tmp84
	%tmp86 = getelementptr inbounds %struct.NamespaceLinkType, %struct.NamespaceLinkType* %tmp85, i32 0, i32 1
	%tmp87 = call i1 @get_compiler_type_generic_internal(%struct.Type* %tmp86, %struct.Path* %tmp85, %struct.Path* %g_path, %struct.SymbolTable* %table, %"struct.vector.Vec<ui16>"* %generics, %struct.CompilerType* %v9)
	%tmp88 = load %struct.CompilerType, %struct.CompilerType* %v9
	store %struct.CompilerType %tmp88, %struct.CompilerType* %output
	br label %func_exit
; Variable inner is out.
endif8:
	br label %endif0
endif0:
	%tmp89 = load %struct.PrimitiveTypeInfo*, %struct.PrimitiveTypeInfo** @DEFAULT_INTEGER_TYPE
	store i32 0, i32* %v10
	%tmp90 = getelementptr inbounds %struct.CompilerType, %struct.CompilerType* %v10, i32 0, i32 1
	store i8* %tmp89, i8** %tmp90
	%tmp91 = load %struct.CompilerType, %struct.CompilerType* %v10
	store %struct.CompilerType %tmp91, %struct.CompilerType* %output
	br label %func_exit
func_exit:
; Variable x is out.
	%tmp92 = phi i1 [false, %then1], [true, %then4], [false, %then5], [false, %then6], [%tmp75, %then7], [%tmp87, %then8], [false, %endif0]
	ret i1 %tmp92
}
define i1 @get_compiler_type_generic(%struct.Type* %type, %struct.Path* %g_path, %struct.SymbolTable* %table, %"struct.vector.Vec<ui16>"* %generics, %struct.CompilerType* %output){
	%v0 = alloca %struct.Path
	store i8 0, i8* %v0
	%tmp0 = call i1 @get_compiler_type_generic_internal(%struct.Type* %type, %struct.Path* %v0, %struct.Path* %g_path, %struct.SymbolTable* %table, %"struct.vector.Vec<ui16>"* %generics, %struct.CompilerType* %output)
; Variable l_path is out.
	ret i1 %tmp0
}
define %struct.CompilerType @get_compiler_type(%struct.Type* %type, %struct.Path* %g_path, %struct.SymbolTable* %table){
	%v0 = alloca %struct.Path
	store i8 0, i8* %v0
	%tmp0 = call %struct.CompilerType @get_compiler_type_internal(%struct.Type* %type, %struct.Path* %v0, %struct.Path* %g_path, %struct.SymbolTable* %table)
; Variable l_path is out.
	ret %struct.CompilerType %tmp0
}
define i8 @get_binary_op(i8 %token){
	%tmp0 = icmp eq i8 %token, 16
	br i1 %tmp0, label %then0, label %endif0
then0:
	br label %func_exit
endif0:
	%tmp1 = icmp eq i8 %token, 17
	br i1 %tmp1, label %then1, label %endif1
then1:
	br label %func_exit
endif1:
	%tmp2 = icmp eq i8 %token, 18
	br i1 %tmp2, label %then2, label %endif2
then2:
	br label %func_exit
endif2:
	%tmp3 = icmp eq i8 %token, 19
	br i1 %tmp3, label %then3, label %endif3
then3:
	br label %func_exit
endif3:
	%tmp4 = icmp eq i8 %token, 20
	br i1 %tmp4, label %then4, label %endif4
then4:
	br label %func_exit
endif4:
	%tmp5 = icmp eq i8 %token, 15
	br i1 %tmp5, label %then5, label %endif5
then5:
	br label %func_exit
endif5:
	%tmp6 = icmp eq i8 %token, 22
	br i1 %tmp6, label %then6, label %endif6
then6:
	br label %func_exit
endif6:
	%tmp7 = icmp eq i8 %token, 23
	br i1 %tmp7, label %then7, label %endif7
then7:
	br label %func_exit
endif7:
	%tmp8 = icmp eq i8 %token, 28
	br i1 %tmp8, label %then8, label %endif8
then8:
	br label %func_exit
endif8:
	%tmp9 = icmp eq i8 %token, 29
	br i1 %tmp9, label %then9, label %endif9
then9:
	br label %func_exit
endif9:
	%tmp10 = icmp eq i8 %token, 26
	br i1 %tmp10, label %then10, label %endif10
then10:
	br label %func_exit
endif10:
	%tmp11 = icmp eq i8 %token, 27
	br i1 %tmp11, label %then11, label %endif11
then11:
	br label %func_exit
endif11:
	%tmp12 = icmp eq i8 %token, 25
	br i1 %tmp12, label %then12, label %endif12
then12:
	br label %func_exit
endif12:
	%tmp13 = icmp eq i8 %token, 24
	br i1 %tmp13, label %then13, label %endif13
then13:
	br label %func_exit
endif13:
	%tmp14 = icmp eq i8 %token, 32
	br i1 %tmp14, label %then14, label %endif14
then14:
	br label %func_exit
endif14:
	%tmp15 = icmp eq i8 %token, 31
	br i1 %tmp15, label %then15, label %endif15
then15:
	br label %func_exit
endif15:
	%tmp16 = icmp eq i8 %token, 33
	br i1 %tmp16, label %then16, label %endif16
then16:
	br label %func_exit
endif16:
	%tmp17 = icmp eq i8 %token, 34
	br i1 %tmp17, label %then17, label %endif17
then17:
	br label %func_exit
endif17:
	%tmp18 = icmp eq i8 %token, 35
	br i1 %tmp18, label %then18, label %endif18
then18:
	br label %func_exit
endif18:
	call void @process.throw(i8* @.str.288)
	br label %func_exit
func_exit:
	%tmp19 = phi i8 [0, %then0], [1, %then1], [2, %then2], [3, %then3], [4, %then4], [5, %then5], [6, %then6], [7, %then7], [8, %then8], [9, %then9], [10, %then10], [11, %then11], [12, %then12], [13, %then13], [14, %then14], [15, %then15], [16, %then16], [17, %then17], [18, %then18], [0, %endif18]
	ret i8 %tmp19
}
define void @free_type(%struct.Type %t){
	call void @process.throw(i8* @.str.289)
; Variable t is out.
	ret void
}
define %struct.Variable* @find_variable(i32 %name, %struct.Scope* %scope){
	%v0 = alloca i32
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.Variable>", %"struct.vector.Vec<%struct.Variable>"* %scope, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = getelementptr inbounds %"struct.vector.Vec<%struct.Variable>", %"struct.vector.Vec<%struct.Variable>"* %scope, i32 0, i32 1
	%tmp3 = load i32, i32* %tmp2
	%tmp4 = sub i32 %tmp3, 1
	store i32 %tmp4, i32* %v0
	br label %loop_start0
loop_start0:
	%tmp5 = load i32, i32* %v0
	%tmp6 = icmp ugt i32 %tmp5, 0
	br i1 %tmp6, label %endif1, label %else1
else1:
	br label %loop_body0_exit
endif1:
	%tmp7 = load i32, i32* %v0
	%tmp8 = sub i32 %tmp7, 1
	store i32 %tmp8, i32* %v0
	%tmp9 = load i32, i32* %v0
	%tmp10 = load %struct.Variable*, %struct.Variable** %scope
	%tmp11 = getelementptr inbounds %struct.Variable, %struct.Variable* %tmp10, i32 %tmp9
	br label %loop_start0
loop_body0_exit:
	ret %struct.Variable* null
}
define i32 @find_primitive_type(i8* %name, i32 %len){
	%tmp0 = icmp eq i32 %len, 2
	br i1 %tmp0, label %then0, label %endif0
then0:
	%tmp1 = call i32 @mem.compare(i8* %name, i8* @.str.290, i64 2)
	%tmp2 = icmp eq i32 %tmp1, 0
	br i1 %tmp2, label %then1, label %endif1
then1:
	br label %func_exit
endif1:
	%tmp3 = call i32 @mem.compare(i8* %name, i8* @.str.291, i64 2)
	%tmp4 = icmp eq i32 %tmp3, 0
	br i1 %tmp4, label %then2, label %endif2
then2:
	br label %func_exit
endif2:
	br label %endif0
endif0:
	%tmp5 = icmp eq i32 %len, 3
	br i1 %tmp5, label %then3, label %endif3
then3:
	%tmp6 = call i32 @mem.compare(i8* %name, i8* @.str.292, i64 3)
	%tmp7 = icmp eq i32 %tmp6, 0
	br i1 %tmp7, label %then4, label %endif4
then4:
	br label %func_exit
endif4:
	%tmp8 = call i32 @mem.compare(i8* %name, i8* @.str.293, i64 3)
	%tmp9 = icmp eq i32 %tmp8, 0
	br i1 %tmp9, label %then5, label %endif5
then5:
	br label %func_exit
endif5:
	%tmp10 = call i32 @mem.compare(i8* %name, i8* @.str.294, i64 3)
	%tmp11 = icmp eq i32 %tmp10, 0
	br i1 %tmp11, label %then6, label %endif6
then6:
	br label %func_exit
endif6:
	%tmp12 = call i32 @mem.compare(i8* %name, i8* @.str.295, i64 3)
	%tmp13 = icmp eq i32 %tmp12, 0
	br i1 %tmp13, label %then7, label %endif7
then7:
	br label %func_exit
endif7:
	%tmp14 = call i32 @mem.compare(i8* %name, i8* @.str.295, i64 3)
	%tmp15 = icmp eq i32 %tmp14, 0
	br i1 %tmp15, label %then8, label %endif8
then8:
	br label %func_exit
endif8:
	%tmp16 = call i32 @mem.compare(i8* %name, i8* @.str.296, i64 3)
	%tmp17 = icmp eq i32 %tmp16, 0
	br i1 %tmp17, label %then9, label %endif9
then9:
	br label %func_exit
endif9:
	%tmp18 = call i32 @mem.compare(i8* %name, i8* @.str.297, i64 3)
	%tmp19 = icmp eq i32 %tmp18, 0
	br i1 %tmp19, label %then10, label %endif10
then10:
	br label %func_exit
endif10:
	%tmp20 = call i32 @mem.compare(i8* %name, i8* @.str.298, i64 3)
	%tmp21 = icmp eq i32 %tmp20, 0
	br i1 %tmp21, label %then11, label %endif11
then11:
	br label %func_exit
endif11:
	%tmp22 = call i32 @mem.compare(i8* %name, i8* @.str.299, i64 3)
	%tmp23 = icmp eq i32 %tmp22, 0
	br i1 %tmp23, label %then12, label %endif12
then12:
	br label %func_exit
endif12:
	br label %endif3
endif3:
	%tmp24 = icmp eq i32 %len, 4
	br i1 %tmp24, label %then13, label %endif13
then13:
	%tmp25 = call i32 @mem.compare(i8* %name, i8* @.str.300, i64 4)
	%tmp26 = icmp eq i32 %tmp25, 0
	br i1 %tmp26, label %then14, label %endif14
then14:
	br label %func_exit
endif14:
	%tmp27 = call i32 @mem.compare(i8* %name, i8* @.str.301, i64 4)
	%tmp28 = icmp eq i32 %tmp27, 0
	br i1 %tmp28, label %then15, label %endif15
then15:
	br label %func_exit
endif15:
	br label %endif13
endif13:
	%tmp29 = icmp eq i32 %len, 5
	br i1 %tmp29, label %then16, label %endif16
then16:
	%tmp30 = call i32 @mem.compare(i8* %name, i8* @.str.302, i64 5)
	%tmp31 = icmp eq i32 %tmp30, 0
	br i1 %tmp31, label %then17, label %endif17
then17:
	br label %func_exit
endif17:
	%tmp32 = call i32 @mem.compare(i8* %name, i8* @.str.303, i64 5)
	%tmp33 = icmp eq i32 %tmp32, 0
	br i1 %tmp33, label %then18, label %endif18
then18:
	br label %func_exit
endif18:
	br label %endif16
endif16:
	br label %func_exit
func_exit:
	%tmp34 = phi i32 [2, %then1], [7, %then2], [3, %then4], [4, %then5], [5, %then6], [8, %then7], [9, %then8], [10, %then9], [12, %then10], [13, %then11], [14, %then12], [0, %then14], [1, %then15], [11, %then17], [6, %then18], [-1, %endif16]
	ret i32 %tmp34
}
define void @expect(%struct.TokenData* %tokens, i32* %index, i32 %len, i8 %expected, i8* %error_msg){
entry:
	%v0 = alloca i32
	%v1 = alloca %struct.string.String
	%v2 = alloca %struct.string.String
	%v3 = alloca i32
	%v4 = alloca %struct.string.String
	%tmp0 = load i32, i32* %index
	%tmp1 = icmp uge i32 %tmp0, %len
	br i1 %tmp1, label %logic_end_0, label %logic_rhs_0
logic_rhs_0:
	%tmp2 = load i32, i32* %index
	%tmp3 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp2
	%tmp4 = load i8, i8* %tmp3
	%tmp5 = icmp ne i8 %tmp4, %expected
	br label %logic_end_0
logic_end_0:
	%tmp6 = phi i1 [%tmp1, %entry], [%tmp5, %logic_rhs_0]
	br i1 %tmp6, label %then1, label %endif1
then1:
	store i32 0, i32* %v0
	br label %loop_cond2
loop_cond2:
	%tmp7 = load i32, i32* %v0
	%tmp8 = icmp uge i32 %tmp7, 5
	br i1 %tmp8, label %then3, label %endif3
then3:
	br label %loop_body2_exit
endif3:
	%tmp9 = load i32, i32* %index
	%tmp10 = load i32, i32* %v0
	%tmp11 = add i32 %tmp9, %tmp10
	%tmp12 = sub i32 %tmp11, 5
	%tmp13 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp12
	%tmp14 = call %struct.string.String @token_type_to_string(%struct.TokenData* %tmp13, %"struct.vector.Vec<%struct.string.String>"* null)
	store %struct.string.String %tmp14, %struct.string.String* %v1
	call void @console.write(i8* @.str.202, i32 4)
	call void @console.write_string(%struct.string.String* %v1)
	call void @console.write(i8* @.str.203, i32 5)
	call void @string.free(%struct.string.String* %v1)
	%tmp15 = load i32, i32* %v0
	%tmp16 = add i32 %tmp15, 1
	store i32 %tmp16, i32* %v0
	br label %loop_cond2
loop_body2_exit:
; Variable q is out.
	%tmp17 = load i32, i32* %index
	%tmp18 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp17
	%tmp19 = call %struct.string.String @token_type_to_string(%struct.TokenData* %tmp18, %"struct.vector.Vec<%struct.string.String>"* null)
	store %struct.string.String %tmp19, %struct.string.String* %v2
	call void @console.write(i8* @.str.304, i32 4)
	call void @console.write_string(%struct.string.String* %v2)
	call void @console.write(i8* @.str.305, i32 5)
	call void @string.free(%struct.string.String* %v2)
	store i32 0, i32* %v3
	br label %loop_cond4
loop_cond4:
	%tmp20 = load i32, i32* %v3
	%tmp21 = icmp uge i32 %tmp20, 5
	br i1 %tmp21, label %then5, label %endif5
then5:
	br label %loop_body4_exit
endif5:
	%tmp22 = load i32, i32* %index
	%tmp23 = load i32, i32* %v3
	%tmp24 = add i32 %tmp22, %tmp23
	%tmp25 = add i32 %tmp24, 1
	%tmp26 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp25
	%tmp27 = call %struct.string.String @token_type_to_string(%struct.TokenData* %tmp26, %"struct.vector.Vec<%struct.string.String>"* null)
	store %struct.string.String %tmp27, %struct.string.String* %v4
	call void @console.write(i8* @.str.202, i32 4)
	call void @console.write_string(%struct.string.String* %v4)
	call void @console.write(i8* @.str.203, i32 5)
	call void @string.free(%struct.string.String* %v4)
	%tmp28 = load i32, i32* %v3
	%tmp29 = add i32 %tmp28, 1
	store i32 %tmp29, i32* %v3
	br label %loop_cond4
loop_body4_exit:
; Variable q is out.
	call void @process.throw(i8* %error_msg)
; Variable q is out.
	br label %endif1
endif1:
	%tmp30 = load i32, i32* %index
	%tmp31 = add i32 %tmp30, 1
	store i32 %tmp31, i32* %index
	ret void
}
define void @exit_scope(%struct.Scope* %scope){
	%v0 = alloca i32
	%v1 = alloca i32
	%v2 = alloca i32
	store i32 0, i32* %v0
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.Variable>", %"struct.vector.Vec<%struct.Variable>"* %scope, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	store i32 %tmp1, i32* %v1
	%tmp2 = getelementptr inbounds %struct.Scope, %struct.Scope* %scope, i32 0, i32 1
	%tmp3 = getelementptr inbounds %"struct.vector.Vec<ui32>", %"struct.vector.Vec<ui32>"* %tmp2, i32 0, i32 1
	%tmp4 = load i32, i32* %tmp3
	%tmp5 = icmp ne i32 %tmp4, 0
	br i1 %tmp5, label %then0, label %endif0
then0:
	%tmp6 = getelementptr inbounds %struct.Scope, %struct.Scope* %scope, i32 0, i32 1
	%tmp7 = call i32 @"vector.pop<ui32>"(%"struct.vector.Vec<ui32>"* %tmp6)
	store i32 %tmp7, i32* %v0
	br label %endif0
endif0:
	%tmp8 = load i32, i32* %v1
	%tmp9 = sub i32 %tmp8, 1
	store i32 %tmp9, i32* %v2
	br label %loop_start1
loop_start1:
	%tmp10 = load i32, i32* %v2
	%tmp11 = load i32, i32* %v0
	%tmp12 = icmp ugt i32 %tmp10, %tmp11
	br i1 %tmp12, label %endif2, label %else2
else2:
	br label %loop_body1_exit
endif2:
	%tmp13 = load i32, i32* %v2
	%tmp14 = sub i32 %tmp13, 1
	store i32 %tmp14, i32* %v2
	%tmp15 = call %struct.Variable @"vector.pop<%struct.Variable>"(%"struct.vector.Vec<%struct.Variable>"* %scope)
	br label %loop_start1
loop_body1_exit:
; Variable var is out.
	ret void
}
define void @enter_scope(%struct.Scope* %scope){
	%tmp0 = getelementptr inbounds %struct.Scope, %struct.Scope* %scope, i32 0, i32 1
	%tmp1 = getelementptr inbounds %"struct.vector.Vec<%struct.Variable>", %"struct.vector.Vec<%struct.Variable>"* %scope, i32 0, i32 1
	%tmp2 = load i32, i32* %tmp1
	call void @"vector.push<ui32>"(%"struct.vector.Vec<ui32>"* %tmp0, i32 %tmp2)
	ret void
}
define void @debug_dump_type(%struct.Type* %expr, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout){
	%v0 = alloca i8
	%v1 = alloca i32
	%v2 = alloca i8
	%v3 = alloca i32
	%tmp0 = load %struct.string.String*, %struct.string.String** %symbol_vector
	%tmp1 = load i32, i32* %expr
	%tmp2 = icmp eq i32 %tmp1, 0
	br i1 %tmp2, label %then0, label %else0
then0:
	%tmp3 = getelementptr inbounds %struct.Type, %struct.Type* %expr, i32 0, i32 1
	%tmp4 = load i8*, i8** %tmp3
	%tmp5 = load i16, i16* %tmp4
	%tmp6 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp0, i16 %tmp5
	%tmp7 = load i8*, i8** %tmp6
	%tmp8 = load i16, i16* %tmp4
	%tmp9 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp0, i16 %tmp8
	%tmp10 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp9, i32 0, i32 1
	%tmp11 = load i32, i32* %tmp10
	call void @string.append_str(%struct.string.String* %stdout, i8* %tmp7, i32 %tmp11)
	br label %endif0
else0:
	%tmp12 = load i32, i32* %expr
	%tmp13 = icmp eq i32 %tmp12, 1
	br i1 %tmp13, label %then1, label %else1
then1:
	%tmp14 = getelementptr inbounds %struct.Type, %struct.Type* %expr, i32 0, i32 1
	%tmp15 = load i8*, i8** %tmp14
	%tmp16 = getelementptr inbounds %struct.PointerType, %struct.PointerType* %tmp15, i32 0, i32 1
	%tmp17 = load i8, i8* %tmp15
	store i8 0, i8* %v0
	br label %loop_cond2
loop_cond2:
	%tmp18 = load i8, i8* %v0
	%tmp19 = load i8, i8* %tmp15
	%tmp20 = icmp uge i8 %tmp18, %tmp19
	br i1 %tmp20, label %then3, label %endif3
then3:
	br label %loop_body2_exit
endif3:
	call void @string.append(%struct.string.String* %stdout, i8 38)
	%tmp21 = load i8, i8* %v0
	%tmp22 = add i8 %tmp21, 1
	store i8 %tmp22, i8* %v0
	br label %loop_cond2
loop_body2_exit:
	call void @debug_dump_type(%struct.Type* %tmp16, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	br label %endif1
else1:
	%tmp23 = load i32, i32* %expr
	%tmp24 = icmp eq i32 %tmp23, 2
	br i1 %tmp24, label %then4, label %else4
then4:
	%tmp25 = getelementptr inbounds %struct.Type, %struct.Type* %expr, i32 0, i32 1
	%tmp26 = load i8*, i8** %tmp25
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.306, i32 3)
	%tmp27 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %tmp26, i32 0, i32 1
	%tmp28 = load i32, i32* %tmp27
	store i32 0, i32* %v1
	br label %loop_cond5
loop_cond5:
	%tmp29 = load i32, i32* %v1
	%tmp30 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %tmp26, i32 0, i32 1
	%tmp31 = load i32, i32* %tmp30
	%tmp32 = icmp uge i32 %tmp29, %tmp31
	br i1 %tmp32, label %then6, label %endif6
then6:
	br label %loop_body5_exit
endif6:
	%tmp33 = load i32, i32* %v1
	%tmp34 = load %struct.Type*, %struct.Type** %tmp26
	%tmp35 = getelementptr inbounds %struct.Type, %struct.Type* %tmp34, i32 %tmp33
	call void @debug_dump_type(%struct.Type* %tmp35, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	%tmp36 = load i32, i32* %v1
	%tmp37 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %tmp26, i32 0, i32 1
	%tmp38 = load i32, i32* %tmp37
	%tmp39 = sub i32 %tmp38, 1
	%tmp40 = icmp ne i32 %tmp36, %tmp39
	br i1 %tmp40, label %then7, label %endif7
then7:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.89, i32 2)
	br label %endif7
endif7:
	%tmp41 = load i32, i32* %v1
	%tmp42 = add i32 %tmp41, 1
	store i32 %tmp42, i32* %v1
	br label %loop_cond5
loop_body5_exit:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.307, i32 4)
	%tmp43 = getelementptr inbounds %struct.FunctionType, %struct.FunctionType* %tmp26, i32 0, i32 1
	call void @debug_dump_type(%struct.Type* %tmp43, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	br label %endif4
else4:
	%tmp44 = load i32, i32* %expr
	%tmp45 = icmp eq i32 %tmp44, 3
	br i1 %tmp45, label %then8, label %else8
then8:
	%tmp46 = getelementptr inbounds %struct.Type, %struct.Type* %expr, i32 0, i32 1
	%tmp47 = load i8*, i8** %tmp46
	%tmp48 = load i8, i8* %tmp47
	store i8 0, i8* %v2
	br label %loop_cond9
loop_cond9:
	%tmp49 = load i8, i8* %v2
	%tmp50 = load i8, i8* %tmp47
	%tmp51 = icmp uge i8 %tmp49, %tmp50
	br i1 %tmp51, label %then10, label %endif10
then10:
	br label %loop_body9_exit
endif10:
	%tmp52 = getelementptr inbounds %struct.Path, %struct.Path* %tmp47, i32 0, i32 1
	%tmp53 = load i8, i8* %v2
	%tmp54 = getelementptr inbounds [8 x i16], [8 x i16]* %tmp52, i32 0, i8 %tmp53
	%tmp55 = load i16, i16* %tmp54
	%tmp56 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp0, i16 %tmp55
	%tmp57 = load i8*, i8** %tmp56
	%tmp58 = getelementptr inbounds %struct.Path, %struct.Path* %tmp47, i32 0, i32 1
	%tmp59 = load i8, i8* %v2
	%tmp60 = getelementptr inbounds [8 x i16], [8 x i16]* %tmp58, i32 0, i8 %tmp59
	%tmp61 = load i16, i16* %tmp60
	%tmp62 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp0, i16 %tmp61
	%tmp63 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp62, i32 0, i32 1
	%tmp64 = load i32, i32* %tmp63
	call void @string.append_str(%struct.string.String* %stdout, i8* %tmp57, i32 %tmp64)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.111, i32 2)
	%tmp65 = load i8, i8* %v2
	%tmp66 = add i8 %tmp65, 1
	store i8 %tmp66, i8* %v2
	br label %loop_cond9
loop_body9_exit:
	%tmp67 = getelementptr inbounds %struct.NamespaceLinkType, %struct.NamespaceLinkType* %tmp47, i32 0, i32 1
	call void @debug_dump_type(%struct.Type* %tmp67, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	br label %endif8
else8:
	%tmp68 = load i32, i32* %expr
	%tmp69 = icmp eq i32 %tmp68, 4
	br i1 %tmp69, label %then11, label %else11
then11:
	%tmp70 = getelementptr inbounds %struct.Type, %struct.Type* %expr, i32 0, i32 1
	%tmp71 = load i8*, i8** %tmp70
	%tmp72 = load i16, i16* %tmp71
	%tmp73 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp0, i16 %tmp72
	%tmp74 = load i8*, i8** %tmp73
	%tmp75 = load i16, i16* %tmp71
	%tmp76 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp0, i16 %tmp75
	%tmp77 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp76, i32 0, i32 1
	%tmp78 = load i32, i32* %tmp77
	call void @string.append_str(%struct.string.String* %stdout, i8* %tmp74, i32 %tmp78)
	call void @string.append(%struct.string.String* %stdout, i8 60)
	%tmp79 = getelementptr inbounds %struct.GenericType, %struct.GenericType* %tmp71, i32 0, i32 1
	%tmp80 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %tmp79, i32 0, i32 1
	%tmp81 = load i32, i32* %tmp80
	store i32 0, i32* %v3
	br label %loop_cond12
loop_cond12:
	%tmp82 = load i32, i32* %v3
	%tmp83 = getelementptr inbounds %struct.GenericType, %struct.GenericType* %tmp71, i32 0, i32 1
	%tmp84 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %tmp83, i32 0, i32 1
	%tmp85 = load i32, i32* %tmp84
	%tmp86 = icmp uge i32 %tmp82, %tmp85
	br i1 %tmp86, label %then13, label %endif13
then13:
	br label %loop_body12_exit
endif13:
	%tmp88 = load i32, i32* %v3
	%tmp89 = getelementptr inbounds %struct.GenericType, %struct.GenericType* %tmp71, i32 0, i32 1
	%tmp90 = load %struct.Type*, %struct.Type** %tmp89
	%tmp91 = getelementptr inbounds %struct.Type, %struct.Type* %tmp90, i32 %tmp88
	call void @debug_dump_type(%struct.Type* %tmp91, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	%tmp92 = load i32, i32* %v3
	%tmp93 = getelementptr inbounds %struct.GenericType, %struct.GenericType* %tmp71, i32 0, i32 1
	%tmp94 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %tmp93, i32 0, i32 1
	%tmp95 = load i32, i32* %tmp94
	%tmp96 = sub i32 %tmp95, 1
	%tmp97 = icmp ne i32 %tmp92, %tmp96
	br i1 %tmp97, label %then14, label %endif14
then14:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.89, i32 2)
	br label %endif14
endif14:
	%tmp98 = load i32, i32* %v3
	%tmp99 = add i32 %tmp98, 1
	store i32 %tmp99, i32* %v3
	br label %loop_cond12
loop_body12_exit:
	call void @string.append(%struct.string.String* %stdout, i8 62)
	br label %endif11
else11:
	%tmp100 = load i32, i32* %expr
	%tmp101 = icmp eq i32 %tmp100, 5
	br i1 %tmp101, label %then15, label %endif15
then15:
	%tmp102 = getelementptr inbounds %struct.Type, %struct.Type* %expr, i32 0, i32 1
	%tmp103 = load i8*, i8** %tmp102
	call void @string.append(%struct.string.String* %stdout, i8 91)
	call void @debug_dump_type(%struct.Type* %tmp103, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.308, i32 2)
	%tmp104 = getelementptr inbounds %struct.ConstantSizeArrayType, %struct.ConstantSizeArrayType* %tmp103, i32 0, i32 1
	call void @debug_dump_expression(%struct.Expression* %tmp104, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	call void @string.append(%struct.string.String* %stdout, i8 93)
	br label %endif15
endif15:
	br label %endif11
endif11:
	br label %endif8
endif8:
	br label %endif4
endif4:
	br label %endif1
endif1:
	br label %endif0
endif0:
	ret void
}
define void @debug_dump_symbol_table(%struct.SymbolTable* %table, %struct.string.String* %stdout){
	%v0 = alloca i32
	%v1 = alloca %struct.PathEx
	%v2 = alloca i32
	%v3 = alloca %struct.string.String
	%v4 = alloca i32
	%v5 = alloca %struct.PathEx
	%v6 = alloca i32
	%v7 = alloca %struct.PathEx
	%v8 = alloca %struct.PathEx
	%v9 = alloca %struct.PathEx
	%v10 = alloca i32
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.SymbolTableEntry>", %"struct.vector.Vec<%struct.SymbolTableEntry>"* %table, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = load %struct.SymbolTableEntry*, %struct.SymbolTableEntry** %table
	%tmp3 = getelementptr inbounds %struct.SymbolTable, %struct.SymbolTable* %table, i32 0, i32 1
	%tmp4 = getelementptr inbounds %struct.SymbolTable, %struct.SymbolTable* %table, i32 0, i32 1
	%tmp5 = load %"struct.vector.Vec<%struct.string.String>"*, %"struct.vector.Vec<%struct.string.String>"** %tmp4
	%tmp6 = load %struct.string.String*, %struct.string.String** %tmp5
	store i32 0, i32* %v0
	br label %loop_cond0
loop_cond0:
	%tmp7 = load i32, i32* %v0
	%tmp8 = icmp uge i32 %tmp7, %tmp1
	br i1 %tmp8, label %then1, label %endif1
then1:
	br label %loop_body0_exit
endif1:
	%tmp9 = load i32, i32* %v0
	%tmp10 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp2, i32 %tmp9
	%tmp11 = load i32, i32* %tmp10
	%tmp12 = and i32 %tmp11, 8
	%tmp13 = icmp eq i32 %tmp12, 0
	br i1 %tmp13, label %then2, label %endif2
then2:
	br label %loop_body0
endif2:
	%tmp14 = load i32, i32* %v0
	%tmp15 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp2, i32 %tmp14
	%tmp16 = load i32, i32* %tmp15
	%tmp17 = and i32 %tmp16, 7
	%tmp18 = icmp eq i32 %tmp17, 4
	br i1 %tmp18, label %then3, label %else3
then3:
	%tmp19 = load i32, i32* %v0
	%tmp20 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp2, i32 %tmp19
	%tmp21 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp20, i32 0, i32 2
	%tmp22 = load i8*, i8** %tmp21
	%tmp23 = load i32, i32* %v0
	%tmp24 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp2, i32 %tmp23
	%tmp25 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp24, i32 0, i32 1
	%tmp26 = load %struct.PathEx, %struct.PathEx* %tmp25
	store %struct.PathEx %tmp26, %struct.PathEx* %v1
	%tmp27 = load i8, i8* %v1
	%tmp28 = sub i8 %tmp27, 1
	store i8 %tmp28, i8* %v1
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.309, i32 6)
	%tmp29 = load i32, i32* %v0
	%tmp30 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp2, i32 %tmp29
	%tmp31 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp30, i32 0, i32 1
	call void @append_path_ex(%struct.PathEx* %tmp31, %struct.string.String* %tmp6, %struct.string.String* %stdout)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.310, i32 2)
	call void @compiler_type_push(%struct.CompilerType* %tmp22, %struct.PathEx* %v1, %struct.SymbolTable* %table, %struct.string.String* %stdout)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.88, i32 2)
	%tmp32 = getelementptr inbounds %struct.EnumSymbolTableEntry, %struct.EnumSymbolTableEntry* %tmp22, i32 0, i32 1
	%tmp33 = getelementptr inbounds %"struct.vector.Vec<%struct.EnumDefinedField>", %"struct.vector.Vec<%struct.EnumDefinedField>"* %tmp32, i32 0, i32 1
	%tmp34 = load i32, i32* %tmp33
	store i32 0, i32* %v2
	br label %loop_cond4
loop_cond4:
	%tmp35 = load i32, i32* %v2
	%tmp36 = getelementptr inbounds %struct.EnumSymbolTableEntry, %struct.EnumSymbolTableEntry* %tmp22, i32 0, i32 1
	%tmp37 = getelementptr inbounds %"struct.vector.Vec<%struct.EnumDefinedField>", %"struct.vector.Vec<%struct.EnumDefinedField>"* %tmp36, i32 0, i32 1
	%tmp38 = load i32, i32* %tmp37
	%tmp39 = icmp uge i32 %tmp35, %tmp38
	br i1 %tmp39, label %then5, label %endif5
then5:
	br label %loop_body4_exit
endif5:
	%tmp41 = load i32, i32* %v2
	%tmp42 = getelementptr inbounds %struct.EnumSymbolTableEntry, %struct.EnumSymbolTableEntry* %tmp22, i32 0, i32 1
	%tmp43 = load %struct.EnumDefinedField*, %struct.EnumDefinedField** %tmp42
	%tmp44 = getelementptr inbounds %struct.EnumDefinedField, %struct.EnumDefinedField* %tmp43, i32 %tmp41
	%tmp45 = load i16, i16* %tmp44
	%tmp46 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp6, i16 %tmp45
	%tmp47 = load i8*, i8** %tmp46
	%tmp49 = load i32, i32* %v2
	%tmp50 = getelementptr inbounds %struct.EnumSymbolTableEntry, %struct.EnumSymbolTableEntry* %tmp22, i32 0, i32 1
	%tmp51 = load %struct.EnumDefinedField*, %struct.EnumDefinedField** %tmp50
	%tmp52 = getelementptr inbounds %struct.EnumDefinedField, %struct.EnumDefinedField* %tmp51, i32 %tmp49
	%tmp53 = load i16, i16* %tmp52
	%tmp54 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp6, i16 %tmp53
	%tmp55 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp54, i32 0, i32 1
	%tmp56 = load i32, i32* %tmp55
	call void @string.append_str(%struct.string.String* %stdout, i8* %tmp47, i32 %tmp56)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.310, i32 2)
	%tmp58 = load i32, i32* %v2
	%tmp59 = getelementptr inbounds %struct.EnumSymbolTableEntry, %struct.EnumSymbolTableEntry* %tmp22, i32 0, i32 1
	%tmp60 = load %struct.EnumDefinedField*, %struct.EnumDefinedField** %tmp59
	%tmp61 = getelementptr inbounds %struct.EnumDefinedField, %struct.EnumDefinedField* %tmp60, i32 %tmp58
	%tmp62 = getelementptr inbounds %struct.EnumDefinedField, %struct.EnumDefinedField* %tmp61, i32 0, i32 1
	%tmp63 = load i64, i64* %tmp62
	%tmp64 = call %struct.string.String @string_utils.u64_to_string(i64 %tmp63)
	store %struct.string.String %tmp64, %struct.string.String* %v3
	%tmp65 = load i8*, i8** %v3
	%tmp66 = getelementptr inbounds %struct.string.String, %struct.string.String* %v3, i32 0, i32 1
	%tmp67 = load i32, i32* %tmp66
	call void @string.append_str(%struct.string.String* %stdout, i8* %tmp65, i32 %tmp67)
	call void @string.free(%struct.string.String* %v3)
	%tmp68 = load i32, i32* %v2
	%tmp69 = getelementptr inbounds %struct.EnumSymbolTableEntry, %struct.EnumSymbolTableEntry* %tmp22, i32 0, i32 1
	%tmp70 = getelementptr inbounds %"struct.vector.Vec<%struct.EnumDefinedField>", %"struct.vector.Vec<%struct.EnumDefinedField>"* %tmp69, i32 0, i32 1
	%tmp71 = load i32, i32* %tmp70
	%tmp72 = sub i32 %tmp71, 1
	%tmp73 = icmp ne i32 %tmp68, %tmp72
	br i1 %tmp73, label %then6, label %endif6
then6:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.89, i32 2)
	br label %endif6
endif6:
	%tmp74 = load i32, i32* %v2
	%tmp75 = add i32 %tmp74, 1
	store i32 %tmp75, i32* %v2
	br label %loop_cond4
loop_body4_exit:
; Variable s is out.
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.90, i32 3)
; Variable loc is out.
	br label %endif3
else3:
	%tmp76 = load i32, i32* %v0
	%tmp77 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp2, i32 %tmp76
	%tmp78 = load i32, i32* %tmp77
	%tmp79 = and i32 %tmp78, 7
	%tmp80 = icmp eq i32 %tmp79, 2
	br i1 %tmp80, label %then7, label %else7
then7:
	%tmp81 = load i32, i32* %v0
	%tmp82 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp2, i32 %tmp81
	%tmp83 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp82, i32 0, i32 2
	%tmp84 = load i8*, i8** %tmp83
	call void @string.append(%struct.string.String* %stdout, i8 37)
	%tmp85 = getelementptr inbounds %struct.StructSymbolTableEntry, %struct.StructSymbolTableEntry* %tmp84, i32 0, i32 2
	%tmp86 = load i8*, i8** %tmp85
	%tmp87 = getelementptr inbounds %struct.StructSymbolTableEntry, %struct.StructSymbolTableEntry* %tmp84, i32 0, i32 2
	%tmp88 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp87, i32 0, i32 1
	%tmp89 = load i32, i32* %tmp88
	call void @string.append_str(%struct.string.String* %stdout, i8* %tmp86, i32 %tmp89)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.87, i32 8)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.88, i32 2)
	%tmp90 = getelementptr inbounds %"struct.vector.Vec<%struct.StructDefinedField>", %"struct.vector.Vec<%struct.StructDefinedField>"* %tmp84, i32 0, i32 1
	%tmp91 = load i32, i32* %tmp90
	store i32 0, i32* %v4
	br label %loop_cond8
loop_cond8:
	%tmp92 = load i32, i32* %v4
	%tmp93 = getelementptr inbounds %"struct.vector.Vec<%struct.StructDefinedField>", %"struct.vector.Vec<%struct.StructDefinedField>"* %tmp84, i32 0, i32 1
	%tmp94 = load i32, i32* %tmp93
	%tmp95 = icmp uge i32 %tmp92, %tmp94
	br i1 %tmp95, label %then9, label %endif9
then9:
	br label %loop_body8_exit
endif9:
	%tmp96 = load i32, i32* %v4
	%tmp97 = load %struct.StructDefinedField*, %struct.StructDefinedField** %tmp84
	%tmp98 = getelementptr inbounds %struct.StructDefinedField, %struct.StructDefinedField* %tmp97, i32 %tmp96
	%tmp99 = getelementptr inbounds %struct.StructDefinedField, %struct.StructDefinedField* %tmp98, i32 0, i32 1
	%tmp100 = load i32, i32* %v0
	%tmp101 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp2, i32 %tmp100
	%tmp102 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp101, i32 0, i32 1
	call void @compiler_type_push(%struct.CompilerType* %tmp99, %struct.PathEx* %tmp102, %struct.SymbolTable* %table, %struct.string.String* %stdout)
	%tmp103 = load i32, i32* %v4
	%tmp104 = getelementptr inbounds %"struct.vector.Vec<%struct.StructDefinedField>", %"struct.vector.Vec<%struct.StructDefinedField>"* %tmp84, i32 0, i32 1
	%tmp105 = load i32, i32* %tmp104
	%tmp106 = sub i32 %tmp105, 1
	%tmp107 = icmp ne i32 %tmp103, %tmp106
	br i1 %tmp107, label %then10, label %endif10
then10:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.89, i32 2)
	br label %endif10
endif10:
	%tmp108 = load i32, i32* %v4
	%tmp109 = add i32 %tmp108, 1
	store i32 %tmp109, i32* %v4
	br label %loop_cond8
loop_body8_exit:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.90, i32 3)
	br label %endif7
else7:
	%tmp110 = load i32, i32* %v0
	%tmp111 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp2, i32 %tmp110
	%tmp112 = load i32, i32* %tmp111
	%tmp113 = and i32 %tmp112, 7
	%tmp114 = icmp eq i32 %tmp113, 3
	br i1 %tmp114, label %then11, label %else11
then11:
	%tmp115 = load i32, i32* %v0
	%tmp116 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp2, i32 %tmp115
	%tmp117 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp116, i32 0, i32 2
	%tmp118 = load i8*, i8** %tmp117
	%tmp119 = load i32, i32* %v0
	%tmp120 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp2, i32 %tmp119
	%tmp121 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp120, i32 0, i32 1
	%tmp122 = load %struct.PathEx, %struct.PathEx* %tmp121
	store %struct.PathEx %tmp122, %struct.PathEx* %v5
	%tmp123 = load i8, i8* %v5
	%tmp124 = sub i8 %tmp123, 1
	store i8 %tmp124, i8* %v5
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.311, i32 8)
	%tmp125 = load i32, i32* %v0
	%tmp126 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp2, i32 %tmp125
	%tmp127 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp126, i32 0, i32 1
	call void @append_path_ex(%struct.PathEx* %tmp127, %struct.string.String* %tmp6, %struct.string.String* %stdout)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.88, i32 2)
	%tmp128 = getelementptr inbounds %"struct.vector.Vec<%struct.GenericStructDefinedField>", %"struct.vector.Vec<%struct.GenericStructDefinedField>"* %tmp118, i32 0, i32 1
	%tmp129 = load i32, i32* %tmp128
	store i32 0, i32* %v6
	br label %loop_cond12
loop_cond12:
	%tmp130 = load i32, i32* %v6
	%tmp131 = getelementptr inbounds %"struct.vector.Vec<%struct.GenericStructDefinedField>", %"struct.vector.Vec<%struct.GenericStructDefinedField>"* %tmp118, i32 0, i32 1
	%tmp132 = load i32, i32* %tmp131
	%tmp133 = icmp uge i32 %tmp130, %tmp132
	br i1 %tmp133, label %then13, label %endif13
then13:
	br label %loop_body12_exit
endif13:
	%tmp134 = load i32, i32* %v6
	%tmp135 = load %struct.GenericStructDefinedField*, %struct.GenericStructDefinedField** %tmp118
	%tmp136 = getelementptr inbounds %struct.GenericStructDefinedField, %struct.GenericStructDefinedField* %tmp135, i32 %tmp134
	%tmp137 = load i16, i16* %tmp136
	%tmp138 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp6, i16 %tmp137
	%tmp139 = load i8*, i8** %tmp138
	%tmp140 = load i32, i32* %v6
	%tmp141 = load %struct.GenericStructDefinedField*, %struct.GenericStructDefinedField** %tmp118
	%tmp142 = getelementptr inbounds %struct.GenericStructDefinedField, %struct.GenericStructDefinedField* %tmp141, i32 %tmp140
	%tmp143 = load i16, i16* %tmp142
	%tmp144 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp6, i16 %tmp143
	%tmp145 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp144, i32 0, i32 1
	%tmp146 = load i32, i32* %tmp145
	call void @string.append_str(%struct.string.String* %stdout, i8* %tmp139, i32 %tmp146)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.310, i32 2)
	%tmp147 = load i32, i32* %v6
	%tmp148 = load %struct.GenericStructDefinedField*, %struct.GenericStructDefinedField** %tmp118
	%tmp149 = getelementptr inbounds %struct.GenericStructDefinedField, %struct.GenericStructDefinedField* %tmp148, i32 %tmp147
	%tmp150 = getelementptr inbounds %struct.GenericStructDefinedField, %struct.GenericStructDefinedField* %tmp149, i32 0, i32 1
	call void @compiler_type_push(%struct.CompilerType* %tmp150, %struct.PathEx* %v5, %struct.SymbolTable* %table, %struct.string.String* %stdout)
	%tmp151 = load i32, i32* %v6
	%tmp152 = getelementptr inbounds %"struct.vector.Vec<%struct.GenericStructDefinedField>", %"struct.vector.Vec<%struct.GenericStructDefinedField>"* %tmp118, i32 0, i32 1
	%tmp153 = load i32, i32* %tmp152
	%tmp154 = sub i32 %tmp153, 1
	%tmp155 = icmp ne i32 %tmp151, %tmp154
	br i1 %tmp155, label %then14, label %endif14
then14:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.89, i32 2)
	br label %endif14
endif14:
	%tmp156 = load i32, i32* %v6
	%tmp157 = add i32 %tmp156, 1
	store i32 %tmp157, i32* %v6
	br label %loop_cond12
loop_body12_exit:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.90, i32 3)
; Variable loc is out.
	br label %endif11
else11:
	%tmp158 = load i32, i32* %v0
	%tmp159 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp2, i32 %tmp158
	%tmp160 = load i32, i32* %tmp159
	%tmp161 = and i32 %tmp160, 7
	%tmp162 = icmp eq i32 %tmp161, 6
	br i1 %tmp162, label %then15, label %else15
then15:
	%tmp163 = load i32, i32* %v0
	%tmp164 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp2, i32 %tmp163
	%tmp165 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp164, i32 0, i32 2
	%tmp166 = load i8*, i8** %tmp165
	%tmp167 = load i32, i32* %v0
	%tmp168 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp2, i32 %tmp167
	%tmp169 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp168, i32 0, i32 1
	%tmp170 = load %struct.PathEx, %struct.PathEx* %tmp169
	store %struct.PathEx %tmp170, %struct.PathEx* %v7
	%tmp171 = load i8, i8* %v7
	%tmp172 = sub i8 %tmp171, 1
	store i8 %tmp172, i8* %v7
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.312, i32 10)
	%tmp173 = load i32, i32* %v0
	%tmp174 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp2, i32 %tmp173
	%tmp175 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp174, i32 0, i32 1
	call void @append_path_ex(%struct.PathEx* %tmp175, %struct.string.String* %tmp6, %struct.string.String* %stdout)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.313, i32 3)
	call void @compiler_type_push(%struct.CompilerType* %tmp166, %struct.PathEx* %v7, %struct.SymbolTable* %table, %struct.string.String* %stdout)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.99, i32 1)
; Variable loc is out.
	br label %endif15
else15:
	%tmp176 = load i32, i32* %v0
	%tmp177 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp2, i32 %tmp176
	%tmp178 = load i32, i32* %tmp177
	%tmp179 = and i32 %tmp178, 7
	%tmp180 = icmp eq i32 %tmp179, 0
	br i1 %tmp180, label %then16, label %endif16
then16:
	%tmp181 = load i32, i32* %v0
	%tmp182 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp2, i32 %tmp181
	%tmp183 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp182, i32 0, i32 2
	%tmp184 = load i8*, i8** %tmp183
	%tmp185 = load i32, i32* %v0
	%tmp186 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp2, i32 %tmp185
	%tmp187 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp186, i32 0, i32 1
	%tmp188 = load %struct.PathEx, %struct.PathEx* %tmp187
	store %struct.PathEx %tmp188, %struct.PathEx* %v8
	%tmp189 = load i8, i8* %v8
	%tmp190 = sub i8 %tmp189, 1
	store i8 %tmp190, i8* %v8
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.314, i32 7)
	%tmp191 = getelementptr inbounds %struct.FunctionSymbolTableEntry, %struct.FunctionSymbolTableEntry* %tmp184, i32 0, i32 3
	%tmp192 = load i8, i8* %tmp191
	%tmp193 = and i8 %tmp192, 4
	%tmp194 = icmp ne i8 %tmp193, 0
	br i1 %tmp194, label %then17, label %endif17
then17:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.315, i32 10)
	br label %endif17
endif17:
	%tmp195 = getelementptr inbounds %struct.FunctionSymbolTableEntry, %struct.FunctionSymbolTableEntry* %tmp184, i32 0, i32 1
	call void @compiler_type_push(%struct.CompilerType* %tmp195, %struct.PathEx* %v8, %struct.SymbolTable* %table, %struct.string.String* %stdout)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.316, i32 2)
	%tmp196 = getelementptr inbounds %struct.FunctionSymbolTableEntry, %struct.FunctionSymbolTableEntry* %tmp184, i32 0, i32 3
	%tmp197 = load i8, i8* %tmp196
	%tmp198 = and i8 %tmp197, 4
	%tmp199 = icmp ne i8 %tmp198, 0
	br i1 %tmp199, label %then18, label %else18
then18:
	%tmp200 = load i32, i32* %v0
	%tmp201 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp2, i32 %tmp200
	%tmp202 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp201, i32 0, i32 1
	%tmp203 = load %struct.PathEx, %struct.PathEx* %tmp202
	store %struct.PathEx %tmp203, %struct.PathEx* %v9
	%tmp204 = getelementptr inbounds %struct.PathEx, %struct.PathEx* %v9, i32 0, i32 1
	%tmp205 = getelementptr inbounds %struct.PathEx, %struct.PathEx* %v9, i32 0, i32 1
	%tmp206 = load i8, i8* %v9
	%tmp207 = sub i8 %tmp206, 1
	%tmp208 = getelementptr inbounds [12 x i16], [12 x i16]* %tmp205, i32 0, i8 %tmp207
	%tmp209 = load i16, i16* %tmp208
	store i16 %tmp209, i16* %tmp204
	store i8 1, i8* %v9
	call void @append_path_ex(%struct.PathEx* %v9, %struct.string.String* %tmp6, %struct.string.String* %stdout)
; Variable q is out.
	br label %endif18
else18:
	%tmp210 = load i32, i32* %v0
	%tmp211 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp2, i32 %tmp210
	%tmp212 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp211, i32 0, i32 1
	call void @append_path_ex(%struct.PathEx* %tmp212, %struct.string.String* %tmp6, %struct.string.String* %stdout)
	br label %endif18
endif18:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.96, i32 1)
	%tmp213 = getelementptr inbounds %"struct.vector.Vec<%struct.StructDefinedField>", %"struct.vector.Vec<%struct.StructDefinedField>"* %tmp184, i32 0, i32 1
	%tmp214 = load i32, i32* %tmp213
	store i32 0, i32* %v10
	br label %loop_cond19
loop_cond19:
	%tmp215 = load i32, i32* %v10
	%tmp216 = getelementptr inbounds %"struct.vector.Vec<%struct.StructDefinedField>", %"struct.vector.Vec<%struct.StructDefinedField>"* %tmp184, i32 0, i32 1
	%tmp217 = load i32, i32* %tmp216
	%tmp218 = icmp uge i32 %tmp215, %tmp217
	br i1 %tmp218, label %then20, label %endif20
then20:
	br label %loop_body19_exit
endif20:
	%tmp219 = load i32, i32* %v10
	%tmp220 = load %struct.StructDefinedField*, %struct.StructDefinedField** %tmp184
	%tmp221 = getelementptr inbounds %struct.StructDefinedField, %struct.StructDefinedField* %tmp220, i32 %tmp219
	%tmp222 = getelementptr inbounds %struct.StructDefinedField, %struct.StructDefinedField* %tmp221, i32 0, i32 1
	call void @compiler_type_push(%struct.CompilerType* %tmp222, %struct.PathEx* %v8, %struct.SymbolTable* %table, %struct.string.String* %stdout)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.317, i32 2)
	%tmp223 = load i16, i16* %tmp221
	%tmp224 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp6, i16 %tmp223
	%tmp225 = load i8*, i8** %tmp224
	%tmp226 = load i16, i16* %tmp221
	%tmp227 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp6, i16 %tmp226
	%tmp228 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp227, i32 0, i32 1
	%tmp229 = load i32, i32* %tmp228
	call void @string.append_str(%struct.string.String* %stdout, i8* %tmp225, i32 %tmp229)
	%tmp230 = load i32, i32* %v10
	%tmp231 = getelementptr inbounds %"struct.vector.Vec<%struct.StructDefinedField>", %"struct.vector.Vec<%struct.StructDefinedField>"* %tmp184, i32 0, i32 1
	%tmp232 = load i32, i32* %tmp231
	%tmp233 = sub i32 %tmp232, 1
	%tmp234 = icmp ne i32 %tmp230, %tmp233
	br i1 %tmp234, label %then21, label %endif21
then21:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.89, i32 2)
	br label %endif21
endif21:
	%tmp235 = load i32, i32* %v10
	%tmp236 = add i32 %tmp235, 1
	store i32 %tmp236, i32* %v10
	br label %loop_cond19
loop_body19_exit:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.98, i32 1)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.99, i32 1)
; Variable loc is out.
	br label %endif16
endif16:
	br label %endif15
endif15:
	br label %endif11
endif11:
	br label %endif7
endif7:
	br label %endif3
endif3:
	br label %loop_body0
loop_body0:
	%tmp237 = load i32, i32* %v0
	%tmp238 = add i32 %tmp237, 1
	store i32 %tmp238, i32* %v0
	br label %loop_cond0
loop_body0_exit:
	ret void
}
define void @debug_dump_expression(%struct.Expression* %expr, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout){
entry:
	%v0 = alloca i32
	%v1 = alloca i32
	%v2 = alloca i32
	%v3 = alloca i32
	%tmp0 = load i32, i32* %expr
	%tmp1 = icmp eq i32 %tmp0, 0
	br i1 %tmp1, label %logic_end_0, label %logic_rhs_0
logic_rhs_0:
	%tmp2 = load i32, i32* %expr
	%tmp3 = icmp eq i32 %tmp2, 2
	br label %logic_end_0
logic_end_0:
	%tmp4 = phi i1 [%tmp1, %entry], [%tmp3, %logic_rhs_0]
	br i1 %tmp4, label %logic_end_1, label %logic_rhs_1
logic_rhs_1:
	%tmp5 = load i32, i32* %expr
	%tmp6 = icmp eq i32 %tmp5, 3
	br label %logic_end_1
logic_end_1:
	%tmp7 = phi i1 [%tmp4, %logic_end_0], [%tmp6, %logic_rhs_1]
	br i1 %tmp7, label %then2, label %endif2
then2:
	%tmp8 = getelementptr inbounds %struct.Expression, %struct.Expression* %expr, i32 0, i32 1
	%tmp9 = load i8*, i8** %tmp8
	%tmp10 = load i16, i16* %tmp9
	%tmp11 = load %struct.string.String*, %struct.string.String** %symbol_vector
	%tmp12 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp11, i16 %tmp10
	%tmp13 = load i8*, i8** %tmp12
	%tmp14 = load i16, i16* %tmp9
	%tmp15 = load %struct.string.String*, %struct.string.String** %symbol_vector
	%tmp16 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp15, i16 %tmp14
	%tmp17 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp16, i32 0, i32 1
	%tmp18 = load i32, i32* %tmp17
	call void @string.append_str(%struct.string.String* %stdout, i8* %tmp13, i32 %tmp18)
	br label %func_exit
endif2:
	%tmp19 = load i32, i32* %expr
	%tmp20 = icmp eq i32 %tmp19, 1
	br i1 %tmp20, label %then3, label %endif3
then3:
	%tmp21 = getelementptr inbounds %struct.Expression, %struct.Expression* %expr, i32 0, i32 1
	%tmp22 = load i8*, i8** %tmp21
	call void @string.append(%struct.string.String* %stdout, i8 39)
	%tmp23 = load i16, i16* %tmp22
	%tmp24 = icmp eq i16 %tmp23, 92
	br i1 %tmp24, label %then4, label %else4
then4:
	call void @string.append(%struct.string.String* %stdout, i8 92)
	call void @string.append(%struct.string.String* %stdout, i8 92)
	br label %endif4
else4:
	%tmp25 = load i16, i16* %tmp22
	%tmp26 = icmp eq i16 %tmp25, 39
	br i1 %tmp26, label %then5, label %endif5
then5:
	call void @string.append(%struct.string.String* %stdout, i8 92)
	call void @string.append(%struct.string.String* %stdout, i8 39)
	br label %endif5
endif5:
	br label %endif4
endif4:
	call void @string.append(%struct.string.String* %stdout, i8 39)
	br label %func_exit
endif3:
	%tmp27 = load i32, i32* %expr
	%tmp28 = icmp eq i32 %tmp27, 18
	br i1 %tmp28, label %then6, label %endif6
then6:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.264, i32 4)
	br label %func_exit
endif6:
	%tmp29 = load i32, i32* %expr
	%tmp30 = icmp eq i32 %tmp29, 4
	br i1 %tmp30, label %then7, label %endif7
then7:
	%tmp31 = getelementptr inbounds %struct.Expression, %struct.Expression* %expr, i32 0, i32 1
	%tmp32 = load i8*, i8** %tmp31
	call void @string.append(%struct.string.String* %stdout, i8 34)
	%tmp33 = load i16, i16* %tmp32
	%tmp34 = load %struct.string.String*, %struct.string.String** %symbol_vector
	%tmp35 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp34, i16 %tmp33
	%tmp36 = load i8*, i8** %tmp35
	%tmp37 = load i16, i16* %tmp32
	%tmp38 = load %struct.string.String*, %struct.string.String** %symbol_vector
	%tmp39 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp38, i16 %tmp37
	%tmp40 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp39, i32 0, i32 1
	%tmp41 = load i32, i32* %tmp40
	call void @string.append_str(%struct.string.String* %stdout, i8* %tmp36, i32 %tmp41)
	call void @string.append(%struct.string.String* %stdout, i8 34)
	br label %func_exit
endif7:
	%tmp42 = load i32, i32* %expr
	%tmp43 = icmp eq i32 %tmp42, 12
	br i1 %tmp43, label %then8, label %endif8
then8:
	%tmp44 = getelementptr inbounds %struct.Expression, %struct.Expression* %expr, i32 0, i32 1
	%tmp45 = load i8*, i8** %tmp44
	call void @debug_dump_expression(%struct.Expression* %tmp45, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	%tmp46 = getelementptr inbounds %struct.CallExpr, %struct.CallExpr* %tmp45, i32 0, i32 2
	%tmp47 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %tmp46, i32 0, i32 1
	%tmp48 = load i32, i32* %tmp47
	%tmp49 = icmp ne i32 %tmp48, 0
	br i1 %tmp49, label %then9, label %endif9
then9:
	call void @string.append(%struct.string.String* %stdout, i8 58)
	call void @string.append(%struct.string.String* %stdout, i8 58)
	call void @string.append(%struct.string.String* %stdout, i8 60)
	%tmp50 = getelementptr inbounds %struct.CallExpr, %struct.CallExpr* %tmp45, i32 0, i32 2
	%tmp51 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %tmp50, i32 0, i32 1
	%tmp52 = load i32, i32* %tmp51
	store i32 0, i32* %v0
	br label %loop_cond10
loop_cond10:
	%tmp53 = load i32, i32* %v0
	%tmp54 = getelementptr inbounds %struct.CallExpr, %struct.CallExpr* %tmp45, i32 0, i32 2
	%tmp55 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %tmp54, i32 0, i32 1
	%tmp56 = load i32, i32* %tmp55
	%tmp57 = icmp uge i32 %tmp53, %tmp56
	br i1 %tmp57, label %then11, label %endif11
then11:
	br label %loop_body10_exit
endif11:
	%tmp59 = load i32, i32* %v0
	%tmp60 = getelementptr inbounds %struct.CallExpr, %struct.CallExpr* %tmp45, i32 0, i32 2
	%tmp61 = load %struct.Type*, %struct.Type** %tmp60
	%tmp62 = getelementptr inbounds %struct.Type, %struct.Type* %tmp61, i32 %tmp59
	call void @debug_dump_type(%struct.Type* %tmp62, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	%tmp63 = load i32, i32* %v0
	%tmp64 = getelementptr inbounds %struct.CallExpr, %struct.CallExpr* %tmp45, i32 0, i32 2
	%tmp65 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %tmp64, i32 0, i32 1
	%tmp66 = load i32, i32* %tmp65
	%tmp67 = sub i32 %tmp66, 1
	%tmp68 = icmp ne i32 %tmp63, %tmp67
	br i1 %tmp68, label %then12, label %endif12
then12:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.89, i32 2)
	br label %endif12
endif12:
	%tmp69 = load i32, i32* %v0
	%tmp70 = add i32 %tmp69, 1
	store i32 %tmp70, i32* %v0
	br label %loop_cond10
loop_body10_exit:
	call void @string.append(%struct.string.String* %stdout, i8 62)
	br label %endif9
endif9:
	call void @string.append(%struct.string.String* %stdout, i8 40)
	%tmp71 = getelementptr inbounds %struct.CallExpr, %struct.CallExpr* %tmp45, i32 0, i32 1
	%tmp72 = getelementptr inbounds %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Expression>"* %tmp71, i32 0, i32 1
	%tmp73 = load i32, i32* %tmp72
	store i32 0, i32* %v1
	br label %loop_cond13
loop_cond13:
	%tmp74 = load i32, i32* %v1
	%tmp75 = getelementptr inbounds %struct.CallExpr, %struct.CallExpr* %tmp45, i32 0, i32 1
	%tmp76 = getelementptr inbounds %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Expression>"* %tmp75, i32 0, i32 1
	%tmp77 = load i32, i32* %tmp76
	%tmp78 = icmp uge i32 %tmp74, %tmp77
	br i1 %tmp78, label %then14, label %endif14
then14:
	br label %loop_body13_exit
endif14:
	%tmp80 = load i32, i32* %v1
	%tmp81 = getelementptr inbounds %struct.CallExpr, %struct.CallExpr* %tmp45, i32 0, i32 1
	%tmp82 = load %struct.Expression*, %struct.Expression** %tmp81
	%tmp83 = getelementptr inbounds %struct.Expression, %struct.Expression* %tmp82, i32 %tmp80
	call void @debug_dump_expression(%struct.Expression* %tmp83, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	%tmp84 = load i32, i32* %v1
	%tmp85 = getelementptr inbounds %struct.CallExpr, %struct.CallExpr* %tmp45, i32 0, i32 1
	%tmp86 = getelementptr inbounds %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Expression>"* %tmp85, i32 0, i32 1
	%tmp87 = load i32, i32* %tmp86
	%tmp88 = sub i32 %tmp87, 1
	%tmp89 = icmp ne i32 %tmp84, %tmp88
	br i1 %tmp89, label %then15, label %endif15
then15:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.89, i32 2)
	br label %endif15
endif15:
	%tmp90 = load i32, i32* %v1
	%tmp91 = add i32 %tmp90, 1
	store i32 %tmp91, i32* %v1
	br label %loop_cond13
loop_body13_exit:
	call void @string.append(%struct.string.String* %stdout, i8 41)
	br label %func_exit
endif8:
	%tmp92 = load i32, i32* %expr
	%tmp93 = icmp eq i32 %tmp92, 10
	br i1 %tmp93, label %then16, label %endif16
then16:
	%tmp94 = getelementptr inbounds %struct.Expression, %struct.Expression* %expr, i32 0, i32 1
	%tmp95 = load i8*, i8** %tmp94
	call void @debug_dump_expression(%struct.Expression* %tmp95, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.111, i32 2)
	%tmp96 = getelementptr inbounds %struct.StaticAccessExpr, %struct.StaticAccessExpr* %tmp95, i32 0, i32 1
	%tmp97 = load i16, i16* %tmp96
	%tmp98 = load %struct.string.String*, %struct.string.String** %symbol_vector
	%tmp99 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp98, i16 %tmp97
	%tmp100 = load i8*, i8** %tmp99
	%tmp101 = getelementptr inbounds %struct.StaticAccessExpr, %struct.StaticAccessExpr* %tmp95, i32 0, i32 1
	%tmp102 = load i16, i16* %tmp101
	%tmp103 = load %struct.string.String*, %struct.string.String** %symbol_vector
	%tmp104 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp103, i16 %tmp102
	%tmp105 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp104, i32 0, i32 1
	%tmp106 = load i32, i32* %tmp105
	call void @string.append_str(%struct.string.String* %stdout, i8* %tmp100, i32 %tmp106)
	br label %func_exit
endif16:
	%tmp107 = load i32, i32* %expr
	%tmp108 = icmp eq i32 %tmp107, 9
	br i1 %tmp108, label %then17, label %endif17
then17:
	%tmp109 = getelementptr inbounds %struct.Expression, %struct.Expression* %expr, i32 0, i32 1
	%tmp110 = load i8*, i8** %tmp109
	call void @debug_dump_expression(%struct.Expression* %tmp110, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	call void @string.append(%struct.string.String* %stdout, i8 46)
	%tmp111 = getelementptr inbounds %struct.MemberAccessExpr, %struct.MemberAccessExpr* %tmp110, i32 0, i32 1
	%tmp112 = load i16, i16* %tmp111
	%tmp113 = load %struct.string.String*, %struct.string.String** %symbol_vector
	%tmp114 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp113, i16 %tmp112
	%tmp115 = load i8*, i8** %tmp114
	%tmp116 = getelementptr inbounds %struct.MemberAccessExpr, %struct.MemberAccessExpr* %tmp110, i32 0, i32 1
	%tmp117 = load i16, i16* %tmp116
	%tmp118 = load %struct.string.String*, %struct.string.String** %symbol_vector
	%tmp119 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp118, i16 %tmp117
	%tmp120 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp119, i32 0, i32 1
	%tmp121 = load i32, i32* %tmp120
	call void @string.append_str(%struct.string.String* %stdout, i8* %tmp115, i32 %tmp121)
	br label %func_exit
endif17:
	%tmp122 = load i32, i32* %expr
	%tmp123 = icmp eq i32 %tmp122, 8
	br i1 %tmp123, label %then18, label %endif18
then18:
	%tmp124 = getelementptr inbounds %struct.Expression, %struct.Expression* %expr, i32 0, i32 1
	%tmp125 = load i8*, i8** %tmp124
	call void @debug_dump_expression(%struct.Expression* %tmp125, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.318, i32 4)
	%tmp126 = getelementptr inbounds %struct.CastExpr, %struct.CastExpr* %tmp125, i32 0, i32 1
	call void @debug_dump_type(%struct.Type* %tmp126, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	br label %func_exit
endif18:
	%tmp127 = load i32, i32* %expr
	%tmp128 = icmp eq i32 %tmp127, 17
	br i1 %tmp128, label %then19, label %endif19
then19:
	%tmp129 = getelementptr inbounds %struct.Expression, %struct.Expression* %expr, i32 0, i32 1
	%tmp130 = load i8*, i8** %tmp129
	%tmp131 = load i1, i1* %tmp130
	br i1 %tmp131, label %then20, label %else20
then20:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.261, i32 4)
	br label %endif20
else20:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.273, i32 5)
	br label %endif20
endif20:
	br label %func_exit
endif19:
	%tmp132 = load i32, i32* %expr
	%tmp133 = icmp eq i32 %tmp132, 6
	br i1 %tmp133, label %then21, label %endif21
then21:
	%tmp134 = getelementptr inbounds %struct.Expression, %struct.Expression* %expr, i32 0, i32 1
	%tmp135 = load i8*, i8** %tmp134
	call void @debug_dump_expression(%struct.Expression* %tmp135, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	call void @string.append(%struct.string.String* %stdout, i8 32)
	call void @string.append(%struct.string.String* %stdout, i8 32)
	%tmp136 = getelementptr inbounds %struct.BinaryOpExpr, %struct.BinaryOpExpr* %tmp135, i32 0, i32 1
	call void @debug_dump_expression(%struct.Expression* %tmp136, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	br label %func_exit
endif21:
	%tmp137 = load i32, i32* %expr
	%tmp138 = icmp eq i32 %tmp137, 7
	br i1 %tmp138, label %then22, label %endif22
then22:
	%tmp139 = getelementptr inbounds %struct.Expression, %struct.Expression* %expr, i32 0, i32 1
	%tmp140 = load i8*, i8** %tmp139
	%tmp141 = getelementptr inbounds %struct.UnaryOpExpr, %struct.UnaryOpExpr* %tmp140, i32 0, i32 1
	%tmp142 = load i8, i8* %tmp141
	%tmp143 = icmp eq i8 %tmp142, 0
	br i1 %tmp143, label %then23, label %else23
then23:
	call void @string.append(%struct.string.String* %stdout, i8 45)
	br label %endif23
else23:
	%tmp144 = getelementptr inbounds %struct.UnaryOpExpr, %struct.UnaryOpExpr* %tmp140, i32 0, i32 1
	%tmp145 = load i8, i8* %tmp144
	%tmp146 = icmp eq i8 %tmp145, 1
	br i1 %tmp146, label %then24, label %else24
then24:
	call void @string.append(%struct.string.String* %stdout, i8 33)
	br label %endif24
else24:
	%tmp147 = getelementptr inbounds %struct.UnaryOpExpr, %struct.UnaryOpExpr* %tmp140, i32 0, i32 1
	%tmp148 = load i8, i8* %tmp147
	%tmp149 = icmp eq i8 %tmp148, 2
	br i1 %tmp149, label %then25, label %else25
then25:
	call void @string.append(%struct.string.String* %stdout, i8 42)
	br label %endif25
else25:
	%tmp150 = getelementptr inbounds %struct.UnaryOpExpr, %struct.UnaryOpExpr* %tmp140, i32 0, i32 1
	%tmp151 = load i8, i8* %tmp150
	%tmp152 = icmp eq i8 %tmp151, 3
	br i1 %tmp152, label %then26, label %else26
then26:
	call void @string.append(%struct.string.String* %stdout, i8 38)
	br label %endif26
else26:
	%tmp153 = getelementptr inbounds %struct.UnaryOpExpr, %struct.UnaryOpExpr* %tmp140, i32 0, i32 1
	%tmp154 = load i8, i8* %tmp153
	%tmp155 = icmp eq i8 %tmp154, 4
	br i1 %tmp155, label %then27, label %endif27
then27:
	call void @string.append(%struct.string.String* %stdout, i8 126)
	br label %endif27
endif27:
	br label %endif26
endif26:
	br label %endif25
endif25:
	br label %endif24
endif24:
	br label %endif23
endif23:
	call void @debug_dump_expression(%struct.Expression* %tmp140, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	br label %func_exit
endif22:
	%tmp156 = load i32, i32* %expr
	%tmp157 = icmp eq i32 %tmp156, 16
	br i1 %tmp157, label %then28, label %endif28
then28:
	%tmp158 = getelementptr inbounds %struct.Expression, %struct.Expression* %expr, i32 0, i32 1
	%tmp159 = load i8*, i8** %tmp158
	call void @debug_dump_expression(%struct.Expression* %tmp159, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.115, i32 2)
	%tmp160 = getelementptr inbounds %struct.RangeExpr, %struct.RangeExpr* %tmp159, i32 0, i32 2
	%tmp161 = load i1, i1* %tmp160
	br i1 %tmp161, label %then29, label %endif29
then29:
	call void @string.append(%struct.string.String* %stdout, i8 61)
	br label %endif29
endif29:
	%tmp162 = getelementptr inbounds %struct.RangeExpr, %struct.RangeExpr* %tmp159, i32 0, i32 1
	call void @debug_dump_expression(%struct.Expression* %tmp162, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	br label %func_exit
endif28:
	%tmp163 = load i32, i32* %expr
	%tmp164 = icmp eq i32 %tmp163, 13
	br i1 %tmp164, label %then30, label %endif30
then30:
	%tmp165 = getelementptr inbounds %struct.Expression, %struct.Expression* %expr, i32 0, i32 1
	%tmp166 = load i8*, i8** %tmp165
	call void @debug_dump_expression(%struct.Expression* %tmp166, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	call void @string.append(%struct.string.String* %stdout, i8 91)
	%tmp167 = getelementptr inbounds %struct.IndexExpr, %struct.IndexExpr* %tmp166, i32 0, i32 1
	call void @debug_dump_expression(%struct.Expression* %tmp167, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	call void @string.append(%struct.string.String* %stdout, i8 93)
	br label %func_exit
endif30:
	%tmp168 = load i32, i32* %expr
	%tmp169 = icmp eq i32 %tmp168, 11
	br i1 %tmp169, label %then31, label %endif31
then31:
	%tmp170 = getelementptr inbounds %struct.Expression, %struct.Expression* %expr, i32 0, i32 1
	%tmp171 = load i8*, i8** %tmp170
	call void @debug_dump_expression(%struct.Expression* %tmp171, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	call void @string.append(%struct.string.String* %stdout, i8 58)
	call void @string.append(%struct.string.String* %stdout, i8 58)
	call void @string.append(%struct.string.String* %stdout, i8 60)
	%tmp172 = getelementptr inbounds %struct.NameWithGenericsExpr, %struct.NameWithGenericsExpr* %tmp171, i32 0, i32 1
	%tmp173 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %tmp172, i32 0, i32 1
	%tmp174 = load i32, i32* %tmp173
	store i32 0, i32* %v2
	br label %loop_cond32
loop_cond32:
	%tmp175 = load i32, i32* %v2
	%tmp176 = getelementptr inbounds %struct.NameWithGenericsExpr, %struct.NameWithGenericsExpr* %tmp171, i32 0, i32 1
	%tmp177 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %tmp176, i32 0, i32 1
	%tmp178 = load i32, i32* %tmp177
	%tmp179 = icmp uge i32 %tmp175, %tmp178
	br i1 %tmp179, label %then33, label %endif33
then33:
	br label %loop_body32_exit
endif33:
	%tmp181 = load i32, i32* %v2
	%tmp182 = getelementptr inbounds %struct.NameWithGenericsExpr, %struct.NameWithGenericsExpr* %tmp171, i32 0, i32 1
	%tmp183 = load %struct.Type*, %struct.Type** %tmp182
	%tmp184 = getelementptr inbounds %struct.Type, %struct.Type* %tmp183, i32 %tmp181
	call void @debug_dump_type(%struct.Type* %tmp184, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	%tmp185 = load i32, i32* %v2
	%tmp186 = getelementptr inbounds %struct.NameWithGenericsExpr, %struct.NameWithGenericsExpr* %tmp171, i32 0, i32 1
	%tmp187 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %tmp186, i32 0, i32 1
	%tmp188 = load i32, i32* %tmp187
	%tmp189 = sub i32 %tmp188, 1
	%tmp190 = icmp ne i32 %tmp185, %tmp189
	br i1 %tmp190, label %then34, label %endif34
then34:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.89, i32 2)
	br label %endif34
endif34:
	%tmp191 = load i32, i32* %v2
	%tmp192 = add i32 %tmp191, 1
	store i32 %tmp192, i32* %v2
	br label %loop_cond32
loop_body32_exit:
	call void @string.append(%struct.string.String* %stdout, i8 62)
	br label %func_exit
endif31:
	%tmp193 = load i32, i32* %expr
	%tmp194 = icmp eq i32 %tmp193, 15
	br i1 %tmp194, label %then35, label %endif35
then35:
	%tmp195 = getelementptr inbounds %struct.Expression, %struct.Expression* %expr, i32 0, i32 1
	%tmp196 = load i8*, i8** %tmp195
	call void @debug_dump_expression(%struct.Expression* %tmp196, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	call void @string.append(%struct.string.String* %stdout, i8 58)
	call void @string.append(%struct.string.String* %stdout, i8 58)
	call void @string.append(%struct.string.String* %stdout, i8 123)
	%tmp197 = getelementptr inbounds %struct.StructInitExpr, %struct.StructInitExpr* %tmp196, i32 0, i32 1
	%tmp198 = getelementptr inbounds %"struct.vector.Vec<%struct.StructInitFieldExpr>", %"struct.vector.Vec<%struct.StructInitFieldExpr>"* %tmp197, i32 0, i32 1
	%tmp199 = load i32, i32* %tmp198
	store i32 0, i32* %v3
	br label %loop_cond36
loop_cond36:
	%tmp200 = load i32, i32* %v3
	%tmp201 = getelementptr inbounds %struct.StructInitExpr, %struct.StructInitExpr* %tmp196, i32 0, i32 1
	%tmp202 = getelementptr inbounds %"struct.vector.Vec<%struct.StructInitFieldExpr>", %"struct.vector.Vec<%struct.StructInitFieldExpr>"* %tmp201, i32 0, i32 1
	%tmp203 = load i32, i32* %tmp202
	%tmp204 = icmp uge i32 %tmp200, %tmp203
	br i1 %tmp204, label %then37, label %endif37
then37:
	br label %loop_body36_exit
endif37:
	%tmp206 = load i32, i32* %v3
	%tmp207 = getelementptr inbounds %struct.StructInitExpr, %struct.StructInitExpr* %tmp196, i32 0, i32 1
	%tmp208 = load %struct.StructInitFieldExpr*, %struct.StructInitFieldExpr** %tmp207
	%tmp209 = getelementptr inbounds %struct.StructInitFieldExpr, %struct.StructInitFieldExpr* %tmp208, i32 %tmp206
	%tmp210 = load i16, i16* %tmp209
	%tmp211 = load %struct.string.String*, %struct.string.String** %symbol_vector
	%tmp212 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp211, i16 %tmp210
	%tmp213 = load i8*, i8** %tmp212
	%tmp215 = load i32, i32* %v3
	%tmp216 = getelementptr inbounds %struct.StructInitExpr, %struct.StructInitExpr* %tmp196, i32 0, i32 1
	%tmp217 = load %struct.StructInitFieldExpr*, %struct.StructInitFieldExpr** %tmp216
	%tmp218 = getelementptr inbounds %struct.StructInitFieldExpr, %struct.StructInitFieldExpr* %tmp217, i32 %tmp215
	%tmp219 = load i16, i16* %tmp218
	%tmp220 = load %struct.string.String*, %struct.string.String** %symbol_vector
	%tmp221 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp220, i16 %tmp219
	%tmp222 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp221, i32 0, i32 1
	%tmp223 = load i32, i32* %tmp222
	call void @string.append_str(%struct.string.String* %stdout, i8* %tmp213, i32 %tmp223)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.310, i32 2)
	%tmp225 = load i32, i32* %v3
	%tmp226 = getelementptr inbounds %struct.StructInitExpr, %struct.StructInitExpr* %tmp196, i32 0, i32 1
	%tmp227 = load %struct.StructInitFieldExpr*, %struct.StructInitFieldExpr** %tmp226
	%tmp228 = getelementptr inbounds %struct.StructInitFieldExpr, %struct.StructInitFieldExpr* %tmp227, i32 %tmp225
	%tmp229 = getelementptr inbounds %struct.StructInitFieldExpr, %struct.StructInitFieldExpr* %tmp228, i32 0, i32 1
	call void @debug_dump_expression(%struct.Expression* %tmp229, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	%tmp230 = load i32, i32* %v3
	%tmp231 = getelementptr inbounds %struct.StructInitExpr, %struct.StructInitExpr* %tmp196, i32 0, i32 1
	%tmp232 = getelementptr inbounds %"struct.vector.Vec<%struct.StructInitFieldExpr>", %"struct.vector.Vec<%struct.StructInitFieldExpr>"* %tmp231, i32 0, i32 1
	%tmp233 = load i32, i32* %tmp232
	%tmp234 = sub i32 %tmp233, 1
	%tmp235 = icmp ne i32 %tmp230, %tmp234
	br i1 %tmp235, label %then38, label %endif38
then38:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.89, i32 2)
	br label %endif38
endif38:
	%tmp236 = load i32, i32* %v3
	%tmp237 = add i32 %tmp236, 1
	store i32 %tmp237, i32* %v3
	br label %loop_cond36
loop_body36_exit:
	call void @string.append(%struct.string.String* %stdout, i8 125)
	br label %func_exit
endif35:
	%tmp238 = load i32, i32* %expr
	%tmp239 = sext i32 %tmp238 to i64
	call void @console.println_i64(i64 %tmp239)
	br label %func_exit
func_exit:
	ret void
}
define %struct.Rvalue @constant_evaluate_expression(%struct.Expression* %expr, %struct.SymbolTable* %table){
	%v0 = alloca %struct.Rvalue
	%tmp0 = inttoptr i64 1337 to i8*
	store i32 1, i32* %v0
	%tmp1 = getelementptr inbounds %struct.Rvalue, %struct.Rvalue* %v0, i32 0, i32 1
	store i8* %tmp0, i8** %tmp1
	%tmp2 = load %struct.Rvalue, %struct.Rvalue* %v0
; Variable sample is out.
	ret %struct.Rvalue %tmp2
}
define void @compiler_type_push(%struct.CompilerType* %type, %struct.PathEx* %path, %struct.SymbolTable* %symbol_table, %struct.string.String* %stdout){
	%v0 = alloca i8
	%v1 = alloca i32
	%tmp0 = load i32, i32* %type
	%tmp1 = icmp eq i32 %tmp0, 0
	br i1 %tmp1, label %then0, label %else0
then0:
	%tmp2 = getelementptr inbounds %struct.CompilerType, %struct.CompilerType* %type, i32 0, i32 1
	%tmp3 = load i8*, i8** %tmp2
	%tmp4 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %tmp3, i32 0, i32 1
	%tmp5 = load i8*, i8** %tmp4
	%tmp6 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %tmp3, i32 0, i32 1
	%tmp7 = load i8*, i8** %tmp6
	%tmp8 = call i32 @string_utils.c_str_len(i8* %tmp7)
	call void @string.append_str(%struct.string.String* %stdout, i8* %tmp5, i32 %tmp8)
	br label %endif0
else0:
	%tmp9 = load i32, i32* %type
	%tmp10 = icmp eq i32 %tmp9, 2
	br i1 %tmp10, label %then1, label %else1
then1:
	%tmp11 = getelementptr inbounds %struct.CompilerType, %struct.CompilerType* %type, i32 0, i32 1
	%tmp12 = load i8*, i8** %tmp11
	%tmp13 = ptrtoint i8* %tmp12 to i64
	%tmp14 = trunc i64 %tmp13 to i32
	%tmp15 = load %struct.SymbolTableEntry*, %struct.SymbolTableEntry** %symbol_table
	%tmp16 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp15, i32 %tmp14
	%tmp17 = load i32, i32* %tmp16
	%tmp18 = and i32 %tmp17, 7
	%tmp19 = icmp eq i32 %tmp18, 2
	br i1 %tmp19, label %then2, label %else2
then2:
	%tmp20 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp16, i32 0, i32 2
	%tmp21 = load i8*, i8** %tmp20
	call void @string.append(%struct.string.String* %stdout, i8 37)
	%tmp22 = getelementptr inbounds %struct.StructSymbolTableEntry, %struct.StructSymbolTableEntry* %tmp21, i32 0, i32 2
	%tmp23 = load i8*, i8** %tmp22
	%tmp24 = getelementptr inbounds %struct.StructSymbolTableEntry, %struct.StructSymbolTableEntry* %tmp21, i32 0, i32 2
	%tmp25 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp24, i32 0, i32 1
	%tmp26 = load i32, i32* %tmp25
	call void @string.append_str(%struct.string.String* %stdout, i8* %tmp23, i32 %tmp26)
	br label %endif2
else2:
	%tmp27 = load i32, i32* %tmp16
	%tmp28 = and i32 %tmp27, 7
	%tmp29 = icmp eq i32 %tmp28, 4
	br i1 %tmp29, label %then3, label %else3
then3:
	%tmp30 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp16, i32 0, i32 2
	%tmp31 = load i8*, i8** %tmp30
	call void @compiler_type_push(%struct.CompilerType* %tmp31, %struct.PathEx* %path, %struct.SymbolTable* %symbol_table, %struct.string.String* %stdout)
	br label %endif3
else3:
	call void @process.throw(i8* @.str.319)
	br label %endif3
endif3:
	br label %endif2
endif2:
	br label %endif1
else1:
	%tmp32 = load i32, i32* %type
	%tmp33 = icmp eq i32 %tmp32, 1
	br i1 %tmp33, label %then4, label %else4
then4:
	%tmp34 = getelementptr inbounds %struct.CompilerType, %struct.CompilerType* %type, i32 0, i32 1
	%tmp35 = load i8*, i8** %tmp34
	%tmp36 = getelementptr inbounds %struct.PointerCompilerType, %struct.PointerCompilerType* %tmp35, i32 0, i32 1
	call void @compiler_type_push(%struct.CompilerType* %tmp36, %struct.PathEx* %path, %struct.SymbolTable* %symbol_table, %struct.string.String* %stdout)
	%tmp37 = load i8, i8* %tmp35
	store i8 0, i8* %v0
	br label %loop_cond5
loop_cond5:
	%tmp38 = load i8, i8* %v0
	%tmp39 = load i8, i8* %tmp35
	%tmp40 = icmp uge i8 %tmp38, %tmp39
	br i1 %tmp40, label %then6, label %endif6
then6:
	br label %loop_body5_exit
endif6:
	call void @string.append(%struct.string.String* %stdout, i8 42)
	%tmp41 = load i8, i8* %v0
	%tmp42 = add i8 %tmp41, 1
	store i8 %tmp42, i8* %v0
	br label %loop_cond5
loop_body5_exit:
	br label %endif4
else4:
	%tmp43 = load i32, i32* %type
	%tmp44 = icmp eq i32 %tmp43, 4
	br i1 %tmp44, label %then7, label %endif7
then7:
	%tmp45 = getelementptr inbounds %struct.CompilerType, %struct.CompilerType* %type, i32 0, i32 1
	%tmp46 = load i8*, i8** %tmp45
	%tmp47 = load i32, i32* %tmp46
	%tmp48 = load %struct.SymbolTableEntry*, %struct.SymbolTableEntry** %symbol_table
	%tmp49 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp48, i32 %tmp47
	%tmp50 = load i32, i32* %tmp49
	%tmp51 = and i32 %tmp50, 7
	%tmp52 = icmp eq i32 %tmp51, 3
	br i1 %tmp52, label %then8, label %else8
then8:
	%tmp53 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp49, i32 0, i32 2
	%tmp54 = load i8*, i8** %tmp53
	call void @string.append(%struct.string.String* %stdout, i8 37)
	%tmp55 = getelementptr inbounds %struct.GenericStructSymbolTableEntry, %struct.GenericStructSymbolTableEntry* %tmp54, i32 0, i32 3
	%tmp56 = load i8*, i8** %tmp55
	%tmp57 = getelementptr inbounds %struct.GenericStructSymbolTableEntry, %struct.GenericStructSymbolTableEntry* %tmp54, i32 0, i32 3
	%tmp58 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp57, i32 0, i32 1
	%tmp59 = load i32, i32* %tmp58
	call void @string.append_str(%struct.string.String* %stdout, i8* %tmp56, i32 %tmp59)
	call void @string.append(%struct.string.String* %stdout, i8 95)
	%tmp60 = getelementptr inbounds %struct.GenericStructSymbolTableEntry, %struct.GenericStructSymbolTableEntry* %tmp54, i32 0, i32 1
	%tmp61 = getelementptr inbounds %"struct.vector.Vec<ui16>", %"struct.vector.Vec<ui16>"* %tmp60, i32 0, i32 1
	%tmp62 = load i32, i32* %tmp61
	%tmp64 = getelementptr inbounds %struct.GenericImplementationCompilerType, %struct.GenericImplementationCompilerType* %tmp46, i32 0, i32 1
	%tmp65 = load i32, i32* %tmp64
	%tmp66 = getelementptr inbounds %struct.GenericStructSymbolTableEntry, %struct.GenericStructSymbolTableEntry* %tmp54, i32 0, i32 2
	%tmp67 = load %"struct.vector.Vec<%struct.CompilerType>"*, %"struct.vector.Vec<%struct.CompilerType>"** %tmp66
	%tmp68 = getelementptr inbounds %"struct.vector.Vec<%struct.CompilerType>", %"struct.vector.Vec<%struct.CompilerType>"* %tmp67, i32 %tmp65
	store i32 0, i32* %v1
	br label %loop_cond9
loop_cond9:
	%tmp69 = load i32, i32* %v1
	%tmp70 = icmp uge i32 %tmp69, %tmp62
	br i1 %tmp70, label %then10, label %endif10
then10:
	br label %loop_body9_exit
endif10:
	%tmp71 = load i32, i32* %v1
	%tmp72 = load %struct.CompilerType*, %struct.CompilerType** %tmp68
	%tmp73 = getelementptr inbounds %struct.CompilerType, %struct.CompilerType* %tmp72, i32 %tmp71
	call void @compiler_type_push(%struct.CompilerType* %tmp73, %struct.PathEx* %path, %struct.SymbolTable* %symbol_table, %struct.string.String* %stdout)
	%tmp74 = load i32, i32* %v1
	%tmp75 = sub i32 %tmp62, 1
	%tmp76 = icmp ne i32 %tmp74, %tmp75
	br i1 %tmp76, label %then11, label %endif11
then11:
	call void @string.append(%struct.string.String* %stdout, i8 46)
	br label %endif11
endif11:
	%tmp77 = load i32, i32* %v1
	%tmp78 = add i32 %tmp77, 1
	store i32 %tmp78, i32* %v1
	br label %loop_cond9
loop_body9_exit:
	call void @string.append(%struct.string.String* %stdout, i8 95)
	br label %endif8
else8:
	call void @process.throw(i8* @.str.319)
	br label %endif8
endif8:
	br label %endif7
endif7:
	br label %endif4
endif4:
	br label %endif1
endif1:
	br label %endif0
endif0:
	ret void
}
define void @compile_internal_sym_table_prefill(%struct.Path* %path, %"struct.vector.Vec<%struct.Stmt>"* %statement_vector, %struct.SymbolTable* %symbol_table, %struct.string.String* %stdout){
	%v0 = alloca i32
	%v1 = alloca i32
	%v2 = alloca %struct.Stmt*
	%v3 = alloca %struct.PathEx
	%v4 = alloca %struct.SymbolTableEntry
	%v5 = alloca %struct.PathEx
	%v6 = alloca %struct.SymbolTableEntry
	%v7 = alloca %struct.GenericStructSymbolTableEntry*
	%v8 = alloca i32
	%v9 = alloca %struct.StructSymbolTableEntry*
	%v10 = alloca %struct.Layout
	%v11 = alloca %struct.PathEx
	%v12 = alloca %struct.SymbolTableEntry
	%v13 = alloca %struct.Path
	%v14 = alloca %struct.PathEx
	%v15 = alloca %struct.SymbolTableEntry
	%v16 = alloca i32
	store i32 0, i32* %v0
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %statement_vector, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	store i32 %tmp1, i32* %v1
	%tmp2 = getelementptr inbounds %struct.SymbolTable, %struct.SymbolTable* %symbol_table, i32 0, i32 1
	%tmp3 = load %"struct.vector.Vec<%struct.string.String>"*, %"struct.vector.Vec<%struct.string.String>"** %tmp2
	%tmp4 = load %struct.string.String*, %struct.string.String** %tmp3
	br label %loop_start0
loop_start0:
	%tmp5 = load i32, i32* %v0
	%tmp6 = load i32, i32* %v1
	%tmp7 = icmp ult i32 %tmp5, %tmp6
	br i1 %tmp7, label %endif1, label %else1
else1:
	br label %loop_body0_exit
endif1:
	%tmp8 = load i32, i32* %v0
	%tmp9 = load %struct.Stmt*, %struct.Stmt** %statement_vector
	%tmp10 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp9, i32 %tmp8
	store %struct.Stmt* %tmp10, %struct.Stmt** %v2
	%tmp11 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp12 = load i8, i8* %tmp11
	%tmp13 = icmp eq i8 %tmp12, 0
	br i1 %tmp13, label %then2, label %else2
then2:
	call void @process.throw(i8* @.str.320)
	br label %endif2
else2:
	%tmp14 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp15 = load i8, i8* %tmp14
	%tmp16 = icmp eq i8 %tmp15, 20
	br i1 %tmp16, label %then3, label %else3
then3:
	%tmp17 = load i32, i32* %v0
	%tmp18 = add i32 %tmp17, 1
	store i32 %tmp18, i32* %v0
	br label %loop_body0
else3:
	%tmp19 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp20 = load i8, i8* %tmp19
	%tmp21 = icmp eq i8 %tmp20, 11
	br i1 %tmp21, label %then4, label %else4
then4:
	%tmp22 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp23 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp22, i32 0, i32 1
	%tmp24 = load i8*, i8** %tmp23
	%tmp25 = load i16, i16* %tmp24
	%tmp26 = call %struct.PathEx @path_to_path_ex_name(%struct.Path* %path, i16 %tmp25)
	store %struct.PathEx %tmp26, %struct.PathEx* %v3
	%tmp27 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %v4, i32 0, i32 1
	%tmp28 = load %struct.PathEx, %struct.PathEx* %v3
	store %struct.PathEx %tmp28, %struct.PathEx* %tmp27
	%tmp29 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %v4, i32 0, i32 2
	store i8* null, i8** %tmp29
	%tmp30 = getelementptr inbounds %struct.FnNode, %struct.FnNode* %tmp24, i32 0, i32 5
	%tmp31 = getelementptr inbounds %"struct.vector.Vec<ui16>", %"struct.vector.Vec<ui16>"* %tmp30, i32 0, i32 1
	%tmp32 = load i32, i32* %tmp31
	%tmp33 = icmp ne i32 %tmp32, 0
	br i1 %tmp33, label %then5, label %else5
then5:
	store i32 1, i32* %v4
	br label %endif5
else5:
	store i32 0, i32* %v4
	br label %endif5
endif5:
	%tmp34 = load %struct.SymbolTableEntry, %struct.SymbolTableEntry* %v4
	call void @insert_symbol_into_table(%struct.SymbolTable* %symbol_table, %struct.SymbolTableEntry %tmp34)
	%tmp35 = load i32, i32* %v0
	%tmp36 = add i32 %tmp35, 1
	store i32 %tmp36, i32* %v0
	br label %loop_body0
; Variable sym_t_entry is out.
; Variable struct_path is out.
else4:
	%tmp37 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp38 = load i8, i8* %tmp37
	%tmp39 = icmp eq i8 %tmp38, 12
	br i1 %tmp39, label %then6, label %else6
then6:
	%tmp40 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp41 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp40, i32 0, i32 1
	%tmp42 = load i8*, i8** %tmp41
	%tmp43 = load i16, i16* %tmp42
	%tmp44 = call %struct.PathEx @path_to_path_ex_name(%struct.Path* %path, i16 %tmp43)
	store %struct.PathEx %tmp44, %struct.PathEx* %v5
	%tmp45 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %v6, i32 0, i32 1
	%tmp46 = load %struct.PathEx, %struct.PathEx* %v5
	store %struct.PathEx %tmp46, %struct.PathEx* %tmp45
	%tmp47 = getelementptr inbounds %struct.StructNode, %struct.StructNode* %tmp42, i32 0, i32 3
	%tmp48 = getelementptr inbounds %"struct.vector.Vec<ui16>", %"struct.vector.Vec<ui16>"* %tmp47, i32 0, i32 1
	%tmp49 = load i32, i32* %tmp48
	%tmp50 = icmp ne i32 %tmp49, 0
	br i1 %tmp50, label %then7, label %else7
then7:
	store i32 3, i32* %v6
	%tmp51 = call i8* @mem.malloc(i64 72)
	store %struct.GenericStructSymbolTableEntry* %tmp51, %struct.GenericStructSymbolTableEntry** %v7
	%tmp52 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %v6, i32 0, i32 2
	%tmp53 = load %struct.GenericStructSymbolTableEntry*, %struct.GenericStructSymbolTableEntry** %v7
	store i8* %tmp53, i8** %tmp52
	%tmp54 = load %struct.GenericStructSymbolTableEntry*, %struct.GenericStructSymbolTableEntry** %v7
	%tmp55 = getelementptr inbounds %struct.GenericStructSymbolTableEntry, %struct.GenericStructSymbolTableEntry* %tmp54, i32 0, i32 4
	%tmp56 = getelementptr inbounds %struct.StructNode, %struct.StructNode* %tmp42, i32 0, i32 1
	%tmp57 = load i8, i8* %tmp56
	store i8 %tmp57, i8* %tmp55
	%tmp58 = load %struct.GenericStructSymbolTableEntry*, %struct.GenericStructSymbolTableEntry** %v7
	%tmp59 = call %"struct.vector.Vec<%struct.GenericStructDefinedField>" @"vector.new<%struct.GenericStructDefinedField>"()
	store %"struct.vector.Vec<%struct.GenericStructDefinedField>" %tmp59, %"struct.vector.Vec<%struct.GenericStructDefinedField>"* %tmp58
	%tmp60 = load %struct.GenericStructSymbolTableEntry*, %struct.GenericStructSymbolTableEntry** %v7
	%tmp61 = getelementptr inbounds %struct.GenericStructSymbolTableEntry, %struct.GenericStructSymbolTableEntry* %tmp60, i32 0, i32 2
	%tmp62 = call %"struct.vector.Vec<%struct.vector.Vec<%struct.CompilerType>>" @"vector.new<%struct.vector.Vec<%struct.CompilerType>>"()
	store %"struct.vector.Vec<%struct.vector.Vec<%struct.CompilerType>>" %tmp62, %"struct.vector.Vec<%struct.vector.Vec<%struct.CompilerType>>"* %tmp61
	%tmp63 = load %struct.GenericStructSymbolTableEntry*, %struct.GenericStructSymbolTableEntry** %v7
	%tmp64 = getelementptr inbounds %struct.GenericStructSymbolTableEntry, %struct.GenericStructSymbolTableEntry* %tmp63, i32 0, i32 1
	%tmp65 = call %"struct.vector.Vec<ui16>" @"vector.new<ui16>"()
	store %"struct.vector.Vec<ui16>" %tmp65, %"struct.vector.Vec<ui16>"* %tmp64
	%tmp66 = getelementptr inbounds %struct.StructNode, %struct.StructNode* %tmp42, i32 0, i32 3
	%tmp67 = getelementptr inbounds %"struct.vector.Vec<ui16>", %"struct.vector.Vec<ui16>"* %tmp66, i32 0, i32 1
	%tmp68 = load i32, i32* %tmp67
	store i32 0, i32* %v8
	br label %loop_cond8
loop_cond8:
	%tmp69 = load i32, i32* %v8
	%tmp70 = getelementptr inbounds %struct.StructNode, %struct.StructNode* %tmp42, i32 0, i32 3
	%tmp71 = getelementptr inbounds %"struct.vector.Vec<ui16>", %"struct.vector.Vec<ui16>"* %tmp70, i32 0, i32 1
	%tmp72 = load i32, i32* %tmp71
	%tmp73 = icmp uge i32 %tmp69, %tmp72
	br i1 %tmp73, label %then9, label %endif9
then9:
	br label %loop_body8_exit
endif9:
	%tmp74 = load %struct.GenericStructSymbolTableEntry*, %struct.GenericStructSymbolTableEntry** %v7
	%tmp75 = getelementptr inbounds %struct.GenericStructSymbolTableEntry, %struct.GenericStructSymbolTableEntry* %tmp74, i32 0, i32 1
	%tmp77 = load i32, i32* %v8
	%tmp78 = getelementptr inbounds %struct.StructNode, %struct.StructNode* %tmp42, i32 0, i32 3
	%tmp79 = load i16*, i16** %tmp78
	%tmp80 = getelementptr inbounds i16, i16* %tmp79, i32 %tmp77
	%tmp81 = load i16, i16* %tmp80
	call void @"vector.push<ui16>"(%"struct.vector.Vec<ui16>"* %tmp75, i16 %tmp81)
	%tmp82 = load i32, i32* %v8
	%tmp83 = add i32 %tmp82, 1
	store i32 %tmp83, i32* %v8
	br label %loop_cond8
loop_body8_exit:
	br label %endif7
else7:
	store i32 2, i32* %v6
	%tmp84 = call i8* @mem.malloc(i64 48)
	store %struct.StructSymbolTableEntry* %tmp84, %struct.StructSymbolTableEntry** %v9
	%tmp85 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %v6, i32 0, i32 2
	%tmp86 = load %struct.StructSymbolTableEntry*, %struct.StructSymbolTableEntry** %v9
	store i8* %tmp86, i8** %tmp85
	%tmp87 = load %struct.StructSymbolTableEntry*, %struct.StructSymbolTableEntry** %v9
	%tmp88 = getelementptr inbounds %struct.StructSymbolTableEntry, %struct.StructSymbolTableEntry* %tmp87, i32 0, i32 3
	%tmp89 = getelementptr inbounds %struct.StructNode, %struct.StructNode* %tmp42, i32 0, i32 1
	%tmp90 = load i8, i8* %tmp89
	store i8 %tmp90, i8* %tmp88
	%tmp91 = load %struct.StructSymbolTableEntry*, %struct.StructSymbolTableEntry** %v9
	%tmp92 = call %"struct.vector.Vec<%struct.StructDefinedField>" @"vector.new<%struct.StructDefinedField>"()
	store %"struct.vector.Vec<%struct.StructDefinedField>" %tmp92, %"struct.vector.Vec<%struct.StructDefinedField>"* %tmp91
	%tmp93 = load %struct.StructSymbolTableEntry*, %struct.StructSymbolTableEntry** %v9
	%tmp94 = getelementptr inbounds %struct.StructSymbolTableEntry, %struct.StructSymbolTableEntry* %tmp93, i32 0, i32 1
	store i16 65535, i16* %v10
	%tmp95 = getelementptr inbounds %struct.Layout, %struct.Layout* %v10, i32 0, i32 1
	store i16 65535, i16* %tmp95
	%tmp96 = load %struct.Layout, %struct.Layout* %v10
	store %struct.Layout %tmp96, %struct.Layout* %tmp94
	br label %endif7
endif7:
	%tmp97 = load %struct.SymbolTableEntry, %struct.SymbolTableEntry* %v6
	call void @insert_symbol_into_table(%struct.SymbolTable* %symbol_table, %struct.SymbolTableEntry %tmp97)
	%tmp98 = load i32, i32* %v0
	%tmp99 = add i32 %tmp98, 1
	store i32 %tmp99, i32* %v0
	br label %loop_body0
; Variable sym_t_entry is out.
; Variable struct_path is out.
else6:
	%tmp100 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp101 = load i8, i8* %tmp100
	%tmp102 = icmp eq i8 %tmp101, 13
	br i1 %tmp102, label %then11, label %else11
then11:
	%tmp103 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp104 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp103, i32 0, i32 1
	%tmp105 = load i8*, i8** %tmp104
	%tmp106 = load i16, i16* %tmp105
	%tmp107 = call %struct.PathEx @path_to_path_ex_name(%struct.Path* %path, i16 %tmp106)
	store %struct.PathEx %tmp107, %struct.PathEx* %v11
	%tmp108 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %v12, i32 0, i32 1
	%tmp109 = load %struct.PathEx, %struct.PathEx* %v11
	store %struct.PathEx %tmp109, %struct.PathEx* %tmp108
	store i32 4, i32* %v12
	%tmp110 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %v12, i32 0, i32 2
	store i8* null, i8** %tmp110
	%tmp111 = load %struct.SymbolTableEntry, %struct.SymbolTableEntry* %v12
	call void @insert_symbol_into_table(%struct.SymbolTable* %symbol_table, %struct.SymbolTableEntry %tmp111)
	%tmp112 = load i32, i32* %v0
	%tmp113 = add i32 %tmp112, 1
	store i32 %tmp113, i32* %v0
	br label %loop_body0
; Variable sym_t_entry is out.
; Variable enum_path is out.
else11:
	%tmp114 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp115 = load i8, i8* %tmp114
	%tmp116 = icmp eq i8 %tmp115, 14
	br i1 %tmp116, label %then12, label %else12
then12:
	%tmp117 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp118 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp117, i32 0, i32 1
	%tmp119 = load i8*, i8** %tmp118
	%tmp120 = load %struct.Path, %struct.Path* %path
	store %struct.Path %tmp120, %struct.Path* %v13
	%tmp121 = load i8, i8* %v13
	%tmp122 = icmp eq i8 %tmp121, 8
	br i1 %tmp122, label %then13, label %endif13
then13:
	call void @process.throw(i8* @.str.321)
	br label %endif13
endif13:
	%tmp123 = getelementptr inbounds %struct.Path, %struct.Path* %v13, i32 0, i32 1
	%tmp124 = load i8, i8* %v13
	%tmp125 = getelementptr inbounds [8 x i16], [8 x i16]* %tmp123, i32 0, i8 %tmp124
	%tmp126 = load i16, i16* %tmp119
	store i16 %tmp126, i16* %tmp125
	%tmp127 = load i8, i8* %v13
	%tmp128 = add i8 %tmp127, 1
	store i8 %tmp128, i8* %v13
	%tmp129 = getelementptr inbounds %struct.NamespaceNode, %struct.NamespaceNode* %tmp119, i32 0, i32 1
	call void @compile_internal_sym_table_prefill(%struct.Path* %v13, %"struct.vector.Vec<%struct.Stmt>"* %tmp129, %struct.SymbolTable* %symbol_table, %struct.string.String* %stdout)
	%tmp130 = load i32, i32* %v0
	%tmp131 = add i32 %tmp130, 1
	store i32 %tmp131, i32* %v0
	br label %loop_body0
; Variable path is out.
else12:
	%tmp132 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp133 = load i8, i8* %tmp132
	%tmp134 = icmp eq i8 %tmp133, 1
	br i1 %tmp134, label %then14, label %endif14
then14:
	%tmp135 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp136 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp135, i32 0, i32 1
	%tmp137 = load i8*, i8** %tmp136
	%tmp138 = load i16, i16* %tmp137
	%tmp139 = call %struct.PathEx @path_to_path_ex_name(%struct.Path* %path, i16 %tmp138)
	store %struct.PathEx %tmp139, %struct.PathEx* %v14
	%tmp140 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %v15, i32 0, i32 1
	%tmp141 = load %struct.PathEx, %struct.PathEx* %v14
	store %struct.PathEx %tmp141, %struct.PathEx* %tmp140
	%tmp142 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp137, i32 0, i32 4
	%tmp143 = load i8, i8* %tmp142
	%tmp144 = icmp eq i8 %tmp143, 2
	br i1 %tmp144, label %then15, label %else15
then15:
	store i32 6, i32* %v15
	%tmp145 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp137, i32 0, i32 1
	%tmp146 = load i1, i1* %tmp145
	%tmp147 = xor i1 1, %tmp146
	br i1 %tmp147, label %then16, label %endif16
then16:
	call void @process.throw(i8* @.str.322)
	br label %endif16
endif16:
	br label %endif15
else15:
	%tmp148 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp137, i32 0, i32 4
	%tmp149 = load i8, i8* %tmp148
	%tmp150 = icmp eq i8 %tmp149, 1
	br i1 %tmp150, label %then17, label %else17
then17:
	store i32 5, i32* %v15
	br label %endif17
else17:
	%tmp151 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp137, i32 0, i32 4
	%tmp152 = load i8, i8* %tmp151
	%tmp153 = icmp eq i8 %tmp152, 0
	br i1 %tmp153, label %then18, label %endif18
then18:
	call void @process.throw(i8* @.str.323)
	br label %endif18
endif18:
	br label %endif17
endif17:
	br label %endif15
endif15:
	%tmp154 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %v15, i32 0, i32 2
	store i8* null, i8** %tmp154
	%tmp155 = load %struct.SymbolTableEntry, %struct.SymbolTableEntry* %v15
	call void @insert_symbol_into_table(%struct.SymbolTable* %symbol_table, %struct.SymbolTableEntry %tmp155)
	%tmp156 = load i32, i32* %v0
	%tmp157 = add i32 %tmp156, 1
	store i32 %tmp157, i32* %v0
	br label %loop_body0
; Variable sym_t_entry is out.
; Variable dec_path is out.
endif14:
	br label %endif2
endif2:
	store i32 0, i32* %v16
	br label %loop_cond19
loop_cond19:
	%tmp158 = load i32, i32* %v16
	%tmp159 = icmp uge i32 %tmp158, 3
	br i1 %tmp159, label %then20, label %endif20
then20:
	br label %loop_body19_exit
endif20:
	%tmp160 = load i32, i32* %v0
	%tmp161 = load i32, i32* %v16
	%tmp162 = add i32 %tmp160, %tmp161
	%tmp163 = load %struct.Stmt*, %struct.Stmt** %statement_vector
	%tmp164 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp163, i32 %tmp162
	%tmp165 = load i8, i8* %tmp164
	%tmp166 = zext i8 %tmp165 to i64
	call void @console.println_i64(i64 %tmp166)
	call void @console.write(i8* @.str.324, i32 6)
	%tmp167 = load i32, i32* %v16
	%tmp168 = add i32 %tmp167, 1
	store i32 %tmp168, i32* %v16
	br label %loop_cond19
loop_body19_exit:
	call void @process.throw(i8* @.str.325)
	br label %loop_body0
loop_body0:
	br label %loop_start0
loop_body0_exit:
	ret void
}
define void @compile_internal_sym_table(%struct.Path* %path, %"struct.vector.Vec<%struct.Stmt>"* %statement_vector, %struct.SymbolTable* %symbol_table, %struct.string.String* %stdout){
	%v0 = alloca i32
	%v1 = alloca i32
	%v2 = alloca %struct.Stmt*
	%v3 = alloca i32
	%v4 = alloca %struct.PathEx
	%v5 = alloca %struct.GenericFunctionSymbolTableEntry*
	%v6 = alloca %struct.CompilerType
	%v7 = alloca i32
	%v8 = alloca %struct.GenericStructDefinedField
	%v9 = alloca %struct.FunctionSymbolTableEntry*
	%v10 = alloca %struct.CompilerType
	%v11 = alloca i32
	%v12 = alloca %struct.StructDefinedField
	%v13 = alloca %struct.PathEx
	%v14 = alloca %struct.GenericStructSymbolTableEntry*
	%v15 = alloca i32
	%v16 = alloca %struct.GenericStructDefinedField
	%v17 = alloca %struct.string.String
	%v18 = alloca %struct.StructSymbolTableEntry*
	%v19 = alloca i32
	%v20 = alloca %struct.StructDefinedField
	%v21 = alloca %struct.string.String
	%v22 = alloca %struct.PathEx
	%v23 = alloca i64
	%v24 = alloca i32
	%v25 = alloca %struct.EnumDefinedField
	%v26 = alloca %struct.Rvalue
	%v27 = alloca %struct.Path
	%v28 = alloca %struct.PathEx
	%v29 = alloca %struct.Rvalue
	%v30 = alloca i32
	store i32 0, i32* %v0
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %statement_vector, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	store i32 %tmp1, i32* %v1
	%tmp2 = getelementptr inbounds %struct.SymbolTable, %struct.SymbolTable* %symbol_table, i32 0, i32 1
	%tmp3 = load %"struct.vector.Vec<%struct.string.String>"*, %"struct.vector.Vec<%struct.string.String>"** %tmp2
	%tmp4 = load %struct.string.String*, %struct.string.String** %tmp3
	br label %loop_start0
loop_start0:
	%tmp5 = load i32, i32* %v0
	%tmp6 = load i32, i32* %v1
	%tmp7 = icmp ult i32 %tmp5, %tmp6
	br i1 %tmp7, label %endif1, label %else1
else1:
	br label %loop_body0_exit
endif1:
	%tmp8 = load i32, i32* %v0
	%tmp9 = load %struct.Stmt*, %struct.Stmt** %statement_vector
	%tmp10 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp9, i32 %tmp8
	store %struct.Stmt* %tmp10, %struct.Stmt** %v2
	%tmp11 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp12 = load i8, i8* %tmp11
	%tmp13 = icmp eq i8 %tmp12, 0
	br i1 %tmp13, label %then2, label %else2
then2:
	call void @process.throw(i8* @.str.320)
	%tmp14 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp15 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp14, i32 0, i32 1
	%tmp16 = load i8*, i8** %tmp15
	call void @string.append(%struct.string.String* %stdout, i8 35)
	%tmp17 = load i16, i16* %tmp16
	%tmp18 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp4, i16 %tmp17
	%tmp19 = load i8*, i8** %tmp18
	%tmp20 = load i16, i16* %tmp16
	%tmp21 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp4, i16 %tmp20
	%tmp22 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp21, i32 0, i32 1
	%tmp23 = load i32, i32* %tmp22
	call void @string.append_str(%struct.string.String* %stdout, i8* %tmp19, i32 %tmp23)
	call void @string.append(%struct.string.String* %stdout, i8 40)
	%tmp24 = getelementptr inbounds %struct.HintNode, %struct.HintNode* %tmp16, i32 0, i32 1
	%tmp25 = getelementptr inbounds %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Expression>"* %tmp24, i32 0, i32 1
	%tmp26 = load i32, i32* %tmp25
	store i32 0, i32* %v3
	br label %loop_cond3
loop_cond3:
	%tmp27 = load i32, i32* %v3
	%tmp28 = getelementptr inbounds %struct.HintNode, %struct.HintNode* %tmp16, i32 0, i32 1
	%tmp29 = getelementptr inbounds %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Expression>"* %tmp28, i32 0, i32 1
	%tmp30 = load i32, i32* %tmp29
	%tmp31 = icmp uge i32 %tmp27, %tmp30
	br i1 %tmp31, label %then4, label %endif4
then4:
	br label %loop_body3_exit
endif4:
	%tmp33 = load i32, i32* %v3
	%tmp34 = getelementptr inbounds %struct.HintNode, %struct.HintNode* %tmp16, i32 0, i32 1
	%tmp35 = load %struct.Expression*, %struct.Expression** %tmp34
	%tmp36 = getelementptr inbounds %struct.Expression, %struct.Expression* %tmp35, i32 %tmp33
	call void @debug_dump_expression(%struct.Expression* %tmp36, %"struct.vector.Vec<%struct.string.String>"* %tmp3, %struct.string.String* %stdout)
	%tmp37 = load i32, i32* %v3
	%tmp38 = getelementptr inbounds %struct.HintNode, %struct.HintNode* %tmp16, i32 0, i32 1
	%tmp39 = getelementptr inbounds %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Expression>"* %tmp38, i32 0, i32 1
	%tmp40 = load i32, i32* %tmp39
	%tmp41 = sub i32 %tmp40, 1
	%tmp42 = icmp ne i32 %tmp37, %tmp41
	br i1 %tmp42, label %then5, label %endif5
then5:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.89, i32 2)
	br label %endif5
endif5:
	%tmp43 = load i32, i32* %v3
	%tmp44 = add i32 %tmp43, 1
	store i32 %tmp44, i32* %v3
	br label %loop_cond3
loop_body3_exit:
	call void @string.append(%struct.string.String* %stdout, i8 41)
	call void @string.append(%struct.string.String* %stdout, i8 10)
	%tmp45 = load i32, i32* %v0
	%tmp46 = add i32 %tmp45, 1
	store i32 %tmp46, i32* %v0
	br label %loop_body0
else2:
	%tmp47 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp48 = load i8, i8* %tmp47
	%tmp49 = icmp eq i8 %tmp48, 20
	br i1 %tmp49, label %then6, label %else6
then6:
	%tmp50 = load i32, i32* %v0
	%tmp51 = add i32 %tmp50, 1
	store i32 %tmp51, i32* %v0
	br label %loop_body0
else6:
	%tmp52 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp53 = load i8, i8* %tmp52
	%tmp54 = icmp eq i8 %tmp53, 11
	br i1 %tmp54, label %then7, label %else7
then7:
	%tmp55 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp56 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp55, i32 0, i32 1
	%tmp57 = load i8*, i8** %tmp56
	%tmp58 = load i16, i16* %tmp57
	%tmp59 = call %struct.PathEx @path_to_path_ex_name(%struct.Path* %path, i16 %tmp58)
	store %struct.PathEx %tmp59, %struct.PathEx* %v4
	%tmp60 = load %struct.PathEx, %struct.PathEx* %v4
	%tmp61 = call %struct.SymbolTableEntry* @get_symbol_from_table(%struct.SymbolTable* %symbol_table, %struct.PathEx %tmp60)
	%tmp62 = getelementptr inbounds %struct.FnNode, %struct.FnNode* %tmp57, i32 0, i32 5
	%tmp63 = getelementptr inbounds %"struct.vector.Vec<ui16>", %"struct.vector.Vec<ui16>"* %tmp62, i32 0, i32 1
	%tmp64 = load i32, i32* %tmp63
	%tmp65 = icmp ne i32 %tmp64, 0
	br i1 %tmp65, label %then8, label %endif8
then8:
	%tmp66 = call i8* @mem.malloc(i64 96)
	store %struct.GenericFunctionSymbolTableEntry* %tmp66, %struct.GenericFunctionSymbolTableEntry** %v5
	%tmp67 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp61, i32 0, i32 2
	%tmp68 = load %struct.GenericFunctionSymbolTableEntry*, %struct.GenericFunctionSymbolTableEntry** %v5
	store i8* %tmp68, i8** %tmp67
	%tmp69 = load %struct.GenericFunctionSymbolTableEntry*, %struct.GenericFunctionSymbolTableEntry** %v5
	%tmp70 = getelementptr inbounds %struct.GenericFunctionSymbolTableEntry, %struct.GenericFunctionSymbolTableEntry* %tmp69, i32 0, i32 6
	%tmp71 = getelementptr inbounds %struct.FnNode, %struct.FnNode* %tmp57, i32 0, i32 1
	%tmp72 = load i8, i8* %tmp71
	store i8 %tmp72, i8* %tmp70
	%tmp73 = load %struct.GenericFunctionSymbolTableEntry*, %struct.GenericFunctionSymbolTableEntry** %v5
	%tmp74 = call %"struct.vector.Vec<%struct.GenericStructDefinedField>" @"vector.new<%struct.GenericStructDefinedField>"()
	store %"struct.vector.Vec<%struct.GenericStructDefinedField>" %tmp74, %"struct.vector.Vec<%struct.GenericStructDefinedField>"* %tmp73
	%tmp75 = getelementptr inbounds %struct.FnNode, %struct.FnNode* %tmp57, i32 0, i32 3
	%tmp76 = load i1, i1* %tmp75
	br i1 %tmp76, label %then9, label %else9
then9:
	%tmp77 = load %struct.GenericFunctionSymbolTableEntry*, %struct.GenericFunctionSymbolTableEntry** %v5
	%tmp78 = getelementptr inbounds %struct.GenericFunctionSymbolTableEntry, %struct.GenericFunctionSymbolTableEntry* %tmp77, i32 0, i32 1
	%tmp79 = getelementptr inbounds %struct.FnNode, %struct.FnNode* %tmp57, i32 0, i32 4
	%tmp80 = getelementptr inbounds %struct.FnNode, %struct.FnNode* %tmp57, i32 0, i32 5
	%tmp81 = load %struct.GenericFunctionSymbolTableEntry*, %struct.GenericFunctionSymbolTableEntry** %v5
	%tmp82 = getelementptr inbounds %struct.GenericFunctionSymbolTableEntry, %struct.GenericFunctionSymbolTableEntry* %tmp81, i32 0, i32 2
	%tmp83 = call i1 @get_compiler_type_generic(%struct.Type* %tmp79, %struct.Path* %path, %struct.SymbolTable* %symbol_table, %"struct.vector.Vec<ui16>"* %tmp80, %struct.CompilerType* %tmp82)
	store i1 %tmp83, i1* %tmp78
	br label %endif9
else9:
	%tmp84 = load %struct.PrimitiveTypeInfo*, %struct.PrimitiveTypeInfo** @VOID_TYPE
	store i32 0, i32* %v6
	%tmp85 = getelementptr inbounds %struct.CompilerType, %struct.CompilerType* %v6, i32 0, i32 1
	store i8* %tmp84, i8** %tmp85
	%tmp86 = load %struct.GenericFunctionSymbolTableEntry*, %struct.GenericFunctionSymbolTableEntry** %v5
	%tmp87 = getelementptr inbounds %struct.GenericFunctionSymbolTableEntry, %struct.GenericFunctionSymbolTableEntry* %tmp86, i32 0, i32 1
	store i1 false, i1* %tmp87
	%tmp88 = load %struct.GenericFunctionSymbolTableEntry*, %struct.GenericFunctionSymbolTableEntry** %v5
	%tmp89 = getelementptr inbounds %struct.GenericFunctionSymbolTableEntry, %struct.GenericFunctionSymbolTableEntry* %tmp88, i32 0, i32 2
	%tmp90 = load %struct.CompilerType, %struct.CompilerType* %v6
	store %struct.CompilerType %tmp90, %struct.CompilerType* %tmp89
; Variable z is out.
	br label %endif9
endif9:
	%tmp91 = getelementptr inbounds %struct.FnNode, %struct.FnNode* %tmp57, i32 0, i32 2
	%tmp92 = getelementptr inbounds %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %tmp91, i32 0, i32 1
	%tmp93 = load i32, i32* %tmp92
	store i32 0, i32* %v7
	br label %loop_cond10
loop_cond10:
	%tmp94 = load i32, i32* %v7
	%tmp95 = getelementptr inbounds %struct.FnNode, %struct.FnNode* %tmp57, i32 0, i32 2
	%tmp96 = getelementptr inbounds %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %tmp95, i32 0, i32 1
	%tmp97 = load i32, i32* %tmp96
	%tmp98 = icmp uge i32 %tmp94, %tmp97
	br i1 %tmp98, label %then11, label %endif11
then11:
	br label %loop_body10_exit
endif11:
	%tmp100 = load i32, i32* %v7
	%tmp101 = getelementptr inbounds %struct.FnNode, %struct.FnNode* %tmp57, i32 0, i32 2
	%tmp102 = load %struct.Argument*, %struct.Argument** %tmp101
	%tmp103 = getelementptr inbounds %struct.Argument, %struct.Argument* %tmp102, i32 %tmp100
	%tmp104 = load i16, i16* %tmp103
	store i16 %tmp104, i16* %v8
	%tmp105 = getelementptr inbounds %struct.GenericStructDefinedField, %struct.GenericStructDefinedField* %v8, i32 0, i32 2
	%tmp106 = getelementptr inbounds %struct.Argument, %struct.Argument* %tmp103, i32 0, i32 1
	%tmp107 = getelementptr inbounds %struct.FnNode, %struct.FnNode* %tmp57, i32 0, i32 5
	%tmp108 = getelementptr inbounds %struct.GenericStructDefinedField, %struct.GenericStructDefinedField* %v8, i32 0, i32 1
	%tmp109 = call i1 @get_compiler_type_generic(%struct.Type* %tmp106, %struct.Path* %path, %struct.SymbolTable* %symbol_table, %"struct.vector.Vec<ui16>"* %tmp107, %struct.CompilerType* %tmp108)
	store i1 %tmp109, i1* %tmp105
	%tmp110 = load %struct.GenericFunctionSymbolTableEntry*, %struct.GenericFunctionSymbolTableEntry** %v5
	%tmp111 = load %struct.GenericStructDefinedField, %struct.GenericStructDefinedField* %v8
	call void @"vector.push<%struct.GenericStructDefinedField>"(%"struct.vector.Vec<%struct.GenericStructDefinedField>"* %tmp110, %struct.GenericStructDefinedField %tmp111)
	%tmp112 = load i32, i32* %v7
	%tmp113 = add i32 %tmp112, 1
	store i32 %tmp113, i32* %v7
	br label %loop_cond10
loop_body10_exit:
; Variable sdf is out.
	%tmp114 = load i32, i32* %v0
	%tmp115 = add i32 %tmp114, 1
	store i32 %tmp115, i32* %v0
	br label %loop_body0
endif8:
	%tmp116 = call i8* @mem.malloc(i64 56)
	store %struct.FunctionSymbolTableEntry* %tmp116, %struct.FunctionSymbolTableEntry** %v9
	%tmp117 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp61, i32 0, i32 2
	%tmp118 = load %struct.FunctionSymbolTableEntry*, %struct.FunctionSymbolTableEntry** %v9
	store i8* %tmp118, i8** %tmp117
	%tmp119 = load %struct.FunctionSymbolTableEntry*, %struct.FunctionSymbolTableEntry** %v9
	%tmp120 = getelementptr inbounds %struct.FunctionSymbolTableEntry, %struct.FunctionSymbolTableEntry* %tmp119, i32 0, i32 3
	%tmp121 = getelementptr inbounds %struct.FnNode, %struct.FnNode* %tmp57, i32 0, i32 1
	%tmp122 = load i8, i8* %tmp121
	store i8 %tmp122, i8* %tmp120
	%tmp123 = load %struct.FunctionSymbolTableEntry*, %struct.FunctionSymbolTableEntry** %v9
	%tmp124 = call %"struct.vector.Vec<%struct.StructDefinedField>" @"vector.new<%struct.StructDefinedField>"()
	store %"struct.vector.Vec<%struct.StructDefinedField>" %tmp124, %"struct.vector.Vec<%struct.StructDefinedField>"* %tmp123
	%tmp125 = getelementptr inbounds %struct.FnNode, %struct.FnNode* %tmp57, i32 0, i32 3
	%tmp126 = load i1, i1* %tmp125
	br i1 %tmp126, label %then12, label %else12
then12:
	%tmp127 = load %struct.FunctionSymbolTableEntry*, %struct.FunctionSymbolTableEntry** %v9
	%tmp128 = getelementptr inbounds %struct.FunctionSymbolTableEntry, %struct.FunctionSymbolTableEntry* %tmp127, i32 0, i32 1
	%tmp129 = getelementptr inbounds %struct.FnNode, %struct.FnNode* %tmp57, i32 0, i32 4
	%tmp130 = call %struct.CompilerType @get_compiler_type(%struct.Type* %tmp129, %struct.Path* %path, %struct.SymbolTable* %symbol_table)
	store %struct.CompilerType %tmp130, %struct.CompilerType* %tmp128
	br label %endif12
else12:
	%tmp131 = load %struct.PrimitiveTypeInfo*, %struct.PrimitiveTypeInfo** @VOID_TYPE
	store i32 0, i32* %v10
	%tmp132 = getelementptr inbounds %struct.CompilerType, %struct.CompilerType* %v10, i32 0, i32 1
	store i8* %tmp131, i8** %tmp132
	%tmp133 = load %struct.FunctionSymbolTableEntry*, %struct.FunctionSymbolTableEntry** %v9
	%tmp134 = getelementptr inbounds %struct.FunctionSymbolTableEntry, %struct.FunctionSymbolTableEntry* %tmp133, i32 0, i32 1
	%tmp135 = load %struct.CompilerType, %struct.CompilerType* %v10
	store %struct.CompilerType %tmp135, %struct.CompilerType* %tmp134
; Variable z is out.
	br label %endif12
endif12:
	%tmp136 = getelementptr inbounds %struct.FnNode, %struct.FnNode* %tmp57, i32 0, i32 2
	%tmp137 = getelementptr inbounds %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %tmp136, i32 0, i32 1
	%tmp138 = load i32, i32* %tmp137
	store i32 0, i32* %v11
	br label %loop_cond13
loop_cond13:
	%tmp139 = load i32, i32* %v11
	%tmp140 = getelementptr inbounds %struct.FnNode, %struct.FnNode* %tmp57, i32 0, i32 2
	%tmp141 = getelementptr inbounds %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %tmp140, i32 0, i32 1
	%tmp142 = load i32, i32* %tmp141
	%tmp143 = icmp uge i32 %tmp139, %tmp142
	br i1 %tmp143, label %then14, label %endif14
then14:
	br label %loop_body13_exit
endif14:
	%tmp145 = load i32, i32* %v11
	%tmp146 = getelementptr inbounds %struct.FnNode, %struct.FnNode* %tmp57, i32 0, i32 2
	%tmp147 = load %struct.Argument*, %struct.Argument** %tmp146
	%tmp148 = getelementptr inbounds %struct.Argument, %struct.Argument* %tmp147, i32 %tmp145
	%tmp149 = load i16, i16* %tmp148
	store i16 %tmp149, i16* %v12
	%tmp150 = getelementptr inbounds %struct.StructDefinedField, %struct.StructDefinedField* %v12, i32 0, i32 1
	%tmp151 = getelementptr inbounds %struct.Argument, %struct.Argument* %tmp148, i32 0, i32 1
	%tmp152 = call %struct.CompilerType @get_compiler_type(%struct.Type* %tmp151, %struct.Path* %path, %struct.SymbolTable* %symbol_table)
	store %struct.CompilerType %tmp152, %struct.CompilerType* %tmp150
	%tmp153 = load %struct.FunctionSymbolTableEntry*, %struct.FunctionSymbolTableEntry** %v9
	%tmp154 = load %struct.StructDefinedField, %struct.StructDefinedField* %v12
	call void @"vector.push<%struct.StructDefinedField>"(%"struct.vector.Vec<%struct.StructDefinedField>"* %tmp153, %struct.StructDefinedField %tmp154)
	%tmp155 = load i32, i32* %v11
	%tmp156 = add i32 %tmp155, 1
	store i32 %tmp156, i32* %v11
	br label %loop_cond13
loop_body13_exit:
; Variable sf is out.
	%tmp157 = load %struct.FunctionSymbolTableEntry*, %struct.FunctionSymbolTableEntry** %v9
	%tmp158 = getelementptr inbounds %struct.FunctionSymbolTableEntry, %struct.FunctionSymbolTableEntry* %tmp157, i32 0, i32 2
	%tmp159 = getelementptr inbounds %struct.FnNode, %struct.FnNode* %tmp57, i32 0, i32 6
	%tmp160 = load %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %tmp159
	store %"struct.vector.Vec<%struct.Stmt>" %tmp160, %"struct.vector.Vec<%struct.Stmt>"* %tmp158
	%tmp161 = load i32, i32* %tmp61
	%tmp162 = or i32 %tmp161, 8
	store i32 %tmp162, i32* %tmp61
	%tmp163 = load i32, i32* %v0
	%tmp164 = add i32 %tmp163, 1
	store i32 %tmp164, i32* %v0
	br label %loop_body0
; Variable func_path is out.
else7:
	%tmp165 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp166 = load i8, i8* %tmp165
	%tmp167 = icmp eq i8 %tmp166, 12
	br i1 %tmp167, label %then15, label %else15
then15:
	%tmp168 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp169 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp168, i32 0, i32 1
	%tmp170 = load i8*, i8** %tmp169
	%tmp171 = load i16, i16* %tmp170
	%tmp172 = call %struct.PathEx @path_to_path_ex_name(%struct.Path* %path, i16 %tmp171)
	store %struct.PathEx %tmp172, %struct.PathEx* %v13
	%tmp173 = load %struct.PathEx, %struct.PathEx* %v13
	%tmp174 = call %struct.SymbolTableEntry* @get_symbol_from_table(%struct.SymbolTable* %symbol_table, %struct.PathEx %tmp173)
	%tmp175 = getelementptr inbounds %struct.StructNode, %struct.StructNode* %tmp170, i32 0, i32 3
	%tmp176 = getelementptr inbounds %"struct.vector.Vec<ui16>", %"struct.vector.Vec<ui16>"* %tmp175, i32 0, i32 1
	%tmp177 = load i32, i32* %tmp176
	%tmp178 = icmp ne i32 %tmp177, 0
	br i1 %tmp178, label %then16, label %endif16
then16:
	%tmp179 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp174, i32 0, i32 2
	%tmp180 = load i8*, i8** %tmp179
	store %struct.GenericStructSymbolTableEntry* %tmp180, %struct.GenericStructSymbolTableEntry** %v14
	%tmp181 = getelementptr inbounds %struct.StructNode, %struct.StructNode* %tmp170, i32 0, i32 2
	%tmp182 = getelementptr inbounds %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %tmp181, i32 0, i32 1
	%tmp183 = load i32, i32* %tmp182
	store i32 0, i32* %v15
	br label %loop_cond17
loop_cond17:
	%tmp184 = load i32, i32* %v15
	%tmp185 = getelementptr inbounds %struct.StructNode, %struct.StructNode* %tmp170, i32 0, i32 2
	%tmp186 = getelementptr inbounds %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %tmp185, i32 0, i32 1
	%tmp187 = load i32, i32* %tmp186
	%tmp188 = icmp uge i32 %tmp184, %tmp187
	br i1 %tmp188, label %then18, label %endif18
then18:
	br label %loop_body17_exit
endif18:
	%tmp190 = load i32, i32* %v15
	%tmp191 = getelementptr inbounds %struct.StructNode, %struct.StructNode* %tmp170, i32 0, i32 2
	%tmp192 = load %struct.Argument*, %struct.Argument** %tmp191
	%tmp193 = getelementptr inbounds %struct.Argument, %struct.Argument* %tmp192, i32 %tmp190
	%tmp194 = load i16, i16* %tmp193
	store i16 %tmp194, i16* %v16
	%tmp195 = getelementptr inbounds %struct.GenericStructDefinedField, %struct.GenericStructDefinedField* %v16, i32 0, i32 2
	%tmp196 = getelementptr inbounds %struct.Argument, %struct.Argument* %tmp193, i32 0, i32 1
	%tmp197 = getelementptr inbounds %struct.StructNode, %struct.StructNode* %tmp170, i32 0, i32 3
	%tmp198 = getelementptr inbounds %struct.GenericStructDefinedField, %struct.GenericStructDefinedField* %v16, i32 0, i32 1
	%tmp199 = call i1 @get_compiler_type_generic(%struct.Type* %tmp196, %struct.Path* %path, %struct.SymbolTable* %symbol_table, %"struct.vector.Vec<ui16>"* %tmp197, %struct.CompilerType* %tmp198)
	store i1 %tmp199, i1* %tmp195
	%tmp200 = load %struct.GenericStructSymbolTableEntry*, %struct.GenericStructSymbolTableEntry** %v14
	%tmp201 = load %struct.GenericStructDefinedField, %struct.GenericStructDefinedField* %v16
	call void @"vector.push<%struct.GenericStructDefinedField>"(%"struct.vector.Vec<%struct.GenericStructDefinedField>"* %tmp200, %struct.GenericStructDefinedField %tmp201)
	%tmp202 = load i32, i32* %v15
	%tmp203 = add i32 %tmp202, 1
	store i32 %tmp203, i32* %v15
	br label %loop_cond17
loop_body17_exit:
; Variable sdf is out.
	%tmp204 = call %struct.string.String @string.from_c_string(i8* @.str.326)
	store %struct.string.String %tmp204, %struct.string.String* %v17
	%tmp205 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp174, i32 0, i32 1
	%tmp206 = getelementptr inbounds %struct.SymbolTable, %struct.SymbolTable* %symbol_table, i32 0, i32 1
	%tmp207 = getelementptr inbounds %struct.SymbolTable, %struct.SymbolTable* %symbol_table, i32 0, i32 1
	%tmp208 = load %"struct.vector.Vec<%struct.string.String>"*, %"struct.vector.Vec<%struct.string.String>"** %tmp207
	%tmp209 = load %struct.string.String*, %struct.string.String** %tmp208
	call void @append_path_ex(%struct.PathEx* %tmp205, %struct.string.String* %tmp209, %struct.string.String* %v17)
	%tmp210 = load %struct.GenericStructSymbolTableEntry*, %struct.GenericStructSymbolTableEntry** %v14
	%tmp211 = getelementptr inbounds %struct.GenericStructSymbolTableEntry, %struct.GenericStructSymbolTableEntry* %tmp210, i32 0, i32 3
	%tmp212 = load %struct.string.String, %struct.string.String* %v17
	store %struct.string.String %tmp212, %struct.string.String* %tmp211
	%tmp213 = load i32, i32* %tmp174
	%tmp214 = or i32 %tmp213, 8
	store i32 %tmp214, i32* %tmp174
	%tmp215 = load i32, i32* %v0
	%tmp216 = add i32 %tmp215, 1
	store i32 %tmp216, i32* %v0
	br label %loop_body0
; Variable llvm_signature is out.
endif16:
	%tmp217 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp174, i32 0, i32 2
	%tmp218 = load i8*, i8** %tmp217
	store %struct.StructSymbolTableEntry* %tmp218, %struct.StructSymbolTableEntry** %v18
	%tmp219 = getelementptr inbounds %struct.StructNode, %struct.StructNode* %tmp170, i32 0, i32 2
	%tmp220 = getelementptr inbounds %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %tmp219, i32 0, i32 1
	%tmp221 = load i32, i32* %tmp220
	store i32 0, i32* %v19
	br label %loop_cond19
loop_cond19:
	%tmp222 = load i32, i32* %v19
	%tmp223 = getelementptr inbounds %struct.StructNode, %struct.StructNode* %tmp170, i32 0, i32 2
	%tmp224 = getelementptr inbounds %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %tmp223, i32 0, i32 1
	%tmp225 = load i32, i32* %tmp224
	%tmp226 = icmp uge i32 %tmp222, %tmp225
	br i1 %tmp226, label %then20, label %endif20
then20:
	br label %loop_body19_exit
endif20:
	%tmp228 = load i32, i32* %v19
	%tmp229 = getelementptr inbounds %struct.StructNode, %struct.StructNode* %tmp170, i32 0, i32 2
	%tmp230 = load %struct.Argument*, %struct.Argument** %tmp229
	%tmp231 = getelementptr inbounds %struct.Argument, %struct.Argument* %tmp230, i32 %tmp228
	%tmp232 = load i16, i16* %tmp231
	store i16 %tmp232, i16* %v20
	%tmp233 = getelementptr inbounds %struct.StructDefinedField, %struct.StructDefinedField* %v20, i32 0, i32 1
	%tmp234 = getelementptr inbounds %struct.Argument, %struct.Argument* %tmp231, i32 0, i32 1
	%tmp235 = call %struct.CompilerType @get_compiler_type(%struct.Type* %tmp234, %struct.Path* %path, %struct.SymbolTable* %symbol_table)
	store %struct.CompilerType %tmp235, %struct.CompilerType* %tmp233
	%tmp236 = load %struct.StructSymbolTableEntry*, %struct.StructSymbolTableEntry** %v18
	%tmp237 = load %struct.StructDefinedField, %struct.StructDefinedField* %v20
	call void @"vector.push<%struct.StructDefinedField>"(%"struct.vector.Vec<%struct.StructDefinedField>"* %tmp236, %struct.StructDefinedField %tmp237)
	%tmp238 = load i32, i32* %v19
	%tmp239 = add i32 %tmp238, 1
	store i32 %tmp239, i32* %v19
	br label %loop_cond19
loop_body19_exit:
; Variable sdf is out.
	%tmp240 = call %struct.string.String @string.from_c_string(i8* @.str.326)
	store %struct.string.String %tmp240, %struct.string.String* %v21
	%tmp241 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp174, i32 0, i32 1
	%tmp242 = getelementptr inbounds %struct.SymbolTable, %struct.SymbolTable* %symbol_table, i32 0, i32 1
	%tmp243 = getelementptr inbounds %struct.SymbolTable, %struct.SymbolTable* %symbol_table, i32 0, i32 1
	%tmp244 = load %"struct.vector.Vec<%struct.string.String>"*, %"struct.vector.Vec<%struct.string.String>"** %tmp243
	%tmp245 = load %struct.string.String*, %struct.string.String** %tmp244
	call void @append_path_ex(%struct.PathEx* %tmp241, %struct.string.String* %tmp245, %struct.string.String* %v21)
	%tmp246 = load %struct.StructSymbolTableEntry*, %struct.StructSymbolTableEntry** %v18
	%tmp247 = getelementptr inbounds %struct.StructSymbolTableEntry, %struct.StructSymbolTableEntry* %tmp246, i32 0, i32 2
	%tmp248 = load %struct.string.String, %struct.string.String* %v21
	store %struct.string.String %tmp248, %struct.string.String* %tmp247
	%tmp249 = load i32, i32* %tmp174
	%tmp250 = or i32 %tmp249, 8
	store i32 %tmp250, i32* %tmp174
	%tmp251 = load i32, i32* %v0
	%tmp252 = add i32 %tmp251, 1
	store i32 %tmp252, i32* %v0
	br label %loop_body0
; Variable llvm_signature is out.
; Variable struct_path is out.
else15:
	%tmp253 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp254 = load i8, i8* %tmp253
	%tmp255 = icmp eq i8 %tmp254, 13
	br i1 %tmp255, label %then21, label %else21
then21:
	%tmp256 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp257 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp256, i32 0, i32 1
	%tmp258 = load i8*, i8** %tmp257
	%tmp259 = load i16, i16* %tmp258
	%tmp260 = call %struct.PathEx @path_to_path_ex_name(%struct.Path* %path, i16 %tmp259)
	store %struct.PathEx %tmp260, %struct.PathEx* %v22
	%tmp261 = load %struct.PathEx, %struct.PathEx* %v22
	%tmp262 = call %struct.SymbolTableEntry* @get_symbol_from_table(%struct.SymbolTable* %symbol_table, %struct.PathEx %tmp261)
	%tmp263 = call i8* @mem.malloc(i64 40)
	%tmp264 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp262, i32 0, i32 2
	store i8* %tmp263, i8** %tmp264
	%tmp265 = getelementptr inbounds %struct.EnumSymbolTableEntry, %struct.EnumSymbolTableEntry* %tmp263, i32 0, i32 2
	%tmp266 = getelementptr inbounds %struct.EnumNode, %struct.EnumNode* %tmp258, i32 0, i32 1
	%tmp267 = load i8, i8* %tmp266
	store i8 %tmp267, i8* %tmp265
	store i32 0, i32* %tmp263
	%tmp268 = getelementptr inbounds %struct.CompilerType, %struct.CompilerType* %tmp263, i32 0, i32 1
	%tmp269 = load %struct.PrimitiveTypeInfo*, %struct.PrimitiveTypeInfo** @DEFAULT_INTEGER_TYPE
	store i8* %tmp269, i8** %tmp268
	%tmp270 = getelementptr inbounds %struct.EnumNode, %struct.EnumNode* %tmp258, i32 0, i32 2
	%tmp271 = load i1, i1* %tmp270
	br i1 %tmp271, label %then22, label %endif22
then22:
	%tmp272 = getelementptr inbounds %struct.EnumNode, %struct.EnumNode* %tmp258, i32 0, i32 3
	%tmp273 = call %struct.CompilerType @get_compiler_type(%struct.Type* %tmp272, %struct.Path* %path, %struct.SymbolTable* %symbol_table)
	store %struct.CompilerType %tmp273, %struct.CompilerType* %tmp263
	br label %endif22
endif22:
	%tmp274 = getelementptr inbounds %struct.EnumSymbolTableEntry, %struct.EnumSymbolTableEntry* %tmp263, i32 0, i32 1
	%tmp275 = call %"struct.vector.Vec<%struct.EnumDefinedField>" @"vector.new<%struct.EnumDefinedField>"()
	store %"struct.vector.Vec<%struct.EnumDefinedField>" %tmp275, %"struct.vector.Vec<%struct.EnumDefinedField>"* %tmp274
	store i64 0, i64* %v23
	%tmp276 = getelementptr inbounds %struct.EnumNode, %struct.EnumNode* %tmp258, i32 0, i32 4
	%tmp277 = getelementptr inbounds %"struct.vector.Vec<%struct.EnumField>", %"struct.vector.Vec<%struct.EnumField>"* %tmp276, i32 0, i32 1
	%tmp278 = load i32, i32* %tmp277
	store i32 0, i32* %v24
	br label %loop_cond23
loop_cond23:
	%tmp279 = load i32, i32* %v24
	%tmp280 = getelementptr inbounds %struct.EnumNode, %struct.EnumNode* %tmp258, i32 0, i32 4
	%tmp281 = getelementptr inbounds %"struct.vector.Vec<%struct.EnumField>", %"struct.vector.Vec<%struct.EnumField>"* %tmp280, i32 0, i32 1
	%tmp282 = load i32, i32* %tmp281
	%tmp283 = icmp uge i32 %tmp279, %tmp282
	br i1 %tmp283, label %then24, label %endif24
then24:
	br label %loop_body23_exit
endif24:
	%tmp285 = load i32, i32* %v24
	%tmp286 = getelementptr inbounds %struct.EnumNode, %struct.EnumNode* %tmp258, i32 0, i32 4
	%tmp287 = load %struct.EnumField*, %struct.EnumField** %tmp286
	%tmp288 = getelementptr inbounds %struct.EnumField, %struct.EnumField* %tmp287, i32 %tmp285
	%tmp289 = load i16, i16* %tmp288
	store i16 %tmp289, i16* %v25
	%tmp290 = getelementptr inbounds %struct.EnumField, %struct.EnumField* %tmp288, i32 0, i32 1
	%tmp291 = load i1, i1* %tmp290
	br i1 %tmp291, label %then25, label %endif25
then25:
	%tmp292 = getelementptr inbounds %struct.EnumField, %struct.EnumField* %tmp288, i32 0, i32 2
	%tmp293 = call %struct.Rvalue @constant_evaluate_expression(%struct.Expression* %tmp292, %struct.SymbolTable* %symbol_table)
	store %struct.Rvalue %tmp293, %struct.Rvalue* %v26
	%tmp294 = load i32, i32* %v26
	%tmp295 = icmp ne i32 %tmp294, 1
	br i1 %tmp295, label %then26, label %endif26
then26:
	call void @process.throw(i8* @.str.327)
	br label %endif26
endif26:
	%tmp296 = getelementptr inbounds %struct.Rvalue, %struct.Rvalue* %v26, i32 0, i32 1
	%tmp297 = load i8*, i8** %tmp296
	%tmp298 = ptrtoint i8* %tmp297 to i64
	store i64 %tmp298, i64* %v23
; Variable rval is out.
	br label %endif25
endif25:
	%tmp299 = getelementptr inbounds %struct.EnumDefinedField, %struct.EnumDefinedField* %v25, i32 0, i32 1
	%tmp300 = load i64, i64* %v23
	store i64 %tmp300, i64* %tmp299
	%tmp301 = load i64, i64* %v23
	%tmp302 = add i64 %tmp301, 1
	store i64 %tmp302, i64* %v23
	%tmp303 = getelementptr inbounds %struct.EnumSymbolTableEntry, %struct.EnumSymbolTableEntry* %tmp263, i32 0, i32 1
	%tmp304 = load %struct.EnumDefinedField, %struct.EnumDefinedField* %v25
	call void @"vector.push<%struct.EnumDefinedField>"(%"struct.vector.Vec<%struct.EnumDefinedField>"* %tmp303, %struct.EnumDefinedField %tmp304)
	%tmp305 = load i32, i32* %v24
	%tmp306 = add i32 %tmp305, 1
	store i32 %tmp306, i32* %v24
	br label %loop_cond23
loop_body23_exit:
; Variable edf is out.
	%tmp307 = load i32, i32* %tmp262
	%tmp308 = or i32 %tmp307, 8
	store i32 %tmp308, i32* %tmp262
	%tmp309 = load i32, i32* %v0
	%tmp310 = add i32 %tmp309, 1
	store i32 %tmp310, i32* %v0
	br label %loop_body0
; Variable dec_path is out.
else21:
	%tmp311 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp312 = load i8, i8* %tmp311
	%tmp313 = icmp eq i8 %tmp312, 14
	br i1 %tmp313, label %then27, label %else27
then27:
	%tmp314 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp315 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp314, i32 0, i32 1
	%tmp316 = load i8*, i8** %tmp315
	%tmp317 = load %struct.Path, %struct.Path* %path
	store %struct.Path %tmp317, %struct.Path* %v27
	%tmp318 = load i8, i8* %v27
	%tmp319 = icmp eq i8 %tmp318, 8
	br i1 %tmp319, label %then28, label %endif28
then28:
	call void @process.throw(i8* @.str.321)
	br label %endif28
endif28:
	%tmp320 = getelementptr inbounds %struct.Path, %struct.Path* %v27, i32 0, i32 1
	%tmp321 = load i8, i8* %v27
	%tmp322 = getelementptr inbounds [8 x i16], [8 x i16]* %tmp320, i32 0, i8 %tmp321
	%tmp323 = load i16, i16* %tmp316
	store i16 %tmp323, i16* %tmp322
	%tmp324 = load i8, i8* %v27
	%tmp325 = add i8 %tmp324, 1
	store i8 %tmp325, i8* %v27
	%tmp326 = getelementptr inbounds %struct.NamespaceNode, %struct.NamespaceNode* %tmp316, i32 0, i32 1
	call void @compile_internal_sym_table(%struct.Path* %v27, %"struct.vector.Vec<%struct.Stmt>"* %tmp326, %struct.SymbolTable* %symbol_table, %struct.string.String* %stdout)
	%tmp327 = load i32, i32* %v0
	%tmp328 = add i32 %tmp327, 1
	store i32 %tmp328, i32* %v0
	br label %loop_body0
; Variable path is out.
else27:
	%tmp329 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp330 = load i8, i8* %tmp329
	%tmp331 = icmp eq i8 %tmp330, 1
	br i1 %tmp331, label %then29, label %endif29
then29:
	%tmp332 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp333 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp332, i32 0, i32 1
	%tmp334 = load i8*, i8** %tmp333
	%tmp335 = load i16, i16* %tmp334
	%tmp336 = call %struct.PathEx @path_to_path_ex_name(%struct.Path* %path, i16 %tmp335)
	store %struct.PathEx %tmp336, %struct.PathEx* %v28
	%tmp337 = load %struct.PathEx, %struct.PathEx* %v28
	%tmp338 = call %struct.SymbolTableEntry* @get_symbol_from_table(%struct.SymbolTable* %symbol_table, %struct.PathEx %tmp337)
	%tmp339 = icmp eq %struct.SymbolTableEntry* %tmp338, null
	br i1 %tmp339, label %then30, label %endif30
then30:
	call void @process.throw(i8* @.str.328)
	br label %endif30
endif30:
	%tmp340 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp334, i32 0, i32 4
	%tmp341 = load i8, i8* %tmp340
	%tmp342 = icmp eq i8 %tmp341, 2
	br i1 %tmp342, label %then31, label %else31
then31:
	%tmp343 = call i8* @mem.malloc(i64 32)
	%tmp344 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp334, i32 0, i32 3
	%tmp345 = call %struct.CompilerType @get_compiler_type(%struct.Type* %tmp344, %struct.Path* %path, %struct.SymbolTable* %symbol_table)
	store %struct.CompilerType %tmp345, %struct.CompilerType* %tmp343
	%tmp346 = getelementptr inbounds %struct.ConstantSymbolTableEntry, %struct.ConstantSymbolTableEntry* %tmp343, i32 0, i32 1
	%tmp347 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp334, i32 0, i32 2
	%tmp348 = call %struct.Rvalue @constant_evaluate_expression(%struct.Expression* %tmp347, %struct.SymbolTable* %symbol_table)
	store %struct.Rvalue %tmp348, %struct.Rvalue* %tmp346
	%tmp349 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp338, i32 0, i32 2
	store i8* %tmp343, i8** %tmp349
	%tmp350 = load i32, i32* %tmp338
	%tmp351 = or i32 %tmp350, 8
	store i32 %tmp351, i32* %tmp338
	br label %endif31
else31:
	%tmp352 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp334, i32 0, i32 4
	%tmp353 = load i8, i8* %tmp352
	%tmp354 = icmp eq i8 %tmp353, 1
	br i1 %tmp354, label %then32, label %endif32
then32:
	%tmp355 = call i8* @mem.malloc(i64 40)
	%tmp356 = getelementptr inbounds %struct.StaticSymbolTableEntry, %struct.StaticSymbolTableEntry* %tmp355, i32 0, i32 1
	store i1 false, i1* %tmp356
	%tmp357 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp334, i32 0, i32 1
	%tmp358 = load i1, i1* %tmp357
	br i1 %tmp358, label %then33, label %endif33
then33:
	%tmp359 = getelementptr inbounds %struct.StaticSymbolTableEntry, %struct.StaticSymbolTableEntry* %tmp355, i32 0, i32 1
	store i1 true, i1* %tmp359
	%tmp360 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp334, i32 0, i32 2
	%tmp361 = call %struct.Rvalue @constant_evaluate_expression(%struct.Expression* %tmp360, %struct.SymbolTable* %symbol_table)
	store %struct.Rvalue %tmp361, %struct.Rvalue* %v29
	br label %endif33
endif33:
	%tmp362 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp334, i32 0, i32 3
	%tmp363 = call %struct.CompilerType @get_compiler_type(%struct.Type* %tmp362, %struct.Path* %path, %struct.SymbolTable* %symbol_table)
	store %struct.CompilerType %tmp363, %struct.CompilerType* %tmp355
	%tmp364 = getelementptr inbounds %struct.StaticSymbolTableEntry, %struct.StaticSymbolTableEntry* %tmp355, i32 0, i32 2
	%tmp365 = load %struct.Rvalue, %struct.Rvalue* %v29
	store %struct.Rvalue %tmp365, %struct.Rvalue* %tmp364
	%tmp366 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp338, i32 0, i32 2
	store i8* %tmp355, i8** %tmp366
	%tmp367 = load i32, i32* %tmp338
	%tmp368 = or i32 %tmp367, 8
	store i32 %tmp368, i32* %tmp338
; Variable expr is out.
	br label %endif32
endif32:
	br label %endif31
endif31:
	%tmp369 = load i32, i32* %v0
	%tmp370 = add i32 %tmp369, 1
	store i32 %tmp370, i32* %v0
	br label %loop_body0
; Variable dec_path is out.
endif29:
	store i32 0, i32* %v30
	br label %loop_cond34
loop_cond34:
	%tmp371 = load i32, i32* %v30
	%tmp372 = icmp uge i32 %tmp371, 3
	br i1 %tmp372, label %then35, label %endif35
then35:
	br label %loop_body34_exit
endif35:
	%tmp373 = load i32, i32* %v0
	%tmp374 = load i32, i32* %v30
	%tmp375 = add i32 %tmp373, %tmp374
	%tmp376 = load %struct.Stmt*, %struct.Stmt** %statement_vector
	%tmp377 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp376, i32 %tmp375
	%tmp378 = load i8, i8* %tmp377
	%tmp379 = zext i8 %tmp378 to i64
	call void @console.println_i64(i64 %tmp379)
	call void @console.write(i8* @.str.324, i32 6)
	%tmp380 = load i32, i32* %v30
	%tmp381 = add i32 %tmp380, 1
	store i32 %tmp381, i32* %v30
	br label %loop_cond34
loop_body34_exit:
	call void @process.throw(i8* @.str.325)
	br label %loop_body0
loop_body0:
	br label %loop_start0
loop_body0_exit:
	ret void
}
define void @compile_body(%"struct.vector.Vec<%struct.Stmt>"* %statement_vector, %struct.Path* %body_path, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout){
	%v0 = alloca i32
	%v1 = alloca i32
	%v2 = alloca %struct.Stmt*
	%v3 = alloca i32
	store i32 0, i32* %v0
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %statement_vector, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	store i32 %tmp1, i32* %v1
	%tmp2 = load %struct.string.String*, %struct.string.String** %symbol_vector
	br label %loop_start0
loop_start0:
	%tmp3 = load i32, i32* %v0
	%tmp4 = load i32, i32* %v1
	%tmp5 = icmp ult i32 %tmp3, %tmp4
	br i1 %tmp5, label %endif1, label %else1
else1:
	br label %loop_body0_exit
endif1:
	%tmp6 = load i32, i32* %v0
	%tmp7 = load %struct.Stmt*, %struct.Stmt** %statement_vector
	%tmp8 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp7, i32 %tmp6
	store %struct.Stmt* %tmp8, %struct.Stmt** %v2
	%tmp9 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp10 = load i8, i8* %tmp9
	%tmp11 = icmp eq i8 %tmp10, 1
	br i1 %tmp11, label %then2, label %else2
then2:
	%tmp12 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp13 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp12, i32 0, i32 1
	%tmp14 = load i8*, i8** %tmp13
	%tmp15 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp14, i32 0, i32 4
	%tmp16 = load i8, i8* %tmp15
	%tmp17 = icmp eq i8 %tmp16, 2
	br i1 %tmp17, label %then3, label %else3
then3:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.329, i32 7)
	br label %endif3
else3:
	%tmp18 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp14, i32 0, i32 4
	%tmp19 = load i8, i8* %tmp18
	%tmp20 = icmp eq i8 %tmp19, 1
	br i1 %tmp20, label %then4, label %else4
then4:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.330, i32 8)
	br label %endif4
else4:
	%tmp21 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp14, i32 0, i32 4
	%tmp22 = load i8, i8* %tmp21
	%tmp23 = icmp eq i8 %tmp22, 0
	br i1 %tmp23, label %then5, label %endif5
then5:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.331, i32 5)
	br label %endif5
endif5:
	br label %endif4
endif4:
	br label %endif3
endif3:
	%tmp24 = load i16, i16* %tmp14
	%tmp25 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp2, i16 %tmp24
	%tmp26 = load i8*, i8** %tmp25
	%tmp27 = load i16, i16* %tmp14
	%tmp28 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp2, i16 %tmp27
	%tmp29 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp28, i32 0, i32 1
	%tmp30 = load i32, i32* %tmp29
	call void @string.append_str(%struct.string.String* %stdout, i8* %tmp26, i32 %tmp30)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.332, i32 3)
	%tmp31 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp14, i32 0, i32 3
	call void @debug_dump_type(%struct.Type* %tmp31, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	%tmp32 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp14, i32 0, i32 1
	%tmp33 = load i1, i1* %tmp32
	br i1 %tmp33, label %then6, label %endif6
then6:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.313, i32 3)
	%tmp34 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp14, i32 0, i32 2
	call void @debug_dump_expression(%struct.Expression* %tmp34, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	br label %endif6
endif6:
	call void @string.append(%struct.string.String* %stdout, i8 10)
	%tmp35 = load i32, i32* %v0
	%tmp36 = add i32 %tmp35, 1
	store i32 %tmp36, i32* %v0
	br label %loop_body0
else2:
	%tmp37 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp38 = load i8, i8* %tmp37
	%tmp39 = icmp eq i8 %tmp38, 2
	br i1 %tmp39, label %then7, label %else7
then7:
	%tmp40 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp41 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp40, i32 0, i32 1
	%tmp42 = load i8*, i8** %tmp41
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.172, i32 1)
	call void @debug_dump_expression(%struct.Expression* %tmp42, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	call void @string.append(%struct.string.String* %stdout, i8 10)
	%tmp43 = load i32, i32* %v0
	%tmp44 = add i32 %tmp43, 1
	store i32 %tmp44, i32* %v0
	br label %loop_body0
else7:
	%tmp45 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp46 = load i8, i8* %tmp45
	%tmp47 = icmp eq i8 %tmp46, 10
	br i1 %tmp47, label %then8, label %else8
then8:
	%tmp48 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp49 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp48, i32 0, i32 1
	%tmp50 = load i8*, i8** %tmp49
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.333, i32 7)
	%tmp51 = load i1, i1* %tmp50
	br i1 %tmp51, label %then9, label %endif9
then9:
	call void @string.append(%struct.string.String* %stdout, i8 32)
	%tmp52 = getelementptr inbounds %struct.ReturnNode, %struct.ReturnNode* %tmp50, i32 0, i32 1
	call void @debug_dump_expression(%struct.Expression* %tmp52, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	br label %endif9
endif9:
	call void @string.append(%struct.string.String* %stdout, i8 10)
	%tmp53 = load i32, i32* %v0
	%tmp54 = add i32 %tmp53, 1
	store i32 %tmp54, i32* %v0
	br label %loop_body0
else8:
	%tmp55 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp56 = load i8, i8* %tmp55
	%tmp57 = icmp eq i8 %tmp56, 3
	br i1 %tmp57, label %then10, label %else10
then10:
	%tmp58 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp59 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp58, i32 0, i32 1
	%tmp60 = load i8*, i8** %tmp59
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.334, i32 4)
	call void @debug_dump_expression(%struct.Expression* %tmp60, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.335, i32 3)
	%tmp61 = getelementptr inbounds %struct.IfStmt, %struct.IfStmt* %tmp60, i32 0, i32 1
	call void @compile_body(%"struct.vector.Vec<%struct.Stmt>"* %tmp61, %struct.Path* %body_path, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	%tmp62 = getelementptr inbounds %struct.IfStmt, %struct.IfStmt* %tmp60, i32 0, i32 2
	%tmp63 = getelementptr inbounds %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %tmp62, i32 0, i32 1
	%tmp64 = load i32, i32* %tmp63
	%tmp65 = icmp ne i32 %tmp64, 0
	br i1 %tmp65, label %then11, label %else11
then11:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.336, i32 10)
	%tmp66 = getelementptr inbounds %struct.IfStmt, %struct.IfStmt* %tmp60, i32 0, i32 2
	call void @compile_body(%"struct.vector.Vec<%struct.Stmt>"* %tmp66, %struct.Path* %body_path, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.337, i32 3)
	br label %endif11
else11:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.337, i32 3)
	br label %endif11
endif11:
	%tmp67 = load i32, i32* %v0
	%tmp68 = add i32 %tmp67, 1
	store i32 %tmp68, i32* %v0
	br label %loop_body0
else10:
	%tmp69 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp70 = load i8, i8* %tmp69
	%tmp71 = icmp eq i8 %tmp70, 4
	br i1 %tmp71, label %then12, label %else12
then12:
	%tmp72 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp73 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp72, i32 0, i32 1
	%tmp74 = load i8*, i8** %tmp73
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.338, i32 7)
	call void @compile_body(%"struct.vector.Vec<%struct.Stmt>"* %tmp74, %struct.Path* %body_path, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.337, i32 3)
	%tmp75 = load i32, i32* %v0
	%tmp76 = add i32 %tmp75, 1
	store i32 %tmp76, i32* %v0
	br label %loop_body0
else12:
	%tmp77 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp78 = load i8, i8* %tmp77
	%tmp79 = icmp eq i8 %tmp78, 5
	br i1 %tmp79, label %then13, label %else13
then13:
	%tmp80 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp81 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp80, i32 0, i32 1
	%tmp82 = load i8*, i8** %tmp81
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.339, i32 7)
	call void @debug_dump_expression(%struct.Expression* %tmp82, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.340, i32 2)
	%tmp83 = getelementptr inbounds %struct.WhileStmt, %struct.WhileStmt* %tmp82, i32 0, i32 1
	call void @compile_body(%"struct.vector.Vec<%struct.Stmt>"* %tmp83, %struct.Path* %body_path, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.337, i32 3)
	%tmp84 = load i32, i32* %v0
	%tmp85 = add i32 %tmp84, 1
	store i32 %tmp85, i32* %v0
	br label %loop_body0
else13:
	%tmp86 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp87 = load i8, i8* %tmp86
	%tmp88 = icmp eq i8 %tmp87, 7
	br i1 %tmp88, label %then14, label %else14
then14:
	%tmp89 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp90 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp89, i32 0, i32 1
	%tmp91 = load i8*, i8** %tmp90
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.341, i32 5)
	call void @debug_dump_expression(%struct.Expression* %tmp91, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.342, i32 4)
	%tmp92 = getelementptr inbounds %struct.ForStmt, %struct.ForStmt* %tmp91, i32 0, i32 1
	call void @debug_dump_expression(%struct.Expression* %tmp92, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.340, i32 2)
	%tmp93 = getelementptr inbounds %struct.ForStmt, %struct.ForStmt* %tmp91, i32 0, i32 2
	call void @compile_body(%"struct.vector.Vec<%struct.Stmt>"* %tmp93, %struct.Path* %body_path, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.337, i32 3)
	%tmp94 = load i32, i32* %v0
	%tmp95 = add i32 %tmp94, 1
	store i32 %tmp95, i32* %v0
	br label %loop_body0
else14:
	%tmp96 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp97 = load i8, i8* %tmp96
	%tmp98 = icmp eq i8 %tmp97, 6
	br i1 %tmp98, label %then15, label %else15
then15:
	%tmp99 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp100 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp99, i32 0, i32 1
	%tmp101 = load i8*, i8** %tmp100
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.343, i32 5)
	%tmp102 = getelementptr inbounds %struct.DoWhileStmt, %struct.DoWhileStmt* %tmp101, i32 0, i32 1
	call void @compile_body(%"struct.vector.Vec<%struct.Stmt>"* %tmp102, %struct.Path* %body_path, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.344, i32 8)
	call void @debug_dump_expression(%struct.Expression* %tmp101, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.345, i32 2)
	%tmp103 = load i32, i32* %v0
	%tmp104 = add i32 %tmp103, 1
	store i32 %tmp104, i32* %v0
	br label %loop_body0
else15:
	%tmp105 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp106 = load i8, i8* %tmp105
	%tmp107 = icmp eq i8 %tmp106, 9
	br i1 %tmp107, label %then16, label %else16
then16:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.346, i32 11)
	%tmp108 = load i32, i32* %v0
	%tmp109 = add i32 %tmp108, 1
	store i32 %tmp109, i32* %v0
	br label %loop_body0
else16:
	%tmp110 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp111 = load i8, i8* %tmp110
	%tmp112 = icmp eq i8 %tmp111, 8
	br i1 %tmp112, label %then17, label %endif17
then17:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.347, i32 8)
	%tmp113 = load i32, i32* %v0
	%tmp114 = add i32 %tmp113, 1
	store i32 %tmp114, i32* %v0
	br label %loop_body0
endif17:
	store i32 0, i32* %v3
	br label %loop_cond18
loop_cond18:
	%tmp115 = load i32, i32* %v3
	%tmp116 = icmp uge i32 %tmp115, 3
	br i1 %tmp116, label %then19, label %endif19
then19:
	br label %loop_body18_exit
endif19:
	%tmp117 = load i32, i32* %v0
	%tmp118 = load i32, i32* %v3
	%tmp119 = add i32 %tmp117, %tmp118
	%tmp120 = load %struct.Stmt*, %struct.Stmt** %statement_vector
	%tmp121 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp120, i32 %tmp119
	%tmp122 = load i8, i8* %tmp121
	%tmp123 = zext i8 %tmp122 to i64
	call void @console.println_i64(i64 %tmp123)
	call void @console.write(i8* @.str.324, i32 6)
	%tmp124 = load i32, i32* %v3
	%tmp125 = add i32 %tmp124, 1
	store i32 %tmp125, i32* %v3
	br label %loop_cond18
loop_body18_exit:
	call void @process.throw(i8* @.str.348)
	br label %loop_body0
loop_body0:
	br label %loop_start0
loop_body0_exit:
	ret void
}
define void @compile(%"struct.vector.Vec<%struct.Stmt>"* %statement_vector, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout){
	%v0 = alloca %struct.SymbolTable
	%v1 = alloca %struct.Path
	call void @STATIC_FILL_PRIMITIVE_TYPES_INFO()
	%tmp0 = call %"struct.vector.Vec<%struct.SymbolTableEntry>" @"vector.new<%struct.SymbolTableEntry>"()
	store %"struct.vector.Vec<%struct.SymbolTableEntry>" %tmp0, %"struct.vector.Vec<%struct.SymbolTableEntry>"* %v0
	%tmp1 = getelementptr inbounds %struct.SymbolTable, %struct.SymbolTable* %v0, i32 0, i32 1
	store %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %"struct.vector.Vec<%struct.string.String>"** %tmp1
	store i8 0, i8* %v1
	call void @compile_internal_sym_table_prefill(%struct.Path* %v1, %"struct.vector.Vec<%struct.Stmt>"* %statement_vector, %struct.SymbolTable* %v0, %struct.string.String* %stdout)
	call void @compile_internal_sym_table(%struct.Path* %v1, %"struct.vector.Vec<%struct.Stmt>"* %statement_vector, %struct.SymbolTable* %v0, %struct.string.String* %stdout)
	call void @compile_internals.sym_table_push_structs(%struct.SymbolTable* %v0, %struct.string.String* %stdout)
	call void @compile_internals.sym_table_push_structs_generic(%struct.SymbolTable* %v0, %struct.string.String* %stdout)
	call void @compile_internals.sym_table_push_external(%struct.SymbolTable* %v0, %struct.string.String* %stdout)
	call void @compile_internals.sym_table_push_static(%struct.SymbolTable* %v0, %struct.string.String* %stdout)
; Variable path is out.
; Variable sym_table is out.
	ret void
}
define void @append_path_ex(%struct.PathEx* %path, %struct.string.String* %sym_array, %struct.string.String* %stdout){
	%v0 = alloca i8
	%tmp0 = load i8, i8* %path
	store i8 0, i8* %v0
	br label %loop_cond0
loop_cond0:
	%tmp1 = load i8, i8* %v0
	%tmp2 = load i8, i8* %path
	%tmp3 = icmp uge i8 %tmp1, %tmp2
	br i1 %tmp3, label %then1, label %endif1
then1:
	br label %loop_body0_exit
endif1:
	%tmp4 = getelementptr inbounds %struct.PathEx, %struct.PathEx* %path, i32 0, i32 1
	%tmp5 = load i8, i8* %v0
	%tmp6 = getelementptr inbounds [12 x i16], [12 x i16]* %tmp4, i32 0, i8 %tmp5
	%tmp7 = load i16, i16* %tmp6
	%tmp8 = getelementptr inbounds %struct.string.String, %struct.string.String* %sym_array, i16 %tmp7
	%tmp9 = load i8*, i8** %tmp8
	%tmp10 = getelementptr inbounds %struct.PathEx, %struct.PathEx* %path, i32 0, i32 1
	%tmp11 = load i8, i8* %v0
	%tmp12 = getelementptr inbounds [12 x i16], [12 x i16]* %tmp10, i32 0, i8 %tmp11
	%tmp13 = load i16, i16* %tmp12
	%tmp14 = getelementptr inbounds %struct.string.String, %struct.string.String* %sym_array, i16 %tmp13
	%tmp15 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp14, i32 0, i32 1
	%tmp16 = load i32, i32* %tmp15
	call void @string.append_str(%struct.string.String* %stdout, i8* %tmp9, i32 %tmp16)
	%tmp17 = load i8, i8* %v0
	%tmp18 = load i8, i8* %path
	%tmp19 = sub i8 %tmp18, 1
	%tmp20 = icmp ne i8 %tmp17, %tmp19
	br i1 %tmp20, label %then2, label %endif2
then2:
	call void @string.append(%struct.string.String* %stdout, i8 46)
	br label %endif2
endif2:
	%tmp21 = load i8, i8* %v0
	%tmp22 = add i8 %tmp21, 1
	store i8 %tmp22, i8* %v0
	br label %loop_cond0
loop_body0_exit:
	ret void
}
define void @append_path(%struct.PathEx* %path, %struct.string.String* %sym_array, %struct.string.String* %stdout){
	%v0 = alloca i8
	%tmp0 = load i8, i8* %path
	store i8 0, i8* %v0
	br label %loop_cond0
loop_cond0:
	%tmp1 = load i8, i8* %v0
	%tmp2 = load i8, i8* %path
	%tmp3 = icmp uge i8 %tmp1, %tmp2
	br i1 %tmp3, label %then1, label %endif1
then1:
	br label %loop_body0_exit
endif1:
	%tmp4 = getelementptr inbounds %struct.PathEx, %struct.PathEx* %path, i32 0, i32 1
	%tmp5 = load i8, i8* %v0
	%tmp6 = getelementptr inbounds [12 x i16], [12 x i16]* %tmp4, i32 0, i8 %tmp5
	%tmp7 = load i16, i16* %tmp6
	%tmp8 = getelementptr inbounds %struct.string.String, %struct.string.String* %sym_array, i16 %tmp7
	%tmp9 = load i8*, i8** %tmp8
	%tmp10 = getelementptr inbounds %struct.PathEx, %struct.PathEx* %path, i32 0, i32 1
	%tmp11 = load i8, i8* %v0
	%tmp12 = getelementptr inbounds [12 x i16], [12 x i16]* %tmp10, i32 0, i8 %tmp11
	%tmp13 = load i16, i16* %tmp12
	%tmp14 = getelementptr inbounds %struct.string.String, %struct.string.String* %sym_array, i16 %tmp13
	%tmp15 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp14, i32 0, i32 1
	%tmp16 = load i32, i32* %tmp15
	call void @string.append_str(%struct.string.String* %stdout, i8* %tmp9, i32 %tmp16)
	%tmp17 = load i8, i8* %v0
	%tmp18 = load i8, i8* %path
	%tmp19 = sub i8 %tmp18, 1
	%tmp20 = icmp ne i8 %tmp17, %tmp19
	br i1 %tmp20, label %then2, label %endif2
then2:
	call void @string.append(%struct.string.String* %stdout, i8 46)
	br label %endif2
endif2:
	%tmp21 = load i8, i8* %v0
	%tmp22 = add i8 %tmp21, 1
	store i8 %tmp22, i8* %v0
	br label %loop_cond0
loop_body0_exit:
	ret void
}
define void @add_to_scope(%struct.Variable %val, %struct.Scope* %scope){
	call void @"vector.push<%struct.Variable>"(%"struct.vector.Vec<%struct.Variable>"* %scope, %struct.Variable %val)
; Variable val is out.
	ret void
}
define i32 @_fltused(){
	ret i32 0
}
define void @__chkstk(){
	ret void
}
define void @STATIC_FILL_PRIMITIVE_TYPES_INFO(){
	%v0 = alloca %struct.Layout
	%v1 = alloca %struct.PrimitiveTypeInfo
	%v2 = alloca %struct.Layout
	%v3 = alloca %struct.PrimitiveTypeInfo
	%v4 = alloca %struct.Layout
	%v5 = alloca %struct.PrimitiveTypeInfo
	%v6 = alloca %struct.Layout
	%v7 = alloca %struct.PrimitiveTypeInfo
	%v8 = alloca %struct.Layout
	%v9 = alloca %struct.PrimitiveTypeInfo
	%v10 = alloca %struct.Layout
	%v11 = alloca %struct.PrimitiveTypeInfo
	%v12 = alloca %struct.Layout
	%v13 = alloca %struct.PrimitiveTypeInfo
	%v14 = alloca %struct.Layout
	%v15 = alloca %struct.PrimitiveTypeInfo
	%v16 = alloca %struct.Layout
	%v17 = alloca %struct.PrimitiveTypeInfo
	%v18 = alloca %struct.Layout
	%v19 = alloca %struct.PrimitiveTypeInfo
	%v20 = alloca %struct.Layout
	%v21 = alloca %struct.PrimitiveTypeInfo
	%v22 = alloca %struct.Layout
	%v23 = alloca %struct.PrimitiveTypeInfo
	%v24 = alloca %struct.Layout
	%v25 = alloca %struct.PrimitiveTypeInfo
	%v26 = alloca %struct.Layout
	%v27 = alloca %struct.PrimitiveTypeInfo
	%v28 = alloca %struct.Layout
	%v29 = alloca %struct.PrimitiveTypeInfo
	%v30 = alloca %struct.Layout
	store i16 8, i16* %v0
	%tmp0 = getelementptr inbounds %struct.Layout, %struct.Layout* %v0, i32 0, i32 1
	store i16 8, i16* %tmp0
	%tmp1 = load %struct.Layout, %struct.Layout* %v0
	store %struct.Layout %tmp1, %struct.Layout* @POINTER_LAYOUT
	store i16 0, i16* %v2
	%tmp2 = getelementptr inbounds %struct.Layout, %struct.Layout* %v2, i32 0, i32 1
	store i16 1, i16* %tmp2
	%tmp3 = load %struct.Layout, %struct.Layout* %v2
	store i8* @.str.300, i8** %v1
	%tmp4 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v1, i32 0, i32 1
	store i8* @.str.300, i8** %tmp4
	%tmp5 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v1, i32 0, i32 2
	store %struct.Layout %tmp3, %struct.Layout* %tmp5
	%tmp6 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v1, i32 0, i32 3
	store i32 0, i32* %tmp6
	%tmp7 = load %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v1
	store %struct.PrimitiveTypeInfo %tmp7, %struct.PrimitiveTypeInfo* @PRIMITIVE_TYPES_INFO
	store i16 1, i16* %v4
	%tmp8 = getelementptr inbounds %struct.Layout, %struct.Layout* %v4, i32 0, i32 1
	store i16 1, i16* %tmp8
	%tmp9 = load %struct.Layout, %struct.Layout* %v4
; Variable x is out.
	store i8* @.str.301, i8** %v3
	%tmp10 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v3, i32 0, i32 1
	store i8* @.str.349, i8** %tmp10
	%tmp11 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v3, i32 0, i32 2
	store %struct.Layout %tmp9, %struct.Layout* %tmp11
	%tmp12 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v3, i32 0, i32 3
	store i32 1, i32* %tmp12
	%tmp13 = getelementptr inbounds [15 x %struct.PrimitiveTypeInfo], [15 x %struct.PrimitiveTypeInfo]* @PRIMITIVE_TYPES_INFO, i32 0, i64 1
	%tmp14 = load %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v3
	store %struct.PrimitiveTypeInfo %tmp14, %struct.PrimitiveTypeInfo* %tmp13
	store i16 1, i16* %v6
	%tmp15 = getelementptr inbounds %struct.Layout, %struct.Layout* %v6, i32 0, i32 1
	store i16 1, i16* %tmp15
	%tmp16 = load %struct.Layout, %struct.Layout* %v6
; Variable x is out.
	store i8* @.str.290, i8** %v5
	%tmp17 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v5, i32 0, i32 1
	store i8* @.str.290, i8** %tmp17
	%tmp18 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v5, i32 0, i32 2
	store %struct.Layout %tmp16, %struct.Layout* %tmp18
	%tmp19 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v5, i32 0, i32 3
	store i32 2, i32* %tmp19
	%tmp20 = getelementptr inbounds [15 x %struct.PrimitiveTypeInfo], [15 x %struct.PrimitiveTypeInfo]* @PRIMITIVE_TYPES_INFO, i32 0, i64 2
	%tmp21 = load %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v5
	store %struct.PrimitiveTypeInfo %tmp21, %struct.PrimitiveTypeInfo* %tmp20
	store i16 2, i16* %v8
	%tmp22 = getelementptr inbounds %struct.Layout, %struct.Layout* %v8, i32 0, i32 1
	store i16 2, i16* %tmp22
	%tmp23 = load %struct.Layout, %struct.Layout* %v8
; Variable x is out.
	store i8* @.str.292, i8** %v7
	%tmp24 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v7, i32 0, i32 1
	store i8* @.str.292, i8** %tmp24
	%tmp25 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v7, i32 0, i32 2
	store %struct.Layout %tmp23, %struct.Layout* %tmp25
	%tmp26 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v7, i32 0, i32 3
	store i32 2, i32* %tmp26
	%tmp27 = getelementptr inbounds [15 x %struct.PrimitiveTypeInfo], [15 x %struct.PrimitiveTypeInfo]* @PRIMITIVE_TYPES_INFO, i32 0, i64 3
	%tmp28 = load %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v7
	store %struct.PrimitiveTypeInfo %tmp28, %struct.PrimitiveTypeInfo* %tmp27
	store i16 4, i16* %v10
	%tmp29 = getelementptr inbounds %struct.Layout, %struct.Layout* %v10, i32 0, i32 1
	store i16 4, i16* %tmp29
	%tmp30 = load %struct.Layout, %struct.Layout* %v10
; Variable x is out.
	store i8* @.str.293, i8** %v9
	%tmp31 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v9, i32 0, i32 1
	store i8* @.str.293, i8** %tmp31
	%tmp32 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v9, i32 0, i32 2
	store %struct.Layout %tmp30, %struct.Layout* %tmp32
	%tmp33 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v9, i32 0, i32 3
	store i32 2, i32* %tmp33
	%tmp34 = getelementptr inbounds [15 x %struct.PrimitiveTypeInfo], [15 x %struct.PrimitiveTypeInfo]* @PRIMITIVE_TYPES_INFO, i32 0, i64 4
	%tmp35 = load %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v9
	store %struct.PrimitiveTypeInfo %tmp35, %struct.PrimitiveTypeInfo* %tmp34
	store i16 8, i16* %v12
	%tmp36 = getelementptr inbounds %struct.Layout, %struct.Layout* %v12, i32 0, i32 1
	store i16 8, i16* %tmp36
	%tmp37 = load %struct.Layout, %struct.Layout* %v12
; Variable x is out.
	store i8* @.str.294, i8** %v11
	%tmp38 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v11, i32 0, i32 1
	store i8* @.str.294, i8** %tmp38
	%tmp39 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v11, i32 0, i32 2
	store %struct.Layout %tmp37, %struct.Layout* %tmp39
	%tmp40 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v11, i32 0, i32 3
	store i32 2, i32* %tmp40
	%tmp41 = getelementptr inbounds [15 x %struct.PrimitiveTypeInfo], [15 x %struct.PrimitiveTypeInfo]* @PRIMITIVE_TYPES_INFO, i32 0, i64 5
	%tmp42 = load %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v11
	store %struct.PrimitiveTypeInfo %tmp42, %struct.PrimitiveTypeInfo* %tmp41
	store i16 8, i16* %v14
	%tmp43 = getelementptr inbounds %struct.Layout, %struct.Layout* %v14, i32 0, i32 1
	store i16 8, i16* %tmp43
	%tmp44 = load %struct.Layout, %struct.Layout* %v14
; Variable x is out.
	store i8* @.str.303, i8** %v13
	%tmp45 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v13, i32 0, i32 1
	store i8* @.str.294, i8** %tmp45
	%tmp46 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v13, i32 0, i32 2
	store %struct.Layout %tmp44, %struct.Layout* %tmp46
	%tmp47 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v13, i32 0, i32 3
	store i32 2, i32* %tmp47
	%tmp48 = getelementptr inbounds [15 x %struct.PrimitiveTypeInfo], [15 x %struct.PrimitiveTypeInfo]* @PRIMITIVE_TYPES_INFO, i32 0, i64 6
	%tmp49 = load %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v13
	store %struct.PrimitiveTypeInfo %tmp49, %struct.PrimitiveTypeInfo* %tmp48
	store i16 1, i16* %v16
	%tmp50 = getelementptr inbounds %struct.Layout, %struct.Layout* %v16, i32 0, i32 1
	store i16 1, i16* %tmp50
	%tmp51 = load %struct.Layout, %struct.Layout* %v16
; Variable x is out.
	store i8* @.str.291, i8** %v15
	%tmp52 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v15, i32 0, i32 1
	store i8* @.str.290, i8** %tmp52
	%tmp53 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v15, i32 0, i32 2
	store %struct.Layout %tmp51, %struct.Layout* %tmp53
	%tmp54 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v15, i32 0, i32 3
	store i32 3, i32* %tmp54
	%tmp55 = getelementptr inbounds [15 x %struct.PrimitiveTypeInfo], [15 x %struct.PrimitiveTypeInfo]* @PRIMITIVE_TYPES_INFO, i32 0, i64 7
	%tmp56 = load %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v15
	store %struct.PrimitiveTypeInfo %tmp56, %struct.PrimitiveTypeInfo* %tmp55
	store i16 2, i16* %v18
	%tmp57 = getelementptr inbounds %struct.Layout, %struct.Layout* %v18, i32 0, i32 1
	store i16 2, i16* %tmp57
	%tmp58 = load %struct.Layout, %struct.Layout* %v18
; Variable x is out.
	store i8* @.str.350, i8** %v17
	%tmp59 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v17, i32 0, i32 1
	store i8* @.str.292, i8** %tmp59
	%tmp60 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v17, i32 0, i32 2
	store %struct.Layout %tmp58, %struct.Layout* %tmp60
	%tmp61 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v17, i32 0, i32 3
	store i32 3, i32* %tmp61
	%tmp62 = getelementptr inbounds [15 x %struct.PrimitiveTypeInfo], [15 x %struct.PrimitiveTypeInfo]* @PRIMITIVE_TYPES_INFO, i32 0, i64 8
	%tmp63 = load %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v17
	store %struct.PrimitiveTypeInfo %tmp63, %struct.PrimitiveTypeInfo* %tmp62
	store i16 4, i16* %v20
	%tmp64 = getelementptr inbounds %struct.Layout, %struct.Layout* %v20, i32 0, i32 1
	store i16 4, i16* %tmp64
	%tmp65 = load %struct.Layout, %struct.Layout* %v20
; Variable x is out.
	store i8* @.str.295, i8** %v19
	%tmp66 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v19, i32 0, i32 1
	store i8* @.str.293, i8** %tmp66
	%tmp67 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v19, i32 0, i32 2
	store %struct.Layout %tmp65, %struct.Layout* %tmp67
	%tmp68 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v19, i32 0, i32 3
	store i32 3, i32* %tmp68
	%tmp69 = getelementptr inbounds [15 x %struct.PrimitiveTypeInfo], [15 x %struct.PrimitiveTypeInfo]* @PRIMITIVE_TYPES_INFO, i32 0, i64 9
	%tmp70 = load %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v19
	store %struct.PrimitiveTypeInfo %tmp70, %struct.PrimitiveTypeInfo* %tmp69
	store i16 8, i16* %v22
	%tmp71 = getelementptr inbounds %struct.Layout, %struct.Layout* %v22, i32 0, i32 1
	store i16 8, i16* %tmp71
	%tmp72 = load %struct.Layout, %struct.Layout* %v22
; Variable x is out.
	store i8* @.str.296, i8** %v21
	%tmp73 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v21, i32 0, i32 1
	store i8* @.str.294, i8** %tmp73
	%tmp74 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v21, i32 0, i32 2
	store %struct.Layout %tmp72, %struct.Layout* %tmp74
	%tmp75 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v21, i32 0, i32 3
	store i32 3, i32* %tmp75
	%tmp76 = getelementptr inbounds [15 x %struct.PrimitiveTypeInfo], [15 x %struct.PrimitiveTypeInfo]* @PRIMITIVE_TYPES_INFO, i32 0, i64 10
	%tmp77 = load %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v21
	store %struct.PrimitiveTypeInfo %tmp77, %struct.PrimitiveTypeInfo* %tmp76
	store i16 8, i16* %v24
	%tmp78 = getelementptr inbounds %struct.Layout, %struct.Layout* %v24, i32 0, i32 1
	store i16 8, i16* %tmp78
	%tmp79 = load %struct.Layout, %struct.Layout* %v24
; Variable x is out.
	store i8* @.str.302, i8** %v23
	%tmp80 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v23, i32 0, i32 1
	store i8* @.str.294, i8** %tmp80
	%tmp81 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v23, i32 0, i32 2
	store %struct.Layout %tmp79, %struct.Layout* %tmp81
	%tmp82 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v23, i32 0, i32 3
	store i32 3, i32* %tmp82
	%tmp83 = getelementptr inbounds [15 x %struct.PrimitiveTypeInfo], [15 x %struct.PrimitiveTypeInfo]* @PRIMITIVE_TYPES_INFO, i32 0, i64 11
	%tmp84 = load %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v23
	store %struct.PrimitiveTypeInfo %tmp84, %struct.PrimitiveTypeInfo* %tmp83
	store i16 2, i16* %v26
	%tmp85 = getelementptr inbounds %struct.Layout, %struct.Layout* %v26, i32 0, i32 1
	store i16 2, i16* %tmp85
	%tmp86 = load %struct.Layout, %struct.Layout* %v26
; Variable x is out.
	store i8* @.str.297, i8** %v25
	%tmp87 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v25, i32 0, i32 1
	store i8* @.str.351, i8** %tmp87
	%tmp88 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v25, i32 0, i32 2
	store %struct.Layout %tmp86, %struct.Layout* %tmp88
	%tmp89 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v25, i32 0, i32 3
	store i32 4, i32* %tmp89
	%tmp90 = getelementptr inbounds [15 x %struct.PrimitiveTypeInfo], [15 x %struct.PrimitiveTypeInfo]* @PRIMITIVE_TYPES_INFO, i32 0, i64 12
	%tmp91 = load %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v25
	store %struct.PrimitiveTypeInfo %tmp91, %struct.PrimitiveTypeInfo* %tmp90
	store i16 4, i16* %v28
	%tmp92 = getelementptr inbounds %struct.Layout, %struct.Layout* %v28, i32 0, i32 1
	store i16 4, i16* %tmp92
	%tmp93 = load %struct.Layout, %struct.Layout* %v28
; Variable x is out.
	store i8* @.str.298, i8** %v27
	%tmp94 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v27, i32 0, i32 1
	store i8* @.str.352, i8** %tmp94
	%tmp95 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v27, i32 0, i32 2
	store %struct.Layout %tmp93, %struct.Layout* %tmp95
	%tmp96 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v27, i32 0, i32 3
	store i32 4, i32* %tmp96
	%tmp97 = getelementptr inbounds [15 x %struct.PrimitiveTypeInfo], [15 x %struct.PrimitiveTypeInfo]* @PRIMITIVE_TYPES_INFO, i32 0, i64 13
	%tmp98 = load %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v27
	store %struct.PrimitiveTypeInfo %tmp98, %struct.PrimitiveTypeInfo* %tmp97
	store i16 8, i16* %v30
	%tmp99 = getelementptr inbounds %struct.Layout, %struct.Layout* %v30, i32 0, i32 1
	store i16 8, i16* %tmp99
	%tmp100 = load %struct.Layout, %struct.Layout* %v30
; Variable x is out.
	store i8* @.str.299, i8** %v29
	%tmp101 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v29, i32 0, i32 1
	store i8* @.str.353, i8** %tmp101
	%tmp102 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v29, i32 0, i32 2
	store %struct.Layout %tmp100, %struct.Layout* %tmp102
	%tmp103 = getelementptr inbounds %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v29, i32 0, i32 3
	store i32 4, i32* %tmp103
	%tmp104 = getelementptr inbounds [15 x %struct.PrimitiveTypeInfo], [15 x %struct.PrimitiveTypeInfo]* @PRIMITIVE_TYPES_INFO, i32 0, i64 14
	%tmp105 = load %struct.PrimitiveTypeInfo, %struct.PrimitiveTypeInfo* %v29
	store %struct.PrimitiveTypeInfo %tmp105, %struct.PrimitiveTypeInfo* %tmp104
	store %struct.PrimitiveTypeInfo* @PRIMITIVE_TYPES_INFO, %struct.PrimitiveTypeInfo** @VOID_TYPE
	%tmp106 = getelementptr inbounds [15 x %struct.PrimitiveTypeInfo], [15 x %struct.PrimitiveTypeInfo]* @PRIMITIVE_TYPES_INFO, i32 0, i64 9
	store %struct.PrimitiveTypeInfo* %tmp106, %struct.PrimitiveTypeInfo** @DEFAULT_INTEGER_TYPE
; Variable x is out.
	ret void
}
define void @"vector.push_bulk<i8>"(%"struct.vector.Vec<i8>"* %vec, i8* %data, i32 %data_len){
	%v0 = alloca i32
	store i32 0, i32* %v0
	br label %loop_cond0
loop_cond0:
	%tmp0 = load i32, i32* %v0
	%tmp1 = icmp sge i32 %tmp0, %data_len
	br i1 %tmp1, label %then1, label %endif1
then1:
	br label %loop_body0_exit
endif1:
	%tmp2 = load i32, i32* %v0
	%tmp3 = getelementptr inbounds i8, i8* %data, i32 %tmp2
	%tmp4 = load i8, i8* %tmp3
	call void @"vector.push<i8>"(%"struct.vector.Vec<i8>"* %vec, i8 %tmp4)
	%tmp5 = load i32, i32* %v0
	%tmp6 = add i32 %tmp5, 1
	store i32 %tmp6, i32* %v0
	br label %loop_cond0
loop_body0_exit:
	ret void
}
define void @"vector.push<%struct.Variable>"(%"struct.vector.Vec<%struct.Variable>"* %vec, %struct.Variable %data){
	%v0 = alloca i32
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.Variable>", %"struct.vector.Vec<%struct.Variable>"* %vec, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = getelementptr inbounds %"struct.vector.Vec<%struct.Variable>", %"struct.vector.Vec<%struct.Variable>"* %vec, i32 0, i32 2
	%tmp3 = load i32, i32* %tmp2
	%tmp4 = icmp uge i32 %tmp1, %tmp3
	br i1 %tmp4, label %then0, label %endif0
then0:
	store i32 4, i32* %v0
	%tmp5 = getelementptr inbounds %"struct.vector.Vec<%struct.Variable>", %"struct.vector.Vec<%struct.Variable>"* %vec, i32 0, i32 2
	%tmp6 = load i32, i32* %tmp5
	%tmp7 = icmp ne i32 %tmp6, 0
	br i1 %tmp7, label %then1, label %endif1
then1:
	%tmp8 = getelementptr inbounds %"struct.vector.Vec<%struct.Variable>", %"struct.vector.Vec<%struct.Variable>"* %vec, i32 0, i32 2
	%tmp9 = load i32, i32* %tmp8
	%tmp10 = mul i32 %tmp9, 2
	store i32 %tmp10, i32* %v0
	br label %endif1
endif1:
	%tmp11 = load i32, i32* %v0
	%tmp12 = zext i32 %tmp11 to i64
	%tmp13 = mul i64 4, %tmp12
	%tmp14 = load %struct.Variable*, %struct.Variable** %vec
	%tmp15 = call i8* @mem.realloc(i8* %tmp14, i64 %tmp13)
	store %struct.Variable* %tmp15, %struct.Variable** %vec
	%tmp16 = getelementptr inbounds %"struct.vector.Vec<%struct.Variable>", %"struct.vector.Vec<%struct.Variable>"* %vec, i32 0, i32 2
	%tmp17 = load i32, i32* %v0
	store i32 %tmp17, i32* %tmp16
	br label %endif0
endif0:
	%tmp18 = getelementptr inbounds %"struct.vector.Vec<%struct.Variable>", %"struct.vector.Vec<%struct.Variable>"* %vec, i32 0, i32 1
	%tmp19 = load i32, i32* %tmp18
	%tmp20 = load %struct.Variable*, %struct.Variable** %vec
	%tmp21 = getelementptr inbounds %struct.Variable, %struct.Variable* %tmp20, i32 %tmp19
	store %struct.Variable %data, %struct.Variable* %tmp21
	%tmp22 = getelementptr inbounds %"struct.vector.Vec<%struct.Variable>", %"struct.vector.Vec<%struct.Variable>"* %vec, i32 0, i32 1
	%tmp23 = getelementptr inbounds %"struct.vector.Vec<%struct.Variable>", %"struct.vector.Vec<%struct.Variable>"* %vec, i32 0, i32 1
	%tmp24 = load i32, i32* %tmp23
	%tmp25 = add i32 %tmp24, 1
	store i32 %tmp25, i32* %tmp22
; Variable data is out.
	ret void
}
define void @"vector.push<%struct.EnumDefinedField>"(%"struct.vector.Vec<%struct.EnumDefinedField>"* %vec, %struct.EnumDefinedField %data){
	%v0 = alloca i32
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.EnumDefinedField>", %"struct.vector.Vec<%struct.EnumDefinedField>"* %vec, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = getelementptr inbounds %"struct.vector.Vec<%struct.EnumDefinedField>", %"struct.vector.Vec<%struct.EnumDefinedField>"* %vec, i32 0, i32 2
	%tmp3 = load i32, i32* %tmp2
	%tmp4 = icmp uge i32 %tmp1, %tmp3
	br i1 %tmp4, label %then0, label %endif0
then0:
	store i32 4, i32* %v0
	%tmp5 = getelementptr inbounds %"struct.vector.Vec<%struct.EnumDefinedField>", %"struct.vector.Vec<%struct.EnumDefinedField>"* %vec, i32 0, i32 2
	%tmp6 = load i32, i32* %tmp5
	%tmp7 = icmp ne i32 %tmp6, 0
	br i1 %tmp7, label %then1, label %endif1
then1:
	%tmp8 = getelementptr inbounds %"struct.vector.Vec<%struct.EnumDefinedField>", %"struct.vector.Vec<%struct.EnumDefinedField>"* %vec, i32 0, i32 2
	%tmp9 = load i32, i32* %tmp8
	%tmp10 = mul i32 %tmp9, 2
	store i32 %tmp10, i32* %v0
	br label %endif1
endif1:
	%tmp11 = load i32, i32* %v0
	%tmp12 = zext i32 %tmp11 to i64
	%tmp13 = mul i64 16, %tmp12
	%tmp14 = load %struct.EnumDefinedField*, %struct.EnumDefinedField** %vec
	%tmp15 = call i8* @mem.realloc(i8* %tmp14, i64 %tmp13)
	store %struct.EnumDefinedField* %tmp15, %struct.EnumDefinedField** %vec
	%tmp16 = getelementptr inbounds %"struct.vector.Vec<%struct.EnumDefinedField>", %"struct.vector.Vec<%struct.EnumDefinedField>"* %vec, i32 0, i32 2
	%tmp17 = load i32, i32* %v0
	store i32 %tmp17, i32* %tmp16
	br label %endif0
endif0:
	%tmp18 = getelementptr inbounds %"struct.vector.Vec<%struct.EnumDefinedField>", %"struct.vector.Vec<%struct.EnumDefinedField>"* %vec, i32 0, i32 1
	%tmp19 = load i32, i32* %tmp18
	%tmp20 = load %struct.EnumDefinedField*, %struct.EnumDefinedField** %vec
	%tmp21 = getelementptr inbounds %struct.EnumDefinedField, %struct.EnumDefinedField* %tmp20, i32 %tmp19
	store %struct.EnumDefinedField %data, %struct.EnumDefinedField* %tmp21
	%tmp22 = getelementptr inbounds %"struct.vector.Vec<%struct.EnumDefinedField>", %"struct.vector.Vec<%struct.EnumDefinedField>"* %vec, i32 0, i32 1
	%tmp23 = getelementptr inbounds %"struct.vector.Vec<%struct.EnumDefinedField>", %"struct.vector.Vec<%struct.EnumDefinedField>"* %vec, i32 0, i32 1
	%tmp24 = load i32, i32* %tmp23
	%tmp25 = add i32 %tmp24, 1
	store i32 %tmp25, i32* %tmp22
; Variable data is out.
	ret void
}
define void @"vector.push<%struct.StructDefinedField>"(%"struct.vector.Vec<%struct.StructDefinedField>"* %vec, %struct.StructDefinedField %data){
	%v0 = alloca i32
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.StructDefinedField>", %"struct.vector.Vec<%struct.StructDefinedField>"* %vec, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = getelementptr inbounds %"struct.vector.Vec<%struct.StructDefinedField>", %"struct.vector.Vec<%struct.StructDefinedField>"* %vec, i32 0, i32 2
	%tmp3 = load i32, i32* %tmp2
	%tmp4 = icmp uge i32 %tmp1, %tmp3
	br i1 %tmp4, label %then0, label %endif0
then0:
	store i32 4, i32* %v0
	%tmp5 = getelementptr inbounds %"struct.vector.Vec<%struct.StructDefinedField>", %"struct.vector.Vec<%struct.StructDefinedField>"* %vec, i32 0, i32 2
	%tmp6 = load i32, i32* %tmp5
	%tmp7 = icmp ne i32 %tmp6, 0
	br i1 %tmp7, label %then1, label %endif1
then1:
	%tmp8 = getelementptr inbounds %"struct.vector.Vec<%struct.StructDefinedField>", %"struct.vector.Vec<%struct.StructDefinedField>"* %vec, i32 0, i32 2
	%tmp9 = load i32, i32* %tmp8
	%tmp10 = mul i32 %tmp9, 2
	store i32 %tmp10, i32* %v0
	br label %endif1
endif1:
	%tmp11 = load i32, i32* %v0
	%tmp12 = zext i32 %tmp11 to i64
	%tmp13 = mul i64 24, %tmp12
	%tmp14 = load %struct.StructDefinedField*, %struct.StructDefinedField** %vec
	%tmp15 = call i8* @mem.realloc(i8* %tmp14, i64 %tmp13)
	store %struct.StructDefinedField* %tmp15, %struct.StructDefinedField** %vec
	%tmp16 = getelementptr inbounds %"struct.vector.Vec<%struct.StructDefinedField>", %"struct.vector.Vec<%struct.StructDefinedField>"* %vec, i32 0, i32 2
	%tmp17 = load i32, i32* %v0
	store i32 %tmp17, i32* %tmp16
	br label %endif0
endif0:
	%tmp18 = getelementptr inbounds %"struct.vector.Vec<%struct.StructDefinedField>", %"struct.vector.Vec<%struct.StructDefinedField>"* %vec, i32 0, i32 1
	%tmp19 = load i32, i32* %tmp18
	%tmp20 = load %struct.StructDefinedField*, %struct.StructDefinedField** %vec
	%tmp21 = getelementptr inbounds %struct.StructDefinedField, %struct.StructDefinedField* %tmp20, i32 %tmp19
	store %struct.StructDefinedField %data, %struct.StructDefinedField* %tmp21
	%tmp22 = getelementptr inbounds %"struct.vector.Vec<%struct.StructDefinedField>", %"struct.vector.Vec<%struct.StructDefinedField>"* %vec, i32 0, i32 1
	%tmp23 = getelementptr inbounds %"struct.vector.Vec<%struct.StructDefinedField>", %"struct.vector.Vec<%struct.StructDefinedField>"* %vec, i32 0, i32 1
	%tmp24 = load i32, i32* %tmp23
	%tmp25 = add i32 %tmp24, 1
	store i32 %tmp25, i32* %tmp22
; Variable data is out.
	ret void
}
define void @"vector.push<%struct.GenericStructDefinedField>"(%"struct.vector.Vec<%struct.GenericStructDefinedField>"* %vec, %struct.GenericStructDefinedField %data){
	%v0 = alloca i32
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.GenericStructDefinedField>", %"struct.vector.Vec<%struct.GenericStructDefinedField>"* %vec, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = getelementptr inbounds %"struct.vector.Vec<%struct.GenericStructDefinedField>", %"struct.vector.Vec<%struct.GenericStructDefinedField>"* %vec, i32 0, i32 2
	%tmp3 = load i32, i32* %tmp2
	%tmp4 = icmp uge i32 %tmp1, %tmp3
	br i1 %tmp4, label %then0, label %endif0
then0:
	store i32 4, i32* %v0
	%tmp5 = getelementptr inbounds %"struct.vector.Vec<%struct.GenericStructDefinedField>", %"struct.vector.Vec<%struct.GenericStructDefinedField>"* %vec, i32 0, i32 2
	%tmp6 = load i32, i32* %tmp5
	%tmp7 = icmp ne i32 %tmp6, 0
	br i1 %tmp7, label %then1, label %endif1
then1:
	%tmp8 = getelementptr inbounds %"struct.vector.Vec<%struct.GenericStructDefinedField>", %"struct.vector.Vec<%struct.GenericStructDefinedField>"* %vec, i32 0, i32 2
	%tmp9 = load i32, i32* %tmp8
	%tmp10 = mul i32 %tmp9, 2
	store i32 %tmp10, i32* %v0
	br label %endif1
endif1:
	%tmp11 = load i32, i32* %v0
	%tmp12 = zext i32 %tmp11 to i64
	%tmp13 = mul i64 32, %tmp12
	%tmp14 = load %struct.GenericStructDefinedField*, %struct.GenericStructDefinedField** %vec
	%tmp15 = call i8* @mem.realloc(i8* %tmp14, i64 %tmp13)
	store %struct.GenericStructDefinedField* %tmp15, %struct.GenericStructDefinedField** %vec
	%tmp16 = getelementptr inbounds %"struct.vector.Vec<%struct.GenericStructDefinedField>", %"struct.vector.Vec<%struct.GenericStructDefinedField>"* %vec, i32 0, i32 2
	%tmp17 = load i32, i32* %v0
	store i32 %tmp17, i32* %tmp16
	br label %endif0
endif0:
	%tmp18 = getelementptr inbounds %"struct.vector.Vec<%struct.GenericStructDefinedField>", %"struct.vector.Vec<%struct.GenericStructDefinedField>"* %vec, i32 0, i32 1
	%tmp19 = load i32, i32* %tmp18
	%tmp20 = load %struct.GenericStructDefinedField*, %struct.GenericStructDefinedField** %vec
	%tmp21 = getelementptr inbounds %struct.GenericStructDefinedField, %struct.GenericStructDefinedField* %tmp20, i32 %tmp19
	store %struct.GenericStructDefinedField %data, %struct.GenericStructDefinedField* %tmp21
	%tmp22 = getelementptr inbounds %"struct.vector.Vec<%struct.GenericStructDefinedField>", %"struct.vector.Vec<%struct.GenericStructDefinedField>"* %vec, i32 0, i32 1
	%tmp23 = getelementptr inbounds %"struct.vector.Vec<%struct.GenericStructDefinedField>", %"struct.vector.Vec<%struct.GenericStructDefinedField>"* %vec, i32 0, i32 1
	%tmp24 = load i32, i32* %tmp23
	%tmp25 = add i32 %tmp24, 1
	store i32 %tmp25, i32* %tmp22
; Variable data is out.
	ret void
}
define void @"vector.push<ui32>"(%"struct.vector.Vec<ui32>"* %vec, i32 %data){
	%v0 = alloca i32
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<ui32>", %"struct.vector.Vec<ui32>"* %vec, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = getelementptr inbounds %"struct.vector.Vec<ui32>", %"struct.vector.Vec<ui32>"* %vec, i32 0, i32 2
	%tmp3 = load i32, i32* %tmp2
	%tmp4 = icmp uge i32 %tmp1, %tmp3
	br i1 %tmp4, label %then0, label %endif0
then0:
	store i32 4, i32* %v0
	%tmp5 = getelementptr inbounds %"struct.vector.Vec<ui32>", %"struct.vector.Vec<ui32>"* %vec, i32 0, i32 2
	%tmp6 = load i32, i32* %tmp5
	%tmp7 = icmp ne i32 %tmp6, 0
	br i1 %tmp7, label %then1, label %endif1
then1:
	%tmp8 = getelementptr inbounds %"struct.vector.Vec<ui32>", %"struct.vector.Vec<ui32>"* %vec, i32 0, i32 2
	%tmp9 = load i32, i32* %tmp8
	%tmp10 = mul i32 %tmp9, 2
	store i32 %tmp10, i32* %v0
	br label %endif1
endif1:
	%tmp11 = load i32, i32* %v0
	%tmp12 = zext i32 %tmp11 to i64
	%tmp13 = mul i64 4, %tmp12
	%tmp14 = load i32*, i32** %vec
	%tmp15 = call i8* @mem.realloc(i8* %tmp14, i64 %tmp13)
	store i32* %tmp15, i32** %vec
	%tmp16 = getelementptr inbounds %"struct.vector.Vec<ui32>", %"struct.vector.Vec<ui32>"* %vec, i32 0, i32 2
	%tmp17 = load i32, i32* %v0
	store i32 %tmp17, i32* %tmp16
	br label %endif0
endif0:
	%tmp18 = getelementptr inbounds %"struct.vector.Vec<ui32>", %"struct.vector.Vec<ui32>"* %vec, i32 0, i32 1
	%tmp19 = load i32, i32* %tmp18
	%tmp20 = load i32*, i32** %vec
	%tmp21 = getelementptr inbounds i32, i32* %tmp20, i32 %tmp19
	store i32 %data, i32* %tmp21
	%tmp22 = getelementptr inbounds %"struct.vector.Vec<ui32>", %"struct.vector.Vec<ui32>"* %vec, i32 0, i32 1
	%tmp23 = getelementptr inbounds %"struct.vector.Vec<ui32>", %"struct.vector.Vec<ui32>"* %vec, i32 0, i32 1
	%tmp24 = load i32, i32* %tmp23
	%tmp25 = add i32 %tmp24, 1
	store i32 %tmp25, i32* %tmp22
	ret void
}
define void @"vector.push<%struct.vector.Vec<%struct.CompilerType>>"(%"struct.vector.Vec<%struct.vector.Vec<%struct.CompilerType>>"* %vec, %"struct.vector.Vec<%struct.CompilerType>" %data){
	%v0 = alloca i32
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.vector.Vec<%struct.CompilerType>>", %"struct.vector.Vec<%struct.vector.Vec<%struct.CompilerType>>"* %vec, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = getelementptr inbounds %"struct.vector.Vec<%struct.vector.Vec<%struct.CompilerType>>", %"struct.vector.Vec<%struct.vector.Vec<%struct.CompilerType>>"* %vec, i32 0, i32 2
	%tmp3 = load i32, i32* %tmp2
	%tmp4 = icmp uge i32 %tmp1, %tmp3
	br i1 %tmp4, label %then0, label %endif0
then0:
	store i32 4, i32* %v0
	%tmp5 = getelementptr inbounds %"struct.vector.Vec<%struct.vector.Vec<%struct.CompilerType>>", %"struct.vector.Vec<%struct.vector.Vec<%struct.CompilerType>>"* %vec, i32 0, i32 2
	%tmp6 = load i32, i32* %tmp5
	%tmp7 = icmp ne i32 %tmp6, 0
	br i1 %tmp7, label %then1, label %endif1
then1:
	%tmp8 = getelementptr inbounds %"struct.vector.Vec<%struct.vector.Vec<%struct.CompilerType>>", %"struct.vector.Vec<%struct.vector.Vec<%struct.CompilerType>>"* %vec, i32 0, i32 2
	%tmp9 = load i32, i32* %tmp8
	%tmp10 = mul i32 %tmp9, 2
	store i32 %tmp10, i32* %v0
	br label %endif1
endif1:
	%tmp11 = load i32, i32* %v0
	%tmp12 = zext i32 %tmp11 to i64
	%tmp13 = mul i64 16, %tmp12
	%tmp14 = load %"struct.vector.Vec<%struct.CompilerType>"*, %"struct.vector.Vec<%struct.CompilerType>"** %vec
	%tmp15 = call i8* @mem.realloc(i8* %tmp14, i64 %tmp13)
	store %"struct.vector.Vec<%struct.CompilerType>"* %tmp15, %"struct.vector.Vec<%struct.CompilerType>"** %vec
	%tmp16 = getelementptr inbounds %"struct.vector.Vec<%struct.vector.Vec<%struct.CompilerType>>", %"struct.vector.Vec<%struct.vector.Vec<%struct.CompilerType>>"* %vec, i32 0, i32 2
	%tmp17 = load i32, i32* %v0
	store i32 %tmp17, i32* %tmp16
	br label %endif0
endif0:
	%tmp18 = getelementptr inbounds %"struct.vector.Vec<%struct.vector.Vec<%struct.CompilerType>>", %"struct.vector.Vec<%struct.vector.Vec<%struct.CompilerType>>"* %vec, i32 0, i32 1
	%tmp19 = load i32, i32* %tmp18
	%tmp20 = load %"struct.vector.Vec<%struct.CompilerType>"*, %"struct.vector.Vec<%struct.CompilerType>"** %vec
	%tmp21 = getelementptr inbounds %"struct.vector.Vec<%struct.CompilerType>", %"struct.vector.Vec<%struct.CompilerType>"* %tmp20, i32 %tmp19
	store %"struct.vector.Vec<%struct.CompilerType>" %data, %"struct.vector.Vec<%struct.CompilerType>"* %tmp21
	%tmp22 = getelementptr inbounds %"struct.vector.Vec<%struct.vector.Vec<%struct.CompilerType>>", %"struct.vector.Vec<%struct.vector.Vec<%struct.CompilerType>>"* %vec, i32 0, i32 1
	%tmp23 = getelementptr inbounds %"struct.vector.Vec<%struct.vector.Vec<%struct.CompilerType>>", %"struct.vector.Vec<%struct.vector.Vec<%struct.CompilerType>>"* %vec, i32 0, i32 1
	%tmp24 = load i32, i32* %tmp23
	%tmp25 = add i32 %tmp24, 1
	store i32 %tmp25, i32* %tmp22
; Variable data is out.
	ret void
}
define void @"vector.push<%struct.CompilerType>"(%"struct.vector.Vec<%struct.CompilerType>"* %vec, %struct.CompilerType %data){
	%v0 = alloca i32
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.CompilerType>", %"struct.vector.Vec<%struct.CompilerType>"* %vec, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = getelementptr inbounds %"struct.vector.Vec<%struct.CompilerType>", %"struct.vector.Vec<%struct.CompilerType>"* %vec, i32 0, i32 2
	%tmp3 = load i32, i32* %tmp2
	%tmp4 = icmp uge i32 %tmp1, %tmp3
	br i1 %tmp4, label %then0, label %endif0
then0:
	store i32 4, i32* %v0
	%tmp5 = getelementptr inbounds %"struct.vector.Vec<%struct.CompilerType>", %"struct.vector.Vec<%struct.CompilerType>"* %vec, i32 0, i32 2
	%tmp6 = load i32, i32* %tmp5
	%tmp7 = icmp ne i32 %tmp6, 0
	br i1 %tmp7, label %then1, label %endif1
then1:
	%tmp8 = getelementptr inbounds %"struct.vector.Vec<%struct.CompilerType>", %"struct.vector.Vec<%struct.CompilerType>"* %vec, i32 0, i32 2
	%tmp9 = load i32, i32* %tmp8
	%tmp10 = mul i32 %tmp9, 2
	store i32 %tmp10, i32* %v0
	br label %endif1
endif1:
	%tmp11 = load i32, i32* %v0
	%tmp12 = zext i32 %tmp11 to i64
	%tmp13 = mul i64 16, %tmp12
	%tmp14 = load %struct.CompilerType*, %struct.CompilerType** %vec
	%tmp15 = call i8* @mem.realloc(i8* %tmp14, i64 %tmp13)
	store %struct.CompilerType* %tmp15, %struct.CompilerType** %vec
	%tmp16 = getelementptr inbounds %"struct.vector.Vec<%struct.CompilerType>", %"struct.vector.Vec<%struct.CompilerType>"* %vec, i32 0, i32 2
	%tmp17 = load i32, i32* %v0
	store i32 %tmp17, i32* %tmp16
	br label %endif0
endif0:
	%tmp18 = getelementptr inbounds %"struct.vector.Vec<%struct.CompilerType>", %"struct.vector.Vec<%struct.CompilerType>"* %vec, i32 0, i32 1
	%tmp19 = load i32, i32* %tmp18
	%tmp20 = load %struct.CompilerType*, %struct.CompilerType** %vec
	%tmp21 = getelementptr inbounds %struct.CompilerType, %struct.CompilerType* %tmp20, i32 %tmp19
	store %struct.CompilerType %data, %struct.CompilerType* %tmp21
	%tmp22 = getelementptr inbounds %"struct.vector.Vec<%struct.CompilerType>", %"struct.vector.Vec<%struct.CompilerType>"* %vec, i32 0, i32 1
	%tmp23 = getelementptr inbounds %"struct.vector.Vec<%struct.CompilerType>", %"struct.vector.Vec<%struct.CompilerType>"* %vec, i32 0, i32 1
	%tmp24 = load i32, i32* %tmp23
	%tmp25 = add i32 %tmp24, 1
	store i32 %tmp25, i32* %tmp22
; Variable data is out.
	ret void
}
define void @"vector.push<%struct.SymbolTableEntry>"(%"struct.vector.Vec<%struct.SymbolTableEntry>"* %vec, %struct.SymbolTableEntry %data){
	%v0 = alloca i32
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.SymbolTableEntry>", %"struct.vector.Vec<%struct.SymbolTableEntry>"* %vec, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = getelementptr inbounds %"struct.vector.Vec<%struct.SymbolTableEntry>", %"struct.vector.Vec<%struct.SymbolTableEntry>"* %vec, i32 0, i32 2
	%tmp3 = load i32, i32* %tmp2
	%tmp4 = icmp uge i32 %tmp1, %tmp3
	br i1 %tmp4, label %then0, label %endif0
then0:
	store i32 4, i32* %v0
	%tmp5 = getelementptr inbounds %"struct.vector.Vec<%struct.SymbolTableEntry>", %"struct.vector.Vec<%struct.SymbolTableEntry>"* %vec, i32 0, i32 2
	%tmp6 = load i32, i32* %tmp5
	%tmp7 = icmp ne i32 %tmp6, 0
	br i1 %tmp7, label %then1, label %endif1
then1:
	%tmp8 = getelementptr inbounds %"struct.vector.Vec<%struct.SymbolTableEntry>", %"struct.vector.Vec<%struct.SymbolTableEntry>"* %vec, i32 0, i32 2
	%tmp9 = load i32, i32* %tmp8
	%tmp10 = mul i32 %tmp9, 2
	store i32 %tmp10, i32* %v0
	br label %endif1
endif1:
	%tmp11 = load i32, i32* %v0
	%tmp12 = zext i32 %tmp11 to i64
	%tmp13 = mul i64 40, %tmp12
	%tmp14 = load %struct.SymbolTableEntry*, %struct.SymbolTableEntry** %vec
	%tmp15 = call i8* @mem.realloc(i8* %tmp14, i64 %tmp13)
	store %struct.SymbolTableEntry* %tmp15, %struct.SymbolTableEntry** %vec
	%tmp16 = getelementptr inbounds %"struct.vector.Vec<%struct.SymbolTableEntry>", %"struct.vector.Vec<%struct.SymbolTableEntry>"* %vec, i32 0, i32 2
	%tmp17 = load i32, i32* %v0
	store i32 %tmp17, i32* %tmp16
	br label %endif0
endif0:
	%tmp18 = getelementptr inbounds %"struct.vector.Vec<%struct.SymbolTableEntry>", %"struct.vector.Vec<%struct.SymbolTableEntry>"* %vec, i32 0, i32 1
	%tmp19 = load i32, i32* %tmp18
	%tmp20 = load %struct.SymbolTableEntry*, %struct.SymbolTableEntry** %vec
	%tmp21 = getelementptr inbounds %struct.SymbolTableEntry, %struct.SymbolTableEntry* %tmp20, i32 %tmp19
	store %struct.SymbolTableEntry %data, %struct.SymbolTableEntry* %tmp21
	%tmp22 = getelementptr inbounds %"struct.vector.Vec<%struct.SymbolTableEntry>", %"struct.vector.Vec<%struct.SymbolTableEntry>"* %vec, i32 0, i32 1
	%tmp23 = getelementptr inbounds %"struct.vector.Vec<%struct.SymbolTableEntry>", %"struct.vector.Vec<%struct.SymbolTableEntry>"* %vec, i32 0, i32 1
	%tmp24 = load i32, i32* %tmp23
	%tmp25 = add i32 %tmp24, 1
	store i32 %tmp25, i32* %tmp22
; Variable data is out.
	ret void
}
define void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %vec, %struct.TokenData %data){
	%v0 = alloca i32
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.TokenData>", %"struct.vector.Vec<%struct.TokenData>"* %vec, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = getelementptr inbounds %"struct.vector.Vec<%struct.TokenData>", %"struct.vector.Vec<%struct.TokenData>"* %vec, i32 0, i32 2
	%tmp3 = load i32, i32* %tmp2
	%tmp4 = icmp uge i32 %tmp1, %tmp3
	br i1 %tmp4, label %then0, label %endif0
then0:
	store i32 4, i32* %v0
	%tmp5 = getelementptr inbounds %"struct.vector.Vec<%struct.TokenData>", %"struct.vector.Vec<%struct.TokenData>"* %vec, i32 0, i32 2
	%tmp6 = load i32, i32* %tmp5
	%tmp7 = icmp ne i32 %tmp6, 0
	br i1 %tmp7, label %then1, label %endif1
then1:
	%tmp8 = getelementptr inbounds %"struct.vector.Vec<%struct.TokenData>", %"struct.vector.Vec<%struct.TokenData>"* %vec, i32 0, i32 2
	%tmp9 = load i32, i32* %tmp8
	%tmp10 = mul i32 %tmp9, 2
	store i32 %tmp10, i32* %v0
	br label %endif1
endif1:
	%tmp11 = load i32, i32* %v0
	%tmp12 = zext i32 %tmp11 to i64
	%tmp13 = mul i64 8, %tmp12
	%tmp14 = load %struct.TokenData*, %struct.TokenData** %vec
	%tmp15 = call i8* @mem.realloc(i8* %tmp14, i64 %tmp13)
	store %struct.TokenData* %tmp15, %struct.TokenData** %vec
	%tmp16 = getelementptr inbounds %"struct.vector.Vec<%struct.TokenData>", %"struct.vector.Vec<%struct.TokenData>"* %vec, i32 0, i32 2
	%tmp17 = load i32, i32* %v0
	store i32 %tmp17, i32* %tmp16
	br label %endif0
endif0:
	%tmp18 = getelementptr inbounds %"struct.vector.Vec<%struct.TokenData>", %"struct.vector.Vec<%struct.TokenData>"* %vec, i32 0, i32 1
	%tmp19 = load i32, i32* %tmp18
	%tmp20 = load %struct.TokenData*, %struct.TokenData** %vec
	%tmp21 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp20, i32 %tmp19
	store %struct.TokenData %data, %struct.TokenData* %tmp21
	%tmp22 = getelementptr inbounds %"struct.vector.Vec<%struct.TokenData>", %"struct.vector.Vec<%struct.TokenData>"* %vec, i32 0, i32 1
	%tmp23 = getelementptr inbounds %"struct.vector.Vec<%struct.TokenData>", %"struct.vector.Vec<%struct.TokenData>"* %vec, i32 0, i32 1
	%tmp24 = load i32, i32* %tmp23
	%tmp25 = add i32 %tmp24, 1
	store i32 %tmp25, i32* %tmp22
; Variable data is out.
	ret void
}
define void @"vector.push<%struct.EnumField>"(%"struct.vector.Vec<%struct.EnumField>"* %vec, %struct.EnumField %data){
	%v0 = alloca i32
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.EnumField>", %"struct.vector.Vec<%struct.EnumField>"* %vec, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = getelementptr inbounds %"struct.vector.Vec<%struct.EnumField>", %"struct.vector.Vec<%struct.EnumField>"* %vec, i32 0, i32 2
	%tmp3 = load i32, i32* %tmp2
	%tmp4 = icmp uge i32 %tmp1, %tmp3
	br i1 %tmp4, label %then0, label %endif0
then0:
	store i32 4, i32* %v0
	%tmp5 = getelementptr inbounds %"struct.vector.Vec<%struct.EnumField>", %"struct.vector.Vec<%struct.EnumField>"* %vec, i32 0, i32 2
	%tmp6 = load i32, i32* %tmp5
	%tmp7 = icmp ne i32 %tmp6, 0
	br i1 %tmp7, label %then1, label %endif1
then1:
	%tmp8 = getelementptr inbounds %"struct.vector.Vec<%struct.EnumField>", %"struct.vector.Vec<%struct.EnumField>"* %vec, i32 0, i32 2
	%tmp9 = load i32, i32* %tmp8
	%tmp10 = mul i32 %tmp9, 2
	store i32 %tmp10, i32* %v0
	br label %endif1
endif1:
	%tmp11 = load i32, i32* %v0
	%tmp12 = zext i32 %tmp11 to i64
	%tmp13 = mul i64 24, %tmp12
	%tmp14 = load %struct.EnumField*, %struct.EnumField** %vec
	%tmp15 = call i8* @mem.realloc(i8* %tmp14, i64 %tmp13)
	store %struct.EnumField* %tmp15, %struct.EnumField** %vec
	%tmp16 = getelementptr inbounds %"struct.vector.Vec<%struct.EnumField>", %"struct.vector.Vec<%struct.EnumField>"* %vec, i32 0, i32 2
	%tmp17 = load i32, i32* %v0
	store i32 %tmp17, i32* %tmp16
	br label %endif0
endif0:
	%tmp18 = getelementptr inbounds %"struct.vector.Vec<%struct.EnumField>", %"struct.vector.Vec<%struct.EnumField>"* %vec, i32 0, i32 1
	%tmp19 = load i32, i32* %tmp18
	%tmp20 = load %struct.EnumField*, %struct.EnumField** %vec
	%tmp21 = getelementptr inbounds %struct.EnumField, %struct.EnumField* %tmp20, i32 %tmp19
	store %struct.EnumField %data, %struct.EnumField* %tmp21
	%tmp22 = getelementptr inbounds %"struct.vector.Vec<%struct.EnumField>", %"struct.vector.Vec<%struct.EnumField>"* %vec, i32 0, i32 1
	%tmp23 = getelementptr inbounds %"struct.vector.Vec<%struct.EnumField>", %"struct.vector.Vec<%struct.EnumField>"* %vec, i32 0, i32 1
	%tmp24 = load i32, i32* %tmp23
	%tmp25 = add i32 %tmp24, 1
	store i32 %tmp25, i32* %tmp22
; Variable data is out.
	ret void
}
define void @"vector.push<%struct.StructInitFieldExpr>"(%"struct.vector.Vec<%struct.StructInitFieldExpr>"* %vec, %struct.StructInitFieldExpr %data){
	%v0 = alloca i32
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.StructInitFieldExpr>", %"struct.vector.Vec<%struct.StructInitFieldExpr>"* %vec, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = getelementptr inbounds %"struct.vector.Vec<%struct.StructInitFieldExpr>", %"struct.vector.Vec<%struct.StructInitFieldExpr>"* %vec, i32 0, i32 2
	%tmp3 = load i32, i32* %tmp2
	%tmp4 = icmp uge i32 %tmp1, %tmp3
	br i1 %tmp4, label %then0, label %endif0
then0:
	store i32 4, i32* %v0
	%tmp5 = getelementptr inbounds %"struct.vector.Vec<%struct.StructInitFieldExpr>", %"struct.vector.Vec<%struct.StructInitFieldExpr>"* %vec, i32 0, i32 2
	%tmp6 = load i32, i32* %tmp5
	%tmp7 = icmp ne i32 %tmp6, 0
	br i1 %tmp7, label %then1, label %endif1
then1:
	%tmp8 = getelementptr inbounds %"struct.vector.Vec<%struct.StructInitFieldExpr>", %"struct.vector.Vec<%struct.StructInitFieldExpr>"* %vec, i32 0, i32 2
	%tmp9 = load i32, i32* %tmp8
	%tmp10 = mul i32 %tmp9, 2
	store i32 %tmp10, i32* %v0
	br label %endif1
endif1:
	%tmp11 = load i32, i32* %v0
	%tmp12 = zext i32 %tmp11 to i64
	%tmp13 = mul i64 24, %tmp12
	%tmp14 = load %struct.StructInitFieldExpr*, %struct.StructInitFieldExpr** %vec
	%tmp15 = call i8* @mem.realloc(i8* %tmp14, i64 %tmp13)
	store %struct.StructInitFieldExpr* %tmp15, %struct.StructInitFieldExpr** %vec
	%tmp16 = getelementptr inbounds %"struct.vector.Vec<%struct.StructInitFieldExpr>", %"struct.vector.Vec<%struct.StructInitFieldExpr>"* %vec, i32 0, i32 2
	%tmp17 = load i32, i32* %v0
	store i32 %tmp17, i32* %tmp16
	br label %endif0
endif0:
	%tmp18 = getelementptr inbounds %"struct.vector.Vec<%struct.StructInitFieldExpr>", %"struct.vector.Vec<%struct.StructInitFieldExpr>"* %vec, i32 0, i32 1
	%tmp19 = load i32, i32* %tmp18
	%tmp20 = load %struct.StructInitFieldExpr*, %struct.StructInitFieldExpr** %vec
	%tmp21 = getelementptr inbounds %struct.StructInitFieldExpr, %struct.StructInitFieldExpr* %tmp20, i32 %tmp19
	store %struct.StructInitFieldExpr %data, %struct.StructInitFieldExpr* %tmp21
	%tmp22 = getelementptr inbounds %"struct.vector.Vec<%struct.StructInitFieldExpr>", %"struct.vector.Vec<%struct.StructInitFieldExpr>"* %vec, i32 0, i32 1
	%tmp23 = getelementptr inbounds %"struct.vector.Vec<%struct.StructInitFieldExpr>", %"struct.vector.Vec<%struct.StructInitFieldExpr>"* %vec, i32 0, i32 1
	%tmp24 = load i32, i32* %tmp23
	%tmp25 = add i32 %tmp24, 1
	store i32 %tmp25, i32* %tmp22
; Variable data is out.
	ret void
}
define void @"vector.push<%struct.Expression>"(%"struct.vector.Vec<%struct.Expression>"* %vec, %struct.Expression %data){
	%v0 = alloca i32
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Expression>"* %vec, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = getelementptr inbounds %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Expression>"* %vec, i32 0, i32 2
	%tmp3 = load i32, i32* %tmp2
	%tmp4 = icmp uge i32 %tmp1, %tmp3
	br i1 %tmp4, label %then0, label %endif0
then0:
	store i32 4, i32* %v0
	%tmp5 = getelementptr inbounds %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Expression>"* %vec, i32 0, i32 2
	%tmp6 = load i32, i32* %tmp5
	%tmp7 = icmp ne i32 %tmp6, 0
	br i1 %tmp7, label %then1, label %endif1
then1:
	%tmp8 = getelementptr inbounds %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Expression>"* %vec, i32 0, i32 2
	%tmp9 = load i32, i32* %tmp8
	%tmp10 = mul i32 %tmp9, 2
	store i32 %tmp10, i32* %v0
	br label %endif1
endif1:
	%tmp11 = load i32, i32* %v0
	%tmp12 = zext i32 %tmp11 to i64
	%tmp13 = mul i64 16, %tmp12
	%tmp14 = load %struct.Expression*, %struct.Expression** %vec
	%tmp15 = call i8* @mem.realloc(i8* %tmp14, i64 %tmp13)
	store %struct.Expression* %tmp15, %struct.Expression** %vec
	%tmp16 = getelementptr inbounds %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Expression>"* %vec, i32 0, i32 2
	%tmp17 = load i32, i32* %v0
	store i32 %tmp17, i32* %tmp16
	br label %endif0
endif0:
	%tmp18 = getelementptr inbounds %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Expression>"* %vec, i32 0, i32 1
	%tmp19 = load i32, i32* %tmp18
	%tmp20 = load %struct.Expression*, %struct.Expression** %vec
	%tmp21 = getelementptr inbounds %struct.Expression, %struct.Expression* %tmp20, i32 %tmp19
	store %struct.Expression %data, %struct.Expression* %tmp21
	%tmp22 = getelementptr inbounds %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Expression>"* %vec, i32 0, i32 1
	%tmp23 = getelementptr inbounds %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Expression>"* %vec, i32 0, i32 1
	%tmp24 = load i32, i32* %tmp23
	%tmp25 = add i32 %tmp24, 1
	store i32 %tmp25, i32* %tmp22
; Variable data is out.
	ret void
}
define void @"vector.push<ui16>"(%"struct.vector.Vec<ui16>"* %vec, i16 %data){
	%v0 = alloca i32
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<ui16>", %"struct.vector.Vec<ui16>"* %vec, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = getelementptr inbounds %"struct.vector.Vec<ui16>", %"struct.vector.Vec<ui16>"* %vec, i32 0, i32 2
	%tmp3 = load i32, i32* %tmp2
	%tmp4 = icmp uge i32 %tmp1, %tmp3
	br i1 %tmp4, label %then0, label %endif0
then0:
	store i32 4, i32* %v0
	%tmp5 = getelementptr inbounds %"struct.vector.Vec<ui16>", %"struct.vector.Vec<ui16>"* %vec, i32 0, i32 2
	%tmp6 = load i32, i32* %tmp5
	%tmp7 = icmp ne i32 %tmp6, 0
	br i1 %tmp7, label %then1, label %endif1
then1:
	%tmp8 = getelementptr inbounds %"struct.vector.Vec<ui16>", %"struct.vector.Vec<ui16>"* %vec, i32 0, i32 2
	%tmp9 = load i32, i32* %tmp8
	%tmp10 = mul i32 %tmp9, 2
	store i32 %tmp10, i32* %v0
	br label %endif1
endif1:
	%tmp11 = load i32, i32* %v0
	%tmp12 = zext i32 %tmp11 to i64
	%tmp13 = mul i64 2, %tmp12
	%tmp14 = load i16*, i16** %vec
	%tmp15 = call i8* @mem.realloc(i8* %tmp14, i64 %tmp13)
	store i16* %tmp15, i16** %vec
	%tmp16 = getelementptr inbounds %"struct.vector.Vec<ui16>", %"struct.vector.Vec<ui16>"* %vec, i32 0, i32 2
	%tmp17 = load i32, i32* %v0
	store i32 %tmp17, i32* %tmp16
	br label %endif0
endif0:
	%tmp18 = getelementptr inbounds %"struct.vector.Vec<ui16>", %"struct.vector.Vec<ui16>"* %vec, i32 0, i32 1
	%tmp19 = load i32, i32* %tmp18
	%tmp20 = load i16*, i16** %vec
	%tmp21 = getelementptr inbounds i16, i16* %tmp20, i32 %tmp19
	store i16 %data, i16* %tmp21
	%tmp22 = getelementptr inbounds %"struct.vector.Vec<ui16>", %"struct.vector.Vec<ui16>"* %vec, i32 0, i32 1
	%tmp23 = getelementptr inbounds %"struct.vector.Vec<ui16>", %"struct.vector.Vec<ui16>"* %vec, i32 0, i32 1
	%tmp24 = load i32, i32* %tmp23
	%tmp25 = add i32 %tmp24, 1
	store i32 %tmp25, i32* %tmp22
	ret void
}
define void @"vector.push<%struct.Argument>"(%"struct.vector.Vec<%struct.Argument>"* %vec, %struct.Argument %data){
	%v0 = alloca i32
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %vec, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = getelementptr inbounds %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %vec, i32 0, i32 2
	%tmp3 = load i32, i32* %tmp2
	%tmp4 = icmp uge i32 %tmp1, %tmp3
	br i1 %tmp4, label %then0, label %endif0
then0:
	store i32 4, i32* %v0
	%tmp5 = getelementptr inbounds %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %vec, i32 0, i32 2
	%tmp6 = load i32, i32* %tmp5
	%tmp7 = icmp ne i32 %tmp6, 0
	br i1 %tmp7, label %then1, label %endif1
then1:
	%tmp8 = getelementptr inbounds %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %vec, i32 0, i32 2
	%tmp9 = load i32, i32* %tmp8
	%tmp10 = mul i32 %tmp9, 2
	store i32 %tmp10, i32* %v0
	br label %endif1
endif1:
	%tmp11 = load i32, i32* %v0
	%tmp12 = zext i32 %tmp11 to i64
	%tmp13 = mul i64 24, %tmp12
	%tmp14 = load %struct.Argument*, %struct.Argument** %vec
	%tmp15 = call i8* @mem.realloc(i8* %tmp14, i64 %tmp13)
	store %struct.Argument* %tmp15, %struct.Argument** %vec
	%tmp16 = getelementptr inbounds %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %vec, i32 0, i32 2
	%tmp17 = load i32, i32* %v0
	store i32 %tmp17, i32* %tmp16
	br label %endif0
endif0:
	%tmp18 = getelementptr inbounds %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %vec, i32 0, i32 1
	%tmp19 = load i32, i32* %tmp18
	%tmp20 = load %struct.Argument*, %struct.Argument** %vec
	%tmp21 = getelementptr inbounds %struct.Argument, %struct.Argument* %tmp20, i32 %tmp19
	store %struct.Argument %data, %struct.Argument* %tmp21
	%tmp22 = getelementptr inbounds %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %vec, i32 0, i32 1
	%tmp23 = getelementptr inbounds %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %vec, i32 0, i32 1
	%tmp24 = load i32, i32* %tmp23
	%tmp25 = add i32 %tmp24, 1
	store i32 %tmp25, i32* %tmp22
; Variable data is out.
	ret void
}
define void @"vector.push<%struct.Type>"(%"struct.vector.Vec<%struct.Type>"* %vec, %struct.Type %data){
	%v0 = alloca i32
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %vec, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %vec, i32 0, i32 2
	%tmp3 = load i32, i32* %tmp2
	%tmp4 = icmp uge i32 %tmp1, %tmp3
	br i1 %tmp4, label %then0, label %endif0
then0:
	store i32 4, i32* %v0
	%tmp5 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %vec, i32 0, i32 2
	%tmp6 = load i32, i32* %tmp5
	%tmp7 = icmp ne i32 %tmp6, 0
	br i1 %tmp7, label %then1, label %endif1
then1:
	%tmp8 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %vec, i32 0, i32 2
	%tmp9 = load i32, i32* %tmp8
	%tmp10 = mul i32 %tmp9, 2
	store i32 %tmp10, i32* %v0
	br label %endif1
endif1:
	%tmp11 = load i32, i32* %v0
	%tmp12 = zext i32 %tmp11 to i64
	%tmp13 = mul i64 16, %tmp12
	%tmp14 = load %struct.Type*, %struct.Type** %vec
	%tmp15 = call i8* @mem.realloc(i8* %tmp14, i64 %tmp13)
	store %struct.Type* %tmp15, %struct.Type** %vec
	%tmp16 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %vec, i32 0, i32 2
	%tmp17 = load i32, i32* %v0
	store i32 %tmp17, i32* %tmp16
	br label %endif0
endif0:
	%tmp18 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %vec, i32 0, i32 1
	%tmp19 = load i32, i32* %tmp18
	%tmp20 = load %struct.Type*, %struct.Type** %vec
	%tmp21 = getelementptr inbounds %struct.Type, %struct.Type* %tmp20, i32 %tmp19
	store %struct.Type %data, %struct.Type* %tmp21
	%tmp22 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %vec, i32 0, i32 1
	%tmp23 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %vec, i32 0, i32 1
	%tmp24 = load i32, i32* %tmp23
	%tmp25 = add i32 %tmp24, 1
	store i32 %tmp25, i32* %tmp22
; Variable data is out.
	ret void
}
define void @"vector.push<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %vec, %struct.Stmt %data){
	%v0 = alloca i32
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %vec, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = getelementptr inbounds %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %vec, i32 0, i32 2
	%tmp3 = load i32, i32* %tmp2
	%tmp4 = icmp uge i32 %tmp1, %tmp3
	br i1 %tmp4, label %then0, label %endif0
then0:
	store i32 4, i32* %v0
	%tmp5 = getelementptr inbounds %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %vec, i32 0, i32 2
	%tmp6 = load i32, i32* %tmp5
	%tmp7 = icmp ne i32 %tmp6, 0
	br i1 %tmp7, label %then1, label %endif1
then1:
	%tmp8 = getelementptr inbounds %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %vec, i32 0, i32 2
	%tmp9 = load i32, i32* %tmp8
	%tmp10 = mul i32 %tmp9, 2
	store i32 %tmp10, i32* %v0
	br label %endif1
endif1:
	%tmp11 = load i32, i32* %v0
	%tmp12 = zext i32 %tmp11 to i64
	%tmp13 = mul i64 16, %tmp12
	%tmp14 = load %struct.Stmt*, %struct.Stmt** %vec
	%tmp15 = call i8* @mem.realloc(i8* %tmp14, i64 %tmp13)
	store %struct.Stmt* %tmp15, %struct.Stmt** %vec
	%tmp16 = getelementptr inbounds %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %vec, i32 0, i32 2
	%tmp17 = load i32, i32* %v0
	store i32 %tmp17, i32* %tmp16
	br label %endif0
endif0:
	%tmp18 = getelementptr inbounds %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %vec, i32 0, i32 1
	%tmp19 = load i32, i32* %tmp18
	%tmp20 = load %struct.Stmt*, %struct.Stmt** %vec
	%tmp21 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp20, i32 %tmp19
	store %struct.Stmt %data, %struct.Stmt* %tmp21
	%tmp22 = getelementptr inbounds %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %vec, i32 0, i32 1
	%tmp23 = getelementptr inbounds %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %vec, i32 0, i32 1
	%tmp24 = load i32, i32* %tmp23
	%tmp25 = add i32 %tmp24, 1
	store i32 %tmp25, i32* %tmp22
; Variable data is out.
	ret void
}
define void @"vector.push<%struct.string.String>"(%"struct.vector.Vec<%struct.string.String>"* %vec, %struct.string.String %data){
	%v0 = alloca i32
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 2
	%tmp3 = load i32, i32* %tmp2
	%tmp4 = icmp uge i32 %tmp1, %tmp3
	br i1 %tmp4, label %then0, label %endif0
then0:
	store i32 4, i32* %v0
	%tmp5 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 2
	%tmp6 = load i32, i32* %tmp5
	%tmp7 = icmp ne i32 %tmp6, 0
	br i1 %tmp7, label %then1, label %endif1
then1:
	%tmp8 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 2
	%tmp9 = load i32, i32* %tmp8
	%tmp10 = mul i32 %tmp9, 2
	store i32 %tmp10, i32* %v0
	br label %endif1
endif1:
	%tmp11 = load i32, i32* %v0
	%tmp12 = zext i32 %tmp11 to i64
	%tmp13 = mul i64 16, %tmp12
	%tmp14 = load %struct.string.String*, %struct.string.String** %vec
	%tmp15 = call i8* @mem.realloc(i8* %tmp14, i64 %tmp13)
	store %struct.string.String* %tmp15, %struct.string.String** %vec
	%tmp16 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 2
	%tmp17 = load i32, i32* %v0
	store i32 %tmp17, i32* %tmp16
	br label %endif0
endif0:
	%tmp18 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 1
	%tmp19 = load i32, i32* %tmp18
	%tmp20 = load %struct.string.String*, %struct.string.String** %vec
	%tmp21 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp20, i32 %tmp19
	store %struct.string.String %data, %struct.string.String* %tmp21
	%tmp22 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 1
	%tmp23 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 1
	%tmp24 = load i32, i32* %tmp23
	%tmp25 = add i32 %tmp24, 1
	store i32 %tmp25, i32* %tmp22
; Variable data is out.
	ret void
}
define void @"vector.push<i8>"(%"struct.vector.Vec<i8>"* %vec, i8 %data){
	%v0 = alloca i32
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 2
	%tmp3 = load i32, i32* %tmp2
	%tmp4 = icmp uge i32 %tmp1, %tmp3
	br i1 %tmp4, label %then0, label %endif0
then0:
	store i32 4, i32* %v0
	%tmp5 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 2
	%tmp6 = load i32, i32* %tmp5
	%tmp7 = icmp ne i32 %tmp6, 0
	br i1 %tmp7, label %then1, label %endif1
then1:
	%tmp8 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 2
	%tmp9 = load i32, i32* %tmp8
	%tmp10 = mul i32 %tmp9, 2
	store i32 %tmp10, i32* %v0
	br label %endif1
endif1:
	%tmp11 = load i32, i32* %v0
	%tmp12 = zext i32 %tmp11 to i64
	%tmp13 = mul i64 1, %tmp12
	%tmp14 = load i8*, i8** %vec
	%tmp15 = call i8* @mem.realloc(i8* %tmp14, i64 %tmp13)
	store i8* %tmp15, i8** %vec
	%tmp16 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 2
	%tmp17 = load i32, i32* %v0
	store i32 %tmp17, i32* %tmp16
	br label %endif0
endif0:
	%tmp18 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 1
	%tmp19 = load i32, i32* %tmp18
	%tmp20 = load i8*, i8** %vec
	%tmp21 = getelementptr inbounds i8, i8* %tmp20, i32 %tmp19
	store i8 %data, i8* %tmp21
	%tmp22 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 1
	%tmp23 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 1
	%tmp24 = load i32, i32* %tmp23
	%tmp25 = add i32 %tmp24, 1
	store i32 %tmp25, i32* %tmp22
	ret void
}
define %struct.Variable @"vector.pop<%struct.Variable>"(%"struct.vector.Vec<%struct.Variable>"* %vec){
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.Variable>", %"struct.vector.Vec<%struct.Variable>"* %vec, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = icmp eq i32 %tmp1, 0
	br i1 %tmp2, label %then0, label %endif0
then0:
	call void @process.throw(i8* @.str.354)
	br label %endif0
endif0:
	%tmp3 = getelementptr inbounds %"struct.vector.Vec<%struct.Variable>", %"struct.vector.Vec<%struct.Variable>"* %vec, i32 0, i32 1
	%tmp4 = getelementptr inbounds %"struct.vector.Vec<%struct.Variable>", %"struct.vector.Vec<%struct.Variable>"* %vec, i32 0, i32 1
	%tmp5 = load i32, i32* %tmp4
	%tmp6 = sub i32 %tmp5, 1
	store i32 %tmp6, i32* %tmp3
	%tmp7 = getelementptr inbounds %"struct.vector.Vec<%struct.Variable>", %"struct.vector.Vec<%struct.Variable>"* %vec, i32 0, i32 1
	%tmp8 = load i32, i32* %tmp7
	%tmp9 = load %struct.Variable*, %struct.Variable** %vec
	%tmp10 = getelementptr inbounds %struct.Variable, %struct.Variable* %tmp9, i32 %tmp8
	%tmp11 = load %struct.Variable, %struct.Variable* %tmp10
	ret %struct.Variable %tmp11
}
define i32 @"vector.pop<ui32>"(%"struct.vector.Vec<ui32>"* %vec){
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<ui32>", %"struct.vector.Vec<ui32>"* %vec, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = icmp eq i32 %tmp1, 0
	br i1 %tmp2, label %then0, label %endif0
then0:
	call void @process.throw(i8* @.str.354)
	br label %endif0
endif0:
	%tmp3 = getelementptr inbounds %"struct.vector.Vec<ui32>", %"struct.vector.Vec<ui32>"* %vec, i32 0, i32 1
	%tmp4 = getelementptr inbounds %"struct.vector.Vec<ui32>", %"struct.vector.Vec<ui32>"* %vec, i32 0, i32 1
	%tmp5 = load i32, i32* %tmp4
	%tmp6 = sub i32 %tmp5, 1
	store i32 %tmp6, i32* %tmp3
	%tmp7 = getelementptr inbounds %"struct.vector.Vec<ui32>", %"struct.vector.Vec<ui32>"* %vec, i32 0, i32 1
	%tmp8 = load i32, i32* %tmp7
	%tmp9 = load i32*, i32** %vec
	%tmp10 = getelementptr inbounds i32, i32* %tmp9, i32 %tmp8
	%tmp11 = load i32, i32* %tmp10
	ret i32 %tmp11
}
define %"struct.vector.Vec<%struct.SymbolTableEntry>" @"vector.new<%struct.SymbolTableEntry>"(){
	%v0 = alloca %"struct.vector.Vec<%struct.SymbolTableEntry>"
	store %struct.SymbolTableEntry* null, %struct.SymbolTableEntry** %v0
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.SymbolTableEntry>", %"struct.vector.Vec<%struct.SymbolTableEntry>"* %v0, i32 0, i32 1
	store i32 0, i32* %tmp0
	%tmp1 = getelementptr inbounds %"struct.vector.Vec<%struct.SymbolTableEntry>", %"struct.vector.Vec<%struct.SymbolTableEntry>"* %v0, i32 0, i32 2
	store i32 0, i32* %tmp1
	%tmp2 = load %"struct.vector.Vec<%struct.SymbolTableEntry>", %"struct.vector.Vec<%struct.SymbolTableEntry>"* %v0
; Variable vec is out.
	ret %"struct.vector.Vec<%struct.SymbolTableEntry>" %tmp2
}
define %"struct.vector.Vec<%struct.EnumDefinedField>" @"vector.new<%struct.EnumDefinedField>"(){
	%v0 = alloca %"struct.vector.Vec<%struct.EnumDefinedField>"
	store %struct.EnumDefinedField* null, %struct.EnumDefinedField** %v0
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.EnumDefinedField>", %"struct.vector.Vec<%struct.EnumDefinedField>"* %v0, i32 0, i32 1
	store i32 0, i32* %tmp0
	%tmp1 = getelementptr inbounds %"struct.vector.Vec<%struct.EnumDefinedField>", %"struct.vector.Vec<%struct.EnumDefinedField>"* %v0, i32 0, i32 2
	store i32 0, i32* %tmp1
	%tmp2 = load %"struct.vector.Vec<%struct.EnumDefinedField>", %"struct.vector.Vec<%struct.EnumDefinedField>"* %v0
; Variable vec is out.
	ret %"struct.vector.Vec<%struct.EnumDefinedField>" %tmp2
}
define %"struct.vector.Vec<%struct.StructDefinedField>" @"vector.new<%struct.StructDefinedField>"(){
	%v0 = alloca %"struct.vector.Vec<%struct.StructDefinedField>"
	store %struct.StructDefinedField* null, %struct.StructDefinedField** %v0
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.StructDefinedField>", %"struct.vector.Vec<%struct.StructDefinedField>"* %v0, i32 0, i32 1
	store i32 0, i32* %tmp0
	%tmp1 = getelementptr inbounds %"struct.vector.Vec<%struct.StructDefinedField>", %"struct.vector.Vec<%struct.StructDefinedField>"* %v0, i32 0, i32 2
	store i32 0, i32* %tmp1
	%tmp2 = load %"struct.vector.Vec<%struct.StructDefinedField>", %"struct.vector.Vec<%struct.StructDefinedField>"* %v0
; Variable vec is out.
	ret %"struct.vector.Vec<%struct.StructDefinedField>" %tmp2
}
define %"struct.vector.Vec<%struct.vector.Vec<%struct.CompilerType>>" @"vector.new<%struct.vector.Vec<%struct.CompilerType>>"(){
	%v0 = alloca %"struct.vector.Vec<%struct.vector.Vec<%struct.CompilerType>>"
	store %"struct.vector.Vec<%struct.CompilerType>"* null, %"struct.vector.Vec<%struct.CompilerType>"** %v0
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.vector.Vec<%struct.CompilerType>>", %"struct.vector.Vec<%struct.vector.Vec<%struct.CompilerType>>"* %v0, i32 0, i32 1
	store i32 0, i32* %tmp0
	%tmp1 = getelementptr inbounds %"struct.vector.Vec<%struct.vector.Vec<%struct.CompilerType>>", %"struct.vector.Vec<%struct.vector.Vec<%struct.CompilerType>>"* %v0, i32 0, i32 2
	store i32 0, i32* %tmp1
	%tmp2 = load %"struct.vector.Vec<%struct.vector.Vec<%struct.CompilerType>>", %"struct.vector.Vec<%struct.vector.Vec<%struct.CompilerType>>"* %v0
; Variable vec is out.
	ret %"struct.vector.Vec<%struct.vector.Vec<%struct.CompilerType>>" %tmp2
}
define %"struct.vector.Vec<%struct.GenericStructDefinedField>" @"vector.new<%struct.GenericStructDefinedField>"(){
	%v0 = alloca %"struct.vector.Vec<%struct.GenericStructDefinedField>"
	store %struct.GenericStructDefinedField* null, %struct.GenericStructDefinedField** %v0
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.GenericStructDefinedField>", %"struct.vector.Vec<%struct.GenericStructDefinedField>"* %v0, i32 0, i32 1
	store i32 0, i32* %tmp0
	%tmp1 = getelementptr inbounds %"struct.vector.Vec<%struct.GenericStructDefinedField>", %"struct.vector.Vec<%struct.GenericStructDefinedField>"* %v0, i32 0, i32 2
	store i32 0, i32* %tmp1
	%tmp2 = load %"struct.vector.Vec<%struct.GenericStructDefinedField>", %"struct.vector.Vec<%struct.GenericStructDefinedField>"* %v0
; Variable vec is out.
	ret %"struct.vector.Vec<%struct.GenericStructDefinedField>" %tmp2
}
define %"struct.vector.Vec<%struct.CompilerType>" @"vector.new<%struct.CompilerType>"(){
	%v0 = alloca %"struct.vector.Vec<%struct.CompilerType>"
	store %struct.CompilerType* null, %struct.CompilerType** %v0
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.CompilerType>", %"struct.vector.Vec<%struct.CompilerType>"* %v0, i32 0, i32 1
	store i32 0, i32* %tmp0
	%tmp1 = getelementptr inbounds %"struct.vector.Vec<%struct.CompilerType>", %"struct.vector.Vec<%struct.CompilerType>"* %v0, i32 0, i32 2
	store i32 0, i32* %tmp1
	%tmp2 = load %"struct.vector.Vec<%struct.CompilerType>", %"struct.vector.Vec<%struct.CompilerType>"* %v0
; Variable vec is out.
	ret %"struct.vector.Vec<%struct.CompilerType>" %tmp2
}
define %"struct.vector.Vec<ui32>" @"vector.new<ui32>"(){
	%v0 = alloca %"struct.vector.Vec<ui32>"
	store i32* null, i32** %v0
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<ui32>", %"struct.vector.Vec<ui32>"* %v0, i32 0, i32 1
	store i32 0, i32* %tmp0
	%tmp1 = getelementptr inbounds %"struct.vector.Vec<ui32>", %"struct.vector.Vec<ui32>"* %v0, i32 0, i32 2
	store i32 0, i32* %tmp1
	%tmp2 = load %"struct.vector.Vec<ui32>", %"struct.vector.Vec<ui32>"* %v0
; Variable vec is out.
	ret %"struct.vector.Vec<ui32>" %tmp2
}
define %"struct.vector.Vec<%struct.Variable>" @"vector.new<%struct.Variable>"(){
	%v0 = alloca %"struct.vector.Vec<%struct.Variable>"
	store %struct.Variable* null, %struct.Variable** %v0
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.Variable>", %"struct.vector.Vec<%struct.Variable>"* %v0, i32 0, i32 1
	store i32 0, i32* %tmp0
	%tmp1 = getelementptr inbounds %"struct.vector.Vec<%struct.Variable>", %"struct.vector.Vec<%struct.Variable>"* %v0, i32 0, i32 2
	store i32 0, i32* %tmp1
	%tmp2 = load %"struct.vector.Vec<%struct.Variable>", %"struct.vector.Vec<%struct.Variable>"* %v0
; Variable vec is out.
	ret %"struct.vector.Vec<%struct.Variable>" %tmp2
}
define %"struct.vector.Vec<%struct.EnumField>" @"vector.new<%struct.EnumField>"(){
	%v0 = alloca %"struct.vector.Vec<%struct.EnumField>"
	store %struct.EnumField* null, %struct.EnumField** %v0
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.EnumField>", %"struct.vector.Vec<%struct.EnumField>"* %v0, i32 0, i32 1
	store i32 0, i32* %tmp0
	%tmp1 = getelementptr inbounds %"struct.vector.Vec<%struct.EnumField>", %"struct.vector.Vec<%struct.EnumField>"* %v0, i32 0, i32 2
	store i32 0, i32* %tmp1
	%tmp2 = load %"struct.vector.Vec<%struct.EnumField>", %"struct.vector.Vec<%struct.EnumField>"* %v0
; Variable vec is out.
	ret %"struct.vector.Vec<%struct.EnumField>" %tmp2
}
define %"struct.vector.Vec<%struct.StructInitFieldExpr>" @"vector.new<%struct.StructInitFieldExpr>"(){
	%v0 = alloca %"struct.vector.Vec<%struct.StructInitFieldExpr>"
	store %struct.StructInitFieldExpr* null, %struct.StructInitFieldExpr** %v0
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.StructInitFieldExpr>", %"struct.vector.Vec<%struct.StructInitFieldExpr>"* %v0, i32 0, i32 1
	store i32 0, i32* %tmp0
	%tmp1 = getelementptr inbounds %"struct.vector.Vec<%struct.StructInitFieldExpr>", %"struct.vector.Vec<%struct.StructInitFieldExpr>"* %v0, i32 0, i32 2
	store i32 0, i32* %tmp1
	%tmp2 = load %"struct.vector.Vec<%struct.StructInitFieldExpr>", %"struct.vector.Vec<%struct.StructInitFieldExpr>"* %v0
; Variable vec is out.
	ret %"struct.vector.Vec<%struct.StructInitFieldExpr>" %tmp2
}
define %"struct.vector.Vec<%struct.Expression>" @"vector.new<%struct.Expression>"(){
	%v0 = alloca %"struct.vector.Vec<%struct.Expression>"
	store %struct.Expression* null, %struct.Expression** %v0
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Expression>"* %v0, i32 0, i32 1
	store i32 0, i32* %tmp0
	%tmp1 = getelementptr inbounds %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Expression>"* %v0, i32 0, i32 2
	store i32 0, i32* %tmp1
	%tmp2 = load %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Expression>"* %v0
; Variable vec is out.
	ret %"struct.vector.Vec<%struct.Expression>" %tmp2
}
define %"struct.vector.Vec<ui16>" @"vector.new<ui16>"(){
	%v0 = alloca %"struct.vector.Vec<ui16>"
	store i16* null, i16** %v0
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<ui16>", %"struct.vector.Vec<ui16>"* %v0, i32 0, i32 1
	store i32 0, i32* %tmp0
	%tmp1 = getelementptr inbounds %"struct.vector.Vec<ui16>", %"struct.vector.Vec<ui16>"* %v0, i32 0, i32 2
	store i32 0, i32* %tmp1
	%tmp2 = load %"struct.vector.Vec<ui16>", %"struct.vector.Vec<ui16>"* %v0
; Variable vec is out.
	ret %"struct.vector.Vec<ui16>" %tmp2
}
define %"struct.vector.Vec<%struct.Argument>" @"vector.new<%struct.Argument>"(){
	%v0 = alloca %"struct.vector.Vec<%struct.Argument>"
	store %struct.Argument* null, %struct.Argument** %v0
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %v0, i32 0, i32 1
	store i32 0, i32* %tmp0
	%tmp1 = getelementptr inbounds %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %v0, i32 0, i32 2
	store i32 0, i32* %tmp1
	%tmp2 = load %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %v0
; Variable vec is out.
	ret %"struct.vector.Vec<%struct.Argument>" %tmp2
}
define %"struct.vector.Vec<%struct.Type>" @"vector.new<%struct.Type>"(){
	%v0 = alloca %"struct.vector.Vec<%struct.Type>"
	store %struct.Type* null, %struct.Type** %v0
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %v0, i32 0, i32 1
	store i32 0, i32* %tmp0
	%tmp1 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %v0, i32 0, i32 2
	store i32 0, i32* %tmp1
	%tmp2 = load %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %v0
; Variable vec is out.
	ret %"struct.vector.Vec<%struct.Type>" %tmp2
}
define %"struct.vector.Vec<%struct.TokenData>" @"vector.new<%struct.TokenData>"(){
	%v0 = alloca %"struct.vector.Vec<%struct.TokenData>"
	store %struct.TokenData* null, %struct.TokenData** %v0
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.TokenData>", %"struct.vector.Vec<%struct.TokenData>"* %v0, i32 0, i32 1
	store i32 0, i32* %tmp0
	%tmp1 = getelementptr inbounds %"struct.vector.Vec<%struct.TokenData>", %"struct.vector.Vec<%struct.TokenData>"* %v0, i32 0, i32 2
	store i32 0, i32* %tmp1
	%tmp2 = load %"struct.vector.Vec<%struct.TokenData>", %"struct.vector.Vec<%struct.TokenData>"* %v0
; Variable vec is out.
	ret %"struct.vector.Vec<%struct.TokenData>" %tmp2
}
define %"struct.vector.Vec<%struct.Stmt>" @"vector.new<%struct.Stmt>"(){
	%v0 = alloca %"struct.vector.Vec<%struct.Stmt>"
	store %struct.Stmt* null, %struct.Stmt** %v0
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %v0, i32 0, i32 1
	store i32 0, i32* %tmp0
	%tmp1 = getelementptr inbounds %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %v0, i32 0, i32 2
	store i32 0, i32* %tmp1
	%tmp2 = load %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %v0
; Variable vec is out.
	ret %"struct.vector.Vec<%struct.Stmt>" %tmp2
}
define %"struct.vector.Vec<i64>" @"vector.new<i64>"(){
	%v0 = alloca %"struct.vector.Vec<i64>"
	store i64* null, i64** %v0
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<i64>", %"struct.vector.Vec<i64>"* %v0, i32 0, i32 1
	store i32 0, i32* %tmp0
	%tmp1 = getelementptr inbounds %"struct.vector.Vec<i64>", %"struct.vector.Vec<i64>"* %v0, i32 0, i32 2
	store i32 0, i32* %tmp1
	%tmp2 = load %"struct.vector.Vec<i64>", %"struct.vector.Vec<i64>"* %v0
; Variable vec is out.
	ret %"struct.vector.Vec<i64>" %tmp2
}
define %"struct.vector.Vec<%struct.string.String>" @"vector.new<%struct.string.String>"(){
	%v0 = alloca %"struct.vector.Vec<%struct.string.String>"
	store %struct.string.String* null, %struct.string.String** %v0
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %v0, i32 0, i32 1
	store i32 0, i32* %tmp0
	%tmp1 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %v0, i32 0, i32 2
	store i32 0, i32* %tmp1
	%tmp2 = load %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %v0
; Variable vec is out.
	ret %"struct.vector.Vec<%struct.string.String>" %tmp2
}
define %"struct.vector.Vec<i8>" @"vector.new<i8>"(){
	%v0 = alloca %"struct.vector.Vec<i8>"
	store i8* null, i8** %v0
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 1
	store i32 0, i32* %tmp0
	%tmp1 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 2
	store i32 0, i32* %tmp1
	%tmp2 = load %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0
; Variable vec is out.
	ret %"struct.vector.Vec<i8>" %tmp2
}
define void @"vector.free<%struct.CompilerType>"(%"struct.vector.Vec<%struct.CompilerType>"* %vec){
	%tmp0 = load %struct.CompilerType*, %struct.CompilerType** %vec
	%tmp1 = icmp ne %struct.CompilerType* %tmp0, null
	br i1 %tmp1, label %then0, label %endif0
then0:
	%tmp2 = load %struct.CompilerType*, %struct.CompilerType** %vec
	call void @mem.free(i8* %tmp2)
	br label %endif0
endif0:
	store %struct.CompilerType* null, %struct.CompilerType** %vec
	%tmp3 = getelementptr inbounds %"struct.vector.Vec<%struct.CompilerType>", %"struct.vector.Vec<%struct.CompilerType>"* %vec, i32 0, i32 1
	store i32 0, i32* %tmp3
	%tmp4 = getelementptr inbounds %"struct.vector.Vec<%struct.CompilerType>", %"struct.vector.Vec<%struct.CompilerType>"* %vec, i32 0, i32 2
	store i32 0, i32* %tmp4
	ret void
}
define void @"vector.free<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %vec){
	%tmp0 = load %struct.Stmt*, %struct.Stmt** %vec
	%tmp1 = icmp ne %struct.Stmt* %tmp0, null
	br i1 %tmp1, label %then0, label %endif0
then0:
	%tmp2 = load %struct.Stmt*, %struct.Stmt** %vec
	call void @mem.free(i8* %tmp2)
	br label %endif0
endif0:
	store %struct.Stmt* null, %struct.Stmt** %vec
	%tmp3 = getelementptr inbounds %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %vec, i32 0, i32 1
	store i32 0, i32* %tmp3
	%tmp4 = getelementptr inbounds %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %vec, i32 0, i32 2
	store i32 0, i32* %tmp4
	ret void
}
define void @"vector.free<%struct.string.String>"(%"struct.vector.Vec<%struct.string.String>"* %vec){
	%tmp0 = load %struct.string.String*, %struct.string.String** %vec
	%tmp1 = icmp ne %struct.string.String* %tmp0, null
	br i1 %tmp1, label %then0, label %endif0
then0:
	%tmp2 = load %struct.string.String*, %struct.string.String** %vec
	call void @mem.free(i8* %tmp2)
	br label %endif0
endif0:
	store %struct.string.String* null, %struct.string.String** %vec
	%tmp3 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 1
	store i32 0, i32* %tmp3
	%tmp4 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 2
	store i32 0, i32* %tmp4
	ret void
}
define void @"vector.free<i8>"(%"struct.vector.Vec<i8>"* %vec){
	%tmp0 = load i8*, i8** %vec
	%tmp1 = icmp ne i8* %tmp0, null
	br i1 %tmp1, label %then0, label %endif0
then0:
	%tmp2 = load i8*, i8** %vec
	call void @mem.free(i8* %tmp2)
	br label %endif0
endif0:
	store i8* null, i8** %vec
	%tmp3 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 1
	store i32 0, i32* %tmp3
	%tmp4 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 2
	store i32 0, i32* %tmp4
	ret void
}
define void @"mem.default_fill<i8>"(i8 %val, i8* %dest, i64 %len){
	%v0 = alloca i64
	store i64 0, i64* %v0
	br label %loop_cond0
loop_cond0:
	%tmp0 = load i64, i64* %v0
	%tmp1 = icmp sge i64 %tmp0, %len
	br i1 %tmp1, label %then1, label %endif1
then1:
	br label %loop_body0_exit
endif1:
	%tmp2 = load i64, i64* %v0
	%tmp3 = getelementptr inbounds i8, i8* %dest, i64 %tmp2
	store i8 %val, i8* %tmp3
	%tmp4 = load i64, i64* %v0
	%tmp5 = add i64 %tmp4, 1
	store i64 %tmp5, i64* %v0
	br label %loop_cond0
loop_body0_exit:
	ret void
}
define i32 @"list.walk<i32>"(%"struct.list.List<i32>"* %list){
	%v0 = alloca i32
	%v1 = alloca %"struct.list.ListNode<i32>"*
	store i32 0, i32* %v0
	%tmp0 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %list
	store %"struct.list.ListNode<i32>"* %tmp0, %"struct.list.ListNode<i32>"** %v1
	br label %loop_start0
loop_start0:
	%tmp1 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v1
	%tmp2 = icmp ne %"struct.list.ListNode<i32>"* %tmp1, null
	br i1 %tmp2, label %endif1, label %else1
else1:
	br label %loop_body0_exit
endif1:
	%tmp3 = load i32, i32* %v0
	%tmp4 = add i32 %tmp3, 1
	store i32 %tmp4, i32* %v0
	%tmp5 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v1
	%tmp6 = getelementptr inbounds %"struct.list.ListNode<i32>", %"struct.list.ListNode<i32>"* %tmp5, i32 0, i32 1
	%tmp7 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %tmp6
	store %"struct.list.ListNode<i32>"* %tmp7, %"struct.list.ListNode<i32>"** %v1
	br label %loop_start0
loop_body0_exit:
	%tmp8 = load i32, i32* %v0
	ret i32 %tmp8
}
define %"struct.list.List<i32>" @"list.new<i32>"(){
	%v0 = alloca %"struct.list.List<i32>"
	store %"struct.list.ListNode<i32>"* null, %"struct.list.ListNode<i32>"** %v0
	%tmp0 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %v0, i32 0, i32 1
	store %"struct.list.ListNode<i32>"* null, %"struct.list.ListNode<i32>"** %tmp0
	%tmp1 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %v0, i32 0, i32 2
	store i32 0, i32* %tmp1
	%tmp2 = load %"struct.list.List<i32>", %"struct.list.List<i32>"* %v0
; Variable list is out.
	ret %"struct.list.List<i32>" %tmp2
}
define void @"list.free<i32>"(%"struct.list.List<i32>"* %list){
	%v0 = alloca %"struct.list.ListNode<i32>"*
	%v1 = alloca %"struct.list.ListNode<i32>"*
	%tmp0 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %list
	store %"struct.list.ListNode<i32>"* %tmp0, %"struct.list.ListNode<i32>"** %v0
	br label %loop_start0
loop_start0:
	%tmp1 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v0
	%tmp2 = icmp ne %"struct.list.ListNode<i32>"* %tmp1, null
	br i1 %tmp2, label %endif1, label %else1
else1:
	br label %loop_body0_exit
endif1:
	%tmp3 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v0
	%tmp4 = getelementptr inbounds %"struct.list.ListNode<i32>", %"struct.list.ListNode<i32>"* %tmp3, i32 0, i32 1
	%tmp5 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %tmp4
	store %"struct.list.ListNode<i32>"* %tmp5, %"struct.list.ListNode<i32>"** %v1
	%tmp6 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v0
	call void @mem.free(i8* %tmp6)
	%tmp7 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v1
	store %"struct.list.ListNode<i32>"* %tmp7, %"struct.list.ListNode<i32>"** %v0
	br label %loop_start0
loop_body0_exit:
	store %"struct.list.ListNode<i32>"* null, %"struct.list.ListNode<i32>"** %list
	%tmp8 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %list, i32 0, i32 1
	store %"struct.list.ListNode<i32>"* null, %"struct.list.ListNode<i32>"** %tmp8
	%tmp9 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %list, i32 0, i32 2
	store i32 0, i32* %tmp9
	ret void
}
define void @"list.extend<i32>"(%"struct.list.List<i32>"* %list, i32 %data){
	%v0 = alloca %"struct.list.ListNode<i32>"*
	%tmp0 = call i8* @mem.malloc(i64 16)
	store %"struct.list.ListNode<i32>"* %tmp0, %"struct.list.ListNode<i32>"** %v0
	%tmp1 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v0
	call void @"list.new_node<i32>"(%"struct.list.ListNode<i32>"* %tmp1)
	%tmp2 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v0
	store i32 %data, i32* %tmp2
	%tmp3 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %list
	%tmp4 = icmp eq %"struct.list.ListNode<i32>"* %tmp3, null
	br i1 %tmp4, label %then0, label %else0
then0:
	%tmp5 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v0
	store %"struct.list.ListNode<i32>"* %tmp5, %"struct.list.ListNode<i32>"** %list
	%tmp6 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %list, i32 0, i32 1
	%tmp7 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v0
	store %"struct.list.ListNode<i32>"* %tmp7, %"struct.list.ListNode<i32>"** %tmp6
	br label %endif0
else0:
	%tmp8 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %list, i32 0, i32 1
	%tmp9 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %list, i32 0, i32 1
	%tmp10 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %tmp9
	%tmp11 = getelementptr inbounds %"struct.list.ListNode<i32>", %"struct.list.ListNode<i32>"* %tmp10, i32 0, i32 1
	%tmp12 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v0
	store %"struct.list.ListNode<i32>"* %tmp12, %"struct.list.ListNode<i32>"** %tmp11
	%tmp13 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %list, i32 0, i32 1
	%tmp14 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v0
	store %"struct.list.ListNode<i32>"* %tmp14, %"struct.list.ListNode<i32>"** %tmp13
	br label %endif0
endif0:
	%tmp15 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %list, i32 0, i32 2
	%tmp16 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %list, i32 0, i32 2
	%tmp17 = load i32, i32* %tmp16
	%tmp18 = add i32 %tmp17, 1
	store i32 %tmp18, i32* %tmp15
	ret void
}
define void @"list.new_node<i32>"(%"struct.list.ListNode<i32>"* %list){
	%tmp0 = getelementptr inbounds %"struct.list.ListNode<i32>", %"struct.list.ListNode<i32>"* %list, i32 0, i32 1
	store %"struct.list.ListNode<i32>"* null, %"struct.list.ListNode<i32>"** %tmp0
	store i32 0, i32* %list
	ret void
}

;func STATIC_FILL_PRIMITIVE_TYPES_INFO []
;func __chkstk ["no_lazy"]
;func _fltused ["no_lazy"]
;func add_to_scope []
;func append_path []
;func append_path_ex []
;func compile []
;func compile_body []
;func compile_internal_sym_table []
;func compile_internal_sym_table_prefill []
;func compiler_type_push []
;func constant_evaluate_expression []
;func debug_dump_expression []
;func debug_dump_symbol_table []
;func debug_dump_type []
;func eight_layout []
;func enter_scope []
;func exit_scope []
;func expect []
;func find_primitive_type []
;func find_variable []
;func four_layout []
;func free_type []
;func get_binary_op []
;func get_compiler_type []
;func get_compiler_type_generic []
;func get_compiler_type_generic_internal []
;func get_compiler_type_internal []
;func get_flags []
;func get_symbol_from_table []
;func get_unary_op []
;func handle_char []
;func handle_decimal_number []
;func handle_number []
;func handle_string []
;func handle_symbol []
;func insert_symbol []
;func insert_symbol_into_table []
;func invalid_layout []
;func is_expression_starter []
;func is_modifier []
;func is_prefix_operator []
;func lex []
;func main []
;func new_scope []
;func one_layout []
;func parse []
;func parse_argument_comma []
;func parse_body []
;func parse_enum_fields []
;func parse_expression []
;func parse_expression_comma []
;func parse_expression_internal []
;func parse_generic_args []
;func parse_generic_params []
;func parse_struct_fields []
;func parse_type []
;func parse_type_internal []
;func parse_types_comma []
;func parse_types_comma_rparen []
;func path_to_path_ex []
;func path_to_path_ex_name []
;func precedence []
;func rcsharp_compile []
;func skip_if_statement []
;func skip_nested []
;func token_type_to_string []
;func two_layout []
;func wrap_in_pointers []
;func zero_layout []
;func char_utils.is_alnum []
;func char_utils.is_alpha []
;func char_utils.is_cntrl []
;func char_utils.is_digit []
;func char_utils.is_graph []
;func char_utils.is_lower []
;func char_utils.is_print []
;func char_utils.is_punct []
;func char_utils.is_space []
;func char_utils.is_upper []
;func char_utils.is_xdigit []
;func char_utils.to_lower []
;func char_utils.to_upper []
;func compile_internals.sym_table_push_external []
;func compile_internals.sym_table_push_static []
;func compile_internals.sym_table_push_structs []
;func compile_internals.sym_table_push_structs_generic []
;func console.get_stdout []
;func console.print_char []
;func console.println_f64 []
;func console.println_i64 []
;func console.println_u64 []
;func console.write []
;func console.write_string []
;func console.writeln []
;func fs.create_file []
;func fs.delete_file []
;func fs.file_exists []
;func fs.read_full_file_as_string []
;func fs.write_to_file []
;func list.extend []
;func list.free []
;func list.new []
;func list.new_node []
;func list.walk []
;func mem.compare []
;func mem.copy []
;func mem.default_fill []
;func mem.fill []
;func mem.free []
;func mem.get_total_allocated_memory_external []
;func mem.malloc []
;func mem.realloc []
;func mem.zero_fill []
;func process.get_executable_env_path []
;func process.get_executable_path []
;func process.throw ["no_return"]
;func stdlib.atoi []
;func stdlib.rand []
;func stdlib.srand []
;func stdlib.str_to_l []
;func string.append ["ExtensionOf"]
;func string.append_c_string ["ExtentionOf"]
;func string.append_str ["ExtensionOf"]
;func string.as_c_string_stalloc ["ExtentionOf"]
;func string.clone ["ExtentionOf"]
;func string.empty []
;func string.equal ["ExtentionOf"]
;func string.free ["ExtentionOf"]
;func string.from_c_string []
;func string.from_data []
;func string.reserve ["ExtensionOf"]
;func string.with_size []
;func string_utils.c_str_copy []
;func string_utils.c_str_len []
;func string_utils.c_str_n_copy []
;func string_utils.insert []
;func string_utils.u64_to_string []
;func tests.console_test []
;func tests.consume_while []
;func tests.fs_test []
;func tests.funny []
;func tests.is_valid_number_token []
;func tests.list_test []
;func tests.mem_test []
;func tests.not_new_line []
;func tests.process_test []
;func tests.run []
;func tests.string_test []
;func tests.string_utils_test []
;func tests.valid_name_token []
;func tests.vector_test []
;func vector.free ["ExtentionOf"]
;func vector.new []
;func vector.pop ["ExtentionOf"]
;func vector.push ["ExtentionOf"]
;func vector.push_bulk ["ExtentionOf"]
;func vector.remove_at ["ExtentionOf"]
;func window.WindowProc []
;func window.draw_bitmap []
;func window.draw_bitmap_stretched []
;func window.get_bitmap_dimensions []
;func window.is_null []
;func window.load_bitmap_from_file []
;func window.start []
;func window.start_image_window []
;type Argument
;type ArrayExpr
;type BinaryOpExpr
;type BlockStmt
;type BoolExpr
;type CallExpr
;type CastExpr
;type CharExpr
;type CompilerType
;type ConstantSizeArrayType
;type ConstantSymbolTableEntry
;type DecimalExpr
;type DeclarationNode
;type DoWhileStmt
;type EnumDefinedField
;type EnumField
;type EnumNode
;type EnumSymbolTableEntry
;type Expression
;type ExpressionNode
;type FnNode
;type ForStmt
;type FunctionSymbolTableEntry
;type FunctionType
;type GenericFunctionSymbolTableEntry
;type GenericImplementationCompilerType
;type GenericStructDefinedField
;type GenericStructSymbolTableEntry
;type GenericType
;type HintNode
;type IfStmt
;type IndexExpr
;type IntegerExpr
;type Layout
;type LoopStmt
;type MemberAccessExpr
;type NameExpr
;type NameWithGenericsExpr
;type NamedType
;type NamespaceLinkType
;type NamespaceNode
;type Path
;type PathEx
;type PointerCompilerType
;type PointerType
;type PrimitiveTypeInfo
;type RangeExpr
;type ReturnNode
;type Rvalue
;type Scope
;type StaticAccessExpr
;type StaticSymbolTableEntry
;type Stmt
;type StringConstExpr
;type StructDefinedField
;type StructInitExpr
;type StructInitFieldExpr
;type StructNode
;type StructSymbolTableEntry
;type SymbolTable
;type SymbolTableEntry
;type TokenData
;type Type
;type TypeExpr
;type UnaryOpExpr
;type Variable
;type WhileStmt
;type list.List
;type list.ListNode
;type mem.PROCESS_HEAP_ENTRY
;type string.String
;type vector.Vec
;type window.BITMAP
;type window.MSG
;type window.PAINTSTRUCT
;type window.POINT
;type window.RECT
;type window.WNDCLASSEXA
