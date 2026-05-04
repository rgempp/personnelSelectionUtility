#' Taylor-Russell utility for one predictor
#'
#' Computes the Taylor-Russell classification table for one normally distributed
#' predictor and one dichotomized criterion.
#'
#' @param base_rate Population proportion of successful applicants, `P(Y >= y_c)`.
#' @param selection_ratio Proportion selected, `P(X >= x_c)`.
#' @param validity Predictor-criterion correlation.
#' @param digits Number of digits used for printed summaries.
#' @return A list with thresholds, TP, FP, FN, TN, PPV, sensitivity, specificity,
#'   and incremental success over the base rate.
#' @references
#'
#' Taylor, H. C., & Russell, J. T. (1939). The relationship of validity
#'   coefficients to the practical effectiveness of tests in selection. Journal
#'   of Applied Psychology, 23, 565-578.
#'
#' Cascio, W. F. (1980). Responding to the demand for accountability: A
#'   critical analysis of three utility models. Organizational Behavior and Human
#'   Performance, 25, 32-45.
#' @export
#' @examples
#' # Literature: Taylor and Russell (1939); Cascio (1980).
#' # Use the first call as a minimal example; the longer block illustrates
#' # how to interpret the function in the substantive setting discussed in the literature.
#' # Minimal example (Taylor and Russell (1939); Cascio (1980)).
#' tr_classic(base_rate = .50, selection_ratio = .20, validity = .35)
#'
#' # Substantive example (Taylor and Russell, 1939; Cascio, 1980).
#' # Examine how selectivity changes the success ratio.
#' low_sr <- tr_classic(base_rate = .50, selection_ratio = .10, validity = .35)
#' high_sr <- tr_classic(base_rate = .50, selection_ratio = .50, validity = .35)
#' c(low_selection_ratio = low_sr$ppv, high_selection_ratio = high_sr$ppv)
tr_classic <- function(base_rate, selection_ratio, validity, digits = 3) {
  validate_probability(base_rate, "base_rate")
  validate_probability(selection_ratio, "selection_ratio")
  validate_correlation(validity, "validity")
  if (length(validity) != 1L || length(base_rate) != 1L || length(selection_ratio) != 1L) {
    stop("`base_rate`, `selection_ratio`, and `validity` must be scalars.", call. = FALSE)
  }
  R <- matrix(c(1, validity, validity, 1), nrow = 2)
  x_cut <- stats::qnorm(1 - selection_ratio)
  y_cut <- stats::qnorm(1 - base_rate)
  tp <- as.numeric(mvtnorm::pmvnorm(
    lower = c(x_cut, y_cut),
    upper = c(Inf, Inf),
    mean = c(0, 0),
    corr = R,
    keepAttr = FALSE
  ))
  fp <- selection_ratio - tp
  fn <- base_rate - tp
  tn <- 1 - tp - fp - fn
  ppv <- safe_divide(tp, tp + fp)
  sensitivity <- safe_divide(tp, base_rate)
  specificity <- safe_divide(tn, 1 - base_rate)
  out <- list(
    model = "Taylor-Russell univariate",
    base_rate = base_rate,
    selection_ratio = selection_ratio,
    validity = validity,
    predictor_cutoff_z = x_cut,
    criterion_cutoff_z = y_cut,
    true_positive = tp,
    false_positive = fp,
    false_negative = fn,
    true_negative = tn,
    ppv = ppv,
    success_ratio = ppv,
    incremental_success = ppv - base_rate,
    sensitivity = sensitivity,
    specificity = specificity,
    digits = digits
  )
  as_psu(out, "psu_tr")
}

