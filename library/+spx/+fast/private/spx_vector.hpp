#ifndef _SPX_VECTOR_H_
#define _SPX_VECTOR_H_ 1

#include <vector>
#include <string>
#include <algorithm>
#include <iostream>
#include <mex.h>

namespace spx {

//! A vector of double values
typedef std::vector<double> d_vector;
//! A vector of integer values
typedef std::vector<int> i_vector;
typedef std::vector<size_t> index_vector;

//! Square all elements of a vector in place
void square_inplace(d_vector& v);
void square(const d_vector& src, d_vector& dst);

mxArray* d_vec_to_mx_array(const d_vector& x);

void print_d_vec(const d_vector& x, const std::string& name = "");
void print_i_vec(const i_vector& x, const std::string& name = "");
void print_index_vec(const index_vector& x, const std::string& name = "");
void print_sorted_asc_vec(const d_vector &v, const std::string& name = "");

template <typename T>
index_vector sort_asc_indices(const std::vector<T> &v) {

  // initialize original index locations
  index_vector idx(v.size());
  // fill with the values 0,1,2,.. n-1
  std::iota(idx.begin(), idx.end(), 0);

  // sort indexes based on comparing values in v
  std::sort(idx.begin(), idx.end(),
       [&v](size_t i1, size_t i2) {return v[i1] < v[i2];});

  return idx;
}

template <typename T>
index_vector sort_desc_indices(const std::vector<T> &v) {

  // initialize original index locations
  index_vector idx(v.size());
  // fill with the values 0,1,2,.. n-1
  std::iota(idx.begin(), idx.end(), 0);

  // sort indexes based on comparing values in v
  std::sort(idx.begin(), idx.end(),
       [&v](size_t i1, size_t i2) {return v[i1] > v[i2];});

  return idx;
}

template <typename T>
index_vector partial_sort_desc_indices(const std::vector<T> &v, size_t k) {

  // initialize original index locations
  index_vector idx(v.size());
  // fill with the values 0,1,2,.. n-1
  std::iota(idx.begin(), idx.end(), 0);

  // sort indexes based on comparing values in v
  std::partial_sort(idx.begin(), idx.begin() + k, idx.end(),
       [&v](size_t i1, size_t i2) {return v[i1] > v[i2];});

  return idx;
}

template <typename T>
void partial_sort_desc_indices(const std::vector<T> &v, index_vector& idx, size_t k) {
  // sort indexes based on comparing values in v
  std::partial_sort(idx.begin(), idx.begin() + k, idx.end(),
       [&v](size_t i1, size_t i2) {return v[i1] > v[i2];});
  return;
}


}

#endif // _SPX_VECTOR_H_
