part of 'selection.dart';

/// {@category Joining data}
extension SelectionEnter on Selection {
  /// Returns the enter selection: placeholder nodes for each datum that had no
  /// corresponding DOM element in the selection. (The enter selection is empty
  /// for selections not returned by [*selection*.dataBind][].)
  ///
  /// [*selection*.dataBind]: https://pub.dev/documentation/d4_selection/latest/d4_selection/SelectionData/dataBind.html
  ///
  /// The enter selection is typically used to create “missing” elements
  /// corresponding to new data. For example, to create DIV elements from an
  /// list of numbers:
  ///
  /// ```dart
  /// final div = d4
  ///     .select("body".u21)
  ///     .selectAll("div".u22)
  ///     .dataBind([4, 8, 15, 16, 23, 42].map((e) => e.toJS).toList().u22)
  ///     .enter()
  ///     .append("div".u22)
  ///     .textSet((Element thisArg, JSAny? d, int i, List<Element?> nodes) {
  ///       return (d as JSNumber).toDartInt.toString();
  ///     }.u21);
  /// ```
  ///
  /// If the body is initially empty, the above code will create six new DIV
  /// elements, append them to the body in-order, and assign their text content
  /// as the associated (string-coerced) number:
  ///
  /// ```html
  /// <div>4</div>
  /// <div>8</div>
  /// <div>15</div>
  /// <div>16</div>
  /// <div>23</div>
  /// <div>42</div>
  /// ```
  ///
  /// Conceptually, the enter selection’s placeholders are pointers to the
  /// parent element (in this example, the document body). The enter selection
  /// is typically only used transiently to append elements, and is often
  /// [merged][] with the update selection after appending, such that
  /// modifications can be applied to both entering and updating elements.
  ///
  /// [merged]: https://pub.dev/documentation/d4_selection/latest/d4_selection/SelectionMerge/merge.html
  Selection enter() {
    return Selection._(
        _enter != null ? _enter! : _groups.map(sparse).toList(), _parents);
  }
}

Element enternode(Element parent, JSAny? data) {
  final enternode =
      parent.ownerDocument!.createElementNS(parent.namespaceURI, "enternode");
  (enternode as JSObject)["__parent__"] = parent as JSObject;
  (enternode as JSObject)["__next__"] = null;
  (enternode as JSObject)["__data__"] = data;
  return enternode;
}

extension PlaceholdableNodeExtension on Element {
  Element appendChild(Node node) {
    if (nodeName == "ENTERNODE") {
      final self = (this as JSObject);
      return PlaceholdableNodeExtension(self["__parent__"] as Element)
          .insertBefore(node, self["__next__"] as Element?);
    }
    return NodeExtension(this).appendChild(node) as Element;
  }

  Element insertBefore(Node node, Node? child) {
    if (nodeName == "ENTERNODE") {
      return PlaceholdableNodeExtension(
              (this as JSObject)["__parent__"] as Element)
          .insertBefore(node, child);
    }
    return NodeExtension(this).insertBefore(node, child) as Element;
  }

  Element? querySelector(String selectors) {
    if (nodeName == "ENTERNODE") {
      return PlaceholdableNodeExtension(
              (this as JSObject)["__parent__"] as Element)
          .querySelector(selectors);
    }
    return ElementExtension(this).querySelector(selectors);
  }

  NodeList querySelectorAll(String selectors) {
    if (nodeName == "ENTERNODE") {
      return PlaceholdableNodeExtension(
              (this as JSObject)["__parent__"] as Element)
          .querySelectorAll(selectors);
    }
    return ElementExtension(this).querySelectorAll(selectors);
  }
}
