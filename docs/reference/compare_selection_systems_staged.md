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
#>   Model: Compensatory versus staged multiple-hurdle comparison
#>   expected_criterion_z_difference: 0.13934
#>   selection_ratio_difference: 0
#>   net_utility_difference: NA
#> 
#>   Compensatory subsystem:
#>     composite_validity: 0.514621
#>     selection_ratio: 0.2
#>     selected_mean_z: 1.39981
#>     expected_criterion_z: 0.720371
#>     n_applicants: NA
#>     applicant_n: NA
#>     n_selected: NA
#>     cost_per_applicant: 0
#>     total_cost: NA
#>     net_utility: NA
#> 
#>   Multiple-hurdle subsystem:
#>     joint_selection_ratio: 0.2
#>     expected_criterion_z: 0.581032
#>     n_sim: 1000
#>     selected_simulated: 200
#>     n_applicants: NA
#>     applicant_n: NA
#>     n_selected: NA
#>     total_cost: NA
#>     net_utility: NA

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
#>   Model: Compensatory versus staged multiple-hurdle comparison
#>   expected_criterion_z_difference: 0.0366914
#>   selection_ratio_difference: 0
#>   net_utility_difference: -117351
#> 
#>   Compensatory subsystem:
#>     composite_validity: 0.494106
#>     selection_ratio: 0.2
#>     selected_mean_z: 1.39981
#>     expected_criterion_z: 0.691654
#>     n_applicants: 500
#>     applicant_n: 500
#>     n_selected: 100
#>     cost_per_applicant: 1000
#>     total_cost: 5e+05
#>     sdy: 60000
#>     net_utility: 3649920
#> 
#>   Multiple-hurdle subsystem:
#>     joint_selection_ratio: 0.2
#>     expected_criterion_z: 0.654963
#>     n_sim: 5000
#>     selected_simulated: 1000
#>     n_applicants: 500
#>     applicant_n: 500
#>     n_selected: 100
#>     total_cost: 162500
#>     sdy: 60000
#>     net_utility: 3767280
```
