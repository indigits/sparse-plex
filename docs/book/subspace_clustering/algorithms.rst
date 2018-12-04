
 
Algorithms
===================================================

A number of algorithms have been developed to address the
subspace clustering problem over last  3 decades. They 
can be largely classified under: algebraic methods, iterative
methods, statistical methods, spectral clustering 
and sparse representations based methods. Some algorithms 
combine ideas from different approaches.
In the following, we review a set of representative algorithms
from the literature.

Algebraic methods include: matrix factorization based
algorithms, Generalized Principal Component Analysis (GPCA).

Iterative methods include: :math:`K`-plane clustering, :math:`K`-subspace clustering,
Expectation-Maximization based subspace clustering.

Statistical methods include: Mixture of Probabilistic Principal Component
Analysis (MPPCA), ALC, Random Sampling Consensus (RANSAC).

Spectral clustering based methods include: Spectral Curvature Clustering
(SCC).

Sparse representations based methods in turn use spectral clustering
as a post processing step. These methods include: Low Rank Representation (LRR), Sparse Subspace Clustering via :math:`\ell_1` minimization (SSC-:math:`\ell_1`),
Sparse Subspace Clustering via Orthogonal Matching Pursuit (SSC-OMP).

Some algorithms assume that the subspaces are independent.
Some algorithms are capable of handling subspaces which
may not be independent but are disjoint. Some algorithms
can allow for arbitrary intersection between subspaces too.
The performance of an algorithm depends on a number of
parameters: ambient space dimension,
number of subspaces, dimension of each subspace,
number of points in each subspace and their distribution within
the subspace, the separation between subspaces (in terms of say
subspace angles). We provide relevant commentary on the 
features and capabilities of each algorithm.

Some algorithms have explicit support for handling affine
subspaces. Many of them are designed for linear subspaces 
only. This is not a handicap in general as a :math:`d`-dimensional 
affine subspace in :math:`\RR^M` can easily be mapped to a 
:math:`d+1`-dimensional linear
subspace in :math:`\RR^{M + 1}` by using homogeneous coordinates.
This representation is one-to-one. The only downside is
that we have to add one more coordinate in the ambient space.
This may not be an issue if :math:`M` is large.

When :math:`M` is very large (say images), then it may be useful
to perform a dimensionality reduction in advance before 
applying a subspace clustering algorithm. With
the union of subspaces being
:math:`Z_{\UUU} = \UUU_1 \cup \dots \cup \UUU_K`,
two situations are possible. The linear span 
of :math:`Z_{\UUU}` is a proper low dimensional subspace
of :math:`\RR^M`. In this case, a direct PCA on the dataset 
pretty good in achieving the dimensional reduction.
Alternatively the dimension of :math:`\text{span}(Z_{\UUU})`
may be very large even though individual subspace dimensions
:math:`D_k` are small. Now, let :math:`D_{\max} = \max(\{ D_k \}`. 
If :math:`D_{\max}` is known and :math:`D_{\max} < M - 1`, 
then we can choose a  :math:`D_{\max}+1` dimensional subspace
which can preserve the separation and dimension of 
all the subspaces :math:`\UUU_k` 
and project all the points to it. Such a subspace
may be chosen either randomly or using special
purpose methods :cite:`broomhead2000new`. Note that
such a projection may not preserve distances
between points or angles between subspaces fully.
An approximately distance preserving projection
may require larger dimension subspace 
:cite:`dasgupta1999elementary`.




.. disqus::
























