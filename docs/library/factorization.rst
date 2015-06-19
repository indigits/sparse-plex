Factorization Algorithms
========================================

.. highlight:: matlab



Various versions of QR Factorization
---------------------------------------------

Gram Schmidt::

    [Q, R] =  CS_QR.gram_schmidt(A)


Householder UR::

    [U, R] = CS_QR.householder_ur(A)


Householder QR::

    [Q, R] =  CS_QR.householder_qr(A)

Householder matrix for a given vector::

    [H, v] = CS_QR.householder_matrix(x)