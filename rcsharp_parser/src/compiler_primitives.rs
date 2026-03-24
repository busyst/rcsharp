use crate::parser::ParserType;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct Layout {
    pub size: u32,
    pub align: u32,
}
impl Layout {
    pub const INVALID: Self = Self {
        size: u32::MAX,
        align: u32::MAX,
    };

    pub const fn new(size: u32, align: u32) -> Self {
        Self { size, align }
    }
    #[inline]
    pub const fn is_valid(self) -> bool {
        self.size != u32::MAX && self.align != u32::MAX
    }
}
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum PrimitiveKind {
    Void,
    Bool,
    SignedInt,
    UnsignedInt,
    Decimal,
}
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct PrimitiveInfo {
    pub name: &'static str,
    pub layout: Layout,
    pub llvm_name: &'static str,
    pub kind: PrimitiveKind,
}

impl PrimitiveInfo {
    #[inline]
    pub fn is_void(self) -> bool {
        self.kind == PrimitiveKind::Void
    }
    #[inline]
    pub fn is_bool(self) -> bool {
        self.kind == PrimitiveKind::Bool
    }
    #[inline]
    pub fn is_signed_integer(self) -> bool {
        self.kind == PrimitiveKind::SignedInt
    }
    #[inline]
    pub fn is_unsigned_integer(self) -> bool {
        self.kind == PrimitiveKind::UnsignedInt
    }
    #[inline]
    pub fn is_decimal(self) -> bool {
        self.kind == PrimitiveKind::Decimal
    }
    #[inline]
    pub fn is_integer(self) -> bool {
        matches!(
            self.kind,
            PrimitiveKind::SignedInt | PrimitiveKind::UnsignedInt
        )
    }
    #[inline]
    pub const fn is_droppable(self) -> bool {
        false
    }
}
impl std::fmt::Display for PrimitiveInfo {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.write_str(self.name)
    }
}
impl From<&'static PrimitiveInfo> for ParserType {
    fn from(info: &'static PrimitiveInfo) -> Self {
        ParserType::Named(info.name.to_string())
    }
}
macro_rules! prim {
    ($name:literal, $size:literal, $align:literal, $llvm:literal, $kind:expr) => {
        PrimitiveInfo {
            name: $name,
            layout: Layout::new($size, $align),
            llvm_name: $llvm,
            kind: $kind,
        }
    };
}
const PRIMITIVE_TYPES_INFO: &[PrimitiveInfo] = &[
    /*0*/ prim!("void", 0, 1, "void", PrimitiveKind::Void),
    /*1*/ prim!("bool", 1, 1, "i1", PrimitiveKind::Bool),
    // SInts
    /*2*/ prim!("i8", 1, 1, "i8", PrimitiveKind::SignedInt),
    /*3*/ prim!("i16", 2, 2, "i16", PrimitiveKind::SignedInt),
    /*4*/ prim!("i32", 4, 4, "i32", PrimitiveKind::SignedInt),
    /*5*/ prim!("i64", 8, 8, "i64", PrimitiveKind::SignedInt),
    /*6*/ prim!("isize", 8, 8, "i64", PrimitiveKind::SignedInt),
    // UInts
    /*7*/ prim!("u8", 1, 1, "i8", PrimitiveKind::UnsignedInt),
    /*8*/ prim!("u16", 2, 2, "i16", PrimitiveKind::UnsignedInt),
    /*9*/ prim!("u32", 4, 4, "i32", PrimitiveKind::UnsignedInt),
    /*A*/ prim!("u64", 8, 8, "i64", PrimitiveKind::UnsignedInt),
    /*B*/ prim!("usize", 8, 8, "i64", PrimitiveKind::UnsignedInt),
    // Decimal
    /*C*/ prim!("f16", 2, 2, "half", PrimitiveKind::Decimal),
    /*D*/ prim!("f32", 4, 4, "float", PrimitiveKind::Decimal),
    /*E*/ prim!("f64", 8, 8, "double", PrimitiveKind::Decimal),
];

pub const VOID_TYPE: &PrimitiveInfo = &PRIMITIVE_TYPES_INFO[0];
pub const BOOL_TYPE: &PrimitiveInfo = &PRIMITIVE_TYPES_INFO[1];
pub const BYTE_TYPE: &PrimitiveInfo = &PRIMITIVE_TYPES_INFO[7];
pub const CHAR_TYPE: &PrimitiveInfo = &PRIMITIVE_TYPES_INFO[2];

pub const DEFAULT_INTEGER_TYPE: &PrimitiveInfo = &PRIMITIVE_TYPES_INFO[4];
pub const DEFAULT_DECIMAL_TYPE: &PrimitiveInfo = &PRIMITIVE_TYPES_INFO[14];

pub const POINTER_SIZED_TYPE: &PrimitiveInfo = &PRIMITIVE_TYPES_INFO[11];

pub fn find_primitive_type(name: &str) -> Option<&'static PrimitiveInfo> {
    PRIMITIVE_TYPES_INFO.iter().find(|p| p.name == name)
}
pub fn find_primitive_type_index(name: &str) -> Option<usize> {
    PRIMITIVE_TYPES_INFO.iter().position(|p| p.name == name)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn all_layouts_valid() {
        for p in PRIMITIVE_TYPES_INFO {
            if p.kind != PrimitiveKind::Void {
                assert!(p.layout.is_valid(), "{} has invalid layout", p.name);
            }
        }
    }

    #[test]
    fn names_are_unique() {
        let mut names: Vec<_> = PRIMITIVE_TYPES_INFO.iter().map(|p| p.name).collect();
        names.dedup();
        assert_eq!(
            names.len(),
            PRIMITIVE_TYPES_INFO.len(),
            "duplicate primitive names"
        );
    }

    #[test]
    fn layout_invalid_sentinel() {
        assert!(!Layout::INVALID.is_valid());
    }

    #[test]
    fn integer_classification() {
        assert!(find_primitive_type("i32").unwrap().is_integer());
        assert!(find_primitive_type("u32").unwrap().is_integer());
        assert!(!find_primitive_type("f32").unwrap().is_integer());
        assert!(!find_primitive_type("bool").unwrap().is_integer());
    }
}
