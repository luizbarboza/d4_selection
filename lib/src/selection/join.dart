part of 'selection.dart';

/// {@category Joining data}
extension SelectionJoin on Selection {
  /// Appends, removes and reorders elements as necessary to match the data that
  /// was previously bound by [*selection*.dataBind][], returning the [merged][]
  /// enter and update selection.
  ///
  /// [*selection*.dataBind]: https://pub.dev/documentation/d4_selection/latest/d4_selection/SelectionData/dataBind.html
  /// [merged]: https://pub.dev/documentation/d4_selection/latest/d4_selection/SelectionMerge/merge.html
  ///
  /// This method is a convenient alternative to the explicit
  /// [general update pattern][], replacing [*selection*.enter][],
  /// [*selection*.exit][], [*selection*.append][], [*selection*.remove][], and
  /// [*selection*.order][]. For example:
  ///
  /// [general update pattern]: https://observablehq.com/@d3/general-update-pattern
  /// [*selection*.enter]: https://pub.dev/documentation/d4_selection/latest/d4_selection/SelectionEnter/enter.html
  /// [*selection*.exit]: https://pub.dev/documentation/d4_selection/latest/d4_selection/SelectionExit/exit.html
  /// [*selection*.append]: https://pub.dev/documentation/d4_selection/latest/d4_selection/SelectionAppend/append.html
  /// [*selection*.remove]: https://pub.dev/documentation/d4_selection/latest/d4_selection/SelectionRemove/remove.html
  /// [*selection*.order]: https://pub.dev/documentation/d4_selection/latest/d4_selection/SelectionOrder/order.html
  ///
  /// ```dart
  /// svg
  ///     .selectAll("circle".u22)
  ///     .dataBind(data.u22)
  ///     .joind("circle".u22)!
  ///     .attrSet("fill", "none".u22)
  ///     .attrSet("stroke", "black".u22);
  /// ```
  ///
  /// The *enter* function may be specified as a string shorthand, as above,
  /// which is equivalent to [*selection*.append][] with the given element name.
  /// Likewise, optional *update* and *exit* functions may be specified, which
  /// default to the identity function and calling [*selection*.remove][],
  /// respectively. The shorthand above is thus equivalent to:
  ///
  /// [*selection*.append]: https://pub.dev/documentation/d4_selection/latest/d4_selection/SelectionAppend/append.html
  /// [*selection*.remove]: https://pub.dev/documentation/d4_selection/latest/d4_selection/SelectionRemove/remove.html
  ///
  /// ```dart
  /// svg
  ///     .selectAll("circle".u22)
  ///     .dataBind(data.u22)
  ///     .joind(
  ///       ((Selection enter) => enter.append("circle".u22)).u21,
  ///       (Selection update) => update,
  ///       (Selection exit) => exit.remove(),
  ///     )!
  ///     .attrSet("fill", "none".u22)
  ///     .attrSet("stroke", "black".u22);
  /// ```
  ///
  /// By passing separate functions on enter, update and exit, you have greater
  /// control over what happens. And by specifying a key function to
  /// [*selection*.dataBind][], you can minimize changes to the DOM to optimize
  /// performance. For example, to set different fill colors for enter and
  /// update:
  ///
  /// [*selection*.dataBind]: https://pub.dev/documentation/d4_selection/latest/d4_selection/SelectionData/dataBind.html
  ///
  /// ```dart
  /// svg
  ///     .selectAll("circle".u22)
  ///     .dataBind(data.u22)
  ///     .joind(
  ///       ((Selection enter) =>
  ///           enter.append("circle".u22).attrSet("fill", "green".u22)).u21,
  ///       (Selection update) => update.attrSet("fill", "blue".u22),
  ///     )!
  ///     .attrSet("stroke", "black".u22);
  /// ```
  ///
  /// The selections returned by the *enter* and *update* functions are merged
  /// and then returned by *selection*.joind.
  ///
  /// You can animate enter, update and exit by creating transitions inside the
  /// *enter*, *update* and *exit* functions. If the *enter* and *update*
  /// functions return transitions, their underlying selections are merged and
  /// then returned by *selection*.joind. The return value of the *exit*
  /// function is not used.
  ///
  /// For more, see the [*selection*.join notebook][].
  ///
  /// [*selection*.join notebook]: https://observablehq.com/@d3/selection-join
  Selection? joind(
    Union2<Selection? Function(Selection), String> onenter, [
    Selection? Function(Selection)? onupdate,
    void Function(Selection)? onexit,
  ]) {
    Selection? enter = this.enter(), update = this, exit = this.exit();
    onenter?.split(
      (onenter) => enter = onenter(enter!)?.selection(),
      (type) => enter = enter!.append(type.u22),
    );
    if (onupdate != null) update = onupdate(update)?.selection();
    if (onexit == null) {
      exit.remove();
    } else {
      onexit(exit);
    }
    return enter != null && update != null
        ? (enter!.merge(update)..order())
        : update;
  }
}
