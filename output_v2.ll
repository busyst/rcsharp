;enum SymbolTableTag: i32{ Function: 1337, GenericFunction: 1337, Struct: 1337, GenericStruct: 1337, Enum: 1337, Static: 1337, Constant: 1337, OnlyTypesMask: 1337, Solved: 1337 }
;struct SymbolTableEntry{ tag: i32, path: i32, val: &void }
;struct EnumDefinedField{ name: i32, value: i64 }
;struct EnumSymbolTableEntry{ representative_type: i32, fields: i32 }
;struct StructDefinedField{ name: i32, type: i32 }
;struct StructSymbolTableEntry{ fields: i32, size_of: i16 }
;struct GenericStructDefinedField{ name: i32, type: i32, is_generic: i1 }
;struct GenericStructSymbolTableEntry{ fields: i32, generic_tokens: i32, implementations: i32 }
;struct ConstantSymbolTableEntry{ type: i32, defined_value: i32 }
;struct StaticSymbolTableEntry{ type: i32, has_initialized_value: i1, initialized_value: i32 }
;struct SymbolTable{ symbols: i32, symbol_vector: &i32 }
;struct Variable{ name: i16 }
;struct Scope{ values: i32, scope_index: i32 }
;enum CompilerTypeKind: i32{ Primitive: 0, Pointer: 1 }
;struct PointerCompilerType{ deep: i8, inner: i32 }
;struct CompilerType{ kind: i32, data: &void }
;enum RvalueKind: i32{ Unsolved: 0, Integer: 1 }
;struct Rvalue{ kind: i32, data: &void }
;struct Layout{ size: i32, align: i32 }
;enum PrimitiveKind: i32{ Void: 0, Bool: 1, SignedInt: 2, UnsignedInt: 3, Decimal: 4 }
;struct PrimitiveTypeInfo{ name: &i8, llvm_signature: &i8, layout: i32, kind: i32 }
;struct mem.PROCESS_HEAP_ENTRY{ lpData: &void, cbData: i16, cbOverhead: i8, iRegionIndex: i8, wFlags: i32, Block_hMem: &void, Block_dwReserved0: i16, Block_dwReserved1: i16, Block_dwReserved2: i16 }
;struct list.List{ head: &i32, foot: &i32, length: i16 }
;struct list.ListNode{ data: i32, next_node: &i32 }
;struct vector.Vec{ array: &i32, length: i16, capacity: i16 }
;struct string.String{ data: &i8, len: i32, capacity: i32 }
;enum tests.LexerTokens: i64{ String: 0 }
;enum window.WM: i16{ NULL: 1337, CREATE: 1337, DESTROY: 1337, MOVE: 1337, SIZE: 1337, ACTIVATE: 1337, SETFOCUS: 1337, KILLFOCUS: 1337, ENABLE: 1337, SETREDRAW: 1337, SETTEXT: 1337, GETTEXT: 1337, GETTEXTLENGTH: 1337, PAINT: 1337, CLOSE: 1337, QUERYENDSESSION: 1337, QUERYOPEN: 1337, ENDSESSION: 1337, QUIT: 1337, ERASEBKGND: 1337, SYSCOLORCHANGE: 1337, SHOWWINDOW: 1337, WININICHANGE: 1337, SETTINGCHANGE: 1337, DEVMODECHANGE: 1337, ACTIVATEAPP: 1337, FONTCHANGE: 1337, TIMECHANGE: 1337, CANCELMODE: 1337, SETCURSOR: 1337, MOUSEACTIVATE: 1337, CHILDACTIVATE: 1337, QUEUESYNC: 1337, GETMINMAXINFO: 1337, PAINTICON: 1337, ICONERASEBKGND: 1337, NEXTDLGCTL: 1337, SPOOLERSTATUS: 1337, DRAWITEM: 1337, MEASUREITEM: 1337, DELETEITEM: 1337, VKEYTOITEM: 1337, CHARTOITEM: 1337, SETFONT: 1337, GETFONT: 1337, SETHOTKEY: 1337, GETHOTKEY: 1337, QUERYDRAGICON: 1337, COMPAREITEM: 1337, GETOBJECT: 1337, COMPACTING: 1337, COMMNOTIFY: 1337, WINDOWPOSCHANGING: 1337, WINDOWPOSCHANGED: 1337, POWER: 1337, COPYDATA: 1337, CANCELJOURNAL: 1337, NOTIFY: 1337, INPUTLANGCHANGEREQUEST: 1337, INPUTLANGCHANGE: 1337, TCARD: 1337, HELP: 1337, USERCHANGED: 1337, NOTIFYFORMAT: 1337, CONTEXTMENU: 1337, STYLECHANGING: 1337, STYLECHANGED: 1337, DISPLAYCHANGE: 1337, GETICON: 1337, SETICON: 1337, NCCREATE: 1337, NCDESTROY: 1337, NCCALCSIZE: 1337, NCHITTEST: 1337, NCPAINT: 1337, NCACTIVATE: 1337, GETDLGCODE: 1337, SYNCPAINT: 1337, NCMOUSEMOVE: 1337, NCLBUTTONDOWN: 1337, NCLBUTTONUP: 1337, NCLBUTTONDBLCLK: 1337, NCRBUTTONDOWN: 1337, NCRBUTTONUP: 1337, NCRBUTTONDBLCLK: 1337, NCMBUTTONDOWN: 1337, NCMBUTTONUP: 1337, NCMBUTTONDBLCLK: 1337, NCXBUTTONDOWN: 1337, NCXBUTTONUP: 1337, NCXBUTTONDBLCLK: 1337, INPUT_DEVICE_CHANGE: 1337, INPUT: 1337, KEYFIRST: 1337, KEYDOWN: 1337, KEYUP: 1337, CHAR: 1337, DEADCHAR: 1337, SYSKEYDOWN: 1337, SYSKEYUP: 1337, SYSCHAR: 1337, SYSDEADCHAR: 1337, UNICHAR: 1337, KEYLAST: 1337, INITDIALOG: 1337, COMMAND: 1337, SYSCOMMAND: 1337, TIMER: 1337, HSCROLL: 1337, VSCROLL: 1337, INITMENU: 1337, INITMENUPOPUP: 1337, MENUSELECT: 1337, MENUCHAR: 1337, ENTERIDLE: 1337, MENURBUTTONUP: 1337, MENUDRAG: 1337, MENUGETOBJECT: 1337, UNINITMENUPOPUP: 1337, MENUCOMMAND: 1337, CHANGEUISTATE: 1337, UPDATEUISTATE: 1337, QUERYUISTATE: 1337, CTLCOLORMSGBOX: 1337, CTLCOLOREDIT: 1337, CTLCOLORLISTBOX: 1337, CTLCOLORBTN: 1337, CTLCOLORDLG: 1337, CTLCOLORSCROLLBAR: 1337, CTLCOLORSTATIC: 1337, MOUSEFIRST: 1337, MOUSEMOVE: 1337, LBUTTONDOWN: 1337, LBUTTONUP: 1337, LBUTTONDBLCLK: 1337, RBUTTONDOWN: 1337, RBUTTONUP: 1337, RBUTTONDBLCLK: 1337, MBUTTONDOWN: 1337, MBUTTONUP: 1337, MBUTTONDBLCLK: 1337, MOUSEWHEEL: 1337, XBUTTONDOWN: 1337, XBUTTONUP: 1337, XBUTTONDBLCLK: 1337, MOUSEHWHEEL: 1337, MOUSELAST: 1337, PARENTNOTIFY: 1337, ENTERMENULOOP: 1337, EXITMENULOOP: 1337, NEXTMENU: 1337, SIZING: 1337, CAPTURECHANGED: 1337, MOVING: 1337, POWERBROADCAST: 1337, DEVICECHANGE: 1337, MDICREATE: 1337, MDIDESTROY: 1337, MDIACTIVATE: 1337, MDIRESTORE: 1337, MDINEXT: 1337, MDIMAXIMIZE: 1337, MDITILE: 1337, MDICASCADE: 1337, MDIICONARRANGE: 1337, MDIGETACTIVE: 1337, MDISETMENU: 1337, ENTERSIZEMOVE: 1337, EXITSIZEMOVE: 1337, DROPFILES: 1337, MDIREFRESHMENU: 1337, DPICHANGED: 1337, THEMECHANGED: 1337, CLIPBOARDUPDATE: 1337, USER: 1337, APP: 1337 }
;enum window.CS: i16{ VREDRAW: 1337, HREDRAW: 1337, DBLCLKS: 1337, OWNDC: 1337, CLASSDC: 1337, PARENTDC: 1337, NOCLOSE: 1337, SAVEBITS: 1337, BYTEALIGNCLIENT: 1337, BYTEALIGNWINDOW: 1337, GLOBALCLASS: 1337, IME: 1337, DROPSHADOW: 1337 }
;enum window.WS: i16{ OVERLAPPED: 1337, POPUP: 1337, CHILD: 1337, MINIMIZE: 1337, VISIBLE: 1337, DISABLED: 1337, CLIPSIBLINGS: 1337, CLIPCHILDREN: 1337, MAXIMIZE: 1337, CAPTION: 1337, BORDER: 1337, DLGFRAME: 1337, VSCROLL: 1337, HSCROLL: 1337, SYSMENU: 1337, THICKFRAME: 1337, GROUP: 1337, TABSTOP: 1337, MINIMIZEBOX: 1337, MAXIMIZEBOX: 1337, TILED: 1337, ICONIC: 1337, SIZEBOX: 1337, TILEDWINDOW: 1337, OVERLAPPEDWINDOW: 1337, POPUPWINDOW: 1337, CHILDWINDOW: 1337 }
;enum window.WS_EX: i16{ DLGMODALFRAME: 1337, NOPARENTNOTIFY: 1337, TOPMOST: 1337, ACCEPTFILES: 1337, TRANSPARENT: 1337, MDICHILD: 1337, TOOLWINDOW: 1337, WINDOWEDGE: 1337, CLIENTEDGE: 1337, CONTEXTHELP: 1337, RIGHT: 1337, LEFT: 1337, RTLREADING: 1337, LTRREADING: 1337, LEFTSCROLLBAR: 1337, RIGHTSCROLLBAR: 1337, CONTROLPARENT: 1337, STATICEDGE: 1337, APPWINDOW: 1337, LAYERED: 1337, NOINHERITLAYOUT: 1337, NOREDIRECTIONBITMAP: 1337, LAYOUTRTL: 1337, COMPOSITED: 1337, NOACTIVATE: 1337, OVERLAPPEDWINDOW: 1337, PALETTEWINDOW: 1337 }
;enum window.SW: i32{ HIDE: 1337, SHOWNORMAL: 1337, NORMAL: 1337, SHOWMINIMIZED: 1337, SHOWMAXIMIZED: 1337, MAXIMIZE: 1337, SHOWNOACTIVATE: 1337, SHOW: 1337, MINIMIZE: 1337, SHOWMINNOACTIVE: 1337, SHOWNA: 1337, RESTORE: 1337, SHOWDEFAULT: 1337, FORCEMINIMIZE: 1337, MAX: 1337 }
;enum window.SYS_COLOR: i32{ SCROLLBAR: 1337, BACKGROUND: 1337, DESKTOP: 1337, ACTIVECAPTION: 1337, INACTIVECAPTION: 1337, MENU: 1337, WINDOW: 1337, WINDOWFRAME: 1337, MENUTEXT: 1337, WINDOWTEXT: 1337, CAPTIONTEXT: 1337, ACTIVEBORDER: 1337, INACTIVEBORDER: 1337, APPWORKSPACE: 1337, HIGHLIGHT: 1337, HIGHLIGHTTEXT: 1337, BTNFACE: 1337, THREEDFACE: 1337, BTNSHADOW: 1337, THREEDSHADOW: 1337, GRAYTEXT: 1337, BTNTEXT: 1337, INACTIVECAPTIONTEXT: 1337, BTNHIGHLIGHT: 1337, THREEDHIGHLIGHT: 1337, BTNHILIGHT: 1337, THREEDHILIGHT: 1337, THREEDDKSHADOW: 1337, THREEDLIGHT: 1337, INFOTEXT: 1337, INFOBK: 1337, HOTLIGHT: 1337, GRADIENTACTIVECAPTION: 1337, GRADIENTINACTIVECAPTION: 1337, MENUHILIGHT: 1337, MENUBAR: 1337 }
;struct window.POINT{ x: i32, y: i32 }
;struct window.MSG{ hwnd: &void, message: i16, wParam: i64, lParam: i64, time: i16, pt: i32 }
;struct window.WNDCLASSEXA{ cbSize: i16, style: i16, lpfnWndProc: &i32, cbClsExtra: i32, cbWndExtra: i32, hInstance: &void, hIcon: &void, hCursor: &void, hbrBackground: &void, lpszMenuName: &i8, lpszClassName: &i8, hIconSm: &void }
;struct window.RECT{ left: i32, top: i32, right: i32, bottom: i32 }
;struct window.PAINTSTRUCT{ hdc: &void, fErase: i32, rcPaint: i32, fRestore: i32, fIncUpdate: i32, rgbReserved: i32 }
;struct window.BITMAP{ bmType: i32, bmWidth: i32, bmHeight: i32, bmWidthBytes: i32, bmPlanes: i32, bmBitsPixel: i32, bmBits: &void }
;enum window.StartError: i32{ Ok: 1337, GetModuleHandleFailed: 1337, RegisterClassFailed: 1337, CreateWindowFailed: 1337 }
;enum TokenType: i8{ LParen: 0, RParen: 1, LBrace: 2, RBrace: 3, LSquareBrace: 4, RSquareBrace: 5, Colon: 6, DoubleColon: 7, SemiColon: 8, Comma: 9, Dot: 10, RangeDots: 11, RangeDotsInclusive: 12, FatArrow: 13, Hint: 14, Equal: 15, Plus: 16, Minus: 17, Multiply: 18, Divide: 19, Modulo: 20, LogicNot: 21, LogicEqual: 22, LogicNotEqual: 23, LogicOr: 24, LogicAnd: 25, LogicGreater: 26, LogicGreaterEqual: 27, LogicLess: 28, LogicLessEqual: 29, BitNot: 30, BitOr: 31, BitAnd: 32, BitXor: 33, BitShiftL: 34, BitShiftR: 35, KeywordPub: 36, KeywordInline: 37, KeywordConst: 38, KeywordExtern: 39, KeywordMatch: 40, KeywordFunction: 41, KeywordLet: 42, KeywordStatic: 43, KeywordAs: 44, KeywordIf: 45, KeywordElse: 46, KeywordTrait: 47, KeywordImpl: 48, KeywordStruct: 49, KeywordEnum: 50, KeywordLoop: 51, KeywordFor: 52, KeywordDo: 53, KeywordIn: 54, KeywordWhile: 55, KeywordBreak: 56, KeywordContinue: 57, KeywordReturn: 58, KeywordThis: 59, KeywordOperator: 60, KeywordNamespace: 61, KeywordTrue: 62, KeywordFalse: 63, KeywordNull: 64, Name: 65, Integer: 66, Decimal: 67, String: 68, Char: 69, DummyToken: 70 }
;struct TokenData{ token_type: i32, symbol_id: i32, file_offset: i16 }
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
;struct Path{ len: i8, data: i32 }
;struct PathEx{ len: i8, data: i32 }
;enum TypeType: i32{ Named: 0, Pointer: 1, Function: 2, NamespaceLink: 3, Generic: 4, ConstantSizeArray: 5 }
;struct NamedType{ idx: i32 }
;struct PointerType{ deep: i8, inner: i32 }
;struct FunctionType{ args: i32, return_type: i32 }
;struct NamespaceLinkType{ path: i32, rval: i32 }
;struct GenericType{ idx: i32, gen_args: i32 }
;struct ConstantSizeArrayType{ inner: i32, size: i32 }
;struct Type{ type: i32, val: &void }
;enum Flags: i8{ Public: 1337, Inline: 1337, External: 1337, NoReturn: 1337, Static: 1337, Export: 1337 }
;struct Argument{ name: i32, type: i32 }
;struct EnumField{ name: i32, has_value: i1, value: i32 }
;struct HintNode{ name: i32, flags: i8, expressions: i32 }
;struct FnNode{ name: i32, flags: i8, arguments: i32, return_type: &i32, generic: i32, nodes: i32 }
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
;enum SymbolTableTag: i32{ Function: 1337, GenericFunction: 1337, Struct: 1337, GenericStruct: 1337, Enum: 1337, Static: 1337, Constant: 1337, OnlyTypesMask: 1337, Solved: 1337 }
;struct SymbolTableEntry{ tag: i32, path: i32, val: &void }
;struct EnumDefinedField{ name: i32, value: i64 }
;struct EnumSymbolTableEntry{ representative_type: i32, fields: i32 }
;struct StructDefinedField{ name: i32, type: i32 }
;struct StructSymbolTableEntry{ fields: i32, size_of: i16 }
;struct GenericStructDefinedField{ name: i32, type: i32, is_generic: i1 }
;struct GenericStructSymbolTableEntry{ fields: i32, generic_tokens: i32, implementations: i32 }
;struct ConstantSymbolTableEntry{ type: i32, defined_value: i32 }
;struct StaticSymbolTableEntry{ type: i32, has_initialized_value: i1, initialized_value: i32 }
;struct SymbolTable{ symbols: i32, symbol_vector: &i32 }
;struct Variable{ name: i16 }
;struct Scope{ values: i32, scope_index: i32 }
;enum CompilerTypeKind: i32{ Primitive: 0, Pointer: 1 }
;struct PointerCompilerType{ deep: i8, inner: i32 }
;struct CompilerType{ kind: i32, data: &void }
;enum RvalueKind: i32{ Unsolved: 0, Integer: 1 }
;struct Rvalue{ kind: i32, data: &void }
;struct Layout{ size: i32, align: i32 }
;enum PrimitiveKind: i32{ Void: 0, Bool: 1, SignedInt: 2, UnsignedInt: 3, Decimal: 4 }
;struct PrimitiveTypeInfo{ name: &i8, llvm_signature: &i8, layout: i32, kind: i32 }
