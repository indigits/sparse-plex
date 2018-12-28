#include "spx_cg.hpp"
#include "spxblas.h"

namespace spx {

CongugateGradients::CongugateGradients(const Operator& op):
m_op(op),
m_max_iterations(4*op.columns()),
m_tolerance(1e-3), 
m_iterations(0),
m_verbose(QUIET){

}

CongugateGradients::~CongugateGradients(){

}

/**
See slide 22 of Boyd lecture on conjugate gradients.


*/

void CongugateGradients::operator()(const double b[]) {
    // Initializations
    mwSize N = m_op.rows();
    //! Initialize x with zeros
    m_x = d_vector(N, 0);
    // ! Initialize residual with b
    m_r = d_vector(b, b+N);
    //! Initialize p with b
    m_p = d_vector(b, b+N);
    //! Allocate space for w
    m_w = d_vector(N);
    //! squared norm of b
    double b_norm_sqr = inner_product(b, b, N);
    //! squared norm of residual same as b
    double res_norm_sqr = b_norm_sqr;
    //! tolerance for norm reduction
    double tol_sqr = SQR(m_tolerance);
    //! Our best estimate for x so far is all zeros
    m_best_x = m_x;
    // x update coefficient with p
    double alpha;
    // ratio of new vs old norm
    double beta;
    // best value of beta tracked so far
    double best_beta = 1;
    // p' w
    double gamma;
    //! previous value of res norm squared
    double res_norm_sqr_prev = res_norm_sqr;
    // Pointers inside vectors
    double* p_r = &m_r[0];
    double* p_x = &m_x[0];
    double* p_w = &m_w[0];
    double* p_p = &m_p[0];
    m_profile.reset();
    while ((m_iterations < m_max_iterations) &&
    (res_norm_sqr > tol_sqr * b_norm_sqr) ) {
        // w = A p
        m_profile.tic();
        m_op.mult_vec(p_p, p_w);
        m_profile.log_w_update();
        
        // update x
        // p'*w
        gamma = inner_product(p_p, p_w, N);
        alpha = res_norm_sqr / gamma;
        // x = x + alpha*p;
        sum_vec_vec(alpha, p_p, p_x, N);
        m_profile.log_x_update();


        // Update r
        if ( ((m_iterations + 1) % 50) == 0) {
            // Time to reset the residual 
            // r = b -  Ax
            // compute r = A x
            m_op.mult_vec(p_x, p_r);
            // Compute r = b -r
            v_subtract(b, p_r, p_r, N);
        } else {
            // Normal residual update
            // r = r - alpha*w;
            sum_vec_vec(-alpha, p_w, p_r, N);
        }
        m_profile.log_r_update();
        
        // Update res norm
        res_norm_sqr_prev = res_norm_sqr;
        res_norm_sqr = inner_product(p_r, p_r, N);
        beta = res_norm_sqr / res_norm_sqr_prev;
        // p = r + beta p
        for (int i=0; i < N; ++i) {
            p_p[i] = p_r[i] + beta * p_p[i];
        }
        m_profile.log_p_update();
        ++m_iterations;
        
        // Update best x
        if (beta < best_beta) {
            // We have seen an improvement
            best_beta = beta;
            // Let's preserve this value of x
            m_best_x = m_x;
        }
        m_profile.log_best_x_update();
    }
    if(m_verbose >= DEBUG_PROFILE){
        m_profile.log_total_time();
        m_profile.print();
    }
}

CGProfile::CGProfile():
total_time(0),
w_update_time(0),
x_update_time(0),
r_update_time(0),
p_update_time(0),
best_x_update_time(0){
    reset();
}

CGProfile::~CGProfile(){

}


void CGProfile::print_step(const char* step, clock_t spent_time) const{
    if (spent_time > 0){
        double seconds = spent_time / (double)CLOCKS_PER_SEC;
        double percent  = spent_time * (double)100 / total_time;
        mexPrintf("%s time: %.4f seconds, %.2f %%\n", step, seconds, percent);
    }
}


void CGProfile::print() const {
    mexPrintf("\nProfile information. Total time spent: %.4f seconds\n", total_time / (double)CLOCKS_PER_SEC);
    print_step("w_update_time", w_update_time);
    print_step("x_update_time", x_update_time);
    print_step("r_update_time", r_update_time);
    print_step("p_update_time", p_update_time);
    print_step("best_x_update_time", best_x_update_time);
}

}
