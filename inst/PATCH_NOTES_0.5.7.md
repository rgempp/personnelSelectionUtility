# Patch notes for personnelSelectionUtility 0.5.7

This patch updates the package-level help source to the current roxygen2
convention. The package now documents the special `_PACKAGE` sentinel rather
than relying on the deprecated `@docType package` tag.

No statistical functions or computations were changed.

Recommended local validation:

```r
devtools::document()
devtools::load_all()
devtools::test()
devtools::check(args = "--as-cran")
devtools::check(args = "--as-cran", manual = TRUE)
devtools::build_manual()
pkgdown::build_site()
```
