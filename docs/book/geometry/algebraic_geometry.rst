.. _sec:algebraic_geometry:
 
Algebraic Geometry Review
===================================================

This section covers essential notions and facts from algebraic geometry needed 
for this paper. For a systematic introduction to the subject, see
:cite:`hartshorne1977algebraic,harris2013algebraic,griffiths2014principles`.
Algebraic geometry is the study of geometries that come 
from algebra. The geometrical objects being studied are
the solution sets of systems of multivariate polynomial equations. 
A data set being studied can be thought of as a collection of
sample points from a geometrical object (e.g. a union 
of subspaces). The objective is to infer the said
geometrical object from the given data set and decompose
the object into simpler objects which help in better
understanding of the data set.
 
.. _sec:polynomial_rings:

Polynomial Rings
----------------------------------------------------

Let :math:`\FF^m` be :math:`m`-dimensional vector space where :math:`\FF` 
is either :math:`\RR` or :math:`\CC` (a field of characteristic 0). 
For :math:`x = [x_1, \dots, x_m]^T \in \FF^m`,
let :math:`\FF[x] = [x_1, \dots, x_m]`
be the set of all polynomials of :math:`m` variables :math:`x_1, \dots,x_m`.
:math:`\FF[x]` is a commutative ring :cite:`artin1991algebra`. 
A monomial is a product of
variables. Its degree is the number of variables in the product. 
A monomial of degree :math:`n` is of the form 
:math:`x^n = x_1^{n_1}\dots x_m^{n_m}` with :math:`0 \leq n_j \leq n`
and :math:`n_1 + \dots + n_m = n`. There are a total of 
:math:`A_n(m) = \binom{m + n -1}{n} = \binom{m + n -1}{m - 1}`
different degree-n monomials.

We now construct an embedding of vectors in :math:`\FF^m`
to :math:`\FF^{A_n(m)}`. The Veronese map of degree :math:`n`,
denoted as :math:`v_n : \FF^m \to \FF^{A_n(m)}`, is defined as


.. math::
    v_n : [x_1, \dots, x_m]^T \to [\dots, x^n, \dots]^T

where :math:`x^n` are degree-n monomials chosen in the degree
lexicographic order. For example, the Veronese map of
degree 2 from :math:`\RR^3` to :math:`\RR^6` is defined as 


.. math:: 

    v_2(x) = v_2([x_1, x_2, x_3]^T) = [x_1^2, x_1x_2, x_1x_3,x_2^2, x_2x_3, x_3^2 ]^T.

A term is a scalar multiplying a monomial. A polynomial
:math:`p(x)` is said to be *homogeneous* if all its terms
have the same degree. 
Homogeneous polynomials are also known as *forms*.
A *linear form* is a homogeneous 
polynomial of degree 1. 
A *quadratic form* is a 
homogeneous polynomial of degree 2.
A degree-n form :math:`p(x)` can be written as 


.. math::
    p(x) = c_n^T v_n(x) = \sum c_{n_1, \dots, n_m}x_1^{n_1}\dots x_m^{n_m},

where :math:`c_{n_1, \dots, n_m} \in \FF` are the coefficients associated 
with the monomials :math:`x_1^{n_1}\dots x_m^{n_m}`. 

A *projective space* corresponding to a vector space :math:`V` is the
set of lines passing through its origin (the one dimensional subspaces).
Each such line can be represented by any non-zero point on the line.

For a degree-n form :math:`p(x)` and a scalar :math:`b \in \FF`, we have:


.. math::
    p(b x_1, \dots, b x_m ) = b^n p (x_1, \dots, x_m).

Therefore, if :math:`p(x) = 0`, then :math:`p(\alpha x) = 0 \Forall \alpha \in \FF`
and the zero-set of :math:`p(x)` includes the one dimensional subspace 
containing :math:`x` (the line passing through :math:`x` and :math:`0`). Our interest
is in the zero sets of homogeneous polynomials. Thus, it is useful
to view :math:`\FF^n` as a projective space. For a form p(x), 
p(0) is always 0. If p(a) = 0 for some :math:`a \neq 0`, then 
:math:`p(x) = 0 \Forall x = b a, b \in \FF`.

The ring :math:`\FF[x]` can be viewed as a *graded ring*:cite:`lang2002algebra` and decomposed as


