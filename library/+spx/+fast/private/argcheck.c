#include "argcheck.h"
#include <math.h>

void check_num_input_args(int nrhs, int min_args, int max_args){
  char errmsg[1000];
  if (nrhs < min_args){
    sprintf(errmsg, "Insufficient number of input arguments.");
    mexErrMsgTxt(errmsg);
  }
  if (max_args > 0  && nrhs > max_args){
    sprintf(errmsg, "Too many input arguments.");
    mexErrMsgTxt(errmsg);
  }
}

void check_num_output_args(int nlhs, int min_args, int max_args){
  char errmsg[1000];
  if (nlhs < min_args){
    sprintf(errmsg, "Insufficient number of output arguments.");
    mexErrMsgTxt(errmsg);
  }
  if (max_args > 0  && nlhs > max_args){
    sprintf(errmsg, "Too many output arguments.");
    mexErrMsgTxt(errmsg);
  }

}



void check_is_double_matrix(const mxArray *arg, 
    char *function_name, char *arg_name){
  char errmsg[100];
  sprintf(errmsg, "%.15s: %.25s must be a double matrix.", function_name, arg_name);
  if (!mxIsDouble(arg) || mxIsComplex(arg) || mxGetNumberOfDimensions(arg)>2) {
    mexErrMsgTxt(errmsg);
  }
}


void check_is_double_vector(const mxArray *arg, 
    char *function_name, char *arg_name){
  char errmsg[100];
  sprintf(errmsg, "%.15s: %.25s must be a double vector.", function_name, arg_name);
  if (!mxIsDouble(arg) || mxIsComplex(arg) 
    || mxGetNumberOfDimensions(arg)>2
    || (mxGetM(arg)!=1 && mxGetN(arg)!=1)) {
    mexErrMsgTxt(errmsg);
  }
}

void check_is_double_scalar(const mxArray *arg, 
    char *function_name, char *arg_name){
  char errmsg[100];
  sprintf(errmsg, "%.15s: %.25s must be a double scalar.", function_name, arg_name);
  if (!mxIsDouble(arg) || mxIsComplex(arg) 
    || mxGetNumberOfDimensions(arg)>2
    || mxGetM(arg)!=1 
    || mxGetN(arg)!=1) {
    mexErrMsgTxt(errmsg);
  }
}


void check_is_sparse(const mxArray *arg, 
    char *function_name, char *arg_name){
  char errmsg[100];
  sprintf(errmsg, "%.15s: %.25s must be a sparse matrix.", function_name, arg_name);
  if (!mxIsSparse(arg)) {
    mexErrMsgTxt(errmsg);
  }
}
