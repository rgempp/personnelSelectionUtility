# Coefficient of determination

Computes the squared validity coefficient.

## Usage

``` r
coefficient_of_determination(validity)
```

## Arguments

- validity:

  Predictor-criterion validity coefficient.

## Value

Numeric vector with `validity^2`.

## References

Taylor, H. C., & Russell, J. T. (1939). The relationship of validity
coefficients to the practical effectiveness of tests in selection.
Journal of Applied Psychology, 23, 565-578.

Holling, H. (1998). Utility analysis of personnel selection: An overview
and empirical study based on objective performance measures. Methods of
Psychological Research Online, 3(1), 5-24.

## Examples

``` r
# Literature: Taylor and Russell (1939); Holling (1998).
coefficient_of_determination(.30)
#> [1] 0.09
```
