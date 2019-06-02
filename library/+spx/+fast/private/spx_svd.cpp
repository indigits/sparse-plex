#include <mex.h>
#include "blas.h"
#include "lapack.h"
#include "spx_svd.hpp"

#if !defined(_WIN32)
#define dbdsqr dbdsqr_
#endif

namespace spx {

void svd_bd_square(const Vec& alpha, const Vec& beta, Vec& S, Matrix* pU, Matrix* pVT){
    if (alpha.length() != beta.length() + 1) {
        throw std::length_error("Length of subdiagonal incorrect.");
    }
    mwSignedIndex m = alpha.length();
    if (S.length() != m){
        throw std::length_error("S has incorrect length.");
    }
    if (pU) {
        if(pU->columns() != m){
            throw std::length_error("U has incorrect dimensions.");
        }
    }
    if (pVT) {
        if(pVT->rows() != pVT->columns()) {
            throw std::length_error("V must be square matrix.");
        }
        if(pVT->rows() != m){
            throw std::length_error("V has incorrect dimensions.");
        }
    }
    // Prepare for calling the bdsqr function
    ptrdiff_t zero = 0;
    ptrdiff_t one = 1;
    double dummy = 0;
    char   uplo = 'U';
    const ptrdiff_t *n = &m;
    // Number of columns in VT [i.e. length of V vectors]
    const ptrdiff_t *ncvt = &zero;
    // Leading dimension of vt
    const ptrdiff_t *ldvt = &one;
    // Pointer to VT matrix
    double *vt = &dummy;
    if (pVT != 0) {
        ncvt = &m;
        ldvt = &m;
        vt = pVT->head();
    }
    // Number of rows in U
    ptrdiff_t nru = zero;
    // Leading dimension of U
    ptrdiff_t ldu = one;
    // Pointer to U matrix data
    double *u = &dummy;
    if (pU != 0) {
        nru = pU->rows();
        ldu = pU->rows();
        u = pU->head();
    } 
    // No C matrix involved here
    const ptrdiff_t *ncc = &zero;
    const ptrdiff_t *ldc = &one;
    double *c  = &dummy;
    // diagonal elements alpha
    double *d = S.head();
    // Copy alpha in to S
    memcpy(d, alpha.head(), m*sizeof(double));
    // subdiagonal elements
    double *e = (double*) mxCalloc(m-1,sizeof(double));
    memcpy(e,beta.head(), (m-1)*sizeof(double));
    // Space for work in the algorithm
    double *work = (double*) mxCalloc(4*m-4,sizeof(double));
    ptrdiff_t info = 0;

    dbdsqr(&uplo, n, ncvt, &nru, ncc, d, e,
        vt, ldvt, u, &ldu, c, ldc, 
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


}