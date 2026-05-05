# =============================================================================
# Final release script
# Wraps `devtools::release()` with a single pre-flight that re-runs the
# critical checks. Use ONLY after `tools/release-checklist.R` has passed end
# to end and after manual win-builder/R-hub confirmations.
#
#   source("tools/release.R")
# =============================================================================
if (!requireNamespace("devtools", quietly = TRUE))
  stop("Install devtools first: install.packages(\"devtools\")")

cat("=== Pre-flight ===\n")

# Re-run URL check
cat("[1/3] URL check...\n")
if (requireNamespace("urlchecker", quietly = TRUE)) {
  res <- urlchecker::url_check()
  if (nrow(res) > 0L) {
    print(res)
    stop("Fix URLs before releasing.", call. = FALSE)
  }
  cat("  [OK]\n")
}

# Re-run R CMD check --as-cran
cat("[2/3] R CMD check --as-cran (this takes a few minutes)...\n")
chk <- rcmdcheck::rcmdcheck(args = c("--as-cran", "--no-manual"),
                            error_on = "warning")
if (length(chk$errors) > 0L || length(chk$warnings) > 0L)
  stop("Fix R CMD check issues before releasing.", call. = FALSE)
cat("  [OK]\n")

# Confirm version is correct
desc <- read.dcf("DESCRIPTION")
cat("[3/3] Version to be released:", desc[1, "Version"], "\n")
ans <- readline(prompt = "Proceed with devtools::release()? [y/N] ")
if (!tolower(ans) %in% c("y", "yes")) {
  cat("Aborted.\n")
  invokeRestart("abort")
}

# Hand off to devtools::release()
cat("\n=== Submitting to CRAN ===\n")
devtools::release()
