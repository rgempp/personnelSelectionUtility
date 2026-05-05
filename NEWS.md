# personnelSelectionUtility 1.0.0

First stable release.

## Models implemented

* **Classification utility**: Taylor-Russell univariate (`tr_classic`,
  `tr_solve`, `tr_binomial_success_probability`) and Thomas-Owen-Gunst
  multivariate extension for conjunctive multiple-hurdle selection
  (`tr_multivariate`, `tr_multivariate_equal_cutoff`,
  `group_tr_multivariate`).
* **Continuous utility**: Naylor-Shine (`naylor_shine`),
  Brogden-Cronbach-Gleser (`bcg_utility`), Schmidt-Hunter-Pearlman
  intervention utility (`shp_utility`), Boudreau-style discounted utility
  (`boudreau_utility`), probation-period adjustments (`probation_adjustment`,
  `probation_utility`), and Sturman's (2001) integrated comprehensive model
  (`sturman_comprehensive`).
* **SDy estimation**: percentile method (`sdy_percentile`), proportional
  rules (`sdy_proportional`), Raju-Burke-Normand coefficient of variation
  (`sdy_rbn`), CREPID-style activity decomposition (`sdy_crepid`),
  cost-accounting (`sdy_cost_accounting`), superior-equivalents
  (`sdy_superior_equivalents`), observed (`sdy_observed`).
* **Incremental validity**: restricted canonical validity for a fixed
  criterion composite (`restricted_canonical_validity`), incremental
  validity (`incremental_validity`), Johnson relative weights
  (`relative_weights`), Budescu dominance analysis (`dominance_analysis`),
  composite effect size (`composite_d`).
* **Composite formation (Lord & Novick, 1968)**: composite reliability
  (`fuse_reliability`), composite validity (`fuse_validity`), composite
  correlation matrix (`fuse_composite_cor`), Spearman disattenuation
  (`disattenuate_correlation`).
* **Range-restriction corrections**: direct (Thorndike Case II,
  `correct_r_direct_range_restriction`) and multivariate Lawley
  (`correct_r_lawley`) for incidental restriction.
* **Offer-rejection models (Hogarth-Einhorn, 1976; Murphy, 1986)**:
  `offer_rejection_adjustment` with uniform, correlated, and selective
  modes.
* **Selection systems**: compensatory top-down (`compensatory_selection`),
  conjunctive multiple-hurdle simulation (`multiple_hurdle_selection`,
  `multiple_hurdle_selection_staged`), and Ock-Oswald-style comparisons
  (`compare_selection_systems`, `compare_selection_systems_staged`).
* **Decision support**: multi-attribute utility (`multiattribute_utility`),
  Pareto frontiers (`pareto_frontier`, `utility_fairness_frontier`),
  adverse-impact ratio (`adverse_impact_ratio`), Monte Carlo uncertainty
  propagation (`utility_monte_carlo`), sensitivity grid (`sensitivity_grid`),
  break-even validity (`break_even_validity`), risk-adjusted utility
  (`risk_adjusted_utility`).
* **Conversions**: AUC <-> rank-biserial, AUC -> Cohen's d under the
  equal-variance binormal model, d <-> point-biserial correlation,
  inflation-adjusted discount rate.
* **Diagnostics**: regression-based linearity and normality checks
  (`utility_regression_diagnostics`), forecasting efficiency
  (`forecasting_efficiency`), coefficient of determination
  (`coefficient_of_determination`).
* **Reference helpers**: model taxonomy and argument glossary as data frames
  (`model_taxonomy`, `argument_glossary`).

## Tests and validation

* The Taylor-Russell univariate integral and the Thomas-Owen-Gunst
  multivariate integral are cross-validated against
  `scipy.stats.multivariate_normal` on a 6 x 6 grid (TR 1939) and a 3 x 3
  grid (TOG 1977). Discrepancies are below 1e-3 throughout.
* `correct_r_lawley` validated to reproduce Thorndike Case II in the
  k = 2 case to machine precision.
* `dominance_analysis` validated such that general-dominance values sum
  to the full-model R^2 to machine precision.
* `fuse_reliability` validated against the Spearman-Brown formula for
  parallel items.
* Internal coherence: `tr_multivariate(k = 1)` matches `tr_classic` to
  machine precision; `boudreau_utility` collapses to `bcg_utility` under
  degenerate parameters; `cor_to_d` and `d_to_cor` invert each other.

## Vignettes

* `getting-started`: tour through the five main families of the package.
* `reproductions`: reproduces the qualitative pattern of Sturman's (2001)
  comprehensive cascade and Ock and Oswald's (2018) compensatory vs.
  multiple-hurdle comparison, plus a worked example with
  `sturman_comprehensive()`.

## Continuous integration

* `R-CMD-check.yaml`: macOS / Windows / Ubuntu (devel, release, oldrel-1).
* `test-coverage.yaml`: codecov via `covr`.
* `pkgdown.yaml`: site deployment to gh-pages.
