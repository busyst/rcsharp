%struct.List = type {%struct.ListNode*,%struct.ListNode*,i32}
%struct.ListNode = type {%struct.ListNode*,i32}
%struct.Vec = type {i8*,i32,i32}
declare dllimport i32* @GetProcessHeap()
declare dllimport i8* @HeapAlloc(i32*, i32, i64)
declare dllimport i32 @HeapFree(i32*, i32, i8*)
declare dllimport void @ExitProcess(i32)
declare dllimport i32 @AllocConsole()
declare dllimport i8* @GetStdHandle(i32)
declare dllimport i32 @FreeConsole()
declare dllimport i32 @MessageBoxA(i8*, i8*, i8*, i32)
declare dllimport i32 @WriteConsoleA(i8*, i8*, i32, i32*, i8*)

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
    %buffer.addr = alloca i8*
    store i8* %buffer, i8** %buffer.addr
    %len.addr = alloca i32
    store i32 %len, i32* %len.addr
    %chars_written = alloca i32
    %tmp2 = call i8* @get_stdout()
    %tmp3 = load i8*, i8** %buffer.addr
    %tmp4 = load i32, i32* %len.addr
    %tmp5 = getelementptr inbounds i32, i32* %chars_written, i32 0
    call i32 @WriteConsoleA(i8* %tmp2,i8* %tmp3,i32 %tmp4,i32* %tmp5,i8* null)
    ret void

    unreachable
}

define i8* @malloc(i64 %size){
    %size.addr = alloca i64
    store i64 %size, i64* %size.addr
    %tmp2 = call i32* @GetProcessHeap()
    %tmp3 = load i64, i64* %size.addr
    %tmp4 = call i8* @HeapAlloc(i32* %tmp2,i32 0,i64 %tmp3)
    ret i8* %tmp4

    unreachable
}

define void @free(i8* %ptr){
    %ptr.addr = alloca i8*
    store i8* %ptr, i8** %ptr.addr
    %tmp2 = call i32* @GetProcessHeap()
    %tmp3 = load i8*, i8** %ptr.addr
    call i32 @HeapFree(i32* %tmp2,i32 0,i8* %tmp3)
    ret void

    unreachable
}

define void @new_list(%struct.List* %list){
    %list.addr = alloca %struct.List*
    store %struct.List* %list, %struct.List** %list.addr
    %tmp0 = getelementptr inbounds %struct.List*, %struct.List** %list.addr, i32 0
    %tmp1 = load %struct.List*, %struct.List** %tmp0
    %tmp2 = getelementptr inbounds %struct.List, %struct.List* %tmp1, i32 0, i32 0
    store %struct.ListNode* null, %struct.ListNode** %tmp2
    %tmp3 = getelementptr inbounds %struct.List*, %struct.List** %list.addr, i32 0
    %tmp4 = load %struct.List*, %struct.List** %tmp3
    %tmp5 = getelementptr inbounds %struct.List, %struct.List* %tmp4, i32 0, i32 1
    store %struct.ListNode* null, %struct.ListNode** %tmp5
    %tmp6 = getelementptr inbounds %struct.List*, %struct.List** %list.addr, i32 0
    %tmp7 = load %struct.List*, %struct.List** %tmp6
    %tmp8 = getelementptr inbounds %struct.List, %struct.List* %tmp7, i32 0, i32 2
    store i32 0, i32* %tmp8
    ret void

    unreachable
}

define void @new_list_node(%struct.ListNode* %list){
    %list.addr = alloca %struct.ListNode*
    store %struct.ListNode* %list, %struct.ListNode** %list.addr
    %tmp0 = getelementptr inbounds %struct.ListNode*, %struct.ListNode** %list.addr, i32 0
    %tmp1 = load %struct.ListNode*, %struct.ListNode** %tmp0
    %tmp2 = getelementptr inbounds %struct.ListNode, %struct.ListNode* %tmp1, i32 0, i32 0
    store %struct.ListNode* null, %struct.ListNode** %tmp2
    %tmp3 = getelementptr inbounds %struct.ListNode*, %struct.ListNode** %list.addr, i32 0
    %tmp4 = load %struct.ListNode*, %struct.ListNode** %tmp3
    %tmp5 = getelementptr inbounds %struct.ListNode, %struct.ListNode* %tmp4, i32 0, i32 1
    store i32 0, i32* %tmp5
    ret void

    unreachable
}

