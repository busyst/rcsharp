; ModuleID = '.\output.ll'
source_filename = ".\\output.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct.ListNode = type { ptr, i32 }
%struct.List = type { ptr, ptr, i32 }
%struct.Vec = type { ptr, i32, i32 }

declare dllimport ptr @GetProcessHeap() local_unnamed_addr

declare dllimport ptr @HeapAlloc(ptr, i32, i64) local_unnamed_addr

declare dllimport i32 @HeapFree(ptr, i32, ptr) local_unnamed_addr

declare dllimport void @ExitProcess(i32) local_unnamed_addr

declare dllimport i32 @AllocConsole() local_unnamed_addr

declare dllimport ptr @GetStdHandle(i32) local_unnamed_addr

declare dllimport i32 @WriteConsoleA(ptr, ptr, i32, ptr, ptr) local_unnamed_addr

declare dllimport i32 @FreeConsole() local_unnamed_addr

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define void @__chkstk() local_unnamed_addr #0 {
  ret void
}

define ptr @get_stdout() local_unnamed_addr {
  %tmp2 = tail call ptr @GetStdHandle(i32 -11)
  %tmp5 = icmp eq ptr %tmp2, inttoptr (i64 -1 to ptr)
  br i1 %tmp5, label %then0, label %end_if0

then0:                                            ; preds = %0
  tail call void @ExitProcess(i32 -1)
  br label %end_if0

end_if0:                                          ; preds = %then0, %0
  ret ptr %tmp2
}

define void @write(ptr %buffer, i32 %len) local_unnamed_addr {
  %chars_written = alloca i32, align 4
  %tmp2.i = tail call ptr @GetStdHandle(i32 -11)
  %tmp5.i = icmp eq ptr %tmp2.i, inttoptr (i64 -1 to ptr)
  br i1 %tmp5.i, label %then0.i, label %get_stdout.exit

then0.i:                                          ; preds = %0
  tail call void @ExitProcess(i32 -1)
  br label %get_stdout.exit

get_stdout.exit:                                  ; preds = %0, %then0.i
  %1 = call i32 @WriteConsoleA(ptr %tmp2.i, ptr %buffer, i32 %len, ptr nonnull %chars_written, ptr null)
  ret void
}

define ptr @malloc(i64 %size) local_unnamed_addr {
  %tmp2 = tail call ptr @GetProcessHeap()
  %tmp4 = tail call ptr @HeapAlloc(ptr %tmp2, i32 0, i64 %size)
  ret ptr %tmp4
}

define void @free(ptr %ptr) local_unnamed_addr {
  %tmp2 = tail call ptr @GetProcessHeap()
  %1 = tail call i32 @HeapFree(ptr %tmp2, i32 0, ptr %ptr)
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
define void @new_list(ptr nocapture writeonly %list) local_unnamed_addr #1 {
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(20) %list, i8 0, i64 20, i1 false)
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
define void @new_list_node(ptr nocapture writeonly %list) local_unnamed_addr #1 {
  store ptr null, ptr %list, align 8
  %tmp5 = getelementptr inbounds %struct.ListNode, ptr %list, i64 0, i32 1
  store i32 0, ptr %tmp5, align 4
  ret void
}

define void @extend(ptr nocapture %list, i32 %data) local_unnamed_addr {
  %tmp2.i = tail call ptr @GetProcessHeap()
  %tmp4.i = tail call ptr @HeapAlloc(ptr %tmp2.i, i32 0, i64 12)
  store ptr null, ptr %tmp4.i, align 8
  %tmp9 = getelementptr inbounds %struct.ListNode, ptr %tmp4.i, i64 0, i32 1
  store i32 %data, ptr %tmp9, align 4
  %tmp14 = load ptr, ptr %list, align 8
  %tmp15 = icmp eq ptr %tmp14, null
  br i1 %tmp15, label %then1, label %else1

then1:                                            ; preds = %0
  store ptr %tmp4.i, ptr %list, align 8
  %tmp22 = getelementptr inbounds %struct.List, ptr %list, i64 0, i32 1
  br label %end_if1

else1:                                            ; preds = %0
  %tmp26 = getelementptr inbounds %struct.List, ptr %list, i64 0, i32 1
  %tmp27 = load ptr, ptr %tmp26, align 8
  store ptr %tmp4.i, ptr %tmp27, align 8
  br label %end_if1

end_if1:                                          ; preds = %else1, %then1
  %tmp26.sink = phi ptr [ %tmp26, %else1 ], [ %tmp22, %then1 ]
  store ptr %tmp4.i, ptr %tmp26.sink, align 8
  %tmp36 = getelementptr inbounds %struct.List, ptr %list, i64 0, i32 2
  %tmp40 = load i32, ptr %tmp36, align 4
  %tmp41 = add i32 %tmp40, 1
  store i32 %tmp41, ptr %tmp36, align 4
  ret void
}

; Function Attrs: nofree norecurse nosync nounwind memory(read, inaccessiblemem: none)
define i32 @walk(ptr nocapture readonly %list) local_unnamed_addr #2 {
  br label %loop_body2

loop_body2:                                       ; preds = %loop_body2, %0
  %l.0 = phi i32 [ 0, %0 ], [ %tmp10, %loop_body2 ]
  %ptr.0.in = phi ptr [ %list, %0 ], [ %ptr.0, %loop_body2 ]
  %ptr.0 = load ptr, ptr %ptr.0.in, align 8
  %tmp7 = icmp eq ptr %ptr.0, null
  %tmp10 = add i32 %l.0, 1
  br i1 %tmp7, label %loop_body2_exit, label %loop_body2

