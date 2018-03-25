#include "spxblas.h"
#include "blas.h"
#include "lapack.h"
#include "stddef.h"


/**

Some useful references: 

- dgemv https://gitlab.phys.ethz.ch/hpcse_fs15/lecture/blob/324a55886a689479a7e47d011d98d953588a3212/examples/matrix/cblas/dgemv.c


*/

#if !defined(_WIN32)
#define dgemm dgemm_
#define dgemv dgemv_
#endif


/********************************************
* One vector operations
*
*********************************************/

mwIndex abs_max_index(const double x[], mwSize n){
    mwSignedIndex  nn = n;
    mwSignedIndex  incx = 1;
    return idamax(&nn, x, &incx) - 1;
}


mwIndex max_index(const double x[], mwSize n){
    mwIndex maxid=0, k;
    double val, maxval = *x;

    for (k=1; k<n; ++k) {
        val = x[k];
        if (val > maxval) {
            maxval = val;
            maxid = k;
        }
    }
    return maxid;    
}

void vec_extract(const double x[], 
    const mwIndex indices[], double y[], 
    mwSize k){    
    
    mwIndex i;

    for (i=0; i<k; ++i){
        y[i] = x[indices[i]];
    }
}

void vec_set_value(double x[], double value, mwSize n){
    int i;
    for (i=0; i < n; ++i){
        x[i] = value;
    }
}


/********************************************
* One matrix operations
*
*********************************************/

/* matrix transpose */

void mat_transpose(const double X[], double Y[], mwSize n, mwSize m)
{
  mwIndex i, j, i_m, j_n;
  
  if (n<m) {
    for (j=0; j<m; ++j) {
      j_n = j*n;
      for (i=0; i<n; ++i) {
        Y[j+i*m] = X[i+j_n];
      }
    }
  }
  else {
    for (i=0; i<n; ++i) {
      i_m = i*m;
      for (j=0; j<m; ++j) {
        Y[j+i_m] = X[i+j*n];
      }
    }
  }
}


/********************************************
* Vector vector operations
*
*********************************************/

void sum_vec_vec(double alpha, const double x[], double y[], mwSize n){
    mwSignedIndex  nn = n;
    mwSignedIndex  incx = 1; 
    daxpy(&nn, &alpha, x, &incx, y, &incx);   
}

void copy_vec_vec(const double x[], double y[], mwSize n){
    mwSignedIndex  nn = n;
    mwSignedIndex  inc = 1; 
    dcopy(&nn, x, &inc, y, &inc);
}


double inner_product(const double a[], 
    const double b[], mwSize n){
    mwSignedIndex  nn = n;
    mwSignedIndex  inc = 1; 
    ddot(&nn, a, &inc, b, &inc);
}



/********************************************
* Matrix vector operations
*
*********************************************/


void mult_mat_vec(double alpha, 
    const double A[], 
    const double x[], 
    double y[], mwSize m, mwSize n){
    
    mwSignedIndex  incx = 1;
    mwSignedIndex  incy = 1;
    char trans = 'N';
    double beta = 0;
    mwSignedIndex  mm = m;
    mwSignedIndex  nn = n;
    dgemv(&trans, &mm, &nn, &alpha, A, &mm, x, &incx, 
        &beta, y, &incy);
}

void mult_mat_t_vec(double alpha, 
    const double A[], 
    const double x[], 
    double y[], mwSize m, mwSize n){
    
    mwSignedIndex  incx = 1;
    mwSignedIndex  incy = 1;
    char trans = 'T';
    double beta = 0;
    mwSignedIndex  mm = m;
    mwSignedIndex  nn = n;
    dgemv(&trans, &mm, &nn, &alpha, A, &mm, x, &incx, 
        &beta, y, &incy);
}

void mult_mat_vec_sp(double alpha, 
    const double A[], 
    const  double pr[], 
    const mwIndex ir[], const mwIndex jc[],
    double y[], mwSize m, mwSize n){
    mwIndex i, j, j_col_offset, k, kend;
    /**
    Initialize result to 0
    */
    for (i=0; i<m; ++i) {
        y[i] = 0;
    }

    // number of non-zero entries in x (vector).
    kend = jc[1];
    if (kend==0) {   /* x is empty */
        return;
    }

    for (k=0; k<kend; ++k) {
        j = ir[k];
        // offset of j-th column in A
        j_col_offset = j*m;
        /**
        y += x[k] * A[j]
        */
        sum_vec_vec(alpha * pr[k], A + j_col_offset, y, m);
    }
}


