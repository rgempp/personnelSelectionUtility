make_mvn <- function(n, R) {
  validate_correlation_matrix(R, "R")
  if (!is.numeric(n) || length(n) != 1L || !is.finite(n) || n <= 0) {
    stop("`n` must be a positive scalar.", call. = FALSE)
  }
  z <- matrix(stats::rnorm(n * nrow(R)), nrow = n)
  L <- chol(R + diag(1e-10, nrow(R)))
  z %*% L
}

weighted_composite <- function(X, weights) {
  X <- as.matrix(X)
  weights <- as.numeric(weights)
  if (ncol(X) != length(weights)) stop("`weights` must match the number of columns in `X`.", call. = FALSE)
  raw <- as.vector(X %*% weights)
  as.vector(scale(raw))
}

resolve_n_applicants <- function(n_applicants, applicant_n = NULL) {
  if (!is.null(applicant_n)) {
    if (!missing(n_applicants) && !identical(n_applicants, NA_real_) && !isTRUE(all.equal(n_applicants, applicant_n))) {
      stop("Use only one of `n_applicants` or legacy alias `applicant_n`.", call. = FALSE)
    }
    n_applicants <- applicant_n
  }
  n_applicants
}

#' Selection utility from expected standardized criterion performance
#'
#' Computes the Ock-Oswald/BCG-style utility expression
#' `expected_criterion_z * sdy * n_selected - n_applicants * cost_per_applicant - fixed_cost`
#' from an expected standardized criterion score among selected applicants.
#'
#' @param expected_criterion_z Expected criterion performance in standard deviation units.
#' @param sdy Monetary value of one criterion standard deviation.
#' @param n_selected Number of selected applicants.
#' @param n_applicants Number of applicants assessed. This is the preferred name
#'   in v0.4.0.
#' @param cost_per_applicant Cost per applicant assessed.
#' @param fixed_cost Additional fixed cost.
#' @param applicant_n Legacy alias for `n_applicants`. Use `n_applicants` in new code.
#' @return A `psu_comparison` object.
#' @references
#'
#' Cronbach, L. J., & Gleser, G. C. (1965). Psychological tests and personnel
#'   decisions (2nd ed.). University of Illinois Press.
#'
#' Naylor, J. C., & Shine, L. C. (1965). A table for determining the increase
#'   in mean criterion score obtained by using a selection device. Journal of
#'   Industrial Psychology, 3, 33-42.
#'
#' Brogden, H. E. (1946). On the interpretation of the correlation coefficient
#'   as a measure of predictive efficiency. Journal of Educational Psychology,
#'   37, 65-76.
#' @export
#' @examples
#' # Literature: Naylor and Shine (1965); Brogden (1946); Cronbach and Gleser (1965).
#' # Minimal example: expected performance converted to monetary utility.
#' selection_utility_from_z(1.25, sdy = 50000, n_selected = 20,
#'                          n_applicants = 100, cost_per_applicant = 200)
#'
#' # Substantive example: compare two systems from expected criterion gains.
#' compensatory <- selection_utility_from_z(1.25, 50000, n_selected = 20,
#'                                          n_applicants = 100,
#'                                          cost_per_applicant = 1000)
#' hurdle <- selection_utility_from_z(.55, 50000, n_selected = 20,
#'                                    n_applicants = 100,
#'                                    cost_per_applicant = 300)
#' compensatory$net_utility - hurdle$net_utility
selection_utility_from_z <- function(expected_criterion_z, sdy, n_selected,
                                     n_applicants = n_selected, cost_per_applicant = 0,
                                     fixed_cost = 0, applicant_n = NULL) {
  n_applicants <- resolve_n_applicants(n_applicants, applicant_n)
  if (!is.numeric(expected_criterion_z) || any(!is.finite(expected_criterion_z))) {
    stop("`expected_criterion_z` must be numeric and finite.", call. = FALSE)
  }
  validate_nonnegative(sdy, "sdy")
  validate_nonnegative(n_selected, "n_selected")
  validate_nonnegative(n_applicants, "n_applicants")
  validate_nonnegative(cost_per_applicant, "cost_per_applicant")
  validate_nonnegative(fixed_cost, "fixed_cost")
  gross <- expected_criterion_z * sdy * n_selected
  cost <- n_applicants * cost_per_applicant + fixed_cost
  out <- list(
    model = "Utility from expected criterion z",
    expected_criterion_z = expected_criterion_z,
    sdy = sdy,
    n_selected = n_selected,
    n_applicants = n_applicants,
    applicant_n = n_applicants,
    cost_per_applicant = cost_per_applicant,
    fixed_cost = fixed_cost,
    gross_utility = gross,
    total_cost = cost,
    net_utility = gross - cost
  )
  as_psu(out, "psu_comparison")
}

