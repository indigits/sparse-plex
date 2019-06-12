#include <mex.h>
#include "blas.h"
#include "lapack.h"
#include "spx_svd.hpp"

#if !defined(_WIN32)
#define dbdsqr dbdsqr_
#define dlartg dlartg_
#endif

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

}