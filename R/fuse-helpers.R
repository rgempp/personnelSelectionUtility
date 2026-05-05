# =============================================================================
# Fuse helpers: composite formation a la Lord & Novick (1968)
# =============================================================================

#' Reliability of a weighted composite (Mosier, 1943; Lord & Novick, 1968)
#'
#' @param weights Numeric vector of composite weights.
#' @param item_cor Symmetric correlation (or covariance) matrix among items.
#' @param item_reliabilities Numeric vector of item reliabilities (length
#'   equal to `weights`). If `NULL`, the composite reliability is computed
#'   under the assumption that diagonal entries of `item_cor` are item
#'   reliabilities (e.g., when an empirical reliability matrix is supplied).
#' @return The reliability of the weighted composite.
#'
#' @references
#' Lord, F. M., & Novick, M. R. (1968). *Statistical theories of mental test
#' scores*. Addison-Wesley.
#'
#' Mosier, C. I. (1943). On the reliability of a weighted composite.
#' *Psychometrika*, 8, 161-168.
#'
#' @examples
#' R <- matrix(c(1, .3, .3, 1), 2, 2)
#' fuse_reliability(c(.5, .5), R, item_reliabilities = c(.80, .85))
#' @export
fuse_reliability <- function(weights, item_cor, item_reliabilities = NULL) {
  weights <- as.numeric(weights)
  item_cor <- as.matrix(item_cor)
  if (length(weights) != nrow(item_cor))
    stop("`weights` length must equal nrow(item_cor).", call. = FALSE)
  validate_correlation_matrix_like(item_cor, "item_cor",
                                   require_unit_diagonal = FALSE)
  num_var <- as.numeric(t(weights) %*% item_cor %*% weights)
  if (is.null(item_reliabilities)) {
    # Assume diagonal already encodes reliabilities (covariance interpretation).
    err_var <- sum(weights^2 * (1 - diag(item_cor)))
  } else {
    if (length(item_reliabilities) != length(weights))
      stop("`item_reliabilities` length must equal `weights`.", call. = FALSE)
    err_var <- sum(weights^2 * diag(item_cor) * (1 - item_reliabilities))
  }
  true_var <- num_var - err_var
  if (num_var <= 0) return(NA_real_)
  true_var / num_var
}

#' Correlation of a weighted composite with an external variable
#'
#' Implements the standard formula
#' \eqn{r_{C,Y} = (w' \rho_{XY}) / \sqrt{w' R_{XX} w}}
#' for the correlation between a weighted composite of items and an external
#' criterion `Y`, where the items have correlations `R_XX` and individual
#' validities `\rho_{XY}` (Lord & Novick, 1968, Ch. 4).
#'
#' @param weights Composite weights.
#' @param item_cor Predictor (item) correlation matrix.
#' @param item_validities Item-level correlations with the external variable.
#' @return Scalar correlation.
#' @examples
#' R <- matrix(c(1, .3, .3, 1), 2, 2)
#' fuse_validity(c(.5, .5), R, item_validities = c(.30, .25))
#' @export
fuse_validity <- function(weights, item_cor, item_validities) {
  weights <- as.numeric(weights)
  if (length(weights) != length(item_validities))
    stop("`weights` and `item_validities` must have the same length.",
         call. = FALSE)
  validate_correlation_matrix_like(item_cor, "item_cor",
                                   require_unit_diagonal = FALSE)
  num <- as.numeric(t(weights) %*% as.numeric(item_validities))
  den <- sqrt(as.numeric(t(weights) %*% item_cor %*% weights))
  if (den <= 0) return(NA_real_)
  num / den
}

#' Correlation matrix between several weighted composites
#'
#' Given a stack of items and a weight matrix `W` whose columns are
#' composite-specific weight vectors, computes the correlation matrix
#' between the resulting composites under the standard Lord-Novick formula.
#'
#' @param weights_matrix `p x m` matrix; column `j` is the weight vector of
#'   composite `j`.
#' @param item_cor `p x p` correlation matrix among items.
#' @return `m x m` correlation matrix among composites.
#' @examples
#' R <- diag(4); R[lower.tri(R)] <- R[upper.tri(R)] <- .25
#' W <- cbind(c(1, 1, 0, 0), c(0, 0, 1, 1))
#' fuse_composite_cor(W, R)
#' @export
fuse_composite_cor <- function(weights_matrix, item_cor) {
  weights_matrix <- as.matrix(weights_matrix)
  item_cor <- as.matrix(item_cor)
  if (nrow(weights_matrix) != nrow(item_cor))
    stop("nrow(weights_matrix) must equal nrow(item_cor).", call. = FALSE)
  validate_correlation_matrix_like(item_cor, "item_cor",
                                   require_unit_diagonal = FALSE)
  Sigma_C <- t(weights_matrix) %*% item_cor %*% weights_matrix
  sds <- sqrt(diag(Sigma_C))
  if (any(sds <= 0))
    stop("At least one composite has zero variance; check weights.",
         call. = FALSE)
  Sigma_C / tcrossprod(sds)
}

#' Disattenuated correlation (Spearman, 1904)
#'
#' Corrects an observed correlation for unreliability in either or both
#' variables.
#'
#' @param r_observed Observed correlation.
#' @param reliability_x Reliability of `X` (default 1, i.e., no correction).
#' @param reliability_y Reliability of `Y` (default 1).
#' @return Disattenuated correlation. Capped at +/- 1 with a warning when
#' the algebraic value exceeds 1 in magnitude (typically a sign of unreliable
#' reliability inputs).
#'
#' @references
#' Spearman, C. (1904). The proof and measurement of association between two
#' things. *American Journal of Psychology*, 15, 72-101.
#'
#' @examples
#' disattenuate_correlation(0.30, reliability_x = 0.80, reliability_y = 0.70)
#' @export
disattenuate_correlation <- function(r_observed, reliability_x = 1,
                                     reliability_y = 1) {
  if (reliability_x <= 0 || reliability_x > 1)
    stop("`reliability_x` must be in (0, 1].", call. = FALSE)
  if (reliability_y <= 0 || reliability_y > 1)
    stop("`reliability_y` must be in (0, 1].", call. = FALSE)
  r_true <- r_observed / sqrt(reliability_x * reliability_y)
  if (abs(r_true) > 1) {
    warning("Disattenuated correlation exceeds 1 in absolute value; ",
            "capped. Check reliability inputs.", call. = FALSE)
    r_true <- sign(r_true)
  }
  r_true
}
