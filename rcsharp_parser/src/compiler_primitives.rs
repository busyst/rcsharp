#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Layout {
    pub size: u32,
    pub align: u32,
}
impl Layout {
    pub const fn is_valid(&self) -> bool { !(self.align == u32::MAX || self.size == u32::MAX) }
    pub const fn new(size: u32, align: u32) -> Self { Self { size, align } }
    pub const fn new_not_valid() -> Self { Self { size: u32::MAX, align: u32::MAX } }
}
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum PrimitiveKind {
    Void,
    Bool,
    SignedInt,
    UnsignedInt,
    Decimal,
}
pub struct PrimitiveInfo {
    pub name: &'static str,
    pub layout: Layout,
    pub llvm_name: &'static str,
    pub kind: PrimitiveKind,
}

pub const PRIMITIVE_TYPES_INFO: &[PrimitiveInfo] = &[
    PrimitiveInfo { name: "void", layout: Layout::new(0, 1), llvm_name: "void", kind: PrimitiveKind::Void },
    PrimitiveInfo { name: "bool", layout: Layout::new(1, 1), llvm_name: "i1", kind: PrimitiveKind::Bool },
    // SInts
    PrimitiveInfo { name: "i8", layout: Layout::new(1, 1), llvm_name: "i8", kind: PrimitiveKind::SignedInt },
    PrimitiveInfo { name: "i16", layout: Layout::new(2, 2), llvm_name: "i16", kind: PrimitiveKind::SignedInt },
    PrimitiveInfo { name: "i32", layout: Layout::new(4, 4), llvm_name: "i32", kind: PrimitiveKind::SignedInt },
    PrimitiveInfo { name: "i64", layout: Layout::new(8, 8), llvm_name: "i64", kind: PrimitiveKind::SignedInt },
    // UInts
    PrimitiveInfo { name: "u8", layout: Layout::new(1, 1), llvm_name: "i8", kind: PrimitiveKind::UnsignedInt },
    PrimitiveInfo { name: "u16", layout: Layout::new(2, 2), llvm_name: "i16", kind: PrimitiveKind::UnsignedInt },
    PrimitiveInfo { name: "u32", layout: Layout::new(4, 4), llvm_name: "i32", kind: PrimitiveKind::UnsignedInt },
    PrimitiveInfo { name: "u64", layout: Layout::new(8, 8), llvm_name: "i64", kind: PrimitiveKind::UnsignedInt },
    // Decimal
    PrimitiveInfo { name: "f16", layout: Layout::new(2, 2), llvm_name: "half", kind: PrimitiveKind::Decimal },
    PrimitiveInfo { name: "f32", layout: Layout::new(4, 4), llvm_name: "float", kind: PrimitiveKind::Decimal },
    PrimitiveInfo { name: "f64", layout: Layout::new(8, 8), llvm_name: "double", kind: PrimitiveKind::Decimal },

    PrimitiveInfo { name: "isize", layout: Layout::new(8, 8), llvm_name: "i64", kind: PrimitiveKind::SignedInt },
    PrimitiveInfo { name: "usize", layout: Layout::new(8, 8), llvm_name: "i64", kind: PrimitiveKind::UnsignedInt },
];
pub const VOID_TYPE: &PrimitiveInfo = &PRIMITIVE_TYPES_INFO[0];
pub const BOOL_TYPE: &PrimitiveInfo = &PRIMITIVE_TYPES_INFO[1];

pub fn find_primitive_type(name: &str) -> Option<&'static PrimitiveInfo> {
    PRIMITIVE_TYPES_INFO.iter().find(|x| x.name == name)
}
pub fn find_primitive_type_position(name: &str) -> Option<usize> {
    PRIMITIVE_TYPES_INFO.iter().position(|x| x.name == name)
}