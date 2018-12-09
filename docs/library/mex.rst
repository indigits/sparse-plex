MEX Extensions
=========================

Some parts of the library have been written
in the form of MEX extensions. The mex
extensions have been written in C/C++.
They also use the BLAS/LAPACK libraries
which are shipped with MATLAB.



This page summarizes available functions
and their speed gains.

All of these functions are available in
the package ``spx.fast``.


.. list-table::
    :header-rows: 1

    * - Function
      - Purpose
      - Speedup
    * - mp
      - Standard Matching Pursuit
      - Up to 3.8x faster than greedy_mp in sparsify toolbox.
    * - omp
      - Orthogonal Matching Pursuit
      - Up to 4x faster than OMPBOX
    * - batch_omp
      - Batch version of Orthogonal Matching Pursuits
      - Up to 3x faster than Batch OMP in OMPBox
    * - omp_spr
      - | OMP adapted for constructing subspace
        | preserving representations
      - | The flipped version provided by :cite:`you2015sparse`
        | is usually faster on large datasets.
        | But the simple OMP loop is faster on
        | smaller datasets by 20%.
    * - batch_omp_spr
      - | Computes subspace preserving representations
        | for sparse subspace clustering using Batch
        | version of OMP based on :cite:`rubinstein2008efficient`.
      - | Up to 4.6x faster than OMP for subspace
        | preserving representations by :cite:`you2015sparse`.
    * - cg
      - Conjugate gradients
      - Same as cgsolve.m from Model-CS Toolbox


For more details about these functions,
please refer to the sections in following table:


.. list-table::
    :header-rows: 1

    * - Function
      - Section
    * - mp
      - :ref:`sec:pursuit:greedy:mp:fast`
    * - omp
      - :ref:`sec:pursuit:omp:fast`
    * - batch_omp
      - :ref:`sec:pursuit:batch-omp:fast`
    * - omp_spr
      - :ref:`sec:sc:ssc:omp:implementations` CLASSIC_OMP_C
    * - batch_omp_spr
      - :ref:`sec:sc:ssc:omp:implementations`  BATCH_OMP_C

General Principles
-------------------------

* While the essential structure of algorithms remains
  the same, the C/C++ implementations achieve
  efficiency by working around the natural inefficiencies 
  of MATLAB language.
* Use of BLAS/LAPACK makes sure that we don't suffer 
  a performance loss due to use of naive C/C++ for loops
  for basic matrix algebra. BLAS/LAPACK has state of
  the art implementation of basic matrix algebra
  and MATLAB already uses it. We also use the same
  in our C/C++ implementations.
* We allocate all the necessary memory for an algorithm
  in advance. We make sure that during the execution
  of the algorithm, memory allocations are minimized.
* We avoid data copies as much as possible. In C/C++,
  we have fine grained access of raw matrix/vector 
  data in the form of pointers. 
  We reuse them as much as possible.


Remarks
-----------------

.. rubric:: cg
    
The C++ version of cg was written for internal
use within other algorithms written in C++.
It doesn't give any speed ups since most of
its time is spent in the single matrix vector
multiply operation which is already optimized
in MATLAB.

