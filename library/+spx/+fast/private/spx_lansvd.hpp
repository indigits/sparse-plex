#ifndef _SPX_LANSVD_H_
#define _SPX_LANSVD_H_ 1

#include <mex.h>

#include "spx_operator.hpp"
#include "spx_vector.hpp"
#include "spx_lanbd.hpp"
#include "spx_rand.hpp"

namespace spx {


struct LanSVDOptions{
public:
    //! Number of singular values requested
    int k_req;
    //! Threshold for singular values
    double lambda;
    //! desired level of orthogonality
    double delta;
    //! desired level of orthogonality after reorthogonalization
    double eta;
    //! Tolerance for iterated Gram-Schmidt
    double gamma;
    //! Flag for Classic / Modified Gram Schmidt
    bool cgs;
    //! Flag for extended local reorthogonalization
    bool elr;
    //! verbosity level
    int verbosity;
    //! tolerance
    double tolerance;
    //! maximum number of iterations
    int max_iters;
    //! p0 specified by user
    mxArray*  p0;
public:
    LanSVDOptions();
};


class LanSVD {
public:
    enum STOPPING_CRITERION {
        SV_COUNT,
        SV_THRESHOLD
    };
public:
    //! Constructor
    LanSVD(const mxArray* A, const LanSVDOptions& options);
    //! Destructor
    ~LanSVD();
    //! Executes the SVD operation
    void operator()();
    //! Transfers the U array to caller.
    mxArray* transfer_u();
    //! Transfers the V array to the caller.
    mxArray* transfer_v();
    //! Transfer the singular values vector
    mxArray* transfer_s();
    //! Transfer the alpha vector
    mxArray* transfer_alpha();
    //! Transfer the beta vector
    mxArray* transfer_beta();
    //! Transfer the p vector
    mxArray* transfer_p();
    //! Transfer the details of computation
    mxArray* transfer_details();
private:
    //! Array
    const mxArray* m_a_input;
    //! Stopping criterion
    STOPPING_CRITERION m_stop_crit;
    //! Number of columns in A
    size_t m_cols;
    //! Number of rows in A
    size_t m_rows;
    //! Number of Lanczos iterations completed
    int k_done;
    /// Number of singular values which have converged
    int n_converged;
    //! Options
    const LanSVDOptions& m_options;
    //! maximum number of iterations
    int m_max_iters;
    //! tolerance
    double m_tolerance;
    //! U matrix
    mxArray* m_u_arr;
    //! V matrix
    mxArray* m_v_arr;
    //! S array
    mxArray* m_s_arr;
    // Arguments to be passed to the LAN BD solver
    //! Operator to be passed
    Operator* m_a_op;
    //! space for storing alpha
    Vec* m_v_alpha;
    //! space for storing beta
    Vec* m_v_beta;
    //! space for storing p
    Vec* m_v_p;
    //! Lanczos Bidiagonalization with Partial Reorthogonalization solver
    LanczosBD* mp_solver;
    //! Random number generator
    Rng rng;
private:
    // Helper functions
    //! Refine the bounds on the singular values
    void refine_bounds(const Vec& S, Vec& bnd, double tolerance);
};


}

#endif // _SPX_LANSVD_H_

