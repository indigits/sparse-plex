#include "spxla.h"
#include "blas.h"
#include "lapack.h"



#if !defined(_WIN32)

#ifndef dgesv
#define dgesv dgesv_
#endif

#endif

int linsolve(double A[], 
    double B[], 
    double X[], 
    mwSize m, mwSize n, mwSize p,
    int arr_type)
{   
    // Storage for pivots.
    mwSignedIndex ipiv[4000];
    mwSignedIndex lda = m;
    mwSignedIndex ldb = m;
    mwSignedIndex info;
    mwSignedIndex mm = m;
    mwSignedIndex nn = n;
    mwSignedIndex pp = p;
    if (m == n){
        mwSignedIndex x_size = n*p;
        mwSignedIndex  inc = 1;
        if (arr_type == 'G'){
            // It's a square matrix
            dgesv(&nn, &pp, A, &lda, ipiv, B, &ldb, &info);
            if( info > 0 ) {
                    mexPrintf( "The diagonal element of the triangular factor of A,\n" );
                    mexPrintf( "U(%i,%i) is zero, so that A is singular;\n", info, info );
                    mexPrintf( "the solution could not be computed.\n" );
                    return -1;
            }
            // Copy the solution
            dcopy(&x_size, B, &inc, X, &inc);
            return 0;
        }else if (arr_type == 'S'){
            char uplo = 'U';
            dposv(&uplo, &nn, &pp, A, &lda, B, &ldb, &info);            
            if( info > 0 ) {
                    mexPrintf( "The leading minor of order %i is not positive ", info );
                    mexPrintf( "definite;\nthe solution could not be computed.\n" );
                    return -1;
            }
            // Copy the solution
            dcopy(&x_size, B, &inc, X, &inc);
            return 0;
        }
    }
    else if (m > n){
        if (arr_type == 'G'){
            // We attempt a least square solution
            return least_square(A, B, X, m, n, p);
        }
    }
    return -1;
}

#define BLK_SIZE 128
#define LWORK_SIZE BLK_SIZE*4000

int least_square(double A[], 
    double B[], 
    double X[], 
    mwSize m, mwSize n, mwSize p){
    mwSignedIndex lda = m;
    mwSignedIndex ldb = m;
    mwSignedIndex mm = m;
    mwSignedIndex nn = n;
    mwSignedIndex pp = p;
    mwSignedIndex info;
    mwSignedIndex lwork = LWORK_SIZE;
    double work[LWORK_SIZE];
    mwSignedIndex  inc = 1;
    double* x = X;
    double* b = B;
    char trans = 'N';

    dgels(&trans, &mm, &nn, &pp, A, &lda, B, &ldb, work, &lwork,
                            &info );
    if( info > 0 ) {
        mexPrintf( "The diagonal element %i of the triangular factor ", info );
        mexPrintf( "of A is zero, so that A does not have full rank;\n" );
        mexPrintf( "the least squares solution could not be computed.\n" );
        return -1;
    }
    // Copy the solution from B to X only the first n rows.
    for (int i=0;i < p; ++i){
        dcopy(&nn, b, &inc, x, &inc);
        x += n;
        b += m;
    }
    return 0;
}

