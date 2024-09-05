part of 'selection.dart';

/// {@category Joining data}
extension SelectionDatum on Selection {
  /// Returns the bound datum for the first (non-null) element in the selection.
  ///
  /// This is generally useful only if you know the selection contains exactly
  /// one element.
  ///
  /// This method is useful for accessing HTML5 [custom data attributes][]. For
  /// example, given the following elements:
  ///
  /// [custom data attributes]: http://www.w3.org/TR/html5/dom.html#custom-data-attribute
  ///
  /// ```html
  /// <ul id="list">
  ///   <li data-username="shawnbot">Shawn Allen</li>
  ///   <li data-username="mbostock">Mike Bostock</li>
  /// </ul>
  /// ```
  ///
  /// You can expose the custom data attributes by setting each element’s data
  /// as the built-in [dataset][] property:
  ///
  /// [dataset]: http://www.w3.org/TR/html5/dom.html#dom-dataset
  ///
  /// ```dart
  /// selection.datumSet((Element thisArg, JSAny? d, int i, List<Element?> nodes) {
  ///   return (thisArg as HTMLElement).dataset as JSAny?;
  /// }.u21);
  /// ```
  JSAny? datumGet() {
    return (node() as JSObject?)?["__data__"];
  }

  /// Sets the element’s bound data to the specified *value* on all selected
  /// elements.
  ///
  /// If the *value* is a constant, all elements are given the same datum;
  /// otherwise, if the *value* is a function, it is evaluated for each selected
  /// element, in order, being passed the current datum (*d*), the current index
  /// (*i*), and the current group (*nodes*), with *thisArg* as the current DOM
  /// element (*nodes*\[*i*\]). The function is then used to set each element’s
  /// new data. A null value will delete the bound data.
  ///
  /// Unlike [*selection*.dataBind][], this method does not compute a join and
  /// does not affect indexes or the enter and exit selections.
  ///
  /// [*selection*.dataBind]: https://pub.dev/documentation/d4_selection/latest/d4_selection/SelectionData/dataBind.html
  Selection datumSet(Union2<EachCallback<JSAny?>, JSAny?>? value) {
    return propertySet("__data__", value);
  }
}
