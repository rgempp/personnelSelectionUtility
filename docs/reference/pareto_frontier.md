# Pareto frontier indicator

Identifies non-dominated alternatives for objectives to be maximized or
minimized.

## Usage

``` r
pareto_frontier(objectives, maximize = TRUE)
```

## Arguments

- objectives:

  Numeric matrix/data frame. Alternatives are rows, objectives columns.

- maximize:

  Logical vector indicating whether each objective is to be maximized.
  Scalar values are recycled.

## Value

Logical vector indicating Pareto-efficient rows.

## References

De Corte, W., Lievens, F., & Sackett, P. R. (2007). Combining predictors
to achieve optimal trade-offs between selection quality and adverse
impact. Journal of Applied Psychology, 92, 1380-1393. De Corte, W.,
Sackett, P. R., & Lievens, F. (2011). Designing Pareto-optimal selection
systems: Formalizing the decisions required for selection system
development. Journal of Applied Psychology, 96, 907-926.

## Examples

``` r
# Literature: De Corte, Lievens, and Sackett (2007); De Corte, Sackett, and Lievens (2011).
pareto_frontier(data.frame(validity = c(.30, .35, .32), diversity = c(.80, .70, .85)))
#> [1] FALSE  TRUE  TRUE
```
