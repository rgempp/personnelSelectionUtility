# Break-even validity for BCG utility

Solves the validity needed to obtain zero net utility under the BCG
model.

## Usage

``` r
break_even_validity(
  selection_ratio,
  sdy,
  n_selected,
  tenure,
  cost = 0,
  baseline_validity = 0
)
```

## Arguments

- selection_ratio:

  Selection ratio.

- sdy:

  SDy.

- n_selected:

  Number selected.

- tenure:

  Expected tenure.

- cost:

  Cost.

- baseline_validity:

  Baseline validity.

## Value

Required focal validity.

## References

Boudreau, J. W. (1991). Utility analysis for decisions in human resource
management. In M. D. Dunnette & L. M. Hough (Eds.), Handbook of
industrial and organizational psychology (Vol. 2, pp. 621-745).
Consulting Psychologists Press.

Holling, H. (1998). Utility analysis of personnel selection: An overview
and empirical study based on objective performance measures. Methods of
Psychological Research Online, 3(1), 5-24.

## Examples

``` r
# Literature: Boudreau (1991); Holling (1998).
# Use the first call as a minimal example; the longer block illustrates
# how to interpret the function in the substantive setting discussed in the literature.
# Minimal example (Boudreau (1991); Holling (1998)).
break_even_validity(.20, 50000, 100, 3, cost = 75000)
#> [1] 0.003571914

# Substantive example (Boudreau, 1991; Holling, 1998).
# Required incremental validity under different costs.
costs <- c(25000, 75000, 150000)
setNames(
  break_even_validity(.20, 50000, 100, 3, cost = costs, baseline_validity = .15),
  paste0('cost_', costs)
)
#>  cost_25000  cost_75000 cost_150000 
#>   0.1511906   0.1535719   0.1571438 
```
