# =============================================================================
# Sturman (2001) comprehensive utility model — single integrated function
# =============================================================================

#' Sturman's (2001) comprehensive utility analysis
#'
#' Composes the six adjustments of Sturman's (2001) comprehensive model
#' (§15 of the package's accompanying review) into a single call. The
#' returned object includes both the integrated comprehensive estimate and
#' a stepwise cascade that documents the contribution of each adjustment.
#'
#' The six adjustments combined here are: (1) baseline correction
#' (Sturman, 2000, 2001), (2) restricted canonical validity for a
#' multidimensional criterion, (3) multi-period employee flows, (4)
#' Boudreau-style economic adjustments (taxes, variable costs, discount
#' rate), (5) De Corte (1994) probation-period truncation, and optionally
#' (6) Murphy's (1986) offer-rejection adjustment. See [`bcg_utility()`],
#' [`boudreau_utility()`], [`restricted_canonical_validity()`],
#' [`probation_adjustment()`], [`employee_flow()`], and
#' [`offer_rejection_adjustment()`] for the underlying components.
#'
#' @param validity Focal-system validity (used directly when `predictor_cor`
#'   is `NULL`; replaced by the restricted canonical validity otherwise).
#' @param baseline_validity Operating-system baseline validity. Default 0
#'   collapses to a random-baseline analysis, which the function will warn
#'   about.
#' @param selection_ratio Selection ratio.
#' @param sdy Standard deviation of job performance in monetary units.
#' @param n_year_one Number of hires in year 1.
#' @param tenure Horizon in years (>= 1).
#' @param fixed_cost Year-1 selection cost (currency).
#' @param hires_per_period,losses_per_period Optional vectors of length
#'   `tenure` for replacement hires and turnover losses; if `NULL` a steady
#'   state with `n_year_one` per year is used.
#' @param tax_rate,discount_rate,variable_value Boudreau parameters.
#' @param maintenance_cost_per_period Optional cost vector of length `tenure`.
#' @param predictor_cor,predictor_criterion_cor,criterion_cor,criterion_weights
#'   If supplied, the function computes the restricted canonical validity
#'   from this multidimensional criterion specification and substitutes it
#'   for `validity`.
#' @param probation_cutoff_z Standardized cutoff for the probation rule
#'   (default `NULL` skips this adjustment).
#' @param acceptance_rate,quality_acceptance_correlation Murphy's (1986)
#'   offer-rejection adjustment. If `acceptance_rate < 1`, the function
#'   adjusts the year-1 expected criterion mean and headcount accordingly.
#'
#' @return Object of class `c("psu_sturman", "psu_utility")` with
#' components: `net_utility` (final comprehensive estimate), `cascade`
#' (a data frame documenting each step), `effective_validity`,
#' `effective_baseline_validity`, and the relevant intermediate objects.
#'
#' @references
#' De Corte, W. (1994). Utility analysis for the one-cohort
#' selection-retention decision with a probationary period. *Journal of
#' Applied Psychology*, 79, 402-411.
#'
#' Murphy, K. R. (1986). When your top choice turns you down: Effect of
#' rejected offers on the utility of selection tests. *Psychological
#' Bulletin*, 99, 133-138.
#'
#' Sturman, M. C. (2000). Implications of utility analysis adjustments for
#' estimates of human resource intervention value. *Journal of Management*,
#' 26, 281-299.
#'
#' Sturman, M. C. (2001). Utility analysis for multiple selection devices
#' and multiple outcomes. *Journal of Human Resource Costing and Accounting*,
#' 6(2), 9-28.
#'
#' @examples
#' Rxx <- matrix(c(1, .30, .30, 1), 2, 2)
#' Rxy <- matrix(c(.30, .10, .15, .25), 2, 2, byrow = TRUE)
#' Ryy <- matrix(c(1, .40, .40, 1), 2, 2)
#'
#' sturman_comprehensive(
#'   validity = .35, baseline_validity = .20, selection_ratio = .20,
#'   sdy = 50000, n_year_one = 100, tenure = 5, fixed_cost = 75000,
#'   tax_rate = .25, discount_rate = .08,
#'   predictor_cor = Rxx, predictor_criterion_cor = Rxy,
#'   criterion_cor = Ryy, criterion_weights = c(.7, .3),
#'   probation_cutoff_z = -1,
#'   acceptance_rate = 0.70, quality_acceptance_correlation = -0.20
#' )
#' @export
sturman_comprehensive <- function(validity, baseline_validity = 0,
                                  selection_ratio, sdy, n_year_one,
                                  tenure = 5, fixed_cost = 0,
                                  hires_per_period = NULL,
                                  losses_per_period = NULL,
                                  tax_rate = 0, discount_rate = 0,
                                  variable_value = 0,
                                  maintenance_cost_per_period = NULL,
                                  predictor_cor = NULL,
                                  predictor_criterion_cor = NULL,
                                  criterion_cor = NULL,
                                  criterion_weights = NULL,
                                  probation_cutoff_z = NULL,
                                  acceptance_rate = 1,
                                  quality_acceptance_correlation = 0) {
  validate_probability(selection_ratio, "selection_ratio")
  validate_nonnegative(sdy, "sdy")
  if (n_year_one <= 0) stop("`n_year_one` must be > 0.", call. = FALSE)
  if (tenure < 1)      stop("`tenure` must be >= 1.", call. = FALSE)

  if (baseline_validity == 0)
    warning("baseline_validity = 0 implies a random-selection baseline; ",
            "Sturman (2000, 2001) recommends supplying the operating ",
            "baseline validity instead.", call. = FALSE)

  cascade <- data.frame(step = character(), net_utility = numeric(),
                        stringsAsFactors = FALSE)

  # --- Step 1: Naive BCG (random baseline) ---
  step1 <- bcg_utility(validity = validity, selection_ratio = selection_ratio,
                       sdy = sdy, n_selected = n_year_one, tenure = tenure,
                       cost = fixed_cost, baseline_validity = 0)
  cascade <- rbind(cascade, data.frame(
    step = "1. Naive BCG (random baseline)",
    net_utility = step1$net_utility, stringsAsFactors = FALSE))

  # --- Step 2: + operating baseline ---
  step2 <- bcg_utility(validity = validity, selection_ratio = selection_ratio,
                       sdy = sdy, n_selected = n_year_one, tenure = tenure,
                       cost = fixed_cost,
                       baseline_validity = baseline_validity)
  cascade <- rbind(cascade, data.frame(
    step = "2. + operating baseline",
    net_utility = step2$net_utility, stringsAsFactors = FALSE))

  # --- Step 3: + multidimensional criterion (RCV) ---
  effective_validity <- validity
  rcv_obj <- NULL
  if (!is.null(predictor_cor) && !is.null(predictor_criterion_cor) &&
      !is.null(criterion_cor) && !is.null(criterion_weights)) {
    rcv_obj <- restricted_canonical_validity(
      predictor_cor, predictor_criterion_cor,
      criterion_cor, criterion_weights
    )
    effective_validity <- rcv_obj$validity
  }
  step3 <- bcg_utility(validity = effective_validity,
                       selection_ratio = selection_ratio, sdy = sdy,
                       n_selected = n_year_one, tenure = tenure,
                       cost = fixed_cost,
                       baseline_validity = baseline_validity)
  cascade <- rbind(cascade, data.frame(
    step = "3. + multidim. criterion (RCV)",
    net_utility = step3$net_utility, stringsAsFactors = FALSE))

  # --- Step 4: + flows + tax + discount (Boudreau) ---
  if (is.null(hires_per_period))  hires_per_period  <- rep(n_year_one, tenure)
  if (is.null(losses_per_period)) losses_per_period <- rep(0, tenure)
  if (length(hires_per_period) != tenure ||
      length(losses_per_period) != tenure)
    stop("`hires_per_period` and `losses_per_period` must have length `tenure`.",
         call. = FALSE)
  active_n <- employee_flow(hires_per_period, losses_per_period)
  cost_vec <- if (is.null(maintenance_cost_per_period))
    c(fixed_cost, rep(0, tenure - 1)) else
    c(fixed_cost, maintenance_cost_per_period[-1])
  if (length(cost_vec) != tenure)
    cost_vec <- rep_len(cost_vec, tenure)

  step4 <- boudreau_utility(
    validity = effective_validity,
    baseline_validity = baseline_validity,
    selection_ratio = selection_ratio, sdy = sdy,
    n_by_period = active_n, variable_value = variable_value,
    tax_rate = tax_rate, discount_rate = discount_rate,
    cost_by_period = cost_vec
  )
  cascade <- rbind(cascade, data.frame(
    step = "4. + flows + tax + discount",
    net_utility = step4$net_present_value, stringsAsFactors = FALSE))

  # --- Step 5: + probation cutoff ---
  step5_value <- step4$net_present_value
  if (!is.null(probation_cutoff_z)) {
    survivor_gain <- probation_adjustment(probation_cutoff_z)
    later <- seq_along(active_n)[-1]
    benefit_t <- survivor_gain * sdy * active_n[later] * (1 - tax_rate) *
                 (1 + variable_value)
    discounted <- benefit_t / (1 + discount_rate)^later
    step5_value <- step5_value + sum(discounted)
  }
  cascade <- rbind(cascade, data.frame(
    step = "5. + probation",
    net_utility = step5_value, stringsAsFactors = FALSE))

  # --- Step 6: + offer rejection (Murphy 1986) ---
  step6_value <- step5_value
  z_loss <- 0
  if (acceptance_rate < 1) {
    z_offered <- selected_mean_z(selection_ratio)
    rej <- offer_rejection_adjustment(
      expected_z_offered = z_offered,
      mode = "correlated",
      acceptance_rate = acceptance_rate,
      rho_quality_acceptance = quality_acceptance_correlation
    )
    z_loss <- rej$effective_validity_loss
    # Compose two effects: (a) headcount shrinks by acceptance_rate, so the
    # year-1 incremental gain proportionally shrinks; (b) accepted hires have
    # lower expected criterion mean by z_loss * effective_validity * SDy.
    # Approximate composition: scale step5 by acceptance_rate, then subtract
    # the per-hire quality loss (year-1 only, conservative).
    quality_loss_y1 <- n_year_one * acceptance_rate * sdy *
                       effective_validity * z_loss * (1 - tax_rate) *
                       (1 + variable_value) / (1 + discount_rate)
    step6_value <- step5_value * acceptance_rate - quality_loss_y1
  }
  cascade <- rbind(cascade, data.frame(
    step = "6. + offer rejection",
    net_utility = step6_value, stringsAsFactors = FALSE))

  cascade$pct_of_naive <- 100 * cascade$net_utility / step1$net_utility

  out <- list(
    net_utility = step6_value,
    cascade = cascade,
    effective_validity = effective_validity,
    effective_baseline_validity = baseline_validity,
    n_active_by_period = active_n,
    rcv = rcv_obj,
    inputs = list(
      validity = validity, baseline_validity = baseline_validity,
      selection_ratio = selection_ratio, sdy = sdy,
      n_year_one = n_year_one, tenure = tenure,
      fixed_cost = fixed_cost, tax_rate = tax_rate,
      discount_rate = discount_rate, variable_value = variable_value,
      probation_cutoff_z = probation_cutoff_z,
      acceptance_rate = acceptance_rate,
      quality_acceptance_correlation = quality_acceptance_correlation
    )
  )
  class(out) <- c("psu_sturman", "psu_utility")
  out
}

#' @rdname print.psu_utility
#' @export
print.psu_sturman <- function(x, ...) {
  cat("<psu_sturman: Sturman (2001) comprehensive utility>\n")
  cat("  Comprehensive net utility:", format(signif(x$net_utility, 6)), "\n")
  cat("  Effective validity:", format(signif(x$effective_validity, 4)),
      " (baseline:", format(signif(x$effective_baseline_validity, 4)), ")\n")
  cat("\n  Cascade:\n")
  print(x$cascade, row.names = FALSE)
  invisible(x)
}
