part of 'selection.dart';

void Function(Event) contextListener(JSExportedDartFunction listener) {
  return (Event event) {
    final thisArg = event.target;
    listener.callAsFunction(null, thisArg as JSObject, event as JSObject,
        (thisArg as JSObject)["__data__"]);
  };
}

Iterable<Map<String, String>> parseTypenames(String typenames) {
  return typenames.trim().split(RegExp(r'^|\s+')).map((t) {
    var name = "", i = t.indexOf(".");
    if (i >= 0) {
      name = t.substring(i + 1);
      t = t.substring(0, i);
    }
    return {"type": t, "name": name};
  });
}

EachCallback<void> onRemove(JSObject typename, OnListener? _, JSAny? __) {
  return (thisArg, _, __, ___) {
    var on = (thisArg as JSObject)["__on"] as JSArray<JSObject>?;
    if (on == null) return;
    JSObject o;
    var i = -1;
    for (var j = 0, m = (on["length"] as JSNumber).toDartInt; j < m; ++j) {
      final j0 = j.toString();
      o = on[j0] as JSObject;
      if ((typename["type"] == "".toJS || o["type"] == typename["type"]) &&
          o["name"] == typename["name"]) {
        var ooptions = o["options"];
        ooptions != null
            ? thisArg.removeEventListener((o["type"] as JSString).toDart,
                (o["listener"] as JSFunction), ooptions)
            : thisArg.removeEventListener(
                (o["type"] as JSString).toDart, (o["listener"] as JSFunction));
      } else {
        on[(++i).toString()] = o;
      }
    }
    if (++i > 0) {
      on["length"] = i.toJS;
    } else {
      (thisArg as JSObject).delete("__on".toJS);
    }
  };
}

EachCallback<void> onAdd(JSObject typename, OnListener? value, JSAny? options) {
  return (thisArg, data, i, group) {
    var on = (thisArg as JSObject)["__on"] as JSArray<JSObject>?;
    JSObject o;
    JSFunction listener = contextListener(value!.toJS).toJS;
    if (on != null) {
      for (var j = 0, m = (on["length"] as JSNumber).toDartInt; j < m; ++j) {
        final j0 = j.toString();
        if ((o = on[j0] as JSObject)["type"] == typename["type"] &&
            o["name"] == typename["name"]) {
          var options0 = o["options"];
          options0 != null
              ? thisArg.removeEventListener((o["type"] as JSString).toDart,
                  (o["listener"] as JSFunction), options0)
              : thisArg.removeEventListener((o["type"] as JSString).toDart,
                  (o["listener"] as JSFunction));
          o["options"] = options;
          options != null
              ? thisArg.addEventListener((o["type"] as JSString).toDart,
                  o["listener"] = listener, options)
              : thisArg.addEventListener(
                  (o["type"] as JSString).toDart, o["listener"] = listener);
          o["value"] = value.toJSBox;
          return;
        }
      }
    }
    options != null
        ? thisArg.addEventListener(
            (typename["type"] as JSString).toDart, listener, options)
        : thisArg.addEventListener(
            (typename["type"] as JSString).toDart, listener);
    o = {
      "type": typename["type"],
      "name": typename["name"],
      "value": value.toJSBox,
      "listener": listener,
      "options": options
    }.jsify() as JSObject;
    if (on == null) {
      (thisArg as JSObject)["__on"] = [o].toJS;
    } else {
      on.callMethod("push".toJS, o);
    }
  };
}

/// {@category Handling events}
extension SelectionOn on Selection {
  /// Returns the currently-assigned listener for the specified event *typename*
  /// on the first (non-null) selected element, if any.
  ///
  /// If multiple typenames are specified, the first matching listener is
  /// returned.
  OnListener? onGet(String typename) {
    var typenames = parseTypenames(typename);

    var on = (node() as JSObject?)?["__on"] as JSArray<JSObject>?;
    if (on != null) {
      for (var j = 0, m = (on["length"] as JSNumber).toDartInt; j < m; ++j) {
        final o = on[j.toString()] as JSObject;
        for (final t in typenames) {
          if (t["type"]!.toJS == o["type"] && t["name"]!.toJS == o["name"]) {
            return (o["value"] as JSBoxedDartObject).toDart as OnListener;
          }
        }
      }
    }
    return null;
  }

  /// Adds or removes a *listener* to each selected element for the specified
  /// event *typenames*.
  ///
  /// ```dart
  /// d4.selectAll("p".u31).onBind(
  ///     "click", (EventTarget? thisArg, Event event, JSAny? d) => print(event));
  /// ```
  ///
  /// The *typenames* is a string event type, such as `click`, `mouseover`, or
  /// `submit`; any [DOM event type][] supported by your browser may be used.
  /// The type may be optionally followed by a period (`.`) and a name; the
  /// optional name allows multiple callbacks to be registered to receive events
  /// of the same type, such as `click.foo` and `click.bar`. To specify multiple
  /// typenames, separate typenames with spaces, such as `input change` or
  /// `click.foo click.bar`.
  ///
  /// [DOM event type]: https://developer.mozilla.org/en-US/docs/Web/Events#Standard_events
  ///
  /// When a specified event is dispatched on a selected element, the specified
  /// *listener* will be evaluated for the element, being passed the current
  /// event (*event*) and the current datum (*d*), with *thisArg* as the current
  /// DOM element (*event*.currentTarget). Listeners always see the latest datum
  /// for their element. Note: while you can use [*event*.pageX][] and
  /// [*event*.pageY][] directly, it is often convenient to transform the event
  /// position to the local coordinate system of the element that received the
  /// event using [d4.pointer][].
  ///
  /// [*event*.pageX]: https://developer.mozilla.org/en/DOM/event.pageX
  /// [*event*.pageY]: https://developer.mozilla.org/en/DOM/event.pageY
  /// [d4.pointer]: https://pub.dev/documentation/d4_selection/latest/d4_selection/pointer.html
  ///
  /// If an event listener was previously registered for the same *typename* on
  /// a selected element, the old listener is removed before the new listener is
  /// added. To remove a listener, pass null as the *listener*. To remove all
  /// listeners for a given name, pass null as the *listener* and `.foo` as the
  /// *typename*, where `foo` is the name; to remove all listeners with no name,
  /// specify `.` as the *typename*.
  ///
  /// An optional *options* object may specify characteristics about the event
  /// listener, such as whether it is capturing or passive; see
  /// [*element*.addEventListener][].
  ///
  /// [*element*.addEventListener]: https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/addEventListener
  Selection onBind(String typename, OnListener? listener, [JSAny? options]) {
    var typenames = parseTypenames(typename);

    final on = listener != null ? onAdd : onRemove;
    for (final t in typenames) {
      each(on(t.jsify() as JSObject, listener, options));
    }
    return this;
  }
}

typedef OnListener = void Function(EventTarget?, Event, JSAny?);
