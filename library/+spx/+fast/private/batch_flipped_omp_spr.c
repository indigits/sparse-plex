/*************************************************
*
*  Flipped Bath OMP for Subspace Preserving 
*  Representations Implementation
*
*************************************************/

#include <mex.h>
#include <math.h>
#include "omp.h"
#include "spxblas.h"
#include "spxalg.h"
#include "omp_profile.h"

#define SPR_DEBUG 1

mxArray* batch_flipped_omp_spr(double *m_dataset, // Dataset
    mwSize M, // Data dimension
    mwSize S, // Number of signals
    mwSize K, // Sparsity level
    double res_norm_bnd, // Residual norm bound
    int sparse_output // Whether output is sparse matrix
    ){

    // Square on the bound on the norm of residual
    double res_norm_bnd_sqr = SQR(res_norm_bnd);

    /**
    Following variables are common for all signals being processed.
    */
    // Gram matrix
    double *m_gram = 0;
    // The proxy D' x
    double* wv_proxy = 0;
    // Pointer to corresponding column in G 
    const double* wv_new_gram_col;

    // List of indices of selected atoms for all points
    mwIndex* m_support_sets = 0;
    // List of indices for current point
    mwIndex *wv_selected_atoms = 0; 


    // Storage for the Cholesky decomposition of D_I' D_I
    double *mm_lt = 0;
    // Pointer to current L matrix
    double *wm_lt = 0;

    // The dict residual correlation matrix
    double* m_h = 0;
    // The dict residual correlation vector for current point
    double* wv_h = 0;

    // Result of orthogonal projection LL' z = p_I
    double *m_z = 0;
    double *wv_z  = 0;

    /// Output representation matrix
    mxArray *p_alpha;
    double *m_alpha;
    // Storage for current sparse representation vector (dense mode)
    double* wv_alpha;
    // row indices for non-zero entries in Alpha (sparse mode)
    mwIndex *ir_alpha;
    // indices for first non-zero entry in column (sparse mode)
    mwIndex *jc_alpha;
    /// Index for non-zero entries in alpha (sparse mode)
    mwIndex nz_index;


    // b = D_I' d_k in the Cholesky decomposition updates
    double* v_b = 0;
    // New vector in the Cholesky decomposition updates
    double* v_w = 0;
    // G(I) alpha
    double* v_beta = 0;
    // Some temporary vectors
    double *v_t1 = 0, *v_t2 = 0;

    // index of new atom
    mwIndex new_atom_index;
    // counters
    int i, j , k, s;
    // misc variables 
    double d1, d2;

    // structure for tracking time spent.
    omp_profile profile;
    // Take care of situation where K is unspecified.
    if (K < 0 || K > M) {
        // K cannot be greater than M.
        K = M;
    }

    // Memory allocations
    // Gram matrix
    m_gram = (double*)mxMalloc(S*S*sizeof(double));
    // Space for storing support indices for all points
    m_support_sets = (mwIndex*) mxMalloc(K*S*sizeof(mwIndex));
    // The matrix of non-zero coefficients.
    m_z = (double*)mxMalloc(K*S*sizeof(double));
    // h is in R^S.
    m_h = (double*)mxMalloc(S*S*sizeof(double));
    // Size or L cannot exceed KxK.
    mm_lt = (double*) mxMalloc(K*K*S*sizeof (double));
    // Number of entries in new line for L cannot exceed S.
    v_b = (double*)mxMalloc(S*sizeof(double));
    v_w = (double*)mxMalloc(S*sizeof(double));
    // Giving enough space for temporary vectors
    v_beta = (double*)mxMalloc(S*sizeof(double));
    v_t1 = (double*)mxMalloc(S*sizeof(double));
    v_t2 = (double*)mxMalloc(S*sizeof(double));

    // Allocate memory for output coefficients sparse matrix
    if (sparse_output == 0){
        p_alpha = mxCreateDoubleMatrix(S, S, mxREAL);
        m_alpha =  mxGetPr(p_alpha);
        ir_alpha = 0;
        jc_alpha = 0;
    }else{
        p_alpha = mxCreateSparse(S, S, K*S, mxREAL);
        m_alpha = mxGetPr(p_alpha);
        ir_alpha = mxGetIr(p_alpha);
        jc_alpha = mxGetJc(p_alpha);
        nz_index = 0;
        jc_alpha[0] = 0;
    }

    omp_profile_init(&profile);
    // Initialize gram matrix
    mult_mat_t_mat(1, m_dataset, m_dataset, m_gram, S, S, M);
    omp_profile_toc(&profile, TIME_DtD);
    // Initialize correlation matrix
    copy_vec_vec(m_gram, m_h, S*S);
    omp_profile_tic(&profile);
    // Iterate over sparsity
    for (k = 0; k < K; ++k){
        mwSize num_atoms = k+1;
        // Update solutions for each point
        for (s=0; s < S; ++s){
            // Relevant pointers
            // Correlation vector
            wv_h = m_h + S*s;
            // Support vector
            wv_selected_atoms = m_support_sets + K*s;
            // Non-zero coefficients vector
            wv_z = m_z + K*s;
            // Refer to G(:, s) as proxy vector
            wv_proxy = m_gram + S*s;
            // Location of the L matrix for s-th point
            wm_lt = mm_lt + s*K*K;
            // Set the self correlation entry to 0
            wv_h[s] = 0;
            // Find the new support index for each point.
            omp_profile_tic(&profile);
            new_atom_index = abs_max_index_2(wv_h, S);
            wv_selected_atoms[k] = new_atom_index;
            omp_profile_toctic(&profile, TIME_MaxAbs);
            // Pointer to new atom
            wv_new_gram_col = m_gram + new_atom_index*S;
            // Cholesky update
            if (k == 0){
                // Simply initialize the L matrix
                *wm_lt = 1;
            }else{
                // Incremental Cholesky decomposition
                // Correlation of new atom with older atoms
                // Extract G(I, k) i.e. from the k-th column of G
                // extract entries indexed by I.
                // note that k entries means current entry is skipped.
                vec_extract(wv_new_gram_col, wv_selected_atoms, v_b, k);
                // L' w = b
                lt_back_substitution(wm_lt, v_b, v_w, K, k);
                // Copy w to the new row of L (k-th row)
                for (j=0; j < k; ++j){
                    wm_lt[j*K + k] = v_w[j];
                }
                // Update the entry L[k, k]
                d1 = 1 - inner_product(v_w, v_w, k);
                wm_lt[k*K + k] = sqrt(d1); 
            }
            omp_profile_toctic(&profile, TIME_LCholUpdate);
            // We will now solve the equation L L' alpha_I = p_I
            vec_extract(wv_proxy, wv_selected_atoms, v_t1, num_atoms);
            spd_chol_lt_solve2(wm_lt, v_t1, wv_z, v_t2, K, num_atoms);
            omp_profile_toctic(&profile, TIME_LLtSolve);
            // Update h = Y' r
            // Compute beta  = G(I) c
            mult_submat_vec(1, m_gram, wv_selected_atoms,wv_z, v_beta, S, num_atoms);
            omp_profile_toctic(&profile, TIME_Beta);
            // h = h_0 - beta
            //v_subtract(wv_proxy, v_beta, wv_h, S);
            copy_vec_vec(wv_proxy, wv_h, S);
            sum_vec_vec(-1, v_beta, wv_h, S);
            omp_profile_toctic(&profile, TIME_HUpdate);
        }
    }
    // Finally write the outputs
    // Loop over signals
    for (s=0; s < S; ++s){
        // Relevant pointers
        // Support vector
        wv_selected_atoms = m_support_sets + K*s;
        // Non-zero coefficients vector
        wv_z = m_z + K*s;
        if(sparse_output == 0){
            // Write the output vector
            wv_alpha =  m_alpha + S*s;   
            fill_vec_sparse_vals(wv_z, wv_selected_atoms, wv_alpha, S, K);
        }
        else{
            // Sort the row indices
            quicksort_indices(wv_selected_atoms, wv_z, K);
            // add the non-zero entries for this column
            for(j=0; j <K; ++j){
                m_alpha[nz_index] = wv_z[j];
                ir_alpha[nz_index] = wv_selected_atoms[j];
                ++nz_index;
            }
            // fill in the index of first entry for next column
            jc_alpha[s+1] = jc_alpha[s] + K;
            // Note that this line automatically fills
            // Total number of nonzero entries in the end.
        }
    }

    omp_profile_print(&profile);
    // Memory cleanup
    mxFree(m_gram);
    mxFree(m_support_sets);
    mxFree(mm_lt);
    mxFree(v_b);
    mxFree(v_w);
    mxFree(m_z);
    mxFree(v_beta);
    mxFree(v_t1);
    mxFree(v_t2);
    mxFree(m_h);
    // Return the result
    return p_alpha;


}