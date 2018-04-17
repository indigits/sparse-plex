
/*************************************************
*
*  GOMP Implementation
*
*************************************************/

#include <mex.h>
#include <math.h>
#include "omp.h"
#include "omp_profile.h"
#include "spxblas.h"
#include "spxalg.h"
#include "spxla.h"


mxArray* gomp_ls(const double m_dict[], 
    const double m_x[],
    mwSize M, 
    mwSize N,
    mwSize S,
    mwSize K,
    mwSize L, 
    double res_norm_bnd,
    int sparse_output,
    int verbose){

    // List of indices of selected atoms
    mwIndex *selected_atoms = 0; 
    // Atom indices needed during selection
    mwIndex* atom_indices = 0;   
    // The submatrix of selected atoms
    double* m_subdict = 0;
    // Copy of subdictionary for least squares
    double* m_subdict_copy = 0;
    // The proxy D' x
    double* v_proxy = 0;
    // The inner product of residual with atoms
    double* v_h = 0;
    // The residual
    double* v_r = 0;
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

    // Maximum number of atoms to be used in representations
    mwSize max_atoms;

    // structure for tracking time spent.
    omp_profile profile;

    if (K < 0 || K > M / L) {
        // K cannot be greater than M / L.
        K = M / L;
    }
    max_atoms = K*L;
    // Memory allocations
    // Number of selected atoms cannot exceed M
    selected_atoms = (mwIndex*) mxMalloc(M*sizeof(mwIndex));
    // Total number of atoms is N
    atom_indices = (mwIndex*) mxMalloc(N*sizeof(mwIndex));
    // Coefficients of solution of least square problem
    v_c = (double*)mxMalloc(M*sizeof(double));
    // Giving enough space for temporary vectors
    v_t1 = (double*)mxMalloc(N*sizeof(double));
    v_t2 = (double*)mxMalloc(N*sizeof(double));
    // Keeping max_atoms space for subdictionary. 
    m_subdict = (double*)mxMalloc(max_atoms*M*sizeof(double));
    m_subdict_copy = (double*)mxMalloc(max_atoms*M*sizeof(double));
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
        p_alpha = mxCreateSparse(N, S, max_atoms*S, mxREAL);
        m_alpha = mxGetPr(p_alpha);
        ir_alpha = mxGetIr(p_alpha);
        jc_alpha = mxGetJc(p_alpha);
        nz_index = 0;
        jc_alpha[0] = 0;
    }
    omp_profile_init(&profile);

    for(s=0; s<S; ++s){
        // Counter for selected atoms
        int kk = 0;
        wv_x = m_x + M*s;
        // Initialization
        res_norm_sqr = inner_product(wv_x, wv_x, M);
        //Compute proxy p  = D' * x
        mult_mat_t_vec(1, m_dict, wv_x, v_proxy, M, N);
        omp_profile_toctic(&profile, TIME_DtR);
        // h = p = D' * r
        copy_vec_vec(v_proxy, v_h, N);
        // Iteration counter for selecting bunch of atoms in each iteration.
        k = 0;
        // In each iteration we select up to L atoms
        while (k < K &&  res_norm_sqr > res_norm_bnd_sqr){
            if (verbose > 1){
                mexPrintf("k: %d :: ", k+1);
            }
            omp_profile_tic(&profile);
            // Square correlations and assign indices
            for (i=0; i<N; ++i){
                // Square the correlation
                v_h[i] = SQR(v_h[i]);
                // Assign indices to atoms
                atom_indices[i] = i;
            }
            // Search for L largest atoms
            quickselect_desc(v_h, atom_indices, N, L);
            omp_profile_toctic(&profile, TIME_MaxAbs);
            // Store the indices 
            for (i=0; i < L; ++i){
                new_atom_index = atom_indices[i];
                selected_atoms[kk] = new_atom_index;
                // Copy the new atom to the sub-dictionary
                wv_new_atom = m_dict + new_atom_index*M;
                copy_vec_vec(wv_new_atom, m_subdict+kk*M, M);
                if (verbose > 1){
                    mexPrintf("%d ", new_atom_index+1);
                }
                ++kk;
            }
            omp_profile_toctic(&profile, TIME_DictSubMatrixUpdate);
            // We can increase the iteration count
            ++k;
            // Least squares
            copy_vec_vec(m_subdict, m_subdict_copy, M*kk);
            copy_vec_vec(wv_x, v_t1, M);
            least_square(m_subdict_copy, v_t1, v_c, M, kk, 1);
            omp_profile_toctic(&profile, TIME_LeastSquares);
            // Compute residual
            // r  = x - D_I c
            mult_mat_vec(-1, m_subdict, v_c, v_r, M, kk);
            sum_vec_vec(1, wv_x, v_r, M);
            omp_profile_toctic(&profile, TIME_RUpdate);
            // Update h = D' r
            mult_mat_t_vec(1, m_dict, v_r, v_h, M, N);
            // Update residual norm squared
            res_norm_sqr = inner_product(v_r, v_r, M);
            omp_profile_toctic(&profile, TIME_DtR);
            if(verbose > 1){
                mexPrintf(" \\| r \\|_2^2 : %.4f.\n", res_norm_sqr);
            }
        }

        // Write the output vector
        if(sparse_output == 0){
            // Write the output vector
            double* wv_alpha =  m_alpha + N*s;
            fill_vec_sparse_vals(v_c, selected_atoms, wv_alpha, N, kk);
        }
        else{
            // Sort the row indices
            quicksort_indices(selected_atoms, v_c, kk);
            // add the non-zero entries for this column
            for(j=0; j <kk; ++j){
                m_alpha[nz_index] = v_c[j];
                ir_alpha[nz_index] = selected_atoms[j];
                ++nz_index;
            }
            // fill in the total number of nonzero entries in the end.
            jc_alpha[s+1] = jc_alpha[s] + kk;
        }
    }
    if(verbose){
        omp_profile_print(&profile);
    }

    // Memory cleanup
    mxFree(selected_atoms);
    mxFree(atom_indices);
    mxFree(v_c);
    mxFree(v_t1);
    mxFree(v_t2);
    mxFree(m_subdict);
    mxFree(m_subdict_copy);
    mxFree(v_proxy);
    mxFree(v_h);
    mxFree(v_r);

    // Return the result
    return p_alpha;
}


