# Boudreau-style discounted utility

Computes discounted multi-period utility with optional value, tax, and
cost adjustments. The expected standardized criterion gain can be
supplied directly as `delta_z_y`, or computed from validity and
selection-ratio parameters.

## Usage

``` r
boudreau_utility(
  delta_z_y = NULL,
  validity = NULL,
  selection_ratio = NULL,
  baseline_validity = 0,
  baseline_selection_ratio = NULL,
  sdy,
  n_by_period = NULL,
  variable_value = 0,
  contribution_margin = NULL,
  variable_value_convention = c("paper_plus", "cost_rate"),
  tax_rate = 0,
  discount_rate = 0,
  cost_by_period = NULL,
  discount_costs = TRUE,
  n_t = NULL,
  cost_t = NULL
)
```

## Arguments

- delta_z_y:

  Expected incremental standardized criterion gain. If `NULL`, it is
  computed from `validity`, `selection_ratio`, `baseline_validity`, and
  `baseline_selection_ratio`.

- validity:

  Focal validity, used when `delta_z_y` is `NULL`.

- selection_ratio:

  Focal selection ratio, used when `delta_z_y` is `NULL`.

- baseline_validity:

  Baseline validity. Defaults to zero.

- baseline_selection_ratio:

  Baseline selection ratio. Defaults to `selection_ratio`.

- sdy:

  Standard deviation of job performance in monetary units.

- n_by_period:

  Vector of selected/retained employees in each period. This is the
  preferred v0.4.0 name for the literature's `N_t`.

- variable_value:

  Boudreau-style multiplier `V`. By default the multiplier is
  `(1 + variable_value)`, matching the printed Boudreau-style notation.
  Set `variable_value_convention = "cost_rate"` to use
  `(1 - variable_value)`, or pass `contribution_margin` directly when
  the margin is known.

- contribution_margin:

  Optional contribution-margin multiplier. Overrides `variable_value`
  when supplied.

- variable_value_convention:

  Either `"paper_plus"` for `(1 + V)` or `"cost_rate"` for `(1 - V)`.

- tax_rate:

  Tax rate.

- discount_rate:

  Discount rate.

- cost_by_period:

  Cost in each period. Scalar or vector matching `n_by_period`.

- discount_costs:

  Should costs be discounted by period? Defaults to `TRUE`.

- n_t:

  Legacy alias for `n_by_period`. Use `n_by_period` in new code.

- cost_t:

  Legacy alias for `cost_by_period`. Use `cost_by_period` in new code.

## Value

A `psu_boudreau` object.

## References

Boudreau, J. W. (1983). Economic considerations in estimating the
utility of human resource productivity improvement programs. Personnel
Psychology, 36, 551-576.

Boudreau, J. W. (1991). Utility analysis for decisions in human resource
management. In M. D. Dunnette & L. M. Hough (Eds.), Handbook of
industrial and organizational psychology (Vol. 2, pp. 621-745).
Consulting Psychologists Press.

Sturman, M. C. (2001). Utility analysis for multiple selection devices
and multiple outcomes. Journal of Human Resource Costing and Accounting,
6(2), 9-28.

Holling, H. (1998). Utility analysis of personnel selection: An overview
and empirical study based on objective performance measures. Methods of
Psychological Research Online, 3(1), 5-24.

## Examples

``` r
# Literature: Boudreau (1983, 1991); Sturman (2001); Holling (1998).
# Use the first call as a minimal example; the longer block illustrates
# how to interpret the function in the substantive setting discussed in the literature.
# Minimal example (Boudreau (1983, 1991); Sturman (2001); Holling (1998)).
boudreau_utility(validity = .35, selection_ratio = .20, sdy = 50000,
                 n_by_period = c(100, 90, 80), discount_rate = .08,
                 cost_by_period = c(75000, 10000, 10000))
#> <psu_boudreau>
#>   delta_z_y: 0.489933
#>   sdy: 50000
#>   variable_value: 0
#>   effective_margin: 1
#>   tax_rate: 0
#>   discount_rate: 0.08
#>   net_present_value: 5628130

# Substantive example (Boudreau, 1983, 1991;
# Sturman, 2001; Holling, 1998).
# Use an explicit contribution margin and operating baseline.
boudreau_utility(
  validity = .35,
  baseline_validity = .20,
  selection_ratio = .20,
  sdy = 50000,
  n_by_period = c(100, 90, 80, 70),
  contribution_margin = .30,
  tax_rate = .25,
  discount_rate = .08,
  cost_by_period = c(75000, 10000, 10000, 10000)
)
#> <psu_boudreau>
#>   delta_z_y: 0.209971
#>   sdy: 50000
#>   variable_value: 0
#>   contribution_margin: 0.3
#>   effective_margin: 0.3
#>   tax_rate: 0.25
#>   discount_rate: 0.08
#>   net_present_value: 579234
```
