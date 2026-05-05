# Expected performance under compensatory top-down selection

Computes the expected standardized criterion performance of applicants
selected on a weighted predictor composite. This is the compensatory
cell of the package taxonomy: scores on stronger predictors can offset
lower scores on weaker ones.

## Usage

``` r
compensatory_selection(
  predictor_cor,
  validities,
  weights = NULL,
  selection_ratio,
  n_applicants = NA_real_,
  cost_per_applicant = 0,
  sdy = NULL,
  applicant_n = NULL
)
```

## Arguments

- predictor_cor:

  Predictor intercorrelation matrix, denoted `R_XX`.

- validities:

  Vector of predictor-criterion correlations, denoted `r_xi,y`.

- weights:

  Composite weights. Defaults to validity weights.

- selection_ratio:

  Overall selection ratio for top-down selection on the composite.

- n_applicants:

  Number of applicants, used for cost calculations. Preferred name in
  v0.4.0.

- cost_per_applicant:

  Cost per assessed applicant.

- sdy:

  Optional monetary value of one criterion standard deviation.

- applicant_n:

  Legacy alias for `n_applicants`.

## Value

A `psu_comparison` object.

## References

Naylor, J. C., & Shine, L. C. (1965). A table for determining the
increase in mean criterion score obtained by using a selection device.
Journal of Industrial Psychology, 3, 33-42.

Ock, J., & Oswald, F. L. (2018). The utility of personnel selection
decisions: Comparing compensatory and multiple-hurdle selection models.
Journal of Personnel Psychology, 17(4), 172-182.

## Examples

``` r
# Literature: Naylor and Shine (1965); Ock and Oswald (2018).
# Use the first call as a minimal example; the longer block illustrates
# how to interpret the function in the substantive setting discussed in the literature.
# Minimal example (Naylor and Shine (1965); Ock and Oswald (2018)).
Rxx <- matrix(c(1, .30, .30, 1), 2, 2)
compensatory_selection(Rxx, validities = c(.40, .30), selection_ratio = .20)
#> <psu_comparison>
#>   Model: Compensatory top-down selection
#>   composite_validity: 0.440567
#>   selection_ratio: 0.2
#>   selected_mean_z: 1.39981
#>   expected_criterion_z: 0.61671
#>   n_applicants: NA
#>   applicant_n: NA
#>   n_selected: NA
#>   cost_per_applicant: 0
#>   total_cost: NA
#>   net_utility: NA

# Substantive example with costs and SDy.
Rxx <- matrix(c(
  1.00, .30, .20,
  .30, 1.00, .25,
  .20, .25, 1.00
), 3, 3, byrow = TRUE)
compensatory_selection(
  predictor_cor = Rxx,
  validities = c(.45, .35, .25),
  weights = c(1, 1, 1),
  selection_ratio = .20,
  n_applicants = 500,
  cost_per_applicant = 250,
  sdy = 60000
)
#> <psu_comparison>
#>   Model: Compensatory top-down selection
#>   composite_validity: 0.494975
#>   selection_ratio: 0.2
#>   selected_mean_z: 1.39981
#>   expected_criterion_z: 0.69287
#>   n_applicants: 500
#>   applicant_n: 500
#>   n_selected: 100
#>   cost_per_applicant: 250
#>   total_cost: 125000
#>   sdy: 60000
#>   net_utility: 4032220
```
