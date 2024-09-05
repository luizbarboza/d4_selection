part of 'selection.dart';

/// {@category Joining data}
extension SelectionMerge on Selection {
  /// Returns a new selection merging this selection with the specified *other*
  /// selection or transition.
  ///
  /// The returned selection has the same number of groups and the same parents
  /// as this selection. Any missing (null) elements in this selection are
  /// filled with the corresponding element, if present (not null), from the
  /// specified *selection*. (If the *other* selection has additional groups or
  /// parents, they are ignored.)
  ///
  /// This method is used internally by [*selection*.joind][] to merge the
  /// [enter][] and [update][] selections after binding data. You can also merge
  /// explicitly, although note that since merging is based on element index,
  /// you should use operations that preserve index, such as
  /// [*selection*.select][] instead of [*selection*.filter][]. For example:
  ///
  /// [*selection*.joind]: /d4_selection/SelectionJoin/joind.html
  /// [enter]: /d4_selection/SelectionEnter/enter.html
  /// [update]: /d4_selection/SelectionData/dataBind.html
  /// [*selection*.select]: /d4_selection/SelectionSelect/select.html
  /// [*selection*.filter]: /d4_selection/SelectionFilter/filter.html
  ///
  /// ```dart
  /// final odd = selection
  ///     .select((Element thisArg, JSAny? d, int i, List<Element?> nodes) {
  ///   return i.isOdd ? thisArg : null;
  /// }.u21);
  /// final even = selection
  ///     .select((Element thisArg, JSAny? d, int i, List<Element?> nodes) {
  ///   return i.isOdd ? null : thisArg;
  /// }.u21);
  /// final merged = odd.merge(even);
  /// ```
  ///
  /// See [*selection*.dataBind][] for more.
  ///
  /// [*selection*.dataBind]: /d4_selection/SelectionData/dataBind.html
  ///
  /// This method is not intended for concatenating arbitrary selections,
  /// however: if both this selection and the specified *other* selection have
  /// (non-null) elements at the same index, this selection’s element is
  /// returned in the merge and the *other* selection’s element is ignored.
  Selection merge(Selection other) {
    var selection = other.selection(),
        groups0 = _groups,
        m0 = groups0.length,
        merges = List<List<Element?>>.filled(m0, []),
        j = 0;
    for (var groups1 = selection._groups, m1 = groups1.length, m = min(m0, m1);
        j < m;
        ++j) {
      Element? node;
      for (var group0 = groups0[j],
              group1 = groups1[j],
              n = group0.length,
              merge = merges[j] = List<Element?>.filled(n, null),
              i = 0;
          i < n;
          ++i) {
        if ((node = group0[i] ?? group1[i]) != null) {
          merge[i] = node;
        }
      }
    }

    for (; j < m0; ++j) {
      merges[j] = groups0[j];
    }

    return Selection._(merges, _parents);
  }
}
