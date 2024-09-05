import 'package:d4_selection/d4_selection.dart';
import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:test/test.dart';
import 'package:web/web.dart';

void main() {
  test("selection are iterable over the selected nodes", () {
    document.body!.innerHTML = "<h1 id='one'></h1><h1 id='two'></h1>";
    final one = document.querySelector("#one");
    final two = document.querySelector("#two");
    expect([
      ...selectAll([one, two].u32)
    ], [
      one,
      two
    ]);
  });

  test("selection iteration merges nodes from all groups into a single array",
      () {
    document.body!.innerHTML = "<h1 id='one'></h1><h1 id='two'></h1>";
    final one = document.querySelector("#one");
    final two = document.querySelector("#two");
    expect([
      ...selectAll([one, two].u32).selectAll((Element thisArg, _, __, ___) {
        return [thisArg];
      }.u21)
    ], [
      one,
      two
    ]);
  });

  test("selection iteration skips missing elements", () {
    document.body!.innerHTML = "<h1 id='one'></h1><h1 id='two'></h1>";
    final one = document.querySelector("#one");
    final two = document.querySelector("#two");
    expect([
      ...selectAll([null, one, null, two].u32)
    ], [
      one,
      two
    ]);
  });
}
