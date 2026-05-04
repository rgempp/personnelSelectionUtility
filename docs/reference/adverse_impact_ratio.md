# Adverse-impact ratio by group

Computes selection rates and adverse-impact ratios by group. If no
reference group is supplied, the highest selection-rate group is used as
reference.

## Usage

``` r
adverse_impact_ratio(selected, group, reference = NULL)
```

## Arguments

- selected:

  Logical or 0/1 vector indicating selection.

- group:

  Group membership vector.

- reference:

  Optional reference group.

## Value

A data frame with selection rates and ratios.

## References

De Corte, W., Lievens, F., & Sackett, P. R. (2007). Combining predictors
to achieve optimal trade-offs between selection quality and adverse
impact. Journal of Applied Psychology, 92, 1380-1393.

Pyburn, K. M., Ployhart, R. E., & Kravitz, D. A. (2008). The diversity-
validity dilemma: Overview and legal context. Personnel Psychology, 61,
143-151.

## Examples

``` r
# Literature: Pyburn, Ployhart, and Kravitz (2008); De Corte et al. (2007).
adverse_impact_ratio(c(1, 0, 1, 1, 0, 0), c("A", "A", "A", "B", "B", "B"))
#>   group n selected selection_rate reference_group adverse_impact_ratio
#> 1     A 3        2      0.6666667               A                  1.0
#> 2     B 3        1      0.3333333               A                  0.5
```
