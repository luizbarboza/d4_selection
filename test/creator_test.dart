import 'package:d4_selection/d4_selection.dart';
import 'package:test/test.dart';
import 'package:web/web.dart';

void main() {
  test("creator(name).call(element) returns a new element with the given name",
      () {
    document.body!.innerHTML = "<body class='foo'>";
    expect(type(creator("h1")(document.body!)),
        {"namespace": "http://www.w3.org/1999/xhtml", "name": "H1"});
    expect(type(creator("xhtml:h1")(document.body!)),
        {"namespace": "http://www.w3.org/1999/xhtml", "name": "H1"});
    expect(type(creator("svg")(document.body!)),
        {"namespace": "http://www.w3.org/2000/svg", "name": "svg"});
    expect(type(creator("g")(document.body!)),
        {"namespace": "http://www.w3.org/1999/xhtml", "name": "G"});
  });

  test(
      "creator(name).call(element) can inherit the namespace from the given element",
      () {
    document.body!.innerHTML = "<body class='foo'><svg></svg>";
    final svg = document.querySelector("svg")!;
    expect(type(creator("g")(document.body!)),
        {"namespace": "http://www.w3.org/1999/xhtml", "name": "G"});
    expect(type(creator("g")(svg)),
        {"namespace": "http://www.w3.org/2000/svg", "name": "g"});
  });
}

Map<String, String?> type(Element element) {
  return {"namespace": element.namespaceURI, "name": element.tagName};
}
