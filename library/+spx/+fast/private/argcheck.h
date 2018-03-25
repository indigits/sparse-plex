/**
Implements routines for verifying correctness of arguments.
*/

#ifndef _ARG_CHECK_H_
#define _ARG_CHECK_H_ 1

#include "mex.h"

void check_num_input_args(int nrhs, int min_args, int max_args);
void check_num_output_args(int nlhs, int min_args, int max_args);

//! Checks if an argument is a double matrix
void check_is_double_matrix(const mxArray *arg, 
    char *function_name, char *arg_name);


//! Checks if an argument is a double vector
void check_is_double_vector(const mxArray *arg, 
    char *function_name, char *arg_name);


//! Checks if an argument is a double scalar
void check_is_double_scalar(const mxArray *arg, 
    char *function_name, char *arg_name);

//! Checks if an argument is a sparse matrix
void check_is_sparse(const mxArray *arg, 
    char *function_name, char *arg_name);

#endif
