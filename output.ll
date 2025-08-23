target triple = "x86_64-pc-windows-msvc"
%struct.list.List = type {%struct.list.ListNode*, %struct.list.ListNode*, i32}
%struct.list.ListNode = type {%struct.list.ListNode*, i32}
%struct.vector.Vec = type {i8*, i32, i32}
%struct.test.test_in1ternal.Example1 = type {i32}
%struct.test.test_in1ternal.Example2 = type {i32, %struct.test.test_in1ternal.Example1*}
%struct.window.WNDCLASSEXA = type {i32, i32, i64 (i8*, i32, i64, i64)*, i32, i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*}
%struct.window.POINT = type {i32, i32}
%struct.window.MSG = type {i8*, i32, i64, i64, i32, %struct.window.POINT}
declare dllimport i32* @GetProcessHeap()
declare dllimport i8* @HeapAlloc(i32*,i32,i64)
declare dllimport i32 @HeapFree(i32*,i32,i8*)
declare dllimport void @ExitProcess(i32)
declare dllimport i32 @MessageBoxA(i8*,i8*,i8*,i32)
declare dllimport i32 @AllocConsole()
declare dllimport i8* @GetStdHandle(i32)
declare dllimport i32 @FreeConsole()
declare dllimport i32 @WriteConsoleA(i8*,i8*,i32,i32*,i8*)
declare dllimport i64 @GetTickCount64()
declare dllimport void @Sleep(i64)
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
@.str0 = internal constant [2 x i8] c"-\00"
@.str1 = internal constant [2 x i8] c"0\00"
@.str2 = internal constant [14 x i8] c"MyWindowClass\00"
@.str3 = internal constant [14 x i8] c"Hello, World!\00"


define void @__chkstk(){
    ret void

    unreachable
}

define i8* @std_process.malloc(i64 %size){
    %tmp0 = call i32* @GetProcessHeap()
    %tmp1 = call i8* @HeapAlloc(i32* %tmp0,i32 0,i64 %size)
    ret i8* %tmp1

    unreachable
}

