import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:web/web.dart';

List<Element?> list(Union2<Iterable<Element?>, Object>? x) {
  return x?.split(
        (iterable) => iterable.toList(),
        (object) => [
          for (var i = 0;
              i < ((object as JSObject)["length"] as JSNumber).toDartInt;
              i++)
            object[i.toString()] as Element?
        ],
      ) ??
      [];
}
