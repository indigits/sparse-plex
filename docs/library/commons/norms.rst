Norms and distances
==================================

.. highlight:: matlab


Distance measurement utilities
---------------------------------------------------

Let ``X`` be a matrix. Treat each column of ``X``
as a signal.

Euclidean distance between each signal pair can be computed by::

    SPX_Distance.pairwise_distances(X)

If ``X`` contains N signals, then the result 
is an ``N x N`` matrix whose (i, j)-th entry
contains the distance between i-th and j-th
signal. Naturally, the diagonal elements are all 
zero.

An additional second argument can be
provided to specify the distance measure
to be used. See the documentation of
MATLAB ``pdist`` function for supported
distance functions.

For example, for measuring city-block
distance between each pair of signals, use::

    SPX_Distance.pairwise_distances(X, 'cityblock')



Following dedicated functions are faster.

Squared :math:`\ell_2` distances between all pairs
of columns of X::

    SPX_Distance.sqrd_l2_distances_cw(X)


Squared :math:`\ell_2` distances between all pairs
of rows of X::

    SPX_Distance.sqrd_l2_distances_rw(X)


Norm utilities
---------------------------------------------------

These functions help in computing norm or
normalizing signals in a signal matrix.

Compute :math:`\ell_1` norm of each column vector::

    spx.commons.norm.norms_l1_cw(X)


Compute :math:`\ell_2` norm of each column vector::

    spx.commons.norm.norms_l2_cw(X)
    

Compute :math:`\ell_{\infty}` norm of each column vector::

    spx.commons.norm.norms_linf_cw(X)
    

Normalize each column vector w.r.t. :math:`\ell_1` norm::

    spx.commons.norm.normalize_l1(X)
    
Normalize each column vector w.r.t. :math:`\ell_2` norm::

    spx.commons.norm.normalize_l2(X)
    
Normalize each row vector w.r.t. :math:`\ell_2` norm::

    spx.commons.norm.normalize_l2_rw(X)
    
Normalize each column vector w.r.t. :math:`\ell_{\infty}` norm::

    spx.commons.norm.normalize_linf(X)
    

Scale each column vector by a separate factor::

    spx.commons.norm.scale_columns(X, factors)
    
Scale each row vector by a separate factor::
    
    spx.commons.norm.scale_rows(X, factors)
    
Compute  the inner product of each column vector in A
with each column vector in B::

    spx.commons.norm.inner_product_cw(A, B)


