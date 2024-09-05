import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:d4_selection/d4_selection.dart';
import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:test/test.dart';
import 'package:web/web.dart';

import '../equals_enter_node.dart';
import '../equals_selection.dart';

void main() {
  test(
      "selection.data(values) binds the specified values to the selected elements by index",
      () {
    document.body!.innerHTML =
        "<div id='one'></div><div id='two'></div><div id='three'></div>";
    final one = document.body!.querySelector("#one")!;
    final two = document.body!.querySelector("#two")!;
    final three = document.body!.querySelector("#three")!;
    final selection = select(document.body!.u22)
        .selectAll("div".u22)
        .dataBind(["foo", "bar", "baz"].map((d) => d.toJS).toList().u22);
    expect((one as JSObject)["__data__"], "foo");
    expect((two as JSObject)["__data__"], "bar");
    expect((three as JSObject)["__data__"], "baz");
    expect(
        selection,
        EqualsSelection(<String, Object?>{
          "groups": [
            [one, two, three]
          ],
          "parents": [document.body],
          "enter": [
            [null, null, null]
          ],
          "exit": [
            [null, null, null]
          ]
        }));
  });

  test("selection.data(values) accepts an iterable", () {
    document.body!.innerHTML =
        "<div id='one'></div><div id='two'></div><div id='three'></div>";
    final selection = select(document.body!.u22)
        .selectAll("div".u22)
        .dataBind({"foo", "bar", "baz"}.map((d) => d.toJS).toSet().u22);
    expect(selection.dataGet(), ["foo", "bar", "baz"]);
  });

  test("selection.data() returns the bound data", () {
    document.body!.innerHTML =
        "<div id='one'></div><div id='two'></div><div id='three'></div>";
    final selection = select(document.body!.u22)
        .selectAll("div".u22)
        .dataBind(["foo", "bar", "baz"].map((d) => d.toJS).toList().u22);
    expect(selection.dataGet(), ["foo", "bar", "baz"]);
  });

  test("selection.data(values) puts unbound data in the enter selection", () {
    document.body!.innerHTML = "<div id='one'></div><div id='two'></div>";
    final one = document.body!.querySelector("#one");
    final two = document.body!.querySelector("#two");
    final selection = select(document.body!.u22)
        .selectAll("div".u22)
        .dataBind(["foo", "bar", "baz"].map((d) => d.toJS).toList().u22);
    expect((one as JSObject)["__data__"], "foo");
    expect((two as JSObject)["__data__"], "bar");
    expect(
        selection,
        EqualsSelection(<String, Object?>{
          "groups": [
            [one, two, null]
          ],
          "parents": [document.body],
          "enter": [
            [null, null, EqualsEnterNode(enterNode(document.body, "baz".toJS))]
          ],
          "exit": [
            [null, null]
          ]
        }));
  });

  test("selection.data(values) puts unbound elements in the exit selection",
      () {
    document.body!.innerHTML =
        "<div id='one'></div><div id='two'></div><div id='three'></div>";
    final one = document.body!.querySelector("#one");
    final two = document.body!.querySelector("#two");
    final three = document.body!.querySelector("#three");
    final selection = select(document.body!.u22)
        .selectAll("div".u22)
        .dataBind(["foo", "bar"].map((d) => d.toJS).toList().u22);
    expect((one as JSObject)["__data__"], "foo");
    expect((two as JSObject)["__data__"], "bar");
    expect(
        selection,
        EqualsSelection(<String, Object?>{
          "groups": [
            [
              one,
              two,
            ]
          ],
          "parents": [document.body],
          "enter": [
            [null, null]
          ],
          "exit": [
            [null, null, three]
          ]
        }));
  });

  test(
      "selection.data(values) binds the specified values to each group independently",
      () {
    document.body!.innerHTML =
        "<div id='zero'><span id='one'></span><span id='two'></span></div><div id='three'><span id='four'></span><span id='five'></span></div>";
    final zero = document.body!.querySelector("#zero");
    final one = document.body!.querySelector("#one");
    final two = document.body!.querySelector("#two");
    final three = document.body!.querySelector("#three");
    final four = document.body!.querySelector("#four");
    final five = document.body!.querySelector("#five");
    final selection = select(document.body!.u22)
        .selectAll("div".u22)
        .selectAll("span".u22)
        .dataBind(["foo", "bar"].map((d) => d.toJS).toList().u22);
    expect((one as JSObject)["__data__"], "foo");
    expect((two as JSObject)["__data__"], "bar");
    expect((four as JSObject)["__data__"], "foo");
    expect((five as JSObject)["__data__"], "bar");
    expect(
        selection,
        EqualsSelection(<String, Object?>{
          "groups": [
            [one, two],
            [four, five]
          ],
          "parents": [zero, three],
          "enter": [
            [null, null],
            [null, null]
          ],
          "exit": [
            [null, null],
            [null, null]
          ]
        }));
  });

  test(
      "selection.data(function) binds the specified return values to the selected elements by index",
      () {
    document.body!.innerHTML =
        "<div id='one'></div><div id='two'></div><div id='three'></div>";
    final one = document.body!.querySelector("#one");
    final two = document.body!.querySelector("#two");
    final three = document.body!.querySelector("#three");
    final selection = select(document.body!.u22)
        .selectAll("div".u22)
        .dataBind((_, __, ___, ____) {
          return ["foo", "bar", "baz"].map((d) => d.toJS).toList();
        }.u21);
    expect((one as JSObject)["__data__"], "foo");
    expect((two as JSObject)["__data__"], "bar");
    expect((three as JSObject)["__data__"], "baz");
    expect(
        selection,
        EqualsSelection(<String, Object?>{
          "groups": [
            [one, two, three]
          ],
          "parents": [document.body],
          "enter": [
            [null, null, null]
          ],
          "exit": [
            [null, null, null]
          ]
        }));
  });

  test(
      "selection.data(function) passes the values function datum, index and parents",
      () {
    document.body!.innerHTML =
        "<parent id='one'><child></child><child></child></parent><parent id='two'><child></child></parent>";
    final one = document.querySelector("#one");
    final two = document.querySelector("#two");
    final results = [];

    (selectAll([one, two].u32)
          ..datumSet((_, __, i, ___) {
            return "parent-$i".toJS;
          }.u21))
        .selectAll("child".u22)
        .dataBind((thisArg, d, i, nodes) {
          results.add([thisArg, d, i, nodes]);
          return ["foo", "bar"].map((d) => d.toJS).toList();
        }.u21);

    expect(results, [
      [
        one,
        "parent-0",
        0,
        [one, two]
      ],
      [
        two,
        "parent-1",
        1,
        [one, two]
      ]
    ]);
  });

  test(
      "selection.data(values, function) joins data to element using the computed keys",
      () {
    document.body!.innerHTML =
        "<node id='one'></node><node id='two'></node><node id='three'></node>";
    final one = document.body!.querySelector("#one");
    final two = document.body!.querySelector("#two");
    final three = document.body!.querySelector("#three");
    final selection = select(document.body!.u22)
        .selectAll("node".u22)
        .dataBind(["one", "four", "three"].map((d) => d.toJS).toList().u22,
            (thisArg, d, _, __) {
      return d != null ? (d as JSString).toDart : thisArg.id;
    });
    expect(
        selection,
        EqualsSelection(<String, Object?>{
          "groups": [
            [one, null, three]
          ],
          "parents": [document.body],
          "enter": [
            [
              null,
              EqualsEnterNode(enterNode(document.body, "four".toJS, "#three")),
              null
            ]
          ],
          "exit": [
            [null, two, null]
          ]
        }));
  });

  test(
      "selection.data(values, function) puts elements with duplicate keys into update or exit",
      () {
    document.body!.innerHTML =
        "<node id='one' name='foo'></node><node id='two' name='foo'></node><node id='three' name='bar'></node>";
    final one = document.body!.querySelector("#one");
    final two = document.body!.querySelector("#two");
    final three = document.body!.querySelector("#three");
    final selection = select(document.body!.u22)
        .selectAll("node".u22)
        .dataBind(["foo".toJS].u22, (thisArg, d, _, __) {
      return d != null ? (d as JSString).toDart : thisArg.getAttribute("name")!;
    });
    expect(
        selection,
        EqualsSelection(<String, Object?>{
          "groups": [
            [one]
          ],
          "parents": [document.body],
          "enter": [
            [null]
          ],
          "exit": [
            [null, two, three]
          ]
        }));
  });

  test(
      "selection.data(values, function) puts elements with duplicate keys into exit",
      () {
    document.body!.innerHTML =
        "<node id='one' name='foo'></node><node id='two' name='foo'></node><node id='three' name='bar'></node>";
    final one = document.body!.querySelector("#one");
    final two = document.body!.querySelector("#two");
    final three = document.body!.querySelector("#three");
    final selection = select(document.body!.u22)
        .selectAll("node".u22)
        .dataBind(["bar".toJS].u22, (thisArg, d, _, __) {
      return d != null ? (d as JSString).toDart : thisArg.getAttribute("name")!;
    });
    expect(
        selection,
        EqualsSelection(<String, Object?>{
          "groups": [
            [three]
          ],
          "parents": [document.body],
          "enter": [
            [null]
          ],
          "exit": [
            [one, two, null]
          ]
        }));
  });

  test(
      "selection.data(values, function) puts data with duplicate keys into update and enter",
      () {
    document.body!.innerHTML =
        "<node id='one'></node><node id='two'></node><node id='three'></node>";
    final one = document.body!.querySelector("#one");
    final two = document.body!.querySelector("#two");
    final three = document.body!.querySelector("#three");
    final selection = select(document.body!.u22)
        .selectAll("node".u22)
        .dataBind(["one", "one", "two"].map((d) => d.toJS).toList().u22,
            (thisArg, d, _, __) {
      return d != null ? (d as JSString).toDart : thisArg.id;
    });
    expect(
        selection,
        EqualsSelection(<String, Object?>{
          "groups": [
            [one, null, two]
          ],
          "parents": [document.body],
          "enter": [
            [
              null,
              EqualsEnterNode(enterNode(document.body, "one".toJS, two)),
              null
            ]
          ],
          "exit": [
            [null, null, three]
          ]
        }));
  });

  test(
      "selection.data(values, function) puts data with duplicate keys into enter",
      () {
    document.body!.innerHTML =
        "<node id='one'></node><node id='two'></node><node id='three'></node>";
    final one = document.body!.querySelector("#one");
    final two = document.body!.querySelector("#two");
    final three = document.body!.querySelector("#three");
    final selection = select(document.body!.u22)
        .selectAll("node".u22)
        .dataBind(["foo", "foo", "two"].map((d) => d.toJS).toList().u22,
            (thisArg, d, _, __) {
      return d != null ? (d as JSString).toDart : thisArg.id;
    });
    expect(
        selection,
        EqualsSelection(<String, Object?>{
          "groups": [
            [null, null, two]
          ],
          "parents": [document.body],
          "enter": [
            [
              EqualsEnterNode(enterNode(document.body, "foo".toJS, two)),
              EqualsEnterNode(enterNode(document.body, "foo".toJS, two)),
              null
            ]
          ],
          "exit": [
            [one, null, three]
          ]
        }));
  });

  test(
      "selection.data(values, function) passes the key function datum, index and nodes or data",
      () {
    document.body!.innerHTML = "<node id='one'></node><node id='two'></node>";
    final one = document.body!.querySelector("#one")!;
    final two = document.body!.querySelector("#two");
    final results = [];

    select(one.u22).datumSet("foo".toJS.u22);

    select(document.body!.u22).selectAll("node".u22).dataBind(
        ["foo", "bar"].map((d) => d.toJS).toList().u22, (thisArg, d, i, nodes) {
      results.add([
        thisArg,
        d,
        i,
        [...nodes as List]
      ]);
      return d != null ? (d as JSString).toDart : thisArg.id;
    });

    expect(results, [
      [
        one,
        "foo",
        0,
        [one, two]
      ],
      [
        two,
        null,
        1,
        [one, two]
      ],
      [
        document.body,
        "foo",
        0,
        ["foo", "bar"]
      ],
      [
        document.body,
        "bar",
        1,
        ["foo", "bar"]
      ]
    ]);
  });

  test("selection.data(values, function) applies the order of the data", () {
    document.body!.innerHTML =
        "<div id='one'></div><div id='two'></div><div id='three'></div>";
    final one = document.body!.querySelector("#one");
    final two = document.body!.querySelector("#two");
    final three = document.body!.querySelector("#three");
    final selection = select(document.body!.u22).selectAll("div".u22).dataBind(
        ["four", "three", "one", "five", "two"].map((d) => d.toJS).toList().u22,
        (thisArg, d, _, __) {
      return d != null ? (d as JSString).toDart : thisArg.id;
    });
    expect(
        selection,
        EqualsSelection(<String, Object?>{
          "groups": [
            [null, three, one, null, two]
          ],
          "parents": [document.body],
          "enter": [
            [
              EqualsEnterNode(enterNode(document.body, "four".toJS, three)),
              null,
              null,
              EqualsEnterNode(enterNode(document.body, "five".toJS, two)),
              null
            ]
          ],
          "exit": [
            [null, null, null]
          ]
        }));
  });

  test(
      "selection.data(values) returns a new selection, and does not modify the original selection",
      () {
    document.body!.innerHTML = "<h1 id='one'></h1><h1 id='two'></h1>";
    final root = document.documentElement!;
    final one = document.querySelector("#one");
    final two = document.querySelector("#two");
    final selection0 = select(root.u22).selectAll("h1".u22);
    final selection1 =
        selection0.dataBind([1, 2, 3].map((d) => d.toJS).toList().u22);
    final selection2 = selection1.dataBind([1].map((d) => d.toJS).toList().u22);
    expect(
        selection0,
        EqualsSelection(<String, Object?>{
          "groups": [
            [one, two]
          ],
          "parents": [root]
        }));
    expect(
        selection1,
        EqualsSelection(<String, Object?>{
          "groups": [
            [one, two, null]
          ],
          "parents": [root],
          "enter": [
            [null, null, EqualsEnterNode(enterNode(root, 3.toJS))]
          ],
          "exit": [
            [null, null]
          ]
        }));
    expect(
        selection2,
        EqualsSelection(<String, Object?>{
          "groups": [
            [one]
          ],
          "parents": [root],
          "enter": [
            [null]
          ],
          "exit": [
            [null, two, null]
          ]
        }));
  });

  test("selection.data(values, key) does not modify the groups array in-place",
      () {
    document.body!.innerHTML = "<h1 id='one'></h1><h1 id='two'></h1>";
    final root = document.documentElement!;
    final one = document.querySelector("#one");
    final two = document.querySelector("#two");
    key(Element _, JSAny? __, int i,
        Union2<List<Element?>, Iterable<JSAny?>> ___) {
      return i.toString();
    }

    final selection0 = select(root.u22).selectAll("h1".u22);
    final selection1 =
        selection0.dataBind([1, 2, 3].map((d) => d.toJS).toList().u22, key);
    final selection2 =
        selection1.dataBind([1].map((d) => d.toJS).toList().u22, key);
    expect(
        selection0,
        EqualsSelection(<String, Object?>{
          "groups": [
            [one, two]
          ],
          "parents": [root]
        }));
    expect(
        selection1,
        EqualsSelection(<String, Object?>{
          "groups": [
            [one, two, null]
          ],
          "parents": [root],
          "enter": [
            [null, null, EqualsEnterNode(enterNode(root, 3.toJS))]
          ],
          "exit": [
            [null, null]
          ]
        }));
    expect(
        selection2,
        EqualsSelection(<String, Object?>{
          "groups": [
            [one]
          ],
          "parents": [root],
          "enter": [
            [null]
          ],
          "exit": [
            [null, two, null]
          ]
        }));
  });
}
