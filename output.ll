target triple = "x86_64-pc-windows-msvc"
%struct.list.List = type {%struct.list.ListNode*, %struct.list.ListNode*, i32}
%struct.list.ListNode = type {%struct.list.ListNode*, i32}
%struct.vector.Vec = type {i8*, i32, i32}
%struct.string.String = type {i8*, i32}
%struct.window.WNDCLASSEXA = type {i32, i32, i64 (i8*, i32, i64, i64)*, i32, i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*}
%struct.window.POINT = type {i32, i32}
%struct.window.MSG = type {i8*, i32, i64, i64, i32, %struct.window.POINT}
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
@.str0 = internal constant [12 x i8] c"Exception: \00"
@.str1 = internal constant [2 x i8] c"-\00"
@.str2 = internal constant [20 x i8] c"File  was not found\00"
@.str3 = internal constant [17 x i8] c"File read failed\00"
@.str4 = internal constant [10 x i8] c"fs_test: \00"
@.str5 = internal constant [47 x i8] c"The quick brown fox jumps over crazy lost dog.\00"
@.str6 = internal constant [9 x i8] c"test.txt\00"
@.str7 = internal constant [38 x i8] c"Filesystem test failed, data mismatch\00"
@.str8 = internal constant [3 x i8] c"OK\00"
@.str9 = internal constant [32 x i8] c"D:\Projects\rcsharp\src.rcsharp\00"
@.str10 = internal constant [14 x i8] c"MyWindowClass\00"
@.str11 = internal constant [14 x i8] c"Hello, World!\00"


define void @__chkstk(){
    ret void

    unreachable
}

define %struct.string.String @process.get_executable_path(){
    %string = alloca %struct.string.String
    %tmp0 = getelementptr inbounds %struct.string.String, %struct.string.String* %string, i32 0
    %tmp1 = call %struct.string.String @string.with_size(i32 260)
    store %struct.string.String %tmp1, %struct.string.String* %tmp0
    %len = alloca i32
    %tmp2 = getelementptr inbounds i32, i32* %len, i32 0
    %tmp3 = getelementptr inbounds %struct.string.String, %struct.string.String* %string, i32 0
    %tmp4 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp3, i32 0, i32 0
    %tmp5 = load i8*, i8** %tmp4
    %tmp6 = getelementptr inbounds %struct.string.String, %struct.string.String* %string, i32 0
    %tmp7 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp6, i32 0, i32 1
    %tmp8 = load i32, i32* %tmp7
    %tmp9 = call i32 @GetModuleFileNameA(i8* null,i8* %tmp5,i32 %tmp8)
    store i32 %tmp9, i32* %tmp2
    %tmp10 = getelementptr inbounds %struct.string.String, %struct.string.String* %string, i32 0
    %tmp11 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp10, i32 0, i32 1
    %tmp12 = load i32, i32* %len
    store i32 %tmp12, i32* %tmp11
    %tmp13 = load %struct.string.String, %struct.string.String* %string
    ret %struct.string.String %tmp13

    unreachable
}

define %struct.string.String @process.get_executable_env_path(){
    %string = alloca %struct.string.String
    %tmp0 = getelementptr inbounds %struct.string.String, %struct.string.String* %string, i32 0
    %tmp1 = call %struct.string.String @process.get_executable_path()
    store %struct.string.String %tmp1, %struct.string.String* %tmp0
    %index = alloca i32
    %tmp2 = getelementptr inbounds i32, i32* %index, i32 0
    %tmp3 = getelementptr inbounds %struct.string.String, %struct.string.String* %string, i32 0
    %tmp4 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp3, i32 0, i32 1
    %tmp5 = load i32, i32* %tmp4
    %tmp6 = sub i32 %tmp5, 1
    store i32 %tmp6, i32* %tmp2
    br label %loop_body0
loop_body0:
    %tmp7 = getelementptr inbounds %struct.string.String, %struct.string.String* %string, i32 0
    %tmp8 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp7, i32 0, i32 0
    %tmp9 = load i8*, i8** %tmp8
    %tmp10 = load i32, i32* %index
    %tmp11 = sext i32 %tmp10 to i64
    %tmp12 = getelementptr i8, i8* %tmp9, i64 %tmp11
    %tmp13 = load i8, i8* %tmp12
    %tmp14 = icmp eq i8 %tmp13, 92
    %tmp15 = load i32, i32* %index
    %tmp16 = icmp slt i32 %tmp15, 0
    %tmp17 = or i1 %tmp14, %tmp16
    br i1 %tmp17, label %then1, label %end_if1
then1:
    br label %loop_body0_exit
    br label %end_if1
end_if1:
    %tmp18 = getelementptr inbounds i32, i32* %index, i32 0
    %tmp19 = load i32, i32* %index
    %tmp20 = sub i32 %tmp19, 1
    store i32 %tmp20, i32* %tmp18
    br label %loop_body0
loop_body0_exit:
    %tmp21 = getelementptr inbounds %struct.string.String, %struct.string.String* %string, i32 0
    %tmp22 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp21, i32 0, i32 1
    %tmp23 = load i32, i32* %index
    %tmp24 = add i32 %tmp23, 1
    store i32 %tmp24, i32* %tmp22
    %tmp25 = load %struct.string.String, %struct.string.String* %string
    ret %struct.string.String %tmp25

    unreachable
}

define void @process.throw(i8* %exception){
    %len = alloca i32
    %tmp0 = getelementptr inbounds i32, i32* %len, i32 0
    %tmp1 = call i32 @string_utils.c_str_len(i8* %exception)
    store i32 %tmp1, i32* %tmp0
    call i32 @AllocConsole()
    %chars_written = alloca i32
    %stdout_handle = alloca i8*
    %tmp2 = getelementptr inbounds i8*, i8** %stdout_handle, i32 0
    %tmp3 = call i8* @GetStdHandle(i32 -11)
    store i8* %tmp3, i8** %tmp2
    %e = alloca i8*
    %tmp4 = getelementptr inbounds i8*, i8** %e, i32 0
    %tmp5 = getelementptr inbounds [12 x i8], ptr @.str0, i64 0, i64 0
    store i8* %tmp5, i8** %tmp4
    %tmp6 = load i8*, i8** %stdout_handle
    %tmp7 = load i8*, i8** %e
    %tmp8 = load i8*, i8** %e
    %tmp9 = call i32 @string_utils.c_str_len(i8* %tmp8)
    %tmp10 = getelementptr inbounds i32, i32* %chars_written, i32 0
    call i32 @WriteConsoleA(i8* %tmp6,i8* %tmp7,i32 %tmp9,i32* %tmp10,i8* null)
    %tmp11 = load i8*, i8** %stdout_handle
    %tmp12 = load i32, i32* %len
    %tmp13 = getelementptr inbounds i32, i32* %chars_written, i32 0
    call i32 @WriteConsoleA(i8* %tmp11,i8* %exception,i32 %tmp12,i32* %tmp13,i8* null)
    %nl = alloca i8
    %tmp14 = getelementptr inbounds i8, i8* %nl, i32 0
    store i8 10, i8* %tmp14
    %tmp15 = load i8*, i8** %stdout_handle
    %tmp16 = getelementptr inbounds i8, i8* %nl, i32 0
    %tmp17 = getelementptr inbounds i32, i32* %chars_written, i32 0
    call i32 @WriteConsoleA(i8* %tmp15,i8* %tmp16,i32 1,i32* %tmp17,i8* null)
    call void @ExitProcess(i32 -1)
    ret void

    unreachable
}

define i8* @mem.malloc(i64 %size){
    %tmp0 = call i32* @GetProcessHeap()
    %tmp1 = call i8* @HeapAlloc(i32* %tmp0,i32 0,i64 %size)
    ret i8* %tmp1

    unreachable
}

define void @mem.free(i8* %ptr){
    %tmp0 = call i32* @GetProcessHeap()
    call i32 @HeapFree(i32* %tmp0,i32 0,i8* %ptr)
    ret void

    unreachable
}

define void @mem.copy(i8* %src, i8* %dest, i64 %len){
    %i = alloca i64
    %tmp0 = getelementptr inbounds i64, i64* %i, i32 0
    store i64 0, i64* %tmp0
    br label %loop_body2
loop_body2:
    %tmp1 = load i64, i64* %i
    %tmp2 = icmp sge i64 %tmp1, %len
    br i1 %tmp2, label %then3, label %end_if3
then3:
    br label %loop_body2_exit
    br label %end_if3
end_if3:
    %tmp3 = load i64, i64* %i
    %tmp4 = getelementptr i8, i8* %dest, i64 %tmp3
    %tmp5 = load i64, i64* %i
    %tmp6 = getelementptr i8, i8* %src, i64 %tmp5
    %tmp7 = load i8, i8* %tmp6
    store i8 %tmp7, i8* %tmp4
    %tmp8 = getelementptr inbounds i64, i64* %i, i32 0
    %tmp9 = load i64, i64* %i
    %tmp10 = add i64 %tmp9, 1
    store i64 %tmp10, i64* %tmp8
    br label %loop_body2
loop_body2_exit:
    ret void

    unreachable
}

define void @mem.zerofill(i8 %val, i8* %dest, i64 %len){
    call void @mem.fill(i8 0,i8* %dest,i64 %len)
    ret void

    unreachable
}

define void @mem.fill(i8 %val, i8* %dest, i64 %len){
    %i = alloca i64
    %tmp0 = getelementptr inbounds i64, i64* %i, i32 0
    store i64 0, i64* %tmp0
    br label %loop_body4
loop_body4:
    %tmp1 = load i64, i64* %i
    %tmp2 = icmp sge i64 %tmp1, %len
    br i1 %tmp2, label %then5, label %end_if5
then5:
    br label %loop_body4_exit
    br label %end_if5
end_if5:
    %tmp3 = load i64, i64* %i
    %tmp4 = getelementptr i8, i8* %dest, i64 %tmp3
    store i8 %val, i8* %tmp4
    %tmp5 = getelementptr inbounds i64, i64* %i, i32 0
    %tmp6 = load i64, i64* %i
    %tmp7 = add i64 %tmp6, 1
    store i64 %tmp7, i64* %tmp5
    br label %loop_body4
loop_body4_exit:
    ret void

    unreachable
}

define void @list.new(%struct.list.List* %list){
    %tmp0 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 0
    store %struct.list.ListNode* null, %struct.list.ListNode** %tmp0
    %tmp1 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 1
    store %struct.list.ListNode* null, %struct.list.ListNode** %tmp1
    %tmp2 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 2
    store i32 0, i32* %tmp2
    ret void

    unreachable
}

define void @list.new_node(%struct.list.ListNode* %list){
    %tmp0 = getelementptr inbounds %struct.list.ListNode, %struct.list.ListNode* %list, i32 0, i32 0
    store %struct.list.ListNode* null, %struct.list.ListNode** %tmp0
    %tmp1 = getelementptr inbounds %struct.list.ListNode, %struct.list.ListNode* %list, i32 0, i32 1
    store i32 0, i32* %tmp1
    ret void

    unreachable
}

define void @list.extend(%struct.list.List* %list, i32 %data){
    %new_node = alloca %struct.list.ListNode*
    %tmp0 = getelementptr inbounds %struct.list.ListNode*, %struct.list.ListNode** %new_node, i32 0
    %tmp1 = call i8* @mem.malloc(i64 12)
    %tmp2 = bitcast i8* %tmp1 to %struct.list.ListNode*
    store %struct.list.ListNode* %tmp2, %struct.list.ListNode** %tmp0
    %tmp3 = getelementptr inbounds %struct.list.ListNode*, %struct.list.ListNode** %new_node, i32 0
    %tmp4 = getelementptr inbounds %struct.list.ListNode, %struct.list.ListNode* %tmp3, i32 0, i32 0
    store %struct.list.ListNode* null, %struct.list.ListNode** %tmp4
    %tmp5 = getelementptr inbounds %struct.list.ListNode*, %struct.list.ListNode** %new_node, i32 0
    %tmp6 = getelementptr inbounds %struct.list.ListNode, %struct.list.ListNode* %tmp5, i32 0, i32 1
    store i32 %data, i32* %tmp6
    %tmp7 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 0
    %tmp8 = load %struct.list.ListNode*, %struct.list.ListNode** %tmp7
    %tmp9 = icmp eq ptr %tmp8, null
    br i1 %tmp9, label %then6, label %else6
then6:
    %tmp10 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 0
    %tmp11 = load %struct.list.ListNode*, %struct.list.ListNode** %new_node
    store %struct.list.ListNode* %tmp11, %struct.list.ListNode** %tmp10
    %tmp12 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 1
    %tmp13 = load %struct.list.ListNode*, %struct.list.ListNode** %new_node
    store %struct.list.ListNode* %tmp13, %struct.list.ListNode** %tmp12
    br label %end_if6
else6:
    %tmp14 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 1
    %tmp15 = getelementptr inbounds %struct.list.ListNode, %struct.list.ListNode* %tmp14, i32 0, i32 0
    %tmp16 = load %struct.list.ListNode*, %struct.list.ListNode** %new_node
    store %struct.list.ListNode* %tmp16, %struct.list.ListNode** %tmp15
    %tmp17 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 1
    %tmp18 = load %struct.list.ListNode*, %struct.list.ListNode** %new_node
    store %struct.list.ListNode* %tmp18, %struct.list.ListNode** %tmp17
    br label %end_if6
end_if6:
    %tmp19 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 2
    %tmp20 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 2
    %tmp21 = load i32, i32* %tmp20
    %tmp22 = add i32 %tmp21, 1
    store i32 %tmp22, i32* %tmp19
    ret void

    unreachable
}

