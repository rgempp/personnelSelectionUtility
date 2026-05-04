# Johnson relative weights for one criterion

Computes approximate relative weights for correlated predictors in a
multiple regression with one criterion.

## Usage

``` r
relative_weights(predictor_cor, criterion_cor)
```

## Arguments

- predictor_cor:

  Predictor correlation matrix.

- criterion_cor:

  Vector of predictor-criterion correlations.

## Value

A data frame with raw and rescaled relative weights.

## References

Johnson, J. W. (2000). A heuristic method for estimating the relative
weight of predictor variables in multiple regression. Multivariate
Behavioral Research, 35, 1-19.

## Examples

``` r
# Literature: Johnson (2000).
relative_weights(matrix(c(1, .30, .30, 1), 2, 2), c(.40, .30))
#>   predictor raw_weight rescaled_weight percent_of_r2
#> 1         1  0.1328022       0.1328022      67.89326
#> 2         2  0.0628022       0.0628022      32.10674
```
