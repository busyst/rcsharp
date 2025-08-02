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
  %chars_written.i215 = alloca i32, align 4
  %chars_written.i = alloca i32, align 4
  %tmp3 = icmp eq i32 %n, 0
  br i1 %tmp3, label %push.exit43, label %end_if12

common.ret:                                       ; preds = %then11.i222, %free_vec.exit
  %buffer.sroa.0.7.sink = phi ptr [ %buffer.sroa.0.7, %then11.i222 ], [ %tmp4.i.i, %free_vec.exit ]
  %tmp2.i.i223 = call ptr @GetProcessHeap()
  %1 = call i32 @HeapFree(ptr %tmp2.i.i223, i32 0, ptr nonnull %buffer.sroa.0.7.sink)
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
  %tmp28269.ph = phi i64 [ %tmp27, %then13 ], [ %tmp20, %end_if12 ]
  br label %end_if15

end_if15:                                         ; preds = %end_if15.preheader, %push.exit88
  %buffer.sroa.78.2272 = phi i32 [ %buffer.sroa.78.3, %push.exit88 ], [ 0, %end_if15.preheader ]
  %buffer.sroa.39.0271 = phi i32 [ %tmp85.i85, %push.exit88 ], [ 0, %end_if15.preheader ]
  %buffer.sroa.0.2270 = phi ptr [ %buffer.sroa.0.3, %push.exit88 ], [ null, %end_if15.preheader ]
  %tmp28269 = phi i64 [ %tmp40, %push.exit88 ], [ %tmp28269.ph, %end_if15.preheader ]
  %3 = zext i32 %buffer.sroa.39.0271 to i64
  %buffer.sroa.0.2270287 = ptrtoint ptr %buffer.sroa.0.2270 to i64
  %4 = zext i32 %buffer.sroa.39.0271 to i64
  %tmp32 = srem i64 %tmp28269, 10
  %tmp33 = trunc i64 %tmp32 to i8
  %tmp34 = add nsw i8 %tmp33, 48
  %tmp8.not.i51 = icmp ult i32 %buffer.sroa.39.0271, %buffer.sroa.78.2272
  br i1 %tmp8.not.i51, label %push.exit88, label %then6.i52

then6.i52:                                        ; preds = %end_if15
  %tmp14.not.i53 = icmp eq i32 %buffer.sroa.78.2272, 0
  %tmp20.i54 = shl i32 %buffer.sroa.78.2272, 1
  %spec.select.i55 = select i1 %tmp14.not.i53, i32 4, i32 %tmp20.i54
  %tmp24.i56 = zext i32 %spec.select.i55 to i64
  %tmp2.i.i57 = tail call ptr @GetProcessHeap()
  %tmp4.i.i58 = tail call ptr @HeapAlloc(ptr %tmp2.i.i57, i32 0, i64 %tmp24.i56)
  %tmp4.i.i58286 = ptrtoint ptr %tmp4.i.i58 to i64
  %tmp31.not.i60 = icmp eq ptr %buffer.sroa.0.2270, null
  br i1 %tmp31.not.i60, label %push.exit88, label %loop_body9.preheader.i61

loop_body9.preheader.i61:                         ; preds = %then6.i52
  %tmp38.not4.not.i63 = icmp eq i32 %buffer.sroa.39.0271, 0
  br i1 %tmp38.not4.not.i63, label %loop_body9_exit.i75, label %iter.check

iter.check:                                       ; preds = %loop_body9.preheader.i61
  %min.iters.check = icmp ult i32 %buffer.sroa.39.0271, 8
  %5 = sub i64 %tmp4.i.i58286, %buffer.sroa.0.2270287
  %diff.check = icmp ult i64 %5, 32
  %or.cond = select i1 %min.iters.check, i1 true, i1 %diff.check
  br i1 %or.cond, label %end_if10.i64.preheader, label %vector.main.loop.iter.check

vector.main.loop.iter.check:                      ; preds = %iter.check
  %min.iters.check288 = icmp ult i32 %buffer.sroa.39.0271, 32
  br i1 %min.iters.check288, label %vec.epilog.ph, label %vector.ph

