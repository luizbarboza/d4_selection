part of 'selection.dart';

/// {@category Modifying elements}
extension SelectionSort on Selection {
  /// Returns a new selection that contains a copy of each group in this
  /// selection sorted according to the *compare* function. After sorting,
  /// re-inserts elements to match the resulting order (per
  /// [*selection*.order][]).
  ///
  /// [*selection*.order]: /d4_selection/SelectionOrder/order.html
  ///
  /// The compare function, which defaults to [ascending][],
  /// is passed two elements’ data *a* and *b* to compare. It should return
  /// either a negative, positive, or zero value. If negative, then *a* should
  /// be before *b*; if positive, then *a* should be after *b*; otherwise, *a*
  /// and *b* are considered equal and the order is arbitrary.
  ///
  /// [ascending]: https://pub.dev/documentation/d4_array/latest/d4_array/ascending.html
  Selection sort(Comparator<JSAny?> compare) {
    int compareNode(Element? a, Element? b) {
      var aIsNull = (a == null ? 1 : 0),
          bIsNull = (b == null ? 1 : 0),
          xor = aIsNull - bIsNull;
      return xor == 0 && aIsNull == 0
          ? compare((a as JSObject)["__data__"], (b as JSObject)["__data__"])
          : xor;
    }

    final m = _groups.length, sortgroups = List<List<Element?>>.filled(m, []);
    for (var j = 0; j < m; ++j) {
      Element? node;
      List<Element?> group = _groups[j];
      int n = group.length;
      List<Element?>? sortgroup =
          sortgroups[j] = List<Element?>.filled(n, null);
      for (var i = 0; i < n; ++i) {
        if ((node = group[i]) != null) {
          sortgroup[i] = node;
        }
      }
      sortgroup.sort(compareNode);
    }

    return Selection._(sortgroups, _parents)..order();
  }
}

int ascendingDefined(Element? a, Element? b) {
  var aIsInvalid = ((a == null || a != a) ? 1 : 0),
      bIsInvalid = ((b == null || b != b) ? 1 : 0),
      xor = aIsInvalid - bIsInvalid;
  return xor != 0 || aIsInvalid == 1 ? xor : (a as Comparable).compareTo(b);
}
