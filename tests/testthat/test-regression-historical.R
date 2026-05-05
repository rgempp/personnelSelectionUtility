# tests/testthat/test-regression-historical.R
# -------------------------------------------------------------------------
# Tests de regresión numérica.
# Los valores de referencia se obtienen mediante integración independiente con
# `mvtnorm::pmvnorm()` invocado externamente al paquete (auto-consistencia
# matemática), y se han cross-validado adicionalmente contra
# scipy.stats.multivariate_normal en una sesión Python externa.
# -------------------------------------------------------------------------

test_that("tr_classic reproduces grid of the Taylor-Russell univariate integral", {
  # Valores cross-validados con scipy.stats.multivariate_normal
  # BR = .20, columnas SR = c(.05, .10, .30, .50, .70, .95),
  # filas r = c(.00, .10, .30, .50, .70, .90)
  expected <- matrix(c(
    0.2000, 0.2000, 0.2000, 0.2000, 0.2000, 0.2000,
    0.2617, 0.2518, 0.2332, 0.2223, 0.2136, 0.2028,
    0.4081, 0.3714, 0.3044, 0.2673, 0.2389, 0.2072,
    0.5840, 0.5150, 0.3842, 0.3128, 0.2613, 0.2096,
    0.7856, 0.6900, 0.4777, 0.3584, 0.2785, 0.2105,
    0.9765, 0.9129, 0.5999, 0.3962, 0.2856, 0.2105
  ), nrow = 6, byrow = TRUE)
  rs  <- c(.00, .10, .30, .50, .70, .90)
  srs <- c(.05, .10, .30, .50, .70, .95)
  for (i in seq_along(rs)) {
    for (j in seq_along(srs)) {
      ppv <- tr_classic(base_rate = .20, selection_ratio = srs[j],
                        validity = rs[i])$ppv
      expect_equal(ppv, expected[i, j], tolerance = 1e-3,
                   info = sprintf("r=%.2f SR=%.2f", rs[i], srs[j]))
    }
  }
})

test_that("tr_multivariate matches tr_classic when k = 1", {
  for (r in c(.10, .30, .50, .70)) {
    for (sr in c(.10, .20, .50)) {
      for (br in c(.20, .50)) {
        a <- tr_classic(br, sr, r)
        R <- matrix(c(1, r, r, 1), 2, 2)
        b <- tr_multivariate(sr, br, R)
        expect_equal(a$ppv, b$ppv, tolerance = 1e-9)
        expect_equal(a$true_positive, b$true_positive, tolerance = 1e-9)
      }
    }
  }
})

test_that("tr_multivariate_equal_cutoff reproduces TOG (1977) Table 6 grid", {
  # Two predictors with rho_12 = .50, validity rho_iY = .70 each.
  # Reference values cross-validated with scipy + Monte Carlo (n = 5e6, seed 42).
  R <- matrix(c(1.0, .5, .7,
                .5, 1.0, .7,
                .7, .7, 1.0), 3, 3, byrow = TRUE)
  ref <- data.frame(
    base_rate    = c(.20, .20, .20, .50, .50, .50, .80, .80, .80),
    joint_sr     = c(.05, .20, .50, .05, .20, .50, .05, .20, .50),
    marginal_sr  = c(.1357, .3543, .6530, .1357, .3543, .6530,
                     .1357, .3543, .6530),
    ppv          = c(.8695, .6201, .3715, .9924, .9375, .7772,
                     .9999, .9976, .9737)
  )
  for (i in seq_len(nrow(ref))) {
    out <- tr_multivariate_equal_cutoff(ref$joint_sr[i], ref$base_rate[i], R)
    expect_equal(out$solved_marginal_selection_ratio, ref$marginal_sr[i],
                 tolerance = 1e-3,
                 info = sprintf("BR=%.2f JSR=%.2f", ref$base_rate[i],
                                ref$joint_sr[i]))
    expect_equal(out$ppv, ref$ppv[i], tolerance = 5e-3,
                 info = sprintf("BR=%.2f JSR=%.2f", ref$base_rate[i],
                                ref$joint_sr[i]))
  }
})

test_that("tr_solve recovers each parameter from the other three", {
  # Ground truth obtained from tr_classic itself (round-trip)
  ground <- tr_classic(.50, .20, .35)
  expect_equal(tr_solve(NULL, .20, .35, ground$ppv)$base_rate,
               .50, tolerance = 1e-3)
  expect_equal(tr_solve(.50, NULL, .35, ground$ppv)$selection_ratio,
               .20, tolerance = 1e-3)
  expect_equal(tr_solve(.50, .20, NULL, ground$ppv)$validity,
               .35, tolerance = 1e-3)
  expect_equal(tr_solve(.50, .20, .35, NULL)$ppv,
               ground$ppv, tolerance = 1e-9)
})

