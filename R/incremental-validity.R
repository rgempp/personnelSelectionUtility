#' Restricted canonical validity for a fixed criterion composite
#'
#' Computes Sturman-style restricted canonical validity. Predictor weights are
#' optimized, but criterion weights are fixed by the analyst.
#'
#' @param predictor_cor Predictor correlation matrix, `Sigma_11`.
#' @param predictor_criterion_cor Matrix of predictor-criterion correlations,
#'   `Sigma_12`, with predictors in rows and criteria in columns.
#' @param criterion_cor Criterion correlation matrix, `Sigma_22`.
#' @param criterion_weights Fixed criterion weights, `b`.
#' @return A `psu_incremental_validity` object with restricted canonical validity
#'   and optimized standardized predictor weights.
#' @references
#'
#' Sturman, M. C. (2001). Utility analysis for multiple selection devices and
#'   multiple outcomes. Journal of Human Resource Costing and Accounting, 6(2),
#'   9-28.
#' @export
#' @examples
#' # Literature: Sturman (2001).
#' # Use the first call as a minimal example; the longer block illustrates
#' # how to interpret the function in the substantive setting discussed in the literature.
#' # Minimal example (Sturman (2001)).
#' S11 <- matrix(c(1, .30, .30, 1), 2, 2)
#' S12 <- matrix(c(.30, .20, .25, .15), 2, 2)
#' S22 <- matrix(c(1, .40, .40, 1), 2, 2)
#' restricted_canonical_validity(S11, S12, S22, criterion_weights = c(.6, .4))
#'
#' # Substantive example (Sturman (2001)): change criterion weights and compare restricted validity.
#' task_weighted <- restricted_canonical_validity(S11, S12, S22, c(.8, .2))
#' balanced <- restricted_canonical_validity(S11, S12, S22, c(.5, .5))
#' c(task_weighted = task_weighted$validity, balanced = balanced$validity)
restricted_canonical_validity <- function(predictor_cor, predictor_criterion_cor,
                                          criterion_cor, criterion_weights) {
  validate_correlation_matrix(predictor_cor, "predictor_cor")
  validate_correlation_matrix(criterion_cor, "criterion_cor")
  validate_correlation(predictor_criterion_cor, "predictor_criterion_cor")
  if (!is.matrix(predictor_criterion_cor)) predictor_criterion_cor <- as.matrix(predictor_criterion_cor)
  if (nrow(predictor_criterion_cor) != nrow(predictor_cor) ||
      ncol(predictor_criterion_cor) != nrow(criterion_cor)) {
    stop("Dimensions of predictor and criterion matrices are inconsistent.", call. = FALSE)
  }
  b <- as.numeric(criterion_weights)
  if (length(b) != nrow(criterion_cor) || any(!is.finite(b))) {
    stop("`criterion_weights` must be finite and match the number of criteria.", call. = FALSE)
  }
  var_v <- as.numeric(t(b) %*% criterion_cor %*% b)
  if (var_v <= 0) stop("The criterion composite has non-positive variance.", call. = FALSE)
  q <- as.numeric(t(b) %*% t(predictor_criterion_cor) %*%
                    solve(predictor_cor, predictor_criterion_cor %*% b))
  q <- max(q, 0)
  r <- sqrt(q / var_v)
  a_raw <- solve(predictor_cor, predictor_criterion_cor %*% b)
  var_u <- as.numeric(t(a_raw) %*% predictor_cor %*% a_raw)
  weights <- as.numeric(a_raw / sqrt(var_u))
  out <- list(
    model = "Restricted canonical validity",
    validity = r,
    predictor_weights = weights,
    criterion_weights = b,
    predictor_cor = predictor_cor,
    predictor_criterion_cor = predictor_criterion_cor,
    criterion_cor = criterion_cor
  )
  as_psu(out, "psu_incremental_validity")
}

