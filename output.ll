%struct.mem.PROCESS_HEAP_ENTRY = type { i8*, i32, i8, i8, i16, i8*, i32, i32, i32 }
%struct.string.String = type { i8*, i32 }
%struct.window.BITMAP = type { i32, i32, i32, i32, i16, i16, i8* }
%struct.window.MSG = type { i8*, i32, i64, i64, i32, %struct.window.POINT }
%struct.window.PAINTSTRUCT = type { i8*, i32, %struct.window.RECT, i32, i32, [32 x i8] }
%struct.window.POINT = type { i32, i32 }
%struct.window.RECT = type { i32, i32, i32, i32 }
%struct.window.WNDCLASSEXA = type { i32, i32, i64 (i8*, i32, i64, i64)*, i32, i32, i8*, i8*, i8*, i8*, i8*, i8*, i8* }
%"struct.Pair<i8, %struct.string.String>" = type { i8, %struct.string.String }
%"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>" = type { i32, %"struct.Pair<i8, %struct.string.String>" }
%"struct.list.List<i32>" = type { %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"*, i32 }
%"struct.list.ListNode<i32>" = type { i32, %"struct.list.ListNode<i32>"* }
%"struct.test.QPair<i64, i64>" = type { i64, i64 }
%"struct.vector.Vec<i8>" = type { i8*, i32, i32 }
%"struct.vector.Vec<%struct.string.String>" = type { %struct.string.String*, i32, i32 }
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


@.str.0 = private unnamed_addr constant [48 x i8] c"Window error: StartError::GetModuleHandleFailed\00"
@.str.1 = private unnamed_addr constant [42 x i8] c"Failed to load image. not valid .BMP file\00"
@.str.2 = private unnamed_addr constant [21 x i8] c"BorderlessImageClass\00"
@.str.3 = private unnamed_addr constant [46 x i8] c"Window error: StartError::RegisterClassFailed\00"
@.str.4 = private unnamed_addr constant [12 x i8] c"ImageWindow\00"
@.str.5 = private unnamed_addr constant [45 x i8] c"Window error: StartError::CreateWindowFailed\00"
@.str.6 = private unnamed_addr constant [14 x i8] c"MyWindowClass\00"
@.str.7 = private unnamed_addr constant [14 x i8] c"Hello, World!\00"
@.str.8 = private unnamed_addr constant [37 x i8] c"File not found! While loading Bitmap\00"
@.str.9 = private unnamed_addr constant [14 x i8] c"vector_test: \00"
@.str.10 = private unnamed_addr constant [24 x i8] c"vector_test: new failed\00"
@.str.11 = private unnamed_addr constant [33 x i8] c"vector_test: initial push failed\00"
@.str.12 = private unnamed_addr constant [36 x i8] c"vector_test: initial content failed\00"
@.str.13 = private unnamed_addr constant [28 x i8] c"vector_test: realloc failed\00"
@.str.14 = private unnamed_addr constant [36 x i8] c"vector_test: realloc content failed\00"
@.str.15 = private unnamed_addr constant [3 x i8] c"AB\00"
@.str.16 = private unnamed_addr constant [37 x i8] c"vector_test: push_bulk length failed\00"
@.str.17 = private unnamed_addr constant [38 x i8] c"vector_test: push_bulk content failed\00"
@.str.18 = private unnamed_addr constant [25 x i8] c"vector_test: free failed\00"
@.str.19 = private unnamed_addr constant [3 x i8] c"OK\00"
@.str.20 = private unnamed_addr constant [20 x i8] c"string_utils_test: \00"
@.str.21 = private unnamed_addr constant [5 x i8] c"test\00"
@.str.22 = private unnamed_addr constant [36 x i8] c"string_utils_test: c_str_len failed\00"
@.str.23 = private unnamed_addr alias [1 x i8], [1 x i8]* bitcast (i8* getelementptr inbounds ([48 x i8], [48 x i8]* @.str.0, i64 0, i64 47) to [1 x i8]*)
@.str.24 = private unnamed_addr constant [42 x i8] c"string_utils_test: c_str_len empty failed\00"
@.str.25 = private unnamed_addr constant [32 x i8] c"char_utils: charis_digit failed\00"
@.str.26 = private unnamed_addr constant [28 x i8] c"char_utils: is_alpha failed\00"
@.str.27 = private unnamed_addr constant [29 x i8] c"char_utils: is_xdigit failed\00"
@.str.28 = private unnamed_addr constant [3 x i8] c"ac\00"
@.str.29 = private unnamed_addr constant [2 x i8] c"b\00"
@.str.30 = private unnamed_addr constant [4 x i8] c"abc\00"
@.str.31 = private unnamed_addr constant [33 x i8] c"string_utils_test: insert failed\00"
@.str.32 = private unnamed_addr constant [14 x i8] c"string_test: \00"
@.str.33 = private unnamed_addr constant [6 x i8] c"hello\00"
@.str.34 = private unnamed_addr alias [6 x i8], [6 x i8]* bitcast (i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.39, i64 0, i64 6) to [6 x i8]*)
@.str.35 = private unnamed_addr constant [41 x i8] c"string_test: from_c_string length failed\00"
@.str.36 = private unnamed_addr constant [40 x i8] c"string_test: equal positive case failed\00"
@.str.37 = private unnamed_addr constant [40 x i8] c"string_test: equal negative case failed\00"
@.str.38 = private unnamed_addr alias [7 x i8], [7 x i8]* bitcast (i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.39, i64 0, i64 5) to [7 x i8]*)
@.str.39 = private unnamed_addr constant [12 x i8] c"hello world\00"
@.str.40 = private unnamed_addr constant [34 x i8] c"string_test: concat length failed\00"
@.str.41 = private unnamed_addr constant [35 x i8] c"string_test: concat content failed\00"
@.str.42 = private unnamed_addr constant [20 x i8] c"test malloc delta: \00"
@.str.43 = private unnamed_addr constant [15 x i8] c"process_test: \00"
@.str.44 = private unnamed_addr constant [49 x i8] c"process_test: get_executable_path returned empty\00"
@.str.45 = private unnamed_addr constant [53 x i8] c"process_test: get_executable_env_path returned empty\00"
@.str.46 = private unnamed_addr constant [53 x i8] c"process_test: env path is not shorter than full path\00"
@.str.47 = private unnamed_addr constant [53 x i8] c"process_test: env path does not end with a backslash\00"
@.str.48 = private unnamed_addr constant [18 x i8] c"Executable Path: \00"
@.str.49 = private unnamed_addr constant [19 x i8] c"Environment Path: \00"
@.str.50 = private unnamed_addr constant [11 x i8] c"mem_test: \00"
@.str.51 = private unnamed_addr constant [24 x i8] c"mem_test: malloc failed\00"
@.str.52 = private unnamed_addr constant [35 x i8] c"mem_test: fill verification failed\00"
@.str.53 = private unnamed_addr constant [40 x i8] c"mem_test: zero_fill verification failed\00"
@.str.54 = private unnamed_addr constant [33 x i8] c"mem_test: malloc for copy failed\00"
@.str.55 = private unnamed_addr constant [35 x i8] c"mem_test: copy verification failed\00"
@.str.56 = private unnamed_addr constant [12 x i8] c"list_test: \00"
@.str.57 = private unnamed_addr constant [22 x i8] c"list_test: new failed\00"
@.str.58 = private unnamed_addr constant [41 x i8] c"list_test: length incorrect after extend\00"
@.str.59 = private unnamed_addr constant [33 x i8] c"list_test: walk length incorrect\00"
@.str.60 = private unnamed_addr constant [36 x i8] c"list_test: data mismatch for node 1\00"
@.str.61 = private unnamed_addr constant [36 x i8] c"list_test: data mismatch for node 2\00"
@.str.62 = private unnamed_addr constant [36 x i8] c"list_test: data mismatch for node 3\00"
@.str.63 = private unnamed_addr constant [33 x i8] c"list_test: foot pointer mismatch\00"
@.str.64 = private unnamed_addr constant [23 x i8] c"list_test: free failed\00"
@.str.65 = private unnamed_addr constant [45 x i8] c"D:\Projects\rcsharp\src_base_structs.rcsharp\00"
@.str.66 = private unnamed_addr constant [10 x i8] c"fs_test: \00"
@.str.67 = private unnamed_addr constant [47 x i8] c"The quick brown fox jumps over crazy lost dog.\00"
@.str.68 = private unnamed_addr constant [9 x i8] c"test.txt\00"
@.str.69 = private unnamed_addr constant [38 x i8] c"Filesystem test failed, data mismatch\00"
@.str.70 = private unnamed_addr constant [15 x i8] c"\0Aconsole_test:\00"
@.str.71 = private unnamed_addr constant [26 x i8] c"--- VISUAL TEST START ---\00"
@.str.72 = private unnamed_addr constant [22 x i8] c"Printing i64(12345): \00"
@.str.73 = private unnamed_addr constant [23 x i8] c"Printing i64(-67890): \00"
@.str.74 = private unnamed_addr constant [18 x i8] c"Printing i64(0): \00"
@.str.75 = private unnamed_addr constant [27 x i8] c"Printing u64(9876543210): \00"
@.str.76 = private unnamed_addr constant [24 x i8] c"--- VISUAL TEST END ---\00"
@.str.77 = private unnamed_addr constant [12 x i8] c"Exception: \00"
@.str.78 = private unnamed_addr constant [15 x i8] c"Realloc failed\00"
@.str.79 = private unnamed_addr constant [14 x i8] c"Out of memory\00"
@.str.80 = private unnamed_addr constant [33 x i8] c"Failed to lock heap for walking.\00"
@.str.81 = private unnamed_addr constant [17 x i8] c"File not found: \00"
@.str.82 = private unnamed_addr constant [17 x i8] c"File read failed\00"
@.str.83 = private unnamed_addr constant [3 x i8] c"0\0A\00"
@.str.84 = private unnamed_addr constant [26 x i8] c"stdout handle was invalid\00"
@yt = internal global [43 x i32] zeroinitializer
@stdlib.rand_seed = internal global i32 zeroinitializer

