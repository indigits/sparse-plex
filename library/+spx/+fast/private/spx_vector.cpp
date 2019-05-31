#include <stdexcept>
#include <random>
#include "spx_vector.hpp"
#include "spxblas.h"
#include "blas.h"
#include "lapack.h"
#include "stddef.h"

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

void print_d_vec(const d_vector& x, const std::string& name) {
    if (name.size() > 0) {
        mexPrintf("\n%s = \n\n", name.c_str());
    }
    int n = x.size();
    for (int i = 0; i < n; ++i) {
        mexPrintf("   %lf", x[i]);
    }
    mexPrintf("\n");
}
void print_i_vec(const i_vector& x, const std::string& name) {
    if (name.size() > 0) {
        mexPrintf("\n%s = \n\n", name.c_str());
    }
    int n = x.size();
    for (int i = 0; i < n; ++i) {
        mexPrintf("   %d", x[i]);
    }
    mexPrintf("\n");
}

void print_index_vec(const index_vector& x, const std::string& name) {
    if (name.size() > 0) {
        mexPrintf("\n%s = \n\n", name.c_str());
    }
    int n = x.size();
    for (int i = 0; i < n; ++i) {
        mexPrintf("   %d", x[i]);
    }
    mexPrintf("\n");
}


void print_sorted_asc_vec(const d_vector &v, const std::string& name) {
    if (name.size() > 0) {
        mexPrintf("\n%s = \n\n", name.c_str());
    }
    for (auto i : sort_asc_indices(v)) {
        mexPrintf("   %lf", v[i]);
    }
    mexPrintf("\n");
}


void square_inplace(d_vector& v) {
    size_t n = v.size();
    double* p_v = &v[0];
    for (int i = 0; i < n; ++i) {
        double value = *p_v;
        *p_v = value * value;
        ++p_v;
    }
}

void square(const d_vector& src, d_vector& dst) {
    size_t n = src.size();
    if (n > dst.size()) {
        throw std::logic_error("square: vector lengths mismatch");
    }
    const double* p_src = &src[0];
    double* p_dst = &dst[0];
    for (int i = 0; i < n; ++i) {
        double value = *p_src;
        *p_dst = value * value;
        ++p_src;
        ++p_dst;
    }
}


/**********************************************
 *
 *
 *  VEC CLASS IMPLEMENTATION
 *
 *
 *
 ***********************************************/

Vec::Vec(double* pVec, mwSize n, mwSignedIndex  inc):
    m_pVec(pVec),
    m_n(n),
    m_inc(inc) {

}

Vec::Vec(d_vector& vec):
m_pVec(&(vec[0])),
m_n(vec.size()),
m_inc(1){

}

Vec::Vec(const mxArray* vec):
m_pVec(mxGetPr(vec)),
m_n(mxGetM(vec)*mxGetN(vec)),
m_inc(1){

}

Vec::~Vec() {

}

mwIndex Vec::abx_max_index() const {
    mwSignedIndex  nn = m_n;
    mwSignedIndex  incx = m_inc;
    return idamax(&nn, m_pVec, &incx) - 1;
}

mwIndex Vec::max_index() const {
    double max_value;
    mwIndex index;
    this->max_index(max_value, index);
    return index;
}

void Vec::max_index(double& max_value, mwIndex& index) const {
    double val;
    const double* x = m_pVec;
    max_value = *x;
    index = 0;
    mwSize n = m_n;
    for (mwIndex k = 1; k < n; ++k) {
        val = x[k];
        if (val > max_value) {
            max_value = val;
            index = k;
        }
    }
    return;
}

void Vec::extract(const mwIndex indices[], Vec& out, mwSize k) const {
    if (k == 0 ) {
        k = out.m_n;
    }
    double* x = m_pVec;
    double* y = out.m_pVec;
    mwIndex inc = m_inc;
    mwIndex o_inc = out.m_inc;
    for (mwIndex i = 0; i < k; ++i) {
        mwIndex index = indices[i];
        if (index > m_n) {
            // We are outside the x
            continue;
        }
        *y = x[index * inc];
        y += o_inc;
    }
}

Vec& Vec::operator=(const double& value) {
    double* x = m_pVec;
    mwSignedIndex inc = m_inc;
    mwSize n = m_n;
    for (int i = 0; i < n; ++i) {
        *x = value;
        x += inc;
    }

}

