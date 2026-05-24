%struct.Argument = type { i16, %struct.Type }
%struct.EnumField = type { i16, i1, %struct.Expression }
%struct.EnumNode = type { i16, %struct.Type*, %"struct.vector.Vec<%struct.EnumField>" }
%struct.Expression = type { i32 }
%struct.FnNode = type { i16, %"struct.vector.Vec<%struct.Argument>", %struct.Type*, %"struct.vector.Vec<i16>" }
%struct.HintNode = type { i16, %"struct.vector.Vec<%struct.Expression>" }
%struct.NamespaceNode = type { i16, %"struct.vector.Vec<%struct.Stmt>" }
%struct.Stmt = type { i8, i8* }
%struct.StructNode = type { i16, %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<i16>" }
%struct.TokenData = type { i8, i16, i32 }
%struct.Type = type { i32 }
%struct.mem.PROCESS_HEAP_ENTRY = type { i8*, i32, i8, i8, i16, i8*, i32, i32, i32 }
%struct.string.String = type { i8*, i32 }
%struct.window.BITMAP = type { i32, i32, i32, i32, i16, i16, i8* }
%struct.window.MSG = type { i8*, i32, i64, i64, i32, %struct.window.POINT }
%struct.window.PAINTSTRUCT = type { i8*, i32, %struct.window.RECT, i32, i32, [32 x i8] }
%struct.window.POINT = type { i32, i32 }
%struct.window.RECT = type { i32, i32, i32, i32 }
%struct.window.WNDCLASSEXA = type { i32, i32, i64 (i8*, i32, i64, i64)*, i32, i32, i8*, i8*, i8*, i8*, i8*, i8*, i8* }
%"struct.vector.Vec<%struct.EnumField>" = type { %struct.EnumField*, i32, i32 }
%"struct.vector.Vec<%struct.Argument>" = type { %struct.Argument*, i32, i32 }
%"struct.vector.Vec<i16>" = type { i16*, i32, i32 }
%"struct.vector.Vec<%struct.Expression>" = type { %struct.Expression*, i32, i32 }
%"struct.vector.Vec<%struct.Stmt>" = type { %struct.Stmt*, i32, i32 }
%"struct.vector.Vec<%struct.TokenData>" = type { %struct.TokenData*, i32, i32 }
%"struct.vector.Vec<%struct.string.String>" = type { %struct.string.String*, i32, i32 }
declare dllimport i32 @AllocConsole()
declare dllimport i8* @GetStdHandle(i32 %nStdHandle)
declare dllimport i32 @WriteConsoleA(i8* %hConsoleOutput, i8* %lpBuffer, i32 %nNumberOfCharsToWrite, i32* %lpNumberOfCharsWritten, i8* %lpReserved)
declare dllimport i32 @CloseHandle(i8* %hObject)
declare dllimport i8* @CreateFileA(i8* %lpFileName, i32 %dwDesiredAccess, i32 %dwShareMode, i8* %lpSecurityAttributes, i32 %dwCreationDisposition, i32 %dwFlagsAndAttributes, i8* %hTemplateFile)
declare dllimport i32 @GetFileSizeEx(i8* %hFile, i64* %lpFileSize)
declare dllimport i32 @ReadFile(i8* %hFile, i8* %lpBuffer, i32 %nNumberOfBytesToRead, i32* %lpNumberOfBytesRead, i8* %lpOverlapped)
declare dllimport i32* @GetProcessHeap()
declare dllimport i8* @HeapAlloc(i32* %hHeap, i32 %dwFlags, i64 %dwBytes)
declare dllimport i32 @HeapFree(i32* %hHeap, i32 %dwFlags, i8* %lpMem)
declare dllimport i8* @HeapReAlloc(i32* %hHeap, i32 %dwFlags, i8* %lpMem, i64 %dwBytes)
declare dllimport void @ExitProcess(i32 %code)


@.str.0 = private unnamed_addr constant [32 x i8] c"D:/Projects/rcsharp/src.rcsharp\00"
@.str.1 = private unnamed_addr constant [28 x i8] c"Successfully parsed items: \00"
@.str.2 = private unnamed_addr constant [17 x i8] c"File not found: \00"
@.str.3 = private unnamed_addr constant [17 x i8] c"File read failed\00"
@.str.4 = private unnamed_addr constant [34 x i8] c"Expected name after hint symbol #\00"
@.str.5 = private unnamed_addr constant [37 x i8] c"Expected ')' after arguments in hint\00"
@.str.6 = private unnamed_addr constant [42 x i8] c"Expected ']' after arguments in attribute\00"
@.str.7 = private unnamed_addr constant [34 x i8] c"Expected function name after 'fn'\00"
@.str.8 = private unnamed_addr constant [40 x i8] c"Expected '(' or '<' after function name\00"
@.str.9 = private unnamed_addr constant [38 x i8] c"Expected ')' after function arguments\00"
@.str.10 = private unnamed_addr constant [24 x i8] c"Expected namespace name\00"
@.str.11 = private unnamed_addr constant [40 x i8] c"Expected namespace body after namespace\00"
@.str.12 = private unnamed_addr constant [19 x i8] c"Expected enum name\00"
@.str.13 = private unnamed_addr constant [27 x i8] c"Expected '{' for enum body\00"
@.str.14 = private unnamed_addr constant [21 x i8] c"Expected struct name\00"
@.str.15 = private unnamed_addr constant [29 x i8] c"Expected '{' for struct body\00"
@.str.16 = private unnamed_addr constant [50 x i8] c"Expected this be a constant or static declaration\00"
@.str.17 = private unnamed_addr constant [24 x i8] c"Expected Colon and Type\00"
@.str.18 = private unnamed_addr constant [33 x i8] c"Expected SemiColon or expression\00"
@.str.19 = private unnamed_addr constant [19 x i8] c"Expected SemiColon\00"
@.str.20 = private unnamed_addr constant [7 x i8] c"@@@@\0A\0D\00"
@.str.21 = private unnamed_addr constant [21 x i8] c"--UNEXPECTED TOKEN--\00"
@.str.22 = private unnamed_addr constant [9 x i8] c"ACHTUNG:\00"
@.str.23 = private unnamed_addr constant [24 x i8] c"Character not expected!\00"
@.str.24 = private unnamed_addr constant [12 x i8] c"Exception: \00"
@.str.25 = private unnamed_addr constant [14 x i8] c"Out of memory\00"
@.str.26 = private unnamed_addr constant [3 x i8] c"0\0A\00"
@.str.27 = private unnamed_addr constant [26 x i8] c"stdout handle was invalid\00"
@.str.28 = private unnamed_addr constant [5 x i8] c"CHAR\00"
@.str.29 = private unnamed_addr constant [2 x i8] c"(\00"
@.str.30 = private unnamed_addr constant [2 x i8] c")\00"
@.str.31 = private unnamed_addr constant [2 x i8] c"{\00"
@.str.32 = private unnamed_addr constant [2 x i8] c"}\00"
@.str.33 = private unnamed_addr constant [2 x i8] c"[\00"
@.str.34 = private unnamed_addr constant [2 x i8] c"]\00"
@.str.35 = private unnamed_addr alias [2 x i8], [2 x i8]* bitcast (i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.22, i64 0, i64 7) to [2 x i8]*)
@.str.36 = private unnamed_addr constant [3 x i8] c"::\00"
@.str.37 = private unnamed_addr constant [2 x i8] c";\00"
@.str.38 = private unnamed_addr constant [2 x i8] c",\00"
@.str.39 = private unnamed_addr alias [2 x i8], [2 x i8]* bitcast (i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.40, i64 0, i64 1) to [2 x i8]*)
@.str.40 = private unnamed_addr constant [3 x i8] c"..\00"
@.str.41 = private unnamed_addr constant [4 x i8] c"..=\00"
@.str.42 = private unnamed_addr constant [3 x i8] c"=>\00"
@.str.43 = private unnamed_addr alias [2 x i8], [2 x i8]* bitcast (i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.4, i64 0, i64 32) to [2 x i8]*)
@.str.44 = private unnamed_addr alias [2 x i8], [2 x i8]* bitcast (i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.41, i64 0, i64 2) to [2 x i8]*)
@.str.45 = private unnamed_addr constant [2 x i8] c"+\00"
@.str.46 = private unnamed_addr alias [2 x i8], [2 x i8]* bitcast (i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.21, i64 0, i64 19) to [2 x i8]*)
@.str.47 = private unnamed_addr constant [2 x i8] c"*\00"
@.str.48 = private unnamed_addr constant [2 x i8] c"/\00"
@.str.49 = private unnamed_addr constant [2 x i8] c"%\00"
@.str.50 = private unnamed_addr alias [2 x i8], [2 x i8]* bitcast (i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str.23, i64 0, i64 22) to [2 x i8]*)
@.str.51 = private unnamed_addr constant [3 x i8] c"==\00"
@.str.52 = private unnamed_addr constant [3 x i8] c"!=\00"
@.str.53 = private unnamed_addr constant [3 x i8] c"||\00"
@.str.54 = private unnamed_addr constant [3 x i8] c"&&\00"
@.str.55 = private unnamed_addr alias [2 x i8], [2 x i8]* bitcast (i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.42, i64 0, i64 1) to [2 x i8]*)
@.str.56 = private unnamed_addr constant [3 x i8] c">=\00"
@.str.57 = private unnamed_addr constant [2 x i8] c"<\00"
@.str.58 = private unnamed_addr constant [3 x i8] c"<=\00"
@.str.59 = private unnamed_addr constant [2 x i8] c"~\00"
@.str.60 = private unnamed_addr alias [2 x i8], [2 x i8]* bitcast (i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.53, i64 0, i64 1) to [2 x i8]*)
@.str.61 = private unnamed_addr alias [2 x i8], [2 x i8]* bitcast (i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.54, i64 0, i64 1) to [2 x i8]*)
@.str.62 = private unnamed_addr constant [2 x i8] c"^\00"
@.str.63 = private unnamed_addr constant [4 x i8] c"PUB\00"
@.str.64 = private unnamed_addr constant [7 x i8] c"INLINE\00"
@.str.65 = private unnamed_addr constant [6 x i8] c"CONST\00"
@.str.66 = private unnamed_addr constant [7 x i8] c"EXTERN\00"
@.str.67 = private unnamed_addr constant [6 x i8] c"MATCH\00"
@.str.68 = private unnamed_addr constant [3 x i8] c"FN\00"
@.str.69 = private unnamed_addr constant [4 x i8] c"LET\00"
@.str.70 = private unnamed_addr constant [7 x i8] c"STATIC\00"
@.str.71 = private unnamed_addr constant [3 x i8] c"AS\00"
@.str.72 = private unnamed_addr constant [3 x i8] c"IF\00"
@.str.73 = private unnamed_addr constant [5 x i8] c"ELSE\00"
@.str.74 = private unnamed_addr constant [6 x i8] c"TRAIT\00"
@.str.75 = private unnamed_addr constant [5 x i8] c"IMPL\00"
@.str.76 = private unnamed_addr constant [7 x i8] c"STRUCT\00"
@.str.77 = private unnamed_addr constant [5 x i8] c"ENUM\00"
@.str.78 = private unnamed_addr constant [5 x i8] c"LOOP\00"
@.str.79 = private unnamed_addr constant [4 x i8] c"FOR\00"
@.str.80 = private unnamed_addr constant [3 x i8] c"DO\00"
@.str.81 = private unnamed_addr constant [3 x i8] c"IN\00"
@.str.82 = private unnamed_addr constant [6 x i8] c"WHILE\00"
@.str.83 = private unnamed_addr constant [6 x i8] c"BREAK\00"
@.str.84 = private unnamed_addr constant [9 x i8] c"CONTINUE\00"
@.str.85 = private unnamed_addr constant [7 x i8] c"RETURN\00"
@.str.86 = private unnamed_addr constant [5 x i8] c"THIS\00"
@.str.87 = private unnamed_addr constant [9 x i8] c"OPERATOR\00"
@.str.88 = private unnamed_addr constant [10 x i8] c"NAMESPACE\00"
@.str.89 = private unnamed_addr constant [5 x i8] c"TRUE\00"
@.str.90 = private unnamed_addr constant [6 x i8] c"FALSE\00"
@.str.91 = private unnamed_addr constant [5 x i8] c"NULL\00"
@.str.92 = private unnamed_addr constant [14 x i8] c"UNKNOWN_TOKEN\00"
@.str.93 = private unnamed_addr constant [27 x i8] c"Expected ';' in array type\00"
@.str.94 = private unnamed_addr constant [27 x i8] c"Expected ']' in array type\00"
@.str.95 = private unnamed_addr constant [16 x i8] c"Expected LParen\00"
@.str.96 = private unnamed_addr constant [15 x i8] c"Expected Colon\00"
@.str.97 = private unnamed_addr constant [19 x i8] c"Expected type name\00"
@.str.98 = private unnamed_addr constant [20 x i8] c"Expected field name\00"
@.str.99 = private unnamed_addr constant [30 x i8] c"Expected ':' after field name\00"
@.str.100 = private unnamed_addr constant [39 x i8] c"Expected ',' or '}' after struct field\00"
@.str.101 = private unnamed_addr constant [31 x i8] c"Expected '}' after struct body\00"
@.str.102 = private unnamed_addr constant [36 x i8] c"Expected generic type name or comma\00"
@.str.103 = private unnamed_addr constant [38 x i8] c"Expected '>' after generic parameters\00"
@.str.104 = private unnamed_addr constant [27 x i8] c"Expected enum variant name\00"
@.str.105 = private unnamed_addr constant [39 x i8] c"Expected ',' or '}' after enum variant\00"
@.str.106 = private unnamed_addr constant [29 x i8] c"Expected '}' after enum body\00"
@.str.107 = private unnamed_addr constant [23 x i8] c"Expected argument name\00"
@.str.108 = private unnamed_addr constant [33 x i8] c"Expected ':' after argument name\00"
@.str.109 = private unnamed_addr constant [35 x i8] c"Expected ',' or ')' after argument\00"
@.str.110 = private unnamed_addr constant [3 x i8] c"if\00"
@.str.111 = private unnamed_addr constant [3 x i8] c"do\00"
@.str.112 = private unnamed_addr constant [3 x i8] c"as\00"
@.str.113 = private unnamed_addr constant [3 x i8] c"in\00"
@.str.114 = private unnamed_addr constant [3 x i8] c"fn\00"
@.str.115 = private unnamed_addr constant [4 x i8] c"let\00"
@.str.116 = private unnamed_addr constant [4 x i8] c"pub\00"
@.str.117 = private unnamed_addr constant [4 x i8] c"for\00"
@.str.118 = private unnamed_addr constant [5 x i8] c"true\00"
@.str.119 = private unnamed_addr constant [5 x i8] c"loop\00"
@.str.120 = private unnamed_addr constant [5 x i8] c"this\00"
@.str.121 = private unnamed_addr constant [5 x i8] c"null\00"
@.str.122 = private unnamed_addr constant [5 x i8] c"else\00"
@.str.123 = private unnamed_addr constant [5 x i8] c"enum\00"
@.str.124 = private unnamed_addr constant [5 x i8] c"impl\00"
@.str.125 = private unnamed_addr constant [6 x i8] c"const\00"
@.str.126 = private unnamed_addr constant [6 x i8] c"match\00"
@.str.127 = private unnamed_addr constant [6 x i8] c"trait\00"
@.str.128 = private unnamed_addr constant [6 x i8] c"while\00"
@.str.129 = private unnamed_addr constant [6 x i8] c"break\00"
@.str.130 = private unnamed_addr constant [6 x i8] c"false\00"
@.str.131 = private unnamed_addr constant [7 x i8] c"inline\00"
@.str.132 = private unnamed_addr constant [7 x i8] c"extern\00"
@.str.133 = private unnamed_addr constant [7 x i8] c"static\00"
@.str.134 = private unnamed_addr constant [7 x i8] c"struct\00"
@.str.135 = private unnamed_addr constant [7 x i8] c"return\00"
@.str.136 = private unnamed_addr constant [9 x i8] c"continue\00"
@.str.137 = private unnamed_addr constant [9 x i8] c"operator\00"
@.str.138 = private unnamed_addr alias [10 x i8], [10 x i8]* bitcast (i8* getelementptr inbounds ([40 x i8], [40 x i8]* @.str.11, i64 0, i64 30) to [10 x i8]*)
@.str.139 = private unnamed_addr constant [26 x i8] c"Invalid escape character!\00"
@.str.140 = private unnamed_addr constant [17 x i8] c"Char is too long\00"
@.str.141 = private unnamed_addr constant [15 x i8] c"Realloc failed\00"
@stdlib.rand_seed = internal global i32 zeroinitializer

