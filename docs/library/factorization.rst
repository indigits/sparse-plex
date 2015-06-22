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

    [Q, R] =  SPX_QR.gram_schmidt(A)


Householder UR::

    [U, R] = SPX_QR.householder_ur(A)


Householder QR::

    [Q, R] =  SPX_QR.householder_qr(A)

Householder matrix for a given vector::

    [H, v] = SPX_QR.householder_matrix(x)