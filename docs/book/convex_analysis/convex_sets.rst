 
Convex sets
===================================================


We start off with reviewing some basic definitions.

 
Affine sets
----------------------------------------------------



.. index:: Line
.. index:: Line segment
.. index:: Base point
.. index:: Direction


.. _def:line:
.. _def:line_segment:
.. _def:base_point:
.. _def:line_direction:

.. definition:: 



    Let :math:`x_1` and :math:`x_2` be two points in :math:`\RR^N`. Points of the form
    
    
    .. math:: 
    
        y = \theta x_1 + (1 - \theta) x_2 \text{ where } \theta \in \RR

    form a **line** passing through :math:`x_1` and :math:`x_2`.
    
    
    *  at :math:`\theta=0` we have :math:`y=x_2`.
    *  at :math:`\theta=1` we have :math:`y=x_1`.
    *  :math:`\theta \in [0,1]` corresponds to the points belonging to 
       the [closed] **line segment** between :math:`x_1` and :math:`x_2`.
    
    We can also rewrite :math:`y` as 
    
    
    .. math:: 
    
        y = x_2 + \theta (x_1 - x_2)
    
    
    In this definition:
    
    
    *  :math:`x_2` is called the **base point** for this line.
    *  :math:`x_1 - x_2` defines the **direction** of the line.
    *  :math:`y` is the sum of the base point and the direction scaled 
       by the parameter :math:`\theta`.
    *  As :math:`\theta` increases from :math:`0` to :math:`1`, :math:`y` 
       moves from :math:`x_2` to :math:`x_1`.
    
    


.. index:: Affine set

.. _def:affine_set:

.. definition:: 


    A set :math:`C \subseteq \RR^N` is **affine** if the line through
    any two distinct points in :math:`C` lies in :math:`C`.
    
    In other words, for any :math:`x_1, x_2 \in C`, we have :math:`\theta x_1 + (1 - \theta) x_2 \in C` 
    for all :math:`\theta \in \RR`.



If we denote :math:`\alpha = \theta` and :math:`\beta = (1 - \theta)` we see that 
:math:`\alpha x_1 + \beta x_2` represents a linear combination of points in :math:`C`
such that :math:`\alpha + \beta = 1`.

The idea can be generalized in following way.


.. index:: Affine combination

.. _def:affine_combination:

.. definition:: 


    A point of the form :math:`\theta_1 x_1 + \dots + \theta_k x_k` where 
    :math:`\theta_1 + \dots + \theta_k = 1` with :math:`\theta_i \in \RR` and :math:`x_i \in \RR^N`, is called
    an **affine combination** of the points :math:`x_1,\dots,x_k`.


It can be shown easily that an affine set :math:`C` contains all affine combinations
of its points.



.. remark:: 

    If :math:`C` is an affine set, :math:`x_1, \dots, x_k \in C`, and :math:`\theta_1 + \dots + \theta_k = 1`, then
    the point :math:`y = \theta_1 x_1 + \dots + \theta_k x_k` also belongs to :math:`C`. 




.. lemma:: 

    Let :math:`C` be an affine set and :math:`x_0` be any element in :math:`C`. Then the set
    
    
    .. math::
        V = C  - x_0 = \{ x  - x_0 | x \in C\}
    
    is a subspace of :math:`\RR^N`.




.. proof:: 

    Let :math:`v_1` and :math:`v_2` be two elements in :math:`V`. Then by definition, there exist :math:`x_1` and :math:`x_2` in :math:`C` such that
    
    
    .. math:: 
    
        v_1 = x_1 - x_0
    
    and 
    
    
    .. math:: 
    
        v_2 = x_2 - x_0
    
    
    Thus 
    
    
    .. math:: 
    
        a v_1 + v_2 = a (x_1 - x_0) + x_2 - x_0 = (a x_1 + x_2  - a x_0 )  - x_0 \Forall a \in \RR.
    
    
    But since :math:`a + 1 - a = 1`, hence :math:`x_3 = (a x_1 + x_2  - a x_0 ) \in C` (an affine combination). 
    
    Hence :math:`a v_1 + v_2 = x_3 - x_0 \in V` [by definition of :math:`V`].
    
    Thus any linear combination of elements in :math:`V` belongs to :math:`V`. Hence :math:`V` is a subspace of :math:`\RR^N`.


With this, we can use the following notation:


.. math::
    C = V + x_0 = \{ v + x_0 | v \in V\}

i.e. an affine set is a subspace with an offset.


.. remark:: 

    Let :math:`C` be an affine set and let :math:`x_1` and :math:`x_2` be two distinct elements.
    Let :math:`V_1 = C - x_1` and :math:`V_2 = C - x_2`, then the subspaces :math:`V_1` and :math:`V_2` 
    are identical.

Thus the subspace :math:`V` associated with an affine set :math:`C` doesn't depend upon
the choice of offset :math:`x_0` in :math:`C`.


.. index:: Affine dimension

.. _def:affine_dimension:

.. definition:: 

    We define the **affine dimension** of an affine set :math:`C` as the dimension
    of the associated subspace :math:`V = C - x_0` for some :math:`x_0 \in C`. 




