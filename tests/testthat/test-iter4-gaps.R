# Tests for iteration 4 implementations:
# - correct_r_lawley (multivariate range restriction)
# - offer_rejection_adjustment (Murphy 1986)
# - dominance_analysis (Budescu 1993)
# - fuse_* helpers (Lord & Novick 1968)
# - sturman_comprehensive

test_that("correct_r_lawley reduces to Thorndike Case II for k = 2", {
  # Selection on X1 with restricted r* = .25, restricted SD = .6 of unrestricted.
  sigma_star <- matrix(c(1, .25, .25, 1), 2, 2)
  sigma_ss   <- matrix(1 / .6^2, 1, 1)
  out_lawley <- correct_r_lawley(sigma_star, selection_indices = 1,
                                 sigma_ss_unrestricted = sigma_ss)
  out_direct <- correct_r_direct_range_restriction(.25, u = 1 / .6)
  expect_equal(out_lawley$sigma_corrected[1, 2], out_direct, tolerance = 1e-6)
})

test_that("correct_r_lawley returns identity when sigma_ss is unchanged", {
  sigma_star <- matrix(c(1, .3, .25,
                         .3, 1, .20,
                         .25, .20, 1), 3, 3)
  sigma_ss <- sigma_star[1, 1, drop = FALSE]
  out <- correct_r_lawley(sigma_star, selection_indices = 1,
                          sigma_ss_unrestricted = sigma_ss)
  expect_equal(out$sigma_corrected, sigma_star, tolerance = 1e-9)
})

test_that("offer_rejection_adjustment uniform mode preserves z and scales N", {
  z0 <- selected_mean_z(.20)
  out <- offer_rejection_adjustment(z0, mode = "uniform",
                                    acceptance_rate = .70, n_offered = 100)
  expect_equal(out$expected_z_accepted, z0)
  expect_equal(out$effective_validity_loss, 0)
  expect_equal(out$expected_n_accepted, 70)
})

test_that("offer_rejection_adjustment correlated mode reflects negative rho", {
  z0 <- selected_mean_z(.20)
  out_neg <- offer_rejection_adjustment(z0, mode = "correlated",
                                        acceptance_rate = .70,
                                        rho_quality_acceptance = -.20)
  out_pos <- offer_rejection_adjustment(z0, mode = "correlated",
                                        acceptance_rate = .70,
                                        rho_quality_acceptance = +.20)
  expect_lt(out_neg$expected_z_accepted, z0)
  expect_gt(out_pos$expected_z_accepted, z0)
})

test_that("offer_rejection_adjustment selective mode integrates correctly", {
  z0 <- selected_mean_z(.20)
  # Logit slope of zero = uniform acceptance ~ plogis(intercept).
  out <- offer_rejection_adjustment(z0, mode = "selective",
                                    logit_intercept = 0, logit_slope = 0)
  expect_equal(out$acceptance_rate, .5, tolerance = 1e-3)
  expect_equal(out$expected_z_accepted, 0, tolerance = 1e-3)
})

test_that("dominance_analysis general dominance sums to R^2", {
  Rxx <- matrix(c(1, .30, .20,
                  .30, 1, .25,
                  .20, .25, 1), 3, 3)
  rxy <- c(.40, .30, .25)
  da <- dominance_analysis(Rxx, rxy)
  expect_equal(sum(da$general_dominance), da$r_squared_full, tolerance = 1e-9)
})

test_that("dominance_analysis ranks irrelevant predictors lowest", {
  # X3 has zero validity; should have zero general dominance.
  Rxx <- matrix(c(1, .30, .00,
                  .30, 1, .00,
                  .00, .00, 1), 3, 3)
  rxy <- c(.40, .30, .00)
  da <- dominance_analysis(Rxx, rxy)
  expect_equal(unname(da$general_dominance[3]), 0, tolerance = 1e-9)
})

test_that("fuse_reliability returns 1 when items are perfectly reliable", {
  R <- matrix(c(1, .3, .3, 1), 2, 2)
  expect_equal(fuse_reliability(c(.5, .5), R, c(1, 1)), 1)
})

test_that("fuse_reliability matches Spearman-Brown for two parallel items", {
  # Two parallel items: equal reliability rho_1, equal weights, intercorr rho_1.
  rho1 <- .80
  R <- matrix(c(1, rho1, rho1, 1), 2, 2)
  rel <- fuse_reliability(c(1, 1), R, c(rho1, rho1))
  # Sum-score Spearman-Brown: rho_C = (k * rho_1) / (1 + (k-1) * rho_1)
  sb <- (2 * rho1) / (1 + (2 - 1) * rho1)
  expect_equal(rel, sb, tolerance = 1e-9)
})

