# Utility-analysis taxonomy for personnel selection

## Purpose

The package is organized around a diagnostic question: **what kind of
selection problem are you analyzing?** Many disagreements in utility
analysis arise because a method designed for one type of problem is used
for another. Taylor and Russell (1939) framed utility as a
classificatory success-ratio problem. Naylor and Shine (1965) moved the
focus to expected criterion gain in standard-deviation units. Brogden
(1946, 1949) and Cronbach and Gleser (1965) developed the
decision-theoretic monetary formulation. Boudreau (1983, 1991), Holling
(1998), Sturman (2001), Thomas, Owen, and Gunst (1977), and Ock and
Oswald (2018) each added important corrections or extensions.

The taxonomy used here crosses two dimensions:

1.  **Criterion scale**: is the criterion treated as
    continuous/monetary, or dichotomized into success/failure?
2.  **Selection structure**: is selection compensatory, based on a
    composite score, or conjunctive/multiple-hurdle, based on passing
    multiple cutoffs or stages?

``` r

library(personnelSelectionUtility)
model_taxonomy()
#>               criterion_scale
#> 1 classification/dichotomized
#> 2 classification/dichotomized
#> 3 classification/dichotomized
#> 4         continuous/monetary
#> 5         continuous/monetary
#> 6         continuous/monetary
#> 7         continuous/monetary
#> 8             multi-attribute
#>                                             selection_structure
#> 1                              compensatory or single predictor
#> 2   conjunctive multiple-hurdle with specified marginal cutoffs
#> 3 conjunctive multiple-hurdle with target joint selection ratio
#> 4                                         compensatory top-down
#> 5                               incremental compensatory system
#> 6                         sequential/multiple-hurdle simulation
#> 7                          diagnostics and SDy input estimation
#> 8                                             multiple criteria
#>                                        model_family
#> 1                             Taylor-Russell (1939)
#> 2                          Thomas-Owen-Gunst (1977)
#> 3    Thomas-Owen-Gunst tables / equal-cutoff design
#> 4               Naylor-Shine / BCG / SHP / Boudreau
#> 5       Sturman-style restricted canonical validity
#> 6                       Ock-Oswald-style comparison
#> 7 Holling-style empirical checks and SDy estimation
#> 8                    MAUA / Pareto decision support
#>                                                                                                               primary_functions
#> 1                                                                                                      tr_classic(), tr_solve()
#> 2                                                                                                             tr_multivariate()
#> 3                                                             tr_multivariate_equal_cutoff(), tr_binomial_success_probability()
#> 4                                                              naylor_shine(), bcg_utility(), shp_utility(), boudreau_utility()
#> 5                                                                       restricted_canonical_validity(), incremental_validity()
#> 6 compensatory_selection(), multiple_hurdle_selection(), multiple_hurdle_selection_staged(), compare_selection_systems_staged()
#> 7                                         sdy_observed(), sdy_cost_accounting(), sdy_crepid(), utility_regression_diagnostics()
#> 8                                                      multiattribute_utility(), pareto_frontier(), utility_fairness_frontier()
```

This yields four practical cells.

| Criterion scale | Compensatory selection | Multiple-hurdle selection |
|----|----|----|
| Dichotomized / classificatory | Taylor-Russell on one predictor or a composite | Thomas-Owen-Gunst multivariate Taylor-Russell |
| Continuous / monetary | Naylor-Shine, BCG, Boudreau, Sturman incremental validity | Simulation or stage-wise utility calculations |

## Why this matters

A selection system can have the same predictors but a different utility
model depending on the decision rule. If cognitive ability,
conscientiousness, biodata, and interview ratings are added into one
composite and applicants are selected top-down, the model is
compensatory. If applicants must first pass a cheap screening composite
and only then pass an interview stage, the model is staged
multiple-hurdle.

