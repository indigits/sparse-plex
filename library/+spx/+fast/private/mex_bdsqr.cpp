#include <stdio.h>
#include <string.h>
#include <mex.h>
#include "argcheck.h"

#include "blas.h"
#include "lapack.h"

#include "spx_svd.hpp"

const char* func_name="mex_bdsqr";

#define ALPHA_IN prhs[0]
#define BETA_IN prhs[1]


/**
USAGE :
    // Return the singular values
    mex_bdsqr(alpha, beta);
    // Return the singular values
    s  = mex_bdsqr(alpha, beta);
    // Return the singular values with left singular vectors
    u, s = mex_bdsqr(alpha, beta);
    // Return the singular values with all singular vectors
    u, s, vt = mex_bdsqr(alpha, beta);
*/
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray*prhs[]){
    check_num_input_args(nrhs, 2, 2);
    check_num_output_args(nlhs, 0, 3);
    check_is_double_vector(ALPHA_IN, func_name, "alpha");
    check_is_double_vector(BETA_IN,  func_name, "beta");

    mwSignedIndex m = mxGetM(ALPHA_IN)*mxGetN(ALPHA_IN);
    mwSignedIndex m2 = mxGetM(BETA_IN)*mxGetN(BETA_IN);
    if (m2 != m-1) {
        mexErrMsgTxt("Length of subdiagonal elements is incorrect.");
    }
    /// Store for left singular vectors
    mxArray *U = 0;
    /// Store for right singular vectors
    mxArray *VT = 0;
    /// Store for singular values
    mxArray *S = 0;
    // We always allocate space for singular values
    S  = mxCreateDoubleMatrix(m,1,mxREAL);
    if (nlhs >= 2){
        // U will be returned
        U = mxCreateDoubleMatrix(m,m,mxREAL);
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
    }
    spx::Matrix* pmVT = 0;
    if (VT != 0) {
        pmVT = new spx::Matrix(VT);
    }
    try {
        spx::svd_bd_square(v_alpha, v_beta, v_S, pmU, pmVT);
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
