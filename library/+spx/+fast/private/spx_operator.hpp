#include <mex.h>
#include <vector>

namespace spx {

typedef std::vector<double> d_vector;

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
private:
};

class MatrixOperator : public Operator {
public:
    MatrixOperator(double *pMatrix, mwSize rows, mwSize cols, bool bOwned = false);
    virtual ~MatrixOperator();
    virtual mwSize rows() const;
    virtual mwSize columns() const;
    virtual void column(mwIndex index, double b[]) const;
    virtual void extract_columns( const mwIndex indices[], mwSize k, double B[]) const;
    virtual void extract_rows( const mwIndex indices[], mwSize k, double B[]) const;
    virtual void mult_vec(const double x[], double y[]) const;
    virtual void mult_t_vec(const double x[], double y[]) const;
    virtual void mult_submat_vec(const mwIndex indices[], mwSize k, const double x[], double y[]) const;
    virtual void add_column_to_vec(double coeff, mwIndex index, double x[]) const;
private:
    double *m_pMatrix;
    mwSize m_rows;
    mwSize m_cols;
    const bool  m_bOwned;
};


class MxArrayOperator : public Operator {
public:
    MxArrayOperator(const mxArray *pMatrix, bool bOwned = false);
    virtual ~MxArrayOperator();
    virtual mwSize rows() const;
    virtual mwSize columns() const;
    virtual void column(mwIndex index, double b[]) const;
    virtual void extract_columns( const mwIndex indices[], mwSize k, double B[]) const;
    virtual void extract_rows( const mwIndex indices[], mwSize k, double B[]) const;
    virtual void mult_vec(const double x[], double y[]) const;
    virtual void mult_t_vec(const double x[], double y[]) const;
    virtual void mult_submat_vec(const mwIndex indices[], mwSize k, const double x[], double y[]) const;
    virtual void add_column_to_vec(double coeff, mwIndex index, double x[]) const;
private:
    const mxArray *m_pMatrix;
    const bool  m_bOwned;
    MatrixOperator m_impl;
};

mxArray* d_vec_to_mx_array(const d_vector& x);


}