#' Incremental validity for adding predictors to an existing system
#'
#' Computes the difference in restricted canonical validity between a baseline
#' predictor set and an expanded predictor set.
#'
#' @param predictor_cor Predictor correlation matrix for all candidate predictors.
#' @param predictor_criterion_cor Predictor-by-criterion correlation matrix.
#' @param criterion_cor Criterion correlation matrix.
#' @param criterion_weights Fixed criterion weights.
#' @param baseline_predictors Integer indices of predictors already in the system.
#' @param added_predictors Integer indices of predictors to add. Preferred name.
#' @param focal_predictors Optional legacy/convenience alias for the expanded
#'   predictor set. If supplied, `added_predictors` is computed as
#'   `setdiff(focal_predictors, baseline_predictors)`. New code should use
#'   `added_predictors`.
#' @return A `psu_incremental_validity` object.
#' @references
#'
#' Sturman, M. C. (2001). Utility analysis for multiple selection devices and
#'   multiple outcomes. Journal of Human Resource Costing and Accounting, 6(2),
#'   9-28.
#' @export
#' @examples
#' # Literature: Sturman (2001).
#' # Use the first call as a minimal example; the longer block illustrates
#' # how to interpret the function in the substantive setting discussed in the literature.
#' # Minimal example (Sturman (2001)).
#' Rxx <- matrix(c(1, .30, .20, .30, 1, .25, .20, .25, 1), 3, 3)
#' Rxy <- matrix(c(.30, .20, .25, .15, .10, .35), 3, 2, byrow = TRUE)
#' Ryy <- matrix(c(1, .40, .40, 1), 2, 2)
#' incremental_validity(Rxx, Rxy, Ryy, c(.6, .4), baseline_predictors = 1:2,
#'                      added_predictors = 3)
#'
#' # Substantive example (Sturman (2001)): compare two possible additions to the same baseline.
#' add_2 <- incremental_validity(Rxx, Rxy, Ryy, c(.6, .4),
#'                               baseline_predictors = 1, added_predictors = 2)
#' add_3 <- incremental_validity(Rxx, Rxy, Ryy, c(.6, .4),
#'                               baseline_predictors = 1, added_predictors = 3)
#' c(add_predictor_2 = add_2$incremental_validity,
#'   add_predictor_3 = add_3$incremental_validity)
incremental_validity <- function(predictor_cor, predictor_criterion_cor,
                                 criterion_cor, criterion_weights,
                                 baseline_predictors, added_predictors = NULL,
                                 focal_predictors = NULL) {
  if (is.null(added_predictors)) {
    if (!is.null(focal_predictors)) {
      added_predictors <- setdiff(focal_predictors, baseline_predictors)
    } else {
      stop("Provide `added_predictors` or `focal_predictors`.", call. = FALSE)
    }
  }
  if (!is.null(focal_predictors) && !setequal(sort(unique(c(baseline_predictors, added_predictors))), focal_predictors)) {
    warning("Both `added_predictors` and `focal_predictors` were supplied; using `added_predictors`.", call. = FALSE)
  }
  all_idx <- seq_len(nrow(predictor_cor))
  if (any(!baseline_predictors %in% all_idx) || any(!added_predictors %in% all_idx)) {
    stop("Predictor indices are out of range.", call. = FALSE)
  }
  expanded <- sort(unique(c(baseline_predictors, added_predictors)))
  base <- restricted_canonical_validity(
    predictor_cor[baseline_predictors, baseline_predictors, drop = FALSE],
    predictor_criterion_cor[baseline_predictors, , drop = FALSE],
    criterion_cor,
    criterion_weights
  )
  full <- restricted_canonical_validity(
    predictor_cor[expanded, expanded, drop = FALSE],
    predictor_criterion_cor[expanded, , drop = FALSE],
    criterion_cor,
    criterion_weights
  )
  out <- list(
    model = "Incremental restricted canonical validity",
    baseline_validity = base$validity,
    expanded_validity = full$validity,
    incremental_validity = full$validity - base$validity,
    baseline_predictors = baseline_predictors,
    added_predictors = added_predictors,
    expanded_predictors = expanded,
    baseline = base,
    expanded = full
  )
  as_psu(out, "psu_incremental_validity")
}

