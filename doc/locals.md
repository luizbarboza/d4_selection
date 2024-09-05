D4 locals allow you to define local state independent of data. For instance, when rendering [small multiples][] of time-series data, you might want the same x scale for all charts but distinct y scales to compare the relative performance of each metric. D4 locals are scoped by DOM elements: on set, the value is stored on the given element; on get, the value is retrieved from given element or the nearest ancestor that defines it.

[small multiples]: https://gist.github.com/mbostock/e1192fe405703d8321a5187350910e08

> [!CAUTION]
> Locals are rarely used; you may find it easier to store whatever state you need in the selection’s data.