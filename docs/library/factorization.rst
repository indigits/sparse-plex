Matrix factorization algorithms
========================================

.. highlight:: matlab


.. note::

    Better implementations for these algorithms may be available
    in stock MATLAB distribution or other third party libraries.
    These codes were developed for instructional purposes as
    variations of these algorithms were needed in development
    of other algorithms in this package.




Various versions of QR Factorization
---------------------------------------------

Gram Schmidt::

    [Q, R] =  spx.la.qr.gram_schmidt(A)


Householder UR::

    [U, R] = spx.la.qr.householder_ur(A)


Householder QR::

    [Q, R] =  spx.la.qr.householder_qr(A)

Householder matrix for a given vector::

    [H, v] = spx.la.qr.householder_matrix(x)