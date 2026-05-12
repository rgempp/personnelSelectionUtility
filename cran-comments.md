## Resubmission

This is a resubmission of personnelSelectionUtility (version 1.0.1)
addressing the comments from the CRAN review of version 1.0.0
(Benjamin Altmann, May 2026):

* Added DOI references in the Description field of DESCRIPTION using the
  format `Authors (Year) <doi:...>` for Taylor and Russell (1939),
  Brogden (1949), Schmidt et al. (1979), Sturman (2001), Thomas et al.
  (1977), Ock and Oswald (2018), and Salgado (2018).
* Added explicit `\value{}` documentation to `print.psu_utility()`,
  clarifying that it is called for side effects (prints to console) and
  returns the input invisibly.

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

