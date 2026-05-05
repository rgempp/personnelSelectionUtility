# Selection table and classification metrics

Computes a 2x2 classification table from observed selected/success
outcomes.

## Usage

``` r
selection_table(selected, success)
```

## Arguments

- selected:

  Logical or 0/1 vector indicating selection.

- success:

  Logical or 0/1 vector indicating criterion success.

## Value

A list with table and classification metrics.

## References

Thomas, J. G., Owen, D. B., & Gunst, R. F. (1977). Improving the use of
educational tests as selection tools. Journal of Educational Statistics,
2(1), 55-77.

Taylor, H. C., & Russell, J. T. (1939). The relationship of validity
coefficients to the practical effectiveness of tests in selection.
Journal of Applied Psychology, 23, 565-578.

## Examples

``` r
# Literature: Taylor and Russell (1939); Thomas, Owen, and Gunst (1977).
selection_table(c(1, 1, 0, 0), c(1, 0, 1, 0))
#> $table
#>         success
#> selected yes no
#>      yes   1  1
#>      no    1  1
#> 
#> $base_rate
#> [1] 0.5
#> 
#> $selection_ratio
#> [1] 0.5
#> 
#> $ppv
#> [1] 0.5
#> 
#> $sensitivity
#> [1] 0.5
#> 
#> $specificity
#> [1] 0.5
#> 
```
