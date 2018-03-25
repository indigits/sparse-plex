

#include <mex.h>
#include "argcheck.h"
#include "spxblas.h"
#include "omp.h"


#define D_IN prhs[0]
#define X_IN prhs[1]
#define K_IN prhs[2]
#define EPS_IN prhs[3]

#define A_OUT plhs[0]

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray*prhs[])
{
    double* m_dict;
    double* v_x;
    int K;
    double eps = 0;

    size_t M, N;

    check_num_input_args(nrhs, 3, 4);
    check_num_output_args(nlhs, 0,1);

    check_is_double_matrix(D_IN, "mex_omp_chol", "D");
    check_is_double_vector(X_IN,  "mex_omp_chol", "x");
    check_is_double_scalar(K_IN,  "mex_omp_chol", "K");
    // Read the value of K
    K = mxGetScalar(K_IN);
    if (nrhs > 3){
        check_is_double_scalar(EPS_IN,  "mex_omp_chol", "eps");
        eps  = mxGetScalar(EPS_IN);
    }

    m_dict = mxGetPr(D_IN);
    v_x = mxGetPr(X_IN);
    // Number of signal space dimension
    M = mxGetM(D_IN);
    // Number of atoms
    N = mxGetN(D_IN);
    if (M != mxGetM(X_IN)){
        mexErrMsgTxt("Dimensions mismatch");
    }
    // Create Sparse Representation Vector
    A_OUT = omp_chol(m_dict, v_x, M, N, K, eps);
}