define void @extend(%struct.List* %list, i32 %data){
    %list.addr = alloca %struct.List*
    store %struct.List* %list, %struct.List** %list.addr
    %data.addr = alloca i32
    store i32 %data, i32* %data.addr
    %new_node = alloca %struct.ListNode*
    %tmp0 = getelementptr inbounds %struct.ListNode*, %struct.ListNode** %new_node, i32 0
    %tmp2 = call i8* @malloc(i64 12)
    %tmp3 = bitcast i8* %tmp2 to %struct.ListNode*
    store %struct.ListNode* %tmp3, %struct.ListNode** %tmp0
    %tmp4 = getelementptr inbounds %struct.ListNode*, %struct.ListNode** %new_node, i32 0
    %tmp5 = load %struct.ListNode*, %struct.ListNode** %tmp4
    %tmp6 = getelementptr inbounds %struct.ListNode, %struct.ListNode* %tmp5, i32 0, i32 0
    store %struct.ListNode* null, %struct.ListNode** %tmp6
    %tmp7 = getelementptr inbounds %struct.ListNode*, %struct.ListNode** %new_node, i32 0
    %tmp8 = load %struct.ListNode*, %struct.ListNode** %tmp7
    %tmp9 = getelementptr inbounds %struct.ListNode, %struct.ListNode* %tmp8, i32 0, i32 1
    %tmp10 = load i32, i32* %data.addr
    store i32 %tmp10, i32* %tmp9
    %tmp11 = getelementptr inbounds %struct.List*, %struct.List** %list.addr, i32 0
    %tmp12 = load %struct.List*, %struct.List** %tmp11
    %tmp13 = getelementptr inbounds %struct.List, %struct.List* %tmp12, i32 0, i32 0
    %tmp14 = load %struct.ListNode*, %struct.ListNode** %tmp13
    %tmp15 = icmp eq ptr %tmp14, null
    br i1 %tmp15, label %then1, label %else1
then1:
    %tmp16 = getelementptr inbounds %struct.List*, %struct.List** %list.addr, i32 0
    %tmp17 = load %struct.List*, %struct.List** %tmp16
    %tmp18 = getelementptr inbounds %struct.List, %struct.List* %tmp17, i32 0, i32 0
    %tmp19 = load %struct.ListNode*, %struct.ListNode** %new_node
    store %struct.ListNode* %tmp19, %struct.ListNode** %tmp18
    %tmp20 = getelementptr inbounds %struct.List*, %struct.List** %list.addr, i32 0
    %tmp21 = load %struct.List*, %struct.List** %tmp20
    %tmp22 = getelementptr inbounds %struct.List, %struct.List* %tmp21, i32 0, i32 1
    %tmp23 = load %struct.ListNode*, %struct.ListNode** %new_node
    store %struct.ListNode* %tmp23, %struct.ListNode** %tmp22
    br label %end_if1
else1:
    %tmp24 = getelementptr inbounds %struct.List*, %struct.List** %list.addr, i32 0
    %tmp25 = load %struct.List*, %struct.List** %tmp24
    %tmp26 = getelementptr inbounds %struct.List, %struct.List* %tmp25, i32 0, i32 1
    %tmp27 = load %struct.ListNode*, %struct.ListNode** %tmp26
    %tmp28 = getelementptr inbounds %struct.ListNode, %struct.ListNode* %tmp27, i32 0, i32 0
    %tmp29 = load %struct.ListNode*, %struct.ListNode** %new_node
    store %struct.ListNode* %tmp29, %struct.ListNode** %tmp28
    %tmp30 = getelementptr inbounds %struct.List*, %struct.List** %list.addr, i32 0
    %tmp31 = load %struct.List*, %struct.List** %tmp30
    %tmp32 = getelementptr inbounds %struct.List, %struct.List* %tmp31, i32 0, i32 1
    %tmp33 = load %struct.ListNode*, %struct.ListNode** %new_node
    store %struct.ListNode* %tmp33, %struct.ListNode** %tmp32
    br label %end_if1
end_if1:
    %tmp34 = getelementptr inbounds %struct.List*, %struct.List** %list.addr, i32 0
    %tmp35 = load %struct.List*, %struct.List** %tmp34
    %tmp36 = getelementptr inbounds %struct.List, %struct.List* %tmp35, i32 0, i32 2
    %tmp37 = getelementptr inbounds %struct.List*, %struct.List** %list.addr, i32 0
    %tmp38 = load %struct.List*, %struct.List** %tmp37
    %tmp39 = getelementptr inbounds %struct.List, %struct.List* %tmp38, i32 0, i32 2
    %tmp40 = load i32, i32* %tmp39
    %tmp41 = add i32 %tmp40, 1
    store i32 %tmp41, i32* %tmp36
    ret void

    unreachable
}

