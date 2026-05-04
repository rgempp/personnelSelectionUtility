#' Observed SDy from monetary criterion data
#'
#' Computes the observed standard deviation of job performance in monetary or
#' productivity units. This is the direct empirical counterpart to subjective SDy
#' estimation methods.
#'
#' @param y Numeric vector of monetary or productivity criterion values.
#' @param na.rm Should missing values be removed?
#' @return Observed SDy.
#' @references
#'
#' Holling, H. (1998). Utility analysis of personnel selection: An overview and
#'   empirical study based on objective performance measures. Methods of
#'   Psychological Research Online, 3(1), 5-24.
#' @export
#' @examples
#' # Literature: Holling (1998).
#' sdy_observed(c(100, 120, 80, 150))
sdy_observed <- function(y, na.rm = TRUE) {
  if (!is.numeric(y)) stop("`y` must be numeric.", call. = FALSE)
  stats::sd(y, na.rm = na.rm)
}

#' SDy from superior-equivalents judgments
#'
#' Computes SDy from a judged monetary difference between a superior and a typical
#' performer, divided by the standardized distance assumed to separate them.
#'
#' @param superior_value Monetary value of the superior performer.
#' @param typical_value Monetary value of the typical performer.
#' @param z_difference Standardized distance between the two performers. Defaults
#'   to `1`, but can be set to another value if the judgment anchors imply it.
#' @return Estimated SDy.
#' @references
#'
#' Eaton, N. K., Wing, H., & Mitchell, K. J. (1985). Alternate methods of
#'   estimating the dollar value of performance. Personnel Psychology, 38, 27-40.
#'
#' Burke, M. J., & Frederick, J. T. (1984). Two modified procedures for
#'   estimating standard deviations in utility analyses. Journal of Applied
#'   Psychology, 69, 482-489.
#'
#' Burke, M. J., & Frederick, J. T. (1986). A comparison of economic utility
#'   estimates for alternative SDy estimation procedures. Journal of Applied
#'   Psychology, 71, 334-339.
#' @export
#' @examples
#' # Literature: Eaton, Wing, and Mitchell (1985); Burke and Frederick (1984, 1986).
#' sdy_superior_equivalents(superior_value = 140000, typical_value = 100000)
sdy_superior_equivalents <- function(superior_value, typical_value, z_difference = 1) {
  if (!is.numeric(superior_value) || !is.numeric(typical_value) || !is.numeric(z_difference)) {
    stop("Inputs must be numeric.", call. = FALSE)
  }
  if (any(!is.finite(superior_value)) || any(!is.finite(typical_value)) ||
      any(!is.finite(z_difference)) || any(z_difference <= 0)) {
    stop("Values must be finite and `z_difference` must be positive.", call. = FALSE)
  }
  (superior_value - typical_value) / z_difference
}

#' Risk-adjusted utility
#'
#' Computes a mean-variance risk-adjusted utility score. With `risk_aversion = 0`,
#' the score equals expected utility. Larger values penalize uncertainty more
#' strongly.
#'
#' @param expected_utility Expected utility or mean posterior/simulation utility.
#' @param utility_sd Standard deviation of utility.
#' @param risk_aversion Non-negative risk-aversion parameter.
#' @return Risk-adjusted utility score.
#' @references
#'
#' Bhattacharya, M., & Wright, P. M. (2005). Managing human assets in an
#'   uncertain world: Applying real options theory to HRM. International Journal
#'   of Human Resource Management, 16, 929-948.
#'
#' Cronshaw, S. F., Alexander, R. A., Wiesner, W. H., & Barrick, M. R. (1987).
#'   Incorporating risk into selection utility. Organizational Behavior and Human
#'   Decision Processes, 40, 270-286.
#' @export
#' @examples
#' # Literature: Cronshaw et al. (1987); Bhattacharya and Wright (2005).
#' risk_adjusted_utility(expected_utility = 100000, utility_sd = 25000,
#'                       risk_aversion = 1e-6)
risk_adjusted_utility <- function(expected_utility, utility_sd, risk_aversion = 0) {
  if (!is.numeric(expected_utility) || !is.numeric(utility_sd) || !is.numeric(risk_aversion)) {
    stop("Inputs must be numeric.", call. = FALSE)
  }
  if (any(!is.finite(expected_utility)) || any(!is.finite(utility_sd)) ||
      any(!is.finite(risk_aversion)) || any(utility_sd < 0) || any(risk_aversion < 0)) {
    stop("`utility_sd` and `risk_aversion` must be non-negative and all inputs must be finite.", call. = FALSE)
  }
  expected_utility - 0.5 * risk_aversion * utility_sd^2
}

