# Continuous and monetary utility: Naylor-Shine, BCG, Boudreau, and Sturman

## From success ratios to continuous performance

Taylor-Russell utility dichotomizes the criterion. Naylor and Shine
(1965) keep the criterion continuous and compute expected criterion gain
in standard deviation units. This is usually a better match when
performance is a continuous construct.

``` r

library(personnelSelectionUtility)
naylor_shine(validity = .35, selection_ratio = .20)
#> <psu_ns>
#>   validity: 0.35
#>   selection_ratio: 0.2
#>   selected_mean_z: 1.39981
#>   expected_criterion_z: 0.489933
#>   sdy: 1
#>   n_selected: 1
#>   tenure: 1
#>   cost: 0
#>   gross_utility: 0.489933
#>   net_utility: 0.489933
```

The expected gain has two steps:

1.  compute the expected standardized predictor score among selected
    applicants;
2.  multiply it by the validity coefficient.

``` r

selected_mean_z(.20)
#> [1] 1.39981
.35 * selected_mean_z(.20)
#> [1] 0.4899334
```

## Brogden-Cronbach-Gleser monetary utility

Brogden (1946, 1949) and Cronbach and Gleser (1965) convert the
standardized criterion gain into utility by multiplying by `SD_y`, the
standard deviation of job performance value. Schmidt, Hunter, McKenzie,
and Muldrow (1979) popularized the organizational implications of this
formulation for personnel selection.

``` r

bcg_utility(
  validity = .35,
  selection_ratio = .20,
  sdy = 50000,
  n_selected = 100,
  tenure = 3,
  cost = 75000
)
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
```

## The baseline problem

The classical expression compares against random selection. Sturman
(2001) argues that the realistic baseline is often another selection
system, not random choice. The package represents this with
`baseline_validity` and `baseline_selection_ratio`.

``` r

random_baseline <- bcg_utility(
  validity = .35,
  selection_ratio = .20,
  sdy = 50000,
  n_selected = 100,
  tenure = 3,
  cost = 75000
)

operating_baseline <- bcg_utility(
  validity = .35,
  baseline_validity = .20,
  selection_ratio = .20,
  sdy = 50000,
  n_selected = 100,
  tenure = 3,
  cost = 75000
)

c(random = random_baseline$net_utility,
  operating = operating_baseline$net_utility)
#>    random operating 
#>   7274000   3074572
```

## Estimating `SD_y`

Holling (1998) shows why `SD_y` is a central vulnerability in utility
analysis. Small changes in `SD_y`, especially when objective performance
distributions are skewed or outliers are present, can change monetary
utility dramatically. The package includes several helpers.

Percentile judgments use the familiar 15th-to-85th percentile
approximation.

``` r

sdy_percentile(p15 = 60000, p85 = 140000)
#> [1] 40000
```

Proportional rules express `SD_y` as a fraction of pay or output value.

``` r

sdy_proportional(mean_pay = 80000, multiplier = .40)
#> [1] 32000
sdy_proportional(mean_pay = 80000, multiplier = .70)
#> [1] 56000
```

Observed monetary criterion data can be used directly.

``` r

sdy_observed(c(90000, 110000, 85000, 150000, 125000))
#> [1] 26598.87
```

## Boudreau-style extensions

Boudreau (1983, 1991) extends the basic model by adding discounting,
taxes, value multipliers, and employee flows. In
`personnelSelectionUtility`, the preferred argument names are
`n_by_period` and `cost_by_period`.

``` r

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

If the expected incremental standardized gain comes from an external
model, pass it directly through `delta_z_y`.

``` r

boudreau_utility(
  delta_z_y = .25,
  sdy = 50000,
  n_by_period = c(100, 90, 80),
  discount_rate = .08,
  cost_by_period = c(75000, 10000, 10000)
)
#> <psu_boudreau>
#>   delta_z_y: 0.25
#>   sdy: 50000
#>   variable_value: 0
#>   effective_margin: 1
#>   tax_rate: 0
#>   discount_rate: 0.08
#>   net_present_value: 2829790
```

## Multiple predictors and multiple outcomes

Sturman (2001) generalizes utility analysis to multiple selection
devices and multiple outcomes. The key move is to evaluate the
incremental validity of a new predictor system over the current system,
while allowing the criterion to be a weighted composite of several
outcomes.

``` r

