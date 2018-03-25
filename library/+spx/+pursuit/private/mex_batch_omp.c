

#include <mex.h>
#include "argcheck.h"
#include "spxblas.h"
#include "omp.h"


#define D_IN prhs[0]
#define X_IN prhs[1]
#define G_IN prhs[2]
#define DTX_IN prhs[3]
#define K_IN prhs[4]
#define EPS_IN prhs[5]

#define A_OUT plhs[0]

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray*prhs[])
{
    // Initialize input arguments
    BatchOMPInput in;
    in.m_dict = 0;
    in.m_gram = 0;
    in.m_x = 0;
    in.m_dtx = 0;
    in.M = in.N = in.K = in.S = 0;
    in.res_norm_bnd = 0;
    // Verify number of arguments
    check_num_input_args(nrhs, 5, 6);
    check_num_output_args(nlhs, 0,1);

    check_is_double_matrix(D_IN, "mex_omp_chol", "D");
    check_is_double_matrix(X_IN,  "mex_omp_chol", "X");
    check_is_double_matrix(G_IN, "mex_omp_chol", "G");
    check_is_double_matrix(DTX_IN, "mex_omp_chol", "DtX");
    check_is_double_scalar(K_IN,  "mex_omp_chol", "K");
    // Read the value of K
    in.K = (int)(mxGetScalar(K_IN) + 1e-2);
    if (nrhs > 4){
        check_is_double_scalar(EPS_IN,  "mex_omp_chol", "eps");
        in.res_norm_bnd  = mxGetScalar(EPS_IN);
    }
    // Check an argument for empty matrix before taking it.
    if (!mxIsEmpty(D_IN)){
        in.m_dict = mxGetPr(D_IN);
    }
    if (!mxIsEmpty(X_IN)){
        in.m_x = mxGetPr(X_IN);
    }
    if (!mxIsEmpty(G_IN)){
        in.m_gram = mxGetPr(G_IN);
    }
    if (!mxIsEmpty(DTX_IN)){
        in.m_dtx = mxGetPr(DTX_IN);
    }
    if (in.m_dict && in.m_x){
        // Number of signal space dimension
        in.M = mxGetM(D_IN);
        // Number of atoms
        in.N = mxGetN(D_IN);
        // Number of Signals
        in.S = mxGetN(X_IN);
        if (in.M != mxGetM(X_IN)){
            mexErrMsgTxt("Dimensions mismatch");
        }
    }
    else if(in.m_dtx){
        // Number of atoms
        in.N = mxGetM(DTX_IN);
        // Number of signals
        in.S = mxGetN(DTX_IN);
        // Signal space dimension is unknown
        // We pick a suitable value
        in.M = in.K;
        // Make sure that error norm mode is disabled.
        in.res_norm_bnd = 0;
    }
    else{
        mexErrMsgTxt("Either D  and X or DtX must be specified.");
    }
    if (in.m_gram == 0){
        mexErrMsgTxt("Gram matrix must be specified.");
    }
    if (mxGetM(G_IN) != mxGetN(G_IN)){
        mexErrMsgTxt("Gram matrix must be square.");
    }
    if (in.N != mxGetM(G_IN)){
        mexErrMsgTxt("Gram matrix has wrong dimensions.");
    }
    if(in.S < 1){
        mexErrMsgTxt("No signals for sparse coding.");
    }
    // Create Sparse Representation Vector
    A_OUT = batch_omp_gram(&in);
}

