import 'package:d4_selection/d4_selection.dart';
import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:test/test.dart';
import 'package:web/web.dart';

void main() {
  test("selection.empty() return false if the selection is not empty", () {
    document.body!.innerHTML = "<h1 id='one'></h1><h1 id='two'></h1>";
    expect(select((document as Element).u22).empty(), false);
  });

  test("selection.empty() return true if the selection is empty", () {
    document.body!.innerHTML = "<h1 id='one'></h1><h1 id='two'></h1>";
    expect(select(null).empty(), true);
    expect(selectAll(<Element?>[].u32).empty(), true);
    expect(selectAll([null].u32).empty(), true);
  });
}
