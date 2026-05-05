# Restricted canonical validity for a fixed criterion composite

Computes Sturman-style restricted canonical validity. Predictor weights
are optimized, but criterion weights are fixed by the analyst.

## Usage

``` r
restricted_canonical_validity(
  predictor_cor,
  predictor_criterion_cor,
  criterion_cor,
  criterion_weights
)
```

## Arguments

- predictor_cor:

  Predictor correlation matrix, `Sigma_11`.

- predictor_criterion_cor:

  Matrix of predictor-criterion correlations, `Sigma_12`, with
  predictors in rows and criteria in columns.

- criterion_cor:

  Criterion correlation matrix, `Sigma_22`.

- criterion_weights:

  Fixed criterion weights, `b`.

## Value

A `psu_incremental_validity` object with restricted canonical validity
and optimized standardized predictor weights.

## References

Sturman, M. C. (2001). Utility analysis for multiple selection devices
and multiple outcomes. Journal of Human Resource Costing and Accounting,
6(2), 9-28.

## Examples

``` r
# Literature: Sturman (2001).
# Use the first call as a minimal example; the longer block illustrates
# how to interpret the function in the substantive setting discussed in the literature.
# Minimal example (Sturman (2001)).
S11 <- matrix(c(1, .30, .30, 1), 2, 2)
S12 <- matrix(c(.30, .20, .25, .15), 2, 2)
S22 <- matrix(c(1, .40, .40, 1), 2, 2)
restricted_canonical_validity(S11, S12, S22, criterion_weights = c(.6, .4))
#> <psu_incremental_validity>
#>   validity: 0.352614

# Substantive example (Sturman (2001)): change criterion weights and compare restricted validity.
task_weighted <- restricted_canonical_validity(S11, S12, S22, c(.8, .2))
balanced <- restricted_canonical_validity(S11, S12, S22, c(.5, .5))
c(task_weighted = task_weighted$validity, balanced = balanced$validity)
#> task_weighted      balanced 
#>     0.3442567     0.3485223 
```
