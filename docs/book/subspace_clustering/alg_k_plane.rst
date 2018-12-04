
 
K-plane clustering
----------------------------------------------------

K-plane clustering :cite:`bradley2000k` is a variation of 
the K-means algorithm :cite:`duda2012pattern`.
In :math:`K`-means, we choose a point as the center of
each cluster. In :math:`K`-plane clustering, we instead choose
a hyperplane at the center of each cluster. 
This algorithm
can be used for solving subspace clustering
problem when each subspace :math:`\UUU_k` is deemed to be
a hyperplane of :math:`\RR^M`. 
See :ref:`here <sec:affine_subspace>` for a quick review
of affine subspaces. 
In our notation, we will
be estimating :math:`K` hyperplanes :math:`\mathcal{H}_k`
with :math:`1 \leq k \leq K`. We also assume that
:math:`K` is known in advance. Each of the planes
is defined as 


.. math::
    \mathcal{H}_k = \{ x | x \in \RR^M , x^T w_k = d_k\}.

The algorithm seeks to choose planes such that 
the sum of squares of distances of each point in :math:`Y`
to the nearest plane is minimized.

The algorithm alternates between cluster 
assignment step (where each point is assigned to
the nearest plane) and cluster update step (where a new
nearest plane is computed for each cluster).

We assume that the normal vector :math:`w_k` is unit norm,
i.e. :math:`\| w_k \|_2 = 1`. Thus, the distance of 
a point :math:`y_s` from a plane :math:`\mathcal{H}_k` is
:math:`| \langle w_k , y_s \rangle - d_k |`. 

In the cluster assignment step, the closest plane
for the point :math:`y_s` is chosen as 


.. math::
    k(s) = \underset{k \in 1, \dots, K}{\text{arg min}}
    | \langle w_k , y_s \rangle - d_k |

where :math:`k(s)` denotes the assignment of :math:`s`-th point
to :math:`k`-th cluster.
Next, we look at the problem of finding the
nearest hyperplane to a given set of points.
Let :math:`\{y_{k 1}, y_{k 2}, y_{k n_k} \}` be the
set of points assigned to :math:`k`-th cluster at 
a given iteration. 
We can stack the vectors :math:`y_{k n}` in a matrix 
:math:`Y_k = \begin{bmatrix} y_{k 1} & \dots & y_{k n_k} \end{bmatrix}`. 
If :math:`\Rank(Y_k) < M`, then it is 
easy to find a hyperplane which contains all the
points and the minimum distance is 0. In particular,
if :math:`\Rank(Y_k) = M-1`, then this hyperplane is the
range of columns of :math:`Y_k`: :math:`\Range(Y_k)`. Otherwise, any hyperplane
containing :math:`\Range(Y_k)` would work fine. 

In the general case, for an arbitrary hyperplane
specified by :math:`(w, d)`, the sum of squared distances
from the plane is given by


.. math::
    \sum_{n=1}^{n_k}| \langle w , y_{k n} \rangle - d |^2
    = \| Y_k^T w - d \OneVec_{n_k} \|_2^2.

The cluster update step thus is equivalent to finding the
solution to the optimization problem:


.. math::
    \begin{aligned}
    \underset{w, d}{\text{minimize}} \| Y_k^T w - d \OneVec_{n_k} \|_2^2\\
    \text{subject to } w^T w = 1.
    \end{aligned}

To solve this problem, we define a matrix 


.. math:: 

    B \triangleq Y_k \left ( I - \frac{\OneVec \OneVec^T}{n_k} \right ) Y_k^T.

A global solution to this problem is obtained at any
eigenvector :math:`w` of :math:`B` corresponding to a minimum
eigenvalue of :math:`B` and :math:`d = \frac{\OneVec^T Y_k^T w}{n_k}`
:cite:`bradley2000k`. When :math:`Y_k` is degenerate (:math:`\Rank(Y_k) < M`),
then the minimum eigen value of :math:`B` is 0 and the minimum distance
is 0.

Finally, it can also be shown that
the :math:`K`-plane clustering algorithm terminates in
a finite number of steps at a cluster assignment
that is locally optimal. This concludes our discussion
of :math:`K`-plane clustering.


.. disqus::

