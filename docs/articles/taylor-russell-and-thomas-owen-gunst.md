# Taylor-Russell and the Thomas-Owen-Gunst multivariate extension

## The classificatory problem

Taylor and Russell (1939) ask a classificatory question: **what
proportion of selected applicants will be successful, given a base rate,
a selection ratio, and a validity coefficient?** In modern diagnostic
language, the central quantity is a positive predictive value (PPV):
`P(success | selected)`.

``` r

library(personnelSelectionUtility)
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

The output includes true positives, false positives, false negatives,
and true negatives. The key value is `ppv`, also called the success
ratio among selected applicants.

## Solving unknown Taylor-Russell inputs

The original tables were forward-looking: given the base rate, selection
ratio, and validity, they give the success ratio. In practice, one often
asks the inverse question: **what validity is required to achieve a
target PPV?** The function
[`tr_solve()`](https://rgempp.github.io/personnel-selection-utility/reference/tr_solve.md)
follows this logic and is intentionally similar to the flexible solver
implemented in Waller’s `TaylorRussell` package.

``` r

tr_solve(base_rate = .50, selection_ratio = .20, validity = NULL, ppv = .70)
#> <psu_tr>
#>   base_rate: 0.5
#>   selection_ratio: 0.2
#>   validity: 0.356075
#>   predictor_cutoff_z: 0.841621
#>   criterion_cutoff_z: 0
#>   true_positive: 0.14
#>   false_positive: 0.06
#>   false_negative: 0.36
#>   true_negative: 0.44
#>   ppv: 0.7
#>   success_ratio: 0.7
#>   incremental_success: 0.2
#>   sensitivity: 0.28
#>   specificity: 0.88
#>   digits: 3
#>   target_ppv: 0.7
```

You can also solve for the selection ratio implied by a desired PPV and
a known validity.

``` r

tr_solve(base_rate = .50, selection_ratio = NULL, validity = .35, ppv = .70)
#> <psu_tr>
#>   base_rate: 0.5
#>   selection_ratio: 0.190709
#>   validity: 0.35
#>   predictor_cutoff_z: 0.875286
#>   criterion_cutoff_z: 0
#>   true_positive: 0.133496
#>   false_positive: 0.0572127
#>   false_negative: 0.366504
#>   true_negative: 0.442787
#>   ppv: 0.7
#>   success_ratio: 0.7
#>   incremental_success: 0.2
#>   sensitivity: 0.266993
#>   specificity: 0.885575
#>   digits: 3
#>   target_ppv: 0.7
```

## Why the univariate model is not enough

The univariate Taylor-Russell model can handle a single predictor, or a
composite that has already collapsed several predictors into one score.
But many real systems do not operate as a single composite. Applicants
may need to pass multiple independent cutoffs: for example, minimum
cognitive score and minimum interview score.

Thomas, Owen, and Gunst (1977) generalized the Taylor-Russell logic to
multiple cutoffs. Their paper shows that multiple cutoff scores are, in
principle, a natural extension of the single-test case, but computation
was historically difficult because it requires multivariate normal
probabilities. Modern implementations use numerical multivariate normal
integration, for example through `mvtnorm`.

## Multivariate Taylor-Russell with specified marginal cutoffs

The matrix `R` must include predictors first and the criterion last. The
following example has two predictors and one criterion.

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

The output contains both the marginal selection ratios supplied by the
user and the implied `joint_selection_ratio`. These are not the same
thing. If each predictor has a marginal selection ratio of .50, the
joint selected proportion can be much smaller than .50 because
applicants must pass both cutoffs.

## Equal-cutoff tables and target joint selection ratio

The historical Thomas-Owen-Gunst tables are indexed by the **joint**
proportion selected under equal cutoffs. That is why the package
includes
[`tr_multivariate_equal_cutoff()`](https://rgempp.github.io/personnel-selection-utility/reference/tr_multivariate_equal_cutoff.md).

``` r

R_tog <- matrix(c(
  1.00, .50, .70,
  .50, 1.00, .70,
  .70, .70, 1.00
), nrow = 3, byrow = TRUE)

tog <- tr_multivariate_equal_cutoff(
  joint_selection_ratio = .20,
  base_rate = .60,
  R = R_tog
)

