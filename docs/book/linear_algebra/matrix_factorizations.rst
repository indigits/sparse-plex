
 
Matrix Factorizations
----------------------------------------------------


 
Singular Value Decomposition
""""""""""""""""""""""""""""""""""""""""""""""""""""""

A non-negative real value :math:`\sigma` is a singular value
for a matrix :math:`A \in \RR^{m \times n}` if and only if
there exist unit length vectors :math:`u \in \RR^m` and :math:`v \in \RR^n`
such that :math:`A v = \sigma u` and :math:`A^T u = \sigma v`. The vectors
u and v are called left singular and right singular vectors
for :math:`\sigma` respectively. For every :math:`A \in \RR^{m \times n}` 
with :math:`k = \min(m, n)`, there exist two orthogonal matrices 
:math:`U \in \RR^{m \times m}` and :math:`V \in \RR^{n \times n}` and
a sequence of real numbers :math:`\sigma_1 \geq \dots \geq \sigma_k \geq 0`
such that :math:`U^T A V = \Sigma` where :math:`\Sigma = \text{diag}(\sigma_1, \dots, \sigma_k, 0, \dots, 0) \in \RR^{m \times n}` (Extra columns or rows are filled with zeros). The decomposition of :math:`A` given by
:math:`A = U \Sigma V^T` is called the singular value decomposition of :math:`A`.
The first :math:`k` columns of :math:`U` and :math:`V` are the left and right
singular vectors of :math:`A` corresponding to the singular values
:math:`\sigma_1, \dots, \sigma_k`. The rank of :math:`A` is equal to the
number of non-zero singular values which equals the rank of :math:`\Sigma`.
The eigen values of positive semi-definite matrices :math:`A^T A` 
and :math:`A A^T` are given by :math:`\sigma_1^2, \dots, \sigma_k^2` (remaining
eigen values being 0).
Specifically, :math:`A^T A = V \Sigma^T \Sigma V^T` and
:math:`A A^T = U \Sigma \Sigma^T U^T`. 
We can rewrite :math:`A = \sum_{i=1}^k \sigma_i u_i v_i^T`. :math:`\sigma_1 u_1 v_1^T` is rank-1 approximation of :math:`A` in Frobenius
norm sense. The spectral radius and :math:`2`-norm of :math:`A` is given by
its largest singular value :math:`\sigma_1`. 
The Moore-Penrose pseudo-inverse of :math:`\Sigma`
is easily obtained by taking the transpose of :math:`\Sigma` and inverting
the non-zero singular values. Further, :math:`A^{\dag} = V \Sigma^{\dag} U^T`.
The non-zero singular values of :math:`A^{\dag}` are just reciprocals of 
the non-zero singular values of :math:`A`.
Geometrically, singular values of :math:`A` are the
precisely the lengths of the semi-axes of the 
hyper-ellipsoid :math:`E` defined by 
:math:`E = \{ A x | \| x \|_2  = 1 \}` (i.e. image of 
the unit sphere under :math:`A`). Thus, if :math:`A` is a
data matrix, then the SVD of :math:`A`
is strongly connected with the principal component
analysis of :math:`A`.