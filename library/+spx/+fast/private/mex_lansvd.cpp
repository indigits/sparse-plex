
#include <cstdlib>
#include <vector>
#include <mex.h>
#include "argcheck.h"
#include "spx_lansvd.hpp"


const char* func_name = "mex_lansvd";

#define A_IN prhs[0]
#define OPTIONS_IN prhs[1]

#define U_OUT plhs[0]
#define S_OUT plhs[1]
#define V_OUT plhs[2]
#define A_OUT plhs[3]
#define B_OUT plhs[4]
#define P_OUT plhs[5] 
#define DETAILS_OUT plhs[6]

/**

TODO LIST

Input
- Sparse matrices
- Function handles


LAN BD
- Empty matrix
- Single column matrix
- ANORM estimation after 5 iterations
- Bailout conditions for early convergence
- Extended local reorthogonalization understanding
- force reorthogonalization understanding
- U indices computation under force reorth 
- est_norm flag should be reset at the right time

LAN SVD
- Error handling if the algorithm fails
- Return the convergence error bounds

*/

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray*prhs[])
{
    double* m_dict;
    double* m_x;

    check_num_input_args(nrhs, 1, 2);
    check_num_output_args(nlhs, 7, 7);

    spx::LanSVDOptions options;
    if (nrhs > 1) {
        /**
        For more details about handling structure arrays,
        see phonebook.c example.
        */
        check_is_struct(OPTIONS_IN, func_name, "options");
        check_struct_array_is_singleton(OPTIONS_IN, func_name, "options");
        mxArray* field;
        extract_int_field_from_struct(OPTIONS_IN, func_name, 
            "options.verbosity", "verbosity", options.verbosity);
        extract_int_field_from_struct(OPTIONS_IN, func_name, 
            "options.k", "k", options.k_req);
        extract_double_field_from_struct(OPTIONS_IN, func_name,
            "options.lambda", "lambda", options.lambda);
        extract_double_field_from_struct(OPTIONS_IN, func_name,
            "options.delta", "delta", options.delta);
        extract_double_field_from_struct(OPTIONS_IN, func_name,
            "options.eta", "eta", options.eta);
        extract_double_field_from_struct(OPTIONS_IN, func_name,
            "options.gamma", "gamma", options.gamma);
        extract_double_field_from_struct(OPTIONS_IN, func_name,
            "options.tolerance", "tolerance", options.tolerance);
        extract_int_field_from_struct(OPTIONS_IN, func_name, 
            "options.max_iters", "max_iters", options.max_iters);
        extract_double_vec_field_from_struct(OPTIONS_IN, func_name,
            "options.p0", "p0", &(options.p0));
        field = mxGetField(OPTIONS_IN, 0, "p0");
        if (options.verbosity > 0) {
            mexPrintf("verbosity: %d\n", options.verbosity);
            mexPrintf("k: %d\n", options.k_req);
            mexPrintf("lambda: %.4f\n", options.lambda);
            mexPrintf("delta: %.4f\n", options.delta);
            mexPrintf("eta: %.4f\n", options.eta);
            mexPrintf("gamma: %.4f\n", options.gamma);
            mexPrintf("tolerance: %.4f\n", options.tolerance);
            mexPrintf("max_iters: %d\n", options.max_iters);
            mexPrintf("p0 is user specified.\n");
        }
    }
    try {
        if (options.verbosity >= 2) {
            mexPrintf("Constructing LanSVD Solver.\n");
        }
        spx::LanSVD solver(A_IN, options);
        if(options.verbosity >= 2){
            mexPrintf("Running LanSVD Solver.\n");
        }
        // Carry out the Lanczos Bidiagonalization with
        // Partial Reorthogonalization process to
        // compute the required singular values
        solver();
        U_OUT = solver.transfer_u();
        S_OUT = solver.transfer_s();
        V_OUT = solver.transfer_v();
        A_OUT = solver.transfer_alpha();
        B_OUT = solver.transfer_beta();
        P_OUT = solver.transfer_p();
        DETAILS_OUT = solver.transfer_details();
    } catch (std::exception& e) {
        mexErrMsgTxt(e.what());
        return;
    }
}

