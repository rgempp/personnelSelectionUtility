# Argument naming glossary

Returns the package's recommended argument names and the notation they
map to in the utility-analysis literature. The glossary is intended to
make the API explicit and to avoid mixing compact statistical notation
with readable R argument names.

## Usage

``` r
argument_glossary()
```

## Value

A data frame with argument names, literature notation, and usage notes.

## References

Sturman, M. C. (2001). Utility analysis for multiple selection devices
and multiple outcomes. Journal of Human Resource Costing and Accounting,
6(2), 9-28.

Holling, H. (1998). Utility analysis of personnel selection: An overview
and empirical study based on objective performance measures. Methods of
Psychological Research Online, 3(1), 5-24.

## Examples

``` r
# Literature: Holling (1998); Sturman (2001).
argument_glossary()
#>                    argument                notation
#> 1                 base_rate               BR or phi
#> 2           selection_ratio                      SR
#> 3          selection_ratios                    SR_i
#> 4     joint_selection_ratio                 SR_conj
#> 5                  validity                    r_xy
#> 6                validities                  r_xi,y
#> 7             predictor_cor                    R_XX
#> 8                         R  R = cor(X_1,...,X_k,Y)
#> 9                       sdy                    SD_y
#> 10               n_selected                     N_s
#> 11                n_treated               N_treated
#> 12             n_applicants                       N
#> 13              n_by_period                     N_t
#> 14                   tenure                       T
#> 15                     cost                       C
#> 16       cost_per_applicant                     C_A
#> 17           cost_per_stage                     C_j
#> 18           cost_by_period                     C_t
#> 19        baseline_validity              r_baseline
#> 20 baseline_selection_ratio             SR_baseline
#> 21                delta_z_y               Delta z_y
#> 22            effect_size_d                       d
#> 23  range_restriction_ratio                       u
#> 24           variable_value                       V
#> 25      contribution_margin                  margin
#> 26                 tax_rate                     tax
#> 27            discount_rate                       i
#> 28         stage_predictors             stage index
#> 29   stage_selection_ratios                    SR_j
#> 30            stage_weights                     w_j
#> 31                    n_sim simulation replications
#> 32                     seed             random seed
#>                                                                                 meaning
#> 1               Applicant-population probability of criterion success before selection.
#> 2                          Overall proportion selected by a single cutoff or composite.
#> 3               Vector of marginal selection ratios for multiple predictors or hurdles.
#> 4                      Overall conjunctive probability of passing all multiple cutoffs.
#> 5                                       Focal predictor-criterion validity coefficient.
#> 6                                           Vector of predictor-criterion correlations.
#> 7                                               Predictor intercorrelation matrix only.
#> 8   Full predictor-plus-criterion correlation matrix; predictors first, criterion last.
#> 9                 Standard deviation of job performance in monetary or criterion units.
#> 10                                             Number of selected applicants/employees.
#> 11                                       Number of employees receiving an intervention.
#> 12                                 Number of applicants assessed by a selection system.
#> 13                              Vector of active selected/retained employees by period.
#> 14                                   Expected duration of effects or tenure in periods.
#> 15                                           Total fixed or net cost supplied directly.
#> 16                                   Cost per applicant assessed by a one-stage system.
#> 17                                    Cost per applicant assessed at each hurdle stage.
#> 18                                                   Cost incurred in each time period.
#> 19                                 Validity of the currently operating baseline system.
#> 20       Selection ratio of the baseline system; defaults to the focal selection ratio.
#> 21                  Expected incremental standardized criterion gain supplied directly.
#> 22                               Standardized mean difference for intervention utility.
#> 23                   Ratio of unrestricted to restricted predictor standard deviations.
#> 24 Boudreau-style multiplier V; interpretation controlled by variable_value_convention.
#> 25                     Direct contribution-margin multiplier overriding variable_value.
#> 26                          Tax rate applied to benefits and, where appropriate, costs.
#> 27                                   Discount rate used for present-value calculations.
#> 28                              List defining which predictors enter each hurdle stage.
#> 29                   Within-stage selection ratios for a staged multiple-hurdle system.
#> 30                                             Optional within-stage composite weights.
#> 31                                 Number of Monte Carlo simulated applicants or draws.
#> 32                                          Optional seed for reproducible simulations.
#>                                                                                  note
#> 1                                     Use base_rate rather than BR in the public API.
#> 2                                          Use singular form for one decision cutoff.
#> 3                        Use plural form when there is one SR per predictor or stage.
#> 4      Distinct from marginal selection_ratios; central for Thomas-Owen-Gunst tables.
#> 5            More readable than rxy, but documentation always gives the r_xy mapping.
#> 6                                    Used when multiple predictors enter a composite.
#> 7                                      Do not include the criterion in predictor_cor.
#> 8                               Required by tr_multivariate() and simulation helpers.
#> 9       The package uses sdy because SDy is the conventional label in the literature.
#> 10                                   Avoid N when the role of the count is ambiguous.
#> 11                              Used in Schmidt-Hunter-Pearlman intervention utility.
#> 12               Preferred name in v0.4.0; applicant_n is accepted as a legacy alias.
#> 13 Preferred name in v0.4.0; n_t is accepted as a legacy alias in boudreau_utility().
#> 14                          Used when the same effect persists over multiple periods.
#> 15    Use more specific names when costs are per applicant, per stage, or per period.
#> 16                                  Preferred over CA because it is self-documenting.
#> 17                                               Used in multiple-hurdle simulations.
#> 18                    Preferred name in v0.4.0; cost_t is accepted as a legacy alias.
#> 19                                          Implements the Sturman baseline critique.
#> 20              Important when baseline and focal systems have different selectivity.
#> 21                  Allows direct use of outputs from simulations or external models.
#> 22             Used for training/intervention utility rather than selection validity.
#> 23                         Preferred name in v0.4.0; u is accepted as a legacy alias.
#> 24                 Use contribution_margin directly when V is conceptually ambiguous.
#> 25             Most transparent way to represent value retained after variable costs.
#> 26                                                                 Must be in [0, 1].
#> 27                               Non-negative scalar or vector, depending on context.
#> 28                            Each element is an integer vector of predictor indices.
#> 29    Product gives the expected net selection ratio in a strictly sequential design.
#> 30                                        Defaults to unit weights within each stage.
#> 31                        Keep examples small; use larger values in applied analyses.
#> 32                                 Set seed for reproducible documentation and tests.
subset(argument_glossary(), argument %in% c("base_rate", "selection_ratio", "sdy"))
#>          argument  notation
#> 1       base_rate BR or phi
#> 2 selection_ratio        SR
#> 9             sdy      SD_y
#>                                                                   meaning
#> 1 Applicant-population probability of criterion success before selection.
#> 2            Overall proportion selected by a single cutoff or composite.
#> 9   Standard deviation of job performance in monetary or criterion units.
#>                                                                            note
#> 1                               Use base_rate rather than BR in the public API.
#> 2                                    Use singular form for one decision cutoff.
#> 9 The package uses sdy because SDy is the conventional label in the literature.
```
