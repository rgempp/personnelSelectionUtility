# SDy from cost-accounting data

Computes individual criterion values from production units and unit
values, then returns the standard deviation of those values.

## Usage

``` r
sdy_cost_accounting(units, unit_values, na.rm = TRUE)
```

## Arguments

- units:

  Numeric matrix or data frame. Rows are employees; columns are
  production units, activities, or outputs.

- unit_values:

  Numeric vector of monetary values per unit. Length one or one value
  per column of `units`.

- na.rm:

  Should missing values be removed in the SD calculation?

## Value

A list with individual criterion values and `sdy`.

## References

Cronbach, L. J., & Gleser, G. C. (1965). Psychological tests and
personnel decisions (2nd ed.). University of Illinois Press.

Holling, H. (1998). Utility analysis of personnel selection: An overview
and empirical study based on objective performance measures. Methods of
Psychological Research Online, 3(1), 5-24.

Cascio, W. F. (1982). Costing human resources: The financial impact of
behavior in organizations. Kent.

## Examples

``` r
# Literature: Cronbach and Gleser (1965); Cascio (1982); Holling (1998).
sdy_cost_accounting(matrix(c(10, 12, 8, 11), ncol = 2), unit_values = c(100, 200))
#> $y
#> [1] 2600 3400
#> 
#> $sdy
#> [1] 565.6854
#> 
```
