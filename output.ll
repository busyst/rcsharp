target triple = "x86_64-pc-windows-msvc"
%struct.list.List = type { %struct.list.ListNode*, %struct.list.ListNode*, i32 }
%struct.list.ListNode = type { %struct.list.ListNode*, i32 }
%struct.vector.Vec = type { i8*, i32, i32 }
%struct.string.String = type { i8*, i32 }
%struct.window.WNDCLASSEXA = type { i32, i32, i64 (i8*, i32, i64, i64)**, i32, i32, i8*, i8*, i8*, i8*, i8*, i8*, i8* }
%struct.window.POINT = type { i32, i32 }
%struct.window.MSG = type { i8*, i32, i64, i64, i32, %struct.window.POINT }
declare dllimport void @ExitProcess(i32)
declare dllimport i32 @GetModuleFileNameA(i8*,i8*,i32)
declare dllimport i32* @GetProcessHeap()
declare dllimport i8* @HeapAlloc(i32*,i32,i64)
declare dllimport i32 @HeapFree(i32*,i32,i8*)
declare dllimport i64 @HeapSize(i32*,i32,i8*)
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
declare dllimport i32 @GetMessageA(%struct.window.MSG*,i8*,i32,i32)
declare dllimport i32 @TranslateMessage(%struct.window.MSG*)
declare dllimport i64 @DispatchMessageA(%struct.window.MSG*)
declare dllimport i64 @DefWindowProcA(i8*,i32,i64,i64)
declare dllimport void @PostQuitMessage(i32)
declare dllimport i8* @GetModuleHandleA(i8*)
@.str.0 = private unnamed_addr constant [12 x i8] c"Exception: \00"
@.str.1 = private unnamed_addr constant [2 x i8] c"-\00"
@.str.2 = private unnamed_addr constant [20 x i8] c"File  was not found\00"
@.str.3 = private unnamed_addr constant [17 x i8] c"File read failed\00"
@.str.4 = private unnamed_addr constant [10 x i8] c"fs_test: \00"
@.str.5 = private unnamed_addr constant [47 x i8] c"The quick brown fox jumps over crazy lost dog.\00"
@.str.6 = private unnamed_addr constant [9 x i8] c"test.txt\00"
@.str.7 = private unnamed_addr constant [38 x i8] c"Filesystem test failed, data mismatch\00"
@.str.8 = private unnamed_addr constant [3 x i8] c"OK\00"
@.str.9 = private unnamed_addr constant [32 x i8] c"D:\Projects\rcsharp\src.rcsharp\00"
@.str.10 = private unnamed_addr constant [14 x i8] c"MyWindowClass\00"
@.str.11 = private unnamed_addr constant [14 x i8] c"Hello, World!\00"


define void @__chkstk() {
    ret void
}

define %struct.string.String @process.get_executable_path() {
    %string = alloca %struct.string.String
    %tmp0 = call %struct.string.String @string.with_size(i32 260)
    store %struct.string.String %tmp0, %struct.string.String* %string
    %len = alloca i32
    %tmp1 = getelementptr inbounds %struct.string.String, %struct.string.String* %string, i32 0, i32 0
    %tmp2 = load i8*, i8** %tmp1
    %tmp3 = getelementptr inbounds %struct.string.String, %struct.string.String* %string, i32 0, i32 1
    %tmp4 = load i32, i32* %tmp3
    %tmp5 = call i32 @GetModuleFileNameA(i8* null, i8* %tmp2, i32 %tmp4)
    store i32 %tmp5, i32* %len
    %tmp6 = getelementptr inbounds %struct.string.String, %struct.string.String* %string, i32 0, i32 1
    %tmp7 = load i32, i32* %len
    store i32 %tmp7, i32* %tmp6
    %tmp8 = load %struct.string.String, %struct.string.String* %string
    ret %struct.string.String %tmp8
}

define %struct.string.String @process.get_executable_env_path() {
    %string = alloca %struct.string.String
    %tmp0 = call %struct.string.String @process.get_executable_path()
    store %struct.string.String %tmp0, %struct.string.String* %string
    %index = alloca i32
    %tmp1 = getelementptr inbounds %struct.string.String, %struct.string.String* %string, i32 0, i32 1
    %tmp2 = load i32, i32* %tmp1
    %tmp3 = sub i32 %tmp2, 1
    store i32 %tmp3, i32* %index
    br label %loop_body0
loop_body0:
    %tmp4 = getelementptr inbounds %struct.string.String, %struct.string.String* %string, i32 0, i32 0
    %tmp5 = load i8*, i8** %tmp4
    %tmp6 = load i32, i32* %index
    %tmp7 = mul i32 %tmp6, 1    %tmp8 = getelementptr inbounds i8, i8* %tmp5, i32 %tmp7
    %tmp9 = load i8, i8* %tmp8
    %tmp10 = icmp eq i8 %tmp9, 92
    %tmp11 = load i32, i32* %index
    %tmp12 = icmp slt i32 %tmp11, 0
    %tmp13 = or i1 %tmp10, %tmp12
    br i1 %tmp13, label %then1, label %endif1
then1:
    br label %loop_body0_exit
    br label %endif1
endif1:
    %tmp14 = load i32, i32* %index
    %tmp15 = sub i32 %tmp14, 1
    store i32 %tmp15, i32* %index
    br label %loop_body0
loop_body0_exit:
    %tmp16 = getelementptr inbounds %struct.string.String, %struct.string.String* %string, i32 0, i32 1
    %tmp17 = load i32, i32* %index
    %tmp18 = add i32 %tmp17, 1
    store i32 %tmp18, i32* %tmp16
    %tmp19 = load %struct.string.String, %struct.string.String* %string
    ret %struct.string.String %tmp19
}

define void @process.throw(i8* %exception) {
    %len = alloca i32
    %tmp0 = call i32 @string_utils.c_str_len(i8* %exception)
    store i32 %tmp0, i32* %len
    %tmp1 = call i32 @AllocConsole()
    %chars_written = alloca i32
    %stdout_handle = alloca i8*
    %tmp2 = call i8* @GetStdHandle(i32 -11)
    store i8* %tmp2, i8** %stdout_handle
    %e = alloca i8*
    %tmp3 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.0, i64 0, i64 0
    store i8* %tmp3, i8** %e
    %tmp4 = load i8*, i8** %stdout_handle
    %tmp5 = load i8*, i8** %e
    %tmp6 = load i8*, i8** %e
    %tmp7 = call i32 @string_utils.c_str_len(i8* %tmp6)
    %tmp8 = call i32 @WriteConsoleA(i8* %tmp4, i8* %tmp5, i32 %tmp7, i32* %chars_written, i8* null)
    %tmp9 = load i8*, i8** %stdout_handle
    %tmp10 = load i32, i32* %len
    %tmp11 = call i32 @WriteConsoleA(i8* %tmp9, i8* %exception, i32 %tmp10, i32* %chars_written, i8* null)
    %nl = alloca i8
    store i8 10, i8* %nl
    %tmp12 = load i8*, i8** %stdout_handle
    %tmp13 = call i32 @WriteConsoleA(i8* %tmp12, i8* %nl, i32 1, i32* %chars_written, i8* null)
    call void @ExitProcess(i32 -1)
    ret void
}

define i8* @mem.malloc(i64 %size) {
    %tmp0 = call i32* @GetProcessHeap()
    %tmp1 = call i8* @HeapAlloc(i32* %tmp0, i32 0, i64 %size)
    ret i8* %tmp1
}

define void @mem.free(i8* %ptr) {
    %tmp0 = call i32* @GetProcessHeap()
    %tmp1 = call i32 @HeapFree(i32* %tmp0, i32 0, i8* %ptr)
    ret void
}

define void @mem.copy(i8* %src, i8* %dest, i64 %len) {
    %i = alloca i64
    store i64 0, i64* %i
    br label %loop_body0
loop_body0:
    %tmp0 = load i64, i64* %i
    %tmp1 = icmp sge i64 %tmp0, %len
    br i1 %tmp1, label %then1, label %endif1
then1:
    br label %loop_body0_exit
    br label %endif1
endif1:
    %tmp2 = load i64, i64* %i
    %tmp3 = mul i64 %tmp2, 1    %tmp4 = getelementptr inbounds i8, i8* %dest, i64 %tmp3
    %tmp5 = load i64, i64* %i
    %tmp6 = mul i64 %tmp5, 1    %tmp7 = getelementptr inbounds i8, i8* %src, i64 %tmp6
    %tmp8 = load i8, i8* %tmp7
    store i8 %tmp8, i8* %tmp4
    %tmp9 = load i64, i64* %i
    %tmp10 = add i64 %tmp9, 1
    store i64 %tmp10, i64* %i
    br label %loop_body0
loop_body0_exit:
    ret void
}

define void @mem.zerofill(i8 %val, i8* %dest, i64 %len) {
    call void @mem.fill(i8 0, i8* %dest, i64 %len)
    ret void
}

define void @mem.fill(i8 %val, i8* %dest, i64 %len) {
    %i = alloca i64
    store i64 0, i64* %i
    br label %loop_body0
loop_body0:
    %tmp0 = load i64, i64* %i
    %tmp1 = icmp sge i64 %tmp0, %len
    br i1 %tmp1, label %then1, label %endif1
then1:
    br label %loop_body0_exit
    br label %endif1
endif1:
    %tmp2 = load i64, i64* %i
    %tmp3 = mul i64 %tmp2, 1    %tmp4 = getelementptr inbounds i8, i8* %dest, i64 %tmp3
    store i8 %val, i8* %tmp4
    %tmp5 = load i64, i64* %i
    %tmp6 = add i64 %tmp5, 1
    store i64 %tmp6, i64* %i
    br label %loop_body0
loop_body0_exit:
    ret void
}

define void @list.new(%struct.list.List* %list) {
    %tmp0 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 0
    store %struct.list.ListNode* null, %struct.list.ListNode** %tmp0
    %tmp1 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 1
    store %struct.list.ListNode* null, %struct.list.ListNode** %tmp1
    %tmp2 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 2
    store i32 0, i32* %tmp2
    ret void
}

define void @list.new_node(%struct.list.ListNode* %list) {
    %tmp0 = getelementptr inbounds %struct.list.ListNode, %struct.list.ListNode* %list, i32 0, i32 0
    store %struct.list.ListNode* null, %struct.list.ListNode** %tmp0
    %tmp1 = getelementptr inbounds %struct.list.ListNode, %struct.list.ListNode* %list, i32 0, i32 1
    store i32 0, i32* %tmp1
    ret void
}