.. example:: Solution set of linear equations

    We now show that the solution set of linear equations forms an affine set.
    
    Let :math:`C = \{ x | A x = b\}` where :math:`A \in \RR^{M \times N}` and :math:`b \in \RR^M`.
    
    :math:`C` is the set of all vectors :math:`x \in \RR^N` which satisfy the system of linear
    equations given by :math:`A x = b`. Then :math:`C` is an affine set.
    
    Let :math:`x_1` and :math:`x_2` belong to :math:`C`.  Then we have
    
    
    .. math:: 
    
        A x_1 = b
     and 
    
    
    .. math:: 
    
        A x_2 = b
    
    
    Thus 
    
    
    .. math:: 
    
        &\theta A x_1 + ( 1 - \theta ) A x_2 = \theta b + (1 - \theta ) b\\
        &\implies A (\theta x_1 + (1  - \theta) x_2) = b\\
        &\implies (\theta x_1 + (1  - \theta) x_2) \in C
    
    Thus :math:`C` is an affine set.
    
    The subspace associated with :math:`C` is nothing but the
    null space of :math:`A` denoted as :math:`\NullSpace(A)`.




.. remark:: 

    Every affine set can be expressed as the solution set of a 
    system of linear equations.





.. example:: More affine sets

    *  The empty set :math:`\EmptySet` is affine.
    *  A singleton set containing a single point :math:`x_0` is affine.
       Its corresponding subspace is :math:`\{0 \}` of zero dimension.
    *  The whole euclidean space :math:`\RR^N` is affine.
    *  Any line is affine. The associated subspace is a line parallel to it
       which passes through origin.
    *  Any plane is affine. If it passes through origin, its a
       subspace. The associated subspace is the plane parallel to it
       which passes through origin.
    



.. index:: Affine hull

.. _def:affine_hull:

.. definition:: 


    The set of all affine combinations of points in some arbitrary set :math:`S \subseteq \RR^N` 
    is called the **affine hull** of :math:`S` and denoted as :math:`\AffineHull(S)`:
    
    
    .. math::
        \AffineHull(S) = \{\theta_1 x_1 + \dots + \theta_k x_k | x_1, \dots, x_k \in S \text{ and } \theta_1 + \dots + \theta_k = 1\}.
    




.. remark:: 

    The affine hull is the smallest affine set containing :math:`S`. In other words, let :math:`C` be any affine set
    with :math:`S \subseteq C`. Then :math:`\AffineHull(S) \subseteq C`.


.. index:: Affine independence

.. _def:affine_independence:

.. definition:: 

    A set of vectors :math:`v_0, v_1, \dots, v_K \in \RR^N` is called **affine independent**,
    if the vectors :math:`v_1 - v_0, \dots, v_K - v_0` are linearly independent.


Essentially the difference vectors :math:`v_k - v_0` belong to the associated subspace. 

If the associated subspace has dimension :math:`L` then a maximum of :math:`L` vectors can 
be linearly independent in it. Hence a maximum of :math:`L+1` vectors can be affine
independent for the affine set.




 
Convex sets
----------------------------------------------------


.. index:: Convex set


.. _def:convex_set:

.. definition:: 

    A set :math:`C` is **convex** if the line segment between any two points in :math:`C` lies in :math:`C`. i.e.
    
    
    .. math::
        \theta x_1 + (1 - \theta) x_2 \in C \Forall x_1, x_2 \in C \text{ and } 0 \leq \theta \leq 1.
    




.. index:: Convex combination 


.. _def:convex_combination:

.. definition:: 

    We call a point of the form :math:`\theta_1 x_1  + \dots + \theta_k x_k`, where
    :math:`\theta_1 + \dots + \theta_k  = 1` and :math:`\theta_i \geq 0, i=1,\dots,k`,
    a **convex combination** of the points :math:`x_1, \dots, x_k`. 
    
    It is like a weighted average of the points :math:`x_i`.




.. remark:: 

    A set is convex if and only if it contains all convex combinations of its points.


.. index:: Ray

.. _def:ray:

.. example:: Convex sets


    *  A line segment is convex.
    *  A circle [including its interior] is convex.
    *  A **ray** is defined as :math:`\{ x_0 + \theta v | \theta \geq 0 \}` 
       where :math:`v \neq 0` indicates the direction of ray and 
       :math:`x_0` is the base or origin of ray. A ray
       is convex but not affine.
    *  Any affine set is convex.
    




.. index:: Convex hull

.. _def:convex_hull:

.. definition:: 


    The **convex hull** of an arbitrary set :math:`S \subseteq \RR^n` denoted as 
    :math:`\ConvexHull(S)`, is the set of all convex combinations of points in :math:`S`.
    
    
    .. math::
        \ConvexHull(S) = \{ \theta_1 x_1 + \dots + \theta_k x_k | x_k \in S, \theta_i \geq 0, i = 1,\dots, k,
        \theta_1 + \dots + \theta_k = 1\}.
    




.. remark:: 

    The convex hull :math:`\ConvexHull(S)` of a set :math:`S` is always convex.






.. remark:: 

    The convex hull of a set :math:`S` is the smallest convex set containing it. In other words,
    let :math:`C` be any convex set such that :math:`S \subseteq C`. Then :math:`\ConvexHull(S) \subseteq C`.


We can generalize convex combinations to include infinite sums.


.. lemma:: 

    Let :math:`\theta_1, \theta_2, \dots` satisfy
    
    
    .. math:: 
    
        \theta_i \geq 0, i = 1,2,\dots, \quad \sum_{i=1}^{\infty} \theta_i = 1,
    
    and let :math:`x_1, x_2, \dots \in C`, where :math:`C \subseteq \RR^N` is convex. Then
    
    
    .. math:: 
    
        \sum_{i=1}^{\infty} \theta_i x_i \in C,
    
    if the series converges.


