%struct.Argument = type { i16, %struct.Type }
%struct.Expression = type { i32 }
%struct.FnNode = type { i16, %"struct.vector.Vec<%struct.Argument>", %struct.Type* }
%struct.HintNode = type { i16, %"struct.vector.Vec<%struct.Expression>" }
%struct.Stmt = type { i8, i8* }
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
%"struct.vector.Vec<%struct.Expression>" = type { %struct.Expression*, i32, i32 }
%"struct.vector.Vec<%struct.Argument>" = type { %struct.Argument*, i32, i32 }
%"struct.vector.Vec<%struct.TokenData>" = type { %struct.TokenData*, i32, i32 }
%"struct.vector.Vec<%struct.string.String>" = type { %struct.string.String*, i32, i32 }
%"struct.vector.Vec<%struct.Stmt>" = type { %struct.Stmt*, i32, i32 }
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
declare dllimport void @ExitProcess(i32 %code)noreturn


@.str.0 = private unnamed_addr constant [45 x i8] c"D:/Projects/rcsharp/src_base_structs.rcsharp\00"
@.str.1 = private unnamed_addr constant [17 x i8] c"File not found: \00"
@.str.2 = private unnamed_addr constant [17 x i8] c"File read failed\00"
@.str.3 = private unnamed_addr constant [9 x i8] c"ACHTUNG:\00"
@.str.4 = private unnamed_addr constant [24 x i8] c"Character not expected!\00"
@.str.5 = private unnamed_addr constant [12 x i8] c"Exception: \00"
@.str.6 = private unnamed_addr constant [3 x i8] c"if\00"
@.str.7 = private unnamed_addr constant [3 x i8] c"do\00"
@.str.8 = private unnamed_addr constant [3 x i8] c"as\00"
@.str.9 = private unnamed_addr constant [3 x i8] c"in\00"
@.str.10 = private unnamed_addr constant [3 x i8] c"fn\00"
@.str.11 = private unnamed_addr constant [4 x i8] c"let\00"
@.str.12 = private unnamed_addr constant [4 x i8] c"pub\00"
@.str.13 = private unnamed_addr constant [4 x i8] c"for\00"
@.str.14 = private unnamed_addr constant [5 x i8] c"true\00"
@.str.15 = private unnamed_addr constant [5 x i8] c"loop\00"
@.str.16 = private unnamed_addr constant [5 x i8] c"this\00"
@.str.17 = private unnamed_addr constant [5 x i8] c"null\00"
@.str.18 = private unnamed_addr constant [5 x i8] c"else\00"
@.str.19 = private unnamed_addr constant [5 x i8] c"enum\00"
@.str.20 = private unnamed_addr constant [26 x i8] c"Invalid escape character!\00"
@.str.21 = private unnamed_addr constant [17 x i8] c"Char is too long\00"
@.str.22 = private unnamed_addr constant [14 x i8] c"Out of memory\00"
@.str.23 = private unnamed_addr constant [3 x i8] c"0\0A\00"
@.str.24 = private unnamed_addr constant [26 x i8] c"stdout handle was invalid\00"
@.str.25 = private unnamed_addr constant [15 x i8] c"Realloc failed\00"
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
	%v4 = alloca %"struct.vector.Vec<%struct.Stmt>"
	%tmp0 = call %struct.string.String @fs.read_full_file_as_string(i8* @.str.0)
	store %struct.string.String %tmp0, %struct.string.String* %v0
	%tmp1 = call %"struct.vector.Vec<%struct.TokenData>" @"vector.new<%struct.TokenData>"()
	store %"struct.vector.Vec<%struct.TokenData>" %tmp1, %"struct.vector.Vec<%struct.TokenData>"* %v1
	%tmp2 = call %"struct.vector.Vec<%struct.string.String>" @"vector.new<%struct.string.String>"()
	store %"struct.vector.Vec<%struct.string.String>" %tmp2, %"struct.vector.Vec<%struct.string.String>"* %v2
	call void @lex(%struct.string.String* %v0, %"struct.vector.Vec<%struct.TokenData>"* %v1, %"struct.vector.Vec<%struct.string.String>"* %v2)
	%tmp3 = call %"struct.vector.Vec<%struct.Stmt>" @"vector.new<%struct.Stmt>"()
	store %"struct.vector.Vec<%struct.Stmt>" %tmp3, %"struct.vector.Vec<%struct.Stmt>"* %v3
	call void @parse(%"struct.vector.Vec<%struct.TokenData>"* %v1, %"struct.vector.Vec<%struct.string.String>"* %v2, %"struct.vector.Vec<%struct.Stmt>"* %v3)
	%tmp4 = call %"struct.vector.Vec<%struct.Stmt>" @"vector.new<%struct.Stmt>"()
	store %"struct.vector.Vec<%struct.Stmt>" %tmp4, %"struct.vector.Vec<%struct.Stmt>"* %v4
	call void @string.free(%struct.string.String* %v0)
	call void @ExitProcess(i32 0)
