#include <mex.h>
#include "blas.h"
#include "lapack.h"
#include "spx_svd.hpp"

#if !defined(_WIN32)
#define dbdsqr dbdsqr_
#define dlartg dlartg_
#define dgesvd dgesvd_
#define dgesdd dgesdd_
#define dlamch dlamch_
#define lsame lsame_
#define dlasr dlasr_
#define dlas2 dlas2_
#define dlasv2 dlasv2_
#define drot drot_
#endif

using namespace std;

namespace spx {

void svd_bd_square(const Vec& alpha, const Vec& beta, Vec& S, 
    Matrix* pU, Matrix* pVT, mwSignedIndex m){
    if (m < 0){
        m = alpha.length();
    }
    if (alpha.length() < m){
        throw std::length_error("alpha has insufficient elements.");
    }
    if (beta.length() < m -1){
        throw std::length_error("beta has insufficient elements.");
    }
    if (S.length() < m){
        throw std::length_error("S has insufficient space.");
    }
    if (pU != 0) {
        if(pU->columns() != m){
            throw std::length_error("U has incorrect dimensions.");
        }
    }
    if (pVT != 0) {
        if(pVT->rows() != pVT->columns()) {
            throw std::length_error("V must be square matrix.");
        }
        if(pVT->rows() != m){
            throw std::length_error("V has incorrect dimensions.");
        }
    }
    // Prepare for calling the bdsqr function
    double dummy = 0;
    char   uplo = 'U';
    // Number of columns in VT [i.e. length of V vectors]
    ptrdiff_t ncvt = 0;
    // Leading dimension of vt
    ptrdiff_t ldvt = 1;
    // Pointer to VT matrix
    double *vt = &dummy;
    if (pVT != 0) {
        ncvt = pVT->rows();
        ldvt = pVT->rows();
        vt = pVT->head();
    }
    // Number of rows in U
    ptrdiff_t nru = 0;
    // Leading dimension of U
    ptrdiff_t ldu = 1;
    // Pointer to U matrix data
    double *u = &dummy;
    if (pU != 0) {
        nru = pU->rows();
        ldu = pU->rows();
        u = pU->head();
    } 
    // No C matrix involved here
    ptrdiff_t ncc = 0;
    ptrdiff_t ldc = 1;
    double *c  = &dummy;
    // diagonal elements alpha
    double *d = S.head();
    // Copy alpha in to S
    memcpy(d, alpha.head(), m*sizeof(double));
    // subdiagonal elements
    // double *e = (double*) mxCalloc(m-1,sizeof(double));
    double *e = (double*) mxCalloc(m-1,sizeof(double));
    memcpy(e, beta.head(), (m-1)*sizeof(double));
    // Space for work in the algorithm
    double *work = (double*) mxCalloc(4*m-4,sizeof(double));
    ptrdiff_t info = 0;
    // mexPrintf("uplo: %c, m: %d, ncvt: %d, nru: %d, ncc: %d, ldvt: %d, ldu: %d, ldc: %d, info: %d\n",
    //     uplo, m, ncvt, nru, ncc, ldvt, ldu, ldc, info);
    dbdsqr(&uplo, &m, &ncvt, &nru, &ncc, d, e,
        vt, &ldvt, u, &ldu, c, &ldc, 
        work, &info);
    /* Free work arrays */
    mxFree(e);
    mxFree(work);
    if (info < 0) {
        throw std::invalid_argument("dbdsqr called with illegal arguments.");
    } else if (info > 0) {
        throw std::logic_error("BDSQR: singular values didn't converge.");        
    }
    // Everything went well.
}


void convert_bd_kp1xk_to_kxk(Vec& alpha, Vec& beta, double& c, double& s){
    if (alpha.length() < 1){
        // There is nothing to do
        return;
    }
    size_t n = alpha.length();
    if (n != beta.length()){
        throw std::length_error("Length of alpha and beta must be same.");
    }
    // local variables
    double f;
    double g;
    double cs;
    double sn;
    double r;
    int i;
    for (i=0; i < n-1; ++i){
        // rotate alpha[i], beta[i]
        f = alpha[i];
        g = beta[i];
        dlartg(&f, &g, &cs, &sn, &r);
        alpha[i] = r;
        beta[i] = sn*alpha[i+1];
        alpha[i+1] = cs*alpha[i+1];
    }
    // last iteration
    f = alpha[i];
    g = beta[i];
    dlartg(&f, &g, &cs, &sn, &r);
    alpha[i] = r;
    beta[i] = 0;
    c = cs;
    s = sn;
}


double norm_kp1xk_mat(const Vec& alpha, const Vec& beta){
    mwSize k = alpha.length();
    if (k != beta.length()){
        throw std::length_error("alpha beta should have same size.");
    }
    if (k < 2){
        throw std::length_error("Too small matrix.");
    }
    Vec alpha2(k);
    Vec beta2(k);
    // copy all coefficients from alpha
    alpha2 = alpha;
    // copy all coefficients from beta
    beta2 = beta;
    double cs = 0;
    double sn = 0;
    convert_bd_kp1xk_to_kxk(alpha2, beta2, cs, sn);
    // Space for singular values
    Vec S(k);
    Matrix U(1, k);
    U.set(0);
    U(0, k-1) = 1;
    svd_bd_square(alpha2, beta2, S, &U, 0);
    return S[0];
}

void gesvd_kp1xk(const Vec& alpha, const Vec& beta, Vec& s, Vec& u_bot){
    mwSize k = alpha.length();
    if (k < 2){
        throw std::length_error("Too small matrix.");
    }
    if (k != beta.length()){
        throw std::length_error("alpha beta should have same size.");
    }
    if (k > s.length()){
        throw std::length_error("singular values insufficient size.");
    }
    if (k > u_bot.length()){
        throw std::length_error("u_bot insufficient size.");
    }
    Matrix A(k+1, k);
    A.set(0);
    for (int i=0; i < k; ++i){
        A(i, i) = alpha[i];
        A(i+1, i) = beta[i];
    }
    ptrdiff_t m = A.rows();
    ptrdiff_t n = A.columns();
    ptrdiff_t lda = m;
    ptrdiff_t ldu = m; 
    ptrdiff_t ldvt = 1;
    char JOBU = 'O';
    char JOBV = 'N';
    /// dummy work variable
    double wkopt;
    ptrdiff_t info;
    //! Pointer to the beginning of the matrix
    double* a = A.head();
    /* Query and allocate the optimal workspace */
    ptrdiff_t lwork;
    {
        // We will try to solve using dgesvd
        lwork = -1;
        dgesvd(&JOBU, &JOBV, &m, &n, a, &lda, s.head(), 0, &ldu, 0, &ldvt, &wkopt, &lwork,
         &info );
        /// allocate workspace accordingly
        lwork = (ptrdiff_t)wkopt;
        double *work = new double[lwork];
        /* Compute SVD */
        dgesvd(&JOBU, &JOBV, &m, &n, a, &lda, s.head(), 0, &ldu, 0, &ldvt, work, &lwork,
         &info );
        delete[] work;
    }
    if (info != 0) {
        mexPrintf("dgesvd failed. info=%d, Now trying dgesdd.\n", info);
        // Reset A
        A.set(0);
        for (int i=0; i < k; ++i){
            A(i, i) = alpha[i];
            A(i+1, i) = beta[i];
        }
        // Try to solve using dgesdd
        // workspace size query
        char JOBZ = 'O';
        lwork = -1;
        double wkopt = 0;
        ptrdiff_t *iwork = new ptrdiff_t[8*k];
        lda = m;
        ldu = m;
        Matrix vt(n, n);
        ldvt = vt.rows();
        info = 0;
        dgesdd(&JOBZ, &m, &n, a, &lda, s.head(), 0, &ldu, vt.head(), &ldvt, &wkopt,
            &lwork, iwork, &info );
        /// allocate workspace accordingly
        lwork = (ptrdiff_t)wkopt;
        double *work = new double[lwork];
        dgesdd(&JOBZ, &m, &n, a, &lda, s.head(), 0, &ldu, vt.head(), &ldvt, work,
            &lwork, iwork, &info );
        delete[] work;
        delete[] iwork;
    }
    /* Check for convergence */
    if (info < 0) {
        mexPrintf("dgesdd failed: info=%d\n", info);
        throw std::invalid_argument("dgesdd: called with illegal arguments.");
    } else if( info > 0 ) {
        alpha.print("alpha: ");
        beta.print("beta: ");
        mexPrintf("info : %d\n", info);
        throw std::logic_error("dgesdd: singular values didn't converge.");     
    }
    // We can pick up the bottom row of U
    for (int i=0; i < n; ++i){
        u_bot[i] = A(m-1, i);
    }

#if 0
        if(mxIsNaN(alpha[i])){
            throw std::logic_error("alpha[i] is nan.");
        }
        if(mxIsNaN(beta[i])){
            throw std::logic_error("beta[i] is nan.");
        }
#endif

}

/***********************************************************
*
*  SVD of bidiagonal matrix using hybrid strategy of
*  Wilkinson shift based QR algorithm and implicit
*  zero shift based QR algorithm.
*
*  This code is adapted from dbdsqr.f LAPACK.
*
***********************************************************/

bool svd_bd_hizsqr(char uplo, const Vec& alpha, const Vec& beta, 
    Vec& S, Matrix* pU, Matrix* pVT, mwSignedIndex n, 
    const SVDBIHIZSQROptions& options){
    if (n < 0){
        n = alpha.length();
    }
    if (alpha.length() < n){
        throw std::length_error("d has insufficient elements.");
    }
    if (beta.length() < n -1){
        throw std::length_error("e has insufficient elements.");
    }
    if (S.length() < n){
        throw std::length_error("S has insufficient space.");
    }
    if (pU != 0) {
        if(pU->columns() != n){
            throw std::length_error("U has incorrect dimensions.");
        }
    }
    if (pVT != 0) {
        if(pVT->rows() != pVT->columns()) {
            throw std::length_error("V must be square matrix.");
        }
        if(pVT->rows() != n){
            throw std::length_error("V has incorrect dimensions.");
        }
    }
    /// flag indicating if the bidiagonal matrix is lower or upper triangular.
    bool lower = lsame(&uplo, "L");
    if (!lsame(&uplo, "U") && !lower){
        throw std::invalid_argument("uplo must be either U or L");
    }
    // Copy the values from alpha and beta
    S = alpha;
    double* d = S.head();
    Vec ee(n-1);
    ee =beta;
    double* e = ee.head();
    /// Parameters
    const double zero = 0.0;
    const double one = 1.0;
    // minus one
    const double negone = -1.0;
    // 1/100
    const double hndrth = 0.01;
    const double ten = 10.0;
    // hundred
    const double hndrd = 100.0;
    // minus 1/8
    const double meigth = -0.125;
    // max number of iterations
    int maxiter = 6;

    // check if singular vectors are desired
    bool rotate = (pU != 0 || pVT != 0);
    // n minus 1
    mwSignedIndex nm1 = n - 1;
    // twice of n minus 1
    mwSignedIndex nm12 = nm1  + nm1;
    // thrice of n minus 1
    mwSignedIndex nm13 = nm12 + nm1;
    mwSignedIndex idir = 0;
    // Relative machine precision
    double eps = dlamch("Epsilon");
    // Safe minimum such that 1/sfmin doesn't overflow
    double unfl = dlamch("Safe minimum");
    // variables for returning values from dlartg
    double cs;
    double sn;
    Vec cosines1(n+1);
    Vec sines1(n+1);
    Vec cosines2(n+1);
    Vec sines2(n+1);
    double r;
    // Number of U rows
    ptrdiff_t nru = 0;
    // Leading dimension of U
    ptrdiff_t ldu = 1;
    if (pU){
        nru = pU->rows();
        ldu = pU->rows();
    }
    // Number of VT columns
    ptrdiff_t ncvt = 0;
    // Leading dimension of VT
    ptrdiff_t ldvt = 1;
    if (pVT){
        ncvt = pVT->columns();
        ldvt = pVT->rows();
    }
    const char RR = 'R';
    const char VV = 'V';
    const char FF = 'F';
    if (lower){
        // We need to convert it into an
        // upper bidiagonal matrix
        for (int i=0; i < nm1; ++i){
            dlartg(&(d[i]), &(e[i]), &cs, &sn, &r);
            d[i] = r;
            e[i] = sn * d[i+1];
            d[i+1] = cs*d[i+1];
            cosines1[i] = cs;
            sines1[i] = sn;
        }
        //The rotations should be applied on U if needed
        if(pU){
            dlasr(&RR, &VV, &FF, &nru, &n, cosines1.head(), sines1.head(), pU->head(), &ldu);
        }
    }
    // tolerance
    double tolmul = max(ten, min(hndrd, pow(eps, meigth)));
    double tol = tolmul * eps;
    // Compute approximate maximum, minimum singular values
    double smax = 0;
    double smin = 0;
    for (int i=0; i < n; ++i){
        smax = max(smax, fabs(d[i]));
    }
    for(int i=0; i < nm1; ++i){
        smax = max(smax, fabs(e[i]));
    }
    double sminl = zero;
    double sminoa = 0;
    double mu = 0;
    double thresh = 0;
    if (tol >= 0){
        // Relative accuracy desired
        sminoa = fabs(d[0]);
        if(sminoa != 0){
            mu = sminoa;
            for (int i=1; i < n; ++i){
                mu = fabs(d[i]) * (mu / (mu + fabs(e[i-1])));
                sminoa = min(sminoa, mu);
                if (sminoa == 0){
                    break;
                }
            }
        }
        sminoa = sminoa / sqrt((double)n);
        thresh = max(tol * sminoa, maxiter*n*n*unfl);
    } else {
        // Absolute accuracy desired
        thresh = max(fabs(tol) * smax, maxiter*n*n*unfl);
    }
    // maximum number of iterations
    int maxit = maxiter * n * n;
    int maxitdivn = maxiter*n;
    int iterdivn = 0;
    int oldll = -1;
    int oldm = -1;
    bool converged = false;
    // index of the last element of unconverged part of matrix
    int m = n - 1;
    if (options.verbosity >= 2){
        mexPrintf("smax: %.2f, sminl: %.2f, sminoa: %.2f, tolmul: %.2f, tol: %e, thresh: %e, m: %d\n",
            smax, sminl, sminoa, tolmul, tol, thresh, m);
    }
    // temporary variables [counters]
    int ll;
    int lll;
    int iter = 0;
    int count = 0;
    double shift;
    double f, g, h;
    double sll;
    double oldcs, oldsn;
    double cosr, sinr;
    double cosl, sinl;
    double sig_min, sig_max;
    /// MAIN LOOP STARTS HERE
    for (; iter < maxit; ++count){
        if (options.verbosity >= 2){
            mexPrintf("Iteration [%d]\n", count);
        }
        if (options.verbosity >= 3){
            S.print("S");
            ee.print("e");
        }
        if (converged){
            break;
        }
        if (m <= 0){
            converged = true;
            break;
        }
        // Find the diagonal block of matrix to work upon
        {
            if ((tol < zero) && (fabs(d[m]) <= thresh)){
                d[m] = zero;
            }
            smax = abs(d[m]);
            smin = smax;
            for (ll= m-1; ll >= 0; --ll){
                // look at d and e in ll-th row
                double abss = fabs(d[ll]);
                double abse = fabs(e[ll]);
                if ((tol < zero) && (abss <= thresh)){
                    // Reset this diagonal entry to zero
                    d[ll] = zero;
                }
                if(abse <= thresh){
                    // We found the point of splitting
                    e[ll] = zero;
                    // matrix will split since e[ll] = 0
                    break;
                }
                smin = min(smin, abss);
                smax = max(smax, max(abss, abse));
            }
        }
        if (ll == m - 1) {
            // We have convergence of bottom singular value
            // We should deflate and continue
            if(options.verbosity >= 1){
                mexPrintf("sv [%d] converged.\n", m);
            }
            m = m - 1;
            continue;
        }
        // ll-th row has a zero e[ll]
        // ll+1 th row is the beginning of an unreduced part of matrix
        ll = ll + 1;
        if (options.verbosity >= 2){
            mexPrintf("ll: %d, m: %d, smin: %.2f, smax: %.2f \n", ll, m, smin, smax);
        }
        /*
        e[ll] through e[m-1] are non-zero
        e[ll -1] is zero
        Our sub-matrix of concern is

        x x . . . 
        . x . . .
        . . x x .
        . . . x x
        . . . . x
        
        - ll = 2
        - m = 4
        - d[ll] to d[m]
        - e[ll] to e[m-1]
        - row ll to row m
        - column ll to column m
        - row ll has d[ll], e[ll]
        - column ll has d[ll] and zeros below it
        - row m has d[m]
        - column m has e[m-1] and d[m]

        */
        if (ll == m-1){
            // This is a 2x2 block 
            // We provide special handling for 2x2 blocks
            if (options.verbosity >=2){
                mexPrintf("A 2 x 2 block has been found.\n");
            }
            // Focus on remaining matrix
            f = d[m-1];
            g = e[m-1];
            h = d[m];
            dlasv2(&f, &g, &h, &sig_min, &sig_max, &sinr, &cosr, &sinl, &cosl);
            d[m-1] = sig_max;
            e[m-1] = zero;
            d[m] = sig_min;
            if (pVT != 0){
                // We need to rotate the last two rows of V
                const ptrdiff_t n  = ncvt;
                double* dx = &((*pVT)(m-1, 0));
                const ptrdiff_t incx = ldvt;
                double* dy = &((*pVT)(m, 0));
                const ptrdiff_t incy = ldvt;
                drot(&n, dx, &incx, dy, &incy, &cosr, &sinr);
            }
            if (pU != 0){
                // We need to rotate the last two columns of U
                const ptrdiff_t n  = nru;
                double* dx = &((*pU)(0, m-1));
                const ptrdiff_t incx = 1;
                double* dy = &((*pU)(0, m));
                const ptrdiff_t incy = 1;
                drot(&n, dx, &incx, dy, &incy, &cosl, &sinl);
            }
            m = m - 2;
            continue;
        }
        if ((ll > oldm) || (m < oldll)){
            // We are working on a new sub-matrix
            // choose shift direction
            if (fabs(d[ll]) >= fabs(d[m])){
                // Chase bulge from top (big end) to bottom (small end)
                idir = 1;
                mexPrintf("Shift direction from top to bottom\n");
            } else {
                // chase bulge from bottom (big end) o top (small end)
                mexPrintf("Shift direction from bottom to top\n");
                idir = 2;
            }
        }
        // Apply convergence tests
        if (idir == 1){
            // Run convergence test in forward direction
            if ( (fabs(e[m-1])  <= fabs(tol) *fabs(d[m])) ||
                ((tol < zero)  && (fabs(e[m-1] <= thresh)))){
                if (options.verbosity >= 2){
                    mexPrintf("e[%d]: %e has converged. 111\n", m-1, e[m-1]);
                }
                e[m-1] = zero;
                continue;
            }
            if (tol >= zero){
                mu = fabs(d[ll]);
                sminl = mu;
                bool e_converged = false;
                for (int iii = ll; iii < m; ++iii){
                    if (fabs(e[iii]) <= tol * mu){
                        if (options.verbosity >= 2){
                            mexPrintf("e[%d]: %e has converged. 222\n", iii, e[iii]);
                        }
                        e[iii] = zero;
                        e_converged = true;
                        break;
                    }
                    mu = fabs(d[iii + 1]) * (mu / (mu + fabs(e[iii])));
                    sminl = min(sminl, mu);
                }
                if (e_converged){
                    // We move on to next iteration
                    continue;
                }
            }
        } else {
            // Run convergence tests in backward direction
            // Standard test to the top of the matrix
            if ((fabs(e[ll]) <= fabs(tol) * fabs(d[ll]) ) || 
                ((tol < zero) && (fabs(e[ll]) <= thresh) )){
                if (options.verbosity >= 2){
                    mexPrintf("e[%d]: %e has converged. 333\n", ll, e[ll]);
                }
                e[ll] = zero;
                continue;
            }
            if (tol >= zero){
                mu = fabs(d[m]);
                sminl = mu;
                bool e_converged = false;
                for (int iii = m-1; iii >= ll; --iii){
                    if (fabs(e[iii]) <= tol * mu){
                        if (options.verbosity >= 2){
                            mexPrintf("e[%d]: %e has converged. 444\n", iii, e[iii]);
                        }
                        e[iii] = zero;
                        e_converged = true;
                        break;
                    }
                    mu = fabs(d[iii]) * (mu / (mu + fabs(e[iii])));
                    sminl = min(sminl, mu);
                }
                if (e_converged){
                    // We move on to next iteration
                    continue;
                }
            }
        } // convergence test idir = 2
        oldll = ll;
        oldm = m;
        if (options.verbosity >= 2){
            mexPrintf("After convergence tests: sminl: %.2f, smax: %.2f\n", sminl, smax);
        }
        // Compute shift
        // first, test if shifting would ruin relative accuracy
        // if so set the shift to zero.
        if (options.verbosity >= 3){
            mexPrintf("zero_shift_test: SV ratio: %.2e, LHS: %.2e, RHS: %.2e\n",
            sminl / smax,
            n*tol*(sminl/smax), max(eps, hndrth*tol));
        }
        if ((tol >= zero) &&
         (n*tol*(sminl/smax) <= max(eps, hndrth*tol))
            ) {
            shift = zero;
        } else {
            // Compute the shift from 2x2 block at the end of the matrix
            if (idir == 1){
                // top to bottom
                sll = fabs(d[ll]);
                f = d[m-1];
                g = e[m-1];
                h = d[m];
            } else {
                sll = fabs(d[m]);
                f = d[ll];
                g = e[ll];
                h = d[ll+1];
            }
            dlas2(&f, &g, &h, &shift, &r);
            if(options.verbosity >=2){
                mexPrintf("Wilkinson shift: sll: %.2e, f: %.2e, g: %.2e, h: %.2e, min: %.2e, max: %.2e\n",
                    sll, f, g, h, shift, r);
            }
            // Test if shift is negligible, and if yes, set it to zero
            if (sll > zero){
                if (square(shift / sll) < eps) {
                    if (options.verbosity){
                        mexPrintf("shift is negligible.");
                    }
                    shift = zero;
                }
            }
        } // non-zero shift computation
        iter = iter + m - ll;
        // if shift is zero, then simplified QR iteration
        if (shift == zero){
            if (idir == 1){
                // chase bulge from top to bottom
                cs = one;
                if (options.verbosity >= 2){
                    mexPrintf("Chasing implicit zero shift bulge from top to bottom\n");
                }
                oldcs = one;
                for (int ii = ll; ii < m; ++ii){
                    f = d[ii] * cs;
                    g = e[ii];
                    dlartg(&f, &g, &cs, &sn, &r);
                    if (ii > ll){
                        e[ii-1] = oldsn * r;
                    }
                    f  = oldcs*r;
                    g = d[ii+1]*sn;
                    dlartg(&f, &g, &oldcs, &oldsn, &(d[ii]));
                    cosines1[ii - ll] = cs;
                    sines1[ii -ll] = sn;
                    cosines2[ii -ll] = oldcs;
                    sines2[ii -ll] = oldsn;
                }
                h = d[m] * cs;
                d[m] = h * oldcs;
                e[m-1] = h * oldsn;
                // TODO Update singular vectors
                if (pVT != 0){
                    // Update V
                }
                if (pU != 0){
                    // Update U
                }
                // Test convergence
                if (fabs(e[m-1]) <= thresh){
                    e[m-1] = zero;
                }
                // End top to bottom for zero shift
            } else {
                // bottom to top
                if (options.verbosity >= 2){
                    mexPrintf("Chasing implicit zero shift bulge from bottom to top\n");
                }
                cs = one;
                oldcs = one;
                for (int ii = m; ii > ll; --ii){
                    f = d[ii] * cs;
                    g = e[ii-1];
                    dlartg(&f, &g, &cs, &sn, &r);
                    if (ii < m){
                        e[ii] = oldsn * r;
                    }
                    f  = oldcs*r;
                    g = d[ii-1]*sn;
                    dlartg(&f, &g, &oldcs, &oldsn, &(d[ii]));
                    int iii = ii - ll - 1;
                    cosines1[iii] = cs;
                    sines1[iii] = -sn;
                    cosines2[iii] = oldcs;
                    sines2[iii] = -oldsn;
                }
                h = d[ll] * cs;
                d[ll] = h * oldcs;
                e[ll] = h * oldsn;
                // TODO Update singular vectors
                if (pVT != 0){
                    // Update V
                    const char side = 'L';
                    const char pivot = 'V';
                    const char direct  = 'B';
                    const ptrdiff_t mm = m - ll + 1;
                    const ptrdiff_t nn = ncvt;
                    const double* c = cosines2.head();
                    const double* s = sines2.head();
                    double* a = &((*pVT)(ll, 0));
                    //pVT->print_matrix("VT");
                    dlasr(&side, &pivot, &direct, &mm, &nn, c, s, a, &ldvt);
                    //pVT->print_matrix("VT");
                }
                if (pU != 0){
                    // Update U
                    const char side = 'R';
                    const char pivot = 'V';
                    const char direct  = 'B';
                    const ptrdiff_t mm = nru;
                    const ptrdiff_t nn = m - ll + 1;
                    const double* c = cosines1.head();
                    const double* s = sines1.head();
                    double* a = &((*pU)(0, ll));
                    dlasr(&side, &pivot, &direct, &mm, &nn, c, s, a, &ldu);
                }
                // Test convergence
                if (fabs(e[ll]) <= thresh){
                    e[ll] = zero;
                }
            }
        } else {
            // Wilkinson shift QR iteration
            if (idir == 1){
                // start chase bulge from top to bottom
                if (options.verbosity >= 2){
                    mexPrintf("Chasing Wilkinson shift bulge from top to bottom\n");
                }
                f = (fabs(d[ll]) - shift) * 
                    (sgn(d[ll]) + shift/d[ll]);
                g = e[ll];
                for (int ii=ll; ii < m; ++ii){
                    dlartg(&f, &g, &cosr, &sinr, &r);
                    if (ii > ll){
                        e[ii - 1] = r;
                    }
                    f = cosr * d[ii] + sinr * e[ii];
                    e[ii] = cosr * e[ii] - sinr * d[ii];
                    g = sinr * d[ii + 1];
                    d[ii+1] = cosr * d[ii+1];
                    dlartg(&f, &g, &cosl, &sinl, &r);
                    d[ii] = r;
                    f = cosl * e[ii] + sinl * d[ii+ 1];
                    d[ii+1] = cosl * d[ii+1] - sinl * e[ii];
                    if (ii < m-1){
                        g = sinl * e[ii+1];
                        e[ii+1] = cosl * e[ii+1];
                    }
                    int iii = ii -ll;
                    cosines1[iii] = cosr;
                    sines1[iii] = sinr;
                    cosines2[iii] = cosl;
                    sines2[iii] = sinl;
                }
                e[m-1] = f;
                // TODO Update singular vectors
                if (pVT != 0){
                    // Update V
                    const char side = 'L';
                    const char pivot = 'V';
                    const char direct  = 'F';
                    const ptrdiff_t mm = m - ll + 1;
                    const ptrdiff_t nn = ncvt;
                    const double* c = cosines1.head();
                    const double* s = sines1.head();
                    double* a = &((*pVT)(ll, 0));
                    //pVT->print_matrix("VT");
                    dlasr(&side, &pivot, &direct, &mm, &nn, c, s, a, &ldvt);
                    //pVT->print_matrix("VT");
                }
                if (pU != 0){
                    // Update U
                    const char side = 'R';
                    const char pivot = 'V';
                    const char direct  = 'F';
                    const ptrdiff_t mm = nru;
                    const ptrdiff_t nn = m - ll + 1;
                    const double* c = cosines2.head();
                    const double* s = sines2.head();
                    double* a = &((*pU)(0, ll));
                    dlasr(&side, &pivot, &direct, &mm, &nn, c, s, a, &ldu);
                }
                // Test convergence
                if (fabs(e[m-1]) <= thresh){
                    e[m-1] = zero;
                }
                // finish chase bulge from top to bottom
            } else {
                // start chase bulge from bottom to top
                if (options.verbosity >= 2){
                    mexPrintf("Chasing Wilkinson shift bulge from bottom to top\n");
                }
                f = (fabs(d[m]) - shift) * 
                    (sgn(d[m]) + shift/d[m]);
                g = e[m -1];
                for (int ii=m; ii > ll; --ii){
                    dlartg(&f, &g, &cosr, &sinr, &r);
                    if (ii < m){
                        e[ii] = r;
                    }
                    f = cosr * d[ii] + sinr * e[ii-1];
                    e[ii-1] = cosr * e[ii-1] - sinr * d[ii];
                    g = sinr * d[ii - 1];
                    d[ii-1] = cosr * d[ii-1];
                    dlartg(&f, &g, &cosl, &sinl, &r);
                    d[ii] = r;
                    f = cosl * e[ii-1] + sinl * d[ii - 1];
                    d[ii -1] = cosl * d[ii - 1] - sinl * e[ii - 1];
                    if (ii > ll + 1){
                        g = sinl * e[ii-2];
                        e[ii-2] = cosl * e[ii-2];
                    }
                    int iii = ii -ll  - 1;
                    cosines1[iii] = cosr;
                    sines1[iii] = sinr;
                    cosines2[iii]  = cosl;
                    sines2[iii] = sinl;
                }
                e[ll] = f;
                // Test convergence
                if (fabs(e[ll]) <= thresh){
                    e[ll] = zero;
                }
                // TODO Update singular vectors
                if (pVT != 0){
                    // Update V
                    const char side = 'L';
                    const char pivot = 'V';
                    const char direct  = 'B';
                    const ptrdiff_t mm = m - ll + 1;
                    const ptrdiff_t nn = ncvt;
                    const double* c = cosines2.head();
                    const double* s = sines2.head();
                    double* a = &((*pVT)(ll, 0));
                    //pVT->print_matrix("VT");
                    dlasr(&side, &pivot, &direct, &mm, &nn, c, s, a, &ldvt);
                    //pVT->print_matrix("VT");
                }
                if (pU != 0){
                    // Update U
                    const char side = 'R';
                    const char pivot = 'V';
                    const char direct  = 'B';
                    const ptrdiff_t mm = nru;
                    const ptrdiff_t nn = m - ll + 1;
                    const double* c = cosines1.head();
                    const double* s = sines1.head();
                    double* a = &((*pU)(0, ll));
                    dlasr(&side, &pivot, &direct, &mm, &nn, c, s, a, &ldu);
                }
                // finish chase bulge from bottom to top
            }
        }

    } // end for over iterations
    if (!converged){
        // We ran out of max iterations
    } else {
        // All singular values have converged
        // Make sure that they are positive
        for (int i=0; i < n; ++i){
            if (d[i] < zero){
                d[i] = - d[i];
                if (pVT != 0){
                    // TODO Change the sign of singular vector also
                    pVT->scale_row(i, -1);
                }
            }
        } // sign change complete
        if (options.verbosity >= 3){
            mexPrintf("Results before sorting.");
            if(pU != 0){
                pU->print_matrix("U");
            }
            if (pVT != 0){
                pVT->print_matrix("VT");
            }
        }
        // sort the singular values in decreasing order
        // insertion sort on singular values
        // but only one transposition per singular vector
        for (int i = n-1; i > 0; --i){
            // search for the minimum element 
            int min_index = 0;
            smin = d[0];
            for (int j = 1; j <= i; ++j){
                if (d[j] <= smin) {
                    min_index = j;
                    smin = d[j];
                }
            }
            if (i != min_index){
                d[min_index] = d[i];
                d[i] = smin;
                // TODO swap singular vectors
                if(pVT != 0){
                    pVT->swap_rows(min_index, i);
                }
                if (pU != 0){
                    mexPrintf("U: Swapping col: %d, %d\n", min_index, i);
                    pU->swap_columns(min_index, i);
                }
            }
        }
    }
    return converged;
}


}