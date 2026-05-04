#' Monte Carlo uncertainty propagation for BCG utility
#'
#' Samples validity and SDy and propagates them through the BCG model. This is a
#' simple decision-support approximation, not a full Bayesian model.
#'
#' @param n_sim Number of simulations.
#' @param validity_mean Mean validity.
#' @param validity_se Standard error of validity.
#' @param sdy_mean Mean SDy.
#' @param sdy_sd Standard deviation of SDy uncertainty.
#' @param selection_ratio Selection ratio.
#' @param n_selected Number selected.
#' @param tenure Expected tenure.
#' @param cost Cost.
#' @param baseline_validity Baseline validity.
#' @param seed Optional random seed.
#' @return A `psu_monte_carlo` object with draws and quantiles.
#' @references
#'
#' Alexander, R. A., & Barrick, M. R. (1987). Estimating the standard error of
#'   projected dollar gains in utility analysis. Journal of Applied Psychology,
#'   72, 475-479.
#'
#' Rich, J. R., & Boudreau, J. W. (1987). The effects of variability and risk
#'   on selection utility analysis. Personnel Psychology, 40, 55-84.
#'
#' Ock, J., & Oswald, F. L. (2018). The utility of personnel selection
#'   decisions: Comparing compensatory and multiple-hurdle selection models.
#'   Journal of Personnel Psychology, 17(4), 172-182.
#' @export
#' @examples
#' # Literature: Alexander and Barrick (1987); Rich and Boudreau (1987); Ock and Oswald (2018).
#' # Use the first call as a minimal example; the longer block illustrates
#' # how to interpret the function in the substantive setting discussed in the literature.
#' # Minimal example (Alexander and Barrick (1987); Rich and Boudreau (1987); Ock and Oswald (2018)).
#' utility_monte_carlo(n_sim = 1000, validity_mean = .35, validity_se = .05,
#'                     sdy_mean = 50000, sdy_sd = 10000, selection_ratio = .20,
#'                     n_selected = 100, tenure = 3, cost = 75000, seed = 1)
#'
#' # Substantive example (Alexander and Barrick, 1987;
#' # Rich and Boudreau, 1987; Ock and Oswald, 2018).
#' # Quantify the probability that net utility is positive.
#' mc <- utility_monte_carlo(n_sim = 2000, validity_mean = .30, validity_se = .06,
#'                           sdy_mean = 50000, sdy_sd = 15000,
#'                           selection_ratio = .20, n_selected = 100,
#'                           tenure = 3, cost = 75000,
#'                           baseline_validity = .15, seed = 123)
#' mc$probability_positive
utility_monte_carlo <- function(n_sim = 10000, validity_mean, validity_se,
                                sdy_mean, sdy_sd, selection_ratio, n_selected,
                                tenure, cost = 0, baseline_validity = 0,
                                seed = NULL) {
  validate_nonnegative(n_sim, "n_sim")
  if (!is.null(seed)) set.seed(seed)
  validity <- pmax(pmin(stats::rnorm(n_sim, validity_mean, validity_se), .999), -.999)
  sdy <- pmax(stats::rnorm(n_sim, sdy_mean, sdy_sd), 0)
  zbar <- selected_mean_z(selection_ratio)
  net <- n_selected * tenure * sdy * ((validity - baseline_validity) * zbar) - cost
  qs <- stats::quantile(net, probs = c(.025, .05, .25, .50, .75, .95, .975), na.rm = TRUE)
  out <- list(
    model = "Monte Carlo BCG uncertainty propagation",
    n_sim = n_sim,
    mean_net_utility = mean(net),
    median_net_utility = unname(qs["50%"]),
    probability_positive = mean(net > 0),
    quantiles = qs,
    draws = data.frame(validity = validity, sdy = sdy, net_utility = net)
  )
  as_psu(out, "psu_monte_carlo")
}

