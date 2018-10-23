.. _sec:la:principal_angles:

Principal Angles
================================

.. highlight:: matlab


If :math:`\UUU` and :math:`\VVV` are two linear subspaces of :math:`\RR^M`, then 
the *smallest principal angle* between them 
denoted by :math:`\theta` is defined as :cite:`bjorck1973numerical`


.. math::
    \cos \theta = \underset{u \in \UUU, v \in \VVV}{\max} \frac{u^T v}{\| u \|_2 \| v \|_2}.

In other words, we try to find unit norm vectors in the two
spaces which are maximally aligned with each other. The angle
between them is the smallest principal angle. Note that 
:math:`\theta \in [0, \pi /2 ]` (:math:`\cos \theta` as defined above is always positive).
If we have :math:`U` and :math:`V` as matrices whose column spans are 
the subspaces :math:`\UUU` and :math:`\VVV`
respectively, then in order to find the principal angles, we construct
orthogonal bases :math:`Q_U` and :math:`Q_V`. We then compute the inner product
matrix :math:`G = Q_U^T Q_V`. The SVD of :math:`G` gives the principal angles. 
In particular, the smallest principal angle is given by :math:`\cos \theta = \sigma_1`,
the largest singular value. 

Hands on with Principal Angles
---------------------------------------

We will generate two random 4-D subspaces
in an ambient spaces :math:`\RR^{10}`::

    % subspace dimension
    D = 4;
    % ambient dimension
    M = 10;
    % Number of subspaces
    K = 2;
    import spx.data.synthetic.subspaces.random_subspaces;
    bases = random_subspaces(M, K, D);

Finding the smallest principal angle in two
subspaces is quite easy.

Let's give some convenient names to the two bases::

    >> A = bases{1};
    >> B = bases{2};

Now let's compute the inner products matrix
between the basis vectors of the two bases::

    >> G = A' * B
    G =

       -0.3416   -0.4993    0.1216    0.2732
       -0.3780    0.0173   -0.5111    0.4413
        0.1296   -0.1153   -0.4123   -0.5332
       -0.2152   -0.4476    0.2282   -0.5022

Compute the singular values for G::

    >> sigmas = svd(G)'
    sigmas =

        0.9676    0.8197    0.6738    0.1664


The largest inner product between unit vectors
drawn from A and B is given by::

    >> largest_product = sigmas(1)
    largest_product =

        0.9676

It is clear that this is very high. 
The corresponding smallest principal angle is::

    >> smallest_angle_rad  = acos(largest_product)
    smallest_angle_rad =

        0.2551

Or in radians::

    >> smallest_angle_deg = rad2deg(smallest_angle_rad)
    smallest_angle_deg =

       14.6143

   
``sparse-plex`` provides a number of 
convenience functions for measuring
principal angles.

We start with functions which can tell
us about the smallest principal angle
between a pair of subspaces.

The smallest principal angle in degrees::

    >> spx.la.spaces.smallest_angle_deg(A, B)

    ans =

       14.6143

The smallest principal angle in radians::

    >> spx.la.spaces.smallest_angle_rad(A, B)

    ans =

        0.2551

The smallest principal angle in cosine version::

    >> spx.la.spaces.smallest_angle_cos(A, B)

    ans =

        0.9676


If we have more than two subspaces,
then we have a way of computing principal
angles between each of them.

Let's draw 6 subspaces from :math:`\RR^{10}`::

    >> K = 6;
    >> bases = random_subspaces(M, K, D);


We now want pairwise smallest principal angles
between them::

    >> angles = spx.la.spaces.smallest_angles_deg(bases)
    angles =

             0   19.9756   32.3022   21.1835   47.2059   24.9171
       19.9756         0   14.9874   17.8499   20.5399   42.5358
       32.3022   14.9874         0   34.6420   21.9036   34.4935
       21.1835   17.8499   34.6420         0   14.0794   26.5235
       47.2059   20.5399   21.9036   14.0794         0   39.5866
       24.9171   42.5358   34.4935   26.5235   39.5866         0