loop_body2_exit:                                  ; preds = %loop_body2
  ret i32 %l.0
}

define void @free_list(ptr nocapture %list) local_unnamed_addr {
  %current.0.pr = load ptr, ptr %list, align 8
  %tmp61 = icmp eq ptr %current.0.pr, null
  br i1 %tmp61, label %loop_body4_exit, label %end_if5

end_if5:                                          ; preds = %0, %end_if5
  %current.02 = phi ptr [ %tmp11, %end_if5 ], [ %current.0.pr, %0 ]
  %tmp11 = load ptr, ptr %current.02, align 8
  %tmp2.i = tail call ptr @GetProcessHeap()
  %1 = tail call i32 @HeapFree(ptr %tmp2.i, i32 0, ptr nonnull %current.02)
  %tmp6 = icmp eq ptr %tmp11, null
  br i1 %tmp6, label %loop_body4_exit, label %end_if5

loop_body4_exit:                                  ; preds = %end_if5, %0
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(20) %list, i8 0, i64 20, i1 false)
  ret void
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
define void @new_vec(ptr nocapture writeonly %vec) local_unnamed_addr #1 {
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %vec, i8 0, i64 16, i1 false)
  ret void
}

define void @push(ptr nocapture %vec, i8 %data) local_unnamed_addr {
  %tmp2 = getelementptr inbounds %struct.Vec, ptr %vec, i64 0, i32 1
  %tmp3 = load i32, ptr %tmp2, align 4
  %tmp6 = getelementptr inbounds %struct.Vec, ptr %vec, i64 0, i32 2
  %tmp7 = load i32, ptr %tmp6, align 4
  %tmp8.not = icmp ult i32 %tmp3, %tmp7
  br i1 %tmp8.not, label %.end_if6_crit_edge, label %then6

.end_if6_crit_edge:                               ; preds = %0
  %tmp70.pre = load ptr, ptr %vec, align 8
  br label %end_if6

then6:                                            ; preds = %0
  %tmp14.not = icmp eq i32 %tmp7, 0
  %tmp20 = shl i32 %tmp7, 1
  %spec.select = select i1 %tmp14.not, i32 4, i32 %tmp20
  %tmp24 = zext i32 %spec.select to i64
  %tmp2.i = tail call ptr @GetProcessHeap()
  %tmp4.i = tail call ptr @HeapAlloc(ptr %tmp2.i, i32 0, i64 %tmp24)
  %tmp30 = load ptr, ptr %vec, align 8
  %tmp31.not = icmp eq ptr %tmp30, null
  br i1 %tmp31.not, label %end_if8, label %loop_body9.preheader

loop_body9.preheader:                             ; preds = %then6
  %tmp373 = load i32, ptr %tmp2, align 4
  %tmp38.not4.not = icmp eq i32 %tmp373, 0
  br i1 %tmp38.not4.not, label %loop_body9_exit, label %end_if10

end_if10:                                         ; preds = %loop_body9.preheader, %end_if10
  %indvars.iv = phi i64 [ %indvars.iv.next, %end_if10 ], [ 0, %loop_body9.preheader ]
  %tmp42 = getelementptr i8, ptr %tmp4.i, i64 %indvars.iv
  %tmp46 = load ptr, ptr %vec, align 8
  %tmp49 = getelementptr i8, ptr %tmp46, i64 %indvars.iv
  %tmp50 = load i8, ptr %tmp49, align 1
  store i8 %tmp50, ptr %tmp42, align 1
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %tmp37 = load i32, ptr %tmp2, align 4
  %1 = zext i32 %tmp37 to i64
  %tmp38.not = icmp ult i64 %indvars.iv.next, %1
  br i1 %tmp38.not, label %end_if10, label %loop_body9_exit.loopexit

loop_body9_exit.loopexit:                         ; preds = %end_if10
  %tmp58.pre = load ptr, ptr %vec, align 8
  br label %loop_body9_exit

loop_body9_exit:                                  ; preds = %loop_body9_exit.loopexit, %loop_body9.preheader
  %tmp58 = phi ptr [ %tmp58.pre, %loop_body9_exit.loopexit ], [ %tmp30, %loop_body9.preheader ]
  %tmp2.i1 = tail call ptr @GetProcessHeap()
  %2 = tail call i32 @HeapFree(ptr %tmp2.i1, i32 0, ptr %tmp58)
  br label %end_if8

end_if8:                                          ; preds = %loop_body9_exit, %then6
  store ptr %tmp4.i, ptr %vec, align 8
  store i32 %spec.select, ptr %tmp6, align 4
  %tmp74.pre = load i32, ptr %tmp2, align 4
  br label %end_if6

end_if6:                                          ; preds = %.end_if6_crit_edge, %end_if8
  %tmp74 = phi i32 [ %tmp3, %.end_if6_crit_edge ], [ %tmp74.pre, %end_if8 ]
  %tmp70 = phi ptr [ %tmp70.pre, %.end_if6_crit_edge ], [ %tmp4.i, %end_if8 ]
  %tmp75 = zext i32 %tmp74 to i64
  %tmp76 = getelementptr i8, ptr %tmp70, i64 %tmp75
  store i8 %data, ptr %tmp76, align 1
  %tmp84 = load i32, ptr %tmp2, align 4
  %tmp85 = add i32 %tmp84, 1
  store i32 %tmp85, ptr %tmp2, align 4
  ret void
}

