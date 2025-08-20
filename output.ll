target triple = "x86_64-pc-windows-msvc"
%struct.List = type {%struct.ListNode*, %struct.ListNode*, i32}
%struct.ListNode = type {%struct.ListNode*, i32}
%struct.Vec = type {i8*, i32, i32}
%struct.WNDCLASSEXA = type {i32, i32, i64 (i8*, i32, i64, i64)*, i32, i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*}
%struct.POINT = type {i32, i32}
%struct.MSG = type {i8*, i32, i64, i64, i32, %struct.POINT}
declare dllimport i32* @GetProcessHeap()
declare dllimport i8* @HeapAlloc(i32*,i32,i64)
declare dllimport i32 @HeapFree(i32*,i32,i8*)
declare dllimport void @ExitProcess(i32)
declare dllimport i32 @MessageBoxA(i8*,i8*,i8*,i32)
declare dllimport i32 @AllocConsole()
declare dllimport i8* @GetStdHandle(i32)
declare dllimport i32 @FreeConsole()
declare dllimport i32 @WriteConsoleA(i8*,i8*,i32,i32*,i8*)
declare dllimport i16 @RegisterClassExA(%struct.WNDCLASSEXA*)
declare dllimport i8* @CreateWindowExA(i32,i8*,i8*,i32,i32,i32,i32,i32,i8*,i8*,i8*,i8*)
declare dllimport i32 @ShowWindow(i8*,i32)
declare dllimport i32 @UpdateWindow(i8*)
declare dllimport i32 @GetMessageA(%struct.MSG*,i8*,i32,i32)
declare dllimport i32 @TranslateMessage(%struct.MSG*)
declare dllimport i64 @DispatchMessageA(%struct.MSG*)
declare dllimport i64 @DefWindowProcA(i8*,i32,i64,i64)
declare dllimport void @PostQuitMessage(i32)
declare dllimport i8* @GetModuleHandleA(i8*)
@.str0 = internal constant [2 x i8] c"-\00"
@.str1 = internal constant [48 x i8] c"Pee pee poo poo
 Waterfall 
 TORRONTO CENTRAL 
\00"
@.str2 = internal constant [2 x i8] c"0\00"
@.str3 = internal constant [14 x i8] c"MyWindowClass\00"
@.str4 = internal constant [14 x i8] c"Hello, World!\00"


define void @__chkstk(){
    ret void

    unreachable
}

define i8* @std_process.malloc(i64 %size){
    %tmp2 = call i32* @GetProcessHeap()
    %tmp4 = call i8* @HeapAlloc(i32* %tmp2,i32 0,i64 %size)
    ret i8* %tmp4

    unreachable
}

define void @std_process.free(i8* %ptr){
    %tmp2 = call i32* @GetProcessHeap()
    call i32 @HeapFree(i32* %tmp2,i32 0,i8* %ptr)
    ret void

    unreachable
}

define void @list.new(%struct.List* %list){
    %tmp1 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0, i32 0
    store %struct.ListNode* null, %struct.ListNode** %tmp1
    %tmp3 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0, i32 1
    store %struct.ListNode* null, %struct.ListNode** %tmp3
    %tmp5 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0, i32 2
    store i32 0, i32* %tmp5
    ret void

    unreachable
}

define void @list.new_node(%struct.ListNode* %list){
    %tmp1 = getelementptr inbounds %struct.ListNode, %struct.ListNode* %list, i32 0, i32 0
    store %struct.ListNode* null, %struct.ListNode** %tmp1
    %tmp3 = getelementptr inbounds %struct.ListNode, %struct.ListNode* %list, i32 0, i32 1
    store i32 0, i32* %tmp3
    ret void

    unreachable
}

define void @list.extend(%struct.List* %list, i32 %data){
    %new_node = alloca %struct.ListNode*
    %tmp0 = getelementptr inbounds %struct.ListNode*, %struct.ListNode** %new_node, i32 0
    %tmp2 = call i8* @std_process.malloc(i64 12)
    %tmp3 = bitcast i8* %tmp2 to %struct.ListNode*
    store %struct.ListNode* %tmp3, %struct.ListNode** %tmp0
    %tmp4 = getelementptr inbounds %struct.ListNode*, %struct.ListNode** %new_node, i32 0
    %tmp5 = getelementptr inbounds %struct.ListNode, %struct.ListNode* %tmp4, i32 0, i32 0
    store %struct.ListNode* null, %struct.ListNode** %tmp5
    %tmp6 = getelementptr inbounds %struct.ListNode*, %struct.ListNode** %new_node, i32 0
    %tmp7 = getelementptr inbounds %struct.ListNode, %struct.ListNode* %tmp6, i32 0, i32 1
    store i32 %data, i32* %tmp7
    %tmp10 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0, i32 0
    %tmp11 = load %struct.ListNode*, %struct.ListNode** %tmp10
    %tmp12 = icmp eq ptr %tmp11, null
    br i1 %tmp12, label %then0, label %else0
then0:
    %tmp14 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0, i32 0
    %tmp15 = load %struct.ListNode*, %struct.ListNode** %new_node
    store %struct.ListNode* %tmp15, %struct.ListNode** %tmp14
    %tmp17 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0, i32 1
    %tmp18 = load %struct.ListNode*, %struct.ListNode** %new_node
    store %struct.ListNode* %tmp18, %struct.ListNode** %tmp17
    br label %end_if0
else0:
    %tmp20 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0, i32 1
    %tmp21 = getelementptr inbounds %struct.ListNode, %struct.ListNode* %tmp20, i32 0, i32 0
    %tmp22 = load %struct.ListNode*, %struct.ListNode** %new_node
    store %struct.ListNode* %tmp22, %struct.ListNode** %tmp21
    %tmp24 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0, i32 1
    %tmp25 = load %struct.ListNode*, %struct.ListNode** %new_node
    store %struct.ListNode* %tmp25, %struct.ListNode** %tmp24
    br label %end_if0
end_if0:
    %tmp27 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0, i32 2
    %tmp29 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0, i32 2
    %tmp30 = load i32, i32* %tmp29
    %tmp31 = add i32 %tmp30, 1
    store i32 %tmp31, i32* %tmp27
    ret void

    unreachable
}

