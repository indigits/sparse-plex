#ifndef _SPX_SVD_HPP_
#define _SPX_SVD_HPP_ 1

#include "spx_vector.hpp"
#include "spx_operator.hpp"

namespace spx {

//! Wrapper over dbdsqr function
void svd_bd_square(const Vec& alpha, const Vec& beta, Vec& S, Matrix* pU, Matrix* pVT);
//! Converts a k x (k+1) lower bidiagonal system into a kxk upper bidiagonal system
void convert_bd_kxkp1_to_kxk(Vec& alpha, Vec& beta, double& c, double& s);

}

#endif // _SPX_SVD_HPP_