define i32 @list.walk(%struct.list.List* %list){
    %l = alloca i32
    %tmp0 = getelementptr inbounds i32, i32* %l, i32 0
    store i32 0, i32* %tmp0
    %ptr = alloca %struct.list.ListNode*
    %tmp1 = getelementptr inbounds %struct.list.ListNode*, %struct.list.ListNode** %ptr, i32 0
    %tmp2 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 0
    %tmp3 = load %struct.list.ListNode*, %struct.list.ListNode** %tmp2
    store %struct.list.ListNode* %tmp3, %struct.list.ListNode** %tmp1
    br label %loop_body7
loop_body7:
    %tmp4 = load %struct.list.ListNode*, %struct.list.ListNode** %ptr
    %tmp5 = icmp eq ptr %tmp4, null
    br i1 %tmp5, label %then8, label %end_if8
then8:
    br label %loop_body7_exit
    br label %end_if8
end_if8:
    %tmp6 = getelementptr inbounds i32, i32* %l, i32 0
    %tmp7 = load i32, i32* %l
    %tmp8 = add i32 %tmp7, 1
    store i32 %tmp8, i32* %tmp6
    %tmp9 = getelementptr inbounds %struct.list.ListNode*, %struct.list.ListNode** %ptr, i32 0
    %tmp10 = getelementptr inbounds %struct.list.ListNode*, %struct.list.ListNode** %ptr, i32 0
    %tmp11 = getelementptr inbounds %struct.list.ListNode, %struct.list.ListNode* %tmp10, i32 0, i32 0
    %tmp12 = load %struct.list.ListNode*, %struct.list.ListNode** %tmp11
    store %struct.list.ListNode* %tmp12, %struct.list.ListNode** %tmp9
    br label %loop_body7
loop_body7_exit:
    %tmp13 = load i32, i32* %l
    ret i32 %tmp13

    unreachable
}

define void @list.free(%struct.list.List* %list){
    %current = alloca %struct.list.ListNode*
    %tmp0 = getelementptr inbounds %struct.list.ListNode*, %struct.list.ListNode** %current, i32 0
    %tmp1 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 0
    %tmp2 = load %struct.list.ListNode*, %struct.list.ListNode** %tmp1
    store %struct.list.ListNode* %tmp2, %struct.list.ListNode** %tmp0
    br label %loop_body9
loop_body9:
    %tmp3 = load %struct.list.ListNode*, %struct.list.ListNode** %current
    %tmp4 = icmp eq ptr %tmp3, null
    br i1 %tmp4, label %then10, label %end_if10
then10:
    br label %loop_body9_exit
    br label %end_if10
end_if10:
    %next = alloca %struct.list.ListNode*
    %tmp5 = getelementptr inbounds %struct.list.ListNode*, %struct.list.ListNode** %next, i32 0
    %tmp6 = getelementptr inbounds %struct.list.ListNode*, %struct.list.ListNode** %current, i32 0
    %tmp7 = getelementptr inbounds %struct.list.ListNode, %struct.list.ListNode* %tmp6, i32 0, i32 0
    %tmp8 = load %struct.list.ListNode*, %struct.list.ListNode** %tmp7
    store %struct.list.ListNode* %tmp8, %struct.list.ListNode** %tmp5
    %tmp9 = load %struct.list.ListNode*, %struct.list.ListNode** %current
    %tmp10 = bitcast %struct.list.ListNode* %tmp9 to i8*
    call void @mem.free(i8* %tmp10)
    %tmp11 = getelementptr inbounds %struct.list.ListNode*, %struct.list.ListNode** %current, i32 0
    %tmp12 = load %struct.list.ListNode*, %struct.list.ListNode** %next
    store %struct.list.ListNode* %tmp12, %struct.list.ListNode** %tmp11
    br label %loop_body9
loop_body9_exit:
    %tmp13 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 0
    store %struct.list.ListNode* null, %struct.list.ListNode** %tmp13
    %tmp14 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 1
    store %struct.list.ListNode* null, %struct.list.ListNode** %tmp14
    %tmp15 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 2
    store i32 0, i32* %tmp15
    ret void

    unreachable
}

define void @vector.new(%struct.vector.Vec* %vec){
    %tmp0 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 0
    store i8* null, i8** %tmp0
    %tmp1 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 1
    store i32 0, i32* %tmp1
    %tmp2 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 2
    store i32 0, i32* %tmp2
    ret void

    unreachable
}

define void @vector.push(%struct.vector.Vec* %vec, i8 %data){
    %tmp0 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 1
    %tmp1 = load i32, i32* %tmp0
    %tmp2 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 2
    %tmp3 = load i32, i32* %tmp2
    %tmp4 = icmp uge i32 %tmp1, %tmp3
    br i1 %tmp4, label %then11, label %end_if11
then11:
    %new_capacity = alloca i32
    %tmp5 = getelementptr inbounds i32, i32* %new_capacity, i32 0
    store i32 4, i32* %tmp5
    %tmp6 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 2
    %tmp7 = load i32, i32* %tmp6
    %tmp8 = icmp ne i32 %tmp7, 0
    br i1 %tmp8, label %then12, label %end_if12
then12:
    %tmp9 = getelementptr inbounds i32, i32* %new_capacity, i32 0
    %tmp10 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 2
    %tmp11 = load i32, i32* %tmp10
    %tmp12 = mul i32 %tmp11, 2
    store i32 %tmp12, i32* %tmp9
    br label %end_if12
end_if12:
    %new_array = alloca i8*
    %tmp13 = getelementptr inbounds i8*, i8** %new_array, i32 0
    %tmp14 = load i32, i32* %new_capacity
    %tmp15 = zext i32 %tmp14 to i64
    %tmp16 = mul i64 %tmp15, 1
    %tmp17 = call i8* @mem.malloc(i64 %tmp16)
    store i8* %tmp17, i8** %tmp13
    %tmp18 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 0
    %tmp19 = load i8*, i8** %tmp18
    %tmp20 = icmp ne ptr %tmp19, null
    br i1 %tmp20, label %then13, label %end_if13
then13:
    %i = alloca i32
    %tmp21 = getelementptr inbounds i32, i32* %i, i32 0
    store i32 0, i32* %tmp21
    br label %loop_body14
loop_body14:
    %tmp22 = load i32, i32* %i
    %tmp23 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 1
    %tmp24 = load i32, i32* %tmp23
    %tmp25 = icmp uge i32 %tmp22, %tmp24
    br i1 %tmp25, label %then15, label %end_if15
then15:
    br label %loop_body14_exit
    br label %end_if15
end_if15:
    %tmp26 = load i8*, i8** %new_array
    %tmp27 = load i32, i32* %i
    %tmp28 = zext i32 %tmp27 to i64
    %tmp29 = getelementptr i8, i8* %tmp26, i64 %tmp28
    %tmp30 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 0
    %tmp31 = load i8*, i8** %tmp30
    %tmp32 = load i32, i32* %i
    %tmp33 = zext i32 %tmp32 to i64
    %tmp34 = getelementptr i8, i8* %tmp31, i64 %tmp33
    %tmp35 = load i8, i8* %tmp34
    store i8 %tmp35, i8* %tmp29
    %tmp36 = getelementptr inbounds i32, i32* %i, i32 0
    %tmp37 = load i32, i32* %i
    %tmp38 = add i32 %tmp37, 1
    store i32 %tmp38, i32* %tmp36
    br label %loop_body14
loop_body14_exit:
    %tmp39 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 0
    %tmp40 = load i8*, i8** %tmp39
    call void @mem.free(i8* %tmp40)
    br label %end_if13
end_if13:
    %tmp41 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 0
    %tmp42 = load i8*, i8** %new_array
    store i8* %tmp42, i8** %tmp41
    %tmp43 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 2
    %tmp44 = load i32, i32* %new_capacity
    store i32 %tmp44, i32* %tmp43
    br label %end_if11
end_if11:
    %tmp45 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 0
    %tmp46 = load i8*, i8** %tmp45
    %tmp47 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 1
    %tmp48 = load i32, i32* %tmp47
    %tmp49 = zext i32 %tmp48 to i64
    %tmp50 = getelementptr i8, i8* %tmp46, i64 %tmp49
    store i8 %data, i8* %tmp50
    %tmp51 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 1
    %tmp52 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 1
    %tmp53 = load i32, i32* %tmp52
    %tmp54 = add i32 %tmp53, 1
    store i32 %tmp54, i32* %tmp51
    ret void

    unreachable
}

define void @vector.push_bulk(%struct.vector.Vec* %vec, i8* %data, i32 %data_len){
    %index = alloca i32
    %tmp0 = getelementptr inbounds i32, i32* %index, i32 0
    store i32 0, i32* %tmp0
    br label %loop_body16
loop_body16:
    %tmp1 = load i32, i32* %index
    %tmp2 = icmp sge i32 %tmp1, %data_len
    br i1 %tmp2, label %then17, label %end_if17
then17:
    br label %loop_body16_exit
    br label %end_if17
end_if17:
    %tmp3 = load i32, i32* %index
    %tmp4 = sext i32 %tmp3 to i64
    %tmp5 = getelementptr i8, i8* %data, i64 %tmp4
    %tmp6 = load i8, i8* %tmp5
    call void @vector.push(%struct.vector.Vec* %vec,i8 %tmp6)
    %tmp7 = getelementptr inbounds i32, i32* %index, i32 0
    %tmp8 = load i32, i32* %index
    %tmp9 = add i32 %tmp8, 1
    store i32 %tmp9, i32* %tmp7
    br label %loop_body16
loop_body16_exit:
    ret void

    unreachable
}

define void @vector.free(%struct.vector.Vec* %vec){
    %tmp0 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 0
    %tmp1 = load i8*, i8** %tmp0
    %tmp2 = icmp ne ptr %tmp1, null
    br i1 %tmp2, label %then18, label %end_if18
then18:
    %tmp3 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 0
    %tmp4 = load i8*, i8** %tmp3
    call void @mem.free(i8* %tmp4)
    br label %end_if18
end_if18:
    %tmp5 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 0
    store i8* null, i8** %tmp5
    %tmp6 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 1
    store i32 0, i32* %tmp6
    %tmp7 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 2
    store i32 0, i32* %tmp7
    ret void

    unreachable
}

define i8* @console.get_stdout(){
    %stdout_handle = alloca i8*
    %tmp0 = getelementptr inbounds i8*, i8** %stdout_handle, i32 0
    %tmp1 = call i8* @GetStdHandle(i32 -11)
    store i8* %tmp1, i8** %tmp0
    %tmp2 = load i8*, i8** %stdout_handle
    %tmp3 = inttoptr i64 18446744073709551615 to i8*
    %tmp4 = icmp eq ptr %tmp2, %tmp3
    br i1 %tmp4, label %then19, label %end_if19
then19:
    call void @ExitProcess(i32 -1)
    br label %end_if19
end_if19:
    %tmp5 = load i8*, i8** %stdout_handle
    ret i8* %tmp5

    unreachable
}

define void @console.write(i8* %buffer, i32 %len){
    %chars_written = alloca i32
    %tmp0 = call i8* @console.get_stdout()
    %tmp1 = getelementptr inbounds i32, i32* %chars_written, i32 0
    call i32 @WriteConsoleA(i8* %tmp0,i8* %buffer,i32 %len,i32* %tmp1,i8* null)
    %tmp2 = load i32, i32* %chars_written
    %tmp3 = icmp ne i32 %len, %tmp2
    br i1 %tmp3, label %then20, label %end_if20
then20:
    call void @ExitProcess(i32 -2)
    br label %end_if20
end_if20:
    ret void

    unreachable
}

define void @console.write_string(%struct.string.String* %str){
    %chars_written = alloca i32
    %tmp0 = call i8* @console.get_stdout()
    %tmp1 = getelementptr inbounds %struct.string.String, %struct.string.String* %str, i32 0, i32 0
    %tmp2 = load i8*, i8** %tmp1
    %tmp3 = getelementptr inbounds %struct.string.String, %struct.string.String* %str, i32 0, i32 1
    %tmp4 = load i32, i32* %tmp3
    %tmp5 = getelementptr inbounds i32, i32* %chars_written, i32 0
    call i32 @WriteConsoleA(i8* %tmp0,i8* %tmp2,i32 %tmp4,i32* %tmp5,i8* null)
    %tmp6 = getelementptr inbounds %struct.string.String, %struct.string.String* %str, i32 0, i32 1
    %tmp7 = load i32, i32* %tmp6
    %tmp8 = load i32, i32* %chars_written
    %tmp9 = icmp ne i32 %tmp7, %tmp8
    br i1 %tmp9, label %then21, label %end_if21
then21:
    call void @ExitProcess(i32 -2)
    br label %end_if21
end_if21:
    ret void

    unreachable
}

