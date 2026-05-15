# Print personnel-selection utility objects

Formats and prints utility-analysis result objects of class
`psu_utility` and its subclasses (e.g., `psu_tr`, `psu_bcg`, `psu_ns`,
`psu_shp`, `psu_boudreau`, `psu_incremental_validity`,
`psu_monte_carlo`). Provides a concise textual summary of the computed
quantities.

## Usage

``` r
# S3 method for class 'psu_sturman'
print(x, ...)

# S3 method for class 'psu_utility'
print(x, ...)

# S3 method for class 'psu_tr'
print(x, ...)

# S3 method for class 'psu_bcg'
print(x, ...)

# S3 method for class 'psu_ns'
print(x, ...)

# S3 method for class 'psu_shp'
print(x, ...)

# S3 method for class 'psu_boudreau'
print(x, ...)

# S3 method for class 'psu_incremental_validity'
print(x, ...)

# S3 method for class 'psu_monte_carlo'
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
