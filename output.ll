target triple = "x86_64-pc-windows-msvc"
;./src.rcsharp
%struct.mem.PROCESS_HEAP_ENTRY = type { i8*, i32, i8, i8, i16, i8*, i32, i32, i32 }
%struct.string.String = type { i8*, i32 }
%struct.window.POINT = type { i32, i32 }
%struct.window.MSG = type { i8*, i32, i64, i64, i32, %struct.window.POINT }
%struct.window.WNDCLASSEXA = type { i32, i32, i64 (i8*, i32, i64, i64)**, i32, i32, i8*, i8*, i8*, i8*, i8*, i8*, i8* }
%struct.window.RECT = type { i32, i32, i32, i32 }
%struct.window.PAINTSTRUCT = type { i8*, i32, %struct.window.RECT, i32, i32, i8* }
%struct.window.BITMAP = type { i32, i32, i32, i32, i16, i16, i8* }
%"struct.list.List<i32>" = type { %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"*, i32 }
%"struct.list.ListNode<i32>" = type { i32, %"struct.list.ListNode<i32>"* }
%"struct.vector.Vec<i8>" = type { i8*, i32, i32 }
%"struct.vector.Vec<%struct.string.String>" = type { %struct.string.String*, i32, i32 }
%"struct.vector.Vec<i64>" = type { i64*, i32, i32 }
%"struct.Pair<i32, struct.Pair<i8, %struct.string.String>>" = type { i32, %"struct.Pair<i8, %struct.string.String>" }
%"struct.Pair<i8, %struct.string.String>" = type { i8, %struct.string.String }
%"struct.test.QPair<i64, i64>" = type { i64, i64 }

declare dllimport void @ExitProcess(i32)
declare dllimport i32 @GetModuleFileNameA(i8*,i8*,i32)
declare dllimport i32* @GetProcessHeap()
declare dllimport i8* @HeapAlloc(i32*,i32,i64)
declare dllimport i8* @HeapReAlloc(i32*,i32,i8*,i64)
declare dllimport i32 @HeapFree(i32*,i32,i8*)
declare dllimport i32 @HeapWalk(i32*,%struct.mem.PROCESS_HEAP_ENTRY*)
declare dllimport i32 @HeapLock(i32*)
declare dllimport i32 @HeapUnlock(i32*)
declare dllimport i32 @AllocConsole()
declare dllimport i8* @GetStdHandle(i32)
declare dllimport i32 @FreeConsole()
declare dllimport i32 @WriteConsoleA(i8*,i8*,i32,i32*,i8*)
declare dllimport i8* @CreateFileA(i8*,i32,i32,i8*,i32,i32,i8*)
declare dllimport i32 @WriteFile(i8*,i8*,i32,i32*,i8*)
declare dllimport i32 @ReadFile(i8*,i8*,i32,i32*,i8*)
declare dllimport i32 @GetFileSizeEx(i8*,i64*)
declare dllimport i32 @CloseHandle(i8*)
declare dllimport i32 @DeleteFileA(i8*)
declare dllimport i32 @GetFileAttributesA(i8*)
declare dllimport i8* @CreateWindowExA(i32,i8*,i8*,i32,i32,i32,i32,i32,i8*,i8*,i8*,i8*)
declare dllimport i64 @DefWindowProcA(i8*,i32,i64,i64)
declare dllimport i32 @GetMessageA(%struct.window.MSG*,i8*,i32,i32)
declare dllimport i32 @TranslateMessage(%struct.window.MSG*)
declare dllimport i64 @DispatchMessageA(%struct.window.MSG*)
declare dllimport void @PostQuitMessage(i32)
declare dllimport i8* @BeginPaint(i8*,%struct.window.PAINTSTRUCT*)
declare dllimport i32 @EndPaint(i8*,%struct.window.PAINTSTRUCT*)
declare dllimport i8* @LoadImageA(i8*,i8*,i32,i32,i32,i32)
declare dllimport i32 @GetClientRect(i8*,%struct.window.RECT*)
declare dllimport i32 @InvalidateRect(i8*,%struct.window.RECT*,i32)
declare dllimport i8* @GetModuleHandleA(i8*)
declare dllimport i16 @RegisterClassExA(%struct.window.WNDCLASSEXA*)
declare dllimport i32 @ShowWindow(i8*,i32)
declare dllimport i8* @CreateCompatibleDC(i8*)
declare dllimport i8* @SelectObject(i8*,i8*)
declare dllimport i32 @BitBlt(i8*,i32,i32,i32,i32,i8*,i32,i32,i32)
declare dllimport i32 @DeleteDC(i8*)
declare dllimport i32 @GetObjectA(i8*,i32,%struct.window.BITMAP*)
declare dllimport i32 @SetStretchBltMode(i8*,i32)
declare dllimport i32 @StretchBlt(i8*,i32,i32,i32,i32,i8*,i32,i32,i32,i32,i32)
declare dllimport i64 @SetWindowLongPtrA(i8*,i32,i8*)
declare dllimport i8* @GetWindowLongPtrA(i8*,i32)

@.str.0 = private unnamed_addr constant [12 x i8] c"Exception: \00"
@.str.1 = private unnamed_addr constant [14 x i8] c"Out of memory\00"
@.str.2 = private unnamed_addr constant [15 x i8] c"Realloc failed\00"
@.str.3 = private unnamed_addr constant [33 x i8] c"Failed to lock heap for walking.\00"
@.str.4 = private unnamed_addr constant [26 x i8] c"stdout handle was invalid\00"
@.str.5 = private unnamed_addr constant [3 x i8] c"0\0A\00"
@.str.6 = private unnamed_addr constant [17 x i8] c"File not found: \00"
@.str.7 = private unnamed_addr constant [17 x i8] c"File read failed\00"
@.str.8 = private unnamed_addr constant [20 x i8] c"test malloc delta: \00"
@.str.9 = private unnamed_addr constant [11 x i8] c"mem_test: \00"
@.str.10 = private unnamed_addr constant [24 x i8] c"mem_test: malloc failed\00"
@.str.11 = private unnamed_addr constant [35 x i8] c"mem_test: fill verification failed\00"
@.str.12 = private unnamed_addr constant [40 x i8] c"mem_test: zero_fill verification failed\00"
@.str.13 = private unnamed_addr constant [33 x i8] c"mem_test: malloc for copy failed\00"
@.str.14 = private unnamed_addr constant [35 x i8] c"mem_test: copy verification failed\00"
@.str.15 = private unnamed_addr constant [3 x i8] c"OK\00"
@.str.16 = private unnamed_addr constant [20 x i8] c"string_utils_test: \00"
@.str.17 = private unnamed_addr constant [5 x i8] c"test\00"
@.str.18 = private unnamed_addr constant [36 x i8] c"string_utils_test: c_str_len failed\00"
@.str.19 = private unnamed_addr constant [1 x i8] c"\00"
@.str.20 = private unnamed_addr constant [42 x i8] c"string_utils_test: c_str_len empty failed\00"
@.str.21 = private unnamed_addr constant [39 x i8] c"string_utils_test: is_ascii_num failed\00"
@.str.22 = private unnamed_addr constant [40 x i8] c"string_utils_test: is_ascii_char failed\00"
@.str.23 = private unnamed_addr constant [39 x i8] c"string_utils_test: is_ascii_hex failed\00"
@.str.24 = private unnamed_addr constant [3 x i8] c"ac\00"
@.str.25 = private unnamed_addr constant [2 x i8] c"b\00"
@.str.26 = private unnamed_addr constant [4 x i8] c"abc\00"
@.str.27 = private unnamed_addr constant [33 x i8] c"string_utils_test: insert failed\00"
@.str.28 = private unnamed_addr constant [14 x i8] c"string_test: \00"
@.str.29 = private unnamed_addr constant [6 x i8] c"hello\00"
@.str.30 = private unnamed_addr constant [6 x i8] c"world\00"
@.str.31 = private unnamed_addr constant [41 x i8] c"string_test: from_c_string length failed\00"
@.str.32 = private unnamed_addr constant [40 x i8] c"string_test: equal positive case failed\00"
@.str.33 = private unnamed_addr constant [40 x i8] c"string_test: equal negative case failed\00"
@.str.34 = private unnamed_addr constant [7 x i8] c" world\00"
@.str.35 = private unnamed_addr constant [12 x i8] c"hello world\00"
@.str.36 = private unnamed_addr constant [34 x i8] c"string_test: concat length failed\00"
@.str.37 = private unnamed_addr constant [35 x i8] c"string_test: concat content failed\00"
@.str.38 = private unnamed_addr constant [14 x i8] c"vector_test: \00"
@.str.39 = private unnamed_addr constant [24 x i8] c"vector_test: new failed\00"
@.str.40 = private unnamed_addr constant [33 x i8] c"vector_test: initial push failed\00"
@.str.41 = private unnamed_addr constant [36 x i8] c"vector_test: initial content failed\00"
@.str.42 = private unnamed_addr constant [28 x i8] c"vector_test: realloc failed\00"
@.str.43 = private unnamed_addr constant [36 x i8] c"vector_test: realloc content failed\00"
@.str.44 = private unnamed_addr constant [3 x i8] c"AB\00"
@.str.45 = private unnamed_addr constant [37 x i8] c"vector_test: push_bulk length failed\00"
@.str.46 = private unnamed_addr constant [38 x i8] c"vector_test: push_bulk content failed\00"
@.str.47 = private unnamed_addr constant [25 x i8] c"vector_test: free failed\00"
@.str.48 = private unnamed_addr constant [12 x i8] c"list_test: \00"
@.str.49 = private unnamed_addr constant [22 x i8] c"list_test: new failed\00"
@.str.50 = private unnamed_addr constant [41 x i8] c"list_test: length incorrect after extend\00"
@.str.51 = private unnamed_addr constant [33 x i8] c"list_test: walk length incorrect\00"
@.str.52 = private unnamed_addr constant [36 x i8] c"list_test: data mismatch for node 1\00"
@.str.53 = private unnamed_addr constant [36 x i8] c"list_test: data mismatch for node 2\00"
@.str.54 = private unnamed_addr constant [36 x i8] c"list_test: data mismatch for node 3\00"
@.str.55 = private unnamed_addr constant [33 x i8] c"list_test: foot pointer mismatch\00"
@.str.56 = private unnamed_addr constant [23 x i8] c"list_test: free failed\00"
@.str.57 = private unnamed_addr constant [15 x i8] c"process_test: \00"
@.str.58 = private unnamed_addr constant [49 x i8] c"process_test: get_executable_path returned empty\00"
@.str.59 = private unnamed_addr constant [53 x i8] c"process_test: get_executable_env_path returned empty\00"
@.str.60 = private unnamed_addr constant [53 x i8] c"process_test: env path is not shorter than full path\00"
@.str.61 = private unnamed_addr constant [53 x i8] c"process_test: env path does not end with a backslash\00"
@.str.62 = private unnamed_addr constant [18 x i8] c"Executable Path: \00"
@.str.63 = private unnamed_addr constant [19 x i8] c"Environment Path: \00"
@.str.64 = private unnamed_addr constant [15 x i8] c"\0Aconsole_test:\00"
@.str.65 = private unnamed_addr constant [26 x i8] c"--- VISUAL TEST START ---\00"
@.str.66 = private unnamed_addr constant [22 x i8] c"Printing i64(12345): \00"
@.str.67 = private unnamed_addr constant [23 x i8] c"Printing i64(-67890): \00"
@.str.68 = private unnamed_addr constant [18 x i8] c"Printing i64(0): \00"
@.str.69 = private unnamed_addr constant [27 x i8] c"Printing u64(9876543210): \00"
@.str.70 = private unnamed_addr constant [24 x i8] c"--- VISUAL TEST END ---\00"
@.str.71 = private unnamed_addr constant [10 x i8] c"fs_test: \00"
@.str.72 = private unnamed_addr constant [47 x i8] c"The quick brown fox jumps over crazy lost dog.\00"
@.str.73 = private unnamed_addr constant [9 x i8] c"test.txt\00"
@.str.74 = private unnamed_addr constant [38 x i8] c"Filesystem test failed, data mismatch\00"
@.str.75 = private unnamed_addr constant [45 x i8] c"D:\Projects\rcsharp\src_base_structs.rcsharp\00"
@.str.76 = private unnamed_addr constant [37 x i8] c"File not found! While loading Bitmap\00"
@.str.77 = private unnamed_addr constant [48 x i8] c"Window error: StartError::GetModuleHandleFailed\00"
@.str.78 = private unnamed_addr constant [14 x i8] c"MyWindowClass\00"
@.str.79 = private unnamed_addr constant [46 x i8] c"Window error: StartError::RegisterClassFailed\00"
@.str.80 = private unnamed_addr constant [14 x i8] c"Hello, World!\00"
@.str.81 = private unnamed_addr constant [45 x i8] c"Window error: StartError::CreateWindowFailed\00"
@.str.82 = private unnamed_addr constant [42 x i8] c"Failed to load image. not valid .BMP file\00"
@.str.83 = private unnamed_addr constant [21 x i8] c"BorderlessImageClass\00"
@.str.84 = private unnamed_addr constant [12 x i8] c"ImageWindow\00"
define void @"__chkstk"(){
    ret void
}
define i32 @"_fltused"(){
    ret i32 0
}
define %struct.string.String @"process.get_executable_path"(){
    %v0 = alloca %struct.string.String; var: string
    %tmp1 = call %struct.string.String @string.with_size(i32 260)
    store %struct.string.String %tmp1, %struct.string.String* %v0
    %tmp2 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
    %tmp3 = load i8*, i8** %tmp2
    %tmp4 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
    %tmp5 = load i32, i32* %tmp4
    %tmp7 = call i32 @GetModuleFileNameA(i8* null, i8* %tmp3, i32 %tmp5)
    %tmp8 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
    store i32 %tmp7, i32* %tmp8
    %tmp10 = load %struct.string.String, %struct.string.String* %v0
    ret %struct.string.String %tmp10
}
define %struct.string.String @"process.get_executable_env_path"(){
    %v0 = alloca %struct.string.String; var: string
    %v1 = alloca i32; var: index
    %tmp0 = call %struct.string.String @process.get_executable_path()
    store %struct.string.String %tmp0, %struct.string.String* %v0
    %tmp1 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
    %tmp2 = load i32, i32* %tmp1
    %tmp3 = sub i32 %tmp2, 1
    store i32 %tmp3, i32* %v1
    br label %loop_body0
loop_body0:
    %tmp4 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
    %tmp5 = load i8*, i8** %tmp4
    %tmp6 = load i32, i32* %v1
    %tmp7 = getelementptr inbounds i8, i8* %tmp5, i32 %tmp6
    %tmp8 = load i8, i8* %tmp7
    %tmp9 = icmp eq i8 %tmp8, 92
    %tmp10 = load i32, i32* %v1
    %tmp11 = icmp slt i32 %tmp10, 0
    %tmp12 = or i1 %tmp9, %tmp11
    br i1 %tmp12, label %then1, label %endif1
then1:
    br label %loop_body0_exit
    br label %endif1
endif1:
    %tmp13 = load i32, i32* %v1
    %tmp14 = sub i32 %tmp13, 1
    store i32 %tmp14, i32* %v1
    br label %loop_body0
loop_body0_exit:
    %tmp15 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
    %tmp16 = load i32, i32* %v1
    %tmp17 = add i32 %tmp16, 1
    store i32 %tmp17, i32* %tmp15
    %tmp18 = load %struct.string.String, %struct.string.String* %v0
    ret %struct.string.String %tmp18
}
define void @"process.throw"(i8* %exception){
    %tmp0 = call i32 @string_utils.c_str_len(i8* %exception)
    call i32 @AllocConsole()
    %tmp1 = call i8* @GetStdHandle(i32 -11)
    %tmp2 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.0, i64 0, i64 0
    call void @console.writeln(i8* %tmp2, i32 11)
    call void @console.writeln(i8* %exception, i32 %tmp0)
    call void @ExitProcess(i32 -1)
    ret void
}
define i8* @"mem.malloc"(i64 %size){
    %tmp0 = call i32* @GetProcessHeap()
    %tmp1 = call i8* @HeapAlloc(i32* %tmp0, i32 0, i64 %size)
    %tmp2 = inttoptr i64 0 to i8*
    %tmp3 = icmp eq ptr %tmp1, %tmp2
    br i1 %tmp3, label %then0, label %endif0
then0:
    %tmp4 = getelementptr inbounds [14 x i8], [14 x i8]* @.str.1, i64 0, i64 0
    call void @process.throw(i8* %tmp4)
    br label %endif0
endif0:
    ret i8* %tmp1
}
define i8* @"mem.realloc"(i8* %ptr, i64 %size){
    %tmp0 = inttoptr i64 0 to i8*
    %tmp1 = icmp eq ptr %ptr, %tmp0
    br i1 %tmp1, label %then0, label %endif0
then0:
    %tmp2 = call i8* @mem.malloc(i64 %size)
    ret i8* %tmp2
    br label %endif0
endif0:
    %tmp3 = call i32* @GetProcessHeap()
    %tmp4 = call i8* @HeapReAlloc(i32* %tmp3, i32 0, i8* %ptr, i64 %size)
    %tmp5 = inttoptr i64 0 to i8*
    %tmp6 = icmp eq ptr %tmp4, %tmp5
    br i1 %tmp6, label %then1, label %endif1
then1:
    %tmp7 = getelementptr inbounds [15 x i8], [15 x i8]* @.str.2, i64 0, i64 0
    call void @process.throw(i8* %tmp7)
    br label %endif1
endif1:
    ret i8* %tmp4
}
define void @"mem.free"(i8* %ptr){
    %tmp0 = inttoptr i64 0 to i8*
    %tmp1 = icmp ne ptr %ptr, %tmp0
    br i1 %tmp1, label %then0, label %endif0
then0:
    %tmp2 = call i32* @GetProcessHeap()
    call i32 @HeapFree(i32* %tmp2, i32 0, i8* %ptr)
    br label %endif0
endif0:
    ret void
}
define void @"mem.copy"(i8* %src, i8* %dest, i64 %len){
    %v0 = alloca i64; var: i
    store i64 0, i64* %v0
    br label %loop_body0
loop_body0:
    %tmp0 = load i64, i64* %v0
    %tmp1 = icmp sge i64 %tmp0, %len
    br i1 %tmp1, label %then1, label %endif1
then1:
    br label %loop_body0_exit
    br label %endif1
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
    br label %loop_body0
loop_body0_exit:
    ret void
}
define i32 @"mem.compare"(i8* %left, i8* %right, i64 %len){
    %v0 = alloca i64; var: i
    store i64 0, i64* %v0
    br label %loop_body0
loop_body0:
    %tmp0 = load i64, i64* %v0
    %tmp1 = icmp sge i64 %tmp0, %len
    br i1 %tmp1, label %then1, label %endif1
then1:
    br label %loop_body0_exit
    br label %endif1
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
    ret i32 -1
    br label %endif2
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
    ret i32 1
    br label %endif3
endif3:
    %tmp16 = load i64, i64* %v0
    %tmp17 = add i64 %tmp16, 1
    store i64 %tmp17, i64* %v0
    br label %loop_body0
loop_body0_exit:
    ret i32 0
}
define void @"mem.fill"(i8 %val, i8* %dest, i64 %len){
    %v0 = alloca i64; var: i
    store i64 0, i64* %v0
    br label %loop_body0
loop_body0:
    %tmp0 = load i64, i64* %v0
    %tmp1 = icmp sge i64 %tmp0, %len
    br i1 %tmp1, label %then1, label %endif1
then1:
    br label %loop_body0_exit
    br label %endif1
endif1:
    %tmp2 = load i64, i64* %v0
    %tmp3 = getelementptr inbounds i8, i8* %dest, i64 %tmp2
    store i8 %val, i8* %tmp3
    %tmp4 = load i64, i64* %v0
    %tmp5 = add i64 %tmp4, 1
    store i64 %tmp5, i64* %v0
    br label %loop_body0
loop_body0_exit:
    ret void
}
define void @"mem.zero_fill"(i8* %dest, i64 %len){
    call void @mem.fill(i8 0, i8* %dest, i64 %len)
    ret void
}
define i64 @"mem.get_total_allocated_memory_external"(){
    %v0 = alloca i64; var: total_size
    %v1 = alloca %struct.mem.PROCESS_HEAP_ENTRY; var: entry
    %tmp0 = call i32* @GetProcessHeap()
    store i64 0, i64* %v0
    %tmp1 = getelementptr inbounds %struct.mem.PROCESS_HEAP_ENTRY, %struct.mem.PROCESS_HEAP_ENTRY* %v1, i32 0, i32 0
    store i8* null, i8** %tmp1
    %tmp2 = call i32 @HeapLock(i32* %tmp0)
    %tmp3 = icmp eq i32 %tmp2, 0
    br i1 %tmp3, label %then0, label %endif0
then0:
    %tmp4 = getelementptr inbounds [33 x i8], [33 x i8]* @.str.3, i64 0, i64 0
    call void @process.throw(i8* %tmp4)
    br label %endif0
endif0:
    br label %loop_body1
loop_body1:
    %tmp5 = call i32 @HeapWalk(i32* %tmp0, %struct.mem.PROCESS_HEAP_ENTRY* %v1)
    %tmp6 = icmp eq i32 %tmp5, 0
    br i1 %tmp6, label %then2, label %endif2
then2:
    br label %loop_body1_exit
    br label %endif2
endif2:
    %tmp7 = getelementptr inbounds %struct.mem.PROCESS_HEAP_ENTRY, %struct.mem.PROCESS_HEAP_ENTRY* %v1, i32 0, i32 4
    %tmp8 = load i16, i16* %tmp7
    %tmp9 = and i16 %tmp8, 4
    %tmp10 = icmp ne i16 %tmp9, 0
    br i1 %tmp10, label %then3, label %endif3
then3:
    %tmp11 = load i64, i64* %v0
    %tmp12 = getelementptr inbounds %struct.mem.PROCESS_HEAP_ENTRY, %struct.mem.PROCESS_HEAP_ENTRY* %v1, i32 0, i32 1
    %tmp13 = load i32, i32* %tmp12
    %tmp14 = zext i32 %tmp13 to i64
    %tmp15 = add i64 %tmp11, %tmp14
    store i64 %tmp15, i64* %v0
    br label %endif3
endif3:
    br label %loop_body1
loop_body1_exit:
    call i32 @HeapUnlock(i32* %tmp0)
    %tmp16 = load i64, i64* %v0
    ret i64 %tmp16
}
define i8* @"console.get_stdout"(){
    %v0 = alloca i8*; var: stdout_handle
    %tmp0 = call i8* @GetStdHandle(i32 -11)
    store i8* %tmp0, i8** %v0
    %tmp1 = load i8*, i8** %v0
    %tmp2 = inttoptr i64 -1 to i8*
    %tmp3 = icmp eq ptr %tmp1, %tmp2
    br i1 %tmp3, label %then0, label %endif0
then0:
    %tmp4 = getelementptr inbounds [26 x i8], [26 x i8]* @.str.4, i64 0, i64 0
    call void @process.throw(i8* %tmp4)
    br label %endif0
endif0:
    %tmp5 = load i8*, i8** %v0
    ret i8* %tmp5
}
define void @"console.write"(i8* %buffer, i32 %len){
    %v0 = alloca i32; var: chars_written
    %tmp0 = call i8* @console.get_stdout()
    call i32 @WriteConsoleA(i8* %tmp0, i8* %buffer, i32 %len, i32* %v0, i8* null)
    %tmp1 = load i32, i32* %v0
    %tmp2 = icmp ne i32 %len, %tmp1
    br i1 %tmp2, label %then0, label %endif0
then0:
    call void @ExitProcess(i32 -2)
    br label %endif0
endif0:
    ret void
}
define void @"console.write_string"(%struct.string.String* %str){
    %v0 = alloca i32; var: chars_written
    %tmp0 = call i8* @console.get_stdout()
    %tmp1 = getelementptr inbounds %struct.string.String, %struct.string.String* %str, i32 0, i32 0
    %tmp2 = load i8*, i8** %tmp1
    %tmp3 = getelementptr inbounds %struct.string.String, %struct.string.String* %str, i32 0, i32 1
    %tmp4 = load i32, i32* %tmp3
    call i32 @WriteConsoleA(i8* %tmp0, i8* %tmp2, i32 %tmp4, i32* %v0, i8* null)
    %tmp5 = getelementptr inbounds %struct.string.String, %struct.string.String* %str, i32 0, i32 1
    %tmp6 = load i32, i32* %tmp5
    %tmp7 = load i32, i32* %v0
    %tmp8 = icmp ne i32 %tmp6, %tmp7
    br i1 %tmp8, label %then0, label %endif0
then0:
    call void @ExitProcess(i32 -2)
    br label %endif0
endif0:
    ret void
}
define void @"console.writeln"(i8* %buffer, i32 %len){
    %v0 = alloca i32; var: chars_written
    %v1 = alloca i8; var: nl
    %tmp0 = icmp eq i32 %len, 0
    br i1 %tmp0, label %then0, label %endif0
then0:
    ret void
    br label %endif0
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
    store i8 10, i8* %v1
    %tmp4 = call i8* @console.get_stdout()
    call i32 @WriteConsoleA(i8* %tmp4, i8* %v1, i32 1, i32* %v0, i8* null)
    ret void
}
define void @"console.print_char"(i8 %n){
    %v0 = alloca i8; var: b
    store i8 %n, i8* %v0
    call void @console.write(i8* %v0, i32 1)
    ret void
}
define void @"console.println_i64"(i64 %n){
    %tmp0 = icmp sge i64 %n, 0
    br i1 %tmp0, label %then0, label %else0
then0:
    call void @console.println_u64(i64 %n)
    br label %endif0
else0:
    call void @console.print_char(i8 45)
    %tmp2 = sub i64 0, %n
    call void @console.println_u64(i64 %tmp2)
    br label %endif0
endif0:
    ret void
}
define void @"console.println_u64"(i64 %n){
    %v0 = alloca i32; var: i
    %v1 = alloca i64; var: mut_n
    %tmp0 = alloca i8, i64 22
    store i32 20, i32* %v0
    %tmp1 = icmp eq i64 %n, 0
    br i1 %tmp1, label %then0, label %endif0
then0:
    %tmp2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.5, i64 0, i64 0
    call void @console.write(i8* %tmp2, i32 2)
    ret void
    br label %endif0
endif0:
    store i64 %n, i64* %v1
    br label %loop_body1
loop_body1:
    %tmp3 = load i32, i32* %v0
    %tmp4 = getelementptr inbounds i8, i8* %tmp0, i32 %tmp3
    %tmp5 = load i64, i64* %v1
    %tmp6 = urem i64 %tmp5, 10
    %tmp7 = trunc i64 %tmp6 to i8
    %tmp8 = add i8 %tmp7, 48
    store i8 %tmp8, i8* %tmp4
    %tmp9 = load i64, i64* %v1
    %tmp10 = udiv i64 %tmp9, 10
    store i64 %tmp10, i64* %v1
    %tmp11 = load i32, i32* %v0
    %tmp12 = sub i32 %tmp11, 1
    store i32 %tmp12, i32* %v0
    %tmp13 = load i64, i64* %v1
    %tmp14 = icmp eq i64 %tmp13, 0
    br i1 %tmp14, label %then2, label %endif2
then2:
    br label %loop_body1_exit
    br label %endif2
endif2:
    br label %loop_body1
loop_body1_exit:
    %tmp15 = getelementptr inbounds i8, i8* %tmp0, i64 21
    store i8 10, i8* %tmp15
    %tmp16 = load i32, i32* %v0
    %tmp17 = add i32 %tmp16, 1
    %tmp18 = getelementptr inbounds i8, i8* %tmp0, i32 %tmp17
    %tmp19 = trunc i64 21 to i32
    %tmp20 = load i32, i32* %v0
    %tmp21 = sub i32 %tmp19, %tmp20
    call void @console.write(i8* %tmp18, i32 %tmp21)
    ret void
}
define void @"console.println_f64"(double %n){
    %v0 = alloca double; var: mut_n
    %v1 = alloca double; var: rounder
    %v2 = alloca i32; var: i
    %v3 = alloca double; var: fractional_part
    %v4 = alloca i8*; var: buffer
    %v5 = alloca i32; var: i
    %v6 = alloca i64; var: temp_int
    %v7 = alloca i8*; var: start_ptr
    %v8 = alloca i32; var: len
    %v9 = alloca i32; var: i
    %v10 = alloca i64; var: digit
    store double %n, double* %v0
    %tmp1 = fcmp olt double %n, 0x0
    br i1 %tmp1, label %then0, label %endif0
then0:
    call void @console.print_char(i8 45)
    %tmp2 = load double, double* %v0
    %tmp3 = fsub double 0.0, %tmp2
    store double %tmp3, double* %v0
    br label %endif0
endif0:
    store double 0x3FE0000000000000, double* %v1
    store i32 0, i32* %v2
    br label %loop_body1
loop_body1:
    %tmp5 = load i32, i32* %v2
    %tmp6 = icmp sge i32 %tmp5, 6
    br i1 %tmp6, label %then2, label %endif2
then2:
    br label %loop_body1_exit
    br label %endif2
endif2:
    %tmp7 = load double, double* %v1
    %tmp9 = fdiv double %tmp7, 0x4024000000000000
    store double %tmp9, double* %v1
    %tmp10 = load i32, i32* %v2
    %tmp11 = add i32 %tmp10, 1
    store i32 %tmp11, i32* %v2
    br label %loop_body1
loop_body1_exit:
    %tmp12 = load double, double* %v0
    %tmp13 = load double, double* %v1
    %tmp14 = fadd double %tmp12, %tmp13
    store double %tmp14, double* %v0
    %tmp15 = load double, double* %v0
    %tmp16 = fptoui double %tmp15 to i64
    %tmp17 = load double, double* %v0
    %tmp18 = uitofp i64 %tmp16 to double
    %tmp19 = fsub double %tmp17, %tmp18
    store double %tmp19, double* %v3
    %tmp20 = icmp eq i64 %tmp16, 0
    br i1 %tmp20, label %then3, label %else3
then3:
    call void @console.print_char(i8 48)
    br label %endif3
else3:
    %tmp21 = alloca i8, i64 21
    store i8* %tmp21, i8** %v4
    store i32 20, i32* %v5
    store i64 %tmp16, i64* %v6
    br label %loop_body4
loop_body4:
    %tmp22 = load i8*, i8** %v4
    %tmp23 = load i32, i32* %v5
    %tmp24 = getelementptr inbounds i8, i8* %tmp22, i32 %tmp23
    %tmp25 = load i64, i64* %v6
    %tmp26 = urem i64 %tmp25, 10
    %tmp27 = trunc i64 %tmp26 to i8
    %tmp28 = add i8 %tmp27, 48
    store i8 %tmp28, i8* %tmp24
    %tmp29 = load i64, i64* %v6
    %tmp30 = udiv i64 %tmp29, 10
    store i64 %tmp30, i64* %v6
    %tmp31 = load i32, i32* %v5
    %tmp32 = sub i32 %tmp31, 1
    store i32 %tmp32, i32* %v5
    %tmp33 = load i64, i64* %v6
    %tmp34 = icmp eq i64 %tmp33, 0
    br i1 %tmp34, label %then5, label %endif5
then5:
    br label %loop_body4_exit
    br label %endif5
endif5:
    br label %loop_body4
loop_body4_exit:
    %tmp35 = load i8*, i8** %v4
    %tmp36 = load i32, i32* %v5
    %tmp37 = add i32 %tmp36, 1
    %tmp38 = getelementptr inbounds i8, i8* %tmp35, i32 %tmp37
    store i8* %tmp38, i8** %v7
    %tmp39 = trunc i64 20 to i32
    %tmp40 = load i32, i32* %v5
    %tmp41 = sub i32 %tmp39, %tmp40
    store i32 %tmp41, i32* %v8
    %tmp42 = load i8*, i8** %v7
    %tmp43 = load i32, i32* %v8
    call void @console.write(i8* %tmp42, i32 %tmp43)
    br label %endif3
endif3:
    call void @console.print_char(i8 46)
    store i32 0, i32* %v9
    br label %loop_body6
loop_body6:
    %tmp44 = load i32, i32* %v9
    %tmp45 = icmp sge i32 %tmp44, 6
    br i1 %tmp45, label %then7, label %endif7
then7:
    br label %loop_body6_exit
    br label %endif7
endif7:
    %tmp46 = load double, double* %v3
    %tmp48 = fmul double %tmp46, 0x4024000000000000
    store double %tmp48, double* %v3
    %tmp49 = load double, double* %v3
    %tmp50 = fptoui double %tmp49 to i64
    store i64 %tmp50, i64* %v10
    %tmp51 = load i64, i64* %v10
    %tmp52 = trunc i64 %tmp51 to i8
    %tmp53 = add i8 %tmp52, 48
    call void @console.print_char(i8 %tmp53)
    %tmp54 = load double, double* %v3
    %tmp55 = load i64, i64* %v10
    %tmp56 = uitofp i64 %tmp55 to double
    %tmp57 = fsub double %tmp54, %tmp56
    store double %tmp57, double* %v3
    %tmp58 = load i32, i32* %v9
    %tmp59 = add i32 %tmp58, 1
    store i32 %tmp59, i32* %v9
    br label %loop_body6
loop_body6_exit:
    call void @console.print_char(i8 10)
    ret void
}
define %struct.string.String @"string.from_c_string"(i8* %c_string){
    %v0 = alloca %struct.string.String; var: x
    %tmp0 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
    %tmp1 = call i32 @string_utils.c_str_len(i8* %c_string)
    store i32 %tmp1, i32* %tmp0
    %tmp2 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
    %tmp3 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
    %tmp4 = load i32, i32* %tmp3
    %tmp5 = add i32 %tmp4, 1
    %tmp6 = sext i32 %tmp5 to i64
    %tmp7 = mul i64 %tmp6, 1
    %tmp8 = call i8* @mem.malloc(i64 %tmp7)
    %tmp9 = bitcast i8* %tmp8 to i8*
    store i8* %tmp9, i8** %tmp2
    %tmp10 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
    %tmp11 = load i8*, i8** %tmp10
    %tmp12 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
    %tmp13 = load i32, i32* %tmp12
    %tmp14 = sext i32 %tmp13 to i64
    call void @mem.copy(i8* %c_string, i8* %tmp11, i64 %tmp14)
    %tmp15 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
    %tmp16 = load i8*, i8** %tmp15
    %tmp17 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
    %tmp18 = load i32, i32* %tmp17
    %tmp19 = getelementptr inbounds i8, i8* %tmp16, i32 %tmp18
    store i8 0, i8* %tmp19
    %tmp20 = load %struct.string.String, %struct.string.String* %v0
    ret %struct.string.String %tmp20
}
define %struct.string.String @"string.empty"(){
    %v0 = alloca %struct.string.String; var: x
    %tmp0 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
    store i8* null, i8** %tmp0
    %tmp1 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
    store i32 0, i32* %tmp1
    %tmp2 = load %struct.string.String, %struct.string.String* %v0
    ret %struct.string.String %tmp2
}
define %struct.string.String @"string.with_size"(i32 %size){
    %v0 = alloca %struct.string.String; var: x
    %tmp0 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
    store i32 %size, i32* %tmp0
    %tmp1 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
    %tmp2 = add i32 %size, 1
    %tmp3 = sext i32 %tmp2 to i64
    %tmp4 = mul i64 %tmp3, 1
    %tmp5 = call i8* @mem.malloc(i64 %tmp4)
    %tmp6 = bitcast i8* %tmp5 to i8*
    store i8* %tmp6, i8** %tmp1
    %tmp7 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
    %tmp8 = load i8*, i8** %tmp7
    %tmp9 = add i32 %size, 1
    %tmp10 = sext i32 %tmp9 to i64
    call void @mem.zero_fill(i8* %tmp8, i64 %tmp10)
    %tmp11 = load %struct.string.String, %struct.string.String* %v0
    ret %struct.string.String %tmp11
}
define %struct.string.String @"string.clone"(%struct.string.String* %src){
    %v0 = alloca %struct.string.String; var: x
    %tmp0 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
    %tmp1 = getelementptr inbounds %struct.string.String, %struct.string.String* %src, i32 0, i32 1
    %tmp2 = load i32, i32* %tmp1
    store i32 %tmp2, i32* %tmp0
    %tmp3 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
    %tmp4 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
    %tmp5 = load i32, i32* %tmp4
    %tmp6 = add i32 %tmp5, 1
    %tmp7 = sext i32 %tmp6 to i64
    %tmp8 = mul i64 %tmp7, 1
    %tmp9 = call i8* @mem.malloc(i64 %tmp8)
    %tmp10 = bitcast i8* %tmp9 to i8*
    store i8* %tmp10, i8** %tmp3
    %tmp11 = getelementptr inbounds %struct.string.String, %struct.string.String* %src, i32 0, i32 0
    %tmp12 = load i8*, i8** %tmp11
    %tmp13 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
    %tmp14 = load i8*, i8** %tmp13
    %tmp15 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
    %tmp16 = load i32, i32* %tmp15
    %tmp17 = sext i32 %tmp16 to i64
    call void @mem.copy(i8* %tmp12, i8* %tmp14, i64 %tmp17)
    %tmp18 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
    %tmp19 = load i8*, i8** %tmp18
    %tmp20 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
    %tmp21 = load i32, i32* %tmp20
    %tmp22 = getelementptr inbounds i8, i8* %tmp19, i32 %tmp21
    store i8 0, i8* %tmp22
    %tmp23 = load %struct.string.String, %struct.string.String* %v0
    ret %struct.string.String %tmp23
}
define %struct.string.String @"string.concat_with_c_string"(%struct.string.String* %src_string, i8* %c_string){
    %v0 = alloca %struct.string.String; var: str
    %tmp0 = call i32 @string_utils.c_str_len(i8* %c_string)
    %tmp1 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 1
    %tmp2 = load i32, i32* %tmp1
    %tmp3 = add i32 %tmp0, %tmp2
    %tmp4 = add i32 %tmp3, 1
    %tmp5 = sext i32 %tmp4 to i64
    %tmp6 = mul i64 %tmp5, 1
    %tmp7 = call i8* @mem.malloc(i64 %tmp6)
    %tmp8 = bitcast i8* %tmp7 to i8*
    %tmp9 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 0
    %tmp10 = load i8*, i8** %tmp9
    %tmp11 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 1
    %tmp12 = load i32, i32* %tmp11
    %tmp13 = sext i32 %tmp12 to i64
    call void @mem.copy(i8* %tmp10, i8* %tmp8, i64 %tmp13)
    %tmp14 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 1
    %tmp15 = load i32, i32* %tmp14
    %tmp16 = sext i32 %tmp15 to i64
    %tmp17 = getelementptr i8, i8* %tmp8, i64 %tmp16
    %tmp18 = sext i32 %tmp0 to i64
    call void @mem.copy(i8* %c_string, i8* %tmp17, i64 %tmp18)
    %tmp19 = getelementptr inbounds i8, i8* %tmp8, i32 %tmp3
    store i8 0, i8* %tmp19
    %tmp20 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
    store i8* %tmp8, i8** %tmp20
    %tmp21 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
    store i32 %tmp3, i32* %tmp21
    %tmp22 = load %struct.string.String, %struct.string.String* %v0
    ret %struct.string.String %tmp22
}
define i1 @"string.equal"(%struct.string.String* %first, %struct.string.String* %second){
    %tmp0 = getelementptr inbounds %struct.string.String, %struct.string.String* %first, i32 0, i32 1
    %tmp1 = load i32, i32* %tmp0
    %tmp2 = getelementptr inbounds %struct.string.String, %struct.string.String* %second, i32 0, i32 1
    %tmp3 = load i32, i32* %tmp2
    %tmp4 = icmp ne i32 %tmp1, %tmp3
    br i1 %tmp4, label %then0, label %endif0
then0:
    ret i1 0
    br label %endif0
endif0:
    %tmp5 = getelementptr inbounds %struct.string.String, %struct.string.String* %first, i32 0, i32 0
    %tmp6 = load i8*, i8** %tmp5
    %tmp7 = getelementptr inbounds %struct.string.String, %struct.string.String* %second, i32 0, i32 0
    %tmp8 = load i8*, i8** %tmp7
    %tmp9 = getelementptr inbounds %struct.string.String, %struct.string.String* %first, i32 0, i32 1
    %tmp10 = load i32, i32* %tmp9
    %tmp11 = sext i32 %tmp10 to i64
    %tmp12 = call i32 @mem.compare(i8* %tmp6, i8* %tmp8, i64 %tmp11)
    %tmp13 = icmp eq i32 %tmp12, 0
    ret i1 %tmp13
}
define void @"string.free"(%struct.string.String* %str){
    %tmp0 = getelementptr inbounds %struct.string.String, %struct.string.String* %str, i32 0, i32 0
    %tmp1 = load i8*, i8** %tmp0
    %tmp2 = bitcast i8* %tmp1 to i8*
    call void @mem.free(i8* %tmp2)
    %tmp3 = getelementptr inbounds %struct.string.String, %struct.string.String* %str, i32 0, i32 1
    store i32 0, i32* %tmp3
    ret void
}
define i8* @"string_utils.insert"(i8* %src1, i8* %src2, i32 %index){
    %tmp0 = call i32 @string_utils.c_str_len(i8* %src1)
    %tmp1 = call i32 @string_utils.c_str_len(i8* %src2)
    %tmp2 = add i32 %tmp0, %tmp1
    %tmp3 = add i32 %tmp2, 1
    %tmp4 = sext i32 %tmp3 to i64
    %tmp5 = call i8* @mem.malloc(i64 %tmp4)
    %tmp6 = bitcast i8* %tmp5 to i8*
    %tmp7 = sext i32 %index to i64
    call void @mem.copy(i8* %src1, i8* %tmp6, i64 %tmp7)
    %tmp8 = getelementptr i8, i8* %tmp6, i32 %index
    %tmp9 = sext i32 %tmp1 to i64
    call void @mem.copy(i8* %src2, i8* %tmp8, i64 %tmp9)
    %tmp10 = getelementptr i8, i8* %src1, i32 %index
    %tmp11 = getelementptr i8, i8* %tmp6, i32 %index
    %tmp12 = getelementptr i8, i8* %tmp11, i32 %tmp1
    %tmp13 = sub i32 %tmp0, %index
    %tmp14 = sext i32 %tmp13 to i64
    call void @mem.copy(i8* %tmp10, i8* %tmp12, i64 %tmp14)
    %tmp15 = add i32 %tmp0, %tmp1
    %tmp16 = getelementptr inbounds i8, i8* %tmp6, i32 %tmp15
    store i8 0, i8* %tmp16
    ret i8* %tmp6
}
define i32 @"string_utils.c_str_len"(i8* %str){
    %v0 = alloca i32; var: len
    store i32 0, i32* %v0
    br label %loop_body0
loop_body0:
    %tmp0 = load i32, i32* %v0
    %tmp1 = getelementptr inbounds i8, i8* %str, i32 %tmp0
    %tmp2 = load i8, i8* %tmp1
    %tmp3 = icmp eq i8 %tmp2, 0
    br i1 %tmp3, label %then1, label %endif1
then1:
    br label %loop_body0_exit
    br label %endif1
endif1:
    %tmp4 = load i32, i32* %v0
    %tmp5 = add i32 %tmp4, 1
    store i32 %tmp5, i32* %v0
    br label %loop_body0
loop_body0_exit:
    %tmp6 = load i32, i32* %v0
    ret i32 %tmp6
}
define i1 @"string_utils.is_ascii_num"(i8 %char){
    %tmp0 = icmp sge i8 %char, 48
    %tmp1 = icmp sle i8 %char, 57
    %tmp2 = and i1 %tmp0, %tmp1
    ret i1 %tmp2
}
define i1 @"string_utils.is_ascii_char"(i8 %char){
    %tmp0 = icmp sge i8 %char, 65
    %tmp1 = icmp sle i8 %char, 90
    %tmp2 = and i1 %tmp0, %tmp1
    %tmp3 = icmp sge i8 %char, 97
    %tmp4 = icmp sle i8 %char, 122
    %tmp5 = and i1 %tmp3, %tmp4
    %tmp6 = or i1 %tmp2, %tmp5
    ret i1 %tmp6
}
define i1 @"string_utils.is_ascii_hex"(i8 %char){
    %tmp0 = icmp sge i8 %char, 48
    %tmp1 = icmp sle i8 %char, 57
    %tmp2 = and i1 %tmp0, %tmp1
    %tmp3 = icmp sge i8 %char, 65
    %tmp4 = icmp sle i8 %char, 70
    %tmp5 = and i1 %tmp3, %tmp4
    %tmp6 = or i1 %tmp2, %tmp5
    %tmp7 = icmp sge i8 %char, 97
    %tmp8 = icmp sle i8 %char, 102
    %tmp9 = and i1 %tmp7, %tmp8
    %tmp10 = or i1 %tmp6, %tmp9
    ret i1 %tmp10
}
define i32 @"fs.write_to_file"(i8* %path, i8* %content, i32 %content_len){
    %v0 = alloca i32; var: bytes_written
    %tmp0 = call i8* @CreateFileA(i8* %path, i32 1073741824, i32 0, i8* null, i32 2, i32 128, i8* null)
    %tmp1 = inttoptr i64 -1 to i8*
    %tmp2 = icmp eq ptr %tmp0, %tmp1
    br i1 %tmp2, label %then0, label %endif0
then0:
    ret i32 0
    br label %endif0
endif0:
    store i32 0, i32* %v0
    %tmp3 = call i32 @WriteFile(i8* %tmp0, i8* %content, i32 %content_len, i32* %v0, i8* null)
    call i32 @CloseHandle(i8* %tmp0)
    %tmp4 = icmp ne i32 %tmp3, 0
    %tmp5 = load i32, i32* %v0
    %tmp6 = icmp eq i32 %tmp5, %content_len
    %tmp7 = and i1 %tmp4, %tmp6
    %tmp8 = zext i1 %tmp7 to i32
    ret i32 %tmp8
}
define %struct.string.String @"fs.read_full_file_as_string"(i8* %path){
    %v0 = alloca i64; var: file_size
    %v1 = alloca %struct.string.String; var: buffer
    %v2 = alloca i32; var: bytes_read
    %tmp0 = call i8* @CreateFileA(i8* %path, i32 2147483648, i32 1, i8* null, i32 3, i32 128, i8* null)
    %tmp1 = inttoptr i64 -1 to i8*
    %tmp2 = icmp eq ptr %tmp0, %tmp1
    br i1 %tmp2, label %then0, label %endif0
then0:
    %tmp3 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.6, i64 0, i64 0
    %tmp4 = call i8* @string_utils.insert(i8* %tmp3, i8* %path, i32 16)
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
    ret %struct.string.String %tmp7
    br label %endif1
endif1:
    %tmp8 = load i64, i64* %v0
    %tmp9 = trunc i64 %tmp8 to i32
    %tmp10 = call %struct.string.String @string.with_size(i32 %tmp9)
    store %struct.string.String %tmp10, %struct.string.String* %v1
    store i32 0, i32* %v2
    %tmp11 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 0
    %tmp12 = load i8*, i8** %tmp11
    %tmp13 = load i64, i64* %v0
    %tmp14 = trunc i64 %tmp13 to i32
    %tmp15 = call i32 @ReadFile(i8* %tmp0, i8* %tmp12, i32 %tmp14, i32* %v2, i8* null)
    call i32 @CloseHandle(i8* %tmp0)
    %tmp16 = icmp eq i32 %tmp15, 0
    br i1 %tmp16, label %then2, label %endif2
then2:
    call void @string.free(%struct.string.String* %v1)
    %tmp17 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.7, i64 0, i64 0
    call void @process.throw(i8* %tmp17)
    br label %endif2
endif2:
    %tmp18 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 1
    %tmp19 = load i64, i64* %v0
    %tmp20 = trunc i64 %tmp19 to i32
    store i32 %tmp20, i32* %tmp18
    %tmp21 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 0
    %tmp22 = load i8*, i8** %tmp21
    %tmp23 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 1
    %tmp24 = load i32, i32* %tmp23
    %tmp25 = getelementptr inbounds i8, i8* %tmp22, i32 %tmp24
    store i8 0, i8* %tmp25
    %tmp26 = load %struct.string.String, %struct.string.String* %v1
    ret %struct.string.String %tmp26
}
define i32 @"fs.create_file"(i8* %path){
    %tmp0 = call i8* @CreateFileA(i8* %path, i32 1073741824, i32 0, i8* null, i32 1, i32 128, i8* null)
    %tmp1 = inttoptr i64 -1 to i8*
    %tmp2 = icmp eq ptr %tmp0, %tmp1
    br i1 %tmp2, label %then0, label %endif0
then0:
    ret i32 0
    br label %endif0
endif0:
    call i32 @CloseHandle(i8* %tmp0)
    ret i32 1
}
define i32 @"fs.delete_file"(i8* %path){
    %tmp0 = call i32 @DeleteFileA(i8* %path)
    ret i32 %tmp0
}
define i1 @"fs.file_exists"(i8* %path){
    %tmp0 = call i32 @GetFileAttributesA(i8* %path)
    %tmp1 = icmp ne i32 %tmp0, 4294967295
    ret i1 %tmp1
}
define void @"tests.run"(){
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
    %tmp3 = getelementptr inbounds [20 x i8], [20 x i8]* @.str.8, i64 0, i64 0
    call void @console.write(i8* %tmp3, i32 19)
    call void @console.println_i64(i64 %tmp2)
    ret void
}
define void @"tests.mem_test"(){
    %v0 = alloca i64; var: i
    %v1 = alloca i64; var: i
    %tmp0 = getelementptr inbounds [11 x i8], [11 x i8]* @.str.9, i64 0, i64 0
    call void @console.write(i8* %tmp0, i32 10)
    %tmp1 = call i8* @mem.malloc(i64 16)
    %tmp2 = bitcast i8* %tmp1 to i8*
    %tmp3 = icmp eq ptr %tmp2, null
    br i1 %tmp3, label %then0, label %endif0
then0:
    %tmp4 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.10, i64 0, i64 0
    call void @process.throw(i8* %tmp4)
    br label %endif0
endif0:
    call void @mem.fill(i8 88, i8* %tmp2, i64 16)
    store i64 0, i64* %v0
    br label %loop_body1
loop_body1:
    %tmp5 = load i64, i64* %v0
    %tmp6 = icmp sge i64 %tmp5, 16
    br i1 %tmp6, label %then2, label %endif2
then2:
    br label %loop_body1_exit
    br label %endif2
endif2:
    %tmp7 = load i64, i64* %v0
    %tmp8 = getelementptr inbounds i8, i8* %tmp2, i64 %tmp7
    %tmp9 = load i8, i8* %tmp8
    %tmp10 = icmp ne i8 %tmp9, 88
    br i1 %tmp10, label %then3, label %endif3
then3:
    %tmp11 = getelementptr inbounds [35 x i8], [35 x i8]* @.str.11, i64 0, i64 0
    call void @process.throw(i8* %tmp11)
    br label %endif3
endif3:
    %tmp12 = load i64, i64* %v0
    %tmp13 = add i64 %tmp12, 1
    store i64 %tmp13, i64* %v0
    br label %loop_body1
loop_body1_exit:
    call void @mem.zero_fill(i8* %tmp2, i64 16)
    store i64 0, i64* %v1
    br label %loop_body4
loop_body4:
    %tmp14 = load i64, i64* %v1
    %tmp15 = icmp sge i64 %tmp14, 16
    br i1 %tmp15, label %then5, label %endif5
then5:
    br label %loop_body4_exit
    br label %endif5
endif5:
    %tmp16 = load i64, i64* %v1
    %tmp17 = getelementptr inbounds i8, i8* %tmp2, i64 %tmp16
    %tmp18 = load i8, i8* %tmp17
    %tmp19 = icmp ne i8 %tmp18, 0
    br i1 %tmp19, label %then6, label %endif6
then6:
    %tmp20 = getelementptr inbounds [40 x i8], [40 x i8]* @.str.12, i64 0, i64 0
    call void @process.throw(i8* %tmp20)
    br label %endif6
endif6:
    %tmp21 = load i64, i64* %v1
    %tmp22 = add i64 %tmp21, 1
    store i64 %tmp22, i64* %v1
    br label %loop_body4
loop_body4_exit:
    %tmp23 = call i8* @mem.malloc(i64 16)
    %tmp24 = bitcast i8* %tmp23 to i8*
    %tmp25 = icmp eq ptr %tmp24, null
    br i1 %tmp25, label %then7, label %endif7
then7:
    %tmp26 = getelementptr inbounds [33 x i8], [33 x i8]* @.str.13, i64 0, i64 0
    call void @process.throw(i8* %tmp26)
    br label %endif7
endif7:
    call void @mem.fill(i8 89, i8* %tmp24, i64 16)
    call void @mem.copy(i8* %tmp24, i8* %tmp2, i64 16)
    store i64 0, i64* %v1
    br label %loop_body8
loop_body8:
    %tmp27 = load i64, i64* %v1
    %tmp28 = icmp sge i64 %tmp27, 16
    br i1 %tmp28, label %then9, label %endif9
then9:
    br label %loop_body8_exit
    br label %endif9
endif9:
    %tmp29 = load i64, i64* %v1
    %tmp30 = getelementptr inbounds i8, i8* %tmp2, i64 %tmp29
    %tmp31 = load i8, i8* %tmp30
    %tmp32 = icmp ne i8 %tmp31, 89
    br i1 %tmp32, label %then10, label %endif10
then10:
    %tmp33 = getelementptr inbounds [35 x i8], [35 x i8]* @.str.14, i64 0, i64 0
    call void @process.throw(i8* %tmp33)
    br label %endif10
endif10:
    %tmp34 = load i64, i64* %v1
    %tmp35 = add i64 %tmp34, 1
    store i64 %tmp35, i64* %v1
    br label %loop_body8
loop_body8_exit:
    %tmp36 = bitcast i8* %tmp2 to i8*
    call void @mem.free(i8* %tmp36)
    %tmp37 = bitcast i8* %tmp24 to i8*
    call void @mem.free(i8* %tmp37)
    %tmp38 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.15, i64 0, i64 0
    call void @console.writeln(i8* %tmp38, i32 2)
    ret void
}
define void @"tests.string_utils_test"(){
    %v0 = alloca i32; var: i
    %tmp0 = getelementptr inbounds [20 x i8], [20 x i8]* @.str.16, i64 0, i64 0
    call void @console.write(i8* %tmp0, i32 19)
    %tmp1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.17, i64 0, i64 0
    %tmp2 = call i32 @string_utils.c_str_len(i8* %tmp1)
    %tmp3 = icmp ne i32 %tmp2, 4
    br i1 %tmp3, label %then0, label %endif0
then0:
    %tmp4 = getelementptr inbounds [36 x i8], [36 x i8]* @.str.18, i64 0, i64 0
    call void @process.throw(i8* %tmp4)
    br label %endif0
endif0:
    %tmp5 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.19, i64 0, i64 0
    %tmp6 = call i32 @string_utils.c_str_len(i8* %tmp5)
    %tmp7 = icmp ne i32 %tmp6, 0
    br i1 %tmp7, label %then1, label %endif1
then1:
    %tmp8 = getelementptr inbounds [42 x i8], [42 x i8]* @.str.20, i64 0, i64 0
    call void @process.throw(i8* %tmp8)
    br label %endif1
endif1:
    %tmp9 = call i1 @string_utils.is_ascii_num(i8 55)
    %tmp10 = xor i1 %tmp9, 1
    %tmp11 = call i1 @string_utils.is_ascii_num(i8 98)
    %tmp12 = or i1 %tmp10, %tmp11
    br i1 %tmp12, label %then2, label %endif2
then2:
    %tmp13 = getelementptr inbounds [39 x i8], [39 x i8]* @.str.21, i64 0, i64 0
    call void @process.throw(i8* %tmp13)
    br label %endif2
endif2:
    %tmp14 = call i1 @string_utils.is_ascii_char(i8 97)
    %tmp15 = xor i1 %tmp14, 1
    %tmp16 = call i1 @string_utils.is_ascii_char(i8 57)
    %tmp17 = or i1 %tmp15, %tmp16
    br i1 %tmp17, label %then3, label %endif3
then3:
    %tmp18 = getelementptr inbounds [40 x i8], [40 x i8]* @.str.22, i64 0, i64 0
    call void @process.throw(i8* %tmp18)
    br label %endif3
endif3:
    %tmp19 = call i1 @string_utils.is_ascii_hex(i8 70)
    %tmp20 = xor i1 %tmp19, 1
    %tmp21 = call i1 @string_utils.is_ascii_hex(i8 71)
    %tmp22 = or i1 %tmp20, %tmp21
    br i1 %tmp22, label %then4, label %endif4
then4:
    %tmp23 = getelementptr inbounds [39 x i8], [39 x i8]* @.str.23, i64 0, i64 0
    call void @process.throw(i8* %tmp23)
    br label %endif4
endif4:
    %tmp24 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.24, i64 0, i64 0
    %tmp25 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.25, i64 0, i64 0
    %tmp26 = call i8* @string_utils.insert(i8* %tmp24, i8* %tmp25, i32 1)
    %tmp27 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.26, i64 0, i64 0
    store i32 0, i32* %v0
    br label %loop_body5
loop_body5:
    %tmp28 = load i32, i32* %v0
    %tmp29 = getelementptr inbounds i8, i8* %tmp26, i32 %tmp28
    %tmp30 = load i8, i8* %tmp29
    %tmp31 = icmp eq i8 %tmp30, 0
    %tmp32 = load i32, i32* %v0
    %tmp33 = getelementptr inbounds i8, i8* %tmp27, i32 %tmp32
    %tmp34 = load i8, i8* %tmp33
    %tmp35 = icmp eq i8 %tmp34, 0
    %tmp36 = and i1 %tmp31, %tmp35
    br i1 %tmp36, label %then6, label %endif6
then6:
    br label %loop_body5_exit
    br label %endif6
endif6:
    %tmp37 = load i32, i32* %v0
    %tmp38 = getelementptr inbounds i8, i8* %tmp26, i32 %tmp37
    %tmp39 = load i8, i8* %tmp38
    %tmp40 = load i32, i32* %v0
    %tmp41 = getelementptr inbounds i8, i8* %tmp27, i32 %tmp40
    %tmp42 = load i8, i8* %tmp41
    %tmp43 = icmp ne i8 %tmp39, %tmp42
    br i1 %tmp43, label %then7, label %endif7
then7:
    %tmp44 = getelementptr inbounds [33 x i8], [33 x i8]* @.str.27, i64 0, i64 0
    call void @process.throw(i8* %tmp44)
    br label %endif7
endif7:
    %tmp45 = load i32, i32* %v0
    %tmp46 = add i32 %tmp45, 1
    store i32 %tmp46, i32* %v0
    br label %loop_body5
loop_body5_exit:
    %tmp47 = bitcast i8* %tmp26 to i8*
    call void @mem.free(i8* %tmp47)
    %tmp48 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.15, i64 0, i64 0
    call void @console.writeln(i8* %tmp48, i32 2)
    ret void
}
define void @"tests.string_test"(){
    %v0 = alloca %struct.string.String; var: s1
    %v1 = alloca %struct.string.String; var: s2
    %v2 = alloca %struct.string.String; var: s3
    %v3 = alloca %struct.string.String; var: s4
    %v4 = alloca %struct.string.String; var: s5
    %tmp0 = getelementptr inbounds [14 x i8], [14 x i8]* @.str.28, i64 0, i64 0
    call void @console.write(i8* %tmp0, i32 13)
    %tmp1 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.29, i64 0, i64 0
    %tmp2 = call %struct.string.String @string.from_c_string(i8* %tmp1)
    store %struct.string.String %tmp2, %struct.string.String* %v0
    %tmp3 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.29, i64 0, i64 0
    %tmp4 = call %struct.string.String @string.from_c_string(i8* %tmp3)
    store %struct.string.String %tmp4, %struct.string.String* %v1
    %tmp5 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.30, i64 0, i64 0
    %tmp6 = call %struct.string.String @string.from_c_string(i8* %tmp5)
    store %struct.string.String %tmp6, %struct.string.String* %v2
    %tmp7 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
    %tmp8 = load i32, i32* %tmp7
    %tmp9 = icmp ne i32 %tmp8, 5
    br i1 %tmp9, label %then0, label %endif0
then0:
    %tmp10 = getelementptr inbounds [41 x i8], [41 x i8]* @.str.31, i64 0, i64 0
    call void @process.throw(i8* %tmp10)
    br label %endif0
endif0:
    %tmp11 = call i1 @string.equal(%struct.string.String* %v0, %struct.string.String* %v1)
    %tmp12 = xor i1 %tmp11, 1
    br i1 %tmp12, label %then1, label %endif1
then1:
    %tmp13 = getelementptr inbounds [40 x i8], [40 x i8]* @.str.32, i64 0, i64 0
    call void @process.throw(i8* %tmp13)
    br label %endif1
endif1:
    %tmp14 = call i1 @string.equal(%struct.string.String* %v0, %struct.string.String* %v2)
    br i1 %tmp14, label %then2, label %endif2
then2:
    %tmp15 = getelementptr inbounds [40 x i8], [40 x i8]* @.str.33, i64 0, i64 0
    call void @process.throw(i8* %tmp15)
    br label %endif2
endif2:
    %tmp16 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.34, i64 0, i64 0
    %tmp17 = call %struct.string.String @string.concat_with_c_string(%struct.string.String* %v0, i8* %tmp16)
    store %struct.string.String %tmp17, %struct.string.String* %v3
    %tmp18 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.35, i64 0, i64 0
    %tmp19 = call %struct.string.String @string.from_c_string(i8* %tmp18)
    store %struct.string.String %tmp19, %struct.string.String* %v4
    %tmp20 = getelementptr inbounds %struct.string.String, %struct.string.String* %v3, i32 0, i32 1
    %tmp21 = load i32, i32* %tmp20
    %tmp22 = icmp ne i32 %tmp21, 11
    br i1 %tmp22, label %then3, label %endif3
then3:
    %tmp23 = getelementptr inbounds [34 x i8], [34 x i8]* @.str.36, i64 0, i64 0
    call void @process.throw(i8* %tmp23)
    br label %endif3
endif3:
    %tmp24 = call i1 @string.equal(%struct.string.String* %v3, %struct.string.String* %v4)
    %tmp25 = xor i1 %tmp24, 1
    br i1 %tmp25, label %then4, label %endif4
then4:
    %tmp26 = getelementptr inbounds [35 x i8], [35 x i8]* @.str.37, i64 0, i64 0
    call void @process.throw(i8* %tmp26)
    br label %endif4
endif4:
    call void @string.free(%struct.string.String* %v0)
    call void @string.free(%struct.string.String* %v1)
    call void @string.free(%struct.string.String* %v2)
    call void @string.free(%struct.string.String* %v3)
    call void @string.free(%struct.string.String* %v4)
    %tmp27 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.15, i64 0, i64 0
    call void @console.writeln(i8* %tmp27, i32 2)
    ret void
}
define void @"tests.vector_test"(){
    %v0 = alloca %"struct.vector.Vec<i8>"; var: v
    %tmp0 = getelementptr inbounds [14 x i8], [14 x i8]* @.str.38, i64 0, i64 0
    call void @console.write(i8* %tmp0, i32 13)
    %tmp1 = call %"struct.vector.Vec<i8>" @"vector.new<i8>"()
    store %"struct.vector.Vec<i8>" %tmp1, %"struct.vector.Vec<i8>"* %v0
    %tmp2 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 1
    %tmp3 = load i32, i32* %tmp2
    %tmp4 = icmp ne i32 %tmp3, 0
    %tmp5 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 2
    %tmp6 = load i32, i32* %tmp5
    %tmp7 = icmp ne i32 %tmp6, 0
    %tmp8 = or i1 %tmp4, %tmp7
    br i1 %tmp8, label %then0, label %endif0
then0:
    %tmp9 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.39, i64 0, i64 0
    call void @process.throw(i8* %tmp9)
    br label %endif0
endif0:
    call void @"vector.push<i8>"(%"struct.vector.Vec<i8>"* %v0, i8 10)
    call void @"vector.push<i8>"(%"struct.vector.Vec<i8>"* %v0, i8 20)
    call void @"vector.push<i8>"(%"struct.vector.Vec<i8>"* %v0, i8 30)
    call void @"vector.push<i8>"(%"struct.vector.Vec<i8>"* %v0, i8 40)
    %tmp10 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 1
    %tmp11 = load i32, i32* %tmp10
    %tmp12 = icmp ne i32 %tmp11, 4
    %tmp13 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 2
    %tmp14 = load i32, i32* %tmp13
    %tmp15 = icmp ne i32 %tmp14, 4
    %tmp16 = or i1 %tmp12, %tmp15
    br i1 %tmp16, label %then1, label %endif1
then1:
    %tmp17 = getelementptr inbounds [33 x i8], [33 x i8]* @.str.40, i64 0, i64 0
    call void @process.throw(i8* %tmp17)
    br label %endif1
endif1:
    %tmp18 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 0
    %tmp19 = load i8*, i8** %tmp18
    %tmp20 = getelementptr inbounds i8, i8* %tmp19, i64 0
    %tmp21 = load i8, i8* %tmp20
    %tmp22 = icmp ne i8 %tmp21, 10
    %tmp23 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 0
    %tmp24 = load i8*, i8** %tmp23
    %tmp25 = getelementptr inbounds i8, i8* %tmp24, i64 3
    %tmp26 = load i8, i8* %tmp25
    %tmp27 = icmp ne i8 %tmp26, 40
    %tmp28 = or i1 %tmp22, %tmp27
    br i1 %tmp28, label %then2, label %endif2
then2:
    %tmp29 = getelementptr inbounds [36 x i8], [36 x i8]* @.str.41, i64 0, i64 0
    call void @process.throw(i8* %tmp29)
    br label %endif2
endif2:
    call void @"vector.push<i8>"(%"struct.vector.Vec<i8>"* %v0, i8 50)
    %tmp30 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 1
    %tmp31 = load i32, i32* %tmp30
    %tmp32 = icmp ne i32 %tmp31, 5
    %tmp33 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 2
    %tmp34 = load i32, i32* %tmp33
    %tmp35 = icmp ne i32 %tmp34, 8
    %tmp36 = or i1 %tmp32, %tmp35
    br i1 %tmp36, label %then3, label %endif3
then3:
    %tmp37 = getelementptr inbounds [28 x i8], [28 x i8]* @.str.42, i64 0, i64 0
    call void @process.throw(i8* %tmp37)
    br label %endif3
endif3:
    %tmp38 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 0
    %tmp39 = load i8*, i8** %tmp38
    %tmp40 = getelementptr inbounds i8, i8* %tmp39, i64 4
    %tmp41 = load i8, i8* %tmp40
    %tmp42 = icmp ne i8 %tmp41, 50
    %tmp43 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 0
    %tmp44 = load i8*, i8** %tmp43
    %tmp45 = getelementptr inbounds i8, i8* %tmp44, i64 0
    %tmp46 = load i8, i8* %tmp45
    %tmp47 = icmp ne i8 %tmp46, 10
    %tmp48 = or i1 %tmp42, %tmp47
    br i1 %tmp48, label %then4, label %endif4
then4:
    %tmp49 = getelementptr inbounds [36 x i8], [36 x i8]* @.str.43, i64 0, i64 0
    call void @process.throw(i8* %tmp49)
    br label %endif4
endif4:
    %tmp50 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.44, i64 0, i64 0
    call void @"vector.push_bulk<i8>"(%"struct.vector.Vec<i8>"* %v0, i8* %tmp50, i32 2)
    %tmp51 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 1
    %tmp52 = load i32, i32* %tmp51
    %tmp53 = icmp ne i32 %tmp52, 7
    br i1 %tmp53, label %then5, label %endif5
then5:
    %tmp54 = getelementptr inbounds [37 x i8], [37 x i8]* @.str.45, i64 0, i64 0
    call void @process.throw(i8* %tmp54)
    br label %endif5
endif5:
    %tmp55 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 0
    %tmp56 = load i8*, i8** %tmp55
    %tmp57 = getelementptr inbounds i8, i8* %tmp56, i64 5
    %tmp58 = load i8, i8* %tmp57
    %tmp59 = icmp ne i8 %tmp58, 65
    %tmp60 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 0
    %tmp61 = load i8*, i8** %tmp60
    %tmp62 = getelementptr inbounds i8, i8* %tmp61, i64 6
    %tmp63 = load i8, i8* %tmp62
    %tmp64 = icmp ne i8 %tmp63, 66
    %tmp65 = or i1 %tmp59, %tmp64
    br i1 %tmp65, label %then6, label %endif6
then6:
    %tmp66 = getelementptr inbounds [38 x i8], [38 x i8]* @.str.46, i64 0, i64 0
    call void @process.throw(i8* %tmp66)
    br label %endif6
endif6:
    call void @"vector.free<i8>"(%"struct.vector.Vec<i8>"* %v0)
    %tmp67 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 1
    %tmp68 = load i32, i32* %tmp67
    %tmp69 = icmp ne i32 %tmp68, 0
    %tmp70 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 2
    %tmp71 = load i32, i32* %tmp70
    %tmp72 = icmp ne i32 %tmp71, 0
    %tmp73 = or i1 %tmp69, %tmp72
    %tmp74 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 0
    %tmp75 = load i8*, i8** %tmp74
    %tmp76 = icmp ne ptr %tmp75, null
    %tmp77 = or i1 %tmp73, %tmp76
    br i1 %tmp77, label %then7, label %endif7
then7:
    %tmp78 = getelementptr inbounds [25 x i8], [25 x i8]* @.str.47, i64 0, i64 0
    call void @process.throw(i8* %tmp78)
    br label %endif7
endif7:
    %tmp79 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.15, i64 0, i64 0
    call void @console.writeln(i8* %tmp79, i32 2)
    ret void
}
define void @"tests.list_test"(){
    %v0 = alloca %"struct.list.List<i32>"; var: l
    %v1 = alloca %"struct.list.ListNode<i32>"*; var: current
    %tmp0 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.48, i64 0, i64 0
    call void @console.write(i8* %tmp0, i32 11)
    %tmp1 = call %"struct.list.List<i32>" @"list.new<i32>"()
    store %"struct.list.List<i32>" %tmp1, %"struct.list.List<i32>"* %v0
    %tmp2 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %v0, i32 0, i32 2
    %tmp3 = load i32, i32* %tmp2
    %tmp4 = icmp ne i32 %tmp3, 0
    %tmp5 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %v0, i32 0, i32 0
    %tmp6 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %tmp5
    %tmp7 = icmp ne ptr %tmp6, null
    %tmp8 = or i1 %tmp4, %tmp7
    br i1 %tmp8, label %then0, label %endif0
then0:
    %tmp9 = getelementptr inbounds [22 x i8], [22 x i8]* @.str.49, i64 0, i64 0
    call void @process.throw(i8* %tmp9)
    br label %endif0
endif0:
    call void @"list.extend<i32>"(%"struct.list.List<i32>"* %v0, i32 100)
    call void @"list.extend<i32>"(%"struct.list.List<i32>"* %v0, i32 200)
    call void @"list.extend<i32>"(%"struct.list.List<i32>"* %v0, i32 300)
    %tmp10 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %v0, i32 0, i32 2
    %tmp11 = load i32, i32* %tmp10
    %tmp12 = icmp ne i32 %tmp11, 3
    br i1 %tmp12, label %then1, label %endif1
then1:
    %tmp13 = getelementptr inbounds [41 x i8], [41 x i8]* @.str.50, i64 0, i64 0
    call void @process.throw(i8* %tmp13)
    br label %endif1
endif1:
    %tmp14 = call i32 @"list.walk<i32>"(%"struct.list.List<i32>"* %v0)
    %tmp15 = icmp ne i32 %tmp14, 3
    br i1 %tmp15, label %then2, label %endif2
then2:
    %tmp16 = getelementptr inbounds [33 x i8], [33 x i8]* @.str.51, i64 0, i64 0
    call void @process.throw(i8* %tmp16)
    br label %endif2
endif2:
    %tmp17 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %v0, i32 0, i32 0
    %tmp18 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %tmp17
    store %"struct.list.ListNode<i32>"* %tmp18, %"struct.list.ListNode<i32>"** %v1
    %tmp19 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v1
    %tmp20 = getelementptr inbounds %"struct.list.ListNode<i32>", %"struct.list.ListNode<i32>"* %tmp19, i32 0, i32 0
    %tmp21 = load i32, i32* %tmp20
    %tmp22 = icmp ne i32 %tmp21, 100
    br i1 %tmp22, label %then3, label %endif3
then3:
    %tmp23 = getelementptr inbounds [36 x i8], [36 x i8]* @.str.52, i64 0, i64 0
    call void @process.throw(i8* %tmp23)
    br label %endif3
endif3:
    %tmp24 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v1
    %tmp25 = getelementptr inbounds %"struct.list.ListNode<i32>", %"struct.list.ListNode<i32>"* %tmp24, i32 0, i32 1
    %tmp26 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %tmp25
    store %"struct.list.ListNode<i32>"* %tmp26, %"struct.list.ListNode<i32>"** %v1
    %tmp27 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v1
    %tmp28 = getelementptr inbounds %"struct.list.ListNode<i32>", %"struct.list.ListNode<i32>"* %tmp27, i32 0, i32 0
    %tmp29 = load i32, i32* %tmp28
    %tmp30 = icmp ne i32 %tmp29, 200
    br i1 %tmp30, label %then4, label %endif4
then4:
    %tmp31 = getelementptr inbounds [36 x i8], [36 x i8]* @.str.53, i64 0, i64 0
    call void @process.throw(i8* %tmp31)
    br label %endif4
endif4:
    %tmp32 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v1
    %tmp33 = getelementptr inbounds %"struct.list.ListNode<i32>", %"struct.list.ListNode<i32>"* %tmp32, i32 0, i32 1
    %tmp34 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %tmp33
    store %"struct.list.ListNode<i32>"* %tmp34, %"struct.list.ListNode<i32>"** %v1
    %tmp35 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v1
    %tmp36 = getelementptr inbounds %"struct.list.ListNode<i32>", %"struct.list.ListNode<i32>"* %tmp35, i32 0, i32 0
    %tmp37 = load i32, i32* %tmp36
    %tmp38 = icmp ne i32 %tmp37, 300
    br i1 %tmp38, label %then5, label %endif5
then5:
    %tmp39 = getelementptr inbounds [36 x i8], [36 x i8]* @.str.54, i64 0, i64 0
    call void @process.throw(i8* %tmp39)
    br label %endif5
endif5:
    %tmp40 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v1
    %tmp41 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %v0, i32 0, i32 1
    %tmp42 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %tmp41
    %tmp43 = icmp ne ptr %tmp40, %tmp42
    br i1 %tmp43, label %then6, label %endif6
then6:
    %tmp44 = getelementptr inbounds [33 x i8], [33 x i8]* @.str.55, i64 0, i64 0
    call void @process.throw(i8* %tmp44)
    br label %endif6
endif6:
    call void @"list.free<i32>"(%"struct.list.List<i32>"* %v0)
    %tmp45 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %v0, i32 0, i32 2
    %tmp46 = load i32, i32* %tmp45
    %tmp47 = icmp ne i32 %tmp46, 0
    %tmp48 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %v0, i32 0, i32 0
    %tmp49 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %tmp48
    %tmp50 = icmp ne ptr %tmp49, null
    %tmp51 = or i1 %tmp47, %tmp50
    br i1 %tmp51, label %then7, label %endif7
then7:
    %tmp52 = getelementptr inbounds [23 x i8], [23 x i8]* @.str.56, i64 0, i64 0
    call void @process.throw(i8* %tmp52)
    br label %endif7
endif7:
    %tmp53 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.15, i64 0, i64 0
    call void @console.writeln(i8* %tmp53, i32 2)
    ret void
}
define void @"tests.process_test"(){
    %v0 = alloca %struct.string.String; var: full_path
    %v1 = alloca %struct.string.String; var: env_path
    %tmp0 = getelementptr inbounds [15 x i8], [15 x i8]* @.str.57, i64 0, i64 0
    call void @console.write(i8* %tmp0, i32 14)
    %tmp1 = call %struct.string.String @process.get_executable_path()
    store %struct.string.String %tmp1, %struct.string.String* %v0
    %tmp2 = call %struct.string.String @process.get_executable_env_path()
    store %struct.string.String %tmp2, %struct.string.String* %v1
    %tmp3 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
    %tmp4 = load i32, i32* %tmp3
    %tmp5 = icmp sle i32 %tmp4, 0
    br i1 %tmp5, label %then0, label %endif0
then0:
    %tmp6 = getelementptr inbounds [49 x i8], [49 x i8]* @.str.58, i64 0, i64 0
    call void @process.throw(i8* %tmp6)
    br label %endif0
endif0:
    %tmp7 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 1
    %tmp8 = load i32, i32* %tmp7
    %tmp9 = icmp sle i32 %tmp8, 0
    br i1 %tmp9, label %then1, label %endif1
then1:
    %tmp10 = getelementptr inbounds [53 x i8], [53 x i8]* @.str.59, i64 0, i64 0
    call void @process.throw(i8* %tmp10)
    br label %endif1
endif1:
    %tmp11 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 1
    %tmp12 = load i32, i32* %tmp11
    %tmp13 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
    %tmp14 = load i32, i32* %tmp13
    %tmp15 = icmp sge i32 %tmp12, %tmp14
    br i1 %tmp15, label %then2, label %endif2
then2:
    %tmp16 = getelementptr inbounds [53 x i8], [53 x i8]* @.str.60, i64 0, i64 0
    call void @process.throw(i8* %tmp16)
    br label %endif2
endif2:
    %tmp17 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 0
    %tmp18 = load i8*, i8** %tmp17
    %tmp19 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 1
    %tmp20 = load i32, i32* %tmp19
    %tmp21 = sub i32 %tmp20, 1
    %tmp22 = getelementptr inbounds i8, i8* %tmp18, i32 %tmp21
    %tmp23 = load i8, i8* %tmp22
    %tmp24 = icmp ne i8 %tmp23, 92
    br i1 %tmp24, label %then3, label %endif3
then3:
    %tmp25 = getelementptr inbounds [53 x i8], [53 x i8]* @.str.61, i64 0, i64 0
    call void @process.throw(i8* %tmp25)
    br label %endif3
endif3:
    %tmp26 = getelementptr inbounds [18 x i8], [18 x i8]* @.str.62, i64 0, i64 0
    call void @console.write(i8* %tmp26, i32 17)
    %tmp27 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
    %tmp28 = load i8*, i8** %tmp27
    %tmp29 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
    %tmp30 = load i32, i32* %tmp29
    call void @console.writeln(i8* %tmp28, i32 %tmp30)
    %tmp31 = getelementptr inbounds [19 x i8], [19 x i8]* @.str.63, i64 0, i64 0
    call void @console.write(i8* %tmp31, i32 18)
    %tmp32 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 0
    %tmp33 = load i8*, i8** %tmp32
    %tmp34 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 1
    %tmp35 = load i32, i32* %tmp34
    call void @console.writeln(i8* %tmp33, i32 %tmp35)
    call void @string.free(%struct.string.String* %v0)
    call void @string.free(%struct.string.String* %v1)
    %tmp36 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.15, i64 0, i64 0
    call void @console.writeln(i8* %tmp36, i32 2)
    ret void
}
define void @"tests.console_test"(){
    %tmp0 = getelementptr inbounds [15 x i8], [15 x i8]* @.str.64, i64 0, i64 0
    call void @console.writeln(i8* %tmp0, i32 14)
    %tmp1 = getelementptr inbounds [26 x i8], [26 x i8]* @.str.65, i64 0, i64 0
    call void @console.writeln(i8* %tmp1, i32 25)
    %tmp2 = getelementptr inbounds [22 x i8], [22 x i8]* @.str.66, i64 0, i64 0
    call void @console.write(i8* %tmp2, i32 21)
    call void @console.println_i64(i64 12345)
    %tmp3 = getelementptr inbounds [23 x i8], [23 x i8]* @.str.67, i64 0, i64 0
    call void @console.write(i8* %tmp3, i32 22)
    call void @console.println_i64(i64 -67890)
    %tmp4 = getelementptr inbounds [18 x i8], [18 x i8]* @.str.68, i64 0, i64 0
    call void @console.write(i8* %tmp4, i32 17)
    call void @console.println_i64(i64 0)
    %tmp5 = getelementptr inbounds [27 x i8], [27 x i8]* @.str.69, i64 0, i64 0
    call void @console.write(i8* %tmp5, i32 26)
    call void @console.println_u64(i64 9876543210)
    %tmp6 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.70, i64 0, i64 0
    call void @console.writeln(i8* %tmp6, i32 23)
    %tmp7 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.15, i64 0, i64 0
    call void @console.writeln(i8* %tmp7, i32 2)
    ret void
}
define void @"tests.fs_test"(){
    %v0 = alloca %struct.string.String; var: data
    %v1 = alloca %struct.string.String; var: env_path
    %v2 = alloca %struct.string.String; var: new_file_path
    %v3 = alloca %struct.string.String; var: read
    %tmp0 = getelementptr inbounds [10 x i8], [10 x i8]* @.str.71, i64 0, i64 0
    call void @console.write(i8* %tmp0, i32 9)
    %tmp1 = getelementptr inbounds [47 x i8], [47 x i8]* @.str.72, i64 0, i64 0
    %tmp2 = call %struct.string.String @string.from_c_string(i8* %tmp1)
    store %struct.string.String %tmp2, %struct.string.String* %v0
    %tmp3 = call %struct.string.String @process.get_executable_env_path()
    store %struct.string.String %tmp3, %struct.string.String* %v1
    %tmp4 = getelementptr inbounds [9 x i8], [9 x i8]* @.str.73, i64 0, i64 0
    %tmp5 = call %struct.string.String @string.concat_with_c_string(%struct.string.String* %v1, i8* %tmp4)
    store %struct.string.String %tmp5, %struct.string.String* %v2
    %tmp6 = getelementptr inbounds %struct.string.String, %struct.string.String* %v2, i32 0, i32 1
    %tmp7 = load i32, i32* %tmp6
    %tmp8 = add i32 %tmp7, 1
    %tmp9 = sext i32 %tmp8 to i64
    %tmp10 = alloca i8, i64 %tmp9
    %tmp12 = bitcast %struct.string.String** %v2 to %struct.string.String**
    %tmp13 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp12, i32 0, i32 0
    %tmp14 = load i8*, i8** %tmp13
    %tmp15 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp12, i32 0, i32 1
    %tmp16 = load i32, i32* %tmp15
    %tmp17 = sext i32 %tmp16 to i64
    call void @mem.copy(i8* %tmp14, i8* %tmp10, i64 %tmp17)
    %tmp18 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp12, i32 0, i32 1
    %tmp19 = load i32, i32* %tmp18
    %tmp20 = getelementptr inbounds i8, i8* %tmp10, i32 %tmp19
    store i8 0, i8* %tmp20
    br label %inline_exit0
inline_exit0:
    call i32 @fs.create_file(i8* %tmp10)
    call i32 @fs.delete_file(i8* %tmp10)
    call i32 @fs.create_file(i8* %tmp10)
    %tmp21 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
    %tmp22 = load i8*, i8** %tmp21
    %tmp23 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
    %tmp24 = load i32, i32* %tmp23
    call i32 @fs.write_to_file(i8* %tmp10, i8* %tmp22, i32 %tmp24)
    %tmp26 = call %struct.string.String @fs.read_full_file_as_string(i8* %tmp10)
    store %struct.string.String %tmp26, %struct.string.String* %v3
    %tmp27 = call i1 @string.equal(%struct.string.String* %v0, %struct.string.String* %v3)
    %tmp28 = xor i1 %tmp27, 1
    br i1 %tmp28, label %then1, label %endif1
then1:
    %tmp29 = getelementptr inbounds [38 x i8], [38 x i8]* @.str.74, i64 0, i64 0
    call void @process.throw(i8* %tmp29)
    br label %endif1
endif1:
    call i32 @fs.delete_file(i8* %tmp10)
    call void @string.free(%struct.string.String* %v3)
    call void @string.free(%struct.string.String* %v2)
    call void @string.free(%struct.string.String* %v1)
    call void @string.free(%struct.string.String* %v0)
    %tmp30 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.15, i64 0, i64 0
    call void @console.writeln(i8* %tmp30, i32 2)
    ret void
}
define void @"tests.consume_while"(%struct.string.String* %file, i32* %iterator, i1 (i8)** %condition){
    br label %loop_body0
loop_body0:
    %tmp0 = load i32, i32* %iterator
    %tmp1 = getelementptr inbounds %struct.string.String, %struct.string.String* %file, i32 0, i32 1
    %tmp2 = load i32, i32* %tmp1
    %tmp3 = icmp sge i32 %tmp0, %tmp2
    br i1 %tmp3, label %then1, label %endif1
then1:
    br label %loop_body0_exit
    br label %endif1
endif1:
    %tmp4 = getelementptr inbounds %struct.string.String, %struct.string.String* %file, i32 0, i32 0
    %tmp5 = load i8*, i8** %tmp4
    %tmp6 = load i32, i32* %iterator
    %tmp7 = getelementptr inbounds i8, i8* %tmp5, i32 %tmp6
    %tmp8 = load i8, i8* %tmp7
    %tmp9 = call i1 %condition(i8 %tmp8)
    br i1 %tmp9, label %then2, label %else2
then2:
    %tmp10 = load i32, i32* %iterator
    %tmp11 = add i32 %tmp10, 1
    store i32 %tmp11, i32* %iterator
    br label %endif2
else2:
    br label %loop_body0_exit
    br label %endif2
endif2:
    br label %loop_body0
loop_body0_exit:
    ret void
}
define i1 @"tests.not_new_line"(i8 %c){
    %tmp0 = icmp ne i8 %c, 10
    ret i1 %tmp0
}
define i1 @"tests.valid_name_token"(i8 %c){
    %tmp0 = call i1 @string_utils.is_ascii_char(i8 %c)
    %tmp1 = call i1 @string_utils.is_ascii_num(i8 %c)
    %tmp2 = or i1 %tmp0, %tmp1
    %tmp3 = icmp eq i8 %c, 95
    %tmp4 = or i1 %tmp2, %tmp3
    ret i1 %tmp4
}
define i1 @"tests.is_valid_number_token"(i8 %c){
    %tmp0 = call i1 @string_utils.is_ascii_num(i8 %c)
    %tmp1 = call i1 @string_utils.is_ascii_hex(i8 %c)
    %tmp2 = or i1 %tmp0, %tmp1
    %tmp3 = icmp eq i8 %c, 95
    %tmp4 = or i1 %tmp2, %tmp3
    ret i1 %tmp4
}
define void @"tests.funny"(){
    %v0 = alloca i8*; var: path
    %v1 = alloca %struct.string.String; var: file
    %v2 = alloca i32; var: iterator
    %v3 = alloca i8; var: char
    %v4 = alloca i8; var: next_char
    %v5 = alloca i32; var: index
    %v6 = alloca %"struct.vector.Vec<%struct.string.String>"; var: data
    %v7 = alloca %"struct.vector.Vec<i64>"; var: tokens
    %v8 = alloca %struct.string.String; var: temp_string
    %v9 = alloca %struct.string.String; var: temp_string
    %v10 = alloca %struct.string.String; var: temp_string
    %v11 = alloca i32; var: i
    %tmp0 = getelementptr inbounds [45 x i8], [45 x i8]* @.str.75, i64 0, i64 0
    store i8* %tmp0, i8** %v0
    %tmp1 = load i8*, i8** %v0
    %tmp2 = call i32 @fs.create_file(i8* %tmp1)
    %tmp3 = icmp eq i32 %tmp2, 1
    br i1 %tmp3, label %then0, label %endif0
then0:
    %tmp4 = load i8*, i8** %v0
    call i32 @fs.delete_file(i8* %tmp4)
    ret void
    br label %endif0
endif0:
    %tmp5 = load i8*, i8** %v0
    %tmp6 = call %struct.string.String @fs.read_full_file_as_string(i8* %tmp5)
    store %struct.string.String %tmp6, %struct.string.String* %v1
    store i32 0, i32* %v2
    %tmp7 = call %"struct.vector.Vec<%struct.string.String>" @"vector.new<%struct.string.String>"()
    store %"struct.vector.Vec<%struct.string.String>" %tmp7, %"struct.vector.Vec<%struct.string.String>"* %v6
    %tmp8 = call %"struct.vector.Vec<i64>" @"vector.new<i64>"()
    store %"struct.vector.Vec<i64>" %tmp8, %"struct.vector.Vec<i64>"* %v7
    br label %loop_body1
loop_body1:
    %tmp9 = load i32, i32* %v2
    %tmp10 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 1
    %tmp11 = load i32, i32* %tmp10
    %tmp12 = icmp sge i32 %tmp9, %tmp11
    br i1 %tmp12, label %then2, label %endif2
then2:
    br label %loop_body1_exit
    br label %endif2
endif2:
    %tmp13 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 0
    %tmp14 = load i8*, i8** %tmp13
    %tmp15 = load i32, i32* %v2
    %tmp16 = getelementptr inbounds i8, i8* %tmp14, i32 %tmp15
    %tmp17 = load i8, i8* %tmp16
    store i8 %tmp17, i8* %v3
    %tmp18 = load i8, i8* %v3
    %tmp19 = icmp eq i8 %tmp18, 32
    %tmp20 = load i8, i8* %v3
    %tmp21 = icmp eq i8 %tmp20, 9
    %tmp22 = or i1 %tmp19, %tmp21
    %tmp23 = load i8, i8* %v3
    %tmp24 = icmp eq i8 %tmp23, 13
    %tmp25 = or i1 %tmp22, %tmp24
    %tmp26 = load i8, i8* %v3
    %tmp27 = icmp eq i8 %tmp26, 10
    %tmp28 = or i1 %tmp25, %tmp27
    br i1 %tmp28, label %then3, label %endif3
then3:
    %tmp29 = load i32, i32* %v2
    %tmp30 = add i32 %tmp29, 1
    store i32 %tmp30, i32* %v2
    br label %loop_body1
    br label %endif3
endif3:
    %tmp31 = load i32, i32* %v2
    %tmp32 = add i32 %tmp31, 1
    %tmp33 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 1
    %tmp34 = load i32, i32* %tmp33
    %tmp35 = icmp slt i32 %tmp32, %tmp34
    br i1 %tmp35, label %then4, label %else4
then4:
    %tmp36 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 0
    %tmp37 = load i8*, i8** %tmp36
    %tmp38 = load i32, i32* %v2
    %tmp39 = add i32 %tmp38, 1
    %tmp40 = getelementptr inbounds i8, i8* %tmp37, i32 %tmp39
    %tmp41 = load i8, i8* %tmp40
    store i8 %tmp41, i8* %v4
    br label %endif4
else4:
    store i8 0, i8* %v4
    br label %endif4
endif4:
    %tmp42 = load i8, i8* %v3
    %tmp43 = icmp eq i8 %tmp42, 47
    %tmp44 = load i8, i8* %v4
    %tmp45 = icmp eq i8 %tmp44, 47
    %tmp46 = and i1 %tmp43, %tmp45
    br i1 %tmp46, label %then5, label %endif5
then5:
    call void @tests.consume_while(%struct.string.String* %v1, i32* %v2, i1 (i8)** @tests.not_new_line)
    br label %loop_body1
    br label %endif5
endif5:
    %tmp47 = load i8, i8* %v3
    %tmp48 = call i1 @string_utils.is_ascii_num(i8 %tmp47)
    br i1 %tmp48, label %then6, label %endif6
then6:
    %tmp49 = load i32, i32* %v2
    store i32 %tmp49, i32* %v5
    %tmp50 = load i8, i8* %v4
    %tmp51 = icmp eq i8 %tmp50, 120
    %tmp52 = load i8, i8* %v4
    %tmp53 = icmp eq i8 %tmp52, 98
    %tmp54 = or i1 %tmp51, %tmp53
    br i1 %tmp54, label %then7, label %endif7
then7:
    %tmp55 = load i32, i32* %v2
    %tmp56 = add i32 %tmp55, 2
    store i32 %tmp56, i32* %v2
    br label %endif7
endif7:
    call void @tests.consume_while(%struct.string.String* %v1, i32* %v2, i1 (i8)** @tests.is_valid_number_token)
    %tmp57 = load i32, i32* %v2
    %tmp58 = load i32, i32* %v5
    %tmp59 = sub i32 %tmp57, %tmp58
    %tmp60 = call %struct.string.String @string.with_size(i32 %tmp59)
    store %struct.string.String %tmp60, %struct.string.String* %v8
    %tmp61 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 0
    %tmp62 = load i8*, i8** %tmp61
    %tmp63 = load i32, i32* %v5
    %tmp64 = getelementptr i8, i8* %tmp62, i32 %tmp63
    %tmp65 = getelementptr inbounds %struct.string.String, %struct.string.String* %v8, i32 0, i32 0
    %tmp66 = load i8*, i8** %tmp65
    %tmp67 = getelementptr inbounds %struct.string.String, %struct.string.String* %v8, i32 0, i32 1
    %tmp68 = load i32, i32* %tmp67
    %tmp69 = sext i32 %tmp68 to i64
    call void @mem.copy(i8* %tmp64, i8* %tmp66, i64 %tmp69)
    %tmp70 = load %struct.string.String, %struct.string.String* %v8
    call void @"vector.push<%struct.string.String>"(%"struct.vector.Vec<%struct.string.String>"* %v6, %struct.string.String %tmp70)
    br label %loop_body1
    br label %endif6
endif6:
    %tmp71 = load i8, i8* %v3
    %tmp72 = call i1 @string_utils.is_ascii_char(i8 %tmp71)
    %tmp73 = load i8, i8* %v3
    %tmp74 = icmp eq i8 %tmp73, 95
    %tmp75 = or i1 %tmp72, %tmp74
    br i1 %tmp75, label %then8, label %endif8
then8:
    %tmp76 = load i32, i32* %v2
    store i32 %tmp76, i32* %v5
    call void @tests.consume_while(%struct.string.String* %v1, i32* %v2, i1 (i8)** @tests.valid_name_token)
    %tmp77 = load i32, i32* %v2
    %tmp78 = load i32, i32* %v5
    %tmp79 = sub i32 %tmp77, %tmp78
    %tmp80 = call %struct.string.String @string.with_size(i32 %tmp79)
    store %struct.string.String %tmp80, %struct.string.String* %v9
    %tmp81 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 0
    %tmp82 = load i8*, i8** %tmp81
    %tmp83 = load i32, i32* %v5
    %tmp84 = getelementptr i8, i8* %tmp82, i32 %tmp83
    %tmp85 = getelementptr inbounds %struct.string.String, %struct.string.String* %v9, i32 0, i32 0
    %tmp86 = load i8*, i8** %tmp85
    %tmp87 = getelementptr inbounds %struct.string.String, %struct.string.String* %v9, i32 0, i32 1
    %tmp88 = load i32, i32* %tmp87
    %tmp89 = sext i32 %tmp88 to i64
    call void @mem.copy(i8* %tmp84, i8* %tmp86, i64 %tmp89)
    %tmp90 = load %struct.string.String, %struct.string.String* %v9
    call void @"vector.push<%struct.string.String>"(%"struct.vector.Vec<%struct.string.String>"* %v6, %struct.string.String %tmp90)
    br label %loop_body1
    br label %endif8
endif8:
    %tmp91 = load i8, i8* %v3
    %tmp92 = icmp eq i8 %tmp91, 34
    br i1 %tmp92, label %then9, label %endif9
then9:
    %tmp93 = load i32, i32* %v2
    store i32 %tmp93, i32* %v5
    br label %loop_body10
loop_body10:
    %tmp94 = load i32, i32* %v2
    %tmp95 = add i32 %tmp94, 1
    store i32 %tmp95, i32* %v2
    %tmp96 = load i32, i32* %v2
    %tmp97 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 1
    %tmp98 = load i32, i32* %tmp97
    %tmp99 = icmp sge i32 %tmp96, %tmp98
    br i1 %tmp99, label %then11, label %endif11
then11:
    br label %loop_body10_exit
    br label %endif11
endif11:
    %tmp100 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 0
    %tmp101 = load i8*, i8** %tmp100
    %tmp102 = load i32, i32* %v2
    %tmp103 = getelementptr inbounds i8, i8* %tmp101, i32 %tmp102
    %tmp104 = load i8, i8* %tmp103
    %tmp105 = icmp eq i8 %tmp104, 34
    br i1 %tmp105, label %then12, label %endif12
then12:
    %tmp106 = load i32, i32* %v2
    %tmp107 = add i32 %tmp106, 1
    store i32 %tmp107, i32* %v2
    br label %loop_body10_exit
    br label %endif12
endif12:
    br label %loop_body10
loop_body10_exit:
    %tmp108 = load i32, i32* %v2
    %tmp109 = load i32, i32* %v5
    %tmp110 = sub i32 %tmp108, %tmp109
    %tmp111 = call %struct.string.String @string.with_size(i32 %tmp110)
    store %struct.string.String %tmp111, %struct.string.String* %v10
    %tmp112 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 0
    %tmp113 = load i8*, i8** %tmp112
    %tmp114 = load i32, i32* %v5
    %tmp115 = getelementptr i8, i8* %tmp113, i32 %tmp114
    %tmp116 = getelementptr inbounds %struct.string.String, %struct.string.String* %v10, i32 0, i32 0
    %tmp117 = load i8*, i8** %tmp116
    %tmp118 = getelementptr inbounds %struct.string.String, %struct.string.String* %v10, i32 0, i32 1
    %tmp119 = load i32, i32* %tmp118
    %tmp120 = sext i32 %tmp119 to i64
    call void @mem.copy(i8* %tmp115, i8* %tmp117, i64 %tmp120)
    %tmp121 = load %struct.string.String, %struct.string.String* %v10
    call void @"vector.push<%struct.string.String>"(%"struct.vector.Vec<%struct.string.String>"* %v6, %struct.string.String %tmp121)
    br label %loop_body1
    br label %endif9
endif9:
    %tmp122 = load i8, i8* %v3
    %tmp123 = icmp eq i8 %tmp122, 39
    br i1 %tmp123, label %then13, label %endif13
then13:
    %tmp124 = load i32, i32* %v2
    %tmp125 = add i32 %tmp124, 1
    store i32 %tmp125, i32* %v2
    br label %loop_body1
    br label %endif13
endif13:
    %tmp126 = load i8, i8* %v3
    %tmp127 = icmp eq i8 %tmp126, 40
    br i1 %tmp127, label %then14, label %endif14
then14:
    %tmp128 = load i32, i32* %v2
    %tmp129 = add i32 %tmp128, 1
    store i32 %tmp129, i32* %v2
    br label %loop_body1
    br label %endif14
endif14:
    %tmp130 = load i8, i8* %v3
    %tmp131 = icmp eq i8 %tmp130, 41
    br i1 %tmp131, label %then15, label %endif15
then15:
    %tmp132 = load i32, i32* %v2
    %tmp133 = add i32 %tmp132, 1
    store i32 %tmp133, i32* %v2
    br label %loop_body1
    br label %endif15
endif15:
    %tmp134 = load i8, i8* %v3
    %tmp135 = icmp eq i8 %tmp134, 123
    br i1 %tmp135, label %then16, label %endif16
then16:
    %tmp136 = load i32, i32* %v2
    %tmp137 = add i32 %tmp136, 1
    store i32 %tmp137, i32* %v2
    br label %loop_body1
    br label %endif16
endif16:
    %tmp138 = load i8, i8* %v3
    %tmp139 = icmp eq i8 %tmp138, 125
    br i1 %tmp139, label %then17, label %endif17
then17:
    %tmp140 = load i32, i32* %v2
    %tmp141 = add i32 %tmp140, 1
    store i32 %tmp141, i32* %v2
    br label %loop_body1
    br label %endif17
endif17:
    %tmp142 = load i8, i8* %v3
    %tmp143 = icmp eq i8 %tmp142, 91
    br i1 %tmp143, label %then18, label %endif18
then18:
    %tmp144 = load i32, i32* %v2
    %tmp145 = add i32 %tmp144, 1
    store i32 %tmp145, i32* %v2
    br label %loop_body1
    br label %endif18
endif18:
    %tmp146 = load i8, i8* %v3
    %tmp147 = icmp eq i8 %tmp146, 93
    br i1 %tmp147, label %then19, label %endif19
then19:
    %tmp148 = load i32, i32* %v2
    %tmp149 = add i32 %tmp148, 1
    store i32 %tmp149, i32* %v2
    br label %loop_body1
    br label %endif19
endif19:
    %tmp150 = load i8, i8* %v3
    %tmp151 = icmp eq i8 %tmp150, 61
    br i1 %tmp151, label %then20, label %endif20
then20:
    %tmp152 = load i8, i8* %v4
    %tmp153 = icmp eq i8 %tmp152, 61
    br i1 %tmp153, label %then21, label %endif21
then21:
    %tmp154 = load i32, i32* %v2
    %tmp155 = add i32 %tmp154, 2
    store i32 %tmp155, i32* %v2
    br label %loop_body1
    br label %endif21
endif21:
    %tmp156 = load i32, i32* %v2
    %tmp157 = add i32 %tmp156, 1
    store i32 %tmp157, i32* %v2
    br label %loop_body1
    br label %endif20
endif20:
    %tmp158 = load i8, i8* %v3
    %tmp159 = icmp eq i8 %tmp158, 58
    br i1 %tmp159, label %then22, label %endif22
then22:
    %tmp160 = load i8, i8* %v4
    %tmp161 = icmp eq i8 %tmp160, 58
    br i1 %tmp161, label %then23, label %endif23
then23:
    %tmp162 = load i32, i32* %v2
    %tmp163 = add i32 %tmp162, 2
    store i32 %tmp163, i32* %v2
    br label %loop_body1
    br label %endif23
endif23:
    %tmp164 = load i32, i32* %v2
    %tmp165 = add i32 %tmp164, 1
    store i32 %tmp165, i32* %v2
    br label %loop_body1
    br label %endif22
endif22:
    %tmp166 = load i8, i8* %v3
    %tmp167 = icmp eq i8 %tmp166, 124
    br i1 %tmp167, label %then24, label %endif24
then24:
    %tmp168 = load i8, i8* %v4
    %tmp169 = icmp eq i8 %tmp168, 124
    br i1 %tmp169, label %then25, label %endif25
then25:
    %tmp170 = load i32, i32* %v2
    %tmp171 = add i32 %tmp170, 2
    store i32 %tmp171, i32* %v2
    br label %loop_body1
    br label %endif25
endif25:
    %tmp172 = load i32, i32* %v2
    %tmp173 = add i32 %tmp172, 1
    store i32 %tmp173, i32* %v2
    br label %loop_body1
    br label %endif24
endif24:
    %tmp174 = load i8, i8* %v3
    %tmp175 = icmp eq i8 %tmp174, 38
    br i1 %tmp175, label %then26, label %endif26
then26:
    %tmp176 = load i8, i8* %v4
    %tmp177 = icmp eq i8 %tmp176, 38
    br i1 %tmp177, label %then27, label %endif27
then27:
    %tmp178 = load i32, i32* %v2
    %tmp179 = add i32 %tmp178, 2
    store i32 %tmp179, i32* %v2
    br label %loop_body1
    br label %endif27
endif27:
    %tmp180 = load i32, i32* %v2
    %tmp181 = add i32 %tmp180, 1
    store i32 %tmp181, i32* %v2
    br label %loop_body1
    br label %endif26
endif26:
    %tmp182 = load i8, i8* %v3
    %tmp183 = icmp eq i8 %tmp182, 62
    br i1 %tmp183, label %then28, label %endif28
then28:
    %tmp184 = load i8, i8* %v4
    %tmp185 = icmp eq i8 %tmp184, 61
    br i1 %tmp185, label %then29, label %endif29
then29:
    %tmp186 = load i32, i32* %v2
    %tmp187 = add i32 %tmp186, 2
    store i32 %tmp187, i32* %v2
    br label %loop_body1
    br label %endif29
endif29:
    %tmp188 = load i32, i32* %v2
    %tmp189 = add i32 %tmp188, 1
    store i32 %tmp189, i32* %v2
    br label %loop_body1
    br label %endif28
endif28:
    %tmp190 = load i8, i8* %v3
    %tmp191 = icmp eq i8 %tmp190, 60
    br i1 %tmp191, label %then30, label %endif30
then30:
    %tmp192 = load i8, i8* %v4
    %tmp193 = icmp eq i8 %tmp192, 61
    br i1 %tmp193, label %then31, label %endif31
then31:
    %tmp194 = load i32, i32* %v2
    %tmp195 = add i32 %tmp194, 2
    store i32 %tmp195, i32* %v2
    br label %loop_body1
    br label %endif31
endif31:
    %tmp196 = load i32, i32* %v2
    %tmp197 = add i32 %tmp196, 1
    store i32 %tmp197, i32* %v2
    br label %loop_body1
    br label %endif30
endif30:
    %tmp198 = load i8, i8* %v3
    %tmp199 = icmp eq i8 %tmp198, 35
    br i1 %tmp199, label %then32, label %endif32
then32:
    %tmp200 = load i32, i32* %v2
    %tmp201 = add i32 %tmp200, 1
    store i32 %tmp201, i32* %v2
    br label %loop_body1
    br label %endif32
endif32:
    %tmp202 = load i8, i8* %v3
    %tmp203 = icmp eq i8 %tmp202, 59
    br i1 %tmp203, label %then33, label %endif33
then33:
    %tmp204 = load i32, i32* %v2
    %tmp205 = add i32 %tmp204, 1
    store i32 %tmp205, i32* %v2
    br label %loop_body1
    br label %endif33
endif33:
    %tmp206 = load i8, i8* %v3
    %tmp207 = icmp eq i8 %tmp206, 46
    br i1 %tmp207, label %then34, label %endif34
then34:
    %tmp208 = load i32, i32* %v2
    %tmp209 = add i32 %tmp208, 1
    store i32 %tmp209, i32* %v2
    br label %loop_body1
    br label %endif34
endif34:
    %tmp210 = load i8, i8* %v3
    %tmp211 = icmp eq i8 %tmp210, 44
    br i1 %tmp211, label %then35, label %endif35
then35:
    %tmp212 = load i32, i32* %v2
    %tmp213 = add i32 %tmp212, 1
    store i32 %tmp213, i32* %v2
    br label %loop_body1
    br label %endif35
endif35:
    %tmp214 = load i8, i8* %v3
    %tmp215 = icmp eq i8 %tmp214, 43
    br i1 %tmp215, label %then36, label %endif36
then36:
    %tmp216 = load i32, i32* %v2
    %tmp217 = add i32 %tmp216, 1
    store i32 %tmp217, i32* %v2
    br label %loop_body1
    br label %endif36
endif36:
    %tmp218 = load i8, i8* %v3
    %tmp219 = icmp eq i8 %tmp218, 45
    br i1 %tmp219, label %then37, label %endif37
then37:
    %tmp220 = load i32, i32* %v2
    %tmp221 = add i32 %tmp220, 1
    store i32 %tmp221, i32* %v2
    br label %loop_body1
    br label %endif37
endif37:
    %tmp222 = load i8, i8* %v3
    %tmp223 = icmp eq i8 %tmp222, 42
    br i1 %tmp223, label %then38, label %endif38
then38:
    %tmp224 = load i32, i32* %v2
    %tmp225 = add i32 %tmp224, 1
    store i32 %tmp225, i32* %v2
    br label %loop_body1
    br label %endif38
endif38:
    %tmp226 = load i8, i8* %v3
    %tmp227 = icmp eq i8 %tmp226, 47
    br i1 %tmp227, label %then39, label %endif39
then39:
    %tmp228 = load i32, i32* %v2
    %tmp229 = add i32 %tmp228, 1
    store i32 %tmp229, i32* %v2
    br label %loop_body1
    br label %endif39
endif39:
    %tmp230 = load i8, i8* %v3
    %tmp231 = icmp eq i8 %tmp230, 37
    br i1 %tmp231, label %then40, label %endif40
then40:
    %tmp232 = load i32, i32* %v2
    %tmp233 = add i32 %tmp232, 1
    store i32 %tmp233, i32* %v2
    br label %loop_body1
    br label %endif40
endif40:
    %tmp234 = load i8, i8* %v3
    %tmp235 = icmp eq i8 %tmp234, 33
    br i1 %tmp235, label %then41, label %endif41
then41:
    %tmp236 = load i32, i32* %v2
    %tmp237 = add i32 %tmp236, 1
    store i32 %tmp237, i32* %v2
    br label %loop_body1
    br label %endif41
endif41:
    %tmp238 = load i8, i8* %v3
    %tmp239 = icmp eq i8 %tmp238, 126
    br i1 %tmp239, label %then42, label %endif42
then42:
    %tmp240 = load i32, i32* %v2
    %tmp241 = add i32 %tmp240, 1
    store i32 %tmp241, i32* %v2
    br label %loop_body1
    br label %endif42
endif42:
    %tmp242 = load i8, i8* %v3
    %tmp243 = icmp eq i8 %tmp242, 92
    br i1 %tmp243, label %then43, label %endif43
then43:
    %tmp244 = load i32, i32* %v2
    %tmp245 = add i32 %tmp244, 1
    store i32 %tmp245, i32* %v2
    br label %loop_body1
    br label %endif43
endif43:
    %tmp246 = load i8, i8* %v3
    call void @console.print_char(i8 %tmp246)
    call void @console.print_char(i8 10)
    %tmp247 = load i32, i32* %v2
    %tmp248 = add i32 %tmp247, 1
    store i32 %tmp248, i32* %v2
    br label %loop_body1
loop_body1_exit:
    store i32 0, i32* %v11
    br label %loop_body44
loop_body44:
    %tmp249 = load i32, i32* %v11
    %tmp250 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %v6, i32 0, i32 1
    %tmp251 = load i32, i32* %tmp250
    %tmp252 = icmp uge i32 %tmp249, %tmp251
    br i1 %tmp252, label %then45, label %endif45
then45:
    br label %loop_body44_exit
    br label %endif45
endif45:
    %tmp253 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %v6, i32 0, i32 0
    %tmp254 = load %struct.string.String*, %struct.string.String** %tmp253
    %tmp255 = load i32, i32* %v11
    %tmp256 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp254, i32 %tmp255
    call void @string.free(%struct.string.String* %tmp256)
    %tmp257 = load i32, i32* %v11
    %tmp258 = add i32 %tmp257, 1
    store i32 %tmp258, i32* %v11
    br label %loop_body44
loop_body44_exit:
    call void @"vector.free<%struct.string.String>"(%"struct.vector.Vec<%struct.string.String>"* %v6)
    call void @string.free(%struct.string.String* %v1)
    ret void
}
define i64 @"window.WindowProc"(i8* %hWnd, i32 %uMsg, i64 %wParam, i64 %lParam){
    %v0 = alloca %struct.window.PAINTSTRUCT; var: ps
    %tmp0 = icmp eq i32 %uMsg, 16
    br i1 %tmp0, label %then0, label %endif0
then0:
    call void @PostQuitMessage(i32 0)
    ret i64 0
    br label %endif0
endif0:
    %tmp1 = icmp eq i32 %uMsg, 2
    br i1 %tmp1, label %then1, label %endif1
then1:
    call void @PostQuitMessage(i32 0)
    ret i64 0
    br label %endif1
endif1:
    %tmp2 = icmp eq i32 %uMsg, 256
    br i1 %tmp2, label %then2, label %endif2
then2:
    %tmp3 = icmp eq i64 %wParam, 27
    br i1 %tmp3, label %then3, label %endif3
then3:
    call void @PostQuitMessage(i32 0)
    ret i64 0
    br label %endif3
endif3:
    %tmp4 = trunc i64 %wParam to i8
    call void @console.print_char(i8 %tmp4)
    br label %endif2
endif2:
    %tmp5 = icmp eq i32 %uMsg, 8
    br i1 %tmp5, label %then4, label %endif4
then4:
    call void @PostQuitMessage(i32 0)
    ret i64 0
    br label %endif4
endif4:
    %tmp6 = icmp eq i32 %uMsg, 132
    br i1 %tmp6, label %then5, label %endif5
then5:
    %tmp7 = call i64 @DefWindowProcA(i8* %hWnd, i32 %uMsg, i64 %wParam, i64 %lParam)
    %tmp8 = icmp eq i64 %tmp7, 1
    br i1 %tmp8, label %then6, label %endif6
then6:
    ret i64 2
    br label %endif6
endif6:
    ret i64 %tmp7
    br label %endif5
endif5:
    %tmp9 = icmp eq i32 %uMsg, 163
    br i1 %tmp9, label %then7, label %endif7
then7:
    ret i64 0
    br label %endif7
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
    ret i64 0
    br label %endif8
endif8:
    %tmp14 = call i64 @DefWindowProcA(i8* %hWnd, i32 %uMsg, i64 %wParam, i64 %lParam)
    ret i64 %tmp14
}
define i8* @"window.load_bitmap_from_file"(i8* %path){
    %tmp0 = call i1 @fs.file_exists(i8* %path)
    %tmp1 = xor i1 %tmp0, 1
    br i1 %tmp1, label %then0, label %endif0
then0:
    %tmp2 = getelementptr inbounds [37 x i8], [37 x i8]* @.str.76, i64 0, i64 0
    call void @process.throw(i8* %tmp2)
    br label %endif0
endif0:
    %tmp3 = call i8* @LoadImageA(i8* null, i8* %path, i32 0, i32 0, i32 0, i32 16)
    ret i8* %tmp3
}
define void @"window.get_bitmap_dimensions"(i8* %hBitmap, i32* %width, i32* %height){
    %v0 = alloca %struct.window.BITMAP; var: bm
    call i32 @GetObjectA(i8* %hBitmap, i32 32, %struct.window.BITMAP* %v0)
    %tmp0 = getelementptr inbounds %struct.window.BITMAP, %struct.window.BITMAP* %v0, i32 0, i32 1
    %tmp1 = load i32, i32* %tmp0
    store i32 %tmp1, i32* %width
    %tmp2 = getelementptr inbounds %struct.window.BITMAP, %struct.window.BITMAP* %v0, i32 0, i32 2
    %tmp3 = load i32, i32* %tmp2
    store i32 %tmp3, i32* %height
    ret void
}
define void @"window.draw_bitmap"(i8* %hdc, i8* %hBitmap, i32 %x, i32 %y){
    %v0 = alloca %struct.window.BITMAP; var: bm
    %tmp0 = icmp eq ptr %hBitmap, null
    br i1 %tmp0, label %then0, label %endif0
then0:
    ret void
    br label %endif0
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
    ret void
}
define void @"window.draw_bitmap_stretched"(i8* %hdc, i8* %hBitmap, i32 %x, i32 %y, i32 %width, i32 %height){
    %v0 = alloca %struct.window.BITMAP; var: bm
    %tmp0 = icmp eq ptr %hBitmap, null
    br i1 %tmp0, label %then0, label %endif0
then0:
    ret void
    br label %endif0
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
    ret void
}
define void @"window.start"(){
    %v0 = alloca %struct.window.WNDCLASSEXA; var: wc
    %v1 = alloca %struct.window.MSG; var: msg
    %tmp0 = inttoptr i64 0 to i8*
    %tmp1 = call i8* @GetModuleHandleA(i8* %tmp0)
    %iv2 = alloca i1
    %tmp3 = icmp eq ptr %tmp1, null
    store i1 %tmp3, i1* %iv2
    br label %inline_exit0
inline_exit0:
    %tmp4 = load i1, i1* %iv2
    br i1 %tmp4, label %then1, label %endif1
then1:
    %tmp5 = getelementptr inbounds [48 x i8], [48 x i8]* @.str.77, i64 0, i64 0
    call void @process.throw(i8* %tmp5)
    br label %endif1
endif1:
    %tmp6 = getelementptr inbounds [14 x i8], [14 x i8]* @.str.78, i64 0, i64 0
    %tmp7 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v0, i32 0, i32 0
    store i32 80, i32* %tmp7
    %tmp8 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v0, i32 0, i32 1
    %tmp9 = or i32 2, 1
    store i32 %tmp9, i32* %tmp8
    %tmp10 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v0, i32 0, i32 2
    store i64 (i8*, i32, i64, i64)** @window.WindowProc, i64 (i8*, i32, i64, i64)*** %tmp10
    %tmp11 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v0, i32 0, i32 3
    store i32 0, i32* %tmp11
    %tmp12 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v0, i32 0, i32 4
    store i32 0, i32* %tmp12
    %tmp13 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v0, i32 0, i32 5
    store i8* %tmp1, i8** %tmp13
    %tmp14 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v0, i32 0, i32 6
    %tmp15 = inttoptr i64 0 to i8*
    store i8* %tmp15, i8** %tmp14
    %tmp16 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v0, i32 0, i32 7
    %tmp17 = inttoptr i64 0 to i8*
    store i8* %tmp17, i8** %tmp16
    %tmp18 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v0, i32 0, i32 8
    %tmp19 = add i32 5, 1
    %tmp20 = inttoptr i32 %tmp19 to i8*
    store i8* %tmp20, i8** %tmp18
    %tmp21 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v0, i32 0, i32 9
    %tmp22 = inttoptr i64 0 to i8*
    store i8* %tmp22, i8** %tmp21
    %tmp23 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v0, i32 0, i32 10
    store i8* %tmp6, i8** %tmp23
    %tmp24 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v0, i32 0, i32 11
    %tmp25 = inttoptr i64 0 to i8*
    store i8* %tmp25, i8** %tmp24
    %tmp26 = call i16 @RegisterClassExA(%struct.window.WNDCLASSEXA* %v0)
    %tmp27 = icmp eq i16 %tmp26, 0
    br i1 %tmp27, label %then2, label %endif2
then2:
    %tmp28 = getelementptr inbounds [46 x i8], [46 x i8]* @.str.79, i64 0, i64 0
    call void @process.throw(i8* %tmp28)
    br label %endif2
endif2:
    %tmp29 = getelementptr inbounds [14 x i8], [14 x i8]* @.str.80, i64 0, i64 0
    %tmp30 = inttoptr i64 0 to i8*
    %tmp31 = inttoptr i64 0 to i8*
    %tmp32 = inttoptr i64 0 to i8*
    %tmp33 = call i8* @CreateWindowExA(i32 0, i8* %tmp6, i8* %tmp29, i32 13565952, i32 2147483648, i32 2147483648, i32 800, i32 600, i8* %tmp30, i8* %tmp31, i8* %tmp1, i8* %tmp32)
    %iv34 = alloca i1
    %tmp35 = icmp eq ptr %tmp33, null
    store i1 %tmp35, i1* %iv34
    br label %inline_exit3
inline_exit3:
    %tmp36 = load i1, i1* %iv34
    br i1 %tmp36, label %then4, label %endif4
then4:
    %tmp37 = getelementptr inbounds [45 x i8], [45 x i8]* @.str.81, i64 0, i64 0
    call void @process.throw(i8* %tmp37)
    br label %endif4
endif4:
    call i32 @ShowWindow(i8* %tmp33, i32 5)
    br label %loop_body5
loop_body5:
    %tmp38 = inttoptr i64 0 to i8*
    %tmp39 = call i32 @GetMessageA(%struct.window.MSG* %v1, i8* %tmp38, i32 0, i32 0)
    %tmp40 = icmp sle i32 %tmp39, 0
    br i1 %tmp40, label %then6, label %endif6
then6:
    br label %loop_body5_exit
    br label %endif6
endif6:
    call i32 @TranslateMessage(%struct.window.MSG* %v1)
    call i64 @DispatchMessageA(%struct.window.MSG* %v1)
    br label %loop_body5
loop_body5_exit:
    ret void
}
define void @"window.start_image_window"(i8* %imagePath){
    %v0 = alloca i32; var: imgW
    %v1 = alloca i32; var: imgH
    %v2 = alloca %struct.window.WNDCLASSEXA; var: wc
    %v3 = alloca %struct.window.RECT; var: rect
    %v4 = alloca %struct.window.MSG; var: msg
    %tmp0 = inttoptr i64 0 to i8*
    %tmp1 = call i8* @GetModuleHandleA(i8* %tmp0)
    %iv2 = alloca i1
    %tmp3 = icmp eq ptr %tmp1, null
    store i1 %tmp3, i1* %iv2
    br label %inline_exit0
inline_exit0:
    %tmp4 = load i1, i1* %iv2
    br i1 %tmp4, label %then1, label %endif1
then1:
    %tmp5 = getelementptr inbounds [48 x i8], [48 x i8]* @.str.77, i64 0, i64 0
    call void @process.throw(i8* %tmp5)
    br label %endif1
endif1:
    %tmp6 = call i8* @window.load_bitmap_from_file(i8* %imagePath)
    %tmp7 = inttoptr i64 0 to i8*
    %tmp8 = icmp eq ptr %tmp6, %tmp7
    br i1 %tmp8, label %then2, label %endif2
then2:
    %tmp9 = getelementptr inbounds [42 x i8], [42 x i8]* @.str.82, i64 0, i64 0
    call void @process.throw(i8* %tmp9)
    br label %endif2
endif2:
    store i32 0, i32* %v0
    store i32 0, i32* %v1
    call void @window.get_bitmap_dimensions(i8* %tmp6, i32* %v0, i32* %v1)
    %tmp10 = getelementptr inbounds [21 x i8], [21 x i8]* @.str.83, i64 0, i64 0
    %tmp11 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v2, i32 0, i32 0
    store i32 80, i32* %tmp11
    %tmp12 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v2, i32 0, i32 1
    %tmp13 = or i32 2, 1
    store i32 %tmp13, i32* %tmp12
    %tmp14 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v2, i32 0, i32 2
    store i64 (i8*, i32, i64, i64)** @window.WindowProc, i64 (i8*, i32, i64, i64)*** %tmp14
    %tmp15 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v2, i32 0, i32 3
    store i32 0, i32* %tmp15
    %tmp16 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v2, i32 0, i32 4
    store i32 0, i32* %tmp16
    %tmp17 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v2, i32 0, i32 5
    store i8* %tmp1, i8** %tmp17
    %tmp18 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v2, i32 0, i32 6
    %tmp19 = inttoptr i64 0 to i8*
    store i8* %tmp19, i8** %tmp18
    %tmp20 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v2, i32 0, i32 7
    %tmp21 = inttoptr i64 0 to i8*
    store i8* %tmp21, i8** %tmp20
    %tmp22 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v2, i32 0, i32 8
    %tmp23 = add i32 5, 1
    %tmp24 = inttoptr i32 %tmp23 to i8*
    store i8* %tmp24, i8** %tmp22
    %tmp25 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v2, i32 0, i32 9
    %tmp26 = inttoptr i64 0 to i8*
    store i8* %tmp26, i8** %tmp25
    %tmp27 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v2, i32 0, i32 10
    store i8* %tmp10, i8** %tmp27
    %tmp28 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v2, i32 0, i32 11
    %tmp29 = inttoptr i64 0 to i8*
    store i8* %tmp29, i8** %tmp28
    %tmp30 = call i16 @RegisterClassExA(%struct.window.WNDCLASSEXA* %v2)
    %tmp31 = icmp eq i16 %tmp30, 0
    br i1 %tmp31, label %then3, label %endif3
then3:
    %tmp32 = getelementptr inbounds [46 x i8], [46 x i8]* @.str.79, i64 0, i64 0
    call void @process.throw(i8* %tmp32)
    br label %endif3
endif3:
    %tmp33 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.84, i64 0, i64 0
    %tmp34 = or i32 2147483648, 268435456
    %tmp35 = load i32, i32* %v0
    %tmp36 = load i32, i32* %v1
    %tmp37 = inttoptr i64 0 to i8*
    %tmp38 = inttoptr i64 0 to i8*
    %tmp39 = inttoptr i64 0 to i8*
    %tmp40 = call i8* @CreateWindowExA(i32 8, i8* %tmp10, i8* %tmp33, i32 %tmp34, i32 100, i32 100, i32 %tmp35, i32 %tmp36, i8* %tmp37, i8* %tmp38, i8* %tmp1, i8* %tmp39)
    %iv41 = alloca i1
    %tmp42 = icmp eq ptr %tmp40, null
    store i1 %tmp42, i1* %iv41
    br label %inline_exit4
inline_exit4:
    %tmp43 = load i1, i1* %iv41
    br i1 %tmp43, label %then5, label %endif5
then5:
    %tmp44 = getelementptr inbounds [45 x i8], [45 x i8]* @.str.81, i64 0, i64 0
    call void @process.throw(i8* %tmp44)
    br label %endif5
endif5:
    call i64 @SetWindowLongPtrA(i8* %tmp40, i32 -21, i8* %tmp6)
    call i32 @ShowWindow(i8* %tmp40, i32 5)
    call i32 @GetClientRect(i8* %tmp40, %struct.window.RECT* %v3)
    call i32 @InvalidateRect(i8* %tmp40, %struct.window.RECT* %v3, i32 1)
    br label %loop_body6
loop_body6:
    %tmp45 = inttoptr i64 0 to i8*
    %tmp46 = call i32 @GetMessageA(%struct.window.MSG* %v4, i8* %tmp45, i32 0, i32 0)
    %tmp47 = icmp sle i32 %tmp46, 0
    br i1 %tmp47, label %then7, label %endif7
then7:
    br label %loop_body6_exit
    br label %endif7
endif7:
    call i32 @TranslateMessage(%struct.window.MSG* %v4)
    call i64 @DispatchMessageA(%struct.window.MSG* %v4)
    br label %loop_body6
loop_body6_exit:
    ret void
}
define void ()** ()** @"of_fn"(){
    %tmp0 = call void ()** ()** @of_fn()
    ret void ()** ()** %tmp0
}
define %"struct.test.QPair<i64, i64>" @"test.geg"(){
    %v0 = alloca %"struct.test.QPair<i64, i64>"; var: temp
    %tmp0 = getelementptr inbounds %"struct.test.QPair<i64, i64>", %"struct.test.QPair<i64, i64>"* %v0, i32 0, i32 0
    store i64 1337, i64* %tmp0
    %tmp1 = getelementptr inbounds %"struct.test.QPair<i64, i64>", %"struct.test.QPair<i64, i64>"* %v0, i32 0, i32 1
    store i64 1226, i64* %tmp1
    %tmp2 = getelementptr inbounds %"struct.test.QPair<i64, i64>", %"struct.test.QPair<i64, i64>"* %v0, i32 0, i32 0
    %tmp3 = getelementptr inbounds %"struct.test.QPair<i64, i64>", %"struct.test.QPair<i64, i64>"* %v0, i32 0, i32 0
    %tmp4 = load i64, i64* %tmp3
    %tmp5 = getelementptr inbounds %"struct.test.QPair<i64, i64>", %"struct.test.QPair<i64, i64>"* %v0, i32 0, i32 1
    %tmp6 = load i64, i64* %tmp5
    %tmp7 = sub i64 %tmp4, %tmp6
    store i64 %tmp7, i64* %tmp2
    %tmp8 = load %"struct.test.QPair<i64, i64>", %"struct.test.QPair<i64, i64>"* %v0
    ret %"struct.test.QPair<i64, i64>" %tmp8
}
define %"struct.test.QPair<i64, i64>" @"xq"(){
    %tmp0 = call %"struct.test.QPair<i64, i64>" @test.geg()
    ret %"struct.test.QPair<i64, i64>" %tmp0
}
define i32 @"main"(){
    %v0 = alloca %"struct.Pair<i32, struct.Pair<i8, %struct.string.String>>"; var: y
    %tmp1 = call %"struct.Pair<i32, struct.Pair<i8, %struct.string.String>>" @"ax<i32>"()
    store %"struct.Pair<i32, struct.Pair<i8, %struct.string.String>>" %tmp1, %"struct.Pair<i32, struct.Pair<i8, %struct.string.String>>"* %v0
    %tmp2 = getelementptr inbounds %"struct.Pair<i32, struct.Pair<i8, %struct.string.String>>", %"struct.Pair<i32, struct.Pair<i8, %struct.string.String>>"* %v0, i32 0, i32 1
    %tmp3 = getelementptr inbounds %"struct.Pair<i8, %struct.string.String>", %"struct.Pair<i8, %struct.string.String>"* %tmp2, i32 0, i32 0
    %tmp4 = load i8, i8* %tmp3
    %tmp5 = sext i8 %tmp4 to i64
    call void @console.println_i64(i64 %tmp5)
    call void @console.println_f64(double 0x40DEADDD3B80D02E)
    %tmp6 = fptosi double 0x40DEADDD3B80D02E to i64
    call void @console.println_i64(i64 %tmp6)
    %tmp7 = bitcast double 0x40DEADDD3B80D02E to i64
    call void @console.println_i64(i64 %tmp7)
    %tmp8 = bitcast double 0x40DEADDD3B80D02E to i64
    %tmp9 = add i64 %tmp8, 123123123123
    %tmp10 = bitcast i64 %tmp9 to double
    call void @console.println_f64(double %tmp10)
    call i32 @AllocConsole()
    call void @tests.run()
    call void @window.start()
    call i32 @FreeConsole()
    br label %inline_exit0
inline_exit0:
    %tmp12 = call %"struct.test.QPair<i64, i64>" @xq()
    %tmp13 = ptrtoint %"struct.Pair<i32, struct.Pair<i8, %struct.string.String>>" ()** @"ax<i32>" to i64
    %tmp14 = ptrtoint i32 ()** @main to i64
    %tmp15 = sub i64 %tmp13, %tmp14
    %tmp16 = trunc i64 %tmp15 to i32
    ret i32 %tmp16
}
define %"struct.list.List<i32>" @"list.new<i32>"(){
    %v0 = alloca %"struct.list.List<i32>"; var: list
    %tmp0 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %v0, i32 0, i32 0
    store %"struct.list.ListNode<i32>"* null, %"struct.list.ListNode<i32>"** %tmp0
    %tmp1 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %v0, i32 0, i32 1
    store %"struct.list.ListNode<i32>"* null, %"struct.list.ListNode<i32>"** %tmp1
    %tmp2 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %v0, i32 0, i32 2
    store i32 0, i32* %tmp2
    %tmp3 = load %"struct.list.List<i32>", %"struct.list.List<i32>"* %v0
    ret %"struct.list.List<i32>" %tmp3
}
define void @"list.extend<i32>"(%"struct.list.List<i32>"* %list, i32 %data){
    %v0 = alloca %"struct.list.ListNode<i32>"*; var: node_to_add
    %tmp0 = call i8* @mem.malloc(i64 16)
    %tmp1 = bitcast i8* %tmp0 to %"struct.list.ListNode<i32>"*
    store %"struct.list.ListNode<i32>"* %tmp1, %"struct.list.ListNode<i32>"** %v0
    %tmp2 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v0
    call void @"list.new_node<i32>"(%"struct.list.ListNode<i32>"* %tmp2)
    %tmp3 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v0
    %tmp4 = getelementptr inbounds %"struct.list.ListNode<i32>", %"struct.list.ListNode<i32>"* %tmp3, i32 0, i32 0
    store i32 %data, i32* %tmp4
    %tmp5 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %list, i32 0, i32 0
    %tmp6 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %tmp5
    %tmp7 = icmp eq ptr %tmp6, null
    br i1 %tmp7, label %then0, label %else0
then0:
    %tmp8 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %list, i32 0, i32 0
    %tmp9 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v0
    store %"struct.list.ListNode<i32>"* %tmp9, %"struct.list.ListNode<i32>"** %tmp8
    %tmp10 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %list, i32 0, i32 1
    %tmp11 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v0
    store %"struct.list.ListNode<i32>"* %tmp11, %"struct.list.ListNode<i32>"** %tmp10
    br label %endif0
else0:
    %tmp12 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %list, i32 0, i32 1
    %tmp13 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %list, i32 0, i32 1
    %tmp14 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %tmp13
    %tmp15 = getelementptr inbounds %"struct.list.ListNode<i32>", %"struct.list.ListNode<i32>"* %tmp14, i32 0, i32 1
    %tmp16 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v0
    store %"struct.list.ListNode<i32>"* %tmp16, %"struct.list.ListNode<i32>"** %tmp15
    %tmp17 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %list, i32 0, i32 1
    %tmp18 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v0
    store %"struct.list.ListNode<i32>"* %tmp18, %"struct.list.ListNode<i32>"** %tmp17
    br label %endif0
endif0:
    %tmp19 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %list, i32 0, i32 2
    %tmp20 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %list, i32 0, i32 2
    %tmp21 = load i32, i32* %tmp20
    %tmp22 = add i32 %tmp21, 1
    store i32 %tmp22, i32* %tmp19
    ret void
}
define i32 @"list.walk<i32>"(%"struct.list.List<i32>"* %list){
    %v0 = alloca i32; var: l
    %v1 = alloca %"struct.list.ListNode<i32>"*; var: ptr
    store i32 0, i32* %v0
    %tmp0 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %list, i32 0, i32 0
    %tmp1 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %tmp0
    store %"struct.list.ListNode<i32>"* %tmp1, %"struct.list.ListNode<i32>"** %v1
    br label %loop_body0
loop_body0:
    %tmp2 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v1
    %tmp3 = icmp eq ptr %tmp2, null
    br i1 %tmp3, label %then1, label %endif1
then1:
    br label %loop_body0_exit
    br label %endif1
endif1:
    %tmp4 = load i32, i32* %v0
    %tmp5 = add i32 %tmp4, 1
    store i32 %tmp5, i32* %v0
    %tmp6 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v1
    %tmp7 = getelementptr inbounds %"struct.list.ListNode<i32>", %"struct.list.ListNode<i32>"* %tmp6, i32 0, i32 1
    %tmp8 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %tmp7
    store %"struct.list.ListNode<i32>"* %tmp8, %"struct.list.ListNode<i32>"** %v1
    br label %loop_body0
loop_body0_exit:
    %tmp9 = load i32, i32* %v0
    ret i32 %tmp9
}
define void @"list.free<i32>"(%"struct.list.List<i32>"* %list){
    %v0 = alloca %"struct.list.ListNode<i32>"*; var: current
    %v1 = alloca %"struct.list.ListNode<i32>"*; var: next
    %tmp0 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %list, i32 0, i32 0
    %tmp1 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %tmp0
    store %"struct.list.ListNode<i32>"* %tmp1, %"struct.list.ListNode<i32>"** %v0
    br label %loop_body0
loop_body0:
    %tmp2 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v0
    %tmp3 = icmp eq ptr %tmp2, null
    br i1 %tmp3, label %then1, label %endif1
then1:
    br label %loop_body0_exit
    br label %endif1
endif1:
    %tmp4 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v0
    %tmp5 = getelementptr inbounds %"struct.list.ListNode<i32>", %"struct.list.ListNode<i32>"* %tmp4, i32 0, i32 1
    %tmp6 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %tmp5
    store %"struct.list.ListNode<i32>"* %tmp6, %"struct.list.ListNode<i32>"** %v1
    %tmp7 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v0
    %tmp8 = bitcast %"struct.list.ListNode<i32>"* %tmp7 to i8*
    call void @mem.free(i8* %tmp8)
    %tmp9 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v1
    store %"struct.list.ListNode<i32>"* %tmp9, %"struct.list.ListNode<i32>"** %v0
    br label %loop_body0
loop_body0_exit:
    %tmp10 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %list, i32 0, i32 0
    store %"struct.list.ListNode<i32>"* null, %"struct.list.ListNode<i32>"** %tmp10
    %tmp11 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %list, i32 0, i32 1
    store %"struct.list.ListNode<i32>"* null, %"struct.list.ListNode<i32>"** %tmp11
    %tmp12 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %list, i32 0, i32 2
    store i32 0, i32* %tmp12
    ret void
}
define %"struct.vector.Vec<i8>" @"vector.new<i8>"(){
    %v0 = alloca %"struct.vector.Vec<i8>"; var: vec
    %tmp0 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 0
    store i8* null, i8** %tmp0
    %tmp1 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 1
    store i32 0, i32* %tmp1
    %tmp2 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 2
    store i32 0, i32* %tmp2
    %tmp3 = load %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0
    ret %"struct.vector.Vec<i8>" %tmp3
}
define %"struct.vector.Vec<%struct.string.String>" @"vector.new<%struct.string.String>"(){
    %v0 = alloca %"struct.vector.Vec<%struct.string.String>"; var: vec
    %tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %v0, i32 0, i32 0
    store %struct.string.String* null, %struct.string.String** %tmp0
    %tmp1 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %v0, i32 0, i32 1
    store i32 0, i32* %tmp1
    %tmp2 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %v0, i32 0, i32 2
    store i32 0, i32* %tmp2
    %tmp3 = load %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %v0
    ret %"struct.vector.Vec<%struct.string.String>" %tmp3
}
define %"struct.vector.Vec<i64>" @"vector.new<i64>"(){
    %v0 = alloca %"struct.vector.Vec<i64>"; var: vec
    %tmp0 = getelementptr inbounds %"struct.vector.Vec<i64>", %"struct.vector.Vec<i64>"* %v0, i32 0, i32 0
    store i64* null, i64** %tmp0
    %tmp1 = getelementptr inbounds %"struct.vector.Vec<i64>", %"struct.vector.Vec<i64>"* %v0, i32 0, i32 1
    store i32 0, i32* %tmp1
    %tmp2 = getelementptr inbounds %"struct.vector.Vec<i64>", %"struct.vector.Vec<i64>"* %v0, i32 0, i32 2
    store i32 0, i32* %tmp2
    %tmp3 = load %"struct.vector.Vec<i64>", %"struct.vector.Vec<i64>"* %v0
    ret %"struct.vector.Vec<i64>" %tmp3
}
define void @"vector.push<i8>"(%"struct.vector.Vec<i8>"* %vec, i8 %data){
    %v0 = alloca i32; var: new_capacity
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
    %tmp13 = mul i64 %tmp12, 1
    %tmp14 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 0
    %tmp15 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 0
    %tmp16 = load i8*, i8** %tmp15
    %tmp17 = bitcast i8* %tmp16 to i8*
    %tmp18 = call i8* @mem.realloc(i8* %tmp17, i64 %tmp13)
    %tmp19 = bitcast i8* %tmp18 to i8*
    store i8* %tmp19, i8** %tmp14
    %tmp20 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 2
    %tmp21 = load i32, i32* %v0
    store i32 %tmp21, i32* %tmp20
    br label %endif0
endif0:
    %tmp22 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 0
    %tmp23 = load i8*, i8** %tmp22
    %tmp24 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 1
    %tmp25 = load i32, i32* %tmp24
    %tmp26 = getelementptr inbounds i8, i8* %tmp23, i32 %tmp25
    store i8 %data, i8* %tmp26
    %tmp27 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 1
    %tmp28 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 1
    %tmp29 = load i32, i32* %tmp28
    %tmp30 = add i32 %tmp29, 1
    store i32 %tmp30, i32* %tmp27
    ret void
}
define void @"vector.push<%struct.string.String>"(%"struct.vector.Vec<%struct.string.String>"* %vec, %struct.string.String %data){
    %v0 = alloca i32; var: new_capacity
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
    %tmp13 = mul i64 %tmp12, 16
    %tmp14 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 0
    %tmp15 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 0
    %tmp16 = load %struct.string.String*, %struct.string.String** %tmp15
    %tmp17 = bitcast %struct.string.String* %tmp16 to i8*
    %tmp18 = call i8* @mem.realloc(i8* %tmp17, i64 %tmp13)
    %tmp19 = bitcast i8* %tmp18 to %struct.string.String*
    store %struct.string.String* %tmp19, %struct.string.String** %tmp14
    %tmp20 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 2
    %tmp21 = load i32, i32* %v0
    store i32 %tmp21, i32* %tmp20
    br label %endif0
endif0:
    %tmp22 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 0
    %tmp23 = load %struct.string.String*, %struct.string.String** %tmp22
    %tmp24 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 1
    %tmp25 = load i32, i32* %tmp24
    %tmp26 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp23, i32 %tmp25
    store %struct.string.String %data, %struct.string.String* %tmp26
    %tmp27 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 1
    %tmp28 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 1
    %tmp29 = load i32, i32* %tmp28
    %tmp30 = add i32 %tmp29, 1
    store i32 %tmp30, i32* %tmp27
    ret void
}
define void @"vector.push_bulk<i8>"(%"struct.vector.Vec<i8>"* %vec, i8* %data, i32 %data_len){
    %v0 = alloca i32; var: index
    store i32 0, i32* %v0
    br label %loop_body0
loop_body0:
    %tmp0 = load i32, i32* %v0
    %tmp1 = icmp sge i32 %tmp0, %data_len
    br i1 %tmp1, label %then1, label %endif1
then1:
    br label %loop_body0_exit
    br label %endif1
endif1:
    %tmp2 = load i32, i32* %v0
    %tmp3 = getelementptr inbounds i8, i8* %data, i32 %tmp2
    %tmp4 = load i8, i8* %tmp3
    call void @"vector.push<i8>"(%"struct.vector.Vec<i8>"* %vec, i8 %tmp4)
    %tmp5 = load i32, i32* %v0
    %tmp6 = add i32 %tmp5, 1
    store i32 %tmp6, i32* %v0
    br label %loop_body0
loop_body0_exit:
    ret void
}
define void @"vector.free<i8>"(%"struct.vector.Vec<i8>"* %vec){
    %tmp0 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 0
    %tmp1 = load i8*, i8** %tmp0
    %tmp2 = icmp ne ptr %tmp1, null
    br i1 %tmp2, label %then0, label %endif0
then0:
    %tmp3 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 0
    %tmp4 = load i8*, i8** %tmp3
    %tmp5 = bitcast i8* %tmp4 to i8*
    call void @mem.free(i8* %tmp5)
    br label %endif0
endif0:
    %tmp6 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 0
    store i8* null, i8** %tmp6
    %tmp7 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 1
    store i32 0, i32* %tmp7
    %tmp8 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 2
    store i32 0, i32* %tmp8
    ret void
}
define void @"vector.free<%struct.string.String>"(%"struct.vector.Vec<%struct.string.String>"* %vec){
    %tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 0
    %tmp1 = load %struct.string.String*, %struct.string.String** %tmp0
    %tmp2 = icmp ne ptr %tmp1, null
    br i1 %tmp2, label %then0, label %endif0
then0:
    %tmp3 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 0
    %tmp4 = load %struct.string.String*, %struct.string.String** %tmp3
    %tmp5 = bitcast %struct.string.String* %tmp4 to i8*
    call void @mem.free(i8* %tmp5)
    br label %endif0
endif0:
    %tmp6 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 0
    store %struct.string.String* null, %struct.string.String** %tmp6
    %tmp7 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 1
    store i32 0, i32* %tmp7
    %tmp8 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 2
    store i32 0, i32* %tmp8
    ret void
}
define %"struct.Pair<i32, struct.Pair<i8, %struct.string.String>>" @"ax<i32>"(){
    %v0 = alloca %"struct.Pair<i32, struct.Pair<i8, %struct.string.String>>"; var: p
    %tmp0 = getelementptr inbounds %"struct.Pair<i32, struct.Pair<i8, %struct.string.String>>", %"struct.Pair<i32, struct.Pair<i8, %struct.string.String>>"* %v0, i32 0, i32 0
    store i32 43, i32* %tmp0
    %tmp1 = getelementptr inbounds %"struct.Pair<i32, struct.Pair<i8, %struct.string.String>>", %"struct.Pair<i32, struct.Pair<i8, %struct.string.String>>"* %v0, i32 0, i32 1
    %tmp2 = getelementptr inbounds %"struct.Pair<i8, %struct.string.String>", %"struct.Pair<i8, %struct.string.String>"* %tmp1, i32 0, i32 0
    store i8 126, i8* %tmp2
    %tmp3 = load %"struct.Pair<i32, struct.Pair<i8, %struct.string.String>>", %"struct.Pair<i32, struct.Pair<i8, %struct.string.String>>"* %v0
    ret %"struct.Pair<i32, struct.Pair<i8, %struct.string.String>>" %tmp3
}
define void @"list.new_node<i32>"(%"struct.list.ListNode<i32>"* %list){
    %tmp0 = getelementptr inbounds %"struct.list.ListNode<i32>", %"struct.list.ListNode<i32>"* %list, i32 0, i32 1
    store %"struct.list.ListNode<i32>"* null, %"struct.list.ListNode<i32>"** %tmp0
    %tmp1 = getelementptr inbounds %"struct.list.ListNode<i32>", %"struct.list.ListNode<i32>"* %list, i32 0, i32 0
    store i32 0, i32* %tmp1
    ret void
}

;fn __chkstk used times 0
;fn _fltused used times 0
;fn process.ExitProcess used times 4
;fn process.GetModuleFileNameA used times 1
;fn process.get_executable_path used times 2
;fn process.get_executable_env_path used times 2
;fn process.throw used times 51
;fn mem.GetProcessHeap used times 4
;fn mem.HeapAlloc used times 1
;fn mem.HeapReAlloc used times 1
;fn mem.HeapFree used times 1
;fn mem.HeapSize used times 0
;fn mem.HeapWalk used times 1
;fn mem.HeapLock used times 1
;fn mem.HeapUnlock used times 1
;fn mem.malloc used times 8
;fn mem.realloc used times 0
;fn mem.free used times 4
;fn mem.copy used times 12
;fn mem.compare used times 1
;fn mem.fill used times 3
;fn mem.zero_fill used times 2
;fn mem.default_fill used times 0
;fn mem.get_total_allocated_memory_external used times 2
;fn list.new used times 2
;fn list.new_node used times 0
;fn list.extend used times 6
;fn list.walk used times 2
;fn list.free used times 2
;fn vector.new used times 6
;fn vector.push used times 16
;fn vector.push_bulk used times 2
;fn vector.remove_at used times 0
;fn vector.free used times 4
;fn console.AllocConsole used times 2
;fn console.GetStdHandle used times 2
;fn console.FreeConsole used times 1
;fn console.WriteConsoleA used times 4
;fn console.get_stdout used times 4
;fn console.write used times 18
;fn console.write_string used times 0
;fn console.writeln used times 15
;fn console.print_char used times 9
;fn console.println_i64 used times 7
;fn console.println_u64 used times 3
;fn console.println_f64 used times 2
;fn string.from_c_string used times 5
;fn string.empty used times 1
;fn string.with_size used times 5
;fn string.clone used times 0
;fn string.concat_with_c_string used times 2
;fn string.equal used times 4
;fn string.free used times 14
;fn string.as_c_string_stalloc used times 1
;fn string_utils.insert used times 2
;fn string_utils.c_str_len used times 7
;fn string_utils.is_ascii_num used times 5
;fn string_utils.is_ascii_char used times 4
;fn string_utils.is_ascii_hex used times 3
;fn fs.CreateFileA used times 3
;fn fs.WriteFile used times 1
;fn fs.ReadFile used times 1
;fn fs.GetFileSizeEx used times 1
;fn fs.CloseHandle used times 4
;fn fs.DeleteFileA used times 1
;fn fs.GetFileAttributesA used times 1
;fn fs.write_to_file used times 1
;fn fs.read_full_file_as_string used times 2
;fn fs.create_file used times 3
;fn fs.delete_file used times 3
;fn fs.file_exists used times 1
;fn tests.run used times 1
;fn tests.mem_test used times 1
;fn tests.string_utils_test used times 1
;fn tests.string_test used times 1
;fn tests.vector_test used times 1
;fn tests.list_test used times 1
;fn tests.process_test used times 1
;fn tests.console_test used times 1
;fn tests.fs_test used times 1
;fn tests.consume_while used times 3
;fn tests.not_new_line used times 1
;fn tests.valid_name_token used times 1
;fn tests.is_valid_number_token used times 1
;fn tests.funny used times 1
;fn window.RegisterClassA used times 0
;fn window.CreateWindowExA used times 2
;fn window.DefWindowProcA used times 2
;fn window.GetMessageA used times 2
;fn window.TranslateMessage used times 2
;fn window.DispatchMessageA used times 2
;fn window.PostQuitMessage used times 4
;fn window.BeginPaint used times 1
;fn window.EndPaint used times 1
;fn window.GetDC used times 0
;fn window.ReleaseDC used times 0
;fn window.LoadCursorA used times 0
;fn window.LoadIconA used times 0
;fn window.LoadImageA used times 1
;fn window.GetClientRect used times 1
;fn window.InvalidateRect used times 1
;fn window.GetModuleHandleA used times 2
;fn window.RegisterClassExA used times 2
;fn window.ShowWindow used times 2
;fn window.CreateCompatibleDC used times 2
;fn window.SelectObject used times 4
;fn window.BitBlt used times 1
;fn window.DeleteDC used times 2
;fn window.DeleteObject used times 0
;fn window.GetObjectA used times 3
;fn window.SetStretchBltMode used times 1
;fn window.StretchBlt used times 1
;fn window.SetWindowLongPtrA used times 1
;fn window.GetWindowLongPtrA used times 1
;fn window.WindowProc used times 2
;fn window.load_bitmap_from_file used times 1
;fn window.get_bitmap_dimensions used times 1
;fn window.draw_bitmap used times 1
;fn window.draw_bitmap_stretched used times 0
;fn window.is_null used times 4
;fn window.start used times 1
;fn window.start_image_window used times 0
;fn basic_functions used times 1
;fn ax used times 1
;fn ay used times 0
;fn of_fn used times 1
;fn test.geg used times 1
;fn xq used times 1
;fn main used times 1
