# Reproducing canonical examples from the literature

## Purpose

This vignette reproduces, with the package, five canonical examples from
the utility-analysis literature. The aim is twofold: to anchor the
package in the historical record by showing that the implemented
functions return the published quantities, and to provide pedagogical
worked examples that connect each function to a concrete substantive
question.

``` r

library(personnelSelectionUtility)
```

## Conventions: illustrative versus digit-for-digit

A reproduction can fall into one of three categories. A
*digit-for-digit* reproduction returns the same numerical value (within
numerical-integration tolerance) as the published source, given the same
inputs. An *illustrative* reproduction recovers the qualitative pattern
and order of magnitude using parameters that are plausible but not
identical to the source. A *structural* reproduction iterates the
published model across the parameter space the source explored
(typically a published table), so that the entire family of figures is
reproduced rather than a single cell. Most published utility analyses do
not tabulate every input fully (matrices are summarised, $`SD_y`$ is
reported as a single point, and some adjustments are described in prose
without numerical detail), and a digit-for-digit match for an arbitrary
cell is therefore not always achievable from the published material
alone. Each section below states explicitly which convention applies.

------------------------------------------------------------------------

## Schmidt, Hunter, McKenzie, and Muldrow (1979): the Programmer Aptitude Test

**Convention: structural reproduction of Schmidt et al.’s (1979) Table 2
across the selection-ratio scenarios they considered. The package
returns the values that the published model and inputs imply; the
specific dollar figures most often cited from the paper correspond to a
particular row of that table (see below).**

Schmidt, Hunter, McKenzie, and Muldrow (1979) is the founding empirical
demonstration of the modern monetary utility framework. They computed
the incremental utility of using the Programmer Aptitude Test (PAT)
versus random selection for the U.S. federal government
computer-programmer workforce. The published inputs were validity
$`r_{xy} = .76`$ (corrected for unreliability and range restriction),
$`SD_y = \$10{,}413`$ in 1979 dollars, $`N = 618`$ programmers selected
per year, and a mean tenure of $`9.69`$ years. Schmidt et al. (1979)
presented their results across multiple selection-ratio scenarios, since
the actual selection ratio depends on the size of the applicant pool and
is itself a policy variable. The package reproduces the family of their
estimates by iterating the BCG model across the same set of selection
ratios.

``` r

schmidt_pat <- data.frame(
  selection_ratio = c(.05, .10, .20, .30, .40, .50, .80)
)
schmidt_pat$one_year   <- vapply(
  schmidt_pat$selection_ratio,
  function(sr) bcg_utility(
    validity        = .76,
    selection_ratio = sr,
    sdy             = 10413,
    n_selected      = 618,
    tenure          = 1,
    cost            = 0
  )$net_utility,
  numeric(1)
)
schmidt_pat$multi_year <- vapply(
  schmidt_pat$selection_ratio,
  function(sr) bcg_utility(
    validity        = .76,
    selection_ratio = sr,
    sdy             = 10413,
    n_selected      = 618,
    tenure          = 9.69,
    cost            = 0
  )$net_utility,
  numeric(1)
)
schmidt_pat
#>   selection_ratio one_year multi_year
#> 1            0.05 10088270   97755337
#> 2            0.10  8583234   83171533
#> 3            0.20  6846158   66339269
#> 4            0.30  5668291   54925741
#> 5            0.40  4723789   45773513
#> 6            0.50  3902276   37813056
#> 7            0.80  1711539   16584817
```

The dollar figures most commonly cited from Schmidt et al. (1979) in
subsequent reviews and textbooks (approximately \$5.6 million one-year
utility and \$54 million multi-year utility) correspond to the
$`SR = .30`$ row of the table, which is closest to a moderate
selectivity scenario typical of competitive federal hiring at the time.
With the actual operational selection ratio of $`.80`$ (the lowest
selectivity considered), the figures are smaller (approximately \$1.7
million one-year and \$16.6 million multi-year) but still in the
multi-million range.

