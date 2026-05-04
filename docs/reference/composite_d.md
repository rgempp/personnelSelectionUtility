# Composite effect size for a weighted predictor battery

Computes Sackett-Ellingson-style composite d for a weighted battery.

## Usage

``` r
composite_d(d, weights = NULL, predictor_cor = NULL, sd = NULL)
```

## Arguments

- d:

  Vector of standardized group differences or effect sizes.

- weights:

  Composite weights. Defaults to equal weights.

- predictor_cor:

  Predictor correlation matrix. Defaults to identity.

- sd:

  Predictor standard deviations. Defaults to ones.

## Value

Composite effect size.

## References

Sackett, P. R., & Ellingson, J. E. (1997). The effects of forming multi-
predictor composites on group differences and adverse impact. Personnel
Psychology, 50, 707-721.

## Examples

``` r
# Literature: Sackett and Ellingson (1997).
composite_d(d = c(.80, .30), weights = c(.7, .3),
            predictor_cor = matrix(c(1, .30, .30, 1), 2, 2))
#> [1] 0.7735903
```
