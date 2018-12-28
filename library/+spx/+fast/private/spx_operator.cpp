#include <stdexcept>
#include "spx_operator.hpp"
#include "blas.h"
#include "spxblas.h"
namespace spx {

Operator::Operator(){
}

Operator::~Operator(){

}

/************************************************
 *  Matrix Operator Implementation
 ************************************************/

Matrix::Matrix(mwSize rows, mwSize cols):
m_pMatrix((double*)mxMalloc(rows*cols*sizeof(double))),
m_rows(rows),
m_cols(cols),
m_bOwned(true)
{
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
m_bOwned(false){

}


Matrix::~Matrix(){
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


void Matrix::column(mwIndex index, double b[]) const {
    double* a = m_pMatrix + index*m_rows;
    mwSignedIndex  inc = 1;
    mwSignedIndex mm = m_rows; 
    dcopy(&mm, a, &inc, b, &inc);
}

void Matrix::extract_columns( const mwIndex indices[], mwSize k, 
    double B[]) const{
     mat_col_extract(m_pMatrix, indices, B, m_rows, k);
}

void Matrix::extract_columns(const index_vector& indices, Matrix& output) const{
    double* B = output.m_pMatrix;
    const mwIndex* indices2 = &indices[0];
    mwSize k = indices.size();
    mat_col_extract(m_pMatrix, indices2, B, m_rows, k);
}

void Matrix::extract_rows( const mwIndex indices[], mwSize k, double B[]) const{
    mat_row_extract(m_pMatrix, indices, B, m_rows, m_cols, k);
}

void Matrix::mult_vec(const double x[], double y[]) const{
    mult_mat_vec(1, m_pMatrix, x, y, m_rows, m_cols);
}
void Matrix::mult_t_vec(const double x[], double y[]) const{
    mult_mat_t_vec(1, m_pMatrix, x, y, m_rows, m_cols);
}

void Matrix::mult_submat_vec( const mwIndex indices[], mwSize k, const double x[], double y[]) const{
    ::mult_submat_vec(1, m_pMatrix, indices, x, y, m_rows, k);
}

void Matrix::add_column_to_vec(double coeff, mwIndex index, double x[]) const{
    double* a = m_pMatrix + index*m_rows;
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
std::tuple<double, mwIndex> Matrix::col_max(mwIndex col) const{
    // Pointer to the beginning of column
    const double* x = m_pMatrix + col*m_rows;
    mwIndex max_index=0, k;
    double cur_value, max_value = *x;
    mwSize n = m_rows;
    for (k=1; k<n; ++k) {
        cur_value = x[k];
        if (cur_value > max_value) {
            max_value = cur_value;
            max_index = k;
        }
    }
    return std::tuple<double, mwIndex>(max_value, max_index);
}
std::tuple<double, mwIndex> Matrix::col_min(mwIndex col) const{
    // Pointer to the beginning of column
    const double* x = m_pMatrix + col*m_rows;
    mwIndex min_index=0, k;
    double cur_value, min_value = *x;
    mwSize n = m_rows;
    for (k=1; k<n; ++k) {
        cur_value = x[k];
        if (cur_value < min_value) {
            min_value = cur_value;
            min_index = k;
        }
    }
    return std::tuple<double, mwIndex>(min_value, min_index);
}
std::tuple<double, mwIndex> Matrix::row_max(mwIndex row) const{
    // Pointer to the beginning of row
    const double* x = m_pMatrix + row;
    mwIndex max_index=0, k;
    double cur_value, max_value = *x;
    mwSize n = m_cols;
    for (k=1; k<n; ++k) {
        x += m_rows;
        cur_value = *x;
        if (cur_value > max_value) {
            max_value = cur_value;
            max_index = k;
        }
    }
    return std::tuple<double, mwIndex>(max_value, max_index);
}
std::tuple<double, mwIndex> Matrix::row_min(mwIndex row) const{
    // Pointer to the beginning of row
    const double* x = m_pMatrix + row;
    mwIndex min_index=0, k;
    double cur_value, min_value = *x;
    mwSize n = m_cols;
    for (k=1; k<n; ++k) {
        x += m_rows;
        cur_value = *x;
        if (cur_value < min_value) {
            min_value = cur_value;
            min_index = k;
        }
    }
    return std::tuple<double, mwIndex>(min_value, min_index);
}

void Matrix::add_to_col(mwIndex col, const double &value){
    double* x = m_pMatrix + col*m_rows;
    mwSize n = m_rows;
    for (mwIndex k=0; k<n; ++k) {
        x[k] += value;
    }
}

void Matrix::add_to_row(mwIndex row, const double &value){
    double* x = m_pMatrix + row;
    mwSize n = m_cols;
    for (mwIndex k=0; k<n; ++k) {
        *x += value;
        x += m_rows;
    }
}

void Matrix::subtract_col_mins_from_cols() {
    mwSize n = m_cols;
    for (mwIndex c = 0; c < n; ++c){
        auto min_val = col_min(c);
        add_to_col(c, -std::get<0>(min_val));
    }
}

void Matrix::subtract_row_mins_from_rows(){
    mwSize n = m_rows;
    for (mwIndex r = 0; r < n; ++r){
        auto min_val = row_min(r);
        add_to_row(r, -std::get<0>(min_val));
    }
}

void Matrix::find_value(const double &value, Matrix& result) const{
    if (m_rows != result.rows()) {
        throw std::length_error("Number of rows mismatch");
    }
    if (m_cols != result.columns()) {
        throw std::length_error("Number of columns mismatch");
    }
    mwSize n  = m_rows * m_cols;
    double* p_src = m_pMatrix;
    double* p_dst = result.m_pMatrix;
    for (mwIndex i = 0; i < n; ++i){
        *p_dst = *p_src == value;
        ++p_src;
        ++p_dst;
    }
}

void Matrix::gram(Matrix& output) const{
    if(output.rows() != output.columns()) {
        throw std::logic_error("Gram matrix must be symmetric");
    }
    if(output.columns() != columns()) {
        throw std::logic_error("Size of gram matrix must be equal to the number of columns in source matrix");
    }
    double* src = m_pMatrix;
    int M = rows();
    int N = columns();
    mult_mat_t_mat(1, src, src, output.m_pMatrix, N, N, M);
}

/************************************************
 *  Matrix Printing
 ************************************************/

void Matrix::print_matrix(const char* name) const {
    ::print_matrix(m_pMatrix, m_rows, m_cols, name);
}

void Matrix::print_int_matrix(const char* name) const{
  int i, j;
  if (name[0]) {
      mexPrintf("\n%s = \n\n", name);
  }
  mwSize m = m_rows;
  mwSize n = m_cols;

  if (n*m==0) {
    mexPrintf("   Empty matrix: %d-by-%d\n\n", n, m);
    return;
  }
  double* A = m_pMatrix;
  for (i=0; i<n; ++i) {
    for (j=0; j<m; ++j)
      mexPrintf("   %d", (int)A[j*n+i]);
    mexPrintf("\n");
  }
  mexPrintf("\n");
}


/************************************************
 *  MxArray Operator Implementation
 ************************************************/

MxArray::MxArray(const mxArray *pMatrix, 
    bool bOwned):
m_pMatrix(pMatrix),
m_bOwned(bOwned),
m_impl(mxGetPr(pMatrix), mxGetM(pMatrix), mxGetN(pMatrix), false)
{
}

MxArray::~MxArray(){
    if (m_bOwned) {
        // release the memory
    }
}

mwSize MxArray::rows() const {
    return m_impl.rows();
}

mwSize MxArray::columns() const {
    return m_impl.columns();
}


void MxArray::column(mwIndex index, double b[]) const {
    m_impl.column(index, b);
}

void MxArray::extract_columns( const mwIndex indices[], mwSize k, 
    double B[]) const{
    m_impl.extract_columns(indices, k, B);
}

void MxArray::extract_columns(const index_vector& indices, Matrix& output) const{
    m_impl.extract_columns(indices, output);
}


void MxArray::extract_rows( const mwIndex indices[], mwSize k, double B[]) const{
    m_impl.extract_rows(indices, k, B);
}

void MxArray::mult_vec(const double x[], double y[]) const{
    m_impl.mult_vec(x, y);
}
void MxArray::mult_t_vec(const double x[], double y[]) const{
    m_impl.mult_t_vec(x, y);
}

void MxArray::mult_submat_vec( const mwIndex indices[], mwSize k, const double x[], double y[]) const{
    m_impl.mult_submat_vec(indices, k, x, y);
}

void MxArray::add_column_to_vec(double coeff, mwIndex index, double x[]) const{
    m_impl.add_column_to_vec(coeff, index, x);
}

bool MxArray::copy_matrix_to(Matrix& dst) const {
    return m_impl.copy_matrix_to(dst);
}


}
