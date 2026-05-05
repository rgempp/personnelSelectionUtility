# Compute employee flows across periods

Computes retained headcount after hires and losses:
`N_t = initial + cumsum(hired - lost)`.

## Usage

``` r
employee_flow(hired, lost, initial = 0)
```

## Arguments

- hired:

  Number hired in each period.

- lost:

  Number lost in each period.

- initial:

  Initial headcount.

## Value

Numeric vector of headcount by period.

## References

Boudreau, J. W., & Berger, C. J. (1985). Decision-theoretic utility
analysis applied to employee separations and acquisitions. Journal of
Applied Psychology, 70, 581-612.

Boudreau, J. W. (1991). Utility analysis for decisions in human resource
management. In M. D. Dunnette & L. M. Hough (Eds.), Handbook of
industrial and organizational psychology (Vol. 2, pp. 621-745).
Consulting Psychologists Press.

## Examples

``` r
# Literature: Boudreau and Berger (1985); Boudreau (1991).
employee_flow(hired = c(100, 20, 20), lost = c(0, 30, 25))
#> [1] 100  90  85
```
