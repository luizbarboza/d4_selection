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
  test("selection.append(…) returns a selection", () {
    expect(select(document.body!.u22).append("h1".u22), isA<Selection>());
  });

  test(
      "selection.append(name) appends a new element of the specified name as the last child of each selected element",
      () {
    document.body!.innerHTML =
        "<div id='one'><span class='before'></span></div><div id='two'><span class='before'></span></div>";
    final one = document.querySelector("#one")!;
    final two = document.querySelector("#two")!;
    final s = selectAll([one, two].u32).append("span".u22);
    final three = one.querySelector("span:last-child");
    final four = two.querySelector("span:last-child");
    expect(
        s,
        EqualsSelection(<String, Object?>{
          "groups": [
            [three, four]
          ]
        }));
  });

  test("selection.append(name) observes the specified namespace, if any", () {
    document.body!.innerHTML = "<div id='one'></div><div id='two'></div>";
    final one = document.querySelector("#one")!;
    final two = document.querySelector("#two")!;
    final s = selectAll([one, two].u32).append("svg:g".u22);
    final three = one.querySelector("g")!;
    final four = two.querySelector("g")!;
    expect(three.namespaceURI, "http://www.w3.org/2000/svg");
    expect(four.namespaceURI, "http://www.w3.org/2000/svg");
    expect(
        s,
        EqualsSelection(<String, Object?>{
          "groups": [
            [three, four]
          ]
        }));
  });

  test(
      "selection.append(name) uses createElement, not createElementNS, if the implied namespace is the same as the document",
      () {
    document.body!.innerHTML = "<div id='one'></div><div id='two'></div>";
    final pass = globalContext["pass"].dartify() as num;
    final one = document.querySelector("#one")!;
    final two = document.querySelector("#two")!;

    final selection = selectAll([one, two].u32).append("P".u22);
    final three = one.querySelector("p");
    final four = two.querySelector("p");
    expect((globalContext["pass"].dartify() as num) - pass, 2);
    expect(
        selection,
        EqualsSelection(<String, Object?>{
          "groups": [
            [three, four]
          ]
        }));
  });

  test("selection.append(name) observes the implicit namespace, if any", () {
    document.body!.innerHTML = "<div id='one'></div><div id='two'></div>";
    final one = document.querySelector("#one")!;
    final two = document.querySelector("#two")!;
    final selection = selectAll([one, two].u32).append("svg".u22);
    final three = one.querySelector("svg")!;
    final four = two.querySelector("svg")!;
    expect(three.namespaceURI, "http://www.w3.org/2000/svg");
    expect(four.namespaceURI, "http://www.w3.org/2000/svg");
    expect(
        selection,
        EqualsSelection(<String, Object?>{
          "groups": [
            [three, four]
          ]
        }));
  });

  test("selection.append(name) observes the inherited namespace, if any", () {
    document.body!.innerHTML = "<div id='one'></div><div id='two'></div>";
    final one = document.querySelector("#one")!;
    final two = document.querySelector("#two")!;
    final selection =
        selectAll([one, two].u32).append("svg".u22).append("g".u22);
    final three = one.querySelector("g")!;
    final four = two.querySelector("g")!;
    expect(three.namespaceURI, "http://www.w3.org/2000/svg");
    expect(four.namespaceURI, "http://www.w3.org/2000/svg");
    expect(
        selection,
        EqualsSelection(<String, Object?>{
          "groups": [
            [three, four]
          ]
        }));
  });

  test("selection.append(name) observes a custom namespace, if any", () {
    document.body!.innerHTML = "<div id='one'></div><div id='two'></div>";
    try {
      namespaces["d3js"] = "https://d3js.org/2016/namespace";
      final one = document.querySelector("#one")!;
      final two = document.querySelector("#two")!;
      final selection = selectAll([one, two].u32).append("d3js".u22);
      final three = one.querySelector("d3js")!;
      final four = two.querySelector("d3js")!;
      expect(three.namespaceURI, "https://d3js.org/2016/namespace");
      expect(four.namespaceURI, "https://d3js.org/2016/namespace");
      expect(
          selection,
          EqualsSelection(<String, Object?>{
            "groups": [
              [three, four]
            ]
          }));
    } finally {
      namespaces.remove("d3js");
    }
  });

  test(
      "selection.append(function) appends the returned element as the last child of each selected element",
      () {
    document.body!.innerHTML =
        "<div id='one'><span class='before'></span></div><div id='two'><span class='before'></span></div>";
    final one = document.querySelector("#one")!;
    final two = document.querySelector("#two")!;
    final selection = selectAll([one, two].u32).append((_, __, ___, ____) {
      return document.createElement("SPAN");
    }.u21);
    final three = one.querySelector("span:last-child");
    final four = two.querySelector("span:last-child");
    expect(
        selection,
        EqualsSelection(<String, Object?>{
          "groups": [
            [three, four]
          ]
        }));
  });

  test(
      "selection.append(function) passes the creator function data, index and group",
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
        .append((thisArg, d, i, nodes) {
          results.add([thisArg, d, i, nodes]);
          return document.createElement("SPAN");
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
      "selection.append(…) propagates data if defined on the originating element",
      () {
    document.body!.innerHTML = "<parent><child>hello</child></parent>";
    final parent = document.querySelector("parent")!;
    (parent as JSObject)["__data__"] =
        0.toJS; // still counts as data even though falsey
    expect(select(parent.u22).append("child".u22).datumGet(), 0);
  });

  test(
      "selection.append(…) will not propagate data if not defined on the originating element",
      () {
    document.body!.innerHTML = "<parent><child>hello</child></parent>";
    final parent = document.querySelector("parent")!;
    final child = document.querySelector("child")!;
    (child as JSObject)["__data__"] = 42.toJS;
    select(parent.u22).append((_, __, ___, ____) {
      return child;
    }.u21);
    expect((child as JSObject)["__data__"], 42);
  });

  test("selection.append(…) propagates parents from the originating selection",
      () {
    document.body!.innerHTML = "<parent></parent><parent></parent>";
    final parents = select((document as Element).u22).selectAll("parent".u22);
    final childs = parents.append("child".u22);
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
    expect(parents.parents, childs.parents); // Not copied!
  });

  test(
      "selection.append(…) can select elements when the originating selection is nested",
      () {
    document.body!.innerHTML =
        "<parent id='one'><child></child></parent><parent id='two'><child></child></parent>";
    final one = document.querySelector("#one")!;
    final two = document.querySelector("#two")!;
    final selection =
        selectAll([one, two].u32).selectAll("child".u22).append("span".u22);
    final three = one.querySelector("span");
    final four = two.querySelector("span");
    expect(
        selection,
        EqualsSelection(<String, Object?>{
          "groups": [
            [three],
            [four]
          ],
          "parents": [one, two]
        }));
  });

  test("selection.append(…) skips missing originating elements", () {
    document.body!.innerHTML = "<h1></h1>";
    final h1 = document.querySelector("h1")!;
    final selection = selectAll([null, h1].u32).append("span".u22);
    final span = h1.querySelector("span");
    expect(
        selection,
        EqualsSelection(<String, Object?>{
          "groups": [
            [null, span]
          ]
        }));
  });
}

extension ToList on NodeList {
  List<Node?> toList() {
    return [for (var i = 0; i < length; i++) item(i)];
  }
}