define i32 @main(){
	%v0 = alloca %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>"
	%v1 = alloca i32
	%tmp0 = getelementptr inbounds [43 x i32], [43 x i32]* @yt, i32 0, i64 42
	store i32 9999000, i32* %tmp0
	%tmp1 = call %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>" @"ax<i32>"()
	store %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>" %tmp1, %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>"* %v0
	%tmp2 = getelementptr inbounds %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>", %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>"* %v0, i32 0, i32 1
	%tmp3 = load i8, i8* %tmp2
	%tmp4 = sext i8 %tmp3 to i64
	call void @console.println_i64(i64 %tmp4)
	call void @console.println_f64(double 0x40DEADDD40000000)
	call void @console.println_i64(i64 31415)
	call void @console.println_i64(i64 4674364628954828846)
	%tmp5 = add i64 4674364628954828846, 123123123123
	%tmp6 = bitcast i64 %tmp5 to double
	call void @console.println_f64(double %tmp6)
	store i32 0, i32* %v1
	br label %loop_cond0
loop_cond0:
	%tmp7 = load i32, i32* %v1
	%tmp8 = icmp sge i32 %tmp7, 10
	br i1 %tmp8, label %then1, label %endif1
then1:
	br label %loop_body0_exit
endif1:
	%tmp9 = call i32 @stdlib.rand()
	%tmp10 = sext i32 %tmp9 to i64
	call void @console.println_i64(i64 %tmp10)
	%tmp11 = load i32, i32* %v1
	%tmp12 = add i32 %tmp11, 1
	store i32 %tmp12, i32* %v1
	br label %loop_cond0
loop_body0_exit:
	call void @basic_functions()
	%tmp13 = call %"struct.test.QPair<i64, i64>" @xq()
	%tmp14 = ptrtoint %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>" ()* @"ax<i32>" to i64
	%tmp15 = ptrtoint i32 ()* @main to i64
	%tmp16 = sub i64 %tmp14, %tmp15
	%tmp17 = trunc i64 %tmp16 to i32
	%tmp18 = getelementptr inbounds [43 x i32], [43 x i32]* @yt, i32 0, i64 42
	%tmp19 = load i32, i32* %tmp18
	%tmp20 = add i32 %tmp17, %tmp19
; Variable temp is out.
; Variable y is out.
	ret i32 %tmp20
}
define void @window.start_image_window(i8* %imagePath){
	%v0 = alloca i32
	%v1 = alloca i32
	%v2 = alloca %struct.window.WNDCLASSEXA
	%v3 = alloca %struct.window.RECT
	%v4 = alloca %struct.window.MSG
	%tmp0 = call i8* @GetModuleHandleA(i8* null)
	%tmp1 = icmp eq ptr %tmp0, null
	br i1 %tmp1, label %then1, label %endif1
then1:
	call void @process.throw(i8* @.str.0)
	br label %endif1
endif1:
	%tmp2 = call i8* @window.load_bitmap_from_file(i8* %imagePath)
	%tmp3 = icmp eq ptr %tmp2, null
	br i1 %tmp3, label %then2, label %endif2
then2:
	call void @process.throw(i8* @.str.1)
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
	store i8* @.str.2, i8** %tmp17
	%tmp18 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v2, i32 0, i32 11
	store i8* null, i8** %tmp18
	%tmp19 = call i16 @RegisterClassExA(%struct.window.WNDCLASSEXA* %v2)
	%tmp20 = icmp eq i16 %tmp19, 0
	br i1 %tmp20, label %then3, label %endif3
then3:
	call void @process.throw(i8* @.str.3)
	br label %endif3
endif3:
	%tmp21 = or i32 2147483648, 268435456
	%tmp22 = load i32, i32* %v0
	%tmp23 = load i32, i32* %v1
	%tmp24 = call i8* @CreateWindowExA(i32 8, i8* @.str.2, i8* @.str.4, i32 %tmp21, i32 100, i32 100, i32 %tmp22, i32 %tmp23, i8* null, i8* null, i8* %tmp0, i8* null)
	%tmp25 = icmp eq ptr %tmp24, null
	br i1 %tmp25, label %then5, label %endif5
then5:
	call void @process.throw(i8* @.str.5)
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
	%tmp1 = icmp eq ptr %tmp0, null
	br i1 %tmp1, label %then1, label %endif1
then1:
	call void @process.throw(i8* @.str.0)
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
	store i8* @.str.6, i8** %tmp15
	%tmp16 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v0, i32 0, i32 11
	store i8* null, i8** %tmp16
	%tmp17 = call i16 @RegisterClassExA(%struct.window.WNDCLASSEXA* %v0)
	%tmp18 = icmp eq i16 %tmp17, 0
	br i1 %tmp18, label %then2, label %endif2
then2:
	call void @process.throw(i8* @.str.3)
	br label %endif2
endif2:
	%tmp19 = call i8* @CreateWindowExA(i32 0, i8* @.str.6, i8* @.str.7, i32 13565952, i32 2147483648, i32 2147483648, i32 800, i32 600, i8* null, i8* null, i8* %tmp0, i8* null)
	%tmp20 = icmp eq ptr %tmp19, null
	br i1 %tmp20, label %then4, label %endif4
then4:
	call void @process.throw(i8* @.str.5)
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
	call void @process.throw(i8* @.str.8)
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
	%tmp0 = icmp eq ptr %hBitmap, null
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
	%tmp0 = icmp eq ptr %hBitmap, null
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
	%tmp13 = icmp ne ptr %tmp12, null
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
	call void @console.write(i8* @.str.9, i32 13)
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
	call void @process.throw(i8* @.str.10)
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
	call void @process.throw(i8* @.str.11)
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
	call void @process.throw(i8* @.str.12)
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
	call void @process.throw(i8* @.str.13)
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
	call void @process.throw(i8* @.str.14)
	br label %endif9
endif9:
	call void @"vector.push_bulk<i8>"(%"struct.vector.Vec<i8>"* %v0, i8* @.str.15, i32 2)
	%tmp38 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 1
	%tmp39 = load i32, i32* %tmp38
	%tmp40 = icmp ne i32 %tmp39, 7
	br i1 %tmp40, label %then10, label %endif10
then10:
	call void @process.throw(i8* @.str.16)
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
	call void @process.throw(i8* @.str.17)
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
	%tmp58 = icmp ne ptr %tmp57, null
	br label %logic_end_14
logic_end_14:
	%tmp59 = phi i1 [%tmp56, %logic_end_13], [%tmp58, %logic_rhs_14]
	br i1 %tmp59, label %then15, label %endif15
then15:
	call void @process.throw(i8* @.str.18)
	br label %endif15
endif15:
	call void @console.writeln(i8* @.str.19, i32 2)
; Variable v is out.
	ret void
}
define i1 @tests.valid_name_token(i8 %c){
entry:
	%tmp0 = call i1 @char_utils.is_alpha(i8 %c)
	br i1 %tmp0, label %logic_end_0, label %logic_rhs_0
logic_rhs_0:
	%tmp1 = call i1 @char_utils.is_digit(i8 %c)
	br label %logic_end_0
logic_end_0:
	%tmp2 = phi i1 [%tmp0, %entry], [%tmp1, %logic_rhs_0]
	br i1 %tmp2, label %logic_end_1, label %logic_rhs_1
logic_rhs_1:
	%tmp3 = icmp eq i8 %c, 95
	br label %logic_end_1
logic_end_1:
	%tmp4 = phi i1 [%tmp2, %logic_end_0], [%tmp3, %logic_rhs_1]
	ret i1 %tmp4
}
define void @tests.string_utils_test(){
	%v0 = alloca i32
	call void @console.write(i8* @.str.20, i32 19)
	%tmp0 = call i32 @string_utils.c_str_len(i8* @.str.21)
	%tmp1 = icmp ne i32 %tmp0, 4
	br i1 %tmp1, label %then0, label %endif0
then0:
	call void @process.throw(i8* @.str.22)
	br label %endif0
endif0:
	%tmp2 = call i32 @string_utils.c_str_len(i8* @.str.23)
	%tmp3 = icmp ne i32 %tmp2, 0
	br i1 %tmp3, label %then1, label %endif1
then1:
	call void @process.throw(i8* @.str.24)
	br label %endif1
endif1:
	%tmp4 = call i1 @char_utils.is_digit(i8 55)
	%tmp5 = xor i1 1, %tmp4
	br i1 %tmp5, label %logic_end_2, label %logic_rhs_2
logic_rhs_2:
	%tmp6 = call i1 @char_utils.is_digit(i8 98)
	br label %logic_end_2
logic_end_2:
	%tmp7 = phi i1 [%tmp5, %endif1], [%tmp6, %logic_rhs_2]
	br i1 %tmp7, label %then3, label %endif3
then3:
	call void @process.throw(i8* @.str.25)
	br label %endif3
endif3:
	%tmp8 = call i1 @char_utils.is_alpha(i8 97)
	%tmp9 = xor i1 1, %tmp8
	br i1 %tmp9, label %logic_end_4, label %logic_rhs_4
logic_rhs_4:
	%tmp10 = call i1 @char_utils.is_alpha(i8 57)
	br label %logic_end_4
logic_end_4:
	%tmp11 = phi i1 [%tmp9, %endif3], [%tmp10, %logic_rhs_4]
	br i1 %tmp11, label %then5, label %endif5
then5:
	call void @process.throw(i8* @.str.26)
	br label %endif5
endif5:
	%tmp12 = call i1 @char_utils.is_xdigit(i8 70)
	%tmp13 = xor i1 1, %tmp12
	br i1 %tmp13, label %logic_end_6, label %logic_rhs_6
logic_rhs_6:
	%tmp14 = call i1 @char_utils.is_xdigit(i8 71)
	br label %logic_end_6
logic_end_6:
	%tmp15 = phi i1 [%tmp13, %endif5], [%tmp14, %logic_rhs_6]
	br i1 %tmp15, label %then7, label %endif7
then7:
	call void @process.throw(i8* @.str.27)
	br label %endif7
endif7:
	%tmp16 = call i8* @string_utils.insert(i8* @.str.28, i8* @.str.29, i32 1)
	store i32 0, i32* %v0
	br label %loop_start8
loop_start8:
	%tmp17 = load i32, i32* %v0
	%tmp18 = getelementptr inbounds i8, i8* %tmp16, i32 %tmp17
	%tmp19 = load i8, i8* %tmp18
	%tmp20 = icmp ne i8 %tmp19, 0
	br i1 %tmp20, label %logic_end_9, label %logic_rhs_9
logic_rhs_9:
	%tmp21 = load i32, i32* %v0
	%tmp22 = getelementptr inbounds i8, i8* @.str.30, i32 %tmp21
	%tmp23 = load i8, i8* %tmp22
	%tmp24 = icmp ne i8 %tmp23, 0
	br label %logic_end_9
logic_end_9:
	%tmp25 = phi i1 [%tmp20, %loop_start8], [%tmp24, %logic_rhs_9]
	br i1 %tmp25, label %endif10, label %else10
else10:
	br label %loop_body8_exit
endif10:
	%tmp26 = load i32, i32* %v0
	%tmp27 = getelementptr inbounds i8, i8* %tmp16, i32 %tmp26
	%tmp28 = load i8, i8* %tmp27
	%tmp29 = load i32, i32* %v0
	%tmp30 = getelementptr inbounds i8, i8* @.str.30, i32 %tmp29
	%tmp31 = load i8, i8* %tmp30
	%tmp32 = icmp ne i8 %tmp28, %tmp31
	br i1 %tmp32, label %then11, label %endif11
then11:
	call void @process.throw(i8* @.str.31)
	br label %endif11
endif11:
	%tmp33 = load i32, i32* %v0
	%tmp34 = add i32 %tmp33, 1
	store i32 %tmp34, i32* %v0
	br label %loop_start8
loop_body8_exit:
	call void @mem.free(i8* %tmp16)
	call void @console.writeln(i8* @.str.19, i32 2)
	ret void
}
define void @tests.string_test(){
	%v0 = alloca %struct.string.String
	%v1 = alloca %struct.string.String
	%v2 = alloca %struct.string.String
	%v3 = alloca %struct.string.String
	%v4 = alloca %struct.string.String
	call void @console.write(i8* @.str.32, i32 13)
	%tmp0 = call %struct.string.String @string.from_c_string(i8* @.str.33)
	store %struct.string.String %tmp0, %struct.string.String* %v0
	%tmp1 = call %struct.string.String @string.from_c_string(i8* @.str.33)
	store %struct.string.String %tmp1, %struct.string.String* %v1
	%tmp2 = call %struct.string.String @string.from_c_string(i8* @.str.34)
	store %struct.string.String %tmp2, %struct.string.String* %v2
	%tmp3 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	%tmp4 = load i32, i32* %tmp3
	%tmp5 = icmp ne i32 %tmp4, 5
	br i1 %tmp5, label %then0, label %endif0
then0:
	call void @process.throw(i8* @.str.35)
	br label %endif0
endif0:
	%tmp6 = call i1 @string.equal(%struct.string.String* %v0, %struct.string.String* %v1)
	%tmp7 = xor i1 1, %tmp6
	br i1 %tmp7, label %then1, label %endif1
then1:
	call void @process.throw(i8* @.str.36)
	br label %endif1
endif1:
	%tmp8 = call i1 @string.equal(%struct.string.String* %v0, %struct.string.String* %v2)
	br i1 %tmp8, label %then2, label %endif2
then2:
	call void @process.throw(i8* @.str.37)
	br label %endif2
endif2:
	%tmp9 = call %struct.string.String @string.concat_with_c_string(%struct.string.String* %v0, i8* @.str.38)
	store %struct.string.String %tmp9, %struct.string.String* %v3
	%tmp10 = call %struct.string.String @string.from_c_string(i8* @.str.39)
	store %struct.string.String %tmp10, %struct.string.String* %v4
	%tmp11 = getelementptr inbounds %struct.string.String, %struct.string.String* %v3, i32 0, i32 1
	%tmp12 = load i32, i32* %tmp11
	%tmp13 = icmp ne i32 %tmp12, 11
	br i1 %tmp13, label %then3, label %endif3
then3:
	call void @process.throw(i8* @.str.40)
	br label %endif3
endif3:
	%tmp14 = call i1 @string.equal(%struct.string.String* %v3, %struct.string.String* %v4)
	%tmp15 = xor i1 1, %tmp14
	br i1 %tmp15, label %then4, label %endif4
then4:
	call void @process.throw(i8* @.str.41)
	br label %endif4
endif4:
	call void @string.free(%struct.string.String* %v0)
	call void @string.free(%struct.string.String* %v1)
	call void @string.free(%struct.string.String* %v2)
	call void @string.free(%struct.string.String* %v3)
	call void @string.free(%struct.string.String* %v4)
	call void @console.writeln(i8* @.str.19, i32 2)
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
	call void @console.write(i8* @.str.42, i32 19)
	call void @console.println_i64(i64 %tmp2)
	ret void
}
define void @tests.process_test(){
	%v0 = alloca %struct.string.String
	%v1 = alloca %struct.string.String
	call void @console.write(i8* @.str.43, i32 14)
	%tmp0 = call %struct.string.String @process.get_executable_path()
	store %struct.string.String %tmp0, %struct.string.String* %v0
	%tmp1 = call %struct.string.String @process.get_executable_env_path()
	store %struct.string.String %tmp1, %struct.string.String* %v1
	%tmp2 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	%tmp3 = load i32, i32* %tmp2
	%tmp4 = icmp sle i32 %tmp3, 0
	br i1 %tmp4, label %then0, label %endif0
then0:
	call void @process.throw(i8* @.str.44)
	br label %endif0
endif0:
	%tmp5 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 1
	%tmp6 = load i32, i32* %tmp5
	%tmp7 = icmp sle i32 %tmp6, 0
	br i1 %tmp7, label %then1, label %endif1
then1:
	call void @process.throw(i8* @.str.45)
	br label %endif1
endif1:
	%tmp8 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 1
	%tmp9 = load i32, i32* %tmp8
	%tmp10 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	%tmp11 = load i32, i32* %tmp10
	%tmp12 = icmp sge i32 %tmp9, %tmp11
	br i1 %tmp12, label %then2, label %endif2
then2:
	call void @process.throw(i8* @.str.46)
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
	call void @process.throw(i8* @.str.47)
	br label %endif3
endif3:
	call void @console.write(i8* @.str.48, i32 17)
	%tmp20 = load i8*, i8** %v0
	%tmp21 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	%tmp22 = load i32, i32* %tmp21
	call void @console.writeln(i8* %tmp20, i32 %tmp22)
	call void @console.write(i8* @.str.49, i32 18)
	%tmp23 = load i8*, i8** %v1
	%tmp24 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 1
	%tmp25 = load i32, i32* %tmp24
	call void @console.writeln(i8* %tmp23, i32 %tmp25)
	call void @string.free(%struct.string.String* %v0)
	call void @string.free(%struct.string.String* %v1)
	call void @console.writeln(i8* @.str.19, i32 2)
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
	call void @console.write(i8* @.str.50, i32 10)
	%tmp0 = call i8* @mem.malloc(i64 16)
	%tmp1 = bitcast i8* %tmp0 to i8*
	%tmp2 = icmp eq ptr %tmp1, null
	br i1 %tmp2, label %then0, label %endif0
then0:
	call void @process.throw(i8* @.str.51)
	br label %endif0
endif0:
	call void @mem.fill(i8 88, i8* %tmp1, i64 16)
	%tmp3 = sext i32 0 to i64
	store i64 %tmp3, i64* %v0
	br label %loop_cond1
loop_cond1:
	%tmp4 = load i64, i64* %v0
	%tmp5 = icmp sge i64 %tmp4, 16
	br i1 %tmp5, label %then2, label %endif2
then2:
	br label %loop_body1_exit
endif2:
	%tmp6 = load i64, i64* %v0
	%tmp7 = getelementptr inbounds i8, i8* %tmp1, i64 %tmp6
	%tmp8 = load i8, i8* %tmp7
	%tmp9 = icmp ne i8 %tmp8, 88
	br i1 %tmp9, label %then3, label %endif3
then3:
	call void @process.throw(i8* @.str.52)
	br label %endif3
endif3:
	%tmp10 = load i64, i64* %v0
	%tmp11 = add i64 %tmp10, 1
	store i64 %tmp11, i64* %v0
	br label %loop_cond1
loop_body1_exit:
	call void @mem.zero_fill(i8* %tmp1, i64 16)
	%tmp12 = sext i32 0 to i64
	store i64 %tmp12, i64* %v1
	br label %loop_cond4
loop_cond4:
	%tmp13 = load i64, i64* %v1
	%tmp14 = icmp sge i64 %tmp13, 16
	br i1 %tmp14, label %then5, label %endif5
then5:
	br label %loop_body4_exit
endif5:
	%tmp15 = load i64, i64* %v1
	%tmp16 = getelementptr inbounds i8, i8* %tmp1, i64 %tmp15
	%tmp17 = load i8, i8* %tmp16
	%tmp18 = icmp ne i8 %tmp17, 0
	br i1 %tmp18, label %then6, label %endif6
then6:
	call void @process.throw(i8* @.str.53)
	br label %endif6
endif6:
	%tmp19 = load i64, i64* %v1
	%tmp20 = add i64 %tmp19, 1
	store i64 %tmp20, i64* %v1
	br label %loop_cond4
loop_body4_exit:
	%tmp21 = call i8* @mem.malloc(i64 16)
	%tmp22 = bitcast i8* %tmp21 to i8*
	%tmp23 = icmp eq ptr %tmp22, null
	br i1 %tmp23, label %then7, label %endif7
then7:
	call void @process.throw(i8* @.str.54)
	br label %endif7
endif7:
	call void @mem.fill(i8 89, i8* %tmp22, i64 16)
	call void @mem.copy(i8* %tmp22, i8* %tmp1, i64 16)
	%tmp24 = sext i32 0 to i64
	store i64 %tmp24, i64* %v2
	br label %loop_cond8
loop_cond8:
	%tmp25 = load i64, i64* %v2
	%tmp26 = icmp sge i64 %tmp25, 16
	br i1 %tmp26, label %then9, label %endif9
then9:
	br label %loop_body8_exit
endif9:
	%tmp27 = load i64, i64* %v2
	%tmp28 = getelementptr inbounds i8, i8* %tmp1, i64 %tmp27
	%tmp29 = load i8, i8* %tmp28
	%tmp30 = icmp ne i8 %tmp29, 89
	br i1 %tmp30, label %then10, label %endif10
then10:
	call void @process.throw(i8* @.str.55)
	br label %endif10
endif10:
	%tmp31 = load i64, i64* %v2
	%tmp32 = add i64 %tmp31, 1
	store i64 %tmp32, i64* %v2
	br label %loop_cond8
loop_body8_exit:
	call void @mem.free(i8* %tmp1)
	call void @mem.free(i8* %tmp22)
	call void @console.writeln(i8* @.str.19, i32 2)
	ret void
}
define void @tests.list_test(){
entry:
	%v0 = alloca %"struct.list.List<i32>"
	%v1 = alloca %"struct.list.ListNode<i32>"*
	call void @console.write(i8* @.str.56, i32 11)
	%tmp0 = call %"struct.list.List<i32>" @"list.new<i32>"()
	store %"struct.list.List<i32>" %tmp0, %"struct.list.List<i32>"* %v0
	%tmp1 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %v0, i32 0, i32 2
	%tmp2 = load i32, i32* %tmp1
	%tmp3 = icmp ne i32 %tmp2, 0
	br i1 %tmp3, label %logic_end_0, label %logic_rhs_0
logic_rhs_0:
	%tmp4 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v0
	%tmp5 = icmp ne ptr %tmp4, null
	br label %logic_end_0
logic_end_0:
	%tmp6 = phi i1 [%tmp3, %entry], [%tmp5, %logic_rhs_0]
	br i1 %tmp6, label %then1, label %endif1
then1:
	call void @process.throw(i8* @.str.57)
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
	call void @process.throw(i8* @.str.58)
	br label %endif2
endif2:
	%tmp10 = call i32 @"list.walk<i32>"(%"struct.list.List<i32>"* %v0)
	%tmp11 = icmp ne i32 %tmp10, 3
	br i1 %tmp11, label %then3, label %endif3
then3:
	call void @process.throw(i8* @.str.59)
	br label %endif3
endif3:
	%tmp12 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v0
	store %"struct.list.ListNode<i32>"* %tmp12, %"struct.list.ListNode<i32>"** %v1
	%tmp13 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v1
	%tmp14 = load i32, i32* %tmp13
	%tmp15 = icmp ne i32 %tmp14, 100
	br i1 %tmp15, label %then4, label %endif4
then4:
	call void @process.throw(i8* @.str.60)
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
	call void @process.throw(i8* @.str.61)
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
	call void @process.throw(i8* @.str.62)
	br label %endif6
endif6:
	%tmp28 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v1
	%tmp29 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %v0, i32 0, i32 1
	%tmp30 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %tmp29
	%tmp31 = icmp ne ptr %tmp28, %tmp30
	br i1 %tmp31, label %then7, label %endif7
then7:
	call void @process.throw(i8* @.str.63)
	br label %endif7
endif7:
	call void @"list.free<i32>"(%"struct.list.List<i32>"* %v0)
	%tmp32 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %v0, i32 0, i32 2
	%tmp33 = load i32, i32* %tmp32
	%tmp34 = icmp ne i32 %tmp33, 0
	br i1 %tmp34, label %logic_end_8, label %logic_rhs_8
logic_rhs_8:
	%tmp35 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v0
	%tmp36 = icmp ne ptr %tmp35, null
	br label %logic_end_8
logic_end_8:
	%tmp37 = phi i1 [%tmp34, %endif7], [%tmp36, %logic_rhs_8]
	br i1 %tmp37, label %then9, label %endif9
then9:
	call void @process.throw(i8* @.str.64)
	br label %endif9
endif9:
	call void @console.writeln(i8* @.str.19, i32 2)
; Variable l is out.
	ret void
}
define i1 @tests.is_valid_number_token(i8 %c){
entry:
	%tmp0 = call i1 @char_utils.is_digit(i8 %c)
	br i1 %tmp0, label %logic_end_0, label %logic_rhs_0
logic_rhs_0:
	%tmp1 = call i1 @char_utils.is_xdigit(i8 %c)
	br label %logic_end_0
logic_end_0:
	%tmp2 = phi i1 [%tmp0, %entry], [%tmp1, %logic_rhs_0]
	br i1 %tmp2, label %logic_end_1, label %logic_rhs_1
logic_rhs_1:
	%tmp3 = icmp eq i8 %c, 95
	br label %logic_end_1
logic_end_1:
	%tmp4 = phi i1 [%tmp2, %logic_end_0], [%tmp3, %logic_rhs_1]
	ret i1 %tmp4
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
	%tmp0 = call i32 @fs.create_file(i8* @.str.65)
	%tmp1 = icmp eq i32 %tmp0, 1
	br i1 %tmp1, label %then0, label %endif0
then0:
	call i32 @fs.delete_file(i8* @.str.65)
	br label %func_exit
endif0:
	%tmp2 = call %struct.string.String @fs.read_full_file_as_string(i8* @.str.65)
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
	%tmp44 = call i1 @char_utils.is_digit(i8 %tmp43)
	br i1 %tmp44, label %then10, label %endif10
then10:
	%tmp45 = load i32, i32* %v6
	store i32 %tmp45, i32* %v3
	%tmp46 = load i8, i8* %v2
	%tmp47 = icmp eq i8 %tmp46, 120
	br i1 %tmp47, label %logic_end_11, label %logic_rhs_11
logic_rhs_11:
	%tmp48 = load i8, i8* %v2
	%tmp49 = icmp eq i8 %tmp48, 98
	br label %logic_end_11
logic_end_11:
	%tmp50 = phi i1 [%tmp47, %then10], [%tmp49, %logic_rhs_11]
	br i1 %tmp50, label %then12, label %endif12
then12:
	%tmp51 = load i32, i32* %v6
	%tmp52 = add i32 %tmp51, 2
	store i32 %tmp52, i32* %v6
	br label %endif12
endif12:
	call void @tests.consume_while(%struct.string.String* %v0, i32* %v6, i1 (i8)* @tests.is_valid_number_token)
	%tmp53 = load i32, i32* %v6
	%tmp54 = load i32, i32* %v3
	%tmp55 = sub i32 %tmp53, %tmp54
	%tmp56 = call %struct.string.String @string.with_size(i32 %tmp55)
	store %struct.string.String %tmp56, %struct.string.String* %v7
	%tmp57 = load i8*, i8** %v0
	%tmp58 = load i32, i32* %v3
	%tmp59 = getelementptr inbounds i8, i8* %tmp57, i32 %tmp58
	%tmp60 = load i8*, i8** %v7
	%tmp61 = getelementptr inbounds %struct.string.String, %struct.string.String* %v7, i32 0, i32 1
	%tmp62 = load i32, i32* %tmp61
	%tmp63 = sext i32 %tmp62 to i64
	call void @mem.copy(i8* %tmp59, i8* %tmp60, i64 %tmp63)
	%tmp64 = load %struct.string.String, %struct.string.String* %v7
	call void @"vector.push<%struct.string.String>"(%"struct.vector.Vec<%struct.string.String>"* %v4, %struct.string.String %tmp64)
	br label %loop_body1
; Variable temp_string is out.
endif10:
	%tmp65 = load i8, i8* %v1
	%tmp66 = call i1 @char_utils.is_alpha(i8 %tmp65)
	br i1 %tmp66, label %logic_end_13, label %logic_rhs_13
logic_rhs_13:
	%tmp67 = load i8, i8* %v1
	%tmp68 = icmp eq i8 %tmp67, 95
	br label %logic_end_13
logic_end_13:
	%tmp69 = phi i1 [%tmp66, %endif10], [%tmp68, %logic_rhs_13]
	br i1 %tmp69, label %then14, label %endif14
then14:
	%tmp70 = load i32, i32* %v6
	store i32 %tmp70, i32* %v3
	call void @tests.consume_while(%struct.string.String* %v0, i32* %v6, i1 (i8)* @tests.valid_name_token)
	%tmp71 = load i32, i32* %v6
	%tmp72 = load i32, i32* %v3
	%tmp73 = sub i32 %tmp71, %tmp72
	%tmp74 = call %struct.string.String @string.with_size(i32 %tmp73)
	store %struct.string.String %tmp74, %struct.string.String* %v8
	%tmp75 = load i8*, i8** %v0
	%tmp76 = load i32, i32* %v3
	%tmp77 = getelementptr inbounds i8, i8* %tmp75, i32 %tmp76
	%tmp78 = load i8*, i8** %v8
	%tmp79 = getelementptr inbounds %struct.string.String, %struct.string.String* %v8, i32 0, i32 1
	%tmp80 = load i32, i32* %tmp79
	%tmp81 = sext i32 %tmp80 to i64
	call void @mem.copy(i8* %tmp77, i8* %tmp78, i64 %tmp81)
	%tmp82 = load %struct.string.String, %struct.string.String* %v8
	call void @"vector.push<%struct.string.String>"(%"struct.vector.Vec<%struct.string.String>"* %v4, %struct.string.String %tmp82)
	br label %loop_body1
; Variable temp_string is out.
endif14:
	%tmp83 = load i8, i8* %v1
	%tmp84 = icmp eq i8 %tmp83, 34
	br i1 %tmp84, label %then15, label %endif15
then15:
	%tmp85 = load i32, i32* %v6
	store i32 %tmp85, i32* %v3
	br label %loop_start16
loop_start16:
	%tmp86 = load i32, i32* %v6
	%tmp87 = add i32 %tmp86, 1
	store i32 %tmp87, i32* %v6
	%tmp88 = load i32, i32* %v6
	%tmp89 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	%tmp90 = load i32, i32* %tmp89
	%tmp91 = icmp sge i32 %tmp88, %tmp90
	br i1 %tmp91, label %then17, label %endif17
then17:
	br label %loop_body16_exit
endif17:
	%tmp92 = load i32, i32* %v6
	%tmp93 = load i8*, i8** %v0
	%tmp94 = getelementptr inbounds i8, i8* %tmp93, i32 %tmp92
	%tmp95 = load i8, i8* %tmp94
	%tmp96 = icmp eq i8 %tmp95, 34
	br i1 %tmp96, label %then18, label %endif18
then18:
	%tmp97 = load i32, i32* %v6
	%tmp98 = add i32 %tmp97, 1
	store i32 %tmp98, i32* %v6
	br label %loop_body16_exit
endif18:
	br label %loop_start16
loop_body16_exit:
	%tmp99 = load i32, i32* %v6
	%tmp100 = load i32, i32* %v3
	%tmp101 = sub i32 %tmp99, %tmp100
	%tmp102 = call %struct.string.String @string.with_size(i32 %tmp101)
	store %struct.string.String %tmp102, %struct.string.String* %v9
	%tmp103 = load i8*, i8** %v0
	%tmp104 = load i32, i32* %v3
	%tmp105 = getelementptr inbounds i8, i8* %tmp103, i32 %tmp104
	%tmp106 = load i8*, i8** %v9
	%tmp107 = getelementptr inbounds %struct.string.String, %struct.string.String* %v9, i32 0, i32 1
	%tmp108 = load i32, i32* %tmp107
	%tmp109 = sext i32 %tmp108 to i64
	call void @mem.copy(i8* %tmp105, i8* %tmp106, i64 %tmp109)
	%tmp110 = load %struct.string.String, %struct.string.String* %v9
	call void @"vector.push<%struct.string.String>"(%"struct.vector.Vec<%struct.string.String>"* %v4, %struct.string.String %tmp110)
	br label %loop_body1
; Variable temp_string is out.
endif15:
	%tmp111 = load i8, i8* %v1
	%tmp112 = icmp eq i8 %tmp111, 39
	br i1 %tmp112, label %then19, label %endif19
then19:
	%tmp113 = load i32, i32* %v6
	%tmp114 = add i32 %tmp113, 1
	store i32 %tmp114, i32* %v6
	br label %loop_body1
endif19:
	%tmp115 = load i8, i8* %v1
	%tmp116 = icmp eq i8 %tmp115, 40
	br i1 %tmp116, label %then20, label %endif20
then20:
	%tmp117 = load i32, i32* %v6
	%tmp118 = add i32 %tmp117, 1
	store i32 %tmp118, i32* %v6
	br label %loop_body1
endif20:
	%tmp119 = load i8, i8* %v1
	%tmp120 = icmp eq i8 %tmp119, 41
	br i1 %tmp120, label %then21, label %endif21
then21:
	%tmp121 = load i32, i32* %v6
	%tmp122 = add i32 %tmp121, 1
	store i32 %tmp122, i32* %v6
	br label %loop_body1
endif21:
	%tmp123 = load i8, i8* %v1
	%tmp124 = icmp eq i8 %tmp123, 123
	br i1 %tmp124, label %then22, label %endif22
then22:
	%tmp125 = load i32, i32* %v6
	%tmp126 = add i32 %tmp125, 1
	store i32 %tmp126, i32* %v6
	br label %loop_body1
endif22:
	%tmp127 = load i8, i8* %v1
	%tmp128 = icmp eq i8 %tmp127, 125
	br i1 %tmp128, label %then23, label %endif23
then23:
	%tmp129 = load i32, i32* %v6
	%tmp130 = add i32 %tmp129, 1
	store i32 %tmp130, i32* %v6
	br label %loop_body1
endif23:
	%tmp131 = load i8, i8* %v1
	%tmp132 = icmp eq i8 %tmp131, 91
	br i1 %tmp132, label %then24, label %endif24
then24:
	%tmp133 = load i32, i32* %v6
	%tmp134 = add i32 %tmp133, 1
	store i32 %tmp134, i32* %v6
	br label %loop_body1
endif24:
	%tmp135 = load i8, i8* %v1
	%tmp136 = icmp eq i8 %tmp135, 93
	br i1 %tmp136, label %then25, label %endif25
then25:
	%tmp137 = load i32, i32* %v6
	%tmp138 = add i32 %tmp137, 1
	store i32 %tmp138, i32* %v6
	br label %loop_body1
endif25:
	%tmp139 = load i8, i8* %v1
	%tmp140 = icmp eq i8 %tmp139, 61
	br i1 %tmp140, label %then26, label %endif26
then26:
	%tmp141 = load i8, i8* %v2
	%tmp142 = icmp eq i8 %tmp141, 61
	br i1 %tmp142, label %then27, label %endif27
then27:
	%tmp143 = load i32, i32* %v6
	%tmp144 = add i32 %tmp143, 2
	store i32 %tmp144, i32* %v6
	br label %loop_body1
endif27:
	%tmp145 = load i32, i32* %v6
	%tmp146 = add i32 %tmp145, 1
	store i32 %tmp146, i32* %v6
	br label %loop_body1
endif26:
	%tmp147 = load i8, i8* %v1
	%tmp148 = icmp eq i8 %tmp147, 58
	br i1 %tmp148, label %then28, label %endif28
then28:
	%tmp149 = load i8, i8* %v2
	%tmp150 = icmp eq i8 %tmp149, 58
	br i1 %tmp150, label %then29, label %endif29
then29:
	%tmp151 = load i32, i32* %v6
	%tmp152 = add i32 %tmp151, 2
	store i32 %tmp152, i32* %v6
	br label %loop_body1
endif29:
	%tmp153 = load i32, i32* %v6
	%tmp154 = add i32 %tmp153, 1
	store i32 %tmp154, i32* %v6
	br label %loop_body1
endif28:
	%tmp155 = load i8, i8* %v1
	%tmp156 = icmp eq i8 %tmp155, 124
	br i1 %tmp156, label %then30, label %endif30
then30:
	%tmp157 = load i8, i8* %v2
	%tmp158 = icmp eq i8 %tmp157, 124
	br i1 %tmp158, label %then31, label %endif31
then31:
	%tmp159 = load i32, i32* %v6
	%tmp160 = add i32 %tmp159, 2
	store i32 %tmp160, i32* %v6
	br label %loop_body1
endif31:
	%tmp161 = load i32, i32* %v6
	%tmp162 = add i32 %tmp161, 1
	store i32 %tmp162, i32* %v6
	br label %loop_body1
endif30:
	%tmp163 = load i8, i8* %v1
	%tmp164 = icmp eq i8 %tmp163, 38
	br i1 %tmp164, label %then32, label %endif32
then32:
	%tmp165 = load i8, i8* %v2
	%tmp166 = icmp eq i8 %tmp165, 38
	br i1 %tmp166, label %then33, label %endif33
then33:
	%tmp167 = load i32, i32* %v6
	%tmp168 = add i32 %tmp167, 2
	store i32 %tmp168, i32* %v6
	br label %loop_body1
endif33:
	%tmp169 = load i32, i32* %v6
	%tmp170 = add i32 %tmp169, 1
	store i32 %tmp170, i32* %v6
	br label %loop_body1
endif32:
	%tmp171 = load i8, i8* %v1
	%tmp172 = icmp eq i8 %tmp171, 62
	br i1 %tmp172, label %then34, label %endif34
then34:
	%tmp173 = load i8, i8* %v2
	%tmp174 = icmp eq i8 %tmp173, 61
	br i1 %tmp174, label %then35, label %endif35
then35:
	%tmp175 = load i32, i32* %v6
	%tmp176 = add i32 %tmp175, 2
	store i32 %tmp176, i32* %v6
	br label %loop_body1
endif35:
	%tmp177 = load i32, i32* %v6
	%tmp178 = add i32 %tmp177, 1
	store i32 %tmp178, i32* %v6
	br label %loop_body1
endif34:
	%tmp179 = load i8, i8* %v1
	%tmp180 = icmp eq i8 %tmp179, 60
	br i1 %tmp180, label %then36, label %endif36
then36:
	%tmp181 = load i8, i8* %v2
	%tmp182 = icmp eq i8 %tmp181, 61
	br i1 %tmp182, label %then37, label %endif37
then37:
	%tmp183 = load i32, i32* %v6
	%tmp184 = add i32 %tmp183, 2
	store i32 %tmp184, i32* %v6
	br label %loop_body1
endif37:
	%tmp185 = load i32, i32* %v6
	%tmp186 = add i32 %tmp185, 1
	store i32 %tmp186, i32* %v6
	br label %loop_body1
endif36:
	%tmp187 = load i8, i8* %v1
	%tmp188 = icmp eq i8 %tmp187, 35
	br i1 %tmp188, label %then38, label %endif38
then38:
	%tmp189 = load i32, i32* %v6
	%tmp190 = add i32 %tmp189, 1
	store i32 %tmp190, i32* %v6
	br label %loop_body1
endif38:
	%tmp191 = load i8, i8* %v1
	%tmp192 = icmp eq i8 %tmp191, 59
	br i1 %tmp192, label %then39, label %endif39
then39:
	%tmp193 = load i32, i32* %v6
	%tmp194 = add i32 %tmp193, 1
	store i32 %tmp194, i32* %v6
	br label %loop_body1
endif39:
	%tmp195 = load i8, i8* %v1
	%tmp196 = icmp eq i8 %tmp195, 46
	br i1 %tmp196, label %then40, label %endif40
then40:
	%tmp197 = load i32, i32* %v6
	%tmp198 = add i32 %tmp197, 1
	store i32 %tmp198, i32* %v6
	br label %loop_body1
endif40:
	%tmp199 = load i8, i8* %v1
	%tmp200 = icmp eq i8 %tmp199, 44
	br i1 %tmp200, label %then41, label %endif41
then41:
	%tmp201 = load i32, i32* %v6
	%tmp202 = add i32 %tmp201, 1
	store i32 %tmp202, i32* %v6
	br label %loop_body1
endif41:
	%tmp203 = load i8, i8* %v1
	%tmp204 = icmp eq i8 %tmp203, 43
	br i1 %tmp204, label %then42, label %endif42
then42:
	%tmp205 = load i32, i32* %v6
	%tmp206 = add i32 %tmp205, 1
	store i32 %tmp206, i32* %v6
	br label %loop_body1
endif42:
	%tmp207 = load i8, i8* %v1
	%tmp208 = icmp eq i8 %tmp207, 45
	br i1 %tmp208, label %then43, label %endif43
then43:
	%tmp209 = load i32, i32* %v6
	%tmp210 = add i32 %tmp209, 1
	store i32 %tmp210, i32* %v6
	br label %loop_body1
endif43:
	%tmp211 = load i8, i8* %v1
	%tmp212 = icmp eq i8 %tmp211, 42
	br i1 %tmp212, label %then44, label %endif44
then44:
	%tmp213 = load i32, i32* %v6
	%tmp214 = add i32 %tmp213, 1
	store i32 %tmp214, i32* %v6
	br label %loop_body1
endif44:
	%tmp215 = load i8, i8* %v1
	%tmp216 = icmp eq i8 %tmp215, 47
	br i1 %tmp216, label %then45, label %endif45
then45:
	%tmp217 = load i32, i32* %v6
	%tmp218 = add i32 %tmp217, 1
	store i32 %tmp218, i32* %v6
	br label %loop_body1
endif45:
	%tmp219 = load i8, i8* %v1
	%tmp220 = icmp eq i8 %tmp219, 37
	br i1 %tmp220, label %then46, label %endif46
then46:
	%tmp221 = load i32, i32* %v6
	%tmp222 = add i32 %tmp221, 1
	store i32 %tmp222, i32* %v6
	br label %loop_body1
endif46:
	%tmp223 = load i8, i8* %v1
	%tmp224 = icmp eq i8 %tmp223, 33
	br i1 %tmp224, label %then47, label %endif47
then47:
	%tmp225 = load i32, i32* %v6
	%tmp226 = add i32 %tmp225, 1
	store i32 %tmp226, i32* %v6
	br label %loop_body1
endif47:
	%tmp227 = load i8, i8* %v1
	%tmp228 = icmp eq i8 %tmp227, 126
	br i1 %tmp228, label %then48, label %endif48
then48:
	%tmp229 = load i32, i32* %v6
	%tmp230 = add i32 %tmp229, 1
	store i32 %tmp230, i32* %v6
	br label %loop_body1
endif48:
	%tmp231 = load i8, i8* %v1
	%tmp232 = icmp eq i8 %tmp231, 92
	br i1 %tmp232, label %then49, label %endif49
then49:
	%tmp233 = load i32, i32* %v6
	%tmp234 = add i32 %tmp233, 1
	store i32 %tmp234, i32* %v6
	br label %loop_body1
endif49:
	%tmp235 = load i8, i8* %v1
	call void @console.print_char(i8 %tmp235)
	call void @console.print_char(i8 10)
	%tmp236 = load i32, i32* %v6
	%tmp237 = add i32 %tmp236, 1
	store i32 %tmp237, i32* %v6
	br label %loop_body1
loop_body1:
	%tmp238 = load i32, i32* %v6
	%tmp239 = add i32 %tmp238, 1
	store i32 %tmp239, i32* %v6
	br label %loop_cond1
loop_body1_exit:
	%tmp240 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %v4, i32 0, i32 1
	%tmp241 = load i32, i32* %tmp240
	store i32 0, i32* %v10
	br label %loop_cond50
loop_cond50:
	%tmp242 = load i32, i32* %v10
	%tmp243 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %v4, i32 0, i32 1
	%tmp244 = load i32, i32* %tmp243
	%tmp245 = icmp uge i32 %tmp242, %tmp244
	br i1 %tmp245, label %then51, label %endif51
then51:
	br label %loop_body50_exit
endif51:
	%tmp246 = load i32, i32* %v10
	%tmp247 = load %struct.string.String*, %struct.string.String** %v4
	%tmp248 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp247, i32 %tmp246
	call void @string.free(%struct.string.String* %tmp248)
	%tmp249 = load i32, i32* %v10
	%tmp250 = add i32 %tmp249, 1
	store i32 %tmp250, i32* %v10
	%tmp251 = load i32, i32* %v10
	%tmp252 = add i32 %tmp251, 1
	store i32 %tmp252, i32* %v10
	br label %loop_cond50
loop_body50_exit:
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
	call void @console.write(i8* @.str.66, i32 9)
	%tmp0 = call %struct.string.String @string.from_c_string(i8* @.str.67)
	store %struct.string.String %tmp0, %struct.string.String* %v0
	%tmp1 = call %struct.string.String @process.get_executable_env_path()
	store %struct.string.String %tmp1, %struct.string.String* %v1
	%tmp2 = call %struct.string.String @string.concat_with_c_string(%struct.string.String* %v1, i8* @.str.68)
	store %struct.string.String %tmp2, %struct.string.String* %v2
	%tmp3 = getelementptr inbounds %struct.string.String, %struct.string.String* %v2, i32 0, i32 1
	%tmp4 = load i32, i32* %tmp3
	%tmp5 = add i32 %tmp4, 1
	%tmp6 = sext i32 %tmp5 to i64
	%tmp7 = alloca i8, i64 %tmp6
	%tmp8 = load i8*, i8** %v2
	%tmp9 = getelementptr inbounds %struct.string.String, %struct.string.String* %v2, i32 0, i32 1
	%tmp10 = load i32, i32* %tmp9
	%tmp11 = sext i32 %tmp10 to i64
	call void @mem.copy(i8* %tmp8, i8* %tmp7, i64 %tmp11)
	%tmp12 = getelementptr inbounds %struct.string.String, %struct.string.String* %v2, i32 0, i32 1
	%tmp13 = load i32, i32* %tmp12
	%tmp14 = getelementptr inbounds i8, i8* %tmp7, i32 %tmp13
	store i8 0, i8* %tmp14
	call i32 @fs.create_file(i8* %tmp7)
	call i32 @fs.delete_file(i8* %tmp7)
	call i32 @fs.create_file(i8* %tmp7)
	%tmp15 = load i8*, i8** %v0
	%tmp16 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	%tmp17 = load i32, i32* %tmp16
	call i32 @fs.write_to_file(i8* %tmp7, i8* %tmp15, i32 %tmp17)
	%tmp18 = call %struct.string.String @fs.read_full_file_as_string(i8* %tmp7)
	store %struct.string.String %tmp18, %struct.string.String* %v3
	%tmp19 = call i1 @string.equal(%struct.string.String* %v0, %struct.string.String* %v3)
	%tmp20 = xor i1 1, %tmp19
	br i1 %tmp20, label %then1, label %endif1
then1:
	call void @process.throw(i8* @.str.69)
	br label %endif1
endif1:
	call i32 @fs.delete_file(i8* %tmp7)
	call void @string.free(%struct.string.String* %v3)
	call void @string.free(%struct.string.String* %v2)
	call void @string.free(%struct.string.String* %v1)
	call void @string.free(%struct.string.String* %v0)
	call void @console.writeln(i8* @.str.19, i32 2)
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
	call void @console.writeln(i8* @.str.70, i32 14)
	call void @console.writeln(i8* @.str.71, i32 25)
	call void @console.write(i8* @.str.72, i32 21)
	call void @console.println_i64(i64 12345)
	call void @console.write(i8* @.str.73, i32 22)
	call void @console.println_i64(i64 -67890)
	call void @console.write(i8* @.str.74, i32 17)
	call void @console.println_i64(i64 0)
	call void @console.write(i8* @.str.75, i32 26)
	call void @console.println_u64(i64 9876543210)
	call void @console.writeln(i8* @.str.76, i32 23)
	call void @console.writeln(i8* @.str.19, i32 2)
	ret void
}
define %"struct.test.QPair<i64, i64>" @test.geg(){
	%v0 = alloca %"struct.test.QPair<i64, i64>"
	store i64 1337, i64* %v0
	%tmp0 = getelementptr inbounds %"struct.test.QPair<i64, i64>", %"struct.test.QPair<i64, i64>"* %v0, i32 0, i32 1
	store i64 1226, i64* %tmp0
	%tmp1 = load i64, i64* %v0
	%tmp2 = getelementptr inbounds %"struct.test.QPair<i64, i64>", %"struct.test.QPair<i64, i64>"* %v0, i32 0, i32 1
	%tmp3 = load i64, i64* %tmp2
	%tmp4 = sub i64 %tmp1, %tmp3
	store i64 %tmp4, i64* %v0
	%tmp5 = load %"struct.test.QPair<i64, i64>", %"struct.test.QPair<i64, i64>"* %v0
; Variable temp is out.
	ret %"struct.test.QPair<i64, i64>" %tmp5
}
define i8* @string_utils.insert(i8* %src1, i8* %src2, i32 %index){
	%tmp0 = call i32 @string_utils.c_str_len(i8* %src1)
	%tmp1 = call i32 @string_utils.c_str_len(i8* %src2)
	%tmp2 = add i32 %tmp0, %tmp1
	%tmp3 = add i32 %tmp2, 1
	%tmp4 = sext i32 %tmp3 to i64
	%tmp5 = call i8* @mem.malloc(i64 %tmp4)
	%tmp6 = bitcast i8* %tmp5 to i8*
	%tmp7 = sext i32 %index to i64
	call void @mem.copy(i8* %src1, i8* %tmp6, i64 %tmp7)
	%tmp8 = getelementptr inbounds i8, i8* %tmp6, i32 %index
	%tmp9 = sext i32 %tmp1 to i64
	call void @mem.copy(i8* %src2, i8* %tmp8, i64 %tmp9)
	%tmp10 = getelementptr inbounds i8, i8* %src1, i32 %index
	%tmp11 = getelementptr inbounds i8, i8* %tmp6, i32 %index
	%tmp12 = getelementptr inbounds i8, i8* %tmp11, i32 %tmp1
	%tmp13 = sub i32 %tmp0, %index
	%tmp14 = sext i32 %tmp13 to i64
	call void @mem.copy(i8* %tmp10, i8* %tmp12, i64 %tmp14)
	%tmp15 = add i32 %tmp0, %tmp1
	%tmp16 = getelementptr inbounds i8, i8* %tmp6, i32 %tmp15
	store i8 0, i8* %tmp16
	ret i8* %tmp6
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
	%tmp0 = add i32 %size, 1
	%tmp1 = sext i32 %tmp0 to i64
	%tmp2 = mul i64 1, %tmp1
	%tmp3 = call i8* @mem.malloc(i64 %tmp2)
	%tmp4 = bitcast i8* %tmp3 to i8*
	store i8* %tmp4, i8** %v0
	%tmp5 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	store i32 %size, i32* %tmp5
	%tmp6 = load i8*, i8** %v0
	%tmp7 = add i32 %size, 1
	%tmp8 = sext i32 %tmp7 to i64
	call void @mem.zero_fill(i8* %tmp6, i64 %tmp8)
	%tmp9 = load %struct.string.String, %struct.string.String* %v0
; Variable x is out.
	ret %struct.string.String %tmp9
}
define %struct.string.String @string.from_c_string(i8* %c_string){
	%v0 = alloca %struct.string.String
	%tmp0 = call i32 @string_utils.c_str_len(i8* %c_string)
	%tmp1 = add i32 %tmp0, 1
	%tmp2 = sext i32 %tmp1 to i64
	%tmp3 = mul i64 1, %tmp2
	%tmp4 = call i8* @mem.malloc(i64 %tmp3)
	%tmp5 = bitcast i8* %tmp4 to i8*
	store i8* %tmp5, i8** %v0
	%tmp6 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	store i32 %tmp0, i32* %tmp6
	%tmp7 = load i8*, i8** %v0
	%tmp8 = sext i32 %tmp0 to i64
	call void @mem.copy(i8* %c_string, i8* %tmp7, i64 %tmp8)
	%tmp9 = load i8*, i8** %v0
	%tmp10 = getelementptr inbounds i8, i8* %tmp9, i32 %tmp0
	store i8 0, i8* %tmp10
	%tmp11 = load %struct.string.String, %struct.string.String* %v0
; Variable x is out.
	ret %struct.string.String %tmp11
}
define void @string.free(%struct.string.String* %str){
	%tmp0 = load i8*, i8** %str
	call void @mem.free(i8* %tmp0)
	%tmp1 = getelementptr inbounds %struct.string.String, %struct.string.String* %str, i32 0, i32 1
	store i32 0, i32* %tmp1
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
	%tmp5 = load i8*, i8** %first
	%tmp6 = load i8*, i8** %second
	%tmp7 = getelementptr inbounds %struct.string.String, %struct.string.String* %first, i32 0, i32 1
	%tmp8 = load i32, i32* %tmp7
	%tmp9 = sext i32 %tmp8 to i64
	%tmp10 = call i32 @mem.compare(i8* %tmp5, i8* %tmp6, i64 %tmp9)
	%tmp11 = icmp eq i32 %tmp10, 0
	br label %func_exit
func_exit:
	%tmp12 = phi i1 [false, %then0], [%tmp11, %endif0]
	ret i1 %tmp12
}
define %struct.string.String @string.empty(){
	%v0 = alloca %struct.string.String
	store i8* null, i8** %v0
	%tmp0 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	store i32 0, i32* %tmp0
	%tmp1 = load %struct.string.String, %struct.string.String* %v0
; Variable x is out.
	ret %struct.string.String %tmp1
}
define %struct.string.String @string.concat_with_c_string(%struct.string.String* %src_string, i8* %c_string){
	%v0 = alloca %struct.string.String
	%tmp0 = call i32 @string_utils.c_str_len(i8* %c_string)
	%tmp1 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 1
	%tmp2 = load i32, i32* %tmp1
	%tmp3 = add i32 %tmp0, %tmp2
	%tmp4 = add i32 %tmp3, 1
	%tmp5 = sext i32 %tmp4 to i64
	%tmp6 = mul i64 1, %tmp5
	%tmp7 = call i8* @mem.malloc(i64 %tmp6)
	%tmp8 = bitcast i8* %tmp7 to i8*
	%tmp9 = load i8*, i8** %src_string
	%tmp10 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 1
	%tmp11 = load i32, i32* %tmp10
	%tmp12 = sext i32 %tmp11 to i64
	call void @mem.copy(i8* %tmp9, i8* %tmp8, i64 %tmp12)
	%tmp13 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 1
	%tmp14 = load i32, i32* %tmp13
	%tmp15 = sext i32 %tmp14 to i64
	%tmp16 = getelementptr inbounds i8, i8* %tmp8, i64 %tmp15
	%tmp17 = sext i32 %tmp0 to i64
	call void @mem.copy(i8* %c_string, i8* %tmp16, i64 %tmp17)
	%tmp18 = getelementptr inbounds i8, i8* %tmp8, i32 %tmp3
	store i8 0, i8* %tmp18
	store i8* %tmp8, i8** %v0
	%tmp19 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	store i32 %tmp3, i32* %tmp19
	%tmp20 = load %struct.string.String, %struct.string.String* %v0
; Variable str is out.
	ret %struct.string.String %tmp20
}
define %struct.string.String @string.clone(%struct.string.String* %src){
	%v0 = alloca %struct.string.String
	%tmp0 = getelementptr inbounds %struct.string.String, %struct.string.String* %src, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = getelementptr inbounds %struct.string.String, %struct.string.String* %src, i32 0, i32 1
	%tmp3 = load i32, i32* %tmp2
	%tmp4 = add i32 %tmp1, 1
	%tmp5 = sext i32 %tmp4 to i64
	%tmp6 = mul i64 1, %tmp5
	%tmp7 = call i8* @mem.malloc(i64 %tmp6)
	%tmp8 = bitcast i8* %tmp7 to i8*
	store i8* %tmp8, i8** %v0
	%tmp9 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	store i32 %tmp3, i32* %tmp9
	%tmp10 = load i8*, i8** %src
	%tmp11 = load i8*, i8** %v0
	%tmp12 = sext i32 %tmp1 to i64
	call void @mem.copy(i8* %tmp10, i8* %tmp11, i64 %tmp12)
	%tmp13 = load i8*, i8** %v0
	%tmp14 = getelementptr inbounds i8, i8* %tmp13, i32 %tmp1
	store i8 0, i8* %tmp14
	%tmp15 = load %struct.string.String, %struct.string.String* %v0
; Variable x is out.
	ret %struct.string.String %tmp15
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
	%tmp3 = call i1 @char_utils.is_space(i8 %tmp2)
	br i1 %tmp3, label %endif1, label %else1
else1:
	br label %loop_body0_exit
endif1:
	%tmp4 = load i32, i32* %v0
	%tmp5 = add i32 %tmp4, 1
	store i32 %tmp5, i32* %v0
	br label %loop_start0
loop_body0_exit:
	store i64 1, i64* %v1
	%tmp6 = load i32, i32* %v0
	%tmp7 = getelementptr inbounds i8, i8* %str, i32 %tmp6
	%tmp8 = load i8, i8* %tmp7
	%tmp9 = icmp eq i8 %tmp8, 43
	br i1 %tmp9, label %then2, label %else2
then2:
	%tmp10 = load i32, i32* %v0
	%tmp11 = add i32 %tmp10, 1
	store i32 %tmp11, i32* %v0
	br label %endif2
else2:
	%tmp12 = load i32, i32* %v0
	%tmp13 = getelementptr inbounds i8, i8* %str, i32 %tmp12
	%tmp14 = load i8, i8* %tmp13
	%tmp15 = icmp eq i8 %tmp14, 45
	br i1 %tmp15, label %then3, label %endif3
then3:
	store i64 -1, i64* %v1
	%tmp16 = load i32, i32* %v0
	%tmp17 = add i32 %tmp16, 1
	store i32 %tmp17, i32* %v0
	br label %endif3
endif3:
	br label %endif2
endif2:
	store i32 %base, i32* %v2
	%tmp18 = load i32, i32* %v2
	%tmp19 = icmp eq i32 %tmp18, 0
	br i1 %tmp19, label %then4, label %endif4
then4:
	%tmp20 = load i32, i32* %v0
	%tmp21 = getelementptr inbounds i8, i8* %str, i32 %tmp20
	%tmp22 = load i8, i8* %tmp21
	%tmp23 = icmp eq i8 %tmp22, 48
	br i1 %tmp23, label %then5, label %else5
then5:
	%tmp24 = load i32, i32* %v0
	%tmp25 = add i32 %tmp24, 1
	%tmp26 = getelementptr inbounds i8, i8* %str, i32 %tmp25
	%tmp27 = load i8, i8* %tmp26
	%tmp28 = call i8 @char_utils.to_lower(i8 %tmp27)
	%tmp29 = icmp eq i8 %tmp28, 120
	br i1 %tmp29, label %then6, label %else6
then6:
	store i32 16, i32* %v2
	br label %endif6
else6:
	store i32 8, i32* %v2
	br label %endif6
endif6:
	br label %endif5
else5:
	store i32 10, i32* %v2
	br label %endif5
endif5:
	br label %endif4
endif4:
	%tmp30 = load i32, i32* %v2
	%tmp31 = icmp eq i32 %tmp30, 16
	br i1 %tmp31, label %logic_rhs_7, label %logic_end_7
logic_rhs_7:
	%tmp32 = load i32, i32* %v0
	%tmp33 = getelementptr inbounds i8, i8* %str, i32 %tmp32
	%tmp34 = load i8, i8* %tmp33
	%tmp35 = icmp eq i8 %tmp34, 48
	br label %logic_end_7
logic_end_7:
	%tmp36 = phi i1 [%tmp31, %endif4], [%tmp35, %logic_rhs_7]
	br i1 %tmp36, label %logic_rhs_8, label %logic_end_8
logic_rhs_8:
	%tmp37 = load i32, i32* %v0
	%tmp38 = add i32 %tmp37, 1
	%tmp39 = getelementptr inbounds i8, i8* %str, i32 %tmp38
	%tmp40 = load i8, i8* %tmp39
	%tmp41 = call i8 @char_utils.to_lower(i8 %tmp40)
	%tmp42 = icmp eq i8 %tmp41, 120
	br label %logic_end_8
logic_end_8:
	%tmp43 = phi i1 [%tmp36, %logic_end_7], [%tmp42, %logic_rhs_8]
	br i1 %tmp43, label %then9, label %endif9
then9:
	%tmp44 = load i32, i32* %v0
	%tmp45 = add i32 %tmp44, 2
	store i32 %tmp45, i32* %v0
	br label %endif9
endif9:
	store i64 0, i64* %v3
	br label %loop_start10
loop_start10:
	%tmp46 = load i32, i32* %v0
	%tmp47 = getelementptr inbounds i8, i8* %str, i32 %tmp46
	%tmp48 = load i8, i8* %tmp47
	%tmp49 = call i1 @char_utils.is_digit(i8 %tmp48)
	br i1 %tmp49, label %then11, label %else11
then11:
	%tmp50 = sub i8 %tmp48, 48
	%tmp51 = sext i8 %tmp50 to i32
	store i32 %tmp51, i32* %v4
	br label %endif11
else11:
	%tmp52 = call i1 @char_utils.is_alpha(i8 %tmp48)
	br i1 %tmp52, label %then12, label %else12
then12:
	%tmp53 = call i8 @char_utils.to_lower(i8 %tmp48)
	%tmp54 = sub i8 %tmp53, 97
	%tmp55 = add i8 %tmp54, 10
	%tmp56 = sext i8 %tmp55 to i32
	store i32 %tmp56, i32* %v4
	br label %endif12
else12:
	br label %loop_body10_exit
endif12:
	br label %endif11
endif11:
	%tmp57 = load i32, i32* %v4
	%tmp58 = load i32, i32* %v2
	%tmp59 = icmp sge i32 %tmp57, %tmp58
	br i1 %tmp59, label %then13, label %endif13
then13:
	br label %loop_body10_exit
endif13:
	%tmp60 = load i64, i64* %v3
	%tmp61 = load i32, i32* %v2
	%tmp62 = sext i32 %tmp61 to i64
	%tmp63 = mul i64 %tmp60, %tmp62
	%tmp64 = load i32, i32* %v4
	%tmp65 = sext i32 %tmp64 to i64
	%tmp66 = add i64 %tmp63, %tmp65
	store i64 %tmp66, i64* %v3
	%tmp67 = load i32, i32* %v0
	%tmp68 = add i32 %tmp67, 1
	store i32 %tmp68, i32* %v0
	br label %loop_start10
loop_body10_exit:
	%tmp69 = icmp ne ptr %endptr, null
	br i1 %tmp69, label %then14, label %endif14
then14:
	%tmp70 = load i32, i32* %v0
	%tmp71 = sext i32 %tmp70 to i64
	%tmp72 = getelementptr inbounds i8, i8* %str, i64 %tmp71
	store i8* %tmp72, i8** %endptr
	br label %endif14
endif14:
	%tmp73 = load i64, i64* %v3
	%tmp74 = load i64, i64* %v1
	%tmp75 = mul i64 %tmp73, %tmp74
	ret i64 %tmp75
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
	%tmp3 = call i1 @char_utils.is_space(i8 %tmp2)
	br i1 %tmp3, label %endif1, label %else1
else1:
	br label %loop_body0_exit
endif1:
	%tmp4 = load i32, i32* %v2
	%tmp5 = add i32 %tmp4, 1
	store i32 %tmp5, i32* %v2
	br label %loop_start0
loop_body0_exit:
	%tmp6 = load i32, i32* %v2
	%tmp7 = getelementptr inbounds i8, i8* %str, i32 %tmp6
	%tmp8 = load i8, i8* %tmp7
	%tmp9 = icmp eq i8 %tmp8, 45
	br i1 %tmp9, label %then2, label %else2
then2:
	store i32 -1, i32* %v1
	%tmp10 = load i32, i32* %v2
	%tmp11 = add i32 %tmp10, 1
	store i32 %tmp11, i32* %v2
	br label %endif2
else2:
	%tmp12 = load i32, i32* %v2
	%tmp13 = getelementptr inbounds i8, i8* %str, i32 %tmp12
	%tmp14 = load i8, i8* %tmp13
	%tmp15 = icmp eq i8 %tmp14, 43
	br i1 %tmp15, label %then3, label %endif3
then3:
	%tmp16 = load i32, i32* %v2
	%tmp17 = add i32 %tmp16, 1
	store i32 %tmp17, i32* %v2
	br label %endif3
endif3:
	br label %endif2
endif2:
	br label %loop_start4
loop_start4:
	%tmp18 = load i32, i32* %v2
	%tmp19 = getelementptr inbounds i8, i8* %str, i32 %tmp18
	%tmp20 = load i8, i8* %tmp19
	%tmp21 = call i1 @char_utils.is_digit(i8 %tmp20)
	br i1 %tmp21, label %endif5, label %else5
else5:
	br label %loop_body4_exit
endif5:
	%tmp22 = load i32, i32* %v0
	%tmp23 = mul i32 %tmp22, 10
	%tmp24 = load i32, i32* %v2
	%tmp25 = getelementptr inbounds i8, i8* %str, i32 %tmp24
	%tmp26 = load i8, i8* %tmp25
	%tmp27 = sub i8 %tmp26, 48
	%tmp28 = sext i8 %tmp27 to i32
	%tmp29 = add i32 %tmp23, %tmp28
	store i32 %tmp29, i32* %v0
	%tmp30 = load i32, i32* %v2
	%tmp31 = add i32 %tmp30, 1
	store i32 %tmp31, i32* %v2
	br label %loop_start4
loop_body4_exit:
	%tmp32 = load i32, i32* %v0
	%tmp33 = load i32, i32* %v1
	%tmp34 = mul i32 %tmp32, %tmp33
	ret i32 %tmp34
}
define void @process.throw(i8* %exception){
	%tmp0 = call i32 @string_utils.c_str_len(i8* %exception)
	call i32 @AllocConsole()
	%tmp1 = call i8* @GetStdHandle(i32 -11)
	call void @console.writeln(i8* @.str.77, i32 11)
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
	%tmp5 = load i8*, i8** %v0
	%tmp6 = getelementptr inbounds i8, i8* %tmp5, i32 %tmp4
	%tmp7 = load i8, i8* %tmp6
	%tmp8 = icmp ne i8 %tmp7, 92
	br i1 %tmp8, label %logic_rhs_1, label %logic_end_1
logic_rhs_1:
	%tmp9 = load i32, i32* %v1
	%tmp10 = icmp sge i32 %tmp9, 0
	br label %logic_end_1
logic_end_1:
	%tmp11 = phi i1 [%tmp8, %loop_start0], [%tmp10, %logic_rhs_1]
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
	%tmp0 = icmp eq ptr %ptr, null
	br i1 %tmp0, label %then0, label %endif0
then0:
	%tmp1 = call i8* @mem.malloc(i64 %size)
	br label %func_exit
endif0:
	%tmp2 = call i32* @GetProcessHeap()
	%tmp3 = call i8* @HeapReAlloc(i32* %tmp2, i32 0, i8* %ptr, i64 %size)
	%tmp4 = icmp eq ptr %tmp3, null
	br i1 %tmp4, label %then1, label %endif1
then1:
	call void @process.throw(i8* @.str.78)
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
	%tmp2 = icmp eq ptr %tmp1, null
	br i1 %tmp2, label %then0, label %endif0
then0:
	call void @process.throw(i8* @.str.79)
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
	call void @process.throw(i8* @.str.80)
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
	%tmp0 = icmp ne ptr %ptr, null
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
	%tmp0 = sext i32 0 to i64
	store i64 %tmp0, i64* %v0
	br label %loop_cond0
loop_cond0:
	%tmp1 = load i64, i64* %v0
	%tmp2 = icmp sge i64 %tmp1, %len
	br i1 %tmp2, label %then1, label %endif1
then1:
	br label %loop_body0_exit
endif1:
	%tmp3 = load i64, i64* %v0
	%tmp4 = getelementptr inbounds i8, i8* %dest, i64 %tmp3
	%tmp5 = load i64, i64* %v0
	%tmp6 = getelementptr inbounds i8, i8* %src, i64 %tmp5
	%tmp7 = load i8, i8* %tmp6
	store i8 %tmp7, i8* %tmp4
	%tmp8 = load i64, i64* %v0
	%tmp9 = add i64 %tmp8, 1
	store i64 %tmp9, i64* %v0
	br label %loop_cond0
loop_body0_exit:
	ret void
}
define i32 @mem.compare(i8* %left, i8* %right, i64 %len){
	%v0 = alloca i64
	%tmp0 = sext i32 0 to i64
	store i64 %tmp0, i64* %v0
	br label %loop_cond0
loop_cond0:
	%tmp1 = load i64, i64* %v0
	%tmp2 = icmp sge i64 %tmp1, %len
	br i1 %tmp2, label %then1, label %endif1
then1:
	br label %loop_body0_exit
endif1:
	%tmp3 = load i64, i64* %v0
	%tmp4 = getelementptr inbounds i8, i8* %left, i64 %tmp3
	%tmp5 = load i8, i8* %tmp4
	%tmp6 = load i64, i64* %v0
	%tmp7 = getelementptr inbounds i8, i8* %right, i64 %tmp6
	%tmp8 = load i8, i8* %tmp7
	%tmp9 = icmp slt i8 %tmp5, %tmp8
	br i1 %tmp9, label %then2, label %endif2
then2:
	br label %func_exit
endif2:
	%tmp10 = load i64, i64* %v0
	%tmp11 = getelementptr inbounds i8, i8* %left, i64 %tmp10
	%tmp12 = load i8, i8* %tmp11
	%tmp13 = load i64, i64* %v0
	%tmp14 = getelementptr inbounds i8, i8* %right, i64 %tmp13
	%tmp15 = load i8, i8* %tmp14
	%tmp16 = icmp sgt i8 %tmp12, %tmp15
	br i1 %tmp16, label %then3, label %endif3
then3:
	br label %func_exit
endif3:
	%tmp17 = load i64, i64* %v0
	%tmp18 = add i64 %tmp17, 1
	store i64 %tmp18, i64* %v0
	br label %loop_cond0
loop_body0_exit:
	br label %func_exit
func_exit:
	%tmp19 = phi i32 [-1, %then2], [1, %then3], [0, %loop_body0_exit]
	ret i32 %tmp19
}
define i32 @fs.write_to_file(i8* %path, i8* %content, i32 %content_len){
	%v0 = alloca i32
	%tmp0 = call i8* @CreateFileA(i8* %path, i32 1073741824, i32 0, i8* null, i32 2, i32 128, i8* null)
	%tmp1 = sext i32 -1 to i64
	%tmp2 = inttoptr i64 %tmp1 to i8*
	%tmp3 = icmp eq ptr %tmp0, %tmp2
	br i1 %tmp3, label %then0, label %endif0
then0:
	br label %func_exit
endif0:
	store i32 0, i32* %v0
	%tmp4 = call i32 @WriteFile(i8* %tmp0, i8* %content, i32 %content_len, i32* %v0, i8* null)
	call i32 @CloseHandle(i8* %tmp0)
	%tmp5 = icmp ne i32 %tmp4, 0
	br i1 %tmp5, label %logic_rhs_1, label %logic_end_1
logic_rhs_1:
	%tmp6 = load i32, i32* %v0
	%tmp7 = icmp eq i32 %tmp6, %content_len
	br label %logic_end_1
logic_end_1:
	%tmp8 = phi i1 [%tmp5, %endif0], [%tmp7, %logic_rhs_1]
	%tmp9 = zext i1 %tmp8 to i32
	br label %func_exit
func_exit:
	%tmp10 = phi i32 [0, %then0], [%tmp9, %logic_end_1]
	ret i32 %tmp10
}
define %struct.string.String @fs.read_full_file_as_string(i8* %path){
	%v0 = alloca i64
	%v1 = alloca %struct.string.String
	%v2 = alloca i32
	%tmp0 = call i8* @CreateFileA(i8* %path, i32 2147483648, i32 1, i8* null, i32 3, i32 128, i8* null)
	%tmp1 = sext i32 -1 to i64
	%tmp2 = inttoptr i64 %tmp1 to i8*
	%tmp3 = icmp eq ptr %tmp0, %tmp2
	br i1 %tmp3, label %then0, label %endif0
then0:
	%tmp4 = call i8* @string_utils.insert(i8* @.str.81, i8* %path, i32 16)
	call void @process.throw(i8* %tmp4)
	br label %endif0
endif0:
	store i64 0, i64* %v0
	%tmp5 = call i32 @GetFileSizeEx(i8* %tmp0, i64* %v0)
	%tmp6 = icmp eq i32 %tmp5, 0
	br i1 %tmp6, label %then1, label %endif1
then1:
	call i32 @CloseHandle(i8* %tmp0)
	%tmp7 = call %struct.string.String @string.empty()
	br label %func_exit
endif1:
	%tmp8 = load i64, i64* %v0
	%tmp9 = trunc i64 %tmp8 to i32
	%tmp10 = call %struct.string.String @string.with_size(i32 %tmp9)
	store %struct.string.String %tmp10, %struct.string.String* %v1
	store i32 0, i32* %v2
	%tmp11 = load i8*, i8** %v1
	%tmp12 = load i64, i64* %v0
	%tmp13 = trunc i64 %tmp12 to i32
	%tmp14 = call i32 @ReadFile(i8* %tmp0, i8* %tmp11, i32 %tmp13, i32* %v2, i8* null)
	call i32 @CloseHandle(i8* %tmp0)
	%tmp15 = icmp eq i32 %tmp14, 0
	br i1 %tmp15, label %then2, label %endif2
then2:
	call void @string.free(%struct.string.String* %v1)
	call void @process.throw(i8* @.str.82)
	br label %endif2
endif2:
	%tmp16 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 1
	%tmp17 = load i64, i64* %v0
	%tmp18 = trunc i64 %tmp17 to i32
	store i32 %tmp18, i32* %tmp16
	%tmp19 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 1
	%tmp20 = load i32, i32* %tmp19
	%tmp21 = load i8*, i8** %v1
	%tmp22 = getelementptr inbounds i8, i8* %tmp21, i32 %tmp20
	store i8 0, i8* %tmp22
	%tmp23 = load %struct.string.String, %struct.string.String* %v1
	br label %func_exit
func_exit:
; Variable buffer is out.
	%tmp24 = phi %struct.string.String [%tmp7, %then1], [%tmp23, %endif2]
	ret %struct.string.String %tmp24
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
	%tmp1 = sext i32 -1 to i64
	%tmp2 = inttoptr i64 %tmp1 to i8*
	%tmp3 = icmp eq ptr %tmp0, %tmp2
	br i1 %tmp3, label %then0, label %endif0
then0:
	br label %func_exit
endif0:
	call i32 @CloseHandle(i8* %tmp0)
	br label %func_exit
func_exit:
	%tmp4 = phi i32 [0, %then0], [1, %endif0]
	ret i32 %tmp4
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
	%tmp0 = call i8* @console.get_stdout()
	%tmp1 = load i8*, i8** %str
	%tmp2 = getelementptr inbounds %struct.string.String, %struct.string.String* %str, i32 0, i32 1
	%tmp3 = load i32, i32* %tmp2
	call i32 @WriteConsoleA(i8* %tmp0, i8* %tmp1, i32 %tmp3, i32* %v0, i8* null)
	%tmp4 = getelementptr inbounds %struct.string.String, %struct.string.String* %str, i32 0, i32 1
	%tmp5 = load i32, i32* %tmp4
	%tmp6 = load i32, i32* %v0
	%tmp7 = icmp ne i32 %tmp5, %tmp6
	br i1 %tmp7, label %then0, label %endif0
then0:
	call void @ExitProcess(i32 -2)
	br label %endif0
endif0:
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
	call void @console.write(i8* @.str.83, i32 2)
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
	%tmp2 = sext i32 -1 to i64
	%tmp3 = inttoptr i64 %tmp2 to i8*
	%tmp4 = icmp eq ptr %tmp1, %tmp3
	br i1 %tmp4, label %then0, label %endif0
then0:
	call void @process.throw(i8* @.str.84)
	br label %endif0
endif0:
	%tmp5 = load i8*, i8** %v0
	ret i8* %tmp5
}
define i8 @char_utils.to_upper(i8 %c){
	%tmp0 = call i1 @char_utils.is_lower(i8 %c)
	br i1 %tmp0, label %then0, label %endif0
then0:
	%tmp1 = sub i8 %c, 32
	br label %func_exit
endif0:
	br label %func_exit
func_exit:
	%tmp2 = phi i8 [%tmp1, %then0], [%c, %endif0]
	ret i8 %tmp2
}
define i8 @char_utils.to_lower(i8 %c){
	%tmp0 = call i1 @char_utils.is_upper(i8 %c)
	br i1 %tmp0, label %then0, label %endif0
then0:
	%tmp1 = add i8 %c, 32
	br label %func_exit
endif0:
	br label %func_exit
func_exit:
	%tmp2 = phi i8 [%tmp1, %then0], [%c, %endif0]
	ret i8 %tmp2
}
define i1 @char_utils.is_xdigit(i8 %c){
entry:
	%tmp0 = icmp sge i8 %c, 48
	br i1 %tmp0, label %logic_rhs_0, label %logic_end_0
logic_rhs_0:
	%tmp1 = icmp sle i8 %c, 57
	br label %logic_end_0
logic_end_0:
	%tmp2 = phi i1 [%tmp0, %entry], [%tmp1, %logic_rhs_0]
	br i1 %tmp2, label %logic_end_1, label %logic_rhs_1
logic_rhs_1:
	%tmp3 = icmp sge i8 %c, 97
	br i1 %tmp3, label %logic_rhs_2, label %logic_end_2
logic_rhs_2:
	%tmp4 = icmp sle i8 %c, 102
	br label %logic_end_2
logic_end_2:
	%tmp5 = phi i1 [%tmp3, %logic_rhs_1], [%tmp4, %logic_rhs_2]
	br label %logic_end_1
logic_end_1:
	%tmp6 = phi i1 [%tmp2, %logic_end_0], [%tmp5, %logic_end_2]
	br i1 %tmp6, label %logic_end_3, label %logic_rhs_3
logic_rhs_3:
	%tmp7 = icmp sge i8 %c, 65
	br i1 %tmp7, label %logic_rhs_4, label %logic_end_4
logic_rhs_4:
	%tmp8 = icmp sle i8 %c, 70
	br label %logic_end_4
logic_end_4:
	%tmp9 = phi i1 [%tmp7, %logic_rhs_3], [%tmp8, %logic_rhs_4]
	br label %logic_end_3
logic_end_3:
	%tmp10 = phi i1 [%tmp6, %logic_end_1], [%tmp9, %logic_end_4]
	ret i1 %tmp10
}
define i1 @char_utils.is_upper(i8 %c){
entry:
	%tmp0 = icmp sge i8 %c, 65
	br i1 %tmp0, label %logic_rhs_0, label %logic_end_0
logic_rhs_0:
	%tmp1 = icmp sle i8 %c, 90
	br label %logic_end_0
logic_end_0:
	%tmp2 = phi i1 [%tmp0, %entry], [%tmp1, %logic_rhs_0]
	ret i1 %tmp2
}
define i1 @char_utils.is_space(i8 %c){
entry:
	%tmp0 = icmp eq i8 %c, 32
	br i1 %tmp0, label %logic_end_0, label %logic_rhs_0
logic_rhs_0:
	%tmp1 = icmp eq i8 %c, 9
	br label %logic_end_0
logic_end_0:
	%tmp2 = phi i1 [%tmp0, %entry], [%tmp1, %logic_rhs_0]
	br i1 %tmp2, label %logic_end_1, label %logic_rhs_1
logic_rhs_1:
	%tmp3 = icmp eq i8 %c, 10
	br label %logic_end_1
logic_end_1:
	%tmp4 = phi i1 [%tmp2, %logic_end_0], [%tmp3, %logic_rhs_1]
	br i1 %tmp4, label %logic_end_2, label %logic_rhs_2
logic_rhs_2:
	%tmp5 = icmp eq i8 %c, 118
	br label %logic_end_2
logic_end_2:
	%tmp6 = phi i1 [%tmp4, %logic_end_1], [%tmp5, %logic_rhs_2]
	br i1 %tmp6, label %logic_end_3, label %logic_rhs_3
logic_rhs_3:
	%tmp7 = icmp eq i8 %c, 102
	br label %logic_end_3
logic_end_3:
	%tmp8 = phi i1 [%tmp6, %logic_end_2], [%tmp7, %logic_rhs_3]
	br i1 %tmp8, label %logic_end_4, label %logic_rhs_4
logic_rhs_4:
	%tmp9 = icmp eq i8 %c, 13
	br label %logic_end_4
logic_end_4:
	%tmp10 = phi i1 [%tmp8, %logic_end_3], [%tmp9, %logic_rhs_4]
	ret i1 %tmp10
}
define i1 @char_utils.is_punct(i8 %c){
entry:
	%tmp0 = call i1 @char_utils.is_graph(i8 %c)
	br i1 %tmp0, label %logic_rhs_0, label %logic_end_0
logic_rhs_0:
	%tmp1 = call i1 @char_utils.is_alnum(i8 %c)
	%tmp2 = xor i1 1, %tmp1
	br label %logic_end_0
logic_end_0:
	%tmp3 = phi i1 [%tmp0, %entry], [%tmp2, %logic_rhs_0]
	ret i1 %tmp3
}
define i1 @char_utils.is_print(i8 %c){
entry:
	%tmp0 = icmp sge i8 %c, 32
	br i1 %tmp0, label %logic_rhs_0, label %logic_end_0
logic_rhs_0:
	%tmp1 = icmp sle i8 %c, 126
	br label %logic_end_0
logic_end_0:
	%tmp2 = phi i1 [%tmp0, %entry], [%tmp1, %logic_rhs_0]
	ret i1 %tmp2
}
define i1 @char_utils.is_lower(i8 %c){
entry:
	%tmp0 = icmp sge i8 %c, 97
	br i1 %tmp0, label %logic_rhs_0, label %logic_end_0
logic_rhs_0:
	%tmp1 = icmp sle i8 %c, 122
	br label %logic_end_0
logic_end_0:
	%tmp2 = phi i1 [%tmp0, %entry], [%tmp1, %logic_rhs_0]
	ret i1 %tmp2
}
define i1 @char_utils.is_graph(i8 %c){
entry:
	%tmp0 = icmp sge i8 %c, 33
	br i1 %tmp0, label %logic_rhs_0, label %logic_end_0
logic_rhs_0:
	%tmp1 = icmp sle i8 %c, 126
	br label %logic_end_0
logic_end_0:
	%tmp2 = phi i1 [%tmp0, %entry], [%tmp1, %logic_rhs_0]
	ret i1 %tmp2
}
define i1 @char_utils.is_digit(i8 %c){
entry:
	%tmp0 = icmp sge i8 %c, 48
	br i1 %tmp0, label %logic_rhs_0, label %logic_end_0
logic_rhs_0:
	%tmp1 = icmp sle i8 %c, 57
	br label %logic_end_0
logic_end_0:
	%tmp2 = phi i1 [%tmp0, %entry], [%tmp1, %logic_rhs_0]
	ret i1 %tmp2
}
define i1 @char_utils.is_cntrl(i8 %c){
entry:
	%tmp0 = icmp sge i8 %c, 0
	br i1 %tmp0, label %logic_rhs_0, label %logic_end_0
logic_rhs_0:
	%tmp1 = icmp sle i8 %c, 31
	br label %logic_end_0
logic_end_0:
	%tmp2 = phi i1 [%tmp0, %entry], [%tmp1, %logic_rhs_0]
	br i1 %tmp2, label %logic_end_1, label %logic_rhs_1
logic_rhs_1:
	%tmp3 = icmp eq i8 %c, 127
	br label %logic_end_1
logic_end_1:
	%tmp4 = phi i1 [%tmp2, %logic_end_0], [%tmp3, %logic_rhs_1]
	ret i1 %tmp4
}
define i1 @char_utils.is_alpha(i8 %c){
entry:
	%tmp0 = icmp sge i8 %c, 97
	br i1 %tmp0, label %logic_rhs_0, label %logic_end_0
logic_rhs_0:
	%tmp1 = icmp sle i8 %c, 122
	br label %logic_end_0
logic_end_0:
	%tmp2 = phi i1 [%tmp0, %entry], [%tmp1, %logic_rhs_0]
	br i1 %tmp2, label %logic_end_1, label %logic_rhs_1
logic_rhs_1:
	%tmp3 = icmp sge i8 %c, 65
	br i1 %tmp3, label %logic_rhs_2, label %logic_end_2
logic_rhs_2:
	%tmp4 = icmp sle i8 %c, 90
	br label %logic_end_2
logic_end_2:
	%tmp5 = phi i1 [%tmp3, %logic_rhs_1], [%tmp4, %logic_rhs_2]
	br label %logic_end_1
logic_end_1:
	%tmp6 = phi i1 [%tmp2, %logic_end_0], [%tmp5, %logic_end_2]
	ret i1 %tmp6
}
define i1 @char_utils.is_alnum(i8 %c){
entry:
	%tmp0 = icmp sge i8 %c, 97
	br i1 %tmp0, label %logic_rhs_0, label %logic_end_0
logic_rhs_0:
	%tmp1 = icmp sle i8 %c, 122
	br label %logic_end_0
logic_end_0:
	%tmp2 = phi i1 [%tmp0, %entry], [%tmp1, %logic_rhs_0]
	br i1 %tmp2, label %logic_end_1, label %logic_rhs_1
logic_rhs_1:
	%tmp3 = icmp sge i8 %c, 65
	br i1 %tmp3, label %logic_rhs_2, label %logic_end_2
logic_rhs_2:
	%tmp4 = icmp sle i8 %c, 90
	br label %logic_end_2
logic_end_2:
	%tmp5 = phi i1 [%tmp3, %logic_rhs_1], [%tmp4, %logic_rhs_2]
	br label %logic_end_1
logic_end_1:
	%tmp6 = phi i1 [%tmp2, %logic_end_0], [%tmp5, %logic_end_2]
	br i1 %tmp6, label %logic_end_3, label %logic_rhs_3
logic_rhs_3:
	%tmp7 = icmp sge i8 %c, 48
	br i1 %tmp7, label %logic_rhs_4, label %logic_end_4
logic_rhs_4:
	%tmp8 = icmp sle i8 %c, 57
	br label %logic_end_4
logic_end_4:
	%tmp9 = phi i1 [%tmp7, %logic_rhs_3], [%tmp8, %logic_rhs_4]
	br label %logic_end_3
logic_end_3:
	%tmp10 = phi i1 [%tmp6, %logic_end_1], [%tmp9, %logic_end_4]
	ret i1 %tmp10
}
define %"struct.test.QPair<i64, i64>" @xq(){
	%tmp0 = call %"struct.test.QPair<i64, i64>" @test.geg()
	ret %"struct.test.QPair<i64, i64>" %tmp0
}
define void ()* ()* @of_fn(){
	%tmp0 = call void ()* ()* @of_fn()
	ret void ()* ()* %tmp0
}
define void @basic_functions(){
	call i32 @AllocConsole()
	call void @tests.run()
	call void @window.start()
	call i32 @FreeConsole()
	ret void
}
define i32 @_fltused(){
	ret i32 0
}
define void @__chkstk(){
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
	%tmp15 = bitcast %struct.string.String* %tmp14 to i8*
	%tmp16 = call i8* @mem.realloc(i8* %tmp15, i64 %tmp13)
	%tmp17 = bitcast i8* %tmp16 to %struct.string.String*
	store %struct.string.String* %tmp17, %struct.string.String** %vec
	%tmp18 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 2
	%tmp19 = load i32, i32* %v0
	store i32 %tmp19, i32* %tmp18
	br label %endif0
endif0:
	%tmp20 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 1
	%tmp21 = load i32, i32* %tmp20
	%tmp22 = load %struct.string.String*, %struct.string.String** %vec
	%tmp23 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp22, i32 %tmp21
	store %struct.string.String %data, %struct.string.String* %tmp23
	%tmp24 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 1
	%tmp25 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 1
	%tmp26 = load i32, i32* %tmp25
	%tmp27 = add i32 %tmp26, 1
	store i32 %tmp27, i32* %tmp24
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
	%tmp15 = bitcast i8* %tmp14 to i8*
	%tmp16 = call i8* @mem.realloc(i8* %tmp15, i64 %tmp13)
	%tmp17 = bitcast i8* %tmp16 to i8*
	store i8* %tmp17, i8** %vec
	%tmp18 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 2
	%tmp19 = load i32, i32* %v0
	store i32 %tmp19, i32* %tmp18
	br label %endif0
endif0:
	%tmp20 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 1
	%tmp21 = load i32, i32* %tmp20
	%tmp22 = load i8*, i8** %vec
	%tmp23 = getelementptr inbounds i8, i8* %tmp22, i32 %tmp21
	store i8 %data, i8* %tmp23
	%tmp24 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 1
	%tmp25 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 1
	%tmp26 = load i32, i32* %tmp25
	%tmp27 = add i32 %tmp26, 1
	store i32 %tmp27, i32* %tmp24
	ret void
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
define void @"vector.free<%struct.string.String>"(%"struct.vector.Vec<%struct.string.String>"* %vec){
	%tmp0 = load %struct.string.String*, %struct.string.String** %vec
	%tmp1 = icmp ne ptr %tmp0, null
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
	%tmp1 = icmp ne ptr %tmp0, null
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
	%tmp0 = sext i32 0 to i64
	store i64 %tmp0, i64* %v0
	br label %loop_cond0
loop_cond0:
	%tmp1 = load i64, i64* %v0
	%tmp2 = icmp sge i64 %tmp1, %len
	br i1 %tmp2, label %then1, label %endif1
then1:
	br label %loop_body0_exit
endif1:
	%tmp3 = load i64, i64* %v0
	%tmp4 = getelementptr inbounds i8, i8* %dest, i64 %tmp3
	store i8 %val, i8* %tmp4
	%tmp5 = load i64, i64* %v0
	%tmp6 = add i64 %tmp5, 1
	store i64 %tmp6, i64* %v0
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
	%tmp2 = icmp ne ptr %tmp1, null
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
	%tmp2 = icmp ne ptr %tmp1, null
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
	%tmp1 = bitcast i8* %tmp0 to %"struct.list.ListNode<i32>"*
	store %"struct.list.ListNode<i32>"* %tmp1, %"struct.list.ListNode<i32>"** %v0
	%tmp2 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v0
	call void @"list.new_node<i32>"(%"struct.list.ListNode<i32>"* %tmp2)
	%tmp3 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v0
	store i32 %data, i32* %tmp3
	%tmp4 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %list
	%tmp5 = icmp eq ptr %tmp4, null
	br i1 %tmp5, label %then0, label %else0
then0:
	%tmp6 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v0
	store %"struct.list.ListNode<i32>"* %tmp6, %"struct.list.ListNode<i32>"** %list
	%tmp7 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %list, i32 0, i32 1
	%tmp8 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v0
	store %"struct.list.ListNode<i32>"* %tmp8, %"struct.list.ListNode<i32>"** %tmp7
	br label %endif0
else0:
	%tmp9 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %list, i32 0, i32 1
	%tmp10 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %list, i32 0, i32 1
	%tmp11 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %tmp10
	%tmp12 = getelementptr inbounds %"struct.list.ListNode<i32>", %"struct.list.ListNode<i32>"* %tmp11, i32 0, i32 1
	%tmp13 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v0
	store %"struct.list.ListNode<i32>"* %tmp13, %"struct.list.ListNode<i32>"** %tmp12
	%tmp14 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %list, i32 0, i32 1
	%tmp15 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v0
	store %"struct.list.ListNode<i32>"* %tmp15, %"struct.list.ListNode<i32>"** %tmp14
	br label %endif0
endif0:
	%tmp16 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %list, i32 0, i32 2
	%tmp17 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %list, i32 0, i32 2
	%tmp18 = load i32, i32* %tmp17
	%tmp19 = add i32 %tmp18, 1
	store i32 %tmp19, i32* %tmp16
	ret void
}
define %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>" @"ax<i32>"(){
	%v0 = alloca %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>"
	store i32 43, i32* %v0
	%tmp0 = getelementptr inbounds %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>", %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>"* %v0, i32 0, i32 1
	store i8 126, i8* %tmp0
	%tmp1 = load %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>", %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>"* %v0
; Variable p is out.
	ret %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>" %tmp1
}
define void @"list.new_node<i32>"(%"struct.list.ListNode<i32>"* %list){
	%tmp0 = getelementptr inbounds %"struct.list.ListNode<i32>", %"struct.list.ListNode<i32>"* %list, i32 0, i32 1
	store %"struct.list.ListNode<i32>"* null, %"struct.list.ListNode<i32>"** %tmp0
	store i32 0, i32* %list
	ret void
}

;func __chkstk ["no_lazy"]
;func _fltused ["no_lazy"]
;func ax []
;func ay []
;func basic_functions []
;func main []
;func of_fn []
;func xq []
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
;func process.throw []
;func stdlib.atoi []
;func stdlib.rand []
;func stdlib.srand []
;func stdlib.str_to_l []
;func string.as_c_string_stalloc ["ExtentionOf"]
;func string.clone ["ExtentionOf"]
;func string.concat_with_c_string ["ExtentionOf"]
;func string.empty []
;func string.equal ["ExtentionOf"]
;func string.free ["ExtentionOf"]
;func string.from_c_string []
;func string.with_size []
;func string_utils.c_str_copy []
;func string_utils.c_str_len []
;func string_utils.c_str_n_copy []
;func string_utils.insert []
;func test.geg []
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
;type Pair
;type list.List
;type list.ListNode
;type mem.PROCESS_HEAP_ENTRY
;type string.String
;type test.QPair
;type vector.Vec
;type window.BITMAP
;type window.MSG
;type window.PAINTSTRUCT
;type window.POINT
;type window.RECT
;type window.WNDCLASSEXA
