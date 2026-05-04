# Convert Cohen's d to a point-biserial correlation

Converts a standardized mean difference to the point-biserial
correlation implied by a dichotomous criterion with base rate \\p\\. The
implemented formula is \\r\_{pb} = d\sqrt{p(1-p)} / \sqrt{1 +
d^2p(1-p)}\\. When `base_rate = .50`, this reduces to the common
equal-group conversion \\r = d / \sqrt{d^2 + 4}\\.

## Usage

``` r
d_to_point_biserial(d, base_rate = 0.5)
```

## Arguments

- d:

  Cohen's d. Must be numeric and finite.

- base_rate:

  Proportion in the focal or successful group, usually denoted \\p\\.
  Must be in `(0, 1)`. The default is `.50`.

## Value

Numeric vector of point-biserial correlations.

## References

Cohen, J. (1988). *Statistical power analysis for the behavioral
sciences* (2nd ed.). Erlbaum.

Rice, M. E., & Harris, G. T. (2005). Comparing effect sizes in follow-up
studies: ROC area, Cohen's d, and r. *Law and Human Behavior*, 29(5),
615-620.

Salgado, J. F. (2018). Transforming the area under the normal curve
(AUC) into Cohen's d, Pearson's r_pb, odds-ratio, and natural log
odds-ratio: Two conversion tables. *The European Journal of Psychology
Applied to Legal Context*, 10(1), 35-47.

## Examples

``` r
# Minimal example: equal base-rate conversion equals d_to_cor().
d_to_point_biserial(.50, base_rate = .50)
#> [1] 0.2425356
d_to_cor(.50)
#> [1] 0.2425356

# Unequal base rates reduce the attainable point-biserial correlation.
d_to_point_biserial(.50, base_rate = c(.50, .20, .10))
#> [1] 0.2425356 0.1961161 0.1483405
```
