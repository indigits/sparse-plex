/**
Wrapper for BLAS functions

This code is derived from OMPBOX.
Hand coded C routines have been replaced
in many cases with implementations from
BLAS and LAPACK.

Some conventions:
- input arguments are marked with const
- output arguments are non-const
- array values are returned  through output arguments
- scalar values are returned through return values.
- input arrays come first.
- output arrays follow.
- scalars describing dimensions etc. come last.

*/

#ifndef _SPX_BLAS_H_
#define _SPX_BLAS_H_ 1

#include <math.h>
#include "mex.h"

/**
Square of a value
*/
#define SQR(x) ((x) * (x))

/********************************************
* One vector operations
*
*********************************************/

/**
Returns the index of the maximum absolute value in the array
*/
mwIndex abs_max_index(const double x[], mwSize n);

/**
Returns the index of the maximum absolute value in the array
This version doesn't use BLAS.
*/
mwIndex abs_max_index_2(const double x[], mwSize n);


/**
Returns the index of the maximum value in the array
*/
mwIndex max_index(const double x[], mwSize n);

/**
Extracts a vector y = x(indices)
*/
void vec_extract(const double x[], 
    const mwIndex indices[], double y[], mwSize k);

/**
Set same value to all entries in vector
*/
void vec_set_value(double x[], double value, mwSize n);

/********************************************
* One matrix operations
*
*********************************************/

/**
Computes the transpose
Y = X'
*/
void mat_transpose(const double X[], double Y[], mwSize m, mwSize n);


/**
Extracts a submatrix B = A(:, indices)
*/
void mat_col_extract(const double A[], 
    const mwIndex indices[], double B[], mwSize m, mwSize k);

/**
Extracts a submatrix B = A(indices, :)
*/
void mat_row_extract(const double A[], 
    const mwIndex indices[], double B[], mwSize m, mwSize n, mwSize k);

/**
Absolute sum over columns of a matrix
*/
void mat_col_asum(const double A[], double v[], mwSize m, mwSize n);

/**
Absolute sum over rows of a matrix
*/
void mat_row_asum(const double A[], double v[], mwSize m, mwSize n);


/********************************************
* Vector vector operations
*
*********************************************/

void v_subtract(const double x[], 
    const double y[], double z[], mwSize n);


/**
Square the elements of x into y
*/
void v_square(const double x[], 
    double y[], mwSize n);

/**
Computes 
y = alpha * x + y 
*/
void sum_vec_vec(double alpha, const double x[], double y[], mwSize n);

/***
Copies a vector y = x
*/
void copy_vec_vec(const double x[], double y[], mwSize n);


/**
Computes inner product of two vectors
*/
double inner_product(const double a[], const double b[], mwSize n);


/********************************************
* Matrix vector operations
*
*********************************************/

/***
Compute y = alpha * A * x
*/
void mult_mat_vec(double alpha, 
    const double A[], 
    const double x[], 
    double y[], mwSize m, mwSize n);

/***
Compute y = alpha * A' * x
*/
void mult_mat_t_vec(double alpha, 
    const double A[], 
    const double x[], 
    double y[], mwSize m, mwSize n);

/***
Compute y = alpha * A * x where x is sparse array
*/
void mult_mat_vec_sp(double alpha, 
    const double A[], 
    const double pr[], const mwIndex ir[], const mwIndex jc[],
    double y[], mwSize m, mwSize n);

/***
Compute y = alpha * A(:, indices) * x
k is the number of column indices and length of x.
m is the number of rows in A.
*/
void mult_submat_vec(double alpha, 
    const double A[], 
    const mwSize indices[], 
    const double x[],
    double y[], mwSize m, mwSize k);

/***
Compute y = alpha * A(:, indices)' * x
k is the number of column indices and length of y.
m is the number of rows in A and the length of x.
*/
void mult_submat_t_vec(double alpha, 
    const double A[], 
    const mwSize indices[], 
    const double x[],
    double y[], mwSize m, mwSize k);