vector.ph:                                        ; preds = %vector.main.loop.iter.check
  %n.vec = and i64 %3, 4294967264
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %6 = getelementptr i8, ptr %tmp4.i.i58, i64 %index
  %7 = getelementptr i8, ptr %buffer.sroa.0.2270, i64 %index
  %8 = getelementptr i8, ptr %7, i64 16
  %wide.load = load <16 x i8>, ptr %7, align 1
  %wide.load289 = load <16 x i8>, ptr %8, align 1
  %9 = getelementptr i8, ptr %6, i64 16
  store <16 x i8> %wide.load, ptr %6, align 1
  store <16 x i8> %wide.load289, ptr %9, align 1
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
  %n.vec291 = and i64 %3, 4294967288
  br label %vec.epilog.vector.body

vec.epilog.vector.body:                           ; preds = %vec.epilog.vector.body, %vec.epilog.ph
  %index293 = phi i64 [ %vec.epilog.resume.val, %vec.epilog.ph ], [ %index.next295, %vec.epilog.vector.body ]
  %11 = getelementptr i8, ptr %tmp4.i.i58, i64 %index293
  %12 = getelementptr i8, ptr %buffer.sroa.0.2270, i64 %index293
  %wide.load294 = load <8 x i8>, ptr %12, align 1
  store <8 x i8> %wide.load294, ptr %11, align 1
  %index.next295 = add nuw i64 %index293, 8
  %13 = icmp eq i64 %index.next295, %n.vec291
  br i1 %13, label %vec.epilog.middle.block, label %vec.epilog.vector.body, !llvm.loop !3

vec.epilog.middle.block:                          ; preds = %vec.epilog.vector.body
  %cmp.n292 = icmp eq i64 %n.vec291, %3
  br i1 %cmp.n292, label %loop_body9_exit.i75, label %end_if10.i64.preheader

end_if10.i64.preheader:                           ; preds = %iter.check, %vec.epilog.iter.check, %vec.epilog.middle.block
  %indvars.iv.i65.ph = phi i64 [ 0, %iter.check ], [ %n.vec, %vec.epilog.iter.check ], [ %n.vec291, %vec.epilog.middle.block ]
  br label %end_if10.i64

end_if10.i64:                                     ; preds = %end_if10.i64.preheader, %end_if10.i64
  %indvars.iv.i65 = phi i64 [ %indvars.iv.next.i70, %end_if10.i64 ], [ %indvars.iv.i65.ph, %end_if10.i64.preheader ]
  %tmp42.i66 = getelementptr i8, ptr %tmp4.i.i58, i64 %indvars.iv.i65
  %tmp49.i68 = getelementptr i8, ptr %buffer.sroa.0.2270, i64 %indvars.iv.i65
  %tmp50.i69 = load i8, ptr %tmp49.i68, align 1
  store i8 %tmp50.i69, ptr %tmp42.i66, align 1
  %indvars.iv.next.i70 = add nuw nsw i64 %indvars.iv.i65, 1
  %exitcond.not = icmp eq i64 %indvars.iv.next.i70, %4
  br i1 %exitcond.not, label %loop_body9_exit.i75, label %end_if10.i64, !llvm.loop !4

loop_body9_exit.i75:                              ; preds = %end_if10.i64, %middle.block, %vec.epilog.middle.block, %loop_body9.preheader.i61
  %tmp2.i1.i77 = tail call ptr @GetProcessHeap()
  %14 = tail call i32 @HeapFree(ptr %tmp2.i1.i77, i32 0, ptr nonnull %buffer.sroa.0.2270)
  br label %push.exit88

push.exit88:                                      ; preds = %then6.i52, %loop_body9_exit.i75, %end_if15
  %buffer.sroa.0.3 = phi ptr [ %buffer.sroa.0.2270, %end_if15 ], [ %tmp4.i.i58, %loop_body9_exit.i75 ], [ %tmp4.i.i58, %then6.i52 ]
  %buffer.sroa.78.3 = phi i32 [ %buffer.sroa.78.2272, %end_if15 ], [ %spec.select.i55, %loop_body9_exit.i75 ], [ %spec.select.i55, %then6.i52 ]
  %tmp76.i83 = getelementptr i8, ptr %buffer.sroa.0.3, i64 %4
  store i8 %tmp34, ptr %tmp76.i83, align 1
  %tmp85.i85 = add i32 %buffer.sroa.39.0271, 1
  %tmp39 = load i64, ptr %mut_n, align 8
  %tmp40 = sdiv i64 %tmp39, 10
  store i64 %tmp40, ptr %mut_n, align 8
  %tmp39.off = add i64 %tmp39, 9
  %tmp29 = icmp ult i64 %tmp39.off, 19
  br i1 %tmp29, label %loop_body14_exit, label %end_if15

