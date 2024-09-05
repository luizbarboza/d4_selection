import 'dart:js_interop';

import 'package:d4_selection/d4_selection.dart';
import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:test/test.dart';
import 'package:web/web.dart';

void main() {
  test(
      "selection.each(function) calls the specified function for each selected element in order",
      () {
    document.body!.innerHTML = "<h1 id='one'></h1><h1 id='two'></h1>";
    final result = [];
    final one = document.querySelector("#one");
    final two = document.querySelector("#two");
    final selection = selectAll([one, two].u32)
      ..datumSet(((_, __, i, ___) => "node-$i".toJS).u21);
    expect(
        selection
          ..each((thisArg, d, i, nodes) {
            result.addAll([thisArg, d, i, nodes]);
          }),
        selection);
    expect(result, [
      one,
      "node-0",
      0,
      [one, two],
      two,
      "node-1",
      1,
      [one, two]
    ]);
  });

  test("selection.each(function) skips missing elements", () {
    document.body!.innerHTML = "<h1 id='one'></h1><h1 id='two'></h1>";
    final result = [];
    final one = document.querySelector("#one");
    final two = document.querySelector("#two");
    final selection = selectAll([null, one, null, two].u32)
      ..datumSet(((_, __, i, ___) => "node-$i".toJS).u21);
    expect(
        selection
          ..each((thisArg, d, i, nodes) {
            result.addAll([thisArg, d, i, nodes]);
          }),
        selection);
    expect(result, [
      one,
      "node-1",
      1,
      [null, one, null, two],
      two,
      "node-3",
      3,
      [null, one, null, two]
    ]);
  });
}
