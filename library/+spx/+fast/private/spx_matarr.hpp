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

//! Create a MATLAB structure array of length 1
mxArray* create_struct(const std::vector<std::string> &fields);

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

//! Converts a double vector to an MX Array
mxArray* d_vec_to_mx_array(const Vec& x, int n = -1);

}


#endif // _SPX_MATARR_HPP_

