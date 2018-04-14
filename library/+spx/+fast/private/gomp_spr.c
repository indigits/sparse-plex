/*************************************************
*
*  GOMP Based Computation of Subspace Preserving 
*  Representations
*
*************************************************/

#include <mex.h>
#include <math.h>
#include "omp.h"
#include "spxblas.h"
#include "spxalg.h"
#include "omp_profile.h"

mxArray* gomp_spr(const double *m_dataset, // Dataset
    mwSize M, // Data dimension
    mwSize S, // Number of signals
    mwSize K, // Sparsity level
    mwSize L, 
    double res_norm_bnd, // Residual norm bound
    int sparse_output, // Whether output is sparse matrix
    int verbose // Verbose output (profiling data etc.)
    ){

    // List of indices of selected atoms
    mwIndex *selected_atoms = 0; 
    // Atom indices needed during selection
    mwIndex* atom_indices = 0;   
    // Storage for the Cholesky decomposition of D_I' D_I
    double *m_lt = 0;
    // number or rows in lt
    mwSize lrows = 0;
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
    double* v_z = 0;
    // Some temporary vectors
    double *v_t1 = 0, *v_t2 = 0;
    // Pointer to new atom
    const double* wv_new_atom;
    // residual norm squared
    double res_norm_sqr;
    // square of upper bound on residual norm
    double res_norm_bnd_sqr = SQR(res_norm_bnd);
    // Pointer to current data vector
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
    // maximum number of rows in L
    lrows = M;
    // Memory allocations
    // Number of selected atoms cannot exceed M
    selected_atoms = (mwIndex*) mxMalloc(M*sizeof(mwIndex));
    // Total number of atoms is S
    atom_indices = (mwIndex*) mxMalloc(S*sizeof(mwIndex));
    // Number of rows and columns in L cannot exceed max_atoms.
    // We still allocate M elements per column as
    // this is what the chol update function assumes
    m_lt = (double*) mxMalloc(M*max_atoms*sizeof (double));
    // Number of entries in new line for L cannot exceed S.
    v_b = (double*)mxMalloc(S*sizeof(double));
    v_w = (double*)mxMalloc(S*sizeof(double));
    v_z = (double*)mxMalloc(M*sizeof(double));
    // Giving enough space for temporary vectors
    v_t1 = (double*)mxMalloc(S*sizeof(double));
    v_t2 = (double*)mxMalloc(S*sizeof(double));
    // Keeping max_atoms space for subdictionary. 
    m_subdict = (double*)mxMalloc(max_atoms*M*sizeof(double));
    // Proxy vector is in R^S
    v_proxy = (double*)mxMalloc(S*sizeof(double));
    // h is in R^S.
    v_h = (double*)mxMalloc(S*sizeof(double));
    // Residual is in signal space R^M.
    v_r = (double*)mxMalloc(M*sizeof(double));

    if (sparse_output == 0){
        p_alpha = mxCreateDoubleMatrix(S, S, mxREAL);
        m_alpha =  mxGetPr(p_alpha);
        ir_alpha = 0;
        jc_alpha = 0;
    }else{
        p_alpha = mxCreateSparse(S, S, max_atoms*S, mxREAL);
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
        // Current data point
        wv_x = m_dataset + M*s;
        // Initialization
        res_norm_sqr = 1;
        //Compute proxy p  = D' * x
        mult_mat_t_vec(1, m_dataset, wv_x, v_proxy, M, S);
        omp_profile_toctic(&profile, TIME_DtR);
        // h = p = D' * r
        copy_vec_vec(v_proxy, v_h, S);
        // Number of atoms selected so far.
        k = 0;
        // Iterate for each atom
        while (k < K &&  res_norm_sqr > res_norm_bnd_sqr){
            if (verbose > 1){
                mexPrintf("k: %d :: ", k+1);
            }
            omp_profile_tic(&profile);
            // ignore s-th atom from consideration
            v_h[s] = 0;
            // Square correlations and assign indices
            for (i=0; i<S; ++i){
                // Square the correlation
                v_h[i] = SQR(v_h[i]);
                // Assign indices to atoms
                atom_indices[i] = i;
            }
            // Search for L largest atoms
            quickselect_desc(v_h, atom_indices, S, L);
            omp_profile_toctic(&profile, TIME_MaxAbs);
            // Store the indices 
            for (i=0; i < L; ++i){
                new_atom_index = atom_indices[i];
                selected_atoms[kk] = new_atom_index;
                // Copy the new atom to the sub-dictionary
                wv_new_atom = m_dataset + new_atom_index*M;
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
            omp_profile_toctic(&profile, TIME_LCholUpdate);
            // We can increase the iteration count
            ++k;
            // We will now solve the equation L L' alpha_I = p_I
            vec_extract(v_proxy, selected_atoms, v_t1, kk);
            spd_chol_lt_solve2(m_lt, v_t1, v_z, v_t2, lrows, kk);
            omp_profile_toctic(&profile, TIME_LLtSolve);
            // Compute residual
            // r  = x - D_I c
            mult_mat_vec(-1, m_subdict, v_z, v_r, M, kk);
            sum_vec_vec(1, wv_x, v_r, M);
            omp_profile_toctic(&profile, TIME_RUpdate);
            // Update h = D' r
            mult_mat_t_vec(1, m_dataset, v_r, v_h, M, S);
            if (res_norm_bnd_sqr > 0){
                // Update residual norm squared
                res_norm_sqr = inner_product(v_r, v_r, M);
            }else{
                // We don't need to track the norm of residual
                res_norm_sqr = 1;                
            }
            omp_profile_toctic(&profile, TIME_DtR);
            if(verbose > 1){
                mexPrintf(" \\| r \\|_2^2 : %.4f.\n", res_norm_sqr);
            }
        }

        // Write the output vector
        if(sparse_output == 0){
            // Write the output vector
            double* wv_alpha =  m_alpha + S*s;
            fill_vec_sparse_vals(v_z, selected_atoms, wv_alpha, S, kk);
        }
        else{
            // Sort the row indices
            quicksort_indices(selected_atoms, v_z, kk);
            // add the non-zero entries for this column
            for(j=0; j <kk; ++j){
                m_alpha[nz_index] = v_z[j];
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
