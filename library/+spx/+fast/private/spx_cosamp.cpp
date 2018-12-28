#include <stdexcept>
#include "spx_pursuit.hpp"
#include "spxblas.h"
#include "spx_cg.hpp"

namespace spx {

CoSaMP::CoSaMP(const Operator& dict, mwIndex sparsity):
m_dict(dict),
m_sparsity(sparsity),
m_max_iterations(dict.rows()),
m_max_residual_norm(1e-12),
m_max_res_norm_ratio(1e-2), 
m_iterations(0),
m_verbose(QUIET),
m_sub_phi(dict.rows(), sparsity*3),
m_sub_gram_space(9*sparsity*sparsity),
m_sub_phi_t_x(3*sparsity),
m_z_3k_sqr(3*sparsity),
m_z_k(sparsity),
m_approximation(dict.rows()),
m_h(dict.columns()),
m_abs_h(dict.columns()),
m_representation(dict.columns())
{
    if (m_sparsity*4 > m_dict.columns()) {
        throw std::logic_error("Sparsity: too large.");
    }
    m_largest_3k_indices.reserve(3*m_sparsity);
    m_largest_k_indices.reserve(m_sparsity);
}

CoSaMP::~CoSaMP(){

}

void CoSaMP::operator()(const d_vector& x){
    (*this)(&x[0]);
}


/**

The steps involved are:

- Correlation / matching or residual with atoms
- Identification of largest 2K values and corresponding indices
- Merging of largest 2K indices with existing K indices
- Least squares estimation on 
  - Extraction of 3K columns from Phi as sub matrix
  - Computation of sub-gram matrix
  - Computation of sub_phi' x
  - Conjugate gradients for solving the least squares equation
- Identification of largest K coefficients in the least square estimate
- Approximation computation
- Residual update
*/
void CoSaMP::operator()(const double x[]) {
    // Initializations
    mwSize M = m_dict.rows();
    mwSize N = m_dict.columns();
    m_signal = x;
    // Copy the residual
    m_residual = d_vector(m_signal, m_signal + M);
    mwIndex iter = 0;
    //! Signal norm squared
    double x_norm_sqr = inner_product(m_signal, m_signal, M);
    //! Initial value of residual norm squared
    double res_norm_sqr = x_norm_sqr;
    //! Bound on the residual norm squared
    double res_norm_bnd_sqr = SQR(m_max_residual_norm);
    //! Maximum allowed value of ratio of residual norm to signal norm (squared)
    double max_norm_sqr_ratio = SQR(m_max_res_norm_ratio);
    m_res_norm_sqrs.resize(m_max_iterations + 1);
    m_res_norm_sqrs[0] = res_norm_sqr;
    //! Iterate till signal recovery is complete
    while (iter < m_max_iterations && res_norm_sqr > res_norm_bnd_sqr) {
        mexPrintf("Iteration: %d\n", iter+1);
        //! Match residual with atoms
        match();
        //! Identify 2K largest atoms and merge them with old K atoms
        identify_3k();
        //! Compute least squares estimate on 3K atoms
        least_square();
        //! Prune largest K entries
        prune_k();
        //! Compute the approximation
        update_approximation();
        res_norm_sqr = update_residual();
        m_res_norm_sqrs[iter+1] = res_norm_sqr;
        //! If residual is lower than a bound, we break
        if (res_norm_sqr < res_norm_bnd_sqr) {
            break;
        }
        // If residual norm is much lower than signal norm, we break
        if (res_norm_sqr / x_norm_sqr < max_norm_sqr_ratio) {
            break;
        }
        ++iter;
    }
    prepare_representation();
    print_d_vec(m_res_norm_sqrs, "residual norm squared s");
}

void CoSaMP::match(){
    double* p_r = &m_residual[0];
    double* p_h = &m_h[0];
    // Compute the correlation of residual with atoms h = Phi' r
    m_dict.mult_t_vec(p_r, p_h);
    // Compute square values of the correlations
    square_inplace(m_h);
    print_d_vec(m_h, "h");
    //print_sorted_asc_vec(m_h, "h sorted");
}

void CoSaMP::identify_3k(){
    mwIndex K = m_sparsity;
    //! partial sort for K largest values
    index_vector largest_2k_indices = partial_sort_desc_indices(m_h, 2*K);
    largest_2k_indices.resize(2*K);
    print_index_vec(largest_2k_indices, "largest_2k_indices");
    //! sort the largest 2 k indices 
    std::sort(largest_2k_indices.begin(), largest_2k_indices.end());
    print_index_vec(largest_2k_indices, "sorted largest_2k_indices");
    print_index_vec(m_largest_k_indices, "largest_k_indices");
    //! merge the 2K indices with existing K indices
    m_largest_3k_indices.resize(3*K);
    //! union of K old indices with 2K new indices
    auto end_iter = std::set_union(
        m_largest_k_indices.begin(), m_largest_k_indices.end(), 
        largest_2k_indices.begin(), largest_2k_indices.begin() + 2*K, 
        m_largest_3k_indices.begin());
    m_largest_3k_indices.resize(end_iter-m_largest_3k_indices.begin());
    print_index_vec(m_largest_3k_indices, "m_largest_3k_indices");
}


void CoSaMP::least_square() {
    //! extract the selected rows
    size_t num_3k_indices = m_largest_3k_indices.size();
    Matrix sub_phi(m_sub_phi, 0, num_3k_indices);
    m_dict.extract_columns(m_largest_3k_indices, sub_phi);
    sub_phi.print_matrix("sub_phi");
    //! Compute the gram matrix for this sub-matrix
    Matrix sub_gram(&m_sub_gram_space[0], num_3k_indices, num_3k_indices);
    sub_phi.gram(sub_gram);
    // sub_gram.print_matrix();
    //! Compute subphi' x
    double* p_xx  = &m_sub_phi_t_x[0]; 
    sub_phi.mult_t_vec(m_signal, p_xx);
    //! Estimation over the submatrix
    //! Apply Conjugate Gradients Solver
    spx::CongugateGradients cg(sub_gram);
    // cg.set_verbose(m_verbose);
    cg(p_xx);
    // if (max_iters > 0) {
    //     cg.set_max_iterations(max_iters);
    // }
    // if (tolerance > 0) {
    //     cg.set_tolerance(tolerance);
    // }
    m_z_3k = cg.get_x();
    print_d_vec(m_z_3k, "z_3k");
}

void CoSaMP::prune_k(){
    //! Pruning of largest K entries
    mwIndex K = m_sparsity;
    // Square the coefficients for sorting
    m_z_3k_sqr.resize(m_z_3k.size());
    square(m_z_3k, m_z_3k_sqr);
    print_d_vec(m_z_3k_sqr, "z_3k_sqr");
    m_sorted_3k = partial_sort_desc_indices(m_z_3k_sqr, K);
    print_index_vec(m_sorted_3k, "sorted_3k");
    m_largest_k_indices.resize(K);
    for (int iii=0; iii < K; ++iii){
        m_largest_k_indices[iii] = m_largest_3k_indices[m_sorted_3k[iii]];
        m_z_k[iii] = m_z_3k[m_sorted_3k[iii]];
    }
    //! sort the largest k indices
    std::sort(m_largest_k_indices.begin(), m_largest_k_indices.end());
    print_index_vec(m_largest_k_indices, "largest_k_indices");
    print_d_vec(m_z_k, "z_k");
}

void CoSaMP::update_approximation(){
    // Choose the first K indices and corresponding coefficients
    m_sub_phi.mult_submat_vec(&m_sorted_3k[0], m_sparsity, &m_z_k[0], &m_approximation[0]);
    print_d_vec(m_approximation, "approximation");
}


double CoSaMP::update_residual() {
    //! Compute the residual
    size_t M = m_approximation.size();
    double *p_r = &m_residual[0];
    v_subtract(m_signal, &m_approximation[0], p_r, M);
    print_d_vec(m_residual, "residual");
    double res_norm_sqr = inner_product(p_r, p_r, M);
    mexPrintf("res norm square: %e\n", res_norm_sqr);
    return res_norm_sqr;
}

void CoSaMP::prepare_representation(){
    // Copy the coefficients carefully to the result
    for (int iii=0; iii < m_sparsity; ++iii){
        m_representation[m_largest_3k_indices[m_sorted_3k[iii]]] = m_z_k[iii];
    }
}

}
