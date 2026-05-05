#' Coefficient of determination
#'
#' Computes the squared validity coefficient.
#'
#' @param validity Predictor-criterion validity coefficient.
#' @return Numeric vector with `validity^2`.
#' @references
#'
#' Taylor, H. C., & Russell, J. T. (1939). The relationship of validity
#'   coefficients to the practical effectiveness of tests in selection. Journal
#'   of Applied Psychology, 23, 565-578.
#'
#' Holling, H. (1998). Utility analysis of personnel selection: An overview and
#'   empirical study based on objective performance measures. Methods of
#'   Psychological Research Online, 3(1), 5-24.
#' @export
#' @examples
#' # Literature: Taylor and Russell (1939); Holling (1998).
#' coefficient_of_determination(.30)
coefficient_of_determination <- function(validity) {
  validate_correlation(validity, "validity")
  validity^2
}

#' Forecasting efficiency
#'
#' Computes the proportional reduction in the standard error of prediction:
#' `1 - sqrt(1 - validity^2)`.
#'
#' @param validity Predictor-criterion validity coefficient.
#' @return Numeric vector with forecasting efficiency values.
#' @references
#'
#' Holling, H. (1998). Utility analysis of personnel selection: An overview and
#'   empirical study based on objective performance measures. Methods of
#'   Psychological Research Online, 3(1), 5-24.
#' @export
#' @examples
#' # Literature: Holling (1998).
#' forecasting_efficiency(.30)
forecasting_efficiency <- function(validity) {
  validate_correlation(validity, "validity")
  1 - sqrt(1 - validity^2)
}

#' SDy from cost-accounting data
#'
#' Computes individual criterion values from production units and unit values,
#' then returns the standard deviation of those values.
#'
#' @param units Numeric matrix or data frame. Rows are employees; columns are
#'   production units, activities, or outputs.
#' @param unit_values Numeric vector of monetary values per unit. Length one or
#'   one value per column of `units`.
#' @param na.rm Should missing values be removed in the SD calculation?
#' @return A list with individual criterion values and `sdy`.
#' @references
#'
#' Cronbach, L. J., & Gleser, G. C. (1965). Psychological tests and personnel
#'   decisions (2nd ed.). University of Illinois Press.
#'
#' Holling, H. (1998). Utility analysis of personnel selection: An overview and
#'   empirical study based on objective performance measures. Methods of
#'   Psychological Research Online, 3(1), 5-24.
#'
#' Cascio, W. F. (1982). Costing human resources: The financial impact of
#'   behavior in organizations. Kent.
#' @export
#' @examples
#' # Literature: Cronbach and Gleser (1965); Cascio (1982); Holling (1998).
#' sdy_cost_accounting(matrix(c(10, 12, 8, 11), ncol = 2), unit_values = c(100, 200))
sdy_cost_accounting <- function(units, unit_values, na.rm = TRUE) {
  units <- as.matrix(units)
  if (!is.numeric(units)) stop("`units` must be numeric.", call. = FALSE)
  if (!is.numeric(unit_values) || any(!is.finite(unit_values))) stop("`unit_values` must be finite and numeric.", call. = FALSE)
  if (length(unit_values) == 1L) unit_values <- rep(unit_values, ncol(units))
  if (length(unit_values) != ncol(units)) stop("`unit_values` must have length 1 or ncol(units).", call. = FALSE)
  y <- as.vector(units %*% unit_values)
  list(y = y, sdy = stats::sd(y, na.rm = na.rm))
}

#' SDy from a simplified CREPID-style activity decomposition
#'
#' Computes a monetary performance index by weighting activity ratings with
#' activity time/frequency and importance weights.
#'
#' @param activities Data frame with activity-level metadata.
#' @param ratings Numeric matrix/data frame. Rows are employees, columns are activities.
#' @param salary Average salary or criterion value to distribute across activities.
#' @param time_col Name of the time/frequency column in `activities`.
#' @param importance_col Name of the importance column in `activities`.
#' @param activity_names Optional activity labels.
#' @param na.rm Should missing values be removed in the SD calculation?
#' @return A list with activity weights, individual criterion values, and `sdy`.
#' @references
#'
#' Cascio, W. F., & Ramos, R. A. (1986). Development and application of a new
#'   method for assessing job performance in behavioral/economic terms. Journal
#'   of Applied Psychology, 71, 20-28.
#' @export
#' @examples
#' # Literature: Cascio and Ramos (1986).
#' activities <- data.frame(time_frequency = c(.4, .6), importance = c(2, 3))
#' ratings <- matrix(c(3, 4, 2, 5, 4, 4), ncol = 2, byrow = TRUE)
#' sdy_crepid(activities, ratings, salary = 80000)
sdy_crepid <- function(activities, ratings, salary,
                       time_col = "time_frequency",
                       importance_col = "importance",
                       activity_names = NULL,
                       na.rm = TRUE) {
  if (!is.data.frame(activities)) stop("`activities` must be a data frame.", call. = FALSE)
  if (!all(c(time_col, importance_col) %in% names(activities))) {
    stop("`activities` must contain `time_col` and `importance_col`.", call. = FALSE)
  }
  ratings <- as.matrix(ratings)
  if (!is.numeric(ratings)) stop("`ratings` must be numeric.", call. = FALSE)
  if (nrow(activities) != ncol(ratings)) stop("nrow(activities) must equal ncol(ratings).", call. = FALSE)
  validate_nonnegative(salary, "salary")
  tf <- activities[[time_col]]
  imp <- activities[[importance_col]]
  if (!is.numeric(tf) || !is.numeric(imp) || any(!is.finite(tf)) || any(!is.finite(imp)) ||
      any(tf < 0) || any(imp < 0) || sum(tf * imp) <= 0) {
    stop("Activity time/frequency and importance values must be non-negative and produce positive weights.", call. = FALSE)
  }
  raw_weight <- tf * imp
  final_weight <- raw_weight / sum(raw_weight)
  dollar_value <- salary * final_weight
  y <- as.vector(ratings %*% dollar_value)
  if (is.null(activity_names)) {
    activity_names <- if (!is.null(colnames(ratings))) colnames(ratings) else paste0("activity_", seq_along(final_weight))
  }
  list(
    activity_weights = data.frame(
      activity = activity_names,
      time_frequency = tf,
      importance = imp,
      raw_weight = raw_weight,
      final_weight = final_weight,
      dollar_value = dollar_value
    ),
    y = y,
    sdy = stats::sd(y, na.rm = na.rm)
  )
}

