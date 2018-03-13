/**
Wrapper for BLAS functions
*/

#ifndef _SPX_BLAS_H_
#define _SPX_BLAS_H_ 1

#include <math.h>
#include "mex.h"

/**
Square of a value
*/
#define SQR(x) ((x) * (x))


/***
Compute y = alpha * A * x
*/
void mult_mat_vec(double alpha, 
    const double A[], 
    const double x[], 
    double y[], size_t m, size_t n);

/***
Compute y = alpha * A' * x
*/
void mult_mat_t_vec(double alpha, 
    const double A[], 
    const double x[], 
    double y[], size_t m, size_t n);


#endif 


