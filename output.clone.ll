@.str = private unnamed_addr constant [13 x i8] c"Hello World!\00", align 1
@.str1 = private unnamed_addr constant [6 x i8] c"Title\00", align 1

; Declare with the correct calling convention (stdcall)
declare dllimport i32 @MessageBoxA(
    i8* nocapture readonly, 
    i8* nocapture readonly, 
    i8* nocapture readonly, 
    i32
) local_unnamed_addr #1

define i32 @main() local_unnamed_addr #0 {
entry:
  %call = call i32 @MessageBoxA(
      i8* null, 
      i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str, i32 0, i32 0), 
      i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str1, i32 0, i32 0), 
      i32 0
  )
  ret i32 %call
}

attributes #0 = { "target-cpu"="x86-64" }
attributes #1 = { "dllimport" }