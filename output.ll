target triple = "x86_64-pc-windows-msvc"
declare dllimport i32* @GetProcessHeap()
declare dllimport i8* @HeapAlloc(i32*, i32, i64)
%struct.List = type {%struct.ListNode*,%struct.ListNode*,i32}
%struct.ListNode = type {%struct.ListNode*,i8*}

define void @__chkstk(){
    ret void

    unreachable
}

define i8* @malloc(i64 %size){
    %size.addr = alloca i64
    store i64 %size, i64* %size.addr
    %tmp0 = bitcast i8*(i32*,i32,i64)* @HeapAlloc to ptr
    %tmp1 = bitcast i32*()* @GetProcessHeap to ptr
    %tmp2 = call i32* %tmp1()
    %tmp3 = add i32 0, 0
    %tmp4 = load i64, i64* %size.addr
    %tmp5 = call i8* %tmp0(i32* %tmp2,i32 %tmp3,i64 %tmp4)
    ret i8* %tmp5

    unreachable
}

define void @new_list(%struct.List* %list){
    %list.addr = alloca %struct.List*
    store %struct.List* %list, %struct.List** %list.addr
    %tmp2 = load %struct.List*, %struct.List** %list.addr
    %tmp0 = getelementptr i8, ptr %tmp2, i64 0
    %tmp3 = add i64 0, 0
    %tmp4 = inttoptr i64 %tmp3 to %struct.ListNode*
    store %struct.ListNode* %tmp4, %struct.ListNode** %tmp0
    %tmp7 = load %struct.List*, %struct.List** %list.addr
    %tmp5 = getelementptr i8, ptr %tmp7, i64 8
    %tmp8 = add i64 0, 0
    %tmp9 = inttoptr i64 %tmp8 to %struct.ListNode*
    store %struct.ListNode* %tmp9, %struct.ListNode** %tmp5
    %tmp12 = load %struct.List*, %struct.List** %list.addr
    %tmp10 = getelementptr i8, ptr %tmp12, i64 16
    %tmp13 = add i32 0, 0
    store i32 %tmp13, i32* %tmp10
    ret void

    unreachable
}

define void @new_list_node(%struct.ListNode* %list){
    %list.addr = alloca %struct.ListNode*
    store %struct.ListNode* %list, %struct.ListNode** %list.addr
    %tmp2 = load %struct.ListNode*, %struct.ListNode** %list.addr
    %tmp0 = getelementptr i8, ptr %tmp2, i64 0
    %tmp3 = add i64 0, 0
    %tmp4 = inttoptr i64 %tmp3 to %struct.ListNode*
    store %struct.ListNode* %tmp4, %struct.ListNode** %tmp0
    %tmp7 = load %struct.ListNode*, %struct.ListNode** %list.addr
    %tmp5 = getelementptr i8, ptr %tmp7, i64 8
    %tmp8 = add i64 0, 0
    %tmp9 = inttoptr i64 %tmp8 to i8*
    store i8* %tmp9, i8** %tmp5
    ret void

    unreachable
}