#' Solve one Taylor-Russell parameter from the other three
#'
#' Solves for one missing Taylor-Russell parameter among base rate, selection
#' ratio, validity, and PPV. Exactly one of the four arguments must be `NULL`.
#' The default validity interval is non-negative to match the classical
#' Taylor-Russell table convention and the defensive behavior of the
#' `TaylorRussell::TR()` implementation.
#'
#' @param base_rate Population proportion of successful applicants.
#' @param selection_ratio Proportion selected.
#' @param validity Predictor-criterion correlation.
#' @param ppv Positive predictive value / success ratio among selected applicants.
#' @param interval Search interval for the missing parameter.
#' @param tol Numerical tolerance passed to `optimize()`.
#' @param allow_negative_validity Logical. Should the solver allow negative
#'   validity when `validity = NULL`? Defaults to `FALSE`.
#' @return A `psu_tr` object containing the solved parameter and the resulting
#'   Taylor-Russell table.
#' @references
#'
#' Taylor, H. C., & Russell, J. T. (1939). The relationship of validity
#'   coefficients to the practical effectiveness of tests in selection. Journal
#'   of Applied Psychology, 23, 565-578.
#'
#' Waller, N. G. (2024). TaylorRussell: A Taylor-Russell function for multiple
#'   predictors (R package version 1.2.1). CRAN.
#' @export
#' @examples
#' # Literature: Taylor and Russell (1939); Waller (2024).
#' # Use the first call as a minimal example; the longer block illustrates
#' # how to interpret the function in the substantive setting discussed in the literature.
#' # Minimal example: solve validity from desired PPV.
#' tr_solve(base_rate = .50, selection_ratio = .20, validity = NULL, ppv = .70)
#'
#' # Substantive example (Taylor and Russell, 1939; Waller, 2024).
#' # Solve the selection ratio needed for a desired PPV.
#' tr_solve(base_rate = .50, selection_ratio = NULL, validity = .35, ppv = .70)
tr_solve <- function(base_rate = NULL, selection_ratio = NULL, validity = NULL, ppv = NULL,
                     interval = NULL, tol = 1e-8, allow_negative_validity = FALSE) {
  args <- list(base_rate = base_rate, selection_ratio = selection_ratio,
               validity = validity, ppv = ppv)
  missing <- names(args)[vapply(args, is.null, logical(1))]
  if (length(missing) != 1L) {
    stop("Exactly one of `base_rate`, `selection_ratio`, `validity`, or `ppv` must be NULL.", call. = FALSE)
  }
  target <- missing
  if (!is.null(base_rate)) validate_probability(base_rate, "base_rate")
  if (!is.null(selection_ratio)) validate_probability(selection_ratio, "selection_ratio")
  if (!is.null(validity)) validate_correlation(validity, "validity")
  if (!is.null(ppv)) validate_probability(ppv, "ppv")

  if (target == "validity" && !allow_negative_validity && ppv <= base_rate) {
    validity <- 0
    warning("Requested PPV is not above the base rate; non-negative validity is set to 0.", call. = FALSE)
    out <- tr_classic(base_rate, selection_ratio, validity)
    out$solved_parameter <- target
    out$target_ppv <- ppv
    return(out)
  }

  default_interval <- switch(target,
    base_rate = c(1e-6, 1 - 1e-6),
    selection_ratio = c(1e-6, 1 - 1e-6),
    validity = if (allow_negative_validity) c(-.999, .999) else c(0, .999),
    ppv = c(1e-6, 1 - 1e-6)
  )
  if (is.null(interval)) interval <- default_interval

  objective <- function(theta) {
    br <- if (target == "base_rate") theta else base_rate
    sr <- if (target == "selection_ratio") theta else selection_ratio
    cv <- if (target == "validity") theta else validity
    pv <- if (target == "ppv") theta else ppv
    if (target == "ppv") return(0)
    pred <- tr_classic(br, sr, cv)$ppv
    (pred - pv)^2
  }

  if (target == "ppv") {
    ppv <- tr_classic(base_rate, selection_ratio, validity)$ppv
  } else {
    opt <- stats::optimize(objective, interval = interval, tol = tol)
    if (target == "base_rate") base_rate <- opt$minimum
    if (target == "selection_ratio") selection_ratio <- opt$minimum
    if (target == "validity") validity <- opt$minimum
  }
  out <- tr_classic(base_rate, selection_ratio, validity)
  out$solved_parameter <- target
  out$target_ppv <- ppv
  out
}

