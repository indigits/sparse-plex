#ifndef _SPX_SVD_HPP_
#define _SPX_SVD_HPP_ 1

#include "spx_vector.hpp"
#include "spx_operator.hpp"

namespace spx {

//! Wrapper over dbdsqr function
void svd_bd_square(const Vec& alpha, const Vec& beta, Vec& S, Matrix* pU, Matrix* pVT, mwSignedIndex m = -1);
//! Converts a (k+1) x k lower bidiagonal system into a kxk upper bidiagonal system
void convert_bd_kp1xk_to_kxk(Vec& alpha, Vec& beta, double& c, double& s);

//! Norm of a k+1 by k lower bidiagonal matrix
double norm_kp1xk_mat(const Vec& alpha, const Vec& beta);

}

#endif // _SPX_SVD_HPP_

