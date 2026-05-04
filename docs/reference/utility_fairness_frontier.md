# Utility-fairness Pareto frontier

Convenience wrapper around
[`pareto_frontier()`](https://rgempp.github.io/personnel-selection-utility/reference/pareto_frontier.md)
for selection-system alternatives evaluated on utility, fairness, and
optionally validity.

## Usage

``` r
utility_fairness_frontier(utility, fairness, validity = NULL)
```

## Arguments

- utility:

  Numeric vector of utility values to maximize.

- fairness:

  Numeric vector of fairness values to maximize, for example an
  adverse-impact ratio where larger values indicate smaller subgroup
  disparity.

- validity:

  Optional numeric vector of validity values to maximize.

## Value

A data frame with frontier membership.

## References

De Corte, W., Lievens, F., & Sackett, P. R. (2007). Combining predictors
to achieve optimal trade-offs between selection quality and adverse
impact. Journal of Applied Psychology, 92, 1380-1393.

Tippins, N. T., Oswald, F. L., & McPhail, S. M. (2021). Scientific,
legal, and ethical concerns about AI-based personnel selection tools: A
call to action. Personnel Assessment and Decisions, 7(2), Article 1.

## Examples

``` r
# Literature: De Corte, Lievens, and Sackett (2007); Tippins, Oswald, and McPhail (2021).
utility_fairness_frontier(utility = c(100, 120, 90), fairness = c(.80, .70, .95))
#>   utility fairness pareto_efficient
#> 1     100     0.80             TRUE
#> 2     120     0.70             TRUE
#> 3      90     0.95             TRUE
```
