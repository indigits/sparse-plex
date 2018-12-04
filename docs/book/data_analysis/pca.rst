
.. _sec:pca:
 
Principal Component Analysis
----------------------------------------------------

Principal component analysis (PCA) :cite:`jolliffe2002principal`
is a statistical procedure that uses an orthogonal transformation to convert a set of observations of possibly correlated variables into a set of values of linearly uncorrelated variables called principal components.
This transformation is defined in such a way that the first principal component has the largest possible variance (that is, accounts for as much of the variability in the data as possible), and each succeeding component in turn has the highest variance possible under the constraint that it is orthogonal to the preceding components. The resulting vectors are an uncorrelated orthogonal basis set.
If a multivariate dataset is visualized as a set of coordinates in a high-dimensional data space (1 axis per variable), PCA can supply the user with a lower-dimensional picture, a projection of this object when viewed from its most informative viewpoint. 
PCA can be thought of as fitting an n-dimensional ellipsoid to the data, where each axis of the ellipsoid represents a principal component.

Consider a data-matrix :math:`X \in \RR^{n \times p}` 
:math:`(n \geq p)`
with each column
representing one feature (or random variable) 
and each row representing
one feature vector (or observation vector). Assume
that :math:`X` has column wise zero sample mean. 
The principal components decomposition of :math:`X`
is given by :math:`T = X V` where :math:`V` is a :math:`p \times p`
matrix whose columns are eigen vectors of :math:`X^T X`.
If each row of :math:`X` ( resp. T) is given by a (column) vector :math:`x` (resp. t), then they are related by
:math:`t = V^T x` or :math:`x = V t`. Each principal component
:math:`t_i` is obtained by taking the inner product
of an eigen vector :math:`v^i` in :math:`V` with :math:`x`.
:math:`T` can be obtained straight-away from the SVD of
:math:`X = U \Sigma V^T` giving :math:`T = X V = U \Sigma`.
Note that :math:`T^T T = \Sigma^T \Sigma` implying that
the columns of :math:`T` are orthogonal to each other.
In other words, the features (or random variables)
corresponding to each column of :math:`T` are uncorrelated.
Recall that :math:`T^T T` is proportional to the empirical
covariance matrix of :math:`T` and 
:math:`\sigma_1 \geq \dots  \geq \sigma_p` shows how variance
of individual columns in :math:`T` decreases. The
form :math:`T = U \Sigma` is also known as the polar
decomposition of :math:`T`.

The dimensionality reduction of data-set in :math:`X` is
obtained by keeping just the first :math:`k` columns of :math:`T`.



.. disqus::
