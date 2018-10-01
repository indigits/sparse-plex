
.. _sec:affine_subspace:

 
Affine Subspaces Review
----------------------------------------------------

For a detailed introduction to affine concepts,
see :cite:`kelly1979geometry`.
For a vector :math:`v \in \RR^n`, the function :math:`f` defined
by :math:`f (x) = x + v, x \in \RR^n` is a *translation*
of :math:`\RR^n` by :math:`v`.  The image of any set :math:`\mathcal{S}` 
under :math:`f` is the :math:`v`-*translate* of :math:`\mathcal{S}`.
A translation of space is a one to one isometry of
:math:`\RR^n` onto :math:`\RR^n`.

A translate of a :math:`d`-dimensional, linear subspace
of :math:`\RR^n` is a :math:`d`-*dimensional flat* or simply
:math:`d`-*flat* in :math:`\RR^n`. Flats of dimension
1, 2, and :math:`n-1` are also called lines, planes, and
hyperplanes, respectively. Flats are also known as
*affine subspaces*.  

Every :math:`d`-flat in :math:`\RR^n` is congruent to the Euclidean space :math:`\RR^d`. Flats are closed sets.

An *affine combination* of the vectors
:math:`v_1, \dots, v_m` is a linear combination 
in which the sum of coefficients is 1. Thus, 
:math:`b` is an affine combination of :math:`v_1, \dots, v_m` 
if :math:`b = k_1 v_1 + \dots k_m v_m` and 
:math:`k_1 + \dots + k_m = 1`. The set of affine combinations
of a set of vectors :math:`\{ v_1, \dots, v_m \}` is their
*affine span*. A finite set of vectors
:math:`\{v_1, \dots, v_m\}` is called 
*affine independent* if the only 
*zero-sum linear combination* of theirs
representing the null vector is the null combination.
i.e. :math:`k_1 v_1 + \dots + k_m v_m = 0` and
:math:`k_1 + \dots + k_m = 0` implies 
:math:`k_1 = \dots = k_m = 0`. Otherwise, the set is
*affinely dependent*. A finite set of two
or more vectors is affine independent if and
only if none of them is an affine combination 
of the others.

**Vectors vs. Points** An n-tuple 
:math:`(x_1, \dots, x_n)` is used to refer to a
point :math:`X` in :math:`\RR^n` as well as to a vector
from origin :math:`O` to :math:`X` in :math:`\RR^n`. 
In basic linear algebra, the terms vector and point
are used interchangeably. While discussing geometrical
concepts (affine or convex sets etc.), it is useful
to distinguish between vectors and points.
When
the terms "dependent" and "independent"
are used without qualification to points, they
refer to affine dependence/independence. When
used for vectors, they mean linear 
dependence/independence.

The span of :math:`k+1` independent points is a :math:`k`-flat
and is the unique :math:`k`-flat that contains all :math:`k+1`
points. Every :math:`k`-flat contains :math:`k+1` 
(affine) independent points. Each set of :math:`k+1`
independent points in the :math:`k`-flat forms an 
*affine basis* for the flat. Each point of 
a :math:`k`-flat is represented by one and only one
affine combination of a given affine basis for the
flat. The coefficients of the affine combination
of a point are the *affine coordinates* of
the point in the given affine basis of the :math:`k`-flat.
A :math:`d`-flat is contained in a linear subspace of dimension :math:`d+1`. This can be easily obtained
by choosing an affine basis for the flat and
constructing its linear span. 

A function :math:`f` defined on a vector space :math:`V` 
is an *affine function* or 
*affine transformation* or *affine mapping*
if it maps
every affine combination of vectors :math:`u, v` in
:math:`V` onto the same affine combination of their images.
If :math:`f` is real valued, then :math:`f` is an 
*affine functional*. A property which
is invariant under an affine mapping is called 
*affine invariant*. The image of a 
flat under an affine function is a flat. 

Every affine function differs from a linear function
by a translation. A functional is an affine
functional if and only if there exists a unique
vector :math:`a \in \RR^n` and a unique real number 
:math:`k` such that  :math:`f(x) = \langle a, x \rangle + k`.
Affine functionals are continuous.  If :math:`a \neq 0`,
then the linear functional 
:math:`f(x) = \langle a, x \rangle` and the affine 
functional :math:`g(x) = \langle a, x \rangle + k` map
bounded sets onto bounded sets, neighborhoods
onto neighborhoods, balls onto balls and open sets
onto open sets.

 
Hyperplanes and Half spaces
""""""""""""""""""""""""""""""""""""""""""""""""""""""


