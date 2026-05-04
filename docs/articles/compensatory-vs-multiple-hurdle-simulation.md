# Compensatory versus multiple-hurdle selection simulation

## The design question

A compensatory system applies a cutoff to a predictor composite. A
multiple-hurdle system applies sequential cutoffs: an applicant must
pass one stage to reach the next. Ock and Oswald (2018) argue that this
creates a cost-reliability trade-off. Compensatory systems often
preserve more information and produce higher expected criterion
performance. Multiple-hurdle systems can reduce administration costs
because expensive stages are used only for applicants who survive
earlier stages.

This vignette shows how to compare the two systems with
`personnelSelectionUtility`.

``` r

library(personnelSelectionUtility)
```

## A four-predictor example

Following the type of simulation design used by Ock and Oswald (2018),
suppose the predictors are cognitive ability, structured interview,
conscientiousness, and biodata. The criterion is job performance. We
define a plausible predictor intercorrelation matrix and
predictor-criterion validities.

``` r

Rxx <- matrix(c(
  1.00, .31, .03, .37,
  .31, 1.00, .13, .16,
  .03, .13, 1.00, .51,
  .37, .16, .51, 1.00
), 4, 4, byrow = TRUE)
validities <- c(.37, .35, .16, .23)
```

## Compensatory selection

In the compensatory system, all applicants complete all predictors and
are selected top-down on a composite. This follows the logic of Naylor
and Shine (1965) when the output is expected standardized criterion
performance.

``` r

comp <- compensatory_selection(
  predictor_cor = Rxx,
  validities = validities,
  weights = rep(1, 4),
  selection_ratio = .20,
  n_applicants = 500,
  cost_per_applicant = 1000,
  sdy = 60000
)
comp
#> <psu_comparison>
#>   composite_validity: 0.418943
#>   selection_ratio: 0.2
#>   selected_mean_z: 1.39981
#>   expected_criterion_z: 0.58644
#>   n_applicants: 500
#>   applicant_n: 500
#>   n_selected: 100
#>   cost_per_applicant: 1000
#>   total_cost: 5e+05
#>   sdy: 60000
#>   net_utility: 3018640
```

## Staged multiple-hurdle selection

Now suppose the first stage is a cheaper composite of cognitive ability,
conscientiousness, and biodata. The second stage is a structured
interview. The first stage retains 25% of applicants; the interview
retains 80% of those, giving an expected net selection ratio near .20.
This follows the staged logic examined by Sackett and Roth (1996) and
Ock and Oswald (2018).

``` r

R <- rbind(cbind(Rxx, validities), c(validities, 1))

hurdle <- multiple_hurdle_selection_staged(
  stage_predictors = list(c(1, 3, 4), 2),
  stage_selection_ratios = c(.25, .80),
  R = R,
  n_sim = 5000,
  seed = 123,
  n_applicants = 500,
  cost_per_stage = c(100, 900),
  sdy = 60000
)
hurdle
#> <psu_comparison>
#>   joint_selection_ratio: 0.2
#>   expected_criterion_z: 0.569705
#>   n_sim: 5000
#>   selected_simulated: 1000
#>   n_applicants: 500
#>   applicant_n: 500
#>   n_selected: 100
#>   total_cost: 162500
#>   sdy: 60000
#>   net_utility: 3255730
```

## Direct comparison

