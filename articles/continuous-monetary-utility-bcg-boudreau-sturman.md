# Continuous and monetary utility: Naylor-Shine, BCG, Boudreau, and Sturman

## From success ratios to continuous performance

Taylor-Russell utility dichotomises the criterion. Naylor and Shine
(1965) keep the criterion continuous and compute the expected criterion
gain in standard-deviation units. This is usually a better match when
performance is itself a continuous construct, which is the modal case in
industrial-organisational research on job-performance taxonomies (Borman
& Motowidlo, 1993; Campbell, 1990; Rotundo & Sackett, 2002).

``` r

library(personnelSelectionUtility)

naylor_shine(validity = .35, selection_ratio = .20)
#> <psu_ns>
#>   validity: 0.35
#>   selection_ratio: 0.2
#>   selected_mean_z: 1.39981
#>   expected_criterion_z: 0.489933
#>   sdy: 1
#>   n_selected: 1
#>   tenure: 1
#>   cost: 0
#>   gross_utility: 0.489933
#>   net_utility: 0.489933
```

The expected gain has two components. First,
[`selected_mean_z()`](https://rgempp.github.io/personnelSelectionUtility/reference/selected_mean_z.md)
returns the expected standardised predictor score among selected
applicants, which under the normal model is the inverse Mills ratio.
Second, this is multiplied by the validity coefficient to obtain the
expected standardised criterion gain:

``` math
\bar{Z}_{x_s} \;=\; \frac{\varphi(z_c)}{1 - \Phi(z_c)} \;=\; \frac{\lambda(SR)}{SR}, \qquad \bar{Z}_{y_s} \;=\; r_{xy} \cdot \bar{Z}_{x_s},
```

where $`z_c = \Phi^{-1}(1 - SR)`$ is the cutoff in standardised units
and $`\lambda(\cdot)`$ denotes the standard normal density.

``` r

selected_mean_z(.20)
#> [1] 1.39981
.35 * selected_mean_z(.20)
#> [1] 0.4899334
```

Naylor-Shine is the natural starting point when the analysis stops at
expected criterion gain in standard-deviation units. The transition to
monetary utility is governed by Brogden’s (1949) demonstration that,
under linearity and normality, the expected criterion gain in dollars
equals $`r_{xy} \cdot SD_y \cdot \bar{Z}_{x_s}`$.

## Brogden-Cronbach-Gleser monetary utility

Brogden (1946, 1949) and Cronbach and Gleser (1965) convert standardised
criterion gain into monetary utility by multiplying by $`SD_y`$, the
standard deviation of job performance value. The expected incremental
utility for $`N_s`$ applicants selected with validity $`r_{xy}`$ at
selection ratio $`SR`$ over a tenure horizon $`T`$, net of total cost
$`C`$, is

``` math
\Delta U \;=\; N_s \cdot T \cdot r_{xy} \cdot SD_y \cdot \bar{Z}_{x_s} \;-\; C.
```

When the comparator is an operating procedure with validity
$`r_{\text{baseline}}`$ rather than random selection, the focal validity
is replaced by the difference $`r_{xy} - r_{\text{baseline}}`$ (Sturman,
2000, 2001). Schmidt, Hunter, McKenzie, and Muldrow (1979) popularised
the organisational implications of this formulation in their analysis of
the Programmer Aptitude Test (PAT). Their estimates of
multi-million-dollar utility gains generated the modern utility-analysis
literature, and a stripped-down version of their calculation is the
canonical pedagogical example.

``` r

bcg_utility(
  validity = .35,
  selection_ratio = .20,
  sdy = 50000,
  n_selected = 100,
  tenure = 3,
  cost = 75000
)
#> <psu_bcg>
#>   validity: 0.35
#>   selection_ratio: 0.2
#>   baseline_validity: 0
#>   baseline_selection_ratio: 0.2
#>   selected_mean_z: 1.39981
#>   baseline_selected_mean_z: 1.39981
#>   focal_expected_criterion_z: 0.489933
#>   baseline_expected_criterion_z: 0
#>   incremental_criterion_z: 0.489933
#>   sdy: 50000
#>   n_selected: 100
#>   tenure: 3
#>   cost: 75000
#>   gross_utility: 7349000
#>   net_utility: 7274000
```

The Schmidt et al. (1979) PAT calculation uses different inputs (notably
$`SD_y`$ in 1979 dollars, a much larger cohort, and a longer tenure
horizon) and is reproduced in detail in the *Reproducing canonical
examples* vignette. The simplified call above illustrates the structure:
the gross utility is the product of $`N`$, $`T`$, $`r_{xy}`$, $`SD_y`$,
and the inverse-Mills selection-intensity term $`\bar{Z}_{x_s}`$, minus
total cost.

## The baseline problem

The classical Brogden-Cronbach-Gleser expression compares the focal
selection procedure against random selection. Sturman (2000, 2001)
argued forcefully that the realistic baseline is rarely random choice.
Almost every organisation already operates with some procedure:
reference checks (used by $`97\%`$ of organisations according to
Gatewood and Feild, 2001), unstructured interviews ($`81\%`$), or
biodata. The package implements this critique through the
`baseline_validity` and `baseline_selection_ratio` arguments. Setting
`baseline_validity` to the validity of the operating procedure shifts
the comparison from “test versus random” to “test versus current
system”, which is the operationally relevant difference.

``` r

random_baseline <- bcg_utility(
  validity = .35,
  selection_ratio = .20,
  sdy = 50000,
  n_selected = 100,
  tenure = 3,
  cost = 75000
)

operating_baseline <- bcg_utility(
  validity = .35,
  baseline_validity = .20,
  selection_ratio = .20,
  sdy = 50000,
  n_selected = 100,
  tenure = 3,
  cost = 75000
)

c(random   = random_baseline$net_utility,
  operating = operating_baseline$net_utility)
#>    random operating 
#>   7274000   3074572
```

The shift from random to operating baseline reduces the estimated
utility by approximately $`40\%`$ in this example, consistent with the
average reduction of $`59\%`$ that Sturman (2000) documented across the
published utility-analysis literature. The decision to adopt the new
procedure may be unchanged, since the incremental utility remains
positive, but the *expected return* communicated to organisational
decision-makers is materially different.

## Estimating $`SD_y`$: the four families

Because $`SD_y`$ enters the Brogden-Cronbach-Gleser expression linearly,
any error in its magnitude propagates one-for-one into the final
$`\Delta U`$ figure: doubling $`SD_y`$ exactly doubles the reported
utility, all else equal. As Holling (1998) documents empirically,
plausible alternative methods can yield $`SD_y`$ estimates that differ
by a factor of two or more (with the corresponding doubling of
$`\Delta U`$), so the choice of estimation method is not a technicality
but a substantive decision that should be justified and triangulated.

Holling (1998) classifies the methods for estimating $`SD_y`$ into four
families. The package implements representative members of each.

### Cost accounting

The cost-accounting approach assigns a monetary value to each unit of
measurable production, originating in Roche (1961, cited in Cronbach &
Gleser, 1965). It is conceptually the most defensible method when
production is genuinely measurable, but is operationally restricted to
jobs with quantifiable output.

``` r

# 5 employees, 2 output types (e.g., transactions completed and customer-service
# hours); unit_values gives the monetary value of one unit of each type.
sdy_cost_accounting(
  units = matrix(c(2400,  18,
                   3100,  22,
                   1800,  14,
                   2700,  25,
                   2200,  20),
                 ncol = 2, byrow = TRUE),
  unit_values = c(25, 80)
)
#> $y
#> [1] 61440 79260 46120 69500 56600
#> 
#> $sdy
#> [1] 12590.67
```

### Global percentile

Schmidt et al. (1979) proposed the percentile-judgement method: experts
estimate the dollar value of performance at the $`15`$th, $`50`$th, and
$`85`$th percentiles, and $`SD_y`$ is approximated as
$`(P_{85} - P_{15}) / 2`$ under the normal-model assumption. This method
has been the most widely applied historically but has been criticised
for between-judge dispersion, anchoring effects, and cognitive
difficulty (Bobko, Karren, & Parkington, 1983).

``` r

sdy_percentile(p15 = 60000, p85 = 140000)
#> [1] 40000
```

### Proportional rules

Schmidt, Hunter, and Pearlman (1982) proposed proportional rules tying
$`SD_y`$ to mean salary: approximately $`40\%`$ of mean pay for jobs of
low to medium complexity, and approximately $`70\%`$ for jobs of high
complexity or when output value is the relevant criterion. Raju, Burke,
and Normand (1990) reformulated the model in terms of the coefficient of
variation of performance ratings, which is implemented in
[`sdy_rbn()`](https://rgempp.github.io/personnelSelectionUtility/reference/sdy_rbn.md).

``` r

sdy_proportional(mean_pay = 80000, multiplier = .40)
#> [1] 32000
sdy_proportional(mean_pay = 80000, multiplier = .70)
#> [1] 56000
```

``` r

sdy_rbn(mean_pay = 80000, coefficient_variation = .20)
#> [1] 16000
```

### Individualised methods

CREPID (Cascio & Ramos, 1986) decomposes the job into weighted
activities and estimates the dollar value of each, summing across
activities to obtain $`SD_y`$. Variants appear in Janz and Dunnette
(1977), Edwards, Frederick, and Burke (1988), and the
superior-equivalents technique of Eaton, Wing, and Mitchell (1985) and
Burke and Frederick (1984, 1986).

``` r

# CREPID weights activities by time/frequency and importance, distributes the
# average salary across activities, and computes individual-level monetary value.
activities <- data.frame(
  activity        = c("Strategic planning", "Team supervision", "Reporting"),
  time_frequency  = c(.40, .35, .25),
  importance      = c(3, 2, 2)
)
ratings <- matrix(c(
  4, 3, 3,
  5, 4, 4,
  3, 4, 3,
  4, 5, 4,
  5, 5, 5
), nrow = 5, byrow = TRUE)
sdy_crepid(activities, ratings, salary = 80000)
#> $activity_weights
#>     activity time_frequency importance raw_weight final_weight dollar_value
#> 1 activity_1           0.40          3        1.2    0.5000000     40000.00
#> 2 activity_2           0.35          2        0.7    0.2916667     23333.33
#> 3 activity_3           0.25          2        0.5    0.2083333     16666.67
#> 
#> $y
#> [1] 280000.0 360000.0 263333.3 343333.3 400000.0
#> 
#> $sdy
#> [1] 56833.09

# Superior-equivalents: SDy = (superior - typical) / z_difference, with z_difference
# the standardised distance the analyst assumes separates the two anchors.
sdy_superior_equivalents(superior_value = 140000, typical_value = 100000)
#> [1] 40000
```

### Triangulation

The empirical comparisons of Bobko, Karren, and Parkington (1983),
Becker and Huselid (1992), and Hakstian, Wooley, Woolsey, and Kryger
(1991) indicate that CREPID and the $`40\%`$ rule converge to broadly
similar values, while the global percentile method tends to produce
values approximately $`1.8`$ times larger. Triangulation across at least
two methods is the practice supported by these comparisons, and the
analyst should report a sensitivity range rather than a single value.
Direct estimation from observed monetary criterion data, when available,
is the most defensible anchor.

``` r

sdy_observed(c(90000, 110000, 85000, 150000, 125000))
#> [1] 26598.87
```

## Schmidt-Hunter-Pearlman intervention utility

A common conceptual error is to apply Brogden-Cronbach-Gleser to
evaluation problems for which it is not designed. Schmidt, Hunter, and
Pearlman (1982) developed the parallel utility model for *interventions*
such as training programmes, where the appropriate effect size is
Cohen’s $`d`$ between treated and control groups rather than a validity
coefficient:

``` math
\Delta U_{SHP} \;=\; N \cdot T \cdot d \cdot SD_y \;-\; C, \qquad d \;=\; \frac{\bar{Y}_{\text{treated}} - \bar{Y}_{\text{control}}}{SD_{\text{pooled}}}.
```

The function
[`shp_utility()`](https://rgempp.github.io/personnelSelectionUtility/reference/shp_utility.md)
implements this formulation.

``` r

shp_utility(
  effect_size_d = .50,
  sdy           = 50000,
  n_treated     = 100,
  tenure        = 3,
  cost          = 25000
)
#> <psu_shp>
#>   effect_size_d: 0.5
#>   approximate_r: 0.242536
#>   sdy: 50000
#>   n_treated: 100
#>   tenure: 3
#>   cost: 25000
#>   gross_utility: 7500000
#>   net_utility: 7475000
```

The conversion between $`r`$ and $`d`$ under the equal-variance binormal
assumption is provided by
[`cor_to_d()`](https://rgempp.github.io/personnelSelectionUtility/reference/cor_to_d.md)
and
[`d_to_cor()`](https://rgempp.github.io/personnelSelectionUtility/reference/d_to_cor.md).
Mathieu and Leonard (1987) and Cascio (1989) document representative
applications to training programmes, while Burke and Day (1986) and
Morrow, Jarrett, and Rupinski (1997) provide cumulative meta-analytic
and longitudinal estimates respectively. The substantive point is that
selection utility ($`r`$-based) and intervention utility ($`d`$-based)
require different inputs and different study designs, even when the
outcome metric ($`\Delta U`$ in dollars) is identical.

## Boudreau-style extensions

Boudreau (1983, 1991) extended the basic monetary utility model along
several economically relevant dimensions: discounting future benefits to
net present value, separating fixed from variable costs, applying tax
rates, incorporating contribution margins, and modelling employee flows
over multiple periods. Per period, the discounted incremental utility is

``` math
\Delta U_t \;=\; \frac{N_t \cdot \Delta\bar{Z}_y \cdot SD_y \cdot (1 + V)(1 - TAX)}{(1 + i)^t} \;-\; C_t,
```

with $`N_t`$ the active headcount in period $`t`$, $`V`$ the
variable-value (or contribution-margin) multiplier, $`TAX`$ the tax
rate, $`i`$ the discount rate, and $`C_t`$ the period cost. Total
utility is the sum of $`\Delta U_t`$ over the horizon. The function
[`boudreau_utility()`](https://rgempp.github.io/personnelSelectionUtility/reference/boudreau_utility.md)
accepts these inputs through the arguments `n_by_period`,
`cost_by_period`, `contribution_margin`, `tax_rate`, and
`discount_rate`.

``` r

boudreau_utility(
  validity = .35,
  baseline_validity = .20,
  selection_ratio = .20,
  sdy = 50000,
  n_by_period = c(100, 90, 80, 70),
  contribution_margin = .30,
  tax_rate = .25,
  discount_rate = .08,
  cost_by_period = c(75000, 10000, 10000, 10000)
)
#> <psu_boudreau>
#>   delta_z_y: 0.209971
#>   sdy: 50000
#>   variable_value: 0
#>   contribution_margin: 0.3
#>   effective_margin: 0.3
#>   tax_rate: 0.25
#>   discount_rate: 0.08
#>   net_present_value: 579234
```

If the expected incremental standardised gain comes from an external
model, it can be passed directly through `delta_z_y`, bypassing the
internal computation from `validity`, `baseline_validity`, and
`selection_ratio`.

``` r

boudreau_utility(
  delta_z_y = .25,
  sdy = 50000,
  n_by_period = c(100, 90, 80),
  discount_rate = .08,
  cost_by_period = c(75000, 10000, 10000)
)
#> <psu_boudreau>
#>   delta_z_y: 0.25
#>   sdy: 50000
#>   variable_value: 0
#>   effective_margin: 1
#>   tax_rate: 0
#>   discount_rate: 0.08
#>   net_present_value: 2829790
```

When inflation is non-trivial, the discount rate should be adjusted
accordingly. Tziner, Meir, Dahan, and Birati (1994) show that the
inflation-adjusted rate is $`i_a = i + f + i \cdot f`$, where $`i`$ is
the nominal discount rate and $`f`$ is the inflation rate. The package
exposes this transformation as
[`inflation_adjusted_rate()`](https://rgempp.github.io/personnelSelectionUtility/reference/inflation_adjusted_rate.md).

``` r

inflation_adjusted_rate(discount_rate = .08, inflation_rate = .025)
#> [1] 0.107
```

The combined
[`boudreau_utility()`](https://rgempp.github.io/personnelSelectionUtility/reference/boudreau_utility.md)
framework is closer to the standard capital-budgeting practice of
corporate finance, but it inherits the well-documented difficulties that
Hunter, Schmidt, and Coggin (1988) identified from inside the
Schmidt-Hunter programme: discount-rate selection, period definition,
and the boundary between fixed and variable costs are all decisions that
materially affect the estimate and that admit no purely statistical
resolution.

## Composite formation

When multiple predictors are combined into a single composite score, the
validity, reliability, and intercorrelation of the composite follow from
the well-known formulae in Lord and Novick (1968). The package
implements these as the `fuse_*` family.

``` r

weights            <- c(.5, .3, .2)
item_validities    <- c(.40, .30, .25)
item_reliabilities <- c(.85, .80, .75)
item_cor <- matrix(c(
  1.00, .30, .20,
  .30, 1.00, .25,
  .20, .25, 1.00
), 3, 3, byrow = TRUE)

fuse_validity(weights, item_cor, item_validities)
#> [1] 0.4626814
fuse_reliability(weights, item_cor, item_reliabilities)
#> [1] 0.8787037

# fuse_composite_cor() returns the correlation matrix between several composites
# whose weights are stacked column-wise. The example below contrasts a unit-weighted
# composite with a validity-weighted composite of the same items.
W <- cbind(unit = c(1, 1, 1), validity_weighted = item_validities)
fuse_composite_cor(weights_matrix = W, item_cor = item_cor)
#>                        unit validity_weighted
#> unit              1.0000000         0.9900312
#> validity_weighted 0.9900312         1.0000000
```

The composite validity is generally smaller than the largest
single-predictor validity unless the predictors carry independent
variance with respect to the criterion, which connects directly to the
incremental-validity reasoning developed below. Disattenuation of the
observed correlation for measurement error in the criterion is provided
by
[`disattenuate_correlation()`](https://rgempp.github.io/personnelSelectionUtility/reference/disattenuate_correlation.md).

``` r

disattenuate_correlation(r_observed = .35, reliability_x = .85, reliability_y = .70)
#> [1] 0.4537426
```

Disattenuation moves the analysis from the observed-score metric to the
true-score metric, which is the appropriate input for population-level
utility statements but should be reported alongside the observed-score
estimate (Schmidt & Hunter, 2015).

## Range-restriction corrections

A second standard correction is for range restriction. Sackett, Laczo,
and Arvey (2002) and Sackett, Lievens, Berry, and Landers (2007)
distinguish *direct* range restriction, which operates on the predictor
that was used as the selection variable, from *incidental* range
restriction, which operates on variables correlated with the selected
variable. The Thorndike Case II correction handles direct restriction;
the Lawley (1943) multivariate correction handles incidental restriction
in correlated predictors.

``` r

correct_r_direct_range_restriction(
  r_restricted            = .25,
  range_restriction_ratio = 1.40
)
#> [1] 0.3399501
```

The Lawley multivariate correction is more general and covers the case
in which selection occurs on a composite or on a different variable than
the one being corrected.

``` r

# Three-variable example: selection on X1 (cognitive ability, the predictor used as
# the selection variable); incidental restriction on X2 (interview) and Y (criterion).
sigma_star <- matrix(c(
  1.00, .30, .25,
  .30, 1.00, .20,
  .25, .20, 1.00
), 3, 3)
# Unrestricted SD of X1 is 1/.6 times the restricted SD; variance increases by 1/.6^2.
sigma_ss_unrestricted <- matrix(1 / 0.6^2, 1, 1)
correct_r_lawley(
  sigma_restricted      = sigma_star,
  selection_indices     = 1,
  sigma_ss_unrestricted = sigma_ss_unrestricted
)
#> $sigma_corrected
#>           [,1]      [,2]      [,3]
#> [1,] 1.0000000 0.4642383 0.3952847
#> [2,] 0.4642383 1.0000000 0.2936101
#> [3,] 0.3952847 0.2936101 1.0000000
#> 
#> $sigma_restricted
#>      [,1] [,2] [,3]
#> [1,] 1.00  0.3 0.25
#> [2,] 0.30  1.0 0.20
#> [3,] 0.25  0.2 1.00
#> 
#> $selection_indices
#> [1] 1
#> 
#> $incidental_indices
#> [1] 2 3
#> 
#> $u
#> [1] 0.6
#> 
#> $sign_changes
#> [1] 0
```

Ree, Carretta, Earles, and Albert (1994) document that multivariate
range-restriction corrections can occasionally produce sign changes when
the unrestricted covariance structure is poorly estimated, which is a
strong argument for reporting both corrected and uncorrected values and
for inspecting the implied unrestricted matrix for plausibility.

## Incremental validity and predictor importance

When a battery already exists and a candidate predictor is being
considered for addition, the relevant quantity is not the marginal
correlation of the new predictor with the criterion but the *incremental
validity* of the augmented battery over the existing one. Sturman (2001)
developed the matrix formulation of this problem as a *restricted
canonical correlation*, in which the predictor-side weights are
optimised given a fixed criterion-side composite weighting. With
predictor correlation matrix $`\boldsymbol{\Sigma}_{11}`$,
predictor-criterion correlation matrix $`\boldsymbol{\Sigma}_{12}`$,
criterion correlation matrix $`\boldsymbol{\Sigma}_{22}`$, fixed
criterion weights $`\mathbf{b}`$, and predictor weights $`\mathbf{a}`$
to be determined,

``` math
r_{uv} \;=\; \frac{\mathbf{a}^{\top} \boldsymbol{\Sigma}_{12} \mathbf{b}}{\sqrt{\mathbf{a}^{\top} \boldsymbol{\Sigma}_{11} \mathbf{a}} \cdot \sqrt{\mathbf{b}^{\top} \boldsymbol{\Sigma}_{22} \mathbf{b}}},
```

with the optimal predictor-side weights given by
$`\mathbf{a} \propto \boldsymbol{\Sigma}_{11}^{-1} \boldsymbol{\Sigma}_{12} \mathbf{b}`$.

``` r

S11 <- matrix(c(1, .30, .30, 1), 2, 2)
S12 <- matrix(c(.30, .20, .25, .15), 2, 2)
S22 <- matrix(c(1, .40, .40, 1), 2, 2)

restricted_canonical_validity(S11, S12, S22, criterion_weights = c(.6, .4))
#> <psu_incremental_validity>
#>   validity: 0.352614
```

The function
[`incremental_validity()`](https://rgempp.github.io/personnelSelectionUtility/reference/incremental_validity.md)
evaluates the gain from adding new predictors to an existing baseline.

``` r

Rxx <- matrix(c(1, .30, .20,
                .30, 1, .25,
                .20, .25, 1), 3, 3, byrow = TRUE)
Rxy <- matrix(c(.30, .20,
                .25, .15,
                .10, .35), 3, 2, byrow = TRUE)
Ryy <- matrix(c(1, .40, .40, 1), 2, 2)

incremental_validity(
  predictor_cor = Rxx,
  predictor_criterion_cor = Rxy,
  criterion_cor = Ryy,
  criterion_weights = c(.6, .4),
  baseline_predictors = 1:2,
  added_predictors = 3
)
#> <psu_incremental_validity>
#>   baseline_validity: 0.34905
#>   expanded_validity: 0.379438
#>   incremental_validity: 0.0303873
#>   added_predictors: 3
```

Two contemporary methods for quantifying the relative importance of
predictors complement this matrix formulation. Johnson’s (2000)
relative-weights method decomposes the model $`R^2`$ into approximately
uncorrelated contributions, and Budescu’s (1993) dominance analysis
evaluates each predictor across all subsets of the other predictors.

``` r

# For predictor-importance methods, the criterion side collapses to a single
# criterion (e.g., overall job performance):
rxy_single <- c(.30, .25, .35)
relative_weights(predictor_cor = Rxx, criterion_cor = rxy_single)
#>   predictor raw_weight rescaled_weight percent_of_r2
#> 1         1 0.06156283      0.06156283      32.45758
#> 2         2 0.03381629      0.03381629      17.82886
#> 3         3 0.09429252      0.09429252      49.71356
dominance_analysis(predictor_cor = Rxx, predictor_criterion_cor = rxy_single)
#> <psu_dominance>
#>   r_squared_full: 0.189672
```

The substantive lesson, formalised by Sturman (2001), is that a
predictor with high marginal correlation can have negligible or even
negative incremental validity if it is highly redundant with predictors
already in the battery, and conversely a predictor with low marginal
correlation can have high incremental validity through suppression
effects. Reporting both relative weights and dominance results,
alongside the matrix-restricted canonical validity, provides a
multi-method check on the importance of any candidate predictor.

## The integrated Sturman comprehensive model

Sturman (2001) integrates several of the corrections developed above
into a single comprehensive utility model: incremental validity over the
operating baseline, multidimensional criterion through restricted
canonical reweighting, multi-period employee flows, taxes and
discounting, probationary survival, and offer rejection. The function
[`sturman_comprehensive()`](https://rgempp.github.io/personnelSelectionUtility/reference/sturman_comprehensive.md)
composes these adjustments and returns both the integrated estimate and
the cumulative cascade.

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
  acceptance_rate                = .70,
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

The cumulative cascade is available in `s$cascade`, the effective
validity actually used for the calculations after restricted canonical
reweighting in `s$effective_validity`, and the active headcount per
period after employee flows in `s$n_active_by_period`. The applied
reproduction of Sturman’s (2001) cascade, including the published
shrinkage to approximately $`8\%`$ of the naive Brogden-Cronbach-Gleser
estimate, is developed in the *Reproducing canonical examples* vignette.

## How to proceed in applied work

1.  Start with
    [`naylor_shine()`](https://rgempp.github.io/personnelSelectionUtility/reference/naylor_shine.md)
    if the analysis stops at expected criterion gain in
    standard-deviation units; do not introduce $`SD_y`$ unless the
    decision genuinely requires monetary translation.
2.  Use
    [`bcg_utility()`](https://rgempp.github.io/personnelSelectionUtility/reference/bcg_utility.md)
    for transparent monetary utility, but treat it as a starting point
    and not as an endpoint.
3.  Replace random selection with the actual operating baseline whenever
    it is identifiable; report the random-baseline result as an upper
    bound only.
4.  Estimate $`SD_y`$ using at least two methods and report a
    sensitivity range; a single point estimate of $`SD_y`$ understates
    the uncertainty in the final utility figure (Holling, 1998).
5.  Use
    [`boudreau_utility()`](https://rgempp.github.io/personnelSelectionUtility/reference/boudreau_utility.md)
    when the analysis spans several periods, when costs and returns
    occur at different times, or when taxes and contribution margins are
    non-negligible.
6.  Distinguish selection utility ($`r`$-based,
    [`bcg_utility()`](https://rgempp.github.io/personnelSelectionUtility/reference/bcg_utility.md))
    from intervention utility ($`d`$-based,
    [`shp_utility()`](https://rgempp.github.io/personnelSelectionUtility/reference/shp_utility.md));
    they are calibrated for different study designs.
7.  Disattenuate validities with
    [`disattenuate_correlation()`](https://rgempp.github.io/personnelSelectionUtility/reference/disattenuate_correlation.md)
    and correct for range restriction with
    [`correct_r_lawley()`](https://rgempp.github.io/personnelSelectionUtility/reference/correct_r_lawley.md)
    or
    [`correct_r_direct_range_restriction()`](https://rgempp.github.io/personnelSelectionUtility/reference/correct_r_direct_range_restriction.md)
    *before* utility calculation; report both corrected and uncorrected
    values.
8.  When the battery has multiple predictors, use
    [`restricted_canonical_validity()`](https://rgempp.github.io/personnelSelectionUtility/reference/restricted_canonical_validity.md)
    and
    [`incremental_validity()`](https://rgempp.github.io/personnelSelectionUtility/reference/incremental_validity.md),
    complemented by
    [`relative_weights()`](https://rgempp.github.io/personnelSelectionUtility/reference/relative_weights.md)
    and
    [`dominance_analysis()`](https://rgempp.github.io/personnelSelectionUtility/reference/dominance_analysis.md)
    for predictor-importance triangulation.
9.  Use
    [`sturman_comprehensive()`](https://rgempp.github.io/personnelSelectionUtility/reference/sturman_comprehensive.md)
    as the integrated reporting standard for continuous-monetary,
    compensatory-selection problems; the cascade output makes the
    contribution of each adjustment auditable.
10. Report inputs in full; utility estimates are only as credible as the
    validity, $`SD_y`$, cost, baseline, tenure, and discount-rate
    assumptions on which they rest.

## References

Becker, B. E., & Huselid, M. A. (1992). Direct estimates of $`SD_y`$ and
the implications for utility analysis. *Journal of Applied Psychology*,
*77*, 227–233.

Bobko, P., Karren, R., & Parkington, J. J. (1983). Estimation of
standard deviations in utility analyses: An empirical test. *Journal of
Applied Psychology*, *68*, 170–176.

Borman, W. C., & Motowidlo, S. J. (1993). Expanding the criterion domain
to include elements of contextual performance. In N. Schmitt, W. C.
Borman, & Associates (Eds.), *Personnel selection in organizations*
(pp. 71–98). Jossey-Bass.

Boudreau, J. W. (1983). Economic considerations in estimating the
utility of human resource productivity improvement programs. *Personnel
Psychology*, *36*, 551–576.

Boudreau, J. W. (1991). Utility analysis for decisions in human resource
management. In M. D. Dunnette & L. M. Hough (Eds.), *Handbook of
industrial and organizational psychology* (Vol. 2, pp. 621–745).
Consulting Psychologists Press.

Brogden, H. E. (1946). On the interpretation of the correlation
coefficient as a measure of predictive efficiency. *Journal of
Educational Psychology*, *37*, 65–76.

Brogden, H. E. (1949). When testing pays off. *Personnel Psychology*,
*2*, 171–183.

Budescu, D. V. (1993). Dominance analysis: A new approach to the problem
of relative importance of predictors in multiple regression.
*Psychological Bulletin*, *114*, 542–551.

Burke, M. J., & Day, R. R. (1986). A cumulative study of the
effectiveness of managerial training. *Journal of Applied Psychology*,
*71*, 232–245.

Burke, M. J., & Frederick, J. T. (1984). Two modified procedures for
estimating standard deviations in utility analyses. *Journal of Applied
Psychology*, *69*, 482–489.

Burke, M. J., & Frederick, J. T. (1986). A comparison of economic
utility estimates for alternative $`SD_y`$ estimation procedures.
*Journal of Applied Psychology*, *71*, 334–339.

Campbell, J. P. (1990). Modeling the performance prediction problem in
industrial and organizational psychology. In M. D. Dunnette & L. M.
Hough (Eds.), *Handbook of industrial and organizational psychology*
(Vol. 1, pp. 687–732). Consulting Psychologists Press.

Cascio, W. F. (1989). Using utility analysis to assess training
outcomes. In I. L. Goldstein (Ed.), *Training and development in
organizations* (pp. 63–88). Jossey-Bass.

Cascio, W. F., & Ramos, R. A. (1986). Development and application of a
new method for assessing job performance in behavioral/economic terms.
*Journal of Applied Psychology*, *71*, 20–28.

Cronbach, L. J., & Gleser, G. C. (1965). *Psychological tests and
personnel decisions* (2nd ed.). University of Illinois Press.

Eaton, N. K., Wing, H., & Mitchell, K. J. (1985). Alternate methods of
estimating the dollar value of performance. *Personnel Psychology*,
*38*, 27–40.

Edwards, J. E., Frederick, J. T., & Burke, M. J. (1988). Efficacy of
modified CREPID $`SD_y`$s on the basis of archival organizational data.
*Journal of Applied Psychology*, *73*, 529–535.

Gatewood, R. D., & Feild, H. S. (2001). *Human resource selection* (5th
ed.). Dryden Press.

Hakstian, A. R., Wooley, R. M., Woolsey, L. K., & Kryger, B. R. (1991).
Management selection by multiple-domain assessment: II. Utility to the
organisation. *Educational and Psychological Measurement*, *51*,
899–911.

Holling, H. (1998). Utility analysis of personnel selection: An overview
and empirical study based on objective performance measures. *Methods of
Psychological Research Online*, *3*(1), 5–24.

Hunter, J. E., Schmidt, F. L., & Coggin, T. D. (1988). Problems and
pitfalls in using capital budgeting and financial accounting techniques
in assessing the utility of personnel programs. *Journal of Applied
Psychology*, *73*, 522–528.

Janz, T., & Dunnette, M. D. (1977). Development and application of a
method for examining managerial work performance through analyses of
resource allocations and contingent outcomes. *Personnel Psychology*,
*30*, 519–544.

Johnson, J. W. (2000). A heuristic method for estimating the relative
weight of predictor variables in multiple regression. *Multivariate
Behavioral Research*, *35*, 1–19.

Lawley, D. N. (1943). A note on Karl Pearson’s selection formulae.
*Proceedings of the Royal Society of Edinburgh, Section A*, *62*, 28–30.

Lord, F. M., & Novick, M. R. (1968). *Statistical theories of mental
test scores*. Addison-Wesley.

Mathieu, J. E., & Leonard, R. L. (1987). Applying utility concepts to a
training program in supervisory skills: A time-based approach. *Academy
of Management Journal*, *30*, 316–335.

Morrow, C. C., Jarrett, M. Q., & Rupinski, M. T. (1997). An
investigation of the effect and economic utility of corporate-wide
training. *Personnel Psychology*, *50*, 91–119.

Naylor, J. C., & Shine, L. C. (1965). A table for determining the
increase in mean criterion score obtained by using a selection device.
*Journal of Industrial Psychology*, *3*, 33–42.

Raju, N. S., Burke, M. J., & Normand, J. (1990). A new approach for
utility analysis. *Journal of Applied Psychology*, *75*, 3–12.

Ree, M. J., Carretta, T. R., Earles, J. A., & Albert, W. (1994). Sign
changes when correcting for range restriction: A note on Pearson’s and
Lawley’s selection formulas. *Journal of Applied Psychology*, *79*,
298–301.

Rotundo, M., & Sackett, P. R. (2002). The relative importance of task,
citizenship, and counterproductive performance to global ratings of job
performance: A policy-capturing approach. *Journal of Applied
Psychology*, *87*, 66–80.

Sackett, P. R., Laczo, R. M., & Arvey, R. D. (2002). The effects of
range restriction on estimates of criterion interrater reliability:
Implications for validation research. *Personnel Psychology*, *55*,
807–825.

Sackett, P. R., Lievens, F., Berry, C. M., & Landers, R. N. (2007). A
cautionary note on the effects of range restriction on predictor
intercorrelations. *Journal of Applied Psychology*, *92*, 538–544.

Schmidt, F. L., & Hunter, J. E. (2015). *Methods of meta-analysis:
Correcting error and bias in research findings* (3rd ed.). Sage.

Schmidt, F. L., Hunter, J. E., McKenzie, R. C., & Muldrow, T. W. (1979).
Impact of valid selection procedures on work-force productivity.
*Journal of Applied Psychology*, *64*, 609–626.

Schmidt, F. L., Hunter, J. E., & Pearlman, K. (1982). Assessing the
economic impact of personnel programs on workforce productivity.
*Personnel Psychology*, *35*, 333–347.

Sturman, M. C. (2000). Implications of utility analysis adjustments for
estimates of human resource intervention value. *Journal of Management*,
*26*, 281–299.

Sturman, M. C. (2001). Utility analysis for multiple selection devices
and multiple outcomes. *Journal of Human Resource Costing and
Accounting*, *6*(2), 9–28.

Tziner, A., Meir, E. I., Dahan, M., & Birati, A. (1994). An
investigation of the predictive validity and economic utility of the
assessment center for the high-management level. *Canadian Journal of
Behavioural Science*, *26*, 228–245.
