# Simulate conjunctive multiple-hurdle selection

Simulates expected standardized criterion performance under conjunctive
multiple-hurdle selection. Predictors are first in `R`; criterion is
last. Candidates pass only if they exceed all marginal cutoffs.

## Usage

``` r
multiple_hurdle_selection(
  selection_ratios,
  R,
  n_sim = 1e+05,
  seed = NULL,
  n_applicants = NA_real_,
  cost_per_stage = 0,
  sdy = NULL,
  applicant_n = NULL
)
```

## Arguments

- selection_ratios:

  Marginal selection ratios for each hurdle.

- R:

  Correlation matrix for predictors and criterion, criterion last.

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
# Minimal example (Sackett and Roth (1996); Ock and Oswald (2018)).
R <- matrix(c(1, .30, .40, .30, 1, .30, .40, .30, 1), 3, 3)
multiple_hurdle_selection(c(.50, .50), R, n_sim = 1000, seed = 1)
#> <psu_comparison>
#>   joint_selection_ratio: 0.287
#>   expected_criterion_z: 0.584623
#>   n_sim: 1000
#>   selected_simulated: 287
#>   n_applicants: NA
#>   applicant_n: NA
#>   n_selected: NA
#>   total_cost: NA
#>   net_utility: NA

# Substantive example with two marginal hurdles and costs.
multiple_hurdle_selection(
  selection_ratios = c(.40, .50),
  R = R,
  n_sim = 5000,
  seed = 123,
  n_applicants = 500,
  cost_per_stage = c(100, 400),
  sdy = 60000
)
#> <psu_comparison>
#>   joint_selection_ratio: 0.2452
#>   expected_criterion_z: 0.565539
#>   n_sim: 5000
#>   selected_simulated: 1226
#>   n_applicants: 500
#>   applicant_n: 500
#>   n_selected: 122.6
#>   total_cost: 129880
#>   sdy: 60000
#>   net_utility: 4030220
```
