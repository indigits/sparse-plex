Sparse signals
======================

.. highlight:: matlab


Let's create a sparse vector::

    >> x = [0 0 0  1 0 0 -1 0 0 -2 0 0 -3 0 0 7 0 0 4 0 0 -6];

Sparse support for a vector::

    >> SPX_Support.support(x)
    4     7    10    13    16    19    22

:math:`\ell_0` "norm" of a vector::

    >> SPX_Support.l0norm(x)
    7

Let us create one more signal::

    >> y = [3 0 0  0 0 0 0 0 0 4 0 0 -6 0 0 -5 0 0 -4 0 8 0];
    >> SPX_Support.l0norm(y) 
    6
    >> SPX_Support.support(y) 
    1    10    13    16    19    21

Support intersection ratio::

    >> SPX_Support.intersectionRatio(x, y)
    0.1364

It is the ratio between the size of common indices
in the supports of x and y and maximum of the
sizes of supports of x and y.    

Average support similarity of a reference 
signal with a set of signals X (each signal
as a column vector)::

    SPX_Support.supportSimilarity(X, reference)

Support similarities between two sets of signals (pairwise)::

    SPX_Support.supportSimilarities(X, Y)

Support detection ratios ::

    SPX_Support.supportDetectionRate(X, trueSupport)


K largest indices over a set of vectors::

     SPX_Support.dominantSupportMerged(data, K)


