#include "spx_rand.hpp"

#include <random>

namespace spx
{

namespace rand{

void init_uniform_real(Vec& v, double a, double b) {
    std::mt19937 gen(0);
    std::uniform_real_distribution<> dis(a, b);
    double* x = v.head();
    mwSignedIndex  x_inc = v.inc();
    mwSize length = v.length();
    // mexPrintf("inc: x_inc, n: m_n\n", x_inc, m_n);
    for (int n = 0; n < length; ++n) {
        double value = dis(gen);
        *x = value;
        x += x_inc;
    }
}

}

}