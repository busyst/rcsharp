declare dllimport i32 @AllocConsole()
declare dllimport i32 @FreeConsole()
declare dllimport void @ExitProcess(i32)
declare dllimport i32* @GetStdHandle(i32)
declare dllimport i32 @WriteConsoleA(i32*,i8*,i32,i32*,i32*)
declare dllimport i32 @ReadConsoleA(i32*,i8*,i32,i32*,i32*)
declare dllimport i32* @GetProcessHeap()
declare dllimport i8* @HeapAlloc(i32*,i32,i64)
declare dllimport i32 @HeapFree(i32*,i32,i8*)
define i32 @main() {
entry:
%tmp0 = call i32 @AllocConsole()
%prompt_msg = alloca i8*
%tmp1 = getelementptr inbounds [41 x i8], [41 x i8]* @.str0, i64 0, i64 0
store i8* %tmp1, i8** %prompt_msg
%buffer = alloca i8*
%tmp2 = add i32 38, 0
%tmp3 = call i8* @malloc(i32 %tmp2)
store i8* %tmp3, i8** %buffer
%x = alloca i8*
%tmp4 = getelementptr inbounds [7 x i8], [7 x i8]* @.str1, i64 0, i64 0
store i8* %tmp4, i8** %x
%tmp5 = load i8*, i8** %buffer
%tmp6 = load i8*, i8** %prompt_msg
%tmp7 = add i32 38, 0
call void @mem_copy(i8* %tmp5, i8* %tmp6, i32 %tmp7)
%tmp9 = load i8*, i8** %buffer
%tmp10 = load i8*, i8** %x
%tmp11 = add i32 6, 0
call void @mem_copy(i8* %tmp9, i8* %tmp10, i32 %tmp11)
%tmp13 = load i8*, i8** %buffer
%tmp14 = add i32 38, 0
call void @write(i8* %tmp13, i32 %tmp14)
call void @echo()
%tmp17 = call i32 @FreeConsole()
%tmp18 = add i32 0, 0
call void @ExitProcess(i32 %tmp18)
%tmp20 = add i32 0, 0
ret i32 %tmp20
unreachable
}
define void @__chkstk() {
entry:
ret void
}
define i32* @get_stdout() {
entry:
%stdout_handle = alloca i32*
%tmp0 = add i32 11, 0
%tmp1 = sub nsw i32 0, %tmp0
%tmp2 = call i32* @GetStdHandle(i32 %tmp1)
store i32* %tmp2, i32** %stdout_handle
%tmp3 = bitcast i32** %stdout_handle to i32**
%tmp4 = add i32 1, 0
%tmp5 = sub nsw i32 0, %tmp4
%tmp6 = inttoptr i32 %tmp5 to i32**
%tmp7 = icmp eq i32** %tmp3, %tmp6
br i1 %tmp7, label %if.then.0, label %if.end.2
if.then.0:
%tmp8 = add i32 1, 0
%tmp9 = sub nsw i32 0, %tmp8
call void @ExitProcess(i32 %tmp9)
br label %if.end.2
if.end.2:
%tmp11 = load i32*, i32** %stdout_handle
ret i32* %tmp11
unreachable
}
define i32* @get_stdin() {
entry:
%stdin_handle = alloca i32*
%tmp0 = add i32 10, 0
%tmp1 = sub nsw i32 0, %tmp0
%tmp2 = call i32* @GetStdHandle(i32 %tmp1)
store i32* %tmp2, i32** %stdin_handle
%tmp3 = bitcast i32** %stdin_handle to i32**
%tmp4 = add i32 1, 0
%tmp5 = sub nsw i32 0, %tmp4
%tmp6 = inttoptr i32 %tmp5 to i32**
%tmp7 = icmp eq i32** %tmp3, %tmp6
br i1 %tmp7, label %if.then.0, label %if.end.2
if.then.0:
%tmp8 = add i32 1, 0
%tmp9 = sub nsw i32 0, %tmp8
call void @ExitProcess(i32 %tmp9)
br label %if.end.2
if.end.2:
%tmp11 = load i32*, i32** %stdin_handle
ret i32* %tmp11
unreachable
}
define i8* @malloc(i32 %size) {
entry:
%size.addr = alloca i32, align 4
store i32 %size, i32* %size.addr
%process_heap = alloca i32*
%tmp0 = call i32* @GetProcessHeap()
store i32* %tmp0, i32** %process_heap
%buffer = alloca i8*
%tmp1 = load i32*, i32** %process_heap
%tmp2 = add i32 0, 0
%tmp3 = load i32, i32* %size.addr
%tmp4 = sext i32 %tmp3 to i64
%tmp5 = call i8* @HeapAlloc(i32* %tmp1, i32 %tmp2, i64 %tmp4)
store i8* %tmp5, i8** %buffer
%tmp6 = load i8*, i8** %buffer
ret i8* %tmp6
unreachable
}
define i8* @malloc_zero(i32 %size) {
entry:
%size.addr = alloca i32, align 4
store i32 %size, i32* %size.addr
%process_heap = alloca i32*
%tmp0 = call i32* @GetProcessHeap()
store i32* %tmp0, i32** %process_heap
%buffer = alloca i8*
%tmp1 = load i32*, i32** %process_heap
%tmp2 = add i32 8, 0
%tmp3 = load i32, i32* %size.addr
%tmp4 = sext i32 %tmp3 to i64
%tmp5 = call i8* @HeapAlloc(i32* %tmp1, i32 %tmp2, i64 %tmp4)
store i8* %tmp5, i8** %buffer
%tmp6 = load i8*, i8** %buffer
ret i8* %tmp6
unreachable
}
define void @free(i8* %buffer) {
entry:
%buffer.addr = alloca i8*, align 4
store i8* %buffer, i8** %buffer.addr
%process_heap = alloca i32*
%tmp0 = call i32* @GetProcessHeap()
store i32* %tmp0, i32** %process_heap
%tmp1 = load i32*, i32** %process_heap
%tmp2 = add i32 0, 0
%tmp3 = load i8*, i8** %buffer.addr
%tmp4 = call i32 @HeapFree(i32* %tmp1, i32 %tmp2, i8* %tmp3)
ret void
}
define void @write(i8* %buffer, i32 %len) {
entry:
%buffer.addr = alloca i8*, align 4
store i8* %buffer, i8** %buffer.addr
%len.addr = alloca i32, align 4
store i32 %len, i32* %len.addr
%stdout_handle = alloca i32*
%tmp0 = call i32* @get_stdout()
store i32* %tmp0, i32** %stdout_handle
%tmp1 = load i32*, i32** %stdout_handle
%tmp2 = load i8*, i8** %buffer.addr
%tmp3 = load i32, i32* %len.addr
%tmp4_i64 = add i64 0, 0
%tmp4 = inttoptr i64 %tmp4_i64 to i32*
%tmp5_i64 = add i64 0, 0
%tmp5 = inttoptr i64 %tmp5_i64 to i32*
%tmp6 = call i32 @WriteConsoleA(i32* %tmp1, i8* %tmp2, i32 %tmp3, i32* %tmp4, i32* %tmp5)
ret void
}
define i8 @read_key() {
entry:
%stdin_handle = alloca i32*
%tmp0 = call i32* @get_stdin()
store i32* %tmp0, i32** %stdin_handle
%read = alloca i32
%tmp1 = add i32 0, 0
store i32 %tmp1, i32* %read
%input_buffer = alloca i8
%tmp2 = add i32 0, 0
%tmp3 = trunc i32 %tmp2 to i8
store i8 %tmp3, i8* %input_buffer
%tmp4 = load i32*, i32** %stdin_handle
%tmp5 = bitcast i8* %input_buffer to i8*
%tmp6 = add i32 1, 0
%tmp7 = bitcast i32* %read to i32*
%tmp8_i64 = add i64 0, 0
%tmp8 = inttoptr i64 %tmp8_i64 to i32*
%tmp9 = call i32 @ReadConsoleA(i32* %tmp4, i8* %tmp5, i32 %tmp6, i32* %tmp7, i32* %tmp8)
%tmp10 = load i8, i8* %input_buffer
ret i8 %tmp10
unreachable
}
define void @echo() {
entry:
%BUFFER_SIZE = alloca i32
%tmp0 = add i32 1024, 0
store i32 %tmp0, i32* %BUFFER_SIZE
%input_buffer = alloca i8*
%tmp1 = load i32, i32* %BUFFER_SIZE
%tmp2 = call i8* @malloc(i32 %tmp1)
store i8* %tmp2, i8** %input_buffer
%number_of_chars_read = alloca i32
%tmp3 = add i32 0, 0
store i32 %tmp3, i32* %number_of_chars_read
%stdin_handle = alloca i32*
%tmp4 = call i32* @get_stdin()
store i32* %tmp4, i32** %stdin_handle
%tmp5 = load i32*, i32** %stdin_handle
%tmp6 = load i8*, i8** %input_buffer
%tmp7 = load i32, i32* %BUFFER_SIZE
%tmp8 = bitcast i32* %number_of_chars_read to i32*
%tmp9_i64 = add i64 0, 0
%tmp9 = inttoptr i64 %tmp9_i64 to i32*
%tmp10 = call i32 @ReadConsoleA(i32* %tmp5, i8* %tmp6, i32 %tmp7, i32* %tmp8, i32* %tmp9)
%tmp11 = load i8*, i8** %input_buffer
%tmp12 = load i32, i32* %number_of_chars_read
call void @write(i8* %tmp11, i32 %tmp12)
%tmp14 = load i8*, i8** %input_buffer
call void @free(i8* %tmp14)
ret void
}
define void @mem_copy(i8* %dest, i8* %src, i32 %len) {
entry:
%dest.addr = alloca i8*, align 4
store i8* %dest, i8** %dest.addr
%src.addr = alloca i8*, align 4
store i8* %src, i8** %src.addr
%len.addr = alloca i32, align 4
store i32 %len, i32* %len.addr
%i = alloca i32
%tmp0 = add i32 0, 0
store i32 %tmp0, i32* %i
br label %loop.header.0
loop.header.0:
br label %loop.body.1
loop.body.1:
%tmp1 = load i32, i32* %i
%tmp2 = load i32, i32* %len.addr
%tmp3 = icmp sge i32 %tmp1, %tmp2
br i1 %tmp3, label %if.then.3, label %if.end.5
if.then.3:
br label %loop.end.2
br label %if.end.5
if.end.5:
%tmp4 = load i8*, i8** %src.addr
%tmp5 = load i32, i32* %i
%tmp6 = getelementptr inbounds i8, i8* %tmp4, i32 %tmp5
%tmp7 = load i8, i8* %tmp6
%tmp8 = load i8*, i8** %dest.addr
%tmp9 = load i32, i32* %i
%tmp10 = getelementptr inbounds i8, i8* %tmp8, i32 %tmp9
store i8 %tmp7, i8* %tmp10
%tmp11 = load i32, i32* %i
%tmp12 = add i32 1, 0
%tmp13 = add i32 %tmp11, %tmp12
store i32 %tmp13, i32* %i
br label %loop.header.0
loop.end.2:
ret void
}
@.str0 = private unnamed_addr constant [41 x i8] c"Please type something and press Enter:\0A\0D\00", align 1
@.str1 = private unnamed_addr constant [7 x i8] c"esaelP\00", align 1
