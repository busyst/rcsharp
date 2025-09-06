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
declare dllimport i32 @PeekMessageA(%struct.window.MSG*,i8*,i32,i32,i32)
declare dllimport i32 @TranslateMessage(%struct.window.MSG*)
declare dllimport i64 @DispatchMessageA(%struct.window.MSG*)
declare dllimport i64 @DefWindowProcA(i8*,i32,i64,i64)
declare dllimport void @PostQuitMessage(i32)
declare dllimport i8* @GetModuleHandleA(i8*)
@.str.0 = private unnamed_addr constant [12 x i8] c"Exception: \00"
@.str.1 = private unnamed_addr constant [26 x i8] c"stdout handle was invalid\00"
@.str.2 = private unnamed_addr constant [2 x i8] c"-\00"
@.str.3 = private unnamed_addr constant [20 x i8] c"File  was not found\00"
@.str.4 = private unnamed_addr constant [17 x i8] c"File read failed\00"
@.str.5 = private unnamed_addr constant [10 x i8] c"fs_test: \00"
@.str.6 = private unnamed_addr constant [47 x i8] c"The quick brown fox jumps over crazy lost dog.\00"
@.str.7 = private unnamed_addr constant [9 x i8] c"test.txt\00"
@.str.8 = private unnamed_addr constant [38 x i8] c"Filesystem test failed, data mismatch\00"
@.str.9 = private unnamed_addr constant [3 x i8] c"OK\00"
@.str.10 = private unnamed_addr constant [32 x i8] c"D:\Projects\rcsharp\src.rcsharp\00"
@.str.11 = private unnamed_addr constant [14 x i8] c"MyWindowClass\00"
@.str.12 = private unnamed_addr constant [14 x i8] c"Hello, World!\00"


define void @__chkstk() {
    ret void
}

define %struct.string.String @process.get_executable_path() {
    %v0 = alloca %struct.string.String; var: string
    %tmp1 = call %struct.string.String @string.with_size(i32 260)
    store %struct.string.String %tmp1, %struct.string.String* %v0
    %v2 = alloca i32; var: len
    %tmp3 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
    %tmp4 = load i8*, i8** %tmp3
    %tmp5 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
    %tmp6 = load i32, i32* %tmp5
    %tmp8 = call i32 @GetModuleFileNameA(i8* null, i8* %tmp4, i32 %tmp6)
    store i32 %tmp8, i32* %v2
    %tmp9 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
    %tmp10 = load i32, i32* %v2
    store i32 %tmp10, i32* %tmp9
    %tmp12 = load %struct.string.String, %struct.string.String* %v0
    ret %struct.string.String %tmp12
}

define %struct.string.String @process.get_executable_env_path() {
    %v0 = alloca %struct.string.String; var: string
    %tmp1 = call %struct.string.String @process.get_executable_path()
    store %struct.string.String %tmp1, %struct.string.String* %v0
    %v2 = alloca i32; var: index
    %tmp3 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
    %tmp4 = load i32, i32* %tmp3
    %tmp5 = sub i32 %tmp4, 1
    store i32 %tmp5, i32* %v2
    br label %loop_body0
loop_body0:
    %tmp6 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
    %tmp7 = load i8*, i8** %tmp6
    %tmp8 = load i32, i32* %v2
    %tmp9 = getelementptr inbounds i8, i8* %tmp7, i32 %tmp8
    %tmp10 = load i8, i8* %tmp9
    %tmp11 = icmp eq i8 %tmp10, 92
    %tmp12 = load i32, i32* %v2
    %tmp13 = icmp slt i32 %tmp12, 0
    %tmp14 = or i1 %tmp11, %tmp13
    br i1 %tmp14, label %then1, label %endif1
then1:
    br label %loop_body0_exit
    br label %endif1
endif1:
    %tmp15 = load i32, i32* %v2
    %tmp16 = sub i32 %tmp15, 1
    store i32 %tmp16, i32* %v2
    br label %loop_body0
loop_body0_exit:
    %tmp17 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
    %tmp18 = load i32, i32* %v2
    %tmp19 = add i32 %tmp18, 1
    store i32 %tmp19, i32* %tmp17
    %tmp20 = load %struct.string.String, %struct.string.String* %v0
    ret %struct.string.String %tmp20
}

define void @process.throw(i8* %exception) {
    %v0 = alloca i32; var: len
    %tmp1 = call i32 @string_utils.c_str_len(i8* %exception)
    store i32 %tmp1, i32* %v0
    call i32 @AllocConsole()
    %v2 = alloca i32; var: chars_written
    %v3 = alloca i8*; var: stdout_handle
    %tmp4 = call i8* @GetStdHandle(i32 -11)
    store i8* %tmp4, i8** %v3
    %v5 = alloca i8*; var: e
    %tmp6 = getelementptr inbounds [12 x i8], [12 x i8]* @.str.0, i64 0, i64 0
    store i8* %tmp6, i8** %v5
    %tmp7 = load i8*, i8** %v3
    %tmp8 = load i8*, i8** %v5
    %tmp9 = load i8*, i8** %v5
    %tmp10 = call i32 @string_utils.c_str_len(i8* %tmp9)
    call i32 @WriteConsoleA(i8* %tmp7, i8* %tmp8, i32 %tmp10, i32* %v2, i8* null)
    %tmp11 = load i8*, i8** %v3
    %tmp12 = load i32, i32* %v0
    call i32 @WriteConsoleA(i8* %tmp11, i8* %exception, i32 %tmp12, i32* %v2, i8* null)
    %v13 = alloca i8; var: nl
    store i8 10, i8* %v13
    %tmp14 = load i8*, i8** %v3
    call i32 @WriteConsoleA(i8* %tmp14, i8* %v13, i32 1, i32* %v2, i8* null)
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
    call i32 @HeapFree(i32* %tmp0, i32 0, i8* %ptr)
    ret void
}

define void @mem.copy(i8* %src, i8* %dest, i64 %len) {
    %v0 = alloca i64; var: i
    store i64 0, i64* %v0
    br label %loop_body0
loop_body0:
    %tmp1 = load i64, i64* %v0
    %tmp2 = icmp sge i64 %tmp1, %len
    br i1 %tmp2, label %then1, label %endif1
then1:
    br label %loop_body0_exit
    br label %endif1
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
    br label %loop_body0
loop_body0_exit:
    ret void
}

define void @mem.zerofill(i8 %val, i8* %dest, i64 %len) {
    call void @mem.fill(i8 0, i8* %dest, i64 %len)
    ret void
}

define void @mem.fill(i8 %val, i8* %dest, i64 %len) {
    %v0 = alloca i64; var: i
    store i64 0, i64* %v0
    br label %loop_body0
loop_body0:
    %tmp1 = load i64, i64* %v0
    %tmp2 = icmp sge i64 %tmp1, %len
    br i1 %tmp2, label %then1, label %endif1
then1:
    br label %loop_body0_exit
    br label %endif1
endif1:
    %tmp3 = load i64, i64* %v0
    %tmp4 = getelementptr inbounds i8, i8* %dest, i64 %tmp3
    store i8 %val, i8* %tmp4
    %tmp5 = load i64, i64* %v0
    %tmp6 = add i64 %tmp5, 1
    store i64 %tmp6, i64* %v0
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
    %v0 = alloca %struct.list.ListNode*; var: new_node
    %tmp1 = call i8* @mem.malloc(i64 12)
    %tmp2 = bitcast i8* %tmp1 to %struct.list.ListNode*
    store %struct.list.ListNode* %tmp2, %struct.list.ListNode** %v0
    %tmp3 = getelementptr inbounds %struct.list.ListNode, %struct.list.ListNode* %v0, i32 0, i32 0
    store %struct.list.ListNode* null, %struct.list.ListNode** %tmp3
    %tmp4 = getelementptr inbounds %struct.list.ListNode, %struct.list.ListNode* %v0, i32 0, i32 1
    store i32 %data, i32* %tmp4
    %tmp5 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 0
    %tmp6 = load %struct.list.ListNode*, %struct.list.ListNode** %tmp5
    %tmp7 = icmp eq ptr %tmp6, null
    br i1 %tmp7, label %then0, label %else0
then0:
    %tmp8 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 0
    %tmp9 = load %struct.list.ListNode*, %struct.list.ListNode** %v0
    store %struct.list.ListNode* %tmp9, %struct.list.ListNode** %tmp8
    %tmp10 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 1
    %tmp11 = load %struct.list.ListNode*, %struct.list.ListNode** %v0
    store %struct.list.ListNode* %tmp11, %struct.list.ListNode** %tmp10
    br label %endif0
else0:
    %tmp12 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 1
    %tmp13 = getelementptr inbounds %struct.list.ListNode, %struct.list.ListNode* %tmp12, i32 0, i32 0
    %tmp14 = load %struct.list.ListNode*, %struct.list.ListNode** %v0
    store %struct.list.ListNode* %tmp14, %struct.list.ListNode** %tmp13
    %tmp15 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 1
    %tmp16 = load %struct.list.ListNode*, %struct.list.ListNode** %v0
    store %struct.list.ListNode* %tmp16, %struct.list.ListNode** %tmp15
    br label %endif0
endif0:
    %tmp17 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 2
    %tmp18 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 2
    %tmp19 = load i32, i32* %tmp18
    %tmp20 = add i32 %tmp19, 1
    store i32 %tmp20, i32* %tmp17
    ret void
}

