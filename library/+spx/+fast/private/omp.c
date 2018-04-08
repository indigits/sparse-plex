

#include <mex.h>
#include <math.h>
#include "omp.h"
#include "omp_profile.h"
#include "spxblas.h"
#include "spxalg.h"


#define CHOL_DEBUG 1


mxArray* omp(const double m_dict[], 
    const double m_x[],
    mwSize M, 
    mwSize N,
    mwSize S,
    mwSize K, 
    double res_norm_bnd,
    int sparse_output){

    // List of indices of selected atoms
    mwIndex *selected_atoms = 0; 
    // Simple binary mask of selected atoms
    int* selected_atoms_mask = 0;   
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
    // square of upper bound on residual norm
    double res_norm_bnd_sqr = SQR(res_norm_bnd);
    // Pointer to current signal
    const double *wv_x = 0;

    /// Output array
    mxArray* p_alpha;
    double* m_alpha;
    // row indices for non-zero entries in Alpha
    mwIndex *ir_alpha;
    // indices for first non-zero entry in column
    mwIndex *jc_alpha;
    /// Index for non-zero entries in alpha
    mwIndex nz_index;


    // counters
    int i, j , k, s;
    // index of new atom
    mwIndex new_atom_index;
    // misc variables 
    double d1, d2;

    // Maximum number of columns to be used in representations
    mwSize max_cols;

    // structure for tracking time spent.
    omp_profile profile;

    // Print input data
#if CHOL_DEBUG
    //print_matrix(m_dict, M, N, "D");
    //print_matrix(m_x, M, S, "X");
    //mexPrintf("M: %d, N:%d, S: %d, K: %d\n", M, N, S, K);
#endif
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

    if (sparse_output == 0){
        p_alpha = mxCreateDoubleMatrix(N, S, mxREAL);
        m_alpha =  mxGetPr(p_alpha);
        ir_alpha = 0;
        jc_alpha = 0;
    }else{
        p_alpha = mxCreateSparse(N, S, max_cols*S, mxREAL);
        m_alpha = mxGetPr(p_alpha);
        ir_alpha = mxGetIr(p_alpha);
        jc_alpha = mxGetJc(p_alpha);
        nz_index = 0;
        jc_alpha[0] = 0;
    }
    omp_profile_init(&profile);

    for(s=0; s<S; ++s){
        wv_x = m_x + M*s;
        // Initialization
        res_norm_sqr = inner_product(wv_x, wv_x, M);
        //Compute proxy p  = D' * x
        mult_mat_t_vec(1, m_dict, wv_x, v_proxy, M, N);
        omp_profile_toctic(&profile, TIME_DtR);
        // h = p = D' * r
        copy_vec_vec(v_proxy, v_h, N);
        for (i=0; i<N; ++i){
            selected_atoms_mask[i] = 0;
        }
        // Number of atoms selected so far.
        k = 0;
        // Iterate for each atom
        while (k < K &&  res_norm_sqr > res_norm_bnd_sqr){
            omp_profile_tic(&profile);
            // Pick the index of (k+1)-th atom
            new_atom_index = abs_max_index(v_h, N);
            omp_profile_toctic(&profile, TIME_MaxAbs);
            // If this atom is already selected, we will break
            if (selected_atoms_mask[new_atom_index]){
                // This is unlikely due to orthogonal structure of OMP
    #if CHOL_DEBUG
                //mexPrintf("This atom is already selected.");
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
            omp_profile_toctic(&profile, TIME_DictSubMatrixUpdate);

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
            omp_profile_toctic(&profile, TIME_LCholUpdate);
            // It is time to increase the count of selected atoms
            ++k;
            // We will now solve the equation L L' alpha_I = p_I
            vec_extract(v_proxy, selected_atoms, v_t1, k);
            spd_chol_lt_solve(m_lt, v_t1, v_c, M, k);
            omp_profile_toctic(&profile, TIME_LLtSolve);
            // Compute residual
            // r  = x - D_I c
            mult_mat_vec(-1, m_subdict, v_c, v_r, M, k);
            sum_vec_vec(1, wv_x, v_r, M);
            omp_profile_toctic(&profile, TIME_RUpdate);
            // Update h = D' r
            mult_mat_t_vec(1, m_dict, v_r, v_h, M, N);
            // Update residual norm squared
            res_norm_sqr = inner_product(v_r, v_r, M);
            omp_profile_toctic(&profile, TIME_DtR);
            //mexPrintf(".\n");
        }

        // Write the output vector
        if(sparse_output == 0){
            // Write the output vector
            double* wv_alpha =  m_alpha + N*s;
            fill_vec_sparse_vals(v_c, selected_atoms, wv_alpha, N, k);
        }
        else{
            // Sort the row indices
            quicksort_indices(selected_atoms, v_c, k);
            // add the non-zero entries for this column
            for(j=0; j <k; ++j){
                m_alpha[nz_index] = v_c[j];
                ir_alpha[nz_index] = selected_atoms[j];
                ++nz_index;
            }
            // fill in the total number of nonzero entries in the end.
            jc_alpha[s+1] = jc_alpha[s] + k;
        }
    }
    omp_profile_print(&profile);

    // Memory cleanup
    mxFree(selected_atoms);
    mxFree(selected_atoms_mask);
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



