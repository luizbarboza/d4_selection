part of 'selection.dart';

EachCallback<List<Element?>> listAll(EachCallback<Iterable<Element?>> select) {
  return (thisArg, data, i, group) {
    return select(thisArg, data, i, group).toList();
  };
}

/// {@category Selecting elements}
extension SelectionSelectAll on Selection {
  /// For each selected element, selects the descendant elements that match the
  /// specified *selector* string.
  ///
  /// ```dart
  /// final b = d4.selectAll("p".u31).selectAll("b".u22); // every <b> in every <p>
  /// ```
  ///
  /// The elements in the returned selection are grouped by their corresponding
  /// parent node in this selection. If no element matches the specified
  /// selector for the current element, or if the *selector* is null, the group
  /// at the current index will be empty. The selected elements do not inherit
  /// data from this selection; use [*selection*.dataBind][] to propagate data
  /// to children.
  ///
  /// [*selection*.dataBind]: https://pub.dev/documentation/d4_selection/latest/d4_selection/SelectionData/dataBind.html
  ///
  /// If the *selector* is a function, it is evaluated for each selected
  /// element, in order, being passed the current datum (*d*), the current index
  /// (*i*), and the current group (*nodes*), with *this* as the current DOM
  /// element (*nodes*\[*i*\]). It must return an list of elements (or an
  /// iterable, or a pseudo-array such as a NodeList), or the empty list if
  /// there are no matching elements. For example, to select the previous and
  /// next siblings of each paragraph:
  ///
  /// ```dart
  /// final sibling = d4.selectAll("p".u31).selectAll(
  ///   (Element thisArg, JSAny? d, int i, List<Element?> nodes) {
  ///     return [thisArg.previousElementSibling, thisArg.nextElementSibling];
  ///   }.u21,
  /// );
  /// ```
  ///
  /// Unlike [*selection*.select][], *selection*.selectAll does affect grouping:
  /// each selected descendant is grouped by the parent element in the
  /// originating selection. Grouping plays an important role in the
  /// [data join][]. See [Nested Selections][] and [How Selections Work][] for
  /// more on this topic.
  ///
  /// [*selection*.select]: https://pub.dev/documentation/d4_selection/latest/d4_selection/SelectionSelect/select.html
  /// [data join]: https://pub.dev/documentation/d4_selection/latest/topics/Joining%20data-topic.html
  /// [Nested Selections]: http://bost.ocks.org/mike/nest/
  /// [How Selections Work]: http://bost.ocks.org/mike/selection/
  Selection selectAll(
      [Union2<EachCallback<Iterable<Element?>>, String>? selector]) {
    var select = selector?.split(
          (select) => listAll(select),
          (selector) => g.selectorAll(selector),
        ) ??
        g.selectorAll(null);

    List<List<Element?>> subgroups = [];
    List<Element?> parents = [];
    for (var groups = _groups, m = groups.length, j = 0; j < m; ++j) {
      Element? node;
      for (var group = groups[j], n = group.length, i = 0; i < n; ++i) {
        if ((node = group[i]) != null) {
          subgroups
              .add(select(node!, (node as JSObject)["__data__"], i, group));
          parents.add(node);
        }
      }
    }

    return Selection._(subgroups, parents);
  }
}
