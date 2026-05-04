# Schmidt-Hunter-Pearlman intervention utility

Computes utility from an intervention effect size rather than from a
selection validity coefficient. This is appropriate for training or
intervention designs where the key input is a standardized mean
difference.

## Usage

``` r
shp_utility(effect_size_d, sdy, n_treated, tenure, cost = 0)
```

## Arguments

- effect_size_d:

  Standardized mean difference caused by the intervention.

- sdy:

  Standard deviation of job performance in monetary units.

- n_treated:

  Number of employees receiving the intervention.

- tenure:

  Expected duration of the effect in periods.

- cost:

  Total intervention cost.

## Value

A `psu_shp` object.

## References

Schmidt, F. L., Hunter, J. E., & Pearlman, K. (1982). Assessing the
economic impact of personnel programs on workforce productivity.
Personnel Psychology, 35, 333-347.

Cohen, J. (1988). Statistical power analysis for the behavioral sciences
(2nd ed.). Erlbaum.

## Examples

``` r
# Literature: Schmidt, Hunter, and Pearlman (1982); Cohen (1988).
# Use the first call as a minimal example; the longer block illustrates
# how to interpret the function in the substantive setting discussed in the literature.
# Minimal example (Schmidt, Hunter, and Pearlman (1982); Cohen (1988)).
shp_utility(effect_size_d = .30, sdy = 50000, n_treated = 100,
            tenure = 2, cost = 40000)
#> <psu_shp>
#>   effect_size_d: 0.3
#>   approximate_r: 0.14834
#>   sdy: 50000
#>   n_treated: 100
#>   tenure: 2
#>   cost: 40000
#>   gross_utility: 3e+06
#>   net_utility: 2960000

# Substantive example (Schmidt, Hunter, and Pearlman, 1982;
# Cohen, 1988). Compare two training designs.
short_training <- shp_utility(.20, 50000, n_treated = 120, tenure = 1, cost = 30000)
intensive_training <- shp_utility(.35, 50000, n_treated = 120, tenure = 1,
                                  cost = 95000)
c(short = short_training$net_utility, intensive = intensive_training$net_utility)
#>     short intensive 
#>   1170000   2005000 
```
