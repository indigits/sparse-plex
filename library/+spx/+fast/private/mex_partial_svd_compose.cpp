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

const double BLAS_CUTOFF = 0.2;

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray*prhs[])
{
    try {
        check_num_input_args(nrhs, 4, 5);
        check_num_output_args(nlhs, 0, 1);

        check_is_double_matrix(U_IN, func_name, "U");
        check_is_double_matrix(V_IN, func_name, "V");
        check_is_double_vector(I_IN, func_name, "I");
        check_is_double_vector(J_IN, func_name, "J");

        spx::MxFullMat U(U_IN);
        spx::MxFullMat V(V_IN);
        const spx::Matrix& mU = U.impl();
        const spx::Matrix& mV = V.impl();

        spx::Matrix* p_l3prod = 0;

        mwSize m = U.rows();
        mwSize l1 = U.columns();
        mwSize n = V.rows();
        mwSize l2 = V.columns();
        if (l1 != l2){
            mexErrMsgTxt("Inner dimensions of U and V do not agree");
            return;
        }
        spx::Vec I(I_IN);
        spx::Vec J(J_IN);

        mwSize num_indices = I.length();

        bool use_l3 = num_indices >= BLAS_CUTOFF * m * n;
        // mexPrintf("M = %d, N = %d, Total= %d, Needed= %d, L3=%d", 
        //     m, n, m*n,num_indices, use_l3);
        if (use_l3){
            p_l3prod = new spx::Matrix(m, n);
            spx::multiply(mU, mV, *p_l3prod, false, true);
        }
        Y_OUT = mxCreateDoubleMatrix(num_indices, 1, mxREAL);
        spx::Vec Y(Y_OUT);
        for (mwSize i=0; i < num_indices; ++i){
            // row number from U
            mwIndex k1 = I[i] - 1;
            // row number from V
            mwIndex k2 = J[i] - 1;
            if (use_l3){
                Y[i] = (*p_l3prod)(k1, k2);
            } else {
                spx::Vec v1 = mU.row_ref(k1);
                spx::Vec v2 = mV.row_ref(k2);
                Y[i] = v1.inner_product(v2);
            }
        }
        if (p_l3prod){
            delete p_l3prod;
            p_l3prod = 0;
        }
    } catch (std::exception& e) {
        mexErrMsgTxt(e.what());
        return;
    }
}
