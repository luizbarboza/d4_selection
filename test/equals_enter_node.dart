import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:d4_selection/src/selection/selection.dart';
import 'package:test/test.dart';
import 'package:web/web.dart';

class EqualsEnterNode extends CustomMatcher {
  EqualsEnterNode(Object enterNode)
      : super("EnterNode that is equal to", "enterNode",
            equals(enterNodeToMap(enterNode)));

  @override
  Object? featureValueOf(actual) {
    return enterNodeToMap(actual);
  }
}

Map<String, Object?> enterNodeToMap(Object e) {
  return {
    "namespaceURI": (e as JSObject)["namespaceURI"],
    "parent": e["__parent__"],
    "next": e["__next__"],
    "data": e["__data__"]
  };
}

Element enterNode(Object? parent, JSAny? data, [Object? next]) {
  if (parent is String) parent = document.querySelector(parent);
  if (next is String) next = document.querySelector(next);
  final node = enternode(parent as Element, data);
  (node as JSObject)["__next__"] = next as JSObject?;
  return node;
}