define i32 @walk(%struct.List* %list){
    %list.addr = alloca %struct.List*
    store %struct.List* %list, %struct.List** %list.addr
    %l = alloca i32
    %tmp0 = getelementptr inbounds i32, i32* %l, i32 0
    store i32 0, i32* %tmp0
    %ptr = alloca %struct.ListNode*
    %tmp1 = getelementptr inbounds %struct.ListNode*, %struct.ListNode** %ptr, i32 0
    %tmp2 = getelementptr inbounds %struct.List*, %struct.List** %list.addr, i32 0
    %tmp3 = load %struct.List*, %struct.List** %tmp2
    %tmp4 = getelementptr inbounds %struct.List, %struct.List* %tmp3, i32 0, i32 0
    %tmp5 = load %struct.ListNode*, %struct.ListNode** %tmp4
    store %struct.ListNode* %tmp5, %struct.ListNode** %tmp1
    br label %loop_body2
loop_body2:
    %tmp6 = load %struct.ListNode*, %struct.ListNode** %ptr
    %tmp7 = icmp eq ptr %tmp6, null
    br i1 %tmp7, label %then3, label %end_if3
then3:
    br label %loop_body2_exit
    br label %end_if3
end_if3:
    %tmp8 = getelementptr inbounds i32, i32* %l, i32 0
    %tmp9 = load i32, i32* %l
    %tmp10 = add i32 %tmp9, 1
    store i32 %tmp10, i32* %tmp8
    %tmp11 = getelementptr inbounds %struct.ListNode*, %struct.ListNode** %ptr, i32 0
    %tmp12 = getelementptr inbounds %struct.ListNode*, %struct.ListNode** %ptr, i32 0
    %tmp13 = load %struct.ListNode*, %struct.ListNode** %tmp12
    %tmp14 = getelementptr inbounds %struct.ListNode, %struct.ListNode* %tmp13, i32 0, i32 0
    %tmp15 = load %struct.ListNode*, %struct.ListNode** %tmp14
    store %struct.ListNode* %tmp15, %struct.ListNode** %tmp11
    br label %loop_body2
loop_body2_exit:
    %tmp16 = load i32, i32* %l
    ret i32 %tmp16

    unreachable
}

