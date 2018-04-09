

#include <mex.h>
#include "argcheck.h"
#include "spxblas.h"
#include "omp.h"


#define D_IN prhs[0]
#define X_IN prhs[1]
#define K_IN prhs[2]
#define EPS_IN prhs[3]
#define FACTOR_IN prhs[4]
#define CYCLE_IN prhs[5]
#define SPARSE_IN prhs[6]
#define VERBOSE prhs[7]

#define A_OUT plhs[0]

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray*prhs[])
{
    double* m_dict;
    double* m_x;
    int K;
    double eps = 0;
    double threshold_factor = 2;
    int reset_cycle = 5;
    int sparse_output = 1;
    int verbose = 0;

    size_t M, N, S;

    check_num_input_args(nrhs, 3, 8);
    check_num_output_args(nlhs, 0,1);

    check_is_double_matrix(D_IN, "mex_omp_ar", "D");
    check_is_double_matrix(X_IN,  "mex_omp_ar", "X");
    check_is_double_scalar(K_IN,  "mex_omp_ar", "K");
    // Read the value of K
    K = mxGetScalar(K_IN);
    if (nrhs > 3){
        check_is_double_scalar(EPS_IN,  "mex_omp_ar", "eps");
        eps  = mxGetScalar(EPS_IN);
    }
    if (nrhs > 4){
        check_is_double_scalar(FACTOR_IN, "mex_omp_ar","threshold_factor");
        threshold_factor = mxGetScalar(FACTOR_IN);
    }
    if (nrhs > 5){
        check_is_double_scalar(CYCLE_IN, "mex_omp_ar","reset_cycle");
        reset_cycle = (int) mxGetScalar(CYCLE_IN);
    }
    if (nrhs > 6){
        check_is_double_scalar(SPARSE_IN, "mex_omp_ar","sparse");
        sparse_output = (int) mxGetScalar(SPARSE_IN);
    }
    if (nrhs > 7){
        check_is_double_scalar(VERBOSE, "mex_omp_ar","verbose");
        verbose = (int) mxGetScalar(VERBOSE);
    }
    m_dict = mxGetPr(D_IN);
    m_x = mxGetPr(X_IN);
    // Number of signal space dimension
    M = mxGetM(D_IN);
    // Number of atoms
    N = mxGetN(D_IN);
    if (M != mxGetM(X_IN)){
        mexErrMsgTxt("Dimensions mismatch");
    }
    // Number of signals
    S = mxGetN(X_IN);
    if(verbose){
        mexPrintf("M: %d, N: %d, S: %d, K: %d, ", 
            M, N, S, K);
        mexPrintf("eps: %e, thr_factor: %.2f, reset_cycle: %d, sparse_output: %d, verbose: %d\n",
            eps, threshold_factor, reset_cycle, sparse_output, verbose);
    }

    // Create Sparse Representation Vector
    A_OUT = omp_ar(m_dict, m_x, M, N, S, K, 
        eps, threshold_factor, reset_cycle,
        sparse_output, verbose);
}

