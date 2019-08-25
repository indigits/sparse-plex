#ifndef _SPX_OPERATOR_H_ 
#define _SPX_OPERATOR_H_ 1

#include <mex.h>
#include <vector>
#include <tuple>
#include <stdexcept>
#include <string>

#include "spx_vector.hpp"
#include "spx_matrix.hpp"

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
 *  Adapts spx::Matrix as Operator
 ************************************************/

class MatrixOp : public Operator {
public:
    MatrixOp(Matrix& matrix);
    virtual ~MatrixOp();
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
    MatrixOp();
private:
    Matrix& m_impl;
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
    //! Update the sparse values
    void update_values(const Vec& b);
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
