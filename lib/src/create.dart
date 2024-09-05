import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:web/web.dart' hide Selection;

import 'creator.dart';
import 'select.dart';
import 'selection/selection.dart';

/// Given the specified element *name*, returns a single-element selection
/// containing a detached element of the given name in the current document.
///
/// ```dart
/// d4.create("svg"); // equivalent to svg:svg
/// ```
/// ```dart
/// d4.create("svg:svg"); // more explicitly
/// ```
/// ```dart
/// d4.create("svg:g"); // an SVG G element
/// ```
/// ```dart
/// d4.create("g"); // an HTML G (unknown) element
/// ```
///
/// This method assumes the HTML namespace, so you must specify a namespace
/// explicitly when creating SVG or other non-HTML elements; see [namespace][]
/// for details on supported namespace prefixes.
///
/// [namespace]: https://pub.dev/documentation/d4_selection/latest/d4_selection/namespace.html
///
/// {@category Modifying elements}
Selection create(String name) {
  return select(creator(name)(document.documentElement!).u22);
}
