# Convert AUC to Cohen's d under the equal-variance binormal model

Converts AUC to Cohen's d using \\d = \sqrt{2}\Phi^{-1}(AUC)\\. This
conversion assumes two normal distributions with equal variances and
should therefore be interpreted as a model-based effect-size conversion,
not as a universal transformation from classifier accuracy to
personnel-selection validity.

## Usage

``` r
auc_to_d_equal_variance(auc)
```

## Arguments

- auc:

  Area under the ROC curve. Must be in `(0, 1)` because AUC values of 0
  or 1 imply infinite d under the equal-variance binormal model.

## Value

Numeric vector of Cohen's d values.

## References

Hanley, J. A., & McNeil, B. J. (1982). The meaning and use of the area
under a receiver operating characteristic (ROC) curve. *Radiology*,
143(1), 29-36.

Rice, M. E., & Harris, G. T. (2005). Comparing effect sizes in follow-up
studies: ROC area, Cohen's d, and r. *Law and Human Behavior*, 29(5),
615-620.

Salgado, J. F. (2018). Transforming the area under the normal curve
(AUC) into Cohen's d, Pearson's r_pb, odds-ratio, and natural log
odds-ratio: Two conversion tables. *The European Journal of Psychology
Applied to Legal Context*, 10(1), 35-47.

## Examples

``` r
# Minimal example based on the equal-variance binormal conversion.
auc_to_d_equal_variance(.75)
#> [1] 0.9538726

# Direction is preserved: AUC below .50 implies a negative effect.
auc_to_d_equal_variance(.40)
#> [1] -0.3582869
```
