part of 'selection.dart';

/// {@category Selecting elements}
extension SelectionSelect on Selection {
  /// For each selected element, selects the first descendant element that
  /// matches the specified *selector* string.
  ///
  /// ```dart
  /// final b = d4.selectAll("p".u31).select("b".u22); // the first <b> in every <p>
  /// ```
  ///
  /// If no element matches the specified selector for the current element, the
  /// element at the current index will be null in the returned selection. (If
  /// the *selector* is null, every element in the returned selection will be
  /// null, resulting in an empty selection.) If the current element has
  /// associated data, this data is propagated to the corresponding selected
  /// element. If multiple elements match the selector, only the first matching
  /// element in document order is selected.
  ///
  /// If the *selector* is a function, it is evaluated for each selected
  /// element, in order, being passed the current datum (*d*), the current index
  /// (*i*), and the current group (*nodes*), with *thisArg* as the current DOM
  /// element (*nodes*\[*i*\]). It must return an element, or null if there is
  /// no matching element. For example, to select the previous sibling of each
  /// paragraph:
  ///
  /// ```dart
  /// final previous = d4.selectAll("p".u31).select(
  ///   (Element thisArg, JSAny? d, int i, List<Element?> nodes) {
  ///     return thisArg.previousElementSibling;
  ///   }.u21,
  /// );
  /// ```
  ///
  /// Unlike [*selection*.selectAll][], *selection*.select does not affect
  /// grouping: it preserves the existing group structure and indexes, and
  /// propagates data (if any) to selected children. Grouping plays an important
  /// role in the [data join][]. See [Nested Selections][] and
  /// [How Selections Work][] for more on this topic.
  ///
  /// [*selection*.selectAll]: https://pub.dev/documentation/d4_selection/latest/d4_selection/SelectionSelectAll/selectAll.html
  /// [data join]: https://pub.dev/documentation/d4_selection/latest/topics/Joining%20data-topic.html
  /// [Nested Selections]: http://bost.ocks.org/mike/nest/
  /// [How Selections Work]: http://bost.ocks.org/mike/selection/
  ///
  /// > [!CAUTION]
  /// > *selection*.select propagates the parent’s data to the selected child.
  Selection select([Union2<EachCallback<Element?>, String>? selector]) {
    var select = selector?.split(
          (select) => select,
          (selector) => g.selector(selector),
        ) ??
        g.selector(null);

    var groups = _groups,
        m = groups.length,
        subgroups = List<List<Element?>>.filled(m, []);
    for (var j = 0; j < m; ++j) {
      Element? node, subnode;
      for (var group = groups[j],
              n = group.length,
              subgroup = subgroups[j] = List.filled(n, null),
              i = 0;
          i < n;
          ++i) {
        if ((node = group.elementAtOrNull(i)) != null &&
            (subnode =
                    select(node!, (node as JSObject)["__data__"], i, group)) !=
                null) {
          if ((node as JSObject).has("__data__")) {
            (subnode as JSObject)["__data__"] = (node as JSObject)["__data__"];
          }
          subgroup[i] = subnode;
        }
      }
    }

    return Selection._(subgroups, _parents);
  }
}
