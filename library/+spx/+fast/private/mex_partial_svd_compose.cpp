#include <mex.h>
#include "argcheck.h"
#include "spx_matarr.hpp"
#include "spx_operator.hpp"
#include "spx_vector.hpp"

#define U_IN prhs[0]
#define V_IN prhs[1]
#define I_IN prhs[2]
#define J_IN prhs[3]

#define Y_OUT plhs[0]

const char* func_name = "mex_partial_svd_compose";


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray*prhs[])
{
    try {
        check_num_input_args(nrhs, 4, 4);
        check_num_output_args(nlhs, 0, 1);

        check_is_double_matrix(U_IN, func_name, "U");
        check_is_double_matrix(V_IN, func_name, "V");
        check_is_double_vector(I_IN, func_name, "I");
        check_is_double_vector(J_IN, func_name, "J");

        spx::MxFullMat U(U_IN);
        spx::MxFullMat V(V_IN);

        spx::Vec I(I_IN);
        spx::Vec J(J_IN);

        mwSize n = I.length();
        Y_OUT = mxCreateDoubleMatrix(n, 1, mxREAL);
    } catch (std::exception& e) {
        mexErrMsgTxt(e.what());
        return;
    }
}
