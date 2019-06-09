#ifndef _SPX_RAND_H_
#define _SPX_RAND_H_ 1

#include <random>

#include "spx_vector.hpp"
#include "spx_operator.hpp"

namespace spx{

class Rng{
public:
    Rng(unsigned seed = 0);
    ~Rng();
    //! Initialize a vector by uniform random numbers
    void uniform_real(double a, double b, Vec& v);
private:
    std::mt19937 gen;
};


}

#endif // _SPX_RAND_H_