define void @list.extend(%struct.list.List* %list, i32 %data) {
    %new_node = alloca %struct.list.ListNode*
    %tmp0 = call i8* @mem.malloc(i64 12)
    %tmp1 = bitcast i8* %tmp0 to %struct.list.ListNode*
    store %struct.list.ListNode* %tmp1, %struct.list.ListNode** %new_node
    %tmp2 = getelementptr inbounds %struct.list.ListNode, %struct.list.ListNode* %new_node, i32 0, i32 0
    store %struct.list.ListNode* null, %struct.list.ListNode** %tmp2
    %tmp3 = getelementptr inbounds %struct.list.ListNode, %struct.list.ListNode* %new_node, i32 0, i32 1
    store i32 %data, i32* %tmp3
    %tmp4 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 0
    %tmp5 = load %struct.list.ListNode*, %struct.list.ListNode** %tmp4
    %tmp6 = icmp eq ptr %tmp5, null
    br i1 %tmp6, label %then0, label %else0
then0:
    %tmp7 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 0
    %tmp8 = load %struct.list.ListNode*, %struct.list.ListNode** %new_node
    store %struct.list.ListNode* %tmp8, %struct.list.ListNode** %tmp7
    %tmp9 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 1
    %tmp10 = load %struct.list.ListNode*, %struct.list.ListNode** %new_node
    store %struct.list.ListNode* %tmp10, %struct.list.ListNode** %tmp9
    br label %endif0
else0:
    %tmp11 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 1
    %tmp12 = getelementptr inbounds %struct.list.ListNode, %struct.list.ListNode* %tmp11, i32 0, i32 0
    %tmp13 = load %struct.list.ListNode*, %struct.list.ListNode** %new_node
    store %struct.list.ListNode* %tmp13, %struct.list.ListNode** %tmp12
    %tmp14 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 1
    %tmp15 = load %struct.list.ListNode*, %struct.list.ListNode** %new_node
    store %struct.list.ListNode* %tmp15, %struct.list.ListNode** %tmp14
    br label %endif0
endif0:
    %tmp16 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 2
    %tmp17 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 2
    %tmp18 = load i32, i32* %tmp17
    %tmp19 = add i32 %tmp18, 1
    store i32 %tmp19, i32* %tmp16
    ret void
}

define i32 @list.walk(%struct.list.List* %list) {
    %l = alloca i32
    store i32 0, i32* %l
    %ptr = alloca %struct.list.ListNode*
    %tmp0 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 0
    %tmp1 = load %struct.list.ListNode*, %struct.list.ListNode** %tmp0
    store %struct.list.ListNode* %tmp1, %struct.list.ListNode** %ptr
    br label %loop_body0
loop_body0:
    %tmp2 = load %struct.list.ListNode*, %struct.list.ListNode** %ptr
    %tmp3 = icmp eq ptr %tmp2, null
    br i1 %tmp3, label %then1, label %endif1
then1:
    br label %loop_body0_exit
    br label %endif1
endif1:
    %tmp4 = load i32, i32* %l
    %tmp5 = add i32 %tmp4, 1
    store i32 %tmp5, i32* %l
    %tmp6 = getelementptr inbounds %struct.list.ListNode, %struct.list.ListNode* %ptr, i32 0, i32 0
    %tmp7 = load %struct.list.ListNode*, %struct.list.ListNode** %tmp6
    store %struct.list.ListNode* %tmp7, %struct.list.ListNode** %ptr
    br label %loop_body0
loop_body0_exit:
    %tmp8 = load i32, i32* %l
    ret i32 %tmp8
}

define void @list.free(%struct.list.List* %list) {
    %current = alloca %struct.list.ListNode*
    %tmp0 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 0
    %tmp1 = load %struct.list.ListNode*, %struct.list.ListNode** %tmp0
    store %struct.list.ListNode* %tmp1, %struct.list.ListNode** %current
    br label %loop_body0
loop_body0:
    %tmp2 = load %struct.list.ListNode*, %struct.list.ListNode** %current
    %tmp3 = icmp eq ptr %tmp2, null
    br i1 %tmp3, label %then1, label %endif1
then1:
    br label %loop_body0_exit
    br label %endif1
endif1:
    %next = alloca %struct.list.ListNode*
    %tmp4 = getelementptr inbounds %struct.list.ListNode, %struct.list.ListNode* %current, i32 0, i32 0
    %tmp5 = load %struct.list.ListNode*, %struct.list.ListNode** %tmp4
    store %struct.list.ListNode* %tmp5, %struct.list.ListNode** %next
    %tmp6 = load %struct.list.ListNode*, %struct.list.ListNode** %current
    %tmp7 = bitcast %struct.list.ListNode* %tmp6 to i8*
    call void @mem.free(i8* %tmp7)
    %tmp8 = load %struct.list.ListNode*, %struct.list.ListNode** %next
    store %struct.list.ListNode* %tmp8, %struct.list.ListNode** %current
    br label %loop_body0
loop_body0_exit:
    %tmp9 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 0
    store %struct.list.ListNode* null, %struct.list.ListNode** %tmp9
    %tmp10 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 1
    store %struct.list.ListNode* null, %struct.list.ListNode** %tmp10
    %tmp11 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 2
    store i32 0, i32* %tmp11
    ret void
}

define void @vector.new(%struct.vector.Vec* %vec) {
    %tmp0 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 0
    store i8* null, i8** %tmp0
    %tmp1 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 1
    store i32 0, i32* %tmp1
    %tmp2 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 2
    store i32 0, i32* %tmp2
    ret void
}

define void @vector.push(%struct.vector.Vec* %vec, i8 %data) {
    %tmp0 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 1
    %tmp1 = load i32, i32* %tmp0
    %tmp2 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 2
    %tmp3 = load i32, i32* %tmp2
    %tmp4 = icmp uge i32 %tmp1, %tmp3
    br i1 %tmp4, label %then0, label %endif0
then0:
    %new_capacity = alloca i32
    store i32 4, i32* %new_capacity
    %tmp5 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 2
    %tmp6 = load i32, i32* %tmp5
    %tmp7 = icmp ne i32 %tmp6, 0
    br i1 %tmp7, label %then1, label %endif1
then1:
    %tmp8 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 2
    %tmp9 = load i32, i32* %tmp8
    %tmp10 = mul i32 %tmp9, 2
    store i32 %tmp10, i32* %new_capacity
    br label %endif1
endif1:
    %new_array = alloca i8*
    %tmp11 = load i32, i32* %new_capacity
    %tmp12 = zext i32 %tmp11 to i64
    %tmp13 = mul i64 %tmp12, 1
    %tmp14 = call i8* @mem.malloc(i64 %tmp13)
    store i8* %tmp14, i8** %new_array
    %tmp15 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 0
    %tmp16 = load i8*, i8** %tmp15
    %tmp17 = icmp ne ptr %tmp16, null
    br i1 %tmp17, label %then2, label %endif2
then2:
    %i = alloca i32
    store i32 0, i32* %i
    br label %loop_body3
loop_body3:
    %tmp18 = load i32, i32* %i
    %tmp19 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 1
    %tmp20 = load i32, i32* %tmp19
    %tmp21 = icmp uge i32 %tmp18, %tmp20
    br i1 %tmp21, label %then4, label %endif4
then4:
    br label %loop_body3_exit
    br label %endif4
endif4:
    %tmp22 = load i8*, i8** %new_array
    %tmp23 = load i32, i32* %i
    %tmp24 = mul i32 %tmp23, 1    %tmp25 = getelementptr inbounds i8, i8* %tmp22, i32 %tmp24
    %tmp26 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 0
    %tmp27 = load i8*, i8** %tmp26
    %tmp28 = load i32, i32* %i
    %tmp29 = mul i32 %tmp28, 1    %tmp30 = getelementptr inbounds i8, i8* %tmp27, i32 %tmp29
    %tmp31 = load i8, i8* %tmp30
    store i8 %tmp31, i8* %tmp25
    %tmp32 = load i32, i32* %i
    %tmp33 = add i32 %tmp32, 1
    store i32 %tmp33, i32* %i
    br label %loop_body3
loop_body3_exit:
    %tmp34 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 0
    %tmp35 = load i8*, i8** %tmp34
    call void @mem.free(i8* %tmp35)
    br label %endif2
endif2:
    %tmp36 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 0
    %tmp37 = load i8*, i8** %new_array
    store i8* %tmp37, i8** %tmp36
    %tmp38 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 2
    %tmp39 = load i32, i32* %new_capacity
    store i32 %tmp39, i32* %tmp38
    br label %endif0
endif0:
    %tmp40 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 0
    %tmp41 = load i8*, i8** %tmp40
    %tmp42 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 1
    %tmp43 = load i32, i32* %tmp42
    %tmp44 = mul i32 %tmp43, 1    %tmp45 = getelementptr inbounds i8, i8* %tmp41, i32 %tmp44
    store i8 %data, i8* %tmp45
    %tmp46 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 1
    %tmp47 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 1
    %tmp48 = load i32, i32* %tmp47
    %tmp49 = add i32 %tmp48, 1
    store i32 %tmp49, i32* %tmp46
    ret void
}

define void @vector.push_bulk(%struct.vector.Vec* %vec, i8* %data, i32 %data_len) {
    %index = alloca i32
    store i32 0, i32* %index
    br label %loop_body0
loop_body0:
    %tmp0 = load i32, i32* %index
    %tmp1 = icmp sge i32 %tmp0, %data_len
    br i1 %tmp1, label %then1, label %endif1
then1:
    br label %loop_body0_exit
    br label %endif1
endif1:
    %tmp2 = load i32, i32* %index
    %tmp3 = mul i32 %tmp2, 1    %tmp4 = getelementptr inbounds i8, i8* %data, i32 %tmp3
    %tmp5 = load i8, i8* %tmp4
    call void @vector.push(%struct.vector.Vec* %vec, i8 %tmp5)
    %tmp6 = load i32, i32* %index
    %tmp7 = add i32 %tmp6, 1
    store i32 %tmp7, i32* %index
    br label %loop_body0
loop_body0_exit:
    ret void
}

define void @vector.free(%struct.vector.Vec* %vec) {
    %tmp0 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 0
    %tmp1 = load i8*, i8** %tmp0
    %tmp2 = icmp ne ptr %tmp1, null
    br i1 %tmp2, label %then0, label %endif0
then0:
    %tmp3 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 0
    %tmp4 = load i8*, i8** %tmp3
    call void @mem.free(i8* %tmp4)
    br label %endif0
endif0:
    %tmp5 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 0
    store i8* null, i8** %tmp5
    %tmp6 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 1
    store i32 0, i32* %tmp6
    %tmp7 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 2
    store i32 0, i32* %tmp7
    ret void
}