define i32 @list.walk(%struct.List* %list){
    %l = alloca i32
    %tmp0 = getelementptr inbounds i32, i32* %l, i32 0
    store i32 0, i32* %tmp0
    %ptr = alloca %struct.ListNode*
    %tmp1 = getelementptr inbounds %struct.ListNode*, %struct.ListNode** %ptr, i32 0
    %tmp3 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0, i32 0
    %tmp4 = load %struct.ListNode*, %struct.ListNode** %tmp3
    store %struct.ListNode* %tmp4, %struct.ListNode** %tmp1
    br label %loop_body1
loop_body1:
    %tmp5 = load %struct.ListNode*, %struct.ListNode** %ptr
    %tmp6 = icmp eq ptr %tmp5, null
    br i1 %tmp6, label %then2, label %end_if2
then2:
    br label %loop_body1_exit
    br label %end_if2
end_if2:
    %tmp7 = getelementptr inbounds i32, i32* %l, i32 0
    %tmp8 = load i32, i32* %l
    %tmp9 = add i32 %tmp8, 1
    store i32 %tmp9, i32* %tmp7
    %tmp10 = getelementptr inbounds %struct.ListNode*, %struct.ListNode** %ptr, i32 0
    %tmp11 = getelementptr inbounds %struct.ListNode*, %struct.ListNode** %ptr, i32 0
    %tmp12 = getelementptr inbounds %struct.ListNode, %struct.ListNode* %tmp11, i32 0, i32 0
    %tmp13 = load %struct.ListNode*, %struct.ListNode** %tmp12
    store %struct.ListNode* %tmp13, %struct.ListNode** %tmp10
    br label %loop_body1
loop_body1_exit:
    %tmp14 = load i32, i32* %l
    ret i32 %tmp14

    unreachable
}

define void @list.free(%struct.List* %list){
    %current = alloca %struct.ListNode*
    %tmp0 = getelementptr inbounds %struct.ListNode*, %struct.ListNode** %current, i32 0
    %tmp2 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0, i32 0
    %tmp3 = load %struct.ListNode*, %struct.ListNode** %tmp2
    store %struct.ListNode* %tmp3, %struct.ListNode** %tmp0
    br label %loop_body3
loop_body3:
    %tmp4 = load %struct.ListNode*, %struct.ListNode** %current
    %tmp5 = icmp eq ptr %tmp4, null
    br i1 %tmp5, label %then4, label %end_if4
then4:
    br label %loop_body3_exit
    br label %end_if4
end_if4:
    %next = alloca %struct.ListNode*
    %tmp6 = getelementptr inbounds %struct.ListNode*, %struct.ListNode** %next, i32 0
    %tmp7 = getelementptr inbounds %struct.ListNode*, %struct.ListNode** %current, i32 0
    %tmp8 = getelementptr inbounds %struct.ListNode, %struct.ListNode* %tmp7, i32 0, i32 0
    %tmp9 = load %struct.ListNode*, %struct.ListNode** %tmp8
    store %struct.ListNode* %tmp9, %struct.ListNode** %tmp6
    %tmp11 = load %struct.ListNode*, %struct.ListNode** %current
    %tmp12 = bitcast %struct.ListNode* %tmp11 to i8*
    call void @std_process.free(i8* %tmp12)
    %tmp13 = getelementptr inbounds %struct.ListNode*, %struct.ListNode** %current, i32 0
    %tmp14 = load %struct.ListNode*, %struct.ListNode** %next
    store %struct.ListNode* %tmp14, %struct.ListNode** %tmp13
    br label %loop_body3
loop_body3_exit:
    %tmp16 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0, i32 0
    store %struct.ListNode* null, %struct.ListNode** %tmp16
    %tmp18 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0, i32 1
    store %struct.ListNode* null, %struct.ListNode** %tmp18
    %tmp20 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0, i32 2
    store i32 0, i32* %tmp20
    ret void

    unreachable
}

