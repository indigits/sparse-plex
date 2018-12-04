
 
Notation and problem formulation
===================================================

.. contents:: :local:

First some general 
notation for vectors and matrices.
For a vector :math:`v \in \RR^n`, its support
is denoted by :math:`\supp(v)` and is defined as
:math:`\supp(v) \triangleq \{i : v_i \neq 0, 1 \leq i \leq n \}`.
:math:`|v|` denotes a vector obtained by taking the absolute
values of entries in :math:`v`.  
:math:`\OneVec_n \in \RR^n` denotes a vector whose each entry is :math:`1`.
:math:`\| v \|_p` denotes
the :math:`\ell_p` norm of :math:`v`. :math:`\| v \|_0` denotes 
the :math:`\ell_0`-"norm" of :math:`v`.
Let :math:`A` be any :math:`m \times n` real matrix 
(:math:`A \in \RR^{m \times n}`). 
:math:`a_{i, j}` is the element at the :math:`i`-th row
and :math:`j`-th column of :math:`A`. :math:`a_j` with
:math:`1 \leq j \leq n` denotes the :math:`j`-th column
vector of :math:`A`.   :math:`\underline{a}_i` with
:math:`1 \leq i \leq m` denotes the :math:`i`-th row vector of
:math:`A`. :math:`a_{j,k}` is the :math:`k`-th entry in :math:`a_j`. 
:math:`\underline{a}_{i,k}` is the :math:`k`-th entry in
:math:`\underline{a}_i`. 
:math:`A_{\Lambda}` denotes a submatrix of :math:`A`
consisting of columns indexed by 
:math:`\Lambda \subset \{1, \dots, n \}`.
:math:`\underline{A}_{\Lambda}`  denotes a 
submatrix of :math:`A` consisting of rows indexed 
by :math:`\Lambda \subset \{1, \dots, m \}`.
:math:`|A|` denotes  
matrix consisting of absolute values of entries in :math:`A`.


:math:`\supp(A)` denotes the index set of 
non-zero rows of :math:`A`.
Clearly, :math:`\supp(A) \subseteq \{1, \dots, m\}`.
:math:`\| A \|_{0}` denotes the number
of non-zero rows of :math:`A`. Clearly, 
:math:`\| A \|_{0} = |\supp(A)|`.
We note that while :math:`\| A \|_{0}`
is not a norm, its behavior is similar to the
:math:`l_0`-"norm" for vectors :math:`v \in \RR^n` defined
as :math:`\| v \|_0 \triangleq | \supp(v) |`.
:math:`\OneVec_n \in \RR^n` denotes a vector consisting
of all :math:`1\text{s}`.


We use :math:`f(x)` and :math:`F(x)` to denote the
PDF and CDF of a continuous random variable.
We use :math:`p(x)` to denote the PMF of a 
discrete random variable. We use
:math:`\PP(E)` to denote the probability of 
an event.


 
Problem formulation
----------------------------------------------------

The data set can be modeled as a set of data points
lying in a union of low dimensional linear or affine subspaces in a
Euclidean space :math:`\RR^M` 
where :math:`M` denotes the dimension of ambient space. 
Let the data set be :math:`\{ y_j  \in \RR^M \}_{j=1}^S`
drawn from the union of subspaces under consideration.
:math:`S` is the total number of data points being analyzed
simultaneously.
We put the data points together in a *data matrix* as


.. math::
    Y  \triangleq \begin{bmatrix}
    y_1 & \dots & y_S
    \end{bmatrix}.

The data matrix :math:`Y` off course is known to us. 

We will slightly abuse the notation
and let :math:`Y` denote the *set* of data points :math:`\{ y_j  \in \RR^M \}_{j=1}^S` also. We will use the terms data points and vectors interchangeably in 
the sequel. 
Let the vectors be drawn from a set of :math:`K` (linear or affine) subspaces, 
The number of subspaces may not be known in advance. 
The subspaces
are indexed by a variable :math:`k` with :math:`1 \leq k \leq K`.
The :math:`k`-th subspace is denoted by :math:`\UUU_k`. Let the 
(linear or affine) dimension
of :math:`k`-th subspace be :math:`\dim(\UUU_k) = D_k` with :math:`D_k \leq D`.
Here :math:`D` is an upper bound on the dimension of individual subspaces. 
We may or may not know :math:`D`. We assume that none of the
subspaces is contained in another. A pair of
subspaces may not intersect (e.g. parallel lines or planes),
may have a trivial intersection (lines passing through origin),
or a non-trivial intersection (two planes intersecting at a line).
The collection of subspaces may also be independent or disjoint. 

