%struct.window.POINT = type { i32, i32 }
%struct.window.MSG = type { i8*, i32, i64, i64, i32, %struct.window.POINT }
%struct.window.WNDCLASSEXA = type { i32, i32, i64 (i8*, i32, i64, i64)*, i32, i32, i8*, i8*, i8*, i8*, i8*, i8*, i8* }
%struct.window.RECT = type { i32, i32, i32, i32 }
%struct.window.PAINTSTRUCT = type { i8*, i32, %struct.window.RECT, i32, i32, i8* }
%struct.window.BITMAP = type { i32, i32, i32, i32, i16, i16, i8* }
%struct.string.String = type { i8*, i32 }
%struct.mem.PROCESS_HEAP_ENTRY = type { i8*, i32, i8, i8, i16, i8*, i32, i32, i32 }
%"struct.Pair<i8, %struct.string.String>" = type { i8, %struct.string.String }
%"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>" = type { i32, %"struct.Pair<i8, %struct.string.String>" }
%"struct.vector.Vec<%struct.string.String>" = type { %struct.string.String*, i32, i32 }
%"struct.vector.Vec<i64>" = type { i64*, i32, i32 }
%"struct.vector.Vec<i8>" = type { i8*, i32, i32 }
%"struct.list.List<i32>" = type { %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"*, i32 }
%"struct.list.ListNode<i32>" = type { i32, %"struct.list.ListNode<i32>"* }
%"struct.test.QPair<i64, i64>" = type { i64, i64 }
declare dllimport i8* @CreateWindowExA(i32 %dwExStyle, i8* %lpClassName, i8* %lpWindowName, i32 %dwStyle, i32 %x, i32 %y, i32 %nWidth, i32 %nHeight, i8* %hWndParent, i8* %hMenu, i8* %hInstance, i8* %lpParam)
declare dllimport i64 @DefWindowProcA(i8* %hWnd, i32 %Msg, i64 %wParam, i64 %lParam)
declare dllimport i32 @GetMessageA(%struct.window.MSG* %lpMsg, i8* %hWnd, i32 %wMsgFilterMin, i32 %wMsgFilterMax)
declare dllimport i32 @TranslateMessage(%struct.window.MSG* %lpMsg)
declare dllimport i64 @DispatchMessageA(%struct.window.MSG* %lpMsg)
declare dllimport void @PostQuitMessage(i32 %nExitCode)
declare dllimport i8* @BeginPaint(i8* %hWnd, %struct.window.PAINTSTRUCT* %lpPaint)
declare dllimport i32 @EndPaint(i8* %hWnd, %struct.window.PAINTSTRUCT* %lpPaint)
declare dllimport i8* @GetModuleHandleA(i8* %lpModuleName)
declare dllimport i16 @RegisterClassExA(%struct.window.WNDCLASSEXA* %lpwcx)
declare dllimport i32 @ShowWindow(i8* %hWnd, i32 %nCmdShow)
declare dllimport i8* @CreateCompatibleDC(i8* %hdc)
declare dllimport i8* @SelectObject(i8* %hdc, i8* %h)
declare dllimport i32 @BitBlt(i8* %hdc, i32 %x, i32 %y, i32 %cx, i32 %cy, i8* %hdcSrc, i32 %x1, i32 %y1, i32 %rop)
declare dllimport i32 @DeleteDC(i8* %hdc)
declare dllimport i32 @GetObjectA(i8* %h, i32 %c, %struct.window.BITMAP* %pv)
declare dllimport i8* @GetWindowLongPtrA(i8* %hWnd, i32 %nIndex)
declare dllimport i8* @CreateFileA(i8* %lpFileName, i32 %dwDesiredAccess, i32 %dwShareMode, i8* %lpSecurityAttributes, i32 %dwCreationDisposition, i32 %dwFlagsAndAttributes, i8* %hTemplateFile)
declare dllimport i32 @WriteFile(i8* %hFile, i8* %lpBuffer, i32 %nNumberOfBytesToWrite, i32* %lpNumberOfBytesWritten, i8* %lpOverlapped)
declare dllimport i32 @ReadFile(i8* %hFile, i8* %lpBuffer, i32 %nNumberOfBytesToRead, i32* %lpNumberOfBytesRead, i8* %lpOverlapped)
declare dllimport i32 @GetFileSizeEx(i8* %hFile, i64* %lpFileSize)
declare dllimport i32 @CloseHandle(i8* %hObject)
declare dllimport i32 @DeleteFileA(i8* %lpFileName)
declare dllimport i32 @AllocConsole()
declare dllimport i8* @GetStdHandle(i32 %nStdHandle)
declare dllimport i32 @FreeConsole()
declare dllimport i32 @WriteConsoleA(i8* %hConsoleOutput, i8* %lpBuffer, i32 %nNumberOfCharsToWrite, i32* %lpNumberOfCharsWritten, i8* %lpReserved)
declare dllimport i32* @GetProcessHeap()
declare dllimport i8* @HeapAlloc(i32* %hHeap, i32 %dwFlags, i64 %dwBytes)
declare dllimport i8* @HeapReAlloc(i32* %hHeap, i32 %dwFlags, i8* %lpMem, i64 %dwBytes)
declare dllimport i32 @HeapFree(i32* %hHeap, i32 %dwFlags, i8* %lpMem)
declare dllimport i32 @HeapWalk(i32* %hHeap, %struct.mem.PROCESS_HEAP_ENTRY* %lpEntry)
declare dllimport i32 @HeapLock(i32* %hHeap)
declare dllimport i32 @HeapUnlock(i32* %hHeap)
declare dllimport void @ExitProcess(i32 %code)
declare dllimport i32 @GetModuleFileNameA(i8* %hModule, i8* %lpFilename, i32 %nSize)


@.str.0 = private unnamed_addr constant [3 x i8] c"0\0A\00"
@.str.1 = private unnamed_addr constant [20 x i8] c"test malloc delta: \00"
@.str.2 = private unnamed_addr constant [48 x i8] c"Window error: StartError::GetModuleHandleFailed\00"
@.str.3 = private unnamed_addr constant [14 x i8] c"MyWindowClass\00"
@.str.4 = private unnamed_addr constant [46 x i8] c"Window error: StartError::RegisterClassFailed\00"
@.str.5 = private unnamed_addr constant [14 x i8] c"Hello, World!\00"
@.str.6 = private unnamed_addr constant [45 x i8] c"Window error: StartError::CreateWindowFailed\00"
@.str.7 = private unnamed_addr constant [12 x i8] c"Exception: \00"
@.str.8 = private unnamed_addr constant [33 x i8] c"Failed to lock heap for walking.\00"
@.str.9 = private unnamed_addr constant [26 x i8] c"stdout handle was invalid\00"
@.str.10 = private unnamed_addr constant [45 x i8] c"D:\Projects\rcsharp\src_base_structs.rcsharp\00"
@.str.11 = private unnamed_addr constant [10 x i8] c"fs_test: \00"
@.str.12 = private unnamed_addr constant [47 x i8] c"The quick brown fox jumps over crazy lost dog.\00"
@.str.13 = private unnamed_addr constant [9 x i8] c"test.txt\00"
@.str.14 = private unnamed_addr constant [38 x i8] c"Filesystem test failed, data mismatch\00"
@.str.15 = private unnamed_addr constant [3 x i8] c"OK\00"
@.str.16 = private unnamed_addr constant [15 x i8] c"\0Aconsole_test:\00"
@.str.17 = private unnamed_addr constant [26 x i8] c"--- VISUAL TEST START ---\00"
@.str.18 = private unnamed_addr constant [22 x i8] c"Printing i64(12345): \00"
@.str.19 = private unnamed_addr constant [23 x i8] c"Printing i64(-67890): \00"
@.str.20 = private unnamed_addr constant [18 x i8] c"Printing i64(0): \00"
@.str.21 = private unnamed_addr constant [27 x i8] c"Printing u64(9876543210): \00"
@.str.22 = private unnamed_addr constant [24 x i8] c"--- VISUAL TEST END ---\00"
@.str.23 = private unnamed_addr constant [15 x i8] c"process_test: \00"
@.str.24 = private unnamed_addr constant [49 x i8] c"process_test: get_executable_path returned empty\00"
@.str.25 = private unnamed_addr constant [53 x i8] c"process_test: get_executable_env_path returned empty\00"
@.str.26 = private unnamed_addr constant [53 x i8] c"process_test: env path is not shorter than full path\00"
@.str.27 = private unnamed_addr constant [53 x i8] c"process_test: env path does not end with a backslash\00"
@.str.28 = private unnamed_addr constant [18 x i8] c"Executable Path: \00"
@.str.29 = private unnamed_addr constant [19 x i8] c"Environment Path: \00"
@.str.30 = private unnamed_addr constant [12 x i8] c"list_test: \00"
@.str.31 = private unnamed_addr constant [22 x i8] c"list_test: new failed\00"
@.str.32 = private unnamed_addr constant [41 x i8] c"list_test: length incorrect after extend\00"
@.str.33 = private unnamed_addr constant [33 x i8] c"list_test: walk length incorrect\00"
@.str.34 = private unnamed_addr constant [36 x i8] c"list_test: data mismatch for node 1\00"
@.str.35 = private unnamed_addr constant [36 x i8] c"list_test: data mismatch for node 2\00"
@.str.36 = private unnamed_addr constant [36 x i8] c"list_test: data mismatch for node 3\00"
@.str.37 = private unnamed_addr constant [33 x i8] c"list_test: foot pointer mismatch\00"
@.str.38 = private unnamed_addr constant [23 x i8] c"list_test: free failed\00"
@.str.39 = private unnamed_addr constant [14 x i8] c"vector_test: \00"
@.str.40 = private unnamed_addr constant [24 x i8] c"vector_test: new failed\00"
@.str.41 = private unnamed_addr constant [33 x i8] c"vector_test: initial push failed\00"
@.str.42 = private unnamed_addr constant [36 x i8] c"vector_test: initial content failed\00"
@.str.43 = private unnamed_addr constant [28 x i8] c"vector_test: realloc failed\00"
@.str.44 = private unnamed_addr constant [36 x i8] c"vector_test: realloc content failed\00"
@.str.45 = private unnamed_addr constant [3 x i8] c"AB\00"
@.str.46 = private unnamed_addr constant [37 x i8] c"vector_test: push_bulk length failed\00"
@.str.47 = private unnamed_addr constant [38 x i8] c"vector_test: push_bulk content failed\00"
@.str.48 = private unnamed_addr constant [25 x i8] c"vector_test: free failed\00"
@.str.49 = private unnamed_addr constant [14 x i8] c"string_test: \00"
@.str.50 = private unnamed_addr constant [6 x i8] c"hello\00"
@.str.51 = private unnamed_addr alias [6 x i8], [6 x i8]* bitcast (i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.56, i64 0, i64 6) to [6 x i8]*)
@.str.52 = private unnamed_addr constant [41 x i8] c"string_test: from_c_string length failed\00"
@.str.53 = private unnamed_addr constant [40 x i8] c"string_test: equal positive case failed\00"
@.str.54 = private unnamed_addr constant [40 x i8] c"string_test: equal negative case failed\00"
@.str.55 = private unnamed_addr alias [7 x i8], [7 x i8]* bitcast (i8* getelementptr inbounds ([12 x i8], [12 x i8]* @.str.56, i64 0, i64 5) to [7 x i8]*)
@.str.56 = private unnamed_addr constant [12 x i8] c"hello world\00"
@.str.57 = private unnamed_addr constant [34 x i8] c"string_test: concat length failed\00"
@.str.58 = private unnamed_addr constant [35 x i8] c"string_test: concat content failed\00"
@.str.59 = private unnamed_addr constant [20 x i8] c"string_utils_test: \00"
@.str.60 = private unnamed_addr constant [5 x i8] c"test\00"
@.str.61 = private unnamed_addr constant [36 x i8] c"string_utils_test: c_str_len failed\00"
@.str.62 = private unnamed_addr alias [1 x i8], [1 x i8]* bitcast (i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.0, i64 0, i64 2) to [1 x i8]*)
@.str.63 = private unnamed_addr constant [42 x i8] c"string_utils_test: c_str_len empty failed\00"
@.str.64 = private unnamed_addr constant [39 x i8] c"string_utils_test: is_ascii_num failed\00"
@.str.65 = private unnamed_addr constant [40 x i8] c"string_utils_test: is_ascii_char failed\00"
@.str.66 = private unnamed_addr constant [39 x i8] c"string_utils_test: is_ascii_hex failed\00"
@.str.67 = private unnamed_addr constant [3 x i8] c"ac\00"
@.str.68 = private unnamed_addr constant [2 x i8] c"b\00"
@.str.69 = private unnamed_addr constant [4 x i8] c"abc\00"
@.str.70 = private unnamed_addr constant [33 x i8] c"string_utils_test: insert failed\00"
@.str.71 = private unnamed_addr constant [11 x i8] c"mem_test: \00"
@.str.72 = private unnamed_addr constant [24 x i8] c"mem_test: malloc failed\00"
@.str.73 = private unnamed_addr constant [35 x i8] c"mem_test: fill verification failed\00"
@.str.74 = private unnamed_addr constant [40 x i8] c"mem_test: zero_fill verification failed\00"
@.str.75 = private unnamed_addr constant [33 x i8] c"mem_test: malloc for copy failed\00"
@.str.76 = private unnamed_addr constant [35 x i8] c"mem_test: copy verification failed\00"
@.str.77 = private unnamed_addr constant [14 x i8] c"Out of memory\00"
@.str.78 = private unnamed_addr constant [17 x i8] c"File not found: \00"
@.str.79 = private unnamed_addr constant [17 x i8] c"File read failed\00"
@.str.80 = private unnamed_addr constant [15 x i8] c"Realloc failed\00"
@yt = internal global [43 x i32] zeroinitializer
define i32 @main(){
entry:
	%v0 = alloca %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>"; var: y
	%tmp0 = getelementptr inbounds [43 x i32], [43 x i32]* @yt, i32 0, i64 42
	store i32 9999000, i32* %tmp0
	%tmp1 = call %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>" @"ax<i32>"()
	store %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>" %tmp1, %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>"* %v0
	%tmp2 = getelementptr inbounds %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>", %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>"* %v0, i32 0, i32 1
	%tmp3 = getelementptr inbounds %"struct.Pair<i8, %struct.string.String>", %"struct.Pair<i8, %struct.string.String>"* %tmp2, i32 0, i32 0
	%tmp4 = load i8, i8* %tmp3
	%tmp5 = sext i8 %tmp4 to i64
	call void @console.println_i64(i64 %tmp5)
	call void @console.println_f64(double 0x40DEADDD3B80D02E)
	call void @console.println_i64(i64 31415)
	call void @console.println_i64(i64 4674364628954828846)
	%tmp6 = add i64 4674364628954828846, 123123123123
	%tmp7 = bitcast i64 %tmp6 to double
	call void @console.println_f64(double %tmp7)
	call void @basic_functions()
	%tmp8 = call %"struct.test.QPair<i64, i64>" @xq()
	%tmp9 = ptrtoint %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>" ()* @"ax<i32>" to i64
	%tmp10 = ptrtoint i32 ()* @main to i64
	%tmp11 = sub i64 %tmp9, %tmp10
	%tmp12 = trunc i64 %tmp11 to i32
	%tmp13 = getelementptr inbounds [43 x i32], [43 x i32]* @yt, i32 0, i64 42
	%tmp14 = load i32, i32* %tmp13
	%tmp15 = add i32 %tmp12, %tmp14
	br label %func_exit
	unreachable
func_exit:
; Variable temp is out.
; Variable y is out.
	%final_ret = phi i32 [ %tmp15, %entry ]
	ret i32 %final_ret
}
define void @console.println_f64(double %n){
entry:
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
	%tmp0 = fcmp olt double %n, 0x0
	br i1 %tmp0, label %then0, label %endif0
then0:
	call void @console.print_char(i8 45)
	%tmp1 = load double, double* %v0
	%tmp2 = fsub double 0x0, %tmp1
	store double %tmp2, double* %v0
	br label %endif0
	br label %endif0
endif0:
	store double 0x3FE0000000000000, double* %v1
	store i32 0, i32* %v2
	br label %loop_body1
loop_body1:
	%tmp3 = load i32, i32* %v2
	%tmp4 = icmp sge i32 %tmp3, 6
	br i1 %tmp4, label %then2, label %endif2
then2:
	br label %loop_body1_exit
	br label %endif2
	br label %endif2
endif2:
	%tmp5 = load double, double* %v1
	%tmp6 = fdiv double %tmp5, 0x4024000000000000
	store double %tmp6, double* %v1
	%tmp7 = load i32, i32* %v2
	%tmp8 = add i32 %tmp7, 1
	store i32 %tmp8, i32* %v2
	br label %loop_body1
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
	br label %loop_body4
loop_body4:
	%tmp19 = load i8*, i8** %v4
	%tmp20 = load i32, i32* %v5
	%tmp21 = getelementptr inbounds i8, i8* %tmp19, i32 %tmp20
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
	%tmp31 = icmp eq i64 %tmp30, 0
	br i1 %tmp31, label %then5, label %endif5
then5:
	br label %loop_body4_exit
	br label %endif5
	br label %endif5
endif5:
	br label %loop_body4
loop_body4_exit:
	%tmp32 = load i8*, i8** %v4
	%tmp33 = load i32, i32* %v5
	%tmp34 = add i32 %tmp33, 1
	%tmp35 = getelementptr inbounds i8, i8* %tmp32, i32 %tmp34
	store i8* %tmp35, i8** %v7
	%tmp36 = trunc i64 20 to i32
	%tmp37 = load i32, i32* %v5
	%tmp38 = sub i32 %tmp36, %tmp37
	store i32 %tmp38, i32* %v8
	%tmp39 = load i8*, i8** %v7
	%tmp40 = load i32, i32* %v8
	call void @console.write(i8* %tmp39, i32 %tmp40)
	br label %endif3
endif3:
	call void @console.print_char(i8 46)
	store i32 0, i32* %v9
	br label %loop_body6
loop_body6:
	%tmp41 = load i32, i32* %v9
	%tmp42 = icmp sge i32 %tmp41, 6
	br i1 %tmp42, label %then7, label %endif7
then7:
	br label %loop_body6_exit
	br label %endif7
	br label %endif7
endif7:
	%tmp43 = load double, double* %v3
	%tmp44 = fmul double %tmp43, 0x4024000000000000
	store double %tmp44, double* %v3
	%tmp45 = load double, double* %v3
	%tmp46 = fptoui double %tmp45 to i64
	store i64 %tmp46, i64* %v10
	%tmp47 = load i64, i64* %v10
	%tmp48 = trunc i64 %tmp47 to i8
	%tmp49 = add i8 %tmp48, 48
	call void @console.print_char(i8 %tmp49)
	%tmp50 = load double, double* %v3
	%tmp51 = load i64, i64* %v10
	%tmp52 = uitofp i64 %tmp51 to double
	%tmp53 = fsub double %tmp50, %tmp52
	store double %tmp53, double* %v3
	%tmp54 = load i32, i32* %v9
	%tmp55 = add i32 %tmp54, 1
	store i32 %tmp55, i32* %v9
	br label %loop_body6
loop_body6_exit:
	call void @console.print_char(i8 10)
	br label %func_exit
func_exit:
	ret void
}
define void @console.println_i64(i64 %n){
entry:
	%tmp0 = icmp sge i64 %n, 0
	br i1 %tmp0, label %then8, label %else8
then8:
	call void @console.println_u64(i64 %n)
	br label %endif8
else8:
	call void @console.print_char(i8 45)
	%tmp1 = sub i64 0, %n
	call void @console.println_u64(i64 %tmp1)
	br label %endif8
endif8:
	br label %func_exit
func_exit:
	ret void
}
define i32 @_fltused(){
entry:
	br label %func_exit
	unreachable
func_exit:
	%final_ret = phi i32 [ 0, %entry ]
	ret i32 %final_ret
}
define void @__chkstk(){
entry:
	call void asm sideeffect inteldialect "push rcx
         push rax
         cmp rax, 4096
         jb .end
         
         lea r10, [rsp + 24]
         
         .probe_loop:
         sub r10, 4096
         test [r10], r10
         sub rax, 4096
         cmp rax, 4096
         ja .probe_loop
         
         .end:
         pop rax
         pop rcx", "~{flags}"()
	br label %func_exit
func_exit:
	ret void
}
define %"struct.test.QPair<i64, i64>" @xq(){
entry:
	%tmp0 = call %"struct.test.QPair<i64, i64>" @test.geg()
	br label %func_exit
	unreachable
func_exit:
	%final_ret = phi %"struct.test.QPair<i64, i64>" [ %tmp0, %entry ]
	ret %"struct.test.QPair<i64, i64>" %final_ret
}
define void @basic_functions(){
entry:
	call i32 @AllocConsole()
	call void @tests.run()
	call void @window.start()
	call i32 @FreeConsole()
	br label %func_exit
func_exit:
	ret void
}
define %"struct.test.QPair<i64, i64>" @test.geg(){
entry:
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
	br label %func_exit
	unreachable
func_exit:
; Variable temp is out.
	%final_ret = phi %"struct.test.QPair<i64, i64>" [ %tmp8, %entry ]
	ret %"struct.test.QPair<i64, i64>" %final_ret
}
define void @console.println_u64(i64 %n){
entry:
	%v0 = alloca i32; var: i
	%v1 = alloca i64; var: mut_n
	%tmp0 = alloca i8, i64 22
	store i32 20, i32* %v0
	%tmp1 = icmp eq i64 %n, 0
	br i1 %tmp1, label %then9, label %endif9
then9:
	call void @console.write(i8* @.str.0, i32 2)
	br label %func_exit
	br label %endif9
	br label %endif9
endif9:
	store i64 %n, i64* %v1
	br label %loop_body10
loop_body10:
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
	%tmp13 = icmp eq i64 %tmp12, 0
	br i1 %tmp13, label %then11, label %endif11
then11:
	br label %loop_body10_exit
	br label %endif11
	br label %endif11
endif11:
	br label %loop_body10
loop_body10_exit:
	%tmp14 = getelementptr inbounds i8, i8* %tmp0, i64 21
	store i8 10, i8* %tmp14
	%tmp15 = load i32, i32* %v0
	%tmp16 = add i32 %tmp15, 1
	%tmp17 = getelementptr inbounds i8, i8* %tmp0, i32 %tmp16
	%tmp18 = trunc i64 21 to i32
	%tmp19 = load i32, i32* %v0
	%tmp20 = sub i32 %tmp18, %tmp19
	call void @console.write(i8* %tmp17, i32 %tmp20)
	br label %func_exit
func_exit:
	ret void
}
define void @console.print_char(i8 %n){
entry:
	%v0 = alloca i8; var: b
	store i8 %n, i8* %v0
	call void @console.write(i8* %v0, i32 1)
	br label %func_exit
func_exit:
	ret void
}
define void @console.write(i8* %buffer, i32 %len){
entry:
	%v0 = alloca i32; var: chars_written
	%tmp0 = call i8* @console.get_stdout()
	call i32 @WriteConsoleA(i8* %tmp0, i8* %buffer, i32 %len, i32* %v0, i8* null)
	%tmp1 = load i32, i32* %v0
	%tmp2 = icmp ne i32 %len, %tmp1
	br i1 %tmp2, label %then12, label %endif12
then12:
	call void @ExitProcess(i32 -2)
	br label %endif12
	br label %endif12
endif12:
	br label %func_exit
func_exit:
	ret void
}
define void @tests.run(){
entry:
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
	call void @console.write(i8* @.str.1, i32 19)
	call void @console.println_i64(i64 %tmp2)
	br label %func_exit
func_exit:
	ret void
}
define void @window.start(){
entry:
	%v0 = alloca %struct.window.WNDCLASSEXA; var: wc
	%v1 = alloca %struct.window.MSG; var: msg
	%tmp0 = call i8* @GetModuleHandleA(i8* null)
	%tmp1 = call i1 @window.is_null(i8* %tmp0)
	br i1 %tmp1, label %then13, label %endif13
then13:
	call void @process.throw(i8* @.str.2)
	br label %endif13
	br label %endif13
endif13:
	%tmp2 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v0, i32 0, i32 0
	store i32 80, i32* %tmp2
	%tmp3 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v0, i32 0, i32 1
	%tmp4 = or i32 2, 1
	store i32 %tmp4, i32* %tmp3
	%tmp5 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v0, i32 0, i32 2
	store i64 (i8*, i32, i64, i64)* @window.WindowProc, i64 (i8*, i32, i64, i64)** %tmp5
	%tmp6 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v0, i32 0, i32 3
	store i32 0, i32* %tmp6
	%tmp7 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v0, i32 0, i32 4
	store i32 0, i32* %tmp7
	%tmp8 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v0, i32 0, i32 5
	store i8* %tmp0, i8** %tmp8
	%tmp9 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v0, i32 0, i32 6
	store i8* null, i8** %tmp9
	%tmp10 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v0, i32 0, i32 7
	store i8* null, i8** %tmp10
	%tmp11 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v0, i32 0, i32 8
	%tmp12 = add i32 5, 1
	%tmp13 = sext i32 %tmp12 to i64
	%tmp14 = inttoptr i64 %tmp13 to i8*
	store i8* %tmp14, i8** %tmp11
	%tmp15 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v0, i32 0, i32 9
	store i8* null, i8** %tmp15
	%tmp16 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v0, i32 0, i32 10
	store i8* @.str.3, i8** %tmp16
	%tmp17 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v0, i32 0, i32 11
	store i8* null, i8** %tmp17
	%tmp18 = call i16 @RegisterClassExA(%struct.window.WNDCLASSEXA* %v0)
	%tmp19 = icmp eq i16 %tmp18, 0
	br i1 %tmp19, label %then14, label %endif14
then14:
	call void @process.throw(i8* @.str.4)
	br label %endif14
	br label %endif14
endif14:
	%tmp20 = call i8* @CreateWindowExA(i32 0, i8* @.str.3, i8* @.str.5, i32 13565952, i32 2147483648, i32 2147483648, i32 800, i32 600, i8* null, i8* null, i8* %tmp0, i8* null)
	%tmp21 = call i1 @window.is_null(i8* %tmp20)
	br i1 %tmp21, label %then15, label %endif15
then15:
	call void @process.throw(i8* @.str.6)
	br label %endif15
	br label %endif15
endif15:
	call i32 @ShowWindow(i8* %tmp20, i32 5)
	br label %loop_body16
loop_body16:
	%tmp22 = call i32 @GetMessageA(%struct.window.MSG* %v1, i8* null, i32 0, i32 0)
	%tmp23 = icmp sle i32 %tmp22, 0
	br i1 %tmp23, label %then17, label %endif17
then17:
	br label %loop_body16_exit
	br label %endif17
	br label %endif17
endif17:
	call i32 @TranslateMessage(%struct.window.MSG* %v1)
	call i64 @DispatchMessageA(%struct.window.MSG* %v1)
	br label %loop_body16
loop_body16_exit:
	br label %func_exit
func_exit:
; Variable msg is out.
; Variable wc is out.
	ret void
}
define void @process.throw(i8* %exception){
entry:
	%tmp0 = call i32 @string_utils.c_str_len(i8* %exception)
	call i32 @AllocConsole()
	%tmp1 = call i8* @GetStdHandle(i32 -11)
	call void @console.writeln(i8* @.str.7, i32 11)
	call void @console.writeln(i8* %exception, i32 %tmp0)
	call void @ExitProcess(i32 -1)
	br label %func_exit
func_exit:
	ret void
}
define i64 @mem.get_total_allocated_memory_external(){
entry:
	%v0 = alloca i64; var: total_size
	%v1 = alloca %struct.mem.PROCESS_HEAP_ENTRY; var: entry
	%tmp0 = call i32* @GetProcessHeap()
	store i64 0, i64* %v0
	%tmp1 = getelementptr inbounds %struct.mem.PROCESS_HEAP_ENTRY, %struct.mem.PROCESS_HEAP_ENTRY* %v1, i32 0, i32 0
	store i8* null, i8** %tmp1
	%tmp2 = call i32 @HeapLock(i32* %tmp0)
	%tmp3 = icmp eq i32 %tmp2, 0
	br i1 %tmp3, label %then18, label %endif18
then18:
	call void @process.throw(i8* @.str.8)
	br label %endif18
	br label %endif18
endif18:
	br label %loop_body19
loop_body19:
	%tmp4 = call i32 @HeapWalk(i32* %tmp0, %struct.mem.PROCESS_HEAP_ENTRY* %v1)
	%tmp5 = icmp eq i32 %tmp4, 0
	br i1 %tmp5, label %then20, label %endif20
then20:
	br label %loop_body19_exit
	br label %endif20
	br label %endif20
endif20:
	%tmp6 = getelementptr inbounds %struct.mem.PROCESS_HEAP_ENTRY, %struct.mem.PROCESS_HEAP_ENTRY* %v1, i32 0, i32 4
	%tmp7 = load i16, i16* %tmp6
	%tmp8 = and i16 %tmp7, 4
	%tmp9 = icmp ne i16 %tmp8, 0
	br i1 %tmp9, label %then21, label %endif21
then21:
	%tmp10 = load i64, i64* %v0
	%tmp11 = getelementptr inbounds %struct.mem.PROCESS_HEAP_ENTRY, %struct.mem.PROCESS_HEAP_ENTRY* %v1, i32 0, i32 1
	%tmp12 = load i32, i32* %tmp11
	%tmp13 = zext i32 %tmp12 to i64
	%tmp14 = add i64 %tmp10, %tmp13
	store i64 %tmp14, i64* %v0
	br label %endif21
	br label %endif21
endif21:
	br label %loop_body19
loop_body19_exit:
	call i32 @HeapUnlock(i32* %tmp0)
	%tmp15 = load i64, i64* %v0
	br label %func_exit
	unreachable
func_exit:
; Variable entry is out.
	%final_ret = phi i64 [ %tmp15, %loop_body19_exit ]
	ret i64 %final_ret
}
define i8* @console.get_stdout(){
entry:
	%v0 = alloca i8*; var: stdout_handle
	%tmp0 = call i8* @GetStdHandle(i32 -11)
	store i8* %tmp0, i8** %v0
	%tmp1 = load i8*, i8** %v0
	%tmp2 = inttoptr i64 -1 to i8*
	%tmp3 = icmp eq ptr %tmp1, %tmp2
	br i1 %tmp3, label %then22, label %endif22
then22:
	call void @process.throw(i8* @.str.9)
	br label %endif22
	br label %endif22
endif22:
	%tmp4 = load i8*, i8** %v0
	br label %func_exit
	unreachable
func_exit:
	%final_ret = phi i8* [ %tmp4, %endif22 ]
	ret i8* %final_ret
}
define void @tests.funny(){
entry:
	%v0 = alloca %struct.string.String; var: file
	%v1 = alloca i32; var: iterator
	%v2 = alloca i8; var: char
	%v3 = alloca i8; var: next_char
	%v4 = alloca i32; var: index
	%v5 = alloca %"struct.vector.Vec<%struct.string.String>"; var: data
	%v6 = alloca %"struct.vector.Vec<i64>"; var: tokens
	%tmp17 = alloca i1
	%tmp21 = alloca i1
	%tmp25 = alloca i1
	%tmp45 = alloca i1
	%tmp54 = alloca i1
	%v7 = alloca %struct.string.String; var: temp_string
	%tmp76 = alloca i1
	%v8 = alloca %struct.string.String; var: temp_string
	%v9 = alloca %struct.string.String; var: temp_string
	%v10 = alloca i32; var: i
	%tmp0 = call i32 @fs.create_file(i8* @.str.10)
	%tmp1 = icmp eq i32 %tmp0, 1
	br i1 %tmp1, label %then23, label %endif23
then23:
	call i32 @fs.delete_file(i8* @.str.10)
	br label %func_exit
	br label %endif23
	br label %endif23
endif23:
	%tmp2 = call %struct.string.String @fs.read_full_file_as_string(i8* @.str.10)
	store %struct.string.String %tmp2, %struct.string.String* %v0
	store i32 0, i32* %v1
	%tmp3 = call %"struct.vector.Vec<%struct.string.String>" @"vector.new<%struct.string.String>"()
	store %"struct.vector.Vec<%struct.string.String>" %tmp3, %"struct.vector.Vec<%struct.string.String>"* %v5
	%tmp4 = call %"struct.vector.Vec<i64>" @"vector.new<i64>"()
	store %"struct.vector.Vec<i64>" %tmp4, %"struct.vector.Vec<i64>"* %v6
	br label %loop_body24
loop_body24:
	%tmp5 = load i32, i32* %v1
	%tmp6 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	%tmp7 = load i32, i32* %tmp6
	%tmp8 = icmp sge i32 %tmp5, %tmp7
	br i1 %tmp8, label %then25, label %endif25
then25:
	br label %loop_body24_exit
	br label %endif25
	br label %endif25
endif25:
	%tmp9 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
	%tmp10 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
	%tmp11 = load i8*, i8** %tmp10
	%tmp12 = load i32, i32* %v1
	%tmp13 = getelementptr inbounds i8, i8* %tmp11, i32 %tmp12
	%tmp14 = load i8, i8* %tmp13
	store i8 %tmp14, i8* %v2
	%tmp15 = load i8, i8* %v2
	%tmp16 = icmp eq i8 %tmp15, 32
	store i1 %tmp16, i1* %tmp17
	br i1 %tmp16, label %logic_end_26, label %logic_rhs_26
logic_rhs_26:
	%tmp18 = load i8, i8* %v2
	%tmp19 = icmp eq i8 %tmp18, 9
	store i1 %tmp19, i1* %tmp17
	br label %logic_end_26
logic_end_26:
	%tmp20 = load i1, i1* %tmp17
	store i1 %tmp20, i1* %tmp21
	br i1 %tmp20, label %logic_end_27, label %logic_rhs_27
logic_rhs_27:
	%tmp22 = load i8, i8* %v2
	%tmp23 = icmp eq i8 %tmp22, 13
	store i1 %tmp23, i1* %tmp21
	br label %logic_end_27
logic_end_27:
	%tmp24 = load i1, i1* %tmp21
	store i1 %tmp24, i1* %tmp25
	br i1 %tmp24, label %logic_end_28, label %logic_rhs_28
logic_rhs_28:
	%tmp26 = load i8, i8* %v2
	%tmp27 = icmp eq i8 %tmp26, 10
	store i1 %tmp27, i1* %tmp25
	br label %logic_end_28
logic_end_28:
	%tmp28 = load i1, i1* %tmp25
	br i1 %tmp28, label %then29, label %endif29
then29:
	%tmp29 = load i32, i32* %v1
	%tmp30 = add i32 %tmp29, 1
	store i32 %tmp30, i32* %v1
	br label %loop_body24
	br label %endif29
	br label %endif29
endif29:
	%tmp31 = load i32, i32* %v1
	%tmp32 = add i32 %tmp31, 1
	%tmp33 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	%tmp34 = load i32, i32* %tmp33
	%tmp35 = icmp slt i32 %tmp32, %tmp34
	br i1 %tmp35, label %then30, label %else30
then30:
	%tmp36 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
	%tmp37 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
	%tmp38 = load i8*, i8** %tmp37
	%tmp39 = load i32, i32* %v1
	%tmp40 = add i32 %tmp39, 1
	%tmp41 = getelementptr inbounds i8, i8* %tmp38, i32 %tmp40
	%tmp42 = load i8, i8* %tmp41
	store i8 %tmp42, i8* %v3
	br label %endif30
else30:
	store i8 0, i8* %v3
	br label %endif30
endif30:
	%tmp43 = load i8, i8* %v2
	%tmp44 = icmp eq i8 %tmp43, 47
	store i1 %tmp44, i1* %tmp45
	br i1 %tmp44, label %logic_rhs_31, label %logic_end_31
logic_rhs_31:
	%tmp46 = load i8, i8* %v3
	%tmp47 = icmp eq i8 %tmp46, 47
	store i1 %tmp47, i1* %tmp45
	br label %logic_end_31
logic_end_31:
	%tmp48 = load i1, i1* %tmp45
	br i1 %tmp48, label %then32, label %endif32
then32:
	call void @tests.consume_while(%struct.string.String* %v0, i32* %v1, i1 (i8)* @tests.not_new_line)
	br label %loop_body24
	br label %endif32
	br label %endif32
endif32:
	%tmp49 = load i8, i8* %v2
	%tmp50 = call i1 @string_utils.is_ascii_num(i8 %tmp49)
	br i1 %tmp50, label %then33, label %endif33
then33:
	%tmp51 = load i32, i32* %v1
	store i32 %tmp51, i32* %v4
	%tmp52 = load i8, i8* %v3
	%tmp53 = icmp eq i8 %tmp52, 120
	store i1 %tmp53, i1* %tmp54
	br i1 %tmp53, label %logic_end_34, label %logic_rhs_34
logic_rhs_34:
	%tmp55 = load i8, i8* %v3
	%tmp56 = icmp eq i8 %tmp55, 98
	store i1 %tmp56, i1* %tmp54
	br label %logic_end_34
logic_end_34:
	%tmp57 = load i1, i1* %tmp54
	br i1 %tmp57, label %then35, label %endif35
then35:
	%tmp58 = load i32, i32* %v1
	%tmp59 = add i32 %tmp58, 2
	store i32 %tmp59, i32* %v1
	br label %endif35
	br label %endif35
endif35:
	call void @tests.consume_while(%struct.string.String* %v0, i32* %v1, i1 (i8)* @tests.is_valid_number_token)
	%tmp60 = load i32, i32* %v1
	%tmp61 = load i32, i32* %v4
	%tmp62 = sub i32 %tmp60, %tmp61
	%tmp63 = call %struct.string.String @string.with_size(i32 %tmp62)
	store %struct.string.String %tmp63, %struct.string.String* %v7
	%tmp64 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
	%tmp65 = load i8*, i8** %tmp64
	%tmp66 = load i32, i32* %v4
	%tmp67 = getelementptr inbounds i8, i8* %tmp65, i32 %tmp66
	%tmp68 = getelementptr inbounds %struct.string.String, %struct.string.String* %v7, i32 0, i32 0
	%tmp69 = load i8*, i8** %tmp68
	%tmp70 = getelementptr inbounds %struct.string.String, %struct.string.String* %v7, i32 0, i32 1
	%tmp71 = load i32, i32* %tmp70
	%tmp72 = sext i32 %tmp71 to i64
	call void @mem.copy(i8* %tmp67, i8* %tmp69, i64 %tmp72)
	%tmp73 = load %struct.string.String, %struct.string.String* %v7
	call void @"vector.push<%struct.string.String>"(%"struct.vector.Vec<%struct.string.String>"* %v5, %struct.string.String %tmp73)
	br label %loop_body24
; Variable temp_string is out.
	br label %endif33
	br label %endif33
endif33:
	%tmp74 = load i8, i8* %v2
	%tmp75 = call i1 @string_utils.is_ascii_char(i8 %tmp74)
	store i1 %tmp75, i1* %tmp76
	br i1 %tmp75, label %logic_end_36, label %logic_rhs_36
logic_rhs_36:
	%tmp77 = load i8, i8* %v2
	%tmp78 = icmp eq i8 %tmp77, 95
	store i1 %tmp78, i1* %tmp76
	br label %logic_end_36
logic_end_36:
	%tmp79 = load i1, i1* %tmp76
	br i1 %tmp79, label %then37, label %endif37
then37:
	%tmp80 = load i32, i32* %v1
	store i32 %tmp80, i32* %v4
	call void @tests.consume_while(%struct.string.String* %v0, i32* %v1, i1 (i8)* @tests.valid_name_token)
	%tmp81 = load i32, i32* %v1
	%tmp82 = load i32, i32* %v4
	%tmp83 = sub i32 %tmp81, %tmp82
	%tmp84 = call %struct.string.String @string.with_size(i32 %tmp83)
	store %struct.string.String %tmp84, %struct.string.String* %v8
	%tmp85 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
	%tmp86 = load i8*, i8** %tmp85
	%tmp87 = load i32, i32* %v4
	%tmp88 = getelementptr inbounds i8, i8* %tmp86, i32 %tmp87
	%tmp89 = getelementptr inbounds %struct.string.String, %struct.string.String* %v8, i32 0, i32 0
	%tmp90 = load i8*, i8** %tmp89
	%tmp91 = getelementptr inbounds %struct.string.String, %struct.string.String* %v8, i32 0, i32 1
	%tmp92 = load i32, i32* %tmp91
	%tmp93 = sext i32 %tmp92 to i64
	call void @mem.copy(i8* %tmp88, i8* %tmp90, i64 %tmp93)
	%tmp94 = load %struct.string.String, %struct.string.String* %v8
	call void @"vector.push<%struct.string.String>"(%"struct.vector.Vec<%struct.string.String>"* %v5, %struct.string.String %tmp94)
	br label %loop_body24
; Variable temp_string is out.
	br label %endif37
	br label %endif37
endif37:
	%tmp95 = load i8, i8* %v2
	%tmp96 = icmp eq i8 %tmp95, 34
	br i1 %tmp96, label %then38, label %endif38
then38:
	%tmp97 = load i32, i32* %v1
	store i32 %tmp97, i32* %v4
	br label %loop_body39
loop_body39:
	%tmp98 = load i32, i32* %v1
	%tmp99 = add i32 %tmp98, 1
	store i32 %tmp99, i32* %v1
	%tmp100 = load i32, i32* %v1
	%tmp101 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	%tmp102 = load i32, i32* %tmp101
	%tmp103 = icmp sge i32 %tmp100, %tmp102
	br i1 %tmp103, label %then40, label %endif40
then40:
	br label %loop_body39_exit
	br label %endif40
	br label %endif40
endif40:
	%tmp104 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
	%tmp105 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
	%tmp106 = load i8*, i8** %tmp105
	%tmp107 = load i32, i32* %v1
	%tmp108 = getelementptr inbounds i8, i8* %tmp106, i32 %tmp107
	%tmp109 = load i8, i8* %tmp108
	%tmp110 = icmp eq i8 %tmp109, 34
	br i1 %tmp110, label %then41, label %endif41
then41:
	%tmp111 = load i32, i32* %v1
	%tmp112 = add i32 %tmp111, 1
	store i32 %tmp112, i32* %v1
	br label %loop_body39_exit
	br label %endif41
	br label %endif41
endif41:
	br label %loop_body39
loop_body39_exit:
	%tmp113 = load i32, i32* %v1
	%tmp114 = load i32, i32* %v4
	%tmp115 = sub i32 %tmp113, %tmp114
	%tmp116 = call %struct.string.String @string.with_size(i32 %tmp115)
	store %struct.string.String %tmp116, %struct.string.String* %v9
	%tmp117 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
	%tmp118 = load i8*, i8** %tmp117
	%tmp119 = load i32, i32* %v4
	%tmp120 = getelementptr inbounds i8, i8* %tmp118, i32 %tmp119
	%tmp121 = getelementptr inbounds %struct.string.String, %struct.string.String* %v9, i32 0, i32 0
	%tmp122 = load i8*, i8** %tmp121
	%tmp123 = getelementptr inbounds %struct.string.String, %struct.string.String* %v9, i32 0, i32 1
	%tmp124 = load i32, i32* %tmp123
	%tmp125 = sext i32 %tmp124 to i64
	call void @mem.copy(i8* %tmp120, i8* %tmp122, i64 %tmp125)
	%tmp126 = load %struct.string.String, %struct.string.String* %v9
	call void @"vector.push<%struct.string.String>"(%"struct.vector.Vec<%struct.string.String>"* %v5, %struct.string.String %tmp126)
	br label %loop_body24
; Variable temp_string is out.
	br label %endif38
	br label %endif38
endif38:
	%tmp127 = load i8, i8* %v2
	%tmp128 = icmp eq i8 %tmp127, 39
	br i1 %tmp128, label %then42, label %endif42
then42:
	%tmp129 = load i32, i32* %v1
	%tmp130 = add i32 %tmp129, 1
	store i32 %tmp130, i32* %v1
	br label %loop_body24
	br label %endif42
	br label %endif42
endif42:
	%tmp131 = load i8, i8* %v2
	%tmp132 = icmp eq i8 %tmp131, 40
	br i1 %tmp132, label %then43, label %endif43
then43:
	%tmp133 = load i32, i32* %v1
	%tmp134 = add i32 %tmp133, 1
	store i32 %tmp134, i32* %v1
	br label %loop_body24
	br label %endif43
	br label %endif43
endif43:
	%tmp135 = load i8, i8* %v2
	%tmp136 = icmp eq i8 %tmp135, 41
	br i1 %tmp136, label %then44, label %endif44
then44:
	%tmp137 = load i32, i32* %v1
	%tmp138 = add i32 %tmp137, 1
	store i32 %tmp138, i32* %v1
	br label %loop_body24
	br label %endif44
	br label %endif44
endif44:
	%tmp139 = load i8, i8* %v2
	%tmp140 = icmp eq i8 %tmp139, 123
	br i1 %tmp140, label %then45, label %endif45
then45:
	%tmp141 = load i32, i32* %v1
	%tmp142 = add i32 %tmp141, 1
	store i32 %tmp142, i32* %v1
	br label %loop_body24
	br label %endif45
	br label %endif45
endif45:
	%tmp143 = load i8, i8* %v2
	%tmp144 = icmp eq i8 %tmp143, 125
	br i1 %tmp144, label %then46, label %endif46
then46:
	%tmp145 = load i32, i32* %v1
	%tmp146 = add i32 %tmp145, 1
	store i32 %tmp146, i32* %v1
	br label %loop_body24
	br label %endif46
	br label %endif46
endif46:
	%tmp147 = load i8, i8* %v2
	%tmp148 = icmp eq i8 %tmp147, 91
	br i1 %tmp148, label %then47, label %endif47
then47:
	%tmp149 = load i32, i32* %v1
	%tmp150 = add i32 %tmp149, 1
	store i32 %tmp150, i32* %v1
	br label %loop_body24
	br label %endif47
	br label %endif47
endif47:
	%tmp151 = load i8, i8* %v2
	%tmp152 = icmp eq i8 %tmp151, 93
	br i1 %tmp152, label %then48, label %endif48
then48:
	%tmp153 = load i32, i32* %v1
	%tmp154 = add i32 %tmp153, 1
	store i32 %tmp154, i32* %v1
	br label %loop_body24
	br label %endif48
	br label %endif48
endif48:
	%tmp155 = load i8, i8* %v2
	%tmp156 = icmp eq i8 %tmp155, 61
	br i1 %tmp156, label %then49, label %endif49
then49:
	%tmp157 = load i8, i8* %v3
	%tmp158 = icmp eq i8 %tmp157, 61
	br i1 %tmp158, label %then50, label %endif50
then50:
	%tmp159 = load i32, i32* %v1
	%tmp160 = add i32 %tmp159, 2
	store i32 %tmp160, i32* %v1
	br label %loop_body24
	br label %endif50
	br label %endif50
endif50:
	%tmp161 = load i32, i32* %v1
	%tmp162 = add i32 %tmp161, 1
	store i32 %tmp162, i32* %v1
	br label %loop_body24
	br label %endif49
	br label %endif49
endif49:
	%tmp163 = load i8, i8* %v2
	%tmp164 = icmp eq i8 %tmp163, 58
	br i1 %tmp164, label %then51, label %endif51
then51:
	%tmp165 = load i8, i8* %v3
	%tmp166 = icmp eq i8 %tmp165, 58
	br i1 %tmp166, label %then52, label %endif52
then52:
	%tmp167 = load i32, i32* %v1
	%tmp168 = add i32 %tmp167, 2
	store i32 %tmp168, i32* %v1
	br label %loop_body24
	br label %endif52
	br label %endif52
endif52:
	%tmp169 = load i32, i32* %v1
	%tmp170 = add i32 %tmp169, 1
	store i32 %tmp170, i32* %v1
	br label %loop_body24
	br label %endif51
	br label %endif51
endif51:
	%tmp171 = load i8, i8* %v2
	%tmp172 = icmp eq i8 %tmp171, 124
	br i1 %tmp172, label %then53, label %endif53
then53:
	%tmp173 = load i8, i8* %v3
	%tmp174 = icmp eq i8 %tmp173, 124
	br i1 %tmp174, label %then54, label %endif54
then54:
	%tmp175 = load i32, i32* %v1
	%tmp176 = add i32 %tmp175, 2
	store i32 %tmp176, i32* %v1
	br label %loop_body24
	br label %endif54
	br label %endif54
endif54:
	%tmp177 = load i32, i32* %v1
	%tmp178 = add i32 %tmp177, 1
	store i32 %tmp178, i32* %v1
	br label %loop_body24
	br label %endif53
	br label %endif53
endif53:
	%tmp179 = load i8, i8* %v2
	%tmp180 = icmp eq i8 %tmp179, 38
	br i1 %tmp180, label %then55, label %endif55
then55:
	%tmp181 = load i8, i8* %v3
	%tmp182 = icmp eq i8 %tmp181, 38
	br i1 %tmp182, label %then56, label %endif56
then56:
	%tmp183 = load i32, i32* %v1
	%tmp184 = add i32 %tmp183, 2
	store i32 %tmp184, i32* %v1
	br label %loop_body24
	br label %endif56
	br label %endif56
endif56:
	%tmp185 = load i32, i32* %v1
	%tmp186 = add i32 %tmp185, 1
	store i32 %tmp186, i32* %v1
	br label %loop_body24
	br label %endif55
	br label %endif55
endif55:
	%tmp187 = load i8, i8* %v2
	%tmp188 = icmp eq i8 %tmp187, 62
	br i1 %tmp188, label %then57, label %endif57
then57:
	%tmp189 = load i8, i8* %v3
	%tmp190 = icmp eq i8 %tmp189, 61
	br i1 %tmp190, label %then58, label %endif58
then58:
	%tmp191 = load i32, i32* %v1
	%tmp192 = add i32 %tmp191, 2
	store i32 %tmp192, i32* %v1
	br label %loop_body24
	br label %endif58
	br label %endif58
endif58:
	%tmp193 = load i32, i32* %v1
	%tmp194 = add i32 %tmp193, 1
	store i32 %tmp194, i32* %v1
	br label %loop_body24
	br label %endif57
	br label %endif57
endif57:
	%tmp195 = load i8, i8* %v2
	%tmp196 = icmp eq i8 %tmp195, 60
	br i1 %tmp196, label %then59, label %endif59
then59:
	%tmp197 = load i8, i8* %v3
	%tmp198 = icmp eq i8 %tmp197, 61
	br i1 %tmp198, label %then60, label %endif60
then60:
	%tmp199 = load i32, i32* %v1
	%tmp200 = add i32 %tmp199, 2
	store i32 %tmp200, i32* %v1
	br label %loop_body24
	br label %endif60
	br label %endif60
endif60:
	%tmp201 = load i32, i32* %v1
	%tmp202 = add i32 %tmp201, 1
	store i32 %tmp202, i32* %v1
	br label %loop_body24
	br label %endif59
	br label %endif59
endif59:
	%tmp203 = load i8, i8* %v2
	%tmp204 = icmp eq i8 %tmp203, 35
	br i1 %tmp204, label %then61, label %endif61
then61:
	%tmp205 = load i32, i32* %v1
	%tmp206 = add i32 %tmp205, 1
	store i32 %tmp206, i32* %v1
	br label %loop_body24
	br label %endif61
	br label %endif61
endif61:
	%tmp207 = load i8, i8* %v2
	%tmp208 = icmp eq i8 %tmp207, 59
	br i1 %tmp208, label %then62, label %endif62
then62:
	%tmp209 = load i32, i32* %v1
	%tmp210 = add i32 %tmp209, 1
	store i32 %tmp210, i32* %v1
	br label %loop_body24
	br label %endif62
	br label %endif62
endif62:
	%tmp211 = load i8, i8* %v2
	%tmp212 = icmp eq i8 %tmp211, 46
	br i1 %tmp212, label %then63, label %endif63
then63:
	%tmp213 = load i32, i32* %v1
	%tmp214 = add i32 %tmp213, 1
	store i32 %tmp214, i32* %v1
	br label %loop_body24
	br label %endif63
	br label %endif63
endif63:
	%tmp215 = load i8, i8* %v2
	%tmp216 = icmp eq i8 %tmp215, 44
	br i1 %tmp216, label %then64, label %endif64
then64:
	%tmp217 = load i32, i32* %v1
	%tmp218 = add i32 %tmp217, 1
	store i32 %tmp218, i32* %v1
	br label %loop_body24
	br label %endif64
	br label %endif64
endif64:
	%tmp219 = load i8, i8* %v2
	%tmp220 = icmp eq i8 %tmp219, 43
	br i1 %tmp220, label %then65, label %endif65
then65:
	%tmp221 = load i32, i32* %v1
	%tmp222 = add i32 %tmp221, 1
	store i32 %tmp222, i32* %v1
	br label %loop_body24
	br label %endif65
	br label %endif65
endif65:
	%tmp223 = load i8, i8* %v2
	%tmp224 = icmp eq i8 %tmp223, 45
	br i1 %tmp224, label %then66, label %endif66
then66:
	%tmp225 = load i32, i32* %v1
	%tmp226 = add i32 %tmp225, 1
	store i32 %tmp226, i32* %v1
	br label %loop_body24
	br label %endif66
	br label %endif66
endif66:
	%tmp227 = load i8, i8* %v2
	%tmp228 = icmp eq i8 %tmp227, 42
	br i1 %tmp228, label %then67, label %endif67
then67:
	%tmp229 = load i32, i32* %v1
	%tmp230 = add i32 %tmp229, 1
	store i32 %tmp230, i32* %v1
	br label %loop_body24
	br label %endif67
	br label %endif67
endif67:
	%tmp231 = load i8, i8* %v2
	%tmp232 = icmp eq i8 %tmp231, 47
	br i1 %tmp232, label %then68, label %endif68
then68:
	%tmp233 = load i32, i32* %v1
	%tmp234 = add i32 %tmp233, 1
	store i32 %tmp234, i32* %v1
	br label %loop_body24
	br label %endif68
	br label %endif68
endif68:
	%tmp235 = load i8, i8* %v2
	%tmp236 = icmp eq i8 %tmp235, 37
	br i1 %tmp236, label %then69, label %endif69
then69:
	%tmp237 = load i32, i32* %v1
	%tmp238 = add i32 %tmp237, 1
	store i32 %tmp238, i32* %v1
	br label %loop_body24
	br label %endif69
	br label %endif69
endif69:
	%tmp239 = load i8, i8* %v2
	%tmp240 = icmp eq i8 %tmp239, 33
	br i1 %tmp240, label %then70, label %endif70
then70:
	%tmp241 = load i32, i32* %v1
	%tmp242 = add i32 %tmp241, 1
	store i32 %tmp242, i32* %v1
	br label %loop_body24
	br label %endif70
	br label %endif70
endif70:
	%tmp243 = load i8, i8* %v2
	%tmp244 = icmp eq i8 %tmp243, 126
	br i1 %tmp244, label %then71, label %endif71
then71:
	%tmp245 = load i32, i32* %v1
	%tmp246 = add i32 %tmp245, 1
	store i32 %tmp246, i32* %v1
	br label %loop_body24
	br label %endif71
	br label %endif71
endif71:
	%tmp247 = load i8, i8* %v2
	%tmp248 = icmp eq i8 %tmp247, 92
	br i1 %tmp248, label %then72, label %endif72
then72:
	%tmp249 = load i32, i32* %v1
	%tmp250 = add i32 %tmp249, 1
	store i32 %tmp250, i32* %v1
	br label %loop_body24
	br label %endif72
	br label %endif72
endif72:
	%tmp251 = load i8, i8* %v2
	call void @console.print_char(i8 %tmp251)
	call void @console.print_char(i8 10)
	%tmp252 = load i32, i32* %v1
	%tmp253 = add i32 %tmp252, 1
	store i32 %tmp253, i32* %v1
	br label %loop_body24
loop_body24_exit:
	store i32 0, i32* %v10
	br label %loop_body73
loop_body73:
	%tmp254 = load i32, i32* %v10
	%tmp255 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %v5, i32 0, i32 1
	%tmp256 = load i32, i32* %tmp255
	%tmp257 = icmp uge i32 %tmp254, %tmp256
	br i1 %tmp257, label %then74, label %endif74
then74:
	br label %loop_body73_exit
	br label %endif74
	br label %endif74
endif74:
	%tmp258 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %v5, i32 0, i32 0
	%tmp259 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %v5, i32 0, i32 0
	%tmp260 = load %struct.string.String*, %struct.string.String** %tmp259
	%tmp261 = load i32, i32* %v10
	%tmp262 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp260, i32 %tmp261
	call void @string.free(%struct.string.String* %tmp262)
	%tmp263 = load i32, i32* %v10
	%tmp264 = add i32 %tmp263, 1
	store i32 %tmp264, i32* %v10
	br label %loop_body73
loop_body73_exit:
	call void @"vector.free<%struct.string.String>"(%"struct.vector.Vec<%struct.string.String>"* %v5)
	call void @string.free(%struct.string.String* %v0)
	br label %func_exit
func_exit:
; Variable tokens is out.
; Variable data is out.
; Variable file is out.
	ret void
}
define void @tests.fs_test(){
entry:
	%v0 = alloca %struct.string.String; var: data
	%v1 = alloca %struct.string.String; var: env_path
	%v2 = alloca %struct.string.String; var: new_file_path
	%v3 = alloca %struct.string.String; var: read
	call void @console.write(i8* @.str.11, i32 9)
	%tmp0 = call %struct.string.String @string.from_c_string(i8* @.str.12)
	store %struct.string.String %tmp0, %struct.string.String* %v0
	%tmp1 = call %struct.string.String @process.get_executable_env_path()
	store %struct.string.String %tmp1, %struct.string.String* %v1
	%tmp2 = call %struct.string.String @string.concat_with_c_string(%struct.string.String* %v1, i8* @.str.13)
	store %struct.string.String %tmp2, %struct.string.String* %v2
	%tmp3 = getelementptr inbounds %struct.string.String, %struct.string.String* %v2, i32 0, i32 1
	%tmp4 = load i32, i32* %tmp3
	%tmp5 = add i32 %tmp4, 1
	%tmp6 = sext i32 %tmp5 to i64
	%tmp7 = alloca i8, i64 %tmp6
	call void @string.as_c_string_stalloc(%struct.string.String* %v2, i8* %tmp7)
	call i32 @fs.create_file(i8* %tmp7)
	call i32 @fs.delete_file(i8* %tmp7)
	call i32 @fs.create_file(i8* %tmp7)
	%tmp8 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
	%tmp9 = load i8*, i8** %tmp8
	%tmp10 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	%tmp11 = load i32, i32* %tmp10
	call i32 @fs.write_to_file(i8* %tmp7, i8* %tmp9, i32 %tmp11)
	%tmp12 = call %struct.string.String @fs.read_full_file_as_string(i8* %tmp7)
	store %struct.string.String %tmp12, %struct.string.String* %v3
	%tmp13 = call i1 @string.equal(%struct.string.String* %v0, %struct.string.String* %v3)
	%tmp14 = xor i1 1, %tmp13
	br i1 %tmp14, label %then75, label %endif75
then75:
	call void @process.throw(i8* @.str.14)
	br label %endif75
	br label %endif75
endif75:
	call i32 @fs.delete_file(i8* %tmp7)
	call void @string.free(%struct.string.String* %v3)
	call void @string.free(%struct.string.String* %v2)
	call void @string.free(%struct.string.String* %v1)
	call void @string.free(%struct.string.String* %v0)
	call void @console.writeln(i8* @.str.15, i32 2)
	br label %func_exit
func_exit:
; Variable read is out.
; Variable new_file_path is out.
; Variable env_path is out.
; Variable data is out.
	ret void
}
define void @tests.console_test(){
entry:
	call void @console.writeln(i8* @.str.16, i32 14)
	call void @console.writeln(i8* @.str.17, i32 25)
	call void @console.write(i8* @.str.18, i32 21)
	call void @console.println_i64(i64 12345)
	call void @console.write(i8* @.str.19, i32 22)
	call void @console.println_i64(i64 -67890)
	call void @console.write(i8* @.str.20, i32 17)
	call void @console.println_i64(i64 0)
	call void @console.write(i8* @.str.21, i32 26)
	call void @console.println_u64(i64 9876543210)
	call void @console.writeln(i8* @.str.22, i32 23)
	call void @console.writeln(i8* @.str.15, i32 2)
	br label %func_exit
func_exit:
	ret void
}
define void @tests.process_test(){
entry:
	%v0 = alloca %struct.string.String; var: full_path
	%v1 = alloca %struct.string.String; var: env_path
	call void @console.write(i8* @.str.23, i32 14)
	%tmp0 = call %struct.string.String @process.get_executable_path()
	store %struct.string.String %tmp0, %struct.string.String* %v0
	%tmp1 = call %struct.string.String @process.get_executable_env_path()
	store %struct.string.String %tmp1, %struct.string.String* %v1
	%tmp2 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	%tmp3 = load i32, i32* %tmp2
	%tmp4 = icmp sle i32 %tmp3, 0
	br i1 %tmp4, label %then76, label %endif76
then76:
	call void @process.throw(i8* @.str.24)
	br label %endif76
	br label %endif76
endif76:
	%tmp5 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 1
	%tmp6 = load i32, i32* %tmp5
	%tmp7 = icmp sle i32 %tmp6, 0
	br i1 %tmp7, label %then77, label %endif77
then77:
	call void @process.throw(i8* @.str.25)
	br label %endif77
	br label %endif77
endif77:
	%tmp8 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 1
	%tmp9 = load i32, i32* %tmp8
	%tmp10 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	%tmp11 = load i32, i32* %tmp10
	%tmp12 = icmp sge i32 %tmp9, %tmp11
	br i1 %tmp12, label %then78, label %endif78
then78:
	call void @process.throw(i8* @.str.26)
	br label %endif78
	br label %endif78
endif78:
	%tmp13 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 0
	%tmp14 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 0
	%tmp15 = load i8*, i8** %tmp14
	%tmp16 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 1
	%tmp17 = load i32, i32* %tmp16
	%tmp18 = sub i32 %tmp17, 1
	%tmp19 = getelementptr inbounds i8, i8* %tmp15, i32 %tmp18
	%tmp20 = load i8, i8* %tmp19
	%tmp21 = icmp ne i8 %tmp20, 92
	br i1 %tmp21, label %then79, label %endif79
then79:
	call void @process.throw(i8* @.str.27)
	br label %endif79
	br label %endif79
endif79:
	call void @console.write(i8* @.str.28, i32 17)
	%tmp22 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
	%tmp23 = load i8*, i8** %tmp22
	%tmp24 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	%tmp25 = load i32, i32* %tmp24
	call void @console.writeln(i8* %tmp23, i32 %tmp25)
	call void @console.write(i8* @.str.29, i32 18)
	%tmp26 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 0
	%tmp27 = load i8*, i8** %tmp26
	%tmp28 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 1
	%tmp29 = load i32, i32* %tmp28
	call void @console.writeln(i8* %tmp27, i32 %tmp29)
	call void @string.free(%struct.string.String* %v0)
	call void @string.free(%struct.string.String* %v1)
	call void @console.writeln(i8* @.str.15, i32 2)
	br label %func_exit
func_exit:
; Variable env_path is out.
; Variable full_path is out.
	ret void
}
define void @tests.list_test(){
entry:
	%v0 = alloca %"struct.list.List<i32>"; var: l
	%tmp4 = alloca i1
	%v1 = alloca %"struct.list.ListNode<i32>"*; var: current
	%tmp41 = alloca i1
	call void @console.write(i8* @.str.30, i32 11)
	%tmp0 = call %"struct.list.List<i32>" @"list.new<i32>"()
	store %"struct.list.List<i32>" %tmp0, %"struct.list.List<i32>"* %v0
	%tmp1 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %v0, i32 0, i32 2
	%tmp2 = load i32, i32* %tmp1
	%tmp3 = icmp ne i32 %tmp2, 0
	store i1 %tmp3, i1* %tmp4
	br i1 %tmp3, label %logic_end_80, label %logic_rhs_80
logic_rhs_80:
	%tmp5 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %v0, i32 0, i32 0
	%tmp6 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %tmp5
	%tmp7 = icmp ne ptr %tmp6, null
	store i1 %tmp7, i1* %tmp4
	br label %logic_end_80
logic_end_80:
	%tmp8 = load i1, i1* %tmp4
	br i1 %tmp8, label %then81, label %endif81
then81:
	call void @process.throw(i8* @.str.31)
	br label %endif81
	br label %endif81
endif81:
	call void @"list.extend<i32>"(%"struct.list.List<i32>"* %v0, i32 100)
	call void @"list.extend<i32>"(%"struct.list.List<i32>"* %v0, i32 200)
	call void @"list.extend<i32>"(%"struct.list.List<i32>"* %v0, i32 300)
	%tmp9 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %v0, i32 0, i32 2
	%tmp10 = load i32, i32* %tmp9
	%tmp11 = icmp ne i32 %tmp10, 3
	br i1 %tmp11, label %then82, label %endif82
then82:
	call void @process.throw(i8* @.str.32)
	br label %endif82
	br label %endif82
endif82:
	%tmp12 = call i32 @"list.walk<i32>"(%"struct.list.List<i32>"* %v0)
	%tmp13 = icmp ne i32 %tmp12, 3
	br i1 %tmp13, label %then83, label %endif83
then83:
	call void @process.throw(i8* @.str.33)
	br label %endif83
	br label %endif83
endif83:
	%tmp14 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %v0, i32 0, i32 0
	%tmp15 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %tmp14
	store %"struct.list.ListNode<i32>"* %tmp15, %"struct.list.ListNode<i32>"** %v1
	%tmp16 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v1
	%tmp17 = getelementptr inbounds %"struct.list.ListNode<i32>", %"struct.list.ListNode<i32>"* %tmp16, i32 0, i32 0
	%tmp18 = load i32, i32* %tmp17
	%tmp19 = icmp ne i32 %tmp18, 100
	br i1 %tmp19, label %then84, label %endif84
then84:
	call void @process.throw(i8* @.str.34)
	br label %endif84
	br label %endif84
endif84:
	%tmp20 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v1
	%tmp21 = getelementptr inbounds %"struct.list.ListNode<i32>", %"struct.list.ListNode<i32>"* %tmp20, i32 0, i32 1
	%tmp22 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %tmp21
	store %"struct.list.ListNode<i32>"* %tmp22, %"struct.list.ListNode<i32>"** %v1
	%tmp23 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v1
	%tmp24 = getelementptr inbounds %"struct.list.ListNode<i32>", %"struct.list.ListNode<i32>"* %tmp23, i32 0, i32 0
	%tmp25 = load i32, i32* %tmp24
	%tmp26 = icmp ne i32 %tmp25, 200
	br i1 %tmp26, label %then85, label %endif85
then85:
	call void @process.throw(i8* @.str.35)
	br label %endif85
	br label %endif85
endif85:
	%tmp27 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v1
	%tmp28 = getelementptr inbounds %"struct.list.ListNode<i32>", %"struct.list.ListNode<i32>"* %tmp27, i32 0, i32 1
	%tmp29 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %tmp28
	store %"struct.list.ListNode<i32>"* %tmp29, %"struct.list.ListNode<i32>"** %v1
	%tmp30 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v1
	%tmp31 = getelementptr inbounds %"struct.list.ListNode<i32>", %"struct.list.ListNode<i32>"* %tmp30, i32 0, i32 0
	%tmp32 = load i32, i32* %tmp31
	%tmp33 = icmp ne i32 %tmp32, 300
	br i1 %tmp33, label %then86, label %endif86
then86:
	call void @process.throw(i8* @.str.36)
	br label %endif86
	br label %endif86
endif86:
	%tmp34 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v1
	%tmp35 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %v0, i32 0, i32 1
	%tmp36 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %tmp35
	%tmp37 = icmp ne ptr %tmp34, %tmp36
	br i1 %tmp37, label %then87, label %endif87
then87:
	call void @process.throw(i8* @.str.37)
	br label %endif87
	br label %endif87
endif87:
	call void @"list.free<i32>"(%"struct.list.List<i32>"* %v0)
	%tmp38 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %v0, i32 0, i32 2
	%tmp39 = load i32, i32* %tmp38
	%tmp40 = icmp ne i32 %tmp39, 0
	store i1 %tmp40, i1* %tmp41
	br i1 %tmp40, label %logic_end_88, label %logic_rhs_88
logic_rhs_88:
	%tmp42 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %v0, i32 0, i32 0
	%tmp43 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %tmp42
	%tmp44 = icmp ne ptr %tmp43, null
	store i1 %tmp44, i1* %tmp41
	br label %logic_end_88
logic_end_88:
	%tmp45 = load i1, i1* %tmp41
	br i1 %tmp45, label %then89, label %endif89
then89:
	call void @process.throw(i8* @.str.38)
	br label %endif89
	br label %endif89
endif89:
	call void @console.writeln(i8* @.str.15, i32 2)
	br label %func_exit
func_exit:
; Variable l is out.
	ret void
}
define void @tests.vector_test(){
entry:
	%v0 = alloca %"struct.vector.Vec<i8>"; var: v
	%tmp4 = alloca i1
	%tmp12 = alloca i1
	%tmp23 = alloca i1
	%tmp34 = alloca i1
	%tmp45 = alloca i1
	%tmp62 = alloca i1
	%tmp73 = alloca i1
	%tmp78 = alloca i1
	call void @console.write(i8* @.str.39, i32 13)
	%tmp0 = call %"struct.vector.Vec<i8>" @"vector.new<i8>"()
	store %"struct.vector.Vec<i8>" %tmp0, %"struct.vector.Vec<i8>"* %v0
	%tmp1 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 1
	%tmp2 = load i32, i32* %tmp1
	%tmp3 = icmp ne i32 %tmp2, 0
	store i1 %tmp3, i1* %tmp4
	br i1 %tmp3, label %logic_end_90, label %logic_rhs_90
logic_rhs_90:
	%tmp5 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 2
	%tmp6 = load i32, i32* %tmp5
	%tmp7 = icmp ne i32 %tmp6, 0
	store i1 %tmp7, i1* %tmp4
	br label %logic_end_90
logic_end_90:
	%tmp8 = load i1, i1* %tmp4
	br i1 %tmp8, label %then91, label %endif91
then91:
	call void @process.throw(i8* @.str.40)
	br label %endif91
	br label %endif91
endif91:
	call void @"vector.push<i8>"(%"struct.vector.Vec<i8>"* %v0, i8 10)
	call void @"vector.push<i8>"(%"struct.vector.Vec<i8>"* %v0, i8 20)
	call void @"vector.push<i8>"(%"struct.vector.Vec<i8>"* %v0, i8 30)
	call void @"vector.push<i8>"(%"struct.vector.Vec<i8>"* %v0, i8 40)
	%tmp9 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 1
	%tmp10 = load i32, i32* %tmp9
	%tmp11 = icmp ne i32 %tmp10, 4
	store i1 %tmp11, i1* %tmp12
	br i1 %tmp11, label %logic_end_92, label %logic_rhs_92
logic_rhs_92:
	%tmp13 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 2
	%tmp14 = load i32, i32* %tmp13
	%tmp15 = icmp ne i32 %tmp14, 4
	store i1 %tmp15, i1* %tmp12
	br label %logic_end_92
logic_end_92:
	%tmp16 = load i1, i1* %tmp12
	br i1 %tmp16, label %then93, label %endif93
then93:
	call void @process.throw(i8* @.str.41)
	br label %endif93
	br label %endif93
endif93:
	%tmp17 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 0
	%tmp18 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 0
	%tmp19 = load i8*, i8** %tmp18
	%tmp20 = getelementptr inbounds i8, i8* %tmp19, i64 0
	%tmp21 = load i8, i8* %tmp20
	%tmp22 = icmp ne i8 %tmp21, 10
	store i1 %tmp22, i1* %tmp23
	br i1 %tmp22, label %logic_end_94, label %logic_rhs_94
logic_rhs_94:
	%tmp24 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 0
	%tmp25 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 0
	%tmp26 = load i8*, i8** %tmp25
	%tmp27 = getelementptr inbounds i8, i8* %tmp26, i64 3
	%tmp28 = load i8, i8* %tmp27
	%tmp29 = icmp ne i8 %tmp28, 40
	store i1 %tmp29, i1* %tmp23
	br label %logic_end_94
logic_end_94:
	%tmp30 = load i1, i1* %tmp23
	br i1 %tmp30, label %then95, label %endif95
then95:
	call void @process.throw(i8* @.str.42)
	br label %endif95
	br label %endif95
endif95:
	call void @"vector.push<i8>"(%"struct.vector.Vec<i8>"* %v0, i8 50)
	%tmp31 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 1
	%tmp32 = load i32, i32* %tmp31
	%tmp33 = icmp ne i32 %tmp32, 5
	store i1 %tmp33, i1* %tmp34
	br i1 %tmp33, label %logic_end_96, label %logic_rhs_96
logic_rhs_96:
	%tmp35 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 2
	%tmp36 = load i32, i32* %tmp35
	%tmp37 = icmp ne i32 %tmp36, 8
	store i1 %tmp37, i1* %tmp34
	br label %logic_end_96
logic_end_96:
	%tmp38 = load i1, i1* %tmp34
	br i1 %tmp38, label %then97, label %endif97
then97:
	call void @process.throw(i8* @.str.43)
	br label %endif97
	br label %endif97
endif97:
	%tmp39 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 0
	%tmp40 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 0
	%tmp41 = load i8*, i8** %tmp40
	%tmp42 = getelementptr inbounds i8, i8* %tmp41, i64 4
	%tmp43 = load i8, i8* %tmp42
	%tmp44 = icmp ne i8 %tmp43, 50
	store i1 %tmp44, i1* %tmp45
	br i1 %tmp44, label %logic_end_98, label %logic_rhs_98
logic_rhs_98:
	%tmp46 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 0
	%tmp47 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 0
	%tmp48 = load i8*, i8** %tmp47
	%tmp49 = getelementptr inbounds i8, i8* %tmp48, i64 0
	%tmp50 = load i8, i8* %tmp49
	%tmp51 = icmp ne i8 %tmp50, 10
	store i1 %tmp51, i1* %tmp45
	br label %logic_end_98
logic_end_98:
	%tmp52 = load i1, i1* %tmp45
	br i1 %tmp52, label %then99, label %endif99
then99:
	call void @process.throw(i8* @.str.44)
	br label %endif99
	br label %endif99
endif99:
	call void @"vector.push_bulk<i8>"(%"struct.vector.Vec<i8>"* %v0, i8* @.str.45, i32 2)
	%tmp53 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 1
	%tmp54 = load i32, i32* %tmp53
	%tmp55 = icmp ne i32 %tmp54, 7
	br i1 %tmp55, label %then100, label %endif100
then100:
	call void @process.throw(i8* @.str.46)
	br label %endif100
	br label %endif100
endif100:
	%tmp56 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 0
	%tmp57 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 0
	%tmp58 = load i8*, i8** %tmp57
	%tmp59 = getelementptr inbounds i8, i8* %tmp58, i64 5
	%tmp60 = load i8, i8* %tmp59
	%tmp61 = icmp ne i8 %tmp60, 65
	store i1 %tmp61, i1* %tmp62
	br i1 %tmp61, label %logic_end_101, label %logic_rhs_101
logic_rhs_101:
	%tmp63 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 0
	%tmp64 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 0
	%tmp65 = load i8*, i8** %tmp64
	%tmp66 = getelementptr inbounds i8, i8* %tmp65, i64 6
	%tmp67 = load i8, i8* %tmp66
	%tmp68 = icmp ne i8 %tmp67, 66
	store i1 %tmp68, i1* %tmp62
	br label %logic_end_101
logic_end_101:
	%tmp69 = load i1, i1* %tmp62
	br i1 %tmp69, label %then102, label %endif102
then102:
	call void @process.throw(i8* @.str.47)
	br label %endif102
	br label %endif102
endif102:
	call void @"vector.free<i8>"(%"struct.vector.Vec<i8>"* %v0)
	%tmp70 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 1
	%tmp71 = load i32, i32* %tmp70
	%tmp72 = icmp ne i32 %tmp71, 0
	store i1 %tmp72, i1* %tmp73
	br i1 %tmp72, label %logic_end_103, label %logic_rhs_103
logic_rhs_103:
	%tmp74 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 2
	%tmp75 = load i32, i32* %tmp74
	%tmp76 = icmp ne i32 %tmp75, 0
	store i1 %tmp76, i1* %tmp73
	br label %logic_end_103
logic_end_103:
	%tmp77 = load i1, i1* %tmp73
	store i1 %tmp77, i1* %tmp78
	br i1 %tmp77, label %logic_end_104, label %logic_rhs_104
logic_rhs_104:
	%tmp79 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 0
	%tmp80 = load i8*, i8** %tmp79
	%tmp81 = icmp ne ptr %tmp80, null
	store i1 %tmp81, i1* %tmp78
	br label %logic_end_104
logic_end_104:
	%tmp82 = load i1, i1* %tmp78
	br i1 %tmp82, label %then105, label %endif105
then105:
	call void @process.throw(i8* @.str.48)
	br label %endif105
	br label %endif105
endif105:
	call void @console.writeln(i8* @.str.15, i32 2)
	br label %func_exit
func_exit:
; Variable v is out.
	ret void
}
define void @tests.string_test(){
entry:
	%v0 = alloca %struct.string.String; var: s1
	%v1 = alloca %struct.string.String; var: s2
	%v2 = alloca %struct.string.String; var: s3
	%v3 = alloca %struct.string.String; var: s4
	%v4 = alloca %struct.string.String; var: s5
	call void @console.write(i8* @.str.49, i32 13)
	%tmp0 = call %struct.string.String @string.from_c_string(i8* @.str.50)
	store %struct.string.String %tmp0, %struct.string.String* %v0
	%tmp1 = call %struct.string.String @string.from_c_string(i8* @.str.50)
	store %struct.string.String %tmp1, %struct.string.String* %v1
	%tmp2 = call %struct.string.String @string.from_c_string(i8* @.str.51)
	store %struct.string.String %tmp2, %struct.string.String* %v2
	%tmp3 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	%tmp4 = load i32, i32* %tmp3
	%tmp5 = icmp ne i32 %tmp4, 5
	br i1 %tmp5, label %then106, label %endif106
then106:
	call void @process.throw(i8* @.str.52)
	br label %endif106
	br label %endif106
endif106:
	%tmp6 = call i1 @string.equal(%struct.string.String* %v0, %struct.string.String* %v1)
	%tmp7 = xor i1 1, %tmp6
	br i1 %tmp7, label %then107, label %endif107
then107:
	call void @process.throw(i8* @.str.53)
	br label %endif107
	br label %endif107
endif107:
	%tmp8 = call i1 @string.equal(%struct.string.String* %v0, %struct.string.String* %v2)
	br i1 %tmp8, label %then108, label %endif108
then108:
	call void @process.throw(i8* @.str.54)
	br label %endif108
	br label %endif108
endif108:
	%tmp9 = call %struct.string.String @string.concat_with_c_string(%struct.string.String* %v0, i8* @.str.55)
	store %struct.string.String %tmp9, %struct.string.String* %v3
	%tmp10 = call %struct.string.String @string.from_c_string(i8* @.str.56)
	store %struct.string.String %tmp10, %struct.string.String* %v4
	%tmp11 = getelementptr inbounds %struct.string.String, %struct.string.String* %v3, i32 0, i32 1
	%tmp12 = load i32, i32* %tmp11
	%tmp13 = icmp ne i32 %tmp12, 11
	br i1 %tmp13, label %then109, label %endif109
then109:
	call void @process.throw(i8* @.str.57)
	br label %endif109
	br label %endif109
endif109:
	%tmp14 = call i1 @string.equal(%struct.string.String* %v3, %struct.string.String* %v4)
	%tmp15 = xor i1 1, %tmp14
	br i1 %tmp15, label %then110, label %endif110
then110:
	call void @process.throw(i8* @.str.58)
	br label %endif110
	br label %endif110
endif110:
	call void @string.free(%struct.string.String* %v0)
	call void @string.free(%struct.string.String* %v1)
	call void @string.free(%struct.string.String* %v2)
	call void @string.free(%struct.string.String* %v3)
	call void @string.free(%struct.string.String* %v4)
	call void @console.writeln(i8* @.str.15, i32 2)
	br label %func_exit
func_exit:
; Variable s5 is out.
; Variable s4 is out.
; Variable s3 is out.
; Variable s2 is out.
; Variable s1 is out.
	ret void
}
define void @tests.string_utils_test(){
entry:
	%tmp6 = alloca i1
	%tmp11 = alloca i1
	%tmp16 = alloca i1
	%v0 = alloca i32; var: i
	%tmp24 = alloca i1
	call void @console.write(i8* @.str.59, i32 19)
	%tmp0 = call i32 @string_utils.c_str_len(i8* @.str.60)
	%tmp1 = icmp ne i32 %tmp0, 4
	br i1 %tmp1, label %then111, label %endif111
then111:
	call void @process.throw(i8* @.str.61)
	br label %endif111
	br label %endif111
endif111:
	%tmp2 = call i32 @string_utils.c_str_len(i8* @.str.62)
	%tmp3 = icmp ne i32 %tmp2, 0
	br i1 %tmp3, label %then112, label %endif112
then112:
	call void @process.throw(i8* @.str.63)
	br label %endif112
	br label %endif112
endif112:
	%tmp4 = call i1 @string_utils.is_ascii_num(i8 55)
	%tmp5 = xor i1 1, %tmp4
	store i1 %tmp5, i1* %tmp6
	br i1 %tmp5, label %logic_end_113, label %logic_rhs_113
logic_rhs_113:
	%tmp7 = call i1 @string_utils.is_ascii_num(i8 98)
	store i1 %tmp7, i1* %tmp6
	br label %logic_end_113
logic_end_113:
	%tmp8 = load i1, i1* %tmp6
	br i1 %tmp8, label %then114, label %endif114
then114:
	call void @process.throw(i8* @.str.64)
	br label %endif114
	br label %endif114
endif114:
	%tmp9 = call i1 @string_utils.is_ascii_char(i8 97)
	%tmp10 = xor i1 1, %tmp9
	store i1 %tmp10, i1* %tmp11
	br i1 %tmp10, label %logic_end_115, label %logic_rhs_115
logic_rhs_115:
	%tmp12 = call i1 @string_utils.is_ascii_char(i8 57)
	store i1 %tmp12, i1* %tmp11
	br label %logic_end_115
logic_end_115:
	%tmp13 = load i1, i1* %tmp11
	br i1 %tmp13, label %then116, label %endif116
then116:
	call void @process.throw(i8* @.str.65)
	br label %endif116
	br label %endif116
endif116:
	%tmp14 = call i1 @string_utils.is_ascii_hex(i8 70)
	%tmp15 = xor i1 1, %tmp14
	store i1 %tmp15, i1* %tmp16
	br i1 %tmp15, label %logic_end_117, label %logic_rhs_117
logic_rhs_117:
	%tmp17 = call i1 @string_utils.is_ascii_hex(i8 71)
	store i1 %tmp17, i1* %tmp16
	br label %logic_end_117
logic_end_117:
	%tmp18 = load i1, i1* %tmp16
	br i1 %tmp18, label %then118, label %endif118
then118:
	call void @process.throw(i8* @.str.66)
	br label %endif118
	br label %endif118
endif118:
	%tmp19 = call i8* @string_utils.insert(i8* @.str.67, i8* @.str.68, i32 1)
	store i32 0, i32* %v0
	br label %loop_body119
loop_body119:
	%tmp20 = load i32, i32* %v0
	%tmp21 = getelementptr inbounds i8, i8* %tmp19, i32 %tmp20
	%tmp22 = load i8, i8* %tmp21
	%tmp23 = icmp eq i8 %tmp22, 0
	store i1 %tmp23, i1* %tmp24
	br i1 %tmp23, label %logic_rhs_120, label %logic_end_120
logic_rhs_120:
	%tmp25 = load i32, i32* %v0
	%tmp26 = getelementptr inbounds i8, i8* @.str.69, i32 %tmp25
	%tmp27 = load i8, i8* %tmp26
	%tmp28 = icmp eq i8 %tmp27, 0
	store i1 %tmp28, i1* %tmp24
	br label %logic_end_120
logic_end_120:
	%tmp29 = load i1, i1* %tmp24
	br i1 %tmp29, label %then121, label %endif121
then121:
	br label %loop_body119_exit
	br label %endif121
	br label %endif121
endif121:
	%tmp30 = load i32, i32* %v0
	%tmp31 = getelementptr inbounds i8, i8* %tmp19, i32 %tmp30
	%tmp32 = load i8, i8* %tmp31
	%tmp33 = load i32, i32* %v0
	%tmp34 = getelementptr inbounds i8, i8* @.str.69, i32 %tmp33
	%tmp35 = load i8, i8* %tmp34
	%tmp36 = icmp ne i8 %tmp32, %tmp35
	br i1 %tmp36, label %then122, label %endif122
then122:
	call void @process.throw(i8* @.str.70)
	br label %endif122
	br label %endif122
endif122:
	%tmp37 = load i32, i32* %v0
	%tmp38 = add i32 %tmp37, 1
	store i32 %tmp38, i32* %v0
	br label %loop_body119
loop_body119_exit:
	call void @mem.free(i8* %tmp19)
	call void @console.writeln(i8* @.str.15, i32 2)
	br label %func_exit
func_exit:
	ret void
}
define void @tests.mem_test(){
entry:
	%v0 = alloca i64; var: i
	%v1 = alloca i64; var: i
	call void @console.write(i8* @.str.71, i32 10)
	%tmp0 = call i8* @mem.malloc(i64 16)
	%tmp1 = icmp eq ptr %tmp0, null
	br i1 %tmp1, label %then123, label %endif123
then123:
	call void @process.throw(i8* @.str.72)
	br label %endif123
	br label %endif123
endif123:
	call void @mem.fill(i8 88, i8* %tmp0, i64 16)
	store i64 0, i64* %v0
	br label %loop_body124
loop_body124:
	%tmp2 = load i64, i64* %v0
	%tmp3 = icmp sge i64 %tmp2, 16
	br i1 %tmp3, label %then125, label %endif125
then125:
	br label %loop_body124_exit
	br label %endif125
	br label %endif125
endif125:
	%tmp4 = load i64, i64* %v0
	%tmp5 = getelementptr inbounds i8, i8* %tmp0, i64 %tmp4
	%tmp6 = load i8, i8* %tmp5
	%tmp7 = icmp ne i8 %tmp6, 88
	br i1 %tmp7, label %then126, label %endif126
then126:
	call void @process.throw(i8* @.str.73)
	br label %endif126
	br label %endif126
endif126:
	%tmp8 = load i64, i64* %v0
	%tmp9 = add i64 %tmp8, 1
	store i64 %tmp9, i64* %v0
	br label %loop_body124
loop_body124_exit:
	call void @mem.zero_fill(i8* %tmp0, i64 16)
	store i64 0, i64* %v1
	br label %loop_body127
loop_body127:
	%tmp10 = load i64, i64* %v1
	%tmp11 = icmp sge i64 %tmp10, 16
	br i1 %tmp11, label %then128, label %endif128
then128:
	br label %loop_body127_exit
	br label %endif128
	br label %endif128
endif128:
	%tmp12 = load i64, i64* %v1
	%tmp13 = getelementptr inbounds i8, i8* %tmp0, i64 %tmp12
	%tmp14 = load i8, i8* %tmp13
	%tmp15 = icmp ne i8 %tmp14, 0
	br i1 %tmp15, label %then129, label %endif129
then129:
	call void @process.throw(i8* @.str.74)
	br label %endif129
	br label %endif129
endif129:
	%tmp16 = load i64, i64* %v1
	%tmp17 = add i64 %tmp16, 1
	store i64 %tmp17, i64* %v1
	br label %loop_body127
loop_body127_exit:
	%tmp18 = call i8* @mem.malloc(i64 16)
	%tmp19 = icmp eq ptr %tmp18, null
	br i1 %tmp19, label %then130, label %endif130
then130:
	call void @process.throw(i8* @.str.75)
	br label %endif130
	br label %endif130
endif130:
	call void @mem.fill(i8 89, i8* %tmp18, i64 16)
	call void @mem.copy(i8* %tmp18, i8* %tmp0, i64 16)
	store i64 0, i64* %v1
	br label %loop_body131
loop_body131:
	%tmp20 = load i64, i64* %v1
	%tmp21 = icmp sge i64 %tmp20, 16
	br i1 %tmp21, label %then132, label %endif132
then132:
	br label %loop_body131_exit
	br label %endif132
	br label %endif132
endif132:
	%tmp22 = load i64, i64* %v1
	%tmp23 = getelementptr inbounds i8, i8* %tmp0, i64 %tmp22
	%tmp24 = load i8, i8* %tmp23
	%tmp25 = icmp ne i8 %tmp24, 89
	br i1 %tmp25, label %then133, label %endif133
then133:
	call void @process.throw(i8* @.str.76)
	br label %endif133
	br label %endif133
endif133:
	%tmp26 = load i64, i64* %v1
	%tmp27 = add i64 %tmp26, 1
	store i64 %tmp27, i64* %v1
	br label %loop_body131
loop_body131_exit:
	call void @mem.free(i8* %tmp0)
	call void @mem.free(i8* %tmp18)
	call void @console.writeln(i8* @.str.15, i32 2)
	br label %func_exit
func_exit:
	ret void
}
define i1 @window.is_null(i8* %p){
entry:
	%tmp0 = icmp eq ptr %p, null
	br label %func_exit
	unreachable
func_exit:
	%final_ret = phi i1 [ %tmp0, %entry ]
	ret i1 %final_ret
}
define i64 @window.WindowProc(i8* %hWnd, i32 %uMsg, i64 %wParam, i64 %lParam){
entry:
	%v0 = alloca %struct.window.PAINTSTRUCT; var: ps
	%tmp0 = icmp eq i32 %uMsg, 16
	br i1 %tmp0, label %then134, label %endif134
then134:
	call void @PostQuitMessage(i32 0)
	br label %func_exit
	br label %endif134
	br label %endif134
endif134:
	%tmp1 = icmp eq i32 %uMsg, 2
	br i1 %tmp1, label %then135, label %endif135
then135:
	call void @PostQuitMessage(i32 0)
	br label %func_exit
	br label %endif135
	br label %endif135
endif135:
	%tmp2 = icmp eq i32 %uMsg, 256
	br i1 %tmp2, label %then136, label %endif136
then136:
	%tmp3 = icmp eq i64 %wParam, 27
	br i1 %tmp3, label %then137, label %endif137
then137:
	call void @PostQuitMessage(i32 0)
	br label %func_exit
	br label %endif137
	br label %endif137
endif137:
	%tmp4 = trunc i64 %wParam to i8
	call void @console.print_char(i8 %tmp4)
	br label %endif136
	br label %endif136
endif136:
	%tmp5 = icmp eq i32 %uMsg, 8
	br i1 %tmp5, label %then138, label %endif138
then138:
	call void @PostQuitMessage(i32 0)
	br label %func_exit
	br label %endif138
	br label %endif138
endif138:
	%tmp6 = icmp eq i32 %uMsg, 132
	br i1 %tmp6, label %then139, label %endif139
then139:
	%tmp7 = call i64 @DefWindowProcA(i8* %hWnd, i32 %uMsg, i64 %wParam, i64 %lParam)
	%tmp8 = icmp eq i64 %tmp7, 1
	br i1 %tmp8, label %then140, label %endif140
then140:
	br label %func_exit
	br label %endif140
	br label %endif140
endif140:
	br label %func_exit
	br label %endif139
	br label %endif139
endif139:
	%tmp9 = icmp eq i32 %uMsg, 163
	br i1 %tmp9, label %then141, label %endif141
then141:
	br label %func_exit
	br label %endif141
	br label %endif141
endif141:
	%tmp10 = icmp eq i32 %uMsg, 15
	br i1 %tmp10, label %then142, label %endif142
then142:
	%tmp11 = call i8* @BeginPaint(i8* %hWnd, %struct.window.PAINTSTRUCT* %v0)
	%tmp12 = call i8* @GetWindowLongPtrA(i8* %hWnd, i32 -21)
	%tmp13 = icmp ne ptr %tmp12, null
	br i1 %tmp13, label %then143, label %endif143
then143:
	call void @window.draw_bitmap(i8* %tmp11, i8* %tmp12, i32 0, i32 0)
	br label %endif143
	br label %endif143
endif143:
	call i32 @EndPaint(i8* %hWnd, %struct.window.PAINTSTRUCT* %v0)
	br label %func_exit
; Variable ps is out.
	br label %endif142
	br label %endif142
endif142:
	%tmp14 = call i64 @DefWindowProcA(i8* %hWnd, i32 %uMsg, i64 %wParam, i64 %lParam)
	br label %func_exit
	unreachable
func_exit:
	%final_ret = phi i64 [ 0, %then134 ], [ 0, %then135 ], [ 0, %then137 ], [ 0, %then138 ], [ 2, %then140 ], [ %tmp7, %endif140 ], [ 0, %then141 ], [ 0, %endif143 ], [ %tmp14, %endif142 ]
	ret i64 %final_ret
}
define %struct.string.String @process.get_executable_env_path(){
entry:
	%v0 = alloca %struct.string.String; var: string
	%v1 = alloca i32; var: index
	%tmp11 = alloca i1
	%tmp0 = call %struct.string.String @process.get_executable_path()
	store %struct.string.String %tmp0, %struct.string.String* %v0
	%tmp1 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	%tmp2 = load i32, i32* %tmp1
	%tmp3 = sub i32 %tmp2, 1
	store i32 %tmp3, i32* %v1
	br label %loop_body144
loop_body144:
	%tmp4 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
	%tmp5 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
	%tmp6 = load i8*, i8** %tmp5
	%tmp7 = load i32, i32* %v1
	%tmp8 = getelementptr inbounds i8, i8* %tmp6, i32 %tmp7
	%tmp9 = load i8, i8* %tmp8
	%tmp10 = icmp eq i8 %tmp9, 92
	store i1 %tmp10, i1* %tmp11
	br i1 %tmp10, label %logic_end_145, label %logic_rhs_145
logic_rhs_145:
	%tmp12 = load i32, i32* %v1
	%tmp13 = icmp slt i32 %tmp12, 0
	store i1 %tmp13, i1* %tmp11
	br label %logic_end_145
logic_end_145:
	%tmp14 = load i1, i1* %tmp11
	br i1 %tmp14, label %then146, label %endif146
then146:
	br label %loop_body144_exit
	br label %endif146
	br label %endif146
endif146:
	%tmp15 = load i32, i32* %v1
	%tmp16 = sub i32 %tmp15, 1
	store i32 %tmp16, i32* %v1
	br label %loop_body144
loop_body144_exit:
	%tmp17 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	%tmp18 = load i32, i32* %v1
	%tmp19 = add i32 %tmp18, 1
	store i32 %tmp19, i32* %tmp17
	%tmp20 = load %struct.string.String, %struct.string.String* %v0
	br label %func_exit
	unreachable
func_exit:
; Variable string is out.
	%final_ret = phi %struct.string.String [ %tmp20, %loop_body144_exit ]
	ret %struct.string.String %final_ret
}
define %struct.string.String @process.get_executable_path(){
entry:
	%v0 = alloca %struct.string.String; var: string
	%tmp0 = call %struct.string.String @string.with_size(i32 260)
	store %struct.string.String %tmp0, %struct.string.String* %v0
	%tmp1 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
	%tmp2 = load i8*, i8** %tmp1
	%tmp3 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	%tmp4 = load i32, i32* %tmp3
	%tmp5 = call i32 @GetModuleFileNameA(i8* null, i8* %tmp2, i32 %tmp4)
	%tmp6 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	store i32 %tmp5, i32* %tmp6
	%tmp7 = load %struct.string.String, %struct.string.String* %v0
	br label %func_exit
	unreachable
func_exit:
; Variable string is out.
	%final_ret = phi %struct.string.String [ %tmp7, %entry ]
	ret %struct.string.String %final_ret
}
define void @mem.zero_fill(i8* %dest, i64 %len){
entry:
	call void @mem.fill(i8 0, i8* %dest, i64 %len)
	br label %func_exit
func_exit:
	ret void
}
define void @mem.fill(i8 %val, i8* %dest, i64 %len){
entry:
	%v0 = alloca i64; var: i
	store i64 0, i64* %v0
	br label %loop_body147
loop_body147:
	%tmp0 = load i64, i64* %v0
	%tmp1 = icmp sge i64 %tmp0, %len
	br i1 %tmp1, label %then148, label %endif148
then148:
	br label %loop_body147_exit
	br label %endif148
	br label %endif148
endif148:
	%tmp2 = load i64, i64* %v0
	%tmp3 = getelementptr inbounds i8, i8* %dest, i64 %tmp2
	store i8 %val, i8* %tmp3
	%tmp4 = load i64, i64* %v0
	%tmp5 = add i64 %tmp4, 1
	store i64 %tmp5, i64* %v0
	br label %loop_body147
loop_body147_exit:
	br label %func_exit
func_exit:
	ret void
}
define void @mem.copy(i8* %src, i8* %dest, i64 %len){
entry:
	%v0 = alloca i64; var: i
	store i64 0, i64* %v0
	br label %loop_body149
loop_body149:
	%tmp0 = load i64, i64* %v0
	%tmp1 = icmp sge i64 %tmp0, %len
	br i1 %tmp1, label %then150, label %endif150
then150:
	br label %loop_body149_exit
	br label %endif150
	br label %endif150
endif150:
	%tmp2 = load i64, i64* %v0
	%tmp3 = getelementptr inbounds i8, i8* %dest, i64 %tmp2
	%tmp4 = load i64, i64* %v0
	%tmp5 = getelementptr inbounds i8, i8* %src, i64 %tmp4
	%tmp6 = load i8, i8* %tmp5
	store i8 %tmp6, i8* %tmp3
	%tmp7 = load i64, i64* %v0
	%tmp8 = add i64 %tmp7, 1
	store i64 %tmp8, i64* %v0
	br label %loop_body149
loop_body149_exit:
	br label %func_exit
func_exit:
	ret void
}
define void @mem.free(i8* %ptr){
entry:
	%tmp0 = icmp ne ptr %ptr, null
	br i1 %tmp0, label %then151, label %endif151
then151:
	%tmp1 = call i32* @GetProcessHeap()
	call i32 @HeapFree(i32* %tmp1, i32 0, i8* %ptr)
	br label %endif151
	br label %endif151
endif151:
	br label %func_exit
func_exit:
	ret void
}
define i8* @mem.malloc(i64 %size){
entry:
	%tmp0 = call i32* @GetProcessHeap()
	%tmp1 = call i8* @HeapAlloc(i32* %tmp0, i32 0, i64 %size)
	%tmp2 = icmp eq ptr %tmp1, null
	br i1 %tmp2, label %then152, label %endif152
then152:
	call void @process.throw(i8* @.str.77)
	br label %endif152
	br label %endif152
endif152:
	br label %func_exit
	unreachable
func_exit:
	%final_ret = phi i8* [ %tmp1, %endif152 ]
	ret i8* %final_ret
}
define void @console.writeln(i8* %buffer, i32 %len){
entry:
	%v0 = alloca i32; var: chars_written
	%v1 = alloca i8; var: nl
	%tmp0 = icmp eq i32 %len, 0
	br i1 %tmp0, label %then153, label %endif153
then153:
	br label %func_exit
	br label %endif153
	br label %endif153
endif153:
	%tmp1 = call i8* @console.get_stdout()
	call i32 @WriteConsoleA(i8* %tmp1, i8* %buffer, i32 %len, i32* %v0, i8* null)
	%tmp2 = load i32, i32* %v0
	%tmp3 = icmp ne i32 %len, %tmp2
	br i1 %tmp3, label %then154, label %endif154
then154:
	call void @ExitProcess(i32 -2)
	br label %endif154
	br label %endif154
endif154:
	store i8 10, i8* %v1
	%tmp4 = call i8* @console.get_stdout()
	call i32 @WriteConsoleA(i8* %tmp4, i8* %v1, i32 1, i32* %v0, i8* null)
	br label %func_exit
func_exit:
	ret void
}
define void @string.as_c_string_stalloc(%struct.string.String* %string, i8* %stallocd_buffer){
entry:
	%tmp0 = getelementptr inbounds %struct.string.String, %struct.string.String* %string, i32 0, i32 0
	%tmp1 = load i8*, i8** %tmp0
	%tmp2 = getelementptr inbounds %struct.string.String, %struct.string.String* %string, i32 0, i32 1
	%tmp3 = load i32, i32* %tmp2
	%tmp4 = sext i32 %tmp3 to i64
	call void @mem.copy(i8* %tmp1, i8* %stallocd_buffer, i64 %tmp4)
	%tmp5 = getelementptr inbounds %struct.string.String, %struct.string.String* %string, i32 0, i32 1
	%tmp6 = load i32, i32* %tmp5
	%tmp7 = getelementptr inbounds i8, i8* %stallocd_buffer, i32 %tmp6
	store i8 0, i8* %tmp7
	br label %func_exit
func_exit:
	ret void
}
define void @string.free(%struct.string.String* %str){
entry:
	%tmp0 = getelementptr inbounds %struct.string.String, %struct.string.String* %str, i32 0, i32 0
	%tmp1 = load i8*, i8** %tmp0
	call void @mem.free(i8* %tmp1)
	%tmp2 = getelementptr inbounds %struct.string.String, %struct.string.String* %str, i32 0, i32 1
	store i32 0, i32* %tmp2
	br label %func_exit
func_exit:
	ret void
}
define i1 @string.equal(%struct.string.String* %first, %struct.string.String* %second){
entry:
	%tmp0 = getelementptr inbounds %struct.string.String, %struct.string.String* %first, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = getelementptr inbounds %struct.string.String, %struct.string.String* %second, i32 0, i32 1
	%tmp3 = load i32, i32* %tmp2
	%tmp4 = icmp ne i32 %tmp1, %tmp3
	br i1 %tmp4, label %then155, label %endif155
then155:
	br label %func_exit
	br label %endif155
	br label %endif155
endif155:
	%tmp5 = getelementptr inbounds %struct.string.String, %struct.string.String* %first, i32 0, i32 0
	%tmp6 = load i8*, i8** %tmp5
	%tmp7 = getelementptr inbounds %struct.string.String, %struct.string.String* %second, i32 0, i32 0
	%tmp8 = load i8*, i8** %tmp7
	%tmp9 = getelementptr inbounds %struct.string.String, %struct.string.String* %first, i32 0, i32 1
	%tmp10 = load i32, i32* %tmp9
	%tmp11 = sext i32 %tmp10 to i64
	%tmp12 = call i32 @mem.compare(i8* %tmp6, i8* %tmp8, i64 %tmp11)
	%tmp13 = icmp eq i32 %tmp12, 0
	br label %func_exit
	unreachable
func_exit:
	%final_ret = phi i1 [ false, %then155 ], [ %tmp13, %endif155 ]
	ret i1 %final_ret
}
define %struct.string.String @string.concat_with_c_string(%struct.string.String* %src_string, i8* %c_string){
entry:
	%v0 = alloca %struct.string.String; var: str
	%tmp0 = call i32 @string_utils.c_str_len(i8* %c_string)
	%tmp1 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 1
	%tmp2 = load i32, i32* %tmp1
	%tmp3 = add i32 %tmp0, %tmp2
	%tmp4 = add i32 %tmp3, 1
	%tmp5 = sext i32 %tmp4 to i64
	%tmp6 = mul i64 1, %tmp5
	%tmp7 = call i8* @mem.malloc(i64 %tmp6)
	%tmp8 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 0
	%tmp9 = load i8*, i8** %tmp8
	%tmp10 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 1
	%tmp11 = load i32, i32* %tmp10
	%tmp12 = sext i32 %tmp11 to i64
	call void @mem.copy(i8* %tmp9, i8* %tmp7, i64 %tmp12)
	%tmp13 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 1
	%tmp14 = load i32, i32* %tmp13
	%tmp15 = sext i32 %tmp14 to i64
	%tmp16 = getelementptr inbounds i8, i8* %tmp7, i64 %tmp15
	%tmp17 = sext i32 %tmp0 to i64
	call void @mem.copy(i8* %c_string, i8* %tmp16, i64 %tmp17)
	%tmp18 = getelementptr inbounds i8, i8* %tmp7, i32 %tmp3
	store i8 0, i8* %tmp18
	%tmp19 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
	store i8* %tmp7, i8** %tmp19
	%tmp20 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	store i32 %tmp3, i32* %tmp20
	%tmp21 = load %struct.string.String, %struct.string.String* %v0
	br label %func_exit
	unreachable
func_exit:
; Variable str is out.
	%final_ret = phi %struct.string.String [ %tmp21, %entry ]
	ret %struct.string.String %final_ret
}
define %struct.string.String @string.with_size(i32 %size){
entry:
	%v0 = alloca %struct.string.String; var: x
	%tmp0 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	store i32 %size, i32* %tmp0
	%tmp1 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
	%tmp2 = add i32 %size, 1
	%tmp3 = sext i32 %tmp2 to i64
	%tmp4 = mul i64 1, %tmp3
	%tmp5 = call i8* @mem.malloc(i64 %tmp4)
	store i8* %tmp5, i8** %tmp1
	%tmp6 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
	%tmp7 = load i8*, i8** %tmp6
	%tmp8 = add i32 %size, 1
	%tmp9 = sext i32 %tmp8 to i64
	call void @mem.zero_fill(i8* %tmp7, i64 %tmp9)
	%tmp10 = load %struct.string.String, %struct.string.String* %v0
	br label %func_exit
	unreachable
func_exit:
; Variable x is out.
	%final_ret = phi %struct.string.String [ %tmp10, %entry ]
	ret %struct.string.String %final_ret
}
define %struct.string.String @string.from_c_string(i8* %c_string){
entry:
	%v0 = alloca %struct.string.String; var: x
	%tmp0 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	%tmp1 = call i32 @string_utils.c_str_len(i8* %c_string)
	store i32 %tmp1, i32* %tmp0
	%tmp2 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
	%tmp3 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	%tmp4 = load i32, i32* %tmp3
	%tmp5 = add i32 %tmp4, 1
	%tmp6 = sext i32 %tmp5 to i64
	%tmp7 = mul i64 1, %tmp6
	%tmp8 = call i8* @mem.malloc(i64 %tmp7)
	store i8* %tmp8, i8** %tmp2
	%tmp9 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
	%tmp10 = load i8*, i8** %tmp9
	%tmp11 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	%tmp12 = load i32, i32* %tmp11
	%tmp13 = sext i32 %tmp12 to i64
	call void @mem.copy(i8* %c_string, i8* %tmp10, i64 %tmp13)
	%tmp14 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
	%tmp15 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
	%tmp16 = load i8*, i8** %tmp15
	%tmp17 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	%tmp18 = load i32, i32* %tmp17
	%tmp19 = getelementptr inbounds i8, i8* %tmp16, i32 %tmp18
	store i8 0, i8* %tmp19
	%tmp20 = load %struct.string.String, %struct.string.String* %v0
	br label %func_exit
	unreachable
func_exit:
; Variable x is out.
	%final_ret = phi %struct.string.String [ %tmp20, %entry ]
	ret %struct.string.String %final_ret
}
define i1 @string_utils.is_ascii_hex(i8 %char){
entry:
	%tmp1 = alloca i1
	%tmp4 = alloca i1
	%tmp6 = alloca i1
	%tmp10 = alloca i1
	%tmp12 = alloca i1
	%tmp0 = icmp sge i8 %char, 48
	store i1 %tmp0, i1* %tmp1
	br i1 %tmp0, label %logic_rhs_156, label %logic_end_156
logic_rhs_156:
	%tmp2 = icmp sle i8 %char, 57
	store i1 %tmp2, i1* %tmp1
	br label %logic_end_156
logic_end_156:
	%tmp3 = load i1, i1* %tmp1
	store i1 %tmp3, i1* %tmp4
	br i1 %tmp3, label %logic_end_157, label %logic_rhs_157
logic_rhs_157:
	%tmp5 = icmp sge i8 %char, 65
	store i1 %tmp5, i1* %tmp6
	br i1 %tmp5, label %logic_rhs_158, label %logic_end_158
logic_rhs_158:
	%tmp7 = icmp sle i8 %char, 70
	store i1 %tmp7, i1* %tmp6
	br label %logic_end_158
logic_end_158:
	%tmp8 = load i1, i1* %tmp6
	store i1 %tmp8, i1* %tmp4
	br label %logic_end_157
logic_end_157:
	%tmp9 = load i1, i1* %tmp4
	store i1 %tmp9, i1* %tmp10
	br i1 %tmp9, label %logic_end_159, label %logic_rhs_159
logic_rhs_159:
	%tmp11 = icmp sge i8 %char, 97
	store i1 %tmp11, i1* %tmp12
	br i1 %tmp11, label %logic_rhs_160, label %logic_end_160
logic_rhs_160:
	%tmp13 = icmp sle i8 %char, 102
	store i1 %tmp13, i1* %tmp12
	br label %logic_end_160
logic_end_160:
	%tmp14 = load i1, i1* %tmp12
	store i1 %tmp14, i1* %tmp10
	br label %logic_end_159
logic_end_159:
	%tmp15 = load i1, i1* %tmp10
	br label %func_exit
	unreachable
func_exit:
	%final_ret = phi i1 [ %tmp15, %logic_end_159 ]
	ret i1 %final_ret
}
define i1 @string_utils.is_ascii_char(i8 %char){
entry:
	%tmp1 = alloca i1
	%tmp4 = alloca i1
	%tmp6 = alloca i1
	%tmp0 = icmp sge i8 %char, 65
	store i1 %tmp0, i1* %tmp1
	br i1 %tmp0, label %logic_rhs_161, label %logic_end_161
logic_rhs_161:
	%tmp2 = icmp sle i8 %char, 90
	store i1 %tmp2, i1* %tmp1
	br label %logic_end_161
logic_end_161:
	%tmp3 = load i1, i1* %tmp1
	store i1 %tmp3, i1* %tmp4
	br i1 %tmp3, label %logic_end_162, label %logic_rhs_162
logic_rhs_162:
	%tmp5 = icmp sge i8 %char, 97
	store i1 %tmp5, i1* %tmp6
	br i1 %tmp5, label %logic_rhs_163, label %logic_end_163
logic_rhs_163:
	%tmp7 = icmp sle i8 %char, 122
	store i1 %tmp7, i1* %tmp6
	br label %logic_end_163
logic_end_163:
	%tmp8 = load i1, i1* %tmp6
	store i1 %tmp8, i1* %tmp4
	br label %logic_end_162
logic_end_162:
	%tmp9 = load i1, i1* %tmp4
	br label %func_exit
	unreachable
func_exit:
	%final_ret = phi i1 [ %tmp9, %logic_end_162 ]
	ret i1 %final_ret
}
define i1 @string_utils.is_ascii_num(i8 %char){
entry:
	%tmp1 = alloca i1
	%tmp0 = icmp sge i8 %char, 48
	store i1 %tmp0, i1* %tmp1
	br i1 %tmp0, label %logic_rhs_164, label %logic_end_164
logic_rhs_164:
	%tmp2 = icmp sle i8 %char, 57
	store i1 %tmp2, i1* %tmp1
	br label %logic_end_164
logic_end_164:
	%tmp3 = load i1, i1* %tmp1
	br label %func_exit
	unreachable
func_exit:
	%final_ret = phi i1 [ %tmp3, %logic_end_164 ]
	ret i1 %final_ret
}
define i32 @string_utils.c_str_len(i8* %str){
entry:
	%v0 = alloca i32; var: len
	store i32 0, i32* %v0
	br label %loop_body165
loop_body165:
	%tmp0 = load i32, i32* %v0
	%tmp1 = getelementptr inbounds i8, i8* %str, i32 %tmp0
	%tmp2 = load i8, i8* %tmp1
	%tmp3 = icmp eq i8 %tmp2, 0
	br i1 %tmp3, label %then166, label %endif166
then166:
	br label %loop_body165_exit
	br label %endif166
	br label %endif166
endif166:
	%tmp4 = load i32, i32* %v0
	%tmp5 = add i32 %tmp4, 1
	store i32 %tmp5, i32* %v0
	br label %loop_body165
loop_body165_exit:
	%tmp6 = load i32, i32* %v0
	br label %func_exit
	unreachable
func_exit:
	%final_ret = phi i32 [ %tmp6, %loop_body165_exit ]
	ret i32 %final_ret
}
define i8* @string_utils.insert(i8* %src1, i8* %src2, i32 %index){
entry:
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
	br label %func_exit
	unreachable
func_exit:
	%final_ret = phi i8* [ %tmp5, %entry ]
	ret i8* %final_ret
}
define i32 @fs.delete_file(i8* %path){
entry:
	%tmp0 = call i32 @DeleteFileA(i8* %path)
	br label %func_exit
	unreachable
func_exit:
	%final_ret = phi i32 [ %tmp0, %entry ]
	ret i32 %final_ret
}
define i32 @fs.create_file(i8* %path){
entry:
	%tmp0 = call i8* @CreateFileA(i8* %path, i32 1073741824, i32 0, i8* null, i32 1, i32 128, i8* null)
	%tmp1 = inttoptr i64 -1 to i8*
	%tmp2 = icmp eq ptr %tmp0, %tmp1
	br i1 %tmp2, label %then167, label %endif167
then167:
	br label %func_exit
	br label %endif167
	br label %endif167
endif167:
	call i32 @CloseHandle(i8* %tmp0)
	br label %func_exit
	unreachable
func_exit:
	%final_ret = phi i32 [ 0, %then167 ], [ 1, %endif167 ]
	ret i32 %final_ret
}
define %struct.string.String @fs.read_full_file_as_string(i8* %path){
entry:
	%v0 = alloca i64; var: file_size
	%v1 = alloca %struct.string.String; var: buffer
	%v2 = alloca i32; var: bytes_read
	%tmp0 = call i8* @CreateFileA(i8* %path, i32 2147483648, i32 1, i8* null, i32 3, i32 128, i8* null)
	%tmp1 = inttoptr i64 -1 to i8*
	%tmp2 = icmp eq ptr %tmp0, %tmp1
	br i1 %tmp2, label %then168, label %endif168
then168:
	%tmp3 = call i8* @string_utils.insert(i8* @.str.78, i8* %path, i32 16)
	call void @process.throw(i8* %tmp3)
	br label %endif168
	br label %endif168
endif168:
	store i64 0, i64* %v0
	%tmp4 = call i32 @GetFileSizeEx(i8* %tmp0, i64* %v0)
	%tmp5 = icmp eq i32 %tmp4, 0
	br i1 %tmp5, label %then169, label %endif169
then169:
	call i32 @CloseHandle(i8* %tmp0)
	%tmp6 = call %struct.string.String @string.empty()
	br label %func_exit
	br label %endif169
	br label %endif169
endif169:
	%tmp7 = load i64, i64* %v0
	%tmp8 = trunc i64 %tmp7 to i32
	%tmp9 = call %struct.string.String @string.with_size(i32 %tmp8)
	store %struct.string.String %tmp9, %struct.string.String* %v1
	store i32 0, i32* %v2
	%tmp10 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 0
	%tmp11 = load i8*, i8** %tmp10
	%tmp12 = load i64, i64* %v0
	%tmp13 = trunc i64 %tmp12 to i32
	%tmp14 = call i32 @ReadFile(i8* %tmp0, i8* %tmp11, i32 %tmp13, i32* %v2, i8* null)
	call i32 @CloseHandle(i8* %tmp0)
	%tmp15 = icmp eq i32 %tmp14, 0
	br i1 %tmp15, label %then170, label %endif170
then170:
	call void @string.free(%struct.string.String* %v1)
	call void @process.throw(i8* @.str.79)
	br label %endif170
	br label %endif170
endif170:
	%tmp16 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 1
	%tmp17 = load i64, i64* %v0
	%tmp18 = trunc i64 %tmp17 to i32
	store i32 %tmp18, i32* %tmp16
	%tmp19 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 0
	%tmp20 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 0
	%tmp21 = load i8*, i8** %tmp20
	%tmp22 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 1
	%tmp23 = load i32, i32* %tmp22
	%tmp24 = getelementptr inbounds i8, i8* %tmp21, i32 %tmp23
	store i8 0, i8* %tmp24
	%tmp25 = load %struct.string.String, %struct.string.String* %v1
	br label %func_exit
	unreachable
func_exit:
; Variable buffer is out.
	%final_ret = phi %struct.string.String [ %tmp6, %then169 ], [ %tmp25, %endif170 ]
	ret %struct.string.String %final_ret
}
define i32 @fs.write_to_file(i8* %path, i8* %content, i32 %content_len){
entry:
	%v0 = alloca i32; var: bytes_written
	%tmp5 = alloca i1
	%tmp0 = call i8* @CreateFileA(i8* %path, i32 1073741824, i32 0, i8* null, i32 2, i32 128, i8* null)
	%tmp1 = inttoptr i64 -1 to i8*
	%tmp2 = icmp eq ptr %tmp0, %tmp1
	br i1 %tmp2, label %then171, label %endif171
then171:
	br label %func_exit
	br label %endif171
	br label %endif171
endif171:
	store i32 0, i32* %v0
	%tmp3 = call i32 @WriteFile(i8* %tmp0, i8* %content, i32 %content_len, i32* %v0, i8* null)
	call i32 @CloseHandle(i8* %tmp0)
	%tmp4 = icmp ne i32 %tmp3, 0
	store i1 %tmp4, i1* %tmp5
	br i1 %tmp4, label %logic_rhs_172, label %logic_end_172
logic_rhs_172:
	%tmp6 = load i32, i32* %v0
	%tmp7 = icmp eq i32 %tmp6, %content_len
	store i1 %tmp7, i1* %tmp5
	br label %logic_end_172
logic_end_172:
	%tmp8 = load i1, i1* %tmp5
	%tmp9 = zext i1 %tmp8 to i32
	br label %func_exit
	unreachable
func_exit:
	%final_ret = phi i32 [ 0, %then171 ], [ %tmp9, %logic_end_172 ]
	ret i32 %final_ret
}
define i1 @tests.is_valid_number_token(i8 %c){
entry:
	%tmp1 = alloca i1
	%tmp4 = alloca i1
	%tmp0 = call i1 @string_utils.is_ascii_num(i8 %c)
	store i1 %tmp0, i1* %tmp1
	br i1 %tmp0, label %logic_end_173, label %logic_rhs_173
logic_rhs_173:
	%tmp2 = call i1 @string_utils.is_ascii_hex(i8 %c)
	store i1 %tmp2, i1* %tmp1
	br label %logic_end_173
logic_end_173:
	%tmp3 = load i1, i1* %tmp1
	store i1 %tmp3, i1* %tmp4
	br i1 %tmp3, label %logic_end_174, label %logic_rhs_174
logic_rhs_174:
	%tmp5 = icmp eq i8 %c, 95
	store i1 %tmp5, i1* %tmp4
	br label %logic_end_174
logic_end_174:
	%tmp6 = load i1, i1* %tmp4
	br label %func_exit
	unreachable
func_exit:
	%final_ret = phi i1 [ %tmp6, %logic_end_174 ]
	ret i1 %final_ret
}
define i1 @tests.valid_name_token(i8 %c){
entry:
	%tmp1 = alloca i1
	%tmp4 = alloca i1
	%tmp0 = call i1 @string_utils.is_ascii_char(i8 %c)
	store i1 %tmp0, i1* %tmp1
	br i1 %tmp0, label %logic_end_175, label %logic_rhs_175
logic_rhs_175:
	%tmp2 = call i1 @string_utils.is_ascii_num(i8 %c)
	store i1 %tmp2, i1* %tmp1
	br label %logic_end_175
logic_end_175:
	%tmp3 = load i1, i1* %tmp1
	store i1 %tmp3, i1* %tmp4
	br i1 %tmp3, label %logic_end_176, label %logic_rhs_176
logic_rhs_176:
	%tmp5 = icmp eq i8 %c, 95
	store i1 %tmp5, i1* %tmp4
	br label %logic_end_176
logic_end_176:
	%tmp6 = load i1, i1* %tmp4
	br label %func_exit
	unreachable
func_exit:
	%final_ret = phi i1 [ %tmp6, %logic_end_176 ]
	ret i1 %final_ret
}
define i1 @tests.not_new_line(i8 %c){
entry:
	%tmp0 = icmp ne i8 %c, 10
	br label %func_exit
	unreachable
func_exit:
	%final_ret = phi i1 [ %tmp0, %entry ]
	ret i1 %final_ret
}
define void @tests.consume_while(%struct.string.String* %file, i32* %iterator, i1 (i8)* %condition){
entry:
	br label %loop_body177
loop_body177:
	%tmp0 = load i32, i32* %iterator
	%tmp1 = getelementptr inbounds %struct.string.String, %struct.string.String* %file, i32 0, i32 1
	%tmp2 = load i32, i32* %tmp1
	%tmp3 = icmp sge i32 %tmp0, %tmp2
	br i1 %tmp3, label %then178, label %endif178
then178:
	br label %loop_body177_exit
	br label %endif178
	br label %endif178
endif178:
	%tmp4 = getelementptr inbounds %struct.string.String, %struct.string.String* %file, i32 0, i32 0
	%tmp5 = getelementptr inbounds %struct.string.String, %struct.string.String* %file, i32 0, i32 0
	%tmp6 = load i8*, i8** %tmp5
	%tmp7 = load i32, i32* %iterator
	%tmp8 = getelementptr inbounds i8, i8* %tmp6, i32 %tmp7
	%tmp9 = load i8, i8* %tmp8
	%tmp10 = call i1 %condition(i8 %tmp9)
	br i1 %tmp10, label %then179, label %else179
then179:
	%tmp11 = load i32, i32* %iterator
	%tmp12 = add i32 %tmp11, 1
	store i32 %tmp12, i32* %iterator
	br label %endif179
else179:
	br label %loop_body177_exit
	br label %endif179
endif179:
	br label %loop_body177
loop_body177_exit:
	br label %func_exit
func_exit:
	ret void
}
define void @window.draw_bitmap(i8* %hdc, i8* %hBitmap, i32 %x, i32 %y){
entry:
	%v0 = alloca %struct.window.BITMAP; var: bm
	%tmp0 = icmp eq ptr %hBitmap, null
	br i1 %tmp0, label %then180, label %endif180
then180:
	br label %func_exit
	br label %endif180
	br label %endif180
endif180:
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
define i32 @mem.compare(i8* %left, i8* %right, i64 %len){
entry:
	%v0 = alloca i64; var: i
	store i64 0, i64* %v0
	br label %loop_body181
loop_body181:
	%tmp0 = load i64, i64* %v0
	%tmp1 = icmp sge i64 %tmp0, %len
	br i1 %tmp1, label %then182, label %endif182
then182:
	br label %loop_body181_exit
	br label %endif182
	br label %endif182
endif182:
	%tmp2 = load i64, i64* %v0
	%tmp3 = getelementptr inbounds i8, i8* %left, i64 %tmp2
	%tmp4 = load i8, i8* %tmp3
	%tmp5 = load i64, i64* %v0
	%tmp6 = getelementptr inbounds i8, i8* %right, i64 %tmp5
	%tmp7 = load i8, i8* %tmp6
	%tmp8 = icmp slt i8 %tmp4, %tmp7
	br i1 %tmp8, label %then183, label %endif183
then183:
	br label %func_exit
	br label %endif183
	br label %endif183
endif183:
	%tmp9 = load i64, i64* %v0
	%tmp10 = getelementptr inbounds i8, i8* %left, i64 %tmp9
	%tmp11 = load i8, i8* %tmp10
	%tmp12 = load i64, i64* %v0
	%tmp13 = getelementptr inbounds i8, i8* %right, i64 %tmp12
	%tmp14 = load i8, i8* %tmp13
	%tmp15 = icmp sgt i8 %tmp11, %tmp14
	br i1 %tmp15, label %then184, label %endif184
then184:
	br label %func_exit
	br label %endif184
	br label %endif184
endif184:
	%tmp16 = load i64, i64* %v0
	%tmp17 = add i64 %tmp16, 1
	store i64 %tmp17, i64* %v0
	br label %loop_body181
loop_body181_exit:
	br label %func_exit
	unreachable
func_exit:
	%final_ret = phi i32 [ -1, %then183 ], [ 1, %then184 ], [ 0, %loop_body181_exit ]
	ret i32 %final_ret
}
define %struct.string.String @string.empty(){
entry:
	%v0 = alloca %struct.string.String; var: x
	%tmp0 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
	store i8* null, i8** %tmp0
	%tmp1 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	store i32 0, i32* %tmp1
	%tmp2 = load %struct.string.String, %struct.string.String* %v0
	br label %func_exit
	unreachable
func_exit:
; Variable x is out.
	%final_ret = phi %struct.string.String [ %tmp2, %entry ]
	ret %struct.string.String %final_ret
}
define void @"list.free<i32>"(%"struct.list.List<i32>"* %list){
entry:
	%v0 = alloca %"struct.list.ListNode<i32>"*; var: current
	%v1 = alloca %"struct.list.ListNode<i32>"*; var: next
	%tmp0 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %list, i32 0, i32 0
	%tmp1 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %tmp0
	store %"struct.list.ListNode<i32>"* %tmp1, %"struct.list.ListNode<i32>"** %v0
	br label %loop_body185
loop_body185:
	%tmp2 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v0
	%tmp3 = icmp eq ptr %tmp2, null
	br i1 %tmp3, label %then186, label %endif186
then186:
	br label %loop_body185_exit
	br label %endif186
	br label %endif186
endif186:
	%tmp4 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v0
	%tmp5 = getelementptr inbounds %"struct.list.ListNode<i32>", %"struct.list.ListNode<i32>"* %tmp4, i32 0, i32 1
	%tmp6 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %tmp5
	store %"struct.list.ListNode<i32>"* %tmp6, %"struct.list.ListNode<i32>"** %v1
	%tmp7 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v0
	call void @mem.free(i8* %tmp7)
	%tmp8 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v1
	store %"struct.list.ListNode<i32>"* %tmp8, %"struct.list.ListNode<i32>"** %v0
	br label %loop_body185
loop_body185_exit:
	%tmp9 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %list, i32 0, i32 0
	store %"struct.list.ListNode<i32>"* null, %"struct.list.ListNode<i32>"** %tmp9
	%tmp10 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %list, i32 0, i32 1
	store %"struct.list.ListNode<i32>"* null, %"struct.list.ListNode<i32>"** %tmp10
	%tmp11 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %list, i32 0, i32 2
	store i32 0, i32* %tmp11
	br label %func_exit
func_exit:
	ret void
}
define i32 @"list.walk<i32>"(%"struct.list.List<i32>"* %list){
entry:
	%v0 = alloca i32; var: l
	%v1 = alloca %"struct.list.ListNode<i32>"*; var: ptr
	store i32 0, i32* %v0
	%tmp0 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %list, i32 0, i32 0
	%tmp1 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %tmp0
	store %"struct.list.ListNode<i32>"* %tmp1, %"struct.list.ListNode<i32>"** %v1
	br label %loop_body187
loop_body187:
	%tmp2 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v1
	%tmp3 = icmp eq ptr %tmp2, null
	br i1 %tmp3, label %then188, label %endif188
then188:
	br label %loop_body187_exit
	br label %endif188
	br label %endif188
endif188:
	%tmp4 = load i32, i32* %v0
	%tmp5 = add i32 %tmp4, 1
	store i32 %tmp5, i32* %v0
	%tmp6 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v1
	%tmp7 = getelementptr inbounds %"struct.list.ListNode<i32>", %"struct.list.ListNode<i32>"* %tmp6, i32 0, i32 1
	%tmp8 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %tmp7
	store %"struct.list.ListNode<i32>"* %tmp8, %"struct.list.ListNode<i32>"** %v1
	br label %loop_body187
loop_body187_exit:
	%tmp9 = load i32, i32* %v0
	br label %func_exit
	unreachable
func_exit:
	%final_ret = phi i32 [ %tmp9, %loop_body187_exit ]
	ret i32 %final_ret
}
define void @"list.extend<i32>"(%"struct.list.List<i32>"* %list, i32 %data){
entry:
	%v0 = alloca %"struct.list.ListNode<i32>"*; var: node_to_add
	%tmp0 = call i8* @mem.malloc(i64 16)
	store %"struct.list.ListNode<i32>"* %tmp0, %"struct.list.ListNode<i32>"** %v0
	%tmp1 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v0
	call void @"list.new_node<i32>"(%"struct.list.ListNode<i32>"* %tmp1)
	%tmp2 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v0
	%tmp3 = getelementptr inbounds %"struct.list.ListNode<i32>", %"struct.list.ListNode<i32>"* %tmp2, i32 0, i32 0
	store i32 %data, i32* %tmp3
	%tmp4 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %list, i32 0, i32 0
	%tmp5 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %tmp4
	%tmp6 = icmp eq ptr %tmp5, null
	br i1 %tmp6, label %then189, label %else189
then189:
	%tmp7 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %list, i32 0, i32 0
	%tmp8 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v0
	store %"struct.list.ListNode<i32>"* %tmp8, %"struct.list.ListNode<i32>"** %tmp7
	%tmp9 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %list, i32 0, i32 1
	%tmp10 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v0
	store %"struct.list.ListNode<i32>"* %tmp10, %"struct.list.ListNode<i32>"** %tmp9
	br label %endif189
else189:
	%tmp11 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %list, i32 0, i32 1
	%tmp12 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %list, i32 0, i32 1
	%tmp13 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %tmp12
	%tmp14 = getelementptr inbounds %"struct.list.ListNode<i32>", %"struct.list.ListNode<i32>"* %tmp13, i32 0, i32 1
	%tmp15 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v0
	store %"struct.list.ListNode<i32>"* %tmp15, %"struct.list.ListNode<i32>"** %tmp14
	%tmp16 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %list, i32 0, i32 1
	%tmp17 = load %"struct.list.ListNode<i32>"*, %"struct.list.ListNode<i32>"** %v0
	store %"struct.list.ListNode<i32>"* %tmp17, %"struct.list.ListNode<i32>"** %tmp16
	br label %endif189
endif189:
	%tmp18 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %list, i32 0, i32 2
	%tmp19 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %list, i32 0, i32 2
	%tmp20 = load i32, i32* %tmp19
	%tmp21 = add i32 %tmp20, 1
	store i32 %tmp21, i32* %tmp18
	br label %func_exit
func_exit:
	ret void
}
define %"struct.list.List<i32>" @"list.new<i32>"(){
entry:
	%v0 = alloca %"struct.list.List<i32>"; var: list
	%tmp0 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %v0, i32 0, i32 0
	store %"struct.list.ListNode<i32>"* null, %"struct.list.ListNode<i32>"** %tmp0
	%tmp1 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %v0, i32 0, i32 1
	store %"struct.list.ListNode<i32>"* null, %"struct.list.ListNode<i32>"** %tmp1
	%tmp2 = getelementptr inbounds %"struct.list.List<i32>", %"struct.list.List<i32>"* %v0, i32 0, i32 2
	store i32 0, i32* %tmp2
	%tmp3 = load %"struct.list.List<i32>", %"struct.list.List<i32>"* %v0
	br label %func_exit
	unreachable
func_exit:
; Variable list is out.
	%final_ret = phi %"struct.list.List<i32>" [ %tmp3, %entry ]
	ret %"struct.list.List<i32>" %final_ret
}
define void @"vector.free<i8>"(%"struct.vector.Vec<i8>"* %vec){
entry:
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 0
	%tmp1 = load i8*, i8** %tmp0
	%tmp2 = icmp ne ptr %tmp1, null
	br i1 %tmp2, label %then190, label %endif190
then190:
	%tmp3 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 0
	%tmp4 = load i8*, i8** %tmp3
	call void @mem.free(i8* %tmp4)
	br label %endif190
	br label %endif190
endif190:
	%tmp5 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 0
	store i8* null, i8** %tmp5
	%tmp6 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 1
	store i32 0, i32* %tmp6
	%tmp7 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 2
	store i32 0, i32* %tmp7
	br label %func_exit
func_exit:
	ret void
}
define void @"vector.free<%struct.string.String>"(%"struct.vector.Vec<%struct.string.String>"* %vec){
entry:
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 0
	%tmp1 = load %struct.string.String*, %struct.string.String** %tmp0
	%tmp2 = icmp ne ptr %tmp1, null
	br i1 %tmp2, label %then191, label %endif191
then191:
	%tmp3 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 0
	%tmp4 = load %struct.string.String*, %struct.string.String** %tmp3
	call void @mem.free(i8* %tmp4)
	br label %endif191
	br label %endif191
endif191:
	%tmp5 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 0
	store %struct.string.String* null, %struct.string.String** %tmp5
	%tmp6 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 1
	store i32 0, i32* %tmp6
	%tmp7 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 2
	store i32 0, i32* %tmp7
	br label %func_exit
func_exit:
	ret void
}
define void @"vector.push_bulk<i8>"(%"struct.vector.Vec<i8>"* %vec, i8* %data, i32 %data_len){
entry:
	%v0 = alloca i32; var: index
	store i32 0, i32* %v0
	br label %loop_body192
loop_body192:
	%tmp0 = load i32, i32* %v0
	%tmp1 = icmp sge i32 %tmp0, %data_len
	br i1 %tmp1, label %then193, label %endif193
then193:
	br label %loop_body192_exit
	br label %endif193
	br label %endif193
endif193:
	%tmp2 = load i32, i32* %v0
	%tmp3 = getelementptr inbounds i8, i8* %data, i32 %tmp2
	%tmp4 = load i8, i8* %tmp3
	call void @"vector.push<i8>"(%"struct.vector.Vec<i8>"* %vec, i8 %tmp4)
	%tmp5 = load i32, i32* %v0
	%tmp6 = add i32 %tmp5, 1
	store i32 %tmp6, i32* %v0
	br label %loop_body192
loop_body192_exit:
	br label %func_exit
func_exit:
	ret void
}
define void @"vector.push<i8>"(%"struct.vector.Vec<i8>"* %vec, i8 %data){
entry:
	%v0 = alloca i32; var: new_capacity
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 2
	%tmp3 = load i32, i32* %tmp2
	%tmp4 = icmp uge i32 %tmp1, %tmp3
	br i1 %tmp4, label %then194, label %endif194
then194:
	store i32 4, i32* %v0
	%tmp5 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 2
	%tmp6 = load i32, i32* %tmp5
	%tmp7 = icmp ne i32 %tmp6, 0
	br i1 %tmp7, label %then195, label %endif195
then195:
	%tmp8 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 2
	%tmp9 = load i32, i32* %tmp8
	%tmp10 = mul i32 %tmp9, 2
	store i32 %tmp10, i32* %v0
	br label %endif195
	br label %endif195
endif195:
	%tmp11 = load i32, i32* %v0
	%tmp12 = zext i32 %tmp11 to i64
	%tmp13 = mul i64 1, %tmp12
	%tmp14 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 0
	%tmp15 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 0
	%tmp16 = load i8*, i8** %tmp15
	%tmp17 = call i8* @mem.realloc(i8* %tmp16, i64 %tmp13)
	store i8* %tmp17, i8** %tmp14
	%tmp18 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 2
	%tmp19 = load i32, i32* %v0
	store i32 %tmp19, i32* %tmp18
	br label %endif194
	br label %endif194
endif194:
	%tmp20 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 0
	%tmp21 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 0
	%tmp22 = load i8*, i8** %tmp21
	%tmp23 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 1
	%tmp24 = load i32, i32* %tmp23
	%tmp25 = getelementptr inbounds i8, i8* %tmp22, i32 %tmp24
	store i8 %data, i8* %tmp25
	%tmp26 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 1
	%tmp27 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %vec, i32 0, i32 1
	%tmp28 = load i32, i32* %tmp27
	%tmp29 = add i32 %tmp28, 1
	store i32 %tmp29, i32* %tmp26
	br label %func_exit
func_exit:
	ret void
}
define void @"vector.push<%struct.string.String>"(%"struct.vector.Vec<%struct.string.String>"* %vec, %struct.string.String %data){
entry:
	%v0 = alloca i32; var: new_capacity
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 2
	%tmp3 = load i32, i32* %tmp2
	%tmp4 = icmp uge i32 %tmp1, %tmp3
	br i1 %tmp4, label %then196, label %endif196
then196:
	store i32 4, i32* %v0
	%tmp5 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 2
	%tmp6 = load i32, i32* %tmp5
	%tmp7 = icmp ne i32 %tmp6, 0
	br i1 %tmp7, label %then197, label %endif197
then197:
	%tmp8 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 2
	%tmp9 = load i32, i32* %tmp8
	%tmp10 = mul i32 %tmp9, 2
	store i32 %tmp10, i32* %v0
	br label %endif197
	br label %endif197
endif197:
	%tmp11 = load i32, i32* %v0
	%tmp12 = zext i32 %tmp11 to i64
	%tmp13 = mul i64 16, %tmp12
	%tmp14 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 0
	%tmp15 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 0
	%tmp16 = load %struct.string.String*, %struct.string.String** %tmp15
	%tmp17 = call i8* @mem.realloc(i8* %tmp16, i64 %tmp13)
	store %struct.string.String* %tmp17, %struct.string.String** %tmp14
	%tmp18 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 2
	%tmp19 = load i32, i32* %v0
	store i32 %tmp19, i32* %tmp18
	br label %endif196
	br label %endif196
endif196:
	%tmp20 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 0
	%tmp21 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 0
	%tmp22 = load %struct.string.String*, %struct.string.String** %tmp21
	%tmp23 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 1
	%tmp24 = load i32, i32* %tmp23
	%tmp25 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp22, i32 %tmp24
	store %struct.string.String %data, %struct.string.String* %tmp25
	%tmp26 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 1
	%tmp27 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 1
	%tmp28 = load i32, i32* %tmp27
	%tmp29 = add i32 %tmp28, 1
	store i32 %tmp29, i32* %tmp26
	br label %func_exit
func_exit:
; Variable data is out.
	ret void
}
define %"struct.vector.Vec<i8>" @"vector.new<i8>"(){
entry:
	%v0 = alloca %"struct.vector.Vec<i8>"; var: vec
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 0
	store i8* null, i8** %tmp0
	%tmp1 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 1
	store i32 0, i32* %tmp1
	%tmp2 = getelementptr inbounds %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0, i32 0, i32 2
	store i32 0, i32* %tmp2
	%tmp3 = load %"struct.vector.Vec<i8>", %"struct.vector.Vec<i8>"* %v0
	br label %func_exit
	unreachable
func_exit:
; Variable vec is out.
	%final_ret = phi %"struct.vector.Vec<i8>" [ %tmp3, %entry ]
	ret %"struct.vector.Vec<i8>" %final_ret
}
define %"struct.vector.Vec<i64>" @"vector.new<i64>"(){
entry:
	%v0 = alloca %"struct.vector.Vec<i64>"; var: vec
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<i64>", %"struct.vector.Vec<i64>"* %v0, i32 0, i32 0
	store i64* null, i64** %tmp0
	%tmp1 = getelementptr inbounds %"struct.vector.Vec<i64>", %"struct.vector.Vec<i64>"* %v0, i32 0, i32 1
	store i32 0, i32* %tmp1
	%tmp2 = getelementptr inbounds %"struct.vector.Vec<i64>", %"struct.vector.Vec<i64>"* %v0, i32 0, i32 2
	store i32 0, i32* %tmp2
	%tmp3 = load %"struct.vector.Vec<i64>", %"struct.vector.Vec<i64>"* %v0
	br label %func_exit
	unreachable
func_exit:
; Variable vec is out.
	%final_ret = phi %"struct.vector.Vec<i64>" [ %tmp3, %entry ]
	ret %"struct.vector.Vec<i64>" %final_ret
}
define %"struct.vector.Vec<%struct.string.String>" @"vector.new<%struct.string.String>"(){
entry:
	%v0 = alloca %"struct.vector.Vec<%struct.string.String>"; var: vec
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %v0, i32 0, i32 0
	store %struct.string.String* null, %struct.string.String** %tmp0
	%tmp1 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %v0, i32 0, i32 1
	store i32 0, i32* %tmp1
	%tmp2 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %v0, i32 0, i32 2
	store i32 0, i32* %tmp2
	%tmp3 = load %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %v0
	br label %func_exit
	unreachable
func_exit:
; Variable vec is out.
	%final_ret = phi %"struct.vector.Vec<%struct.string.String>" [ %tmp3, %entry ]
	ret %"struct.vector.Vec<%struct.string.String>" %final_ret
}
define %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>" @"ax<i32>"(){
entry:
	%v0 = alloca %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>"; var: p
	%tmp0 = getelementptr inbounds %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>", %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>"* %v0, i32 0, i32 0
	store i32 43, i32* %tmp0
	%tmp1 = getelementptr inbounds %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>", %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>"* %v0, i32 0, i32 1
	%tmp2 = getelementptr inbounds %"struct.Pair<i8, %struct.string.String>", %"struct.Pair<i8, %struct.string.String>"* %tmp1, i32 0, i32 0
	store i8 126, i8* %tmp2
	%tmp3 = load %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>", %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>"* %v0
	br label %func_exit
	unreachable
func_exit:
; Variable p is out.
	%final_ret = phi %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>" [ %tmp3, %entry ]
	ret %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>" %final_ret
}
define i8* @mem.realloc(i8* %ptr, i64 %size){
entry:
	%tmp0 = icmp eq ptr %ptr, null
	br i1 %tmp0, label %then198, label %endif198
then198:
	%tmp1 = call i8* @mem.malloc(i64 %size)
	br label %func_exit
	br label %endif198
	br label %endif198
endif198:
	%tmp2 = call i32* @GetProcessHeap()
	%tmp3 = call i8* @HeapReAlloc(i32* %tmp2, i32 0, i8* %ptr, i64 %size)
	%tmp4 = icmp eq ptr %tmp3, null
	br i1 %tmp4, label %then199, label %endif199
then199:
	call void @process.throw(i8* @.str.80)
	br label %endif199
	br label %endif199
endif199:
	br label %func_exit
	unreachable
func_exit:
	%final_ret = phi i8* [ %tmp1, %then198 ], [ %tmp3, %endif199 ]
	ret i8* %final_ret
}
define void @"list.new_node<i32>"(%"struct.list.ListNode<i32>"* %list){
entry:
	%tmp0 = getelementptr inbounds %"struct.list.ListNode<i32>", %"struct.list.ListNode<i32>"* %list, i32 0, i32 1
	store %"struct.list.ListNode<i32>"* null, %"struct.list.ListNode<i32>"** %tmp0
	%tmp1 = getelementptr inbounds %"struct.list.ListNode<i32>", %"struct.list.ListNode<i32>"* %list, i32 0, i32 0
	store i32 0, i32* %tmp1
	br label %func_exit
func_exit:
	ret void
}