define void @vector.new(%struct.Vec* %vec){
    %tmp1 = getelementptr inbounds %struct.Vec, %struct.Vec* %vec, i32 0, i32 0
    store i8* null, i8** %tmp1
    %tmp3 = getelementptr inbounds %struct.Vec, %struct.Vec* %vec, i32 0, i32 1
    store i32 0, i32* %tmp3
    %tmp5 = getelementptr inbounds %struct.Vec, %struct.Vec* %vec, i32 0, i32 2
    store i32 0, i32* %tmp5
    ret void

    unreachable
}

define void @vector.push(%struct.Vec* %vec, i8 %data){
    %tmp1 = getelementptr inbounds %struct.Vec, %struct.Vec* %vec, i32 0, i32 1
    %tmp2 = load i32, i32* %tmp1
    %tmp4 = getelementptr inbounds %struct.Vec, %struct.Vec* %vec, i32 0, i32 2
    %tmp5 = load i32, i32* %tmp4
    %tmp6 = icmp uge i32 %tmp2, %tmp5
    br i1 %tmp6, label %then5, label %end_if5
then5:
    %new_capacity = alloca i32
    %tmp7 = getelementptr inbounds i32, i32* %new_capacity, i32 0
    store i32 4, i32* %tmp7
    %tmp9 = getelementptr inbounds %struct.Vec, %struct.Vec* %vec, i32 0, i32 2
    %tmp10 = load i32, i32* %tmp9
    %tmp11 = icmp ne i32 %tmp10, 0
    br i1 %tmp11, label %then6, label %end_if6
then6:
    %tmp12 = getelementptr inbounds i32, i32* %new_capacity, i32 0
    %tmp14 = getelementptr inbounds %struct.Vec, %struct.Vec* %vec, i32 0, i32 2
    %tmp15 = load i32, i32* %tmp14
    %tmp16 = mul i32 %tmp15, 2
    store i32 %tmp16, i32* %tmp12
    br label %end_if6
end_if6:
    %new_array = alloca i8*
    %tmp17 = getelementptr inbounds i8*, i8** %new_array, i32 0
    %tmp19 = load i32, i32* %new_capacity
    %tmp20 = zext i32 %tmp19 to i64
    %tmp21 = mul i64 1, %tmp20
    %tmp22 = call i8* @std_process.malloc(i64 %tmp21)
    store i8* %tmp22, i8** %tmp17
    %tmp24 = getelementptr inbounds %struct.Vec, %struct.Vec* %vec, i32 0, i32 0
    %tmp25 = load i8*, i8** %tmp24
    %tmp26 = icmp ne ptr %tmp25, null
    br i1 %tmp26, label %then7, label %end_if7
then7:
    %i = alloca i32
    %tmp27 = getelementptr inbounds i32, i32* %i, i32 0
    store i32 0, i32* %tmp27
    br label %loop_body8
loop_body8:
    %tmp28 = load i32, i32* %i
    %tmp30 = getelementptr inbounds %struct.Vec, %struct.Vec* %vec, i32 0, i32 1
    %tmp31 = load i32, i32* %tmp30
    %tmp32 = icmp uge i32 %tmp28, %tmp31
    br i1 %tmp32, label %then9, label %end_if9
then9:
    br label %loop_body8_exit
    br label %end_if9
end_if9:
    %tmp33 = load i8*, i8** %new_array
    %tmp34 = load i32, i32* %i
    %tmp35 = zext i32 %tmp34 to i64
    %tmp36 = getelementptr i8, i8* %tmp33, i64 %tmp35
    %tmp38 = getelementptr inbounds %struct.Vec, %struct.Vec* %vec, i32 0, i32 0
    %tmp39 = load i8*, i8** %tmp38
    %tmp40 = load i32, i32* %i
    %tmp41 = zext i32 %tmp40 to i64
    %tmp42 = getelementptr i8, i8* %tmp39, i64 %tmp41
    %tmp43 = load i8, i8* %tmp42
    store i8 %tmp43, i8* %tmp36
    %tmp44 = getelementptr inbounds i32, i32* %i, i32 0
    %tmp45 = load i32, i32* %i
    %tmp46 = add i32 %tmp45, 1
    store i32 %tmp46, i32* %tmp44
    br label %loop_body8
loop_body8_exit:
    %tmp49 = getelementptr inbounds %struct.Vec, %struct.Vec* %vec, i32 0, i32 0
    %tmp50 = load i8*, i8** %tmp49
    call void @std_process.free(i8* %tmp50)
    br label %end_if7
end_if7:
    %tmp52 = getelementptr inbounds %struct.Vec, %struct.Vec* %vec, i32 0, i32 0
    %tmp53 = load i8*, i8** %new_array
    store i8* %tmp53, i8** %tmp52
    %tmp55 = getelementptr inbounds %struct.Vec, %struct.Vec* %vec, i32 0, i32 2
    %tmp56 = load i32, i32* %new_capacity
    store i32 %tmp56, i32* %tmp55
    br label %end_if5
end_if5:
    %tmp58 = getelementptr inbounds %struct.Vec, %struct.Vec* %vec, i32 0, i32 0
    %tmp59 = load i8*, i8** %tmp58
    %tmp61 = getelementptr inbounds %struct.Vec, %struct.Vec* %vec, i32 0, i32 1
    %tmp62 = load i32, i32* %tmp61
    %tmp63 = zext i32 %tmp62 to i64
    %tmp64 = getelementptr i8, i8* %tmp59, i64 %tmp63
    store i8 %data, i8* %tmp64
    %tmp67 = getelementptr inbounds %struct.Vec, %struct.Vec* %vec, i32 0, i32 1
    %tmp69 = getelementptr inbounds %struct.Vec, %struct.Vec* %vec, i32 0, i32 1
    %tmp70 = load i32, i32* %tmp69
    %tmp71 = add i32 %tmp70, 1
    store i32 %tmp71, i32* %tmp67
    ret void

    unreachable
}

