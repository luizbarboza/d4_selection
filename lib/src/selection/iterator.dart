part of 'selection.dart';

/// {@category Control flow}
extension SelectionIterator on Selection {
  /// Returns an iterator over the selected (non-null) elements.
  ///
  /// For example, to iterate over the selected elements:
  ///
  /// ```dart
  /// for (final element in selection) {
  ///   print(element);
  /// }
  /// ```
  ///
  /// To flatten the selection to an list:
  ///
  /// ```dart
  /// final elements = [...selection];
  /// ```
  Iterator<Element> get iterator =>
      _groups.expand((g) => g.where((e) => e != null).cast<Element>()).iterator;
}