loop_body14_exit:                                 ; preds = %push.exit88
  %buffer.sroa.0.3.lcssa298 = ptrtoint ptr %buffer.sroa.0.3 to i64
  %tmp41.pre = load i32, ptr %is_negative, align 4
  %tmp42.not = icmp eq i32 %tmp41.pre, 0
  br i1 %tmp42.not, label %end_if16, label %then16

then16:                                           ; preds = %loop_body14_exit
  %tmp8.not.i93 = icmp ult i32 %tmp85.i85, %buffer.sroa.78.3
  br i1 %tmp8.not.i93, label %push.exit130, label %loop_body9.preheader.i103

loop_body9.preheader.i103:                        ; preds = %then16
  %tmp14.not.i95 = icmp eq i32 %buffer.sroa.78.3, 0
  %tmp20.i96 = shl i32 %buffer.sroa.78.3, 1
  %spec.select.i97 = select i1 %tmp14.not.i95, i32 4, i32 %tmp20.i96
  %tmp24.i98 = zext i32 %spec.select.i97 to i64
  %tmp2.i.i99 = tail call ptr @GetProcessHeap()
  %tmp4.i.i100 = tail call ptr @HeapAlloc(ptr %tmp2.i.i99, i32 0, i64 %tmp24.i98)
  %tmp38.not4.not.i105 = icmp eq i32 %tmp85.i85, 0
  br i1 %tmp38.not4.not.i105, label %loop_body9_exit.i117, label %iter.check303

iter.check303:                                    ; preds = %loop_body9.preheader.i103
  %tmp4.i.i100297 = ptrtoint ptr %tmp4.i.i100 to i64
  %15 = zext i32 %tmp85.i85 to i64
  %min.iters.check301 = icmp ult i32 %tmp85.i85, 8
  %16 = sub i64 %tmp4.i.i100297, %buffer.sroa.0.3.lcssa298
  %diff.check299 = icmp ult i64 %16, 32
  %or.cond398 = select i1 %min.iters.check301, i1 true, i1 %diff.check299
  br i1 %or.cond398, label %end_if10.i106.preheader, label %vector.main.loop.iter.check305

vector.main.loop.iter.check305:                   ; preds = %iter.check303
  %min.iters.check304 = icmp ult i32 %tmp85.i85, 32
  br i1 %min.iters.check304, label %vec.epilog.ph318, label %vector.ph306

vector.ph306:                                     ; preds = %vector.main.loop.iter.check305
  %n.vec308 = and i64 %15, 4294967264
  br label %vector.body310

vector.body310:                                   ; preds = %vector.body310, %vector.ph306
  %index311 = phi i64 [ 0, %vector.ph306 ], [ %index.next314, %vector.body310 ]
  %17 = getelementptr i8, ptr %tmp4.i.i100, i64 %index311
  %18 = getelementptr i8, ptr %buffer.sroa.0.3, i64 %index311
  %19 = getelementptr i8, ptr %18, i64 16
  %wide.load312 = load <16 x i8>, ptr %18, align 1
  %wide.load313 = load <16 x i8>, ptr %19, align 1
  %20 = getelementptr i8, ptr %17, i64 16
  store <16 x i8> %wide.load312, ptr %17, align 1
  store <16 x i8> %wide.load313, ptr %20, align 1
  %index.next314 = add nuw i64 %index311, 32
  %21 = icmp eq i64 %index.next314, %n.vec308
  br i1 %21, label %middle.block300, label %vector.body310, !llvm.loop !5

middle.block300:                                  ; preds = %vector.body310
  %cmp.n309 = icmp eq i64 %n.vec308, %15
  br i1 %cmp.n309, label %loop_body9_exit.i117, label %vec.epilog.iter.check317

vec.epilog.iter.check317:                         ; preds = %middle.block300
  %n.vec.remaining319 = and i64 %15, 24
  %min.epilog.iters.check320 = icmp eq i64 %n.vec.remaining319, 0
  br i1 %min.epilog.iters.check320, label %end_if10.i106.preheader, label %vec.epilog.ph318

vec.epilog.ph318:                                 ; preds = %vector.main.loop.iter.check305, %vec.epilog.iter.check317
  %vec.epilog.resume.val321 = phi i64 [ %n.vec308, %vec.epilog.iter.check317 ], [ 0, %vector.main.loop.iter.check305 ]
  %n.vec323 = and i64 %15, 4294967288
  br label %vec.epilog.vector.body326

