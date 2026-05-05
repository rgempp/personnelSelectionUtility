# Expected standardized performance after a probation cutoff

Computes the mean of a standard normal criterion among employees
surviving a probation rule `Y >= probation_cutoff_z`.

## Usage

``` r
probation_adjustment(probation_cutoff_z)
```

## Arguments

- probation_cutoff_z:

  Probation cutoff on the standardized criterion.

## Value

Expected standardized criterion score among survivors.

## References

De Corte, W. (1994). Utility analysis for the one-cohort
selection-retention decision with a probationary period. Journal of
Applied Psychology, 79, 402-411.

Sturman, M. C. (2001). Utility analysis for multiple selection devices
and multiple outcomes. Journal of Human Resource Costing and Accounting,
6(2), 9-28.

## Examples

``` r
# Literature: De Corte (1994); Sturman (2001).
probation_adjustment(-1)
#> [1] 0.2876
```
