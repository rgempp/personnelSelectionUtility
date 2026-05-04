# personnelSelectionUtility 0.5.6 patch notes

This patch revises the AUC conversion utilities. The former single `auc_to_r()` helper is no longer treated as the recommended interface because AUC can be mapped to several different effect-size metrics depending on assumptions. The package now exposes:

- `auc_to_rank_biserial()` for the distribution-free dominance transformation `2 * AUC - 1`;
- `auc_to_d_equal_variance()` for the equal-variance binormal conversion from AUC to Cohen's d;
- `d_to_point_biserial()` for base-rate-sensitive conversion from d to r_pb;
- `auc_to_point_biserial()` for the full AUC -> d -> r_pb conversion.

`auc_to_r()` remains available as a backward-compatible alias for `auc_to_point_biserial(auc, base_rate = .50)`, but new code should use the explicit conversion functions.

No core Taylor-Russell, BCG, Boudreau, Sturman, or simulation computations were changed.
