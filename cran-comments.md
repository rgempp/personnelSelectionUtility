## Test environments

* Local: Ubuntu 24.04, R 4.3.3
* GitHub Actions (workflow `R-CMD-check.yaml`):
  * macOS-latest (R-release)
  * Windows-latest (R-release)
  * Ubuntu-latest (R-devel, with HTTP user-agent set to release)
  * Ubuntu-latest (R-release)
  * Ubuntu-latest (R-oldrel-1)
* win-builder (release and devel)
* R-hub (Linux, Windows, macOS via `rhub::check_for_cran()`)

## R CMD check results

0 errors | 0 warnings | 0 notes

## This is a new release

This is the first CRAN submission of `personnelSelectionUtility` (version
1.0.0).

The package implements utility-analysis methods for personnel selection,
organised by the 2x2 taxonomy of (criterion scale: classification or
continuous) x (selection structure: compensatory or conjunctive
multiple-hurdle). It includes:

* Taylor-Russell (1939) classification utility and the Thomas-Owen-Gunst
  (1977) multivariate extension for conjunctive multiple-hurdle selection.
  This second model has not been available outside the `TaylorRussell`
  package (Waller, 2024); the present package implements an independent,
  vectorised version with cross-validation against
  `mvtnorm::pmvnorm()`.
* Brogden-Cronbach-Gleser (1949, 1965) and Boudreau-style discounted
  monetary utility, including Sturman's (2001) integrated comprehensive
  model exposed as a single `sturman_comprehensive()` function.
* Lawley's (1943) multivariate range-restriction correction, Budescu's
  (1993) dominance analysis, Lord-Novick (1968) composite-formation
  helpers, and Hogarth-Einhorn (1976) / Murphy (1986) offer-rejection
  adjustments — none of which are exposed by the existing utility
  packages on CRAN (`iopsych`, `ParetoR`, `psychmeta`, `MetaUtility`).

## Numerical validation

* Classification integrals are validated against
  `scipy.stats.multivariate_normal` (Python) on a 6 x 6 grid for the
  univariate Taylor-Russell model and a 3 x 3 grid for the
  Thomas-Owen-Gunst multivariate model. Discrepancies are below 1e-3
  throughout.
* `correct_r_lawley` reduces to Thorndike Case II in the k = 2 case to
  machine precision.
* `dominance_analysis` general-dominance values sum to the full-model
  R-squared to machine precision.
* `fuse_reliability` reproduces the Spearman-Brown formula for parallel
  items to machine precision.

## Reverse dependencies

This is a new release; there are no reverse dependencies.

## Author

* Maintainer: René Gempp <rene.gempp@udp.cl> (ORCID: 0000-0002-0427-6894)
* Repository: https://github.com/rgempp/personnelSelectionUtility
* Documentation site: https://rgempp.github.io/personnelSelectionUtility/