vec.epilog.vector.body326:                        ; preds = %vec.epilog.vector.body326, %vec.epilog.ph318
  %index327 = phi i64 [ %vec.epilog.resume.val321, %vec.epilog.ph318 ], [ %index.next329, %vec.epilog.vector.body326 ]
  %22 = getelementptr i8, ptr %tmp4.i.i100, i64 %index327
  %23 = getelementptr i8, ptr %buffer.sroa.0.3, i64 %index327
  %wide.load328 = load <8 x i8>, ptr %23, align 1
  store <8 x i8> %wide.load328, ptr %22, align 1
  %index.next329 = add nuw i64 %index327, 8
  %24 = icmp eq i64 %index.next329, %n.vec323
  br i1 %24, label %vec.epilog.middle.block315, label %vec.epilog.vector.body326, !llvm.loop !6

vec.epilog.middle.block315:                       ; preds = %vec.epilog.vector.body326
  %cmp.n325 = icmp eq i64 %n.vec323, %15
  br i1 %cmp.n325, label %loop_body9_exit.i117, label %end_if10.i106.preheader

end_if10.i106.preheader:                          ; preds = %iter.check303, %vec.epilog.iter.check317, %vec.epilog.middle.block315
  %indvars.iv.i107.ph = phi i64 [ 0, %iter.check303 ], [ %n.vec308, %vec.epilog.iter.check317 ], [ %n.vec323, %vec.epilog.middle.block315 ]
  br label %end_if10.i106

end_if10.i106:                                    ; preds = %end_if10.i106.preheader, %end_if10.i106
  %indvars.iv.i107 = phi i64 [ %indvars.iv.next.i112, %end_if10.i106 ], [ %indvars.iv.i107.ph, %end_if10.i106.preheader ]
  %tmp42.i108 = getelementptr i8, ptr %tmp4.i.i100, i64 %indvars.iv.i107
  %tmp49.i110 = getelementptr i8, ptr %buffer.sroa.0.3, i64 %indvars.iv.i107
  %tmp50.i111 = load i8, ptr %tmp49.i110, align 1
  store i8 %tmp50.i111, ptr %tmp42.i108, align 1
  %indvars.iv.next.i112 = add nuw nsw i64 %indvars.iv.i107, 1
  %exitcond280.not = icmp eq i64 %indvars.iv.next.i112, %15
  br i1 %exitcond280.not, label %loop_body9_exit.i117, label %end_if10.i106, !llvm.loop !7

loop_body9_exit.i117:                             ; preds = %end_if10.i106, %middle.block300, %vec.epilog.middle.block315, %loop_body9.preheader.i103
  %tmp2.i1.i119 = tail call ptr @GetProcessHeap()
  %25 = tail call i32 @HeapFree(ptr %tmp2.i1.i119, i32 0, ptr nonnull %buffer.sroa.0.3)
  br label %push.exit130

push.exit130:                                     ; preds = %loop_body9_exit.i117, %then16
  %buffer.sroa.0.4 = phi ptr [ %buffer.sroa.0.3, %then16 ], [ %tmp4.i.i100, %loop_body9_exit.i117 ]
  %buffer.sroa.78.4 = phi i32 [ %buffer.sroa.78.3, %then16 ], [ %spec.select.i97, %loop_body9_exit.i117 ]
  %tmp75.i124 = zext i32 %tmp85.i85 to i64
  %tmp76.i125 = getelementptr i8, ptr %buffer.sroa.0.4, i64 %tmp75.i124
  store i8 45, ptr %tmp76.i125, align 1
  %tmp85.i127 = add i32 %buffer.sroa.39.0271, 2
  br label %end_if16

end_if16:                                         ; preds = %push.exit130, %loop_body14_exit
  %buffer.sroa.0.5 = phi ptr [ %buffer.sroa.0.3, %loop_body14_exit ], [ %buffer.sroa.0.4, %push.exit130 ]
  %buffer.sroa.39.1 = phi i32 [ %tmp85.i85, %loop_body14_exit ], [ %tmp85.i127, %push.exit130 ]
  %buffer.sroa.78.5 = phi i32 [ %buffer.sroa.78.3, %loop_body14_exit ], [ %buffer.sroa.78.4, %push.exit130 ]
  %buffer.sroa.0.5332 = ptrtoint ptr %buffer.sroa.0.5 to i64
  %i = alloca i32, align 4
  store i32 0, ptr %i, align 4
  %j = alloca i32, align 4
  %storemerge275 = add i32 %buffer.sroa.39.1, -1
  store i32 %storemerge275, ptr %j, align 4
  %tmp53.not277.not = icmp eq i32 %storemerge275, 0
  br i1 %tmp53.not277.not, label %loop_body17_exit, label %end_if18

