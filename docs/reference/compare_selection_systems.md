# Compare compensatory and conjunctive multiple-hurdle selection systems

Computes analytic compensatory expected performance and simulated
multiple-hurdle expected performance using the same predictor/criterion
correlation structure.

## Usage

``` r
compare_selection_systems(
  predictor_cor,
  validities,
  compensatory_weights = NULL,
  compensatory_selection_ratio,
  hurdle_selection_ratios,
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

- hurdle_selection_ratios:

  Marginal selection ratios for hurdle stages.

- n_sim:

  Number of simulated applicants for the hurdle system.

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

A list with compensatory, multiple-hurdle, and difference summaries.

## References

Ock, J., & Oswald, F. L. (2018). The utility of personnel selection
decisions: Comparing compensatory and multiple-hurdle selection models.
Journal of Personnel Psychology, 17(4), 172-182.

## Examples

``` r
# Literature: Ock and Oswald (2018).
# Minimal example (Ock and Oswald (2018)).
Rxx <- matrix(c(1, .30, .30, 1), 2, 2)
compare_selection_systems(Rxx, c(.40, .30), hurdle_selection_ratios = c(.50, .50),
                          compensatory_selection_ratio = .25, n_sim = 1000, seed = 1)
#> <psu_comparison>
#>   expected_criterion_z_difference: -0.024615
#>   selection_ratio_difference: -0.037
#>   net_utility_difference: NA

# Substantive example with monetary utility.
compare_selection_systems(
  predictor_cor = Rxx,
  validities = c(.40, .30),
  compensatory_selection_ratio = .25,
  hurdle_selection_ratios = c(.50, .50),
  n_sim = 5000,
  seed = 123,
  n_applicants = 400,
  compensatory_cost_per_applicant = 800,
  hurdle_cost_per_stage = c(100, 300),
  sdy = 50000
)
#> <psu_comparison>
#>   expected_criterion_z_difference: 0.0550903
#>   selection_ratio_difference: -0.0442
#>   net_utility_difference: -391184
```
