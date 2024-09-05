import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:web/web.dart' hide Selection;

import 'selection/selection.dart';

/// Selects the first element that matches the specified *selector* string.
///
/// ```dart
/// final svg = d4.select("#chart".u21);
/// ```
///
/// If no elements match the *selector*, returns an empty selection. If multiple
/// elements match the *selector*, only the first matching element (in document
/// order) will be selected. For example, to select the first anchor element:
///
/// ```dart
/// final anchor = d4.select("a".u21);
/// ```
///
/// If the *selector* is not a string, instead selects the specified node; this
/// is useful if you already have a reference to a node, such as
/// `document.body`.
///
/// ```dart
/// d4.select(document.body!.u22).styleSet("background", "red".u22);
/// ```
///
/// Or, to make a clicked paragraph red:
///
/// ```dart
/// d4.selectAll("p".u31)
///     .onBind(
///       "click",
///       (thisARg, event, d) => d4.select(
///         (event.currentTarget as Element).u22,
///       ),
///     )
///     .styleSet("color", "red".u22);
/// ```
///
/// {@category Selecting elements}
Selection select([Union2<String, Element>? selector]) {
  return selector == null
      ? createSelection([
          [null]
        ], root)
      : selector.split(
          (selector) => createSelection([
            [document.querySelector(selector)]
          ], [
            document.documentElement
          ]),
          (node) => createSelection([
            [node]
          ], root),
        );
}
