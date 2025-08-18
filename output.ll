%struct.Vec = type {i8*,i32,i32}
%struct.List = type {%struct.ListNode*,%struct.ListNode*,i32}
%struct.ListNode = type {%struct.ListNode*,i32}
declare dllimport i32* @GetProcessHeap()
declare dllimport i8* @HeapAlloc(i32*, i32, i64)
declare dllimport i32 @HeapFree(i32*, i32, i8*)
declare dllimport void @ExitProcess(i32)
declare dllimport i32 @AllocConsole()
declare dllimport i8* @GetStdHandle(i32)
declare dllimport i32 @FreeConsole()
declare dllimport i32 @MessageBoxA(i8*, i8*, i8*, i32)
declare dllimport i32 @WriteConsoleA(i8*, i8*, i32, i32*, i8*)
@.str24 = internal constant [48 x i8] c"Pee pee poo poo
 Waterfall 
 TORRONTO CENTRAL 
\00"
@.str27 = internal constant [2 x i8] c"0\00"


define void @__chkstk(){
    ret void

    unreachable
}

define i8* @get_stdout(){
    %stdout_handle = alloca i8*
    %tmp0 = getelementptr inbounds i8*, i8** %stdout_handle, i32 0
    %tmp2 = call i8* @GetStdHandle(i32 -11)
    store i8* %tmp2, i8** %tmp0
    %tmp3 = load i8*, i8** %stdout_handle
    %tmp4 = inttoptr i64 18446744073709551615 to i8*
    %tmp5 = icmp eq ptr %tmp3, %tmp4
    br i1 %tmp5, label %then0, label %end_if0
then0:
    call void @ExitProcess(i32 -1)
    br label %end_if0
end_if0:
    %tmp7 = load i8*, i8** %stdout_handle
    ret i8* %tmp7

    unreachable
}

define void @write(i8* %buffer, i32 %len){
    %chars_written = alloca i32
    %tmp2 = call i8* @get_stdout()
    %tmp5 = getelementptr inbounds i32, i32* %chars_written, i32 0
    call i32 @WriteConsoleA(i8* %tmp2,i8* %buffer,i32 %len,i32* %tmp5,i8* null)
    %tmp7 = load i32, i32* %chars_written
    %tmp8 = icmp ne i32 %len, %tmp7
    br i1 %tmp8, label %then1, label %end_if1
then1:
    call void @ExitProcess(i32 -2)
    br label %end_if1
end_if1:
    ret void

    unreachable
}

define i8* @malloc(i64 %size){
    %tmp2 = call i32* @GetProcessHeap()
    %tmp4 = call i8* @HeapAlloc(i32* %tmp2,i32 0,i64 %size)
    ret i8* %tmp4

    unreachable
}

define void @free(i8* %ptr){
    %tmp2 = call i32* @GetProcessHeap()
    call i32 @HeapFree(i32* %tmp2,i32 0,i8* %ptr)
    ret void

    unreachable
}

define void @new_list(%struct.List* %list){
    %tmp1 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0, i32 0
    store %struct.ListNode* null, %struct.ListNode** %tmp1
    %tmp3 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0, i32 1
    store %struct.ListNode* null, %struct.ListNode** %tmp3
    %tmp5 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0, i32 2
    store i32 0, i32* %tmp5
    ret void

    unreachable
}

define void @new_list_node(%struct.ListNode* %list){
    %tmp1 = getelementptr inbounds %struct.ListNode, %struct.ListNode* %list, i32 0, i32 0
    store %struct.ListNode* null, %struct.ListNode** %tmp1
    %tmp3 = getelementptr inbounds %struct.ListNode, %struct.ListNode* %list, i32 0, i32 1
    store i32 0, i32* %tmp3
    ret void

    unreachable
}

