define i32 @main(){
	%t0 = alloca double
	%t1 = fadd double 0x40400fbe76c8b43a, 0.0
	store double %t1, double* %t0
	%t2 = load double, double* %t0
	%t3 = fadd double 0x40400fbe76c8b43a, 0.0
	%t4 = fsub double %t2, %t3
	%t5 = fadd double 0.0, 0.0
	%t6 = fcmp oeq double %t4, %t5
	br i1 %t6, label %l0, label %l1
l0:
	%t7 = add i32 1, 0
	ret i32 %t7
	br label %l1
l1:
	%t8 = load double, double* %t0
	%t10 = fadd double 0.0, 0.0
	%t9 = fadd double %t10, %t8
	%t11 = fadd double 0x40400fbe76c8b43a, 0.0
	%t12 = fadd double %t9, %t11
	%t13 = fadd double 0.0, 0.0
	%t14 = fcmp oeq double %t12, %t13
	br i1 %t14, label %l2, label %l3
l2:
	%t15 = add i32 2, 0
	ret i32 %t15
	br label %l3
l3:
	%t16 = alloca double
	%t17 = fadd double 0xc0400fbe76c8b43a, 0.0
	store double %t17, double* %t16
	%t18 = load double, double* %t16
	%t19 = fadd double 0x40400fbe76c8b43a, 0.0
	%t20 = fadd double %t18, %t19
	%t21 = fadd double 0.0, 0.0
	%t22 = fcmp oeq double %t20, %t21
	br i1 %t22, label %l4, label %l5
l4:
	%t23 = add i32 2, 0
	ret i32 %t23
	br label %l5
l5:
	%t24 = alloca i32
	%t25 = add i32 0, 0
	store i32 %t25, i32* %t24
	%t26 = add i32 6, 0
	store i32 %t26, i32* %t24
	%t27 = add i32 0, 0
	ret i32 %t27
}
