
 
Introduction
===================================================


High dimensional data-sets are now pervasive in various signal 
processing applications. 
For example, high resolution surveillance cameras are now commonplace
generating millions of images continually. 
A major factor in the success of current generation signal processing
algorithms is the fact that, even though these data-sets are high
dimensional, their intrinsic dimension is often much smaller than
the dimension of the ambient space. 

One resorts to inferring (or learning) a quantitative model 
:math:`\mathbb{M}` of a given set of data points 
:math:`Y = \{ y_1, \dots, y_S\} \subset \RR^M`.
Such a model enables us to obtain a low dimensional representation 
of a high dimensional data set. 
The low dimensional representations
enable efficient implementation of acquisition, compression, 
storage, and various statistical inferencing tasks without losing
significant precision. There is no such thing as a perfect model.
Rather, we seek a model :math:`\mathbb{M}^*` that is best amongst a 
restricted class of
models :math:`\mathcal{M} = \{ \mathbb{M} \}` which is rich enough to 
describe the data set to a desired accuracy yet restricted
enough so that selecting the best model is tractable.

In absence of training data, the problem of modeling falls
into the category of *unsupervised learning*. There
are two common viewpoints of data modeling. A *statistical*
viewpoint assumes that data points are random samples from
a probabilistic distribution. *Statistical models* try
to learn the distribution from the dataset. In contrast,
a *geometrical* viewpoint assumes that data points 
belong to a geometrical object (a smooth manifold or a topological
space). A *geometrical model* attempts to learn the shape of
the object to which the data points belong. Examples of 
statistical modeling include maximum likelihood, 
maximum a posteriori estimates, Bayesian models etc. 
An example of geometrical models is 
Principal Component Analysis (PCA) 
which assumes that data
is drawn from a low dimensional subspace of the high dimensional
ambient space. PCA is simple to implement and has found 
tremendous success in different fields e.g., pattern recognition,
data compression, image processing, computer vision, etc.
\footnote{PCA can also be viewed as a statistical model. 
When the data points are independent samples drawn from 
a Gaussian distribution, the geometric formulation of PCA
coincides with its statistical formulation.}

The assumption that all the data points in a data set could be
drawn from a single model however happens
to be a stretched one. In practice, it often occurs that
if we *group* or *segment* the data set :math:`Y` into
multiple disjoint subsets: 
:math:`Y = Y_1 \cup \dots \cup Y_K`,
then each subset can be modeled sufficiently well by a model
:math:`\mathbb{M}_k^*` (:math:`1 \leq k \leq K`) chosen from a simple model class.
Each model :math:`\mathbb{M}_k^*` is called a *primitive* or *component*
model. In this sense, the data set :math:`Y` is called a *mixed*
dataset and the collection of primitive models is called a
*hybrid* model for the dataset. Let us look at some examples
of mixed data sets.

Consider the problem of *vanishing point detection* in computer
vision. Under perspective projection, a group of parallel lines 
pass through a common point in the image plane which is known as
the vanishing point for the group. For a typical scene consisting
of multiple sets of parallel lines, the problem of detecting
all vanishing points in the image plane 
from the set of edge segments (identified in the image) can be 
transformed into clustering points (in edge segments) into
multiple 2D subspaces in :math:`\RR^3` (world coordinates of the scene).

In the *Motion segmentation* problem, an image
sequence consisting of multiple moving objects is
segmented so that each segment consists of motion 
from only one object. This is a fundamental problem
in applications such as motion capture, vision based navigation,
target tracking and surveillance. We first track the
trajectories of feature points (from all objects) over the image
sequence. It has been shown (see :ref:`here <sec:motion_segmentation>`)
that trajectories of feature points for rigid motion
for a single object form a low dimensional subspace.
Thus motion segmentation problem can be solved by
segmenting the feature point trajectories  
for different objects separately and estimating
the motion of each object from corresponding trajectories.

In a *face clustering* problem, we have 
a collection of unlabeled images of different faces taken
under varying illumination conditions. Our goal is to
cluster, images of the same face in one group each.
For a Lambertian object, it has been shown
that the set of images taken under different lighting 
conditions forms a cone in the image space. This cone
can be well approximated by a low-dimensional subspace :cite:`basri2003lambertian,ho2003clustering`.  The images of the face
of each person form one low dimensional subspace and the face clustering
problem reduces to clustering the collection of images to 
multiple subspaces. 

As the examples above suggest, a typical hybrid model 
for a mixed data set consists of multiple primitive models
where each primitive is a (low dimensional) subspace. 
The data set is modeled as being sampled from a collection
or arrangement :math:`\UUU` of linear (or affine) subspaces
:math:`\UUU_k \subset \RR^M` : 
:math:`\UUU = \{ \UUU_1  , \dots , \UUU_K \}`. 
The union of the subspaces
\footnote{In the sequel, we would use the
terms arrangement and union interchangeably. 
For more discussion see :ref:`here <sec:algebraic_geometry>`.} 
is denoted as
:math:`Z_{\UUU} = \UUU_1 \cup \dots \cup \UUU_K`.
This is indeed a geometric
model.
In such modeling problems, 
individual subspaces (dimension and orientation of each subspace and total number of subspaces) and 
the membership of a data point (a single image
in the face clustering problem) to a particular subspace is 
unknown beforehand. This entails the need for algorithms
which can simultaneously identify the subspaces
involved and cluster/segment 
the data points from individual subspaces
into separate groups. 
This problem is known as *subspace clustering* which is the
focus of this paper. 
An earlier detailed introduction to subspace clustering can be found in 
:cite:`vidal2010tutorial`.

An example of a statistical hybrid model is a Gaussian Mixture
Model (GMM) where one assumes that the sample points are drawn
independently from a mixture of Gaussian distributions. 
A way of estimating such a mixture model is the 
expectation maximization (EM) method.

The fundamental difficulty in the estimation of hybrid models
is the "chicken-and-egg" relationship between data segmentation
and model estimation. If the data segmentation was known,
one could easily fit a primitive model to each subset. 
Alternatively, if the constituent primitive models were known,
one could easily segment the data by choosing the best model
for each data point. An iterative approach starts with 
an initial (hopefully good) guess of primitive models 
or data segments. It then alternates between estimating
the models for each segment and segmenting the data based
on current primitive models till the solution converges.
On the contrary, a global algorithm can perform the segmentation
and primitive modeling simultaneously. In the sequel, we will
look at a variety of algorithms for solving the subspace
clustering problem.

.. disqus::