define void @std_process.free(i8* %ptr){
    %tmp0 = call i32* @GetProcessHeap()
    call i32 @HeapFree(i32* %tmp0,i32 0,i8* %ptr)
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
    %tmp1 = call i8* @std_process.malloc(i64 12)
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
    br i1 %tmp9, label %then0, label %else0
then0:
    %tmp10 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 0
    %tmp11 = load %struct.list.ListNode*, %struct.list.ListNode** %new_node
    store %struct.list.ListNode* %tmp11, %struct.list.ListNode** %tmp10
    %tmp12 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 1
    %tmp13 = load %struct.list.ListNode*, %struct.list.ListNode** %new_node
    store %struct.list.ListNode* %tmp13, %struct.list.ListNode** %tmp12
    br label %end_if0
else0:
    %tmp14 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 1
    %tmp15 = getelementptr inbounds %struct.list.ListNode, %struct.list.ListNode* %tmp14, i32 0, i32 0
    %tmp16 = load %struct.list.ListNode*, %struct.list.ListNode** %new_node
    store %struct.list.ListNode* %tmp16, %struct.list.ListNode** %tmp15
    %tmp17 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0, i32 1
    %tmp18 = load %struct.list.ListNode*, %struct.list.ListNode** %new_node
    store %struct.list.ListNode* %tmp18, %struct.list.ListNode** %tmp17
    br label %end_if0
end_if0:
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
    br label %loop_body1
loop_body1:
    %tmp4 = load %struct.list.ListNode*, %struct.list.ListNode** %ptr
    %tmp5 = icmp eq ptr %tmp4, null
    br i1 %tmp5, label %then2, label %end_if2
then2:
    br label %loop_body1_exit
    br label %end_if2
end_if2:
    %tmp6 = getelementptr inbounds i32, i32* %l, i32 0
    %tmp7 = load i32, i32* %l
    %tmp8 = add i32 %tmp7, 1
    store i32 %tmp8, i32* %tmp6
    %tmp9 = getelementptr inbounds %struct.list.ListNode*, %struct.list.ListNode** %ptr, i32 0
    %tmp10 = getelementptr inbounds %struct.list.ListNode*, %struct.list.ListNode** %ptr, i32 0
    %tmp11 = getelementptr inbounds %struct.list.ListNode, %struct.list.ListNode* %tmp10, i32 0, i32 0
    %tmp12 = load %struct.list.ListNode*, %struct.list.ListNode** %tmp11
    store %struct.list.ListNode* %tmp12, %struct.list.ListNode** %tmp9
    br label %loop_body1
loop_body1_exit:
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
    br label %loop_body3
loop_body3:
    %tmp3 = load %struct.list.ListNode*, %struct.list.ListNode** %current
    %tmp4 = icmp eq ptr %tmp3, null
    br i1 %tmp4, label %then4, label %end_if4
then4:
    br label %loop_body3_exit
    br label %end_if4
end_if4:
    %next = alloca %struct.list.ListNode*
    %tmp5 = getelementptr inbounds %struct.list.ListNode*, %struct.list.ListNode** %next, i32 0
    %tmp6 = getelementptr inbounds %struct.list.ListNode*, %struct.list.ListNode** %current, i32 0
    %tmp7 = getelementptr inbounds %struct.list.ListNode, %struct.list.ListNode* %tmp6, i32 0, i32 0
    %tmp8 = load %struct.list.ListNode*, %struct.list.ListNode** %tmp7
    store %struct.list.ListNode* %tmp8, %struct.list.ListNode** %tmp5
    %tmp9 = load %struct.list.ListNode*, %struct.list.ListNode** %current
    %tmp10 = bitcast %struct.list.ListNode* %tmp9 to i8*
    call void @std_process.free(i8* %tmp10)
    %tmp11 = getelementptr inbounds %struct.list.ListNode*, %struct.list.ListNode** %current, i32 0
    %tmp12 = load %struct.list.ListNode*, %struct.list.ListNode** %next
    store %struct.list.ListNode* %tmp12, %struct.list.ListNode** %tmp11
    br label %loop_body3
loop_body3_exit:
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
    br i1 %tmp4, label %then5, label %end_if5
then5:
    %new_capacity = alloca i32
    %tmp5 = getelementptr inbounds i32, i32* %new_capacity, i32 0
    store i32 4, i32* %tmp5
    %tmp6 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 2
    %tmp7 = load i32, i32* %tmp6
    %tmp8 = icmp ne i32 %tmp7, 0
    br i1 %tmp8, label %then6, label %end_if6
then6:
    %tmp9 = getelementptr inbounds i32, i32* %new_capacity, i32 0
    %tmp10 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 2
    %tmp11 = load i32, i32* %tmp10
    %tmp12 = mul i32 %tmp11, 2
    store i32 %tmp12, i32* %tmp9
    br label %end_if6
end_if6:
    %new_array = alloca i8*
    %tmp13 = getelementptr inbounds i8*, i8** %new_array, i32 0
    %tmp14 = load i32, i32* %new_capacity
    %tmp15 = zext i32 %tmp14 to i64    %tmp16 = mul i64 1, %tmp15
    %tmp17 = call i8* @std_process.malloc(i64 %tmp16)
    store i8* %tmp17, i8** %tmp13
    %tmp18 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 0
    %tmp19 = load i8*, i8** %tmp18
    %tmp20 = icmp ne ptr %tmp19, null
    br i1 %tmp20, label %then7, label %end_if7
then7:
    %i = alloca i32
    %tmp21 = getelementptr inbounds i32, i32* %i, i32 0
    store i32 0, i32* %tmp21
    br label %loop_body8
loop_body8:
    %tmp22 = load i32, i32* %i
    %tmp23 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 1
    %tmp24 = load i32, i32* %tmp23
    %tmp25 = icmp uge i32 %tmp22, %tmp24
    br i1 %tmp25, label %then9, label %end_if9
then9:
    br label %loop_body8_exit
    br label %end_if9
end_if9:
    %tmp26 = load i8*, i8** %new_array
    %tmp27 = load i32, i32* %i
    %tmp28 = zext i32 %tmp27 to i64    %tmp29 = getelementptr i8, i8* %tmp26, i64 %tmp28
    %tmp30 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 0
    %tmp31 = load i8*, i8** %tmp30
    %tmp32 = load i32, i32* %i
    %tmp33 = zext i32 %tmp32 to i64    %tmp34 = getelementptr i8, i8* %tmp31, i64 %tmp33
    %tmp35 = load i8, i8* %tmp34
    store i8 %tmp35, i8* %tmp29
    %tmp36 = getelementptr inbounds i32, i32* %i, i32 0
    %tmp37 = load i32, i32* %i
    %tmp38 = add i32 %tmp37, 1
    store i32 %tmp38, i32* %tmp36
    br label %loop_body8
loop_body8_exit:
    %tmp39 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 0
    %tmp40 = load i8*, i8** %tmp39
    call void @std_process.free(i8* %tmp40)
    br label %end_if7
end_if7:
    %tmp41 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 0
    %tmp42 = load i8*, i8** %new_array
    store i8* %tmp42, i8** %tmp41
    %tmp43 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 2
    %tmp44 = load i32, i32* %new_capacity
    store i32 %tmp44, i32* %tmp43
    br label %end_if5
end_if5:
    %tmp45 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 0
    %tmp46 = load i8*, i8** %tmp45
    %tmp47 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 1
    %tmp48 = load i32, i32* %tmp47
    %tmp49 = zext i32 %tmp48 to i64    %tmp50 = getelementptr i8, i8* %tmp46, i64 %tmp49
    store i8 %data, i8* %tmp50
    %tmp51 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 1
    %tmp52 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 1
    %tmp53 = load i32, i32* %tmp52
    %tmp54 = add i32 %tmp53, 1
    store i32 %tmp54, i32* %tmp51
    ret void

    unreachable
}

