#ifndef _SPX_LANSVD_H_
#define _SPX_LANSVD_H_ 1

#include "spx_operator.hpp"
#include "spx_vector.hpp"
#include "spx_lanbd.hpp"
#include <mex.h>

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
private:
    //! Array
    const mxArray* m_a_input;
    //! Number of singular values needed
    int m_k;
    //! Options
    const LanSVDOptions& m_options;
    //! maximum number of iterations
    int n_max_iters;
    //! tolerance
    double m_tolerance;
    //! U matrix
    mxArray* m_u_arr;
    //! V matrix
    mxArray* m_v_arr;
    // Arguments to be passed to the LAN BD solver
    //! Operator to be passed
    MxFullMat* m_a_op_fullmat;
    //! Space for U
    MxFullMat* m_u_mat;
    //! Space for V
    MxFullMat* m_v_mat;
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
};


}

#endif // _SPX_LANSVD_H_