define void @free_vec(ptr nocapture %vec) local_unnamed_addr {
  %tmp3 = load ptr, ptr %vec, align 8
  %tmp4.not = icmp eq ptr %tmp3, null
  br i1 %tmp4.not, label %end_if11, label %then11

then11:                                           ; preds = %0
  %tmp2.i = tail call ptr @GetProcessHeap()
  %1 = tail call i32 @HeapFree(ptr %tmp2.i, i32 0, ptr nonnull %tmp3)
  br label %end_if11

end_if11:                                         ; preds = %then11, %0
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %vec, i8 0, i64 16, i1 false)
  ret void
}

define void @println_i32(i32 %n) local_unnamed_addr {
  %chars_written.i173 = alloca i32, align 4
  %chars_written.i = alloca i32, align 4
  %tmp3 = icmp eq i32 %n, 0
  br i1 %tmp3, label %push.exit43, label %end_if12

common.ret:                                       ; preds = %then11.i180, %free_vec.exit
  %buffer.sroa.0.6.sink = phi ptr [ %buffer.sroa.0.6, %then11.i180 ], [ %tmp4.i.i, %free_vec.exit ]
  %tmp2.i.i181 = call ptr @GetProcessHeap()
  %1 = call i32 @HeapFree(ptr %tmp2.i.i181, i32 0, ptr nonnull %buffer.sroa.0.6.sink)
  ret void

push.exit43:                                      ; preds = %0
  %tmp2.i.i = tail call ptr @GetProcessHeap()
  %tmp4.i.i = tail call ptr @HeapAlloc(ptr %tmp2.i.i, i32 0, i64 4)
  store i8 48, ptr %tmp4.i.i, align 1
  %tmp76.i38 = getelementptr i8, ptr %tmp4.i.i, i64 1
  store i8 10, ptr %tmp76.i38, align 1
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %chars_written.i)
  %tmp2.i.i44 = tail call ptr @GetStdHandle(i32 -11)
  %tmp5.i.i = icmp eq ptr %tmp2.i.i44, inttoptr (i64 -1 to ptr)
  br i1 %tmp5.i.i, label %then0.i.i, label %free_vec.exit

then0.i.i:                                        ; preds = %push.exit43
  tail call void @ExitProcess(i32 -1)
  br label %free_vec.exit

free_vec.exit:                                    ; preds = %push.exit43, %then0.i.i
  %2 = call i32 @WriteConsoleA(ptr %tmp2.i.i44, ptr nonnull %tmp4.i.i, i32 2, ptr nonnull %chars_written.i, ptr null)
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %chars_written.i)
  br label %common.ret

end_if12:                                         ; preds = %0
  %mut_n = alloca i64, align 8
  %tmp20 = sext i32 %n to i64
  store i64 %tmp20, ptr %mut_n, align 8
  %is_negative = alloca i32, align 4
  store i32 0, ptr %is_negative, align 4
  %tmp23 = icmp slt i32 %n, 0
  br i1 %tmp23, label %then13, label %end_if15.preheader

then13:                                           ; preds = %end_if12
  store i32 1, ptr %is_negative, align 4
  %tmp27 = sub nsw i64 0, %tmp20
  store i64 %tmp27, ptr %mut_n, align 8
  br label %end_if15.preheader

end_if15.preheader:                               ; preds = %end_if12, %then13
  %tmp28221.ph = phi i64 [ %tmp27, %then13 ], [ %tmp20, %end_if12 ]
  br label %end_if15

end_if15:                                         ; preds = %end_if15.preheader, %push.exit88
  %buffer.sroa.67.2224 = phi i32 [ %buffer.sroa.67.3, %push.exit88 ], [ 0, %end_if15.preheader ]
  %buffer.sroa.34.0223 = phi i32 [ %tmp85.i85, %push.exit88 ], [ 0, %end_if15.preheader ]
  %buffer.sroa.0.2222 = phi ptr [ %buffer.sroa.0.3, %push.exit88 ], [ null, %end_if15.preheader ]
  %tmp28221 = phi i64 [ %tmp40, %push.exit88 ], [ %tmp28221.ph, %end_if15.preheader ]
  %3 = zext i32 %buffer.sroa.34.0223 to i64
  %buffer.sroa.0.2222238 = ptrtoint ptr %buffer.sroa.0.2222 to i64
  %4 = zext i32 %buffer.sroa.34.0223 to i64
  %tmp32 = srem i64 %tmp28221, 10
  %tmp33 = trunc i64 %tmp32 to i8
  %tmp34 = add nsw i8 %tmp33, 48
  %tmp8.not.i51 = icmp ult i32 %buffer.sroa.34.0223, %buffer.sroa.67.2224
  br i1 %tmp8.not.i51, label %push.exit88, label %then6.i52

then6.i52:                                        ; preds = %end_if15
  %tmp14.not.i53 = icmp eq i32 %buffer.sroa.67.2224, 0
  %tmp20.i54 = shl i32 %buffer.sroa.67.2224, 1
  %spec.select.i55 = select i1 %tmp14.not.i53, i32 4, i32 %tmp20.i54
  %tmp24.i56 = zext i32 %spec.select.i55 to i64
  %tmp2.i.i57 = tail call ptr @GetProcessHeap()
  %tmp4.i.i58 = tail call ptr @HeapAlloc(ptr %tmp2.i.i57, i32 0, i64 %tmp24.i56)
  %tmp4.i.i58237 = ptrtoint ptr %tmp4.i.i58 to i64
  %tmp31.not.i60 = icmp eq ptr %buffer.sroa.0.2222, null
  br i1 %tmp31.not.i60, label %push.exit88, label %loop_body9.preheader.i61

