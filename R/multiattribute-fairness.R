#' Multi-attribute utility
#'
#' Computes additive multi-attribute utility `sum(weights * utilities)` for one or
#' more alternatives.
#'
#' @param values Numeric vector or matrix of attribute values. Alternatives are rows.
#' @param weights Attribute weights. They are normalized to sum to one.
#' @param utility_functions Optional list of transformation functions, one per attribute.
#' @return Numeric utility score per alternative.
#' @references
#'
#' Keeney, R. L., & Raiffa, H. (1976). Decisions with multiple objectives:
#'   Preferences and value tradeoffs. Wiley.
#'
#' Roth, P. L., & Bobko, P. (1997). A research agenda for multi-attribute
#'   utility analysis in human resource management. Human Resource Management
#'   Review, 7, 341-368.
#'
#' Roth, P. L. (1994). Multi-attribute utility analysis using the PROMES
#'   approach. Journal of Business and Psychology, 9, 69-80.
#' @export
#' @examples
#' # Literature: Keeney and Raiffa (1976); Roth (1994); Roth and Bobko (1997).
#' multiattribute_utility(matrix(c(80, .90, 70, .95), nrow = 2, byrow = TRUE),
#'                        weights = c(.7, .3))
multiattribute_utility <- function(values, weights, utility_functions = NULL) {
  X <- as.matrix(values)
  if (!is.numeric(X) || any(!is.finite(X))) stop("`values` must be numeric and finite.", call. = FALSE)
  w <- as.numeric(weights)
  if (length(w) != ncol(X) || any(!is.finite(w)) || any(w < 0) || sum(w) <= 0) {
    stop("`weights` must be non-negative, finite, and match the number of attributes.", call. = FALSE)
  }
  w <- w / sum(w)
  if (!is.null(utility_functions)) {
    if (!is.list(utility_functions) || length(utility_functions) != ncol(X)) {
      stop("`utility_functions` must be a list with one function per attribute.", call. = FALSE)
    }
    for (j in seq_len(ncol(X))) X[, j] <- utility_functions[[j]](X[, j])
  }
  as.numeric(X %*% w)
}

#' Pareto frontier indicator
#'
#' Identifies non-dominated alternatives for objectives to be maximized or minimized.
#'
#' @param objectives Numeric matrix/data frame. Alternatives are rows, objectives columns.
#' @param maximize Logical vector indicating whether each objective is to be maximized.
#'   Scalar values are recycled.
#' @return Logical vector indicating Pareto-efficient rows.
#' @references
#'
#' De Corte, W., Lievens, F., & Sackett, P. R. (2007). Combining predictors to
#'   achieve optimal trade-offs between selection quality and adverse impact.
#'   Journal of Applied Psychology, 92, 1380-1393. De Corte, W., Sackett, P. R.,
#'   & Lievens, F. (2011). Designing Pareto-optimal selection systems:
#'   Formalizing the decisions required for selection system development. Journal
#'   of Applied Psychology, 96, 907-926.
#' @export
#' @examples
#' # Literature: De Corte, Lievens, and Sackett (2007); De Corte, Sackett, and Lievens (2011).
#' pareto_frontier(data.frame(validity = c(.30, .35, .32), diversity = c(.80, .70, .85)))
pareto_frontier <- function(objectives, maximize = TRUE) {
  X <- as.matrix(objectives)
  if (!is.numeric(X) || any(!is.finite(X))) stop("`objectives` must be numeric and finite.", call. = FALSE)
  maximize <- recycle_to_length(maximize, ncol(X), "maximize")
  Y <- X
  for (j in seq_len(ncol(Y))) if (!maximize[j]) Y[, j] <- -Y[, j]
  n <- nrow(Y)
  efficient <- rep(TRUE, n)
  for (i in seq_len(n)) {
    others <- setdiff(seq_len(n), i)
    dominated <- any(apply(Y[others, , drop = FALSE], 1, function(row) {
      all(row >= Y[i, ]) && any(row > Y[i, ])
    }))
    efficient[i] <- !dominated
  }
  efficient
}