define void @mainCRTStartup(){
	call void @main()
	unreachable
}
define void @main(){
	%v0 = alloca %struct.string.String
	%v1 = alloca %"struct.vector.Vec<%struct.TokenData>"
	%v2 = alloca %"struct.vector.Vec<%struct.string.String>"
	%v3 = alloca %"struct.vector.Vec<%struct.Stmt>"
	%tmp0 = call %struct.string.String @fs.read_full_file_as_string(i8* @.str.0)
	store %struct.string.String %tmp0, %struct.string.String* %v0
	%tmp1 = call %"struct.vector.Vec<%struct.TokenData>" @"vector.new<%struct.TokenData>"()
	store %"struct.vector.Vec<%struct.TokenData>" %tmp1, %"struct.vector.Vec<%struct.TokenData>"* %v1
	%tmp2 = call %"struct.vector.Vec<%struct.string.String>" @"vector.new<%struct.string.String>"()
	store %"struct.vector.Vec<%struct.string.String>" %tmp2, %"struct.vector.Vec<%struct.string.String>"* %v2
	call void @lex(%struct.string.String* %v0, %"struct.vector.Vec<%struct.TokenData>"* %v1, %"struct.vector.Vec<%struct.string.String>"* %v2)
	%tmp3 = call %"struct.vector.Vec<%struct.Stmt>" @"vector.new<%struct.Stmt>"()
	store %"struct.vector.Vec<%struct.Stmt>" %tmp3, %"struct.vector.Vec<%struct.Stmt>"* %v3
	%tmp4 = load %struct.TokenData*, %struct.TokenData** %v1
	%tmp5 = getelementptr inbounds %"struct.vector.Vec<%struct.TokenData>", %"struct.vector.Vec<%struct.TokenData>"* %v1, i32 0, i32 1
	%tmp6 = load i32, i32* %tmp5
	call void @parse(%struct.TokenData* %tmp4, i32 %tmp6, %"struct.vector.Vec<%struct.string.String>"* %v2, %"struct.vector.Vec<%struct.Stmt>"* %v3)
	call void @console.write(i8* @.str.1, i32 27)
	%tmp7 = getelementptr inbounds %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %v3, i32 0, i32 1
	%tmp8 = load i32, i32* %tmp7
	%tmp9 = zext i32 %tmp8 to i64
	call void @console.println_i64(i64 %tmp9)
	call void @string.free(%struct.string.String* %v0)
	call void @ExitProcess(i32 0)
; Variable statement_vector is out.
; Variable symbol_vector is out.
; Variable token_vector is out.
; Variable file_data is out.
	ret void
}
define void @string.free(%struct.string.String* %str){
	%tmp0 = load i8*, i8** %str
	call void @mem.free(i8* %tmp0)
	%tmp1 = getelementptr inbounds %struct.string.String, %struct.string.String* %str, i32 0, i32 1
	store i32 0, i32* %tmp1
	ret void
}
define %struct.string.String @fs.read_full_file_as_string(i8* %path){
	%v0 = alloca i64
	%v1 = alloca %struct.string.String
	%v2 = alloca i32
	%tmp0 = call i8* @CreateFileA(i8* %path, i32 2147483648, i32 1, i8* null, i32 3, i32 128, i8* null)
	%tmp1 = inttoptr i64 -1 to i8*
	%tmp2 = icmp eq i8* %tmp0, %tmp1
	br i1 %tmp2, label %then0, label %endif0
then0:
	%tmp3 = call i8* @string_utils.insert(i8* @.str.2, i8* %path, i32 16)
	call void @process.throw(i8* %tmp3)
	br label %endif0
endif0:
	store i64 0, i64* %v0
	%tmp4 = call i32 @GetFileSizeEx(i8* %tmp0, i64* %v0)
	%tmp5 = icmp eq i32 %tmp4, 0
	br i1 %tmp5, label %then1, label %endif1
then1:
	call i32 @CloseHandle(i8* %tmp0)
	%tmp6 = call %struct.string.String @string.empty()
	br label %func_exit
endif1:
	%tmp7 = load i64, i64* %v0
	%tmp8 = trunc i64 %tmp7 to i32
	%tmp9 = call %struct.string.String @string.with_size(i32 %tmp8)
	store %struct.string.String %tmp9, %struct.string.String* %v1
	store i32 0, i32* %v2
	%tmp10 = load i8*, i8** %v1
	%tmp11 = load i64, i64* %v0
	%tmp12 = trunc i64 %tmp11 to i32
	%tmp13 = call i32 @ReadFile(i8* %tmp0, i8* %tmp10, i32 %tmp12, i32* %v2, i8* null)
	call i32 @CloseHandle(i8* %tmp0)
	%tmp14 = icmp eq i32 %tmp13, 0
	br i1 %tmp14, label %then2, label %endif2
then2:
	call void @string.free(%struct.string.String* %v1)
	call void @process.throw(i8* @.str.3)
	br label %endif2
endif2:
	%tmp15 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 1
	%tmp16 = load i64, i64* %v0
	%tmp17 = trunc i64 %tmp16 to i32
	store i32 %tmp17, i32* %tmp15
	%tmp18 = getelementptr inbounds %struct.string.String, %struct.string.String* %v1, i32 0, i32 1
	%tmp19 = load i32, i32* %tmp18
	%tmp20 = load i8*, i8** %v1
	%tmp21 = getelementptr inbounds i8, i8* %tmp20, i32 %tmp19
	store i8 0, i8* %tmp21
	%tmp22 = load %struct.string.String, %struct.string.String* %v1
	br label %func_exit
func_exit:
; Variable buffer is out.
	%tmp23 = phi %struct.string.String [%tmp6, %then1], [%tmp22, %endif2]
	ret %struct.string.String %tmp23
}
define void @console.write(i8* %buffer, i32 %len){
	%v0 = alloca i32
	%tmp0 = icmp eq i32 %len, 0
	br i1 %tmp0, label %then0, label %endif0
then0:
	br label %func_exit
endif0:
	%tmp1 = call i8* @console.get_stdout()
	call i32 @WriteConsoleA(i8* %tmp1, i8* %buffer, i32 %len, i32* %v0, i8* null)
	%tmp2 = load i32, i32* %v0
	%tmp3 = icmp ne i32 %len, %tmp2
	br i1 %tmp3, label %then1, label %endif1
then1:
	call void @ExitProcess(i32 -2)
	br label %endif1
endif1:
	br label %func_exit
func_exit:
	ret void
}
define void @console.println_i64(i64 %n){
	%tmp0 = icmp sge i64 %n, 0
	br i1 %tmp0, label %then0, label %else0
then0:
	call void @console.println_u64(i64 %n)
	br label %endif0
else0:
	call void @console.print_char(i8 45)
	%tmp1 = sub i64 0, %n
	call void @console.println_u64(i64 %tmp1)
	br label %endif0
endif0:
	ret void
}
define void @parse(%struct.TokenData* %token_array, i32 %token_len, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %"struct.vector.Vec<%struct.Stmt>"* %statement_vector){
	%v0 = alloca i32
	%v1 = alloca i32
	%v2 = alloca i1
	%v3 = alloca %"struct.vector.Vec<%struct.Expression>"
	%v4 = alloca %struct.Stmt
	%v5 = alloca %"struct.vector.Vec<%struct.Argument>"
	%v6 = alloca %struct.Type*
	%v7 = alloca %struct.Stmt
	%v8 = alloca %"struct.vector.Vec<%struct.Stmt>"
	%v9 = alloca %struct.Stmt
	%v10 = alloca %struct.Type*
	%v11 = alloca %"struct.vector.Vec<%struct.EnumField>"
	%v12 = alloca %struct.Stmt
	%v13 = alloca %"struct.vector.Vec<i16>"
	%v14 = alloca %"struct.vector.Vec<%struct.Argument>"
	%v15 = alloca %struct.Stmt
	%v16 = alloca %"struct.vector.Vec<%struct.Stmt>"
	%v17 = alloca %struct.Type*
	%v18 = alloca i32
	%v19 = alloca %struct.string.String
	store i32 0, i32* %v0
	store i32 4294967295, i32* %v1
	br label %loop_start0
loop_start0:
	%tmp0 = load i32, i32* %v0
	%tmp1 = icmp ult i32 %tmp0, %token_len
	br i1 %tmp1, label %endif1, label %else1
else1:
	br label %loop_body0_exit
endif1:
	%tmp2 = load i32, i32* %v0
	%tmp3 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp2
	%tmp4 = load i8, i8* %tmp3
	%tmp5 = call i1 @is_modifier(i8 %tmp4)
	br i1 %tmp5, label %then2, label %endif2
then2:
	%tmp6 = load i32, i32* %v1
	%tmp7 = icmp eq i32 %tmp6, 4294967295
	br i1 %tmp7, label %then3, label %endif3
then3:
	%tmp8 = load i32, i32* %v0
	store i32 %tmp8, i32* %v1
	br label %endif3
endif3:
	%tmp9 = load i32, i32* %v0
	%tmp10 = add i32 %tmp9, 1
	store i32 %tmp10, i32* %v0
	br label %loop_body0
endif2:
	%tmp11 = icmp eq i8 %tmp4, 14
	br i1 %tmp11, label %then4, label %endif4
then4:
	store i32 4294967295, i32* %v1
	%tmp12 = load i32, i32* %v0
	%tmp13 = add i32 %tmp12, 1
	store i32 %tmp13, i32* %v0
	store i1 false, i1* %v2
	%tmp14 = load i32, i32* %v0
	%tmp15 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp14
	%tmp16 = load i8, i8* %tmp15
	%tmp17 = icmp eq i8 %tmp16, 4
	br i1 %tmp17, label %then5, label %endif5
then5:
	store i1 true, i1* %v2
	%tmp18 = load i32, i32* %v0
	%tmp19 = add i32 %tmp18, 1
	store i32 %tmp19, i32* %v0
	br label %endif5
endif5:
	%tmp20 = load i32, i32* %v0
	%tmp21 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp20
	%tmp22 = load i8, i8* %tmp21
	%tmp23 = icmp ne i8 %tmp22, 65
	br i1 %tmp23, label %then6, label %endif6
then6:
	call void @process.throw(i8* @.str.4)
	br label %endif6
endif6:
	%tmp24 = load i32, i32* %v0
	%tmp25 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp24
	%tmp26 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp25, i32 0, i32 1
	%tmp27 = load i16, i16* %tmp26
	%tmp28 = load i32, i32* %v0
	%tmp29 = add i32 %tmp28, 1
	store i32 %tmp29, i32* %v0
	%tmp30 = call %"struct.vector.Vec<%struct.Expression>" @"vector.new<%struct.Expression>"()
	store %"struct.vector.Vec<%struct.Expression>" %tmp30, %"struct.vector.Vec<%struct.Expression>"* %v3
	%tmp31 = load i32, i32* %v0
	%tmp32 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp31
	%tmp33 = load i8, i8* %tmp32
	%tmp34 = icmp eq i8 %tmp33, 0
	br i1 %tmp34, label %then7, label %endif7
then7:
	%tmp35 = load i32, i32* %v0
	%tmp36 = add i32 %tmp35, 1
	store i32 %tmp36, i32* %v0
	%tmp37 = call %"struct.vector.Vec<%struct.Expression>" @parse_expression_comma(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	store %"struct.vector.Vec<%struct.Expression>" %tmp37, %"struct.vector.Vec<%struct.Expression>"* %v3
	call void @expect(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 1, i8* @.str.5)
	br label %endif7
endif7:
	%tmp38 = load i1, i1* %v2
	br i1 %tmp38, label %then8, label %endif8
then8:
	call void @expect(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 5, i8* @.str.6)
	br label %endif8
endif8:
	%tmp39 = call i8* @mem.malloc(i64 24)
	store i16 %tmp27, i16* %tmp39
	%tmp40 = getelementptr inbounds %struct.HintNode, %struct.HintNode* %tmp39, i32 0, i32 1
	%tmp41 = load %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Expression>"* %v3
	store %"struct.vector.Vec<%struct.Expression>" %tmp41, %"struct.vector.Vec<%struct.Expression>"* %tmp40
	store i8 4, i8* %v4
	%tmp42 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %v4, i32 0, i32 1
	store i8* %tmp39, i8** %tmp42
	%tmp43 = load %struct.Stmt, %struct.Stmt* %v4
	call void @"vector.push<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %statement_vector, %struct.Stmt %tmp43)
	br label %loop_body0
; Variable stmt is out.
; Variable exprs is out.
endif4:
	%tmp44 = icmp eq i8 %tmp4, 41
	br i1 %tmp44, label %then9, label %endif9
then9:
	store i32 4294967295, i32* %v1
	%tmp45 = load i32, i32* %v0
	%tmp46 = add i32 %tmp45, 1
	store i32 %tmp46, i32* %v0
	%tmp47 = load i32, i32* %v0
	%tmp48 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp47
	%tmp49 = load i8, i8* %tmp48
	%tmp50 = icmp ne i8 %tmp49, 65
	br i1 %tmp50, label %then10, label %endif10
then10:
	call void @process.throw(i8* @.str.7)
	br label %endif10
endif10:
	%tmp51 = load i32, i32* %v0
	%tmp52 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp51
	%tmp53 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp52, i32 0, i32 1
	%tmp54 = load i16, i16* %tmp53
	%tmp55 = load i32, i32* %v0
	%tmp56 = add i32 %tmp55, 1
	store i32 %tmp56, i32* %v0
	%tmp57 = load i32, i32* %v0
	%tmp58 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp57
	%tmp59 = load i8, i8* %tmp58
	%tmp60 = icmp ne i8 %tmp59, 0
	br i1 %tmp60, label %logic_rhs_11, label %logic_end_11
logic_rhs_11:
	%tmp61 = load i32, i32* %v0
	%tmp62 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp61
	%tmp63 = load i8, i8* %tmp62
	%tmp64 = icmp ne i8 %tmp63, 28
	br label %logic_end_11
logic_end_11:
	%tmp65 = phi i1 [%tmp60, %endif10], [%tmp64, %logic_rhs_11]
	br i1 %tmp65, label %then12, label %endif12
then12:
	call void @process.throw(i8* @.str.8)
	br label %endif12
endif12:
	%tmp66 = load i32, i32* %v0
	%tmp67 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp66
	%tmp68 = load i8, i8* %tmp67
	%tmp69 = icmp eq i8 %tmp68, 28
	br i1 %tmp69, label %then13, label %endif13
then13:
	call void @skip_nested(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 28, i8 26)
	br label %endif13
endif13:
	%tmp70 = load i32, i32* %v0
	%tmp71 = add i32 %tmp70, 1
	store i32 %tmp71, i32* %v0
	%tmp72 = call %"struct.vector.Vec<%struct.Argument>" @parse_argument_comma(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	store %"struct.vector.Vec<%struct.Argument>" %tmp72, %"struct.vector.Vec<%struct.Argument>"* %v5
	%tmp73 = load i32, i32* %v0
	%tmp74 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp73
	%tmp75 = load i8, i8* %tmp74
	%tmp76 = icmp ne i8 %tmp75, 1
	br i1 %tmp76, label %then14, label %endif14
then14:
	call void @process.throw(i8* @.str.9)
	br label %endif14
endif14:
	%tmp77 = load i32, i32* %v0
	%tmp78 = add i32 %tmp77, 1
	store i32 %tmp78, i32* %v0
	store %struct.Type* null, %struct.Type** %v6
	%tmp79 = load i32, i32* %v0
	%tmp80 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp79
	%tmp81 = load i8, i8* %tmp80
	%tmp82 = icmp eq i8 %tmp81, 6
	br i1 %tmp82, label %then15, label %endif15
then15:
	%tmp83 = load i32, i32* %v0
	%tmp84 = add i32 %tmp83, 1
	store i32 %tmp84, i32* %v0
	%tmp85 = call %struct.Type @parse_type(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	%tmp86 = call i8* @mem.malloc(i64 4)
	store %struct.Type* %tmp86, %struct.Type** %v6
	%tmp87 = load %struct.Type*, %struct.Type** %v6
	store %struct.Type %tmp85, %struct.Type* %tmp87
; Variable parsed_type is out.
	br label %endif15
endif15:
	%tmp88 = load i32, i32* %v0
	%tmp89 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp88
	%tmp90 = load i8, i8* %tmp89
	%tmp91 = icmp eq i8 %tmp90, 2
	br i1 %tmp91, label %then16, label %else16
then16:
	call void @skip_nested(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 2, i8 3)
	br label %endif16
else16:
	%tmp92 = load i32, i32* %v0
	%tmp93 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp92
	%tmp94 = load i8, i8* %tmp93
	%tmp95 = icmp eq i8 %tmp94, 13
	br i1 %tmp95, label %then17, label %else17
then17:
	%tmp96 = load i32, i32* %v0
	%tmp97 = add i32 %tmp96, 1
	store i32 %tmp97, i32* %v0
	br label %loop_start18
loop_start18:
	%tmp98 = load i32, i32* %v0
	%tmp99 = icmp ult i32 %tmp98, %token_len
	br i1 %tmp99, label %logic_rhs_19, label %logic_end_19
logic_rhs_19:
	%tmp100 = load i32, i32* %v0
	%tmp101 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp100
	%tmp102 = load i8, i8* %tmp101
	%tmp103 = icmp ne i8 %tmp102, 8
	br label %logic_end_19
logic_end_19:
	%tmp104 = phi i1 [%tmp99, %loop_start18], [%tmp103, %logic_rhs_19]
	br i1 %tmp104, label %endif20, label %else20
else20:
	br label %loop_body18_exit
endif20:
	%tmp105 = load i32, i32* %v0
	%tmp106 = add i32 %tmp105, 1
	store i32 %tmp106, i32* %v0
	br label %loop_start18
loop_body18_exit:
	%tmp107 = load i32, i32* %v0
	%tmp108 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp107
	%tmp109 = load i8, i8* %tmp108
	%tmp110 = icmp eq i8 %tmp109, 8
	br i1 %tmp110, label %then21, label %endif21
then21:
	%tmp111 = load i32, i32* %v0
	%tmp112 = add i32 %tmp111, 1
	store i32 %tmp112, i32* %v0
	br label %endif21
endif21:
	br label %endif17
else17:
	%tmp113 = load i32, i32* %v0
	%tmp114 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp113
	%tmp115 = load i8, i8* %tmp114
	%tmp116 = icmp eq i8 %tmp115, 8
	br i1 %tmp116, label %then22, label %endif22
then22:
	%tmp117 = load i32, i32* %v0
	%tmp118 = add i32 %tmp117, 1
	store i32 %tmp118, i32* %v0
	br label %endif22
endif22:
	br label %endif17
endif17:
	br label %endif16
endif16:
	%tmp119 = call i8* @mem.malloc(i64 48)
	store i16 %tmp54, i16* %tmp119
	%tmp120 = getelementptr inbounds %struct.FnNode, %struct.FnNode* %tmp119, i32 0, i32 1
	%tmp121 = load %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %v5
	store %"struct.vector.Vec<%struct.Argument>" %tmp121, %"struct.vector.Vec<%struct.Argument>"* %tmp120
	%tmp122 = getelementptr inbounds %struct.FnNode, %struct.FnNode* %tmp119, i32 0, i32 2
	%tmp123 = load %struct.Type*, %struct.Type** %v6
	store %struct.Type* %tmp123, %struct.Type** %tmp122
	%tmp124 = getelementptr inbounds %struct.FnNode, %struct.FnNode* %tmp119, i32 0, i32 3
	%tmp125 = call %"struct.vector.Vec<i16>" @"vector.new<i16>"()
	store %"struct.vector.Vec<i16>" %tmp125, %"struct.vector.Vec<i16>"* %tmp124
	store i8 3, i8* %v7
	%tmp126 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %v7, i32 0, i32 1
	store i8* %tmp119, i8** %tmp126
	%tmp127 = load %struct.Stmt, %struct.Stmt* %v7
	call void @"vector.push<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %statement_vector, %struct.Stmt %tmp127)
	br label %loop_body0
; Variable stmt is out.
; Variable args is out.
endif9:
	%tmp128 = icmp eq i8 %tmp4, 61
	br i1 %tmp128, label %then23, label %endif23
then23:
	store i32 4294967295, i32* %v1
	%tmp129 = load i32, i32* %v0
	%tmp130 = add i32 %tmp129, 1
	store i32 %tmp130, i32* %v0
	%tmp131 = load i32, i32* %v0
	%tmp132 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp131
	%tmp133 = load i8, i8* %tmp132
	%tmp134 = icmp ne i8 %tmp133, 65
	br i1 %tmp134, label %then24, label %endif24
then24:
	call void @process.throw(i8* @.str.10)
	br label %endif24
endif24:
	%tmp135 = load i32, i32* %v0
	%tmp136 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp135
	%tmp137 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp136, i32 0, i32 1
	%tmp138 = load i16, i16* %tmp137
	%tmp139 = load i32, i32* %v0
	%tmp140 = add i32 %tmp139, 1
	store i32 %tmp140, i32* %v0
	%tmp141 = call %"struct.vector.Vec<%struct.Stmt>" @"vector.new<%struct.Stmt>"()
	store %"struct.vector.Vec<%struct.Stmt>" %tmp141, %"struct.vector.Vec<%struct.Stmt>"* %v8
	%tmp142 = load i32, i32* %v0
	%tmp143 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp142
	%tmp144 = load i8, i8* %tmp143
	%tmp145 = icmp eq i8 %tmp144, 2
	br i1 %tmp145, label %then25, label %else25
then25:
	%tmp146 = load i32, i32* %v0
	%tmp147 = add i32 %tmp146, 1
	call void @skip_nested(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 2, i8 3)
	%tmp148 = load i32, i32* %v0
	%tmp149 = sub i32 %tmp148, 1
	%tmp150 = sub i32 %tmp149, %tmp147
	%tmp151 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp147
	call void @parse(%struct.TokenData* %tmp151, i32 %tmp150, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %"struct.vector.Vec<%struct.Stmt>"* %v8)
	br label %endif25
else25:
	call void @process.throw(i8* @.str.11)
	br label %endif25
endif25:
	%tmp152 = call i8* @mem.malloc(i64 24)
	store i16 %tmp138, i16* %tmp152
	%tmp153 = getelementptr inbounds %struct.NamespaceNode, %struct.NamespaceNode* %tmp152, i32 0, i32 1
	%tmp154 = load %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %v8
	store %"struct.vector.Vec<%struct.Stmt>" %tmp154, %"struct.vector.Vec<%struct.Stmt>"* %tmp153
	store i8 1, i8* %v9
	%tmp155 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %v9, i32 0, i32 1
	store i8* %tmp152, i8** %tmp155
	%tmp156 = load %struct.Stmt, %struct.Stmt* %v9
	call void @"vector.push<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %statement_vector, %struct.Stmt %tmp156)
	br label %loop_body0
; Variable stmt is out.
; Variable nodes is out.
endif23:
	%tmp157 = icmp eq i8 %tmp4, 50
	br i1 %tmp157, label %then26, label %endif26
then26:
	store i32 4294967295, i32* %v1
	%tmp158 = load i32, i32* %v0
	%tmp159 = add i32 %tmp158, 1
	store i32 %tmp159, i32* %v0
	%tmp160 = load i32, i32* %v0
	%tmp161 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp160
	%tmp162 = load i8, i8* %tmp161
	%tmp163 = icmp ne i8 %tmp162, 65
	br i1 %tmp163, label %then27, label %endif27
then27:
	call void @process.throw(i8* @.str.12)
	br label %endif27
endif27:
	%tmp164 = load i32, i32* %v0
	%tmp165 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp164
	%tmp166 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp165, i32 0, i32 1
	%tmp167 = load i16, i16* %tmp166
	%tmp168 = load i32, i32* %v0
	%tmp169 = add i32 %tmp168, 1
	store i32 %tmp169, i32* %v0
	store %struct.Type* null, %struct.Type** %v10
	%tmp170 = load i32, i32* %v0
	%tmp171 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp170
	%tmp172 = load i8, i8* %tmp171
	%tmp173 = icmp eq i8 %tmp172, 6
	br i1 %tmp173, label %then28, label %endif28
then28:
	%tmp174 = load i32, i32* %v0
	%tmp175 = add i32 %tmp174, 1
	store i32 %tmp175, i32* %v0
	%tmp176 = call %struct.Type @parse_type(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	%tmp177 = call i8* @mem.malloc(i64 4)
	store %struct.Type* %tmp177, %struct.Type** %v10
	%tmp178 = load %struct.Type*, %struct.Type** %v10
	store %struct.Type %tmp176, %struct.Type* %tmp178
; Variable parsed_type is out.
	br label %endif28
endif28:
	%tmp179 = call %"struct.vector.Vec<%struct.EnumField>" @"vector.new<%struct.EnumField>"()
	store %"struct.vector.Vec<%struct.EnumField>" %tmp179, %"struct.vector.Vec<%struct.EnumField>"* %v11
	%tmp180 = load i32, i32* %v0
	%tmp181 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp180
	%tmp182 = load i8, i8* %tmp181
	%tmp183 = icmp eq i8 %tmp182, 2
	br i1 %tmp183, label %then29, label %else29
then29:
	%tmp184 = call %"struct.vector.Vec<%struct.EnumField>" @parse_enum_fields(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	store %"struct.vector.Vec<%struct.EnumField>" %tmp184, %"struct.vector.Vec<%struct.EnumField>"* %v11
	br label %endif29
else29:
	call void @process.throw(i8* @.str.13)
	br label %endif29
endif29:
	%tmp185 = call i8* @mem.malloc(i64 32)
	store i16 %tmp167, i16* %tmp185
	%tmp186 = getelementptr inbounds %struct.EnumNode, %struct.EnumNode* %tmp185, i32 0, i32 1
	%tmp187 = load %struct.Type*, %struct.Type** %v10
	store %struct.Type* %tmp187, %struct.Type** %tmp186
	%tmp188 = getelementptr inbounds %struct.EnumNode, %struct.EnumNode* %tmp185, i32 0, i32 2
	%tmp189 = load %"struct.vector.Vec<%struct.EnumField>", %"struct.vector.Vec<%struct.EnumField>"* %v11
	store %"struct.vector.Vec<%struct.EnumField>" %tmp189, %"struct.vector.Vec<%struct.EnumField>"* %tmp188
	store i8 2, i8* %v12
	%tmp190 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %v12, i32 0, i32 1
	store i8* %tmp185, i8** %tmp190
	%tmp191 = load %struct.Stmt, %struct.Stmt* %v12
	call void @"vector.push<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %statement_vector, %struct.Stmt %tmp191)
	br label %loop_body0
; Variable stmt is out.
; Variable fields is out.
endif26:
	%tmp192 = icmp eq i8 %tmp4, 49
	br i1 %tmp192, label %then30, label %endif30
then30:
	store i32 4294967295, i32* %v1
	%tmp193 = load i32, i32* %v0
	%tmp194 = add i32 %tmp193, 1
	store i32 %tmp194, i32* %v0
	%tmp195 = load i32, i32* %v0
	%tmp196 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp195
	%tmp197 = load i8, i8* %tmp196
	%tmp198 = icmp ne i8 %tmp197, 65
	br i1 %tmp198, label %then31, label %endif31
then31:
	call void @process.throw(i8* @.str.14)
	br label %endif31
endif31:
	%tmp199 = load i32, i32* %v0
	%tmp200 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp199
	%tmp201 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp200, i32 0, i32 1
	%tmp202 = load i16, i16* %tmp201
	%tmp203 = load i32, i32* %v0
	%tmp204 = add i32 %tmp203, 1
	store i32 %tmp204, i32* %v0
	%tmp205 = call %"struct.vector.Vec<i16>" @"vector.new<i16>"()
	store %"struct.vector.Vec<i16>" %tmp205, %"struct.vector.Vec<i16>"* %v13
	%tmp206 = load i32, i32* %v0
	%tmp207 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp206
	%tmp208 = load i8, i8* %tmp207
	%tmp209 = icmp eq i8 %tmp208, 28
	br i1 %tmp209, label %then32, label %endif32
then32:
	%tmp210 = call %"struct.vector.Vec<i16>" @parse_generic_params(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	store %"struct.vector.Vec<i16>" %tmp210, %"struct.vector.Vec<i16>"* %v13
	br label %endif32
endif32:
	%tmp211 = call %"struct.vector.Vec<%struct.Argument>" @"vector.new<%struct.Argument>"()
	store %"struct.vector.Vec<%struct.Argument>" %tmp211, %"struct.vector.Vec<%struct.Argument>"* %v14
	%tmp212 = load i32, i32* %v0
	%tmp213 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp212
	%tmp214 = load i8, i8* %tmp213
	%tmp215 = icmp eq i8 %tmp214, 2
	br i1 %tmp215, label %then33, label %else33
then33:
	%tmp216 = call %"struct.vector.Vec<%struct.Argument>" @parse_struct_fields(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	store %"struct.vector.Vec<%struct.Argument>" %tmp216, %"struct.vector.Vec<%struct.Argument>"* %v14
	br label %endif33
else33:
	call void @process.throw(i8* @.str.15)
	br label %endif33
endif33:
	%tmp217 = call i8* @mem.malloc(i64 40)
	store i16 %tmp202, i16* %tmp217
	%tmp218 = getelementptr inbounds %struct.StructNode, %struct.StructNode* %tmp217, i32 0, i32 1
	%tmp219 = load %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %v14
	store %"struct.vector.Vec<%struct.Argument>" %tmp219, %"struct.vector.Vec<%struct.Argument>"* %tmp218
	%tmp220 = getelementptr inbounds %struct.StructNode, %struct.StructNode* %tmp217, i32 0, i32 2
	%tmp221 = load %"struct.vector.Vec<i16>", %"struct.vector.Vec<i16>"* %v13
	store %"struct.vector.Vec<i16>" %tmp221, %"struct.vector.Vec<i16>"* %tmp220
	store i8 0, i8* %v15
	%tmp222 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %v15, i32 0, i32 1
	store i8* %tmp217, i8** %tmp222
	%tmp223 = load %struct.Stmt, %struct.Stmt* %v15
	call void @"vector.push<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %statement_vector, %struct.Stmt %tmp223)
	br label %loop_body0
; Variable stmt is out.
; Variable fields is out.
; Variable generics is out.
endif30:
	%tmp224 = load i32, i32* %v0
	%tmp225 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp224
	%tmp226 = load i8, i8* %tmp225
	%tmp227 = icmp eq i8 %tmp226, 2
	br i1 %tmp227, label %then34, label %endif34
then34:
	%tmp228 = load i32, i32* %v0
	call void @skip_nested(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 2, i8 3)
	%tmp229 = call %"struct.vector.Vec<%struct.Stmt>" @"vector.new<%struct.Stmt>"()
	store %"struct.vector.Vec<%struct.Stmt>" %tmp229, %"struct.vector.Vec<%struct.Stmt>"* %v16
	%tmp230 = load i32, i32* %v0
	%tmp231 = sub i32 %tmp230, 1
	%tmp232 = sub i32 %tmp231, %tmp228
	%tmp233 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp228
	call void @parse(%struct.TokenData* %tmp233, i32 %tmp232, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %"struct.vector.Vec<%struct.Stmt>"* %v16)
	br label %loop_body0
; Variable m is out.
endif34:
	%tmp234 = load i32, i32* %v1
	%tmp235 = icmp ne i32 %tmp234, 4294967295
	br i1 %tmp235, label %then35, label %endif35
then35:
	%tmp236 = load i32, i32* %v0
	%tmp237 = sub i32 %tmp236, 1
	%tmp238 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp237
	%tmp239 = load i8, i8* %tmp238
	%tmp240 = icmp eq i8 %tmp239, 38
	br i1 %tmp240, label %logic_end_36, label %logic_rhs_36
logic_rhs_36:
	%tmp241 = load i32, i32* %v0
	%tmp242 = sub i32 %tmp241, 1
	%tmp243 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp242
	%tmp244 = load i8, i8* %tmp243
	%tmp245 = icmp eq i8 %tmp244, 43
	br label %logic_end_36
logic_end_36:
	%tmp246 = phi i1 [%tmp240, %then35], [%tmp245, %logic_rhs_36]
	br i1 %tmp246, label %then37, label %endif37
then37:
	%tmp247 = load i32, i32* %v0
	%tmp248 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp247
	%tmp249 = load i8, i8* %tmp248
	%tmp250 = icmp ne i8 %tmp249, 65
	br i1 %tmp250, label %then38, label %endif38
then38:
	call void @process.throw(i8* @.str.16)
	br label %endif38
endif38:
	%tmp251 = load i32, i32* %v0
	%tmp252 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp251
	%tmp253 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp252, i32 0, i32 1
	%tmp254 = load i16, i16* %tmp253
	%tmp255 = load i32, i32* %v0
	%tmp256 = add i32 %tmp255, 1
	store i32 %tmp256, i32* %v0
	%tmp257 = load i32, i32* %v0
	%tmp258 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp257
	%tmp259 = load i8, i8* %tmp258
	%tmp260 = icmp eq i8 %tmp259, 6
	br i1 %tmp260, label %then39, label %else39
then39:
	%tmp261 = load i32, i32* %v0
	%tmp262 = add i32 %tmp261, 1
	store i32 %tmp262, i32* %v0
	%tmp263 = call %struct.Type @parse_type(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	%tmp264 = call i8* @mem.malloc(i64 4)
	store %struct.Type* %tmp264, %struct.Type** %v17
	%tmp265 = load %struct.Type*, %struct.Type** %v17
	store %struct.Type %tmp263, %struct.Type* %tmp265
; Variable parsed_type is out.
	br label %endif39
else39:
	call void @process.throw(i8* @.str.17)
	br label %endif39
endif39:
	%tmp266 = load i32, i32* %v0
	%tmp267 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp266
	%tmp268 = load i8, i8* %tmp267
	%tmp269 = icmp eq i8 %tmp268, 15
	br i1 %tmp269, label %then40, label %else40
then40:
	%tmp270 = load i32, i32* %v0
	%tmp271 = add i32 %tmp270, 1
	store i32 %tmp271, i32* %v0
	call %struct.Expression @parse_expression(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	br label %endif40
else40:
	%tmp272 = load i32, i32* %v0
	%tmp273 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp272
	%tmp274 = load i8, i8* %tmp273
	%tmp275 = icmp eq i8 %tmp274, 8
	br i1 %tmp275, label %endif41, label %else41
else41:
	call void @process.throw(i8* @.str.18)
	br label %endif41
endif41:
	br label %endif40
endif40:
	%tmp276 = load i32, i32* %v0
	%tmp277 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp276
	%tmp278 = load i8, i8* %tmp277
	%tmp279 = icmp ne i8 %tmp278, 8
	br i1 %tmp279, label %then42, label %endif42
then42:
	call void @process.throw(i8* @.str.19)
	br label %endif42
endif42:
	%tmp280 = load i32, i32* %v0
	%tmp281 = add i32 %tmp280, 1
	store i32 %tmp281, i32* %v0
	br label %loop_body0
endif37:
	br label %endif35
endif35:
	store i32 0, i32* %v18
	br label %loop_cond43
loop_cond43:
	%tmp282 = load i32, i32* %v18
	%tmp283 = icmp uge i32 %tmp282, 3
	br i1 %tmp283, label %then44, label %endif44
then44:
	br label %loop_body43_exit
endif44:
	%tmp284 = load i32, i32* %v0
	%tmp285 = load i32, i32* %v18
	%tmp286 = add i32 %tmp284, %tmp285
	%tmp287 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp286
	%tmp288 = call %struct.string.String @token_type_to_string(%struct.TokenData* %tmp287, %"struct.vector.Vec<%struct.string.String>"* null)
	store %struct.string.String %tmp288, %struct.string.String* %v19
	call void @console.write_string(%struct.string.String* %v19)
	call void @console.write(i8* @.str.20, i32 6)
	call void @string.free(%struct.string.String* %v19)
	%tmp289 = load i32, i32* %v18
	%tmp290 = add i32 %tmp289, 1
	store i32 %tmp290, i32* %v18
	br label %loop_cond43
loop_body43_exit:
; Variable q is out.
	call void @process.throw(i8* @.str.21)
	br label %loop_body0
loop_body0:
	br label %loop_start0
loop_body0_exit:
	ret void
}
define void @lex(%struct.string.String* %data, %"struct.vector.Vec<%struct.TokenData>"* %token_vector, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector){
	%v0 = alloca i32
	%v1 = alloca i8
	%v2 = alloca i8
	%v3 = alloca i8
	%v4 = alloca i32
	%v5 = alloca i32
	%v6 = alloca i1
	%v7 = alloca i32
	%v8 = alloca i1
	%v9 = alloca i32
	%v10 = alloca i1
	%v11 = alloca i32
	%v12 = alloca i32
	%v13 = alloca i32
	%v14 = alloca i32
	%v15 = alloca i1
	%v16 = alloca i32
	%v17 = alloca i8
	%v18 = alloca %struct.TokenData
	store i32 0, i32* %v0
	br label %loop_start0
loop_start0:
	%tmp0 = load i32, i32* %v0
	%tmp1 = getelementptr inbounds %struct.string.String, %struct.string.String* %data, i32 0, i32 1
	%tmp2 = load i32, i32* %tmp1
	%tmp3 = icmp ult i32 %tmp0, %tmp2
	br i1 %tmp3, label %endif1, label %else1
else1:
	br label %loop_body0_exit
endif1:
	%tmp4 = load i32, i32* %v0
	%tmp5 = load i8*, i8** %data
	%tmp6 = getelementptr inbounds i8, i8* %tmp5, i32 %tmp4
	%tmp7 = load i8, i8* %tmp6
	store i8 %tmp7, i8* %v1
	%tmp8 = load i8, i8* %v1
	%tmp9 = icmp eq i8 %tmp8, 32
	br i1 %tmp9, label %logic_end_2, label %logic_rhs_2
logic_rhs_2:
	%tmp10 = load i8, i8* %v1
	br label %inl_entry3
inl_entry3:
	%tmp11 = icmp sge i8 %tmp10, 0
	br i1 %tmp11, label %logic_rhs_4, label %logic_end_4
logic_rhs_4:
	%tmp12 = icmp sle i8 %tmp10, 31
	br label %logic_end_4
logic_end_4:
	%tmp13 = phi i1 [%tmp11, %inl_entry3], [%tmp12, %logic_rhs_4]
	br i1 %tmp13, label %logic_end_5, label %logic_rhs_5
logic_rhs_5:
	%tmp14 = icmp eq i8 %tmp10, 127
	br label %logic_end_5
logic_end_5:
	%tmp15 = phi i1 [%tmp13, %logic_end_4], [%tmp14, %logic_rhs_5]
	br label %inl_exit3
inl_exit3:
	br label %logic_end_2
logic_end_2:
	%tmp16 = phi i1 [%tmp9, %endif1], [%tmp15, %inl_exit3]
	br i1 %tmp16, label %then6, label %endif6
then6:
	%tmp17 = load i32, i32* %v0
	%tmp18 = load i8*, i8** %data
	%tmp19 = getelementptr inbounds i8, i8* %tmp18, i32 %tmp17
	store i8 0, i8* %tmp19
	%tmp20 = load i32, i32* %v0
	%tmp21 = add i32 %tmp20, 1
	store i32 %tmp21, i32* %v0
	br label %loop_body0
endif6:
	store i8 0, i8* %v2
	%tmp22 = load i32, i32* %v0
	%tmp23 = add i32 %tmp22, 1
	%tmp24 = getelementptr inbounds %struct.string.String, %struct.string.String* %data, i32 0, i32 1
	%tmp25 = load i32, i32* %tmp24
	%tmp26 = icmp ult i32 %tmp23, %tmp25
	br i1 %tmp26, label %then7, label %else7
then7:
	%tmp27 = load i32, i32* %v0
	%tmp28 = add i32 %tmp27, 1
	%tmp29 = load i8*, i8** %data
	%tmp30 = getelementptr inbounds i8, i8* %tmp29, i32 %tmp28
	%tmp31 = load i8, i8* %tmp30
	store i8 %tmp31, i8* %v2
	br label %endif7
else7:
	store i8 0, i8* %v2
	br label %endif7
endif7:
	store i8 0, i8* %v3
	%tmp32 = load i32, i32* %v0
	%tmp33 = add i32 %tmp32, 2
	%tmp34 = getelementptr inbounds %struct.string.String, %struct.string.String* %data, i32 0, i32 1
	%tmp35 = load i32, i32* %tmp34
	%tmp36 = icmp ult i32 %tmp33, %tmp35
	br i1 %tmp36, label %then8, label %else8
then8:
	%tmp37 = load i32, i32* %v0
	%tmp38 = add i32 %tmp37, 2
	%tmp39 = load i8*, i8** %data
	%tmp40 = getelementptr inbounds i8, i8* %tmp39, i32 %tmp38
	%tmp41 = load i8, i8* %tmp40
	store i8 %tmp41, i8* %v3
	br label %endif8
else8:
	store i8 0, i8* %v3
	br label %endif8
endif8:
	%tmp42 = load i8, i8* %v1
	br label %inl_entry9
inl_entry9:
	%tmp43 = icmp sge i8 %tmp42, 97
	br i1 %tmp43, label %logic_rhs_10, label %logic_end_10
logic_rhs_10:
	%tmp44 = icmp sle i8 %tmp42, 122
	br label %logic_end_10
logic_end_10:
	%tmp45 = phi i1 [%tmp43, %inl_entry9], [%tmp44, %logic_rhs_10]
	br i1 %tmp45, label %logic_end_11, label %logic_rhs_11
logic_rhs_11:
	%tmp46 = icmp sge i8 %tmp42, 65
	br i1 %tmp46, label %logic_rhs_12, label %logic_end_12
logic_rhs_12:
	%tmp47 = icmp sle i8 %tmp42, 90
	br label %logic_end_12
logic_end_12:
	%tmp48 = phi i1 [%tmp46, %logic_rhs_11], [%tmp47, %logic_rhs_12]
	br label %logic_end_11
logic_end_11:
	%tmp49 = phi i1 [%tmp45, %logic_end_10], [%tmp48, %logic_end_12]
	br label %inl_exit9
inl_exit9:
	br i1 %tmp49, label %logic_end_13, label %logic_rhs_13
logic_rhs_13:
	%tmp50 = load i8, i8* %v1
	%tmp51 = icmp eq i8 %tmp50, 95
	br label %logic_end_13
logic_end_13:
	%tmp52 = phi i1 [%tmp49, %inl_exit9], [%tmp51, %logic_rhs_13]
	br i1 %tmp52, label %then14, label %else14
then14:
	%tmp53 = load i32, i32* %v0
	%tmp54 = add i32 %tmp53, 1
	store i32 %tmp54, i32* %v4
	br label %loop_start15
loop_start15:
	%tmp55 = load i32, i32* %v4
	%tmp56 = getelementptr inbounds %struct.string.String, %struct.string.String* %data, i32 0, i32 1
	%tmp57 = load i32, i32* %tmp56
	%tmp58 = icmp ult i32 %tmp55, %tmp57
	br i1 %tmp58, label %endif16, label %else16
else16:
	br label %loop_body15_exit
endif16:
	%tmp59 = load i32, i32* %v4
	%tmp60 = load i8*, i8** %data
	%tmp61 = getelementptr inbounds i8, i8* %tmp60, i32 %tmp59
	%tmp62 = load i8, i8* %tmp61
	br label %inl_entry18
inl_entry18:
	%tmp63 = icmp sge i8 %tmp62, 97
	br i1 %tmp63, label %logic_rhs_19, label %logic_end_19
logic_rhs_19:
	%tmp64 = icmp sle i8 %tmp62, 122
	br label %logic_end_19
logic_end_19:
	%tmp65 = phi i1 [%tmp63, %inl_entry18], [%tmp64, %logic_rhs_19]
	br i1 %tmp65, label %logic_end_20, label %logic_rhs_20
logic_rhs_20:
	%tmp66 = icmp sge i8 %tmp62, 65
	br i1 %tmp66, label %logic_rhs_21, label %logic_end_21
logic_rhs_21:
	%tmp67 = icmp sle i8 %tmp62, 90
	br label %logic_end_21
logic_end_21:
	%tmp68 = phi i1 [%tmp66, %logic_rhs_20], [%tmp67, %logic_rhs_21]
	br label %logic_end_20
logic_end_20:
	%tmp69 = phi i1 [%tmp65, %logic_end_19], [%tmp68, %logic_end_21]
	br label %inl_exit18
inl_exit18:
	br i1 %tmp69, label %logic_end_22, label %logic_rhs_22
logic_rhs_22:
	br label %inl_entry23
inl_entry23:
	%tmp70 = icmp sge i8 %tmp62, 48
	br i1 %tmp70, label %logic_rhs_24, label %logic_end_24
logic_rhs_24:
	%tmp71 = icmp sle i8 %tmp62, 57
	br label %logic_end_24
logic_end_24:
	%tmp72 = phi i1 [%tmp70, %inl_entry23], [%tmp71, %logic_rhs_24]
	br label %inl_exit23
inl_exit23:
	br label %logic_end_22
logic_end_22:
	%tmp73 = phi i1 [%tmp69, %inl_exit18], [%tmp72, %inl_exit23]
	br label %inl_exit17
inl_exit17:
	br i1 %tmp73, label %logic_end_25, label %logic_rhs_25
logic_rhs_25:
	%tmp74 = load i32, i32* %v4
	%tmp75 = load i8*, i8** %data
	%tmp76 = getelementptr inbounds i8, i8* %tmp75, i32 %tmp74
	%tmp77 = load i8, i8* %tmp76
	%tmp78 = icmp eq i8 %tmp77, 95
	br label %logic_end_25
logic_end_25:
	%tmp79 = phi i1 [%tmp73, %inl_exit17], [%tmp78, %logic_rhs_25]
	br i1 %tmp79, label %then26, label %endif26
then26:
	%tmp80 = load i32, i32* %v4
	%tmp81 = add i32 %tmp80, 1
	store i32 %tmp81, i32* %v4
	br label %loop_body15
endif26:
	br label %loop_body15_exit
loop_body15:
	br label %loop_start15
loop_body15_exit:
	%tmp82 = load i8*, i8** %data
	%tmp83 = load i32, i32* %v0
	%tmp84 = load i32, i32* %v4
	call void @handle_symbol(i8* %tmp82, i32 %tmp83, i32 %tmp84, %"struct.vector.Vec<%struct.TokenData>"* %token_vector, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector)
	%tmp85 = load i32, i32* %v4
	store i32 %tmp85, i32* %v0
	br label %loop_body0
else14:
	%tmp86 = load i8, i8* %v1
	br label %inl_entry27
inl_entry27:
	%tmp87 = icmp sge i8 %tmp86, 48
	br i1 %tmp87, label %logic_rhs_28, label %logic_end_28
logic_rhs_28:
	%tmp88 = icmp sle i8 %tmp86, 57
	br label %logic_end_28
logic_end_28:
	%tmp89 = phi i1 [%tmp87, %inl_entry27], [%tmp88, %logic_rhs_28]
	br label %inl_exit27
inl_exit27:
	br i1 %tmp89, label %logic_end_29, label %logic_rhs_29
logic_rhs_29:
	%tmp90 = load i8, i8* %v1
	%tmp91 = icmp eq i8 %tmp90, 45
	br i1 %tmp91, label %logic_rhs_30, label %logic_end_30
logic_rhs_30:
	%tmp92 = load i8, i8* %v2
	br label %inl_entry31
inl_entry31:
	%tmp93 = icmp sge i8 %tmp92, 48
	br i1 %tmp93, label %logic_rhs_32, label %logic_end_32
logic_rhs_32:
	%tmp94 = icmp sle i8 %tmp92, 57
	br label %logic_end_32
logic_end_32:
	%tmp95 = phi i1 [%tmp93, %inl_entry31], [%tmp94, %logic_rhs_32]
	br label %inl_exit31
inl_exit31:
	br label %logic_end_30
logic_end_30:
	%tmp96 = phi i1 [%tmp91, %logic_rhs_29], [%tmp95, %inl_exit31]
	br label %logic_end_29
logic_end_29:
	%tmp97 = phi i1 [%tmp89, %inl_exit27], [%tmp96, %logic_end_30]
	br i1 %tmp97, label %then33, label %else33
then33:
	%tmp98 = load i32, i32* %v0
	%tmp99 = add i32 %tmp98, 1
	store i32 %tmp99, i32* %v5
	%tmp100 = load i8, i8* %v1
	%tmp101 = icmp eq i8 %tmp100, 45
	br i1 %tmp101, label %then34, label %endif34
then34:
	%tmp102 = load i8, i8* %v2
	store i8 %tmp102, i8* %v1
	br label %endif34
endif34:
	%tmp103 = load i8, i8* %v1
	%tmp104 = icmp eq i8 %tmp103, 48
	br i1 %tmp104, label %then35, label %endif35
then35:
	%tmp105 = load i8, i8* %v2
	%tmp106 = icmp eq i8 %tmp105, 120
	br i1 %tmp106, label %then36, label %else36
then36:
	%tmp107 = load i32, i32* %v5
	%tmp108 = add i32 %tmp107, 1
	store i32 %tmp108, i32* %v5
	br label %endif36
else36:
	%tmp109 = load i8, i8* %v2
	%tmp110 = icmp eq i8 %tmp109, 98
	br i1 %tmp110, label %then37, label %endif37
then37:
	%tmp111 = load i32, i32* %v5
	%tmp112 = add i32 %tmp111, 1
	store i32 %tmp112, i32* %v5
	br label %endif37
endif37:
	br label %endif36
endif36:
	br label %endif35
endif35:
	store i1 false, i1* %v6
	br label %loop_start38
loop_start38:
	%tmp113 = load i32, i32* %v5
	%tmp114 = getelementptr inbounds %struct.string.String, %struct.string.String* %data, i32 0, i32 1
	%tmp115 = load i32, i32* %tmp114
	%tmp116 = icmp ult i32 %tmp113, %tmp115
	br i1 %tmp116, label %endif39, label %else39
else39:
	br label %loop_body38_exit
endif39:
	%tmp117 = load i32, i32* %v5
	%tmp118 = load i8*, i8** %data
	%tmp119 = getelementptr inbounds i8, i8* %tmp118, i32 %tmp117
	%tmp120 = load i8, i8* %tmp119
	br label %inl_entry41
inl_entry41:
	%tmp121 = icmp sge i8 %tmp120, 48
	br i1 %tmp121, label %logic_rhs_42, label %logic_end_42
logic_rhs_42:
	%tmp122 = icmp sle i8 %tmp120, 57
	br label %logic_end_42
logic_end_42:
	%tmp123 = phi i1 [%tmp121, %inl_entry41], [%tmp122, %logic_rhs_42]
	br label %inl_exit41
inl_exit41:
	br i1 %tmp123, label %logic_end_43, label %logic_rhs_43
logic_rhs_43:
	%tmp124 = icmp sge i8 %tmp120, 97
	br i1 %tmp124, label %logic_rhs_44, label %logic_end_44
logic_rhs_44:
	%tmp125 = icmp sle i8 %tmp120, 102
	br label %logic_end_44
logic_end_44:
	%tmp126 = phi i1 [%tmp124, %logic_rhs_43], [%tmp125, %logic_rhs_44]
	br label %logic_end_43
logic_end_43:
	%tmp127 = phi i1 [%tmp123, %inl_exit41], [%tmp126, %logic_end_44]
	br i1 %tmp127, label %logic_end_45, label %logic_rhs_45
logic_rhs_45:
	%tmp128 = icmp sge i8 %tmp120, 65
	br i1 %tmp128, label %logic_rhs_46, label %logic_end_46
logic_rhs_46:
	%tmp129 = icmp sle i8 %tmp120, 70
	br label %logic_end_46
logic_end_46:
	%tmp130 = phi i1 [%tmp128, %logic_rhs_45], [%tmp129, %logic_rhs_46]
	br label %logic_end_45
logic_end_45:
	%tmp131 = phi i1 [%tmp127, %logic_end_43], [%tmp130, %logic_end_46]
	br label %inl_exit40
inl_exit40:
	br i1 %tmp131, label %logic_end_47, label %logic_rhs_47
logic_rhs_47:
	%tmp132 = load i32, i32* %v5
	%tmp133 = load i8*, i8** %data
	%tmp134 = getelementptr inbounds i8, i8* %tmp133, i32 %tmp132
	%tmp135 = load i8, i8* %tmp134
	%tmp136 = icmp eq i8 %tmp135, 95
	br label %logic_end_47
logic_end_47:
	%tmp137 = phi i1 [%tmp131, %inl_exit40], [%tmp136, %logic_rhs_47]
	br i1 %tmp137, label %then48, label %endif48
then48:
	%tmp138 = load i32, i32* %v5
	%tmp139 = add i32 %tmp138, 1
	store i32 %tmp139, i32* %v5
	br label %loop_body38
endif48:
	%tmp140 = load i32, i32* %v5
	%tmp141 = load i8*, i8** %data
	%tmp142 = getelementptr inbounds i8, i8* %tmp141, i32 %tmp140
	%tmp143 = load i8, i8* %tmp142
	%tmp144 = icmp eq i8 %tmp143, 46
	br i1 %tmp144, label %then49, label %endif49
then49:
	%tmp145 = load i1, i1* %v6
	%tmp146 = xor i1 1, %tmp145
	br i1 %tmp146, label %then50, label %endif50
then50:
	store i1 true, i1* %v6
	%tmp147 = load i32, i32* %v5
	%tmp148 = add i32 %tmp147, 1
	store i32 %tmp148, i32* %v5
	br label %loop_body38
endif50:
	br label %endif49
endif49:
	br label %loop_body38_exit
loop_body38:
	br label %loop_start38
loop_body38_exit:
	%tmp149 = load i1, i1* %v6
	br i1 %tmp149, label %then51, label %else51
then51:
	%tmp150 = load i8*, i8** %data
	%tmp151 = load i32, i32* %v0
	%tmp152 = load i32, i32* %v5
	call void @handle_decimal_number(i8* %tmp150, i32 %tmp151, i32 %tmp152, %"struct.vector.Vec<%struct.TokenData>"* %token_vector, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector)
	br label %endif51
else51:
	%tmp153 = load i8*, i8** %data
	%tmp154 = load i32, i32* %v0
	%tmp155 = load i32, i32* %v5
	call void @handle_number(i8* %tmp153, i32 %tmp154, i32 %tmp155, %"struct.vector.Vec<%struct.TokenData>"* %token_vector, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector)
	br label %endif51
endif51:
	%tmp156 = load i32, i32* %v5
	store i32 %tmp156, i32* %v0
	br label %loop_body0
else33:
	%tmp157 = load i8, i8* %v1
	%tmp158 = icmp eq i8 %tmp157, 34
	br i1 %tmp158, label %then52, label %else52
then52:
	%tmp159 = load i32, i32* %v0
	%tmp160 = add i32 %tmp159, 1
	store i32 %tmp160, i32* %v7
	store i1 false, i1* %v8
	br label %loop_start53
loop_start53:
	%tmp161 = load i32, i32* %v7
	%tmp162 = getelementptr inbounds %struct.string.String, %struct.string.String* %data, i32 0, i32 1
	%tmp163 = load i32, i32* %tmp162
	%tmp164 = icmp ult i32 %tmp161, %tmp163
	br i1 %tmp164, label %endif54, label %else54
else54:
	br label %loop_body53_exit
endif54:
	%tmp165 = load i32, i32* %v7
	%tmp166 = load i8*, i8** %data
	%tmp167 = getelementptr inbounds i8, i8* %tmp166, i32 %tmp165
	%tmp168 = load i8, i8* %tmp167
	%tmp169 = icmp eq i8 %tmp168, 34
	br i1 %tmp169, label %then55, label %endif55
then55:
	%tmp170 = load i1, i1* %v8
	br i1 %tmp170, label %then56, label %else56
then56:
	store i1 false, i1* %v8
	%tmp171 = load i32, i32* %v7
	%tmp172 = add i32 %tmp171, 1
	store i32 %tmp172, i32* %v7
	br label %loop_body53
else56:
	%tmp173 = load i32, i32* %v7
	%tmp174 = add i32 %tmp173, 1
	store i32 %tmp174, i32* %v7
	br label %loop_body53_exit
	br label %endif55
endif55:
	%tmp175 = load i32, i32* %v7
	%tmp176 = load i8*, i8** %data
	%tmp177 = getelementptr inbounds i8, i8* %tmp176, i32 %tmp175
	%tmp178 = load i8, i8* %tmp177
	%tmp179 = icmp eq i8 %tmp178, 92
	br i1 %tmp179, label %then57, label %endif57
then57:
	%tmp180 = load i1, i1* %v8
	%tmp181 = xor i1 1, %tmp180
	store i1 %tmp181, i1* %v8
	%tmp182 = load i32, i32* %v7
	%tmp183 = add i32 %tmp182, 1
	store i32 %tmp183, i32* %v7
	br label %loop_body53
endif57:
	%tmp184 = load i1, i1* %v8
	br i1 %tmp184, label %then58, label %endif58
then58:
	store i1 false, i1* %v8
	br label %endif58
endif58:
	%tmp185 = load i32, i32* %v7
	%tmp186 = add i32 %tmp185, 1
	store i32 %tmp186, i32* %v7
	br label %loop_body53
loop_body53:
	br label %loop_start53
loop_body53_exit:
	%tmp187 = load i8*, i8** %data
	%tmp188 = load i32, i32* %v0
	%tmp189 = load i32, i32* %v7
	call void @handle_string(i8* %tmp187, i32 %tmp188, i32 %tmp189, %"struct.vector.Vec<%struct.TokenData>"* %token_vector, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector)
	%tmp190 = load i32, i32* %v7
	store i32 %tmp190, i32* %v0
	br label %loop_body0
else52:
	%tmp191 = load i8, i8* %v1
	%tmp192 = icmp eq i8 %tmp191, 39
	br i1 %tmp192, label %then59, label %else59
then59:
	%tmp193 = load i32, i32* %v0
	%tmp194 = add i32 %tmp193, 1
	store i32 %tmp194, i32* %v9
	store i1 false, i1* %v10
	br label %loop_start60
loop_start60:
	%tmp195 = load i32, i32* %v9
	%tmp196 = getelementptr inbounds %struct.string.String, %struct.string.String* %data, i32 0, i32 1
	%tmp197 = load i32, i32* %tmp196
	%tmp198 = icmp ult i32 %tmp195, %tmp197
	br i1 %tmp198, label %endif61, label %else61
else61:
	br label %loop_body60_exit
endif61:
	%tmp199 = load i32, i32* %v9
	%tmp200 = load i8*, i8** %data
	%tmp201 = getelementptr inbounds i8, i8* %tmp200, i32 %tmp199
	%tmp202 = load i8, i8* %tmp201
	%tmp203 = icmp eq i8 %tmp202, 39
	br i1 %tmp203, label %then62, label %endif62
then62:
	%tmp204 = load i1, i1* %v10
	br i1 %tmp204, label %then63, label %else63
then63:
	store i1 false, i1* %v10
	%tmp205 = load i32, i32* %v9
	%tmp206 = add i32 %tmp205, 1
	store i32 %tmp206, i32* %v9
	br label %loop_body60
else63:
	%tmp207 = load i32, i32* %v9
	%tmp208 = add i32 %tmp207, 1
	store i32 %tmp208, i32* %v9
	br label %loop_body60_exit
	br label %endif62
endif62:
	%tmp209 = load i32, i32* %v9
	%tmp210 = load i8*, i8** %data
	%tmp211 = getelementptr inbounds i8, i8* %tmp210, i32 %tmp209
	%tmp212 = load i8, i8* %tmp211
	%tmp213 = icmp eq i8 %tmp212, 92
	br i1 %tmp213, label %then64, label %endif64
then64:
	%tmp214 = load i1, i1* %v10
	%tmp215 = xor i1 1, %tmp214
	store i1 %tmp215, i1* %v10
	%tmp216 = load i32, i32* %v9
	%tmp217 = add i32 %tmp216, 1
	store i32 %tmp217, i32* %v9
	br label %loop_body60
endif64:
	%tmp218 = load i1, i1* %v10
	br i1 %tmp218, label %then65, label %endif65
then65:
	store i1 false, i1* %v10
	br label %endif65
endif65:
	%tmp219 = load i32, i32* %v9
	%tmp220 = add i32 %tmp219, 1
	store i32 %tmp220, i32* %v9
	br label %loop_body60
loop_body60:
	br label %loop_start60
loop_body60_exit:
	%tmp221 = load i8*, i8** %data
	%tmp222 = load i32, i32* %v0
	%tmp223 = load i32, i32* %v9
	call void @handle_char(i8* %tmp221, i32 %tmp222, i32 %tmp223, %"struct.vector.Vec<%struct.TokenData>"* %token_vector, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector)
	%tmp224 = load i32, i32* %v9
	store i32 %tmp224, i32* %v0
	br label %loop_body0
else59:
	%tmp225 = load i8, i8* %v1
	%tmp226 = icmp eq i8 %tmp225, 47
	br i1 %tmp226, label %logic_rhs_66, label %logic_end_66
logic_rhs_66:
	%tmp227 = load i8, i8* %v2
	%tmp228 = icmp eq i8 %tmp227, 47
	br label %logic_end_66
logic_end_66:
	%tmp229 = phi i1 [%tmp226, %else59], [%tmp228, %logic_rhs_66]
	br i1 %tmp229, label %then67, label %else67
then67:
	%tmp230 = load i32, i32* %v0
	%tmp231 = add i32 %tmp230, 2
	store i32 %tmp231, i32* %v11
	br label %loop_start68
loop_start68:
	%tmp232 = load i32, i32* %v11
	%tmp233 = getelementptr inbounds %struct.string.String, %struct.string.String* %data, i32 0, i32 1
	%tmp234 = load i32, i32* %tmp233
	%tmp235 = icmp ult i32 %tmp232, %tmp234
	br i1 %tmp235, label %endif69, label %else69
else69:
	br label %loop_body68_exit
endif69:
	%tmp236 = load i32, i32* %v11
	%tmp237 = load i8*, i8** %data
	%tmp238 = getelementptr inbounds i8, i8* %tmp237, i32 %tmp236
	%tmp239 = load i8, i8* %tmp238
	%tmp240 = icmp eq i8 %tmp239, 10
	br i1 %tmp240, label %then70, label %endif70
then70:
	%tmp241 = load i32, i32* %v11
	%tmp242 = add i32 %tmp241, 1
	store i32 %tmp242, i32* %v11
	br label %loop_body68_exit
endif70:
	%tmp243 = load i32, i32* %v11
	%tmp244 = add i32 %tmp243, 1
	store i32 %tmp244, i32* %v11
	br label %loop_start68
loop_body68_exit:
	%tmp245 = load i32, i32* %v11
	%tmp246 = load i32, i32* %v0
	%tmp247 = sub i32 %tmp245, %tmp246
	store i32 %tmp247, i32* %v12
	%tmp248 = load i8*, i8** %data
	%tmp249 = load i32, i32* %v0
	%tmp250 = getelementptr inbounds i8, i8* %tmp248, i32 %tmp249
	%tmp251 = load i32, i32* %v12
	%tmp252 = sext i32 %tmp251 to i64
	call void @mem.fill(i8 0, i8* %tmp250, i64 %tmp252)
	%tmp253 = load i32, i32* %v11
	store i32 %tmp253, i32* %v0
	br label %loop_body0
else67:
	%tmp254 = load i8, i8* %v1
	%tmp255 = icmp eq i8 %tmp254, 47
	br i1 %tmp255, label %logic_rhs_71, label %logic_end_71
logic_rhs_71:
	%tmp256 = load i8, i8* %v2
	%tmp257 = icmp eq i8 %tmp256, 42
	br label %logic_end_71
logic_end_71:
	%tmp258 = phi i1 [%tmp255, %else67], [%tmp257, %logic_rhs_71]
	br i1 %tmp258, label %then72, label %endif72
then72:
	%tmp259 = load i32, i32* %v0
	%tmp260 = add i32 %tmp259, 2
	store i32 %tmp260, i32* %v13
	store i32 1, i32* %v14
	store i1 false, i1* %v15
	br label %loop_start73
loop_start73:
	%tmp261 = load i32, i32* %v13
	%tmp262 = getelementptr inbounds %struct.string.String, %struct.string.String* %data, i32 0, i32 1
	%tmp263 = load i32, i32* %tmp262
	%tmp264 = icmp ult i32 %tmp261, %tmp263
	br i1 %tmp264, label %endif74, label %else74
else74:
	br label %loop_body73_exit
endif74:
	%tmp265 = load i32, i32* %v13
	%tmp266 = add i32 %tmp265, 1
	%tmp267 = getelementptr inbounds %struct.string.String, %struct.string.String* %data, i32 0, i32 1
	%tmp268 = load i32, i32* %tmp267
	%tmp269 = icmp ult i32 %tmp266, %tmp268
	br i1 %tmp269, label %then75, label %endif75
then75:
	%tmp270 = load i32, i32* %v13
	%tmp271 = load i8*, i8** %data
	%tmp272 = getelementptr inbounds i8, i8* %tmp271, i32 %tmp270
	%tmp273 = load i8, i8* %tmp272
	%tmp274 = icmp eq i8 %tmp273, 47
	br i1 %tmp274, label %logic_rhs_76, label %logic_end_76
logic_rhs_76:
	%tmp275 = load i32, i32* %v13
	%tmp276 = add i32 %tmp275, 1
	%tmp277 = load i8*, i8** %data
	%tmp278 = getelementptr inbounds i8, i8* %tmp277, i32 %tmp276
	%tmp279 = load i8, i8* %tmp278
	%tmp280 = icmp eq i8 %tmp279, 42
	br label %logic_end_76
logic_end_76:
	%tmp281 = phi i1 [%tmp274, %then75], [%tmp280, %logic_rhs_76]
	br i1 %tmp281, label %then77, label %endif77
then77:
	%tmp282 = load i32, i32* %v14
	%tmp283 = add i32 %tmp282, 1
	store i32 %tmp283, i32* %v14
	%tmp284 = load i32, i32* %v13
	%tmp285 = add i32 %tmp284, 2
	store i32 %tmp285, i32* %v13
	br label %loop_body73
endif77:
	%tmp286 = load i32, i32* %v13
	%tmp287 = load i8*, i8** %data
	%tmp288 = getelementptr inbounds i8, i8* %tmp287, i32 %tmp286
	%tmp289 = load i8, i8* %tmp288
	%tmp290 = icmp eq i8 %tmp289, 42
	br i1 %tmp290, label %logic_rhs_78, label %logic_end_78
logic_rhs_78:
	%tmp291 = load i32, i32* %v13
	%tmp292 = add i32 %tmp291, 1
	%tmp293 = load i8*, i8** %data
	%tmp294 = getelementptr inbounds i8, i8* %tmp293, i32 %tmp292
	%tmp295 = load i8, i8* %tmp294
	%tmp296 = icmp eq i8 %tmp295, 47
	br label %logic_end_78
logic_end_78:
	%tmp297 = phi i1 [%tmp290, %endif77], [%tmp296, %logic_rhs_78]
	br i1 %tmp297, label %then79, label %endif79
then79:
	%tmp298 = load i32, i32* %v14
	%tmp299 = sub i32 %tmp298, 1
	store i32 %tmp299, i32* %v14
	%tmp300 = load i32, i32* %v13
	%tmp301 = add i32 %tmp300, 2
	store i32 %tmp301, i32* %v13
	%tmp302 = load i32, i32* %v14
	%tmp303 = icmp eq i32 %tmp302, 0
	br i1 %tmp303, label %then80, label %endif80
then80:
	br label %loop_body73_exit
endif80:
	br label %loop_body73
endif79:
	br label %endif75
endif75:
	%tmp304 = load i32, i32* %v13
	%tmp305 = add i32 %tmp304, 1
	store i32 %tmp305, i32* %v13
	br label %loop_body73
loop_body73:
	br label %loop_start73
loop_body73_exit:
	%tmp306 = load i32, i32* %v13
	%tmp307 = load i32, i32* %v0
	%tmp308 = sub i32 %tmp306, %tmp307
	store i32 %tmp308, i32* %v16
	%tmp309 = load i8*, i8** %data
	%tmp310 = load i32, i32* %v0
	%tmp311 = getelementptr inbounds i8, i8* %tmp309, i32 %tmp310
	%tmp312 = load i32, i32* %v16
	%tmp313 = sext i32 %tmp312 to i64
	call void @mem.fill(i8 0, i8* %tmp311, i64 %tmp313)
	%tmp314 = load i32, i32* %v13
	store i32 %tmp314, i32* %v0
	br label %loop_body0
endif72:
	store i8 70, i8* %v17
	%tmp315 = load i8, i8* %v1
	%tmp316 = icmp eq i8 %tmp315, 35
	br i1 %tmp316, label %then81, label %else81
then81:
	store i8 14, i8* %v17
	%tmp317 = load i32, i32* %v0
	%tmp318 = load i8*, i8** %data
	%tmp319 = getelementptr inbounds i8, i8* %tmp318, i32 %tmp317
	store i8 32, i8* %tmp319
	%tmp320 = load i32, i32* %v0
	%tmp321 = add i32 %tmp320, 1
	store i32 %tmp321, i32* %v0
	br label %endif81
else81:
	%tmp322 = load i8, i8* %v1
	%tmp323 = icmp eq i8 %tmp322, 40
	br i1 %tmp323, label %then82, label %else82
then82:
	store i8 0, i8* %v17
	%tmp324 = load i32, i32* %v0
	%tmp325 = load i8*, i8** %data
	%tmp326 = getelementptr inbounds i8, i8* %tmp325, i32 %tmp324
	store i8 32, i8* %tmp326
	%tmp327 = load i32, i32* %v0
	%tmp328 = add i32 %tmp327, 1
	store i32 %tmp328, i32* %v0
	br label %endif82
else82:
	%tmp329 = load i8, i8* %v1
	%tmp330 = icmp eq i8 %tmp329, 41
	br i1 %tmp330, label %then83, label %else83
then83:
	store i8 1, i8* %v17
	%tmp331 = load i32, i32* %v0
	%tmp332 = load i8*, i8** %data
	%tmp333 = getelementptr inbounds i8, i8* %tmp332, i32 %tmp331
	store i8 32, i8* %tmp333
	%tmp334 = load i32, i32* %v0
	%tmp335 = add i32 %tmp334, 1
	store i32 %tmp335, i32* %v0
	br label %endif83
else83:
	%tmp336 = load i8, i8* %v1
	%tmp337 = icmp eq i8 %tmp336, 123
	br i1 %tmp337, label %then84, label %else84
then84:
	store i8 2, i8* %v17
	%tmp338 = load i32, i32* %v0
	%tmp339 = load i8*, i8** %data
	%tmp340 = getelementptr inbounds i8, i8* %tmp339, i32 %tmp338
	store i8 32, i8* %tmp340
	%tmp341 = load i32, i32* %v0
	%tmp342 = add i32 %tmp341, 1
	store i32 %tmp342, i32* %v0
	br label %endif84
else84:
	%tmp343 = load i8, i8* %v1
	%tmp344 = icmp eq i8 %tmp343, 125
	br i1 %tmp344, label %then85, label %else85
then85:
	store i8 3, i8* %v17
	%tmp345 = load i32, i32* %v0
	%tmp346 = load i8*, i8** %data
	%tmp347 = getelementptr inbounds i8, i8* %tmp346, i32 %tmp345
	store i8 32, i8* %tmp347
	%tmp348 = load i32, i32* %v0
	%tmp349 = add i32 %tmp348, 1
	store i32 %tmp349, i32* %v0
	br label %endif85
else85:
	%tmp350 = load i8, i8* %v1
	%tmp351 = icmp eq i8 %tmp350, 91
	br i1 %tmp351, label %then86, label %else86
then86:
	store i8 4, i8* %v17
	%tmp352 = load i32, i32* %v0
	%tmp353 = load i8*, i8** %data
	%tmp354 = getelementptr inbounds i8, i8* %tmp353, i32 %tmp352
	store i8 32, i8* %tmp354
	%tmp355 = load i32, i32* %v0
	%tmp356 = add i32 %tmp355, 1
	store i32 %tmp356, i32* %v0
	br label %endif86
else86:
	%tmp357 = load i8, i8* %v1
	%tmp358 = icmp eq i8 %tmp357, 93
	br i1 %tmp358, label %then87, label %else87
then87:
	store i8 5, i8* %v17
	%tmp359 = load i32, i32* %v0
	%tmp360 = load i8*, i8** %data
	%tmp361 = getelementptr inbounds i8, i8* %tmp360, i32 %tmp359
	store i8 32, i8* %tmp361
	%tmp362 = load i32, i32* %v0
	%tmp363 = add i32 %tmp362, 1
	store i32 %tmp363, i32* %v0
	br label %endif87
else87:
	%tmp364 = load i8, i8* %v1
	%tmp365 = icmp eq i8 %tmp364, 58
	br i1 %tmp365, label %then88, label %else88
then88:
	%tmp366 = load i8, i8* %v2
	%tmp367 = icmp eq i8 %tmp366, 58
	br i1 %tmp367, label %then89, label %else89
then89:
	store i8 7, i8* %v17
	%tmp368 = load i32, i32* %v0
	%tmp369 = load i8*, i8** %data
	%tmp370 = getelementptr inbounds i8, i8* %tmp369, i32 %tmp368
	store i8 32, i8* %tmp370
	%tmp371 = load i32, i32* %v0
	%tmp372 = add i32 %tmp371, 1
	%tmp373 = load i8*, i8** %data
	%tmp374 = getelementptr inbounds i8, i8* %tmp373, i32 %tmp372
	store i8 32, i8* %tmp374
	%tmp375 = load i32, i32* %v0
	%tmp376 = add i32 %tmp375, 2
	store i32 %tmp376, i32* %v0
	br label %endif89
else89:
	store i8 6, i8* %v17
	%tmp377 = load i32, i32* %v0
	%tmp378 = load i8*, i8** %data
	%tmp379 = getelementptr inbounds i8, i8* %tmp378, i32 %tmp377
	store i8 32, i8* %tmp379
	%tmp380 = load i32, i32* %v0
	%tmp381 = add i32 %tmp380, 1
	store i32 %tmp381, i32* %v0
	br label %endif89
endif89:
	br label %endif88
else88:
	%tmp382 = load i8, i8* %v1
	%tmp383 = icmp eq i8 %tmp382, 61
	br i1 %tmp383, label %then90, label %else90
then90:
	%tmp384 = load i8, i8* %v2
	%tmp385 = icmp eq i8 %tmp384, 61
	br i1 %tmp385, label %then91, label %else91
then91:
	store i8 22, i8* %v17
	%tmp386 = load i32, i32* %v0
	%tmp387 = load i8*, i8** %data
	%tmp388 = getelementptr inbounds i8, i8* %tmp387, i32 %tmp386
	store i8 32, i8* %tmp388
	%tmp389 = load i32, i32* %v0
	%tmp390 = add i32 %tmp389, 1
	%tmp391 = load i8*, i8** %data
	%tmp392 = getelementptr inbounds i8, i8* %tmp391, i32 %tmp390
	store i8 32, i8* %tmp392
	%tmp393 = load i32, i32* %v0
	%tmp394 = add i32 %tmp393, 2
	store i32 %tmp394, i32* %v0
	br label %endif91
else91:
	%tmp395 = load i8, i8* %v2
	%tmp396 = icmp eq i8 %tmp395, 62
	br i1 %tmp396, label %then92, label %else92
then92:
	store i8 13, i8* %v17
	%tmp397 = load i32, i32* %v0
	%tmp398 = load i8*, i8** %data
	%tmp399 = getelementptr inbounds i8, i8* %tmp398, i32 %tmp397
	store i8 32, i8* %tmp399
	%tmp400 = load i32, i32* %v0
	%tmp401 = add i32 %tmp400, 1
	%tmp402 = load i8*, i8** %data
	%tmp403 = getelementptr inbounds i8, i8* %tmp402, i32 %tmp401
	store i8 32, i8* %tmp403
	%tmp404 = load i32, i32* %v0
	%tmp405 = add i32 %tmp404, 2
	store i32 %tmp405, i32* %v0
	br label %endif92
else92:
	store i8 15, i8* %v17
	%tmp406 = load i32, i32* %v0
	%tmp407 = load i8*, i8** %data
	%tmp408 = getelementptr inbounds i8, i8* %tmp407, i32 %tmp406
	store i8 32, i8* %tmp408
	%tmp409 = load i32, i32* %v0
	%tmp410 = add i32 %tmp409, 1
	store i32 %tmp410, i32* %v0
	br label %endif92
endif92:
	br label %endif91
endif91:
	br label %endif90
else90:
	%tmp411 = load i8, i8* %v1
	%tmp412 = icmp eq i8 %tmp411, 59
	br i1 %tmp412, label %then93, label %else93
then93:
	store i8 8, i8* %v17
	%tmp413 = load i32, i32* %v0
	%tmp414 = load i8*, i8** %data
	%tmp415 = getelementptr inbounds i8, i8* %tmp414, i32 %tmp413
	store i8 32, i8* %tmp415
	%tmp416 = load i32, i32* %v0
	%tmp417 = add i32 %tmp416, 1
	store i32 %tmp417, i32* %v0
	br label %endif93
else93:
	%tmp418 = load i8, i8* %v1
	%tmp419 = icmp eq i8 %tmp418, 44
	br i1 %tmp419, label %then94, label %else94
then94:
	store i8 9, i8* %v17
	%tmp420 = load i32, i32* %v0
	%tmp421 = load i8*, i8** %data
	%tmp422 = getelementptr inbounds i8, i8* %tmp421, i32 %tmp420
	store i8 32, i8* %tmp422
	%tmp423 = load i32, i32* %v0
	%tmp424 = add i32 %tmp423, 1
	store i32 %tmp424, i32* %v0
	br label %endif94
else94:
	%tmp425 = load i8, i8* %v1
	%tmp426 = icmp eq i8 %tmp425, 43
	br i1 %tmp426, label %then95, label %else95
then95:
	store i8 16, i8* %v17
	%tmp427 = load i32, i32* %v0
	%tmp428 = load i8*, i8** %data
	%tmp429 = getelementptr inbounds i8, i8* %tmp428, i32 %tmp427
	store i8 32, i8* %tmp429
	%tmp430 = load i32, i32* %v0
	%tmp431 = add i32 %tmp430, 1
	store i32 %tmp431, i32* %v0
	br label %endif95
else95:
	%tmp432 = load i8, i8* %v1
	%tmp433 = icmp eq i8 %tmp432, 45
	br i1 %tmp433, label %then96, label %else96
then96:
	store i8 17, i8* %v17
	%tmp434 = load i32, i32* %v0
	%tmp435 = load i8*, i8** %data
	%tmp436 = getelementptr inbounds i8, i8* %tmp435, i32 %tmp434
	store i8 32, i8* %tmp436
	%tmp437 = load i32, i32* %v0
	%tmp438 = add i32 %tmp437, 1
	store i32 %tmp438, i32* %v0
	br label %endif96
else96:
	%tmp439 = load i8, i8* %v1
	%tmp440 = icmp eq i8 %tmp439, 42
	br i1 %tmp440, label %then97, label %else97
then97:
	store i8 18, i8* %v17
	%tmp441 = load i32, i32* %v0
	%tmp442 = load i8*, i8** %data
	%tmp443 = getelementptr inbounds i8, i8* %tmp442, i32 %tmp441
	store i8 32, i8* %tmp443
	%tmp444 = load i32, i32* %v0
	%tmp445 = add i32 %tmp444, 1
	store i32 %tmp445, i32* %v0
	br label %endif97
else97:
	%tmp446 = load i8, i8* %v1
	%tmp447 = icmp eq i8 %tmp446, 47
	br i1 %tmp447, label %then98, label %else98
then98:
	store i8 19, i8* %v17
	%tmp448 = load i32, i32* %v0
	%tmp449 = load i8*, i8** %data
	%tmp450 = getelementptr inbounds i8, i8* %tmp449, i32 %tmp448
	store i8 32, i8* %tmp450
	%tmp451 = load i32, i32* %v0
	%tmp452 = add i32 %tmp451, 1
	store i32 %tmp452, i32* %v0
	br label %endif98
else98:
	%tmp453 = load i8, i8* %v1
	%tmp454 = icmp eq i8 %tmp453, 37
	br i1 %tmp454, label %then99, label %else99
then99:
	store i8 20, i8* %v17
	%tmp455 = load i32, i32* %v0
	%tmp456 = load i8*, i8** %data
	%tmp457 = getelementptr inbounds i8, i8* %tmp456, i32 %tmp455
	store i8 32, i8* %tmp457
	%tmp458 = load i32, i32* %v0
	%tmp459 = add i32 %tmp458, 1
	store i32 %tmp459, i32* %v0
	br label %endif99
else99:
	%tmp460 = load i8, i8* %v1
	%tmp461 = icmp eq i8 %tmp460, 33
	br i1 %tmp461, label %then100, label %else100
then100:
	%tmp462 = load i8, i8* %v2
	%tmp463 = icmp eq i8 %tmp462, 61
	br i1 %tmp463, label %then101, label %else101
then101:
	store i8 23, i8* %v17
	%tmp464 = load i32, i32* %v0
	%tmp465 = load i8*, i8** %data
	%tmp466 = getelementptr inbounds i8, i8* %tmp465, i32 %tmp464
	store i8 32, i8* %tmp466
	%tmp467 = load i32, i32* %v0
	%tmp468 = add i32 %tmp467, 1
	%tmp469 = load i8*, i8** %data
	%tmp470 = getelementptr inbounds i8, i8* %tmp469, i32 %tmp468
	store i8 32, i8* %tmp470
	%tmp471 = load i32, i32* %v0
	%tmp472 = add i32 %tmp471, 2
	store i32 %tmp472, i32* %v0
	br label %endif101
else101:
	store i8 21, i8* %v17
	%tmp473 = load i32, i32* %v0
	%tmp474 = load i8*, i8** %data
	%tmp475 = getelementptr inbounds i8, i8* %tmp474, i32 %tmp473
	store i8 32, i8* %tmp475
	%tmp476 = load i32, i32* %v0
	%tmp477 = add i32 %tmp476, 1
	store i32 %tmp477, i32* %v0
	br label %endif101
endif101:
	br label %endif100
else100:
	%tmp478 = load i8, i8* %v1
	%tmp479 = icmp eq i8 %tmp478, 38
	br i1 %tmp479, label %then102, label %else102
then102:
	%tmp480 = load i8, i8* %v2
	%tmp481 = icmp eq i8 %tmp480, 38
	br i1 %tmp481, label %then103, label %else103
then103:
	store i8 25, i8* %v17
	%tmp482 = load i32, i32* %v0
	%tmp483 = load i8*, i8** %data
	%tmp484 = getelementptr inbounds i8, i8* %tmp483, i32 %tmp482
	store i8 32, i8* %tmp484
	%tmp485 = load i32, i32* %v0
	%tmp486 = add i32 %tmp485, 1
	%tmp487 = load i8*, i8** %data
	%tmp488 = getelementptr inbounds i8, i8* %tmp487, i32 %tmp486
	store i8 32, i8* %tmp488
	%tmp489 = load i32, i32* %v0
	%tmp490 = add i32 %tmp489, 2
	store i32 %tmp490, i32* %v0
	br label %endif103
else103:
	store i8 32, i8* %v17
	%tmp491 = load i32, i32* %v0
	%tmp492 = load i8*, i8** %data
	%tmp493 = getelementptr inbounds i8, i8* %tmp492, i32 %tmp491
	store i8 32, i8* %tmp493
	%tmp494 = load i32, i32* %v0
	%tmp495 = add i32 %tmp494, 1
	store i32 %tmp495, i32* %v0
	br label %endif103
endif103:
	br label %endif102
else102:
	%tmp496 = load i8, i8* %v1
	%tmp497 = icmp eq i8 %tmp496, 124
	br i1 %tmp497, label %then104, label %else104
then104:
	%tmp498 = load i8, i8* %v2
	%tmp499 = icmp eq i8 %tmp498, 124
	br i1 %tmp499, label %then105, label %else105
then105:
	store i8 24, i8* %v17
	%tmp500 = load i32, i32* %v0
	%tmp501 = load i8*, i8** %data
	%tmp502 = getelementptr inbounds i8, i8* %tmp501, i32 %tmp500
	store i8 32, i8* %tmp502
	%tmp503 = load i32, i32* %v0
	%tmp504 = add i32 %tmp503, 1
	%tmp505 = load i8*, i8** %data
	%tmp506 = getelementptr inbounds i8, i8* %tmp505, i32 %tmp504
	store i8 32, i8* %tmp506
	%tmp507 = load i32, i32* %v0
	%tmp508 = add i32 %tmp507, 2
	store i32 %tmp508, i32* %v0
	br label %endif105
else105:
	store i8 31, i8* %v17
	%tmp509 = load i32, i32* %v0
	%tmp510 = load i8*, i8** %data
	%tmp511 = getelementptr inbounds i8, i8* %tmp510, i32 %tmp509
	store i8 32, i8* %tmp511
	%tmp512 = load i32, i32* %v0
	%tmp513 = add i32 %tmp512, 1
	store i32 %tmp513, i32* %v0
	br label %endif105
endif105:
	br label %endif104
else104:
	%tmp514 = load i8, i8* %v1
	%tmp515 = icmp eq i8 %tmp514, 46
	br i1 %tmp515, label %then106, label %else106
then106:
	%tmp516 = load i8, i8* %v2
	%tmp517 = icmp eq i8 %tmp516, 46
	br i1 %tmp517, label %then107, label %else107
then107:
	%tmp518 = load i8, i8* %v3
	%tmp519 = icmp eq i8 %tmp518, 61
	br i1 %tmp519, label %then108, label %else108
then108:
	store i8 12, i8* %v17
	%tmp520 = load i32, i32* %v0
	%tmp521 = load i8*, i8** %data
	%tmp522 = getelementptr inbounds i8, i8* %tmp521, i32 %tmp520
	store i8 32, i8* %tmp522
	%tmp523 = load i32, i32* %v0
	%tmp524 = add i32 %tmp523, 1
	%tmp525 = load i8*, i8** %data
	%tmp526 = getelementptr inbounds i8, i8* %tmp525, i32 %tmp524
	store i8 32, i8* %tmp526
	%tmp527 = load i32, i32* %v0
	%tmp528 = add i32 %tmp527, 2
	%tmp529 = load i8*, i8** %data
	%tmp530 = getelementptr inbounds i8, i8* %tmp529, i32 %tmp528
	store i8 32, i8* %tmp530
	%tmp531 = load i32, i32* %v0
	%tmp532 = add i32 %tmp531, 3
	store i32 %tmp532, i32* %v0
	br label %endif108
else108:
	store i8 11, i8* %v17
	%tmp533 = load i32, i32* %v0
	%tmp534 = load i8*, i8** %data
	%tmp535 = getelementptr inbounds i8, i8* %tmp534, i32 %tmp533
	store i8 32, i8* %tmp535
	%tmp536 = load i32, i32* %v0
	%tmp537 = add i32 %tmp536, 1
	%tmp538 = load i8*, i8** %data
	%tmp539 = getelementptr inbounds i8, i8* %tmp538, i32 %tmp537
	store i8 32, i8* %tmp539
	%tmp540 = load i32, i32* %v0
	%tmp541 = add i32 %tmp540, 2
	store i32 %tmp541, i32* %v0
	br label %endif108
endif108:
	br label %endif107
else107:
	store i8 10, i8* %v17
	%tmp542 = load i32, i32* %v0
	%tmp543 = load i8*, i8** %data
	%tmp544 = getelementptr inbounds i8, i8* %tmp543, i32 %tmp542
	store i8 32, i8* %tmp544
	%tmp545 = load i32, i32* %v0
	%tmp546 = add i32 %tmp545, 1
	store i32 %tmp546, i32* %v0
	br label %endif107
endif107:
	br label %endif106
else106:
	%tmp547 = load i8, i8* %v1
	%tmp548 = icmp eq i8 %tmp547, 60
	br i1 %tmp548, label %then109, label %else109
then109:
	%tmp549 = load i8, i8* %v2
	%tmp550 = icmp eq i8 %tmp549, 61
	br i1 %tmp550, label %then110, label %else110
then110:
	store i8 29, i8* %v17
	%tmp551 = load i32, i32* %v0
	%tmp552 = load i8*, i8** %data
	%tmp553 = getelementptr inbounds i8, i8* %tmp552, i32 %tmp551
	store i8 32, i8* %tmp553
	%tmp554 = load i32, i32* %v0
	%tmp555 = add i32 %tmp554, 1
	%tmp556 = load i8*, i8** %data
	%tmp557 = getelementptr inbounds i8, i8* %tmp556, i32 %tmp555
	store i8 32, i8* %tmp557
	%tmp558 = load i32, i32* %v0
	%tmp559 = add i32 %tmp558, 2
	store i32 %tmp559, i32* %v0
	br label %endif110
else110:
	store i8 28, i8* %v17
	%tmp560 = load i32, i32* %v0
	%tmp561 = load i8*, i8** %data
	%tmp562 = getelementptr inbounds i8, i8* %tmp561, i32 %tmp560
	store i8 32, i8* %tmp562
	%tmp563 = load i32, i32* %v0
	%tmp564 = add i32 %tmp563, 1
	store i32 %tmp564, i32* %v0
	br label %endif110
endif110:
	br label %endif109
else109:
	%tmp565 = load i8, i8* %v1
	%tmp566 = icmp eq i8 %tmp565, 62
	br i1 %tmp566, label %then111, label %else111
then111:
	%tmp567 = load i8, i8* %v2
	%tmp568 = icmp eq i8 %tmp567, 61
	br i1 %tmp568, label %then112, label %else112
then112:
	store i8 27, i8* %v17
	%tmp569 = load i32, i32* %v0
	%tmp570 = load i8*, i8** %data
	%tmp571 = getelementptr inbounds i8, i8* %tmp570, i32 %tmp569
	store i8 32, i8* %tmp571
	%tmp572 = load i32, i32* %v0
	%tmp573 = add i32 %tmp572, 1
	%tmp574 = load i8*, i8** %data
	%tmp575 = getelementptr inbounds i8, i8* %tmp574, i32 %tmp573
	store i8 32, i8* %tmp575
	%tmp576 = load i32, i32* %v0
	%tmp577 = add i32 %tmp576, 2
	store i32 %tmp577, i32* %v0
	br label %endif112
else112:
	store i8 26, i8* %v17
	%tmp578 = load i32, i32* %v0
	%tmp579 = load i8*, i8** %data
	%tmp580 = getelementptr inbounds i8, i8* %tmp579, i32 %tmp578
	store i8 32, i8* %tmp580
	%tmp581 = load i32, i32* %v0
	%tmp582 = add i32 %tmp581, 1
	store i32 %tmp582, i32* %v0
	br label %endif112
endif112:
	br label %endif111
else111:
	%tmp583 = load i8, i8* %v1
	%tmp584 = icmp eq i8 %tmp583, 126
	br i1 %tmp584, label %then113, label %endif113
then113:
	store i8 30, i8* %v17
	%tmp585 = load i32, i32* %v0
	%tmp586 = load i8*, i8** %data
	%tmp587 = getelementptr inbounds i8, i8* %tmp586, i32 %tmp585
	store i8 32, i8* %tmp587
	%tmp588 = load i32, i32* %v0
	%tmp589 = add i32 %tmp588, 1
	store i32 %tmp589, i32* %v0
	br label %endif113
endif113:
	br label %endif111
endif111:
	br label %endif109
endif109:
	br label %endif106
endif106:
	br label %endif104
endif104:
	br label %endif102
endif102:
	br label %endif100
endif100:
	br label %endif99
endif99:
	br label %endif98
endif98:
	br label %endif97
endif97:
	br label %endif96
endif96:
	br label %endif95
endif95:
	br label %endif94
endif94:
	br label %endif93
endif93:
	br label %endif90
endif90:
	br label %endif88
endif88:
	br label %endif87
endif87:
	br label %endif86
endif86:
	br label %endif85
endif85:
	br label %endif84
endif84:
	br label %endif83
endif83:
	br label %endif82
endif82:
	br label %endif81
endif81:
	%tmp590 = load i8, i8* %v17
	%tmp591 = icmp ne i8 %tmp590, 70
	br i1 %tmp591, label %then114, label %endif114
then114:
	%tmp592 = load i8, i8* %v17
	%tmp593 = load i32, i32* %v0
	store i8 %tmp592, i8* %v18
	%tmp594 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v18, i32 0, i32 1
	store i16 0, i16* %tmp594
	%tmp595 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v18, i32 0, i32 2
	store i32 %tmp593, i32* %tmp595
	%tmp596 = load %struct.TokenData, %struct.TokenData* %v18
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %token_vector, %struct.TokenData %tmp596)
	br label %loop_body0
; Variable temp is out.
endif114:
	call void @console.write(i8* @.str.22, i32 8)
	%tmp597 = load i32, i32* %v0
	%tmp598 = zext i32 %tmp597 to i64
	call void @console.println_i64(i64 %tmp598)
	%tmp599 = load i32, i32* %v0
	%tmp600 = load i8*, i8** %data
	%tmp601 = getelementptr inbounds i8, i8* %tmp600, i32 %tmp599
	%tmp602 = load i8, i8* %tmp601
	%tmp603 = sext i8 %tmp602 to i64
	call void @console.println_i64(i64 %tmp603)
	call void @process.throw(i8* @.str.23)
	br label %loop_body0
loop_body0:
	br label %loop_start0
loop_body0_exit:
	ret void
}
define i32 @_fltused(){
	ret i32 0
}
define void @__chkstk(){
	ret void
}
define i8* @string_utils.insert(i8* %src1, i8* %src2, i32 %index){
	%tmp0 = call i32 @string_utils.c_str_len(i8* %src1)
	%tmp1 = call i32 @string_utils.c_str_len(i8* %src2)
	%tmp2 = add i32 %tmp0, %tmp1
	%tmp3 = add i32 %tmp2, 1
	%tmp4 = sext i32 %tmp3 to i64
	%tmp5 = call i8* @mem.malloc(i64 %tmp4)
	%tmp6 = sext i32 %index to i64
	call void @mem.copy(i8* %src1, i8* %tmp5, i64 %tmp6)
	%tmp7 = getelementptr inbounds i8, i8* %tmp5, i32 %index
	%tmp8 = sext i32 %tmp1 to i64
	call void @mem.copy(i8* %src2, i8* %tmp7, i64 %tmp8)
	%tmp9 = getelementptr inbounds i8, i8* %src1, i32 %index
	%tmp10 = getelementptr inbounds i8, i8* %tmp5, i32 %index
	%tmp11 = getelementptr inbounds i8, i8* %tmp10, i32 %tmp1
	%tmp12 = sub i32 %tmp0, %index
	%tmp13 = sext i32 %tmp12 to i64
	call void @mem.copy(i8* %tmp9, i8* %tmp11, i64 %tmp13)
	%tmp14 = add i32 %tmp0, %tmp1
	%tmp15 = getelementptr inbounds i8, i8* %tmp5, i32 %tmp14
	store i8 0, i8* %tmp15
	ret i8* %tmp5
}
define %struct.string.String @string.with_size(i32 %size){
	%v0 = alloca %struct.string.String
	%tmp0 = add i32 %size, 1
	%tmp1 = sext i32 %tmp0 to i64
	%tmp2 = mul i64 1, %tmp1
	%tmp3 = call i8* @mem.malloc(i64 %tmp2)
	store i8* %tmp3, i8** %v0
	%tmp4 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	store i32 %size, i32* %tmp4
	%tmp5 = load i8*, i8** %v0
	%tmp6 = add i32 %size, 1
	%tmp7 = sext i32 %tmp6 to i64
	call void @mem.zero_fill(i8* %tmp5, i64 %tmp7)
	%tmp8 = load %struct.string.String, %struct.string.String* %v0
; Variable x is out.
	ret %struct.string.String %tmp8
}
define %struct.string.String @string.empty(){
	%v0 = alloca %struct.string.String
	store i8* null, i8** %v0
	%tmp0 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	store i32 0, i32* %tmp0
	%tmp1 = load %struct.string.String, %struct.string.String* %v0
; Variable x is out.
	ret %struct.string.String %tmp1
}
define void @process.throw(i8* %exception){
	%tmp0 = call i32 @string_utils.c_str_len(i8* %exception)
	call i32 @AllocConsole()
	%tmp1 = call i8* @GetStdHandle(i32 -11)
	call void @console.writeln(i8* @.str.24, i32 11)
	call void @console.writeln(i8* %exception, i32 %tmp0)
	call void @ExitProcess(i32 -1)
	ret void
}
define i8* @mem.malloc(i64 %size){
	%tmp0 = call i32* @GetProcessHeap()
	%tmp1 = call i8* @HeapAlloc(i32* %tmp0, i32 0, i64 %size)
	%tmp2 = icmp eq i8* %tmp1, null
	br i1 %tmp2, label %then0, label %endif0
then0:
	call void @process.throw(i8* @.str.25)
	br label %endif0
endif0:
	ret i8* %tmp1
}
define void @mem.free(i8* %ptr){
	%tmp0 = icmp ne i8* %ptr, null
	br i1 %tmp0, label %then0, label %endif0
then0:
	%tmp1 = call i32* @GetProcessHeap()
	call i32 @HeapFree(i32* %tmp1, i32 0, i8* %ptr)
	br label %endif0
endif0:
	ret void
}
define void @mem.fill(i8 %val, i8* %dest, i64 %len){
	call void @"mem.default_fill<i8>"(i8 %val, i8* %dest, i64 %len)
	ret void
}
define void @console.write_string(%struct.string.String* %str){
	%v0 = alloca i32
	%tmp0 = call i8* @console.get_stdout()
	%tmp1 = load i8*, i8** %str
	%tmp2 = getelementptr inbounds %struct.string.String, %struct.string.String* %str, i32 0, i32 1
	%tmp3 = load i32, i32* %tmp2
	call i32 @WriteConsoleA(i8* %tmp0, i8* %tmp1, i32 %tmp3, i32* %v0, i8* null)
	%tmp4 = getelementptr inbounds %struct.string.String, %struct.string.String* %str, i32 0, i32 1
	%tmp5 = load i32, i32* %tmp4
	%tmp6 = load i32, i32* %v0
	%tmp7 = icmp ne i32 %tmp5, %tmp6
	br i1 %tmp7, label %then0, label %endif0
then0:
	call void @ExitProcess(i32 -2)
	br label %endif0
endif0:
	ret void
}
define void @console.println_u64(i64 %n){
	%v0 = alloca i32
	%v1 = alloca i64
	%tmp0 = alloca i8, i64 22
	store i32 20, i32* %v0
	%tmp1 = icmp eq i64 %n, 0
	br i1 %tmp1, label %then0, label %endif0
then0:
	call void @console.write(i8* @.str.26, i32 2)
	br label %func_exit
endif0:
	store i64 %n, i64* %v1
	br label %loop_start1
loop_start1:
	%tmp2 = load i32, i32* %v0
	%tmp3 = getelementptr inbounds i8, i8* %tmp0, i32 %tmp2
	%tmp4 = load i64, i64* %v1
	%tmp5 = urem i64 %tmp4, 10
	%tmp6 = trunc i64 %tmp5 to i8
	%tmp7 = add i8 %tmp6, 48
	store i8 %tmp7, i8* %tmp3
	%tmp8 = load i64, i64* %v1
	%tmp9 = udiv i64 %tmp8, 10
	store i64 %tmp9, i64* %v1
	%tmp10 = load i32, i32* %v0
	%tmp11 = sub i32 %tmp10, 1
	store i32 %tmp11, i32* %v0
	%tmp12 = load i64, i64* %v1
	%tmp13 = icmp ne i64 %tmp12, 0
	br i1 %tmp13, label %endif2, label %else2
else2:
	br label %loop_body1_exit
endif2:
	br label %loop_start1
loop_body1_exit:
	%tmp14 = getelementptr inbounds i8, i8* %tmp0, i64 21
	store i8 10, i8* %tmp14
	%tmp15 = load i32, i32* %v0
	%tmp16 = add i32 %tmp15, 1
	%tmp17 = getelementptr inbounds i8, i8* %tmp0, i32 %tmp16
	%tmp18 = load i32, i32* %v0
	%tmp19 = sub i32 21, %tmp18
	call void @console.write(i8* %tmp17, i32 %tmp19)
	br label %func_exit
func_exit:
	ret void
}
define void @console.print_char(i8 %n){
	%v0 = alloca i8
	store i8 %n, i8* %v0
	call void @console.write(i8* %v0, i32 1)
	ret void
}
define i8* @console.get_stdout(){
	%v0 = alloca i8*
	%tmp0 = call i8* @GetStdHandle(i32 -11)
	store i8* %tmp0, i8** %v0
	%tmp1 = load i8*, i8** %v0
	%tmp2 = inttoptr i64 -1 to i8*
	%tmp3 = icmp eq i8* %tmp1, %tmp2
	br i1 %tmp3, label %then0, label %endif0
then0:
	call void @process.throw(i8* @.str.27)
	br label %endif0
endif0:
	%tmp4 = load i8*, i8** %v0
	ret i8* %tmp4
}
define %struct.string.String @token_type_to_string(%struct.TokenData* %val, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector){
	%tmp0 = icmp ne %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, null
	br i1 %tmp0, label %then0, label %endif0
then0:
	%tmp1 = load i8, i8* %val
	%tmp2 = icmp eq i8 %tmp1, 65
	br i1 %tmp2, label %then1, label %else1
then1:
	%tmp3 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %val, i32 0, i32 1
	%tmp4 = load i16, i16* %tmp3
	%tmp5 = load %struct.string.String*, %struct.string.String** %symbol_vector
	%tmp6 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp5, i16 %tmp4
	%tmp7 = call %struct.string.String @string.clone(%struct.string.String* %tmp6)
	br label %func_exit
else1:
	%tmp8 = load i8, i8* %val
	%tmp9 = icmp eq i8 %tmp8, 68
	br i1 %tmp9, label %then2, label %else2
then2:
	%tmp10 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %val, i32 0, i32 1
	%tmp11 = load i16, i16* %tmp10
	%tmp12 = load %struct.string.String*, %struct.string.String** %symbol_vector
	%tmp13 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp12, i16 %tmp11
	%tmp14 = call %struct.string.String @string.clone(%struct.string.String* %tmp13)
	br label %func_exit
else2:
	%tmp15 = load i8, i8* %val
	%tmp16 = icmp eq i8 %tmp15, 66
	br i1 %tmp16, label %then3, label %else3
then3:
	%tmp17 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %val, i32 0, i32 1
	%tmp18 = load i16, i16* %tmp17
	%tmp19 = load %struct.string.String*, %struct.string.String** %symbol_vector
	%tmp20 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp19, i16 %tmp18
	%tmp21 = call %struct.string.String @string.clone(%struct.string.String* %tmp20)
	br label %func_exit
else3:
	%tmp22 = load i8, i8* %val
	%tmp23 = icmp eq i8 %tmp22, 67
	br i1 %tmp23, label %then4, label %else4
then4:
	%tmp24 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %val, i32 0, i32 1
	%tmp25 = load i16, i16* %tmp24
	%tmp26 = load %struct.string.String*, %struct.string.String** %symbol_vector
	%tmp27 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp26, i16 %tmp25
	%tmp28 = call %struct.string.String @string.clone(%struct.string.String* %tmp27)
	br label %func_exit
else4:
	%tmp29 = load i8, i8* %val
	%tmp30 = icmp eq i8 %tmp29, 69
	br i1 %tmp30, label %then5, label %endif5
then5:
	%tmp31 = call %struct.string.String @string.from_c_string(i8* @.str.28)
	br label %func_exit
endif5:
	br label %endif0
endif0:
	%tmp32 = load i8, i8* %val
	%tmp33 = icmp eq i8 %tmp32, 0
	br i1 %tmp33, label %then6, label %else6
then6:
	%tmp34 = call %struct.string.String @string.from_c_string(i8* @.str.29)
	br label %func_exit
else6:
	%tmp35 = load i8, i8* %val
	%tmp36 = icmp eq i8 %tmp35, 1
	br i1 %tmp36, label %then7, label %else7
then7:
	%tmp37 = call %struct.string.String @string.from_c_string(i8* @.str.30)
	br label %func_exit
else7:
	%tmp38 = load i8, i8* %val
	%tmp39 = icmp eq i8 %tmp38, 2
	br i1 %tmp39, label %then8, label %else8
then8:
	%tmp40 = call %struct.string.String @string.from_c_string(i8* @.str.31)
	br label %func_exit
else8:
	%tmp41 = load i8, i8* %val
	%tmp42 = icmp eq i8 %tmp41, 3
	br i1 %tmp42, label %then9, label %else9
then9:
	%tmp43 = call %struct.string.String @string.from_c_string(i8* @.str.32)
	br label %func_exit
else9:
	%tmp44 = load i8, i8* %val
	%tmp45 = icmp eq i8 %tmp44, 4
	br i1 %tmp45, label %then10, label %else10
then10:
	%tmp46 = call %struct.string.String @string.from_c_string(i8* @.str.33)
	br label %func_exit
else10:
	%tmp47 = load i8, i8* %val
	%tmp48 = icmp eq i8 %tmp47, 5
	br i1 %tmp48, label %then11, label %else11
then11:
	%tmp49 = call %struct.string.String @string.from_c_string(i8* @.str.34)
	br label %func_exit
else11:
	%tmp50 = load i8, i8* %val
	%tmp51 = icmp eq i8 %tmp50, 6
	br i1 %tmp51, label %then12, label %else12
then12:
	%tmp52 = call %struct.string.String @string.from_c_string(i8* @.str.35)
	br label %func_exit
else12:
	%tmp53 = load i8, i8* %val
	%tmp54 = icmp eq i8 %tmp53, 7
	br i1 %tmp54, label %then13, label %else13
then13:
	%tmp55 = call %struct.string.String @string.from_c_string(i8* @.str.36)
	br label %func_exit
else13:
	%tmp56 = load i8, i8* %val
	%tmp57 = icmp eq i8 %tmp56, 8
	br i1 %tmp57, label %then14, label %else14
then14:
	%tmp58 = call %struct.string.String @string.from_c_string(i8* @.str.37)
	br label %func_exit
else14:
	%tmp59 = load i8, i8* %val
	%tmp60 = icmp eq i8 %tmp59, 9
	br i1 %tmp60, label %then15, label %else15
then15:
	%tmp61 = call %struct.string.String @string.from_c_string(i8* @.str.38)
	br label %func_exit
else15:
	%tmp62 = load i8, i8* %val
	%tmp63 = icmp eq i8 %tmp62, 10
	br i1 %tmp63, label %then16, label %else16
then16:
	%tmp64 = call %struct.string.String @string.from_c_string(i8* @.str.39)
	br label %func_exit
else16:
	%tmp65 = load i8, i8* %val
	%tmp66 = icmp eq i8 %tmp65, 11
	br i1 %tmp66, label %then17, label %else17
then17:
	%tmp67 = call %struct.string.String @string.from_c_string(i8* @.str.40)
	br label %func_exit
else17:
	%tmp68 = load i8, i8* %val
	%tmp69 = icmp eq i8 %tmp68, 12
	br i1 %tmp69, label %then18, label %else18
then18:
	%tmp70 = call %struct.string.String @string.from_c_string(i8* @.str.41)
	br label %func_exit
else18:
	%tmp71 = load i8, i8* %val
	%tmp72 = icmp eq i8 %tmp71, 13
	br i1 %tmp72, label %then19, label %else19
then19:
	%tmp73 = call %struct.string.String @string.from_c_string(i8* @.str.42)
	br label %func_exit
else19:
	%tmp74 = load i8, i8* %val
	%tmp75 = icmp eq i8 %tmp74, 14
	br i1 %tmp75, label %then20, label %else20
then20:
	%tmp76 = call %struct.string.String @string.from_c_string(i8* @.str.43)
	br label %func_exit
else20:
	%tmp77 = load i8, i8* %val
	%tmp78 = icmp eq i8 %tmp77, 15
	br i1 %tmp78, label %then21, label %else21
then21:
	%tmp79 = call %struct.string.String @string.from_c_string(i8* @.str.44)
	br label %func_exit
else21:
	%tmp80 = load i8, i8* %val
	%tmp81 = icmp eq i8 %tmp80, 16
	br i1 %tmp81, label %then22, label %else22
then22:
	%tmp82 = call %struct.string.String @string.from_c_string(i8* @.str.45)
	br label %func_exit
else22:
	%tmp83 = load i8, i8* %val
	%tmp84 = icmp eq i8 %tmp83, 17
	br i1 %tmp84, label %then23, label %else23
then23:
	%tmp85 = call %struct.string.String @string.from_c_string(i8* @.str.46)
	br label %func_exit
else23:
	%tmp86 = load i8, i8* %val
	%tmp87 = icmp eq i8 %tmp86, 18
	br i1 %tmp87, label %then24, label %else24
then24:
	%tmp88 = call %struct.string.String @string.from_c_string(i8* @.str.47)
	br label %func_exit
else24:
	%tmp89 = load i8, i8* %val
	%tmp90 = icmp eq i8 %tmp89, 19
	br i1 %tmp90, label %then25, label %else25
then25:
	%tmp91 = call %struct.string.String @string.from_c_string(i8* @.str.48)
	br label %func_exit
else25:
	%tmp92 = load i8, i8* %val
	%tmp93 = icmp eq i8 %tmp92, 20
	br i1 %tmp93, label %then26, label %else26
then26:
	%tmp94 = call %struct.string.String @string.from_c_string(i8* @.str.49)
	br label %func_exit
else26:
	%tmp95 = load i8, i8* %val
	%tmp96 = icmp eq i8 %tmp95, 21
	br i1 %tmp96, label %then27, label %else27
then27:
	%tmp97 = call %struct.string.String @string.from_c_string(i8* @.str.50)
	br label %func_exit
else27:
	%tmp98 = load i8, i8* %val
	%tmp99 = icmp eq i8 %tmp98, 22
	br i1 %tmp99, label %then28, label %else28
then28:
	%tmp100 = call %struct.string.String @string.from_c_string(i8* @.str.51)
	br label %func_exit
else28:
	%tmp101 = load i8, i8* %val
	%tmp102 = icmp eq i8 %tmp101, 23
	br i1 %tmp102, label %then29, label %else29
then29:
	%tmp103 = call %struct.string.String @string.from_c_string(i8* @.str.52)
	br label %func_exit
else29:
	%tmp104 = load i8, i8* %val
	%tmp105 = icmp eq i8 %tmp104, 24
	br i1 %tmp105, label %then30, label %else30
then30:
	%tmp106 = call %struct.string.String @string.from_c_string(i8* @.str.53)
	br label %func_exit
else30:
	%tmp107 = load i8, i8* %val
	%tmp108 = icmp eq i8 %tmp107, 25
	br i1 %tmp108, label %then31, label %else31
then31:
	%tmp109 = call %struct.string.String @string.from_c_string(i8* @.str.54)
	br label %func_exit
else31:
	%tmp110 = load i8, i8* %val
	%tmp111 = icmp eq i8 %tmp110, 26
	br i1 %tmp111, label %then32, label %else32
then32:
	%tmp112 = call %struct.string.String @string.from_c_string(i8* @.str.55)
	br label %func_exit
else32:
	%tmp113 = load i8, i8* %val
	%tmp114 = icmp eq i8 %tmp113, 27
	br i1 %tmp114, label %then33, label %else33
then33:
	%tmp115 = call %struct.string.String @string.from_c_string(i8* @.str.56)
	br label %func_exit
else33:
	%tmp116 = load i8, i8* %val
	%tmp117 = icmp eq i8 %tmp116, 28
	br i1 %tmp117, label %then34, label %else34
then34:
	%tmp118 = call %struct.string.String @string.from_c_string(i8* @.str.57)
	br label %func_exit
else34:
	%tmp119 = load i8, i8* %val
	%tmp120 = icmp eq i8 %tmp119, 29
	br i1 %tmp120, label %then35, label %else35
then35:
	%tmp121 = call %struct.string.String @string.from_c_string(i8* @.str.58)
	br label %func_exit
else35:
	%tmp122 = load i8, i8* %val
	%tmp123 = icmp eq i8 %tmp122, 30
	br i1 %tmp123, label %then36, label %else36
then36:
	%tmp124 = call %struct.string.String @string.from_c_string(i8* @.str.59)
	br label %func_exit
else36:
	%tmp125 = load i8, i8* %val
	%tmp126 = icmp eq i8 %tmp125, 31
	br i1 %tmp126, label %then37, label %else37
then37:
	%tmp127 = call %struct.string.String @string.from_c_string(i8* @.str.60)
	br label %func_exit
else37:
	%tmp128 = load i8, i8* %val
	%tmp129 = icmp eq i8 %tmp128, 32
	br i1 %tmp129, label %then38, label %else38
then38:
	%tmp130 = call %struct.string.String @string.from_c_string(i8* @.str.61)
	br label %func_exit
else38:
	%tmp131 = load i8, i8* %val
	%tmp132 = icmp eq i8 %tmp131, 33
	br i1 %tmp132, label %then39, label %else39
then39:
	%tmp133 = call %struct.string.String @string.from_c_string(i8* @.str.62)
	br label %func_exit
else39:
	%tmp134 = load i8, i8* %val
	%tmp135 = icmp eq i8 %tmp134, 36
	br i1 %tmp135, label %then40, label %else40
then40:
	%tmp136 = call %struct.string.String @string.from_c_string(i8* @.str.63)
	br label %func_exit
else40:
	%tmp137 = load i8, i8* %val
	%tmp138 = icmp eq i8 %tmp137, 37
	br i1 %tmp138, label %then41, label %else41
then41:
	%tmp139 = call %struct.string.String @string.from_c_string(i8* @.str.64)
	br label %func_exit
else41:
	%tmp140 = load i8, i8* %val
	%tmp141 = icmp eq i8 %tmp140, 38
	br i1 %tmp141, label %then42, label %else42
then42:
	%tmp142 = call %struct.string.String @string.from_c_string(i8* @.str.65)
	br label %func_exit
else42:
	%tmp143 = load i8, i8* %val
	%tmp144 = icmp eq i8 %tmp143, 39
	br i1 %tmp144, label %then43, label %else43
then43:
	%tmp145 = call %struct.string.String @string.from_c_string(i8* @.str.66)
	br label %func_exit
else43:
	%tmp146 = load i8, i8* %val
	%tmp147 = icmp eq i8 %tmp146, 40
	br i1 %tmp147, label %then44, label %else44
then44:
	%tmp148 = call %struct.string.String @string.from_c_string(i8* @.str.67)
	br label %func_exit
else44:
	%tmp149 = load i8, i8* %val
	%tmp150 = icmp eq i8 %tmp149, 41
	br i1 %tmp150, label %then45, label %else45
then45:
	%tmp151 = call %struct.string.String @string.from_c_string(i8* @.str.68)
	br label %func_exit
else45:
	%tmp152 = load i8, i8* %val
	%tmp153 = icmp eq i8 %tmp152, 42
	br i1 %tmp153, label %then46, label %else46
then46:
	%tmp154 = call %struct.string.String @string.from_c_string(i8* @.str.69)
	br label %func_exit
else46:
	%tmp155 = load i8, i8* %val
	%tmp156 = icmp eq i8 %tmp155, 43
	br i1 %tmp156, label %then47, label %else47
then47:
	%tmp157 = call %struct.string.String @string.from_c_string(i8* @.str.70)
	br label %func_exit
else47:
	%tmp158 = load i8, i8* %val
	%tmp159 = icmp eq i8 %tmp158, 44
	br i1 %tmp159, label %then48, label %else48
then48:
	%tmp160 = call %struct.string.String @string.from_c_string(i8* @.str.71)
	br label %func_exit
else48:
	%tmp161 = load i8, i8* %val
	%tmp162 = icmp eq i8 %tmp161, 45
	br i1 %tmp162, label %then49, label %else49
then49:
	%tmp163 = call %struct.string.String @string.from_c_string(i8* @.str.72)
	br label %func_exit
else49:
	%tmp164 = load i8, i8* %val
	%tmp165 = icmp eq i8 %tmp164, 46
	br i1 %tmp165, label %then50, label %else50
then50:
	%tmp166 = call %struct.string.String @string.from_c_string(i8* @.str.73)
	br label %func_exit
else50:
	%tmp167 = load i8, i8* %val
	%tmp168 = icmp eq i8 %tmp167, 47
	br i1 %tmp168, label %then51, label %else51
then51:
	%tmp169 = call %struct.string.String @string.from_c_string(i8* @.str.74)
	br label %func_exit
else51:
	%tmp170 = load i8, i8* %val
	%tmp171 = icmp eq i8 %tmp170, 48
	br i1 %tmp171, label %then52, label %else52
then52:
	%tmp172 = call %struct.string.String @string.from_c_string(i8* @.str.75)
	br label %func_exit
else52:
	%tmp173 = load i8, i8* %val
	%tmp174 = icmp eq i8 %tmp173, 49
	br i1 %tmp174, label %then53, label %else53
then53:
	%tmp175 = call %struct.string.String @string.from_c_string(i8* @.str.76)
	br label %func_exit
else53:
	%tmp176 = load i8, i8* %val
	%tmp177 = icmp eq i8 %tmp176, 50
	br i1 %tmp177, label %then54, label %else54
then54:
	%tmp178 = call %struct.string.String @string.from_c_string(i8* @.str.77)
	br label %func_exit
else54:
	%tmp179 = load i8, i8* %val
	%tmp180 = icmp eq i8 %tmp179, 51
	br i1 %tmp180, label %then55, label %else55
then55:
	%tmp181 = call %struct.string.String @string.from_c_string(i8* @.str.78)
	br label %func_exit
else55:
	%tmp182 = load i8, i8* %val
	%tmp183 = icmp eq i8 %tmp182, 52
	br i1 %tmp183, label %then56, label %else56
then56:
	%tmp184 = call %struct.string.String @string.from_c_string(i8* @.str.79)
	br label %func_exit
else56:
	%tmp185 = load i8, i8* %val
	%tmp186 = icmp eq i8 %tmp185, 53
	br i1 %tmp186, label %then57, label %else57
then57:
	%tmp187 = call %struct.string.String @string.from_c_string(i8* @.str.80)
	br label %func_exit
else57:
	%tmp188 = load i8, i8* %val
	%tmp189 = icmp eq i8 %tmp188, 54
	br i1 %tmp189, label %then58, label %else58
then58:
	%tmp190 = call %struct.string.String @string.from_c_string(i8* @.str.81)
	br label %func_exit
else58:
	%tmp191 = load i8, i8* %val
	%tmp192 = icmp eq i8 %tmp191, 55
	br i1 %tmp192, label %then59, label %else59
then59:
	%tmp193 = call %struct.string.String @string.from_c_string(i8* @.str.82)
	br label %func_exit
else59:
	%tmp194 = load i8, i8* %val
	%tmp195 = icmp eq i8 %tmp194, 56
	br i1 %tmp195, label %then60, label %else60
then60:
	%tmp196 = call %struct.string.String @string.from_c_string(i8* @.str.83)
	br label %func_exit
else60:
	%tmp197 = load i8, i8* %val
	%tmp198 = icmp eq i8 %tmp197, 57
	br i1 %tmp198, label %then61, label %else61
then61:
	%tmp199 = call %struct.string.String @string.from_c_string(i8* @.str.84)
	br label %func_exit
else61:
	%tmp200 = load i8, i8* %val
	%tmp201 = icmp eq i8 %tmp200, 58
	br i1 %tmp201, label %then62, label %else62
then62:
	%tmp202 = call %struct.string.String @string.from_c_string(i8* @.str.85)
	br label %func_exit
else62:
	%tmp203 = load i8, i8* %val
	%tmp204 = icmp eq i8 %tmp203, 59
	br i1 %tmp204, label %then63, label %else63
then63:
	%tmp205 = call %struct.string.String @string.from_c_string(i8* @.str.86)
	br label %func_exit
else63:
	%tmp206 = load i8, i8* %val
	%tmp207 = icmp eq i8 %tmp206, 60
	br i1 %tmp207, label %then64, label %else64
then64:
	%tmp208 = call %struct.string.String @string.from_c_string(i8* @.str.87)
	br label %func_exit
else64:
	%tmp209 = load i8, i8* %val
	%tmp210 = icmp eq i8 %tmp209, 61
	br i1 %tmp210, label %then65, label %else65
then65:
	%tmp211 = call %struct.string.String @string.from_c_string(i8* @.str.88)
	br label %func_exit
else65:
	%tmp212 = load i8, i8* %val
	%tmp213 = icmp eq i8 %tmp212, 62
	br i1 %tmp213, label %then66, label %else66
then66:
	%tmp214 = call %struct.string.String @string.from_c_string(i8* @.str.89)
	br label %func_exit
else66:
	%tmp215 = load i8, i8* %val
	%tmp216 = icmp eq i8 %tmp215, 63
	br i1 %tmp216, label %then67, label %else67
then67:
	%tmp217 = call %struct.string.String @string.from_c_string(i8* @.str.90)
	br label %func_exit
else67:
	%tmp218 = load i8, i8* %val
	%tmp219 = icmp eq i8 %tmp218, 64
	br i1 %tmp219, label %then68, label %endif68
then68:
	%tmp220 = call %struct.string.String @string.from_c_string(i8* @.str.91)
	br label %func_exit
endif68:
	br label %endif6
endif6:
	%tmp221 = call %struct.string.String @string.from_c_string(i8* @.str.92)
	br label %func_exit
func_exit:
	%tmp222 = phi %struct.string.String [%tmp7, %then1], [%tmp14, %then2], [%tmp21, %then3], [%tmp28, %then4], [%tmp31, %then5], [%tmp34, %then6], [%tmp37, %then7], [%tmp40, %then8], [%tmp43, %then9], [%tmp46, %then10], [%tmp49, %then11], [%tmp52, %then12], [%tmp55, %then13], [%tmp58, %then14], [%tmp61, %then15], [%tmp64, %then16], [%tmp67, %then17], [%tmp70, %then18], [%tmp73, %then19], [%tmp76, %then20], [%tmp79, %then21], [%tmp82, %then22], [%tmp85, %then23], [%tmp88, %then24], [%tmp91, %then25], [%tmp94, %then26], [%tmp97, %then27], [%tmp100, %then28], [%tmp103, %then29], [%tmp106, %then30], [%tmp109, %then31], [%tmp112, %then32], [%tmp115, %then33], [%tmp118, %then34], [%tmp121, %then35], [%tmp124, %then36], [%tmp127, %then37], [%tmp130, %then38], [%tmp133, %then39], [%tmp136, %then40], [%tmp139, %then41], [%tmp142, %then42], [%tmp145, %then43], [%tmp148, %then44], [%tmp151, %then45], [%tmp154, %then46], [%tmp157, %then47], [%tmp160, %then48], [%tmp163, %then49], [%tmp166, %then50], [%tmp169, %then51], [%tmp172, %then52], [%tmp175, %then53], [%tmp178, %then54], [%tmp181, %then55], [%tmp184, %then56], [%tmp187, %then57], [%tmp190, %then58], [%tmp193, %then59], [%tmp196, %then60], [%tmp199, %then61], [%tmp202, %then62], [%tmp205, %then63], [%tmp208, %then64], [%tmp211, %then65], [%tmp214, %then66], [%tmp217, %then67], [%tmp220, %then68], [%tmp221, %endif6]
	ret %struct.string.String %tmp222
}
define void @skip_nested(%struct.TokenData* %tokens, i32* %index, i32 %len, i8 %open, i8 %close){
	%v0 = alloca i32
	%tmp0 = load i32, i32* %index
	%tmp1 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp0
	%tmp2 = load i8, i8* %tmp1
	%tmp3 = icmp ne i8 %tmp2, %open
	br i1 %tmp3, label %then0, label %endif0
then0:
	br label %func_exit
endif0:
	%tmp4 = load i32, i32* %index
	%tmp5 = add i32 %tmp4, 1
	store i32 %tmp5, i32* %index
	store i32 1, i32* %v0
	br label %loop_start1
loop_start1:
	%tmp6 = load i32, i32* %index
	%tmp7 = icmp ult i32 %tmp6, %len
	br i1 %tmp7, label %logic_rhs_2, label %logic_end_2
logic_rhs_2:
	%tmp8 = load i32, i32* %v0
	%tmp9 = icmp sgt i32 %tmp8, 0
	br label %logic_end_2
logic_end_2:
	%tmp10 = phi i1 [%tmp7, %loop_start1], [%tmp9, %logic_rhs_2]
	br i1 %tmp10, label %endif3, label %else3
else3:
	br label %loop_body1_exit
endif3:
	%tmp11 = load i32, i32* %index
	%tmp12 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp11
	%tmp13 = load i8, i8* %tmp12
	%tmp14 = icmp eq i8 %tmp13, %open
	br i1 %tmp14, label %then4, label %else4
then4:
	%tmp15 = load i32, i32* %v0
	%tmp16 = add i32 %tmp15, 1
	store i32 %tmp16, i32* %v0
	br label %endif4
else4:
	%tmp17 = load i32, i32* %index
	%tmp18 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp17
	%tmp19 = load i8, i8* %tmp18
	%tmp20 = icmp eq i8 %tmp19, %close
	br i1 %tmp20, label %then5, label %endif5
then5:
	%tmp21 = load i32, i32* %v0
	%tmp22 = sub i32 %tmp21, 1
	store i32 %tmp22, i32* %v0
	br label %endif5
endif5:
	br label %endif4
endif4:
	%tmp23 = load i32, i32* %index
	%tmp24 = add i32 %tmp23, 1
	store i32 %tmp24, i32* %index
	br label %loop_start1
loop_body1_exit:
	br label %func_exit
func_exit:
	ret void
}
define %struct.Type @parse_type(%struct.TokenData* %token_array, i32* %index, i32 %len){
	%v0 = alloca %struct.Type
	store i32 0, i32* %v0
	%tmp0 = load i32, i32* %index
	%tmp1 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp0
	%tmp2 = load i8, i8* %tmp1
	%tmp3 = icmp eq i8 %tmp2, 32
	br i1 %tmp3, label %then0, label %endif0
then0:
	%tmp4 = load i32, i32* %index
	%tmp5 = add i32 %tmp4, 1
	store i32 %tmp5, i32* %index
	call %struct.Type @parse_type(%struct.TokenData* %token_array, i32* %index, i32 %len)
	%tmp6 = load %struct.Type, %struct.Type* %v0
	br label %func_exit
endif0:
	%tmp7 = load i32, i32* %index
	%tmp8 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp7
	%tmp9 = load i8, i8* %tmp8
	%tmp10 = icmp eq i8 %tmp9, 25
	br i1 %tmp10, label %then1, label %endif1
then1:
	%tmp11 = load i32, i32* %index
	%tmp12 = add i32 %tmp11, 1
	store i32 %tmp12, i32* %index
	call %struct.Type @parse_type(%struct.TokenData* %token_array, i32* %index, i32 %len)
	%tmp13 = load %struct.Type, %struct.Type* %v0
	br label %func_exit
endif1:
	%tmp14 = load i32, i32* %index
	%tmp15 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp14
	%tmp16 = load i8, i8* %tmp15
	%tmp17 = icmp eq i8 %tmp16, 4
	br i1 %tmp17, label %then2, label %endif2
then2:
	%tmp18 = load i32, i32* %index
	%tmp19 = add i32 %tmp18, 1
	store i32 %tmp19, i32* %index
	call %struct.Type @parse_type(%struct.TokenData* %token_array, i32* %index, i32 %len)
	call void @expect(%struct.TokenData* %token_array, i32* %index, i32 %len, i8 8, i8* @.str.93)
	call %struct.Expression @parse_expression(%struct.TokenData* %token_array, i32* %index, i32 %len)
	call void @expect(%struct.TokenData* %token_array, i32* %index, i32 %len, i8 5, i8* @.str.94)
	%tmp20 = load %struct.Type, %struct.Type* %v0
	br label %func_exit
endif2:
	%tmp21 = load i32, i32* %index
	%tmp22 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp21
	%tmp23 = load i8, i8* %tmp22
	%tmp24 = icmp eq i8 %tmp23, 65
	br i1 %tmp24, label %then3, label %endif3
then3:
	%tmp25 = load i32, i32* %index
	%tmp26 = add i32 %tmp25, 1
	store i32 %tmp26, i32* %index
	%tmp27 = load i32, i32* %index
	%tmp28 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp27
	%tmp29 = load i8, i8* %tmp28
	%tmp30 = icmp eq i8 %tmp29, 7
	br i1 %tmp30, label %then4, label %else4
then4:
	%tmp31 = load i32, i32* %index
	%tmp32 = add i32 %tmp31, 1
	store i32 %tmp32, i32* %index
	call %struct.Type @parse_type(%struct.TokenData* %token_array, i32* %index, i32 %len)
	br label %endif4
else4:
	%tmp33 = load i32, i32* %index
	%tmp34 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp33
	%tmp35 = load i8, i8* %tmp34
	%tmp36 = icmp eq i8 %tmp35, 28
	br i1 %tmp36, label %then5, label %endif5
then5:
	%tmp37 = load i32, i32* %index
	%tmp38 = add i32 %tmp37, 1
	store i32 %tmp38, i32* %index
	call %struct.Type @parse_type(%struct.TokenData* %token_array, i32* %index, i32 %len)
	%tmp39 = load i32, i32* %index
	%tmp40 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp39
	%tmp41 = load i8, i8* %tmp40
	%tmp42 = icmp eq i8 %tmp41, 26
	br i1 %tmp42, label %then6, label %endif6
then6:
	%tmp43 = load i32, i32* %index
	%tmp44 = add i32 %tmp43, 1
	store i32 %tmp44, i32* %index
	%tmp45 = load %struct.Type, %struct.Type* %v0
	br label %func_exit
endif6:
	br label %endif5
endif5:
	br label %endif4
endif4:
	%tmp46 = load %struct.Type, %struct.Type* %v0
	br label %func_exit
endif3:
	%tmp47 = load i32, i32* %index
	%tmp48 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp47
	%tmp49 = load i8, i8* %tmp48
	%tmp50 = icmp eq i8 %tmp49, 41
	br i1 %tmp50, label %then7, label %endif7
then7:
	%tmp51 = load i32, i32* %index
	%tmp52 = add i32 %tmp51, 1
	store i32 %tmp52, i32* %index
	call void @expect(%struct.TokenData* %token_array, i32* %index, i32 %len, i8 0, i8* @.str.95)
	br label %loop_start8
loop_start8:
	%tmp53 = load i32, i32* %index
	%tmp54 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp53
	%tmp55 = load i8, i8* %tmp54
	%tmp56 = icmp ne i8 %tmp55, 1
	br i1 %tmp56, label %endif9, label %else9
else9:
	br label %loop_body8_exit
endif9:
	call %struct.Type @parse_type(%struct.TokenData* %token_array, i32* %index, i32 %len)
	%tmp57 = load i32, i32* %index
	%tmp58 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp57
	%tmp59 = load i8, i8* %tmp58
	%tmp60 = icmp eq i8 %tmp59, 9
	br i1 %tmp60, label %then10, label %endif10
then10:
	%tmp61 = load i32, i32* %index
	%tmp62 = add i32 %tmp61, 1
	store i32 %tmp62, i32* %index
	br label %endif10
endif10:
	br label %loop_start8
loop_body8_exit:
	%tmp63 = load i32, i32* %index
	%tmp64 = add i32 %tmp63, 1
	store i32 %tmp64, i32* %index
	call void @expect(%struct.TokenData* %token_array, i32* %index, i32 %len, i8 6, i8* @.str.96)
	call %struct.Type @parse_type(%struct.TokenData* %token_array, i32* %index, i32 %len)
	%tmp65 = load %struct.Type, %struct.Type* %v0
	br label %func_exit
endif7:
	call void @process.throw(i8* @.str.97)
	%tmp66 = load %struct.Type, %struct.Type* %v0
	br label %func_exit
func_exit:
; Variable t is out.
	%tmp67 = phi %struct.Type [%tmp6, %then0], [%tmp13, %then1], [%tmp20, %then2], [%tmp45, %then6], [%tmp46, %endif4], [%tmp65, %loop_body8_exit], [%tmp66, %endif7]
	ret %struct.Type %tmp67
}
define %"struct.vector.Vec<%struct.Argument>" @parse_struct_fields(%struct.TokenData* %token_array, i32* %index, i32 %len){
	%v0 = alloca %"struct.vector.Vec<%struct.Argument>"
	%v1 = alloca %struct.Argument
	%tmp0 = call %"struct.vector.Vec<%struct.Argument>" @"vector.new<%struct.Argument>"()
	store %"struct.vector.Vec<%struct.Argument>" %tmp0, %"struct.vector.Vec<%struct.Argument>"* %v0
	call void @expect(%struct.TokenData* %token_array, i32* %index, i32 %len, i8 2, i8* @.str.15)
	br label %loop_start0
loop_start0:
	%tmp1 = load i32, i32* %index
	%tmp2 = icmp ult i32 %tmp1, %len
	br i1 %tmp2, label %logic_rhs_1, label %logic_end_1
logic_rhs_1:
	%tmp3 = load i32, i32* %index
	%tmp4 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp3
	%tmp5 = load i8, i8* %tmp4
	%tmp6 = icmp ne i8 %tmp5, 3
	br label %logic_end_1
logic_end_1:
	%tmp7 = phi i1 [%tmp2, %loop_start0], [%tmp6, %logic_rhs_1]
	br i1 %tmp7, label %endif2, label %else2
else2:
	br label %loop_body0_exit
endif2:
	%tmp8 = load i32, i32* %index
	%tmp9 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp8
	%tmp10 = load i8, i8* %tmp9
	%tmp11 = icmp ne i8 %tmp10, 65
	br i1 %tmp11, label %then3, label %endif3
then3:
	call void @process.throw(i8* @.str.98)
	br label %endif3
endif3:
	%tmp12 = load i32, i32* %index
	%tmp13 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp12
	%tmp14 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp13, i32 0, i32 1
	%tmp15 = load i16, i16* %tmp14
	store i16 %tmp15, i16* %v1
	%tmp16 = load i32, i32* %index
	%tmp17 = add i32 %tmp16, 1
	store i32 %tmp17, i32* %index
	call void @expect(%struct.TokenData* %token_array, i32* %index, i32 %len, i8 6, i8* @.str.99)
	%tmp18 = getelementptr inbounds %struct.Argument, %struct.Argument* %v1, i32 0, i32 1
	%tmp19 = call %struct.Type @parse_type(%struct.TokenData* %token_array, i32* %index, i32 %len)
	store %struct.Type %tmp19, %struct.Type* %tmp18
	%tmp20 = load %struct.Argument, %struct.Argument* %v1
	call void @"vector.push<%struct.Argument>"(%"struct.vector.Vec<%struct.Argument>"* %v0, %struct.Argument %tmp20)
	%tmp21 = load i32, i32* %index
	%tmp22 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp21
	%tmp23 = load i8, i8* %tmp22
	%tmp24 = icmp eq i8 %tmp23, 9
	br i1 %tmp24, label %then4, label %else4
then4:
	%tmp25 = load i32, i32* %index
	%tmp26 = add i32 %tmp25, 1
	store i32 %tmp26, i32* %index
	br label %endif4
else4:
	%tmp27 = load i32, i32* %index
	%tmp28 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp27
	%tmp29 = load i8, i8* %tmp28
	%tmp30 = icmp ne i8 %tmp29, 3
	br i1 %tmp30, label %then5, label %endif5
then5:
	call void @process.throw(i8* @.str.100)
	br label %endif5
endif5:
	br label %endif4
endif4:
	br label %loop_start0
loop_body0_exit:
; Variable field is out.
	call void @expect(%struct.TokenData* %token_array, i32* %index, i32 %len, i8 3, i8* @.str.101)
	%tmp31 = load %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %v0
; Variable fields is out.
	ret %"struct.vector.Vec<%struct.Argument>" %tmp31
}
define %"struct.vector.Vec<i16>" @parse_generic_params(%struct.TokenData* %token_array, i32* %index, i32 %len){
	%v0 = alloca %"struct.vector.Vec<i16>"
	%tmp0 = call %"struct.vector.Vec<i16>" @"vector.new<i16>"()
	store %"struct.vector.Vec<i16>" %tmp0, %"struct.vector.Vec<i16>"* %v0
	%tmp1 = load i32, i32* %index
	%tmp2 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp1
	%tmp3 = load i8, i8* %tmp2
	%tmp4 = icmp eq i8 %tmp3, 28
	br i1 %tmp4, label %then0, label %endif0
then0:
	%tmp5 = load i32, i32* %index
	%tmp6 = add i32 %tmp5, 1
	store i32 %tmp6, i32* %index
	br label %loop_start1
loop_start1:
	%tmp7 = load i32, i32* %index
	%tmp8 = icmp ult i32 %tmp7, %len
	br i1 %tmp8, label %logic_rhs_2, label %logic_end_2
logic_rhs_2:
	%tmp9 = load i32, i32* %index
	%tmp10 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp9
	%tmp11 = load i8, i8* %tmp10
	%tmp12 = icmp ne i8 %tmp11, 26
	br label %logic_end_2
logic_end_2:
	%tmp13 = phi i1 [%tmp8, %loop_start1], [%tmp12, %logic_rhs_2]
	br i1 %tmp13, label %endif3, label %else3
else3:
	br label %loop_body1_exit
endif3:
	%tmp14 = load i32, i32* %index
	%tmp15 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp14
	%tmp16 = load i8, i8* %tmp15
	%tmp17 = icmp eq i8 %tmp16, 65
	br i1 %tmp17, label %then4, label %else4
then4:
	%tmp18 = load i32, i32* %index
	%tmp19 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp18
	%tmp20 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp19, i32 0, i32 1
	%tmp21 = load i16, i16* %tmp20
	call void @"vector.push<i16>"(%"struct.vector.Vec<i16>"* %v0, i16 %tmp21)
	%tmp22 = load i32, i32* %index
	%tmp23 = add i32 %tmp22, 1
	store i32 %tmp23, i32* %index
	br label %endif4
else4:
	%tmp24 = load i32, i32* %index
	%tmp25 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp24
	%tmp26 = load i8, i8* %tmp25
	%tmp27 = icmp eq i8 %tmp26, 9
	br i1 %tmp27, label %then5, label %else5
then5:
	%tmp28 = load i32, i32* %index
	%tmp29 = add i32 %tmp28, 1
	store i32 %tmp29, i32* %index
	br label %endif5
else5:
	call void @process.throw(i8* @.str.102)
	br label %endif5
endif5:
	br label %endif4
endif4:
	br label %loop_start1
loop_body1_exit:
	call void @expect(%struct.TokenData* %token_array, i32* %index, i32 %len, i8 26, i8* @.str.103)
	br label %endif0
endif0:
	%tmp30 = load %"struct.vector.Vec<i16>", %"struct.vector.Vec<i16>"* %v0
; Variable generics is out.
	ret %"struct.vector.Vec<i16>" %tmp30
}
define %"struct.vector.Vec<%struct.Expression>" @parse_expression_comma(%struct.TokenData* %token_array, i32* %index, i32 %len){
	%v0 = alloca %"struct.vector.Vec<%struct.Expression>"
	%v1 = alloca %struct.Expression
	%tmp0 = call %"struct.vector.Vec<%struct.Expression>" @"vector.new<%struct.Expression>"()
	store %"struct.vector.Vec<%struct.Expression>" %tmp0, %"struct.vector.Vec<%struct.Expression>"* %v0
	br label %loop_start0
loop_start0:
	%tmp1 = load i32, i32* %index
	%tmp2 = icmp ult i32 %tmp1, %len
	br i1 %tmp2, label %logic_rhs_1, label %logic_end_1
logic_rhs_1:
	%tmp3 = load i32, i32* %index
	%tmp4 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp3
	%tmp5 = load i8, i8* %tmp4
	%tmp6 = icmp ne i8 %tmp5, 1
	br label %logic_end_1
logic_end_1:
	%tmp7 = phi i1 [%tmp2, %loop_start0], [%tmp6, %logic_rhs_1]
	br i1 %tmp7, label %endif2, label %else2
else2:
	br label %loop_body0_exit
endif2:
	%tmp8 = call %struct.Expression @parse_expression(%struct.TokenData* %token_array, i32* %index, i32 %len)
	store %struct.Expression %tmp8, %struct.Expression* %v1
	%tmp9 = load %struct.Expression, %struct.Expression* %v1
	call void @"vector.push<%struct.Expression>"(%"struct.vector.Vec<%struct.Expression>"* %v0, %struct.Expression %tmp9)
	%tmp10 = load i32, i32* %index
	%tmp11 = icmp ult i32 %tmp10, %len
	br i1 %tmp11, label %logic_rhs_3, label %logic_end_3
logic_rhs_3:
	%tmp12 = load i32, i32* %index
	%tmp13 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp12
	%tmp14 = load i8, i8* %tmp13
	%tmp15 = icmp eq i8 %tmp14, 9
	br label %logic_end_3
logic_end_3:
	%tmp16 = phi i1 [%tmp11, %endif2], [%tmp15, %logic_rhs_3]
	br i1 %tmp16, label %then4, label %else4
then4:
	%tmp17 = load i32, i32* %index
	%tmp18 = add i32 %tmp17, 1
	store i32 %tmp18, i32* %index
	br label %endif4
else4:
	br label %loop_body0_exit
endif4:
	br label %loop_start0
loop_body0_exit:
; Variable expr is out.
	%tmp19 = load %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Expression>"* %v0
; Variable output is out.
	ret %"struct.vector.Vec<%struct.Expression>" %tmp19
}
define %struct.Expression @parse_expression(%struct.TokenData* %token_array, i32* %index, i32 %len){
	%v0 = alloca %struct.Expression
	%v1 = alloca i32
	%v2 = alloca i32
	%v3 = alloca i32
	store i32 0, i32* %v0
	store i32 0, i32* %v1
	store i32 0, i32* %v2
	store i32 0, i32* %v3
	br label %loop_start0
loop_start0:
	%tmp0 = load i32, i32* %index
	%tmp1 = icmp ult i32 %tmp0, %len
	br i1 %tmp1, label %endif1, label %else1
else1:
	br label %loop_body0_exit
endif1:
	%tmp2 = load i32, i32* %index
	%tmp3 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp2
	%tmp4 = load i8, i8* %tmp3
	%tmp5 = icmp eq i8 %tmp4, 0
	br i1 %tmp5, label %then2, label %else2
then2:
	%tmp6 = load i32, i32* %v1
	%tmp7 = add i32 %tmp6, 1
	store i32 %tmp7, i32* %v1
	br label %endif2
else2:
	%tmp8 = icmp eq i8 %tmp4, 1
	br i1 %tmp8, label %then3, label %else3
then3:
	%tmp9 = load i32, i32* %v1
	%tmp10 = icmp eq i32 %tmp9, 0
	br i1 %tmp10, label %then4, label %endif4
then4:
	br label %loop_body0_exit
endif4:
	%tmp11 = load i32, i32* %v1
	%tmp12 = sub i32 %tmp11, 1
	store i32 %tmp12, i32* %v1
	br label %endif3
else3:
	%tmp13 = icmp eq i8 %tmp4, 2
	br i1 %tmp13, label %then5, label %else5
then5:
	%tmp14 = load i32, i32* %v2
	%tmp15 = add i32 %tmp14, 1
	store i32 %tmp15, i32* %v2
	br label %endif5
else5:
	%tmp16 = icmp eq i8 %tmp4, 3
	br i1 %tmp16, label %then6, label %else6
then6:
	%tmp17 = load i32, i32* %v2
	%tmp18 = icmp eq i32 %tmp17, 0
	br i1 %tmp18, label %then7, label %endif7
then7:
	br label %loop_body0_exit
endif7:
	%tmp19 = load i32, i32* %v2
	%tmp20 = sub i32 %tmp19, 1
	store i32 %tmp20, i32* %v2
	br label %endif6
else6:
	%tmp21 = icmp eq i8 %tmp4, 4
	br i1 %tmp21, label %then8, label %else8
then8:
	%tmp22 = load i32, i32* %v3
	%tmp23 = add i32 %tmp22, 1
	store i32 %tmp23, i32* %v3
	br label %endif8
else8:
	%tmp24 = icmp eq i8 %tmp4, 5
	br i1 %tmp24, label %then9, label %else9
then9:
	%tmp25 = load i32, i32* %v3
	%tmp26 = icmp eq i32 %tmp25, 0
	br i1 %tmp26, label %then10, label %endif10
then10:
	br label %loop_body0_exit
endif10:
	%tmp27 = load i32, i32* %v3
	%tmp28 = sub i32 %tmp27, 1
	store i32 %tmp28, i32* %v3
	br label %endif9
else9:
	%tmp29 = load i32, i32* %v1
	%tmp30 = icmp eq i32 %tmp29, 0
	br i1 %tmp30, label %logic_rhs_11, label %logic_end_11
logic_rhs_11:
	%tmp31 = load i32, i32* %v2
	%tmp32 = icmp eq i32 %tmp31, 0
	br label %logic_end_11
logic_end_11:
	%tmp33 = phi i1 [%tmp30, %else9], [%tmp32, %logic_rhs_11]
	br i1 %tmp33, label %logic_rhs_12, label %logic_end_12
logic_rhs_12:
	%tmp34 = load i32, i32* %v3
	%tmp35 = icmp eq i32 %tmp34, 0
	br label %logic_end_12
logic_end_12:
	%tmp36 = phi i1 [%tmp33, %logic_end_11], [%tmp35, %logic_rhs_12]
	br i1 %tmp36, label %then13, label %endif13
then13:
	%tmp37 = icmp eq i8 %tmp4, 9
	br i1 %tmp37, label %logic_end_14, label %logic_rhs_14
logic_rhs_14:
	%tmp38 = icmp eq i8 %tmp4, 8
	br label %logic_end_14
logic_end_14:
	%tmp39 = phi i1 [%tmp37, %then13], [%tmp38, %logic_rhs_14]
	br i1 %tmp39, label %then15, label %endif15
then15:
	br label %loop_body0_exit
endif15:
	br label %endif13
endif13:
	br label %endif9
endif9:
	br label %endif8
endif8:
	br label %endif6
endif6:
	br label %endif5
endif5:
	br label %endif3
endif3:
	br label %endif2
endif2:
	%tmp40 = load i32, i32* %index
	%tmp41 = add i32 %tmp40, 1
	store i32 %tmp41, i32* %index
	br label %loop_start0
loop_body0_exit:
	%tmp42 = load %struct.Expression, %struct.Expression* %v0
; Variable expr is out.
	ret %struct.Expression %tmp42
}
define %"struct.vector.Vec<%struct.EnumField>" @parse_enum_fields(%struct.TokenData* %token_array, i32* %index, i32 %len){
	%v0 = alloca %"struct.vector.Vec<%struct.EnumField>"
	%v1 = alloca %struct.EnumField
	%tmp0 = call %"struct.vector.Vec<%struct.EnumField>" @"vector.new<%struct.EnumField>"()
	store %"struct.vector.Vec<%struct.EnumField>" %tmp0, %"struct.vector.Vec<%struct.EnumField>"* %v0
	call void @expect(%struct.TokenData* %token_array, i32* %index, i32 %len, i8 2, i8* @.str.13)
	br label %loop_start0
loop_start0:
	%tmp1 = load i32, i32* %index
	%tmp2 = icmp ult i32 %tmp1, %len
	br i1 %tmp2, label %logic_rhs_1, label %logic_end_1
logic_rhs_1:
	%tmp3 = load i32, i32* %index
	%tmp4 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp3
	%tmp5 = load i8, i8* %tmp4
	%tmp6 = icmp ne i8 %tmp5, 3
	br label %logic_end_1
logic_end_1:
	%tmp7 = phi i1 [%tmp2, %loop_start0], [%tmp6, %logic_rhs_1]
	br i1 %tmp7, label %endif2, label %else2
else2:
	br label %loop_body0_exit
endif2:
	%tmp8 = load i32, i32* %index
	%tmp9 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp8
	%tmp10 = load i8, i8* %tmp9
	%tmp11 = icmp ne i8 %tmp10, 65
	br i1 %tmp11, label %then3, label %endif3
then3:
	call void @process.throw(i8* @.str.104)
	br label %endif3
endif3:
	%tmp12 = load i32, i32* %index
	%tmp13 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp12
	%tmp14 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp13, i32 0, i32 1
	%tmp15 = load i16, i16* %tmp14
	store i16 %tmp15, i16* %v1
	%tmp16 = load i32, i32* %index
	%tmp17 = add i32 %tmp16, 1
	store i32 %tmp17, i32* %index
	%tmp18 = load i32, i32* %index
	%tmp19 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp18
	%tmp20 = load i8, i8* %tmp19
	%tmp21 = icmp eq i8 %tmp20, 15
	br i1 %tmp21, label %then4, label %else4
then4:
	%tmp22 = load i32, i32* %index
	%tmp23 = add i32 %tmp22, 1
	store i32 %tmp23, i32* %index
	%tmp24 = getelementptr inbounds %struct.EnumField, %struct.EnumField* %v1, i32 0, i32 1
	store i1 true, i1* %tmp24
	%tmp25 = getelementptr inbounds %struct.EnumField, %struct.EnumField* %v1, i32 0, i32 2
	%tmp26 = call %struct.Expression @parse_expression(%struct.TokenData* %token_array, i32* %index, i32 %len)
	store %struct.Expression %tmp26, %struct.Expression* %tmp25
	br label %endif4
else4:
	%tmp27 = getelementptr inbounds %struct.EnumField, %struct.EnumField* %v1, i32 0, i32 1
	store i1 false, i1* %tmp27
	br label %endif4
endif4:
	%tmp28 = load %struct.EnumField, %struct.EnumField* %v1
	call void @"vector.push<%struct.EnumField>"(%"struct.vector.Vec<%struct.EnumField>"* %v0, %struct.EnumField %tmp28)
	%tmp29 = load i32, i32* %index
	%tmp30 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp29
	%tmp31 = load i8, i8* %tmp30
	%tmp32 = icmp eq i8 %tmp31, 9
	br i1 %tmp32, label %then5, label %else5
then5:
	%tmp33 = load i32, i32* %index
	%tmp34 = add i32 %tmp33, 1
	store i32 %tmp34, i32* %index
	br label %endif5
else5:
	%tmp35 = load i32, i32* %index
	%tmp36 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp35
	%tmp37 = load i8, i8* %tmp36
	%tmp38 = icmp ne i8 %tmp37, 3
	br i1 %tmp38, label %then6, label %endif6
then6:
	call void @process.throw(i8* @.str.105)
	br label %endif6
endif6:
	br label %endif5
endif5:
	br label %loop_start0
loop_body0_exit:
; Variable field is out.
	call void @expect(%struct.TokenData* %token_array, i32* %index, i32 %len, i8 3, i8* @.str.106)
	%tmp39 = load %"struct.vector.Vec<%struct.EnumField>", %"struct.vector.Vec<%struct.EnumField>"* %v0
; Variable fields is out.
	ret %"struct.vector.Vec<%struct.EnumField>" %tmp39
}
define %"struct.vector.Vec<%struct.Argument>" @parse_argument_comma(%struct.TokenData* %token_array, i32* %index, i32 %len){
	%v0 = alloca %"struct.vector.Vec<%struct.Argument>"
	%v1 = alloca %struct.Argument
	%tmp0 = call %"struct.vector.Vec<%struct.Argument>" @"vector.new<%struct.Argument>"()
	store %"struct.vector.Vec<%struct.Argument>" %tmp0, %"struct.vector.Vec<%struct.Argument>"* %v0
	br label %loop_start0
loop_start0:
	%tmp1 = load i32, i32* %index
	%tmp2 = icmp ult i32 %tmp1, %len
	br i1 %tmp2, label %logic_rhs_1, label %logic_end_1
logic_rhs_1:
	%tmp3 = load i32, i32* %index
	%tmp4 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp3
	%tmp5 = load i8, i8* %tmp4
	%tmp6 = icmp ne i8 %tmp5, 1
	br label %logic_end_1
logic_end_1:
	%tmp7 = phi i1 [%tmp2, %loop_start0], [%tmp6, %logic_rhs_1]
	br i1 %tmp7, label %endif2, label %else2
else2:
	br label %loop_body0_exit
endif2:
	%tmp8 = load i32, i32* %index
	%tmp9 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp8
	%tmp10 = load i8, i8* %tmp9
	%tmp11 = icmp ne i8 %tmp10, 65
	br i1 %tmp11, label %then3, label %endif3
then3:
	call void @process.throw(i8* @.str.107)
	br label %endif3
endif3:
	%tmp12 = load i32, i32* %index
	%tmp13 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp12
	%tmp14 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp13, i32 0, i32 1
	%tmp15 = load i16, i16* %tmp14
	store i16 %tmp15, i16* %v1
	%tmp16 = load i32, i32* %index
	%tmp17 = add i32 %tmp16, 1
	store i32 %tmp17, i32* %index
	%tmp18 = load i32, i32* %index
	%tmp19 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp18
	%tmp20 = load i8, i8* %tmp19
	%tmp21 = icmp ne i8 %tmp20, 6
	br i1 %tmp21, label %then4, label %endif4
then4:
	call void @process.throw(i8* @.str.108)
	br label %endif4
endif4:
	%tmp22 = load i32, i32* %index
	%tmp23 = add i32 %tmp22, 1
	store i32 %tmp23, i32* %index
	%tmp24 = getelementptr inbounds %struct.Argument, %struct.Argument* %v1, i32 0, i32 1
	%tmp25 = call %struct.Type @parse_type(%struct.TokenData* %token_array, i32* %index, i32 %len)
	store %struct.Type %tmp25, %struct.Type* %tmp24
	%tmp26 = load %struct.Argument, %struct.Argument* %v1
	call void @"vector.push<%struct.Argument>"(%"struct.vector.Vec<%struct.Argument>"* %v0, %struct.Argument %tmp26)
	%tmp27 = load i32, i32* %index
	%tmp28 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp27
	%tmp29 = load i8, i8* %tmp28
	%tmp30 = icmp eq i8 %tmp29, 9
	br i1 %tmp30, label %then5, label %else5
then5:
	%tmp31 = load i32, i32* %index
	%tmp32 = add i32 %tmp31, 1
	store i32 %tmp32, i32* %index
	br label %endif5
else5:
	%tmp33 = load i32, i32* %index
	%tmp34 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp33
	%tmp35 = load i8, i8* %tmp34
	%tmp36 = icmp ne i8 %tmp35, 1
	br i1 %tmp36, label %then6, label %endif6
then6:
	call void @process.throw(i8* @.str.109)
	br label %endif6
endif6:
	br label %endif5
endif5:
	br label %loop_start0
loop_body0_exit:
; Variable arg is out.
	%tmp37 = load %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %v0
; Variable output is out.
	ret %"struct.vector.Vec<%struct.Argument>" %tmp37
}
define i1 @is_modifier(i8 %val){
entry:
	%tmp0 = icmp eq i8 %val, 36
	br i1 %tmp0, label %logic_end_0, label %logic_rhs_0
logic_rhs_0:
	%tmp1 = icmp eq i8 %val, 37
	br label %logic_end_0
logic_end_0:
	%tmp2 = phi i1 [%tmp0, %entry], [%tmp1, %logic_rhs_0]
	br i1 %tmp2, label %logic_end_1, label %logic_rhs_1
logic_rhs_1:
	%tmp3 = icmp eq i8 %val, 38
	br label %logic_end_1
logic_end_1:
	%tmp4 = phi i1 [%tmp2, %logic_end_0], [%tmp3, %logic_rhs_1]
	br i1 %tmp4, label %logic_end_2, label %logic_rhs_2
logic_rhs_2:
	%tmp5 = icmp eq i8 %val, 39
	br label %logic_end_2
logic_end_2:
	%tmp6 = phi i1 [%tmp4, %logic_end_1], [%tmp5, %logic_rhs_2]
	br i1 %tmp6, label %logic_end_3, label %logic_rhs_3
logic_rhs_3:
	%tmp7 = icmp eq i8 %val, 43
	br label %logic_end_3
logic_end_3:
	%tmp8 = phi i1 [%tmp6, %logic_end_2], [%tmp7, %logic_rhs_3]
	ret i1 %tmp8
}
define void @handle_symbol(i8* %data, i32 %start, i32 %end, %"struct.vector.Vec<%struct.TokenData>"* %tokens, %"struct.vector.Vec<%struct.string.String>"* %symbols){
	%v0 = alloca %struct.TokenData
	%v1 = alloca %struct.TokenData
	%v2 = alloca %struct.TokenData
	%v3 = alloca %struct.TokenData
	%v4 = alloca %struct.TokenData
	%v5 = alloca %struct.TokenData
	%v6 = alloca %struct.TokenData
	%v7 = alloca %struct.TokenData
	%v8 = alloca %struct.TokenData
	%v9 = alloca %struct.TokenData
	%v10 = alloca %struct.TokenData
	%v11 = alloca %struct.TokenData
	%v12 = alloca %struct.TokenData
	%v13 = alloca %struct.TokenData
	%v14 = alloca %struct.TokenData
	%v15 = alloca %struct.TokenData
	%v16 = alloca %struct.TokenData
	%v17 = alloca %struct.TokenData
	%v18 = alloca %struct.TokenData
	%v19 = alloca %struct.TokenData
	%v20 = alloca %struct.TokenData
	%v21 = alloca %struct.TokenData
	%v22 = alloca %struct.TokenData
	%v23 = alloca %struct.TokenData
	%v24 = alloca %struct.TokenData
	%v25 = alloca %struct.TokenData
	%v26 = alloca %struct.TokenData
	%v27 = alloca %struct.TokenData
	%v28 = alloca %struct.TokenData
	%v29 = alloca i32
	%v30 = alloca %struct.TokenData
	%v31 = alloca %struct.TokenData
	%tmp0 = sub i32 %end, %start
	%tmp1 = getelementptr inbounds i8, i8* %data, i32 %start
	%tmp2 = icmp eq i32 %tmp0, 2
	br i1 %tmp2, label %then0, label %else0
then0:
	%tmp3 = call i32 @mem.compare(i8* %tmp1, i8* @.str.110, i64 2)
	%tmp4 = icmp eq i32 %tmp3, 0
	br i1 %tmp4, label %then1, label %endif1
then1:
	store i8 45, i8* %v0
	%tmp5 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v0, i32 0, i32 1
	store i16 0, i16* %tmp5
	%tmp6 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v0, i32 0, i32 2
	store i32 %start, i32* %tmp6
	%tmp7 = load %struct.TokenData, %struct.TokenData* %v0
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp7)
	br label %func_exit
; Variable temp is out.
endif1:
	%tmp8 = call i32 @mem.compare(i8* %tmp1, i8* @.str.111, i64 2)
	%tmp9 = icmp eq i32 %tmp8, 0
	br i1 %tmp9, label %then2, label %endif2
then2:
	store i8 53, i8* %v1
	%tmp10 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v1, i32 0, i32 1
	store i16 0, i16* %tmp10
	%tmp11 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v1, i32 0, i32 2
	store i32 %start, i32* %tmp11
	%tmp12 = load %struct.TokenData, %struct.TokenData* %v1
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp12)
	br label %func_exit
; Variable temp is out.
endif2:
	%tmp13 = call i32 @mem.compare(i8* %tmp1, i8* @.str.112, i64 2)
	%tmp14 = icmp eq i32 %tmp13, 0
	br i1 %tmp14, label %then3, label %endif3
then3:
	store i8 44, i8* %v2
	%tmp15 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v2, i32 0, i32 1
	store i16 0, i16* %tmp15
	%tmp16 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v2, i32 0, i32 2
	store i32 %start, i32* %tmp16
	%tmp17 = load %struct.TokenData, %struct.TokenData* %v2
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp17)
	br label %func_exit
; Variable temp is out.
endif3:
	%tmp18 = call i32 @mem.compare(i8* %tmp1, i8* @.str.113, i64 2)
	%tmp19 = icmp eq i32 %tmp18, 0
	br i1 %tmp19, label %then4, label %endif4
then4:
	store i8 54, i8* %v3
	%tmp20 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v3, i32 0, i32 1
	store i16 0, i16* %tmp20
	%tmp21 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v3, i32 0, i32 2
	store i32 %start, i32* %tmp21
	%tmp22 = load %struct.TokenData, %struct.TokenData* %v3
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp22)
	br label %func_exit
; Variable temp is out.
endif4:
	%tmp23 = call i32 @mem.compare(i8* %tmp1, i8* @.str.114, i64 2)
	%tmp24 = icmp eq i32 %tmp23, 0
	br i1 %tmp24, label %then5, label %endif5
then5:
	store i8 41, i8* %v4
	%tmp25 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v4, i32 0, i32 1
	store i16 0, i16* %tmp25
	%tmp26 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v4, i32 0, i32 2
	store i32 %start, i32* %tmp26
	%tmp27 = load %struct.TokenData, %struct.TokenData* %v4
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp27)
	br label %func_exit
; Variable temp is out.
endif5:
	br label %endif0
else0:
	%tmp28 = icmp eq i32 %tmp0, 3
	br i1 %tmp28, label %then6, label %else6
then6:
	%tmp29 = call i32 @mem.compare(i8* %tmp1, i8* @.str.115, i64 3)
	%tmp30 = icmp eq i32 %tmp29, 0
	br i1 %tmp30, label %then7, label %endif7
then7:
	store i8 42, i8* %v5
	%tmp31 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v5, i32 0, i32 1
	store i16 0, i16* %tmp31
	%tmp32 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v5, i32 0, i32 2
	store i32 %start, i32* %tmp32
	%tmp33 = load %struct.TokenData, %struct.TokenData* %v5
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp33)
	br label %func_exit
; Variable temp is out.
endif7:
	%tmp34 = call i32 @mem.compare(i8* %tmp1, i8* @.str.116, i64 3)
	%tmp35 = icmp eq i32 %tmp34, 0
	br i1 %tmp35, label %then8, label %endif8
then8:
	store i8 36, i8* %v6
	%tmp36 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v6, i32 0, i32 1
	store i16 0, i16* %tmp36
	%tmp37 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v6, i32 0, i32 2
	store i32 %start, i32* %tmp37
	%tmp38 = load %struct.TokenData, %struct.TokenData* %v6
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp38)
	br label %func_exit
; Variable temp is out.
endif8:
	%tmp39 = call i32 @mem.compare(i8* %tmp1, i8* @.str.117, i64 3)
	%tmp40 = icmp eq i32 %tmp39, 0
	br i1 %tmp40, label %then9, label %endif9
then9:
	store i8 52, i8* %v7
	%tmp41 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v7, i32 0, i32 1
	store i16 0, i16* %tmp41
	%tmp42 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v7, i32 0, i32 2
	store i32 %start, i32* %tmp42
	%tmp43 = load %struct.TokenData, %struct.TokenData* %v7
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp43)
	br label %func_exit
; Variable temp is out.
endif9:
	br label %endif6
else6:
	%tmp44 = icmp eq i32 %tmp0, 4
	br i1 %tmp44, label %then10, label %else10
then10:
	%tmp45 = call i32 @mem.compare(i8* %tmp1, i8* @.str.118, i64 4)
	%tmp46 = icmp eq i32 %tmp45, 0
	br i1 %tmp46, label %then11, label %endif11
then11:
	store i8 62, i8* %v8
	%tmp47 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v8, i32 0, i32 1
	store i16 0, i16* %tmp47
	%tmp48 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v8, i32 0, i32 2
	store i32 %start, i32* %tmp48
	%tmp49 = load %struct.TokenData, %struct.TokenData* %v8
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp49)
	br label %func_exit