loop_body9.preheader.i61:                         ; preds = %then6.i52
  %tmp38.not4.not.i63 = icmp eq i32 %buffer.sroa.34.0223, 0
  br i1 %tmp38.not4.not.i63, label %loop_body9_exit.i75, label %iter.check

iter.check:                                       ; preds = %loop_body9.preheader.i61
  %min.iters.check = icmp ult i32 %buffer.sroa.34.0223, 8
  %5 = sub i64 %tmp4.i.i58237, %buffer.sroa.0.2222238
  %diff.check = icmp ult i64 %5, 32
  %or.cond = select i1 %min.iters.check, i1 true, i1 %diff.check
  br i1 %or.cond, label %end_if10.i64.preheader, label %vector.main.loop.iter.check

vector.main.loop.iter.check:                      ; preds = %iter.check
  %min.iters.check239 = icmp ult i32 %buffer.sroa.34.0223, 32
  br i1 %min.iters.check239, label %vec.epilog.ph, label %vector.ph

vector.ph:                                        ; preds = %vector.main.loop.iter.check
  %n.vec = and i64 %3, 4294967264
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %6 = getelementptr i8, ptr %tmp4.i.i58, i64 %index
  %7 = getelementptr i8, ptr %buffer.sroa.0.2222, i64 %index
  %8 = getelementptr i8, ptr %7, i64 16
  %wide.load = load <16 x i8>, ptr %7, align 1
  %wide.load240 = load <16 x i8>, ptr %8, align 1
  %9 = getelementptr i8, ptr %6, i64 16
  store <16 x i8> %wide.load, ptr %6, align 1
  store <16 x i8> %wide.load240, ptr %9, align 1
  %index.next = add nuw i64 %index, 32
  %10 = icmp eq i64 %index.next, %n.vec
  br i1 %10, label %middle.block, label %vector.body, !llvm.loop !0

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i64 %n.vec, %3
  br i1 %cmp.n, label %loop_body9_exit.i75, label %vec.epilog.iter.check

vec.epilog.iter.check:                            ; preds = %middle.block
  %n.vec.remaining = and i64 %3, 24
  %min.epilog.iters.check = icmp eq i64 %n.vec.remaining, 0
  br i1 %min.epilog.iters.check, label %end_if10.i64.preheader, label %vec.epilog.ph

vec.epilog.ph:                                    ; preds = %vector.main.loop.iter.check, %vec.epilog.iter.check
  %vec.epilog.resume.val = phi i64 [ %n.vec, %vec.epilog.iter.check ], [ 0, %vector.main.loop.iter.check ]
  %n.vec242 = and i64 %3, 4294967288
  br label %vec.epilog.vector.body

vec.epilog.vector.body:                           ; preds = %vec.epilog.vector.body, %vec.epilog.ph
  %index244 = phi i64 [ %vec.epilog.resume.val, %vec.epilog.ph ], [ %index.next246, %vec.epilog.vector.body ]
  %11 = getelementptr i8, ptr %tmp4.i.i58, i64 %index244
  %12 = getelementptr i8, ptr %buffer.sroa.0.2222, i64 %index244
  %wide.load245 = load <8 x i8>, ptr %12, align 1
  store <8 x i8> %wide.load245, ptr %11, align 1
  %index.next246 = add nuw i64 %index244, 8
  %13 = icmp eq i64 %index.next246, %n.vec242
  br i1 %13, label %vec.epilog.middle.block, label %vec.epilog.vector.body, !llvm.loop !3

vec.epilog.middle.block:                          ; preds = %vec.epilog.vector.body
  %cmp.n243 = icmp eq i64 %n.vec242, %3
  br i1 %cmp.n243, label %loop_body9_exit.i75, label %end_if10.i64.preheader

end_if10.i64.preheader:                           ; preds = %iter.check, %vec.epilog.iter.check, %vec.epilog.middle.block
  %indvars.iv.i65.ph = phi i64 [ 0, %iter.check ], [ %n.vec, %vec.epilog.iter.check ], [ %n.vec242, %vec.epilog.middle.block ]
  br label %end_if10.i64

end_if10.i64:                                     ; preds = %end_if10.i64.preheader, %end_if10.i64
  %indvars.iv.i65 = phi i64 [ %indvars.iv.next.i70, %end_if10.i64 ], [ %indvars.iv.i65.ph, %end_if10.i64.preheader ]
  %tmp42.i66 = getelementptr i8, ptr %tmp4.i.i58, i64 %indvars.iv.i65
  %tmp49.i68 = getelementptr i8, ptr %buffer.sroa.0.2222, i64 %indvars.iv.i65
  %tmp50.i69 = load i8, ptr %tmp49.i68, align 1
  store i8 %tmp50.i69, ptr %tmp42.i66, align 1
  %indvars.iv.next.i70 = add nuw nsw i64 %indvars.iv.i65, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next.i70, %4
  br i1 %exitcond.not, label %loop_body9_exit.i75, label %end_if10.i64, !llvm.loop !4

loop_body9_exit.i75:                              ; preds = %end_if10.i64, %middle.block, %vec.epilog.middle.block, %loop_body9.preheader.i61
  %tmp2.i1.i77 = tail call ptr @GetProcessHeap()
  %14 = tail call i32 @HeapFree(ptr %tmp2.i1.i77, i32 0, ptr nonnull %buffer.sroa.0.2222)
  br label %push.exit88

