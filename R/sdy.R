#' Estimate SDy from percentile judgments
#'
#' Implements the percentile approximation `SDy = (P85 - P15) / 2`.
#'
#' @param p15 Estimated monetary value of performance at the 15th percentile.
#' @param p85 Estimated monetary value of performance at the 85th percentile.
#' @return Estimated standard deviation of job performance in monetary units.
#' @references
#'
#' Bobko, P., Karren, R., & Parkington, J. J. (1983). Estimation of standard
#'   deviations in utility analyses: An empirical test. Journal of Applied
#'   Psychology, 68, 170-176.
#'
#' Schmidt, F. L., Hunter, J. E., McKenzie, R. C., & Muldrow, T. W. (1979).
#'   Impact of valid selection procedures on work-force productivity. Journal of
#'   Applied Psychology, 64, 609-626.
#' @export
#' @examples
#' # Literature: Schmidt et al. (1979); Bobko, Karren, and Parkington (1983).
#' sdy_percentile(p15 = 60000, p85 = 140000)
sdy_percentile <- function(p15, p85) {
  if (!is.numeric(p15) || !is.numeric(p85) || length(p15) != length(p85)) {
    stop("`p15` and `p85` must be numeric vectors of the same length.", call. = FALSE)
  }
  if (any(!is.finite(p15)) || any(!is.finite(p85)) || any(p85 <= p15)) {
    stop("`p85` must be greater than `p15` and both must be finite.", call. = FALSE)
  }
  (p85 - p15) / 2
}

#' Estimate SDy with proportional rules
#'
#' Computes a salary- or value-based SDy estimate using a multiplier such as .40
#' or .70.
#'
#' @param mean_pay Mean pay or mean output value.
#' @param multiplier Proportional SDy multiplier. Defaults to `.40`.
#' @return Estimated SDy.
#' @references
#'
#' Schmidt, F. L., Hunter, J. E., & Pearlman, K. (1982). Assessing the economic
#'   impact of personnel programs on workforce productivity. Personnel
#'   Psychology, 35, 333-347.
#'
#' Hunter, J. E., & Schmidt, F. L. (1982). Fitting people to jobs: The impact
#'   of personnel selection on national productivity. In M. D. Dunnette & E. A.
#'   Fleishman (Eds.), Human performance and productivity (Vol. 1, pp. 233-284).
#'   Erlbaum.
#' @export
#' @examples
#' # Literature: Schmidt, Hunter, and Pearlman (1982); Hunter and Schmidt (1982).
#' sdy_proportional(mean_pay = 80000, multiplier = .40)
#' sdy_proportional(mean_pay = 80000, multiplier = .70)
sdy_proportional <- function(mean_pay, multiplier = .40) {
  validate_nonnegative(mean_pay, "mean_pay")
  validate_nonnegative(multiplier, "multiplier")
  mean_pay * multiplier
}

#' Estimate SDy with a coefficient-of-variation approach
#'
#' A compact implementation of the Raju-Burke-Normand logic: `SDy = CV * mean_pay`.
#' Use this function when the coefficient of variation is theoretically or
#' empirically justified for the job family.
#'
#' @param mean_pay Mean pay or mean criterion value.
#' @param coefficient_variation Coefficient of variation for job performance value.
#' @return Estimated SDy.
#' @references
#'
#' Raju, N. S., Burke, M. J., & Normand, J. (1990). A new approach for utility
#'   analysis. Journal of Applied Psychology, 75, 3-12.
#' @export
#' @examples
#' # Literature: Raju, Burke, and Normand (1990).
#' sdy_rbn(mean_pay = 80000, coefficient_variation = .35)
sdy_rbn <- function(mean_pay, coefficient_variation) {
  validate_nonnegative(mean_pay, "mean_pay")
  validate_nonnegative(coefficient_variation, "coefficient_variation")
  mean_pay * coefficient_variation
}