define void @free_list(%struct.List* %list){
    %list.addr = alloca %struct.List*
    store %struct.List* %list, %struct.List** %list.addr
    %current = alloca %struct.ListNode*
    %tmp0 = getelementptr inbounds %struct.ListNode*, %struct.ListNode** %current, i32 0
    %tmp1 = getelementptr inbounds %struct.List*, %struct.List** %list.addr, i32 0
    %tmp2 = load %struct.List*, %struct.List** %tmp1
    %tmp3 = getelementptr inbounds %struct.List, %struct.List* %tmp2, i32 0, i32 0
    %tmp4 = load %struct.ListNode*, %struct.ListNode** %tmp3
    store %struct.ListNode* %tmp4, %struct.ListNode** %tmp0
    br label %loop_body4
loop_body4:
    %tmp5 = load %struct.ListNode*, %struct.ListNode** %current
    %tmp6 = icmp eq ptr %tmp5, null
    br i1 %tmp6, label %then5, label %end_if5
then5:
    br label %loop_body4_exit
    br label %end_if5
end_if5:
    %next = alloca %struct.ListNode*
    %tmp7 = getelementptr inbounds %struct.ListNode*, %struct.ListNode** %next, i32 0
    %tmp8 = getelementptr inbounds %struct.ListNode*, %struct.ListNode** %current, i32 0
    %tmp9 = load %struct.ListNode*, %struct.ListNode** %tmp8
    %tmp10 = getelementptr inbounds %struct.ListNode, %struct.ListNode* %tmp9, i32 0, i32 0
    %tmp11 = load %struct.ListNode*, %struct.ListNode** %tmp10
    store %struct.ListNode* %tmp11, %struct.ListNode** %tmp7
    %tmp13 = load %struct.ListNode*, %struct.ListNode** %current
    %tmp14 = bitcast %struct.ListNode* %tmp13 to i8*
    call void @free(i8* %tmp14)
    %tmp15 = getelementptr inbounds %struct.ListNode*, %struct.ListNode** %current, i32 0
    %tmp16 = load %struct.ListNode*, %struct.ListNode** %next
    store %struct.ListNode* %tmp16, %struct.ListNode** %tmp15
    br label %loop_body4
loop_body4_exit:
    %tmp17 = getelementptr inbounds %struct.List*, %struct.List** %list.addr, i32 0
    %tmp18 = load %struct.List*, %struct.List** %tmp17
    %tmp19 = getelementptr inbounds %struct.List, %struct.List* %tmp18, i32 0, i32 0
    store %struct.ListNode* null, %struct.ListNode** %tmp19
    %tmp20 = getelementptr inbounds %struct.List*, %struct.List** %list.addr, i32 0
    %tmp21 = load %struct.List*, %struct.List** %tmp20
    %tmp22 = getelementptr inbounds %struct.List, %struct.List* %tmp21, i32 0, i32 1
    store %struct.ListNode* null, %struct.ListNode** %tmp22
    %tmp23 = getelementptr inbounds %struct.List*, %struct.List** %list.addr, i32 0
    %tmp24 = load %struct.List*, %struct.List** %tmp23
    %tmp25 = getelementptr inbounds %struct.List, %struct.List* %tmp24, i32 0, i32 2
    store i32 0, i32* %tmp25
    ret void

    unreachable
}

define void @new_vec(%struct.Vec* %vec){
    %vec.addr = alloca %struct.Vec*
    store %struct.Vec* %vec, %struct.Vec** %vec.addr
    %tmp0 = getelementptr inbounds %struct.Vec*, %struct.Vec** %vec.addr, i32 0
    %tmp1 = load %struct.Vec*, %struct.Vec** %tmp0
    %tmp2 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp1, i32 0, i32 0
    store i8* null, i8** %tmp2
    %tmp3 = getelementptr inbounds %struct.Vec*, %struct.Vec** %vec.addr, i32 0
    %tmp4 = load %struct.Vec*, %struct.Vec** %tmp3
    %tmp5 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp4, i32 0, i32 1
    store i32 0, i32* %tmp5
    %tmp6 = getelementptr inbounds %struct.Vec*, %struct.Vec** %vec.addr, i32 0
    %tmp7 = load %struct.Vec*, %struct.Vec** %tmp6
    %tmp8 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp7, i32 0, i32 2
    store i32 0, i32* %tmp8
    ret void

    unreachable
}