; Variable output is out.
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
	%tmp3 = call i8* @string_utils.insert(i8* @.str.1, i8* %path, i32 16)
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
	call void @process.throw(i8* @.str.2)
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
define void @parse(%"struct.vector.Vec<%struct.TokenData>"* %token_vector, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %"struct.vector.Vec<%struct.Stmt>"* %statement_vector){
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
	br i1 %tmp89, label %then29, label %else29
then29:
	%tmp90 = load i32, i32* %v0
	%tmp91 = add i32 %tmp90, 1
	store i32 %tmp91, i32* %v5
	%tmp92 = load i8, i8* %v1
	%tmp93 = icmp eq i8 %tmp92, 48
	br i1 %tmp93, label %then30, label %endif30
then30:
	%tmp94 = load i8, i8* %v2
	%tmp95 = icmp eq i8 %tmp94, 120
	br i1 %tmp95, label %then31, label %else31
then31:
	%tmp96 = load i32, i32* %v5
	%tmp97 = add i32 %tmp96, 1
	store i32 %tmp97, i32* %v5
	br label %endif31
else31:
	%tmp98 = load i8, i8* %v2
	%tmp99 = icmp eq i8 %tmp98, 98
	br i1 %tmp99, label %then32, label %endif32
then32:
	%tmp100 = load i32, i32* %v5
	%tmp101 = add i32 %tmp100, 1
	store i32 %tmp101, i32* %v5
	br label %endif32
endif32:
	br label %endif31
endif31:
	br label %endif30
endif30:
	store i1 false, i1* %v6
	br label %loop_start33
loop_start33:
	%tmp102 = load i32, i32* %v5
	%tmp103 = getelementptr inbounds %struct.string.String, %struct.string.String* %data, i32 0, i32 1
	%tmp104 = load i32, i32* %tmp103
	%tmp105 = icmp ult i32 %tmp102, %tmp104
	br i1 %tmp105, label %endif34, label %else34
else34:
	br label %loop_body33_exit
endif34:
	%tmp106 = load i32, i32* %v5
	%tmp107 = load i8*, i8** %data
	%tmp108 = getelementptr inbounds i8, i8* %tmp107, i32 %tmp106
	%tmp109 = load i8, i8* %tmp108
	br label %inl_entry36
inl_entry36:
	%tmp110 = icmp sge i8 %tmp109, 48
	br i1 %tmp110, label %logic_rhs_37, label %logic_end_37
logic_rhs_37:
	%tmp111 = icmp sle i8 %tmp109, 57
	br label %logic_end_37
logic_end_37:
	%tmp112 = phi i1 [%tmp110, %inl_entry36], [%tmp111, %logic_rhs_37]
	br label %inl_exit36
inl_exit36:
	br i1 %tmp112, label %logic_end_38, label %logic_rhs_38
logic_rhs_38:
	%tmp113 = icmp sge i8 %tmp109, 97
	br i1 %tmp113, label %logic_rhs_39, label %logic_end_39
logic_rhs_39:
	%tmp114 = icmp sle i8 %tmp109, 102
	br label %logic_end_39
logic_end_39:
	%tmp115 = phi i1 [%tmp113, %logic_rhs_38], [%tmp114, %logic_rhs_39]
	br label %logic_end_38
logic_end_38:
	%tmp116 = phi i1 [%tmp112, %inl_exit36], [%tmp115, %logic_end_39]
	br i1 %tmp116, label %logic_end_40, label %logic_rhs_40
logic_rhs_40:
	%tmp117 = icmp sge i8 %tmp109, 65
	br i1 %tmp117, label %logic_rhs_41, label %logic_end_41
logic_rhs_41:
	%tmp118 = icmp sle i8 %tmp109, 70
	br label %logic_end_41
logic_end_41:
	%tmp119 = phi i1 [%tmp117, %logic_rhs_40], [%tmp118, %logic_rhs_41]
	br label %logic_end_40
logic_end_40:
	%tmp120 = phi i1 [%tmp116, %logic_end_38], [%tmp119, %logic_end_41]
	br i1 %tmp120, label %then42, label %endif42
then42:
	%tmp121 = load i32, i32* %v5
	%tmp122 = add i32 %tmp121, 1
	store i32 %tmp122, i32* %v5
	br label %loop_body33
endif42:
	%tmp123 = load i32, i32* %v5
	%tmp124 = load i8*, i8** %data
	%tmp125 = getelementptr inbounds i8, i8* %tmp124, i32 %tmp123
	%tmp126 = load i8, i8* %tmp125
	%tmp127 = icmp eq i8 %tmp126, 46
	br i1 %tmp127, label %then43, label %endif43
then43:
	%tmp128 = load i1, i1* %v6
	%tmp129 = xor i1 1, %tmp128
	br i1 %tmp129, label %then44, label %endif44
then44:
	store i1 true, i1* %v6
	%tmp130 = load i32, i32* %v5
	%tmp131 = add i32 %tmp130, 1
	store i32 %tmp131, i32* %v5
	br label %loop_body33
endif44:
	br label %endif43
endif43:
	br label %loop_body33_exit
loop_body33:
	br label %loop_start33
loop_body33_exit:
	%tmp132 = load i1, i1* %v6
	br i1 %tmp132, label %then45, label %else45
then45:
	%tmp133 = load i8*, i8** %data
	%tmp134 = load i32, i32* %v0
	%tmp135 = load i32, i32* %v5
	call void @handle_decimal_number(i8* %tmp133, i32 %tmp134, i32 %tmp135, %"struct.vector.Vec<%struct.TokenData>"* %token_vector, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector)
	br label %endif45
else45:
	%tmp136 = load i8*, i8** %data
	%tmp137 = load i32, i32* %v0
	%tmp138 = load i32, i32* %v5
	call void @handle_number(i8* %tmp136, i32 %tmp137, i32 %tmp138, %"struct.vector.Vec<%struct.TokenData>"* %token_vector, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector)
	br label %endif45
endif45:
	%tmp139 = load i32, i32* %v5
	store i32 %tmp139, i32* %v0
	br label %loop_body0
else29:
	%tmp140 = load i8, i8* %v1
	%tmp141 = icmp eq i8 %tmp140, 34
	br i1 %tmp141, label %then46, label %else46
then46:
	%tmp142 = load i32, i32* %v0
	%tmp143 = add i32 %tmp142, 1
	store i32 %tmp143, i32* %v7
	store i1 false, i1* %v8
	br label %loop_start47
loop_start47:
	%tmp144 = load i32, i32* %v7
	%tmp145 = getelementptr inbounds %struct.string.String, %struct.string.String* %data, i32 0, i32 1
	%tmp146 = load i32, i32* %tmp145
	%tmp147 = icmp ult i32 %tmp144, %tmp146
	br i1 %tmp147, label %endif48, label %else48
else48:
	br label %loop_body47_exit
endif48:
	%tmp148 = load i32, i32* %v7
	%tmp149 = load i8*, i8** %data
	%tmp150 = getelementptr inbounds i8, i8* %tmp149, i32 %tmp148
	%tmp151 = load i8, i8* %tmp150
	%tmp152 = icmp eq i8 %tmp151, 34
	br i1 %tmp152, label %then49, label %endif49
then49:
	%tmp153 = load i1, i1* %v8
	br i1 %tmp153, label %then50, label %else50
then50:
	store i1 false, i1* %v8
	%tmp154 = load i32, i32* %v7
	%tmp155 = add i32 %tmp154, 1
	store i32 %tmp155, i32* %v7
	br label %loop_body47
else50:
	%tmp156 = load i32, i32* %v7
	%tmp157 = add i32 %tmp156, 1
	store i32 %tmp157, i32* %v7
	br label %loop_body47_exit
	br label %endif49
endif49:
	%tmp158 = load i32, i32* %v7
	%tmp159 = load i8*, i8** %data
	%tmp160 = getelementptr inbounds i8, i8* %tmp159, i32 %tmp158
	%tmp161 = load i8, i8* %tmp160
	%tmp162 = icmp eq i8 %tmp161, 92
	br i1 %tmp162, label %then51, label %endif51
then51:
	%tmp163 = load i1, i1* %v8
	%tmp164 = xor i1 1, %tmp163
	store i1 %tmp164, i1* %v8
	%tmp165 = load i32, i32* %v7
	%tmp166 = add i32 %tmp165, 1
	store i32 %tmp166, i32* %v7
	br label %loop_body47
endif51:
	%tmp167 = load i1, i1* %v8
	br i1 %tmp167, label %then52, label %endif52
then52:
	store i1 false, i1* %v8
	br label %endif52
endif52:
	%tmp168 = load i32, i32* %v7
	%tmp169 = add i32 %tmp168, 1
	store i32 %tmp169, i32* %v7
	br label %loop_body47
loop_body47:
	br label %loop_start47
loop_body47_exit:
	%tmp170 = load i8*, i8** %data
	%tmp171 = load i32, i32* %v0
	%tmp172 = load i32, i32* %v7
	call void @handle_string(i8* %tmp170, i32 %tmp171, i32 %tmp172, %"struct.vector.Vec<%struct.TokenData>"* %token_vector, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector)
	%tmp173 = load i32, i32* %v7
	store i32 %tmp173, i32* %v0
	br label %loop_body0
else46:
	%tmp174 = load i8, i8* %v1
	%tmp175 = icmp eq i8 %tmp174, 39
	br i1 %tmp175, label %then53, label %else53
then53:
	%tmp176 = load i32, i32* %v0
	%tmp177 = add i32 %tmp176, 1
	store i32 %tmp177, i32* %v9
	store i1 false, i1* %v10
	br label %loop_start54
loop_start54:
	%tmp178 = load i32, i32* %v9
	%tmp179 = getelementptr inbounds %struct.string.String, %struct.string.String* %data, i32 0, i32 1
	%tmp180 = load i32, i32* %tmp179
	%tmp181 = icmp ult i32 %tmp178, %tmp180
	br i1 %tmp181, label %endif55, label %else55
else55:
	br label %loop_body54_exit
endif55:
	%tmp182 = load i32, i32* %v9
	%tmp183 = load i8*, i8** %data
	%tmp184 = getelementptr inbounds i8, i8* %tmp183, i32 %tmp182
	%tmp185 = load i8, i8* %tmp184
	%tmp186 = icmp eq i8 %tmp185, 39
	br i1 %tmp186, label %then56, label %endif56
then56:
	%tmp187 = load i1, i1* %v10
	br i1 %tmp187, label %then57, label %else57
then57:
	store i1 false, i1* %v10
	%tmp188 = load i32, i32* %v9
	%tmp189 = add i32 %tmp188, 1
	store i32 %tmp189, i32* %v9
	br label %loop_body54
else57:
	%tmp190 = load i32, i32* %v9
	%tmp191 = add i32 %tmp190, 1
	store i32 %tmp191, i32* %v9
	br label %loop_body54_exit
	br label %endif56
endif56:
	%tmp192 = load i32, i32* %v9
	%tmp193 = load i8*, i8** %data
	%tmp194 = getelementptr inbounds i8, i8* %tmp193, i32 %tmp192
	%tmp195 = load i8, i8* %tmp194
	%tmp196 = icmp eq i8 %tmp195, 92
	br i1 %tmp196, label %then58, label %endif58
then58:
	%tmp197 = load i1, i1* %v10
	%tmp198 = xor i1 1, %tmp197
	store i1 %tmp198, i1* %v10
	%tmp199 = load i32, i32* %v9
	%tmp200 = add i32 %tmp199, 1
	store i32 %tmp200, i32* %v9
	br label %loop_body54
endif58:
	%tmp201 = load i1, i1* %v10
	br i1 %tmp201, label %then59, label %endif59
then59:
	store i1 false, i1* %v10
	br label %endif59
endif59:
	%tmp202 = load i32, i32* %v9
	%tmp203 = add i32 %tmp202, 1
	store i32 %tmp203, i32* %v9
	br label %loop_body54
loop_body54:
	br label %loop_start54
loop_body54_exit:
	%tmp204 = load i8*, i8** %data
	%tmp205 = load i32, i32* %v0
	%tmp206 = load i32, i32* %v9
	call void @handle_char(i8* %tmp204, i32 %tmp205, i32 %tmp206, %"struct.vector.Vec<%struct.TokenData>"* %token_vector, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector)
	%tmp207 = load i32, i32* %v9
	store i32 %tmp207, i32* %v0
	br label %loop_body0
else53:
	%tmp208 = load i8, i8* %v1
	%tmp209 = icmp eq i8 %tmp208, 47
	br i1 %tmp209, label %logic_rhs_60, label %logic_end_60
logic_rhs_60:
	%tmp210 = load i8, i8* %v2
	%tmp211 = icmp eq i8 %tmp210, 47
	br label %logic_end_60
logic_end_60:
	%tmp212 = phi i1 [%tmp209, %else53], [%tmp211, %logic_rhs_60]
	br i1 %tmp212, label %then61, label %else61
then61:
	%tmp213 = load i32, i32* %v0
	%tmp214 = add i32 %tmp213, 2
	store i32 %tmp214, i32* %v11
	br label %loop_start62
loop_start62:
	%tmp215 = load i32, i32* %v11
	%tmp216 = getelementptr inbounds %struct.string.String, %struct.string.String* %data, i32 0, i32 1
	%tmp217 = load i32, i32* %tmp216
	%tmp218 = icmp ult i32 %tmp215, %tmp217
	br i1 %tmp218, label %endif63, label %else63
else63:
	br label %loop_body62_exit
endif63:
	%tmp219 = load i32, i32* %v11
	%tmp220 = load i8*, i8** %data
	%tmp221 = getelementptr inbounds i8, i8* %tmp220, i32 %tmp219
	%tmp222 = load i8, i8* %tmp221
	%tmp223 = icmp eq i8 %tmp222, 10
	br i1 %tmp223, label %then64, label %endif64
then64:
	%tmp224 = load i32, i32* %v11
	%tmp225 = add i32 %tmp224, 1
	store i32 %tmp225, i32* %v11
	br label %loop_body62_exit
endif64:
	%tmp226 = load i32, i32* %v11
	%tmp227 = add i32 %tmp226, 1
	store i32 %tmp227, i32* %v11
	br label %loop_start62
loop_body62_exit:
	%tmp228 = load i32, i32* %v11
	%tmp229 = load i32, i32* %v0
	%tmp230 = sub i32 %tmp228, %tmp229
	store i32 %tmp230, i32* %v12
	%tmp231 = load i8*, i8** %data
	%tmp232 = load i32, i32* %v0
	%tmp233 = getelementptr inbounds i8, i8* %tmp231, i32 %tmp232
	%tmp234 = load i32, i32* %v12
	%tmp235 = sext i32 %tmp234 to i64
	call void @mem.fill(i8 0, i8* %tmp233, i64 %tmp235)
	%tmp236 = load i32, i32* %v11
	store i32 %tmp236, i32* %v0
	br label %loop_body0
else61:
	%tmp237 = load i8, i8* %v1
	%tmp238 = icmp eq i8 %tmp237, 47
	br i1 %tmp238, label %logic_rhs_65, label %logic_end_65
logic_rhs_65:
	%tmp239 = load i8, i8* %v2
	%tmp240 = icmp eq i8 %tmp239, 42
	br label %logic_end_65
logic_end_65:
	%tmp241 = phi i1 [%tmp238, %else61], [%tmp240, %logic_rhs_65]
	br i1 %tmp241, label %then66, label %endif66
then66:
	%tmp242 = load i32, i32* %v0
	%tmp243 = add i32 %tmp242, 2
	store i32 %tmp243, i32* %v13
	store i32 1, i32* %v14
	store i1 false, i1* %v15
	br label %loop_start67
loop_start67:
	%tmp244 = load i32, i32* %v13
	%tmp245 = getelementptr inbounds %struct.string.String, %struct.string.String* %data, i32 0, i32 1
	%tmp246 = load i32, i32* %tmp245
	%tmp247 = icmp ult i32 %tmp244, %tmp246
	br i1 %tmp247, label %endif68, label %else68
else68:
	br label %loop_body67_exit
endif68:
	%tmp248 = load i32, i32* %v13
	%tmp249 = add i32 %tmp248, 1
	%tmp250 = getelementptr inbounds %struct.string.String, %struct.string.String* %data, i32 0, i32 1
	%tmp251 = load i32, i32* %tmp250
	%tmp252 = icmp ult i32 %tmp249, %tmp251
	br i1 %tmp252, label %then69, label %endif69
then69:
	%tmp253 = load i32, i32* %v13
	%tmp254 = load i8*, i8** %data
	%tmp255 = getelementptr inbounds i8, i8* %tmp254, i32 %tmp253
	%tmp256 = load i8, i8* %tmp255
	%tmp257 = icmp eq i8 %tmp256, 47
	br i1 %tmp257, label %logic_rhs_70, label %logic_end_70
logic_rhs_70:
	%tmp258 = load i32, i32* %v13
	%tmp259 = add i32 %tmp258, 1
	%tmp260 = load i8*, i8** %data
	%tmp261 = getelementptr inbounds i8, i8* %tmp260, i32 %tmp259
	%tmp262 = load i8, i8* %tmp261
	%tmp263 = icmp eq i8 %tmp262, 42
	br label %logic_end_70
logic_end_70:
	%tmp264 = phi i1 [%tmp257, %then69], [%tmp263, %logic_rhs_70]
	br i1 %tmp264, label %then71, label %endif71
then71:
	%tmp265 = load i32, i32* %v14
	%tmp266 = add i32 %tmp265, 1
	store i32 %tmp266, i32* %v14
	%tmp267 = load i32, i32* %v13
	%tmp268 = add i32 %tmp267, 2
	store i32 %tmp268, i32* %v13
	br label %loop_body67
endif71:
	%tmp269 = load i32, i32* %v13
	%tmp270 = load i8*, i8** %data
	%tmp271 = getelementptr inbounds i8, i8* %tmp270, i32 %tmp269
	%tmp272 = load i8, i8* %tmp271
	%tmp273 = icmp eq i8 %tmp272, 42
	br i1 %tmp273, label %logic_rhs_72, label %logic_end_72
logic_rhs_72:
	%tmp274 = load i32, i32* %v13
	%tmp275 = add i32 %tmp274, 1
	%tmp276 = load i8*, i8** %data
	%tmp277 = getelementptr inbounds i8, i8* %tmp276, i32 %tmp275
	%tmp278 = load i8, i8* %tmp277
	%tmp279 = icmp eq i8 %tmp278, 47
	br label %logic_end_72
logic_end_72:
	%tmp280 = phi i1 [%tmp273, %endif71], [%tmp279, %logic_rhs_72]
	br i1 %tmp280, label %then73, label %endif73
then73:
	%tmp281 = load i32, i32* %v14
	%tmp282 = sub i32 %tmp281, 1
	store i32 %tmp282, i32* %v14
	%tmp283 = load i32, i32* %v13
	%tmp284 = add i32 %tmp283, 2
	store i32 %tmp284, i32* %v13
	%tmp285 = load i32, i32* %v14
	%tmp286 = icmp eq i32 %tmp285, 0
	br i1 %tmp286, label %then74, label %endif74
then74:
	br label %loop_body67_exit
endif74:
	br label %loop_body67
endif73:
	br label %endif69
endif69:
	%tmp287 = load i32, i32* %v13
	%tmp288 = add i32 %tmp287, 1
	store i32 %tmp288, i32* %v13
	br label %loop_body67
loop_body67:
	br label %loop_start67
loop_body67_exit:
	%tmp289 = load i32, i32* %v13
	%tmp290 = load i32, i32* %v0
	%tmp291 = sub i32 %tmp289, %tmp290
	store i32 %tmp291, i32* %v16
	%tmp292 = load i8*, i8** %data
	%tmp293 = load i32, i32* %v0
	%tmp294 = getelementptr inbounds i8, i8* %tmp292, i32 %tmp293
	%tmp295 = load i32, i32* %v16
	%tmp296 = sext i32 %tmp295 to i64
	call void @mem.fill(i8 0, i8* %tmp294, i64 %tmp296)
	%tmp297 = load i32, i32* %v13
	store i32 %tmp297, i32* %v0
	br label %loop_body0
endif66:
	store i8 72, i8* %v17
	%tmp298 = load i8, i8* %v1
	%tmp299 = icmp eq i8 %tmp298, 35
	br i1 %tmp299, label %then75, label %else75
then75:
	store i8 14, i8* %v17
	%tmp300 = load i32, i32* %v0
	%tmp301 = load i8*, i8** %data
	%tmp302 = getelementptr inbounds i8, i8* %tmp301, i32 %tmp300
	store i8 32, i8* %tmp302
	%tmp303 = load i32, i32* %v0
	%tmp304 = add i32 %tmp303, 1
	store i32 %tmp304, i32* %v0
	br label %endif75
else75:
	%tmp305 = load i8, i8* %v1
	%tmp306 = icmp eq i8 %tmp305, 40
	br i1 %tmp306, label %then76, label %else76
then76:
	store i8 0, i8* %v17
	%tmp307 = load i32, i32* %v0
	%tmp308 = load i8*, i8** %data
	%tmp309 = getelementptr inbounds i8, i8* %tmp308, i32 %tmp307
	store i8 32, i8* %tmp309
	%tmp310 = load i32, i32* %v0
	%tmp311 = add i32 %tmp310, 1
	store i32 %tmp311, i32* %v0
	br label %endif76
else76:
	%tmp312 = load i8, i8* %v1
	%tmp313 = icmp eq i8 %tmp312, 41
	br i1 %tmp313, label %then77, label %else77
then77:
	store i8 1, i8* %v17
	%tmp314 = load i32, i32* %v0
	%tmp315 = load i8*, i8** %data
	%tmp316 = getelementptr inbounds i8, i8* %tmp315, i32 %tmp314
	store i8 32, i8* %tmp316
	%tmp317 = load i32, i32* %v0
	%tmp318 = add i32 %tmp317, 1
	store i32 %tmp318, i32* %v0
	br label %endif77
else77:
	%tmp319 = load i8, i8* %v1
	%tmp320 = icmp eq i8 %tmp319, 123
	br i1 %tmp320, label %then78, label %else78
then78:
	store i8 2, i8* %v17
	%tmp321 = load i32, i32* %v0
	%tmp322 = load i8*, i8** %data
	%tmp323 = getelementptr inbounds i8, i8* %tmp322, i32 %tmp321
	store i8 32, i8* %tmp323
	%tmp324 = load i32, i32* %v0
	%tmp325 = add i32 %tmp324, 1
	store i32 %tmp325, i32* %v0
	br label %endif78
else78:
	%tmp326 = load i8, i8* %v1
	%tmp327 = icmp eq i8 %tmp326, 125
	br i1 %tmp327, label %then79, label %else79
then79:
	store i8 3, i8* %v17
	%tmp328 = load i32, i32* %v0
	%tmp329 = load i8*, i8** %data
	%tmp330 = getelementptr inbounds i8, i8* %tmp329, i32 %tmp328
	store i8 32, i8* %tmp330
	%tmp331 = load i32, i32* %v0
	%tmp332 = add i32 %tmp331, 1
	store i32 %tmp332, i32* %v0
	br label %endif79
else79:
	%tmp333 = load i8, i8* %v1
	%tmp334 = icmp eq i8 %tmp333, 91
	br i1 %tmp334, label %then80, label %else80
then80:
	store i8 4, i8* %v17
	%tmp335 = load i32, i32* %v0
	%tmp336 = load i8*, i8** %data
	%tmp337 = getelementptr inbounds i8, i8* %tmp336, i32 %tmp335
	store i8 32, i8* %tmp337
	%tmp338 = load i32, i32* %v0
	%tmp339 = add i32 %tmp338, 1
	store i32 %tmp339, i32* %v0
	br label %endif80
else80:
	%tmp340 = load i8, i8* %v1
	%tmp341 = icmp eq i8 %tmp340, 93
	br i1 %tmp341, label %then81, label %else81
then81:
	store i8 5, i8* %v17
	%tmp342 = load i32, i32* %v0
	%tmp343 = load i8*, i8** %data
	%tmp344 = getelementptr inbounds i8, i8* %tmp343, i32 %tmp342
	store i8 32, i8* %tmp344
	%tmp345 = load i32, i32* %v0
	%tmp346 = add i32 %tmp345, 1
	store i32 %tmp346, i32* %v0
	br label %endif81
else81:
	%tmp347 = load i8, i8* %v1
	%tmp348 = icmp eq i8 %tmp347, 58
	br i1 %tmp348, label %then82, label %else82
then82:
	%tmp349 = load i8, i8* %v2
	%tmp350 = icmp eq i8 %tmp349, 58
	br i1 %tmp350, label %then83, label %else83
then83:
	store i8 7, i8* %v17
	%tmp351 = load i32, i32* %v0
	%tmp352 = load i8*, i8** %data
	%tmp353 = getelementptr inbounds i8, i8* %tmp352, i32 %tmp351
	store i8 32, i8* %tmp353
	%tmp354 = load i32, i32* %v0
	%tmp355 = add i32 %tmp354, 1
	%tmp356 = load i8*, i8** %data
	%tmp357 = getelementptr inbounds i8, i8* %tmp356, i32 %tmp355
	store i8 32, i8* %tmp357
	%tmp358 = load i32, i32* %v0
	%tmp359 = add i32 %tmp358, 2
	store i32 %tmp359, i32* %v0
	br label %endif83
else83:
	store i8 6, i8* %v17
	%tmp360 = load i32, i32* %v0
	%tmp361 = load i8*, i8** %data
	%tmp362 = getelementptr inbounds i8, i8* %tmp361, i32 %tmp360
	store i8 32, i8* %tmp362
	%tmp363 = load i32, i32* %v0
	%tmp364 = add i32 %tmp363, 1
	store i32 %tmp364, i32* %v0
	br label %endif83
endif83:
	br label %endif82
else82:
	%tmp365 = load i8, i8* %v1
	%tmp366 = icmp eq i8 %tmp365, 61
	br i1 %tmp366, label %then84, label %else84
then84:
	%tmp367 = load i8, i8* %v2
	%tmp368 = icmp eq i8 %tmp367, 61
	br i1 %tmp368, label %then85, label %else85
then85:
	store i8 22, i8* %v17
	%tmp369 = load i32, i32* %v0
	%tmp370 = load i8*, i8** %data
	%tmp371 = getelementptr inbounds i8, i8* %tmp370, i32 %tmp369
	store i8 32, i8* %tmp371
	%tmp372 = load i32, i32* %v0
	%tmp373 = add i32 %tmp372, 1
	%tmp374 = load i8*, i8** %data
	%tmp375 = getelementptr inbounds i8, i8* %tmp374, i32 %tmp373
	store i8 32, i8* %tmp375
	%tmp376 = load i32, i32* %v0
	%tmp377 = add i32 %tmp376, 2
	store i32 %tmp377, i32* %v0
	br label %endif85
else85:
	store i8 15, i8* %v17
	%tmp378 = load i32, i32* %v0
	%tmp379 = load i8*, i8** %data
	%tmp380 = getelementptr inbounds i8, i8* %tmp379, i32 %tmp378
	store i8 32, i8* %tmp380
	%tmp381 = load i32, i32* %v0
	%tmp382 = add i32 %tmp381, 1
	store i32 %tmp382, i32* %v0
	br label %endif85
endif85:
	br label %endif84
else84:
	%tmp383 = load i8, i8* %v1
	%tmp384 = icmp eq i8 %tmp383, 59
	br i1 %tmp384, label %then86, label %else86
then86:
	store i8 8, i8* %v17
	%tmp385 = load i32, i32* %v0
	%tmp386 = load i8*, i8** %data
	%tmp387 = getelementptr inbounds i8, i8* %tmp386, i32 %tmp385
	store i8 32, i8* %tmp387
	%tmp388 = load i32, i32* %v0
	%tmp389 = add i32 %tmp388, 1
	store i32 %tmp389, i32* %v0
	br label %endif86
else86:
	%tmp390 = load i8, i8* %v1
	%tmp391 = icmp eq i8 %tmp390, 44
	br i1 %tmp391, label %then87, label %else87
then87:
	store i8 9, i8* %v17
	%tmp392 = load i32, i32* %v0
	%tmp393 = load i8*, i8** %data
	%tmp394 = getelementptr inbounds i8, i8* %tmp393, i32 %tmp392
	store i8 32, i8* %tmp394
	%tmp395 = load i32, i32* %v0
	%tmp396 = add i32 %tmp395, 1
	store i32 %tmp396, i32* %v0
	br label %endif87
else87:
	%tmp397 = load i8, i8* %v1
	%tmp398 = icmp eq i8 %tmp397, 43
	br i1 %tmp398, label %then88, label %else88
then88:
	store i8 16, i8* %v17
	%tmp399 = load i32, i32* %v0
	%tmp400 = load i8*, i8** %data
	%tmp401 = getelementptr inbounds i8, i8* %tmp400, i32 %tmp399
	store i8 32, i8* %tmp401
	%tmp402 = load i32, i32* %v0
	%tmp403 = add i32 %tmp402, 1
	store i32 %tmp403, i32* %v0
	br label %endif88
else88:
	%tmp404 = load i8, i8* %v1
	%tmp405 = icmp eq i8 %tmp404, 45
	br i1 %tmp405, label %then89, label %else89
then89:
	store i8 17, i8* %v17
	%tmp406 = load i32, i32* %v0
	%tmp407 = load i8*, i8** %data
	%tmp408 = getelementptr inbounds i8, i8* %tmp407, i32 %tmp406
	store i8 32, i8* %tmp408
	%tmp409 = load i32, i32* %v0
	%tmp410 = add i32 %tmp409, 1
	store i32 %tmp410, i32* %v0
	br label %endif89
else89:
	%tmp411 = load i8, i8* %v1
	%tmp412 = icmp eq i8 %tmp411, 42
	br i1 %tmp412, label %then90, label %else90
then90:
	store i8 18, i8* %v17
	%tmp413 = load i32, i32* %v0
	%tmp414 = load i8*, i8** %data
	%tmp415 = getelementptr inbounds i8, i8* %tmp414, i32 %tmp413
	store i8 32, i8* %tmp415
	%tmp416 = load i32, i32* %v0
	%tmp417 = add i32 %tmp416, 1
	store i32 %tmp417, i32* %v0
	br label %endif90
else90:
	%tmp418 = load i8, i8* %v1
	%tmp419 = icmp eq i8 %tmp418, 47
	br i1 %tmp419, label %then91, label %else91
then91:
	store i8 19, i8* %v17
	%tmp420 = load i32, i32* %v0
	%tmp421 = load i8*, i8** %data
	%tmp422 = getelementptr inbounds i8, i8* %tmp421, i32 %tmp420
	store i8 32, i8* %tmp422
	%tmp423 = load i32, i32* %v0
	%tmp424 = add i32 %tmp423, 1
	store i32 %tmp424, i32* %v0
	br label %endif91
else91:
	%tmp425 = load i8, i8* %v1
	%tmp426 = icmp eq i8 %tmp425, 37
	br i1 %tmp426, label %then92, label %else92
then92:
	store i8 20, i8* %v17
	%tmp427 = load i32, i32* %v0
	%tmp428 = load i8*, i8** %data
	%tmp429 = getelementptr inbounds i8, i8* %tmp428, i32 %tmp427
	store i8 32, i8* %tmp429
	%tmp430 = load i32, i32* %v0
	%tmp431 = add i32 %tmp430, 1
	store i32 %tmp431, i32* %v0
	br label %endif92
else92:
	%tmp432 = load i8, i8* %v1
	%tmp433 = icmp eq i8 %tmp432, 33
	br i1 %tmp433, label %then93, label %else93
then93:
	%tmp434 = load i8, i8* %v2
	%tmp435 = icmp eq i8 %tmp434, 61
	br i1 %tmp435, label %then94, label %else94
then94:
	store i8 23, i8* %v17
	%tmp436 = load i32, i32* %v0
	%tmp437 = load i8*, i8** %data
	%tmp438 = getelementptr inbounds i8, i8* %tmp437, i32 %tmp436
	store i8 32, i8* %tmp438
	%tmp439 = load i32, i32* %v0
	%tmp440 = add i32 %tmp439, 1
	%tmp441 = load i8*, i8** %data
	%tmp442 = getelementptr inbounds i8, i8* %tmp441, i32 %tmp440
	store i8 32, i8* %tmp442
	%tmp443 = load i32, i32* %v0
	%tmp444 = add i32 %tmp443, 2
	store i32 %tmp444, i32* %v0
	br label %endif94
else94:
	store i8 21, i8* %v17
	%tmp445 = load i32, i32* %v0
	%tmp446 = load i8*, i8** %data
	%tmp447 = getelementptr inbounds i8, i8* %tmp446, i32 %tmp445
	store i8 32, i8* %tmp447
	%tmp448 = load i32, i32* %v0
	%tmp449 = add i32 %tmp448, 1
	store i32 %tmp449, i32* %v0
	br label %endif94
endif94:
	br label %endif93
else93:
	%tmp450 = load i8, i8* %v1
	%tmp451 = icmp eq i8 %tmp450, 38
	br i1 %tmp451, label %then95, label %else95
then95:
	%tmp452 = load i8, i8* %v2
	%tmp453 = icmp eq i8 %tmp452, 38
	br i1 %tmp453, label %then96, label %else96
then96:
	store i8 25, i8* %v17
	%tmp454 = load i32, i32* %v0
	%tmp455 = load i8*, i8** %data
	%tmp456 = getelementptr inbounds i8, i8* %tmp455, i32 %tmp454
	store i8 32, i8* %tmp456
	%tmp457 = load i32, i32* %v0
	%tmp458 = add i32 %tmp457, 1
	%tmp459 = load i8*, i8** %data
	%tmp460 = getelementptr inbounds i8, i8* %tmp459, i32 %tmp458
	store i8 32, i8* %tmp460
	%tmp461 = load i32, i32* %v0
	%tmp462 = add i32 %tmp461, 2
	store i32 %tmp462, i32* %v0
	br label %endif96
else96:
	store i8 32, i8* %v17
	%tmp463 = load i32, i32* %v0
	%tmp464 = load i8*, i8** %data
	%tmp465 = getelementptr inbounds i8, i8* %tmp464, i32 %tmp463
	store i8 32, i8* %tmp465
	%tmp466 = load i32, i32* %v0
	%tmp467 = add i32 %tmp466, 1
	store i32 %tmp467, i32* %v0
	br label %endif96
endif96:
	br label %endif95
else95:
	%tmp468 = load i8, i8* %v1
	%tmp469 = icmp eq i8 %tmp468, 124
	br i1 %tmp469, label %then97, label %else97
then97:
	%tmp470 = load i8, i8* %v2
	%tmp471 = icmp eq i8 %tmp470, 124
	br i1 %tmp471, label %then98, label %else98
then98:
	store i8 24, i8* %v17
	%tmp472 = load i32, i32* %v0
	%tmp473 = load i8*, i8** %data
	%tmp474 = getelementptr inbounds i8, i8* %tmp473, i32 %tmp472
	store i8 32, i8* %tmp474
	%tmp475 = load i32, i32* %v0
	%tmp476 = add i32 %tmp475, 1
	%tmp477 = load i8*, i8** %data
	%tmp478 = getelementptr inbounds i8, i8* %tmp477, i32 %tmp476
	store i8 32, i8* %tmp478
	%tmp479 = load i32, i32* %v0
	%tmp480 = add i32 %tmp479, 2
	store i32 %tmp480, i32* %v0
	br label %endif98
else98:
	store i8 31, i8* %v17
	%tmp481 = load i32, i32* %v0
	%tmp482 = load i8*, i8** %data
	%tmp483 = getelementptr inbounds i8, i8* %tmp482, i32 %tmp481
	store i8 32, i8* %tmp483
	%tmp484 = load i32, i32* %v0
	%tmp485 = add i32 %tmp484, 1
	store i32 %tmp485, i32* %v0
	br label %endif98
endif98:
	br label %endif97
else97:
	%tmp486 = load i8, i8* %v1
	%tmp487 = icmp eq i8 %tmp486, 46
	br i1 %tmp487, label %then99, label %else99
then99:
	%tmp488 = load i8, i8* %v2
	%tmp489 = icmp eq i8 %tmp488, 46
	br i1 %tmp489, label %then100, label %else100
then100:
	%tmp490 = load i8, i8* %v3
	%tmp491 = icmp eq i8 %tmp490, 61
	br i1 %tmp491, label %then101, label %else101
then101:
	store i8 12, i8* %v17
	%tmp492 = load i32, i32* %v0
	%tmp493 = load i8*, i8** %data
	%tmp494 = getelementptr inbounds i8, i8* %tmp493, i32 %tmp492
	store i8 32, i8* %tmp494
	%tmp495 = load i32, i32* %v0
	%tmp496 = add i32 %tmp495, 1
	%tmp497 = load i8*, i8** %data
	%tmp498 = getelementptr inbounds i8, i8* %tmp497, i32 %tmp496
	store i8 32, i8* %tmp498
	%tmp499 = load i32, i32* %v0
	%tmp500 = add i32 %tmp499, 2
	%tmp501 = load i8*, i8** %data
	%tmp502 = getelementptr inbounds i8, i8* %tmp501, i32 %tmp500
	store i8 32, i8* %tmp502
	%tmp503 = load i32, i32* %v0
	%tmp504 = add i32 %tmp503, 3
	store i32 %tmp504, i32* %v0
	br label %endif101
else101:
	store i8 11, i8* %v17
	%tmp505 = load i32, i32* %v0
	%tmp506 = load i8*, i8** %data
	%tmp507 = getelementptr inbounds i8, i8* %tmp506, i32 %tmp505
	store i8 32, i8* %tmp507
	%tmp508 = load i32, i32* %v0
	%tmp509 = add i32 %tmp508, 1
	%tmp510 = load i8*, i8** %data
	%tmp511 = getelementptr inbounds i8, i8* %tmp510, i32 %tmp509
	store i8 32, i8* %tmp511
	%tmp512 = load i32, i32* %v0
	%tmp513 = add i32 %tmp512, 2
	store i32 %tmp513, i32* %v0
	br label %endif101
endif101:
	br label %endif100
else100:
	store i8 10, i8* %v17
	%tmp514 = load i32, i32* %v0
	%tmp515 = load i8*, i8** %data
	%tmp516 = getelementptr inbounds i8, i8* %tmp515, i32 %tmp514
	store i8 32, i8* %tmp516
	%tmp517 = load i32, i32* %v0
	%tmp518 = add i32 %tmp517, 1
	store i32 %tmp518, i32* %v0
	br label %endif100
endif100:
	br label %endif99
else99:
	%tmp519 = load i8, i8* %v1
	%tmp520 = icmp eq i8 %tmp519, 60
	br i1 %tmp520, label %then102, label %else102
then102:
	%tmp521 = load i8, i8* %v2
	%tmp522 = icmp eq i8 %tmp521, 60
	br i1 %tmp522, label %then103, label %else103
then103:
	store i8 34, i8* %v17
	%tmp523 = load i32, i32* %v0
	%tmp524 = load i8*, i8** %data
	%tmp525 = getelementptr inbounds i8, i8* %tmp524, i32 %tmp523
	store i8 32, i8* %tmp525
	%tmp526 = load i32, i32* %v0
	%tmp527 = add i32 %tmp526, 1
	%tmp528 = load i8*, i8** %data
	%tmp529 = getelementptr inbounds i8, i8* %tmp528, i32 %tmp527
	store i8 32, i8* %tmp529
	%tmp530 = load i32, i32* %v0
	%tmp531 = add i32 %tmp530, 2
	store i32 %tmp531, i32* %v0
	br label %endif103
else103:
	%tmp532 = load i8, i8* %v2
	%tmp533 = icmp eq i8 %tmp532, 61
	br i1 %tmp533, label %then104, label %else104
then104:
	store i8 29, i8* %v17
	%tmp534 = load i32, i32* %v0
	%tmp535 = load i8*, i8** %data
	%tmp536 = getelementptr inbounds i8, i8* %tmp535, i32 %tmp534
	store i8 32, i8* %tmp536
	%tmp537 = load i32, i32* %v0
	%tmp538 = add i32 %tmp537, 1
	%tmp539 = load i8*, i8** %data
	%tmp540 = getelementptr inbounds i8, i8* %tmp539, i32 %tmp538
	store i8 32, i8* %tmp540
	%tmp541 = load i32, i32* %v0
	%tmp542 = add i32 %tmp541, 2
	store i32 %tmp542, i32* %v0
	br label %endif104
else104:
	store i8 28, i8* %v17
	%tmp543 = load i32, i32* %v0
	%tmp544 = load i8*, i8** %data
	%tmp545 = getelementptr inbounds i8, i8* %tmp544, i32 %tmp543
	store i8 32, i8* %tmp545
	%tmp546 = load i32, i32* %v0
	%tmp547 = add i32 %tmp546, 1
	store i32 %tmp547, i32* %v0
	br label %endif104
endif104:
	br label %endif103
endif103:
	br label %endif102
else102:
	%tmp548 = load i8, i8* %v1
	%tmp549 = icmp eq i8 %tmp548, 62
	br i1 %tmp549, label %then105, label %else105
then105:
	%tmp550 = load i8, i8* %v2
	%tmp551 = icmp eq i8 %tmp550, 62
	br i1 %tmp551, label %then106, label %else106
then106:
	store i8 35, i8* %v17
	%tmp552 = load i32, i32* %v0
	%tmp553 = load i8*, i8** %data
	%tmp554 = getelementptr inbounds i8, i8* %tmp553, i32 %tmp552
	store i8 32, i8* %tmp554
	%tmp555 = load i32, i32* %v0
	%tmp556 = add i32 %tmp555, 1
	%tmp557 = load i8*, i8** %data
	%tmp558 = getelementptr inbounds i8, i8* %tmp557, i32 %tmp556
	store i8 32, i8* %tmp558
	%tmp559 = load i32, i32* %v0
	%tmp560 = add i32 %tmp559, 2
	store i32 %tmp560, i32* %v0
	br label %endif106
else106:
	%tmp561 = load i8, i8* %v2
	%tmp562 = icmp eq i8 %tmp561, 61
	br i1 %tmp562, label %then107, label %else107
then107:
	store i8 27, i8* %v17
	%tmp563 = load i32, i32* %v0
	%tmp564 = load i8*, i8** %data
	%tmp565 = getelementptr inbounds i8, i8* %tmp564, i32 %tmp563
	store i8 32, i8* %tmp565
	%tmp566 = load i32, i32* %v0
	%tmp567 = add i32 %tmp566, 1
	%tmp568 = load i8*, i8** %data
	%tmp569 = getelementptr inbounds i8, i8* %tmp568, i32 %tmp567
	store i8 32, i8* %tmp569
	%tmp570 = load i32, i32* %v0
	%tmp571 = add i32 %tmp570, 2
	store i32 %tmp571, i32* %v0
	br label %endif107
else107:
	store i8 26, i8* %v17
	%tmp572 = load i32, i32* %v0
	%tmp573 = load i8*, i8** %data
	%tmp574 = getelementptr inbounds i8, i8* %tmp573, i32 %tmp572
	store i8 32, i8* %tmp574
	%tmp575 = load i32, i32* %v0
	%tmp576 = add i32 %tmp575, 1
	store i32 %tmp576, i32* %v0
	br label %endif107
endif107:
	br label %endif106
endif106:
	br label %endif105
else105:
	%tmp577 = load i8, i8* %v1
	%tmp578 = icmp eq i8 %tmp577, 126
	br i1 %tmp578, label %then108, label %endif108
then108:
	store i8 30, i8* %v17
	%tmp579 = load i32, i32* %v0
	%tmp580 = load i8*, i8** %data
	%tmp581 = getelementptr inbounds i8, i8* %tmp580, i32 %tmp579
	store i8 32, i8* %tmp581
	%tmp582 = load i32, i32* %v0
	%tmp583 = add i32 %tmp582, 1
	store i32 %tmp583, i32* %v0
	br label %endif108
endif108:
	br label %endif105
endif105:
	br label %endif102
endif102:
	br label %endif99
endif99:
	br label %endif97
endif97:
	br label %endif95
endif95:
	br label %endif93
endif93:
	br label %endif92
endif92:
	br label %endif91
endif91:
	br label %endif90
endif90:
	br label %endif89
endif89:
	br label %endif88
endif88:
	br label %endif87
endif87:
	br label %endif86
endif86:
	br label %endif84
endif84:
	br label %endif82
endif82:
	br label %endif81
endif81:
	br label %endif80
endif80:
	br label %endif79
endif79:
	br label %endif78
endif78:
	br label %endif77
endif77:
	br label %endif76
endif76:
	br label %endif75
endif75:
	%tmp584 = load i8, i8* %v17
	%tmp585 = icmp ne i8 %tmp584, 72
	br i1 %tmp585, label %then109, label %endif109
then109:
	%tmp586 = load i8, i8* %v17
	%tmp587 = load i32, i32* %v0
	store i8 %tmp586, i8* %v18
	%tmp588 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v18, i32 0, i32 1
	store i16 0, i16* %tmp588
	%tmp589 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v18, i32 0, i32 2
	store i32 %tmp587, i32* %tmp589
	%tmp590 = load %struct.TokenData, %struct.TokenData* %v18
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %token_vector, %struct.TokenData %tmp590)
	br label %loop_body0