We can generalize it further to density functions.


.. lemma:: 

    Let :math:`p : \RR^N \to \RR` satisfy :math:`p(x) \geq 0` for all  :math:`x \in C` 
    and 
    
    
    .. math:: 
    
        \int_{C} p(x) d x = 1
    
    Then
    
    
    .. math:: 
    
        \int_{C} p(x) x d x \in C
    
    provided the integral exists.


Note that :math:`p` above can be treated as a probability density function if
we define :math:`p(x) = 0 \Forall x \in \RR^N \setminus C`.



 
Cones
----------------------------------------------------


.. index:: Cone
.. index:: Nonnegative homogeneous

.. _def:cone:

.. definition:: 

    A set :math:`C` is called a **cone** or **nonnegative homogeneous**, if for every :math:`x \in C`
    and :math:`\theta \geq 0`, we have :math:`\theta x \in C`.



By definition we have :math:`0 \in C`.

.. index:: Convex cone

.. _def:convex_cone:

.. definition:: 

    A set :math:`C` is called a **convex cone** if it is convex and a cone.
    In other words, for every :math:`x_1, x_2 \in C` and :math:`\theta_1, \theta_2 \geq 0`, 
    we have
    
    
    .. math:: 
    
        \theta_1 x_1 + \theta_2 x_2 \in C
    




.. index:: Conic combination
.. index:: Nonnegative linear combination

.. _def:conic_combination:

.. definition:: 

    A point of the form :math:`\theta_1 x_1 + \dots + \theta_k x_k` with
    :math:`\theta_1 , \dots, \theta_k \geq 0` is called a **conic combination**
    (or a **non-negative linear combination**) of :math:`x_1,\dots, x_k`.





.. remark:: 

    Let :math:`C` be a convex cone. Then for every :math:`x_1, \dots, x_k \in C`,
    a conic combination :math:`\theta_1 x_1 + \dots + \theta_k x_k` with 
    :math:`\theta_i \geq 0` belongs to :math:`C`.
    
    Conversely if a set :math:`C` contains all conic combinations of its
    points, then its a convex cone.


The idea of conic combinations can be generalized to infinite sums
and integrals.


.. index:: Conic hull

.. _def:conic_hull:

.. definition:: 

    The **conic hull** of a set :math:`S` is the set of all conic combinations
    of points in :math:`S`. i.e.
    
    
    .. math::
        \{\theta_1 x_1 + \dots \theta_k x_k | x_i \in S, \theta_i \geq 0, i = 1, \dots, k \}
     





.. remark:: 

    Conic hull of a set is the smallest convex cone that contains the set.




.. example:: Convex cones

    *  A ray with its base at origin is a convex cone.
    *  A line passing through zero is a convex cone.
    *  A plane passing through zero is a convex cone.
    *  Any subspace is a convex cone.
    


We now look at some more important convex sets one by one.

 
Hyperplanes and half spaces
----------------------------------------------------


.. index:: Hyperplane
.. index:: Hyperplane!Normal vector

.. _def:hyperplane:
.. _def:hyperplane_normalvector:

.. definition:: 

    A **hyperplane**  is a set of the form
    
    
    .. math::
           H =  \{ x : a^T x = b \}
    
    where :math:`a \in \RR^N, a \neq 0` and :math:`b \in \RR`. 
    
    The vector :math:`a` is called the **normal vector** to the hyperplane.




*  Analytically it is a solution set of a nontrivial linear equation. 
   Thus it is an affine set.
*  Geometrically it is a set of points with a constant inner product to 
   a given vector :math:`a`.


Now let :math:`x_0` be an arbitrary element in :math:`H`. Then


.. math:: 

             &a^T x_0 = b\\
    \implies &a^T x = a^T x_0 \Forall x \in H\\
    \implies &a^T (x - x_0) = 0 \Forall x \in H\\
    \implies &H = \{ x | a^T(x-x_0) = 0\}


Now consider the orthogonal complement of :math:`a` defined as


.. math::
    a^{\bot} = \{ v | a^T v  = 0\}


i.e. the set of all vectors that are orthogonal to :math:`a`.

Now consider the set


.. math:: 

    S = x_0 + a^{\bot} 


Clearly for every :math:`x \in S`, :math:`a^T x = a^T x_0 = b`.

Thus we can say that


.. math::
    H = \{ x | a^T(x-x_0) = 0\} = x_0 + a^{\bot}


Thus the hyperplane consists of an offset :math:`x_0` plus all vectors
orthogonal to the (normal) vector :math:`a_0`.

.. index:: Halfspace
.. index:: Clsoed halfspace

.. _def:halfspace:

.. definition:: 

    A hyperplane divides :math:`\RR^N` into two **halfspaces**. 
    The two (closed) halfspaces are given by
    
    
    .. math::
        H_+ = \{ x : a^T x \geq b \}
    
    and
    
    
    .. math::
        H_- = \{ x : a^T x \leq b \}
    
    
    The halfspace :math:`H_+` extends in the direction of :math:`a` while
    :math:`H_-` extends in the direction of :math:`-a`.