define void @vector.free(%struct.vector.Vec* %vec){
    %tmp0 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 0
    %tmp1 = load i8*, i8** %tmp0
    %tmp2 = icmp ne ptr %tmp1, null
    br i1 %tmp2, label %then10, label %end_if10
then10:
    %tmp3 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 0
    %tmp4 = load i8*, i8** %tmp3
    call void @std_process.free(i8* %tmp4)
    br label %end_if10
end_if10:
    %tmp5 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 0
    store i8* null, i8** %tmp5
    %tmp6 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 1
    store i32 0, i32* %tmp6
    %tmp7 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0, i32 2
    store i32 0, i32* %tmp7
    ret void

    unreachable
}

define i8* @std_console.get_stdout(){
    %stdout_handle = alloca i8*
    %tmp0 = getelementptr inbounds i8*, i8** %stdout_handle, i32 0
    %tmp1 = call i8* @GetStdHandle(i32 -11)
    store i8* %tmp1, i8** %tmp0
    %tmp2 = load i8*, i8** %stdout_handle
    %tmp3 = inttoptr i64 18446744073709551615 to i8*
    %tmp4 = icmp eq ptr %tmp2, %tmp3
    br i1 %tmp4, label %then11, label %end_if11
then11:
    call void @ExitProcess(i32 -1)
    br label %end_if11
end_if11:
    %tmp5 = load i8*, i8** %stdout_handle
    ret i8* %tmp5

    unreachable
}

define void @std_console.write(i8* %buffer, i32 %len){
    %chars_written = alloca i32
    %tmp0 = call i8* @std_console.get_stdout()
    %tmp1 = getelementptr inbounds i32, i32* %chars_written, i32 0
    call i32 @WriteConsoleA(i8* %tmp0,i8* %buffer,i32 %len,i32* %tmp1,i8* null)
    %tmp2 = load i32, i32* %chars_written
    %tmp3 = icmp ne i32 %len, %tmp2
    br i1 %tmp3, label %then12, label %end_if12
then12:
    call void @ExitProcess(i32 -2)
    br label %end_if12
end_if12:
    ret void

    unreachable
}

