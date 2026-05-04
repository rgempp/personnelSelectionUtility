# personnelSelectionUtility

The goal of `personnelSelectionUtility` is to provide a comprehensive and user-friendly way to apply utility-analysis methods for personnel selection. It was created and is maintained by [René Gempp](https://gempp.cl) to systematize state-of-the-art methods using consistent notation across classification, continuous, monetary, incremental-validity, simulation, and fairness-oriented summaries.

## Installation

```r
# Development installation after cloning the repository
pak::pak("rgempp/personnel-selection-utility")
# or
remotes::install_github("rgempp/personnel-selection-utility", build_vignettes = TRUE)
```

## Argument naming convention

The package uses readable R argument names while preserving the notation used in the utility-analysis literature.

```r
library(personnelSelectionUtility)
argument_glossary()
```

Key conventions:

`base_rate` = BR or `phi`: population proportion successful before selection.

`selection_ratio` = SR: proportion selected by one cutoff or composite.

`selection_ratios` = vector of marginal SRs for multiple predictors or stages.

`joint_selection_ratio` = overall conjunctive selection ratio under multiple cutoffs.

`validity` = `r_xy`; `validities` = vector of predictor-criterion correlations.

`sdy` = `SD_y`, the monetary or criterion-unit standard deviation of job performance.

`n_applicants` is the preferred name for the number of applicants assessed; legacy `applicant_n` is still accepted.

`n_by_period` and `cost_by_period` are the preferred names in `boudreau_utility()`; legacy `n_t` and `cost_t` are still accepted.

`range_restriction_ratio` is the preferred name for the literature's `u`; legacy `u` is still accepted.

## Main model families

The package is organized around two decisions that should be made explicit before computing utility:

1. **Criterion scale**: continuous/monetary versus dichotomized/classificatory.
2. **Selection structure**: compensatory top-down composite versus conjunctive or staged multiple-hurdle cutoffs.

| Criterion scale | Compensatory selection | Multiple-hurdle selection |
|---|---|---|
| Continuous / monetary | `bcg_utility()`, `boudreau_utility()`, `restricted_canonical_validity()` | `multiple_hurdle_selection_staged()`, `compare_selection_systems_staged()`, `selection_utility_from_z()` |
| Dichotomized / classificatory | `tr_classic()`, `tr_solve()` | `tr_multivariate()`, `tr_multivariate_equal_cutoff()` |

## Examples

```r
library(personnelSelectionUtility)

# BCG utility with an operating baseline
bcg_utility(
  validity = .35,
  selection_ratio = .20,
  sdy = 50000,
  n_selected = 100,
  tenure = 3,
  cost = 75000,
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
```

## References

Hanley, J. A., & McNeil, B. J. (1982). The meaning and use of the area under a receiver operating characteristic (ROC) curve. *Radiology*, 143(1), 29-36.

Kerby, D. S. (2014). The simple difference formula: An approach to teaching nonparametric correlation. *Comprehensive Psychology*, 3, 11.IT.3.1.

Boudreau, J. W. (1991). Utility analysis for decisions in human resource management. In M. D. Dunnette & L. M. Hough (Eds.), *Handbook of industrial and organizational psychology* (Vol. 2, pp. 621-745). Consulting Psychologists Press.

Brogden, H. E. (1949). When testing pays off. *Personnel Psychology*, 2, 171-183.

Cronbach, L. J., & Gleser, G. C. (1965). *Psychological tests and personnel decisions* (2nd ed.). University of Illinois Press.

Holling, H. (1998). Utility analysis of personnel selection: An overview and empirical study based on objective performance measures. *Methods of Psychological Research Online*, 3(1), 5-24.

Ock, J., & Oswald, F. L. (2018). The utility of personnel selection decisions: Comparing compensatory and multiple-hurdle selection models. *Journal of Personnel Psychology*, 17(4), 172-182.

Rice, M. E., & Harris, G. T. (2005). Comparing effect sizes in follow-up studies: ROC area, Cohen's d, and r. *Law and Human Behavior*, 29(5), 615-620.

Salgado, J. F. (2018). Transforming the area under the normal curve (AUC) into Cohen's d, Pearson's r_pb, odds-ratio, and natural log odds-ratio: Two conversion tables. *The European Journal of Psychology Applied to Legal Context*, 10(1), 35-47.

Sturman, M. C. (2001). Utility analysis for multiple selection devices and multiple outcomes. *Journal of Human Resource Costing and Accounting*, 6(2), 9-28.

Taylor, H. C., & Russell, J. T. (1939). The relationship of validity coefficients to the practical effectiveness of tests in selection. *Journal of Applied Psychology*, 23, 565-578.

Thomas, J. G., Owen, D. B., & Gunst, R. F. (1977). Improving the use of educational tests as selection tools. *Journal of Educational Statistics*, 2(1), 55-77.