; Variable temp is out.
endif11:
	%tmp50 = call i32 @mem.compare(i8* %tmp1, i8* @.str.119, i64 4)
	%tmp51 = icmp eq i32 %tmp50, 0
	br i1 %tmp51, label %then12, label %endif12
then12:
	store i8 51, i8* %v9
	%tmp52 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v9, i32 0, i32 1
	store i16 0, i16* %tmp52
	%tmp53 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v9, i32 0, i32 2
	store i32 %start, i32* %tmp53
	%tmp54 = load %struct.TokenData, %struct.TokenData* %v9
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp54)
	br label %func_exit
; Variable temp is out.
endif12:
	%tmp55 = call i32 @mem.compare(i8* %tmp1, i8* @.str.120, i64 4)
	%tmp56 = icmp eq i32 %tmp55, 0
	br i1 %tmp56, label %then13, label %endif13
then13:
	store i8 59, i8* %v10
	%tmp57 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v10, i32 0, i32 1
	store i16 0, i16* %tmp57
	%tmp58 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v10, i32 0, i32 2
	store i32 %start, i32* %tmp58
	%tmp59 = load %struct.TokenData, %struct.TokenData* %v10
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp59)
	br label %func_exit
; Variable temp is out.
endif13:
	%tmp60 = call i32 @mem.compare(i8* %tmp1, i8* @.str.121, i64 4)
	%tmp61 = icmp eq i32 %tmp60, 0
	br i1 %tmp61, label %then14, label %endif14