define void @extend(%struct.List* %list, i32 %data){
    %new_node = alloca %struct.ListNode*
    %tmp0 = getelementptr inbounds %struct.ListNode*, %struct.ListNode** %new_node, i32 0
    %tmp2 = call i8* @malloc(i64 12)
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
    br i1 %tmp12, label %then2, label %else2
then2:
    %tmp14 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0, i32 0
    %tmp15 = load %struct.ListNode*, %struct.ListNode** %new_node
    store %struct.ListNode* %tmp15, %struct.ListNode** %tmp14
    %tmp17 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0, i32 1
    %tmp18 = load %struct.ListNode*, %struct.ListNode** %new_node
    store %struct.ListNode* %tmp18, %struct.ListNode** %tmp17
    br label %end_if2
else2:
    %tmp20 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0, i32 1
    %tmp21 = getelementptr inbounds %struct.ListNode, %struct.ListNode* %tmp20, i32 0, i32 0
    %tmp22 = load %struct.ListNode*, %struct.ListNode** %new_node
    store %struct.ListNode* %tmp22, %struct.ListNode** %tmp21
    %tmp24 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0, i32 1
    %tmp25 = load %struct.ListNode*, %struct.ListNode** %new_node
    store %struct.ListNode* %tmp25, %struct.ListNode** %tmp24
    br label %end_if2
end_if2:
    %tmp27 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0, i32 2
    %tmp29 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0, i32 2
    %tmp30 = load i32, i32* %tmp29
    %tmp31 = add i32 %tmp30, 1
    store i32 %tmp31, i32* %tmp27
    ret void

    unreachable
}

define i32 @walk(%struct.List* %list){
    %l = alloca i32
    %tmp0 = getelementptr inbounds i32, i32* %l, i32 0
    store i32 0, i32* %tmp0
    %ptr = alloca %struct.ListNode*
    %tmp1 = getelementptr inbounds %struct.ListNode*, %struct.ListNode** %ptr, i32 0
    %tmp3 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0, i32 0
    %tmp4 = load %struct.ListNode*, %struct.ListNode** %tmp3
    store %struct.ListNode* %tmp4, %struct.ListNode** %tmp1
    br label %loop_body3
loop_body3:
    %tmp5 = load %struct.ListNode*, %struct.ListNode** %ptr
    %tmp6 = icmp eq ptr %tmp5, null
    br i1 %tmp6, label %then4, label %end_if4
then4:
    br label %loop_body3_exit
    br label %end_if4
end_if4:
    %tmp7 = getelementptr inbounds i32, i32* %l, i32 0
    %tmp8 = load i32, i32* %l
    %tmp9 = add i32 %tmp8, 1
    store i32 %tmp9, i32* %tmp7
    %tmp10 = getelementptr inbounds %struct.ListNode*, %struct.ListNode** %ptr, i32 0
    %tmp11 = getelementptr inbounds %struct.ListNode*, %struct.ListNode** %ptr, i32 0
    %tmp12 = getelementptr inbounds %struct.ListNode, %struct.ListNode* %tmp11, i32 0, i32 0
    %tmp13 = load %struct.ListNode*, %struct.ListNode** %tmp12
    store %struct.ListNode* %tmp13, %struct.ListNode** %tmp10
    br label %loop_body3
loop_body3_exit:
    %tmp14 = load i32, i32* %l
    ret i32 %tmp14

    unreachable
}

define void @free_list(%struct.List* %list){
    %current = alloca %struct.ListNode*
    %tmp0 = getelementptr inbounds %struct.ListNode*, %struct.ListNode** %current, i32 0
    %tmp2 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0, i32 0
    %tmp3 = load %struct.ListNode*, %struct.ListNode** %tmp2
    store %struct.ListNode* %tmp3, %struct.ListNode** %tmp0
    br label %loop_body5
loop_body5:
    %tmp4 = load %struct.ListNode*, %struct.ListNode** %current
    %tmp5 = icmp eq ptr %tmp4, null
    br i1 %tmp5, label %then6, label %end_if6
then6:
    br label %loop_body5_exit
    br label %end_if6
end_if6:
    %next = alloca %struct.ListNode*
    %tmp6 = getelementptr inbounds %struct.ListNode*, %struct.ListNode** %next, i32 0
    %tmp7 = getelementptr inbounds %struct.ListNode*, %struct.ListNode** %current, i32 0
    %tmp8 = getelementptr inbounds %struct.ListNode, %struct.ListNode* %tmp7, i32 0, i32 0
    %tmp9 = load %struct.ListNode*, %struct.ListNode** %tmp8
    store %struct.ListNode* %tmp9, %struct.ListNode** %tmp6
    %tmp11 = load %struct.ListNode*, %struct.ListNode** %current
    %tmp12 = bitcast %struct.ListNode* %tmp11 to i8*
    call void @free(i8* %tmp12)
    %tmp13 = getelementptr inbounds %struct.ListNode*, %struct.ListNode** %current, i32 0
    %tmp14 = load %struct.ListNode*, %struct.ListNode** %next
    store %struct.ListNode* %tmp14, %struct.ListNode** %tmp13
    br label %loop_body5
loop_body5_exit:
    %tmp16 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0, i32 0
    store %struct.ListNode* null, %struct.ListNode** %tmp16
    %tmp18 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0, i32 1
    store %struct.ListNode* null, %struct.ListNode** %tmp18
    %tmp20 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0, i32 2
    store i32 0, i32* %tmp20
    ret void

    unreachable
}

