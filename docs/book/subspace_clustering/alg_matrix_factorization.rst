
 
Matrix Factorization based algorithms
----------------------------------------------------

Basic matrix factorization based algorithms were developed 
for solving the motion segmentation problem 
in :cite:`boult1991factorization,gear1998multibody,costeira1998multibody,kanatani2001motion`. 
These algorithms are primarily algebraic in nature.
See :ref:`here <sec:motion_segmentation>`
for the motivation from motion segmentation problem.

The following derivation is applicable if the
subspaces are linear and independent. 

We start with the equation:


.. math:: 

    Y^* = Y \Gamma 
    = \begin{bmatrix} y_1 & \dots & y_S \end{bmatrix} \Gamma
    = \begin{bmatrix} Y_1 & \dots & Y_K \end{bmatrix}.

Under the independence assumption, we have


.. math::
    \Rank (Y)  = \Rank(Y^*) = \sum_{k=1}^K \Rank(Y_k). 

Note that each :math:`Y_k \in \RR^{M \times S_k}` can be factorized via SVD as


.. math::
    Y_k = U_k \Sigma_k V_k^T

where :math:`U_k \in \RR^{M \times D_k}`,
:math:`\Sigma_k = \text{diag}(\sigma_{p 1}, \dots, \sigma_{p D_k}) \in \RR^{D_k \times D_k}` and :math:`V_k \in \RR^{S_k \times D_k}`. 
Columns of :math:`U_k` form an orthonormal basis for the subspace
:math:`\UUU_k`. Columns of :math:`\Sigma_k V_k^T` give the coordinates
of points in :math:`Y_k` in the orthonormal basis :math:`U_k`.
Singular values are non-zero since :math:`Y_k` spans :math:`\UUU_k`. Alternatively,
:math:`D_k` can be obtained by counting the non-zero singular values
in the SVD of Y.
Denoting:


.. math::
    \hat{U} = \begin{bmatrix}
    U_1 & \dots & U_K
    \end{bmatrix}\\
    \hat{\Sigma} = \begin{bmatrix}
    \Sigma_1 & \dots & 0 \\
    \vdots & \ddots & \vdots\\
    0 & \dots & \Sigma_K
    \end{bmatrix}\\
    \hat{V} = \begin{bmatrix}
    V_1 & \dots & 0 \\
    \vdots & \ddots & \vdots\\
    0 & \dots & V_K
    \end{bmatrix},

we can write


.. math::
    Y^*  = \hat{U} \hat{\Sigma} \hat{V}^T.

This is a valid SVD of :math:`Y^*` if the subspaces
:math:`\UUU_k` are independent. 
This differs from the standard SVD of :math:`Y^*` only
in the permutation of singular values in :math:`\Sigma`
as the standard SVD of :math:`Y^*` will require them
to be ordered in decreasing order. Nevertheless,


.. math::
    Y = Y^* \Gamma^{-1} = Y^* \Gamma^T 
    = \hat{U} \hat{\Sigma} \hat{V}^T \Gamma^T 
    = \hat{U} \hat{\Sigma} (\Gamma \hat{V})^T.

It is clear that both :math:`Y` and :math:`Y^*` share the 
same singular values.  
Let the SVD of :math:`Y` be :math:`Y = U \Sigma V^T`.
Let :math:`\Sigma =  \hat{\Sigma}\hat{\Gamma}` where
:math:`\hat{\Gamma}` permutes the singular values in :math:`\hat{\Sigma}`
in decreasing order.
Then
:math:`\hat{\Sigma} = \Sigma \hat{\Gamma}^T` and 


.. math::
    Y 
    = \hat{U} \hat{\Sigma} (\Gamma \hat{V})^T
    = \hat{U} \Sigma \hat{\Gamma}^T (\Gamma \hat{V})^T
    = \hat{U} \Sigma (\Gamma \hat{V} \hat{\Gamma})^T.

Matching terms, we see that :math:`U = \hat{U}` and :math:`V  = \Gamma \hat{V} \hat{\Gamma}`.
Thus :math:`\hat{V}` is obtained by permuting the rows and columns of :math:`V`
where :math:`\Gamma` and :math:`\hat{\Gamma}` are unknown permutations.

Let :math:`W = VV^T` and :math:`\hat{W} = \hat{V} \hat{V}^T`. Then


.. math::
    W = VV^T = \Gamma \hat{V} \hat{\Gamma} \hat{\Gamma}^T \hat{V}^T \Gamma^T
    = \Gamma \hat{V} \hat{V}^T \Gamma^T = \Gamma \hat{W} \Gamma^T.

Alternatively 


.. math::
    \hat{W} = \Gamma^T W \Gamma.

Thus, :math:`\hat{W}` can be obtained by identical row and column permutations
of :math:`W` given by :math:`\Gamma`. 

The matrix :math:`W` is very useful. But first let's check out :math:`\hat{W}`.
Note that :math:`\hat{V}` can be considered as a :math:`P \times P` block matrix
with diagonal matrix elements.
Thus 


.. math::
    \hat{V} \hat{V}^T = 
    \begin{bmatrix}
    V_1 & \dots & 0 \\
    \vdots & \ddots & \vdots\\
    0 & \dots & V_K
    \end{bmatrix}
    \begin{bmatrix}
    V_1^T & \dots & 0 \\
    \vdots & \ddots & \vdots\\
    0 & \dots & V_K^T
    \end{bmatrix}.

Simplifying, we obtain


.. math::
    \hat{W} = 
    \begin{bmatrix}
    V_1 V_1^T & \dots & 0 \\
    \vdots & \ddots & \vdots\\
    0 & \dots & V_K V_K^T
    \end{bmatrix}.

:math:`V_k V_k^T` is a :math:`S_k \times S_k` non-zero matrix.
:math:`\hat{W}` is an :math:`S \times S` matrix. Clearly,
:math:`\hat{W}_{i j} = 0` if :math:`i`-th and :math:`j`-th columns
in :math:`Y^*` belong to the different subspaces.
Since :math:`W` is obtained by permuting the rows and columns
of :math:`\hat{W}` by :math:`\Gamma`, hence :math:`W_{ij} = 0` if :math:`i`-th
and :math:`j`-th columns in the unsorted data matrix :math:`Y` come
from different subspaces. A simple algorithm for
data segmentation is thus obtained which puts 
the :math:`i`-th and :math:`j`-th columns in :math:`Y` in same cluster
if the corresponding entry :math:`W_{ij}` is non-zero.


.. disqus::