*  A halfspace is the solution set of one (nontrivial) linear inequality.
*  A halfspace  is convex but not affine.
*  The halfspace can be written alternatively as 

   .. math::
        H_+  = \{ x | a^T (x - x_0) \geq 0\}\\
        H_-  = \{ x | a^T (x - x_0) \leq 0\}

   where :math:`x_0` is any point in the associated hyperplane :math:`H`.
*  Geometrically, points in :math:`H_+` make an acute angle with :math:`a` 
   while points in :math:`H_-` make an obtuse angle with :math:`a`.


.. index:: Open halfspace


.. _def:open_halfspace:

.. definition:: 

    The sets given by 
    
    
    .. math::
        \Interior{H_+} = \{ x | a^T x > b\}\\
        \Interior{H_-} = \{ x | a^T x < b\}
    
    are called **open halfspaces**. They are the interior
    of corresponding closed halfspaces.
    


 
Euclidean balls and ellipsoids
----------------------------------------------------

.. index:: Euclidean closed ball
.. index:: Euclidean closed ball!center
.. index:: Euclidean closed ball!radius



.. _def:euclidean_closed_ball:

.. definition:: 

    A **Euclidean closed ball** (or just ball) in :math:`\RR^N` has the form
    
    
    .. math::
        B = \{ x | \|  x - x_c\|_2 \leq r \} = \{x | (x - x_c)^T (x  - x_c) \leq r^2 \},
    
    where :math:`r > 0` and :math:`\| \|_2` denotes the Euclidean norm.
    
    :math:`x_c` is the **center** of the ball.
    
    :math:`r` is the **radius** of the ball.
    


An equivalent definition is given by


.. math::
    B = \{x_c +  r u | \| u \|_2 \leq 1  \}.




.. remark:: 

    A Euclidean ball is a convex set.




.. proof:: 

    Let :math:`x_1, x_2` be any two points in :math:`B`. We have
    
    
    .. math:: 
    
        \| x_1 - x_c\|_2 \leq r
    
    and 
    
    
    .. math:: 
    
        \| x_2 - x_c\|_2 \leq r
    
    
    Let :math:`\theta \in [0,1]` and consider the point :math:`x  = \theta x_1 + (1 - \theta) x_2`.
    Then 
    
    
    .. math:: 
    
        \| x - x_c \|_2 &= \| \theta x_1 + (1 - \theta) x_2 - x_c\|_2\\
        &=  \| \theta (x_1 - x_c) + (1 - \theta) (x_2 - x_c) \|_2\\
        &\leq \theta \| (x_1 - x_c)\|_2  + (1 - \theta)\| (x_2 - x_c)\|_2\\
        &\leq \theta r + (1 - \theta) r\\
        &= r
    
    
    Thus :math:`x \in B`, hence :math:`B` is a convex set.


.. index:: Ellipsoid


.. _def:ellipsoid:

.. definition:: 

    An **ellipsoid** is a set of the form
    
    
    .. math::
        \xi = \{x | (x - x_c)^T P^{-1} (x - x_c) \leq 1\}
    
    where :math:`P = P^T \succ 0` i.e. :math:`P` is symmetric and positive definite.
    
    The vector :math:`x_c \in \RR^N` is the **centroid** of the ellipse.
    
    Eigen values of the matrix :math:`P` (which are all positive) determine
    how far the ellipsoid extends in every direction from :math:`x_c`.
    
    The lengths of semi-axes of :math:`\xi` are given by :math:`\sqrt{\lambda_i}` 
    where :math:`\lambda_i` are the eigen values of :math:`P`.
    


 

.. remark:: 

     A ball is an ellipsoid with :math:`P = r^2 I`.



An alternative representation of an ellipsoid is given by


.. math::
    \xi = \{x_c + A u | \| u\|_2 \leq 1 \}

where :math:`A` is a square and nonsingular matrix.

To show the equivalence of the two definitions, we proceed as follows.

Let :math:`P = A A^T`. Let :math:`x` be any arbitrary element in :math:`\xi`.

Then :math:`x - x_c = A u` for some :math:`u` such that :math:`\| u \|_2 \leq 1`.

Thus


.. math:: 

    &(x - x_c)^T P^{-1} (x - x_c) =  (A u)^T (A A^T)^{-1} (A u)\\ 
    &= u^T A^T (A^T)^{-1} A^{-1} A u = u^T u  \\
    &= \| u \|_2^2 \leq 1


The two representations of an ellipsoid are therefore equivalent.



.. remark:: 

    An ellipsoid is a convex set.



 
Norm balls and norm cones
----------------------------------------------------


.. index:: Norm ball


.. _def:norm_ball:

.. definition:: 

    Let :math:`\|  \cdot \| : \RR^N \to R` be any norm on :math:`\RR`. 
    A **norm ball** with **radius** :math:`r` and **center** :math:`x_c` is given by
    
    
    .. math::
        B  = \{ x | \| x - x_c \| \leq r \}
    
    


 

.. remark:: 

     A norm ball is convex.



.. index:: Norm cone

.. _def:norm_cone:

.. definition:: 

    Let :math:`\|  \cdot \| : \RR^N \to R` be any norm on :math:`\RR`. 
    The **norm cone** associated with the norm :math:`\| \cdot \|` is given by the set
    
    
    .. math::
        C = \{ (x,t) | \| x \| \leq t \} \subseteq \RR^{N+1}
    



 

