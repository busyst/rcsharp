use std::iter::Zip;

pub const PATH_SECTION_SEPARATOR: &'static str = ".";
pub type ContextPathDictionaryIter<'a, T> =
    Zip<std::slice::Iter<'a, ContextPathEnd>, std::slice::Iter<'a, T>>;
pub type ContextPathDictionaryIterMut<'a, T> =
    Zip<std::slice::Iter<'a, ContextPathEnd>, std::slice::IterMut<'a, T>>;
#[derive(Debug)]
pub struct ContextPathDictionary<T> {
    keys: Box<[ContextPathEnd]>,
    values: Box<[T]>,
}

impl<T> ContextPathDictionary<T> {
    pub fn get(&self, entry_path: &ContextPathEnd) -> Option<&T> {
        if let Ok(index) = self.keys.binary_search(entry_path) {
            Some(&self.values[index])
        } else {
            None
        }
    }
    pub fn index_of(&self, entry_path: &ContextPathEnd) -> Option<usize> {
        if let Ok(index) = self.keys.binary_search(entry_path) {
            Some(index)
        } else {
            None
        }
    }
    pub fn get_mut(&mut self, entry_path: &ContextPathEnd) -> Option<&mut T> {
        if let Ok(index) = self.keys.binary_search(entry_path) {
            Some(&mut self.values[index])
        } else {
            None
        }
    }
    // Indexes are not valid after insert
    pub fn insert(&mut self, entry_path: &ContextPathEnd, val: T) -> Option<T> {
        match self.keys.binary_search(entry_path) {
            Ok(index) => {
                let mut t = val;
                std::mem::swap(&mut self.values[index], &mut t);
                Some(t)
            }
            Err(index) => {
                let mut k_vec = std::mem::take(&mut self.keys).into_vec();
                let mut v_vec = std::mem::take(&mut self.values).into_vec();

                k_vec.insert(index, entry_path.clone());
                v_vec.insert(index, val);

                self.keys = k_vec.into_boxed_slice();
                self.values = v_vec.into_boxed_slice();
                None
            }
        }
    }
    pub fn iter(&self) -> ContextPathDictionaryIter<'_, T> {
        self.keys.iter().zip(self.values.iter())
    }
    pub fn iter_mut(&mut self) -> ContextPathDictionaryIterMut<'_, T> {
        self.keys.iter().zip(self.values.iter_mut())
    }
    pub fn values(&self) -> std::slice::Iter<'_, T> {
        self.values.iter()
    }

    pub fn len(&self) -> usize {
        self.values.len()
    }
}
impl<T> Default for ContextPathDictionary<T> {
    fn default() -> Self {
        Self {
            keys: Box::new([]),
            values: Box::new([]),
        }
    }
}
#[derive(Debug, Clone, Default, Eq, PartialOrd, Ord)]
pub struct ContextPath {
    path_sections: Box<[Box<str>]>,
}
impl ContextPath {
    pub fn new(path_sections: Box<[Box<str>]>) -> Self {
        Self { path_sections }
    }
    pub fn from_string(path: &str) -> ContextPath {
        if path.is_empty() {
            return Self {
                path_sections: Box::new([]),
            };
        }
        Self {
            path_sections: path
                .split(".")
                .map(|x| x.to_string().into_boxed_str())
                .collect::<Box<_>>(),
        }
    }

    pub fn to_extended(&self, section: &str) -> ContextPath {
        let mut path_sections_vec = self.path_sections.to_vec();
        path_sections_vec.push(section.to_string().into_boxed_str());
        ContextPath {
            path_sections: path_sections_vec.into_boxed_slice(),
        }
    }
    pub fn path_sections(&self) -> &[Box<str>] {
        &self.path_sections
    }

    pub fn is_empty(&self) -> bool {
        self.path_sections.is_empty()
    }
}
impl PartialEq for ContextPath {
    fn eq(&self, other: &Self) -> bool {
        self.path_sections
            .iter()
            .rev()
            .eq(other.path_sections.iter().rev())
    }
}
impl ToString for ContextPath {
    fn to_string(&self) -> String {
        self.path_sections.join(PATH_SECTION_SEPARATOR)
    }
}

#[derive(Debug, Clone, Default, Eq, PartialOrd, Ord)]
pub struct ContextPathEnd {
    context_path: ContextPath,
    name: Box<str>,
}
impl ContextPathEnd {
    pub fn new(context_path: ContextPath, name: Box<str>) -> Self {
        Self { context_path, name }
    }
    pub fn from_path(current_path: &str, name: &str) -> ContextPathEnd {
        Self {
            context_path: ContextPath::from_string(current_path),
            name: name.to_string().into_boxed_str(),
        }
    }
    pub fn from_full_path(fqp: &str) -> ContextPathEnd {
        if fqp.is_empty() {
            return Self::default();
        }
        let path_sections = fqp
            .split(PATH_SECTION_SEPARATOR)
            .map(|x| x.to_string().into_boxed_str())
            .collect::<Vec<_>>();
        Self::from_vec(path_sections)
    }
    pub fn from_context_path(context_path: ContextPath, name: &str) -> ContextPathEnd {
        Self {
            context_path,
            name: name.to_string().into_boxed_str(),
        }
    }

    pub fn from_vec(mut vec: Vec<Box<str>>) -> ContextPathEnd {
        match vec.len() {
            0 => panic!("Moron"),
            1 => Self {
                context_path: ContextPath::default(),
                name: vec[0].clone(),
            },
            _ => {
                let last = vec.remove(vec.len() - 1);
                Self {
                    context_path: ContextPath::new(vec.into_boxed_slice()),
                    name: last,
                }
            }
        }
    }

    pub fn with_start(&self, starting_with: &ContextPath) -> ContextPathEnd {
        if self.context_path.path_sections.is_empty() {
            return ContextPathEnd {
                context_path: starting_with.clone(),
                name: self.name.clone(),
            };
        }
        let mut b = self.context_path.path_sections.to_vec();
        let mut concatedinated = starting_with.path_sections.to_vec();
        concatedinated.append(&mut b);
        return Self {
            context_path: ContextPath::new(concatedinated.into_boxed_slice()),
            name: self.name.clone(),
        };
    }
    pub fn context_path(&self) -> &ContextPath {
        &self.context_path
    }

    pub fn name(&self) -> &str {
        &self.name
    }
}
impl PartialEq for ContextPathEnd {
    fn eq(&self, other: &Self) -> bool {
        self.name == other.name && self.context_path == other.context_path
    }
}
impl ToString for ContextPathEnd {
    fn to_string(&self) -> String {
        if self.context_path.path_sections.is_empty() {
            self.name.to_string()
        } else {
            format!(
                "{}{PATH_SECTION_SEPARATOR}{}",
                self.context_path.path_sections.join(PATH_SECTION_SEPARATOR),
                self.name
            )
        }
    }
}