#' Multivariate Taylor-Russell utility for conjunctive multiple-hurdle selection
#'
#' Implements the Thomas-Owen-Gunst multivariate extension of the Taylor-Russell
#' model. Candidates are selected if and only if they exceed all predictor cutoffs.
#' The correlation matrix must include the predictors first and the criterion last.
#'
#' @param selection_ratios Vector of marginal selection ratios, one per predictor.
#' @param base_rate Population proportion of successful applicants.
#' @param R Correlation matrix of dimension `(k + 1) x (k + 1)`. Predictors must
#'   occupy the first `k` rows/columns; the criterion must be last.
#' @param digits Number of digits used for printed summaries.
#' @return A `psu_tr` object with TP, FP, FN, TN, joint selection ratio, PPV,
#'   sensitivity, specificity, and cutoffs.
#' @references
#'
#' Thomas, J. G., Owen, D. B., & Gunst, R. F. (1977). Improving the use of
#'   educational tests as selection tools. Journal of Educational Statistics,
#'   2(1), 55-77.
#'
#' Taylor, H. C., & Russell, J. T. (1939). The relationship of validity
#'   coefficients to the practical effectiveness of tests in selection. Journal
#'   of Applied Psychology, 23, 565-578.
#'
#' Genz, A., & Bretz, F. (2009). Computation of multivariate normal and t
#'   probabilities. Springer.
#' @export
#' @examples
#' # Literature: Taylor and Russell (1939); Thomas, Owen, and Gunst
#' # (1977); Genz and Bretz (2009).
#' # Use the first call as a minimal example; the longer block illustrates
#' # how to interpret the function in the substantive setting discussed in the literature.
#' # Minimal example (Taylor and Russell, 1939;
#' # Thomas, Owen, and Gunst, 1977; Genz and Bretz, 2009).
#' R <- matrix(c(1, .30, .40,
#'               .30, 1, .35,
#'               .40, .35, 1), nrow = 3, byrow = TRUE)
#' tr_multivariate(selection_ratios = c(.50, .50), base_rate = .50, R = R)
#'
#' # Substantive example (Taylor and Russell, 1939;
#' # Thomas, Owen, and Gunst, 1977; Genz and Bretz, 2009).
#' # Compare two validity patterns under the same marginal cutoffs.
#' R_stronger <- matrix(c(1, .30, .60,
#'                        .30, 1, .55,
#'                        .60, .55, 1), nrow = 3, byrow = TRUE)
#' weak <- tr_multivariate(c(.50, .50), base_rate = .50, R = R)
#' strong <- tr_multivariate(c(.50, .50), base_rate = .50, R = R_stronger)
#' c(weak_ppv = weak$ppv, strong_ppv = strong$ppv)
tr_multivariate <- function(selection_ratios, base_rate, R, digits = 3) {
  validate_probability(selection_ratios, "selection_ratios")
  validate_probability(base_rate, "base_rate")
  validate_correlation_matrix(R, "R")
  k <- length(selection_ratios)
  if (nrow(R) != k + 1L) {
    stop("`R` must have dimension length(selection_ratios) + 1, with the criterion last.", call. = FALSE)
  }
  x_cut <- stats::qnorm(1 - selection_ratios)
  y_cut <- stats::qnorm(1 - base_rate)
  tp <- as.numeric(mvtnorm::pmvnorm(
    lower = c(x_cut, y_cut),
    upper = rep(Inf, k + 1L),
    mean = rep(0, k + 1L),
    corr = R,
    keepAttr = FALSE
  ))
  fp <- as.numeric(mvtnorm::pmvnorm(
    lower = c(x_cut, -Inf),
    upper = c(rep(Inf, k), y_cut),
    mean = rep(0, k + 1L),
    corr = R,
    keepAttr = FALSE
  ))
  fn <- base_rate - tp
  tn <- 1 - tp - fp - fn
  joint_selection_ratio <- tp + fp
  ppv <- safe_divide(tp, joint_selection_ratio)
  sensitivity <- safe_divide(tp, base_rate)
  specificity <- safe_divide(tn, 1 - base_rate)
  out <- list(
    model = "Thomas-Owen-Gunst multivariate Taylor-Russell",
    base_rate = base_rate,
    selection_ratios = selection_ratios,
    joint_selection_ratio = joint_selection_ratio,
    R = R,
    predictor_cutoffs_z = x_cut,
    criterion_cutoff_z = y_cut,
    true_positive = tp,
    false_positive = fp,
    false_negative = fn,
    true_negative = tn,
    ppv = ppv,
    success_ratio = ppv,
    incremental_success = ppv - base_rate,
    sensitivity = sensitivity,
    specificity = specificity,
    digits = digits
  )
  as_psu(out, "psu_tr")
}

