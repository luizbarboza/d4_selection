part of 'selection.dart';

// ignore: prefer_void_to_null
Null constantNull(Element _, JSAny? __, int ___, List<Element?> ____) {
  return null;
}

/// {@category Modifying elements}
extension SelectionInsert on Selection {
  /// If the specified *type* is a string, inserts a new element of this type
  /// (tag name) before the first element matching the specified *before*
  /// selector for each selected element.
  ///
  /// For example, a *before* selector `:first-child` will prepend nodes before
  /// the first child. If *before* is not specified, it defaults to null. (To
  /// append elements in an order consistent with [bound data][], use
  /// [*selection*.append][].)
  ///
  /// [bound data]: https://pub.dev/documentation/d4_selection/latest/topics/Joining%20data-topic.html
  /// [*selection*.append]: https://pub.dev/documentation/d4_selection/latest/d4_selection/SelectionAppend/append.html
  ///
  /// Both *type* and *before* may instead be specified as functions which are
  /// evaluated for each selected element, in order, being passed the current
  /// datum (*d*), the current index (*i*), and the current group (*nodes*),
  /// with *thisArg* as the current DOM element (*nodes*\[*i*\]). The *type*
  /// function should return an element to be inserted; the *before* function
  /// should return the child element before which the element should be
  /// inserted. For example, to append a paragraph to each DIV element:
  ///
  /// ```dart
  /// d4.selectAll("div".u31).insert("p".u22);
  /// ```
  ///
  /// This is equivalent to:
  ///
  /// ```dart
  /// d4.selectAll("div".u31).insert(
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
  ///     return thisArg.insertBefore(document.createElement("p"), null);
  ///   }.u21,
  /// );
  /// ```
  ///
  /// In both cases, this method returns a new selection containing the appended
  /// elements. Each new element inherits the data of the current elements, if
  /// any, in the same manner as [*selection*.select][].
  ///
  /// [*selection*.select]: https://pub.dev/documentation/d4_selection/latest/d4_selection/SelectionSelect/select.html
  ///
  /// The specified *name* may have a namespace prefix, such as `svg:text` to
  /// specify a `text` attribute in the SVG namespace. See [namespaces][] for
  /// the map of supported namespaces; additional namespaces can be registered
  /// by adding to the map. If no namespace is specified, the namespace will be
  /// inherited from the parent element; or, if the name is one of the known
  /// prefixes, the corresponding namespace will be used (for example, `svg`
  /// implies `svg:svg`).
  ///
  /// [namespaces]: https://pub.dev/documentation/d4_selection/latest/d4_selection/namespaces.html
  Selection insert(Union2<EachCallback<Element>, String> type,
      [Union2<EachCallback<Element?>, String>? before]) {
    var create = type.split(
          (create) => create,
          (type) => g.creator(type),
        ),
        select = before?.split(
              (select) => select,
              (before) => g.selector(before),
            ) ??
            constantNull;
    return this.select((thisArg, data, i, group) {
      return PlaceholdableNodeExtension(thisArg).insertBefore(
          create(thisArg, data, i, group), select(thisArg, data, i, group));
    }.u21);
  }
}
