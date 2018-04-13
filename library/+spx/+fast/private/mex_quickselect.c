

#include "argcheck.h"
#include "spxalg.h"
#include <mex.h>


const char* func_name = "mex_quickselect";


#define X_IN prhs[0]
#define K_IN prhs[1]

#define Y_OUT plhs[0]
#define I_OUT plhs[1]

#define MAX_ARR_SIZE 1000000

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray*prhs[])
{
    double* y;
    mwIndex n, k = 1;
    mwIndex indices[MAX_ARR_SIZE];

    check_num_input_args(nrhs, 1, 2);
    check_num_output_args(nlhs, 0,1);

    check_is_double_vector(X_IN,  func_name, "x");
    n = mxGetNumberOfElements(X_IN);
    if (n == 0){
        error_msg(func_name, "empty vector");
    }
    if (n > MAX_ARR_SIZE){
        error_msg(func_name, "too large array");
    }
    if (nrhs > 1){
        check_is_double_scalar(K_IN, func_name,"k");
        k = (int) mxGetScalar(K_IN);
    }
    if (k > n){
        error_msg(func_name, "k must be less than length of x.");
    }
    Y_OUT = mxDuplicateArray(X_IN);
    y =  mxGetPr(Y_OUT);
    for (int i=0; i < n; ++i){
        indices[i] = i;
    }
    quickselect_desc(y, indices, n, k);
}