end_if18:                                         ; preds = %end_if16, %end_if18
  %tmp51279 = phi i32 [ %tmp84, %end_if18 ], [ 0, %end_if16 ]
  %storemerge278 = phi i32 [ %storemerge, %end_if18 ], [ %storemerge275, %end_if16 ]
  %temp = alloca i8, align 1
  %tmp59 = zext i32 %tmp51279 to i64
  %tmp60 = getelementptr i8, ptr %buffer.sroa.0.5, i64 %tmp59
  %tmp61 = load i8, ptr %tmp60, align 1
  store i8 %tmp61, ptr %temp, align 1
  %tmp72 = zext i32 %storemerge278 to i64
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
  %tmp8.not.i135 = icmp ult i32 %buffer.sroa.39.1, %buffer.sroa.78.5
  br i1 %tmp8.not.i135, label %push.exit172, label %loop_body9.preheader.i145

loop_body9.preheader.i145:                        ; preds = %loop_body17_exit
  %tmp14.not.i137 = icmp eq i32 %buffer.sroa.78.5, 0
  %tmp20.i138 = shl i32 %buffer.sroa.78.5, 1
  %spec.select.i139 = select i1 %tmp14.not.i137, i32 4, i32 %tmp20.i138
  %tmp24.i140 = zext i32 %spec.select.i139 to i64
  %tmp2.i.i141 = tail call ptr @GetProcessHeap()
  %tmp4.i.i142 = tail call ptr @HeapAlloc(ptr %tmp2.i.i141, i32 0, i64 %tmp24.i140)
  %tmp38.not4.not.i147 = icmp eq i32 %buffer.sroa.39.1, 0
  br i1 %tmp38.not4.not.i147, label %loop_body9_exit.i159, label %iter.check337

iter.check337:                                    ; preds = %loop_body9.preheader.i145
  %tmp4.i.i142331 = ptrtoint ptr %tmp4.i.i142 to i64
  %26 = zext i32 %buffer.sroa.39.1 to i64
  %min.iters.check335 = icmp ult i32 %buffer.sroa.39.1, 8
  %27 = sub i64 %tmp4.i.i142331, %buffer.sroa.0.5332
  %diff.check333 = icmp ult i64 %27, 32
  %or.cond399 = select i1 %min.iters.check335, i1 true, i1 %diff.check333
  br i1 %or.cond399, label %end_if10.i148.preheader, label %vector.main.loop.iter.check339

vector.main.loop.iter.check339:                   ; preds = %iter.check337
  %min.iters.check338 = icmp ult i32 %buffer.sroa.39.1, 32
  br i1 %min.iters.check338, label %vec.epilog.ph352, label %vector.ph340

vector.ph340:                                     ; preds = %vector.main.loop.iter.check339
  %n.vec342 = and i64 %26, 4294967264
  br label %vector.body344

vector.body344:                                   ; preds = %vector.body344, %vector.ph340
  %index345 = phi i64 [ 0, %vector.ph340 ], [ %index.next348, %vector.body344 ]
  %28 = getelementptr i8, ptr %tmp4.i.i142, i64 %index345
  %29 = getelementptr i8, ptr %buffer.sroa.0.5, i64 %index345
  %30 = getelementptr i8, ptr %29, i64 16
  %wide.load346 = load <16 x i8>, ptr %29, align 1
  %wide.load347 = load <16 x i8>, ptr %30, align 1
  %31 = getelementptr i8, ptr %28, i64 16
  store <16 x i8> %wide.load346, ptr %28, align 1
  store <16 x i8> %wide.load347, ptr %31, align 1
  %index.next348 = add nuw i64 %index345, 32
  %32 = icmp eq i64 %index.next348, %n.vec342
  br i1 %32, label %middle.block334, label %vector.body344, !llvm.loop !8

