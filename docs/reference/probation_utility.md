# Utility with a probation-period survivor adjustment

A compact helper for selection systems where year 1 utility follows BCG
and later periods include an additional survivor-performance gain caused
by a probation cutoff.

## Usage

``` r
probation_utility(
  validity,
  selection_ratio,
  sdy,
  n_selected,
  tenure,
  probation_cutoff_z,
  cost = 0
)
```

## Arguments

- validity:

  Predictor-criterion validity.

- selection_ratio:

  Selection ratio.

- sdy:

  Standard deviation of job performance in monetary units.

- n_selected:

  Number of selected applicants in period 1.

- tenure:

  Total number of periods.

- probation_cutoff_z:

  Standardized criterion cutoff used after probation.

- cost:

  Total cost.

## Value

A `psu_bcg` object.

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
probation_utility(.35, .20, 50000, 100, tenure = 3, probation_cutoff_z = -1)
#> <psu_bcg>
#>   validity: 0.35
#>   selection_ratio: 0.2
#>   baseline_validity: 0
#>   baseline_selection_ratio: 0.2
#>   selected_mean_z: 1.39981
#>   baseline_selected_mean_z: 1.39981
#>   focal_expected_criterion_z: 0.489933
#>   baseline_expected_criterion_z: 0
#>   incremental_criterion_z: 0.489933
#>   sdy: 50000
#>   n_selected: 100
#>   tenure: 3
#>   cost: 0
#>   gross_utility: 5325670
#>   net_utility: 5325670
#>   probation_cutoff_z: -1
#>   survivor_expected_criterion_z: 0.2876
```
