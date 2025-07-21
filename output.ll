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
    %x = alloca i8*
    %tmp0 = getelementptr i8*, i8** %x
    %tmp1 = bitcast i8*(i64)* @malloc_zero to ptr
    %tmp2 = add i64 1, 0
    %tmp3 = call i8* %tmp1(i64 %tmp2)
    store i8* %tmp3, i8** %tmp0
    %tmp4 = load i8*, i8** %x
    %tmp5 = load i8, i8* %tmp4
    %tmp6 = sext i8 %tmp5 to i32
    ret i32 %tmp6

    unreachable
}
