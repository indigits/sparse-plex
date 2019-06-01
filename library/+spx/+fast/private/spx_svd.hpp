#ifndef _SPX_SVD_H_
#define _SPX_SVD_H_ 1

#include "spx_vector.hpp"
#include "spx_operator.hpp"

namespace spx {


void svd_bd_square(const Vec& alpha, const Vec& beta, Vec& S, Matrix* pU, Matrix* pVT);

}

#endif // _SPX_SVD_H_

