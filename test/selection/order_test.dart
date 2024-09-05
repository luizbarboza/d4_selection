import 'package:d4_selection/d4_selection.dart';
import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:test/test.dart';
import 'package:web/web.dart';

void main() {
  test(
      "selection.order() moves selected elements so that they are before their next sibling",
      () {
    document.body!.innerHTML = "<h1 id='one'></h1><h1 id='two'></h1>";
    final one = document.querySelector("#one")!;
    final two = document.querySelector("#two")!;
    final selection = selectAll([two, one].u32);
    expect(selection..order(), selection);
    expect(one.nextSibling, null);
    expect(two.nextSibling, one);
  });

  test("selection.order() only orders within each group", () {
    document.body!.innerHTML =
        "<h1><span id='one'></span></h1><h1><span id='two'></span></h1>";
    final one = document.querySelector("#one")!;
    final two = document.querySelector("#two")!;
    final selection = select((document as Element).u22)
        .selectAll("h1".u22)
        .selectAll("span".u22);
    expect(selection..order(), selection);
    expect(one.nextSibling, null);
    expect(two.nextSibling, null);
  });
}
