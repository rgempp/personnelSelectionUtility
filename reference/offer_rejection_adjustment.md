# Offer-rejection adjustment for selection utility (Murphy, 1986)

Adjusts the expected standardized criterion score of accepted hires when
offer recipients can decline. When the probability of accepting an offer
is *negatively* correlated with candidate quality (top candidates have
more outside options), the realized mean criterion of accepted hires is
below the mean of selected (offered) candidates.

## Usage

``` r
offer_rejection_adjustment(
  expected_z_offered,
  mode = c("uniform", "selective", "correlated"),
  acceptance_rate = 1,
  rho_quality_acceptance = 0,
  logit_intercept = NULL,
  logit_slope = NULL,
  n_offered = NULL
)
```

## Arguments

- expected_z_offered:

  Expected standardized score of offered candidates (e.g.,
  `selected_mean_z(selection_ratio)`).

- mode:

  One of `"uniform"`, `"selective"`, or `"correlated"`.

- acceptance_rate:

  Expected proportion of offers accepted (used in all three modes for
  the headcount-scaling output).

- rho_quality_acceptance:

  Correlation between standardized candidate quality and acceptance
  propensity (used for `mode = "correlated"`). Negative values reflect
  adverse selection (top candidates more likely to decline).

- logit_intercept, logit_slope:

  Logit link coefficients for `mode = "selective"`. The slope is
  typically negative for adverse selection.

- n_offered:

  Optional integer; if supplied, the function also returns the expected
  number of accepted hires.

## Value

A list with `expected_z_accepted`, `acceptance_rate`,
`effective_validity_loss` (the difference between offered and accepted
means), and optionally `expected_n_accepted`.

## Details

Three modes are supported:

- `mode = "uniform"`: a fixed acceptance probability `p` independent of
  candidate quality. The expected criterion of accepted hires equals the
  expected criterion of those offered, but the realized headcount is
  scaled by `p`.

- `mode = "selective"`: the probability of acceptance depends on
  candidate standardized quality `z` through a logit link
  `logit(p) = a + b * z` with `b < 0` for adverse selection. The
  adjusted mean criterion is computed by integrating the standard normal
  weighted by the acceptance probability.

- `mode = "correlated"`: a closed-form approximation under the
  assumption that quality and acceptance are jointly normal with
  correlation `rho_quality_acceptance`. The adjustment is
  \\\bar{z}\_{accepted} \approx \bar{z}\_{offered} + \rho \cdot
  (\lambda(z_p) - \bar{z}\_{offered})\\ for an acceptance threshold
  `z_p` derived from the expected acceptance rate.

## References

Hogarth, R. M., & Einhorn, H. J. (1976). Optimal strategies for
personnel selection when candidates can reject job offers. *Journal of
Business*, 49, 479-495.

Murphy, K. R. (1986). When your top choice turns you down: Effect of
rejected offers on the utility of selection tests. *Psychological
Bulletin*, 99, 133-138.

## Examples

``` r
z_offered <- selected_mean_z(0.20)

# Uniform 70% acceptance rate, no quality dependence:
offer_rejection_adjustment(z_offered, mode = "uniform",
                           acceptance_rate = 0.70, n_offered = 100)
#> <psu_offer_rejection>
#>   expected_z_offered: 1.39981
#>   expected_z_accepted: 1.39981
#>   acceptance_rate: 0.7
#>   effective_validity_loss: 0
#>   expected_n_accepted: 70

# Adverse selection: top candidates more likely to decline.
offer_rejection_adjustment(z_offered, mode = "correlated",
                           acceptance_rate = 0.70,
                           rho_quality_acceptance = -0.20,
                           n_offered = 100)
#> <psu_offer_rejection>
#>   expected_z_offered: 1.39981
#>   expected_z_accepted: 1.30047
#>   acceptance_rate: 0.7
#>   effective_validity_loss: 0.0993407
#>   expected_n_accepted: 70
```