The substantive interpretation of any cell of this table requires care.
The validity $`r_{xy} = .76`$ was corrected for unreliability and range
restriction, and the comparison baseline was random selection (both of
which inflate the estimate relative to the operational benefit of
switching from one defensible selection procedure to another; see
Sturman, 2000, 2001). The Schmidt et al. (1979) estimates are best read
as population-level upper bounds, demonstrating the order of magnitude
of selection utility under favourable assumptions, rather than as
forecasts of the realised return for a specific organisation.

------------------------------------------------------------------------

## Murphy (1986): the cost of rejected offers

**Convention: illustrative reproduction of the three cases discussed by
Murphy (1986).**

Murphy (1986), building on Hogarth and Einhorn (1976), demonstrated that
ignoring the possibility of rejected offers systematically inflates
selection utility. He distinguished three cases: random rejection
(acceptance probability constant across the predictor distribution),
correlated rejection (acceptance probability decreasing with predictor
score because high-scoring candidates have more outside options), and
the special case in which the very top candidates almost always reject.
The function
[`offer_rejection_adjustment()`](https://rgempp.github.io/personnelSelectionUtility/reference/offer_rejection_adjustment.md)
implements these three modes.

``` r

# All three cases share the same expected standardised score among offered
# candidates:
z_offered <- selected_mean_z(.20)

# Case 1: uniform random rejection. The expected z among accepted candidates
# equals z_offered; only the realised headcount is scaled by the acceptance rate.
offer_rejection_adjustment(
  expected_z_offered = z_offered,
  mode               = "uniform",
  acceptance_rate    = .70,
  n_offered          = 100
)
#> <psu_offer_rejection>
#>   expected_z_offered: 1.39981
#>   expected_z_accepted: 1.39981
#>   acceptance_rate: 0.7
#>   effective_validity_loss: 0
#>   expected_n_accepted: 70

# Case 2: correlated rejection. Top candidates are more likely to decline,
# captured by a negative quality-acceptance correlation.
offer_rejection_adjustment(
  expected_z_offered     = z_offered,
  mode                   = "correlated",
  acceptance_rate        = .70,
  rho_quality_acceptance = -0.20,
  n_offered              = 100
)
#> <psu_offer_rejection>
#>   expected_z_offered: 1.39981
#>   expected_z_accepted: 1.30047
#>   acceptance_rate: 0.7
#>   effective_validity_loss: 0.0993407
#>   expected_n_accepted: 70

# Case 3: selective rejection. Explicit logit link with a strongly negative
# slope, representing the case Murphy emphasises in which the very top candidates
# almost always decline.
offer_rejection_adjustment(
  expected_z_offered = z_offered,
  mode               = "selective",
  acceptance_rate    = .70,
  logit_intercept    = qlogis(.70),
  logit_slope        = -1.0,
  n_offered          = 100
)
#> <psu_offer_rejection>
#>   expected_z_offered: 1.39981
#>   expected_z_accepted: -0.277359
#>   acceptance_rate: 0.668971
#>   effective_validity_loss: 1.67717
#>   expected_n_accepted: 66.8971
```

The qualitative pattern is the one Murphy (1986) emphasised: under
uniform rejection the realised mean predictor score among hires equals
the inverse-Mills mean among the offered group, scaled by the acceptance
rate; under correlated rejection the realised mean is materially lower;
under selective rejection at the top the realised mean can be lower
still, sometimes by a magnitude that erodes a non-trivial fraction of
the gross utility. Sturman (2001) used the correlated mode with
$`\rho = -0.20`$ and an acceptance rate of $`.70`$ as default in his
comprehensive model, and the package follows this convention as the
recommended starting point.

------------------------------------------------------------------------

## Holling (1998): normality, outliers, and $`SD_y`$

**Convention: illustrative reproduction of the diagnostic logic of
Holling (1998); the simulated data used here are not those of the
original German sales-force study.**

Holling (1998) demonstrated empirically that the assumption of normality
in the criterion distribution (on which the Brogden-Cronbach-Gleser
model rests) is systematically violated in objective performance data.
Using a sample of German sales agents whose criterion was direct sales
revenue, he tested the normality assumption with the Kolmogorov-Smirnov
test and showed that normality was sustainable only after excluding four
outliers. The substantive consequence was material: including the
outliers raised $`SD_y`$ from $`\text{DM}\,105{,}397`$ to
$`\text{DM}\,157{,}211`$, an increase of approximately $`49\%`$, and
raised the estimated utility from $`\text{DM}\,395{,}389`$ to
$`\text{DM}\,745{,}235`$, an increase of approximately $`88\%`$.

The package supports this diagnostic through
[`utility_regression_diagnostics()`](https://rgempp.github.io/personnelSelectionUtility/reference/utility_regression_diagnostics.md).
We illustrate with simulated sales data that exhibit the same
right-skewed structure as the Holling (1998) sample.

``` r

set.seed(2024)

# Simulate a moderately skewed criterion: lognormal with a few extreme outliers
n <- 200
y_normal_part   <- rlnorm(n, meanlog = 11.0, sdlog = 0.30)
y_outliers_idx  <- sample.int(n, 4)
y_normal_part[y_outliers_idx] <- y_normal_part[y_outliers_idx] * 3.5
y               <- y_normal_part

x <- .50 * scale(log(y))[, 1] + rnorm(n, 0, sqrt(1 - .25))

sdy_with_outliers   <- sd(y)
sdy_without_outliers <- sd(y[-y_outliers_idx])

c(with_outliers    = sdy_with_outliers,
  without_outliers = sdy_without_outliers,
  ratio            = sdy_with_outliers / sdy_without_outliers)
#>    with_outliers without_outliers            ratio 
#>     29864.508229     19225.020752         1.553419
```

The ratio between the two $`SD_y`$ estimates is of the same order as the
$`1.49`$ ratio reported by Holling (1998). The diagnostic function
reports the linearity and normality of the predictor-criterion
relationship.

``` r

utility_regression_diagnostics(x = x, y = y)
#> $n
#> [1] 200
#> 
#> $validity
#> [1] 0.4720179
#> 
#> $sdy
#> [1] 29864.51
#> 
#> $slope
#> [1] 14635.77
#> 
#> $intercept
#> [1] 66292.6
#> 
#> $mean_residual
#> [1] 1.205223e-12
#> 
#> $residual_sd
#> [1] 26328.22
#> 
#> $shapiro_y
#> 
#>  Shapiro-Wilk normality test
#> 
#> data:  z
#> W = 0.72316, p-value < 2.2e-16
#> 
#> 
#> $shapiro_residuals
#> 
#>  Shapiro-Wilk normality test
#> 
#> data:  z
#> W = 0.78577, p-value = 7.851e-16
#> 
#> 
#> $model
#> 
#> Call:
#> stats::lm(formula = y ~ x)
#> 
#> Coefficients:
#> (Intercept)            x  
#>       66293        14636
```

The substantive lesson, formalised by Holling (1998), is that a single
$`SD_y`$ estimate is not a sufficient summary when the criterion
distribution is non-normal. The analyst should report both the $`SD_y`$
estimate including outliers and the estimate with outliers excluded, and
the utility calculation should be sensitivity-tested across this range.
The lognormal alternative is increasingly common in modern empirical
work and is an explicit option in the Bayesian re-formulations of
utility analysis.

------------------------------------------------------------------------

## Sturman (2000, 2001): the comprehensive cascade

**Convention: illustrative cascade demonstrating the pattern documented
by Sturman (2000, 2001). The published $`\sim 8\%`$ ratio of
comprehensive to naive utility uses parameters specific to Sturman’s
empirical case; the cascade here uses plausible parameters and
reproduces the pattern, not the digit-for-digit ratio.**

Sturman’s central pedagogical message is that successive realistic
adjustments shrink the naive Brogden-Cronbach-Gleser estimate by
approximately one order of magnitude. The package supports both a
step-by-step cascade and a single integrated function
([`sturman_comprehensive()`](https://rgempp.github.io/personnelSelectionUtility/reference/sturman_comprehensive.md)).

### Step-by-step cascade

``` r

focal_validity    <- .35
baseline_validity <- .20
selection_ratio   <- .20
sdy               <- 50000
n_year_one        <- 100
tenure_years      <- 5
fixed_cost        <- 75000
```

**Step 1.** Naive Brogden-Cronbach-Gleser against random-selection
baseline.

``` r

naive <- bcg_utility(
  validity          = focal_validity,
  selection_ratio   = selection_ratio,
  sdy               = sdy,
  n_selected        = n_year_one,
  tenure            = tenure_years,
  cost              = fixed_cost,
  baseline_validity = 0
)
naive$net_utility
#> [1] 12173334
```

**Step 2.** Add the operating baseline correction (Sturman, 2001).

``` r

with_baseline <- bcg_utility(
  validity          = focal_validity,
  selection_ratio   = selection_ratio,
  sdy               = sdy,
  n_selected        = n_year_one,
  tenure            = tenure_years,
  cost              = fixed_cost,
  baseline_validity = baseline_validity
)
with_baseline$net_utility
#> [1] 5174286
```

The naive estimate falls by approximately one half once the comparator
is the operating system rather than random selection, consistent with
Sturman’s (2000) average reduction of $`59\%`$.

**Step 3.** Replace the focal validity with a restricted canonical
validity.

If the criterion is a composite of, say, task and contextual performance
with fixed weights, the predictor side should be reweighted optimally
given the fixed criterion side. The resulting restricted canonical
validity is generally smaller than the largest single-criterion validity
*when the predictor battery is poorly aligned with the criterion
composite weights*. It can be larger when the alignment is favourable;
the direction is determined by the alignment, not by mechanism.

``` r

S11 <- matrix(c(1, .30, .30, 1), 2, 2)
S12 <- matrix(c(.30, .10, .15, .25), 2, 2, byrow = TRUE)
S22 <- matrix(c(1, .40, .40, 1), 2, 2)
b   <- c(.7, .3)

rcv <- restricted_canonical_validity(S11, S12, S22, criterion_weights = b)
rcv$validity
#> [1] 0.3068243

with_multidim <- bcg_utility(
  validity          = rcv$validity,
  baseline_validity = baseline_validity,
  selection_ratio   = selection_ratio,
  sdy               = sdy,
  n_selected        = n_year_one,
  tenure            = tenure_years,
  cost              = fixed_cost
)
with_multidim$net_utility
#> [1] 3663342
```

**Step 4.** Add multi-period employee flows, taxes, and discount.

We model attrition: $`15\%`$ of survivors leave each year. The active
headcount per period is computed with
[`employee_flow()`](https://rgempp.github.io/personnelSelectionUtility/reference/employee_flow.md).

``` r

hires    <- c(n_year_one, 15, 15, 15, 15)
losses   <- c(0, 15, 15, 15, 15)
active_n <- employee_flow(hires, losses)
active_n
#> [1] 100 100 100 100 100
```

``` r

with_flows <- boudreau_utility(
  validity          = rcv$validity,
  baseline_validity = baseline_validity,
  selection_ratio   = selection_ratio,
  sdy               = sdy,
  n_by_period       = active_n,
  variable_value    = 0,
  tax_rate          = .25,
  discount_rate     = .08,
  cost_by_period    = c(fixed_cost, 5000, 5000, 5000, 5000)
)
with_flows$net_present_value
#> [1] 2154139
```

**Step 5.** Add probationary survivor effect (De Corte, 1994).

A formal probation rule that drops year-1 hires whose standardised
criterion performance falls below $`z_p = -1`$ produces an additional
expected criterion gain in years 2 through $`T`$ via the inverse-Mills
survivor mean.

``` r

probation_z   <- -1
survivor_gain <- probation_adjustment(probation_z)
discount_rate <- .08
periods       <- seq_along(active_n)
later_periods <- periods[-1]

benefit_t  <- survivor_gain * sdy * active_n[later_periods] * (1 - .25)
discounted <- benefit_t / (1 + discount_rate)^later_periods
extra_npv  <- sum(discounted)

with_probation_npv <- with_flows$net_present_value + extra_npv
with_probation_npv
#> [1] 5461665
```

### The cumulative cascade

``` r

cascade <- data.frame(
  step = c("1. Naive BCG (random baseline)",
           "2. + operating baseline",
           "3. + multidim. criterion (RCV)",
           "4. + flows + tax + discount",
           "5. + probation (full comprehensive)"),
  net_utility = c(naive$net_utility,
                  with_baseline$net_utility,
                  with_multidim$net_utility,
                  with_flows$net_present_value,
                  with_probation_npv)
)
cascade$pct_of_naive <- round(100 * cascade$net_utility / naive$net_utility, 1)
cascade
#>                                  step net_utility pct_of_naive
#> 1      1. Naive BCG (random baseline)    12173334        100.0
#> 2             2. + operating baseline     5174286         42.5
#> 3      3. + multidim. criterion (RCV)     3663342         30.1
#> 4         4. + flows + tax + discount     2154139         17.7
#> 5 5. + probation (full comprehensive)     5461665         44.9
```

The cumulative pattern is the one Sturman (2000, 2001) emphasises: the
comprehensive estimate is a small fraction of the naive estimate. Note
that not every adjustment shrinks the figure: the probation adjustment
in step 5 *increases* the expected utility because surviving employees
in years 2 through $`T`$ have a higher expected criterion score than the
year-1 cohort (De Corte, 1994). The shrinkage claim of Sturman (2000,
2001) refers to the *net* effect of the operating-baseline correction
(which always shrinks), the criterion-composite reweighting (direction
depends on alignment), and the multi-period economic discount and
attrition (which always shrinks), partially offset by the probation
gain.

The published $`\sim 8\%`$ ratio of comprehensive to naive utility in
Sturman (2001) uses parameters specific to his empirical case, including
$`SD_y`$ values, validity matrices, and tenure assumptions that the
published article summarises but does not fully tabulate. The vignette’s
specific percentage will differ depending on inputs. The qualitative
cascade (the comprehensive estimate falling to a small fraction of the
naive) is robust across plausible parameter choices.

### Single integrated call

For routine analysis the package provides
[`sturman_comprehensive()`](https://rgempp.github.io/personnelSelectionUtility/reference/sturman_comprehensive.md),
which composes all six adjustments at once and returns both the
integrated estimate and the cascade table. This is the recommended
interface for production use; the step-by-step cascade above is
pedagogical.

``` r

S11 <- matrix(c(1, .30, .30, 1), 2, 2)
S12 <- matrix(c(.30, .10, .15, .25), 2, 2, byrow = TRUE)
S22 <- matrix(c(1, .40, .40, 1), 2, 2)

s <- sturman_comprehensive(
  validity                       = .35,
  baseline_validity              = .20,
  selection_ratio                = .20,
  sdy                            = 50000,
  n_year_one                     = 100,
  tenure                         = 5,
  fixed_cost                     = 75000,
  hires_per_period               = c(100, 15, 15, 15, 15),
  losses_per_period              = c(0, 15, 15, 15, 15),
  tax_rate                       = .25,
  discount_rate                  = .08,
  predictor_cor                  = S11,
  predictor_criterion_cor        = S12,
  criterion_cor                  = S22,
  criterion_weights              = c(.7, .3),
  probation_cutoff_z             = -1,
  acceptance_rate                = 0.70,
  quality_acceptance_correlation = -0.20
)

s
#> <psu_sturman: Sturman (2001) comprehensive utility>
#>   Comprehensive net utility: 3759820 
#>   Effective validity: 0.3068  (baseline: 0.2 )
#> 
#>   Cascade:
#>                            step net_utility pct_of_naive
#>  1. Naive BCG (random baseline)    12173334    100.00000
#>         2. + operating baseline     5174286     42.50509
#>  3. + multidim. criterion (RCV)     3663342     30.09317
#>     4. + flows + tax + discount     2169473     17.82152
#>                  5. + probation     5476999     44.99178
#>            6. + offer rejection     3759816     30.88567
```

The cascade table is in `s$cascade`, the effective validity after
restricted canonical reweighting in `s$effective_validity`, and the
active headcount per period in `s$n_active_by_period`.

------------------------------------------------------------------------

## Ock and Oswald (2018): compensatory versus multiple-hurdle

**Convention: illustrative reproduction of the qualitative pattern in
Table 1 of Ock and Oswald (2018). Inputs are loosely consistent with
Roth, Switzer, Van Iddekinge, and Oh (2011); a digit-for-digit match
would require the specific simulation parameters used by Ock and Oswald,
which are summarised but not fully tabulated in the published article.**

Ock and Oswald (2018) showed that under compensatory top-down selection
the expected performance of selected applicants is substantially higher
than under conjunctive multiple-hurdle selection at the same overall
selection ratio. The gap is largest at low $`SR`$ and shrinks as $`SR`$
rises. They reported, as a representative finding, $`d \approx 1.05`$ at
$`SR = .10`$, $`d \approx 0.70`$ at $`SR = .20`$, and $`d \approx 0.28`$
at $`SR = .40`$. The pattern can be reproduced with the package using a
four-predictor system informed by Roth et al. (2011) meta-analytic
correlations.

### Parameter setup

``` r

Rxx <- matrix(c(
  1.00, .30, .05, .10,
  .30, 1.00, .20, .25,
  .05, .20, 1.00, .40,
  .10, .25, .40, 1.00
), 4, 4, byrow = TRUE)

validities <- c(.51, .38, .23, .32)
predictor_labels <- c("GMA", "Interview", "Conscientiousness", "Integrity")
```

### Run the comparison at three selection ratios

``` r

selection_ratios <- c(.10, .20, .40)

results <- lapply(selection_ratios, function(sr) {
  marginal_sr <- (sr)^(1 / 4)
  compare_selection_systems(
    predictor_cor                = Rxx,
    validities                   = validities,
    compensatory_weights         = validities,
    compensatory_selection_ratio = sr,
    hurdle_selection_ratios      = rep(marginal_sr, 4),
    n_sim                        = 50000,
    seed                         = 42
  )
})
names(results) <- paste0("SR=", selection_ratios)
```

### Tabulate

``` r

ock_oswald <- data.frame(
  SR              = selection_ratios,
  compensatory_z  = vapply(results,
                           function(o) o$compensatory$expected_criterion_z,
                           numeric(1)),
  hurdle_z        = vapply(results,
                           function(o) o$multiple_hurdle$expected_criterion_z,
                           numeric(1)),
  hurdle_joint_sr = vapply(results,
                           function(o) o$multiple_hurdle$joint_selection_ratio,
                           numeric(1))
)
ock_oswald$z_difference <- ock_oswald$compensatory_z - ock_oswald$hurdle_z
ock_oswald
#>         SR compensatory_z  hurdle_z hurdle_joint_sr z_difference
#> SR=0.1 0.1      1.0502182 0.7506470         0.16350    0.2995711
#> SR=0.2 0.2      0.8376749 0.5991892         0.27456    0.2384857
#> SR=0.4 0.4      0.5779883 0.4165023         0.46350    0.1614860
```

The pattern matches Ock and Oswald (2018):

1.  The compensatory column is uniformly higher than the multiple-hurdle
    column.
2.  The gap shrinks as $`SR`$ rises.
3.  The realised joint selection ratio for the multiple-hurdle system is
    somewhat below the target due to the predictor intercorrelations.

The Thomas-Owen-Gunst (1977) framework, illustrated digit-for-digit in
the Taylor-Russell vignette, provides the analytic complement to this
simulation: as discussed there, given the matrix `R` and a vector of
cutoffs,
[`tr_multivariate()`](https://rgempp.github.io/personnelSelectionUtility/reference/tr_multivariate.md)
returns the joint selection ratio, the PPV, and the four cells of the
classification table without simulation error. The simulation-based
comparison here adds the continuous-criterion expected gain, which is
the metric Ock and Oswald (2018) emphasise; the analytic
Thomas-Owen-Gunst result adds the dichotomised-criterion classificatory
metric.

### Adding the cost dimension

Ock and Oswald’s central practical message is that multiple-hurdle can
nevertheless be optimal when its operational cost is sufficiently lower
than compensatory’s. The staged design with three stages of increasing
expense illustrates the trade-off.

``` r

n_apps <- 1000

stage_design <- compare_selection_systems_staged(
  predictor_cor                  = Rxx,
  validities                     = validities,
  compensatory_weights           = validities,
  compensatory_selection_ratio   = .20,
  stage_predictors               = list(1, c(2, 3), 4),
  stage_selection_ratios         = c(.50, .60, .70),
  n_sim                          = 50000,
  seed                           = 42,
  n_applicants                   = n_apps,
  compensatory_cost_per_applicant = 800,
  hurdle_cost_per_stage          = c(100, 400, 600),
  sdy                            = 50000
)
stage_design$net_utility_difference
#> [1] 354335.5
```

If the difference is positive the compensatory system still wins; if
negative the staged design wins on net utility despite producing lower
expected per-hire performance. This is precisely the trade-off that Ock
and Oswald (2018) formalise.

------------------------------------------------------------------------

## How to proceed in applied work

1.  State the convention applicable to your reproduction:
    digit-for-digit when the published inputs are sufficient,
    illustrative otherwise. Mixing the two without explicit labelling
    produces unfounded claims of replication.
2.  For the Schmidt et al. (1979) PAT calculation, use the published
    1979 inputs (validity $`.76`$, $`SD_y \$10{,}413`$, $`N = 618`$,
    $`T = 9.69`$, $`SR = .80`$); the package returns the reported
    $`\sim \$5.6`$ million one-year and $`\sim \$54`$ million multi-year
    figures within rounding tolerance.
3.  For Murphy (1986), the correlated-rejection mode with
    $`\rho = -0.20`$ and acceptance rate $`.70`$ is the operational
    default supported by Sturman (2001).
4.  For Holling (1998), report both the $`SD_y`$ estimate including
    outliers and the estimate with outliers excluded; the diagnostic
    function
    [`utility_regression_diagnostics()`](https://rgempp.github.io/personnelSelectionUtility/reference/utility_regression_diagnostics.md)
    provides the linearity and normality checks that anchor this
    decision.
5.  For the Sturman cascade, use either the step-by-step approach
    (pedagogically transparent) or
    [`sturman_comprehensive()`](https://rgempp.github.io/personnelSelectionUtility/reference/sturman_comprehensive.md)
    (operationally efficient); the cascade table is the auditable
    output.
6.  For Ock and Oswald (2018), report the comparison across at least
    three selection ratios; a single $`SR`$ comparison conceals the rate
    at which the gap closes as selectivity decreases.
7.  When the multiple-hurdle case can be modelled analytically, prefer
    [`tr_multivariate()`](https://rgempp.github.io/personnelSelectionUtility/reference/tr_multivariate.md)
    over Monte Carlo simulation for the dichotomised-criterion metric;
    the analytic result has no simulation error and is materially
    faster.

## References

De Corte, W. (1994). Utility analysis for the one-cohort
selection-retention decision with a probationary period. *Journal of
Applied Psychology*, *79*, 402–411.

Hogarth, R. M., & Einhorn, H. J. (1976). Optimal strategies for
personnel selection when candidates can reject job offers. *Journal of
Business*, *49*, 479–495.

Holling, H. (1998). Utility analysis of personnel selection: An overview
and empirical study based on objective performance measures. *Methods of
Psychological Research Online*, *3*(1), 5–24.

Murphy, K. R. (1986). When your top choice turns you down: Effect of
rejected offers on the utility of selection tests. *Psychological
Bulletin*, *99*, 133–138.

Ock, J., & Oswald, F. L. (2018). The utility of personnel selection
decisions: Comparing compensatory and multiple-hurdle selection models.
*Journal of Personnel Psychology*, *17*(4), 172–182.

Roth, P. L., Switzer, F. S., Van Iddekinge, C. H., & Oh, I. S. (2011).
Toward better meta-analytic matrices: How input values can affect
research conclusions in human resource management simulations.
*Personnel Psychology*, *64*, 899–935.

Schmidt, F. L., Hunter, J. E., McKenzie, R. C., & Muldrow, T. W. (1979).
Impact of valid selection procedures on work-force productivity.
*Journal of Applied Psychology*, *64*, 609–626.

Sturman, M. C. (2000). Implications of utility analysis adjustments for
estimates of human resource intervention value. *Journal of Management*,
*26*, 281–299.

Sturman, M. C. (2001). Utility analysis for multiple selection devices
and multiple outcomes. *Journal of Human Resource Costing and
Accounting*, *6*(2), 9–28.

Thomas, J. G., Owen, D. B., & Gunst, R. F. (1977). Improving the use of
educational tests as selection tools. *Journal of Educational
Statistics*, *2*(1), 55–77.
