#ifndef _SPX_VECTOR_H_
#define _SPX_VECTOR_H_ 1

#include <vector>
#include <string>
#include <algorithm>
#include <iostream>
#include <numeric>
#include <mex.h>

namespace spx {

//! A vector of double values
typedef std::vector<double> d_vector;
//! A vector of integer values
typedef std::vector<int> i_vector;
//! A vector of unsigned integer values
typedef std::vector<size_t> index_vector;
//! A vector of boolean values
typedef std::vector<bool> b_vector;

//! Square all elements of a vector in place
void square_inplace(d_vector& v);
void square(const d_vector& src, d_vector& dst);

//! Converts a double vector to an MX Array
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
  //! Constructor for a self owned vector
  Vec(mwSize n);
  //! Constructor from external data
  Vec(double* pVec, mwSize n, mwSignedIndex  inc = 1);
  //! Constructor from vector
  Vec(d_vector& vec);
  //! Constructor from mxArray
  Vec(const mxArray* vec);
  //! Destructor
  ~Vec();
public:
/*****************************************************************************
 *  Basic setters and getters
 *****************************************************************************/
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

 /*****************************************************************************
 *  Extraction operations
 *****************************************************************************/

  //! Extract a subset of values from the vector
  void extract(const mwIndex indices[], Vec& out, mwSize k=0) const;
  //! Square all the entries element wise and write in another vector
  void square(Vec& out) const;


 /*****************************************************************************
 *  Assignment and self manipulation operations. Can be chained.
 *****************************************************************************/
  //! Set all values in the vector to a fixed value
  Vec& operator=(const double& value);
  //! Copy assignment operator
  Vec& operator = (const Vec &o);
  //! Set a value to a subset of indices
  void set(const index_vector& indices, const double& value);
  //! Square all entries in the vector
  Vec& square();
  //! Compute square root of all entries in the vector (in place)
  Vec& sqrt();
  //! Invert all entries in the vector
  Vec& inv();
  //! Compute absolute value of all entries in the vector
  Vec& abs();
  //! Scale each value by a factor
  Vec& scale(double value);
 /*****************************************************************************
 *  Summaries, statistics
 *****************************************************************************/
  //! Returns the absolute maximum of a range of values
  double abs_max(mwSignedIndex start = 0, mwSignedIndex end = -1) const;
  //! Returns the index of largest entry by magnitude in the vector
  mwIndex abs_max_index() const;
  //! Return the index of largest entry in the vector
  mwIndex max_index() const;
  //! Return the value and index of largest entry in the vector
  void max_index(double& value, mwIndex& index) const;
  //! Return the squared norm of the vector
  double norm_squared() const;
  //! Return the norm of the vector
  inline double norm() const {
    return ::sqrt(norm_squared());
  }
 /*****************************************************************************
 *  Vector - Vector operations
 *****************************************************************************/
  //! add another vector into this vector
  void add(const Vec& o, double alpha=1);
  //! subtract another vector
  void subtract(const Vec& o);
  //! element wise multiply
  void multiply(const Vec& o);
  //! element wise divide
  void divide(const Vec& o);
  //! Inner product with another vector
  double inner_product(const Vec& o) const;
  //! Swap the contents of this vector with another
  void swap(const Vec& o);
 /*****************************************************************************
 *  Debugging support
 *****************************************************************************/
  //! print the contents of the vector
  void print(const std::string& name = "", mwSignedIndex end = -1, bool scientific = false) const;
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
  //! Indicates if the contents are owned
  bool m_bOwned;
};


template<typename T>
T square(const T& value){
  return value*value;
}

template <typename T> int sgn(T val) {
    return (T(0) < val) - (val < T(0));
}

/**
Computes sqrt(a^2 + b^2) but is careful to avoid overflow.
*/
template<typename T>
T pythag(T a, T b){
  // signs of a and b
  int sa = sgn(a);
  int sb = sgn(b);
  // Find the absolute max value between a and b
  T rmax = std::max(sa*a, sb*b);
  if (rmax == T(0)){
    return rmax;
  }
  // Bring both a and b to be below 1.
  a = a/rmax;
  b = b/rmax;
  // compute the hypotenuse and scale it back
  return rmax*sqrt(a*a + b*b);
}

//! Converts a vector of boolean flags to indices
void flags_to_indices(const b_vector& flags, index_vector& indices, int n = -1);

//! Converts a vector of indices to boolean flags
void indices_to_flags(const index_vector& indices, b_vector& flags);


}

#endif // _SPX_VECTOR_H_
