import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:d4_selection/d4_selection.dart';
import 'package:d4_selection/src/selection/selection.dart'
    show SelectionExposed;
import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:test/test.dart';
import 'package:web/web.dart' hide Selection;

import '../equals_selection.dart';

void main() {
  test("selection.select(…) returns a selection", () {
    document.body!.innerHTML = "<h1>hello</h1>";
    expect(
        select((document as Element).u22).select("h1".u22), isA<Selection>());
  });

  test(
      "selection.select(string) selects the first descendant that matches the selector string for each selected element",
      () {
    document.body!.innerHTML =
        "<h1><span id='one'></span><span id='two'></span></h1><h1><span id='three'></span><span id='four'></span></h1>";
    final one = document.querySelector("#one");
    final three = document.querySelector("#three");
    expect(
        select((document as Element).u22)
            .selectAll("h1".u22)
            .select("span".u22),
        EqualsSelection(<String, Object?>{
          "groups": [
            [one, three]
          ],
          "parents": [document]
        }));
  });

  test(
      "selection.select(function) selects the return value of the given function for each selected element",
      () {
    document.body!.innerHTML = "<span id='one'></span>";
    final one = document.querySelector("#one");
    expect(
        select((document as Element).u22).select((_, __, ___, ____) {
          return one;
        }.u21),
        EqualsSelection(<String, Object?>{
          "groups": [
            [one]
          ],
          "parents": [null]
        }));
  });

  test(
      "selection.select(function) passes the selector function data, index and group",
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
        .select((thisArg, d, i, nodes) {
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

  test(
      "selection.select(…) propagates data if defined on the originating element",
      () {
    document.body!.innerHTML = "<parent><child>hello</child></parent>";
    final parent = document.querySelector("parent")!;
    final child = document.querySelector("child");
    (parent as JSObject)["__data__"] =
        0.toJS; // still counts as data even though falsey
    (child as JSObject)["__data__"] = 42.toJS;
    select(parent.u22).select("child".u22);
    expect((child as JSObject)["__data__"], 0);
  });

  test(
      "selection.select(…) will not propagate data if not defined on the originating element",
      () {
    document.body!.innerHTML = "<parent><child>hello</child></parent>";
    final parent = document.querySelector("parent")!;
    final child = document.querySelector("child");
    (child as JSObject)["__data__"] = 42.toJS;
    select(parent.u22).select("child".u22);
    expect((child as JSObject)["__data__"], 42);
  });

  test("selection.select(…) propagates parents from the originating selection",
      () {
    document.body!.innerHTML =
        "<parent><child>1</child></parent><parent><child>2</child></parent>";
    final parents = select((document as Element).u22).selectAll("parent".u22);
    final childs = parents.select("child".u22);
    expect(
        parents,
        EqualsSelection(<String, Object?>{
          "groups": [document.querySelectorAll("parent").toList()],
          "parents": [document]
        }));
    expect(
        childs,
        EqualsSelection(<String, Object?>{
          "groups": [document.querySelectorAll("child").toList()],
          "parents": [document]
        }));
    expect(parents.parents == childs.parents, isTrue); // Not copied!
  });

  test(
      "selection.select(…) can select elements when the originating selection is nested",
      () {
    document.body!.innerHTML =
        "<parent id='one'><child><span id='three'></span></child></parent><parent id='two'><child><span id='four'></span></child></parent>";
    final one = document.querySelector("#one");
    final two = document.querySelector("#two");
    final three = document.querySelector("#three");
    final four = document.querySelector("#four");
    expect(
        selectAll([one, two].u32).selectAll("child".u22).select("span".u22),
        EqualsSelection(<String, Object?>{
          "groups": [
            [three],
            [four]
          ],
          "parents": [one, two]
        }));
  });

  test("selection.select(…) skips missing originating elements", () {
    document.body!.innerHTML = "<h1><span>hello</span></h1>";
    final h1 = document.querySelector("h1");
    final span = document.querySelector("span");
    expect(
        selectAll([null, h1].u32).select("span".u22),
        EqualsSelection(<String, Object?>{
          "groups": [
            [null, span]
          ],
          "parents": [null]
        }));
  });

  test(
      "selection.select(…) skips missing originating elements when the originating selection is nested",
      () {
    document.body!.innerHTML =
        "<parent id='one'><child></child><child><span id='three'></span></child></parent><parent id='two'><child></child><child><span id='four'></span></child></parent>";
    final one = document.querySelector("#one");
    final two = document.querySelector("#two");
    final three = document.querySelector("#three");
    final four = document.querySelector("#four");
    expect(
        selectAll([one, two].u32)
            .selectAll("child".u22)
            .select((Element thisArg, __, int i, ___) {
              return i.isOdd ? thisArg : null;
            }.u21)
            .select("span".u22),
        EqualsSelection(<String, Object?>{
          "groups": [
            [null, three],
            [null, four]
          ],
          "parents": [one, two]
        }));
  });

  test("selection.selection() returns itself", () {
    document.body!.innerHTML = "<h1>hello</h1>";
    final sel = select((document as Element).u22).select("h1".u22);
    expect(sel == sel.selection(), isTrue);
    expect(sel == sel.selection().selection(), isTrue);
  });
}

extension ToList on NodeList {
  List<Node?> toList() {
    return [for (var i = 0; i < length; i++) item(i)];
  }
}