define void @vector.free(%struct.Vec* %vec){
    %tmp1 = getelementptr inbounds %struct.Vec, %struct.Vec* %vec, i32 0, i32 0
    %tmp2 = load i8*, i8** %tmp1
    %tmp3 = icmp ne ptr %tmp2, null
    br i1 %tmp3, label %then10, label %end_if10
then10:
    %tmp6 = getelementptr inbounds %struct.Vec, %struct.Vec* %vec, i32 0, i32 0
    %tmp7 = load i8*, i8** %tmp6
    call void @std_process.free(i8* %tmp7)
    br label %end_if10
end_if10:
    %tmp9 = getelementptr inbounds %struct.Vec, %struct.Vec* %vec, i32 0, i32 0
    store i8* null, i8** %tmp9
    %tmp11 = getelementptr inbounds %struct.Vec, %struct.Vec* %vec, i32 0, i32 1
    store i32 0, i32* %tmp11
    %tmp13 = getelementptr inbounds %struct.Vec, %struct.Vec* %vec, i32 0, i32 2
    store i32 0, i32* %tmp13
    ret void

    unreachable
}

define i8* @std_console.get_stdout(){
    %stdout_handle = alloca i8*
    %tmp0 = getelementptr inbounds i8*, i8** %stdout_handle, i32 0
    %tmp2 = call i8* @GetStdHandle(i32 -11)
    store i8* %tmp2, i8** %tmp0
    %tmp3 = load i8*, i8** %stdout_handle
    %tmp4 = inttoptr i64 18446744073709551615 to i8*
    %tmp5 = icmp eq ptr %tmp3, %tmp4
    br i1 %tmp5, label %then11, label %end_if11
then11:
    call void @ExitProcess(i32 -1)
    br label %end_if11
end_if11:
    %tmp7 = load i8*, i8** %stdout_handle
    ret i8* %tmp7

    unreachable
}

define void @std_console.write(i8* %buffer, i32 %len){
    %chars_written = alloca i32
    %tmp2 = call i8* @std_console.get_stdout()
    %tmp5 = getelementptr inbounds i32, i32* %chars_written, i32 0
    call i32 @WriteConsoleA(i8* %tmp2,i8* %buffer,i32 %len,i32* %tmp5,i8* null)
    %tmp7 = load i32, i32* %chars_written
    %tmp8 = icmp ne i32 %len, %tmp7
    br i1 %tmp8, label %then12, label %end_if12
then12:
    call void @ExitProcess(i32 -2)
    br label %end_if12
end_if12:
    ret void

    unreachable
}

define void @std_console.println_i64(i64 %n){
    %tmp1 = icmp sge i64 %n, 0
    br i1 %tmp1, label %then13, label %else13
then13:
%tmp5 = add i64 %n , 0    %tmp4 = bitcast i64 %tmp5 to i64
    call void @std_console.println_u64(i64 %tmp4)
    br label %end_if13
else13:
    %tmp7 = getelementptr inbounds [2 x i8], ptr @.str0, i64 0, i64 0
    call void @std_console.write(i8* %tmp7,i32 1)
    %tmp10 = sub i64 0, %n
    %tmp11 = bitcast i64 %tmp10 to i64
    call void @std_console.println_u64(i64 %tmp11)
    br label %end_if13
end_if13:
    ret void

    unreachable
}

