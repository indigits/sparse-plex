Sparse Signal Models
======================================

.. toctree::
   :maxdepth: 1
   
   sparse_signal_models/underdetermined



Outline
----------------


In this chapter we develop initial concepts of sparse signal models.


We begin our study with a review of solutions of under-determined systems.
We build a case for solutions which promote sparsity. 

We show that although the real life signals may not be sparse yet they
are compressible and can be approximated with sparse signals.

We then review orthonormal bases and explain the inadequacy of those bases
in exploiting the sparsity in many signals of interest. We develop an
example of Dirac Fourier basis as a two ortho basis and demonstrate how
it can better exploit signal sparsity compared to Dirac basis and Fourier
basis individually.

We follow this with a general discussion of redundant signal dictionaries. 
We show how they can be used to create sparse and redundant signal representations.

We study various properties of signal dictionaries which are useful in
characterizing the capabilities of a signal dictionary in exploiting signal sparsity.

In this chapter, our signals of interest will typically lie in the finite :math:`N`-dimensional complex vector space :math:`\CC^N`.
Sometimes we will restrict our attention to the :math:`N` dimensional Euclidean space to simplify discussion.

We will be concerned with different representations of our signals of interest in
:math:`\CC^D` where :math:`D \geq N`. This aspect will become clearer as we go along in this chapter.


Sparsity
-------------


We quickly define the notion of sparsity in a signal.

We recall the definition
of :math:`l_0`-"norm" (don't forget the quotes) of :math:`x \in \CC^N` given by

.. math::

  \| x \|_0 = | \supp(x) |

where :math:`\supp(x) = \{ i : x_i \neq 0\}` denotes the support of :math:`x`.

Informally we say that a signal :math:`x \in \CC^N` is \term{sparse} if :math:`\| x \|_0  \ll N`.
\index{Sparse signal}

More generally if :math:`x =\DDD \alpha` 
where :math:`\DDD \in \CC^{N \times D}` with
:math:`D > N` is some signal dictionary (to be formally defined later), then :math:`x` is 
sparse in dictionary :math:`\DDD` 
if :math:`\| \alpha \|_0 \ll D`. 

Sometimes we simply say that :math:`x` is :math:`K`-sparse if :math:`\| x \|_0 \leq K` where
:math:`K < N`. We do not specifically require that :math:`K \ll N`.

An even more general definition of sparsity is the degrees of freedom a signal may have.

As an example consider all points on the surface of a unit sphere in :math:`\RR^N`. For every
point :math:`x` belonging to the surface :math:`|x|_2 = 1`. Thus if we choose the values of :math:`N-1` components
of :math:`x` then the value of the remaining component is automatically fixed. Thus the
number of degrees of freedom :math:`x` has on the surface of the unit sphere in :math:`\RR^N` is actually
:math:`N-1`. Such a surface represents a manifold in the ambient Euclidean space. Of special 
interest are low dimensional manifolds where the number of degrees of freedom :math:`K \ll N`.

