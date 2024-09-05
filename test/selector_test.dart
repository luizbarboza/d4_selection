import 'package:d4_selection/d4_selection.dart';
import 'package:test/test.dart';
import 'package:web/web.dart';

void main() {
  test(
      "selector(selector).call(element) returns the first element that matches the selector",
      () {
    document.documentElement!.innerHTML = "<body class='foo'>";
    expect(selector("body")(document.documentElement!), document.body);
    expect(selector(".foo")(document.documentElement!), document.body);
    expect(selector("body.foo")(document.documentElement!), document.body);
    expect(selector("h1")(document.documentElement!), null);
    expect(selector("body.bar")(document.documentElement!), null);
  });

  test("selector(null).call(element) always returns undefined", () {
    document.body!.innerHTML =
        "<body class='foo'><undefined></undefined><null></null>";
    expect(selector()(document.documentElement!), null);
    expect(selector(null)(document.documentElement!), null);
  });
}
