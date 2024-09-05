part of 'selection.dart';

List<Element?> children(
    Element thisArg, JSAny? data, int i, List<Element?> group) {
  final children = thisArg.children;
  final childrenList = <Element?>[];
  for (var i = 0; i < children.length; i++) {
    childrenList.add(children.item(i));
  }
  return childrenList;
}

EachCallback<List<Element?>> childrenFilter(
    bool Function(Element, int, HTMLCollection) match) {
  return (thisArg, _, __, ___) {
    final children = thisArg.children;
    final childrenList = <Element?>[];
    for (var i = 0; i < children.length; i++) {
      final item = children.item(i)!;
      if (match(item, i, children)) childrenList.add(item);
    }
    return childrenList;
  };
}

/// {@category Selecting elements}
extension SelectionSelectChildren on Selection {
  /// Returns a new selection with the children of each element of the current
  /// selection matching the *selector*.
  ///
  /// If no *selector* is specified, selects all the children. If the *selector*
  /// is specified as a string, selects the children that match (if any). If the
  /// *selector* is a function, it is evaluated for each of the children nodes,
  /// in order, being passed the child (*child*), the child’s index (*i*), and
  /// the list of children (*children*); the method selects all children for
  /// which the selector return truthy.
  Selection selectChildren(
      [Union2<bool Function(Element, int, HTMLCollection), String>? selector]) {
    return selectAll(
      (selector?.split(
                (match) => childrenFilter(match),
                (selector) => childrenFilter(g.childMatcher(selector)),
              ) ??
              children)
          .u21,
    );
  }
}
