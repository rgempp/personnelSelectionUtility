#' Argument naming glossary
#'
#' Returns the package's recommended argument names and the notation they map to
#' in the utility-analysis literature. The glossary is intended to make the API
#' explicit and to avoid mixing compact statistical notation with readable R
#' argument names.
#'
#' @return A data frame with argument names, literature notation, and usage notes.
#' @references
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
#' # Literature: Holling (1998); Sturman (2001).
#' argument_glossary()
#' subset(argument_glossary(), argument %in% c("base_rate", "selection_ratio", "sdy"))
argument_glossary <- function() {
  data.frame(
    argument = c(
      "base_rate", "selection_ratio", "selection_ratios", "joint_selection_ratio",
      "validity", "validities", "predictor_cor", "R", "sdy", "n_selected",
      "n_treated", "n_applicants", "n_by_period", "tenure", "cost",
      "cost_per_applicant", "cost_per_stage", "cost_by_period", "baseline_validity",
      "baseline_selection_ratio", "delta_z_y", "effect_size_d", "range_restriction_ratio",
      "variable_value", "contribution_margin", "tax_rate", "discount_rate",
      "stage_predictors", "stage_selection_ratios", "stage_weights", "n_sim", "seed"
    ),
    notation = c(
      "BR or phi", "SR", "SR_i", "SR_conj", "r_xy", "r_xi,y",
      "R_XX", "R = cor(X_1,...,X_k,Y)", "SD_y", "N_s", "N_treated", "N",
      "N_t", "T", "C", "C_A", "C_j", "C_t", "r_baseline", "SR_baseline",
      "Delta z_y", "d", "u", "V", "margin", "tax", "i", "stage index",
      "SR_j", "w_j", "simulation replications", "random seed"
    ),
    meaning = c(
      "Applicant-population probability of criterion success before selection.",
      "Overall proportion selected by a single cutoff or composite.",
      "Vector of marginal selection ratios for multiple predictors or hurdles.",
      "Overall conjunctive probability of passing all multiple cutoffs.",
      "Focal predictor-criterion validity coefficient.",
      "Vector of predictor-criterion correlations.",
      "Predictor intercorrelation matrix only.",
      "Full predictor-plus-criterion correlation matrix; predictors first, criterion last.",
      "Standard deviation of job performance in monetary or criterion units.",
      "Number of selected applicants/employees.",
      "Number of employees receiving an intervention.",
      "Number of applicants assessed by a selection system.",
      "Vector of active selected/retained employees by period.",
      "Expected duration of effects or tenure in periods.",
      "Total fixed or net cost supplied directly.",
      "Cost per applicant assessed by a one-stage system.",
      "Cost per applicant assessed at each hurdle stage.",
      "Cost incurred in each time period.",
      "Validity of the currently operating baseline system.",
      "Selection ratio of the baseline system; defaults to the focal selection ratio.",
      "Expected incremental standardized criterion gain supplied directly.",
      "Standardized mean difference for intervention utility.",
      "Ratio of unrestricted to restricted predictor standard deviations.",
      "Boudreau-style multiplier V; interpretation controlled by variable_value_convention.",
      "Direct contribution-margin multiplier overriding variable_value.",
      "Tax rate applied to benefits and, where appropriate, costs.",
      "Discount rate used for present-value calculations.",
      "List defining which predictors enter each hurdle stage.",
      "Within-stage selection ratios for a staged multiple-hurdle system.",
      "Optional within-stage composite weights.",
      "Number of Monte Carlo simulated applicants or draws.",
      "Optional seed for reproducible simulations."
    ),
    note = c(
      "Use base_rate rather than BR in the public API.",
      "Use singular form for one decision cutoff.",
      "Use plural form when there is one SR per predictor or stage.",
      "Distinct from marginal selection_ratios; central for Thomas-Owen-Gunst tables.",
      "More readable than rxy, but documentation always gives the r_xy mapping.",
      "Used when multiple predictors enter a composite.",
      "Do not include the criterion in predictor_cor.",
      "Required by tr_multivariate() and simulation helpers.",
      "The package uses sdy because SDy is the conventional label in the literature.",
      "Avoid N when the role of the count is ambiguous.",
      "Used in Schmidt-Hunter-Pearlman intervention utility.",
      "Preferred name in v0.4.0; applicant_n is accepted as a legacy alias.",
      "Preferred name in v0.4.0; n_t is accepted as a legacy alias in boudreau_utility().",
      "Used when the same effect persists over multiple periods.",
      "Use more specific names when costs are per applicant, per stage, or per period.",
      "Preferred over CA because it is self-documenting.",
      "Used in multiple-hurdle simulations.",
      "Preferred name in v0.4.0; cost_t is accepted as a legacy alias.",
      "Implements the Sturman baseline critique.",
      "Important when baseline and focal systems have different selectivity.",
      "Allows direct use of outputs from simulations or external models.",
      "Used for training/intervention utility rather than selection validity.",
      "Preferred name in v0.4.0; u is accepted as a legacy alias.",
      "Use contribution_margin directly when V is conceptually ambiguous.",
      "Most transparent way to represent value retained after variable costs.",
      "Must be in [0, 1].", "Non-negative scalar or vector, depending on context.",
      "Each element is an integer vector of predictor indices.",
      "Product gives the expected net selection ratio in a strictly sequential design.",
      "Defaults to unit weights within each stage.",
      "Keep examples small; use larger values in applied analyses.",
      "Set seed for reproducible documentation and tests."
    ),
    stringsAsFactors = FALSE
  )
}