; Variable temp is out.
endif109:
	call void @console.write(i8* @.str.3, i32 8)
	%tmp591 = load i32, i32* %v0
	%tmp592 = zext i32 %tmp591 to i64
	call void @console.println_i64(i64 %tmp592)
	%tmp593 = load i32, i32* %v0
	%tmp594 = load i8*, i8** %data
	%tmp595 = getelementptr inbounds i8, i8* %tmp594, i32 %tmp593
	%tmp596 = load i8, i8* %tmp595
	%tmp597 = sext i8 %tmp596 to i64
	call void @console.println_i64(i64 %tmp597)
	call void @process.throw(i8* @.str.4)
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
define void @process.throw(i8* %exception)noreturn{
	%tmp0 = call i32 @string_utils.c_str_len(i8* %exception)
	call i32 @AllocConsole()
	%tmp1 = call i8* @GetStdHandle(i32 -11)
	call void @console.writeln(i8* @.str.5, i32 11)
	call void @console.writeln(i8* %exception, i32 %tmp0)
	call void @ExitProcess(i32 -1)
	unreachable
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
	%v14 = alloca i32
	%v15 = alloca %struct.TokenData
	%v16 = alloca %struct.TokenData
	%tmp0 = sub i32 %end, %start
	%tmp1 = getelementptr inbounds i8, i8* %data, i32 %start
	%tmp2 = icmp eq i32 %tmp0, 2
	br i1 %tmp2, label %then0, label %else0
then0:
	%tmp3 = call i32 @mem.compare(i8* %tmp1, i8* @.str.6, i64 2)
	%tmp4 = icmp eq i32 %tmp3, 0
	br i1 %tmp4, label %then1, label %endif1
then1:
	store i8 47, i8* %v0
	%tmp5 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v0, i32 0, i32 1
	store i16 0, i16* %tmp5
	%tmp6 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v0, i32 0, i32 2
	store i32 %start, i32* %tmp6
	%tmp7 = load %struct.TokenData, %struct.TokenData* %v0
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp7)
	br label %func_exit
