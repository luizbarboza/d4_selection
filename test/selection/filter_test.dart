import 'dart:js_interop';

import 'package:d4_selection/d4_selection.dart';
import 'package:d4_selection/src/selection/selection.dart'
    show SelectionExposed;
import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:test/test.dart';
import 'package:web/web.dart' hide Selection;

import '../equals_selection.dart';

void main() {
  test("selection.filter(…) returns a selection", () {
    document.body!.innerHTML = "<h1>hello</h1>";
    expect(select(document.body!.u22).filter("body".u22), isA<Selection>());
  });

  test(
      "selection.filter(string) retains the selected elements that matches the selector string",
      () {
    document.body!.innerHTML =
        "<h1><span id='one'></span><span id='two'></span></h1><h1><span id='three'></span><span id='four'></span></h1>";
    final one = document.querySelector("#one");
    final three = document.querySelector("#three");
    expect(
        select((document as Element).u22)
            .selectAll("span".u22)
            .filter("#one,#three".u22),
        EqualsSelection(<String, Object?>{
          "groups": [
            [one, three]
          ],
          "parents": [document]
        }));
  });

  test(
      "selection.filter(function) retains elements for which the given function returns true",
      () {
    document.body!.innerHTML =
        "<h1><span id='one'></span><span id='two'></span></h1><h1><span id='three'></span><span id='four'></span></h1>";
    final one = document.querySelector("#one");
    final two = document.querySelector("#two");
    final three = document.querySelector("#three");
    final four = document.querySelector("#four");
    expect(
        selectAll([one, two, three, four].u32).filter((_, __, int i, ___) {
          return i.isOdd;
        }.u21),
        EqualsSelection(<String, Object?>{
          "groups": [
            [two, four]
          ],
          "parents": [null]
        }));
  });

  test(
      "selection.filter(function) passes the selector function data, index and group",
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
          ..datumSet(((_, __, i, ___) => "parent-$i".toJS).u21))
        .selectAll("child".u22)
        .dataBind((_, __, i, ___) {
          return [0, 1].map((j) {
            return "child-$i-$j".toJS;
          }).toList();
        }.u21)
        .filter((thisArg, d, i, nodes) {
          return (results..add([thisArg, d, i, nodes])).isNotEmpty;
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

  test("selection.filter(…) propagates parents from the originating selection",
      () {
    document.body!.innerHTML =
        "<parent><child>1</child></parent><parent><child>2</child></parent>";
    final parents = select((document as Element).u22).selectAll("parent".u22);
    final parents2 = parents.filter((_, __, ___, ____) {
      return true;
    }.u21);
    expect(
        parents,
        EqualsSelection(<String, Object?>{
          "groups": [document.querySelectorAll("parent").toList()],
          "parents": [document]
        }));
    expect(
        parents2,
        EqualsSelection(<String, Object?>{
          "groups": [document.querySelectorAll("parent").toList()],
          "parents": [document]
        }));
    expect(parents.parents == parents2.parents, true); // Not copied!
  });

  test(
      "selection.filter(…) can filter elements when the originating selection is nested",
      () {
    document.body!.innerHTML =
        "<parent id='one'><child><span id='three'></span></child></parent><parent id='two'><child><span id='four'></span></child></parent>";
    final one = document.querySelector("#one");
    final two = document.querySelector("#two");
    final three = document.querySelector("#three");
    final four = document.querySelector("#four");
    expect(
        selectAll([one, two].u32).selectAll("span".u22).filter("*".u22),
        EqualsSelection(<String, Object?>{
          "groups": [
            [three],
            [four]
          ],
          "parents": [one, two]
        }));
  });

  test(
      "selection.filter(…) skips missing originating elements and does not retain the original indexes",
      () {
    document.body!.innerHTML = "<h1>hello</h1>";
    final h1 = document.querySelector("h1");
    expect(
        selectAll([null, h1].u32).filter("*".u22),
        EqualsSelection(<String, Object?>{
          "groups": [
            [h1]
          ],
          "parents": [null]
        }));
  });

  test(
      "selection.filter(…) skips missing originating elements when the originating selection is nested",
      () {
    document.body!.innerHTML =
        "<parent id='one'><child></child><child id='three'></child></parent><parent id='two'><child></child><child id='four'></child></parent>";
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
            .filter("*".u22),
        EqualsSelection(<String, Object?>{
          "groups": [
            [three],
            [four]
          ],
          "parents": [one, two]
        }));
  });
}

extension ToList on NodeList {
  List<Node?> toList() {
    return [for (var i = 0; i < length; i++) item(i)];
  }
}
