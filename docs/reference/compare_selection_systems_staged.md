# Compare compensatory and staged multiple-hurdle selection systems

Compares a compensatory top-down composite against a staged
multiple-hurdle system in which stages can be composites.

## Usage

``` r
compare_selection_systems_staged(
  predictor_cor,
  validities,
  compensatory_weights = NULL,
  compensatory_selection_ratio,
  stage_predictors,
  stage_selection_ratios,
  stage_weights = NULL,
  n_sim = 1e+05,
  seed = NULL,
  n_applicants = NA_real_,
  compensatory_cost_per_applicant = 0,
  hurdle_cost_per_stage = 0,
  sdy = NULL,
  applicant_n = NULL
)
```

## Arguments

- predictor_cor:

  Predictor intercorrelation matrix.

- validities:

  Vector of predictor-criterion correlations.

- compensatory_weights:

  Weights for the compensatory composite.

- compensatory_selection_ratio:

  Overall compensatory selection ratio.

- stage_predictors:

  List of integer vectors defining staged predictors.

- stage_selection_ratios:

  Within-stage selection ratios.

- stage_weights:

  Optional list of weight vectors.

- n_sim:

  Number of simulated applicants for the staged system.

- seed:

  Optional random seed.

- n_applicants:

  Optional number of real applicants.

- compensatory_cost_per_applicant:

  Cost per applicant for the compensatory system.

- hurdle_cost_per_stage:

  Cost per applicant assessed at each hurdle.

- sdy:

  Optional monetary value of one criterion standard deviation.

- applicant_n:

  Legacy alias for `n_applicants`.

## Value

A list with compensatory, staged multiple-hurdle, and difference
summaries.

## References

Ock, J., & Oswald, F. L. (2018). The utility of personnel selection
decisions: Comparing compensatory and multiple-hurdle selection models.
Journal of Personnel Psychology, 17(4), 172-182.

## Examples

``` r
# Literature: Ock and Oswald (2018).
# Use the first call as a minimal example; the longer block illustrates
# how to interpret the function in the substantive setting discussed in the literature.
# Minimal example (Ock and Oswald (2018)).
Rxx <- diag(4); Rxx[lower.tri(Rxx)] <- Rxx[upper.tri(Rxx)] <- .20
compare_selection_systems_staged(Rxx, validities = c(.40, .35, .20, .30),
  compensatory_selection_ratio = .20, stage_predictors = list(1:3, 4),
  stage_selection_ratios = c(.25, .80), n_sim = 1000, seed = 1)
#> <psu_comparison>
#>   expected_criterion_z_difference: 0.13934
#>   selection_ratio_difference: 0
#>   net_utility_difference: NA

# Substantive Ock-Oswald-style staged comparison.
compare_selection_systems_staged(
  predictor_cor = Rxx,
  validities = c(.40, .35, .20, .30),
  compensatory_weights = rep(1, 4),
  compensatory_selection_ratio = .20,
  stage_predictors = list(c(1, 3, 4), 2),
  stage_selection_ratios = c(.25, .80),
  n_sim = 5000,
  seed = 123,
  n_applicants = 500,
  compensatory_cost_per_applicant = 1000,
  hurdle_cost_per_stage = c(100, 900),
  sdy = 60000
)
#> <psu_comparison>
#>   expected_criterion_z_difference: 0.0366914
#>   selection_ratio_difference: 0
#>   net_utility_difference: -117351
```
