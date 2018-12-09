.. _sec:sc:ssc:omp:

SSC by Orthogonal Matching Pursuit
========================================

.. highlight:: matlab

.. contents::
    :local:


.. _sec:sc:ssc:omp:hands-on:

Hands-on with SSC-OMP
-----------------------------

Following :ref:`sec:sc:ssc:bp:hands-on`, 
we setup the test data for this example::

    % Ambient space dimension
    M = 50;
    % Number of subspaces
    K = 10;
    % common dimension for each subspace
    D = 10;

    % Construct bases for random subspaces
    bases = spx.data.synthetic.subspaces.random_subspaces(M, K, D);

    % Number of points on each subspace
    Sk = 4 * D;

    cluster_sizes = Sk * ones(1, K);
    % total number of points
    S = sum(cluster_sizes);

    points_result = spx.data.synthetic.subspaces.uniform_points_on_subspaces(bases, cluster_sizes);
    X0 = points_result.X;

    % noise level
    sigma = 0.5;
    % Generate noise
    Noise = sigma * spx.data.synthetic.uniform(M, S);
    % Add noise to signal
    X = X0 + Noise;
    % Normalize noisy signals.
    X = spx.norm.normalize_l2(X); 
    % labels assigned to the data points
    true_labels = spx.cluster.labels_from_cluster_sizes(cluster_sizes);

We now perform SSC-OMP by using the
``spx.cluster.ssc.SSC_OMP`` class in the
``sparse-plex`` library::

    rng('default');
    tstart = tic;
    fprintf('Performing SSC OMP\n');
    import spx.cluster.ssc.OMP_REPR_METHOD;
    solver = spx.cluster.ssc.SSC_OMP(X, D, K, 1e-3, OMP_REPR_METHOD.FLIPPED_OMP_MATLAB);
    solver.Quiet = true;
    clustering_result = solver.solve();
    elapsed_time = toc (tstart);
    fprintf('Time taken in SSC-OMP %.2f seconds\n', elapsed_time);


Finally we verify the clustering results::

    % Time to compare the clustering
    cluster_labels = clustering_result.labels;
    comparsion_result = spx.cluster.clustering_error_hungarian_mapping(cluster_labels, true_labels, K);
    clustering_error_perc = comparsion_result.error_perc;
    clustering_acc_perc = 100 - comparsion_result.error_perc;

    spr_stats = spx.cluster.subspace.subspace_preservation_stats(clustering_result.Z, cluster_sizes);
    spr_error = spr_stats.spr_error;
    spr_flag = spr_stats.spr_flag;
    spr_perc = spr_stats.spr_perc;
    fprintf('\nclustering error: %0.2f %%, clustering accuracy: %0.2f %% \n'...
        , clustering_error_perc, clustering_acc_perc);
    fprintf('mean spr error: %0.2f, preserving : %0.2f %%\n', spr_stats.spr_error, spr_stats.spr_perc);
    fprintf('elapsed time: %0.2f sec', elapsed_time);
    fprintf('\n\n');


Here is the output::

    Performing SSC OMP
    Time taken in SSC-OMP 0.53 seconds

    clustering error: 4.75 %, clustering accuracy: 95.25 % 
    mean spr error: 0.50, preserving : 0.00 %
    elapsed time: 0.53 sec

.. _sec:sc:ssc:omp:implementations:

SSC-OMP Implementations
---------------------------------

The library provides multiple implementations
of OMP algorithm used in SSC-OMP.

The exact OMP method is chosen by
the method parameter in the constructor
for SSC-OMP object::

    import spx.cluster.ssc.OMP_REPR_METHOD;
    solver = spx.cluster.ssc.SSC_OMP(X, D, K, 1e-3, OMP_REPR_METHOD.FLIPPED_OMP_MATLAB);

Note that every version of OMP has been modified
in a manner that when a representation of
a data vector is constructed from the
data dictionary, then the same data
vector is not used in the representation.

Batch OMP :cite:`rubinstein2008efficient` is 
a well known redesign of OMP algorithm which
is suitable when large number of signals 
are to be sparse coded using the same dictionary.
We have adapted the same idea for sparse coding
step of SSC-OMP also.

The OMP implementation provided by the
authors of :cite:`you2015sparse` flips
the two level loops in OMP based construction
of subspace preserving representations.
If you have S vectors to code in the
data dictionary with K sparse 
representations, the classic OMP way
would go like this::

    % Iterate over data vectors
    for s=1:S
        y = Y[s]
        % Construct sparse representation
        C[s] = OMP (Y, y)
    end

If we expand the inner OMP, into K stages,
it becomes::

    % Iterate over data vectors
    for s=1:S
        y = Y[s]
        % iterate over number of coefficients.
        for k=1:K
            find next atom for representation of y in Y.
        end
    end

The authors in :cite:`you2015sparse` have 
flipped the two loops::

    % iterate over number of coefficients.
    for k=1:K
        % Iterate over data vectors
        for s=1:S
            find next atom for representation of y in Y.
        end
    end

This flipping of loops ends up providing significant
computational gains. Exact details of this flipped
version can be seen in a MATLAB source file 
`here <https://github.com/indigits/sparse-plex/blob/master/library/%2Bspx/%2Bcluster/%2Bssc/flipped_omp.m>`_
which is our own implementation of the code
provided by :cite:`you2015sparse`.