define i32 @list.walk(%struct.list.List* %list) {
    %v0 = alloca i32; var: l
    store i32 0, i32* %v0
    %v1 = alloca %struct.list.ListNode*; var: ptr
    %tmp2 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 0
    %tmp3 = load %struct.list.ListNode*, %struct.list.ListNode** %tmp2
    store %struct.list.ListNode* %tmp3, %struct.list.ListNode** %v1
    br label %loop_body0
loop_body0:
    %tmp4 = load %struct.list.ListNode*, %struct.list.ListNode** %v1
    %tmp5 = icmp eq ptr %tmp4, null
    br i1 %tmp5, label %then1, label %endif1
then1:
    br label %loop_body0_exit
    br label %endif1
endif1:
    %tmp6 = load i32, i32* %v0
    %tmp7 = add i32 %tmp6, 1
    store i32 %tmp7, i32* %v0
    %tmp8 = getelementptr inbounds %struct.list.ListNode, %struct.list.ListNode* %v1, i32 0, i32 0
    %tmp9 = load %struct.list.ListNode*, %struct.list.ListNode** %tmp8
    store %struct.list.ListNode* %tmp9, %struct.list.ListNode** %v1
    br label %loop_body0
loop_body0_exit:
    %tmp10 = load i32, i32* %v0
    ret i32 %tmp10
}

define void @list.free(%struct.list.List* %list) {
    %v0 = alloca %struct.list.ListNode*; var: current
    %tmp1 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 0
    %tmp2 = load %struct.list.ListNode*, %struct.list.ListNode** %tmp1
    store %struct.list.ListNode* %tmp2, %struct.list.ListNode** %v0
    br label %loop_body0
loop_body0:
    %tmp3 = load %struct.list.ListNode*, %struct.list.ListNode** %v0
    %tmp4 = icmp eq ptr %tmp3, null
    br i1 %tmp4, label %then1, label %endif1
then1:
    br label %loop_body0_exit
    br label %endif1
endif1:
    %v5 = alloca %struct.list.ListNode*; var: next
    %tmp6 = getelementptr inbounds %struct.list.ListNode, %struct.list.ListNode* %v0, i32 0, i32 0
    %tmp7 = load %struct.list.ListNode*, %struct.list.ListNode** %tmp6
    store %struct.list.ListNode* %tmp7, %struct.list.ListNode** %v5
    %tmp8 = load %struct.list.ListNode*, %struct.list.ListNode** %v0
    %tmp9 = bitcast %struct.list.ListNode* %tmp8 to i8*
    call void @mem.free(i8* %tmp9)
    %tmp10 = load %struct.list.ListNode*, %struct.list.ListNode** %v5
    store %struct.list.ListNode* %tmp10, %struct.list.ListNode** %v0
    br label %loop_body0
loop_body0_exit:
    %tmp11 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 0
    store %struct.list.ListNode* null, %struct.list.ListNode** %tmp11
    %tmp12 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 1
    store %struct.list.ListNode* null, %struct.list.ListNode** %tmp12
    %tmp13 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 2
    store i32 0, i32* %tmp13
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
    %v5 = alloca i32; var: new_capacity
    store i32 4, i32* %v5
    %tmp6 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 2
    %tmp7 = load i32, i32* %tmp6
    %tmp8 = icmp ne i32 %tmp7, 0
    br i1 %tmp8, label %then1, label %endif1
then1:
    %tmp9 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 2
    %tmp10 = load i32, i32* %tmp9
    %tmp11 = mul i32 %tmp10, 2
    store i32 %tmp11, i32* %v5
    br label %endif1
endif1:
    %v12 = alloca i8*; var: new_array
    %tmp13 = load i32, i32* %v5
    %tmp14 = zext i32 %tmp13 to i64
    %tmp15 = mul i64 %tmp14, 1
    %tmp16 = call i8* @mem.malloc(i64 %tmp15)
    store i8* %tmp16, i8** %v12
    %tmp17 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 0
    %tmp18 = load i8*, i8** %tmp17
    %tmp19 = icmp ne ptr %tmp18, null
    br i1 %tmp19, label %then2, label %endif2
then2:
    %v20 = alloca i32; var: i
    store i32 0, i32* %v20
    br label %loop_body3
loop_body3:
    %tmp21 = load i32, i32* %v20
    %tmp22 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 1
    %tmp23 = load i32, i32* %tmp22
    %tmp24 = icmp uge i32 %tmp21, %tmp23
    br i1 %tmp24, label %then4, label %endif4
then4:
    br label %loop_body3_exit
    br label %endif4
endif4:
    %tmp25 = load i8*, i8** %v12
    %tmp26 = load i32, i32* %v20
    %tmp27 = getelementptr inbounds i8, i8* %tmp25, i32 %tmp26
    %tmp28 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 0
    %tmp29 = load i8*, i8** %tmp28
    %tmp30 = load i32, i32* %v20
    %tmp31 = getelementptr inbounds i8, i8* %tmp29, i32 %tmp30
    %tmp32 = load i8, i8* %tmp31
    store i8 %tmp32, i8* %tmp27
    %tmp33 = load i32, i32* %v20
    %tmp34 = add i32 %tmp33, 1
    store i32 %tmp34, i32* %v20
    br label %loop_body3
loop_body3_exit:
    %tmp35 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 0
    %tmp36 = load i8*, i8** %tmp35
    call void @mem.free(i8* %tmp36)
    br label %endif2
endif2:
    %tmp37 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 0
    %tmp38 = load i8*, i8** %v12
    store i8* %tmp38, i8** %tmp37
    %tmp39 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 2
    %tmp40 = load i32, i32* %v5
    store i32 %tmp40, i32* %tmp39
    br label %endif0
endif0:
    %tmp41 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 0
    %tmp42 = load i8*, i8** %tmp41
    %tmp43 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 1
    %tmp44 = load i32, i32* %tmp43
    %tmp45 = getelementptr inbounds i8, i8* %tmp42, i32 %tmp44
    store i8 %data, i8* %tmp45
    %tmp46 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 1
    %tmp47 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 1
    %tmp48 = load i32, i32* %tmp47
    %tmp49 = add i32 %tmp48, 1
    store i32 %tmp49, i32* %tmp46
    ret void
}

define void @vector.push_bulk(%struct.vector.Vec* %vec, i8* %data, i32 %data_len) {
    %v0 = alloca i32; var: index
    store i32 0, i32* %v0
    br label %loop_body0
loop_body0:
    %tmp1 = load i32, i32* %v0
    %tmp2 = icmp sge i32 %tmp1, %data_len
    br i1 %tmp2, label %then1, label %endif1
then1:
    br label %loop_body0_exit
    br label %endif1
endif1:
    %tmp3 = load i32, i32* %v0
    %tmp4 = getelementptr inbounds i8, i8* %data, i32 %tmp3
    %tmp5 = load i8, i8* %tmp4
    call void @vector.push(%struct.vector.Vec* %vec, i8 %tmp5)
    %tmp6 = load i32, i32* %v0
    %tmp7 = add i32 %tmp6, 1
    store i32 %tmp7, i32* %v0
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
    %v0 = alloca i8*; var: stdout_handle
    %tmp1 = call i8* @GetStdHandle(i32 -11)
    store i8* %tmp1, i8** %v0
    %tmp2 = load i8*, i8** %v0
    %tmp3 = inttoptr i64 -1 to i8*
    %tmp4 = icmp eq ptr %tmp2, %tmp3
    br i1 %tmp4, label %then0, label %endif0
then0:
    %tmp5 = getelementptr inbounds [26 x i8], [26 x i8]* @.str.1, i64 0, i64 0
    call void @process.throw(i8* %tmp5)
    br label %endif0
endif0:
    %tmp6 = load i8*, i8** %v0
    ret i8* %tmp6
}

define void @console.write(i8* %buffer, i32 %len) {
    %v0 = alloca i32; var: chars_written
    %tmp1 = call i8* @console.get_stdout()
    call i32 @WriteConsoleA(i8* %tmp1, i8* %buffer, i32 %len, i32* %v0, i8* null)
    %tmp2 = load i32, i32* %v0
    %tmp3 = icmp ne i32 %len, %tmp2
    br i1 %tmp3, label %then0, label %endif0
then0:
    call void @ExitProcess(i32 -2)
    br label %endif0
endif0:
    ret void
}

define void @console.write_string(%struct.string.String* %str) {
    %v0 = alloca i32; var: chars_written
    %tmp1 = call i8* @console.get_stdout()
    %tmp2 = getelementptr inbounds %struct.string.String, %struct.string.String* %str, i32 0, i32 0
    %tmp3 = load i8*, i8** %tmp2
    %tmp4 = getelementptr inbounds %struct.string.String, %struct.string.String* %str, i32 0, i32 1
    %tmp5 = load i32, i32* %tmp4
    call i32 @WriteConsoleA(i8* %tmp1, i8* %tmp3, i32 %tmp5, i32* %v0, i8* null)
    %tmp6 = getelementptr inbounds %struct.string.String, %struct.string.String* %str, i32 0, i32 1
    %tmp7 = load i32, i32* %tmp6
    %tmp8 = load i32, i32* %v0
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
    %v1 = alloca i32; var: chars_written
    %tmp2 = call i8* @console.get_stdout()
    call i32 @WriteConsoleA(i8* %tmp2, i8* %buffer, i32 %len, i32* %v1, i8* null)
    %tmp3 = load i32, i32* %v1
    %tmp4 = icmp ne i32 %len, %tmp3
    br i1 %tmp4, label %then1, label %endif1
then1:
    call void @ExitProcess(i32 -2)
    br label %endif1
endif1:
    %v5 = alloca i8; var: nl
    store i8 10, i8* %v5
    %tmp6 = call i8* @console.get_stdout()
    call i32 @WriteConsoleA(i8* %tmp6, i8* %v5, i32 1, i32* %v1, i8* null)
    ret void
}

