part of 'selection.dart';

/// {@category Control flow}
extension SelectionNode on Selection {
  /// Returns the first (non-null) element in this selection. If the selection
  /// is empty, returns null.
  Element? node() {
    for (var groups = _groups, j = 0, m = groups.length; j < m; ++j) {
      for (var group = groups[j], i = 0, n = group.length; i < n; ++i) {
        var node = group[i];
        if (node != null) return node;
      }
    }

    return null;
  }
}
