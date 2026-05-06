## Test environments

* Local: Windows 11, R 4.x.x — 0 errors, 0 warnings, 0 notes
* GitHub Actions:
  * macOS-latest (R-release): 0 errors, 0 warnings, 0 notes
  * Windows-latest (R-release): 0 errors, 0 warnings, 0 notes
  * Ubuntu-latest (R-devel): 0 errors, 0 warnings, 0 notes
  * Ubuntu-latest (R-release): 0 errors, 0 warnings, 0 notes
  * Ubuntu-latest (R-oldrel-1): 0 errors, 0 warnings, 0 notes
* win-builder (R-devel): 0 errors, 0 warnings, 1 note
* win-builder (R-release): 0 errors, 0 warnings, 1 note

R-hub v2 is currently experiencing infrastructure issues (jobs queue 
indefinitely). The GitHub Actions matrix above provides equivalent 
multi-platform coverage of CRAN-relevant configurations.


## R CMD check results

The single NOTE in win-builder runs concerns:

* "New submission" — expected for first CRAN submission of this package.
* "Possibly misspelled words in DESCRIPTION": Boudreau, Brogden, 
  Cronbach, Gleser, Gunst, Sturman. These are surnames of authors 
  cited in the package description (Brogden, 1949; Cronbach & Gleser, 
  1965; Thomas, Owen & Gunst, 1977; Sturman, 2001; Boudreau, 1991).


## This is a new release

This is the first CRAN submission of personnelSelectionUtility (version 1.0.0).

The package implements utility-analysis methods for personnel selection,
organised by the 2x2 taxonomy of (criterion scale: classification or
continuous) x (selection structure: compensatory or conjunctive
multiple-hurdle). Key contributions include:

* Taylor-Russell (1939) classification utility and the Thomas-Owen-Gunst
  (1977) multivariate extension for conjunctive multiple-hurdle selection.
  This second model has not been available outside the TaylorRussell
  package (Waller, 2024); the present package implements an independent,
  vectorised version with cross-validation against mvtnorm::pmvnorm().
* Brogden-Cronbach-Gleser (1949, 1965) and Boudreau-style discounted
  monetary utility, including Sturman's (2001) integrated comprehensive
  model exposed as a single sturman_comprehensive() function.
* Lawley's (1943) multivariate range-restriction correction, Budescu's
  (1993) dominance analysis, Lord-Novick (1968) composite-formation
  helpers, and Hogarth-Einhorn (1976) / Murphy (1986) offer-rejection
  adjustments.

## Numerical validation

* Classification integrals are validated against scipy.stats.multivariate_normal
  (Python) on a 6 x 6 grid for the univariate Taylor-Russell model and 
  a 3 x 3 grid for the Thomas-Owen-Gunst multivariate model. 
  Discrepancies are below 1e-3 throughout.
* correct_r_lawley reduces to Thorndike Case II in the k = 2 case to 
  machine precision.
* dominance_analysis general-dominance values sum to the full-model 
  R-squared to machine precision.
* fuse_reliability reproduces the Spearman-Brown formula for parallel 
  items to machine precision.
  
## Reverse dependencies

This is a new release; there are no reverse dependencies.

## Author

* Maintainer: René Gempp <rene.gempp@udp.cl> (ORCID: 0000-0002-0427-6894)
* Repository: https://github.com/rgempp/personnelSelectionUtility
* Documentation site: https://gempp.cl/personnelSelectionUtility/

