#ifndef _OMP_H_
#define _OMP_H_ 1

#include "mex.h"

mxArray* omp_chol(const double m_dict[], 
    const double v_x[],
    mwSize M, 
    mwSize N,
    mwSize K);


void fill_vec_sparse_vals(const double values[],
    const mwIndex indices[], double output[], 
    mwSize n, mwSize k);

int chol_update(const double m_subdict[],
    const double v_atom[],
    double m_lt[],
    double v_b[],
    double v_w[],
    mwSize M,
    mwSize k
    );


#endif
