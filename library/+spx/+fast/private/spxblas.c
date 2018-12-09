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
#define dgels dgels_
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

mwIndex abs_max_index_2(const double x[], mwSize n){
    mwIndex maxid=0, k;
    double val, maxval = SQR(*x);

    for (k=1; k<n; ++k) {
        val = SQR(x[k]);
        if (val > maxval) {
            maxval = val;
            maxid = k;
        }
    }
    return maxid;    
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

void vec_elt_wise_sqrt(const double x[], double y[], mwSize n){
    int i;
    for(i=0;i<n;++i){
        y[i] = sqrt(x[i]);
    }
}

void vec_elt_wise_inv(const double x[], double y[], mwSize n){
    int i;
    for(i=0;i<n;++i){
        double value = x[i];
        if (value) {
            y[i] =  1/value;    
        } else{
            y[i] = 0;
        }
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


void mat_col_extract(const double A[], 
    const mwIndex indices[], double B[], mwSize m, mwSize k){
    mwIndex i;
    mwIndex index;
    mwSignedIndex  inc = 1;
    mwSignedIndex mm = m; 
    const double* a;
    double* b;
    for (i=0; i<k; ++i){
        index = indices[i];
        a = A + index*m;
        b = B + i*m;
        dcopy(&mm, a, &inc, b, &inc);
    }
}

void mat_row_extract(const double A[], 
    const mwIndex indices[], double B[], mwSize m, mwSize n, mwSize k){
    mwIndex i;
    mwIndex index;
    mwSignedIndex  inc_a = m;
    mwSignedIndex  inc_b = k;
    mwSignedIndex nn = n; 
    const double* a;
    double* b;
    for (i=0; i<k; ++i){
        index = indices[i];
        a = A + index;
        b = B + i;
        dcopy(&nn, a, &inc_a, b, &inc_b);
    }
}


void mat_col_asum(const double A[], double v[], mwSize m, mwSize n){
    const double* a = A;
    mwSignedIndex  inc = 1;
    mwSignedIndex  mm = m;
    for (int c=0; c < n; ++c){
        v[c] = dasum(&mm, a, &inc);
        a += m; 
    }
}

void mat_row_asum(const double A[], double v[], mwSize m, mwSize n){
    const double* a = A;
    mwSignedIndex  inc = m;
    mwSignedIndex nn = n;
    for (int c=0; c < m; ++c){
        v[c] = dasum(&nn, a, &inc);
        a += 1;
    }
}

void mat_element_wise_sqr(double A[], mwSize m, mwSize n){
    mwSize l = m*n;
    for(mwSignedIndex i=0; i < l; ++i){
        A[i] = SQR(A[i]);
    }
}

void mat_col_sum_sqr(const double A[], double v[], mwSize m, mwSize n){
    const double* a = A;
    mwSignedIndex  inc = 1;
    mwSignedIndex  mm = m;
    for (int c=0; c < n; ++c){
        double sum = 0;
        for (int r=0; r < m; ++r){
            sum += SQR(a[r]);
        }
        v[c] = sum;
        a += m; 
    }
}

void mat_col_norms(const double A[], double v[], mwSize m, mwSize n){
    mat_col_sum_sqr(A, v, m, n);
    vec_elt_wise_sqrt(v, v, n);
}

void mat_col_scale(double A[], const double v[], mwSize m, mwSize n){
    double* a = A;
    mwSignedIndex  inc = 1;
    mwSignedIndex  mm = m;
    for (int c=0; c < n; ++c){
        dscal(&mm, v + c, a, &inc);
        a += m;
    }
}

void mat_row_scale(double A[], const double v[], mwSize m, mwSize n){
    double* a = A;
    mwSignedIndex  inc = m;
    mwSignedIndex nn = n;
    for (int r=0; r < m; ++r){
        dscal(&nn, v + r, a, &inc);
        a += 1;
    }
}

void mat_col_normalize(double A[], mwSize m, mwSize n){
    double *v;
    v = (double *) mxMalloc(n*sizeof(double));
    // Compute the norms
    mat_col_norms(A, v, m, n);
    // Inverse the norms
    vec_elt_wise_inv(v, v, n);
    // Scale by norms
    mat_col_scale(A, v, m, n);
    mxFree(v);
}

/********************************************
* Vector vector operations
*
*********************************************/

void v_subtract(const double x[], 
    const double y[], double z[], mwSize n){
    for (int i=0; i < n; ++i){
        z[i] = x[i] - y[i];
    }
}

void v_square(const double x[], 
    double y[], mwSize n){
    for (int i=0; i < n; ++i){
        y[i] = SQR(x[i]);
    }
}


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
    return ddot(&nn, a, &inc, b, &inc);
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

void mult_submat_vec(double alpha, 
    const double A[], 
    const mwSize indices[], 
    const double x[],
    double y[], mwSize m, mwSize k){
    mwIndex i, j, c;
    /**
    Initialize result to 0
    */
    for (i=0; i<m; ++i) {
        y[i] = 0;
    }    
    for (j=0; j<k; ++j) {
        /**
        y += alpha* x(j) *A(:,  index[j])
        */
        c = indices[j];
        sum_vec_vec(alpha * x[j], A + c*m, y, m);
    }
}

void mult_submat_t_vec(double alpha, 
    const double A[], 
    const mwSize indices[], 
    const double x[],
    double y[], mwSize m, mwSize k){

    mwSignedIndex  mm = m;
    mwSignedIndex  inc = 1; 
    mwSize index;
    const double *v_col;
    for (int i=0; i<k; ++i){
        index = indices[i];
        v_col = A + m*index;
        y[i] = ddot(&mm, v_col, &inc, x, &inc);
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

void lt_back_substitution_col(const double L[], 
    double b[], 
    double x[], 
    mwSize m, mwSize k)
{
    mwIndex i, j;
    double rhs;
    mwSignedIndex  nn;
    mwSignedIndex  incx = 1; 
    double alpha;
    /** Iterate over columns */
    for(i=0; i < k; ++i){
        x[i] = b[i] / L[i*m+i];
        nn = k - i - 1;
        if (nn > 0){
            alpha = -x[i];
            daxpy(&nn, &alpha, &(L[i*m+i +1]), &incx, &(b[i + 1]), &incx);   
        }
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
    tmp = (double *) mxMalloc(k*sizeof(double));
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

void spd_chol_lt_solve2(const double L[], 
    double b[], 
    double x[], 
    double tmp[],
    mwSize m, mwSize k){
    /**
    Solve the problem L t = b
    */
    lt_back_substitution(L, b, tmp, m, k);
    /**
    Solve the problem L' x = t
    */
    lt_t_back_substitution(L, tmp, x, m, k);
}

void spd_lt_trtrs(const double L[],
    double b[],
    mwSize m, mwSize k){
    char uplo = 'L';
    char trans = 'N';
    char diag  = 'N';
    mwSignedIndex  n = k;
    mwSignedIndex nrhs = 1;
    mwSignedIndex lda = m;
    mwSignedIndex ldb = k;
    mwSignedIndex info = 0;
    /**
    Solve the problem L t = b
    */
    dtrtrs(&uplo, &trans, &diag, &n, &nrhs, L, &lda, b, &ldb, &info);
    /**
    Solve the problem L' x = t
    */
    trans = 'T';
    dtrtrs(&uplo, &trans, &diag, &n, &nrhs, L, &lda, b, &ldb, &info);
}

void spd_lt_trtrs_multi(const double L[],
    double B[],
    mwSize m, mwSize k, mwSize s){
    char uplo = 'L';
    char trans = 'N';
    char diag  = 'N';
    mwSignedIndex  n = k;
    mwSignedIndex nrhs = s;
    mwSignedIndex lda = m;
    mwSignedIndex ldb = k;
    mwSignedIndex info = 0;
    /**
    Solve the problem L t = b
    */
    dtrtrs(&uplo, &trans, &diag, &n, &nrhs, L, &lda, B, &ldb, &info);
    /**
    Solve the problem L' x = t
    */
    trans = 'T';
    dtrtrs(&uplo, &trans, &diag, &n, &nrhs, L, &lda, B, &ldb, &info);
}


mwSignedIndex ls_qr_solve(double A[],
    double b[],
    mwSize m, mwSize n) {

    mwSignedIndex mm = m;
    mwSignedIndex nn  = n;

    mwSignedIndex lda = m;
    mwSignedIndex ldb = m;
    mwSignedIndex nrhs = 1;
    mwSignedIndex info = 0;    
    char trans = 'N';
    double wkopt;
    double* work = 0;
    mwSignedIndex lwork;

    /* Query and allocate the optimal workspace */
    lwork = -1;
    dgels(&trans, &mm, &nn, &nrhs, A, &lda, b, &ldb, &wkopt, &lwork, &info);
    lwork = (mwSignedIndex) wkopt;
    work = (double *) mxMalloc(lwork*sizeof(double));
    // Solve the linear equation
    dgels(&trans, &mm, &nn, &nrhs, A, &lda, b, &ldb, work, &lwork, &info);
    // Free the workspace
    mxFree(work);
    return info;
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

void print_index_vector(const mwIndex v_x[], int n, char* vec_name){
    int i;
    mexPrintf("\n%s = \n\n", vec_name);
    if (n==0) {
        mexPrintf("   Empty vector");
        return;
    }
    for (i=0; i<n; ++i) {
        mexPrintf("   %d", v_x[i]);
    }
    mexPrintf("\n");
}

void print_index_vector_plus1(const mwIndex v_x[], int n, char* vec_name){
    int i;
    mexPrintf("\n%s = \n\n", vec_name);
    if (n==0) {
        mexPrintf("   Empty vector");
        return;
    }
    for (i=0; i<n; ++i) {
        mexPrintf("   %d", v_x[i] + 1);
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

