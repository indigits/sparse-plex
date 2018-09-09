/*************************************************
*
*  GOMP Implementation for multiple measurement vectors
*
*************************************************/


#include <mex.h>
#include <math.h>
#include "omp.h"
#include "omp_profile.h"
#include "spxblas.h"
#include "spxalg.h"
#include "spxla.h"
#include "argcheck.h"

#define MAX_M 4096

mxArray* gomp_mmv_chol(const double m_dict[], 
    const double m_x[],
    mwSize M, 
    mwSize N,
    mwSize S,
    mwSize K, 
    mwSize L, 
    mwSize T, 
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
    double* m_proxy = 0;
    // The inner product of residual with atoms H = D' * R
    double* m_h = 0;
    // Absolute sum of inner products in each column
    double* v_h = 0;
    // The residual
    double* m_r = 0;
    // b = D_I' d_k in the Cholesky decomposition updates
    double* v_b = 0;
    // New vector in the Cholesky decomposition updates
    double* v_w = 0;
    // Result of orthogonal projection LL' c = p_I
    double* m_c = 0;
    // Pointer to new atom
    const double* wv_new_atom;
    // residual norm squared
    double res_norm_sqr = 1;
    // square of upper bound on residual norm
    double res_norm_bnd_sqr = SQR(res_norm_bnd);
    // Expected sparsity of signal
    mwSize sparsity = K;

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

    // Maximum number of columns to be used in representations
    mwSize max_atoms;

    if(verbose > 1){
        mexPrintf("M: %d, N:%d, S: %d, K: %d, L: %d, T: %d, eps: %e, sparse: %d, verbose: %d\n",
         M, N, S, K, L, T, res_norm_bnd, sparse_output, verbose);
    }
    // structure for tracking time spent.
    omp_profile profile;

    // K is now the iteration count.
    // If it is larger than acceptable, we will cut it down here.
    if (K < 0 || K * L > M) {
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


    // h is in R^N. We need to store it separately for each vector in MMV set
    m_h = (double*)mxMalloc(T*N*sizeof(double));
    v_h = (double*)mxMalloc(N*sizeof(double));
    // Residual is in signal space R^M. We need to store it separately for each vector in MMV set
    m_r = (double*)mxMalloc(T*M*sizeof(double));
    // The non-zero approximation coefficients. We need to store it separately for each vector in MMV set
    m_c = (double*)mxMalloc(T*M*sizeof(double));
    // Proxy vector is in R^N. We need to store it separately for each vector in MMV set
    m_proxy = (double*)mxMalloc(T*N*sizeof(double));

    // Keeping max_atoms space for subdictionary. 
    m_subdict = (double*)mxMalloc(max_atoms*M*sizeof(double));

    // Allocation of space for the result vector
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

    if (M > MAX_M){
        error_msg("gomp_mmv", "Too large M.");
        return p_alpha;
    }

    omp_profile_init(&profile);
    //  We process one MMV set in each iteration.
    // Each MMV set contains at most T vectors
    // All except last set contain T vectors
    // Last set may contain less vectors
    // s indicates the index of first vector in the MMV set
    for(s=0; s<S; s+= T){
        // Pointer to current MMV set
        const double *wm_x = m_x + M*s;
        int dummy;
        // Counter for selected atoms
        int kk = 0;
        // Number of atoms in next MMV set
        mwSize tt = T;
        if (S -s < T){
            tt = S - s;
        }
        if (verbose > 1){
            mexPrintf("Processing %d vectors \n", tt);
        }
        // Initialization
        if (res_norm_bnd_sqr > 0){
            // Cool trick to compute Frobenius norm of residual
            res_norm_sqr = inner_product(wm_x, wm_x, M*tt);
        }
        //Compute proxy P  = D' * X for the MMV set
        mult_mat_t_mat(1, m_dict, wm_x, m_proxy, N, tt, M);
        omp_profile_toctic(&profile, TIME_DtR);
        // h = p = D' * r
        copy_vec_vec(m_proxy, m_h, N*tt);
        // Iteration counter for selecting bunch of atoms in each iteration.
        k = 0;
        // In each iteration we select up to L atoms
        while (k < K &&  res_norm_sqr > res_norm_bnd_sqr){
            // Number of atoms added during this cycle.
            int added_atoms = 0;
            if (verbose > 1){
                mexPrintf("k: %d :: ", k+1);
            }
            omp_profile_tic(&profile);
            // Sum of absolute correlations in each row (i.e. for all vectors in MMV set)
            mat_row_asum(m_h, v_h, N, tt);
            // Remove the entries for already selected atoms
            for(i=0; i < kk; ++i){
                v_h[selected_atoms[i]] = 0;
            }
            //Assign atom indices
            for (i=0; i<N; ++i){
                // Assign indices to atoms
                atom_indices[i] = i;
            }
            // Search for L largest atoms
            quickselect_desc(v_h, atom_indices, N, L);
            omp_profile_toctic(&profile, TIME_MaxAbs);
            // Store the indices and update Cholesky decomposition
            for (i=0; i < L; ++i){
                if (v_h[i] < 1e-6*tt){
                    // The contribution of atom is too small to consider
                    continue;
                }
                new_atom_index = atom_indices[i];
                selected_atoms[kk] = new_atom_index;
                // One more atom was added
                ++added_atoms;
                // Copy the new atom to the sub-dictionary
                wv_new_atom = m_dict + new_atom_index*M;
                copy_vec_vec(wv_new_atom, m_subdict+kk*M, M);
                if (verbose > 1){
                    mexPrintf("%d ", new_atom_index+1);
                }
                // Cholesky update
                if (kk == 0){
                    // Simply initialize the L matrix
                    *m_lt = 1;
                }else{
                    wv_new_atom = m_subdict+kk*M;
                    // Incremental Cholesky decomposition
                    if (chol_update(m_subdict, wv_new_atom, m_lt, 
                        v_b, v_w, M, kk) != 0){
                        // We will ignore this atom
                        // as it is linearly dependent on previous atoms
                        continue;
                    }
                }
                ++kk;
            }
            if(0 == added_atoms){
                if (verbose > 1){
                    mexPrintf("No new atoms were added. Stopping.\n");
                    break;
                }
            }
            omp_profile_toctic(&profile, TIME_LCholUpdate);
            // We can increase the iteration count
            ++k;
            // We will now solve the equation L L' alpha_I = p_I
            mat_row_extract(m_proxy, selected_atoms, m_c, N, tt, kk);
            spd_lt_trtrs_multi(m_lt, m_c, M, kk, tt);
            if (verbose > 2){
                print_matrix(m_c, kk, tt, "c");
            }
            omp_profile_toctic(&profile, TIME_LLtSolve);
            // Compute residual
            // r  = x - D_I c
            mult_mat_mat(-1, m_subdict, m_c, m_r, M, tt, kk);
            sum_vec_vec(1, wm_x, m_r, M*tt);
            omp_profile_toctic(&profile, TIME_RUpdate);
            // Update h = D' r
            mult_mat_t_mat(1, m_dict, m_r, m_h, N, tt, M);
            if (res_norm_bnd_sqr > 0){
                // Update residual norm squared
                res_norm_sqr = inner_product(m_r, m_r, M*tt);
                if(verbose > 1){
                    mexPrintf(" \\| r \\|_2^2 : %.4f.\n", res_norm_sqr);
                }
            }else{
                if (verbose > 1){
                    mexPrintf("\n");
                }
            }
            omp_profile_toctic(&profile, TIME_DtR);
        }

        // Write the output vector
        if(sparse_output == 0){
            // Iterate over MMV set
            for (int j=0; j < tt; ++j){
                double* wv_alpha =  m_alpha + N*(s + j);
                double* wv_c = m_c + kk*j;
                // Write the output vector
                fill_vec_sparse_vals(wv_c, selected_atoms, wv_alpha, N, kk);                
            }
        }
        else{
            // First sort the indices
            mwIndex indices1[MAX_M];
            double  indices2[MAX_M];
            for (int j=0; j < kk; ++j){
                indices2[j] = j;
            }
            // Sort the row indices
            quicksort_indices(selected_atoms, indices2, kk);
            for (int j=0; j < kk; ++j){
                indices1[j] = (mwIndex) indices2[j];
            }
            // Iterate over MMV set
            for(int i=0; i < tt; ++i){
                // Coefficients for current vector in MMV set
                double* wv_c = m_c + kk*i;
                // add the non-zero entries for this column
                for(j=0; j <kk; ++j){
                    m_alpha[nz_index] = wv_c[indices1[j]];
                    ir_alpha[nz_index] = selected_atoms[j];
                    ++nz_index;
                }
                // fill in the total number of nonzero entries in the end.
                jc_alpha[s+i+1] = jc_alpha[s+i] + kk;
            }
        }
    }
    if(verbose){
        omp_profile_print(&profile);
    }
    if (sparse_output && verbose > 2){
        mexPrintf("nnz : %d\n", nz_index);
        // print_index_vector(jc_alpha, S, "jc_alpha");
        // print_vector(m_alpha, nz_index, "pr_alpha");
    }
    // Memory cleanup
    mxFree(selected_atoms);
    mxFree(atom_indices);
    mxFree(m_lt);
    mxFree(v_b);
    mxFree(v_w);
    mxFree(m_c);
    mxFree(m_subdict);
    mxFree(m_proxy);
    mxFree(m_h);
    mxFree(v_h);
    mxFree(m_r);

    // Return the result
    return p_alpha;
}