define void @push(%struct.Vec* %vec, i8 %data){
    %vec.addr = alloca %struct.Vec*
    store %struct.Vec* %vec, %struct.Vec** %vec.addr
    %data.addr = alloca i8
    store i8 %data, i8* %data.addr
    %tmp0 = getelementptr inbounds %struct.Vec*, %struct.Vec** %vec.addr, i32 0
    %tmp1 = load %struct.Vec*, %struct.Vec** %tmp0
    %tmp2 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp1, i32 0, i32 1
    %tmp3 = load i32, i32* %tmp2
    %tmp4 = getelementptr inbounds %struct.Vec*, %struct.Vec** %vec.addr, i32 0
    %tmp5 = load %struct.Vec*, %struct.Vec** %tmp4
    %tmp6 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp5, i32 0, i32 2
    %tmp7 = load i32, i32* %tmp6
    %tmp8 = icmp uge i32 %tmp3, %tmp7
    br i1 %tmp8, label %then6, label %end_if6
then6:
    %new_capacity = alloca i32
    %tmp9 = getelementptr inbounds i32, i32* %new_capacity, i32 0
    store i32 4, i32* %tmp9
    %tmp10 = getelementptr inbounds %struct.Vec*, %struct.Vec** %vec.addr, i32 0
    %tmp11 = load %struct.Vec*, %struct.Vec** %tmp10
    %tmp12 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp11, i32 0, i32 2
    %tmp13 = load i32, i32* %tmp12
    %tmp14 = icmp ne i32 %tmp13, 0
    br i1 %tmp14, label %then7, label %end_if7
then7:
    %tmp15 = getelementptr inbounds i32, i32* %new_capacity, i32 0
    %tmp16 = getelementptr inbounds %struct.Vec*, %struct.Vec** %vec.addr, i32 0
    %tmp17 = load %struct.Vec*, %struct.Vec** %tmp16
    %tmp18 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp17, i32 0, i32 2
    %tmp19 = load i32, i32* %tmp18
    %tmp20 = mul i32 %tmp19, 2
    store i32 %tmp20, i32* %tmp15
    br label %end_if7
end_if7:
    %new_array = alloca i8*
    %tmp21 = getelementptr inbounds i8*, i8** %new_array, i32 0
    %tmp23 = load i32, i32* %new_capacity
    %tmp24 = zext i32 %tmp23 to i64
    %tmp25 = mul i64 1, %tmp24
    %tmp26 = call i8* @malloc(i64 %tmp25)
    store i8* %tmp26, i8** %tmp21
    %tmp27 = getelementptr inbounds %struct.Vec*, %struct.Vec** %vec.addr, i32 0
    %tmp28 = load %struct.Vec*, %struct.Vec** %tmp27
    %tmp29 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp28, i32 0, i32 0
    %tmp30 = load i8*, i8** %tmp29
    %tmp31 = icmp ne ptr %tmp30, null
    br i1 %tmp31, label %then8, label %end_if8
then8:
    %i = alloca i32
    %tmp32 = getelementptr inbounds i32, i32* %i, i32 0
    store i32 0, i32* %tmp32
    br label %loop_body9
loop_body9:
    %tmp33 = load i32, i32* %i
    %tmp34 = getelementptr inbounds %struct.Vec*, %struct.Vec** %vec.addr, i32 0
    %tmp35 = load %struct.Vec*, %struct.Vec** %tmp34
    %tmp36 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp35, i32 0, i32 1
    %tmp37 = load i32, i32* %tmp36
    %tmp38 = icmp uge i32 %tmp33, %tmp37
    br i1 %tmp38, label %then10, label %end_if10
then10:
    br label %loop_body9_exit
    br label %end_if10
end_if10:
    %tmp39 = load i8*, i8** %new_array
    %tmp40 = load i32, i32* %i
    %tmp41 = zext i32 %tmp40 to i64
    %tmp42 = getelementptr i8, i8* %tmp39, i64 %tmp41
    %tmp43 = getelementptr inbounds %struct.Vec*, %struct.Vec** %vec.addr, i32 0
    %tmp44 = load %struct.Vec*, %struct.Vec** %tmp43
    %tmp45 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp44, i32 0, i32 0
    %tmp46 = load i8*, i8** %tmp45
    %tmp47 = load i32, i32* %i
    %tmp48 = zext i32 %tmp47 to i64
    %tmp49 = getelementptr i8, i8* %tmp46, i64 %tmp48
    %tmp50 = load i8, i8* %tmp49
    store i8 %tmp50, i8* %tmp42
    %tmp51 = getelementptr inbounds i32, i32* %i, i32 0
    %tmp52 = load i32, i32* %i
    %tmp53 = add i32 %tmp52, 1
    store i32 %tmp53, i32* %tmp51
    br label %loop_body9
loop_body9_exit:
    %tmp55 = getelementptr inbounds %struct.Vec*, %struct.Vec** %vec.addr, i32 0
    %tmp56 = load %struct.Vec*, %struct.Vec** %tmp55
    %tmp57 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp56, i32 0, i32 0
    %tmp58 = load i8*, i8** %tmp57
    call void @free(i8* %tmp58)
    br label %end_if8
end_if8:
    %tmp59 = getelementptr inbounds %struct.Vec*, %struct.Vec** %vec.addr, i32 0
    %tmp60 = load %struct.Vec*, %struct.Vec** %tmp59
    %tmp61 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp60, i32 0, i32 0
    %tmp62 = load i8*, i8** %new_array
    store i8* %tmp62, i8** %tmp61
    %tmp63 = getelementptr inbounds %struct.Vec*, %struct.Vec** %vec.addr, i32 0
    %tmp64 = load %struct.Vec*, %struct.Vec** %tmp63
    %tmp65 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp64, i32 0, i32 2
    %tmp66 = load i32, i32* %new_capacity
    store i32 %tmp66, i32* %tmp65
    br label %end_if6
end_if6:
    %tmp67 = getelementptr inbounds %struct.Vec*, %struct.Vec** %vec.addr, i32 0
    %tmp68 = load %struct.Vec*, %struct.Vec** %tmp67
    %tmp69 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp68, i32 0, i32 0
    %tmp70 = load i8*, i8** %tmp69
    %tmp71 = getelementptr inbounds %struct.Vec*, %struct.Vec** %vec.addr, i32 0
    %tmp72 = load %struct.Vec*, %struct.Vec** %tmp71
    %tmp73 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp72, i32 0, i32 1
    %tmp74 = load i32, i32* %tmp73
    %tmp75 = zext i32 %tmp74 to i64
    %tmp76 = getelementptr i8, i8* %tmp70, i64 %tmp75
    %tmp77 = load i8, i8* %data.addr
    store i8 %tmp77, i8* %tmp76
    %tmp78 = getelementptr inbounds %struct.Vec*, %struct.Vec** %vec.addr, i32 0
    %tmp79 = load %struct.Vec*, %struct.Vec** %tmp78
    %tmp80 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp79, i32 0, i32 1
    %tmp81 = getelementptr inbounds %struct.Vec*, %struct.Vec** %vec.addr, i32 0
    %tmp82 = load %struct.Vec*, %struct.Vec** %tmp81
    %tmp83 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp82, i32 0, i32 1
    %tmp84 = load i32, i32* %tmp83
    %tmp85 = add i32 %tmp84, 1
    store i32 %tmp85, i32* %tmp80
    ret void

    unreachable
}

