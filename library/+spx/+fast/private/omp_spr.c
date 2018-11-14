/*************************************************
*
*  OMP Based Computation of Subspace Preserving 
*  Representations
*
*************************************************/

#include <mex.h>
#include <math.h>
#include "omp.h"
#include "spxblas.h"
#include "spxalg.h"

#define SPR_DEBUG 1

mxArray* omp_spr(double *m_dataset, // Dataset
    double *m_dict, // Normalized dataset
    mwSize M, // Data dimension
    mwSize S, // Number of signals
    mwSize K, // Sparsity level
    double res_norm_bnd, // Residual norm bound
    int sparse_output // Whether output is sparse matrix
    ){

    /**
    Following variables are common for all signals being processed.
    */
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
    // number or rows in lt
    mwSize lrows = 0;
    // The submatrix of dictionary for selected atoms
    double* m_subdict = 0;
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
    // Residual 
    double* v_r = 0;
    // Some temporary vectors
    double *v_t1 = 0, *v_t2 = 0;
    // Pointer to corresponding column in data set 
    const double* wv_new_atom;
    // residual norm squared
    double res_norm_sqr;
    // Storage for current sparse representation vector
    double* wv_alpha;
    // index of new atom
    mwIndex new_atom_index;

    // counters
    int i, j , k, s, ii;
    // misc variables 
    double d1, d2;
    // information about any low rank issues in DGELS
    mwSignedIndex info;

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
    // maximum number of rows in L
    lrows = M;
    // Memory allocations
    // Number of selected atoms cannot exceed M
    selected_atoms = (mwIndex*) mxMalloc(M*sizeof(mwIndex));
    // Total number of atoms is S
    selected_atoms_mask = (int*) mxMalloc(S*sizeof(int));
    // Number of rows in L cannot exceed M. Number of columns 
    // cannot exceed max_cols.
    m_lt = (double*) mxMalloc(lrows*max_cols*sizeof (double));
    // Number of entries in new line for L cannot exceed lrows.
    v_b = (double*)mxMalloc(S*sizeof(double));
    v_w = (double*)mxMalloc(S*sizeof(double));
    // the non-zero coefficients array [cannot be longer than M]
    v_z = (double*)mxMalloc(M*sizeof(double));
    // Giving enough space for temporary vectors
    v_t1 = (double*)mxMalloc(S*sizeof(double));
    v_t2 = (double*)mxMalloc(S*sizeof(double));
    // Keeping max_cols space for submatrix of gram matrix. 
    m_subdict = (double*)mxMalloc(max_cols*M*sizeof(double));
    // Proxy vector is in R^S
    v_proxy = (double*)mxMalloc(S*sizeof(double));
    // h is in R^S.
    v_h = (double*)mxMalloc(S*sizeof(double));
    // residual r \in R^M.
    v_r = (double*)mxMalloc(M*sizeof(double));

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

    // Loop over signals
    for (s=0; s < S; ++s){
        // Current data point
        wv_x = m_dict + M*s;
        // By default, there is no need to track the residual norm
        // since data points are unit norm, hence residual norm
        // is initialized to 1.
        res_norm_sqr = 1;
        // Initialization
        //Compute proxy p  = D' * x
        mult_mat_t_vec(1, m_dataset, wv_x, v_proxy, M, S);
        // h = p = D' * r
        copy_vec_vec(v_proxy, v_h, S);
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
            // Copy  the new atom in subdictionary
            wv_new_atom = m_dict + new_atom_index*M;
            copy_vec_vec(wv_new_atom, m_subdict+k*M, M);
            // Cholesky update
            if (k == 0){
                // Simply initialize the L matrix
                *m_lt = 1;
            }else{
                // Incremental Cholesky decomposition
                // note that k atoms means current atom is skipped.
                mult_mat_t_vec(1, m_subdict, wv_new_atom, v_b, M, k);
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
            // It is time to increase the count of selected atoms
            ++k;
            // We will now solve the equation L L' alpha_I = b
            // Compute b = Phi_I^T y
            mult_mat_t_vec(1, m_subdict, wv_x, v_t1, M, k);
            // vec_extract(v_proxy, selected_atoms, v_t1, k);
            //spd_chol_lt_solve(m_lt, v_t1, v_z, lrows, k);
            spd_chol_lt_solve2(m_lt, v_t1, v_z, v_t2, lrows, k);
            // spd_lt_trtrs(m_lt, v_t1, lrows, k);
            // copy_vec_vec(v_t1, v_z, k);

            // Compute residual
            // r  = x - D_I c
            mult_mat_vec(-1, m_subdict, v_z, v_r, M, k);
            sum_vec_vec(1, wv_x, v_r, M);
            // Update h = D' r
            mult_mat_t_vec(1, m_dataset, v_r, v_h, M, S);
            // Update residual norm squared
            if (res_norm_bnd_sqr > 0){
                // Update residual norm squared
                res_norm_sqr = inner_product(v_r, v_r, M);
            }
            else{
                // We don't need to track the norm of residual
                res_norm_sqr = 1;
            }
        }
    #if SPR_DEBUG
        //mexPrintf("%d: %d, \n.", s, k);
    #endif
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
        // The solution coefficients are stored in v_z
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

    mxFree(selected_atoms);
    mxFree(selected_atoms_mask);
    mxFree(m_lt);
    mxFree(v_b);
    mxFree(v_w);
    mxFree(v_z);
    mxFree(v_t1);
    mxFree(v_t2);
    mxFree(m_subdict);
    mxFree(v_proxy);
    mxFree(v_h);
    mxFree(v_r);
    // Return the result
    return p_alpha;


}