.. math::
    :label: eq:graded_ring

    \FF[x] = \bigoplus_{i=0}^{\infty} \FF_0 \oplus \FF_1 \oplus \dots \FF_p \oplus \dots,

where :math:`\FF_i` consists of all homogeneous polynomials of degree :math:`i`.
:math:`\FF_0 = \FF` is the set of scalars 
(polynomials of degree 0).
:math:`\FF_1` is the set of all 1-forms:


.. math::
    \FF_1 = {b_1 x_1 + \dots + b_m x_m : [b_1, \dots b_m]^T \in \FF^m}.

Note that the polynomial :math:`0 = 0^T x` is included in every :math:`\FF_i`. 
This enables us to treat :math:`\FF_i` as a vector space of :math:`i`-forms.
:math:`\FF_1` can also be viewed as the dual-space of linear functionals
for the vector space :math:`\FF^m`. We will also need following sets
in the sequel:


.. math::
    \begin{aligned}
    &\FF_{\leq p} = \bigoplus_{i=0}^p \FF_i = \FF_0 \oplus \dots \oplus \FF_p.\\
    &\FF_{\geq p} = \bigoplus_{i=p}^{\infty}\FF_i = \FF_p \oplus \FF_{p+1}\oplus \dots.
    \end{aligned}



An *ideal* in the ring :math:`\FF[x]` is an additive subgroup
:math:`I` such that if :math:`p(x) \in I` and :math:`q(x) \in \FF[x]`, then
:math:`p(x) q(x) \in I`. :math:`\FF[x]` is a trivial ideal. :math:`I`
is called a proper ideal if :math:`I \neq \FF[x]`. A proper ideal :math:`I`
is called *maximal* if no other proper ideal of :math:`\FF[x]`
contains :math:`I`. An ideal :math:`I` is called a *subideal* of
an ideal :math:`J` if :math:`I \subset J`.

If :math:`I` and :math:`J` are two ideals in :math:`\FF[x]`,
then :math:`I \cap J` is also an ideal. An ideal :math:`I` is said to be
*generated* by a subset :math:`\GGG \subset I`, if every 
:math:`p(x) \in I` can be written as 


.. math::
    p(x) = \sum_{i=1}^k q_i(x) g_i (x), q_i(x) \in \FF[x],\, g_i(x) \in \GGG.

It is denoted by :math:`(\GGG)`. If :math:`\GGG` is finite,
:math:`(\GGG = \{ g_1, \dots, g_k\})`, then, the generated
ideal is also denoted by :math:`(g_1, \dots, g_k)`.
An ideal generated by a single element :math:`p(x)` is called a 
*principal ideal* denoted by :math:`(p(x))`.


.. math::
    (p(x)) = \{f(x) p(x) \Forall f(x) \in \FF[x] \}.

Given two ideals :math:`I` and :math:`J`, the ideal that is generated
by product of elements in :math:`I` and :math:`J` 
: :math:`\{ f(x)g(x) : f(x) \in I, g(x) \in J \}`
is called the *product ideal* :math:`IJ`. 

A prime ideal is similar to prime numbers in the
ring of integers. A proper ideal :math:`I` is called *prime*
if :math:`p(x) q(x) \in I` implies that :math:`p(x) \in I` or :math:`q(x) \in I`.
A polynomial :math:`p(x)` is said to be *prime* or *irreducible* if it generates a prime ideal.
A *homogeneous ideal* of :math:`\FF[x]` is an ideal 
generated by homogeneous polynomials. 

 
.. _sec:algebraic_sets:

Algebraic Sets
----------------------------------------------------

Given a set of homogeneous polynomials :math:`J \subset \FF[x]`,
a corresponding *projective algebraic set* :math:`Z(J) \subset \FF^m` is defined as 


.. math::
    Z(J) = \{y \in \FF^m | p(y) = 0, \Forall p(x) \in J \}.


In other words, :math:`Z(J)` is the zero set of polynomials
in :math:`J` (intersection of zero sets of each polynomial in :math:`J`).
Let :math:`I` and :math:`K` be sets of homogeneous polynomials and 
:math:`X = Z(I)` and :math:`Y = Z(K)` such that :math:`Y \subset X`. Then
:math:`Y` is called an *algebraic subset* of :math:`X`.
A nonempty algebraic set is called *irreducible*
if it is not the union of two nonempty smaller algebraic
sets. An *irreducible algebraic set* is also known as
*algebraic variety*. Any subspace of :math:`\FF^m` is
an *algebraic variety*.

