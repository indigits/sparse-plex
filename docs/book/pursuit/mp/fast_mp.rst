.. _sec:pursuit:greedy:mp:fast: 

Fast Implementation of Matching Pursuit
===========================================

As part of `sparse-plex`_, 
we provide a fast CPU based implementation of Matching Pursuit.


This is written in C++ and uses the
BLAS and LAPACK features available in 
MATLAB MEX extensions.
The implementation is available in the function
`spx.fast.mp`_.  
The corresponding C code is in `spx_matching_pursuit.cpp`_. 

.. _sparse-plex: https://github.com/indigits/sparse-plex

.. _spx_matching_pursuit.cpp: https://github.com/indigits/sparse-plex/blob/master/library/%2Bspx/%2Bfast/private/spx_matching_pursuit.cpp

.. _spx.fast.mp: https://github.com/indigits/sparse-plex/blob/master/library/%2Bspx/%2Bfast/mp.m


Benchmarks
-------------------------

.. list-table:: System configuration

    * - OS
      - Windows 7 Professional 64 Bit
    * - Processor
      - Intel(R) Core(TM) i7-3630QM CPU @ 2.40GHz
    * - Memory (RAM)
      - 16.0 GB
    * - Hard Disk
      - SATA 120GB
    * - MATLAB
      - R2017b

We compare following algorithms:

* ``greedy_mp.m`` function in `sparsify`_.
* Our C++ version in `sparse-plex`_.

Our implementation is about 3.8 times faster.

The benchmark generation code is in `compare_mp_speeds.m`_.

The work load consists of a Gaussian dictionary of
size :math:`100 \times 1000`.  
1000 signals are constructed so that the benchmarks can run reasonable duration.
8-sparse representations are constructed for each 
randomly generated signal in the given dictionary.

Output of the comparison script::

    Time taken by MATLAB implementation: 3.790
    Time taken by C++ implementation: 0.990
    Gain: 3.83


.. _sparse-plex: https://github.com/indigits/sparse-plex

.. _sparsify: https://www.southampton.ac.uk/engineering/about/staff/tb1m08.page#software

.. _compare_mp_speeds.m: https://github.com/indigits/sparse-plex/blob/master/experiments/pursuit/mp/compare_mp_speeds.m