define void @console.print_char(i8 %n) {
    %v0 = alloca i8; var: b
    store i8 %n, i8* %v0
    call void @console.write(i8* %v0, i32 1)
    ret void
}

define void @console.println_i64(i64 %n) {
    %tmp0 = icmp sge i64 %n, 0
    br i1 %tmp0, label %then0, label %else0
then0:
    call void @console.println_u64(i64 %n)
    br label %endif0
else0:
    %tmp2 = getelementptr inbounds [2 x i8], [2 x i8]* @.str.2, i64 0, i64 0
    call void @console.write(i8* %tmp2, i32 1)
    %tmp3 = sub i64 0, %n
    call void @console.println_u64(i64 %tmp3)
    br label %endif0
endif0:
    ret void
}

define void @console.println_u64(i64 %n) {
    %v0 = alloca %struct.vector.Vec; var: buffer
    call void @vector.new(%struct.vector.Vec* %v0)
    %tmp1 = icmp eq i64 %n, 0
    br i1 %tmp1, label %then0, label %endif0
then0:
    call void @vector.push(%struct.vector.Vec* %v0, i8 48)
    call void @vector.push(%struct.vector.Vec* %v0, i8 10)
    %tmp2 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %v0, i32 0, i32 0
    %tmp3 = load i8*, i8** %tmp2
    %tmp4 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %v0, i32 0, i32 1
    %tmp5 = load i32, i32* %tmp4
    call void @console.write(i8* %tmp3, i32 %tmp5)
    call void @vector.free(%struct.vector.Vec* %v0)
    ret void
    br label %endif0
endif0:
    %v7 = alloca i64; var: mut_n
    store i64 %n, i64* %v7
    br label %loop_body1
loop_body1:
    %tmp8 = load i64, i64* %v7
    %tmp9 = icmp eq i64 %tmp8, 0
    br i1 %tmp9, label %then2, label %endif2
then2:
    br label %loop_body1_exit
    br label %endif2
endif2:
    %v10 = alloca i8; var: digit_char
    %tmp11 = load i64, i64* %v7
    %tmp12 = urem i64 %tmp11, 10
    %tmp13 = trunc i64 %tmp12 to i8
    %tmp14 = add i8 %tmp13, 48
    store i8 %tmp14, i8* %v10
    %tmp15 = load i8, i8* %v10
    call void @vector.push(%struct.vector.Vec* %v0, i8 %tmp15)
    %tmp16 = load i64, i64* %v7
    %tmp17 = udiv i64 %tmp16, 10
    store i64 %tmp17, i64* %v7
    br label %loop_body1
loop_body1_exit:
    %v18 = alloca i32; var: i
    store i32 0, i32* %v18
    %v19 = alloca i32; var: j
    %tmp20 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %v0, i32 0, i32 1
    %tmp21 = load i32, i32* %tmp20
    %tmp22 = sub i32 %tmp21, 1
    store i32 %tmp22, i32* %v19
    br label %loop_body3
loop_body3:
    %tmp23 = load i32, i32* %v18
    %tmp24 = load i32, i32* %v19
    %tmp25 = icmp uge i32 %tmp23, %tmp24
    br i1 %tmp25, label %then4, label %endif4
then4:
    br label %loop_body3_exit
    br label %endif4
endif4:
    %v26 = alloca i8; var: temp
    %tmp27 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %v0, i32 0, i32 0
    %tmp28 = load i8*, i8** %tmp27
    %tmp29 = load i32, i32* %v18
    %tmp30 = getelementptr inbounds i8, i8* %tmp28, i32 %tmp29
    %tmp31 = load i8, i8* %tmp30
    store i8 %tmp31, i8* %v26
    %tmp32 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %v0, i32 0, i32 0
    %tmp33 = load i8*, i8** %tmp32
    %tmp34 = load i32, i32* %v18
    %tmp35 = getelementptr inbounds i8, i8* %tmp33, i32 %tmp34
    %tmp36 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %v0, i32 0, i32 0
    %tmp37 = load i8*, i8** %tmp36
    %tmp38 = load i32, i32* %v19
    %tmp39 = getelementptr inbounds i8, i8* %tmp37, i32 %tmp38
    %tmp40 = load i8, i8* %tmp39
    store i8 %tmp40, i8* %tmp35
    %tmp41 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %v0, i32 0, i32 0
    %tmp42 = load i8*, i8** %tmp41
    %tmp43 = load i32, i32* %v19
    %tmp44 = getelementptr inbounds i8, i8* %tmp42, i32 %tmp43
    %tmp45 = load i8, i8* %v26
    store i8 %tmp45, i8* %tmp44
    %tmp46 = load i32, i32* %v18
    %tmp47 = add i32 %tmp46, 1
    store i32 %tmp47, i32* %v18
    %tmp48 = load i32, i32* %v19
    %tmp49 = sub i32 %tmp48, 1
    store i32 %tmp49, i32* %v19
    br label %loop_body3
loop_body3_exit:
    call void @vector.push(%struct.vector.Vec* %v0, i8 10)
    %tmp50 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %v0, i32 0, i32 0
    %tmp51 = load i8*, i8** %tmp50
    %tmp52 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %v0, i32 0, i32 1
    %tmp53 = load i32, i32* %tmp52
    call void @console.write(i8* %tmp51, i32 %tmp53)
    call void @vector.free(%struct.vector.Vec* %v0)
    ret void
}

define %struct.string.String @string.from_c_string(i8* %c_string) {
    %v0 = alloca %struct.string.String; var: x
    %tmp1 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
    %tmp2 = call i32 @string_utils.c_str_len(i8* %c_string)
    store i32 %tmp2, i32* %tmp1
    %tmp3 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
    %tmp4 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
    %tmp5 = load i32, i32* %tmp4
    %tmp6 = sext i32 %tmp5 to i64
    %tmp7 = mul i64 %tmp6, 1
    %tmp8 = call i8* @mem.malloc(i64 %tmp7)
    store i8* %tmp8, i8** %tmp3
    %tmp9 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
    %tmp10 = load i8*, i8** %tmp9
    %tmp11 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
    %tmp12 = load i32, i32* %tmp11
    %tmp13 = sext i32 %tmp12 to i64
    call void @mem.copy(i8* %c_string, i8* %tmp10, i64 %tmp13)
    %tmp14 = load %struct.string.String, %struct.string.String* %v0
    ret %struct.string.String %tmp14
}

define %struct.string.String @string.empty() {
    %v0 = alloca %struct.string.String; var: x
    %tmp1 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
    store i8* null, i8** %tmp1
    %tmp2 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
    store i32 0, i32* %tmp2
    %tmp3 = load %struct.string.String, %struct.string.String* %v0
    ret %struct.string.String %tmp3
}

define %struct.string.String @string.with_size(i32 %size) {
    %v0 = alloca %struct.string.String; var: x
    %tmp1 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
    store i32 %size, i32* %tmp1
    %tmp2 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 0
    %tmp3 = sext i32 %size to i64
    %tmp4 = mul i64 %tmp3, 1
    %tmp5 = call i8* @mem.malloc(i64 %tmp4)
    store i8* %tmp5, i8** %tmp2
    %tmp6 = load %struct.string.String, %struct.string.String* %v0
    ret %struct.string.String %tmp6
}