push.exit88:                                      ; preds = %then6.i52, %loop_body9_exit.i75, %end_if15
  %buffer.sroa.0.3 = phi ptr [ %buffer.sroa.0.2222, %end_if15 ], [ %tmp4.i.i58, %loop_body9_exit.i75 ], [ %tmp4.i.i58, %then6.i52 ]
  %buffer.sroa.67.3 = phi i32 [ %buffer.sroa.67.2224, %end_if15 ], [ %spec.select.i55, %loop_body9_exit.i75 ], [ %spec.select.i55, %then6.i52 ]
  %tmp76.i83 = getelementptr i8, ptr %buffer.sroa.0.3, i64 %4
  store i8 %tmp34, ptr %tmp76.i83, align 1
  %tmp85.i85 = add i32 %buffer.sroa.34.0223, 1
  %tmp39 = load i64, ptr %mut_n, align 8
  %tmp40 = sdiv i64 %tmp39, 10
  store i64 %tmp40, ptr %mut_n, align 8
  %tmp39.off = add i64 %tmp39, 9
  %tmp29 = icmp ult i64 %tmp39.off, 19
  br i1 %tmp29, label %loop_body14_exit, label %end_if15

loop_body14_exit:                                 ; preds = %push.exit88
  %buffer.sroa.0.3.lcssa249 = ptrtoint ptr %buffer.sroa.0.3 to i64
  %tmp41.pre = load i32, ptr %is_negative, align 4
  %tmp42.not = icmp eq i32 %tmp41.pre, 0
  br i1 %tmp42.not, label %end_if16, label %then16

then16:                                           ; preds = %loop_body14_exit
  %tmp8.not.i93 = icmp ult i32 %tmp85.i85, %buffer.sroa.67.3
  br i1 %tmp8.not.i93, label %push.exit130, label %loop_body9.preheader.i103

loop_body9.preheader.i103:                        ; preds = %then16
  %tmp14.not.i95 = icmp eq i32 %buffer.sroa.67.3, 0
  %tmp20.i96 = shl i32 %buffer.sroa.67.3, 1
  %spec.select.i97 = select i1 %tmp14.not.i95, i32 4, i32 %tmp20.i96
  %tmp24.i98 = zext i32 %spec.select.i97 to i64
  %tmp2.i.i99 = tail call ptr @GetProcessHeap()
  %tmp4.i.i100 = tail call ptr @HeapAlloc(ptr %tmp2.i.i99, i32 0, i64 %tmp24.i98)
  %tmp38.not4.not.i105 = icmp eq i32 %tmp85.i85, 0
  br i1 %tmp38.not4.not.i105, label %loop_body9_exit.i117, label %iter.check254

iter.check254:                                    ; preds = %loop_body9.preheader.i103
  %tmp4.i.i100248 = ptrtoint ptr %tmp4.i.i100 to i64
  %15 = zext i32 %tmp85.i85 to i64
  %min.iters.check252 = icmp ult i32 %tmp85.i85, 8
  %16 = sub i64 %tmp4.i.i100248, %buffer.sroa.0.3.lcssa249
  %diff.check250 = icmp ult i64 %16, 32
  %or.cond315 = select i1 %min.iters.check252, i1 true, i1 %diff.check250
  br i1 %or.cond315, label %end_if10.i106.preheader, label %vector.main.loop.iter.check256

vector.main.loop.iter.check256:                   ; preds = %iter.check254
  %min.iters.check255 = icmp ult i32 %tmp85.i85, 32
  br i1 %min.iters.check255, label %vec.epilog.ph269, label %vector.ph257

vector.ph257:                                     ; preds = %vector.main.loop.iter.check256
  %n.vec259 = and i64 %15, 4294967264
  br label %vector.body261

vector.body261:                                   ; preds = %vector.body261, %vector.ph257
  %index262 = phi i64 [ 0, %vector.ph257 ], [ %index.next265, %vector.body261 ]
  %17 = getelementptr i8, ptr %tmp4.i.i100, i64 %index262
  %18 = getelementptr i8, ptr %buffer.sroa.0.3, i64 %index262
  %19 = getelementptr i8, ptr %18, i64 16
  %wide.load263 = load <16 x i8>, ptr %18, align 1
  %wide.load264 = load <16 x i8>, ptr %19, align 1
  %20 = getelementptr i8, ptr %17, i64 16
  store <16 x i8> %wide.load263, ptr %17, align 1
  store <16 x i8> %wide.load264, ptr %20, align 1
  %index.next265 = add nuw i64 %index262, 32
  %21 = icmp eq i64 %index.next265, %n.vec259
  br i1 %21, label %middle.block251, label %vector.body261, !llvm.loop !5

middle.block251:                                  ; preds = %vector.body261
  %cmp.n260 = icmp eq i64 %n.vec259, %15
  br i1 %cmp.n260, label %loop_body9_exit.i117, label %vec.epilog.iter.check268

vec.epilog.iter.check268:                         ; preds = %middle.block251
  %n.vec.remaining270 = and i64 %15, 24
  %min.epilog.iters.check271 = icmp eq i64 %n.vec.remaining270, 0
  br i1 %min.epilog.iters.check271, label %end_if10.i106.preheader, label %vec.epilog.ph269

vec.epilog.ph269:                                 ; preds = %vector.main.loop.iter.check256, %vec.epilog.iter.check268
  %vec.epilog.resume.val272 = phi i64 [ %n.vec259, %vec.epilog.iter.check268 ], [ 0, %vector.main.loop.iter.check256 ]
  %n.vec274 = and i64 %15, 4294967288
  br label %vec.epilog.vector.body277

