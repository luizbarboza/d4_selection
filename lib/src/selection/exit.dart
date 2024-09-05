part of 'selection.dart';

/// {@category Joining data}
extension SelectionExit on Selection {
  /// Returns the exit selection: existing DOM elements in the selection for
  /// which no new datum was found. (The exit selection is empty for selections
  /// not returned by [*selection*.dataBind][].)
  ///
  /// [*selection*.dataBind]: https://pub.dev/documentation/d4_selection/latest/d4_selection/SelectionData/dataBind.html
  ///
  /// The exit selection is typically used to remove “superfluous” elements
  /// corresponding to old data. For example, to update the DIV elements created
  /// previously with a new list of numbers:
  ///
  /// ```dart
  /// div = div.dataBind(
  ///   [4, 8, 15, 16, 23, 42].map((e) => e.toJS).toList().u22,
  ///   (Element thisArg, JSAny? d, int i, Union2<List<Element?>, List<JSAny?>> nodes) {
  ///     return (d as JSNumber).toDartInt.toString();
  ///   },
  /// );
  /// ```
  ///
  /// Since a key function was specified (as the identity function), and the new
  /// data contains the numbers \[4, 8, 16\] which match existing elements in
  /// the document, the update selection contains three DIV elements. Leaving
  /// those elements as-is, we can append new elements for \[1, 2, 32\] using
  /// the enter selection:
  ///
  /// ```dart
  /// div
  ///     .enter()
  ///     .append("div".u22)
  ///     .textSet((Element thisArg, JSAny? d, int i, List<Element?> nodes) {
  ///       return (d as JSNumber).toDartInt.toString();
  ///     }.u21);
  /// ```
  ///
  /// Likewise, to remove the exiting elements \[15, 23, 42\]:
  ///
  /// ```dart
  /// div.exit().remove();
  /// ```
  ///
  /// Now the document body looks like this:
  ///
  /// ```html
  /// <div>1</div>
  /// <div>2</div>
  /// <div>4</div>
  /// <div>8</div>
  /// <div>16</div>
  /// <div>32</div>
  /// ```
  ///
  /// The order of the DOM elements matches the order of the data because the
  /// old data’s order and the new data’s order were consistent. If the new
  /// data’s order is different, use [*selection*.order][] to reorder
  /// the elements in the DOM. See the [general update pattern][] notebook for
  /// more on data joins.
  ///
  /// [*selection*.order]: https://pub.dev/documentation/d4_selection/latest/d4_selection/SelectionOrder/order.html
  /// [general update pattern]: https://observablehq.com/@d3/general-update-pattern
  ///
  /// {@category Joining data}
  Selection exit() {
    return Selection._(_exit ?? _groups.map(sparse).toList(), _parents);
  }
}
