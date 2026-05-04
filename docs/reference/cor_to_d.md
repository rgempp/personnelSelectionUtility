# Convert a correlation to Cohen's d

Uses the common two-group approximation `d = 2r / sqrt(1 - r^2)`.

## Usage

``` r
cor_to_d(r)
```

## Arguments

- r:

  Correlation coefficient.

## Value

Cohen's d.

## References

Schmidt, F. L., Hunter, J. E., & Pearlman, K. (1982). Assessing the
economic impact of personnel programs on workforce productivity.
Personnel Psychology, 35, 333-347.

Cohen, J. (1988). Statistical power analysis for the behavioral sciences
(2nd ed.). Erlbaum.

## Examples

``` r
# Literature: Cohen (1988); Schmidt, Hunter, and Pearlman (1982).
cor_to_d(.30)
#> [1] 0.6289709
```
