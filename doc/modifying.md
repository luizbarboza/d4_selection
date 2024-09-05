After selecting elements, use the selection to modify the elements. For example, to set the class and color style of all paragraph elements in the current document:

```dart
d4
    .selectAll("p".u31)
    .attrSet("class", "graf".u22)
    .styleSet("color", "red".u22);
```

Selection methods typically return the current selection, or a new selection, allowing the concise application of multiple operations on a given selection via method chaining. The above is equivalent to:

```dart
final p = d4.selectAll("p".u31);
p.attrSet("class", "graf".u22);
p.styleSet("color", "red".u22);
```

Selections are immutable. All selection methods that affect which elements are selected (or their order) return a new selection rather than modifying the current selection. However, note that elements are necessarily mutable, as selections drive transformations of the document!