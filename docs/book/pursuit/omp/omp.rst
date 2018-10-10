whoop algorithm
----------------------------------------------------


The core **Orthogonal Matching Pursuit** 
algorithm is presented in :ref:`here <alg:orthogonal_matching_pursuit>`.
The algorithm is iterative. 



[leftmargin=*]
*  We start with the initial estimate of solution :math:`\alpha=0`. 
*  We also maintain the support of :math:`\alpha` i.e. the set of indices for which :math:`\alpha` is non-zero.
We start with an empty support.
*  In each (:math:`k`-th) iteration we attempt to reduce the difference between the actual signal :math:`x` 
and the approximate signal based on current solution :math:`\alpha^{k-1}` given by :math:`r^{k-1} = x - \Phi \alpha^{k-1}`.
*  We do this by choosing a new index in :math:`\alpha` given by :math:`j_0` for the column :math:`\phi_{j_0}`
which most closely matches our current residual.
*  We include this to our support for :math:`\alpha`, estimate new solution vector :math:`\alpha` and compute
new residual.
*  We stop when the residual magnitude is below a threshold :math:`\epsilon_0` defined by us.


Each iteration of algorithm consists of following stages:
[leftmargin=*]
* [Sweep] For each column :math:`\phi_j` in our synthesis matrix, 
we measure the projection of residual from previous iteration  on the column
and compute the magnitude of error between the projection
and residual. 

The square of minimum error for :math:`\phi_j` is given by:


.. math:: 

    \epsilon^2(j) = \| r^{k-1}\|_2^2 - |\phi_j^H r^{k-1}|^2.


We can also note that minimizing over :math:`\epsilon(j)` is equivalent to 
maximizing over the inner product of :math:`\phi_j` with :math:`r^{k-1}` though this
just helps us reduce only :math:`N` subtractions per iteration. 
* [Update support] Ignoring the columns which have already been included in the support, we pick
up the column which most closely resembles the residual of previous stage. i.e. the magnitude of
error is minimum. We include the index of this column :math:`j_0` in the support set :math:`S^{k}`.
* [Update provisional solution] 
In this step we find the solution of minimizing :math:`\| \Phi \alpha - x \|^2` over the
support :math:`S^k` as our next candidate solution vector.

By keeping :math:`\alpha_i = 0` for :math:`i \notin S^k` we are essentially leaving out corresponding
columns :math:`\phi_i` from our calculations.

Thus we pickup up only the columns specified by :math:`S^k` from :math:`\Phi`. Let us call this matrix
as :math:`\Phi_{S^k}`. The size of this matrix is :math:`N \times | S^k |`. 
Let us call corresponding sub vector as :math:`\alpha_{S^k}`.

E.g. suppose :math:`D=4`, then :math:`\Phi = \begin{bmatrix} \phi_1 & \phi_2 & \phi_3 & \phi_4 \end{bmatrix}`.
Let :math:`S^k = \{1, 4\}`. Then :math:`\Phi_{S^k} = \begin{bmatrix} \phi_1 & \phi_4 \end{bmatrix}` and
:math:`\alpha_{S^k} = (\alpha_1, \alpha_4)`.

Our minimization problem then reduces to minimizing :math:`\|\Phi_{S^k} \alpha_{S^k} - x \|_2`.

We use standard least squares estimate for getting the coefficients for :math:`\alpha_{S^k}` over these indices.
We put back :math:`\alpha_{S^k}` to obtain our new solution estimate :math:`\alpha^k`.

In the running example after obtaining the values :math:`\alpha_1` and :math:`\alpha_4`, we will have 
:math:`\alpha^k = (\alpha_1, 0 , 0, \alpha_4)`.

The solution to this minimization problem is given by


.. math:: 

    \Phi_{S^k}^H ( \Phi_{S^k}\alpha_{S^k} - x ) = 0 
    \implies \alpha_{S^k} = ( \Phi_{S^k}^H \Phi_{S^k} )^{-1} \Phi_{S^k}^H x


Interestingly we note that :math:`r^k = x - \Phi \alpha^k = x - \Phi_{S^k} \alpha_{S^k}`, thus


.. math:: 

    \Phi_{S^k}^H r^k = 0

which means that columns in :math:`\Phi_{S^k}` which are part of support :math:`S^k` are necessarily
orthogonal to the residual :math:`r^k`. This implies that these columns will not be considered
in the coming iterations for extending the support. This orthogonality is the reason
behind the name of the algorithm as OMP.
* [Update residual] We finally update the residual vector to :math:`r^k` based on new solution 
vector estimate.





    


 
