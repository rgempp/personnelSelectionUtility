# =============================================================================
# Standalone URL check
# Run anytime URLs in DESCRIPTION, README, vignettes, or Rd files might have
# rotted. Catches 404s, redirects, and SSL failures before CRAN does.
#
#   Rscript tools/url-check.R
# =============================================================================
if (!requireNamespace("urlchecker", quietly = TRUE)) {
  message("Install with: install.packages(\"urlchecker\")")
  quit(status = 1)
}

cat("Running urlchecker::url_check() on package root...\n")
res <- urlchecker::url_check()
if (nrow(res) == 0L) {
  cat("All URLs reachable.\n")
  quit(status = 0)
} else {
  cat("Issues found:\n")
  print(res)
  cat("\nFix the URLs above before submitting to CRAN.\n",
      "Tip: `urlchecker::url_update()` can rewrite redirects in place.\n",
      sep = "")
  quit(status = 1)
}
