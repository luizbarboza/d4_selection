part of 'selection.dart';

void htmlRemove(Element thisArg, JSAny? _, int __, List<Element?> ___) {
  thisArg.innerHTML = "";
}

EachCallback<void> htmlConstant(String value) {
  return (Element thisArg, _, __, ___) {
    thisArg.innerHTML = value;
  };
}

EachCallback<void> htmlFunction(EachCallback<String?> value) {
  return (thisArg, data, i, group) {
    var v = value(thisArg, data, i, group);
    thisArg.innerHTML = v ?? "";
  };
}

/// {@category Modifying elements}
extension SelectionHtml on Selection {
  /// Returns the inner HTML for the first (non-null) element in the selection.
  ///
  /// ```dart
  /// selection.htmlGet(); // "Hello, <i>world</i>!"
  /// ```
  ///
  /// This is generally useful only if you know the selection contains exactly
  /// one element.
  String? htmlGet() {
    return node()?.innerHTML;
  }

  /// Sets the [inner HTML][] to the specified *value* on all selected elements,
  /// replacing any existing child elements.
  ///
  /// [inner HTML]: http://dev.w3.org/html5/spec-LC/apis-in-html-documents.html#innerhtml
  ///
  /// ```dart
  /// selection.htmlSet("Hello, <i>world</i>!".u22);
  /// ```
  ///
  /// If the *value* is a constant, then all elements are given the same inner
  /// HTML; otherwise, if the *value* is a function, it is evaluated for each
  /// selected element, in order, being passed the current datum (*d*), the
  /// current index (*i*), and the current group (*nodes*), with *thisArg* as
  /// the current DOM element (*nodes*\[*i*\]). The function’s return value is
  /// then used to set each element’s inner HTML. A null value will clear the
  /// scontent.
  ///
  /// Use [*selection*.append][] or [*selection*.insert][] instead to create
  /// data-driven content; this method is intended for when you want a little
  /// bit of HTML, say for rich formatting. Also, *selection*.htmlSet is only
  /// supported on HTML elements. SVG elements and other non-HTML elements do
  /// not support the innerHTML property, and thus are incompatible with
  /// *selection*.htmlSet. Consider using [XMLSerializer][] to convert a DOM
  /// subtree to text. See also the [innersvg polyfill][], which provides a shim
  /// to support the innerHTML property on SVG elements.
  ///
  /// [*selection*.append]: https://pub.dev/documentation/d4_selection/latest/d4_selection/SelectionAppend/append.html
  /// [*selection*.insert]: https://pub.dev/documentation/d4_selection/latest/d4_selection/SelectionInsert/insert.html
  /// [XMLSerializer]: https://developer.mozilla.org/en-US/docs/XMLSerializer
  /// [innersvg polyfill]: https://code.google.com/p/innersvg/
  Selection htmlSet(Union2<EachCallback<String?>, String>? value) {
    return each(
      value?.split(
            (callback) => htmlFunction(callback),
            (value) => htmlConstant(value),
          ) ??
          htmlRemove,
    );
  }
}