/**
Solves a lower triangular system via back substitution

L x  = b

where L is lower triangular.

L can be of a size m x n where 
m is the number of rows and n
is the number of columns.

k is the number of equations to solve.
We require that k <= m, n

Only the  lower triangle of the submatrix L(1:k, 1:k) is used 
for solving the problem.

*/
void lt_back_substitution(const double L[], 
    const double b[], 
    double x[], 
    mwSize m, mwSize k);

/**
Solves the Lx = b problem column wise.
Requires b to be modifiable.
*/
void lt_back_substitution_col(const double L[], 
    double b[], 
    double x[], 
    mwSize m, mwSize k);

/**
Solves an upper triangular system via back substitution

U x  = b

where U is upper triangular.

U can be of a size m x n where 
m is the number of rows and n
is the number of columns.

k is the number of equations to solve.
We require that k <= m, n

Only the upper triangle of the submatrix U(1:k, 1:k) is used 
for solving the problem.

*/
void ut_back_substitution(const double U[], 
    const double b[], 
    double x[], 
    mwSize m, mwSize k);

/**
Solves an upper triangular system via back substitution

L' x  = b

where L is lower triangular.

L can be of a size m x n where 
m is the number of rows and n
is the number of columns.

k is the number of equations to solve.
We require that k <= m, n

Only the upper triangle of the submatrix L'(1:k, 1:k) is used 
for solving the problem.

*/
void lt_t_back_substitution(const double L[], 
    const double b[], 
    double x[], 
    mwSize m, mwSize k);


/**
Solves the linear system 
A x = b

where A is a symmetric positive definite matrix
with the decomposition
A = L L' where L is a lower triangular matrix.

L can be of a size m x n where 
m is the number of rows and n
is the number of columns.

k is the number of equations to solve.
We require that k <= m, n

Only the  lower triangle of the submatrix L(1:k, 1:k) is used 
for solving the problem.
*/
void spd_chol_lt_solve(const double L[], 
    const double b[], 
    double x[], 
    mwSize m, mwSize k);


/**
This version avoids internal memory allocation
and uses column operations.
*/
void spd_chol_lt_solve2(const double L[], 
    double b[], 
    double x[], 
    double tmp[],
    mwSize m, mwSize k);

/**
This version uses LAPACK function trtrs.
*/
void spd_lt_trtrs(const double L[],
    double b[],
    mwSize m, mwSize k);


/**
This version solves multiple
right hand sides 
using the LAPACK function trtrs.
*/
void spd_lt_trtrs_multi(const double L[],
    double B[],
    mwSize m, mwSize k, mwSize s);


/********************************************
* Least Square Problems
*
*********************************************/

/**
Solves the least square problem A x = b
*/
mwSignedIndex ls_qr_solve(double A[],
    double b[],
    mwSize m, mwSize n);


/********************************************
* Matrix matrix operations
*
*********************************************/





/** 
Matrix matrix multiplication 

Compute X = alpha * A * B

A is m x k,  B is k x n
*/
void mult_mat_mat(double alpha, 
    const double A[], 
    const double B[], 
    double X[], 
    mwSize m, mwSize n, mwSize k);

/** 
Matrix transpose matrix multiplication 

Compute X = alpha * A' * B

A' is m x k,  B is k x n
A is k x m

Output is m x n.

Put the output dimensions first.
Then the common dimension.
*/
void mult_mat_t_mat(double alpha, 
    const double A[], 
    const double B[], 
    double X[], 
    mwSize m, mwSize n, mwSize k);






/********************************************
* Debugging functions
*
*********************************************/


/**
Prints the contents of a matrix
*/
void print_matrix(const double A[], int m, int n, char* matrix_name);

/**
Prints the contents of a vector
*/
void print_vector(const double v_x[], int n, char* vec_name);

/**
Prints the contents of a vector
*/
void print_index_vector(const mwIndex v_x[], int n, char* vec_name);

/**
Prints the contents of a sparse vector
*/
void print_sparse_vector(const mxArray *A, char* vector_name);


#endif 


