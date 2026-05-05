# Naylor-Shine expected criterion gain

Computes expected standardized criterion gain among selected applicants
and, optionally, converts it to utility using `sdy`, `n_selected`,
`tenure`, and `cost`. The expected standardized criterion gain is
`validity * selected_mean_z(selection_ratio)`.

## Usage

``` r
naylor_shine(
  validity,
  selection_ratio,
  sdy = 1,
  n_selected = 1,
  tenure = 1,
  cost = 0
)
```

## Arguments

- validity:

  Predictor-criterion validity, usually denoted `r_xy`.

- selection_ratio:

  Selection ratio, usually denoted `SR`.

- sdy:

  Standard deviation of job performance in monetary or criterion units.

- n_selected:

  Number of selected applicants.

- tenure:

  Expected tenure or number of periods.

- cost:

  Total cost.

## Value

A `psu_ns` object.

## References

Naylor, J. C., & Shine, L. C. (1965). A table for determining the
increase in mean criterion score obtained by using a selection device.
Journal of Industrial Psychology, 3, 33-42.

## Examples

``` r
# Literature: Naylor and Shine (1965).
# Use the first call as a minimal example; the longer block illustrates
# how to interpret the function in the substantive setting discussed in the literature.
# Minimal example: standardized criterion gain only.
naylor_shine(validity = .35, selection_ratio = .20)
#> <psu_ns>
#>   validity: 0.35
#>   selection_ratio: 0.2
#>   selected_mean_z: 1.39981
#>   expected_criterion_z: 0.489933
#>   sdy: 1
#>   n_selected: 1
#>   tenure: 1
#>   cost: 0
#>   gross_utility: 0.489933
#>   net_utility: 0.489933

# Substantive example (Naylor and Shine (1965)): standardized gain translated to monetary utility.
naylor_shine(
  validity = .35,
  selection_ratio = .20,
  sdy = 50000,
  n_selected = 100,
  tenure = 3,
  cost = 75000
)
#> <psu_ns>
#>   validity: 0.35
#>   selection_ratio: 0.2
#>   selected_mean_z: 1.39981
#>   expected_criterion_z: 0.489933
#>   sdy: 50000
#>   n_selected: 100
#>   tenure: 3
#>   cost: 75000
#>   gross_utility: 7349000
#>   net_utility: 7274000
```