define %struct.string.String @string.concat_with_c_string(%struct.string.String* %src_string, i8* %c_string) {
    %v0 = alloca i32; var: c_string_len
    %tmp1 = call i32 @string_utils.c_str_len(i8* %c_string)
    store i32 %tmp1, i32* %v0
    %v2 = alloca i8*; var: combined
    %tmp3 = load i32, i32* %v0
    %tmp4 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 1
    %tmp5 = load i32, i32* %tmp4
    %tmp6 = add i32 %tmp3, %tmp5
    %tmp7 = sext i32 %tmp6 to i64
    %tmp8 = mul i64 %tmp7, 1
    %tmp9 = call i8* @mem.malloc(i64 %tmp8)
    store i8* %tmp9, i8** %v2
    %tmp10 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 0
    %tmp11 = load i8*, i8** %tmp10
    %tmp12 = load i8*, i8** %v2
    %tmp13 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 1
    %tmp14 = load i32, i32* %tmp13
    %tmp15 = sext i32 %tmp14 to i64
    call void @mem.copy(i8* %tmp11, i8* %tmp12, i64 %tmp15)
    %tmp16 = load i8*, i8** %v2
    %tmp17 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 1
    %tmp18 = load i32, i32* %tmp17
    %tmp19 = sext i32 %tmp18 to i64
    %tmp20 = getelementptr i8, i8* %tmp16, i64 %tmp19
    %tmp21 = load i32, i32* %v0
    %tmp22 = sext i32 %tmp21 to i64
    call void @mem.copy(i8* %c_string, i8* %tmp20, i64 %tmp22)
    %v23 = alloca %struct.string.String; var: str
    %tmp24 = getelementptr inbounds %struct.string.String, %struct.string.String* %v23, i32 0, i32 0
    %tmp25 = load i8*, i8** %v2
    store i8* %tmp25, i8** %tmp24
    %tmp26 = getelementptr inbounds %struct.string.String, %struct.string.String* %v23, i32 0, i32 1
    %tmp27 = load i32, i32* %v0
    %tmp28 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 1
    %tmp29 = load i32, i32* %tmp28
    %tmp30 = add i32 %tmp27, %tmp29
    store i32 %tmp30, i32* %tmp26
    %tmp31 = load %struct.string.String, %struct.string.String* %v23
    ret %struct.string.String %tmp31
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
    %v5 = alloca i32; var: iter
    %tmp6 = getelementptr inbounds %struct.string.String, %struct.string.String* %first, i32 0, i32 1
    %tmp7 = load i32, i32* %tmp6
    %tmp8 = sub i32 %tmp7, 1
    store i32 %tmp8, i32* %v5
    br label %loop_body1
loop_body1:
    %tmp9 = load i32, i32* %v5
    %tmp10 = icmp slt i32 %tmp9, 0
    br i1 %tmp10, label %then2, label %endif2
then2:
    br label %loop_body1_exit
    br label %endif2
endif2:
    %tmp11 = getelementptr inbounds %struct.string.String, %struct.string.String* %first, i32 0, i32 0
    %tmp12 = load i8*, i8** %tmp11
    %tmp13 = load i32, i32* %v5
    %tmp14 = getelementptr inbounds i8, i8* %tmp12, i32 %tmp13
    %tmp15 = load i8, i8* %tmp14
    %tmp16 = getelementptr inbounds %struct.string.String, %struct.string.String* %second, i32 0, i32 0
    %tmp17 = load i8*, i8** %tmp16
    %tmp18 = load i32, i32* %v5
    %tmp19 = getelementptr inbounds i8, i8* %tmp17, i32 %tmp18
    %tmp20 = load i8, i8* %tmp19
    %tmp21 = icmp ne i8 %tmp15, %tmp20
    br i1 %tmp21, label %then3, label %endif3
then3:
    ret i1 0
    br label %endif3
endif3:
    %tmp22 = load i32, i32* %v5
    %tmp23 = sub i32 %tmp22, 1
    store i32 %tmp23, i32* %v5
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
    %v0 = alloca i32; var: len1
    %tmp1 = call i32 @string_utils.c_str_len(i8* %src1)
    store i32 %tmp1, i32* %v0
    %v2 = alloca i32; var: len2
    %tmp3 = call i32 @string_utils.c_str_len(i8* %src2)
    store i32 %tmp3, i32* %v2
    %v4 = alloca i8*; var: output
    %tmp5 = load i32, i32* %v0
    %tmp6 = load i32, i32* %v2
    %tmp7 = add i32 %tmp5, %tmp6
    %tmp8 = add i32 %tmp7, 1
    %tmp9 = sext i32 %tmp8 to i64
    %tmp10 = call i8* @mem.malloc(i64 %tmp9)
    store i8* %tmp10, i8** %v4
    %tmp11 = load i8*, i8** %v4
    %tmp12 = sext i32 %index to i64
    call void @mem.copy(i8* %src1, i8* %tmp11, i64 %tmp12)
    %tmp13 = load i8*, i8** %v4
    %tmp14 = getelementptr i8, i8* %tmp13, i32 %index
    %tmp15 = load i32, i32* %v2
    %tmp16 = sext i32 %tmp15 to i64
    call void @mem.copy(i8* %src2, i8* %tmp14, i64 %tmp16)
    %tmp17 = getelementptr i8, i8* %src1, i32 %index
    %tmp18 = load i8*, i8** %v4
    %tmp19 = getelementptr i8, i8* %tmp18, i32 %index
    %tmp20 = load i32, i32* %v2
    %tmp21 = getelementptr i8, i8* %tmp19, i32 %tmp20
    %tmp22 = load i32, i32* %v0
    %tmp23 = sub i32 %tmp22, %index
    %tmp24 = sext i32 %tmp23 to i64
    call void @mem.copy(i8* %tmp17, i8* %tmp21, i64 %tmp24)
    %tmp25 = load i8*, i8** %v4
    %tmp26 = load i32, i32* %v0
    %tmp27 = load i32, i32* %v2
    %tmp28 = add i32 %tmp26, %tmp27
    %tmp29 = getelementptr inbounds i8, i8* %tmp25, i32 %tmp28
    store i8 0, i8* %tmp29
    %tmp30 = load i8*, i8** %v4
    ret i8* %tmp30
}

define i32 @string_utils.c_str_len(i8* %str) {
    %v0 = alloca i32; var: len
    store i32 0, i32* %v0
    br label %loop_body0
loop_body0:
    %tmp1 = load i32, i32* %v0
    %tmp2 = getelementptr inbounds i8, i8* %str, i32 %tmp1
    %tmp3 = load i8, i8* %tmp2
    %tmp4 = icmp eq i8 %tmp3, 0
    br i1 %tmp4, label %then1, label %endif1
then1:
    br label %loop_body0_exit
    br label %endif1
endif1:
    %tmp5 = load i32, i32* %v0
    %tmp6 = add i32 %tmp5, 1
    store i32 %tmp6, i32* %v0
    br label %loop_body0
loop_body0_exit:
    %tmp7 = load i32, i32* %v0
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
    %v0 = alloca i32; var: CREATE_ALWAYS
    store i32 2, i32* %v0
    %v1 = alloca i32; var: GENERIC_WRITE
    store i32 1073741824, i32* %v1
    %v2 = alloca i32; var: FILE_ATTRIBUTE_NORMAL
    store i32 128, i32* %v2
    %v3 = alloca i8*; var: hFile
    %tmp4 = load i32, i32* %v1
    %tmp5 = load i32, i32* %v0
    %tmp6 = load i32, i32* %v2
    %tmp7 = call i8* @CreateFileA(i8* %path, i32 %tmp4, i32 0, i8* null, i32 %tmp5, i32 %tmp6, i8* null)
    store i8* %tmp7, i8** %v3
    %v8 = alloca i8*; var: INVALID_HANDLE_VALUE
    %tmp9 = inttoptr i64 -1 to i8*
    store i8* %tmp9, i8** %v8
    %tmp10 = load i8*, i8** %v3
    %tmp11 = load i8*, i8** %v8
    %tmp12 = icmp eq ptr %tmp10, %tmp11
    br i1 %tmp12, label %then0, label %endif0
then0:
    ret i32 0
    br label %endif0
endif0:
    %v13 = alloca i32; var: bytes_written
    store i32 0, i32* %v13
    %v14 = alloca i32; var: success
    %tmp15 = load i8*, i8** %v3
    %tmp16 = call i32 @WriteFile(i8* %tmp15, i8* %content, i32 %content_len, i32* %v13, i8* null)
    store i32 %tmp16, i32* %v14
    %tmp17 = load i8*, i8** %v3
    call i32 @CloseHandle(i8* %tmp17)
    %tmp18 = load i32, i32* %v14
    %tmp19 = icmp eq i32 %tmp18, 0
    br i1 %tmp19, label %then1, label %endif1
then1:
    ret i32 0
    br label %endif1
endif1:
    %tmp20 = load i32, i32* %v13
    %tmp21 = icmp ne i32 %tmp20, %content_len
    br i1 %tmp21, label %then2, label %endif2
then2:
    ret i32 0
    br label %endif2
endif2:
    ret i32 1
}