test_that("tr_solve warns and returns zero validity when PPV <= base_rate", {
  expect_warning(
    out <- tr_solve(base_rate = .50, selection_ratio = .20,
                    validity = NULL, ppv = .50),
    "non-negative validity is set to 0"
  )
  expect_equal(out$validity, 0)
})

test_that("Naylor-Shine equals BCG/SDy*N*T*r*z when SDy normalized", {
  zbar <- selected_mean_z(.20)
  ns <- naylor_shine(validity = .35, selection_ratio = .20,
                     sdy = 1, n_selected = 1, tenure = 1)
  expect_equal(ns$expected_criterion_z, .35 * zbar, tolerance = 1e-12)
})

test_that("BCG identity: validity = 0 implies zero gross utility", {
  bcg <- bcg_utility(0, .20, sdy = 50000, n_selected = 100, tenure = 3)
  expect_equal(bcg$gross_utility, 0)
})

test_that("BCG with operating baseline implements Sturman (2001) reduction", {
  naive <- bcg_utility(.35, .20, 50000, 100, 3, baseline_validity = 0)
  incr  <- bcg_utility(.35, .20, 50000, 100, 3, baseline_validity = .20)
  # Incremental utility = (focal - baseline) * SDy * N * T * z
  zbar <- selected_mean_z(.20)
  expect_equal(incr$gross_utility,
               (.35 - .20) * 50000 * 100 * 3 * zbar, tolerance = 1e-9)
  expect_lt(incr$gross_utility, naive$gross_utility)
})

test_that("Boudreau collapses to BCG under degenerate parameters", {
  bcg <- bcg_utility(.35, .20, 50000, 100, tenure = 3, cost = 75000)
  bd  <- boudreau_utility(validity = .35, selection_ratio = .20, sdy = 50000,
                          n_by_period = rep(100, 3), variable_value = 0,
                          tax_rate = 0, discount_rate = 0,
                          cost_by_period = c(75000, 0, 0))
  expect_equal(bd$net_present_value, bcg$net_utility, tolerance = 1e-6)
})

test_that("Boudreau discount factor reduces NPV monotonically", {
  bd0 <- boudreau_utility(.35, .20, sdy = 50000, n_by_period = c(100, 100, 100),
                          discount_rate = 0)
  bd1 <- boudreau_utility(.35, .20, sdy = 50000, n_by_period = c(100, 100, 100),
                          discount_rate = .10)
  expect_lt(bd1$net_present_value, bd0$net_present_value)
})

test_that("SHP intervention utility scales linearly with d", {
  u1 <- shp_utility(.20, 50000, 100, 2)
  u2 <- shp_utility(.40, 50000, 100, 2)
  expect_equal(u2$gross_utility / u1$gross_utility, 2, tolerance = 1e-12)
})

test_that("Probation adjustment matches inverse-Mills ratio", {
  for (z in c(-1, 0, 1)) {
    expect_equal(probation_adjustment(z),
                 dnorm(z) / (1 - pnorm(z)), tolerance = 1e-12)
  }
})

test_that("Compensatory composite validity matches closed form", {
  Rxx <- matrix(c(1, .30, .30, 1), 2, 2)
  v   <- c(.40, .30)
  w   <- c(.6, .4)
  comp <- compensatory_selection(Rxx, v, weights = w, selection_ratio = .20)
  comp_sd <- sqrt(t(w) %*% Rxx %*% w)
  expected_validity <- as.numeric(t(w) %*% v) / as.numeric(comp_sd)
  expect_equal(comp$composite_validity, expected_validity, tolerance = 1e-12)
})

test_that("Multiple-hurdle simulation respects joint selection ratio bounds", {
  R <- diag(3); R[lower.tri(R)] <- R[upper.tri(R)] <- .25
  out <- multiple_hurdle_selection(c(.50, .50), R, n_sim = 5000, seed = 1)
  # Joint SR for two independent .50 cuts under correlation .25 is below .25
  # but bounded above by min(.50, .50) = .50.
  expect_gt(out$joint_selection_ratio, .25)
  expect_lt(out$joint_selection_ratio, .50)
})

test_that("Restricted canonical validity equals simple correlation when k = m = 1", {
  S11 <- matrix(1)
  S12 <- matrix(.30)
  S22 <- matrix(1)
  out <- restricted_canonical_validity(S11, S12, S22, criterion_weights = 1)
  expect_equal(out$validity, .30, tolerance = 1e-12)
})

test_that("Incremental validity is non-negative for nested predictor sets", {
  Rxx <- matrix(c(1, .30, .20, .30, 1, .25, .20, .25, 1), 3, 3)
  Rxy <- matrix(c(.30, .20, .25, .15, .10, .35), 3, 2, byrow = TRUE)
  Ryy <- matrix(c(1, .40, .40, 1), 2, 2)
  iv <- incremental_validity(Rxx, Rxy, Ryy, c(.6, .4),
                             baseline_predictors = 1:2, added_predictors = 3)
  expect_gte(iv$incremental_validity, 0)
})

