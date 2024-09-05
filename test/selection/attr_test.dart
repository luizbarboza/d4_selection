import 'dart:js_interop';

import 'package:d4_selection/d4_selection.dart';
import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:test/test.dart';
import 'package:web/web.dart';

void main() {
  test(
      "selection.attr(name) returns the value of the attribute with the specified name on the first selected element",
      () {
    document.body!.innerHTML =
        "<h1 class='c1 c2'>hello</h1><h1 class='c3'></h1>";
    expect(select((document as Element).u22).select("h1".u22).attrGet("class"),
        "c1 c2");
    expect(
        selectAll([null, document as Element].u32)
            .select("h1".u22)
            .attrGet("class"),
        "c1 c2");
  });

  test("selection.attr(name) observes the namespace prefix, if any", () {
    final selection =
        select((createJSInteropWrapper(MockElementA()) as Element).u22);
    expect(selection.attrGet("foo"), "bar");
    expect(selection.attrGet("svg:foo"), "svg:bar");
  });

  test("selection.attr(name) observes a custom namespace prefix, if any", () {
    final selection =
        select((createJSInteropWrapper(MockElementB()) as Element).u22);
    try {
      namespaces["d3js"] = "https://d3js.org/2016/namespace";
      expect(selection.attrGet("d3js:pie"), "tasty");
    } finally {
      namespaces.remove("d3js");
    }
  });

  test("selection.attr(name, value) observes the namespace prefix, if any", () {
    String? result;
    final selection = select(
        (createJSInteropWrapper(MockElementC((value) => result = value))
                as Element)
            .u22);

    result = null;
    selection.attrSet("foo", "bar".u22);
    expect(result, "bar");

    result = null;
    selection.attrSet("svg:foo", "svg:bar".u22);
    expect(result, "svg:bar");

    result = null;
    selection.attrSet(
        "foo",
        (_, __, ___, ____) {
          return "bar";
        }.u21);
    expect(result, "bar");

    result = null;
    selection.attrSet(
        "svg:foo",
        (_, __, ___, ____) {
          return "svg:bar";
        }.u21);
    expect(result, "svg:bar");
  });

  test("selection.attr(name, null) observes the namespace prefix, if any", () {
    String? result;
    final selection = select(
        (createJSInteropWrapper(MockElementD((value) => result = value))
                as Element)
            .u22);

    result = null;
    selection.attrSet("foo", null);
    expect(result, "foo");

    result = null;
    selection.attrSet("svg:foo", null);
    expect(result, "svg:foo");

    result = null;
    selection.attrSet(
        "foo",
        (_, __, ___, ____) {
          return null;
        }.u21);
    expect(result, "foo");

    result = null;
    selection.attrSet(
        "svg:foo",
        (_, __, ___, ____) {
          return null;
        }.u21);
    expect(result, "svg:foo");
  });

  test(
      "selection.attr(name, value) sets the value of the attribute with the specified name on the selected elements",
      () {
    document.body!.innerHTML =
        "<h1 id='one' class='c1 c2'>hello</h1><h1 id='two' class='c3'></h1>";
    final one = document.querySelector("#one")!;
    final two = document.querySelector("#two")!;
    final s = selectAll([one, two].u32);
    expect(s..attrSet("foo", "bar".u22), s);
    expect(one.getAttribute("foo"), "bar");
    expect(two.getAttribute("foo"), "bar");
  });

  test(
      "selection.attr(name, null) removes the attribute with the specified name on the selected elements",
      () {
    document.body!.innerHTML =
        "<h1 id='one' foo='bar' class='c1 c2'>hello</h1><h1 id='two' foo='bar' class='c3'></h1>";
    final one = document.querySelector("#one")!;
    final two = document.querySelector("#two")!;
    final s = selectAll([one, two].u32);
    expect(s..attrSet("foo", null), s);
    expect(one.hasAttribute("foo"), false);
    expect(two.hasAttribute("foo"), false);
  });

  test(
      "selection.attr(name, function) sets the value of the attribute with the specified name on the selected elements",
      () {
    document.body!.innerHTML =
        "<h1 id='one' class='c1 c2'>hello</h1><h1 id='two' class='c3'></h1>";
    final one = document.querySelector("#one")!;
    final two = document.querySelector("#two")!;
    final selection = selectAll([one, two].u32);
    expect(
        selection
          ..attrSet(
              "foo",
              (_, __, i, ___) {
                return i != 0 ? "bar-$i" : null;
              }.u21),
        selection);
    expect(one.hasAttribute("foo"), false);
    expect(two.getAttribute("foo"), "bar-1");
  });

  test(
      "selection.attr(name, function) passes the value function data, index and group",
      () {
    document.body!.innerHTML =
        "<parent id='one'><child id='three'></child><child id='four'></child></parent><parent id='two'><child id='five'></child></parent>";
    final one = document.querySelector("#one");
    final two = document.querySelector("#two");
    final three = document.querySelector("#three");
    final four = document.querySelector("#four");
    final five = document.querySelector("#five");
    final results = [];

    (selectAll([one, two].u32)
          ..datumSet((_, __, i, ___) {
            return "parent-$i".toJS;
          }.u21))
        .selectAll("child".u22)
        .dataBind((_, __, i, ___) {
          return [0, 1].map((j) {
            return "child-$i-$j".toJS;
          }).toList();
        }.u21)
        .attrSet(
            "foo",
            (thisArg, d, i, nodes) {
              results.add([thisArg, d, i, nodes]);
            }.u21);

    expect(results, [
      [
        three,
        "child-0-0",
        0,
        [three, four]
      ],
      [
        four,
        "child-0-1",
        1,
        [three, four]
      ],
      [
        five,
        "child-1-0",
        0,
        [five, null]
      ]
    ]);
  });
}

@JSExport()
class MockElementA {
  String? getAttribute(String qualifiedName) {
    return qualifiedName == "foo" ? "bar" : null;
  }

  String? getAttributeNS(String? namespace, String localName) {
    return namespace == "http://www.w3.org/2000/svg" && localName == "foo"
        ? "svg:bar"
        : null;
  }
}

@JSExport()
class MockElementB {
  String? getAttributeNS(String? namespace, String localName) {
    return namespace == "https://d3js.org/2016/namespace" && localName == "pie"
        ? "tasty"
        : null;
  }
}

@JSExport()
class MockElementC {
  final void Function(String?) _setResult;

  MockElementC(this._setResult);

  void setAttribute(String qualifiedName, String value) {
    _setResult(qualifiedName == "foo" ? value : null);
  }

  void setAttributeNS(String? namespace, String qualifiedName, String value) {
    _setResult(
        namespace == "http://www.w3.org/2000/svg" && qualifiedName == "foo"
            ? value
            : null);
  }
}

@JSExport()
class MockElementD {
  final void Function(String?) _setResult;

  MockElementD(this._setResult);

  void removeAttribute(String qualifiedName) {
    _setResult(qualifiedName == "foo" ? "foo" : null);
  }

  void removeAttributeNS(String? namespace, String localName) {
    return _setResult(
        namespace == "http://www.w3.org/2000/svg" && localName == "foo"
            ? "svg:foo"
            : null);
  }
}