define void @std_console.println_u64(i64 %n){
    %buffer = alloca %struct.Vec
    %tmp1 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    call void @vector.new(%struct.Vec* %tmp1)
    %tmp3 = icmp eq i64 %n, 0
    br i1 %tmp3, label %then14, label %end_if14
then14:
    %tmp5 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    call void @vector.push(%struct.Vec* %tmp5,i8 48)
    %tmp7 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    call void @vector.push(%struct.Vec* %tmp7,i8 10)
    %tmp9 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    %tmp10 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp9, i32 0, i32 0
    %tmp11 = load i8*, i8** %tmp10
    %tmp12 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    %tmp13 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp12, i32 0, i32 1
    %tmp14 = load i32, i32* %tmp13
    %tmp15 = bitcast i32 %tmp14 to i32
    call void @std_console.write(i8* %tmp11,i32 %tmp15)
    %tmp17 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    call void @vector.free(%struct.Vec* %tmp17)
    ret void
    br label %end_if14
end_if14:
    %mut_n = alloca i64
    %tmp18 = getelementptr inbounds i64, i64* %mut_n, i32 0
    store i64 %n, i64* %tmp18
    br label %loop_body15
loop_body15:
    %tmp20 = load i64, i64* %mut_n
    %tmp21 = icmp eq i64 %tmp20, 0
    br i1 %tmp21, label %then16, label %end_if16
then16:
    br label %loop_body15_exit
    br label %end_if16
end_if16:
    %digit_char = alloca i8
    %tmp22 = getelementptr inbounds i8, i8* %digit_char, i32 0
    %tmp23 = load i64, i64* %mut_n
    %tmp24 = urem i64 %tmp23, 10
    %tmp25 = trunc i64 %tmp24 to i8
    %tmp26 = add i8 %tmp25, 48
    store i8 %tmp26, i8* %tmp22
    %tmp28 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    %tmp29 = load i8, i8* %digit_char
    call void @vector.push(%struct.Vec* %tmp28,i8 %tmp29)
    %tmp30 = getelementptr inbounds i64, i64* %mut_n, i32 0
    %tmp31 = load i64, i64* %mut_n
    %tmp32 = udiv i64 %tmp31, 10
    store i64 %tmp32, i64* %tmp30
    br label %loop_body15
loop_body15_exit:
    %i = alloca i32
    %tmp33 = getelementptr inbounds i32, i32* %i, i32 0
    store i32 0, i32* %tmp33
    %j = alloca i32
    %tmp34 = getelementptr inbounds i32, i32* %j, i32 0
    %tmp35 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    %tmp36 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp35, i32 0, i32 1
    %tmp37 = load i32, i32* %tmp36
    %tmp38 = sub i32 %tmp37, 1
    store i32 %tmp38, i32* %tmp34
    br label %loop_body17
loop_body17:
    %tmp39 = load i32, i32* %i
    %tmp40 = load i32, i32* %j
    %tmp41 = icmp uge i32 %tmp39, %tmp40
    br i1 %tmp41, label %then18, label %end_if18
then18:
    br label %loop_body17_exit
    br label %end_if18
end_if18:
    %temp = alloca i8
    %tmp42 = getelementptr inbounds i8, i8* %temp, i32 0
    %tmp43 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    %tmp44 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp43, i32 0, i32 0
    %tmp45 = load i8*, i8** %tmp44
    %tmp46 = load i32, i32* %i
    %tmp47 = zext i32 %tmp46 to i64
    %tmp48 = getelementptr i8, i8* %tmp45, i64 %tmp47
    %tmp49 = load i8, i8* %tmp48
    store i8 %tmp49, i8* %tmp42
    %tmp50 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    %tmp51 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp50, i32 0, i32 0
    %tmp52 = load i8*, i8** %tmp51
    %tmp53 = load i32, i32* %i
    %tmp54 = zext i32 %tmp53 to i64
    %tmp55 = getelementptr i8, i8* %tmp52, i64 %tmp54
    %tmp56 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    %tmp57 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp56, i32 0, i32 0
    %tmp58 = load i8*, i8** %tmp57
    %tmp59 = load i32, i32* %j
    %tmp60 = zext i32 %tmp59 to i64
    %tmp61 = getelementptr i8, i8* %tmp58, i64 %tmp60
    %tmp62 = load i8, i8* %tmp61
    store i8 %tmp62, i8* %tmp55
    %tmp63 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    %tmp64 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp63, i32 0, i32 0
    %tmp65 = load i8*, i8** %tmp64
    %tmp66 = load i32, i32* %j
    %tmp67 = zext i32 %tmp66 to i64
    %tmp68 = getelementptr i8, i8* %tmp65, i64 %tmp67
    %tmp69 = load i8, i8* %temp
    store i8 %tmp69, i8* %tmp68
    %tmp70 = getelementptr inbounds i32, i32* %i, i32 0
    %tmp71 = load i32, i32* %i
    %tmp72 = add i32 %tmp71, 1
    store i32 %tmp72, i32* %tmp70
    %tmp73 = getelementptr inbounds i32, i32* %j, i32 0
    %tmp74 = load i32, i32* %j
    %tmp75 = sub i32 %tmp74, 1
    store i32 %tmp75, i32* %tmp73
    br label %loop_body17
loop_body17_exit:
    %tmp77 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    call void @vector.push(%struct.Vec* %tmp77,i8 10)
    %tmp79 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    %tmp80 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp79, i32 0, i32 0
    %tmp81 = load i8*, i8** %tmp80
    %tmp82 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    %tmp83 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp82, i32 0, i32 1
    %tmp84 = load i32, i32* %tmp83
    %tmp85 = bitcast i32 %tmp84 to i32
    call void @std_console.write(i8* %tmp81,i32 %tmp85)
    %tmp87 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    call void @vector.free(%struct.Vec* %tmp87)
    ret void

    unreachable
}

define i32 @c_str_len(i8* %str){
    %len = alloca i32
    %tmp0 = getelementptr inbounds i32, i32* %len, i32 0
    store i32 0, i32* %tmp0
    br label %loop_body19
loop_body19:
    %tmp2 = load i32, i32* %len
    %tmp3 = sext i32 %tmp2 to i64
    %tmp4 = getelementptr i8, i8* %str, i64 %tmp3
    %tmp5 = load i8, i8* %tmp4
    %tmp6 = icmp eq i8 %tmp5, 0
    br i1 %tmp6, label %then20, label %end_if20
then20:
    br label %loop_body19_exit
    br label %end_if20
end_if20:
    %tmp7 = getelementptr inbounds i32, i32* %len, i32 0
    %tmp8 = load i32, i32* %len
    %tmp9 = add i32 %tmp8, 1
    store i32 %tmp9, i32* %tmp7
    br label %loop_body19
loop_body19_exit:
    %tmp10 = load i32, i32* %len
    ret i32 %tmp10

    unreachable
}

