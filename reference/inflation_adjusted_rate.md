# Combine nominal discount and inflation rates

Computes `i_a = i + f + i*f`.

## Usage

``` r
inflation_adjusted_rate(discount_rate, inflation_rate)
```

## Arguments

- discount_rate:

  Real discount rate.

- inflation_rate:

  Inflation rate.

## Value

Inflation-adjusted discount rate.

## References

Tziner, A., Meir, E. I., Dahan, M., & Birati, A. (1994). An
investigation of the predictive validity and economic utility of the
assessment center for the high- management level. Canadian Journal of
Behavioural Science, 26, 228-245.

Holling, H. (1998). Utility analysis of personnel selection: An overview
and empirical study based on objective performance measures. Methods of
Psychological Research Online, 3(1), 5-24.

## Examples

``` r
# Literature: Tziner et al. (1994); Holling (1998).
inflation_adjusted_rate(.08, .025)
#> [1] 0.107
```
