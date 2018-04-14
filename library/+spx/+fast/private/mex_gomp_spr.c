

#include <mex.h>
#include "argcheck.h"
#include "spxblas.h"
#include "omp.h"


const char* func_name = "mex_gomp_spr";

#define Y_IN prhs[0]
#define K_IN prhs[1]
#define L_IN prhs[2]
#define EPS_IN prhs[3]
#define SPARSE_IN prhs[4]
#define VERBOSE prhs[5]

#define C_OUT plhs[0]

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray*prhs[])
{
    double* m_dataset;
    double* m_x;
    mwSize M = 0;
    mwSize S = 0;
    mwSize K = 0;
    mwSize L = 2;
    double res_norm_bnd = 0;
    int sparse_output = 1;
    int verbose = 0;

    check_num_input_args(nrhs, 2, 6);
    check_num_output_args(nlhs, 0,1);

    check_is_double_matrix(Y_IN, func_name, "Y");
    check_is_double_scalar(K_IN,  func_name, "K");
    // Read the value of K
    K = mxGetScalar(K_IN);
    if (nrhs > 2){
        check_is_double_scalar(L_IN,  func_name, "L");
        L  = (mwSize) mxGetScalar(L_IN);
    }
    if (L < 1){
        error_msg(func_name, "L is too small.");
    }
    if (L > 10){
        error_msg(func_name, "L is too large.");
    }
    if (nrhs > 3){
        check_is_double_scalar(EPS_IN,  func_name, "res_norm_bnd");
        res_norm_bnd  = mxGetScalar(EPS_IN);
    }
    if (nrhs > 4){
        check_is_double_scalar(SPARSE_IN, func_name,"sparse");
        sparse_output = (int) mxGetScalar(SPARSE_IN);
    }
    if (nrhs > 5){
        check_is_double_scalar(VERBOSE, func_name, "verbose");
        verbose = (int) mxGetScalar(VERBOSE);
    }
    if (mxIsEmpty(Y_IN)){
        error_msg(func_name, "Data set is empty.");
    }
    m_dataset = mxGetPr(Y_IN);
    // Number of signal space dimension
    M = mxGetM(Y_IN);
    // Number of atoms
    S = mxGetN(Y_IN);
    if (K*L > M){
        error_msg(func_name, "K*L is larger than M.");
    }
    // Create Sparse Representation Vector
    if(verbose){
        mexPrintf("M: %d, S: %d, K: %d, L: %d, res_norm_bnd: %e, sparse: %d, verbose: %d\n",
         M, S, K, L, res_norm_bnd, sparse_output, verbose);
    }
    // Create Sparse Representation matrix
    C_OUT = gomp_spr(m_dataset, M, S, K, L, res_norm_bnd, sparse_output, verbose);
}

