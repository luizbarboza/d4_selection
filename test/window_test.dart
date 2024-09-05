import 'package:d4_selection/d4_selection.dart';
import 'package:test/test.dart';
import 'package:web/web.dart' hide window;
import 'package:web/web.dart' as web;

void main() {
  test("window(node) returns node.ownerDocument.defaultView", () {
    document.body!.innerHTML = "";
    expect(window(document.body!), document.defaultView);
  });

  test("window(document) returns document.defaultView", () {
    document.body!.innerHTML = "";
    expect(window(document), document.defaultView);
  });

  test("window(window) returns window", () {
    document.body!.innerHTML = "";
    expect(window(web.window), web.window);
  });
}