#' Sensitivity grid for BCG utility
#'
#' Computes BCG net utility for all combinations of selected parameter values.
#'
#' @param validity Numeric vector of validities.
#' @param selection_ratio Numeric vector of selection ratios.
#' @param sdy Numeric vector of SDy values.
#' @param n_selected Number selected.
#' @param tenure Expected tenure.
#' @param cost Cost.
#' @return A data frame with one row per scenario.
#' @references
#'
#' Cronshaw, S. F., Alexander, R. A., Wiesner, W. H., & Barrick, M. R. (1987).
#'   Incorporating risk into selection utility. Organizational Behavior and Human
#'   Decision Processes, 40, 270-286.
#'
#' Ock, J., & Oswald, F. L. (2018). The utility of personnel selection
#'   decisions: Comparing compensatory and multiple-hurdle selection models.
#'   Journal of Personnel Psychology, 17(4), 172-182.
#'
#' Boudreau, J. W. (1991). Utility analysis for decisions in human resource
#'   management. In M. D. Dunnette & L. M. Hough (Eds.), Handbook of industrial
#'   and organizational psychology (Vol. 2, pp. 621-745). Consulting
#'   Psychologists Press.
#' @export
#' @examples
#' # Literature: Cronshaw et al. (1987); Boudreau (1991); Ock and Oswald (2018).
#' # Use the first call as a minimal example; the longer block illustrates
#' # how to interpret the function in the substantive setting discussed in the literature.
#' # Minimal example (Cronshaw et al. (1987); Boudreau (1991); Ock and Oswald (2018)).
#' sensitivity_grid(validity = c(.20, .30), selection_ratio = c(.10, .20),
#'                  sdy = c(40000, 60000), n_selected = 100, tenure = 3)
#'
#' # Substantive example (Cronshaw et al., 1987; Boudreau, 1991;
#' # Ock and Oswald, 2018). Find the best sensitivity scenario.
#' grid <- sensitivity_grid(validity = seq(.20, .40, .10),
#'                          selection_ratio = c(.10, .20, .40),
#'                          sdy = c(30000, 60000),
#'                          n_selected = 100, tenure = 3, cost = 75000)
#' grid[which.max(grid$net_utility), ]
sensitivity_grid <- function(validity, selection_ratio, sdy, n_selected, tenure, cost = 0) {
  grid <- expand.grid(validity = validity, selection_ratio = selection_ratio, sdy = sdy)
  grid$selected_mean_z <- selected_mean_z(grid$selection_ratio)
  grid$net_utility <- n_selected * tenure * grid$validity * grid$sdy * grid$selected_mean_z - cost
  grid
}

#' Break-even validity for BCG utility
#'
#' Solves the validity needed to obtain zero net utility under the BCG model.
#'
#' @param selection_ratio Selection ratio.
#' @param sdy SDy.
#' @param n_selected Number selected.
#' @param tenure Expected tenure.
#' @param cost Cost.
#' @param baseline_validity Baseline validity.
#' @return Required focal validity.
#' @references
#'
#' Boudreau, J. W. (1991). Utility analysis for decisions in human resource
#'   management. In M. D. Dunnette & L. M. Hough (Eds.), Handbook of industrial
#'   and organizational psychology (Vol. 2, pp. 621-745). Consulting
#'   Psychologists Press.
#'
#' Holling, H. (1998). Utility analysis of personnel selection: An overview and
#'   empirical study based on objective performance measures. Methods of
#'   Psychological Research Online, 3(1), 5-24.
#' @export
#' @examples
#' # Literature: Boudreau (1991); Holling (1998).
#' # Use the first call as a minimal example; the longer block illustrates
#' # how to interpret the function in the substantive setting discussed in the literature.
#' # Minimal example (Boudreau (1991); Holling (1998)).
#' break_even_validity(.20, 50000, 100, 3, cost = 75000)
#'
#' # Substantive example (Boudreau, 1991; Holling, 1998).
#' # Required incremental validity under different costs.
#' costs <- c(25000, 75000, 150000)
#' setNames(
#'   break_even_validity(.20, 50000, 100, 3, cost = costs, baseline_validity = .15),
#'   paste0('cost_', costs)
#' )
break_even_validity <- function(selection_ratio, sdy, n_selected, tenure,
                                cost = 0, baseline_validity = 0) {
  validate_probability(selection_ratio, "selection_ratio")
  validate_nonnegative(sdy, "sdy")
  validate_nonnegative(n_selected, "n_selected")
  validate_nonnegative(tenure, "tenure")
  validate_nonnegative(cost, "cost")
  validate_correlation(baseline_validity, "baseline_validity")
  baseline_validity + cost / (n_selected * tenure * sdy * selected_mean_z(selection_ratio))
}