define void @console.writeln(i8* %buffer, i32 %len){
    %tmp0 = icmp eq i32 %len, 0
    br i1 %tmp0, label %then22, label %end_if22
then22:
    ret void
    br label %end_if22
end_if22:
    %chars_written = alloca i32
    %tmp1 = call i8* @console.get_stdout()
    %tmp2 = getelementptr inbounds i32, i32* %chars_written, i32 0
    call i32 @WriteConsoleA(i8* %tmp1,i8* %buffer,i32 %len,i32* %tmp2,i8* null)
    %tmp3 = load i32, i32* %chars_written
    %tmp4 = icmp ne i32 %len, %tmp3
    br i1 %tmp4, label %then23, label %end_if23
then23:
    call void @ExitProcess(i32 -2)
    br label %end_if23
end_if23:
    %nl = alloca i8
    %tmp5 = getelementptr inbounds i8, i8* %nl, i32 0
    store i8 10, i8* %tmp5
    %tmp6 = call i8* @console.get_stdout()
    %tmp7 = getelementptr inbounds i8, i8* %nl, i32 0
    %tmp8 = getelementptr inbounds i32, i32* %chars_written, i32 0
    call i32 @WriteConsoleA(i8* %tmp6,i8* %tmp7,i32 1,i32* %tmp8,i8* null)
    ret void

    unreachable
}

define void @console.print_char(i8 %n){
    %b = alloca i8
    %tmp0 = getelementptr inbounds i8, i8* %b, i32 0
    store i8 %n, i8* %tmp0
    %tmp1 = getelementptr inbounds i8, i8* %b, i32 0
    call void @console.write(i8* %tmp1,i32 1)
    ret void

    unreachable
}

define void @console.println_i64(i64 %n){
    %tmp0 = icmp sge i64 %n, 0
    br i1 %tmp0, label %then24, label %else24
then24:
    call void @console.println_u64(i64 %n)
    br label %end_if24
else24:
    %tmp1 = getelementptr inbounds [2 x i8], ptr @.str1, i64 0, i64 0
    call void @console.write(i8* %tmp1,i32 1)
    %tmp2 = sub i64 0, %n
    call void @console.println_u64(i64 %tmp2)
    br label %end_if24
end_if24:
    ret void

    unreachable
}

define void @console.println_u64(i64 %n){
    %buffer = alloca %struct.vector.Vec
    %tmp0 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %buffer, i32 0
    call void @vector.new(%struct.vector.Vec* %tmp0)
    %tmp1 = icmp eq i64 %n, 0
    br i1 %tmp1, label %then25, label %end_if25
then25:
    %tmp2 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %buffer, i32 0
    call void @vector.push(%struct.vector.Vec* %tmp2,i8 48)
    %tmp3 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %buffer, i32 0
    call void @vector.push(%struct.vector.Vec* %tmp3,i8 10)
    %tmp4 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %buffer, i32 0
    %tmp5 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %tmp4, i32 0, i32 0
    %tmp6 = load i8*, i8** %tmp5
    %tmp7 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %buffer, i32 0
    %tmp8 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %tmp7, i32 0, i32 1
    %tmp9 = load i32, i32* %tmp8
    call void @console.write(i8* %tmp6,i32 %tmp9)
    %tmp10 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %buffer, i32 0
    call void @vector.free(%struct.vector.Vec* %tmp10)
    ret void
    br label %end_if25
end_if25:
    %mut_n = alloca i64
    %tmp11 = getelementptr inbounds i64, i64* %mut_n, i32 0
    store i64 %n, i64* %tmp11
    br label %loop_body26
loop_body26:
    %tmp12 = load i64, i64* %mut_n
    %tmp13 = icmp eq i64 %tmp12, 0
    br i1 %tmp13, label %then27, label %end_if27
then27:
    br label %loop_body26_exit
    br label %end_if27
end_if27:
    %digit_char = alloca i8
    %tmp14 = getelementptr inbounds i8, i8* %digit_char, i32 0
    %tmp15 = load i64, i64* %mut_n
    %tmp16 = urem i64 %tmp15, 10
    %tmp17 = trunc i64 %tmp16 to i8
    %tmp18 = add i8 %tmp17, 48
    store i8 %tmp18, i8* %tmp14
    %tmp19 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %buffer, i32 0
    %tmp20 = load i8, i8* %digit_char
    call void @vector.push(%struct.vector.Vec* %tmp19,i8 %tmp20)
    %tmp21 = getelementptr inbounds i64, i64* %mut_n, i32 0
    %tmp22 = load i64, i64* %mut_n
    %tmp23 = udiv i64 %tmp22, 10
    store i64 %tmp23, i64* %tmp21
    br label %loop_body26
loop_body26_exit:
    %i = alloca i32
    %tmp24 = getelementptr inbounds i32, i32* %i, i32 0
    store i32 0, i32* %tmp24
    %j = alloca i32
    %tmp25 = getelementptr inbounds i32, i32* %j, i32 0
    %tmp26 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %buffer, i32 0
    %tmp27 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %tmp26, i32 0, i32 1
    %tmp28 = load i32, i32* %tmp27
    %tmp29 = sub i32 %tmp28, 1
    store i32 %tmp29, i32* %tmp25
    br label %loop_body28
loop_body28:
    %tmp30 = load i32, i32* %i
    %tmp31 = load i32, i32* %j
    %tmp32 = icmp uge i32 %tmp30, %tmp31
    br i1 %tmp32, label %then29, label %end_if29
then29:
    br label %loop_body28_exit
    br label %end_if29
end_if29:
    %temp = alloca i8
    %tmp33 = getelementptr inbounds i8, i8* %temp, i32 0
    %tmp34 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %buffer, i32 0
    %tmp35 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %tmp34, i32 0, i32 0
    %tmp36 = load i8*, i8** %tmp35
    %tmp37 = load i32, i32* %i
    %tmp38 = zext i32 %tmp37 to i64
    %tmp39 = getelementptr i8, i8* %tmp36, i64 %tmp38
    %tmp40 = load i8, i8* %tmp39
    store i8 %tmp40, i8* %tmp33
    %tmp41 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %buffer, i32 0
    %tmp42 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %tmp41, i32 0, i32 0
    %tmp43 = load i8*, i8** %tmp42
    %tmp44 = load i32, i32* %i
    %tmp45 = zext i32 %tmp44 to i64
    %tmp46 = getelementptr i8, i8* %tmp43, i64 %tmp45
    %tmp47 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %buffer, i32 0
    %tmp48 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %tmp47, i32 0, i32 0
    %tmp49 = load i8*, i8** %tmp48
    %tmp50 = load i32, i32* %j
    %tmp51 = zext i32 %tmp50 to i64
    %tmp52 = getelementptr i8, i8* %tmp49, i64 %tmp51
    %tmp53 = load i8, i8* %tmp52
    store i8 %tmp53, i8* %tmp46
    %tmp54 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %buffer, i32 0
    %tmp55 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %tmp54, i32 0, i32 0
    %tmp56 = load i8*, i8** %tmp55
    %tmp57 = load i32, i32* %j
    %tmp58 = zext i32 %tmp57 to i64
    %tmp59 = getelementptr i8, i8* %tmp56, i64 %tmp58
    %tmp60 = load i8, i8* %temp
    store i8 %tmp60, i8* %tmp59
    %tmp61 = getelementptr inbounds i32, i32* %i, i32 0
    %tmp62 = load i32, i32* %i
    %tmp63 = add i32 %tmp62, 1
    store i32 %tmp63, i32* %tmp61
    %tmp64 = getelementptr inbounds i32, i32* %j, i32 0
    %tmp65 = load i32, i32* %j
    %tmp66 = sub i32 %tmp65, 1
    store i32 %tmp66, i32* %tmp64
    br label %loop_body28
loop_body28_exit:
    %tmp67 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %buffer, i32 0
    call void @vector.push(%struct.vector.Vec* %tmp67,i8 10)
    %tmp68 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %buffer, i32 0
    %tmp69 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %tmp68, i32 0, i32 0
    %tmp70 = load i8*, i8** %tmp69
    %tmp71 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %buffer, i32 0
    %tmp72 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %tmp71, i32 0, i32 1
    %tmp73 = load i32, i32* %tmp72
    call void @console.write(i8* %tmp70,i32 %tmp73)
    %tmp74 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %buffer, i32 0
    call void @vector.free(%struct.vector.Vec* %tmp74)
    ret void

    unreachable
}

define %struct.string.String @string.from_c_string(i8* %c_string){
    %x = alloca %struct.string.String
    %tmp0 = getelementptr inbounds %struct.string.String, %struct.string.String* %x, i32 0
    %tmp1 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp0, i32 0, i32 1
    %tmp2 = call i32 @string_utils.c_str_len(i8* %c_string)
    store i32 %tmp2, i32* %tmp1
    %tmp3 = getelementptr inbounds %struct.string.String, %struct.string.String* %x, i32 0
    %tmp4 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp3, i32 0, i32 0
    %tmp5 = getelementptr inbounds %struct.string.String, %struct.string.String* %x, i32 0
    %tmp6 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp5, i32 0, i32 1
    %tmp7 = load i32, i32* %tmp6
    %tmp8 = sext i32 %tmp7 to i64
    %tmp9 = mul i64 %tmp8, 1
    %tmp10 = call i8* @mem.malloc(i64 %tmp9)
    store i8* %tmp10, i8** %tmp4
    %tmp11 = getelementptr inbounds %struct.string.String, %struct.string.String* %x, i32 0
    %tmp12 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp11, i32 0, i32 0
    %tmp13 = load i8*, i8** %tmp12
    %tmp14 = getelementptr inbounds %struct.string.String, %struct.string.String* %x, i32 0
    %tmp15 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp14, i32 0, i32 1
    %tmp16 = load i32, i32* %tmp15
    %tmp17 = sext i32 %tmp16 to i64
    call void @mem.copy(i8* %c_string,i8* %tmp13,i64 %tmp17)
    %tmp18 = load %struct.string.String, %struct.string.String* %x
    ret %struct.string.String %tmp18

    unreachable
}

define %struct.string.String @string.empty(){
    %x = alloca %struct.string.String
    %tmp0 = getelementptr inbounds %struct.string.String, %struct.string.String* %x, i32 0
    %tmp1 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp0, i32 0, i32 0
    store i8* null, i8** %tmp1
    %tmp2 = getelementptr inbounds %struct.string.String, %struct.string.String* %x, i32 0
    %tmp3 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp2, i32 0, i32 1
    store i32 0, i32* %tmp3
    %tmp4 = load %struct.string.String, %struct.string.String* %x
    ret %struct.string.String %tmp4

    unreachable
}

define %struct.string.String @string.with_size(i32 %size){
    %x = alloca %struct.string.String
    %tmp0 = getelementptr inbounds %struct.string.String, %struct.string.String* %x, i32 0
    %tmp1 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp0, i32 0, i32 1
    store i32 %size, i32* %tmp1
    %tmp2 = getelementptr inbounds %struct.string.String, %struct.string.String* %x, i32 0
    %tmp3 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp2, i32 0, i32 0
    %tmp4 = sext i32 %size to i64
    %tmp5 = mul i64 %tmp4, 1
    %tmp6 = call i8* @mem.malloc(i64 %tmp5)
    store i8* %tmp6, i8** %tmp3
    %tmp7 = load %struct.string.String, %struct.string.String* %x
    ret %struct.string.String %tmp7

    unreachable
}

