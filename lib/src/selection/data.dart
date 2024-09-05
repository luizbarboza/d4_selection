part of 'selection.dart';

void bindIndex(
    Element parent,
    List<Element?> group,
    List<Element?> enter,
    List<Element?> update,
    List<Element?> exit,
    List<JSAny?> data,
    String Function(Element, JSAny?, int, Union2<List<Element?>, List<JSAny?>>)?
        _) {
  var i = 0, groupLength = group.length, dataLength = data.length;
  Element? node;

  // Put any non-null nodes that fit into update.
  // Put any null nodes into enter.
  // Put any remaining data into enter.
  for (; i < dataLength; ++i) {
    if ((node = group.elementAtOrNull(i)) != null) {
      (node as JSObject)["__data__"] = data[i];
      update[i] = node;
    } else {
      enter[i] = enternode(parent, data[i]);
    }
  }

  // Put any non-null nodes that don’t fit into exit.
  for (; i < groupLength; ++i) {
    if ((node = group[i]) != null) {
      exit[i] = node;
    }
  }
}

void bindKey(
    Element parent,
    List<Element?> group,
    List<Element?> enter,
    List<Element?> update,
    List<Element?> exit,
    List<JSAny?> data,
    String Function(Element, JSAny?, int, Union2<List<Element?>, List<JSAny?>>)?
        key) {
  var nodeByKeyValue = <String, Element>{},
      groupLength = group.length,
      dataLength = data.length,
      keyValues = List<String?>.filled(groupLength, null);
  int i;
  Element? node;
  String keyValue;

  // Compute the key for each node.
  // If multiple nodes have the same key, the duplicates are added to exit.
  for (i = 0; i < groupLength; ++i) {
    if ((node = group[i]) != null) {
      keyValues[i] =
          keyValue = key!(node!, (node as JSObject)["__data__"], i, group.u21);
      if (nodeByKeyValue.containsKey(keyValue)) {
        exit[i] = node;
      } else {
        nodeByKeyValue[keyValue] = node;
      }
    }
  }

  // Compute the key for each datum.
  // If there a node associated with this key, join and add it to update.
  // If there is not (or the key is a duplicate), add it to enter.
  for (i = 0; i < dataLength; ++i) {
    keyValue = key!(parent, data[i], i, data.u22);
    if ((node = nodeByKeyValue[keyValue]) != null) {
      update[i] = node;
      (node as JSObject)["__data__"] = data[i];
      nodeByKeyValue.remove(keyValue);
    } else {
      enter[i] = enternode(parent, data[i]);
    }
  }

  // Add any remaining nodes that were not bound to data to exit.
  for (i = 0; i < groupLength; ++i) {
    if ((node = group[i]) != null && (nodeByKeyValue[keyValues[i]] == node)) {
      exit[i] = node;
    }
  }
}

JSAny? datum(Element? node) {
  return (node as JSObject)["__data__"];
}

/// {@category Joining data}
extension SelectionData on Selection {
  /// Returns the list of data for the selected elements.
  List<JSAny?> dataGet() {
    return map(datum).toList();
  }

