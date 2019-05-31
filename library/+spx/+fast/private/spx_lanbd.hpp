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
    bool elr;
    //! verbosity level
    int verbosity;
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
        MxFullMat& U,
        MxFullMat& V,
        Vec& alpha,
        Vec& beta,
        Vec& p);
    //! Destructor
    ~LanczosBD();
    //! Complete iterations up to k Lanczos vectors
    int operator()(LanczosBDOptions& options, int k, int k_done=0);
private:
    const Operator& m_A;
    MxFullMat& m_U;
    MxFullMat& m_V;
    Vec& m_alpha;
    Vec& m_beta;
    Vec& m_p;
    d_vector m_r;
};

} 

#endif // _SPX_LANBD_H_

