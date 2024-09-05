part of 'selection.dart';

void _remove(Element thisArg, JSAny? data, int i, List<Element?> group) {
  thisArg.remove();
}

/// {@category Modifying elements}
extension SelectionRemove on Selection {
  /// Removes the selected elements from the document.
  ///
  /// Returns this selection (the removed elements) which are now detached from
  /// the DOM. There is not currently a dedicated API to add removed elements
  /// back to the document; however, you can pass a function to
  /// [*selection*.append][] or [*selection*.insert][] to re-add elements.
  ///
  /// [*selection*.append]: /d4_selection/SelectionAppend/append.html
  /// [*selection*.insert]: /d4_selection/SelectionInsert/insert.html
  Selection remove() {
    return each(_remove);
  }
}
