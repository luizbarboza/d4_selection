part of 'selection.dart';

///{@category Selecting elements}
extension SelectionFilter on Selection {
  /// Filters the selection, returning a new selection that contains only the
  /// elements for which the specified *filter* is true.
  ///
  /// For example, to filter a selection of table rows to contain only even
  /// rows:
  ///
  /// ```dart
  /// final even = d4.selectAll("tr".u31).filter(":nth-child(even)".u22);
  /// ```
  ///
  /// This is approximately equivalent to using [d4.selectAll][] directly,
  /// although the indexes may be different:
  ///
  /// [d4.selectAll]: /d4_selection/selectAll.html
  ///
  /// ```dart
  /// final even = d4.selectAll("tr:nth-child(even)".u31);
  /// ```
  ///
  /// The *filter* may be specified either as a selector string or a function.
  /// If the *filter* is a function, it is evaluated for each selected element,
  /// in order, being passed the current datum (*d*), the current index (*i*),
  /// and the current group (*nodes*), with *thisArg* as the current DOM element
  /// (*nodes*\[*i*\]). Using a function:
  ///
  /// ```dart
  /// final even = d4.selectAll("tr".u31).filter(
  ///   (Element thisArg, JSAny? d, int i, List<Element?> nodes) {
  ///     return i.isOdd;
  ///   }.u21,
  /// );
  /// ```
  ///
  /// Or using [*selection*.select][]:
  ///
  /// [*selection*.select]: /d4_selection/SelectionSelect/select.html
  ///
  /// ```dart
  /// final even = d4.selectAll("tr".u31).select(
  ///   (Element thisArg, JSAny? d, int i, List<Element?> nodes) {
  ///     return i.isOdd ? thisArg : null;
  ///   }.u21,
  /// );
  /// ```
  ///
  /// Note that the `:nth-child` pseudo-class is a one-based index rather than a
  /// zero-based index. Also, the above filter functions do not have precisely
  /// the same meaning as `:nth-child`; they rely on the selection index rather
  /// than the number of preceding sibling elements in the DOM.
  ///
  /// The returned filtered selection preserves the parents of this selection,
  /// but like [*array*.filter][], it does not preserve indexes as some elements
  /// may be removed; use [*selection*.select][] to preserve the index, if
  /// needed.
  ///
  /// [*array*.filter]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/filter
  /// [*selection*.select]: /d4_selection/SelectionSelect/select.html
  Selection filter(Union2<EachCallback<bool>, String> filter) {
    var match = filter.split(
      (filter) => filter,
      (selector) => g.matcher(selector),
    );

    final groups = _groups,
        m = groups.length,
        subgroups = List<List<Element?>>.filled(m, []);
    for (var j = 0; j < m; ++j) {
      Element? node;
      for (var group = groups[j],
              n = group.length,
              subgroup = subgroups[j] = [],
              i = 0;
          i < n;
          ++i) {
        if ((node = group[i]) != null &&
            match(node!, (node as JSObject)["__data__"], i, group)) {
          subgroup.add(node);
        }
      }
    }

    return Selection._(subgroups, _parents);
  }
}