define void @free_vec(%struct.Vec* %vec){
    %vec.addr = alloca %struct.Vec*
    store %struct.Vec* %vec, %struct.Vec** %vec.addr
    %tmp0 = getelementptr inbounds %struct.Vec*, %struct.Vec** %vec.addr, i32 0
    %tmp1 = load %struct.Vec*, %struct.Vec** %tmp0
    %tmp2 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp1, i32 0, i32 0
    %tmp3 = load i8*, i8** %tmp2
    %tmp4 = icmp ne ptr %tmp3, null
    br i1 %tmp4, label %then11, label %end_if11
then11:
    %tmp6 = getelementptr inbounds %struct.Vec*, %struct.Vec** %vec.addr, i32 0
    %tmp7 = load %struct.Vec*, %struct.Vec** %tmp6
    %tmp8 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp7, i32 0, i32 0
    %tmp9 = load i8*, i8** %tmp8
    call void @free(i8* %tmp9)
    br label %end_if11
end_if11:
    %tmp10 = getelementptr inbounds %struct.Vec*, %struct.Vec** %vec.addr, i32 0
    %tmp11 = load %struct.Vec*, %struct.Vec** %tmp10
    %tmp12 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp11, i32 0, i32 0
    store i8* null, i8** %tmp12
    %tmp13 = getelementptr inbounds %struct.Vec*, %struct.Vec** %vec.addr, i32 0
    %tmp14 = load %struct.Vec*, %struct.Vec** %tmp13
    %tmp15 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp14, i32 0, i32 1
    store i32 0, i32* %tmp15
    %tmp16 = getelementptr inbounds %struct.Vec*, %struct.Vec** %vec.addr, i32 0
    %tmp17 = load %struct.Vec*, %struct.Vec** %tmp16
    %tmp18 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp17, i32 0, i32 2
    store i32 0, i32* %tmp18
    ret void

    unreachable
}

