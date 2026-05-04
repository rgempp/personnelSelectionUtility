# Multi-attribute utility

Computes additive multi-attribute utility `sum(weights * utilities)` for
one or more alternatives.

## Usage

``` r
multiattribute_utility(values, weights, utility_functions = NULL)
```

## Arguments

- values:

  Numeric vector or matrix of attribute values. Alternatives are rows.

- weights:

  Attribute weights. They are normalized to sum to one.

- utility_functions:

  Optional list of transformation functions, one per attribute.

## Value

Numeric utility score per alternative.

## References

Keeney, R. L., & Raiffa, H. (1976). Decisions with multiple objectives:
Preferences and value tradeoffs. Wiley.

Roth, P. L., & Bobko, P. (1997). A research agenda for multi-attribute
utility analysis in human resource management. Human Resource Management
Review, 7, 341-368.

Roth, P. L. (1994). Multi-attribute utility analysis using the PROMES
approach. Journal of Business and Psychology, 9, 69-80.

## Examples

``` r
# Literature: Keeney and Raiffa (1976); Roth (1994); Roth and Bobko (1997).
multiattribute_utility(matrix(c(80, .90, 70, .95), nrow = 2, byrow = TRUE),
                       weights = c(.7, .3))
#> [1] 56.270 49.285
```
