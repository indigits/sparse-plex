#ifndef _SPX_LANBD_H_
#define _SPX_LANBD_H_ 1

#include "spx_operator.hpp"
#include "spx_vector.hpp"
#include "spx_rand.hpp"

namespace spx {


struct LanczosBDOptions{
public:
    //! desired level of orthogonality
    double delta;
    //! desired level of orthogonality after reorthogonalization
    double eta;
    //! Tolerance for iterate Gram-Schmidt
    double gamma;
    //! Flag for Classic / Modified Gram Schmidt
    bool cgs;
    //! Flag for extended local reorthogonalization
    int elr;
    //! verbosity level
    int verbosity;
    //! eps value
    double eps;
    LanczosBDOptions(double eps, int k);
};


/**
This class implements the algorithms related to
Lanczos bidiagonalization with full or 
partial reorthogonalization 
*/
class LanczosBD {
public:
    //! Constructor
    LanczosBD(const Operator& A, 
        Vec& alpha,
        Vec& beta,
        Vec& p,
        Rng& rng);
    //! Destructor
    ~LanczosBD();
    //! Complete iterations up to k Lanczos vectors
    int operator()(Matrix& U, Matrix& V, int k, int k_done, const LanczosBDOptions& options);
    //! Returns the running estimate of norm of A
    inline double get_anorm() const {
        return m_anorm;
    }
    inline void set_anorm(const double& anorm) {
        m_anorm = anorm;
    }
private:
    const Operator& m_A;
    Vec& m_alpha;
    Vec& m_beta;
    Vec& m_p;
    Rng& rng;
    Vec m_r;
    // Running estimate of the norm of A
    double m_anorm;
    //! Indicator for finishing before k iterations
    int ierr;
    //! Tracker for U inner products
    d_vector m_mu;
    //! Tracker for V inner products
    d_vector m_nu;
    //! Maximum values of mu for each iteration
    d_vector m_mumax;
    //! Maximum values of nu for each iteration
    d_vector m_numax;
    //! Number of reorthogonalizations on U
    int m_nreorthu;
    //! Number of reorthogonalizations on V
    int m_nreorthv;
    //! Number of U inner products
    int m_npu;
    //! Number of V inner products
    int m_npv;
    //! Number of times u vectors were renewed 
    int m_nrenewu;
    //! Number of times v vectors were renewed 
    int m_nrenewv;
    //! Set of indices to orthogonalize against
    b_vector m_indices;
    //! Indicates if reorthogonalization is forced in next iter
    int force_reorth;
    //! iteration number for j-th Lanczos vector
    int j;
    // Flag which indicates whether norm of A is to
    // be estimated
    bool est_anorm;
    //! flag to indicate if full reorthogonalization is to be done
    bool fro;
private:
    // Updates nu
    void update_nu(int j, const LanczosBDOptions& options);
    // Updates mu
    void update_mu(int j, const LanczosBDOptions& options);
    // Compute the indexes for orthogonalization
    void compute_ind(d_vector& mu, int j, int LL, int strategy, int extra, const LanczosBDOptions& options);

    // Extended local reorthogonalization
    void do_elr(const Vec& v_prev, Vec& v, double& v_norm, 
        double& v_coeff, const LanczosBDOptions& options);
    // Helper functions for norm estimations
    void estimate_anorm_from_largest_ritz_value(const LanczosBDOptions& options);
    //! Update a norm in U_{j+1} calculation
    void update_a_norm_for_u(const Vec& alpha, const Vec& beta);
    //! Update a norm in V_j calculation
    void update_a_norm_for_v(const Vec& alpha, const Vec& beta);
    void check_for_u_convergence(const LanczosBDOptions& options, Matrix& U, int k);
    void check_for_v_convergence(const LanczosBDOptions& options, Matrix& V, int k);


    /// With friends like these.
    friend class LanSVD;
};


} 

#endif // _SPX_LANBD_H_

