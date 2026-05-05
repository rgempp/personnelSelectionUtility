# Selection utility from expected standardized criterion performance

Computes the Ock-Oswald/BCG-style utility expression
`expected_criterion_z * sdy * n_selected - n_applicants * cost_per_applicant - fixed_cost`
from an expected standardized criterion score among selected applicants.

## Usage

``` r
selection_utility_from_z(
  expected_criterion_z,
  sdy,
  n_selected,
  n_applicants = n_selected,
  cost_per_applicant = 0,
  fixed_cost = 0,
  applicant_n = NULL
)
```

## Arguments

- expected_criterion_z:

  Expected criterion performance in standard deviation units.

- sdy:

  Monetary value of one criterion standard deviation.

- n_selected:

  Number of selected applicants.

- n_applicants:

  Number of applicants assessed. This is the preferred name in v0.4.0.

- cost_per_applicant:

  Cost per applicant assessed.

- fixed_cost:

  Additional fixed cost.

- applicant_n:

  Legacy alias for `n_applicants`. Use `n_applicants` in new code.

## Value

A `psu_comparison` object.

## References

Cronbach, L. J., & Gleser, G. C. (1965). Psychological tests and
personnel decisions (2nd ed.). University of Illinois Press.

Naylor, J. C., & Shine, L. C. (1965). A table for determining the
increase in mean criterion score obtained by using a selection device.
Journal of Industrial Psychology, 3, 33-42.

Brogden, H. E. (1946). On the interpretation of the correlation
coefficient as a measure of predictive efficiency. Journal of
Educational Psychology, 37, 65-76.

## Examples

``` r
# Literature: Naylor and Shine (1965); Brogden (1946); Cronbach and Gleser (1965).
# Minimal example: expected performance converted to monetary utility.
selection_utility_from_z(1.25, sdy = 50000, n_selected = 20,
                         n_applicants = 100, cost_per_applicant = 200)
#> <psu_comparison>
#>   Model: Utility from expected criterion z
#>   expected_criterion_z: 1.25
#>   sdy: 50000
#>   n_selected: 20
#>   n_applicants: 100
#>   applicant_n: 100
#>   cost_per_applicant: 200
#>   fixed_cost: 0
#>   gross_utility: 1250000
#>   total_cost: 20000
#>   net_utility: 1230000

# Substantive example: compare two systems from expected criterion gains.
compensatory <- selection_utility_from_z(1.25, 50000, n_selected = 20,
                                         n_applicants = 100,
                                         cost_per_applicant = 1000)
hurdle <- selection_utility_from_z(.55, 50000, n_selected = 20,
                                   n_applicants = 100,
                                   cost_per_applicant = 300)
compensatory$net_utility - hurdle$net_utility
#> [1] 630000
```
