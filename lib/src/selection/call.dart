part of 'selection.dart';

/// {@category Control flow}
extension SelectionCall on Selection {
  /// Invokes the specified *function* exactly once, passing in this selection
  /// along with any optional *arguments*. Returns this selection.
  ///
  /// This is equivalent to invoking the function by hand but facilitates method
  /// chaining. For example, to set several styles in a reusable function:
  ///
  /// ```dart
  /// void name(Selection selection, [List<Object?>?] arguments) {
  ///   selection
  ///       .attrSet("first-name", (arguments![0] as String).u22)
  ///       .attrSet("last-name", (arguments[1] as String).u22);
  /// }
  /// ```
  ///
  /// Now say:
  ///
  /// ```dart
  /// d4.selectAll("div".u31).call(name, ["John", "Snow"]);
  /// ```
  ///
  /// This is roughly equivalent to:
  ///
  /// ```dart
  /// name(d4.selectAll("div".u31), ["John", "Snow"]);
  /// ```
  ///
  /// The only difference is that *selection*.call always returns the
  /// *selection* and not the return value of the called *function*, `name`.
  Selection call(void Function(Selection, [List<Object?>?]) function,
      [List<Object?>? arguments]) {
    function(this, arguments);
    return this;
  }
}
