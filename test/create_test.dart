import 'package:d4_selection/d4_selection.dart';
import 'package:d4_selection/src/selection/selection.dart'
    show SelectionExposed;
import 'package:test/test.dart';
import 'package:web/web.dart';

void main() {
  test("create(name) returns a new HTML element with the given name", () {
    final h1 = create("h1");
    expect(h1.groups[0][0]!.namespaceURI, "http://www.w3.org/1999/xhtml");
    expect(h1.groups[0][0]!.tagName, "H1");
    expect(h1.parents, [null]);
  });

  test("create(name) returns a new SVG element with the given name", () {
    final svg = create("svg");
    expect(svg.groups[0][0]!.namespaceURI, "http://www.w3.org/2000/svg");
    expect(svg.groups[0][0]!.tagName, "svg");
    expect(svg.parents, [null]);
  });
}