middle.block334:                                  ; preds = %vector.body344
  %cmp.n343 = icmp eq i64 %n.vec342, %26
  br i1 %cmp.n343, label %loop_body9_exit.i159, label %vec.epilog.iter.check351

vec.epilog.iter.check351:                         ; preds = %middle.block334
  %n.vec.remaining353 = and i64 %26, 24
  %min.epilog.iters.check354 = icmp eq i64 %n.vec.remaining353, 0
  br i1 %min.epilog.iters.check354, label %end_if10.i148.preheader, label %vec.epilog.ph352

vec.epilog.ph352:                                 ; preds = %vector.main.loop.iter.check339, %vec.epilog.iter.check351
  %vec.epilog.resume.val355 = phi i64 [ %n.vec342, %vec.epilog.iter.check351 ], [ 0, %vector.main.loop.iter.check339 ]
  %n.vec357 = and i64 %26, 4294967288
  br label %vec.epilog.vector.body360

vec.epilog.vector.body360:                        ; preds = %vec.epilog.vector.body360, %vec.epilog.ph352
  %index361 = phi i64 [ %vec.epilog.resume.val355, %vec.epilog.ph352 ], [ %index.next363, %vec.epilog.vector.body360 ]
  %33 = getelementptr i8, ptr %tmp4.i.i142, i64 %index361
  %34 = getelementptr i8, ptr %buffer.sroa.0.5, i64 %index361
  %wide.load362 = load <8 x i8>, ptr %34, align 1
  store <8 x i8> %wide.load362, ptr %33, align 1
  %index.next363 = add nuw i64 %index361, 8
  %35 = icmp eq i64 %index.next363, %n.vec357
  br i1 %35, label %vec.epilog.middle.block349, label %vec.epilog.vector.body360, !llvm.loop !9

vec.epilog.middle.block349:                       ; preds = %vec.epilog.vector.body360
  %cmp.n359 = icmp eq i64 %n.vec357, %26
  br i1 %cmp.n359, label %loop_body9_exit.i159, label %end_if10.i148.preheader

end_if10.i148.preheader:                          ; preds = %iter.check337, %vec.epilog.iter.check351, %vec.epilog.middle.block349
  %indvars.iv.i149.ph = phi i64 [ 0, %iter.check337 ], [ %n.vec342, %vec.epilog.iter.check351 ], [ %n.vec357, %vec.epilog.middle.block349 ]
  br label %end_if10.i148

end_if10.i148:                                    ; preds = %end_if10.i148.preheader, %end_if10.i148
  %indvars.iv.i149 = phi i64 [ %indvars.iv.next.i154, %end_if10.i148 ], [ %indvars.iv.i149.ph, %end_if10.i148.preheader ]
  %tmp42.i150 = getelementptr i8, ptr %tmp4.i.i142, i64 %indvars.iv.i149
  %tmp49.i152 = getelementptr i8, ptr %buffer.sroa.0.5, i64 %indvars.iv.i149
  %tmp50.i153 = load i8, ptr %tmp49.i152, align 1
  store i8 %tmp50.i153, ptr %tmp42.i150, align 1
  %indvars.iv.next.i154 = add nuw nsw i64 %indvars.iv.i149, 1
  %exitcond281.not = icmp eq i64 %indvars.iv.next.i154, %26
  br i1 %exitcond281.not, label %loop_body9_exit.i159, label %end_if10.i148, !llvm.loop !10

loop_body9_exit.i159:                             ; preds = %end_if10.i148, %middle.block334, %vec.epilog.middle.block349, %loop_body9.preheader.i145
  %tmp2.i1.i161 = tail call ptr @GetProcessHeap()
  %36 = tail call i32 @HeapFree(ptr %tmp2.i1.i161, i32 0, ptr nonnull %buffer.sroa.0.5)
  br label %push.exit172

push.exit172:                                     ; preds = %loop_body9_exit.i159, %loop_body17_exit
  %buffer.sroa.0.6 = phi ptr [ %buffer.sroa.0.5, %loop_body17_exit ], [ %tmp4.i.i142, %loop_body9_exit.i159 ]
  %buffer.sroa.78.6 = phi i32 [ %buffer.sroa.78.5, %loop_body17_exit ], [ %spec.select.i139, %loop_body9_exit.i159 ]
  %buffer.sroa.0.6366 = ptrtoint ptr %buffer.sroa.0.6 to i64
  %tmp75.i166 = zext i32 %buffer.sroa.39.1 to i64
  %tmp76.i167 = getelementptr i8, ptr %buffer.sroa.0.6, i64 %tmp75.i166
  store i8 10, ptr %tmp76.i167, align 1
  %tmp85.i169 = add i32 %buffer.sroa.39.1, 1
  %tmp8.not.i177 = icmp ult i32 %tmp85.i169, %buffer.sroa.78.6
  br i1 %tmp8.not.i177, label %push.exit214, label %loop_body9.preheader.i187

