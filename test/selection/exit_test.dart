import 'dart:js_interop';

import 'package:d4_selection/d4_selection.dart';
import 'package:d4_selection/src/selection/selection.dart'
    show SelectionExposed;
import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:test/test.dart';
import 'package:web/web.dart';

import '../equals_selection.dart';

void main() {
  test("selection.exit() returns an empty selection before a data-join", () {
    document.body!.innerHTML = "<h1>hello</h1>";
    final selection = select(document.body!.u22);
    expect(
        selection.exit(),
        EqualsSelection(<String, Object?>{
          "groups": [
            [null]
          ]
        }));
  });

  test("selection.exit() shares the update selection’s parents", () {
    document.body!.innerHTML = "<h1>hello</h1>";
    final selection = select(document.body!.u22);
    expect(selection.exit().parents, selection.parents);
  });

  test("selection.exit() returns the same selection each time", () {
    document.body!.innerHTML = "<h1>hello</h1>";
    final selection = select(document.body!.u22);
    expect(selection.exit(), selection.exit());
  });

  test("selection.exit() contains unbound elements after a data-join", () {
    document.body!.innerHTML = "<div id='one'></div><div id='two'></div>";
    final selection = select(document.body!.u22)
        .selectAll("div".u22)
        .dataBind(["foo".toJS].u22);
    expect(
        selection.exit(),
        EqualsSelection(<String, Object?>{
          "groups": [
            [null, document.body!.querySelector("#two")]
          ],
          "parents": [document.body]
        }));
  });

  test("selection.exit() uses the order of the originating selection", () {
    document.body!.innerHTML =
        "<div id='one'></div><div id='two'></div><div id='three'></div>";
    final selection = select(document.body!.u22).selectAll("div".u22).dataBind(
        ["three", "one"].map((d) => d.toJS).toList().u22, (thisArg, d, _, __) {
      return d != null ? (d as JSString).toDart : thisArg.id;
    });
    expect(
        selection.exit(),
        EqualsSelection(<String, Object?>{
          "groups": [
            [null, document.body!.querySelector("#two"), null]
          ],
          "parents": [document.body]
        }));
  });
}
