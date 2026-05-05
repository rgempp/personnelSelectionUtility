# Risk-adjusted utility

Computes a mean-variance risk-adjusted utility score. With
`risk_aversion = 0`, the score equals expected utility. Larger values
penalize uncertainty more strongly.

## Usage

``` r
risk_adjusted_utility(expected_utility, utility_sd, risk_aversion = 0)
```

## Arguments

- expected_utility:

  Expected utility or mean posterior/simulation utility.

- utility_sd:

  Standard deviation of utility.

- risk_aversion:

  Non-negative risk-aversion parameter.

## Value

Risk-adjusted utility score.

## References

Bhattacharya, M., & Wright, P. M. (2005). Managing human assets in an
uncertain world: Applying real options theory to HRM. International
Journal of Human Resource Management, 16, 929-948.

Cronshaw, S. F., Alexander, R. A., Wiesner, W. H., & Barrick, M. R.
(1987). Incorporating risk into selection utility. Organizational
Behavior and Human Decision Processes, 40, 270-286.

## Examples

``` r
# Literature: Cronshaw et al. (1987); Bhattacharya and Wright (2005).
risk_adjusted_utility(expected_utility = 100000, utility_sd = 25000,
                      risk_aversion = 1e-6)
#> [1] 99687.5
```