#' Solve equal marginal cutoffs for a target joint selection ratio
#'
#' Thomas, Owen, and Gunst's printed tables are indexed by the overall proportion
#' selected under two equal cutoffs. This helper solves the common marginal
#' selection ratio that yields a target conjunctive selection ratio for any
#' predictor correlation matrix, then calls `tr_multivariate()`.
#'
#' @param joint_selection_ratio Target conjunctive selection ratio,
#'   `P(X_1 >= c, ..., X_k >= c)`.
#' @param base_rate Population proportion of successful applicants.
#' @param R Correlation matrix with predictors first and criterion last.
#' @param interval Optional search interval for the common marginal selection
#'   ratio. Defaults to `(joint_selection_ratio, 1)`.
#' @param tol Numerical tolerance passed to `optimize()`.
#' @param digits Number of digits used for printed summaries.
#' @return A `psu_tr` object from `tr_multivariate()` with the solved marginal
#'   selection ratio, the target joint selection ratio, the computed joint
#'   selection ratio, and the numerical joint-selection error added.
#' @references
#'
#' Thomas, J. G., Owen, D. B., & Gunst, R. F. (1977). Improving the use of
#'   educational tests as selection tools. Journal of Educational Statistics,
#'   2(1), 55-77.
#'
#' Waller, N. G. (2024). TaylorRussell: A Taylor-Russell function for multiple
#'   predictors (R package version 1.2.1). CRAN.
#' @export
#' @examples
#' # Literature: Thomas, Owen, and Gunst (1977); Waller (2024).
#' # Use the first call as a minimal example; the longer block illustrates
#' # how to interpret the function in the substantive setting discussed in the literature.
#' # Minimal example (Thomas, Owen, and Gunst (1977); Waller (2024)).
#' R <- matrix(c(1, .50, .70,
#'               .50, 1, .70,
#'               .70, .70, 1), 3, 3, byrow = TRUE)
#' tr_multivariate_equal_cutoff(joint_selection_ratio = .20, base_rate = .60, R = R)
#'
#' # Substantive example (Thomas, Owen, and Gunst, 1977;
#' # Waller, 2024). Reproduce the Example 1 pattern.
#' tog <- tr_multivariate_equal_cutoff(.20, .60, R)
#' c(marginal_sr = tog$solved_marginal_selection_ratio, ppv = tog$ppv)
tr_multivariate_equal_cutoff <- function(joint_selection_ratio, base_rate, R,
                                         interval = NULL, tol = 1e-8, digits = 3) {
  validate_probability(joint_selection_ratio, "joint_selection_ratio")
  validate_probability(base_rate, "base_rate")
  validate_correlation_matrix(R, "R")
  k <- nrow(R) - 1L
  if (k < 1L) stop("`R` must include at least one predictor and one criterion.", call. = FALSE)
  predictor_cor <- R[seq_len(k), seq_len(k), drop = FALSE]
  if (is.null(interval)) interval <- c(joint_selection_ratio + 1e-8, 1 - 1e-8)
  objective <- function(sr) {
    cut <- stats::qnorm(1 - sr)
    joint <- as.numeric(mvtnorm::pmvnorm(
      lower = rep(cut, k),
      upper = rep(Inf, k),
      mean = rep(0, k),
      corr = predictor_cor,
      keepAttr = FALSE
    ))
    (joint - joint_selection_ratio)^2
  }
  opt <- stats::optimize(objective, interval = interval, tol = tol)
  marginal_sr <- opt$minimum
  out <- tr_multivariate(rep(marginal_sr, k), base_rate, R, digits = digits)
  computed_joint_selection_ratio <- out$joint_selection_ratio
  out$target_joint_selection_ratio <- joint_selection_ratio
  out$computed_joint_selection_ratio <- computed_joint_selection_ratio
  out$solved_marginal_selection_ratio <- marginal_sr
  out$joint_selection_error <- computed_joint_selection_ratio - joint_selection_ratio

  # In the equal-cutoff helper, the joint selection ratio is a target design
  # quantity. Use the target value in the returned classification table and
  # keep the computed value separately for numerical diagnostics. This avoids
  # spurious test/check failures caused by tiny multivariate integration error.
  out$joint_selection_ratio <- joint_selection_ratio
  out$false_positive <- joint_selection_ratio - out$true_positive
  out$false_negative <- base_rate - out$true_positive
  out$true_negative <- 1 - out$true_positive - out$false_positive - out$false_negative
  out$ppv <- safe_divide(out$true_positive, joint_selection_ratio)
  out$success_ratio <- out$ppv
  out$incremental_success <- out$ppv - base_rate
  out$sensitivity <- safe_divide(out$true_positive, base_rate)
  out$specificity <- safe_divide(out$true_negative, 1 - base_rate)
  out$model <- "Thomas-Owen-Gunst multivariate Taylor-Russell with equal cutoffs"
  out
}

