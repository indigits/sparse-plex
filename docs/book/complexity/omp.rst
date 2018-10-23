
 
Orthogonal Matching Pursuit
===================================================

.. _sec:complexity:omp:
We are modeling a signal :math:`y \in \RR^M` in a dictionary 
:math:`\Phi \in \RR^{M \times N}` consisting of :math:`N` atoms as :math:`y = \Phi x + r` where 
:math:`r` is the approximation error. Our objective is to construct
a sparse model :math:`x \in \RR^N`. 
:math:`\Lambda = \supp(x)` is the set
of indices on which :math:`x_i` is non-zero. 
:math:`K = \| x \|_0 = | \supp(x) |` is the 
so called :math:`\ell_0`-"norm" of :math:`x` which
is the number of non-zero entries in :math:`x`.

A sparse recovery or approximation algorithm
need not provide the full vector :math:`x`. It 
can provide the positions of non-zero 
entries :math:`\Lambda` and corresponding values
:math:`x_{\Lambda}` requiring :math:`2K` units of storage
where :math:`x_{\Lambda} \in \RR^{K}` consists of
entries from :math:`x` indexed by :math:`\Lambda`. 
:math:`\Phi_{\Lambda}` denotes the submatrix 
constructed by picking columns indexed by :math:`\Lambda`.

Orthogonal Matching Pursuit is presented below.


.. _alg:omp_rip:

.. figure:: ../pursuit/omp/images/algorithm_orthogonal_matching_pursuit.png


OMP builds the support incrementally. In each iteration, one more
atom is added to the support set for :math:`y`. We terminate the algorithm
either after a fixed number of iterations :math:`K` or when the magnitude of
residual :math:`\| y  - \Phi x \|_2` reaches a specified threshold.

Following analysis assumes that the main loop of OMP
runs for :math:`K` iterations.  The iteration counter
:math:`k` varies from :math:`1` to :math:`K`. The counter is increased
at the beginning of the iteration. Note that  :math:`K \leq M`.


Matching step requires the multiplication of :math:`\Phi^T \in \RR^{N \times M}`
with :math:`r^{k-1}\in \RR^{M}` (the residual after :math:`k-1` iterations).
It requires :math:`2MN` flops at maximum.
OMP has a property that the residual after :math:`k`-th iteration
is orthogonal to the space spanned by the atoms selected
till :math:`k`-th iteration :math:`\{\phi_{\lambda_1}\dots \phi_{\lambda_k}\}`. Thus, the inner product of these atoms
with :math:`r` is 0 and we can safely ignore these columns.
This reduces flop count to :math:`2M(N-k+1)`.

Identification step requires :math:`2N` flops. This 
includes :math:`N` flops for taking absolute values
and :math:`N` flops for finding the maximum. 

:math:`\Lambda` is easily implemented in the form of an array
whose length is indicated by the iteration 
counter :math:`k`. A large array (of size :math:`M`) can be allocated
in advance for maintaining :math:`\Lambda`. Thus, support
update operation requires a single flop and we will
ignore it. :math:`\Lambda^{k}` contains :math:`k` indices.

While the algorithm shows the full sparse vector :math:`x`,
in practice, we only need to reserve space for 
:math:`x_{\Lambda}` which is an array with maximum size of
:math:`M` and can be preallocated. 
:math:`\Phi_{\Lambda^{k}}` need not be stored separately.
This can be obtained from :math:`\Phi` by proper indexing
operations. Its size is :math:`M \times k`.

Let's skip the least squares step for updating representation
for the moment.

Once :math:`x^{k}_{\Lambda^{k}}` has been computed,
computing the approximation :math:`y^{k}` takes
:math:`2Mk` flops. 

Updating the residual :math:`r^{k}` takes :math:`M` flops 
as both :math:`y` and :math:`y^{k}` belong to :math:`\RR^{M}`.
Updating iteration counter takes 1 flop and can
be ignored.


 
Least Squares through  QR Update
----------------------------------------------------