then14:
	store i8 64, i8* %v11
	%tmp62 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v11, i32 0, i32 1
	store i16 0, i16* %tmp62
	%tmp63 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v11, i32 0, i32 2
	store i32 %start, i32* %tmp63
	%tmp64 = load %struct.TokenData, %struct.TokenData* %v11
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp64)
	br label %func_exit
; Variable temp is out.
endif14:
	%tmp65 = call i32 @mem.compare(i8* %tmp1, i8* @.str.122, i64 4)
	%tmp66 = icmp eq i32 %tmp65, 0
	br i1 %tmp66, label %then15, label %endif15
then15:
	store i8 46, i8* %v12
	%tmp67 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v12, i32 0, i32 1
	store i16 0, i16* %tmp67
	%tmp68 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v12, i32 0, i32 2
	store i32 %start, i32* %tmp68
	%tmp69 = load %struct.TokenData, %struct.TokenData* %v12
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp69)
	br label %func_exit
; Variable temp is out.
endif15:
	%tmp70 = call i32 @mem.compare(i8* %tmp1, i8* @.str.123, i64 4)
	%tmp71 = icmp eq i32 %tmp70, 0
	br i1 %tmp71, label %then16, label %endif16
then16:
	store i8 50, i8* %v13
	%tmp72 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v13, i32 0, i32 1
	store i16 0, i16* %tmp72
	%tmp73 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v13, i32 0, i32 2
	store i32 %start, i32* %tmp73
	%tmp74 = load %struct.TokenData, %struct.TokenData* %v13
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp74)
	br label %func_exit
