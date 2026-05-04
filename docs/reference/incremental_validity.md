# Incremental validity for adding predictors to an existing system

Computes the difference in restricted canonical validity between a
baseline predictor set and an expanded predictor set.

## Usage

``` r
incremental_validity(
  predictor_cor,
  predictor_criterion_cor,
  criterion_cor,
  criterion_weights,
  baseline_predictors,
  added_predictors = NULL,
  focal_predictors = NULL
)
```

## Arguments

- predictor_cor:

  Predictor correlation matrix for all candidate predictors.

- predictor_criterion_cor:

  Predictor-by-criterion correlation matrix.

- criterion_cor:

  Criterion correlation matrix.

- criterion_weights:

  Fixed criterion weights.

- baseline_predictors:

  Integer indices of predictors already in the system.

- added_predictors:

  Integer indices of predictors to add. Preferred name.

- focal_predictors:

  Optional legacy/convenience alias for the expanded predictor set. If
  supplied, `added_predictors` is computed as
  `setdiff(focal_predictors, baseline_predictors)`. New code should use
  `added_predictors`.

## Value

A `psu_incremental_validity` object.

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
Rxx <- matrix(c(1, .30, .20, .30, 1, .25, .20, .25, 1), 3, 3)
Rxy <- matrix(c(.30, .20, .25, .15, .10, .35), 3, 2, byrow = TRUE)
Ryy <- matrix(c(1, .40, .40, 1), 2, 2)
incremental_validity(Rxx, Rxy, Ryy, c(.6, .4), baseline_predictors = 1:2,
                     added_predictors = 3)
#> <psu_incremental_validity>
#>   baseline_validity: 0.34905
#>   expanded_validity: 0.379438
#>   incremental_validity: 0.0303873
#>   added_predictors: 3

# Substantive example (Sturman (2001)): compare two possible additions to the same baseline.
add_2 <- incremental_validity(Rxx, Rxy, Ryy, c(.6, .4),
                              baseline_predictors = 1, added_predictors = 2)
add_3 <- incremental_validity(Rxx, Rxy, Ryy, c(.6, .4),
                              baseline_predictors = 1, added_predictors = 3)
c(add_predictor_2 = add_2$incremental_validity,
  add_predictor_3 = add_3$incremental_validity)
#> add_predictor_2 add_predictor_3 
#>      0.04092063      0.04822659 
```