.. _sec:complexity:omp:qr:
Let's come back to the least squares step.
Assume that :math:`\Phi_{\Lambda^{k-1}}` has a QR decomposition
:math:`Q_{k-1} R_{k-1}`. Addition of :math:`\phi_{\lambda^{k}}`
to :math:`\Phi_{\Lambda^k}` requires us updating the
QR decomposition to :math:`Q_{k} R_{k}`.
Following :ref:`here <alg:gram_schmidt_colwise>`, 
Computing and subtracting projection of :math:`\phi_{\lambda^{k}}`
for each normalized column in :math:`Q_{k-1}` requires :math:`4M-1` flops.
This loop is run  :math:`{k-1}` times. Computing norm and
division requires :math:`3M+1` flops. The whole QR 
update step requires :math:`(k-1)(4M-1) + 3M + 1` flops.
We are assuming that enough space has been preallocated
to maintain :math:`Q_k` and :math:`R_k`. Solving the least squares
problem requires additional steps of 
computing the projection :math:`d = Q^T y` (:math:`2M` flops
for the new entry in :math:`d`) 
and solving
:math:`R x = d` by back substitution (:math:`k^2` flops).
Thus, QR update based least squares solution requires
:math:`(k-1)(4M-1) + 3M + 1 + 2M + k^2` flops.

Refer to :ref:`here <tbl:complexity:omp:qr:steps>` for a summary of
all the steps.

Finally, we can put together the cost of all steps 
in the main loop of OMP as


.. math:: 

    2M(N-k+1) + 2N + 2Mk + M + (k-1)(4M-1) + 3M + 1 + 2M + k^2.

This simplifies to :math:`4\,M+2\,N-k+4\,M\,k+k^2+2\,M\,N+2`.
Summing over :math:`k \in \{1,\dots, K\}`, we obtain


.. math::
    \frac{5\, K}{3} + 2\, K^2\, M + \frac{K^3}{3} + 6\, K\, M + 2\, K\, N + 2\, K\, M\, N.


For a specific setting of :math:`K = \sqrt{M} / 2` and :math:`M = N/2`, we get


.. math::
    \frac{5\,\sqrt{2}\,\sqrt{N}}{12}+\frac{121\,\sqrt{2}\,N^{3/2}}{96}+\frac{\sqrt{2}\,N^{5/2}}{4}+\frac{N^2}{8}
    \approx \frac{\sqrt{2}\,N^{5/2}}{4}.

In terms of :math:`M`, it will simplify to: 


.. math::
    \frac{M^2}{2}+\frac{5\,\sqrt{M}}{6}+\frac{121\,M^{3/2}}{24}+2\,M^{5/2}
    \approx 2\,M^{5/2}.


In a typical sparse approximation problem, we have
:math:`K < M \ll N`. Thus, the flop count will be
approximately :math:`2KMN`.

Total flop count of matching step over all iterations
is :math:`K\, M - K^2\, M + 2\, K\, M\, N`. 
Total flop count of least squares step over all
iterations is 
:math:`\frac{5\, K}{3} + 2\, K^2\, M + \frac{K^3}{3} + 3\, K\, M`.
This suggests that the matching step is the dominant step
for OMP.



.. _tbl:complexity:omp:qr:steps:

.. code-block:: 

    \centering
    \caption{Operations in OMP using QR update}
    \begin{tabular}{c | c}
    \hline
    Operation & Flops \\
    \hline
    :math:`\Phi^T r` & :math:`2M(N - k +1)`\\
    Identification  & :math:`2N` \\
    :math:`y^{k} = \Phi_{\Lambda^{k}} x_{\Lambda^{k}}^{k}` & :math:`2Mk`\\
    :math:`r^k = y - y^k` & :math:`M` \\
    QR update & :math:`(k-1)(4M-1) + 3M + 1` \\
    Update :math:`d = Q_k^T y` &  :math:`2M` \\
    Solve :math:`R_k x = d` & :math:`k^2` \\
    \hline
    \end{tabular}




 
Least Squares through  Cholesky Update
----------------------------------------------------

.. _sec:complexity:omp:chol:
If the OMP least squares step is computed through Cholesky decomposition,
then we maintain the Cholesky decomposition of :math:`G = \Phi_{\Lambda}^T \Phi_{\Lambda}`
as :math:`G = L L^T`. Then