define %struct.string.String @fs.read_full_file_as_string(i8* %path) {
    %v0 = alloca i32; var: GENERIC_READ
    store i32 2147483648, i32* %v0
    %v1 = alloca i32; var: FILE_ATTRIBUTE_NORMAL
    store i32 128, i32* %v1
    %v2 = alloca i32; var: OPEN_EXISTING
    store i32 3, i32* %v2
    %v3 = alloca i8*; var: hFile
    %tmp4 = load i32, i32* %v0
    %tmp5 = load i32, i32* %v2
    %tmp6 = load i32, i32* %v1
    %tmp7 = call i8* @CreateFileA(i8* %path, i32 %tmp4, i32 0, i8* null, i32 %tmp5, i32 %tmp6, i8* null)
    store i8* %tmp7, i8** %v3
    %v8 = alloca i8*; var: INVALID_HANDLE_VALUE
    %tmp9 = inttoptr i64 -1 to i8*
    store i8* %tmp9, i8** %v8
    %tmp10 = load i8*, i8** %v3
    %tmp11 = load i8*, i8** %v8
    %tmp12 = icmp eq ptr %tmp10, %tmp11
    br i1 %tmp12, label %then0, label %endif0
then0:
    %tmp13 = getelementptr inbounds [20 x i8], [20 x i8]* @.str.3, i64 0, i64 0
    %tmp14 = call i8* @string_utils.insert(i8* %tmp13, i8* %path, i32 5)
    call void @process.throw(i8* %tmp14)
    br label %endif0
endif0:
    %v15 = alloca i64; var: file_size
    store i64 0, i64* %v15
    %tmp16 = load i8*, i8** %v3
    %tmp17 = call i32 @GetFileSizeEx(i8* %tmp16, i64* %v15)
    %tmp18 = icmp eq i32 %tmp17, 0
    br i1 %tmp18, label %then1, label %endif1
then1:
    %tmp19 = load i8*, i8** %v3
    call i32 @CloseHandle(i8* %tmp19)
    %tmp20 = call %struct.string.String @string.empty()
    ret %struct.string.String %tmp20
    br label %endif1
endif1:
    %v21 = alloca %struct.string.String; var: buffer
    %tmp22 = load i64, i64* %v15
    %tmp23 = trunc i64 %tmp22 to i32
    %tmp24 = add i32 %tmp23, 1
    %tmp25 = call %struct.string.String @string.with_size(i32 %tmp24)
    store %struct.string.String %tmp25, %struct.string.String* %v21
    %v26 = alloca i32; var: bytes_read
    store i32 0, i32* %v26
    %v27 = alloca i32; var: success
    %tmp28 = load i8*, i8** %v3
    %tmp29 = getelementptr inbounds %struct.string.String, %struct.string.String* %v21, i32 0, i32 0
    %tmp30 = load i8*, i8** %tmp29
    %tmp31 = load i64, i64* %v15
    %tmp32 = trunc i64 %tmp31 to i32
    %tmp33 = call i32 @ReadFile(i8* %tmp28, i8* %tmp30, i32 %tmp32, i32* %v26, i8* null)
    store i32 %tmp33, i32* %v27
    %tmp34 = load i8*, i8** %v3
    call i32 @CloseHandle(i8* %tmp34)
    %tmp35 = load i32, i32* %v27
    %tmp36 = icmp eq i32 %tmp35, 0
    %tmp37 = load i32, i32* %v26
    %tmp38 = zext i32 %tmp37 to i64
    %tmp39 = load i64, i64* %v15
    %tmp40 = icmp ne i64 %tmp38, %tmp39
    %tmp41 = or i1 %tmp36, %tmp40
    br i1 %tmp41, label %then2, label %endif2
then2:
    call void @string.free(%struct.string.String* %v21)
    %tmp42 = getelementptr inbounds [17 x i8], [17 x i8]* @.str.4, i64 0, i64 0
    call void @process.throw(i8* %tmp42)
    br label %endif2
endif2:
    %tmp43 = getelementptr inbounds %struct.string.String, %struct.string.String* %v21, i32 0, i32 1
    %tmp44 = load i64, i64* %v15
    %tmp45 = trunc i64 %tmp44 to i32
    store i32 %tmp45, i32* %tmp43
    %tmp46 = load %struct.string.String, %struct.string.String* %v21
    ret %struct.string.String %tmp46
}

define i32 @fs.create_file(i8* %path) {
    %v0 = alloca i32; var: CREATE_NEW
    store i32 1, i32* %v0
    %v1 = alloca i32; var: GENERIC_WRITE
    store i32 1073741824, i32* %v1
    %v2 = alloca i32; var: FILE_ATTRIBUTE_NORMAL
    store i32 128, i32* %v2
    %v3 = alloca i8*; var: hFile
    %tmp4 = load i32, i32* %v1
    %tmp5 = load i32, i32* %v0
    %tmp6 = load i32, i32* %v2
    %tmp7 = call i8* @CreateFileA(i8* %path, i32 %tmp4, i32 0, i8* null, i32 %tmp5, i32 %tmp6, i8* null)
    store i8* %tmp7, i8** %v3
    %v8 = alloca i8*; var: INVALID_HANDLE_VALUE
    %tmp9 = inttoptr i64 -1 to i8*
    store i8* %tmp9, i8** %v8
    %tmp10 = load i8*, i8** %v3
    %tmp11 = load i8*, i8** %v8
    %tmp12 = icmp eq ptr %tmp10, %tmp11
    br i1 %tmp12, label %then0, label %endif0
then0:
    ret i32 0
    br label %endif0
endif0:
    %tmp13 = load i8*, i8** %v3
    call i32 @CloseHandle(i8* %tmp13)
    ret i32 1
}

define i32 @fs.delete_file(i8* %path) {
    %tmp0 = call i32 @DeleteFileA(i8* %path)
    ret i32 %tmp0
}

define void @tests.run() {
    call void @tests.fs_test()
    ret void
}