; Variable temp is out.
endif16:
	%tmp75 = call i32 @mem.compare(i8* %tmp1, i8* @.str.124, i64 4)
	%tmp76 = icmp eq i32 %tmp75, 0
	br i1 %tmp76, label %then17, label %endif17
then17:
	store i8 48, i8* %v14
	%tmp77 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v14, i32 0, i32 1
	store i16 0, i16* %tmp77
	%tmp78 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v14, i32 0, i32 2
	store i32 %start, i32* %tmp78
	%tmp79 = load %struct.TokenData, %struct.TokenData* %v14
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp79)
	br label %func_exit
; Variable temp is out.
endif17:
	br label %endif10
else10:
	%tmp80 = icmp eq i32 %tmp0, 5
	br i1 %tmp80, label %then18, label %else18
then18:
	%tmp81 = call i32 @mem.compare(i8* %tmp1, i8* @.str.125, i64 5)
	%tmp82 = icmp eq i32 %tmp81, 0
	br i1 %tmp82, label %then19, label %endif19
then19:
	store i8 38, i8* %v15
	%tmp83 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v15, i32 0, i32 1
	store i16 0, i16* %tmp83
	%tmp84 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v15, i32 0, i32 2
	store i32 %start, i32* %tmp84
	%tmp85 = load %struct.TokenData, %struct.TokenData* %v15
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp85)
	br label %func_exit
