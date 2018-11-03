.. _sec:clustering:utility-functions:

Utility Functions for Clustering Experiments
===============================================

.. highlight: matlab

We provide some utility functions which are
quite useful in setting up clustering experiments.

Suppose you stack data vectors from different
clusters together in a matrix column-wise.
You wish to assign labels to each column of the matrix.
We provide a function to automatically choose such
labels.


Let's choose some cluster sizes::

    >> cluster_sizes = [  4 3 3 2];


Let's generate labels for these clusters::

    >> labels = spx.cluster.labels_from_cluster_sizes(cluster_sizes)

    labels =

         1     1     1     1     2     2     2     3     3     3     4     4

Notice how first 4 labels are 1, next 3 labels are 2, next 3 
are 3 and final 2 are 4.


Let's randomly reorder the labels. This is a typical
step in feeding a clustering algorithm so that any
inherent order in data is destroyed before applying 
the clustering algorithm.

    >> labels = labels(randperm(numel(labels)))

    labels =

         3     2     2     3     4     3     1     1     4     1     2     1

A useful function is to find the sizes of clusters for each
label. We provide a function for that::

    >> spx.cluster.cluster_sizes_from_labels(labels)

    ans =

         4     3     3     2