  /// Binds the specified list of *data* with the selected elements, returning a
  /// new selection that represents the *update* selection: the elements
  /// successfully bound to data.
  ///
  /// Also defines the [enter][] and [exit][] selections on the returned
  /// selection, which can be used to add or remove elements to correspond to
  /// the new data. The specified *data* is an list of arbitrary values (*e.g.*,
  /// numbers or objects), or a function that returns an list of values for each
  /// group. When data is assigned to an element, it is stored in the property
  /// `__data__`, thus making the data “sticky” and available on re-selection.
  ///
  /// [enter]: /d4_selection/SelectionEnter/enter.html
  /// [exit]: /d4_selection/SelectionExit/exit.html
  ///
  /// The *data* is specified **for each group** in the selection. If the
  /// selection has multiple groups (such as [d4.selectAll][] followed by
  /// [*selection*.selectAll][]), then *data* should typically be specified as a
  /// function. This function will be evaluated for each group in order, being
  /// passed the group’s parent datum (*d*, which may be null), the group index
  /// (*i*), and the selection’s parent nodes (*nodes*), with *thisArg* as the
  /// group’s parent element.
  ///
  /// [d4.selectAll]: /d4_selection/selectAll.html
  /// [*selection*.selectAll]: /d4_selection/SelectionSelectAll/selectAll.html
  ///
  /// In conjunction with [*selection*.joind][] (or more explicitly with
  /// [*selection*.enter][], [*selection*.exit][], [*selection*.append][] and
  /// [*selection*.remove][]), *selection*.data can be used to enter, update and
  /// exit elements to match data. For example, to create an HTML table from a
  /// matrix of numbers:
  ///
  /// [*selection*.joind]: /d4_selection/SelectionJoin/joind.html
  /// [*selection*.enter]: /d4_selection/SelectionEnter/enter.html
  /// [*selection*.exit]: /d4_selection/SelectionExit/exit.html
  /// [*selection*.append]: /d4_selection/SelectionAppend/append.html
  /// [*selection*.remove]: /d4_selection/SelectionRemove/remove.html
  ///
  ///
  /// ```dart
  /// final matrix = [
  ///   [11975,  5871, 8916, 2868],
  ///   [ 1951, 10048, 2060, 6171],
  ///   [ 8010, 16145, 8090, 8045],
  ///   [ 1013,   990,  940, 6907]
  /// ];
  ///
  /// d4.select("body".u21)
  ///     .append("table".u22)
  ///     .selectAll("tr".u22)
  ///     .dataBind(matrix.u22)
  ///     .joind("tr".u22)!
  ///     .selectAll("td".u22)
  ///     .dataBind((Element thisArg, JSAny? d, int i, List<Element?> nodes) {
  ///       return (d as JSArray<JSNumber>).toDart;
  ///     }.u21)
  ///     .joind("td".u22)!
  ///     .textSet((Element thisArg, JSAny? d, int i, List<Element?> nodes) {
  ///       return (d as JSNumber).toDartInt.toString();
  ///     }.u21);
  /// ```
  ///
  /// In this example the *data* function is the identity function: for each
  /// table row, it returns the corresponding row from the data matrix.
  ///
  /// If a *key* function is not specified, then the first datum in *data* is
  /// assigned to the first selected element, the second datum to the second
  /// selected element, and so on. A *key* function may be specified to control
  /// which datum is assigned to which element, replacing the default
  /// join-by-index, by computing a string identifier for each datum and
  /// element. This key function is evaluated for each selected element, in
  /// order, being passed the current datum (*d*), the current index (*i*), and
  /// the current group (*nodes*), with *thisArg* as the current DOM element
  /// (*nodes*\[*i*\]); the returned string is the element’s key. The key
  /// function is then also evaluated for each new datum in *data*, being passed
  /// the current datum (*d*), the current index (*i*), and the group’s new
  /// *data*, with *thisArg* as the group’s parent DOM element; the returned
  /// string is the datum’s key. The datum for a given key is assigned to the
  /// element with the matching key. If multiple elements have the same key, the
  /// duplicate elements are put into the exit selection; if multiple data have
  /// the same key, the duplicate data are put into the enter selection.
  ///
  /// For example, given this document:
  ///
  /// ```html
  /// <div id="Ford"></div>
  /// <div id="Jarrah"></div>
  /// <div id="Kwon"></div>
  /// <div id="Locke"></div>
  /// <div id="Reyes"></div>
  /// <div id="Shephard"></div>
  /// ```
  ///
  /// You could join data by key as follows:
  ///
  ///
  /// ```dart
  /// final data = [
  ///   {"name": "Locke", "number": 4},
  ///   {"name": "Reyes", "number": 8},
  ///   {"name": "Ford", "number": 15},
  ///   {"name": "Jarrah", "number": 16},
  ///   {"name": "Shephard", "number": 23},
  ///   {"name": "Kwon", "number": 42}
  /// ].map((m) => m.toJSBox);
  ///
  /// d4.selectAll("div".u31).dataBind(data.u22, (Element thisArg, JSAny? d, int i,
  ///     Union2<List<Element?>, List<JSAny?>> nodes) {
  ///   return d != null ? (d as JSBoxedDartObject)["name"] as String : thisArg.id;
  /// }).textSet((Element thisArg, JSAny? d, int i, List<Element?> nodes) {
  ///   return ((d as JSBoxedDartObject)["number"] as int).toString();
  /// }.u21);
  /// ```
  ///
  /// This example key function uses the datum *d* if present, and otherwise
  /// falls back to the element’s id property. Since these elements were not
  /// previously bound to data, the datum *d* is null when the key function is
  /// evaluated on selected elements, and non-null when the key function is
  /// evaluated on the new data.
  ///
  /// The *update* and *enter* selections are returned in data order, while the
  /// *exit* selection preserves the selection order prior to the join. If a key
  /// function is specified, the order of elements in the selection may not
  /// match their order in the document; use [*selection*.order][] or
  /// [*selection*.sort][] as needed. For more on how the key function affects
  /// the join, see [A Bar Chart, Part 2][] and [Object Constancy][].
  ///
  /// [*selection*.order]: /d4_selection/SelectionOrder/order.html
  /// [*selection*.sort]: /d4_selection/SelectionSort/sort.html
  /// [A Bar Chart, Part 2]: https://observablehq.com/@d3/lets-make-a-bar-chart/2
  /// [Object Constancy]: http://bost.ocks.org/mike/constancy/
  ///
  /// This method cannot be used to clear bound data; use
  /// [*selection*.datumSet][] instead.
  ///
  /// [*selection*.datumSet]: /d4_selection/SelectionDatum/datumSet.html
  Selection dataBind(
      Union2<EachCallback<Iterable<JSAny?>>, Iterable<JSAny?>> data,
      [String Function(
              Element, JSAny?, int, Union2<List<Element?>, List<JSAny?>>)?
          key]) {
    var bind = key != null ? bindKey : bindIndex,
        parents = _parents,
        groups = _groups;

    if (!data.is1) data = constant(data.as2.toList()).u21;

    final m = groups.length,
        update = List<List<Element?>>.filled(m, []),
        enter = List<List<Element?>>.filled(m, []),
        exit = List<List<Element?>>.filled(m, []);
    for (var j = 0; j < m; ++j) {
      var parent = parents[j],
          group = groups[j],
          groupLength = group.length,
          data0 =
              (data.as1)(parent!, (parent as JSObject)["__data__"], j, parents)
                  .toList(),
          dataLength = data0.length,
          enterGroup = enter[j] = List<Element?>.filled(dataLength, null),
          updateGroup = update[j] = List<Element?>.filled(dataLength, null),
          exitGroup = exit[j] = List<Element?>.filled(groupLength, null);

      bind(parent, group, enterGroup, updateGroup, exitGroup, data0, key);

      // Now connect the enter nodes to their following update node, such that
      // appendChild can insert the materialized enter node before this node,
      // rather than at the end of the parent node.
      Element? previous;
      Element? next;
      for (var i0 = 0, i1 = 0; i0 < dataLength; ++i0) {
        if ((previous = enterGroup[i0]) != null) {
          if (i0 >= i1) i1 = i0 + 1;
          while ((next = updateGroup.elementAtOrNull(i1)) == null &&
              ++i1 < dataLength) {}
          (previous as JSObject)["__next__"] = next as JSAny?;
        }
      }
    }

    final updateSelection = Selection._(update, parents);
    updateSelection._enter = enter;
    updateSelection._exit = exit;
    return updateSelection;
  }
}
