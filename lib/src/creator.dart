import 'dart:js_interop';

import 'package:web/web.dart';

import 'namespace.dart';
import 'namespaces.dart';

Element Function(Element, [JSAny?, int?, List<Element?>?]) _creatorInherit(
    String name) {
  return (thisArg, [_, __, ___]) {
    var document = thisArg.ownerDocument!, uri = thisArg.namespaceURI!;
    return uri == xhtml && document.documentElement!.namespaceURI == xhtml
        ? document.createElement(name)
        : document.createElementNS(uri, name);
  };
}

Element Function(Element, [JSAny?, int?, List<Element?>?]) _creatorFixed(
    Map<String, String> fullname) {
  return (thisArg, [_, __, ___]) {
    return thisArg.ownerDocument!
        .createElementNS(fullname["space"], fullname["local"]!);
  };
}

/// Given the specified element *name*, returns a function which creates an
/// element of the given name, assuming that `thisArg` is the parent element.
///
/// This method is used internally by [*selection*.append][] and
/// [*selection*.insert][] to create new elements. For example, this:
///
/// [*selection*.append]: /d4_selection/SelectionAppend/append.html
/// [*selection*.insert]: /d4_selection/SelectionInsert/insert.html
///
/// ```dart
/// selection.append("div".u22);
/// ```
///
/// Is equivalent to:
///
/// ```dart
/// selection.append(d4.creator("div").u21);
/// ```
///
/// See [namespace][] for details on supported namespace prefixes, such as for
/// SVG elements.
///
/// [namespace]: /d4_selection/namespace.html
///
/// {@category Modifying elements}
Element Function(Element, [JSAny?, int?, List<Element?>?]) creator(
    String name) {
  var fullname = namespace(name);
  return fullname.split(
    (fullname) => _creatorFixed(fullname),
    (name) => _creatorInherit(name),
  );
}