#' Johnson relative weights for one criterion
#'
#' Computes approximate relative weights for correlated predictors in a multiple
#' regression with one criterion.
#'
#' @param predictor_cor Predictor correlation matrix.
#' @param criterion_cor Vector of predictor-criterion correlations.
#' @return A data frame with raw and rescaled relative weights.
#' @references
#'
#' Johnson, J. W. (2000). A heuristic method for estimating the relative weight
#'   of predictor variables in multiple regression. Multivariate Behavioral
#'   Research, 35, 1-19.
#' @export
#' @examples
#' # Literature: Johnson (2000).
#' relative_weights(matrix(c(1, .30, .30, 1), 2, 2), c(.40, .30))
relative_weights <- function(predictor_cor, criterion_cor) {
  validate_correlation_matrix(predictor_cor, "predictor_cor")
  validate_correlation(criterion_cor, "criterion_cor")
  rxy <- as.numeric(criterion_cor)
  if (length(rxy) != nrow(predictor_cor)) stop("`criterion_cor` length must match predictors.", call. = FALSE)
  e <- eigen(predictor_cor, symmetric = TRUE)
  vals <- pmax(e$values, .Machine$double.eps)
  lambda <- e$vectors %*% diag(sqrt(vals), nrow = length(vals)) %*% t(e$vectors)
  beta_star <- solve(lambda, rxy)
  raw <- as.numeric((lambda^2) %*% (beta_star^2))
  total_r2 <- as.numeric(t(rxy) %*% solve(predictor_cor, rxy))
  rescaled <- if (sum(raw) > 0) raw / sum(raw) * total_r2 else raw
  data.frame(
    predictor = seq_along(raw),
    raw_weight = raw,
    rescaled_weight = rescaled,
    percent_of_r2 = if (total_r2 > 0) 100 * rescaled / total_r2 else NA_real_
  )
}

#' Composite effect size for a weighted predictor battery
#'
#' Computes Sackett-Ellingson-style composite d for a weighted battery.
#'
#' @param d Vector of standardized group differences or effect sizes.
#' @param weights Composite weights. Defaults to equal weights.
#' @param predictor_cor Predictor correlation matrix. Defaults to identity.
#' @param sd Predictor standard deviations. Defaults to ones.
#' @return Composite effect size.
#' @references
#'
#' Sackett, P. R., & Ellingson, J. E. (1997). The effects of forming multi-
#'   predictor composites on group differences and adverse impact. Personnel
#'   Psychology, 50, 707-721.
#' @export
#' @examples
#' # Literature: Sackett and Ellingson (1997).
#' composite_d(d = c(.80, .30), weights = c(.7, .3),
#'             predictor_cor = matrix(c(1, .30, .30, 1), 2, 2))
composite_d <- function(d, weights = NULL, predictor_cor = NULL, sd = NULL) {
  if (!is.numeric(d) || any(!is.finite(d))) stop("`d` must be numeric and finite.", call. = FALSE)
  k <- length(d)
  if (is.null(weights)) weights <- rep(1 / k, k)
  if (is.null(predictor_cor)) predictor_cor <- diag(k)
  if (is.null(sd)) sd <- rep(1, k)
  validate_correlation_matrix(predictor_cor, "predictor_cor")
  if (length(weights) != k || length(sd) != k) stop("Lengths of `d`, `weights`, and `sd` must match.", call. = FALSE)
  cov_x <- diag(sd, k) %*% predictor_cor %*% diag(sd, k)
  numerator <- sum(weights * d * sd)
  denominator <- sqrt(as.numeric(t(weights) %*% cov_x %*% weights))
  numerator / denominator
}
