# SDy from a simplified CREPID-style activity decomposition

Computes a monetary performance index by weighting activity ratings with
activity time/frequency and importance weights.

## Usage

``` r
sdy_crepid(
  activities,
  ratings,
  salary,
  time_col = "time_frequency",
  importance_col = "importance",
  activity_names = NULL,
  na.rm = TRUE
)
```

## Arguments

- activities:

  Data frame with activity-level metadata.

- ratings:

  Numeric matrix/data frame. Rows are employees, columns are activities.

- salary:

  Average salary or criterion value to distribute across activities.

- time_col:

  Name of the time/frequency column in `activities`.

- importance_col:

  Name of the importance column in `activities`.

- activity_names:

  Optional activity labels.

- na.rm:

  Should missing values be removed in the SD calculation?

## Value

A list with activity weights, individual criterion values, and `sdy`.

## References

Cascio, W. F., & Ramos, R. A. (1986). Development and application of a
new method for assessing job performance in behavioral/economic terms.
Journal of Applied Psychology, 71, 20-28.

## Examples

``` r
# Literature: Cascio and Ramos (1986).
activities <- data.frame(time_frequency = c(.4, .6), importance = c(2, 3))
ratings <- matrix(c(3, 4, 2, 5, 4, 4), ncol = 2, byrow = TRUE)
sdy_crepid(activities, ratings, salary = 80000)
#> $activity_weights
#>     activity time_frequency importance raw_weight final_weight dollar_value
#> 1 activity_1            0.4          2        0.8    0.3076923     24615.38
#> 2 activity_2            0.6          3        1.8    0.6923077     55384.62
#> 
#> $y
#> [1] 295384.6 326153.8 320000.0
#> 
#> $sdy
#> [1] 16281.55
#> 
```
