part of 'selection.dart';

/// {@category Modifying elements}
extension SelectionAppend on Selection {
  /// If the specified *type* is a string, appends a new element of this type
  /// (tag name) as the last child of each selected element, or before the next
  /// following sibling in the update selection if this is an
  /// [enter selection][].
  ///
  /// [enter selection]: /d4_selection/SelectionEnter/enter.html
  ///
  /// The latter behavior for enter selections allows you to insert elements
  /// into the DOM in an order consistent with the new bound data; however, note
  /// that [*selection*.order][] may still be required if updating elements
  /// change order (*i.e.*, if the order of new data is inconsistent with old
  /// data).
  ///
  /// [*selection*.order]: /d4_selection/SelectionOrder/order.html
  ///
  /// If the specified *type* is a function, it is evaluated for each selected
  /// element, in order, being passed the current datum (*d*), the current index
  /// (*i*), and the current group (*nodes*), with *thisArg* as the current DOM
  /// element (*nodes*\[*i*\]). This function should return an element to be
  /// appended. (The function typically creates a new element, but it may
  /// instead return an existing element.) For example, to append a paragraph to
  /// each DIV element:
  ///
  /// ```dart
  /// d4.selectAll("div".u31).append("p".u22);
  /// ```
  ///
  /// This is equivalent to:
  ///
  /// ```dart
  /// d4.selectAll("div".u31).append(
  ///   (Element thisArg, JSAny? d, int i, List<Element?> nodes) {
  ///     return document.createElement("p");
  ///   }.u21,
  /// );
  /// ```
  ///
  /// Which is equivalent to:
  ///
  /// ```dart
  /// d4.selectAll("div".u31).select(
  ///   (Element thisArg, JSAny? d, int i, List<Element?> nodes) {
  ///     return thisArg.appendChild(document.createElement("p"));
  ///   }.u21,
  /// );
  /// ```
  ///
  /// In both cases, this method returns a new selection containing the appended
  /// elements. Each new element inherits the data of the current elements, if
  /// any, in the same manner as [*selection*.select][].
  ///
  /// [*selection*.select]: /d4_selection/SelectionSelect/select.html
  ///
  /// The specified *name* may have a namespace prefix, such as `svg:text` to
  /// specify a `text` attribute in the SVG namespace. See [namespaces][] for
  /// the map of supported namespaces; additional namespaces can be registered
  /// by adding to the map. If no namespace is specified, the namespace will be
  /// inherited from the parent element; or, if the name is one of the known
  /// prefixes, the corresponding namespace will be used (for example, `svg`
  /// implies `svg:svg`).
  ///
  /// [namespaces]: /d4_selection/namespaces.html
  Selection append(Union2<EachCallback<Element>, String> type) {
    var create = type.split((create) => create, (type) => g.creator(type));

    return select((Element thisArg, JSAny? data, int i, List<Element?> group) {
      return PlaceholdableNodeExtension(thisArg)
          .appendChild(create(thisArg, data, i, group));
    }.u21);
  }
}