.. remark:: 

     A norm cone is convex. Moreover it is a convex cone.


.. index:: Second order cone


.. _ex:second_order_cone:

.. example:: Second order cone

    The second order cone is the norm cone for the Euclidean norm, i.e.
    
    
    .. math::
        C  = \{(x,t) | \| x \|_2 \leq t \} \subseteq \RR^{N+1}
    
    This can be rewritten as 
    
    
    .. math::
        C = \left \{ 
        \begin{bmatrix}
        x \\ t
        \end{bmatrix}
        \middle | 
        \begin{bmatrix}
        x \\ t
        \end{bmatrix}^T 
        \begin{bmatrix}
        I & 0 \\
        0 & -1 
        \end{bmatrix}
        \begin{bmatrix}
        x \\ t
        \end{bmatrix}
        \leq 0 , t \geq 0
        \right \}
    


.. index:: Polyhedron

 
Polyhedra
----------------------------------------------------



.. _def:polyhedron:

.. definition:: 

    A **polyhedron** is defined as the solution set of a finite number of linear inequalities.
    
    
    .. math::
        P = \{ x | a_j^T x \leq b_j, j = 1, \dots, M, c_k^T x = d_k, k = 1, \dots, P\}
    
    


A polyhedron thus is the intersection of a finite number of halfspaces (:math:`M`)
and hyperplanes (:math:`P`).



.. example:: Polyhedra

    *  Affine sets ( subspaces, hyperplanes, lines)
    *  Rays
    *  Line segments
    *  Halfspaces
    




.. remark:: 

    A polyhedron is a convex set.



.. index:: Polytope

.. _def:polytope:

.. definition:: 

    A bounded polyhedron is known as a **polytope**.



We can combine the set of inequalities and equalities in the form of
linear matrix inequalities and equalities.


.. math::
    P = \{ x | A x \preceq b,  C x = d\}


where


.. math::
    &A = \begin{bmatrix}
    a_1^T \\
    \vdots \\
    a_M^T
    \end{bmatrix}
    ,
    b = \begin{bmatrix}
    b_1 \\
    \vdots \\
    b_M
    \end{bmatrix}\\
    &C = \begin{bmatrix}
    c_1^T \\
    \vdots\\
    c_P^T
    \end{bmatrix}
    ,
    d = \begin{bmatrix}
    d_1 \\
    \vdots \\
    d_P
    \end{bmatrix}


and the symbol :math:`\preceq` means **vector inequality** or 
**component wise inequality** in :math:`\RR^M` i.e. :math:`u \preceq v`
means :math:`u_i \leq v_i` for :math:`i = 1, \dots, M`.

Note that :math:`b \in \RR^M`, :math:`A \in \RR^{M \times N}`, :math:`A x \in \RR^M`, 
:math:`d \in \RR^P`, :math:`C \in \RR^{P \times N}` and :math:`C x \in \RR^P`.



.. example:: Set of nonnegative numbers

    Let :math:`\RR_+  = \{ x \in \RR | x \geq 0\}`. :math:`\RR_+` is a polyhedron
    (a solution set of a single linear inequality). Hence its a convex set.
    Moreover its a ray and a convex cone.


.. index:: Nonnegative orthant


.. _def:nonnegative_orthant:

.. example:: Non-negative orthant

    We can generalize :math:`\RR_+` as follows.  Define
    
    
    .. math::
        \RR_+^N = \{ x \in \RR^N | x_i \geq 0 , i = 1, \dots , N\}  = \{x \in \RR^N | x \succeq 0 \}.
    
    
    :math:`\RR_+^N` is called **nonnegative orthant**. It is a polyhedron (solution set of
    :math:`N` linear inequalities). It is also a convex cone.


.. index:: Simplex

.. _def:simplex:

.. definition:: 

    Let :math:`K+1` points :math:`v_0, \dots, v_K \in \RR^N` be affine independent 
    (see :ref:`here <def:affine_independence>`).
    
    The **simplex** determined by them is given by
    
    
    .. math::
        C = \ConvexHull \{ v_0, \dots, v_K\} 
        = \{ \theta_0 v_0 + \dots + \theta_K v_K | \theta \succeq 0, 1^T \theta = 1\}
    
    where :math:`\theta = [\theta_1, \dots, \theta_K]^T` and 
    :math:`1` denotes a vector of appropriate size :math:`(K)` with all entries one.
    
    In other words, :math:`C` is the convex hull of the set :math:`\{v_0, \dots, v_K\}`.






 
The positive semidefinite cone
----------------------------------------------------


.. index:: Set of symmetric :math:`N\times N` matrices

.. _def:symmetric_matrices:

.. definition:: 

    We define the **set of symmetric** :math:`N\times N` **matrices** as
        
    .. math::
        S^N = \{X \in \RR^{N \times N} | X = X^T\}.
    

.. lemma:: 

    :math:`S^N` is a vector space with dimension :math:`\frac{N(N+1)}{2}`.



.. index:: Set of symmetric positive semidefinite matrices
.. _def:positive_semidefinite_matrices:

.. definition:: 

    We define the **set of symmetric positive semidefinite matrices** as
    
    
    .. math::
        S_+^N = \{X \in S^N | X \succeq 0 \}.
    
    The notation :math:`X \succeq 0` means :math:`v^T X v \geq 0 \Forall v \in \RR^N`.




.. index:: Set of symmetric positive definite matrices
.. _def:positive_definite_matrices:

