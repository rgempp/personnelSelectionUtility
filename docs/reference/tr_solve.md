# Solve one Taylor-Russell parameter from the other three

Solves for one missing Taylor-Russell parameter among base rate,
selection ratio, validity, and PPV. Exactly one of the four arguments
must be `NULL`. The default validity interval is non-negative to match
the classical Taylor-Russell table convention and the defensive behavior
of the
[`TaylorRussell::TR()`](https://rdrr.io/pkg/TaylorRussell/man/TR.html)
implementation.

## Usage

``` r
tr_solve(
  base_rate = NULL,
  selection_ratio = NULL,
  validity = NULL,
  ppv = NULL,
  interval = NULL,
  tol = 1e-08,
  allow_negative_validity = FALSE
)
```

## Arguments

- base_rate:

  Population proportion of successful applicants.

- selection_ratio:

  Proportion selected.

- validity:

  Predictor-criterion correlation.

- ppv:

  Positive predictive value / success ratio among selected applicants.

- interval:

  Search interval for the missing parameter.

- tol:

  Numerical tolerance passed to
  [`optimize()`](https://rdrr.io/r/stats/optimize.html).

- allow_negative_validity:

  Logical. Should the solver allow negative validity when
  `validity = NULL`? Defaults to `FALSE`.

## Value

A `psu_tr` object containing the solved parameter and the resulting
Taylor-Russell table.

## References

Taylor, H. C., & Russell, J. T. (1939). The relationship of validity
coefficients to the practical effectiveness of tests in selection.
Journal of Applied Psychology, 23, 565-578.

Waller, N. G. (2024). TaylorRussell: A Taylor-Russell function for
multiple predictors (R package version 1.2.1). CRAN.

## Examples

``` r
# Literature: Taylor and Russell (1939); Waller (2024).
# Use the first call as a minimal example; the longer block illustrates
# how to interpret the function in the substantive setting discussed in the literature.
# Minimal example: solve validity from desired PPV.
tr_solve(base_rate = .50, selection_ratio = .20, validity = NULL, ppv = .70)
#> <psu_tr>
#>   base_rate: 0.5
#>   selection_ratio: 0.2
#>   validity: 0.356075
#>   predictor_cutoff_z: 0.841621
#>   criterion_cutoff_z: 0
#>   true_positive: 0.14
#>   false_positive: 0.06
#>   false_negative: 0.36
#>   true_negative: 0.44
#>   ppv: 0.7
#>   success_ratio: 0.7
#>   incremental_success: 0.2
#>   sensitivity: 0.28
#>   specificity: 0.88
#>   digits: 3
#>   target_ppv: 0.7

# Substantive example (Taylor and Russell, 1939; Waller, 2024).
# Solve the selection ratio needed for a desired PPV.
tr_solve(base_rate = .50, selection_ratio = NULL, validity = .35, ppv = .70)
#> <psu_tr>
#>   base_rate: 0.5
#>   selection_ratio: 0.190709
#>   validity: 0.35
#>   predictor_cutoff_z: 0.875286
#>   criterion_cutoff_z: 0
#>   true_positive: 0.133496
#>   false_positive: 0.0572127
#>   false_negative: 0.366504
#>   true_negative: 0.442787
#>   ppv: 0.7
#>   success_ratio: 0.7
#>   incremental_success: 0.2
#>   sensitivity: 0.266993
#>   specificity: 0.885575
#>   digits: 3
#>   target_ppv: 0.7
```