define void @tests.fs_test() {
    %tmp0 = getelementptr inbounds [10 x i8], [10 x i8]* @.str.5, i64 0, i64 0
    call void @console.write(i8* %tmp0, i32 9)
    %v1 = alloca %struct.string.String; var: data
    %tmp2 = getelementptr inbounds [47 x i8], [47 x i8]* @.str.6, i64 0, i64 0
    %tmp3 = call %struct.string.String @string.from_c_string(i8* %tmp2)
    store %struct.string.String %tmp3, %struct.string.String* %v1
    %v4 = alloca %struct.string.String; var: env_path
    %tmp5 = call %struct.string.String @process.get_executable_env_path()
    store %struct.string.String %tmp5, %struct.string.String* %v4
    %v6 = alloca %struct.string.String; var: new_file_path
    %tmp7 = getelementptr inbounds [9 x i8], [9 x i8]* @.str.7, i64 0, i64 0
    %tmp8 = call %struct.string.String @string.concat_with_c_string(%struct.string.String* %v4, i8* %tmp7)
    store %struct.string.String %tmp8, %struct.string.String* %v6
    %v9 = alloca i8*; var: c_string
    %tmp10 = getelementptr inbounds %struct.string.String, %struct.string.String* %v6, i32 0, i32 1
    %tmp11 = load i32, i32* %tmp10
    %tmp12 = add i32 %tmp11, 1
    %tmp13 = sext i32 %tmp12 to i64
    %tmp14 = mul i64 %tmp13, 1
    %tmp15 = alloca i8, i64 %tmp14
    store i8* %tmp15, i8** %v9
    %tmp17 = bitcast %struct.string.String** %v6 to %struct.string.String**
    %tmp18 = load i8*, i8** %v9
    %tmp19 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp17, i32 0, i32 0
    %tmp20 = load i8*, i8** %tmp19
    %tmp21 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp17, i32 0, i32 1
    %tmp22 = load i32, i32* %tmp21
    %tmp23 = sext i32 %tmp22 to i64
    call void @mem.copy(i8* %tmp20, i8* %tmp18, i64 %tmp23)
    %tmp24 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp17, i32 0, i32 1
    %tmp25 = load i32, i32* %tmp24
    %tmp26 = getelementptr inbounds i8, i8* %tmp18, i32 %tmp25
    store i8 0, i8* %tmp26
    br label %inline_exit0
inline_exit0:
    %tmp27 = load i8*, i8** %v9
    call i32 @fs.create_file(i8* %tmp27)
    %tmp28 = load i8*, i8** %v9
    call i32 @fs.delete_file(i8* %tmp28)
    %tmp29 = load i8*, i8** %v9
    call i32 @fs.create_file(i8* %tmp29)
    %tmp30 = load i8*, i8** %v9
    %tmp31 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 0
    %tmp32 = load i8*, i8** %tmp31
    %tmp33 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 1
    %tmp34 = load i32, i32* %tmp33
    call i32 @fs.write_to_file(i8* %tmp30, i8* %tmp32, i32 %tmp34)
    %v36 = alloca %struct.string.String; var: read
    %tmp37 = load i8*, i8** %v9
    %tmp38 = call %struct.string.String @fs.read_full_file_as_string(i8* %tmp37)
    store %struct.string.String %tmp38, %struct.string.String* %v36
    %tmp39 = call i1 @string.equal(%struct.string.String* %v1, %struct.string.String* %v36)
    %tmp40 = xor i1 %tmp39, 1
    br i1 %tmp40, label %then1, label %endif1
then1:
    %tmp41 = getelementptr inbounds [38 x i8], [38 x i8]* @.str.8, i64 0, i64 0
    call void @process.throw(i8* %tmp41)
    br label %endif1
endif1:
    %tmp42 = load i8*, i8** %v9
    call i32 @fs.delete_file(i8* %tmp42)
    call void @string.free(%struct.string.String* %v36)
    call void @string.free(%struct.string.String* %v6)
    call void @string.free(%struct.string.String* %v4)
    call void @string.free(%struct.string.String* %v1)
    %tmp43 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.9, i64 0, i64 0
    call void @console.writeln(i8* %tmp43, i32 2)
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
    %v4 = alloca i8; var: char
    %tmp5 = getelementptr inbounds %struct.string.String, %struct.string.String* %file, i32 0, i32 0
    %tmp6 = load i8*, i8** %tmp5
    %tmp7 = load i32, i32* %iterator
    %tmp8 = getelementptr inbounds i8, i8* %tmp6, i32 %tmp7
    %tmp9 = load i8, i8* %tmp8
    store i8 %tmp9, i8* %v4
    %tmp10 = load i8, i8* %v4
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
    %v0 = alloca i8*; var: path
    %tmp1 = getelementptr inbounds [32 x i8], [32 x i8]* @.str.10, i64 0, i64 0
    store i8* %tmp1, i8** %v0
    %v2 = alloca %struct.string.String; var: file
    %tmp3 = load i8*, i8** %v0
    %tmp4 = call %struct.string.String @fs.read_full_file_as_string(i8* %tmp3)
    store %struct.string.String %tmp4, %struct.string.String* %v2
    %v5 = alloca %struct.vector.Vec; var: tokens
    call void @vector.new(%struct.vector.Vec* %v5)
    %v6 = alloca i32; var: iterator
    store i32 0, i32* %v6
    %v7 = alloca i8; var: char
    %v8 = alloca i8; var: next_char
    %v9 = alloca i32; var: index
    %v10 = alloca %struct.string.String; var: temp_string
    %v11 = alloca i32; var: line
    store i32 0, i32* %v11
    %v12 = alloca i32; var: line_index
    store i32 0, i32* %v12
    br label %loop_body0
loop_body0:
    %tmp13 = load i32, i32* %v6
    %tmp14 = getelementptr inbounds %struct.string.String, %struct.string.String* %v2, i32 0, i32 1
    %tmp15 = load i32, i32* %tmp14
    %tmp16 = icmp sge i32 %tmp13, %tmp15
    br i1 %tmp16, label %then1, label %endif1
then1:
    br label %loop_body0_exit
    br label %endif1
endif1:
    %tmp17 = getelementptr inbounds %struct.string.String, %struct.string.String* %v2, i32 0, i32 0
    %tmp18 = load i8*, i8** %tmp17
    %tmp19 = load i32, i32* %v6
    %tmp20 = getelementptr inbounds i8, i8* %tmp18, i32 %tmp19
    %tmp21 = load i8, i8* %tmp20
    store i8 %tmp21, i8* %v7
    %tmp22 = load i8, i8* %v7
    %tmp23 = icmp eq i8 %tmp22, 10
    br i1 %tmp23, label %then2, label %endif2
then2:
    %tmp24 = load i32, i32* %v11
    %tmp25 = add i32 %tmp24, 1
    store i32 %tmp25, i32* %v11
    %tmp26 = load i32, i32* %v6
    store i32 %tmp26, i32* %v12
    %tmp27 = load i32, i32* %v6
    %tmp28 = add i32 %tmp27, 1
    store i32 %tmp28, i32* %v6
    br label %loop_body0
    br label %endif2
endif2:
    %tmp29 = load i8, i8* %v7
    %tmp30 = icmp eq i8 %tmp29, 32
    %tmp31 = load i8, i8* %v7
    %tmp32 = icmp eq i8 %tmp31, 9
    %tmp33 = or i1 %tmp30, %tmp32
    %tmp34 = load i8, i8* %v7
    %tmp35 = icmp eq i8 %tmp34, 13
    %tmp36 = or i1 %tmp33, %tmp35
    %tmp37 = and i1 %tmp36, 1
    br i1 %tmp37, label %then3, label %endif3
then3:
    %tmp38 = load i32, i32* %v6
    %tmp39 = add i32 %tmp38, 1
    store i32 %tmp39, i32* %v6
    br label %loop_body0
    br label %endif3
endif3:
    %tmp40 = load i32, i32* %v6
    %tmp41 = add i32 %tmp40, 1
    %tmp42 = getelementptr inbounds %struct.string.String, %struct.string.String* %v2, i32 0, i32 1
    %tmp43 = load i32, i32* %tmp42
    %tmp44 = icmp slt i32 %tmp41, %tmp43
    br i1 %tmp44, label %then4, label %else4
then4:
    %tmp45 = getelementptr inbounds %struct.string.String, %struct.string.String* %v2, i32 0, i32 0
    %tmp46 = load i8*, i8** %tmp45
    %tmp47 = load i32, i32* %v6
    %tmp48 = add i32 %tmp47, 1
    %tmp49 = getelementptr inbounds i8, i8* %tmp46, i32 %tmp48
    %tmp50 = load i8, i8* %tmp49
    store i8 %tmp50, i8* %v8
    br label %endif4
else4:
    store i8 0, i8* %v8
    br label %endif4
endif4:
    %tmp51 = load i8, i8* %v7
    %tmp52 = icmp eq i8 %tmp51, 47
    %tmp53 = load i8, i8* %v8
    %tmp54 = icmp eq i8 %tmp53, 47
    %tmp55 = and i1 %tmp52, %tmp54
    br i1 %tmp55, label %then5, label %endif5
then5:
    %tmp56 = load i32, i32* %v6
    store i32 %tmp56, i32* %v9
    call void @tests.consume_while(%struct.string.String* %v2, i32* %v6, i1 (i8)** @tests.not_new_line)
    br label %loop_body0
    br label %endif5
endif5:
    %tmp57 = load i8, i8* %v7
    %tmp58 = call i1 @string_utils.is_ascii_num(i8 %tmp57)
    br i1 %tmp58, label %then6, label %endif6
then6:
    %tmp59 = load i32, i32* %v6
    store i32 %tmp59, i32* %v9
    %tmp60 = load i8, i8* %v8
    %tmp61 = icmp eq i8 %tmp60, 120
    %tmp62 = load i8, i8* %v8
    %tmp63 = icmp eq i8 %tmp62, 98
    %tmp64 = or i1 %tmp61, %tmp63
    br i1 %tmp64, label %then7, label %endif7
then7:
    %tmp65 = load i32, i32* %v6
    %tmp66 = add i32 %tmp65, 2
    store i32 %tmp66, i32* %v6
    br label %endif7
endif7:
    call void @tests.consume_while(%struct.string.String* %v2, i32* %v6, i1 (i8)** @tests.is_valid_number_token)
    %tmp67 = load i32, i32* %v6
    %tmp68 = load i32, i32* %v9
    %tmp69 = sub i32 %tmp67, %tmp68
    %tmp70 = call %struct.string.String @string.with_size(i32 %tmp69)
    store %struct.string.String %tmp70, %struct.string.String* %v10
    %tmp71 = getelementptr inbounds %struct.string.String, %struct.string.String* %v2, i32 0, i32 0
    %tmp72 = load i8*, i8** %tmp71
    %tmp73 = load i32, i32* %v9
    %tmp74 = getelementptr i8, i8* %tmp72, i32 %tmp73
    %tmp75 = getelementptr inbounds %struct.string.String, %struct.string.String* %v10, i32 0, i32 0
    %tmp76 = load i8*, i8** %tmp75
    %tmp77 = getelementptr inbounds %struct.string.String, %struct.string.String* %v10, i32 0, i32 1
    %tmp78 = load i32, i32* %tmp77
    %tmp79 = sext i32 %tmp78 to i64
    call void @mem.copy(i8* %tmp74, i8* %tmp76, i64 %tmp79)
    call void @string.free(%struct.string.String* %v10)
    br label %loop_body0
    br label %endif6
endif6:
    %tmp80 = load i8, i8* %v7
    %tmp81 = call i1 @string_utils.is_ascii_char(i8 %tmp80)
    %tmp82 = load i8, i8* %v7
    %tmp83 = icmp eq i8 %tmp82, 95
    %tmp84 = or i1 %tmp81, %tmp83
    br i1 %tmp84, label %then8, label %endif8
then8:
    %tmp85 = load i32, i32* %v6
    store i32 %tmp85, i32* %v9
    call void @tests.consume_while(%struct.string.String* %v2, i32* %v6, i1 (i8)** @tests.valid_name_token)
    %tmp86 = load i32, i32* %v6
    %tmp87 = load i32, i32* %v9
    %tmp88 = sub i32 %tmp86, %tmp87
    %tmp89 = call %struct.string.String @string.with_size(i32 %tmp88)
    store %struct.string.String %tmp89, %struct.string.String* %v10
    %tmp90 = getelementptr inbounds %struct.string.String, %struct.string.String* %v2, i32 0, i32 0
    %tmp91 = load i8*, i8** %tmp90
    %tmp92 = load i32, i32* %v9
    %tmp93 = getelementptr i8, i8* %tmp91, i32 %tmp92
    %tmp94 = getelementptr inbounds %struct.string.String, %struct.string.String* %v10, i32 0, i32 0
    %tmp95 = load i8*, i8** %tmp94
    %tmp96 = getelementptr inbounds %struct.string.String, %struct.string.String* %v10, i32 0, i32 1
    %tmp97 = load i32, i32* %tmp96
    %tmp98 = sext i32 %tmp97 to i64
    call void @mem.copy(i8* %tmp93, i8* %tmp95, i64 %tmp98)
    call void @string.free(%struct.string.String* %v10)
    br label %loop_body0
    br label %endif8
endif8:
    %tmp99 = load i8, i8* %v7
    %tmp100 = icmp eq i8 %tmp99, 34
    br i1 %tmp100, label %then9, label %endif9
then9:
    %tmp101 = load i32, i32* %v6
    store i32 %tmp101, i32* %v9
    br label %loop_body10
loop_body10:
    %tmp102 = load i32, i32* %v6
    %tmp103 = add i32 %tmp102, 1
    store i32 %tmp103, i32* %v6
    %tmp104 = load i32, i32* %v6
    %tmp105 = getelementptr inbounds %struct.string.String, %struct.string.String* %v2, i32 0, i32 1
    %tmp106 = load i32, i32* %tmp105
    %tmp107 = icmp sge i32 %tmp104, %tmp106
    br i1 %tmp107, label %then11, label %endif11
then11:
    br label %loop_body10_exit
    br label %endif11
endif11:
    %tmp108 = getelementptr inbounds %struct.string.String, %struct.string.String* %v2, i32 0, i32 0
    %tmp109 = load i8*, i8** %tmp108
    %tmp110 = load i32, i32* %v6
    %tmp111 = getelementptr inbounds i8, i8* %tmp109, i32 %tmp110
    %tmp112 = load i8, i8* %tmp111
    store i8 %tmp112, i8* %v7
    %tmp113 = load i8, i8* %v7
    %tmp114 = icmp ne i8 %tmp113, 34
    br i1 %tmp114, label %then12, label %endif12
then12:
    br label %loop_body10
    br label %endif12
endif12:
    %tmp115 = load i32, i32* %v6
    %tmp116 = add i32 %tmp115, 1
    store i32 %tmp116, i32* %v6
    br label %loop_body10_exit
    br label %loop_body10
loop_body10_exit:
    %tmp117 = load i32, i32* %v6
    %tmp118 = load i32, i32* %v9
    %tmp119 = sub i32 %tmp117, %tmp118
    %tmp120 = call %struct.string.String @string.with_size(i32 %tmp119)
    store %struct.string.String %tmp120, %struct.string.String* %v10
    %tmp121 = getelementptr inbounds %struct.string.String, %struct.string.String* %v2, i32 0, i32 0
    %tmp122 = load i8*, i8** %tmp121
    %tmp123 = load i32, i32* %v9
    %tmp124 = getelementptr i8, i8* %tmp122, i32 %tmp123
    %tmp125 = getelementptr inbounds %struct.string.String, %struct.string.String* %v10, i32 0, i32 0
    %tmp126 = load i8*, i8** %tmp125
    %tmp127 = getelementptr inbounds %struct.string.String, %struct.string.String* %v10, i32 0, i32 1
    %tmp128 = load i32, i32* %tmp127
    %tmp129 = sext i32 %tmp128 to i64
    call void @mem.copy(i8* %tmp124, i8* %tmp126, i64 %tmp129)
    call void @string.free(%struct.string.String* %v10)
    br label %loop_body0
    br label %endif9
endif9:
    %tmp130 = load i8, i8* %v7
    %tmp131 = icmp eq i8 %tmp130, 40
    br i1 %tmp131, label %then13, label %endif13
then13:
    %tmp132 = load i32, i32* %v6
    %tmp133 = add i32 %tmp132, 1
    store i32 %tmp133, i32* %v6
    br label %loop_body0
    br label %endif13
endif13:
    %tmp134 = load i8, i8* %v7
    %tmp135 = icmp eq i8 %tmp134, 41
    br i1 %tmp135, label %then14, label %endif14
then14:
    %tmp136 = load i32, i32* %v6
    %tmp137 = add i32 %tmp136, 1
    store i32 %tmp137, i32* %v6
    br label %loop_body0
    br label %endif14
endif14:
    %tmp138 = load i8, i8* %v7
    %tmp139 = icmp eq i8 %tmp138, 123
    br i1 %tmp139, label %then15, label %endif15
then15:
    %tmp140 = load i32, i32* %v6
    %tmp141 = add i32 %tmp140, 1
    store i32 %tmp141, i32* %v6
    br label %loop_body0
    br label %endif15
endif15:
    %tmp142 = load i8, i8* %v7
    %tmp143 = icmp eq i8 %tmp142, 125
    br i1 %tmp143, label %then16, label %endif16
then16:
    %tmp144 = load i32, i32* %v6
    %tmp145 = add i32 %tmp144, 1
    store i32 %tmp145, i32* %v6
    br label %loop_body0
    br label %endif16
endif16:
    %tmp146 = load i8, i8* %v7
    %tmp147 = icmp eq i8 %tmp146, 91
    br i1 %tmp147, label %then17, label %endif17
then17:
    %tmp148 = load i32, i32* %v6
    %tmp149 = add i32 %tmp148, 1
    store i32 %tmp149, i32* %v6
    br label %loop_body0
    br label %endif17
endif17:
    %tmp150 = load i8, i8* %v7
    %tmp151 = icmp eq i8 %tmp150, 93
    br i1 %tmp151, label %then18, label %endif18
then18:
    %tmp152 = load i32, i32* %v6
    %tmp153 = add i32 %tmp152, 1
    store i32 %tmp153, i32* %v6
    br label %loop_body0
    br label %endif18
endif18:
    %tmp154 = load i8, i8* %v7
    %tmp155 = icmp eq i8 %tmp154, 61
    br i1 %tmp155, label %then19, label %endif19
then19:
    %tmp156 = load i8, i8* %v8
    %tmp157 = icmp eq i8 %tmp156, 61
    br i1 %tmp157, label %then20, label %endif20
then20:
    %tmp158 = load i32, i32* %v6
    %tmp159 = add i32 %tmp158, 2
    store i32 %tmp159, i32* %v6
    br label %loop_body0
    br label %endif20
endif20:
    %tmp160 = load i32, i32* %v6
    %tmp161 = add i32 %tmp160, 1
    store i32 %tmp161, i32* %v6
    br label %loop_body0
    br label %endif19
endif19:
    %tmp162 = load i8, i8* %v7
    %tmp163 = icmp eq i8 %tmp162, 58
    br i1 %tmp163, label %then21, label %endif21
then21:
    %tmp164 = load i8, i8* %v8
    %tmp165 = icmp eq i8 %tmp164, 58
    br i1 %tmp165, label %then22, label %endif22
then22:
    %tmp166 = load i32, i32* %v6
    %tmp167 = add i32 %tmp166, 2
    store i32 %tmp167, i32* %v6
    br label %loop_body0
    br label %endif22
endif22:
    %tmp168 = load i32, i32* %v6
    %tmp169 = add i32 %tmp168, 1
    store i32 %tmp169, i32* %v6
    br label %loop_body0
    br label %endif21
endif21:
    %tmp170 = load i8, i8* %v7
    %tmp171 = icmp eq i8 %tmp170, 124
    br i1 %tmp171, label %then23, label %endif23
then23:
    %tmp172 = load i8, i8* %v8
    %tmp173 = icmp eq i8 %tmp172, 124
    br i1 %tmp173, label %then24, label %endif24
then24:
    %tmp174 = load i32, i32* %v6
    %tmp175 = add i32 %tmp174, 2
    store i32 %tmp175, i32* %v6
    br label %loop_body0
    br label %endif24
endif24:
    %tmp176 = load i32, i32* %v6
    %tmp177 = add i32 %tmp176, 1
    store i32 %tmp177, i32* %v6
    br label %loop_body0
    br label %endif23
endif23:
    %tmp178 = load i8, i8* %v7
    %tmp179 = icmp eq i8 %tmp178, 38
    br i1 %tmp179, label %then25, label %endif25
then25:
    %tmp180 = load i8, i8* %v8
    %tmp181 = icmp eq i8 %tmp180, 38
    br i1 %tmp181, label %then26, label %endif26
then26:
    %tmp182 = load i32, i32* %v6
    %tmp183 = add i32 %tmp182, 2
    store i32 %tmp183, i32* %v6
    br label %loop_body0
    br label %endif26
endif26:
    %tmp184 = load i32, i32* %v6
    %tmp185 = add i32 %tmp184, 1
    store i32 %tmp185, i32* %v6
    br label %loop_body0
    br label %endif25
endif25:
    %tmp186 = load i8, i8* %v7
    %tmp187 = icmp eq i8 %tmp186, 62
    br i1 %tmp187, label %then27, label %endif27
then27:
    %tmp188 = load i8, i8* %v8
    %tmp189 = icmp eq i8 %tmp188, 61
    br i1 %tmp189, label %then28, label %endif28
then28:
    %tmp190 = load i32, i32* %v6
    %tmp191 = add i32 %tmp190, 2
    store i32 %tmp191, i32* %v6
    br label %loop_body0
    br label %endif28
endif28:
    %tmp192 = load i32, i32* %v6
    %tmp193 = add i32 %tmp192, 1
    store i32 %tmp193, i32* %v6
    br label %loop_body0
    br label %endif27
endif27:
    %tmp194 = load i8, i8* %v7
    %tmp195 = icmp eq i8 %tmp194, 60
    br i1 %tmp195, label %then29, label %endif29
then29:
    %tmp196 = load i8, i8* %v8
    %tmp197 = icmp eq i8 %tmp196, 61
    br i1 %tmp197, label %then30, label %endif30
then30:
    %tmp198 = load i32, i32* %v6
    %tmp199 = add i32 %tmp198, 2
    store i32 %tmp199, i32* %v6
    br label %loop_body0
    br label %endif30
endif30:
    %tmp200 = load i32, i32* %v6
    %tmp201 = add i32 %tmp200, 1
    store i32 %tmp201, i32* %v6
    br label %loop_body0
    br label %endif29
endif29:
    %tmp202 = load i8, i8* %v7
    %tmp203 = icmp eq i8 %tmp202, 35
    br i1 %tmp203, label %then31, label %endif31
then31:
    %tmp204 = load i32, i32* %v6
    %tmp205 = add i32 %tmp204, 1
    store i32 %tmp205, i32* %v6
    br label %loop_body0
    br label %endif31
endif31:
    %tmp206 = load i8, i8* %v7
    %tmp207 = icmp eq i8 %tmp206, 59
    br i1 %tmp207, label %then32, label %endif32
then32:
    %tmp208 = load i32, i32* %v6
    %tmp209 = add i32 %tmp208, 1
    store i32 %tmp209, i32* %v6
    br label %loop_body0
    br label %endif32
endif32:
    %tmp210 = load i8, i8* %v7
    %tmp211 = icmp eq i8 %tmp210, 46
    br i1 %tmp211, label %then33, label %endif33
then33:
    %tmp212 = load i32, i32* %v6
    %tmp213 = add i32 %tmp212, 1
    store i32 %tmp213, i32* %v6
    br label %loop_body0
    br label %endif33
endif33:
    %tmp214 = load i8, i8* %v7
    %tmp215 = icmp eq i8 %tmp214, 44
    br i1 %tmp215, label %then34, label %endif34
then34:
    %tmp216 = load i32, i32* %v6
    %tmp217 = add i32 %tmp216, 1
    store i32 %tmp217, i32* %v6
    br label %loop_body0
    br label %endif34
endif34:
    %tmp218 = load i8, i8* %v7
    %tmp219 = icmp eq i8 %tmp218, 43
    br i1 %tmp219, label %then35, label %endif35
then35:
    %tmp220 = load i32, i32* %v6
    %tmp221 = add i32 %tmp220, 1
    store i32 %tmp221, i32* %v6
    br label %loop_body0
    br label %endif35
endif35:
    %tmp222 = load i8, i8* %v7
    %tmp223 = icmp eq i8 %tmp222, 45
    br i1 %tmp223, label %then36, label %endif36
then36:
    %tmp224 = load i32, i32* %v6
    %tmp225 = add i32 %tmp224, 1
    store i32 %tmp225, i32* %v6
    br label %loop_body0
    br label %endif36
endif36:
    %tmp226 = load i8, i8* %v7
    %tmp227 = icmp eq i8 %tmp226, 42
    br i1 %tmp227, label %then37, label %endif37
then37:
    %tmp228 = load i32, i32* %v6
    %tmp229 = add i32 %tmp228, 1
    store i32 %tmp229, i32* %v6
    br label %loop_body0
    br label %endif37
endif37:
    %tmp230 = load i8, i8* %v7
    %tmp231 = icmp eq i8 %tmp230, 47
    br i1 %tmp231, label %then38, label %endif38
then38:
    %tmp232 = load i32, i32* %v6
    %tmp233 = add i32 %tmp232, 1
    store i32 %tmp233, i32* %v6
    br label %loop_body0
    br label %endif38
endif38:
    %tmp234 = load i8, i8* %v7
    %tmp235 = icmp eq i8 %tmp234, 37
    br i1 %tmp235, label %then39, label %endif39
then39:
    %tmp236 = load i32, i32* %v6
    %tmp237 = add i32 %tmp236, 1
    store i32 %tmp237, i32* %v6
    br label %loop_body0
    br label %endif39
endif39:
    %tmp238 = load i8, i8* %v7
    %tmp239 = icmp eq i8 %tmp238, 33
    br i1 %tmp239, label %then40, label %endif40
then40:
    %tmp240 = load i32, i32* %v6
    %tmp241 = add i32 %tmp240, 1
    store i32 %tmp241, i32* %v6
    br label %loop_body0
    br label %endif40
endif40:
    %tmp242 = load i8, i8* %v7
    %tmp243 = icmp eq i8 %tmp242, 126
    br i1 %tmp243, label %then41, label %endif41
then41:
    %tmp244 = load i32, i32* %v6
    %tmp245 = add i32 %tmp244, 1
    store i32 %tmp245, i32* %v6
    br label %loop_body0
    br label %endif41
endif41:
    %tmp246 = load i8, i8* %v7
    call void @console.print_char(i8 %tmp246)
    call void @console.print_char(i8 10)
    %tmp247 = load i32, i32* %v11
    %tmp248 = sext i32 %tmp247 to i64
    call void @console.println_u64(i64 %tmp248)
    %tmp249 = load i32, i32* %v6
    %tmp250 = load i32, i32* %v12
    %tmp251 = sub i32 %tmp249, %tmp250
    %tmp252 = sext i32 %tmp251 to i64
    call void @console.println_u64(i64 %tmp252)
    %tmp253 = load i32, i32* %v6
    %tmp254 = add i32 %tmp253, 1
    store i32 %tmp254, i32* %v6
    br label %loop_body0
loop_body0_exit:
    ret void
}