define void @new_vec(%struct.Vec* %vec){
    %tmp1 = getelementptr inbounds %struct.Vec, %struct.Vec* %vec, i32 0, i32 0
    store i8* null, i8** %tmp1
    %tmp3 = getelementptr inbounds %struct.Vec, %struct.Vec* %vec, i32 0, i32 1
    store i32 0, i32* %tmp3
    %tmp5 = getelementptr inbounds %struct.Vec, %struct.Vec* %vec, i32 0, i32 2
    store i32 0, i32* %tmp5
    ret void

    unreachable
}

define void @push(%struct.Vec* %vec, i8 %data){
    %tmp1 = getelementptr inbounds %struct.Vec, %struct.Vec* %vec, i32 0, i32 1
    %tmp2 = load i32, i32* %tmp1
    %tmp4 = getelementptr inbounds %struct.Vec, %struct.Vec* %vec, i32 0, i32 2
    %tmp5 = load i32, i32* %tmp4
    %tmp6 = icmp uge i32 %tmp2, %tmp5
    br i1 %tmp6, label %then7, label %end_if7
then7:
    %new_capacity = alloca i32
    %tmp7 = getelementptr inbounds i32, i32* %new_capacity, i32 0
    store i32 4, i32* %tmp7
    %tmp9 = getelementptr inbounds %struct.Vec, %struct.Vec* %vec, i32 0, i32 2
    %tmp10 = load i32, i32* %tmp9
    %tmp11 = icmp ne i32 %tmp10, 0
    br i1 %tmp11, label %then8, label %end_if8
then8:
    %tmp12 = getelementptr inbounds i32, i32* %new_capacity, i32 0
    %tmp14 = getelementptr inbounds %struct.Vec, %struct.Vec* %vec, i32 0, i32 2
    %tmp15 = load i32, i32* %tmp14
    %tmp16 = mul i32 %tmp15, 2
    store i32 %tmp16, i32* %tmp12
    br label %end_if8
end_if8:
    %new_array = alloca i8*
    %tmp17 = getelementptr inbounds i8*, i8** %new_array, i32 0
    %tmp19 = load i32, i32* %new_capacity
    %tmp20 = zext i32 %tmp19 to i64
    %tmp21 = mul i64 1, %tmp20
    %tmp22 = call i8* @malloc(i64 %tmp21)
    store i8* %tmp22, i8** %tmp17
    %tmp24 = getelementptr inbounds %struct.Vec, %struct.Vec* %vec, i32 0, i32 0
    %tmp25 = load i8*, i8** %tmp24
    %tmp26 = icmp ne ptr %tmp25, null
    br i1 %tmp26, label %then9, label %end_if9
then9:
    %i = alloca i32
    %tmp27 = getelementptr inbounds i32, i32* %i, i32 0
    store i32 0, i32* %tmp27
    br label %loop_body10
loop_body10:
    %tmp28 = load i32, i32* %i
    %tmp30 = getelementptr inbounds %struct.Vec, %struct.Vec* %vec, i32 0, i32 1
    %tmp31 = load i32, i32* %tmp30
    %tmp32 = icmp uge i32 %tmp28, %tmp31
    br i1 %tmp32, label %then11, label %end_if11
then11:
    br label %loop_body10_exit
    br label %end_if11
end_if11:
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
    br label %loop_body10
loop_body10_exit:
    %tmp49 = getelementptr inbounds %struct.Vec, %struct.Vec* %vec, i32 0, i32 0
    %tmp50 = load i8*, i8** %tmp49
    call void @free(i8* %tmp50)
    br label %end_if9
end_if9:
    %tmp52 = getelementptr inbounds %struct.Vec, %struct.Vec* %vec, i32 0, i32 0
    %tmp53 = load i8*, i8** %new_array
    store i8* %tmp53, i8** %tmp52
    %tmp55 = getelementptr inbounds %struct.Vec, %struct.Vec* %vec, i32 0, i32 2
    %tmp56 = load i32, i32* %new_capacity
    store i32 %tmp56, i32* %tmp55
    br label %end_if7
end_if7:
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

define void @free_vec(%struct.Vec* %vec){
    %tmp1 = getelementptr inbounds %struct.Vec, %struct.Vec* %vec, i32 0, i32 0
    %tmp2 = load i8*, i8** %tmp1
    %tmp3 = icmp ne ptr %tmp2, null
    br i1 %tmp3, label %then12, label %end_if12
then12:
    %tmp6 = getelementptr inbounds %struct.Vec, %struct.Vec* %vec, i32 0, i32 0
    %tmp7 = load i8*, i8** %tmp6
    call void @free(i8* %tmp7)
    br label %end_if12
end_if12:
    %tmp9 = getelementptr inbounds %struct.Vec, %struct.Vec* %vec, i32 0, i32 0
    store i8* null, i8** %tmp9
    %tmp11 = getelementptr inbounds %struct.Vec, %struct.Vec* %vec, i32 0, i32 1
    store i32 0, i32* %tmp11
    %tmp13 = getelementptr inbounds %struct.Vec, %struct.Vec* %vec, i32 0, i32 2
    store i32 0, i32* %tmp13
    ret void

    unreachable
}

define void @println_i32(i32 %n){
    %buffer = alloca %struct.Vec
    %tmp1 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    call void @new_vec(%struct.Vec* %tmp1)
    %tmp3 = icmp eq i32 %n, 0
    br i1 %tmp3, label %then13, label %end_if13
then13:
    %tmp5 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    call void @push(%struct.Vec* %tmp5,i8 48)
    %tmp7 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    call void @push(%struct.Vec* %tmp7,i8 10)
    %tmp9 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    %tmp10 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp9, i32 0, i32 0
    %tmp11 = load i8*, i8** %tmp10
    %tmp12 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    %tmp13 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp12, i32 0, i32 1
    %tmp14 = load i32, i32* %tmp13
    %tmp15 = bitcast i32 %tmp14 to i32
    call void @write(i8* %tmp11,i32 %tmp15)
    %tmp17 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    call void @free_vec(%struct.Vec* %tmp17)
    ret void
    br label %end_if13
end_if13:
    %mut_n = alloca i64
    %tmp18 = getelementptr inbounds i64, i64* %mut_n, i32 0
%tmp21 = add i32 %n , 0    %tmp20 = sext i32 %tmp21 to i64
    store i64 %tmp20, i64* %tmp18
    %is_negative = alloca i32
    %tmp22 = getelementptr inbounds i32, i32* %is_negative, i32 0
    store i32 0, i32* %tmp22
    %tmp23 = load i64, i64* %mut_n
    %tmp24 = icmp slt i64 %tmp23, 0
    br i1 %tmp24, label %then14, label %end_if14
then14:
    %tmp25 = getelementptr inbounds i32, i32* %is_negative, i32 0
    store i32 1, i32* %tmp25
    %tmp26 = getelementptr inbounds i64, i64* %mut_n, i32 0
    %tmp27 = load i64, i64* %mut_n
    %tmp28 = sub i64 0, %tmp27
    store i64 %tmp28, i64* %tmp26
    br label %end_if14
end_if14:
    br label %loop_body15
loop_body15:
    %tmp29 = load i64, i64* %mut_n
    %tmp30 = icmp eq i64 %tmp29, 0
    br i1 %tmp30, label %then16, label %end_if16
then16:
    br label %loop_body15_exit
    br label %end_if16
end_if16:
    %digit_char = alloca i8
    %tmp31 = getelementptr inbounds i8, i8* %digit_char, i32 0
    %tmp32 = load i64, i64* %mut_n
    %tmp33 = srem i64 %tmp32, 10
    %tmp34 = trunc i64 %tmp33 to i8
    %tmp35 = add i8 %tmp34, 48
    store i8 %tmp35, i8* %tmp31
    %tmp37 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    %tmp38 = load i8, i8* %digit_char
    call void @push(%struct.Vec* %tmp37,i8 %tmp38)
    %tmp39 = getelementptr inbounds i64, i64* %mut_n, i32 0
    %tmp40 = load i64, i64* %mut_n
    %tmp41 = sdiv i64 %tmp40, 10
    store i64 %tmp41, i64* %tmp39
    br label %loop_body15
loop_body15_exit:
    %tmp42 = load i32, i32* %is_negative
    %tmp43 = icmp ne i32 %tmp42, 0
    br i1 %tmp43, label %then17, label %end_if17
then17:
    %tmp45 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    call void @push(%struct.Vec* %tmp45,i8 45)
    br label %end_if17
end_if17:
    %i = alloca i32
    %tmp46 = getelementptr inbounds i32, i32* %i, i32 0
    store i32 0, i32* %tmp46
    %j = alloca i32
    %tmp47 = getelementptr inbounds i32, i32* %j, i32 0
    %tmp48 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    %tmp49 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp48, i32 0, i32 1
    %tmp50 = load i32, i32* %tmp49
    %tmp51 = sub i32 %tmp50, 1
    store i32 %tmp51, i32* %tmp47
    br label %loop_body18
loop_body18:
    %tmp52 = load i32, i32* %i
    %tmp53 = load i32, i32* %j
    %tmp54 = icmp uge i32 %tmp52, %tmp53
    br i1 %tmp54, label %then19, label %end_if19
then19:
    br label %loop_body18_exit
    br label %end_if19
end_if19:
    %temp = alloca i8
    %tmp55 = getelementptr inbounds i8, i8* %temp, i32 0
    %tmp56 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    %tmp57 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp56, i32 0, i32 0
    %tmp58 = load i8*, i8** %tmp57
    %tmp59 = load i32, i32* %i
    %tmp60 = zext i32 %tmp59 to i64
    %tmp61 = getelementptr i8, i8* %tmp58, i64 %tmp60
    %tmp62 = load i8, i8* %tmp61
    store i8 %tmp62, i8* %tmp55
    %tmp63 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    %tmp64 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp63, i32 0, i32 0
    %tmp65 = load i8*, i8** %tmp64
    %tmp66 = load i32, i32* %i
    %tmp67 = zext i32 %tmp66 to i64
    %tmp68 = getelementptr i8, i8* %tmp65, i64 %tmp67
    %tmp69 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    %tmp70 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp69, i32 0, i32 0
    %tmp71 = load i8*, i8** %tmp70
    %tmp72 = load i32, i32* %j
    %tmp73 = zext i32 %tmp72 to i64
    %tmp74 = getelementptr i8, i8* %tmp71, i64 %tmp73
    %tmp75 = load i8, i8* %tmp74
    store i8 %tmp75, i8* %tmp68
    %tmp76 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    %tmp77 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp76, i32 0, i32 0
    %tmp78 = load i8*, i8** %tmp77
    %tmp79 = load i32, i32* %j
    %tmp80 = zext i32 %tmp79 to i64
    %tmp81 = getelementptr i8, i8* %tmp78, i64 %tmp80
    %tmp82 = load i8, i8* %temp
    store i8 %tmp82, i8* %tmp81
    %tmp83 = getelementptr inbounds i32, i32* %i, i32 0
    %tmp84 = load i32, i32* %i
    %tmp85 = add i32 %tmp84, 1
    store i32 %tmp85, i32* %tmp83
    %tmp86 = getelementptr inbounds i32, i32* %j, i32 0
    %tmp87 = load i32, i32* %j
    %tmp88 = sub i32 %tmp87, 1
    store i32 %tmp88, i32* %tmp86
    br label %loop_body18
loop_body18_exit:
    %tmp90 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    call void @push(%struct.Vec* %tmp90,i8 10)
    %tmp92 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    %tmp93 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp92, i32 0, i32 0
    %tmp94 = load i8*, i8** %tmp93
    %tmp95 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    %tmp96 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp95, i32 0, i32 1
    %tmp97 = load i32, i32* %tmp96
    %tmp98 = bitcast i32 %tmp97 to i32
    call void @write(i8* %tmp94,i32 %tmp98)
    %tmp100 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    call void @free_vec(%struct.Vec* %tmp100)
    ret void

    unreachable
}

define i32 @c_str_len(i8* %str){
    %len = alloca i32
    %tmp0 = getelementptr inbounds i32, i32* %len, i32 0
    store i32 0, i32* %tmp0
    br label %loop_body20
loop_body20:
    %tmp2 = load i32, i32* %len
    %tmp3 = sext i32 %tmp2 to i64
    %tmp4 = getelementptr i8, i8* %str, i64 %tmp3
    %tmp5 = load i8, i8* %tmp4
    %tmp6 = icmp eq i8 %tmp5, 0
    br i1 %tmp6, label %then21, label %end_if21
then21:
    br label %loop_body20_exit
    br label %end_if21
end_if21:
    %tmp7 = getelementptr inbounds i32, i32* %len, i32 0
    %tmp8 = load i32, i32* %len
    %tmp9 = add i32 %tmp8, 1
    store i32 %tmp9, i32* %tmp7
    br label %loop_body20
loop_body20_exit:
    %tmp10 = load i32, i32* %len
    ret i32 %tmp10

    unreachable
}

define i64 @triple_factorial(i64 %x){
    %tmp1 = icmp slt i64 %x, 0
    br i1 %tmp1, label %then22, label %end_if22
then22:
    ret i64 0
    br label %end_if22
end_if22:
    %tmp3 = icmp sle i64 %x, 3
    br i1 %tmp3, label %then23, label %end_if23
then23:
    ret i64 1
    br label %end_if23
end_if23:
    %tmp7 = sub i64 %x, 3
    %tmp8 = call i64 @triple_factorial(i64 %tmp7)
    %tmp9 = mul i64 %x, %tmp8
    ret i64 %tmp9

    unreachable
}

define i32 @main(){
    %x = alloca i8*
    %tmp0 = getelementptr inbounds i8*, i8** %x, i32 0
    %tmp1 = getelementptr inbounds [48 x i8], ptr @.str24, i64 0, i64 0
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
    %tmp9 = sext i8 %tmp8 to i32
    call void @println_i32(i32 %tmp9)
    %tmp11 = load i8**, i8*** %y
    %tmp12 = load i8*, i8** %tmp11
    %tmp13 = load i8, i8* %tmp12
    %tmp14 = sext i8 %tmp13 to i32
    call void @println_i32(i32 %tmp14)
    %tmp16 = load i8***, i8**** %z
    %tmp17 = load i8**, i8*** %tmp16
    %tmp18 = load i8*, i8** %tmp17
    %tmp19 = load i8, i8* %tmp18
    %tmp20 = sext i8 %tmp19 to i32
    call void @println_i32(i32 %tmp20)
    %i = alloca i64
    %tmp21 = getelementptr inbounds i64, i64* %i, i32 0
    store i64 0, i64* %tmp21
    br label %loop_body25
loop_body25:
    %tmp24 = load i64, i64* %i
    %tmp25 = call i64 @triple_factorial(i64 %tmp24)
    %tmp26 = trunc i64 %tmp25 to i32
    call void @println_i32(i32 %tmp26)
    %tmp27 = getelementptr inbounds i64, i64* %i, i32 0
    %tmp28 = load i64, i64* %i
    %tmp29 = add i64 %tmp28, 1
    store i64 %tmp29, i64* %tmp27
    %tmp30 = load i64, i64* %i
    %tmp31 = icmp sge i64 %tmp30, 15
    br i1 %tmp31, label %then26, label %end_if26
then26:
    br label %loop_body25_exit
    br label %end_if26
end_if26:
    br label %loop_body25
loop_body25_exit:
    call i32 @AllocConsole()
    %tmp34 = load i8*, i8** %x
    %tmp36 = load i8*, i8** %x
    %tmp37 = call i32 @c_str_len(i8* %tmp36)
    call void @write(i8* %tmp34,i32 %tmp37)
    %tmp39 = getelementptr inbounds [2 x i8], ptr @.str27, i64 0, i64 0
    %tmp40 = load i8, i8* %tmp39
    %tmp41 = sext i8 %tmp40 to i32
    call void @println_i32(i32 %tmp41)
    call void @println_i32(i32 -1432)
    call void @println_i32(i32 1342)
    call void @println_i32(i32 777)
    call i32 @FreeConsole()
    %buffer = alloca %struct.Vec
    %tmp47 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    call void @new_vec(%struct.Vec* %tmp47)
    %tmp49 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    call void @push(%struct.Vec* %tmp49,i8 32)
    %tmp51 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    call void @free_vec(%struct.Vec* %tmp51)
    %list = alloca %struct.List
    %tmp53 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0
    call void @new_list(%struct.List* %tmp53)
    %tmp55 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0
    call void @extend(%struct.List* %tmp55,i32 64)
    %tmp57 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0
    call void @free_list(%struct.List* %tmp57)
    ret i32 0

    unreachable
}