define i32 @main(){
    %x = alloca i8*
    %tmp0 = getelementptr inbounds i8*, i8** %x, i32 0
    %tmp1 = getelementptr inbounds [48 x i8], ptr @.str1, i64 0, i64 0
    store i8* %tmp1, i8** %tmp0
    %y = alloca i8**
    %tmp2 = getelementptr inbounds i8**, i8*** %y, i32 0
    %tmp3 = getelementptr inbounds i8*, i8** %x, i32 0
    store i8** %tmp3, i8*** %tmp2
    %z = alloca i8***
    %tmp4 = getelementptr inbounds i8***, i8**** %z, i32 0
    %tmp5 = getelementptr inbounds i8**, i8*** %y, i32 0
    store i8*** %tmp5, i8**** %tmp4
    %tmp7 = load i8*, i8** %x
    %tmp8 = load i8, i8* %tmp7
    %tmp9 = sext i8 %tmp8 to i64
    call void @std_console.println_u64(i64 %tmp9)
    %tmp11 = load i8**, i8*** %y
    %tmp12 = load i8*, i8** %tmp11
    %tmp13 = load i8, i8* %tmp12
    %tmp14 = sext i8 %tmp13 to i64
    call void @std_console.println_u64(i64 %tmp14)
    %tmp16 = load i8***, i8**** %z
    %tmp17 = load i8**, i8*** %tmp16
    %tmp18 = load i8*, i8** %tmp17
    %tmp19 = load i8, i8* %tmp18
    %tmp20 = sext i8 %tmp19 to i64
    call void @std_console.println_u64(i64 %tmp20)
    %i = alloca i64
    %tmp21 = getelementptr inbounds i64, i64* %i, i32 0
    store i64 0, i64* %tmp21
    br label %loop_body21
loop_body21:
    %tmp22 = getelementptr inbounds i64, i64* %i, i32 0
    %tmp23 = load i64, i64* %i
    %tmp24 = add i64 %tmp23, 1
    store i64 %tmp24, i64* %tmp22
    %tmp25 = load i64, i64* %i
    %tmp26 = icmp sge i64 %tmp25, 15
    br i1 %tmp26, label %then22, label %end_if22
then22:
    br label %loop_body21_exit
    br label %end_if22
end_if22:
    br label %loop_body21
loop_body21_exit:
    call i32 @AllocConsole()
    %tmp29 = load i8*, i8** %x
    %tmp31 = load i8*, i8** %x
    %tmp32 = call i32 @c_str_len(i8* %tmp31)
    call void @std_console.write(i8* %tmp29,i32 %tmp32)
    %tmp34 = getelementptr inbounds [2 x i8], ptr @.str2, i64 0, i64 0
    %tmp35 = load i8, i8* %tmp34
    %tmp36 = sext i8 %tmp35 to i64
    call void @std_console.println_u64(i64 %tmp36)
    call void @std_console.println_u64(i64 -1)
    call void @std_console.println_i64(i64 -1)
    call void @std_console.println_u64(i64 1342)
    call void @std_console.println_u64(i64 777)
    call i32 @FreeConsole()
    %vec = alloca %struct.Vec
    %tmp43 = getelementptr inbounds %struct.Vec, %struct.Vec* %vec, i32 0
    call void @vector.new(%struct.Vec* %tmp43)
    %tmp45 = getelementptr inbounds %struct.Vec, %struct.Vec* %vec, i32 0
    call void @vector.push(%struct.Vec* %tmp45,i8 32)
    %tmp47 = getelementptr inbounds %struct.Vec, %struct.Vec* %vec, i32 0
    call void @vector.free(%struct.Vec* %tmp47)
    %list = alloca %struct.List
    %tmp49 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0
    call void @list.new(%struct.List* %tmp49)
    %tmp51 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0
    call void @list.extend(%struct.List* %tmp51,i32 64)
    %tmp53 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0
    call void @list.free(%struct.List* %tmp53)
    call i32 @wind()
    ret i32 0

    unreachable
}

define i64 @WindowProc(i8* %hWnd, i32 %uMsg, i64 %wParam, i64 %lParam){
    %WM_DESTROY = alloca i32
    %tmp0 = getelementptr inbounds i32, i32* %WM_DESTROY, i32 0
    store i32 2, i32* %tmp0
    %WM_CLOSE = alloca i32
    %tmp1 = getelementptr inbounds i32, i32* %WM_CLOSE, i32 0
    store i32 16, i32* %tmp1
    %tmp3 = load i32, i32* %WM_CLOSE
    %tmp4 = icmp eq i32 %uMsg, %tmp3
    br i1 %tmp4, label %then23, label %end_if23
then23:
    call void @PostQuitMessage(i32 0)
    ret i64 0
    br label %end_if23
end_if23:
    %tmp7 = load i32, i32* %WM_DESTROY
    %tmp8 = icmp eq i32 %uMsg, %tmp7
    br i1 %tmp8, label %then24, label %end_if24
then24:
    call void @PostQuitMessage(i32 0)
    ret i64 0
    br label %end_if24
end_if24:
    %tmp15 = call i64 @DefWindowProcA(i8* %hWnd,i32 %uMsg,i64 %wParam,i64 %lParam)
    ret i64 %tmp15

    unreachable
}

