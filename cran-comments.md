## Resubmission

This is a resubmission of personnelSelectionUtility, addressing the comments 
from Benjamin Altmann's review of version 1.0.0:

* Added DOI references in the Description field of DESCRIPTION using the 
  format `Authors (Year) <doi:...>` for Taylor and Russell (1939) and 
  Brogden (1949).
* Added explicit `\value{}` documentation to `print.psu_utility()` 
  describing that the function is called for side effects (printing) 
  and returns the input invisibly.

## Test environments

* Local: Windows 11, R 4.6.0 — 0 errors, 0 warnings, 0 notes
* GitHub Actions:
  * macOS-latest (R-release): OK
  * Windows-latest (R-release): OK
  * Ubuntu-latest (R-devel, R-release, R-oldrel-1): OK
* win-builder (R-devel and R-release): 0 errors, 0 warnings, 1 note 
  (new submission; surname false positives addressed below)

## R CMD check results

The remaining NOTE concerns:
* "New submission" — expected for a first-time package on CRAN.
* "Possibly misspelled words in DESCRIPTION": Boudreau, Brogden, 
  Cronbach, Gleser, Gunst, Sturman. These are surnames of authors 
  cited in the package description.

## Reverse dependencies

This is a new release; there are no reverse dependencies.

## Author

* Maintainer: René Gempp <rene.gempp@udp.cl> (ORCID: 0000-0002-0427-6894)
* Repository: https://github.com/rgempp/personnelSelectionUtility
* Documentation site: https://gempp.cl/personnelSelectionUtility/