.. definition:: 

    We define the **set of symmetric positive definite matrices** as
    
    
    .. math::
        S_{++}^N = \{X \in S^N | X \succ 0 \}.
    
    The notation :math:`X \succ 0` means :math:`v^T X v  > 0 \Forall v \in \RR^N`.





.. lemma:: 

    The set :math:`S_+^N` is a convex cone.




.. proof:: 

    Let :math:`A, B \in S_+^N` and :math:`\theta_1, \theta_2 \geq 0`. We have to show that
    :math:`\theta_1 A + \theta_2 B \in S_+^N`.
    
    
    .. math:: 
    
        A \in S_+^N \implies v^T A v \geq 0 \Forall v \in \RR^N.
    
    
    
    .. math:: 
    
        B \in S_+^N \implies v^T B v \geq 0 \Forall v \in \RR^N.
    
    
    Now
    
    
    .. math:: 
    
        v^T (\theta_1 A + \theta_2 B) v = \theta_1 v^T A v + \theta_2 v^T B v \geq 0 \Forall v \in \RR^N.
     
    
    Hence :math:`\theta_1 A + \theta_2 B \in S_+^N`.
    


 
Operations that preserve convexity
----------------------------------------------------


In the following, we will discuss several operations which
transform a convex set into another convex set, and thus
preserve convexity.

Understanding these operations is useful for determining
the convexity of a wide variety of sets.

Usually its easier to prove that a set is convex by showing
that it is obtained by a convexity preserving operation from
a convex set compared to directly verifying the convexity property
i.e. 


.. math:: 

    \theta x_1 + (1 - \theta) x_2 \in C \Forall x_1, x_2 \in C, \theta \in [0,1]
.


 
Intersection
----------------------------------------------------




.. lemma:: 

    If :math:`S_1` and :math:`S_2` are convex sets then :math:`S_1 \cap S_2` is convex.




.. proof:: 

    Let :math:`x_1, x_2 \in S_1 \cap S_2`. We have to show that
    
    
    .. math:: 
    
        \theta x_1 + (1 - \theta) x_2 \in S_1 \cap S_2, \Forall \theta \in [0,1].
    
    
    Since :math:`S_1` is convex and :math:`x_1, x_2 \in S_1`, hence
    
    
    .. math:: 
    
        \theta x_1 + (1 - \theta) x_2 \in S_1, \Forall \theta \in [0,1].
    
    
    Similarly
    
    
    .. math:: 
    
        \theta x_1 + (1 - \theta) x_2 \in S_2, \Forall \theta \in [0,1].
    
    
    Thus
    
    
    .. math:: 
    
        \theta x_1 + (1 - \theta) x_2 \in S_1 \cap S_2, \Forall \theta \in [0,1].
    
    
    which completes the proof.


We can generalize it further.



.. lemma:: 

    Let :math:`\{ A_i\}_{i \in I}` be a family of sets such that :math:`A_i` is convex
    for all :math:`i \in I`.  Then :math:`\cap_{i \in I} A_i` is convex.




.. proof:: 

    Let :math:`x_1, x_2` be any two arbitrary elements in :math:`\cap_{i \in I} A_i`. 
    
    
    .. math:: 
    
        &x_1, x_2 \in \cap_{i \in I} A_i\\
        \implies & x_1, x_2 \in A_i \Forall i \in I\\
        \implies &\theta x_1 + (1 - \theta) x_2 \in A_i \Forall \theta \in [0,1] \Forall i \in I
        \text{ since $A_i$ is convex }\\
        \implies &\theta x_1 + (1 - \theta) x_2 \in \cap_{i \in I} A_i
    
    
    Hence :math:`\cap_{i \in I} A_i` is convex.




 
Affine functions
----------------------------------------------------


.. index:: Affine function

.. _def:affine_function:

.. definition:: 

    A function :math:`f : \RR^N \to \RR^M` is affine if it is a sum of a linear
    function and a constant, i.e.
    
    
    .. math::
        f = A x + b
    
    where :math:`A \in \RR^{M \times N}` and :math:`b \in \RR^M`.





.. lemma:: 

    Let :math:`S \subseteq \RR^N` be convex and :math:`f : \RR^N \to \RR^M` be an 
    affine function. Then the image of :math:`S` under :math:`f` given by
    
    
    .. math::
        f(S) = \{ f(x) | x \in S\}
    
    is a convex set.


It applies in the reverse direction also.


.. lemma:: 

    Let :math:`f : \RR^K \to \RR^N` be affine and :math:`S \subseteq \RR^N` be convex.
    Then the inverse image of :math:`S` under :math:`f` given by
    
    
    .. math::
        f^{-1}(S) = \{ x \in \RR^K | f(x) \in S\}
    
    is convex.



.. index:: Scaling
.. index:: Translation
.. index:: Projection

.. example:: Affine functions preserving convexity

    
    Let :math:`S \in \RR^N` be convex.

    #. For some :math:`\alpha \in \RR` , :math:`\alpha S`  given by
        
       .. math::
            \alpha S = \{\alpha x | x \in S\}
    
       is convex. This is the **scaling** operation.
    #. For some :math:`a \in \RR^N`, :math:`S + a` given by
    
    
       .. math::
            S + a = \{x + a | x \in S\}
    
       is convex. This is the **translation** operation.

    #. Let :math:`N = M + K` where :math:`M, N \in \Nat`. Thus let 
       :math:`\RR^N = \RR^M \times \RR^K`.
       A vector :math:`x \in S` can be written as :math:`x = (x_1, x_2)` 
       where :math:`x_1 \in \RR^M` and :math:`x_2 \in \RR^K`.
       Then 

       .. math::
            T = \{ x_1 \in \RR^M | (x_1, x_2) \in S \text{ for some } x_2 \in \RR^K\}
    
       is convex. This is the **projection** operation.
    


