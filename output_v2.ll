define void @main()
;enum SymbolTableTag: i32{ Function: 1337, GenericFunction: 1337, Struct: 1337, GenericStruct: 1337, Enum: 1337, Static: 1337, Constant: 1337, OnlyTypesMask: 1337, Solved: 1337 }
;struct SymbolTableEntry{ tag: i32, path: i32, val: &void }
;struct EnumDefinedField{ name: i32, value: i64 }
;struct EnumSymbolTableEntry{ representative_type: i32, fields: i32 }
;struct StructDefinedField{ name: i32, type: i32 }
;struct StructSymbolTableEntry{ fields: i32, size_of: i16 }
;struct FunctionSymbolTableEntry{ arguments: i32, return_type: i32, body: i32 }
;struct GenericFunctionSymbolTableEntry{ arguments: i32, return_type: i32, body: i32, generic_tokens: i32, implementations: i32 }
;struct GenericStructDefinedField{ name: i32, type: i32, is_generic: i1 }
;struct GenericStructSymbolTableEntry{ fields: i32, generic_tokens: i32, implementations: i32 }
;struct ConstantSymbolTableEntry{ type: i32, defined_value: i32 }
;struct StaticSymbolTableEntry{ type: i32, has_initialized_value: i1, initialized_value: i32 }
;struct SymbolTable{ symbols: i32, symbol_vector: &i32 }
define void @insert_symbol_into_table(table: &i32, entry: i32)
define &i32 @get_symbol_from_table(table: &i32, path: i32)
;struct Variable{ name: i16 }
;struct Scope{ values: i32, scope_index: i32 }
define i32 @new_scope()
define void @add_to_scope(val: i32, scope: &i32)
define void @enter_scope(scope: &i32)
define void @exit_scope(scope: &i32)
define &i32 @find_variable(name: i16, scope: &i32)
define void @rcsharp_compile(input_file_path: &i8, output_file_path: &i8)
define void @debug_dump_type(expr: &i32, symbol_vector: &i32, stdout: &i32)
define void @debug_dump_expression(expr: &i32, symbol_vector: &i32, stdout: &i32)
define void @compile_body(statement_vector: &i32, body_path: &i32, symbol_vector: &i32, stdout: &i32)
define void @compile_internal_sym_table_prefill(path: i32, statement_vector: &i32, symbol_table: &i32, stdout: &i32)
define void @compile_internal(path: i32, statement_vector: &i32, symbol_table: &i32, stdout: &i32)
define i32 @constant_evaluate_expression(expr: &i32, table: &i32)
define void @compile(statement_vector: &i32, symbol_vector: &i32, stdout: &i32)
define void @debug_dump_path_ex(path: &i32, sym_array: &i32, stdout: &i32)
define void @debug_dump_path(path: &i32, sym_array: &i32, stdout: &i32)
define void @debug_dump_symbol_table(table: &i32, stdout: &i32)
define i32 @get_compiler_type(type: &i32, table: &i32)
define void @compiler_type_push(type: &i32, path: &i32, symbol_table: &i32, stdout: &i32)
;enum CompilerTypeKind: i32{ Primitive: 0, Pointer: 1 }
;struct PointerCompilerType{ deep: i8, inner: i32 }
;struct CompilerType{ kind: i32, data: &void }
;enum RvalueKind: i32{ Register: 0, Integer: 1, Decimal: 2, Boolean: 3, Null: 4, Void: 5 }
;struct Rvalue{ kind: i32, data: &void }
;struct Layout{ size: i32, align: i32 }
define i32 @invalid_layout()
define i32 @zero_layout()
define i32 @one_layout()
define i32 @two_layout()
define i32 @four_layout()
define i32 @eight_layout()
;enum PrimitiveKind: i32{ Void: 0, Bool: 1, SignedInt: 2, UnsignedInt: 3, Decimal: 4 }
;struct PrimitiveTypeInfo{ name: &i8, llvm_signature: &i8, layout: i32, kind: i32 }
@POINTER_LAYOUT = internal global i32
@VOID_TYPE = internal global &i32
@DEFAULT_INTEGER_TYPE = internal global &i32
@PRIMITIVE_TYPES_INFO = internal global i32
define void @STATIC_FILL_PRIMITIVE_TYPES_INFO()
define i32 @find_primitive_type(name: &i8, len: i32)
define void @__chkstk()
define i32 @_fltused()
define void @process.ExitProcess(code: i32)
define i16 @process.GetModuleFileNameA(hModule: &i8, lpFilename: &i8, nSize: i16)
define i32 @process.get_executable_path()
define i32 @process.get_executable_env_path()
define void @process.throw(exception: &i8)
;struct mem.PROCESS_HEAP_ENTRY{ lpData: &void, cbData: i16, cbOverhead: i8, iRegionIndex: i8, wFlags: i32, Block_hMem: &void, Block_dwReserved0: i16, Block_dwReserved1: i16, Block_dwReserved2: i16 }
define &i32 @mem.GetProcessHeap()
define &void @mem.HeapAlloc(hHeap: &i32, dwFlags: i32, dwBytes: i64)
define &void @mem.HeapReAlloc(hHeap: &i32, dwFlags: i32, lpMem: &void, dwBytes: i64)
define i32 @mem.HeapFree(hHeap: &i32, dwFlags: i32, lpMem: &void)
define i64 @mem.HeapSize(hHeap: &i32, dwFlags: i32, lpMem: &i8)
define i32 @mem.HeapWalk(hHeap: &i32, lpEntry: &i32)
define i32 @mem.HeapLock(hHeap: &i32)
define i32 @mem.HeapUnlock(hHeap: &i32)
define &void @mem.malloc(size: i64)
define &void @mem.realloc(ptr: &void, size: i64)
define void @mem.free(ptr: &void)
define void @mem.copy(src: &i8, dest: &i8, len: i64)
define i32 @mem.compare(left: &i8, right: &i8, len: i64)
define void @mem.fill(val: i8, dest: &i8, len: i64)
define void @mem.zero_fill(dest: &i8, len: i64)
define i64 @mem.get_total_allocated_memory_external()
;struct list.List{ head: &i32, foot: &i32, length: i16 }
;struct list.ListNode{ data: i32, next_node: &i32 }
;struct vector.Vec{ array: &i32, length: i16, capacity: i16 }
;constant console.STD_OUTPUT_HANDLE = i32
define i32 @console.AllocConsole()
define &i8 @console.GetStdHandle(nStdHandle: i32)
define i32 @console.FreeConsole()
define i32 @console.WriteConsoleA(hConsoleOutput: &i8, lpBuffer: &i8, nNumberOfCharsToWrite: i32, lpNumberOfCharsWritten: &i32, lpReserved: &i8)
define &i8 @console.get_stdout()
define void @console.write(buffer: &i8, len: i32)
define void @console.write_string(str: &i32)
define void @console.writeln(buffer: &i8, len: i32)
define void @console.print_char(n: i8)
define void @console.println_i64(n: i64)
define void @console.println_u64(n: i64)
define void @console.println_f64(n: double)
;struct string.String{ data: &i8, len: i32, capacity: i32 }
define i32 @string.from_data(data: &i8, len: i32)
define i32 @string.from_c_string(c_string: &i8)
define i32 @string.empty()
define i32 @string.with_size(size: i32)
define i32 @string.clone(src: &i32)
define void @string.reserve(str: &i32, required_capacity: i32)
define i32 @string.append_c_string(src_string: &i32, c_string: &i8)
define void @string.append_str(src_string: &i32, buffer: &i8, buffer_len: i32)
define void @string.append(src_string: &i32, ch: i8)
define i1 @string.equal(first: &i32, second: &i32)
define void @string.free(str: &i32)
define void @string.as_c_string_stalloc(string: &i32, stallocd_buffer: &i8)
define i1 @char_utils.is_alnum(c: i8)
define i1 @char_utils.is_alpha(c: i8)
define i1 @char_utils.is_cntrl(c: i8)
define i1 @char_utils.is_digit(c: i8)
define i1 @char_utils.is_graph(c: i8)
define i1 @char_utils.is_lower(c: i8)
define i1 @char_utils.is_print(c: i8)
define i1 @char_utils.is_punct(c: i8)
define i1 @char_utils.is_space(c: i8)
define i1 @char_utils.is_upper(c: i8)
define i1 @char_utils.is_xdigit(c: i8)
define i8 @char_utils.to_lower(c: i8)
define i8 @char_utils.to_upper(c: i8)
define &i8 @string_utils.c_str_copy(dest: &i8, src: &i8)
define &i8 @string_utils.c_str_n_copy(dest: &i8, src: &i8, n: i32)
define &i8 @string_utils.insert(src1: &i8, src2: &i8, index: i32)
define i32 @string_utils.c_str_len(str: &i8)
define i32 @string_utils.u64_to_string(n: i64)
define i32 @stdlib.atoi(str: &i8)
define i64 @stdlib.str_to_l(str: &i8, endptr: &&i8, base: i32)
@stdlib.rand_seed = internal global i16
define void @stdlib.srand(seed: i16)
define i32 @stdlib.rand()
define &void @fs.CreateFileA(lpFileName: &i8, dwDesiredAccess: i16, dwShareMode: i16, lpSecurityAttributes: &i8, dwCreationDisposition: i16, dwFlagsAndAttributes: i16, hTemplateFile: &i8)
define i32 @fs.WriteFile(hFile: &void, lpBuffer: &i8, nNumberOfBytesToWrite: i16, lpNumberOfBytesWritten: &i16, lpOverlapped: &i8)
define i32 @fs.ReadFile(hFile: &void, lpBuffer: &i8, nNumberOfBytesToRead: i16, lpNumberOfBytesRead: &i16, lpOverlapped: &i8)
define i32 @fs.GetFileSizeEx(hFile: &void, lpFileSize: &i64)
define i32 @fs.CloseHandle(hObject: &void)
define i32 @fs.DeleteFileA(lpFileName: &i8)
define i16 @fs.GetFileAttributesA(lpFileName: &i8)
define i32 @fs.GetFullPathNameA(lpFileName: &i8, nBufferLength: i32, lpBuffer: &i8, lpFilePart: &i8)
define &i8 @fs.PathCombineA(pszDest: &i8, pszDir: &i8, pszFile: &i8)
define i32 @fs.write_to_file(path: &i8, content: &i8, content_len: i16)
define i32 @fs.read_full_file_as_string(path: &i8)
define i32 @fs.create_file(path: &i8)
define i32 @fs.delete_file(path: &i8)
define i1 @fs.file_exists(path: &i8)
define void @tests.run()
define void @tests.mem_test()
define void @tests.string_utils_test()
define void @tests.string_test()
define void @tests.vector_test()
define void @tests.list_test()
define void @tests.process_test()
define void @tests.console_test()
define void @tests.fs_test()
define void @tests.consume_while(file: &i32, iterator: &i32, condition: &i32)
define i1 @tests.not_new_line(c: i8)
define i1 @tests.valid_name_token(c: i8)
define i1 @tests.is_valid_number_token(c: i8)
;enum tests.LexerTokens: i64{ String: 0 }
define void @tests.funny()
;constant window.GWLP_USERDATA = i32
;enum window.WM: i16{ NULL: 1337, CREATE: 1337, DESTROY: 1337, MOVE: 1337, SIZE: 1337, ACTIVATE: 1337, SETFOCUS: 1337, KILLFOCUS: 1337, ENABLE: 1337, SETREDRAW: 1337, SETTEXT: 1337, GETTEXT: 1337, GETTEXTLENGTH: 1337, PAINT: 1337, CLOSE: 1337, QUERYENDSESSION: 1337, QUERYOPEN: 1337, ENDSESSION: 1337, QUIT: 1337, ERASEBKGND: 1337, SYSCOLORCHANGE: 1337, SHOWWINDOW: 1337, WININICHANGE: 1337, SETTINGCHANGE: 1337, DEVMODECHANGE: 1337, ACTIVATEAPP: 1337, FONTCHANGE: 1337, TIMECHANGE: 1337, CANCELMODE: 1337, SETCURSOR: 1337, MOUSEACTIVATE: 1337, CHILDACTIVATE: 1337, QUEUESYNC: 1337, GETMINMAXINFO: 1337, PAINTICON: 1337, ICONERASEBKGND: 1337, NEXTDLGCTL: 1337, SPOOLERSTATUS: 1337, DRAWITEM: 1337, MEASUREITEM: 1337, DELETEITEM: 1337, VKEYTOITEM: 1337, CHARTOITEM: 1337, SETFONT: 1337, GETFONT: 1337, SETHOTKEY: 1337, GETHOTKEY: 1337, QUERYDRAGICON: 1337, COMPAREITEM: 1337, GETOBJECT: 1337, COMPACTING: 1337, COMMNOTIFY: 1337, WINDOWPOSCHANGING: 1337, WINDOWPOSCHANGED: 1337, POWER: 1337, COPYDATA: 1337, CANCELJOURNAL: 1337, NOTIFY: 1337, INPUTLANGCHANGEREQUEST: 1337, INPUTLANGCHANGE: 1337, TCARD: 1337, HELP: 1337, USERCHANGED: 1337, NOTIFYFORMAT: 1337, CONTEXTMENU: 1337, STYLECHANGING: 1337, STYLECHANGED: 1337, DISPLAYCHANGE: 1337, GETICON: 1337, SETICON: 1337, NCCREATE: 1337, NCDESTROY: 1337, NCCALCSIZE: 1337, NCHITTEST: 1337, NCPAINT: 1337, NCACTIVATE: 1337, GETDLGCODE: 1337, SYNCPAINT: 1337, NCMOUSEMOVE: 1337, NCLBUTTONDOWN: 1337, NCLBUTTONUP: 1337, NCLBUTTONDBLCLK: 1337, NCRBUTTONDOWN: 1337, NCRBUTTONUP: 1337, NCRBUTTONDBLCLK: 1337, NCMBUTTONDOWN: 1337, NCMBUTTONUP: 1337, NCMBUTTONDBLCLK: 1337, NCXBUTTONDOWN: 1337, NCXBUTTONUP: 1337, NCXBUTTONDBLCLK: 1337, INPUT_DEVICE_CHANGE: 1337, INPUT: 1337, KEYFIRST: 1337, KEYDOWN: 1337, KEYUP: 1337, CHAR: 1337, DEADCHAR: 1337, SYSKEYDOWN: 1337, SYSKEYUP: 1337, SYSCHAR: 1337, SYSDEADCHAR: 1337, UNICHAR: 1337, KEYLAST: 1337, INITDIALOG: 1337, COMMAND: 1337, SYSCOMMAND: 1337, TIMER: 1337, HSCROLL: 1337, VSCROLL: 1337, INITMENU: 1337, INITMENUPOPUP: 1337, MENUSELECT: 1337, MENUCHAR: 1337, ENTERIDLE: 1337, MENURBUTTONUP: 1337, MENUDRAG: 1337, MENUGETOBJECT: 1337, UNINITMENUPOPUP: 1337, MENUCOMMAND: 1337, CHANGEUISTATE: 1337, UPDATEUISTATE: 1337, QUERYUISTATE: 1337, CTLCOLORMSGBOX: 1337, CTLCOLOREDIT: 1337, CTLCOLORLISTBOX: 1337, CTLCOLORBTN: 1337, CTLCOLORDLG: 1337, CTLCOLORSCROLLBAR: 1337, CTLCOLORSTATIC: 1337, MOUSEFIRST: 1337, MOUSEMOVE: 1337, LBUTTONDOWN: 1337, LBUTTONUP: 1337, LBUTTONDBLCLK: 1337, RBUTTONDOWN: 1337, RBUTTONUP: 1337, RBUTTONDBLCLK: 1337, MBUTTONDOWN: 1337, MBUTTONUP: 1337, MBUTTONDBLCLK: 1337, MOUSEWHEEL: 1337, XBUTTONDOWN: 1337, XBUTTONUP: 1337, XBUTTONDBLCLK: 1337, MOUSEHWHEEL: 1337, MOUSELAST: 1337, PARENTNOTIFY: 1337, ENTERMENULOOP: 1337, EXITMENULOOP: 1337, NEXTMENU: 1337, SIZING: 1337, CAPTURECHANGED: 1337, MOVING: 1337, POWERBROADCAST: 1337, DEVICECHANGE: 1337, MDICREATE: 1337, MDIDESTROY: 1337, MDIACTIVATE: 1337, MDIRESTORE: 1337, MDINEXT: 1337, MDIMAXIMIZE: 1337, MDITILE: 1337, MDICASCADE: 1337, MDIICONARRANGE: 1337, MDIGETACTIVE: 1337, MDISETMENU: 1337, ENTERSIZEMOVE: 1337, EXITSIZEMOVE: 1337, DROPFILES: 1337, MDIREFRESHMENU: 1337, DPICHANGED: 1337, THEMECHANGED: 1337, CLIPBOARDUPDATE: 1337, USER: 1337, APP: 1337 }
;enum window.CS: i16{ VREDRAW: 1337, HREDRAW: 1337, DBLCLKS: 1337, OWNDC: 1337, CLASSDC: 1337, PARENTDC: 1337, NOCLOSE: 1337, SAVEBITS: 1337, BYTEALIGNCLIENT: 1337, BYTEALIGNWINDOW: 1337, GLOBALCLASS: 1337, IME: 1337, DROPSHADOW: 1337 }
;enum window.WS: i16{ OVERLAPPED: 1337, POPUP: 1337, CHILD: 1337, MINIMIZE: 1337, VISIBLE: 1337, DISABLED: 1337, CLIPSIBLINGS: 1337, CLIPCHILDREN: 1337, MAXIMIZE: 1337, CAPTION: 1337, BORDER: 1337, DLGFRAME: 1337, VSCROLL: 1337, HSCROLL: 1337, SYSMENU: 1337, THICKFRAME: 1337, GROUP: 1337, TABSTOP: 1337, MINIMIZEBOX: 1337, MAXIMIZEBOX: 1337, TILED: 1337, ICONIC: 1337, SIZEBOX: 1337, TILEDWINDOW: 1337, OVERLAPPEDWINDOW: 1337, POPUPWINDOW: 1337, CHILDWINDOW: 1337 }
;enum window.WS_EX: i16{ DLGMODALFRAME: 1337, NOPARENTNOTIFY: 1337, TOPMOST: 1337, ACCEPTFILES: 1337, TRANSPARENT: 1337, MDICHILD: 1337, TOOLWINDOW: 1337, WINDOWEDGE: 1337, CLIENTEDGE: 1337, CONTEXTHELP: 1337, RIGHT: 1337, LEFT: 1337, RTLREADING: 1337, LTRREADING: 1337, LEFTSCROLLBAR: 1337, RIGHTSCROLLBAR: 1337, CONTROLPARENT: 1337, STATICEDGE: 1337, APPWINDOW: 1337, LAYERED: 1337, NOINHERITLAYOUT: 1337, NOREDIRECTIONBITMAP: 1337, LAYOUTRTL: 1337, COMPOSITED: 1337, NOACTIVATE: 1337, OVERLAPPEDWINDOW: 1337, PALETTEWINDOW: 1337 }
;enum window.SW: i32{ HIDE: 1337, SHOWNORMAL: 1337, NORMAL: 1337, SHOWMINIMIZED: 1337, SHOWMAXIMIZED: 1337, MAXIMIZE: 1337, SHOWNOACTIVATE: 1337, SHOW: 1337, MINIMIZE: 1337, SHOWMINNOACTIVE: 1337, SHOWNA: 1337, RESTORE: 1337, SHOWDEFAULT: 1337, FORCEMINIMIZE: 1337, MAX: 1337 }
;enum window.SYS_COLOR: i32{ SCROLLBAR: 1337, BACKGROUND: 1337, DESKTOP: 1337, ACTIVECAPTION: 1337, INACTIVECAPTION: 1337, MENU: 1337, WINDOW: 1337, WINDOWFRAME: 1337, MENUTEXT: 1337, WINDOWTEXT: 1337, CAPTIONTEXT: 1337, ACTIVEBORDER: 1337, INACTIVEBORDER: 1337, APPWORKSPACE: 1337, HIGHLIGHT: 1337, HIGHLIGHTTEXT: 1337, BTNFACE: 1337, THREEDFACE: 1337, BTNSHADOW: 1337, THREEDSHADOW: 1337, GRAYTEXT: 1337, BTNTEXT: 1337, INACTIVECAPTIONTEXT: 1337, BTNHIGHLIGHT: 1337, THREEDHIGHLIGHT: 1337, BTNHILIGHT: 1337, THREEDHILIGHT: 1337, THREEDDKSHADOW: 1337, THREEDLIGHT: 1337, INFOTEXT: 1337, INFOBK: 1337, HOTLIGHT: 1337, GRADIENTACTIVECAPTION: 1337, GRADIENTINACTIVECAPTION: 1337, MENUHILIGHT: 1337, MENUBAR: 1337 }
define i32 @window.RegisterClassA(lpWndClass: &i32)
define &void @window.CreateWindowExA(dwExStyle: i16, lpClassName: &i8, lpWindowName: &i8, dwStyle: i16, x: i32, y: i32, nWidth: i32, nHeight: i32, hWndParent: &void, hMenu: &void, hInstance: &void, lpParam: &void)
define i64 @window.DefWindowProcA(hWnd: &void, Msg: i16, wParam: i64, lParam: i64)
define i32 @window.GetMessageA(lpMsg: &i32, hWnd: &void, wMsgFilterMin: i16, wMsgFilterMax: i16)
define i32 @window.TranslateMessage(lpMsg: &i32)
define i64 @window.DispatchMessageA(lpMsg: &i32)
define void @window.PostQuitMessage(nExitCode: i32)
define &void @window.BeginPaint(hWnd: &void, lpPaint: &i32)
define i32 @window.EndPaint(hWnd: &void, lpPaint: &i32)
define &void @window.GetDC(hWnd: &void)
define i32 @window.ReleaseDC(hWnd: &void, hDC: &void)
define &void @window.LoadCursorA(hInstance: &void, lpCursorName: &i8)
define &void @window.LoadIconA(hInstance: &void, lpIconName: &i8)
define &void @window.LoadImageA(hInst: &void, name: &i8, type: i16, cx: i32, cy: i32, fuLoad: i16)
define i32 @window.GetClientRect(hWnd: &void, lpRect: &i32)
define i32 @window.InvalidateRect(hWnd: &void, lpRect: &i32, bErase: i32)
define i32 @window.RegisterClassExA(lpwcx: &i32)
define i32 @window.ShowWindow(hWnd: &void, nCmdShow: i32)
define i64 @window.SetWindowLongPtrA(hWnd: &void, nIndex: i32, dwNewLong: &void)
define &void @window.GetWindowLongPtrA(hWnd: &void, nIndex: i32)
define &void @window.GetModuleHandleA(lpModuleName: &i8)
define &void @window.CreateCompatibleDC(hdc: &void)
define &void @window.SelectObject(hdc: &void, h: &void)
define i32 @window.BitBlt(hdc: &void, x: i32, y: i32, cx: i32, cy: i32, hdcSrc: &void, x1: i32, y1: i32, rop: i16)
define i32 @window.DeleteDC(hdc: &void)
define i32 @window.DeleteObject(hObject: &void)
define i32 @window.GetObjectA(h: &void, c: i32, pv: &i32)
define i32 @window.SetStretchBltMode(hdc: &void, mode: i32)
define i32 @window.StretchBlt(hdcDest: &void, xDest: i32, yDest: i32, wDest: i32, hDest: i32, hdcSrc: &void, xSrc: i32, ySrc: i32, wSrc: i32, hSrc: i32, rop: i16)
;struct window.POINT{ x: i32, y: i32 }
;struct window.MSG{ hwnd: &void, message: i16, wParam: i64, lParam: i64, time: i16, pt: i32 }
;struct window.WNDCLASSEXA{ cbSize: i16, style: i16, lpfnWndProc: &i32, cbClsExtra: i32, cbWndExtra: i32, hInstance: &void, hIcon: &void, hCursor: &void, hbrBackground: &void, lpszMenuName: &i8, lpszClassName: &i8, hIconSm: &void }
;struct window.RECT{ left: i32, top: i32, right: i32, bottom: i32 }
;struct window.PAINTSTRUCT{ hdc: &void, fErase: i32, rcPaint: i32, fRestore: i32, fIncUpdate: i32, rgbReserved: i32 }
;struct window.BITMAP{ bmType: i32, bmWidth: i32, bmHeight: i32, bmWidthBytes: i32, bmPlanes: i32, bmBitsPixel: i32, bmBits: &void }
define i64 @window.WindowProc(hWnd: &void, uMsg: i16, wParam: i64, lParam: i64)
;enum window.StartError: i32{ Ok: 1337, GetModuleHandleFailed: 1337, RegisterClassFailed: 1337, CreateWindowFailed: 1337 }
define &void @window.load_bitmap_from_file(path: &i8)
define void @window.get_bitmap_dimensions(hBitmap: &void, width: &i32, height: &i32)
define void @window.draw_bitmap(hdc: &void, hBitmap: &void, x: i32, y: i32)
define void @window.draw_bitmap_stretched(hdc: &void, hBitmap: &void, x: i32, y: i32, width: i32, height: i32)
define i1 @window.is_null(p: &void)
define void @window.start()
define void @window.start_image_window(imagePath: &i8)
;enum TokenType: i8{ LParen: 0, RParen: 1, LBrace: 2, RBrace: 3, LSquareBrace: 4, RSquareBrace: 5, Colon: 6, DoubleColon: 7, SemiColon: 8, Comma: 9, Dot: 10, RangeDots: 11, RangeDotsInclusive: 12, FatArrow: 13, Hint: 14, Equal: 15, Plus: 16, Minus: 17, Multiply: 18, Divide: 19, Modulo: 20, LogicNot: 21, LogicEqual: 22, LogicNotEqual: 23, LogicOr: 24, LogicAnd: 25, LogicGreater: 26, LogicGreaterEqual: 27, LogicLess: 28, LogicLessEqual: 29, BitNot: 30, BitOr: 31, BitAnd: 32, BitXor: 33, BitShiftL: 34, BitShiftR: 35, KeywordPub: 36, KeywordInline: 37, KeywordConst: 38, KeywordExtern: 39, KeywordMatch: 40, KeywordFunction: 41, KeywordLet: 42, KeywordStatic: 43, KeywordAs: 44, KeywordIf: 45, KeywordElse: 46, KeywordTrait: 47, KeywordImpl: 48, KeywordStruct: 49, KeywordEnum: 50, KeywordLoop: 51, KeywordFor: 52, KeywordDo: 53, KeywordIn: 54, KeywordWhile: 55, KeywordBreak: 56, KeywordContinue: 57, KeywordReturn: 58, KeywordThis: 59, KeywordOperator: 60, KeywordNamespace: 61, KeywordTrue: 62, KeywordFalse: 63, KeywordNull: 64, Name: 65, Integer: 66, Decimal: 67, String: 68, Char: 69, DummyToken: 70 }
define i1 @is_modifier(val: i32)
define i32 @token_type_to_string(val: &i32, symbol_vector: &i32)
;struct TokenData{ token_type: i32, symbol_id: i32, file_offset: i16 }
define i32 @insert_symbol(data: &i8, len: i32, symbols: &i32)
define void @handle_number(data: &i8, start: i16, end: i16, tokens: &i32, symbols: &i32)
define void @handle_decimal_number(data: &i8, start: i16, end: i16, tokens: &i32, symbols: &i32)
define void @handle_string(data: &i8, start: i16, end: i16, tokens: &i32, symbols: &i32)
define void @handle_char(data: &i8, start: i16, end: i16, tokens: &i32, symbols: &i32)
define void @handle_symbol(data: &i8, start: i16, end: i16, tokens: &i32, symbols: &i32)
define void @lex(data: &i32, token_vector: &i32, symbol_vector: &i32)
;struct IntegerExpr{ idx: i32 }
;struct DecimalExpr{ idx: i32 }
;struct CharExpr{ val: i32 }
;struct NameExpr{ idx: i32 }
;struct StringConstExpr{ idx: i32 }
;struct TypeExpr{ val: i32 }
;enum BinaryOp: i8{ Add: 0, Subtract: 1, Multiply: 2, Divide: 3, Modulo: 4, Assign: 5, Equals: 6, NotEqual: 7, Less: 8, LessEqual: 9, Greater: 10, GreaterEqual: 11, And: 12, Or: 13, BitAnd: 14, BitOr: 15, BitXor: 16, ShiftLeft: 17, ShiftRight: 18 }
;struct BinaryOpExpr{ lval: i32, rval: i32, op: i32 }
;enum UnaryOp: i8{ Negate: 0, Not: 1, Deref: 2, Pointer: 3, BitFlip: 4 }
;struct UnaryOpExpr{ rval: i32, op: i32 }
;struct CastExpr{ rval: i32, to: i32 }
;struct MemberAccessExpr{ rval: i32, member: i32 }
;struct StaticAccessExpr{ rval: i32, member: i32 }
;struct NameWithGenericsExpr{ rval: i32, generics: i32 }
;struct CallExpr{ lval: i32, expr: i32, generics: i32 }
;struct RangeExpr{ start: i32, end: i32, inclusive: i1 }
;struct IndexExpr{ lval: i32, index_expr: i32 }
;struct ArrayExpr{ expr: i32 }
;struct StructInitFieldExpr{ name: i32, expr: i32 }
;struct StructInitExpr{ type: i32, expr: i32 }
;struct BoolExpr{ val: i1 }
;enum ExpressionType: i32{ Integer: 0, Char: 1, Decimal: 2, Name: 3, StringConst: 4, Type: 5, BinaryOp: 6, UnaryOp: 7, Cast: 8, MemberAccess: 9, StaticAccess: 10, NameWithGenerics: 11, Call: 12, Index: 13, Array: 14, StructInit: 15, Range: 16, Boolean: 17, NullPtr: 18 }
;struct Expression{ type: i32, val: &void }
;constant PREFIX_PRECEDENCE = i8
define i1 @is_prefix_operator(token: i32)
define i8 @precedence(token: i32)
define i32 @get_unary_op(token: i32)
define i32 @get_binary_op(token: i32)
define i32 @parse_expression_internal(tokens: &i32, index: &i16, len: i16, min_precedence: i8)
define i32 @parse_expression(token_array: &i32, index: &i16, len: i16)
define i32 @parse_expression_comma(token_array: &i32, index: &i16, len: i16)
;constant MAX_PATH_DEPTH = i16
;constant MAX_PATH_EX_DEPTH = i16
;struct Path{ len: i8, data: i32 }
;struct PathEx{ len: i8, data: i32 }
define i32 @path_to_path_ex(path: &i32)
define i32 @path_to_path_ex_name(path: &i32, name: i32)
;enum TypeType: i32{ Named: 0, Pointer: 1, Function: 2, NamespaceLink: 3, Generic: 4, ConstantSizeArray: 5 }
;struct NamedType{ idx: i32 }
;struct PointerType{ deep: i8, inner: i32 }
;struct FunctionType{ args: i32, return_type: i32 }
;struct NamespaceLinkType{ path: i32, rval: i32 }
;struct GenericType{ idx: i32, gen_args: i32 }
;struct ConstantSizeArrayType{ inner: i32, size: i32 }
;struct Type{ type: i32, val: &void }
define i32 @wrap_in_pointers(base: i32, depth: i16)
define i32 @parse_generic_args(token_array: &i32, index: &i16, len: i16)
define i32 @parse_types_comma(token_array: &i32, index: &i16, len: i16, stop: i32)
define i32 @parse_type_internal(token_array: &i32, index: &i16, len: i16)
define i32 @parse_type(token_array: &i32, index: &i16, len: i16)
define i32 @parse_types_comma_rparen(token_array: &i32, index: &i16, len: i16)
define void @free_type(t: i32)
;enum Flags: i8{ Public: 1337, Inline: 1337, External: 1337, NoReturn: 1337, Static: 1337, Export: 1337 }
;struct Argument{ name: i32, type: i32 }
;struct EnumField{ name: i32, has_value: i1, value: i32 }
;struct HintNode{ name: i32, flags: i8, expressions: i32 }
;struct FnNode{ name: i32, flags: i8, arguments: i32, has_value: i1, return_type: i32, generic: i32, nodes: i32 }
;struct EnumNode{ name: i32, flags: i8, has_value: i1, enum_type: i32, fields: i32 }
;struct StructNode{ name: i32, flags: i8, fields: i32, generic: i32 }
;struct IfStmt{ cond: i32, then_body: i32, else_body: i32 }
;struct LoopStmt{ body: i32 }
;struct WhileStmt{ cond: i32, body: i32 }
;struct DoWhileStmt{ cond: i32, body: i32 }
;struct ForStmt{ iter: i32, in_expr: i32, body: i32 }
;struct NamespaceNode{ name: i32, nodes: i32 }
;struct BlockStmt{ body: i32 }
;struct ReturnNode{ has_value: i1, expression: i32 }
;struct ExpressionNode{ expression: i32 }
;enum VarType: i8{ Stack: 0, Static: 1, Constant: 2 }
;struct DeclarationNode{ name: i32, has_value: i1, expression: i32, var_type: i32, var_comp_type: i32 }
;enum StatementType: i8{ CompilerHint: 0, VarDec: 1, Expression: 2, If: 3, Loop: 4, WhileLoop: 5, DoWhileLoop: 6, ForLoop: 7, Break: 8, Continue: 9, Return: 10, Function: 11, Struct: 12, Enum: 13, Namespace: 14, Impl: 15, TraitDeclaration: 16, Block: 17, Debug: 18, CompilerDud: 19, Attribute: 20 }
;struct Stmt{ statement_type: i32, node_ptr: &void }
define void @expect(tokens: &i32, index: &i16, len: i16, expected: i32, error_msg: &i8)
define void @skip_nested(tokens: &i32, index: &i16, len: i16, open: i32, close: i32)
define void @skip_if_statement(tokens: &i32, index: &i16, len: i16)
define i32 @parse_argument_comma(token_array: &i32, index: &i16, len: i16)
define i32 @parse_generic_params(token_array: &i32, index: &i16, len: i16)
define i32 @parse_struct_fields(token_array: &i32, index: &i16, len: i16)
define i32 @parse_enum_fields(token_array: &i32, index: &i16, len: i16)
define i1 @is_expression_starter(token: i32)
define void @parse_body(token_array: &i32, token_len: i16, symbol_vector: &i32, statement_vector: &i32)
define i8 @get_flags(token_array: &i32, index: i16, mod_index: i16)
;constant NO_MODIFIER = i16
define void @parse(token_array: &i32, token_len: i16, symbol_vector: &i32, statement_vector: &i32)
