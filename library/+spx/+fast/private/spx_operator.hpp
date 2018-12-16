#ifndef _SPX_OPERATOR_H_ 
#define _SPX_OPERATOR_H_ 1

#include <mex.h>
#include <vector>
#include <tuple>
#include <stdexcept>
#include <string>
namespace spx {

typedef std::vector<double> d_vector;
typedef std::vector<int> i_vector;

/// Level of verbosity in different algorithms
enum VERBOSITY {
    BASIC = 1,
    PROFILE = 2,
    DEBUG_LOW = 3,
    DEBUG_MID = 4,
    DEBUG_HIGH = 5,
    DEBUG_HUGE = 6,
};

class Matrix;
class MxArray;

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
    virtual void extract_rows( const mwIndex indices[], mwSize k, double B[]) const = 0;
    virtual void mult_vec(const double x[], double y[]) const = 0;
    virtual void mult_t_vec(const double x[], double y[]) const = 0;
    virtual void mult_submat_vec(const mwIndex indices[], mwSize k, const double x[], double y[]) const = 0;
    virtual void add_column_to_vec(double coeff, mwIndex index, double x[]) const = 0;
    //! Copies contents of the matrix to destination matrix
    virtual bool copy_matrix_to(Matrix& dst) const = 0;
private:
};

class Matrix : public Operator {
public:
    Matrix(mwSize rows, mwSize cols);
    Matrix(double *pMatrix, mwSize rows, mwSize cols, bool bOwned = false);
    virtual ~Matrix();
    virtual mwSize rows() const;
    virtual mwSize columns() const;
    virtual void column(mwIndex index, double b[]) const;
    virtual void extract_columns( const mwIndex indices[], mwSize k, double B[]) const;
    virtual void extract_rows( const mwIndex indices[], mwSize k, double B[]) const;
    virtual void mult_vec(const double x[], double y[]) const;
    virtual void mult_t_vec(const double x[], double y[]) const;
    virtual void mult_submat_vec(const mwIndex indices[], mwSize k, const double x[], double y[]) const;
    virtual void add_column_to_vec(double coeff, mwIndex index, double x[]) const;
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


class MxArray : public Operator {
public:
    MxArray(const mxArray *pMatrix, bool bOwned = false);
    virtual ~MxArray();
    virtual mwSize rows() const;
    virtual mwSize columns() const;
    virtual void column(mwIndex index, double b[]) const;
    virtual void extract_columns( const mwIndex indices[], mwSize k, double B[]) const;
    virtual void extract_rows( const mwIndex indices[], mwSize k, double B[]) const;
    virtual void mult_vec(const double x[], double y[]) const;
    virtual void mult_t_vec(const double x[], double y[]) const;
    virtual void mult_submat_vec(const mwIndex indices[], mwSize k, const double x[], double y[]) const;
    virtual void add_column_to_vec(double coeff, mwIndex index, double x[]) const;
    virtual bool copy_matrix_to(Matrix& dst) const;
    inline const Matrix& impl() const {
        return m_impl;
    }
private:
    MxArray();
private:
    const mxArray *m_pMatrix;
    const bool  m_bOwned;
    Matrix m_impl;
};

mxArray* d_vec_to_mx_array(const d_vector& x);

void print_d_vec(const d_vector& x, const std::string& name = "");
void print_i_vec(const i_vector& x, const std::string& name = "");

}

#endif // _SPX_OPERATOR_H_