; Variable temp is out.
endif1:
	%tmp8 = call i32 @mem.compare(i8* %tmp1, i8* @.str.7, i64 2)
	%tmp9 = icmp eq i32 %tmp8, 0
	br i1 %tmp9, label %then2, label %endif2
then2:
	store i8 55, i8* %v1
	%tmp10 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v1, i32 0, i32 1
	store i16 0, i16* %tmp10
	%tmp11 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v1, i32 0, i32 2
	store i32 %start, i32* %tmp11
	%tmp12 = load %struct.TokenData, %struct.TokenData* %v1
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp12)
	br label %func_exit
; Variable temp is out.
endif2:
	%tmp13 = call i32 @mem.compare(i8* %tmp1, i8* @.str.8, i64 2)
	%tmp14 = icmp eq i32 %tmp13, 0
	br i1 %tmp14, label %then3, label %endif3
then3:
	store i8 46, i8* %v2
	%tmp15 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v2, i32 0, i32 1
	store i16 0, i16* %tmp15
	%tmp16 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v2, i32 0, i32 2
	store i32 %start, i32* %tmp16
	%tmp17 = load %struct.TokenData, %struct.TokenData* %v2
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp17)
	br label %func_exit
; Variable temp is out.
endif3:
	%tmp18 = call i32 @mem.compare(i8* %tmp1, i8* @.str.9, i64 2)
	%tmp19 = icmp eq i32 %tmp18, 0
	br i1 %tmp19, label %then4, label %endif4
