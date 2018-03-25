#ifndef _SPX_ALG_H_
#define _SPX_ALG_H_ 1

#include "mex.h"

/**
* QuickSort - public-domain C implementation by Darel Rex Finley.
*
* This function is used for sorting indices 
* and corresponding values 
* for the sparse representation of a vector
*
* indices contains the indices to be sorted.
* data contains corresponding entries in the sparse vector.
*/
void quicksort_indices(mwIndex indices[], double data[], mwIndex n);

#endif 
