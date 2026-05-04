#' Expected standardized predictor score among selected applicants
#'
#' Computes the mean of a standard normal predictor after top-down selection at a
#' given selection ratio: `dnorm(qnorm(1 - selection_ratio)) / selection_ratio`.
#'
#' @param selection_ratio Proportion of applicants selected. Must be in `(0, 1)`.
#' @return Numeric vector with expected standardized predictor scores.
#' @references
#'
#' Naylor, J. C., & Shine, L. C. (1965). A table for determining the increase
#'   in mean criterion score obtained by using a selection device. Journal of
#'   Industrial Psychology, 3, 33-42.
#' @export
#' @examples
#' # Literature: Naylor and Shine (1965).
#' selected_mean_z(c(.10, .20, .50))
selected_mean_z <- function(selection_ratio) {
  validate_probability(selection_ratio, "selection_ratio")
  cut <- stats::qnorm(1 - selection_ratio)
  stats::dnorm(cut) / selection_ratio
}

#' Convert a correlation to Cohen's d
#'
#' Uses the common two-group approximation `d = 2r / sqrt(1 - r^2)`.
#'
#' @param r Correlation coefficient.
#' @return Cohen's d.
#' @references
#'
#' Schmidt, F. L., Hunter, J. E., & Pearlman, K. (1982). Assessing the economic
#'   impact of personnel programs on workforce productivity. Personnel
#'   Psychology, 35, 333-347.
#'
#' Cohen, J. (1988). Statistical power analysis for the behavioral sciences
#'   (2nd ed.). Erlbaum.
#' @export
#' @examples
#' # Literature: Cohen (1988); Schmidt, Hunter, and Pearlman (1982).
#' cor_to_d(.30)
cor_to_d <- function(r) {
  validate_correlation(r, "r")
  2 * r / sqrt(1 - r^2)
}

#' Convert Cohen's d to a correlation
#'
#' Uses \eqn{r = d / \sqrt{d^2 + 4}}.
#'
#' @param d Cohen's d.
#' @return Correlation coefficient.
#' @references
#'
#' Schmidt, F. L., Hunter, J. E., & Pearlman, K. (1982). Assessing the economic
#'   impact of personnel programs on workforce productivity. Personnel
#'   Psychology, 35, 333-347.
#'
#' Cohen, J. (1988). Statistical power analysis for the behavioral sciences
#'   (2nd ed.). Erlbaum.
#' @export
#' @examples
#' # Literature: Cohen (1988); Schmidt, Hunter, and Pearlman (1982).
#' d_to_cor(.50)
d_to_cor <- function(d) {
  if (!is.numeric(d) || any(!is.finite(d))) stop("`d` must be numeric and finite.", call. = FALSE)
  d / sqrt(d^2 + 4)
}

#' Convert AUC to a rank-biserial correlation
#'
#' Converts the area under the ROC curve to the rank-biserial correlation,
#' \eqn{r_{rb} = 2 AUC - 1}. This is a distribution-free dominance summary: it
#' rescales the probability that a randomly chosen successful applicant is ranked
#' above a randomly chosen unsuccessful applicant from the `[0, 1]` AUC scale to
#' the `[-1, 1]` correlation-like scale.
#'
#' @param auc Area under the ROC curve. Must be in `[0, 1]`.
#' @return Numeric vector of rank-biserial correlations.
#' @references
#'
#' Hanley, J. A., & McNeil, B. J. (1982). The meaning and use of the area under
#'   a receiver operating characteristic (ROC) curve. *Radiology*, 143(1), 29-36.
#'
#' Kerby, D. S. (2014). The simple difference formula: An approach to teaching
#'   nonparametric correlation. *Comprehensive Psychology*, 3, 11.IT.3.1.
#'
#' Rice, M. E., & Harris, G. T. (2005). Comparing effect sizes in follow-up
#'   studies: ROC area, Cohen's d, and r. *Law and Human Behavior*, 29(5),
#'   615-620.
#' @export
#' @examples
#' # Minimal example: AUC = .50 implies no dominance.
#' auc_to_rank_biserial(.50)
#'
#' # AUC = .75 means 75% favorable pairwise ordering; r_rb = .50.
#' auc_to_rank_biserial(.75)
auc_to_rank_biserial <- function(auc) {
  validate_probability(auc, "auc", allow_zero = TRUE, allow_one = TRUE)
  2 * auc - 1
}