#' Selection table and classification metrics
#'
#' Computes a 2x2 classification table from observed selected/success outcomes.
#'
#' @param selected Logical or 0/1 vector indicating selection.
#' @param success Logical or 0/1 vector indicating criterion success.
#' @return A list with table and classification metrics.
#' @references
#'
#' Thomas, J. G., Owen, D. B., & Gunst, R. F. (1977). Improving the use of
#'   educational tests as selection tools. Journal of Educational Statistics,
#'   2(1), 55-77.
#'
#' Taylor, H. C., & Russell, J. T. (1939). The relationship of validity
#'   coefficients to the practical effectiveness of tests in selection. Journal
#'   of Applied Psychology, 23, 565-578.
#' @export
#' @examples
#' # Literature: Taylor and Russell (1939); Thomas, Owen, and Gunst (1977).
#' selection_table(c(1, 1, 0, 0), c(1, 0, 1, 0))
selection_table <- function(selected, success) {
  selected <- as.logical(selected)
  success <- as.logical(success)
  if (length(selected) != length(success)) stop("`selected` and `success` must have the same length.", call. = FALSE)
  ok <- stats::complete.cases(selected, success)
  selected <- selected[ok]
  success <- success[ok]
  tp <- sum(selected & success)
  fp <- sum(selected & !success)
  fn <- sum(!selected & success)
  tn <- sum(!selected & !success)
  n <- tp + fp + fn + tn
  list(
    table = matrix(c(tp, fp, fn, tn), nrow = 2, byrow = TRUE,
                   dimnames = list(selected = c("yes", "no"), success = c("yes", "no"))),
    base_rate = (tp + fn) / n,
    selection_ratio = (tp + fp) / n,
    ppv = safe_divide(tp, tp + fp),
    sensitivity = safe_divide(tp, tp + fn),
    specificity = safe_divide(tn, tn + fp)
  )
}

#' Adverse-impact ratio by group
#'
#' Computes selection rates and adverse-impact ratios by group. If no reference
#' group is supplied, the highest selection-rate group is used as reference.
#'
#' @param selected Logical or 0/1 vector indicating selection.
#' @param group Group membership vector.
#' @param reference Optional reference group.
#' @return A data frame with selection rates and ratios.
#' @references
#'
#' De Corte, W., Lievens, F., & Sackett, P. R. (2007). Combining predictors to
#'   achieve optimal trade-offs between selection quality and adverse impact.
#'   Journal of Applied Psychology, 92, 1380-1393.
#'
#' Pyburn, K. M., Ployhart, R. E., & Kravitz, D. A. (2008). The diversity-
#'   validity dilemma: Overview and legal context. Personnel Psychology, 61,
#'   143-151.
#' @export
#' @examples
#' # Literature: Pyburn, Ployhart, and Kravitz (2008); De Corte et al. (2007).
#' adverse_impact_ratio(c(1, 0, 1, 1, 0, 0), c("A", "A", "A", "B", "B", "B"))
adverse_impact_ratio <- function(selected, group, reference = NULL) {
  selected <- as.logical(selected)
  if (length(selected) != length(group)) stop("`selected` and `group` must have the same length.", call. = FALSE)
  ok <- stats::complete.cases(selected, group)
  selected <- selected[ok]
  group <- as.factor(group[ok])
  split_selected <- split(selected, group)
  out <- data.frame(
    group = names(split_selected),
    n = vapply(split_selected, length, integer(1)),
    selected = vapply(split_selected, sum, integer(1)),
    selection_rate = vapply(split_selected, mean, numeric(1)),
    row.names = NULL
  )
  if (is.null(reference)) {
    ref_rate <- max(out$selection_rate)
    reference <- as.character(out$group[which.max(out$selection_rate)])
  } else {
    ref_rate <- out$selection_rate[as.character(out$group) == reference]
    if (length(ref_rate) != 1L) stop("`reference` was not found in `group`.", call. = FALSE)
  }
  out$reference_group <- reference
  out$adverse_impact_ratio <- out$selection_rate / ref_rate
  out
}
