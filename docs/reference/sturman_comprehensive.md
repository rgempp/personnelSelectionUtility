# Sturman's (2001) comprehensive utility analysis

Composes the six adjustments of Sturman's (2001) comprehensive model
(§15 of the package's accompanying review) into a single call. The
returned object includes both the integrated comprehensive estimate and
a stepwise cascade that documents the contribution of each adjustment.

## Usage

``` r
sturman_comprehensive(
  validity,
  baseline_validity = 0,
  selection_ratio,
  sdy,
  n_year_one,
  tenure = 5,
  fixed_cost = 0,
  hires_per_period = NULL,
  losses_per_period = NULL,
  tax_rate = 0,
  discount_rate = 0,
  variable_value = 0,
  maintenance_cost_per_period = NULL,
  predictor_cor = NULL,
  predictor_criterion_cor = NULL,
  criterion_cor = NULL,
  criterion_weights = NULL,
  probation_cutoff_z = NULL,
  acceptance_rate = 1,
  quality_acceptance_correlation = 0
)
```

## Arguments

- validity:

  Focal-system validity (used directly when `predictor_cor` is `NULL`;
  replaced by the restricted canonical validity otherwise).

- baseline_validity:

  Operating-system baseline validity. Default 0 collapses to a
  random-baseline analysis, which the function will warn about.

- selection_ratio:

  Selection ratio.

- sdy:

  Standard deviation of job performance in monetary units.

- n_year_one:

  Number of hires in year 1.

- tenure:

  Horizon in years (\>= 1).

- fixed_cost:

  Year-1 selection cost (currency).

- hires_per_period, losses_per_period:

  Optional vectors of length `tenure` for replacement hires and turnover
  losses; if `NULL` a steady state with `n_year_one` per year is used.

- tax_rate, discount_rate, variable_value:

  Boudreau parameters.

- maintenance_cost_per_period:

  Optional cost vector of length `tenure`.

- predictor_cor, predictor_criterion_cor, criterion_cor,
  criterion_weights:

  If supplied, the function computes the restricted canonical validity
  from this multidimensional criterion specification and substitutes it
  for `validity`.

- probation_cutoff_z:

  Standardized cutoff for the probation rule (default `NULL` skips this
  adjustment).

- acceptance_rate, quality_acceptance_correlation:

  Murphy's (1986) offer-rejection adjustment. If `acceptance_rate < 1`,
  the function adjusts the year-1 expected criterion mean and headcount
  accordingly.

## Value

Object of class `c("psu_sturman", "psu_utility")` with components:
`net_utility` (final comprehensive estimate), `cascade` (a data frame
documenting each step), `effective_validity`,
`effective_baseline_validity`, and the relevant intermediate objects.

## Details

The six adjustments combined here are: (1) baseline correction (Sturman,
2000, 2001), (2) restricted canonical validity for a multidimensional
criterion, (3) multi-period employee flows, (4) Boudreau-style economic
adjustments (taxes, variable costs, discount rate), (5) De Corte (1994)
probation-period truncation, and optionally (6) Murphy's (1986)
offer-rejection adjustment. See
[`bcg_utility()`](https://rgempp.github.io/personnelSelectionUtility/reference/bcg_utility.md),
[`boudreau_utility()`](https://rgempp.github.io/personnelSelectionUtility/reference/boudreau_utility.md),
[`restricted_canonical_validity()`](https://rgempp.github.io/personnelSelectionUtility/reference/restricted_canonical_validity.md),
[`probation_adjustment()`](https://rgempp.github.io/personnelSelectionUtility/reference/probation_adjustment.md),
[`employee_flow()`](https://rgempp.github.io/personnelSelectionUtility/reference/employee_flow.md),
and
[`offer_rejection_adjustment()`](https://rgempp.github.io/personnelSelectionUtility/reference/offer_rejection_adjustment.md)
for the underlying components.

## References

De Corte, W. (1994). Utility analysis for the one-cohort
selection-retention decision with a probationary period. *Journal of
Applied Psychology*, 79, 402-411.

Murphy, K. R. (1986). When your top choice turns you down: Effect of
rejected offers on the utility of selection tests. *Psychological
Bulletin*, 99, 133-138.

Sturman, M. C. (2000). Implications of utility analysis adjustments for
estimates of human resource intervention value. *Journal of Management*,
26, 281-299.

Sturman, M. C. (2001). Utility analysis for multiple selection devices
and multiple outcomes. *Journal of Human Resource Costing and
Accounting*, 6(2), 9-28.

## Examples

``` r
Rxx <- matrix(c(1, .30, .30, 1), 2, 2)
Rxy <- matrix(c(.30, .10, .15, .25), 2, 2, byrow = TRUE)
Ryy <- matrix(c(1, .40, .40, 1), 2, 2)

sturman_comprehensive(
  validity = .35, baseline_validity = .20, selection_ratio = .20,
  sdy = 50000, n_year_one = 100, tenure = 5, fixed_cost = 75000,
  tax_rate = .25, discount_rate = .08,
  predictor_cor = Rxx, predictor_criterion_cor = Rxy,
  criterion_cor = Ryy, criterion_weights = c(.7, .3),
  probation_cutoff_z = -1,
  acceptance_rate = 0.70, quality_acceptance_correlation = -0.20
)
#> <psu_sturman: Sturman (2001) comprehensive utility>
#>   Comprehensive net utility: 12219500 
#>   Effective validity: 0.3068  (baseline: 0.2 )
#> 
#>   Cascade:
#>                            step net_utility pct_of_naive
#>  1. Naive BCG (random baseline)    12173334    100.00000
#>         2. + operating baseline     5174286     42.50509
#>  3. + multidim. criterion (RCV)     3663342     30.09317
#>     4. + flows + tax + discount     6303570     51.78179
#>                  5. + probation    17562257    144.26826
#>            6. + offer rejection    12219496    100.37921
```