then4:
	store i8 56, i8* %v3
	%tmp20 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v3, i32 0, i32 1
	store i16 0, i16* %tmp20
	%tmp21 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v3, i32 0, i32 2
	store i32 %start, i32* %tmp21
	%tmp22 = load %struct.TokenData, %struct.TokenData* %v3
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp22)
	br label %func_exit
; Variable temp is out.
endif4:
	%tmp23 = call i32 @mem.compare(i8* %tmp1, i8* @.str.10, i64 2)
	%tmp24 = icmp eq i32 %tmp23, 0
	br i1 %tmp24, label %then5, label %endif5
then5:
	store i8 43, i8* %v4
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
	%tmp29 = call i32 @mem.compare(i8* %tmp1, i8* @.str.11, i64 3)
	%tmp30 = icmp eq i32 %tmp29, 0
	br i1 %tmp30, label %then7, label %endif7
then7:
	store i8 44, i8* %v5
	%tmp31 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v5, i32 0, i32 1
	store i16 0, i16* %tmp31
	%tmp32 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v5, i32 0, i32 2
	store i32 %start, i32* %tmp32
	%tmp33 = load %struct.TokenData, %struct.TokenData* %v5
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp33)
	br label %func_exit
; Variable temp is out.
endif7:
	%tmp34 = call i32 @mem.compare(i8* %tmp1, i8* @.str.12, i64 3)
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
	%tmp39 = call i32 @mem.compare(i8* %tmp1, i8* @.str.13, i64 3)
	%tmp40 = icmp eq i32 %tmp39, 0
	br i1 %tmp40, label %then9, label %endif9
