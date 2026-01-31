target triple = "x86_64-pc-windows-msvc"
;./src.rcsharp
%struct.mem.PROCESS_HEAP_ENTRY = type { i8*, i32, i8, i8, i16, i8*, i32, i32, i32 }
%struct.string.String = type { i8*, i32 }
%struct.window.POINT = type { i32, i32 }
%struct.window.MSG = type { i8*, i32, i64, i64, i32, %struct.window.POINT }
%struct.window.WNDCLASSEXA = type { i32, i32, i64 (i8*, i32, i64, i64)*, i32, i32, i8*, i8*, i8*, i8*, i8*, i8*, i8* }
%struct.window.RECT = type { i32, i32, i32, i32 }
%struct.window.PAINTSTRUCT = type { i8*, i32, %struct.window.RECT, i32, i32, i8* }
%struct.window.BITMAP = type { i32, i32, i32, i32, i16, i16, i8* }
%"struct.Pair<i8, %struct.string.String>" = type { i8, %struct.string.String }
%"struct.test.QPair<i64, i64>" = type { i64, i64 }
%"struct.Pair<i64, %struct.Pair<i8, %struct.string.String>>" = type { i64, %"struct.Pair<i8, %struct.string.String>" }
%"struct.Pair<%struct.Pair<i64, %struct.Pair<i8, %struct.string.String>>, %struct.string.String>" = type { %"struct.Pair<i64, %struct.Pair<i8, %struct.string.String>>", %struct.string.String }
%"struct.Pair<i64, %struct.Pair<%struct.Pair<i64, %struct.Pair<i8, %struct.string.String>>, %struct.string.String>>" = type { i64, %"struct.Pair<%struct.Pair<i64, %struct.Pair<i8, %struct.string.String>>, %struct.string.String>" }
%"struct.Pair<i8, %struct.Pair<i64, %struct.Pair<%struct.Pair<i64, %struct.Pair<i8, %struct.string.String>>, %struct.string.String>>>" = type { i8, %"struct.Pair<i64, %struct.Pair<%struct.Pair<i64, %struct.Pair<i8, %struct.string.String>>, %struct.string.String>>" }
%"struct.Pair<i64, %struct.Pair<i8, %struct.Pair<i64, %struct.Pair<%struct.Pair<i64, %struct.Pair<i8, %struct.string.String>>, %struct.string.String>>>>" = type { i64, %"struct.Pair<i8, %struct.Pair<i64, %struct.Pair<%struct.Pair<i64, %struct.Pair<i8, %struct.string.String>>, %struct.string.String>>>" }
%"struct.Pair<i8, %struct.Pair<i64, %struct.Pair<i8, %struct.Pair<i64, %struct.Pair<%struct.Pair<i64, %struct.Pair<i8, %struct.string.String>>, %struct.string.String>>>>>" = type { i8, %"struct.Pair<i64, %struct.Pair<i8, %struct.Pair<i64, %struct.Pair<%struct.Pair<i64, %struct.Pair<i8, %struct.string.String>>, %struct.string.String>>>>" }
%"struct.Pair<i64, %struct.Pair<i8, %struct.Pair<i64, %struct.Pair<i8, %struct.Pair<i64, %struct.Pair<%struct.Pair<i64, %struct.Pair<i8, %struct.string.String>>, %struct.string.String>>>>>>" = type { i64, %"struct.Pair<i8, %struct.Pair<i64, %struct.Pair<i8, %struct.Pair<i64, %struct.Pair<%struct.Pair<i64, %struct.Pair<i8, %struct.string.String>>, %struct.string.String>>>>>" }
%"struct.Pair<i8, %struct.Pair<i64, %struct.Pair<i8, %struct.Pair<i64, %struct.Pair<i8, %struct.Pair<i64, %struct.Pair<%struct.Pair<i64, %struct.Pair<i8, %struct.string.String>>, %struct.string.String>>>>>>>" = type { i8, %"struct.Pair<i64, %struct.Pair<i8, %struct.Pair<i64, %struct.Pair<i8, %struct.Pair<i64, %struct.Pair<%struct.Pair<i64, %struct.Pair<i8, %struct.string.String>>, %struct.string.String>>>>>>" }
%"struct.Pair<i64, %struct.Pair<i8, %struct.Pair<i64, %struct.Pair<i8, %struct.Pair<i64, %struct.Pair<i8, %struct.Pair<i64, %struct.Pair<%struct.Pair<i64, %struct.Pair<i8, %struct.string.String>>, %struct.string.String>>>>>>>>" = type { i64, %"struct.Pair<i8, %struct.Pair<i64, %struct.Pair<i8, %struct.Pair<i64, %struct.Pair<i8, %struct.Pair<i64, %struct.Pair<%struct.Pair<i64, %struct.Pair<i8, %struct.string.String>>, %struct.string.String>>>>>>>" }



@yt = internal global [43 x i32] zeroinitializer
define i32 @main(){
    ret i32 104
}
define i32 @_fltused(){
    ret i32 0
}
define void @__chkstk(){
    call void asm sideeffect inteldialect "push rcx
         push rax
         cmp rax, 4096
         jb .end
         
         lea r10, [rsp + 24]
         
         .probe_loop:
         sub r10, 4096
         test [r10], r10
         sub rax, 4096
         cmp rax, 4096
         ja .probe_loop
         
         .end:
         pop rax
         pop rcx", "~{flags}"()
    ret void
}

