import 'dart:js_interop';

import 'package:d4_selection/d4_selection.dart';
import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:test/test.dart';
import 'package:web/web.dart';

void main() {
  test(
      "selection.dispatch(type) dispatches a custom event of the specified type to each selected element in order",
      () {
    document.body!.innerHTML = "<h1 id='one'></h1><h1 id='two'></h1>";
    late CustomEvent event;
    final result = [];
    final one = document.querySelector("#one");
    final two = document.querySelector("#two");
    final selection =
        (selectAll([one, two].u32)..datumSet(((_, __, i, ___) => "node-$i".toJS).u21))
          ..onBind("bang", (thisArg, e, d) {
            event = e as CustomEvent;
            result.addAll([thisArg, d]);
          });
    expect(selection..dispatch("bang"), selection);
    expect(result, [one, "node-0", two, "node-1"]);
    expect(event.type, "bang");
    expect(event.bubbles, false);
    expect(event.cancelable, false);
    expect(event.detail, null);
  });

  test(
      "selection.dispatch(type, params) dispatches a custom event with the specified constant parameters",
      () {
    document.body!.innerHTML = "<h1 id='one'></h1><h1 id='two'></h1>";
    late CustomEvent event;
    final result = [];
    final one = document.querySelector("#one");
    final two = document.querySelector("#two");
    final selection =
        (selectAll([one, two].u32)..datumSet(((_, __, i, ___) => "node-$i".toJS).u21))
          ..onBind("bang", (thisArg, e, d) {
            event = e as CustomEvent;
            result.addAll([thisArg, d]);
          });
    expect(
        selection
          ..dispatch("bang",
              (bubbles: true, cancelable: true, detail: "loud".toJS).u22),
        selection);
    expect(result, [one, "node-0", two, "node-1"]);
    expect(event.type, "bang");
    expect(event.bubbles, true);
    expect(event.cancelable, true);
    expect(event.detail, "loud");
  });

  test(
      "selection.dispatch(type, function) dispatches a custom event with the specified parameter function",
      () {
    document.body!.innerHTML = "<h1 id='one'></h1><h1 id='two'></h1>";
    final result = [];
    final events = <CustomEvent>[];
    final one = document.querySelector("#one");
    final two = document.querySelector("#two");
    final selection =
        (selectAll([one, two].u32)..datumSet(((_, __, i, ___) => "node-$i".toJS).u21))
          ..onBind("bang", (thisArg, e, d) {
            events.add(e as CustomEvent);
            result.addAll([thisArg, d]);
          });
    expect(
        selection
          ..dispatch(
              "bang",
              ((_, __, i, ___) => (
                    bubbles: true,
                    cancelable: true,
                    detail: "loud-$i".toJS
                  )).u21),
        selection);
    expect(result, [one, "node-0", two, "node-1"]);
    expect(events[0].type, "bang");
    expect(events[0].bubbles, true);
    expect(events[0].cancelable, true);
    expect(events[0].detail, "loud-0");
    expect(events[1].type, "bang");
    expect(events[1].bubbles, true);
    expect(events[1].cancelable, true);
    expect(events[1].detail, "loud-1");
  });

  test("selection.dispatch(type) skips missing elements", () {
    document.body!.innerHTML = "<h1 id='one'></h1><h1 id='two'></h1>";
    late CustomEvent event;
    final result = [];
    final one = document.querySelector("#one");
    final two = document.querySelector("#two");
    final selection =
        (selectAll([null, one, null, two].u32)..datumSet(((_, __, i, ___) => "node-$i".toJS).u21))
          ..onBind("bang", (thisArg, e, d) {
            event = e as CustomEvent;
            result.addAll([thisArg, d]);
          });
    expect(selection..dispatch("bang"), selection);
    expect(result, [one, "node-1", two, "node-3"]);
    expect(event.type, "bang");
    expect(event.detail, null);
  });
}
