.. _sec:data_clustering:
 
Data Clustering Introduction
===================================================

In this section, we summarize some of the traditional 
and general purpose data clustering algorithms. These
algorithms get used as building blocks for various subspace
clustering algorithms. The objective of data clustering
is to group the data points into clusters such that
points within each cluster are more related to each other 
than points across different cluster. The relationship
can be measured in various ways: distance between points,
similarity of points, etc.
In distance based clustering, we group the points
into :math:`K` clusters such that the distance among points in the
same group is significantly smaller than those between clusters.
In similarity based clustering, 
the points within the same cluster are more similar
to each other than points from different cluster. 
A graph based clustering will treat each point as a node
on a graph [with appropriate edges] and split the graph
into connected components.
Compare this
with subspace clustering which assumes that points in each cluster
are sampled from one subspace [even though they may be far apart
within the subspace].

Simplest distance measure is the standard Euclidean distance measure.
But it is susceptible to the choice of basis. This can be improved
by adopting a statistical model for data in each cluster.
We assume that the data in :math:`k`-th cluster is sampled
from a probability distribution with mean :math:`\mu_k` and covariance
:math:`\Sigma_k`. An appropriate distance measure from the mean of a 
distribution which is invariant of the
choice of basis is the *Mahanalobis distance*:


.. math::
    d^2 (x_s, \mu_k) = \| x_s - \mu_k\|_{\Sigma_k}^2 = (x_s - \mu_k)^T \Sigma_k^{-1}(x_s - \mu_k).

For Gaussian distributions, this is proportional to the negative
of the log-likelihood of a sample point. 
A simple way to measure similarity between two points is the
absolute value of the inner product. Alternatively, one can
look at the angle between two points or inner product of the normalized
points. Another way to measure similarity is to consider the
inverse of an appropriate distance measure.


.. _sec:clustering:performance:measure:intro:
 
Measurement of clustering performance
----------------------------------------------------


In general a *clustering* :math:`\CCC` of a set :math:`Y` constructed
by a clustering algorithm
is a set
:math:`\{\CCC_1, \dots, \CCC_C\}` of non-empty disjoint subsets
of :math:`Y` such that their union equals :math:`Y`. Clearly: :math:`|\CCC_c| > 0`.


The clustering process may identify incorrect
number of clusters and :math:`C` may not be equal to :math:`K`. More-over
even if :math:`K = C`, 
the vectors may be placed in wrong clusters. Ideally, we want
:math:`K = C` and :math:`\CCC_c = Y_k` with a bijective mapping between
:math:`1 \leq c \leq C` and :math:`1 \leq k \leq K`.
In practice, a clustering algorithm estimates the number of
clusters :math:`C` and
assigns a label :math:`l_s`, :math:`1 \leq s \leq S` to each vector
:math:`y_s` where :math:`1\leq l_s \leq C`.  
All the labels can be put in a label vector :math:`L`
where :math:`L \in \{1, \dots, C\}^S`.
The permutation matrix :math:`\Gamma` can be easily 
obtained from :math:`L`.
 


Following :cite:`wagner2007comparing`, we will quickly establish the measures used in this work for 
clustering performance of synthetic experiments. 
We have a reference clustering of
vectors in :math:`Y` given by :math:`\BBB = \{Y_1, \dots, Y_K\}` which is known
to us in advance (either by construction in synthetic experiments or as ground truth with real life data-sets). 
The clustering obtained
by the algorithm is given by :math:`\CCC= \{\CCC_1, \dots, \CCC_C\}`. For
two arbitrary vectors :math:`y_i, y_j \in Y`, there are four possibilities:
a) they belong to same cluster in both :math:`\BBB` and :math:`\CCC` (true positive),
b) they are in same cluster in :math:`\BBB` but different cluster in :math:`\CCC`
(false negative)
c) they are in different clusters in :math:`\BBB` but in same cluster in :math:`\CCC`
d) they are in different clusters in both :math:`\BBB` and :math:`\CCC` (true negative).

Consider some cluster :math:`Y_i \in \BBB` and :math:`\CCC_j \in \CC`. 
The elements common to :math:`Y_i` and :math:`\CCC_j` are given by :math:`Y_i \cap \CCC_j`.
We define 
:math:`\text{precision}_{ij} \triangleq \frac{|Y_i \cap \CCC_j|}{|\CCC_j|}.`
We define the overall precision for :math:`\CCC_j` as 
:math:`\text{precision}(\CCC_j) \triangleq  \underset{i}{\max}(\text{precision}_{ij}).`
We define :math:`\text{recall}_{ij} \triangleq \frac{|Y_i \cap \CCC_j|}{|Y_i|}`.
We define the overall recall for :math:`Y_i` as 
:math:`\text{recall}(Y_i) \triangleq  \underset{j}{\max}(\text{recall}_{ij})`.
We define the :math:`F` score as
:math:`F_{ij} \triangleq \frac{2 \text{precision}_{ij} \text{recall}_{ij} }{\text{precision}_{ij} + \text{recall}_{ij}}.`
We define the overall :math:`F`-score for :math:`Y_i` as 
:math:`F(Y_i) \triangleq  \underset{j}{\max}(F_{ij}).`
We note that cluster :math:`\CCC_j` for which the maximum is achieved is best matching cluster
for :math:`Y_i`.
Finally, we define the overall :math:`F`-score for the clustering 
:math:`F(\mathcal{B}, \mathcal{C}) \triangleq  \frac{1}{S}\sum_{i=1}^p |Y_i | F(Y_i)`
where :math:`S` is the total number of vectors in :math:`Y`.
We also define a clustering ratio given by the factor 
:math:`\eta \triangleq \frac{C}{K}`.

There are different ways to define *clustering error*.
For the special case where the number of clusters is known in advance,
and we ensure that the data-set is divided into exactly those many
clusters, it is possible to define subspace clustering error as
follows:


.. math::
    \text{subspace clustering error} = \frac{\text{\# of misclassified points}}
    {\text{total \# of points}}.

The definition is adopted from :cite:`elhamifar2013sparse` for comparing
the results in this work with their results. This definition can be
used after a proper one-one mapping between original labels
and cluster labels assigned by the clustering algorithms has been 
identified. We can compute this mapping by comparing :math:`F`-scores.



.. disqus::




