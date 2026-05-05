# Direct range-restriction correction for selection on the predictor

Corrects a restricted validity coefficient for direct range restriction
on the predictor using the standard Thorndike Case II expression.

## Usage

``` r
correct_r_direct_range_restriction(
  r_restricted,
  range_restriction_ratio = NULL,
  u = NULL
)
```

## Arguments

- r_restricted:

  Restricted-sample validity coefficient.

- range_restriction_ratio:

  Ratio of unrestricted to restricted predictor standard deviations.
  This is the preferred v0.4.0 name for the literature's `u`.

- u:

  Legacy alias for `range_restriction_ratio`.

## Value

Corrected validity coefficient.

## References

Sackett, P. R., Laczo, R. M., & Arvey, R. D. (2002). The effects of
range restriction on estimates of criterion interrater reliability:
Implications for validation research. Personnel Psychology, 55, 807-825.

Ree, M. J., Carretta, T. R., Earles, J. A., & Albert, W. (1994). Sign
changes when correcting for range restriction: A note on Pearson's and
Lawley's selection formulas. Journal of Applied Psychology, 79, 298-301.

Lawley, D. N. (1943). A note on Karl Pearson's selection formulae.
Proceedings of the Royal Society of Edinburgh, Section A, 62, 28-30.

## Examples

``` r
# Literature: Lawley (1943); Sackett, Laczo, and Arvey (2002); Ree et al. (1994).
correct_r_direct_range_restriction(.25, range_restriction_ratio = 1.40)
#> [1] 0.3399501
correct_r_direct_range_restriction(.25, u = 1.40)
#> [1] 0.3399501
```
