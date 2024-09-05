import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:math';

import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:web/web.dart';

import '../constant.dart';
import '../creator.dart' as g;
import '../matcher.dart' as g;
import '../namespace.dart' as g;
import '../selector.dart' as g;
import '../selector_all.dart' as g;
import '../window.dart' as g;

part 'append.dart';
part 'attr.dart';
part 'call.dart';
part 'classed.dart';
part 'clone.dart';
part 'data.dart';
part 'datum.dart';
part 'dispatch.dart';
part 'each.dart';
part 'empty.dart';
part 'enter.dart';
part 'exit.dart';
part 'filter.dart';
part 'html.dart';
part 'insert.dart';
part 'iterator.dart';
part 'join.dart';
part 'lower.dart';
part 'merge.dart';
part 'node.dart';
part 'nodes.dart';
part 'on.dart';
part 'order.dart';
part 'property.dart';
part 'raise.dart';
part 'remove.dart';
part 'select.dart';
part 'select_all.dart';
part 'select_child.dart';
part 'select_children.dart';
part 'size.dart';
part 'sort.dart';
part 'sparse.dart';
part 'style.dart';
part 'text.dart';

var root = <Element?>[null];

class Selection with Iterable<Element?> {
  final List<List<Element?>> _groups;
  final List<Element?> _parents;
  List<List<Element?>>? _enter;
  List<List<Element?>>? _exit;

  Selection._(this._groups, this._parents);

  @override
  get iterator => SelectionIterator(this).iterator;
}

/// {@category Selecting elements}
extension SelectionSelection on Selection {
  /// Returns the selection (for symmetry with *transition*.selection).
  Selection selection() => this;
}

/// [Selects][] the root element, `document.documentElement`.]
///
/// [Selects]: ./select.html
///
/// ```dart
/// final root = d4.selection();
/// ```
///
/// {@category Selecting elements}
Selection selection() {
  return Selection._([
    [document.documentElement]
  ], root);
}

Selection createSelection(List<List<Element?>> groups, List<Element?> parents) {
  return Selection._(groups, parents);
}

extension SelectionExposed on Selection {
  List<List<Element?>> get groups => _groups;
  List<Element?> get parents => _parents;
  List<List<Element?>>? get enterr => _enter;
  List<List<Element?>>? get exitt => _exit;
}
