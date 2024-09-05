part of 'selection.dart';

/// {@category Control flow}
extension SelectionSize on Selection {
  /// Returns the total number of (non-null) elements in this selection.
  int size() {
    var size = 0;
    // ignore: unused_local_variable
    for (final node in this) {
      ++size;
    }
    return size;
  }
}