define %struct.string.String @string.concat_with_c_string(%struct.string.String* %src_string, i8* %c_string){
    %c_string_len = alloca i32
    %tmp0 = getelementptr inbounds i32, i32* %c_string_len, i32 0
    %tmp1 = call i32 @string_utils.c_str_len(i8* %c_string)
    store i32 %tmp1, i32* %tmp0
    %combined = alloca i8*
    %tmp2 = getelementptr inbounds i8*, i8** %combined, i32 0
    %tmp3 = load i32, i32* %c_string_len
    %tmp4 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 1
    %tmp5 = load i32, i32* %tmp4
    %tmp6 = add i32 %tmp3, %tmp5
    %tmp7 = sext i32 %tmp6 to i64
    %tmp8 = mul i64 %tmp7, 1
    %tmp9 = call i8* @mem.malloc(i64 %tmp8)
    store i8* %tmp9, i8** %tmp2
    %tmp10 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 0
    %tmp11 = load i8*, i8** %tmp10
    %tmp12 = load i8*, i8** %combined
    %tmp13 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 1
    %tmp14 = load i32, i32* %tmp13
    %tmp15 = sext i32 %tmp14 to i64
    call void @mem.copy(i8* %tmp11,i8* %tmp12,i64 %tmp15)
    %tmp16 = load i8*, i8** %combined
    %tmp17 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 1
    %tmp18 = load i32, i32* %tmp17
    %tmp19 = sext i32 %tmp18 to i64
    %tmp20 = getelementptr i8, i8* %tmp16, i64 %tmp19
    %tmp21 = load i32, i32* %c_string_len
    %tmp22 = sext i32 %tmp21 to i64
    call void @mem.copy(i8* %c_string,i8* %tmp20,i64 %tmp22)
    %str = alloca %struct.string.String
    %tmp23 = getelementptr inbounds %struct.string.String, %struct.string.String* %str, i32 0
    %tmp24 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp23, i32 0, i32 0
    %tmp25 = load i8*, i8** %combined
    store i8* %tmp25, i8** %tmp24
    %tmp26 = getelementptr inbounds %struct.string.String, %struct.string.String* %str, i32 0
    %tmp27 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp26, i32 0, i32 1
    %tmp28 = load i32, i32* %c_string_len
    %tmp29 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 1
    %tmp30 = load i32, i32* %tmp29
    %tmp31 = add i32 %tmp28, %tmp30
    store i32 %tmp31, i32* %tmp27
    %tmp32 = load %struct.string.String, %struct.string.String* %str
    ret %struct.string.String %tmp32

    unreachable
}

define i1 @string.equal(%struct.string.String* %first, %struct.string.String* %second){
    %tmp0 = getelementptr inbounds %struct.string.String, %struct.string.String* %first, i32 0, i32 1
    %tmp1 = load i32, i32* %tmp0
    %tmp2 = getelementptr inbounds %struct.string.String, %struct.string.String* %second, i32 0, i32 1
    %tmp3 = load i32, i32* %tmp2
    %tmp4 = icmp ne i32 %tmp1, %tmp3
    br i1 %tmp4, label %then30, label %end_if30
then30:
    ret i1 0
    br label %end_if30
end_if30:
    %iter = alloca i32
    %tmp5 = getelementptr inbounds i32, i32* %iter, i32 0
    %tmp6 = getelementptr inbounds %struct.string.String, %struct.string.String* %first, i32 0, i32 1
    %tmp7 = load i32, i32* %tmp6
    %tmp8 = sub i32 %tmp7, 1
    store i32 %tmp8, i32* %tmp5
    br label %loop_body31
loop_body31:
    %tmp9 = load i32, i32* %iter
    %tmp10 = icmp slt i32 %tmp9, 0
    br i1 %tmp10, label %then32, label %end_if32
then32:
    br label %loop_body31_exit
    br label %end_if32
end_if32:
    %tmp11 = getelementptr inbounds %struct.string.String, %struct.string.String* %first, i32 0, i32 0
    %tmp12 = load i8*, i8** %tmp11
    %tmp13 = load i32, i32* %iter
    %tmp14 = sext i32 %tmp13 to i64
    %tmp15 = getelementptr i8, i8* %tmp12, i64 %tmp14
    %tmp16 = load i8, i8* %tmp15
    %tmp17 = getelementptr inbounds %struct.string.String, %struct.string.String* %second, i32 0, i32 0
    %tmp18 = load i8*, i8** %tmp17
    %tmp19 = load i32, i32* %iter
    %tmp20 = sext i32 %tmp19 to i64
    %tmp21 = getelementptr i8, i8* %tmp18, i64 %tmp20
    %tmp22 = load i8, i8* %tmp21
    %tmp23 = icmp ne i8 %tmp16, %tmp22
    br i1 %tmp23, label %then33, label %end_if33
then33:
    ret i1 0
    br label %end_if33
end_if33:
    %tmp24 = getelementptr inbounds i32, i32* %iter, i32 0
    %tmp25 = load i32, i32* %iter
    %tmp26 = sub i32 %tmp25, 1
    store i32 %tmp26, i32* %tmp24
    br label %loop_body31
loop_body31_exit:
    ret i1 1

    unreachable
}

define void @string.free(%struct.string.String* %str){
    %tmp0 = getelementptr inbounds %struct.string.String, %struct.string.String* %str, i32 0, i32 0
    %tmp1 = load i8*, i8** %tmp0
    call void @mem.free(i8* %tmp1)
    %tmp2 = getelementptr inbounds %struct.string.String, %struct.string.String* %str, i32 0, i32 1
    store i32 0, i32* %tmp2
    ret void

    unreachable
}

define i8* @string_utils.insert(i8* %src1, i8* %src2, i32 %index){
    %len1 = alloca i32
    %tmp0 = getelementptr inbounds i32, i32* %len1, i32 0
    %tmp1 = call i32 @string_utils.c_str_len(i8* %src1)
    store i32 %tmp1, i32* %tmp0
    %len2 = alloca i32
    %tmp2 = getelementptr inbounds i32, i32* %len2, i32 0
    %tmp3 = call i32 @string_utils.c_str_len(i8* %src2)
    store i32 %tmp3, i32* %tmp2
    %output = alloca i8*
    %tmp4 = getelementptr inbounds i8*, i8** %output, i32 0
    %tmp5 = load i32, i32* %len1
    %tmp6 = load i32, i32* %len2
    %tmp7 = add i32 %tmp5, %tmp6
    %tmp8 = add i32 %tmp7, 1
    %tmp9 = sext i32 %tmp8 to i64
    %tmp10 = call i8* @mem.malloc(i64 %tmp9)
    store i8* %tmp10, i8** %tmp4
    %tmp11 = load i8*, i8** %output
    %tmp12 = sext i32 %index to i64
    call void @mem.copy(i8* %src1,i8* %tmp11,i64 %tmp12)
    %tmp13 = load i8*, i8** %output
    %tmp14 = getelementptr i8, i8* %tmp13, i32 %index
    %tmp15 = load i32, i32* %len2
    %tmp16 = sext i32 %tmp15 to i64
    call void @mem.copy(i8* %src2,i8* %tmp14,i64 %tmp16)
    %tmp17 = getelementptr i8, i8* %src1, i32 %index
    %tmp18 = load i8*, i8** %output
    %tmp19 = getelementptr i8, i8* %tmp18, i32 %index
    %tmp20 = load i32, i32* %len2
    %tmp21 = getelementptr i8, i8* %tmp19, i32 %tmp20
    %tmp22 = load i32, i32* %len1
    %tmp23 = sub i32 %tmp22, %index
    %tmp24 = sext i32 %tmp23 to i64
    call void @mem.copy(i8* %tmp17,i8* %tmp21,i64 %tmp24)
    %tmp25 = load i8*, i8** %output
    %tmp26 = load i32, i32* %len1
    %tmp27 = getelementptr i8, i8* %tmp25, i32 %tmp26
    %tmp28 = load i32, i32* %len2
    %tmp29 = getelementptr i8, i8* %tmp27, i32 %tmp28
    store i8 0, i8* %tmp29
    %tmp30 = load i8*, i8** %output
    ret i8* %tmp30

    unreachable
}

define i32 @string_utils.c_str_len(i8* %str){
    %len = alloca i32
    %tmp0 = getelementptr inbounds i32, i32* %len, i32 0
    store i32 0, i32* %tmp0
    br label %loop_body34
loop_body34:
    %tmp1 = load i32, i32* %len
    %tmp2 = getelementptr i8, i8* %str, i32 %tmp1
    %tmp3 = load i8, i8* %tmp2
    %tmp4 = icmp eq i8 %tmp3, 0
    br i1 %tmp4, label %then35, label %end_if35
then35:
    br label %loop_body34_exit
    br label %end_if35
end_if35:
    %tmp5 = getelementptr inbounds i32, i32* %len, i32 0
    %tmp6 = load i32, i32* %len
    %tmp7 = add i32 %tmp6, 1
    store i32 %tmp7, i32* %tmp5
    br label %loop_body34
loop_body34_exit:
    %tmp8 = load i32, i32* %len
    ret i32 %tmp8

    unreachable
}

define i1 @string_utils.is_ascii_num(i8 %char){
    %tmp0 = icmp sge i8 %char, 48
    %tmp1 = icmp sle i8 %char, 57
    %tmp2 = and i1 %tmp0, %tmp1
    ret i1 %tmp2

    unreachable
}

define i1 @string_utils.is_ascii_char(i8 %char){
    %tmp0 = icmp sge i8 %char, 65
    %tmp1 = icmp sle i8 %char, 90
    %tmp2 = and i1 %tmp0, %tmp1
    %tmp3 = icmp sge i8 %char, 97
    %tmp4 = icmp sle i8 %char, 122
    %tmp5 = and i1 %tmp3, %tmp4
    %tmp6 = or i1 %tmp2, %tmp5
    ret i1 %tmp6

    unreachable
}

define i1 @string_utils.is_ascii_hex(i8 %char){
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

    unreachable
}

define i32 @fs.write_to_file(i8* %path, i8* %content, i32 %content_len){
    %CREATE_ALWAYS = alloca i32
    %tmp0 = getelementptr inbounds i32, i32* %CREATE_ALWAYS, i32 0
    store i32 2, i32* %tmp0
    %GENERIC_WRITE = alloca i32
    %tmp1 = getelementptr inbounds i32, i32* %GENERIC_WRITE, i32 0
    store i32 1073741824, i32* %tmp1
    %FILE_ATTRIBUTE_NORMAL = alloca i32
    %tmp2 = getelementptr inbounds i32, i32* %FILE_ATTRIBUTE_NORMAL, i32 0
    store i32 128, i32* %tmp2
    %hFile = alloca i8*
    %tmp3 = getelementptr inbounds i8*, i8** %hFile, i32 0
    %tmp4 = load i32, i32* %GENERIC_WRITE
    %tmp5 = load i32, i32* %CREATE_ALWAYS
    %tmp6 = load i32, i32* %FILE_ATTRIBUTE_NORMAL
    %tmp7 = call i8* @CreateFileA(i8* %path,i32 %tmp4,i32 0,i8* null,i32 %tmp5,i32 %tmp6,i8* null)
    store i8* %tmp7, i8** %tmp3
    %INVALID_HANDLE_VALUE = alloca i8*
    %tmp8 = getelementptr inbounds i8*, i8** %INVALID_HANDLE_VALUE, i32 0
    %tmp9 = inttoptr i64 18446744073709551615 to i8*
    store i8* %tmp9, i8** %tmp8
    %tmp10 = load i8*, i8** %hFile
    %tmp11 = load i8*, i8** %INVALID_HANDLE_VALUE
    %tmp12 = icmp eq ptr %tmp10, %tmp11
    br i1 %tmp12, label %then36, label %end_if36
then36:
    ret i32 0
    br label %end_if36
end_if36:
    %bytes_written = alloca i32
    %tmp13 = getelementptr inbounds i32, i32* %bytes_written, i32 0
    store i32 0, i32* %tmp13
    %success = alloca i32
    %tmp14 = getelementptr inbounds i32, i32* %success, i32 0
    %tmp15 = load i8*, i8** %hFile
    %tmp16 = getelementptr inbounds i32, i32* %bytes_written, i32 0
    %tmp17 = call i32 @WriteFile(i8* %tmp15,i8* %content,i32 %content_len,i32* %tmp16,i8* null)
    store i32 %tmp17, i32* %tmp14
    %tmp18 = load i8*, i8** %hFile
    call i32 @CloseHandle(i8* %tmp18)
    %tmp19 = load i32, i32* %success
    %tmp20 = icmp eq i32 %tmp19, 0
    br i1 %tmp20, label %then37, label %end_if37
then37:
    ret i32 0
    br label %end_if37
end_if37:
    %tmp21 = load i32, i32* %bytes_written
    %tmp22 = icmp ne i32 %tmp21, %content_len
    br i1 %tmp22, label %then38, label %end_if38
then38:
    ret i32 0
    br label %end_if38
end_if38:
    ret i32 1

    unreachable
}

