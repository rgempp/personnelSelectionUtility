# Multivariate Taylor-Russell utility for conjunctive multiple-hurdle selection

Implements the Thomas-Owen-Gunst multivariate extension of the
Taylor-Russell model. Candidates are selected if and only if they exceed
all predictor cutoffs. The correlation matrix must include the
predictors first and the criterion last.

## Usage

``` r
tr_multivariate(selection_ratios, base_rate, R, digits = 3)
```

## Arguments

- selection_ratios:

  Vector of marginal selection ratios, one per predictor.

- base_rate:

  Population proportion of successful applicants.

- R:

  Correlation matrix of dimension `(k + 1) x (k + 1)`. Predictors must
  occupy the first `k` rows/columns; the criterion must be last.

- digits:

  Number of digits used for printed summaries.

## Value

A `psu_tr` object with TP, FP, FN, TN, joint selection ratio, PPV,
sensitivity, specificity, and cutoffs.

## References

Thomas, J. G., Owen, D. B., & Gunst, R. F. (1977). Improving the use of
educational tests as selection tools. Journal of Educational Statistics,
2(1), 55-77.

Taylor, H. C., & Russell, J. T. (1939). The relationship of validity
coefficients to the practical effectiveness of tests in selection.
Journal of Applied Psychology, 23, 565-578.

Genz, A., & Bretz, F. (2009). Computation of multivariate normal and t
probabilities. Springer.

## Examples

``` r
# Literature: Taylor and Russell (1939); Thomas, Owen, and Gunst
# (1977); Genz and Bretz (2009).
# Use the first call as a minimal example; the longer block illustrates
# how to interpret the function in the substantive setting discussed in the literature.
# Minimal example (Taylor and Russell, 1939;
# Thomas, Owen, and Gunst, 1977; Genz and Bretz, 2009).
R <- matrix(c(1, .30, .40,
              .30, 1, .35,
              .40, .35, 1), nrow = 3, byrow = TRUE)
tr_multivariate(selection_ratios = c(.50, .50), base_rate = .50, R = R)
#> <psu_tr>
#>   base_rate: 0.5
#>   joint_selection_ratio: 0.298507
#>   criterion_cutoff_z: 0
#>   true_positive: 0.210473
#>   false_positive: 0.0880345
#>   false_negative: 0.289527
#>   true_negative: 0.411966
#>   ppv: 0.705084
#>   success_ratio: 0.705084
#>   incremental_success: 0.205084
#>   sensitivity: 0.420945
#>   specificity: 0.823931
#>   digits: 3

# Substantive example (Taylor and Russell, 1939;
# Thomas, Owen, and Gunst, 1977; Genz and Bretz, 2009).
# Compare two validity patterns under the same marginal cutoffs.
R_stronger <- matrix(c(1, .30, .60,
                       .30, 1, .55,
                       .60, .55, 1), nrow = 3, byrow = TRUE)
weak <- tr_multivariate(c(.50, .50), base_rate = .50, R = R)
strong <- tr_multivariate(c(.50, .50), base_rate = .50, R = R_stronger)
c(weak_ppv = weak$ppv, strong_ppv = strong$ppv)
#>   weak_ppv strong_ppv 
#>  0.7050732  0.8268465 
```
