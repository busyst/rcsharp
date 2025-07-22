target triple = "x86_64-pc-windows-msvc"
declare dllimport i32* @GetProcessHeap()
declare dllimport i8* @HeapAlloc(i32*, i32, i64)

define i8* @malloc(i64 %size){
    %size.addr = alloca i64
    store i64 %size, i64* %size.addr
    %tmp0 = bitcast i8*(i32*,i32,i64)* @HeapAlloc to ptr
    %tmp1 = bitcast i32*()* @GetProcessHeap to ptr
    %tmp2 = call i32* %tmp1()
    %tmp3 = add i64 0, 0
    %tmp4 = trunc i64 %tmp3 to i32
    %tmp5 = load i64, i64* %size.addr
    %tmp6 = call i8* %tmp0(i32* %tmp2,i32 %tmp4,i64 %tmp5)
    ret i8* %tmp6

    unreachable
}

define i8* @malloc_zero(i64 %size){
    %size.addr = alloca i64
    store i64 %size, i64* %size.addr
    %tmp0 = bitcast i8*(i32*,i32,i64)* @HeapAlloc to ptr
    %tmp1 = bitcast i32*()* @GetProcessHeap to ptr
    %tmp2 = call i32* %tmp1()
    %tmp3 = add i64 8, 0
    %tmp4 = trunc i64 %tmp3 to i32
    %tmp5 = load i64, i64* %size.addr
    %tmp6 = call i8* %tmp0(i32* %tmp2,i32 %tmp4,i64 %tmp5)
    ret i8* %tmp6

    unreachable
}

define i32 @main(){
    %x = alloca i32
    %tmp0 = getelementptr i32, i32* %x
    %tmp1 = add i64 0, 0
    %tmp2 = trunc i64 %tmp1 to i32
    store i32 %tmp2, i32* %tmp0
    %tmp3 = load i32, i32* %x
    ret i32 %tmp3

    unreachable
}
