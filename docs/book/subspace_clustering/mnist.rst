.. _sec:sc:ssc:mnist:

Sparse Subspace Clustering with MNIST Digits
=============================================

.. highlight:: matlab

In this section, we discuss using SSC algorithms on
MNIST dataset. 

.. contents::
    :local:

MNIST dataset :cite:`lecun1998gradient` contains
gray scale images of handwritten digits 0-9. The 
dataset consists of :math:`60,000` images. Following
:cite:`you2016scalable`, for each image, we compute
a set of feature vectors using a scattering
convolution network :cite:`bruna2013invariant`.
The feature vector is translation invariant and
deformation stable. Each feature vector is of
length :math:`3,472`. The feature vectors are available
`here <https://www.kaggle.com/shailesh1729/mnist-digits-scattering-transform>`_.

.. _sec:sc:ssc:mnist:dataset:

MNIST Dataset
----------------------------------------------------


Please download the file ``MNIST_SC.mat``
and place it in ``sparse-plex/data/mnist`` directory.


We provide a wrapper class to load the data from
this dataset::

    md = spx.data.image.ChongMNISTDigits;

Beware, the whole dataset is 1GB in size and can take
10-20 seconds to load depending upon your system capability.

Let's look at the structure ``md``::

    >> md
    md = 

      ChongMNISTDigits with properties:

                    Y: [3472×60000 double]
               labels: [1×60000 double]
               digits: [0 1 2 3 4 5 6 7 8 9]
        cluster_sizes: [5923 6742 5958 6131 5842 5421 5918 6265 5851 5949]


* The :math:`Y` matrix contains one feature vector (as column)
  per example digit. 
* The labels array contains information about the 
  digit represented in each column of :math:`Y`.
* ``cluster_sizes`` is the number of examples of each digit
  in this dataset.

Seeing some labels::

    >> md.labels(1:10)

    ans =

         5     0     4     1     9     2     1     3     1     4


Number of examples of digit 5 ::

    >> sum(md.labels == 5)

    ans =

            5421

    >> md.cluster_sizes(5+1)

    ans =

            5421

The object ``md`` provides a method to find out the column indices
for a given digit in the labels array. 
Let's find all the indices for digit 4::

    >> four_indices = md.digit_indices(4);
    >> numel(four_indices)

    ans =

            5842

Let's checkout some of these indices and verify them in the
labels array::

    >> four_indices(1:4)

    ans =

         3    10    21    27

    >> md.labels(four_indices(1:4))

    ans =

         4     4     4     4


We can select a subset of samples from this dataset 
along with the labels as follows::

    >> indices = [1 10 11 40];
    >> [Y, labels] = md.selected_samples(indices);
    >> labels

    labels =

         5     4     3     6

.. _sec:sc:ssc:mnist:ssc-omp:

SSC-OMP on MNIST Dataset
--------------------------------

In this section, we will go through the steps
of applying the SSC-OMP algorithm on the 
MNIST dataset.

We will work on all the digits::

    digit_set = 0:9;

Number of samples for each digit::

    num_samples_per_digit = 400;


Number of clusters or corresponding low dimensional
subspaces::

    K = length(digit_set);

Sizes of each cluster::

    cluster_sizes = num_samples_per_digit*ones(1, K);

Let's draw 200 examples/samples for each
digit from the MNIST dataset described above::

    sample_list = [];
    for k=1:K
        digit = digit_set(k);
        digit_indices = md.digit_indices(digit);
        num_digit_samples = length(digit_indices);
        choices = randperm(num_digit_samples, cluster_sizes(k));
        selected_indices = digit_indices(choices);
        sample_list = [sample_list selected_indices];
    end

We have picked the column numbers of samples/examples
for each digit and concatenated them into
``sample_list``.

Time to pickup the samples from the dataset
along with labels::

    [Y, true_labels] = md.selected_samples(sample_list);

The feature vectors are 3472 dimensional. 
We don't really need this much of detail.
We will perform PCA to reduce the dimensions
to 500::

    fprintf('Performing PCA\n');
    tstart = tic;
    Y = spx.la.pca.low_rank_approx(Y, 500);
    elapsed_time = toc (tstart);
    fprintf('Time taken in PCA %.2f seconds\n', elapsed_time);

::

    Performing PCA
    Time taken in PCA 17.69 seconds

The ambient space dimension M and the
number of data vectors S::

    [M, S] = size(Y);

Time to perform sparse subspace clustering
with orthogonal matching pursuit::

    tstart = tic;
    fprintf('Performing SSC OMP\n');
    import spx.cluster.ssc.OMP_REPR_METHOD;
    solver = spx.cluster.ssc.SSC_OMP(Y, D, K, 1e-3, OMP_REPR_METHOD.FLIPPED_OMP_MATLAB);
    solver.Quiet = true;
    clustering_result = solver.solve();
    elapsed_time = toc (tstart);
    fprintf('Time taken in SSC-OMP %.2f seconds\n', elapsed_time);

::

    Performing SSC OMP
    Time taken in SSC-OMP 10.54 seconds

Let's collect the statistics related to
clustering error and subspace preserving
representations error::


    connectivity = clustering_result.connectivity;
    % estimated number of clusters
    estimated_num_subspaces = clustering_result.num_clusters;
    % Time to compare the clustering
    cluster_labels = clustering_result.labels;
    fprintf('Measuring clustering error and accuracy\n');
    comparsion_result = spx.cluster.clustering_error_hungarian_mapping(cluster_labels, true_labels, K);
    clustering_error_perc = comparsion_result.error_perc;
    clustering_acc_perc = 100 - comparsion_result.error_perc;
    spr_stats = spx.cluster.subspace.subspace_preservation_stats(clustering_result.Z, cluster_sizes);
    spr_error = spr_stats.spr_error;
    spr_flag = spr_stats.spr_flag;
    spr_perc = spr_stats.spr_perc;
    fprintf('\nclustering error: %0.2f %% , clustering accuracy: %0.2f %%\n, mean spr error: %0.4f preserving : %0.2f %%\n, connectivity: %0.2f, elapsed time: %0.2f sec',...
        clustering_error_perc, clustering_acc_perc,...
        spr_stats.spr_error, spr_stats.spr_perc,...
        connectivity, elapsed_time);
    fprintf('\n\n');


Results :: 

    Measuring clustering error and accuracy

    clustering error: 6.42 % , clustering accuracy: 93.58 %
    , mean spr error: 0.3404 preserving : 0.00 %
    , connectivity: -1.00, elapsed time: 10.54 sec


.. _sec:sc:ssc:mnist:benchmark:

SSC-OMP on MNIST Benchmarks
------------------------------

The table below reports the performance of SSC-OMP 
algorithm on MNIST dataset. The data consists of
randomly chosen number of images for each of the
10 digits. Scattering network features are extracted
from the image and they are projected to dimension
500 using PCA. The images per digit are varied 
for each experiment from 50 to 400. 

.. list-table::
    :header-rows: 1

    * - Images per Digit
      - a%
      - e%
      - t
    * - 50
      - 82.18
      - 42.11
      - 0.36
    * - 80
      - 87.39
      - 39.79
      - 0.81
    * - 100
      - 87.20
      - 38.86
      - 1.11
    * - 150
      - 89.16
      - 37.33
      - 2.02
    * - 200
      - 89.68
      - 36.39
      - 3.25
    * - 300
      - 92.19
      - 35.18
      - 6.27
    * - 400
      - 91.13
      - 34.26
      - 7.07
