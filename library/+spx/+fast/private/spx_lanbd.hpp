#ifndef _SPX_LANBD_H_
#define _SPX_LANBD_H_ 1

#include "spx_operator.hpp"
#include "spx_vector.hpp"

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
        Vec& p);
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
    d_vector m_r;
    // Running estimate of the norm of A
    double m_anorm;
    //! Number of U inner products
    int m_npu;
    //! Number of V inner products
    int m_npv;
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
    //! Set of indices to orthogonalize against
    b_vector m_indices;
private:
    // Updates nu
    void update_nu(int j, const LanczosBDOptions& options);
    // Updates mu
    void update_mu(int j, const LanczosBDOptions& options);
    // Compute the indexes for orthogonalization
    void compute_ind(d_vector& mu, int j, int LL, int strategy, int extra, const LanczosBDOptions& options);
};


} 

#endif // _SPX_LANBD_H_