The convenience wrapper
[`compare_selection_systems_staged()`](https://rgempp.github.io/personnel-selection-utility/reference/compare_selection_systems_staged.md)
performs both calculations with the same inputs.

``` r

comparison <- compare_selection_systems_staged(
  predictor_cor = Rxx,
  validities = validities,
  compensatory_weights = rep(1, 4),
  compensatory_selection_ratio = .20,
  stage_predictors = list(c(1, 3, 4), 2),
  stage_selection_ratios = c(.25, .80),
  n_sim = 5000,
  seed = 123,
  n_applicants = 500,
  compensatory_cost_per_applicant = 1000,
  hurdle_cost_per_stage = c(100, 900),
  sdy = 60000
)
comparison
#> <psu_comparison>
#>   expected_criterion_z_difference: 0.0167344
#>   selection_ratio_difference: 0
#>   net_utility_difference: -237094
```

The object reports differences in expected criterion performance,
selection ratio, and net utility.

``` r

c(
  expected_z_difference = comparison$expected_criterion_z_difference,
  net_utility_difference = comparison$net_utility_difference
)
#>  expected_z_difference net_utility_difference 
#>           1.673436e-02          -2.370938e+05
```

## Cost-reliability trade-off

The substantive decision is not simply which system has higher expected
performance. It is whether the performance advantage of a more complete
compensatory system offsets its additional cost. Ock and Oswald (2018)
recommend exploring conditions rather than relying on a single point
estimate.

One way to study this is to vary `sdy` and the relative cost of the
hurdle system.

``` r

sdy_values <- c(20000, 40000, 60000)
hurdle_stage2_cost <- c(200, 500, 900)

out <- expand.grid(sdy = sdy_values, interview_cost = hurdle_stage2_cost)
out$net_utility_difference <- NA_real_

for (i in seq_len(nrow(out))) {
  cmp <- compare_selection_systems_staged(
    predictor_cor = Rxx,
    validities = validities,
    compensatory_selection_ratio = .20,
    stage_predictors = list(c(1, 3, 4), 2),
    stage_selection_ratios = c(.25, .80),
    n_sim = 3000,
    seed = 100 + i,
    n_applicants = 500,
    compensatory_cost_per_applicant = 1000,
    hurdle_cost_per_stage = c(100, out$interview_cost[i]),
    sdy = out$sdy[i]
  )
  out$net_utility_difference[i] <- cmp$net_utility_difference
}

out
#>     sdy interview_cost net_utility_difference
#> 1 20000            200             -215469.59
#> 2 40000            200             -200153.83
#> 3 60000            200              -16610.17
#> 4 20000            500             -198337.78
#> 5 40000            500               44669.64
#> 6 60000            500             -116994.78
#> 7 20000            900             -177825.88
#> 8 40000            900              197097.17
#> 9 60000            900              429377.05
```

Positive values indicate that the compensatory system has higher net
utility. Negative values indicate that the hurdle system is favored
under that cost and `SD_y` scenario.

## How to proceed in applied work

1.  Define the actual stages used by the organization.
2.  Estimate costs separately by stage. Do not use one average cost if
    early stages and late stages differ sharply.
3.  Use realistic validity coefficients and, when possible, account for
    measurement error and range restriction before utility analysis.
4.  Compare expected criterion performance and monetary utility; the two
    can disagree.
5.  Vary `SD_y`, costs, and selection ratios. A result that changes sign
    under plausible inputs should be reported as fragile.
6.  Use larger `n_sim` values for final analyses. The examples here are
    intentionally small enough for vignette execution.
7.  Incorporate adverse impact or diversity criteria if the decision has
    legal or fairness implications; see the Pareto and fairness helpers.

## References

Naylor, J. C., & Shine, L. C. (1965). A table for determining the
increase in mean criterion score obtained by using a selection device.
*Journal of Industrial Psychology*, 3, 33–42.

Ock, J., & Oswald, F. L. (2018). The utility of personnel selection
decisions: Comparing compensatory and multiple-hurdle selection models.
*Journal of Personnel Psychology*, 17(4), 172–182.

Sackett, P. R., & Roth, L. (1996). Multi-stage selection strategies: A
Monte Carlo investigation of effects on performance and minority hiring.
*Personnel Psychology*, 49, 549–572.

Sturman, M. C. (2001). Utility analysis for multiple selection devices
and multiple outcomes. *Journal of Human Resource Costing and
Accounting*, 6(2), 9–28.