.. index:: Sum of two sets in :math:`\RR^N`

.. _def:sum_of_two_sets:

.. definition:: 

    Let :math:`S_1` and :math:`S_2` be two arbitrary subsets of :math:`\RR^N`. Then their **sum**
    is defined as 
    
    
    .. math::
        S_1 + S_2  = \{ x + y | x \in S_1 , y \in S_2\}.
    
    





.. lemma:: 

    Let :math:`S_1` and :math:`S_2` be two convex subsets of :math:`\RR^N`. Then 
    :math:`S_1 + S_2` is convex.






 
Proper cones and generalized inequalities
----------------------------------------------------

.. index:: Proper cone

.. _def:proper_cone:

.. definition:: 

    A cone :math:`K \in \RR^N` is called a **proper cone** if it satisfies the following:
    
    *  :math:`K` is *convex*.
    *  :math:`K` is *closed*.
    *  :math:`k` is *solid* i.e. it has a nonempty interior.
    *  :math:`K` is *pointed* i.e. it contains no line. In other words
    
    
    .. math:: 
    
        x \in K, -x \in K \implies x = 0.
    
    





A proper cone :math:`K` can be used to define a *generalized inequality*,
which is a partial ordering on :math:`\RR^N`.


.. index:: Generalized inequality
.. index:: Proper cone!Partial ordering
.. index:: Proper cone!Strict partial ordering

.. _def:generalized_inequality:
.. _def:proper_cone_partial_ordering:
.. _def:proper_cone_strict_partial_ordering:

.. definition:: 

    Let :math:`K \subseteq \RR^N` be a proper cone. A **partial ordering** on 
    :math:`\RR^N` associated with the proper cone :math:`K` is defined as
    
    
    .. math::
        x \preceq_{K} y \iff y - x \in K.
    
    We also write :math:`x \succeq_K y` if :math:`y \preceq_K x`. This is also known
    as a **generalized inequality**.
    
    A **strict partial ordering** on :math:`\RR^N` associated with the proper cone :math:`K`
    is defined as
    
    
    .. math::
        x \prec_{K} y \iff y - x \in \Interior{K}.
    
    where :math:`\Interior{K}` is the interior of :math:`K`.
    We also write :math:`x \succ_K y` if :math:`y \prec_K x`.
    This is also known as a **strict generalized inequality**.
    




When :math:`K = \RR_+`, then :math:`\preceq_K` is same as usual :math:`\leq`
and :math:`\prec_K` is same as usual :math:`<` operators on :math:`\RR_+`.

.. index:: Component wise inequality

.. _def:component_wise_inequality:

.. example:: Nonnegative orthant and component-wise inequality

    The nonnegative orthant :math:`K=\RR_+^N` is a proper cone. Then the
    associated generalized inequality :math:`\preceq_{K}` means that
    
    
    .. math:: 
    
        x \preceq_K y \implies (y-x) \in \RR_+^N
        \implies x_i \leq y_i \Forall i= 1,\dots,N. 
    
    This is usually known as **component-wise inequality** and
    usually denoted as :math:`x \preceq y`.





.. example:: Positive semidefinite cone and matrix inequality

    The positive semidefinite cone :math:`S_+^N \subseteq S^N` is a proper
    cone in the vector space :math:`S^N`.
    
    The associated generalized inequality means
    
    
    .. math:: 
    
        X \preceq_{S_+^N} Y \implies Y - X \in S_+^N
    
    i.e. :math:`Y - X` is positive semidefinite.
    This is also usually denoted as :math:`X \preceq Y`.






 
Minimum and minimal elements
----------------------------------------------------


The generalized inequalities (:math:`\preceq_K, \prec_K`) w.r.t. the proper cone
:math:`K \subset \RR^N` 
define
a partial ordering over any arbitrary set :math:`S \subseteq \RR^N`.

But since they may not enforce a total ordering on :math:`S`,  not every
pair of elements :math:`x, y\in S` may be related by :math:`\preceq_K` or :math:`\prec_K`.



.. example:: Partial ordering with nonnegative orthant cone

    Let :math:`K = \RR^2_+ \subset \RR^2`. 
    Let :math:`x_1 = (2,3), x_2 = (4, 5), x_3=(-3, 5)`. Then we have

    *  :math:`x_1 \prec x_2`, :math:`x_2 \succ x_1` and :math:`x_3 \preceq x_2`.
    *  But neither :math:`x_1 \preceq x_3` nor :math:`x_1 \succeq x_3` holds.
    *  In general For any :math:`x , y \in \RR^2`, :math:`x \preceq y` 
       if and only if
       :math:`y` is to the right and above of :math:`x` in 
       the :math:`\RR^2` plane.
    *  If :math:`y` is to the right but below or :math:`y` is above 
       but to the left of :math:`x`, then
       no ordering holds.
    


.. index:: Generalized inequality!Minimum element

