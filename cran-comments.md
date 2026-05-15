## Resubmission (second)

This is a second resubmission of personnelSelectionUtility (version 1.0.2)
addressing the comment from the CRAN review of version 1.0.1 (Benjamin
Altmann, May 12, 2026):

* Added explicit `\value{}` documentation to the `print.psu_utility()`
  S3 method documentation, following the CRAN cookbook recommendation
  to add the `@return` tag in the corresponding `.R` file and
  re-roxygenize. The previous resubmission (1.0.1) included the fix
  for the related `print.psu_comparison` method but, due to an
  editing error, the roxygen block intended for `print.psu_utility`
  was placed above `print.psu_comparison` instead. The fix is now
  applied to `print.psu_utility` and all its subclass aliases
  (`print.psu_tr`, `print.psu_bcg`, `print.psu_ns`, `print.psu_shp`,
  `print.psu_boudreau`, `print.psu_incremental_validity`,
  `print.psu_monte_carlo`, `print.psu_sturman`), which are now all
  documented under the same `.Rd` via `@rdname`.
  
## Test environments

* Local: Windows 11, R 4.6.0 — 0 errors, 0 warnings, 0 notes
* GitHub Actions:
  * macOS-latest (R-release): OK
  * Windows-latest (R-release): OK
  * Ubuntu-latest (R-devel): OK
  * Ubuntu-latest (R-release): OK
  * Ubuntu-latest (R-oldrel-1): OK
* win-builder (R-release): 0 errors, 0 warnings, 1 NOTE (surname
  false positives — see below).
* win-builder (R-devel): attempted on 2026-05-11 via
  devtools::check_win_devel() and via manual upload to
  https://win-builder.r-project.org/upload.aspx; no email response
  was received within 4+ hours, presumably due to mail delivery
  issues at the institutional address. The package builds and
  passes R CMD check on R-devel via the GitHub Actions workflow
  (ubuntu-latest with r: devel), providing equivalent R-devel
  validation.

## R CMD check results

The remaining NOTE concerns:
* "New submission" — expected for a first-time package on CRAN.
* "Possibly misspelled words in DESCRIPTION": Brogden, Cronbach,
  Gleser, Gunst, Ock, Pearlman, Salgado, Sturman. These are
  surnames of authors cited in the package description.

## Reverse dependencies

This is a new release; there are no reverse dependencies.

## Author

* Maintainer: René Gempp <rene.gempp@udp.cl> (ORCID: 0000-0002-0427-6894)
* Repository: https://github.com/rgempp/personnelSelectionUtility
* Documentation site: https://gempp.cl/personnelSelectionUtility/

