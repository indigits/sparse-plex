#include <mex.h>
#include "argcheck.h"

#include "spx_operator.hpp"
#include "spx_vector.hpp"

const char* func_name = "mex_update_sparse_data";

#define A_IN prhs[0]
#define B_IN prhs[1]


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray*prhs[])
{
    try {
        check_num_input_args(nrhs, 2, 2);
        check_num_output_args(nlhs, 0, 0);
        spx::MxSparseMat A(A_IN);
        check_is_double_vector(B_IN,  func_name, "b");
        spx::Vec b(B_IN);
        A.update_values(b);
    } catch (std::exception& e) {
        mexErrMsgTxt(e.what());
        return;
    }
}
