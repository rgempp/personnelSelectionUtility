# personnelSelectionUtility: Utility analysis methods for personnel selection

The goal of `personnelSelectionUtility` is to provide a comprehensive
and user-friendly way to apply utility-analysis methods for personnel
selection. It was created and is maintained by [René
Gempp](https://gempp.cl) to systematize state-of-the-art methods using
consistent notation across classification, continuous, monetary,
incremental-validity, simulation, and fairness-oriented summaries.

## Details

The package is organized around two core decisions: the scale of the
criterion (classification versus continuous/monetary outcomes) and the
structure of the selection rule (compensatory versus conjunctive or
staged multiple-hurdle systems). Start with
[`model_taxonomy()`](https://rgempp.github.io/personnel-selection-utility/reference/model_taxonomy.md)
and
[`argument_glossary()`](https://rgempp.github.io/personnel-selection-utility/reference/argument_glossary.md)
to choose the appropriate family of functions. Use the AUC conversion
helpers only when evidence is reported as AUC and a correlation-like
effect-size input is needed.

## Author

René Gempp, Facultad de Administración y Economía, Universidad Diego
Portales. Email: <rene.gempp@udp.cl>. Website: <https://gempp.cl>.

## References

Boudreau, J. W. (1991). Utility analysis for decisions in human resource
management. In M. D. Dunnette & L. M. Hough (Eds.), *Handbook of
industrial and organizational psychology* (Vol. 2, pp. 621-745).
Consulting Psychologists Press.

Brogden, H. E. (1949). When testing pays off. *Personnel Psychology*, 2,
171-183.

Cronbach, L. J., & Gleser, G. C. (1965). *Psychological tests and
personnel decisions* (2nd ed.). University of Illinois Press.

Hanley, J. A., & McNeil, B. J. (1982). The meaning and use of the area
under a receiver operating characteristic (ROC) curve. *Radiology*,
143(1), 29-36.

Holling, H. (1998). Utility analysis of personnel selection: An overview
and empirical study based on objective performance measures. *Methods of
Psychological Research Online*, 3(1), 5-24.

Ock, J., & Oswald, F. L. (2018). The utility of personnel selection
decisions: Comparing compensatory and multiple-hurdle selection models.
*Journal of Personnel Psychology*, 17(4), 172-182.

Rice, M. E., & Harris, G. T. (2005). Comparing effect sizes in follow-up
studies: ROC area, Cohen's d, and r. *Law and Human Behavior*, 29(5),
615-620.

Salgado, J. F. (2018). Transforming the area under the normal curve
(AUC) into Cohen's d, Pearson's r_pb, odds-ratio, and natural log
odds-ratio: Two conversion tables. *The European Journal of Psychology
Applied to Legal Context*, 10(1), 35-47.

Sturman, M. C. (2001). Utility analysis for multiple selection devices
and multiple outcomes. *Journal of Human Resource Costing and
Accounting*, 6(2), 9-28.

Taylor, H. C., & Russell, J. T. (1939). The relationship of validity
coefficients to the practical effectiveness of tests in selection.
*Journal of Applied Psychology*, 23, 565-578.

Thomas, J. G., Owen, D. B., & Gunst, R. F. (1977). Improving the use of
educational tests as selection tools. *Journal of Educational
Statistics*, 2(1), 55-77.

## See also

[`model_taxonomy()`](https://rgempp.github.io/personnel-selection-utility/reference/model_taxonomy.md),
[`argument_glossary()`](https://rgempp.github.io/personnel-selection-utility/reference/argument_glossary.md),
[`tr_classic()`](https://rgempp.github.io/personnel-selection-utility/reference/tr_classic.md),
[`tr_multivariate()`](https://rgempp.github.io/personnel-selection-utility/reference/tr_multivariate.md),
[`bcg_utility()`](https://rgempp.github.io/personnel-selection-utility/reference/bcg_utility.md),
[`boudreau_utility()`](https://rgempp.github.io/personnel-selection-utility/reference/boudreau_utility.md),
[`compare_selection_systems_staged()`](https://rgempp.github.io/personnel-selection-utility/reference/compare_selection_systems_staged.md),
[`auc_to_point_biserial()`](https://rgempp.github.io/personnel-selection-utility/reference/auc_to_point_biserial.md).

## Author

**Maintainer**: René Gempp <rene.gempp@udp.cl>
([ORCID](https://orcid.org/0000-0002-0427-6894)) (affiliation: Facultad
de Administración y Economía, Universidad Diego Portales, web:
https://gempp.cl) \[copyright holder\]

Authors:

- René Gempp <rene.gempp@udp.cl>
  ([ORCID](https://orcid.org/0000-0002-0427-6894)) (affiliation:
  Facultad de Administración y Economía, Universidad Diego Portales,
  web: https://gempp.cl) \[copyright holder\]
