

#include <mex.h>
#include <math.h>
#include "omp.h"
#include "spxblas.h"

#define CHOL_DEBUG 0

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
    // Copy w to the new row of L
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

mxArray* omp_chol(const double m_dict[], 
    const double v_x[],
    mwSize M, 
    mwSize N,
    mwSize K){

    // List of indices of selected atoms
    mwIndex *selected_atoms = 0; 
    // Simple binary mask of selected atoms
    int* selected_atoms_mask = 0;   
    // Approximation of x on selected atoms
    double *v_x_hat = 0;
    // Storage for the Cholesky decomposition of D_I' D_I
    double *m_lt = 0;
    // The submatrix of selected atoms
    double* m_subdict = 0;
    // The proxy D' x
    double* v_proxy = 0;
    // The inner product of residual with atoms
    double* v_h = 0;
    // The residual
    double* v_r = 0;
    // b = D_I' d_k in the Cholesky decomposition updates
    double* v_b = 0;
    // New vector in the Cholesky decomposition updates
    double* v_w = 0;
    // Result of orthogonal projection LL' c = p_I
    double* v_c = 0;
    // Some temporary vectors
    double *v_t1 = 0, *v_t2 = 0;
    // Pointer to new atom
    const double* wv_new_atom;
    // residual norm squared
    double res_nom_sqr;
    /// Output array
    mxArray* p_alpha;
    double* v_alpha;

    // counters
    int i, j , k;
    // index of new atom
    mwIndex new_atom_index;
    // misc variables 
    double d1, d2;

    // Maximum number of columns to be used in representations
    mwSize max_cols;

    // Print input data
#if CHOL_DEBUG
    print_matrix(m_dict, M, N, "D");
    print_matrix(v_x, M, 1, "x");
#endif

    max_cols = (mwSize)(ceil(sqrt((double)M)/2.0) + 1.01);
    if(max_cols < K){
        max_cols = K;
    }
    // Memory allocations
    // Number of selected atoms cannot exceed M
    selected_atoms = (mwIndex*) mxMalloc(M*sizeof(mwIndex));
    // Total number of atoms is N
    selected_atoms_mask = (int*) mxMalloc(N*sizeof(int));
    // approximation vector is in signal space R^M
    v_x_hat = (double*) mxMalloc(M * sizeof(double));
    // Number of rows in L cannot exceed M. Number of columns 
    // cannot exceed max_cols.
    m_lt = (double*) mxMalloc(M*max_cols*sizeof (double));
    // Number of entries in new line for L cannot exceed N.
    v_b = (double*)mxMalloc(N*sizeof(double));
    v_w = (double*)mxMalloc(N*sizeof(double));
    v_c = (double*)mxMalloc(M*sizeof(double));
    // Giving enough space for temporary vectors
    v_t1 = (double*)mxMalloc(N*sizeof(double));
    v_t2 = (double*)mxMalloc(N*sizeof(double));
    // Keeping max_cols space for subdictionary. 
    m_subdict = (double*)mxMalloc(max_cols*M*sizeof(double));
    // Proxy vector is in R^N
    v_proxy = (double*)mxMalloc(N*sizeof(double));
    // h is in R^N.
    v_h = (double*)mxMalloc(N*sizeof(double));
    // Residual is in signal space R^M.
    v_r = (double*)mxMalloc(M*sizeof(double));


    // Initialization
    res_nom_sqr = inner_product(v_x, v_x, M);
    //Compute proxy p  = D' * x
    mult_mat_t_vec(1, m_dict, v_x, v_proxy, M, N);
    // h = p = D' * r
    copy_vec_vec(v_proxy, v_h, N);
    for (i=0; i<N; ++i){
        selected_atoms_mask[i] = 0;
    }
#if CHOL_DEBUG
#endif
    // Number of atoms selected so far.
    k = 0;
    // Iterate for each atom
    while (k < K){
        // Pick the index of (k+1)-th atom
        new_atom_index = abs_max_index(v_h, N);
#if CHOL_DEBUG
        print_matrix(v_h, N, 1, "h");
        mexPrintf("k = %d, index = %d \n\n", k, new_atom_index);
#endif
        // If this atom is already selected, we will break
        if (selected_atoms_mask[new_atom_index]){
            // This is unlikely due to orthogonal structure of OMP
#if CHOL_DEBUG
            mexPrintf("This atom is already selected.");
#endif
            break;
        }
        // Check for small values
        d2 = v_h[new_atom_index];
        if (SQR(d2) < 1e-14){
            // The inner product of residual with new atom is way too small.
            break;
        }
        // Store the index of new atom
        selected_atoms[k] = new_atom_index;
        selected_atoms_mask[new_atom_index] = 1;

        // Copy the new atom to the sub-dictionary
        wv_new_atom = m_dict + new_atom_index*M;
        copy_vec_vec(wv_new_atom, m_subdict+k*M, M);

        // Cholesky update
        if (k == 0){
            // Simply initialize the L matrix
            *m_lt = 1;
        }else{
            // Incremental Cholesky decomposition
            if (chol_update(m_subdict, wv_new_atom, m_lt, 
                v_b, v_w, M, k) != 0){
                break;
            }
        }
        // It is time to increase the count of selected atoms
        ++k;
        // We will now solve the equation L L' alpha_I = p_I
        vec_extract(v_proxy, selected_atoms, v_t1, k);
        spd_chol_lt_solve(m_lt, v_t1, v_c, M, k);
        // Compute residual
        // r  = x - D_I c
        mult_mat_vec(-1, m_subdict, v_c, v_r, M, k);
        sum_vec_vec(1, v_x, v_r, M);
        // Update h = D' r
        mult_mat_t_vec(1, m_dict, v_r, v_h, M, N);
        // Update residual norm squared
        res_nom_sqr = inner_product(v_r, v_r, M);
    }

    // Write the output vector
    p_alpha = mxCreateDoubleMatrix(N, 1, mxREAL);
    v_alpha =  mxGetPr(p_alpha);    
    fill_vec_sparse_vals(v_c, selected_atoms, v_alpha, N, k);

    // Memory cleanup
    mxFree(selected_atoms);
    mxFree(selected_atoms_mask);
    mxFree(v_x_hat);
    mxFree(m_lt);
    mxFree(v_b);
    mxFree(v_w);
    mxFree(v_c);
    mxFree(v_t1);
    mxFree(v_t2);
    mxFree(m_subdict);
    mxFree(v_proxy);
    mxFree(v_h);
    mxFree(v_r);

    // Return the result
    return p_alpha;
}


