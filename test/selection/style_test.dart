import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:d4_selection/d4_selection.dart';
import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:test/test.dart';
import 'package:web/web.dart';

void main() {
  test(
      "style(node, name) returns the inline value of the style property with the specified name on the first selected element, if present",
      () {
    final node = {
      "style": {
        "getPropertyValue": ((JSString name) {
          return name == "color".toJS ? "red" : "";
        }).toJS
      }
    }.jsify() as Element;
    expect(style(node, "color"), "red");
  });

  test(
      "style(node, name) returns the computed value of the style property with the specified name on the first selected element, if there is no inline style",
      () {
    final styles = createJSInteropWrapper(
      MockCSSStyleDeclaration(
        (name) => name == "color" ? "rgb(255, 0, 0)" : "",
      ),
    ) as CssStyleDeclaration;

    Element node = {
      "style": createJSInteropWrapper(
        MockCSSStyleDeclaration(
          (_) => "",
        ),
      ),
    }.jsify() as Element;

    (node as JSObject)["ownerDocument"] = {
      "defaultView": createJSInteropWrapper(MockWindow(node, styles)),
    }.jsify();

    expect(style(node, "color"), "rgb(255, 0, 0)");
  });

  test(
      "selection.style(name) returns the inline value of the style property with the specified name on the first selected element, if present",
      () {
    final node = {
      "style": createJSInteropWrapper(MockCSSStyleDeclaration((name) {
        return name == "color" ? "red" : "";
      }))
    }.jsify() as Element;
    expect(select(node.u22).styleGet("color"), "red");
    expect(selectAll([null, node].u32).styleGet("color"), "red");
  });

  test(
      "selection.style(name) returns the computed value of the style property with the specified name on the first selected element, if there is no inline style",
      () {
    final style = createJSInteropWrapper(MockCSSStyleDeclaration((name) {
      return name == "color" ? "rgb(255, 0, 0)" : "";
    })) as CssStyleDeclaration;

    final node = {
      "style": createJSInteropWrapper(MockCSSStyleDeclaration((_) {
        return "";
      })),
    }.jsify() as Element;

    (node as JSObject)["ownerDocument"] = {
      "defaultView": createJSInteropWrapper(MockWindow(node, style)),
    }.jsify();

    expect(select(node.u22).styleGet("color"), "rgb(255, 0, 0)");
    expect(selectAll([null, node].u32).styleGet("color"), "rgb(255, 0, 0)");
  });

  test(
      "selection.style(name, value) sets the value of the style property with the specified name on the selected elements",
      () {
    document.body!.innerHTML =
        "<h1 id='one' class='c1 c2'>hello</h1><h1 id='two' class='c3'></h1>";
    final one = document.querySelector("#one") as HtmlElement;
    final two = document.querySelector("#two") as HtmlElement;
    final s = selectAll([one, two].u32);
    expect(s..styleSet("color", "red".u22), s);
    expect(one.style.getPropertyValue("color"), "red");
    expect(one.style.getPropertyPriority("color"), "");
    expect(two.style.getPropertyValue("color"), "red");
    expect(two.style.getPropertyPriority("color"), "");
  });

  test(
      "selection.style(name, value, priority) sets the value and priority of the style property with the specified name on the selected elements",
      () {
    document.body!.innerHTML =
        "<h1 id='one' class='c1 c2'>hello</h1><h1 id='two' class='c3'></h1>";
    final one = document.querySelector("#one") as HtmlElement;
    final two = document.querySelector("#two") as HtmlElement;
    final s = selectAll([one, two].u32);
    expect(s..styleSet("color", "red".u22, "important"), s);
    expect(one.style.getPropertyValue("color"), "red");
    expect(one.style.getPropertyPriority("color"), "important");
    expect(two.style.getPropertyValue("color"), "red");
    expect(two.style.getPropertyPriority("color"), "important");
  });

  test(
      "selection.style(name, null) removes the attribute with the specified name on the selected elements",
      () {
    document.body!.innerHTML =
        "<h1 id='one' style='color:red;' class='c1 c2'>hello</h1><h1 id='two' style='color:red;' class='c3'></h1>";
    final one = document.querySelector("#one") as HtmlElement;
    final two = document.querySelector("#two") as HtmlElement;
    final s = selectAll([one, two].u32);
    expect(s..styleSet("color", null), s);
    expect(one.style.getPropertyValue("color"), "");
    expect(one.style.getPropertyPriority("color"), "");
    expect(two.style.getPropertyValue("color"), "");
    expect(two.style.getPropertyPriority("color"), "");
  });

  test(
      "selection.style(name, function) sets the value of the style property with the specified name on the selected elements",
      () {
    document.body!.innerHTML =
        "<h1 id='one' class='c1 c2'>hello</h1><h1 id='two' class='c3'></h1>";
    final one = document.querySelector("#one") as HtmlElement;
    final two = document.querySelector("#two") as HtmlElement;
    final s = selectAll([one, two].u32);
    expect(
        s
          ..styleSet(
              "color",
              (_, __, int i, ___) {
                return i != 0 ? "red" : null;
              }.u21),
        s);
    expect(one.style.getPropertyValue("color"), "");
    expect(one.style.getPropertyPriority("color"), "");
    expect(two.style.getPropertyValue("color"), "red");
    expect(two.style.getPropertyPriority("color"), "");
  });

  test(
      "selection.style(name, function, priority) sets the value and priority of the style property with the specified name on the selected elements",
      () {
    document.body!.innerHTML =
        "<h1 id='one' class='c1 c2'>hello</h1><h1 id='two' class='c3'></h1>";
    final one = document.querySelector("#one") as HtmlElement;
    final two = document.querySelector("#two") as HtmlElement;
    final s = selectAll([one, two].u32);
    expect(
        s
          ..styleSet(
              "color",
              (_, __, int i, ___) {
                return i != 0 ? "red" : null;
              }.u21,
              "important"),
        s);
    expect(one.style.getPropertyValue("color"), "");
    expect(one.style.getPropertyPriority("color"), "");
    expect(two.style.getPropertyValue("color"), "red");
    expect(two.style.getPropertyPriority("color"), "important");
  });

  test(
      "selection.style(name, function) passes the value function data, index and group",
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
        .styleSet(
            "color",
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
class MockCSSStyleDeclaration {
  final String Function(String) _getPropertyValue;

  MockCSSStyleDeclaration(this._getPropertyValue);

  String getPropertyValue(String property) => _getPropertyValue(property);
}

@JSExport()
class MockWindow {
  final Element _node;
  final CSSStyleDeclaration _styles;

  MockWindow(this._node, this._styles);

  CSSStyleDeclaration? getComputedStyle(
    Element elt, [
    String? pseudoElt,
  ]) {
    return elt == _node ? _styles : null;
  }
}