; Variable temp is out.
endif19:
	%tmp86 = call i32 @mem.compare(i8* %tmp1, i8* @.str.126, i64 5)
	%tmp87 = icmp eq i32 %tmp86, 0
	br i1 %tmp87, label %then20, label %endif20
then20:
	store i8 40, i8* %v16
	%tmp88 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v16, i32 0, i32 1
	store i16 0, i16* %tmp88
	%tmp89 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v16, i32 0, i32 2
	store i32 %start, i32* %tmp89
	%tmp90 = load %struct.TokenData, %struct.TokenData* %v16
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp90)
	br label %func_exit
; Variable temp is out.
endif20:
	%tmp91 = call i32 @mem.compare(i8* %tmp1, i8* @.str.127, i64 5)
	%tmp92 = icmp eq i32 %tmp91, 0
	br i1 %tmp92, label %then21, label %endif21
then21:
	store i8 47, i8* %v17
	%tmp93 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v17, i32 0, i32 1
	store i16 0, i16* %tmp93
	%tmp94 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v17, i32 0, i32 2
	store i32 %start, i32* %tmp94
	%tmp95 = load %struct.TokenData, %struct.TokenData* %v17
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp95)
	br label %func_exit
; Variable temp is out.
endif21:
	%tmp96 = call i32 @mem.compare(i8* %tmp1, i8* @.str.128, i64 5)
	%tmp97 = icmp eq i32 %tmp96, 0
	br i1 %tmp97, label %then22, label %endif22
then22:
	store i8 55, i8* %v18
	%tmp98 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v18, i32 0, i32 1
	store i16 0, i16* %tmp98
	%tmp99 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v18, i32 0, i32 2
	store i32 %start, i32* %tmp99
	%tmp100 = load %struct.TokenData, %struct.TokenData* %v18
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp100)
	br label %func_exit
; Variable temp is out.
endif22:
	%tmp101 = call i32 @mem.compare(i8* %tmp1, i8* @.str.129, i64 5)
	%tmp102 = icmp eq i32 %tmp101, 0
	br i1 %tmp102, label %then23, label %endif23
then23:
	store i8 56, i8* %v19
	%tmp103 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v19, i32 0, i32 1
	store i16 0, i16* %tmp103
	%tmp104 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v19, i32 0, i32 2
	store i32 %start, i32* %tmp104
	%tmp105 = load %struct.TokenData, %struct.TokenData* %v19
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp105)
	br label %func_exit
; Variable temp is out.
endif23:
	%tmp106 = call i32 @mem.compare(i8* %tmp1, i8* @.str.130, i64 5)
	%tmp107 = icmp eq i32 %tmp106, 0
	br i1 %tmp107, label %then24, label %endif24
then24:
	store i8 63, i8* %v20
	%tmp108 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v20, i32 0, i32 1
	store i16 0, i16* %tmp108
	%tmp109 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v20, i32 0, i32 2
	store i32 %start, i32* %tmp109
	%tmp110 = load %struct.TokenData, %struct.TokenData* %v20
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp110)
	br label %func_exit
; Variable temp is out.
endif24:
	br label %endif18
