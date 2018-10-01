
 
Principal Angles
----------------------------------------------------

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
