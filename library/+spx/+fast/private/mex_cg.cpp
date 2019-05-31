
#include <cstdlib>
#include <vector>
#include <mex.h>
#include "argcheck.h"
#include "spx_cg.hpp"


const char* func_name = "mex_cg";

#define A_IN prhs[0]
#define B_IN prhs[1]
#define ITER_IN prhs[2]
#define EPS_IN prhs[3]
#define SPARSE_IN prhs[4]
#define VERBOSE prhs[5]

#define X_OUT plhs[0]

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray*prhs[])
{
    double* m_dict;
    double* m_x;

    check_num_input_args(nrhs, 2, 6);
    check_num_output_args(nlhs, 0,1);

    check_is_double_matrix(A_IN, func_name, "A");
    check_is_double_matrix(B_IN,  func_name, "b");

    int max_iters = 0;
    if (nrhs > 2){
        check_is_double_scalar(ITER_IN,  func_name, "max_iters");
        // Read the value of max_iters
        max_iters = mxGetScalar(ITER_IN);
    }

    double tolerance = 0;
    if (nrhs > 3){
        check_is_double_scalar(EPS_IN,  func_name, "tolerance");
        tolerance  = mxGetScalar(EPS_IN);
    }

    int sparse_output = 1;
    if (nrhs > 4){
        check_is_double_scalar(SPARSE_IN, func_name,"sparse");
        sparse_output = (int) mxGetScalar(SPARSE_IN);
    }

    int verbose = 0;
    if (nrhs > 5){
        check_is_double_scalar(VERBOSE, func_name, "verbose");
        verbose = (int) mxGetScalar(VERBOSE);
    }

    m_dict = mxGetPr(A_IN);
    m_x = mxGetPr(B_IN);

    size_t M, N, S;
    // Number of signal space dimension
    M = mxGetM(A_IN);
    // Number of atoms
    N = mxGetN(A_IN);
    if (M != mxGetM(B_IN)){
        mexErrMsgTxt("Dimensions mismatch");
    }
    if (M != N) {
        mexErrMsgTxt("A must be symmetric positive definite");
    }
    // Number of signals
    S = mxGetN(B_IN);
    if (S != 1) {
        mexErrMsgTxt("Only one vector supported at the moment");
    }
    if(verbose){
        mexPrintf("M: %d, N:%d, S: %d, max_iters: %d, tolerance: %e, sparse: %d, verbose: %d\n",
         M, N, S, max_iters, tolerance, sparse_output, verbose);
    }
    // Create Sparse Representation Vector
    spx::MxFullMat op(A_IN);
    spx::CongugateGradients cg (op);
    if (max_iters > 0) {
        cg.set_max_iterations(max_iters);
    }
    if (tolerance > 0) {
        cg.set_tolerance(tolerance);
    }
    if (verbose > 0){
        cg.set_verbose( (spx::VERBOSITY) verbose);
    }
    cg(m_x);
    X_OUT = spx::d_vec_to_mx_array(cg.get_x());
}