vec.epilog.vector.body277:                        ; preds = %vec.epilog.vector.body277, %vec.epilog.ph269
  %index278 = phi i64 [ %vec.epilog.resume.val272, %vec.epilog.ph269 ], [ %index.next280, %vec.epilog.vector.body277 ]
  %22 = getelementptr i8, ptr %tmp4.i.i100, i64 %index278
  %23 = getelementptr i8, ptr %buffer.sroa.0.3, i64 %index278
  %wide.load279 = load <8 x i8>, ptr %23, align 1
  store <8 x i8> %wide.load279, ptr %22, align 1
  %index.next280 = add nuw i64 %index278, 8
  %24 = icmp eq i64 %index.next280, %n.vec274
  br i1 %24, label %vec.epilog.middle.block266, label %vec.epilog.vector.body277, !llvm.loop !6

vec.epilog.middle.block266:                       ; preds = %vec.epilog.vector.body277
  %cmp.n276 = icmp eq i64 %n.vec274, %15
  br i1 %cmp.n276, label %loop_body9_exit.i117, label %end_if10.i106.preheader

end_if10.i106.preheader:                          ; preds = %iter.check254, %vec.epilog.iter.check268, %vec.epilog.middle.block266
  %indvars.iv.i107.ph = phi i64 [ 0, %iter.check254 ], [ %n.vec259, %vec.epilog.iter.check268 ], [ %n.vec274, %vec.epilog.middle.block266 ]
  br label %end_if10.i106

end_if10.i106:                                    ; preds = %end_if10.i106.preheader, %end_if10.i106
  %indvars.iv.i107 = phi i64 [ %indvars.iv.next.i112, %end_if10.i106 ], [ %indvars.iv.i107.ph, %end_if10.i106.preheader ]
  %tmp42.i108 = getelementptr i8, ptr %tmp4.i.i100, i64 %indvars.iv.i107
  %tmp49.i110 = getelementptr i8, ptr %buffer.sroa.0.3, i64 %indvars.iv.i107
  %tmp50.i111 = load i8, ptr %tmp49.i110, align 1
  store i8 %tmp50.i111, ptr %tmp42.i108, align 1
  %indvars.iv.next.i112 = add nuw nsw i64 %indvars.iv.i107, 1
  %exitcond232.not = icmp eq i64 %indvars.iv.next.i112, %15
  br i1 %exitcond232.not, label %loop_body9_exit.i117, label %end_if10.i106, !llvm.loop !7

loop_body9_exit.i117:                             ; preds = %end_if10.i106, %middle.block251, %vec.epilog.middle.block266, %loop_body9.preheader.i103
  %tmp2.i1.i119 = tail call ptr @GetProcessHeap()
  %25 = tail call i32 @HeapFree(ptr %tmp2.i1.i119, i32 0, ptr nonnull %buffer.sroa.0.3)
  br label %push.exit130

push.exit130:                                     ; preds = %loop_body9_exit.i117, %then16
  %buffer.sroa.0.4 = phi ptr [ %buffer.sroa.0.3, %then16 ], [ %tmp4.i.i100, %loop_body9_exit.i117 ]
  %buffer.sroa.67.4 = phi i32 [ %buffer.sroa.67.3, %then16 ], [ %spec.select.i97, %loop_body9_exit.i117 ]
  %tmp75.i124 = zext i32 %tmp85.i85 to i64
  %tmp76.i125 = getelementptr i8, ptr %buffer.sroa.0.4, i64 %tmp75.i124
  store i8 45, ptr %tmp76.i125, align 1
  %tmp85.i127 = add i32 %buffer.sroa.34.0223, 2
  br label %end_if16

end_if16:                                         ; preds = %push.exit130, %loop_body14_exit
  %buffer.sroa.0.5 = phi ptr [ %buffer.sroa.0.3, %loop_body14_exit ], [ %buffer.sroa.0.4, %push.exit130 ]
  %buffer.sroa.34.1 = phi i32 [ %tmp85.i85, %loop_body14_exit ], [ %tmp85.i127, %push.exit130 ]
  %buffer.sroa.67.5 = phi i32 [ %buffer.sroa.67.3, %loop_body14_exit ], [ %buffer.sroa.67.4, %push.exit130 ]
  %buffer.sroa.0.5283 = ptrtoint ptr %buffer.sroa.0.5 to i64
  %i = alloca i32, align 4
  store i32 0, ptr %i, align 4
  %j = alloca i32, align 4
  %storemerge227 = add i32 %buffer.sroa.34.1, -1
  store i32 %storemerge227, ptr %j, align 4
  %tmp53.not229.not = icmp eq i32 %storemerge227, 0
  br i1 %tmp53.not229.not, label %loop_body17_exit, label %end_if18

end_if18:                                         ; preds = %end_if16, %end_if18
  %tmp51231 = phi i32 [ %tmp84, %end_if18 ], [ 0, %end_if16 ]
  %storemerge230 = phi i32 [ %storemerge, %end_if18 ], [ %storemerge227, %end_if16 ]
  %temp = alloca i8, align 1
  %tmp59 = zext i32 %tmp51231 to i64
  %tmp60 = getelementptr i8, ptr %buffer.sroa.0.5, i64 %tmp59
  %tmp61 = load i8, ptr %tmp60, align 1
  store i8 %tmp61, ptr %temp, align 1
  %tmp72 = zext i32 %storemerge230 to i64
  %tmp73 = getelementptr i8, ptr %buffer.sroa.0.5, i64 %tmp72
  %tmp74 = load i8, ptr %tmp73, align 1
  store i8 %tmp74, ptr %tmp60, align 1
  %tmp81 = load i8, ptr %temp, align 1
  store i8 %tmp81, ptr %tmp73, align 1
  %tmp83 = load i32, ptr %i, align 4
  %tmp84 = add i32 %tmp83, 1
  store i32 %tmp84, ptr %i, align 4
  %tmp86 = load i32, ptr %j, align 4
  %storemerge = add i32 %tmp86, -1
  store i32 %storemerge, ptr %j, align 4
  %tmp53.not = icmp ult i32 %tmp84, %storemerge
  br i1 %tmp53.not, label %end_if18, label %loop_body17_exit