define i32 @main() {
    call i32 @AllocConsole()
    call void @tests.run()
    call i32 @window.start()
    call i32 @FreeConsole()
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
    %v0 = alloca i32; var: CW_USEDEFAULT
    store i32 2147483648, i32* %v0
    %v1 = alloca i8*; var: hInstance
    %tmp2 = call i8* @GetModuleHandleA(i8* null)
    %tmp3 = bitcast i8* %tmp2 to i8*
    store i8* %tmp3, i8** %v1
    %tmp4 = load i8*, i8** %v1
    %tmp5 = call i1 @window.is_null(i8* %tmp4)
    br i1 %tmp5, label %then0, label %endif0
then0:
    ret i32 1
    br label %endif0
endif0:
    %v6 = alloca i8*; var: className
    %tmp7 = getelementptr inbounds [14 x i8], [14 x i8]* @.str.11, i64 0, i64 0
    store i8* %tmp7, i8** %v6
    %v8 = alloca %struct.window.WNDCLASSEXA; var: wc
    %tmp9 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v8, i32 0, i32 0
    store i32 80, i32* %tmp9
    %tmp10 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v8, i32 0, i32 1
    %tmp11 = or i32 2, 1
    store i32 %tmp11, i32* %tmp10
    %tmp12 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v8, i32 0, i32 2
    store i64 (i8*, i32, i64, i64)** @window.WindowProc, i64 (i8*, i32, i64, i64)*** %tmp12
    %tmp13 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v8, i32 0, i32 3
    store i32 0, i32* %tmp13
    %tmp14 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v8, i32 0, i32 4
    store i32 0, i32* %tmp14
    %tmp15 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v8, i32 0, i32 5
    %tmp16 = load i8*, i8** %v1
    store i8* %tmp16, i8** %tmp15
    %tmp17 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v8, i32 0, i32 6
    store i8* null, i8** %tmp17
    %tmp18 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v8, i32 0, i32 7
    store i8* null, i8** %tmp18
    %tmp19 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v8, i32 0, i32 8
    %tmp20 = add i32 5, 1
    %tmp21 = inttoptr i32 %tmp20 to i8*
    store i8* %tmp21, i8** %tmp19
    %tmp22 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v8, i32 0, i32 9
    store i8* null, i8** %tmp22
    %tmp23 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v8, i32 0, i32 10
    %tmp24 = load i8*, i8** %v6
    store i8* %tmp24, i8** %tmp23
    %tmp25 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %v8, i32 0, i32 11
    store i8* null, i8** %tmp25
    %tmp26 = call i16 @RegisterClassExA(%struct.window.WNDCLASSEXA* %v8)
    %tmp27 = icmp eq i16 %tmp26, 0
    br i1 %tmp27, label %then1, label %endif1
then1:
    ret i32 2
    br label %endif1
endif1:
    %v28 = alloca i8*; var: windowTitle
    %tmp29 = getelementptr inbounds [14 x i8], [14 x i8]* @.str.12, i64 0, i64 0
    store i8* %tmp29, i8** %v28
    %v30 = alloca i8*; var: hWnd
    %tmp31 = load i8*, i8** %v6
    %tmp32 = load i8*, i8** %v28
    %tmp33 = load i32, i32* %v0
    %tmp34 = load i32, i32* %v0
    %tmp35 = load i8*, i8** %v1
    %tmp36 = call i8* @CreateWindowExA(i32 0, i8* %tmp31, i8* %tmp32, i32 13565952, i32 %tmp33, i32 %tmp34, i32 800, i32 600, i8* null, i8* null, i8* %tmp35, i8* null)
    store i8* %tmp36, i8** %v30
    %tmp37 = load i8*, i8** %v30
    %tmp38 = call i1 @window.is_null(i8* %tmp37)
    br i1 %tmp38, label %then2, label %endif2
then2:
    ret i32 3
    br label %endif2
endif2:
    %tmp39 = load i8*, i8** %v30
    call i32 @ShowWindow(i8* %tmp39, i32 1)
    %tmp40 = load i8*, i8** %v30
    call i32 @UpdateWindow(i8* %tmp40)
    %v41 = alloca %struct.window.MSG; var: msg
    br label %loop_body3
loop_body3:
    %tmp42 = call i32 @PeekMessageA(%struct.window.MSG* %v41, i8* null, i32 0, i32 0, i32 1)
    %tmp43 = icmp ne i32 %tmp42, 0
    br i1 %tmp43, label %then4, label %endif4
then4:
    %tmp44 = getelementptr inbounds %struct.window.MSG, %struct.window.MSG* %v41, i32 0, i32 1
    %tmp45 = load i32, i32* %tmp44
    %tmp46 = icmp eq i32 %tmp45, 18
    br i1 %tmp46, label %then5, label %endif5
then5:
    br label %loop_body3_exit
    br label %endif5
endif5:
    call i32 @TranslateMessage(%struct.window.MSG* %v41)
    call i64 @DispatchMessageA(%struct.window.MSG* %v41)
    br label %endif4
endif4:
    br label %loop_body3
loop_body3_exit:
    %tmp47 = getelementptr inbounds %struct.window.MSG, %struct.window.MSG* %v41, i32 0, i32 2
    %tmp48 = load i64, i64* %tmp47
    %tmp49 = trunc i64 %tmp48 to i32
    ret i32 %tmp49
}
