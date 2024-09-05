import 'dart:html';

class ElementData {
  static final ElementData _instance = ElementData._internal();

  final Map<Element?, Object?> _data = {};

  factory ElementData() => _instance;

  ElementData._internal();

  void operator []=(Element? element, Object? data) => _data[element] = data;

  Object? operator [](Element? element) => _data[element];

  bool containsKey(Element? element) => _data.containsKey(element);
}
