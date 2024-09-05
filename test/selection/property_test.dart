import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:d4_selection/d4_selection.dart';
import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:test/test.dart';
import 'package:web/web.dart';

void main() {
  test(
      "selection.property(name) returns the property with the specified name on the first selected element",
      () {
    final node = {"foo": 42}.jsify() as Element;
    expect(select(node.u22).propertyGet("foo"), 42);
    expect(selectAll([null, node].u32).propertyGet("foo"), 42);
  });

  test(
      "selection.property(name, value) sets property with the specified name on the selected elements",
      () {
    final one = {}.jsify() as Element;
    final two = {}.jsify() as Element;
    final selection = selectAll([one, two].u32);
    expect(selection..propertySet("foo", "bar".toJS.u22), selection);
    expect((one as JSObject)["foo"], "bar");
    expect((two as JSObject)["foo"], "bar");
  });

  test(
      "selection.property(name, null) removes the property with the specified name on the selected elements",
      () {
    final one = {"foo": "bar"}.jsify() as Element;
    final two = {"foo": "bar"}.jsify() as Element;
    final selection = selectAll([one, two].u32);
    expect(selection..propertySet("foo", null), selection);
    expect((one as JSObject).hasProperty("foo".toJS), false);
    expect((two as JSObject).hasProperty("foo".toJS), false);
  });

  test(
      "selection.property(name, function) sets the value of the property with the specified name on the selected elements",
      () {
    final one = {"foo": "bar"}.jsify() as Element;
    final two = {"foo": "bar"}.jsify() as Element;
    final selection = selectAll([one, two].u32);
    expect(
        selection
          ..propertySet(
              "foo",
              (_, __, i, ___) {
                return i != 0 ? "baz".toJS : null;
              }.u21),
        selection);
    expect((one as JSObject).hasProperty("foo".toJS), false);
    expect((two as JSObject)["foo"], "baz");
  });

  test(
      "selection.property(name, function) passes the value function data, index and group",
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
        .propertySet(
            "color",
            (thisArg, d, i, nodes) {
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
