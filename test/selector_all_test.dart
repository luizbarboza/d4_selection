import 'dart:js_interop';

import 'package:d4_selection/d4_selection.dart';
import 'package:test/test.dart';
import 'package:web/web.dart';

void main() {
  test(
      "selectorAll(selector).call(element) returns all elements that match the selector",
      () {
    document.documentElement!.innerHTML = "<body class='foo'><div class='foo'>";
    final body = document.body;
    final div = document.querySelector("div");
    expect([...selectorAll("body")(document.documentElement!)], [body]);
    expect([...selectorAll(".foo")(document.documentElement!)], [body, div]);
    expect([...selectorAll("div.foo")(document.documentElement!)], [div]);
    expect([...selectorAll("div")(document.documentElement!)], [div]);
    expect(
        [...selectorAll("div,body")(document.documentElement!)], [body, div]);
    expect([...selectorAll("h1")(document.documentElement!)], []);
    expect([...selectorAll("body.bar")(document.documentElement!)], []);
  });

  test("selectorAll(null).call(element) always returns the empty array", () {
    document.body!.innerHTML =
        "<body class='foo'><undefined></undefined><null></null>";
    expect(selectorAll()(document.documentElement!), []);
    expect(selectorAll(null)(document.documentElement!), []);
  });

  test("selectorAll(null).call(element) returns a new empty array each time",
      () {
    final one = selectorAll()({}.jsify() as Element);
    final two = selectorAll()({}.jsify() as Element);
    expect(one == two, false);
    one.add(null);
    expect(selectorAll()({}.jsify() as Element), []);
  });
}
