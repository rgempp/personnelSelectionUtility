# Correlation matrix between several weighted composites

Given a stack of items and a weight matrix `W` whose columns are
composite-specific weight vectors, computes the correlation matrix
between the resulting composites under the standard Lord-Novick formula.

## Usage

``` r
fuse_composite_cor(weights_matrix, item_cor)
```

## Arguments

- weights_matrix:

  `p x m` matrix; column `j` is the weight vector of composite `j`.

- item_cor:

  `p x p` correlation matrix among items.

## Value

`m x m` correlation matrix among composites.

## Examples

``` r
R <- diag(4); R[lower.tri(R)] <- R[upper.tri(R)] <- .25
W <- cbind(c(1, 1, 0, 0), c(0, 0, 1, 1))
fuse_composite_cor(W, R)
#>      [,1] [,2]
#> [1,]  1.0  0.4
#> [2,]  0.4  1.0
```
