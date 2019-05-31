#include "spx_lanbd.hpp"

namespace spx{

LanczosBDOptions::LanczosBDOptions(double eps, int k){
    delta = sqrt(eps/k);
    eta = pow(eps, 0.75) / sqrt(k);
    gamma = 1/sqrt(2);
    cgs = false;
    elr = 2;
    verbosity = 0;
}

/************************************************
 *  LanczosBD Implementation
 ************************************************/

LanczosBD::LanczosBD(const Operator& A, 
        MxFullMat& U,
        MxFullMat& V,
        Vec& alpha,
        Vec& beta,
        Vec& p):
m_A(A),
m_U(U),
m_V(V),
m_alpha(alpha),
m_beta(beta),
m_p(p)
{
    // mexPrintf("A : %d\n", &m_A);
    // mexPrintf("U : %d\n", &m_U);
    // mexPrintf("V : %d\n", &m_V);
    // mexPrintf("alpha : %d\n", &m_alpha);
    // mexPrintf("beta : %d\n", &m_beta);
    // mexPrintf("p : %d\n", &m_p);
    m_r.resize(A.columns());
}


LanczosBD::~LanczosBD(){

}


int LanczosBD::operator()(LanczosBDOptions& options, int k, int k_done){
    Matrix& U = m_U.impl();
    Matrix& V = m_V.impl();
    const Operator& A = m_A;
    Vec& alpha = m_alpha;
    Vec& beta = m_beta;
    Vec& p = m_p;
    Vec r(m_r);
    if (options.verbosity > 3){
        mexPrintf("Computing the norm of p vector.\n");
    }
    beta[0] = p.norm();
    if (options.verbosity> 1){
        mexPrintf("beta[%d]: %.lf\n", 1, beta[0]);
    }
    for (int j=0; j < k; ++j){
        if (options.verbosity > 1){
            mexPrintf("Computing %d-th U vector\n", j+1);
        }
        U.set_column(j, p, 1/beta[j]);
        Vec U_j = U.column_ref(j);
        // r = A' * U(:, j)
        A.mult_t_vec(U_j, r);
        if (j > 0) {
            // r = r - beta(j) * V(:, j-1)
            Vec V_j1 = V.column_ref(j-1);
            r.add(V_j1, -beta[j]);
        }
        alpha[j] = r.norm();
        // Compute V_j
        V.set_column(j, r, 1/alpha[j]);
        // Compute p_j = A * V_j - alpha_j * U_j
        Vec V_j = V.column_ref(j);
        A.mult_vec(V_j, p);
        p.add(U_j, -alpha[j]);
        beta[j+1] = p.norm();
    }
    if (options.verbosity > 3){
        alpha.print("alpha");
        beta.print("beta");
    }
    return k_done;
}


}