#include "spx_pursuit.hpp"
#include "spxblas.h"

namespace spx {

MatchingPursuit::MatchingPursuit(const Operator& dict):
m_dict(dict),
m_max_iterations(4*dict.columns()),
m_max_residual_norm(1e-12),
m_max_res_norm_ratio(1e-6), 
m_iterations(0){

}

MatchingPursuit::~MatchingPursuit(){

}

void MatchingPursuit::operator()(const double x[]) {
    // Initializations
    mwSize M = m_dict.rows();
    mwSize N = m_dict.columns();
    m_z = d_vector(N, 0);
    m_h = d_vector(N, 0);
    // Copy the residual
    m_r = d_vector(x, x + M);
    double* p_r = &m_r[0];
    double* p_z = &m_z[0];
    double* p_h = &m_h[0];
    mwIndex index;
    mwIndex iter = 0;

    double x_norm_sqr = inner_product(x, x, M);
    double res_norm_sqr = inner_product(p_r, p_r, M);
    double res_norm_bnd_sqr = SQR(m_max_residual_norm);
    double max_norm_sqr_ratio = SQR(m_max_res_norm_ratio);
    while (iter < m_max_iterations && res_norm_sqr > res_norm_bnd_sqr) {
        m_dict.mult_t_vec(p_r, p_h);
        index = abs_max_index(p_h, N);
        double coeff = p_h[index];
        p_z[index] += coeff;
        m_dict.add_column_to_vec(-coeff, index, p_r);
        ++iter;
        res_norm_sqr = inner_product(p_r, p_r, M);
        // If residual norm is much lower than signal norm, we break
        if (res_norm_sqr / x_norm_sqr < max_norm_sqr_ratio) {
            break;
        }
    }
}

void MatchingPursuit::operator()(const d_vector& x){
    (*this)(&x[0]);
}


}
