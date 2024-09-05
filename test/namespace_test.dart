import 'package:d4_selection/d4_selection.dart';
import 'package:test/test.dart';

void main() {
  test("namespace(name) returns name if there is no namespace prefix", () {
    expect(namespace("foo"), "foo");
    expect(namespace("foo:bar"), "bar");
  });

  test("namespace(name) returns the expected values for built-in namespaces",
      () {
    expect(namespace("svg"),
        {"space": "http://www.w3.org/2000/svg", "local": "svg"});
    expect(namespace("xhtml"),
        {"space": "http://www.w3.org/1999/xhtml", "local": "xhtml"});
    expect(namespace("xlink"),
        {"space": "http://www.w3.org/1999/xlink", "local": "xlink"});
    expect(namespace("xml"),
        {"space": "http://www.w3.org/XML/1998/namespace", "local": "xml"});
    expect(namespace("svg:g"),
        {"space": "http://www.w3.org/2000/svg", "local": "g"});
    expect(namespace("xhtml:b"),
        {"space": "http://www.w3.org/1999/xhtml", "local": "b"});
    expect(namespace("xlink:href"),
        {"space": "http://www.w3.org/1999/xlink", "local": "href"});
    expect(namespace("xml:lang"),
        {"space": "http://www.w3.org/XML/1998/namespace", "local": "lang"});
  });

  test("namespace(\"xmlns:…\") treats the whole name as the local name", () {
    expect(namespace("xmlns:xlink"),
        {"space": "http://www.w3.org/2000/xmlns/", "local": "xmlns:xlink"});
  });

  test("namespace(name) observes modifications to namespaces", () {
    namespaces["d3js"] = "https://d3js.org/2016/namespace";
    expect(namespace("d3js:pie"),
        {"space": "https://d3js.org/2016/namespace", "local": "pie"});
    namespaces.remove("d3js");
    expect(namespace("d3js:pie"), "pie");
  });
}
