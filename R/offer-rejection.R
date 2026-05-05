# =============================================================================
# Offer rejection (Hogarth & Einhorn, 1976; Murphy, 1986)
# =============================================================================

#' Offer-rejection adjustment for selection utility (Murphy, 1986)
#'
#' Adjusts the expected standardized criterion score of accepted hires when
#' offer recipients can decline. When the probability of accepting an offer
#' is *negatively* correlated with candidate quality (top candidates have
#' more outside options), the realized mean criterion of accepted hires is
#' below the mean of selected (offered) candidates.
#'
#' Three modes are supported:
#' \itemize{
#'   \item `mode = "uniform"`: a fixed acceptance probability `p` independent
#'     of candidate quality. The expected criterion of accepted hires equals
#'     the expected criterion of those offered, but the realized headcount is
#'     scaled by `p`.
#'   \item `mode = "selective"`: the probability of acceptance depends on
#'     candidate standardized quality `z` through a logit link
#'     `logit(p) = a + b * z` with `b < 0` for adverse selection. The
#'     adjusted mean criterion is computed by integrating the standard
#'     normal weighted by the acceptance probability.
#'   \item `mode = "correlated"`: a closed-form approximation under the
#'     assumption that quality and acceptance are jointly normal with
#'     correlation `rho_quality_acceptance`. The adjustment is
#'     \eqn{\bar{z}_{accepted} \approx \bar{z}_{offered} + \rho \cdot
#'     (\lambda(z_p) - \bar{z}_{offered})} for an acceptance threshold
#'     `z_p` derived from the expected acceptance rate.
#' }
#'
#' @param expected_z_offered Expected standardized score of offered
#'   candidates (e.g., `selected_mean_z(selection_ratio)`).
#' @param mode One of `"uniform"`, `"selective"`, or `"correlated"`.
#' @param acceptance_rate Expected proportion of offers accepted (used in
#'   all three modes for the headcount-scaling output).
#' @param rho_quality_acceptance Correlation between standardized candidate
#'   quality and acceptance propensity (used for `mode = "correlated"`).
#'   Negative values reflect adverse selection (top candidates more likely
#'   to decline).
#' @param logit_intercept,logit_slope Logit link coefficients for
#'   `mode = "selective"`. The slope is typically negative for adverse
#'   selection.
#' @param n_offered Optional integer; if supplied, the function also returns
#'   the expected number of accepted hires.
#'
#' @return A list with `expected_z_accepted`, `acceptance_rate`,
#' `effective_validity_loss` (the difference between offered and accepted
#' means), and optionally `expected_n_accepted`.
#'
#' @references
#' Hogarth, R. M., & Einhorn, H. J. (1976). Optimal strategies for personnel
#' selection when candidates can reject job offers. *Journal of Business*,
#' 49, 479-495.
#'
#' Murphy, K. R. (1986). When your top choice turns you down: Effect of
#' rejected offers on the utility of selection tests. *Psychological
#' Bulletin*, 99, 133-138.
#'
#' @examples
#' z_offered <- selected_mean_z(0.20)
#'
#' # Uniform 70% acceptance rate, no quality dependence:
#' offer_rejection_adjustment(z_offered, mode = "uniform",
#'                            acceptance_rate = 0.70, n_offered = 100)
#'
#' # Adverse selection: top candidates more likely to decline.
#' offer_rejection_adjustment(z_offered, mode = "correlated",
#'                            acceptance_rate = 0.70,
#'                            rho_quality_acceptance = -0.20,
#'                            n_offered = 100)
#' @export
offer_rejection_adjustment <- function(expected_z_offered,
                                       mode = c("uniform", "selective",
                                                "correlated"),
                                       acceptance_rate = 1,
                                       rho_quality_acceptance = 0,
                                       logit_intercept = NULL,
                                       logit_slope = NULL,
                                       n_offered = NULL) {
  mode <- match.arg(mode)
  validate_probability(acceptance_rate, "acceptance_rate",
                       allow_zero = FALSE, allow_one = TRUE)

  if (mode == "uniform") {
    z_accepted <- expected_z_offered
    p_accept <- acceptance_rate
  } else if (mode == "correlated") {
    if (abs(rho_quality_acceptance) > 1)
      stop("`rho_quality_acceptance` must be in [-1, 1].", call. = FALSE)
    # Treat acceptance as a latent normal with threshold z_p such that
    # P(accept) = 1 - Phi(z_p). Mean of accepted = E[Z | latent > z_p] when
    # quality and latent are correlated rho.
    # Closed form: E[Z | A > z_p] = E[Z] + rho * lambda(z_p) where
    # lambda is the inverse Mills ratio at z_p.
    z_threshold <- stats::qnorm(1 - acceptance_rate)
    mills <- stats::dnorm(z_threshold) / acceptance_rate
    z_accepted <- expected_z_offered +
      rho_quality_acceptance * mills - rho_quality_acceptance *
      stats::dnorm(stats::qnorm(1 - .5)) / .5  # centred on neutral baseline
    # Simpler formulation: marginal effect of correlation.
    z_accepted <- expected_z_offered + rho_quality_acceptance * mills
    p_accept <- acceptance_rate
  } else {
    # mode == "selective": logit-link integration.
    if (is.null(logit_intercept) || is.null(logit_slope))
      stop("`logit_intercept` and `logit_slope` are required for mode='selective'.",
           call. = FALSE)
    integrand_num <- function(z) {
      p <- stats::plogis(logit_intercept + logit_slope * z)
      z * p * stats::dnorm(z)
    }
    integrand_den <- function(z) {
      p <- stats::plogis(logit_intercept + logit_slope * z)
      p * stats::dnorm(z)
    }
    num <- stats::integrate(integrand_num, lower = -10, upper = 10)$value
    den <- stats::integrate(integrand_den, lower = -10, upper = 10)$value
    z_accepted <- num / den
    p_accept <- den
  }

  out <- list(
    mode = mode,
    expected_z_offered = expected_z_offered,
    expected_z_accepted = z_accepted,
    acceptance_rate = p_accept,
    effective_validity_loss = expected_z_offered - z_accepted
  )
  if (!is.null(n_offered)) {
    out$expected_n_accepted <- n_offered * p_accept
  }
  class(out) <- c("psu_offer_rejection", "psu_utility")
  out
}
