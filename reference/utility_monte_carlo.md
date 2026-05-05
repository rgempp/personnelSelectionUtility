# Monte Carlo uncertainty propagation for BCG utility

Samples validity and SDy and propagates them through the BCG model. This
is a simple decision-support approximation, not a full Bayesian model.

## Usage

``` r
utility_monte_carlo(
  n_sim = 10000,
  validity_mean,
  validity_se,
  sdy_mean,
  sdy_sd,
  selection_ratio,
  n_selected,
  tenure,
  cost = 0,
  baseline_validity = 0,
  seed = NULL
)
```

## Arguments

- n_sim:

  Number of simulations.

- validity_mean:

  Mean validity.

- validity_se:

  Standard error of validity.

- sdy_mean:

  Mean SDy.

- sdy_sd:

  Standard deviation of SDy uncertainty.

- selection_ratio:

  Selection ratio.

- n_selected:

  Number selected.

- tenure:

  Expected tenure.

- cost:

  Cost.

- baseline_validity:

  Baseline validity.

- seed:

  Optional random seed.

## Value

A `psu_monte_carlo` object with draws and quantiles.

## References

Alexander, R. A., & Barrick, M. R. (1987). Estimating the standard error
of projected dollar gains in utility analysis. Journal of Applied
Psychology, 72, 475-479.

Rich, J. R., & Boudreau, J. W. (1987). The effects of variability and
risk on selection utility analysis. Personnel Psychology, 40, 55-84.

Ock, J., & Oswald, F. L. (2018). The utility of personnel selection
decisions: Comparing compensatory and multiple-hurdle selection models.
Journal of Personnel Psychology, 17(4), 172-182.

## Examples

``` r
# Literature: Alexander and Barrick (1987); Rich and Boudreau (1987); Ock and Oswald (2018).
# Use the first call as a minimal example; the longer block illustrates
# how to interpret the function in the substantive setting discussed in the literature.
# Minimal example (Alexander and Barrick (1987); Rich and Boudreau (1987); Ock and Oswald (2018)).
utility_monte_carlo(n_sim = 1000, validity_mean = .35, validity_se = .05,
                    sdy_mean = 50000, sdy_sd = 10000, selection_ratio = .20,
                    n_selected = 100, tenure = 3, cost = 75000, seed = 1)
#> <psu_monte_carlo>
#>   n_sim: 1000
#>   mean_net_utility: 7239350
#>   median_net_utility: 7138200
#>   probability_positive: 1

# Substantive example (Alexander and Barrick, 1987;
# Rich and Boudreau, 1987; Ock and Oswald, 2018).
# Quantify the probability that net utility is positive.
mc <- utility_monte_carlo(n_sim = 2000, validity_mean = .30, validity_se = .06,
                          sdy_mean = 50000, sdy_sd = 15000,
                          selection_ratio = .20, n_selected = 100,
                          tenure = 3, cost = 75000,
                          baseline_validity = .15, seed = 123)
mc$probability_positive
#> [1] 0.994
```