Vec& Vec::operator = (const Vec &o) {
    // self assignment check
    if (this == &o) {
        return *this;
    }
    // Minimum of the two
    mwSize n = std::min(m_n, o.m_n);
    double* x = m_pVec;
    const double* y = o.m_pVec;
    mwSignedIndex x_inc = m_inc;
    mwSignedIndex y_inc = o.m_inc;
    for (mwIndex i = 0; i < n; ++i) {
        *x = *y;
        x += x_inc;
        y += y_inc;
    }
    return *this;
}

void Vec::elt_wise_square() {
    mwSize n = m_n;
    mwSignedIndex inc = m_inc;
    double* x = m_pVec;
    for (mwIndex i = 0 ; i < n; ++i) {
        *x = SQR(*x);
        x += inc;
    }
}

void Vec::elt_wise_square(Vec& out) const {
    mwSize n = std::min(m_n, out.m_n);
    mwSignedIndex x_inc = m_inc;
    const double* x = m_pVec;
    double* y = out.m_pVec;
    mwSignedIndex y_inc = out.m_inc;
    for (mwIndex i = 0 ; i < n; ++i) {
        *y = SQR(*x);
        x += x_inc;
        y += y_inc;
    }
}

void Vec::elt_wise_inv() {
    mwSize n = m_n;
    mwSignedIndex inc = m_inc;
    double* x = m_pVec;
    for (mwIndex i = 0 ; i < n; ++i) {
        double value = *x;
        if (value != 0) {
            *x = 1 / value;
        }
        else {
            *x = 0;
        }
        x += inc;
    }
}

double Vec::norm_squared() const {
    mwSize n = m_n;
    mwSignedIndex inc = m_inc;
    double* x = m_pVec;
    double result = 0;
    for (mwIndex i = 0 ; i < n; ++i) {
        result += SQR(*x);
        x += inc;
    }
    return result;
}

void Vec::add(const Vec& o, double alpha) {
    mwSignedIndex  nn = std::min(m_n, o.m_n);
    mwSignedIndex  incy = m_inc;
    mwSignedIndex incx = o.m_inc;
    double* y = m_pVec;
    const double* x = o.m_pVec;
    daxpy(&nn, &alpha, x, &incx, y, &incx);
}

void Vec::subtract(const Vec& o) {
    mwSize n = std::min(m_n, o.m_n);
    mwSignedIndex x_inc = m_inc;
    double* x = m_pVec;
    const double* y = o.m_pVec;
    mwSignedIndex y_inc = o.m_inc;
    for (mwIndex i = 0 ; i < n; ++i) {
        *x = (*x) - (*y);
        x += x_inc;
        y += y_inc;
    }
}

void Vec::multiply(const Vec& o) {
    mwSize n = std::min(m_n, o.m_n);
    mwSignedIndex x_inc = m_inc;
    double* x = m_pVec;
    const double* y = o.m_pVec;
    mwSignedIndex y_inc = o.m_inc;
    for (mwIndex i = 0 ; i < n; ++i) {
        *x = (*x) * (*y);
        x += x_inc;
        y += y_inc;
    }
}

double Vec::inner_product(const Vec& o) const {
    mwSignedIndex  nn = std::min(m_n, o.m_n);
    const double* x = m_pVec;
    const double* y = o.m_pVec;
    mwSignedIndex  x_inc = m_inc;
    mwSignedIndex  y_inc = o.m_inc;
    return ddot(&nn, x, &x_inc, y, &y_inc);
}

void Vec::init_uniform_real(double a, double b) {
    std::mt19937 gen(0);
    std::uniform_real_distribution<> dis(a, b);
    double* x = m_pVec;
    mwSignedIndex  x_inc = m_inc;
    // mexPrintf("inc: x_inc, n: m_n\n", x_inc, m_n);
    for (int n = 0; n < m_n; ++n) {
        double value = dis(gen);
        *x = value;
        x += x_inc;
    }
}

void Vec::print(const std::string& name) const {
    if (name.size() > 0) {
        mexPrintf("\n%s = \n\n", name.c_str());
    }
    int n = m_n;
    double* x = m_pVec;
    for (int i = 0; i < n; ++i) {
        mexPrintf("   %lf", *x);
        x += m_inc;
    }
    mexPrintf("\n");    
}

}