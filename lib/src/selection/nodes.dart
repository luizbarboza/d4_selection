part of 'selection.dart';

/// {@category Control flow}
extension SelectionNodes on Selection {
  /// Returns an list of all (non-null) elements in this selection.
  ///
  /// ```dart
  /// d4.selectAll("p".u31).nodes(); // [p, p, p, …]
  /// ```
  ///
  /// Equivalent to:
  ///
  /// ```dart
  /// selection.toList()
  /// ```
  List<Element?> nodes() {
    return toList();
  }
}
