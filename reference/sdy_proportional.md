# Estimate SDy with proportional rules

Computes a salary- or value-based SDy estimate using a multiplier such
as .40 or .70.

## Usage

``` r
sdy_proportional(mean_pay, multiplier = 0.4)
```

## Arguments

- mean_pay:

  Mean pay or mean output value.

- multiplier:

  Proportional SDy multiplier. Defaults to `.40`.

## Value

Estimated SDy.

## References

Schmidt, F. L., Hunter, J. E., & Pearlman, K. (1982). Assessing the
economic impact of personnel programs on workforce productivity.
Personnel Psychology, 35, 333-347.

Hunter, J. E., & Schmidt, F. L. (1982). Fitting people to jobs: The
impact of personnel selection on national productivity. In M. D.
Dunnette & E. A. Fleishman (Eds.), Human performance and productivity
(Vol. 1, pp. 233-284). Erlbaum.

## Examples

``` r
# Literature: Schmidt, Hunter, and Pearlman (1982); Hunter and Schmidt (1982).
sdy_proportional(mean_pay = 80000, multiplier = .40)
#> [1] 32000
sdy_proportional(mean_pay = 80000, multiplier = .70)
#> [1] 56000
```
