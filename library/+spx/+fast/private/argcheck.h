/**
Implements routines for verifying correctness of arguments.
*/

#ifndef _ARG_CHECK_H_
#define _ARG_CHECK_H_ 1

#include "mex.h"

/// Check on number of input arguments
void check_num_input_args(int nrhs, int min_args, int max_args);
/// Check on number of output arguments
void check_num_output_args(int nlhs, int min_args, int max_args);


// General error message with function name
void error_msg(const char *function_name, const char *message);


//! Checks if an argument is a double matrix
void check_is_double_matrix(const mxArray *arg, 
    const char *function_name, const char *arg_name);


//! Checks if an argument is a double vector
void check_is_double_vector(const mxArray *arg, 
    const char *function_name, const char *arg_name);


//! Checks if an argument is a double scalar
void check_is_double_scalar(const mxArray *arg, 
    const char *function_name, const char *arg_name);

//! Checks if an argument is a sparse matrix
void check_is_sparse(const mxArray *arg, 
    const char *function_name, const char *arg_name);

//! Checks if an argument is a structure
void check_is_struct(const mxArray *arg, 
    const char *function_name, const char *arg_name);

//! Checks if a structure array has just one element
void check_struct_array_is_singleton(const mxArray *arg, 
    const char *function_name, const char *arg_name);


//! Checks that the input is a character scalar
void check_is_char_scalar(const mxArray *arg,
  const char *function_name, const char *arg_name);

//! Returns the first character in character array
mxChar get_mx_char(const mxArray* arg);

#endif
