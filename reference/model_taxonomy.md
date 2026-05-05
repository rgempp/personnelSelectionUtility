# Utility-analysis model taxonomy

Returns the package's working taxonomy: criterion scale crossed with
selection structure. The taxonomy is designed to keep the
Taylor-Russell, Brogden-Cronbach-Gleser, Sturman, Ock-Oswald, and
Thomas-Owen-Gunst formulations distinct.

## Usage

``` r
model_taxonomy()
```

## Value

A data frame with model families, decision structures, and package
functions.

## References

Thomas, J. G., Owen, D. B., & Gunst, R. F. (1977). Improving the use of
educational tests as selection tools. Journal of Educational Statistics,
2(1), 55-77.

Ock, J., & Oswald, F. L. (2018). The utility of personnel selection
decisions: Comparing compensatory and multiple-hurdle selection models.
Journal of Personnel Psychology, 17(4), 172-182.

## Examples

``` r
# Literature: Thomas, Owen, and Gunst (1977); Ock and Oswald (2018).
model_taxonomy()
#>               criterion_scale
#> 1 classification/dichotomized
#> 2 classification/dichotomized
#> 3 classification/dichotomized
#> 4         continuous/monetary
#> 5         continuous/monetary
#> 6         continuous/monetary
#> 7         continuous/monetary
#> 8             multi-attribute
#>                                             selection_structure
#> 1                              compensatory or single predictor
#> 2   conjunctive multiple-hurdle with specified marginal cutoffs
#> 3 conjunctive multiple-hurdle with target joint selection ratio
#> 4                                         compensatory top-down
#> 5                               incremental compensatory system
#> 6                         sequential/multiple-hurdle simulation
#> 7                          diagnostics and SDy input estimation
#> 8                                             multiple criteria
#>                                        model_family
#> 1                             Taylor-Russell (1939)
#> 2                          Thomas-Owen-Gunst (1977)
#> 3    Thomas-Owen-Gunst tables / equal-cutoff design
#> 4               Naylor-Shine / BCG / SHP / Boudreau
#> 5       Sturman-style restricted canonical validity
#> 6                       Ock-Oswald-style comparison
#> 7 Holling-style empirical checks and SDy estimation
#> 8                    MAUA / Pareto decision support
#>                                                                                                               primary_functions
#> 1                                                                                                      tr_classic(), tr_solve()
#> 2                                                                                                             tr_multivariate()
#> 3                                                             tr_multivariate_equal_cutoff(), tr_binomial_success_probability()
#> 4                                                              naylor_shine(), bcg_utility(), shp_utility(), boudreau_utility()
#> 5                                                                       restricted_canonical_validity(), incremental_validity()
#> 6 compensatory_selection(), multiple_hurdle_selection(), multiple_hurdle_selection_staged(), compare_selection_systems_staged()
#> 7                                         sdy_observed(), sdy_cost_accounting(), sdy_crepid(), utility_regression_diagnostics()
#> 8                                                      multiattribute_utility(), pareto_frontier(), utility_fairness_frontier()
```
