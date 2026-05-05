# Correlation of a weighted composite with an external variable

Implements the standard formula \\r\_{C,Y} = (w' \rho\_{XY}) / \sqrt{w'
R\_{XX} w}\\ for the correlation between a weighted composite of items
and an external criterion `Y`, where the items have correlations `R_XX`
and individual validities `\rho_{XY}` (Lord & Novick, 1968, Ch. 4).

## Usage

``` r
fuse_validity(weights, item_cor, item_validities)
```

## Arguments

- weights:

  Composite weights.

- item_cor:

  Predictor (item) correlation matrix.

- item_validities:

  Item-level correlations with the external variable.

## Value

Scalar correlation.

## Examples

``` r
R <- matrix(c(1, .3, .3, 1), 2, 2)
fuse_validity(c(.5, .5), R, item_validities = c(.30, .25))
#> [1] 0.3410955
```