#' Expected performance under compensatory top-down selection
#'
#' Computes the expected standardized criterion performance of applicants selected
#' on a weighted predictor composite. This is the compensatory cell of the package
#' taxonomy: scores on stronger predictors can offset lower scores on weaker ones.
#'
#' @param predictor_cor Predictor intercorrelation matrix, denoted `R_XX`.
#' @param validities Vector of predictor-criterion correlations, denoted `r_xi,y`.
#' @param weights Composite weights. Defaults to validity weights.
#' @param selection_ratio Overall selection ratio for top-down selection on the composite.
#' @param n_applicants Number of applicants, used for cost calculations. Preferred
#'   name in v0.4.0.
#' @param cost_per_applicant Cost per assessed applicant.
#' @param sdy Optional monetary value of one criterion standard deviation.
#' @param applicant_n Legacy alias for `n_applicants`.
#' @return A `psu_comparison` object.
#' @references
#'
#' Naylor, J. C., & Shine, L. C. (1965). A table for determining the increase
#'   in mean criterion score obtained by using a selection device. Journal of
#'   Industrial Psychology, 3, 33-42.
#'
#' Ock, J., & Oswald, F. L. (2018). The utility of personnel selection
#'   decisions: Comparing compensatory and multiple-hurdle selection models.
#'   Journal of Personnel Psychology, 17(4), 172-182.
#' @export
#' @examples
#' # Literature: Naylor and Shine (1965); Ock and Oswald (2018).
#' # Use the first call as a minimal example; the longer block illustrates
#' # how to interpret the function in the substantive setting discussed in the literature.
#' # Minimal example (Naylor and Shine (1965); Ock and Oswald (2018)).
#' Rxx <- matrix(c(1, .30, .30, 1), 2, 2)
#' compensatory_selection(Rxx, validities = c(.40, .30), selection_ratio = .20)
#'
#' # Substantive example with costs and SDy.
#' Rxx <- matrix(c(
#'   1.00, .30, .20,
#'   .30, 1.00, .25,
#'   .20, .25, 1.00
#' ), 3, 3, byrow = TRUE)
#' compensatory_selection(
#'   predictor_cor = Rxx,
#'   validities = c(.45, .35, .25),
#'   weights = c(1, 1, 1),
#'   selection_ratio = .20,
#'   n_applicants = 500,
#'   cost_per_applicant = 250,
#'   sdy = 60000
#' )
compensatory_selection <- function(predictor_cor, validities, weights = NULL,
                                   selection_ratio, n_applicants = NA_real_,
                                   cost_per_applicant = 0, sdy = NULL,
                                   applicant_n = NULL) {
  n_applicants <- resolve_n_applicants(n_applicants, applicant_n)
  validate_correlation_matrix(predictor_cor, "predictor_cor")
  validate_correlation(validities, "validities")
  validate_probability(selection_ratio, "selection_ratio")
  k <- nrow(predictor_cor)
  if (length(validities) != k) stop("`validities` must match the number of predictors.", call. = FALSE)
  if (is.null(weights)) weights <- validities
  if (length(weights) != k || any(!is.finite(weights))) stop("`weights` must be finite and match predictors.", call. = FALSE)
  comp_sd <- sqrt(as.numeric(t(weights) %*% predictor_cor %*% weights))
  if (comp_sd <= 0) stop("The weighted composite has non-positive variance.", call. = FALSE)
  composite_validity <- as.numeric(t(weights) %*% validities) / comp_sd
  expected_z <- composite_validity * selected_mean_z(selection_ratio)
  total_cost <- if (is.na(n_applicants)) NA_real_ else n_applicants * cost_per_applicant
  n_selected <- if (is.na(n_applicants)) NA_real_ else n_applicants * selection_ratio
  net_utility <- if (is.null(sdy) || is.na(n_applicants)) NA_real_ else expected_z * sdy * n_selected - total_cost
  out <- list(
    model = "Compensatory top-down selection",
    composite_validity = composite_validity,
    selection_ratio = selection_ratio,
    selected_mean_z = selected_mean_z(selection_ratio),
    expected_criterion_z = expected_z,
    n_applicants = n_applicants,
    applicant_n = n_applicants,
    n_selected = n_selected,
    cost_per_applicant = cost_per_applicant,
    total_cost = total_cost,
    sdy = sdy,
    net_utility = net_utility,
    weights = weights
  )
  as_psu(out, "psu_comparison")
}

