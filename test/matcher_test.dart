import 'package:d4_selection/d4_selection.dart';
import 'package:test/test.dart';
import 'package:web/web.dart';

void main() {
  test(
      "matcher(selector).call(element) returns true if the element matches the selector",
      () {
    document.documentElement!.innerHTML = "<body class='foo'>";
    expect(matcher("body")(document.body!), true);
    expect(matcher(".foo")(document.body!), true);
    expect(matcher("body.foo")(document.body!), true);
    expect(matcher("h1")(document.body!), false);
    expect(matcher("body.bar")(document.body!), false);
  });
}
