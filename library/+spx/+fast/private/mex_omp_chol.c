

#include <mex.h>
#include "argcheck.h"
#include "spxblas.h"
#include "omp.h"


const char* func_name = "mex_omp";

#define D_IN prhs[0]
#define X_IN prhs[1]
#define K_IN prhs[2]
#define EPS_IN prhs[3]
#define SPARSE_IN prhs[4]
#define LS_METHOD_IN prhs[5]
#define VERBOSE prhs[6]

#define A_OUT plhs[0]

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray*prhs[])
{
    double* m_dict;
    double* m_x;
    int K;
    double eps = 0;

    size_t M, N, S;
    int sparse_output = 1;
    int verbose = 0;
    LS_METHOD ls_method = LS_CHOL;

    check_num_input_args(nrhs, 3, 7);
    check_num_output_args(nlhs, 0,1);

    check_is_double_matrix(D_IN, func_name, "D");
    check_is_double_matrix(X_IN,  func_name, "X");
    check_is_double_scalar(K_IN,  func_name, "K");
    // Read the value of K
    K = mxGetScalar(K_IN);
    if (nrhs > 3){
        check_is_double_scalar(EPS_IN,  func_name, "eps");
        eps  = mxGetScalar(EPS_IN);
    }
    if (nrhs > 4){
        check_is_double_scalar(SPARSE_IN, func_name,"sparse");
        sparse_output = (int) mxGetScalar(SPARSE_IN);
    }
    if (nrhs > 5){
        check_is_double_scalar(LS_METHOD_IN, func_name, "ls_method");
        ls_method = (int) mxGetScalar(LS_METHOD_IN);
    }
    if (nrhs > 6){
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
    // Number of signals
    S = mxGetN(X_IN);
    // Create Sparse Representation Vector
    if(verbose){
        mexPrintf("M: %d, N:%d, S: %d, K: %d, eps: %e, sparse: %d, verbose: %d\n",
         M, N, S, K, eps, sparse_output, verbose);
    }
    switch(ls_method){
        case LS_CHOL:
            A_OUT = omp_chol(m_dict, m_x, M, N, S, K, eps, sparse_output, verbose);
            break;
        case LS_LS:
            A_OUT = omp_ls(m_dict, m_x, M, N, S, K, eps, sparse_output, verbose);
            break;
        default:
            error_msg(func_name, "Unsupported least squares method.");
            break;
    }
}

