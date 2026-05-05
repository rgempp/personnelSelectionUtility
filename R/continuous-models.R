#' Naylor-Shine expected criterion gain
#'
#' Computes expected standardized criterion gain among selected applicants and,
#' optionally, converts it to utility using `sdy`, `n_selected`, `tenure`, and
#' `cost`. The expected standardized criterion gain is `validity * selected_mean_z(selection_ratio)`.
#'
#' @param validity Predictor-criterion validity, usually denoted `r_xy`.
#' @param selection_ratio Selection ratio, usually denoted `SR`.
#' @param sdy Standard deviation of job performance in monetary or criterion units.
#' @param n_selected Number of selected applicants.
#' @param tenure Expected tenure or number of periods.
#' @param cost Total cost.
#' @return A `psu_ns` object.
#' @references
#'
#' Naylor, J. C., & Shine, L. C. (1965). A table for determining the increase
#'   in mean criterion score obtained by using a selection device. Journal of
#'   Industrial Psychology, 3, 33-42.
#' @export
#' @examples
#' # Literature: Naylor and Shine (1965).
#' # Use the first call as a minimal example; the longer block illustrates
#' # how to interpret the function in the substantive setting discussed in the literature.
#' # Minimal example: standardized criterion gain only.
#' naylor_shine(validity = .35, selection_ratio = .20)
#'
#' # Substantive example (Naylor and Shine (1965)): standardized gain translated to monetary utility.
#' naylor_shine(
#'   validity = .35,
#'   selection_ratio = .20,
#'   sdy = 50000,
#'   n_selected = 100,
#'   tenure = 3,
#'   cost = 75000
#' )
naylor_shine <- function(validity, selection_ratio, sdy = 1, n_selected = 1,
                         tenure = 1, cost = 0) {
  validate_correlation(validity, "validity")
  validate_probability(selection_ratio, "selection_ratio")
  validate_nonnegative(sdy, "sdy")
  validate_nonnegative(n_selected, "n_selected")
  validate_nonnegative(tenure, "tenure")
  validate_nonnegative(cost, "cost")
  zbar_x <- selected_mean_z(selection_ratio)
  zbar_y <- validity * zbar_x
  gross <- n_selected * tenure * sdy * zbar_y
  out <- list(
    model = "Naylor-Shine",
    validity = validity,
    selection_ratio = selection_ratio,
    selected_mean_z = zbar_x,
    expected_criterion_z = zbar_y,
    sdy = sdy,
    n_selected = n_selected,
    tenure = tenure,
    cost = cost,
    gross_utility = gross,
    net_utility = gross - cost
  )
  as_psu(out, "psu_ns")
}