loop_body17_exit:                                 ; preds = %end_if18, %end_if16
  %tmp8.not.i135 = icmp ult i32 %buffer.sroa.34.1, %buffer.sroa.67.5
  br i1 %tmp8.not.i135, label %push.exit172, label %loop_body9.preheader.i145

loop_body9.preheader.i145:                        ; preds = %loop_body17_exit
  %tmp14.not.i137 = icmp eq i32 %buffer.sroa.67.5, 0
  %tmp20.i138 = shl i32 %buffer.sroa.67.5, 1
  %spec.select.i139 = select i1 %tmp14.not.i137, i32 4, i32 %tmp20.i138
  %tmp24.i140 = zext i32 %spec.select.i139 to i64
  %tmp2.i.i141 = tail call ptr @GetProcessHeap()
  %tmp4.i.i142 = tail call ptr @HeapAlloc(ptr %tmp2.i.i141, i32 0, i64 %tmp24.i140)
  %tmp38.not4.not.i147 = icmp eq i32 %buffer.sroa.34.1, 0
  br i1 %tmp38.not4.not.i147, label %loop_body9_exit.i159, label %iter.check288

iter.check288:                                    ; preds = %loop_body9.preheader.i145
  %tmp4.i.i142282 = ptrtoint ptr %tmp4.i.i142 to i64
  %26 = zext i32 %buffer.sroa.34.1 to i64
  %min.iters.check286 = icmp ult i32 %buffer.sroa.34.1, 8
  %27 = sub i64 %tmp4.i.i142282, %buffer.sroa.0.5283
  %diff.check284 = icmp ult i64 %27, 32
  %or.cond316 = select i1 %min.iters.check286, i1 true, i1 %diff.check284
  br i1 %or.cond316, label %end_if10.i148.preheader, label %vector.main.loop.iter.check290

vector.main.loop.iter.check290:                   ; preds = %iter.check288
  %min.iters.check289 = icmp ult i32 %buffer.sroa.34.1, 32
  br i1 %min.iters.check289, label %vec.epilog.ph303, label %vector.ph291

vector.ph291:                                     ; preds = %vector.main.loop.iter.check290
  %n.vec293 = and i64 %26, 4294967264
  br label %vector.body295

vector.body295:                                   ; preds = %vector.body295, %vector.ph291
  %index296 = phi i64 [ 0, %vector.ph291 ], [ %index.next299, %vector.body295 ]
  %28 = getelementptr i8, ptr %tmp4.i.i142, i64 %index296
  %29 = getelementptr i8, ptr %buffer.sroa.0.5, i64 %index296
  %30 = getelementptr i8, ptr %29, i64 16
  %wide.load297 = load <16 x i8>, ptr %29, align 1
  %wide.load298 = load <16 x i8>, ptr %30, align 1
  %31 = getelementptr i8, ptr %28, i64 16
  store <16 x i8> %wide.load297, ptr %28, align 1
  store <16 x i8> %wide.load298, ptr %31, align 1
  %index.next299 = add nuw i64 %index296, 32
  %32 = icmp eq i64 %index.next299, %n.vec293
  br i1 %32, label %middle.block285, label %vector.body295, !llvm.loop !8

middle.block285:                                  ; preds = %vector.body295
  %cmp.n294 = icmp eq i64 %n.vec293, %26
  br i1 %cmp.n294, label %loop_body9_exit.i159, label %vec.epilog.iter.check302

vec.epilog.iter.check302:                         ; preds = %middle.block285
  %n.vec.remaining304 = and i64 %26, 24
  %min.epilog.iters.check305 = icmp eq i64 %n.vec.remaining304, 0
  br i1 %min.epilog.iters.check305, label %end_if10.i148.preheader, label %vec.epilog.ph303

vec.epilog.ph303:                                 ; preds = %vector.main.loop.iter.check290, %vec.epilog.iter.check302
  %vec.epilog.resume.val306 = phi i64 [ %n.vec293, %vec.epilog.iter.check302 ], [ 0, %vector.main.loop.iter.check290 ]
  %n.vec308 = and i64 %26, 4294967288
  br label %vec.epilog.vector.body311

vec.epilog.vector.body311:                        ; preds = %vec.epilog.vector.body311, %vec.epilog.ph303
  %index312 = phi i64 [ %vec.epilog.resume.val306, %vec.epilog.ph303 ], [ %index.next314, %vec.epilog.vector.body311 ]
  %33 = getelementptr i8, ptr %tmp4.i.i142, i64 %index312
  %34 = getelementptr i8, ptr %buffer.sroa.0.5, i64 %index312
  %wide.load313 = load <8 x i8>, ptr %34, align 1
  store <8 x i8> %wide.load313, ptr %33, align 1
  %index.next314 = add nuw i64 %index312, 8
  %35 = icmp eq i64 %index.next314, %n.vec308
  br i1 %35, label %vec.epilog.middle.block300, label %vec.epilog.vector.body311, !llvm.loop !9

vec.epilog.middle.block300:                       ; preds = %vec.epilog.vector.body311
  %cmp.n310 = icmp eq i64 %n.vec308, %26
  br i1 %cmp.n310, label %loop_body9_exit.i159, label %end_if10.i148.preheader

