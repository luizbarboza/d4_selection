import 'package:d4_selection/d4_selection.dart';
import 'package:d4_selection/src/selection/selection.dart'
    show SelectionExposed;
import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:test/test.dart';
import 'package:web/web.dart';

import '../equals_selection.dart';

void main() {
  test(
      "selection.merge(selection) returns a new selection, merging the two selections",
      () {
    document.body!.innerHTML = "<h1 id='one'>one</h1><h1 id='two'>two</h1>";
    final one = document.querySelector("#one");
    final two = document.querySelector("#two");
    final selection0 = select(document.body!.u22).selectAll("h1".u22);
    final selection1 = selection0.select((Element thisArg, __, int i, ___) {
      return i.isOdd ? thisArg : null;
    }.u21);
    final selection2 = selection0.select((Element thisArg, __, int i, ___) {
      return i.isOdd ? null : thisArg;
    }.u21);
    expect(
        selection1.merge(selection2),
        EqualsSelection(<String, Object?>{
          "groups": [
            [one, two]
          ],
          "parents": [document.body]
        }));
    expect(
        selection1,
        EqualsSelection(<String, Object?>{
          "groups": [
            [null, two]
          ],
          "parents": [document.body]
        }));
    expect(
        selection2,
        EqualsSelection(<String, Object?>{
          "groups": [
            [one, null]
          ],
          "parents": [document.body]
        }));
  });

  test(
      "selection.merge(selection) returns a selection with the same size and parents as this selection",
      () {
    document.body!.innerHTML =
        "<div id='body0'><h1 name='one'>one</h1><h1 name='two'>two</h1></div><div id='body1'><h1 name='one'>one</h1><h1 name='two'>two</h1><h1 name='three'>three</h1></div>";
    final body0 = document.querySelector("#body0")!;
    final body1 = document.querySelector("#body1")!;
    final one0 = body0.querySelector("[name='one']");
    final one1 = body1.querySelector("[name='one']");
    final two0 = body0.querySelector("[name='two']");
    final two1 = body1.querySelector("[name='two']");
    final three1 = body1.querySelector("[name='three']");
    expect(
        select(body0.u22)
            .selectAll("h1".u22)
            .merge(select(body1.u22).selectAll("h1".u22)),
        EqualsSelection(<String, Object?>{
          "groups": [
            [one0, two0]
          ],
          "parents": [body0]
        }));
    expect(
        select(body1.u22)
            .selectAll("h1".u22)
            .merge(select(body0.u22).selectAll("h1".u22)),
        EqualsSelection(<String, Object?>{
          "groups": [
            [one1, two1, three1]
          ],
          "parents": [body1]
        }));
  });

  test(
      "selection.merge(selection) reuses groups from this selection if the other selection has fewer groups",
      () {
    document.body!.innerHTML =
        "<parent><child></child><child></child></parent><parent><child></child><child></child></parent>";
    final selection0 = selectAll("parent".u31).selectAll("child".u22);
    final selection1 =
        selectAll("parent:first-child".u31).selectAll("child".u22);
    final selection01 = selection0.merge(selection1);
    final selection10 = selection1.merge(selection0);
    expect(selection01, EqualsSelection(selection0));
    expect(selection10, EqualsSelection(selection1));
    expect(selection01.groups[1], selection0.groups[1]);
  });

  test("selection.merge(selection) reuses this selection’s parents", () {
    document.body!.innerHTML =
        "<parent><child></child><child></child></parent><parent><child></child><child></child></parent>";
    final selection0 = selectAll("parent".u31).selectAll("child".u22);
    final selection1 =
        selectAll("parent:first-child".u31).selectAll("child".u22);
    final selection01 = selection0.merge(selection1);
    final selection10 = selection1.merge(selection0);
    expect(selection01.parents, selection0.parents);
    expect(selection10.parents, selection1.parents);
  });
}
