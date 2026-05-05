# personnelSelectionUtility

`personnelSelectionUtility` systematizes classical and contemporary
utility-analysis methods for personnel selection under consistent
notation, organised by criterion scale (classification or
continuous/monetary) and selection structure (compensatory or
multiple-hurdle).

The package implements Taylor-Russell univariate and Thomas-Owen-Gunst
multivariate classification models, Brogden-Cronbach-Gleser and
Boudreau-style continuous and monetary utility, Schmidt-Hunter-Pearlman
intervention utility, Sturman-style incremental validity for multiple
predictors and multiple outcomes, the integrated Sturman comprehensive
cascade, simulation tools for compensatory and staged multiple-hurdle
systems, Pareto frontiers for validity-diversity trade-offs,
AUC-to-effect-size conversions, and Monte Carlo uncertainty propagation.

## Installation

``` r

# Stable installation from CRAN (when available)
install.packages("personnelSelectionUtility")

# Development installation
pak::pak("rgempp/personnelSelectionUtility")
# or
remotes::install_github("rgempp/personnelSelectionUtility", build_vignettes = TRUE)
```

## Argument naming convention

The package uses readable R argument names while preserving the notation
used in the utility-analysis literature.

``` r

library(personnelSelectionUtility)
argument_glossary()
```

Key conventions:

`base_rate` = `BR` or `phi`: population proportion successful before
selection.

`selection_ratio` = `SR`: proportion selected by one cutoff or
composite.

`selection_ratios` = vector of marginal `SR`s for multiple predictors or
stages.

`joint_selection_ratio` = overall conjunctive selection ratio under
multiple cutoffs.

`validity` = `r_xy`; `validities` = vector of predictor-criterion
correlations.

`sdy` = `SD_y`, the monetary or criterion-unit standard deviation of job
performance.

`baseline_validity` = validity of the operating system used as
comparator (Sturman, 2000, 2001).

`n_applicants` = number of applicants assessed; `n_selected` = number
selected.

`tenure` = expected number of periods.

