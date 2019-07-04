#include "argcheck.h"
#include "spx_matarr.hpp"
#include "spxblas.h"

namespace spx {

/************************************************
 *  Utility functions for MATLAB structures
 ************************************************/

mxArray* create_struct(const std::vector<std::string> &v){
    int nfields = v.size();
    const char **fieldnames;
    fieldnames = (const char **) mxCalloc(nfields, sizeof(*fieldnames));
    for (int i=0; i < nfields; ++i){
        fieldnames[i] = v[i].c_str();
    }
    mxArray* result = mxCreateStructMatrix(1,1,nfields,fieldnames);
    mxFree(fieldnames);
    return result;
}

void extract_int_field_from_struct(const mxArray *arg, 
    const char *function_name, const char *arg_name, const char* field_name, int& output){
      mxArray* field = mxGetField(arg, 0, field_name);
      if (field != NULL) {
          check_is_double_scalar(field, function_name, arg_name);
          output = (int) mxGetScalar(field);
      }
}
void extract_double_field_from_struct(const mxArray *arg, 
    const char *function_name, const char *arg_name, const char* field_name, double& output){
      mxArray* field = mxGetField(arg, 0, field_name);
      if (field != NULL) {
          check_is_double_scalar(field, function_name, arg_name);
          output = mxGetScalar(field);
      }
}


void extract_double_vec_field_from_struct(const mxArray *arg, 
    const char *function_name, const char *arg_name, const char* field_name, mxArray** output){
        mxArray* field = mxGetField(arg, 0, field_name);
        if (field != NULL) {
          check_is_double_vector(field, function_name, arg_name);
          *output = field;
        }
}

void set_struct_int_field(mxArray* s, int field_num, int value) {
    mxArray *field = mxCreateNumericMatrix(1, 1, mxINT32_CLASS, mxREAL);
    int32_T* pData  = (int32_T*) mxGetData(field);
    *pData = (int32_T) value;
    mxSetFieldByNumber(s,0,field_num, field);
}

void set_struct_bool_field(mxArray* s, int field_num, bool value) {
    mxArray *field = mxCreateNumericMatrix(1, 1, mxINT8_CLASS, mxREAL);
    int8_T* pData  = (int8_T*) mxGetData(field);
    *pData = (int8_T) value;
    mxSetFieldByNumber(s,0,field_num, field);
}

void set_struct_double_field(mxArray* s, int field_num, double value) {
    mxArray *field = mxCreateNumericMatrix(1, 1, mxDOUBLE_CLASS, mxREAL);
    double* pData  = (double*) mxGetData(field);
    *pData = (int8_T) value;
    mxSetFieldByNumber(s,0,field_num, field);
}

void set_struct_string_field(mxArray* s, int field_num, const std::string& value){
    mxArray *field = mxCreateString(value.c_str());
    mxSetFieldByNumber(s,0,field_num, field);
}

void set_struct_d_vec_field(mxArray* s, int field_num, const d_vector& value){
    mwSize N = value.size();
    mxArray* field = mxCreateDoubleMatrix(N, 1, mxREAL);
    double* m_alpha =  mxGetPr(field);
    copy_vec_vec(&value[0], m_alpha, N);
    mxSetFieldByNumber(s,0,field_num, field);
}

bool has_double_field(mxArray* s, const char* field_name){
    mxArray* field = mxGetField(s, 0, field_name);
    if (0 == field){
        return false;
    }
    if (!mxIsDouble(field) || mxIsComplex(field) 
        || mxGetNumberOfDimensions(field)>2
        || mxGetM(field)!=1 
        || mxGetN(field)!=1) {
            return false;
    }
    return true;
}


/************************************************
 *  Utility functions for MATLAB arrays
 ************************************************/

mxArray* d_vec_to_mx_array(const Vec& x, int n)
{
    mwSize N = x.length();
    if (n >= 0){
        N = n;
    }
    mxArray* p_alpha = mxCreateDoubleMatrix(N, 1, mxREAL);
    double* m_alpha =  mxGetPr(p_alpha);
    copy_vec_vec(x.head(), m_alpha, N);
    return p_alpha;
}

bool resize_fullmat_columns(mxArray *pMatrix, int n){
    if (mxGetN(pMatrix) == n) {
        // Nothing to do
        return true;
    }
    double* pU = mxGetPr(pMatrix);
    int m = mxGetM(pMatrix);
    pU = (double*) mxRealloc(pU, m*n*sizeof(double));
    if (pU != 0){
        // Reallocation happened successfully
        mxSetN(pMatrix, n);
        mxSetPr(pMatrix, pU);
        return true;
    }
    // reallocation failed
    return false;
}


bool resize_mat_vec(mxArray *pVector, int n){
    if (mxGetM(pVector) == n) {
        // Nothing to do
        return true;
    }
    double* pU = mxGetPr(pVector);
    pU = (double*) mxRealloc(pU, n*sizeof(double));
    if (pU != 0){
        // Reallocation happened successfully
        mxSetM(pVector, n);
        mxSetPr(pVector, pU);
        return true;
    }
    // reallocation failed
    return false;    
}



}