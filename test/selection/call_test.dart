import 'package:d4_selection/d4_selection.dart';
import 'package:extension_type_unions/extension_type_unions.dart';
import 'package:test/test.dart';
import 'package:web/web.dart' hide Selection;

void main() {
  test(
      "selection.call(function) calls the specified function, passing the selection",
      () {
    late Selection result;
    final s = select((document as Element).u22);
    expect(
        s
          ..call((s, [_]) {
            result = s;
          }),
        s);
    expect(result, s);
  });

  test(
      "selection.call(function, arguments…) calls the specified function, passing the additional arguments",
      () {
    var result = [];
    final foo = {};
    final bar = {};
    final s = select((document as Element).u22);
    expect(
        s
          ..call((s, [args]) {
            result.addAll([s, args![0], args[1]]);
          }, [foo, bar]),
        s);
    expect(result, [s, foo, bar]);
  });
}