`n_by_period`, `cost_by_period` = preferred names in
[`boudreau_utility()`](https://rgempp.github.io/personnelSelectionUtility/reference/boudreau_utility.md)
for time-varying parameters.

`range_restriction_ratio` = the literature’s `u`, the ratio of
unrestricted to restricted predictor standard deviations.

## Main model families

The package is organised around two decisions that should be made
explicit before computing utility:

1.  **Criterion scale**: continuous/monetary versus
    dichotomised/classificatory.
2.  **Selection structure**: compensatory top-down composite versus
    conjunctive or staged multiple-hurdle cutoffs.

| Criterion scale | Compensatory selection | Multiple-hurdle selection |
|----|----|----|
| Continuous / monetary | [`bcg_utility()`](https://rgempp.github.io/personnelSelectionUtility/reference/bcg_utility.md), [`boudreau_utility()`](https://rgempp.github.io/personnelSelectionUtility/reference/boudreau_utility.md), [`shp_utility()`](https://rgempp.github.io/personnelSelectionUtility/reference/shp_utility.md), [`restricted_canonical_validity()`](https://rgempp.github.io/personnelSelectionUtility/reference/restricted_canonical_validity.md), [`sturman_comprehensive()`](https://rgempp.github.io/personnelSelectionUtility/reference/sturman_comprehensive.md) | [`multiple_hurdle_selection_staged()`](https://rgempp.github.io/personnelSelectionUtility/reference/multiple_hurdle_selection_staged.md), [`compare_selection_systems_staged()`](https://rgempp.github.io/personnelSelectionUtility/reference/compare_selection_systems_staged.md), [`selection_utility_from_z()`](https://rgempp.github.io/personnelSelectionUtility/reference/selection_utility_from_z.md) |
| Dichotomised / classificatory | [`tr_classic()`](https://rgempp.github.io/personnelSelectionUtility/reference/tr_classic.md), [`tr_solve()`](https://rgempp.github.io/personnelSelectionUtility/reference/tr_solve.md) | [`tr_multivariate()`](https://rgempp.github.io/personnelSelectionUtility/reference/tr_multivariate.md), [`tr_multivariate_equal_cutoff()`](https://rgempp.github.io/personnelSelectionUtility/reference/tr_multivariate_equal_cutoff.md), [`group_tr_multivariate()`](https://rgempp.github.io/personnelSelectionUtility/reference/group_tr_multivariate.md) |

## Examples

``` r

library(personnelSelectionUtility)

# Brogden-Cronbach-Gleser utility with an operating baseline
bcg_utility(
  validity          = .35,
  selection_ratio   = .20,
  sdy               = 50000,
  n_selected        = 100,
  tenure            = 3,
  cost              = 75000,
  baseline_validity = .20
)

# Taylor-Russell, univariate
tr_classic(base_rate = .50, selection_ratio = .20, validity = .35)

# Thomas-Owen-Gunst multivariate Taylor-Russell with specified marginal cutoffs
R <- matrix(c(
  1.00, .30, .40,
  .30, 1.00, .35,
  .40, .35, 1.00
), nrow = 3, byrow = TRUE)
tr_multivariate(selection_ratios = c(.50, .50), base_rate = .50, R = R)

# Thomas-Owen-Gunst equal-cutoff design indexed by a target joint selection ratio
R_tog <- matrix(c(
  1.00, .50, .70,
  .50, 1.00, .70,
  .70, .70, 1.00
), nrow = 3, byrow = TRUE)
tr_multivariate_equal_cutoff(joint_selection_ratio = .20, base_rate = .60, R = R_tog)

# AUC effect-size conversions for algorithmic or classificatory summaries
auc_to_rank_biserial(.75)
auc_to_d_equal_variance(.75)
auc_to_point_biserial(.75, base_rate = c(.50, .30, .20))

# Sturman (2001) integrated comprehensive utility model
S11 <- matrix(c(1, .30, .30, 1), 2, 2)
S12 <- matrix(c(.30, .10, .15, .25), 2, 2, byrow = TRUE)
S22 <- matrix(c(1, .40, .40, 1), 2, 2)

sturman_comprehensive(
  validity                       = .35,
  baseline_validity              = .20,
  selection_ratio                = .20,
  sdy                            = 50000,
  n_year_one                     = 100,
  tenure                         = 5,
  fixed_cost                     = 75000,
  hires_per_period               = c(100, 15, 15, 15, 15),
  losses_per_period              = c(0, 15, 15, 15, 15),
  tax_rate                       = .25,
  discount_rate                  = .08,
  predictor_cor                  = S11,
  predictor_criterion_cor        = S12,
  criterion_cor                  = S22,
  criterion_weights              = c(.7, .3),
  probation_cutoff_z             = -1,
  acceptance_rate                = .70,
  quality_acceptance_correlation = -0.20
)
```

## References

Boudreau, J. W. (1991). Utility analysis for decisions in human resource
management. In M. D. Dunnette & L. M. Hough (Eds.), *Handbook of
industrial and organizational psychology* (Vol. 2, pp. 621-745).
Consulting Psychologists Press.

Brogden, H. E. (1949). When testing pays off. *Personnel Psychology*, 2,
171-183.

Cronbach, L. J., & Gleser, G. C. (1965). *Psychological tests and
personnel decisions* (2nd ed.). University of Illinois Press.

Hanley, J. A., & McNeil, B. J. (1982). The meaning and use of the area
under a receiver operating characteristic (ROC) curve. *Radiology*,
143(1), 29-36.

Holling, H. (1998). Utility analysis of personnel selection: An overview
and empirical study based on objective performance measures. *Methods of
Psychological Research Online*, 3(1), 5-24.

Kerby, D. S. (2014). The simple difference formula: An approach to
teaching nonparametric correlation. *Comprehensive Psychology*, 3,
11.IT.3.1.

Naylor, J. C., & Shine, L. C. (1965). A table for determining the
increase in mean criterion score obtained by using a selection device.
*Journal of Industrial Psychology*, 3, 33-42.

Ock, J., & Oswald, F. L. (2018). The utility of personnel selection
decisions: Comparing compensatory and multiple-hurdle selection models.
*Journal of Personnel Psychology*, 17(4), 172-182.

Rice, M. E., & Harris, G. T. (2005). Comparing effect sizes in follow-up
studies: ROC area, Cohen’s *d*, and *r*. *Law and Human Behavior*,
29(5), 615-620.

Salgado, J. F. (2018). Transforming the area under the normal curve
(AUC) into Cohen’s *d*, Pearson’s *r_pb*, odds-ratio, and natural log
odds-ratio: Two conversion tables. *The European Journal of Psychology
Applied to Legal Context*, 10(1), 35-47.

Schmidt, F. L., Hunter, J. E., McKenzie, R. C., & Muldrow, T. W. (1979).
Impact of valid selection procedures on work-force productivity.
*Journal of Applied Psychology*, 64, 609-626.

Sturman, M. C. (2000). Implications of utility analysis adjustments for
estimates of human resource intervention value. *Journal of Management*,
26, 281-299.

Sturman, M. C. (2001). Utility analysis for multiple selection devices
and multiple outcomes. *Journal of Human Resource Costing and
Accounting*, 6(2), 9-28.

Taylor, H. C., & Russell, J. T. (1939). The relationship of validity
coefficients to the practical effectiveness of tests in selection.
*Journal of Applied Psychology*, 23, 565-578.

Thomas, J. G., Owen, D. B., & Gunst, R. F. (1977). Improving the use of
educational tests as selection tools. *Journal of Educational
Statistics*, 2(1), 55-77.
