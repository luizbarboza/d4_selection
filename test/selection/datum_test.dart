import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:d4_selection/d4_selection.dart';
import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:test/test.dart';
import 'package:web/web.dart';

void main() {
  test("selection.datum() returns the datum on the first selected element", () {
    final node = {"__data__": "hello"}.jsify() as Element;
    expect(select(node.u22).datumGet(), "hello");
    expect(selectAll([null, node].u32).datumGet(), "hello");
  });

  test("selection.datum(value) sets datum on the selected elements", () {
    final one = {"__data__": ""}.jsify() as Element;
    final two = {"__data__": ""}.jsify() as Element;
    final selection = selectAll([one, two].u32);
    expect(selection..datumSet("bar".toJS.u22), selection);
    expect((one as JSObject)["__data__"], "bar");
    expect((two as JSObject)["__data__"], "bar");
  });

  test("selection.datum(null) clears the datum on the selected elements", () {
    final one = {"__data__": "bar"}.jsify() as Element;
    final two = {"__data__": "bar"}.jsify() as Element;
    final selection = selectAll([one, two].u32);
    expect(selection..datumSet(null), selection);
    expect((one as JSObject).hasProperty("__data__".toJS), false);
    expect((one as JSObject).hasProperty("__data__".toJS), false);
  });

  test(
      "selection.datum(function) sets the value of the datum on the selected elements",
      () {
    final one = {"__data__": "bar"}.jsify() as Element;
    final two = {"__data__": "bar"}.jsify() as Element;
    final selection = selectAll([one, two].u32);
    expect(
        selection
          ..datumSet(((_, __, i, ___) => i != 0 ? "baz".toJS : null).u21),
        selection);
    expect((one as JSObject).hasProperty("__data__".toJS), false);
    expect((two as JSObject)["__data__"], "baz");
  });

  test(
      "selection.datum(function) passes the value function data, index and group",
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
          ..datumSet((_, __, i, ____) {
            return "parent-$i".toJS;
          }.u21))
        .selectAll("child".u22)
        .dataBind((_, __, i, ____) {
          return [0, 1].map((j) {
            return "child-$i-$j".toJS;
          }).toList();
        }.u21)
        .datumSet((thisArg, d, i, nodes) {
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
