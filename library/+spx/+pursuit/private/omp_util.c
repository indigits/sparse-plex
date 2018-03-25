#include <mex.h>
#include <math.h>
#include "omp.h"
#include "spxblas.h"


void fill_vec_sparse_vals(const double values[],
    const mwIndex indices[], double output[], 
    mwSize n, mwSize k){
    int j;
    vec_set_value(output, 0, n);
    for(j = 0; j < k; ++j){
        output[indices[j]] = values[j];
    }
}


int chol_update(const double m_subdict[],
    const double v_atom[],
    double m_lt[],
    double v_b[],
    double v_w[],
    mwSize M,
    mwSize k
    ){
    int j;
    double d1;
    // Incremental Cholesky decomposition
    // b = D_I ' d
    // note that k atoms means current atom is skipped.
    mult_mat_t_vec(1, m_subdict, v_atom, v_b, M, k);
    // L' w = b
    lt_back_substitution(m_lt, v_b, v_w, M, k);
    // Copy w to the new row of L (k-th row)
    for (j=0; j < k; ++j){
        m_lt[j*M + k] = v_w[j];
    }
    // Update the entry L[k, k]
    d1 = 1 - inner_product(v_w, v_w, k);
    if (d1 <= 1e-14){
        // Selected atoms are dependent.
        return -1;
    }
    m_lt[k*M + k] = sqrt(d1);    
    return 0;
}
