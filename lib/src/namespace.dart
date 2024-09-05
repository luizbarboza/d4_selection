import 'package:extension_type_unions/extension_type_unions.dart';

import 'namespaces.dart';

/// Qualifies the specified *name*, which may or may not have a namespace
/// prefix.
///
/// ```dart
/// d4.namespace("svg:text"); // {"space": "http://www.w3.org/2000/svg", "local": "text"}
/// ```
///
/// If the name contains a colon (`:`), the substring before the colon is
/// interpreted as the namespace prefix, which must be registered in
/// [d4.namespaces][]. Returns an object `space` and `local` attributes
/// describing the full namespace URL and the local name. If the name does not
/// contain a colon, this function merely returns the input name.
///
/// [d4.namespaces]: https://pub.dev/documentation/d4_selection/latest/d4_selection/namespaces.html
///
/// {@category Namespaces}
Union2<Map<String, String>, String> namespace(String name) {
  var prefix = name, i = prefix.indexOf(":");
  if (i >= 0 && (prefix = name.substring(0, i)) != "xmlns") {
    name = name.substring(i + 1);
  }
  return namespaces.containsKey(prefix)
      ? {"space": namespaces[prefix]!, "local": name}.u21
      : name.u22;
}