mxArray* gomp_chol(const double m_dict[], 
    const double m_x[],
    mwSize M, 
    mwSize N,
    mwSize S,
    mwSize K, 
    mwSize L, 
    double res_norm_bnd,
    int sparse_output,
    int verbose){

    // List of indices of selected atoms
    mwIndex *selected_atoms = 0; 
    // Atom indices needed during selection
    mwIndex* atom_indices = 0;   
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
    mwSize max_atoms;

    // structure for tracking time spent.
    omp_profile profile;

    if (K < 0 || K > M / L) {
        // K cannot be greater than M / L.
        K = M / L;
    }
    max_atoms = K*L;
    // Memory allocations
    // Number of selected atoms cannot exceed M
    selected_atoms = (mwIndex*) mxMalloc(M*sizeof(mwIndex));
    // Total number of atoms is N
    atom_indices = (mwIndex*) mxMalloc(N*sizeof(mwIndex));
    // Number of rows and columns in L cannot exceed max_atoms.
    // We still allocate M elements per column as
    // this is what the chol update function assumes
    m_lt = (double*) mxMalloc(M*max_atoms*sizeof (double));
    // Number of entries in new line for L cannot exceed N.
    v_b = (double*)mxMalloc(N*sizeof(double));
    v_w = (double*)mxMalloc(N*sizeof(double));
    v_c = (double*)mxMalloc(M*sizeof(double));
    // Giving enough space for temporary vectors
    v_t1 = (double*)mxMalloc(N*sizeof(double));
    v_t2 = (double*)mxMalloc(N*sizeof(double));
    // Keeping max_atoms space for subdictionary. 
    m_subdict = (double*)mxMalloc(max_atoms*M*sizeof(double));
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
        p_alpha = mxCreateSparse(N, S, max_atoms*S, mxREAL);
        m_alpha = mxGetPr(p_alpha);
        ir_alpha = mxGetIr(p_alpha);
        jc_alpha = mxGetJc(p_alpha);
        nz_index = 0;
        jc_alpha[0] = 0;
    }
    omp_profile_init(&profile);

    for(s=0; s<S; ++s){
        // Counter for selected atoms
        int kk = 0;
        // another counter for cholesky update
        int kkk;
        wv_x = m_x + M*s;
        // Initialization
        res_norm_sqr = inner_product(wv_x, wv_x, M);
        //Compute proxy p  = D' * x
        mult_mat_t_vec(1, m_dict, wv_x, v_proxy, M, N);
        omp_profile_toctic(&profile, TIME_DtR);
        // h = p = D' * r
        copy_vec_vec(v_proxy, v_h, N);
        // Iteration counter for selecting bunch of atoms in each iteration.
        k = 0;
        // In each iteration we select up to L atoms
        while (k < K &&  res_norm_sqr > res_norm_bnd_sqr){
            if (verbose > 1){
                mexPrintf("k: %d :: ", k+1);
            }
            omp_profile_tic(&profile);
            // Square correlations and assign indices
            for (i=0; i<N; ++i){
                // Square the correlation
                v_h[i] = SQR(v_h[i]);
                // Assign indices to atoms
                atom_indices[i] = i;
            }
            // Search for L largest atoms
            quickselect_desc(v_h, atom_indices, N, L);
            omp_profile_toctic(&profile, TIME_MaxAbs);
            // This index will be used later
            kkk = kk;
            // Store the indices 
            for (i=0; i < L; ++i){
                new_atom_index = atom_indices[i];
                selected_atoms[kk] = new_atom_index;
                // Copy the new atom to the sub-dictionary
                wv_new_atom = m_dict + new_atom_index*M;
                copy_vec_vec(wv_new_atom, m_subdict+kk*M, M);
                if (verbose > 1){
                    mexPrintf("%d ", new_atom_index+1);
                }
                ++kk;
            }
            omp_profile_toctic(&profile, TIME_DictSubMatrixUpdate);
            for (i=0; i < L; ++i)
            {
                // Cholesky update
                if (kkk == 0){
                    // Simply initialize the L matrix
                    *m_lt = 1;
                }else{
                    wv_new_atom = m_subdict+kkk*M;
                    // Incremental Cholesky decomposition
                    if (chol_update(m_subdict, wv_new_atom, m_lt, 
                        v_b, v_w, M, kkk) != 0){
                        break;
                    }
                }
                ++kkk;
            }
            omp_profile_toctic(&profile, TIME_LCholUpdate);
            // We can increase the iteration count
            ++k;
            // We will now solve the equation L L' alpha_I = p_I
            vec_extract(v_proxy, selected_atoms, v_t1, kk);
            spd_chol_lt_solve(m_lt, v_t1, v_c, M, kk);
            omp_profile_toctic(&profile, TIME_LLtSolve);
            // Compute residual
            // r  = x - D_I c
            mult_mat_vec(-1, m_subdict, v_c, v_r, M, kk);
            sum_vec_vec(1, wv_x, v_r, M);
            omp_profile_toctic(&profile, TIME_RUpdate);
            // Update h = D' r
            mult_mat_t_vec(1, m_dict, v_r, v_h, M, N);
            // Update residual norm squared
            res_norm_sqr = inner_product(v_r, v_r, M);
            omp_profile_toctic(&profile, TIME_DtR);
            if(verbose > 1){
                mexPrintf(" \\| r \\|_2^2 : %.4f.\n", res_norm_sqr);
            }
        }

        // Write the output vector
        if(sparse_output == 0){
            // Write the output vector
            double* wv_alpha =  m_alpha + N*s;
            fill_vec_sparse_vals(v_c, selected_atoms, wv_alpha, N, kk);
        }
        else{
            // Sort the row indices
            quicksort_indices(selected_atoms, v_c, kk);
            // add the non-zero entries for this column
            for(j=0; j <kk; ++j){
                m_alpha[nz_index] = v_c[j];
                ir_alpha[nz_index] = selected_atoms[j];
                ++nz_index;
            }
            // fill in the total number of nonzero entries in the end.
            jc_alpha[s+1] = jc_alpha[s] + kk;
        }
    }
    if(verbose){
        omp_profile_print(&profile);
    }

    // Memory cleanup
    mxFree(selected_atoms);
    mxFree(atom_indices);
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