The distinction is not cosmetic. Ock and Oswald (2018) emphasize the
cost-reliability trade-off: a compensatory composite often uses more
information and yields higher expected criterion performance, whereas a
multiple-hurdle system can be cheaper because expensive stages are
administered only to applicants who survive earlier screens. Sturman
(2001) adds a second major warning: classical utility analyses often
compare a new procedure to random selection, even though the realistic
baseline is usually an existing selection system.

## Argument naming

The package uses readable R argument names while keeping close
correspondence with the notation used in the literature.

``` r

head(argument_glossary(), 12)
#>                 argument               notation
#> 1              base_rate              BR or phi
#> 2        selection_ratio                     SR
#> 3       selection_ratios                   SR_i
#> 4  joint_selection_ratio                SR_conj
#> 5               validity                   r_xy
#> 6             validities                 r_xi,y
#> 7          predictor_cor                   R_XX
#> 8                      R R = cor(X_1,...,X_k,Y)
#> 9                    sdy                   SD_y
#> 10            n_selected                    N_s
#> 11             n_treated              N_treated
#> 12          n_applicants                      N
#>                                                                                meaning
#> 1              Applicant-population probability of criterion success before selection.
#> 2                         Overall proportion selected by a single cutoff or composite.
#> 3              Vector of marginal selection ratios for multiple predictors or hurdles.
#> 4                     Overall conjunctive probability of passing all multiple cutoffs.
#> 5                                      Focal predictor-criterion validity coefficient.
#> 6                                          Vector of predictor-criterion correlations.
#> 7                                              Predictor intercorrelation matrix only.
#> 8  Full predictor-plus-criterion correlation matrix; predictors first, criterion last.
#> 9                Standard deviation of job performance in monetary or criterion units.
#> 10                                            Number of selected applicants/employees.
#> 11                                      Number of employees receiving an intervention.
#> 12                                Number of applicants assessed by a selection system.
#>                                                                              note
#> 1                                 Use base_rate rather than BR in the public API.
#> 2                                      Use singular form for one decision cutoff.
#> 3                    Use plural form when there is one SR per predictor or stage.
#> 4  Distinct from marginal selection_ratios; central for Thomas-Owen-Gunst tables.
#> 5        More readable than rxy, but documentation always gives the r_xy mapping.
#> 6                                Used when multiple predictors enter a composite.
#> 7                                  Do not include the criterion in predictor_cor.
#> 8                           Required by tr_multivariate() and simulation helpers.
#> 9   The package uses sdy because SDy is the conventional label in the literature.
#> 10                               Avoid N when the role of the count is ambiguous.
#> 11                          Used in Schmidt-Hunter-Pearlman intervention utility.
#> 12           Preferred name in v0.4.0; applicant_n is accepted as a legacy alias.
```

The most important names are:

`base_rate`: population proportion successful before selection;
Taylor-Russell notation often uses `BR`.

`selection_ratio`: proportion selected by a single cutoff or composite;
classical notation uses `SR`.

`selection_ratios`: vector of marginal selection ratios in
multiple-predictor or multiple-stage models.

`joint_selection_ratio`: overall conjunctive selection ratio after all
cutoffs.

`validity`: predictor-criterion validity coefficient, usually `r_xy`.

`validities`: vector of predictor-criterion correlations.

`sdy`: standard deviation of job performance in monetary or criterion
units, usually `SD_y`.

`n_applicants`: number of applicants assessed by a system.

`n_selected`: number selected or treated.

## Recommended workflow

### Step 1: Specify the selection decision

Start by writing down the rule used in practice. Is selection based on a
single test, a composite, several simultaneous cutoffs, or a staged
process? Do not choose a utility formula before specifying the rule.

### Step 2: Specify the criterion scale

If the criterion is success/failure, use Taylor-Russell style functions.
If the criterion is continuous or monetary, use Naylor-Shine, BCG,
Boudreau, or simulation functions.

### Step 3: Specify the baseline