#' Utility-fairness Pareto frontier
#'
#' Convenience wrapper around `pareto_frontier()` for selection-system alternatives
#' evaluated on utility, fairness, and optionally validity.
#'
#' @param utility Numeric vector of utility values to maximize.
#' @param fairness Numeric vector of fairness values to maximize, for example an
#'   adverse-impact ratio where larger values indicate smaller subgroup disparity.
#' @param validity Optional numeric vector of validity values to maximize.
#' @return A data frame with frontier membership.
#' @references
#'
#' De Corte, W., Lievens, F., & Sackett, P. R. (2007). Combining predictors to
#'   achieve optimal trade-offs between selection quality and adverse impact.
#'   Journal of Applied Psychology, 92, 1380-1393.
#'
#' Tippins, N. T., Oswald, F. L., & McPhail, S. M. (2021). Scientific, legal,
#'   and ethical concerns about AI-based personnel selection tools: A call to
#'   action. Personnel Assessment and Decisions, 7(2), Article 1.
#' @export
#' @examples
#' # Literature: De Corte, Lievens, and Sackett (2007); Tippins, Oswald, and McPhail (2021).
#' utility_fairness_frontier(utility = c(100, 120, 90), fairness = c(.80, .70, .95))
utility_fairness_frontier <- function(utility, fairness, validity = NULL) {
  if (is.null(validity)) {
    X <- data.frame(utility = utility, fairness = fairness)
  } else {
    X <- data.frame(utility = utility, fairness = fairness, validity = validity)
  }
  X$pareto_efficient <- pareto_frontier(X, maximize = TRUE)
  X
}

#' Multigroup multivariate Taylor-Russell summaries
#'
#' Applies `tr_multivariate()` separately by group. This is useful for sensitivity
#' analyses in which base rates or correlation matrices differ across demographic
#' groups. It does not by itself establish legal compliance or fairness.
#'
#' @param selection_ratios Vector of marginal selection ratios, common to all groups,
#'   or a list of group-specific vectors.
#' @param base_rates Numeric vector of group-specific base rates.
#' @param R_list List of group-specific correlation matrices.
#' @param group_names Optional group labels.
#' @param group_proportions Optional population proportions. If supplied, they are
#'   normalized and used to compute overall weighted summaries.
#' @return A list with group-level Taylor-Russell summaries and optional weighted
#'   overall metrics.
#' @references
#'
#' De Corte, W., Lievens, F., & Sackett, P. R. (2007). Combining predictors to
#'   achieve optimal trade-offs between selection quality and adverse impact.
#'   Journal of Applied Psychology, 92, 1380-1393.
#'
#' Thomas, J. G., Owen, D. B., & Gunst, R. F. (1977). Improving the use of
#'   educational tests as selection tools. Journal of Educational Statistics,
#'   2(1), 55-77.
#' @export
#' @examples
#' # Literature: Thomas, Owen, and Gunst (1977); De Corte et al. (2007).
#' R <- matrix(c(1, .30, .40, .30, 1, .35, .40, .35, 1), 3, 3)
#' group_tr_multivariate(c(.50, .50), base_rates = c(.50, .40),
#'                       R_list = list(R, R), group_names = c("A", "B"))
group_tr_multivariate <- function(selection_ratios, base_rates, R_list,
                                  group_names = NULL, group_proportions = NULL) {
  validate_probability(base_rates, "base_rates")
  if (!is.list(R_list) || length(R_list) != length(base_rates)) {
    stop("`R_list` must be a list with one correlation matrix per base rate.", call. = FALSE)
  }
  g <- length(base_rates)
  if (is.null(group_names)) group_names <- paste0("group_", seq_len(g))
  if (length(group_names) != g) stop("`group_names` must match the number of groups.", call. = FALSE)
  sr_list <- if (is.list(selection_ratios)) selection_ratios else rep(list(selection_ratios), g)
  if (length(sr_list) != g) stop("`selection_ratios` list must match the number of groups.", call. = FALSE)
  fits <- vector("list", g)
  for (i in seq_len(g)) {
    fits[[i]] <- tr_multivariate(sr_list[[i]], base_rates[i], R_list[[i]])
  }
  names(fits) <- group_names
  summary <- data.frame(
    group = group_names,
    base_rate = base_rates,
    joint_selection_ratio = vapply(fits, `[[`, numeric(1), "joint_selection_ratio"),
    ppv = vapply(fits, `[[`, numeric(1), "ppv"),
    sensitivity = vapply(fits, `[[`, numeric(1), "sensitivity"),
    specificity = vapply(fits, `[[`, numeric(1), "specificity")
  )
  overall <- NULL
  if (!is.null(group_proportions)) {
    if (length(group_proportions) != g || any(group_proportions < 0) || sum(group_proportions) <= 0) {
      stop("`group_proportions` must be non-negative and match groups.", call. = FALSE)
    }
    w <- group_proportions / sum(group_proportions)
    overall <- list(
      joint_selection_ratio = sum(w * summary$joint_selection_ratio),
      ppv = sum(w * summary$ppv),
      sensitivity = sum(w * summary$sensitivity),
      specificity = sum(w * summary$specificity)
    )
  }
  list(groups = fits, summary = summary, overall = overall)
}
