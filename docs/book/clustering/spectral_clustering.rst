.. _sec:spectral_clustering:
 
Spectral Clustering
----------------------------------------------------

Spectral clustering is a graph based clustering algorithm :cite:`von2007tutorial`.
:math:`\GGG = \{T, W\}` to obtain the
clustering :math:`\CCC` of :math:`X`. More specifically, the following
steps are performed. The degree of a vertex :math:`t_s \in T`
is defined as :math:`d_s = \sum_{j = 1}^S w_{s j}`. The
*degree matrix* :math:`D` is defined as the diagonal matrix with the degrees
:math:`\{ d_s \}_{s =1 }^S`. The unnormalized graph Laplacian is defined
as :math:`\LLL = D - W`. The normalized graph Laplacian is defined as
:math:`\LLL_{\text{rw}} \triangleq D^{-1} \LLL = I - D^{-1} W`
\footnote{We specifically use the random walk version of normalized
Graph Laplacian as defined in :cite:`von2007tutorial`. There
are other ways to define normalized graph Laplacian.}. The
subscript :math:`\text{rw}` stands for random walk. We compute 
:math:`\LLL_{\text{rw}}` and examine its eigen-structure to estimate the
number of clusters :math:`C` and the label vector :math:`L`. If :math:`C` is known
in advance, usually the first :math:`C` eigen vectors of :math:`\LLL_{\text{rw}}` 
corresponding to the smallest eigen-values are taken and their row
vectors are clustered using K-means algorithm :cite:`shi2000normalized`.
Since, we don't make any assumption on the number of clusters, we need
to estimate it. A simple way is to track the eigen-gap statistic. 
After arranging the eigen values in increasing order,
we
can choose the number :math:`C` such that the eigen values :math:`\lambda_1, \dots, \lambda_C`
are very small and :math:`\lambda_{C + 1}` is large. This is guided by
the theoretical results that if a Graph has :math:`C` connected components
then exactly :math:`C` eigen values of :math:`\LLL_{\text{rw}}` are 0. 
However, when the
subspaces are not clearly separated, and noise is introduced, this approach
becomes tricky. We go for a more robust approach by 
analyzing the eigen vectors as described in :cite:`zelnik2004self`.
The approach of :cite:`zelnik2004self`, with a slightly different definition of
the graph Laplacian :math:`(D^{-1/2} W D^{-1/2})` :cite:`ng2002spectral`,
has been adapted for working with the Laplacian 
:math:`\LLL_{\text{rw}}` as defined above.

 
Robust estimation of number of clusters
""""""""""""""""""""""""""""""""""""""""""""""""""""""

In step 6, we estimate the number of clusters from the Graph
Laplacian.
It can be easily shown that :math:`0` is an eigen value of :math:`\LLL_{\text{rw}}`
with an eigen vector :math:`\OneVec_S` :cite:`von2007tutorial`. Further, 
the multiplicity of eigen value 0 equals the number of connected
components in :math:`\GGG`. In fact the adjacency matrix can be 
factored as


.. math::
    W = \begin{bmatrix}
    W_1 & \dots  & 0\\
    \vdots & \ddots & \vdots \\
    0 & \dots & W_P
    \end{bmatrix} \Gamma

where :math:`W_p \in \RR^{S_p \times S_p}` is the adjacency matrix for the 
:math:`p`-th connected component of :math:`\GGG` corresponding to the subspace :math:`\UUU^p`
and :math:`\Gamma` is the unknown permutation matrix. 
The graph Laplacian for each :math:`W_p` has an eigen
value :math:`0` and the eigen-vector :math:`\OneVec_{S_p}`. Thus, if we look at the
:math:`P`-dimensional eigen-space of :math:`\LLL_{\text{rw}}` corresponding to eigen value :math:`0`,
then there exists a basis :math:`\widehat{V} \in \RR^{S \times P}` such that each row of :math:`\widehat{V}` is a 
unit vector in :math:`\RR^P` and the columns contain :math:`S_1, \dots, S_P` ones. 
Actual eigen vectors obtained through any numerical method will be a rotated version of :math:`\widehat{V}` 
given by :math:`V = \widehat{V} R`. :cite:`zelnik2004self` suggests a cost function over
the entries in :math:`V` such that the cost is minimized when the rows of :math:`V` are close to coordinate
vectors. It then estimates a rotation matrix as a product of Givens rotations which can rotate :math:`V`
to minimize the cost. The parameters of the rotation matrix are the angles of Givens rotations
which are estimated through a Gradient descent process. Since :math:`P` is unknown, the algorithm
is run over multiple values of :math:`C` and we choose the value which gives minimum cost. 
Note that, we reuse the rotated version of :math:`V` obtained for a particular value of :math:`C`
when we go for examining :math:`C+1` eigen-vectors. This may appear to be ad-hoc, but is seen to help in faster convergence of the
gradient descent algorithm for next iteration.

When :math:`S` is small, we can do a complete SVD of :math:`\LLL_{\text{rw}}` to get the eigen vectors.
However, this is time consuming when :math:`S` is large (say 1000+). An important question is
how many eigen vectors we really need to examine! As :math:`C` increases, the number of Givens
rotation parameters increase as :math:`C(C-1)/2`. 
Thus, if we examine too many eigen-vectors, we will lose
out unnecessarily on speed.
We can actually use the eigen-gap 
statistic described above to decide how many eigen vectors we should examine. 
 
Finally, we assign labels to each data point to identify the cluster they belong to.
As described above, we maintain the rotated version of :math:`V` during the estimation
of rotation matrix. Once, we have zeroed in on the right value of :math:`C`, then
assigning labels to :math:`x^s` is straight-forward. We simply perform *non-maximum suppression*
on the rows of V, i.e. we keep the largest (magnitude) entry in each row of :math:`V`
and assign zero to the rest. The column number of the largest entry in the :math:`s`-th row of :math:`V` 
is the label :math:`l_s` for :math:`x^s`. This completes the clustering process.

While eigen gap statistic based estimation of number of clusters is quick,
it requires running an additional :math:`K`-means algorithm step on the first :math:`C`
eigen vectors to assign the labels. In contrast, eigen vector based estimation
of number of clusters is involved and slow but it allows us to pick the
labels very quickly.

.. disqus::