define void @extend(%struct.List* %list, i8* %data){
    %list.addr = alloca %struct.List*
    store %struct.List* %list, %struct.List** %list.addr
    %data.addr = alloca i8*
    store i8* %data, i8** %data.addr
    %tmp2 = load %struct.List*, %struct.List** %list.addr
    %tmp0 = getelementptr i8, ptr %tmp2, i64 0
    %tmp3 = load %struct.ListNode*, %struct.ListNode** %tmp0
    %tmp4 = add i64 0, 0
    %tmp5 = inttoptr i64 %tmp4 to %struct.ListNode*
    %tmp6 = icmp eq ptr %tmp3, %tmp5
    br i1 %tmp6, label %then0, label %else0
then0:
    %tmp9 = load %struct.List*, %struct.List** %list.addr
    %tmp7 = getelementptr i8, ptr %tmp9, i64 0
    %tmp10 = bitcast i8*(i64)* @malloc to ptr
    %tmp11 = add i64 16, 0
    %tmp12 = call i8* %tmp10(i64 %tmp11)
    %tmp13 = bitcast i8* %tmp12 to %struct.ListNode*
    store %struct.ListNode* %tmp13, %struct.ListNode** %tmp7
    %tmp14 = bitcast void(%struct.ListNode*)* @new_list_node to ptr
    %tmp17 = load %struct.List*, %struct.List** %list.addr
    %tmp15 = getelementptr i8, ptr %tmp17, i64 0
    %tmp18 = load %struct.ListNode*, %struct.ListNode** %tmp15
    call void %tmp14(%struct.ListNode* %tmp18)
    %tmp22 = load %struct.List*, %struct.List** %list.addr
    %tmp20 = getelementptr i8, ptr %tmp22, i64 0
    %tmp19 = getelementptr i8, ptr %tmp20, i64 8
    %tmp23 = load i8*, i8** %data.addr
    store i8* %tmp23, i8** %tmp19
    %tmp26 = load %struct.List*, %struct.List** %list.addr
    %tmp24 = getelementptr i8, ptr %tmp26, i64 8
    %tmp29 = load %struct.List*, %struct.List** %list.addr
    %tmp27 = getelementptr i8, ptr %tmp29, i64 0
    %tmp30 = load %struct.ListNode*, %struct.ListNode** %tmp27
    store %struct.ListNode* %tmp30, %struct.ListNode** %tmp24
    %tmp33 = load %struct.List*, %struct.List** %list.addr
    %tmp31 = getelementptr i8, ptr %tmp33, i64 16
    %tmp34 = add i32 1, 0
    store i32 %tmp34, i32* %tmp31
    ret void
    br label %after_else0
else0:
    br label %after_else0
after_else0:
    %nln = alloca %struct.ListNode*
    %tmp35 = getelementptr inbounds %struct.ListNode*, %struct.ListNode** %nln, i32 0
    %tmp36 = bitcast i8*(i64)* @malloc to ptr
    %tmp37 = add i64 16, 0
    %tmp38 = call i8* %tmp36(i64 %tmp37)
    %tmp39 = bitcast i8* %tmp38 to %struct.ListNode*
    store %struct.ListNode* %tmp39, %struct.ListNode** %tmp35
    %tmp40 = bitcast void(%struct.ListNode*)* @new_list_node to ptr
    %tmp41 = load %struct.ListNode*, %struct.ListNode** %nln
    call void %tmp40(%struct.ListNode* %tmp41)
    %tmp44 = load %struct.ListNode*, %struct.ListNode** %nln
    %tmp42 = getelementptr i8, ptr %tmp44, i64 8
    %tmp45 = load i8*, i8** %data.addr
    store i8* %tmp45, i8** %tmp42
    %tmp49 = load %struct.List*, %struct.List** %list.addr
    %tmp47 = getelementptr i8, ptr %tmp49, i64 8
    %tmp46 = getelementptr i8, ptr %tmp47, i64 0
    %tmp50 = load %struct.ListNode*, %struct.ListNode** %nln
    store %struct.ListNode* %tmp50, %struct.ListNode** %tmp46
    %tmp53 = load %struct.List*, %struct.List** %list.addr
    %tmp51 = getelementptr i8, ptr %tmp53, i64 8
    %tmp57 = load %struct.List*, %struct.List** %list.addr
    %tmp55 = getelementptr i8, ptr %tmp57, i64 8
    %tmp54 = getelementptr i8, ptr %tmp55, i64 0
    %tmp58 = load %struct.ListNode*, %struct.ListNode** %tmp54
    store %struct.ListNode* %tmp58, %struct.ListNode** %tmp51
    %tmp61 = load %struct.List*, %struct.List** %list.addr
    %tmp59 = getelementptr i8, ptr %tmp61, i64 16
    %tmp64 = load %struct.List*, %struct.List** %list.addr
    %tmp62 = getelementptr i8, ptr %tmp64, i64 16
    %tmp65 = load i32, i32* %tmp62
    %tmp66 = add i32 1, 0
    %tmp67 = add i32 %tmp65, %tmp66
    store i32 %tmp67, i32* %tmp59
    ret void

    unreachable
}

define i32 @main(){
    %list = alloca %struct.List
    %tmp0 = bitcast void(%struct.List*)* @new_list to ptr
    %tmp1 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0
    call void %tmp0(%struct.List* %tmp1)
    %tmp2 = bitcast void(%struct.List*,i8*)* @extend to ptr
    %tmp3 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0
    %tmp4 = add i64 1, 0
    %tmp5 = inttoptr i64 %tmp4 to i8*
    call void %tmp2(%struct.List* %tmp3,i8* %tmp5)
    %tmp6 = bitcast void(%struct.List*,i8*)* @extend to ptr
    %tmp7 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0
    %tmp8 = add i64 2, 0
    %tmp9 = inttoptr i64 %tmp8 to i8*
    call void %tmp6(%struct.List* %tmp7,i8* %tmp9)
    %tmp10 = bitcast void(%struct.List*,i8*)* @extend to ptr
    %tmp11 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0
    %tmp12 = add i64 3, 0
    %tmp13 = inttoptr i64 %tmp12 to i8*
    call void %tmp10(%struct.List* %tmp11,i8* %tmp13)
    %tmp15 = getelementptr inbounds %struct.List, %struct.List* %list, i32 0
    %tmp14 = getelementptr i8, ptr %tmp15, i64 16
    %tmp16 = load i32, i32* %tmp14
    %tmp17 = bitcast i32 %tmp16 to i32
    ret i32 %tmp17

    unreachable
}
