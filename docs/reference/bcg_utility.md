# Brogden-Cronbach-Gleser utility

Computes classical Brogden-Cronbach-Gleser utility. By default the
baseline is random selection (`baseline_validity = 0`), but an operating
baseline can be supplied using `baseline_validity` and, optionally,
`baseline_selection_ratio`.

## Usage

``` r
bcg_utility(
  validity,
  selection_ratio,
  sdy,
  n_selected,
  tenure,
  cost = 0,
  baseline_validity = 0,
  baseline_selection_ratio = NULL
)
```

## Arguments

- validity:

  Validity of the focal selection system, usually denoted `r_xy`.

- selection_ratio:

  Selection ratio of the focal system.

- sdy:

  Standard deviation of job performance in monetary units, `SD_y`.

- n_selected:

  Number of selected applicants, `N_s`.

- tenure:

  Expected tenure or number of periods, `T`.

- cost:

  Total cost of the focal system net of baseline costs, if relevant.

- baseline_validity:

  Validity of the baseline system. Defaults to `0`.

- baseline_selection_ratio:

  Selection ratio of the baseline system. If `NULL`, it is assumed to
  equal `selection_ratio`.

## Value

A `psu_bcg` object.

## References

Cronbach, L. J., & Gleser, G. C. (1965). Psychological tests and
personnel decisions (2nd ed.). University of Illinois Press.

Brogden, H. E. (1946). On the interpretation of the correlation
coefficient as a measure of predictive efficiency. Journal of
Educational Psychology, 37, 65-76.

Brogden, H. E. (1949). When testing pays off. Personnel Psychology, 2,
171-183.

Sturman, M. C. (2001). Utility analysis for multiple selection devices
and multiple outcomes. Journal of Human Resource Costing and Accounting,
6(2), 9-28.

## Examples

``` r
# Literature: Brogden (1946, 1949); Cronbach and Gleser (1965); Sturman (2001).
# Use the first call as a minimal example; the longer block illustrates
# how to interpret the function in the substantive setting discussed in the literature.
# Minimal example (Brogden (1946, 1949); Cronbach and Gleser (1965); Sturman (2001)).
bcg_utility(validity = .35, selection_ratio = .20, sdy = 50000,
            n_selected = 100, tenure = 3, cost = 75000)
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
#>   cost: 75000
#>   gross_utility: 7349000
#>   net_utility: 7274000

# Substantive example (Brogden, 1946, 1949;
# Cronbach and Gleser, 1965; Sturman, 2001).
# Use an operating baseline rather than random selection.
naive <- bcg_utility(.35, .20, 50000, n_selected = 100, tenure = 3, cost = 75000)
incremental <- bcg_utility(.35, .20, 50000, n_selected = 100, tenure = 3,
                           cost = 75000, baseline_validity = .20)
c(naive = naive$net_utility, incremental = incremental$net_utility)
#>       naive incremental 
#>     7274000     3074572 
```
