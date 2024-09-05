import 'dart:js_interop';
import 'package:web/web.dart';

import 'selection/selection.dart';

// ignore: prefer_void_to_null
Null _none(_, [__, ___, ____]) => null;

/// Given the specified *selector*, returns a function which returns the first
/// descendant of `this` element that matches the specified selector.
///
/// This method is used internally by [*selection*.select][]. For example, this:
///
/// [*selection*.select]: /d4_selection/SelectionSelect/select.html
///
/// ```dart
/// final div = selection.select("div".u22);
/// ```
///
/// Is equivalent to:
///
/// ```dart
/// final div = selection.select(d4.selector("div").u21);
/// ```
///
/// {@category Selecting elements}
Element? Function(Element, [JSAny?, int?, List<Element?>?]) selector(
    [String? selector]) {
  return selector == null
      ? _none
      : (thisArg, [data, i, group]) {
          return PlaceholdableNodeExtension(thisArg).querySelector(selector);
        };
}