#' Convert AUC to Cohen's d under the equal-variance binormal model
#'
#' Converts AUC to Cohen's d using \eqn{d = \sqrt{2}\Phi^{-1}(AUC)}. This
#' conversion assumes two normal distributions with equal variances and should
#' therefore be interpreted as a model-based effect-size conversion, not as a
#' universal transformation from classifier accuracy to personnel-selection
#' validity.
#'
#' @param auc Area under the ROC curve. Must be in `(0, 1)` because AUC values
#'   of 0 or 1 imply infinite d under the equal-variance binormal model.
#' @return Numeric vector of Cohen's d values.
#' @references
#'
#' Hanley, J. A., & McNeil, B. J. (1982). The meaning and use of the area under
#'   a receiver operating characteristic (ROC) curve. *Radiology*, 143(1), 29-36.
#'
#' Rice, M. E., & Harris, G. T. (2005). Comparing effect sizes in follow-up
#'   studies: ROC area, Cohen's d, and r. *Law and Human Behavior*, 29(5),
#'   615-620.
#'
#' Salgado, J. F. (2018). Transforming the area under the normal curve (AUC)
#'   into Cohen's d, Pearson's r_pb, odds-ratio, and natural log odds-ratio: Two
#'   conversion tables. *The European Journal of Psychology Applied to Legal
#'   Context*, 10(1), 35-47.
#' @export
#' @examples
#' # Minimal example based on the equal-variance binormal conversion.
#' auc_to_d_equal_variance(.75)
#'
#' # Direction is preserved: AUC below .50 implies a negative effect.
#' auc_to_d_equal_variance(.40)
auc_to_d_equal_variance <- function(auc) {
  validate_probability(auc, "auc")
  sqrt(2) * stats::qnorm(auc)
}

#' Convert Cohen's d to a point-biserial correlation
#'
#' Converts a standardized mean difference to the point-biserial correlation
#' implied by a dichotomous criterion with base rate \eqn{p}. The implemented
#' formula is \eqn{r_{pb} = d\sqrt{p(1-p)} / \sqrt{1 + d^2p(1-p)}}. When
#' `base_rate = .50`, this reduces to the common equal-group conversion
#' \eqn{r = d / \sqrt{d^2 + 4}}.
#'
#' @param d Cohen's d. Must be numeric and finite.
#' @param base_rate Proportion in the focal or successful group, usually denoted
#'   \eqn{p}. Must be in `(0, 1)`. The default is `.50`.
#' @return Numeric vector of point-biserial correlations.
#' @references
#'
#' Cohen, J. (1988). *Statistical power analysis for the behavioral sciences*
#'   (2nd ed.). Erlbaum.
#'
#' Rice, M. E., & Harris, G. T. (2005). Comparing effect sizes in follow-up
#'   studies: ROC area, Cohen's d, and r. *Law and Human Behavior*, 29(5),
#'   615-620.
#'
#' Salgado, J. F. (2018). Transforming the area under the normal curve (AUC)
#'   into Cohen's d, Pearson's r_pb, odds-ratio, and natural log odds-ratio: Two
#'   conversion tables. *The European Journal of Psychology Applied to Legal
#'   Context*, 10(1), 35-47.
#' @export
#' @examples
#' # Minimal example: equal base-rate conversion equals d_to_cor().
#' d_to_point_biserial(.50, base_rate = .50)
#' d_to_cor(.50)
#'
#' # Unequal base rates reduce the attainable point-biserial correlation.
#' d_to_point_biserial(.50, base_rate = c(.50, .20, .10))
d_to_point_biserial <- function(d, base_rate = .50) {
  if (!is.numeric(d) || any(!is.finite(d))) {
    stop("`d` must be numeric and finite.", call. = FALSE)
  }
  validate_probability(base_rate, "base_rate")
  p <- base_rate
  q <- 1 - p
  d * sqrt(p * q) / sqrt(1 + d^2 * p * q)
}

