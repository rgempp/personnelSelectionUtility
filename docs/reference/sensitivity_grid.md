# Sensitivity grid for BCG utility

Computes BCG net utility for all combinations of selected parameter
values.

## Usage

``` r
sensitivity_grid(validity, selection_ratio, sdy, n_selected, tenure, cost = 0)
```

## Arguments

- validity:

  Numeric vector of validities.

- selection_ratio:

  Numeric vector of selection ratios.

- sdy:

  Numeric vector of SDy values.

- n_selected:

  Number selected.

- tenure:

  Expected tenure.

- cost:

  Cost.

## Value

A data frame with one row per scenario.

## References

Cronshaw, S. F., Alexander, R. A., Wiesner, W. H., & Barrick, M. R.
(1987). Incorporating risk into selection utility. Organizational
Behavior and Human Decision Processes, 40, 270-286.

Ock, J., & Oswald, F. L. (2018). The utility of personnel selection
decisions: Comparing compensatory and multiple-hurdle selection models.
Journal of Personnel Psychology, 17(4), 172-182.

Boudreau, J. W. (1991). Utility analysis for decisions in human resource
management. In M. D. Dunnette & L. M. Hough (Eds.), Handbook of
industrial and organizational psychology (Vol. 2, pp. 621-745).
Consulting Psychologists Press.

## Examples

``` r
# Literature: Cronshaw et al. (1987); Boudreau (1991); Ock and Oswald (2018).
# Use the first call as a minimal example; the longer block illustrates
# how to interpret the function in the substantive setting discussed in the literature.
# Minimal example (Cronshaw et al. (1987); Boudreau (1991); Ock and Oswald (2018)).
sensitivity_grid(validity = c(.20, .30), selection_ratio = c(.10, .20),
                 sdy = c(40000, 60000), n_selected = 100, tenure = 3)
#>   validity selection_ratio   sdy selected_mean_z net_utility
#> 1      0.2             0.1 40000        1.754983     4211960
#> 2      0.3             0.1 40000        1.754983     6317940
#> 3      0.2             0.2 40000        1.399810     3359543
#> 4      0.3             0.2 40000        1.399810     5039315
#> 5      0.2             0.1 60000        1.754983     6317940
#> 6      0.3             0.1 60000        1.754983     9476910
#> 7      0.2             0.2 60000        1.399810     5039315
#> 8      0.3             0.2 60000        1.399810     7558972

# Substantive example (Cronshaw et al., 1987; Boudreau, 1991;
# Ock and Oswald, 2018). Find the best sensitivity scenario.
grid <- sensitivity_grid(validity = seq(.20, .40, .10),
                         selection_ratio = c(.10, .20, .40),
                         sdy = c(30000, 60000),
                         n_selected = 100, tenure = 3, cost = 75000)
grid[which.max(grid$net_utility), ]
#>    validity selection_ratio   sdy selected_mean_z net_utility
#> 12      0.4             0.1 60000        1.754983    12560880
```
