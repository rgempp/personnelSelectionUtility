# Simulate staged multiple-hurdle selection with composite stages

Simulates a sequential multiple-hurdle design in which each stage can be
one predictor or a composite of predictors. This matches
Ock-Oswald-style designs: an inexpensive first-stage composite can
screen applicants before a later, more expensive stage such as a
structured interview.

## Usage

``` r
multiple_hurdle_selection_staged(
  stage_predictors,
  stage_selection_ratios,
  R,
  stage_weights = NULL,
  n_sim = 1e+05,
  seed = NULL,
  n_applicants = NA_real_,
  cost_per_stage = 0,
  sdy = NULL,
  applicant_n = NULL
)
```

## Arguments

- stage_predictors:

  List of integer vectors. Each element gives the predictor columns used
  at that stage.

- stage_selection_ratios:

  Vector of within-stage selection ratios.

- R:

  Correlation matrix for predictors and criterion, criterion last.

- stage_weights:

  Optional list of weight vectors. Defaults to unit weights within each
  stage.

- n_sim:

  Number of simulated applicants.

- seed:

  Optional random seed.

- n_applicants:

  Number of real applicants, used for cost calculations.

- cost_per_stage:

  Cost per applicant at each stage. Scalar or vector.

- sdy:

  Optional monetary value of one criterion standard deviation.

- applicant_n:

  Legacy alias for `n_applicants`.

## Value

A `psu_comparison` object.

## References

Ock, J., & Oswald, F. L. (2018). The utility of personnel selection
decisions: Comparing compensatory and multiple-hurdle selection models.
Journal of Personnel Psychology, 17(4), 172-182.

## Examples

``` r
# Literature: Sackett and Roth (1996); Ock and Oswald (2018).
# Use the first call as a minimal example; the longer block illustrates
# how to interpret the function in the substantive setting discussed in the literature.
# Minimal example (Sackett and Roth (1996); Ock and Oswald (2018)).
R <- diag(5)
R[lower.tri(R)] <- R[upper.tri(R)] <- .20
diag(R) <- 1
multiple_hurdle_selection_staged(list(1:3, 4), c(.25, .80), R,
                                 n_sim = 1000, seed = 1)
#> <psu_comparison>
#>   Model: Staged multiple-hurdle selection with composites
#>   joint_selection_ratio: 0.2
#>   expected_criterion_z: 0.336167
#>   n_sim: 1000
#>   selected_simulated: 200
#>   n_applicants: NA
#>   applicant_n: NA
#>   n_selected: NA
#>   total_cost: NA
#>   net_utility: NA

# Substantive example (Sackett and Roth, 1996;
# Ock and Oswald, 2018).
# Use an inexpensive first-stage composite, then an interview.
R <- matrix(c(
  1.00, .41, .04, .46, .37,
  .41, 1.00, .18, .22, .35,
  .04, .18, 1.00, .66, .16,
  .46, .22, .66, 1.00, .23,
  .37, .35, .16, .23, 1.00
), 5, 5, byrow = TRUE)
multiple_hurdle_selection_staged(
  stage_predictors = list(c(1, 3, 4), 2),
  stage_selection_ratios = c(.25, .80),
  R = R,
  n_sim = 5000,
  seed = 123,
  n_applicants = 500,
  cost_per_stage = c(100, 900),
  sdy = 60000
)
#> <psu_comparison>
#>   Model: Staged multiple-hurdle selection with composites
#>   joint_selection_ratio: 0.2
#>   expected_criterion_z: 0.557481
#>   n_sim: 5000
#>   selected_simulated: 1000
#>   n_applicants: 500
#>   applicant_n: 500
#>   n_selected: 100
#>   total_cost: 162500
#>   sdy: 60000
#>   net_utility: 3182380
```