define void @std_console.println_i64(i64 %n){
    %tmp0 = icmp sge i64 %n, 0
    br i1 %tmp0, label %then13, label %else13
then13:
    call void @std_console.println_u64(i64 %n)
    br label %end_if13
else13:
    %tmp1 = getelementptr inbounds [2 x i8], ptr @.str0, i64 0, i64 0
    call void @std_console.write(i8* %tmp1,i32 1)
    %tmp2 = sub i64 0, %n
    call void @std_console.println_u64(i64 %tmp2)
    br label %end_if13
end_if13:
    ret void

    unreachable
}

define void @std_console.println_u64(i64 %n){
    %buffer = alloca %struct.vector.Vec
    %tmp0 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %buffer, i32 0
    call void @vector.new(%struct.vector.Vec* %tmp0)
    %tmp1 = icmp eq i64 %n, 0
    br i1 %tmp1, label %then14, label %end_if14
then14:
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
    call void @std_console.write(i8* %tmp6,i32 %tmp9)
    %tmp10 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %buffer, i32 0
    call void @vector.free(%struct.vector.Vec* %tmp10)
    ret void
    br label %end_if14
end_if14:
    %mut_n = alloca i64
    %tmp11 = getelementptr inbounds i64, i64* %mut_n, i32 0
    store i64 %n, i64* %tmp11
    br label %loop_body15
loop_body15:
    %tmp12 = load i64, i64* %mut_n
    %tmp13 = icmp eq i64 %tmp12, 0
    br i1 %tmp13, label %then16, label %end_if16
then16:
    br label %loop_body15_exit
    br label %end_if16
end_if16:
    %digit_char = alloca i8
    %tmp14 = getelementptr inbounds i8, i8* %digit_char, i32 0
    %tmp15 = load i64, i64* %mut_n
    %tmp16 = urem i64 %tmp15, 10
    %tmp17 = trunc i64 %tmp16 to i8    %tmp18 = add i8 %tmp17, 48
    store i8 %tmp18, i8* %tmp14
    %tmp19 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %buffer, i32 0
    %tmp20 = load i8, i8* %digit_char
    call void @vector.push(%struct.vector.Vec* %tmp19,i8 %tmp20)
    %tmp21 = getelementptr inbounds i64, i64* %mut_n, i32 0
    %tmp22 = load i64, i64* %mut_n
    %tmp23 = udiv i64 %tmp22, 10
    store i64 %tmp23, i64* %tmp21
    br label %loop_body15
loop_body15_exit:
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
    br label %loop_body17
loop_body17:
    %tmp30 = load i32, i32* %i
    %tmp31 = load i32, i32* %j
    %tmp32 = icmp uge i32 %tmp30, %tmp31
    br i1 %tmp32, label %then18, label %end_if18
then18:
    br label %loop_body17_exit
    br label %end_if18
end_if18:
    %temp = alloca i8
    %tmp33 = getelementptr inbounds i8, i8* %temp, i32 0
    %tmp34 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %buffer, i32 0
    %tmp35 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %tmp34, i32 0, i32 0
    %tmp36 = load i8*, i8** %tmp35
    %tmp37 = load i32, i32* %i
    %tmp38 = zext i32 %tmp37 to i64    %tmp39 = getelementptr i8, i8* %tmp36, i64 %tmp38
    %tmp40 = load i8, i8* %tmp39
    store i8 %tmp40, i8* %tmp33
    %tmp41 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %buffer, i32 0
    %tmp42 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %tmp41, i32 0, i32 0
    %tmp43 = load i8*, i8** %tmp42
    %tmp44 = load i32, i32* %i
    %tmp45 = zext i32 %tmp44 to i64    %tmp46 = getelementptr i8, i8* %tmp43, i64 %tmp45
    %tmp47 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %buffer, i32 0
    %tmp48 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %tmp47, i32 0, i32 0
    %tmp49 = load i8*, i8** %tmp48
    %tmp50 = load i32, i32* %j
    %tmp51 = zext i32 %tmp50 to i64    %tmp52 = getelementptr i8, i8* %tmp49, i64 %tmp51
    %tmp53 = load i8, i8* %tmp52
    store i8 %tmp53, i8* %tmp46
    %tmp54 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %buffer, i32 0
    %tmp55 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %tmp54, i32 0, i32 0
    %tmp56 = load i8*, i8** %tmp55
    %tmp57 = load i32, i32* %j
    %tmp58 = zext i32 %tmp57 to i64    %tmp59 = getelementptr i8, i8* %tmp56, i64 %tmp58
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
    br label %loop_body17
loop_body17_exit:
    %tmp67 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %buffer, i32 0
    call void @vector.push(%struct.vector.Vec* %tmp67,i8 10)
    %tmp68 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %buffer, i32 0
    %tmp69 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %tmp68, i32 0, i32 0
    %tmp70 = load i8*, i8** %tmp69
    %tmp71 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %buffer, i32 0
    %tmp72 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %tmp71, i32 0, i32 1
    %tmp73 = load i32, i32* %tmp72
    call void @std_console.write(i8* %tmp70,i32 %tmp73)
    %tmp74 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %buffer, i32 0
    call void @vector.free(%struct.vector.Vec* %tmp74)
    ret void

    unreachable
}

