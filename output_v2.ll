declare dllimport i8*	@GetStdHandle(i32 %a0)
declare dllimport i32	@WriteConsoleA(i8* %a0, i8* %a1, i32 %a2, i32* %a3, i8* %a4)
@.d0 = constant [12 x i8] c"Hello World!"
define i32 @main(){
	%t0 = alloca i32
	%t1 = add i32 18446744073709551605, 0
	%t2 = call i8* @GetStdHandle(i32 %t1)
	%t3 = bitcast [12 x i8]* @.d0 to i8*
	%t4 = add i32 12, 0
	%t5 = inttoptr i64 0 to ptr
	%t6 = call i32 @WriteConsoleA(i8* %t2, i8* %t3, i32 %t4, i32* %t0, i8* %t5)
	%t7 = add i32 0, 0
	ret i32 %t7
}
