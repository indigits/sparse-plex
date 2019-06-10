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

mxArray* create_struct(const std::vector<std::string> &fields);

void set_struct_int_field(mxArray* s, int field_num, int value);

void set_struct_bool_field(mxArray* s, int field_num, bool value);

void set_struct_double_field(mxArray* s, int field_num, double value);

void set_struct_string_field(mxArray* s, int field_num, const std::string& value);

void set_struct_d_vec_field(mxArray* s, int field_num, const d_vector& value);


}


#endif // _SPX_MATARR_HPP_

