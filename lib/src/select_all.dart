import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:web/web.dart' hide Selection;

import 'list.dart';
import 'selection/selection.dart';

/// Selects all elements that match the specified *selector* string.
///
/// ```dart
/// final p = d4.selectAll("p".u31);
/// ```
///
/// The elements will be selected in document order (top-to-bottom). If no
/// elements in the document match the *selector*, or if the *selector* is null,
/// returns an empty selection.
///
/// If the *selector* is not a string, instead selects the specified list of
/// nodes; this is useful if you already have a reference to nodes, such as
/// `this.childNodes` within an event listener or a global such as
/// `document.links`. The nodes may instead be an iterable, or a pseudo-array
/// such as a NodeList. For example, to color all links red:
///
/// ```dart
/// d4.selectAll(document.links.u33).styleSet("color", "red".u22);
/// ```
///
/// {@category Selecting elements}
Selection selectAll([Union3<String, Iterable<Element?>, Object>? selector]) {
  return selector == null
      ? createSelection([[]], root)
      : selector.split(
          (selector) => createSelection(
              [list(document.querySelectorAll(selector).u22)],
              [document.documentElement]),
          (iterable) => createSelection([list(iterable.u21)], root),
          (object) => createSelection([list(object.u22)], root),
        );
}