The vectors in :math:`Y` can be grouped (or segmented or clustered) 
as submatrices 
:math:`Y_1, Y_2, \dots, Y_K` such 
that all vectors in :math:`Y_k` lie in subspace :math:`\UUU_k`. 
Thus, we can write


.. math::
    Y^* = Y \Gamma = \begin{bmatrix} y_1 & \dots & y_S \end{bmatrix} 
    \Gamma
    = \begin{bmatrix} Y_1 & \dots & Y_K \end{bmatrix} 

where :math:`\Gamma` is an :math:`S \times S` unknown permutation
matrix placing each vector to the right subspace. 
This segmentation is straight-forward if the (affine)
subspaces do not intersect or the subspaces intersect
trivially at one point (e.g. any pair of linear
subspaces passes through origin). 
Let there be :math:`S_k` vectors in :math:`Y_k` with
:math:`S = S_1 + \dots + S_K`. 
Naturally, we may not have any prior information about the 
number of points in individual subspaces.
We do typically require that there are enough vectors 
drawn from each subspace so that they can span the corresponding subspace.
This requirement may vary for individual subspace clustering algorithms.
For example, for linear subspaces, 
sparse representation based algorithms require that whenever
a vector is removed from :math:`Y_k`, the remaining set of vectors spans
:math:`\UUU_k`. This guarantees that every vector in :math:`Y_k` can be represented
in terms of other vectors in :math:`Y_k`. The minimum required :math:`S_k` for 
which this is possible is :math:`S_k = D_k + 1` when the data points
from each subspace are in general position (i.e. :math:`\spark(Y_k) = D_k + 1`).

Let :math:`Q_k` be an orthonormal basis for subspace :math:`\UUU_k`. Then,
the subspaces can be described as 


.. math::
    \UUU_k = \{ y \in \RR^M : y = \mu_k + Q_k \alpha \}, \quad 1 \leq k \leq K 

For linear subspaces, :math:`\mu_k = 0`.
We will abuse :math:`Y_k` to also denote the set of vectors from the
:math:`k`-th subspace. 

The basic objective of *subspace clustering* algorithms 
is to obtain a clustering or segmentation of vectors in :math:`Y`
into :math:`Y_1, \dots, Y_K`. This involves finding out the number
of subspaces/clusters :math:`K`, and placing each vector :math:`y_s` in its cluster correctly.
Alternatively, if we can identify :math:`\Gamma` and the numbers
:math:`S_1, \dots, S_K` correctly, we have solved the clustering
problem. Since the clusters fall into different subspaces, 
as part of subspace clustering, we may also identify
the dimensions :math:`\{D_k\}_{k=1}^K` of individual subspaces, the
bases :math:`\{ Q_k \}_{k=1}^K` and the offset vectors :math:`\{ \mu_k \}_{k=1}^K`
in case of affine subspaces. These quantities emerge due to 
modeling the clustering problem as a subspace clustering problem. 
However, they are not essential outputs of the subspace clustering algorithms.
Some subspace clustering algorithms may not calculate them, 
yet they are useful in the analysis of the algorithm. 
See :ref:`here <sec:data_clustering>` for a quick review of
data clustering terminology.

 
Noisy case
""""""""""""""""""""""""""""""""""""""""""""""""""""""

We also consider clustering of data points which are contaminated with
noise. The data points do not perfectly lie in a
subspace but can be approximated as a sum of a component which
lies perfectly in a subspace and a noise component. 
Let


.. math::
    y_s = \bar{y}_s + e_s , \quad \Forall 1 \leq s \leq S

be the :math:`s`-th vector that is obtained by corrupting
an error free vector :math:`\bar{y}_s` (which perfectly lies in
a low dimensional subspace) with a noise vector :math:`e_s \in \RR^M`.
The clustering problem remains the same. Our goal would
be to characterize the behavior of the clustering algorithm
in the presence of noise at different levels.


.. disqus::

