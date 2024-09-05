import 'dart:js_interop';

import 'package:d4_selection/d4_selection.dart';
import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:test/test.dart';
import 'package:web/web.dart';

void main() {
  test("selection.html() returns the inner HTML on the first selected element",
      () {
    final node = {"innerHTML": "hello"}.jsify() as Element;
    expect(select(node.u22).htmlGet(), "hello");
    expect(selectAll([null, node].u32).htmlGet(), "hello");
  });

  test("selection.html(value) sets inner HTML on the selected elements", () {
    final one = {"innerHTML": ""}.jsify() as Element;
    final two = {"innerHTML": ""}.jsify() as Element;
    final selection = selectAll([one, two].u32);
    expect(selection..htmlSet("bar".u22), selection);
    expect(one.innerHTML, "bar");
    expect(two.innerHTML, "bar");
  });

  test("selection.html(null) clears the inner HTML on the selected elements",
      () {
    final one = {"innerHTML": "bar"}.jsify() as Element;
    final two = {"innerHTML": "bar"}.jsify() as Element;
    final selection = selectAll([one, two].u32);
    expect(selection..htmlSet(null), selection);
    expect(one.innerHTML, "");
    expect(two.innerHTML, "");
  });

  test(
      "selection.html(function) sets the value of the inner HTML on the selected elements",
      () {
    final one = {"innerHTML": "bar"}.jsify() as Element;
    final two = {"innerHTML": "bar"}.jsify() as Element;
    final selection = selectAll([one, two].u32);
    expect(
        selection
          ..htmlSet((_, __, i, ___) {
            return i != 0 ? "baz" : null;
          }.u21),
        selection);
    expect(one.innerHTML, "");
    expect(two.innerHTML, "baz");
  });

  test(
      "selection.html(function) passes the value function data, index and group",
      () {
    document.body!.innerHTML =
        "<parent id='one'><child id='three'></child><child id='four'></child></parent><parent id='two'><child id='five'></child></parent>";
    final one = document.querySelector("#one");
    final two = document.querySelector("#two");
    final three = document.querySelector("#three");
    final four = document.querySelector("#four");
    final five = document.querySelector("#five");
    final results = [];

    (selectAll([one, two].u32)
          ..datumSet((_, __, i, ___) {
            return "parent-$i".toJS;
          }.u21))
        .selectAll("child".u22)
        .dataBind((_, __, i, ___) {
          return [0, 1].map((j) {
            return "child-$i-$j".toJS;
          }).toList();
        }.u21)
        .htmlSet((thisArg, d, i, nodes) {
          results.add([thisArg, d, i, nodes]);
        }.u21);

    expect(results, [
      [
        three,
        "child-0-0",
        0,
        [three, four]
      ],
      [
        four,
        "child-0-1",
        1,
        [three, four]
      ],
      [
        five,
        "child-1-0",
        0,
        [five, null]
      ]
    ]);
  });
}
