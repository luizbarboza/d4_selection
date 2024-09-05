part of 'selection.dart';

EachCallback<void> propertyRemove(String name) {
  return (thisArg, _, __, ___) {
    (thisArg as JSObject).delete(name.toJS);
  };
}

EachCallback<void> propertyConstant(String name, JSAny? value) {
  return (thisArg, _, __, ___) {
    (thisArg as JSObject)[name] = value;
  };
}

EachCallback<void> propertyFunction(String name, EachCallback<JSAny?> value) {
  return (thisArg, data, i, group) {
    var v = value(thisArg, data, i, group);
    if (v == null) {
      (thisArg as JSObject).delete(name.toJS);
    } else {
      (thisArg as JSObject)[name] = v;
    }
  };
}

/// Some HTML elements have special properties that are not addressable using
/// attributes or styles, such as a form field’s text `value` and a checkbox’s
/// `checked` boolean. Use this extension to get or set these properties.
///
/// {@category Modifying elements}
extension SelectionProperty on Selection {
  /// Returns the value of the specified *property* for the first (non-null)
  /// element in the selection.
  ///
  /// ```dart
  /// selection.propertyGet("checked"); // true, perhaps
  /// ```
  ///
  /// This is generally useful only if you know the selection contains exactly
  /// one element.
  JSAny? propertyGet(String property) {
    return (node() as JSObject?)?[property];
  }

  /// Sets the property with the specified *name* to the specified *value* on
  /// selected elements.
  ///
  /// ```dart
  /// selection.propertySet("checked", true.toJS.u22);
  /// ```
  ///
  /// If the *value* is a constant, then all elements are given the same
  /// property value; otherwise, if the *value* is a function, it is evaluated
  /// for each selected element, in order, being passed the current datum (*d*),
  /// the current index (*i*), and the current group (*nodes*), with *thisArg*
  /// as the current DOM element (*nodes*\[*i*\]). The function’s return value
  /// is then used to set each element’s property. A null value will delete the
  /// specified property.
  Selection propertySet(
      String name, Union2<EachCallback<JSAny?>, JSAny?>? value) {
    return each(
      value?.split(
            (callback) => propertyFunction(name, callback),
            (value) => propertyConstant(name, value),
          ) ??
          propertyRemove(name),
    );
  }
}
