import 'dart:js_interop';

import 'package:d4_selection/d4_selection.dart';
import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:test/test.dart';
import 'package:web/web.dart' hide Selection;

import 'equals_selection.dart';

void main() {
  test("select(…) returns an instanceof selection", () {
    document.body!.innerHTML = "<h1>hello</h1>";
    expect(select((document as Element).u22), isA<Selection>());
  });

  test(
      "select(string) selects the first element that matches the selector string",
      () {
    document.body!.innerHTML = "<h1 id='one'>foo</h1><h1 id='two'>bar</h1>";
    expect(
        select("h1".u21),
        EqualsSelection(<String, Object?>{
          "groups": [
            [document.querySelector("h1")]
          ],
          "parents": [document.documentElement]
        }));
  });

  test("select(element) selects the given element", () {
    document.body!.innerHTML = "<h1>hello</h1>";
    expect(
        select(document.body!.u22),
        EqualsSelection(<String, Object?>{
          "groups": [
            [document.body]
          ]
        }));
    expect(
        select(document.documentElement!.u22),
        EqualsSelection(<String, Object?>{
          "groups": [
            [document.documentElement]
          ]
        }));
  });

  test("select(window) selects the given window", () {
    document.body!.innerHTML = "<h1>hello</h1>";
    expect(
        select((document.defaultView as Element).u22),
        EqualsSelection(<String, Object?>{
          "groups": [
            [document.defaultView]
          ]
        }));
  });

  test("select(document) selects the given document", () {
    document.body!.innerHTML = "<h1>hello</h1>";
    expect(
        select((document as Element).u22),
        EqualsSelection(<String, Object?>{
          "groups": [
            [document]
          ]
        }));
  });

  test("select(null) selects null", () {
    document.body!.innerHTML =
        "<h1>hello</h1><null></null><undefined></undefined>";
    expect(
        select(null),
        EqualsSelection(<String, Object?>{
          "groups": [
            [null]
          ]
        }));
    expect(
        select(),
        EqualsSelection(<String, Object?>{
          "groups": [
            [null]
          ]
        }));
  });

  test("select(object) selects an arbitrary object", () {
    final object = {}.toJSBox;
    expect(
        select((object as Element).u22),
        EqualsSelection(<String, Object?>{
          "groups": [
            [object]
          ]
        }));
  });
}
