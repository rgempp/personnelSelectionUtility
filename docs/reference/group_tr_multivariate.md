# Multigroup multivariate Taylor-Russell summaries

Applies
[`tr_multivariate()`](https://rgempp.github.io/personnel-selection-utility/reference/tr_multivariate.md)
separately by group. This is useful for sensitivity analyses in which
base rates or correlation matrices differ across demographic groups. It
does not by itself establish legal compliance or fairness.

## Usage

``` r
group_tr_multivariate(
  selection_ratios,
  base_rates,
  R_list,
  group_names = NULL,
  group_proportions = NULL
)
```

## Arguments

- selection_ratios:

  Vector of marginal selection ratios, common to all groups, or a list
  of group-specific vectors.

- base_rates:

  Numeric vector of group-specific base rates.

- R_list:

  List of group-specific correlation matrices.

- group_names:

  Optional group labels.

- group_proportions:

  Optional population proportions. If supplied, they are normalized and
  used to compute overall weighted summaries.

## Value

A list with group-level Taylor-Russell summaries and optional weighted
overall metrics.

## References

De Corte, W., Lievens, F., & Sackett, P. R. (2007). Combining predictors
to achieve optimal trade-offs between selection quality and adverse
impact. Journal of Applied Psychology, 92, 1380-1393.

Thomas, J. G., Owen, D. B., & Gunst, R. F. (1977). Improving the use of
educational tests as selection tools. Journal of Educational Statistics,
2(1), 55-77.

## Examples

``` r
# Literature: Thomas, Owen, and Gunst (1977); De Corte et al. (2007).
R <- matrix(c(1, .30, .40, .30, 1, .35, .40, .35, 1), 3, 3)
group_tr_multivariate(c(.50, .50), base_rates = c(.50, .40),
                      R_list = list(R, R), group_names = c("A", "B"))
#> $groups
#> $groups$A
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
#> 
#> $groups$B
#> <psu_tr>
#>   base_rate: 0.4
#>   joint_selection_ratio: 0.298512
#>   criterion_cutoff_z: 0.253347
#>   true_positive: 0.180407
#>   false_positive: 0.118105
#>   false_negative: 0.219593
#>   true_negative: 0.481895
#>   ppv: 0.604354
#>   success_ratio: 0.604354
#>   incremental_success: 0.204354
#>   sensitivity: 0.451018
#>   specificity: 0.803158
#>   digits: 3
#> 
#> 
#> $summary
#>   group base_rate joint_selection_ratio       ppv sensitivity specificity
#> A     A       0.5             0.2985072 0.7050843   0.4209455   0.8239311
#> B     B       0.4             0.2985122 0.6043542   0.4510177   0.8031582
#> 
#> $overall
#> NULL
#> 
```
