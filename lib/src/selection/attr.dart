part of 'selection.dart';

EachCallback<void> attrRemove(String name) {
  return (thisArg, _, __, ___) {
    thisArg.removeAttribute(name);
  };
}

EachCallback<void> attrRemoveNS(Map<String, String> fullname) {
  return (thisArg, _, __, ___) {
    thisArg.removeAttributeNS(fullname["space"], fullname["local"]!);
  };
}

EachCallback<void> attrConstant(String name, String value) {
  return (thisArg, _, __, ___) {
    thisArg.setAttribute(name, value);
  };
}

EachCallback<void> attrConstantNS(Map<String, String> fullname, String value) {
  return (thisArg, _, __, ___) {
    thisArg.setAttributeNS(fullname["space"], fullname["local"]!, value);
  };
}

EachCallback<void> attrFunction(String name, EachCallback<String?> value) {
  return (thisArg, data, i, group) {
    var v = value(thisArg, data, i, group);
    if (v == null) {
      thisArg.removeAttribute(name);
    } else {
      thisArg.setAttribute(name, v);
    }
  };
}

EachCallback<void> attrFunctionNS(
    Map<String, String> fullname, EachCallback<String?> value) {
  return (thisArg, data, i, group) {
    var v = value(thisArg, data, i, group);
    if (v == null) {
      thisArg.removeAttributeNS(fullname["space"], fullname["local"]!);
    } else {
      thisArg.setAttributeNS(fullname["space"], fullname["local"]!, v);
    }
  };
}

/// {@category Modifying elements}
extension SelectionAttr on Selection {
  /// Returns the current value of the specified attribute for the first
  /// (non-null) element in the selection.
  ///
  /// ```dart
  /// selection.attrGet("color"); // "red"
  /// ```
  ///
  /// This is generally useful only if you know that the selection contains
  /// exactly one element.
  ///
  /// The specified *name* may have a namespace prefix, such as `xlink:href` to
  /// specify the `href` attribute in the XLink namespace. See
  /// [namespaces][] for the map of supported
  /// namespaces; additional namespaces can be registered by adding to the map.
  ///
  /// [namespaces]: /d4_selection/namespaces.html
  String? attrGet(String name) {
    var fullname = g.namespace(name);

    var node = this.node();
    return fullname.split(
      (fullname) => node?.getAttributeNS(fullname["space"], fullname["local"]!),
      (name) => node?.getAttribute(name),
    );
  }

  /// Sets the attribute with the specified *name* to the specified *value* on
  /// the selected elements and returns this selection.
  ///
  /// ```dart
  /// selection.attrSet("color", "red".u22);
  /// ```
  ///
  /// If the *value* is a constant, all elements are given the same attribute
  /// value; otherwise, if the *value* is a function, it is evaluated for each
  /// selected element, in order, being passed the current datum (*d*), the
  /// current index (*i*), and the current group (*nodes*), with *thisArg* as
  /// the current DOM element (*nodes*\[*i*\]). The function’s return value is
  /// then used to set each element’s attribute. A null value will remove the
  /// specified attribute.
  Selection attrSet(String name, Union2<EachCallback<String?>, String>? value) {
    var fullname = g.namespace(name);

    return each(
      value?.split(
            (callback) => fullname.split(
              (fullname) => attrFunctionNS(fullname, callback),
              (name) => attrFunction(name, callback),
            ),
            (value) => fullname.split(
              (fullname) => attrConstantNS(fullname, value),
              (name) => attrConstant(name, value),
            ),
          ) ??
          fullname.split(
            (fullname) => attrRemoveNS(fullname),
            (name) => attrRemove(name),
          ),
    );
  }
}
