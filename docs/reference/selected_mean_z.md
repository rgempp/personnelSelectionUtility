# Expected standardized predictor score among selected applicants

Computes the mean of a standard normal predictor after top-down
selection at a given selection ratio:
`dnorm(qnorm(1 - selection_ratio)) / selection_ratio`.

## Usage

``` r
selected_mean_z(selection_ratio)
```

## Arguments

- selection_ratio:

  Proportion of applicants selected. Must be in `(0, 1)`.

## Value

Numeric vector with expected standardized predictor scores.

## References

Naylor, J. C., & Shine, L. C. (1965). A table for determining the
increase in mean criterion score obtained by using a selection device.
Journal of Industrial Psychology, 3, 33-42.

## Examples

``` r
# Literature: Naylor and Shine (1965).
selected_mean_z(c(.10, .20, .50))
#> [1] 1.7549833 1.3998096 0.7978846
```
