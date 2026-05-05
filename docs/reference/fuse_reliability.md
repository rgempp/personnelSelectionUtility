# Reliability of a weighted composite (Mosier, 1943; Lord & Novick, 1968)

Reliability of a weighted composite (Mosier, 1943; Lord & Novick, 1968)

## Usage

``` r
fuse_reliability(weights, item_cor, item_reliabilities = NULL)
```

## Arguments

- weights:

  Numeric vector of composite weights.

- item_cor:

  Symmetric correlation (or covariance) matrix among items.

- item_reliabilities:

  Numeric vector of item reliabilities (length equal to `weights`). If
  `NULL`, the composite reliability is computed under the assumption
  that diagonal entries of `item_cor` are item reliabilities (e.g., when
  an empirical reliability matrix is supplied).

## Value

The reliability of the weighted composite.

## References

Lord, F. M., & Novick, M. R. (1968). *Statistical theories of mental
test scores*. Addison-Wesley.

Mosier, C. I. (1943). On the reliability of a weighted composite.
*Psychometrika*, 8, 161-168.

## Examples

``` r
R <- matrix(c(1, .3, .3, 1), 2, 2)
fuse_reliability(c(.5, .5), R, item_reliabilities = c(.80, .85))
#> [1] 0.8653846
```
