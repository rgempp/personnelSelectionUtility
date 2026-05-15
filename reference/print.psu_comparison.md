# Print personnel-selection model comparison objects

Formats and prints model-comparison result objects of class
`psu_comparison`. Displays the top-level scalar quantities and, when
present, the per-subsystem summaries (compensatory and multiple-hurdle).

## Usage

``` r
# S3 method for class 'psu_comparison'
print(x, ...)
```

## Arguments

- x:

  An object of class `psu_comparison`, typically returned by
  [`compare_selection_systems()`](https://rgempp.github.io/personnelSelectionUtility/reference/compare_selection_systems.md)
  or related functions.

- ...:

  Currently ignored; reserved for compatibility with the
  [`print()`](https://rdrr.io/r/base/print.html) generic.

## Value

No return value, called for side effects (prints a formatted summary to
the console). The input object `x` is returned invisibly.