end_if10.i148.preheader:                          ; preds = %iter.check288, %vec.epilog.iter.check302, %vec.epilog.middle.block300
  %indvars.iv.i149.ph = phi i64 [ 0, %iter.check288 ], [ %n.vec293, %vec.epilog.iter.check302 ], [ %n.vec308, %vec.epilog.middle.block300 ]
  br label %end_if10.i148

end_if10.i148:                                    ; preds = %end_if10.i148.preheader, %end_if10.i148
  %indvars.iv.i149 = phi i64 [ %indvars.iv.next.i154, %end_if10.i148 ], [ %indvars.iv.i149.ph, %end_if10.i148.preheader ]
  %tmp42.i150 = getelementptr i8, ptr %tmp4.i.i142, i64 %indvars.iv.i149
  %tmp49.i152 = getelementptr i8, ptr %buffer.sroa.0.5, i64 %indvars.iv.i149
  %tmp50.i153 = load i8, ptr %tmp49.i152, align 1
  store i8 %tmp50.i153, ptr %tmp42.i150, align 1
  %indvars.iv.next.i154 = add nuw nsw i64 %indvars.iv.i149, 1
  %exitcond233.not = icmp eq i64 %indvars.iv.next.i154, %26
  br i1 %exitcond233.not, label %loop_body9_exit.i159, label %end_if10.i148, !llvm.loop !10

loop_body9_exit.i159:                             ; preds = %end_if10.i148, %middle.block285, %vec.epilog.middle.block300, %loop_body9.preheader.i145
  %tmp2.i1.i161 = tail call ptr @GetProcessHeap()
  %36 = tail call i32 @HeapFree(ptr %tmp2.i1.i161, i32 0, ptr nonnull %buffer.sroa.0.5)
  br label %push.exit172

push.exit172:                                     ; preds = %loop_body9_exit.i159, %loop_body17_exit
  %buffer.sroa.0.6 = phi ptr [ %buffer.sroa.0.5, %loop_body17_exit ], [ %tmp4.i.i142, %loop_body9_exit.i159 ]
  %tmp75.i166 = zext i32 %buffer.sroa.34.1 to i64
  %tmp76.i167 = getelementptr i8, ptr %buffer.sroa.0.6, i64 %tmp75.i166
  store i8 10, ptr %tmp76.i167, align 1
  %tmp85.i169 = add i32 %buffer.sroa.34.1, 1
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %chars_written.i173)
  %tmp2.i.i174 = tail call ptr @GetStdHandle(i32 -11)
  %tmp5.i.i175 = icmp eq ptr %tmp2.i.i174, inttoptr (i64 -1 to ptr)
  br i1 %tmp5.i.i175, label %then0.i.i176, label %then11.i180

then0.i.i176:                                     ; preds = %push.exit172
  tail call void @ExitProcess(i32 -1)
  br label %then11.i180

then11.i180:                                      ; preds = %then0.i.i176, %push.exit172
  %37 = call i32 @WriteConsoleA(ptr %tmp2.i.i174, ptr nonnull %buffer.sroa.0.6, i32 %tmp85.i169, ptr nonnull %chars_written.i173, ptr null)
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %chars_written.i173)
  br label %common.ret
}

define noundef i32 @main() local_unnamed_addr {
free_vec.exit:
  %0 = tail call i32 @AllocConsole()
  tail call void @println_i32(i32 0)
  tail call void @println_i32(i32 -1432)
  tail call void @println_i32(i32 1342)
  %1 = tail call i32 @FreeConsole()
  %tmp2.i.i = tail call ptr @GetProcessHeap()
  %tmp4.i.i = tail call ptr @HeapAlloc(ptr %tmp2.i.i, i32 0, i64 4)
  store i8 32, ptr %tmp4.i.i, align 1
  %tmp2.i.i2 = tail call ptr @GetProcessHeap()
  %2 = tail call i32 @HeapFree(ptr %tmp2.i.i2, i32 0, ptr nonnull %tmp4.i.i)
  %tmp2.i.i3 = tail call ptr @GetProcessHeap()
  %tmp4.i.i4 = tail call ptr @HeapAlloc(ptr %tmp2.i.i3, i32 0, i64 12)
  store ptr null, ptr %tmp4.i.i4, align 8
  %tmp9.i = getelementptr inbounds %struct.ListNode, ptr %tmp4.i.i4, i64 0, i32 1
  store i32 64, ptr %tmp9.i, align 4
  %tmp2.i.i517 = tail call ptr @GetProcessHeap()
  %3 = tail call i32 @HeapFree(ptr %tmp2.i.i517, i32 0, ptr nonnull %tmp4.i.i4)
  ret i32 0
}

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #3

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #4

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #4

attributes #0 = { mustprogress nofree norecurse nosync nounwind willreturn memory(none) }
attributes #1 = { mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write) }
attributes #2 = { nofree norecurse nosync nounwind memory(read, inaccessiblemem: none) }
attributes #3 = { nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #4 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }

!0 = distinct !{!0, !1, !2}
!1 = !{!"llvm.loop.isvectorized", i32 1}
!2 = !{!"llvm.loop.unroll.runtime.disable"}
!3 = distinct !{!3, !1, !2}
!4 = distinct !{!4, !1}
!5 = distinct !{!5, !1, !2}
!6 = distinct !{!6, !1, !2}
!7 = distinct !{!7, !1}
!8 = distinct !{!8, !1, !2}
!9 = distinct !{!9, !1, !2}
!10 = distinct !{!10, !1}