then9:
	store i8 54, i8* %v7
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
	br i1 %tmp44, label %then10, label %endif10
then10:
	%tmp45 = call i32 @mem.compare(i8* %tmp1, i8* @.str.14, i64 4)
	%tmp46 = icmp eq i32 %tmp45, 0
	br i1 %tmp46, label %then11, label %endif11
then11:
	store i8 64, i8* %v8
	%tmp47 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v8, i32 0, i32 1
	store i16 0, i16* %tmp47
	%tmp48 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v8, i32 0, i32 2
	store i32 %start, i32* %tmp48
	%tmp49 = load %struct.TokenData, %struct.TokenData* %v8
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp49)
	br label %func_exit
; Variable temp is out.
endif11:
	%tmp50 = call i32 @mem.compare(i8* %tmp1, i8* @.str.15, i64 4)
	%tmp51 = icmp eq i32 %tmp50, 0
	br i1 %tmp51, label %then12, label %endif12
then12:
	store i8 53, i8* %v9
	%tmp52 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v9, i32 0, i32 1
	store i16 0, i16* %tmp52
	%tmp53 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v9, i32 0, i32 2
	store i32 %start, i32* %tmp53
	%tmp54 = load %struct.TokenData, %struct.TokenData* %v9
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp54)
	br label %func_exit