#' Brogden-Cronbach-Gleser utility
#'
#' Computes classical Brogden-Cronbach-Gleser utility. By default the baseline is
#' random selection (`baseline_validity = 0`), but an operating baseline can be
#' supplied using `baseline_validity` and, optionally, `baseline_selection_ratio`.
#'
#' @param validity Validity of the focal selection system, usually denoted `r_xy`.
#' @param selection_ratio Selection ratio of the focal system.
#' @param sdy Standard deviation of job performance in monetary units, `SD_y`.
#' @param n_selected Number of selected applicants, `N_s`.
#' @param tenure Expected tenure or number of periods, `T`.
#' @param cost Total cost of the focal system net of baseline costs, if relevant.
#' @param baseline_validity Validity of the baseline system. Defaults to `0`.
#' @param baseline_selection_ratio Selection ratio of the baseline system. If `NULL`,
#'   it is assumed to equal `selection_ratio`.
#' @return A `psu_bcg` object.
#' @references
#'
#' Cronbach, L. J., & Gleser, G. C. (1965). Psychological tests and personnel
#'   decisions (2nd ed.). University of Illinois Press.
#'
#' Brogden, H. E. (1946). On the interpretation of the correlation coefficient
#'   as a measure of predictive efficiency. Journal of Educational Psychology,
#'   37, 65-76.
#'
#' Brogden, H. E. (1949). When testing pays off. Personnel Psychology, 2,
#'   171-183.
#'
#' Sturman, M. C. (2001). Utility analysis for multiple selection devices and
#'   multiple outcomes. Journal of Human Resource Costing and Accounting, 6(2),
#'   9-28.
#' @export
#' @examples
#' # Literature: Brogden (1946, 1949); Cronbach and Gleser (1965); Sturman (2001).
#' # Use the first call as a minimal example; the longer block illustrates
#' # how to interpret the function in the substantive setting discussed in the literature.
#' # Minimal example (Brogden (1946, 1949); Cronbach and Gleser (1965); Sturman (2001)).
#' bcg_utility(validity = .35, selection_ratio = .20, sdy = 50000,
#'             n_selected = 100, tenure = 3, cost = 75000)
#'
#' # Substantive example (Brogden, 1946, 1949;
#' # Cronbach and Gleser, 1965; Sturman, 2001).
#' # Use an operating baseline rather than random selection.
#' naive <- bcg_utility(.35, .20, 50000, n_selected = 100, tenure = 3, cost = 75000)
#' incremental <- bcg_utility(.35, .20, 50000, n_selected = 100, tenure = 3,
#'                            cost = 75000, baseline_validity = .20)
#' c(naive = naive$net_utility, incremental = incremental$net_utility)
bcg_utility <- function(validity, selection_ratio, sdy, n_selected, tenure,
                        cost = 0, baseline_validity = 0,
                        baseline_selection_ratio = NULL) {
  validate_correlation(validity, "validity")
  validate_probability(selection_ratio, "selection_ratio")
  validate_nonnegative(sdy, "sdy")
  validate_nonnegative(n_selected, "n_selected")
  validate_nonnegative(tenure, "tenure")
  validate_nonnegative(cost, "cost")
  validate_correlation(baseline_validity, "baseline_validity")
  if (is.null(baseline_selection_ratio)) baseline_selection_ratio <- selection_ratio
  validate_probability(baseline_selection_ratio, "baseline_selection_ratio")
  focal_gain_z <- validity * selected_mean_z(selection_ratio)
  baseline_gain_z <- baseline_validity * selected_mean_z(baseline_selection_ratio)
  incremental_gain_z <- focal_gain_z - baseline_gain_z
  gross <- n_selected * tenure * sdy * incremental_gain_z
  out <- list(
    model = "Brogden-Cronbach-Gleser",
    validity = validity,
    selection_ratio = selection_ratio,
    baseline_validity = baseline_validity,
    baseline_selection_ratio = baseline_selection_ratio,
    selected_mean_z = selected_mean_z(selection_ratio),
    baseline_selected_mean_z = selected_mean_z(baseline_selection_ratio),
    focal_expected_criterion_z = focal_gain_z,
    baseline_expected_criterion_z = baseline_gain_z,
    incremental_criterion_z = incremental_gain_z,
    sdy = sdy,
    n_selected = n_selected,
    tenure = tenure,
    cost = cost,
    gross_utility = gross,
    net_utility = gross - cost
  )
  as_psu(out, "psu_bcg")
}

#' Schmidt-Hunter-Pearlman intervention utility
#'
#' Computes utility from an intervention effect size rather than from a selection
#' validity coefficient. This is appropriate for training or intervention designs
#' where the key input is a standardized mean difference.
#'
#' @param effect_size_d Standardized mean difference caused by the intervention.
#' @param sdy Standard deviation of job performance in monetary units.
#' @param n_treated Number of employees receiving the intervention.
#' @param tenure Expected duration of the effect in periods.
#' @param cost Total intervention cost.
#' @return A `psu_shp` object.
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
#' # Literature: Schmidt, Hunter, and Pearlman (1982); Cohen (1988).
#' # Use the first call as a minimal example; the longer block illustrates
#' # how to interpret the function in the substantive setting discussed in the literature.
#' # Minimal example (Schmidt, Hunter, and Pearlman (1982); Cohen (1988)).
#' shp_utility(effect_size_d = .30, sdy = 50000, n_treated = 100,
#'             tenure = 2, cost = 40000)
#'
#' # Substantive example (Schmidt, Hunter, and Pearlman, 1982;
#' # Cohen, 1988). Compare two training designs.
#' short_training <- shp_utility(.20, 50000, n_treated = 120, tenure = 1, cost = 30000)
#' intensive_training <- shp_utility(.35, 50000, n_treated = 120, tenure = 1,
#'                                   cost = 95000)
#' c(short = short_training$net_utility, intensive = intensive_training$net_utility)
shp_utility <- function(effect_size_d, sdy, n_treated, tenure, cost = 0) {
  if (!is.numeric(effect_size_d) || any(!is.finite(effect_size_d))) {
    stop("`effect_size_d` must be numeric and finite.", call. = FALSE)
  }
  validate_nonnegative(sdy, "sdy")
  validate_nonnegative(n_treated, "n_treated")
  validate_nonnegative(tenure, "tenure")
  validate_nonnegative(cost, "cost")
  gross <- n_treated * tenure * effect_size_d * sdy
  out <- list(
    model = "Schmidt-Hunter-Pearlman",
    effect_size_d = effect_size_d,
    approximate_r = d_to_cor(effect_size_d),
    sdy = sdy,
    n_treated = n_treated,
    tenure = tenure,
    cost = cost,
    gross_utility = gross,
    net_utility = gross - cost
  )
  as_psu(out, "psu_shp")
}

