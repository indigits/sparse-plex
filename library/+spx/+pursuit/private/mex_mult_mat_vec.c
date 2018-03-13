

#include "argcheck.h"
#include "spxblas.h"
#include <mex.h>



#define A_IN prhs[0]
#define X_IN prhs[1]

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray*prhs[])
{
    double* A;
    double* x;
    double* y;
    size_t m, n, nx;

    check_num_input_args(nrhs, 2, 2);
    check_num_output_args(nlhs, 0,1);

    check_is_double_matrix(A_IN, "mex_mult_mat_vec", "A");
    check_is_double_vector(X_IN,  "mex_mult_mat_vec", "x");

    A = mxGetPr(A_IN);
    x = mxGetPr(X_IN);

    m = mxGetM(A_IN);
    n = mxGetN(A_IN);
    nx = mxGetM(X_IN);
    if (nx != n){
        mexErrMsgTxt("Dimensions mismatch");
    }

    plhs[0] = mxCreateDoubleMatrix(m, 1, mxREAL);
    y =  mxGetPr(plhs[0]);
    mult_mat_vec(1, A, x, y, m, n);
}
