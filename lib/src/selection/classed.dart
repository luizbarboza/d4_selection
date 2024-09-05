part of 'selection.dart';

List<String> classArray(String string) {
  return string.trim().split(RegExp(r'^|\s+'));
}

void classedAdd(Element node, List<String> names) {
  var list = node.classList, i = -1, n = names.length;
  while (++i < n) {
    list.add(names[i]);
  }
}

void classedRemove(Element node, List<String> names) {
  var list = node.classList, i = -1, n = names.length;
  while (++i < n) {
    list.remove(names[i]);
  }
}

EachCallback<void> classedTrue(List<String> names) {
  return (thisArg, _, __, ___) {
    classedAdd(thisArg, names);
  };
}

EachCallback<void> classedFalse(List<String> names) {
  return (thisArg, _, __, ___) {
    classedRemove(thisArg, names);
  };
}

EachCallback<void> classedFunction(
    List<String> names, EachCallback<bool> value) {
  return (thisArg, data, i, group) {
    (value(thisArg, data, i, group) ? classedAdd : classedRemove)(
        thisArg, names);
  };
}

/// {@category Modifying elements}
extension SelectionClassed on Selection {
  /// Returns true if and only if the first (non-null) selected element has the
  /// specified *classes*.
  ///
  /// ```dart
  /// selection.classedIs("foo"); // true, perhaps
  /// ```
  ///
  /// This is generally useful only if you know the selection contains exactly
  /// one element.
  bool classedIs(String classes) {
    var names = classArray(classes);

    DOMTokenList? list;
    if ((list = node()?.classList) == null) return false;

    var i = -1, n = names.length;
    while (++i < n) {
      if (!list!.contains(names[i])) {
        return false;
      }
    }
    return true;
  }

  /// Assigns or unassigns the specified CSS class *names* on the selected
  /// elements by setting the `class` attribute or modifying the `classList`
  /// property and returns this selection.
  ///
  /// ```dart
  /// selection.classedSet("foo", true.u22);
  /// ```
  ///
  /// The specified *names* is a string of space-separated class names. For
  /// example, to assign the classes `foo` and `bar` to the selected elements:
  ///
  /// ```dart
  /// selection.classedSet("foo bar", true.u22);
  /// ```
  ///
  /// If the *value* is truthy, then all elements are assigned the specified
  /// classes; otherwise, the classes are unassigned.
  ///
  /// ```dart
  /// selection.classedSet(
  ///   "foo",
  ///   (Element thisArg, JSAny? d, int t, List<Element?> nodes) {
  ///     return Random().nextDouble() > 0.5;
  ///   }.u21,
  /// );
  /// ```
  ///
  /// If the *value* is a function, it is evaluated for each selected element,
  /// in order, being passed the current datum (*d*), the current index (*i*),
  /// and the current group (*nodes*), with *thisArg* as the current DOM element
  /// (*nodes*\[*i*\]). The function’s return value is then used to assign or
  /// unassign classes on each element.
  Selection classedSet(String names, Union2<EachCallback<bool>, bool> value) {
    var names0 = classArray(names);

    return each(
      value?.split(
            (callback) => classedFunction(names0, callback),
            (value) => (value ? classedTrue : classedFalse)(names0),
          ) ??
          classedFalse(names0),
    );
  }
}
