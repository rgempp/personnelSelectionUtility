# Observed SDy from monetary criterion data

Computes the observed standard deviation of job performance in monetary
or productivity units. This is the direct empirical counterpart to
subjective SDy estimation methods.

## Usage

``` r
sdy_observed(y, na.rm = TRUE)
```

## Arguments

- y:

  Numeric vector of monetary or productivity criterion values.

- na.rm:

  Should missing values be removed?

## Value

Observed SDy.

## References

Holling, H. (1998). Utility analysis of personnel selection: An overview
and empirical study based on objective performance measures. Methods of
Psychological Research Online, 3(1), 5-24.

## Examples

``` r
# Literature: Holling (1998).
sdy_observed(c(100, 120, 80, 150))
#> [1] 29.86079
```
