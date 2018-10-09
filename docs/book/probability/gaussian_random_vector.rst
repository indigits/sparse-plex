
 
Gaussian random vector
===================================================



.. _def:prob:gaussian_random_vector:

.. definition:: 

     .. index:: Gaussian random vector

    A random vector :math:`X = [X_1, \dots, X_n]^T` is called **Gaussian random vector** if 
    
    
    .. math:: 
    
        \langle t , X \rangle = X^T t = \sum_{i = 1}^n t_i X_i  = t_1 X_1 + \dots + t_n X_n
    
    follows a normal distribution for all :math:`t = [t_1, \dots, t_n ]^T \in \RR^n`. 
    The components :math:`X_1, \dots, X_n` are called **jointly Gaussian**. It is denoted
    by :math:`X \sim \NNN_n (\mu, \Sigma)` where :math:`\mu` is its mean vector and :math:`\Sigma` 
    is its covariance matrix. 



Let :math:`X \sim \NNN_n (\mu, \Sigma)` be a Gaussian random vector. 
The subscript :math:`n` denotes that it takes values over the space :math:`\RR^n`.
We assume that  :math:`\Sigma` is invertible. 
Its PDF is given by


.. math::
    f_X (x) = \frac{1}{(2\pi)^{n / 2} \det (\Sigma)^{1/2} } \exp \left \{- \frac{1}{2} (x - \mu)^T \Sigma^{-1}  (x - \mu) \right\}.


Moments:


.. math::
    \EE [X] = \mu \in \RR^n.



.. math::
    \EE[XX^T] = \Sigma + \mu \mu^T.



.. math::
    \Cov[X] = \EE[XX^T] - \EE[X]\EE[X]^T = \Sigma.



Let :math:`Y = A X + b` where :math:`A \in \RR^{n \times n}` is an invertible matrix and :math:`b \in \RR^n`. Then


.. math::
    Y \sim \NNN_n (A \mu + b  , A \Sigma A^T). 


:math:`Y` is also a Gaussian random vector with the mean vector being :math:`A \mu + b` and the covariance 
matrix being :math:`A \Sigma A^T`. This essentially is a change in basis in :math:`\RR^n`.

The CF is given by


.. math::
    \Psi_X(j \omega) \exp \left ( j \omega^T x - \frac{1}{2} \omega^T \Sigma \omega \right ), \quad \omega \in \RR^n.



 
Whitening
----------------------------------------------------

Usually we are interested in making the components of :math:`X` uncorrelated. This process is
known as whitening. We are looking for a linear transformation :math:`Y = A X + b` such that
the components of :math:`Y` are uncorrelated. i.e. we start with


.. math::
    X \sim \NNN_n (\mu, \Sigma)

and transform :math:`Y = A X + b` such that


.. math::
    Y \sim \NNN_n (0, I_n)

where :math:`I_n` is the :math:`n`-dimensional identity matrix.



 
Whitening by eigen value decomposition
""""""""""""""""""""""""""""""""""""""""""""""""""""""

Let


.. math::
    \Sigma = E \Lambda E^T

be the eigen value decomposition of :math:`\Sigma` with :math:`\Lambda` being a diagonal matrix and :math:`E` 
being an orthonormal basis.

Let 


.. math::
    \Lambda^{\frac{1}{2}} = \Diag (\lambda_1^{\frac{1}{2}}, \dots, \lambda_n^{\frac{1}{2}}).


Choose :math:`B = E \Lambda^{\frac{1}{2}}` and :math:`A = B^{-1} = \Lambda^{-\frac{1}{2}} E^T`.  
Then 


.. math::
    \Cov (B^{-1} X) = \Cov (A X) =  \Lambda^{-\frac{1}{2}} E^T \Sigma E \Lambda^{-\frac{1}{2}} = I. 



.. math::
    \EE [B^{-1} X] = B^{-1} \mu \iff \EE [B^{-1} (X - \mu)]  = 0.

Thus the random vector :math:`Y = [B^{-1} (X - \mu)` is a whitened vector of uncorrelated components.

 
Causal whitening
""""""""""""""""""""""""""""""""""""""""""""""""""""""

We want that the transformation be causal, i.e. :math:`A` should be a lower triangular matrix. We start with


.. math::
    \Sigma = L D L^T = (L D^{\frac{1}{2}} ) (D^{\frac{1}{2}} L^T).

Choose :math:`B = L D^{\frac{1}{2}}` and :math:`A = B^{-1} = D^{-\frac{1}{2}} L^{-1}`. Clearly, :math:`A`
is lower triangular.

The transformation is :math:`Y = [B^{-1} (X - \mu)`. 



