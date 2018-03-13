

#include "argcheck.h"
#include "spxblas.h"
#include <mex.h>



#define A_IN prhs[0]
#define B_IN prhs[1]
#define X_OUT plhs[0]

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray*prhs[])
{
    double* A;
    double* B;
    double* X;

    size_t m, k, n;

    check_num_input_args(nrhs, 2, 2);
    check_num_output_args(nlhs, 0,1);

    check_is_double_matrix(A_IN, "mex_mult_mat_mat", "A");
    check_is_double_matrix(B_IN,  "mex_mult_mat_mat", "B");

    A = mxGetPr(A_IN);
    B = mxGetPr(B_IN);

    m = mxGetM(A_IN);
    k = mxGetN(A_IN);
    if (k != mxGetM(B_IN)){
        mexErrMsgTxt("Dimensions mismatch");
    }
    n = mxGetN(B_IN);

    X_OUT = mxCreateDoubleMatrix(m, n, mxREAL);
    X =  mxGetPr(X_OUT);
    mult_mat_mat(1, A, B, X, m, n, k);
}

