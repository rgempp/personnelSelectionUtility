# Taylor-Russell and the Thomas-Owen-Gunst multivariate extension

## The classificatory problem

Taylor and Russell (1939) ask a classificatory question: **what
proportion of selected applicants will be successful, given a base rate,
a selection ratio, and a validity coefficient?** In modern diagnostic
language, the central quantity is a positive predictive value (PPV):
$`P(\text{success} \mid \text{selected})`$. Under bivariate normality of
predictor $`X`$ and criterion $`Y`$ at correlation $`\rho = r_{xy}`$,
with cutoffs $`x_c`$ on the predictor and $`y_c`$ on the dichotomised
criterion, the PPV has the closed form

``` math
PPV \;=\; \frac{P(X \geq x_c,\, Y \geq y_c)}{P(X \geq x_c)} \;=\; \frac{\displaystyle\int_{x_c}^{\infty}\!\!\int_{y_c}^{\infty} \phi_2(x, y;\, \rho)\, dy\, dx}{\displaystyle\int_{x_c}^{\infty} \phi_1(x)\, dx},
```

where $`\phi_2`$ and $`\phi_1`$ are the standard bivariate and
univariate normal densities. The Taylor and Russell (1939) utility
metric is the increment of $`PPV`$ over the population base rate
$`\phi`$, i.e. $`\Delta P_S = PPV - \phi`$. Cascio (1980) showed that
the Taylor-Russell model is a special case of the
Brogden-Cronbach-Gleser framework when the criterion is dichotomised at
a fixed cutoff, but the success-ratio metric remains uniquely
interpretable when the practical decision is binary (e.g., probationary
pass/fail, certification, retention beyond a fixed horizon).

``` r

library(personnelSelectionUtility)

tr_classic(base_rate = .50, selection_ratio = .20, validity = .35)
#> <psu_tr>
#>   base_rate: 0.5
#>   selection_ratio: 0.2
#>   validity: 0.35
#>   predictor_cutoff_z: 0.841621
#>   criterion_cutoff_z: 0
#>   true_positive: 0.13931
#>   false_positive: 0.0606895
#>   false_negative: 0.36069
#>   true_negative: 0.43931
#>   ppv: 0.696552
#>   success_ratio: 0.696552
#>   incremental_success: 0.196552
#>   sensitivity: 0.278621
#>   specificity: 0.878621
#>   digits: 3
```

The output includes the four cells of the $`2 \times 2`$ classification
table, the success ratio among selected applicants (`ppv`), and the
increment over the base rate. Sensitivity and specificity are reported
as additional diagnostic indices. The increment
$`\Delta P_S = PPV - BR`$ is the original Taylor and Russell (1939)
utility metric.

## Solving unknown Taylor-Russell inputs

