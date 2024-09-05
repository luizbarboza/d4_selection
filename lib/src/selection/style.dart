part of 'selection.dart';

String? _getPropertyValue(Element? e, String name) {
  return ((e as JSObject?)?["style"] as CssStyleDeclaration?)
      ?.getPropertyValue(name);
}

void _removeProperty(Element? e, String name) {
  ((e as JSObject?)?["style"] as CssStyleDeclaration?)?.removeProperty(name);
}

void _setProperty(Element? e, String name, String value, String priority) {
  ((e as JSObject?)?["style"] as CssStyleDeclaration?)
      ?.setProperty(name, value, priority);
}

EachCallback<void> styleRemove(String name) {
  return (thisArg, data, i, group) {
    _removeProperty(thisArg, name);
  };
}

EachCallback<void> styleConstant(String name, String? value, String priority) {
  return (thisArg, data, i, group) {
    _setProperty(thisArg, name, value!, priority);
  };
}

EachCallback<void> styleFunction(
    String name, EachCallback<String?> value, String priority) {
  return (thisArg, data, i, group) {
    var v = value(thisArg, data, i, group);
    if (v == null) {
      _removeProperty(thisArg, name);
    } else {
      _setProperty(thisArg, name, v, priority);
    }
  };
}

/// {@category Modifying elements}
extension SelectionStyle on Selection {
  /// Returns the current value of the specified style property for the first
  /// (non-null) element in the selection.
  ///
  /// ```dart
  /// selection.styleGet("color"); // "red"
  /// ```
  ///
  /// The current value is defined as the element’s inline value, if present,
  /// and otherwise its [computed value][]. Accessing the current style value is
  /// generally useful only if you know the selection contains exactly one
  /// element.
  ///
  /// [computed value]: https://developer.mozilla.org/en-US/docs/Web/CSS/computed_value
  String? styleGet(String name) {
    return style(node(), name);
  }

  /// Sets the style property with the specified *name* to the specified *value*
  /// on the selected elements and returns this selection.
  ///
  /// ```dart
  /// selection.styleSet("color", "red".u22);
  /// ```
  ///
  /// If the *value* is a constant, then all elements are given the same style
  /// property value; otherwise, if the *value* is a function, it is evaluated
  /// for each selected element, in order, being passed the current datum (*d*),
  /// the current index (*i*), and the current group (*nodes*), with *thisArg*
  /// as the current DOM element (*nodes*\[*i*\]). The function’s return value
  /// is then used to set each element’s style property. A null value will
  /// remove the style property. An optional *priority* may also be specified,
  /// either as null or the string `important` (without the exclamation point).
  ///
  /// > [!CAUTION]
  /// > Unlike many SVG attributes, CSS styles typically have associated units.
  /// > For example, `3px` is a valid stroke-width property value, while `3` is
  /// > not. Some browsers implicitly assign the `px` (pixel) unit to numeric
  /// > values, but not all browsers do: IE, for example, throws an “invalid
  /// > arguments” error!
  Selection styleSet(String name, Union2<EachCallback<String?>, String>? value,
      [String priority = ""]) {
    return each(
      value == null
          ? styleRemove(name)
          : value.split(
              (callback) => styleFunction(name, callback, priority),
              (value) => styleConstant(name, value, priority),
            ),
    );
  }
}

/// Returns the value of the style property with the specified *name* for the
/// specified *node*.
///
/// If the *node* has an inline style with the specified *name*, its value is
/// returned; otherwise, the [computed property value][] is returned. See also
/// [*selection*.styleGet][].
///
/// [computed property value]: https://developer.mozilla.org/en-US/docs/Web/CSS/computed_value
/// [*selection*.styleGet]: https://pub.dev/documentation/d4_selection/latest/d4_selection/SelectionStyle/styleGet.html
///
/// {@category Selecting elements}
String? style(Element? node, String name) {
  final styleValue = _getPropertyValue(node, name);
  if (styleValue != null && styleValue != "") return styleValue;
  return node != null
      ? g.window(node).getComputedStyle(node, null).getPropertyValue(name)
      : null;
}
