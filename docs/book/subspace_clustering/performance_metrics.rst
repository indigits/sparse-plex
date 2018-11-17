.. _sec:sc:ssc:performance_metrics:
 
Performance Metrics for Sparse Subspace Clustering
===================================================


.. contents:: :local:


Consider a sparse representation matrix :math:`C`
where each signal has been represented in terms
of other signals. With :math:`S` signals, the
matrix is of size :math:`S \times S` and 
the diagonal elements of the matrix are zero.

We use following metrics for comparison of algorithms.

.. rubric:: Percentage of subspace preserving representations (p%) :cite:`you2015sparse`

This is the percentage of points whose representations are
subspace-preserving. Due to the imprecision of solvers,
coefficients with absolute values less than 
:math:`10^{-3}` are considered zero. 
A subspace preserving :math:`C` gives :math:`p = 100`.

.. rubric:: Subspace preserving representation error (e%) :cite:`elhamifar2013sparse`

For each column :math:`c_s` in :math:`C`, we compute the
fraction of its :math:`\ell_1` norm that comes from other
subspaces and average over all :math:`1 \leq s \leq S`.

.. math:: 

    e\% = \frac{100}{S} \sum_{s=1}^S  \left ( 1 - 
    \frac{\sum_{i=1}^S w_{is} | c_{is}| }{\| c_s \|_1}  
    \right )  

where :math:`w_{is} \in \{0, 1\}` is its true affinity.
A subspace-preserving :math:`C` gives :math:`e=0`.

.. rubric:: Clustering accuracy (a %) :cite:`you2015sparse` 

This is the percentage of correctly labeled data points. 
It is computed by matching the estimated and true labels as

.. math:: 

    a\% = \frac{100}{S}  \underset{\pi}{\max} 
    \sum_{ks} L^{\text{est}}_{\pi(k) s} L^{\text{true}}_{ks}

where :math:`\pi` is a permutation of the :math:`K` cluster labels,
:math:`L_{ks} = 1` if point :math:`s` belongs to cluster :math:`k`, and 0
otherwise. This assumes that either the number of 
subspaces/clusters is known a priori to the clustering
algorithm or the clustering algorithm has inferred it 
correctly.

.. rubric:: Running time (t) 

For each clustering task using MATLAB.  

Hands-on with Subspace Preservation Metrics
---------------------------------------------------

Let's consider a data set of 10 points::

    X =

        0.2813   -0.9343    0.2368   -0.7846    0.7908         0         0         0         0         0
        0.9596    0.3566   -0.9716    0.6200    0.6120   -0.4064    0.9962    0.9613   -0.0830    0.7051
             0         0         0         0         0    0.9137   -0.0866   -0.2757    0.9965    0.7091

The points are drawn from a 3 dimensional space. First 5 points
are drawn from X-Y plane and last 5 points are from Y-Z plane.

We constructed the sparse presentations of these data points
in terms of other points using basis pursuit. The representations
are::

    C =

        0.0000   -0.0000   -0.0000    0.0000    0.8565   -0.0000    0.3284    0.0000    0.0000    0.3615
        0.0000   -0.0000   -0.0000    0.7476   -0.5885   -0.0000    0.0000    0.0000    0.0000    0.0000
       -0.0000   -0.0000   -0.0000   -0.3638   -0.0000    0.0000   -0.3902   -0.0000   -0.0000   -0.4295
        0.0000    0.8797   -0.3018    0.0000   -0.0000   -0.0000    0.0000    0.0000    0.0000    0.0000
        0.3558   -0.3085   -0.0000   -0.0000   -0.0000   -0.0000    0.0000    0.0000    0.0000    0.0000
       -0.0000    0.0000    0.0000   -0.0000   -0.0000   -0.0000   -0.0000   -0.2187    0.8167    0.0000
        0.6854   -0.0000   -0.7247    0.0000    0.0000   -0.0000    0.0000    0.8757    0.0000    0.0000
        0.0000   -0.0000   -0.0000    0.0000    0.0000   -0.3520    0.3141    0.0000   -0.0000    0.0000
        0.0000   -0.0000   -0.0000    0.0000    0.0000    0.8195   -0.0000   -0.0000   -0.0000    0.7116
        0.0837   -0.0000   -0.0885    0.0000    0.0000    0.0000    0.0000    0.0000    0.3530    0.0000

For subspace preserving representations:

* In the first 5 columns, non-zero entries should 
  appear in first 5 rows.
* In the last 5 columns, non-zero entries should 
  appear in last 5 rows. 

On inspection, we can see that column 1 is not 
subspace preserving while column 2 is.

Let's go through the steps of computing the metrics.
We will work on column 1.


Let's assign cluster labels to each of the columns::

    cluster_sizes = [5 5];
    labels = spx.cluster.labels_from_cluster_sizes(cluster_sizes)
    >> spx.io.print.vector(labels, 0)
    1 1 1 1 1 2 2 2 2 2 

Let's compute absolute values of :math:`C`::

    C = abs(C);

We will allocate some space to keep
flags indicating whether a column contains
subspace preserving representation or not
and the amount of :math:`\ell_1`-error
in each column::

    spr_flags = zeros(1, S);
    spr_errors = zeros(1, S);


Let's pick up the first column::

    c1 = C(:, 1);

The label assigned to this column is::

    k = labels(1);

which happens to be 1 (first cluster).

Identify the rows which contain non-zero values::


    non_zero_indices = (c1 >= 1e-3);

Each non-zero value is a contribution from
some other column. We wish to identify the
cluster to which those columns belong::

    non_zero_labels = labels(non_zero_indices)
    non_zero_labels =

         1     2     2

Notice, how only one of the contributors is from
1st cluster while the other two are from second 
cluster. Cross check this in the :math:`C` matrix
display above.

Verify if all the contributors are from the same
cluster and store it in the ``spr_flags`` variable::

    spr_flags(1) = all(non_zero_labels == k)
    0

Next, let's identify the columns which come
from the same cluster as the current cluster::

    w = labels == k;

Coefficients from same cluster are::

    c1k = c1(w);

Subspace preserving representation  error is given by::

    spr_errors(1) = 1 - sum(c1k) / sum (c1)
    >> spr_errors(1)

    ans =

        0.6837


We provide a function which does this whole sequence
of operations on all data points::

    spr_stats = spx.cluster.subspace.subspace_preservation_stats(C, cluster_sizes);


The flags whether a representation is subspace preserving
or not for each data point::

    >> spr_stats.spr_flags

    ans =

         0     1     0     1     1     1     0     1     1     0


Indicator if all representations are subspace preserving or not::

    >> spr_stats.spr_flag
    0


Data point wise subspace preserving representation error::

    >> spr_stats.spr_errors

    ans =

        0.6837    0.0000    0.7293    0.0000    0.0000    0.0000    0.6958    0.0000    0.0000    0.5264


Average representation error::

    >> spr_stats.spr_error

    ans =

        0.2635


This is about 26% error.

Percentage of data points having subspace preserving representations::

    >> spr_stats.spr_perc

    ans =

        60


Not too bad given that the number of data points was
very small.


Complete example code can be downloaded
:download:`here <demo_spr.m>`.
