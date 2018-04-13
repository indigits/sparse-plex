

#include "argcheck.h"
#include "spxblas.h"
#include "spxla.h"
#include <mex.h>


const char* func_name = "mex_linsolve";


#define A_IN prhs[0]
#define B_IN prhs[1]
#define ARR_TYPE_IN prhs[2]

#define X_OUT plhs[0]

#define MATRIX_LT  'L'
#define MATRIX_UT  'U'
#define MATRIX_D    'D'
#define MATRIX_GE   'G'
#define MATRIX_SYM  'S'


/**
Solves the problem AX = B.
*/
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray*prhs[])
{
    double* A;
    double* B;
    double* X;

    mxArray* A_COPY;
    mxArray* B_COPY;

    size_t m, n, p;
    int result;
    mxChar arr_type = 'G';

    check_num_input_args(nrhs, 2, 3);
    check_num_output_args(nlhs, 0,1);

    check_is_double_matrix(A_IN, func_name, "A");
    check_is_double_matrix(B_IN,  func_name, "B");
    if(nrhs > 2){
        check_is_char_scalar(ARR_TYPE_IN,  func_name, "arr_type");
        arr_type = get_mx_char(ARR_TYPE_IN);
    }

    m = mxGetM(A_IN);
    n = mxGetN(A_IN);
    p = mxGetN(B_IN);
    if (m != mxGetM(B_IN)){
        mexErrMsgTxt("Dimensions mismatch");
    }
    if (p < 1){
        mexErrMsgTxt("At least one problem must be specified to be solved.\n");
    }
    if (m > 4000 || n > 4000){
        mexErrMsgTxt("Matrices of this size are not supported.");
    }

    // Let's copy input data
    A_COPY = mxDuplicateArray(A_IN);
    B_COPY = mxDuplicateArray(B_IN);
    A = mxGetPr(A_COPY);
    B = mxGetPr(B_COPY);
    // Solution matrix
    X_OUT = mxCreateDoubleMatrix(n, p, mxREAL);
    X =  mxGetPr(X_OUT);
    result = linsolve(A, B, X, m, n, p, arr_type);
    // Let's free memory consumed by us
    mxDestroyArray(A_COPY);
    mxDestroyArray(B_COPY);
    if(result != 0){
        error_msg(func_name, "The problem could not be solved.\n");
    }
}


