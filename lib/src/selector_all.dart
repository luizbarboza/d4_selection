import 'dart:js_interop';

import 'package:web/web.dart';

import 'selection/selection.dart';

List<Element?> _empty(_, [__, ___, ____]) {
  return [];
}

/// Given the specified *selector*, returns a function which returns all
/// descendants of `this` element that match the specified selector.
///
/// This method is used internally by [*selection*.selectAll][]. For example,
/// this:
///
/// [*selection*.selectAll]: /d4_selection/SelectionSelectAll/selectAll.html
///
/// ```dart
/// final div = selection.selectAll("div".u22);
/// ```
///
/// Is equivalent to:
///
/// ```dart
/// final div = selection.selectAll(d4.selectorAll("div").u21);
/// ```
///
/// {@category Selecting elements}
List<Element?> Function(Element, [JSAny?, int?, List<Element?>?]) selectorAll(
    [String? selector]) {
  return selector == null
      ? _empty
      : (thisArg, [data, i, group]) {
          final nodeList =
              PlaceholdableNodeExtension(thisArg).querySelectorAll(selector);
          return [
            for (var i = 0; i < nodeList.length; i++)
              nodeList.item(i) as Element?
          ];
        };
}
