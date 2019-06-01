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
    virtual void mult_submat_vec(const mwIndex indices[], mwSize k, const double x[], double y[]) const = 0;
    virtual void add_column_to_vec(double coeff, mwIndex index, double x[]) const = 0;
    //! Copies contents of the matrix to destination matrix
    virtual bool copy_matrix_to(Matrix& dst) const = 0;
private:
};

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
    inline Vec column_ref(mwIndex col) {
        double* beg = m_pMatrix + col * m_rows;
        return Vec(beg, m_rows, 1);
    }
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
    //! y = A' * x
    virtual void mult_t_vec(const double x[], double y[]) const;
    virtual void mult_t_vec(const Vec& x, Vec& y) const;
    //! y = A(:, indices) * x
    virtual void mult_submat_vec(const mwIndex indices[], mwSize k, const double x[], double y[]) const;
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
public:
    // Functions for printing
    void print_matrix(const char* name="") const;
    void print_int_matrix(const char* name="") const;
private:
    Matrix();
private:
    double *m_pMatrix;
    mwSize m_rows;
    mwSize m_cols;
    const bool  m_bOwned;
};


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
    virtual void mult_submat_vec(const mwIndex indices[], mwSize k, const double x[], double y[]) const;
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

}

#endif // _SPX_OPERATOR_H_
