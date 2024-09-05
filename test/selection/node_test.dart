import 'package:d4_selection/d4_selection.dart';
import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:test/test.dart';
import 'package:web/web.dart';

void main() {
  test("selection.node() returns the first element in a selection", () {
    document.body!.innerHTML = "<h1 id='one'></h1><h1 id='two'></h1>";
    final one = document.querySelector("#one");
    final two = document.querySelector("#two");
    expect(selectAll([one, two].u32).node(), one);
  });

  test("selection.node() skips missing elements", () {
    document.body!.innerHTML = "<h1 id='one'></h1><h1 id='two'></h1>";
    final one = document.querySelector("#one");
    final two = document.querySelector("#two");
    expect(selectAll([null, one, null, two].u32).node(), one);
  });

  test("selection.node() skips empty groups", () {
    document.body!.innerHTML = "<h1 id='one'></h1><h1 id='two'></h1>";
    final one = document.querySelector("#one");
    final two = document.querySelector("#two");
    expect(
        selectAll([one, two].u32)
            .selectAll((Element thisArg, _, int i, __) {
              return i != 0 ? [thisArg] : <Element?>[];
            }.u21)
            .node(),
        two);
  });

  test("selection.node() returns null for an empty selection", () {
    expect(select(null).node(), null);
    expect(selectAll(<Element?>[].u32).node(), null);
    expect(selectAll([null, null].u32).node(), null);
  });
}
