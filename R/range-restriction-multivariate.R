# =============================================================================
# Multivariate range-restriction correction (Lawley, 1943)
# =============================================================================

#' Multivariate range-restriction correction (Lawley, 1943)
#'
#' Corrects an observed (restricted) correlation matrix for direct selection
#' on a subset of variables and incidental selection on the remaining
#' variables, using Lawley's (1943) multivariate formulae.
#'
#' Let `S` index the variables on which selection was applied and `U` index
#' the remaining (incidentally restricted) variables. Given the observed
#' restricted covariance matrix `Sigma_star` and the unrestricted
#' covariance submatrix `Sigma_SS_unrestricted` for the selection variables,
#' Lawley's correction recovers the unrestricted covariance matrix:
#'
#' \deqn{\Sigma_{UV} = \Sigma_{UV}^{*} + \Sigma_{US}^{*}\, (\Sigma_{SS}^{*})^{-1}\, (\Sigma_{SS} - \Sigma_{SS}^{*})\, (\Sigma_{SS}^{*})^{-1}\, \Sigma_{SV}^{*}}
#' \deqn{\Sigma_{UU} = \Sigma_{UU}^{*} + \Sigma_{US}^{*}\, (\Sigma_{SS}^{*})^{-1}\, (\Sigma_{SS} - \Sigma_{SS}^{*})\, (\Sigma_{SS}^{*})^{-1}\, \Sigma_{SU}^{*}}
#'
#' for any partitioning into selection variables `S` and other variables `U,V`.
#'
#' @param sigma_restricted Observed (restricted) covariance or correlation
#'   matrix in the selected sample. Must be symmetric and positive
#'   semi-definite.
#' @param selection_indices Integer vector indicating which rows/columns of
#'   `sigma_restricted` correspond to variables on which selection was applied.
#' @param sigma_ss_unrestricted Unrestricted covariance submatrix for the
#'   selection variables (the same dimension as
#'   `sigma_restricted[selection_indices, selection_indices]`). Typically
#'   estimated from applicant-pool data.
#' @param standardize Logical. If `TRUE` (default), the corrected covariance
#'   matrix is converted to a correlation matrix via [stats::cov2cor()].
#'
#' @return A list with components:
#' \describe{
#'   \item{sigma_corrected}{The corrected (unrestricted) covariance or
#'     correlation matrix of the same dimension as `sigma_restricted`.}
#'   \item{sigma_restricted}{The input restricted matrix (echoed).}
#'   \item{selection_indices}{Indices treated as direct-selection variables.}
#'   \item{incidental_indices}{Indices treated as incidentally restricted.}
#'   \item{u}{Vector of `sd_restricted / sd_unrestricted` per selection
#'     variable, one of the standard summaries of restriction severity.}
#'   \item{sign_changes}{Integer count of off-diagonal entries whose sign
#'     differs between corrected and observed matrices, flagged in the spirit
#'     of Ree, Carretta, Earles & Albert (1994).}
#' }
#'
#' @details
#' Sign changes flagged in `sign_changes` are not necessarily errors but
#' should be inspected: Ree et al. (1994) documented that legitimate Lawley
#' corrections can flip the sign of small predictor-criterion correlations
#' when the restriction matrix is large.
#'
#' @references
#' Lawley, D. N. (1943). A note on Karl Pearson's selection formulae.
#' *Proceedings of the Royal Society of Edinburgh, Section A*, 62, 28-30.
#'
#' Mendoza, J. L., & Mumford, M. D. (1987). Corrections for attenuation and
#' range restriction on the predictor. *Journal of Educational and Behavioral
#' Statistics*, 12, 282-293.
#'
#' Ree, M. J., Carretta, T. R., Earles, J. A., & Albert, W. (1994). Sign
#' changes when correcting for range restriction: A note on Pearson's and
#' Lawley's selection formulas. *Journal of Applied Psychology*, 79, 298-301.
#'
#' Sackett, P. R., Lievens, F., Berry, C. M., & Landers, R. N. (2007). A
#' cautionary note on the effects of range restriction on predictor
#' intercorrelations. *Journal of Applied Psychology*, 92, 538-544.
#'
#' @examples
#' # Three-variable example: selection on X1 (cognitive ability),
#' # incidental restriction on X2 (interview) and Y (criterion).
#' sigma_star <- matrix(c(
#'   1.00, 0.30, 0.25,
#'   0.30, 1.00, 0.20,
#'   0.25, 0.20, 1.00
#' ), 3, 3)
#' # Unrestricted SD of X1 is larger; var increases by factor 1/u^2 = 1/.6^2
#' sigma_ss <- matrix(1 / 0.6^2, 1, 1)
#' correct_r_lawley(sigma_star, selection_indices = 1,
#'                  sigma_ss_unrestricted = sigma_ss)
#' @export
correct_r_lawley <- function(sigma_restricted, selection_indices,
                             sigma_ss_unrestricted, standardize = TRUE) {
  if (!is.matrix(sigma_restricted) || !isSymmetric(sigma_restricted))
    stop("`sigma_restricted` must be a symmetric matrix.", call. = FALSE)
  k <- nrow(sigma_restricted)
  selection_indices <- as.integer(selection_indices)
  if (any(selection_indices < 1L) || any(selection_indices > k) ||
      anyDuplicated(selection_indices))
    stop("`selection_indices` must be unique integers in 1:nrow(sigma_restricted).",
         call. = FALSE)
  if (!is.matrix(sigma_ss_unrestricted))
    sigma_ss_unrestricted <- as.matrix(sigma_ss_unrestricted)
  s <- length(selection_indices)
  if (!identical(dim(sigma_ss_unrestricted), c(s, s)))
    stop("`sigma_ss_unrestricted` must be a ", s, "x", s,
         " matrix matching `selection_indices`.", call. = FALSE)
  validate_correlation_matrix_like(sigma_restricted, "sigma_restricted",
                                   require_unit_diagonal = FALSE)
  validate_correlation_matrix_like(sigma_ss_unrestricted,
                                   "sigma_ss_unrestricted",
                                   require_unit_diagonal = FALSE)

  s_idx <- selection_indices
  u_idx <- setdiff(seq_len(k), s_idx)
  Sss_star <- sigma_restricted[s_idx, s_idx, drop = FALSE]
  Sss_unr  <- sigma_ss_unrestricted
  delta    <- Sss_unr - Sss_star
  Sss_inv  <- solve(Sss_star)

  corrected <- sigma_restricted
  corrected[s_idx, s_idx] <- Sss_unr
  if (length(u_idx) > 0L) {
    Sus_star <- sigma_restricted[u_idx, s_idx, drop = FALSE]
    Suu_star <- sigma_restricted[u_idx, u_idx, drop = FALSE]
    A <- Sus_star %*% Sss_inv
    corrected[u_idx, s_idx] <- A %*% Sss_unr
    corrected[s_idx, u_idx] <- t(corrected[u_idx, s_idx])
    corrected[u_idx, u_idx] <- Suu_star + A %*% delta %*% t(A)
  }

  if (standardize) {
    sds <- sqrt(diag(corrected))
    if (any(!is.finite(sds)) || any(sds <= 0))
      stop("Corrected matrix has non-positive diagonal; check inputs.",
           call. = FALSE)
    corrected <- corrected / tcrossprod(sds)
    diag(corrected) <- 1
  }

  u_ratios <- sqrt(diag(Sss_star) / diag(Sss_unr))
  off_diag <- function(m) m[lower.tri(m)]
  sign_changes <- sum(sign(off_diag(corrected)) !=
                        sign(off_diag(sigma_restricted)) &
                        off_diag(sigma_restricted) != 0 &
                        off_diag(corrected) != 0)

  list(
    sigma_corrected = corrected,
    sigma_restricted = sigma_restricted,
    selection_indices = s_idx,
    incidental_indices = u_idx,
    u = u_ratios,
    sign_changes = sign_changes
  )
}

# Internal helper: a more permissive validator that does not require unit
# diagonal (covariance matrices are allowed).
validate_correlation_matrix_like <- function(R, name,
                                             require_unit_diagonal = TRUE) {
  if (!is.matrix(R) || !isSymmetric(R, tol = 1e-8))
    stop("`", name, "` must be a symmetric matrix.", call. = FALSE)
  if (require_unit_diagonal && any(abs(diag(R) - 1) > 1e-8))
    stop("`", name, "` must have unit diagonal.", call. = FALSE)
  ev <- eigen(R, symmetric = TRUE, only.values = TRUE)$values
  if (min(ev) < -1e-8)
    stop("`", name, "` must be positive semi-definite.", call. = FALSE)
  invisible(TRUE)
}
