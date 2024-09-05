part of 'selection.dart';

void dispatchEvent(Element node, String type, DispatchParams? params) {
  node.dispatchEvent(CustomEvent(
      type,
      CustomEventInit(detail: params?.detail)
        ..bubbles = params?.bubbles ?? false
        ..cancelable = params?.cancelable ?? false));
}

EachCallback<void> dispatchConstant(String type, DispatchParams? params) {
  return (thisArg, _, __, ___) {
    dispatchEvent(thisArg, type, params);
  };
}

EachCallback<void> dispatchFunction(
    String type, EachCallback<DispatchParams?> params) {
  return (thisArg, data, i, group) {
    dispatchEvent(thisArg, type, params(thisArg, data, i, group));
  };
}

/// {@category Handling events}
extension SelectionDispatch on Selection {
  /// Dispatches a [custom event][] of the specified *type* to each selected
  /// element, in order.
  ///
  /// [custom event]: http://www.w3.org/TR/dom/#interface-customevent
  ///
  /// ```dart
  /// d4.select("p".u21).dispatch("click");
  /// ```
  ///
  /// An optional *parameters* object may be specified to set additional
  /// properties of the event. It may contain the following fields:
  ///
  /// * [`bubbles`][] - if true, the event is dispatched to ancestors in reverse
  /// tree order.
  /// * [`cancelable`][] - if true, *event*.preventDefault is allowed.
  /// * [`detail`][] - any custom data associated with the event.
  ///
  /// [`bubbles`]: https://www.w3.org/TR/dom/#dom-event-bubbles
  /// [`cancelable`]: https://www.w3.org/TR/dom/#dom-event-cancelable
  /// [`detail`]: https://www.w3.org/TR/dom/#dom-customevent-detail
  ///
  /// If *parameters* is a function, it is evaluated for each selected element,
  /// in order, being passed the current datum (*d*), the current index (*i*),
  /// and the current group (*nodes*), with *thisArg* as the current DOM element
  /// (*nodes*\[*i*\]). It must return the parameters for the current element.
  Selection dispatch(String type,
      [Union2<EachCallback<DispatchParams?>, DispatchParams>? parameters]) {
    return each(
      parameters?.split(
            (callback) => dispatchFunction(type, callback),
            (params) => dispatchConstant(type, params),
          ) ??
          dispatchConstant(type, null),
    );
  }
}

typedef DispatchParams = ({bool bubbles, bool cancelable, JSAny? detail})?;
