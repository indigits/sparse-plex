#ifndef _SPX_MATRIX_H_ 
#define _SPX_MATRIX_H_ 1

#include <mex.h>
#include <tuple>
#include <stdexcept>
#include "blas.h"

#include "spxblas.h"
#include "spx_vector.hpp"

namespace spx {


/************************************************
 *  Matrix  Declaration
 ************************************************/


/**

Available operations 

Information
------------------

[m, n] = size(A)
- m = A.rows(), n = A.columns()

Extraction
------------------

x = A(i, j)
- x = A(i, j)

B = A
- Fully copy  A.copy_matrix_to(B)

B = A(:, indices)
- Copy: A.extract_columns(indices, B)
- Copy: A.extract_columns(indices, k, B)

z = A(:, n)  
- Copying  A.column(n, z)
- Reference: Vec z = A.column_ref(n)

B = A(:, start:end)
- Reference: Matrix B = A.columns_ref(start, end+1)


Matrix Vector Multiplication
--------------------------------

y = A * x    
- A.mult_vec(x, y)

y = A' * x   
- A.mult_t_vec(x, y)

y = A(:, indices) * x
- A.mult_vec(indices, k, x, y)



x += coeff * A(:, column)
- A.add_column_to_vec(coeff, column, x)


Stats
------------------

[v, i] = max(A(:, k))
- tuple = A.col_max(k)

[v, i] = min(A(:, k))
- tuple = A.col_min(k)

[v, i] = max(A(k, :))
- tuple = A.row_max(k)

[v, i] = min(A(k, :))
- tuple = A.row_min(k)

G = A' * A
- A.gram(G)


Updates
--------------------

A(i, j) = x
- A(i, j) = x

A(:) = value
- A.set(value)

A(:, k) = A(:,k) + value
- A.add_to_col(k, value)

A(:, k) = value
- A.set_column(k, value)

A(1:m+1:end) = value
- A.set_diag(value)

A(1:m+1:end) = v [vector]
- A.set_diag(v)

B = A == value
- A.find_value(value, B)

*/

class Matrix {
public:
    //! Constructs a self owned matrix
    Matrix(mwSize rows, mwSize cols);
    //! Constructs a matrix object for an mxArray full matrix
    Matrix(const mxArray* pMat);
    //! Construct a matrix on data owned by someone else
    Matrix(double *pMatrix, mwSize rows, mwSize cols, bool bOwned = false);
    //! Construct a view over a set of columns from another matrix
    Matrix(Matrix& source, mwSize start_col, mwSize num_cols);
    //! Destructor
    virtual ~Matrix();
    //! Returns the number of rows
    virtual mwSize rows() const;
    //! Returns the number of columns
    virtual mwSize columns() const;
    //! Returns the head of the matrix
    inline const double* head() const {
        return m_pMatrix;
    }
    //! Returns the head of the matrix [for modification]
    inline double* head() {
        return m_pMatrix;
    }
    //! Returns reference to a column
    inline Vec column_ref(mwIndex col) const {
        double* beg = m_pMatrix + col * m_rows;
        return Vec(beg, m_rows, 1);
    }
    //! Returns reference to a row
    inline Vec row_ref(mwIndex row) const {
        double* beg = m_pMatrix + row;
        return Vec(beg, m_cols, m_rows);
    }
    //! Returns reference to sub-matrix of columns
    Matrix columns_ref(mwIndex start, mwIndex end) const;
    //! Copies the data of one column in b
    virtual void column(mwIndex index, double b[]) const;
    //! Extracts the data of multiple columns into a raw array
    virtual void extract_columns( const mwIndex indices[], mwSize k, double B[]) const;
    //! Extracts the data of multiple columns into an output matrix
    virtual void extract_columns(const index_vector& indices, Matrix& output) const;
    //! Extracts the data of multiple rows into an output array
    virtual void extract_rows( const mwIndex indices[], mwSize k, double B[]) const;
    //! y = A * x
    virtual void mult_vec(const double x[], double y[]) const;
    virtual void mult_vec(const Vec& x, Vec& y) const;
    //! y = A(:, indices) * x
    void mult_vec(const index_vector& indices, const Vec& x, Vec& y) const;
    //! y = A(:, indices) * x
    virtual void mult_vec(const mwIndex indices[], mwSize k, const double x[], double y[]) const;
    //! y = A' * x
    virtual void mult_t_vec(const double x[], double y[]) const;
    virtual void mult_t_vec(const Vec& x, Vec& y) const;
    //! y = A(:, indices)' * x
    void mult_t_vec(const index_vector& indices, const Vec& x, Vec& y) const;
    //! x += coeff * A(:, column)
    virtual void add_column_to_vec(double coeff, mwIndex index, double x[]) const;
    //! dst = src (full copy)
    virtual bool copy_matrix_to(Matrix& dst) const;
public:
    //! max for a particular column
    std::tuple<double, mwIndex> col_max(mwIndex col) const;
    //! min for a particular column
    std::tuple<double, mwIndex> col_min(mwIndex col) const;
    //! max for a particular row
    std::tuple<double, mwIndex> row_max(mwIndex row) const;
    //! min for a particular row
    std::tuple<double, mwIndex> row_min(mwIndex row) const;
    //! add a particular value to a column
    void add_to_col(mwIndex col, const double &value);
    //! set the contents of a column
    void set_column(mwIndex col, const Vec& input, double alpha = 1.0);
    //! Set all entries to a fixed value
    void set(double value);
    //! Set diagonal entries to a fixed value
    void set_diag(double value);
    //! Set diagonal entries from a vector
    void set_diag(const Vec& input);
    //! add a particular value to a row
    void add_to_row(mwIndex row, const double &value);
    //! subtract column minimums from columns
    void subtract_col_mins_from_cols();
    //! subtract row minimums from rows
    void subtract_row_mins_from_rows();
    //! Finds a particular value inside the matrix
    void find_value(const double &value, Matrix& result) const;
    //! Return a value
    inline double operator()(mwIndex row, mwIndex col) const {
        return m_pMatrix[col * m_rows + row];
    }
    //! Return a reference to a value
    inline double& operator()(mwIndex row, mwIndex col) {
        return m_pMatrix[col * m_rows + row];
    }
    //! Computes the gram matrix for this matrix
    void gram(Matrix& output) const;
    //! Computes the frame operator A * A' for this matrix
    void frame(Matrix& output) const;
    //! Swap columns 
    void swap_columns(mwIndex i, mwIndex j);
    //! Swap rows 
    void swap_rows(mwIndex i, mwIndex j);
    //! Scale column by a factor value
    void scale_column(mwIndex i, double value);
    //! Scale row by a factor value
    void scale_row(mwIndex i, double value);
public:
    // Functions for printing
    void print_matrix(const char* name="") const;
    void print_int_matrix(const char* name="") const;
private:
    Matrix();
private:
    //! Pointer to the head of the matrix
    double *m_pMatrix;
    //! Number of rows in the matrix
    mwSize m_rows;
    //! Number of columns in the matrix
    mwSize m_cols;
    //! Indicates if the data of the matrix is owned by this object
    const bool  m_bOwned;
};

// ! Computes the product of two matrices A and B into C
void multiply(const Matrix& A, const Matrix& B, Matrix& C, bool a_transpose=false, bool b_transpose=false);


}

#endif // _SPX_MATRIX_H_

