#ifndef _SPX_LA_H_
#define _SPX_LA_H_ 1

#include "spxblas.h"


/**
Solves linear equations and least square problems

The matrices A and B are overwritten
in the process.
*/
int linsolve(double A[], 
    double B[], 
    double X[], 
    mwSize m, mwSize n, mwSize p, 
    int arr_type);


/**
Wrapper over dgels

Solves  min | A X - B |

The matrices A and B are overwritten
in the process.
*/
int least_square(double A[], 
    double B[], 
    double X[], 
    mwSize m, mwSize n, mwSize p);

#endif 
