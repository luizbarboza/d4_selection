import 'dart:js_interop';

import 'package:web/web.dart';

/// Given the specified *selector*, returns a function which returns true if
/// `this` element [matches][] the specified selector.
///
/// [matches]: https://developer.mozilla.org/en-US/docs/Web/API/Element/matches
///
/// This method is used internally by [*selection*.filter][]. For example, this:
///
/// [*selection*.filter]: https://pub.dev/documentation/d4_selection/latest/d4_selection/SelectionFilter/filter.html
///
/// ```dart
/// final div = selection.filter("div".u22);
/// ```
///
/// Is equivalent to:
///
/// ```dart
/// final div = selection.filter(d4.matcher("div"));
/// ```
///
/// (Although D4 is not a compatibility layer, this implementation does support
/// vendor-prefixed implementations due to the recent standardization of
/// *element*.matches.)
///
/// {@category Selecting elements}
bool Function(Element, [JSAny?, int?, List<Element?>?]) matcher(
    String selector) {
  return (Element thisArg, [_, __, ___]) {
    return thisArg.matches(selector);
  };
}

bool Function(Element, int, HTMLCollection) childMatcher(String selector) {
  return (Element node, _, __) {
    return node.matches(selector);
  };
}