Given any subset :math:`X \in \FF^m`, we define the 
*vanishing ideal* of :math:`X` as the set of all 
polynomials that vanish on :math:`X`.


.. math::
    I(X) = \{ f(x) \in \FF[x] | f(y) = 0, \Forall y \in X \}.

It is easy to see that if :math:`f(x) \in I(X)` then :math:`f(x) g(x) \in I(X)` for all :math:`g(x) \in \FF[x]`. Thus, :math:`I(X)` is indeed an ideal.


Let :math:`J \subset \FF[x]` be a set of homogeneous polynomials. 
:math:`Z(J)` is the zero set of :math:`J` (an algebraic set). 
:math:`I(Z(J))` is the vanishing
ideal of the zero set of :math:`J`. 
It can be shown that
:math:`I(Z(J))` is an ideal that contains :math:`J`.

Similarly, let :math:`X \subset \FF^m` be an arbitrary set of vectors
in :math:`\FF^m`. :math:`I(X)` is the vanishing ideal of :math:`X` and
:math:`Z(I(X))` is the zero set of the vanishing ideal of :math:`X`.
Then, :math:`Z(I(X))` is an algebraic set that contains :math:`X`. 

It turns out that irreducible algebraic sets and 
prime ideals are connected. In fact, If :math:`X` is an algebraic
set and :math:`I(X)` is the vanishing ideal of :math:`X`, then :math:`X`
is irreducible if and only if :math:`I(X)` is a prime ideal.

The natural progression is to look for a one-to-one 
correspondence between ideals and algebraic sets.
The concept of a radical ideal is useful in this context.
Given a (homogeneous) ideal :math:`I` of :math:`\FF[x]`, the 
*(homogeneous) radical ideal* of :math:`I` is defined to be


.. math::
    \text{rad}(I) = \{ f(x) \in \FF[x] | f(x)^p \in I \,\text{for some } p \in \Nat\}.

Clearly, \text{rad}(I) is an ideal in itself and :math:`I \subset \text{rad}(I)`.
:math:`\text{rad}(I)` is a fixed-point in the sense that 
:math:`\text{rad}(\text{rad}(I)) = \text{rad}(I)`.
Also, if :math:`I` is
homogeneous, then so is :math:`\text{rad}(I)`.
A theorem by Hilbert
suggests the following: If :math:`\FF` is an algebraically
closed field (e.g. :math:`\FF = \CC`) and :math:`I \subset \FF[x]` is
an (homogeneous) ideal, then


.. math::
    I(Z(I)) = \text{rad}(I).

Thus, the mappings :math:`I \to Z(I)` and :math:`X \to I(X)`
induce a one-to-one correspondence between the collection of
(projective) algebraic sets of :math:`\FF^m` and 
(homogeneous) radical ideals of :math:`\FF[x]`.
This result is known as *Nullstellensatz*.
 
.. _sec:algebraic_sampling_theory:

Algebraic Sampling Theory
----------------------------------------------------

We will now explore the problem of identifying
a (projective) algebraic set :math:`Z \in \FF^m` from a
finite number of sample points in :math:`Z`. 
In general, the algebraic set :math:`Z` may not be irreducible
and the ideal :math:`I(Z)` may not be prime. Let 
:math:`\{z_1, \dots, z_S\} \subset Z` be the finite (but 
sufficiently large) set of sample points from :math:`Z`
for the following discussion. 
For an arbitrary point :math:`z \in Z`,
we abuse :math:`z` to 
mean the corresponding projective point (i.e. the
line passing between 0 and :math:`z`). 
Let :math:`\mathfrak{m} = I(z)` be the vanishing ideal of (the line) z.
Then, :math:`\mathfrak{m}` is a *submaximal* ideal (i.e. it cannot be a subideal
of any other homogeneous ideal of :math:`\FF[x]`). Let 
:math:`\mathfrak{m}_i` be the vanishing ideal of :math:`z_i`. Then the vanishing
ideal for the set of points is 


.. math::
    \mathfrak{a}_S = \mathfrak{m}_1 \cap \dots \cap \mathfrak{m}_S.

