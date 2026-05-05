# =============================================================================
# Release checklist for personnelSelectionUtility
# Run this from the package root, in order. Each block prints a clear
# PASS/FAIL line. Stop on the first FAIL and fix.
#
#   source("tools/release-checklist.R")
# =============================================================================

required_pkgs <- c("devtools", "rcmdcheck", "urlchecker", "spelling",
                   "covr", "pkgdown", "rhub")
missing <- required_pkgs[!vapply(required_pkgs, requireNamespace,
                                 logical(1), quietly = TRUE)]
if (length(missing) > 0L) {
  message("Install required packages first:")
  message("  install.packages(c(",
          paste0("\"", missing, "\"", collapse = ", "), "))")
  invisible(NULL)
}

banner <- function(msg) {
  cat("\n",
      strrep("-", 70), "\n",
      "[STEP] ", msg, "\n",
      strrep("-", 70), "\n", sep = "")
}

ok <- function(msg)   cat("  [OK]   ", msg, "\n", sep = "")
warn <- function(msg) cat("  [WARN] ", msg, "\n", sep = "")
fail <- function(msg) {
  cat("  [FAIL] ", msg, "\n", sep = "")
  stop("Release checklist halted at: ", msg, call. = FALSE)
}

# -----------------------------------------------------------------------------
# 1. Sanity: are we at the package root?
# -----------------------------------------------------------------------------
banner("1. Confirm working directory is package root")
if (!file.exists("DESCRIPTION") || !dir.exists("R"))
  fail("Run this script from the package root.")
ok(paste("Package root:", normalizePath(".")))

desc <- read.dcf("DESCRIPTION")
ok(paste("Package:", desc[1, "Package"], "version", desc[1, "Version"]))

# -----------------------------------------------------------------------------
# 2. Documentation up-to-date
# -----------------------------------------------------------------------------
banner("2. Regenerate documentation")
devtools::document()
ok("man/ regenerated. Inspect any warnings above.")

# -----------------------------------------------------------------------------
# 3. Spell check
# -----------------------------------------------------------------------------
banner("3. Spell check")
if (requireNamespace("spelling", quietly = TRUE)) {
  result <- spelling::spell_check_package()
  if (nrow(result) == 0L) {
    ok("No spelling issues.")
  } else {
    print(result)
    warn(paste(nrow(result), "potential typos; review and add to inst/WORDLIST if intended."))
  }
}

# -----------------------------------------------------------------------------
# 4. URL check
# -----------------------------------------------------------------------------
banner("4. URL check (urlchecker)")
url_results <- urlchecker::url_check()
if (nrow(url_results) == 0L) {
  ok("All URLs reachable.")
} else {
  print(url_results)
  fail("Some URLs are broken or moved. Fix before submission.")
}

# -----------------------------------------------------------------------------
# 5. Local R CMD check --as-cran
# -----------------------------------------------------------------------------
banner("5. Local R CMD check --as-cran")
local_check <- rcmdcheck::rcmdcheck(args = c("--as-cran", "--no-manual"),
                                    error_on = "warning")
if (length(local_check$errors) == 0L &&
    length(local_check$warnings) == 0L) {
  ok("0 errors, 0 warnings.")
  if (length(local_check$notes) > 0L) {
    warn(paste(length(local_check$notes),
               "NOTE(s); justify in cran-comments.md."))
  }
} else {
  fail("R CMD check produced errors or warnings.")
}

# -----------------------------------------------------------------------------
# 6. Reverse dependency check (skipped on first release)
# -----------------------------------------------------------------------------
banner("6. Reverse dependency check")
ok("Skipped: no CRAN reverse dependencies on first release.")

# -----------------------------------------------------------------------------
# 7. Test coverage
# -----------------------------------------------------------------------------
banner("7. Test coverage")
if (requireNamespace("covr", quietly = TRUE)) {
  cov <- covr::package_coverage()
  pct <- covr::percent_coverage(cov)
  cat("  Coverage:", round(pct, 1), "%\n")
  if (pct < 60) {
    warn("Coverage below 60%; consider adding tests.")
  } else {
    ok("Coverage threshold met.")
  }
}

# -----------------------------------------------------------------------------
# 8. CRAN-environment checks (manual triggers)
# -----------------------------------------------------------------------------
banner("8. CRAN-environment cross-checks (run separately)")
cat("Run the following interactively before submission. They take time and\n",
    "are not invoked automatically by this script.\n\n",
    "  devtools::check_win_devel()      # win-builder devel\n",
    "  devtools::check_win_release()    # win-builder release\n",
    "  devtools::check_mac_release()    # macOS builder\n",
    "  rhub::check_for_cran()           # R-hub multi-OS\n", sep = "")

# -----------------------------------------------------------------------------
# 9. Submit
# -----------------------------------------------------------------------------
banner("9. Submit (manual)")
cat("When all of the above pass and the win-builder/macOS-builder/R-hub\n",
    "results return clean, run:\n\n",
    "  devtools::release()\n\n",
    "and confirm the questions interactively. Do NOT skip these steps.\n",
    sep = "")

cat("\n", strrep("=", 70), "\n",
    "Release checklist complete. Review WARNs above before proceeding.\n",
    strrep("=", 70), "\n", sep = "")
