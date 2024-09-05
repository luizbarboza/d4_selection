A *selection* is a set of elements from the DOM. Typically these elements are identified by [selectors][] such as `.fancy` for elements with the class *fancy*, or `div` to select DIV elements.

[selectors]: http://www.w3.org/TR/selectors-api/

Selection methods come in two forms, **select** and **selectAll**: the former selects only the first matching element, while the latter selects all matching elements in document order. The top-level selection methods, [d4.select][] and [d4.selectAll][], query the entire document; the subselection methods, [*selection*.select][] and [*selection*.selectAll][], restrict selection to descendants of the selected elements. There is also [*selection*.selectChild][] and [*selection*.selectChildren][] for direct children.

[d4.select]: /d4_selection/select.html
[d4.selectAll]: /d4_selection/selectAll.html
[*selection*.select]: /d4_selection/SelectionSelect/select.html
[*selection*.selectAll]: /d4_selection/SelectionSelectAll/selectAll.html
[*selection*.selectChild]: /d4_selection/SelectionChild/selectChild.html
[*selection*.selectChildren]: /d4_selection/SelectionChildren/selectChildren.html

```dart
d4
    .select("body".u21)
    .append("svg".u22)
    .attrSet("width", 960.toString().u22)
    .attrSet("height", 500.toString().u22)
    .append("g".u22)
    .attrSet("transform", "translate(20,20)".u22)
    .append("rect".u22)
    .attrSet("width", 920.toString().u22)
    .attrSet("height", 460.toString().u22);
```