; Variable temp is out.
endif12:
	%tmp55 = call i32 @mem.compare(i8* %tmp1, i8* @.str.16, i64 4)
	%tmp56 = icmp eq i32 %tmp55, 0
	br i1 %tmp56, label %then13, label %endif13
then13:
	store i8 61, i8* %v10
	%tmp57 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v10, i32 0, i32 1
	store i16 0, i16* %tmp57
	%tmp58 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v10, i32 0, i32 2
	store i32 %start, i32* %tmp58
	%tmp59 = load %struct.TokenData, %struct.TokenData* %v10
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp59)
	br label %func_exit
; Variable temp is out.
endif13:
	%tmp60 = call i32 @mem.compare(i8* %tmp1, i8* @.str.17, i64 4)
	%tmp61 = icmp eq i32 %tmp60, 0
	br i1 %tmp61, label %then14, label %endif14
then14:
	store i8 66, i8* %v11
	%tmp62 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v11, i32 0, i32 1
	store i16 0, i16* %tmp62
	%tmp63 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v11, i32 0, i32 2
	store i32 %start, i32* %tmp63
	%tmp64 = load %struct.TokenData, %struct.TokenData* %v11
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp64)
	br label %func_exit
; Variable temp is out.
endif14:
	%tmp65 = call i32 @mem.compare(i8* %tmp1, i8* @.str.18, i64 4)
	%tmp66 = icmp eq i32 %tmp65, 0
	br i1 %tmp66, label %then15, label %endif15
then15:
	store i8 48, i8* %v12
	%tmp67 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v12, i32 0, i32 1
	store i16 0, i16* %tmp67
	%tmp68 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v12, i32 0, i32 2
	store i32 %start, i32* %tmp68
	%tmp69 = load %struct.TokenData, %struct.TokenData* %v12
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp69)
	br label %func_exit
; Variable temp is out.
endif15:
	%tmp70 = call i32 @mem.compare(i8* %tmp1, i8* @.str.19, i64 4)
	%tmp71 = icmp eq i32 %tmp70, 0
	br i1 %tmp71, label %then16, label %endif16
then16:
	store i8 66, i8* %v13
	%tmp72 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v13, i32 0, i32 1
	store i16 0, i16* %tmp72
	%tmp73 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v13, i32 0, i32 2
	store i32 %start, i32* %tmp73
	%tmp74 = load %struct.TokenData, %struct.TokenData* %v13
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp74)
	br label %func_exit
; Variable temp is out.
endif16:
	br label %endif10
endif10:
	br label %endif6
endif6:
	br label %endif0
endif0:
	%tmp75 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %symbols, i32 0, i32 1
	%tmp76 = load i32, i32* %tmp75
	store i32 0, i32* %v14
	br label %loop_cond17
loop_cond17:
	%tmp77 = load i32, i32* %v14
	%tmp78 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %symbols, i32 0, i32 1
	%tmp79 = load i32, i32* %tmp78
	%tmp80 = icmp uge i32 %tmp77, %tmp79
	br i1 %tmp80, label %then18, label %endif18
then18:
	br label %loop_body17_exit
endif18:
	%tmp81 = load i32, i32* %v14
	%tmp82 = load %struct.string.String*, %struct.string.String** %symbols
	%tmp83 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp82, i32 %tmp81
	%tmp84 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp83, i32 0, i32 1
	%tmp85 = load i32, i32* %tmp84
	%tmp86 = icmp ne i32 %tmp85, %tmp0
	br i1 %tmp86, label %then19, label %endif19
then19:
	br label %loop_body17
endif19:
	%tmp87 = load i32, i32* %v14
	%tmp88 = load %struct.string.String*, %struct.string.String** %symbols
	%tmp89 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp88, i32 %tmp87
	%tmp90 = load i8*, i8** %tmp89
	%tmp91 = sext i32 %tmp0 to i64
	%tmp92 = call i32 @mem.compare(i8* %tmp1, i8* %tmp90, i64 %tmp91)
	%tmp93 = icmp eq i32 %tmp92, 0
	br i1 %tmp93, label %then20, label %endif20
then20:
	%tmp94 = load i32, i32* %v14
	%tmp95 = trunc i32 %tmp94 to i16
	store i8 67, i8* %v15
	%tmp96 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v15, i32 0, i32 1
	store i16 %tmp95, i16* %tmp96
	%tmp97 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v15, i32 0, i32 2
	store i32 %start, i32* %tmp97
	%tmp98 = load %struct.TokenData, %struct.TokenData* %v15
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp98)
	br label %func_exit
; Variable temp is out.
endif20:
	br label %loop_body17
loop_body17:
	%tmp99 = load i32, i32* %v14
	%tmp100 = add i32 %tmp99, 1
	store i32 %tmp100, i32* %v14
	br label %loop_cond17
