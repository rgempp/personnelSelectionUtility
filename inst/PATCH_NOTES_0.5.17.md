# personnelSelectionUtility 0.5.17 patch notes

This maintenance release addresses a packaging issue introduced while trying to handle vignette installation on Windows/R 4.6.

## Changes

- The editable source tree no longer contains `inst/doc`, so `devtools::check()` should not ask whether that directory may be deleted.
- Added `configure` and `configure.win` scripts that create `inst/doc/.keep` during source installation. This ensures that the installed package has a `doc/` directory before R writes the vignette index.
- Removed unused `vignettes/logo.png` and `vignettes/logo.svg`; the logo is managed by pkgdown through `man/figures/logo.*`.
- No exported functions or statistical computations changed.
