# Print personnel-selection utility objects

Formats and prints utility-analysis result objects of class
`psu_utility` and its subclasses (e.g., `psu_tr`, `psu_bcg`, `psu_ns`,
`psu_shp`, `psu_boudreau`, `psu_incremental_validity`,
`psu_monte_carlo`). Provides a concise textual summary of the computed
quantities.

## Usage

``` r
# S3 method for class 'psu_comparison'
print(x, ...)
```

## Arguments

- x:

  An object returned by one of the package's main analysis functions,
  with class `psu_utility` or a subclass thereof.

- ...:

  Currently ignored; reserved for compatibility with the
  [`print()`](https://rdrr.io/r/base/print.html) generic.

## Value

No return value, called for side effects (prints a formatted summary to
the console). The input object `x` is returned invisibly.