loop_body17_exit:
	%tmp101 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %symbols, i32 0, i32 1
	%tmp102 = load i32, i32* %tmp101
	%tmp103 = trunc i32 %tmp102 to i16
	%tmp104 = call %struct.string.String @string.from_data(i8* %tmp1, i32 %tmp0)
	call void @"vector.push<%struct.string.String>"(%"struct.vector.Vec<%struct.string.String>"* %symbols, %struct.string.String %tmp104)
	store i8 67, i8* %v16
	%tmp105 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v16, i32 0, i32 1
	store i16 %tmp103, i16* %tmp105
	%tmp106 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v16, i32 0, i32 2
	store i32 %start, i32* %tmp106
	%tmp107 = load %struct.TokenData, %struct.TokenData* %v16
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp107)
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
	%tmp34 = getelementptr inbounds i8, i8* %data, i32 %start
	%tmp35 = getelementptr inbounds i8, i8* %tmp34, i32 1
	%tmp36 = load i8, i8* %v3
	%tmp37 = sext i8 %tmp36 to i64
	call void @console.println_i64(i64 %tmp37)
	call void @console.writeln(i8* %tmp35, i32 %tmp1)
	call void @process.throw(i8* @.str.20)
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
	%tmp38 = load i32, i32* %v1
	%tmp39 = getelementptr inbounds i8, i8* %tmp4, i32 %tmp38
	%tmp40 = load i8, i8* %v4
	store i8 %tmp40, i8* %tmp39
	%tmp41 = load i32, i32* %v1
	%tmp42 = add i32 %tmp41, 1
	store i32 %tmp42, i32* %v1
	%tmp43 = load i32, i32* %v0
	%tmp44 = add i32 %tmp43, 2
	store i32 %tmp44, i32* %v0
	br label %loop_body0
endif2:
	%tmp45 = load i32, i32* %v1
	%tmp46 = getelementptr inbounds i8, i8* %tmp4, i32 %tmp45
	%tmp47 = load i8, i8* %v2
	store i8 %tmp47, i8* %tmp46
	%tmp48 = load i32, i32* %v1
	%tmp49 = add i32 %tmp48, 1
	store i32 %tmp49, i32* %v1
	%tmp50 = load i32, i32* %v0
	%tmp51 = add i32 %tmp50, 1
	store i32 %tmp51, i32* %v0
	br label %loop_body0
loop_body0:
	br label %loop_start0
loop_body0_exit:
	%tmp52 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %symbols, i32 0, i32 1
	%tmp53 = load i32, i32* %tmp52
	store i32 0, i32* %v5
	br label %loop_cond11
loop_cond11:
	%tmp54 = load i32, i32* %v5
	%tmp55 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %symbols, i32 0, i32 1
	%tmp56 = load i32, i32* %tmp55
	%tmp57 = icmp uge i32 %tmp54, %tmp56
	br i1 %tmp57, label %then12, label %endif12
then12:
	br label %loop_body11_exit
endif12:
	%tmp58 = load i32, i32* %v5
	%tmp59 = load %struct.string.String*, %struct.string.String** %symbols
	%tmp60 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp59, i32 %tmp58
	%tmp61 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp60, i32 0, i32 1
	%tmp62 = load i32, i32* %tmp61
	%tmp63 = icmp ne i32 %tmp62, %tmp1
	br i1 %tmp63, label %then13, label %endif13
then13:
	br label %loop_body11
endif13:
	%tmp64 = load i32, i32* %v5
	%tmp65 = load %struct.string.String*, %struct.string.String** %symbols
	%tmp66 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp65, i32 %tmp64
	%tmp67 = load i8*, i8** %tmp66
	%tmp68 = sext i32 %tmp1 to i64
	%tmp69 = call i32 @mem.compare(i8* %tmp3, i8* %tmp67, i64 %tmp68)
	%tmp70 = icmp eq i32 %tmp69, 0
	br i1 %tmp70, label %then14, label %endif14
then14:
	%tmp71 = load i32, i32* %v5
	%tmp72 = trunc i32 %tmp71 to i16
	store i8 70, i8* %v6
	%tmp73 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v6, i32 0, i32 1
	store i16 %tmp72, i16* %tmp73
	%tmp74 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v6, i32 0, i32 2
	store i32 %start, i32* %tmp74
	%tmp75 = load %struct.TokenData, %struct.TokenData* %v6
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp75)
	br label %func_exit
; Variable temp is out.
endif14:
	br label %loop_body11
loop_body11:
	%tmp76 = load i32, i32* %v5
	%tmp77 = add i32 %tmp76, 1
	store i32 %tmp77, i32* %v5
	br label %loop_cond11
loop_body11_exit:
	%tmp78 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %symbols, i32 0, i32 1
	%tmp79 = load i32, i32* %tmp78
	%tmp80 = trunc i32 %tmp79 to i16
	store i16 %tmp80, i16* %v7
	%tmp81 = load i32, i32* %v1
	%tmp82 = call %struct.string.String @string.from_data(i8* %tmp4, i32 %tmp81)
	call void @"vector.push<%struct.string.String>"(%"struct.vector.Vec<%struct.string.String>"* %symbols, %struct.string.String %tmp82)
	%tmp83 = load i16, i16* %v7
	store i8 70, i8* %v8
	%tmp84 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v8, i32 0, i32 1
	store i16 %tmp83, i16* %tmp84
	%tmp85 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v8, i32 0, i32 2
	store i32 %start, i32* %tmp85
	%tmp86 = load %struct.TokenData, %struct.TokenData* %v8
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp86)
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
	store i8 70, i8* %v1
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
	store i8 68, i8* %v3
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
	store i8 70, i8* %v1
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
	store i8 69, i8* %v3
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
	call void @console.writeln(i8* %tmp3, i32 %tmp1)
	call void @process.throw(i8* @.str.20)
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
	%tmp22 = load i16, i16* %v1
	store i8 71, i8* %v2
	%tmp23 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v2, i32 0, i32 1
	store i16 %tmp22, i16* %tmp23
	%tmp24 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v2, i32 0, i32 2
	store i32 %start, i32* %tmp24
	%tmp25 = load %struct.TokenData, %struct.TokenData* %v2
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp25)
	br label %func_exit
; Variable temp is out.
endif0:
	%tmp26 = icmp ne i32 %tmp1, 1
	br i1 %tmp26, label %then8, label %endif8
then8:
	call void @process.throw(i8* @.str.21)
	br label %endif8
endif8:
	%tmp27 = sext i8 %tmp4 to i16
	store i8 71, i8* %v3
	%tmp28 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v3, i32 0, i32 1
	store i16 %tmp27, i16* %tmp28
	%tmp29 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v3, i32 0, i32 2
	store i32 %start, i32* %tmp29
	%tmp30 = load %struct.TokenData, %struct.TokenData* %v3
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp30)
	br label %func_exit
func_exit:
; Variable temp is out.
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
define void @mem.zero_fill(i8* %dest, i64 %len){
	call void @mem.fill(i8 0, i8* %dest, i64 %len)
	ret void
}
define i8* @mem.malloc(i64 %size){
	%tmp0 = call i32* @GetProcessHeap()
	%tmp1 = call i8* @HeapAlloc(i32* %tmp0, i32 0, i64 %size)
	%tmp2 = icmp eq i8* %tmp1, null
	br i1 %tmp2, label %then0, label %endif0
then0:
	call void @process.throw(i8* @.str.22)
	br label %endif0
endif0:
	ret i8* %tmp1
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
define void @console.println_u64(i64 %n){
	%v0 = alloca i32
	%v1 = alloca i64
	%tmp0 = alloca i8, i64 22
	store i32 20, i32* %v0
	%tmp1 = icmp eq i64 %n, 0
	br i1 %tmp1, label %then0, label %endif0
then0:
	call void @console.write(i8* @.str.23, i32 2)
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
	call void @process.throw(i8* @.str.24)
	br label %endif0
endif0:
	%tmp4 = load i8*, i8** %v0
	ret i8* %tmp4
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
	call void @process.throw(i8* @.str.25)
	br label %endif1
endif1:
	br label %func_exit
func_exit:
	%tmp5 = phi i8* [%tmp1, %then0], [%tmp3, %endif1]
	ret i8* %tmp5
}

;func __chkstk ["no_lazy"]
;func _fltused ["no_lazy"]
;func handle_char []
;func handle_decimal_number []
;func handle_number []
;func handle_string []
;func handle_symbol []
;func lex []
;func main []
;func parse []
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
;func process.throw []
;func string.empty []
;func string.free ["ExtentionOf"]
;func string.from_data []
;func string.with_size []
;func string_utils.c_str_len []
;func string_utils.insert []
;func vector.new []
;func vector.push ["ExtentionOf"]
;type Argument
;type Expression
;type FnNode
;type HintNode
;type Stmt
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
