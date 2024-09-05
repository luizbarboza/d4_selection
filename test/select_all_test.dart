import 'dart:js_interop';

import 'package:d4_selection/d4_selection.dart';
import 'package:d4_selection/src/selection/selection.dart'
    show SelectionExposed;
import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:test/test.dart';
import 'package:web/web.dart' hide Selection;

import 'equals_selection.dart';

void main() {
  test("selectAll(…) returns an instanceof selection", () {
    document.body!.innerHTML = "<h1>hello</h1>";
    expect(selectAll([document as Element].u32), isA<Selection>());
  });

  test("selectAll(…) accepts an iterable", () {
    document.body!.innerHTML = "<h1>hello</h1>";
    expect(selectAll({document as Element}.u32).nodes(), [document]);
  });

  test(
      "selectAll(string) selects all elements that match the selector string, in order",
      () {
    document.body!.innerHTML = "<h1 id='one'>foo</h1><h1 id='two'>bar</h1>";
    expect(
        selectAll("h1".u31),
        EqualsSelection(<String, Object?>{
          "groups": [document.querySelectorAll("h1").toList()],
          "parents": [document.documentElement]
        }));
  });

  /*test("selectAll(nodeList) selects a NodeList of elements", () {
    document.body!.innerHTML = "<h1>hello</h1><h2>world</h2>";
    expect(
        selectAll(document.querySelectorAll("h1,h2")),
        EqualsSelection(<String, Object?>{
          "groups": [document.querySelectorAll("h1,h2")]
        }));
  });*/

  test("selectAll(array) selects an array of elements", () {
    document.body!.innerHTML = "<h1>hello</h1><h2>world</h2>";
    final h1 = document.querySelector("h1");
    final h2 = document.querySelector("h2");
    expect(
        selectAll([h1, h2].u32),
        EqualsSelection(<String, Object?>{
          "groups": [
            [h1, h2]
          ]
        }));
  });

  test("selectAll(array) can select an empty array", () {
    expect(
        selectAll(<Element?>[].u32),
        EqualsSelection(<String, Object?>{
          "groups": [[]]
        }));
  });

  test("selectAll(null) selects an empty array", () {
    expect(
        selectAll(),
        EqualsSelection(<String, Object?>{
          "groups": [[]]
        }));
    expect(
        selectAll(null),
        EqualsSelection(<String, Object?>{
          "groups": [[]]
        }));
  });

  test("selectAll(null) selects a new empty array each time", () {
    final one = selectAll().groups[0];
    final two = selectAll().groups[0];
    expect(one == two, false);
    one.add(null);
    expect(selectAll().groups[0], []);
  });

  test("selectAll(array) can select an array that contains null", () {
    document.body!.innerHTML = "<h1>hello</h1><h2>world</h2>";
    final h1 = document.querySelector("h1");
    expect(
        selectAll([null, h1, null].u32),
        EqualsSelection(<String, Object?>{
          "groups": [
            [null, h1, null]
          ]
        }));
  });

  test("selectAll(array) can select an array that contains arbitrary objects",
      () {
    final object = {}.jsify() as Element;
    expect(
        selectAll([object].u32),
        EqualsSelection(<String, Object?>{
          "groups": [
            [object]
          ]
        }));
  });
}

extension ToList on NodeList {
  List<Node?> toList() {
    return [for (var i = 0; i < length; i++) item(i)];
  }
}