;fn __chkstk used times 1
;fn _fltused used times 1
;fn process.ExitProcess used times 0
;fn process.GetModuleFileNameA used times 0
;fn process.get_executable_path used times 0
;fn process.get_executable_env_path used times 0
;fn process.throw used times 0
;fn mem.GetProcessHeap used times 0
;fn mem.HeapAlloc used times 0
;fn mem.HeapReAlloc used times 0
;fn mem.HeapFree used times 0
;fn mem.HeapSize used times 0
;fn mem.HeapWalk used times 0
;fn mem.HeapLock used times 0
;fn mem.HeapUnlock used times 0
;fn mem.malloc used times 0
;fn mem.realloc used times 0
;fn mem.free used times 0
;fn mem.copy used times 0
;fn mem.compare used times 0
;fn mem.fill used times 0
;fn mem.zero_fill used times 0
;fn mem.default_fill used times 0
;fn mem.get_total_allocated_memory_external used times 0
;fn list.new used times 0
;fn list.new_node used times 0
;fn list.extend used times 0
;fn list.walk used times 0
;fn list.free used times 0
;fn vector.new used times 0
;fn vector.push used times 0
;fn vector.push_bulk used times 0
;fn vector.remove_at used times 0
;fn vector.free used times 0
;fn console.AllocConsole used times 0
;fn console.GetStdHandle used times 0
;fn console.FreeConsole used times 0
;fn console.WriteConsoleA used times 0
;fn console.get_stdout used times 0
;fn console.write used times 0
;fn console.write_string used times 0
;fn console.writeln used times 0
;fn console.print_char used times 0
;fn console.println_i64 used times 0
;fn console.println_u64 used times 0
;fn console.println_f64 used times 0
;fn string.from_c_string used times 0
;fn string.empty used times 0
;fn string.with_size used times 0
;fn string.clone used times 0
;fn string.concat_with_c_string used times 0
;fn string.equal used times 0
;fn string.free used times 0
;fn string.as_c_string_stalloc used times 0
;fn string_utils.insert used times 0
;fn string_utils.c_str_len used times 0
;fn string_utils.is_ascii_num used times 0
;fn string_utils.is_ascii_char used times 0
;fn string_utils.is_ascii_hex used times 0
;fn fs.CreateFileA used times 0
;fn fs.WriteFile used times 0
;fn fs.ReadFile used times 0
;fn fs.GetFileSizeEx used times 0
;fn fs.CloseHandle used times 0
;fn fs.DeleteFileA used times 0
;fn fs.GetFileAttributesA used times 0
;fn fs.write_to_file used times 0
;fn fs.read_full_file_as_string used times 0
;fn fs.create_file used times 0
;fn fs.delete_file used times 0
;fn fs.file_exists used times 0
;fn tests.run used times 0
;fn tests.mem_test used times 0
;fn tests.string_utils_test used times 0
;fn tests.string_test used times 0
;fn tests.vector_test used times 0
;fn tests.list_test used times 0
;fn tests.process_test used times 0
;fn tests.console_test used times 0
;fn tests.fs_test used times 0
;fn tests.consume_while used times 0
;fn tests.not_new_line used times 0
;fn tests.valid_name_token used times 0
;fn tests.is_valid_number_token used times 0
;fn tests.funny used times 0
;fn window.RegisterClassA used times 0
;fn window.CreateWindowExA used times 0
;fn window.DefWindowProcA used times 0
;fn window.GetMessageA used times 0
;fn window.TranslateMessage used times 0
;fn window.DispatchMessageA used times 0
;fn window.PostQuitMessage used times 0
;fn window.BeginPaint used times 0
;fn window.EndPaint used times 0
;fn window.GetDC used times 0
;fn window.ReleaseDC used times 0
;fn window.LoadCursorA used times 0
;fn window.LoadIconA used times 0
;fn window.LoadImageA used times 0
;fn window.GetClientRect used times 0
;fn window.InvalidateRect used times 0
;fn window.GetModuleHandleA used times 0
;fn window.RegisterClassExA used times 0
;fn window.ShowWindow used times 0
;fn window.CreateCompatibleDC used times 0
;fn window.SelectObject used times 0
;fn window.BitBlt used times 0
;fn window.DeleteDC used times 0
;fn window.DeleteObject used times 0
;fn window.GetObjectA used times 0
;fn window.SetStretchBltMode used times 0
;fn window.StretchBlt used times 0
;fn window.SetWindowLongPtrA used times 0
;fn window.GetWindowLongPtrA used times 0
;fn window.WindowProc used times 0
;fn window.load_bitmap_from_file used times 0
;fn window.get_bitmap_dimensions used times 0
;fn window.draw_bitmap used times 0
;fn window.draw_bitmap_stretched used times 0
;fn window.is_null used times 0
;fn window.start used times 0
;fn window.start_image_window used times 0
;fn basic_functions used times 0
;fn ax used times 0
;fn of_fn used times 0
;fn test.geg used times 0
;fn xq used times 0
;fn main used times 0
