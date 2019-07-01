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

void error_msg(const char *function_name, const char *message){
  char errmsg[2048];
  sprintf(errmsg, "%s: %s", function_name, message);
  mexErrMsgTxt(errmsg);
}



void check_is_double_matrix(const mxArray *arg, 
    const char *function_name, const char *arg_name){
  char errmsg[100];
  sprintf(errmsg, "%.15s: %.25s must be a double matrix.", function_name, arg_name);
  if (!mxIsDouble(arg) || mxIsComplex(arg) || mxGetNumberOfDimensions(arg)>2) {
    mexErrMsgTxt(errmsg);
  }
}

void check_is_char_scalar(const mxArray *arg,
  const char *function_name, const char *arg_name){
  char errmsg[100];
  sprintf(errmsg, "%.15s: %.25s must be a character.", function_name, arg_name);
  if (!mxIsChar(arg) || mxGetNumberOfDimensions(arg)>2
    || mxGetM(arg)!=1 
    || mxGetN(arg)!=1){
    mexErrMsgTxt(errmsg);    
  }  
}

mxChar get_mx_char(const mxArray* arg){
  mxChar* data = mxGetChars(arg);
  if(data == 0){
    mexErrMsgTxt("Could not read character.");
  }
  return data[0];
}


void check_is_double_vector(const mxArray *arg, 
    const char *function_name, const char *arg_name){
  char errmsg[100];
  sprintf(errmsg, "%.15s: %.25s must be a double vector.", function_name, arg_name);
  if (!mxIsDouble(arg) || mxIsComplex(arg) 
    || mxGetNumberOfDimensions(arg)>2
    || (mxGetM(arg)!=1 && mxGetN(arg)!=1)) {
    mexErrMsgTxt(errmsg);
  }
}

void check_is_double_scalar(const mxArray *arg, 
    const char *function_name, const char *arg_name){
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
    const char *function_name, const char *arg_name){
  char errmsg[100];
  sprintf(errmsg, "%.15s: %.25s must be a sparse matrix.", function_name, arg_name);
  if (!mxIsSparse(arg)) {
    mexErrMsgTxt(errmsg);
  }
}

void check_is_struct(const mxArray *arg, 
    const char *function_name, const char *arg_name){
  char errmsg[100];
  sprintf(errmsg, "%.15s: %.25s must be a structure.", function_name, arg_name);
  if (!mxIsStruct(arg)) {
    mexErrMsgTxt(errmsg);
  }
}


void check_struct_array_is_singleton(const mxArray *arg, 
    const char *function_name, const char *arg_name){
  char errmsg[200];
  sprintf(errmsg, "%.15s: %.25s must be a structure.", function_name, arg_name);
  if (!mxIsStruct(arg)) {
    mexErrMsgTxt(errmsg);
  }
  mwSize     num_elements;
  num_elements = mxGetNumberOfElements(arg);
  if (num_elements != 1) {
    sprintf(errmsg, "%.15s: %.25s Exactly one structure should be provided.", function_name, arg_name);
    mexErrMsgTxt(errmsg);
  }
}

void extract_int_field_from_struct(const mxArray *arg, 
    const char *function_name, const char *arg_name, const char* field_name, int& output){
      mxArray* field = mxGetField(arg, 0, field_name);
      if (field != NULL) {
          check_is_double_scalar(field, function_name, arg_name);
          output = (int) mxGetScalar(field);
      }
}
void extract_double_field_from_struct(const mxArray *arg, 
    const char *function_name, const char *arg_name, const char* field_name, double& output){
      mxArray* field = mxGetField(arg, 0, field_name);
      if (field != NULL) {
          check_is_double_scalar(field, function_name, arg_name);
          output = mxGetScalar(field);
      }
}


void extract_double_vec_field_from_struct(const mxArray *arg, 
    const char *function_name, const char *arg_name, const char* field_name, mxArray** output){
        mxArray* field = mxGetField(arg, 0, field_name);
        if (field != NULL) {
          check_is_double_vector(field, function_name, arg_name);
          *output = field;
        }
}