#' Boudreau-style discounted utility
#'
#' Computes discounted multi-period utility with optional value, tax, and cost
#' adjustments. The expected standardized criterion gain can be supplied directly
#' as `delta_z_y`, or computed from validity and selection-ratio parameters.
#'
#' @param delta_z_y Expected incremental standardized criterion gain. If `NULL`,
#'   it is computed from `validity`, `selection_ratio`, `baseline_validity`, and
#'   `baseline_selection_ratio`.
#' @param validity Focal validity, used when `delta_z_y` is `NULL`.
#' @param selection_ratio Focal selection ratio, used when `delta_z_y` is `NULL`.
#' @param baseline_validity Baseline validity. Defaults to zero.
#' @param baseline_selection_ratio Baseline selection ratio. Defaults to `selection_ratio`.
#' @param sdy Standard deviation of job performance in monetary units.
#' @param n_by_period Vector of selected/retained employees in each period. This is
#'   the preferred v0.4.0 name for the literature's `N_t`.
#' @param variable_value Boudreau-style multiplier `V`. By default the multiplier
#'   is `(1 + variable_value)`, matching the printed Boudreau-style notation. Set
#'   `variable_value_convention = "cost_rate"` to use `(1 - variable_value)`, or
#'   pass `contribution_margin` directly when the margin is known.
#' @param contribution_margin Optional contribution-margin multiplier. Overrides
#'   `variable_value` when supplied.
#' @param variable_value_convention Either `"paper_plus"` for `(1 + V)` or
#'   `"cost_rate"` for `(1 - V)`.
#' @param tax_rate Tax rate.
#' @param discount_rate Discount rate.
#' @param cost_by_period Cost in each period. Scalar or vector matching `n_by_period`.
#' @param discount_costs Should costs be discounted by period? Defaults to `TRUE`.
#' @param n_t Legacy alias for `n_by_period`. Use `n_by_period` in new code.
#' @param cost_t Legacy alias for `cost_by_period`. Use `cost_by_period` in new code.
#' @return A `psu_boudreau` object.
#' @references
#'
#' Boudreau, J. W. (1983). Economic considerations in estimating the utility of
#'   human resource productivity improvement programs. Personnel Psychology, 36,
#'   551-576.
#'
#' Boudreau, J. W. (1991). Utility analysis for decisions in human resource
#'   management. In M. D. Dunnette & L. M. Hough (Eds.), Handbook of industrial
#'   and organizational psychology (Vol. 2, pp. 621-745). Consulting
#'   Psychologists Press.
#'
#' Sturman, M. C. (2001). Utility analysis for multiple selection devices and
#'   multiple outcomes. Journal of Human Resource Costing and Accounting, 6(2),
#'   9-28.
#'
#' Holling, H. (1998). Utility analysis of personnel selection: An overview and
#'   empirical study based on objective performance measures. Methods of
#'   Psychological Research Online, 3(1), 5-24.
#' @export
#' @examples
#' # Literature: Boudreau (1983, 1991); Sturman (2001); Holling (1998).
#' # Use the first call as a minimal example; the longer block illustrates
#' # how to interpret the function in the substantive setting discussed in the literature.
#' # Minimal example (Boudreau (1983, 1991); Sturman (2001); Holling (1998)).
#' boudreau_utility(validity = .35, selection_ratio = .20, sdy = 50000,
#'                  n_by_period = c(100, 90, 80), discount_rate = .08,
#'                  cost_by_period = c(75000, 10000, 10000))
#'
#' # Substantive example (Boudreau, 1983, 1991;
#' # Sturman, 2001; Holling, 1998).
#' # Use an explicit contribution margin and operating baseline.
#' boudreau_utility(
#'   validity = .35,
#'   baseline_validity = .20,
#'   selection_ratio = .20,
#'   sdy = 50000,
#'   n_by_period = c(100, 90, 80, 70),
#'   contribution_margin = .30,
#'   tax_rate = .25,
#'   discount_rate = .08,
#'   cost_by_period = c(75000, 10000, 10000, 10000)
#' )
boudreau_utility <- function(delta_z_y = NULL, validity = NULL, selection_ratio = NULL,
                             baseline_validity = 0, baseline_selection_ratio = NULL,
                             sdy, n_by_period = NULL, variable_value = 0,
                             contribution_margin = NULL,
                             variable_value_convention = c("paper_plus", "cost_rate"),
                             tax_rate = 0, discount_rate = 0, cost_by_period = NULL,
                             discount_costs = TRUE, n_t = NULL, cost_t = NULL) {
  # Resolve legacy aliases symmetrically: error when both supplied disagree,
  # otherwise the modern argument wins.
  n_by_period <- resolve_legacy_alias(n_by_period, n_t,
                                      "n_by_period", "n_t")
  if (is.null(n_by_period)) stop("Supply `n_by_period`.", call. = FALSE)
  cost_by_period <- resolve_legacy_alias(cost_by_period, cost_t,
                                         "cost_by_period", "cost_t",
                                         modern_default = 0)
  validate_nonnegative(sdy, "sdy")
  validate_nonnegative(n_by_period, "n_by_period")
  variable_value_convention <- match.arg(variable_value_convention)
  if (!is.null(contribution_margin)) {
    if (!is.numeric(contribution_margin) || any(!is.finite(contribution_margin))) {
      stop("`contribution_margin` must be numeric and finite.", call. = FALSE)
    }
  } else {
    if (!is.numeric(variable_value) || any(!is.finite(variable_value))) {
      stop("`variable_value` must be numeric and finite.", call. = FALSE)
    }
  }
  validate_probability(tax_rate, "tax_rate", allow_zero = TRUE)
  validate_nonnegative(discount_rate, "discount_rate")
  if (is.null(delta_z_y)) {
    if (is.null(validity) || is.null(selection_ratio)) {
      stop("Supply either `delta_z_y` or both `validity` and `selection_ratio`.", call. = FALSE)
    }
    validate_correlation(validity, "validity")
    validate_probability(selection_ratio, "selection_ratio")
    validate_correlation(baseline_validity, "baseline_validity")
    if (is.null(baseline_selection_ratio)) baseline_selection_ratio <- selection_ratio
    validate_probability(baseline_selection_ratio, "baseline_selection_ratio")
    delta_z_y <- validity * selected_mean_z(selection_ratio) -
      baseline_validity * selected_mean_z(baseline_selection_ratio)
  }
  if (!is.numeric(delta_z_y) || length(delta_z_y) != 1L || !is.finite(delta_z_y)) {
    stop("`delta_z_y` must be a finite scalar.", call. = FALSE)
  }
  periods <- seq_along(n_by_period)
  cost_by_period <- recycle_to_length(cost_by_period, length(n_by_period), "cost_by_period")
  validate_nonnegative(cost_by_period, "cost_by_period")
  margin <- contribution_multiplier(variable_value, contribution_margin, variable_value_convention)
  adjustment <- margin * (1 - tax_rate)
  benefit_t <- n_by_period * delta_z_y * sdy * adjustment
  discount_factor <- (1 + discount_rate)^periods
  discounted_benefit_t <- benefit_t / discount_factor
  discounted_cost_t <- if (discount_costs) cost_by_period / discount_factor else cost_by_period
  net_t <- discounted_benefit_t - discounted_cost_t
  out <- list(
    model = "Boudreau discounted utility",
    delta_z_y = delta_z_y,
    sdy = sdy,
    n_by_period = n_by_period,
    n_t = n_by_period,
    variable_value = variable_value,
    contribution_margin = contribution_margin,
    variable_value_convention = variable_value_convention,
    effective_margin = margin,
    tax_rate = tax_rate,
    discount_rate = discount_rate,
    cost_by_period = cost_by_period,
    cost_t = cost_by_period,
    benefit_t = benefit_t,
    discounted_benefit_t = discounted_benefit_t,
    discounted_cost_t = discounted_cost_t,
    net_t = net_t,
    net_present_value = sum(net_t)
  )
  as_psu(out, "psu_boudreau")
}