else18:
	%tmp111 = icmp eq i32 %tmp0, 6
	br i1 %tmp111, label %then25, label %else25
then25:
	%tmp112 = call i32 @mem.compare(i8* %tmp1, i8* @.str.131, i64 6)
	%tmp113 = icmp eq i32 %tmp112, 0
	br i1 %tmp113, label %then26, label %endif26
then26:
	store i8 37, i8* %v21
	%tmp114 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v21, i32 0, i32 1
	store i16 0, i16* %tmp114
	%tmp115 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v21, i32 0, i32 2
	store i32 %start, i32* %tmp115
	%tmp116 = load %struct.TokenData, %struct.TokenData* %v21
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp116)
	br label %func_exit
; Variable temp is out.
endif26:
	%tmp117 = call i32 @mem.compare(i8* %tmp1, i8* @.str.132, i64 6)
	%tmp118 = icmp eq i32 %tmp117, 0
	br i1 %tmp118, label %then27, label %endif27
then27:
	store i8 39, i8* %v22
	%tmp119 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v22, i32 0, i32 1
	store i16 0, i16* %tmp119
	%tmp120 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v22, i32 0, i32 2
	store i32 %start, i32* %tmp120
	%tmp121 = load %struct.TokenData, %struct.TokenData* %v22
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp121)
	br label %func_exit
; Variable temp is out.
endif27:
	%tmp122 = call i32 @mem.compare(i8* %tmp1, i8* @.str.133, i64 6)
	%tmp123 = icmp eq i32 %tmp122, 0
	br i1 %tmp123, label %then28, label %endif28
then28:
	store i8 43, i8* %v23
	%tmp124 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v23, i32 0, i32 1
	store i16 0, i16* %tmp124
	%tmp125 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v23, i32 0, i32 2
	store i32 %start, i32* %tmp125
	%tmp126 = load %struct.TokenData, %struct.TokenData* %v23
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp126)
	br label %func_exit
; Variable temp is out.
endif28:
	%tmp127 = call i32 @mem.compare(i8* %tmp1, i8* @.str.134, i64 6)
	%tmp128 = icmp eq i32 %tmp127, 0
	br i1 %tmp128, label %then29, label %endif29
then29:
	store i8 49, i8* %v24
	%tmp129 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v24, i32 0, i32 1
	store i16 0, i16* %tmp129
	%tmp130 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v24, i32 0, i32 2
	store i32 %start, i32* %tmp130
	%tmp131 = load %struct.TokenData, %struct.TokenData* %v24
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp131)
	br label %func_exit
; Variable temp is out.
endif29:
	%tmp132 = call i32 @mem.compare(i8* %tmp1, i8* @.str.135, i64 6)
	%tmp133 = icmp eq i32 %tmp132, 0
	br i1 %tmp133, label %then30, label %endif30
then30:
	store i8 58, i8* %v25
	%tmp134 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v25, i32 0, i32 1
	store i16 0, i16* %tmp134
	%tmp135 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v25, i32 0, i32 2
	store i32 %start, i32* %tmp135
	%tmp136 = load %struct.TokenData, %struct.TokenData* %v25
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp136)
	br label %func_exit
; Variable temp is out.
endif30:
	br label %endif25
else25:
	%tmp137 = icmp eq i32 %tmp0, 8
	br i1 %tmp137, label %then31, label %else31
then31:
	%tmp138 = call i32 @mem.compare(i8* %tmp1, i8* @.str.136, i64 8)
	%tmp139 = icmp eq i32 %tmp138, 0
	br i1 %tmp139, label %then32, label %endif32
then32:
	store i8 57, i8* %v26
	%tmp140 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v26, i32 0, i32 1
	store i16 0, i16* %tmp140
	%tmp141 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v26, i32 0, i32 2
	store i32 %start, i32* %tmp141
	%tmp142 = load %struct.TokenData, %struct.TokenData* %v26
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp142)
	br label %func_exit
; Variable temp is out.
endif32:
	%tmp143 = call i32 @mem.compare(i8* %tmp1, i8* @.str.137, i64 8)
	%tmp144 = icmp eq i32 %tmp143, 0
	br i1 %tmp144, label %then33, label %endif33
then33:
	store i8 60, i8* %v27
	%tmp145 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v27, i32 0, i32 1
	store i16 0, i16* %tmp145
	%tmp146 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v27, i32 0, i32 2
	store i32 %start, i32* %tmp146
	%tmp147 = load %struct.TokenData, %struct.TokenData* %v27
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp147)
	br label %func_exit
; Variable temp is out.
endif33:
	br label %endif31
else31:
	%tmp148 = icmp eq i32 %tmp0, 9
	br i1 %tmp148, label %then34, label %endif34
then34:
	%tmp149 = call i32 @mem.compare(i8* %tmp1, i8* @.str.138, i64 9)
	%tmp150 = icmp eq i32 %tmp149, 0
	br i1 %tmp150, label %then35, label %endif35
then35:
	store i8 61, i8* %v28
	%tmp151 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v28, i32 0, i32 1
	store i16 0, i16* %tmp151
	%tmp152 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v28, i32 0, i32 2
	store i32 %start, i32* %tmp152
	%tmp153 = load %struct.TokenData, %struct.TokenData* %v28
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp153)
	br label %func_exit
; Variable temp is out.
endif35:
	br label %endif34
endif34:
	br label %endif31
endif31:
	br label %endif25
endif25:
	br label %endif18
endif18:
	br label %endif10
endif10:
	br label %endif6
endif6:
	br label %endif0
endif0:
	%tmp154 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %symbols, i32 0, i32 1
	%tmp155 = load i32, i32* %tmp154
	store i32 0, i32* %v29
	br label %loop_cond36
loop_cond36:
	%tmp156 = load i32, i32* %v29
	%tmp157 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %symbols, i32 0, i32 1
	%tmp158 = load i32, i32* %tmp157
	%tmp159 = icmp uge i32 %tmp156, %tmp158
	br i1 %tmp159, label %then37, label %endif37
then37:
	br label %loop_body36_exit
endif37:
	%tmp160 = load i32, i32* %v29
	%tmp161 = load %struct.string.String*, %struct.string.String** %symbols
	%tmp162 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp161, i32 %tmp160
	%tmp163 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp162, i32 0, i32 1
	%tmp164 = load i32, i32* %tmp163
	%tmp165 = icmp ne i32 %tmp164, %tmp0
	br i1 %tmp165, label %then38, label %endif38
then38:
	br label %loop_body36
endif38:
	%tmp166 = load i32, i32* %v29
	%tmp167 = load %struct.string.String*, %struct.string.String** %symbols
	%tmp168 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp167, i32 %tmp166
	%tmp169 = load i8*, i8** %tmp168
	%tmp170 = sext i32 %tmp0 to i64
	%tmp171 = call i32 @mem.compare(i8* %tmp1, i8* %tmp169, i64 %tmp170)
	%tmp172 = icmp eq i32 %tmp171, 0
	br i1 %tmp172, label %then39, label %endif39
then39:
	%tmp173 = load i32, i32* %v29
	%tmp174 = trunc i32 %tmp173 to i16
	store i8 65, i8* %v30
	%tmp175 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v30, i32 0, i32 1
	store i16 %tmp174, i16* %tmp175
	%tmp176 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v30, i32 0, i32 2
	store i32 %start, i32* %tmp176
	%tmp177 = load %struct.TokenData, %struct.TokenData* %v30
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp177)
	br label %func_exit
; Variable temp is out.
endif39:
	br label %loop_body36
loop_body36:
	%tmp178 = load i32, i32* %v29
	%tmp179 = add i32 %tmp178, 1
	store i32 %tmp179, i32* %v29
	br label %loop_cond36
loop_body36_exit:
	%tmp180 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %symbols, i32 0, i32 1
	%tmp181 = load i32, i32* %tmp180
	%tmp182 = trunc i32 %tmp181 to i16
	%tmp183 = call %struct.string.String @string.from_data(i8* %tmp1, i32 %tmp0)
	call void @"vector.push<%struct.string.String>"(%"struct.vector.Vec<%struct.string.String>"* %symbols, %struct.string.String %tmp183)
	store i8 65, i8* %v31
	%tmp184 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v31, i32 0, i32 1
	store i16 %tmp182, i16* %tmp184
	%tmp185 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v31, i32 0, i32 2
	store i32 %start, i32* %tmp185
	%tmp186 = load %struct.TokenData, %struct.TokenData* %v31
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp186)
	br label %func_exit
func_exit:
; Variable temp is out.
	ret void
}
define void @handle_string(i8* %data, i32 %start, i32 %end, %"struct.vector.Vec<%struct.TokenData>"* %tokens, %"struct.vector.Vec<%struct.string.String>"* %symbols){
	%v0 = alloca i32
	%v1 = alloca i32
	%v2 = alloca i8
	%v3 = alloca i8
	%v4 = alloca i8
	%v5 = alloca i32
	%v6 = alloca %struct.TokenData
	%v7 = alloca i16
	%v8 = alloca %struct.TokenData
	%tmp0 = sub i32 %end, %start
	%tmp1 = sub i32 %tmp0, 2
	%tmp2 = getelementptr inbounds i8, i8* %data, i32 %start
	%tmp3 = getelementptr inbounds i8, i8* %tmp2, i32 1
	%tmp4 = alloca i8, i32 %tmp1
	%tmp5 = add i32 %start, 1
	store i32 %tmp5, i32* %v0
	store i32 0, i32* %v1
	br label %loop_start0
loop_start0:
	%tmp6 = load i32, i32* %v0
	%tmp7 = sub i32 %end, 1
	%tmp8 = icmp ult i32 %tmp6, %tmp7
	br i1 %tmp8, label %endif1, label %else1
else1:
	br label %loop_body0_exit
endif1:
	%tmp9 = load i32, i32* %v0
	%tmp10 = getelementptr inbounds i8, i8* %data, i32 %tmp9
	%tmp11 = load i8, i8* %tmp10
	store i8 %tmp11, i8* %v2
	%tmp12 = load i8, i8* %v2
	%tmp13 = icmp eq i8 %tmp12, 92
	br i1 %tmp13, label %then2, label %endif2
then2:
	%tmp14 = load i32, i32* %v0
	%tmp15 = add i32 %tmp14, 1
	%tmp16 = getelementptr inbounds i8, i8* %data, i32 %tmp15
	%tmp17 = load i8, i8* %tmp16
	store i8 %tmp17, i8* %v3
	%tmp18 = load i8, i8* %v3
	%tmp19 = icmp eq i8 %tmp18, 92
	br i1 %tmp19, label %then3, label %else3
then3:
	store i8 92, i8* %v4
	br label %endif3
else3:
	%tmp20 = load i8, i8* %v3
	%tmp21 = icmp eq i8 %tmp20, 110
	br i1 %tmp21, label %then4, label %else4
then4:
	store i8 10, i8* %v4
	br label %endif4
else4:
	%tmp22 = load i8, i8* %v3
	%tmp23 = icmp eq i8 %tmp22, 114
	br i1 %tmp23, label %then5, label %else5
then5:
	store i8 13, i8* %v4
	br label %endif5
else5:
	%tmp24 = load i8, i8* %v3
	%tmp25 = icmp eq i8 %tmp24, 116
	br i1 %tmp25, label %then6, label %else6
then6:
	store i8 9, i8* %v4
	br label %endif6
else6:
	%tmp26 = load i8, i8* %v3
	%tmp27 = icmp eq i8 %tmp26, 39
	br i1 %tmp27, label %then7, label %else7
then7:
	store i8 39, i8* %v4
	br label %endif7
else7:
	%tmp28 = load i8, i8* %v3
	%tmp29 = icmp eq i8 %tmp28, 34
	br i1 %tmp29, label %then8, label %else8
then8:
	store i8 34, i8* %v4
	br label %endif8
else8:
	%tmp30 = load i8, i8* %v3
	%tmp31 = icmp eq i8 %tmp30, 118
	br i1 %tmp31, label %then9, label %else9
then9:
	store i8 11, i8* %v4
	br label %endif9
else9:
	%tmp32 = load i8, i8* %v3
	%tmp33 = icmp eq i8 %tmp32, 102
	br i1 %tmp33, label %then10, label %else10
then10:
	store i8 12, i8* %v4
	br label %endif10
else10:
	%tmp34 = load i8, i8* %v3
	%tmp35 = icmp eq i8 %tmp34, 48
	br i1 %tmp35, label %then11, label %else11
then11:
	store i8 0, i8* %v4
	br label %endif11
else11:
	%tmp36 = getelementptr inbounds i8, i8* %data, i32 %start
	%tmp37 = getelementptr inbounds i8, i8* %tmp36, i32 1
	%tmp38 = load i8, i8* %v3
	%tmp39 = sext i8 %tmp38 to i64
	call void @console.println_i64(i64 %tmp39)
	call void @console.writeln(i8* %tmp37, i32 %tmp1)
	call void @process.throw(i8* @.str.139)
	br label %endif11
endif11:
	br label %endif10
endif10:
	br label %endif9
endif9:
	br label %endif8
endif8:
	br label %endif7
endif7:
	br label %endif6
endif6:
	br label %endif5
endif5:
	br label %endif4
endif4:
	br label %endif3
endif3:
	%tmp40 = load i32, i32* %v1
	%tmp41 = getelementptr inbounds i8, i8* %tmp4, i32 %tmp40
	%tmp42 = load i8, i8* %v4
	store i8 %tmp42, i8* %tmp41
	%tmp43 = load i32, i32* %v1
	%tmp44 = add i32 %tmp43, 1
	store i32 %tmp44, i32* %v1
	%tmp45 = load i32, i32* %v0
	%tmp46 = add i32 %tmp45, 2
	store i32 %tmp46, i32* %v0
	br label %loop_body0
endif2:
	%tmp47 = load i32, i32* %v1
	%tmp48 = getelementptr inbounds i8, i8* %tmp4, i32 %tmp47
	%tmp49 = load i8, i8* %v2
	store i8 %tmp49, i8* %tmp48
	%tmp50 = load i32, i32* %v1
	%tmp51 = add i32 %tmp50, 1
	store i32 %tmp51, i32* %v1
	%tmp52 = load i32, i32* %v0
	%tmp53 = add i32 %tmp52, 1
	store i32 %tmp53, i32* %v0
	br label %loop_body0
loop_body0:
	br label %loop_start0
loop_body0_exit:
	%tmp54 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %symbols, i32 0, i32 1
	%tmp55 = load i32, i32* %tmp54
	store i32 0, i32* %v5
	br label %loop_cond12
loop_cond12:
	%tmp56 = load i32, i32* %v5
	%tmp57 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %symbols, i32 0, i32 1
	%tmp58 = load i32, i32* %tmp57
	%tmp59 = icmp uge i32 %tmp56, %tmp58
	br i1 %tmp59, label %then13, label %endif13
then13:
	br label %loop_body12_exit
endif13:
	%tmp60 = load i32, i32* %v5
	%tmp61 = load %struct.string.String*, %struct.string.String** %symbols
	%tmp62 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp61, i32 %tmp60
	%tmp63 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp62, i32 0, i32 1
	%tmp64 = load i32, i32* %tmp63
	%tmp65 = icmp ne i32 %tmp64, %tmp1
	br i1 %tmp65, label %then14, label %endif14
then14:
	br label %loop_body12
endif14:
	%tmp66 = load i32, i32* %v5
	%tmp67 = load %struct.string.String*, %struct.string.String** %symbols
	%tmp68 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp67, i32 %tmp66
	%tmp69 = load i8*, i8** %tmp68
	%tmp70 = sext i32 %tmp1 to i64
	%tmp71 = call i32 @mem.compare(i8* %tmp3, i8* %tmp69, i64 %tmp70)
	%tmp72 = icmp eq i32 %tmp71, 0
	br i1 %tmp72, label %then15, label %endif15
then15:
	%tmp73 = load i32, i32* %v5
	%tmp74 = trunc i32 %tmp73 to i16
	store i8 68, i8* %v6
	%tmp75 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v6, i32 0, i32 1
	store i16 %tmp74, i16* %tmp75
	%tmp76 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v6, i32 0, i32 2
	store i32 %start, i32* %tmp76
	%tmp77 = load %struct.TokenData, %struct.TokenData* %v6
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp77)
	br label %func_exit
; Variable temp is out.
endif15:
	br label %loop_body12
loop_body12:
	%tmp78 = load i32, i32* %v5
	%tmp79 = add i32 %tmp78, 1
	store i32 %tmp79, i32* %v5
	br label %loop_cond12
loop_body12_exit:
	%tmp80 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %symbols, i32 0, i32 1
	%tmp81 = load i32, i32* %tmp80
	%tmp82 = trunc i32 %tmp81 to i16
	store i16 %tmp82, i16* %v7
	%tmp83 = load i32, i32* %v1
	%tmp84 = call %struct.string.String @string.from_data(i8* %tmp4, i32 %tmp83)
	call void @"vector.push<%struct.string.String>"(%"struct.vector.Vec<%struct.string.String>"* %symbols, %struct.string.String %tmp84)
	%tmp85 = load i16, i16* %v7
	store i8 68, i8* %v8
	%tmp86 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v8, i32 0, i32 1
	store i16 %tmp85, i16* %tmp86
	%tmp87 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v8, i32 0, i32 2
	store i32 %start, i32* %tmp87
	%tmp88 = load %struct.TokenData, %struct.TokenData* %v8
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp88)
	br label %func_exit
func_exit:
; Variable temp is out.
	ret void
}
define void @handle_number(i8* %data, i32 %start, i32 %end, %"struct.vector.Vec<%struct.TokenData>"* %tokens, %"struct.vector.Vec<%struct.string.String>"* %symbols){
	%v0 = alloca i32
	%v1 = alloca %struct.TokenData
	%v2 = alloca i16
	%v3 = alloca %struct.TokenData
	%tmp0 = sub i32 %end, %start
	%tmp1 = getelementptr inbounds i8, i8* %data, i32 %start
	%tmp2 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %symbols, i32 0, i32 1
	%tmp3 = load i32, i32* %tmp2
	store i32 0, i32* %v0
	br label %loop_cond0
loop_cond0:
	%tmp4 = load i32, i32* %v0
	%tmp5 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %symbols, i32 0, i32 1
	%tmp6 = load i32, i32* %tmp5
	%tmp7 = icmp uge i32 %tmp4, %tmp6
	br i1 %tmp7, label %then1, label %endif1
then1:
	br label %loop_body0_exit
endif1:
	%tmp8 = load i32, i32* %v0
	%tmp9 = load %struct.string.String*, %struct.string.String** %symbols
	%tmp10 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp9, i32 %tmp8
	%tmp11 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp10, i32 0, i32 1
	%tmp12 = load i32, i32* %tmp11
	%tmp13 = icmp ne i32 %tmp12, %tmp0
	br i1 %tmp13, label %then2, label %endif2
then2:
	br label %loop_body0
endif2:
	%tmp14 = load i32, i32* %v0
	%tmp15 = load %struct.string.String*, %struct.string.String** %symbols
	%tmp16 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp15, i32 %tmp14
	%tmp17 = load i8*, i8** %tmp16
	%tmp18 = sext i32 %tmp0 to i64
	%tmp19 = call i32 @mem.compare(i8* %tmp1, i8* %tmp17, i64 %tmp18)
	%tmp20 = icmp eq i32 %tmp19, 0
	br i1 %tmp20, label %then3, label %endif3
then3:
	%tmp21 = load i32, i32* %v0
	%tmp22 = trunc i32 %tmp21 to i16
	store i8 68, i8* %v1
	%tmp23 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v1, i32 0, i32 1
	store i16 %tmp22, i16* %tmp23
	%tmp24 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v1, i32 0, i32 2
	store i32 %start, i32* %tmp24
	%tmp25 = load %struct.TokenData, %struct.TokenData* %v1
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp25)
	br label %func_exit
; Variable temp is out.
endif3:
	br label %loop_body0
loop_body0:
	%tmp26 = load i32, i32* %v0
	%tmp27 = add i32 %tmp26, 1
	store i32 %tmp27, i32* %v0
	br label %loop_cond0
loop_body0_exit:
	%tmp28 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %symbols, i32 0, i32 1
	%tmp29 = load i32, i32* %tmp28
	%tmp30 = trunc i32 %tmp29 to i16
	store i16 %tmp30, i16* %v2
	%tmp31 = call %struct.string.String @string.from_data(i8* %tmp1, i32 %tmp0)
	call void @"vector.push<%struct.string.String>"(%"struct.vector.Vec<%struct.string.String>"* %symbols, %struct.string.String %tmp31)
	%tmp32 = load i16, i16* %v2
	store i8 66, i8* %v3
	%tmp33 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v3, i32 0, i32 1
	store i16 %tmp32, i16* %tmp33
	%tmp34 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v3, i32 0, i32 2
	store i32 %start, i32* %tmp34
	%tmp35 = load %struct.TokenData, %struct.TokenData* %v3
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp35)
	br label %func_exit
func_exit:
; Variable temp is out.
	ret void
}
define void @handle_decimal_number(i8* %data, i32 %start, i32 %end, %"struct.vector.Vec<%struct.TokenData>"* %tokens, %"struct.vector.Vec<%struct.string.String>"* %symbols){
	%v0 = alloca i32
	%v1 = alloca %struct.TokenData
	%v2 = alloca i16
	%v3 = alloca %struct.TokenData
	%tmp0 = sub i32 %end, %start
	%tmp1 = getelementptr inbounds i8, i8* %data, i32 %start
	%tmp2 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %symbols, i32 0, i32 1
	%tmp3 = load i32, i32* %tmp2
	store i32 0, i32* %v0
	br label %loop_cond0
loop_cond0:
	%tmp4 = load i32, i32* %v0
	%tmp5 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %symbols, i32 0, i32 1
	%tmp6 = load i32, i32* %tmp5
	%tmp7 = icmp uge i32 %tmp4, %tmp6
	br i1 %tmp7, label %then1, label %endif1
then1:
	br label %loop_body0_exit
endif1:
	%tmp8 = load i32, i32* %v0
	%tmp9 = load %struct.string.String*, %struct.string.String** %symbols
	%tmp10 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp9, i32 %tmp8
	%tmp11 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp10, i32 0, i32 1
	%tmp12 = load i32, i32* %tmp11
	%tmp13 = icmp ne i32 %tmp12, %tmp0
	br i1 %tmp13, label %then2, label %endif2
then2:
	br label %loop_body0
endif2:
	%tmp14 = load i32, i32* %v0
	%tmp15 = load %struct.string.String*, %struct.string.String** %symbols
	%tmp16 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp15, i32 %tmp14
	%tmp17 = load i8*, i8** %tmp16
	%tmp18 = sext i32 %tmp0 to i64
	%tmp19 = call i32 @mem.compare(i8* %tmp1, i8* %tmp17, i64 %tmp18)
	%tmp20 = icmp eq i32 %tmp19, 0
	br i1 %tmp20, label %then3, label %endif3
then3:
	%tmp21 = load i32, i32* %v0
	%tmp22 = trunc i32 %tmp21 to i16
	store i8 68, i8* %v1
	%tmp23 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v1, i32 0, i32 1
	store i16 %tmp22, i16* %tmp23
	%tmp24 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v1, i32 0, i32 2
	store i32 %start, i32* %tmp24
	%tmp25 = load %struct.TokenData, %struct.TokenData* %v1
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp25)
	br label %func_exit
; Variable temp is out.
endif3:
	br label %loop_body0
loop_body0:
	%tmp26 = load i32, i32* %v0
	%tmp27 = add i32 %tmp26, 1
	store i32 %tmp27, i32* %v0
	br label %loop_cond0
loop_body0_exit:
	%tmp28 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %symbols, i32 0, i32 1
	%tmp29 = load i32, i32* %tmp28
	%tmp30 = trunc i32 %tmp29 to i16
	store i16 %tmp30, i16* %v2
	%tmp31 = call %struct.string.String @string.from_data(i8* %tmp1, i32 %tmp0)
	call void @"vector.push<%struct.string.String>"(%"struct.vector.Vec<%struct.string.String>"* %symbols, %struct.string.String %tmp31)
	%tmp32 = load i16, i16* %v2
	store i8 67, i8* %v3
	%tmp33 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v3, i32 0, i32 1
	store i16 %tmp32, i16* %tmp33
	%tmp34 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v3, i32 0, i32 2
	store i32 %start, i32* %tmp34
	%tmp35 = load %struct.TokenData, %struct.TokenData* %v3
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp35)
	br label %func_exit
func_exit:
; Variable temp is out.
	ret void
}
define void @handle_char(i8* %data, i32 %start, i32 %end, %"struct.vector.Vec<%struct.TokenData>"* %tokens, %"struct.vector.Vec<%struct.string.String>"* %symbols){
	%v0 = alloca i8
	%v1 = alloca i16
	%v2 = alloca %struct.TokenData
	%v3 = alloca %struct.TokenData
	%tmp0 = sub i32 %end, %start
	%tmp1 = sub i32 %tmp0, 2
	%tmp2 = getelementptr inbounds i8, i8* %data, i32 %start
	%tmp3 = getelementptr inbounds i8, i8* %tmp2, i32 1
	%tmp4 = load i8, i8* %tmp3
	%tmp5 = icmp eq i8 %tmp4, 92
	br i1 %tmp5, label %then0, label %endif0
then0:
	%tmp6 = getelementptr inbounds i8, i8* %tmp3, i32 1
	%tmp7 = load i8, i8* %tmp6
	store i8 %tmp7, i8* %v0
	%tmp8 = load i8, i8* %v0
	%tmp9 = icmp eq i8 %tmp8, 92
	br i1 %tmp9, label %then1, label %else1
then1:
	store i16 92, i16* %v1
	br label %endif1
else1:
	%tmp10 = load i8, i8* %v0
	%tmp11 = icmp eq i8 %tmp10, 110
	br i1 %tmp11, label %then2, label %else2
then2:
	store i16 10, i16* %v1
	br label %endif2
else2:
	%tmp12 = load i8, i8* %v0
	%tmp13 = icmp eq i8 %tmp12, 114
	br i1 %tmp13, label %then3, label %else3
then3:
	store i16 13, i16* %v1
	br label %endif3
else3:
	%tmp14 = load i8, i8* %v0
	%tmp15 = icmp eq i8 %tmp14, 116
	br i1 %tmp15, label %then4, label %else4
then4:
	store i16 9, i16* %v1
	br label %endif4
else4:
	%tmp16 = load i8, i8* %v0
	%tmp17 = icmp eq i8 %tmp16, 39
	br i1 %tmp17, label %then5, label %else5
then5:
	store i16 39, i16* %v1
	br label %endif5
else5:
	%tmp18 = load i8, i8* %v0
	%tmp19 = icmp eq i8 %tmp18, 118
	br i1 %tmp19, label %then6, label %else6
then6:
	store i16 11, i16* %v1
	br label %endif6
else6:
	%tmp20 = load i8, i8* %v0
	%tmp21 = icmp eq i8 %tmp20, 102
	br i1 %tmp21, label %then7, label %else7
then7:
	store i16 12, i16* %v1
	br label %endif7
else7:
	%tmp22 = load i8, i8* %v0
	%tmp23 = icmp eq i8 %tmp22, 48
	br i1 %tmp23, label %then8, label %else8
then8:
	store i16 0, i16* %v1
	br label %endif8
else8:
	call void @console.writeln(i8* %tmp3, i32 %tmp1)
	call void @process.throw(i8* @.str.139)
	br label %endif8
endif8:
	br label %endif7
endif7:
	br label %endif6
endif6:
	br label %endif5
endif5:
	br label %endif4
endif4:
	br label %endif3
endif3:
	br label %endif2
endif2:
	br label %endif1
endif1:
	%tmp24 = load i16, i16* %v1
	store i8 69, i8* %v2
	%tmp25 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v2, i32 0, i32 1
	store i16 %tmp24, i16* %tmp25
	%tmp26 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v2, i32 0, i32 2
	store i32 %start, i32* %tmp26
	%tmp27 = load %struct.TokenData, %struct.TokenData* %v2
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp27)
	br label %func_exit
; Variable temp is out.
endif0:
	%tmp28 = icmp ne i32 %tmp1, 1
	br i1 %tmp28, label %then9, label %endif9
then9:
	call void @process.throw(i8* @.str.140)
	br label %endif9
endif9:
	%tmp29 = sext i8 %tmp4 to i16
	store i8 69, i8* %v3
	%tmp30 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v3, i32 0, i32 1
	store i16 %tmp29, i16* %tmp30
	%tmp31 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v3, i32 0, i32 2
	store i32 %start, i32* %tmp31
	%tmp32 = load %struct.TokenData, %struct.TokenData* %v3
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp32)
	br label %func_exit
