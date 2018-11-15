/*************************************************
*
*  Batch OMP for Subspace Preserving Representations
*  Implementation
*
*************************************************/

#include <mex.h>
#include <math.h>
#include "omp.h"
#include "spxblas.h"
#include "spxalg.h"
#include "omp_profile.h"

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
    // Norms of each data vector
    double* v_norms = 0;
    double* v_norms2 = 0;
    double* v_norm_invs = 0;
    // normalized data set
    double* m_dict = 0;
    // Gram matrix
    double *m_gram = 0;
    double* m_y_gram = 0;
    // Square on the bound on the norm of residual
    double res_norm_bnd_sqr = SQR(res_norm_bnd);
    res_norm_bnd_sqr = 0;

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
    // Storage for the Cholesky decomposition of D_I' D_I
    double *m_lt = 0;
    // number or rows in lt
    mwSize lrows = 0;
    // The submatrix of gram matrix for selected atoms
    double* m_subgram = 0;
    // The submatrix of selected atoms/data vectors
    double* m_subdict = 0;
    // The proxy D' x dataset with normalized vector
    double* v_proxy = 0;
    // The proxy normalized dataset with normalized vector
    double* wv_proxy = 0;
    // Pointer to selected atom
    double* wv_new_atom = 0;
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
    // information about any low rank issues in DGELS
    mwSignedIndex info;

    // Maximum number of columns to be used in representations
    mwSize max_cols;

    // structure for tracking time spent.
    omp_profile profile;

    if (K < 0 || K > M) {
        // K cannot be greater than M.
        K = M;
    }
    // maximum number of columns expected in a submatrix.
    max_cols = (mwSize)(ceil(sqrt((double)M)/2.0) + 1.01);
    if(max_cols < K){
        max_cols = K;
    }
    // maximum number of rows in L
    lrows = K;
    // Memory allocations
    // Gram matrix Phi^T Phi
    v_norms =(double*)mxMalloc(S*sizeof(double)); 
    v_norms2 =(double*)mxMalloc(S*sizeof(double)); 
    v_norm_invs = (double*)mxMalloc(S*sizeof(double));
    // Space for normalized dataset
    m_dict  = (double*)mxMalloc(M*S*sizeof(double));
    m_gram = (double*)mxMalloc(S*S*sizeof(double));
    // Unnormalized Gram matrix Y^T Phi
    m_y_gram = (double*)mxMalloc(S*S*sizeof(double));
    // Number of selected atoms cannot exceed M
    selected_atoms = (mwIndex*) mxMalloc(M*sizeof(mwIndex));
    // Number of rows in L cannot exceed M. Number of columns 
    // cannot exceed max_cols.
    m_lt = (double*) mxMalloc(lrows*max_cols*sizeof (double));
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
    m_subdict = (double*)mxMalloc(max_cols*M*sizeof(double));
    // Proxy is D' x
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

    omp_profile_init(&profile);
    // Compute norm of each vector in dataset
    mat_col_norms(m_dataset, v_norms, M, S);
    // Compute the norm inverse for each column
    vec_elt_wise_inv(v_norms, v_norm_invs, S);
    // Compute the m_dict directly here
    copy_vec_vec(m_dataset, m_dict, M*S);
    // mat_col_norms(m_dict, v_norms2, M, S);
    // print_vector(v_norms2, 10, "Phi norms");
    mat_col_scale(m_dict, v_norm_invs, M, S);
    // mat_col_norms(m_dict, v_norms2, M, S);
    // print_vector(v_norms2, 10, "Phi norms");

    // Initialize gram matrix
    mult_mat_t_mat(1, m_dataset, m_dict, m_y_gram, S, S, M);

    // Compute Phi^T Phi
    copy_vec_vec(m_y_gram, m_gram, S*S);
    mat_row_scale(m_gram, v_norm_invs, S, S);

    //mult_mat_t_mat(1, m_dict, m_dict, m_gram, S, S, M);
    omp_profile_toctic(&profile, TIME_DtD);

    // Loop over signals
    for (s=0; s < S; ++s){
        // Initialization
        // Current data point
        wv_x = m_dict + M*s;
        // By default, there is no need to track the residual norm
        res_norm_sqr = 1;
        // normalized dict with normalized vector product
        wv_proxy = m_gram + S*s;
        //Compute proxy p  = D' * x  dataset with normalized vector
        //mult_mat_t_vec(1, m_dataset, wv_x, v_proxy, M, S);
        // h = p = D' * r
        copy_vec_vec(m_y_gram + S*s, v_h, S);
        // initialize previous value of delta as 0.
        prev_delta = 0;
        // Number of atoms selected so far.
        k = 0;
        // Iterate for each atom
        while (k < K &&  res_norm_sqr > res_norm_bnd_sqr){
            // ignore s-th atom from consideration
            v_h[s] = 0;
            // Pick the index of (k+1)-th atom
            omp_profile_tic(&profile);
            new_atom_index = abs_max_index(v_h, S);
            omp_profile_toctic(&profile, TIME_MaxAbs);
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
            // Copy the column for the new atom in gram matrix to 
            // the sub-gram matrix
            wv_new_gram_col = m_gram + new_atom_index*S;
            copy_vec_vec(wv_new_gram_col, m_subgram+k*S, S);
            omp_profile_toctic(&profile, TIME_GramSubMatrixUpdate);

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
                lt_back_substitution(m_lt, v_b, v_w, lrows, k);
                // Copy w to the new row of L (k-th row)
                for (j=0; j < k; ++j){
                    m_lt[j*lrows + k] = v_w[j];
                }
                // Update the entry L[k, k]
                d1 = 1 - inner_product(v_w, v_w, k);
                if (d1 <= 1e-14){
                    // Selected atoms are dependent.
                    break;
                }
                m_lt[k*lrows + k] = sqrt(d1);    
            }
            omp_profile_toctic(&profile, TIME_LCholUpdate);
            // It is time to increase the count of selected atoms
            ++k;
            // We will now solve the equation L L' alpha_I = p_I
            // Compute b = Phi_I^T y from normalized dict with normalized data
            vec_extract(wv_proxy, selected_atoms, v_t1, k);
            //spd_chol_lt_solve(m_lt, v_t1, v_z, lrows, k);
            spd_chol_lt_solve2(m_lt, v_t1, v_z, v_t2, lrows, k);
            // spd_lt_trtrs(m_lt, v_t1, lrows, k);
            // copy_vec_vec(v_t1, v_z, k);
            omp_profile_toctic(&profile, TIME_LLtSolve);

            // Update h = Y' r
            // Compute beta  = G(I) c
            //mult_mat_vec(1, m_subgram, v_z, v_beta, S, k);
            mult_submat_vec(1, m_y_gram, selected_atoms, v_z, v_beta, S, k);
            omp_profile_toctic(&profile, TIME_Beta);
    #if SPR_DEBUG
            print_vector(v_h, S, "h");
            print_vector(v_beta, S, "beta");
    #endif
            // h = h_0 - beta
            copy_vec_vec(m_y_gram + S*s, v_h, S);
            sum_vec_vec(-1, v_beta, v_h, S);
            omp_profile_toctic(&profile, TIME_HUpdate);
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
        // Solve the LS problem again
        // Build the sub dictionary from the dataset
        for (i=0; i<k; ++i){
            new_atom_index = selected_atoms[i];
            wv_new_atom = m_dataset + new_atom_index*M;
            copy_vec_vec(wv_new_atom, m_subdict+i*M, M);
        }
        // The signal whose representation is to be constructed.
        wv_x = m_dataset + M*s;
        copy_vec_vec(wv_x, v_z, M);
        // Solving the least squares problem using QR through DGELS
        info = ls_qr_solve(m_subdict, v_z, M, k);
        if (info > 0) {
             mexPrintf( "The diagonal element %i of the triangular factor ", info );
             mexPrintf( "of A is zero, so that A does not have full rank;\n" );
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

    omp_profile_print(&profile);
    // Memory cleanup
    mxFree(v_norms);
    mxFree(v_norms2);
    mxFree(v_norm_invs);
    mxFree(m_dict);
    mxFree(m_gram);
    mxFree(m_y_gram);
    mxFree(selected_atoms);
    mxFree(m_lt);
    mxFree(v_b);
    mxFree(v_w);
    mxFree(v_z);
    mxFree(v_beta);
    mxFree(v_t1);
    mxFree(v_t2);
    mxFree(m_subgram);
    mxFree(m_subdict);
    mxFree(v_proxy);
    mxFree(v_h);
    // Return the result
    return p_alpha;


}