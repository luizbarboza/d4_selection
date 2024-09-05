part of 'selection.dart';

EachCallback<void> textRemove() {
  return (thisArg, data, i, group) {
    thisArg.textContent = "";
  };
}

EachCallback<void> textConstant(String value) {
  return (thisArg, data, i, group) {
    thisArg.textContent = value;
  };
}

EachCallback<void> textFunction(EachCallback<String?> value) {
  return (thisArg, data, i, group) {
    var v = value(thisArg, data, i, group);
    thisArg.textContent = v ?? "";
  };
}

/// {@category Modifying elements}
extension SelectionText on Selection {
  /// Returns the text content for the first (non-null) element in the
  /// selection.
  ///
  /// ```dart
  /// selection.textGet(); // "Hello, world!"
  /// ```
  ///
  /// This is generally useful only if you know the selection contains exactly
  /// one element.
  String? textGet() {
    var node = this.node();
    return node?.textContent;
  }

  /// Sets the [text content][] to the specified *value* on all selected
  /// elements, replacing any existing child elements.
  ///
  /// [text content]: http://www.w3.org/TR/DOM-Level-3-Core/core.html#Node3-textContent
  ///
  /// ```dart
  /// selection.textSet("Hello, world!".u22);
  /// ```
  ///
  /// If the *value* is a constant, then all elements are given the same text
  /// content; otherwise, if the *value* is a function, it is evaluated for each
  /// selected element, in order, being passed the current datum (*d*), the
  /// current index (*i*), and the current group (*nodes*), with *thisArg* as
  /// the current DOM element (*nodes*\[*i*\]). The function’s return value is
  /// then used to set each element’s text content. A null value will clear the
  /// content.
  Selection textSet([Union2<EachCallback<String?>, String>? value]) {
    return each(
      value?.split(
            (callback) => textFunction(callback),
            (value) => textConstant(value),
          ) ??
          textRemove(),
    );
  }
}