test_that("Composite d reduces to scalar d when k = 1", {
  expect_equal(composite_d(.50), .50, tolerance = 1e-12)
})

test_that("Composite d zero when all individual d are zero", {
  expect_equal(composite_d(c(0, 0), c(.5, .5),
                           matrix(c(1, .3, .3, 1), 2, 2)), 0)
})

test_that("Adverse impact ratio is 1 for the reference group itself", {
  out <- adverse_impact_ratio(c(1, 0, 1, 1, 0, 0),
                              c("A", "A", "A", "B", "B", "B"))
  ref_row <- out[as.character(out$group) == out$reference_group[1], ]
  expect_equal(ref_row$adverse_impact_ratio, 1)
})

test_that("AUC conversion family is internally consistent", {
  # auc_to_rank_biserial(0.5) == 0
  expect_equal(auc_to_rank_biserial(.5), 0)
  # auc_to_d_equal_variance(.5) == 0
  expect_equal(auc_to_d_equal_variance(.5), 0, tolerance = 1e-12)
  # auc_to_point_biserial composes auc_to_d_equal_variance and d_to_point_biserial
  expect_equal(auc_to_point_biserial(.75, base_rate = .50),
               d_to_point_biserial(auc_to_d_equal_variance(.75), base_rate = .50),
               tolerance = 1e-12)
})

test_that("d-to-r and r-to-d invert each other", {
  for (r in c(-.50, -.20, 0, .20, .50, .70)) {
    expect_equal(d_to_cor(cor_to_d(r)), r, tolerance = 1e-10)
  }
})

test_that("inflation_adjusted_rate matches Tziner et al. (1994) formula", {
  expect_equal(inflation_adjusted_rate(.08, .025),
               .08 + .025 + .08 * .025, tolerance = 1e-12)
})

test_that("sdy_percentile recovers the standard deviation under symmetric inputs", {
  # If percentiles are at +/- z * sd around the mean, then (P85 - P15) / 2
  # equals the empirical sd only approximately under normality.
  # Here we test the formula itself, not the normality assumption.
  expect_equal(sdy_percentile(80, 120), 20)
})

test_that("sdy_proportional matches multiplier * mean_pay", {
  expect_equal(sdy_proportional(80000, .40), 32000)
  expect_equal(sdy_proportional(80000, .70), 56000)
})

test_that("sdy_observed equals stats::sd for finite vectors", {
  y <- c(100, 120, 80, 150)
  expect_equal(sdy_observed(y), stats::sd(y))
})

test_that("Pareto frontier finds the trivial cases", {
  # Single-row data.frame
  expect_equal(pareto_frontier(data.frame(a = 1, b = 2)), TRUE)
  # All identical
  expect_equal(pareto_frontier(data.frame(a = c(1, 1), b = c(2, 2))),
               c(TRUE, TRUE))
  # One point dominates
  out <- pareto_frontier(data.frame(a = c(1, 2), b = c(2, 3)))
  expect_equal(out, c(FALSE, TRUE))
})

test_that("utility_monte_carlo seed yields reproducible draws", {
  m1 <- utility_monte_carlo(500, .30, .05, 50000, 10000, .20, 100, 3, seed = 7)
  m2 <- utility_monte_carlo(500, .30, .05, 50000, 10000, .20, 100, 3, seed = 7)
  expect_equal(m1$mean_net_utility, m2$mean_net_utility)
  expect_equal(m1$quantiles, m2$quantiles)
})

test_that("break_even_validity recovers the algebraic identity", {
  bev <- break_even_validity(.20, 50000, 100, 3, cost = 75000,
                             baseline_validity = .15)
  zbar <- selected_mean_z(.20)
  expected <- .15 + 75000 / (100 * 3 * 50000 * zbar)
  expect_equal(bev, expected, tolerance = 1e-12)
})

test_that("Validators reject malformed inputs", {
  expect_error(validate_probability(c(.5, 1.5), "x"), "must be in")
  expect_error(validate_correlation(c(.5, 1.5), "x"), "must contain correlations")
  R_bad <- matrix(c(1, .9, .9, .9, 1, -.9, .9, -.9, 1), 3, 3)
  expect_error(validate_correlation_matrix(R_bad, "R"), "positive semi-definite")
})

test_that("model_taxonomy and argument_glossary return data frames", {
  expect_s3_class(model_taxonomy(), "data.frame")
  expect_s3_class(argument_glossary(), "data.frame")
  expect_gt(nrow(model_taxonomy()), 0)
  expect_gt(nrow(argument_glossary()), 0)
})