func_exit:
; Variable temp is out.
	ret void
}
define void @expect(%struct.TokenData* %tokens, i32* %index, i32 %len, i8 %expected, i8* %error_msg){
entry:
	%tmp0 = load i32, i32* %index
	%tmp1 = icmp uge i32 %tmp0, %len
	br i1 %tmp1, label %logic_end_0, label %logic_rhs_0
logic_rhs_0:
	%tmp2 = load i32, i32* %index
	%tmp3 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp2
	%tmp4 = load i8, i8* %tmp3
	%tmp5 = icmp ne i8 %tmp4, %expected
	br label %logic_end_0
logic_end_0:
	%tmp6 = phi i1 [%tmp1, %entry], [%tmp5, %logic_rhs_0]
	br i1 %tmp6, label %then1, label %endif1
then1:
	call void @process.throw(i8* %error_msg)
	br label %endif1
endif1:
	%tmp7 = load i32, i32* %index
	%tmp8 = add i32 %tmp7, 1
	store i32 %tmp8, i32* %index
	ret void
}
define i32 @string_utils.c_str_len(i8* %str){
	%v0 = alloca i32
	store i32 0, i32* %v0
	br label %loop_start0
loop_start0:
	%tmp0 = load i32, i32* %v0
	%tmp1 = getelementptr inbounds i8, i8* %str, i32 %tmp0
	%tmp2 = load i8, i8* %tmp1
	%tmp3 = icmp ne i8 %tmp2, 0
	br i1 %tmp3, label %endif1, label %else1
else1:
	br label %loop_body0_exit
endif1:
	%tmp4 = load i32, i32* %v0
	%tmp5 = add i32 %tmp4, 1
	store i32 %tmp5, i32* %v0
	br label %loop_start0
loop_body0_exit:
	%tmp6 = load i32, i32* %v0
	ret i32 %tmp6
}
define %struct.string.String @string.from_data(i8* %data, i32 %len){
	%v0 = alloca %struct.string.String
	%tmp0 = add i32 %len, 1
	%tmp1 = sext i32 %tmp0 to i64
	%tmp2 = mul i64 1, %tmp1
	%tmp3 = call i8* @mem.malloc(i64 %tmp2)
	store i8* %tmp3, i8** %v0
	%tmp4 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	store i32 %len, i32* %tmp4
	%tmp5 = load i8*, i8** %v0
	%tmp6 = sext i32 %len to i64
	call void @mem.copy(i8* %data, i8* %tmp5, i64 %tmp6)
	%tmp7 = load i8*, i8** %v0
	%tmp8 = getelementptr inbounds i8, i8* %tmp7, i32 %len
	store i8 0, i8* %tmp8
	%tmp9 = load %struct.string.String, %struct.string.String* %v0
; Variable x is out.
	ret %struct.string.String %tmp9
}
define %struct.string.String @string.from_c_string(i8* %c_string){
	%v0 = alloca %struct.string.String
	%tmp0 = call i32 @string_utils.c_str_len(i8* %c_string)
	%tmp1 = add i32 %tmp0, 1
	%tmp2 = sext i32 %tmp1 to i64
	%tmp3 = mul i64 1, %tmp2
	%tmp4 = call i8* @mem.malloc(i64 %tmp3)
	store i8* %tmp4, i8** %v0
	%tmp5 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	store i32 %tmp0, i32* %tmp5
	%tmp6 = load i8*, i8** %v0
	%tmp7 = sext i32 %tmp0 to i64
	call void @mem.copy(i8* %c_string, i8* %tmp6, i64 %tmp7)
	%tmp8 = load i8*, i8** %v0
	%tmp9 = getelementptr inbounds i8, i8* %tmp8, i32 %tmp0
	store i8 0, i8* %tmp9
	%tmp10 = load %struct.string.String, %struct.string.String* %v0
; Variable x is out.
	ret %struct.string.String %tmp10
}
define %struct.string.String @string.clone(%struct.string.String* %src){
	%v0 = alloca %struct.string.String
	%tmp0 = getelementptr inbounds %struct.string.String, %struct.string.String* %src, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = getelementptr inbounds %struct.string.String, %struct.string.String* %src, i32 0, i32 1
	%tmp3 = load i32, i32* %tmp2
	%tmp4 = add i32 %tmp1, 1
	%tmp5 = sext i32 %tmp4 to i64
	%tmp6 = mul i64 1, %tmp5
	%tmp7 = call i8* @mem.malloc(i64 %tmp6)
	store i8* %tmp7, i8** %v0
	%tmp8 = getelementptr inbounds %struct.string.String, %struct.string.String* %v0, i32 0, i32 1
	store i32 %tmp3, i32* %tmp8
	%tmp9 = load i8*, i8** %src
	%tmp10 = load i8*, i8** %v0
	%tmp11 = sext i32 %tmp1 to i64
	call void @mem.copy(i8* %tmp9, i8* %tmp10, i64 %tmp11)
	%tmp12 = load i8*, i8** %v0
	%tmp13 = getelementptr inbounds i8, i8* %tmp12, i32 %tmp1
	store i8 0, i8* %tmp13
	%tmp14 = load %struct.string.String, %struct.string.String* %v0
; Variable x is out.
	ret %struct.string.String %tmp14
}
define void @mem.zero_fill(i8* %dest, i64 %len){
	call void @mem.fill(i8 0, i8* %dest, i64 %len)
	ret void
}
define void @mem.copy(i8* %src, i8* %dest, i64 %len){
	%v0 = alloca i64
	store i64 0, i64* %v0
	br label %loop_cond0
loop_cond0:
	%tmp0 = load i64, i64* %v0
	%tmp1 = icmp sge i64 %tmp0, %len
	br i1 %tmp1, label %then1, label %endif1
then1:
	br label %loop_body0_exit
endif1:
	%tmp2 = load i64, i64* %v0
	%tmp3 = getelementptr inbounds i8, i8* %dest, i64 %tmp2
	%tmp4 = load i64, i64* %v0
	%tmp5 = getelementptr inbounds i8, i8* %src, i64 %tmp4
	%tmp6 = load i8, i8* %tmp5
	store i8 %tmp6, i8* %tmp3
	%tmp7 = load i64, i64* %v0
	%tmp8 = add i64 %tmp7, 1
	store i64 %tmp8, i64* %v0
	br label %loop_cond0
loop_body0_exit:
	ret void
}
define i32 @mem.compare(i8* %left, i8* %right, i64 %len){
	%v0 = alloca i64
	store i64 0, i64* %v0
	br label %loop_cond0
loop_cond0:
	%tmp0 = load i64, i64* %v0
	%tmp1 = icmp sge i64 %tmp0, %len
	br i1 %tmp1, label %then1, label %endif1
then1:
	br label %loop_body0_exit
endif1:
	%tmp2 = load i64, i64* %v0
	%tmp3 = getelementptr inbounds i8, i8* %left, i64 %tmp2
	%tmp4 = load i8, i8* %tmp3
	%tmp5 = load i64, i64* %v0
	%tmp6 = getelementptr inbounds i8, i8* %right, i64 %tmp5
	%tmp7 = load i8, i8* %tmp6
	%tmp8 = icmp slt i8 %tmp4, %tmp7
	br i1 %tmp8, label %then2, label %endif2
then2:
	br label %func_exit
endif2:
	%tmp9 = load i64, i64* %v0
	%tmp10 = getelementptr inbounds i8, i8* %left, i64 %tmp9
	%tmp11 = load i8, i8* %tmp10
	%tmp12 = load i64, i64* %v0
	%tmp13 = getelementptr inbounds i8, i8* %right, i64 %tmp12
	%tmp14 = load i8, i8* %tmp13
	%tmp15 = icmp sgt i8 %tmp11, %tmp14
	br i1 %tmp15, label %then3, label %endif3
then3:
	br label %func_exit
endif3:
	%tmp16 = load i64, i64* %v0
	%tmp17 = add i64 %tmp16, 1
	store i64 %tmp17, i64* %v0
	br label %loop_cond0
loop_body0_exit:
	br label %func_exit
func_exit:
	%tmp18 = phi i32 [-1, %then2], [1, %then3], [0, %loop_body0_exit]
	ret i32 %tmp18
}
define void @console.writeln(i8* %buffer, i32 %len){
	%v0 = alloca i32
	%v1 = alloca i8
	call void @console.write(i8* %buffer, i32 %len)
	store i8 10, i8* %v1
	%tmp0 = call i8* @console.get_stdout()
	call i32 @WriteConsoleA(i8* %tmp0, i8* %v1, i32 1, i32* %v0, i8* null)
	ret void
}
define void @"vector.push<%struct.string.String>"(%"struct.vector.Vec<%struct.string.String>"* %vec, %struct.string.String %data){
	%v0 = alloca i32
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 2
	%tmp3 = load i32, i32* %tmp2
	%tmp4 = icmp uge i32 %tmp1, %tmp3
	br i1 %tmp4, label %then0, label %endif0
then0:
	store i32 4, i32* %v0
	%tmp5 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 2
	%tmp6 = load i32, i32* %tmp5
	%tmp7 = icmp ne i32 %tmp6, 0
	br i1 %tmp7, label %then1, label %endif1
then1:
	%tmp8 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 2
	%tmp9 = load i32, i32* %tmp8
	%tmp10 = mul i32 %tmp9, 2
	store i32 %tmp10, i32* %v0
	br label %endif1
endif1:
	%tmp11 = load i32, i32* %v0
	%tmp12 = zext i32 %tmp11 to i64
	%tmp13 = mul i64 16, %tmp12
	%tmp14 = load %struct.string.String*, %struct.string.String** %vec
	%tmp15 = call i8* @mem.realloc(i8* %tmp14, i64 %tmp13)
	store %struct.string.String* %tmp15, %struct.string.String** %vec
	%tmp16 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 2
	%tmp17 = load i32, i32* %v0
	store i32 %tmp17, i32* %tmp16
	br label %endif0
endif0:
	%tmp18 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 1
	%tmp19 = load i32, i32* %tmp18
	%tmp20 = load %struct.string.String*, %struct.string.String** %vec
	%tmp21 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp20, i32 %tmp19
	store %struct.string.String %data, %struct.string.String* %tmp21
	%tmp22 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 1
	%tmp23 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %vec, i32 0, i32 1
	%tmp24 = load i32, i32* %tmp23
	%tmp25 = add i32 %tmp24, 1
	store i32 %tmp25, i32* %tmp22
; Variable data is out.
	ret void
}
define void @"vector.push<%struct.EnumField>"(%"struct.vector.Vec<%struct.EnumField>"* %vec, %struct.EnumField %data){
	%v0 = alloca i32
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.EnumField>", %"struct.vector.Vec<%struct.EnumField>"* %vec, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = getelementptr inbounds %"struct.vector.Vec<%struct.EnumField>", %"struct.vector.Vec<%struct.EnumField>"* %vec, i32 0, i32 2
	%tmp3 = load i32, i32* %tmp2
	%tmp4 = icmp uge i32 %tmp1, %tmp3
	br i1 %tmp4, label %then0, label %endif0
then0:
	store i32 4, i32* %v0
	%tmp5 = getelementptr inbounds %"struct.vector.Vec<%struct.EnumField>", %"struct.vector.Vec<%struct.EnumField>"* %vec, i32 0, i32 2
	%tmp6 = load i32, i32* %tmp5
	%tmp7 = icmp ne i32 %tmp6, 0
	br i1 %tmp7, label %then1, label %endif1
then1:
	%tmp8 = getelementptr inbounds %"struct.vector.Vec<%struct.EnumField>", %"struct.vector.Vec<%struct.EnumField>"* %vec, i32 0, i32 2
	%tmp9 = load i32, i32* %tmp8
	%tmp10 = mul i32 %tmp9, 2
	store i32 %tmp10, i32* %v0
	br label %endif1
endif1:
	%tmp11 = load i32, i32* %v0
	%tmp12 = zext i32 %tmp11 to i64
	%tmp13 = mul i64 8, %tmp12
	%tmp14 = load %struct.EnumField*, %struct.EnumField** %vec
	%tmp15 = call i8* @mem.realloc(i8* %tmp14, i64 %tmp13)
	store %struct.EnumField* %tmp15, %struct.EnumField** %vec
	%tmp16 = getelementptr inbounds %"struct.vector.Vec<%struct.EnumField>", %"struct.vector.Vec<%struct.EnumField>"* %vec, i32 0, i32 2
	%tmp17 = load i32, i32* %v0
	store i32 %tmp17, i32* %tmp16
	br label %endif0
endif0:
	%tmp18 = getelementptr inbounds %"struct.vector.Vec<%struct.EnumField>", %"struct.vector.Vec<%struct.EnumField>"* %vec, i32 0, i32 1
	%tmp19 = load i32, i32* %tmp18
	%tmp20 = load %struct.EnumField*, %struct.EnumField** %vec
	%tmp21 = getelementptr inbounds %struct.EnumField, %struct.EnumField* %tmp20, i32 %tmp19
	store %struct.EnumField %data, %struct.EnumField* %tmp21
	%tmp22 = getelementptr inbounds %"struct.vector.Vec<%struct.EnumField>", %"struct.vector.Vec<%struct.EnumField>"* %vec, i32 0, i32 1
	%tmp23 = getelementptr inbounds %"struct.vector.Vec<%struct.EnumField>", %"struct.vector.Vec<%struct.EnumField>"* %vec, i32 0, i32 1
	%tmp24 = load i32, i32* %tmp23
	%tmp25 = add i32 %tmp24, 1
	store i32 %tmp25, i32* %tmp22
; Variable data is out.
	ret void
}
define void @"vector.push<%struct.Expression>"(%"struct.vector.Vec<%struct.Expression>"* %vec, %struct.Expression %data){
	%v0 = alloca i32
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Expression>"* %vec, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = getelementptr inbounds %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Expression>"* %vec, i32 0, i32 2
	%tmp3 = load i32, i32* %tmp2
	%tmp4 = icmp uge i32 %tmp1, %tmp3
	br i1 %tmp4, label %then0, label %endif0
then0:
	store i32 4, i32* %v0
	%tmp5 = getelementptr inbounds %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Expression>"* %vec, i32 0, i32 2
	%tmp6 = load i32, i32* %tmp5
	%tmp7 = icmp ne i32 %tmp6, 0
	br i1 %tmp7, label %then1, label %endif1
then1:
	%tmp8 = getelementptr inbounds %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Expression>"* %vec, i32 0, i32 2
	%tmp9 = load i32, i32* %tmp8
	%tmp10 = mul i32 %tmp9, 2
	store i32 %tmp10, i32* %v0
	br label %endif1
endif1:
	%tmp11 = load i32, i32* %v0
	%tmp12 = zext i32 %tmp11 to i64
	%tmp13 = mul i64 4, %tmp12
	%tmp14 = load %struct.Expression*, %struct.Expression** %vec
	%tmp15 = call i8* @mem.realloc(i8* %tmp14, i64 %tmp13)
	store %struct.Expression* %tmp15, %struct.Expression** %vec
	%tmp16 = getelementptr inbounds %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Expression>"* %vec, i32 0, i32 2
	%tmp17 = load i32, i32* %v0
	store i32 %tmp17, i32* %tmp16
	br label %endif0
endif0:
	%tmp18 = getelementptr inbounds %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Expression>"* %vec, i32 0, i32 1
	%tmp19 = load i32, i32* %tmp18
	%tmp20 = load %struct.Expression*, %struct.Expression** %vec
	%tmp21 = getelementptr inbounds %struct.Expression, %struct.Expression* %tmp20, i32 %tmp19
	store %struct.Expression %data, %struct.Expression* %tmp21
	%tmp22 = getelementptr inbounds %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Expression>"* %vec, i32 0, i32 1
	%tmp23 = getelementptr inbounds %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Expression>"* %vec, i32 0, i32 1
	%tmp24 = load i32, i32* %tmp23
	%tmp25 = add i32 %tmp24, 1
	store i32 %tmp25, i32* %tmp22
; Variable data is out.
	ret void
}
define void @"vector.push<i16>"(%"struct.vector.Vec<i16>"* %vec, i16 %data){
	%v0 = alloca i32
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<i16>", %"struct.vector.Vec<i16>"* %vec, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = getelementptr inbounds %"struct.vector.Vec<i16>", %"struct.vector.Vec<i16>"* %vec, i32 0, i32 2
	%tmp3 = load i32, i32* %tmp2
	%tmp4 = icmp uge i32 %tmp1, %tmp3
	br i1 %tmp4, label %then0, label %endif0
then0:
	store i32 4, i32* %v0
	%tmp5 = getelementptr inbounds %"struct.vector.Vec<i16>", %"struct.vector.Vec<i16>"* %vec, i32 0, i32 2
	%tmp6 = load i32, i32* %tmp5
	%tmp7 = icmp ne i32 %tmp6, 0
	br i1 %tmp7, label %then1, label %endif1
then1:
	%tmp8 = getelementptr inbounds %"struct.vector.Vec<i16>", %"struct.vector.Vec<i16>"* %vec, i32 0, i32 2
	%tmp9 = load i32, i32* %tmp8
	%tmp10 = mul i32 %tmp9, 2
	store i32 %tmp10, i32* %v0
	br label %endif1
endif1:
	%tmp11 = load i32, i32* %v0
	%tmp12 = zext i32 %tmp11 to i64
	%tmp13 = mul i64 2, %tmp12
	%tmp14 = load i16*, i16** %vec
	%tmp15 = call i8* @mem.realloc(i8* %tmp14, i64 %tmp13)
	store i16* %tmp15, i16** %vec
	%tmp16 = getelementptr inbounds %"struct.vector.Vec<i16>", %"struct.vector.Vec<i16>"* %vec, i32 0, i32 2
	%tmp17 = load i32, i32* %v0
	store i32 %tmp17, i32* %tmp16
	br label %endif0
endif0:
	%tmp18 = getelementptr inbounds %"struct.vector.Vec<i16>", %"struct.vector.Vec<i16>"* %vec, i32 0, i32 1
	%tmp19 = load i32, i32* %tmp18
	%tmp20 = load i16*, i16** %vec
	%tmp21 = getelementptr inbounds i16, i16* %tmp20, i32 %tmp19
	store i16 %data, i16* %tmp21
	%tmp22 = getelementptr inbounds %"struct.vector.Vec<i16>", %"struct.vector.Vec<i16>"* %vec, i32 0, i32 1
	%tmp23 = getelementptr inbounds %"struct.vector.Vec<i16>", %"struct.vector.Vec<i16>"* %vec, i32 0, i32 1
	%tmp24 = load i32, i32* %tmp23
	%tmp25 = add i32 %tmp24, 1
	store i32 %tmp25, i32* %tmp22
	ret void
}
define void @"vector.push<%struct.Argument>"(%"struct.vector.Vec<%struct.Argument>"* %vec, %struct.Argument %data){
	%v0 = alloca i32
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %vec, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = getelementptr inbounds %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %vec, i32 0, i32 2
	%tmp3 = load i32, i32* %tmp2
	%tmp4 = icmp uge i32 %tmp1, %tmp3
	br i1 %tmp4, label %then0, label %endif0
then0:
	store i32 4, i32* %v0
	%tmp5 = getelementptr inbounds %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %vec, i32 0, i32 2
	%tmp6 = load i32, i32* %tmp5
	%tmp7 = icmp ne i32 %tmp6, 0
	br i1 %tmp7, label %then1, label %endif1
then1:
	%tmp8 = getelementptr inbounds %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %vec, i32 0, i32 2
	%tmp9 = load i32, i32* %tmp8
	%tmp10 = mul i32 %tmp9, 2
	store i32 %tmp10, i32* %v0
	br label %endif1
endif1:
	%tmp11 = load i32, i32* %v0
	%tmp12 = zext i32 %tmp11 to i64
	%tmp13 = mul i64 8, %tmp12
	%tmp14 = load %struct.Argument*, %struct.Argument** %vec
	%tmp15 = call i8* @mem.realloc(i8* %tmp14, i64 %tmp13)
	store %struct.Argument* %tmp15, %struct.Argument** %vec
	%tmp16 = getelementptr inbounds %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %vec, i32 0, i32 2
	%tmp17 = load i32, i32* %v0
	store i32 %tmp17, i32* %tmp16
	br label %endif0
endif0:
	%tmp18 = getelementptr inbounds %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %vec, i32 0, i32 1
	%tmp19 = load i32, i32* %tmp18
	%tmp20 = load %struct.Argument*, %struct.Argument** %vec
	%tmp21 = getelementptr inbounds %struct.Argument, %struct.Argument* %tmp20, i32 %tmp19
	store %struct.Argument %data, %struct.Argument* %tmp21
	%tmp22 = getelementptr inbounds %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %vec, i32 0, i32 1
	%tmp23 = getelementptr inbounds %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %vec, i32 0, i32 1
	%tmp24 = load i32, i32* %tmp23
	%tmp25 = add i32 %tmp24, 1
	store i32 %tmp25, i32* %tmp22
; Variable data is out.
	ret void
}
define void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %vec, %struct.TokenData %data){
	%v0 = alloca i32
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.TokenData>", %"struct.vector.Vec<%struct.TokenData>"* %vec, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = getelementptr inbounds %"struct.vector.Vec<%struct.TokenData>", %"struct.vector.Vec<%struct.TokenData>"* %vec, i32 0, i32 2
	%tmp3 = load i32, i32* %tmp2
	%tmp4 = icmp uge i32 %tmp1, %tmp3
	br i1 %tmp4, label %then0, label %endif0
then0:
	store i32 4, i32* %v0
	%tmp5 = getelementptr inbounds %"struct.vector.Vec<%struct.TokenData>", %"struct.vector.Vec<%struct.TokenData>"* %vec, i32 0, i32 2
	%tmp6 = load i32, i32* %tmp5
	%tmp7 = icmp ne i32 %tmp6, 0
	br i1 %tmp7, label %then1, label %endif1
then1:
	%tmp8 = getelementptr inbounds %"struct.vector.Vec<%struct.TokenData>", %"struct.vector.Vec<%struct.TokenData>"* %vec, i32 0, i32 2
	%tmp9 = load i32, i32* %tmp8
	%tmp10 = mul i32 %tmp9, 2
	store i32 %tmp10, i32* %v0
	br label %endif1
endif1:
	%tmp11 = load i32, i32* %v0
	%tmp12 = zext i32 %tmp11 to i64
	%tmp13 = mul i64 8, %tmp12
	%tmp14 = load %struct.TokenData*, %struct.TokenData** %vec
	%tmp15 = call i8* @mem.realloc(i8* %tmp14, i64 %tmp13)
	store %struct.TokenData* %tmp15, %struct.TokenData** %vec
	%tmp16 = getelementptr inbounds %"struct.vector.Vec<%struct.TokenData>", %"struct.vector.Vec<%struct.TokenData>"* %vec, i32 0, i32 2
	%tmp17 = load i32, i32* %v0
	store i32 %tmp17, i32* %tmp16
	br label %endif0
endif0:
	%tmp18 = getelementptr inbounds %"struct.vector.Vec<%struct.TokenData>", %"struct.vector.Vec<%struct.TokenData>"* %vec, i32 0, i32 1
	%tmp19 = load i32, i32* %tmp18
	%tmp20 = load %struct.TokenData*, %struct.TokenData** %vec
	%tmp21 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp20, i32 %tmp19
	store %struct.TokenData %data, %struct.TokenData* %tmp21
	%tmp22 = getelementptr inbounds %"struct.vector.Vec<%struct.TokenData>", %"struct.vector.Vec<%struct.TokenData>"* %vec, i32 0, i32 1
	%tmp23 = getelementptr inbounds %"struct.vector.Vec<%struct.TokenData>", %"struct.vector.Vec<%struct.TokenData>"* %vec, i32 0, i32 1
	%tmp24 = load i32, i32* %tmp23
	%tmp25 = add i32 %tmp24, 1
	store i32 %tmp25, i32* %tmp22
; Variable data is out.
	ret void
}
define void @"vector.push<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %vec, %struct.Stmt %data){
	%v0 = alloca i32
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %vec, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = getelementptr inbounds %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %vec, i32 0, i32 2
	%tmp3 = load i32, i32* %tmp2
	%tmp4 = icmp uge i32 %tmp1, %tmp3
	br i1 %tmp4, label %then0, label %endif0
then0:
	store i32 4, i32* %v0
	%tmp5 = getelementptr inbounds %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %vec, i32 0, i32 2
	%tmp6 = load i32, i32* %tmp5
	%tmp7 = icmp ne i32 %tmp6, 0
	br i1 %tmp7, label %then1, label %endif1
then1:
	%tmp8 = getelementptr inbounds %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %vec, i32 0, i32 2
	%tmp9 = load i32, i32* %tmp8
	%tmp10 = mul i32 %tmp9, 2
	store i32 %tmp10, i32* %v0
	br label %endif1
endif1:
	%tmp11 = load i32, i32* %v0
	%tmp12 = zext i32 %tmp11 to i64
	%tmp13 = mul i64 16, %tmp12
	%tmp14 = load %struct.Stmt*, %struct.Stmt** %vec
	%tmp15 = call i8* @mem.realloc(i8* %tmp14, i64 %tmp13)
	store %struct.Stmt* %tmp15, %struct.Stmt** %vec
	%tmp16 = getelementptr inbounds %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %vec, i32 0, i32 2
	%tmp17 = load i32, i32* %v0
	store i32 %tmp17, i32* %tmp16
	br label %endif0
endif0:
	%tmp18 = getelementptr inbounds %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %vec, i32 0, i32 1
	%tmp19 = load i32, i32* %tmp18
	%tmp20 = load %struct.Stmt*, %struct.Stmt** %vec
	%tmp21 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp20, i32 %tmp19
	store %struct.Stmt %data, %struct.Stmt* %tmp21
	%tmp22 = getelementptr inbounds %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %vec, i32 0, i32 1
	%tmp23 = getelementptr inbounds %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %vec, i32 0, i32 1
	%tmp24 = load i32, i32* %tmp23
	%tmp25 = add i32 %tmp24, 1
	store i32 %tmp25, i32* %tmp22
; Variable data is out.
	ret void
}
define %"struct.vector.Vec<%struct.Argument>" @"vector.new<%struct.Argument>"(){
	%v0 = alloca %"struct.vector.Vec<%struct.Argument>"
	store %struct.Argument* null, %struct.Argument** %v0
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %v0, i32 0, i32 1
	store i32 0, i32* %tmp0
	%tmp1 = getelementptr inbounds %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %v0, i32 0, i32 2
	store i32 0, i32* %tmp1
	%tmp2 = load %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %v0
; Variable vec is out.
	ret %"struct.vector.Vec<%struct.Argument>" %tmp2
}
define %"struct.vector.Vec<%struct.EnumField>" @"vector.new<%struct.EnumField>"(){
	%v0 = alloca %"struct.vector.Vec<%struct.EnumField>"
	store %struct.EnumField* null, %struct.EnumField** %v0
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.EnumField>", %"struct.vector.Vec<%struct.EnumField>"* %v0, i32 0, i32 1
	store i32 0, i32* %tmp0
	%tmp1 = getelementptr inbounds %"struct.vector.Vec<%struct.EnumField>", %"struct.vector.Vec<%struct.EnumField>"* %v0, i32 0, i32 2
	store i32 0, i32* %tmp1
	%tmp2 = load %"struct.vector.Vec<%struct.EnumField>", %"struct.vector.Vec<%struct.EnumField>"* %v0
; Variable vec is out.
	ret %"struct.vector.Vec<%struct.EnumField>" %tmp2
}
define %"struct.vector.Vec<i16>" @"vector.new<i16>"(){
	%v0 = alloca %"struct.vector.Vec<i16>"
	store i16* null, i16** %v0
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<i16>", %"struct.vector.Vec<i16>"* %v0, i32 0, i32 1
	store i32 0, i32* %tmp0
	%tmp1 = getelementptr inbounds %"struct.vector.Vec<i16>", %"struct.vector.Vec<i16>"* %v0, i32 0, i32 2
	store i32 0, i32* %tmp1
	%tmp2 = load %"struct.vector.Vec<i16>", %"struct.vector.Vec<i16>"* %v0
; Variable vec is out.
	ret %"struct.vector.Vec<i16>" %tmp2
}
define %"struct.vector.Vec<%struct.Expression>" @"vector.new<%struct.Expression>"(){
	%v0 = alloca %"struct.vector.Vec<%struct.Expression>"
	store %struct.Expression* null, %struct.Expression** %v0
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Expression>"* %v0, i32 0, i32 1
	store i32 0, i32* %tmp0
	%tmp1 = getelementptr inbounds %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Expression>"* %v0, i32 0, i32 2
	store i32 0, i32* %tmp1
	%tmp2 = load %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Expression>"* %v0
; Variable vec is out.
	ret %"struct.vector.Vec<%struct.Expression>" %tmp2
}
define %"struct.vector.Vec<%struct.Stmt>" @"vector.new<%struct.Stmt>"(){
	%v0 = alloca %"struct.vector.Vec<%struct.Stmt>"
	store %struct.Stmt* null, %struct.Stmt** %v0
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %v0, i32 0, i32 1
	store i32 0, i32* %tmp0
	%tmp1 = getelementptr inbounds %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %v0, i32 0, i32 2
	store i32 0, i32* %tmp1
	%tmp2 = load %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %v0
; Variable vec is out.
	ret %"struct.vector.Vec<%struct.Stmt>" %tmp2
}
define %"struct.vector.Vec<%struct.string.String>" @"vector.new<%struct.string.String>"(){
	%v0 = alloca %"struct.vector.Vec<%struct.string.String>"
	store %struct.string.String* null, %struct.string.String** %v0
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %v0, i32 0, i32 1
	store i32 0, i32* %tmp0
	%tmp1 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %v0, i32 0, i32 2
	store i32 0, i32* %tmp1
	%tmp2 = load %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %v0
; Variable vec is out.
	ret %"struct.vector.Vec<%struct.string.String>" %tmp2
}
define %"struct.vector.Vec<%struct.TokenData>" @"vector.new<%struct.TokenData>"(){
	%v0 = alloca %"struct.vector.Vec<%struct.TokenData>"
	store %struct.TokenData* null, %struct.TokenData** %v0
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.TokenData>", %"struct.vector.Vec<%struct.TokenData>"* %v0, i32 0, i32 1
	store i32 0, i32* %tmp0
	%tmp1 = getelementptr inbounds %"struct.vector.Vec<%struct.TokenData>", %"struct.vector.Vec<%struct.TokenData>"* %v0, i32 0, i32 2
	store i32 0, i32* %tmp1
	%tmp2 = load %"struct.vector.Vec<%struct.TokenData>", %"struct.vector.Vec<%struct.TokenData>"* %v0
; Variable vec is out.
	ret %"struct.vector.Vec<%struct.TokenData>" %tmp2
}
define void @"mem.default_fill<i8>"(i8 %val, i8* %dest, i64 %len){
	%v0 = alloca i64
	store i64 0, i64* %v0
	br label %loop_cond0
loop_cond0:
	%tmp0 = load i64, i64* %v0
	%tmp1 = icmp sge i64 %tmp0, %len
	br i1 %tmp1, label %then1, label %endif1
then1:
	br label %loop_body0_exit
endif1:
	%tmp2 = load i64, i64* %v0
	%tmp3 = getelementptr inbounds i8, i8* %dest, i64 %tmp2
	store i8 %val, i8* %tmp3
	%tmp4 = load i64, i64* %v0
	%tmp5 = add i64 %tmp4, 1
	store i64 %tmp5, i64* %v0
	br label %loop_cond0
loop_body0_exit:
	ret void
}
define i8* @mem.realloc(i8* %ptr, i64 %size){
	%tmp0 = icmp eq i8* %ptr, null
	br i1 %tmp0, label %then0, label %endif0
then0:
	%tmp1 = call i8* @mem.malloc(i64 %size)
	br label %func_exit
endif0:
	%tmp2 = call i32* @GetProcessHeap()
	%tmp3 = call i8* @HeapReAlloc(i32* %tmp2, i32 0, i8* %ptr, i64 %size)
	%tmp4 = icmp eq i8* %tmp3, null
	br i1 %tmp4, label %then1, label %endif1
then1:
	call void @process.throw(i8* @.str.141)
	br label %endif1
endif1:
	br label %func_exit
func_exit:
	%tmp5 = phi i8* [%tmp1, %then0], [%tmp3, %endif1]
	ret i8* %tmp5
}

;func __chkstk ["no_lazy"]
;func _fltused ["no_lazy"]
;func expect []
;func handle_char []
;func handle_decimal_number []
;func handle_number []
;func handle_string []
;func handle_symbol []
;func is_modifier []
;func lex []
;func main []
;func parse []
;func parse_argument_comma []
;func parse_enum_fields []
;func parse_expression []
;func parse_expression_comma []
;func parse_generic_params []
;func parse_struct_fields []
;func parse_type []
;func skip_nested []
;func token_type_to_string []
;func char_utils.is_alnum []
;func char_utils.is_alpha []
;func char_utils.is_cntrl []
;func char_utils.is_digit []
;func char_utils.is_xdigit []
;func console.get_stdout []
;func console.print_char []
;func console.println_i64 []
;func console.println_u64 []
;func console.write []
;func console.write_string []
;func console.writeln []
;func fs.read_full_file_as_string []
;func mem.compare []
;func mem.copy []
;func mem.default_fill []
;func mem.fill []
;func mem.free []
;func mem.malloc []
;func mem.realloc []
;func mem.zero_fill []
;func process.throw ["no_return"]
;func string.clone ["ExtentionOf"]
;func string.empty []
;func string.free ["ExtentionOf"]
;func string.from_c_string []
;func string.from_data []
;func string.with_size []
;func string_utils.c_str_len []
;func string_utils.insert []
;func vector.new []
;func vector.push ["ExtentionOf"]
;type Argument
;type EnumField
;type EnumNode
;type Expression
;type FnNode
;type HintNode
;type NamespaceNode
;type Stmt
;type StructNode
;type TokenData
;type Type
;type mem.PROCESS_HEAP_ENTRY
;type string.String
;type vector.Vec
;type window.BITMAP
;type window.MSG
;type window.PAINTSTRUCT
;type window.POINT
;type window.RECT
;type window.WNDCLASSEXA