#' Simulate conjunctive multiple-hurdle selection
#'
#' Simulates expected standardized criterion performance under conjunctive
#' multiple-hurdle selection. Predictors are first in `R`; criterion is last.
#' Candidates pass only if they exceed all marginal cutoffs.
#'
#' @param selection_ratios Marginal selection ratios for each hurdle.
#' @param R Correlation matrix for predictors and criterion, criterion last.
#' @param n_sim Number of simulated applicants.
#' @param seed Optional random seed.
#' @param n_applicants Number of real applicants, used for cost calculations.
#' @param cost_per_stage Cost per applicant at each stage. Scalar or vector.
#' @param sdy Optional monetary value of one criterion standard deviation.
#' @param applicant_n Legacy alias for `n_applicants`.
#' @return A `psu_comparison` object.
#' @references
#'
#' Ock, J., & Oswald, F. L. (2018). The utility of personnel selection
#'   decisions: Comparing compensatory and multiple-hurdle selection models.
#'   Journal of Personnel Psychology, 17(4), 172-182.
#' @export
#' @examples
#' # Literature: Sackett and Roth (1996); Ock and Oswald (2018).
#' # Minimal example (Sackett and Roth (1996); Ock and Oswald (2018)).
#' R <- matrix(c(1, .30, .40, .30, 1, .30, .40, .30, 1), 3, 3)
#' multiple_hurdle_selection(c(.50, .50), R, n_sim = 1000, seed = 1)
#'
#' # Substantive example with two marginal hurdles and costs.
#' multiple_hurdle_selection(
#'   selection_ratios = c(.40, .50),
#'   R = R,
#'   n_sim = 5000,
#'   seed = 123,
#'   n_applicants = 500,
#'   cost_per_stage = c(100, 400),
#'   sdy = 60000
#' )
multiple_hurdle_selection <- function(selection_ratios, R, n_sim = 100000,
                                      seed = NULL, n_applicants = NA_real_,
                                      cost_per_stage = 0, sdy = NULL,
                                      applicant_n = NULL) {
  n_applicants <- resolve_n_applicants(n_applicants, applicant_n)
  validate_probability(selection_ratios, "selection_ratios")
  validate_correlation_matrix(R, "R")
  k <- length(selection_ratios)
  if (nrow(R) != k + 1L) stop("`R` must include predictors first and criterion last.", call. = FALSE)
  if (!is.null(seed)) set.seed(seed)
  dat <- make_mvn(n_sim, R)
  cuts <- stats::qnorm(1 - selection_ratios)
  pass <- matrix(TRUE, nrow = n_sim, ncol = k)
  for (j in seq_len(k)) pass[, j] <- dat[, j] >= cuts[j]
  selected <- rowSums(pass) == k
  joint_sr <- mean(selected)
  expected_z <- if (any(selected)) mean(dat[selected, k + 1L]) else NA_real_
  stage_counts <- numeric(k)
  at_risk <- rep(TRUE, n_sim)
  for (j in seq_len(k)) {
    stage_counts[j] <- mean(at_risk)
    at_risk <- at_risk & pass[, j]
  }
  cost_per_stage <- recycle_to_length(cost_per_stage, k, "cost_per_stage")
  total_cost <- if (is.na(n_applicants)) NA_real_ else sum(n_applicants * stage_counts * cost_per_stage)
  n_selected <- if (is.na(n_applicants)) NA_real_ else n_applicants * joint_sr
  net_utility <- if (is.null(sdy) || is.na(n_applicants)) NA_real_ else expected_z * sdy * n_selected - total_cost
  out <- list(
    model = "Conjunctive multiple-hurdle selection",
    selection_ratios = selection_ratios,
    joint_selection_ratio = joint_sr,
    expected_criterion_z = expected_z,
    n_sim = n_sim,
    selected_simulated = sum(selected),
    stage_proportions_assessed = stage_counts,
    n_applicants = n_applicants,
    applicant_n = n_applicants,
    n_selected = n_selected,
    cost_per_stage = cost_per_stage,
    total_cost = total_cost,
    sdy = sdy,
    net_utility = net_utility
  )
  as_psu(out, "psu_comparison")
}

