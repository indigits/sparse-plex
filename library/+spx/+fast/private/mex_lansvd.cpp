
#include <cstdlib>
#include <vector>
#include <mex.h>
#include "argcheck.h"
#include "spx_lansvd.hpp"


const char* func_name = "mex_lansvd";

#define A_IN prhs[0]
#define K_IN prhs[1]
#define OPTIONS_IN prhs[2]

#define U_OUT plhs[0]
#define S_OUT plhs[1]
#define V_OUT plhs[2]
#define A_OUT plhs[3]
#define B_OUT plhs[4]
#define P_OUT plhs[5]

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
- 

LAN SVD
- Error handling if the algorithm fails
- Return the convergence error bounds

*/

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray*prhs[])
{
    double* m_dict;
    double* m_x;

    double eps = mxGetEps();
    check_num_input_args(nrhs, 1, 3);
    check_num_output_args(nlhs, 6, 6);

    check_is_double_matrix(A_IN, func_name, "A");

    // By default k is unspecified
    int k = -1;
    if (nrhs > 1) {
        check_is_double_scalar(K_IN, func_name, "k");
        k = (int) mxGetScalar(K_IN);
    }
    spx::LanSVDOptions options(eps, k);
    if (nrhs > 2) {
        /**
        For more details about handling structure arrays,
        see phonebook.c example.
        */
        check_is_struct(OPTIONS_IN, func_name, "options");
        mwSize     num_elements;
        int nfields;
        nfields = mxGetNumberOfFields(OPTIONS_IN);
        num_elements = mxGetNumberOfElements(OPTIONS_IN);
        if (num_elements != 1) {
            mexErrMsgTxt("Exactly one structure should be provided.");
        }
        mxArray* field;
        field = mxGetField(OPTIONS_IN, 0, "verbosity");
        if (field != NULL) {
            check_is_double_scalar(field, func_name, "options.verbosity");
            options.verbosity = (int) mxGetScalar(field);
            if (options.verbosity > 0) {
                mexPrintf("verbosity: %d\n", options.verbosity);
            }
        }
        field = mxGetField(OPTIONS_IN, 0, "delta");
        if (field != NULL) {
            check_is_double_scalar(field, func_name, "options.delta");
            options.delta = mxGetScalar(field);
            if (options.verbosity > 0) {
                mexPrintf("delta: %.4f\n", options.delta);
            }
        }
        field = mxGetField(OPTIONS_IN, 0, "tolerance");
        if (field != NULL) {
            check_is_double_scalar(field, func_name, "options.tolerance");
            options.tolerance = mxGetScalar(field);
            if (options.verbosity > 0) {
                mexPrintf("tolerance: %.4f\n", options.tolerance);
            }
        }
        field = mxGetField(OPTIONS_IN, 0, "max_iters");
        if (field != NULL) {
            check_is_double_scalar(field, func_name, "options.max_iters");
            options.max_iters = (int) mxGetScalar(field);
            if (options.verbosity > 0) {
                mexPrintf("max_iters: %d\n", options.max_iters);
            }
        }
        field = mxGetField(OPTIONS_IN, 0, "p0");
        if (field != NULL) {
            check_is_double_vector(field, func_name, "options.p0");
            options.p0 = field;
            if (options.verbosity > 0) {
                mexPrintf("p0 is user specified.\n");
            }
        }
    }
    try {
        if (options.verbosity >= 2) {
            mexPrintf("Constructing LanSVD Solver.\n");
        }
        spx::LanSVD solver(A_IN, k, options);
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
    } catch (std::exception& e) {
        mexErrMsgTxt(e.what());
        return;
    }
}

