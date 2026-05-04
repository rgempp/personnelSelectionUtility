#' Utility-analysis model taxonomy
#'
#' Returns the package's working taxonomy: criterion scale crossed with selection
#' structure. The taxonomy is designed to keep the Taylor-Russell,
#' Brogden-Cronbach-Gleser, Sturman, Ock-Oswald, and Thomas-Owen-Gunst
#' formulations distinct.
#'
#' @return A data frame with model families, decision structures, and package functions.
#' @references
#'
#' Thomas, J. G., Owen, D. B., & Gunst, R. F. (1977). Improving the use of
#'   educational tests as selection tools. Journal of Educational Statistics,
#'   2(1), 55-77.
#'
#' Ock, J., & Oswald, F. L. (2018). The utility of personnel selection
#'   decisions: Comparing compensatory and multiple-hurdle selection models.
#'   Journal of Personnel Psychology, 17(4), 172-182.
#' @export
#' @examples
#' # Literature: Thomas, Owen, and Gunst (1977); Ock and Oswald (2018).
#' model_taxonomy()
model_taxonomy <- function() {
  data.frame(
    criterion_scale = c(
      "classification/dichotomized",
      "classification/dichotomized",
      "classification/dichotomized",
      "continuous/monetary",
      "continuous/monetary",
      "continuous/monetary",
      "continuous/monetary",
      "multi-attribute"
    ),
    selection_structure = c(
      "compensatory or single predictor",
      "conjunctive multiple-hurdle with specified marginal cutoffs",
      "conjunctive multiple-hurdle with target joint selection ratio",
      "compensatory top-down",
      "incremental compensatory system",
      "sequential/multiple-hurdle simulation",
      "diagnostics and SDy input estimation",
      "multiple criteria"
    ),
    model_family = c(
      "Taylor-Russell (1939)",
      "Thomas-Owen-Gunst (1977)",
      "Thomas-Owen-Gunst tables / equal-cutoff design",
      "Naylor-Shine / BCG / SHP / Boudreau",
      "Sturman-style restricted canonical validity",
      "Ock-Oswald-style comparison",
      "Holling-style empirical checks and SDy estimation",
      "MAUA / Pareto decision support"
    ),
    primary_functions = c(
      "tr_classic(), tr_solve()",
      "tr_multivariate()",
      "tr_multivariate_equal_cutoff(), tr_binomial_success_probability()",
      "naylor_shine(), bcg_utility(), shp_utility(), boudreau_utility()",
      "restricted_canonical_validity(), incremental_validity()",
      "compensatory_selection(), multiple_hurdle_selection(), multiple_hurdle_selection_staged(), compare_selection_systems_staged()",
      "sdy_observed(), sdy_cost_accounting(), sdy_crepid(), utility_regression_diagnostics()",
      "multiattribute_utility(), pareto_frontier(), utility_fairness_frontier()"
    ),
    stringsAsFactors = FALSE
  )
}