#' Simulate staged multiple-hurdle selection with composite stages
#'
#' Simulates a sequential multiple-hurdle design in which each stage can be one
#' predictor or a composite of predictors. This matches Ock-Oswald-style designs:
#' an inexpensive first-stage composite can screen applicants before a later, more
#' expensive stage such as a structured interview.
#'
#' @param stage_predictors List of integer vectors. Each element gives the
#'   predictor columns used at that stage.
#' @param stage_selection_ratios Vector of within-stage selection ratios.
#' @param R Correlation matrix for predictors and criterion, criterion last.
#' @param stage_weights Optional list of weight vectors. Defaults to unit weights
#'   within each stage.
#' @param n_sim Number of simulated applicants.
#' @param seed Optional random seed.
#' @param n_applicants Number of real applicants, used for cost calculations.
#' @param cost_per_stage Cost per applicant at each stage. Scalar or vector.
#' @param sdy Optional monetary value of one criterion standard deviation.
#' @param applicant_n Legacy alias for `n_applicants`.
#' @return A `psu_comparison` object.
#' @references
#'
#' Ock, J., & Oswald, F. L. (2018). The utility of personnel selection
#'   decisions: Comparing compensatory and multiple-hurdle selection models.
#'   Journal of Personnel Psychology, 17(4), 172-182.
#' @export
#' @examples
#' # Literature: Sackett and Roth (1996); Ock and Oswald (2018).
#' # Use the first call as a minimal example; the longer block illustrates
#' # how to interpret the function in the substantive setting discussed in the literature.
#' # Minimal example (Sackett and Roth (1996); Ock and Oswald (2018)).
#' R <- diag(5)
#' R[lower.tri(R)] <- R[upper.tri(R)] <- .20
#' diag(R) <- 1
#' multiple_hurdle_selection_staged(list(1:3, 4), c(.25, .80), R,
#'                                  n_sim = 1000, seed = 1)
#'
#' # Substantive example (Sackett and Roth, 1996;
#' # Ock and Oswald, 2018).
#' # Use an inexpensive first-stage composite, then an interview.
#' R <- matrix(c(
#'   1.00, .41, .04, .46, .37,
#'   .41, 1.00, .18, .22, .35,
#'   .04, .18, 1.00, .66, .16,
#'   .46, .22, .66, 1.00, .23,
#'   .37, .35, .16, .23, 1.00
#' ), 5, 5, byrow = TRUE)
#' multiple_hurdle_selection_staged(
#'   stage_predictors = list(c(1, 3, 4), 2),
#'   stage_selection_ratios = c(.25, .80),
#'   R = R,
#'   n_sim = 5000,
#'   seed = 123,
#'   n_applicants = 500,
#'   cost_per_stage = c(100, 900),
#'   sdy = 60000
#' )
multiple_hurdle_selection_staged <- function(stage_predictors, stage_selection_ratios, R,
                                             stage_weights = NULL, n_sim = 100000,
                                             seed = NULL, n_applicants = NA_real_,
                                             cost_per_stage = 0, sdy = NULL,
                                             applicant_n = NULL) {
  n_applicants <- resolve_n_applicants(n_applicants, applicant_n)
  if (!is.list(stage_predictors) || length(stage_predictors) == 0L) {
    stop("`stage_predictors` must be a non-empty list of predictor indices.", call. = FALSE)
  }
  validate_probability(stage_selection_ratios, "stage_selection_ratios")
  validate_correlation_matrix(R, "R")
  p <- nrow(R) - 1L
  k <- length(stage_predictors)
  if (length(stage_selection_ratios) != k) stop("`stage_selection_ratios` must match stages.", call. = FALSE)
  if (is.null(stage_weights)) stage_weights <- lapply(stage_predictors, function(idx) rep(1, length(idx)))
  if (!is.list(stage_weights) || length(stage_weights) != k) stop("`stage_weights` must be a list matching stages.", call. = FALSE)
  for (j in seq_len(k)) {
    idx <- stage_predictors[[j]]
    if (any(idx < 1L | idx > p) || any(abs(idx - round(idx)) > .Machine$double.eps^0.5)) {
      stop("Each element of `stage_predictors` must contain valid predictor indices.", call. = FALSE)
    }
    if (length(stage_weights[[j]]) != length(idx)) stop("Each stage weight vector must match its predictor set.", call. = FALSE)
  }
  if (!is.null(seed)) set.seed(seed)
  dat <- make_mvn(n_sim, R)
  at_risk <- rep(TRUE, n_sim)
  passed_stage <- matrix(FALSE, nrow = n_sim, ncol = k)
  stage_counts <- numeric(k)
  cutoffs <- numeric(k)
  for (j in seq_len(k)) {
    stage_counts[j] <- mean(at_risk)
    score <- weighted_composite(dat[, stage_predictors[[j]], drop = FALSE], stage_weights[[j]])
    cutoffs[j] <- stats::quantile(score[at_risk], probs = 1 - stage_selection_ratios[j], names = FALSE, type = 7)
    pass_j <- at_risk & score >= cutoffs[j]
    passed_stage[, j] <- pass_j
    at_risk <- pass_j
  }
  selected <- at_risk
  joint_sr <- mean(selected)
  expected_z <- if (any(selected)) mean(dat[selected, p + 1L]) else NA_real_
  cost_per_stage <- recycle_to_length(cost_per_stage, k, "cost_per_stage")
  total_cost <- if (is.na(n_applicants)) NA_real_ else sum(n_applicants * stage_counts * cost_per_stage)
  n_selected <- if (is.na(n_applicants)) NA_real_ else n_applicants * joint_sr
  net_utility <- if (is.null(sdy) || is.na(n_applicants)) NA_real_ else expected_z * sdy * n_selected - total_cost
  out <- list(
    model = "Staged multiple-hurdle selection with composites",
    stage_predictors = stage_predictors,
    stage_weights = stage_weights,
    stage_selection_ratios = stage_selection_ratios,
    joint_selection_ratio = joint_sr,
    expected_criterion_z = expected_z,
    n_sim = n_sim,
    selected_simulated = sum(selected),
    stage_proportions_assessed = stage_counts,
    stage_cutoffs_z = cutoffs,
    n_applicants = n_applicants,
    applicant_n = n_applicants,
    n_selected = n_selected,
    cost_per_stage = cost_per_stage,
    total_cost = total_cost,
    sdy = sdy,
    net_utility = net_utility
  )
  as_psu(out, "psu_comparison")
}