S11 <- matrix(c(1, .30, .30, 1), 2, 2)
S12 <- matrix(c(.30, .20, .25, .15), 2, 2)
S22 <- matrix(c(1, .40, .40, 1), 2, 2)

restricted_canonical_validity(S11, S12, S22, criterion_weights = c(.6, .4))
#> <psu_incremental_validity>
#>   validity: 0.352614
```

To evaluate whether adding a predictor is worthwhile, use
[`incremental_validity()`](https://rgempp.github.io/personnel-selection-utility/reference/incremental_validity.md)
and then feed the resulting increment into a utility model.

``` r

Rxx <- matrix(c(1, .30, .20,
                .30, 1, .25,
                .20, .25, 1), 3, 3, byrow = TRUE)
Rxy <- matrix(c(.30, .20,
                .25, .15,
                .10, .35), 3, 2, byrow = TRUE)
Ryy <- matrix(c(1, .40, .40, 1), 2, 2)

incremental_validity(
  predictor_cor = Rxx,
  predictor_criterion_cor = Rxy,
  criterion_cor = Ryy,
  criterion_weights = c(.6, .4),
  baseline_predictors = 1:2,
  added_predictors = 3
)
#> <psu_incremental_validity>
#>   baseline_validity: 0.34905
#>   expanded_validity: 0.379438
#>   incremental_validity: 0.0303873
#>   added_predictors: 3
```

## How to proceed in applied work

1.  Start with
    [`naylor_shine()`](https://rgempp.github.io/personnel-selection-utility/reference/naylor_shine.md)
    if you only need expected criterion gain.
2.  Use
    [`bcg_utility()`](https://rgempp.github.io/personnel-selection-utility/reference/bcg_utility.md)
    for transparent monetary utility, but do not stop there.
3.  Replace random selection with the actual operating baseline whenever
    possible.
4.  Estimate `SD_y` using more than one method and report a sensitivity
    range.
5.  Use
    [`boudreau_utility()`](https://rgempp.github.io/personnel-selection-utility/reference/boudreau_utility.md)
    when utility spans several periods or when costs/returns occur at
    different times.
6.  Use
    [`restricted_canonical_validity()`](https://rgempp.github.io/personnel-selection-utility/reference/restricted_canonical_validity.md)
    and
    [`incremental_validity()`](https://rgempp.github.io/personnel-selection-utility/reference/incremental_validity.md)
    when the current selection system already includes predictors.
7.  Report the input assumptions; utility estimates are only as credible
    as the validity, `SD_y`, cost, and tenure assumptions.

## References

Boudreau, J. W. (1983). Economic considerations in estimating the
utility of human resource productivity improvement programs. *Personnel
Psychology*, 36, 551–576.

Boudreau, J. W. (1991). Utility analysis for decisions in human resource
management. In M. D. Dunnette & L. M. Hough (Eds.), *Handbook of
industrial and organizational psychology* (Vol. 2, pp. 621–745).
Consulting Psychologists Press.

Brogden, H. E. (1946). On the interpretation of the correlation
coefficient as a measure of predictive efficiency. *Journal of
Educational Psychology*, 37, 65–76.

Brogden, H. E. (1949). When testing pays off. *Personnel Psychology*, 2,
171–183.

Cronbach, L. J., & Gleser, G. C. (1965). *Psychological tests and
personnel decisions* (2nd ed.). University of Illinois Press.

Holling, H. (1998). Utility analysis of personnel selection: An overview
and empirical study based on objective performance measures. *Methods of
Psychological Research Online*, 3(1), 5–24.

Naylor, J. C., & Shine, L. C. (1965). A table for determining the
increase in mean criterion score obtained by using a selection device.
*Journal of Industrial Psychology*, 3, 33–42.

Schmidt, F. L., Hunter, J. E., McKenzie, R. C., & Muldrow, T. W. (1979).
Impact of valid selection procedures on work-force productivity.
*Journal of Applied Psychology*, 64, 609–626.

Sturman, M. C. (2001). Utility analysis for multiple selection devices
and multiple outcomes. *Journal of Human Resource Costing and
Accounting*, 6(2), 9–28.
