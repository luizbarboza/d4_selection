part of 'selection.dart';

/// {@category Modifying elements}
extension SelectionOrder on Selection {
  /// Re-inserts elements into the document such that the document order of each
  /// group matches the selection order.
  ///
  /// This is equivalent to calling [*selection*.sort][] if the data is already
  /// sorted, but much faster.
  ///
  /// [*selection*.sort]: https://pub.dev/documentation/d4_selection/latest/d4_selection/SelectionSort/sort.html
  Selection order() {
    for (var groups = _groups, j = -1, m = groups.length; ++j < m;) {
      Element? node;
      for (var group = groups[j], i = group.length - 1, next = group[i];
          --i >= 0;) {
        if ((node = group[i]) != null) {
          if (next != null && (node!.compareDocumentPosition(next) ^ 4) != 0) {
            next.parentNode!.insertBefore(node, next);
          }
          next = node;
        }
      }
    }
    return this;
  }
}
