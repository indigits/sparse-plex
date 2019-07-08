/**

This code is inspired from the example in
https://in.mathworks.com/matlabcentral/answers/6411-matrix-multiplication-optimal-speed-and-memory

*/

#include <mex.h>
#include "argcheck.h"
#include "spx_matarr.hpp"
#include "spx_operator.hpp"
#include "spx_vector.hpp"

const char* func_name = "mex_sqrt_times";

#define S_IN prhs[0]
#define V_IN prhs[1]
#define FLAG_IN prhs[2]


#define A_OUT plhs[0]


void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray*prhs[])
{
    try {
        check_num_input_args(nrhs, 2, 3);
        check_num_output_args(nlhs, 0, 1);
        check_is_double_vector(S_IN, func_name, "S");
        check_is_double_matrix(V_IN, func_name, "V");
        spx::Vec S(S_IN);
        spx::Matrix V(V_IN);
        bool rows = false;
        if (nrhs > 2){
            check_is_double_scalar(FLAG_IN, func_name, "rows");
            rows = mxGetScalar(FLAG_IN) != 0;
        }
        if (rows){
            if (S.length() != V.rows()){
                mexErrMsgTxt("The number of eigen values must be same as number of rows of V");
            }
        } else{
            if (S.length() != V.columns()){
                mexErrMsgTxt("The number of eigen values must be same as number of columns of V");
            }
        }
        mwSize M = V.rows();
        mwSize N = V.columns();
        // Perform in place square root of S
        S.sqrt();
        if (rows){
            // Scale the rows of V
            for (int i=0; i < M; ++i){
                V.scale_row(i, S[i]);
            }
        } else {
            // Scale the columns of V
            for (int i=0; i < N; ++i){
                V.scale_column(i, S[i]);
            }
        }
    } catch (std::exception& e) {
        mexErrMsgTxt(e.what());
        return;
    }
}