;func basic_functions []
;func ax []
;func xq []
;func main []
;func __chkstk ["no_lazy"]
;func _fltused ["no_lazy"]
;func window.WindowProc []
;func window.draw_bitmap []
;func window.is_null []
;func window.start []
;func tests.run []
;func tests.mem_test []
;func tests.string_utils_test []
;func tests.string_test []
;func tests.vector_test []
;func tests.list_test []
;func tests.process_test []
;func tests.console_test []
;func tests.fs_test []
;func tests.consume_while []
;func tests.not_new_line []
;func tests.valid_name_token []
;func tests.is_valid_number_token []
;func tests.funny []
;func fs.write_to_file []
;func fs.read_full_file_as_string []
;func fs.create_file []
;func fs.delete_file []
;func string_utils.insert []
;func string_utils.c_str_len []
;func string_utils.is_ascii_num []
;func string_utils.is_ascii_char []
;func string_utils.is_ascii_hex []
;func string.from_c_string []
;func string.empty []
;func string.with_size []
;func string.concat_with_c_string ["ExtentionOf"]
;func string.equal ["ExtentionOf"]
;func string.free ["ExtentionOf"]
;func string.as_c_string_stalloc ["ExtentionOf"]
;func console.get_stdout []
;func console.write []
;func console.writeln []
;func console.print_char []
;func console.println_i64 []
;func console.println_u64 []
;func console.println_f64 []
;func vector.new []
;func vector.push ["ExtentionOf"]
;func vector.push_bulk ["ExtentionOf"]
;func vector.free ["ExtentionOf"]
;func list.new []
;func list.new_node []
;func list.extend []
;func list.walk []
;func list.free []
;func mem.malloc []
;func mem.realloc []
;func mem.free []
;func mem.copy []
;func mem.compare []
;func mem.fill []
;func mem.zero_fill []
;func mem.get_total_allocated_memory_external []
;func process.get_executable_path []
;func process.get_executable_env_path []
;func process.throw []
;func test.geg []
;type Pair
;type window.POINT
;type window.MSG
;type window.WNDCLASSEXA
;type window.RECT
;type window.PAINTSTRUCT
;type window.BITMAP
;type string.String
;type vector.Vec
;type list.List
;type list.ListNode
;type mem.PROCESS_HEAP_ENTRY
;type test.QPair
