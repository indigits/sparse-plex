
#include <cstdlib>
#include <vector>
#include <mex.h>
#include "argcheck.h"
#include "spx_pursuit.hpp"


const char* func_name = "mex_cosamp";

#define D_IN prhs[0]
#define X_IN prhs[1]
#define K_IN prhs[2]
#define EPS_IN prhs[3]
#define ITERATIONS_IN prhs[4]
#define SPARSE_IN prhs[5]
#define VERBOSE prhs[6]

#define A_OUT plhs[0]

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray*prhs[])
{
    double* m_dict;
    double* m_x;

    check_num_input_args(nrhs, 3, 6);
    check_num_output_args(nlhs, 0,1);

    check_is_double_matrix(D_IN, func_name, "D");
    m_dict = mxGetPr(D_IN);

    check_is_double_matrix(X_IN,  func_name, "X");
    m_x = mxGetPr(X_IN);

    int K = 0;
    if (nrhs > 2){
        check_is_double_scalar(K_IN,  func_name, "K");
        // Read the value of K
        K = mxGetScalar(K_IN);
    }

    double eps = 0;
    if (nrhs > 3){
        check_is_double_scalar(EPS_IN,  func_name, "eps");
        eps  = mxGetScalar(EPS_IN);
    }

    int iterations = 0;
    if (nrhs > 4){
        check_is_double_scalar(ITERATIONS_IN,  func_name, "iterations");
        // Read the value of iterations
        iterations = mxGetScalar(ITERATIONS_IN);
    }

    int sparse_output = 1;
    if (nrhs > 5){
        check_is_double_scalar(SPARSE_IN, func_name,"sparse");
        sparse_output = (int) mxGetScalar(SPARSE_IN);
    }

    int verbose = 0;
    if (nrhs > 6){
        check_is_double_scalar(VERBOSE, func_name, "verbose");
        verbose = (int) mxGetScalar(VERBOSE);
    }


    size_t M, N, S;
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
        mexPrintf("M: %d, N:%d, S: %d, K: %d, eps: %e, sparse: %d, verbose: %d\n",
         M, N, S, K, eps, sparse_output, verbose);
    }
    try {
        // Create Sparse Representation Vector
        spx::MxArray op(D_IN);
        spx::CoSaMP cosamp(op, K);
        if (eps > 0) {
            cosamp.set_max_residual_norm(eps);
        }
        if (iterations > 0) {
            cosamp.set_max_iterations(iterations);
        }
        cosamp(m_x);
        A_OUT = spx::d_vec_to_mx_array(cosamp.get_representation());
    } catch (std::exception& e) {
        mexErrMsgTxt(e.what());
        return;
    }
}

