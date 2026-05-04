# Convert AUC to a rank-biserial correlation

Converts the area under the ROC curve to the rank-biserial correlation,
\\r\_{rb} = 2 AUC - 1\\. This is a distribution-free dominance summary:
it rescales the probability that a randomly chosen successful applicant
is ranked above a randomly chosen unsuccessful applicant from the
`[0, 1]` AUC scale to the `[-1, 1]` correlation-like scale.

## Usage

``` r
auc_to_rank_biserial(auc)
```

## Arguments

- auc:

  Area under the ROC curve. Must be in `[0, 1]`.

## Value

Numeric vector of rank-biserial correlations.

## References

Hanley, J. A., & McNeil, B. J. (1982). The meaning and use of the area
under a receiver operating characteristic (ROC) curve. *Radiology*,
143(1), 29-36.

Kerby, D. S. (2014). The simple difference formula: An approach to
teaching nonparametric correlation. *Comprehensive Psychology*, 3,
11.IT.3.1.

Rice, M. E., & Harris, G. T. (2005). Comparing effect sizes in follow-up
studies: ROC area, Cohen's d, and r. *Law and Human Behavior*, 29(5),
615-620.

## Examples

``` r
# Minimal example: AUC = .50 implies no dominance.
auc_to_rank_biserial(.50)
#> [1] 0

# AUC = .75 means 75% favorable pairwise ordering; r_rb = .50.
auc_to_rank_biserial(.75)
#> [1] 0.5
```
