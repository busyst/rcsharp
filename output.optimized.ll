; ModuleID = '.\output.ll'
source_filename = ".\\output.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare dllimport ptr @GetProcessHeap() local_unnamed_addr

declare dllimport ptr @HeapAlloc(ptr, i32, i64) local_unnamed_addr

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none)
define void @__chkstk() local_unnamed_addr #0 {
  ret void
}

define ptr @malloc(i64 %size) local_unnamed_addr {
  %tmp2 = tail call ptr @GetProcessHeap()
  %tmp5 = tail call ptr @HeapAlloc(ptr %tmp2, i32 0, i64 %size)
  ret ptr %tmp5
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write)
define void @new(ptr nocapture writeonly %node) local_unnamed_addr #1 {
  tail call void @llvm.memset.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %node, i8 0, i64 16, i1 false)
  ret void
}

; Function Attrs: nofree norecurse nosync nounwind memory(read, inaccessiblemem: none)
define i32 @len(ptr nocapture readonly %node) local_unnamed_addr #2 {
  br label %loop_body0

loop_body0:                                       ; preds = %loop_body0, %0
  %len.0 = phi i32 [ 1, %0 ], [ %tmp17, %loop_body0 ]
  %current_node.0 = phi ptr [ %node, %0 ], [ %tmp8, %loop_body0 ]
  %tmp8 = load ptr, ptr %current_node.0, align 8
  %tmp13 = icmp eq ptr %tmp8, null
  %tmp17 = add i32 %len.0, 1
  br i1 %tmp13, label %loop_body0_exit, label %loop_body0

loop_body0_exit:                                  ; preds = %loop_body0
  ret i32 %len.0
}

; Function Attrs: nofree norecurse nosync nounwind memory(read, inaccessiblemem: none)
define i32 @main() local_unnamed_addr #2 {
  %list_end.sroa.0 = alloca ptr, align 8
  store ptr null, ptr %list_end.sroa.0, align 8
  br label %loop_body0.ithread-pre-splitthread-pre-split

loop_body0.ithread-pre-splitthread-pre-split:     ; preds = %0, %loop_body0.ithread-pre-splitthread-pre-split
  %tmp17.i4 = phi i32 [ 2, %0 ], [ %tmp17.i, %loop_body0.ithread-pre-splitthread-pre-split ]
  %tmp8.i.pr3 = phi ptr [ %list_end.sroa.0, %0 ], [ %tmp8.i.pr.pr, %loop_body0.ithread-pre-splitthread-pre-split ]
  %tmp8.i.pr.pr = load ptr, ptr %tmp8.i.pr3, align 8
  %tmp17.i = add i32 %tmp17.i4, 1
  %tmp13.i = icmp eq ptr %tmp8.i.pr.pr, null
  br i1 %tmp13.i, label %len.exit, label %loop_body0.ithread-pre-splitthread-pre-split

len.exit:                                         ; preds = %loop_body0.ithread-pre-splitthread-pre-split
  ret i32 %tmp17.i
}

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #3

attributes #0 = { mustprogress nofree norecurse nosync nounwind willreturn memory(none) }
attributes #1 = { mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write) }
attributes #2 = { nofree norecurse nosync nounwind memory(read, inaccessiblemem: none) }
attributes #3 = { nocallback nofree nounwind willreturn memory(argmem: write) }
