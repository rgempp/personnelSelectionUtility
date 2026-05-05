# Dominance analysis for predictor importance

Implements Budescu's (1993) dominance analysis to decompose the
coefficient of determination of a multiple regression into contributions
attributable to each predictor. Three dominance summaries are returned:

## Usage

``` r
dominance_analysis(predictor_cor, predictor_criterion_cor)
```

## Arguments

- predictor_cor:

  Predictor correlation matrix `R_xx`.

- predictor_criterion_cor:

  Vector of predictor-criterion correlations `r_xy` (length `p`).

## Value

A list with components:

- r_squared_full:

  The full-model `R^2`.

- general_dominance:

  Vector of length `p` whose entries sum to `r_squared_full`.

- conditional_dominance:

  `p x p` matrix; row `i` gives the average contribution of predictor
  `i` at subset sizes `0, 1, ..., p-1`.

- complete_dominance:

  `p x p` logical matrix where entry `[i,j]` is `TRUE` if `i` completely
  dominates `j`, `FALSE` if `j` completely dominates `i`, `NA`
  otherwise.

## Details

- **Complete dominance**: predictor `i` *completely dominates* `j` if
  `R^2(S \cup {i}) > R^2(S \cup {j})` for every subset `S` not
  containing `i` or `j`. Reported as a pairwise dominance matrix.

- **Conditional dominance**: average increment of predictor `i` to `R^2`
  across subsets of size `k`, for `k = 0, ..., p-1`.

- **General dominance**: the average of conditional dominance values;
  equivalent to the Shapley value of `R^2`.

## References

Azen, R., & Budescu, D. V. (2003). The dominance analysis approach for
comparing predictors in multiple regression. *Psychological Methods*, 8,
129-148.

Budescu, D. V. (1993). Dominance analysis: A new approach to the problem
of relative importance of predictors in multiple regression.
*Psychological Bulletin*, 114, 542-551.

## Examples

``` r
Rxx <- matrix(c(1, .30, .20,
                .30, 1, .25,
                .20, .25, 1), 3, 3)
rxy <- c(.40, .30, .25)
dominance_analysis(Rxx, rxy)
#> <psu_dominance>
#>   r_squared_full: 0.214657
```
