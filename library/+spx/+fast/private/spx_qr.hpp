#ifndef _SPX_QR_HPP_
#define _SPX_QR_HPP_ 1

#include "spx_vector.hpp"
#include "spx_operator.hpp"

namespace spx{

namespace qr{

//! Reorthogonalize a vector against previous vectors
/**

Q: input matrix of orthogonal columns
ind: the list of indices of columns against which to orthogonalize
r : The vector which is to be orthogonalized
r_norm: current norm of r
alpha: The factor of reduction in the norm of r which triggers further reorthogonalization

*/
int reorth(const Matrix& Q, const index_vector& ind, Vec& r, double& r_norm, double alpha, int method);


}
}

#endif // _SPX_QR_HPP_


