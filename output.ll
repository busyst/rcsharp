target triple = "x86_64-pc-windows-msvc"
declare dllimport i32* @GetProcessHeap()
declare dllimport i8* @HeapAlloc(i32*, i32, i64)
%struct.vec2 = type {i32,i32}

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

define i8* @malloc_zero(i64 %size){
    %size.addr = alloca i64
    store i64 %size, i64* %size.addr
    %tmp0 = bitcast i8*(i32*,i32,i64)* @HeapAlloc to ptr
    %tmp1 = bitcast i32*()* @GetProcessHeap to ptr
    %tmp2 = call i32* %tmp1()
    %tmp3 = add i32 8, 0
    %tmp4 = load i64, i64* %size.addr
    %tmp5 = call i8* %tmp0(i32* %tmp2,i32 %tmp3,i64 %tmp4)
    ret i8* %tmp5

    unreachable
}

define i32 @main(){
    %x = alloca %struct.vec2*
    %tmp0 = getelementptr %struct.vec2*, %struct.vec2** %x
    %tmp1 = add i64 8, 0
    %tmp2 = alloca i8, i64 %tmp1
    %tmp3 = bitcast i8* %tmp2 to %struct.vec2*
    store %struct.vec2* %tmp3, %struct.vec2** %tmp0
    %y = alloca %struct.vec2
    %tmp4 = getelementptr %struct.vec2, %struct.vec2* %y
    %tmp5 = load %struct.vec2*, %struct.vec2** %x
    %tmp6 = load %struct.vec2, %struct.vec2* %tmp5
    store %struct.vec2 %tmp6, %struct.vec2* %tmp4
    %tmp7 = add i32 0, 0
    ret i32 %tmp7

    unreachable
}