define %struct.string.String @fs.read_full_file_as_string(i8* %path){
    %GENERIC_READ = alloca i32
    %tmp0 = getelementptr inbounds i32, i32* %GENERIC_READ, i32 0
    store i32 2147483648, i32* %tmp0
    %FILE_ATTRIBUTE_NORMAL = alloca i32
    %tmp1 = getelementptr inbounds i32, i32* %FILE_ATTRIBUTE_NORMAL, i32 0
    store i32 128, i32* %tmp1
    %OPEN_EXISTING = alloca i32
    %tmp2 = getelementptr inbounds i32, i32* %OPEN_EXISTING, i32 0
    store i32 3, i32* %tmp2
    %hFile = alloca i8*
    %tmp3 = getelementptr inbounds i8*, i8** %hFile, i32 0
    %tmp4 = load i32, i32* %GENERIC_READ
    %tmp5 = load i32, i32* %OPEN_EXISTING
    %tmp6 = load i32, i32* %FILE_ATTRIBUTE_NORMAL
    %tmp7 = call i8* @CreateFileA(i8* %path,i32 %tmp4,i32 0,i8* null,i32 %tmp5,i32 %tmp6,i8* null)
    store i8* %tmp7, i8** %tmp3
    %INVALID_HANDLE_VALUE = alloca i8*
    %tmp8 = getelementptr inbounds i8*, i8** %INVALID_HANDLE_VALUE, i32 0
    %tmp9 = inttoptr i64 18446744073709551615 to i8*
    store i8* %tmp9, i8** %tmp8
    %tmp10 = load i8*, i8** %hFile
    %tmp11 = load i8*, i8** %INVALID_HANDLE_VALUE
    %tmp12 = icmp eq ptr %tmp10, %tmp11
    br i1 %tmp12, label %then39, label %end_if39
then39:
    %tmp13 = getelementptr inbounds [20 x i8], ptr @.str2, i64 0, i64 0
    %tmp14 = call i8* @string_utils.insert(i8* %tmp13,i8* %path,i32 5)
    call void @process.throw(i8* %tmp14)
    br label %end_if39
end_if39:
    %file_size = alloca i64
    %tmp15 = getelementptr inbounds i64, i64* %file_size, i32 0
    store i64 0, i64* %tmp15
    %tmp16 = load i8*, i8** %hFile
    %tmp17 = getelementptr inbounds i64, i64* %file_size, i32 0
    %tmp18 = call i32 @GetFileSizeEx(i8* %tmp16,i64* %tmp17)
    %tmp19 = icmp eq i32 %tmp18, 0
    br i1 %tmp19, label %then40, label %end_if40
then40:
    %tmp20 = load i8*, i8** %hFile
    call i32 @CloseHandle(i8* %tmp20)
    %tmp21 = call %struct.string.String @string.empty()
    ret %struct.string.String %tmp21
    br label %end_if40
end_if40:
    %buffer = alloca %struct.string.String
    %tmp22 = getelementptr inbounds %struct.string.String, %struct.string.String* %buffer, i32 0
    %tmp23 = load i64, i64* %file_size
    %tmp24 = trunc i64 %tmp23 to i32
    %tmp25 = add i32 %tmp24, 1
    %tmp26 = call %struct.string.String @string.with_size(i32 %tmp25)
    store %struct.string.String %tmp26, %struct.string.String* %tmp22
    %bytes_read = alloca i32
    %tmp27 = getelementptr inbounds i32, i32* %bytes_read, i32 0
    store i32 0, i32* %tmp27
    %success = alloca i32
    %tmp28 = getelementptr inbounds i32, i32* %success, i32 0
    %tmp29 = load i8*, i8** %hFile
    %tmp30 = getelementptr inbounds %struct.string.String, %struct.string.String* %buffer, i32 0
    %tmp31 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp30, i32 0, i32 0
    %tmp32 = load i8*, i8** %tmp31
    %tmp33 = load i64, i64* %file_size
    %tmp34 = trunc i64 %tmp33 to i32
    %tmp35 = getelementptr inbounds i32, i32* %bytes_read, i32 0
    %tmp36 = call i32 @ReadFile(i8* %tmp29,i8* %tmp32,i32 %tmp34,i32* %tmp35,i8* null)
    store i32 %tmp36, i32* %tmp28
    %tmp37 = load i8*, i8** %hFile
    call i32 @CloseHandle(i8* %tmp37)
    %tmp38 = load i32, i32* %success
    %tmp39 = icmp eq i32 %tmp38, 0
    %tmp40 = load i32, i32* %bytes_read
    %tmp41 = zext i32 %tmp40 to i64
    %tmp42 = load i64, i64* %file_size
    %tmp43 = icmp ne i64 %tmp41, %tmp42
    %tmp44 = or i1 %tmp39, %tmp43
    br i1 %tmp44, label %then41, label %end_if41
then41:
    %tmp45 = getelementptr inbounds %struct.string.String, %struct.string.String* %buffer, i32 0
    call void @string.free(%struct.string.String* %tmp45)
    %tmp46 = getelementptr inbounds [17 x i8], ptr @.str3, i64 0, i64 0
    call void @process.throw(i8* %tmp46)
    br label %end_if41
end_if41:
    %tmp47 = getelementptr inbounds %struct.string.String, %struct.string.String* %buffer, i32 0
    %tmp48 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp47, i32 0, i32 1
    %tmp49 = load i64, i64* %file_size
    %tmp50 = trunc i64 %tmp49 to i32
    store i32 %tmp50, i32* %tmp48
    %tmp51 = load %struct.string.String, %struct.string.String* %buffer
    ret %struct.string.String %tmp51

    unreachable
}

define i32 @fs.create_file(i8* %path){
    %CREATE_NEW = alloca i32
    %tmp0 = getelementptr inbounds i32, i32* %CREATE_NEW, i32 0
    store i32 1, i32* %tmp0
    %GENERIC_WRITE = alloca i32
    %tmp1 = getelementptr inbounds i32, i32* %GENERIC_WRITE, i32 0
    store i32 1073741824, i32* %tmp1
    %FILE_ATTRIBUTE_NORMAL = alloca i32
    %tmp2 = getelementptr inbounds i32, i32* %FILE_ATTRIBUTE_NORMAL, i32 0
    store i32 128, i32* %tmp2
    %hFile = alloca i8*
    %tmp3 = getelementptr inbounds i8*, i8** %hFile, i32 0
    %tmp4 = load i32, i32* %GENERIC_WRITE
    %tmp5 = load i32, i32* %CREATE_NEW
    %tmp6 = load i32, i32* %FILE_ATTRIBUTE_NORMAL
    %tmp7 = call i8* @CreateFileA(i8* %path,i32 %tmp4,i32 0,i8* null,i32 %tmp5,i32 %tmp6,i8* null)
    store i8* %tmp7, i8** %tmp3
    %INVALID_HANDLE_VALUE = alloca i8*
    %tmp8 = getelementptr inbounds i8*, i8** %INVALID_HANDLE_VALUE, i32 0
    %tmp9 = inttoptr i64 18446744073709551615 to i8*
    store i8* %tmp9, i8** %tmp8
    %tmp10 = load i8*, i8** %hFile
    %tmp11 = load i8*, i8** %INVALID_HANDLE_VALUE
    %tmp12 = icmp eq ptr %tmp10, %tmp11
    br i1 %tmp12, label %then42, label %end_if42
then42:
    ret i32 0
    br label %end_if42
end_if42:
    %tmp13 = load i8*, i8** %hFile
    call i32 @CloseHandle(i8* %tmp13)
    ret i32 1

    unreachable
}

define i32 @fs.delete_file(i8* %path){
    %tmp0 = call i32 @DeleteFileA(i8* %path)
    ret i32 %tmp0

    unreachable
}

define void @tests.run(){
    call void @tests.fs_test()
    call void @tests.funny()
    ret void

    unreachable
}

define void @tests.fs_test(){
    %tmp0 = getelementptr inbounds [10 x i8], ptr @.str4, i64 0, i64 0
    call void @console.write(i8* %tmp0,i32 9)
    %data = alloca %struct.string.String
    %tmp1 = getelementptr inbounds %struct.string.String, %struct.string.String* %data, i32 0
    %tmp2 = getelementptr inbounds [47 x i8], ptr @.str5, i64 0, i64 0
    %tmp3 = call %struct.string.String @string.from_c_string(i8* %tmp2)
    store %struct.string.String %tmp3, %struct.string.String* %tmp1
    %env_path = alloca %struct.string.String
    %tmp4 = getelementptr inbounds %struct.string.String, %struct.string.String* %env_path, i32 0
    %tmp5 = call %struct.string.String @process.get_executable_env_path()
    store %struct.string.String %tmp5, %struct.string.String* %tmp4
    %new_file_path = alloca %struct.string.String
    %tmp6 = getelementptr inbounds %struct.string.String, %struct.string.String* %new_file_path, i32 0
    %tmp7 = getelementptr inbounds %struct.string.String, %struct.string.String* %env_path, i32 0
    %tmp8 = getelementptr inbounds [9 x i8], ptr @.str6, i64 0, i64 0
    %tmp9 = call %struct.string.String @string.concat_with_c_string(%struct.string.String* %tmp7,i8* %tmp8)
    store %struct.string.String %tmp9, %struct.string.String* %tmp6
    %c_string = alloca i8*
    %tmp10 = getelementptr inbounds i8*, i8** %c_string, i32 0
    %tmp11 = getelementptr inbounds %struct.string.String, %struct.string.String* %new_file_path, i32 0
    %tmp12 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp11, i32 0, i32 1
    %tmp13 = load i32, i32* %tmp12
    %tmp14 = add i32 %tmp13, 1
    %tmp15 = sext i32 %tmp14 to i64
    %tmp16 = mul i64 %tmp15, 1
    %tmp17 = alloca i8, i64 %tmp16
    store i8* %tmp17, i8** %tmp10
    %tmp18 = getelementptr inbounds %struct.string.String, %struct.string.String* %new_file_path, i32 0
    %tmp19 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp18, i32 0, i32 0
    %tmp20 = load i8*, i8** %tmp19
    %tmp21 = load i8*, i8** %c_string
    %tmp22 = getelementptr inbounds %struct.string.String, %struct.string.String* %new_file_path, i32 0
    %tmp23 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp22, i32 0, i32 1
    %tmp24 = load i32, i32* %tmp23
    %tmp25 = sext i32 %tmp24 to i64
    call void @mem.copy(i8* %tmp20,i8* %tmp21,i64 %tmp25)
    %tmp26 = load i8*, i8** %c_string
    %tmp27 = getelementptr inbounds %struct.string.String, %struct.string.String* %new_file_path, i32 0
    %tmp28 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp27, i32 0, i32 1
    %tmp29 = load i32, i32* %tmp28
    %tmp30 = sext i32 %tmp29 to i64
    %tmp31 = getelementptr i8, i8* %tmp26, i64 %tmp30
    store i8 0, i8* %tmp31
    %tmp32 = load i8*, i8** %c_string
    call i32 @fs.create_file(i8* %tmp32)
    %tmp33 = load i8*, i8** %c_string
    call i32 @fs.delete_file(i8* %tmp33)
    %tmp34 = load i8*, i8** %c_string
    call i32 @fs.create_file(i8* %tmp34)
    %tmp35 = load i8*, i8** %c_string
    %tmp36 = getelementptr inbounds %struct.string.String, %struct.string.String* %data, i32 0
    %tmp37 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp36, i32 0, i32 0
    %tmp38 = load i8*, i8** %tmp37
    %tmp39 = getelementptr inbounds %struct.string.String, %struct.string.String* %data, i32 0
    %tmp40 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp39, i32 0, i32 1
    %tmp41 = load i32, i32* %tmp40
    call i32 @fs.write_to_file(i8* %tmp35,i8* %tmp38,i32 %tmp41)
    %read = alloca %struct.string.String
    %tmp42 = getelementptr inbounds %struct.string.String, %struct.string.String* %read, i32 0
    %tmp43 = load i8*, i8** %c_string
    %tmp44 = call %struct.string.String @fs.read_full_file_as_string(i8* %tmp43)
    store %struct.string.String %tmp44, %struct.string.String* %tmp42
    %tmp45 = getelementptr inbounds %struct.string.String, %struct.string.String* %data, i32 0
    %tmp46 = getelementptr inbounds %struct.string.String, %struct.string.String* %read, i32 0
    %tmp47 = call i1 @string.equal(%struct.string.String* %tmp45,%struct.string.String* %tmp46)
    %tmp48 = xor i1 %tmp47, 1
    br i1 %tmp48, label %then43, label %end_if43
then43:
    %tmp49 = getelementptr inbounds [38 x i8], ptr @.str7, i64 0, i64 0
    call void @process.throw(i8* %tmp49)
    br label %end_if43
end_if43:
    %tmp50 = load i8*, i8** %c_string
    call i32 @fs.delete_file(i8* %tmp50)
    %tmp51 = getelementptr inbounds %struct.string.String, %struct.string.String* %read, i32 0
    call void @string.free(%struct.string.String* %tmp51)
    %tmp52 = getelementptr inbounds %struct.string.String, %struct.string.String* %new_file_path, i32 0
    call void @string.free(%struct.string.String* %tmp52)
    %tmp53 = getelementptr inbounds %struct.string.String, %struct.string.String* %env_path, i32 0
    call void @string.free(%struct.string.String* %tmp53)
    %tmp54 = getelementptr inbounds %struct.string.String, %struct.string.String* %data, i32 0
    call void @string.free(%struct.string.String* %tmp54)
    %tmp55 = getelementptr inbounds [3 x i8], ptr @.str8, i64 0, i64 0
    call void @console.writeln(i8* %tmp55,i32 2)
    ret void

    unreachable
}

