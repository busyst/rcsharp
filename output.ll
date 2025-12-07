target triple = "x86_64-pc-windows-msvc"
;./src.rcsharp
%struct.mem.PROCESS_HEAP_ENTRY = type { i8*, i32, i8, i8, i16, i8*, i32, i32, i32 }
%struct.string.String = type { i8*, i32 }
%struct.window.WNDCLASSEXA = type { i32, i32, i64 (i8*, i32, i64, i64)**, i32, i32, i8*, i8*, i8*, i8*, i8*, i8*, i8* }
%struct.window.POINT = type { i32, i32 }
%struct.window.MSG = type { i8*, i32, i64, i64, i32, %struct.window.POINT }
%"struct.list.List<i32>" = type { %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"*, i32 }
%"struct.list.ListNode<i32>" = type { i32, %"struct.list.ListNode<i32>"* }
%"struct.vector.Vec<i8>" = type { i8*, i32, i32 }
%"struct.vector.Vec<%struct.string.String>" = type { %struct.string.String*, i32, i32 }
%"struct.test.QPair<i64, i64>" = type { i64, i64 }

declare dllimport void @ExitProcess(i32)
declare dllimport i32 @GetModuleFileNameA(i8*,i8*,i32)
declare dllimport i32* @GetProcessHeap()
declare dllimport i8* @HeapAlloc(i32*,i32,i64)
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
declare dllimport i16 @RegisterClassExA(%struct.window.WNDCLASSEXA*)
declare dllimport i8* @CreateWindowExA(i32,i8*,i8*,i32,i32,i32,i32,i32,i8*,i8*,i8*,i8*)
declare dllimport i32 @ShowWindow(i8*,i32)
declare dllimport i32 @UpdateWindow(i8*)
declare dllimport i32 @PeekMessageA(%struct.window.MSG*,i8*,i32,i32,i32)
declare dllimport i32 @TranslateMessage(%struct.window.MSG*)
declare dllimport i64 @DispatchMessageA(%struct.window.MSG*)
declare dllimport i64 @DefWindowProcA(i8*,i32,i64,i64)
declare dllimport void @PostQuitMessage(i32)
declare dllimport i8* @GetModuleHandleA(i8*)
declare dllimport i32 @MessageBoxA(i8*,i8*,i8*,i32)

@.str.0 = private unnamed_addr constant [12 x i8] c"Exception: \00"
@.str.1 = private unnamed_addr constant [33 x i8] c"Failed to lock heap for walking.\00"
@.str.2 = private unnamed_addr constant [26 x i8] c"stdout handle was invalid\00"
@.str.3 = private unnamed_addr constant [3 x i8] c"0\0A\00"
@.str.4 = private unnamed_addr constant [20 x i8] c"File  was not found\00"
@.str.5 = private unnamed_addr constant [17 x i8] c"File read failed\00"
@.str.6 = private unnamed_addr constant [20 x i8] c"test malloc delta: \00"
@.str.7 = private unnamed_addr constant [11 x i8] c"mem_test: \00"
@.str.8 = private unnamed_addr constant [24 x i8] c"mem_test: malloc failed\00"
@.str.9 = private unnamed_addr constant [35 x i8] c"mem_test: fill verification failed\00"
@.str.10 = private unnamed_addr constant [40 x i8] c"mem_test: zero_fill verification failed\00"
@.str.11 = private unnamed_addr constant [33 x i8] c"mem_test: malloc for copy failed\00"
@.str.12 = private unnamed_addr constant [35 x i8] c"mem_test: copy verification failed\00"
@.str.13 = private unnamed_addr constant [3 x i8] c"OK\00"
@.str.14 = private unnamed_addr constant [20 x i8] c"string_utils_test: \00"
@.str.15 = private unnamed_addr constant [5 x i8] c"test\00"
@.str.16 = private unnamed_addr constant [36 x i8] c"string_utils_test: c_str_len failed\00"
@.str.17 = private unnamed_addr constant [1 x i8] c"\00"
@.str.18 = private unnamed_addr constant [42 x i8] c"string_utils_test: c_str_len empty failed\00"
@.str.19 = private unnamed_addr constant [39 x i8] c"string_utils_test: is_ascii_num failed\00"
@.str.20 = private unnamed_addr constant [40 x i8] c"string_utils_test: is_ascii_char failed\00"
@.str.21 = private unnamed_addr constant [39 x i8] c"string_utils_test: is_ascii_hex failed\00"
@.str.22 = private unnamed_addr constant [3 x i8] c"ac\00"
@.str.23 = private unnamed_addr constant [2 x i8] c"b\00"
@.str.24 = private unnamed_addr constant [4 x i8] c"abc\00"
@.str.25 = private unnamed_addr constant [33 x i8] c"string_utils_test: insert failed\00"
@.str.26 = private unnamed_addr constant [14 x i8] c"string_test: \00"
@.str.27 = private unnamed_addr constant [6 x i8] c"hello\00"
@.str.28 = private unnamed_addr constant [6 x i8] c"world\00"
@.str.29 = private unnamed_addr constant [41 x i8] c"string_test: from_c_string length failed\00"
@.str.30 = private unnamed_addr constant [40 x i8] c"string_test: equal positive case failed\00"
@.str.31 = private unnamed_addr constant [40 x i8] c"string_test: equal negative case failed\00"
@.str.32 = private unnamed_addr constant [7 x i8] c" world\00"
@.str.33 = private unnamed_addr constant [12 x i8] c"hello world\00"
@.str.34 = private unnamed_addr constant [34 x i8] c"string_test: concat length failed\00"
@.str.35 = private unnamed_addr constant [35 x i8] c"string_test: concat content failed\00"
@.str.36 = private unnamed_addr constant [14 x i8] c"vector_test: \00"
@.str.37 = private unnamed_addr constant [24 x i8] c"vector_test: new failed\00"
@.str.38 = private unnamed_addr constant [33 x i8] c"vector_test: initial push failed\00"
@.str.39 = private unnamed_addr constant [36 x i8] c"vector_test: initial content failed\00"
@.str.40 = private unnamed_addr constant [28 x i8] c"vector_test: realloc failed\00"
@.str.41 = private unnamed_addr constant [36 x i8] c"vector_test: realloc content failed\00"
@.str.42 = private unnamed_addr constant [3 x i8] c"AB\00"
@.str.43 = private unnamed_addr constant [37 x i8] c"vector_test: push_bulk length failed\00"
@.str.44 = private unnamed_addr constant [38 x i8] c"vector_test: push_bulk content failed\00"
@.str.45 = private unnamed_addr constant [25 x i8] c"vector_test: free failed\00"
@.str.46 = private unnamed_addr constant [12 x i8] c"list_test: \00"
@.str.47 = private unnamed_addr constant [22 x i8] c"list_test: new failed\00"
@.str.48 = private unnamed_addr constant [41 x i8] c"list_test: length incorrect after extend\00"
@.str.49 = private unnamed_addr constant [33 x i8] c"list_test: walk length incorrect\00"
@.str.50 = private unnamed_addr constant [36 x i8] c"list_test: data mismatch for node 1\00"
@.str.51 = private unnamed_addr constant [36 x i8] c"list_test: data mismatch for node 2\00"
@.str.52 = private unnamed_addr constant [36 x i8] c"list_test: data mismatch for node 3\00"
@.str.53 = private unnamed_addr constant [33 x i8] c"list_test: foot pointer mismatch\00"
@.str.54 = private unnamed_addr constant [23 x i8] c"list_test: free failed\00"
@.str.55 = private unnamed_addr constant [15 x i8] c"process_test: \00"
@.str.56 = private unnamed_addr constant [49 x i8] c"process_test: get_executable_path returned empty\00"
@.str.57 = private unnamed_addr constant [53 x i8] c"process_test: get_executable_env_path returned empty\00"
@.str.58 = private unnamed_addr constant [53 x i8] c"process_test: env path is not shorter than full path\00"
@.str.59 = private unnamed_addr constant [53 x i8] c"process_test: env path does not end with a backslash\00"
@.str.60 = private unnamed_addr constant [18 x i8] c"Executable Path: \00"
@.str.61 = private unnamed_addr constant [19 x i8] c"Environment Path: \00"
@.str.62 = private unnamed_addr constant [15 x i8] c"\0Aconsole_test:\00"
@.str.63 = private unnamed_addr constant [26 x i8] c"--- VISUAL TEST START ---\00"
@.str.64 = private unnamed_addr constant [22 x i8] c"Printing i64(12345): \00"
@.str.65 = private unnamed_addr constant [23 x i8] c"Printing i64(-67890): \00"
@.str.66 = private unnamed_addr constant [18 x i8] c"Printing i64(0): \00"
@.str.67 = private unnamed_addr constant [27 x i8] c"Printing u64(9876543210): \00"
@.str.68 = private unnamed_addr constant [24 x i8] c"--- VISUAL TEST END ---\00"
@.str.69 = private unnamed_addr constant [10 x i8] c"fs_test: \00"
@.str.70 = private unnamed_addr constant [47 x i8] c"The quick brown fox jumps over crazy lost dog.\00"
@.str.71 = private unnamed_addr constant [9 x i8] c"test.txt\00"
@.str.72 = private unnamed_addr constant [38 x i8] c"Filesystem test failed, data mismatch\00"
@.str.73 = private unnamed_addr constant [45 x i8] c"D:\Projects\rcsharp\src_base_structs.rcsharp\00"
@.str.74 = private unnamed_addr constant [2 x i8] c"\0A\00"
@.str.75 = private unnamed_addr constant [48 x i8] c"Window error: StartError::GetModuleHandleFailed\00"
@.str.76 = private unnamed_addr constant [14 x i8] c"MyWindowClass\00"
@.str.77 = private unnamed_addr constant [46 x i8] c"Window error: StartError::RegisterClassFailed\00"
@.str.78 = private unnamed_addr constant [14 x i8] c"Hello, World!\00"
@.str.79 = private unnamed_addr constant [45 x i8] c"Window error: StartError::CreateWindowFailed\00"
define void @"__chkstk"(){
    ret void
}
define i32 @"_fltused"(){
    ret i32 0
}
define %struct.string.String @"process.get_executable_path"(){
    %v0 = alloca %struct.string.String; var: string
    %v1 = alloca i32; var: len
    %tmp0 = call %struct.string.String @string.with_size(i32 260)
    store %struct.string.String %tmp0, %struct.string.String* %v0
    %tmp1 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
    %tmp2 = load i8*, i8** %tmp1
    %tmp3 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
    %tmp4 = load i32, i32* %tmp3
    %tmp6 = call i32 @GetModuleFileNameA(i8* null, i8* %tmp2, i32 %tmp4)
    store i32 %tmp6, i32* %v1
    %tmp7 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
    %tmp8 = load i32, i32* %v1
    store i32 %tmp8, i32* %tmp7
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
    %v0 = alloca i32; var: len
    %v1 = alloca i32; var: chars_written
    %v2 = alloca i8*; var: stdout_handle
    %v3 = alloca i8*; var: e
    %v4 = alloca i8; var: nl
    %tmp0 = call i32 @string_utils.c_str_len(i8* %exception)
    store i32 %tmp0, i32* %v0
    call i32 @AllocConsole()
    %tmp1 = call i8* @GetStdHandle(i32 -11)
    store i8* %tmp1, i8** %v2
    %tmp2 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.0, i64 0, i64 0
    store i8* %tmp2, i8** %v3
    %tmp3 = load i8*, i8** %v2
    %tmp4 = load i8*, i8** %v3
    %tmp5 = load i8*, i8** %v3
    %tmp6 = call i32 @string_utils.c_str_len(i8* %tmp5)
    call i32 @WriteConsoleA(i8* %tmp3, i8* %tmp4, i32 %tmp6, i32* %v1, i8* null)
    %tmp7 = load i8*, i8** %v2
    %tmp8 = load i32, i32* %v0
    call i32 @WriteConsoleA(i8* %tmp7, i8* %exception, i32 %tmp8, i32* %v1, i8* null)
    store i8 10, i8* %v4
    %tmp9 = load i8*, i8** %v2
    call i32 @WriteConsoleA(i8* %tmp9, i8* %v4, i32 1, i32* %v1, i8* null)
    call void @ExitProcess(i32 -1)
    ret void
}
define i8* @"mem.malloc"(i64 %size){
    %tmp0 = call i32* @GetProcessHeap()
    %tmp1 = call i8* @HeapAlloc(i32* %tmp0, i32 0, i64 %size)
    ret i8* %tmp1
}
define void @"mem.free"(i8* %ptr){
    %tmp0 = call i32* @GetProcessHeap()
    call i32 @HeapFree(i32* %tmp0, i32 0, i8* %ptr)
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
define void @"mem.zero_fill"(i8* %dest, i64 %len){
    call void @mem.fill(i8 0, i8* %dest, i64 %len)
    ret void
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
define i64 @"mem.get_total_allocated_memory_external"(){
    %v0 = alloca i32*; var: hHeap
    %v1 = alloca i64; var: total_size
    %v2 = alloca %struct.mem.PROCESS_HEAP_ENTRY; var: entry
    %tmp0 = call i32* @GetProcessHeap()
    store i32* %tmp0, i32** %v0
    store i64 0, i64* %v1
    %tmp1 = getelementptr inbounds %struct.mem.PROCESS_HEAP_ENTRY, %struct.mem.PROCESS_HEAP_ENTRY* %v2, i32 0, i32 0
    store i8* null, i8** %tmp1
    %tmp2 = load i32*, i32** %v0
    %tmp3 = call i32 @HeapLock(i32* %tmp2)
    %tmp4 = icmp eq i32 %tmp3, 0
    br i1 %tmp4, label %then0, label %endif0
then0:
    %tmp5 = getelementptr inbounds [33 x i8], [33 x i8]* @.str.1, i64 0, i64 0
    call void @process.throw(i8* %tmp5)
    br label %endif0
endif0:
    br label %loop_body1
loop_body1:
    %tmp6 = load i32*, i32** %v0
    %tmp7 = call i32 @HeapWalk(i32* %tmp6, %struct.mem.PROCESS_HEAP_ENTRY* %v2)
    %tmp8 = icmp eq i32 %tmp7, 0
    br i1 %tmp8, label %then2, label %endif2
then2:
    br label %loop_body1_exit
    br label %endif2
endif2:
    %tmp9 = getelementptr inbounds %struct.mem.PROCESS_HEAP_ENTRY, %struct.mem.PROCESS_HEAP_ENTRY* %v2, i32 0, i32 4
    %tmp10 = load i16, i16* %tmp9
    %tmp11 = and i16 %tmp10, 4
    %tmp12 = icmp ne i16 %tmp11, 0
    br i1 %tmp12, label %then3, label %endif3
then3:
    %tmp13 = load i64, i64* %v1
    %tmp14 = getelementptr inbounds %struct.mem.PROCESS_HEAP_ENTRY, %struct.mem.PROCESS_HEAP_ENTRY* %v2, i32 0, i32 1
    %tmp15 = load i32, i32* %tmp14
    %tmp16 = zext i32 %tmp15 to i64
    %tmp17 = add i64 %tmp13, %tmp16
    store i64 %tmp17, i64* %v1
    br label %endif3
endif3:
    br label %loop_body1
loop_body1_exit:
    %tmp18 = load i32*, i32** %v0
    call i32 @HeapUnlock(i32* %tmp18)
    %tmp19 = load i64, i64* %v1
    ret i64 %tmp19
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
    %tmp4 = getelementptr inbounds [26 x i8], [26 x i8]* @.str.2, i64 0, i64 0
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
    %v0 = alloca i8*; var: buffer
    %v1 = alloca i32; var: i
    %v2 = alloca i64; var: mut_n
    %v3 = alloca i8*; var: start_ptr
    %v4 = alloca i32; var: len
    %tmp0 = mul i64 1, 22
    %tmp1 = alloca i8, i64 %tmp0
    store i8* %tmp1, i8** %v0
    store i32 20, i32* %v1
    %tmp2 = icmp eq i64 %n, 0
    br i1 %tmp2, label %then0, label %endif0
then0:
    %tmp3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.3, i64 0, i64 0
    call void @console.write(i8* %tmp3, i32 2)
    ret void
    br label %endif0
endif0:
    store i64 %n, i64* %v2
    br label %loop_body1
loop_body1:
    %tmp4 = load i8*, i8** %v0
    %tmp5 = load i32, i32* %v1
    %tmp6 = getelementptr inbounds i8, i8* %tmp4, i32 %tmp5
    %tmp7 = load i64, i64* %v2
    %tmp8 = urem i64 %tmp7, 10
    %tmp9 = trunc i64 %tmp8 to i8
    %tmp10 = add i8 %tmp9, 48
    store i8 %tmp10, i8* %tmp6
    %tmp11 = load i64, i64* %v2
    %tmp12 = udiv i64 %tmp11, 10
    store i64 %tmp12, i64* %v2
    %tmp13 = load i32, i32* %v1
    %tmp14 = sub i32 %tmp13, 1
    store i32 %tmp14, i32* %v1
    %tmp15 = load i64, i64* %v2
    %tmp16 = icmp eq i64 %tmp15, 0
    br i1 %tmp16, label %then2, label %endif2
then2:
    br label %loop_body1_exit
    br label %endif2
endif2:
    br label %loop_body1
loop_body1_exit:
    %tmp17 = load i8*, i8** %v0
    %tmp18 = getelementptr inbounds i8, i8* %tmp17, i64 21
    store i8 10, i8* %tmp18
    %tmp19 = load i8*, i8** %v0
    %tmp20 = load i32, i32* %v1
    %tmp21 = add i32 %tmp20, 1
    %tmp22 = getelementptr inbounds i8, i8* %tmp19, i32 %tmp21
    store i8* %tmp22, i8** %v3
    %tmp23 = trunc i64 21 to i32
    %tmp24 = load i32, i32* %v1
    %tmp25 = add i32 %tmp24, 1
    %tmp26 = sub i32 %tmp23, %tmp25
    %tmp27 = add i32 %tmp26, 1
    store i32 %tmp27, i32* %v4
    %tmp28 = load i8*, i8** %v3
    %tmp29 = load i32, i32* %v4
    call void @console.write(i8* %tmp28, i32 %tmp29)
    ret void
}
define void @"console.println_f64"(double %n){
    %v0 = alloca i32; var: PRECISION
    %v1 = alloca double; var: mut_n
    %v2 = alloca double; var: rounder
    %v3 = alloca i32; var: i
    %v4 = alloca i64; var: integer_part
    %v5 = alloca double; var: fractional_part
    %v6 = alloca i8*; var: buffer
    %v7 = alloca i32; var: i
    %v8 = alloca i64; var: temp_int
    %v9 = alloca i8*; var: start_ptr
    %v10 = alloca i32; var: len
    %v11 = alloca i32; var: i
    %v12 = alloca i64; var: digit
    store i32 6, i32* %v0
    store double %n, double* %v1
    %tmp1 = fcmp olt double %n, 0x0
    br i1 %tmp1, label %then0, label %endif0
then0:
    call void @console.print_char(i8 45)
    %tmp2 = load double, double* %v1
    %tmp3 = fsub double 0.0, %tmp2
    store double %tmp3, double* %v1
    br label %endif0
endif0:
    store double 0x3FE0000000000000, double* %v2
    store i32 0, i32* %v3
    br label %loop_body1
loop_body1:
    %tmp5 = load i32, i32* %v3
    %tmp6 = load i32, i32* %v0
    %tmp7 = icmp sge i32 %tmp5, %tmp6
    br i1 %tmp7, label %then2, label %endif2
then2:
    br label %loop_body1_exit
    br label %endif2
endif2:
    %tmp8 = load double, double* %v2
    %tmp10 = fdiv double %tmp8, 0x4024000000000000
    store double %tmp10, double* %v2
    %tmp11 = load i32, i32* %v3
    %tmp12 = add i32 %tmp11, 1
    store i32 %tmp12, i32* %v3
    br label %loop_body1
loop_body1_exit:
    %tmp13 = load double, double* %v1
    %tmp14 = load double, double* %v2
    %tmp15 = fadd double %tmp13, %tmp14
    store double %tmp15, double* %v1
    %tmp16 = load double, double* %v1
    %tmp17 = fptoui double %tmp16 to i64
    store i64 %tmp17, i64* %v4
    %tmp18 = load double, double* %v1
    %tmp19 = load i64, i64* %v4
    %tmp20 = uitofp i64 %tmp19 to double
    %tmp21 = fsub double %tmp18, %tmp20
    store double %tmp21, double* %v5
    %tmp22 = load i64, i64* %v4
    %tmp23 = icmp eq i64 %tmp22, 0
    br i1 %tmp23, label %then3, label %else3
then3:
    call void @console.print_char(i8 48)
    br label %endif3
else3:
    %tmp24 = mul i64 1, 21
    %tmp25 = alloca i8, i64 %tmp24
    store i8* %tmp25, i8** %v6
    store i32 20, i32* %v7
    %tmp26 = load i64, i64* %v4
    store i64 %tmp26, i64* %v8
    br label %loop_body4
loop_body4:
    %tmp27 = load i8*, i8** %v6
    %tmp28 = load i32, i32* %v7
    %tmp29 = getelementptr inbounds i8, i8* %tmp27, i32 %tmp28
    %tmp30 = load i64, i64* %v8
    %tmp31 = urem i64 %tmp30, 10
    %tmp32 = trunc i64 %tmp31 to i8
    %tmp33 = add i8 %tmp32, 48
    store i8 %tmp33, i8* %tmp29
    %tmp34 = load i64, i64* %v8
    %tmp35 = udiv i64 %tmp34, 10
    store i64 %tmp35, i64* %v8
    %tmp36 = load i32, i32* %v7
    %tmp37 = sub i32 %tmp36, 1
    store i32 %tmp37, i32* %v7
    %tmp38 = load i64, i64* %v8
    %tmp39 = icmp eq i64 %tmp38, 0
    br i1 %tmp39, label %then5, label %endif5
then5:
    br label %loop_body4_exit
    br label %endif5
endif5:
    br label %loop_body4
loop_body4_exit:
    %tmp40 = load i8*, i8** %v6
    %tmp41 = load i32, i32* %v7
    %tmp42 = add i32 %tmp41, 1
    %tmp43 = getelementptr inbounds i8, i8* %tmp40, i32 %tmp42
    store i8* %tmp43, i8** %v9
    %tmp44 = trunc i64 20 to i32
    %tmp45 = load i32, i32* %v7
    %tmp46 = sub i32 %tmp44, %tmp45
    store i32 %tmp46, i32* %v10
    %tmp47 = load i8*, i8** %v9
    %tmp48 = load i32, i32* %v10
    call void @console.write(i8* %tmp47, i32 %tmp48)
    br label %endif3
endif3:
    call void @console.print_char(i8 46)
    store i32 0, i32* %v11
    br label %loop_body6
loop_body6:
    %tmp49 = load i32, i32* %v11
    %tmp50 = load i32, i32* %v0
    %tmp51 = icmp sge i32 %tmp49, %tmp50
    br i1 %tmp51, label %then7, label %endif7
then7:
    br label %loop_body6_exit
    br label %endif7
endif7:
    %tmp52 = load double, double* %v5
    %tmp54 = fmul double %tmp52, 0x4024000000000000
    store double %tmp54, double* %v5
    %tmp55 = load double, double* %v5
    %tmp56 = fptoui double %tmp55 to i64
    store i64 %tmp56, i64* %v12
    %tmp57 = load i64, i64* %v12
    %tmp58 = trunc i64 %tmp57 to i8
    %tmp59 = add i8 %tmp58, 48
    call void @console.print_char(i8 %tmp59)
    %tmp60 = load double, double* %v5
    %tmp61 = load i64, i64* %v12
    %tmp62 = uitofp i64 %tmp61 to double
    %tmp63 = fsub double %tmp60, %tmp62
    store double %tmp63, double* %v5
    %tmp64 = load i32, i32* %v11
    %tmp65 = add i32 %tmp64, 1
    store i32 %tmp65, i32* %v11
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
    %tmp5 = sext i32 %tmp4 to i64
    %tmp6 = mul i64 %tmp5, 1
    %tmp7 = call i8* @mem.malloc(i64 %tmp6)
    %tmp8 = bitcast i8* %tmp7 to i8*
    store i8* %tmp8, i8** %tmp2
    %tmp9 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
    %tmp10 = load i8*, i8** %tmp9
    %tmp11 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
    %tmp12 = load i32, i32* %tmp11
    %tmp13 = sext i32 %tmp12 to i64
    call void @mem.copy(i8* %c_string, i8* %tmp10, i64 %tmp13)
    %tmp14 = load %struct.string.String, %struct.string.String* %v0
    ret %struct.string.String %tmp14
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
    %tmp2 = sext i32 %size to i64
    %tmp3 = mul i64 %tmp2, 1
    %tmp4 = call i8* @mem.malloc(i64 %tmp3)
    %tmp5 = bitcast i8* %tmp4 to i8*
    store i8* %tmp5, i8** %tmp1
    %tmp6 = load %struct.string.String, %struct.string.String* %v0
    ret %struct.string.String %tmp6
}
define %struct.string.String @"string.concat_with_c_string"(%struct.string.String* %src_string, i8* %c_string){
    %v0 = alloca i32; var: c_string_len
    %v1 = alloca i8*; var: combined
    %v2 = alloca %struct.string.String; var: str
    %tmp0 = call i32 @string_utils.c_str_len(i8* %c_string)
    store i32 %tmp0, i32* %v0
    %tmp1 = load i32, i32* %v0
    %tmp2 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 1
    %tmp3 = load i32, i32* %tmp2
    %tmp4 = add i32 %tmp1, %tmp3
    %tmp5 = sext i32 %tmp4 to i64
    %tmp6 = mul i64 %tmp5, 1
    %tmp7 = call i8* @mem.malloc(i64 %tmp6)
    %tmp8 = bitcast i8* %tmp7 to i8*
    store i8* %tmp8, i8** %v1
    %tmp9 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 0
    %tmp10 = load i8*, i8** %tmp9
    %tmp11 = load i8*, i8** %v1
    %tmp12 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 1
    %tmp13 = load i32, i32* %tmp12
    %tmp14 = sext i32 %tmp13 to i64
    call void @mem.copy(i8* %tmp10, i8* %tmp11, i64 %tmp14)
    %tmp15 = load i8*, i8** %v1
    %tmp16 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 1
    %tmp17 = load i32, i32* %tmp16
    %tmp18 = sext i32 %tmp17 to i64
    %tmp19 = getelementptr i8, i8* %tmp15, i64 %tmp18
    %tmp20 = load i32, i32* %v0
    %tmp21 = sext i32 %tmp20 to i64
    call void @mem.copy(i8* %c_string, i8* %tmp19, i64 %tmp21)
    %tmp22 = getelementptr inbounds %struct.string.String, %struct.string.String* %v2, i32 0, i32 0
    %tmp23 = load i8*, i8** %v1
    store i8* %tmp23, i8** %tmp22
    %tmp24 = getelementptr inbounds %struct.string.String, %struct.string.String* %v2, i32 0, i32 1
    %tmp25 = load i32, i32* %v0
    %tmp26 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 1
    %tmp27 = load i32, i32* %tmp26
    %tmp28 = add i32 %tmp25, %tmp27
    store i32 %tmp28, i32* %tmp24
    %tmp29 = load %struct.string.String, %struct.string.String* %v2
    ret %struct.string.String %tmp29
}
define i1 @"string.equal"(%struct.string.String* %first, %struct.string.String* %second){
    %v0 = alloca i32; var: iter
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
    %tmp5 = getelementptr inbounds %struct.string.String, %struct.string.String* %first, i32 0, i32 1
    %tmp6 = load i32, i32* %tmp5
    %tmp7 = sub i32 %tmp6, 1
    store i32 %tmp7, i32* %v0
    br label %loop_body1
loop_body1:
    %tmp8 = load i32, i32* %v0
    %tmp9 = icmp slt i32 %tmp8, 0
    br i1 %tmp9, label %then2, label %endif2
then2:
    br label %loop_body1_exit
    br label %endif2
endif2:
    %tmp10 = getelementptr inbounds %struct.string.String, %struct.string.String* %first, i32 0, i32 0
    %tmp11 = load i8*, i8** %tmp10
    %tmp12 = load i32, i32* %v0
    %tmp13 = getelementptr inbounds i8, i8* %tmp11, i32 %tmp12
    %tmp14 = load i8, i8* %tmp13
    %tmp15 = getelementptr inbounds %struct.string.String, %struct.string.String* %second, i32 0, i32 0
    %tmp16 = load i8*, i8** %tmp15
    %tmp17 = load i32, i32* %v0
    %tmp18 = getelementptr inbounds i8, i8* %tmp16, i32 %tmp17
    %tmp19 = load i8, i8* %tmp18
    %tmp20 = icmp ne i8 %tmp14, %tmp19
    br i1 %tmp20, label %then3, label %endif3
then3:
    ret i1 0
    br label %endif3
endif3:
    %tmp21 = load i32, i32* %v0
    %tmp22 = sub i32 %tmp21, 1
    store i32 %tmp22, i32* %v0
    br label %loop_body1
loop_body1_exit:
    ret i1 1
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
    %v0 = alloca i32; var: len1
    %v1 = alloca i32; var: len2
    %v2 = alloca i8*; var: output
    %tmp0 = call i32 @string_utils.c_str_len(i8* %src1)
    store i32 %tmp0, i32* %v0
    %tmp1 = call i32 @string_utils.c_str_len(i8* %src2)
    store i32 %tmp1, i32* %v1
    %tmp2 = load i32, i32* %v0
    %tmp3 = load i32, i32* %v1
    %tmp4 = add i32 %tmp2, %tmp3
    %tmp5 = add i32 %tmp4, 1
    %tmp6 = sext i32 %tmp5 to i64
    %tmp7 = call i8* @mem.malloc(i64 %tmp6)
    %tmp8 = bitcast i8* %tmp7 to i8*
    store i8* %tmp8, i8** %v2
    %tmp9 = load i8*, i8** %v2
    %tmp10 = sext i32 %index to i64
    call void @mem.copy(i8* %src1, i8* %tmp9, i64 %tmp10)
    %tmp11 = load i8*, i8** %v2
    %tmp12 = getelementptr i8, i8* %tmp11, i32 %index
    %tmp13 = load i32, i32* %v1
    %tmp14 = sext i32 %tmp13 to i64
    call void @mem.copy(i8* %src2, i8* %tmp12, i64 %tmp14)
    %tmp15 = getelementptr i8, i8* %src1, i32 %index
    %tmp16 = load i8*, i8** %v2
    %tmp17 = getelementptr i8, i8* %tmp16, i32 %index
    %tmp18 = load i32, i32* %v1
    %tmp19 = getelementptr i8, i8* %tmp17, i32 %tmp18
    %tmp20 = load i32, i32* %v0
    %tmp21 = sub i32 %tmp20, %index
    %tmp22 = sext i32 %tmp21 to i64
    call void @mem.copy(i8* %tmp15, i8* %tmp19, i64 %tmp22)
    %tmp23 = load i8*, i8** %v2
    %tmp24 = load i32, i32* %v0
    %tmp25 = load i32, i32* %v1
    %tmp26 = add i32 %tmp24, %tmp25
    %tmp27 = getelementptr inbounds i8, i8* %tmp23, i32 %tmp26
    store i8 0, i8* %tmp27
    %tmp28 = load i8*, i8** %v2
    ret i8* %tmp28
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
    %v0 = alloca i32; var: CREATE_ALWAYS
    %v1 = alloca i32; var: GENERIC_WRITE
    %v2 = alloca i32; var: FILE_ATTRIBUTE_NORMAL
    %v3 = alloca i8*; var: hFile
    %v4 = alloca i8*; var: INVALID_HANDLE_VALUE
    %v5 = alloca i32; var: bytes_written
    %v6 = alloca i32; var: success
    store i32 2, i32* %v0
    store i32 1073741824, i32* %v1
    store i32 128, i32* %v2
    %tmp0 = load i32, i32* %v1
    %tmp1 = load i32, i32* %v0
    %tmp2 = load i32, i32* %v2
    %tmp3 = call i8* @CreateFileA(i8* %path, i32 %tmp0, i32 0, i8* null, i32 %tmp1, i32 %tmp2, i8* null)
    store i8* %tmp3, i8** %v3
    %tmp4 = inttoptr i64 -1 to i8*
    store i8* %tmp4, i8** %v4
    %tmp5 = load i8*, i8** %v3
    %tmp6 = load i8*, i8** %v4
    %tmp7 = icmp eq ptr %tmp5, %tmp6
    br i1 %tmp7, label %then0, label %endif0
then0:
    ret i32 0
    br label %endif0
endif0:
    store i32 0, i32* %v5
    %tmp8 = load i8*, i8** %v3
    %tmp9 = call i32 @WriteFile(i8* %tmp8, i8* %content, i32 %content_len, i32* %v5, i8* null)
    store i32 %tmp9, i32* %v6
    %tmp10 = load i8*, i8** %v3
    call i32 @CloseHandle(i8* %tmp10)
    %tmp11 = load i32, i32* %v6
    %tmp12 = icmp eq i32 %tmp11, 0
    br i1 %tmp12, label %then1, label %endif1
then1:
    ret i32 0
    br label %endif1
endif1:
    %tmp13 = load i32, i32* %v5
    %tmp14 = icmp ne i32 %tmp13, %content_len
    br i1 %tmp14, label %then2, label %endif2
then2:
    ret i32 0
    br label %endif2
endif2:
    ret i32 1
}
define %struct.string.String @"fs.read_full_file_as_string"(i8* %path){
    %v0 = alloca i32; var: GENERIC_READ
    %v1 = alloca i32; var: FILE_ATTRIBUTE_NORMAL
    %v2 = alloca i32; var: OPEN_EXISTING
    %v3 = alloca i8*; var: hFile
    %v4 = alloca i8*; var: INVALID_HANDLE_VALUE
    %v5 = alloca i64; var: file_size
    %v6 = alloca %struct.string.String; var: buffer
    %v7 = alloca i32; var: bytes_read
    %v8 = alloca i32; var: success
    store i32 2147483648, i32* %v0
    store i32 128, i32* %v1
    store i32 3, i32* %v2
    %tmp0 = load i32, i32* %v0
    %tmp1 = load i32, i32* %v2
    %tmp2 = load i32, i32* %v1
    %tmp3 = call i8* @CreateFileA(i8* %path, i32 %tmp0, i32 0, i8* null, i32 %tmp1, i32 %tmp2, i8* null)
    store i8* %tmp3, i8** %v3
    %tmp4 = inttoptr i64 -1 to i8*
    store i8* %tmp4, i8** %v4
    %tmp5 = load i8*, i8** %v3
    %tmp6 = load i8*, i8** %v4
    %tmp7 = icmp eq ptr %tmp5, %tmp6
    br i1 %tmp7, label %then0, label %endif0
then0:
    %tmp8 = getelementptr inbounds [20 x i8], [20 x i8]* @.str.4, i64 0, i64 0
    %tmp9 = call i8* @string_utils.insert(i8* %tmp8, i8* %path, i32 5)
    call void @process.throw(i8* %tmp9)
    br label %endif0
endif0:
    store i64 0, i64* %v5
    %tmp10 = load i8*, i8** %v3
    %tmp11 = call i32 @GetFileSizeEx(i8* %tmp10, i64* %v5)
    %tmp12 = icmp eq i32 %tmp11, 0
    br i1 %tmp12, label %then1, label %endif1
then1:
    %tmp13 = load i8*, i8** %v3
    call i32 @CloseHandle(i8* %tmp13)
    %tmp14 = call %struct.string.String @string.empty()
    ret %struct.string.String %tmp14
    br label %endif1
endif1:
    %tmp15 = load i64, i64* %v5
    %tmp16 = trunc i64 %tmp15 to i32
    %tmp17 = add i32 %tmp16, 1
    %tmp18 = call %struct.string.String @string.with_size(i32 %tmp17)
    store %struct.string.String %tmp18, %struct.string.String* %v6
    store i32 0, i32* %v7
    %tmp19 = load i8*, i8** %v3
    %tmp20 = getelementptr inbounds %struct.string.String, %struct.string.String* %v6, i32 0, i32 0
    %tmp21 = load i8*, i8** %tmp20
    %tmp22 = load i64, i64* %v5
    %tmp23 = trunc i64 %tmp22 to i32
    %tmp24 = call i32 @ReadFile(i8* %tmp19, i8* %tmp21, i32 %tmp23, i32* %v7, i8* null)
    store i32 %tmp24, i32* %v8
    %tmp25 = load i8*, i8** %v3
    call i32 @CloseHandle(i8* %tmp25)
    %tmp26 = load i32, i32* %v8
    %tmp27 = icmp eq i32 %tmp26, 0
    %tmp28 = load i32, i32* %v7
    %tmp29 = zext i32 %tmp28 to i64
    %tmp30 = load i64, i64* %v5
    %tmp31 = icmp ne i64 %tmp29, %tmp30
    %tmp32 = or i1 %tmp27, %tmp31
    br i1 %tmp32, label %then2, label %endif2
then2:
    call void @string.free(%struct.string.String* %v6)
    %tmp33 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.5, i64 0, i64 0
    call void @process.throw(i8* %tmp33)
    br label %endif2
endif2:
    %tmp34 = getelementptr inbounds %struct.string.String, %struct.string.String* %v6, i32 0, i32 1
    %tmp35 = load i64, i64* %v5
    %tmp36 = trunc i64 %tmp35 to i32
    store i32 %tmp36, i32* %tmp34
    %tmp37 = load %struct.string.String, %struct.string.String* %v6
    ret %struct.string.String %tmp37
}
define i32 @"fs.create_file"(i8* %path){
    %v0 = alloca i32; var: CREATE_NEW
    %v1 = alloca i32; var: GENERIC_WRITE
    %v2 = alloca i32; var: FILE_ATTRIBUTE_NORMAL
    %v3 = alloca i8*; var: hFile
    %v4 = alloca i8*; var: INVALID_HANDLE_VALUE
    store i32 1, i32* %v0
    store i32 1073741824, i32* %v1
    store i32 128, i32* %v2
    %tmp0 = load i32, i32* %v1
    %tmp1 = load i32, i32* %v0
    %tmp2 = load i32, i32* %v2
    %tmp3 = call i8* @CreateFileA(i8* %path, i32 %tmp0, i32 0, i8* null, i32 %tmp1, i32 %tmp2, i8* null)
    store i8* %tmp3, i8** %v3
    %tmp4 = inttoptr i64 -1 to i8*
    store i8* %tmp4, i8** %v4
    %tmp5 = load i8*, i8** %v3
    %tmp6 = load i8*, i8** %v4
    %tmp7 = icmp eq ptr %tmp5, %tmp6
    br i1 %tmp7, label %then0, label %endif0
then0:
    ret i32 0
    br label %endif0
endif0:
    %tmp8 = load i8*, i8** %v3
    call i32 @CloseHandle(i8* %tmp8)
    ret i32 1
}
define i32 @"fs.delete_file"(i8* %path){
    %tmp0 = call i32 @DeleteFileA(i8* %path)
    ret i32 %tmp0
}
define void @"tests.run"(){
    %v0 = alloca i64; var: pre_test_mem
    %v1 = alloca i64; var: post_test_mem
    %v2 = alloca i64; var: delta
    %tmp0 = call i64 @mem.get_total_allocated_memory_external()
    store i64 %tmp0, i64* %v0
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
    store i64 %tmp1, i64* %v1
    %tmp2 = load i64, i64* %v1
    %tmp3 = load i64, i64* %v0
    %tmp4 = sub i64 %tmp2, %tmp3
    store i64 %tmp4, i64* %v2
    %tmp5 = getelementptr inbounds [20 x i8], [20 x i8]* @.str.6, i64 0, i64 0
    call void @console.write(i8* %tmp5, i32 19)
    %tmp6 = load i64, i64* %v2
    call void @console.println_i64(i64 %tmp6)
    ret void
}
define void @"tests.mem_test"(){
    %v0 = alloca i64; var: size
    %v1 = alloca i8*; var: buffer1
    %v2 = alloca i64; var: i
    %v3 = alloca i64; var: i
    %v4 = alloca i8*; var: buffer2
    %tmp0 = getelementptr inbounds [11 x i8], [11 x i8]* @.str.7, i64 0, i64 0
    call void @console.write(i8* %tmp0, i32 10)
    store i64 16, i64* %v0
    %tmp1 = load i64, i64* %v0
    %tmp2 = call i8* @mem.malloc(i64 %tmp1)
    %tmp3 = bitcast i8* %tmp2 to i8*
    store i8* %tmp3, i8** %v1
    %tmp4 = load i8*, i8** %v1
    %tmp5 = icmp eq ptr %tmp4, null
    br i1 %tmp5, label %then0, label %endif0
then0:
    %tmp6 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.8, i64 0, i64 0
    call void @process.throw(i8* %tmp6)
    br label %endif0
endif0:
    %tmp7 = load i8*, i8** %v1
    %tmp8 = load i64, i64* %v0
    call void @mem.fill(i8 88, i8* %tmp7, i64 %tmp8)
    store i64 0, i64* %v2
    br label %loop_body1
loop_body1:
    %tmp9 = load i64, i64* %v2
    %tmp10 = load i64, i64* %v0
    %tmp11 = icmp sge i64 %tmp9, %tmp10
    br i1 %tmp11, label %then2, label %endif2
then2:
    br label %loop_body1_exit
    br label %endif2
endif2:
    %tmp12 = load i8*, i8** %v1
    %tmp13 = load i64, i64* %v2
    %tmp14 = getelementptr inbounds i8, i8* %tmp12, i64 %tmp13
    %tmp15 = load i8, i8* %tmp14
    %tmp16 = icmp ne i8 %tmp15, 88
    br i1 %tmp16, label %then3, label %endif3
then3:
    %tmp17 = getelementptr inbounds [35 x i8], [35 x i8]* @.str.9, i64 0, i64 0
    call void @process.throw(i8* %tmp17)
    br label %endif3
endif3:
    %tmp18 = load i64, i64* %v2
    %tmp19 = add i64 %tmp18, 1
    store i64 %tmp19, i64* %v2
    br label %loop_body1
loop_body1_exit:
    %tmp20 = load i8*, i8** %v1
    %tmp21 = load i64, i64* %v0
    call void @mem.zero_fill(i8* %tmp20, i64 %tmp21)
    store i64 0, i64* %v3
    br label %loop_body4
loop_body4:
    %tmp22 = load i64, i64* %v3
    %tmp23 = load i64, i64* %v0
    %tmp24 = icmp sge i64 %tmp22, %tmp23
    br i1 %tmp24, label %then5, label %endif5
then5:
    br label %loop_body4_exit
    br label %endif5
endif5:
    %tmp25 = load i8*, i8** %v1
    %tmp26 = load i64, i64* %v3
    %tmp27 = getelementptr inbounds i8, i8* %tmp25, i64 %tmp26
    %tmp28 = load i8, i8* %tmp27
    %tmp29 = icmp ne i8 %tmp28, 0
    br i1 %tmp29, label %then6, label %endif6
then6:
    %tmp30 = getelementptr inbounds [40 x i8], [40 x i8]* @.str.10, i64 0, i64 0
    call void @process.throw(i8* %tmp30)
    br label %endif6
endif6:
    %tmp31 = load i64, i64* %v3
    %tmp32 = add i64 %tmp31, 1
    store i64 %tmp32, i64* %v3
    br label %loop_body4
loop_body4_exit:
    %tmp33 = load i64, i64* %v0
    %tmp34 = call i8* @mem.malloc(i64 %tmp33)
    %tmp35 = bitcast i8* %tmp34 to i8*
    store i8* %tmp35, i8** %v4
    %tmp36 = load i8*, i8** %v4
    %tmp37 = icmp eq ptr %tmp36, null
    br i1 %tmp37, label %then7, label %endif7
then7:
    %tmp38 = getelementptr inbounds [33 x i8], [33 x i8]* @.str.11, i64 0, i64 0
    call void @process.throw(i8* %tmp38)
    br label %endif7
endif7:
    %tmp39 = load i8*, i8** %v4
    %tmp40 = load i64, i64* %v0
    call void @mem.fill(i8 89, i8* %tmp39, i64 %tmp40)
    %tmp41 = load i8*, i8** %v4
    %tmp42 = load i8*, i8** %v1
    %tmp43 = load i64, i64* %v0
    call void @mem.copy(i8* %tmp41, i8* %tmp42, i64 %tmp43)
    store i64 0, i64* %v3
    br label %loop_body8
loop_body8:
    %tmp44 = load i64, i64* %v3
    %tmp45 = load i64, i64* %v0
    %tmp46 = icmp sge i64 %tmp44, %tmp45
    br i1 %tmp46, label %then9, label %endif9
then9:
    br label %loop_body8_exit
    br label %endif9
endif9:
    %tmp47 = load i8*, i8** %v1
    %tmp48 = load i64, i64* %v3
    %tmp49 = getelementptr inbounds i8, i8* %tmp47, i64 %tmp48
    %tmp50 = load i8, i8* %tmp49
    %tmp51 = icmp ne i8 %tmp50, 89
    br i1 %tmp51, label %then10, label %endif10
then10:
    %tmp52 = getelementptr inbounds [35 x i8], [35 x i8]* @.str.12, i64 0, i64 0
    call void @process.throw(i8* %tmp52)
    br label %endif10
endif10:
    %tmp53 = load i64, i64* %v3
    %tmp54 = add i64 %tmp53, 1
    store i64 %tmp54, i64* %v3
    br label %loop_body8
loop_body8_exit:
    %tmp55 = load i8*, i8** %v1
    %tmp56 = bitcast i8* %tmp55 to i8*
    call void @mem.free(i8* %tmp56)
    %tmp57 = load i8*, i8** %v4
    %tmp58 = bitcast i8* %tmp57 to i8*
    call void @mem.free(i8* %tmp58)
    %tmp59 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.13, i64 0, i64 0
    call void @console.writeln(i8* %tmp59, i32 2)
    ret void
}
define void @"tests.string_utils_test"(){
    %v0 = alloca i8*; var: inserted
    %v1 = alloca i8*; var: expected
    %v2 = alloca i32; var: i
    %tmp0 = getelementptr inbounds [20 x i8], [20 x i8]* @.str.14, i64 0, i64 0
    call void @console.write(i8* %tmp0, i32 19)
    %tmp1 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.15, i64 0, i64 0
    %tmp2 = call i32 @string_utils.c_str_len(i8* %tmp1)
    %tmp3 = icmp ne i32 %tmp2, 4
    br i1 %tmp3, label %then0, label %endif0
then0:
    %tmp4 = getelementptr inbounds [36 x i8], [36 x i8]* @.str.16, i64 0, i64 0
    call void @process.throw(i8* %tmp4)
    br label %endif0
endif0:
    %tmp5 = getelementptr inbounds [1 x i8], [1 x i8]* @.str.17, i64 0, i64 0
    %tmp6 = call i32 @string_utils.c_str_len(i8* %tmp5)
    %tmp7 = icmp ne i32 %tmp6, 0
    br i1 %tmp7, label %then1, label %endif1
then1:
    %tmp8 = getelementptr inbounds [42 x i8], [42 x i8]* @.str.18, i64 0, i64 0
    call void @process.throw(i8* %tmp8)
    br label %endif1
endif1:
    %tmp9 = call i1 @string_utils.is_ascii_num(i8 55)
    %tmp10 = xor i1 %tmp9, 1
    %tmp11 = call i1 @string_utils.is_ascii_num(i8 98)
    %tmp12 = or i1 %tmp10, %tmp11
    br i1 %tmp12, label %then2, label %endif2
then2:
    %tmp13 = getelementptr inbounds [39 x i8], [39 x i8]* @.str.19, i64 0, i64 0
    call void @process.throw(i8* %tmp13)
    br label %endif2
endif2:
    %tmp14 = call i1 @string_utils.is_ascii_char(i8 97)
    %tmp15 = xor i1 %tmp14, 1
    %tmp16 = call i1 @string_utils.is_ascii_char(i8 57)
    %tmp17 = or i1 %tmp15, %tmp16
    br i1 %tmp17, label %then3, label %endif3
then3:
    %tmp18 = getelementptr inbounds [40 x i8], [40 x i8]* @.str.20, i64 0, i64 0
    call void @process.throw(i8* %tmp18)
    br label %endif3
endif3:
    %tmp19 = call i1 @string_utils.is_ascii_hex(i8 70)
    %tmp20 = xor i1 %tmp19, 1
    %tmp21 = call i1 @string_utils.is_ascii_hex(i8 71)
    %tmp22 = or i1 %tmp20, %tmp21
    br i1 %tmp22, label %then4, label %endif4
then4:
    %tmp23 = getelementptr inbounds [39 x i8], [39 x i8]* @.str.21, i64 0, i64 0
    call void @process.throw(i8* %tmp23)
    br label %endif4
endif4:
    %tmp24 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.22, i64 0, i64 0
    %tmp25 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.23, i64 0, i64 0
    %tmp26 = call i8* @string_utils.insert(i8* %tmp24, i8* %tmp25, i32 1)
    store i8* %tmp26, i8** %v0
    %tmp27 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.24, i64 0, i64 0
    store i8* %tmp27, i8** %v1
    store i32 0, i32* %v2
    br label %loop_body5
loop_body5:
    %tmp28 = load i8*, i8** %v0
    %tmp29 = load i32, i32* %v2
    %tmp30 = getelementptr inbounds i8, i8* %tmp28, i32 %tmp29
    %tmp31 = load i8, i8* %tmp30
    %tmp32 = icmp eq i8 %tmp31, 0
    %tmp33 = load i8*, i8** %v1
    %tmp34 = load i32, i32* %v2
    %tmp35 = getelementptr inbounds i8, i8* %tmp33, i32 %tmp34
    %tmp36 = load i8, i8* %tmp35
    %tmp37 = icmp eq i8 %tmp36, 0
    %tmp38 = and i1 %tmp32, %tmp37
    br i1 %tmp38, label %then6, label %endif6
then6:
    br label %loop_body5_exit
    br label %endif6
endif6:
    %tmp39 = load i8*, i8** %v0
    %tmp40 = load i32, i32* %v2
    %tmp41 = getelementptr inbounds i8, i8* %tmp39, i32 %tmp40
    %tmp42 = load i8, i8* %tmp41
    %tmp43 = load i8*, i8** %v1
    %tmp44 = load i32, i32* %v2
    %tmp45 = getelementptr inbounds i8, i8* %tmp43, i32 %tmp44
    %tmp46 = load i8, i8* %tmp45
    %tmp47 = icmp ne i8 %tmp42, %tmp46
    br i1 %tmp47, label %then7, label %endif7
then7:
    %tmp48 = getelementptr inbounds [33 x i8], [33 x i8]* @.str.25, i64 0, i64 0
    call void @process.throw(i8* %tmp48)
    br label %endif7
endif7:
    %tmp49 = load i32, i32* %v2
    %tmp50 = add i32 %tmp49, 1
    store i32 %tmp50, i32* %v2
    br label %loop_body5
loop_body5_exit:
    %tmp51 = load i8*, i8** %v0
    %tmp52 = bitcast i8* %tmp51 to i8*
    call void @mem.free(i8* %tmp52)
    %tmp53 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.13, i64 0, i64 0
    call void @console.writeln(i8* %tmp53, i32 2)
    ret void
}
define void @"tests.string_test"(){
    %v0 = alloca %struct.string.String; var: s1
    %v1 = alloca %struct.string.String; var: s2
    %v2 = alloca %struct.string.String; var: s3
    %v3 = alloca %struct.string.String; var: s4
    %v4 = alloca %struct.string.String; var: s5
    %tmp0 = getelementptr inbounds [14 x i8], [14 x i8]* @.str.26, i64 0, i64 0
    call void @console.write(i8* %tmp0, i32 13)
    %tmp1 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.27, i64 0, i64 0
    %tmp2 = call %struct.string.String @string.from_c_string(i8* %tmp1)
    store %struct.string.String %tmp2, %struct.string.String* %v0
    %tmp3 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.27, i64 0, i64 0
    %tmp4 = call %struct.string.String @string.from_c_string(i8* %tmp3)
    store %struct.string.String %tmp4, %struct.string.String* %v1
    %tmp5 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.28, i64 0, i64 0
    %tmp6 = call %struct.string.String @string.from_c_string(i8* %tmp5)
    store %struct.string.String %tmp6, %struct.string.String* %v2
    %tmp7 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
    %tmp8 = load i32, i32* %tmp7
    %tmp9 = icmp ne i32 %tmp8, 5
    br i1 %tmp9, label %then0, label %endif0
then0:
    %tmp10 = getelementptr inbounds [41 x i8], [41 x i8]* @.str.29, i64 0, i64 0
    call void @process.throw(i8* %tmp10)
    br label %endif0
endif0:
    %tmp11 = call i1 @string.equal(%struct.string.String* %v0, %struct.string.String* %v1)
    %tmp12 = xor i1 %tmp11, 1
    br i1 %tmp12, label %then1, label %endif1
then1:
    %tmp13 = getelementptr inbounds [40 x i8], [40 x i8]* @.str.30, i64 0, i64 0
    call void @process.throw(i8* %tmp13)
    br label %endif1
endif1:
    %tmp14 = call i1 @string.equal(%struct.string.String* %v0, %struct.string.String* %v2)
    br i1 %tmp14, label %then2, label %endif2
then2:
    %tmp15 = getelementptr inbounds [40 x i8], [40 x i8]* @.str.31, i64 0, i64 0
    call void @process.throw(i8* %tmp15)
    br label %endif2
endif2:
    %tmp16 = getelementptr inbounds [7 x i8], [7 x i8]* @.str.32, i64 0, i64 0
    %tmp17 = call %struct.string.String @string.concat_with_c_string(%struct.string.String* %v0, i8* %tmp16)
    store %struct.string.String %tmp17, %struct.string.String* %v3
    %tmp18 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.33, i64 0, i64 0
    %tmp19 = call %struct.string.String @string.from_c_string(i8* %tmp18)
    store %struct.string.String %tmp19, %struct.string.String* %v4
    %tmp20 = getelementptr inbounds %struct.string.String, %struct.string.String* %v3, i32 0, i32 1
    %tmp21 = load i32, i32* %tmp20
    %tmp22 = icmp ne i32 %tmp21, 11
    br i1 %tmp22, label %then3, label %endif3
then3:
    %tmp23 = getelementptr inbounds [34 x i8], [34 x i8]* @.str.34, i64 0, i64 0
    call void @process.throw(i8* %tmp23)
    br label %endif3
endif3:
    %tmp24 = call i1 @string.equal(%struct.string.String* %v3, %struct.string.String* %v4)
    %tmp25 = xor i1 %tmp24, 1
    br i1 %tmp25, label %then4, label %endif4
then4:
    %tmp26 = getelementptr inbounds [35 x i8], [35 x i8]* @.str.35, i64 0, i64 0
    call void @process.throw(i8* %tmp26)
    br label %endif4
endif4:
    call void @string.free(%struct.string.String* %v0)
    call void @string.free(%struct.string.String* %v1)
    call void @string.free(%struct.string.String* %v2)
    call void @string.free(%struct.string.String* %v3)
    call void @string.free(%struct.string.String* %v4)
    %tmp27 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.13, i64 0, i64 0
    call void @console.writeln(i8* %tmp27, i32 2)
    ret void
}
define void @"tests.vector_test"(){
    %v0 = alloca %"struct.vector.Vec<i8>"; var: v
    %v1 = alloca i8*; var: data_to_push
    %tmp0 = getelementptr inbounds [14 x i8], [14 x i8]* @.str.36, i64 0, i64 0
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
    %tmp9 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.37, i64 0, i64 0
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
    %tmp17 = getelementptr inbounds [33 x i8], [33 x i8]* @.str.38, i64 0, i64 0
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
    %tmp29 = getelementptr inbounds [36 x i8], [36 x i8]* @.str.39, i64 0, i64 0
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
    %tmp37 = getelementptr inbounds [28 x i8], [28 x i8]* @.str.40, i64 0, i64 0
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
    %tmp49 = getelementptr inbounds [36 x i8], [36 x i8]* @.str.41, i64 0, i64 0
    call void @process.throw(i8* %tmp49)
    br label %endif4
endif4:
    %tmp50 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.42, i64 0, i64 0
    store i8* %tmp50, i8** %v1
    %tmp51 = load i8*, i8** %v1
    call void @"vector.push_bulk<i8>"(%"struct.vector.Vec<i8>"* %v0, i8* %tmp51, i32 2)
    %tmp52 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 1
    %tmp53 = load i32, i32* %tmp52
    %tmp54 = icmp ne i32 %tmp53, 7
    br i1 %tmp54, label %then5, label %endif5
then5:
    %tmp55 = getelementptr inbounds [37 x i8], [37 x i8]* @.str.43, i64 0, i64 0
    call void @process.throw(i8* %tmp55)
    br label %endif5
endif5:
    %tmp56 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 0
    %tmp57 = load i8*, i8** %tmp56
    %tmp58 = getelementptr inbounds i8, i8* %tmp57, i64 5
    %tmp59 = load i8, i8* %tmp58
    %tmp60 = icmp ne i8 %tmp59, 65
    %tmp61 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 0
    %tmp62 = load i8*, i8** %tmp61
    %tmp63 = getelementptr inbounds i8, i8* %tmp62, i64 6
    %tmp64 = load i8, i8* %tmp63
    %tmp65 = icmp ne i8 %tmp64, 66
    %tmp66 = or i1 %tmp60, %tmp65
    br i1 %tmp66, label %then6, label %endif6
then6:
    %tmp67 = getelementptr inbounds [38 x i8], [38 x i8]* @.str.44, i64 0, i64 0
    call void @process.throw(i8* %tmp67)
    br label %endif6
endif6:
    call void @"vector.free<i8>"(%"struct.vector.Vec<i8>"* %v0)
    %tmp68 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 1
    %tmp69 = load i32, i32* %tmp68
    %tmp70 = icmp ne i32 %tmp69, 0
    %tmp71 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 2
    %tmp72 = load i32, i32* %tmp71
    %tmp73 = icmp ne i32 %tmp72, 0
    %tmp74 = or i1 %tmp70, %tmp73
    %tmp75 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 0
    %tmp76 = load i8*, i8** %tmp75
    %tmp77 = icmp ne ptr %tmp76, null
    %tmp78 = or i1 %tmp74, %tmp77
    br i1 %tmp78, label %then7, label %endif7
then7:
    %tmp79 = getelementptr inbounds [25 x i8], [25 x i8]* @.str.45, i64 0, i64 0
    call void @process.throw(i8* %tmp79)
    br label %endif7
endif7:
    %tmp80 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.13, i64 0, i64 0
    call void @console.writeln(i8* %tmp80, i32 2)
    ret void
}
define void @"tests.list_test"(){
    %v0 = alloca %"struct.list.List<i32>"; var: l
    %v1 = alloca %"struct.list.ListNode<i32>"*; var: current
    %tmp0 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.46, i64 0, i64 0
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
    %tmp9 = getelementptr inbounds [22 x i8], [22 x i8]* @.str.47, i64 0, i64 0
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
    %tmp13 = getelementptr inbounds [41 x i8], [41 x i8]* @.str.48, i64 0, i64 0
    call void @process.throw(i8* %tmp13)
    br label %endif1
endif1:
    %tmp14 = call i32 @"list.walk<i32>"(%"struct.list.List<i32>"* %v0)
    %tmp15 = icmp ne i32 %tmp14, 3
    br i1 %tmp15, label %then2, label %endif2
then2:
    %tmp16 = getelementptr inbounds [33 x i8], [33 x i8]* @.str.49, i64 0, i64 0
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
    %tmp23 = getelementptr inbounds [36 x i8], [36 x i8]* @.str.50, i64 0, i64 0
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
    %tmp31 = getelementptr inbounds [36 x i8], [36 x i8]* @.str.51, i64 0, i64 0
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
    %tmp39 = getelementptr inbounds [36 x i8], [36 x i8]* @.str.52, i64 0, i64 0
    call void @process.throw(i8* %tmp39)
    br label %endif5
endif5:
    %tmp40 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v1
    %tmp41 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %v0, i32 0, i32 1
    %tmp42 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %tmp41
    %tmp43 = icmp ne ptr %tmp40, %tmp42
    br i1 %tmp43, label %then6, label %endif6
then6:
    %tmp44 = getelementptr inbounds [33 x i8], [33 x i8]* @.str.53, i64 0, i64 0
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
    %tmp52 = getelementptr inbounds [23 x i8], [23 x i8]* @.str.54, i64 0, i64 0
    call void @process.throw(i8* %tmp52)
    br label %endif7
endif7:
    %tmp53 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.13, i64 0, i64 0
    call void @console.writeln(i8* %tmp53, i32 2)
    ret void
}
define void @"tests.process_test"(){
    %v0 = alloca %struct.string.String; var: full_path
    %v1 = alloca %struct.string.String; var: env_path
    %tmp0 = getelementptr inbounds [15 x i8], [15 x i8]* @.str.55, i64 0, i64 0
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
    %tmp6 = getelementptr inbounds [49 x i8], [49 x i8]* @.str.56, i64 0, i64 0
    call void @process.throw(i8* %tmp6)
    br label %endif0
endif0:
    %tmp7 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 1
    %tmp8 = load i32, i32* %tmp7
    %tmp9 = icmp sle i32 %tmp8, 0
    br i1 %tmp9, label %then1, label %endif1
then1:
    %tmp10 = getelementptr inbounds [53 x i8], [53 x i8]* @.str.57, i64 0, i64 0
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
    %tmp16 = getelementptr inbounds [53 x i8], [53 x i8]* @.str.58, i64 0, i64 0
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
    %tmp25 = getelementptr inbounds [53 x i8], [53 x i8]* @.str.59, i64 0, i64 0
    call void @process.throw(i8* %tmp25)
    br label %endif3
endif3:
    %tmp26 = getelementptr inbounds [18 x i8], [18 x i8]* @.str.60, i64 0, i64 0
    call void @console.write(i8* %tmp26, i32 17)
    %tmp27 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
    %tmp28 = load i8*, i8** %tmp27
    %tmp29 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
    %tmp30 = load i32, i32* %tmp29
    call void @console.writeln(i8* %tmp28, i32 %tmp30)
    %tmp31 = getelementptr inbounds [19 x i8], [19 x i8]* @.str.61, i64 0, i64 0
    call void @console.write(i8* %tmp31, i32 18)
    %tmp32 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 0
    %tmp33 = load i8*, i8** %tmp32
    %tmp34 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 1
    %tmp35 = load i32, i32* %tmp34
    call void @console.writeln(i8* %tmp33, i32 %tmp35)
    call void @string.free(%struct.string.String* %v0)
    call void @string.free(%struct.string.String* %v1)
    %tmp36 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.13, i64 0, i64 0
    call void @console.writeln(i8* %tmp36, i32 2)
    ret void
}
define void @"tests.console_test"(){
    %tmp0 = getelementptr inbounds [15 x i8], [15 x i8]* @.str.62, i64 0, i64 0
    call void @console.writeln(i8* %tmp0, i32 14)
    %tmp1 = getelementptr inbounds [26 x i8], [26 x i8]* @.str.63, i64 0, i64 0
    call void @console.writeln(i8* %tmp1, i32 25)
    %tmp2 = getelementptr inbounds [22 x i8], [22 x i8]* @.str.64, i64 0, i64 0
    call void @console.write(i8* %tmp2, i32 21)
    call void @console.println_i64(i64 12345)
    %tmp3 = getelementptr inbounds [23 x i8], [23 x i8]* @.str.65, i64 0, i64 0
    call void @console.write(i8* %tmp3, i32 22)
    call void @console.println_i64(i64 -67890)
    %tmp4 = getelementptr inbounds [18 x i8], [18 x i8]* @.str.66, i64 0, i64 0
    call void @console.write(i8* %tmp4, i32 17)
    call void @console.println_i64(i64 0)
    %tmp5 = getelementptr inbounds [27 x i8], [27 x i8]* @.str.67, i64 0, i64 0
    call void @console.write(i8* %tmp5, i32 26)
    call void @console.println_u64(i64 9876543210)
    %tmp6 = getelementptr inbounds [24 x i8], [24 x i8]* @.str.68, i64 0, i64 0
    call void @console.writeln(i8* %tmp6, i32 23)
    %tmp7 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.13, i64 0, i64 0
    call void @console.writeln(i8* %tmp7, i32 2)
    ret void
}
define void @"tests.fs_test"(){
    %v0 = alloca %struct.string.String; var: data
    %v1 = alloca %struct.string.String; var: env_path
    %v2 = alloca %struct.string.String; var: new_file_path
    %v3 = alloca i8*; var: c_string
    %v4 = alloca %struct.string.String; var: read
    %tmp0 = getelementptr inbounds [10 x i8], [10 x i8]* @.str.69, i64 0, i64 0
    call void @console.write(i8* %tmp0, i32 9)
    %tmp1 = getelementptr inbounds [47 x i8], [47 x i8]* @.str.70, i64 0, i64 0
    %tmp2 = call %struct.string.String @string.from_c_string(i8* %tmp1)
    store %struct.string.String %tmp2, %struct.string.String* %v0
    %tmp3 = call %struct.string.String @process.get_executable_env_path()
    store %struct.string.String %tmp3, %struct.string.String* %v1
    %tmp4 = getelementptr inbounds [9 x i8], [9 x i8]* @.str.71, i64 0, i64 0
    %tmp5 = call %struct.string.String @string.concat_with_c_string(%struct.string.String* %v1, i8* %tmp4)
    store %struct.string.String %tmp5, %struct.string.String* %v2
    %tmp6 = getelementptr inbounds %struct.string.String, %struct.string.String* %v2, i32 0, i32 1
    %tmp7 = load i32, i32* %tmp6
    %tmp8 = add i32 %tmp7, 1
    %tmp9 = sext i32 %tmp8 to i64
    %tmp10 = mul i64 %tmp9, 1
    %tmp11 = alloca i8, i64 %tmp10
    store i8* %tmp11, i8** %v3
    %tmp13 = bitcast %struct.string.String** %v2 to %struct.string.String**
    %tmp14 = load i8*, i8** %v3
    %tmp15 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp13, i32 0, i32 0
    %tmp16 = load i8*, i8** %tmp15
    %tmp17 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp13, i32 0, i32 1
    %tmp18 = load i32, i32* %tmp17
    %tmp19 = sext i32 %tmp18 to i64
    call void @mem.copy(i8* %tmp16, i8* %tmp14, i64 %tmp19)
    %tmp20 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp13, i32 0, i32 1
    %tmp21 = load i32, i32* %tmp20
    %tmp22 = getelementptr inbounds i8, i8* %tmp14, i32 %tmp21
    store i8 0, i8* %tmp22
    br label %inline_exit0
inline_exit0:
    %tmp23 = load i8*, i8** %v3
    call i32 @fs.create_file(i8* %tmp23)
    %tmp24 = load i8*, i8** %v3
    call i32 @fs.delete_file(i8* %tmp24)
    %tmp25 = load i8*, i8** %v3
    call i32 @fs.create_file(i8* %tmp25)
    %tmp26 = load i8*, i8** %v3
    %tmp27 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
    %tmp28 = load i8*, i8** %tmp27
    %tmp29 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
    %tmp30 = load i32, i32* %tmp29
    call i32 @fs.write_to_file(i8* %tmp26, i8* %tmp28, i32 %tmp30)
    %tmp32 = load i8*, i8** %v3
    %tmp33 = call %struct.string.String @fs.read_full_file_as_string(i8* %tmp32)
    store %struct.string.String %tmp33, %struct.string.String* %v4
    %tmp34 = call i1 @string.equal(%struct.string.String* %v0, %struct.string.String* %v4)
    %tmp35 = xor i1 %tmp34, 1
    br i1 %tmp35, label %then1, label %endif1
then1:
    %tmp36 = getelementptr inbounds [38 x i8], [38 x i8]* @.str.72, i64 0, i64 0
    call void @process.throw(i8* %tmp36)
    br label %endif1
endif1:
    %tmp37 = load i8*, i8** %v3
    call i32 @fs.delete_file(i8* %tmp37)
    call void @string.free(%struct.string.String* %v4)
    call void @string.free(%struct.string.String* %v2)
    call void @string.free(%struct.string.String* %v1)
    call void @string.free(%struct.string.String* %v0)
    %tmp38 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.13, i64 0, i64 0
    call void @console.writeln(i8* %tmp38, i32 2)
    ret void
}
define void @"tests.consume_while"(%struct.string.String* %file, i32* %iterator, i1 (i8)** %condition){
    %v0 = alloca i8; var: char
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
    store i8 %tmp8, i8* %v0
    %tmp9 = load i8, i8* %v0
    %tmp10 = call i1 %condition(i8 %tmp9)
    br i1 %tmp10, label %then2, label %else2
then2:
    %tmp11 = load i32, i32* %iterator
    %tmp12 = add i32 %tmp11, 1
    store i32 %tmp12, i32* %iterator
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
    %v7 = alloca %struct.string.String; var: temp_string
    %v8 = alloca %struct.string.String; var: temp_string
    %v9 = alloca %struct.string.String; var: temp_string
    %v10 = alloca i32; var: i
    %tmp0 = getelementptr inbounds [45 x i8], [45 x i8]* @.str.73, i64 0, i64 0
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
    br label %loop_body1
loop_body1:
    %tmp8 = load i32, i32* %v2
    %tmp9 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 1
    %tmp10 = load i32, i32* %tmp9
    %tmp11 = icmp sge i32 %tmp8, %tmp10
    br i1 %tmp11, label %then2, label %endif2
then2:
    br label %loop_body1_exit
    br label %endif2
endif2:
    %tmp12 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 0
    %tmp13 = load i8*, i8** %tmp12
    %tmp14 = load i32, i32* %v2
    %tmp15 = getelementptr inbounds i8, i8* %tmp13, i32 %tmp14
    %tmp16 = load i8, i8* %tmp15
    store i8 %tmp16, i8* %v3
    %tmp17 = load i8, i8* %v3
    %tmp18 = icmp eq i8 %tmp17, 32
    %tmp19 = load i8, i8* %v3
    %tmp20 = icmp eq i8 %tmp19, 9
    %tmp21 = or i1 %tmp18, %tmp20
    %tmp22 = load i8, i8* %v3
    %tmp23 = icmp eq i8 %tmp22, 13
    %tmp24 = or i1 %tmp21, %tmp23
    %tmp25 = load i8, i8* %v3
    %tmp26 = icmp eq i8 %tmp25, 10
    %tmp27 = or i1 %tmp24, %tmp26
    br i1 %tmp27, label %then3, label %endif3
then3:
    %tmp28 = load i32, i32* %v2
    %tmp29 = add i32 %tmp28, 1
    store i32 %tmp29, i32* %v2
    br label %loop_body1
    br label %endif3
endif3:
    %tmp30 = load i32, i32* %v2
    %tmp31 = add i32 %tmp30, 1
    %tmp32 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 1
    %tmp33 = load i32, i32* %tmp32
    %tmp34 = icmp slt i32 %tmp31, %tmp33
    br i1 %tmp34, label %then4, label %else4
then4:
    %tmp35 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 0
    %tmp36 = load i8*, i8** %tmp35
    %tmp37 = load i32, i32* %v2
    %tmp38 = add i32 %tmp37, 1
    %tmp39 = getelementptr inbounds i8, i8* %tmp36, i32 %tmp38
    %tmp40 = load i8, i8* %tmp39
    store i8 %tmp40, i8* %v4
    br label %endif4
else4:
    store i8 0, i8* %v4
    br label %endif4
endif4:
    %tmp41 = load i8, i8* %v3
    %tmp42 = icmp eq i8 %tmp41, 47
    %tmp43 = load i8, i8* %v4
    %tmp44 = icmp eq i8 %tmp43, 47
    %tmp45 = and i1 %tmp42, %tmp44
    br i1 %tmp45, label %then5, label %endif5
then5:
    call void @tests.consume_while(%struct.string.String* %v1, i32* %v2, i1 (i8)** @tests.not_new_line)
    br label %loop_body1
    br label %endif5
endif5:
    %tmp46 = load i8, i8* %v3
    %tmp47 = call i1 @string_utils.is_ascii_num(i8 %tmp46)
    br i1 %tmp47, label %then6, label %endif6
then6:
    %tmp48 = load i32, i32* %v2
    store i32 %tmp48, i32* %v5
    %tmp49 = load i8, i8* %v4
    %tmp50 = icmp eq i8 %tmp49, 120
    %tmp51 = load i8, i8* %v4
    %tmp52 = icmp eq i8 %tmp51, 98
    %tmp53 = or i1 %tmp50, %tmp52
    br i1 %tmp53, label %then7, label %endif7
then7:
    %tmp54 = load i32, i32* %v2
    %tmp55 = add i32 %tmp54, 2
    store i32 %tmp55, i32* %v2
    br label %endif7
endif7:
    call void @tests.consume_while(%struct.string.String* %v1, i32* %v2, i1 (i8)** @tests.is_valid_number_token)
    %tmp56 = load i32, i32* %v2
    %tmp57 = load i32, i32* %v5
    %tmp58 = sub i32 %tmp56, %tmp57
    %tmp59 = call %struct.string.String @string.with_size(i32 %tmp58)
    store %struct.string.String %tmp59, %struct.string.String* %v7
    %tmp60 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 0
    %tmp61 = load i8*, i8** %tmp60
    %tmp62 = load i32, i32* %v5
    %tmp63 = getelementptr i8, i8* %tmp61, i32 %tmp62
    %tmp64 = getelementptr inbounds %struct.string.String, %struct.string.String* %v7, i32 0, i32 0
    %tmp65 = load i8*, i8** %tmp64
    %tmp66 = getelementptr inbounds %struct.string.String, %struct.string.String* %v7, i32 0, i32 1
    %tmp67 = load i32, i32* %tmp66
    %tmp68 = sext i32 %tmp67 to i64
    call void @mem.copy(i8* %tmp63, i8* %tmp65, i64 %tmp68)
    %tmp69 = load %struct.string.String, %struct.string.String* %v7
    call void @"vector.push<%struct.string.String>"(%"struct.vector.Vec<%struct.string.String>"* %v6, %struct.string.String %tmp69)
    br label %loop_body1
    br label %endif6
endif6:
    %tmp70 = load i8, i8* %v3
    %tmp71 = call i1 @string_utils.is_ascii_char(i8 %tmp70)
    %tmp72 = load i8, i8* %v3
    %tmp73 = icmp eq i8 %tmp72, 95
    %tmp74 = or i1 %tmp71, %tmp73
    br i1 %tmp74, label %then8, label %endif8
then8:
    %tmp75 = load i32, i32* %v2
    store i32 %tmp75, i32* %v5
    call void @tests.consume_while(%struct.string.String* %v1, i32* %v2, i1 (i8)** @tests.valid_name_token)
    %tmp76 = load i32, i32* %v2
    %tmp77 = load i32, i32* %v5
    %tmp78 = sub i32 %tmp76, %tmp77
    %tmp79 = call %struct.string.String @string.with_size(i32 %tmp78)
    store %struct.string.String %tmp79, %struct.string.String* %v8
    %tmp80 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 0
    %tmp81 = load i8*, i8** %tmp80
    %tmp82 = load i32, i32* %v5
    %tmp83 = getelementptr i8, i8* %tmp81, i32 %tmp82
    %tmp84 = getelementptr inbounds %struct.string.String, %struct.string.String* %v8, i32 0, i32 0
    %tmp85 = load i8*, i8** %tmp84
    %tmp86 = getelementptr inbounds %struct.string.String, %struct.string.String* %v8, i32 0, i32 1
    %tmp87 = load i32, i32* %tmp86
    %tmp88 = sext i32 %tmp87 to i64
    call void @mem.copy(i8* %tmp83, i8* %tmp85, i64 %tmp88)
    %tmp89 = load %struct.string.String, %struct.string.String* %v8
    call void @"vector.push<%struct.string.String>"(%"struct.vector.Vec<%struct.string.String>"* %v6, %struct.string.String %tmp89)
    br label %loop_body1
    br label %endif8
endif8:
    %tmp90 = load i8, i8* %v3
    %tmp91 = icmp eq i8 %tmp90, 34
    br i1 %tmp91, label %then9, label %endif9
then9:
    %tmp92 = load i32, i32* %v2
    store i32 %tmp92, i32* %v5
    br label %loop_body10
loop_body10:
    %tmp93 = load i32, i32* %v2
    %tmp94 = add i32 %tmp93, 1
    store i32 %tmp94, i32* %v2
    %tmp95 = load i32, i32* %v2
    %tmp96 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 1
    %tmp97 = load i32, i32* %tmp96
    %tmp98 = icmp sge i32 %tmp95, %tmp97
    br i1 %tmp98, label %then11, label %endif11
then11:
    br label %loop_body10_exit
    br label %endif11
endif11:
    %tmp99 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 0
    %tmp100 = load i8*, i8** %tmp99
    %tmp101 = load i32, i32* %v2
    %tmp102 = getelementptr inbounds i8, i8* %tmp100, i32 %tmp101
    %tmp103 = load i8, i8* %tmp102
    %tmp104 = icmp eq i8 %tmp103, 34
    br i1 %tmp104, label %then12, label %endif12
then12:
    %tmp105 = load i32, i32* %v2
    %tmp106 = add i32 %tmp105, 1
    store i32 %tmp106, i32* %v2
    br label %loop_body10_exit
    br label %endif12
endif12:
    br label %loop_body10
loop_body10_exit:
    %tmp107 = load i32, i32* %v2
    %tmp108 = load i32, i32* %v5
    %tmp109 = sub i32 %tmp107, %tmp108
    %tmp110 = call %struct.string.String @string.with_size(i32 %tmp109)
    store %struct.string.String %tmp110, %struct.string.String* %v9
    %tmp111 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 0
    %tmp112 = load i8*, i8** %tmp111
    %tmp113 = load i32, i32* %v5
    %tmp114 = getelementptr i8, i8* %tmp112, i32 %tmp113
    %tmp115 = getelementptr inbounds %struct.string.String, %struct.string.String* %v9, i32 0, i32 0
    %tmp116 = load i8*, i8** %tmp115
    %tmp117 = getelementptr inbounds %struct.string.String, %struct.string.String* %v9, i32 0, i32 1
    %tmp118 = load i32, i32* %tmp117
    %tmp119 = sext i32 %tmp118 to i64
    call void @mem.copy(i8* %tmp114, i8* %tmp116, i64 %tmp119)
    %tmp120 = load %struct.string.String, %struct.string.String* %v9
    call void @"vector.push<%struct.string.String>"(%"struct.vector.Vec<%struct.string.String>"* %v6, %struct.string.String %tmp120)
    br label %loop_body1
    br label %endif9
endif9:
    %tmp121 = load i8, i8* %v3
    %tmp122 = icmp eq i8 %tmp121, 39
    br i1 %tmp122, label %then13, label %endif13
then13:
    %tmp123 = load i32, i32* %v2
    %tmp124 = add i32 %tmp123, 1
    store i32 %tmp124, i32* %v2
    br label %loop_body1
    br label %endif13
endif13:
    %tmp125 = load i8, i8* %v3
    %tmp126 = icmp eq i8 %tmp125, 40
    br i1 %tmp126, label %then14, label %endif14
then14:
    %tmp127 = load i32, i32* %v2
    %tmp128 = add i32 %tmp127, 1
    store i32 %tmp128, i32* %v2
    br label %loop_body1
    br label %endif14
endif14:
    %tmp129 = load i8, i8* %v3
    %tmp130 = icmp eq i8 %tmp129, 41
    br i1 %tmp130, label %then15, label %endif15
then15:
    %tmp131 = load i32, i32* %v2
    %tmp132 = add i32 %tmp131, 1
    store i32 %tmp132, i32* %v2
    br label %loop_body1
    br label %endif15
endif15:
    %tmp133 = load i8, i8* %v3
    %tmp134 = icmp eq i8 %tmp133, 123
    br i1 %tmp134, label %then16, label %endif16
then16:
    %tmp135 = load i32, i32* %v2
    %tmp136 = add i32 %tmp135, 1
    store i32 %tmp136, i32* %v2
    br label %loop_body1
    br label %endif16
endif16:
    %tmp137 = load i8, i8* %v3
    %tmp138 = icmp eq i8 %tmp137, 125
    br i1 %tmp138, label %then17, label %endif17
then17:
    %tmp139 = load i32, i32* %v2
    %tmp140 = add i32 %tmp139, 1
    store i32 %tmp140, i32* %v2
    br label %loop_body1
    br label %endif17
endif17:
    %tmp141 = load i8, i8* %v3
    %tmp142 = icmp eq i8 %tmp141, 91
    br i1 %tmp142, label %then18, label %endif18
then18:
    %tmp143 = load i32, i32* %v2
    %tmp144 = add i32 %tmp143, 1
    store i32 %tmp144, i32* %v2
    br label %loop_body1
    br label %endif18
endif18:
    %tmp145 = load i8, i8* %v3
    %tmp146 = icmp eq i8 %tmp145, 93
    br i1 %tmp146, label %then19, label %endif19
then19:
    %tmp147 = load i32, i32* %v2
    %tmp148 = add i32 %tmp147, 1
    store i32 %tmp148, i32* %v2
    br label %loop_body1
    br label %endif19
endif19:
    %tmp149 = load i8, i8* %v3
    %tmp150 = icmp eq i8 %tmp149, 61
    br i1 %tmp150, label %then20, label %endif20
then20:
    %tmp151 = load i8, i8* %v4
    %tmp152 = icmp eq i8 %tmp151, 61
    br i1 %tmp152, label %then21, label %endif21
then21:
    %tmp153 = load i32, i32* %v2
    %tmp154 = add i32 %tmp153, 2
    store i32 %tmp154, i32* %v2
    br label %loop_body1
    br label %endif21
endif21:
    %tmp155 = load i32, i32* %v2
    %tmp156 = add i32 %tmp155, 1
    store i32 %tmp156, i32* %v2
    br label %loop_body1
    br label %endif20
endif20:
    %tmp157 = load i8, i8* %v3
    %tmp158 = icmp eq i8 %tmp157, 58
    br i1 %tmp158, label %then22, label %endif22
then22:
    %tmp159 = load i8, i8* %v4
    %tmp160 = icmp eq i8 %tmp159, 58
    br i1 %tmp160, label %then23, label %endif23
then23:
    %tmp161 = load i32, i32* %v2
    %tmp162 = add i32 %tmp161, 2
    store i32 %tmp162, i32* %v2
    br label %loop_body1
    br label %endif23
endif23:
    %tmp163 = load i32, i32* %v2
    %tmp164 = add i32 %tmp163, 1
    store i32 %tmp164, i32* %v2
    br label %loop_body1
    br label %endif22
endif22:
    %tmp165 = load i8, i8* %v3
    %tmp166 = icmp eq i8 %tmp165, 124
    br i1 %tmp166, label %then24, label %endif24
then24:
    %tmp167 = load i8, i8* %v4
    %tmp168 = icmp eq i8 %tmp167, 124
    br i1 %tmp168, label %then25, label %endif25
then25:
    %tmp169 = load i32, i32* %v2
    %tmp170 = add i32 %tmp169, 2
    store i32 %tmp170, i32* %v2
    br label %loop_body1
    br label %endif25
endif25:
    %tmp171 = load i32, i32* %v2
    %tmp172 = add i32 %tmp171, 1
    store i32 %tmp172, i32* %v2
    br label %loop_body1
    br label %endif24
endif24:
    %tmp173 = load i8, i8* %v3
    %tmp174 = icmp eq i8 %tmp173, 38
    br i1 %tmp174, label %then26, label %endif26
then26:
    %tmp175 = load i8, i8* %v4
    %tmp176 = icmp eq i8 %tmp175, 38
    br i1 %tmp176, label %then27, label %endif27
then27:
    %tmp177 = load i32, i32* %v2
    %tmp178 = add i32 %tmp177, 2
    store i32 %tmp178, i32* %v2
    br label %loop_body1
    br label %endif27
endif27:
    %tmp179 = load i32, i32* %v2
    %tmp180 = add i32 %tmp179, 1
    store i32 %tmp180, i32* %v2
    br label %loop_body1
    br label %endif26
endif26:
    %tmp181 = load i8, i8* %v3
    %tmp182 = icmp eq i8 %tmp181, 62
    br i1 %tmp182, label %then28, label %endif28
then28:
    %tmp183 = load i8, i8* %v4
    %tmp184 = icmp eq i8 %tmp183, 61
    br i1 %tmp184, label %then29, label %endif29
then29:
    %tmp185 = load i32, i32* %v2
    %tmp186 = add i32 %tmp185, 2
    store i32 %tmp186, i32* %v2
    br label %loop_body1
    br label %endif29
endif29:
    %tmp187 = load i32, i32* %v2
    %tmp188 = add i32 %tmp187, 1
    store i32 %tmp188, i32* %v2
    br label %loop_body1
    br label %endif28
endif28:
    %tmp189 = load i8, i8* %v3
    %tmp190 = icmp eq i8 %tmp189, 60
    br i1 %tmp190, label %then30, label %endif30
then30:
    %tmp191 = load i8, i8* %v4
    %tmp192 = icmp eq i8 %tmp191, 61
    br i1 %tmp192, label %then31, label %endif31
then31:
    %tmp193 = load i32, i32* %v2
    %tmp194 = add i32 %tmp193, 2
    store i32 %tmp194, i32* %v2
    br label %loop_body1
    br label %endif31
endif31:
    %tmp195 = load i32, i32* %v2
    %tmp196 = add i32 %tmp195, 1
    store i32 %tmp196, i32* %v2
    br label %loop_body1
    br label %endif30
endif30:
    %tmp197 = load i8, i8* %v3
    %tmp198 = icmp eq i8 %tmp197, 35
    br i1 %tmp198, label %then32, label %endif32
then32:
    %tmp199 = load i32, i32* %v2
    %tmp200 = add i32 %tmp199, 1
    store i32 %tmp200, i32* %v2
    br label %loop_body1
    br label %endif32
endif32:
    %tmp201 = load i8, i8* %v3
    %tmp202 = icmp eq i8 %tmp201, 59
    br i1 %tmp202, label %then33, label %endif33
then33:
    %tmp203 = load i32, i32* %v2
    %tmp204 = add i32 %tmp203, 1
    store i32 %tmp204, i32* %v2
    br label %loop_body1
    br label %endif33
endif33:
    %tmp205 = load i8, i8* %v3
    %tmp206 = icmp eq i8 %tmp205, 46
    br i1 %tmp206, label %then34, label %endif34
then34:
    %tmp207 = load i32, i32* %v2
    %tmp208 = add i32 %tmp207, 1
    store i32 %tmp208, i32* %v2
    br label %loop_body1
    br label %endif34
endif34:
    %tmp209 = load i8, i8* %v3
    %tmp210 = icmp eq i8 %tmp209, 44
    br i1 %tmp210, label %then35, label %endif35
then35:
    %tmp211 = load i32, i32* %v2
    %tmp212 = add i32 %tmp211, 1
    store i32 %tmp212, i32* %v2
    br label %loop_body1
    br label %endif35
endif35:
    %tmp213 = load i8, i8* %v3
    %tmp214 = icmp eq i8 %tmp213, 43
    br i1 %tmp214, label %then36, label %endif36
then36:
    %tmp215 = load i32, i32* %v2
    %tmp216 = add i32 %tmp215, 1
    store i32 %tmp216, i32* %v2
    br label %loop_body1
    br label %endif36
endif36:
    %tmp217 = load i8, i8* %v3
    %tmp218 = icmp eq i8 %tmp217, 45
    br i1 %tmp218, label %then37, label %endif37
then37:
    %tmp219 = load i32, i32* %v2
    %tmp220 = add i32 %tmp219, 1
    store i32 %tmp220, i32* %v2
    br label %loop_body1
    br label %endif37
endif37:
    %tmp221 = load i8, i8* %v3
    %tmp222 = icmp eq i8 %tmp221, 42
    br i1 %tmp222, label %then38, label %endif38
then38:
    %tmp223 = load i32, i32* %v2
    %tmp224 = add i32 %tmp223, 1
    store i32 %tmp224, i32* %v2
    br label %loop_body1
    br label %endif38
endif38:
    %tmp225 = load i8, i8* %v3
    %tmp226 = icmp eq i8 %tmp225, 47
    br i1 %tmp226, label %then39, label %endif39
then39:
    %tmp227 = load i32, i32* %v2
    %tmp228 = add i32 %tmp227, 1
    store i32 %tmp228, i32* %v2
    br label %loop_body1
    br label %endif39
endif39:
    %tmp229 = load i8, i8* %v3
    %tmp230 = icmp eq i8 %tmp229, 37
    br i1 %tmp230, label %then40, label %endif40
then40:
    %tmp231 = load i32, i32* %v2
    %tmp232 = add i32 %tmp231, 1
    store i32 %tmp232, i32* %v2
    br label %loop_body1
    br label %endif40
endif40:
    %tmp233 = load i8, i8* %v3
    %tmp234 = icmp eq i8 %tmp233, 33
    br i1 %tmp234, label %then41, label %endif41
then41:
    %tmp235 = load i32, i32* %v2
    %tmp236 = add i32 %tmp235, 1
    store i32 %tmp236, i32* %v2
    br label %loop_body1
    br label %endif41
endif41:
    %tmp237 = load i8, i8* %v3
    %tmp238 = icmp eq i8 %tmp237, 126
    br i1 %tmp238, label %then42, label %endif42
then42:
    %tmp239 = load i32, i32* %v2
    %tmp240 = add i32 %tmp239, 1
    store i32 %tmp240, i32* %v2
    br label %loop_body1
    br label %endif42
endif42:
    %tmp241 = load i8, i8* %v3
    %tmp242 = icmp eq i8 %tmp241, 92
    br i1 %tmp242, label %then43, label %endif43
then43:
    %tmp243 = load i32, i32* %v2
    %tmp244 = add i32 %tmp243, 1
    store i32 %tmp244, i32* %v2
    br label %loop_body1
    br label %endif43
endif43:
    %tmp245 = load i8, i8* %v3
    call void @console.print_char(i8 %tmp245)
    call void @console.print_char(i8 10)
    %tmp246 = load i32, i32* %v2
    %tmp247 = add i32 %tmp246, 1
    store i32 %tmp247, i32* %v2
    br label %loop_body1
loop_body1_exit:
    store i32 0, i32* %v10
    br label %loop_body44
loop_body44:
    %tmp248 = load i32, i32* %v10
    %tmp249 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %v6, i32 0, i32 1
    %tmp250 = load i32, i32* %tmp249
    %tmp251 = icmp uge i32 %tmp248, %tmp250
    br i1 %tmp251, label %then45, label %endif45
then45:
    br label %loop_body44_exit
    br label %endif45
endif45:
    %tmp252 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %v6, i32 0, i32 0
    %tmp253 = load %struct.string.String*, %struct.string.String** %tmp252
    %tmp254 = load i32, i32* %v10
    %tmp255 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp253, i32 %tmp254
    call void @console.write_string(%struct.string.String* %tmp255)
    %tmp256 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.74, i64 0, i64 0
    call void @console.write(i8* %tmp256, i32 1)
    %tmp257 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %v6, i32 0, i32 0
    %tmp258 = load %struct.string.String*, %struct.string.String** %tmp257
    %tmp259 = load i32, i32* %v10
    %tmp260 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp258, i32 %tmp259
    call void @string.free(%struct.string.String* %tmp260)
    %tmp261 = load i32, i32* %v10
    %tmp262 = add i32 %tmp261, 1
    store i32 %tmp262, i32* %v10
    br label %loop_body44
loop_body44_exit:
    call void @"vector.free<%struct.string.String>"(%"struct.vector.Vec<%struct.string.String>"* %v6)
    call void @string.free(%struct.string.String* %v1)
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
    %v0 = alloca %"struct.test.QPair<i64, i64>" ()**; var: y
    store %"struct.test.QPair<i64, i64>" ()** @test.geg, %"struct.test.QPair<i64, i64>" ()*** %v0
    %tmp0 = load %"struct.test.QPair<i64, i64>" ()**, %"struct.test.QPair<i64, i64>" ()*** %v0
    %tmp1 = call %"struct.test.QPair<i64, i64>" %tmp0()
    ret %"struct.test.QPair<i64, i64>" %tmp1
}
define i32 @"main"(){
    %v0 = alloca double; var: f
    %v1 = alloca i32 ()**; var: tp
    %v2 = alloca %"struct.test.QPair<i64, i64>"; var: temp
    store double 0x40DEADDD3B80D02E, double* %v0
    store i32 ()** @main, i32 ()*** %v1
    %tmp1 = load double, double* %v0
    call void @console.println_f64(double %tmp1)
    call i32 @AllocConsole()
    call void @tests.run()
    call void @window.start()
    call i32 @FreeConsole()
    br label %inline_exit0
inline_exit0:
    %tmp3 = call %"struct.test.QPair<i64, i64>" @xq()
    store %"struct.test.QPair<i64, i64>" %tmp3, %"struct.test.QPair<i64, i64>"* %v2
    %tmp4 = getelementptr inbounds %"struct.test.QPair<i64, i64>", %"struct.test.QPair<i64, i64>"* %v2, i32 0, i32 0
    %tmp5 = load i64, i64* %tmp4
    %tmp6 = trunc i64 %tmp5 to i32
    ret i32 %tmp6
}
define i64 @"window.WindowProc"(i8* %hWnd, i32 %uMsg, i64 %wParam, i64 %lParam){
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
    %tmp5 = call i64 @DefWindowProcA(i8* %hWnd, i32 %uMsg, i64 %wParam, i64 %lParam)
    ret i64 %tmp5
}
define void @"window.start"(){
    %v0 = alloca i32; var: CW_USEDEFAULT
    %v1 = alloca i8*; var: hInstance
    %v2 = alloca i8*; var: className
    %v3 = alloca %struct.window.WNDCLASSEXA; var: wc
    %v4 = alloca i8*; var: windowTitle
    %v5 = alloca i8*; var: hWnd
    %v6 = alloca %struct.window.MSG; var: msg
    store i32 2147483648, i32* %v0
    %tmp0 = call i8* @GetModuleHandleA(i8* null)
    %tmp1 = bitcast i8* %tmp0 to i8*
    store i8* %tmp1, i8** %v1
    %iv2 = alloca i1
    %tmp3 = load i8*, i8** %v1
    %tmp4 = icmp eq ptr %tmp3, null
    store i1 %tmp4, i1* %iv2
    br label %inline_exit0
inline_exit0:
    %tmp5 = load i1, i1* %iv2
    br i1 %tmp5, label %then1, label %endif1
then1:
    %tmp6 = getelementptr inbounds [48 x i8], [48 x i8]* @.str.75, i64 0, i64 0
    call void @process.throw(i8* %tmp6)
    br label %endif1
endif1:
    %tmp7 = getelementptr inbounds [14 x i8], [14 x i8]* @.str.76, i64 0, i64 0
    store i8* %tmp7, i8** %v2
    %tmp8 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v3, i32 0, i32 0
    store i32 80, i32* %tmp8
    %tmp9 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v3, i32 0, i32 1
    %tmp10 = or i32 2, 1
    store i32 %tmp10, i32* %tmp9
    %tmp11 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v3, i32 0, i32 2
    store i64 (i8*, i32, i64, i64)** @window.WindowProc, i64 (i8*, i32, i64, i64)*** %tmp11
    %tmp12 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v3, i32 0, i32 3
    store i32 0, i32* %tmp12
    %tmp13 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v3, i32 0, i32 4
    store i32 0, i32* %tmp13
    %tmp14 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v3, i32 0, i32 5
    %tmp15 = load i8*, i8** %v1
    store i8* %tmp15, i8** %tmp14
    %tmp16 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v3, i32 0, i32 6
    store i8* null, i8** %tmp16
    %tmp17 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v3, i32 0, i32 7
    store i8* null, i8** %tmp17
    %tmp18 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v3, i32 0, i32 8
    %tmp19 = add i32 5, 1
    %tmp20 = inttoptr i32 %tmp19 to i8*
    store i8* %tmp20, i8** %tmp18
    %tmp21 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v3, i32 0, i32 9
    store i8* null, i8** %tmp21
    %tmp22 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v3, i32 0, i32 10
    %tmp23 = load i8*, i8** %v2
    store i8* %tmp23, i8** %tmp22
    %tmp24 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v3, i32 0, i32 11
    store i8* null, i8** %tmp24
    %tmp25 = call i16 @RegisterClassExA(%struct.window.WNDCLASSEXA* %v3)
    %tmp26 = icmp eq i16 %tmp25, 0
    br i1 %tmp26, label %then2, label %endif2
then2:
    %tmp27 = getelementptr inbounds [46 x i8], [46 x i8]* @.str.77, i64 0, i64 0
    call void @process.throw(i8* %tmp27)
    br label %endif2
endif2:
    %tmp28 = getelementptr inbounds [14 x i8], [14 x i8]* @.str.78, i64 0, i64 0
    store i8* %tmp28, i8** %v4
    %tmp29 = load i8*, i8** %v2
    %tmp30 = load i8*, i8** %v4
    %tmp31 = load i32, i32* %v0
    %tmp32 = load i32, i32* %v0
    %tmp33 = load i8*, i8** %v1
    %tmp34 = call i8* @CreateWindowExA(i32 0, i8* %tmp29, i8* %tmp30, i32 13565952, i32 %tmp31, i32 %tmp32, i32 800, i32 600, i8* null, i8* null, i8* %tmp33, i8* null)
    store i8* %tmp34, i8** %v5
    %iv35 = alloca i1
    %tmp36 = load i8*, i8** %v5
    %tmp37 = icmp eq ptr %tmp36, null
    store i1 %tmp37, i1* %iv35
    br label %inline_exit3
inline_exit3:
    %tmp38 = load i1, i1* %iv35
    br i1 %tmp38, label %then4, label %endif4
then4:
    %tmp39 = getelementptr inbounds [45 x i8], [45 x i8]* @.str.79, i64 0, i64 0
    call void @process.throw(i8* %tmp39)
    br label %endif4
endif4:
    %tmp40 = load i8*, i8** %v5
    call i32 @ShowWindow(i8* %tmp40, i32 1)
    %tmp41 = load i8*, i8** %v5
    call i32 @UpdateWindow(i8* %tmp41)
    br label %loop_body5
loop_body5:
    %tmp42 = call i32 @PeekMessageA(%struct.window.MSG* %v6, i8* null, i32 0, i32 0, i32 1)
    %tmp43 = icmp ne i32 %tmp42, 0
    br i1 %tmp43, label %then6, label %endif6
then6:
    %tmp44 = getelementptr inbounds %struct.window.MSG, %struct.window.MSG* %v6, i32 0, i32 1
    %tmp45 = load i32, i32* %tmp44
    %tmp46 = icmp eq i32 %tmp45, 18
    br i1 %tmp46, label %then7, label %endif7
then7:
    br label %loop_body5_exit
    br label %endif7
endif7:
    call i32 @TranslateMessage(%struct.window.MSG* %v6)
    call i64 @DispatchMessageA(%struct.window.MSG* %v6)
    br label %endif6
endif6:
    br label %loop_body5
loop_body5_exit:
    ret void
}
define void @"window.message_box"(i8* %content, i8* %title){
    %v0 = alloca i32; var: MB_OK
    %v1 = alloca i32; var: MB_ICONINFO
    store i32 0, i32* %v0
    store i32 64, i32* %v1
    %tmp0 = load i32, i32* %v0
    %tmp1 = load i32, i32* %v1
    %tmp2 = or i32 %tmp0, %tmp1
    call i32 @MessageBoxA(i8* null, i8* %content, i8* %title, i32 %tmp2)
    ret void
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
define void @"vector.push<i8>"(%"struct.vector.Vec<i8>"* %vec, i8 %data){
    %v0 = alloca i32; var: new_capacity
    %v1 = alloca i8*; var: new_array
    %v2 = alloca i32; var: i
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
    %tmp14 = call i8* @mem.malloc(i64 %tmp13)
    %tmp15 = bitcast i8* %tmp14 to i8*
    store i8* %tmp15, i8** %v1
    %tmp16 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 0
    %tmp17 = load i8*, i8** %tmp16
    %tmp18 = icmp ne ptr %tmp17, null
    br i1 %tmp18, label %then2, label %endif2
then2:
    store i32 0, i32* %v2
    br label %loop_body3
loop_body3:
    %tmp19 = load i32, i32* %v2
    %tmp20 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 1
    %tmp21 = load i32, i32* %tmp20
    %tmp22 = icmp uge i32 %tmp19, %tmp21
    br i1 %tmp22, label %then4, label %endif4
then4:
    br label %loop_body3_exit
    br label %endif4
endif4:
    %tmp23 = load i8*, i8** %v1
    %tmp24 = load i32, i32* %v2
    %tmp25 = getelementptr inbounds i8, i8* %tmp23, i32 %tmp24
    %tmp26 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 0
    %tmp27 = load i8*, i8** %tmp26
    %tmp28 = load i32, i32* %v2
    %tmp29 = getelementptr inbounds i8, i8* %tmp27, i32 %tmp28
    %tmp30 = load i8, i8* %tmp29
    store i8 %tmp30, i8* %tmp25
    %tmp31 = load i32, i32* %v2
    %tmp32 = add i32 %tmp31, 1
    store i32 %tmp32, i32* %v2
    br label %loop_body3
loop_body3_exit:
    %tmp33 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 0
    %tmp34 = load i8*, i8** %tmp33
    %tmp35 = bitcast i8* %tmp34 to i8*
    call void @mem.free(i8* %tmp35)
    br label %endif2
endif2:
    %tmp36 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 0
    %tmp37 = load i8*, i8** %v1
    store i8* %tmp37, i8** %tmp36
    %tmp38 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 2
    %tmp39 = load i32, i32* %v0
    store i32 %tmp39, i32* %tmp38
    br label %endif0
endif0:
    %tmp40 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 0
    %tmp41 = load i8*, i8** %tmp40
    %tmp42 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 1
    %tmp43 = load i32, i32* %tmp42
    %tmp44 = getelementptr inbounds i8, i8* %tmp41, i32 %tmp43
    store i8 %data, i8* %tmp44
    %tmp45 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 1
    %tmp46 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 1
    %tmp47 = load i32, i32* %tmp46
    %tmp48 = add i32 %tmp47, 1
    store i32 %tmp48, i32* %tmp45
    ret void
}
define void @"vector.push<%struct.string.String>"(%"struct.vector.Vec<%struct.string.String>"* %vec, %struct.string.String %data){
    %v0 = alloca i32; var: new_capacity
    %v1 = alloca %struct.string.String*; var: new_array
    %v2 = alloca i32; var: i
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
    %tmp14 = call i8* @mem.malloc(i64 %tmp13)
    %tmp15 = bitcast i8* %tmp14 to %struct.string.String*
    store %struct.string.String* %tmp15, %struct.string.String** %v1
    %tmp16 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 0
    %tmp17 = load %struct.string.String*, %struct.string.String** %tmp16
    %tmp18 = icmp ne ptr %tmp17, null
    br i1 %tmp18, label %then2, label %endif2
then2:
    store i32 0, i32* %v2
    br label %loop_body3
loop_body3:
    %tmp19 = load i32, i32* %v2
    %tmp20 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 1
    %tmp21 = load i32, i32* %tmp20
    %tmp22 = icmp uge i32 %tmp19, %tmp21
    br i1 %tmp22, label %then4, label %endif4
then4:
    br label %loop_body3_exit
    br label %endif4
endif4:
    %tmp23 = load %struct.string.String*, %struct.string.String** %v1
    %tmp24 = load i32, i32* %v2
    %tmp25 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp23, i32 %tmp24
    %tmp26 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 0
    %tmp27 = load %struct.string.String*, %struct.string.String** %tmp26
    %tmp28 = load i32, i32* %v2
    %tmp29 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp27, i32 %tmp28
    %tmp30 = load %struct.string.String, %struct.string.String* %tmp29
    store %struct.string.String %tmp30, %struct.string.String* %tmp25
    %tmp31 = load i32, i32* %v2
    %tmp32 = add i32 %tmp31, 1
    store i32 %tmp32, i32* %v2
    br label %loop_body3
loop_body3_exit:
    %tmp33 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 0
    %tmp34 = load %struct.string.String*, %struct.string.String** %tmp33
    %tmp35 = bitcast %struct.string.String* %tmp34 to i8*
    call void @mem.free(i8* %tmp35)
    br label %endif2
endif2:
    %tmp36 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 0
    %tmp37 = load %struct.string.String*, %struct.string.String** %v1
    store %struct.string.String* %tmp37, %struct.string.String** %tmp36
    %tmp38 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 2
    %tmp39 = load i32, i32* %v0
    store i32 %tmp39, i32* %tmp38
    br label %endif0
endif0:
    %tmp40 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 0
    %tmp41 = load %struct.string.String*, %struct.string.String** %tmp40
    %tmp42 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 1
    %tmp43 = load i32, i32* %tmp42
    %tmp44 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp41, i32 %tmp43
    store %struct.string.String %data, %struct.string.String* %tmp44
    %tmp45 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 1
    %tmp46 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 1
    %tmp47 = load i32, i32* %tmp46
    %tmp48 = add i32 %tmp47, 1
    store i32 %tmp48, i32* %tmp45
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
define void @"list.new_node<i32>"(%"struct.list.ListNode<i32>"* %list){
    %tmp0 = getelementptr inbounds %"struct.list.ListNode<i32>", %"struct.list.ListNode<i32>"* %list, i32 0, i32 1
    store %"struct.list.ListNode<i32>"* null, %"struct.list.ListNode<i32>"** %tmp0
    %tmp1 = getelementptr inbounds %"struct.list.ListNode<i32>", %"struct.list.ListNode<i32>"* %list, i32 0, i32 0
    store i32 0, i32* %tmp1
    ret void
}

;fn __chkstk used times 0
;fn _fltused used times 0
;fn process.ExitProcess used times 8
;fn process.GetModuleFileNameA used times 2
;fn process.get_executable_path used times 4
;fn process.get_executable_env_path used times 4
;fn process.throw used times 88
;fn mem.GetProcessHeap used times 6
;fn mem.HeapAlloc used times 2
;fn mem.HeapFree used times 2
;fn mem.HeapSize used times 0
;fn mem.HeapWalk used times 2
;fn mem.HeapLock used times 2
;fn mem.HeapUnlock used times 2
;fn mem.malloc used times 12
;fn mem.free used times 8
;fn mem.copy used times 22
;fn mem.zero_fill used times 2
;fn mem.fill used times 6
;fn mem.default_fill used times 0
;fn mem.get_total_allocated_memory_external used times 4
;fn list.new used times 3
;fn list.new_node used times 0
;fn list.extend used times 9
;fn list.walk used times 3
;fn list.free used times 3
;fn vector.new used times 6
;fn vector.push used times 24
;fn vector.push_bulk used times 3
;fn vector.free used times 6
;fn console.AllocConsole used times 4
;fn console.GetStdHandle used times 4
;fn console.FreeConsole used times 2
;fn console.WriteConsoleA used times 14
;fn console.get_stdout used times 8
;fn console.write used times 38
;fn console.write_string used times 2
;fn console.writeln used times 26
;fn console.print_char used times 18
;fn console.println_i64 used times 8
;fn console.println_u64 used times 6
;fn console.println_f64 used times 2
;fn string.from_c_string used times 10
;fn string.empty used times 2
;fn string.with_size used times 10
;fn string.concat_with_c_string used times 4
;fn string.equal used times 8
;fn string.free used times 28
;fn string.as_c_string_stalloc used times 2
;fn string_utils.insert used times 4
;fn string_utils.c_str_len used times 16
;fn string_utils.is_ascii_num used times 10
;fn string_utils.is_ascii_char used times 8
;fn string_utils.is_ascii_hex used times 6
;fn fs.CreateFileA used times 6
;fn fs.WriteFile used times 2
;fn fs.ReadFile used times 2
;fn fs.GetFileSizeEx used times 2
;fn fs.CloseHandle used times 8
;fn fs.DeleteFileA used times 2
;fn fs.write_to_file used times 2
;fn fs.read_full_file_as_string used times 4
;fn fs.create_file used times 6
;fn fs.delete_file used times 6
;fn tests.run used times 2
;fn tests.mem_test used times 2
;fn tests.string_utils_test used times 2
;fn tests.string_test used times 2
;fn tests.vector_test used times 2
;fn tests.list_test used times 2
;fn tests.process_test used times 2
;fn tests.console_test used times 2
;fn tests.fs_test used times 2
;fn tests.consume_while used times 6
;fn tests.not_new_line used times 1
;fn tests.valid_name_token used times 1
;fn tests.is_valid_number_token used times 1
;fn tests.funny used times 2
;fn basic_functions used times 2
;fn ax used times 0
;fn of_fn used times 2
;fn test.geg used times 1
;fn xq used times 2
;fn main used times 1
;fn window.RegisterClassExA used times 2
;fn window.CreateWindowExA used times 2
;fn window.ShowWindow used times 2
;fn window.UpdateWindow used times 2
;fn window.GetMessageA used times 0
;fn window.PeekMessageA used times 2
;fn window.TranslateMessage used times 2
;fn window.DispatchMessageA used times 2
;fn window.DefWindowProcA used times 2
;fn window.PostQuitMessage used times 6
;fn window.GetModuleHandleA used times 2
;fn window.MessageBoxA used times 2
;fn window.WindowProc used times 1
;fn window.is_null used times 4
;fn window.start used times 2
;fn window.message_box used times 0