This is a radical ideal and is in general much larger than
:math:`I(Z)`. In order to ensure that we can infer :math:`I(Z)`
correctly from the set of samples :math:`\{ z_i \}`, we need
some additional constraints. We require that :math:`I(Z)`
is generated by a set of (homogeneous) polynomials 
whose degrees are bound by a relatively small :math:`n`.


.. math::
    I(Z) = (f_1, \dots, f_s) \text{ s.t. }\, \deg(f_j) \leq n.

Then, the zero set of :math:`I` is given by


.. math::
    Z(I) = \{ z  \in \FF^m | f_i(z) = 0, i = 1, 2, \dots, s\}.

In general, :math:`I(Z)` is always a proper subideal of :math:`I_S`
regardless of how large :math:`S` is. We introduce an
algebraic sampling theorem which comes to our rescue. It
suggests that if :math:`I(Z)` is generated by polynomials in
:math:`\FF_{\leq n}`, then there is a finite sequence of
points :math:`Z_S = \{z_1, \dots, z_S \}` such that the subspace 
:math:`I(Z_S) \cap \FF_{\leq n}` generates :math:`I(Z)`. While the
theorem doesn't suggest a bound on :math:`S`, it turns out that
with probability one, the vanishing ideal of an algebraic
set can be correctly determined from a randomly chosen
sequence of samples.  This theorem is analogous to the
classical Nyquist-Shannon sampling theorem.

So far we have looked at modeling a data set as an algebraic
set and obtaining its vanishing ideal. The next step is to
extract the internal geometric or algebraic structure of the
algebraic set. The idea is to find simpler (possibly irreducible)
algebraic sets which can be composed to form the given algebraic
set. For example, if an algebraic set is a union of subspaces,
then we would like to find out the component subspaces. In other
words, given an algebraic set :math:`X` or its vanishing ideal :math:`I(X)`,
the objective is to decompose it into a union of subsets each of
which cannot be decomposed further. 

An algebraic set can have only finitely many irreducible components.
That is, there exists a finite :math:`n` such that


.. math::
    X = X_1 \cup \dots \cup X_n,

where :math:`X_i` are irreducible algebraic varieties. The vanishing
ideal :math:`I(X_i)` must be a prime ideal that is minimal over the radical
ideal :math:`I(X)` (i.e. there is no prime subideal of :math:`I(X_i)`) that
includes :math:`I(X)`. The ideal :math:`I(X)` is given by


.. math::
    I(X) = I(X_1) \cap \dots \cap I(X_n).

This is known as the *minimal primary decomposition* of the radical 
ideal :math:`I(X)`.

Given a (projective) algebraic set :math:`X` and its vanishing ideal :math:`I(Z)`, 
we can grade the ideal by degree as:


.. math::
    I(Z) = I_0(Z) \oplus I_1(Z) \oplus \dots. 

The *Hilbert function* of :math:`Z` is defined to be 


.. math::
    :label: eq:hilbert_function

    h_I(i) \triangleq \text{dim} (I_i(Z)).

:math:`h_I(i)` denotes the number of linearly independent polynomials of
degree :math:`i` that vanish on :math:`Z`. *Hilbert series* of an ideal :math:`I`
is defined as the power series:


.. math::
    \HHH(I, t)\triangleq \sum_{i=0}^{\infty} h_I(i) t^i.



 
Subspace Arrangements
----------------------------------------------------

We are interested in special class of algebraic sets known as
*subspace arrangements* in :math:`\RR^M`. A subspace arrangement is a 
finite collection of linear or affine subspaces in :math:`\RR^M`
:math:`\UUU = \{ \UUU_1, \dots, \UUU_K \}`. The set
:math:`Z_{\UUU} = \UUU_1 \cup \dots \cup \UUU_K` is the *union of subspaces*.
It is an algebraic set. We will explore the algebraic properties of 
:math:`Z_{\UUU}` in the following. We say a subspace arrangement is
*central* if every subspace passes through origin. In the sequel,
we will focus on central subspace arrangements only.

A :math:`D`-dimensional subspace :math:`V` can be defined by :math:`D' = M - D` linearly
independent linear forms :math:`\{b_1, b_2, \dots, b_{D'} \}`:


