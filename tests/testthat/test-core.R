test_that("selected_mean_z is positive and larger for lower selection ratios", {
  expect_gt(selected_mean_z(.10), selected_mean_z(.50))
})

test_that("argument glossary includes renamed arguments", {
  g <- argument_glossary()
  expect_true("n_applicants" %in% g$argument)
  expect_true("n_by_period" %in% g$argument)
  expect_true("range_restriction_ratio" %in% g$argument)
})

test_that("BCG utility returns expected components", {
  x <- bcg_utility(.30, .20, sdy = 1000, n_selected = 10, tenure = 2, cost = 0)
  expect_gt(x$gross_utility, 0)
  expect_equal(x$net_utility, x$gross_utility)
})

test_that("Boudreau utility accepts new and legacy period names", {
  x1 <- boudreau_utility(.10, sdy = 1000, n_by_period = c(10, 9), cost_by_period = c(100, 0))
  x2 <- boudreau_utility(.10, sdy = 1000, n_t = c(10, 9), cost_t = c(100, 0))
  expect_equal(x1$net_present_value, x2$net_present_value)
})

test_that("d and r conversions invert approximately", {
  r <- .30
  expect_equal(d_to_cor(cor_to_d(r)), r, tolerance = 1e-10)
})

test_that("Taylor-Russell finite sampling returns upper-tail probability", {
  p <- tr_binomial_success_probability(20, .91, at_least = 18)
  expect_true(is.data.frame(p))
  expect_true(is.numeric(attr(p, "probability_at_least")))
})

test_that("Thomas-Owen-Gunst equal cutoff solves a target joint selection ratio", {
  R <- matrix(c(1, .50, .70,
                .50, 1, .70,
                .70, .70, 1), 3, 3, byrow = TRUE)
  x <- tr_multivariate_equal_cutoff(.20, .60, R)
  expect_lt(abs(x$joint_selection_ratio - .20), 5e-4)
  expect_gt(x$ppv, .90)
})

test_that("staged multiple hurdle returns a valid summary", {
  R <- diag(5)
  R[lower.tri(R)] <- R[upper.tri(R)] <- .20
  diag(R) <- 1
  out <- multiple_hurdle_selection_staged(list(1:3, 4), c(.25, .80), R, n_sim = 1000, seed = 1)
  expect_true(out$joint_selection_ratio > 0)
  expect_true(out$joint_selection_ratio < 1)
})

test_that("new n_applicants argument and legacy applicant_n agree", {
  Rxx <- matrix(c(1, .30, .30, 1), 2, 2)
  a <- compensatory_selection(Rxx, c(.40, .30), selection_ratio = .20,
                              n_applicants = 100, cost_per_applicant = 10, sdy = 1000)
  b <- compensatory_selection(Rxx, c(.40, .30), selection_ratio = .20,
                              applicant_n = 100, cost_per_applicant = 10, sdy = 1000)
  expect_equal(a$net_utility, b$net_utility)
})

test_that("range restriction correction accepts new and legacy names", {
  expect_equal(
    correct_r_direct_range_restriction(.25, range_restriction_ratio = 1.4),
    correct_r_direct_range_restriction(.25, u = 1.4)
  )
})

test_that("Pareto frontier returns logical vector", {
  x <- pareto_frontier(data.frame(a = c(1, 2, 3), b = c(3, 2, 1)))
  expect_type(x, "logical")
  expect_length(x, 3)
})

test_that("AUC conversion family separates dominance, d, and point-biserial metrics", {
  expect_equal(auc_to_rank_biserial(.75), .50)
  expect_equal(auc_to_d_equal_variance(.50), 0, tolerance = 1e-12)
  expect_equal(d_to_point_biserial(.50, base_rate = .50), d_to_cor(.50), tolerance = 1e-12)
  expect_lt(auc_to_point_biserial(.75, base_rate = .20), auc_to_point_biserial(.75, base_rate = .50))
  expect_equal(auc_to_r(.75), auc_to_point_biserial(.75), tolerance = 1e-12)
})