define void @tests.consume_while(%struct.string.String* %file, i32* %iterator, i1 (i8)* %condition){
    br label %loop_body44
loop_body44:
    %tmp0 = load i32, i32* %iterator
    %tmp1 = getelementptr inbounds %struct.string.String, %struct.string.String* %file, i32 0, i32 1
    %tmp2 = load i32, i32* %tmp1
    %tmp3 = icmp sge i32 %tmp0, %tmp2
    br i1 %tmp3, label %then45, label %end_if45
then45:
    br label %loop_body44_exit
    br label %end_if45
end_if45:
    %char = alloca i8
    %tmp4 = getelementptr inbounds i8, i8* %char, i32 0
    %tmp5 = getelementptr inbounds %struct.string.String, %struct.string.String* %file, i32 0, i32 0
    %tmp6 = load i8*, i8** %tmp5
    %tmp7 = load i32, i32* %iterator
    %tmp8 = getelementptr i8, i8* %tmp6, i32 %tmp7
    %tmp9 = load i8, i8* %tmp8
    store i8 %tmp9, i8* %tmp4
    %tmp10 = load i8, i8* %char
    %tmp11 = call i1 %condition(i8 %tmp10)
    br i1 %tmp11, label %then46, label %else46
then46:
    %tmp12 = load i32, i32* %iterator
    %tmp13 = add i32 %tmp12, 1
    store i32 %tmp13, i32* %iterator
    br label %end_if46
else46:
    br label %loop_body44_exit
    br label %end_if46
end_if46:
    br label %loop_body44
loop_body44_exit:
    ret void

    unreachable
}

define i1 @tests.not_new_line(i8 %c){
    %tmp0 = icmp ne i8 %c, 10
    ret i1 %tmp0

    unreachable
}

define i1 @tests.valid_name_token(i8 %c){
    %tmp0 = call i1 @string_utils.is_ascii_char(i8 %c)
    %tmp1 = call i1 @string_utils.is_ascii_num(i8 %c)
    %tmp2 = or i1 %tmp0, %tmp1
    %tmp3 = icmp eq i8 %c, 95
    %tmp4 = or i1 %tmp2, %tmp3
    ret i1 %tmp4

    unreachable
}

define i1 @tests.is_valid_number_token(i8 %c){
    %tmp0 = call i1 @string_utils.is_ascii_num(i8 %c)
    %tmp1 = call i1 @string_utils.is_ascii_hex(i8 %c)
    %tmp2 = or i1 %tmp0, %tmp1
    %tmp3 = icmp eq i8 %c, 95
    %tmp4 = or i1 %tmp2, %tmp3
    ret i1 %tmp4

    unreachable
}