.. math::
    V = \{x \in \RR^M | b_i(x) = 0,  1 \leq i \leq D' \}.

Let :math:`V^*` denote the vector space of all linear forms that vanish on :math:`V`. Then
:math:`\dim(V^*) = D' = M - D`. 
:math:`V` is the zero set of :math:`V^*` (i.e. :math:`V = Z(V^*))`. The
vanishing ideal of :math:`V` is


.. math::
    I(V) = \{ p(x) \in \RR[x] : p(x) = 0, \Forall x \in V \}.

:math:`I(V)` is an ideal generated by linear forms in :math:`V^*`. It contains
polynomials of all degrees that vanish on :math:`V`. Every polynomial
:math:`p(x) \in I(V)` can be written as


.. math::
    p(x) = h_1 b_1 + \dots  + h_{D'} b_{D'}

where :math:`h_i \in \RR[x]`.
:math:`I(V)` is a prime ideal. 

The vanishing ideal of the subspace 
arrangement :math:`Z_{\UUU} = \UUU_1 \cup \dots \cup \UUU_K` is


.. math::
    I(Z_{\UUU}) = I(\UUU_1) \cap \dots \cap I(\UUU_K).

The ideal can be graded by degree of the polynomial as:


.. math::
    :label: eq:graded_ring_subspace_arrangement

    I(Z_{\UUU}) = I_m(Z_{\UUU}) \oplus I_{m+1}(Z_{\UUU}) \oplus \dots.

Each :math:`I_i(Z_{\UUU})` is a vector space that contains forms of degree :math:`i`
in :math:`I(Z_{\UUU})` and :math:`m\geq 1` is the least degree of the polynomials
in :math:`I(Z_{\UUU})`.
The sequence of dimensions of :math:`I_i(Z_{\UUU})` is the Hilbert function
:math:`h_I(i)` of :math:`Z_{\UUU}`.


Based on a result on the regularity of subspace arrangements 
:cite:`derksen2007hilbert`, the subspace arrangement :math:`Z_{\UUU}`
is uniquely determined as the zero set of all polynomials of degree
up to :math:`K` in its vanishing ideal. i.e. 


.. math::
    Z_{\UUU} = Z (I_0 \oplus I_1 \oplus \dots \oplus I_K).

Thus, we don't really need to determine polynomials of higher degree.

We need to characterize :math:`I(Z_{\UUU})` further. 
Recall that :math:`\UUU_k` is a (linear) subspace 
and :math:`\UUU_k^*` is the vector space of linear forms which vanish 
on :math:`\UUU_k`.
We can construct a *product of linear forms* by choosing one linear 
form from each :math:`\UUU_k^*`.
Let :math:`J(Z_{\UUU})`
be the ideal generated by the products of linear forms 


.. math::
    \{ b_1 \cdot b_2 \cdot \dots \cdot b_K: \quad b_k \in \UUU_k^* \Forall 1 \leq k \leq K \}

Equivalently, we can say that :


.. math::
    J(Z_{\UUU}) \triangleq I(\UUU_1) I(\UUU_2)  \dots I(\UUU_K) 
 
is the product ideal of the vanishing ideals of each of the subspaces.
Evidently, :math:`J(Z_{\UUU})` is a subideal in :math:`I(Z_{\UUU})`. In fact,
the two ideals share the same zero set:


.. math::
    Z_{\UUU} = Z(J(Z_{\UUU})) = Z(I(Z_{\UUU})).

Now, :math:`I(Z_{\UUU})` is the largest ideal which vanishes on
:math:`Z_{\UUU}`. In fact,  :math:`I(Z_{\UUU})` is the *radical ideal* of 
:math:`J(Z_{\UUU})`. 
Now, just like we graded :math:`I(Z_{\UUU})`, we can also grade
:math:`J(Z_{\UUU})` as:


.. math::
    J(Z_{\UUU}) = J_K(Z_{\UUU}) \oplus J_{K+1}(Z_{\UUU}) \oplus \dots.

Note that, the lowest degree of polynomials is always :math:`K` which is
the number of subspaces in :math:`\UUU`. Hilbert function of :math:`J` is
denoted as :math:`h_J(i) = \text{dim} (J_i(Z_{\UUU}))`.
It turns out that 
Hilbert functions of the vanishing ideal :math:`I` and the product ideal
:math:`J` have interesting and useful relationships.
 
.. _sec:subspace_embedding:

Subspace Embeddings
----------------------------------------------------

Let :math:`Z_{\UUU'} = \UUU'_1 \cup \dots \cup \UUU'_{K'}` be
another (central) subspace arrangement such that 
:math:`Z_{\UUU} \subseteq Z_{\UUU'}`. Then it is necessary
that for each :math:`\UUU_k`, there exists :math:`\UUU'_{k'}` such that
:math:`\UUU_k \subseteq \UUU_{k'}`. We call :math:`(Z_{\UUU} \subseteq Z_{\UUU'})`,
a *subspace embedding*. If :math:`Z_{\UUU'}` happens to be
hyperplane arrangement, we call the embedding as a 
*hyperplane embedding*. Let us consider how to
create a hyperplane embedding for a given subspace 
arrangement.

In general, the zero set of each homogeneous component
of :math:`I(Z_{\UUU})` (i.e. :math:`I_i(Z_{\UUU})`), need not be
a subspace embedding of :math:`Z_{\UUU}`. In fact, it may
not even be a subspace arrangement. However, 
the derivatives of the polynomials in :math:`I(Z_{\UUU})`
come to our rescue. We denote the derivative of 
:math:`p(x)` w.r.t. :math:`x \in \RR^M` by :math:`D p(x)`. 
Consider a polynomial :math:`p(x) \in I(Z_{\UUU})`.
Pick a point :math:`x_k` from each subspace :math:`\UUU_k` (:math:`x_k \in \UUU_k`).
Compute the derivative of :math:`p(x)` and evaluate it at :math:`x_k`
as :math:`D p(x_k)`. 
Now, construct the hyperplane :math:`H_k = \{ x : D p(x_k)^T x = 0 \}`.
Recall that the derivative of a smooth function :math:`f(x)`
is orthogonal to (the tangent space of) 
its level set :math:`f(x) = c`. Thus, :math:`H_k` contains
:math:`\UUU_k`. It turns out that if the :math:`K` points
:math:`\{ x_1, \dots, x_K \}` (from each subspace) 
are in general position, then the union of hyperplanes
:math:`\cup_{k=1}^K H_k` is a hyperplane embedding of the subspace
arrangement :math:`Z(\UUU)`.

For each polynomial in :math:`I(Z(\UUU))`, we can construct
a hyperplane embedding of the subspace arrangement :math:`Z(\UUU)`.
The intersection of hyperplane embeddings constructed from 
a collection of polynomials in :math:`I(Z(\UUU))`
is a subspace embedding of :math:`Z(\UUU)`. When this collection
of polynomials contains all the generators of :math:`I(Z(\UUU))`,
the subspace embedding becomes tight. In fact, the resulting
subspace arrangement coincides with the original one.

An ideal is said to be *pl-generated* if it is generated
by *products of linear forms*. The :math:`J(Z_{\UUU})` defined
above is a *pl-generated* ideal. If the ideal of a
subspace arrangement :math:`J(Z_{\UUU})` is pl-generated, then the
zero-set of every generator gives a hyperplane embedding 
of :math:`J(Z_{\UUU})`. 

If :math:`J(Z_{\UUU})` is a hyperplane arrangement, then 
:math:`I(J(Z_{\UUU}))` is always pl-generated as it is 
generated by a single polynomial of the form 
:math:`p(x) = (b_1^T x) \dots (b_K^T x)` where :math:`b_k \in \RR^M`
are the normal vectors to the :math:`K` hyperplanes in the 
arrangement. In fact, it is also a principal ideal.


The vanishing ideal of a single subspace
is always pl-generated. The vanishing ideal of an
arrangement of two subspaces is also pl-generated
but this is not true in general. But something can
be said if the :math:`K` subspaces in the arrangement 
are in general position.

 
Hilbert Functions of Subspace Arrangements
----------------------------------------------------


If a subspace arrangement :math:`\UUU` is in general position,
then the values of the Hilbert function :math:`h_I(i)` of
its vanishing ideal :math:`I(Z_{\UUU})` depend solely on 
the dimensions of the subspaces :math:`D_1, \dots, D_K` and they
are invariant under a continuous change of the position of the
subspaces. When identifying a subspace arrangement from
a set of samples, the first level parameters to be identified
are number of subspaces and the dimensions of each subspace.




.. disqus::