define i8* @console.get_stdout() {
    %stdout_handle = alloca i8*
    %tmp0 = call i8* @GetStdHandle(i32 -11)
    store i8* %tmp0, i8** %stdout_handle
    %tmp1 = load i8*, i8** %stdout_handle
    %tmp2 = inttoptr i64 -1 to i8*
    %tmp3 = icmp eq ptr %tmp1, %tmp2
    br i1 %tmp3, label %then0, label %endif0
then0:
    call void @ExitProcess(i32 -1)
    br label %endif0
endif0:
    %tmp4 = load i8*, i8** %stdout_handle
    ret i8* %tmp4
}

define void @console.write(i8* %buffer, i32 %len) {
    %chars_written = alloca i32
    %tmp0 = call i8* @console.get_stdout()
    %tmp1 = call i32 @WriteConsoleA(i8* %tmp0, i8* %buffer, i32 %len, i32* %chars_written, i8* null)
    %tmp2 = load i32, i32* %chars_written
    %tmp3 = icmp ne i32 %len, %tmp2
    br i1 %tmp3, label %then0, label %endif0
then0:
    call void @ExitProcess(i32 -2)
    br label %endif0
endif0:
    ret void
}

define void @console.write_string(%struct.string.String* %str) {
    %chars_written = alloca i32
    %tmp0 = call i8* @console.get_stdout()
    %tmp1 = getelementptr inbounds %struct.string.String, %struct.string.String* %str, i32 0, i32 0
    %tmp2 = load i8*, i8** %tmp1
    %tmp3 = getelementptr inbounds %struct.string.String, %struct.string.String* %str, i32 0, i32 1
    %tmp4 = load i32, i32* %tmp3
    %tmp5 = call i32 @WriteConsoleA(i8* %tmp0, i8* %tmp2, i32 %tmp4, i32* %chars_written, i8* null)
    %tmp6 = getelementptr inbounds %struct.string.String, %struct.string.String* %str, i32 0, i32 1
    %tmp7 = load i32, i32* %tmp6
    %tmp8 = load i32, i32* %chars_written
    %tmp9 = icmp ne i32 %tmp7, %tmp8
    br i1 %tmp9, label %then0, label %endif0
then0:
    call void @ExitProcess(i32 -2)
    br label %endif0
endif0:
    ret void
}

define void @console.writeln(i8* %buffer, i32 %len) {
    %tmp0 = icmp eq i32 %len, 0
    br i1 %tmp0, label %then0, label %endif0
then0:
    ret void
    br label %endif0
endif0:
    %chars_written = alloca i32
    %tmp1 = call i8* @console.get_stdout()
    %tmp2 = call i32 @WriteConsoleA(i8* %tmp1, i8* %buffer, i32 %len, i32* %chars_written, i8* null)
    %tmp3 = load i32, i32* %chars_written
    %tmp4 = icmp ne i32 %len, %tmp3
    br i1 %tmp4, label %then1, label %endif1
then1:
    call void @ExitProcess(i32 -2)
    br label %endif1
endif1:
    %nl = alloca i8
    store i8 10, i8* %nl
    %tmp5 = call i8* @console.get_stdout()
    %tmp6 = call i32 @WriteConsoleA(i8* %tmp5, i8* %nl, i32 1, i32* %chars_written, i8* null)
    ret void
}

define void @console.print_char(i8 %n) {
    %b = alloca i8
    store i8 %n, i8* %b
    call void @console.write(i8* %b, i32 1)
    ret void
}

define void @console.println_i64(i64 %n) {
    %tmp0 = icmp sge i64 %n, 0
    br i1 %tmp0, label %then0, label %else0
then0:
    call void @console.println_u64(i64 %n)
    br label %endif0
else0:
    %tmp1 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.1, i64 0, i64 0
    call void @console.write(i8* %tmp1, i32 1)
    %tmp2 = sub i64 0, %n    call void @console.println_u64(i64 %tmp2)
    br label %endif0
endif0:
    ret void
}

define void @console.println_u64(i64 %n) {
    %buffer = alloca %struct.vector.Vec
    call void @vector.new(%struct.vector.Vec* %buffer)
    %tmp0 = icmp eq i64 %n, 0
    br i1 %tmp0, label %then0, label %endif0
then0:
    call void @vector.push(%struct.vector.Vec* %buffer, i8 48)
    call void @vector.push(%struct.vector.Vec* %buffer, i8 10)
    %tmp1 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %buffer, i32 0, i32 0
    %tmp2 = load i8*, i8** %tmp1
    %tmp3 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %buffer, i32 0, i32 1
    %tmp4 = load i32, i32* %tmp3
    call void @console.write(i8* %tmp2, i32 %tmp4)
    call void @vector.free(%struct.vector.Vec* %buffer)
    ret void
    br label %endif0
endif0:
    %mut_n = alloca i64
    store i64 %n, i64* %mut_n
    br label %loop_body1
loop_body1:
    %tmp5 = load i64, i64* %mut_n
    %tmp6 = icmp eq i64 %tmp5, 0
    br i1 %tmp6, label %then2, label %endif2
then2:
    br label %loop_body1_exit
    br label %endif2
endif2:
    %digit_char = alloca i8
    %tmp7 = load i64, i64* %mut_n
    %tmp8 = urem i64 %tmp7, 10
    %tmp9 = trunc i64 %tmp8 to i8
    %tmp10 = add i8 %tmp9, 48
    store i8 %tmp10, i8* %digit_char
    %tmp11 = load i8, i8* %digit_char
    call void @vector.push(%struct.vector.Vec* %buffer, i8 %tmp11)
    %tmp12 = load i64, i64* %mut_n
    %tmp13 = udiv i64 %tmp12, 10
    store i64 %tmp13, i64* %mut_n
    br label %loop_body1
loop_body1_exit:
    %i = alloca i32
    store i32 0, i32* %i
    %j = alloca i32
    %tmp14 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %buffer, i32 0, i32 1
    %tmp15 = load i32, i32* %tmp14
    %tmp16 = sub i32 %tmp15, 1
    store i32 %tmp16, i32* %j
    br label %loop_body3
loop_body3:
    %tmp17 = load i32, i32* %i
    %tmp18 = load i32, i32* %j
    %tmp19 = icmp uge i32 %tmp17, %tmp18
    br i1 %tmp19, label %then4, label %endif4
then4:
    br label %loop_body3_exit
    br label %endif4
endif4:
    %temp = alloca i8
    %tmp20 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %buffer, i32 0, i32 0
    %tmp21 = load i8*, i8** %tmp20
    %tmp22 = load i32, i32* %i
    %tmp23 = mul i32 %tmp22, 1    %tmp24 = getelementptr inbounds i8, i8* %tmp21, i32 %tmp23
    %tmp25 = load i8, i8* %tmp24
    store i8 %tmp25, i8* %temp
    %tmp26 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %buffer, i32 0, i32 0
    %tmp27 = load i8*, i8** %tmp26
    %tmp28 = load i32, i32* %i
    %tmp29 = mul i32 %tmp28, 1    %tmp30 = getelementptr inbounds i8, i8* %tmp27, i32 %tmp29
    %tmp31 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %buffer, i32 0, i32 0
    %tmp32 = load i8*, i8** %tmp31
    %tmp33 = load i32, i32* %j
    %tmp34 = mul i32 %tmp33, 1    %tmp35 = getelementptr inbounds i8, i8* %tmp32, i32 %tmp34
    %tmp36 = load i8, i8* %tmp35
    store i8 %tmp36, i8* %tmp30
    %tmp37 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %buffer, i32 0, i32 0
    %tmp38 = load i8*, i8** %tmp37
    %tmp39 = load i32, i32* %j
    %tmp40 = mul i32 %tmp39, 1    %tmp41 = getelementptr inbounds i8, i8* %tmp38, i32 %tmp40
    %tmp42 = load i8, i8* %temp
    store i8 %tmp42, i8* %tmp41
    %tmp43 = load i32, i32* %i
    %tmp44 = add i32 %tmp43, 1
    store i32 %tmp44, i32* %i
    %tmp45 = load i32, i32* %j
    %tmp46 = sub i32 %tmp45, 1
    store i32 %tmp46, i32* %j
    br label %loop_body3
loop_body3_exit:
    call void @vector.push(%struct.vector.Vec* %buffer, i8 10)
    %tmp47 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %buffer, i32 0, i32 0
    %tmp48 = load i8*, i8** %tmp47
    %tmp49 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %buffer, i32 0, i32 1
    %tmp50 = load i32, i32* %tmp49
    call void @console.write(i8* %tmp48, i32 %tmp50)
    call void @vector.free(%struct.vector.Vec* %buffer)
    ret void
}

define %struct.string.String @string.from_c_string(i8* %c_string) {
    %x = alloca %struct.string.String
    %tmp0 = getelementptr inbounds %struct.string.String, %struct.string.String* %x, i32 0, i32 1
    %tmp1 = call i32 @string_utils.c_str_len(i8* %c_string)
    store i32 %tmp1, i32* %tmp0
    %tmp2 = getelementptr inbounds %struct.string.String, %struct.string.String* %x, i32 0, i32 0
    %tmp3 = getelementptr inbounds %struct.string.String, %struct.string.String* %x, i32 0, i32 1
    %tmp4 = load i32, i32* %tmp3
    %tmp5 = sext i32 %tmp4 to i64
    %tmp6 = mul i64 %tmp5, 1
    %tmp7 = call i8* @mem.malloc(i64 %tmp6)
    store i8* %tmp7, i8** %tmp2
    %tmp8 = getelementptr inbounds %struct.string.String, %struct.string.String* %x, i32 0, i32 0
    %tmp9 = load i8*, i8** %tmp8
    %tmp10 = getelementptr inbounds %struct.string.String, %struct.string.String* %x, i32 0, i32 1
    %tmp11 = load i32, i32* %tmp10
    %tmp12 = sext i32 %tmp11 to i64
    call void @mem.copy(i8* %c_string, i8* %tmp9, i64 %tmp12)
    %tmp13 = load %struct.string.String, %struct.string.String* %x
    ret %struct.string.String %tmp13
}

