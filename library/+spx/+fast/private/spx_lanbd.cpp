#include "spx_lanbd.hpp"
#include "spx_qr.hpp"

namespace spx {

LanczosBDOptions::LanczosBDOptions(double eps, int k) {
    delta = sqrt(eps / k);
    eta = pow(eps, 0.75) / sqrt(k);
    gamma = 1 / sqrt(2);
    cgs = false;
    elr = 2;
    verbosity = 0;
    this->eps = eps;
}

/************************************************
 *  LanczosBD Implementation
 ************************************************/

LanczosBD::LanczosBD(const Operator& A,
                     Vec& alpha,
                     Vec& beta,
                     Vec& p):
    m_A(A),
    m_alpha(alpha),
    m_beta(beta),
    m_p(p),
    m_anorm(-1),
    m_npu(0),
    m_npv(0),
    ierr(0),
    m_nreorthu(0),
    m_nreorthv(0)
{
    // mexPrintf("A : %d\n", &m_A);
    // mexPrintf("U : %d\n", &m_U);
    // mexPrintf("V : %d\n", &m_V);
    // mexPrintf("alpha : %d\n", &m_alpha);
    // mexPrintf("beta : %d\n", &m_beta);
    // mexPrintf("p : %d\n", &m_p);
    m_r.resize(A.columns());
    m_indices.resize(A.columns());
}


LanczosBD::~LanczosBD() {

}

/**
TODO List
- Make sure that options argument is passed consistently everywhere.
- Handle the special cases where A is empty matrix or single column matrix.

*/

int LanczosBD::operator()(Matrix& U, Matrix& V, int k, int k_done, const LanczosBDOptions& options) {
    const Operator& A = m_A;
    Vec& alpha = m_alpha;
    Vec& beta = m_beta;
    Vec& p = m_p;
    Vec r(m_r);
    int verbosity = options.verbosity;
    // Options
    double delta  = options.delta;
    double gamma = options.gamma;
    double eta = options.eta;
    bool cgs = options.cgs;
    int elr = options.elr;
    double eps = options.eps;
    int force_reorth  = 0;

    // Verify the dimensions
    if(U.columns() < k){
        mexPrintf("Number of columns in U: %d, expected: %d\n", U.columns(), k);
        throw std::length_error("U doesn't have sufficient space to store all Lanczos vectors.");
    }
    if(V.columns() < k){
        throw std::length_error("V doesn't have sufficient space to store all Lanczos vectors.");
    }
    //! Number of rows
    mwSize m = m_A.rows();
    //! Number of columns
    mwSize n = m_A.columns();

    double m2 = 3.0 / 2;
    double n2 = 3.0 / 2;

    // Flag which indicates whether norm of A is to
    // be estimated
    bool est_anorm = true;
    // Fudge factor for A norm estimate
    double FUDGE = 1.01;
    // Ensure that inner product trackers have sufficient space
    m_nu.resize(k);
    m_mu.resize(k + 1);
    m_numax.resize(k);
    m_mumax.resize(k);
    // if delta is zero, then user has requested full reorthogonalization
    bool fro = (delta == 0);
    /// Initialization for first iteration
    if (k_done == 0) {
        if (verbosity >= 2) {
            mexPrintf("Computing U[0]\n");
        }
        // First time initialization
        beta[0] = p.norm();
        if (verbosity >= 3) {
            mexPrintf("The norm of initial p vector: beta[0]: %f\n", beta[0]);
        }
        m_nu[0] = 1;
        m_mu[0] = 1;
    }

    // Iterate over computing Lanczos vectors
    for (int j = k_done; j < k; ++j) {
        /**
        In each iteration, we update following quantities:
        - U(:, j) from last computed value of p and beta[j]
        - r
        - alpha[j]
        - V_j
        - p
        - beta[j+1]

        Notes:
        - Computation starts with beta[0]
        - beta[j] is computed before alpha[j]
        - U_j is computed before V_j
        */
        if (verbosity >= 2) {
            mexPrintf("\nj=%d: \n", j);
        }
        if (verbosity >= 2) {
            mexPrintf("Setting U[%d]\n", j);
        }
        // U(:, j) = p / beta(j)
        if (beta[j] != 0) {
            U.set_column(j, p, 1 / beta[j]);
        } else {
            // new left vector is 0 vector
            U.set_column(j, p);
        }
        if (verbosity >= 2) {
            mexPrintf("Computing V[%d]\n", j);
        }
        if (j == 5) {
            //TODO Replace A norm estimate with largest Ritz value
        }
        // At this moment U_j has been obtained and V_j computation begins
        // U(:, j)
        Vec U_j = U.column_ref(j);
        // r = A' * U(:, j)
        A.mult_t_vec(U_j, r);
        if (j == 0) {
            // Initial estimate of alpha[0]
            alpha[j] = r.norm();
            if (est_anorm) {
                // Initial norm estimate
                m_anorm = FUDGE * alpha[j];
            }
            // r may change due to orthogonalization
        } else {
            // for j > 0
            // Get V(:, j-1)
            Vec V_jm1 = V.column_ref(j - 1);
            // r = r - beta(j) * V(:, j-1)
            r.add(V_jm1, -beta[j]);
            // alpha[j] estimate
            alpha[j] = r.norm();
            // Extended local reorthogonalization
            if ((alpha[j] < gamma * beta[j]) && elr && (!fro)) {
                // We iterate till r has significant V_{j-1} component
                bool stop = false;
                double normold = alpha[j];
                int nelr = 0;
                while (!stop) {
                    // Component of r along V_{j-1}
                    double t = V_jm1.inner_product(r);
                    // Subtract it from r
                    r.add(V_jm1, -t);
                    // Update its norm
                    alpha[j] = r.norm();
                    if (beta[j] != 0) {
                        // add this correction term to beta_j
                        beta[j] += t;
                    }
                    if (alpha[j] >= gamma * normold) {
                        // Not enough reduction. We stop
                        stop = true;
                    } else {
                        // continue reorthogonalization
                        normold = alpha[j];
                    }
                    ++nelr;
                } // stop
                if (verbosity >= 4) {
                    mexPrintf("ELR for V[%d]: %d times\n", j, nelr);
                }
            } // Extended local reorthogonalization
            // update norm estimate for j > 0
            if (est_anorm) {
                double tmp = 0;
                if (j == 1) {
                    // alpha(j-1)* beta(j-1) component not applicable for j=1
                    double a0 = alpha[0];
                    double b1 = beta[1];
                    double a1 = alpha[1];
                    tmp = square(a0) + square(b1) + a1 * b1;
                } else {
                    double a1 = alpha[j - 1];
                    double a2 = alpha[j];
                    double b1 = beta[j - 1];
                    double b2 = beta[j];
                    tmp = square(a1) + square(b2) + a1 * b1 + a2 * b2;
                }
                tmp = sqrt(tmp);
                m_anorm = std::max(m_anorm, FUDGE * tmp);
            }
            // step 2.1 a update nu
            if ((!fro) && (alpha[j] != 0)) {
                update_nu(j, options);
            }
            if ((elr > 0)) {
                // TODO what's going on here?
                // We always reorthogonalize against the previous vector
                m_nu[j - 1] = n2 * eps;
            }
            // IF level of orthogonality is worse than delta THEN
            // Reorthogonalize v_j against some previous  v_i's, 0<=i<j.
            if (( fro || (m_numax[j] > delta) || force_reorth ) && (alpha[j] != 0)) {
                // step 2.1 b select indices to orthogonalize against.
                // Since we are computing V_j, there are j previously
                // computed V_i
                if (fro || eta == 0) {
                    // We need to orthogonalize against all previous vectors
                    for (int kk = 0; kk < j; ++kk) {
                        m_indices[kk] = true;
                    }
                }
                else if (force_reorth == 0) {
                    // Let's identify the indices to reorthogonalize against
                    compute_ind(m_nu, j, 0, 0, 0, options);
                } else {
                    // We will use  int from last reorth. to avoid spillover from mu_{j-1} to nu_j.
                }
                // Complete the reorthogonalization
                index_vector indices;
                // The indices of columns selected for orthogonalization
                flags_to_indices(m_indices, indices, j);
                // The previous j columns of V
                Matrix Q = V.columns_ref(0, j);
                // reorthogonalize r against Q
                int nre = qr::reorth(Q, indices, r, alpha[j], gamma, cgs);
                // Number of inner products
                m_npv += nre * indices.size();
                // Reset nu for orthogonalized vectors.
                Vec nu(m_nu);
                nu.set(indices, n2 * eps);
                // TODO what's going on here
                if (force_reorth == 0) {
                    force_reorth = 1;
                } else {
                    force_reorth = 0;
                }
                m_nreorthv += 1;
            } // end Reorthogonalize
        } // end j > 0
        // Check for convergence or failure to maintain semiorthogonality
        if ((alpha[j] < std::max(n, m)*m_anorm * eps) && (j < k - 1)) {
            /// TODO finish this
        } // check for convergence
        // Update V_j
        if (verbosity >= 2) {
            mexPrintf("Setting V[%d]\n", j);
        }
        if (alpha[j] != 0) {
            V.set_column(j, r, 1 / alpha[j]);
        } else {
            V.set_column(j, r);
        }
        if (verbosity >= 2) {
            mexPrintf("Computing U[%d]\n", j + 1);
        }
        //// Lanczos step to compute U_{j+1} starts now
        /// At this moment U_j and V_j have already been computed.
        /// beta[j] and alpha[j] have also been computed.
        // V_j
        Vec V_j = V.column_ref(j);
        // Compute p_j = A * V_j - alpha_j * U_j
        // p = A * V_j
        A.mult_vec(V_j, p);
        // p = p - alpha[j] U_j
        p.add(U_j, -alpha[j]);
        // Initiate estimate of beta[j+1]
        beta[j + 1] = p.norm();
        /// This may change due to reorthogonalization
        // Extended local reorthogonalization
        if ((beta[j + 1] < gamma * alpha[j]) && elr && (!fro)) {
            bool stop = false;
            double normold = beta[j + 1];
            int nelr = 0;
            while (!stop) {
                // Component of p along U_j
                double t = U_j.inner_product(p);
                // Subtract it from p
                p.add(U_j, -t);
                // Update its norm
                beta[j + 1] = p.norm();
                if (alpha[j] != 0) {
                    // add this correction term to alpha_j
                    alpha[j] += t;
                }
                if (beta[j + 1] >= gamma * normold) {
                    // Not enough reduction. We stop
                    stop = true;
                } else {
                    // continue reorthogonalization
                    normold = beta[j + 1];
                }
                ++nelr;
            } // stop
            if (verbosity >= 4) {
                mexPrintf("ELR for U[%d]: %d times\n", j + 1, nelr);
            }
        }
        if (est_anorm) {
            double tmp = 0;
            if (j == 0) {
                tmp = square(alpha[0]) + square(beta[1]);
            } else {
                double a1 = alpha[j];
                double b1 = beta[j];
                double b2 = beta[j + 1];
                tmp = square(a1) + square(b2) + a1 * b1;
            }
            tmp = sqrt(tmp);
            m_anorm = std::max(m_anorm, FUDGE * tmp);
        }
        if (!fro & beta[j + 1] != 0) {
            // Update estimates of the orthogonality for the columns of U.
            update_mu(j, options);
        }
        // TODO what's going on here
        if (elr > 0) {
            m_mu[j] = m2 * eps;
        }
        // IF level of orthogonality is worse than delta THEN
        // Reorthogonalize u_{j+1} against some previous  u_i's, 0<=i<=j
        // Total j+1 columns in U exist already. 
        if (( fro || (m_mumax[j] > delta) || force_reorth ) 
            && (beta[j+1] != 0)){
            // Decide which vectors to orthogonalize against.
            if (fro || (eta == 0)){
                // We need to orthogonalize against all previous vectors
                for (int kk = 0; kk <= j; ++kk) {
                    m_indices[kk] = true;
                }
            }
            else if (force_reorth == 0){
                // Let's identify the indices to reorthogonalize against
                compute_ind(m_mu, j+1, 0, 0, 0, options);
            } else {
                //TODO We need to add one more entry
                // int = [int; max(int)+1];
            }
            // Complete the reorthogonalization
            index_vector indices;
            // The indices of columns selected for orthogonalization
            flags_to_indices(m_indices, indices, j+1);
            // The previous j+1 columns of U
            Matrix Q = U.columns_ref(0, j+1);
            // reorthogonalize r against Q
            int nre = qr::reorth(Q, indices, p, beta[j+1], gamma, cgs);
            // Number of inner products
            m_npu += nre * indices.size();
            // Reset mu for orthogonalized vectors.
            Vec mu(m_mu);
            mu.set(indices, n2 * eps);
            // TODO what's going on here
            if (force_reorth == 0) {
                // Force reorthogonalization of v_{j+1}.
                force_reorth = 1;
            } else {
                force_reorth = 0;
            }
            m_nreorthv += 1;
        }
        // TODO Check for convergence or failure to maintain semiorthogonality
        if ((beta[j+1] < std::max(n, m)*m_anorm * eps) && (j < k - 1)) {

        } // end check for convergence
        // Count the number of iterations completed.
        k_done += 1;
    }
    return k_done;
}

/**
At the beginning of this call V[j] is being computed.
- r has been computed
- alpha[j] is being computed
- j+1 U columns are already computed.
- j V columns are already computed.
- beta[j] has been computed.
- Estimates of inner product of V[j] with V_0 till V_{j-1} is being updated.
- Thus, total j entries are under consideration for computing the max value.
- nu[j] = 1 always.
*/
void LanczosBD::update_nu(int j, const LanczosBDOptions& options) {
    Vec& alpha = m_alpha;
    Vec& beta = m_beta;
    double ainv = 1 / alpha[j];
    double eps = options.eps;
    double eps1 = 100 * eps / 2;
    Vec nu(m_nu);
    Vec mu(m_mu);
    double anorm = m_anorm;
    if (options.verbosity >= 6) {
        mexPrintf("Updating nu for j: %d, ainv: %f, anorm: %f\n", j, ainv, anorm);
    }
    if (j > 0) {
        double aj = alpha[j];
        double bj = beta[j];
        double x = sqrt(square(aj) + square(bj));
        for (int k = 0; k < j; ++k) {
            double ak = alpha[k];
            double bk1 = beta[k + 1];
            double y = sqrt(square(ak) + square(bk1));
            double T = eps1 * (x + y + anorm);
            if (options.verbosity >= 6) {
                mexPrintf("k=%d, x=%f, y=%f, anorm=%f, T=%e\n", k, x, y, anorm, T);
            }
            double muk = mu[k];
            double muk1 = mu[k + 1];
            double nuk = nu[k];
            double betak1 = beta[k + 1];
            nu[k] = betak1 * muk1 + ak * muk - bj * nuk;
            nu[k] = ainv * (nu[k] + sgn(nu[k]) * T);
        }
    }
    // v_j' v_j is always 1.
    nu[j] = 1;
    Vec numax(m_numax);
    numax[j] = nu.abs_max(0, j);
    if (options.verbosity >= 3) {
        nu.print("nu", j + 1, true);
        numax.print("numax", j + 1, true);
    }
}

/**
At the beginning of this call U[j+1] is being computed.
- p has been computed
- alpha[j] has been computed
- j+1 U columns are already computed.
- j+1 V columns are already computed.
- beta[j+1] has been computed.
- Estimates of inner product of U[j+1] with U_0 till U_j is being updated.s

For U_1, 1 entry will be updated.
For U_2, 2 entries will be updated.

Essentially mu[0 till j] will be updated.
mu[j+1] will always be set to 1.
*/
void LanczosBD::update_mu(int j, const LanczosBDOptions& options) {
    Vec& alpha = m_alpha;
    Vec& beta = m_beta;
    double aj = alpha[j];
    double bj = beta[j];
    double bjp1 = beta[j + 1];
    double binv = 1 / bjp1;
    double eps = options.eps;
    double eps1 = 100 * eps / 2;
    Vec nu(m_nu);
    Vec mu(m_mu);
    double anorm = m_anorm;
    if (options.verbosity >= 6) {
        mexPrintf("Updating mu for j: %d, binv: %f, anorm: %f\n", j, binv, anorm);
    }
    double a0 = alpha[0];
    double b0 = beta[0];
    if (j == 0) {
        double b1 = beta[1];
        double T = eps1 * (pythag(a0, b1) + pythag(a0, b0) + anorm);
        mu[0] = T / b1;
    }
    else {
        // We need to compute 3 things separately
        // mu[0]
        // mu[1 to j-1]
        // mu[j]
        // mu[0] calculation
        mu[0] = a0 * nu[0] - aj * mu[0];
        double x = sqrt(square(aj) + square(bjp1));
        double y = sqrt(square(a0) + square(b0));
        double T = eps1 * (x + y + anorm);
        mu[0] = binv * (mu[0] + sgn(mu[0]) * T);
        // mu[1 to j-1] calculation
        for (int k = 1; k < j; ++k) {
            double ak = alpha[k];
            double nuk = nu[k];
            double bk = beta[k];
            double nukm1 = nu[k - 1];
            mu[k] = ak * nuk + bk * nukm1 - aj * mu[k];
            double y = sqrt(square(ak) + square(bk));
            double T = eps1 * (x + y + anorm);
            mu[k] = binv * (mu[k] + sgn(mu[k]) * T);
        }
        // mu[j] calculation
        y = sqrt(square(aj) + square(bj));
        T = eps1 * (x + y + anorm);
        mu[j] = bj * nu[j - 1];
        mu[j] = binv * (mu[j] + sgn(mu[j]) * T);
    }
    mu[j + 1] = 1;
    Vec mumax(m_mumax);
    mumax[j] = mu.abs_max(0, j + 1);
    if (options.verbosity >= 3) {
        mu.print("mu", j + 2, true);
        mumax.print("mumax", j + 1, true);
    }
}


void LanczosBD::compute_ind(d_vector& mmu, int j, int LL, int strategy, int extra, const LanczosBDOptions& options) {
    b_vector& ind = m_indices;
    // Reset all indices to 0 first
    for (int i = 0; i < j; ++i) {
        ind[i] = false;
    }
    Vec mu(mmu);
    double delta = options.delta;
    double eta = options.eta;
    if (strategy == 0) {
        // Strategy 0: Orthogonalize vectors v_{i-r-extra},...,v_{i},...v_{i+s+extra}
        // with nu>eta, where v_{i} are the vectors with  mu>delta.
        // Identify the indices where mu[i] > delta
        int found = 0;
        for (int i = 0; i < j; ++i) {
            if (fabs(mu[i]) >= delta) {
                ind[i] = true;
                ++found;
            }
        }
        if (found == 0) {
            // pick the index with largest magnitude
            int idx = mu.abs_max_index();
            ind[idx] = true;
        }
        // iterate over ind
        for (int i = 0; i < j; ++i) {
            if (ind[i] == false) {
                continue;
            }
            // Go backwards to locate r
            int r = i;
            for (; r > 0; --r) {
                if (ind[r] == true || fabs(mu[r]) < eta) {
                    break;
                }
                ind[r] = true;
            }
            // fill ind[r-extra+1:r] = 1
            for (int k = r; k > r - extra; --k) {
                if (k < 0) {
                    break;
                }
                ind[k] = true;
            }
            // Go forward to find s
            int s = i + 1;
            for (; s < j; ++s) {
                if ((ind[s] == true) || (fabs(mu[s]) < eta)) {
                    break;
                }
                ind[s] = true;
            }
            // fill ind[s:s+extra-1] =1
            for (int k = s; k < s + extra; ++k) {
                if (k >= j) {
                    break;
                }
                ind[k] = true;
            }
        }

    } else if (strategy == 1) {
        // Orthogonalize against all vectors in the range below
        int begin = -1;
        int end = -1;
        for (int i = 0; i < j; ++i) {
            if (mu[i] > eta) {
                if (begin < 0) {
                    begin = i;
                    end = i;
                } else {
                    end = i;
                }
            }
        }
        if (begin < 0) {
            // nothing to do
        } else {
            // from begin - extra
            begin = std::max(LL, begin - extra);
            // to end + extra
            end = std::min(end + extra, j - 1);
            for (int i = begin; i <= end; ++i) {
                ind[i] = true;
            }
        }

    } else if (strategy == 2) {
        for (int i = 0; i < j; ++i) {
            if (fabs(mu[i]) >= eta) {
                ind[i] = true;
            }
        }

    } else {
        throw std::invalid_argument("invalid strategy");
    }
}



}