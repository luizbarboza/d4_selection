import 'dart:js_interop';

import 'package:d4_selection/d4_selection.dart';
import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:test/test.dart';
import 'package:web/web.dart';

import '../equals_selection.dart';

void main() {
  test(
      "selection.sort(…) returns a new selection, sorting each group’s data, and then ordering the elements to match",
      () {
    document.body!.innerHTML =
        "<h1 id='one' data-value='1'></h1><h1 id='two' data-value='0'></h1><h1 id='three' data-value='2'></h1>";
    final one = document.querySelector("#one")!;
    final two = document.querySelector("#two")!;
    final three = document.querySelector("#three")!;
    final selection0 = selectAll([two, three, one].u32)
      ..datumSet((Element thisArg, _, __, ___) {
        return num.parse(thisArg.getAttribute("data-value")!).toJS;
      }.u21);
    final selection1 = selection0.sort((a, b) {
      return ((a as JSNumber).toDartInt - (b as JSNumber).toDartInt).sign;
    });
    expect(
        selection0,
        EqualsSelection(<String, Object?>{
          "groups": [
            [two, three, one]
          ],
          "parents": [null]
        }));
    expect(
        selection1,
        EqualsSelection(<String, Object?>{
          "groups": [
            [two, one, three]
          ],
          "parents": [null]
        }));
    expect(two.nextSibling, one);
    expect(one.nextSibling, three);
    expect(three.nextSibling, null);
  });

  test("selection.sort(…) sorts each group separately", () {
    document.body!.innerHTML =
        "<div id='one'><h1 id='three' data-value='1'></h1><h1 id='four' data-value='0'></h1></div><div id='two'><h1 id='five' data-value='3'></h1><h1 id='six' data-value='-1'></h1></div>";
    final one = document.querySelector("#one");
    final two = document.querySelector("#two");
    final three = document.querySelector("#three")!;
    final four = document.querySelector("#four")!;
    final five = document.querySelector("#five")!;
    final six = document.querySelector("#six")!;
    final selection = selectAll([one, two].u32).selectAll("h1".u22)
      ..datumSet((Element thisArg, _, __, ___) {
        return num.parse(thisArg.getAttribute("data-value")!).toJS;
      }.u21);
    expect(selection.sort((a, b) {
      return ((a as JSNumber).toDartInt - (b as JSNumber).toDartInt).sign;
    }),
        EqualsSelection(<String, Object?>{
          "groups": [
            [four, three],
            [six, five]
          ],
          "parents": [one, two]
        }));
    expect(four.nextSibling, three);
    expect(three.nextSibling, null);
    expect(six.nextSibling, five);
    expect(five.nextSibling, null);
  });

  /*test("selection.sort() uses natural ascending order", () {
    document.body!.innerHTML = "<h1 id='one'></h1><h1 id='two'></h1>";
    final one = document.querySelector("#one")!;
    final two = document.querySelector("#two")!;
    final selection = selectAll([two, one].u22)
      ..datumSet((_, __, int i, ___) {
        i.toJS;
      }.u21);
    expect(
        selection.sort(),
        EqualsSelection({
          "groups": [
            [two, one]
          ],
          "parents": [null]
        }));
    expect(one.nextSibling, null);
    expect(two.nextSibling, one);
  });*/

  /*test("selection.sort() puts missing elements at the end of each group", () {
    document.body!.innerHTML = "<h1 id='one'></h1><h1 id='two'></h1>";
    final one = document.querySelector("#one")!;
    final two = document.querySelector("#two")!;
    selectAll([two, one].u22).datumSet((_, __, int i, ___) {
      return i.toJS;
    }.u21);
    expect(selectAll([null, one, null, two].u22).sort(), {
      "groups": [
        [two, one, null, null]
      ],
      "parents": [null]
    });
    expect(two.nextSibling, one);
    expect(one.nextSibling, null);
  });*/

  test(
      "selection.sort(function) puts missing elements at the end of each group",
      () {
    document.body!.innerHTML = "<h1 id='one'></h1><h1 id='two'></h1>";
    final one = document.querySelector("#one")!;
    final two = document.querySelector("#two")!;
    selectAll([two, one].u32).datumSet((_, __, int i, ___) {
      return i.toJS;
    }.u21);
    expect(
        selectAll([null, one, null, two].u32).sort((a, b) {
          return ((b as JSNumber).toDartInt - (a as JSNumber).toDartInt).sign;
        }),
        EqualsSelection(<String, Object?>{
          "groups": [
            [one, two, null, null]
          ],
          "parents": [null]
        }));
    expect(one.nextSibling, two);
    expect(two.nextSibling, null);
  });

  test("selection.sort(function) uses the specified data comparator function",
      () {
    document.body!.innerHTML = "<h1 id='one'></h1><h1 id='two'></h1>";
    final one = document.querySelector("#one")!;
    final two = document.querySelector("#two")!;
    final selection = selectAll([two, one].u32)
      ..datumSet((_, __, int i, ___) {
        return i.toJS;
      }.u21);
    expect(selection.sort((a, b) {
      return ((b as JSNumber).toDartInt - (a as JSNumber).toDartInt).sign;
    }),
        EqualsSelection(<String, Object?>{
          "groups": [
            [one, two]
          ],
          "parents": [null]
        }));
    expect(one.nextSibling, two);
    expect(two.nextSibling, null);
  });

  test(
      "selection.sort(function) returns a new selection, and does not modify the groups array in-place",
      () {
    document.body!.innerHTML = "<h1 id='one'></h1><h1 id='two'></h1>";
    final one = document.querySelector("#one");
    final two = document.querySelector("#two");
    final selection0 = selectAll([one, two].u32)
      ..datumSet((_, __, int i, ___) {
        return i.toJS;
      }.u21);
    final selection1 = selection0.sort((a, b) {
      return ((b as JSNumber).toDartInt - (a as JSNumber).toDartInt).sign;
    });
    //final selection2 = selection1.sort();
    expect(
        selection0,
        EqualsSelection(<String, Object?>{
          "groups": [
            [one, two]
          ],
          "parents": [null]
        }));
    expect(
        selection1,
        EqualsSelection(<String, Object?>{
          "groups": [
            [two, one]
          ],
          "parents": [null]
        }));
    //expect(selection2, EqualsSelection(<String, Object?>{"groups": [[one, two]], "parents": [null]}));
  });
}
