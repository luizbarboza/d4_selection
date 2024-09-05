part of 'selection.dart';

void _lower(Element thisArg, JSAny? data, int i, List<Element?> group) {
  if (thisArg.previousElementSibling != null) {
    thisArg.parentNode!.insertBefore(thisArg, thisArg.parentNode?.firstChild);
  }
}

/// {@category Modifying elements}
extension SelectionLower on Selection {
  /// Re-inserts each selected element, in order, as the first child of its
  /// parent. Equivalent to:
  ///
  /// ```dart
  /// selection.each((Element thisArg, JSAny? d, int i, List<Element?> nodes) {
  ///   thisArg.parentNode!.insertBefore(thisArg, thisArg.parentNode!.firstChild);
  /// });
  /// ```
  Selection lower() {
    return each(_lower);
  }
}
