#include "spx_lansvd.hpp"
#include "spx_rand.hpp"

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
    m_k(k),
    m_options(options),
    // Arrays
    m_u_arr(0),
    m_v_arr(0),
    // A operator
    m_a_op_fullmat(0),
    // Matrices
    m_u_mat(0),
    m_v_mat(0),
    // Vectors
    m_v_alpha(0),
    m_v_beta(0),
    m_v_p(0),
    // Solver
    mp_solver(0)
{
    if(A == 0){
        throw std::invalid_argument("input operator A hasn't been specified.");
    }
    int M, N;
    // Number of signal space dimension
    M = mxGetM(A);
    // Number of atoms
    N = mxGetN(A);
    int min_mn = std::min(M, N);
    if (k < 0) {
        m_k = std::min(min_mn, 6);
    }
    if (m_k < 1) {
        throw std::invalid_argument("Number of required singular values is 0.");
    }
    n_max_iters = min_mn;
    double eps = mxGetEps();
    m_tolerance = 16 * eps;
    if (options.tolerance > 0) {
        m_tolerance = options.tolerance;
    }
    Operator* a_op = 0;
    if(mxIsNumeric(A) && !mxIsSparse(A)){
        m_a_op_fullmat = new MxFullMat(m_a_input);
        a_op = m_a_op_fullmat;
    }
    if (a_op == 0){
        // We couldn't build the operator
        return;
    }
    // allocate memory for U matrix
    m_u_arr = mxCreateDoubleMatrix(M, m_k, mxREAL);
    m_v_arr = mxCreateDoubleMatrix(N, m_k, mxREAL);
    // Wrappers for U and V
    m_u_mat = new MxFullMat(m_u_arr);
    m_v_mat = new MxFullMat(m_v_arr);

    // Vectors
    m_alpha_space.resize(N);
    m_beta_space.resize(N+1);
    m_p_space.resize(M);

    m_v_alpha = new Vec(m_alpha_space);
    m_v_beta = new Vec(m_beta_space);
    m_v_p = new Vec(m_p_space);
    if(options.p0){
        (*m_v_p) = Vec(options.p0);
    }
    else {
        rand::init_uniform_real(*m_v_p, -0.5, 0.5);
    }

    if (m_options.verbosity > 1){
        m_v_p->print("p0");
    }
    if (options.verbosity > 3) {
        mexPrintf("Constructing LanczosBD solver\n");
    }
    mp_solver = new LanczosBD(*a_op, *m_u_mat, *m_v_mat,
                              *m_v_alpha, *m_v_beta, *m_v_p);
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
    if (m_u_mat) {
        delete m_u_mat;
    }
    if (m_v_mat) {
        delete m_v_mat;
    }
    if (m_u_arr) {
        mxDestroyArray(m_u_arr);
    }
    if (m_v_arr) {
        mxDestroyArray(m_v_arr);
    }
    // Operator
    if (m_a_op_fullmat) {
        delete m_a_op_fullmat;
    }
}

void LanSVD::operator()() {
    double eps = mxGetEps();
    //! Options for the LanczosBD algorithm
    if (m_options.verbosity > 3){
        mexPrintf("Setting up options for LanczosBD solver\n");
    }
    LanczosBDOptions bd_options(eps, m_k);
    if (mp_solver == 0){
        mexErrMsgTxt("The LanczosBD solver hasn't been setup.");
    }
    bd_options.verbosity = m_options.verbosity;
    if (m_options.verbosity > 3){
        mexPrintf("Initiating one round of LanczosBD solver execution.\n");
    }
    int k_done = (*mp_solver)(bd_options, m_k);
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

}

