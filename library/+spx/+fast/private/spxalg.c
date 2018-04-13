#include "spxalg.h"

#define  MAX_LEVELS  300

/**
*
*
*  The quick sort implementations are derived from
*  public-domain C implementation by Darel Rex Finley.
*
*/

void quicksort_indices(mwIndex indices[], double data[], mwIndex n) {

  long piv, beg[MAX_LEVELS], end[MAX_LEVELS], i = 0, L, R, swap ;
  double datapiv;

  beg[0] = 0;
  end[0] = n;

  while (i >= 0) {

    L = beg[i];
    R = end[i] - 1;

    if (L < R) {

      piv = indices[L];
      datapiv = data[L];

      while (L < R)
      {
        while (indices[R] >= piv && L < R)
          R--;
        if (L < R) {
          indices[L] = indices[R];
          data[L++] = data[R];
        }

        while (indices[L] <= piv && L < R)
          L++;
        if (L < R) {
          indices[R] = indices[L];
          data[R--] = data[L];
        }
      }

      indices[L] = piv;
      data[L] = datapiv;

      beg[i + 1] = L + 1;
      end[i + 1] = end[i];
      end[i++] = L;

      if (end[i] - beg[i] > end[i - 1] - beg[i - 1]) {
        swap = beg[i]; beg[i] = beg[i - 1]; beg[i - 1] = swap;
        swap = end[i]; end[i] = end[i - 1]; end[i - 1] = swap;
      }
    }
    else {
      i--;
    }
  }
}

static __inline__ 
int insertion_sort_values_desc(double values[], mwIndex indices[], int n) {
  int i, j;
  for (i = 1; i < n; ++i) {
    double tmp = values[i];
    double index = indices[i];
    for (j = i; j >= 1 && tmp > values[j - 1]; --j){
      values[j] = values[j - 1];
      indices[j] = indices[j-1];
    }
    values[j] = tmp;
    indices[j] = index;
  }
}

void quicksort_values_desc(double values[], mwIndex indices[], mwIndex n) {

  // pivot element
  double  pivot;
  mwIndex pivot_index;
  // List of partitions
  long beg[MAX_LEVELS], end[MAX_LEVELS];
  // Partition counter
  int i = 0;
  // Boundaries of a partition
  long L, R , M;
  long partition_length;
  long swap;

  beg[0] = 0; end[0] = n;
  while (i >= 0) {
    // Set L and R to the span of the partition.
    L = beg[i];
    R = end[i] - 1;
    partition_length = R - L + 1;
    if (partition_length < 50){
      // We fall back to insertion sort for small arrays
      insertion_sort_values_desc(values + L, indices + L, partition_length);
      // go to previous partition.
      --i;
      continue;
    }


    //mexPrintf("1: i: %d, L:%d, R:%d\n", i, L, R);

    if (L < R) {
      M = (L + R) / 2;
      // Choose the middle element as pivot.
      pivot = values[M];
      pivot_index = indices[M];
      // Swap the pivot with the middle element
      values[M] = values[L];
      indices[M] = indices[L];
      values[L] = pivot;
      indices[L] = pivot_index;

      while (L < R) {
        // Skip elements from the right till we find an element greater than pivot
        while (values[R] <= pivot && L < R) {
          --R;
        }
        //mexPrintf("2: L:%d, R:%d\n", L, R);
        if (L < R) {
          // Copy that element into left end of partition
          values[L] = values[R];
          indices[L] = indices[R];
          // Move the left end of partition
          ++L;
        }
        //mexPrintf("3: L:%d, R:%d\n", L, R);
        // Skip all elements from left till we find an element smaller than pivot
        while (values[L] >= pivot && L < R) {
          L++;
        }
        //mexPrintf("4: L:%d, R:%d\n", L, R);
        if (L < R) {
          // Copy this element to right end of partition
          values[R] = values[L];
          indices[R] = indices[L];
          // Move the right end of partition
          --R;
        }
        //mexPrintf("5: L:%d, R:%d\n", L, R);
      }
      // Copy pivot to L
      values[L] = pivot;
      indices[L] = pivot_index;
      // Add a new partition
      beg[i + 1] = L + 1;
      end[i + 1] = end[i];
      end[i] = L;
      ++i;
      // Compare the last two partitions
      // Do the smaller partition first
      if (end[i] - beg[i] > end[i - 1] - beg[i - 1]) {
        swap = beg[i]; beg[i] = beg[i - 1]; beg[i - 1] = swap;
        swap = end[i]; end[i] = end[i - 1]; end[i - 1] = swap;
      }
    }
    else {
      --i;
    }
  }
  return;
}


void quickselect_desc(double values[], mwIndex indices[], 
    mwIndex n,
    mwIndex k){
  // pivot element
  double  pivot;
  mwIndex pivot_index;
  // Boundaries of a partition
  long begin, end;
  long L, R , M;
  long partition_length;
  long swap;
  long i;

  begin  = 0; 
  end = n - 1;
  for (i = 0; ; ++i) {
    L = begin;
    R = end;
    partition_length = R - L + 1;
    //mexPrintf("1: i: %d, L:%d, R:%d\n", i, L, R);
    M = (L + R) / 2;
    // Choose the middle element as pivot.
    pivot = values[M];
    pivot_index = indices[M];
    // Swap the pivot with the middle element
    values[M] = values[L];
    indices[M] = indices[L];
    values[L] = pivot;
    indices[L] = pivot_index;

    while (L < R) {
      // Skip elements from the right till we find an element greater than pivot
      while (values[R] <= pivot && L < R) {
        --R;
      }
      //mexPrintf("2: L:%d, R:%d\n", L, R);
      if (L < R) {
        // Copy that element into left end of partition
        values[L] = values[R];
        indices[L] = indices[R];
        // Move the left end of partition
        ++L;
      }
      //mexPrintf("3: L:%d, R:%d\n", L, R);
      // Skip all elements from left till we find an element smaller than pivot
      while (values[L] >= pivot && L < R) {
        L++;
      }
      //mexPrintf("4: L:%d, R:%d\n", L, R);
      if (L < R) {
        // Copy this element to right end of partition
        values[R] = values[L];
        indices[R] = indices[L];
        // Move the right end of partition
        --R;
      }
      //mexPrintf("5: L:%d, R:%d\n", L, R);
    }
    // Copy pivot to L
    values[L] = pivot;
    indices[L] = pivot_index;
    if (L+1 == k){
      // We have found the k-th element
      return;
    }
    if (L >= k){
      end = L-1;
    }
    else{
      begin = L+1;
    }
  }
  return;
}