define i32 @wind(){
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
    %WM_DESTROY = alloca i32
    %tmp22 = getelementptr inbounds i32, i32* %WM_DESTROY, i32 0
    store i32 2, i32* %tmp22
    %WM_CLOSE = alloca i32
    %tmp23 = getelementptr inbounds i32, i32* %WM_CLOSE, i32 0
    store i32 16, i32* %tmp23
    %SW_SHOWNORMAL = alloca i32
    %tmp24 = getelementptr inbounds i32, i32* %SW_SHOWNORMAL, i32 0
    store i32 1, i32* %tmp24
    %hInstance = alloca i8*
    %tmp25 = getelementptr inbounds i8*, i8** %hInstance, i32 0
    %tmp27 = call i8* @GetModuleHandleA(i8* null)
    store i8* %tmp27, i8** %tmp25
    %tmp28 = load i8*, i8** %hInstance
    %tmp29 = icmp eq ptr %tmp28, null
    br i1 %tmp29, label %then25, label %end_if25
then25:
    ret i32 -1
    br label %end_if25
end_if25:
    %className = alloca i8*
    %tmp30 = getelementptr inbounds i8*, i8** %className, i32 0
    %tmp31 = getelementptr inbounds [14 x i8], ptr @.str3, i64 0, i64 0
    store i8* %tmp31, i8** %tmp30
    %wc = alloca %struct.WNDCLASSEXA
    %tmp32 = getelementptr inbounds %struct.WNDCLASSEXA, %struct.WNDCLASSEXA* %wc, i32 0
    %tmp33 = getelementptr inbounds %struct.WNDCLASSEXA, %struct.WNDCLASSEXA* %tmp32, i32 0, i32 0
    store i32 80, i32* %tmp33
    %tmp34 = getelementptr inbounds %struct.WNDCLASSEXA, %struct.WNDCLASSEXA* %wc, i32 0
    %tmp35 = getelementptr inbounds %struct.WNDCLASSEXA, %struct.WNDCLASSEXA* %tmp34, i32 0, i32 1
    %tmp36 = load i32, i32* %CS_HREDRAW
    %tmp37 = load i32, i32* %CS_VREDRAW
    %tmp38 = or i32 %tmp36, %tmp37
    store i32 %tmp38, i32* %tmp35
    %tmp39 = getelementptr inbounds %struct.WNDCLASSEXA, %struct.WNDCLASSEXA* %wc, i32 0
    %tmp40 = getelementptr inbounds %struct.WNDCLASSEXA, %struct.WNDCLASSEXA* %tmp39, i32 0, i32 2
    store i64 (i8*, i32, i64, i64)* @WindowProc, i64 (i8*, i32, i64, i64)** %tmp40
    %tmp42 = getelementptr inbounds %struct.WNDCLASSEXA, %struct.WNDCLASSEXA* %wc, i32 0
    %tmp43 = getelementptr inbounds %struct.WNDCLASSEXA, %struct.WNDCLASSEXA* %tmp42, i32 0, i32 3
    store i32 0, i32* %tmp43
    %tmp44 = getelementptr inbounds %struct.WNDCLASSEXA, %struct.WNDCLASSEXA* %wc, i32 0
    %tmp45 = getelementptr inbounds %struct.WNDCLASSEXA, %struct.WNDCLASSEXA* %tmp44, i32 0, i32 4
    store i32 0, i32* %tmp45
    %tmp46 = getelementptr inbounds %struct.WNDCLASSEXA, %struct.WNDCLASSEXA* %wc, i32 0
    %tmp47 = getelementptr inbounds %struct.WNDCLASSEXA, %struct.WNDCLASSEXA* %tmp46, i32 0, i32 5
    %tmp48 = load i8*, i8** %hInstance
    store i8* %tmp48, i8** %tmp47
    %tmp49 = getelementptr inbounds %struct.WNDCLASSEXA, %struct.WNDCLASSEXA* %wc, i32 0
    %tmp50 = getelementptr inbounds %struct.WNDCLASSEXA, %struct.WNDCLASSEXA* %tmp49, i32 0, i32 6
    store i8* null, i8** %tmp50
    %tmp51 = getelementptr inbounds %struct.WNDCLASSEXA, %struct.WNDCLASSEXA* %wc, i32 0
    %tmp52 = getelementptr inbounds %struct.WNDCLASSEXA, %struct.WNDCLASSEXA* %tmp51, i32 0, i32 7
    store i8* null, i8** %tmp52
    %tmp53 = getelementptr inbounds %struct.WNDCLASSEXA, %struct.WNDCLASSEXA* %wc, i32 0
    %tmp54 = getelementptr inbounds %struct.WNDCLASSEXA, %struct.WNDCLASSEXA* %tmp53, i32 0, i32 8
    %tmp55 = load i32, i32* %COLOR_WINDOW
    %tmp56 = add i32 %tmp55, 1
    %tmp57 = inttoptr i32 %tmp56 to i8*
    store i8* %tmp57, i8** %tmp54
    %tmp58 = getelementptr inbounds %struct.WNDCLASSEXA, %struct.WNDCLASSEXA* %wc, i32 0
    %tmp59 = getelementptr inbounds %struct.WNDCLASSEXA, %struct.WNDCLASSEXA* %tmp58, i32 0, i32 9
    store i8* null, i8** %tmp59
    %tmp60 = getelementptr inbounds %struct.WNDCLASSEXA, %struct.WNDCLASSEXA* %wc, i32 0
    %tmp61 = getelementptr inbounds %struct.WNDCLASSEXA, %struct.WNDCLASSEXA* %tmp60, i32 0, i32 10
    %tmp62 = load i8*, i8** %className
    store i8* %tmp62, i8** %tmp61
    %tmp63 = getelementptr inbounds %struct.WNDCLASSEXA, %struct.WNDCLASSEXA* %wc, i32 0
    %tmp64 = getelementptr inbounds %struct.WNDCLASSEXA, %struct.WNDCLASSEXA* %tmp63, i32 0, i32 11
    store i8* null, i8** %tmp64
    %tmp66 = getelementptr inbounds %struct.WNDCLASSEXA, %struct.WNDCLASSEXA* %wc, i32 0
    %tmp67 = call i16 @RegisterClassExA(%struct.WNDCLASSEXA* %tmp66)
    %tmp68 = icmp eq i16 %tmp67, 0
    br i1 %tmp68, label %then26, label %end_if26
then26:
    ret i32 -2
    br label %end_if26
end_if26:
    %windowTitle = alloca i8*
    %tmp69 = getelementptr inbounds i8*, i8** %windowTitle, i32 0
    %tmp70 = getelementptr inbounds [14 x i8], ptr @.str4, i64 0, i64 0
    store i8* %tmp70, i8** %tmp69
    %hWnd = alloca i8*
    %tmp71 = getelementptr inbounds i8*, i8** %hWnd, i32 0
    %tmp73 = load i8*, i8** %className
    %tmp74 = load i8*, i8** %windowTitle
    %tmp75 = load i32, i32* %WS_OVERLAPPEDWINDOW
    %tmp76 = load i32, i32* %CW_USEDEFAULT
    %tmp77 = load i32, i32* %CW_USEDEFAULT
    %tmp78 = load i8*, i8** %hInstance
    %tmp79 = call i8* @CreateWindowExA(i32 0,i8* %tmp73,i8* %tmp74,i32 %tmp75,i32 %tmp76,i32 %tmp77,i32 800,i32 600,i8* null,i8* null,i8* %tmp78,i8* null)
    store i8* %tmp79, i8** %tmp71
    %tmp80 = load i8*, i8** %hWnd
    %tmp81 = icmp eq ptr %tmp80, null
    br i1 %tmp81, label %then27, label %end_if27
then27:
    ret i32 -3
    br label %end_if27
end_if27:
    %tmp83 = load i8*, i8** %hWnd
    %tmp84 = load i32, i32* %SW_SHOWNORMAL
    call i32 @ShowWindow(i8* %tmp83,i32 %tmp84)
    %tmp86 = load i8*, i8** %hWnd
    call i32 @UpdateWindow(i8* %tmp86)
    %msg = alloca %struct.MSG
    br label %loop_body28
loop_body28:
    %result = alloca i32
    %tmp87 = getelementptr inbounds i32, i32* %result, i32 0
    %tmp89 = getelementptr inbounds %struct.MSG, %struct.MSG* %msg, i32 0
    %tmp90 = call i32 @GetMessageA(%struct.MSG* %tmp89,i8* null,i32 0,i32 0)
    store i32 %tmp90, i32* %tmp87
    %tmp91 = load i32, i32* %result
    %tmp92 = icmp sgt i32 %tmp91, 0
    br i1 %tmp92, label %then29, label %else29
then29:
    %tmp94 = getelementptr inbounds %struct.MSG, %struct.MSG* %msg, i32 0
    call i32 @TranslateMessage(%struct.MSG* %tmp94)
    %tmp96 = getelementptr inbounds %struct.MSG, %struct.MSG* %msg, i32 0
    call i64 @DispatchMessageA(%struct.MSG* %tmp96)
    br label %end_if29
else29:
    br label %loop_body28_exit
    br label %end_if29
end_if29:
    br label %loop_body28
loop_body28_exit:
    %tmp97 = getelementptr inbounds %struct.MSG, %struct.MSG* %msg, i32 0
    %tmp98 = getelementptr inbounds %struct.MSG, %struct.MSG* %tmp97, i32 0, i32 2
    %tmp99 = load i64, i64* %tmp98
    %tmp100 = trunc i64 %tmp99 to i32
    ret i32 %tmp100

    unreachable
}
