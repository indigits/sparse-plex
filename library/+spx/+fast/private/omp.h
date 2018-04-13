#ifndef _OMP_H_
#define _OMP_H_ 1

#include "mex.h"

#define ALLOC_REAL_ARR(n) (double*)mxMalloc((n)*sizeof(double))

typedef struct {
    // Dictionary
    double* m_dict;
    // Gram matrix
    double* m_gram;
    // Signal Matrix
    double* m_x;
    // D' X proxy matrix
    double* m_dtx;
    // Signal Space Dimension
    mwSize M;
    // Number of Atoms
    mwSize N;
    // Sparsity Level
    mwSize K;
    // Number of Signals
    mwSize S;
    // Residual Norm Bound
    double res_norm_bnd;
} BatchOMPInput;


typedef enum{
    LS_LS = 0,
    LS_CHOL = 1,
    LS_QR = 2
}LS_METHOD;

/**
Computes the sparse representation of a vector x 
in the dictionary D using the Orthogonal Matching
Pursuit implemented with Cholesky update.

Solves:  D alpha = x
*/
mxArray* omp_chol(const double m_dict[], 
    const double m_x[],
    mwSize M, 
    mwSize N,
    mwSize S,
    mwSize K, 
    double res_norm_bnd,
    int sparse_output, // Whether output is sparse matrix
    int verbose // Verbose output (profiling data etc.)
    );

/**
An implementation of OMP where ls step is done
using standard least squares 
*/
mxArray* omp_ls(const double m_dict[], 
    const double m_x[],
    mwSize M, 
    mwSize N,
    mwSize S,
    mwSize K, 
    double res_norm_bnd,
    int sparse_output, // Whether output is sparse matrix
    int verbose // Verbose output (profiling data etc.)
    );

/**
Computes the sparse representation of a vector x 
in the dictionary D using the Orthogonal Matching
Pursuit with Atom Ranking extension
implemented with Cholesky update.

Solves:  D alpha = x
*/
mxArray* omp_ar(const double m_dict[], 
    const double m_x[],
    mwSize M, 
    mwSize N,
    mwSize S,
    mwSize K, // Sparsity level
    double res_norm_bnd, // Residual norm bound
    double threshold_factor, // norm square threshold
    int reset_cycle, // The cycle at which all correlations should be recomputed. 
    int sparse_output, // Whether output is sparse matrix
    int verbose // Verbose output (profiling data etc.)
);


/**
Computes the sparse representation of a set of vectors X
in the dictionary D using the OMP implemented with
Cholesky update and using the Gram matrix of the
dictionary.

Solve D A = X 

with G = D' D available.

*/
mxArray* batch_omp_gram(const BatchOMPInput* in);


/**
Computes the subspace preserving
representations of a dataset
using standard OMP with Cholesky acceleration.
*/
mxArray* omp_spr(double *m_dataset, // Dataset
    mwSize M, // Data dimension
    mwSize S, // Number of signals
    mwSize K, // Sparsity level
    double res_norm_bnd, // Residual norm bound
    int sparse_output // Whether output is sparse matrix
    );



/**
Computes the subspace preserving
representations of a dataset.
*/
mxArray* batch_omp_spr(double *m_dataset, // Dataset
    mwSize M, // Data dimension
    mwSize S, // Number of signals
    mwSize K, // Sparsity level
    double res_norm_bnd, // Residual norm bound
    int sparse_output // Whether output is sparse matrix
    );


/**
Computes the subspace preserving
representations of a dataset.
*/
mxArray* batch_flipped_omp_spr(double *m_dataset, // Dataset
    mwSize M, // Data dimension
    mwSize S, // Number of signals
    mwSize K, // Sparsity level
    double res_norm_bnd, // Residual norm bound
    int sparse_output // Whether output is sparse matrix
    );

void fill_vec_sparse_vals(const double values[],
    const mwIndex indices[], double output[], 
    mwSize n, mwSize k);

int chol_update(const double m_subdict[],
    const double v_atom[],
    double m_lt[],
    double v_b[],
    double v_w[],
    mwSize M,
    mwSize k
    );


#endif
