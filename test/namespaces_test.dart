import 'package:d4_selection/d4_selection.dart';
import 'package:test/test.dart';

void main() {
  test("namespaces has the expected value", () {
    expect(namespaces, {
      "svg": "http://www.w3.org/2000/svg",
      "xhtml": "http://www.w3.org/1999/xhtml",
      "xlink": "http://www.w3.org/1999/xlink",
      "xml": "http://www.w3.org/XML/1998/namespace",
      "xmlns": "http://www.w3.org/2000/xmlns/"
    });
  });
}
