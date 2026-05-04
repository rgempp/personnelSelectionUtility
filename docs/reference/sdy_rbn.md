# Estimate SDy with a coefficient-of-variation approach

A compact implementation of the Raju-Burke-Normand logic:
`SDy = CV * mean_pay`. Use this function when the coefficient of
variation is theoretically or empirically justified for the job family.

## Usage

``` r
sdy_rbn(mean_pay, coefficient_variation)
```

## Arguments

- mean_pay:

  Mean pay or mean criterion value.

- coefficient_variation:

  Coefficient of variation for job performance value.

## Value

Estimated SDy.

## References

Raju, N. S., Burke, M. J., & Normand, J. (1990). A new approach for
utility analysis. Journal of Applied Psychology, 75, 3-12.

## Examples

``` r
# Literature: Raju, Burke, and Normand (1990).
sdy_rbn(mean_pay = 80000, coefficient_variation = .35)
#> [1] 28000
```