.. _def:generalized_inequality_minimum_element:

.. definition:: 

    We say that :math:`x \in S \subseteq \RR^N` is **the minimum element** of 
    :math:`S`
    w.r.t. the generalized inequality :math:`\preceq_K` if for 
    every :math:`y \in S` we have
    :math:`x \preceq y`.



*  :math:`x` must belong to :math:`S`.
*  It is highly possible that there is no minimum element in :math:`S`.
*  If a set :math:`S` has a minimum element, then 
   by definition it is unique (Prove it!).


.. index:: Generalized inequality!Maximum element

.. _def:generalized_inequality_maximum_element:

.. definition:: 

    We say that :math:`x \in S \subseteq \RR^N` is **the maximum element** of :math:`S`
    w.r.t. the generalized inequality :math:`\preceq_K` if for every :math:`y \in S` we have
    :math:`y \preceq x`.



*  :math:`x` must belong to :math:`S`.
*  It is highly possible that there is no maximum element in :math:`S`.
*  If a set :math:`S` has a maximum element, then by definition it is unique.




.. example:: Minimum element

    Consider :math:`K = \RR^N_+` and :math:`S = \RR^N_+`. Then :math:`0 \in S` is the minimum element
    since :math:`0 \preceq x \Forall x \in \RR^N_+`.





.. example:: Maximum element

    Consider :math:`K = \RR^N_+` and :math:`S = \{x | x_i \leq 0 \Forall i=1,\dots,N\}`. 
    Then :math:`0 \in S` is the maximum element
    since :math:`x \preceq 0 \Forall x \in S`.





There are many sets for which no minimum element exists. In this context
we can define a slightly weaker concept known as minimal element.


.. index:: Generalized inequality!Minimal element
.. _def:generalized_inequality_minimal_element:

.. definition:: 

    An element :math:`x\in S` is called a **minimal element** of :math:`S`
    w.r.t. the generalized inequality :math:`\preceq_K` if there is no
    element :math:`y \in S` distinct from :math:`x` such that :math:`y \preceq_K x`.
    In other words :math:`y \preceq_K x \implies y = x`.




.. index:: Generalized inequality!Maximal element
.. _def:generalized_inequality_maximal_element:

.. definition:: 

    An element :math:`x\in S` is called a **maximal element** of :math:`S`
    w.r.t. the generalized inequality :math:`\preceq_K` if there is no
    element :math:`y \in S` distinct from :math:`x` such that :math:`x \preceq_K y`.
    In other words :math:`x \preceq_K y \implies y = x`.



*  The minimal or maximal element :math:`x` must belong to :math:`S`.
*  It is highly possible that there is no minimal or maximal 
   element in :math:`S`.
*  Minimal or maximal element need not be unique. A set may 
   have many minimal or maximal elements.




.. lemma:: 

    A point :math:`x \in S` is the minimum element of :math:`S` if and only if 
    
    
    .. math::
        S \subseteq x + K
    




.. proof:: 

    Let :math:`x \in S` be the minimum element. 
    Then by definition :math:`x \preceq_K y \Forall y \in S`.  Thus
    
    
    .. math:: 
    
        & y - x \in K \Forall y \in S \\
        \implies & \text{ there exists some } k \in K  \Forall y \in S \text{ such that } y = x + k\\
        \implies & y \in x + K \Forall y \in S\\
        \implies & S \subseteq x + K.
    
    
    Note that :math:`k \in K` would be distinct for each :math:`y \in S`. 
    
    Now let us prove the converse.
    
    Let :math:`S \subseteq x + K` where :math:`x \in S`. Thus
    
    
    .. math:: 
    
        & \exists k \in K \text{ such that } y = x + k \Forall y \in S\\
        \implies & y - x = k \in K  \Forall y \in S\\
        \implies & x \preceq_K y \Forall y \in S.
    
    
    Thus :math:`x` is the minimum element of :math:`S` since there can be only one minimum element
    of S.
    


:math:`x + K` denotes all the points that are comparable to :math:`x` and greater than
or equal to :math:`x` according to :math:`\preceq_K`.



.. lemma:: 

    A point :math:`x \in S` is a minimal point if and only if 
    
    
    .. math::
        \{ x - K \} \cap S = \{ x \}.
    




.. proof:: 

    Let :math:`x \in S` be a minimal element of :math:`S`. Thus there is no
    element :math:`y \in S` distinct from :math:`x` such that :math:`y \preceq_K x`.
    
    Consider the set :math:`R = x - K = \{x - k | k \in K \}`.
    
    
    .. math::
        r \in R \iff r = x - k \text { for some } k \in K
        \iff x - r \in K \iff  r \preceq_K x. 
    
    
    Thus :math:`x - K` consists of all points :math:`r \in \RR^N` which satisfy
    :math:`r \preceq_K x`. But there is only one such point in :math:`S` namely :math:`x` 
    which satisfies this. Hence
    
    
    .. math::
        \{ x - K \} \cap S = \{ x \}.
    
    
    Now let us assume that :math:`\{ x - K \} \cap S = \{ x \}`.  Thus the only
    point :math:`y \in S` which satisfies :math:`y \preceq_K x` is :math:`x` itself. 
    Hence :math:`x` is a minimal element of :math:`S`.


:math:`x - K` represents the set of points that are comparable to :math:`x` and are 
less than or equal to :math:`x` according to :math:`\preceq_K`.