loop_body9.preheader.i187:                        ; preds = %push.exit172
  %tmp14.not.i179 = icmp eq i32 %buffer.sroa.78.6, 0
  %tmp20.i180 = shl i32 %buffer.sroa.78.6, 1
  %spec.select.i181 = select i1 %tmp14.not.i179, i32 4, i32 %tmp20.i180
  %tmp24.i182 = zext i32 %spec.select.i181 to i64
  %tmp2.i.i183 = tail call ptr @GetProcessHeap()
  %tmp4.i.i184 = tail call ptr @HeapAlloc(ptr %tmp2.i.i183, i32 0, i64 %tmp24.i182)
  %tmp38.not4.not.i189 = icmp eq i32 %tmp85.i169, 0
  br i1 %tmp38.not4.not.i189, label %loop_body9_exit.i201, label %iter.check371

iter.check371:                                    ; preds = %loop_body9.preheader.i187
  %tmp4.i.i184365 = ptrtoint ptr %tmp4.i.i184 to i64
  %37 = zext i32 %tmp85.i169 to i64
  %min.iters.check369 = icmp ult i32 %tmp85.i169, 8
  %38 = sub i64 %tmp4.i.i184365, %buffer.sroa.0.6366
  %diff.check367 = icmp ult i64 %38, 32
  %or.cond400 = select i1 %min.iters.check369, i1 true, i1 %diff.check367
  br i1 %or.cond400, label %end_if10.i190.preheader, label %vector.main.loop.iter.check373

vector.main.loop.iter.check373:                   ; preds = %iter.check371
  %min.iters.check372 = icmp ult i32 %tmp85.i169, 32
  br i1 %min.iters.check372, label %vec.epilog.ph386, label %vector.ph374

vector.ph374:                                     ; preds = %vector.main.loop.iter.check373
  %n.vec376 = and i64 %37, 4294967264
  br label %vector.body378

vector.body378:                                   ; preds = %vector.body378, %vector.ph374
  %index379 = phi i64 [ 0, %vector.ph374 ], [ %index.next382, %vector.body378 ]
  %39 = getelementptr i8, ptr %tmp4.i.i184, i64 %index379
  %40 = getelementptr i8, ptr %buffer.sroa.0.6, i64 %index379
  %41 = getelementptr i8, ptr %40, i64 16
  %wide.load380 = load <16 x i8>, ptr %40, align 1
  %wide.load381 = load <16 x i8>, ptr %41, align 1
  %42 = getelementptr i8, ptr %39, i64 16
  store <16 x i8> %wide.load380, ptr %39, align 1
  store <16 x i8> %wide.load381, ptr %42, align 1
  %index.next382 = add nuw i64 %index379, 32
  %43 = icmp eq i64 %index.next382, %n.vec376
  br i1 %43, label %middle.block368, label %vector.body378, !llvm.loop !11

middle.block368:                                  ; preds = %vector.body378
  %cmp.n377 = icmp eq i64 %n.vec376, %37
  br i1 %cmp.n377, label %loop_body9_exit.i201, label %vec.epilog.iter.check385

vec.epilog.iter.check385:                         ; preds = %middle.block368
  %n.vec.remaining387 = and i64 %37, 24
  %min.epilog.iters.check388 = icmp eq i64 %n.vec.remaining387, 0
  br i1 %min.epilog.iters.check388, label %end_if10.i190.preheader, label %vec.epilog.ph386

vec.epilog.ph386:                                 ; preds = %vector.main.loop.iter.check373, %vec.epilog.iter.check385
  %vec.epilog.resume.val389 = phi i64 [ %n.vec376, %vec.epilog.iter.check385 ], [ 0, %vector.main.loop.iter.check373 ]
  %n.vec391 = and i64 %37, 4294967288
  br label %vec.epilog.vector.body394

