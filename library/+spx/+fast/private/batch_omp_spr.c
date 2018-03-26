/*************************************************
*
*  Bath OMP Implementation
*
*************************************************/

#include <mex.h>
#include <math.h>
#include "omp.h"
#include "spxblas.h"
#include "spxalg.h"

#define SPR_DEBUG 0

mxArray* batch_omp_spr(double *m_dataset, // Dataset
    mwSize M, // Data dimension
    mwSize S, // Number of signals
    mwSize K, // Sparsity level
    double res_norm_bnd, // Residual norm bound
    int sparse_output // Whether output is sparse matrix
    ){

    /**
    Following variables are common for all signals being processed.
    */
    // Gram matrix
    double *m_gram = 0;
    // Square on the bound on the norm of residual
    double res_norm_bnd_sqr = SQR(res_norm_bnd);

    /// Output representation matrix
    mxArray *p_alpha;
    double *m_alpha;
    // row indices for non-zero entries in Alpha
    mwIndex *ir_alpha;
    // indices for first non-zero entry in column
    mwIndex *jc_alpha;
    /// Index for non-zero entries in alpha
    mwIndex nz_index;


    /**
    Following variables are used in each signal iteration.
    */
    // Current signal vector
    double* wv_x;
    // List of indices of selected atoms
    mwIndex *selected_atoms = 0; 
    // Simple binary mask of selected atoms
    int* selected_atoms_mask = 0;   
    // Storage for the Cholesky decomposition of D_I' D_I
    double *m_lt = 0;
    // The submatrix of gram matrix for selected atoms
    double* m_subgram = 0;
    // The proxy D' x
    double* v_proxy = 0;
    // The inner product of residual with atoms
    double* v_h = 0;
    // b = D_I' d_k in the Cholesky decomposition updates
    double* v_b = 0;
    // New vector in the Cholesky decomposition updates
    double* v_w = 0;
    // Result of orthogonal projection LL' z = p_I
    double* v_z = 0;
    // G(I) alpha
    double* v_beta = 0;
    // Some temporary vectors
    double *v_t1 = 0, *v_t2 = 0;
    // Pointer to corresponding column in G 
    const double* wv_new_gram_col;
    // residual norm squared
    double res_norm_sqr;
    // Storage for current sparse representation vector
    double* wv_alpha;
    // trackers for alpha' * G * alpha
    double delta, prev_delta;
    // index of new atom
    mwIndex new_atom_index;

    // counters
    int i, j , k, s;
    // misc variables 
    double d1, d2;

    // Maximum number of columns to be used in representations
    mwSize max_cols;

    if (K < 0 || K > M) {
        // K cannot be greater than M.
        K = M;
    }
    // maximum number of columns expected in a submatrix.
    max_cols = (mwSize)(ceil(sqrt((double)M)/2.0) + 1.01);
    if(max_cols < K){
        max_cols = K;
    }
    // Memory allocations
    // Gram matrix
    m_gram = (double*)mxMalloc(S*S*sizeof(double));
    // Number of selected atoms cannot exceed M
    selected_atoms = (mwIndex*) mxMalloc(M*sizeof(mwIndex));
    // Total number of atoms is S
    selected_atoms_mask = (int*) mxMalloc(S*sizeof(int));
    // Number of rows in L cannot exceed M. Number of columns 
    // cannot exceed max_cols.
    m_lt = (double*) mxMalloc(M*max_cols*sizeof (double));
    // Number of entries in new line for L cannot exceed S.
    v_b = (double*)mxMalloc(S*sizeof(double));
    v_w = (double*)mxMalloc(S*sizeof(double));
    v_z = (double*)mxMalloc(M*sizeof(double));
    // Giving enough space for temporary vectors
    v_beta = (double*)mxMalloc(S*sizeof(double));
    v_t1 = (double*)mxMalloc(S*sizeof(double));
    v_t2 = (double*)mxMalloc(S*sizeof(double));
    // Keeping max_cols space for submatrix of gram matrix. 
    m_subgram = (double*)mxMalloc(max_cols*S*sizeof(double));
    // Proxy vector is in R^S
    v_proxy = (double*)mxMalloc(S*sizeof(double));
    // h is in R^S.
    v_h = (double*)mxMalloc(S*sizeof(double));

    // Allocate memory for output coefficients sparse matrix
    if (sparse_output == 0){
        p_alpha = mxCreateDoubleMatrix(S, S, mxREAL);
        m_alpha =  mxGetPr(p_alpha);
        ir_alpha = 0;
        jc_alpha = 0;
    }else{
        p_alpha = mxCreateSparse(S, S, max_cols*S, mxREAL);
        m_alpha = mxGetPr(p_alpha);
        ir_alpha = mxGetIr(p_alpha);
        jc_alpha = mxGetJc(p_alpha);
        nz_index = 0;
        jc_alpha[0] = 0;
    }

    // Initialize gram matrix
    mult_mat_t_mat(1, m_dataset, m_dataset, m_gram, S, S, M);
    // set the diagonal elements of gram matrix to zero
    // for (s=0; s < S; ++s){
    //     m_gram[s*S + s] = 0;
    // }

    // Loop over signals
    for (s=0; s < S; ++s){
        // By default, there is no need to track the residual norm
        res_norm_sqr = 1;
        // Initialization
        // Copy G(:, s) as proxy vector
        copy_vec_vec(m_gram + S*s, v_proxy, S);
        // h = p = D' * r
        copy_vec_vec(v_proxy, v_h, S);
        // initialize previous value of delta as 0.
        prev_delta = 0;
        // Initialize the mask of selected atoms.
        for (i=0; i<S; ++i){
            selected_atoms_mask[i] = 0;
        }
        // Number of atoms selected so far.
        k = 0;
        // Iterate for each atom
        while (k < K &&  res_norm_sqr > res_norm_bnd_sqr){
            // ignore s-th atom from consideration
            v_h[s] = 0;
            // Pick the index of (k+1)-th atom
            new_atom_index = abs_max_index(v_h, S);
            // If this atom is already selected, we will break
            if (selected_atoms_mask[new_atom_index]){
                // This is unlikely due to orthogonal structure of OMP
    #if SPR_DEBUG
                mexPrintf("This atom is already selected\n.");
    #endif
                break;
            }
            // Check for small values
            d2 = v_h[new_atom_index];
            if (SQR(d2) < 1e-14){
                // The inner product of residual with new atom is way too small.
    #if SPR_DEBUG
                mexPrintf("Inner product is too small\n.");
    #endif
                break;
            }
            // Store the index of new atom
            selected_atoms[k] = new_atom_index;
            selected_atoms_mask[new_atom_index] = 1;
            // Copy the column for the new atom in gram matrix to 
            // the sub-gram matrix
            wv_new_gram_col = m_gram + new_atom_index*S;
            copy_vec_vec(wv_new_gram_col, m_subgram+k*S, S);

            // Cholesky update
            if (k == 0){
                // Simply initialize the L matrix
                *m_lt = 1;
            }else{
                // Incremental Cholesky decomposition
                // Extract G(I, k) i.e. from the k-th column of G(I)
                // extract entries indexed by I.
                // note that k entries means current entry is skipped.
                vec_extract(wv_new_gram_col, selected_atoms, v_b, k);
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
                    break;
                }
                m_lt[k*M + k] = sqrt(d1);    
            }
            // It is time to increase the count of selected atoms
            ++k;
            // We will now solve the equation L L' alpha_I = p_I
            vec_extract(v_proxy, selected_atoms, v_t1, k);
            spd_chol_lt_solve(m_lt, v_t1, v_z, M, k);


            // Update h = Y' r
            // Compute beta  = G(I) c
            mult_mat_vec(1, m_subgram, v_z, v_beta, S, k);
    #if SPR_DEBUG
            print_vector(v_h, S, "h");
            print_vector(v_beta, S, "beta");
    #endif
            // h = h_0 - beta
            copy_vec_vec(v_proxy, v_h, S);
            sum_vec_vec(-1, v_beta, v_h, S);
    #if SPR_DEBUG
            print_vector(v_h, S, "h");
    #endif
            // Update residual norm squared
            if (res_norm_bnd_sqr > 0){
                // Extract beta (I)
                vec_extract(v_beta, selected_atoms, v_t2, k);
                delta = inner_product(v_t2, v_z, k);
                res_norm_sqr = res_norm_sqr - delta + prev_delta;
                prev_delta = delta;
            }
            else{
                // We don't need to track the norm of residual
                res_norm_sqr = 1;
            }
        }

        if(sparse_output == 0){
            // Write the output vector
            wv_alpha =  m_alpha + S*s;   
            fill_vec_sparse_vals(v_z, selected_atoms, wv_alpha, S, k);
        }
        else{
            if (nz_index + k > max_cols*S){
                // TODO. Reallocate.
            }
            // Sort the row indices
            quicksort_indices(selected_atoms, v_z, k);
            // add the non-zero entries for this column
            for(j=0; j <k; ++j){
                m_alpha[nz_index] = v_z[j];
                ir_alpha[nz_index] = selected_atoms[j];
                ++nz_index;
            }
            // fill in the index of first entry for next column
            jc_alpha[s+1] = jc_alpha[s] + k;
            // Note that this line automatically fills
            // Total number of nonzero entries in the end.
        }
    }

    // Memory cleanup
    mxFree(m_gram);
    mxFree(selected_atoms);
    mxFree(selected_atoms_mask);
    mxFree(m_lt);
    mxFree(v_b);
    mxFree(v_w);
    mxFree(v_z);
    mxFree(v_beta);
    mxFree(v_t1);
    mxFree(v_t2);
    mxFree(m_subgram);
    mxFree(v_proxy);
    mxFree(v_h);
    // Return the result
    return p_alpha;


}