The original tables in Taylor and Russell (1939) are forward-looking:
given the base rate, selection ratio, and validity, they return the
success ratio. In practice, the analyst frequently asks the inverse
question: **what validity is required to achieve a target PPV?** The
function
[`tr_solve()`](https://rgempp.github.io/personnelSelectionUtility/reference/tr_solve.md)
follows this logic and is intentionally similar to the flexible solver
implemented in Waller’s (2024) `TaylorRussell` package.

``` r

tr_solve(base_rate = .50, selection_ratio = .20, validity = NULL, ppv = .70)
#> <psu_tr>
#>   base_rate: 0.5
#>   selection_ratio: 0.2
#>   validity: 0.356075
#>   predictor_cutoff_z: 0.841621
#>   criterion_cutoff_z: 0
#>   true_positive: 0.14
#>   false_positive: 0.06
#>   false_negative: 0.36
#>   true_negative: 0.44
#>   ppv: 0.7
#>   success_ratio: 0.7
#>   incremental_success: 0.2
#>   sensitivity: 0.28
#>   specificity: 0.88
#>   digits: 3
#>   target_ppv: 0.7
```

The same function solves for the selection ratio implied by a desired
PPV and a known validity, which is the operationally relevant inversion
when the validity is fixed by the available battery and the analyst
chooses the cutoff.

``` r

tr_solve(base_rate = .50, selection_ratio = NULL, validity = .35, ppv = .70)
#> <psu_tr>
#>   base_rate: 0.5
#>   selection_ratio: 0.190709
#>   validity: 0.35
#>   predictor_cutoff_z: 0.875286
#>   criterion_cutoff_z: 0
#>   true_positive: 0.133496
#>   false_positive: 0.0572127
#>   false_negative: 0.366504
#>   true_negative: 0.442787
#>   ppv: 0.7
#>   success_ratio: 0.7
#>   incremental_success: 0.2
#>   sensitivity: 0.266993
#>   specificity: 0.885575
#>   digits: 3
#>   target_ppv: 0.7
```

These inversions are useful for sensitivity reasoning: rather than
asking “what PPV will my $`r = .35`$ test deliver”, the analyst can ask
“what validity floor would I need to achieve the PPV target the
organisation cares about”, which connects directly to the break-even
logic of Cronshaw, Alexander, Wiesner, and Barrick (1987).

## Why the univariate model is not enough

The univariate Taylor-Russell model handles a single predictor or a
composite that has already been collapsed into one score. Many real
systems do not operate as a single composite. Applicants may need to
pass multiple independent cutoffs: for instance, a minimum cognitive
score *and* a minimum interview score *and* a minimum integrity score.
Forcing such a multiple-hurdle conjunctive design into a univariate
model loses two structurally important features: the *joint* selection
ratio (which is materially smaller than the product of marginals when
predictors are positively correlated) and the differential restriction
of range that each predictor experiences (Sackett, Lievens, Berry, &
Landers, 2007).

Thomas, Owen, and Gunst (1977) generalised the Taylor-Russell logic to
multiple cutoffs. Their derivation shows that the multiple-cutoff
problem is, in principle, a natural extension of the single-test case;
the obstacle was historically computational, since the integrals require
multivariate normal probabilities that were tractable only for
$`k \leq 3`$ predictors using the tables of Owen (1956, 1962). For $`k`$
predictors with marginal cutoffs $`\mathbf{c} = (c_1, \ldots, c_k)`$ and
a dichotomised criterion with cutoff $`y_0`$, the joint conjunctive
selection ratio and the joint true-positive rate are

``` math
SR_{\text{conj}} \;=\; \int_{c_1}^{\infty}\!\!\!\cdots\!\int_{c_k}^{\infty} \phi_k(\mathbf{x};\, \mathbf{R}_{XX})\, d\mathbf{x},
```

``` math
TP \;=\; \int_{c_1}^{\infty}\!\!\!\cdots\!\int_{c_k}^{\infty}\!\int_{y_0}^{\infty} \phi_{k+1}(\mathbf{x},\, y;\, \mathbf{R})\, dy\, d\mathbf{x},
```

with $`\mathbf{R}`$ the full $`(k+1) \times (k+1)`$ correlation matrix
containing predictor intercorrelations and predictor-criterion
validities. The multivariate positive predictive value follows as
$`PPV = TP / SR_{\text{conj}}`$. Modern implementations rely on
numerical integration of the multivariate normal density via the
Genz-Bretz quasi-Monte Carlo algorithm (Genz, 1992; Genz & Bretz, 2009),
which the package accesses through
[`mvtnorm::pmvnorm()`](https://rdrr.io/pkg/mvtnorm/man/pmvnorm.html).
The implementation in this package closely parallels Waller’s (2024)
[`TaylorRussell::TaylorRussell()`](https://rdrr.io/pkg/TaylorRussell/man/TaylorRussell.html),
which provided the first widely available rehabilitation of the
Thomas-Owen-Gunst integral after several decades of computational
neglect (Ren & Waller, 2024).

## Multivariate Taylor-Russell with specified marginal cutoffs

The matrix `R` must include the predictors first and the criterion last.
The following example has two predictors and one dichotomised criterion.

``` r

R <- matrix(c(
  1.00, .30, .40,
  .30, 1.00, .35,
  .40, .35, 1.00
), nrow = 3, byrow = TRUE)

tr_multivariate(selection_ratios = c(.50, .50), base_rate = .50, R = R)
#> <psu_tr>
#>   base_rate: 0.5
#>   joint_selection_ratio: 0.298451
#>   criterion_cutoff_z: 0
#>   true_positive: 0.210393
#>   false_positive: 0.0880588
#>   false_negative: 0.289607
#>   true_negative: 0.411941
#>   ppv: 0.704948
#>   success_ratio: 0.704948
#>   incremental_success: 0.204948
#>   sensitivity: 0.420785
#>   specificity: 0.823882
#>   digits: 3
```

The output reports both the marginal selection ratios supplied by the
user and the implied `joint_selection_ratio`. These are not the same. If
each predictor has a marginal selection ratio of $`.50`$, the joint
selected proportion is materially smaller than $`.50`$ because
applicants must pass both cutoffs. The exact reduction depends on the
predictor intercorrelation: independent predictors yield a joint rate
near the product of marginals, while strongly correlated predictors
yield a joint rate closer to the smaller marginal.

## Equal-cutoff tables and target joint selection ratio

The historical Thomas-Owen-Gunst tables are indexed by the **joint**
proportion selected under equal cutoffs, not by the marginal cutoffs.
The function
[`tr_multivariate_equal_cutoff()`](https://rgempp.github.io/personnelSelectionUtility/reference/tr_multivariate_equal_cutoff.md)
solves for the common marginal cutoff that yields a desired joint
conjunctive probability.

``` r

R_tog <- matrix(c(
  1.00, .50, .70,
  .50, 1.00, .70,
  .70, .70, 1.00
), nrow = 3, byrow = TRUE)

tog <- tr_multivariate_equal_cutoff(
  joint_selection_ratio = .20,
  base_rate = .60,
  R = R_tog
)

tog
#> <psu_tr>
#>   base_rate: 0.6
#>   joint_selection_ratio: 0.2
#>   criterion_cutoff_z: -0.253347
#>   true_positive: 0.194465
#>   false_positive: 0.00553487
#>   false_negative: 0.405535
#>   true_negative: 0.394465
#>   ppv: 0.972326
#>   success_ratio: 0.972326
#>   incremental_success: 0.372326
#>   sensitivity: 0.324109
#>   specificity: 0.986163
#>   digits: 3
#>   target_joint_selection_ratio: 0.2
#>   computed_joint_selection_ratio: 0.200042
#>   solved_marginal_selection_ratio: 0.354321
#>   joint_selection_error: 4.18379e-05
```

The same function exposes the solved marginal selection ratio.

``` r

c(
  marginal_selection_ratio = tog$solved_marginal_selection_ratio,
  joint_selection_ratio    = tog$joint_selection_ratio,
  ppv                      = tog$ppv
)
#> marginal_selection_ratio    joint_selection_ratio                      ppv 
#>                0.3543206                0.2000000                0.9723257
```

This is the canonical Thomas-Owen-Gunst (1977) example: when the
population base rate is $`.60`$, the predictor intercorrelation is
$`.50`$, and both predictor-criterion validities are $`.70`$, selecting
the joint top $`20\%`$ through equal cutoffs yields a success ratio
close to $`.97`$ and a marginal pass rate near $`.35`$ on each test. The
substantive lesson is that conjunctive selection can produce very high
success ratios, but at the cost of a small selection ratio per predictor
that may be operationally infeasible if the applicant pool is limited or
if early stages cannot screen out enough candidates.

## Group-specific multivariate Taylor-Russell

When base rates or predictor-criterion correlations differ across
demographic groups, applying a single matrix `R` to the whole population
conceals systematic differential prediction. The function
[`group_tr_multivariate()`](https://rgempp.github.io/personnelSelectionUtility/reference/group_tr_multivariate.md)
evaluates the model separately by group, which is the natural primitive
for adverse-impact reasoning under conjunctive selection. The package
also provides
[`adverse_impact_ratio()`](https://rgempp.github.io/personnelSelectionUtility/reference/adverse_impact_ratio.md)
for the four-fifths comparison and
[`utility_fairness_frontier()`](https://rgempp.github.io/personnelSelectionUtility/reference/utility_fairness_frontier.md)
for the joint utility-fairness Pareto frontier discussed by De Corte,
Lievens, and Sackett (2007).

``` r

# Group-specific evaluation: same predictor structure but different base rates
# across two demographic groups (e.g., focal and reference). The marginal
# selection ratios are common; the base rates and, optionally, the correlation
# matrices may differ.
group_tr_multivariate(
  selection_ratios = c(.35, .35),
  base_rates       = c(.60, .45),
  R_list           = list(R_tog, R_tog),
  group_names      = c("Group A", "Group B")
)
#> $groups
#> $groups$`Group A`
#> <psu_tr>
#>   base_rate: 0.6
#>   joint_selection_ratio: 0.196445
#>   criterion_cutoff_z: -0.253347
#>   true_positive: 0.191138
#>   false_positive: 0.00530688
#>   false_negative: 0.408862
#>   true_negative: 0.394693
#>   ppv: 0.972985
#>   success_ratio: 0.972985
#>   incremental_success: 0.372985
#>   sensitivity: 0.318564
#>   specificity: 0.986733
#>   digits: 3
#> 
#> $groups$`Group B`
#> <psu_tr>
#>   base_rate: 0.45
#>   joint_selection_ratio: 0.196439
#>   criterion_cutoff_z: 0.125661
#>   true_positive: 0.179263
#>   false_positive: 0.0171765
#>   false_negative: 0.270737
#>   true_negative: 0.532824
#>   ppv: 0.912561
#>   success_ratio: 0.912561
#>   incremental_success: 0.462561
#>   sensitivity: 0.398362
#>   specificity: 0.96877
#>   digits: 3
#> 
#> 
#> $summary
#>           group base_rate joint_selection_ratio       ppv sensitivity
#> Group A Group A      0.60             0.1964450 0.9729854   0.3185635
#> Group B Group B      0.45             0.1964395 0.9125610   0.3983622
#>         specificity
#> Group A   0.9867328
#> Group B   0.9687701
#> 
#> $overall
#> NULL
```

The substantive value of this disaggregation is that the same marginal
cutoffs can produce very different group-specific success ratios when
base rates differ, even when the predictor-criterion correlations are
identical across groups. This is one of the mechanisms behind the
validity-diversity dilemma analysed by Pyburn, Ployhart, and Kravitz
(2008) and is the diagnostic input for Pareto-optimal selection systems
(De Corte, Lievens, & Sackett, 2007; De Corte, Sackett, & Lievens,
2011).

## Finite sampling

The Thomas-Owen-Gunst (1977) framework returns expected proportions in
the population. In a finite cohort of selected applicants, the realised
count of successes is a binomial random variable with parameter equal to
the PPV. The function
[`tr_binomial_success_probability()`](https://rgempp.github.io/personnelSelectionUtility/reference/tr_binomial_success_probability.md)
returns this distribution.

``` r

finite <- tr_binomial_success_probability(n_selected = 20, ppv = .91, at_least = 18)
finite
#>    successes  probability
#> 1          0 1.215767e-21
#> 2          1 2.458550e-19
#> 3          2 2.361574e-17
#> 4          3 1.432688e-15
#> 5          4 6.156580e-14
#> 6          5 1.991996e-12
#> 7          6 5.035322e-11
#> 8          7 1.018254e-09
#> 9          8 1.673048e-08
#> 10         9 2.255516e-07
#> 11        10 2.508636e-06
#> 12        11 2.305918e-05
#> 13        12 1.748654e-04
#> 14        13 1.088051e-03
#> 15        14 5.500705e-03
#> 16        15 2.224729e-02
#> 17        16 7.029527e-02
#> 18        17 1.672384e-01
#> 19        18 2.818277e-01
#> 20        19 2.999570e-01
#> 21        20 1.516449e-01
attr(finite, "probability_at_least")
#> [1] 0.7334296
```

Reporting this finite-sample probability is particularly relevant for
small selection cohorts, where the difference between an expected
success ratio of $`.91`$ and a $`90\%`$ probability of at least $`18`$
out of $`20`$ successes can be operationally meaningful. The same logic
underlies the recommendation, in Cronshaw et al. (1987), to combine
point utility estimates with risk-simulation summaries.

## Reproducing Thomas-Owen-Gunst (1977), Table 6

The package reproduces, digit-for-digit at the precision allowed by the
Genz-Bretz integration tolerance, the canonical example from Thomas,
Owen, and Gunst (1977). Two predictors correlate $`.50`$ with each other
and have validities of $`.70`$ against a dichotomised criterion with
base rate $`.60`$. The original table is indexed by target joint
selection ratio.

``` r

R_tog <- matrix(c(
  1.00, .50, .70,
  .50, 1.00, .70,
  .70, .70, 1.00
), nrow = 3, byrow = TRUE)

joint_targets <- c(.20, .50)
tog_grid <- lapply(joint_targets, function(jsr) {
  tr_multivariate_equal_cutoff(
    joint_selection_ratio = jsr,
    base_rate = .60,
    R = R_tog
  )
})

tog_table <- data.frame(
  joint_sr        = joint_targets,
  marginal_sr     = vapply(tog_grid,
                           function(o) o$solved_marginal_selection_ratio,
                           numeric(1)),
  ppv             = vapply(tog_grid, function(o) o$ppv, numeric(1)),
  sensitivity     = vapply(tog_grid, function(o) o$sensitivity, numeric(1)),
  specificity     = vapply(tog_grid, function(o) o$specificity, numeric(1))
)
tog_table
#>   joint_sr marginal_sr       ppv sensitivity specificity
#> 1      0.2   0.3543206 0.9719918   0.3239973   0.9859959
#> 2      0.5   0.6530319 0.8661905   0.7218254   0.8327381
```

The pattern is the one Thomas, Owen, and Gunst (1977) emphasise: as the
target joint selection ratio increases from $`.20`$ to $`.50`$, the
marginal cutoff per predictor relaxes substantially, and the PPV
decreases monotonically from a value near $`.97`$ to a value near
$`.85`$. Selectivity and base rate jointly determine the success ratio,
exactly as in the univariate Taylor-Russell logic, but the multivariate
generalisation makes explicit the role of predictor intercorrelation.
The same reproduction is documented in the help file of
[`TaylorRussell::TaylorRussell()`](https://rdrr.io/pkg/TaylorRussell/man/TaylorRussell.html)
(Waller, 2024), and the figures returned by the two implementations
agree to integration tolerance.

## How to proceed in applied work

1.  Use
    [`tr_classic()`](https://rgempp.github.io/personnelSelectionUtility/reference/tr_classic.md)
    when the system is genuinely one-dimensional or when a defensible
    composite has already been formed.
2.  Use
    [`tr_solve()`](https://rgempp.github.io/personnelSelectionUtility/reference/tr_solve.md)
    to invert the model and obtain the validity or selection ratio
    implied by a target PPV; this anchors goal-setting and break-even
    reasoning in operational terms.
3.  Use
    [`tr_multivariate()`](https://rgempp.github.io/personnelSelectionUtility/reference/tr_multivariate.md)
    when the actual decision is conjunctive and applicants must pass
    multiple simultaneous cutoffs.
4.  Use
    [`tr_multivariate_equal_cutoff()`](https://rgempp.github.io/personnelSelectionUtility/reference/tr_multivariate_equal_cutoff.md)
    when the overall joint selected proportion is fixed by the
    organisation and the marginal equal cutoff is what the analyst must
    solve.
5.  Always inspect whether the joint selected proportion is
    operationally realistic; multiple marginal cutoffs can become
    extremely selective, and a joint $`SR`$ of $`.05`$ may be
    incompatible with the available applicant pool.
6.  Treat the multivariate normal assumption as a modelling assumption,
    not a fact. If the empirical distributions are skewed or truncated,
    report sensitivity analyses and consider non-Gaussian extensions or
    simulation alternatives.
7.  Use
    [`group_tr_multivariate()`](https://rgempp.github.io/personnelSelectionUtility/reference/group_tr_multivariate.md)
    when group-specific base rates or correlation matrices are
    available; the disaggregated reporting is a precondition for any
    defensible adverse-impact analysis.
8.  If success is not naturally dichotomous, consider Naylor-Shine,
    Brogden-Cronbach-Gleser, or Boudreau-style continuous utility
    instead of forcing a dichotomous criterion.

## References

Cascio, W. F. (1980). Responding to the demand for accountability: A
critical analysis of three utility models. *Organizational Behavior and
Human Performance*, *25*, 32–45.

Cronshaw, S. F., Alexander, R. A., Wiesner, W. H., & Barrick, M. R.
(1987). Incorporating risk into selection utility: Two models for
sensitivity analysis and risk simulation. *Organizational Behavior and
Human Decision Processes*, *40*, 270–286.

De Corte, W., Lievens, F., & Sackett, P. R. (2007). Combining predictors
to achieve optimal trade-offs between selection quality and adverse
impact. *Journal of Applied Psychology*, *92*, 1380–1393.

De Corte, W., Sackett, P. R., & Lievens, F. (2011). Designing
Pareto-optimal selection systems: Formalizing the decisions required for
selection system development. *Journal of Applied Psychology*, *96*,
907–926.

Genz, A. (1992). Numerical computation of multivariate normal
probabilities. *Journal of Computational and Graphical Statistics*, *1*,
141–149.

Genz, A., & Bretz, F. (2009). *Computation of multivariate normal and t
probabilities*. Springer.

Owen, D. B. (1956). Tables for computing bivariate normal probabilities.
*Annals of Mathematical Statistics*, *27*, 1075–1090.

Owen, D. B. (1962). *Handbook of statistical tables*. Addison-Wesley.

Pyburn, K. M., Ployhart, R. E., & Kravitz, D. A. (2008). The
diversity-validity dilemma: Overview and legal context. *Personnel
Psychology*, *61*, 143–151.

Ren, Z., & Waller, N. G. (2024). An extended Taylor-Russell model for
multiple predictors. *Multivariate Behavioral Research*, *59*(3),
654–655. <https://doi.org/10.1080/00273171.2024.2310427>

Sackett, P. R., Lievens, F., Berry, C. M., & Landers, R. N. (2007). A
cautionary note on the effects of range restriction on predictor
intercorrelations. *Journal of Applied Psychology*, *92*, 538–544.

Taylor, H. C., & Russell, J. T. (1939). The relationship of validity
coefficients to the practical effectiveness of tests in selection.
*Journal of Applied Psychology*, *23*, 565–578.

Thomas, J. G., Owen, D. B., & Gunst, R. F. (1977). Improving the use of
educational tests as selection tools. *Journal of Educational
Statistics*, *2*(1), 55–77.

Waller, N. G. (2024). *TaylorRussell: A Taylor-Russell function for
multiple predictors* (R package version 1.2.1).
<https://CRAN.R-project.org/package=TaylorRussell>
