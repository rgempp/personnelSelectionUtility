# Multivariate range-restriction correction (Lawley, 1943)

Corrects an observed (restricted) correlation matrix for direct
selection on a subset of variables and incidental selection on the
remaining variables, using Lawley's (1943) multivariate formulae.

## Usage

``` r
correct_r_lawley(
  sigma_restricted,
  selection_indices,
  sigma_ss_unrestricted,
  standardize = TRUE
)
```

## Arguments

- sigma_restricted:

  Observed (restricted) covariance or correlation matrix in the selected
  sample. Must be symmetric and positive semi-definite.

- selection_indices:

  Integer vector indicating which rows/columns of `sigma_restricted`
  correspond to variables on which selection was applied.

- sigma_ss_unrestricted:

  Unrestricted covariance submatrix for the selection variables (the
  same dimension as
  `sigma_restricted[selection_indices, selection_indices]`). Typically
  estimated from applicant-pool data.

- standardize:

  Logical. If `TRUE` (default), the corrected covariance matrix is
  converted to a correlation matrix via
  [`stats::cov2cor()`](https://rdrr.io/r/stats/cor.html).

## Value

A list with components:

- sigma_corrected:

  The corrected (unrestricted) covariance or correlation matrix of the
  same dimension as `sigma_restricted`.

- sigma_restricted:

  The input restricted matrix (echoed).

- selection_indices:

  Indices treated as direct-selection variables.

- incidental_indices:

  Indices treated as incidentally restricted.

- u:

  Vector of `sd_restricted / sd_unrestricted` per selection variable,
  one of the standard summaries of restriction severity.

- sign_changes:

  Integer count of off-diagonal entries whose sign differs between
  corrected and observed matrices, flagged in the spirit of Ree,
  Carretta, Earles & Albert (1994).

## Details

Let `S` index the variables on which selection was applied and `U` index
the remaining (incidentally restricted) variables. Given the observed
restricted covariance matrix `Sigma_star` and the unrestricted
covariance submatrix `Sigma_SS_unrestricted` for the selection
variables, Lawley's correction recovers the unrestricted covariance
matrix:

\$\$\Sigma\_{UV} = \Sigma\_{UV}^{\*} + \Sigma\_{US}^{\*}\\
(\Sigma\_{SS}^{\*})^{-1}\\ (\Sigma\_{SS} - \Sigma\_{SS}^{\*})\\
(\Sigma\_{SS}^{\*})^{-1}\\ \Sigma\_{SV}^{\*}\$\$ \$\$\Sigma\_{UU} =
\Sigma\_{UU}^{\*} + \Sigma\_{US}^{\*}\\ (\Sigma\_{SS}^{\*})^{-1}\\
(\Sigma\_{SS} - \Sigma\_{SS}^{\*})\\ (\Sigma\_{SS}^{\*})^{-1}\\
\Sigma\_{SU}^{\*}\$\$

for any partitioning into selection variables `S` and other variables
`U,V`.

Sign changes flagged in `sign_changes` are not necessarily errors but
should be inspected: Ree et al. (1994) documented that legitimate Lawley
corrections can flip the sign of small predictor-criterion correlations
when the restriction matrix is large.

## References

Lawley, D. N. (1943). A note on Karl Pearson's selection formulae.
*Proceedings of the Royal Society of Edinburgh, Section A*, 62, 28-30.

Mendoza, J. L., & Mumford, M. D. (1987). Corrections for attenuation and
range restriction on the predictor. *Journal of Educational and
Behavioral Statistics*, 12, 282-293.

Ree, M. J., Carretta, T. R., Earles, J. A., & Albert, W. (1994). Sign
changes when correcting for range restriction: A note on Pearson's and
Lawley's selection formulas. *Journal of Applied Psychology*, 79,
298-301.

Sackett, P. R., Lievens, F., Berry, C. M., & Landers, R. N. (2007). A
cautionary note on the effects of range restriction on predictor
intercorrelations. *Journal of Applied Psychology*, 92, 538-544.

## Examples

``` r
# Three-variable example: selection on X1 (cognitive ability),
# incidental restriction on X2 (interview) and Y (criterion).
sigma_star <- matrix(c(
  1.00, 0.30, 0.25,
  0.30, 1.00, 0.20,
  0.25, 0.20, 1.00
), 3, 3)
# Unrestricted SD of X1 is larger; var increases by factor 1/u^2 = 1/.6^2
sigma_ss <- matrix(1 / 0.6^2, 1, 1)
correct_r_lawley(sigma_star, selection_indices = 1,
                 sigma_ss_unrestricted = sigma_ss)
#> $sigma_corrected
#>           [,1]      [,2]      [,3]
#> [1,] 1.0000000 0.4642383 0.3952847
#> [2,] 0.4642383 1.0000000 0.2936101
#> [3,] 0.3952847 0.2936101 1.0000000
#> 
#> $sigma_restricted
#>      [,1] [,2] [,3]
#> [1,] 1.00  0.3 0.25
#> [2,] 0.30  1.0 0.20
#> [3,] 0.25  0.2 1.00
#> 
#> $selection_indices
#> [1] 1
#> 
#> $incidental_indices
#> [1] 2 3
#> 
#> $u
#> [1] 0.6
#> 
#> $sign_changes
#> [1] 0
#> 
```
