# Convert AUC to a point-biserial correlation

Converts AUC to Cohen's d under the equal-variance binormal model and
then converts d to a point-biserial correlation for a user-specified
base rate. This is the preferred correlation-like conversion when a
utility-analysis function requires a validity input but the available
evidence is reported as AUC.

## Usage

``` r
auc_to_point_biserial(auc, base_rate = 0.5)
```

## Arguments

- auc:

  Area under the ROC curve. Must be in `(0, 1)` because AUC values of 0
  or 1 imply infinite d under the equal-variance binormal model.

- base_rate:

  Proportion in the focal or successful group, usually denoted \\p\\.
  Must be in `(0, 1)`. The default is `.50`.

## Value

Numeric vector of point-biserial correlations.

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
# Minimal example: AUC to d, then to r_pb for a balanced binary criterion.
auc_to_point_biserial(.75)
#> [1] 0.4304822

# Substantive example: examine how base rate affects the implied r_pb.
auc_to_point_biserial(.75, base_rate = c(.50, .30, .20, .10))
#> [1] 0.4304822 0.4005260 0.3564821 0.2751188
```
