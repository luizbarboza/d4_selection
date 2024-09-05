import 'package:d4_selection/d4_selection.dart';
import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:test/test.dart';
import 'package:web/web.dart' hide Selection;

import '../equals_selection.dart';

void main() {
  test("select.selectChild(…) selects the first (matching) child", () {
    document.body!.innerHTML =
        "<h1><span>hello</span>, <span>world<span>!</span></span></h1>";
    final s = select((document as Element).u22).select("h1".u22);
    expect(s.selectChild(((_, __, ___) => true).u21), isA<Selection>());
    expect(s.selectChild(((_, __, ___) => true).u21),
        EqualsSelection(s.select("*".u22)));
    expect(s.selectChild(), isA<Selection>());
    expect(s.selectChild("*".u22), isA<Selection>());
    expect(s.selectChild("*".u22), EqualsSelection(s.select("*".u22)));
    expect(s.selectChild(), EqualsSelection(s.select("*".u22)));
    expect(s.selectChild("div".u22), EqualsSelection(s.select("div".u22)));
    expect(s.selectChild("span".u22).textGet(), "hello");
  });

  test("selectAll.selectChild(…) selects the first (matching) child", () {
    document.body!.innerHTML =
        "<div><span>hello</span>, <span>world<span>!</span></span></div><div><span>hello2</span>, <span>world2<span>!2</span></span></div>";
    final s = select((document as Element).u22).selectAll("div".u22);
    expect(s.selectChild(((_, __, ___) => true).u21), isA<Selection>());
    expect(s.selectChild(((_, __, ___) => true).u21),
        EqualsSelection(s.select("*".u22)));
    expect(s.selectChild(), isA<Selection>());
    expect(s.selectChild("*".u22), isA<Selection>());
    expect(s.selectChild("*".u22), EqualsSelection(s.select("*".u22)));
    expect(s.selectChild(), EqualsSelection(s.select("*".u22)));
    expect(s.selectChild("div".u22), EqualsSelection(s.select("div".u22)));
    expect(s.selectChild("span".u22).textGet(), "hello");
  });

  test("select.selectChildren(…) selects the matching children", () {
    document.body!.innerHTML =
        "<h1><span>hello</span>, <span>world<span>!</span></span></h1>";
    final s = select((document as Element).u22).select("h1".u22);
    expect(s.selectChildren("*".u22), isA<Selection>());
    expect(s.selectChildren("*".u22).textGet(), "hello");
    expect(s.selectChildren().size(), 2);
    expect(s.selectChildren("*".u22).size(), 2);
    expect(s.selectChildren(), EqualsSelection(s.selectChildren("*".u22)));
    expect(s.selectChildren("span".u22).size(), 2);
    expect(s.selectChildren("div".u22).size(), 0);
  });

  test("selectAll.selectChildren(…) selects the matching children", () {
    document.body!.innerHTML =
        "<div><span>hello</span>, <span>world<span>!</span></span></div><div><span>hello2</span>, <span>world2<span>!2</span></span></div>";
    final s = select((document as Element).u22).selectAll("div".u22);
    expect(s.selectChildren("*".u22), isA<Selection>());
    expect(s.selectChildren("*".u22).textGet(), "hello");
    expect(s.selectChildren().size(), 4);
    expect(s.selectChildren("*".u22).size(), 4);
    expect(s.selectChildren(), EqualsSelection(s.selectChildren("*".u22)));
    expect(s.selectChildren("span".u22).size(), 4);
    expect(s.selectChildren("div".u22).size(), 0);
  });
}
