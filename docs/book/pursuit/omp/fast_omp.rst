.. _sec:pursuit:omp:fast:

Fast Implementation of OMP
================================

As part of `sparse-plex`_,
we provide a fast CPU based implementation of OMP.
It is up to 4 times faster than the OMP implementation
in `OMPBOX`_.

This is written in C and uses the
BLAS and LAPACK features available in MATLAB.
The implementation is available in the function
`spx.fast.omp`_.  
The corresponding C code is in `omp.c`_. 


For a :math:`100 \times 1000`
sensing matrix, the implementation can recover
sparse representations for each signal in few
hundred microseconds (depending upon the number
of non-zero coefficients in the sparse representation
and hence the sparsity level) on an Intel i7 2.4 GHz laptop
with 16 GB RAM.


Read :ref:`sec:start:extensions` for how to build
the mex files for fast OMP implementation.


A Simple Example
------------------

Let's create a Gaussian sensing matrix::


    M = 100;
    N = 1000;
    A = spx.dict.simple.gaussian_mtx(M, N);

See :ref:`cs-hands-on-gaussian-sensing-matrices` for details.

Let's create a 1000 sparse signals with sparsity 7::

    S = 1000;
    K = 7;
    gen = spx.data.synthetic.SparseSignalGenerator(N, K, S);
    X =  gen.biGaussian();

See :ref:`sec:pursuit:testing:synthetic-sparse-representations` 
for details.

Let's compute their measurements using the Gaussian matrix::


    Y = A*X;

Let's recover the representations from the measurements::

    start_time = tic;
    result = spx.fast.omp(A, Y, K, 1e-12);
    elapsed_time = toc(start_time);
    fprintf('Time taken: %.2f seconds\n', elapsed_time);
    fprintf('Per signal time: %.2f usec', elapsed_time * 1e6/ S);

    Time taken: 0.17 seconds
    Per signal time: 169.56 usec

See :ref:`sec:pursuit:omp:algorithm` for a review of OMP
algorithm.

We are taking just 169 micro seconds per signal.

Let's verify that all the signals have been recovered correctly::

    cmpare = spx.commons.SparseSignalsComparison(X, result, K);
    cmpare.summarize();

    Signal dimension: 1000
    Number of signals: 1000
    Combined reference norm: 159.67639347
    Combined estimate norm: 159.67639347
    Combined difference norm: 0.00000000
    Combined SNR: 307.9221 dB

All signals have indeed been recovered correctly.
See :ref:`sec:library-commons-comparison-sparse` for 
details about ``SparseSignalsComparison``.

Example code can be downloaded
:download:`here <demo_fast_omp.m>`.


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

The method for benchmarking has been adopted from 
the file ``ompspeedtest.m`` in the `OMPBOX`_ 
package by Ron Rubinstein.

We compare following algorithms:

* The Cholesky decomposition based OMP implementation
  in OMPBOX.
* Our C version in `sparse-plex`_.

The work load consists of a Gaussian dictionary of
size :math:`512 \times 1000`.  Sufficient signals
are chosen so that the benchmarks can run reasonable duration.
8 sparse representations are constructed for each 
randomly generated signal in the given dictionary.

::

    Speed summary for 6917 signals, dictionary size 512 x 1000:
    Call syntax        Algorithm               Total time
    --------------------------------------------------------
    OMP(D,X,[],T)                    OMP-Cholesky            16.65 seconds
    SPX-OMP(D, X, T)                 SPX-OMP-Cholesky         4.29 seconds


Our implementation is close to 4 times faster.

The benchmark generation code is in `ex_fast_omp_speed_test.m`_.

.. _sparse-plex: https://github.com/indigits/sparse-plex

.. _omp.c: https://github.com/indigits/sparse-plex/blob/master/library/%2Bspx/%2Bfast/private/omp.c

.. _spx.fast.omp: https://github.com/indigits/sparse-plex/blob/master/library/%2Bspx/%2Bfast/omp.m


.. _OMPBOX: http://www.cs.technion.ac.il/~ronrubin/software.html

.. _ex_fast_omp_speed_test.m: https://github.com/indigits/sparse-plex/blob/master/experiments/fast_omp_chol/ex_fast_omp_speed_test.m