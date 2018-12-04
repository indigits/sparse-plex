
 
Random vectors
===================================================


We will continue to use the notation of capital letters to denote a random vector. We will specify the
space over which the random vector is generated to clarify the dimensionality.

A real random vector :math:`X` takes values in the vector space :math:`\RR^n`.
A complex random vector :math:`Z` takes values in the vector space :math:`\CC^n`.
We write


.. math::
    X = 
    \begin{bmatrix}
    X_1 \\ \vdots \\ X_n
    \end{bmatrix}.


The expected value or mean of a random vector is :math:`\EE(X)`. 


.. math::
    \EE(X) = 
    \begin{bmatrix}
    \EE(X_1) \\ \vdots \\ \EE(X_n)
    \end{bmatrix}.


Covariance-matrix of a random vector:


.. math::
    \Cov (X)  = \EE [(X - \EE(X)) (X - \EE(X))^T] = \EE [X X^T] - \EE[X] \EE[X]^T.

We will use the symbols :math:`\mu` and :math:`\Sigma` for the mean vector and covariance 
matrix of a random vector :math:`X`. Clearly


.. math::
    \EE [X X^T]  = \Sigma + \mu \mu^T.



Cross-covariance matrix of two random vectors:


.. math::
    \Cov (X, Y)  = \EE [(X - \EE(X)) (Y - \EE(Y))^T]
    = \EE [X Y^T] - \EE[X] \EE[Y]^T.

Note that


.. math::
    \Cov (X, Y)  =\Cov (Y, X)^T. 


The characteristic function is defined as


.. math::
    \Psi_X(j\omega) = \EE \left ( \exp (j \omega^T X) \right ), \quad \omega \in \RR^n.

The MGF is defined as


.. math::
    M_X(t) = \EE \left ( \exp (t^T X) \right ), \quad t \in \CC^n.




.. theorem:: 

    The components :math:`X_1, \dots, X_n` of a random vector :math:`X` are independent if and only if
    
    
    .. math::
        \Psi_X(j\omega) = \prod_{i=1}^n \Psi_{X_i}(j\omega_i), \quad \forall  \omega \in \RR^n.
    
.. disqus::
