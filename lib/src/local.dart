import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:web/web.dart';

var _nextId = 0;

/// D4 locals allow you to define local state independent of data.
///
/// For instance, when rendering [small multiples][] of time-series data, you
/// might want the same x scale for all charts but distinct y scales to compare
/// the relative performance of each metric. D4 locals are scoped by DOM
/// elements: on set, the value is stored on the given element; on get, the
/// value is retrieved from given element or the nearest ancestor that defines
/// it.
///
/// [small multiples]: https://gist.github.com/mbostock/e1192fe405703d8321a5187350910e08
///
/// > [!CAUTION]
/// > Locals are rarely used; you may find it easier to store whatever state you
/// > need in the selection’s data.
///
/// {@category Local variables}
class Local {
  final String _;

  /// Declares a new local variable.
  ///
  /// ```dart
  /// final foo = Local();
  /// ```
  ///
  /// Like `var`, each local is a distinct symbolic reference; unlike `var`, the
  /// value of each local is also scoped by the DOM.
  Local() : _ = "@${(++_nextId).toRadixString(36)}";

  /// Returns the value of this local on the specified *node*.
  ///
  /// ```dart
  /// selection.each((Element thisArg, JSAny? d, int i, List<Element?> nodes) {
  ///   final value = foo.get(thisArg);
  /// });
  /// ```
  ///
  /// If the *node* does not define this local, returns the value from the
  /// nearest ancestor that defines it. Returns null if no ancestor defines
  /// his local.
  JSAny? get(Node node) {
    var id = _;
    Node? node0 = node;
    while (!(node0 as JSObject).hasProperty(id.toJS).toDart) {
      if ((node0 = node.parentNode) == null) {
        return null;
      }
    }
    return (node0 as JSObject)[id];
  }

  /// Sets the value of this local on the specified *node* to the *value*, and
  /// returns the specified *value*. This is often performed using
  /// [*selection*.each][]:
  ///
  /// [*selection*.each]: /d4_selection/SelectionEach/each.html
  ///
  /// ```dart
  /// selection.each((Element thisArg, JSAny? d, int i, List<Element?> nodes) {
  ///   foo.set(thisArg, (d as JSBoxedDartObject)["value"]);
  /// });
  /// ```
  ///
  /// If you are just setting a single variable, consider using
  /// [*selection*.propertySet][]:
  ///
  /// [*selection*.propertySet]: /d4_selection/SelectionProperty/propertySet.html
  ///
  /// ```dart
  /// selection.propertySet(
  ///   foo.toString(),
  ///   (Element thisArg, JSAny? d, int i, List<Element?> nodes) {
  ///     return (d as JSBoxedDartObject)["value"];
  ///   }.u21,
  /// );
  /// ```
  JSAny? set(Node node, JSAny? value) {
    return (node as JSObject)[_] = value;
  }

  /// Deletes this local’s value from the specified *node*.
  ///
  /// ```dart
  /// selection.each((Element thisArg, JSAny? d, int i, List<Element?> nodes) {
  ///   foo.remove(thisArg);
  /// });
  /// ```
  ///
  /// Returns true if the *node* defined this local prior to removal, and false
  /// otherwise. If ancestors also define this local, those definitions are
  /// unaffected, and thus [*local*.get][] will still return the inherited
  /// value.
  ///
  /// [*local*.get]: /d4_selection/Local/get.html
  bool remove(Node node) {
    return (node as JSObject).delete(_.toJS).toDart;
  }

  /// Returns the automatically-generated identifier for this local.
  ///
  /// This is the name of the property that is used to store the local’s value
  /// on elements, and thus you can also set or get the local’s value using
  /// *element*\[*local*.toString()\] or by using [*selection*.propertySet][].
  ///
  /// [*selection*.propertySet]: /d4_selection/SelectionProperty/propertySet.html
  @override
  String toString() {
    return _;
  }
}