define void @tests.funny(){
    %path = alloca i8*
    %tmp0 = getelementptr inbounds i8*, i8** %path, i32 0
    %tmp1 = getelementptr inbounds [32 x i8], ptr @.str9, i64 0, i64 0
    store i8* %tmp1, i8** %tmp0
    %file = alloca %struct.string.String
    %tmp2 = getelementptr inbounds %struct.string.String, %struct.string.String* %file, i32 0
    %tmp3 = load i8*, i8** %path
    %tmp4 = call %struct.string.String @fs.read_full_file_as_string(i8* %tmp3)
    store %struct.string.String %tmp4, %struct.string.String* %tmp2
    %tokens = alloca %struct.vector.Vec
    %tmp5 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %tokens, i32 0
    call void @vector.new(%struct.vector.Vec* %tmp5)
    %iterator = alloca i32
    %tmp6 = getelementptr inbounds i32, i32* %iterator, i32 0
    store i32 0, i32* %tmp6
    %char = alloca i8
    %next_char = alloca i8
    %index = alloca i32
    %temp_string = alloca %struct.string.String
    br label %loop_body47
loop_body47:
    %tmp7 = load i32, i32* %iterator
    %tmp8 = getelementptr inbounds %struct.string.String, %struct.string.String* %file, i32 0
    %tmp9 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp8, i32 0, i32 1
    %tmp10 = load i32, i32* %tmp9
    %tmp11 = icmp sge i32 %tmp7, %tmp10
    br i1 %tmp11, label %then48, label %end_if48
then48:
    br label %loop_body47_exit
    br label %end_if48
end_if48:
    %tmp12 = getelementptr inbounds i8, i8* %char, i32 0
    %tmp13 = getelementptr inbounds %struct.string.String, %struct.string.String* %file, i32 0
    %tmp14 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp13, i32 0, i32 0
    %tmp15 = load i8*, i8** %tmp14
    %tmp16 = load i32, i32* %iterator
    %tmp17 = getelementptr i8, i8* %tmp15, i32 %tmp16
    %tmp18 = load i8, i8* %tmp17
    store i8 %tmp18, i8* %tmp12
    %tmp19 = load i8, i8* %char
    %tmp20 = icmp eq i8 %tmp19, 32
    %tmp21 = load i8, i8* %char
    %tmp22 = icmp eq i8 %tmp21, 9
    %tmp23 = or i1 %tmp20, %tmp22
    %tmp24 = load i8, i8* %char
    %tmp25 = icmp eq i8 %tmp24, 10
    %tmp26 = or i1 %tmp23, %tmp25
    %tmp27 = load i8, i8* %char
    %tmp28 = icmp eq i8 %tmp27, 13
    %tmp29 = or i1 %tmp26, %tmp28
    %tmp30 = and i1 %tmp29, 1
    br i1 %tmp30, label %then49, label %end_if49
then49:
    %tmp31 = getelementptr inbounds i32, i32* %iterator, i32 0
    %tmp32 = load i32, i32* %iterator
    %tmp33 = add i32 %tmp32, 1
    store i32 %tmp33, i32* %tmp31
    br label %loop_body47
    br label %end_if49
end_if49:
    %tmp34 = load i32, i32* %iterator
    %tmp35 = add i32 %tmp34, 1
    %tmp36 = getelementptr inbounds %struct.string.String, %struct.string.String* %file, i32 0
    %tmp37 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp36, i32 0, i32 1
    %tmp38 = load i32, i32* %tmp37
    %tmp39 = icmp slt i32 %tmp35, %tmp38
    br i1 %tmp39, label %then50, label %else50
then50:
    %tmp40 = getelementptr inbounds i8, i8* %next_char, i32 0
    %tmp41 = getelementptr inbounds %struct.string.String, %struct.string.String* %file, i32 0
    %tmp42 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp41, i32 0, i32 0
    %tmp43 = load i8*, i8** %tmp42
    %tmp44 = load i32, i32* %iterator
    %tmp45 = add i32 %tmp44, 1
    %tmp46 = getelementptr i8, i8* %tmp43, i32 %tmp45
    %tmp47 = load i8, i8* %tmp46
    store i8 %tmp47, i8* %tmp40
    br label %end_if50
else50:
    %tmp48 = getelementptr inbounds i8, i8* %next_char, i32 0
    store i8 0, i8* %tmp48
    br label %end_if50
end_if50:
    %tmp49 = load i8, i8* %char
    %tmp50 = icmp eq i8 %tmp49, 47
    %tmp51 = load i8, i8* %next_char
    %tmp52 = icmp eq i8 %tmp51, 47
    %tmp53 = and i1 %tmp50, %tmp52
    br i1 %tmp53, label %then51, label %end_if51
then51:
    %tmp54 = getelementptr inbounds i32, i32* %index, i32 0
    %tmp55 = load i32, i32* %iterator
    store i32 %tmp55, i32* %tmp54
    %tmp56 = getelementptr inbounds %struct.string.String, %struct.string.String* %file, i32 0
    %tmp57 = getelementptr inbounds i32, i32* %iterator, i32 0
    call void @tests.consume_while(%struct.string.String* %tmp56,i32* %tmp57,i1 (i8)* @tests.not_new_line)
    br label %loop_body47
    br label %end_if51
end_if51:
    %tmp58 = load i8, i8* %char
    %tmp59 = call i1 @string_utils.is_ascii_num(i8 %tmp58)
    br i1 %tmp59, label %then52, label %end_if52
then52:
    %tmp60 = getelementptr inbounds i32, i32* %index, i32 0
    %tmp61 = load i32, i32* %iterator
    store i32 %tmp61, i32* %tmp60
    %tmp62 = load i8, i8* %next_char
    %tmp63 = icmp eq i8 %tmp62, 120
    %tmp64 = load i8, i8* %next_char
    %tmp65 = icmp eq i8 %tmp64, 98
    %tmp66 = or i1 %tmp63, %tmp65
    br i1 %tmp66, label %then53, label %end_if53
then53:
    %tmp67 = getelementptr inbounds i32, i32* %iterator, i32 0
    %tmp68 = load i32, i32* %iterator
    %tmp69 = add i32 %tmp68, 2
    store i32 %tmp69, i32* %tmp67
    br label %end_if53
end_if53:
    %tmp70 = getelementptr inbounds %struct.string.String, %struct.string.String* %file, i32 0
    %tmp71 = getelementptr inbounds i32, i32* %iterator, i32 0
    call void @tests.consume_while(%struct.string.String* %tmp70,i32* %tmp71,i1 (i8)* @tests.is_valid_number_token)
    %tmp72 = getelementptr inbounds %struct.string.String, %struct.string.String* %temp_string, i32 0
    %tmp73 = load i32, i32* %iterator
    %tmp74 = load i32, i32* %index
    %tmp75 = sub i32 %tmp73, %tmp74
    %tmp76 = call %struct.string.String @string.with_size(i32 %tmp75)
    store %struct.string.String %tmp76, %struct.string.String* %tmp72
    %tmp77 = getelementptr inbounds %struct.string.String, %struct.string.String* %file, i32 0
    %tmp78 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp77, i32 0, i32 0
    %tmp79 = load i8*, i8** %tmp78
    %tmp80 = load i32, i32* %index
    %tmp81 = getelementptr i8, i8* %tmp79, i32 %tmp80
    %tmp82 = getelementptr inbounds %struct.string.String, %struct.string.String* %temp_string, i32 0
    %tmp83 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp82, i32 0, i32 0
    %tmp84 = load i8*, i8** %tmp83
    %tmp85 = getelementptr inbounds %struct.string.String, %struct.string.String* %temp_string, i32 0
    %tmp86 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp85, i32 0, i32 1
    %tmp87 = load i32, i32* %tmp86
    %tmp88 = sext i32 %tmp87 to i64
    call void @mem.copy(i8* %tmp81,i8* %tmp84,i64 %tmp88)
    %tmp89 = getelementptr inbounds %struct.string.String, %struct.string.String* %temp_string, i32 0
    call void @string.free(%struct.string.String* %tmp89)
    br label %loop_body47
    br label %end_if52
end_if52:
    %tmp90 = load i8, i8* %char
    %tmp91 = call i1 @string_utils.is_ascii_char(i8 %tmp90)
    %tmp92 = load i8, i8* %char
    %tmp93 = icmp eq i8 %tmp92, 95
    %tmp94 = or i1 %tmp91, %tmp93
    br i1 %tmp94, label %then54, label %end_if54
then54:
    %tmp95 = getelementptr inbounds i32, i32* %index, i32 0
    %tmp96 = load i32, i32* %iterator
    store i32 %tmp96, i32* %tmp95
    %tmp97 = getelementptr inbounds %struct.string.String, %struct.string.String* %file, i32 0
    %tmp98 = getelementptr inbounds i32, i32* %iterator, i32 0
    call void @tests.consume_while(%struct.string.String* %tmp97,i32* %tmp98,i1 (i8)* @tests.valid_name_token)
    %tmp99 = getelementptr inbounds %struct.string.String, %struct.string.String* %temp_string, i32 0
    %tmp100 = load i32, i32* %iterator
    %tmp101 = load i32, i32* %index
    %tmp102 = sub i32 %tmp100, %tmp101
    %tmp103 = call %struct.string.String @string.with_size(i32 %tmp102)
    store %struct.string.String %tmp103, %struct.string.String* %tmp99
    %tmp104 = getelementptr inbounds %struct.string.String, %struct.string.String* %file, i32 0
    %tmp105 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp104, i32 0, i32 0
    %tmp106 = load i8*, i8** %tmp105
    %tmp107 = load i32, i32* %index
    %tmp108 = getelementptr i8, i8* %tmp106, i32 %tmp107
    %tmp109 = getelementptr inbounds %struct.string.String, %struct.string.String* %temp_string, i32 0
    %tmp110 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp109, i32 0, i32 0
    %tmp111 = load i8*, i8** %tmp110
    %tmp112 = getelementptr inbounds %struct.string.String, %struct.string.String* %temp_string, i32 0
    %tmp113 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp112, i32 0, i32 1
    %tmp114 = load i32, i32* %tmp113
    %tmp115 = sext i32 %tmp114 to i64
    call void @mem.copy(i8* %tmp108,i8* %tmp111,i64 %tmp115)
    %tmp116 = getelementptr inbounds %struct.string.String, %struct.string.String* %temp_string, i32 0
    call void @string.free(%struct.string.String* %tmp116)
    br label %loop_body47
    br label %end_if54
end_if54:
    %tmp117 = load i8, i8* %char
    %tmp118 = icmp eq i8 %tmp117, 34
    br i1 %tmp118, label %then55, label %end_if55
then55:
    %tmp119 = getelementptr inbounds i32, i32* %index, i32 0
    %tmp120 = load i32, i32* %iterator
    store i32 %tmp120, i32* %tmp119
    br label %loop_body56
loop_body56:
    %tmp121 = getelementptr inbounds i32, i32* %iterator, i32 0
    %tmp122 = load i32, i32* %iterator
    %tmp123 = add i32 %tmp122, 1
    store i32 %tmp123, i32* %tmp121
    %tmp124 = load i32, i32* %iterator
    %tmp125 = getelementptr inbounds %struct.string.String, %struct.string.String* %file, i32 0
    %tmp126 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp125, i32 0, i32 1
    %tmp127 = load i32, i32* %tmp126
    %tmp128 = icmp sge i32 %tmp124, %tmp127
    br i1 %tmp128, label %then57, label %end_if57
then57:
    br label %loop_body56_exit
    br label %end_if57
end_if57:
    %tmp129 = getelementptr inbounds i8, i8* %char, i32 0
    %tmp130 = getelementptr inbounds %struct.string.String, %struct.string.String* %file, i32 0
    %tmp131 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp130, i32 0, i32 0
    %tmp132 = load i8*, i8** %tmp131
    %tmp133 = load i32, i32* %iterator
    %tmp134 = getelementptr i8, i8* %tmp132, i32 %tmp133
    %tmp135 = load i8, i8* %tmp134
    store i8 %tmp135, i8* %tmp129
    %tmp136 = load i8, i8* %char
    %tmp137 = icmp ne i8 %tmp136, 34
    br i1 %tmp137, label %then58, label %end_if58
then58:
    br label %loop_body56
    br label %end_if58
end_if58:
    %tmp138 = getelementptr inbounds i32, i32* %iterator, i32 0
    %tmp139 = load i32, i32* %iterator
    %tmp140 = add i32 %tmp139, 1
    store i32 %tmp140, i32* %tmp138
    br label %loop_body56_exit
    br label %loop_body56
loop_body56_exit:
    %tmp141 = getelementptr inbounds %struct.string.String, %struct.string.String* %temp_string, i32 0
    %tmp142 = load i32, i32* %iterator
    %tmp143 = load i32, i32* %index
    %tmp144 = sub i32 %tmp142, %tmp143
    %tmp145 = call %struct.string.String @string.with_size(i32 %tmp144)
    store %struct.string.String %tmp145, %struct.string.String* %tmp141
    %tmp146 = getelementptr inbounds %struct.string.String, %struct.string.String* %file, i32 0
    %tmp147 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp146, i32 0, i32 0
    %tmp148 = load i8*, i8** %tmp147
    %tmp149 = load i32, i32* %index
    %tmp150 = getelementptr i8, i8* %tmp148, i32 %tmp149
    %tmp151 = getelementptr inbounds %struct.string.String, %struct.string.String* %temp_string, i32 0
    %tmp152 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp151, i32 0, i32 0
    %tmp153 = load i8*, i8** %tmp152
    %tmp154 = getelementptr inbounds %struct.string.String, %struct.string.String* %temp_string, i32 0
    %tmp155 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp154, i32 0, i32 1
    %tmp156 = load i32, i32* %tmp155
    %tmp157 = sext i32 %tmp156 to i64
    call void @mem.copy(i8* %tmp150,i8* %tmp153,i64 %tmp157)
    %tmp158 = getelementptr inbounds %struct.string.String, %struct.string.String* %temp_string, i32 0
    call void @string.free(%struct.string.String* %tmp158)
    br label %loop_body47
    br label %end_if55
end_if55:
    %tmp159 = load i8, i8* %char
    %tmp160 = icmp eq i8 %tmp159, 40
    br i1 %tmp160, label %then59, label %end_if59
then59:
    %tmp161 = getelementptr inbounds i32, i32* %iterator, i32 0
    %tmp162 = load i32, i32* %iterator
    %tmp163 = add i32 %tmp162, 1
    store i32 %tmp163, i32* %tmp161
    br label %loop_body47
    br label %end_if59
end_if59:
    %tmp164 = load i8, i8* %char
    %tmp165 = icmp eq i8 %tmp164, 41
    br i1 %tmp165, label %then60, label %end_if60
then60:
    %tmp166 = getelementptr inbounds i32, i32* %iterator, i32 0
    %tmp167 = load i32, i32* %iterator
    %tmp168 = add i32 %tmp167, 1
    store i32 %tmp168, i32* %tmp166
    br label %loop_body47
    br label %end_if60
end_if60:
    %tmp169 = load i8, i8* %char
    %tmp170 = icmp eq i8 %tmp169, 123
    br i1 %tmp170, label %then61, label %end_if61
then61:
    %tmp171 = getelementptr inbounds i32, i32* %iterator, i32 0
    %tmp172 = load i32, i32* %iterator
    %tmp173 = add i32 %tmp172, 1
    store i32 %tmp173, i32* %tmp171
    br label %loop_body47
    br label %end_if61
end_if61:
    %tmp174 = load i8, i8* %char
    %tmp175 = icmp eq i8 %tmp174, 125
    br i1 %tmp175, label %then62, label %end_if62
then62:
    %tmp176 = getelementptr inbounds i32, i32* %iterator, i32 0
    %tmp177 = load i32, i32* %iterator
    %tmp178 = add i32 %tmp177, 1
    store i32 %tmp178, i32* %tmp176
    br label %loop_body47
    br label %end_if62
end_if62:
    %tmp179 = load i8, i8* %char
    %tmp180 = icmp eq i8 %tmp179, 91
    br i1 %tmp180, label %then63, label %end_if63
then63:
    %tmp181 = getelementptr inbounds i32, i32* %iterator, i32 0
    %tmp182 = load i32, i32* %iterator
    %tmp183 = add i32 %tmp182, 1
    store i32 %tmp183, i32* %tmp181
    br label %loop_body47
    br label %end_if63
end_if63:
    %tmp184 = load i8, i8* %char
    %tmp185 = icmp eq i8 %tmp184, 93
    br i1 %tmp185, label %then64, label %end_if64
then64:
    %tmp186 = getelementptr inbounds i32, i32* %iterator, i32 0
    %tmp187 = load i32, i32* %iterator
    %tmp188 = add i32 %tmp187, 1
    store i32 %tmp188, i32* %tmp186
    br label %loop_body47
    br label %end_if64
end_if64:
    %tmp189 = load i8, i8* %char
    %tmp190 = icmp eq i8 %tmp189, 61
    br i1 %tmp190, label %then65, label %end_if65
then65:
    %tmp191 = load i8, i8* %next_char
    %tmp192 = icmp eq i8 %tmp191, 61
    br i1 %tmp192, label %then66, label %end_if66
then66:
    %tmp193 = getelementptr inbounds i32, i32* %iterator, i32 0
    %tmp194 = load i32, i32* %iterator
    %tmp195 = add i32 %tmp194, 2
    store i32 %tmp195, i32* %tmp193
    br label %loop_body47
    br label %end_if66
end_if66:
    %tmp196 = getelementptr inbounds i32, i32* %iterator, i32 0
    %tmp197 = load i32, i32* %iterator
    %tmp198 = add i32 %tmp197, 1
    store i32 %tmp198, i32* %tmp196
    br label %loop_body47
    br label %end_if65
end_if65:
    %tmp199 = load i8, i8* %char
    %tmp200 = icmp eq i8 %tmp199, 58
    br i1 %tmp200, label %then67, label %end_if67
then67:
    %tmp201 = load i8, i8* %next_char
    %tmp202 = icmp eq i8 %tmp201, 58
    br i1 %tmp202, label %then68, label %end_if68
then68:
    %tmp203 = getelementptr inbounds i32, i32* %iterator, i32 0
    %tmp204 = load i32, i32* %iterator
    %tmp205 = add i32 %tmp204, 2
    store i32 %tmp205, i32* %tmp203
    br label %loop_body47
    br label %end_if68
end_if68:
    %tmp206 = getelementptr inbounds i32, i32* %iterator, i32 0
    %tmp207 = load i32, i32* %iterator
    %tmp208 = add i32 %tmp207, 1
    store i32 %tmp208, i32* %tmp206
    br label %loop_body47
    br label %end_if67
end_if67:
    %tmp209 = load i8, i8* %char
    %tmp210 = icmp eq i8 %tmp209, 124
    br i1 %tmp210, label %then69, label %end_if69
then69:
    %tmp211 = load i8, i8* %next_char
    %tmp212 = icmp eq i8 %tmp211, 124
    br i1 %tmp212, label %then70, label %end_if70
then70:
    %tmp213 = getelementptr inbounds i32, i32* %iterator, i32 0
    %tmp214 = load i32, i32* %iterator
    %tmp215 = add i32 %tmp214, 2
    store i32 %tmp215, i32* %tmp213
    br label %loop_body47
    br label %end_if70
end_if70:
    %tmp216 = getelementptr inbounds i32, i32* %iterator, i32 0
    %tmp217 = load i32, i32* %iterator
    %tmp218 = add i32 %tmp217, 1
    store i32 %tmp218, i32* %tmp216
    br label %loop_body47
    br label %end_if69
end_if69:
    %tmp219 = load i8, i8* %char
    %tmp220 = icmp eq i8 %tmp219, 38
    br i1 %tmp220, label %then71, label %end_if71
then71:
    %tmp221 = load i8, i8* %next_char
    %tmp222 = icmp eq i8 %tmp221, 38
    br i1 %tmp222, label %then72, label %end_if72
then72:
    %tmp223 = getelementptr inbounds i32, i32* %iterator, i32 0
    %tmp224 = load i32, i32* %iterator
    %tmp225 = add i32 %tmp224, 2
    store i32 %tmp225, i32* %tmp223
    br label %loop_body47
    br label %end_if72
end_if72:
    %tmp226 = getelementptr inbounds i32, i32* %iterator, i32 0
    %tmp227 = load i32, i32* %iterator
    %tmp228 = add i32 %tmp227, 1
    store i32 %tmp228, i32* %tmp226
    br label %loop_body47
    br label %end_if71
end_if71:
    %tmp229 = load i8, i8* %char
    %tmp230 = icmp eq i8 %tmp229, 62
    br i1 %tmp230, label %then73, label %end_if73
then73:
    %tmp231 = load i8, i8* %next_char
    %tmp232 = icmp eq i8 %tmp231, 61
    br i1 %tmp232, label %then74, label %end_if74
then74:
    %tmp233 = getelementptr inbounds i32, i32* %iterator, i32 0
    %tmp234 = load i32, i32* %iterator
    %tmp235 = add i32 %tmp234, 2
    store i32 %tmp235, i32* %tmp233
    br label %loop_body47
    br label %end_if74
end_if74:
    %tmp236 = getelementptr inbounds i32, i32* %iterator, i32 0
    %tmp237 = load i32, i32* %iterator
    %tmp238 = add i32 %tmp237, 1
    store i32 %tmp238, i32* %tmp236
    br label %loop_body47
    br label %end_if73
end_if73:
    %tmp239 = load i8, i8* %char
    %tmp240 = icmp eq i8 %tmp239, 60
    br i1 %tmp240, label %then75, label %end_if75
then75:
    %tmp241 = load i8, i8* %next_char
    %tmp242 = icmp eq i8 %tmp241, 61
    br i1 %tmp242, label %then76, label %end_if76
then76:
    %tmp243 = getelementptr inbounds i32, i32* %iterator, i32 0
    %tmp244 = load i32, i32* %iterator
    %tmp245 = add i32 %tmp244, 2
    store i32 %tmp245, i32* %tmp243
    br label %loop_body47
    br label %end_if76
end_if76:
    %tmp246 = getelementptr inbounds i32, i32* %iterator, i32 0
    %tmp247 = load i32, i32* %iterator
    %tmp248 = add i32 %tmp247, 1
    store i32 %tmp248, i32* %tmp246
    br label %loop_body47
    br label %end_if75
end_if75:
    %tmp249 = load i8, i8* %char
    %tmp250 = icmp eq i8 %tmp249, 35
    br i1 %tmp250, label %then77, label %end_if77
then77:
    %tmp251 = getelementptr inbounds i32, i32* %iterator, i32 0
    %tmp252 = load i32, i32* %iterator
    %tmp253 = add i32 %tmp252, 1
    store i32 %tmp253, i32* %tmp251
    br label %loop_body47
    br label %end_if77
end_if77:
    %tmp254 = load i8, i8* %char
    %tmp255 = icmp eq i8 %tmp254, 59
    br i1 %tmp255, label %then78, label %end_if78
then78:
    %tmp256 = getelementptr inbounds i32, i32* %iterator, i32 0
    %tmp257 = load i32, i32* %iterator
    %tmp258 = add i32 %tmp257, 1
    store i32 %tmp258, i32* %tmp256
    br label %loop_body47
    br label %end_if78
end_if78:
    %tmp259 = load i8, i8* %char
    %tmp260 = icmp eq i8 %tmp259, 46
    br i1 %tmp260, label %then79, label %end_if79
then79:
    %tmp261 = getelementptr inbounds i32, i32* %iterator, i32 0
    %tmp262 = load i32, i32* %iterator
    %tmp263 = add i32 %tmp262, 1
    store i32 %tmp263, i32* %tmp261
    br label %loop_body47
    br label %end_if79
end_if79:
    %tmp264 = load i8, i8* %char
    %tmp265 = icmp eq i8 %tmp264, 44
    br i1 %tmp265, label %then80, label %end_if80
then80:
    %tmp266 = getelementptr inbounds i32, i32* %iterator, i32 0
    %tmp267 = load i32, i32* %iterator
    %tmp268 = add i32 %tmp267, 1
    store i32 %tmp268, i32* %tmp266
    br label %loop_body47
    br label %end_if80
end_if80:
    %tmp269 = load i8, i8* %char
    %tmp270 = icmp eq i8 %tmp269, 43
    br i1 %tmp270, label %then81, label %end_if81
then81:
    %tmp271 = getelementptr inbounds i32, i32* %iterator, i32 0
    %tmp272 = load i32, i32* %iterator
    %tmp273 = add i32 %tmp272, 1
    store i32 %tmp273, i32* %tmp271
    br label %loop_body47
    br label %end_if81
end_if81:
    %tmp274 = load i8, i8* %char
    %tmp275 = icmp eq i8 %tmp274, 45
    br i1 %tmp275, label %then82, label %end_if82
then82:
    %tmp276 = getelementptr inbounds i32, i32* %iterator, i32 0
    %tmp277 = load i32, i32* %iterator
    %tmp278 = add i32 %tmp277, 1
    store i32 %tmp278, i32* %tmp276
    br label %loop_body47
    br label %end_if82
end_if82:
    %tmp279 = load i8, i8* %char
    %tmp280 = icmp eq i8 %tmp279, 42
    br i1 %tmp280, label %then83, label %end_if83
then83:
    %tmp281 = getelementptr inbounds i32, i32* %iterator, i32 0
    %tmp282 = load i32, i32* %iterator
    %tmp283 = add i32 %tmp282, 1
    store i32 %tmp283, i32* %tmp281
    br label %loop_body47
    br label %end_if83
end_if83:
    %tmp284 = load i8, i8* %char
    %tmp285 = icmp eq i8 %tmp284, 47
    br i1 %tmp285, label %then84, label %end_if84
then84:
    %tmp286 = getelementptr inbounds i32, i32* %iterator, i32 0
    %tmp287 = load i32, i32* %iterator
    %tmp288 = add i32 %tmp287, 1
    store i32 %tmp288, i32* %tmp286
    br label %loop_body47
    br label %end_if84
end_if84:
    %tmp289 = load i8, i8* %char
    %tmp290 = icmp eq i8 %tmp289, 37
    br i1 %tmp290, label %then85, label %end_if85
then85:
    %tmp291 = getelementptr inbounds i32, i32* %iterator, i32 0
    %tmp292 = load i32, i32* %iterator
    %tmp293 = add i32 %tmp292, 1
    store i32 %tmp293, i32* %tmp291
    br label %loop_body47
    br label %end_if85
end_if85:
    %tmp294 = load i8, i8* %char
    %tmp295 = icmp eq i8 %tmp294, 33
    br i1 %tmp295, label %then86, label %end_if86
then86:
    %tmp296 = getelementptr inbounds i32, i32* %iterator, i32 0
    %tmp297 = load i32, i32* %iterator
    %tmp298 = add i32 %tmp297, 1
    store i32 %tmp298, i32* %tmp296
    br label %loop_body47
    br label %end_if86
end_if86:
    %tmp299 = load i8, i8* %char
    %tmp300 = icmp eq i8 %tmp299, 126
    br i1 %tmp300, label %then87, label %end_if87
then87:
    %tmp301 = getelementptr inbounds i32, i32* %iterator, i32 0
    %tmp302 = load i32, i32* %iterator
    %tmp303 = add i32 %tmp302, 1
    store i32 %tmp303, i32* %tmp301
    br label %loop_body47
    br label %end_if87
end_if87:
    %tmp304 = load i8, i8* %char
    call void @console.print_char(i8 %tmp304)
    %tmp305 = getelementptr inbounds i32, i32* %iterator, i32 0
    %tmp306 = load i32, i32* %iterator
    %tmp307 = add i32 %tmp306, 1
    store i32 %tmp307, i32* %tmp305
    br label %loop_body47
loop_body47_exit:
    ret void

    unreachable
}

