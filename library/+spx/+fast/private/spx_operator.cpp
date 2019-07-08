#include <stdio.h>
#include <string.h>
#include <stdexcept>
#include "spx_operator.hpp"
#include "blas.h"
#include "spxblas.h"

#if !defined(_WIN32)

#define dswap dswap_
#define dscal dscal_
#define dgemm dgemm_
#endif

namespace spx {

Operator::Operator() {
}

Operator::~Operator() {

}

Operator* Operator::create(const mxArray* A) {
    Operator* result = 0;
    if(mxIsNumeric(A) && !mxIsSparse(A)){
        result = new MxFullMat(A);
    }
    else if (mxIsNumeric(A) && mxIsSparse(A)){
        result = new MxSparseMat(A);
    }
    else if (is_aat_func_op(A)){
        result = new AAtFuncOp(A);
    }
    if (0 == result){
        throw std::invalid_argument("A is none of: full matrix, sparse matrix, pair of function handles.");
    }
    return result;
}


/************************************************
 *  Matrix Operator Implementation
 ************************************************/

Matrix::Matrix(mwSize rows, mwSize cols):
    m_pMatrix((double*)mxMalloc(rows * cols * sizeof(double))),
    m_rows(rows),
    m_cols(cols),
    m_bOwned(true)
{
}

Matrix::Matrix(const mxArray* pMat):
    m_pMatrix(mxGetPr(pMat)),
    m_rows(mxGetM(pMat)),
    m_cols(mxGetN(pMat)),
    m_bOwned(false){

}

Matrix::Matrix(double *pMatrix, mwSize rows, mwSize cols, bool bOwned):
    m_pMatrix(pMatrix),
    m_rows(rows),
    m_cols(cols),
    m_bOwned(bOwned)
{
}

Matrix::Matrix(Matrix& source, mwSize start_col, mwSize num_cols):
    m_pMatrix(source.m_pMatrix + source.rows() * start_col),
    m_rows(source.rows()),
    m_cols(num_cols),
    m_bOwned(false) {

}


Matrix::~Matrix() {
    if (m_bOwned) {
        // release the memory
        mxFree(m_pMatrix);
        m_pMatrix = 0;
    }
}

mwSize Matrix::rows() const {
    return m_rows;
}

mwSize Matrix::columns() const {
    return m_cols;
}


Matrix Matrix::columns_ref(mwIndex start, mwIndex end) const {
    if (start < 0){
        throw std::invalid_argument("start cannot be negative.");
    }
    if (end <= start){
        throw std::invalid_argument("end cannot be less than or equal to start.");
    }
    if (end > m_cols){
        throw std::invalid_argument("end cannot go beyond last column of matrix");
    }
    double* beg = m_pMatrix + start * m_rows;
    mwIndex ncols = end - start;
    return Matrix(beg, m_rows, ncols, false);
}


void Matrix::column(mwIndex index, double b[]) const {
    double* a = m_pMatrix + index * m_rows;
    mwSignedIndex  inc = 1;
    mwSignedIndex mm = m_rows;
    dcopy(&mm, a, &inc, b, &inc);
}

void Matrix::extract_columns( const mwIndex indices[], mwSize k,
                              double B[]) const {
    mat_col_extract(m_pMatrix, indices, B, m_rows, k);
}

void Matrix::extract_columns(const index_vector& indices, Matrix& output) const {
    double* B = output.m_pMatrix;
    const mwIndex* indices2 = &indices[0];
    mwSize k = indices.size();
    mat_col_extract(m_pMatrix, indices2, B, m_rows, k);
}

void Matrix::extract_rows( const mwIndex indices[], mwSize k, double B[]) const {
    mat_row_extract(m_pMatrix, indices, B, m_rows, m_cols, k);
}

void Matrix::mult_vec(const double x[], double y[]) const {
    mult_mat_vec(1, m_pMatrix, x, y, m_rows, m_cols);
}

// y = A * x
void Matrix::mult_vec(const Vec& x, Vec& y) const{
    if (m_cols != x.length()) {
        throw std::invalid_argument("x doesn't have appropriate size.");
    }
    if (m_rows != y.length()) {
        throw std::invalid_argument("y doesn't have appropriate size.");
    }
    mwSignedIndex  incx = x.inc();
    mwSignedIndex  incy = y.inc();
    char trans = 'N';
    double beta = 0;
    mwSignedIndex  mm = m_rows;
    mwSignedIndex  nn = m_cols;
    double alpha = 1;
    double* A = m_pMatrix;
    // y := alpha*A*x + beta*y
    dgemv(&trans, &mm, &nn, &alpha, A, &mm, x.head(), &incx, 
        &beta, y.head(), &incy);
}

// y = A' * x
void Matrix::mult_t_vec(const double x[], double y[]) const {
    mult_mat_t_vec(1, m_pMatrix, x, y, m_rows, m_cols);
}

void Matrix::mult_t_vec(const Vec& x, Vec& y) const {
    if (m_rows != x.length()) {
        throw std::invalid_argument("x doesn't have appropriate size.");
    }
    if (m_cols != y.length()) {
        throw std::invalid_argument("y doesn't have appropriate size.");
    }
    mwSignedIndex  incx = x.inc();
    mwSignedIndex  incy = y.inc();
    char trans = 'T';
    double beta = 0;
    mwSignedIndex  mm = m_rows;
    mwSignedIndex  nn = m_cols;
    double alpha = 1;
    double* A = m_pMatrix;
    dgemv(&trans, &mm, &nn, &alpha, A, &mm, x.head(), &incx, 
        &beta, y.head(), &incy);

}

void Matrix::mult_t_vec(const index_vector& indices, const Vec& x, Vec& y) const{
    if (m_rows != x.length()) {
        throw std::invalid_argument("x doesn't have appropriate size.");
    }
    if (indices.size() != y.length()) {
        throw std::invalid_argument("y doesn't have appropriate size.");
    }
    ::mult_submat_t_vec(1, m_pMatrix, &(indices[0]), 
        x.head(), y.head(), m_rows, indices.size());
}



void Matrix::mult_vec(const index_vector& indices, const Vec& x, Vec& y) const{
    if (x.length() != indices.size() ){
        throw std::length_error("Dimension of x is not same as number of columns.");
    }
    if (y.length() != m_rows ){
        throw std::length_error("Dimension of y is not same as number of rows");
    }
    const mwIndex *pindices = &(indices[0]);
    const double *px = x.head();
    double *py = y.head();
    int k = indices.size();
    ::mult_submat_vec(1, m_pMatrix, pindices, px, py, m_rows, k);
}

void Matrix::mult_vec( const mwIndex indices[], mwSize k, const double x[], double y[]) const {
    ::mult_submat_vec(1, m_pMatrix, indices, x, y, m_rows, k);
}

void Matrix::add_column_to_vec(double coeff, mwIndex index, double x[]) const {
    double* a = m_pMatrix + index * m_rows;
    sum_vec_vec(coeff, a, x, m_rows);
}

bool Matrix::copy_matrix_to(Matrix& dst) const {
    //! must be same size
    if (m_rows != dst.rows()) {
        return false;
    }
    if (m_cols != dst.columns()) {
        return false;
    }
    mwSize n = m_rows * m_cols;
    double* p_src = m_pMatrix;
    double* p_dst = dst.m_pMatrix;
    copy_vec_vec(p_src, p_dst, n);
    return true;
}

/************************************************
 *  Matrix Manipulation
 ************************************************/
std::tuple<double, mwIndex> Matrix::col_max(mwIndex col) const {
    // Pointer to the beginning of column
    const double* x = m_pMatrix + col * m_rows;
    mwIndex max_index = 0, k;
    double cur_value, max_value = *x;
    mwSize n = m_rows;
    for (k = 1; k < n; ++k) {
        cur_value = x[k];
        if (cur_value > max_value) {
            max_value = cur_value;
            max_index = k;
        }
    }
    return std::tuple<double, mwIndex>(max_value, max_index);
}
std::tuple<double, mwIndex> Matrix::col_min(mwIndex col) const {
    // Pointer to the beginning of column
    const double* x = m_pMatrix + col * m_rows;
    mwIndex min_index = 0, k;
    double cur_value, min_value = *x;
    mwSize n = m_rows;
    for (k = 1; k < n; ++k) {
        cur_value = x[k];
        if (cur_value < min_value) {
            min_value = cur_value;
            min_index = k;
        }
    }
    return std::tuple<double, mwIndex>(min_value, min_index);
}
std::tuple<double, mwIndex> Matrix::row_max(mwIndex row) const {
    // Pointer to the beginning of row
    const double* x = m_pMatrix + row;
    mwIndex max_index = 0, k;
    double cur_value, max_value = *x;
    mwSize n = m_cols;
    for (k = 1; k < n; ++k) {
        x += m_rows;
        cur_value = *x;
        if (cur_value > max_value) {
            max_value = cur_value;
            max_index = k;
        }
    }
    return std::tuple<double, mwIndex>(max_value, max_index);
}
std::tuple<double, mwIndex> Matrix::row_min(mwIndex row) const {
    // Pointer to the beginning of row
    const double* x = m_pMatrix + row;
    mwIndex min_index = 0, k;
    double cur_value, min_value = *x;
    mwSize n = m_cols;
    for (k = 1; k < n; ++k) {
        x += m_rows;
        cur_value = *x;
        if (cur_value < min_value) {
            min_value = cur_value;
            min_index = k;
        }
    }
    return std::tuple<double, mwIndex>(min_value, min_index);
}

void Matrix::add_to_col(mwIndex col, const double &value) {
    double* x = m_pMatrix + col * m_rows;
    mwSize n = m_rows;
    for (mwIndex k = 0; k < n; ++k) {
        x[k] += value;
    }
}


void Matrix::add_to_row(mwIndex row, const double &value) {
    double* x = m_pMatrix + row;
    mwSize n = m_cols;
    for (mwIndex k = 0; k < n; ++k) {
        *x += value;
        x += m_rows;
    }
}

void Matrix::set_column(mwIndex col, const Vec& input, double alpha) {
    if (col >= m_cols){
        throw std::length_error("Column number beyond range.");
    }
    if (m_rows != input.length()) {
        throw std::length_error("Number of rows mismatch");
    }
    double* x = m_pMatrix + col * m_rows;
    mwSize n = m_rows;
    const double* y = input.head();
    mwIndex inc = input.inc();
    if (alpha == 1) {
        for (mwIndex k = 0; k < n; ++k) {
            *x = *y;
            ++x;
            y += inc;
        }
    } else {
        for (mwIndex k = 0; k < n; ++k) {
            *x = alpha * (*y);
            ++x;
            y += inc;
        }
    }
}


void Matrix::set(double value) {
    int n = m_rows * m_cols;
    double* x = m_pMatrix;
    for (int i=0; i < n; ++i) {
        *x = value;
        ++x;
    }
}
void Matrix::set_diag(double value) {
    int n = std::min(m_rows, m_cols);
    for (int i=0; i < n; ++i) {
        (*this)(i, i) = value;
    }
}
void Matrix::set_diag(const Vec& input) {
    int n = std::min(m_rows, m_cols);
    if (input.length() < n) {
        throw std::length_error("Input vector has insufficient data.");
    }
    for (int i=0; i < n; ++i) {
        (*this)(i, i) = input[i];
    }
}


void Matrix::subtract_col_mins_from_cols() {
    mwSize n = m_cols;
    for (mwIndex c = 0; c < n; ++c) {
        auto min_val = col_min(c);
        add_to_col(c, -std::get<0>(min_val));
    }
}

void Matrix::subtract_row_mins_from_rows() {
    mwSize n = m_rows;
    for (mwIndex r = 0; r < n; ++r) {
        auto min_val = row_min(r);
        add_to_row(r, -std::get<0>(min_val));
    }
}

void Matrix::find_value(const double &value, Matrix& result) const {
    if (m_rows != result.rows()) {
        throw std::length_error("Number of rows mismatch");
    }
    if (m_cols != result.columns()) {
        throw std::length_error("Number of columns mismatch");
    }
    mwSize n  = m_rows * m_cols;
    double* p_src = m_pMatrix;
    double* p_dst = result.m_pMatrix;
    for (mwIndex i = 0; i < n; ++i) {
        *p_dst = *p_src == value;
        ++p_src;
        ++p_dst;
    }
}

void Matrix::gram(Matrix& output) const {
    if (output.rows() != output.columns()) {
        throw std::logic_error("Gram matrix must be symmetric");
    }
    if (output.columns() != columns()) {
        throw std::logic_error("Size of gram matrix must be equal to the number of columns in source matrix");
    }
    double* src = m_pMatrix;
    int M = rows();
    int N = columns();
    /* 
    It is funny to note that GEMM is much faster than the inner product
    approach.
    */
#if 0
    for (int i=0; i < N; ++i){
        double* vi = src + i*M;
        for (int j=i; j < N; ++j){
            double* vj = src + j*M;
            double result = inner_product(vi, vj, M);
            // double result = vi[0] * vj[0];
            // for (int k=1; k < M; ++k){
            //     result += vi[k] * vj[k];
            // }
            output(i, j) = result;
            if (j != i){
                output(j, i) = result;
            }
        }
    }
#else
    mult_mat_t_mat(1, src, src, output.m_pMatrix, N, N, M);
#endif
}

void Matrix::frame(Matrix& output) const{
    if (output.rows() != output.columns()) {
        throw std::logic_error("Frame matrix must be symmetric");
    }
    if (output.rows() != rows()) {
        throw std::logic_error("Size of frame matrix must be equal to the number of rows in source matrix");
    }
    double* src = m_pMatrix;
    int M = rows();
    int N = columns();
    char atrans = 'N';
    char btrans = 'T';
    double alpha = 1;
    double beta = 0;
    double* C = output.m_pMatrix;
    // Output is M x M,  Product is ( M x N )  x (N x M)
    // m = M, n = M, k = N
    mwSignedIndex  mm = rows();
    mwSignedIndex  nn = rows();
    mwSignedIndex  kk = columns();
    dgemm(&atrans, &btrans, 
        &mm, &nn, &kk, 
        &alpha, 
        src, &mm, 
        src, &mm, 
        &beta,
        C, &mm);
}


void Matrix::swap_columns(mwIndex i, mwIndex j){
    if (i >= m_cols || j >= m_cols){
        throw std::length_error("Column number beyond range.");
    }
    ptrdiff_t n = m_rows;
    mwSignedIndex inc = 1;
    double* x = m_pMatrix + i*m_rows;
    double* y = m_pMatrix + j*m_rows;
    dswap(&n, x, &inc, y, &inc);
}

void Matrix::swap_rows(mwIndex i, mwIndex j){
    if (i >= m_rows || j >= m_rows){
        throw std::length_error("Column number beyond range.");
    }
    ptrdiff_t n = m_cols;
    mwSignedIndex inc = m_rows;
    double* x = m_pMatrix + i;
    double* y = m_pMatrix + j;
    dswap(&n, x, &inc, y, &inc);
}

void Matrix::scale_column(mwIndex i, double value){
    ptrdiff_t n = m_rows;
    mwSignedIndex inc = 1;
    double* x = m_pMatrix + i*m_rows;
    dscal(&n, &value, x, &inc);    
}

void Matrix::scale_row(mwIndex i, double value){
    ptrdiff_t n = m_cols;
    mwSignedIndex inc = m_rows;
    double* x = m_pMatrix + i;
    dscal(&n, &value, x, &inc);    
}


/************************************************
 *  Matrix Printing
 ************************************************/

void Matrix::print_matrix(const char* name) const {
    ::print_matrix(m_pMatrix, m_rows, m_cols, name);
}

void Matrix::print_int_matrix(const char* name) const {
    int i, j;
    if (name[0]) {
        mexPrintf("\n%s = \n\n", name);
    }
    mwSize m = m_rows;
    mwSize n = m_cols;

    if (n * m == 0) {
        mexPrintf("   Empty matrix: %d-by-%d\n\n", n, m);
        return;
    }
    double* A = m_pMatrix;
    for (i = 0; i < n; ++i) {
        for (j = 0; j < m; ++j)
            mexPrintf("   %d", (int)A[j * n + i]);
        mexPrintf("\n");
    }
    mexPrintf("\n");
}


/************************************************
 *  MxFullMat Operator Implementation
 ************************************************/

MxFullMat::MxFullMat(const mxArray *pMatrix):
    m_pMatrix(pMatrix),
    m_impl(mxGetPr(pMatrix), mxGetM(pMatrix), mxGetN(pMatrix), false)
{
    if (mxGetNumberOfDimensions(pMatrix) != 2){
        throw std::invalid_argument("Must be a two dimensional matrix.");
    }
    if (!mxIsNumeric(pMatrix)){
        throw std::invalid_argument("Must be a numerical matrix.");
    }
    if(!mxIsDouble(pMatrix)){
        throw std::invalid_argument("Must be a double matrix.");
    }
    if(mxIsComplex(pMatrix)){
       throw std::invalid_argument("Must be a real matrix."); 
    }
    if (mxIsSparse(pMatrix)){
        throw std::invalid_argument("Must be a full matrix.");
    }
}

MxFullMat::~MxFullMat() {
}

mwSize MxFullMat::rows() const {
    return m_impl.rows();
}

mwSize MxFullMat::columns() const {
    return m_impl.columns();
}


void MxFullMat::column(mwIndex index, double b[]) const {
    m_impl.column(index, b);
}

void MxFullMat::extract_columns( const mwIndex indices[], mwSize k,
                               double B[]) const {
    m_impl.extract_columns(indices, k, B);
}

void MxFullMat::extract_columns(const index_vector& indices, Matrix& output) const {
    m_impl.extract_columns(indices, output);
}


void MxFullMat::extract_rows( const mwIndex indices[], mwSize k, double B[]) const {
    m_impl.extract_rows(indices, k, B);
}

void MxFullMat::mult_vec(const double x[], double y[]) const {
    m_impl.mult_vec(x, y);
}

void MxFullMat::mult_vec(const Vec& x, Vec& y) const {
    m_impl.mult_vec(x, y);
}

void MxFullMat::mult_t_vec(const double x[], double y[]) const {
    m_impl.mult_t_vec(x, y);
}

void MxFullMat::mult_t_vec(const Vec& x, Vec& y) const {
    m_impl.mult_t_vec(x, y);
}

void MxFullMat::mult_vec( const mwIndex indices[], mwSize k, const double x[], double y[]) const {
    m_impl.mult_vec(indices, k, x, y);
}

void MxFullMat::add_column_to_vec(double coeff, mwIndex index, double x[]) const {
    m_impl.add_column_to_vec(coeff, index, x);
}

bool MxFullMat::copy_matrix_to(Matrix& dst) const {
    return m_impl.copy_matrix_to(dst);
}




/************************************************
 *  MxSparseMat Operator Implementation
 ************************************************/

/*
    - nzmax is the space allocated for non-zero entries
    - nnz is the total number of non-zero entries
    - Let us assume that the sparse matrix A is of size m x n.
    - Assume that the arrays pr, ir and jc have been extracted from it.
    - This discussion follows 0 based indexing
    - non-zero elements are stored in column major order
    - pr  is the array of values
    - ir is the array of row indices  (i-th row)
    - jc is the array of column indices (j-th column)
    - For each non-zero value, its row number and value are stored in ir and pr arrays
    - The index of first non-zero entry for j-th column in pr array is stored at jc[j]
    - jc[j+1] -1 is the index of the last non-zero entry in the j-th  column
    - jc[j] is the total number of non-zero entries in all columns before j.
    - jc[n] stores the total number of non-zero entries [i.e. nnz]
    - The number of rows m is irrelevant for the storage of non-zero entries
if nnz < nzmax, it is possible to store more non-zero entries without any reallocation
*/


MxSparseMat::MxSparseMat(const mxArray *pMatrix):
    m_pMatrix(pMatrix)
{
    if (mxGetNumberOfDimensions(pMatrix) != 2){
        throw std::invalid_argument("Must be a two dimensional sparse matrix.");
    }
    if (!mxIsNumeric(pMatrix)){
        throw std::invalid_argument("Must be a numerical matrix.");
    }
    if(!mxIsDouble(pMatrix)){
        throw std::invalid_argument("Must be a double matrix.");
    }
    if(mxIsComplex(pMatrix)){
       throw std::invalid_argument("Must be a real matrix."); 
    }
    if (!mxIsSparse(pMatrix)){
        throw std::invalid_argument("Must be a sparse matrix.");
    }
    M = mxGetM(pMatrix);
    N = mxGetN(pMatrix);
    m_pr = mxGetPr(pMatrix);
    m_ir = mxGetIr(pMatrix);
    m_jc = mxGetJc(pMatrix);
}

MxSparseMat::~MxSparseMat() {
}

mwSize MxSparseMat::rows() const {
    return M;
}

mwSize MxSparseMat::columns() const {
    return N;
}


void MxSparseMat::column(mwIndex c, double b[]) const {
    if (c >= N) {
        throw std::invalid_argument("index out of range.");
    }
    double* pr = m_pr;
    mwIndex* ir = m_ir;
    mwIndex* jc = m_jc;
    // Move the pointer to the beginning of the column
    pr += jc[c];
    ir += jc[c];
    // Zero initialize the output
    for(int r=0; r < M; ++r){
        b[r] = 0;
    }
    // Number of row elements for this column
    int nrow = jc[c+1] - jc[c];
    while( nrow > 0 ) {
        b[*ir] = *pr;
        ++ir;
        ++pr;
        // Next non-zero element in column
        --nrow;
    }
}

void MxSparseMat::extract_columns( const mwIndex indices[], mwSize k,
                               double B[]) const {
    double* pr = 0;
    mwIndex* ir = 0;
    mwIndex* jc = m_jc;
    for (int i=0; i < k; ++i){
        mwIndex c = indices[i];
        if (c >= N) {
            throw std::invalid_argument("index out of range.");
        }
        // Move the pointer to the beginning of the column
        pr = m_pr + jc[c];
        ir = m_ir + jc[c];
        double *b = B + M * i;
        // Zero initialize the output
        for(int r=0; r < M; ++r){
            b[r] = 0;
        }
        // Number of row elements for this column
        int nrow = jc[c+1] - jc[c];
        while( nrow > 0 ) {
            b[*ir] = *pr;
            ++ir;
            ++pr;
            // Next non-zero element in column
            --nrow;
        }
    }
}

void MxSparseMat::extract_columns(const index_vector& indices, Matrix& output) const {
    if (indices.size() > output.columns()){
        throw std::length_error("Output doesn't have sufficient space");
    }
    if (output.rows() != M){
        throw std::length_error("Output matrix size not compatible.");
    }
    extract_columns(&(indices[0]), indices.size(), output.head());
}


void MxSparseMat::extract_rows( const mwIndex indices[], mwSize k, double B[]) const {
    i_vector mapping(M);
    // Mapping from source row to destination row
    for (int i=0; i < M; ++i){
        mapping[i] = -1;
    }
    // Map the source row to destination row
    for (int i=0; i < k; ++i){
        if (indices[i] >= M){
            throw std::length_error("row index out of range.");
        }
        mapping[indices[i]] = i;
    }
    // Initialize the output
    // memset(B, 0, k*N*sizeof(double));
    double* pr = 0;
    mwIndex* ir = 0;
    mwIndex* jc = m_jc;
    int sz = k*N;
    for (mwIndex c=0; c < N; ++c){
        // Move the pointer to the beginning of the column
        pr = m_pr + jc[c];
        ir = m_ir + jc[c];
        // Number of row elements for this column
        int nrow = jc[c+1] - jc[c];
        while( nrow > 0 ) {
            mwIndex src_r = *ir;
            int dst_r = mapping[src_r];
            if (dst_r >= 0){
                // place it in the output
                mwIndex dst_index = k*c + dst_r;
                if (dst_index >= sz){
                    throw std::length_error("dst index out of range.");
                }
                B[dst_index] = *pr;
            }
            ++ir;
            ++pr;
            // Next non-zero element in column
            --nrow;
        }
    }
}

void MxSparseMat::mult_vec(const double x[], double y[]) const {
    double* pr = m_pr;
    mwIndex* ir = m_ir;
    mwIndex* jc = m_jc;
    // Zero initialize the output
    for(int r=0; r < M; ++r){
        y[r] = 0;
    }
    // Iterate over the columns in the matrix
    for(int c=0; c<N; c++ ) {
        // Number of row elements for this column
        int nrow = jc[c+1] - jc[c];
        while( nrow > 0 ) {
            // row number of this element
            mwIndex r = *ir;
            // value of A[r,c]
            double value = *pr;
            // Accumulate contribution of x[c] for y[r]
            // y[r] += A(r, c) * x[c]
            y[r] += value * x[c];
            ++ir;
            ++pr;
            // Move on to next non-zero element in the column
            --nrow;
        }
    }
}

void MxSparseMat::mult_vec(const Vec& x, Vec& y) const {
    if (x.length() != N){
        throw std::length_error("x must have length equal to number of columns of A.");
    }
    if (y.length() != M){
        throw std::length_error("y must have length equal to the number of rows of A.");
    }
    mult_vec(x.head(), y.head());
}

void MxSparseMat::mult_t_vec(const double x[], double y[]) const {
    double* pr = m_pr;
    mwIndex* ir = m_ir;
    mwIndex* jc = m_jc;
    // Zero initialize the output
    for(int c=0; c < N; ++c){
        y[c] = 0;
    }
    // Iterate over the columns in the matrix
    for(int c=0; c<N; c++ ) {
        // Number of row elements for this column
        int nrow = jc[c+1] - jc[c];
        while( nrow > 0 ) {
            // row number of this element
            mwIndex r = *ir;
            // value of A[r,c]
            double value = *pr;
            // Accumulate contribution of x[r] for y[c]
            // y[c] += A(r, c) * x[r]
            y[c] += value * x[r];
            ++ir;
            ++pr;
            // Move on to next non-zero element in the column
            --nrow;
        }
    }
}

void MxSparseMat::mult_t_vec(const Vec& x, Vec& y) const {
    if (x.length() != M){
        throw std::length_error("x must have length equal to number of rows of A.");
    }
    if (y.length() != N){
        throw std::length_error("y must have length equal to the number of columns of A.");
    }
    mult_t_vec(x.head(), y.head());
}

void MxSparseMat::mult_vec( const mwIndex indices[], mwSize k, const double x[], double y[]) const {
    double* pr = 0;
    mwIndex* ir = 0;
    mwIndex* jc = m_jc;
    // Zero initialize the output
    for(int r=0; r < M; ++r){
        y[r] = 0;
    }
    // Iterate over the indices
    for(int i=0; i<k; i++ ) {
        // Corresponding column number
        mwIndex c = indices[i];
        if (c >= N) {
            throw std::invalid_argument("index out of range.");
        }
        pr = m_pr + jc[c];
        ir = m_ir + jc[c];
        // Number of row elements for this column
        int nrow = jc[c+1] - jc[c];
        while( nrow > 0 ) {
            // row number of this element
            mwIndex r = *ir;
            // value of A[r,c]
            double value = *pr;
            // Accumulate contribution of x[i] for y[r]
            // y[r] += A(r, c) * x[i]
            y[r] += value * x[i];
            ++ir;
            ++pr;
            // Move on to next non-zero element in the column
            --nrow;
        }
    }
}

void MxSparseMat::add_column_to_vec(double coeff, mwIndex c, double x[]) const {
    if (c >= N) {
        throw std::invalid_argument("index out of range.");
    }
    double* pr = m_pr;
    mwIndex* ir = m_ir;
    mwIndex* jc = m_jc;
    // Move the pointer to the beginning of the column
    pr += jc[c];
    ir += jc[c];
    // Number of row elements for this column
    int nrow = jc[c+1] - jc[c];
    while( nrow > 0 ) {
        x[*ir] += coeff * (*pr);
        ++ir;
        ++pr;
        // Next non-zero element in column
        --nrow;
    }
}

bool MxSparseMat::copy_matrix_to(Matrix& dst) const {
    if (M != dst.rows()){
        throw std::invalid_argument("mismatch in number or rows");
    }
    if (N != dst.columns()){
        throw std::invalid_argument("mismatch in number of columns.");
    }
    double* pr = m_pr;
    mwIndex* ir = m_ir;
    mwIndex* jc = m_jc;
    // Initialize with 0 first
    dst.set(0);
    // Iterate over the columns in the matrix
    for(mwIndex c=0; c<N; c++ ) {
        // Number of row elements for this column
        int nrow = jc[c+1] - jc[c];
        while( nrow > 0 ) {
            // row number of this element
            mwIndex r = *ir;
            // value of A[r,c]
            double value = *pr;
            dst(r, c) = value;
            ++ir;
            ++pr;
            // Move on to next non-zero element in the column
            --nrow;
        }
    }
}


mwSize MxSparseMat::nnz() const{
    return m_jc[N];
}

mwSize MxSparseMat::nnz_col(mwIndex c) const {
    if (c >= N){
        return 0;
    }
    return (m_jc[c+1] - m_jc[c]);
}

/************************************************
 *  AAtFuncOp Operator Implementation
 ************************************************/

bool is_aat_func_op(const mxArray *pStruct){
    if(!mxIsStruct(pStruct)){
        return false;
    }
    mxArray* field =  mxGetField(pStruct, 0, "A");
    if (field == 0){
        return false;
    }
    field =  mxGetField(pStruct, 0, "At");
    if (field == 0){
        return false;
    }
    field =  mxGetField(pStruct, 0, "M");
    if (field == 0){
        return false;
    }
    field =  mxGetField(pStruct, 0, "N");
    if (field == 0){
        return false;
    }
    return true;
}


AAtFuncOp::AAtFuncOp(const mxArray *pStruct):
m_pStruct(pStruct),
m_pXArr(0),
m_pYArr(0),
m_x(0),
m_y(0)
{
    if (!mxIsStruct(pStruct)){
        throw std::invalid_argument("Must be a structure.");
    }
    mxArray* a_field = mxGetField(pStruct, 0, "A");
    if(a_field == 0){
        throw std::invalid_argument("A unspecified.");
    }
    if( !mxIsClass( a_field , "function_handle")) {
        throw std::invalid_argument("A must be a function handle.");
    }
    mxArray* at_field = mxGetField(pStruct, 0, "At");
    if(at_field == 0){
        throw std::invalid_argument("At unspecified.");
    }
    if( !mxIsClass(at_field , "function_handle")) {
        throw std::invalid_argument("At must be a function handle.");
    }
    
    mxArray* m_field = mxGetField(pStruct, 0, "M");
    if(m_field == 0){
        throw std::invalid_argument("M unspecified.");
    }
    if (!mxIsDouble(m_field) || mxIsComplex(m_field) 
    || mxGetNumberOfDimensions(m_field)>2
    || mxGetM(m_field)!=1 
    || mxGetN(m_field)!=1) {
        throw std::invalid_argument("M must be a number.");
    }

    
    mxArray* n_field = mxGetField(pStruct, 0, "N");
    if(n_field == 0){
        throw std::invalid_argument("N unspecified.");
    }
    if (!mxIsDouble(n_field) || mxIsComplex(n_field) 
    || mxGetNumberOfDimensions(n_field)>2
    || mxGetM(n_field)!=1 
    || mxGetN(n_field)!=1) {
        throw std::invalid_argument("N must be a number.");
    }
    m_pA = a_field;
    m_pAt = at_field;
    M = (int) mxGetScalar(m_field);
    N = (int) mxGetScalar(n_field);
    m_pXArr = mxCreateDoubleMatrix(N, 1, mxREAL);
    m_x = mxGetPr(m_pXArr);
    m_pYArr = mxCreateDoubleMatrix(M, 1, mxREAL);
    m_y = mxGetPr(m_pYArr);
}

AAtFuncOp::~AAtFuncOp() {
    if (m_pXArr != 0){
        mxDestroyArray(m_pXArr);
    }
    if (m_pYArr != 0){
        mxDestroyArray(m_pYArr);
    }
}

mwSize AAtFuncOp::rows() const {
    return M;
}

mwSize AAtFuncOp::columns() const {
    return N;
}


void AAtFuncOp::column(mwIndex c, double b[]) const {
    if (c >= N) {
        throw std::invalid_argument("index out of range.");
    }
    // Now set the input properly
    for (int i=0; i < N; ++i){
        m_x[i] = 0;
    }
    m_x[c] = 1;

    mxArray* prhs[2];
    prhs[0] = m_pA;
    prhs[1] = m_pXArr;
    mxArray* plhs[1];
    mexCallMATLAB(1,plhs, 2, prhs,"feval");

    // Copy the result back
    mxArray* y_arr = plhs[0];
    double* dy = mxGetPr(y_arr);
    for (int i=0; i < M; ++i){
        b[i] = dy[i];
    }
    // Destroy the returned array
    mxDestroyArray(y_arr);
}

void AAtFuncOp::row(mwIndex r, double b[], mwIndex inc) const {
    if (r >= M) {
        throw std::invalid_argument("index out of range.");
    }
    // Now set the input properly
    for (int i=0; i < M; ++i){
        m_y[i] = 0;
    }
    m_y[r] = 1;

    mxArray* prhs[2];
    prhs[0] = m_pAt;
    prhs[1] = m_pYArr;
    mxArray* plhs[1];
    mexCallMATLAB(1,plhs, 2, prhs,"feval");

    // Copy the result back
    mxArray* y_arr = plhs[0];
    double* dy = mxGetPr(y_arr);
    double* bb = b;
    for (int i=0; i < N; ++i){
        *b = dy[i];
        b += inc;
    }
    // Destroy the returned array
    mxDestroyArray(y_arr);
}

void AAtFuncOp::extract_columns( const mwIndex indices[], mwSize k,
                               double B[]) const {
    for (int i=0; i < k; ++i){
        mwIndex c = indices[i];
        if (c >= N) {
            throw std::invalid_argument("index out of range.");
        }
        double *b = B + M * i;
        column(c, b);
    }
}

void AAtFuncOp::extract_columns(const index_vector& indices, Matrix& output) const {
    if (indices.size() > output.columns()){
        throw std::length_error("Output doesn't have sufficient space");
    }
    if (output.rows() != M){
        throw std::length_error("Output matrix size not compatible.");
    }
    extract_columns(&(indices[0]), indices.size(), output.head());
}


void AAtFuncOp::extract_rows( const mwIndex indices[], mwSize k, double B[]) const {
    for (int i=0; i < k; ++i){
        mwIndex r = indices[i];
        if (r >= M) {
            throw std::invalid_argument("index out of range.");
        }
        double *b = B +  i;
        row(r, b, k);
    }
}

void AAtFuncOp::mult_vec(const double x[], double y[]) const {
    // Set the input properly
    for (int i=0; i < N; ++i){
        m_x[i] = x[i];
    }
    mxArray* prhs[2];
    prhs[0] = m_pA;
    prhs[1] = m_pXArr;
    mxArray* plhs[1];
    mexCallMATLAB(1,plhs, 2, prhs,"feval");
    // Copy the result back
    mxArray* y_arr = plhs[0];
    double* dy = mxGetPr(y_arr);
    for (int i=0; i < M; ++i){
        y[i] = dy[i];
    }
    // Destroy the returned array
    mxDestroyArray(y_arr);
}

void AAtFuncOp::mult_vec(const Vec& x, Vec& y) const {
    if (x.length() != N){
        throw std::length_error("x must have length equal to number of columns of A.");
    }
    if (y.length() != M){
        throw std::length_error("y must have length equal to the number of rows of A.");
    }
    mult_vec(x.head(), y.head());
}

void AAtFuncOp::mult_t_vec(const double x[], double y[]) const {
    // Now set the input properly
    for (int i=0; i < M; ++i){
        m_y[i] = x[i];
    }
    mxArray* prhs[2];
    prhs[0] = m_pAt;
    prhs[1] = m_pYArr;
    mxArray* plhs[1];
    mexCallMATLAB(1,plhs, 2, prhs,"feval");
    // Copy the result back
    mxArray* y_arr = plhs[0];
    double* dy = mxGetPr(y_arr);
    for (int i=0; i < N; ++i){
        y[i] = dy[i];
    }
    // Destroy the returned array
    mxDestroyArray(y_arr);
}

void AAtFuncOp::mult_t_vec(const Vec& x, Vec& y) const {
    if (x.length() != M){
        throw std::length_error("x must have length equal to number of rows of A.");
    }
    if (y.length() != N){
        throw std::length_error("y must have length equal to the number of columns of A.");
    }
    mult_t_vec(x.head(), y.head());
}

void AAtFuncOp::mult_vec( const mwIndex indices[], mwSize k, const double x[], double y[]) const {
    for (int i=0; i < N; ++i){
        m_x[i] = 0;
    }
    for(int i=0; i<k; i++ ) {
        // Corresponding column number
        mwIndex c = indices[i];
        if (c >= N) {
            throw std::invalid_argument("index out of range.");
        }
        m_x[c] = x[i];
    }
    mxArray* prhs[2];
    prhs[0] = m_pA;
    prhs[1] = m_pXArr;
    mxArray* plhs[1];
    mexCallMATLAB(1,plhs, 2, prhs,"feval");
    // Copy the result back
    mxArray* y_arr = plhs[0];
    double* dy = mxGetPr(y_arr);
    for (int i=0; i < M; ++i){
        y[i] = dy[i];
    }
    // Destroy the returned array
    mxDestroyArray(y_arr);
}

void AAtFuncOp::add_column_to_vec(double coeff, mwIndex c, double x[]) const {
    if (c >= N) {
        throw std::invalid_argument("index out of range.");
    }
    for (int i=0; i < N; ++i){
        m_x[i] = 0;
    }
    m_x[c] = 1;

    mxArray* prhs[2];
    prhs[0] = m_pA;
    prhs[1] = m_pXArr;
    mxArray* plhs[1];
    mexCallMATLAB(1,plhs, 2, prhs,"feval");

    // Copy the result back
    mxArray* y_arr = plhs[0];
    double* dy = mxGetPr(y_arr);
    for (int i=0; i < M; ++i){
        x[i] += coeff*dy[i];
    }
    // Destroy the returned array
    mxDestroyArray(y_arr);
}

bool AAtFuncOp::copy_matrix_to(Matrix& dst) const {
    if (M != dst.rows()){
        throw std::invalid_argument("mismatch in number or rows");
    }
    if (N != dst.columns()){
        throw std::invalid_argument("mismatch in number of columns.");
    }
    // Copy column by column
    double* out = dst.head();
    for (int i=0; i < N; ++i){
        column(i, out + M * i);
    }
}



} // spx