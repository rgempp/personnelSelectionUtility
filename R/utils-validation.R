# Internal validation and printing helpers ---------------------------------

validate_probability <- function(x, name, allow_zero = FALSE, allow_one = FALSE) {
  if (!is.numeric(x) || length(x) == 0L || any(!is.finite(x))) {
    stop("`", name, "` must be numeric and finite.", call. = FALSE)
  }
  lower_ok <- if (allow_zero) x >= 0 else x > 0
  upper_ok <- if (allow_one) x <= 1 else x < 1
  if (any(!lower_ok | !upper_ok)) {
    bracket <- paste0(if (allow_zero) "[" else "(", "0, 1", if (allow_one) "]" else ")")
    stop("`", name, "` must be in ", bracket, ".", call. = FALSE)
  }
  invisible(x)
}

validate_nonnegative <- function(x, name) {
  if (!is.numeric(x) || any(!is.finite(x)) || any(x < 0)) {
    stop("`", name, "` must be numeric, finite, and non-negative.", call. = FALSE)
  }
  invisible(x)
}

validate_correlation <- function(x, name) {
  if (!is.numeric(x) || any(!is.finite(x)) || any(abs(x) > 1)) {
    stop("`", name, "` must contain correlations in [-1, 1].", call. = FALSE)
  }
  invisible(x)
}

validate_correlation_matrix <- function(R, name = "R", tol = 1e-8) {
  if (!is.matrix(R) || !is.numeric(R) || nrow(R) != ncol(R)) {
    stop("`", name, "` must be a numeric square correlation matrix.", call. = FALSE)
  }
  if (any(!is.finite(R))) {
    stop("`", name, "` must contain only finite values.", call. = FALSE)
  }
  if (max(abs(R - t(R))) > sqrt(tol)) {
    stop("`", name, "` must be symmetric.", call. = FALSE)
  }
  if (max(abs(diag(R) - 1)) > sqrt(tol)) {
    stop("The diagonal of `", name, "` must contain ones.", call. = FALSE)
  }
  if (any(abs(R) > 1 + sqrt(tol))) {
    stop("All entries of `", name, "` must be correlations in [-1, 1].", call. = FALSE)
  }
  eig <- eigen((R + t(R)) / 2, symmetric = TRUE, only.values = TRUE)$values
  if (min(eig) < -sqrt(tol)) {
    stop("`", name, "` must be positive semi-definite.", call. = FALSE)
  }
  invisible(R)
}

recycle_to_length <- function(x, n, name) {
  if (length(x) == 1L) return(rep(x, n))
  if (length(x) != n) stop("`", name, "` must have length 1 or ", n, ".", call. = FALSE)
  x
}

safe_divide <- function(num, den) {
  ifelse(abs(den) < .Machine$double.eps, NA_real_, num / den)
}

# -----------------------------------------------------------------------------
# Resolve a (modern, legacy) pair of aliases with consistent semantics.
# - If both are NULL/NA, return modern_default if supplied, else NULL.
# - If only one is supplied, return that one.
# - If both are supplied and equal (under all.equal()), return the modern one.
# - If both are supplied and disagree, abort with an informative error.
# -----------------------------------------------------------------------------
resolve_legacy_alias <- function(modern, legacy,
                                 modern_name, legacy_name,
                                 modern_default = NULL) {
  is_missing <- function(x) {
    is.null(x) || (length(x) == 1L && is.numeric(x) && is.na(x))
  }
  modern_missing <- is_missing(modern)
  legacy_missing <- is_missing(legacy)
  if (legacy_missing) {
    if (modern_missing && !is.null(modern_default)) return(modern_default)
    return(modern)
  }
  if (modern_missing) return(legacy)
  if (!isTRUE(all.equal(modern, legacy))) {
    stop("Use only one of `", modern_name, "` or legacy alias `",
         legacy_name, "`; values disagree.", call. = FALSE)
  }
  modern
}

as_psu <- function(x, class) {
  class(x) <- c(class, "psu_utility", class(x))
  x
}

contribution_multiplier <- function(variable_value = 0, contribution_margin = NULL,
                                    variable_value_convention = c("paper_plus", "cost_rate")) {
  variable_value_convention <- match.arg(variable_value_convention)
  if (!is.null(contribution_margin)) {
    if (!is.numeric(contribution_margin) || any(!is.finite(contribution_margin))) {
      stop("`contribution_margin` must be numeric and finite.", call. = FALSE)
    }
    return(contribution_margin)
  }
  if (!is.numeric(variable_value) || any(!is.finite(variable_value))) {
    stop("`variable_value` must be numeric and finite.", call. = FALSE)
  }
  if (variable_value_convention == "paper_plus") 1 + variable_value else 1 - variable_value
}

#' Print personnel-selection utility objects
#'
#' @param x An object returned by one of the package functions.
#' @param ... Ignored.
#' @keywords internal
#' @export
print.psu_utility <- function(x, ...) {
  cls <- class(x)[1L]
  cat("<", cls, ">\n", sep = "")
  nms <- names(x)
  scalar <- vapply(x, function(z) is.numeric(z) && length(z) == 1L, logical(1))
  for (nm in nms[scalar]) {
    cat("  ", nm, ": ", format(signif(x[[nm]], 6)), "\n", sep = "")
  }
  invisible(x)
}

#' Print personnel-selection utility objects
#'
#' Formats and prints utility-analysis result objects of class
#' `psu_utility` and its subclasses (e.g., `psu_tr`, `psu_bcg`, `psu_ns`,
#' `psu_shp`, `psu_boudreau`, `psu_incremental_validity`,
#' `psu_monte_carlo`). Provides a concise textual summary of the computed
#' quantities.
#'
#' @param x An object returned by one of the package's main analysis
#'   functions, with class `psu_utility` or a subclass thereof.
#' @param ... Currently ignored; reserved for compatibility with the
#'   `print()` generic.
#'
#' @return No return value, called for side effects (prints a formatted
#'   summary to the console). The input object `x` is returned invisibly.
#'
#' @keywords internal
#' @export
print.psu_comparison <- function(x, ...) {
  cls <- class(x)[1L]
  cat("<", cls, ">\n", sep = "")
  if (!is.null(x$model)) cat("  Model: ", x$model, "\n", sep = "")
  scalar_top <- vapply(x, function(z) is.numeric(z) && length(z) == 1L,
                       logical(1))
  for (nm in names(x)[scalar_top]) {
    cat("  ", nm, ": ", format(signif(x[[nm]], 6)), "\n", sep = "")
  }
  if (!is.null(x$compensatory)) {
    cat("\n  Compensatory subsystem:\n")
    sub <- x$compensatory
    sc <- vapply(sub, function(z) is.numeric(z) && length(z) == 1L,
                 logical(1))
    for (nm in names(sub)[sc])
      cat("    ", nm, ": ", format(signif(sub[[nm]], 6)), "\n", sep = "")
  }
  if (!is.null(x$multiple_hurdle)) {
    cat("\n  Multiple-hurdle subsystem:\n")
    sub <- x$multiple_hurdle
    sc <- vapply(sub, function(z) is.numeric(z) && length(z) == 1L,
                 logical(1))
    for (nm in names(sub)[sc])
      cat("    ", nm, ": ", format(signif(sub[[nm]], 6)), "\n", sep = "")
  }
  invisible(x)
}
