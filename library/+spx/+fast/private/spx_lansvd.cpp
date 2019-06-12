#include "spx_lansvd.hpp"
#include "spx_svd.hpp"
#include "spx_matarr.hpp"

namespace spx {



LanSVDOptions::LanSVDOptions(double eps, int k):
    delta(-1),
    eta(-1),
    gamma(-1),
    cgs(true),
    elr(false),
    verbosity(0),
    max_iters(-1),
    tolerance(-1),
    p0(0)
{

}


LanSVD::LanSVD(const mxArray* A, int k, const LanSVDOptions& options):
    m_a_input(A),
    m_cols(0),
    m_rows(0),
    m_k(k),
    k_done(0),
    m_options(options),
    // Arrays
    m_u_arr(0),
    m_v_arr(0),
    // A operator
    m_a_op_fullmat(0),
    // Vectors
    m_v_alpha(0),
    m_v_beta(0),
    m_v_p(0),
    // Solver
    mp_solver(0),
    // Random number generator
    rng(0)
{
    if(A == 0){
        throw std::invalid_argument("input operator A hasn't been specified.");
    }
    double eps = mxGetEps();
    m_tolerance = 16 * eps;
    if (options.tolerance > 0) {
        m_tolerance = options.tolerance;
    }
    Operator* a_op = 0;
    if(mxIsNumeric(A) && !mxIsSparse(A)){
        m_a_op_fullmat = new MxFullMat(m_a_input);
        a_op = m_a_op_fullmat;
        m_cols = m_a_op_fullmat->columns();
        m_rows = m_a_op_fullmat->rows();
    }
    if (a_op == 0){
        // We couldn't build the operator
        throw std::invalid_argument("Could not create A operator.");
    }
    int min_mn = std::min(m_cols, m_rows);
    if (k < 0) {
        m_k = std::min(min_mn, 6);
    }
    if (m_k < 1) {
        throw std::invalid_argument("Number of required singular values is 0.");
    }
    m_max_iters = min_mn;
    if (options.max_iters > 0){
        m_max_iters = options.max_iters;
    }

    // allocate initial memory for U matrix
    m_u_arr = mxCreateDoubleMatrix(m_rows, m_k, mxREAL);
    // allocate initial memory for V matrix
    m_v_arr = mxCreateDoubleMatrix(m_cols, m_k, mxREAL);
    // allocate initial memory for S array
    m_s_arr = mxCreateDoubleMatrix(m_k, 1, mxREAL);

    // Vectors
    m_v_alpha = new Vec(m_cols);
    m_v_beta = new Vec(m_cols + 1);
    m_v_p = new Vec(m_rows);
    if(options.p0){
        (*m_v_p) = Vec(options.p0);
    }
    else {
        rng.uniform_real(-0.5, 0.5, *m_v_p);
    }

    if (m_options.verbosity >= 2){
        m_v_p->print("p0", 8);
    }
    if (options.verbosity >= 2) {
        mexPrintf("Constructing LanczosBD solver\n");
    }
    mp_solver = new LanczosBD(*a_op, *m_v_alpha, *m_v_beta, *m_v_p, rng);
}

LanSVD::~LanSVD() {
    if (mp_solver) {
        delete mp_solver;
    }
    /// Vectors
    if (m_v_alpha) {
        delete m_v_alpha;
    }
    if (m_v_beta) {
        delete m_v_beta;
    }
    if (m_v_p) {
        delete m_v_p;
    }
    /// U, V arrays
    if (m_u_arr) {
        mxDestroyArray(m_u_arr);
    }
    if (m_v_arr) {
        mxDestroyArray(m_v_arr);
    }
    if (m_s_arr){
        mxDestroyArray(m_s_arr);
    }
    // Operator
    if (m_a_op_fullmat) {
        delete m_a_op_fullmat;
    }
}

void LanSVD::operator()() {
    double eps = mxGetEps();
    if (mp_solver == 0){
        mexErrMsgTxt("The LanczosBD solver hasn't been setup.");
    }
    k_done = 0;
    /// Number of singular values which have converged
    int n_converged = 0;
    bool bad_alloc = false;
    // Initial number of Lanczos vectors to compute
    int k_req = std::min(m_k + std::max(8, m_k) + 1, m_max_iters);
    double tolerance = m_tolerance;
    int verbosity = m_options.verbosity;
    // space for conversion of k x k+1 bd matrix to k x k bd matrix
    d_vector alpha2_space(m_cols+1);
    d_vector beta2_space(m_cols+1);
    // We cannot go beyond max iterations
    for (int iter=1; n_converged < m_k ; ++iter){
        //! Options for the LanczosBD algorithm
        if (verbosity >= 1){
            mexPrintf("Setting up options for LanczosBD solver\n");
            mexPrintf("\nStarting LanSVD iter [%d]: k_req=%d, k_done: %d\n\n", iter, k_req, k_done);
        }
        /// Make sure that U and V arrays have sufficient space
        if (false == resize_fullmat_columns(m_u_arr, k_req)){
            bad_alloc = true;
            break;
        }
        if (false == resize_fullmat_columns(m_v_arr, k_req)){
            bad_alloc = true;
            break;
        }
        /// Run the Lanczos BD solver
        LanczosBDOptions bd_options(eps, k_req);
        bd_options.verbosity = verbosity;
        Matrix U(m_u_arr);
        Matrix V(m_v_arr);
        k_done = (*mp_solver)(U, V, k_req, k_done, bd_options);
        // alpha and beta have been updated

        /// TODO provide support for handling the issue of degenerate cases.

        // Norm of the residual
        double p_norm = (*m_v_beta)[k_done];
        // Prepare for computing the singular values of bidiagonal matrix
        if(mxGetM(m_s_arr) < k_done){
            // We need to allocate more space
            double* pS = mxGetPr(m_s_arr);
            pS = (double*) mxRealloc(pS, k_done*sizeof(double));
            if (pS != 0){
                // Reallocation happened successfully
                mxSetM(m_s_arr, k_done);
                mxSetPr(m_s_arr, pS);
            } else {
                bad_alloc = true;
                break;
            }
        }
        ////// Conversion of the lower k+1, k bidiagonal matrix to k x k upper bidiagonal matrix
        // source values
        Vec alpha(m_v_alpha->head(), k_done);
        Vec beta(m_v_beta->head() + 1, k_done);
        // destination
        Vec alpha2(&(alpha2_space[0]), k_done);
        Vec beta2(&(beta2_space[0]), k_done);
        // copy values
        alpha2 = alpha;
        beta2 = beta;
        // perform the conversion
        double cs = 0;
        double sn = 0;
        convert_bd_kp1xk_to_kxk(alpha2, beta2, cs, sn);
        Vec beta3(beta2.head(), k_done-1);
        /////// Compute the singular values of the bidiagonal matrix
        Vec S(m_s_arr);
        // We want to pickup the last row of the U matrix
        Matrix U_bottom(1, k_done);
        U_bottom(0, k_done-1) = cs;
        // Computation of SVD of the bidiagonal matrix
        svd_bd_square(alpha2, beta3, S, &U_bottom, 0);
        // Value of norm of A
        double a_norm = S[0];
        // Save this value with the solver for future use.
        mp_solver->set_anorm(a_norm);
        // Error bounds
        Vec bnd(U_bottom.head(), k_done);
        // Set simple error bounds
        bnd.abs().scale(p_norm);

        // TODO: Examine gap structure and refine error bounds

        // Check convergence criterion
        n_converged = 0;
        int i=0;
        while (i < k_done){
            if (bnd[i] <= tolerance * S[i]){
                n_converged = n_converged + 1;
                i += 1;
            } else {
                break;
            }
        }
        if (verbosity >= 1){
            mexPrintf("Finishing LanSVD iter [%d]: k_req=%d, k_done: %d\n", iter, k_req, k_done);
            mexPrintf("Converged singular values: %d, pnorm: %e\n", n_converged, p_norm);
            S.print("Singular values");
        }
        if (k_done >= m_max_iters){
            break;
        }
        if (n_converged >= m_k){
            // Sufficient number of singular values have converged.
            break;
        }
        // Update number of Lanczos vectors to compute
        if (n_converged > 0){
            // increase k by approx. half the average number of steps pr. converged
            int kk = 0.5 * (k_req - n_converged)*k_req / (n_converged + 1);
            k_req = k_req + std::min(100, (int) std::max(2, kk));
        } else {
            // As long a very few singular values have converged, increase k rapidly.
            k_req = (int) std::max((int)(1.5*k_req), k_req + 10);
        }
        // We cannot request more iterations than the rank.
        k_req = std::min(k_req, m_max_iters);
    }
    if (verbosity >= 1){
        mexPrintf("Final: k_done: %d\n", k_done);
    }
    if (verbosity >= 1){
        m_v_alpha->print("alpha", k_done);
        m_v_beta->print("beta", k_done + 1);
        mexPrintf("nreorthu: %d, nreorthv: %d, npu: %d, npv: %d, ierr: %d\n",
            mp_solver->m_nreorthu, 
            mp_solver->m_nreorthv,
            mp_solver->m_npu,
            mp_solver->m_npv,
            mp_solver->ierr);
    }
    if (bad_alloc){
        // Problem in memory allocation.
        throw std::bad_alloc();
    }
}

mxArray* LanSVD::transfer_u() {
    mxArray* result = m_u_arr;
    m_u_arr = 0;
    return result;
}

mxArray* LanSVD::transfer_v() {
    mxArray* result = m_v_arr;
    m_v_arr = 0;
    return result;
}

mxArray* LanSVD::transfer_s(){
    mxArray* result = m_s_arr;
    m_s_arr = 0;
    return result;    
}

mxArray* LanSVD::transfer_alpha() {
    if(m_v_alpha == 0){
        return 0;
    }
    return d_vec_to_mx_array(*m_v_alpha, k_done);
}

mxArray* LanSVD::transfer_beta(){
    if (m_v_beta == 0){
        return 0;
    }
    return d_vec_to_mx_array(*m_v_beta, k_done+1);
}

mxArray* LanSVD::transfer_p(){
    return d_vec_to_mx_array(*m_v_p);
}

mxArray* LanSVD::transfer_details(){
    std::vector<std::string> fields;
    fields.push_back("nreorthu");
    fields.push_back("nreorthv");
    fields.push_back("npu");
    fields.push_back("npv");
    fields.push_back("nrenewv");
    fields.push_back("ierr");
    mxArray* result = create_struct(fields);
    set_struct_int_field(result, 0, mp_solver->m_nreorthu);
    set_struct_int_field(result, 1, mp_solver->m_nreorthv);
    set_struct_int_field(result, 2, mp_solver->m_npu);
    set_struct_int_field(result, 3, mp_solver->m_npv);
    set_struct_int_field(result, 4, mp_solver->m_nrenewv);
    set_struct_int_field(result, 5, mp_solver->ierr);
    return result;
}

}