define %struct.string.String @string.empty() {
    %x = alloca %struct.string.String
    %tmp0 = getelementptr inbounds %struct.string.String, %struct.string.String* %x, i32 0, i32 0
    store i8* null, i8** %tmp0
    %tmp1 = getelementptr inbounds %struct.string.String, %struct.string.String* %x, i32 0, i32 1
    store i32 0, i32* %tmp1
    %tmp2 = load %struct.string.String, %struct.string.String* %x
    ret %struct.string.String %tmp2
}

define %struct.string.String @string.with_size(i32 %size) {
    %x = alloca %struct.string.String
    %tmp0 = getelementptr inbounds %struct.string.String, %struct.string.String* %x, i32 0, i32 1
    store i32 %size, i32* %tmp0
    %tmp1 = getelementptr inbounds %struct.string.String, %struct.string.String* %x, i32 0, i32 0
    %tmp2 = sext i32 %size to i64
    %tmp3 = mul i64 %tmp2, 1
    %tmp4 = call i8* @mem.malloc(i64 %tmp3)
    store i8* %tmp4, i8** %tmp1
    %tmp5 = load %struct.string.String, %struct.string.String* %x
    ret %struct.string.String %tmp5
}

define %struct.string.String @string.concat_with_c_string(%struct.string.String* %src_string, i8* %c_string) {
    %c_string_len = alloca i32
    %tmp0 = call i32 @string_utils.c_str_len(i8* %c_string)
    store i32 %tmp0, i32* %c_string_len
    %combined = alloca i8*
    %tmp1 = load i32, i32* %c_string_len
    %tmp2 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 1
    %tmp3 = load i32, i32* %tmp2
    %tmp4 = add i32 %tmp1, %tmp3
    %tmp5 = sext i32 %tmp4 to i64
    %tmp6 = mul i64 %tmp5, 1
    %tmp7 = call i8* @mem.malloc(i64 %tmp6)
    store i8* %tmp7, i8** %combined
    %tmp8 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 0
    %tmp9 = load i8*, i8** %tmp8
    %tmp10 = load i8*, i8** %combined
    %tmp11 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 1
    %tmp12 = load i32, i32* %tmp11
    %tmp13 = sext i32 %tmp12 to i64
    call void @mem.copy(i8* %tmp9, i8* %tmp10, i64 %tmp13)
    %tmp14 = load i8*, i8** %combined
    %tmp15 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 1
    %tmp16 = load i32, i32* %tmp15
    %tmp17 = sext i32 %tmp16 to i64
    %tmp18 = getelementptr i8, i8* %tmp14, i64 %tmp17
    %tmp19 = load i32, i32* %c_string_len
    %tmp20 = sext i32 %tmp19 to i64
    call void @mem.copy(i8* %c_string, i8* %tmp18, i64 %tmp20)
    %str = alloca %struct.string.String
    %tmp21 = getelementptr inbounds %struct.string.String, %struct.string.String* %str, i32 0, i32 0
    %tmp22 = load i8*, i8** %combined
    store i8* %tmp22, i8** %tmp21
    %tmp23 = getelementptr inbounds %struct.string.String, %struct.string.String* %str, i32 0, i32 1
    %tmp24 = load i32, i32* %c_string_len
    %tmp25 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 1
    %tmp26 = load i32, i32* %tmp25
    %tmp27 = add i32 %tmp24, %tmp26
    store i32 %tmp27, i32* %tmp23
    %tmp28 = load %struct.string.String, %struct.string.String* %str
    ret %struct.string.String %tmp28
}

define i1 @string.equal(%struct.string.String* %first, %struct.string.String* %second) {
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
    %iter = alloca i32
    %tmp5 = getelementptr inbounds %struct.string.String, %struct.string.String* %first, i32 0, i32 1
    %tmp6 = load i32, i32* %tmp5
    %tmp7 = sub i32 %tmp6, 1
    store i32 %tmp7, i32* %iter
    br label %loop_body1
loop_body1:
    %tmp8 = load i32, i32* %iter
    %tmp9 = icmp slt i32 %tmp8, 0
    br i1 %tmp9, label %then2, label %endif2
then2:
    br label %loop_body1_exit
    br label %endif2
endif2:
    %tmp10 = getelementptr inbounds %struct.string.String, %struct.string.String* %first, i32 0, i32 0
    %tmp11 = load i8*, i8** %tmp10
    %tmp12 = load i32, i32* %iter
    %tmp13 = mul i32 %tmp12, 1    %tmp14 = getelementptr inbounds i8, i8* %tmp11, i32 %tmp13
    %tmp15 = load i8, i8* %tmp14
    %tmp16 = getelementptr inbounds %struct.string.String, %struct.string.String* %second, i32 0, i32 0
    %tmp17 = load i8*, i8** %tmp16
    %tmp18 = load i32, i32* %iter
    %tmp19 = mul i32 %tmp18, 1    %tmp20 = getelementptr inbounds i8, i8* %tmp17, i32 %tmp19
    %tmp21 = load i8, i8* %tmp20
    %tmp22 = icmp ne i8 %tmp15, %tmp21
    br i1 %tmp22, label %then3, label %endif3
then3:
    ret i1 0
    br label %endif3
endif3:
    %tmp23 = load i32, i32* %iter
    %tmp24 = sub i32 %tmp23, 1
    store i32 %tmp24, i32* %iter
    br label %loop_body1
loop_body1_exit:
    ret i1 1
}

define void @string.free(%struct.string.String* %str) {
    %tmp0 = getelementptr inbounds %struct.string.String, %struct.string.String* %str, i32 0, i32 0
    %tmp1 = load i8*, i8** %tmp0
    call void @mem.free(i8* %tmp1)
    %tmp2 = getelementptr inbounds %struct.string.String, %struct.string.String* %str, i32 0, i32 1
    store i32 0, i32* %tmp2
    ret void
}

define i8* @string_utils.insert(i8* %src1, i8* %src2, i32 %index) {
    %len1 = alloca i32
    %tmp0 = call i32 @string_utils.c_str_len(i8* %src1)
    store i32 %tmp0, i32* %len1
    %len2 = alloca i32
    %tmp1 = call i32 @string_utils.c_str_len(i8* %src2)
    store i32 %tmp1, i32* %len2
    %output = alloca i8*
    %tmp2 = load i32, i32* %len1
    %tmp3 = load i32, i32* %len2
    %tmp4 = add i32 %tmp2, %tmp3
    %tmp5 = add i32 %tmp4, 1
    %tmp6 = sext i32 %tmp5 to i64
    %tmp7 = call i8* @mem.malloc(i64 %tmp6)
    store i8* %tmp7, i8** %output
    %tmp8 = load i8*, i8** %output
    %tmp9 = sext i32 %index to i64
    call void @mem.copy(i8* %src1, i8* %tmp8, i64 %tmp9)
    %tmp10 = load i8*, i8** %output
    %tmp11 = getelementptr i8, i8* %tmp10, i32 %index
    %tmp12 = load i32, i32* %len2
    %tmp13 = sext i32 %tmp12 to i64
    call void @mem.copy(i8* %src2, i8* %tmp11, i64 %tmp13)
    %tmp14 = getelementptr i8, i8* %src1, i32 %index
    %tmp15 = load i8*, i8** %output
    %tmp16 = getelementptr i8, i8* %tmp15, i32 %index
    %tmp17 = load i32, i32* %len2
    %tmp18 = getelementptr i8, i8* %tmp16, i32 %tmp17
    %tmp19 = load i32, i32* %len1
    %tmp20 = sub i32 %tmp19, %index
    %tmp21 = sext i32 %tmp20 to i64
    call void @mem.copy(i8* %tmp14, i8* %tmp18, i64 %tmp21)
    %tmp22 = load i8*, i8** %output
    %tmp23 = load i32, i32* %len1
    %tmp24 = load i32, i32* %len2
    %tmp25 = add i32 %tmp23, %tmp24
    %tmp26 = mul i32 %tmp25, 1    %tmp27 = getelementptr inbounds i8, i8* %tmp22, i32 %tmp26
    store i8 0, i8* %tmp27
    %tmp28 = load i8*, i8** %output
    ret i8* %tmp28
}

define i32 @string_utils.c_str_len(i8* %str) {
    %len = alloca i32
    store i32 0, i32* %len
    br label %loop_body0
loop_body0:
    %tmp0 = load i32, i32* %len
    %tmp1 = mul i32 %tmp0, 1    %tmp2 = getelementptr inbounds i8, i8* %str, i32 %tmp1
    %tmp3 = load i8, i8* %tmp2
    %tmp4 = icmp eq i8 %tmp3, 0
    br i1 %tmp4, label %then1, label %endif1
then1:
    br label %loop_body0_exit
    br label %endif1
endif1:
    %tmp5 = load i32, i32* %len
    %tmp6 = add i32 %tmp5, 1
    store i32 %tmp6, i32* %len
    br label %loop_body0
loop_body0_exit:
    %tmp7 = load i32, i32* %len
    ret i32 %tmp7
}

define i1 @string_utils.is_ascii_num(i8 %char) {
    %tmp0 = icmp sge i8 %char, 48
    %tmp1 = icmp sle i8 %char, 57
    %tmp2 = and i1 %tmp0, %tmp1
    ret i1 %tmp2
}

define i1 @string_utils.is_ascii_char(i8 %char) {
    %tmp0 = icmp sge i8 %char, 65
    %tmp1 = icmp sle i8 %char, 90
    %tmp2 = and i1 %tmp0, %tmp1
    %tmp3 = icmp sge i8 %char, 97
    %tmp4 = icmp sle i8 %char, 122
    %tmp5 = and i1 %tmp3, %tmp4
    %tmp6 = or i1 %tmp2, %tmp5
    ret i1 %tmp6
}