test_that("fuse_validity matches the closed-form scalar correlation", {
  R <- matrix(c(1, .30, .30, 1), 2, 2)
  v <- c(.40, .30)
  w <- c(1, 1)
  out <- fuse_validity(w, R, v)
  expected <- sum(w * v) / sqrt(t(w) %*% R %*% w)
  expect_equal(out, as.numeric(expected), tolerance = 1e-12)
})

test_that("fuse_composite_cor returns identity-like result for orthogonal weights", {
  R <- diag(4)
  W <- cbind(c(1, 0, 0, 0), c(0, 1, 0, 0))
  out <- fuse_composite_cor(W, R)
  expect_equal(out, diag(2), tolerance = 1e-12)
})

test_that("disattenuate_correlation inverts attenuation", {
  rho_true <- .40
  rel_x <- .80; rel_y <- .70
  rho_obs <- rho_true * sqrt(rel_x * rel_y)
  expect_equal(disattenuate_correlation(rho_obs, rel_x, rel_y),
               rho_true, tolerance = 1e-12)
})

test_that("disattenuate_correlation caps at +/- 1 with warning", {
  expect_warning(out <- disattenuate_correlation(.95, .50, .50),
                 "exceeds 1")
  expect_equal(abs(out), 1)
})

test_that("sturman_comprehensive returns monotonic step 1->2 reduction", {
  s <- suppressWarnings(sturman_comprehensive(
    validity = .35, baseline_validity = .20, selection_ratio = .20,
    sdy = 50000, n_year_one = 100, tenure = 5, fixed_cost = 75000,
    tax_rate = .25, discount_rate = .08
  ))
  expect_s3_class(s, "psu_sturman")
  step1 <- s$cascade$net_utility[s$cascade$step == "1. Naive BCG (random baseline)"]
  step2 <- s$cascade$net_utility[s$cascade$step == "2. + operating baseline"]
  expect_lt(step2, step1)
})

test_that("sturman_comprehensive substitutes RCV when criterion specs provided", {
  Rxx <- matrix(c(1, .30, .30, 1), 2, 2)
  Rxy <- matrix(c(.30, .10, .15, .25), 2, 2, byrow = TRUE)
  Ryy <- matrix(c(1, .40, .40, 1), 2, 2)
  s <- suppressWarnings(sturman_comprehensive(
    validity = .35, baseline_validity = .20, selection_ratio = .20,
    sdy = 50000, n_year_one = 100, tenure = 5, fixed_cost = 75000,
    predictor_cor = Rxx, predictor_criterion_cor = Rxy,
    criterion_cor = Ryy, criterion_weights = c(.7, .3)
  ))
  expect_lt(s$effective_validity, .35)
  expect_false(is.null(s$rcv))
})

test_that("sturman_comprehensive offer rejection lowers final estimate", {
  Rxx <- matrix(c(1, .30, .30, 1), 2, 2)
  Rxy <- matrix(c(.30, .10, .15, .25), 2, 2, byrow = TRUE)
  Ryy <- matrix(c(1, .40, .40, 1), 2, 2)
  s_full <- suppressWarnings(sturman_comprehensive(
    validity = .35, baseline_validity = .20, selection_ratio = .20,
    sdy = 50000, n_year_one = 100, tenure = 5, fixed_cost = 75000,
    hires_per_period = c(100, 15, 15, 15, 15),
    losses_per_period = c(0, 15, 15, 15, 15),
    tax_rate = .25, discount_rate = .08,
    predictor_cor = Rxx, predictor_criterion_cor = Rxy,
    criterion_cor = Ryy, criterion_weights = c(.7, .3),
    probation_cutoff_z = -1, acceptance_rate = 1
  ))
  s_rej <- suppressWarnings(sturman_comprehensive(
    validity = .35, baseline_validity = .20, selection_ratio = .20,
    sdy = 50000, n_year_one = 100, tenure = 5, fixed_cost = 75000,
    hires_per_period = c(100, 15, 15, 15, 15),
    losses_per_period = c(0, 15, 15, 15, 15),
    tax_rate = .25, discount_rate = .08,
    predictor_cor = Rxx, predictor_criterion_cor = Rxy,
    criterion_cor = Ryy, criterion_weights = c(.7, .3),
    probation_cutoff_z = -1, acceptance_rate = .70,
    quality_acceptance_correlation = -.20
  ))
  expect_lt(s_rej$net_utility, s_full$net_utility)
})

test_that("sturman_comprehensive warns about random-selection baseline", {
  expect_warning(
    sturman_comprehensive(validity = .35, baseline_validity = 0,
                          selection_ratio = .20, sdy = 50000,
                          n_year_one = 100, tenure = 5, fixed_cost = 75000),
    "random-selection baseline"
  )
})