#' Compare compensatory and conjunctive multiple-hurdle selection systems
#'
#' Computes analytic compensatory expected performance and simulated multiple-hurdle
#' expected performance using the same predictor/criterion correlation structure.
#'
#' @param predictor_cor Predictor intercorrelation matrix.
#' @param validities Vector of predictor-criterion correlations.
#' @param compensatory_weights Weights for the compensatory composite.
#' @param compensatory_selection_ratio Overall compensatory selection ratio.
#' @param hurdle_selection_ratios Marginal selection ratios for hurdle stages.
#' @param n_sim Number of simulated applicants for the hurdle system.
#' @param seed Optional random seed.
#' @param n_applicants Optional number of real applicants.
#' @param compensatory_cost_per_applicant Cost per applicant for the compensatory system.
#' @param hurdle_cost_per_stage Cost per applicant assessed at each hurdle.
#' @param sdy Optional monetary value of one criterion standard deviation.
#' @param applicant_n Legacy alias for `n_applicants`.
#' @return A list with compensatory, multiple-hurdle, and difference summaries.
#' @references
#'
#' Ock, J., & Oswald, F. L. (2018). The utility of personnel selection
#'   decisions: Comparing compensatory and multiple-hurdle selection models.
#'   Journal of Personnel Psychology, 17(4), 172-182.
#' @export
#' @examples
#' # Literature: Ock and Oswald (2018).
#' # Minimal example (Ock and Oswald (2018)).
#' Rxx <- matrix(c(1, .30, .30, 1), 2, 2)
#' compare_selection_systems(Rxx, c(.40, .30), hurdle_selection_ratios = c(.50, .50),
#'                           compensatory_selection_ratio = .25, n_sim = 1000, seed = 1)
#'
#' # Substantive example with monetary utility.
#' compare_selection_systems(
#'   predictor_cor = Rxx,
#'   validities = c(.40, .30),
#'   compensatory_selection_ratio = .25,
#'   hurdle_selection_ratios = c(.50, .50),
#'   n_sim = 5000,
#'   seed = 123,
#'   n_applicants = 400,
#'   compensatory_cost_per_applicant = 800,
#'   hurdle_cost_per_stage = c(100, 300),
#'   sdy = 50000
#' )
compare_selection_systems <- function(predictor_cor, validities, compensatory_weights = NULL,
                                      compensatory_selection_ratio,
                                      hurdle_selection_ratios, n_sim = 100000,
                                      seed = NULL, n_applicants = NA_real_,
                                      compensatory_cost_per_applicant = 0,
                                      hurdle_cost_per_stage = 0,
                                      sdy = NULL, applicant_n = NULL) {
  n_applicants <- resolve_n_applicants(n_applicants, applicant_n)
  comp <- compensatory_selection(
    predictor_cor = predictor_cor,
    validities = validities,
    weights = compensatory_weights,
    selection_ratio = compensatory_selection_ratio,
    n_applicants = n_applicants,
    cost_per_applicant = compensatory_cost_per_applicant,
    sdy = sdy
  )
  R <- rbind(cbind(predictor_cor, validities), c(validities, 1))
  hurdle <- multiple_hurdle_selection(
    hurdle_selection_ratios, R, n_sim = n_sim, seed = seed,
    n_applicants = n_applicants, cost_per_stage = hurdle_cost_per_stage, sdy = sdy
  )
  out <- list(
    model = "Compensatory versus conjunctive multiple-hurdle comparison",
    compensatory = comp,
    multiple_hurdle = hurdle,
    expected_criterion_z_difference = comp$expected_criterion_z - hurdle$expected_criterion_z,
    selection_ratio_difference = comp$selection_ratio - hurdle$joint_selection_ratio,
    net_utility_difference = comp$net_utility - hurdle$net_utility
  )
  as_psu(out, "psu_comparison")
}

