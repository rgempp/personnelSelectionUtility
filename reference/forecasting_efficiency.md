# Forecasting efficiency

Computes the proportional reduction in the standard error of prediction:
`1 - sqrt(1 - validity^2)`.

## Usage

``` r
forecasting_efficiency(validity)
```

## Arguments

- validity:

  Predictor-criterion validity coefficient.

## Value

Numeric vector with forecasting efficiency values.

## References

Holling, H. (1998). Utility analysis of personnel selection: An overview
and empirical study based on objective performance measures. Methods of
Psychological Research Online, 3(1), 5-24.

## Examples

``` r
# Literature: Holling (1998).
forecasting_efficiency(.30)
#> [1] 0.0460608
```
