# Convert Cohen's d to a correlation

Uses \\r = d / \sqrt{d^2 + 4}\\.

## Usage

``` r
d_to_cor(d)
```

## Arguments

- d:

  Cohen's d.

## Value

Correlation coefficient.

## References

Schmidt, F. L., Hunter, J. E., & Pearlman, K. (1982). Assessing the
economic impact of personnel programs on workforce productivity.
Personnel Psychology, 35, 333-347.

Cohen, J. (1988). Statistical power analysis for the behavioral sciences
(2nd ed.). Erlbaum.

## Examples

``` r
# Literature: Cohen (1988); Schmidt, Hunter, and Pearlman (1982).
d_to_cor(.50)
#> [1] 0.2425356
```