#' Binomial sampling probabilities for Taylor-Russell success rates
#'
#' Converts a Taylor-Russell success ratio into finite-sample probabilities. This
#' follows the finite-sampling logic discussed by Thomas, Owen, and Gunst: once a
#' conditional probability of success is known, the number of successful selected
#' applicants in a finite cohort can be modeled with a binomial distribution.
#'
#' @param n_selected Number of selected applicants.
#' @param ppv Positive predictive value / success ratio among selected applicants.
#' @param at_least Optional threshold for computing `P(successes >= at_least)`.
#' @return A data frame with the full binomial distribution and, if requested, the
#'   cumulative upper-tail probability.
#' @references
#'
#' Thomas, J. G., Owen, D. B., & Gunst, R. F. (1977). Improving the use of
#'   educational tests as selection tools. Journal of Educational Statistics,
#'   2(1), 55-77.
#' @export
#' @examples
#' # Literature: Thomas, Owen, and Gunst (1977).
#' tr_binomial_success_probability(n_selected = 20, ppv = .91, at_least = 18)
tr_binomial_success_probability <- function(n_selected, ppv, at_least = NULL) {
  if (!is.numeric(n_selected) || length(n_selected) != 1L || !is.finite(n_selected) ||
      n_selected < 0 || abs(n_selected - round(n_selected)) > .Machine$double.eps^0.5) {
    stop("`n_selected` must be a non-negative integer scalar.", call. = FALSE)
  }
  validate_probability(ppv, "ppv", allow_zero = TRUE, allow_one = TRUE)
  x <- 0:as.integer(n_selected)
  probability <- stats::dbinom(x, size = n_selected, prob = ppv)
  out <- data.frame(successes = x, probability = probability)
  if (!is.null(at_least)) {
    if (!is.numeric(at_least) || length(at_least) != 1L || !is.finite(at_least)) {
      stop("`at_least` must be a finite scalar.", call. = FALSE)
    }
    attr(out, "probability_at_least") <- stats::pbinom(at_least - 1, size = n_selected, prob = ppv, lower.tail = FALSE)
  }
  out
}
