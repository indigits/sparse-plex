
#include <cstdlib>
#include <vector>
#include <mex.h>
#include "argcheck.h"
#include "spx_assignment.hpp"


const char* func_name = "mex_mp";

#define A_IN prhs[0]
#define VERBOSE prhs[1]
#define A_OUT plhs[0]
#define COST_OUT plhs[1]

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray*prhs[])
{
    double* m_dict;
    double* m_x;

    check_num_input_args(nrhs, 1, 2);
    check_num_output_args(nlhs, 0,2);

    check_is_double_matrix(A_IN, func_name, "A");

    int verbose = 0;
    if (nrhs > 1){
        check_is_double_scalar(VERBOSE, func_name, "verbose");
        verbose = (int) mxGetScalar(VERBOSE);
    }
    size_t M, N, S;
    // Number of signal space dimension
    M = mxGetM(A_IN);
    // Number of atoms
    N = mxGetN(A_IN);
    if (M != N){
        mexErrMsgTxt("Cost matrix must be square");
    }
    // Create Sparse Representation Vector
    spx::MxFullMat op(A_IN);
    spx:: HungarianAssignment hg(op.impl());
    hg.set_verbose((spx::VERBOSITY) verbose);
    spx::d_vector result = hg();
    A_OUT = spx::d_vec_to_mx_array(result);
    if (nlhs > 1) {
        // We need to copy the cost value to output
        double cost = hg.best_cost();
        COST_OUT = mxCreateDoubleScalar(cost);
    }
}