define i32 @main(){
    call i32 @AllocConsole()
    call void @tests.run()
    call i32 @window.start()
    call i32 @FreeConsole()
    ret i32 0

    unreachable
}

define i64 @window.WindowProc(i8* %hWnd, i32 %uMsg, i64 %wParam, i64 %lParam){
    %tmp0 = icmp eq i32 %uMsg, 16
    br i1 %tmp0, label %then88, label %end_if88
then88:
    call void @PostQuitMessage(i32 0)
    ret i64 0
    br label %end_if88
end_if88:
    %tmp1 = icmp eq i32 %uMsg, 2
    br i1 %tmp1, label %then89, label %end_if89
then89:
    call void @PostQuitMessage(i32 0)
    ret i64 0
    br label %end_if89
end_if89:
    %tmp2 = icmp eq i32 %uMsg, 256
    br i1 %tmp2, label %then90, label %end_if90
then90:
    %tmp3 = icmp eq i64 %wParam, 27
    br i1 %tmp3, label %then91, label %end_if91
then91:
    call void @PostQuitMessage(i32 0)
    ret i64 0
    br label %end_if91
end_if91:
    %tmp4 = trunc i64 %wParam to i8
    call void @console.print_char(i8 %tmp4)
    br label %end_if90
end_if90:
    %tmp5 = call i64 @DefWindowProcA(i8* %hWnd,i32 %uMsg,i64 %wParam,i64 %lParam)
    ret i64 %tmp5

    unreachable
}

define i1 @window.is_null(i8* %p){
    %tmp0 = icmp eq ptr %p, null
    ret i1 %tmp0

    unreachable
}

define i32 @window.start(){
    %CW_USEDEFAULT = alloca i32
    %tmp0 = getelementptr inbounds i32, i32* %CW_USEDEFAULT, i32 0
    store i32 2147483648, i32* %tmp0
    %hInstance = alloca i8*
    %tmp1 = getelementptr inbounds i8*, i8** %hInstance, i32 0
    %tmp2 = call i8* @GetModuleHandleA(i8* null)
    %tmp3 = bitcast i8* %tmp2 to i8*
    store i8* %tmp3, i8** %tmp1
    %tmp4 = load i8*, i8** %hInstance
    %tmp5 = call i1 @window.is_null(i8* %tmp4)
    br i1 %tmp5, label %then92, label %end_if92
then92:
    ret i32 1
    br label %end_if92
end_if92:
    %className = alloca i8*
    %tmp6 = getelementptr inbounds i8*, i8** %className, i32 0
    %tmp7 = getelementptr inbounds [14 x i8], ptr @.str10, i64 0, i64 0
    store i8* %tmp7, i8** %tmp6
    %wc = alloca %struct.window.WNDCLASSEXA
    %tmp8 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %wc, i32 0
    %tmp9 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %tmp8, i32 0, i32 0
    store i32 80, i32* %tmp9
    %tmp10 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %wc, i32 0
    %tmp11 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %tmp10, i32 0, i32 1
    store i32 1, i32* %tmp11
    %tmp12 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %wc, i32 0
    %tmp13 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %tmp12, i32 0, i32 2
    store i64 (i8*, i32, i64, i64)* @window.WindowProc, i64 (i8*, i32, i64, i64)** %tmp13
    %tmp14 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %wc, i32 0
    %tmp15 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %tmp14, i32 0, i32 3
    store i32 0, i32* %tmp15
    %tmp16 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %wc, i32 0
    %tmp17 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %tmp16, i32 0, i32 4
    store i32 0, i32* %tmp17
    %tmp18 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %wc, i32 0
    %tmp19 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %tmp18, i32 0, i32 5
    %tmp20 = load i8*, i8** %hInstance
    store i8* %tmp20, i8** %tmp19
    %tmp21 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %wc, i32 0
    %tmp22 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %tmp21, i32 0, i32 6
    store i8* null, i8** %tmp22
    %tmp23 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %wc, i32 0
    %tmp24 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %tmp23, i32 0, i32 7
    store i8* null, i8** %tmp24
    %tmp25 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %wc, i32 0
    %tmp26 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %tmp25, i32 0, i32 8
    %tmp27 = inttoptr i32 1 to i8*
    store i8* %tmp27, i8** %tmp26
    %tmp28 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %wc, i32 0
    %tmp29 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %tmp28, i32 0, i32 9
    store i8* null, i8** %tmp29
    %tmp30 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %wc, i32 0
    %tmp31 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %tmp30, i32 0, i32 10
    %tmp32 = load i8*, i8** %className
    store i8* %tmp32, i8** %tmp31
    %tmp33 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %wc, i32 0
    %tmp34 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %tmp33, i32 0, i32 11
    store i8* null, i8** %tmp34
    %tmp35 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %wc, i32 0
    %tmp36 = call i16 @RegisterClassExA(%struct.window.WNDCLASSEXA* %tmp35)
    %tmp37 = icmp eq i16 %tmp36, 0
    br i1 %tmp37, label %then93, label %end_if93
then93:
    ret i32 2
    br label %end_if93
end_if93:
    %windowTitle = alloca i8*
    %tmp38 = getelementptr inbounds i8*, i8** %windowTitle, i32 0
    %tmp39 = getelementptr inbounds [14 x i8], ptr @.str11, i64 0, i64 0
    store i8* %tmp39, i8** %tmp38
    %hWnd = alloca i8*
    %tmp40 = getelementptr inbounds i8*, i8** %hWnd, i32 0
    %tmp41 = load i8*, i8** %className
    %tmp42 = load i8*, i8** %windowTitle
    %tmp43 = load i32, i32* %CW_USEDEFAULT
    %tmp44 = load i32, i32* %CW_USEDEFAULT
    %tmp45 = load i8*, i8** %hInstance
    %tmp46 = call i8* @CreateWindowExA(i32 0,i8* %tmp41,i8* %tmp42,i32 13565952,i32 %tmp43,i32 %tmp44,i32 800,i32 600,i8* null,i8* null,i8* %tmp45,i8* null)
    store i8* %tmp46, i8** %tmp40
    %tmp47 = load i8*, i8** %hWnd
    %tmp48 = call i1 @window.is_null(i8* %tmp47)
    br i1 %tmp48, label %then94, label %end_if94
then94:
    ret i32 3
    br label %end_if94
end_if94:
    %tmp49 = load i8*, i8** %hWnd
    call i32 @ShowWindow(i8* %tmp49,i32 1)
    %tmp50 = load i8*, i8** %hWnd
    call i32 @UpdateWindow(i8* %tmp50)
    %msg = alloca %struct.window.MSG
    br label %loop_body95
loop_body95:
    %result = alloca i32
    %tmp51 = getelementptr inbounds i32, i32* %result, i32 0
    %tmp52 = getelementptr inbounds %struct.window.MSG, %struct.window.MSG* %msg, i32 0
    %tmp53 = call i32 @GetMessageA(%struct.window.MSG* %tmp52,i8* null,i32 0,i32 0)
    store i32 %tmp53, i32* %tmp51
    %tmp54 = load i32, i32* %result
    %tmp55 = icmp sgt i32 %tmp54, 0
    br i1 %tmp55, label %then96, label %else96
then96:
    %tmp56 = getelementptr inbounds %struct.window.MSG, %struct.window.MSG* %msg, i32 0
    call i32 @TranslateMessage(%struct.window.MSG* %tmp56)
    %tmp57 = getelementptr inbounds %struct.window.MSG, %struct.window.MSG* %msg, i32 0
    call i64 @DispatchMessageA(%struct.window.MSG* %tmp57)
    br label %end_if96
else96:
    br label %loop_body95_exit
    br label %end_if96
end_if96:
    br label %loop_body95
loop_body95_exit:
    %tmp58 = getelementptr inbounds %struct.window.MSG, %struct.window.MSG* %msg, i32 0
    %tmp59 = getelementptr inbounds %struct.window.MSG, %struct.window.MSG* %tmp58, i32 0, i32 2
    %tmp60 = load i64, i64* %tmp59
    %tmp61 = trunc i64 %tmp60 to i32
    ret i32 %tmp61

    unreachable
}