#' Direct range-restriction correction for selection on the predictor
#'
#' Corrects a restricted validity coefficient for direct range restriction on the
#' predictor using the standard Thorndike Case II expression.
#'
#' @param r_restricted Restricted-sample validity coefficient.
#' @param range_restriction_ratio Ratio of unrestricted to restricted predictor
#'   standard deviations. This is the preferred v0.4.0 name for the literature's `u`.
#' @param u Legacy alias for `range_restriction_ratio`.
#' @return Corrected validity coefficient.
#' @references
#'
#' Sackett, P. R., Laczo, R. M., & Arvey, R. D. (2002). The effects of range
#'   restriction on estimates of criterion interrater reliability: Implications
#'   for validation research. Personnel Psychology, 55, 807-825.
#'
#' Ree, M. J., Carretta, T. R., Earles, J. A., & Albert, W. (1994). Sign
#'   changes when correcting for range restriction: A note on Pearson's and
#'   Lawley's selection formulas. Journal of Applied Psychology, 79, 298-301.
#'
#' Lawley, D. N. (1943). A note on Karl Pearson's selection formulae.
#'   Proceedings of the Royal Society of Edinburgh, Section A, 62, 28-30.
#' @export
#' @examples
#' # Literature: Lawley (1943); Sackett, Laczo, and Arvey (2002); Ree et al. (1994).
#' correct_r_direct_range_restriction(.25, range_restriction_ratio = 1.40)
#' correct_r_direct_range_restriction(.25, u = 1.40)
correct_r_direct_range_restriction <- function(r_restricted, range_restriction_ratio = NULL, u = NULL) {
  validate_correlation(r_restricted, "r_restricted")
  if (is.null(range_restriction_ratio)) range_restriction_ratio <- u
  if (is.null(range_restriction_ratio)) stop("Supply `range_restriction_ratio`.", call. = FALSE)
  if (!is.numeric(range_restriction_ratio) || any(!is.finite(range_restriction_ratio)) || any(range_restriction_ratio <= 0)) {
    stop("`range_restriction_ratio` must be positive and finite.", call. = FALSE)
  }
  (range_restriction_ratio * r_restricted) / sqrt(1 + r_restricted^2 * (range_restriction_ratio^2 - 1))
}

#' Basic utility-analysis regression diagnostics
#'
#' Fits a simple linear model and returns empirical inputs and normality checks
#' relevant to linear utility analysis.
#'
#' @param x Predictor scores.
#' @param y Criterion scores in raw or monetary units.
#' @return A list with sample size, validity, SDy, regression coefficients,
#'   residual summaries, optional Shapiro-Wilk tests, and the fitted model.
#' @references
#'
#' Holling, H. (1998). Utility analysis of personnel selection: An overview and
#'   empirical study based on objective performance measures. Methods of
#'   Psychological Research Online, 3(1), 5-24.
#' @export
#' @examples
#' # Literature: Holling (1998).
#' utility_regression_diagnostics(1:10, c(2, 3, 3, 5, 4, 6, 7, 8, 8, 10))
utility_regression_diagnostics <- function(x, y) {
  if (!is.numeric(x) || !is.numeric(y)) stop("`x` and `y` must be numeric.", call. = FALSE)
  if (length(x) != length(y)) stop("`x` and `y` must have the same length.", call. = FALSE)
  ok <- stats::complete.cases(x, y)
  x <- x[ok]
  y <- y[ok]
  fit <- stats::lm(y ~ x)
  res <- stats::residuals(fit)
  shapiro_safe <- function(z) {
    if (length(z) < 3 || length(z) > 5000) return(NA)
    v <- stats::var(z)
    if (!is.finite(v) || v < .Machine$double.eps^0.5) return(NA)
    tryCatch(stats::shapiro.test(z), error = function(e) NA)
  }
  list(
    n = length(y),
    validity = stats::cor(x, y),
    sdy = stats::sd(y),
    slope = stats::coef(fit)[["x"]],
    intercept = stats::coef(fit)[["(Intercept)"]],
    mean_residual = mean(res),
    residual_sd = stats::sd(res),
    shapiro_y = shapiro_safe(y),
    shapiro_residuals = shapiro_safe(res),
    model = fit
  )
}