define i32 @c_str_len(i8* %str){
    %len = alloca i32
    %tmp0 = getelementptr inbounds i32, i32* %len, i32 0
    store i32 0, i32* %tmp0
    br label %loop_body19
loop_body19:
    %tmp1 = load i32, i32* %len
    %tmp2 = sext i32 %tmp1 to i64    %tmp3 = getelementptr i8, i8* %str, i64 %tmp2
    %tmp4 = load i8, i8* %tmp3
    %tmp5 = icmp eq i8 %tmp4, 0
    br i1 %tmp5, label %then20, label %end_if20
then20:
    br label %loop_body19_exit
    br label %end_if20
end_if20:
    %tmp6 = getelementptr inbounds i32, i32* %len, i32 0
    %tmp7 = load i32, i32* %len
    %tmp8 = add i32 %tmp7, 1
    store i32 %tmp8, i32* %tmp6
    br label %loop_body19
loop_body19_exit:
    %tmp9 = load i32, i32* %len
    ret i32 %tmp9

    unreachable
}

define i32 @main(){
    %time = alloca i64
    %tmp0 = getelementptr inbounds i64, i64* %time, i32 0
    %tmp1 = call i64 @GetTickCount64()
    store i64 %tmp1, i64* %tmp0
    %tick = alloca i64
    br label %loop_body21
loop_body21:
    call void @Sleep(i64 1000)
    %tmp2 = getelementptr inbounds i64, i64* %tick, i32 0
    %tmp3 = call i64 @GetTickCount64()
    store i64 %tmp3, i64* %tmp2
    %tmp4 = load i64, i64* %tick
    %tmp5 = load i64, i64* %time
    %tmp6 = sub i64 %tmp4, %tmp5
    %tmp7 = icmp uge i64 %tmp6, 1000
    br i1 %tmp7, label %then22, label %end_if22
then22:
    %tmp8 = getelementptr inbounds i64, i64* %time, i32 0
    %tmp9 = load i64, i64* %tick
    store i64 %tmp9, i64* %tmp8
    %tmp10 = load i64, i64* %tick
    call void @std_console.println_u64(i64 %tmp10)
    br label %loop_body21_exit
    br label %end_if22
end_if22:
    br label %loop_body21
loop_body21_exit:
    %i = alloca i64
    %tmp11 = getelementptr inbounds i64, i64* %i, i32 0
    store i64 0, i64* %tmp11
    br label %loop_body23
loop_body23:
    %tmp12 = getelementptr inbounds i64, i64* %i, i32 0
    %tmp13 = load i64, i64* %i
    %tmp14 = add i64 %tmp13, 1
    store i64 %tmp14, i64* %tmp12
    %tmp15 = load i64, i64* %i
    %tmp16 = icmp sge i64 %tmp15, 15
    br i1 %tmp16, label %then24, label %end_if24
then24:
    br label %loop_body23_exit
    br label %end_if24
end_if24:
    br label %loop_body23
loop_body23_exit:
    call i32 @AllocConsole()
    %tmp17 = getelementptr inbounds [2 x i8], ptr @.str1, i64 0, i64 0
    %tmp18 = load i8, i8* %tmp17
    %tmp19 = sext i8 %tmp18 to i64    call void @std_console.println_u64(i64 %tmp19)
    call void @std_console.println_u64(i64 80)
    call void @std_console.println_i64(i64 -1)
    call void @std_console.println_u64(i64 1342)
    call void @std_console.println_u64(i64 777)
    %vec = alloca %struct.vector.Vec
    %tmp20 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0
    call void @vector.new(%struct.vector.Vec* %tmp20)
    %tmp21 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0
    call void @vector.push(%struct.vector.Vec* %tmp21,i8 32)
    %tmp22 = getelementptr inbounds %struct.vector.Vec, %struct.vector.Vec* %vec, i32 0
    call void @vector.free(%struct.vector.Vec* %tmp22)
    %list = alloca %struct.list.List
    %tmp23 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0
    call void @list.new(%struct.list.List* %tmp23)
    %tmp24 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0
    call void @list.extend(%struct.list.List* %tmp24,i32 64)
    %tmp25 = getelementptr inbounds %struct.list.List, %struct.list.List* %list, i32 0
    call void @list.free(%struct.list.List* %tmp25)
    call i32 @window.start()
    call i32 @FreeConsole()
    ret i32 0

    unreachable
}

