# personnelSelectionUtility v0.5.12 update report

## Purpose

This maintenance release adds a hexagonal R-package style logo and small pkgdown accessibility fixes.

## Changes

1. Added `man/figures/logo.svg` and `man/figures/logo.png`.
2. Added `vignettes/logo.svg` and `vignettes/logo.png` so the logo can be rendered in the four package vignettes.
3. Added the logo to the top of each vignette using `knitr::include_graphics("logo.png")`.
4. Added the logo to the README/home page using a right-aligned image with alt text.
5. Added `aria-label: Home` and `aria-label: GitHub` to Font Awesome icons in `_pkgdown.yml`, addressing the pkgdown accessibility warning.
6. Updated `pkgdown/extra.css` with a small rule for logo sizing.
7. Updated `DESCRIPTION`, `NEWS.md`, `inst/CITATION`, and added this patch note.
8. Added a note to `dev/check.R` explaining that the Quarto `TMPDIR` message sometimes printed after `devtools::check()` on Windows is external to the package when the final check summary is clean.

## Statistical computations

No statistical computations were changed.

## Validation recommended locally

```r
devtools::document()
devtools::load_all()
devtools::test()
devtools::check(args = "--as-cran")
pkgdown::build_site()
```

If LaTeX tools are available:

```r
devtools::build_manual()
devtools::check(args = "--as-cran", manual = TRUE)
```
