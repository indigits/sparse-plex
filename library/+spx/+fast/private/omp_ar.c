/*************************************************
*
*  Implementation of OMP with Atom Ranking Extension
*
*************************************************/

#include <mex.h>
#include <math.h>
#include "omp.h"
#include "spxblas.h"
#include "spxalg.h"

mxArray* omp_ar(const double m_dict[], 
    const double v_x[],
    mwSize M, 
    mwSize N,
    mwSize K, 
    double res_norm_bnd,
    int sparse_output){

    // List of indices of selected atoms as part of support
    mwIndex *support_set = 0;
    // List of atoms to match
    mwIndex* atoms_to_match_set = 0;
    int n_atoms_to_match = 0;
    // maintains the count of total number of matched atoms
    int n_matched_atoms;


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
    double res_norm_sqr;

    // Array to hold squared correlations of residual with atoms
    double *v_sqr_correlations = 0;
    // Array to hold Sorted (squared) correlations
    double *v_sorted_corrs = 0;
    
    /// Output array
    mxArray* p_alpha;
    double* v_alpha;
    // row indices for non-zero entries in Alpha
    mwIndex *ir_alpha;
    // indices for first non-zero entry in column
    mwIndex *jc_alpha;
    /// Index for non-zero entries in alpha
    mwIndex nz_index;

    // square of upper bound on residual norm
    double res_norm_bnd_sqr = SQR(res_norm_bnd);

    // counters
    int i, j , k;
    // index of new atom
    mwIndex max_idx;
    mwIndex orig_idx;
    // misc variables 
    double d1, d2;

    // Maximum number of columns to be used in representations
    mwSize max_cols;

    // Print input data
    if (K < 0 || K > M) {
        // K cannot be greater than M.
        K = M;
    }
    max_cols = (mwSize)(ceil(sqrt((double)M)/2.0) + 1.01);
    if(max_cols < K){
        max_cols = K;
    }
    // Memory allocations
    // Number of selected atoms cannot exceed M
    support_set = (mwIndex*) mxMalloc(M*sizeof(mwIndex));
    // Active indices can be all of 1:N
    atoms_to_match_set = (mwIndex*) mxMalloc(N*sizeof(mwIndex));
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
    // Squared correlations in original atom order
    v_sqr_correlations = (double*)mxMalloc(N*sizeof(double));
    v_sorted_corrs = (double*)mxMalloc(N*sizeof(double));
    // Squared correlations in the order in which atoms are matched
    // We actually track squared correlations in matching order
    // h is in R^N. 
    v_h = (double*)mxMalloc(N*sizeof(double));
    // Residual is in signal space R^M.
    v_r = (double*)mxMalloc(M*sizeof(double));



    if (sparse_output == 0){
        p_alpha = mxCreateDoubleMatrix(N, 1, mxREAL);
        v_alpha =  mxGetPr(p_alpha);
        ir_alpha = 0;
        jc_alpha = 0;
    }else{
        p_alpha = mxCreateSparse(N, 1, max_cols, mxREAL);
        v_alpha = mxGetPr(p_alpha);
        ir_alpha = mxGetIr(p_alpha);
        jc_alpha = mxGetJc(p_alpha);
        nz_index = 0;
        jc_alpha[0] = 0;
    }


    // Initialization
    res_norm_sqr = inner_product(v_x, v_x, M);
    //Compute proxy p  = D' * x
    // In the first iteration, we match all atoms
    for(int i=0; i < N; ++i){
        atoms_to_match_set[i] = i;
    }
    n_atoms_to_match = N;
    mult_mat_t_vec(1, m_dict, v_x, v_proxy, M, N);
    // h = p = D' * r
    copy_vec_vec(v_proxy, v_h, N);
    // Square all the correlations
    v_square(v_h, v_h, n_atoms_to_match);
    copy_vec_vec(v_h, v_sqr_correlations, n_atoms_to_match);


    // Number of atoms selected so far.
    k = 0;
    // Iterate for each atom
    while (k < K &&  res_norm_sqr > res_norm_bnd_sqr){
        // Pick the index of (k+1)-th atom
        max_idx = max_index(v_h, n_atoms_to_match);
        // Check for small values
        d2 = v_h[max_idx];
        if (d2 < 1e-14){
            // The inner product of residual with new atom is way too small.
            break;
        }
        // Store the index of new atom
        orig_idx = atoms_to_match_set[max_idx];
        support_set[k] = orig_idx;
        // Update squared correlations
        for(int ii=0;ii<n_atoms_to_match; ++ii){
            v_sqr_correlations[atoms_to_match_set[ii]] = v_h[ii];
        }
        // Ensure that the selected atom is never reconsidered.
        v_sqr_correlations[orig_idx] = 0;
        {
            double max_value;
            double factor = 4;
            double threshold;
            int reset_interval = 5;
            // Update atom order
            copy_vec_vec(v_sqr_correlations, v_sorted_corrs, N);
            for(int i=0; i < N; ++i){
                atoms_to_match_set[i] = i;
            }
            //print_vector(v_sorted_corrs, N, "corrs");
            quicksort_values_desc(v_sorted_corrs, atoms_to_match_set, N);
            //print_vector(v_sorted_corrs, N, "corrs");
            max_value = v_sorted_corrs[0];
            threshold = max_value / factor;
            n_atoms_to_match = N;
            if (k % reset_interval != 0){
                for (int i=1; i < N; ++i){
                    if (v_sorted_corrs[i] > threshold){
                        continue;
                    }
                    // We found a value lower than threshold
                    n_atoms_to_match = i+1;
                    break;
                }
            }
        }

        // Copy the new atom to the sub-dictionary
        wv_new_atom = m_dict + orig_idx*M;
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
        vec_extract(v_proxy, support_set, v_t1, k);
        spd_chol_lt_solve(m_lt, v_t1, v_c, M, k);
        // Compute residual
        // r  = x - D_I c
        mult_mat_vec(-1, m_subdict, v_c, v_r, M, k);
        sum_vec_vec(1, v_x, v_r, M);
        // Update h = D(:, Omega)' r
        mult_submat_t_vec(1, m_dict, atoms_to_match_set, 
            v_r, v_h, M, n_atoms_to_match);
        // Square all the correlations
        v_square(v_h, v_h, n_atoms_to_match);
        // Update residual norm squared
        res_norm_sqr = inner_product(v_r, v_r, M);
    }

    // Write the output vector
    if(sparse_output == 0){
        // Write the output vector
        fill_vec_sparse_vals(v_c, support_set, v_alpha, N, k);
    }
    else{
        // Sort the row indices
        quicksort_indices(support_set, v_c, k);
        // add the non-zero entries for this column
        for(j=0; j <k; ++j){
            v_alpha[nz_index] = v_c[j];
            ir_alpha[nz_index] = support_set[j];
            ++nz_index;
        }
        // fill in the total number of nonzero entries in the end.
        jc_alpha[1] = jc_alpha[0] + k;
    }

    // Memory cleanup
    mxFree(support_set);
    mxFree(atoms_to_match_set);
    mxFree(m_lt);
    mxFree(v_b);
    mxFree(v_w);
    mxFree(v_c);
    mxFree(v_t1);
    mxFree(v_t2);
    mxFree(m_subdict);
    mxFree(v_proxy);
    mxFree(v_h);
    mxFree(v_sqr_correlations);
    mxFree(v_sorted_corrs);
    mxFree(v_r);

    // Return the result
    return p_alpha;
}



