import 'dart:js_interop';

import 'package:d4_selection/d4_selection.dart';
import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:test/test.dart';
import 'package:web/web.dart';

import '../equals_selection.dart';

void main() {
  test(
      "selection.insert(name, before) inserts a new element of the specified name before the specified child of each selected element",
      () {
    document.body!.innerHTML =
        "<div id='one'><span class='before'></span></div><div id='two'><span class='before'></span></div>";
    final one = document.querySelector("#one")!;
    final two = document.querySelector("#two")!;
    final selection =
        selectAll([one, two].u32).insert("span".u22, ".before".u22);
    final three = one.querySelector("span:first-child");
    final four = two.querySelector("span:first-child");
    expect(
        selection,
        EqualsSelection(<String, Object?>{
          "groups": [
            [three, four]
          ],
          "parents": [null]
        }));
  });

  test(
      "selection.insert(function, function) inserts the returned element before the specified child of each selected element",
      () {
    document.body!.innerHTML =
        "<div id='one'><span class='before'></span></div><div id='two'><span class='before'></span></div>";
    final one = document.querySelector("#one")!;
    final two = document.querySelector("#two")!;
    final selection = selectAll([one, two].u32).insert(
        (_, __, ___, ____) {
          return document.createElement("SPAN");
        }.u21,
        (Element thisArg, __, ___, ____) {
          return thisArg.firstChild as Element?;
        }.u21);
    final three = one.querySelector("span:first-child");
    final four = two.querySelector("span:first-child");
    expect(
        selection,
        EqualsSelection(<String, Object?>{
          "groups": [
            [three, four]
          ],
          "parents": [null]
        }));
  });

  test(
      "selection.insert(function, function) inserts the returned element as the last child if the selector function returns null",
      () {
    document.body!.innerHTML =
        "<div id='one'><span class='before'></span></div><div id='two'><span class='before'></span></div>";
    final one = document.querySelector("#one")!;
    final two = document.querySelector("#two")!;
    final selection = selectAll([one, two].u32).insert(
        (_, __, ___, ____) {
          return document.createElement("SPAN");
        }.u21,
        (_, __, ___, ____) {
          return null;
        }.u21);
    final three = one.querySelector("span:last-child");
    final four = two.querySelector("span:last-child");
    expect(
        selection,
        EqualsSelection(<String, Object?>{
          "groups": [
            [three, four]
          ],
          "parents": [null]
        }));
  });

  test(
      "selection.insert(name, function) passes the selector function data, index and group",
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
        .insert(
            "span".u22,
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