#' Compute employee flows across periods
#'
#' Computes retained headcount after hires and losses: `N_t = initial + cumsum(hired - lost)`.
#'
#' @param hired Number hired in each period.
#' @param lost Number lost in each period.
#' @param initial Initial headcount.
#' @return Numeric vector of headcount by period.
#' @references
#'
#' Boudreau, J. W., & Berger, C. J. (1985). Decision-theoretic utility analysis
#'   applied to employee separations and acquisitions. Journal of Applied
#'   Psychology, 70, 581-612.
#'
#' Boudreau, J. W. (1991). Utility analysis for decisions in human resource
#'   management. In M. D. Dunnette & L. M. Hough (Eds.), Handbook of industrial
#'   and organizational psychology (Vol. 2, pp. 621-745). Consulting
#'   Psychologists Press.
#' @export
#' @examples
#' # Literature: Boudreau and Berger (1985); Boudreau (1991).
#' employee_flow(hired = c(100, 20, 20), lost = c(0, 30, 25))
employee_flow <- function(hired, lost, initial = 0) {
  validate_nonnegative(hired, "hired")
  validate_nonnegative(lost, "lost")
  validate_nonnegative(initial, "initial")
  if (length(hired) != length(lost)) stop("`hired` and `lost` must have the same length.", call. = FALSE)
  initial + cumsum(hired - lost)
}

