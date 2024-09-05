part of 'selection.dart';

void _raise(Element thisArg, JSAny? data, int i, List<Element?> group) {
  if (thisArg.nextSibling != null) thisArg.parentNode!.appendChild(thisArg);
}

/// {@category Modifying elements}
extension SelectionRaise on Selection {
  /// Re-inserts each selected element, in order, as the last child of its
  /// parent.
  ///
  /// Equivalent to:
  ///
  /// ```dart
  /// selection.each((Element thisArg, JSAny? d, int i, List<Element?> nodes) {
  ///   thisArg.parentNode!.appendChild(thisArg);
  /// });
  /// ```
  Selection raise() {
    return each(_raise);
  }
}
