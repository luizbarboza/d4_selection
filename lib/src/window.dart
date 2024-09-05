import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:web/web.dart';

/// Returns the owner window for the specified *node*.
///
/// If *node* is a node, returns the owner document’s default view; if *node* is
/// a document, returns its default view; otherwise returns the *node*.
///
/// {@category Selecting elements}
Window window(EventTarget node) {
  return ((node as JSObject)["ownerDocument"] != null
      ? (node as Node).ownerDocument!.defaultView! // node is a Node
      : (node as JSObject)["document"] != null
          ? node as Window // node is a Window
          : (node as Document).defaultView!); // node is a Document
}
