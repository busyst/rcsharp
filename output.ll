target triple = "x86_64-pc-windows-msvc"
declare dllimport i32* @GetProcessHeap()
declare dllimport i8* @HeapAlloc(i32*, i32, i64)

define i64 @main(){
    %x1 = alloca i32
    %tmp0 = getelementptr i32, i32* %x1
    %tmp1 = add i64 1235, 0
    %tmp2 = trunc i64 %tmp1 to i32
    store i32 %tmp2, i32* %tmp0
    %x2 = alloca i32
    %tmp3 = getelementptr i32, i32* %x2
    %tmp4 = add i64 1235, 0
    %tmp5 = trunc i64 %tmp4 to i32
    store i32 %tmp5, i32* %tmp3
    %y1 = alloca i64*
    %tmp6 = getelementptr i64*, i64** %y1
    %tmp7 = getelementptr i32, i32* %x1
    store i64* %tmp7, i64** %tmp6
    %y2 = alloca i64*
    %tmp8 = getelementptr i64*, i64** %y2
    %tmp9 = getelementptr i32, i32* %x2
    store i64* %tmp9, i64** %tmp8
    %z1 = alloca i64
    %tmp10 = getelementptr i64, i64* %z1
    %tmp11 = load i64*, i64** %y1
    %tmp12 = ptrtoint i64* %tmp11 to i64
    store i64 %tmp12, i64* %tmp10
    %z2 = alloca i64
    %tmp13 = getelementptr i64, i64* %z2
    %tmp14 = load i64*, i64** %y2
    %tmp15 = ptrtoint i64* %tmp14 to i64
    store i64 %tmp15, i64* %tmp13
    %tmp16 = load i64, i64* %z1
    ret i64 %tmp16

    unreachable
}
