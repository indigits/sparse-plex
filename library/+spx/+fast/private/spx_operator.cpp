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
MatrixOperator::MatrixOperator(double *pMatrix, mwSize rows, mwSize cols, bool bOwned):
m_pMatrix(pMatrix),
m_rows(rows),
m_cols(cols),
m_bOwned(bOwned)
{    
}

MatrixOperator::~MatrixOperator(){
    if (m_bOwned) {
        // release the memory
    }
}

mwSize MatrixOperator::rows() const {
    return m_rows;
}

mwSize MatrixOperator::columns() const {
    return m_cols;
}


void MatrixOperator::column(mwIndex index, double b[]) const {
    double* a = m_pMatrix + index*m_rows;
    mwSignedIndex  inc = 1;
    mwSignedIndex mm = m_rows; 
    dcopy(&mm, a, &inc, b, &inc);
}

void MatrixOperator::extract_columns( const mwIndex indices[], mwSize k, 
    double B[]) const{
     mat_col_extract(m_pMatrix, indices, B, m_rows, k);
}

void MatrixOperator::extract_rows( const mwIndex indices[], mwSize k, double B[]) const{
    mat_row_extract(m_pMatrix, indices, B, m_rows, m_cols, k);
}

void MatrixOperator::mult_vec(const double x[], double y[]) const{
    mult_mat_vec(1, m_pMatrix, x, y, m_rows, m_cols);
}
void MatrixOperator::mult_t_vec(const double x[], double y[]) const{
    mult_mat_t_vec(1, m_pMatrix, x, y, m_rows, m_cols);
}

void MatrixOperator::mult_submat_vec( const mwIndex indices[], mwSize k, const double x[], double y[]) const{
    ::mult_submat_vec(1, m_pMatrix, indices, x, y, m_rows, k);
}

void MatrixOperator::add_column_to_vec(double coeff, mwIndex index, double x[]) const{
    double* a = m_pMatrix + index*m_rows;
    sum_vec_vec(coeff, a, x, m_rows);    
}


/************************************************
 *  MxArray Operator Implementation
 ************************************************/

MxArrayOperator::MxArrayOperator(const mxArray *pMatrix, 
    bool bOwned):
m_pMatrix(pMatrix),
m_bOwned(bOwned),
m_impl(mxGetPr(pMatrix), mxGetM(pMatrix), mxGetN(pMatrix), false)
{
}

MxArrayOperator::~MxArrayOperator(){
    if (m_bOwned) {
        // release the memory
    }
}

mwSize MxArrayOperator::rows() const {
    return m_impl.rows();
}

mwSize MxArrayOperator::columns() const {
    return m_impl.columns();
}


void MxArrayOperator::column(mwIndex index, double b[]) const {
    m_impl.column(index, b);
}

void MxArrayOperator::extract_columns( const mwIndex indices[], mwSize k, 
    double B[]) const{
    m_impl.extract_columns(indices, k, B);
}

void MxArrayOperator::extract_rows( const mwIndex indices[], mwSize k, double B[]) const{
    m_impl.extract_rows(indices, k, B);
}

void MxArrayOperator::mult_vec(const double x[], double y[]) const{
    m_impl.mult_vec(x, y);
}
void MxArrayOperator::mult_t_vec(const double x[], double y[]) const{
    m_impl.mult_t_vec(x, y);
}

void MxArrayOperator::mult_submat_vec( const mwIndex indices[], mwSize k, const double x[], double y[]) const{
    m_impl.mult_submat_vec(indices, k, x, y);
}

void MxArrayOperator::add_column_to_vec(double coeff, mwIndex index, double x[]) const{
    m_impl.add_column_to_vec(coeff, index, x);
}


/************************************************
 *  Utility functions
 ************************************************/

mxArray* d_vec_to_mx_array(const d_vector& x)
{
    mwSize N = x.size();
    mxArray* p_alpha = mxCreateDoubleMatrix(N, 1, mxREAL);
    double* m_alpha =  mxGetPr(p_alpha);
    copy_vec_vec(&x[0], m_alpha, N);
    return p_alpha;
}


}
