# Basic utility-analysis regression diagnostics

Fits a simple linear model and returns empirical inputs and normality
checks relevant to linear utility analysis.

## Usage

``` r
utility_regression_diagnostics(x, y)
```

## Arguments

- x:

  Predictor scores.

- y:

  Criterion scores in raw or monetary units.

## Value

A list with sample size, validity, SDy, regression coefficients,
residual summaries, optional Shapiro-Wilk tests, and the fitted model.

## References

Holling, H. (1998). Utility analysis of personnel selection: An overview
and empirical study based on objective performance measures. Methods of
Psychological Research Online, 3(1), 5-24.

## Examples

``` r
# Literature: Holling (1998).
utility_regression_diagnostics(1:10, c(2, 3, 3, 5, 4, 6, 7, 8, 8, 10))
#> $n
#> [1] 10
#> 
#> $validity
#> [1] 0.9756157
#> 
#> $sdy
#> [1] 2.633122
#> 
#> $slope
#> [1] 0.8484848
#> 
#> $intercept
#> [1] 0.9333333
#> 
#> $mean_residual
#> [1] -2.150515e-17
#> 
#> $residual_sd
#> [1] 0.5779332
#> 
#> $shapiro_y
#> 
#>  Shapiro-Wilk normality test
#> 
#> data:  y
#> W = 0.95381, p-value = 0.7136
#> 
#> 
#> $shapiro_residuals
#> 
#>  Shapiro-Wilk normality test
#> 
#> data:  res
#> W = 0.91894, p-value = 0.3482
#> 
#> 
#> $model
#> 
#> Call:
#> stats::lm(formula = y ~ x)
#> 
#> Coefficients:
#> (Intercept)            x  
#>      0.9333       0.8485  
#> 
#> 
```
