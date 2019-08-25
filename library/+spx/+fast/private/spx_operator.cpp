#include <stdio.h>
#include <string.h>
#include <stdexcept>
#include "spx_operator.hpp"
#include "blas.h"
#include "spxblas.h"

#if !defined(_WIN32)

#ifndef dswap
#define dswap dswap_
#endif

#ifndef dscal 
#define dscal dscal_
#endif

#ifndef dgemm
#define dgemm dgemm_
#endif

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
 *  Matrix to Operator Adapter Implementation
 ************************************************/

MatrixOp::MatrixOp(Matrix& matrix):
    m_impl(matrix)
{
}

MatrixOp::~MatrixOp() {
}

mwSize MatrixOp::rows() const {
    return m_impl.rows();
}

mwSize MatrixOp::columns() const {
    return m_impl.columns();
}


void MatrixOp::column(mwIndex index, double b[]) const {
    m_impl.column(index, b);
}

void MatrixOp::extract_columns( const mwIndex indices[], mwSize k,
                               double B[]) const {
    m_impl.extract_columns(indices, k, B);
}

void MatrixOp::extract_columns(const index_vector& indices, Matrix& output) const {
    m_impl.extract_columns(indices, output);
}


void MatrixOp::extract_rows( const mwIndex indices[], mwSize k, double B[]) const {
    m_impl.extract_rows(indices, k, B);
}

void MatrixOp::mult_vec(const double x[], double y[]) const {
    m_impl.mult_vec(x, y);
}

void MatrixOp::mult_vec(const Vec& x, Vec& y) const {
    m_impl.mult_vec(x, y);
}

void MatrixOp::mult_t_vec(const double x[], double y[]) const {
    m_impl.mult_t_vec(x, y);
}

void MatrixOp::mult_t_vec(const Vec& x, Vec& y) const {
    m_impl.mult_t_vec(x, y);
}

void MatrixOp::mult_vec( const mwIndex indices[], mwSize k, const double x[], double y[]) const {
    m_impl.mult_vec(indices, k, x, y);
}

void MatrixOp::add_column_to_vec(double coeff, mwIndex index, double x[]) const {
    m_impl.add_column_to_vec(coeff, index, x);
}

bool MatrixOp::copy_matrix_to(Matrix& dst) const {
    return m_impl.copy_matrix_to(dst);
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


void MxSparseMat::update_values(const Vec& b){
    mwSize n = b.length();
    n = std::min(n, nnz());
    const double* src = b.head();
    double* dst = m_pr;
    for (int i=0; i < n; ++i){
        dst[i] = src[i];
    }
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