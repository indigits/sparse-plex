Synthetic Data Generation
================================

.. highlight:: matlab


Random Subspaces
-----------------------

Subspace clustering is focused on segmenting
data which fall in different subspaces 
where subspaces are either independent
or disjoint with each other and they are
sufficiently oriented away from each other.

For testing algorithms, it is useful to 
pick random subspaces of an ambient signal
space and then draw data points within 
these subspaces.

A way to pick a random subspace is to pick
a basis for the subspace. Then, all the 
linear combinations of the basis elements
fall in the subspace and the basis elements
span every vector in the said random subspace.

Let's pick a random plane in the 3-Dimensional
space::

    >> basis = orth(randn(3, 2))
    basis =

       -0.2634    0.6981
       -0.5459   -0.6769
        0.7954   -0.2334


What we are doing is we are constructing
a 3x2 Gaussian random matrix and orthogonalizing
its columns. With probability 1, the Gaussian
random matrix is full rank. Hence, this is
a safe way of choosing a basis for a random plane.

We can verify that the basis is indeed orthogonal::

    >> basis'*basis
    ans =

        1.0000         0
             0    1.0000


``sparse-plex`` provides a way to draw
multiple random subspaces of a given dimension
from an ambient space.

Let's pick the dimension of the ambient space::

    M = 10;

Let's pick the dimension of subspaces::

    D = 4;

Let's pick the number of subspaces to be drawn::

    K = 2;

Let's draw the bases for each random subspace::

    import spx.data.synthetic.subspaces.random_subspaces;
    bases = random_subspaces(M, K, D);

The result ``bases`` is a cell array 
containing the orthogonal basis for each subspace::

    >> bases{1}

    ans =

       -0.1178   -0.1432    0.0438   -0.0100
        0.1311   -0.0110   -0.4409    0.1758
        0.5198   -0.6404    0.0422   -0.3980
        0.5211   -0.0172   -0.2929    0.6334
       -0.2253   -0.1194   -0.2797    0.0920
        0.4695    0.1059    0.5408    0.1396
        0.1919    0.0765   -0.1441   -0.3519
        0.0940    0.0145   -0.4542   -0.4078
        0.3209    0.6274   -0.2325   -0.2118
       -0.0855   -0.3791   -0.2537    0.2153

    >> bases{2}

    ans =

        0.4784   -0.0579   -0.4213   -0.0206
        0.1213   -0.0591    0.3498    0.2351
        0.3077   -0.2110    0.2573    0.0042
       -0.5581   -0.5284    0.0988   -0.1403
        0.1128    0.5914    0.2518   -0.1872
       -0.1804   -0.0095    0.0707   -0.1351
       -0.0728    0.2774   -0.2063    0.3801
       -0.4417    0.3878    0.2071    0.4004
        0.0695   -0.2496   -0.1836    0.7344
        0.3158   -0.1732    0.6608    0.1647

Verify orthogonality::

    >> bases{1}' * bases{1}

    ans =

        1.0000   -0.0000   -0.0000   -0.0000
       -0.0000    1.0000    0.0000    0.0000
       -0.0000    0.0000    1.0000   -0.0000
       -0.0000    0.0000   -0.0000    1.0000


Principal Angles
------------------------

If :math:`\UUU` and :math:`\VVV` are two linear subspaces of :math:`\RR^M`, then 
the *smallest principal angle* between them 
denoted by :math:`\theta` is defined as :cite:`bjorck1973numerical`


.. math::
    \cos \theta = \underset{u \in \UUU, v \in \VVV}{\max} \frac{u^T v}{\| u \|_2 \| v \|_2}.


