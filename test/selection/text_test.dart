import 'dart:js_interop';

import 'package:d4_selection/d4_selection.dart';
import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:test/test.dart';
import 'package:web/web.dart';

void main() {
  test(
      "selection.text() returns the text content on the first selected element",
      () {
    final node = {"textContent": "hello"}.jsify() as Element;
    expect(select(node.u22).textGet(), "hello");
    expect(selectAll([null, node].u32).textGet(), "hello");
  });

  test("selection.text(value) sets text content on the selected elements", () {
    final one = {"textContent": ""}.jsify() as Element;
    final two = {"textContent": ""}.jsify() as Element;
    final selection = selectAll([one, two].u32);
    expect(selection..textSet("bar".u22), selection);
    expect(one.textContent, "bar");
    expect(two.textContent, "bar");
  });

  test("selection.text(null) clears the text content on the selected elements",
      () {
    final one = {"textContent": "bar"}.jsify() as Element;
    final two = {"textContent": "bar"}.jsify() as Element;
    final selection = selectAll([one, two].u32);
    expect(selection..textSet(null), selection);
    expect(one.textContent, "");
    expect(two.textContent, "");
  });

  test(
      "selection.text(function) sets the value of the text content on the selected elements",
      () {
    final one = {"textContent": "bar"}.jsify() as Element;
    final two = {"textContent": "bar"}.jsify() as Element;
    final selection = selectAll([one, two].u32);
    expect(
        selection
          ..textSet((_, __, int i, ___) {
            return i != 0 ? "baz" : null;
          }.u21),
        selection);
    expect(one.textContent, "");
    expect(two.textContent, "baz");
  });

  test(
      "selection.text(function) passes the value function data, index and group",
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
        .textSet((thisArg, d, i, nodes) {
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