Following Sturman (2001), avoid treating random selection as the default
comparator unless it is genuinely the decision alternative. Use
`baseline_validity` in
[`bcg_utility()`](https://rgempp.github.io/personnel-selection-utility/reference/bcg_utility.md)
or
[`boudreau_utility()`](https://rgempp.github.io/personnel-selection-utility/reference/boudreau_utility.md)
when the organization already has an operating procedure.

### Step 4: Estimate or triangulate `SD_y`

Holling (1998) highlights that `SD_y` is often the weakest link in
monetary utility analysis. Use multiple estimates when possible:
observed criterion data, percentile judgments, proportional rules, or
job-analysis-based estimates.

### Step 5: Report uncertainty and sensitivity

Ock and Oswald (2018) show that utility estimates can vary substantially
across samples. Use
[`utility_monte_carlo()`](https://rgempp.github.io/personnel-selection-utility/reference/utility_monte_carlo.md),
[`sensitivity_grid()`](https://rgempp.github.io/personnel-selection-utility/reference/sensitivity_grid.md),
and
[`break_even_validity()`](https://rgempp.github.io/personnel-selection-utility/reference/break_even_validity.md)
to avoid reporting a single deterministic point estimate.

## Minimal examples by model family

### Dichotomous success criterion

For a single predictor or a composite summarized by one validity
coefficient, use
[`tr_classic()`](https://rgempp.github.io/personnel-selection-utility/reference/tr_classic.md).

``` r

tr_classic(base_rate = .50, selection_ratio = .20, validity = .35)
#> <psu_tr>
#>   base_rate: 0.5
#>   selection_ratio: 0.2
#>   validity: 0.35
#>   predictor_cutoff_z: 0.841621
#>   criterion_cutoff_z: 0
#>   true_positive: 0.13931
#>   false_positive: 0.0606895
#>   false_negative: 0.36069
#>   true_negative: 0.43931
#>   ppv: 0.696552
#>   success_ratio: 0.696552
#>   incremental_success: 0.196552
#>   sensitivity: 0.278621
#>   specificity: 0.878621
#>   digits: 3
```

For multiple simultaneous cutoffs, use
[`tr_multivariate()`](https://rgempp.github.io/personnel-selection-utility/reference/tr_multivariate.md).

``` r

R <- matrix(c(
  1.00, .30, .40,
  .30, 1.00, .35,
  .40, .35, 1.00
), nrow = 3, byrow = TRUE)
tr_multivariate(selection_ratios = c(.50, .50), base_rate = .50, R = R)
#> <psu_tr>
#>   base_rate: 0.5
#>   joint_selection_ratio: 0.298451
#>   criterion_cutoff_z: 0
#>   true_positive: 0.210393
#>   false_positive: 0.0880588
#>   false_negative: 0.289607
#>   true_negative: 0.411941
#>   ppv: 0.704948
#>   success_ratio: 0.704948
#>   incremental_success: 0.204948
#>   sensitivity: 0.420785
#>   specificity: 0.823882
#>   digits: 3
```

### AUC and effect-size conversions

In contemporary selection research, especially when using algorithmic or
classification models, predictive performance may be reported as AUC
rather than as a validity coefficient. The package therefore separates
three conceptually distinct conversions. First,
[`auc_to_rank_biserial()`](https://rgempp.github.io/personnel-selection-utility/reference/auc_to_rank_biserial.md)
returns the dominance or rank-biserial summary `2 * AUC - 1`, which
follows from the interpretation of AUC as the probability of a favorable
ordering of one positive and one negative case (Hanley & McNeil, 1982;
Kerby, 2014). Second,
[`auc_to_d_equal_variance()`](https://rgempp.github.io/personnel-selection-utility/reference/auc_to_d_equal_variance.md)
converts AUC to Cohen’s `d` under the equal-variance binormal model
(Rice & Harris, 2005; Salgado, 2018). Third,
[`auc_to_point_biserial()`](https://rgempp.github.io/personnel-selection-utility/reference/auc_to_point_biserial.md)
converts that `d` to a point-biserial correlation for a specified
`base_rate`, making the base-rate dependence explicit.

``` r

auc_to_rank_biserial(.75)
#> [1] 0.5
auc_to_d_equal_variance(.75)
#> [1] 0.9538726
auc_to_point_biserial(.75, base_rate = c(.50, .30, .20, .10))
#> [1] 0.4304822 0.4005260 0.3564821 0.2751188
```

Use these conversions as bridges between reported classification
performance and utility-analysis inputs, not as assumption-free
substitutes for validation studies. If the selection criterion is binary
and the available evidence is AUC, report which conversion was used and
whether a base rate was assumed.

### Continuous or monetary criterion

For expected standardized criterion gain without money, use
[`naylor_shine()`](https://rgempp.github.io/personnel-selection-utility/reference/naylor_shine.md).

``` r

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

For monetary utility, use
[`bcg_utility()`](https://rgempp.github.io/personnel-selection-utility/reference/bcg_utility.md)
as a transparent baseline model.

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

If you need discounting, costs by period, taxes, contribution margin, or
employee flows, use
[`boudreau_utility()`](https://rgempp.github.io/personnel-selection-utility/reference/boudreau_utility.md).

``` r

boudreau_utility(
  validity = .35,
  baseline_validity = .20,
  selection_ratio = .20,
  sdy = 50000,
  n_by_period = c(100, 90, 80),
  contribution_margin = .30,
  tax_rate = .25,
  discount_rate = .08,
  cost_by_period = c(75000, 10000, 10000)
)
#> <psu_boudreau>
#>   delta_z_y: 0.209971
#>   sdy: 50000
#>   variable_value: 0
#>   contribution_margin: 0.3
#>   effective_margin: 0.3
#>   tax_rate: 0.25
#>   discount_rate: 0.08
#>   net_present_value: 465045
```

## Reporting checklist

A complete utility analysis should report: the selection rule, the
criterion scale, the base rate if a classificatory model is used, the
selection ratio, all validity coefficients and their sources, how `SD_y`
was estimated, whether validity and `SD_y` were corrected or not, the
baseline comparator, costs, time horizon, discounting, uncertainty
intervals, and sensitivity analyses.

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

Hanley, J. A., & McNeil, B. J. (1982). The meaning and use of the area
under a receiver operating characteristic (ROC) curve. *Radiology*,
143(1), 29–36.

Kerby, D. S. (2014). The simple difference formula: An approach to
teaching nonparametric correlation. *Comprehensive Psychology*, 3,
11.IT.3.1.

Rice, M. E., & Harris, G. T. (2005). Comparing effect sizes in follow-up
studies: ROC area, Cohen’s d, and r. *Law and Human Behavior*, 29(5),
615–620.

Salgado, J. F. (2018). Transforming the area under the normal curve
(AUC) into Cohen’s d, Pearson’s r_pb, odds-ratio, and natural log
odds-ratio: Two conversion tables. *The European Journal of Psychology
Applied to Legal Context*, 10(1), 35–47.

Holling, H. (1998). Utility analysis of personnel selection: An overview
and empirical study based on objective performance measures. *Methods of
Psychological Research Online*, 3(1), 5–24.

Naylor, J. C., & Shine, L. C. (1965). A table for determining the
increase in mean criterion score obtained by using a selection device.
*Journal of Industrial Psychology*, 3, 33–42.

Ock, J., & Oswald, F. L. (2018). The utility of personnel selection
decisions: Comparing compensatory and multiple-hurdle selection models.
*Journal of Personnel Psychology*, 17(4), 172–182.

Sturman, M. C. (2001). Utility analysis for multiple selection devices
and multiple outcomes. *Journal of Human Resource Costing and
Accounting*, 6(2), 9–28.

Taylor, H. C., & Russell, J. T. (1939). The relationship of validity
coefficients to the practical effectiveness of tests in selection.
*Journal of Applied Psychology*, 23, 565–578.

Thomas, J. G., Owen, D. B., & Gunst, R. F. (1977). Improving the use of
educational tests as selection tools. *Journal of Educational
Statistics*, 2(1), 55–77.
