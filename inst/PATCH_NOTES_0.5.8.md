# Patch notes: personnelSelectionUtility 0.5.8

This patch addresses two development-maintenance messages observed during
`devtools::check(args = "--as-cran")`:

1. The package metadata now declares `RoxygenNote: 8.0.0`, matching the installed
   roxygen2 version used to generate documentation.
2. The manually maintained top-level `INDEX` file has been removed. R generates
   the HTML help index when the package is installed; a static top-level `INDEX`
   can become stale and trigger an `R CMD build` message.

No statistical computations were changed.
