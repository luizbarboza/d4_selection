part of 'selection.dart';

/// {@category Control flow}
extension SelectionEach on Selection {
  /// Invokes the specified *function* for each selected element, in order,
  /// being passed the current datum (*d*), the current index (*i*), and the
  /// current group (*nodes*), with *thisArg* as the current DOM element
  /// (*nodes*\[*i*\]).
  ///
  /// This method can be used to invoke arbitrary code for each selected
  /// element, and is useful for creating a context to access parent and child
  /// data simultaneously, such as:
  ///
  /// ```dart
  /// parent.each((Element thisArg, JSAny? p, int j, List<Element?> nodes) {
  ///   d4.select(thisArg.u22).selectAll(".child".u22).textSet(
  ///         (Element thisArg, JSAny? d, int i, List<Element?> nodes) {
  ///           return "child ${(d as JSBoxedDartObject)["name"]} of ${(p as JSBoxedDartObject)["name"]}";
  ///         }.u21,
  ///       );
  /// });
  /// ```
  ///
  /// See [sized donut multiples][] for an example.
  ///
  /// [sized donut multiples]: https://observablehq.com/@d3/sized-donut-multiples
  Selection each(EachCallback<void> function) {
    for (var groups = _groups, j = 0, m = groups.length; j < m; ++j) {
      Element? node;
      for (var group = groups[j], i = 0, n = group.length; i < n; ++i) {
        if ((node = group[i]) != null) {
          function(node!, (node as JSObject)["__data__"], i, group);
        }
      }
    }
    return this;
  }
}

typedef EachCallback<T> = T Function(Element, JSAny?, int, List<Element?>);
