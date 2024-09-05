import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:d4_selection/d4_selection.dart';
import 'package:d4_selection/src/selection/selection.dart'
    show SelectionExposed;
import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:test/test.dart';
import 'package:web/web.dart';

import '../equals_enter_node.dart';
import '../equals_selection.dart';

void main() {
  test("selection.enter() returns an empty selection before a data-join", () {
    document.body!.innerHTML = "<h1>hello</h1>";
    final s = select(document.body!.u22);
    expect(
        s.enter(),
        EqualsSelection(<String, Object?>{
          "groups": [
            [null]
          ],
          "parents": [null]
        }));
  });

  test("selection.enter() contains EnterNodes", () {
    document.body!.innerHTML = "";
    final s = select(document.body!.u22)
        .selectAll("div".u22)
        .dataBind([1, 2, 3].map((d) => d.toJS).toList().u22);
    expect((s.enter().node() as JSObject)["__parent__"], document.body);
  });

  test("selection.enter() shares the update selection’s parents", () {
    document.body!.innerHTML = "<h1>hello</h1>";
    final s = select(document.body!.u22);
    expect(s.enter().parents, s.parents);
  });

  test("selection.enter() returns the same selection each time", () {
    document.body!.innerHTML = "<h1>hello</h1>";
    final s = select(document.body!.u22);
    expect(s.enter(), s.enter());
  });

  test("selection.enter() contains unbound data after a data-join", () {
    document.body!.innerHTML = "<div id='one'></div><div id='two'></div>";
    final s = select(document.body!.u22)
        .selectAll("div".u22)
        .dataBind(["foo", "bar", "baz"].map((d) => d.toJS).toList().u22);
    expect(
        s.enter(),
        EqualsSelection(<String, Object?>{
          "groups": [
            [null, null, EqualsEnterNode(enterNode(document.body, "baz".toJS))]
          ],
          "parents": [document.body]
        }));
  });

  test("selection.enter() uses the order of the data", () {
    document.body!.innerHTML =
        "<div id='one'></div><div id='two'></div><div id='three'></div>";
    final selection = select(document.body!.u22).selectAll("div".u22).dataBind(
        ["one", "four", "three", "five"].map((d) => d.toJS).toList().u22,
        (thisArg, d, _, __) {
      return d != null ? (d as JSString).toDart : thisArg.id;
    });
    expect(
        selection.enter(),
        EqualsSelection(<String, Object?>{
          "groups": [
            [
              null,
              EqualsEnterNode(enterNode(document.body, "four".toJS, "#three")),
              null,
              EqualsEnterNode(enterNode(document.body, "five".toJS))
            ]
          ],
          "parents": [document.body]
        }));
  });

  test("enter.append(…) inherits the namespaceURI from the parent", () {
    document.body!.innerHTML = "";
    final root = select(document.body!.u22).append("div".u22);
    final svg = root.append("svg".u22);
    final g = svg
        .selectAll("g".u22)
        .dataBind(["foo".toJS].u22)
        .enter()
        .append("g".u22);
    expect(root.node()!.namespaceURI, "http://www.w3.org/1999/xhtml");
    expect(svg.node()!.namespaceURI, "http://www.w3.org/2000/svg");
    expect(g.node()!.namespaceURI, "http://www.w3.org/2000/svg");
  });

  test("enter.append(…) does not override an explicit namespace", () {
    document.body!.innerHTML = "";
    final root = select(document.body!.u22).append("div".u22);
    final svg = root.append("svg".u22);
    final g = svg
        .selectAll("g".u22)
        .dataBind(["foo".toJS].u22)
        .enter()
        .append("xhtml:g".u22);
    expect(root.node()!.namespaceURI, "http://www.w3.org/1999/xhtml");
    expect(svg.node()!.namespaceURI, "http://www.w3.org/2000/svg");
    expect(g.node()!.namespaceURI, "http://www.w3.org/1999/xhtml");
  });

  test(
      "enter.append(…) inserts entering nodes before the next node in the update selection",
      () {
    document.body!.innerHTML = "";
    identity(_, d, __, ___) {
      return (d as JSNumber).toDartInt.toString();
    }

    var p = select(document.body!.u22).selectAll("p".u22);
    p = p.dataBind([1, 3].map((d) => d.toJS).toList().u22, identity);
    p = (p.enter().append("p".u22)..textSet(identity.u21)).merge(p);
    p = p.dataBind([0, 1, 2, 3, 4].map((d) => d.toJS).toList().u22, identity);
    p = (p.enter().append("p".u22)..textSet(identity.u21)).merge(p);
    p;
    expect(
        document.body!.innerHTML, "<p>0</p><p>1</p><p>2</p><p>3</p><p>4</p>");
  });

  test(
      "enter.insert(…, before) inserts entering nodes before the sibling matching the specified selector",
      () {
    document.body!.innerHTML = "<hr>";
    identity(_, d, __, ___) {
      return (d as JSNumber).toDartInt.toString();
    }

    var p = select(document.body!.u22).selectAll("p".u22);
    p = p.dataBind([1, 3].map((d) => d.toJS).toList().u22, identity);
    p = (p.enter().insert("p".u22, "hr".u22)..textSet(identity.u21)).merge(p);
    p = p.dataBind([0, 1, 2, 3, 4].map((d) => d.toJS).toList().u22, identity);
    p = (p.enter().insert("p".u22, "hr".u22)..textSet(identity.u21)).merge(p);
    p;
    expect(document.body!.innerHTML,
        "<p>1</p><p>3</p><p>0</p><p>2</p><p>4</p><hr>");
  });

  test("enter.insert(…, null) inserts entering nodes after the last child", () {
    document.body!.innerHTML = "";
    identity(_, d, __, ___) {
      return (d as JSNumber).toDartInt.toString();
    }

    var p = select(document.body!.u22).selectAll("p".u22);
    p = p.dataBind([1, 3].map((d) => d.toJS).toList().u22, identity);
    p = (p.enter().insert("p".u22, null)..textSet(identity.u21)).merge(p);
    p = p.dataBind([0, 1, 2, 3, 4].map((d) => d.toJS).toList().u22, identity);
    p = (p.enter().insert("p".u22, null)..textSet(identity.u21)).merge(p);
    p;
    expect(
        document.body!.innerHTML, "<p>1</p><p>3</p><p>0</p><p>2</p><p>4</p>");
  });
}
