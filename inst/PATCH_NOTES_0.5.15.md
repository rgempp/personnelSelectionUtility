# Patch notes: personnelSelectionUtility 0.5.15

This patch addresses a Windows/R-devel installation failure observed during `devtools::check(args = "--as-cran")`, where package installation failed while writing the vignette index to `doc/index.html` because the installed `doc/` directory did not yet exist.

Changes:

- Added `inst/doc/.keep` to ensure the package installs with a `doc/` directory available for vignette indexing.
- Updated package version metadata to 0.5.15.
- No statistical functions, examples, tests, or formulas were changed.