define i64 @window.WindowProc(i8* %hWnd, i32 %uMsg, i64 %wParam, i64 %lParam){
    %WM_DESTROY = alloca i32
    %tmp0 = getelementptr inbounds i32, i32* %WM_DESTROY, i32 0
    store i32 2, i32* %tmp0
    %WM_CLOSE = alloca i32
    %tmp1 = getelementptr inbounds i32, i32* %WM_CLOSE, i32 0
    store i32 16, i32* %tmp1
    %tmp2 = load i32, i32* %WM_CLOSE
    %tmp3 = icmp eq i32 %uMsg, %tmp2
    br i1 %tmp3, label %then25, label %end_if25
then25:
    call void @PostQuitMessage(i32 0)
    ret i64 0
    br label %end_if25
end_if25:
    %tmp4 = load i32, i32* %WM_DESTROY
    %tmp5 = icmp eq i32 %uMsg, %tmp4
    br i1 %tmp5, label %then26, label %end_if26
then26:
    call void @PostQuitMessage(i32 0)
    ret i64 0
    br label %end_if26
end_if26:
    %tmp6 = call i64 @DefWindowProcA(i8* %hWnd,i32 %uMsg,i64 %wParam,i64 %lParam)
    ret i64 %tmp6

    unreachable
}

define i32 @window.start(){
    %CS_HREDRAW = alloca i32
    %tmp0 = getelementptr inbounds i32, i32* %CS_HREDRAW, i32 0
    store i32 2, i32* %tmp0
    %CS_VREDRAW = alloca i32
    %tmp1 = getelementptr inbounds i32, i32* %CS_VREDRAW, i32 0
    store i32 1, i32* %tmp1
    %WS_OVERLAPPED = alloca i32
    %tmp2 = getelementptr inbounds i32, i32* %WS_OVERLAPPED, i32 0
    store i32 0, i32* %tmp2
    %WS_CAPTION = alloca i32
    %tmp3 = getelementptr inbounds i32, i32* %WS_CAPTION, i32 0
    store i32 12582912, i32* %tmp3
    %WS_SYSMENU = alloca i32
    %tmp4 = getelementptr inbounds i32, i32* %WS_SYSMENU, i32 0
    store i32 524288, i32* %tmp4
    %WS_THICKFRAME = alloca i32
    %tmp5 = getelementptr inbounds i32, i32* %WS_THICKFRAME, i32 0
    store i32 262144, i32* %tmp5
    %WS_MINIMIZEBOX = alloca i32
    %tmp6 = getelementptr inbounds i32, i32* %WS_MINIMIZEBOX, i32 0
    store i32 131072, i32* %tmp6
    %WS_MAXIMIZEBOX = alloca i32
    %tmp7 = getelementptr inbounds i32, i32* %WS_MAXIMIZEBOX, i32 0
    store i32 65536, i32* %tmp7
    %WS_OVERLAPPEDWINDOW = alloca i32
    %tmp8 = getelementptr inbounds i32, i32* %WS_OVERLAPPEDWINDOW, i32 0
    %tmp9 = load i32, i32* %WS_OVERLAPPED
    %tmp10 = load i32, i32* %WS_CAPTION
    %tmp11 = or i32 %tmp9, %tmp10
    %tmp12 = load i32, i32* %WS_SYSMENU
    %tmp13 = or i32 %tmp11, %tmp12
    %tmp14 = load i32, i32* %WS_THICKFRAME
    %tmp15 = or i32 %tmp13, %tmp14
    %tmp16 = load i32, i32* %WS_MINIMIZEBOX
    %tmp17 = or i32 %tmp15, %tmp16
    %tmp18 = load i32, i32* %WS_MAXIMIZEBOX
    %tmp19 = or i32 %tmp17, %tmp18
    store i32 %tmp19, i32* %tmp8
    %CW_USEDEFAULT = alloca i32
    %tmp20 = getelementptr inbounds i32, i32* %CW_USEDEFAULT, i32 0
    store i32 2147483648, i32* %tmp20
    %COLOR_WINDOW = alloca i32
    %tmp21 = getelementptr inbounds i32, i32* %COLOR_WINDOW, i32 0
    store i32 5, i32* %tmp21
    %SW_SHOWNORMAL = alloca i32
    %tmp22 = getelementptr inbounds i32, i32* %SW_SHOWNORMAL, i32 0
    store i32 1, i32* %tmp22
    %hInstance = alloca i8*
    %tmp23 = getelementptr inbounds i8*, i8** %hInstance, i32 0
    %tmp24 = call i8* @GetModuleHandleA(i8* null)
    store i8* %tmp24, i8** %tmp23
    %tmp25 = load i8*, i8** %hInstance
    %tmp26 = icmp eq ptr %tmp25, null
    br i1 %tmp26, label %then27, label %end_if27
then27:
    ret i32 -1
    br label %end_if27
end_if27:
    %className = alloca i8*
    %tmp27 = getelementptr inbounds i8*, i8** %className, i32 0
    %tmp28 = getelementptr inbounds [14 x i8], ptr @.str2, i64 0, i64 0
    store i8* %tmp28, i8** %tmp27
    %wc = alloca %struct.window.WNDCLASSEXA
    %tmp29 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %wc, i32 0
    %tmp30 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %tmp29, i32 0, i32 0
    store i32 80, i32* %tmp30
    %tmp31 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %wc, i32 0
    %tmp32 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %tmp31, i32 0, i32 1
    %tmp33 = load i32, i32* %CS_HREDRAW
    %tmp34 = load i32, i32* %CS_VREDRAW
    %tmp35 = or i32 %tmp33, %tmp34
    store i32 %tmp35, i32* %tmp32
    %tmp36 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %wc, i32 0
    %tmp37 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %tmp36, i32 0, i32 2
    store i64 (i8*, i32, i64, i64)* @window.WindowProc, i64 (i8*, i32, i64, i64)** %tmp37
    %tmp38 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %wc, i32 0
    %tmp39 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %tmp38, i32 0, i32 3
    store i32 0, i32* %tmp39
    %tmp40 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %wc, i32 0
    %tmp41 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %tmp40, i32 0, i32 4
    store i32 0, i32* %tmp41
    %tmp42 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %wc, i32 0
    %tmp43 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %tmp42, i32 0, i32 5
    %tmp44 = load i8*, i8** %hInstance
    store i8* %tmp44, i8** %tmp43
    %tmp45 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %wc, i32 0
    %tmp46 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %tmp45, i32 0, i32 6
    store i8* null, i8** %tmp46
    %tmp47 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %wc, i32 0
    %tmp48 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %tmp47, i32 0, i32 7
    store i8* null, i8** %tmp48
    %tmp49 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %wc, i32 0
    %tmp50 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %tmp49, i32 0, i32 8
    %tmp51 = load i32, i32* %COLOR_WINDOW
    %tmp52 = add i32 %tmp51, 1
    %tmp53 = inttoptr i32 %tmp52 to i8*
    store i8* %tmp53, i8** %tmp50
    %tmp54 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %wc, i32 0
    %tmp55 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %tmp54, i32 0, i32 9
    store i8* null, i8** %tmp55
    %tmp56 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %wc, i32 0
    %tmp57 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %tmp56, i32 0, i32 10
    %tmp58 = load i8*, i8** %className
    store i8* %tmp58, i8** %tmp57
    %tmp59 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %wc, i32 0
    %tmp60 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %tmp59, i32 0, i32 11
    store i8* null, i8** %tmp60
    %tmp61 = getelementptr inbounds %struct.window.WNDCLASSEXA, %struct.window.WNDCLASSEXA* %wc, i32 0
    %tmp62 = call i16 @RegisterClassExA(%struct.window.WNDCLASSEXA* %tmp61)
    %tmp63 = icmp eq i16 %tmp62, 0
    br i1 %tmp63, label %then28, label %end_if28
then28:
    ret i32 -2
    br label %end_if28
end_if28:
    %windowTitle = alloca i8*
    %tmp64 = getelementptr inbounds i8*, i8** %windowTitle, i32 0
    %tmp65 = getelementptr inbounds [14 x i8], ptr @.str3, i64 0, i64 0
    store i8* %tmp65, i8** %tmp64
    %hWnd = alloca i8*
    %tmp66 = getelementptr inbounds i8*, i8** %hWnd, i32 0
    %tmp67 = load i8*, i8** %className
    %tmp68 = load i8*, i8** %windowTitle
    %tmp69 = load i32, i32* %WS_OVERLAPPEDWINDOW
    %tmp70 = load i32, i32* %CW_USEDEFAULT
    %tmp71 = load i32, i32* %CW_USEDEFAULT
    %tmp72 = load i8*, i8** %hInstance
    %tmp73 = call i8* @CreateWindowExA(i32 0,i8* %tmp67,i8* %tmp68,i32 %tmp69,i32 %tmp70,i32 %tmp71,i32 800,i32 600,i8* null,i8* null,i8* %tmp72,i8* null)
    store i8* %tmp73, i8** %tmp66
    %tmp74 = load i8*, i8** %hWnd
    %tmp75 = icmp eq ptr %tmp74, null
    br i1 %tmp75, label %then29, label %end_if29
then29:
    ret i32 -3
    br label %end_if29
end_if29:
    %tmp76 = load i8*, i8** %hWnd
    %tmp77 = load i32, i32* %SW_SHOWNORMAL
    call i32 @ShowWindow(i8* %tmp76,i32 %tmp77)
    %tmp78 = load i8*, i8** %hWnd
    call i32 @UpdateWindow(i8* %tmp78)
    %msg = alloca %struct.window.MSG
    br label %loop_body30
loop_body30:
    %result = alloca i32
    %tmp79 = getelementptr inbounds i32, i32* %result, i32 0
    %tmp80 = getelementptr inbounds %struct.window.MSG, %struct.window.MSG* %msg, i32 0
    %tmp81 = call i32 @GetMessageA(%struct.window.MSG* %tmp80,i8* null,i32 0,i32 0)
    store i32 %tmp81, i32* %tmp79
    %tmp82 = load i32, i32* %result
    %tmp83 = icmp sgt i32 %tmp82, 0
    br i1 %tmp83, label %then31, label %else31
then31:
    %tmp84 = getelementptr inbounds %struct.window.MSG, %struct.window.MSG* %msg, i32 0
    call i32 @TranslateMessage(%struct.window.MSG* %tmp84)
    %tmp85 = getelementptr inbounds %struct.window.MSG, %struct.window.MSG* %msg, i32 0
    call i64 @DispatchMessageA(%struct.window.MSG* %tmp85)
    br label %end_if31
else31:
    br label %loop_body30_exit
    br label %end_if31
end_if31:
    br label %loop_body30
loop_body30_exit:
    %tmp86 = getelementptr inbounds %struct.window.MSG, %struct.window.MSG* %msg, i32 0
    %tmp87 = getelementptr inbounds %struct.window.MSG, %struct.window.MSG* %tmp86, i32 0, i32 2
    %tmp88 = load i64, i64* %tmp87
    %tmp89 = trunc i64 %tmp88 to i32    ret i32 %tmp89

    unreachable
}
