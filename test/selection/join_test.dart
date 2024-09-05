import 'dart:js_interop';

import 'package:d4_selection/d4_selection.dart';
import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:test/test.dart';
import 'package:web/web.dart' hide Selection;

void main() {
  test("selection.join(name) enter-appends elements", () {
    document.body!.innerHTML = "";
    var p = select(document.body!.u22).selectAll("p".u22);
    p = p.dataBind([1, 3].map((d) => d.toJS).toList().u22).joind("p".u22)!
      ..textSet(((_, JSAny? d, __, ___) => d.dartify().toString()).u21);
    p;
    expect(document.body!.innerHTML, "<p>1</p><p>3</p>");
  });

  test("selection.join(name) exit-removes elements", () {
    document.body!.innerHTML = "<p>1</p><p>2</p><p>3</p>";
    var p = select(document.body!.u22).selectAll("p".u22);
    p = p.dataBind([1, 3].map((d) => d.toJS).toList().u22).joind("p".u22)!
      ..textSet(((_, JSAny? d, __, ___) => d.dartify().toString()).u21);
    p;
    expect(document.body!.innerHTML, "<p>1</p><p>3</p>");
  });

  test("selection.join(enter, update, exit) calls the specified functions", () {
    document.body!.innerHTML = "<p>1</p><p>2</p>";
    var p = select(document.body!.u22).selectAll("p".u22)
      ..datumSet((Element thisArg, _, __, ___) {
        return thisArg.textContent?.toJS;
      }.u21);
    p = p.dataBind([1, 3].map((d) => d.toJS).toList().u22,
        (_, JSAny? d, __, ___) => d.dartify().toString())
      ..joind(
          ((Selection enter) =>
                  (enter.append("p".u22)..attrSet("class", "enter".u22))
                    ..textSet(
                        ((_, JSAny? d, __, ___) => d.dartify().toString()).u21))
              .u21,
          (update) => update..attrSet("class", "update".u22),
          (exit) => exit.attrSet("class", "exit".u22));
    p;
    expect(document.body!.innerHTML,
        "<p class=\"update\">1</p><p class=\"exit\">2</p><p class=\"enter\">3</p>");
  });

  test("selection.join(…) reorders nodes to match the data", () {
    document.body!.innerHTML = "";
    var p = select(document.body!.u22).selectAll("p".u22);
    p = p
        .dataBind([1, 3].map((d) => d.toJS).toList().u22,
            (_, d, __, ___) => d.dartify().toString())
        .joind(((Selection enter) => enter.append("p".u22)
              ..textSet(((_, JSAny? d, __, ___) => d.dartify().toString()).u21))
            .u21)!;
    expect(document.body!.innerHTML, "<p>1</p><p>3</p>");
    p = p
        .dataBind([0, 3, 1, 2, 4].map((d) => d.toJS).toList().u22,
            (_, d, __, ___) => d.dartify().toString())
        .joind(((Selection enter) => enter.append("p".u22)
              ..textSet(((_, JSAny? d, __, ___) => d.dartify().toString()).u21))
            .u21)!;
    expect(
        document.body!.innerHTML, "<p>0</p><p>3</p><p>1</p><p>2</p><p>4</p>");
    p;
  });
}
