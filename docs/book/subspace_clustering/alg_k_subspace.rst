
 
K-subspace clustering
----------------------------------------------------

K-subspace clustering :cite:`ho2003clustering`
is a generalization of K-means 
[see :ref:`here <sec:kmeans>`]
and K-plane clustering.
In K-means, we cluster points around centroids,
in K-plane, we cluster points around hyperplanes,
and in K-subspace clustering, we cluster points
around subspaces. This algorithm requires
the number of subspaces :math:`K` and their dimensions
:math:`\{ D_1, \dots, D_K \}` to be known in advance.
We present the version for linear subspaces with :math:`\mu_k = 0`.
Fitting the dataset :math:`Y` into :math:`K`-subspaces can be reduced to 
means identifying an orthogonal basis :math:`Q_k \in \RR^{M \times D_k}` for each subspace. If the data points fit perfectly,
then for every :math:`s` in :math:`\{ 1, \dots , S\}` there exists
a :math:`k` in :math:`\{1, \dots, K\}` such that :math:`y_s = Q_k \alpha_s`
(i.e. :math:`y_s` belongs to :math:`k`-th subspace with basis :math:`Q_k`).
If the data point belongs to an intersection of two or more
subspaces, then we can arbitrarily assign the data point 
to one of the subspaces. 

Lastly, data points may not be
lying perfectly in the subspace.  The orthoprojector
for each subspace is given by :math:`Q_k Q_k^T`. Thus, the
projection of a point :math:`y_s` on a subspace :math:`\UUU_k`
is :math:`Q_k Q_k^T y_s` and the error is :math:`(I - Q_k Q_k^T) y_s`.
The (squared) distance from the subspace is then :math:`\|(I - Q_k Q_k^T) y_s\|_2^2`. The point can be assigned to the subspace
closest to it.

Given that a set of points :math:`Y_k` are assigned to the subspace
:math:`\UUU_k`, the orthonormal basis :math:`Q_k` can be estimated for
:math:`\UUU_k` by performing principal component analysis 
:ref:`here <sec:pca>`.

This gives us a straightforward iterative method for 
fitting the subspaces.

*  Start with initial subspace bases :math:`Q_1^{(0)}, \dots, Q_K^{(0)}`.
*  Assign points to subspaces by using minimum distance criteria.
*  Estimate the bases for each subspace.
*  Repeat steps 2 and 3 till the clustering keeps changing.

Initial subspaces can be chosen randomly.