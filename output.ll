%struct.mem.PROCESS_HEAP_ENTRY = type { i8*, i32, i8, i8, i16, i8*, i32, i32, i32 }
%struct.string.String = type { i8*, i32 }
%struct.window.BITMAP = type { i32, i32, i32, i32, i16, i16, i8* }
%struct.window.MSG = type { i8*, i32, i64, i64, i32, %struct.window.POINT }
%struct.window.PAINTSTRUCT = type { i8*, i32, %struct.window.RECT, i32, i32, [32 x i8] }
%struct.window.POINT = type { i32, i32 }
%struct.window.RECT = type { i32, i32, i32, i32 }
%struct.window.WNDCLASSEXA = type { i32, i32, i64 (i8*, i32, i64, i64)*, i32, i32, i8*, i8*, i8*, i8*, i8*, i8*, i8* }
%"struct.Pair<i8, %struct.string.String>" = type { i8, %struct.string.String }
%"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>" = type { i32, %"struct.Pair<i8, %struct.string.String>" }
%"struct.test.QPair<i64, i64>" = type { i64, i64 }


@.str.0 = private unnamed_addr constant [18 x i8] c"test 13now sudo32\00"
@yt = internal global [43 x i32] zeroinitializer
@stdlib.rand_seed = internal global i32 zeroinitializer

define void @mainCRTStartup(){
	%result = call i32 @main()
	unreachable
}
define i32 @main(){
	%v0 = alloca i8*
	%v1 = alloca %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>"
	%v2 = alloca i32
	store i8* @.str.0, i8** %v0
	%tmp0 = load i8*, i8** %v0
	call void @console.writeln(i8* %tmp0, i32 17)
	%tmp1 = getelementptr inbounds [43 x i32], [43 x i32]* @yt, i32 0, i64 42
	store i32 9999000, i32* %tmp1
	%tmp2 = call %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>" @"ax<i32>"()
	store %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>" %tmp2, %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>"* %v1
	%tmp3 = getelementptr inbounds %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>", %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>"* %v1, i32 0, i32 1
	%tmp4 = load i8, i8* %tmp3
	%tmp5 = sext i8 %tmp4 to i64
	call void @console.println_i64(i64 %tmp5)
	call void @console.println_f64(double 0x40DEADDD40000000)
	call void @console.println_i64(i64 31415)
	call void @console.println_i64(i64 4674364628954828846)
	%tmp6 = add i64 4674364628954828846, 123123123123
	%tmp7 = bitcast i64 %tmp6 to double
	call void @console.println_f64(double %tmp7)
	store i32 0, i32* %v2
	br label %loop_cond0
loop_cond0:
	%tmp8 = load i32, i32* %v2
	%tmp9 = icmp sge i32 %tmp8, 10
	br i1 %tmp9, label %then1, label %endif1
then1:
	br label %loop_body0_exit
endif1:
	%tmp10 = load i32, i32* %v2
	%tmp11 = sext i32 %tmp10 to i64
	call void @console.println_i64(i64 %tmp11)
	%tmp12 = load i32, i32* %v2
	%tmp13 = add i32 %tmp12, 1
	store i32 %tmp13, i32* %v2
	br label %loop_cond0
loop_body0_exit:
	call void @basic_functions()
	%tmp14 = call %"struct.test.QPair<i64, i64>" @xq()
	%tmp15 = ptrtoint %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>" ()* @"ax<i32>" to i64
	%tmp16 = ptrtoint i32 ()* @main to i64
	%tmp17 = sub i64 %tmp15, %tmp16
	%tmp18 = trunc i64 %tmp17 to i32
	%tmp19 = getelementptr inbounds [43 x i32], [43 x i32]* @yt, i32 0, i64 42
	%tmp20 = load i32, i32* %tmp19
	%tmp21 = add i32 %tmp18, %tmp20
; Variable temp is out.
; Variable y is out.
	ret i32 %tmp21
}
define i32 @_fltused(){
	ret i32 0
}
define void @__chkstk(){
	ret void
}
define %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>" @"ax<i32>"(){
	%v0 = alloca %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>"
	store i32 43, i32* %v0
	%tmp0 = getelementptr inbounds %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>", %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>"* %v0, i32 0, i32 1
	store i8 126, i8* %tmp0
	%tmp1 = load %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>", %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>"* %v0
; Variable p is out.
	ret %"struct.Pair<i32, %struct.Pair<i8, %struct.string.String>>" %tmp1
}

;func __chkstk ["no_lazy"]
;func _fltused ["no_lazy"]
;func ax []
;func main []
;type Pair
;type mem.PROCESS_HEAP_ENTRY
;type string.String
;type test.QPair
;type window.BITMAP
;type window.MSG
;type window.PAINTSTRUCT
;type window.POINT
;type window.RECT
;type window.WNDCLASSEXA
