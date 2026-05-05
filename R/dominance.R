# =============================================================================
# Dominance analysis (Budescu, 1993; Azen & Budescu, 2003)
# =============================================================================

#' Dominance analysis for predictor importance
#'
#' Implements Budescu's (1993) dominance analysis to decompose the
#' coefficient of determination of a multiple regression into contributions
#' attributable to each predictor. Three dominance summaries are returned:
#'
#' \itemize{
#'   \item **Complete dominance**: predictor `i` *completely dominates* `j`
#'     if `R^2(S \cup {i}) > R^2(S \cup {j})` for every subset `S` not
#'     containing `i` or `j`. Reported as a pairwise dominance matrix.
#'   \item **Conditional dominance**: average increment of predictor `i` to
#'     `R^2` across subsets of size `k`, for `k = 0, ..., p-1`.
#'   \item **General dominance**: the average of conditional dominance
#'     values; equivalent to the Shapley value of `R^2`.
#' }
#'
#' @param predictor_cor Predictor correlation matrix `R_xx`.
#' @param predictor_criterion_cor Vector of predictor-criterion correlations
#'   `r_xy` (length `p`).
#'
#' @return A list with components:
#' \describe{
#'   \item{r_squared_full}{The full-model `R^2`.}
#'   \item{general_dominance}{Vector of length `p` whose entries sum to
#'     `r_squared_full`.}
#'   \item{conditional_dominance}{`p x p` matrix; row `i` gives the average
#'     contribution of predictor `i` at subset sizes `0, 1, ..., p-1`.}
#'   \item{complete_dominance}{`p x p` logical matrix where entry `[i,j]`
#'     is `TRUE` if `i` completely dominates `j`, `FALSE` if `j` completely
#'     dominates `i`, `NA` otherwise.}
#' }
#'
#' @references
#' Azen, R., & Budescu, D. V. (2003). The dominance analysis approach for
#' comparing predictors in multiple regression. *Psychological Methods*, 8,
#' 129-148.
#'
#' Budescu, D. V. (1993). Dominance analysis: A new approach to the problem
#' of relative importance of predictors in multiple regression.
#' *Psychological Bulletin*, 114, 542-551.
#'
#' @examples
#' Rxx <- matrix(c(1, .30, .20,
#'                 .30, 1, .25,
#'                 .20, .25, 1), 3, 3)
#' rxy <- c(.40, .30, .25)
#' dominance_analysis(Rxx, rxy)
#' @export
dominance_analysis <- function(predictor_cor, predictor_criterion_cor) {
  validate_correlation_matrix(predictor_cor, "predictor_cor")
  p <- nrow(predictor_cor)
  rxy <- as.numeric(predictor_criterion_cor)
  if (length(rxy) != p)
    stop("`predictor_criterion_cor` length must equal nrow(predictor_cor).",
         call. = FALSE)

  r_squared_subset <- function(idx) {
    idx <- unique(idx)
    if (length(idx) == 0L) return(0)
    Rxx_s <- predictor_cor[idx, idx, drop = FALSE]
    rxy_s <- rxy[idx]
    as.numeric(t(rxy_s) %*% solve(Rxx_s) %*% rxy_s)
  }

  # Enumerate all 2^p subsets
  all_idx <- seq_len(p)
  subsets <- list()
  for (k in 0:p) {
    if (k == 0L) {
      subsets <- c(subsets, list(integer(0)))
    } else {
      combos <- utils::combn(all_idx, k, simplify = FALSE)
      subsets <- c(subsets, combos)
    }
  }
  r2 <- vapply(subsets, r_squared_subset, numeric(1))
  names(r2) <- vapply(subsets, function(s) {
    if (length(s) == 0L) "" else paste(s, collapse = ",")
  }, character(1))

  # Conditional dominance: average increment of predictor i across subsets
  # of size k that do not contain i, for k = 0, ..., p-1.
  cond_dom <- matrix(NA_real_, p, p)
  for (i in seq_len(p)) {
    for (k in 0:(p - 1)) {
      # All subsets of size k not containing i
      others <- setdiff(all_idx, i)
      if (k == 0L) {
        increments <- r2[paste(i, collapse = ",")] - 0
      } else {
        candidates <- utils::combn(others, k, simplify = FALSE)
        increments <- vapply(candidates, function(s) {
          r_with    <- r_squared_subset(c(s, i))
          r_without <- r_squared_subset(s)
          r_with - r_without
        }, numeric(1))
      }
      cond_dom[i, k + 1L] <- mean(increments)
    }
  }
  colnames(cond_dom) <- paste0("k=", 0:(p - 1))
  rownames(cond_dom) <- paste0("X", seq_len(p))

  # General dominance: mean across subset sizes
  gen_dom <- rowMeans(cond_dom)
  names(gen_dom) <- paste0("X", seq_len(p))

  # Complete dominance: pairwise comparison across all subsets S not
  # containing i or j.
  comp_dom <- matrix(NA, p, p)
  for (i in seq_len(p)) {
    for (j in seq_len(p)) {
      if (i == j) next
      others <- setdiff(all_idx, c(i, j))
      i_dominates <- TRUE
      j_dominates <- TRUE
      # Iterate over all subsets of others (including empty)
      for (k in 0:length(others)) {
        if (k == 0L) {
          subs <- list(integer(0))
        } else {
          subs <- utils::combn(others, k, simplify = FALSE)
        }
        for (s in subs) {
          inc_i <- r_squared_subset(c(s, i)) - r_squared_subset(s)
          inc_j <- r_squared_subset(c(s, j)) - r_squared_subset(s)
          if (inc_i <= inc_j) i_dominates <- FALSE
          if (inc_j <= inc_i) j_dominates <- FALSE
          if (!i_dominates && !j_dominates) break
        }
        if (!i_dominates && !j_dominates) break
      }
      if (i_dominates) comp_dom[i, j] <- TRUE
      else if (j_dominates) comp_dom[i, j] <- FALSE
    }
  }
  rownames(comp_dom) <- colnames(comp_dom) <- paste0("X", seq_len(p))

  out <- list(
    r_squared_full = r_squared_subset(all_idx),
    general_dominance = gen_dom,
    conditional_dominance = cond_dom,
    complete_dominance = comp_dom
  )
  class(out) <- c("psu_dominance", "psu_utility")
  out
}