#' Convert AUC to a point-biserial correlation
#'
#' Converts AUC to Cohen's d under the equal-variance binormal model and then
#' converts d to a point-biserial correlation for a user-specified base rate. This
#' is the preferred correlation-like conversion when a utility-analysis function
#' requires a validity input but the available evidence is reported as AUC.
#'
#' @inheritParams auc_to_d_equal_variance
#' @param base_rate Proportion in the focal or successful group, usually denoted
#'   \eqn{p}. Must be in `(0, 1)`. The default is `.50`.
#' @return Numeric vector of point-biserial correlations.
#' @references
#'
#' Hanley, J. A., & McNeil, B. J. (1982). The meaning and use of the area under
#'   a receiver operating characteristic (ROC) curve. *Radiology*, 143(1), 29-36.
#'
#' Rice, M. E., & Harris, G. T. (2005). Comparing effect sizes in follow-up
#'   studies: ROC area, Cohen's d, and r. *Law and Human Behavior*, 29(5),
#'   615-620.
#'
#' Salgado, J. F. (2018). Transforming the area under the normal curve (AUC)
#'   into Cohen's d, Pearson's r_pb, odds-ratio, and natural log odds-ratio: Two
#'   conversion tables. *The European Journal of Psychology Applied to Legal
#'   Context*, 10(1), 35-47.
#' @export
#' @examples
#' # Minimal example: AUC to d, then to r_pb for a balanced binary criterion.
#' auc_to_point_biserial(.75)
#'
#' # Substantive example: examine how base rate affects the implied r_pb.
#' auc_to_point_biserial(.75, base_rate = c(.50, .30, .20, .10))
auc_to_point_biserial <- function(auc, base_rate = .50) {
  d_to_point_biserial(auc_to_d_equal_variance(auc), base_rate = base_rate)
}

#' Superseded AUC-to-r conversion
#'
#' `auc_to_r()` is retained as a backward-compatible alias for
#' [auc_to_point_biserial()] with `base_rate = .50`. New code should use the more
#' explicit conversion family: [auc_to_rank_biserial()],
#' [auc_to_d_equal_variance()], [d_to_point_biserial()], and
#' [auc_to_point_biserial()].
#'
#' @inheritParams auc_to_point_biserial
#' @return Numeric vector of point-biserial correlations.
#' @references
#'
#' Rice, M. E., & Harris, G. T. (2005). Comparing effect sizes in follow-up
#'   studies: ROC area, Cohen's d, and r. *Law and Human Behavior*, 29(5),
#'   615-620.
#'
#' Salgado, J. F. (2018). Transforming the area under the normal curve (AUC)
#'   into Cohen's d, Pearson's r_pb, odds-ratio, and natural log odds-ratio: Two
#'   conversion tables. *The European Journal of Psychology Applied to Legal
#'   Context*, 10(1), 35-47.
#' @keywords internal
#' @export
#' @examples
#' # Backward-compatible alias; prefer auc_to_point_biserial().
#' auc_to_r(.75)
auc_to_r <- function(auc, base_rate = .50) {
  auc_to_point_biserial(auc, base_rate = base_rate)
}

#' Combine nominal discount and inflation rates
#'
#' Computes `i_a = i + f + i*f`.
#'
#' @param discount_rate Real discount rate.
#' @param inflation_rate Inflation rate.
#' @return Inflation-adjusted discount rate.
#' @references
#'
#' Tziner, A., Meir, E. I., Dahan, M., & Birati, A. (1994). An investigation of
#'   the predictive validity and economic utility of the assessment center for
#'   the high- management level. Canadian Journal of Behavioural Science, 26,
#'   228-245.
#'
#' Holling, H. (1998). Utility analysis of personnel selection: An overview and
#'   empirical study based on objective performance measures. Methods of
#'   Psychological Research Online, 3(1), 5-24.
#' @export
#' @examples
#' # Literature: Tziner et al. (1994); Holling (1998).
#' inflation_adjusted_rate(.08, .025)
inflation_adjusted_rate <- function(discount_rate, inflation_rate) {
  validate_nonnegative(discount_rate, "discount_rate")
  validate_nonnegative(inflation_rate, "inflation_rate")
  discount_rate + inflation_rate + discount_rate * inflation_rate
}
