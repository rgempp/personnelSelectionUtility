# Disattenuated correlation (Spearman, 1904)

Corrects an observed correlation for unreliability in either or both
variables.

## Usage

``` r
disattenuate_correlation(r_observed, reliability_x = 1, reliability_y = 1)
```

## Arguments

- r_observed:

  Observed correlation.

- reliability_x:

  Reliability of `X` (default 1, i.e., no correction).

- reliability_y:

  Reliability of `Y` (default 1).

## Value

Disattenuated correlation. Capped at +/- 1 with a warning when the
algebraic value exceeds 1 in magnitude (typically a sign of unreliable
reliability inputs).

## References

Spearman, C. (1904). The proof and measurement of association between
two things. *American Journal of Psychology*, 15, 72-101.

## Examples

``` r
disattenuate_correlation(0.30, reliability_x = 0.80, reliability_y = 0.70)
#> [1] 0.4008919
```
