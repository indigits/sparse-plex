#ifndef _SPX_MATARR_HPP_
#define _SPX_MATARR_HPP_ 1
/**
Helper functions to work with Matlab arrays
*/

#include <mex.h>
#include <vector>
#include <string>
#include "spx_vector.hpp"

namespace spx {

/************************************************
 *  Utility functions for MATLAB structures
 ************************************************/

//! Create a MATLAB structure array of length 1
mxArray* create_struct(const std::vector<std::string> &fields);

//! Extracts an integer field from struct if present
void extract_int_field_from_struct(const mxArray *arg, 
    const char *function_name, const char *arg_name, const char* field_name, int& output);
//! Extracts a double field from struct if present
void extract_double_field_from_struct(const mxArray *arg, 
    const char *function_name, const char *arg_name, const char* field_name, double& output);
//! Extracts a double vector field from struct if present
void extract_double_vec_field_from_struct(const mxArray *arg, 
    const char *function_name, const char *arg_name, const char* field_name, mxArray** output);


//! Fill an integer field in the structure
void set_struct_int_field(mxArray* s, int field_num, int value);

//! Fill a boolean field in the structure
void set_struct_bool_field(mxArray* s, int field_num, bool value);

//! Fill a double field in the structure
void set_struct_double_field(mxArray* s, int field_num, double value);

//! Fill a string field in the structure
void set_struct_string_field(mxArray* s, int field_num, const std::string& value);

//! Fill a double vector field in the structure
void set_struct_d_vec_field(mxArray* s, int field_num, const d_vector& value);


//! Checks if the structure has a double field or not
bool has_double_field(mxArray* s, const char* field_name);

//! Converts a double vector to an MX Array
mxArray* d_vec_to_mx_array(const Vec& x, int n = -1);

/************************************************
 *  Utility functions for full matrices
 ************************************************/

//! Resizes the number of elements of a Matlab vector
bool resize_mat_vec(mxArray *pVector, int n);

//! Resizes the number of columns of a full MATLAB matrix
bool resize_fullmat_columns(mxArray *pMatrix, int n);


}


#endif // _SPX_MATARR_HPP_

