# Estimate SDy from percentile judgments

Implements the percentile approximation `SDy = (P85 - P15) / 2`.

## Usage

``` r
sdy_percentile(p15, p85)
```

## Arguments

- p15:

  Estimated monetary value of performance at the 15th percentile.

- p85:

  Estimated monetary value of performance at the 85th percentile.

## Value

Estimated standard deviation of job performance in monetary units.

## References

Bobko, P., Karren, R., & Parkington, J. J. (1983). Estimation of
standard deviations in utility analyses: An empirical test. Journal of
Applied Psychology, 68, 170-176.

Schmidt, F. L., Hunter, J. E., McKenzie, R. C., & Muldrow, T. W. (1979).
Impact of valid selection procedures on work-force productivity. Journal
of Applied Psychology, 64, 609-626.

## Examples

``` r
# Literature: Schmidt et al. (1979); Bobko, Karren, and Parkington (1983).
sdy_percentile(p15 = 60000, p85 = 140000)
#> [1] 40000
```
