# Superseded AUC-to-r conversion

`auc_to_r()` is retained as a backward-compatible alias for
[`auc_to_point_biserial()`](https://rgempp.github.io/personnel-selection-utility/reference/auc_to_point_biserial.md)
with `base_rate = .50`. New code should use the more explicit conversion
family:
[`auc_to_rank_biserial()`](https://rgempp.github.io/personnel-selection-utility/reference/auc_to_rank_biserial.md),
[`auc_to_d_equal_variance()`](https://rgempp.github.io/personnel-selection-utility/reference/auc_to_d_equal_variance.md),
[`d_to_point_biserial()`](https://rgempp.github.io/personnel-selection-utility/reference/d_to_point_biserial.md),
and
[`auc_to_point_biserial()`](https://rgempp.github.io/personnel-selection-utility/reference/auc_to_point_biserial.md).

## Usage

``` r
auc_to_r(auc, base_rate = 0.5)
```

## Arguments

- auc:

  Area under the ROC curve. Must be in `(0, 1)` because AUC values of 0
  or 1 imply infinite d under the equal-variance binormal model.

- base_rate:

  Proportion in the focal or successful group, usually denoted \\p\\.
  Must be in `(0, 1)`. The default is `.50`.

## Value

Numeric vector of point-biserial correlations.

## References

Rice, M. E., & Harris, G. T. (2005). Comparing effect sizes in follow-up
studies: ROC area, Cohen's d, and r. *Law and Human Behavior*, 29(5),
615-620.

Salgado, J. F. (2018). Transforming the area under the normal curve
(AUC) into Cohen's d, Pearson's r_pb, odds-ratio, and natural log
odds-ratio: Two conversion tables. *The European Journal of Psychology
Applied to Legal Context*, 10(1), 35-47.

## Examples

``` r
# Backward-compatible alias; prefer auc_to_point_biserial().
auc_to_r(.75)
#> [1] 0.4304822
```
