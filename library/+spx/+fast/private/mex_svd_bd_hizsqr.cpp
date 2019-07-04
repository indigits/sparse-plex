#include <stdio.h>
#include <string.h>
#include <mex.h>
#include "argcheck.h"
#include "spx_matarr.hpp"

#include "blas.h"
#include "lapack.h"

#include "spx_svd.hpp"

const char* func_name="mex_svd_bd_hizsqr";

#define ALPHA_IN prhs[0]
#define BETA_IN prhs[1]
#define OPTIONS_IN prhs[2]


/**
USAGE :
    // Return the singular values
    mex_svd_bd_hizqr(alpha, beta);
    // Return the singular values
    s  = mex_svd_bd_hizqr(alpha, beta);
    // Return the singular values with left singular vectors
    u, s = mex_svd_bd_hizqr(alpha, beta);
    // Return the singular values with all singular vectors
    u, s, vt = mex_svd_bd_hizqr(alpha, beta);
*/
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray*prhs[]){
    check_num_input_args(nrhs, 2, 3);
    check_num_output_args(nlhs, 0, 3);
    check_is_double_vector(ALPHA_IN, func_name, "alpha");
    check_is_double_vector(BETA_IN,  func_name, "beta");

    mwSignedIndex m = mxGetM(ALPHA_IN)*mxGetN(ALPHA_IN);
    mwSignedIndex m2 = mxGetM(BETA_IN)*mxGetN(BETA_IN);
    if (m2 != m-1) {
        mexErrMsgTxt("Length of subdiagonal elements is incorrect.");
    }
    spx::SVDBIHIZSQROptions options;
    mxArray* u_rows = 0;
    if (nrhs > 2){
        check_struct_array_is_singleton(OPTIONS_IN, func_name, "options");
        spx::extract_int_field_from_struct(OPTIONS_IN, func_name, "options.verbosity",
            "verbosity", options.verbosity);     
        if (options.verbosity > 0) {
            mexPrintf("verbosity: %d\n", options.verbosity);
        }
        spx::extract_double_vec_field_from_struct(OPTIONS_IN, func_name, "options.u_rows",
            "u_rows", &u_rows);
    }
    /// Store for left singular vectors
    mxArray *U = 0;
    /// Store for right singular vectors
    mxArray *VT = 0;
    /// Store for singular values
    mxArray *S = 0;
    // We always allocate space for singular values
    S  = mxCreateDoubleMatrix(m,1,mxREAL);
    int nru = 0;
    if (nlhs >= 2){
        nru = m;
        if (u_rows != 0) {
            nru = mxGetM(u_rows) * mxGetN(u_rows);
        }
        // U will be returned
        U = mxCreateDoubleMatrix(nru,m,mxREAL);
    }
    if (nlhs == 3){
        // V will be returned too
        VT = mxCreateDoubleMatrix(m,m,mxREAL);
    }
    // Assign the variables to output arguments
    switch(nlhs){
        case 0:
        case 1:
            plhs[0] = S;
            break;
        case 2:
            plhs[0] = U;
            plhs[1] = S;
            break;
        case 3:
            plhs[0] = U;
            plhs[1] = S;
            plhs[2] = VT;
            break;
    }

    spx::Vec v_alpha(ALPHA_IN);
    spx::Vec v_beta(BETA_IN);
    spx::Vec v_S(S);
    spx::Matrix* pmU = 0;
    if (U != 0) {
        pmU = new spx::Matrix(U);
        if (u_rows == 0) {
            pmU->set_diag(1);
        } else {
            int nru = mxGetM(u_rows) * mxGetN(u_rows);
            double* v = mxGetPr(u_rows);
            for (int i=0; i < nru; ++i) {
                int index = ((int) v[i]) - 1;
                if (index >= m) {
                    mexErrMsgTxt("Invalid row index for U.");
                }
                (*pmU)(i, index) = 1;
            }
        }
    }
    spx::Matrix* pmVT = 0;
    if (VT != 0) {
        pmVT = new spx::Matrix(VT);
        pmVT->set_diag(1);
    }
    try {
        spx::svd_bd_hizsqr('U', v_alpha, v_beta, v_S, pmU, pmVT, -1, options);
        if (pmU) {
            delete pmU;
            pmU = 0;
        }
        if(pmVT){
            delete pmVT;
            pmVT = 0;
        }
    } catch (std::exception& e) {
        if (pmU) {
            delete pmU;
            pmU = 0;
        }
        if(pmVT){
            delete pmVT;
            pmVT = 0;
        }
        mexErrMsgTxt(e.what());
        return;
    }
}
