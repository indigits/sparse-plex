// AUTHOR:  Christian James Walder

#include "mex.h"
#include "matrix.h"
#include <string>

using namespace std;

#define MALLOC malloc
#define FREE free
//#define PRINTF printf
#define PRINTF mexPrintf

int *sort_data;

class MySparse{
    public:
    double *pr;
    int *jc, *ir, m, n, nzmax;
    MySparse(int the_m, int the_n, int the_nzmax);
    ~MySparse();
    mxArray *convertToMatlab();
    bool resize(int new_size);
    void print();
};

MySparse::MySparse(int the_m, int the_n, int the_nzmax) {
    m = the_m; 
    n = the_n; 
    nzmax = the_nzmax;
    pr = (double *) MALLOC(nzmax*sizeof(double));
    ir = (int *) MALLOC(nzmax*sizeof(int));
    jc = (int *) MALLOC((n+1)*sizeof(int));
    for (int j = 0; j <= n; j++) {
        jc[j] = 0;
    }
};

MySparse::~MySparse() {
    FREE(pr); FREE(jc); FREE(ir);
};


bool MySparse::resize(int new_size) {
    if (new_size > (nzmax-1)) {
        int newnzmax = 2*new_size;
        double *oldpr = pr;
        pr = (double *) MALLOC(newnzmax*sizeof(double));
        memcpy(pr,oldpr,nzmax*sizeof(double));
        FREE(oldpr);
        int *oldir = ir;
        ir = (int *) MALLOC(newnzmax*sizeof(int));
        memcpy(ir,oldir,nzmax*sizeof(int));
        FREE(oldir);
        nzmax = newnzmax;
        return true;
    } 
    return false;
};

mxArray *MySparse::convertToMatlab() {
    mxArray *rval =  mxCreateSparse(m, n, jc[n], mxREAL);
    memcpy(mxGetPr(rval),pr,jc[n]*sizeof(double));
    memcpy(mxGetIr(rval),ir,jc[n]*sizeof(int));
    memcpy(mxGetJc(rval),jc,(n+1)*sizeof(int));
    return rval;
};

int mycompare(const void * a, const void * b) {
    return (int) (*(sort_data+ *((unsigned int *)a)) - *(sort_data+ *((unsigned int *)b)));
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray*prhs[]) { 
    double *a, *b, *c_copy, scal;
    mxArray *A, *B, *C;
    int *ia, *ja, *ib, *jb, *ic_copy;
    int nzmax, nrow, ncol, len, ii, jj, ka, kb, icol, ipos, k, *jw, sort_size, max_sort_size, i;
    unsigned int *sorti;    
    
    if ((nrhs < 2)|(nlhs!=1)) {
        PRINTF("mex_amub.cpp: bad args\nusage: mex_mymult (sparse matrix multiplication) usage: real(A) * real(B) = mex_amub(A,B,nnz);\n");
        return;
    }
    
    if (!mxIsSparse(prhs[0]) | !mxIsSparse(prhs[1])) {
        PRINTF("mex_amub.cpp: A and B must be sparse, returning");
        return;
    }
    
    A = (mxArray *) prhs[0];
    B = (mxArray *) prhs[1];
    nzmax = 10;
    if (nrhs == 3) {
        nzmax = ((int) *mxGetPr(prhs[2])+10) > nzmax ? ((int) *mxGetPr(prhs[2])+10) : nzmax;
    }
    nrow = mxGetM(A);
    ncol = mxGetN(B);
    
    if (mxGetN(A)!=mxGetM(B)) {
        PRINTF("mex_amub.cpp: size(A,2) ~= size(B,1), returning\n");
        return;
    }

    MySparse *AB = new MySparse(nrow,ncol,nzmax);

    ja = mxGetJc(A);
    ia = mxGetIr(A);
    a = mxGetPr(A);

    jb = mxGetJc(B);
    ib = mxGetIr(B);
    b = mxGetPr(B);
    
    len = 0;
    AB->jc[0] = 0;
    jw = (int *) MALLOC(nrow * sizeof(int));
    max_sort_size = 0;
    for (jj = 0; jj < nrow; jj++) {
        jw[jj] = -1;
    }
    for (jj = 0; jj < ncol; jj++) {
        for (kb = jb[jj]; kb < jb[jj+1]; kb++) {
            scal = b[kb];
            ii = ib[kb];
            for (ka = ja[ii]; ka < ja[ii+1]; ka++) {
                icol = ia[ka];
                ipos = jw[icol];
                if (ipos == -1) {
                    AB->resize(len+1);
                    AB->ir[len] = icol;
                    jw[icol] = len;
                    AB->pr[len] = scal * a[ka];
                    len++;
                } else {
                    AB->pr[ipos] += scal * a[ka];
                }
            }
        }
        for (k = AB->jc[jj]; k < len; k++) {
            jw[AB->ir[k]] = -1;
        }
        AB->jc[jj+1] = len;

        sort_size = AB->jc[jj+1]-AB->jc[jj];
        if (sort_size > 1) {
            if (sort_size > max_sort_size) {
                if (max_sort_size > 0) {
                    FREE(sorti);
                    FREE(ic_copy);
                    FREE(c_copy);
                }
                max_sort_size = sort_size * 2;
                sorti = (unsigned int *) MALLOC(max_sort_size*sizeof(unsigned int));
                ic_copy = (int *) MALLOC(max_sort_size*sizeof(int));
                c_copy = (double *) MALLOC(max_sort_size*sizeof(double));
            }
            for (k = 0; k < sort_size; k++) {
                sorti[k] = k;
                ic_copy[k] = AB->ir[AB->jc[jj]+k];
                c_copy[k] = AB->pr[AB->jc[jj]+k];
            }
            sort_data = AB->ir + AB->jc[jj];
            qsort(sorti, sort_size, sizeof(int), mycompare);
            for (k = 0; k < sort_size; k++) {
                AB->ir[k+AB->jc[jj]] = ic_copy[sorti[k]];
                AB->pr[k+AB->jc[jj]] = c_copy[sorti[k]];
            }
        }
    }
    
    plhs[0] = AB->convertToMatlab();
    delete AB;
    
    FREE(jw);
    if (max_sort_size > 0) {
        FREE(sorti);
        FREE(ic_copy);
        FREE(c_copy);
    }
    
	return;
}
