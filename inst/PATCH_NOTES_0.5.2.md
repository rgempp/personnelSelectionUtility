# Patch notes for personnelSelectionUtility 0.5.2

This patch fixes the roxygen2 parsing error caused by roxygen2 interpreting inline text such as `r = d / sqrt(d^2 + 4)` as dynamic inline R code. The documentation now uses Rd math markup.

It also marks `NAMESPACE` and `man/*.Rd` as roxygen2-generated so that `devtools::document()` can update them rather than skipping them.
