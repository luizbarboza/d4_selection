part of 'selection.dart';

Element cloneShallow(Element thisArg, JSAny? _, int __, List<Element?> ___) {
  var clone = thisArg.cloneNode(false) as Element, parent = thisArg.parentNode;
  return parent != null
      ? parent.insertBefore(clone, thisArg.nextSibling) as Element
      : clone;
}

Element cloneDeep(Element thisArg, JSAny? _, int __, List<Element?> ___) {
  var clone = thisArg.cloneNode(true) as Element, parent = thisArg.parentNode;
  return parent != null
      ? parent.insertBefore(clone, thisArg.nextSibling) as Element
      : clone;
}

/// {@category Modifying elements}
extension SelectionClone on Selection {
  /// Inserts clones of the selected elements immediately following the selected
  /// elements and returns a selection of the newly added clones.
  ///
  /// If *deep* is truthy, the descendant nodes of the selected elements will be
  /// cloned as well. Otherwise, only the elements themselves will be cloned.
  /// Equivalent to:
  ///
  /// ```dart
  /// selection.select((Element thisArg, JSAny? d, int i, List<Element?> nodes) {
  ///   return (thisArg.parentNode!
  ///       .insertBefore(thisArg.cloneNode(deep), thisArg.nextSibling) as Element);
  /// }.u21);
  /// ```
  Selection clone(bool deep) {
    return select((deep ? cloneDeep : cloneShallow).u21);
  }
}
