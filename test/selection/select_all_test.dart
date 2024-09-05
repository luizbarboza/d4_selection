import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:d4_selection/d4_selection.dart';
import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:test/test.dart';
import 'package:web/web.dart' hide Selection;

import '../equals_selection.dart';

void main() {
  test("selection.selectAll(…) returns a selection", () {
    document.body!.innerHTML = "<h1>hello</h1>";
    expect(select((document as Element).u22).selectAll("h1".u22),
        isA<Selection>());
  });

  test(
      "selection.selectAll(string) selects all descendants that match the selector string for each selected element",
      () {
    document.body!.innerHTML =
        "<h1 id='one'><span></span><span></span></h1><h1 id='two'><span></span><span></span></h1>";
    final one = document.querySelector("#one")!;
    final two = document.querySelector("#two")!;
    expect(
        selectAll([one, two].u32).selectAll("span".u22),
        EqualsSelection(<String, Object?>{
          "groups": [
            one.querySelectorAll("span").toList(),
            two.querySelectorAll("span").toList()
          ],
          "parents": [one, two]
        }));
  });

  test(
      "selection.selectAll(function) selects the return values of the given function for each selected element",
      () {
    document.body!.innerHTML = "<span id='one'></span>";
    final one = document.querySelector("#one");
    expect(
        select((document as Element).u22).selectAll((_, __, ___, ____) {
          return [one];
        }.u21),
        EqualsSelection(<String, Object?>{
          "groups": [
            [one]
          ],
          "parents": [document]
        }));
  });

  test(
      "selection.selectAll(function) passes the selector function data, index and group",
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
        .selectAll((thisArg, d, i, nodes) {
          results.add([thisArg, d, i, nodes]);
          return <Element?>[];
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

  test("selection.selectAll(…) will not propagate data", () {
    document.body!.innerHTML = "<parent><child>hello</child></parent>";
    final parent = document.querySelector("parent")!;
    final child = document.querySelector("child");
    (parent as JSObject)["__data__"] = 42.toJS;
    select(parent.u22).selectAll("child".u22);
    expect((child as JSObject).has("__data__"), isFalse);
  });

  test(
      "selection.selectAll(…) groups selected elements by their parent in the originating selection",
      () {
    document.body!.innerHTML =
        "<parent id='one'><child id='three'></child></parent><parent id='two'><child id='four'></child></parent>";
    final one = document.querySelector("#one");
    final two = document.querySelector("#two");
    final three = document.querySelector("#three");
    final four = document.querySelector("#four");
    expect(
        select((document as Element).u22)
            .selectAll("parent".u22)
            .selectAll("child".u22),
        EqualsSelection(<String, Object?>{
          "groups": [
            [three],
            [four]
          ],
          "parents": [one, two]
        }));
    expect(
        select((document as Element).u22).selectAll("child".u22),
        EqualsSelection(<String, Object?>{
          "groups": [
            [three, four]
          ],
          "parents": [document]
        }));
  });

  test(
      "selection.selectAll(…) can select elements when the originating selection is nested",
      () {
    document.body!.innerHTML =
        "<parent id='one'><child id='three'><span id='five'></span></child></parent><parent id='two'><child id='four'><span id='six'></span></child></parent>";
    final one = document.querySelector("#one");
    final two = document.querySelector("#two");
    final three = document.querySelector("#three");
    final four = document.querySelector("#four");
    final five = document.querySelector("#five");
    final six = document.querySelector("#six");
    expect(
        selectAll([one, two].u32).selectAll("child".u22).selectAll("span".u22),
        EqualsSelection(<String, Object?>{
          "groups": [
            [five],
            [six]
          ],
          "parents": [three, four]
        }));
  });

  test("selection.selectAll(…) skips missing originating elements", () {
    document.body!.innerHTML = "<h1><span>hello</span></h1>";
    final h1 = document.querySelector("h1");
    final span = document.querySelector("span");
    expect(
        selectAll([null, h1].u32).selectAll("span".u22),
        EqualsSelection(<String, Object?>{
          "groups": [
            [span]
          ],
          "parents": [h1]
        }));
  });

  test(
      "selection.selectAll(…) skips missing originating elements when the originating selection is nested",
      () {
    document.body!.innerHTML =
        "<parent id='one'><child></child><child id='three'><span id='five'></span></child></parent><parent id='two'><child></child><child id='four'><span id='six'></span></child></parent>";
    final one = document.querySelector("#one");
    final two = document.querySelector("#two");
    final three = document.querySelector("#three");
    final four = document.querySelector("#four");
    final five = document.querySelector("#five");
    final six = document.querySelector("#six");
    expect(
        selectAll([one, two].u32)
            .selectAll("child".u22)
            .select((Element thisArg, __, int i, ___) {
              return i.isOdd ? thisArg : null;
            }.u21)
            .selectAll("span".u22),
        EqualsSelection(<String, Object?>{
          "groups": [
            [five],
            [six]
          ],
          "parents": [three, four]
        }));
  });
}

extension ToList on NodeList {
  List<Node?> toList() {
    return [for (var i = 0; i < length; i++) item(i)];
  }
}