vec.epilog.vector.body394:                        ; preds = %vec.epilog.vector.body394, %vec.epilog.ph386
  %index395 = phi i64 [ %vec.epilog.resume.val389, %vec.epilog.ph386 ], [ %index.next397, %vec.epilog.vector.body394 ]
  %44 = getelementptr i8, ptr %tmp4.i.i184, i64 %index395
  %45 = getelementptr i8, ptr %buffer.sroa.0.6, i64 %index395
  %wide.load396 = load <8 x i8>, ptr %45, align 1
  store <8 x i8> %wide.load396, ptr %44, align 1
  %index.next397 = add nuw i64 %index395, 8
  %46 = icmp eq i64 %index.next397, %n.vec391
  br i1 %46, label %vec.epilog.middle.block383, label %vec.epilog.vector.body394, !llvm.loop !12

vec.epilog.middle.block383:                       ; preds = %vec.epilog.vector.body394
  %cmp.n393 = icmp eq i64 %n.vec391, %37
  br i1 %cmp.n393, label %loop_body9_exit.i201, label %end_if10.i190.preheader

end_if10.i190.preheader:                          ; preds = %iter.check371, %vec.epilog.iter.check385, %vec.epilog.middle.block383
  %indvars.iv.i191.ph = phi i64 [ 0, %iter.check371 ], [ %n.vec376, %vec.epilog.iter.check385 ], [ %n.vec391, %vec.epilog.middle.block383 ]
  br label %end_if10.i190

end_if10.i190:                                    ; preds = %end_if10.i190.preheader, %end_if10.i190
  %indvars.iv.i191 = phi i64 [ %indvars.iv.next.i196, %end_if10.i190 ], [ %indvars.iv.i191.ph, %end_if10.i190.preheader ]
  %tmp42.i192 = getelementptr i8, ptr %tmp4.i.i184, i64 %indvars.iv.i191
  %tmp49.i194 = getelementptr i8, ptr %buffer.sroa.0.6, i64 %indvars.iv.i191
  %tmp50.i195 = load i8, ptr %tmp49.i194, align 1
  store i8 %tmp50.i195, ptr %tmp42.i192, align 1
  %indvars.iv.next.i196 = add nuw nsw i64 %indvars.iv.i191, 1
  %exitcond282.not = icmp eq i64 %indvars.iv.next.i196, %37
  br i1 %exitcond282.not, label %loop_body9_exit.i201, label %end_if10.i190, !llvm.loop !13

loop_body9_exit.i201:                             ; preds = %end_if10.i190, %middle.block368, %vec.epilog.middle.block383, %loop_body9.preheader.i187
  %tmp2.i1.i203 = tail call ptr @GetProcessHeap()
  %47 = tail call i32 @HeapFree(ptr %tmp2.i1.i203, i32 0, ptr nonnull %buffer.sroa.0.6)
  br label %push.exit214

push.exit214:                                     ; preds = %loop_body9_exit.i201, %push.exit172
  %buffer.sroa.0.7 = phi ptr [ %buffer.sroa.0.6, %push.exit172 ], [ %tmp4.i.i184, %loop_body9_exit.i201 ]
  %tmp75.i208 = zext i32 %tmp85.i169 to i64
  %tmp76.i209 = getelementptr i8, ptr %buffer.sroa.0.7, i64 %tmp75.i208
  store i8 0, ptr %tmp76.i209, align 1
  %tmp85.i211 = add i32 %buffer.sroa.39.1, 2
  call void @llvm.lifetime.start.p0(i64 4, ptr nonnull %chars_written.i215)
  %tmp2.i.i216 = tail call ptr @GetStdHandle(i32 -11)
  %tmp5.i.i217 = icmp eq ptr %tmp2.i.i216, inttoptr (i64 -1 to ptr)
  br i1 %tmp5.i.i217, label %then0.i.i218, label %then11.i222

then0.i.i218:                                     ; preds = %push.exit214
  tail call void @ExitProcess(i32 -1)
  br label %then11.i222

then11.i222:                                      ; preds = %then0.i.i218, %push.exit214
  %48 = call i32 @WriteConsoleA(ptr %tmp2.i.i216, ptr nonnull %buffer.sroa.0.7, i32 %tmp85.i211, ptr nonnull %chars_written.i215, ptr null)
  call void @llvm.lifetime.end.p0(i64 4, ptr nonnull %chars_written.i215)
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
!11 = distinct !{!11, !1, !2}
!12 = distinct !{!12, !1, !2}
!13 = distinct !{!13, !1}