#' Expected standardized performance after a probation cutoff
#'
#' Computes the mean of a standard normal criterion among employees surviving a
#' probation rule `Y >= probation_cutoff_z`.
#'
#' @param probation_cutoff_z Probation cutoff on the standardized criterion.
#' @return Expected standardized criterion score among survivors.
#' @references
#'
#' De Corte, W. (1994). Utility analysis for the one-cohort selection-retention
#'   decision with a probationary period. Journal of Applied Psychology, 79,
#'   402-411.
#'
#' Sturman, M. C. (2001). Utility analysis for multiple selection devices and
#'   multiple outcomes. Journal of Human Resource Costing and Accounting, 6(2),
#'   9-28.
#' @export
#' @examples
#' # Literature: De Corte (1994); Sturman (2001).
#' probation_adjustment(-1)
probation_adjustment <- function(probation_cutoff_z) {
  if (!is.numeric(probation_cutoff_z) || any(!is.finite(probation_cutoff_z))) {
    stop("`probation_cutoff_z` must be numeric and finite.", call. = FALSE)
  }
  stats::dnorm(probation_cutoff_z) / (1 - stats::pnorm(probation_cutoff_z))
}

#' Utility with a probation-period survivor adjustment
#'
#' A compact helper for selection systems where year 1 utility follows BCG and
#' later periods include an additional survivor-performance gain caused by a
#' probation cutoff.
#'
#' @param validity Predictor-criterion validity.
#' @param selection_ratio Selection ratio.
#' @param sdy Standard deviation of job performance in monetary units.
#' @param n_selected Number of selected applicants in period 1.
#' @param tenure Total number of periods.
#' @param probation_cutoff_z Standardized criterion cutoff used after probation.
#' @param cost Total cost.
#' @return A `psu_bcg` object.
#' @references
#'
#' De Corte, W. (1994). Utility analysis for the one-cohort selection-retention
#'   decision with a probationary period. Journal of Applied Psychology, 79,
#'   402-411.
#'
#' Sturman, M. C. (2001). Utility analysis for multiple selection devices and
#'   multiple outcomes. Journal of Human Resource Costing and Accounting, 6(2),
#'   9-28.
#' @export
#' @examples
#' # Literature: De Corte (1994); Sturman (2001).
#' probation_utility(.35, .20, 50000, 100, tenure = 3, probation_cutoff_z = -1)
probation_utility <- function(validity, selection_ratio, sdy, n_selected, tenure,
                              probation_cutoff_z, cost = 0) {
  validate_nonnegative(tenure, "tenure")
  base <- bcg_utility(validity, selection_ratio, sdy, n_selected, tenure = 1, cost = 0)
  survivor_gain_z <- probation_adjustment(probation_cutoff_z)
  later_periods <- max(tenure - 1, 0)
  gross <- base$gross_utility + n_selected * later_periods * sdy * survivor_gain_z
  out <- base
  out$model <- "BCG with probation-period survivor adjustment"
  out$tenure <- tenure
  out$probation_cutoff_z <- probation_cutoff_z
  out$survivor_expected_criterion_z <- survivor_gain_z
  out$gross_utility <- gross
  out$cost <- cost
  out$net_utility <- gross - cost
  as_psu(out, "psu_bcg")
}
