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
    //! desired level of orthogonality
    double delta;
    //! desired level of orthogonality after reorthogonalization
    double eta;
    //! Tolerance for iterate Gram-Schmidt
    double gamma;
    //! Flag for Classic / Modified Gram Schmidt
    bool cgs;
    //! Flag for extended local reorthogonalization
    bool elr;
    //! verbosity level
    int verbosity;
    //! maximum number of iterations
    int max_iters;
    //! tolerance
    double tolerance;
    //! p0 specified by user
    mxArray*  p0;
public:
    LanSVDOptions(double eps, int k);
};


class LanSVD {
public:
    //! Constructor
    LanSVD(const mxArray* A, int k, const LanSVDOptions& options);
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
private:
    //! Array
    const mxArray* m_a_input;
    //! Number of columns in A
    size_t m_cols;
    //! Number of rows in A
    size_t m_rows;
    //! Number of singular values needed
    int m_k;
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
    MxFullMat* m_a_op_fullmat;
    //! space for storing alpha
    d_vector m_alpha_space; 
    //! space for storing beta
    d_vector m_beta_space;
    //! space for storing p
    d_vector m_p_space;
    // Wrapper vectors
    Vec* m_v_alpha;
    Vec* m_v_beta;
    Vec* m_v_p;
    //! Lanczos Bidiagonalization with Partial Reorthogonalization solver
    LanczosBD* mp_solver;
    //! Random number generator
    Rng rng;
};


}

#endif // _SPX_LANSVD_H_