void lt_back_substitution(const double L[], 
    const double b[], 
    double x[], 
    mwSize m, mwSize k)
{
  mwIndex i, j;
  double rhs;

  /**
  Iterate over rows
  */
  for (i=0; i<k; ++i) {
    rhs = b[i];
    /**
    Subtract over the entries in i-th row before
    the diagonal element.
    */
    for (j=0; j<i; ++j) {
      rhs -= L[j*m+i]*x[j];
    }
    /**
    Divide by the value in the i-th diagonal entry.
    */
    x[i] = rhs/L[i*m+i];
  }
}


void  ut_back_substitution(const double U[], 
    const double b[], 
    double x[], 
    mwSize m, mwSize k){
    mwIndex i, j;
    double rhs;

    /** We start from last row */ 
    for (i=k; i>=1; --i) {
        rhs = b[i-1];
        /** Subtract contributions from entries in row */
        for (j=i; j<k; ++j) {
          rhs -= U[j*m+i-1]*x[j];
        }
        /** Divide from the diagonal element in (i-1)-th row */
        x[i-1] = rhs/U[(i-1)*m+i-1];
      }
}

/**
Solves L' x = b
*/
void lt_t_back_substitution(const double L[], 
    const double b[], 
    double x[], 
    mwSize m, mwSize k){

    mwIndex i, j;
    double rhs;

    for (i=k; i>=1; --i) {
        rhs = b[i-1];
        for (j=i; j<k; ++j) {
            rhs -= L[(i-1)*m+j]*x[j];
        }
        x[i-1] = rhs/L[(i-1)*m+i-1];
    }

}


void spd_chol_lt_solve(const double L[], 
    const double b[], 
    double x[], 
    mwSize m, mwSize k){

    double *tmp;
    tmp = mxMalloc(k*sizeof(double));
    /**
    Solve the problem L t = b
    */
    lt_back_substitution(L, b, tmp, m, k);
    /**
    Solve the problem L' x = t
    */
    lt_t_back_substitution(L, tmp, x, m, k);
    mxFree(tmp);
}




/********************************************
* Matrix matrix operations
*
*********************************************/



void mult_mat_mat(double alpha, 
    const double A[], 
    const double B[], 
    double X[], 
    mwSize m, mwSize n, mwSize k){
    char atrans = 'N';
    char btrans = 'N';
    double beta = 0;
    mwSignedIndex  mm = m;
    mwSignedIndex  nn = n;
    mwSignedIndex  kk = k;
    dgemm(&atrans, &btrans, 
        &mm, &nn, &kk, 
        &alpha, 
        A, &mm, 
        B, &kk, 
        &beta, 
        X, &mm);
}

void mult_mat_t_mat(double alpha, 
    const double A[], 
    const double B[], 
    double X[], 
    mwSize m, mwSize n, mwSize k){
    char atrans = 'T';
    char btrans = 'N';
    double beta = 0;
    mwSignedIndex  mm = m;
    mwSignedIndex  nn = n;
    mwSignedIndex  kk = k;
    dgemm(&atrans, &btrans, 
        &mm, &nn, &kk, 
        &alpha, 
        A, &kk, 
        B, &kk, 
        &beta, 
        X, &mm);
}





/********************************************
* Debugging functions
*
*********************************************/




/* print contents of matrix */

void print_matrix(const double A[], int n, int m, char* matrix_name)
{
  int i, j;
  mexPrintf("\n%s = \n\n", matrix_name);

  if (n*m==0) {
    mexPrintf("   Empty matrix: %d-by-%d\n\n", n, m);
    return;
  }

  for (i=0; i<n; ++i) {
    for (j=0; j<m; ++j)
      mexPrintf("   %lf", A[j*n+i]);
    mexPrintf("\n");
  }
  mexPrintf("\n");
}

void print_vector(const double v_x[], int n, char* vec_name){
    int i;
    mexPrintf("\n%s = \n\n", vec_name);
    if (n==0) {
        mexPrintf("   Empty vector");
        return;
    }
    for (i=0; i<n; ++i) {
        mexPrintf("   %lf", v_x[i]);
    }
    mexPrintf("\n");
}

/* print contents of sparse vector */

void print_sparse_vector(const mxArray *A, char* vector_name)
{
  mwIndex *aJc = mxGetJc(A);
  mwIndex *aIr = mxGetIr(A);
  double *aPr = mxGetPr(A);

  int i;

  mexPrintf("\n%s = \n\n", vector_name);
  // aJc[1] is the number of non-zero entries in sparse vector
  for (i=0; i<aJc[1]; ++i){
    printf("   (%d,1) = %lf\n", aIr[i]+1,aPr[i]);
  }
  mexPrintf("\n");
}

