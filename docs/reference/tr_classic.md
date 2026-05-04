# Taylor-Russell utility for one predictor

Computes the Taylor-Russell classification table for one normally
distributed predictor and one dichotomized criterion.

## Usage

``` r
tr_classic(base_rate, selection_ratio, validity, digits = 3)
```

## Arguments

- base_rate:

  Population proportion of successful applicants, `P(Y >= y_c)`.

- selection_ratio:

  Proportion selected, `P(X >= x_c)`.

- validity:

  Predictor-criterion correlation.

- digits:

  Number of digits used for printed summaries.

## Value

A list with thresholds, TP, FP, FN, TN, PPV, sensitivity, specificity,
and incremental success over the base rate.

## References

Taylor, H. C., & Russell, J. T. (1939). The relationship of validity
coefficients to the practical effectiveness of tests in selection.
Journal of Applied Psychology, 23, 565-578.

Cascio, W. F. (1980). Responding to the demand for accountability: A
critical analysis of three utility models. Organizational Behavior and
Human Performance, 25, 32-45.

## Examples

``` r
# Literature: Taylor and Russell (1939); Cascio (1980).
# Use the first call as a minimal example; the longer block illustrates
# how to interpret the function in the substantive setting discussed in the literature.
# Minimal example (Taylor and Russell (1939); Cascio (1980)).
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

# Substantive example (Taylor and Russell, 1939; Cascio, 1980).
# Examine how selectivity changes the success ratio.
low_sr <- tr_classic(base_rate = .50, selection_ratio = .10, validity = .35)
high_sr <- tr_classic(base_rate = .50, selection_ratio = .50, validity = .35)
c(low_selection_ratio = low_sr$ppv, high_selection_ratio = high_sr$ppv)
#>  low_selection_ratio high_selection_ratio 
#>            0.7414190            0.6138184 
```
