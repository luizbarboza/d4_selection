part of 'selection.dart';

EachCallback<Element?> childFind(
    bool Function(Element, int, HTMLCollection) match) {
  return (thisArg, data, i, group) {
    final children = thisArg.children;
    for (var i = 0; i < children.length; i++) {
      final item = children.item(i)!;
      if (match(item, i, children)) return item;
    }
    return null;
  };
}

Element? childFirst(Element thisArg, JSAny? data, int i, List<Element?> group) {
  return thisArg.firstElementChild;
}

/// {@category Selecting elements}
extension SelectionSelectChild on Selection {
  /// Returns a new selection with the (first) child of each element of the
  /// current selection matching the *selector*.
  ///
  /// ```dart
  /// d4.selectAll("p".u31).selectChild("b".u22); // the first <b> child of every <p>
  /// ```
  ///
  /// If no *selector* is specified, selects the first child (if any). If the
  /// *selector* is specified as a string, selects the first child that matches
  /// (if any). If the *selector* is a function, it is evaluated for each of the
  /// children nodes, in order, being passed the child (*child*), the child’s
  /// index (*i*), and the list of children (*children*); the method selects the
  /// first child for which the selector return truthy, if any.
  ///
  /// > [!CAUTION]
  /// > *selection*.selectChild propagates the parent’s data to the selected
  /// child.
  Selection selectChild(
      [Union2<bool Function(Element, int, HTMLCollection), String>? selector]) {
    return select(
      selector?.split(
            (match) => childFind(match).u21,
            (selector) => childFind(g.childMatcher(selector)).u21,
          ) ??
          childFirst.u21,
    );
  }
}
