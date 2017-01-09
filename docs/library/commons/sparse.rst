Sparse signals
======================

.. highlight:: matlab


Working with signal support
----------------------------------------



Let's create a sparse vector::

    >> x = [0 0 0  1 0 0 -1 0 0 -2 0 0 -3 0 0 7 0 0 4 0 0 -6];

Sparse support for a vector::

    >> spx.commons.sparse.support(x)
    4     7    10    13    16    19    22

:math:`\ell_0` "norm" of a vector::

    >> spx.commons.sparse.l0norm(x)
    7

Let us create one more signal::

    >> y = [3 0 0  0 0 0 0 0 0 4 0 0 -6 0 0 -5 0 0 -4 0 8 0];
    >> spx.commons.sparse.l0norm(y) 
    6
    >> spx.commons.sparse.support(y) 
    1    10    13    16    19    21

Support intersection ratio::

    >> spx.commons.sparse.support_intersection_ratio(x, y)
    0.1364

It is the ratio between the size of common indices
in the supports of x and y and maximum of the
sizes of supports of x and y.    

Average support similarity of a reference 
signal with a set of signals X (each signal
as a column vector)::

    spx.commons.sparse.support_similarity(X, reference)

Support similarities between two sets of signals (pairwise)::

    spx.commons.sparse.support_similarities(X, Y)

Support detection ratios ::

    spx.commons.sparse.support_detection_rate(X, trueSupport)


K largest indices over a set of vectors::

     spx.commons.sparse.dominant_support_merged(data, K)


Sometimes it's useful to identify and arrange the non-zero
entries in a signal in descending order of their magnitude::

    >> spx.commons.sparse.sorted_non_zero_elements(x)
    16    22    19    13    10     4     7
     7    -6     4    -3    -2     1    -1

Given a signal ``x``, the function ``spx.commons.sparse.sorted_non_zero_elements``
returns a two row matrix where the first row contains the locations
of non-zero elements sorted by their magnitude and second row
contains their magnitude. If the magnitude of two non-zero elements
is same, then the original order is maintained. The sorting is stable.