.. math::
        \begin{aligned}
            &x = \Phi_{\Lambda}^{\dag} y\\
            \iff  & x = (\Phi_{\Lambda}^T \Phi_{\Lambda})^{-1} \Phi_{\Lambda}^T y\\
            \iff  & (\Phi_{\Lambda}^T \Phi_{\Lambda}) x = \Phi_{\Lambda}^T y\\
            \iff & LL^T x = \Phi_{\Lambda}^T y = b
        \end{aligned}

In each iteration, we need to update :math:`L_k`, compute :math:`b = \Phi_{\Lambda}^T y`,
solve :math:`L u = b` and then solve :math:`L^T x = u`.
Now,


.. math::
    \Phi_{\Lambda^k}^T \Phi_{\Lambda^k} = \begin{bmatrix}
       \Phi_{\Lambda^{k-1}}^T \Phi_{\Lambda^{k-1}}  & \Phi_{\Lambda^{k-1}}^T \phi_{\lambda^k}\\
       \phi_{\lambda^k}^T \Phi_{\Lambda^{k-1}} & \phi_{\lambda^k}^T \phi_{\lambda^k}
    \end{bmatrix}.

Define :math:`v = \Phi_{\Lambda^{k-1}}^T \phi_{\lambda^k}`. We have


.. math::
        G^k = \begin{bmatrix}
            G^{k - 1} & v \\
            v^T & 1 
        \end{bmatrix}.

The Cholesky update is given by:


.. math::
    L^k = \begin{bmatrix}
        L^{k - 1} & 0 \\
        w^T &  \sqrt{1 - w^T w} 
    \end{bmatrix}

where solving :math:`L^{k - 1} w = v` gives us :math:`w`.
For the first iteration, :math:`L^1 = 1` since the atoms in :math:`\Phi`
are normalized.

Computing :math:`v` would take :math:`2M(k-1)` flops.
Computing :math:`w` would take :math:`(k-1)^2` flops. 
Computing :math:`\sqrt{1-w^T w}` would take another :math:`2k` flops.
Thus, Cholesky update requires :math:`2M(k-1) + 2k + (k-1)^2` flops.
Then computing :math:`b = \Phi^T_{\Lambda} y` requires only updating the
last entry in :math:`b` which requires :math:`2M` flops. Solving :math:`LL^T x = b`
requires :math:`2k^2` flops.


.. _tbl:complexity:omp:chol:steps:

.. code-block:: 

    \centering
    \caption{Operations in OMP using Cholesky update}
    \begin{tabular}{c | c}
    \hline
    Operation & Flops \\
    \hline
    :math:`\Phi^T r` & :math:`2M(N - k +1)`\\
    Identification  & :math:`2N` \\
    :math:`y^{k} = \Phi_{\Lambda^{k}} x_{\Lambda^{k}}^{k}` & :math:`2Mk`\\
    :math:`r^k = y - y^k` & :math:`M` \\
    Cholesky update & :math:`2M(k-1) + 2k + (k-1)^2` \\
    Update :math:`b = \Phi^T_{\Lambda} y` &  :math:`2M` \\
    Solve :math:`LL^T x = b` & :math:`2k^2` \\
    \hline
    \end{tabular}



We can see that for :math:`k \ll M`, QR update is around :math:`4Mk` flops
while Cholesky update is around :math:`2Mk` steps (asymptotically).

Flop counts for the main loop of OMP using Cholesky update is


.. math::
    3\,k^2+2\,M\,k+3\,M+2\,N+2\,M\,N+1.

Summing over :math:`k \in [K]`, we get total flop count for OMP as


.. math::
    :label: eq:complexity:omp_chol_basic

    \frac{3\,K}{2}+K^2\,M+\frac{3\,K^2}{2}+K^3+4\,K\,M+2\,K\,N+2\,K\,M\,N.



For a specific setting of :math:`K = \sqrt{M} / 2` and :math:`M = N/2`, we get
In terms of :math:`M`, it will simplify to: 


.. math::
    \frac{3\,M}{8}+\frac{M^2}{4}+\frac{3\,\sqrt{M}}{4}+\frac{33\,M^{3/2}}{8}+2\,M^{5/2}
    \approx 2\,M^{5/2}.

In a typical sparse approximation problem, we have
:math:`K < M \ll N`. Thus, the flop count will be
approximately :math:`2KMN` i.e. dominated by the matching step.


Cholesky update based solution is marginally faster than QR update based solution
for small values of :math:`M`.