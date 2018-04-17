

#include <mex.h>
#include "argcheck.h"
#include "spxblas.h"
#include "omp.h"


const char* func_name = "mex_gomp";

#define D_IN prhs[0]
#define X_IN prhs[1]
#define K_IN prhs[2]
#define L_IN prhs[3]
#define T_IN prhs[4]
#define EPS_IN prhs[5]
#define SPARSE_IN prhs[6]
#define VERBOSE prhs[7]

#define A_OUT plhs[0]

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray*prhs[])
{
    double* m_dict;
    double* m_x;
    int K;
    int L = 2;
    double eps = 0;

    size_t M, N, S, T;
    int sparse_output = 1;
    int verbose = 0;
    // Number of vectors in MMV set
    T = 1;

    check_num_input_args(nrhs, 3, 8);
    check_num_output_args(nlhs, 0,1);

    check_is_double_matrix(D_IN, func_name, "D");
    check_is_double_matrix(X_IN,  func_name, "X");
    check_is_double_scalar(K_IN,  func_name, "K");
    // Read the value of K
    K = mxGetScalar(K_IN);
    if (nrhs > 3){
        check_is_double_scalar(L_IN,  func_name, "L");
        L  = mxGetScalar(L_IN);
    }
    if (nrhs > 4){
        check_is_double_scalar(T_IN,  func_name, "L");
        T  = mxGetScalar(T_IN);
    }
    if (nrhs > 5){
        check_is_double_scalar(EPS_IN,  func_name, "eps");
        eps  = mxGetScalar(EPS_IN);
    }
    if (nrhs > 6){
        check_is_double_scalar(SPARSE_IN, func_name,"sparse");
        sparse_output = (int) mxGetScalar(SPARSE_IN);
    }
    if (nrhs > 7){
        check_is_double_scalar(VERBOSE, func_name, "verbose");
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
    if (K*L > M){
        error_msg(func_name, "K*L is larger than M.");
    }
    // Number of signals
    S = mxGetN(X_IN);
    // Create Sparse Representation Vector
    if(verbose){
        mexPrintf("M: %d, N:%d, S: %d, K: %d, L: %d, T: %d, eps: %e, sparse: %d, verbose: %d\n",
         M, N, S, K, L, T, eps, sparse_output, verbose);
    }
    A_OUT = gomp_mmv_chol(m_dict, m_x, M, N, S, K, L, T, eps, sparse_output, verbose);
}

