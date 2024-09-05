part of 'selection.dart';

/// {@category Control flow}
extension SelectionEmpty on Selection {
  /// Returns true if this selection contains no (non-null) elements.
  ///
  /// ```dart
  /// d4.selectAll("p".u31).empty(); // false, here
  /// ```
  bool empty() {
    return node() == null;
  }
}
