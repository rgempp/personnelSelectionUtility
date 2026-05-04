# Patch notes for personnelSelectionUtility 0.5.16

This is a documentation and pkgdown maintenance release.

## Changes

- Removed the manually maintained `inst/doc` directory from the editable source tree. This prevents `devtools::build()` and `devtools::check()` from asking whether the directory should be deleted before rebuilding vignettes.
- Removed the explicit `knitr::include_graphics("logo.png")` chunks from all four vignette source files. In pkgdown, the logo is already supplied by the automatic page header.
- Removed the manual logo image from `README.md` to avoid an oversized duplicate on the website home page.
- Updated `pkgdown/extra.css` so the logo is hidden on index pages, including the vignette/articles index, but remains visible in individual vignette article headers.

No statistical computations, exported functions, or tests were changed.
