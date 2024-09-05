XML namespaces are fun! Right? 🤪 Fortunately you can mostly ignore them.

A case where you need to specify them is when appending an element to a parent that belongs to a different namespace; typically, to create a [div][] inside a SVG [foreignObject][] element:

[div]: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/div
[foreignObject]: https://developer.mozilla.org/en-US/docs/Web/SVG/Element/ForeignObject

```dart
d4
    .create("svg")
    .append("foreignObject".u22)
    .attrSet("width", 300.toString().u22)
    .attrSet("height", 100.toString().u22)
    .append("xhtml:div".u22)
    .textSet("Hello, HTML!".u22);
```