Following OMP options are available in
``SSC_OMP`` class. 

.. list-table::
    :header-rows: 1

    * - Method
      - Description
    * - CLASSIC_OMP_C
      - Standard OMP algorithm written in C. 
    * - BATCH_OMP_C
      - Rewritten in the form of Batch OMP :cite:`rubinstein2008efficient`.
    * - FLIPPED_OMP_MATLAB
      - The OMP implementation on the lines 
        of source code by :cite:`you2015sparse`.

Benchmarks comparing OMP implementations in ``SSC_OMP``
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

The benchmarks in this section have 
been generated by a script
`ex_mnist_speed_test.m <https://github.com/indigits/sparse-plex/blob/master/experiments/ssc_batch_omp/ex_mnist_speed_test.m>`_ on the MNIST dataset. 
For more information about clustering MNIST 
dataset using SSC, please see :ref:`sec:sc:ssc:mnist`.


.. rubric:: Comparing FLIPPED_OMP_MATLAB with BATCH_OMP_C

.. list-table::
    :header-rows: 1

    * - Images Per Digit
      - SSC-OMP (M1)
      - OMP (M1)
      - SSC-OMP (M2)
      - OMP (M2)
      - Gain (SSC)
      - Gain (OMP)
    * - 50
      - 0.54
      - 0.31
      - 0.19
      - 0.07
      - 2.86
      - 4.63
    * - 80
      - 0.61
      - 0.49
      - 0.25
      - 0.13
      - 2.50
      - 3.74
    * - 100
      - 0.76
      - 0.63
      - 0.29
      - 0.16
      - 2.65
      - 3.94
    * - 150
      - 1.23
      - 1.08
      - 0.45
      - 0.30
      - 2.73
      - 3.56
    * - 200
      - 1.87
      - 1.68
      - 0.72
      - 0.53
      - 2.60
      - 3.15

The bench marks are run for various values of number of images per
digit in the test. Multiple trials for each configuration were
conducted and execution times were averaged. Execution times
were captured for two things:

* Time taken by OMP algorithm to construct the sparse representations
  for each data vector in the dataset with the dataset used as dictionary.
* Overall time taken by SSC-OMP algorithm. This includes the time
  taken by spectral clustering as well as the time taken by OMP 
  based sparse representation construction.

Two OMP methods are being compared:

* M1 stands for FLIPPED_OMP_MATLAB based on the source code by :cite:`you2015sparse`.
* M2 stands for BATCH_OMP_C as our own implementation.


We provide gains obtained for the OMP step itself and
the whole of SSC-OMP separately.

* OMP step is about 3 to 4.6 times faster in BATCH_OMP_C
* Overall SSC-OMP method becomes 2.5 to 2.8 times faster in BATCH_OMP_C.



.. rubric:: Comparing CLASSIC_OMP_C with BATCH_OMP_C

.. list-table::
    :header-rows: 1

    * - Images Per Digit
      - SSC-OMP (M1)
      - OMP (M1)
      - SSC-OMP (M2)
      - OMP (M2)
      - Gain (SSC)
      - Gain (OMP)
    * - 50
      - 0.36
      - 0.25
      - 0.17
      - 0.07
      - 2.11
      - 3.55
    * - 80
      - 0.63
      - 0.51
      - 0.25
      - 0.13
      - 2.49
      - 4.11
    * - 100
      - 0.91
      - 0.77
      - 0.29
      - 0.16
      - 3.13
      - 4.74
    * - 150
      - 2.16
      - 2.01
      - 0.46
      - 0.32
      - 4.68
      - 6.29
    * - 200
      - 5.28
      - 5.10
      - 0.71
      - 0.53
      - 7.41
      - 9.63

* OMP step is about 3.5 to 9.6 times faster in BATCH_OMP_C
* Overall SSC-OMP method becomes 2.1 to 7.4 times faster in BATCH_OMP_C.


.. rubric:: Comparing FLIPPED_OMP_MATLAB with CLASSIC_OMP_C

.. list-table::
    :header-rows: 1

    * - Images Per Digit
      - SSC-OMP (M1)
      - OMP (M1)
      - SSC-OMP (M2)
      - OMP (M2)
      - Gain (SSC)
      - Gain (OMP)
    * - 50
      - 0.38
      - 0.28
      - 0.33
      - 0.24
      - 1.14
      - 1.20
    * - 80
      - 0.58
      - 0.47
      - 0.61
      - 0.49
      - 0.96
      - 0.97
    * - 100
      - 0.78
      - 0.65
      - 1.07
      - 0.93
      - 0.75
      - 0.72
    * - 150
      - 1.28
      - 1.13
      - 2.26
      - 2.12
      - 0.57
      - 0.54
    * - 200
      - 1.79
      - 1.62
      - 5.17
      - 5.00
      - 0.35
      - 0.32

* The C implementation of classic OMP is 
  20% faster on smaller datasets.
* As the dataset grows larger, the 
  FLIPPED_OMP_MATLAB outperforms it by
  2 to 3x.

.. disqus::