define void @println_i32(i32 %n){
    %n.addr = alloca i32
    store i32 %n, i32* %n.addr
    %buffer = alloca %struct.Vec
    %tmp1 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    call void @new_vec(%struct.Vec* %tmp1)
    %tmp2 = load i32, i32* %n.addr
    %tmp3 = icmp eq i32 %tmp2, 0
    br i1 %tmp3, label %then12, label %end_if12
then12:
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
    br label %end_if12
end_if12:
    %mut_n = alloca i64
    %tmp18 = getelementptr inbounds i64, i64* %mut_n, i32 0
    %tmp19 = load i32, i32* %n.addr
    %tmp20 = sext i32 %tmp19 to i64
    store i64 %tmp20, i64* %tmp18
    %is_negative = alloca i32
    %tmp21 = getelementptr inbounds i32, i32* %is_negative, i32 0
    store i32 0, i32* %tmp21
    %tmp22 = load i64, i64* %mut_n
    %tmp23 = icmp slt i64 %tmp22, 0
    br i1 %tmp23, label %then13, label %end_if13
then13:
    %tmp24 = getelementptr inbounds i32, i32* %is_negative, i32 0
    store i32 1, i32* %tmp24
    %tmp25 = getelementptr inbounds i64, i64* %mut_n, i32 0
    %tmp26 = load i64, i64* %mut_n
    %tmp27 = sub i64 0, %tmp26
    store i64 %tmp27, i64* %tmp25
    br label %end_if13
end_if13:
    br label %loop_body14
loop_body14:
    %tmp28 = load i64, i64* %mut_n
    %tmp29 = icmp eq i64 %tmp28, 0
    br i1 %tmp29, label %then15, label %end_if15
then15:
    br label %loop_body14_exit
    br label %end_if15
end_if15:
    %digit_char = alloca i8
    %tmp30 = getelementptr inbounds i8, i8* %digit_char, i32 0
    %tmp31 = load i64, i64* %mut_n
    %tmp32 = srem i64 %tmp31, 10
    %tmp33 = trunc i64 %tmp32 to i8
    %tmp34 = add i8 %tmp33, 48
    store i8 %tmp34, i8* %tmp30
    %tmp36 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    %tmp37 = load i8, i8* %digit_char
    call void @push(%struct.Vec* %tmp36,i8 %tmp37)
    %tmp38 = getelementptr inbounds i64, i64* %mut_n, i32 0
    %tmp39 = load i64, i64* %mut_n
    %tmp40 = sdiv i64 %tmp39, 10
    store i64 %tmp40, i64* %tmp38
    br label %loop_body14
loop_body14_exit:
    %tmp41 = load i32, i32* %is_negative
    %tmp42 = icmp ne i32 %tmp41, 0
    br i1 %tmp42, label %then16, label %end_if16
then16:
    %tmp44 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    call void @push(%struct.Vec* %tmp44,i8 45)
    br label %end_if16
end_if16:
    %i = alloca i32
    %tmp45 = getelementptr inbounds i32, i32* %i, i32 0
    store i32 0, i32* %tmp45
    %j = alloca i32
    %tmp46 = getelementptr inbounds i32, i32* %j, i32 0
    %tmp47 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    %tmp48 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp47, i32 0, i32 1
    %tmp49 = load i32, i32* %tmp48
    %tmp50 = sub i32 %tmp49, 1
    store i32 %tmp50, i32* %tmp46
    br label %loop_body17
loop_body17:
    %tmp51 = load i32, i32* %i
    %tmp52 = load i32, i32* %j
    %tmp53 = icmp uge i32 %tmp51, %tmp52
    br i1 %tmp53, label %then18, label %end_if18
then18:
    br label %loop_body17_exit
    br label %end_if18
end_if18:
    %temp = alloca i8
    %tmp54 = getelementptr inbounds i8, i8* %temp, i32 0
    %tmp55 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    %tmp56 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp55, i32 0, i32 0
    %tmp57 = load i8*, i8** %tmp56
    %tmp58 = load i32, i32* %i
    %tmp59 = zext i32 %tmp58 to i64
    %tmp60 = getelementptr i8, i8* %tmp57, i64 %tmp59
    %tmp61 = load i8, i8* %tmp60
    store i8 %tmp61, i8* %tmp54
    %tmp62 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    %tmp63 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp62, i32 0, i32 0
    %tmp64 = load i8*, i8** %tmp63
    %tmp65 = load i32, i32* %i
    %tmp66 = zext i32 %tmp65 to i64
    %tmp67 = getelementptr i8, i8* %tmp64, i64 %tmp66
    %tmp68 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    %tmp69 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp68, i32 0, i32 0
    %tmp70 = load i8*, i8** %tmp69
    %tmp71 = load i32, i32* %j
    %tmp72 = zext i32 %tmp71 to i64
    %tmp73 = getelementptr i8, i8* %tmp70, i64 %tmp72
    %tmp74 = load i8, i8* %tmp73
    store i8 %tmp74, i8* %tmp67
    %tmp75 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    %tmp76 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp75, i32 0, i32 0
    %tmp77 = load i8*, i8** %tmp76
    %tmp78 = load i32, i32* %j
    %tmp79 = zext i32 %tmp78 to i64
    %tmp80 = getelementptr i8, i8* %tmp77, i64 %tmp79
    %tmp81 = load i8, i8* %temp
    store i8 %tmp81, i8* %tmp80
    %tmp82 = getelementptr inbounds i32, i32* %i, i32 0
    %tmp83 = load i32, i32* %i
    %tmp84 = add i32 %tmp83, 1
    store i32 %tmp84, i32* %tmp82
    %tmp85 = getelementptr inbounds i32, i32* %j, i32 0
    %tmp86 = load i32, i32* %j
    %tmp87 = sub i32 %tmp86, 1
    store i32 %tmp87, i32* %tmp85
    br label %loop_body17
loop_body17_exit:
    %tmp89 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    call void @push(%struct.Vec* %tmp89,i8 10)
    %tmp91 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    %tmp92 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp91, i32 0, i32 0
    %tmp93 = load i8*, i8** %tmp92
    %tmp94 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    %tmp95 = getelementptr inbounds %struct.Vec, %struct.Vec* %tmp94, i32 0, i32 1
    %tmp96 = load i32, i32* %tmp95
    %tmp97 = bitcast i32 %tmp96 to i32
    call void @write(i8* %tmp93,i32 %tmp97)
    %tmp99 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    call void @free_vec(%struct.Vec* %tmp99)
    ret void

    unreachable
}

define i32 @main(){
    call i32 @AllocConsole()
    call void @println_i32(i32 0)
    call void @println_i32(i32 -1432)
    call void @println_i32(i32 1342)
    call i32 @FreeConsole()
    %buffer = alloca %struct.Vec
    %tmp6 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    call void @new_vec(%struct.Vec* %tmp6)
    %tmp8 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    call void @push(%struct.Vec* %tmp8,i8 32)
    %tmp10 = getelementptr inbounds %struct.Vec, %struct.Vec* %buffer, i32 0
    call void @free_vec(%struct.Vec* %tmp10)
    %list = alloca %struct.List
    %tmp12 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0
    call void @new_list(%struct.List* %tmp12)
    %tmp14 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0
    call void @extend(%struct.List* %tmp14,i32 64)
    %tmp16 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0
    call void @free_list(%struct.List* %tmp16)
    ret i32 0

    unreachable
}
