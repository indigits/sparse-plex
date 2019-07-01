#ifndef _SPX_OPERATOR_H_ 
#define _SPX_OPERATOR_H_ 1

#include <mex.h>
#include <vector>
#include <tuple>
#include <stdexcept>
#include <string>

#include "spx_vector.hpp"

namespace spx {


/// Level of verbosity in different algorithms
enum VERBOSITY {
    QUIET = 0,
    DEBUG_BASIC = 1,
    DEBUG_PROFILE = 2,
    DEBUG_LOW = 3,
    DEBUG_MID = 4,
    DEBUG_HIGH = 5,
    DEBUG_HUGE = 6,
};

class Matrix;
class MxFullMat;

// Base class for operators
class Operator {
public:
    static Operator* create(const mxArray* A);
public: 
    Operator();
    virtual ~Operator();
    //! Returns the number or rows of matrix equivalent
    virtual mwSize rows() const = 0;
    //! Returns the number of columns of the matrix equivalent
    virtual mwSize columns() const = 0;
    //! Returns a particular column from the matrix
    virtual void column(mwIndex index, double b[]) const = 0;
    virtual void extract_columns( const mwIndex indices[], mwSize k, double B[]) const = 0;
    virtual void extract_columns(const index_vector& indices, Matrix& output) const = 0;
    virtual void extract_rows( const mwIndex indices[], mwSize k, double B[]) const = 0;
    virtual void mult_vec(const double x[], double y[]) const = 0;
    virtual void mult_vec(const Vec& x, Vec& y) const = 0;
    virtual void mult_t_vec(const double x[], double y[]) const = 0;
    virtual void mult_t_vec(const Vec& x, Vec& y) const = 0;
    virtual void mult_vec(const mwIndex indices[], mwSize k, const double x[], double y[]) const = 0;
    virtual void add_column_to_vec(double coeff, mwIndex index, double x[]) const = 0;
    //! Copies contents of the matrix to destination matrix
    virtual bool copy_matrix_to(Matrix& dst) const = 0;
private:
};




/************************************************
 *  Matrix Operator Declaration
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

class Matrix : public Operator {
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
    //! Computes the gram matrix for the this matrix
    void gram(Matrix& output) const;
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

/************************************************
 *  MxFullMat Operator Declaration
 ************************************************/

class MxFullMat : public Operator {
public:
    MxFullMat(const mxArray *pMatrix);
    virtual ~MxFullMat();
    virtual mwSize rows() const;
    virtual mwSize columns() const;
    virtual void column(mwIndex index, double b[]) const;
    virtual void extract_columns( const mwIndex indices[], mwSize k, double B[]) const;
    virtual void extract_columns(const index_vector& indices, Matrix& output) const;
    virtual void extract_rows( const mwIndex indices[], mwSize k, double B[]) const;
    virtual void mult_vec(const double x[], double y[]) const;
    virtual void mult_vec(const Vec& x, Vec& y) const;
    virtual void mult_t_vec(const double x[], double y[]) const;
    virtual void mult_t_vec(const Vec& x, Vec& y) const;
    virtual void mult_vec(const mwIndex indices[], mwSize k, const double x[], double y[]) const;
    virtual void add_column_to_vec(double coeff, mwIndex index, double x[]) const;
    virtual bool copy_matrix_to(Matrix& dst) const;
    inline const Matrix& impl() const {
        return m_impl;
    }
    inline Matrix& impl() {
        return m_impl;
    }
private:
    MxFullMat();
private:
    const mxArray *m_pMatrix;
    Matrix m_impl;
};


/************************************************
 *  MxSparseMat Operator Wrapper over sparse MATLAB arrays
 ************************************************/
class MxSparseMat : public Operator {
public:
    MxSparseMat(const mxArray *pMatrix);
    virtual ~MxSparseMat();
    virtual mwSize rows() const;
    virtual mwSize columns() const;
    virtual void column(mwIndex index, double b[]) const;
    virtual void extract_columns( const mwIndex indices[], mwSize k, double B[]) const;
    virtual void extract_columns(const index_vector& indices, Matrix& output) const;
    virtual void extract_rows( const mwIndex indices[], mwSize k, double B[]) const;
    virtual void mult_vec(const double x[], double y[]) const;
    virtual void mult_vec(const Vec& x, Vec& y) const;
    virtual void mult_t_vec(const double x[], double y[]) const;
    virtual void mult_t_vec(const Vec& x, Vec& y) const;
    virtual void mult_vec(const mwIndex indices[], mwSize k, const double x[], double y[]) const;
    virtual void add_column_to_vec(double coeff, mwIndex index, double x[]) const;
    virtual bool copy_matrix_to(Matrix& dst) const;
public:
    //! Number of non-zero entries
    mwSize nnz() const;
    //! Number of non-zero entries in c-th column
    mwSize nnz_col(mwIndex c) const;
private:
    MxSparseMat();
private:
    //! pointer to the sparse array
    const mxArray *m_pMatrix;
    //! Number of rows
    mwSize M;
    //! Number of columns
    mwSize N;
    //! Pointer to the real data
    double *m_pr;
    //! Pointer to ir indices
    mwIndex *m_ir;
    //! Pointer to jc indices
    mwIndex *m_jc;
};

/************************************************
 *  Operator Wrapper over function handles
 *  A, At, M, N should be provided
 * TODO: Support the case where At is missing.
 ************************************************/
class AAtFuncOp : public Operator {
public:
    AAtFuncOp(const mxArray *pStruct);
    virtual ~AAtFuncOp();
    virtual mwSize rows() const;
    virtual mwSize columns() const;
    virtual void column(mwIndex index, double b[]) const;
    virtual void row(mwIndex index, double b[], mwIndex inc) const;
    virtual void extract_columns( const mwIndex indices[], mwSize k, double B[]) const;
    virtual void extract_columns(const index_vector& indices, Matrix& output) const;
    virtual void extract_rows( const mwIndex indices[], mwSize k, double B[]) const;
    virtual void mult_vec(const double x[], double y[]) const;
    virtual void mult_vec(const Vec& x, Vec& y) const;
    virtual void mult_t_vec(const double x[], double y[]) const;
    virtual void mult_t_vec(const Vec& x, Vec& y) const;
    virtual void mult_vec(const mwIndex indices[], mwSize k, const double x[], double y[]) const;
    virtual void add_column_to_vec(double coeff, mwIndex index, double x[]) const;
    virtual bool copy_matrix_to(Matrix& dst) const;
public:
private:
    AAtFuncOp();
private:
    //! pointer to the spars array
    const mxArray *m_pStruct;
    mxArray *m_pA;
    mxArray *m_pAt;
    //! Number of rows
    mwSize M;
    //! Number of columns
    mwSize N;
private:
    mxArray* m_pXArr;
    mxArray* m_pYArr;
    double* m_x;
    double* m_y;
};

//! Checks if the structure is a valid function handle operator
bool is_aat_func_op(const mxArray *pStruct);

}

#endif // _SPX_OPERATOR_H_
