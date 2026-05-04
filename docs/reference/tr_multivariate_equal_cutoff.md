# Solve equal marginal cutoffs for a target joint selection ratio

Thomas, Owen, and Gunst's printed tables are indexed by the overall
proportion selected under two equal cutoffs. This helper solves the
common marginal selection ratio that yields a target conjunctive
selection ratio for any predictor correlation matrix, then calls
[`tr_multivariate()`](https://rgempp.github.io/personnel-selection-utility/reference/tr_multivariate.md).

## Usage

``` r
tr_multivariate_equal_cutoff(
  joint_selection_ratio,
  base_rate,
  R,
  interval = NULL,
  tol = 1e-08,
  digits = 3
)
```

## Arguments

- joint_selection_ratio:

  Target conjunctive selection ratio, `P(X_1 >= c, ..., X_k >= c)`.

- base_rate:

  Population proportion of successful applicants.

- R:

  Correlation matrix with predictors first and criterion last.

- interval:

  Optional search interval for the common marginal selection ratio.
  Defaults to `(joint_selection_ratio, 1)`.

- tol:

  Numerical tolerance passed to
  [`optimize()`](https://rdrr.io/r/stats/optimize.html).

- digits:

  Number of digits used for printed summaries.

## Value

A `psu_tr` object from
[`tr_multivariate()`](https://rgempp.github.io/personnel-selection-utility/reference/tr_multivariate.md)
with the solved marginal selection ratio, the target joint selection
ratio, the computed joint selection ratio, and the numerical
joint-selection error added.

## References

Thomas, J. G., Owen, D. B., & Gunst, R. F. (1977). Improving the use of
educational tests as selection tools. Journal of Educational Statistics,
2(1), 55-77.

Waller, N. G. (2024). TaylorRussell: A Taylor-Russell function for
multiple predictors (R package version 1.2.1). CRAN.

## Examples

``` r
# Literature: Thomas, Owen, and Gunst (1977); Waller (2024).
# Use the first call as a minimal example; the longer block illustrates
# how to interpret the function in the substantive setting discussed in the literature.
# Minimal example (Thomas, Owen, and Gunst (1977); Waller (2024)).
R <- matrix(c(1, .50, .70,
              .50, 1, .70,
              .70, .70, 1), 3, 3, byrow = TRUE)
tr_multivariate_equal_cutoff(joint_selection_ratio = .20, base_rate = .60, R = R)
#> <psu_tr>
#>   base_rate: 0.6
#>   joint_selection_ratio: 0.2
#>   criterion_cutoff_z: -0.253347
#>   true_positive: 0.194408
#>   false_positive: 0.00559223
#>   false_negative: 0.405592
#>   true_negative: 0.394408
#>   ppv: 0.972039
#>   success_ratio: 0.972039
#>   incremental_success: 0.372039
#>   sensitivity: 0.324013
#>   specificity: 0.986019
#>   digits: 3
#>   target_joint_selection_ratio: 0.2
#>   computed_joint_selection_ratio: 0.199984
#>   solved_marginal_selection_ratio: 0.354321
#>   joint_selection_error: -1.61346e-05

# Substantive example (Thomas, Owen, and Gunst, 1977;
# Waller, 2024). Reproduce the Example 1 pattern.
tog <- tr_multivariate_equal_cutoff(.20, .60, R)
c(marginal_sr = tog$solved_marginal_selection_ratio, ppv = tog$ppv)
#> marginal_sr         ppv 
#>   0.3543206   0.9720477 
```