tog
#> <psu_tr>
#>   base_rate: 0.6
#>   joint_selection_ratio: 0.2
#>   criterion_cutoff_z: -0.253347
#>   true_positive: 0.194465
#>   false_positive: 0.00553487
#>   false_negative: 0.405535
#>   true_negative: 0.394465
#>   ppv: 0.972326
#>   success_ratio: 0.972326
#>   incremental_success: 0.372326
#>   sensitivity: 0.324109
#>   specificity: 0.986163
#>   digits: 3
#>   target_joint_selection_ratio: 0.2
#>   computed_joint_selection_ratio: 0.200042
#>   solved_marginal_selection_ratio: 0.354321
#>   joint_selection_error: 4.18379e-05
```

This reproduces the logic of the Thomas-Owen-Gunst example: when the
population base rate is .60, the predictor intercorrelation is .50, and
both predictor-criterion validities are .70, selecting the joint top 20%
through equal cutoffs yields a success ratio close to .972 and a
marginal pass rate near .354 on each test.

``` r

c(
  marginal_selection_ratio = tog$solved_marginal_selection_ratio,
  joint_selection_ratio = tog$joint_selection_ratio,
  ppv = tog$ppv
)
#> marginal_selection_ratio    joint_selection_ratio                      ppv 
#>                0.3543206                0.2000000                0.9723257
```

## Finite sampling

Thomas, Owen, and Gunst (1977) also discuss finite cohorts: once the
expected success ratio is known, a finite selected group can be
summarized using a binomial distribution. For example, if 20 applicants
are selected and the PPV is .91, what is the probability that at least
18 are successful?

``` r

finite <- tr_binomial_success_probability(n_selected = 20, ppv = .91, at_least = 18)
finite
#>    successes  probability
#> 1          0 1.215767e-21
#> 2          1 2.458550e-19
#> 3          2 2.361574e-17
#> 4          3 1.432688e-15
#> 5          4 6.156580e-14
#> 6          5 1.991996e-12
#> 7          6 5.035322e-11
#> 8          7 1.018254e-09
#> 9          8 1.673048e-08
#> 10         9 2.255516e-07
#> 11        10 2.508636e-06
#> 12        11 2.305918e-05
#> 13        12 1.748654e-04
#> 14        13 1.088051e-03
#> 15        14 5.500705e-03
#> 16        15 2.224729e-02
#> 17        16 7.029527e-02
#> 18        17 1.672384e-01
#> 19        18 2.818277e-01
#> 20        19 2.999570e-01
#> 21        20 1.516449e-01
attr(finite, "probability_at_least")
#> [1] 0.7334296
```

## How to proceed in applied work

1.  Use
    [`tr_classic()`](https://rgempp.github.io/personnel-selection-utility/reference/tr_classic.md)
    when the system is genuinely one-dimensional or when a defensible
    composite has already been formed.
2.  Use
    [`tr_multivariate()`](https://rgempp.github.io/personnel-selection-utility/reference/tr_multivariate.md)
    when the actual decision is conjunctive: applicants must pass
    multiple simultaneous cutoffs.
3.  Use
    [`tr_multivariate_equal_cutoff()`](https://rgempp.github.io/personnel-selection-utility/reference/tr_multivariate_equal_cutoff.md)
    when the overall joint selected proportion is fixed and the marginal
    equal cutoff must be solved.
4.  Always inspect whether the joint selected proportion is
    operationally realistic; multiple marginal cutoffs can become
    extremely selective.
5.  Treat the multivariate normal assumption as a modeling assumption,
    not a fact. If the empirical distributions are skewed or truncated,
    report sensitivity analyses.
6.  If success is not naturally dichotomous, consider Naylor-Shine, BCG,
    or Boudreau-style continuous utility instead of forcing a
    dichotomous criterion.

## References

Cascio, W. F. (1980). Responding to the demand for accountability: A
critical analysis of three utility models. *Organizational Behavior and
Human Performance*, 25, 32–45.

Genz, A., & Bretz, F. (2009). *Computation of multivariate normal and t
probabilities*. Springer.

Taylor, H. C., & Russell, J. T. (1939). The relationship of validity
coefficients to the practical effectiveness of tests in selection.
*Journal of Applied Psychology*, 23, 565–578.

Thomas, J. G., Owen, D. B., & Gunst, R. F. (1977). Improving the use of
educational tests as selection tools. *Journal of Educational
Statistics*, 2(1), 55–77.

Waller, N. G. (2024). *TaylorRussell: A Taylor-Russell function for
multiple predictors* (R package version 1.2.1). CRAN.
