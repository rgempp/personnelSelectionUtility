# Development check script.
# Run this from the package root after editing R files, roxygen comments, or vignettes.
#
# Note for Windows/RStudio users: if devtools::check() prints a Quarto
# "Unknown command TMPDIR=..." message after a clean 0/0/0 check summary, that
# message is external to this package and comes from Quarto detection. The
# package check itself has passed when the summary reports 0 errors, 0 warnings,
# and 0 notes.

if (!requireNamespace("devtools", quietly = TRUE)) install.packages("devtools")
if (!requireNamespace("roxygen2", quietly = TRUE)) install.packages("roxygen2")
if (!requireNamespace("testthat", quietly = TRUE)) install.packages("testthat")

roxygen2::roxygenise()
devtools::test()
devtools::check(args = "--as-cran")
