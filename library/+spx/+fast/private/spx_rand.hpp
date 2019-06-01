#ifndef _SPX_RAND_H_
#define _SPX_RAND_H_ 1

#include "spx_vector.hpp"
#include "spx_operator.hpp"

namespace spx{

namespace rand{

//! Initialize a vector by uniform random numbers
void init_uniform_real(Vec& v, double a, double b);

}

}

#endif // _SPX_RAND_H_

