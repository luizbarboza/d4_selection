import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:d4_selection/d4_selection.dart';
import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:test/test.dart';
import 'package:web/web.dart';

void main() {
  test(
      "selection.on(type, listener) registers a listeners for the specified event type on each selected element",
      () {
    document.body!.innerHTML = "<h1 id='one'></h1><h1 id='two'></h1>";
    var clicks = 0;
    final one = document.querySelector("#one");
    final two = document.querySelector("#two");
    final s = selectAll([one, two].u32);
    expect(
        s
          ..onBind("click", (_, __, ___) {
            ++clicks;
          }),
        s);
    s.dispatch("click");
    expect(clicks, 2);
    s.dispatch("tick");
    expect(clicks, 2);
  });

  test("selection.on(type, listener) observes the specified name, if any", () {
    document.body!.innerHTML = "<h1 id='one'></h1><h1 id='two'></h1>";
    var foo = 0;
    var bar = 0;
    final one = document.querySelector("#one");
    final two = document.querySelector("#two");
    final s = selectAll([one, two].u32)
      ..onBind("click.foo", (_, __, ___) {
        ++foo;
      })
      ..onBind("click.bar", (_, __, ___) {
        ++bar;
      });
    s.dispatch("click");
    expect(foo, 2);
    expect(bar, 2);
  });

  test(
      "selection.on(type, listener, capture) observes the specified capture flag, if any",
      () {
    JSAny? result;
    final s = select(
        (createJSInteropWrapper(MockElement((capture) => result = capture))
                as Element)
            .u22);
    expect(s..onBind("click.foo", (_, __, ___) {}, true.toJS), s);
    expect(result, true);
  });

  test(
      "selection.on(type) returns the listener for the specified event type, if any",
      () {
    document.body!.innerHTML = "<h1 id='one'></h1><h1 id='two'></h1>";
    clicked(EventTarget? _, Event __, JSAny? ___) {}
    final one = document.querySelector("#one");
    final two = document.querySelector("#two");
    final s = selectAll([one, two].u32)..onBind("click", clicked);
    expect(s.onGet("click"), equals(clicked));
  });

  test("selection.on(type) observes the specified name, if any", () {
    document.body!.innerHTML = "<h1 id='one'></h1><h1 id='two'></h1>";
    clicked(_, __, ___) {}
    final one = document.querySelector("#one");
    final two = document.querySelector("#two");
    final s = selectAll([one, two].u32)..onBind("click.foo", clicked);
    expect(s.onGet("click"), null);
    expect(s.onGet("click.foo"), clicked);
    expect(s.onGet("click.bar"), null);
    expect(s.onGet("tick.foo"), null);
    expect(s.onGet(".foo"), null);
  });

  test(
      "selection.on(type, null) removes the listener with the specified name, if any",
      () {
    document.body!.innerHTML = "<h1 id='one'></h1><h1 id='two'></h1>";
    var clicks = 0;
    final one = document.querySelector("#one");
    final two = document.querySelector("#two");
    final s = selectAll([one, two].u32)
      ..onBind("click", (_, __, ___) {
        ++clicks;
      });
    expect(s..onBind("click", null), s);
    expect(s.onGet("click"), null);
    s.dispatch("click");
    expect(clicks, 0);
  });

  test("selection.on(type, null) observes the specified name, if any", () {
    document.body!.innerHTML = "<h1 id='one'></h1><h1 id='two'></h1>";
    var foo = 0;
    var bar = 0;
    fooed(_, __, ___) {
      ++foo;
    }

    barred(_, __, ___) {
      ++bar;
    }

    final one = document.querySelector("#one");
    final two = document.querySelector("#two");
    final s = selectAll([one, two].u32)
      ..onBind("click.foo", fooed)
      ..onBind("click.bar", barred);
    expect(s..onBind("click.foo", null), s);
    expect(s.onGet("click.foo"), null);
    expect(s.onGet("click.bar"), barred);
    s.dispatch("click");
    expect(foo, 0);
    expect(bar, 2);
  });

  test(
      "selection.on(type, null, capture) ignores the specified capture flag, if any",
      () {
    var clicks = 0;
    clicked(_, __, ___) {
      ++clicks;
    }

    final s = select((document as Element).u22)
      ..onBind("click.foo", clicked, true.toJS);
    s.dispatch("click");
    expect(clicks, 1);
    (s..onBind(".foo", null, false.toJS)).dispatch("click");
    expect(clicks, 1);
    expect(s.onGet("click.foo"), null);
  });

  test("selection.on(name, null) removes all listeners with the specified name",
      () {
    document.body!.innerHTML = "<h1 id='one'></h1><h1 id='two'></h1>";
    var clicks = 0;
    var loads = 0;
    clicked(_, __, ___) {
      ++clicks;
    }

    loaded(_, __, ___) {
      ++loads;
    }

    final one = document.querySelector("#one");
    final two = document.querySelector("#two");
    final s = selectAll([one, two].u32)
      ..onBind("click.foo", clicked)
      ..onBind("load.foo", loaded);
    expect(s.onGet("click.foo"), clicked);
    expect(s.onGet("load.foo"), loaded);
    s.dispatch("click");
    s.dispatch("load");
    expect(clicks, 2);
    expect(loads, 2);
    expect(s..onBind(".foo", null), s);
    expect(s.onGet("click.foo"), null);
    expect(s.onGet("load.foo"), null);
    s.dispatch("click");
    s.dispatch("load");
    expect(clicks, 2);
    expect(loads, 2);
  });

  test("selection.on(name, null) can remove a listener with capture", () {
    var clicks = 0;
    clicked(_, __, ___) {
      ++clicks;
    }

    final s = select((document as Element).u22)
      ..onBind("click.foo", clicked, true.toJS);
    s.dispatch("click");
    expect(clicks, 1);
    (s..onBind(".foo", null)).dispatch("click");
    expect(clicks, 1);
    expect(s.onGet("click.foo"), null);
  });

  test("selection.on(name, listener) has no effect", () {
    document.body!.innerHTML = "<h1 id='one'></h1><h1 id='two'></h1>";
    var clicks = 0;
    clicked(_, __, ____) {
      ++clicks;
    }

    final one = document.querySelector("#one");
    final two = document.querySelector("#two");
    final s = selectAll([one, two].u32)..onBind("click.foo", clicked);
    expect(
        s
          ..onBind(".foo", (_, __, ___) {
            throw Error();
          }),
        s);
    expect(s.onGet("click.foo"), clicked);
    s.dispatch("click");
    expect(clicks, 2);
  });

  test("selection.on(type) skips missing elements", () {
    document.body!.innerHTML = "<h1 id='one'></h1><h1 id='two'></h1>";
    clicked(_, __, ____) {}
    final one = document.querySelector("#one");
    final two = document.querySelector("#two");
    selectAll([one, two].u32).onBind("click.foo", clicked);
    expect(selectAll([null, two].u32).onGet("click.foo"), clicked);
  });

  test("selection.on(type, listener) skips missing elements", () {
    document.body!.innerHTML = "<h1 id='one'></h1><h1 id='two'></h1>";
    var clicks = 0;
    clicked(_, __, ___) {
      ++clicks;
    }

    final two = document.querySelector("#two");
    final s = selectAll([null, two].u32)..onBind("click.foo", clicked);
    s.dispatch("click");
    expect(clicks, 1);
  });

  test("selection.on(type, listener) passes the event and listener data", () {
    document.body!.innerHTML =
        "<parent id='one'><child id='three'></child><child id='four'></child></parent><parent id='two'><child id='five'></child></parent>";
    final one = document.querySelector("#one");
    final two = document.querySelector("#two");
    final three = document.querySelector("#three");
    final four = document.querySelector("#four");
    final five = document.querySelector("#five");
    final results = [];

    final s = (selectAll([one, two].u32)
          ..datumSet((_, __, i, ___) {
            return "parent-$i".toJS;
          }.u21))
        .selectAll("child".u22)
        .dataBind((_, __, i, ___) {
          return [0, 1].map((j) {
            return "child-$i-$j".toJS;
          }).toList();
        }.u21)
      ..onBind("foo", (thisArg, e, d) {
        results.add([thisArg, e.type, d]);
      });

    expect(results, []);
    s.dispatch("foo");
    expect(results, [
      [three, "foo", "child-0-0"],
      [four, "foo", "child-0-1"],
      [five, "foo", "child-1-0"]
    ]);
  });

  test("selection.on(type, listener) passes the current listener data", () {
    document.body!.innerHTML =
        "<parent id='one'><child id='three'></child><child id='four'></child></parent><parent id='two'><child id='five'></child></parent>";
    final results = [];
    final s = select((document as Element).u22)
      ..onBind("foo", (_, __, d) {
        results.add(d);
      });
    s.dispatch("foo");
    (document as JSObject)["__data__"] = 42.toJS;
    s.dispatch("foo");
    expect(results, [null, 42]);
  });
}

@JSExport()
class MockElement {
  void Function(JSAny?) callback;

  MockElement(this.callback);

  addEventListener(type, listener, capture) {
    callback(capture);
  }
}
