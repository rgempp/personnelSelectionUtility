# Binomial sampling probabilities for Taylor-Russell success rates

Converts a Taylor-Russell success ratio into finite-sample
probabilities. This follows the finite-sampling logic discussed by
Thomas, Owen, and Gunst: once a conditional probability of success is
known, the number of successful selected applicants in a finite cohort
can be modeled with a binomial distribution.

## Usage

``` r
tr_binomial_success_probability(n_selected, ppv, at_least = NULL)
```

## Arguments

- n_selected:

  Number of selected applicants.

- ppv:

  Positive predictive value / success ratio among selected applicants.

- at_least:

  Optional threshold for computing `P(successes >= at_least)`.

## Value

A data frame with the full binomial distribution and, if requested, the
cumulative upper-tail probability.

## References

Thomas, J. G., Owen, D. B., & Gunst, R. F. (1977). Improving the use of
educational tests as selection tools. Journal of Educational Statistics,
2(1), 55-77.

## Examples

``` r
# Literature: Thomas, Owen, and Gunst (1977).
tr_binomial_success_probability(n_selected = 20, ppv = .91, at_least = 18)
#>    successes  probability
#> 1          0 1.215767e-21
#> 2          1 2.458550e-19
#> 3          2 2.361574e-17
#> 4          3 1.432688e-15
#> 5          4 6.156580e-14
#> 6          5 1.991996e-12
#> 7          6 5.035322e-11
#> 8          7 1.018254e-09
#> 9          8 1.673048e-08
#> 10         9 2.255516e-07
#> 11        10 2.508636e-06
#> 12        11 2.305918e-05
#> 13        12 1.748654e-04
#> 14        13 1.088051e-03
#> 15        14 5.500705e-03
#> 16        15 2.224729e-02
#> 17        16 7.029527e-02
#> 18        17 1.672384e-01
#> 19        18 2.818277e-01
#> 20        19 2.999570e-01
#> 21        20 1.516449e-01
```
