/*************************************************
*
*  Bath OMP Implementation
*
*************************************************/

#include <mex.h>
#include <math.h>
#include "omp.h"
#include "spxblas.h"


mxArray* batch_omp_gram(const BatchOMPInput* in){

    /**
    Following variables are common for all signals being processed.
    */
    // Dictionary
    double* m_dict = in->m_dict;
    // Signal matrix
    double *m_x = in->m_x;
    // Gram matrix
    double *m_gram = in->m_gram;
    // D' X matrix
    double *m_dtx = in->m_dtx;
    // Signal space
    mwSize M = in->M;
    // Number of atoms
    mwSize N = in->N;
    // Sparsity level
    mwSize K = in->K;
    // Number of signals
    mwSize S = in->S;
    // Square on the bound on the norm of residual
    double res_norm_bnd_sqr = SQR(in->res_norm_bnd);
    /// Output representation matrix
    mxArray* p_alpha;
    double* m_alpha;


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
    // Result of orthogonal projection LL' c = p_I
    double* v_c = 0;
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
    // Number of selected atoms cannot exceed M
    selected_atoms = (mwIndex*) mxMalloc(M*sizeof(mwIndex));
    // Total number of atoms is N
    selected_atoms_mask = (int*) mxMalloc(N*sizeof(int));
    // Number of rows in L cannot exceed M. Number of columns 
    // cannot exceed max_cols.
    m_lt = (double*) mxMalloc(M*max_cols*sizeof (double));
    // Number of entries in new line for L cannot exceed N.
    v_b = (double*)mxMalloc(N*sizeof(double));
    v_w = (double*)mxMalloc(N*sizeof(double));
    v_c = (double*)mxMalloc(M*sizeof(double));
    // Giving enough space for temporary vectors
    v_beta = (double*)mxMalloc(N*sizeof(double));
    v_t1 = (double*)mxMalloc(N*sizeof(double));
    v_t2 = (double*)mxMalloc(N*sizeof(double));
    // Keeping max_cols space for submatrix of gram matrix. 
    m_subgram = (double*)mxMalloc(max_cols*N*sizeof(double));
    // Proxy vector is in R^N
    v_proxy = (double*)mxMalloc(N*sizeof(double));
    // h is in R^N.
    v_h = (double*)mxMalloc(N*sizeof(double));

    // Allocate memory for output coefficients sparse matrix
    p_alpha = mxCreateDoubleMatrix(N, S, mxREAL);
    m_alpha =  mxGetPr(p_alpha);

    // Loop over signals
    for (s=0; s < S; ++s){
        // By default, there is no need to track the residual norm
        res_norm_sqr = 1;
        // Initialization
        if (0 == m_dtx){
            // Current signal vector
            wv_x  = m_x + M * s;
            //Compute proxy p  = D' * x
            mult_mat_t_vec(1, m_dict, wv_x, v_proxy, M, N);
            if (res_norm_bnd_sqr > 0){
                // norm of current residual = current signal vector
                res_norm_sqr = inner_product(wv_x, wv_x, M);
            }
        }else{
            // Copy D' x from the D' X matrix
            copy_vec_vec(m_dtx + N*s, v_proxy, N);
        }
        // h = p = D' * r
        copy_vec_vec(v_proxy, v_h, N);
        // initialize previous value of delta as 0.
        prev_delta = 0;
        // Initialize the mask of selected atoms.
        for (i=0; i<N; ++i){
            selected_atoms_mask[i] = 0;
        }
    #if CHOL_DEBUG
    #endif
        // Number of atoms selected so far.
        k = 0;
        // Iterate for each atom
        while (k < K &&  res_norm_sqr > res_norm_bnd_sqr){
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
            // Copy the column for the new atom in gram matrix to 
            // the sub-gram matrix
            wv_new_gram_col = m_gram + new_atom_index*N;
            copy_vec_vec(wv_new_gram_col, m_subgram+k*N, N);

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
            spd_chol_lt_solve(m_lt, v_t1, v_c, M, k);


            // Update h = D' r
            // Compute beta  = G(I) c
            mult_mat_vec(1, m_subgram, v_c, v_beta, N, k);
            // h = h_0 - beta
            copy_vec_vec(v_proxy, v_h, N);
            sum_vec_vec(-1, v_beta, v_h, N);
            // Update residual norm squared
            if (res_norm_bnd_sqr > 0){
                // Extract beta (I)
                vec_extract(v_beta, selected_atoms, v_t2, k);
                delta = inner_product(v_t2, v_c, k);
                res_norm_sqr = res_norm_sqr - delta + prev_delta;
                prev_delta = delta;
            }
            else{
                // We don't need to track the norm of residual
                res_norm_sqr = 1;
            }
        }

        // Write the output vector
        wv_alpha =  m_alpha + N*s;   
        fill_vec_sparse_vals(v_c, selected_atoms, wv_alpha, N, k);

    }

    // Memory cleanup
    mxFree(selected_atoms);
    mxFree(selected_atoms_mask);
    mxFree(m_lt);
    mxFree(v_b);
    mxFree(v_w);
    mxFree(v_c);
    mxFree(v_beta);
    mxFree(v_t1);
    mxFree(v_t2);
    mxFree(v_proxy);
    mxFree(v_h);
    // Return the result
    return p_alpha;


}