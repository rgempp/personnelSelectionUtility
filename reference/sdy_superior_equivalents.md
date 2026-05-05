# SDy from superior-equivalents judgments

Computes SDy from a judged monetary difference between a superior and a
typical performer, divided by the standardized distance assumed to
separate them.

## Usage

``` r
sdy_superior_equivalents(superior_value, typical_value, z_difference = 1)
```

## Arguments

- superior_value:

  Monetary value of the superior performer.

- typical_value:

  Monetary value of the typical performer.

- z_difference:

  Standardized distance between the two performers. Defaults to `1`, but
  can be set to another value if the judgment anchors imply it.

## Value

Estimated SDy.

## References

Eaton, N. K., Wing, H., & Mitchell, K. J. (1985). Alternate methods of
estimating the dollar value of performance. Personnel Psychology, 38,
27-40.

Burke, M. J., & Frederick, J. T. (1984). Two modified procedures for
estimating standard deviations in utility analyses. Journal of Applied
Psychology, 69, 482-489.

Burke, M. J., & Frederick, J. T. (1986). A comparison of economic
utility estimates for alternative SDy estimation procedures. Journal of
Applied Psychology, 71, 334-339.

## Examples

``` r
# Literature: Eaton, Wing, and Mitchell (1985); Burke and Frederick (1984, 1986).
sdy_superior_equivalents(superior_value = 140000, typical_value = 100000)
#> [1] 40000
```
