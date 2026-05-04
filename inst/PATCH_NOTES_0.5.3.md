# Patch notes for personnelSelectionUtility 0.5.3

This patch addresses the remaining local `devtools::check(args = "--as-cran")`
issues reported after version 0.5.2.

## Fixed

- Relaxed and stabilized the Thomas-Owen-Gunst equal-cutoff test so that tiny
  numerical integration differences from `mvtnorm::pmvnorm()` do not trigger a
  false test failure.
- `tr_multivariate_equal_cutoff()` now returns both the target design value
  (`joint_selection_ratio`) and the raw numerical value
  (`computed_joint_selection_ratio`).
- Removed the unused `utils` import.
- Added `_pkgdown.yml` to `.Rbuildignore`.
- Wrapped long example comments in roxygen documentation.