Corresponding to a hyperplane :math:`\mathcal{H}` in :math:`\RR^n`
(an :math:`n-1`-flat), there exists a non-null vector
:math:`a` and a real number :math:`k` such that :math:`\mathcal{H}`
is the graph of :math:`\langle a , x \rangle = k`. The
vector :math:`a` is orthogonal to :math:`PQ` for all 
:math:`P, Q \in \mathcal{H}`. All non-null vectors :math:`a` to 
have this property are *normal* to the
hyperplane. The directions of :math:`a` and :math:`-a` are called
opposite normal directions of :math:`\mathcal{H}`. 
Conversely, the graph of :math:`\langle a , x \rangle = k`,
:math:`a \neq 0`, is a hyperplane for which :math:`a` is a normal
vector. If :math:`\langle a, x \rangle = k` and 
:math:`\langle b, x \rangle = h`, :math:`a \neq 0`, :math:`b \neq 0`
are both representations of a hyperplane 
:math:`\mathcal{H}`, then there exists a real non-zero
number :math:`\lambda` such that :math:`b = \lambda a` and
:math:`h = \lambda k`. Obviously, we can find a unit
norm normal vector for :math:`\mathcal{H}`.
Each point :math:`P` in space has a unique foot 
(nearest point) 
:math:`P_0` in a Hyperplane :math:`\mathcal{H}`.
Distance of the point :math:`P` with vector :math:`p` from
a hyperplane :math:`\mathcal{H} : \langle a , x \rangle = k`
is given by 


.. math::
    d(P, \mathcal{H}) = \frac{|\langle a, p \rangle - k|}{\| a \|_2}.

The coordinate :math:`p_0` of the foot :math:`P_0` is given by


.. math::
    p_0 = p  - \frac{\langle a, p \rangle - k}{\| a \|_2^2} a.

Hyperplanes :math:`\mathcal{H}` and :math:`\mathcal{K}` are parallel if they don't intersect. This occurs
if and only if they have a common normal direction.
They are different constant sets of the same
linear functional. If 
:math:`\mathcal{H}_1 : \langle a , x \rangle = k_1`
and :math:`\mathcal{H}_2 : \langle a, x \rangle  = k_2` 
are parallel hyperplanes, then the distance between 
the two hyperplanes is given by


.. math::
    d(\mathcal{H}_1 , \mathcal{H}_2) = 
    \frac{| k_1  - k_2|}{\| a \|_2}.

If :math:`\langle a, x \rangle = k`, :math:`a \neq 0`, is
a hyperplane :math:`\mathcal{H}`, then the graphs of 
:math:`\langle a , x \rangle > k` and 
:math:`\langle a , x \rangle < k` are the 
*opposite sides* or 
*opposite open half spaces* of :math:`\mathcal{H}`.
The graphs of :math:`\langle a , x \rangle \geq k` and
:math:`\langle a , x \rangle \leq k` are the 
*opposite closed half spaces* of :math:`\mathcal{H}`.
:math:`\mathcal{H}` is the *face* of the 
four half-spaces.
Corresponding to a hyperplane :math:`\mathcal{H}`, there exists
a unique pair of sets :math:`\mathcal{S}_1` 
and :math:`\mathcal{S}_2` that are the opposite sides
of :math:`\mathcal{H}`. Open half spaces are open sets
and closed half spaces are closed sets.
If :math:`A` and :math:`B` belong to the opposite sides of a 
hyperplane :math:`\mathcal{H}`, then there exists
a unique point of :math:`\mathcal{H}` that is between
:math:`A` and :math:`B`.

 
General Position
""""""""""""""""""""""""""""""""""""""""""""""""""""""

A *general position* for a set of points or other
geometric objects is a notion of genericity. In means
the general case situation as opposed to more special
and coincidental cases. For example, generically, 
two lines in a plane intersect in a single point.
The special cases are when the two lines are either parallel
or coincident. Three points in a plane in general are not
collinear. If they are, then it is a degenerate case.
A set of :math:`n+1` or more points in :math:`\RR^n` is in said to be
in general position if every subset of :math:`n` points is linearly
independent.
In general, a set of :math:`k+1` or more points in a :math:`k`-flat is said to be
in *general linear position* if no hyperplane contains
more than :math:`k` points.