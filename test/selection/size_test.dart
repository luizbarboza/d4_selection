import 'package:d4_selection/d4_selection.dart';
import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:test/test.dart';
import 'package:web/web.dart';

void main() {
  test("selection.size() returns the number of selected elements", () {
    document.body!.innerHTML = "<h1 id='one'></h1><h1 id='two'></h1>";
    final one = document.querySelector("#one");
    final two = document.querySelector("#two");
    expect(selectAll(<Element?>[].u32).size(), 0);
    expect(selectAll([one].u32).size(), 1);
    expect(selectAll([one, two].u32).size(), 2);
  });

  test("selection.size() skips missing elements", () {
    document.body!.innerHTML = "<h1 id='one'></h1><h1 id='two'></h1>";
    final one = document.querySelector("#one");
    final two = document.querySelector("#two");
    expect(selectAll([null, one, null, two].u32).size(), 2);
  });
}
