import 'package:d4_selection/d4_selection.dart';
import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:test/test.dart';
import 'package:web/web.dart';

void main() {
  test("selection.remove() removes selected elements from their parent", () {
    document.body!.innerHTML = "<h1 id='one'></h1><h1 id='two'></h1>";
    final one = document.querySelector("#one")!;
    final two = document.querySelector("#two")!;
    final s = selectAll([two, one].u32);
    expect(s..remove(), s);
    expect(one.parentNode, null);
    expect(two.parentNode, null);
  });

  test("selection.remove() skips elements that have already been detached", () {
    document.body!.innerHTML = "<h1 id='one'></h1><h1 id='two'></h1>";
    final one = document.querySelector("#one")!;
    final two = document.querySelector("#two")!;
    final s = selectAll([two, one].u32);
    one.parentNode!.removeChild(one);
    expect(s..remove(), s);
    expect(one.parentNode, null);
    expect(two.parentNode, null);
  });

  test("selection.remove() skips missing elements", () {
    document.body!.innerHTML = "<h1 id='one'></h1><h1 id='two'></h1>";
    final one = document.querySelector("#one")!;
    final two = document.querySelector("#two")!;
    final s = selectAll([null, one].u32);
    expect(s..remove(), s);
    expect(one.parentNode, null);
    expect(two.parentNode, document.body);
  });

  test("selectChildren().remove() removes all children", () {
    document.body!.innerHTML =
        "<div><span>0</span><span>1</span><span>2</span><span>3</span><span>4</span><span>5</span><span>6</span><span>7</span><span>8</span><span>9</span></div>";
    final p = document.querySelector("div")!;
    final selection = select(p.u22).selectChildren();
    expect(selection.size(), 10);
    expect(selection..remove(), selection);
    expect(select(p.u22).selectChildren().size(), 0);
  });
}
