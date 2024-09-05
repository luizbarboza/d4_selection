final xhtml = "http://www.w3.org/1999/xhtml";

/// The map of registered namespace prefixes. The initial value is:
///
/// ```dart
/// {
///   "svg": "http://www.w3.org/2000/svg",
///   "xhtml": "http://www.w3.org/1999/xhtml",
///   "xlink": "http://www.w3.org/1999/xlink",
///   "xml": "http://www.w3.org/XML/1998/namespace",
///   "xmlns": "http://www.w3.org/2000/xmlns/"
/// };
/// ```
///
/// Additional prefixes may be assigned as needed to create elements or
/// attributes in other namespaces.
///
/// {@category Namespaces}
final namespaces = {
  "svg": "http://www.w3.org/2000/svg",
  "xhtml": xhtml,
  "xlink": "http://www.w3.org/1999/xlink",
  "xml": "http://www.w3.org/XML/1998/namespace",
  "xmlns": "http://www.w3.org/2000/xmlns/",
};
