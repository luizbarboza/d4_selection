import 'package:d4_selection/src/selection/selection.dart';
import 'package:test/test.dart';

class EqualsSelection extends CustomMatcher {
  EqualsSelection(Object selection)
      : super("Selection that is equal to", "selection",
            equals(selectionToMap(selection)));

  @override
  Object? featureValueOf(actual) {
    return selectionToMap(actual);
  }
}

Map<String, Object?> selectionToMap(Object s) {
  return s is Selection
      ? ({
          "groups": s.groups,
          "parents": s.parents,
          "enter": s.enterr,
          "exit": s.exitt
        })
      : ((s as Map)
            ..["parents"] =
                s["parents"] ?? List.filled((s["groups"] as List).length, null)
            ..["enter"] = s["enter"]
            ..["exit"] = s["exit"])
          .cast();
}
