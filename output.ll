%struct.Argument = type { i16, %struct.Type }
%struct.ArrayExpr = type { %"struct.vector.Vec<%struct.Expression>" }
%struct.BinaryOpExpr = type { %struct.Expression, %struct.Expression, i32 }
%struct.BlockStmt = type { %"struct.vector.Vec<%struct.Stmt>" }
%struct.BoolExpr = type { i1 }
%struct.CallExpr = type { %struct.Expression, %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Type>" }
%struct.CastExpr = type { %struct.Expression, %struct.Type }
%struct.CharExpr = type { i16 }
%struct.ConstantSizeArrayType = type { %struct.Type, %struct.Expression }
%struct.DecimalExpr = type { i16 }
%struct.DeclarationNode = type { i16, i1, %struct.Expression, %struct.Type, i8 }
%struct.DoWhileStmt = type { %struct.Expression, %"struct.vector.Vec<%struct.Stmt>" }
%struct.EnumField = type { i16, i1, %struct.Expression }
%struct.EnumNode = type { i16, %struct.Type*, %"struct.vector.Vec<%struct.EnumField>" }
%struct.Expression = type { i32, i8* }
%struct.ExpressionNode = type { %struct.Expression }
%struct.FnNode = type { i16, %"struct.vector.Vec<%struct.Argument>", %struct.Type*, %"struct.vector.Vec<i16>", %"struct.vector.Vec<%struct.Stmt>" }
%struct.ForStmt = type { %struct.Expression, %struct.Expression, %"struct.vector.Vec<%struct.Stmt>" }
%struct.FunctionType = type { %"struct.vector.Vec<%struct.Type>", %struct.Type }
%struct.GenericType = type { i16, %"struct.vector.Vec<%struct.Type>" }
%struct.HintNode = type { i16, %"struct.vector.Vec<%struct.Expression>" }
%struct.IfStmt = type { %struct.Expression, %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>" }
%struct.IndexExpr = type { %struct.Expression, %struct.Expression }
%struct.IntegerExpr = type { i16 }
%struct.LoopStmt = type { %"struct.vector.Vec<%struct.Stmt>" }
%struct.MemberAccessExpr = type { %struct.Expression, i16 }
%struct.NameExpr = type { i16 }
%struct.NameWithGenericsExpr = type { %struct.Expression, %"struct.vector.Vec<%struct.Type>" }
%struct.NamedType = type { i16 }
%struct.NamespaceLinkType = type { %struct.Path, %struct.Type }
%struct.NamespaceNode = type { i16, %"struct.vector.Vec<%struct.Stmt>" }
%struct.Path = type { [8 x i16], i8 }
%struct.PointerType = type { i8, %struct.Type }
%struct.RangeExpr = type { %struct.Expression, %struct.Expression, i1 }
%struct.ReturnNode = type { i1, %struct.Expression }
%struct.StaticAccessExpr = type { %struct.Expression, i16 }
%struct.Stmt = type { i8, i8* }
%struct.StringConstExpr = type { i16 }
%struct.StructInitExpr = type { %struct.Type, %"struct.vector.Vec<%struct.StructInitFieldExpr>" }
%struct.StructInitFieldExpr = type { i16, %struct.Expression }
%struct.StructNode = type { i16, %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<i16>" }
%struct.TokenData = type { i8, i16, i32 }
%struct.Type = type { i32, i8* }
%struct.TypeExpr = type { %struct.Type }
%struct.UnaryOpExpr = type { %struct.Expression, i32 }
%struct.WhileStmt = type { %struct.Expression, %"struct.vector.Vec<%struct.Stmt>" }
%struct.mem.PROCESS_HEAP_ENTRY = type { i8*, i32, i8, i8, i16, i8*, i32, i32, i32 }
%struct.string.String = type { i8*, i32 }
%struct.window.BITMAP = type { i32, i32, i32, i32, i16, i16, i8* }
%struct.window.MSG = type { i8*, i32, i64, i64, i32, %struct.window.POINT }
%struct.window.PAINTSTRUCT = type { i8*, i32, %struct.window.RECT, i32, i32, [32 x i8] }
%struct.window.POINT = type { i32, i32 }
%struct.window.RECT = type { i32, i32, i32, i32 }
%struct.window.WNDCLASSEXA = type { i32, i32, i64 (i8*, i32, i64, i64)*, i32, i32, i8*, i8*, i8*, i8*, i8*, i8*, i8* }
%"struct.vector.Vec<%struct.Expression>" = type { %struct.Expression*, i32, i32 }
%"struct.vector.Vec<%struct.Stmt>" = type { %struct.Stmt*, i32, i32 }
%"struct.vector.Vec<%struct.Type>" = type { %struct.Type*, i32, i32 }
%"struct.vector.Vec<%struct.EnumField>" = type { %struct.EnumField*, i32, i32 }
%"struct.vector.Vec<%struct.Argument>" = type { %struct.Argument*, i32, i32 }
%"struct.vector.Vec<i16>" = type { i16*, i32, i32 }
%"struct.vector.Vec<%struct.StructInitFieldExpr>" = type { %struct.StructInitFieldExpr*, i32, i32 }
%"struct.vector.Vec<%struct.string.String>" = type { %struct.string.String*, i32, i32 }
%"struct.vector.Vec<%struct.TokenData>" = type { %struct.TokenData*, i32, i32 }
declare dllimport i32 @AllocConsole()
declare dllimport i8* @GetStdHandle(i32 %nStdHandle)
declare dllimport i32 @WriteConsoleA(i8* %hConsoleOutput, i8* %lpBuffer, i32 %nNumberOfCharsToWrite, i32* %lpNumberOfCharsWritten, i8* %lpReserved)
declare dllimport i32 @CloseHandle(i8* %hObject)
declare dllimport i8* @CreateFileA(i8* %lpFileName, i32 %dwDesiredAccess, i32 %dwShareMode, i8* %lpSecurityAttributes, i32 %dwCreationDisposition, i32 %dwFlagsAndAttributes, i8* %hTemplateFile)
declare dllimport i32 @GetFileSizeEx(i8* %hFile, i64* %lpFileSize)
declare dllimport i32 @GetFullPathNameA(i8* %lpFileName, i32 %nBufferLength, i8* %lpBuffer, i8* %lpFilePart)
declare dllimport i32 @ReadFile(i8* %hFile, i8* %lpBuffer, i32 %nNumberOfBytesToRead, i32* %lpNumberOfBytesRead, i8* %lpOverlapped)
declare dllimport i32 @WriteFile(i8* %hFile, i8* %lpBuffer, i32 %nNumberOfBytesToWrite, i32* %lpNumberOfBytesWritten, i8* %lpOverlapped)
declare dllimport i32* @GetProcessHeap()
declare dllimport i8* @HeapAlloc(i32* %hHeap, i32 %dwFlags, i64 %dwBytes)
declare dllimport i32 @HeapFree(i32* %hHeap, i32 %dwFlags, i8* %lpMem)
declare dllimport i8* @HeapReAlloc(i32* %hHeap, i32 %dwFlags, i8* %lpMem, i64 %dwBytes)
declare dllimport void @ExitProcess(i32 %code)


@.str.0 = private unnamed_addr constant [32 x i8] c"D:/Projects/rcsharp/src.rcsharp\00"
@.str.1 = private unnamed_addr constant [38 x i8] c"D:/Projects/rcsharp/output_v2.rcsharp\00"
@.str.2 = private unnamed_addr constant [11 x i8] c"Loading...\00"
@.str.3 = private unnamed_addr constant [16 x i8] c"Reading File...\00"
@.str.4 = private unnamed_addr alias [2 x i8], [2 x i8]* bitcast (i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.17, i64 0, i64 1) to [2 x i8]*)
@.str.5 = private unnamed_addr constant [8 x i8] c"include\00"
@.str.6 = private unnamed_addr constant [42 x i8] c"include directive must have only one path\00"
@.str.7 = private unnamed_addr alias [2 x i8], [2 x i8]* bitcast (i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.147, i64 0, i64 3) to [2 x i8]*)
@.str.8 = private unnamed_addr alias [3 x i8], [3 x i8]* bitcast (i8* getelementptr inbounds ([7 x i8], [7 x i8]* @.str.35, i64 0, i64 4) to [3 x i8]*)
@.str.9 = private unnamed_addr constant [23 x i8] c"Unrecognized directive\00"
@.str.10 = private unnamed_addr constant [10 x i8] c"Loaded...\00"
@.str.11 = private unnamed_addr constant [17 x i8] c"Project Files...\00"
@.str.12 = private unnamed_addr constant [14 x i8] c"Sym Vec Len: \00"
@.str.13 = private unnamed_addr constant [13 x i8] c"Compiling...\00"
@.str.14 = private unnamed_addr constant [12 x i8] c"Exception: \00"
@.str.15 = private unnamed_addr constant [17 x i8] c"File not found: \00"
@.str.16 = private unnamed_addr constant [17 x i8] c"File read failed\00"
@.str.17 = private unnamed_addr constant [3 x i8] c"0\0A\00"
@.str.18 = private unnamed_addr constant [34 x i8] c"Expected name after hint symbol #\00"
@.str.19 = private unnamed_addr constant [37 x i8] c"Expected ')' after arguments in hint\00"
@.str.20 = private unnamed_addr constant [42 x i8] c"Expected ']' after arguments in attribute\00"
@.str.21 = private unnamed_addr constant [34 x i8] c"Expected function name after 'fn'\00"
@.str.22 = private unnamed_addr constant [40 x i8] c"Expected '(' or '<' after function name\00"
@.str.23 = private unnamed_addr constant [38 x i8] c"Expected ')' after function arguments\00"
@.str.24 = private unnamed_addr constant [39 x i8] c"Expected ';' after expression function\00"
@.str.25 = private unnamed_addr constant [24 x i8] c"Expected namespace name\00"
@.str.26 = private unnamed_addr constant [40 x i8] c"Expected namespace body after namespace\00"
@.str.27 = private unnamed_addr constant [19 x i8] c"Expected enum name\00"
@.str.28 = private unnamed_addr constant [27 x i8] c"Expected '{' for enum body\00"
@.str.29 = private unnamed_addr constant [21 x i8] c"Expected struct name\00"
@.str.30 = private unnamed_addr constant [29 x i8] c"Expected '{' for struct body\00"
@.str.31 = private unnamed_addr constant [50 x i8] c"Expected this be a constant or static declaration\00"
@.str.32 = private unnamed_addr constant [24 x i8] c"Expected Colon and Type\00"
@.str.33 = private unnamed_addr constant [33 x i8] c"Expected SemiColon or expression\00"
@.str.34 = private unnamed_addr constant [19 x i8] c"Expected SemiColon\00"
@.str.35 = private unnamed_addr constant [7 x i8] c"@@@@\0A\0D\00"
@.str.36 = private unnamed_addr constant [21 x i8] c"--UNEXPECTED TOKEN--\00"
@.str.37 = private unnamed_addr constant [9 x i8] c"ACHTUNG:\00"
@.str.38 = private unnamed_addr constant [24 x i8] c"Character not expected!\00"
@.str.39 = private unnamed_addr constant [3 x i8] c", \00"
@.str.40 = private unnamed_addr constant [3 x i8] c"#[\00"
@.str.41 = private unnamed_addr constant [3 x i8] c"]\0A\00"
@.str.42 = private unnamed_addr constant [4 x i8] c"fn \00"
@.str.43 = private unnamed_addr alias [3 x i8], [3 x i8]* bitcast (i8* getelementptr inbounds ([14 x i8], [14 x i8]* @.str.12, i64 0, i64 11) to [3 x i8]*)
@.str.44 = private unnamed_addr constant [3 x i8] c"{\0A\00"
@.str.45 = private unnamed_addr constant [8 x i8] c"struct \00"
@.str.46 = private unnamed_addr constant [3 x i8] c"}\0A\00"
@.str.47 = private unnamed_addr constant [6 x i8] c"enum \00"
@.str.48 = private unnamed_addr constant [11 x i8] c"namespace \00"
@.str.49 = private unnamed_addr alias [7 x i8], [7 x i8]* bitcast (i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.189, i64 0, i64 1) to [7 x i8]*)
@.str.50 = private unnamed_addr alias [8 x i8], [8 x i8]* bitcast (i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.190, i64 0, i64 1) to [8 x i8]*)
@.str.51 = private unnamed_addr constant [32 x i8] c"let is not allowed in top scope\00"
@.str.52 = private unnamed_addr alias [4 x i8], [4 x i8]* bitcast (i8* getelementptr inbounds ([5 x i8], [5 x i8]* @.str.187, i64 0, i64 1) to [4 x i8]*)
@.str.53 = private unnamed_addr constant [4 x i8] c" = \00"
@.str.54 = private unnamed_addr constant [25 x i8] c"--UNEXPECTED STATEMENT--\00"
@.str.55 = private unnamed_addr constant [14 x i8] c"Out of memory\00"
@.str.56 = private unnamed_addr constant [26 x i8] c"stdout handle was invalid\00"
@.str.57 = private unnamed_addr constant [5 x i8] c"CHAR\00"
@.str.58 = private unnamed_addr constant [5 x i8] c"NAME\00"
@.str.59 = private unnamed_addr constant [7 x i8] c"STRING\00"
@.str.60 = private unnamed_addr constant [8 x i8] c"INTEGER\00"
@.str.61 = private unnamed_addr constant [8 x i8] c"DECIMAL\00"
@.str.62 = private unnamed_addr alias [2 x i8], [2 x i8]* bitcast (i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.186, i64 0, i64 2) to [2 x i8]*)
@.str.63 = private unnamed_addr alias [2 x i8], [2 x i8]* bitcast (i8* getelementptr inbounds ([52 x i8], [52 x i8]* @.str.202, i64 0, i64 50) to [2 x i8]*)
@.str.64 = private unnamed_addr constant [2 x i8] c"{\00"
@.str.65 = private unnamed_addr constant [2 x i8] c"}\00"
@.str.66 = private unnamed_addr alias [2 x i8], [2 x i8]* bitcast (i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.40, i64 0, i64 1) to [2 x i8]*)
@.str.67 = private unnamed_addr constant [2 x i8] c"]\00"
@.str.68 = private unnamed_addr alias [2 x i8], [2 x i8]* bitcast (i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.37, i64 0, i64 7) to [2 x i8]*)
@.str.69 = private unnamed_addr constant [3 x i8] c"::\00"
@.str.70 = private unnamed_addr constant [2 x i8] c";\00"
@.str.71 = private unnamed_addr constant [2 x i8] c",\00"
@.str.72 = private unnamed_addr alias [2 x i8], [2 x i8]* bitcast (i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.2, i64 0, i64 9) to [2 x i8]*)
@.str.73 = private unnamed_addr alias [3 x i8], [3 x i8]* bitcast (i8* getelementptr inbounds ([11 x i8], [11 x i8]* @.str.2, i64 0, i64 8) to [3 x i8]*)
@.str.74 = private unnamed_addr constant [4 x i8] c"..=\00"
@.str.75 = private unnamed_addr constant [3 x i8] c"=>\00"
@.str.76 = private unnamed_addr alias [2 x i8], [2 x i8]* bitcast (i8* getelementptr inbounds ([34 x i8], [34 x i8]* @.str.18, i64 0, i64 32) to [2 x i8]*)
@.str.77 = private unnamed_addr alias [2 x i8], [2 x i8]* bitcast (i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.74, i64 0, i64 2) to [2 x i8]*)
@.str.78 = private unnamed_addr constant [2 x i8] c"+\00"
@.str.79 = private unnamed_addr alias [2 x i8], [2 x i8]* bitcast (i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str.36, i64 0, i64 19) to [2 x i8]*)
@.str.80 = private unnamed_addr constant [2 x i8] c"*\00"
@.str.81 = private unnamed_addr constant [2 x i8] c"/\00"
@.str.82 = private unnamed_addr constant [2 x i8] c"%\00"
@.str.83 = private unnamed_addr alias [2 x i8], [2 x i8]* bitcast (i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str.38, i64 0, i64 22) to [2 x i8]*)
@.str.84 = private unnamed_addr constant [3 x i8] c"==\00"
@.str.85 = private unnamed_addr constant [3 x i8] c"!=\00"
@.str.86 = private unnamed_addr constant [3 x i8] c"||\00"
@.str.87 = private unnamed_addr constant [3 x i8] c"&&\00"
@.str.88 = private unnamed_addr alias [2 x i8], [2 x i8]* bitcast (i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.75, i64 0, i64 1) to [2 x i8]*)
@.str.89 = private unnamed_addr constant [3 x i8] c">=\00"
@.str.90 = private unnamed_addr constant [2 x i8] c"<\00"
@.str.91 = private unnamed_addr constant [3 x i8] c"<=\00"
@.str.92 = private unnamed_addr constant [2 x i8] c"~\00"
@.str.93 = private unnamed_addr alias [2 x i8], [2 x i8]* bitcast (i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.86, i64 0, i64 1) to [2 x i8]*)
@.str.94 = private unnamed_addr alias [2 x i8], [2 x i8]* bitcast (i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.87, i64 0, i64 1) to [2 x i8]*)
@.str.95 = private unnamed_addr constant [2 x i8] c"^\00"
@.str.96 = private unnamed_addr constant [4 x i8] c"PUB\00"
@.str.97 = private unnamed_addr constant [7 x i8] c"INLINE\00"
@.str.98 = private unnamed_addr constant [6 x i8] c"CONST\00"
@.str.99 = private unnamed_addr constant [7 x i8] c"EXTERN\00"
@.str.100 = private unnamed_addr constant [6 x i8] c"MATCH\00"
@.str.101 = private unnamed_addr constant [3 x i8] c"FN\00"
@.str.102 = private unnamed_addr constant [4 x i8] c"LET\00"
@.str.103 = private unnamed_addr constant [7 x i8] c"STATIC\00"
@.str.104 = private unnamed_addr constant [3 x i8] c"AS\00"
@.str.105 = private unnamed_addr constant [3 x i8] c"IF\00"
@.str.106 = private unnamed_addr constant [5 x i8] c"ELSE\00"
@.str.107 = private unnamed_addr constant [6 x i8] c"TRAIT\00"
@.str.108 = private unnamed_addr constant [5 x i8] c"IMPL\00"
@.str.109 = private unnamed_addr constant [7 x i8] c"STRUCT\00"
@.str.110 = private unnamed_addr constant [5 x i8] c"ENUM\00"
@.str.111 = private unnamed_addr constant [5 x i8] c"LOOP\00"
@.str.112 = private unnamed_addr constant [4 x i8] c"FOR\00"
@.str.113 = private unnamed_addr constant [3 x i8] c"DO\00"
@.str.114 = private unnamed_addr constant [3 x i8] c"IN\00"
@.str.115 = private unnamed_addr constant [6 x i8] c"WHILE\00"
@.str.116 = private unnamed_addr constant [6 x i8] c"BREAK\00"
@.str.117 = private unnamed_addr constant [9 x i8] c"CONTINUE\00"
@.str.118 = private unnamed_addr constant [7 x i8] c"RETURN\00"
@.str.119 = private unnamed_addr constant [5 x i8] c"THIS\00"
@.str.120 = private unnamed_addr constant [9 x i8] c"OPERATOR\00"
@.str.121 = private unnamed_addr constant [10 x i8] c"NAMESPACE\00"
@.str.122 = private unnamed_addr constant [5 x i8] c"TRUE\00"
@.str.123 = private unnamed_addr constant [6 x i8] c"FALSE\00"
@.str.124 = private unnamed_addr constant [5 x i8] c"NULL\00"
@.str.125 = private unnamed_addr constant [14 x i8] c"UNKNOWN_TOKEN\00"
@.str.126 = private unnamed_addr constant [20 x i8] c"Expected field name\00"
@.str.127 = private unnamed_addr constant [30 x i8] c"Expected ':' after field name\00"
@.str.128 = private unnamed_addr constant [39 x i8] c"Expected ',' or '}' after struct field\00"
@.str.129 = private unnamed_addr constant [31 x i8] c"Expected '}' after struct body\00"
@.str.130 = private unnamed_addr constant [36 x i8] c"Expected generic type name or comma\00"
@.str.131 = private unnamed_addr constant [38 x i8] c"Expected '>' after generic parameters\00"
@.str.132 = private unnamed_addr constant [27 x i8] c"Expected enum variant name\00"
@.str.133 = private unnamed_addr constant [39 x i8] c"Expected ',' or '}' after enum variant\00"
@.str.134 = private unnamed_addr constant [29 x i8] c"Expected '}' after enum body\00"
@.str.135 = private unnamed_addr constant [37 x i8] c"Expected ';' after return expression\00"
@.str.136 = private unnamed_addr constant [58 x i8] c"Expected variable name after variable declaration keyword\00"
@.str.137 = private unnamed_addr constant [58 x i8] c"Expected ':' after variable deflaration to indicate type.\00"
@.str.138 = private unnamed_addr constant [49 x i8] c"Expected ';' at the end of variable declaration.\00"
@.str.139 = private unnamed_addr constant [41 x i8] c"Expected '{' as the begining of if body.\00"
@.str.140 = private unnamed_addr constant [24 x i8] c"Expected '{' after else\00"
@.str.141 = private unnamed_addr constant [44 x i8] c"Expected '{' as the begining of while body.\00"
@.str.142 = private unnamed_addr constant [31 x i8] c"Expected while after do block.\00"
@.str.143 = private unnamed_addr constant [49 x i8] c"Expected semicolon after do {} while expression.\00"
@.str.144 = private unnamed_addr constant [45 x i8] c"Expected name of iterator after for keyword.\00"
@.str.145 = private unnamed_addr constant [41 x i8] c"Expected in after name in for structure.\00"
@.str.146 = private unnamed_addr constant [39 x i8] c"Expected ';' at the end of expression.\00"
@.str.147 = private unnamed_addr constant [5 x i8] c"---\09\00"
@.str.148 = private unnamed_addr constant [6 x i8] c"\09---\0A\00"
@.str.149 = private unnamed_addr constant [6 x i8] c"todo!\00"
@.str.150 = private unnamed_addr constant [23 x i8] c"Expected argument name\00"
@.str.151 = private unnamed_addr constant [33 x i8] c"Expected ':' after argument name\00"
@.str.152 = private unnamed_addr constant [35 x i8] c"Expected ',' or ')' after argument\00"
@.str.153 = private unnamed_addr constant [3 x i8] c"if\00"
@.str.154 = private unnamed_addr constant [3 x i8] c"do\00"
@.str.155 = private unnamed_addr constant [3 x i8] c"as\00"
@.str.156 = private unnamed_addr constant [3 x i8] c"in\00"
@.str.157 = private unnamed_addr constant [3 x i8] c"fn\00"
@.str.158 = private unnamed_addr constant [4 x i8] c"let\00"
@.str.159 = private unnamed_addr constant [4 x i8] c"pub\00"
@.str.160 = private unnamed_addr constant [4 x i8] c"for\00"
@.str.161 = private unnamed_addr constant [5 x i8] c"true\00"
@.str.162 = private unnamed_addr constant [5 x i8] c"loop\00"
@.str.163 = private unnamed_addr constant [5 x i8] c"this\00"
@.str.164 = private unnamed_addr constant [5 x i8] c"null\00"
@.str.165 = private unnamed_addr alias [5 x i8], [5 x i8]* bitcast (i8* getelementptr inbounds ([24 x i8], [24 x i8]* @.str.140, i64 0, i64 19) to [5 x i8]*)
@.str.166 = private unnamed_addr constant [5 x i8] c"enum\00"
@.str.167 = private unnamed_addr constant [5 x i8] c"impl\00"
@.str.168 = private unnamed_addr constant [6 x i8] c"const\00"
@.str.169 = private unnamed_addr constant [6 x i8] c"match\00"
@.str.170 = private unnamed_addr constant [6 x i8] c"trait\00"
@.str.171 = private unnamed_addr constant [6 x i8] c"while\00"
@.str.172 = private unnamed_addr constant [6 x i8] c"break\00"
@.str.173 = private unnamed_addr constant [6 x i8] c"false\00"
@.str.174 = private unnamed_addr constant [7 x i8] c"inline\00"
@.str.175 = private unnamed_addr constant [7 x i8] c"extern\00"
@.str.176 = private unnamed_addr constant [7 x i8] c"static\00"
@.str.177 = private unnamed_addr constant [7 x i8] c"struct\00"
@.str.178 = private unnamed_addr constant [7 x i8] c"return\00"
@.str.179 = private unnamed_addr constant [9 x i8] c"continue\00"
@.str.180 = private unnamed_addr alias [9 x i8], [9 x i8]* bitcast (i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str.221, i64 0, i64 14) to [9 x i8]*)
@.str.181 = private unnamed_addr alias [10 x i8], [10 x i8]* bitcast (i8* getelementptr inbounds ([40 x i8], [40 x i8]* @.str.26, i64 0, i64 30) to [10 x i8]*)
@.str.182 = private unnamed_addr constant [26 x i8] c"Invalid escape character!\00"
@.str.183 = private unnamed_addr constant [17 x i8] c"Char is too long\00"
@.str.184 = private unnamed_addr constant [5 x i8] c"-->\09\00"
@.str.185 = private unnamed_addr constant [6 x i8] c"\09<--\0A\00"
@.str.186 = private unnamed_addr constant [4 x i8] c"fn(\00"
@.str.187 = private unnamed_addr constant [5 x i8] c") : \00"
@.str.188 = private unnamed_addr constant [3 x i8] c"; \00"
@.str.189 = private unnamed_addr constant [8 x i8] c"\09const \00"
@.str.190 = private unnamed_addr constant [9 x i8] c"\09static \00"
@.str.191 = private unnamed_addr constant [6 x i8] c"\09let \00"
@.str.192 = private unnamed_addr constant [5 x i8] c">>>\09\00"
@.str.193 = private unnamed_addr constant [9 x i8] c"\09return \00"
@.str.194 = private unnamed_addr constant [44 x i8] c"Unexpected end of tokens while parsing type\00"
@.str.195 = private unnamed_addr constant [41 x i8] c"Expected '(' after 'fn' in function type\00"
@.str.196 = private unnamed_addr constant [50 x i8] c"Expected ')' to close function type argument list\00"
@.str.197 = private unnamed_addr constant [49 x i8] c"Expected ':' before return type in function type\00"
@.str.198 = private unnamed_addr constant [38 x i8] c"Expected ';' in fixed-size array type\00"
@.str.199 = private unnamed_addr constant [44 x i8] c"Expected ']' to close fixed-size array type\00"
@.str.200 = private unnamed_addr constant [56 x i8] c"Qualified type path exceeds maximum depth of 8 segments\00"
@.str.201 = private unnamed_addr constant [49 x i8] c"Expected identifier after '::' in qualified type\00"
@.str.202 = private unnamed_addr constant [52 x i8] c"Expected a type (unexpected token in type position)\00"
@.str.203 = private unnamed_addr constant [39 x i8] c"Unexpected end of tokens in expression\00"
@.str.204 = private unnamed_addr constant [44 x i8] c"Expected ')' after parenthesized expression\00"
@.str.205 = private unnamed_addr constant [37 x i8] c"Expected ',' or ']' in array literal\00"
@.str.206 = private unnamed_addr constant [33 x i8] c"Expected ']' after array literal\00"
@.str.207 = private unnamed_addr constant [51 x i8] c"Invalid expression syntax: Unexpected prefix token\00"
@.str.208 = private unnamed_addr constant [42 x i8] c"Expected ',' or ')' in function arguments\00"
@.str.209 = private unnamed_addr constant [31 x i8] c"Expected ']' after array index\00"
@.str.210 = private unnamed_addr constant [41 x i8] c"Expected ',' or '>' in generic arguments\00"
@.str.211 = private unnamed_addr constant [37 x i8] c"Expected '>' after generic arguments\00"
@.str.212 = private unnamed_addr constant [45 x i8] c"Expected field name in struct initialization\00"
@.str.213 = private unnamed_addr constant [45 x i8] c"Expected ',' or '}' in struct initialization\00"
@.str.214 = private unnamed_addr constant [41 x i8] c"Expected '}' after struct initialization\00"
@.str.215 = private unnamed_addr constant [32 x i8] c"Expected member name after '::'\00"
@.str.216 = private unnamed_addr constant [31 x i8] c"Expected member name after '.'\00"
@.str.217 = private unnamed_addr constant [37 x i8] c"Pointer depth exceeds maximum of 255\00"
@.str.218 = private unnamed_addr constant [13 x i8] c"Not expected\00"
@.str.219 = private unnamed_addr constant [55 x i8] c"Unexpected end of tokens inside generic type arguments\00"
@.str.220 = private unnamed_addr constant [51 x i8] c"Expected ',' or '>' between generic type arguments\00"
@.str.221 = private unnamed_addr constant [23 x i8] c"Invalid unary operator\00"
@.str.222 = private unnamed_addr constant [24 x i8] c"Invalid binary operator\00"
@.str.223 = private unnamed_addr constant [15 x i8] c"Realloc failed\00"
@stdlib.rand_seed = internal global i32 zeroinitializer

define void @mainCRTStartup(){
	call void @main()
	unreachable
}
define void @main(){
	call void @rcsharp_compile(i8* @.str.0, i8* @.str.1)
	ret void
}
define void @rcsharp_compile(i8* %input_file_path, i8* %output_file_path){
	%v0 = alloca i8*
	%v1 = alloca %struct.string.String
	%v2 = alloca %"struct.vector.Vec<%struct.string.String>"
	%v3 = alloca %"struct.vector.Vec<%struct.Stmt>"
	%v4 = alloca %"struct.vector.Vec<%struct.string.String>"
	%v5 = alloca i32
	%v6 = alloca %struct.string.String
	%v7 = alloca %"struct.vector.Vec<%struct.TokenData>"
	%v8 = alloca %"struct.vector.Vec<%struct.Stmt>"
	%v9 = alloca i32
	%v10 = alloca i1
	%v11 = alloca i32
	%v12 = alloca i32
	%v13 = alloca %struct.string.String
	%tmp0 = alloca i8, i64 255
	%tmp1 = call i32 @GetFullPathNameA(i8* %input_file_path, i32 255, i8* %tmp0, i8* %v0)
	%tmp2 = load i8*, i8** %v0
	%tmp3 = ptrtoint i8* %tmp2 to i64
	%tmp4 = ptrtoint i8* %tmp0 to i64
	%tmp5 = sub i64 %tmp3, %tmp4
	%tmp6 = trunc i64 %tmp5 to i32
	%tmp7 = sext i32 %tmp6 to i64
	call void @console.println_i64(i64 %tmp7)
	%tmp8 = call i32 @string_utils.c_str_len(i8* %input_file_path)
	%tmp9 = call i32 @string_utils.c_str_len(i8* %output_file_path)
	%tmp10 = call %struct.string.String @string.from_data(i8* %tmp0, i32 %tmp6)
	store %struct.string.String %tmp10, %struct.string.String* %v1
	call void @console.write_string(%struct.string.String* %v1)
	%tmp11 = call %"struct.vector.Vec<%struct.string.String>" @"vector.new<%struct.string.String>"()
	store %"struct.vector.Vec<%struct.string.String>" %tmp11, %"struct.vector.Vec<%struct.string.String>"* %v2
	%tmp12 = call %struct.string.String @string.from_c_string(i8* %input_file_path)
	call void @"vector.push<%struct.string.String>"(%"struct.vector.Vec<%struct.string.String>"* %v2, %struct.string.String %tmp12)
	call void @console.writeln(i8* @.str.2, i32 10)
	%tmp13 = call %"struct.vector.Vec<%struct.Stmt>" @"vector.new<%struct.Stmt>"()
	store %"struct.vector.Vec<%struct.Stmt>" %tmp13, %"struct.vector.Vec<%struct.Stmt>"* %v3
	%tmp14 = call %"struct.vector.Vec<%struct.string.String>" @"vector.new<%struct.string.String>"()
	store %"struct.vector.Vec<%struct.string.String>" %tmp14, %"struct.vector.Vec<%struct.string.String>"* %v4
	store i32 0, i32* %v5
	br label %loop_start0
loop_start0:
	%tmp15 = load i32, i32* %v5
	%tmp16 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %v2, i32 0, i32 1
	%tmp17 = load i32, i32* %tmp16
	%tmp18 = icmp ult i32 %tmp15, %tmp17
	br i1 %tmp18, label %endif1, label %else1
else1:
	br label %loop_body0_exit
endif1:
	call void @console.writeln(i8* @.str.3, i32 15)
	%tmp19 = load i32, i32* %v5
	%tmp20 = load %struct.string.String*, %struct.string.String** %v2
	%tmp21 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp20, i32 %tmp19
	call void @console.write_string(%struct.string.String* %tmp21)
	call void @console.write(i8* @.str.4, i32 1)
	%tmp22 = load i32, i32* %v5
	%tmp23 = load %struct.string.String*, %struct.string.String** %v2
	%tmp24 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp23, i32 %tmp22
	%tmp25 = load i8*, i8** %tmp24
	%tmp26 = call %struct.string.String @fs.read_full_file_as_string(i8* %tmp25)
	store %struct.string.String %tmp26, %struct.string.String* %v6
	%tmp27 = call %"struct.vector.Vec<%struct.TokenData>" @"vector.new<%struct.TokenData>"()
	store %"struct.vector.Vec<%struct.TokenData>" %tmp27, %"struct.vector.Vec<%struct.TokenData>"* %v7
	call void @lex(%struct.string.String* %v6, %"struct.vector.Vec<%struct.TokenData>"* %v7, %"struct.vector.Vec<%struct.string.String>"* %v4)
	call void @string.free(%struct.string.String* %v6)
	%tmp28 = call %"struct.vector.Vec<%struct.Stmt>" @"vector.new<%struct.Stmt>"()
	store %"struct.vector.Vec<%struct.Stmt>" %tmp28, %"struct.vector.Vec<%struct.Stmt>"* %v8
	%tmp29 = load %struct.TokenData*, %struct.TokenData** %v7
	%tmp30 = getelementptr inbounds %"struct.vector.Vec<%struct.TokenData>", %"struct.vector.Vec<%struct.TokenData>"* %v7, i32 0, i32 1
	%tmp31 = load i32, i32* %tmp30
	call void @parse(%struct.TokenData* %tmp29, i32 %tmp31, %"struct.vector.Vec<%struct.string.String>"* %v4, %"struct.vector.Vec<%struct.Stmt>"* %v8)
	%tmp32 = getelementptr inbounds %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %v8, i32 0, i32 1
	%tmp33 = load i32, i32* %tmp32
	store i32 0, i32* %v9
	br label %loop_cond2
loop_cond2:
	%tmp34 = load i32, i32* %v9
	%tmp35 = getelementptr inbounds %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %v8, i32 0, i32 1
	%tmp36 = load i32, i32* %tmp35
	%tmp37 = icmp uge i32 %tmp34, %tmp36
	br i1 %tmp37, label %then3, label %endif3
then3:
	br label %loop_body2_exit
endif3:
	%tmp38 = load i32, i32* %v9
	%tmp39 = load %struct.Stmt*, %struct.Stmt** %v8
	%tmp40 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp39, i32 %tmp38
	%tmp41 = load i8, i8* %tmp40
	%tmp42 = icmp eq i8 %tmp41, 0
	br i1 %tmp42, label %then4, label %endif4
then4:
	%tmp43 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp40, i32 0, i32 1
	%tmp44 = load i8*, i8** %tmp43
	%tmp45 = load %struct.string.String*, %struct.string.String** %v4
	%tmp46 = load i16, i16* %tmp44
	%tmp47 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp45, i16 %tmp46
	%tmp48 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp47, i32 0, i32 1
	%tmp49 = load i32, i32* %tmp48
	%tmp50 = icmp eq i32 %tmp49, 7
	br i1 %tmp50, label %logic_rhs_5, label %logic_end_5
logic_rhs_5:
	%tmp51 = load i16, i16* %tmp44
	%tmp52 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp45, i16 %tmp51
	%tmp53 = load i8*, i8** %tmp52
	%tmp54 = call i32 @mem.compare(i8* %tmp53, i8* @.str.5, i64 7)
	%tmp55 = icmp eq i32 %tmp54, 0
	br label %logic_end_5
logic_end_5:
	%tmp56 = phi i1 [%tmp50, %then4], [%tmp55, %logic_rhs_5]
	br i1 %tmp56, label %then6, label %else6
then6:
	%tmp57 = getelementptr inbounds %struct.HintNode, %struct.HintNode* %tmp44, i32 0, i32 1
	%tmp58 = getelementptr inbounds %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Expression>"* %tmp57, i32 0, i32 1
	%tmp59 = load i32, i32* %tmp58
	%tmp60 = icmp ne i32 %tmp59, 1
	br i1 %tmp60, label %then7, label %endif7
then7:
	call void @process.throw(i8* @.str.6)
	br label %endif7
endif7:
	%tmp62 = getelementptr inbounds %struct.HintNode, %struct.HintNode* %tmp44, i32 0, i32 1
	%tmp63 = load %struct.Expression*, %struct.Expression** %tmp62
	%tmp64 = load i32, i32* %tmp63
	%tmp65 = icmp ne i32 %tmp64, 4
	br i1 %tmp65, label %then8, label %endif8
then8:
	call void @process.throw(i8* @.str.6)
	br label %endif8
endif8:
	%tmp66 = getelementptr inbounds %struct.Expression, %struct.Expression* %tmp63, i32 0, i32 1
	%tmp67 = load i8*, i8** %tmp66
	call void @console.write(i8* @.str.7, i32 1)
	%tmp68 = load i16, i16* %tmp67
	%tmp69 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp45, i16 %tmp68
	call void @console.write_string(%struct.string.String* %tmp69)
	call void @console.write(i8* @.str.8, i32 2)
	store i1 false, i1* %v10
	%tmp70 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %v2, i32 0, i32 1
	%tmp71 = load i32, i32* %tmp70
	store i32 0, i32* %v11
	br label %loop_cond9
loop_cond9:
	%tmp72 = load i32, i32* %v11
	%tmp73 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %v2, i32 0, i32 1
	%tmp74 = load i32, i32* %tmp73
	%tmp75 = icmp uge i32 %tmp72, %tmp74
	br i1 %tmp75, label %then10, label %endif10
then10:
	br label %loop_body9_exit
endif10:
	%tmp76 = load i16, i16* %tmp67
	%tmp77 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp45, i16 %tmp76
	%tmp78 = load i32, i32* %v11
	%tmp79 = load %struct.string.String*, %struct.string.String** %v2
	%tmp80 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp79, i32 %tmp78
	%tmp81 = call i1 @string.equal(%struct.string.String* %tmp77, %struct.string.String* %tmp80)
	br i1 %tmp81, label %then11, label %endif11
then11:
	store i1 true, i1* %v10
	br label %loop_body9_exit
endif11:
	%tmp82 = load i32, i32* %v11
	%tmp83 = add i32 %tmp82, 1
	store i32 %tmp83, i32* %v11
	br label %loop_cond9
loop_body9_exit:
	%tmp84 = load i1, i1* %v10
	%tmp85 = xor i1 1, %tmp84
	br i1 %tmp85, label %then12, label %endif12
then12:
	%tmp86 = load i16, i16* %tmp67
	%tmp87 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp45, i16 %tmp86
	%tmp88 = call %struct.string.String @string.clone(%struct.string.String* %tmp87)
	call void @"vector.push<%struct.string.String>"(%"struct.vector.Vec<%struct.string.String>"* %v2, %struct.string.String %tmp88)
	br label %endif12
endif12:
	br label %loop_body2
else6:
	call void @process.throw(i8* @.str.9)
	br label %endif4
endif4:
	%tmp89 = load %struct.Stmt, %struct.Stmt* %tmp40
	call void @"vector.push<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %v3, %struct.Stmt %tmp89)
	br label %loop_body2
loop_body2:
	%tmp90 = load i32, i32* %v9
	%tmp91 = add i32 %tmp90, 1
	store i32 %tmp91, i32* %v9
	br label %loop_cond2
loop_body2_exit:
	call void @"vector.free<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %v8)
	%tmp92 = load i32, i32* %v5
	%tmp93 = add i32 %tmp92, 1
	store i32 %tmp93, i32* %v5
	br label %loop_start0
loop_body0_exit:
; Variable statement_vector is out.
; Variable token_vector is out.
; Variable file_data is out.
	call void @console.writeln(i8* @.str.10, i32 9)
	call void @console.writeln(i8* @.str.11, i32 16)
	call void @console.write(i8* @.str.12, i32 13)
	%tmp94 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %v4, i32 0, i32 1
	%tmp95 = load i32, i32* %tmp94
	%tmp96 = zext i32 %tmp95 to i64
	call void @console.println_u64(i64 %tmp96)
	%tmp97 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %v2, i32 0, i32 1
	%tmp98 = load i32, i32* %tmp97
	store i32 0, i32* %v12
	br label %loop_cond13
loop_cond13:
	%tmp99 = load i32, i32* %v12
	%tmp100 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %v2, i32 0, i32 1
	%tmp101 = load i32, i32* %tmp100
	%tmp102 = icmp uge i32 %tmp99, %tmp101
	br i1 %tmp102, label %then14, label %endif14
then14:
	br label %loop_body13_exit
endif14:
	call void @console.write(i8* @.str.7, i32 1)
	%tmp103 = load i32, i32* %v12
	%tmp104 = load %struct.string.String*, %struct.string.String** %v2
	%tmp105 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp104, i32 %tmp103
	call void @console.write_string(%struct.string.String* %tmp105)
	call void @console.write(i8* @.str.4, i32 1)
	%tmp106 = load i32, i32* %v12
	%tmp107 = add i32 %tmp106, 1
	store i32 %tmp107, i32* %v12
	br label %loop_cond13
loop_body13_exit:
	%tmp108 = getelementptr inbounds %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %v3, i32 0, i32 1
	%tmp109 = load i32, i32* %tmp108
	%tmp110 = zext i32 %tmp109 to i64
	call void @console.println_i64(i64 %tmp110)
	call void @console.writeln(i8* @.str.13, i32 12)
	%tmp111 = call %struct.string.String @string.empty()
	store %struct.string.String %tmp111, %struct.string.String* %v13
	call void @compile(%"struct.vector.Vec<%struct.Stmt>"* %v3, %"struct.vector.Vec<%struct.string.String>"* %v4, %struct.string.String* %v13)
	%tmp112 = load i8*, i8** %v13
	%tmp113 = getelementptr inbounds %struct.string.String, %struct.string.String* %v13, i32 0, i32 1
	%tmp114 = load i32, i32* %tmp113
	call i32 @fs.write_to_file(i8* %output_file_path, i8* %tmp112, i32 %tmp114)
	call void @ExitProcess(i32 0)
; Variable stdout is out.
; Variable symbol_vector is out.
; Variable main_statement_vector is out.
; Variable file_stack is out.
; Variable base_env is out.
	ret void
}
define i32 @_fltused(){
	ret i32 0
}
define void @__chkstk(){
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
define void @string.free(%struct.string.String* %str){
	%tmp0 = load i8*, i8** %str
	call void @mem.free(i8* %tmp0)
	%tmp1 = getelementptr inbounds %struct.string.String, %struct.string.String* %str, i32 0, i32 1
	store i32 0, i32* %tmp1
	ret void
}
define i1 @string.equal(%struct.string.String* %first, %struct.string.String* %second){
	%tmp0 = getelementptr inbounds %struct.string.String, %struct.string.String* %first, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = getelementptr inbounds %struct.string.String, %struct.string.String* %second, i32 0, i32 1
	%tmp3 = load i32, i32* %tmp2
	%tmp4 = icmp ne i32 %tmp1, %tmp3
	br i1 %tmp4, label %then0, label %endif0
then0:
	br label %func_exit
endif0:
	%tmp5 = load i8*, i8** %first
	%tmp6 = load i8*, i8** %second
	%tmp7 = getelementptr inbounds %struct.string.String, %struct.string.String* %first, i32 0, i32 1
	%tmp8 = load i32, i32* %tmp7
	%tmp9 = sext i32 %tmp8 to i64
	%tmp10 = call i32 @mem.compare(i8* %tmp5, i8* %tmp6, i64 %tmp9)
	%tmp11 = icmp eq i32 %tmp10, 0
	br label %func_exit
func_exit:
	%tmp12 = phi i1 [false, %then0], [%tmp11, %endif0]
	ret i1 %tmp12
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
define void @process.throw(i8* %exception){
	%tmp0 = call i32 @string_utils.c_str_len(i8* %exception)
	call i32 @AllocConsole()
	%tmp1 = call i8* @GetStdHandle(i32 -11)
	call void @console.writeln(i8* @.str.14, i32 11)
	call void @console.writeln(i8* %exception, i32 %tmp0)
	call void @ExitProcess(i32 -1)
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
define i32 @fs.write_to_file(i8* %path, i8* %content, i32 %content_len){
	%v0 = alloca i32
	%tmp0 = call i8* @CreateFileA(i8* %path, i32 1073741824, i32 0, i8* null, i32 2, i32 128, i8* null)
	%tmp1 = inttoptr i64 -1 to i8*
	%tmp2 = icmp eq i8* %tmp0, %tmp1
	br i1 %tmp2, label %then0, label %endif0
then0:
	br label %func_exit
endif0:
	store i32 0, i32* %v0
	%tmp3 = call i32 @WriteFile(i8* %tmp0, i8* %content, i32 %content_len, i32* %v0, i8* null)
	call i32 @CloseHandle(i8* %tmp0)
	%tmp4 = icmp ne i32 %tmp3, 0
	br i1 %tmp4, label %logic_rhs_1, label %logic_end_1
logic_rhs_1:
	%tmp5 = load i32, i32* %v0
	%tmp6 = icmp eq i32 %tmp5, %content_len
	br label %logic_end_1
logic_end_1:
	%tmp7 = phi i1 [%tmp4, %endif0], [%tmp6, %logic_rhs_1]
	%tmp8 = zext i1 %tmp7 to i32
	br label %func_exit
func_exit:
	%tmp9 = phi i32 [0, %then0], [%tmp8, %logic_end_1]
	ret i32 %tmp9
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
	%tmp3 = call i8* @string_utils.insert(i8* @.str.15, i8* %path, i32 16)
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
	call void @process.throw(i8* @.str.16)
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
define void @console.writeln(i8* %buffer, i32 %len){
	%v0 = alloca i32
	%v1 = alloca i8
	call void @console.write(i8* %buffer, i32 %len)
	store i8 10, i8* %v1
	%tmp0 = call i8* @console.get_stdout()
	call i32 @WriteConsoleA(i8* %tmp0, i8* %v1, i32 1, i32* %v0, i8* null)
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
define void @console.println_u64(i64 %n){
	%v0 = alloca i32
	%v1 = alloca i64
	%tmp0 = alloca i8, i64 22
	store i32 20, i32* %v0
	%tmp1 = icmp eq i64 %n, 0
	br i1 %tmp1, label %then0, label %endif0
then0:
	call void @console.write(i8* @.str.17, i32 2)
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
	%v4 = alloca i8
	%v5 = alloca %struct.Stmt
	%v6 = alloca %"struct.vector.Vec<%struct.Argument>"
	%v7 = alloca %struct.Type*
	%v8 = alloca %"struct.vector.Vec<%struct.Stmt>"
	%v9 = alloca %struct.Stmt
	%v10 = alloca %struct.Stmt
	%v11 = alloca %"struct.vector.Vec<%struct.Stmt>"
	%v12 = alloca %struct.Stmt
	%v13 = alloca %struct.Type*
	%v14 = alloca %"struct.vector.Vec<%struct.EnumField>"
	%v15 = alloca %struct.Stmt
	%v16 = alloca %"struct.vector.Vec<i16>"
	%v17 = alloca %"struct.vector.Vec<%struct.Argument>"
	%v18 = alloca %struct.Stmt
	%v19 = alloca %"struct.vector.Vec<%struct.Stmt>"
	%v20 = alloca i32
	%v21 = alloca %struct.Type*
	%v22 = alloca i32
	%v23 = alloca %struct.string.String
	%tmp0 = icmp eq i32 %token_len, 0
	br i1 %tmp0, label %then0, label %endif0
then0:
	br label %func_exit
endif0:
	store i32 0, i32* %v0
	store i32 4294967295, i32* %v1
	br label %loop_start1
loop_start1:
	%tmp1 = load i32, i32* %v0
	%tmp2 = icmp ult i32 %tmp1, %token_len
	br i1 %tmp2, label %endif2, label %else2
else2:
	br label %loop_body1_exit
endif2:
	%tmp3 = load i32, i32* %v0
	%tmp4 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp3
	%tmp5 = load i8, i8* %tmp4
	%tmp6 = call i1 @is_modifier(i8 %tmp5)
	br i1 %tmp6, label %then3, label %endif3
then3:
	%tmp7 = load i32, i32* %v1
	%tmp8 = icmp eq i32 %tmp7, 4294967295
	br i1 %tmp8, label %then4, label %endif4
then4:
	%tmp9 = load i32, i32* %v0
	store i32 %tmp9, i32* %v1
	br label %endif4
endif4:
	%tmp10 = load i32, i32* %v0
	%tmp11 = add i32 %tmp10, 1
	store i32 %tmp11, i32* %v0
	br label %loop_body1
endif3:
	%tmp12 = icmp eq i8 %tmp5, 14
	br i1 %tmp12, label %then5, label %endif5
then5:
	store i32 4294967295, i32* %v1
	%tmp13 = load i32, i32* %v0
	%tmp14 = add i32 %tmp13, 1
	store i32 %tmp14, i32* %v0
	store i1 false, i1* %v2
	%tmp15 = load i32, i32* %v0
	%tmp16 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp15
	%tmp17 = load i8, i8* %tmp16
	%tmp18 = icmp eq i8 %tmp17, 4
	br i1 %tmp18, label %then6, label %endif6
then6:
	store i1 true, i1* %v2
	%tmp19 = load i32, i32* %v0
	%tmp20 = add i32 %tmp19, 1
	store i32 %tmp20, i32* %v0
	br label %endif6
endif6:
	%tmp21 = load i32, i32* %v0
	%tmp22 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp21
	%tmp23 = load i8, i8* %tmp22
	%tmp24 = icmp ne i8 %tmp23, 65
	br i1 %tmp24, label %then7, label %endif7
then7:
	call void @process.throw(i8* @.str.18)
	br label %endif7
endif7:
	%tmp25 = load i32, i32* %v0
	%tmp26 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp25
	%tmp27 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp26, i32 0, i32 1
	%tmp28 = load i16, i16* %tmp27
	%tmp29 = load i32, i32* %v0
	%tmp30 = add i32 %tmp29, 1
	store i32 %tmp30, i32* %v0
	%tmp31 = call %"struct.vector.Vec<%struct.Expression>" @"vector.new<%struct.Expression>"()
	store %"struct.vector.Vec<%struct.Expression>" %tmp31, %"struct.vector.Vec<%struct.Expression>"* %v3
	%tmp32 = load i32, i32* %v0
	%tmp33 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp32
	%tmp34 = load i8, i8* %tmp33
	%tmp35 = icmp eq i8 %tmp34, 0
	br i1 %tmp35, label %then8, label %endif8
then8:
	%tmp36 = load i32, i32* %v0
	%tmp37 = add i32 %tmp36, 1
	store i32 %tmp37, i32* %v0
	%tmp38 = call %"struct.vector.Vec<%struct.Expression>" @parse_expression_comma(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	store %"struct.vector.Vec<%struct.Expression>" %tmp38, %"struct.vector.Vec<%struct.Expression>"* %v3
	call void @expect(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 1, i8* @.str.19)
	br label %endif8
endif8:
	store i8 0, i8* %v4
	%tmp39 = load i1, i1* %v2
	br i1 %tmp39, label %then9, label %endif9
then9:
	call void @expect(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 5, i8* @.str.20)
	store i8 20, i8* %v4
	br label %endif9
endif9:
	%tmp40 = call i8* @mem.malloc(i64 24)
	store i16 %tmp28, i16* %tmp40
	%tmp41 = getelementptr inbounds %struct.HintNode, %struct.HintNode* %tmp40, i32 0, i32 1
	%tmp42 = load %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Expression>"* %v3
	store %"struct.vector.Vec<%struct.Expression>" %tmp42, %"struct.vector.Vec<%struct.Expression>"* %tmp41
	%tmp43 = load i8, i8* %v4
	store i8 %tmp43, i8* %v5
	%tmp44 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %v5, i32 0, i32 1
	store i8* %tmp40, i8** %tmp44
	%tmp45 = load %struct.Stmt, %struct.Stmt* %v5
	call void @"vector.push<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %statement_vector, %struct.Stmt %tmp45)
	br label %loop_body1
; Variable stmt is out.
; Variable exprs is out.
endif5:
	%tmp46 = icmp eq i8 %tmp5, 41
	br i1 %tmp46, label %then10, label %endif10
then10:
	store i32 4294967295, i32* %v1
	%tmp47 = load i32, i32* %v0
	%tmp48 = add i32 %tmp47, 1
	store i32 %tmp48, i32* %v0
	%tmp49 = load i32, i32* %v0
	%tmp50 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp49
	%tmp51 = load i8, i8* %tmp50
	%tmp52 = icmp ne i8 %tmp51, 65
	br i1 %tmp52, label %then11, label %endif11
then11:
	call void @process.throw(i8* @.str.21)
	br label %endif11
endif11:
	%tmp53 = load i32, i32* %v0
	%tmp54 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp53
	%tmp55 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp54, i32 0, i32 1
	%tmp56 = load i16, i16* %tmp55
	%tmp57 = load i32, i32* %v0
	%tmp58 = add i32 %tmp57, 1
	store i32 %tmp58, i32* %v0
	%tmp59 = load i32, i32* %v0
	%tmp60 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp59
	%tmp61 = load i8, i8* %tmp60
	%tmp62 = icmp ne i8 %tmp61, 0
	br i1 %tmp62, label %logic_rhs_12, label %logic_end_12
logic_rhs_12:
	%tmp63 = load i32, i32* %v0
	%tmp64 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp63
	%tmp65 = load i8, i8* %tmp64
	%tmp66 = icmp ne i8 %tmp65, 28
	br label %logic_end_12
logic_end_12:
	%tmp67 = phi i1 [%tmp62, %endif11], [%tmp66, %logic_rhs_12]
	br i1 %tmp67, label %then13, label %endif13
then13:
	call void @process.throw(i8* @.str.22)
	br label %endif13
endif13:
	%tmp68 = load i32, i32* %v0
	%tmp69 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp68
	%tmp70 = load i8, i8* %tmp69
	%tmp71 = icmp eq i8 %tmp70, 28
	br i1 %tmp71, label %then14, label %endif14
then14:
	call void @skip_nested(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 28, i8 26)
	br label %endif14
endif14:
	%tmp72 = load i32, i32* %v0
	%tmp73 = add i32 %tmp72, 1
	store i32 %tmp73, i32* %v0
	%tmp74 = call %"struct.vector.Vec<%struct.Argument>" @parse_argument_comma(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	store %"struct.vector.Vec<%struct.Argument>" %tmp74, %"struct.vector.Vec<%struct.Argument>"* %v6
	%tmp75 = load i32, i32* %v0
	%tmp76 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp75
	%tmp77 = load i8, i8* %tmp76
	%tmp78 = icmp ne i8 %tmp77, 1
	br i1 %tmp78, label %then15, label %endif15
then15:
	call void @process.throw(i8* @.str.23)
	br label %endif15
endif15:
	%tmp79 = load i32, i32* %v0
	%tmp80 = add i32 %tmp79, 1
	store i32 %tmp80, i32* %v0
	store %struct.Type* null, %struct.Type** %v7
	%tmp81 = load i32, i32* %v0
	%tmp82 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp81
	%tmp83 = load i8, i8* %tmp82
	%tmp84 = icmp eq i8 %tmp83, 6
	br i1 %tmp84, label %then16, label %endif16
then16:
	%tmp85 = load i32, i32* %v0
	%tmp86 = add i32 %tmp85, 1
	store i32 %tmp86, i32* %v0
	%tmp87 = call %struct.Type @parse_type(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	%tmp88 = call i8* @mem.malloc(i64 16)
	store %struct.Type* %tmp88, %struct.Type** %v7
	%tmp89 = load %struct.Type*, %struct.Type** %v7
	store %struct.Type %tmp87, %struct.Type* %tmp89
; Variable parsed_type is out.
	br label %endif16
endif16:
	%tmp90 = call %"struct.vector.Vec<%struct.Stmt>" @"vector.new<%struct.Stmt>"()
	store %"struct.vector.Vec<%struct.Stmt>" %tmp90, %"struct.vector.Vec<%struct.Stmt>"* %v8
	%tmp91 = load i32, i32* %v0
	%tmp92 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp91
	%tmp93 = load i8, i8* %tmp92
	%tmp94 = icmp eq i8 %tmp93, 2
	br i1 %tmp94, label %then17, label %else17
then17:
	%tmp95 = load i32, i32* %v0
	%tmp96 = add i32 %tmp95, 1
	call void @skip_nested(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 2, i8 3)
	%tmp97 = load i32, i32* %v0
	%tmp98 = sub i32 %tmp97, 1
	%tmp99 = sub i32 %tmp98, %tmp96
	%tmp100 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp96
	call void @parse_body(%struct.TokenData* %tmp100, i32 %tmp99, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %"struct.vector.Vec<%struct.Stmt>"* %v8)
	br label %endif17
else17:
	%tmp101 = load i32, i32* %v0
	%tmp102 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp101
	%tmp103 = load i8, i8* %tmp102
	%tmp104 = icmp eq i8 %tmp103, 13
	br i1 %tmp104, label %then18, label %else18
then18:
	%tmp105 = load i32, i32* %v0
	%tmp106 = add i32 %tmp105, 1
	store i32 %tmp106, i32* %v0
	%tmp107 = call i8* @mem.malloc(i64 24)
	%tmp108 = getelementptr inbounds %struct.ReturnNode, %struct.ReturnNode* %tmp107, i32 0, i32 1
	%tmp109 = call %struct.Expression @parse_expression(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	store %struct.Expression %tmp109, %struct.Expression* %tmp108
	call void @expect(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 8, i8* @.str.24)
	store i8 10, i8* %v9
	%tmp110 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %v9, i32 0, i32 1
	store i8* %tmp107, i8** %tmp110
	%tmp111 = load %struct.Stmt, %struct.Stmt* %v9
	call void @"vector.push<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %v8, %struct.Stmt %tmp111)
; Variable stmt is out.
	br label %endif18
else18:
	%tmp112 = load i32, i32* %v0
	%tmp113 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp112
	%tmp114 = load i8, i8* %tmp113
	%tmp115 = icmp eq i8 %tmp114, 8
	br i1 %tmp115, label %then19, label %endif19
then19:
	%tmp116 = load i32, i32* %v0
	%tmp117 = add i32 %tmp116, 1
	store i32 %tmp117, i32* %v0
	br label %endif19
endif19:
	br label %endif18
endif18:
	br label %endif17
endif17:
	%tmp118 = call i8* @mem.malloc(i64 64)
	store i16 %tmp56, i16* %tmp118
	%tmp119 = getelementptr inbounds %struct.FnNode, %struct.FnNode* %tmp118, i32 0, i32 1
	%tmp120 = load %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %v6
	store %"struct.vector.Vec<%struct.Argument>" %tmp120, %"struct.vector.Vec<%struct.Argument>"* %tmp119
	%tmp121 = getelementptr inbounds %struct.FnNode, %struct.FnNode* %tmp118, i32 0, i32 2
	%tmp122 = load %struct.Type*, %struct.Type** %v7
	store %struct.Type* %tmp122, %struct.Type** %tmp121
	%tmp123 = getelementptr inbounds %struct.FnNode, %struct.FnNode* %tmp118, i32 0, i32 3
	%tmp124 = call %"struct.vector.Vec<i16>" @"vector.new<i16>"()
	store %"struct.vector.Vec<i16>" %tmp124, %"struct.vector.Vec<i16>"* %tmp123
	%tmp125 = getelementptr inbounds %struct.FnNode, %struct.FnNode* %tmp118, i32 0, i32 4
	%tmp126 = load %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %v8
	store %"struct.vector.Vec<%struct.Stmt>" %tmp126, %"struct.vector.Vec<%struct.Stmt>"* %tmp125
	store i8 11, i8* %v10
	%tmp127 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %v10, i32 0, i32 1
	store i8* %tmp118, i8** %tmp127
	%tmp128 = load %struct.Stmt, %struct.Stmt* %v10
	call void @"vector.push<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %statement_vector, %struct.Stmt %tmp128)
	br label %loop_body1
; Variable stmt is out.
; Variable nodes is out.
; Variable args is out.
endif10:
	%tmp129 = icmp eq i8 %tmp5, 61
	br i1 %tmp129, label %then20, label %endif20
then20:
	store i32 4294967295, i32* %v1
	%tmp130 = load i32, i32* %v0
	%tmp131 = add i32 %tmp130, 1
	store i32 %tmp131, i32* %v0
	%tmp132 = load i32, i32* %v0
	%tmp133 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp132
	%tmp134 = load i8, i8* %tmp133
	%tmp135 = icmp ne i8 %tmp134, 65
	br i1 %tmp135, label %then21, label %endif21
then21:
	call void @process.throw(i8* @.str.25)
	br label %endif21
endif21:
	%tmp136 = load i32, i32* %v0
	%tmp137 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp136
	%tmp138 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp137, i32 0, i32 1
	%tmp139 = load i16, i16* %tmp138
	%tmp140 = load i32, i32* %v0
	%tmp141 = add i32 %tmp140, 1
	store i32 %tmp141, i32* %v0
	%tmp142 = call %"struct.vector.Vec<%struct.Stmt>" @"vector.new<%struct.Stmt>"()
	store %"struct.vector.Vec<%struct.Stmt>" %tmp142, %"struct.vector.Vec<%struct.Stmt>"* %v11
	%tmp143 = load i32, i32* %v0
	%tmp144 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp143
	%tmp145 = load i8, i8* %tmp144
	%tmp146 = icmp eq i8 %tmp145, 2
	br i1 %tmp146, label %then22, label %else22
then22:
	%tmp147 = load i32, i32* %v0
	%tmp148 = add i32 %tmp147, 1
	call void @skip_nested(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 2, i8 3)
	%tmp149 = load i32, i32* %v0
	%tmp150 = sub i32 %tmp149, 1
	%tmp151 = sub i32 %tmp150, %tmp148
	%tmp152 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp148
	call void @parse(%struct.TokenData* %tmp152, i32 %tmp151, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %"struct.vector.Vec<%struct.Stmt>"* %v11)
	br label %endif22
else22:
	call void @process.throw(i8* @.str.26)
	br label %endif22
endif22:
	%tmp153 = call i8* @mem.malloc(i64 24)
	store i16 %tmp139, i16* %tmp153
	%tmp154 = getelementptr inbounds %struct.NamespaceNode, %struct.NamespaceNode* %tmp153, i32 0, i32 1
	%tmp155 = load %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %v11
	store %"struct.vector.Vec<%struct.Stmt>" %tmp155, %"struct.vector.Vec<%struct.Stmt>"* %tmp154
	store i8 14, i8* %v12
	%tmp156 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %v12, i32 0, i32 1
	store i8* %tmp153, i8** %tmp156
	%tmp157 = load %struct.Stmt, %struct.Stmt* %v12
	call void @"vector.push<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %statement_vector, %struct.Stmt %tmp157)
	br label %loop_body1
; Variable stmt is out.
; Variable nodes is out.
endif20:
	%tmp158 = icmp eq i8 %tmp5, 50
	br i1 %tmp158, label %then23, label %endif23
then23:
	store i32 4294967295, i32* %v1
	%tmp159 = load i32, i32* %v0
	%tmp160 = add i32 %tmp159, 1
	store i32 %tmp160, i32* %v0
	%tmp161 = load i32, i32* %v0
	%tmp162 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp161
	%tmp163 = load i8, i8* %tmp162
	%tmp164 = icmp ne i8 %tmp163, 65
	br i1 %tmp164, label %then24, label %endif24
then24:
	call void @process.throw(i8* @.str.27)
	br label %endif24
endif24:
	%tmp165 = load i32, i32* %v0
	%tmp166 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp165
	%tmp167 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp166, i32 0, i32 1
	%tmp168 = load i16, i16* %tmp167
	%tmp169 = load i32, i32* %v0
	%tmp170 = add i32 %tmp169, 1
	store i32 %tmp170, i32* %v0
	store %struct.Type* null, %struct.Type** %v13
	%tmp171 = load i32, i32* %v0
	%tmp172 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp171
	%tmp173 = load i8, i8* %tmp172
	%tmp174 = icmp eq i8 %tmp173, 6
	br i1 %tmp174, label %then25, label %endif25
then25:
	%tmp175 = load i32, i32* %v0
	%tmp176 = add i32 %tmp175, 1
	store i32 %tmp176, i32* %v0
	%tmp177 = call %struct.Type @parse_type(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	%tmp178 = call i8* @mem.malloc(i64 16)
	store %struct.Type* %tmp178, %struct.Type** %v13
	%tmp179 = load %struct.Type*, %struct.Type** %v13
	store %struct.Type %tmp177, %struct.Type* %tmp179
; Variable parsed_type is out.
	br label %endif25
endif25:
	%tmp180 = call %"struct.vector.Vec<%struct.EnumField>" @"vector.new<%struct.EnumField>"()
	store %"struct.vector.Vec<%struct.EnumField>" %tmp180, %"struct.vector.Vec<%struct.EnumField>"* %v14
	%tmp181 = load i32, i32* %v0
	%tmp182 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp181
	%tmp183 = load i8, i8* %tmp182
	%tmp184 = icmp eq i8 %tmp183, 2
	br i1 %tmp184, label %then26, label %else26
then26:
	%tmp185 = call %"struct.vector.Vec<%struct.EnumField>" @parse_enum_fields(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	store %"struct.vector.Vec<%struct.EnumField>" %tmp185, %"struct.vector.Vec<%struct.EnumField>"* %v14
	br label %endif26
else26:
	call void @process.throw(i8* @.str.28)
	br label %endif26
endif26:
	%tmp186 = call i8* @mem.malloc(i64 32)
	store i16 %tmp168, i16* %tmp186
	%tmp187 = getelementptr inbounds %struct.EnumNode, %struct.EnumNode* %tmp186, i32 0, i32 1
	%tmp188 = load %struct.Type*, %struct.Type** %v13
	store %struct.Type* %tmp188, %struct.Type** %tmp187
	%tmp189 = getelementptr inbounds %struct.EnumNode, %struct.EnumNode* %tmp186, i32 0, i32 2
	%tmp190 = load %"struct.vector.Vec<%struct.EnumField>", %"struct.vector.Vec<%struct.EnumField>"* %v14
	store %"struct.vector.Vec<%struct.EnumField>" %tmp190, %"struct.vector.Vec<%struct.EnumField>"* %tmp189
	store i8 13, i8* %v15
	%tmp191 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %v15, i32 0, i32 1
	store i8* %tmp186, i8** %tmp191
	%tmp192 = load %struct.Stmt, %struct.Stmt* %v15
	call void @"vector.push<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %statement_vector, %struct.Stmt %tmp192)
	br label %loop_body1
; Variable stmt is out.
; Variable fields is out.
endif23:
	%tmp193 = icmp eq i8 %tmp5, 49
	br i1 %tmp193, label %then27, label %endif27
then27:
	store i32 4294967295, i32* %v1
	%tmp194 = load i32, i32* %v0
	%tmp195 = add i32 %tmp194, 1
	store i32 %tmp195, i32* %v0
	%tmp196 = load i32, i32* %v0
	%tmp197 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp196
	%tmp198 = load i8, i8* %tmp197
	%tmp199 = icmp ne i8 %tmp198, 65
	br i1 %tmp199, label %then28, label %endif28
then28:
	call void @process.throw(i8* @.str.29)
	br label %endif28
endif28:
	%tmp200 = load i32, i32* %v0
	%tmp201 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp200
	%tmp202 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp201, i32 0, i32 1
	%tmp203 = load i16, i16* %tmp202
	%tmp204 = load i32, i32* %v0
	%tmp205 = add i32 %tmp204, 1
	store i32 %tmp205, i32* %v0
	%tmp206 = call %"struct.vector.Vec<i16>" @"vector.new<i16>"()
	store %"struct.vector.Vec<i16>" %tmp206, %"struct.vector.Vec<i16>"* %v16
	%tmp207 = load i32, i32* %v0
	%tmp208 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp207
	%tmp209 = load i8, i8* %tmp208
	%tmp210 = icmp eq i8 %tmp209, 28
	br i1 %tmp210, label %then29, label %endif29
then29:
	%tmp211 = call %"struct.vector.Vec<i16>" @parse_generic_params(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	store %"struct.vector.Vec<i16>" %tmp211, %"struct.vector.Vec<i16>"* %v16
	br label %endif29
endif29:
	%tmp212 = call %"struct.vector.Vec<%struct.Argument>" @"vector.new<%struct.Argument>"()
	store %"struct.vector.Vec<%struct.Argument>" %tmp212, %"struct.vector.Vec<%struct.Argument>"* %v17
	%tmp213 = load i32, i32* %v0
	%tmp214 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp213
	%tmp215 = load i8, i8* %tmp214
	%tmp216 = icmp eq i8 %tmp215, 2
	br i1 %tmp216, label %then30, label %else30
then30:
	%tmp217 = call %"struct.vector.Vec<%struct.Argument>" @parse_struct_fields(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	store %"struct.vector.Vec<%struct.Argument>" %tmp217, %"struct.vector.Vec<%struct.Argument>"* %v17
	br label %endif30
else30:
	call void @process.throw(i8* @.str.30)
	br label %endif30
endif30:
	%tmp218 = call i8* @mem.malloc(i64 40)
	store i16 %tmp203, i16* %tmp218
	%tmp219 = getelementptr inbounds %struct.StructNode, %struct.StructNode* %tmp218, i32 0, i32 1
	%tmp220 = load %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %v17
	store %"struct.vector.Vec<%struct.Argument>" %tmp220, %"struct.vector.Vec<%struct.Argument>"* %tmp219
	%tmp221 = getelementptr inbounds %struct.StructNode, %struct.StructNode* %tmp218, i32 0, i32 2
	%tmp222 = load %"struct.vector.Vec<i16>", %"struct.vector.Vec<i16>"* %v16
	store %"struct.vector.Vec<i16>" %tmp222, %"struct.vector.Vec<i16>"* %tmp221
	store i8 12, i8* %v18
	%tmp223 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %v18, i32 0, i32 1
	store i8* %tmp218, i8** %tmp223
	%tmp224 = load %struct.Stmt, %struct.Stmt* %v18
	call void @"vector.push<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %statement_vector, %struct.Stmt %tmp224)
	br label %loop_body1
; Variable stmt is out.
; Variable fields is out.
; Variable generics is out.
endif27:
	%tmp225 = load i32, i32* %v0
	%tmp226 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp225
	%tmp227 = load i8, i8* %tmp226
	%tmp228 = icmp eq i8 %tmp227, 2
	br i1 %tmp228, label %then31, label %endif31
then31:
	%tmp229 = load i32, i32* %v0
	call void @skip_nested(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 2, i8 3)
	%tmp230 = call %"struct.vector.Vec<%struct.Stmt>" @"vector.new<%struct.Stmt>"()
	store %"struct.vector.Vec<%struct.Stmt>" %tmp230, %"struct.vector.Vec<%struct.Stmt>"* %v19
	%tmp231 = load i32, i32* %v0
	%tmp232 = sub i32 %tmp231, 1
	%tmp233 = add i32 %tmp229, 1
	%tmp234 = sub i32 %tmp232, %tmp233
	%tmp235 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp229
	%tmp236 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp235, i32 1
	call void @parse(%struct.TokenData* %tmp236, i32 %tmp234, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %"struct.vector.Vec<%struct.Stmt>"* %v19)
	%tmp237 = getelementptr inbounds %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %v19, i32 0, i32 1
	%tmp238 = load i32, i32* %tmp237
	store i32 0, i32* %v20
	br label %loop_cond32
loop_cond32:
	%tmp239 = load i32, i32* %v20
	%tmp240 = getelementptr inbounds %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %v19, i32 0, i32 1
	%tmp241 = load i32, i32* %tmp240
	%tmp242 = icmp uge i32 %tmp239, %tmp241
	br i1 %tmp242, label %then33, label %endif33
then33:
	br label %loop_body32_exit
endif33:
	%tmp243 = load i32, i32* %v20
	%tmp244 = load %struct.Stmt*, %struct.Stmt** %v19
	%tmp245 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp244, i32 %tmp243
	%tmp246 = load %struct.Stmt, %struct.Stmt* %tmp245
	call void @"vector.push<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %statement_vector, %struct.Stmt %tmp246)
	%tmp247 = load i32, i32* %v20
	%tmp248 = add i32 %tmp247, 1
	store i32 %tmp248, i32* %v20
	br label %loop_cond32
loop_body32_exit:
	br label %loop_body1
; Variable m is out.
endif31:
	%tmp249 = load i32, i32* %v1
	%tmp250 = icmp ne i32 %tmp249, 4294967295
	br i1 %tmp250, label %then34, label %endif34
then34:
	%tmp251 = load i32, i32* %v0
	%tmp252 = sub i32 %tmp251, 1
	%tmp253 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp252
	%tmp254 = load i8, i8* %tmp253
	%tmp255 = icmp eq i8 %tmp254, 38
	br i1 %tmp255, label %logic_end_35, label %logic_rhs_35
logic_rhs_35:
	%tmp256 = load i32, i32* %v0
	%tmp257 = sub i32 %tmp256, 1
	%tmp258 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp257
	%tmp259 = load i8, i8* %tmp258
	%tmp260 = icmp eq i8 %tmp259, 43
	br label %logic_end_35
logic_end_35:
	%tmp261 = phi i1 [%tmp255, %then34], [%tmp260, %logic_rhs_35]
	br i1 %tmp261, label %then36, label %endif36
then36:
	%tmp262 = load i32, i32* %v0
	%tmp263 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp262
	%tmp264 = load i8, i8* %tmp263
	%tmp265 = icmp ne i8 %tmp264, 65
	br i1 %tmp265, label %then37, label %endif37
then37:
	call void @process.throw(i8* @.str.31)
	br label %endif37
endif37:
	%tmp266 = load i32, i32* %v0
	%tmp267 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp266
	%tmp268 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp267, i32 0, i32 1
	%tmp269 = load i16, i16* %tmp268
	%tmp270 = load i32, i32* %v0
	%tmp271 = add i32 %tmp270, 1
	store i32 %tmp271, i32* %v0
	%tmp272 = load i32, i32* %v0
	%tmp273 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp272
	%tmp274 = load i8, i8* %tmp273
	%tmp275 = icmp eq i8 %tmp274, 6
	br i1 %tmp275, label %then38, label %else38
then38:
	%tmp276 = load i32, i32* %v0
	%tmp277 = add i32 %tmp276, 1
	store i32 %tmp277, i32* %v0
	%tmp278 = call %struct.Type @parse_type(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	%tmp279 = call i8* @mem.malloc(i64 16)
	store %struct.Type* %tmp279, %struct.Type** %v21
	%tmp280 = load %struct.Type*, %struct.Type** %v21
	store %struct.Type %tmp278, %struct.Type* %tmp280
; Variable parsed_type is out.
	br label %endif38
else38:
	call void @process.throw(i8* @.str.32)
	br label %endif38
endif38:
	%tmp281 = load i32, i32* %v0
	%tmp282 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp281
	%tmp283 = load i8, i8* %tmp282
	%tmp284 = icmp eq i8 %tmp283, 15
	br i1 %tmp284, label %then39, label %else39
then39:
	%tmp285 = load i32, i32* %v0
	%tmp286 = add i32 %tmp285, 1
	store i32 %tmp286, i32* %v0
	call %struct.Expression @parse_expression(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	br label %endif39
else39:
	%tmp287 = load i32, i32* %v0
	%tmp288 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp287
	%tmp289 = load i8, i8* %tmp288
	%tmp290 = icmp eq i8 %tmp289, 8
	br i1 %tmp290, label %endif40, label %else40
else40:
	call void @process.throw(i8* @.str.33)
	br label %endif40
endif40:
	br label %endif39
endif39:
	%tmp291 = load i32, i32* %v0
	%tmp292 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp291
	%tmp293 = load i8, i8* %tmp292
	%tmp294 = icmp ne i8 %tmp293, 8
	br i1 %tmp294, label %then41, label %endif41
then41:
	call void @process.throw(i8* @.str.34)
	br label %endif41
endif41:
	%tmp295 = load i32, i32* %v0
	%tmp296 = add i32 %tmp295, 1
	store i32 %tmp296, i32* %v0
	store i32 4294967295, i32* %v1
	br label %loop_body1
endif36:
	br label %endif34
endif34:
	store i32 0, i32* %v22
	br label %loop_cond42
loop_cond42:
	%tmp297 = load i32, i32* %v22
	%tmp298 = icmp uge i32 %tmp297, 3
	br i1 %tmp298, label %then43, label %endif43
then43:
	br label %loop_body42_exit
endif43:
	%tmp299 = load i32, i32* %v0
	%tmp300 = load i32, i32* %v22
	%tmp301 = add i32 %tmp299, %tmp300
	%tmp302 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp301
	%tmp303 = call %struct.string.String @token_type_to_string(%struct.TokenData* %tmp302, %"struct.vector.Vec<%struct.string.String>"* null)
	store %struct.string.String %tmp303, %struct.string.String* %v23
	call void @console.write_string(%struct.string.String* %v23)
	call void @console.write(i8* @.str.35, i32 6)
	call void @string.free(%struct.string.String* %v23)
	%tmp304 = load i32, i32* %v22
	%tmp305 = add i32 %tmp304, 1
	store i32 %tmp305, i32* %v22
	br label %loop_cond42
loop_body42_exit:
; Variable q is out.
	call void @process.throw(i8* @.str.36)
	br label %loop_body1
loop_body1:
	br label %loop_start1
loop_body1_exit:
	br label %func_exit
func_exit:
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
	%tmp18 = add i32 %tmp17, 1
	store i32 %tmp18, i32* %v0
	br label %loop_body0
endif6:
	store i8 0, i8* %v2
	%tmp19 = load i32, i32* %v0
	%tmp20 = add i32 %tmp19, 1
	%tmp21 = getelementptr inbounds %struct.string.String, %struct.string.String* %data, i32 0, i32 1
	%tmp22 = load i32, i32* %tmp21
	%tmp23 = icmp ult i32 %tmp20, %tmp22
	br i1 %tmp23, label %then7, label %else7
then7:
	%tmp24 = load i32, i32* %v0
	%tmp25 = add i32 %tmp24, 1
	%tmp26 = load i8*, i8** %data
	%tmp27 = getelementptr inbounds i8, i8* %tmp26, i32 %tmp25
	%tmp28 = load i8, i8* %tmp27
	store i8 %tmp28, i8* %v2
	br label %endif7
else7:
	store i8 0, i8* %v2
	br label %endif7
endif7:
	store i8 0, i8* %v3
	%tmp29 = load i32, i32* %v0
	%tmp30 = add i32 %tmp29, 2
	%tmp31 = getelementptr inbounds %struct.string.String, %struct.string.String* %data, i32 0, i32 1
	%tmp32 = load i32, i32* %tmp31
	%tmp33 = icmp ult i32 %tmp30, %tmp32
	br i1 %tmp33, label %then8, label %else8
then8:
	%tmp34 = load i32, i32* %v0
	%tmp35 = add i32 %tmp34, 2
	%tmp36 = load i8*, i8** %data
	%tmp37 = getelementptr inbounds i8, i8* %tmp36, i32 %tmp35
	%tmp38 = load i8, i8* %tmp37
	store i8 %tmp38, i8* %v3
	br label %endif8
else8:
	store i8 0, i8* %v3
	br label %endif8
endif8:
	%tmp39 = load i8, i8* %v1
	br label %inl_entry9
inl_entry9:
	%tmp40 = icmp sge i8 %tmp39, 97
	br i1 %tmp40, label %logic_rhs_10, label %logic_end_10
logic_rhs_10:
	%tmp41 = icmp sle i8 %tmp39, 122
	br label %logic_end_10
logic_end_10:
	%tmp42 = phi i1 [%tmp40, %inl_entry9], [%tmp41, %logic_rhs_10]
	br i1 %tmp42, label %logic_end_11, label %logic_rhs_11
logic_rhs_11:
	%tmp43 = icmp sge i8 %tmp39, 65
	br i1 %tmp43, label %logic_rhs_12, label %logic_end_12
logic_rhs_12:
	%tmp44 = icmp sle i8 %tmp39, 90
	br label %logic_end_12
logic_end_12:
	%tmp45 = phi i1 [%tmp43, %logic_rhs_11], [%tmp44, %logic_rhs_12]
	br label %logic_end_11
logic_end_11:
	%tmp46 = phi i1 [%tmp42, %logic_end_10], [%tmp45, %logic_end_12]
	br label %inl_exit9
inl_exit9:
	br i1 %tmp46, label %logic_end_13, label %logic_rhs_13
logic_rhs_13:
	%tmp47 = load i8, i8* %v1
	%tmp48 = icmp eq i8 %tmp47, 95
	br label %logic_end_13
logic_end_13:
	%tmp49 = phi i1 [%tmp46, %inl_exit9], [%tmp48, %logic_rhs_13]
	br i1 %tmp49, label %then14, label %else14
then14:
	%tmp50 = load i32, i32* %v0
	%tmp51 = add i32 %tmp50, 1
	store i32 %tmp51, i32* %v4
	br label %loop_start15
loop_start15:
	%tmp52 = load i32, i32* %v4
	%tmp53 = getelementptr inbounds %struct.string.String, %struct.string.String* %data, i32 0, i32 1
	%tmp54 = load i32, i32* %tmp53
	%tmp55 = icmp ult i32 %tmp52, %tmp54
	br i1 %tmp55, label %endif16, label %else16
else16:
	br label %loop_body15_exit
endif16:
	%tmp56 = load i32, i32* %v4
	%tmp57 = load i8*, i8** %data
	%tmp58 = getelementptr inbounds i8, i8* %tmp57, i32 %tmp56
	%tmp59 = load i8, i8* %tmp58
	br label %inl_entry18
inl_entry18:
	%tmp60 = icmp sge i8 %tmp59, 97
	br i1 %tmp60, label %logic_rhs_19, label %logic_end_19
logic_rhs_19:
	%tmp61 = icmp sle i8 %tmp59, 122
	br label %logic_end_19
logic_end_19:
	%tmp62 = phi i1 [%tmp60, %inl_entry18], [%tmp61, %logic_rhs_19]
	br i1 %tmp62, label %logic_end_20, label %logic_rhs_20
logic_rhs_20:
	%tmp63 = icmp sge i8 %tmp59, 65
	br i1 %tmp63, label %logic_rhs_21, label %logic_end_21
logic_rhs_21:
	%tmp64 = icmp sle i8 %tmp59, 90
	br label %logic_end_21
logic_end_21:
	%tmp65 = phi i1 [%tmp63, %logic_rhs_20], [%tmp64, %logic_rhs_21]
	br label %logic_end_20
logic_end_20:
	%tmp66 = phi i1 [%tmp62, %logic_end_19], [%tmp65, %logic_end_21]
	br label %inl_exit18
inl_exit18:
	br i1 %tmp66, label %logic_end_22, label %logic_rhs_22
logic_rhs_22:
	br label %inl_entry23
inl_entry23:
	%tmp67 = icmp sge i8 %tmp59, 48
	br i1 %tmp67, label %logic_rhs_24, label %logic_end_24
logic_rhs_24:
	%tmp68 = icmp sle i8 %tmp59, 57
	br label %logic_end_24
logic_end_24:
	%tmp69 = phi i1 [%tmp67, %inl_entry23], [%tmp68, %logic_rhs_24]
	br label %inl_exit23
inl_exit23:
	br label %logic_end_22
logic_end_22:
	%tmp70 = phi i1 [%tmp66, %inl_exit18], [%tmp69, %inl_exit23]
	br label %inl_exit17
inl_exit17:
	br i1 %tmp70, label %logic_end_25, label %logic_rhs_25
logic_rhs_25:
	%tmp71 = load i32, i32* %v4
	%tmp72 = load i8*, i8** %data
	%tmp73 = getelementptr inbounds i8, i8* %tmp72, i32 %tmp71
	%tmp74 = load i8, i8* %tmp73
	%tmp75 = icmp eq i8 %tmp74, 95
	br label %logic_end_25
logic_end_25:
	%tmp76 = phi i1 [%tmp70, %inl_exit17], [%tmp75, %logic_rhs_25]
	br i1 %tmp76, label %then26, label %endif26
then26:
	%tmp77 = load i32, i32* %v4
	%tmp78 = add i32 %tmp77, 1
	store i32 %tmp78, i32* %v4
	br label %loop_body15
endif26:
	br label %loop_body15_exit
loop_body15:
	br label %loop_start15
loop_body15_exit:
	%tmp79 = load i8*, i8** %data
	%tmp80 = load i32, i32* %v0
	%tmp81 = load i32, i32* %v4
	call void @handle_symbol(i8* %tmp79, i32 %tmp80, i32 %tmp81, %"struct.vector.Vec<%struct.TokenData>"* %token_vector, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector)
	%tmp82 = load i32, i32* %v4
	store i32 %tmp82, i32* %v0
	br label %loop_body0
else14:
	%tmp83 = load i8, i8* %v1
	br label %inl_entry27
inl_entry27:
	%tmp84 = icmp sge i8 %tmp83, 48
	br i1 %tmp84, label %logic_rhs_28, label %logic_end_28
logic_rhs_28:
	%tmp85 = icmp sle i8 %tmp83, 57
	br label %logic_end_28
logic_end_28:
	%tmp86 = phi i1 [%tmp84, %inl_entry27], [%tmp85, %logic_rhs_28]
	br label %inl_exit27
inl_exit27:
	br i1 %tmp86, label %logic_end_29, label %logic_rhs_29
logic_rhs_29:
	%tmp87 = load i8, i8* %v1
	%tmp88 = icmp eq i8 %tmp87, 45
	br i1 %tmp88, label %logic_rhs_30, label %logic_end_30
logic_rhs_30:
	%tmp89 = load i8, i8* %v2
	br label %inl_entry31
inl_entry31:
	%tmp90 = icmp sge i8 %tmp89, 48
	br i1 %tmp90, label %logic_rhs_32, label %logic_end_32
logic_rhs_32:
	%tmp91 = icmp sle i8 %tmp89, 57
	br label %logic_end_32
logic_end_32:
	%tmp92 = phi i1 [%tmp90, %inl_entry31], [%tmp91, %logic_rhs_32]
	br label %inl_exit31
inl_exit31:
	br label %logic_end_30
logic_end_30:
	%tmp93 = phi i1 [%tmp88, %logic_rhs_29], [%tmp92, %inl_exit31]
	br label %logic_end_29
logic_end_29:
	%tmp94 = phi i1 [%tmp86, %inl_exit27], [%tmp93, %logic_end_30]
	br i1 %tmp94, label %then33, label %else33
then33:
	%tmp95 = load i32, i32* %v0
	%tmp96 = add i32 %tmp95, 1
	store i32 %tmp96, i32* %v5
	%tmp97 = load i8, i8* %v1
	%tmp98 = icmp eq i8 %tmp97, 45
	br i1 %tmp98, label %then34, label %endif34
then34:
	%tmp99 = load i8, i8* %v2
	store i8 %tmp99, i8* %v1
	br label %endif34
endif34:
	%tmp100 = load i8, i8* %v1
	%tmp101 = icmp eq i8 %tmp100, 48
	br i1 %tmp101, label %then35, label %endif35
then35:
	%tmp102 = load i8, i8* %v2
	%tmp103 = icmp eq i8 %tmp102, 120
	br i1 %tmp103, label %then36, label %else36
then36:
	%tmp104 = load i32, i32* %v5
	%tmp105 = add i32 %tmp104, 1
	store i32 %tmp105, i32* %v5
	br label %endif36
else36:
	%tmp106 = load i8, i8* %v2
	%tmp107 = icmp eq i8 %tmp106, 98
	br i1 %tmp107, label %then37, label %endif37
then37:
	%tmp108 = load i32, i32* %v5
	%tmp109 = add i32 %tmp108, 1
	store i32 %tmp109, i32* %v5
	br label %endif37
endif37:
	br label %endif36
endif36:
	br label %endif35
endif35:
	store i1 false, i1* %v6
	br label %loop_start38
loop_start38:
	%tmp110 = load i32, i32* %v5
	%tmp111 = getelementptr inbounds %struct.string.String, %struct.string.String* %data, i32 0, i32 1
	%tmp112 = load i32, i32* %tmp111
	%tmp113 = icmp ult i32 %tmp110, %tmp112
	br i1 %tmp113, label %endif39, label %else39
else39:
	br label %loop_body38_exit
endif39:
	%tmp114 = load i32, i32* %v5
	%tmp115 = load i8*, i8** %data
	%tmp116 = getelementptr inbounds i8, i8* %tmp115, i32 %tmp114
	%tmp117 = load i8, i8* %tmp116
	br label %inl_entry41
inl_entry41:
	%tmp118 = icmp sge i8 %tmp117, 48
	br i1 %tmp118, label %logic_rhs_42, label %logic_end_42
logic_rhs_42:
	%tmp119 = icmp sle i8 %tmp117, 57
	br label %logic_end_42
logic_end_42:
	%tmp120 = phi i1 [%tmp118, %inl_entry41], [%tmp119, %logic_rhs_42]
	br label %inl_exit41
inl_exit41:
	br i1 %tmp120, label %logic_end_43, label %logic_rhs_43
logic_rhs_43:
	%tmp121 = icmp sge i8 %tmp117, 97
	br i1 %tmp121, label %logic_rhs_44, label %logic_end_44
logic_rhs_44:
	%tmp122 = icmp sle i8 %tmp117, 102
	br label %logic_end_44
logic_end_44:
	%tmp123 = phi i1 [%tmp121, %logic_rhs_43], [%tmp122, %logic_rhs_44]
	br label %logic_end_43
logic_end_43:
	%tmp124 = phi i1 [%tmp120, %inl_exit41], [%tmp123, %logic_end_44]
	br i1 %tmp124, label %logic_end_45, label %logic_rhs_45
logic_rhs_45:
	%tmp125 = icmp sge i8 %tmp117, 65
	br i1 %tmp125, label %logic_rhs_46, label %logic_end_46
logic_rhs_46:
	%tmp126 = icmp sle i8 %tmp117, 70
	br label %logic_end_46
logic_end_46:
	%tmp127 = phi i1 [%tmp125, %logic_rhs_45], [%tmp126, %logic_rhs_46]
	br label %logic_end_45
logic_end_45:
	%tmp128 = phi i1 [%tmp124, %logic_end_43], [%tmp127, %logic_end_46]
	br label %inl_exit40
inl_exit40:
	br i1 %tmp128, label %logic_end_47, label %logic_rhs_47
logic_rhs_47:
	%tmp129 = load i32, i32* %v5
	%tmp130 = load i8*, i8** %data
	%tmp131 = getelementptr inbounds i8, i8* %tmp130, i32 %tmp129
	%tmp132 = load i8, i8* %tmp131
	%tmp133 = icmp eq i8 %tmp132, 95
	br label %logic_end_47
logic_end_47:
	%tmp134 = phi i1 [%tmp128, %inl_exit40], [%tmp133, %logic_rhs_47]
	br i1 %tmp134, label %then48, label %endif48
then48:
	%tmp135 = load i32, i32* %v5
	%tmp136 = add i32 %tmp135, 1
	store i32 %tmp136, i32* %v5
	br label %loop_body38
endif48:
	%tmp137 = load i32, i32* %v5
	%tmp138 = load i8*, i8** %data
	%tmp139 = getelementptr inbounds i8, i8* %tmp138, i32 %tmp137
	%tmp140 = load i8, i8* %tmp139
	%tmp141 = icmp eq i8 %tmp140, 46
	br i1 %tmp141, label %then49, label %endif49
then49:
	%tmp142 = load i1, i1* %v6
	%tmp143 = xor i1 1, %tmp142
	br i1 %tmp143, label %then50, label %endif50
then50:
	store i1 true, i1* %v6
	%tmp144 = load i32, i32* %v5
	%tmp145 = add i32 %tmp144, 1
	store i32 %tmp145, i32* %v5
	br label %loop_body38
endif50:
	br label %endif49
endif49:
	br label %loop_body38_exit
loop_body38:
	br label %loop_start38
loop_body38_exit:
	%tmp146 = load i1, i1* %v6
	br i1 %tmp146, label %then51, label %else51
then51:
	%tmp147 = load i8*, i8** %data
	%tmp148 = load i32, i32* %v0
	%tmp149 = load i32, i32* %v5
	call void @handle_decimal_number(i8* %tmp147, i32 %tmp148, i32 %tmp149, %"struct.vector.Vec<%struct.TokenData>"* %token_vector, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector)
	br label %endif51
else51:
	%tmp150 = load i8*, i8** %data
	%tmp151 = load i32, i32* %v0
	%tmp152 = load i32, i32* %v5
	call void @handle_number(i8* %tmp150, i32 %tmp151, i32 %tmp152, %"struct.vector.Vec<%struct.TokenData>"* %token_vector, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector)
	br label %endif51
endif51:
	%tmp153 = load i32, i32* %v5
	store i32 %tmp153, i32* %v0
	br label %loop_body0
else33:
	%tmp154 = load i8, i8* %v1
	%tmp155 = icmp eq i8 %tmp154, 34
	br i1 %tmp155, label %then52, label %else52
then52:
	%tmp156 = load i32, i32* %v0
	%tmp157 = add i32 %tmp156, 1
	store i32 %tmp157, i32* %v7
	store i1 false, i1* %v8
	br label %loop_start53
loop_start53:
	%tmp158 = load i32, i32* %v7
	%tmp159 = getelementptr inbounds %struct.string.String, %struct.string.String* %data, i32 0, i32 1
	%tmp160 = load i32, i32* %tmp159
	%tmp161 = icmp ult i32 %tmp158, %tmp160
	br i1 %tmp161, label %endif54, label %else54
else54:
	br label %loop_body53_exit
endif54:
	%tmp162 = load i32, i32* %v7
	%tmp163 = load i8*, i8** %data
	%tmp164 = getelementptr inbounds i8, i8* %tmp163, i32 %tmp162
	%tmp165 = load i8, i8* %tmp164
	%tmp166 = icmp eq i8 %tmp165, 34
	br i1 %tmp166, label %then55, label %endif55
then55:
	%tmp167 = load i1, i1* %v8
	br i1 %tmp167, label %then56, label %else56
then56:
	store i1 false, i1* %v8
	%tmp168 = load i32, i32* %v7
	%tmp169 = add i32 %tmp168, 1
	store i32 %tmp169, i32* %v7
	br label %loop_body53
else56:
	%tmp170 = load i32, i32* %v7
	%tmp171 = add i32 %tmp170, 1
	store i32 %tmp171, i32* %v7
	br label %loop_body53_exit
	br label %endif55
endif55:
	%tmp172 = load i32, i32* %v7
	%tmp173 = load i8*, i8** %data
	%tmp174 = getelementptr inbounds i8, i8* %tmp173, i32 %tmp172
	%tmp175 = load i8, i8* %tmp174
	%tmp176 = icmp eq i8 %tmp175, 92
	br i1 %tmp176, label %then57, label %endif57
then57:
	%tmp177 = load i1, i1* %v8
	%tmp178 = xor i1 1, %tmp177
	store i1 %tmp178, i1* %v8
	%tmp179 = load i32, i32* %v7
	%tmp180 = add i32 %tmp179, 1
	store i32 %tmp180, i32* %v7
	br label %loop_body53
endif57:
	%tmp181 = load i1, i1* %v8
	br i1 %tmp181, label %then58, label %endif58
then58:
	store i1 false, i1* %v8
	br label %endif58
endif58:
	%tmp182 = load i32, i32* %v7
	%tmp183 = add i32 %tmp182, 1
	store i32 %tmp183, i32* %v7
	br label %loop_body53
loop_body53:
	br label %loop_start53
loop_body53_exit:
	%tmp184 = load i8*, i8** %data
	%tmp185 = load i32, i32* %v0
	%tmp186 = load i32, i32* %v7
	call void @handle_string(i8* %tmp184, i32 %tmp185, i32 %tmp186, %"struct.vector.Vec<%struct.TokenData>"* %token_vector, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector)
	%tmp187 = load i32, i32* %v7
	store i32 %tmp187, i32* %v0
	br label %loop_body0
else52:
	%tmp188 = load i8, i8* %v1
	%tmp189 = icmp eq i8 %tmp188, 39
	br i1 %tmp189, label %then59, label %else59
then59:
	%tmp190 = load i32, i32* %v0
	%tmp191 = add i32 %tmp190, 1
	store i32 %tmp191, i32* %v9
	store i1 false, i1* %v10
	br label %loop_start60
loop_start60:
	%tmp192 = load i32, i32* %v9
	%tmp193 = getelementptr inbounds %struct.string.String, %struct.string.String* %data, i32 0, i32 1
	%tmp194 = load i32, i32* %tmp193
	%tmp195 = icmp ult i32 %tmp192, %tmp194
	br i1 %tmp195, label %endif61, label %else61
else61:
	br label %loop_body60_exit
endif61:
	%tmp196 = load i32, i32* %v9
	%tmp197 = load i8*, i8** %data
	%tmp198 = getelementptr inbounds i8, i8* %tmp197, i32 %tmp196
	%tmp199 = load i8, i8* %tmp198
	%tmp200 = icmp eq i8 %tmp199, 39
	br i1 %tmp200, label %then62, label %endif62
then62:
	%tmp201 = load i1, i1* %v10
	br i1 %tmp201, label %then63, label %else63
then63:
	store i1 false, i1* %v10
	%tmp202 = load i32, i32* %v9
	%tmp203 = add i32 %tmp202, 1
	store i32 %tmp203, i32* %v9
	br label %loop_body60
else63:
	%tmp204 = load i32, i32* %v9
	%tmp205 = add i32 %tmp204, 1
	store i32 %tmp205, i32* %v9
	br label %loop_body60_exit
	br label %endif62
endif62:
	%tmp206 = load i32, i32* %v9
	%tmp207 = load i8*, i8** %data
	%tmp208 = getelementptr inbounds i8, i8* %tmp207, i32 %tmp206
	%tmp209 = load i8, i8* %tmp208
	%tmp210 = icmp eq i8 %tmp209, 92
	br i1 %tmp210, label %then64, label %endif64
then64:
	%tmp211 = load i1, i1* %v10
	%tmp212 = xor i1 1, %tmp211
	store i1 %tmp212, i1* %v10
	%tmp213 = load i32, i32* %v9
	%tmp214 = add i32 %tmp213, 1
	store i32 %tmp214, i32* %v9
	br label %loop_body60
endif64:
	%tmp215 = load i1, i1* %v10
	br i1 %tmp215, label %then65, label %endif65
then65:
	store i1 false, i1* %v10
	br label %endif65
endif65:
	%tmp216 = load i32, i32* %v9
	%tmp217 = add i32 %tmp216, 1
	store i32 %tmp217, i32* %v9
	br label %loop_body60
loop_body60:
	br label %loop_start60
loop_body60_exit:
	%tmp218 = load i8*, i8** %data
	%tmp219 = load i32, i32* %v0
	%tmp220 = load i32, i32* %v9
	call void @handle_char(i8* %tmp218, i32 %tmp219, i32 %tmp220, %"struct.vector.Vec<%struct.TokenData>"* %token_vector, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector)
	%tmp221 = load i32, i32* %v9
	store i32 %tmp221, i32* %v0
	br label %loop_body0
else59:
	%tmp222 = load i8, i8* %v1
	%tmp223 = icmp eq i8 %tmp222, 47
	br i1 %tmp223, label %logic_rhs_66, label %logic_end_66
logic_rhs_66:
	%tmp224 = load i8, i8* %v2
	%tmp225 = icmp eq i8 %tmp224, 47
	br label %logic_end_66
logic_end_66:
	%tmp226 = phi i1 [%tmp223, %else59], [%tmp225, %logic_rhs_66]
	br i1 %tmp226, label %then67, label %else67
then67:
	%tmp227 = load i32, i32* %v0
	%tmp228 = add i32 %tmp227, 2
	store i32 %tmp228, i32* %v11
	br label %loop_start68
loop_start68:
	%tmp229 = load i32, i32* %v11
	%tmp230 = getelementptr inbounds %struct.string.String, %struct.string.String* %data, i32 0, i32 1
	%tmp231 = load i32, i32* %tmp230
	%tmp232 = icmp ult i32 %tmp229, %tmp231
	br i1 %tmp232, label %endif69, label %else69
else69:
	br label %loop_body68_exit
endif69:
	%tmp233 = load i32, i32* %v11
	%tmp234 = load i8*, i8** %data
	%tmp235 = getelementptr inbounds i8, i8* %tmp234, i32 %tmp233
	%tmp236 = load i8, i8* %tmp235
	%tmp237 = icmp eq i8 %tmp236, 10
	br i1 %tmp237, label %then70, label %endif70
then70:
	%tmp238 = load i32, i32* %v11
	%tmp239 = add i32 %tmp238, 1
	store i32 %tmp239, i32* %v11
	br label %loop_body68_exit
endif70:
	%tmp240 = load i32, i32* %v11
	%tmp241 = add i32 %tmp240, 1
	store i32 %tmp241, i32* %v11
	br label %loop_start68
loop_body68_exit:
	%tmp242 = load i32, i32* %v11
	%tmp243 = load i32, i32* %v0
	%tmp244 = sub i32 %tmp242, %tmp243
	store i32 %tmp244, i32* %v12
	%tmp245 = load i32, i32* %v11
	store i32 %tmp245, i32* %v0
	br label %loop_body0
else67:
	%tmp246 = load i8, i8* %v1
	%tmp247 = icmp eq i8 %tmp246, 47
	br i1 %tmp247, label %logic_rhs_71, label %logic_end_71
logic_rhs_71:
	%tmp248 = load i8, i8* %v2
	%tmp249 = icmp eq i8 %tmp248, 42
	br label %logic_end_71
logic_end_71:
	%tmp250 = phi i1 [%tmp247, %else67], [%tmp249, %logic_rhs_71]
	br i1 %tmp250, label %then72, label %endif72
then72:
	%tmp251 = load i32, i32* %v0
	%tmp252 = add i32 %tmp251, 2
	store i32 %tmp252, i32* %v13
	store i32 1, i32* %v14
	store i1 false, i1* %v15
	br label %loop_start73
loop_start73:
	%tmp253 = load i32, i32* %v13
	%tmp254 = getelementptr inbounds %struct.string.String, %struct.string.String* %data, i32 0, i32 1
	%tmp255 = load i32, i32* %tmp254
	%tmp256 = icmp ult i32 %tmp253, %tmp255
	br i1 %tmp256, label %endif74, label %else74
else74:
	br label %loop_body73_exit
endif74:
	%tmp257 = load i32, i32* %v13
	%tmp258 = add i32 %tmp257, 1
	%tmp259 = getelementptr inbounds %struct.string.String, %struct.string.String* %data, i32 0, i32 1
	%tmp260 = load i32, i32* %tmp259
	%tmp261 = icmp ult i32 %tmp258, %tmp260
	br i1 %tmp261, label %then75, label %endif75
then75:
	%tmp262 = load i32, i32* %v13
	%tmp263 = load i8*, i8** %data
	%tmp264 = getelementptr inbounds i8, i8* %tmp263, i32 %tmp262
	%tmp265 = load i8, i8* %tmp264
	%tmp266 = icmp eq i8 %tmp265, 47
	br i1 %tmp266, label %logic_rhs_76, label %logic_end_76
logic_rhs_76:
	%tmp267 = load i32, i32* %v13
	%tmp268 = add i32 %tmp267, 1
	%tmp269 = load i8*, i8** %data
	%tmp270 = getelementptr inbounds i8, i8* %tmp269, i32 %tmp268
	%tmp271 = load i8, i8* %tmp270
	%tmp272 = icmp eq i8 %tmp271, 42
	br label %logic_end_76
logic_end_76:
	%tmp273 = phi i1 [%tmp266, %then75], [%tmp272, %logic_rhs_76]
	br i1 %tmp273, label %then77, label %endif77
then77:
	%tmp274 = load i32, i32* %v14
	%tmp275 = add i32 %tmp274, 1
	store i32 %tmp275, i32* %v14
	%tmp276 = load i32, i32* %v13
	%tmp277 = add i32 %tmp276, 2
	store i32 %tmp277, i32* %v13
	br label %loop_body73
endif77:
	%tmp278 = load i32, i32* %v13
	%tmp279 = load i8*, i8** %data
	%tmp280 = getelementptr inbounds i8, i8* %tmp279, i32 %tmp278
	%tmp281 = load i8, i8* %tmp280
	%tmp282 = icmp eq i8 %tmp281, 42
	br i1 %tmp282, label %logic_rhs_78, label %logic_end_78
logic_rhs_78:
	%tmp283 = load i32, i32* %v13
	%tmp284 = add i32 %tmp283, 1
	%tmp285 = load i8*, i8** %data
	%tmp286 = getelementptr inbounds i8, i8* %tmp285, i32 %tmp284
	%tmp287 = load i8, i8* %tmp286
	%tmp288 = icmp eq i8 %tmp287, 47
	br label %logic_end_78
logic_end_78:
	%tmp289 = phi i1 [%tmp282, %endif77], [%tmp288, %logic_rhs_78]
	br i1 %tmp289, label %then79, label %endif79
then79:
	%tmp290 = load i32, i32* %v14
	%tmp291 = sub i32 %tmp290, 1
	store i32 %tmp291, i32* %v14
	%tmp292 = load i32, i32* %v13
	%tmp293 = add i32 %tmp292, 2
	store i32 %tmp293, i32* %v13
	%tmp294 = load i32, i32* %v14
	%tmp295 = icmp eq i32 %tmp294, 0
	br i1 %tmp295, label %then80, label %endif80
then80:
	br label %loop_body73_exit
endif80:
	br label %loop_body73
endif79:
	br label %endif75
endif75:
	%tmp296 = load i32, i32* %v13
	%tmp297 = add i32 %tmp296, 1
	store i32 %tmp297, i32* %v13
	br label %loop_body73
loop_body73:
	br label %loop_start73
loop_body73_exit:
	%tmp298 = load i32, i32* %v13
	%tmp299 = load i32, i32* %v0
	%tmp300 = sub i32 %tmp298, %tmp299
	store i32 %tmp300, i32* %v16
	%tmp301 = load i32, i32* %v13
	store i32 %tmp301, i32* %v0
	br label %loop_body0
endif72:
	store i8 70, i8* %v17
	%tmp302 = load i8, i8* %v1
	%tmp303 = icmp eq i8 %tmp302, 35
	br i1 %tmp303, label %then81, label %else81
then81:
	store i8 14, i8* %v17
	%tmp304 = load i32, i32* %v0
	%tmp305 = add i32 %tmp304, 1
	store i32 %tmp305, i32* %v0
	br label %endif81
else81:
	%tmp306 = load i8, i8* %v1
	%tmp307 = icmp eq i8 %tmp306, 40
	br i1 %tmp307, label %then82, label %else82
then82:
	store i8 0, i8* %v17
	%tmp308 = load i32, i32* %v0
	%tmp309 = add i32 %tmp308, 1
	store i32 %tmp309, i32* %v0
	br label %endif82
else82:
	%tmp310 = load i8, i8* %v1
	%tmp311 = icmp eq i8 %tmp310, 41
	br i1 %tmp311, label %then83, label %else83
then83:
	store i8 1, i8* %v17
	%tmp312 = load i32, i32* %v0
	%tmp313 = add i32 %tmp312, 1
	store i32 %tmp313, i32* %v0
	br label %endif83
else83:
	%tmp314 = load i8, i8* %v1
	%tmp315 = icmp eq i8 %tmp314, 123
	br i1 %tmp315, label %then84, label %else84
then84:
	store i8 2, i8* %v17
	%tmp316 = load i32, i32* %v0
	%tmp317 = add i32 %tmp316, 1
	store i32 %tmp317, i32* %v0
	br label %endif84
else84:
	%tmp318 = load i8, i8* %v1
	%tmp319 = icmp eq i8 %tmp318, 125
	br i1 %tmp319, label %then85, label %else85
then85:
	store i8 3, i8* %v17
	%tmp320 = load i32, i32* %v0
	%tmp321 = add i32 %tmp320, 1
	store i32 %tmp321, i32* %v0
	br label %endif85
else85:
	%tmp322 = load i8, i8* %v1
	%tmp323 = icmp eq i8 %tmp322, 91
	br i1 %tmp323, label %then86, label %else86
then86:
	store i8 4, i8* %v17
	%tmp324 = load i32, i32* %v0
	%tmp325 = add i32 %tmp324, 1
	store i32 %tmp325, i32* %v0
	br label %endif86
else86:
	%tmp326 = load i8, i8* %v1
	%tmp327 = icmp eq i8 %tmp326, 93
	br i1 %tmp327, label %then87, label %else87
then87:
	store i8 5, i8* %v17
	%tmp328 = load i32, i32* %v0
	%tmp329 = add i32 %tmp328, 1
	store i32 %tmp329, i32* %v0
	br label %endif87
else87:
	%tmp330 = load i8, i8* %v1
	%tmp331 = icmp eq i8 %tmp330, 58
	br i1 %tmp331, label %then88, label %else88
then88:
	%tmp332 = load i8, i8* %v2
	%tmp333 = icmp eq i8 %tmp332, 58
	br i1 %tmp333, label %then89, label %else89
then89:
	store i8 7, i8* %v17
	%tmp334 = load i32, i32* %v0
	%tmp335 = add i32 %tmp334, 2
	store i32 %tmp335, i32* %v0
	br label %endif89
else89:
	store i8 6, i8* %v17
	%tmp336 = load i32, i32* %v0
	%tmp337 = add i32 %tmp336, 1
	store i32 %tmp337, i32* %v0
	br label %endif89
endif89:
	br label %endif88
else88:
	%tmp338 = load i8, i8* %v1
	%tmp339 = icmp eq i8 %tmp338, 61
	br i1 %tmp339, label %then90, label %else90
then90:
	%tmp340 = load i8, i8* %v2
	%tmp341 = icmp eq i8 %tmp340, 61
	br i1 %tmp341, label %then91, label %else91
then91:
	store i8 22, i8* %v17
	%tmp342 = load i32, i32* %v0
	%tmp343 = add i32 %tmp342, 2
	store i32 %tmp343, i32* %v0
	br label %endif91
else91:
	%tmp344 = load i8, i8* %v2
	%tmp345 = icmp eq i8 %tmp344, 62
	br i1 %tmp345, label %then92, label %else92
then92:
	store i8 13, i8* %v17
	%tmp346 = load i32, i32* %v0
	%tmp347 = add i32 %tmp346, 2
	store i32 %tmp347, i32* %v0
	br label %endif92
else92:
	store i8 15, i8* %v17
	%tmp348 = load i32, i32* %v0
	%tmp349 = add i32 %tmp348, 1
	store i32 %tmp349, i32* %v0
	br label %endif92
endif92:
	br label %endif91
endif91:
	br label %endif90
else90:
	%tmp350 = load i8, i8* %v1
	%tmp351 = icmp eq i8 %tmp350, 59
	br i1 %tmp351, label %then93, label %else93
then93:
	store i8 8, i8* %v17
	%tmp352 = load i32, i32* %v0
	%tmp353 = add i32 %tmp352, 1
	store i32 %tmp353, i32* %v0
	br label %endif93
else93:
	%tmp354 = load i8, i8* %v1
	%tmp355 = icmp eq i8 %tmp354, 44
	br i1 %tmp355, label %then94, label %else94
then94:
	store i8 9, i8* %v17
	%tmp356 = load i32, i32* %v0
	%tmp357 = add i32 %tmp356, 1
	store i32 %tmp357, i32* %v0
	br label %endif94
else94:
	%tmp358 = load i8, i8* %v1
	%tmp359 = icmp eq i8 %tmp358, 43
	br i1 %tmp359, label %then95, label %else95
then95:
	store i8 16, i8* %v17
	%tmp360 = load i32, i32* %v0
	%tmp361 = add i32 %tmp360, 1
	store i32 %tmp361, i32* %v0
	br label %endif95
else95:
	%tmp362 = load i8, i8* %v1
	%tmp363 = icmp eq i8 %tmp362, 45
	br i1 %tmp363, label %then96, label %else96
then96:
	store i8 17, i8* %v17
	%tmp364 = load i32, i32* %v0
	%tmp365 = add i32 %tmp364, 1
	store i32 %tmp365, i32* %v0
	br label %endif96
else96:
	%tmp366 = load i8, i8* %v1
	%tmp367 = icmp eq i8 %tmp366, 42
	br i1 %tmp367, label %then97, label %else97
then97:
	store i8 18, i8* %v17
	%tmp368 = load i32, i32* %v0
	%tmp369 = add i32 %tmp368, 1
	store i32 %tmp369, i32* %v0
	br label %endif97
else97:
	%tmp370 = load i8, i8* %v1
	%tmp371 = icmp eq i8 %tmp370, 47
	br i1 %tmp371, label %then98, label %else98
then98:
	store i8 19, i8* %v17
	%tmp372 = load i32, i32* %v0
	%tmp373 = add i32 %tmp372, 1
	store i32 %tmp373, i32* %v0
	br label %endif98
else98:
	%tmp374 = load i8, i8* %v1
	%tmp375 = icmp eq i8 %tmp374, 37
	br i1 %tmp375, label %then99, label %else99
then99:
	store i8 20, i8* %v17
	%tmp376 = load i32, i32* %v0
	%tmp377 = add i32 %tmp376, 1
	store i32 %tmp377, i32* %v0
	br label %endif99
else99:
	%tmp378 = load i8, i8* %v1
	%tmp379 = icmp eq i8 %tmp378, 33
	br i1 %tmp379, label %then100, label %else100
then100:
	%tmp380 = load i8, i8* %v2
	%tmp381 = icmp eq i8 %tmp380, 61
	br i1 %tmp381, label %then101, label %else101
then101:
	store i8 23, i8* %v17
	%tmp382 = load i32, i32* %v0
	%tmp383 = add i32 %tmp382, 2
	store i32 %tmp383, i32* %v0
	br label %endif101
else101:
	store i8 21, i8* %v17
	%tmp384 = load i32, i32* %v0
	%tmp385 = add i32 %tmp384, 1
	store i32 %tmp385, i32* %v0
	br label %endif101
endif101:
	br label %endif100
else100:
	%tmp386 = load i8, i8* %v1
	%tmp387 = icmp eq i8 %tmp386, 38
	br i1 %tmp387, label %then102, label %else102
then102:
	%tmp388 = load i8, i8* %v2
	%tmp389 = icmp eq i8 %tmp388, 38
	br i1 %tmp389, label %then103, label %else103
then103:
	store i8 25, i8* %v17
	%tmp390 = load i32, i32* %v0
	%tmp391 = add i32 %tmp390, 2
	store i32 %tmp391, i32* %v0
	br label %endif103
else103:
	store i8 32, i8* %v17
	%tmp392 = load i32, i32* %v0
	%tmp393 = add i32 %tmp392, 1
	store i32 %tmp393, i32* %v0
	br label %endif103
endif103:
	br label %endif102
else102:
	%tmp394 = load i8, i8* %v1
	%tmp395 = icmp eq i8 %tmp394, 124
	br i1 %tmp395, label %then104, label %else104
then104:
	%tmp396 = load i8, i8* %v2
	%tmp397 = icmp eq i8 %tmp396, 124
	br i1 %tmp397, label %then105, label %else105
then105:
	store i8 24, i8* %v17
	%tmp398 = load i32, i32* %v0
	%tmp399 = add i32 %tmp398, 2
	store i32 %tmp399, i32* %v0
	br label %endif105
else105:
	store i8 31, i8* %v17
	%tmp400 = load i32, i32* %v0
	%tmp401 = add i32 %tmp400, 1
	store i32 %tmp401, i32* %v0
	br label %endif105
endif105:
	br label %endif104
else104:
	%tmp402 = load i8, i8* %v1
	%tmp403 = icmp eq i8 %tmp402, 46
	br i1 %tmp403, label %then106, label %else106
then106:
	%tmp404 = load i8, i8* %v2
	%tmp405 = icmp eq i8 %tmp404, 46
	br i1 %tmp405, label %then107, label %else107
then107:
	%tmp406 = load i8, i8* %v3
	%tmp407 = icmp eq i8 %tmp406, 61
	br i1 %tmp407, label %then108, label %else108
then108:
	store i8 12, i8* %v17
	%tmp408 = load i32, i32* %v0
	%tmp409 = add i32 %tmp408, 3
	store i32 %tmp409, i32* %v0
	br label %endif108
else108:
	store i8 11, i8* %v17
	%tmp410 = load i32, i32* %v0
	%tmp411 = add i32 %tmp410, 2
	store i32 %tmp411, i32* %v0
	br label %endif108
endif108:
	br label %endif107
else107:
	store i8 10, i8* %v17
	%tmp412 = load i32, i32* %v0
	%tmp413 = add i32 %tmp412, 1
	store i32 %tmp413, i32* %v0
	br label %endif107
endif107:
	br label %endif106
else106:
	%tmp414 = load i8, i8* %v1
	%tmp415 = icmp eq i8 %tmp414, 60
	br i1 %tmp415, label %then109, label %else109
then109:
	%tmp416 = load i8, i8* %v2
	%tmp417 = icmp eq i8 %tmp416, 61
	br i1 %tmp417, label %then110, label %else110
then110:
	store i8 29, i8* %v17
	%tmp418 = load i32, i32* %v0
	%tmp419 = add i32 %tmp418, 2
	store i32 %tmp419, i32* %v0
	br label %endif110
else110:
	store i8 28, i8* %v17
	%tmp420 = load i32, i32* %v0
	%tmp421 = add i32 %tmp420, 1
	store i32 %tmp421, i32* %v0
	br label %endif110
endif110:
	br label %endif109
else109:
	%tmp422 = load i8, i8* %v1
	%tmp423 = icmp eq i8 %tmp422, 62
	br i1 %tmp423, label %then111, label %else111
then111:
	%tmp424 = load i8, i8* %v2
	%tmp425 = icmp eq i8 %tmp424, 61
	br i1 %tmp425, label %then112, label %else112
then112:
	store i8 27, i8* %v17
	%tmp426 = load i32, i32* %v0
	%tmp427 = add i32 %tmp426, 2
	store i32 %tmp427, i32* %v0
	br label %endif112
else112:
	store i8 26, i8* %v17
	%tmp428 = load i32, i32* %v0
	%tmp429 = add i32 %tmp428, 1
	store i32 %tmp429, i32* %v0
	br label %endif112
endif112:
	br label %endif111
else111:
	%tmp430 = load i8, i8* %v1
	%tmp431 = icmp eq i8 %tmp430, 94
	br i1 %tmp431, label %then113, label %else113
then113:
	store i8 33, i8* %v17
	%tmp432 = load i32, i32* %v0
	%tmp433 = add i32 %tmp432, 1
	store i32 %tmp433, i32* %v0
	br label %endif113
else113:
	%tmp434 = load i8, i8* %v1
	%tmp435 = icmp eq i8 %tmp434, 126
	br i1 %tmp435, label %then114, label %endif114
then114:
	store i8 30, i8* %v17
	%tmp436 = load i32, i32* %v0
	%tmp437 = add i32 %tmp436, 1
	store i32 %tmp437, i32* %v0
	br label %endif114
endif114:
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
	%tmp438 = load i8, i8* %v17
	%tmp439 = icmp ne i8 %tmp438, 70
	br i1 %tmp439, label %then115, label %endif115
then115:
	%tmp440 = load i8, i8* %v17
	%tmp441 = load i32, i32* %v0
	store i8 %tmp440, i8* %v18
	%tmp442 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v18, i32 0, i32 1
	store i16 0, i16* %tmp442
	%tmp443 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v18, i32 0, i32 2
	store i32 %tmp441, i32* %tmp443
	%tmp444 = load %struct.TokenData, %struct.TokenData* %v18
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %token_vector, %struct.TokenData %tmp444)
	br label %loop_body0
; Variable temp is out.
endif115:
	call void @console.write(i8* @.str.37, i32 8)
	%tmp445 = load i32, i32* %v0
	%tmp446 = zext i32 %tmp445 to i64
	call void @console.println_i64(i64 %tmp446)
	%tmp447 = load i32, i32* %v0
	%tmp448 = load i8*, i8** %data
	%tmp449 = getelementptr inbounds i8, i8* %tmp448, i32 %tmp447
	%tmp450 = load i8, i8* %tmp449
	%tmp451 = sext i8 %tmp450 to i64
	call void @console.println_i64(i64 %tmp451)
	call void @process.throw(i8* @.str.38)
	br label %loop_body0
loop_body0:
	br label %loop_start0
loop_body0_exit:
	ret void
}
define void @compile(%"struct.vector.Vec<%struct.Stmt>"* %statement_vector, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout){
	%v0 = alloca i32
	%v1 = alloca i32
	%v2 = alloca %struct.Stmt
	%v3 = alloca i32
	%v4 = alloca i32
	%v5 = alloca i32
	%v6 = alloca i32
	%v7 = alloca i32
	%v8 = alloca i32
	store i32 0, i32* %v0
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %statement_vector, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	store i32 %tmp1, i32* %v1
	%tmp2 = load %struct.string.String*, %struct.string.String** %symbol_vector
	br label %loop_start0
loop_start0:
	%tmp3 = load i32, i32* %v0
	%tmp4 = load i32, i32* %v1
	%tmp5 = icmp ult i32 %tmp3, %tmp4
	br i1 %tmp5, label %endif1, label %else1
else1:
	br label %loop_body0_exit
endif1:
	%tmp6 = load i32, i32* %v0
	%tmp7 = load %struct.Stmt*, %struct.Stmt** %statement_vector
	%tmp8 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp7, i32 %tmp6
	%tmp9 = load %struct.Stmt, %struct.Stmt* %tmp8
	store %struct.Stmt %tmp9, %struct.Stmt* %v2
	%tmp10 = load i8, i8* %v2
	%tmp11 = icmp eq i8 %tmp10, 0
	br i1 %tmp11, label %then2, label %else2
then2:
	%tmp12 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %v2, i32 0, i32 1
	%tmp13 = load i8*, i8** %tmp12
	call void @string.append(%struct.string.String* %stdout, i8 35)
	%tmp14 = load i16, i16* %tmp13
	%tmp15 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp2, i16 %tmp14
	%tmp16 = load i8*, i8** %tmp15
	%tmp17 = load i16, i16* %tmp13
	%tmp18 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp2, i16 %tmp17
	%tmp19 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp18, i32 0, i32 1
	%tmp20 = load i32, i32* %tmp19
	call void @string.append_str(%struct.string.String* %stdout, i8* %tmp16, i32 %tmp20)
	call void @string.append(%struct.string.String* %stdout, i8 40)
	%tmp21 = getelementptr inbounds %struct.HintNode, %struct.HintNode* %tmp13, i32 0, i32 1
	%tmp22 = getelementptr inbounds %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Expression>"* %tmp21, i32 0, i32 1
	%tmp23 = load i32, i32* %tmp22
	store i32 0, i32* %v3
	br label %loop_cond3
loop_cond3:
	%tmp24 = load i32, i32* %v3
	%tmp25 = getelementptr inbounds %struct.HintNode, %struct.HintNode* %tmp13, i32 0, i32 1
	%tmp26 = getelementptr inbounds %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Expression>"* %tmp25, i32 0, i32 1
	%tmp27 = load i32, i32* %tmp26
	%tmp28 = icmp uge i32 %tmp24, %tmp27
	br i1 %tmp28, label %then4, label %endif4
then4:
	br label %loop_body3_exit
endif4:
	%tmp30 = load i32, i32* %v3
	%tmp31 = getelementptr inbounds %struct.HintNode, %struct.HintNode* %tmp13, i32 0, i32 1
	%tmp32 = load %struct.Expression*, %struct.Expression** %tmp31
	%tmp33 = getelementptr inbounds %struct.Expression, %struct.Expression* %tmp32, i32 %tmp30
	call void @debug_dump_expression(%struct.Expression* %tmp33, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	%tmp34 = load i32, i32* %v3
	%tmp35 = getelementptr inbounds %struct.HintNode, %struct.HintNode* %tmp13, i32 0, i32 1
	%tmp36 = getelementptr inbounds %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Expression>"* %tmp35, i32 0, i32 1
	%tmp37 = load i32, i32* %tmp36
	%tmp38 = sub i32 %tmp37, 1
	%tmp39 = icmp ne i32 %tmp34, %tmp38
	br i1 %tmp39, label %then5, label %endif5
then5:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.39, i32 2)
	br label %endif5
endif5:
	%tmp40 = load i32, i32* %v3
	%tmp41 = add i32 %tmp40, 1
	store i32 %tmp41, i32* %v3
	br label %loop_cond3
loop_body3_exit:
	call void @string.append(%struct.string.String* %stdout, i8 41)
	call void @string.append(%struct.string.String* %stdout, i8 10)
	%tmp42 = load i32, i32* %v0
	%tmp43 = add i32 %tmp42, 1
	store i32 %tmp43, i32* %v0
	br label %loop_body0
else2:
	%tmp44 = load i8, i8* %v2
	%tmp45 = icmp eq i8 %tmp44, 20
	br i1 %tmp45, label %then6, label %else6
then6:
	%tmp46 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %v2, i32 0, i32 1
	%tmp47 = load i8*, i8** %tmp46
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.40, i32 2)
	%tmp48 = load i16, i16* %tmp47
	%tmp49 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp2, i16 %tmp48
	%tmp50 = load i8*, i8** %tmp49
	%tmp51 = load i16, i16* %tmp47
	%tmp52 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp2, i16 %tmp51
	%tmp53 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp52, i32 0, i32 1
	%tmp54 = load i32, i32* %tmp53
	call void @string.append_str(%struct.string.String* %stdout, i8* %tmp50, i32 %tmp54)
	call void @string.append(%struct.string.String* %stdout, i8 40)
	%tmp55 = getelementptr inbounds %struct.HintNode, %struct.HintNode* %tmp47, i32 0, i32 1
	%tmp56 = getelementptr inbounds %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Expression>"* %tmp55, i32 0, i32 1
	%tmp57 = load i32, i32* %tmp56
	store i32 0, i32* %v4
	br label %loop_cond7
loop_cond7:
	%tmp58 = load i32, i32* %v4
	%tmp59 = getelementptr inbounds %struct.HintNode, %struct.HintNode* %tmp47, i32 0, i32 1
	%tmp60 = getelementptr inbounds %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Expression>"* %tmp59, i32 0, i32 1
	%tmp61 = load i32, i32* %tmp60
	%tmp62 = icmp uge i32 %tmp58, %tmp61
	br i1 %tmp62, label %then8, label %endif8
then8:
	br label %loop_body7_exit
endif8:
	%tmp64 = load i32, i32* %v4
	%tmp65 = getelementptr inbounds %struct.HintNode, %struct.HintNode* %tmp47, i32 0, i32 1
	%tmp66 = load %struct.Expression*, %struct.Expression** %tmp65
	%tmp67 = getelementptr inbounds %struct.Expression, %struct.Expression* %tmp66, i32 %tmp64
	call void @debug_dump_expression(%struct.Expression* %tmp67, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	%tmp68 = load i32, i32* %v4
	%tmp69 = getelementptr inbounds %struct.HintNode, %struct.HintNode* %tmp47, i32 0, i32 1
	%tmp70 = getelementptr inbounds %"struct.vector.Vec<%struct.Expression>", %"struct.vector.Vec<%struct.Expression>"* %tmp69, i32 0, i32 1
	%tmp71 = load i32, i32* %tmp70
	%tmp72 = sub i32 %tmp71, 1
	%tmp73 = icmp ne i32 %tmp68, %tmp72
	br i1 %tmp73, label %then9, label %endif9
then9:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.39, i32 2)
	br label %endif9
endif9:
	%tmp74 = load i32, i32* %v4
	%tmp75 = add i32 %tmp74, 1
	store i32 %tmp75, i32* %v4
	br label %loop_cond7
loop_body7_exit:
	call void @string.append(%struct.string.String* %stdout, i8 41)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.41, i32 2)
	%tmp76 = load i32, i32* %v0
	%tmp77 = add i32 %tmp76, 1
	store i32 %tmp77, i32* %v0
	br label %loop_body0
else6:
	%tmp78 = load i8, i8* %v2
	%tmp79 = icmp eq i8 %tmp78, 11
	br i1 %tmp79, label %then10, label %else10
then10:
	%tmp80 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %v2, i32 0, i32 1
	%tmp81 = load i8*, i8** %tmp80
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.42, i32 3)
	%tmp82 = load i16, i16* %tmp81
	%tmp83 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp2, i16 %tmp82
	%tmp84 = load i8*, i8** %tmp83
	%tmp85 = load i16, i16* %tmp81
	%tmp86 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp2, i16 %tmp85
	%tmp87 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp86, i32 0, i32 1
	%tmp88 = load i32, i32* %tmp87
	call void @string.append_str(%struct.string.String* %stdout, i8* %tmp84, i32 %tmp88)
	call void @string.append(%struct.string.String* %stdout, i8 40)
	%tmp89 = getelementptr inbounds %struct.FnNode, %struct.FnNode* %tmp81, i32 0, i32 1
	%tmp90 = getelementptr inbounds %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %tmp89, i32 0, i32 1
	%tmp91 = load i32, i32* %tmp90
	store i32 0, i32* %v5
	br label %loop_cond11
loop_cond11:
	%tmp92 = load i32, i32* %v5
	%tmp93 = getelementptr inbounds %struct.FnNode, %struct.FnNode* %tmp81, i32 0, i32 1
	%tmp94 = getelementptr inbounds %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %tmp93, i32 0, i32 1
	%tmp95 = load i32, i32* %tmp94
	%tmp96 = icmp uge i32 %tmp92, %tmp95
	br i1 %tmp96, label %then12, label %endif12
then12:
	br label %loop_body11_exit
endif12:
	%tmp98 = load i32, i32* %v5
	%tmp99 = getelementptr inbounds %struct.FnNode, %struct.FnNode* %tmp81, i32 0, i32 1
	%tmp100 = load %struct.Argument*, %struct.Argument** %tmp99
	%tmp101 = getelementptr inbounds %struct.Argument, %struct.Argument* %tmp100, i32 %tmp98
	%tmp102 = load i16, i16* %tmp101
	%tmp103 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp2, i16 %tmp102
	%tmp104 = load i8*, i8** %tmp103
	%tmp105 = load i16, i16* %tmp101
	%tmp106 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp2, i16 %tmp105
	%tmp107 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp106, i32 0, i32 1
	%tmp108 = load i32, i32* %tmp107
	call void @string.append_str(%struct.string.String* %stdout, i8* %tmp104, i32 %tmp108)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.43, i32 2)
	%tmp109 = getelementptr inbounds %struct.Argument, %struct.Argument* %tmp101, i32 0, i32 1
	call void @debug_dump_type(%struct.Type* %tmp109, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	%tmp110 = load i32, i32* %v5
	%tmp111 = getelementptr inbounds %struct.FnNode, %struct.FnNode* %tmp81, i32 0, i32 1
	%tmp112 = getelementptr inbounds %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %tmp111, i32 0, i32 1
	%tmp113 = load i32, i32* %tmp112
	%tmp114 = sub i32 %tmp113, 1
	%tmp115 = icmp ne i32 %tmp110, %tmp114
	br i1 %tmp115, label %then13, label %endif13
then13:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.39, i32 2)
	br label %endif13
endif13:
	%tmp116 = load i32, i32* %v5
	%tmp117 = add i32 %tmp116, 1
	store i32 %tmp117, i32* %v5
	br label %loop_cond11
loop_body11_exit:
	call void @string.append(%struct.string.String* %stdout, i8 41)
	%tmp118 = getelementptr inbounds %struct.FnNode, %struct.FnNode* %tmp81, i32 0, i32 4
	%tmp119 = getelementptr inbounds %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %tmp118, i32 0, i32 1
	%tmp120 = load i32, i32* %tmp119
	%tmp121 = icmp ne i32 %tmp120, 0
	br i1 %tmp121, label %then14, label %endif14
then14:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.44, i32 2)
	%tmp122 = getelementptr inbounds %struct.FnNode, %struct.FnNode* %tmp81, i32 0, i32 4
	call void @compile_body(%"struct.vector.Vec<%struct.Stmt>"* %tmp122, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	call void @string.append(%struct.string.String* %stdout, i8 125)
	br label %endif14
endif14:
	call void @string.append(%struct.string.String* %stdout, i8 10)
	%tmp123 = load i32, i32* %v0
	%tmp124 = add i32 %tmp123, 1
	store i32 %tmp124, i32* %v0
	br label %loop_body0
else10:
	%tmp125 = load i8, i8* %v2
	%tmp126 = icmp eq i8 %tmp125, 12
	br i1 %tmp126, label %then15, label %else15
then15:
	%tmp127 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %v2, i32 0, i32 1
	%tmp128 = load i8*, i8** %tmp127
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.45, i32 7)
	%tmp129 = load i16, i16* %tmp128
	%tmp130 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp2, i16 %tmp129
	%tmp131 = load i8*, i8** %tmp130
	%tmp132 = load i16, i16* %tmp128
	%tmp133 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp2, i16 %tmp132
	%tmp134 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp133, i32 0, i32 1
	%tmp135 = load i32, i32* %tmp134
	call void @string.append_str(%struct.string.String* %stdout, i8* %tmp131, i32 %tmp135)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.44, i32 2)
	%tmp136 = getelementptr inbounds %struct.StructNode, %struct.StructNode* %tmp128, i32 0, i32 1
	%tmp137 = getelementptr inbounds %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %tmp136, i32 0, i32 1
	%tmp138 = load i32, i32* %tmp137
	store i32 0, i32* %v6
	br label %loop_cond16
loop_cond16:
	%tmp139 = load i32, i32* %v6
	%tmp140 = getelementptr inbounds %struct.StructNode, %struct.StructNode* %tmp128, i32 0, i32 1
	%tmp141 = getelementptr inbounds %"struct.vector.Vec<%struct.Argument>", %"struct.vector.Vec<%struct.Argument>"* %tmp140, i32 0, i32 1
	%tmp142 = load i32, i32* %tmp141
	%tmp143 = icmp uge i32 %tmp139, %tmp142
	br i1 %tmp143, label %then17, label %endif17
then17:
	br label %loop_body16_exit
endif17:
	%tmp145 = load i32, i32* %v6
	%tmp146 = getelementptr inbounds %struct.StructNode, %struct.StructNode* %tmp128, i32 0, i32 1
	%tmp147 = load %struct.Argument*, %struct.Argument** %tmp146
	%tmp148 = getelementptr inbounds %struct.Argument, %struct.Argument* %tmp147, i32 %tmp145
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.7, i32 1)
	%tmp149 = load i16, i16* %tmp148
	%tmp150 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp2, i16 %tmp149
	%tmp151 = load i8*, i8** %tmp150
	%tmp152 = load i16, i16* %tmp148
	%tmp153 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp2, i16 %tmp152
	%tmp154 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp153, i32 0, i32 1
	%tmp155 = load i32, i32* %tmp154
	call void @string.append_str(%struct.string.String* %stdout, i8* %tmp151, i32 %tmp155)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.43, i32 2)
	%tmp156 = getelementptr inbounds %struct.Argument, %struct.Argument* %tmp148, i32 0, i32 1
	call void @debug_dump_type(%struct.Type* %tmp156, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	call void @string.append(%struct.string.String* %stdout, i8 10)
	%tmp157 = load i32, i32* %v6
	%tmp158 = add i32 %tmp157, 1
	store i32 %tmp158, i32* %v6
	br label %loop_cond16
loop_body16_exit:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.46, i32 2)
	%tmp159 = load i32, i32* %v0
	%tmp160 = add i32 %tmp159, 1
	store i32 %tmp160, i32* %v0
	br label %loop_body0
else15:
	%tmp161 = load i8, i8* %v2
	%tmp162 = icmp eq i8 %tmp161, 13
	br i1 %tmp162, label %then18, label %else18
then18:
	%tmp163 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %v2, i32 0, i32 1
	%tmp164 = load i8*, i8** %tmp163
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.47, i32 5)
	%tmp165 = load i16, i16* %tmp164
	%tmp166 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp2, i16 %tmp165
	%tmp167 = load i8*, i8** %tmp166
	%tmp168 = load i16, i16* %tmp164
	%tmp169 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp2, i16 %tmp168
	%tmp170 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp169, i32 0, i32 1
	%tmp171 = load i32, i32* %tmp170
	call void @string.append_str(%struct.string.String* %stdout, i8* %tmp167, i32 %tmp171)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.44, i32 2)
	%tmp172 = getelementptr inbounds %struct.EnumNode, %struct.EnumNode* %tmp164, i32 0, i32 2
	%tmp173 = getelementptr inbounds %"struct.vector.Vec<%struct.EnumField>", %"struct.vector.Vec<%struct.EnumField>"* %tmp172, i32 0, i32 1
	%tmp174 = load i32, i32* %tmp173
	store i32 0, i32* %v7
	br label %loop_cond19
loop_cond19:
	%tmp175 = load i32, i32* %v7
	%tmp176 = getelementptr inbounds %struct.EnumNode, %struct.EnumNode* %tmp164, i32 0, i32 2
	%tmp177 = getelementptr inbounds %"struct.vector.Vec<%struct.EnumField>", %"struct.vector.Vec<%struct.EnumField>"* %tmp176, i32 0, i32 1
	%tmp178 = load i32, i32* %tmp177
	%tmp179 = icmp uge i32 %tmp175, %tmp178
	br i1 %tmp179, label %then20, label %endif20
then20:
	br label %loop_body19_exit
endif20:
	%tmp181 = load i32, i32* %v7
	%tmp182 = getelementptr inbounds %struct.EnumNode, %struct.EnumNode* %tmp164, i32 0, i32 2
	%tmp183 = load %struct.EnumField*, %struct.EnumField** %tmp182
	%tmp184 = getelementptr inbounds %struct.EnumField, %struct.EnumField* %tmp183, i32 %tmp181
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.7, i32 1)
	%tmp185 = load i16, i16* %tmp184
	%tmp186 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp2, i16 %tmp185
	%tmp187 = load i8*, i8** %tmp186
	%tmp188 = load i16, i16* %tmp184
	%tmp189 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp2, i16 %tmp188
	%tmp190 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp189, i32 0, i32 1
	%tmp191 = load i32, i32* %tmp190
	call void @string.append_str(%struct.string.String* %stdout, i8* %tmp187, i32 %tmp191)
	%tmp192 = getelementptr inbounds %struct.EnumField, %struct.EnumField* %tmp184, i32 0, i32 1
	%tmp193 = load i1, i1* %tmp192
	br i1 %tmp193, label %then21, label %endif21
then21:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.43, i32 2)
	br label %endif21
endif21:
	call void @string.append(%struct.string.String* %stdout, i8 10)
	%tmp194 = load i32, i32* %v7
	%tmp195 = add i32 %tmp194, 1
	store i32 %tmp195, i32* %v7
	br label %loop_cond19
loop_body19_exit:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.46, i32 2)
	%tmp196 = load i32, i32* %v0
	%tmp197 = add i32 %tmp196, 1
	store i32 %tmp197, i32* %v0
	br label %loop_body0
else18:
	%tmp198 = load i8, i8* %v2
	%tmp199 = icmp eq i8 %tmp198, 14
	br i1 %tmp199, label %then22, label %else22
then22:
	%tmp200 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %v2, i32 0, i32 1
	%tmp201 = load i8*, i8** %tmp200
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.48, i32 10)
	%tmp202 = load i16, i16* %tmp201
	%tmp203 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp2, i16 %tmp202
	%tmp204 = load i8*, i8** %tmp203
	%tmp205 = load i16, i16* %tmp201
	%tmp206 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp2, i16 %tmp205
	%tmp207 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp206, i32 0, i32 1
	%tmp208 = load i32, i32* %tmp207
	call void @string.append_str(%struct.string.String* %stdout, i8* %tmp204, i32 %tmp208)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.44, i32 2)
	%tmp209 = getelementptr inbounds %struct.NamespaceNode, %struct.NamespaceNode* %tmp201, i32 0, i32 1
	call void @compile(%"struct.vector.Vec<%struct.Stmt>"* %tmp209, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.46, i32 2)
	%tmp210 = load i32, i32* %v0
	%tmp211 = add i32 %tmp210, 1
	store i32 %tmp211, i32* %v0
	br label %loop_body0
else22:
	%tmp212 = load i8, i8* %v2
	%tmp213 = icmp eq i8 %tmp212, 1
	br i1 %tmp213, label %then23, label %else23
then23:
	%tmp214 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %v2, i32 0, i32 1
	%tmp215 = load i8*, i8** %tmp214
	%tmp216 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp215, i32 0, i32 4
	%tmp217 = load i8, i8* %tmp216
	%tmp218 = icmp eq i8 %tmp217, 2
	br i1 %tmp218, label %then24, label %else24
then24:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.49, i32 7)
	br label %endif24
else24:
	%tmp219 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp215, i32 0, i32 4
	%tmp220 = load i8, i8* %tmp219
	%tmp221 = icmp eq i8 %tmp220, 1
	br i1 %tmp221, label %then25, label %else25
then25:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.50, i32 8)
	br label %endif25
else25:
	%tmp222 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp215, i32 0, i32 4
	%tmp223 = load i8, i8* %tmp222
	%tmp224 = icmp eq i8 %tmp223, 0
	br i1 %tmp224, label %then26, label %endif26
then26:
	call void @process.throw(i8* @.str.51)
	br label %endif26
endif26:
	br label %endif25
endif25:
	br label %endif24
endif24:
	%tmp225 = load i16, i16* %tmp215
	%tmp226 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp2, i16 %tmp225
	%tmp227 = load i8*, i8** %tmp226
	%tmp228 = load i16, i16* %tmp215
	%tmp229 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp2, i16 %tmp228
	%tmp230 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp229, i32 0, i32 1
	%tmp231 = load i32, i32* %tmp230
	call void @string.append_str(%struct.string.String* %stdout, i8* %tmp227, i32 %tmp231)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.52, i32 3)
	%tmp232 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp215, i32 0, i32 3
	call void @debug_dump_type(%struct.Type* %tmp232, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	%tmp233 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp215, i32 0, i32 1
	%tmp234 = load i1, i1* %tmp233
	br i1 %tmp234, label %then27, label %endif27
then27:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.53, i32 3)
	%tmp235 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp215, i32 0, i32 2
	call void @debug_dump_expression(%struct.Expression* %tmp235, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	br label %endif27
endif27:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.8, i32 2)
	%tmp236 = load i32, i32* %v0
	%tmp237 = add i32 %tmp236, 1
	store i32 %tmp237, i32* %v0
	br label %loop_body0
else23:
	store i32 0, i32* %v8
	br label %loop_cond28
loop_cond28:
	%tmp238 = load i32, i32* %v8
	%tmp239 = icmp uge i32 %tmp238, 3
	br i1 %tmp239, label %then29, label %endif29
then29:
	br label %loop_body28_exit
endif29:
	%tmp240 = load i32, i32* %v0
	%tmp241 = load i32, i32* %v8
	%tmp242 = add i32 %tmp240, %tmp241
	%tmp243 = load %struct.Stmt*, %struct.Stmt** %statement_vector
	%tmp244 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp243, i32 %tmp242
	%tmp245 = load i8, i8* %tmp244
	%tmp246 = zext i8 %tmp245 to i64
	call void @console.println_i64(i64 %tmp246)
	call void @console.write(i8* @.str.35, i32 6)
	%tmp247 = load i32, i32* %v8
	%tmp248 = add i32 %tmp247, 1
	store i32 %tmp248, i32* %v8
	br label %loop_cond28
loop_body28_exit:
	call void @process.throw(i8* @.str.54)
	br label %loop_body0
loop_body0:
	br label %loop_start0
loop_body0_exit:
; Variable statement is out.
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
define void @string.append_str(%struct.string.String* %src_string, i8* %c_string, i32 %c_string_len){
	%tmp0 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = add i32 %c_string_len, %tmp1
	%tmp3 = add i32 %tmp2, 1
	%tmp4 = sext i32 %tmp3 to i64
	%tmp5 = mul i64 1, %tmp4
	%tmp6 = call i8* @mem.malloc(i64 %tmp5)
	%tmp7 = load i8*, i8** %src_string
	%tmp8 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 1
	%tmp9 = load i32, i32* %tmp8
	%tmp10 = sext i32 %tmp9 to i64
	call void @mem.copy(i8* %tmp7, i8* %tmp6, i64 %tmp10)
	%tmp11 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 1
	%tmp12 = load i32, i32* %tmp11
	%tmp13 = sext i32 %tmp12 to i64
	%tmp14 = getelementptr inbounds i8, i8* %tmp6, i64 %tmp13
	%tmp15 = sext i32 %c_string_len to i64
	call void @mem.copy(i8* %c_string, i8* %tmp14, i64 %tmp15)
	%tmp16 = getelementptr inbounds i8, i8* %tmp6, i32 %tmp2
	store i8 0, i8* %tmp16
	%tmp17 = load i8*, i8** %src_string
	call void @mem.free(i8* %tmp17)
	store i8* %tmp6, i8** %src_string
	%tmp18 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 1
	store i32 %tmp2, i32* %tmp18
	ret void
}
define void @string.append(%struct.string.String* %src_string, i8 %ch){
	%tmp0 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = add i32 %tmp1, 1
	%tmp3 = add i32 %tmp2, 1
	%tmp4 = sext i32 %tmp3 to i64
	%tmp5 = mul i64 1, %tmp4
	%tmp6 = call i8* @mem.malloc(i64 %tmp5)
	%tmp7 = load i8*, i8** %src_string
	%tmp8 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 1
	%tmp9 = load i32, i32* %tmp8
	%tmp10 = sext i32 %tmp9 to i64
	call void @mem.copy(i8* %tmp7, i8* %tmp6, i64 %tmp10)
	%tmp11 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 1
	%tmp12 = load i32, i32* %tmp11
	%tmp13 = sext i32 %tmp12 to i64
	%tmp14 = getelementptr inbounds i8, i8* %tmp6, i64 %tmp13
	store i8 %ch, i8* %tmp14
	%tmp15 = getelementptr inbounds i8, i8* %tmp6, i32 %tmp2
	store i8 0, i8* %tmp15
	%tmp16 = load i8*, i8** %src_string
	call void @mem.free(i8* %tmp16)
	store i8* %tmp6, i8** %src_string
	%tmp17 = getelementptr inbounds %struct.string.String, %struct.string.String* %src_string, i32 0, i32 1
	store i32 %tmp2, i32* %tmp17
	ret void
}
define i8* @mem.malloc(i64 %size){
	%tmp0 = call i32* @GetProcessHeap()
	%tmp1 = call i8* @HeapAlloc(i32* %tmp0, i32 0, i64 %size)
	%tmp2 = icmp eq i8* %tmp1, null
	br i1 %tmp2, label %then0, label %endif0
then0:
	call void @process.throw(i8* @.str.55)
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
	call void @process.throw(i8* @.str.56)
	br label %endif0
endif0:
	%tmp4 = load i8*, i8** %v0
	ret i8* %tmp4
}
define %struct.string.String @token_type_to_string(%struct.TokenData* %val, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector){
	%tmp0 = icmp ne %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, null
	br i1 %tmp0, label %then0, label %else0
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
	%tmp31 = call %struct.string.String @string.from_c_string(i8* @.str.57)
	br label %func_exit
endif5:
	br label %endif0
else0:
	%tmp32 = load i8, i8* %val
	%tmp33 = icmp eq i8 %tmp32, 65
	br i1 %tmp33, label %then6, label %else6
then6:
	%tmp34 = call %struct.string.String @string.from_c_string(i8* @.str.58)
	br label %func_exit
else6:
	%tmp35 = load i8, i8* %val
	%tmp36 = icmp eq i8 %tmp35, 68
	br i1 %tmp36, label %then7, label %else7
then7:
	%tmp37 = call %struct.string.String @string.from_c_string(i8* @.str.59)
	br label %func_exit
else7:
	%tmp38 = load i8, i8* %val
	%tmp39 = icmp eq i8 %tmp38, 66
	br i1 %tmp39, label %then8, label %else8
then8:
	%tmp40 = call %struct.string.String @string.from_c_string(i8* @.str.60)
	br label %func_exit
else8:
	%tmp41 = load i8, i8* %val
	%tmp42 = icmp eq i8 %tmp41, 67
	br i1 %tmp42, label %then9, label %else9
then9:
	%tmp43 = call %struct.string.String @string.from_c_string(i8* @.str.61)
	br label %func_exit
else9:
	%tmp44 = load i8, i8* %val
	%tmp45 = icmp eq i8 %tmp44, 69
	br i1 %tmp45, label %then10, label %endif10
then10:
	%tmp46 = call %struct.string.String @string.from_c_string(i8* @.str.57)
	br label %func_exit
endif10:
	br label %endif0
endif0:
	%tmp47 = load i8, i8* %val
	%tmp48 = icmp eq i8 %tmp47, 0
	br i1 %tmp48, label %then11, label %else11
then11:
	%tmp49 = call %struct.string.String @string.from_c_string(i8* @.str.62)
	br label %func_exit
else11:
	%tmp50 = load i8, i8* %val
	%tmp51 = icmp eq i8 %tmp50, 1
	br i1 %tmp51, label %then12, label %else12
then12:
	%tmp52 = call %struct.string.String @string.from_c_string(i8* @.str.63)
	br label %func_exit
else12:
	%tmp53 = load i8, i8* %val
	%tmp54 = icmp eq i8 %tmp53, 2
	br i1 %tmp54, label %then13, label %else13
then13:
	%tmp55 = call %struct.string.String @string.from_c_string(i8* @.str.64)
	br label %func_exit
else13:
	%tmp56 = load i8, i8* %val
	%tmp57 = icmp eq i8 %tmp56, 3
	br i1 %tmp57, label %then14, label %else14
then14:
	%tmp58 = call %struct.string.String @string.from_c_string(i8* @.str.65)
	br label %func_exit
else14:
	%tmp59 = load i8, i8* %val
	%tmp60 = icmp eq i8 %tmp59, 4
	br i1 %tmp60, label %then15, label %else15
then15:
	%tmp61 = call %struct.string.String @string.from_c_string(i8* @.str.66)
	br label %func_exit
else15:
	%tmp62 = load i8, i8* %val
	%tmp63 = icmp eq i8 %tmp62, 5
	br i1 %tmp63, label %then16, label %else16
then16:
	%tmp64 = call %struct.string.String @string.from_c_string(i8* @.str.67)
	br label %func_exit
else16:
	%tmp65 = load i8, i8* %val
	%tmp66 = icmp eq i8 %tmp65, 6
	br i1 %tmp66, label %then17, label %else17
then17:
	%tmp67 = call %struct.string.String @string.from_c_string(i8* @.str.68)
	br label %func_exit
else17:
	%tmp68 = load i8, i8* %val
	%tmp69 = icmp eq i8 %tmp68, 7
	br i1 %tmp69, label %then18, label %else18
then18:
	%tmp70 = call %struct.string.String @string.from_c_string(i8* @.str.69)
	br label %func_exit
else18:
	%tmp71 = load i8, i8* %val
	%tmp72 = icmp eq i8 %tmp71, 8
	br i1 %tmp72, label %then19, label %else19
then19:
	%tmp73 = call %struct.string.String @string.from_c_string(i8* @.str.70)
	br label %func_exit
else19:
	%tmp74 = load i8, i8* %val
	%tmp75 = icmp eq i8 %tmp74, 9
	br i1 %tmp75, label %then20, label %else20
then20:
	%tmp76 = call %struct.string.String @string.from_c_string(i8* @.str.71)
	br label %func_exit
else20:
	%tmp77 = load i8, i8* %val
	%tmp78 = icmp eq i8 %tmp77, 10
	br i1 %tmp78, label %then21, label %else21
then21:
	%tmp79 = call %struct.string.String @string.from_c_string(i8* @.str.72)
	br label %func_exit
else21:
	%tmp80 = load i8, i8* %val
	%tmp81 = icmp eq i8 %tmp80, 11
	br i1 %tmp81, label %then22, label %else22
then22:
	%tmp82 = call %struct.string.String @string.from_c_string(i8* @.str.73)
	br label %func_exit
else22:
	%tmp83 = load i8, i8* %val
	%tmp84 = icmp eq i8 %tmp83, 12
	br i1 %tmp84, label %then23, label %else23
then23:
	%tmp85 = call %struct.string.String @string.from_c_string(i8* @.str.74)
	br label %func_exit
else23:
	%tmp86 = load i8, i8* %val
	%tmp87 = icmp eq i8 %tmp86, 13
	br i1 %tmp87, label %then24, label %else24
then24:
	%tmp88 = call %struct.string.String @string.from_c_string(i8* @.str.75)
	br label %func_exit
else24:
	%tmp89 = load i8, i8* %val
	%tmp90 = icmp eq i8 %tmp89, 14
	br i1 %tmp90, label %then25, label %else25
then25:
	%tmp91 = call %struct.string.String @string.from_c_string(i8* @.str.76)
	br label %func_exit
else25:
	%tmp92 = load i8, i8* %val
	%tmp93 = icmp eq i8 %tmp92, 15
	br i1 %tmp93, label %then26, label %else26
then26:
	%tmp94 = call %struct.string.String @string.from_c_string(i8* @.str.77)
	br label %func_exit
else26:
	%tmp95 = load i8, i8* %val
	%tmp96 = icmp eq i8 %tmp95, 16
	br i1 %tmp96, label %then27, label %else27
then27:
	%tmp97 = call %struct.string.String @string.from_c_string(i8* @.str.78)
	br label %func_exit
else27:
	%tmp98 = load i8, i8* %val
	%tmp99 = icmp eq i8 %tmp98, 17
	br i1 %tmp99, label %then28, label %else28
then28:
	%tmp100 = call %struct.string.String @string.from_c_string(i8* @.str.79)
	br label %func_exit
else28:
	%tmp101 = load i8, i8* %val
	%tmp102 = icmp eq i8 %tmp101, 18
	br i1 %tmp102, label %then29, label %else29
then29:
	%tmp103 = call %struct.string.String @string.from_c_string(i8* @.str.80)
	br label %func_exit
else29:
	%tmp104 = load i8, i8* %val
	%tmp105 = icmp eq i8 %tmp104, 19
	br i1 %tmp105, label %then30, label %else30
then30:
	%tmp106 = call %struct.string.String @string.from_c_string(i8* @.str.81)
	br label %func_exit
else30:
	%tmp107 = load i8, i8* %val
	%tmp108 = icmp eq i8 %tmp107, 20
	br i1 %tmp108, label %then31, label %else31
then31:
	%tmp109 = call %struct.string.String @string.from_c_string(i8* @.str.82)
	br label %func_exit
else31:
	%tmp110 = load i8, i8* %val
	%tmp111 = icmp eq i8 %tmp110, 21
	br i1 %tmp111, label %then32, label %else32
then32:
	%tmp112 = call %struct.string.String @string.from_c_string(i8* @.str.83)
	br label %func_exit
else32:
	%tmp113 = load i8, i8* %val
	%tmp114 = icmp eq i8 %tmp113, 22
	br i1 %tmp114, label %then33, label %else33
then33:
	%tmp115 = call %struct.string.String @string.from_c_string(i8* @.str.84)
	br label %func_exit
else33:
	%tmp116 = load i8, i8* %val
	%tmp117 = icmp eq i8 %tmp116, 23
	br i1 %tmp117, label %then34, label %else34
then34:
	%tmp118 = call %struct.string.String @string.from_c_string(i8* @.str.85)
	br label %func_exit
else34:
	%tmp119 = load i8, i8* %val
	%tmp120 = icmp eq i8 %tmp119, 24
	br i1 %tmp120, label %then35, label %else35
then35:
	%tmp121 = call %struct.string.String @string.from_c_string(i8* @.str.86)
	br label %func_exit
else35:
	%tmp122 = load i8, i8* %val
	%tmp123 = icmp eq i8 %tmp122, 25
	br i1 %tmp123, label %then36, label %else36
then36:
	%tmp124 = call %struct.string.String @string.from_c_string(i8* @.str.87)
	br label %func_exit
else36:
	%tmp125 = load i8, i8* %val
	%tmp126 = icmp eq i8 %tmp125, 26
	br i1 %tmp126, label %then37, label %else37
then37:
	%tmp127 = call %struct.string.String @string.from_c_string(i8* @.str.88)
	br label %func_exit
else37:
	%tmp128 = load i8, i8* %val
	%tmp129 = icmp eq i8 %tmp128, 27
	br i1 %tmp129, label %then38, label %else38
then38:
	%tmp130 = call %struct.string.String @string.from_c_string(i8* @.str.89)
	br label %func_exit
else38:
	%tmp131 = load i8, i8* %val
	%tmp132 = icmp eq i8 %tmp131, 28
	br i1 %tmp132, label %then39, label %else39
then39:
	%tmp133 = call %struct.string.String @string.from_c_string(i8* @.str.90)
	br label %func_exit
else39:
	%tmp134 = load i8, i8* %val
	%tmp135 = icmp eq i8 %tmp134, 29
	br i1 %tmp135, label %then40, label %else40
then40:
	%tmp136 = call %struct.string.String @string.from_c_string(i8* @.str.91)
	br label %func_exit
else40:
	%tmp137 = load i8, i8* %val
	%tmp138 = icmp eq i8 %tmp137, 30
	br i1 %tmp138, label %then41, label %else41
then41:
	%tmp139 = call %struct.string.String @string.from_c_string(i8* @.str.92)
	br label %func_exit
else41:
	%tmp140 = load i8, i8* %val
	%tmp141 = icmp eq i8 %tmp140, 31
	br i1 %tmp141, label %then42, label %else42
then42:
	%tmp142 = call %struct.string.String @string.from_c_string(i8* @.str.93)
	br label %func_exit
else42:
	%tmp143 = load i8, i8* %val
	%tmp144 = icmp eq i8 %tmp143, 32
	br i1 %tmp144, label %then43, label %else43
then43:
	%tmp145 = call %struct.string.String @string.from_c_string(i8* @.str.94)
	br label %func_exit
else43:
	%tmp146 = load i8, i8* %val
	%tmp147 = icmp eq i8 %tmp146, 33
	br i1 %tmp147, label %then44, label %else44
then44:
	%tmp148 = call %struct.string.String @string.from_c_string(i8* @.str.95)
	br label %func_exit
else44:
	%tmp149 = load i8, i8* %val
	%tmp150 = icmp eq i8 %tmp149, 36
	br i1 %tmp150, label %then45, label %else45
then45:
	%tmp151 = call %struct.string.String @string.from_c_string(i8* @.str.96)
	br label %func_exit
else45:
	%tmp152 = load i8, i8* %val
	%tmp153 = icmp eq i8 %tmp152, 37
	br i1 %tmp153, label %then46, label %else46
then46:
	%tmp154 = call %struct.string.String @string.from_c_string(i8* @.str.97)
	br label %func_exit
else46:
	%tmp155 = load i8, i8* %val
	%tmp156 = icmp eq i8 %tmp155, 38
	br i1 %tmp156, label %then47, label %else47
then47:
	%tmp157 = call %struct.string.String @string.from_c_string(i8* @.str.98)
	br label %func_exit
else47:
	%tmp158 = load i8, i8* %val
	%tmp159 = icmp eq i8 %tmp158, 39
	br i1 %tmp159, label %then48, label %else48
then48:
	%tmp160 = call %struct.string.String @string.from_c_string(i8* @.str.99)
	br label %func_exit
else48:
	%tmp161 = load i8, i8* %val
	%tmp162 = icmp eq i8 %tmp161, 40
	br i1 %tmp162, label %then49, label %else49
then49:
	%tmp163 = call %struct.string.String @string.from_c_string(i8* @.str.100)
	br label %func_exit
else49:
	%tmp164 = load i8, i8* %val
	%tmp165 = icmp eq i8 %tmp164, 41
	br i1 %tmp165, label %then50, label %else50
then50:
	%tmp166 = call %struct.string.String @string.from_c_string(i8* @.str.101)
	br label %func_exit
else50:
	%tmp167 = load i8, i8* %val
	%tmp168 = icmp eq i8 %tmp167, 42
	br i1 %tmp168, label %then51, label %else51
then51:
	%tmp169 = call %struct.string.String @string.from_c_string(i8* @.str.102)
	br label %func_exit
else51:
	%tmp170 = load i8, i8* %val
	%tmp171 = icmp eq i8 %tmp170, 43
	br i1 %tmp171, label %then52, label %else52
then52:
	%tmp172 = call %struct.string.String @string.from_c_string(i8* @.str.103)
	br label %func_exit
else52:
	%tmp173 = load i8, i8* %val
	%tmp174 = icmp eq i8 %tmp173, 44
	br i1 %tmp174, label %then53, label %else53
then53:
	%tmp175 = call %struct.string.String @string.from_c_string(i8* @.str.104)
	br label %func_exit
else53:
	%tmp176 = load i8, i8* %val
	%tmp177 = icmp eq i8 %tmp176, 45
	br i1 %tmp177, label %then54, label %else54
then54:
	%tmp178 = call %struct.string.String @string.from_c_string(i8* @.str.105)
	br label %func_exit
else54:
	%tmp179 = load i8, i8* %val
	%tmp180 = icmp eq i8 %tmp179, 46
	br i1 %tmp180, label %then55, label %else55
then55:
	%tmp181 = call %struct.string.String @string.from_c_string(i8* @.str.106)
	br label %func_exit
else55:
	%tmp182 = load i8, i8* %val
	%tmp183 = icmp eq i8 %tmp182, 47
	br i1 %tmp183, label %then56, label %else56
then56:
	%tmp184 = call %struct.string.String @string.from_c_string(i8* @.str.107)
	br label %func_exit
else56:
	%tmp185 = load i8, i8* %val
	%tmp186 = icmp eq i8 %tmp185, 48
	br i1 %tmp186, label %then57, label %else57
then57:
	%tmp187 = call %struct.string.String @string.from_c_string(i8* @.str.108)
	br label %func_exit
else57:
	%tmp188 = load i8, i8* %val
	%tmp189 = icmp eq i8 %tmp188, 49
	br i1 %tmp189, label %then58, label %else58
then58:
	%tmp190 = call %struct.string.String @string.from_c_string(i8* @.str.109)
	br label %func_exit
else58:
	%tmp191 = load i8, i8* %val
	%tmp192 = icmp eq i8 %tmp191, 50
	br i1 %tmp192, label %then59, label %else59
then59:
	%tmp193 = call %struct.string.String @string.from_c_string(i8* @.str.110)
	br label %func_exit
else59:
	%tmp194 = load i8, i8* %val
	%tmp195 = icmp eq i8 %tmp194, 51
	br i1 %tmp195, label %then60, label %else60
then60:
	%tmp196 = call %struct.string.String @string.from_c_string(i8* @.str.111)
	br label %func_exit
else60:
	%tmp197 = load i8, i8* %val
	%tmp198 = icmp eq i8 %tmp197, 52
	br i1 %tmp198, label %then61, label %else61
then61:
	%tmp199 = call %struct.string.String @string.from_c_string(i8* @.str.112)
	br label %func_exit
else61:
	%tmp200 = load i8, i8* %val
	%tmp201 = icmp eq i8 %tmp200, 53
	br i1 %tmp201, label %then62, label %else62
then62:
	%tmp202 = call %struct.string.String @string.from_c_string(i8* @.str.113)
	br label %func_exit
else62:
	%tmp203 = load i8, i8* %val
	%tmp204 = icmp eq i8 %tmp203, 54
	br i1 %tmp204, label %then63, label %else63
then63:
	%tmp205 = call %struct.string.String @string.from_c_string(i8* @.str.114)
	br label %func_exit
else63:
	%tmp206 = load i8, i8* %val
	%tmp207 = icmp eq i8 %tmp206, 55
	br i1 %tmp207, label %then64, label %else64
then64:
	%tmp208 = call %struct.string.String @string.from_c_string(i8* @.str.115)
	br label %func_exit
else64:
	%tmp209 = load i8, i8* %val
	%tmp210 = icmp eq i8 %tmp209, 56
	br i1 %tmp210, label %then65, label %else65
then65:
	%tmp211 = call %struct.string.String @string.from_c_string(i8* @.str.116)
	br label %func_exit
else65:
	%tmp212 = load i8, i8* %val
	%tmp213 = icmp eq i8 %tmp212, 57
	br i1 %tmp213, label %then66, label %else66
then66:
	%tmp214 = call %struct.string.String @string.from_c_string(i8* @.str.117)
	br label %func_exit
else66:
	%tmp215 = load i8, i8* %val
	%tmp216 = icmp eq i8 %tmp215, 58
	br i1 %tmp216, label %then67, label %else67
then67:
	%tmp217 = call %struct.string.String @string.from_c_string(i8* @.str.118)
	br label %func_exit
else67:
	%tmp218 = load i8, i8* %val
	%tmp219 = icmp eq i8 %tmp218, 59
	br i1 %tmp219, label %then68, label %else68
then68:
	%tmp220 = call %struct.string.String @string.from_c_string(i8* @.str.119)
	br label %func_exit
else68:
	%tmp221 = load i8, i8* %val
	%tmp222 = icmp eq i8 %tmp221, 60
	br i1 %tmp222, label %then69, label %else69
then69:
	%tmp223 = call %struct.string.String @string.from_c_string(i8* @.str.120)
	br label %func_exit
else69:
	%tmp224 = load i8, i8* %val
	%tmp225 = icmp eq i8 %tmp224, 61
	br i1 %tmp225, label %then70, label %else70
then70:
	%tmp226 = call %struct.string.String @string.from_c_string(i8* @.str.121)
	br label %func_exit
else70:
	%tmp227 = load i8, i8* %val
	%tmp228 = icmp eq i8 %tmp227, 62
	br i1 %tmp228, label %then71, label %else71
then71:
	%tmp229 = call %struct.string.String @string.from_c_string(i8* @.str.122)
	br label %func_exit
else71:
	%tmp230 = load i8, i8* %val
	%tmp231 = icmp eq i8 %tmp230, 63
	br i1 %tmp231, label %then72, label %else72
then72:
	%tmp232 = call %struct.string.String @string.from_c_string(i8* @.str.123)
	br label %func_exit
else72:
	%tmp233 = load i8, i8* %val
	%tmp234 = icmp eq i8 %tmp233, 64
	br i1 %tmp234, label %then73, label %endif73
then73:
	%tmp235 = call %struct.string.String @string.from_c_string(i8* @.str.124)
	br label %func_exit
endif73:
	br label %endif11
endif11:
	%tmp236 = call %struct.string.String @string.from_c_string(i8* @.str.125)
	br label %func_exit
func_exit:
	%tmp237 = phi %struct.string.String [%tmp7, %then1], [%tmp14, %then2], [%tmp21, %then3], [%tmp28, %then4], [%tmp31, %then5], [%tmp34, %then6], [%tmp37, %then7], [%tmp40, %then8], [%tmp43, %then9], [%tmp46, %then10], [%tmp49, %then11], [%tmp52, %then12], [%tmp55, %then13], [%tmp58, %then14], [%tmp61, %then15], [%tmp64, %then16], [%tmp67, %then17], [%tmp70, %then18], [%tmp73, %then19], [%tmp76, %then20], [%tmp79, %then21], [%tmp82, %then22], [%tmp85, %then23], [%tmp88, %then24], [%tmp91, %then25], [%tmp94, %then26], [%tmp97, %then27], [%tmp100, %then28], [%tmp103, %then29], [%tmp106, %then30], [%tmp109, %then31], [%tmp112, %then32], [%tmp115, %then33], [%tmp118, %then34], [%tmp121, %then35], [%tmp124, %then36], [%tmp127, %then37], [%tmp130, %then38], [%tmp133, %then39], [%tmp136, %then40], [%tmp139, %then41], [%tmp142, %then42], [%tmp145, %then43], [%tmp148, %then44], [%tmp151, %then45], [%tmp154, %then46], [%tmp157, %then47], [%tmp160, %then48], [%tmp163, %then49], [%tmp166, %then50], [%tmp169, %then51], [%tmp172, %then52], [%tmp175, %then53], [%tmp178, %then54], [%tmp181, %then55], [%tmp184, %then56], [%tmp187, %then57], [%tmp190, %then58], [%tmp193, %then59], [%tmp196, %then60], [%tmp199, %then61], [%tmp202, %then62], [%tmp205, %then63], [%tmp208, %then64], [%tmp211, %then65], [%tmp214, %then66], [%tmp217, %then67], [%tmp220, %then68], [%tmp223, %then69], [%tmp226, %then70], [%tmp229, %then71], [%tmp232, %then72], [%tmp235, %then73], [%tmp236, %endif11]
	ret %struct.string.String %tmp237
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
	%tmp0 = call %struct.Type @parse_type_internal(%struct.TokenData* %token_array, i32* %index, i32 %len)
	ret %struct.Type %tmp0
}
define %"struct.vector.Vec<%struct.Argument>" @parse_struct_fields(%struct.TokenData* %token_array, i32* %index, i32 %len){
	%v0 = alloca %"struct.vector.Vec<%struct.Argument>"
	%v1 = alloca %struct.Argument
	%tmp0 = call %"struct.vector.Vec<%struct.Argument>" @"vector.new<%struct.Argument>"()
	store %"struct.vector.Vec<%struct.Argument>" %tmp0, %"struct.vector.Vec<%struct.Argument>"* %v0
	call void @expect(%struct.TokenData* %token_array, i32* %index, i32 %len, i8 2, i8* @.str.30)
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
	call void @process.throw(i8* @.str.126)
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
	call void @expect(%struct.TokenData* %token_array, i32* %index, i32 %len, i8 6, i8* @.str.127)
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
	call void @process.throw(i8* @.str.128)
	br label %endif5
endif5:
	br label %endif4
endif4:
	br label %loop_start0
loop_body0_exit:
; Variable field is out.
	call void @expect(%struct.TokenData* %token_array, i32* %index, i32 %len, i8 3, i8* @.str.129)
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
	call void @process.throw(i8* @.str.130)
	br label %endif5
endif5:
	br label %endif4
endif4:
	br label %loop_start1
loop_body1_exit:
	call void @expect(%struct.TokenData* %token_array, i32* %index, i32 %len, i8 26, i8* @.str.131)
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
	%tmp0 = call %struct.Expression @parse_expression_internal(%struct.TokenData* %token_array, i32* %index, i32 %len, i8 0)
	ret %struct.Expression %tmp0
}
define %"struct.vector.Vec<%struct.EnumField>" @parse_enum_fields(%struct.TokenData* %token_array, i32* %index, i32 %len){
	%v0 = alloca %"struct.vector.Vec<%struct.EnumField>"
	%v1 = alloca %struct.EnumField
	%tmp0 = call %"struct.vector.Vec<%struct.EnumField>" @"vector.new<%struct.EnumField>"()
	store %"struct.vector.Vec<%struct.EnumField>" %tmp0, %"struct.vector.Vec<%struct.EnumField>"* %v0
	call void @expect(%struct.TokenData* %token_array, i32* %index, i32 %len, i8 2, i8* @.str.28)
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
	call void @process.throw(i8* @.str.132)
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
	call void @process.throw(i8* @.str.133)
	br label %endif6
endif6:
	br label %endif5
endif5:
	br label %loop_start0
loop_body0_exit:
; Variable field is out.
	call void @expect(%struct.TokenData* %token_array, i32* %index, i32 %len, i8 3, i8* @.str.134)
	%tmp39 = load %"struct.vector.Vec<%struct.EnumField>", %"struct.vector.Vec<%struct.EnumField>"* %v0
; Variable fields is out.
	ret %"struct.vector.Vec<%struct.EnumField>" %tmp39
}
define void @parse_body(%struct.TokenData* %token_array, i32 %token_len, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %"struct.vector.Vec<%struct.Stmt>"* %statement_vector){
	%v0 = alloca i32
	%v1 = alloca %struct.Stmt
	%v2 = alloca %struct.Expression
	%v3 = alloca %struct.Stmt
	%v4 = alloca %struct.Type
	%v5 = alloca i1
	%v6 = alloca %struct.Expression
	%v7 = alloca %struct.Expression
	%v8 = alloca %struct.Stmt
	%v9 = alloca %struct.Expression
	%v10 = alloca %struct.Expression
	%v11 = alloca %struct.Expression
	%v12 = alloca %struct.Expression
	%v13 = alloca %struct.Expression
	%v14 = alloca %struct.Stmt
	%v15 = alloca i32
	%v16 = alloca %struct.string.String
	%tmp0 = icmp eq i32 %token_len, 0
	br i1 %tmp0, label %then0, label %endif0
then0:
	br label %func_exit
endif0:
	store i32 0, i32* %v0
	br label %loop_start1
loop_start1:
	%tmp1 = load i32, i32* %v0
	%tmp2 = icmp ult i32 %tmp1, %token_len
	br i1 %tmp2, label %endif2, label %else2
else2:
	br label %loop_body1_exit
endif2:
	%tmp3 = load i32, i32* %v0
	%tmp4 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp3
	%tmp5 = load i8, i8* %tmp4
	%tmp6 = icmp eq i8 %tmp5, 58
	br i1 %tmp6, label %then3, label %endif3
then3:
	%tmp7 = load i32, i32* %v0
	%tmp8 = add i32 %tmp7, 1
	store i32 %tmp8, i32* %v0
	%tmp9 = load i32, i32* %v0
	%tmp10 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp9
	%tmp11 = load i8, i8* %tmp10
	%tmp12 = icmp eq i8 %tmp11, 8
	br i1 %tmp12, label %then4, label %endif4
then4:
	%tmp13 = load i32, i32* %v0
	%tmp14 = add i32 %tmp13, 1
	store i32 %tmp14, i32* %v0
	%tmp15 = call i8* @mem.malloc(i64 24)
	store i1 false, i1* %tmp15
	store i8 10, i8* %v1
	%tmp16 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %v1, i32 0, i32 1
	store i8* null, i8** %tmp16
	%tmp17 = load %struct.Stmt, %struct.Stmt* %v1
	call void @"vector.push<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %statement_vector, %struct.Stmt %tmp17)
	br label %loop_body1
; Variable stmt is out.
endif4:
	%tmp18 = call %struct.Expression @parse_expression(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	store %struct.Expression %tmp18, %struct.Expression* %v2
	call void @expect(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 8, i8* @.str.135)
	%tmp19 = call i8* @mem.malloc(i64 24)
	store i1 true, i1* %tmp19
	%tmp20 = getelementptr inbounds %struct.ReturnNode, %struct.ReturnNode* %tmp19, i32 0, i32 1
	%tmp21 = load %struct.Expression, %struct.Expression* %v2
	store %struct.Expression %tmp21, %struct.Expression* %tmp20
	store i8 10, i8* %v3
	%tmp22 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %v3, i32 0, i32 1
	store i8* %tmp19, i8** %tmp22
	%tmp23 = load %struct.Stmt, %struct.Stmt* %v3
	call void @"vector.push<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %statement_vector, %struct.Stmt %tmp23)
	br label %loop_body1
; Variable stmt is out.
; Variable expr is out.
endif3:
	%tmp24 = icmp eq i8 %tmp5, 38
	br i1 %tmp24, label %logic_end_5, label %logic_rhs_5
logic_rhs_5:
	%tmp25 = icmp eq i8 %tmp5, 42
	br label %logic_end_5
logic_end_5:
	%tmp26 = phi i1 [%tmp24, %endif3], [%tmp25, %logic_rhs_5]
	br i1 %tmp26, label %logic_end_6, label %logic_rhs_6
logic_rhs_6:
	%tmp27 = icmp eq i8 %tmp5, 43
	br label %logic_end_6
logic_end_6:
	%tmp28 = phi i1 [%tmp26, %logic_end_5], [%tmp27, %logic_rhs_6]
	br i1 %tmp28, label %then7, label %endif7
then7:
	%tmp29 = load i32, i32* %v0
	%tmp30 = add i32 %tmp29, 1
	store i32 %tmp30, i32* %v0
	%tmp31 = load i32, i32* %v0
	%tmp32 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp31
	%tmp33 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp32, i32 0, i32 1
	%tmp34 = load i16, i16* %tmp33
	call void @expect(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 65, i8* @.str.136)
	call void @expect(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 6, i8* @.str.137)
	%tmp35 = call %struct.Type @parse_type(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	store %struct.Type %tmp35, %struct.Type* %v4
	store i1 false, i1* %v5
	%tmp36 = load i32, i32* %v0
	%tmp37 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp36
	%tmp38 = load i8, i8* %tmp37
	%tmp39 = icmp eq i8 %tmp38, 15
	br i1 %tmp39, label %then8, label %endif8
then8:
	%tmp40 = load i32, i32* %v0
	%tmp41 = add i32 %tmp40, 1
	store i32 %tmp41, i32* %v0
	%tmp42 = call %struct.Expression @parse_expression(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	store %struct.Expression %tmp42, %struct.Expression* %v7
	%tmp43 = load %struct.Expression, %struct.Expression* %v7
	store %struct.Expression %tmp43, %struct.Expression* %v6
	store i1 true, i1* %v5
; Variable x is out.
	br label %endif8
endif8:
	call void @expect(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 8, i8* @.str.138)
	%tmp44 = call i8* @mem.malloc(i64 48)
	store i16 %tmp34, i16* %tmp44
	%tmp45 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp44, i32 0, i32 3
	%tmp46 = load %struct.Type, %struct.Type* %v4
	store %struct.Type %tmp46, %struct.Type* %tmp45
	%tmp47 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp44, i32 0, i32 1
	%tmp48 = load i1, i1* %v5
	store i1 %tmp48, i1* %tmp47
	%tmp49 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp44, i32 0, i32 2
	%tmp50 = load %struct.Expression, %struct.Expression* %v6
	store %struct.Expression %tmp50, %struct.Expression* %tmp49
	%tmp51 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp44, i32 0, i32 4
	store i8 0, i8* %tmp51
	%tmp52 = icmp eq i8 %tmp5, 38
	br i1 %tmp52, label %then9, label %else9
then9:
	%tmp53 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp44, i32 0, i32 4
	store i8 0, i8* %tmp53
	br label %endif9
else9:
	%tmp54 = icmp eq i8 %tmp5, 43
	br i1 %tmp54, label %then10, label %endif10
then10:
	%tmp55 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp44, i32 0, i32 4
	store i8 1, i8* %tmp55
	br label %endif10
endif10:
	br label %endif9
endif9:
	store i8 1, i8* %v8
	%tmp56 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %v8, i32 0, i32 1
	store i8* %tmp44, i8** %tmp56
	%tmp57 = load %struct.Stmt, %struct.Stmt* %v8
	call void @"vector.push<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %statement_vector, %struct.Stmt %tmp57)
	br label %loop_body1
; Variable stmt is out.
; Variable expr is out.
; Variable type is out.
endif7:
	%tmp58 = icmp eq i8 %tmp5, 45
	br i1 %tmp58, label %then11, label %endif11
then11:
	%tmp59 = load i32, i32* %v0
	%tmp60 = add i32 %tmp59, 1
	store i32 %tmp60, i32* %v0
	%tmp61 = call %struct.Expression @parse_expression(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	store %struct.Expression %tmp61, %struct.Expression* %v9
	%tmp62 = load i32, i32* %v0
	%tmp63 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp62
	%tmp64 = load i8, i8* %tmp63
	%tmp65 = icmp ne i8 %tmp64, 2
	br i1 %tmp65, label %then12, label %endif12
then12:
	call void @process.throw(i8* @.str.139)
	br label %endif12
endif12:
	call void @skip_nested(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 2, i8 3)
	%tmp66 = load i32, i32* %v0
	%tmp67 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp66
	%tmp68 = load i8, i8* %tmp67
	%tmp69 = icmp eq i8 %tmp68, 46
	br i1 %tmp69, label %then13, label %endif13
then13:
	%tmp70 = load i32, i32* %v0
	%tmp71 = add i32 %tmp70, 1
	store i32 %tmp71, i32* %v0
	%tmp72 = load i32, i32* %v0
	%tmp73 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp72
	%tmp74 = load i8, i8* %tmp73
	%tmp75 = icmp eq i8 %tmp74, 45
	br i1 %tmp75, label %then14, label %else14
then14:
	br label %loop_body1
else14:
	%tmp76 = load i32, i32* %v0
	%tmp77 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp76
	%tmp78 = load i8, i8* %tmp77
	%tmp79 = icmp ne i8 %tmp78, 2
	br i1 %tmp79, label %then15, label %endif15
then15:
	call void @process.throw(i8* @.str.140)
	br label %endif15
endif15:
	call void @skip_nested(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 2, i8 3)
	br label %endif13
endif13:
	br label %loop_body1
; Variable expression is out.
endif11:
	%tmp80 = icmp eq i8 %tmp5, 55
	br i1 %tmp80, label %then16, label %endif16
then16:
	%tmp81 = load i32, i32* %v0
	%tmp82 = add i32 %tmp81, 1
	store i32 %tmp82, i32* %v0
	%tmp83 = call %struct.Expression @parse_expression(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	store %struct.Expression %tmp83, %struct.Expression* %v10
	%tmp84 = load i32, i32* %v0
	%tmp85 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp84
	%tmp86 = load i8, i8* %tmp85
	%tmp87 = icmp ne i8 %tmp86, 2
	br i1 %tmp87, label %then17, label %endif17
then17:
	call void @process.throw(i8* @.str.141)
	br label %endif17
endif17:
	call void @skip_nested(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 2, i8 3)
	br label %loop_body1
; Variable expression is out.
endif16:
	%tmp88 = icmp eq i8 %tmp5, 51
	br i1 %tmp88, label %then18, label %endif18
then18:
	%tmp89 = load i32, i32* %v0
	%tmp90 = add i32 %tmp89, 1
	store i32 %tmp90, i32* %v0
	%tmp91 = load i32, i32* %v0
	%tmp92 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp91
	%tmp93 = load i8, i8* %tmp92
	%tmp94 = icmp ne i8 %tmp93, 2
	br i1 %tmp94, label %then19, label %endif19
then19:
	call void @process.throw(i8* @.str.141)
	br label %endif19
endif19:
	call void @skip_nested(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 2, i8 3)
	br label %loop_body1
endif18:
	%tmp95 = icmp eq i8 %tmp5, 53
	br i1 %tmp95, label %then20, label %endif20
then20:
	%tmp96 = load i32, i32* %v0
	%tmp97 = add i32 %tmp96, 1
	store i32 %tmp97, i32* %v0
	%tmp98 = load i32, i32* %v0
	%tmp99 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp98
	%tmp100 = load i8, i8* %tmp99
	%tmp101 = icmp ne i8 %tmp100, 2
	br i1 %tmp101, label %then21, label %endif21
then21:
	call void @process.throw(i8* @.str.141)
	br label %endif21
endif21:
	call void @skip_nested(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 2, i8 3)
	call void @expect(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 55, i8* @.str.142)
	%tmp102 = call %struct.Expression @parse_expression(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	store %struct.Expression %tmp102, %struct.Expression* %v11
	call void @expect(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 8, i8* @.str.143)
	br label %loop_body1
; Variable expression is out.
endif20:
	%tmp103 = icmp eq i8 %tmp5, 52
	br i1 %tmp103, label %then22, label %endif22
then22:
	%tmp104 = load i32, i32* %v0
	%tmp105 = add i32 %tmp104, 1
	store i32 %tmp105, i32* %v0
	%tmp106 = load i32, i32* %v0
	%tmp107 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp106
	%tmp108 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp107, i32 0, i32 1
	%tmp109 = load i16, i16* %tmp108
	%tmp110 = load i32, i32* %v0
	%tmp111 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp110
	%tmp112 = load i8, i8* %tmp111
	%tmp113 = icmp ne i8 %tmp112, 65
	br i1 %tmp113, label %then23, label %endif23
then23:
	call void @process.throw(i8* @.str.144)
	br label %endif23
endif23:
	%tmp114 = load i32, i32* %v0
	%tmp115 = add i32 %tmp114, 1
	store i32 %tmp115, i32* %v0
	call void @expect(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 54, i8* @.str.145)
	%tmp116 = call %struct.Expression @parse_expression(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	store %struct.Expression %tmp116, %struct.Expression* %v12
	call void @skip_nested(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 2, i8 3)
	br label %loop_body1
; Variable expression is out.
endif22:
	%tmp117 = call i1 @is_expression_starter(i8 %tmp5)
	br i1 %tmp117, label %then24, label %endif24
then24:
	%tmp118 = call %struct.Expression @parse_expression(%struct.TokenData* %token_array, i32* %v0, i32 %token_len)
	store %struct.Expression %tmp118, %struct.Expression* %v13
	call void @expect(%struct.TokenData* %token_array, i32* %v0, i32 %token_len, i8 8, i8* @.str.146)
	%tmp119 = call i8* @mem.malloc(i64 16)
	%tmp120 = load %struct.Expression, %struct.Expression* %v13
	store %struct.Expression %tmp120, %struct.Expression* %tmp119
	store i8 2, i8* %v14
	%tmp121 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %v14, i32 0, i32 1
	store i8* %tmp119, i8** %tmp121
	%tmp122 = load %struct.Stmt, %struct.Stmt* %v14
	call void @"vector.push<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %statement_vector, %struct.Stmt %tmp122)
	br label %loop_body1
; Variable stmt is out.
; Variable expression is out.
endif24:
	store i32 0, i32* %v15
	br label %loop_cond25
loop_cond25:
	%tmp123 = load i32, i32* %v15
	%tmp124 = icmp uge i32 %tmp123, 3
	br i1 %tmp124, label %then26, label %endif26
then26:
	br label %loop_body25_exit
endif26:
	%tmp125 = load i32, i32* %v0
	%tmp126 = load i32, i32* %v15
	%tmp127 = add i32 %tmp125, %tmp126
	%tmp128 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp127
	%tmp129 = call %struct.string.String @token_type_to_string(%struct.TokenData* %tmp128, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector)
	store %struct.string.String %tmp129, %struct.string.String* %v16
	call void @console.write(i8* @.str.147, i32 4)
	call void @console.write_string(%struct.string.String* %v16)
	call void @console.write(i8* @.str.148, i32 5)
	call void @string.free(%struct.string.String* %v16)
	%tmp130 = load i32, i32* %v15
	%tmp131 = add i32 %tmp130, 1
	store i32 %tmp131, i32* %v15
	br label %loop_cond25
loop_body25_exit:
; Variable q is out.
	call void @process.throw(i8* @.str.149)
	br label %loop_body1
loop_body1:
	br label %loop_start1
loop_body1_exit:
	br label %func_exit
func_exit:
	ret void
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
	call void @process.throw(i8* @.str.150)
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
	call void @process.throw(i8* @.str.151)
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
	call void @process.throw(i8* @.str.152)
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
	%v29 = alloca i16
	%v30 = alloca %struct.TokenData
	%tmp0 = sub i32 %end, %start
	%tmp1 = getelementptr inbounds i8, i8* %data, i32 %start
	%tmp2 = icmp eq i32 %tmp0, 2
	br i1 %tmp2, label %then0, label %else0
then0:
	%tmp3 = call i32 @mem.compare(i8* %tmp1, i8* @.str.153, i64 2)
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
	%tmp8 = call i32 @mem.compare(i8* %tmp1, i8* @.str.154, i64 2)
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
	%tmp13 = call i32 @mem.compare(i8* %tmp1, i8* @.str.155, i64 2)
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
	%tmp18 = call i32 @mem.compare(i8* %tmp1, i8* @.str.156, i64 2)
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
	%tmp23 = call i32 @mem.compare(i8* %tmp1, i8* @.str.157, i64 2)
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
	%tmp29 = call i32 @mem.compare(i8* %tmp1, i8* @.str.158, i64 3)
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
	%tmp34 = call i32 @mem.compare(i8* %tmp1, i8* @.str.159, i64 3)
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
	%tmp39 = call i32 @mem.compare(i8* %tmp1, i8* @.str.160, i64 3)
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
	%tmp45 = call i32 @mem.compare(i8* %tmp1, i8* @.str.161, i64 4)
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
	%tmp50 = call i32 @mem.compare(i8* %tmp1, i8* @.str.162, i64 4)
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
	%tmp55 = call i32 @mem.compare(i8* %tmp1, i8* @.str.163, i64 4)
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
	%tmp60 = call i32 @mem.compare(i8* %tmp1, i8* @.str.164, i64 4)
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
	%tmp65 = call i32 @mem.compare(i8* %tmp1, i8* @.str.165, i64 4)
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
	%tmp70 = call i32 @mem.compare(i8* %tmp1, i8* @.str.166, i64 4)
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
	%tmp75 = call i32 @mem.compare(i8* %tmp1, i8* @.str.167, i64 4)
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
	%tmp81 = call i32 @mem.compare(i8* %tmp1, i8* @.str.168, i64 5)
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
	%tmp86 = call i32 @mem.compare(i8* %tmp1, i8* @.str.169, i64 5)
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
	%tmp91 = call i32 @mem.compare(i8* %tmp1, i8* @.str.170, i64 5)
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
	%tmp96 = call i32 @mem.compare(i8* %tmp1, i8* @.str.171, i64 5)
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
	%tmp101 = call i32 @mem.compare(i8* %tmp1, i8* @.str.172, i64 5)
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
	%tmp106 = call i32 @mem.compare(i8* %tmp1, i8* @.str.173, i64 5)
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
	%tmp112 = call i32 @mem.compare(i8* %tmp1, i8* @.str.174, i64 6)
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
	%tmp117 = call i32 @mem.compare(i8* %tmp1, i8* @.str.175, i64 6)
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
	%tmp122 = call i32 @mem.compare(i8* %tmp1, i8* @.str.176, i64 6)
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
	%tmp127 = call i32 @mem.compare(i8* %tmp1, i8* @.str.177, i64 6)
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
	%tmp132 = call i32 @mem.compare(i8* %tmp1, i8* @.str.178, i64 6)
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
	%tmp138 = call i32 @mem.compare(i8* %tmp1, i8* @.str.179, i64 8)
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
	%tmp143 = call i32 @mem.compare(i8* %tmp1, i8* @.str.180, i64 8)
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
	%tmp149 = call i32 @mem.compare(i8* %tmp1, i8* @.str.181, i64 9)
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
	%tmp154 = call i16 @insert_symbol(i8* %tmp1, i32 %tmp0, %"struct.vector.Vec<%struct.string.String>"* %symbols)
	store i16 %tmp154, i16* %v29
	%tmp155 = load i16, i16* %v29
	store i8 65, i8* %v30
	%tmp156 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v30, i32 0, i32 1
	store i16 %tmp155, i16* %tmp156
	%tmp157 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v30, i32 0, i32 2
	store i32 %start, i32* %tmp157
	%tmp158 = load %struct.TokenData, %struct.TokenData* %v30
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp158)
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
	%v5 = alloca i16
	%v6 = alloca %struct.TokenData
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
	call void @process.throw(i8* @.str.182)
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
	%tmp54 = call i16 @insert_symbol(i8* %tmp3, i32 %tmp1, %"struct.vector.Vec<%struct.string.String>"* %symbols)
	store i16 %tmp54, i16* %v5
	%tmp55 = load i16, i16* %v5
	store i8 68, i8* %v6
	%tmp56 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v6, i32 0, i32 1
	store i16 %tmp55, i16* %tmp56
	%tmp57 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v6, i32 0, i32 2
	store i32 %start, i32* %tmp57
	%tmp58 = load %struct.TokenData, %struct.TokenData* %v6
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp58)
; Variable temp is out.
	ret void
}
define void @handle_number(i8* %data, i32 %start, i32 %end, %"struct.vector.Vec<%struct.TokenData>"* %tokens, %"struct.vector.Vec<%struct.string.String>"* %symbols){
	%v0 = alloca i16
	%v1 = alloca %struct.TokenData
	%tmp0 = getelementptr inbounds i8, i8* %data, i32 %start
	%tmp1 = sub i32 %end, %start
	%tmp2 = call i16 @insert_symbol(i8* %tmp0, i32 %tmp1, %"struct.vector.Vec<%struct.string.String>"* %symbols)
	store i16 %tmp2, i16* %v0
	%tmp3 = load i16, i16* %v0
	store i8 66, i8* %v1
	%tmp4 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v1, i32 0, i32 1
	store i16 %tmp3, i16* %tmp4
	%tmp5 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v1, i32 0, i32 2
	store i32 %start, i32* %tmp5
	%tmp6 = load %struct.TokenData, %struct.TokenData* %v1
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp6)
; Variable temp is out.
	ret void
}
define void @handle_decimal_number(i8* %data, i32 %start, i32 %end, %"struct.vector.Vec<%struct.TokenData>"* %tokens, %"struct.vector.Vec<%struct.string.String>"* %symbols){
	%v0 = alloca i16
	%v1 = alloca %struct.TokenData
	%tmp0 = getelementptr inbounds i8, i8* %data, i32 %start
	%tmp1 = sub i32 %end, %start
	%tmp2 = call i16 @insert_symbol(i8* %tmp0, i32 %tmp1, %"struct.vector.Vec<%struct.string.String>"* %symbols)
	store i16 %tmp2, i16* %v0
	%tmp3 = load i16, i16* %v0
	store i8 67, i8* %v1
	%tmp4 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v1, i32 0, i32 1
	store i16 %tmp3, i16* %tmp4
	%tmp5 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v1, i32 0, i32 2
	store i32 %start, i32* %tmp5
	%tmp6 = load %struct.TokenData, %struct.TokenData* %v1
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp6)
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
	call void @process.throw(i8* @.str.182)
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
	%tmp28 = icmp sgt i32 %tmp1, 2
	br i1 %tmp28, label %then9, label %endif9
then9:
	call void @process.throw(i8* @.str.183)
	br label %endif9
endif9:
	br label %func_exit
; Variable temp is out.
endif0:
	%tmp29 = icmp ne i32 %tmp1, 1
	br i1 %tmp29, label %then10, label %endif10
then10:
	call void @process.throw(i8* @.str.183)
	br label %endif10
endif10:
	%tmp30 = sext i8 %tmp4 to i16
	store i8 69, i8* %v3
	%tmp31 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v3, i32 0, i32 1
	store i16 %tmp30, i16* %tmp31
	%tmp32 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %v3, i32 0, i32 2
	store i32 %start, i32* %tmp32
	%tmp33 = load %struct.TokenData, %struct.TokenData* %v3
	call void @"vector.push<%struct.TokenData>"(%"struct.vector.Vec<%struct.TokenData>"* %tokens, %struct.TokenData %tmp33)
	br label %func_exit
func_exit:
; Variable temp is out.
	ret void
}
define void @expect(%struct.TokenData* %tokens, i32* %index, i32 %len, i8 %expected, i8* %error_msg){
entry:
	%v0 = alloca i32
	%v1 = alloca %struct.string.String
	%v2 = alloca %struct.string.String
	%v3 = alloca i32
	%v4 = alloca %struct.string.String
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
	store i32 0, i32* %v0
	br label %loop_cond2
loop_cond2:
	%tmp7 = load i32, i32* %v0
	%tmp8 = icmp uge i32 %tmp7, 5
	br i1 %tmp8, label %then3, label %endif3
then3:
	br label %loop_body2_exit
endif3:
	%tmp9 = load i32, i32* %index
	%tmp10 = load i32, i32* %v0
	%tmp11 = add i32 %tmp9, %tmp10
	%tmp12 = sub i32 %tmp11, 5
	%tmp13 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp12
	%tmp14 = call %struct.string.String @token_type_to_string(%struct.TokenData* %tmp13, %"struct.vector.Vec<%struct.string.String>"* null)
	store %struct.string.String %tmp14, %struct.string.String* %v1
	call void @console.write(i8* @.str.147, i32 4)
	call void @console.write_string(%struct.string.String* %v1)
	call void @console.write(i8* @.str.148, i32 5)
	call void @string.free(%struct.string.String* %v1)
	%tmp15 = load i32, i32* %v0
	%tmp16 = add i32 %tmp15, 1
	store i32 %tmp16, i32* %v0
	br label %loop_cond2
loop_body2_exit:
; Variable q is out.
	%tmp17 = load i32, i32* %index
	%tmp18 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp17
	%tmp19 = call %struct.string.String @token_type_to_string(%struct.TokenData* %tmp18, %"struct.vector.Vec<%struct.string.String>"* null)
	store %struct.string.String %tmp19, %struct.string.String* %v2
	call void @console.write(i8* @.str.184, i32 4)
	call void @console.write_string(%struct.string.String* %v2)
	call void @console.write(i8* @.str.185, i32 5)
	call void @string.free(%struct.string.String* %v2)
	store i32 0, i32* %v3
	br label %loop_cond4
loop_cond4:
	%tmp20 = load i32, i32* %v3
	%tmp21 = icmp uge i32 %tmp20, 5
	br i1 %tmp21, label %then5, label %endif5
then5:
	br label %loop_body4_exit
endif5:
	%tmp22 = load i32, i32* %index
	%tmp23 = load i32, i32* %v3
	%tmp24 = add i32 %tmp22, %tmp23
	%tmp25 = add i32 %tmp24, 1
	%tmp26 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp25
	%tmp27 = call %struct.string.String @token_type_to_string(%struct.TokenData* %tmp26, %"struct.vector.Vec<%struct.string.String>"* null)
	store %struct.string.String %tmp27, %struct.string.String* %v4
	call void @console.write(i8* @.str.147, i32 4)
	call void @console.write_string(%struct.string.String* %v4)
	call void @console.write(i8* @.str.148, i32 5)
	call void @string.free(%struct.string.String* %v4)
	%tmp28 = load i32, i32* %v3
	%tmp29 = add i32 %tmp28, 1
	store i32 %tmp29, i32* %v3
	br label %loop_cond4
loop_body4_exit:
; Variable q is out.
	call void @process.throw(i8* %error_msg)
; Variable q is out.
	br label %endif1
endif1:
	%tmp30 = load i32, i32* %index
	%tmp31 = add i32 %tmp30, 1
	store i32 %tmp31, i32* %index
	ret void
}
define void @debug_dump_type(%struct.Type* %expr, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout){
	%v0 = alloca i8
	%v1 = alloca i32
	%v2 = alloca i8
	%v3 = alloca i32
	%tmp0 = load %struct.string.String*, %struct.string.String** %symbol_vector
	%tmp1 = load i32, i32* %expr
	%tmp2 = icmp eq i32 %tmp1, 0
	br i1 %tmp2, label %then0, label %else0
then0:
	%tmp3 = getelementptr inbounds %struct.Type, %struct.Type* %expr, i32 0, i32 1
	%tmp4 = load i8*, i8** %tmp3
	%tmp5 = load i16, i16* %tmp4
	%tmp6 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp0, i16 %tmp5
	%tmp7 = load i8*, i8** %tmp6
	%tmp8 = load i16, i16* %tmp4
	%tmp9 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp0, i16 %tmp8
	%tmp10 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp9, i32 0, i32 1
	%tmp11 = load i32, i32* %tmp10
	call void @string.append_str(%struct.string.String* %stdout, i8* %tmp7, i32 %tmp11)
	br label %endif0
else0:
	%tmp12 = load i32, i32* %expr
	%tmp13 = icmp eq i32 %tmp12, 1
	br i1 %tmp13, label %then1, label %else1
then1:
	%tmp14 = getelementptr inbounds %struct.Type, %struct.Type* %expr, i32 0, i32 1
	%tmp15 = load i8*, i8** %tmp14
	%tmp16 = getelementptr inbounds %struct.PointerType, %struct.PointerType* %tmp15, i32 0, i32 1
	%tmp17 = load i8, i8* %tmp15
	store i8 0, i8* %v0
	br label %loop_cond2
loop_cond2:
	%tmp18 = load i8, i8* %v0
	%tmp19 = load i8, i8* %tmp15
	%tmp20 = icmp uge i8 %tmp18, %tmp19
	br i1 %tmp20, label %then3, label %endif3
then3:
	br label %loop_body2_exit
endif3:
	call void @string.append(%struct.string.String* %stdout, i8 38)
	%tmp21 = load i8, i8* %v0
	%tmp22 = add i8 %tmp21, 1
	store i8 %tmp22, i8* %v0
	br label %loop_cond2
loop_body2_exit:
	call void @debug_dump_type(%struct.Type* %tmp16, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	br label %endif1
else1:
	%tmp23 = load i32, i32* %expr
	%tmp24 = icmp eq i32 %tmp23, 2
	br i1 %tmp24, label %then4, label %else4
then4:
	%tmp25 = getelementptr inbounds %struct.Type, %struct.Type* %expr, i32 0, i32 1
	%tmp26 = load i8*, i8** %tmp25
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.186, i32 3)
	%tmp27 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %tmp26, i32 0, i32 1
	%tmp28 = load i32, i32* %tmp27
	store i32 0, i32* %v1
	br label %loop_cond5
loop_cond5:
	%tmp29 = load i32, i32* %v1
	%tmp30 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %tmp26, i32 0, i32 1
	%tmp31 = load i32, i32* %tmp30
	%tmp32 = icmp uge i32 %tmp29, %tmp31
	br i1 %tmp32, label %then6, label %endif6
then6:
	br label %loop_body5_exit
endif6:
	%tmp33 = load i32, i32* %v1
	%tmp34 = load %struct.Type*, %struct.Type** %tmp26
	%tmp35 = getelementptr inbounds %struct.Type, %struct.Type* %tmp34, i32 %tmp33
	call void @debug_dump_type(%struct.Type* %tmp35, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	%tmp36 = load i32, i32* %v1
	%tmp37 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %tmp26, i32 0, i32 1
	%tmp38 = load i32, i32* %tmp37
	%tmp39 = sub i32 %tmp38, 1
	%tmp40 = icmp ne i32 %tmp36, %tmp39
	br i1 %tmp40, label %then7, label %endif7
then7:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.39, i32 2)
	br label %endif7
endif7:
	%tmp41 = load i32, i32* %v1
	%tmp42 = add i32 %tmp41, 1
	store i32 %tmp42, i32* %v1
	br label %loop_cond5
loop_body5_exit:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.187, i32 4)
	%tmp43 = getelementptr inbounds %struct.FunctionType, %struct.FunctionType* %tmp26, i32 0, i32 1
	call void @debug_dump_type(%struct.Type* %tmp43, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	br label %endif4
else4:
	%tmp44 = load i32, i32* %expr
	%tmp45 = icmp eq i32 %tmp44, 3
	br i1 %tmp45, label %then8, label %else8
then8:
	%tmp46 = getelementptr inbounds %struct.Type, %struct.Type* %expr, i32 0, i32 1
	%tmp47 = load i8*, i8** %tmp46
	%tmp48 = getelementptr inbounds %struct.Path, %struct.Path* %tmp47, i32 0, i32 1
	%tmp49 = load i8, i8* %tmp48
	store i8 0, i8* %v2
	br label %loop_cond9
loop_cond9:
	%tmp50 = load i8, i8* %v2
	%tmp51 = getelementptr inbounds %struct.Path, %struct.Path* %tmp47, i32 0, i32 1
	%tmp52 = load i8, i8* %tmp51
	%tmp53 = icmp uge i8 %tmp50, %tmp52
	br i1 %tmp53, label %then10, label %endif10
then10:
	br label %loop_body9_exit
endif10:
	%tmp54 = load i8, i8* %v2
	%tmp55 = getelementptr inbounds [8 x i16], [8 x i16]* %tmp47, i32 0, i8 %tmp54
	%tmp56 = load i16, i16* %tmp55
	%tmp57 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp0, i16 %tmp56
	%tmp58 = load i8*, i8** %tmp57
	%tmp59 = load i8, i8* %v2
	%tmp60 = getelementptr inbounds [8 x i16], [8 x i16]* %tmp47, i32 0, i8 %tmp59
	%tmp61 = load i16, i16* %tmp60
	%tmp62 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp0, i16 %tmp61
	%tmp63 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp62, i32 0, i32 1
	%tmp64 = load i32, i32* %tmp63
	call void @string.append_str(%struct.string.String* %stdout, i8* %tmp58, i32 %tmp64)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.69, i32 2)
	%tmp65 = load i8, i8* %v2
	%tmp66 = add i8 %tmp65, 1
	store i8 %tmp66, i8* %v2
	br label %loop_cond9
loop_body9_exit:
	%tmp67 = getelementptr inbounds %struct.NamespaceLinkType, %struct.NamespaceLinkType* %tmp47, i32 0, i32 1
	call void @debug_dump_type(%struct.Type* %tmp67, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	br label %endif8
else8:
	%tmp68 = load i32, i32* %expr
	%tmp69 = icmp eq i32 %tmp68, 4
	br i1 %tmp69, label %then11, label %else11
then11:
	%tmp70 = getelementptr inbounds %struct.Type, %struct.Type* %expr, i32 0, i32 1
	%tmp71 = load i8*, i8** %tmp70
	%tmp72 = load i16, i16* %tmp71
	%tmp73 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp0, i16 %tmp72
	%tmp74 = load i8*, i8** %tmp73
	%tmp75 = load i16, i16* %tmp71
	%tmp76 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp0, i16 %tmp75
	%tmp77 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp76, i32 0, i32 1
	%tmp78 = load i32, i32* %tmp77
	call void @string.append_str(%struct.string.String* %stdout, i8* %tmp74, i32 %tmp78)
	call void @string.append(%struct.string.String* %stdout, i8 60)
	%tmp79 = getelementptr inbounds %struct.GenericType, %struct.GenericType* %tmp71, i32 0, i32 1
	%tmp80 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %tmp79, i32 0, i32 1
	%tmp81 = load i32, i32* %tmp80
	store i32 0, i32* %v3
	br label %loop_cond12
loop_cond12:
	%tmp82 = load i32, i32* %v3
	%tmp83 = getelementptr inbounds %struct.GenericType, %struct.GenericType* %tmp71, i32 0, i32 1
	%tmp84 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %tmp83, i32 0, i32 1
	%tmp85 = load i32, i32* %tmp84
	%tmp86 = icmp uge i32 %tmp82, %tmp85
	br i1 %tmp86, label %then13, label %endif13
then13:
	br label %loop_body12_exit
endif13:
	%tmp88 = load i32, i32* %v3
	%tmp89 = getelementptr inbounds %struct.GenericType, %struct.GenericType* %tmp71, i32 0, i32 1
	%tmp90 = load %struct.Type*, %struct.Type** %tmp89
	%tmp91 = getelementptr inbounds %struct.Type, %struct.Type* %tmp90, i32 %tmp88
	call void @debug_dump_type(%struct.Type* %tmp91, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	%tmp92 = load i32, i32* %v3
	%tmp93 = getelementptr inbounds %struct.GenericType, %struct.GenericType* %tmp71, i32 0, i32 1
	%tmp94 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %tmp93, i32 0, i32 1
	%tmp95 = load i32, i32* %tmp94
	%tmp96 = sub i32 %tmp95, 1
	%tmp97 = icmp ne i32 %tmp92, %tmp96
	br i1 %tmp97, label %then14, label %endif14
then14:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.39, i32 2)
	br label %endif14
endif14:
	%tmp98 = load i32, i32* %v3
	%tmp99 = add i32 %tmp98, 1
	store i32 %tmp99, i32* %v3
	br label %loop_cond12
loop_body12_exit:
	call void @string.append(%struct.string.String* %stdout, i8 62)
	br label %endif11
else11:
	%tmp100 = load i32, i32* %expr
	%tmp101 = icmp eq i32 %tmp100, 5
	br i1 %tmp101, label %then15, label %endif15
then15:
	%tmp102 = getelementptr inbounds %struct.Type, %struct.Type* %expr, i32 0, i32 1
	%tmp103 = load i8*, i8** %tmp102
	call void @string.append(%struct.string.String* %stdout, i8 91)
	call void @debug_dump_type(%struct.Type* %tmp103, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.188, i32 2)
	%tmp104 = getelementptr inbounds %struct.ConstantSizeArrayType, %struct.ConstantSizeArrayType* %tmp103, i32 0, i32 1
	call void @debug_dump_expression(%struct.Expression* %tmp104, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	call void @string.append(%struct.string.String* %stdout, i8 93)
	br label %endif15
endif15:
	br label %endif11
endif11:
	br label %endif8
endif8:
	br label %endif4
endif4:
	br label %endif1
endif1:
	br label %endif0
endif0:
	ret void
}
define void @debug_dump_expression(%struct.Expression* %expr, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout){
entry:
	%tmp0 = load i32, i32* %expr
	%tmp1 = icmp eq i32 %tmp0, 0
	br i1 %tmp1, label %logic_end_0, label %logic_rhs_0
logic_rhs_0:
	%tmp2 = load i32, i32* %expr
	%tmp3 = icmp eq i32 %tmp2, 2
	br label %logic_end_0
logic_end_0:
	%tmp4 = phi i1 [%tmp1, %entry], [%tmp3, %logic_rhs_0]
	br i1 %tmp4, label %logic_end_1, label %logic_rhs_1
logic_rhs_1:
	%tmp5 = load i32, i32* %expr
	%tmp6 = icmp eq i32 %tmp5, 3
	br label %logic_end_1
logic_end_1:
	%tmp7 = phi i1 [%tmp4, %logic_end_0], [%tmp6, %logic_rhs_1]
	br i1 %tmp7, label %then2, label %else2
then2:
	%tmp8 = getelementptr inbounds %struct.Expression, %struct.Expression* %expr, i32 0, i32 1
	%tmp9 = load i8*, i8** %tmp8
	%tmp10 = load i16, i16* %tmp9
	%tmp11 = load %struct.string.String*, %struct.string.String** %symbol_vector
	%tmp12 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp11, i16 %tmp10
	%tmp13 = load i8*, i8** %tmp12
	%tmp14 = load i16, i16* %tmp9
	%tmp15 = load %struct.string.String*, %struct.string.String** %symbol_vector
	%tmp16 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp15, i16 %tmp14
	%tmp17 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp16, i32 0, i32 1
	%tmp18 = load i32, i32* %tmp17
	call void @string.append_str(%struct.string.String* %stdout, i8* %tmp13, i32 %tmp18)
	br label %endif2
else2:
	%tmp19 = load i32, i32* %expr
	%tmp20 = icmp eq i32 %tmp19, 1
	br i1 %tmp20, label %then3, label %else3
then3:
	%tmp21 = getelementptr inbounds %struct.Expression, %struct.Expression* %expr, i32 0, i32 1
	%tmp22 = load i8*, i8** %tmp21
	call void @string.append(%struct.string.String* %stdout, i8 39)
	%tmp23 = load i16, i16* %tmp22
	%tmp24 = trunc i16 %tmp23 to i8
	call void @string.append(%struct.string.String* %stdout, i8 %tmp24)
	call void @string.append(%struct.string.String* %stdout, i8 39)
	br label %endif3
else3:
	%tmp25 = load i32, i32* %expr
	%tmp26 = icmp eq i32 %tmp25, 4
	br i1 %tmp26, label %then4, label %endif4
then4:
	%tmp27 = getelementptr inbounds %struct.Expression, %struct.Expression* %expr, i32 0, i32 1
	%tmp28 = load i8*, i8** %tmp27
	call void @string.append(%struct.string.String* %stdout, i8 34)
	%tmp29 = load i16, i16* %tmp28
	%tmp30 = load %struct.string.String*, %struct.string.String** %symbol_vector
	%tmp31 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp30, i16 %tmp29
	%tmp32 = load i8*, i8** %tmp31
	%tmp33 = load i16, i16* %tmp28
	%tmp34 = load %struct.string.String*, %struct.string.String** %symbol_vector
	%tmp35 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp34, i16 %tmp33
	%tmp36 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp35, i32 0, i32 1
	%tmp37 = load i32, i32* %tmp36
	call void @string.append_str(%struct.string.String* %stdout, i8* %tmp32, i32 %tmp37)
	call void @string.append(%struct.string.String* %stdout, i8 34)
	br label %endif4
endif4:
	br label %endif3
endif3:
	br label %endif2
endif2:
	ret void
}
define void @compile_body(%"struct.vector.Vec<%struct.Stmt>"* %statement_vector, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout){
	%v0 = alloca i32
	%v1 = alloca i32
	%v2 = alloca %struct.Stmt*
	%v3 = alloca i32
	store i32 0, i32* %v0
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %statement_vector, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	store i32 %tmp1, i32* %v1
	%tmp2 = load %struct.string.String*, %struct.string.String** %symbol_vector
	br label %loop_start0
loop_start0:
	%tmp3 = load i32, i32* %v0
	%tmp4 = load i32, i32* %v1
	%tmp5 = icmp ult i32 %tmp3, %tmp4
	br i1 %tmp5, label %endif1, label %else1
else1:
	br label %loop_body0_exit
endif1:
	%tmp6 = load i32, i32* %v0
	%tmp7 = load %struct.Stmt*, %struct.Stmt** %statement_vector
	%tmp8 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp7, i32 %tmp6
	store %struct.Stmt* %tmp8, %struct.Stmt** %v2
	%tmp9 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp10 = load i8, i8* %tmp9
	%tmp11 = icmp eq i8 %tmp10, 1
	br i1 %tmp11, label %then2, label %else2
then2:
	%tmp12 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp13 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp12, i32 0, i32 1
	%tmp14 = load i8*, i8** %tmp13
	%tmp15 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp14, i32 0, i32 4
	%tmp16 = load i8, i8* %tmp15
	%tmp17 = icmp eq i8 %tmp16, 2
	br i1 %tmp17, label %then3, label %else3
then3:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.189, i32 7)
	br label %endif3
else3:
	%tmp18 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp14, i32 0, i32 4
	%tmp19 = load i8, i8* %tmp18
	%tmp20 = icmp eq i8 %tmp19, 1
	br i1 %tmp20, label %then4, label %else4
then4:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.190, i32 8)
	br label %endif4
else4:
	%tmp21 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp14, i32 0, i32 4
	%tmp22 = load i8, i8* %tmp21
	%tmp23 = icmp eq i8 %tmp22, 0
	br i1 %tmp23, label %then5, label %endif5
then5:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.191, i32 5)
	br label %endif5
endif5:
	br label %endif4
endif4:
	br label %endif3
endif3:
	%tmp24 = load i16, i16* %tmp14
	%tmp25 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp2, i16 %tmp24
	%tmp26 = load i8*, i8** %tmp25
	%tmp27 = load i16, i16* %tmp14
	%tmp28 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp2, i16 %tmp27
	%tmp29 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp28, i32 0, i32 1
	%tmp30 = load i32, i32* %tmp29
	call void @string.append_str(%struct.string.String* %stdout, i8* %tmp26, i32 %tmp30)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.52, i32 3)
	%tmp31 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp14, i32 0, i32 3
	call void @debug_dump_type(%struct.Type* %tmp31, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	%tmp32 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp14, i32 0, i32 1
	%tmp33 = load i1, i1* %tmp32
	br i1 %tmp33, label %then6, label %endif6
then6:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.53, i32 3)
	%tmp34 = getelementptr inbounds %struct.DeclarationNode, %struct.DeclarationNode* %tmp14, i32 0, i32 2
	call void @debug_dump_expression(%struct.Expression* %tmp34, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	br label %endif6
endif6:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.8, i32 2)
	%tmp35 = load i32, i32* %v0
	%tmp36 = add i32 %tmp35, 1
	store i32 %tmp36, i32* %v0
	br label %loop_body0
else2:
	%tmp37 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp38 = load i8, i8* %tmp37
	%tmp39 = icmp eq i8 %tmp38, 2
	br i1 %tmp39, label %then7, label %else7
then7:
	%tmp40 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp41 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp40, i32 0, i32 1
	%tmp42 = load i8*, i8** %tmp41
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.192, i32 4)
	call void @debug_dump_expression(%struct.Expression* %tmp42, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.8, i32 2)
	%tmp43 = load i32, i32* %v0
	%tmp44 = add i32 %tmp43, 1
	store i32 %tmp44, i32* %v0
	br label %loop_body0
else7:
	%tmp45 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp46 = load i8, i8* %tmp45
	%tmp47 = icmp eq i8 %tmp46, 10
	br i1 %tmp47, label %then8, label %endif8
then8:
	%tmp48 = load %struct.Stmt*, %struct.Stmt** %v2
	%tmp49 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp48, i32 0, i32 1
	%tmp50 = load i8*, i8** %tmp49
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.193, i32 7)
	%tmp51 = load i1, i1* %tmp50
	br i1 %tmp51, label %then9, label %endif9
then9:
	call void @string.append(%struct.string.String* %stdout, i8 32)
	%tmp52 = getelementptr inbounds %struct.ReturnNode, %struct.ReturnNode* %tmp50, i32 0, i32 1
	call void @debug_dump_expression(%struct.Expression* %tmp52, %"struct.vector.Vec<%struct.string.String>"* %symbol_vector, %struct.string.String* %stdout)
	br label %endif9
endif9:
	call void @string.append_str(%struct.string.String* %stdout, i8* @.str.8, i32 2)
	%tmp53 = load i32, i32* %v0
	%tmp54 = add i32 %tmp53, 1
	store i32 %tmp54, i32* %v0
	br label %loop_body0
endif8:
	store i32 0, i32* %v3
	br label %loop_cond10
loop_cond10:
	%tmp55 = load i32, i32* %v3
	%tmp56 = icmp uge i32 %tmp55, 3
	br i1 %tmp56, label %then11, label %endif11
then11:
	br label %loop_body10_exit
endif11:
	%tmp57 = load i32, i32* %v0
	%tmp58 = load i32, i32* %v3
	%tmp59 = add i32 %tmp57, %tmp58
	%tmp60 = load %struct.Stmt*, %struct.Stmt** %statement_vector
	%tmp61 = getelementptr inbounds %struct.Stmt, %struct.Stmt* %tmp60, i32 %tmp59
	%tmp62 = load i8, i8* %tmp61
	%tmp63 = zext i8 %tmp62 to i64
	call void @console.println_i64(i64 %tmp63)
	call void @console.write(i8* @.str.35, i32 6)
	%tmp64 = load i32, i32* %v3
	%tmp65 = add i32 %tmp64, 1
	store i32 %tmp65, i32* %v3
	br label %loop_cond10
loop_body10_exit:
	call void @process.throw(i8* @.str.54)
	br label %loop_body0
loop_body0:
	br label %loop_start0
loop_body0_exit:
	ret void
}
define void @mem.zero_fill(i8* %dest, i64 %len){
	call void @mem.fill(i8 0, i8* %dest, i64 %len)
	ret void
}
define %struct.Type @parse_type_internal(%struct.TokenData* %token_array, i32* %index, i32 %len){
	%v0 = alloca i32
	%v1 = alloca %struct.Type
	%v2 = alloca %"struct.vector.Vec<%struct.Type>"
	%v3 = alloca %struct.Type
	%v4 = alloca %struct.FunctionType*
	%v5 = alloca %struct.Type
	%v6 = alloca %struct.Expression
	%v7 = alloca %struct.ConstantSizeArrayType*
	%v8 = alloca %struct.Path
	%v9 = alloca i16
	%v10 = alloca %struct.Type
	%v11 = alloca %"struct.vector.Vec<%struct.Type>"
	%v12 = alloca %struct.GenericType*
	%v13 = alloca %struct.NamedType*
	%v14 = alloca %struct.NamespaceLinkType*
	store i32 0, i32* %v0
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
	%tmp5 = icmp eq i8 %tmp4, 32
	br i1 %tmp5, label %then2, label %else2
then2:
	%tmp6 = load i32, i32* %v0
	%tmp7 = add i32 %tmp6, 1
	store i32 %tmp7, i32* %v0
	%tmp8 = load i32, i32* %index
	%tmp9 = add i32 %tmp8, 1
	store i32 %tmp9, i32* %index
	br label %endif2
else2:
	%tmp10 = load i32, i32* %index
	%tmp11 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp10
	%tmp12 = load i8, i8* %tmp11
	%tmp13 = icmp eq i8 %tmp12, 25
	br i1 %tmp13, label %then3, label %else3
then3:
	%tmp14 = load i32, i32* %v0
	%tmp15 = add i32 %tmp14, 2
	store i32 %tmp15, i32* %v0
	%tmp16 = load i32, i32* %index
	%tmp17 = add i32 %tmp16, 1
	store i32 %tmp17, i32* %index
	br label %endif3
else3:
	br label %loop_body0_exit
endif3:
	br label %endif2
endif2:
	br label %loop_start0
loop_body0_exit:
	%tmp18 = load i32, i32* %index
	%tmp19 = icmp uge i32 %tmp18, %len
	br i1 %tmp19, label %then4, label %endif4
then4:
	call void @process.throw(i8* @.str.194)
	br label %endif4
endif4:
	%tmp20 = load i32, i32* %index
	%tmp21 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp20
	%tmp22 = load i8, i8* %tmp21
	%tmp23 = icmp eq i8 %tmp22, 41
	br i1 %tmp23, label %then5, label %else5
then5:
	%tmp24 = load i32, i32* %index
	%tmp25 = add i32 %tmp24, 1
	store i32 %tmp25, i32* %index
	call void @expect(%struct.TokenData* %token_array, i32* %index, i32 %len, i8 0, i8* @.str.195)
	%tmp26 = call %"struct.vector.Vec<%struct.Type>" @parse_types_comma(%struct.TokenData* %token_array, i32* %index, i32 %len, i8 1)
	store %"struct.vector.Vec<%struct.Type>" %tmp26, %"struct.vector.Vec<%struct.Type>"* %v2
	call void @expect(%struct.TokenData* %token_array, i32* %index, i32 %len, i8 1, i8* @.str.196)
	call void @expect(%struct.TokenData* %token_array, i32* %index, i32 %len, i8 6, i8* @.str.197)
	%tmp27 = call %struct.Type @parse_type_internal(%struct.TokenData* %token_array, i32* %index, i32 %len)
	store %struct.Type %tmp27, %struct.Type* %v3
	%tmp28 = call i8* @mem.malloc(i64 32)
	store %struct.FunctionType* %tmp28, %struct.FunctionType** %v4
	%tmp29 = load %struct.FunctionType*, %struct.FunctionType** %v4
	%tmp30 = load %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %v2
	store %"struct.vector.Vec<%struct.Type>" %tmp30, %"struct.vector.Vec<%struct.Type>"* %tmp29
	%tmp31 = load %struct.FunctionType*, %struct.FunctionType** %v4
	%tmp32 = getelementptr inbounds %struct.FunctionType, %struct.FunctionType* %tmp31, i32 0, i32 1
	%tmp33 = load %struct.Type, %struct.Type* %v3
	store %struct.Type %tmp33, %struct.Type* %tmp32
	store i32 2, i32* %v1
	%tmp34 = getelementptr inbounds %struct.Type, %struct.Type* %v1, i32 0, i32 1
	%tmp35 = load %struct.FunctionType*, %struct.FunctionType** %v4
	store i8* %tmp35, i8** %tmp34
; Variable ret is out.
; Variable args is out.
	br label %endif5
else5:
	%tmp36 = icmp eq i8 %tmp22, 4
	br i1 %tmp36, label %then6, label %else6
then6:
	%tmp37 = load i32, i32* %index
	%tmp38 = add i32 %tmp37, 1
	store i32 %tmp38, i32* %index
	%tmp39 = call %struct.Type @parse_type_internal(%struct.TokenData* %token_array, i32* %index, i32 %len)
	store %struct.Type %tmp39, %struct.Type* %v5
	call void @expect(%struct.TokenData* %token_array, i32* %index, i32 %len, i8 8, i8* @.str.198)
	%tmp40 = call %struct.Expression @parse_expression_internal(%struct.TokenData* %token_array, i32* %index, i32 %len, i8 0)
	store %struct.Expression %tmp40, %struct.Expression* %v6
	call void @expect(%struct.TokenData* %token_array, i32* %index, i32 %len, i8 5, i8* @.str.199)
	%tmp41 = call i8* @mem.malloc(i64 32)
	store %struct.ConstantSizeArrayType* %tmp41, %struct.ConstantSizeArrayType** %v7
	%tmp42 = load %struct.ConstantSizeArrayType*, %struct.ConstantSizeArrayType** %v7
	%tmp43 = load %struct.Type, %struct.Type* %v5
	store %struct.Type %tmp43, %struct.Type* %tmp42
	%tmp44 = load %struct.ConstantSizeArrayType*, %struct.ConstantSizeArrayType** %v7
	%tmp45 = getelementptr inbounds %struct.ConstantSizeArrayType, %struct.ConstantSizeArrayType* %tmp44, i32 0, i32 1
	%tmp46 = load %struct.Expression, %struct.Expression* %v6
	store %struct.Expression %tmp46, %struct.Expression* %tmp45
	store i32 5, i32* %v1
	%tmp47 = getelementptr inbounds %struct.Type, %struct.Type* %v1, i32 0, i32 1
	%tmp48 = load %struct.ConstantSizeArrayType*, %struct.ConstantSizeArrayType** %v7
	store i8* %tmp48, i8** %tmp47
; Variable size_expr is out.
; Variable inner is out.
	br label %endif6
else6:
	%tmp49 = icmp eq i8 %tmp22, 65
	br i1 %tmp49, label %then7, label %else7
then7:
	%tmp50 = getelementptr inbounds %struct.Path, %struct.Path* %v8, i32 0, i32 1
	store i8 0, i8* %tmp50
	br label %loop_start8
loop_start8:
	%tmp51 = load i32, i32* %index
	%tmp52 = icmp ult i32 %tmp51, %len
	br i1 %tmp52, label %logic_rhs_9, label %logic_end_9
logic_rhs_9:
	%tmp53 = load i32, i32* %index
	%tmp54 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp53
	%tmp55 = load i8, i8* %tmp54
	%tmp56 = icmp eq i8 %tmp55, 65
	br label %logic_end_9
logic_end_9:
	%tmp57 = phi i1 [%tmp52, %loop_start8], [%tmp56, %logic_rhs_9]
	br i1 %tmp57, label %endif10, label %else10
else10:
	br label %loop_body8_exit
endif10:
	%tmp58 = getelementptr inbounds %struct.Path, %struct.Path* %v8, i32 0, i32 1
	%tmp59 = load i8, i8* %tmp58
	%tmp60 = icmp uge i8 %tmp59, 8
	br i1 %tmp60, label %then11, label %endif11
then11:
	call void @process.throw(i8* @.str.200)
	br label %endif11
endif11:
	%tmp61 = getelementptr inbounds %struct.Path, %struct.Path* %v8, i32 0, i32 1
	%tmp62 = load i8, i8* %tmp61
	%tmp63 = getelementptr inbounds [8 x i16], [8 x i16]* %v8, i32 0, i8 %tmp62
	%tmp64 = load i32, i32* %index
	%tmp65 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp64
	%tmp66 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp65, i32 0, i32 1
	%tmp67 = load i16, i16* %tmp66
	store i16 %tmp67, i16* %tmp63
	%tmp68 = getelementptr inbounds %struct.Path, %struct.Path* %v8, i32 0, i32 1
	%tmp69 = getelementptr inbounds %struct.Path, %struct.Path* %v8, i32 0, i32 1
	%tmp70 = load i8, i8* %tmp69
	%tmp71 = add i8 %tmp70, 1
	store i8 %tmp71, i8* %tmp68
	%tmp72 = load i32, i32* %index
	%tmp73 = add i32 %tmp72, 1
	store i32 %tmp73, i32* %index
	%tmp74 = load i32, i32* %index
	%tmp75 = icmp ult i32 %tmp74, %len
	br i1 %tmp75, label %logic_rhs_12, label %logic_end_12
logic_rhs_12:
	%tmp76 = load i32, i32* %index
	%tmp77 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp76
	%tmp78 = load i8, i8* %tmp77
	%tmp79 = icmp eq i8 %tmp78, 7
	br label %logic_end_12
logic_end_12:
	%tmp80 = phi i1 [%tmp75, %endif11], [%tmp79, %logic_rhs_12]
	br i1 %tmp80, label %then13, label %else13
then13:
	%tmp81 = load i32, i32* %index
	%tmp82 = add i32 %tmp81, 1
	%tmp83 = icmp uge i32 %tmp82, %len
	br i1 %tmp83, label %logic_end_14, label %logic_rhs_14
logic_rhs_14:
	%tmp84 = load i32, i32* %index
	%tmp85 = add i32 %tmp84, 1
	%tmp86 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp85
	%tmp87 = load i8, i8* %tmp86
	%tmp88 = icmp ne i8 %tmp87, 65
	br label %logic_end_14
logic_end_14:
	%tmp89 = phi i1 [%tmp83, %then13], [%tmp88, %logic_rhs_14]
	br i1 %tmp89, label %then15, label %endif15
then15:
	call void @process.throw(i8* @.str.201)
	br label %endif15
endif15:
	%tmp90 = load i32, i32* %index
	%tmp91 = add i32 %tmp90, 1
	store i32 %tmp91, i32* %index
	br label %endif13
else13:
	br label %loop_body8_exit
endif13:
	br label %loop_start8
loop_body8_exit:
	%tmp92 = getelementptr inbounds %struct.Path, %struct.Path* %v8, i32 0, i32 1
	%tmp93 = load i8, i8* %tmp92
	%tmp94 = sub i8 %tmp93, 1
	%tmp95 = getelementptr inbounds [8 x i16], [8 x i16]* %v8, i32 0, i8 %tmp94
	%tmp96 = load i16, i16* %tmp95
	store i16 %tmp96, i16* %v9
	%tmp97 = getelementptr inbounds %struct.Path, %struct.Path* %v8, i32 0, i32 1
	%tmp98 = getelementptr inbounds %struct.Path, %struct.Path* %v8, i32 0, i32 1
	%tmp99 = load i8, i8* %tmp98
	%tmp100 = sub i8 %tmp99, 1
	store i8 %tmp100, i8* %tmp97
	%tmp101 = load i32, i32* %index
	%tmp102 = icmp ult i32 %tmp101, %len
	br i1 %tmp102, label %logic_rhs_16, label %logic_end_16
logic_rhs_16:
	%tmp103 = load i32, i32* %index
	%tmp104 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp103
	%tmp105 = load i8, i8* %tmp104
	%tmp106 = icmp eq i8 %tmp105, 28
	br label %logic_end_16
logic_end_16:
	%tmp107 = phi i1 [%tmp102, %loop_body8_exit], [%tmp106, %logic_rhs_16]
	br i1 %tmp107, label %then17, label %else17
then17:
	%tmp108 = load i32, i32* %index
	%tmp109 = add i32 %tmp108, 1
	store i32 %tmp109, i32* %index
	%tmp110 = call %"struct.vector.Vec<%struct.Type>" @parse_generic_args(%struct.TokenData* %token_array, i32* %index, i32 %len)
	store %"struct.vector.Vec<%struct.Type>" %tmp110, %"struct.vector.Vec<%struct.Type>"* %v11
	%tmp111 = call i8* @mem.malloc(i64 24)
	store %struct.GenericType* %tmp111, %struct.GenericType** %v12
	%tmp112 = load %struct.GenericType*, %struct.GenericType** %v12
	%tmp113 = load i16, i16* %v9
	store i16 %tmp113, i16* %tmp112
	%tmp114 = load %struct.GenericType*, %struct.GenericType** %v12
	%tmp115 = getelementptr inbounds %struct.GenericType, %struct.GenericType* %tmp114, i32 0, i32 1
	%tmp116 = load %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %v11
	store %"struct.vector.Vec<%struct.Type>" %tmp116, %"struct.vector.Vec<%struct.Type>"* %tmp115
	store i32 4, i32* %v10
	%tmp117 = getelementptr inbounds %struct.Type, %struct.Type* %v10, i32 0, i32 1
	%tmp118 = load %struct.GenericType*, %struct.GenericType** %v12
	store i8* %tmp118, i8** %tmp117
; Variable gen_args is out.
	br label %endif17
else17:
	%tmp119 = call i8* @mem.malloc(i64 2)
	store %struct.NamedType* %tmp119, %struct.NamedType** %v13
	%tmp120 = load %struct.NamedType*, %struct.NamedType** %v13
	%tmp121 = load i16, i16* %v9
	store i16 %tmp121, i16* %tmp120
	store i32 0, i32* %v10
	%tmp122 = getelementptr inbounds %struct.Type, %struct.Type* %v10, i32 0, i32 1
	%tmp123 = load %struct.NamedType*, %struct.NamedType** %v13
	store i8* %tmp123, i8** %tmp122
	br label %endif17
endif17:
	%tmp124 = getelementptr inbounds %struct.Path, %struct.Path* %v8, i32 0, i32 1
	%tmp125 = load i8, i8* %tmp124
	%tmp126 = icmp ugt i8 %tmp125, 0
	br i1 %tmp126, label %then18, label %else18
then18:
	%tmp127 = call i8* @mem.malloc(i64 40)
	store %struct.NamespaceLinkType* %tmp127, %struct.NamespaceLinkType** %v14
	%tmp128 = load %struct.NamespaceLinkType*, %struct.NamespaceLinkType** %v14
	%tmp129 = load %struct.Path, %struct.Path* %v8
	store %struct.Path %tmp129, %struct.Path* %tmp128
	%tmp130 = load %struct.NamespaceLinkType*, %struct.NamespaceLinkType** %v14
	%tmp131 = getelementptr inbounds %struct.NamespaceLinkType, %struct.NamespaceLinkType* %tmp130, i32 0, i32 1
	%tmp132 = load %struct.Type, %struct.Type* %v10
	store %struct.Type %tmp132, %struct.Type* %tmp131
	store i32 3, i32* %v1
	%tmp133 = getelementptr inbounds %struct.Type, %struct.Type* %v1, i32 0, i32 1
	%tmp134 = load %struct.NamespaceLinkType*, %struct.NamespaceLinkType** %v14
	store i8* %tmp134, i8** %tmp133
	br label %endif18
else18:
	%tmp135 = load %struct.Type, %struct.Type* %v10
	store %struct.Type %tmp135, %struct.Type* %v1
	br label %endif18
endif18:
; Variable rval is out.
; Variable path is out.
	br label %endif7
else7:
	call void @process.throw(i8* @.str.202)
	br label %endif7
endif7:
	br label %endif6
endif6:
	br label %endif5
endif5:
	%tmp136 = load %struct.Type, %struct.Type* %v1
	%tmp137 = load i32, i32* %v0
	%tmp138 = call %struct.Type @wrap_in_pointers(%struct.Type %tmp136, i32 %tmp137)
; Variable t is out.
	ret %struct.Type %tmp138
}
define %struct.Expression @parse_expression_internal(%struct.TokenData* %tokens, i32* %index, i32 %len, i8 %min_precedence){
	%v0 = alloca %struct.Expression
	%v1 = alloca %struct.IntegerExpr*
	%v2 = alloca %struct.CharExpr*
	%v3 = alloca %struct.DecimalExpr*
	%v4 = alloca %struct.NameExpr*
	%v5 = alloca %struct.StringConstExpr*
	%v6 = alloca %struct.BoolExpr*
	%v7 = alloca %struct.BoolExpr*
	%v8 = alloca %struct.ArrayExpr*
	%v9 = alloca %struct.UnaryOpExpr*
	%v10 = alloca i32
	%v11 = alloca %struct.string.String
	%v12 = alloca i8
	%v13 = alloca i1
	%v14 = alloca %struct.CallExpr*
	%v15 = alloca %struct.IndexExpr*
	%v16 = alloca %struct.NameWithGenericsExpr*
	%v17 = alloca %struct.StructInitExpr*
	%v18 = alloca i16
	%v19 = alloca %struct.StructInitFieldExpr
	%v20 = alloca %struct.StaticAccessExpr*
	%v21 = alloca %struct.MemberAccessExpr*
	%v22 = alloca %struct.CastExpr*
	%v23 = alloca %struct.RangeExpr*
	%v24 = alloca i8
	%v25 = alloca %struct.BinaryOpExpr*
	%tmp0 = load i32, i32* %index
	%tmp1 = icmp uge i32 %tmp0, %len
	br i1 %tmp1, label %then0, label %endif0
then0:
	call void @process.throw(i8* @.str.203)
	br label %endif0
endif0:
	%tmp2 = load i32, i32* %index
	%tmp3 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp2
	%tmp4 = load i8, i8* %tmp3
	%tmp5 = icmp eq i8 %tmp4, 66
	br i1 %tmp5, label %then1, label %else1
then1:
	%tmp6 = call i8* @mem.malloc(i64 2)
	store %struct.IntegerExpr* %tmp6, %struct.IntegerExpr** %v1
	%tmp7 = load %struct.IntegerExpr*, %struct.IntegerExpr** %v1
	%tmp8 = load i32, i32* %index
	%tmp9 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp8
	%tmp10 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp9, i32 0, i32 1
	%tmp11 = load i16, i16* %tmp10
	store i16 %tmp11, i16* %tmp7
	store i32 0, i32* %v0
	%tmp12 = getelementptr inbounds %struct.Expression, %struct.Expression* %v0, i32 0, i32 1
	%tmp13 = load %struct.IntegerExpr*, %struct.IntegerExpr** %v1
	store i8* %tmp13, i8** %tmp12
	%tmp14 = load i32, i32* %index
	%tmp15 = add i32 %tmp14, 1
	store i32 %tmp15, i32* %index
	br label %endif1
else1:
	%tmp16 = icmp eq i8 %tmp4, 69
	br i1 %tmp16, label %then2, label %else2
then2:
	%tmp17 = call i8* @mem.malloc(i64 2)
	store %struct.CharExpr* %tmp17, %struct.CharExpr** %v2
	%tmp18 = load %struct.CharExpr*, %struct.CharExpr** %v2
	%tmp19 = load i32, i32* %index
	%tmp20 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp19
	%tmp21 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp20, i32 0, i32 1
	%tmp22 = load i16, i16* %tmp21
	store i16 %tmp22, i16* %tmp18
	store i32 1, i32* %v0
	%tmp23 = getelementptr inbounds %struct.Expression, %struct.Expression* %v0, i32 0, i32 1
	%tmp24 = load %struct.CharExpr*, %struct.CharExpr** %v2
	store i8* %tmp24, i8** %tmp23
	%tmp25 = load i32, i32* %index
	%tmp26 = add i32 %tmp25, 1
	store i32 %tmp26, i32* %index
	br label %endif2
else2:
	%tmp27 = icmp eq i8 %tmp4, 67
	br i1 %tmp27, label %then3, label %else3
then3:
	%tmp28 = call i8* @mem.malloc(i64 2)
	store %struct.DecimalExpr* %tmp28, %struct.DecimalExpr** %v3
	%tmp29 = load %struct.DecimalExpr*, %struct.DecimalExpr** %v3
	%tmp30 = load i32, i32* %index
	%tmp31 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp30
	%tmp32 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp31, i32 0, i32 1
	%tmp33 = load i16, i16* %tmp32
	store i16 %tmp33, i16* %tmp29
	store i32 2, i32* %v0
	%tmp34 = getelementptr inbounds %struct.Expression, %struct.Expression* %v0, i32 0, i32 1
	%tmp35 = load %struct.DecimalExpr*, %struct.DecimalExpr** %v3
	store i8* %tmp35, i8** %tmp34
	%tmp36 = load i32, i32* %index
	%tmp37 = add i32 %tmp36, 1
	store i32 %tmp37, i32* %index
	br label %endif3
else3:
	%tmp38 = icmp eq i8 %tmp4, 65
	br i1 %tmp38, label %then4, label %else4
then4:
	%tmp39 = call i8* @mem.malloc(i64 2)
	store %struct.NameExpr* %tmp39, %struct.NameExpr** %v4
	%tmp40 = load %struct.NameExpr*, %struct.NameExpr** %v4
	%tmp41 = load i32, i32* %index
	%tmp42 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp41
	%tmp43 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp42, i32 0, i32 1
	%tmp44 = load i16, i16* %tmp43
	store i16 %tmp44, i16* %tmp40
	store i32 3, i32* %v0
	%tmp45 = getelementptr inbounds %struct.Expression, %struct.Expression* %v0, i32 0, i32 1
	%tmp46 = load %struct.NameExpr*, %struct.NameExpr** %v4
	store i8* %tmp46, i8** %tmp45
	%tmp47 = load i32, i32* %index
	%tmp48 = add i32 %tmp47, 1
	store i32 %tmp48, i32* %index
	br label %endif4
else4:
	%tmp49 = icmp eq i8 %tmp4, 68
	br i1 %tmp49, label %then5, label %else5
then5:
	%tmp50 = call i8* @mem.malloc(i64 2)
	store %struct.StringConstExpr* %tmp50, %struct.StringConstExpr** %v5
	%tmp51 = load %struct.StringConstExpr*, %struct.StringConstExpr** %v5
	%tmp52 = load i32, i32* %index
	%tmp53 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp52
	%tmp54 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp53, i32 0, i32 1
	%tmp55 = load i16, i16* %tmp54
	store i16 %tmp55, i16* %tmp51
	store i32 4, i32* %v0
	%tmp56 = getelementptr inbounds %struct.Expression, %struct.Expression* %v0, i32 0, i32 1
	%tmp57 = load %struct.StringConstExpr*, %struct.StringConstExpr** %v5
	store i8* %tmp57, i8** %tmp56
	%tmp58 = load i32, i32* %index
	%tmp59 = add i32 %tmp58, 1
	store i32 %tmp59, i32* %index
	br label %endif5
else5:
	%tmp60 = icmp eq i8 %tmp4, 62
	br i1 %tmp60, label %then6, label %else6
then6:
	%tmp61 = call i8* @mem.malloc(i64 1)
	store %struct.BoolExpr* %tmp61, %struct.BoolExpr** %v6
	%tmp62 = load %struct.BoolExpr*, %struct.BoolExpr** %v6
	store i1 true, i1* %tmp62
	store i32 17, i32* %v0
	%tmp63 = getelementptr inbounds %struct.Expression, %struct.Expression* %v0, i32 0, i32 1
	%tmp64 = load %struct.BoolExpr*, %struct.BoolExpr** %v6
	store i8* %tmp64, i8** %tmp63
	%tmp65 = load i32, i32* %index
	%tmp66 = add i32 %tmp65, 1
	store i32 %tmp66, i32* %index
	br label %endif6
else6:
	%tmp67 = icmp eq i8 %tmp4, 63
	br i1 %tmp67, label %then7, label %else7
then7:
	%tmp68 = call i8* @mem.malloc(i64 1)
	store %struct.BoolExpr* %tmp68, %struct.BoolExpr** %v7
	%tmp69 = load %struct.BoolExpr*, %struct.BoolExpr** %v7
	store i1 false, i1* %tmp69
	store i32 17, i32* %v0
	%tmp70 = getelementptr inbounds %struct.Expression, %struct.Expression* %v0, i32 0, i32 1
	%tmp71 = load %struct.BoolExpr*, %struct.BoolExpr** %v7
	store i8* %tmp71, i8** %tmp70
	%tmp72 = load i32, i32* %index
	%tmp73 = add i32 %tmp72, 1
	store i32 %tmp73, i32* %index
	br label %endif7
else7:
	%tmp74 = icmp eq i8 %tmp4, 0
	br i1 %tmp74, label %then8, label %else8
then8:
	%tmp75 = load i32, i32* %index
	%tmp76 = add i32 %tmp75, 1
	store i32 %tmp76, i32* %index
	%tmp77 = call %struct.Expression @parse_expression_internal(%struct.TokenData* %tokens, i32* %index, i32 %len, i8 0)
	store %struct.Expression %tmp77, %struct.Expression* %v0
	call void @expect(%struct.TokenData* %tokens, i32* %index, i32 %len, i8 1, i8* @.str.204)
	br label %endif8
else8:
	%tmp78 = icmp eq i8 %tmp4, 4
	br i1 %tmp78, label %then9, label %else9
then9:
	%tmp79 = load i32, i32* %index
	%tmp80 = add i32 %tmp79, 1
	store i32 %tmp80, i32* %index
	%tmp81 = call i8* @mem.malloc(i64 16)
	store %struct.ArrayExpr* %tmp81, %struct.ArrayExpr** %v8
	%tmp82 = load %struct.ArrayExpr*, %struct.ArrayExpr** %v8
	%tmp83 = call %"struct.vector.Vec<%struct.Expression>" @"vector.new<%struct.Expression>"()
	store %"struct.vector.Vec<%struct.Expression>" %tmp83, %"struct.vector.Vec<%struct.Expression>"* %tmp82
	br label %loop_start10
loop_start10:
	%tmp84 = load i32, i32* %index
	%tmp85 = icmp ult i32 %tmp84, %len
	br i1 %tmp85, label %logic_rhs_11, label %logic_end_11
logic_rhs_11:
	%tmp86 = load i32, i32* %index
	%tmp87 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp86
	%tmp88 = load i8, i8* %tmp87
	%tmp89 = icmp ne i8 %tmp88, 5
	br label %logic_end_11
logic_end_11:
	%tmp90 = phi i1 [%tmp85, %loop_start10], [%tmp89, %logic_rhs_11]
	br i1 %tmp90, label %endif12, label %else12
else12:
	br label %loop_body10_exit
endif12:
	%tmp91 = load %struct.ArrayExpr*, %struct.ArrayExpr** %v8
	%tmp92 = call %struct.Expression @parse_expression_internal(%struct.TokenData* %tokens, i32* %index, i32 %len, i8 0)
	call void @"vector.push<%struct.Expression>"(%"struct.vector.Vec<%struct.Expression>"* %tmp91, %struct.Expression %tmp92)
	%tmp93 = load i32, i32* %index
	%tmp94 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp93
	%tmp95 = load i8, i8* %tmp94
	%tmp96 = icmp eq i8 %tmp95, 9
	br i1 %tmp96, label %then13, label %else13
then13:
	%tmp97 = load i32, i32* %index
	%tmp98 = add i32 %tmp97, 1
	store i32 %tmp98, i32* %index
	br label %endif13
else13:
	%tmp99 = load i32, i32* %index
	%tmp100 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp99
	%tmp101 = load i8, i8* %tmp100
	%tmp102 = icmp ne i8 %tmp101, 5
	br i1 %tmp102, label %then14, label %endif14
then14:
	call void @process.throw(i8* @.str.205)
	br label %endif14
endif14:
	br label %endif13
endif13:
	br label %loop_start10
loop_body10_exit:
	call void @expect(%struct.TokenData* %tokens, i32* %index, i32 %len, i8 5, i8* @.str.206)
	store i32 14, i32* %v0
	%tmp103 = getelementptr inbounds %struct.Expression, %struct.Expression* %v0, i32 0, i32 1
	%tmp104 = load %struct.ArrayExpr*, %struct.ArrayExpr** %v8
	store i8* %tmp104, i8** %tmp103
	br label %endif9
else9:
	%tmp105 = call i1 @is_prefix_operator(i8 %tmp4)
	br i1 %tmp105, label %then15, label %else15
then15:
	%tmp106 = load i32, i32* %index
	%tmp107 = add i32 %tmp106, 1
	store i32 %tmp107, i32* %index
	%tmp108 = call i8* @mem.malloc(i64 24)
	store %struct.UnaryOpExpr* %tmp108, %struct.UnaryOpExpr** %v9
	%tmp109 = load %struct.UnaryOpExpr*, %struct.UnaryOpExpr** %v9
	%tmp110 = getelementptr inbounds %struct.UnaryOpExpr, %struct.UnaryOpExpr* %tmp109, i32 0, i32 1
	%tmp111 = call i32 @get_unary_op(i8 %tmp4)
	store i32 %tmp111, i32* %tmp110
	%tmp112 = load %struct.UnaryOpExpr*, %struct.UnaryOpExpr** %v9
	%tmp113 = call %struct.Expression @parse_expression_internal(%struct.TokenData* %tokens, i32* %index, i32 %len, i8 13)
	store %struct.Expression %tmp113, %struct.Expression* %tmp112
	store i32 7, i32* %v0
	%tmp114 = getelementptr inbounds %struct.Expression, %struct.Expression* %v0, i32 0, i32 1
	%tmp115 = load %struct.UnaryOpExpr*, %struct.UnaryOpExpr** %v9
	store i8* %tmp115, i8** %tmp114
	br label %endif15
else15:
	%tmp116 = icmp eq i8 %tmp4, 64
	br i1 %tmp116, label %then16, label %else16
then16:
	store i32 18, i32* %v0
	%tmp117 = getelementptr inbounds %struct.Expression, %struct.Expression* %v0, i32 0, i32 1
	store i8* null, i8** %tmp117
	%tmp118 = load i32, i32* %index
	%tmp119 = add i32 %tmp118, 1
	store i32 %tmp119, i32* %index
	br label %endif16
else16:
	store i32 0, i32* %v10
	br label %loop_cond17
loop_cond17:
	%tmp120 = load i32, i32* %v10
	%tmp121 = icmp uge i32 %tmp120, 3
	br i1 %tmp121, label %then18, label %endif18
then18:
	br label %loop_body17_exit
endif18:
	%tmp122 = load i32, i32* %index
	%tmp123 = load i32, i32* %v10
	%tmp124 = add i32 %tmp122, %tmp123
	%tmp125 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp124
	%tmp126 = call %struct.string.String @token_type_to_string(%struct.TokenData* %tmp125, %"struct.vector.Vec<%struct.string.String>"* null)
	store %struct.string.String %tmp126, %struct.string.String* %v11
	call void @console.write(i8* @.str.147, i32 4)
	call void @console.write_string(%struct.string.String* %v11)
	call void @console.write(i8* @.str.148, i32 5)
	call void @string.free(%struct.string.String* %v11)
	%tmp127 = load i32, i32* %v10
	%tmp128 = add i32 %tmp127, 1
	store i32 %tmp128, i32* %v10
	br label %loop_cond17
loop_body17_exit:
; Variable q is out.
	call void @process.throw(i8* @.str.207)
	br label %endif16
endif16:
	br label %endif15
endif15:
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
	br label %endif2
endif2:
	br label %endif1
endif1:
	br label %loop_start19
loop_start19:
	%tmp129 = load i32, i32* %index
	%tmp130 = icmp ult i32 %tmp129, %len
	br i1 %tmp130, label %endif20, label %else20
else20:
	br label %loop_body19_exit
endif20:
	%tmp131 = load i32, i32* %index
	%tmp132 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp131
	%tmp133 = load i8, i8* %tmp132
	store i8 %tmp133, i8* %v12
	store i1 false, i1* %v13
	%tmp134 = load i8, i8* %v12
	%tmp135 = icmp eq i8 %tmp134, 8
	br i1 %tmp135, label %logic_end_21, label %logic_rhs_21
logic_rhs_21:
	%tmp136 = load i8, i8* %v12
	%tmp137 = icmp eq i8 %tmp136, 9
	br label %logic_end_21
logic_end_21:
	%tmp138 = phi i1 [%tmp135, %endif20], [%tmp137, %logic_rhs_21]
	br i1 %tmp138, label %logic_end_22, label %logic_rhs_22
logic_rhs_22:
	%tmp139 = load i8, i8* %v12
	%tmp140 = icmp eq i8 %tmp139, 1
	br label %logic_end_22
logic_end_22:
	%tmp141 = phi i1 [%tmp138, %logic_end_21], [%tmp140, %logic_rhs_22]
	br i1 %tmp141, label %logic_end_23, label %logic_rhs_23
logic_rhs_23:
	%tmp142 = load i8, i8* %v12
	%tmp143 = icmp eq i8 %tmp142, 3
	br label %logic_end_23
logic_end_23:
	%tmp144 = phi i1 [%tmp141, %logic_end_22], [%tmp143, %logic_rhs_23]
	br i1 %tmp144, label %logic_end_24, label %logic_rhs_24
logic_rhs_24:
	%tmp145 = load i8, i8* %v12
	%tmp146 = icmp eq i8 %tmp145, 5
	br label %logic_end_24
logic_end_24:
	%tmp147 = phi i1 [%tmp144, %logic_end_23], [%tmp146, %logic_rhs_24]
	br i1 %tmp147, label %then25, label %endif25
then25:
	br label %loop_body19_exit
endif25:
	%tmp148 = load i8, i8* %v12
	%tmp149 = icmp eq i8 %tmp148, 28
	br i1 %tmp149, label %logic_rhs_26, label %logic_end_26
logic_rhs_26:
	%tmp150 = load i32, i32* %index
	%tmp151 = add i32 %tmp150, 1
	%tmp152 = icmp ult i32 %tmp151, %len
	br label %logic_end_26
logic_end_26:
	%tmp153 = phi i1 [%tmp149, %endif25], [%tmp152, %logic_rhs_26]
	br i1 %tmp153, label %logic_rhs_27, label %logic_end_27
logic_rhs_27:
	%tmp154 = load i32, i32* %index
	%tmp155 = add i32 %tmp154, 1
	%tmp156 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp155
	%tmp157 = load i8, i8* %tmp156
	%tmp158 = icmp eq i8 %tmp157, 28
	br label %logic_end_27
logic_end_27:
	%tmp159 = phi i1 [%tmp153, %logic_end_26], [%tmp158, %logic_rhs_27]
	br i1 %tmp159, label %then28, label %else28
then28:
	store i8 34, i8* %v12
	store i1 true, i1* %v13
	br label %endif28
else28:
	%tmp160 = load i8, i8* %v12
	%tmp161 = icmp eq i8 %tmp160, 26
	br i1 %tmp161, label %logic_rhs_29, label %logic_end_29
logic_rhs_29:
	%tmp162 = load i32, i32* %index
	%tmp163 = add i32 %tmp162, 1
	%tmp164 = icmp ult i32 %tmp163, %len
	br label %logic_end_29
logic_end_29:
	%tmp165 = phi i1 [%tmp161, %else28], [%tmp164, %logic_rhs_29]
	br i1 %tmp165, label %logic_rhs_30, label %logic_end_30
logic_rhs_30:
	%tmp166 = load i32, i32* %index
	%tmp167 = add i32 %tmp166, 1
	%tmp168 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp167
	%tmp169 = load i8, i8* %tmp168
	%tmp170 = icmp eq i8 %tmp169, 26
	br label %logic_end_30
logic_end_30:
	%tmp171 = phi i1 [%tmp165, %logic_end_29], [%tmp170, %logic_rhs_30]
	br i1 %tmp171, label %then31, label %endif31
then31:
	store i8 35, i8* %v12
	store i1 true, i1* %v13
	br label %endif31
endif31:
	br label %endif28
endif28:
	%tmp172 = load i8, i8* %v12
	%tmp173 = call i8 @precedence(i8 %tmp172)
	%tmp174 = icmp eq i8 %tmp173, 0
	br i1 %tmp174, label %logic_end_32, label %logic_rhs_32
logic_rhs_32:
	%tmp175 = icmp ult i8 %tmp173, %min_precedence
	br label %logic_end_32
logic_end_32:
	%tmp176 = phi i1 [%tmp174, %endif28], [%tmp175, %logic_rhs_32]
	br i1 %tmp176, label %then33, label %endif33
then33:
	br label %loop_body19_exit
endif33:
	%tmp177 = load i32, i32* %index
	%tmp178 = add i32 %tmp177, 1
	store i32 %tmp178, i32* %index
	%tmp179 = load i1, i1* %v13
	br i1 %tmp179, label %then34, label %endif34
then34:
	%tmp180 = load i32, i32* %index
	%tmp181 = add i32 %tmp180, 1
	store i32 %tmp181, i32* %index
	br label %endif34
endif34:
	%tmp182 = load i8, i8* %v12
	%tmp183 = icmp eq i8 %tmp182, 0
	br i1 %tmp183, label %then35, label %else35
then35:
	%tmp184 = call i8* @mem.malloc(i64 48)
	store %struct.CallExpr* %tmp184, %struct.CallExpr** %v14
	%tmp185 = load %struct.CallExpr*, %struct.CallExpr** %v14
	%tmp186 = load %struct.Expression, %struct.Expression* %v0
	store %struct.Expression %tmp186, %struct.Expression* %tmp185
	%tmp187 = load %struct.CallExpr*, %struct.CallExpr** %v14
	%tmp188 = getelementptr inbounds %struct.CallExpr, %struct.CallExpr* %tmp187, i32 0, i32 1
	%tmp189 = call %"struct.vector.Vec<%struct.Expression>" @"vector.new<%struct.Expression>"()
	store %"struct.vector.Vec<%struct.Expression>" %tmp189, %"struct.vector.Vec<%struct.Expression>"* %tmp188
	%tmp190 = load %struct.CallExpr*, %struct.CallExpr** %v14
	%tmp191 = getelementptr inbounds %struct.CallExpr, %struct.CallExpr* %tmp190, i32 0, i32 2
	%tmp192 = call %"struct.vector.Vec<%struct.Type>" @"vector.new<%struct.Type>"()
	store %"struct.vector.Vec<%struct.Type>" %tmp192, %"struct.vector.Vec<%struct.Type>"* %tmp191
	br label %loop_start36
loop_start36:
	%tmp193 = load i32, i32* %index
	%tmp194 = icmp ult i32 %tmp193, %len
	br i1 %tmp194, label %logic_rhs_37, label %logic_end_37
logic_rhs_37:
	%tmp195 = load i32, i32* %index
	%tmp196 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp195
	%tmp197 = load i8, i8* %tmp196
	%tmp198 = icmp ne i8 %tmp197, 1
	br label %logic_end_37
logic_end_37:
	%tmp199 = phi i1 [%tmp194, %loop_start36], [%tmp198, %logic_rhs_37]
	br i1 %tmp199, label %endif38, label %else38
else38:
	br label %loop_body36_exit
endif38:
	%tmp200 = load %struct.CallExpr*, %struct.CallExpr** %v14
	%tmp201 = getelementptr inbounds %struct.CallExpr, %struct.CallExpr* %tmp200, i32 0, i32 1
	%tmp202 = call %struct.Expression @parse_expression_internal(%struct.TokenData* %tokens, i32* %index, i32 %len, i8 0)
	call void @"vector.push<%struct.Expression>"(%"struct.vector.Vec<%struct.Expression>"* %tmp201, %struct.Expression %tmp202)
	%tmp203 = load i32, i32* %index
	%tmp204 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp203
	%tmp205 = load i8, i8* %tmp204
	%tmp206 = icmp eq i8 %tmp205, 9
	br i1 %tmp206, label %then39, label %else39
then39:
	%tmp207 = load i32, i32* %index
	%tmp208 = add i32 %tmp207, 1
	store i32 %tmp208, i32* %index
	br label %endif39
else39:
	%tmp209 = load i32, i32* %index
	%tmp210 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp209
	%tmp211 = load i8, i8* %tmp210
	%tmp212 = icmp ne i8 %tmp211, 1
	br i1 %tmp212, label %then40, label %endif40
then40:
	call void @process.throw(i8* @.str.208)
	br label %endif40
endif40:
	br label %endif39
endif39:
	br label %loop_start36
loop_body36_exit:
	call void @expect(%struct.TokenData* %tokens, i32* %index, i32 %len, i8 1, i8* @.str.23)
	store i32 12, i32* %v0
	%tmp213 = getelementptr inbounds %struct.Expression, %struct.Expression* %v0, i32 0, i32 1
	%tmp214 = load %struct.CallExpr*, %struct.CallExpr** %v14
	store i8* %tmp214, i8** %tmp213
	br label %endif35
else35:
	%tmp215 = load i8, i8* %v12
	%tmp216 = icmp eq i8 %tmp215, 4
	br i1 %tmp216, label %then41, label %else41
then41:
	%tmp217 = call i8* @mem.malloc(i64 32)
	store %struct.IndexExpr* %tmp217, %struct.IndexExpr** %v15
	%tmp218 = load %struct.IndexExpr*, %struct.IndexExpr** %v15
	%tmp219 = load %struct.Expression, %struct.Expression* %v0
	store %struct.Expression %tmp219, %struct.Expression* %tmp218
	%tmp220 = load %struct.IndexExpr*, %struct.IndexExpr** %v15
	%tmp221 = getelementptr inbounds %struct.IndexExpr, %struct.IndexExpr* %tmp220, i32 0, i32 1
	%tmp222 = call %struct.Expression @parse_expression_internal(%struct.TokenData* %tokens, i32* %index, i32 %len, i8 0)
	store %struct.Expression %tmp222, %struct.Expression* %tmp221
	call void @expect(%struct.TokenData* %tokens, i32* %index, i32 %len, i8 5, i8* @.str.209)
	store i32 13, i32* %v0
	%tmp223 = getelementptr inbounds %struct.Expression, %struct.Expression* %v0, i32 0, i32 1
	%tmp224 = load %struct.IndexExpr*, %struct.IndexExpr** %v15
	store i8* %tmp224, i8** %tmp223
	br label %endif41
else41:
	%tmp225 = load i8, i8* %v12
	%tmp226 = icmp eq i8 %tmp225, 7
	br i1 %tmp226, label %then42, label %else42
then42:
	%tmp227 = load i32, i32* %index
	%tmp228 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp227
	%tmp229 = load i8, i8* %tmp228
	%tmp230 = icmp eq i8 %tmp229, 28
	br i1 %tmp230, label %then43, label %else43
then43:
	%tmp231 = load i32, i32* %index
	%tmp232 = add i32 %tmp231, 1
	store i32 %tmp232, i32* %index
	%tmp233 = call i8* @mem.malloc(i64 32)
	store %struct.NameWithGenericsExpr* %tmp233, %struct.NameWithGenericsExpr** %v16
	%tmp234 = load %struct.NameWithGenericsExpr*, %struct.NameWithGenericsExpr** %v16
	%tmp235 = load %struct.Expression, %struct.Expression* %v0
	store %struct.Expression %tmp235, %struct.Expression* %tmp234
	%tmp236 = load %struct.NameWithGenericsExpr*, %struct.NameWithGenericsExpr** %v16
	%tmp237 = getelementptr inbounds %struct.NameWithGenericsExpr, %struct.NameWithGenericsExpr* %tmp236, i32 0, i32 1
	%tmp238 = call %"struct.vector.Vec<%struct.Type>" @"vector.new<%struct.Type>"()
	store %"struct.vector.Vec<%struct.Type>" %tmp238, %"struct.vector.Vec<%struct.Type>"* %tmp237
	br label %loop_start44
loop_start44:
	%tmp239 = load i32, i32* %index
	%tmp240 = icmp ult i32 %tmp239, %len
	br i1 %tmp240, label %logic_rhs_45, label %logic_end_45
logic_rhs_45:
	%tmp241 = load i32, i32* %index
	%tmp242 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp241
	%tmp243 = load i8, i8* %tmp242
	%tmp244 = icmp ne i8 %tmp243, 26
	br label %logic_end_45
logic_end_45:
	%tmp245 = phi i1 [%tmp240, %loop_start44], [%tmp244, %logic_rhs_45]
	br i1 %tmp245, label %endif46, label %else46
else46:
	br label %loop_body44_exit
endif46:
	%tmp246 = load %struct.NameWithGenericsExpr*, %struct.NameWithGenericsExpr** %v16
	%tmp247 = getelementptr inbounds %struct.NameWithGenericsExpr, %struct.NameWithGenericsExpr* %tmp246, i32 0, i32 1
	%tmp248 = call %struct.Type @parse_type(%struct.TokenData* %tokens, i32* %index, i32 %len)
	call void @"vector.push<%struct.Type>"(%"struct.vector.Vec<%struct.Type>"* %tmp247, %struct.Type %tmp248)
	%tmp249 = load i32, i32* %index
	%tmp250 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp249
	%tmp251 = load i8, i8* %tmp250
	%tmp252 = icmp eq i8 %tmp251, 9
	br i1 %tmp252, label %then47, label %else47
then47:
	%tmp253 = load i32, i32* %index
	%tmp254 = add i32 %tmp253, 1
	store i32 %tmp254, i32* %index
	br label %endif47
else47:
	%tmp255 = load i32, i32* %index
	%tmp256 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp255
	%tmp257 = load i8, i8* %tmp256
	%tmp258 = icmp ne i8 %tmp257, 26
	br i1 %tmp258, label %then48, label %endif48
then48:
	call void @process.throw(i8* @.str.210)
	br label %endif48
endif48:
	br label %endif47
endif47:
	br label %loop_start44
loop_body44_exit:
	call void @expect(%struct.TokenData* %tokens, i32* %index, i32 %len, i8 26, i8* @.str.211)
	store i32 11, i32* %v0
	%tmp259 = getelementptr inbounds %struct.Expression, %struct.Expression* %v0, i32 0, i32 1
	%tmp260 = load %struct.NameWithGenericsExpr*, %struct.NameWithGenericsExpr** %v16
	store i8* %tmp260, i8** %tmp259
	br label %endif43
else43:
	%tmp261 = load i32, i32* %index
	%tmp262 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp261
	%tmp263 = load i8, i8* %tmp262
	%tmp264 = icmp eq i8 %tmp263, 2
	br i1 %tmp264, label %then49, label %else49
then49:
	%tmp265 = load i32, i32* %index
	%tmp266 = add i32 %tmp265, 1
	store i32 %tmp266, i32* %index
	%tmp267 = call i8* @mem.malloc(i64 32)
	store %struct.StructInitExpr* %tmp267, %struct.StructInitExpr** %v17
	%tmp268 = load %struct.StructInitExpr*, %struct.StructInitExpr** %v17
	%tmp269 = getelementptr inbounds %struct.StructInitExpr, %struct.StructInitExpr* %tmp268, i32 0, i32 1
	%tmp270 = call %"struct.vector.Vec<%struct.StructInitFieldExpr>" @"vector.new<%struct.StructInitFieldExpr>"()
	store %"struct.vector.Vec<%struct.StructInitFieldExpr>" %tmp270, %"struct.vector.Vec<%struct.StructInitFieldExpr>"* %tmp269
	br label %loop_start50
loop_start50:
	%tmp271 = load i32, i32* %index
	%tmp272 = icmp ult i32 %tmp271, %len
	br i1 %tmp272, label %logic_rhs_51, label %logic_end_51
logic_rhs_51:
	%tmp273 = load i32, i32* %index
	%tmp274 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp273
	%tmp275 = load i8, i8* %tmp274
	%tmp276 = icmp ne i8 %tmp275, 3
	br label %logic_end_51
logic_end_51:
	%tmp277 = phi i1 [%tmp272, %loop_start50], [%tmp276, %logic_rhs_51]
	br i1 %tmp277, label %endif52, label %else52
else52:
	br label %loop_body50_exit
endif52:
	%tmp278 = load i32, i32* %index
	%tmp279 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp278
	%tmp280 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp279, i32 0, i32 1
	%tmp281 = load i16, i16* %tmp280
	store i16 %tmp281, i16* %v18
	call void @expect(%struct.TokenData* %tokens, i32* %index, i32 %len, i8 65, i8* @.str.212)
	call void @expect(%struct.TokenData* %tokens, i32* %index, i32 %len, i8 6, i8* @.str.127)
	%tmp282 = load i16, i16* %v18
	store i16 %tmp282, i16* %v19
	%tmp283 = getelementptr inbounds %struct.StructInitFieldExpr, %struct.StructInitFieldExpr* %v19, i32 0, i32 1
	%tmp284 = call %struct.Expression @parse_expression_internal(%struct.TokenData* %tokens, i32* %index, i32 %len, i8 0)
	store %struct.Expression %tmp284, %struct.Expression* %tmp283
	%tmp285 = load %struct.StructInitExpr*, %struct.StructInitExpr** %v17
	%tmp286 = getelementptr inbounds %struct.StructInitExpr, %struct.StructInitExpr* %tmp285, i32 0, i32 1
	%tmp287 = load %struct.StructInitFieldExpr, %struct.StructInitFieldExpr* %v19
	call void @"vector.push<%struct.StructInitFieldExpr>"(%"struct.vector.Vec<%struct.StructInitFieldExpr>"* %tmp286, %struct.StructInitFieldExpr %tmp287)
	%tmp288 = load i32, i32* %index
	%tmp289 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp288
	%tmp290 = load i8, i8* %tmp289
	%tmp291 = icmp eq i8 %tmp290, 9
	br i1 %tmp291, label %then53, label %else53
then53:
	%tmp292 = load i32, i32* %index
	%tmp293 = add i32 %tmp292, 1
	store i32 %tmp293, i32* %index
	br label %endif53
else53:
	%tmp294 = load i32, i32* %index
	%tmp295 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp294
	%tmp296 = load i8, i8* %tmp295
	%tmp297 = icmp ne i8 %tmp296, 3
	br i1 %tmp297, label %then54, label %endif54
then54:
	call void @process.throw(i8* @.str.213)
	br label %endif54
endif54:
	br label %endif53
endif53:
	br label %loop_start50
loop_body50_exit:
; Variable fe is out.
	call void @expect(%struct.TokenData* %tokens, i32* %index, i32 %len, i8 3, i8* @.str.214)
	store i32 15, i32* %v0
	%tmp298 = getelementptr inbounds %struct.Expression, %struct.Expression* %v0, i32 0, i32 1
	%tmp299 = load %struct.StructInitExpr*, %struct.StructInitExpr** %v17
	store i8* %tmp299, i8** %tmp298
	br label %endif49
else49:
	%tmp300 = call i8* @mem.malloc(i64 24)
	store %struct.StaticAccessExpr* %tmp300, %struct.StaticAccessExpr** %v20
	%tmp301 = load %struct.StaticAccessExpr*, %struct.StaticAccessExpr** %v20
	%tmp302 = load %struct.Expression, %struct.Expression* %v0
	store %struct.Expression %tmp302, %struct.Expression* %tmp301
	%tmp303 = load i32, i32* %index
	%tmp304 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp303
	%tmp305 = load i8, i8* %tmp304
	%tmp306 = icmp ne i8 %tmp305, 65
	br i1 %tmp306, label %then55, label %endif55
then55:
	call void @process.throw(i8* @.str.215)
	br label %endif55
endif55:
	%tmp307 = load %struct.StaticAccessExpr*, %struct.StaticAccessExpr** %v20
	%tmp308 = getelementptr inbounds %struct.StaticAccessExpr, %struct.StaticAccessExpr* %tmp307, i32 0, i32 1
	%tmp309 = load i32, i32* %index
	%tmp310 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp309
	%tmp311 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp310, i32 0, i32 1
	%tmp312 = load i16, i16* %tmp311
	store i16 %tmp312, i16* %tmp308
	%tmp313 = load i32, i32* %index
	%tmp314 = add i32 %tmp313, 1
	store i32 %tmp314, i32* %index
	store i32 10, i32* %v0
	%tmp315 = getelementptr inbounds %struct.Expression, %struct.Expression* %v0, i32 0, i32 1
	%tmp316 = load %struct.StaticAccessExpr*, %struct.StaticAccessExpr** %v20
	store i8* %tmp316, i8** %tmp315
	br label %endif49
endif49:
	br label %endif43
endif43:
	br label %endif42
else42:
	%tmp317 = load i8, i8* %v12
	%tmp318 = icmp eq i8 %tmp317, 10
	br i1 %tmp318, label %then56, label %else56
then56:
	%tmp319 = call i8* @mem.malloc(i64 24)
	store %struct.MemberAccessExpr* %tmp319, %struct.MemberAccessExpr** %v21
	%tmp320 = load %struct.MemberAccessExpr*, %struct.MemberAccessExpr** %v21
	%tmp321 = load %struct.Expression, %struct.Expression* %v0
	store %struct.Expression %tmp321, %struct.Expression* %tmp320
	%tmp322 = load i32, i32* %index
	%tmp323 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp322
	%tmp324 = load i8, i8* %tmp323
	%tmp325 = icmp ne i8 %tmp324, 65
	br i1 %tmp325, label %then57, label %endif57
then57:
	call void @process.throw(i8* @.str.216)
	br label %endif57
endif57:
	%tmp326 = load %struct.MemberAccessExpr*, %struct.MemberAccessExpr** %v21
	%tmp327 = getelementptr inbounds %struct.MemberAccessExpr, %struct.MemberAccessExpr* %tmp326, i32 0, i32 1
	%tmp328 = load i32, i32* %index
	%tmp329 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tokens, i32 %tmp328
	%tmp330 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %tmp329, i32 0, i32 1
	%tmp331 = load i16, i16* %tmp330
	store i16 %tmp331, i16* %tmp327
	%tmp332 = load i32, i32* %index
	%tmp333 = add i32 %tmp332, 1
	store i32 %tmp333, i32* %index
	store i32 9, i32* %v0
	%tmp334 = getelementptr inbounds %struct.Expression, %struct.Expression* %v0, i32 0, i32 1
	%tmp335 = load %struct.MemberAccessExpr*, %struct.MemberAccessExpr** %v21
	store i8* %tmp335, i8** %tmp334
	br label %endif56
else56:
	%tmp336 = load i8, i8* %v12
	%tmp337 = icmp eq i8 %tmp336, 44
	br i1 %tmp337, label %then58, label %else58
then58:
	%tmp338 = call i8* @mem.malloc(i64 32)
	store %struct.CastExpr* %tmp338, %struct.CastExpr** %v22
	%tmp339 = load %struct.CastExpr*, %struct.CastExpr** %v22
	%tmp340 = load %struct.Expression, %struct.Expression* %v0
	store %struct.Expression %tmp340, %struct.Expression* %tmp339
	%tmp341 = load %struct.CastExpr*, %struct.CastExpr** %v22
	%tmp342 = getelementptr inbounds %struct.CastExpr, %struct.CastExpr* %tmp341, i32 0, i32 1
	%tmp343 = call %struct.Type @parse_type(%struct.TokenData* %tokens, i32* %index, i32 %len)
	store %struct.Type %tmp343, %struct.Type* %tmp342
	store i32 8, i32* %v0
	%tmp344 = getelementptr inbounds %struct.Expression, %struct.Expression* %v0, i32 0, i32 1
	%tmp345 = load %struct.CastExpr*, %struct.CastExpr** %v22
	store i8* %tmp345, i8** %tmp344
	br label %endif58
else58:
	%tmp346 = load i8, i8* %v12
	%tmp347 = icmp eq i8 %tmp346, 11
	br i1 %tmp347, label %logic_end_59, label %logic_rhs_59
logic_rhs_59:
	%tmp348 = load i8, i8* %v12
	%tmp349 = icmp eq i8 %tmp348, 12
	br label %logic_end_59
logic_end_59:
	%tmp350 = phi i1 [%tmp347, %else58], [%tmp349, %logic_rhs_59]
	br i1 %tmp350, label %then60, label %else60
then60:
	%tmp351 = call i8* @mem.malloc(i64 40)
	store %struct.RangeExpr* %tmp351, %struct.RangeExpr** %v23
	%tmp352 = load %struct.RangeExpr*, %struct.RangeExpr** %v23
	%tmp353 = load %struct.Expression, %struct.Expression* %v0
	store %struct.Expression %tmp353, %struct.Expression* %tmp352
	%tmp354 = load %struct.RangeExpr*, %struct.RangeExpr** %v23
	%tmp355 = getelementptr inbounds %struct.RangeExpr, %struct.RangeExpr* %tmp354, i32 0, i32 2
	%tmp356 = load i8, i8* %v12
	%tmp357 = icmp eq i8 %tmp356, 12
	store i1 %tmp357, i1* %tmp355
	%tmp358 = load %struct.RangeExpr*, %struct.RangeExpr** %v23
	%tmp359 = getelementptr inbounds %struct.RangeExpr, %struct.RangeExpr* %tmp358, i32 0, i32 1
	%tmp360 = call %struct.Expression @parse_expression_internal(%struct.TokenData* %tokens, i32* %index, i32 %len, i8 %tmp173)
	store %struct.Expression %tmp360, %struct.Expression* %tmp359
	store i32 16, i32* %v0
	%tmp361 = getelementptr inbounds %struct.Expression, %struct.Expression* %v0, i32 0, i32 1
	%tmp362 = load %struct.RangeExpr*, %struct.RangeExpr** %v23
	store i8* %tmp362, i8** %tmp361
	br label %endif60
else60:
	%tmp363 = add i8 %tmp173, 1
	store i8 %tmp363, i8* %v24
	%tmp364 = load i8, i8* %v12
	%tmp365 = icmp eq i8 %tmp364, 15
	br i1 %tmp365, label %then61, label %endif61
then61:
	store i8 %tmp173, i8* %v24
	br label %endif61
endif61:
	%tmp366 = call i8* @mem.malloc(i64 40)
	store %struct.BinaryOpExpr* %tmp366, %struct.BinaryOpExpr** %v25
	%tmp367 = load %struct.BinaryOpExpr*, %struct.BinaryOpExpr** %v25
	%tmp368 = load %struct.Expression, %struct.Expression* %v0
	store %struct.Expression %tmp368, %struct.Expression* %tmp367
	%tmp369 = load %struct.BinaryOpExpr*, %struct.BinaryOpExpr** %v25
	%tmp370 = getelementptr inbounds %struct.BinaryOpExpr, %struct.BinaryOpExpr* %tmp369, i32 0, i32 2
	%tmp371 = load i8, i8* %v12
	%tmp372 = call i32 @get_binary_op(i8 %tmp371)
	store i32 %tmp372, i32* %tmp370
	%tmp373 = load %struct.BinaryOpExpr*, %struct.BinaryOpExpr** %v25
	%tmp374 = getelementptr inbounds %struct.BinaryOpExpr, %struct.BinaryOpExpr* %tmp373, i32 0, i32 1
	%tmp375 = load i8, i8* %v24
	%tmp376 = call %struct.Expression @parse_expression_internal(%struct.TokenData* %tokens, i32* %index, i32 %len, i8 %tmp375)
	store %struct.Expression %tmp376, %struct.Expression* %tmp374
	store i32 6, i32* %v0
	%tmp377 = getelementptr inbounds %struct.Expression, %struct.Expression* %v0, i32 0, i32 1
	%tmp378 = load %struct.BinaryOpExpr*, %struct.BinaryOpExpr** %v25
	store i8* %tmp378, i8** %tmp377
	br label %endif60
endif60:
	br label %endif58
endif58:
	br label %endif56
endif56:
	br label %endif42
endif42:
	br label %endif41
endif41:
	br label %endif35
endif35:
	br label %loop_start19
loop_body19_exit:
	%tmp379 = load %struct.Expression, %struct.Expression* %v0
; Variable expr is out.
	ret %struct.Expression %tmp379
}
define i1 @is_expression_starter(i8 %token){
entry:
	%tmp0 = icmp eq i8 %token, 65
	br i1 %tmp0, label %logic_end_0, label %logic_rhs_0
logic_rhs_0:
	%tmp1 = icmp eq i8 %token, 66
	br label %logic_end_0
logic_end_0:
	%tmp2 = phi i1 [%tmp0, %entry], [%tmp1, %logic_rhs_0]
	br i1 %tmp2, label %logic_end_1, label %logic_rhs_1
logic_rhs_1:
	%tmp3 = icmp eq i8 %token, 67
	br label %logic_end_1
logic_end_1:
	%tmp4 = phi i1 [%tmp2, %logic_end_0], [%tmp3, %logic_rhs_1]
	br i1 %tmp4, label %logic_end_2, label %logic_rhs_2
logic_rhs_2:
	%tmp5 = icmp eq i8 %token, 68
	br label %logic_end_2
logic_end_2:
	%tmp6 = phi i1 [%tmp4, %logic_end_1], [%tmp5, %logic_rhs_2]
	br i1 %tmp6, label %logic_end_3, label %logic_rhs_3
logic_rhs_3:
	%tmp7 = icmp eq i8 %token, 69
	br label %logic_end_3
logic_end_3:
	%tmp8 = phi i1 [%tmp6, %logic_end_2], [%tmp7, %logic_rhs_3]
	br i1 %tmp8, label %logic_end_4, label %logic_rhs_4
logic_rhs_4:
	%tmp9 = icmp eq i8 %token, 62
	br label %logic_end_4
logic_end_4:
	%tmp10 = phi i1 [%tmp8, %logic_end_3], [%tmp9, %logic_rhs_4]
	br i1 %tmp10, label %logic_end_5, label %logic_rhs_5
logic_rhs_5:
	%tmp11 = icmp eq i8 %token, 63
	br label %logic_end_5
logic_end_5:
	%tmp12 = phi i1 [%tmp10, %logic_end_4], [%tmp11, %logic_rhs_5]
	br i1 %tmp12, label %logic_end_6, label %logic_rhs_6
logic_rhs_6:
	%tmp13 = icmp eq i8 %token, 64
	br label %logic_end_6
logic_end_6:
	%tmp14 = phi i1 [%tmp12, %logic_end_5], [%tmp13, %logic_rhs_6]
	br i1 %tmp14, label %logic_end_7, label %logic_rhs_7
logic_rhs_7:
	%tmp15 = icmp eq i8 %token, 59
	br label %logic_end_7
logic_end_7:
	%tmp16 = phi i1 [%tmp14, %logic_end_6], [%tmp15, %logic_rhs_7]
	br i1 %tmp16, label %logic_end_8, label %logic_rhs_8
logic_rhs_8:
	%tmp17 = icmp eq i8 %token, 0
	br label %logic_end_8
logic_end_8:
	%tmp18 = phi i1 [%tmp16, %logic_end_7], [%tmp17, %logic_rhs_8]
	br i1 %tmp18, label %logic_end_9, label %logic_rhs_9
logic_rhs_9:
	%tmp19 = icmp eq i8 %token, 4
	br label %logic_end_9
logic_end_9:
	%tmp20 = phi i1 [%tmp18, %logic_end_8], [%tmp19, %logic_rhs_9]
	br i1 %tmp20, label %logic_end_10, label %logic_rhs_10
logic_rhs_10:
	%tmp21 = icmp eq i8 %token, 10
	br label %logic_end_10
logic_end_10:
	%tmp22 = phi i1 [%tmp20, %logic_end_9], [%tmp21, %logic_rhs_10]
	br i1 %tmp22, label %then11, label %endif11
then11:
	br label %func_exit
endif11:
	%tmp23 = call i1 @is_prefix_operator(i8 %token)
	br label %func_exit
func_exit:
	%tmp24 = phi i1 [true, %then11], [%tmp23, %endif11]
	ret i1 %tmp24
}
define i16 @insert_symbol(i8* %data, i32 %len, %"struct.vector.Vec<%struct.string.String>"* %symbols){
	%v0 = alloca i32
	%v1 = alloca i16
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %symbols, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	store i32 0, i32* %v0
	br label %loop_cond0
loop_cond0:
	%tmp2 = load i32, i32* %v0
	%tmp3 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %symbols, i32 0, i32 1
	%tmp4 = load i32, i32* %tmp3
	%tmp5 = icmp uge i32 %tmp2, %tmp4
	br i1 %tmp5, label %then1, label %endif1
then1:
	br label %loop_body0_exit
endif1:
	%tmp6 = load i32, i32* %v0
	%tmp7 = load %struct.string.String*, %struct.string.String** %symbols
	%tmp8 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp7, i32 %tmp6
	%tmp9 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp8, i32 0, i32 1
	%tmp10 = load i32, i32* %tmp9
	%tmp11 = icmp ne i32 %tmp10, %len
	br i1 %tmp11, label %then2, label %endif2
then2:
	br label %loop_body0
endif2:
	%tmp12 = load i32, i32* %v0
	%tmp13 = load %struct.string.String*, %struct.string.String** %symbols
	%tmp14 = getelementptr inbounds %struct.string.String, %struct.string.String* %tmp13, i32 %tmp12
	%tmp15 = load i8*, i8** %tmp14
	%tmp16 = sext i32 %len to i64
	%tmp17 = call i32 @mem.compare(i8* %data, i8* %tmp15, i64 %tmp16)
	%tmp18 = icmp eq i32 %tmp17, 0
	br i1 %tmp18, label %then3, label %endif3
then3:
	%tmp19 = load i32, i32* %v0
	%tmp20 = trunc i32 %tmp19 to i16
	br label %func_exit
endif3:
	br label %loop_body0
loop_body0:
	%tmp21 = load i32, i32* %v0
	%tmp22 = add i32 %tmp21, 1
	store i32 %tmp22, i32* %v0
	br label %loop_cond0
loop_body0_exit:
	%tmp23 = getelementptr inbounds %"struct.vector.Vec<%struct.string.String>", %"struct.vector.Vec<%struct.string.String>"* %symbols, i32 0, i32 1
	%tmp24 = load i32, i32* %tmp23
	%tmp25 = trunc i32 %tmp24 to i16
	store i16 %tmp25, i16* %v1
	%tmp26 = call %struct.string.String @string.from_data(i8* %data, i32 %len)
	call void @"vector.push<%struct.string.String>"(%"struct.vector.Vec<%struct.string.String>"* %symbols, %struct.string.String %tmp26)
	%tmp27 = load i16, i16* %v1
	br label %func_exit
func_exit:
	%tmp28 = phi i16 [%tmp20, %then3], [%tmp27, %loop_body0_exit]
	ret i16 %tmp28
}
define void @mem.fill(i8 %val, i8* %dest, i64 %len){
	call void @"mem.default_fill<i8>"(i8 %val, i8* %dest, i64 %len)
	ret void
}
define %struct.Type @wrap_in_pointers(%struct.Type %base, i32 %depth){
	%v0 = alloca %struct.PointerType*
	%v1 = alloca %struct.Type
	%tmp0 = icmp eq i32 %depth, 0
	br i1 %tmp0, label %then0, label %endif0
then0:
	br label %func_exit
endif0:
	%tmp1 = icmp ugt i32 %depth, 255
	br i1 %tmp1, label %then1, label %endif1
then1:
	call void @process.throw(i8* @.str.217)
	br label %endif1
endif1:
	%tmp2 = call i8* @mem.malloc(i64 24)
	store %struct.PointerType* %tmp2, %struct.PointerType** %v0
	%tmp3 = load %struct.PointerType*, %struct.PointerType** %v0
	%tmp4 = trunc i32 %depth to i8
	store i8 %tmp4, i8* %tmp3
	%tmp5 = load %struct.PointerType*, %struct.PointerType** %v0
	%tmp6 = getelementptr inbounds %struct.PointerType, %struct.PointerType* %tmp5, i32 0, i32 1
	store %struct.Type %base, %struct.Type* %tmp6
	store i32 1, i32* %v1
	%tmp7 = getelementptr inbounds %struct.Type, %struct.Type* %v1, i32 0, i32 1
	%tmp8 = load %struct.PointerType*, %struct.PointerType** %v0
	store i8* %tmp8, i8** %tmp7
	%tmp9 = load %struct.Type, %struct.Type* %v1
	br label %func_exit
func_exit:
; Variable wrapper is out.
; Variable base is out.
	%tmp10 = phi %struct.Type [%base, %then0], [%tmp9, %endif1]
	ret %struct.Type %tmp10
}
define i8 @precedence(i8 %token){
entry:
	%tmp0 = icmp eq i8 %token, 15
	br i1 %tmp0, label %logic_end_0, label %logic_rhs_0
logic_rhs_0:
	%tmp1 = icmp eq i8 %token, 11
	br label %logic_end_0
logic_end_0:
	%tmp2 = phi i1 [%tmp0, %entry], [%tmp1, %logic_rhs_0]
	br i1 %tmp2, label %logic_end_1, label %logic_rhs_1
logic_rhs_1:
	%tmp3 = icmp eq i8 %token, 12
	br label %logic_end_1
logic_end_1:
	%tmp4 = phi i1 [%tmp2, %logic_end_0], [%tmp3, %logic_rhs_1]
	br i1 %tmp4, label %then2, label %endif2
then2:
	br label %func_exit
endif2:
	%tmp5 = icmp eq i8 %token, 24
	br i1 %tmp5, label %then3, label %endif3
then3:
	br label %func_exit
endif3:
	%tmp6 = icmp eq i8 %token, 25
	br i1 %tmp6, label %then4, label %endif4
then4:
	br label %func_exit
endif4:
	%tmp7 = icmp eq i8 %token, 31
	br i1 %tmp7, label %then5, label %endif5
then5:
	br label %func_exit
endif5:
	%tmp8 = icmp eq i8 %token, 33
	br i1 %tmp8, label %then6, label %endif6
then6:
	br label %func_exit
endif6:
	%tmp9 = icmp eq i8 %token, 32
	br i1 %tmp9, label %then7, label %endif7
then7:
	br label %func_exit
endif7:
	%tmp10 = icmp eq i8 %token, 22
	br i1 %tmp10, label %logic_end_8, label %logic_rhs_8
logic_rhs_8:
	%tmp11 = icmp eq i8 %token, 23
	br label %logic_end_8
logic_end_8:
	%tmp12 = phi i1 [%tmp10, %endif7], [%tmp11, %logic_rhs_8]
	br i1 %tmp12, label %then9, label %endif9
then9:
	br label %func_exit
endif9:
	%tmp13 = icmp eq i8 %token, 28
	br i1 %tmp13, label %logic_end_10, label %logic_rhs_10
logic_rhs_10:
	%tmp14 = icmp eq i8 %token, 29
	br label %logic_end_10
logic_end_10:
	%tmp15 = phi i1 [%tmp13, %endif9], [%tmp14, %logic_rhs_10]
	br i1 %tmp15, label %logic_end_11, label %logic_rhs_11
logic_rhs_11:
	%tmp16 = icmp eq i8 %token, 26
	br label %logic_end_11
logic_end_11:
	%tmp17 = phi i1 [%tmp15, %logic_end_10], [%tmp16, %logic_rhs_11]
	br i1 %tmp17, label %logic_end_12, label %logic_rhs_12
logic_rhs_12:
	%tmp18 = icmp eq i8 %token, 27
	br label %logic_end_12
logic_end_12:
	%tmp19 = phi i1 [%tmp17, %logic_end_11], [%tmp18, %logic_rhs_12]
	br i1 %tmp19, label %then13, label %endif13
then13:
	br label %func_exit
endif13:
	%tmp20 = icmp eq i8 %token, 34
	br i1 %tmp20, label %logic_end_14, label %logic_rhs_14
logic_rhs_14:
	%tmp21 = icmp eq i8 %token, 35
	br label %logic_end_14
logic_end_14:
	%tmp22 = phi i1 [%tmp20, %endif13], [%tmp21, %logic_rhs_14]
	br i1 %tmp22, label %then15, label %endif15
then15:
	br label %func_exit
endif15:
	%tmp23 = icmp eq i8 %token, 16
	br i1 %tmp23, label %logic_end_16, label %logic_rhs_16
logic_rhs_16:
	%tmp24 = icmp eq i8 %token, 17
	br label %logic_end_16
logic_end_16:
	%tmp25 = phi i1 [%tmp23, %endif15], [%tmp24, %logic_rhs_16]
	br i1 %tmp25, label %then17, label %endif17
then17:
	br label %func_exit
endif17:
	%tmp26 = icmp eq i8 %token, 18
	br i1 %tmp26, label %logic_end_18, label %logic_rhs_18
logic_rhs_18:
	%tmp27 = icmp eq i8 %token, 19
	br label %logic_end_18
logic_end_18:
	%tmp28 = phi i1 [%tmp26, %endif17], [%tmp27, %logic_rhs_18]
	br i1 %tmp28, label %logic_end_19, label %logic_rhs_19
logic_rhs_19:
	%tmp29 = icmp eq i8 %token, 20
	br label %logic_end_19
logic_end_19:
	%tmp30 = phi i1 [%tmp28, %logic_end_18], [%tmp29, %logic_rhs_19]
	br i1 %tmp30, label %then20, label %endif20
then20:
	br label %func_exit
endif20:
	%tmp31 = icmp eq i8 %token, 44
	br i1 %tmp31, label %then21, label %endif21
then21:
	br label %func_exit
endif21:
	%tmp32 = icmp eq i8 %token, 21
	br i1 %tmp32, label %logic_end_22, label %logic_rhs_22
logic_rhs_22:
	%tmp33 = icmp eq i8 %token, 30
	br label %logic_end_22
logic_end_22:
	%tmp34 = phi i1 [%tmp32, %endif21], [%tmp33, %logic_rhs_22]
	br i1 %tmp34, label %then23, label %endif23
then23:
	br label %func_exit
endif23:
	%tmp35 = icmp eq i8 %token, 0
	br i1 %tmp35, label %logic_end_24, label %logic_rhs_24
logic_rhs_24:
	%tmp36 = icmp eq i8 %token, 4
	br label %logic_end_24
logic_end_24:
	%tmp37 = phi i1 [%tmp35, %endif23], [%tmp36, %logic_rhs_24]
	br i1 %tmp37, label %logic_end_25, label %logic_rhs_25
logic_rhs_25:
	%tmp38 = icmp eq i8 %token, 10
	br label %logic_end_25
logic_end_25:
	%tmp39 = phi i1 [%tmp37, %logic_end_24], [%tmp38, %logic_rhs_25]
	br i1 %tmp39, label %logic_end_26, label %logic_rhs_26
logic_rhs_26:
	%tmp40 = icmp eq i8 %token, 7
	br label %logic_end_26
logic_end_26:
	%tmp41 = phi i1 [%tmp39, %logic_end_25], [%tmp40, %logic_rhs_26]
	br i1 %tmp41, label %then27, label %endif27
then27:
	br label %func_exit
endif27:
	br label %func_exit
func_exit:
	%tmp42 = phi i8 [1, %then2], [2, %then3], [3, %then4], [4, %then5], [5, %then6], [6, %then7], [7, %then9], [8, %then13], [9, %then15], [10, %then17], [11, %then20], [12, %then21], [13, %then23], [14, %then27], [0, %endif27]
	ret i8 %tmp42
}
define %"struct.vector.Vec<%struct.Type>" @parse_types_comma(%struct.TokenData* %token_array, i32* %index, i32 %len, i8 %stop){
	%v0 = alloca %"struct.vector.Vec<%struct.Type>"
	%tmp0 = call %"struct.vector.Vec<%struct.Type>" @"vector.new<%struct.Type>"()
	store %"struct.vector.Vec<%struct.Type>" %tmp0, %"struct.vector.Vec<%struct.Type>"* %v0
	br label %loop_start0
loop_start0:
	%tmp1 = load i32, i32* %index
	%tmp2 = icmp ult i32 %tmp1, %len
	br i1 %tmp2, label %logic_rhs_1, label %logic_end_1
logic_rhs_1:
	%tmp3 = load i32, i32* %index
	%tmp4 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp3
	%tmp5 = load i8, i8* %tmp4
	%tmp6 = icmp ne i8 %tmp5, %stop
	br label %logic_end_1
logic_end_1:
	%tmp7 = phi i1 [%tmp2, %loop_start0], [%tmp6, %logic_rhs_1]
	br i1 %tmp7, label %endif2, label %else2
else2:
	br label %loop_body0_exit
endif2:
	%tmp8 = call %struct.Type @parse_type_internal(%struct.TokenData* %token_array, i32* %index, i32 %len)
	call void @"vector.push<%struct.Type>"(%"struct.vector.Vec<%struct.Type>"* %v0, %struct.Type %tmp8)
	%tmp9 = load i32, i32* %index
	%tmp10 = icmp ult i32 %tmp9, %len
	br i1 %tmp10, label %logic_rhs_3, label %logic_end_3
logic_rhs_3:
	%tmp11 = load i32, i32* %index
	%tmp12 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp11
	%tmp13 = load i8, i8* %tmp12
	%tmp14 = icmp eq i8 %tmp13, 9
	br label %logic_end_3
logic_end_3:
	%tmp15 = phi i1 [%tmp10, %endif2], [%tmp14, %logic_rhs_3]
	br i1 %tmp15, label %then4, label %else4
then4:
	%tmp16 = load i32, i32* %index
	%tmp17 = add i32 %tmp16, 1
	store i32 %tmp17, i32* %index
	%tmp18 = load i32, i32* %index
	%tmp19 = icmp ult i32 %tmp18, %len
	br i1 %tmp19, label %logic_rhs_5, label %logic_end_5
logic_rhs_5:
	%tmp20 = load i32, i32* %index
	%tmp21 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp20
	%tmp22 = load i8, i8* %tmp21
	%tmp23 = icmp eq i8 %tmp22, %stop
	br label %logic_end_5
logic_end_5:
	%tmp24 = phi i1 [%tmp19, %then4], [%tmp23, %logic_rhs_5]
	br i1 %tmp24, label %then6, label %endif6
then6:
	br label %loop_body0_exit
endif6:
	br label %endif4
else4:
	br label %loop_body0_exit
endif4:
	br label %loop_start0
loop_body0_exit:
	%tmp25 = load %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %v0
; Variable output is out.
	ret %"struct.vector.Vec<%struct.Type>" %tmp25
}
define %"struct.vector.Vec<%struct.Type>" @parse_generic_args(%struct.TokenData* %token_array, i32* %index, i32 %len){
	%v0 = alloca %"struct.vector.Vec<%struct.Type>"
	%tmp0 = call %"struct.vector.Vec<%struct.Type>" @"vector.new<%struct.Type>"()
	store %"struct.vector.Vec<%struct.Type>" %tmp0, %"struct.vector.Vec<%struct.Type>"* %v0
	br label %loop_start0
loop_start0:
	%tmp1 = load i32, i32* %index
	%tmp2 = icmp ult i32 %tmp1, %len
	br i1 %tmp2, label %endif1, label %else1
else1:
	br label %loop_body0_exit
endif1:
	%tmp3 = load i32, i32* %index
	%tmp4 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp3
	%tmp5 = load i8, i8* %tmp4
	%tmp6 = icmp eq i8 %tmp5, 26
	br i1 %tmp6, label %then2, label %endif2
then2:
	%tmp7 = load i32, i32* %index
	%tmp8 = add i32 %tmp7, 1
	store i32 %tmp8, i32* %index
	br label %loop_body0_exit
endif2:
	%tmp9 = icmp eq i8 %tmp5, 35
	br i1 %tmp9, label %then3, label %endif3
then3:
	call void @process.throw(i8* @.str.218)
	br label %endif3
endif3:
	%tmp10 = load i32, i32* %index
	%tmp11 = icmp uge i32 %tmp10, %len
	br i1 %tmp11, label %then4, label %endif4
then4:
	call void @process.throw(i8* @.str.219)
	br label %endif4
endif4:
	%tmp12 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %v0, i32 0, i32 1
	%tmp13 = load i32, i32* %tmp12
	%tmp14 = icmp ugt i32 %tmp13, 0
	br i1 %tmp14, label %then5, label %endif5
then5:
	%tmp15 = load i32, i32* %index
	%tmp16 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp15
	%tmp17 = load i8, i8* %tmp16
	%tmp18 = icmp ne i8 %tmp17, 9
	br i1 %tmp18, label %then6, label %endif6
then6:
	call void @process.throw(i8* @.str.220)
	br label %endif6
endif6:
	%tmp19 = load i32, i32* %index
	%tmp20 = add i32 %tmp19, 1
	store i32 %tmp20, i32* %index
	%tmp21 = load i32, i32* %index
	%tmp22 = icmp ult i32 %tmp21, %len
	br i1 %tmp22, label %logic_rhs_7, label %logic_end_7
logic_rhs_7:
	%tmp23 = load i32, i32* %index
	%tmp24 = getelementptr inbounds %struct.TokenData, %struct.TokenData* %token_array, i32 %tmp23
	%tmp25 = load i8, i8* %tmp24
	%tmp26 = icmp eq i8 %tmp25, 26
	br label %logic_end_7
logic_end_7:
	%tmp27 = phi i1 [%tmp22, %endif6], [%tmp26, %logic_rhs_7]
	br i1 %tmp27, label %then8, label %endif8
then8:
	%tmp28 = load i32, i32* %index
	%tmp29 = add i32 %tmp28, 1
	store i32 %tmp29, i32* %index
	br label %loop_body0_exit
endif8:
	br label %endif5
endif5:
	%tmp30 = call %struct.Type @parse_type_internal(%struct.TokenData* %token_array, i32* %index, i32 %len)
	call void @"vector.push<%struct.Type>"(%"struct.vector.Vec<%struct.Type>"* %v0, %struct.Type %tmp30)
	br label %loop_start0
loop_body0_exit:
	%tmp31 = load %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %v0
; Variable args is out.
	ret %"struct.vector.Vec<%struct.Type>" %tmp31
}
define i1 @is_prefix_operator(i8 %token){
entry:
	%tmp0 = icmp eq i8 %token, 17
	br i1 %tmp0, label %logic_end_0, label %logic_rhs_0
logic_rhs_0:
	%tmp1 = icmp eq i8 %token, 16
	br label %logic_end_0
logic_end_0:
	%tmp2 = phi i1 [%tmp0, %entry], [%tmp1, %logic_rhs_0]
	br i1 %tmp2, label %logic_end_1, label %logic_rhs_1
logic_rhs_1:
	%tmp3 = icmp eq i8 %token, 21
	br label %logic_end_1
logic_end_1:
	%tmp4 = phi i1 [%tmp2, %logic_end_0], [%tmp3, %logic_rhs_1]
	br i1 %tmp4, label %logic_end_2, label %logic_rhs_2
logic_rhs_2:
	%tmp5 = icmp eq i8 %token, 30
	br label %logic_end_2
logic_end_2:
	%tmp6 = phi i1 [%tmp4, %logic_end_1], [%tmp5, %logic_rhs_2]
	br i1 %tmp6, label %logic_end_3, label %logic_rhs_3
logic_rhs_3:
	%tmp7 = icmp eq i8 %token, 32
	br label %logic_end_3
logic_end_3:
	%tmp8 = phi i1 [%tmp6, %logic_end_2], [%tmp7, %logic_rhs_3]
	br i1 %tmp8, label %logic_end_4, label %logic_rhs_4
logic_rhs_4:
	%tmp9 = icmp eq i8 %token, 18
	br label %logic_end_4
logic_end_4:
	%tmp10 = phi i1 [%tmp8, %logic_end_3], [%tmp9, %logic_rhs_4]
	ret i1 %tmp10
}
define i32 @get_unary_op(i8 %token){
	%tmp0 = icmp eq i8 %token, 17
	br i1 %tmp0, label %then0, label %endif0
then0:
	br label %func_exit
endif0:
	%tmp1 = icmp eq i8 %token, 21
	br i1 %tmp1, label %then1, label %endif1
then1:
	br label %func_exit
endif1:
	%tmp2 = icmp eq i8 %token, 18
	br i1 %tmp2, label %then2, label %endif2
then2:
	br label %func_exit
endif2:
	%tmp3 = icmp eq i8 %token, 32
	br i1 %tmp3, label %then3, label %endif3
then3:
	br label %func_exit
endif3:
	%tmp4 = icmp eq i8 %token, 30
	br i1 %tmp4, label %then4, label %endif4
then4:
	br label %func_exit
endif4:
	call void @process.throw(i8* @.str.221)
	br label %func_exit
func_exit:
	%tmp5 = phi i32 [0, %then0], [1, %then1], [2, %then2], [3, %then3], [4, %then4], [0, %endif4]
	ret i32 %tmp5
}
define i32 @get_binary_op(i8 %token){
	%tmp0 = icmp eq i8 %token, 16
	br i1 %tmp0, label %then0, label %endif0
then0:
	br label %func_exit
endif0:
	%tmp1 = icmp eq i8 %token, 17
	br i1 %tmp1, label %then1, label %endif1
then1:
	br label %func_exit
endif1:
	%tmp2 = icmp eq i8 %token, 18
	br i1 %tmp2, label %then2, label %endif2
then2:
	br label %func_exit
endif2:
	%tmp3 = icmp eq i8 %token, 19
	br i1 %tmp3, label %then3, label %endif3
then3:
	br label %func_exit
endif3:
	%tmp4 = icmp eq i8 %token, 20
	br i1 %tmp4, label %then4, label %endif4
then4:
	br label %func_exit
endif4:
	%tmp5 = icmp eq i8 %token, 15
	br i1 %tmp5, label %then5, label %endif5
then5:
	br label %func_exit
endif5:
	%tmp6 = icmp eq i8 %token, 22
	br i1 %tmp6, label %then6, label %endif6
then6:
	br label %func_exit
endif6:
	%tmp7 = icmp eq i8 %token, 23
	br i1 %tmp7, label %then7, label %endif7
then7:
	br label %func_exit
endif7:
	%tmp8 = icmp eq i8 %token, 28
	br i1 %tmp8, label %then8, label %endif8
then8:
	br label %func_exit
endif8:
	%tmp9 = icmp eq i8 %token, 29
	br i1 %tmp9, label %then9, label %endif9
then9:
	br label %func_exit
endif9:
	%tmp10 = icmp eq i8 %token, 26
	br i1 %tmp10, label %then10, label %endif10
then10:
	br label %func_exit
endif10:
	%tmp11 = icmp eq i8 %token, 27
	br i1 %tmp11, label %then11, label %endif11
then11:
	br label %func_exit
endif11:
	%tmp12 = icmp eq i8 %token, 25
	br i1 %tmp12, label %then12, label %endif12
then12:
	br label %func_exit
endif12:
	%tmp13 = icmp eq i8 %token, 24
	br i1 %tmp13, label %then13, label %endif13
then13:
	br label %func_exit
endif13:
	%tmp14 = icmp eq i8 %token, 32
	br i1 %tmp14, label %then14, label %endif14
then14:
	br label %func_exit
endif14:
	%tmp15 = icmp eq i8 %token, 31
	br i1 %tmp15, label %then15, label %endif15
then15:
	br label %func_exit
endif15:
	%tmp16 = icmp eq i8 %token, 33
	br i1 %tmp16, label %then16, label %endif16
then16:
	br label %func_exit
endif16:
	%tmp17 = icmp eq i8 %token, 34
	br i1 %tmp17, label %then17, label %endif17
then17:
	br label %func_exit
endif17:
	%tmp18 = icmp eq i8 %token, 35
	br i1 %tmp18, label %then18, label %endif18
then18:
	br label %func_exit
endif18:
	call void @process.throw(i8* @.str.222)
	br label %func_exit
func_exit:
	%tmp19 = phi i32 [0, %then0], [1, %then1], [2, %then2], [3, %then3], [4, %then4], [5, %then5], [6, %then6], [7, %then7], [8, %then8], [9, %then9], [10, %then10], [11, %then11], [12, %then12], [13, %then13], [14, %then14], [15, %then15], [16, %then16], [17, %then17], [18, %then18], [0, %endif18]
	ret i32 %tmp19
}
define void @"vector.push<%struct.StructInitFieldExpr>"(%"struct.vector.Vec<%struct.StructInitFieldExpr>"* %vec, %struct.StructInitFieldExpr %data){
	%v0 = alloca i32
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.StructInitFieldExpr>", %"struct.vector.Vec<%struct.StructInitFieldExpr>"* %vec, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = getelementptr inbounds %"struct.vector.Vec<%struct.StructInitFieldExpr>", %"struct.vector.Vec<%struct.StructInitFieldExpr>"* %vec, i32 0, i32 2
	%tmp3 = load i32, i32* %tmp2
	%tmp4 = icmp uge i32 %tmp1, %tmp3
	br i1 %tmp4, label %then0, label %endif0
then0:
	store i32 4, i32* %v0
	%tmp5 = getelementptr inbounds %"struct.vector.Vec<%struct.StructInitFieldExpr>", %"struct.vector.Vec<%struct.StructInitFieldExpr>"* %vec, i32 0, i32 2
	%tmp6 = load i32, i32* %tmp5
	%tmp7 = icmp ne i32 %tmp6, 0
	br i1 %tmp7, label %then1, label %endif1
then1:
	%tmp8 = getelementptr inbounds %"struct.vector.Vec<%struct.StructInitFieldExpr>", %"struct.vector.Vec<%struct.StructInitFieldExpr>"* %vec, i32 0, i32 2
	%tmp9 = load i32, i32* %tmp8
	%tmp10 = mul i32 %tmp9, 2
	store i32 %tmp10, i32* %v0
	br label %endif1
endif1:
	%tmp11 = load i32, i32* %v0
	%tmp12 = zext i32 %tmp11 to i64
	%tmp13 = mul i64 24, %tmp12
	%tmp14 = load %struct.StructInitFieldExpr*, %struct.StructInitFieldExpr** %vec
	%tmp15 = call i8* @mem.realloc(i8* %tmp14, i64 %tmp13)
	store %struct.StructInitFieldExpr* %tmp15, %struct.StructInitFieldExpr** %vec
	%tmp16 = getelementptr inbounds %"struct.vector.Vec<%struct.StructInitFieldExpr>", %"struct.vector.Vec<%struct.StructInitFieldExpr>"* %vec, i32 0, i32 2
	%tmp17 = load i32, i32* %v0
	store i32 %tmp17, i32* %tmp16
	br label %endif0
endif0:
	%tmp18 = getelementptr inbounds %"struct.vector.Vec<%struct.StructInitFieldExpr>", %"struct.vector.Vec<%struct.StructInitFieldExpr>"* %vec, i32 0, i32 1
	%tmp19 = load i32, i32* %tmp18
	%tmp20 = load %struct.StructInitFieldExpr*, %struct.StructInitFieldExpr** %vec
	%tmp21 = getelementptr inbounds %struct.StructInitFieldExpr, %struct.StructInitFieldExpr* %tmp20, i32 %tmp19
	store %struct.StructInitFieldExpr %data, %struct.StructInitFieldExpr* %tmp21
	%tmp22 = getelementptr inbounds %"struct.vector.Vec<%struct.StructInitFieldExpr>", %"struct.vector.Vec<%struct.StructInitFieldExpr>"* %vec, i32 0, i32 1
	%tmp23 = getelementptr inbounds %"struct.vector.Vec<%struct.StructInitFieldExpr>", %"struct.vector.Vec<%struct.StructInitFieldExpr>"* %vec, i32 0, i32 1
	%tmp24 = load i32, i32* %tmp23
	%tmp25 = add i32 %tmp24, 1
	store i32 %tmp25, i32* %tmp22
; Variable data is out.
	ret void
}
define void @"vector.push<%struct.Type>"(%"struct.vector.Vec<%struct.Type>"* %vec, %struct.Type %data){
	%v0 = alloca i32
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %vec, i32 0, i32 1
	%tmp1 = load i32, i32* %tmp0
	%tmp2 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %vec, i32 0, i32 2
	%tmp3 = load i32, i32* %tmp2
	%tmp4 = icmp uge i32 %tmp1, %tmp3
	br i1 %tmp4, label %then0, label %endif0
then0:
	store i32 4, i32* %v0
	%tmp5 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %vec, i32 0, i32 2
	%tmp6 = load i32, i32* %tmp5
	%tmp7 = icmp ne i32 %tmp6, 0
	br i1 %tmp7, label %then1, label %endif1
then1:
	%tmp8 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %vec, i32 0, i32 2
	%tmp9 = load i32, i32* %tmp8
	%tmp10 = mul i32 %tmp9, 2
	store i32 %tmp10, i32* %v0
	br label %endif1
endif1:
	%tmp11 = load i32, i32* %v0
	%tmp12 = zext i32 %tmp11 to i64
	%tmp13 = mul i64 16, %tmp12
	%tmp14 = load %struct.Type*, %struct.Type** %vec
	%tmp15 = call i8* @mem.realloc(i8* %tmp14, i64 %tmp13)
	store %struct.Type* %tmp15, %struct.Type** %vec
	%tmp16 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %vec, i32 0, i32 2
	%tmp17 = load i32, i32* %v0
	store i32 %tmp17, i32* %tmp16
	br label %endif0
endif0:
	%tmp18 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %vec, i32 0, i32 1
	%tmp19 = load i32, i32* %tmp18
	%tmp20 = load %struct.Type*, %struct.Type** %vec
	%tmp21 = getelementptr inbounds %struct.Type, %struct.Type* %tmp20, i32 %tmp19
	store %struct.Type %data, %struct.Type* %tmp21
	%tmp22 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %vec, i32 0, i32 1
	%tmp23 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %vec, i32 0, i32 1
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
	%tmp13 = mul i64 24, %tmp12
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
	%tmp13 = mul i64 16, %tmp12
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
	%tmp13 = mul i64 24, %tmp12
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
define %"struct.vector.Vec<%struct.StructInitFieldExpr>" @"vector.new<%struct.StructInitFieldExpr>"(){
	%v0 = alloca %"struct.vector.Vec<%struct.StructInitFieldExpr>"
	store %struct.StructInitFieldExpr* null, %struct.StructInitFieldExpr** %v0
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.StructInitFieldExpr>", %"struct.vector.Vec<%struct.StructInitFieldExpr>"* %v0, i32 0, i32 1
	store i32 0, i32* %tmp0
	%tmp1 = getelementptr inbounds %"struct.vector.Vec<%struct.StructInitFieldExpr>", %"struct.vector.Vec<%struct.StructInitFieldExpr>"* %v0, i32 0, i32 2
	store i32 0, i32* %tmp1
	%tmp2 = load %"struct.vector.Vec<%struct.StructInitFieldExpr>", %"struct.vector.Vec<%struct.StructInitFieldExpr>"* %v0
; Variable vec is out.
	ret %"struct.vector.Vec<%struct.StructInitFieldExpr>" %tmp2
}
define %"struct.vector.Vec<%struct.Type>" @"vector.new<%struct.Type>"(){
	%v0 = alloca %"struct.vector.Vec<%struct.Type>"
	store %struct.Type* null, %struct.Type** %v0
	%tmp0 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %v0, i32 0, i32 1
	store i32 0, i32* %tmp0
	%tmp1 = getelementptr inbounds %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %v0, i32 0, i32 2
	store i32 0, i32* %tmp1
	%tmp2 = load %"struct.vector.Vec<%struct.Type>", %"struct.vector.Vec<%struct.Type>"* %v0
; Variable vec is out.
	ret %"struct.vector.Vec<%struct.Type>" %tmp2
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
define void @"vector.free<%struct.Stmt>"(%"struct.vector.Vec<%struct.Stmt>"* %vec){
	%tmp0 = load %struct.Stmt*, %struct.Stmt** %vec
	%tmp1 = icmp ne %struct.Stmt* %tmp0, null
	br i1 %tmp1, label %then0, label %endif0
then0:
	%tmp2 = load %struct.Stmt*, %struct.Stmt** %vec
	call void @mem.free(i8* %tmp2)
	br label %endif0
endif0:
	store %struct.Stmt* null, %struct.Stmt** %vec
	%tmp3 = getelementptr inbounds %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %vec, i32 0, i32 1
	store i32 0, i32* %tmp3
	%tmp4 = getelementptr inbounds %"struct.vector.Vec<%struct.Stmt>", %"struct.vector.Vec<%struct.Stmt>"* %vec, i32 0, i32 2
	store i32 0, i32* %tmp4
	ret void
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
	call void @process.throw(i8* @.str.223)
	br label %endif1
endif1:
	br label %func_exit
func_exit:
	%tmp5 = phi i8* [%tmp1, %then0], [%tmp3, %endif1]
	ret i8* %tmp5
}

;func __chkstk ["no_lazy"]
;func _fltused ["no_lazy"]
;func compile []
;func compile_body []
;func debug_dump_expression []
;func debug_dump_type []
;func expect []
;func get_binary_op []
;func get_unary_op []
;func handle_char []
;func handle_decimal_number []
;func handle_number []
;func handle_string []
;func handle_symbol []
;func insert_symbol []
;func is_expression_starter []
;func is_modifier []
;func is_prefix_operator []
;func lex []
;func main []
;func parse []
;func parse_argument_comma []
;func parse_body []
;func parse_enum_fields []
;func parse_expression []
;func parse_expression_comma []
;func parse_expression_internal []
;func parse_generic_args []
;func parse_generic_params []
;func parse_struct_fields []
;func parse_type []
;func parse_type_internal []
;func parse_types_comma []
;func precedence []
;func rcsharp_compile []
;func skip_nested []
;func token_type_to_string []
;func wrap_in_pointers []
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
;func fs.write_to_file []
;func mem.compare []
;func mem.copy []
;func mem.default_fill []
;func mem.fill []
;func mem.free []
;func mem.malloc []
;func mem.realloc []
;func mem.zero_fill []
;func process.throw ["no_return"]
;func string.append ["ExtensionOf"]
;func string.append_str ["ExtensionOf"]
;func string.clone ["ExtentionOf"]
;func string.empty []
;func string.equal ["ExtentionOf"]
;func string.free ["ExtentionOf"]
;func string.from_c_string []
;func string.from_data []
;func string.with_size []
;func string_utils.c_str_len []
;func string_utils.insert []
;func vector.free ["ExtentionOf"]
;func vector.new []
;func vector.push ["ExtentionOf"]
;type Argument
;type ArrayExpr
;type BinaryOpExpr
;type BlockStmt
;type BoolExpr
;type CallExpr
;type CastExpr
;type CharExpr
;type ConstantSizeArrayType
;type DecimalExpr
;type DeclarationNode
;type DoWhileStmt
;type EnumField
;type EnumNode
;type Expression
;type ExpressionNode
;type FnNode
;type ForStmt
;type FunctionType
;type GenericType
;type HintNode
;type IfStmt
;type IndexExpr
;type IntegerExpr
;type LoopStmt
;type MemberAccessExpr
;type NameExpr
;type NameWithGenericsExpr
;type NamedType
;type NamespaceLinkType
;type NamespaceNode
;type Path
;type PointerType
;type RangeExpr
;type ReturnNode
;type StaticAccessExpr
;type Stmt
;type StringConstExpr
;type StructInitExpr
;type StructInitFieldExpr
;type StructNode
;type TokenData
;type Type
;type TypeExpr
;type UnaryOpExpr
;type WhileStmt
;type mem.PROCESS_HEAP_ENTRY
;type string.String
;type vector.Vec
;type window.BITMAP
;type window.MSG
;type window.PAINTSTRUCT
;type window.POINT
;type window.RECT
;type window.WNDCLASSEXA
