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


/**
A wrapper class for representing vectors
*/
class Vec {
public:
  //! Constructor
  Vec(double* pVec, mwSize n, mwSignedIndex  inc = 1);
  //! Constructor from vector
  Vec(d_vector& vec);
  //! Constructor from mxArray
  Vec(const mxArray* vec);
  //! Destructor
  ~Vec();
public:
  //! Returns the length of the vector
  inline mwSize length() const {
    return m_n;
  }
  //! Returns the step size between elements of vector
  mwIndex inc() const {
    return m_inc;
  }
  //! Returns the head of the vector
  inline const double* head() const {
    return m_pVec;
  }
  //! Returns the head of the vector [for modification]
  inline double* head() {
    return m_pVec;
  }
  //! Return a value
  inline double operator[](mwIndex index) const {
    return m_pVec[index * m_inc];
  }
  //! Return a reference to a value
  inline double& operator[](mwIndex index) {
    return m_pVec[index * m_inc];
  }
  //! Returns the index of largest entry by magnitude in the vector
  mwIndex abx_max_index() const;
  //! Return the index of largest entry in the vector
  mwIndex max_index() const;
  //! Return the value and index of largest entry in the vector
  void max_index(double& value, mwIndex& index) const;
  //! Extract a subset of values from the vector
  void extract(const mwIndex indices[], Vec& out, mwSize k=0) const;
  //! Set all values in the vector to a fixed value
  Vec& operator=(const double& value);
  //! Copy assignment operator
  Vec& operator = (const Vec &o);
  //! Square all entries in the vector
  void elt_wise_square();
  //! Square all the entries element wise and write in another vector
  void elt_wise_square(Vec& out) const;
  //! Invert all entries in the vector
  void elt_wise_inv();
  //! Return the squared norm of the vector
  double norm_squared() const;
  //! Return the norm of the vector
  inline double norm() const {
    return sqrt(norm_squared());
  }
  //! add another vector into this vector
  void add(const Vec& o, double alpha=1);
  //! subtract another vector
  void subtract(const Vec& o);
  //! element wise multiply
  void multiply(const Vec& o);
  //! Inner product with another vector
  double inner_product(const Vec& o) const;
  //! print the contents of the vector
  void print(const std::string& name = "") const;
private:
  // //! Disable copy constructor
  // Vec(const Vec &t);
private:
  //! Reference to the beginning of vector
  double* m_pVec;
  //! Number of elements in vector
  mwSize m_n;
  //! Step size between vector elements
  mwIndex m_inc;
};


}

#endif // _SPX_VECTOR_H_