define i1 @string_utils.is_ascii_hex(i8 %char) {
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

define i32 @fs.write_to_file(i8* %path, i8* %content, i32 %content_len) {
    %CREATE_ALWAYS = alloca i32
    store i32 2, i32* %CREATE_ALWAYS
    %GENERIC_WRITE = alloca i32
    store i32 1073741824, i32* %GENERIC_WRITE
    %FILE_ATTRIBUTE_NORMAL = alloca i32
    store i32 128, i32* %FILE_ATTRIBUTE_NORMAL
    %hFile = alloca i8*
    %tmp0 = load i32, i32* %GENERIC_WRITE
    %tmp1 = load i32, i32* %CREATE_ALWAYS
    %tmp2 = load i32, i32* %FILE_ATTRIBUTE_NORMAL
    %tmp3 = call i8* @CreateFileA(i8* %path, i32 %tmp0, i32 0, i8* null, i32 %tmp1, i32 %tmp2, i8* null)
    store i8* %tmp3, i8** %hFile
    %INVALID_HANDLE_VALUE = alloca i8*
    %tmp4 = inttoptr i64 -1 to i8*
    store i8* %tmp4, i8** %INVALID_HANDLE_VALUE
    %tmp5 = load i8*, i8** %hFile
    %tmp6 = load i8*, i8** %INVALID_HANDLE_VALUE
    %tmp7 = icmp eq ptr %tmp5, %tmp6
    br i1 %tmp7, label %then0, label %endif0
then0:
    ret i32 0
    br label %endif0
endif0:
    %bytes_written = alloca i32
    store i32 0, i32* %bytes_written
    %success = alloca i32
    %tmp8 = load i8*, i8** %hFile
    %tmp9 = call i32 @WriteFile(i8* %tmp8, i8* %content, i32 %content_len, i32* %bytes_written, i8* null)
    store i32 %tmp9, i32* %success
    %tmp10 = load i8*, i8** %hFile
    %tmp11 = call i32 @CloseHandle(i8* %tmp10)
    %tmp12 = load i32, i32* %success
    %tmp13 = icmp eq i32 %tmp12, 0
    br i1 %tmp13, label %then1, label %endif1
then1:
    ret i32 0
    br label %endif1
endif1:
    %tmp14 = load i32, i32* %bytes_written
    %tmp15 = icmp ne i32 %tmp14, %content_len
    br i1 %tmp15, label %then2, label %endif2
then2:
    ret i32 0
    br label %endif2
endif2:
    ret i32 1
}

define %struct.string.String @fs.read_full_file_as_string(i8* %path) {
    %GENERIC_READ = alloca i32
    store i32 2147483648, i32* %GENERIC_READ
    %FILE_ATTRIBUTE_NORMAL = alloca i32
    store i32 128, i32* %FILE_ATTRIBUTE_NORMAL
    %OPEN_EXISTING = alloca i32
    store i32 3, i32* %OPEN_EXISTING
    %hFile = alloca i8*
    %tmp0 = load i32, i32* %GENERIC_READ
    %tmp1 = load i32, i32* %OPEN_EXISTING
    %tmp2 = load i32, i32* %FILE_ATTRIBUTE_NORMAL
    %tmp3 = call i8* @CreateFileA(i8* %path, i32 %tmp0, i32 0, i8* null, i32 %tmp1, i32 %tmp2, i8* null)
    store i8* %tmp3, i8** %hFile
    %INVALID_HANDLE_VALUE = alloca i8*
    %tmp4 = inttoptr i64 -1 to i8*
    store i8* %tmp4, i8** %INVALID_HANDLE_VALUE
    %tmp5 = load i8*, i8** %hFile
    %tmp6 = load i8*, i8** %INVALID_HANDLE_VALUE
    %tmp7 = icmp eq ptr %tmp5, %tmp6
    br i1 %tmp7, label %then0, label %endif0
then0:
    %tmp8 = getelementptr inbounds [20 x i8], [20 x i8]* @.str.2, i64 0, i64 0
    %tmp9 = call i8* @string_utils.insert(i8* %tmp8, i8* %path, i32 5)
    call void @process.throw(i8* %tmp9)
    br label %endif0
endif0:
    %file_size = alloca i64
    store i64 0, i64* %file_size
    %tmp10 = load i8*, i8** %hFile
    %tmp11 = call i32 @GetFileSizeEx(i8* %tmp10, i64* %file_size)
    %tmp12 = icmp eq i32 %tmp11, 0
    br i1 %tmp12, label %then1, label %endif1
then1:
    %tmp13 = load i8*, i8** %hFile
    %tmp14 = call i32 @CloseHandle(i8* %tmp13)
    %tmp15 = call %struct.string.String @string.empty()
    ret %struct.string.String %tmp15
    br label %endif1
endif1:
    %buffer = alloca %struct.string.String
    %tmp16 = load i64, i64* %file_size
    %tmp17 = trunc i64 %tmp16 to i32
    %tmp18 = add i32 %tmp17, 1
    %tmp19 = call %struct.string.String @string.with_size(i32 %tmp18)
    store %struct.string.String %tmp19, %struct.string.String* %buffer
    %bytes_read = alloca i32
    store i32 0, i32* %bytes_read
    %success = alloca i32
    %tmp20 = load i8*, i8** %hFile
    %tmp21 = getelementptr inbounds %struct.string.String, %struct.string.String* %buffer, i32 0, i32 0
    %tmp22 = load i8*, i8** %tmp21
    %tmp23 = load i64, i64* %file_size
    %tmp24 = trunc i64 %tmp23 to i32
    %tmp25 = call i32 @ReadFile(i8* %tmp20, i8* %tmp22, i32 %tmp24, i32* %bytes_read, i8* null)
    store i32 %tmp25, i32* %success
    %tmp26 = load i8*, i8** %hFile
    %tmp27 = call i32 @CloseHandle(i8* %tmp26)
    %tmp28 = load i32, i32* %success
    %tmp29 = icmp eq i32 %tmp28, 0
    %tmp30 = load i32, i32* %bytes_read
    %tmp31 = zext i32 %tmp30 to i64
    %tmp32 = load i64, i64* %file_size
    %tmp33 = icmp ne i64 %tmp31, %tmp32
    %tmp34 = or i1 %tmp29, %tmp33
    br i1 %tmp34, label %then2, label %endif2
then2:
    call void @string.free(%struct.string.String* %buffer)
    %tmp35 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.3, i64 0, i64 0
    call void @process.throw(i8* %tmp35)
    br label %endif2
endif2:
    %tmp36 = getelementptr inbounds %struct.string.String, %struct.string.String* %buffer, i32 0, i32 1
    %tmp37 = load i64, i64* %file_size
    %tmp38 = trunc i64 %tmp37 to i32
    store i32 %tmp38, i32* %tmp36
    %tmp39 = load %struct.string.String, %struct.string.String* %buffer
    ret %struct.string.String %tmp39
}

define i32 @fs.create_file(i8* %path) {
    %CREATE_NEW = alloca i32
    store i32 1, i32* %CREATE_NEW
    %GENERIC_WRITE = alloca i32
    store i32 1073741824, i32* %GENERIC_WRITE
    %FILE_ATTRIBUTE_NORMAL = alloca i32
    store i32 128, i32* %FILE_ATTRIBUTE_NORMAL
    %hFile = alloca i8*
    %tmp0 = load i32, i32* %GENERIC_WRITE
    %tmp1 = load i32, i32* %CREATE_NEW
    %tmp2 = load i32, i32* %FILE_ATTRIBUTE_NORMAL
    %tmp3 = call i8* @CreateFileA(i8* %path, i32 %tmp0, i32 0, i8* null, i32 %tmp1, i32 %tmp2, i8* null)
    store i8* %tmp3, i8** %hFile
    %INVALID_HANDLE_VALUE = alloca i8*
    %tmp4 = inttoptr i64 -1 to i8*
    store i8* %tmp4, i8** %INVALID_HANDLE_VALUE
    %tmp5 = load i8*, i8** %hFile
    %tmp6 = load i8*, i8** %INVALID_HANDLE_VALUE
    %tmp7 = icmp eq ptr %tmp5, %tmp6
    br i1 %tmp7, label %then0, label %endif0
then0:
    ret i32 0
    br label %endif0
endif0:
    %tmp8 = load i8*, i8** %hFile
    %tmp9 = call i32 @CloseHandle(i8* %tmp8)
    ret i32 1
}

define i32 @fs.delete_file(i8* %path) {
    %tmp0 = call i32 @DeleteFileA(i8* %path)
    ret i32 %tmp0
}

define void @tests.run() {
    call void @tests.fs_test()
    call void @tests.funny()
    ret void
}

define void @tests.fs_test() {
    %tmp0 = getelementptr inbounds [10 x i8], [10 x i8]* @.str.4, i64 0, i64 0
    call void @console.write(i8* %tmp0, i32 9)
    %data = alloca %struct.string.String
    %tmp1 = getelementptr inbounds [47 x i8], [47 x i8]* @.str.5, i64 0, i64 0
    %tmp2 = call %struct.string.String @string.from_c_string(i8* %tmp1)
    store %struct.string.String %tmp2, %struct.string.String* %data
    %env_path = alloca %struct.string.String
    %tmp3 = call %struct.string.String @process.get_executable_env_path()
    store %struct.string.String %tmp3, %struct.string.String* %env_path
    %new_file_path = alloca %struct.string.String
    %tmp4 = getelementptr inbounds [9 x i8], [9 x i8]* @.str.6, i64 0, i64 0
    %tmp5 = call %struct.string.String @string.concat_with_c_string(%struct.string.String* %env_path, i8* %tmp4)
    store %struct.string.String %tmp5, %struct.string.String* %new_file_path
    %c_string = alloca i8*
    %tmp6 = getelementptr inbounds %struct.string.String, %struct.string.String* %new_file_path, i32 0, i32 1
    %tmp7 = load i32, i32* %tmp6
    %tmp8 = add i32 %tmp7, 1
    %tmp9 = sext i32 %tmp8 to i64
    %tmp10 = mul i64 %tmp9, 1
    %tmp11 = alloca i8, i64 %tmp10
    store i8* %tmp11, i8** %c_string
    %tmp12 = getelementptr inbounds %struct.string.String, %struct.string.String* %new_file_path, i32 0, i32 0
    %tmp13 = load i8*, i8** %tmp12
    %tmp14 = load i8*, i8** %c_string
    %tmp15 = getelementptr inbounds %struct.string.String, %struct.string.String* %new_file_path, i32 0, i32 1
    %tmp16 = load i32, i32* %tmp15
    %tmp17 = sext i32 %tmp16 to i64
    call void @mem.copy(i8* %tmp13, i8* %tmp14, i64 %tmp17)
    %tmp18 = load i8*, i8** %c_string
    %tmp19 = getelementptr inbounds %struct.string.String, %struct.string.String* %new_file_path, i32 0, i32 1
    %tmp20 = load i32, i32* %tmp19
    %tmp21 = mul i32 %tmp20, 1    %tmp22 = getelementptr inbounds i8, i8* %tmp18, i32 %tmp21
    store i8 0, i8* %tmp22
    %tmp23 = load i8*, i8** %c_string
    %tmp24 = call i32 @fs.create_file(i8* %tmp23)
    %tmp25 = load i8*, i8** %c_string
    %tmp26 = call i32 @fs.delete_file(i8* %tmp25)
    %tmp27 = load i8*, i8** %c_string
    %tmp28 = call i32 @fs.create_file(i8* %tmp27)
    %tmp29 = load i8*, i8** %c_string
    %tmp30 = getelementptr inbounds %struct.string.String, %struct.string.String* %data, i32 0, i32 0
    %tmp31 = load i8*, i8** %tmp30
    %tmp32 = getelementptr inbounds %struct.string.String, %struct.string.String* %data, i32 0, i32 1
    %tmp33 = load i32, i32* %tmp32
    %tmp34 = call i32 @fs.write_to_file(i8* %tmp29, i8* %tmp31, i32 %tmp33)
    %read = alloca %struct.string.String
    %tmp35 = load i8*, i8** %c_string
    %tmp36 = call %struct.string.String @fs.read_full_file_as_string(i8* %tmp35)
    store %struct.string.String %tmp36, %struct.string.String* %read
    %tmp37 = call i1 @string.equal(%struct.string.String* %data, %struct.string.String* %read)
    %tmp38 = xor i1 %tmp37, 1
    br i1 %tmp38, label %then0, label %endif0
then0:
    %tmp39 = getelementptr inbounds [38 x i8], [38 x i8]* @.str.7, i64 0, i64 0
    call void @process.throw(i8* %tmp39)
    br label %endif0
endif0:
    %tmp40 = load i8*, i8** %c_string
    %tmp41 = call i32 @fs.delete_file(i8* %tmp40)
    call void @string.free(%struct.string.String* %read)
    call void @string.free(%struct.string.String* %new_file_path)
    call void @string.free(%struct.string.String* %env_path)
    call void @string.free(%struct.string.String* %data)
    %tmp42 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.8, i64 0, i64 0
    call void @console.writeln(i8* %tmp42, i32 2)
    ret void
}

define void @tests.consume_while(%struct.string.String* %file, i32* %iterator, i1 (i8)** %condition) {
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
    %char = alloca i8
    %tmp4 = getelementptr inbounds %struct.string.String, %struct.string.String* %file, i32 0, i32 0
    %tmp5 = load i8*, i8** %tmp4
    %tmp6 = load i32, i32* %iterator
    %tmp7 = mul i32 %tmp6, 1    %tmp8 = getelementptr inbounds i8, i8* %tmp5, i32 %tmp7
    %tmp9 = load i8, i8* %tmp8
    store i8 %tmp9, i8* %char
    %tmp10 = load i8, i8* %char
    %tmp11 = call i1 %condition(i8 %tmp10)
    br i1 %tmp11, label %then2, label %else2
then2:
    %tmp12 = load i32, i32* %iterator
    %tmp13 = add i32 %tmp12, 1
    store i32 %tmp13, i32* %iterator
    br label %endif2
else2:
    br label %loop_body0_exit
    br label %endif2
endif2:
    br label %loop_body0
loop_body0_exit:
    ret void
}

define i1 @tests.not_new_line(i8 %c) {
    %tmp0 = icmp ne i8 %c, 10
    ret i1 %tmp0
}

define i1 @tests.valid_name_token(i8 %c) {
    %tmp0 = call i1 @string_utils.is_ascii_char(i8 %c)
    %tmp1 = call i1 @string_utils.is_ascii_num(i8 %c)
    %tmp2 = or i1 %tmp0, %tmp1
    %tmp3 = icmp eq i8 %c, 95
    %tmp4 = or i1 %tmp2, %tmp3
    ret i1 %tmp4
}

define i1 @tests.is_valid_number_token(i8 %c) {
    %tmp0 = call i1 @string_utils.is_ascii_num(i8 %c)
    %tmp1 = call i1 @string_utils.is_ascii_hex(i8 %c)
    %tmp2 = or i1 %tmp0, %tmp1
    %tmp3 = icmp eq i8 %c, 95
    %tmp4 = or i1 %tmp2, %tmp3
    ret i1 %tmp4
}

define void @tests.funny() {
    %path = alloca i8*
    %tmp0 = getelementptr inbounds [32 x i8], [32 x i8]* @.str.9, i64 0, i64 0
    store i8* %tmp0, i8** %path
    %file = alloca %struct.string.String
    %tmp1 = load i8*, i8** %path
    %tmp2 = call %struct.string.String @fs.read_full_file_as_string(i8* %tmp1)
    store %struct.string.String %tmp2, %struct.string.String* %file
    %tokens = alloca %struct.vector.Vec
    call void @vector.new(%struct.vector.Vec* %tokens)
    %iterator = alloca i32
    store i32 0, i32* %iterator
    %char = alloca i8
    %next_char = alloca i8
    %index = alloca i32
    %temp_string = alloca %struct.string.String
    br label %loop_body0
loop_body0:
    %tmp3 = load i32, i32* %iterator
    %tmp4 = getelementptr inbounds %struct.string.String, %struct.string.String* %file, i32 0, i32 1
    %tmp5 = load i32, i32* %tmp4
    %tmp6 = icmp sge i32 %tmp3, %tmp5
    br i1 %tmp6, label %then1, label %endif1
then1:
    br label %loop_body0_exit
    br label %endif1
endif1:
    %tmp7 = getelementptr inbounds %struct.string.String, %struct.string.String* %file, i32 0, i32 0
    %tmp8 = load i8*, i8** %tmp7
    %tmp9 = load i32, i32* %iterator
    %tmp10 = mul i32 %tmp9, 1    %tmp11 = getelementptr inbounds i8, i8* %tmp8, i32 %tmp10
    %tmp12 = load i8, i8* %tmp11
    store i8 %tmp12, i8* %char
    %tmp13 = load i8, i8* %char
    %tmp14 = icmp eq i8 %tmp13, 32
    %tmp15 = load i8, i8* %char
    %tmp16 = icmp eq i8 %tmp15, 9
    %tmp17 = or i1 %tmp14, %tmp16
    %tmp18 = load i8, i8* %char
    %tmp19 = icmp eq i8 %tmp18, 10
    %tmp20 = or i1 %tmp17, %tmp19
    %tmp21 = load i8, i8* %char
    %tmp22 = icmp eq i8 %tmp21, 13
    %tmp23 = or i1 %tmp20, %tmp22
    %tmp24 = and i1 %tmp23, 1
    br i1 %tmp24, label %then2, label %endif2
then2:
    %tmp25 = load i32, i32* %iterator
    %tmp26 = add i32 %tmp25, 1
    store i32 %tmp26, i32* %iterator
    br label %loop_body0
    br label %endif2
endif2:
    %tmp27 = load i32, i32* %iterator
    %tmp28 = add i32 %tmp27, 1
    %tmp29 = getelementptr inbounds %struct.string.String, %struct.string.String* %file, i32 0, i32 1
    %tmp30 = load i32, i32* %tmp29
    %tmp31 = icmp slt i32 %tmp28, %tmp30
    br i1 %tmp31, label %then3, label %else3
then3:
    %tmp32 = getelementptr inbounds %struct.string.String, %struct.string.String* %file, i32 0, i32 0
    %tmp33 = load i8*, i8** %tmp32
    %tmp34 = load i32, i32* %iterator
    %tmp35 = add i32 %tmp34, 1
    %tmp36 = mul i32 %tmp35, 1    %tmp37 = getelementptr inbounds i8, i8* %tmp33, i32 %tmp36
    %tmp38 = load i8, i8* %tmp37
    store i8 %tmp38, i8* %next_char
    br label %endif3
else3:
    store i8 0, i8* %next_char
    br label %endif3
endif3:
    %tmp39 = load i8, i8* %char
    %tmp40 = icmp eq i8 %tmp39, 47
    %tmp41 = load i8, i8* %next_char
    %tmp42 = icmp eq i8 %tmp41, 47
    %tmp43 = and i1 %tmp40, %tmp42
    br i1 %tmp43, label %then4, label %endif4
then4:
    %tmp44 = load i32, i32* %iterator
    store i32 %tmp44, i32* %index
    call void @tests.consume_while(%struct.string.String* %file, i32* %iterator, i1 (i8)** @tests.not_new_line)
    br label %loop_body0
    br label %endif4
endif4:
    %tmp45 = load i8, i8* %char
    %tmp46 = call i1 @string_utils.is_ascii_num(i8 %tmp45)
    br i1 %tmp46, label %then5, label %endif5
then5:
    %tmp47 = load i32, i32* %iterator
    store i32 %tmp47, i32* %index
    %tmp48 = load i8, i8* %next_char
    %tmp49 = icmp eq i8 %tmp48, 120
    %tmp50 = load i8, i8* %next_char
    %tmp51 = icmp eq i8 %tmp50, 98
    %tmp52 = or i1 %tmp49, %tmp51
    br i1 %tmp52, label %then6, label %endif6
then6:
    %tmp53 = load i32, i32* %iterator
    %tmp54 = add i32 %tmp53, 2
    store i32 %tmp54, i32* %iterator
    br label %endif6
endif6:
    call void @tests.consume_while(%struct.string.String* %file, i32* %iterator, i1 (i8)** @tests.is_valid_number_token)
    %tmp55 = load i32, i32* %iterator
    %tmp56 = load i32, i32* %index
    %tmp57 = sub i32 %tmp55, %tmp56
    %tmp58 = call %struct.string.String @string.with_size(i32 %tmp57)
    store %struct.string.String %tmp58, %struct.string.String* %temp_string
    %tmp59 = getelementptr inbounds %struct.string.String, %struct.string.String* %file, i32 0, i32 0
    %tmp60 = load i8*, i8** %tmp59
    %tmp61 = load i32, i32* %index
    %tmp62 = getelementptr i8, i8* %tmp60, i32 %tmp61
    %tmp63 = getelementptr inbounds %struct.string.String, %struct.string.String* %temp_string, i32 0, i32 0
    %tmp64 = load i8*, i8** %tmp63
    %tmp65 = getelementptr inbounds %struct.string.String, %struct.string.String* %temp_string, i32 0, i32 1
    %tmp66 = load i32, i32* %tmp65
    %tmp67 = sext i32 %tmp66 to i64
    call void @mem.copy(i8* %tmp62, i8* %tmp64, i64 %tmp67)
    call void @string.free(%struct.string.String* %temp_string)
    br label %loop_body0
    br label %endif5
endif5:
    %tmp68 = load i8, i8* %char
    %tmp69 = call i1 @string_utils.is_ascii_char(i8 %tmp68)
    %tmp70 = load i8, i8* %char
    %tmp71 = icmp eq i8 %tmp70, 95
    %tmp72 = or i1 %tmp69, %tmp71
    br i1 %tmp72, label %then7, label %endif7
then7:
    %tmp73 = load i32, i32* %iterator
    store i32 %tmp73, i32* %index
    call void @tests.consume_while(%struct.string.String* %file, i32* %iterator, i1 (i8)** @tests.valid_name_token)
    %tmp74 = load i32, i32* %iterator
    %tmp75 = load i32, i32* %index
    %tmp76 = sub i32 %tmp74, %tmp75
    %tmp77 = call %struct.string.String @string.with_size(i32 %tmp76)
    store %struct.string.String %tmp77, %struct.string.String* %temp_string
    %tmp78 = getelementptr inbounds %struct.string.String, %struct.string.String* %file, i32 0, i32 0
    %tmp79 = load i8*, i8** %tmp78
    %tmp80 = load i32, i32* %index
    %tmp81 = getelementptr i8, i8* %tmp79, i32 %tmp80
    %tmp82 = getelementptr inbounds %struct.string.String, %struct.string.String* %temp_string, i32 0, i32 0
    %tmp83 = load i8*, i8** %tmp82
    %tmp84 = getelementptr inbounds %struct.string.String, %struct.string.String* %temp_string, i32 0, i32 1
    %tmp85 = load i32, i32* %tmp84
    %tmp86 = sext i32 %tmp85 to i64
    call void @mem.copy(i8* %tmp81, i8* %tmp83, i64 %tmp86)
    call void @string.free(%struct.string.String* %temp_string)
    br label %loop_body0
    br label %endif7
endif7:
    %tmp87 = load i8, i8* %char
    %tmp88 = icmp eq i8 %tmp87, 34
    br i1 %tmp88, label %then8, label %endif8
then8:
    %tmp89 = load i32, i32* %iterator
    store i32 %tmp89, i32* %index
    br label %loop_body9
loop_body9:
    %tmp90 = load i32, i32* %iterator
    %tmp91 = add i32 %tmp90, 1
    store i32 %tmp91, i32* %iterator
    %tmp92 = load i32, i32* %iterator
    %tmp93 = getelementptr inbounds %struct.string.String, %struct.string.String* %file, i32 0, i32 1
    %tmp94 = load i32, i32* %tmp93
    %tmp95 = icmp sge i32 %tmp92, %tmp94
    br i1 %tmp95, label %then10, label %endif10
then10:
    br label %loop_body9_exit
    br label %endif10
endif10:
    %tmp96 = getelementptr inbounds %struct.string.String, %struct.string.String* %file, i32 0, i32 0
    %tmp97 = load i8*, i8** %tmp96
    %tmp98 = load i32, i32* %iterator
    %tmp99 = mul i32 %tmp98, 1    %tmp100 = getelementptr inbounds i8, i8* %tmp97, i32 %tmp99
    %tmp101 = load i8, i8* %tmp100
    store i8 %tmp101, i8* %char
    %tmp102 = load i8, i8* %char
    %tmp103 = icmp ne i8 %tmp102, 34
    br i1 %tmp103, label %then11, label %endif11
then11:
    br label %loop_body9
    br label %endif11
endif11:
    %tmp104 = load i32, i32* %iterator
    %tmp105 = add i32 %tmp104, 1
    store i32 %tmp105, i32* %iterator
    br label %loop_body9_exit
    br label %loop_body9
loop_body9_exit:
    %tmp106 = load i32, i32* %iterator
    %tmp107 = load i32, i32* %index
    %tmp108 = sub i32 %tmp106, %tmp107
    %tmp109 = call %struct.string.String @string.with_size(i32 %tmp108)
    store %struct.string.String %tmp109, %struct.string.String* %temp_string
    %tmp110 = getelementptr inbounds %struct.string.String, %struct.string.String* %file, i32 0, i32 0
    %tmp111 = load i8*, i8** %tmp110
    %tmp112 = load i32, i32* %index
    %tmp113 = getelementptr i8, i8* %tmp111, i32 %tmp112
    %tmp114 = getelementptr inbounds %struct.string.String, %struct.string.String* %temp_string, i32 0, i32 0
    %tmp115 = load i8*, i8** %tmp114
    %tmp116 = getelementptr inbounds %struct.string.String, %struct.string.String* %temp_string, i32 0, i32 1
    %tmp117 = load i32, i32* %tmp116
    %tmp118 = sext i32 %tmp117 to i64
    call void @mem.copy(i8* %tmp113, i8* %tmp115, i64 %tmp118)
    call void @string.free(%struct.string.String* %temp_string)
    br label %loop_body0
    br label %endif8
endif8:
    %tmp119 = load i8, i8* %char
    %tmp120 = icmp eq i8 %tmp119, 40
    br i1 %tmp120, label %then12, label %endif12
then12:
    %tmp121 = load i32, i32* %iterator
    %tmp122 = add i32 %tmp121, 1
    store i32 %tmp122, i32* %iterator
    br label %loop_body0
    br label %endif12
endif12:
    %tmp123 = load i8, i8* %char
    %tmp124 = icmp eq i8 %tmp123, 41
    br i1 %tmp124, label %then13, label %endif13
then13:
    %tmp125 = load i32, i32* %iterator
    %tmp126 = add i32 %tmp125, 1
    store i32 %tmp126, i32* %iterator
    br label %loop_body0
    br label %endif13
endif13:
    %tmp127 = load i8, i8* %char
    %tmp128 = icmp eq i8 %tmp127, 123
    br i1 %tmp128, label %then14, label %endif14
then14:
    %tmp129 = load i32, i32* %iterator
    %tmp130 = add i32 %tmp129, 1
    store i32 %tmp130, i32* %iterator
    br label %loop_body0
    br label %endif14
endif14:
    %tmp131 = load i8, i8* %char
    %tmp132 = icmp eq i8 %tmp131, 125
    br i1 %tmp132, label %then15, label %endif15
then15:
    %tmp133 = load i32, i32* %iterator
    %tmp134 = add i32 %tmp133, 1
    store i32 %tmp134, i32* %iterator
    br label %loop_body0
    br label %endif15
endif15:
    %tmp135 = load i8, i8* %char
    %tmp136 = icmp eq i8 %tmp135, 91
    br i1 %tmp136, label %then16, label %endif16
then16:
    %tmp137 = load i32, i32* %iterator
    %tmp138 = add i32 %tmp137, 1
    store i32 %tmp138, i32* %iterator
    br label %loop_body0
    br label %endif16
endif16:
    %tmp139 = load i8, i8* %char
    %tmp140 = icmp eq i8 %tmp139, 93
    br i1 %tmp140, label %then17, label %endif17
then17:
    %tmp141 = load i32, i32* %iterator
    %tmp142 = add i32 %tmp141, 1
    store i32 %tmp142, i32* %iterator
    br label %loop_body0
    br label %endif17
endif17:
    %tmp143 = load i8, i8* %char
    %tmp144 = icmp eq i8 %tmp143, 61
    br i1 %tmp144, label %then18, label %endif18
then18:
    %tmp145 = load i8, i8* %next_char
    %tmp146 = icmp eq i8 %tmp145, 61
    br i1 %tmp146, label %then19, label %endif19
then19:
    %tmp147 = load i32, i32* %iterator
    %tmp148 = add i32 %tmp147, 2
    store i32 %tmp148, i32* %iterator
    br label %loop_body0
    br label %endif19
endif19:
    %tmp149 = load i32, i32* %iterator
    %tmp150 = add i32 %tmp149, 1
    store i32 %tmp150, i32* %iterator
    br label %loop_body0
    br label %endif18
endif18:
    %tmp151 = load i8, i8* %char
    %tmp152 = icmp eq i8 %tmp151, 58
    br i1 %tmp152, label %then20, label %endif20
then20:
    %tmp153 = load i8, i8* %next_char
    %tmp154 = icmp eq i8 %tmp153, 58
    br i1 %tmp154, label %then21, label %endif21
then21:
    %tmp155 = load i32, i32* %iterator
    %tmp156 = add i32 %tmp155, 2
    store i32 %tmp156, i32* %iterator
    br label %loop_body0
    br label %endif21
endif21:
    %tmp157 = load i32, i32* %iterator
    %tmp158 = add i32 %tmp157, 1
    store i32 %tmp158, i32* %iterator
    br label %loop_body0
    br label %endif20
endif20:
    %tmp159 = load i8, i8* %char
    %tmp160 = icmp eq i8 %tmp159, 124
    br i1 %tmp160, label %then22, label %endif22
then22:
    %tmp161 = load i8, i8* %next_char
    %tmp162 = icmp eq i8 %tmp161, 124
    br i1 %tmp162, label %then23, label %endif23
then23:
    %tmp163 = load i32, i32* %iterator
    %tmp164 = add i32 %tmp163, 2
    store i32 %tmp164, i32* %iterator
    br label %loop_body0
    br label %endif23
endif23:
    %tmp165 = load i32, i32* %iterator
    %tmp166 = add i32 %tmp165, 1
    store i32 %tmp166, i32* %iterator
    br label %loop_body0
    br label %endif22
endif22:
    %tmp167 = load i8, i8* %char
    %tmp168 = icmp eq i8 %tmp167, 38
    br i1 %tmp168, label %then24, label %endif24
then24:
    %tmp169 = load i8, i8* %next_char
    %tmp170 = icmp eq i8 %tmp169, 38
    br i1 %tmp170, label %then25, label %endif25
then25:
    %tmp171 = load i32, i32* %iterator
    %tmp172 = add i32 %tmp171, 2
    store i32 %tmp172, i32* %iterator
    br label %loop_body0
    br label %endif25
endif25:
    %tmp173 = load i32, i32* %iterator
    %tmp174 = add i32 %tmp173, 1
    store i32 %tmp174, i32* %iterator
    br label %loop_body0
    br label %endif24
endif24:
    %tmp175 = load i8, i8* %char
    %tmp176 = icmp eq i8 %tmp175, 62
    br i1 %tmp176, label %then26, label %endif26
then26:
    %tmp177 = load i8, i8* %next_char
    %tmp178 = icmp eq i8 %tmp177, 61
    br i1 %tmp178, label %then27, label %endif27
then27:
    %tmp179 = load i32, i32* %iterator
    %tmp180 = add i32 %tmp179, 2
    store i32 %tmp180, i32* %iterator
    br label %loop_body0
    br label %endif27
endif27:
    %tmp181 = load i32, i32* %iterator
    %tmp182 = add i32 %tmp181, 1
    store i32 %tmp182, i32* %iterator
    br label %loop_body0
    br label %endif26
endif26:
    %tmp183 = load i8, i8* %char
    %tmp184 = icmp eq i8 %tmp183, 60
    br i1 %tmp184, label %then28, label %endif28
then28:
    %tmp185 = load i8, i8* %next_char
    %tmp186 = icmp eq i8 %tmp185, 61
    br i1 %tmp186, label %then29, label %endif29
then29:
    %tmp187 = load i32, i32* %iterator
    %tmp188 = add i32 %tmp187, 2
    store i32 %tmp188, i32* %iterator
    br label %loop_body0
    br label %endif29
endif29:
    %tmp189 = load i32, i32* %iterator
    %tmp190 = add i32 %tmp189, 1
    store i32 %tmp190, i32* %iterator
    br label %loop_body0
    br label %endif28
endif28:
    %tmp191 = load i8, i8* %char
    %tmp192 = icmp eq i8 %tmp191, 35
    br i1 %tmp192, label %then30, label %endif30
then30:
    %tmp193 = load i32, i32* %iterator
    %tmp194 = add i32 %tmp193, 1
    store i32 %tmp194, i32* %iterator
    br label %loop_body0
    br label %endif30
endif30:
    %tmp195 = load i8, i8* %char
    %tmp196 = icmp eq i8 %tmp195, 59
    br i1 %tmp196, label %then31, label %endif31
then31:
    %tmp197 = load i32, i32* %iterator
    %tmp198 = add i32 %tmp197, 1
    store i32 %tmp198, i32* %iterator
    br label %loop_body0
    br label %endif31
endif31:
    %tmp199 = load i8, i8* %char
    %tmp200 = icmp eq i8 %tmp199, 46
    br i1 %tmp200, label %then32, label %endif32
then32:
    %tmp201 = load i32, i32* %iterator
    %tmp202 = add i32 %tmp201, 1
    store i32 %tmp202, i32* %iterator
    br label %loop_body0
    br label %endif32
endif32:
    %tmp203 = load i8, i8* %char
    %tmp204 = icmp eq i8 %tmp203, 44
    br i1 %tmp204, label %then33, label %endif33
then33:
    %tmp205 = load i32, i32* %iterator
    %tmp206 = add i32 %tmp205, 1
    store i32 %tmp206, i32* %iterator
    br label %loop_body0
    br label %endif33
endif33:
    %tmp207 = load i8, i8* %char
    %tmp208 = icmp eq i8 %tmp207, 43
    br i1 %tmp208, label %then34, label %endif34
then34:
    %tmp209 = load i32, i32* %iterator
    %tmp210 = add i32 %tmp209, 1
    store i32 %tmp210, i32* %iterator
    br label %loop_body0
    br label %endif34
endif34:
    %tmp211 = load i8, i8* %char
    %tmp212 = icmp eq i8 %tmp211, 45
    br i1 %tmp212, label %then35, label %endif35
then35:
    %tmp213 = load i32, i32* %iterator
    %tmp214 = add i32 %tmp213, 1
    store i32 %tmp214, i32* %iterator
    br label %loop_body0
    br label %endif35
endif35:
    %tmp215 = load i8, i8* %char
    %tmp216 = icmp eq i8 %tmp215, 42
    br i1 %tmp216, label %then36, label %endif36
then36:
    %tmp217 = load i32, i32* %iterator
    %tmp218 = add i32 %tmp217, 1
    store i32 %tmp218, i32* %iterator
    br label %loop_body0
    br label %endif36
endif36:
    %tmp219 = load i8, i8* %char
    %tmp220 = icmp eq i8 %tmp219, 47
    br i1 %tmp220, label %then37, label %endif37
then37:
    %tmp221 = load i32, i32* %iterator
    %tmp222 = add i32 %tmp221, 1
    store i32 %tmp222, i32* %iterator
    br label %loop_body0
    br label %endif37
endif37:
    %tmp223 = load i8, i8* %char
    %tmp224 = icmp eq i8 %tmp223, 37
    br i1 %tmp224, label %then38, label %endif38
then38:
    %tmp225 = load i32, i32* %iterator
    %tmp226 = add i32 %tmp225, 1
    store i32 %tmp226, i32* %iterator
    br label %loop_body0
    br label %endif38
endif38:
    %tmp227 = load i8, i8* %char
    %tmp228 = icmp eq i8 %tmp227, 33
    br i1 %tmp228, label %then39, label %endif39
then39:
    %tmp229 = load i32, i32* %iterator
    %tmp230 = add i32 %tmp229, 1
    store i32 %tmp230, i32* %iterator
    br label %loop_body0
    br label %endif39
endif39:
    %tmp231 = load i8, i8* %char
    %tmp232 = icmp eq i8 %tmp231, 126
    br i1 %tmp232, label %then40, label %endif40
then40:
    %tmp233 = load i32, i32* %iterator
    %tmp234 = add i32 %tmp233, 1
    store i32 %tmp234, i32* %iterator
    br label %loop_body0
    br label %endif40
endif40:
    %tmp235 = load i8, i8* %char
    call void @console.print_char(i8 %tmp235)
    %tmp236 = load i32, i32* %iterator
    %tmp237 = add i32 %tmp236, 1
    store i32 %tmp237, i32* %iterator
    br label %loop_body0
loop_body0_exit:
    ret void
}

define i32 @main() {
    %tmp0 = call i32 @AllocConsole()
    call void @tests.run()
    %tmp1 = call i32 @window.start()
    %tmp2 = call i32 @FreeConsole()
    ret i32 0
}

define i64 @window.WindowProc(i8* %hWnd, i32 %uMsg, i64 %wParam, i64 %lParam) {
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

define i1 @window.is_null(i8* %p) {
    %tmp0 = icmp eq ptr %p, null
    ret i1 %tmp0
}

define i32 @window.start() {
    %CW_USEDEFAULT = alloca i32
    store i32 2147483648, i32* %CW_USEDEFAULT
    %hInstance = alloca i8*
    %tmp0 = call i8* @GetModuleHandleA(i8* null)
    %tmp1 = bitcast i8* %tmp0 to i8*
    store i8* %tmp1, i8** %hInstance
    %tmp2 = load i8*, i8** %hInstance
    %tmp3 = call i1 @window.is_null(i8* %tmp2)
    br i1 %tmp3, label %then0, label %endif0
then0:
    ret i32 1
    br label %endif0
endif0:
    %className = alloca i8*
    %tmp4 = getelementptr inbounds [14 x i8], [14 x i8]* @.str.10, i64 0, i64 0
    store i8* %tmp4, i8** %className
    %wc = alloca %struct.window.WNDCLASSEXA
    %tmp5 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %wc, i32 0, i32 0
    store i32 80, i32* %tmp5
    %tmp6 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %wc, i32 0, i32 1
    %tmp7 = or i32 2, 1
    store i32 %tmp7, i32* %tmp6
    %tmp8 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %wc, i32 0, i32 2
    store i64 (i8*, i32, i64, i64)** @window.WindowProc, i64 (i8*, i32, i64, i64)*** %tmp8
    %tmp9 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %wc, i32 0, i32 3
    store i32 0, i32* %tmp9
    %tmp10 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %wc, i32 0, i32 4
    store i32 0, i32* %tmp10
    %tmp11 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %wc, i32 0, i32 5
    %tmp12 = load i8*, i8** %hInstance
    store i8* %tmp12, i8** %tmp11
    %tmp13 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %wc, i32 0, i32 6
    store i8* null, i8** %tmp13
    %tmp14 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %wc, i32 0, i32 7
    store i8* null, i8** %tmp14
    %tmp15 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %wc, i32 0, i32 8
    %tmp16 = add i32 5, 1
    %tmp17 = inttoptr i32 %tmp16 to i8*
    store i8* %tmp17, i8** %tmp15
    %tmp18 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %wc, i32 0, i32 9
    store i8* null, i8** %tmp18
    %tmp19 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %wc, i32 0, i32 10
    %tmp20 = load i8*, i8** %className
    store i8* %tmp20, i8** %tmp19
    %tmp21 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %wc, i32 0, i32 11
    store i8* null, i8** %tmp21
    %tmp22 = call i16 @RegisterClassExA(%struct.window.WNDCLASSEXA* %wc)
    %tmp23 = icmp eq i16 %tmp22, 0
    br i1 %tmp23, label %then1, label %endif1
then1:
    ret i32 2
    br label %endif1
endif1:
    %windowTitle = alloca i8*
    %tmp24 = getelementptr inbounds [14 x i8], [14 x i8]* @.str.11, i64 0, i64 0
    store i8* %tmp24, i8** %windowTitle
    %hWnd = alloca i8*
    %tmp25 = load i8*, i8** %className
    %tmp26 = load i8*, i8** %windowTitle
    %tmp27 = load i32, i32* %CW_USEDEFAULT
    %tmp28 = load i32, i32* %CW_USEDEFAULT
    %tmp29 = load i8*, i8** %hInstance
    %tmp30 = call i8* @CreateWindowExA(i32 0, i8* %tmp25, i8* %tmp26, i32 13565952, i32 %tmp27, i32 %tmp28, i32 800, i32 600, i8* null, i8* null, i8* %tmp29, i8* null)
    store i8* %tmp30, i8** %hWnd
    %tmp31 = load i8*, i8** %hWnd
    %tmp32 = call i1 @window.is_null(i8* %tmp31)
    br i1 %tmp32, label %then2, label %endif2
then2:
    ret i32 3
    br label %endif2
endif2:
    %tmp33 = load i8*, i8** %hWnd
    %tmp34 = call i32 @ShowWindow(i8* %tmp33, i32 1)
    %tmp35 = load i8*, i8** %hWnd
    %tmp36 = call i32 @UpdateWindow(i8* %tmp35)
    %msg = alloca %struct.window.MSG
    br label %loop_body3
loop_body3:
    %result = alloca i32
    %tmp37 = call i32 @GetMessageA(%struct.window.MSG* %msg, i8* null, i32 0, i32 0)
    store i32 %tmp37, i32* %result
    %tmp38 = load i32, i32* %result
    %tmp39 = icmp sgt i32 %tmp38, 0
    br i1 %tmp39, label %then4, label %else4
then4:
    %tmp40 = call i32 @TranslateMessage(%struct.window.MSG* %msg)
    %tmp41 = call i64 @DispatchMessageA(%struct.window.MSG* %msg)
    br label %endif4
else4:
    br label %loop_body3_exit
    br label %endif4
endif4:
    br label %loop_body3
loop_body3_exit:
    %tmp42 = getelementptr inbounds %struct.window.MSG, %struct.window.MSG* %msg, i32 0, i32 2
    %tmp43 = load i64, i64* %tmp42
    %tmp44 = trunc i64 %tmp43 to i32
    ret i32 %tmp44
}