#' Compare compensatory and staged multiple-hurdle selection systems
#'
#' Compares a compensatory top-down composite against a staged multiple-hurdle
#' system in which stages can be composites.
#'
#' @param predictor_cor Predictor intercorrelation matrix.
#' @param validities Vector of predictor-criterion correlations.
#' @param compensatory_weights Weights for the compensatory composite.
#' @param compensatory_selection_ratio Overall compensatory selection ratio.
#' @param stage_predictors List of integer vectors defining staged predictors.
#' @param stage_selection_ratios Within-stage selection ratios.
#' @param stage_weights Optional list of weight vectors.
#' @param n_sim Number of simulated applicants for the staged system.
#' @param seed Optional random seed.
#' @param n_applicants Optional number of real applicants.
#' @param compensatory_cost_per_applicant Cost per applicant for the compensatory system.
#' @param hurdle_cost_per_stage Cost per applicant assessed at each hurdle.
#' @param sdy Optional monetary value of one criterion standard deviation.
#' @param applicant_n Legacy alias for `n_applicants`.
#' @return A list with compensatory, staged multiple-hurdle, and difference summaries.
#' @references
#'
#' Ock, J., & Oswald, F. L. (2018). The utility of personnel selection
#'   decisions: Comparing compensatory and multiple-hurdle selection models.
#'   Journal of Personnel Psychology, 17(4), 172-182.
#' @export
#' @examples
#' # Literature: Ock and Oswald (2018).
#' # Use the first call as a minimal example; the longer block illustrates
#' # how to interpret the function in the substantive setting discussed in the literature.
#' # Minimal example (Ock and Oswald (2018)).
#' Rxx <- diag(4); Rxx[lower.tri(Rxx)] <- Rxx[upper.tri(Rxx)] <- .20
#' compare_selection_systems_staged(Rxx, validities = c(.40, .35, .20, .30),
#'   compensatory_selection_ratio = .20, stage_predictors = list(1:3, 4),
#'   stage_selection_ratios = c(.25, .80), n_sim = 1000, seed = 1)
#'
#' # Substantive Ock-Oswald-style staged comparison.
#' compare_selection_systems_staged(
#'   predictor_cor = Rxx,
#'   validities = c(.40, .35, .20, .30),
#'   compensatory_weights = rep(1, 4),
#'   compensatory_selection_ratio = .20,
#'   stage_predictors = list(c(1, 3, 4), 2),
#'   stage_selection_ratios = c(.25, .80),
#'   n_sim = 5000,
#'   seed = 123,
#'   n_applicants = 500,
#'   compensatory_cost_per_applicant = 1000,
#'   hurdle_cost_per_stage = c(100, 900),
#'   sdy = 60000
#' )
compare_selection_systems_staged <- function(predictor_cor, validities, compensatory_weights = NULL,
                                             compensatory_selection_ratio,
                                             stage_predictors, stage_selection_ratios,
                                             stage_weights = NULL, n_sim = 100000,
                                             seed = NULL, n_applicants = NA_real_,
                                             compensatory_cost_per_applicant = 0,
                                             hurdle_cost_per_stage = 0,
                                             sdy = NULL, applicant_n = NULL) {
  n_applicants <- resolve_n_applicants(n_applicants, applicant_n)
  comp <- compensatory_selection(
    predictor_cor = predictor_cor,
    validities = validities,
    weights = compensatory_weights,
    selection_ratio = compensatory_selection_ratio,
    n_applicants = n_applicants,
    cost_per_applicant = compensatory_cost_per_applicant,
    sdy = sdy
  )
  R <- rbind(cbind(predictor_cor, validities), c(validities, 1))
  hurdle <- multiple_hurdle_selection_staged(
    stage_predictors = stage_predictors,
    stage_selection_ratios = stage_selection_ratios,
    R = R,
    stage_weights = stage_weights,
    n_sim = n_sim,
    seed = seed,
    n_applicants = n_applicants,
    cost_per_stage = hurdle_cost_per_stage,
    sdy = sdy
  )
  out <- list(
    model = "Compensatory versus staged multiple-hurdle comparison",
    compensatory = comp,
    multiple_hurdle = hurdle,
    expected_criterion_z_difference = comp$expected_criterion_z - hurdle$expected_criterion_z,
    selection_ratio_difference = comp$selection_ratio - hurdle$joint_selection_ratio,
    net_utility_difference = comp$net_utility - hurdle$net_utility
  )
  as_psu(out, "psu_comparison")
}
