#include <stdexcept>
#include "spx_vector.hpp"
#include "spxblas.h"

namespace spx {

/************************************************
 *  Utility functions
 ************************************************/

mxArray* d_vec_to_mx_array(const d_vector& x)
{
    mwSize N = x.size();
    mxArray* p_alpha = mxCreateDoubleMatrix(N, 1, mxREAL);
    double* m_alpha =  mxGetPr(p_alpha);
    copy_vec_vec(&x[0], m_alpha, N);
    return p_alpha;
}

void print_d_vec(const d_vector& x, const std::string& name){
    if (name.size() > 0) {
      mexPrintf("\n%s = \n\n", name.c_str());
    }
    int n = x.size();
    for (int i=0; i<n; ++i) {
        mexPrintf("   %lf", x[i]);
    }
    mexPrintf("\n");
}
void print_i_vec(const i_vector& x, const std::string& name){
    if (name.size() > 0) {
      mexPrintf("\n%s = \n\n", name.c_str());
    }
    int n = x.size();
    for (int i=0; i<n; ++i) {
        mexPrintf("   %d", x[i]);
    }
    mexPrintf("\n");
}

void print_index_vec(const index_vector& x, const std::string& name){
    if (name.size() > 0) {
      mexPrintf("\n%s = \n\n", name.c_str());
    }
    int n = x.size();
    for (int i=0; i<n; ++i) {
        mexPrintf("   %d", x[i]);
    }
    mexPrintf("\n");
}


void print_sorted_asc_vec(const d_vector &v, const std::string& name){
    if (name.size() > 0) {
      mexPrintf("\n%s = \n\n", name.c_str());
    }
    for (auto i: sort_asc_indices(v)) {
        mexPrintf("   %lf", v[i]);
    }
    mexPrintf("\n");
}


void square_inplace(d_vector& v) {
    size_t n = v.size();
    double* p_v = &v[0];
    for (int i=0; i < n; ++i) {
        double value = *p_v;
        *p_v = value * value;
        ++p_v;
    }
}

void square(const d_vector& src, d_vector& dst){
    size_t n = src.size();
    if (n > dst.size()) {
        throw std::logic_error("square: vector lengths mismatch");
    }
    const double* p_src = &src[0];
    double* p_dst = &dst[0];
    for (int i=0; i < n; ++i) {
        double value = *p_src;
        *p_dst = value * value;
        ++p_src;
        ++p_dst;
    }
}


}