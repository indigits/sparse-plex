
 
Vector spaces
===================================================


.. _def:alg:algebraic_structure:
 
Algebraic structures
----------------------------------------------------

.. index:: Algebraic structure

In mathematics, the term **algebraic structure** refers to an 
arbitrary set with one or more operations defined on it.
Simpler algebraic structures include groups, rings, and fields. 
More complex algebraic structures like vector spaces are built on 
top of the simpler structures.
We will develop the notion of vector spaces as a progression of these algebraic structures.

 
Groups
""""""""""""""""""""""""""""""""""""""""""""""""""""""

A group is a set with a single binary operation. 
It is one of the simplest
algebraic structures.


.. index:: Group

.. _def:alg:group:

.. definition:: 

     Let :math:`G` be a set and let 
     :math:`*` be a binary operation defined on :math:`G` as:
    
    .. math::
        \begin{aligned}
          * : &G \times G \to G\\
              &(g_1, g_2) \to * (g_1, g_2) \\
              &\triangleq g_1 * g_2
        \end{aligned}
    
    
    such that the binary operation :math:`*` satisfies following requirements.
    
    
    #. [Closure] The set :math:`G` is closed under the 
       binary operation :math:`*`. i.e. 
    
    
       .. math::
            \forall g_1, g_2 \in G, g_1 * g_2 \in G.

    #. [Associativity] For every :math:`g_1, g_2, g_3 \in G`
    
    
       .. math::
         g_1 * (g_2 * g_3) = (g_1 * g_2) * g_3 

    #. [Identity element] There exists an element :math:`e \in G` 
       such that 
    
    
       .. math::
           g * e = e * g = g \quad \forall g \in G

    #. [Inverse element]
       For every :math:`g \in G` there exists an element 
       :math:`g^{-1} \in G` such that
    
    
       .. math::
          g * g^{-1} = g^{-1} * g = e
    
    Then the set :math:`G` together with the 
    operator :math:`*` denoted as :math:`(G, *)` is known 
    as a **group**.

    
    


Above requirements are known as group axioms.  Note that commutativity is not a requirement of a group.

In the sequel we will write :math:`g_1 * g_2` as :math:`g_1 g_2`. 

 
Commutative groups
""""""""""""""""""""""""""""""""""""""""""""""""""""""

A commutative group is a richer structure than a group. 
Its elements also satisfy commutativity property.

.. index:: Commutative group
.. index:: Abelian group

.. _def:alg:commutative_group:

.. definition:: 

    Let :math:`(G, *)` be a group such that it satisfies
    
    * [Commutativity] For every :math:`g_1, g_2 \in G`
    
    
    .. math::
          g_1 g_2 = g_2 g_1
    
    
    Then :math:`(G,*)` is known as a **commutative group** or an **Abelian group**.


In the sequel we may simply write a group :math:`(G, *)` as :math:`G` when the underlying operation :math:`*` is
clear from context.

 
Rings
""""""""""""""""""""""""""""""""""""""""""""""""""""""

A ring is a set with two binary operations defined over it 
with some requirements as described below. 

.. index:: Associative ring

.. _def:alg:associative_ring:

.. definition:: 

    Let :math:`R` be a set with two binary operations :math:`+` (addition) and :math:`\cdot` (multiplication) defined over it as:
    
    
    .. math::
        \begin{aligned}
          + : &R \times R \to R\\
              &(r_1, r_2) \to  r_1 + r_2
        \end{aligned}
    
    
    
    .. math::
        \begin{aligned}
          \cdot : &R \times R \to R\\
              &(r_1, r_2) \to  r_1 \cdot r_2
        \end{aligned}
    
    
    such that :math:`(R, +, \cdot)` satisfies following requirements:
    
    
    #. :math:`(R, +)` is an Abelian group. 
    #. :math:`R` is closed under multiplication.
    
    
       .. math::
            r_1 \cdot r_2 \in R \quad \forall r_1, r_2 \in R

    #. Multiplication is associative.
    
    
       .. math::
            r_1 \cdot (r_2 \cdot r_3) = (r_1 \cdot r_2) \cdot r_3 \quad \forall r_1, r_2, r_3 \in R

    #. Multiplication distributes over addition.
    
    
       .. math::
            \begin{aligned}
                &r_1 \cdot (r_2 + r_3) = (r_1 \cdot r_2) + (r_1 \cdot r_3) \quad \forall r_1, r_2, r_3 \in R\\
                &(r_1 + r_2) \cdot r_3 = (r_1 \cdot r_3) + (r_2 \cdot r_3) \quad \forall r_1, r_2, r_3 \in R
            \end{aligned}
    
    Then :math:`(R, +, \cdot)` is known as an **associative ring**.
    
    We denote the identity element for :math:`+` as :math:`0` and call it additive identity.
    

In the sequel we will write :math:`r_1 \cdot r_2` as :math:`r_1 r_2`. 

We may simply write a ring :math:`(R, +, \cdot)` as :math:`R` when the underlying operations :math:`+,\cdot` are
clear from context.

There is a hierarchy of ring like structures. In particular we mention:


*  Associative ring with identity
*  Field


.. index:: Associative ring with identity


.. _def:alg:associative_ring_identity:

.. definition:: 

    Let :math:`(R, +, \cdot)` be an associative ring such that 
    it satisfies following additional requirement:
    
    *  There exists an element :math:`1 \in R` 
       (known as multiplicative identity) such that

       .. math::
            1 \cdot r = r \cdot 1 = r \quad \forall r \in R
    
    Then :math:`(R, +, \cdot)` is known as an 
    **associative ring with identity**.
 
Fields
""""""""""""""""""""""""""""""""""""""""""""""""""""""

Field is the richest algebraic structure on one set with 
two operations.


.. index:: Field

.. _def:alg:field:

.. definition:: 

    Let :math:`F` be a set with two binary operations 
    :math:`+` (addition) and :math:`\cdot` (multiplication) 
    defined over it as:
    
    .. math::
        \begin{aligned}
          + : &F \times F \to F\\
              &(x_1, x_2) \to  x_1 + x_2
        \end{aligned}
    
    .. math::
        \begin{aligned}
          \cdot : &F \times F \to F\\
              &(x_1, x_2) \to  x_1 \cdot x_2
        \end{aligned}
    
    such that :math:`(F, +, \cdot)` satisfies following requirements:
    
    
    #. :math:`(F, +)` is an Abelian group 
       (with additive identity as :math:`0 \in F`).
    #. :math:`(F \setminus \{0\}, \cdot)` is an Abelian group 
       (with multiplicative identity as :math:`1 \in F`).
    #. Multiplication distributes over addition:
    
    
       .. math::
            \alpha \cdot (\beta + \gamma) = (\alpha \cdot \beta) + (\alpha \cdot \gamma) \quad \forall \alpha, \beta, \gamma \in F
      
    
    Then :math:`(F, +, \cdot)` is known as a **field**.


.. example:: Examples of fields

    *  The set of real numbers :math:`\RR` is a field.
    *  The set of complex numbers :math:`\CC` is a field.
    *  The Galois field GF-2 is the the set :math:`\{ 0, 1 \}` 
       with modulo-2 additions and multiplications. 
    

.. index:: Vector space
 
Vector space
--------------------------------------------

We are now ready to define a vector space. 
A vector space involves two sets. 
One set :math:`\VV` contains the vectors. 
The other set :math:`\mathrm{F}` (a field) contains scalars 
which are used to scale the vectors.


.. _def:alg:vector_space:

.. definition:: 

     A set :math:`\VV` is called a **vector space** over the field
     :math:`\mathrm{F}` (or an :math:`\mathrm{F}`-vector space) 
     if there exist two mappings
    
    .. math::
        \begin{aligned}
          + : &\VV \times \VV \to \VV\\
              &(v_1, v_2) \to  v_1 + v_2 \quad v_1, v_2 \in \VV
        \end{aligned}
    
    .. math::
        \begin{aligned}
          \cdot : &\mathrm{F} \times \VV \to \VV\\
              &(\alpha, v) \to  \alpha \cdot v  \triangleq \alpha v \quad \alpha \in \mathrm{F}; v \in \VV
        \end{aligned}
        
    which satisfy following requirements:
    
    
    #. :math:`(\VV, +)` is an Abelian group.
    #. Scalar multiplication :math:`\cdot` distributes 
       over vector addition :math:`+`:  
    
    
       .. math::
            \alpha (v_1 + v_2) = \alpha v_1 + \alpha v_2 \quad \forall \alpha \in \mathrm{F}; \forall v_1, v_2 \in \VV.

    #. Addition in :math:`\mathrm{F}` distributes over 
       scalar multiplication :math:`\cdot`:
    
    
       .. math::
            ( \alpha + \beta) v = (\alpha v) + (\beta v) \quad \forall \alpha, \beta \in \mathrm{F}; \forall v \in \VV.

    #. Multiplication in :math:`\mathrm{F}` commutes over 
       scalar multiplication:
    
       .. math::
            (\alpha \beta)  \cdot v = \alpha \cdot (\beta \cdot v) = \beta  \cdot (\alpha \cdot v) = (\beta \alpha) \cdot v
            \quad \forall \alpha, \beta \in \mathrm{F}; \forall v \in \VV.

    #. Scalar multiplication from multiplicative identity 
       :math:`1 \in \mathrm{F}` satisfies the following:
    
       .. math::
            1 v = v \quad \forall v \in \VV.
    
    
Some remarks are in order:


* :math:`\VV` as defined above is also known as an
  :math:`\mathrm{F}` vector space.
* Elements of :math:`\VV` are known as vectors.
* Elements of :math:`\mathrm{F}` are known as scalars.
* There are two :math:`0` involved: :math:`0 \in \mathrm{F}` 
  and :math:`0 \in \VV`. It should be clear from context 
  which :math:`0` is being referred to.
* :math:`0 \in \VV` is known as the zero vector.
* All vectors in :math:`\VV \setminus \{0\}` are non-zero vectors.
* We will typically denote elements of :math:`\mathrm{F}` 
  by :math:`\alpha, \beta, \dots`.
* We will typically denote elements of :math:`\VV` by 
  :math:`v_1, v_2, \dots`.


We quickly look at some vector spaces which will appear again and again in our discussions.

.. index:: N-tuple vector space

.. _def:alg:n-tuple-vector-space:

.. example:: N-tuples as a vector space

    Let :math:`\mathrm{F}` be some field. 
    
    The set of all :math:`N`-tuples :math:`(a_1, a_2, \dots, a_N)` with :math:`a_1, a_2, \dots, a_N \in \mathrm{F}`
    is denoted as :math:`\mathrm{F}^N`. This is a vector space with the operations of coordinate-wise
    addition and scalar multiplication.
    
    Let :math:`u, v \in \mathrm{F}^N` with 
    
    
    .. math:: 
    
        u = (u_1, \dots, u_N)
    
    and
    
    
    .. math:: 
    
        v = (v_1, \dots, v_N).
    
    
    Addition is defined as
    
    
    .. math:: 
    
        u + v \triangleq (u_1 + v_1,  \dots, u_N + v_N).
    
    
    Let :math:`c \in \mathrm{F}`. Scalar multiplication is defined as
    
    
    .. math:: 
    
        c u \triangleq (c u_1, \dots, c u_N).
     
    
    :math:`u, v` are called equal if :math:`u_1 = v_1, \dots, u_N = v_N`.
    
    In matrix notation, vectors in :math:`\mathrm{F}^N` are also written as row vectors
    
    
    .. math:: 
    
        u = \begin{bmatrix} u_1 & \vdots & u_N \end{bmatrix}
    
    or column vectors
    
    
    .. math:: 
    
        u = \begin{bmatrix} u_1 \\ \dots \\ u_N \end{bmatrix}
    



.. index:: Matrix

.. _def:alg:matrix_vector_space:

.. example:: Matrices

    Let :math:`\mathrm{F}` be some field. A matrix is an array of the form
    
    
    .. math:: 
    
        \begin{bmatrix}
        a_{11} & a_{12} & \dots & a_{1N} \\
        a_{21} & a_{22} & \dots & a_{2N} \\
        \vdots & \vdots & \ddots &  \vdots \\
        a_{M 1} & a_{M 2} & \dots & a_{MN} \\
        \end{bmatrix}
    
    with :math:`M` rows and :math:`N` columns where :math:`a_{ij} \in \mathrm{F}`.
    
    The set of these matrices is denoted as :math:`\mathrm{F}^{M \times N}` which is a vector space with
    operations of matrix addition and scalar multiplication.
    
    Let :math:`A, B \in \mathrm{F}^{M \times N}`. Matrix addition is defined by
    
    
    .. math:: 
    
        (A + B)_{ij} \triangleq A_{ij} + B_{ij}.
    
    Let :math:`c \in \mathrm{F}`. Scalar multiplication is defined by
    
    
    .. math:: 
    
        (cA)_{ij} \triangleq c A_{ij}.
    





.. example:: Polynomials

    Let :math:`\mathrm{F}[x]` denote the set of all polynomials with coefficients drawn from
    field :math:`\mathrm{F}`. i.e. if :math:`f(x) \in \mathrm{F}[x]`, then it can be written as
    
    
    .. math:: 
    
        f(x) = a_n x^n + a_{n-1}x^{n -1} + \dots + a_1 x + a_0
    
    where :math:`a_i \in \mathrm{F}`.
    
    The set :math:`\mathrm{F}[x]` is a vector space with usual operations of addition and scalar multiplication
    
    
    .. math:: 
    
        f(x) + g(x) = (a_n + b_n)x^n + \dots + (a_1 + b_1 ) x + (a_0 + b_0).
    
    
    
    .. math:: 
    
        c f(x) = c a_n x^n + \dots + c a_1 x + c a_0.
    


Some useful results are presented without proof. 

.. _thm:vector_space_cancellation_law:

.. theorem:: 

    Let :math:`\VV` be an :math:`\mathrm{F}` vector space. Let :math:`x, y, z` be some vectors in :math:`\VV` such that
    :math:`x + z = y + z`. Then :math:`x = y`. 
    


This is known as the *cancellation law* of vector spaces.



.. corollary:: 

    The :math:`0` vector in a vector space :math:`\VV` is unique.




.. corollary:: 

    The additive inverse of a vector :math:`x` in :math:`\VV` is unique.




.. theorem:: 

    In a vector space :math:`\VV` the following statements are true

    *  :math:`0x = 0 \Forall x \in \VV`.
    *  :math:`(-a)x = - (ax) = a(-x) \Forall a \in \mathrm{F} \text{ and } x \in \VV`.
    *  :math:`a 0 = 0 \Forall a \in \mathrm{F}`. 
    
    


 
Linear independence
----------------------------------------------------


.. index:: Linear combination

.. _def:alg:linear_combination:

.. definition:: 

    A **linear combination** of two vectors :math:`v_1, v_2 \in \VV` is defined as
    
    
    .. math::
          \alpha v_1 + \beta v_2
    

    where :math:`\alpha, \beta \in \mathrm{F}`.
    
    A **linear combination** of :math:`p` vectors :math:`v_1,\dots, v_p \in \VV` is defined as
    
    
    .. math::
          \sum_{i=1}^{p} \alpha_i v_i
    
    

.. index:: Linear combination


.. _def:alg:linear_combinaton_2:

.. definition:: 

    Let :math:`\VV` be a vector space and let :math:`S` be a nonempty subset of :math:`\VV`. A vector :math:`v \in \VV` is called
    a **linear combination** of vectors of :math:`S` if there exist a finite number of vectors
    :math:`s_1, s_2, \dots, s_n \in S` and scalars :math:`a_1, \dots, a_N` in :math:`\mathrm{F}` such that
    
    
    .. math:: 
    
        v = a_1 s_1 + a_2 s_2 + \dots a_n s_n.
    
    We also say that :math:`v` is a linear combination of :math:`s_1, s_2, \dots, s_n` and :math:`a_1, a_2, \dots, a_n`
    are the coefficients of linear combination.



Note that :math:`0` is a trivial linear combination of any subset of :math:`\VV`.

Note that linear combination may refer to the expression itself or its value. e.g. two different linear combinations
may have same value.

Note that a linear combination *always* consists of a *finite* number of vectors.

.. index:: Linearly dependent

.. _def:alg:linearly_dependent:

.. definition:: 

    A finite set of non-zero vectors :math:`\{v_1, \cdots, v_p\} \subset \VV` is called **linearly dependent** if
    there exist :math:`\alpha_1,\dots,\alpha_p \in \mathrm{F}` not all :math:`0` such that
    
    
    
    .. math::
          \sum_{i=1}^{p} \alpha_i v_i = 0.
    



.. index:: Linearly dependent set

.. _def:alg:linearly_dependent_set:

.. definition:: 

    A set :math:`S \subseteq \VV` is called **linearly dependent** if there exist a finite number of distinct
    vectors :math:`u_1, u_2, \dots, u_n \in S` and scalars :math:`a_1, a_2, \dots, a_n \in \mathrm{F}` not all zero,
    such that
    
    
    .. math:: 
    
        a_1 u_1 + a_2 u_2 + \dots + a_n u_n = 0.
    





.. definition:: 

    A set :math:`S \subseteq \VV` is called **linearly independent** if it is not linearly dependent.


.. index:: Linearly independent

.. _def:alg:linearly_independent:

.. definition:: 

    More specifically a finite set of non-zero vectors 
    :math:`\{v_1, \cdots, v_n\} \subset \VV` is called **linearly independent** if
    
    
    
    .. math::
          \sum_{i=1}^{n} \alpha_i v_i = 0 \implies \alpha_i  = 0 \Forall 1 \leq i \leq n.
    






.. example:: Examples of linearly dependent and independent sets

    *  The empty set is linearly independent.
    *  A set of a single non-zero vector :math:`\{v\}` is 
       always linearly independent. Prove!
    *  If two vectors are linearly dependent, we say that 
       they are **collinear**.
    *  Alternatively if two vectors are linearly independent, 
       we say that they are not **collinear**.
    *  If a set :math:`\{v_1, \cdots, v_p\}` is linearly independent,
       then any subset of it will be linearly independent. Prove!
    *  Adding another vector :math:`v` to the set may make it 
       linearly dependent. When?
    *  It is possible to have an infinite set to be linearly 
       independent. Consider the set of polynomials 
       :math:`\{1, x, x^2, x^3, \dots\}`.  
       This set is infinite, yet linearly independent.
    




.. theorem:: 

    Let :math:`\VV` be a vector space. Let :math:`S_1 \subseteq S_2 \subseteq \VV`. If :math:`S_1` is linearly dependent,
    then :math:`S_2` is linearly dependent.




.. corollary:: 

    Let :math:`\VV` be a vector space. Let :math:`S_1 \subseteq S_2 \subseteq \VV`. If :math:`S_2` is linearly independent,
    then :math:`S_1` is linearly independent.


 
Span
----------------------------------------------------
 
Vectors can be combined to form other vectors. It makes sense to consider the set of all vectors which
can be created by combining a given set of vectors.

.. index:: Span

.. _def:alg:span:

.. definition:: 

    Let :math:`S \subset \VV` be a subset of vectors. The **span** of :math:`S` denoted as :math:`\langle S \rangle` or :math:`\Span(S)`
    is the 
    set of all possible linear combinations of vectors belonging to :math:`S`.
    
    
    .. math::
        \Span(S) \triangleq \langle S \rangle \triangleq 
        \{ v \in \VV : v = \sum_{i=1}^{p} \alpha_i v_i 
        \quad \text{for some} \quad v_i \in S; \alpha_i \in \mathrm{F}; p \in \mathbb{N}\}
    

    For convenience we define :math:`\Span(\EmptySet) = \{ 0 \}`.


Span of a finite set of vectors :math:`\{v_1, \cdots, v_p\}` is denoted by :math:`\langle v_1, \cdots, v_p \rangle`.


.. math::
        \langle v_1, \cdots, v_p \rangle = \left \{\sum_{i=1}^{p} \alpha_i v_i | \alpha_i \in \mathrm{F} \right \}.

  
We say that a set of vectors :math:`S \subseteq \VV` spans :math:`\VV` if :math:`\langle S \rangle = \VV`.




.. lemma:: 

    Let :math:`S \subseteq \VV`, then :math:`\Span (S) \subseteq \VV`.




.. definition:: 

    Let :math:`S \subset \VV`. We say that :math:`S` **spans (or generates)** :math:`\VV` if 
    
    
    .. math:: 
    
        \langle S \rangle = \VV.
    
    
    In this case we also say that vectors of :math:`S` span (or generate) :math:`\VV`.




.. theorem:: 

    Let :math:`S` be a linearly independent subset of a vector space :math:`\VV` and let :math:`v \in \VV \setminus S`. 
    Then :math:`S \cup \{ v \}` is linearly dependent if and only if :math:`v \in \Span(S)`.





 
Basis
----------------------------------------------------


.. index:: Basis

.. _def:alg:basis:

.. definition:: 

    A set of linearly independent vectors :math:`\mathcal{B}` is called a 
    **basis** of :math:`\VV` if :math:`\langle \mathcal{B} \rangle = \VV`, i.e. :math:`\mathcal{B}` spans :math:`\VV`.



.. index:: Standard basis for :math:`N`-tuples
.. index:: Standard basis for polynomials


.. _def:alg:standard_basis:

.. example:: Basis examples

    *  Since :math:`\Span(\EmptySet) = \{ 0 \}` and 
       :math:`\EmptySet` is linearly independent, 
       :math:`\EmptySet` is a basis for the zero vector space 
       :math:`\{ 0 \}`.
    *  The basis :math:`\{ e_1, \dots, e_N\}` with 
       :math:`e_1 = (1, 0, \dots, 0)`, 
       :math:`e_2 = (0, 1, \dots, 0)`, 
       :math:`\dots`, :math:`e_N = (0, 0, \dots, 1)`, 
       is called the **standard basis** for 
       :math:`\mathrm{F}^N`.
    *  The set :math:`\{1, x, x^2, x^3, \dots\}` is the 
       **standard basis** for :math:`\mathrm{F}[x]`. 
       Indeed, an infinite basis. Note that though the basis itself 
       is infinite, yet every polynomial 
       :math:`p \in \mathrm{F}[x]` is a linear combination of 
       finite number of elements from the basis.
    


We review some properties of bases.


.. index:: Unique representation

.. _thm:alg:basis_characterization_unique_representation:

.. theorem:: 

    Let :math:`\VV` be a vector space and :math:`\mathcal{B} = \{ v_1, v_2, \dots, v_n\}` be a subset of :math:`\VV`.
    Then :math:`\mathcal{B}` is a basis for :math:`\VV` if and only if each :math:`v \in \VV` can be uniquely 
    expressed as a linear combination of vectors of :math:`\mathcal{B}`:
    
    
    .. math:: 
    
        v = a_1 v_1 + a_2 v_2  + \dots + a_n v_n
    
    for unique scalars :math:`a_1, \dots, a_n`.

This theorem states that a basis :math:`\mathrm{B}` provides a unique representation
to each vector :math:`v \in \VV` where the representation is defined as the :math:`n`-tuple
:math:`(a_1, a_2, \dots, a_n)`.


If the basis is infinite, then the above theorem needs to be modified as follows:

.. _thm:alg:basis_characterization_unique_representation_infinite_basis:

.. theorem:: 

    Let :math:`\VV` be a vector space and :math:`\mathcal{B}` be a subset of :math:`\VV`.
    Then :math:`\mathcal{B}` is a basis for :math:`\VV` if and only if each :math:`v \in \VV` can be uniquely 
    expressed as a linear combination of vectors of :math:`\mathcal{B}`:
    
    
    .. math:: 
    
        v = a_1 v_1 + a_2 v_2  + \dots + a_n v_n
    
    for unique scalars :math:`a_1, \dots, a_n` and unique vectors :math:`v_1, v_2, \dots v_n \in \mathcal{B}`.




.. _thm:alg:finite_basis:

.. theorem:: 

    If a vector space :math:`\VV` is spanned by a finite set :math:`S`, then some subset of :math:`S` is a basis
    for :math:`\VV`. Hence :math:`\VV` has a finite basis.




.. _thm:alg:replacement_theorem:

.. theorem:: 

    Let :math:`\VV` be a vector space that is spanned by a set :math:`G` containing exactly :math:`n` vectors.
    Let :math:`L` be a linearly independent subset of :math:`\VV` containing exactly :math:`m` vectors.
    
    Then :math:`m \leq n` and there exists a subset :math:`H` of :math:`G` containing exactly :math:`n-m` vectors
    such that :math:`L \cup H` spans :math:`\VV`.





.. corollary:: 

    Let :math:`\VV` be a vector space having a finite basis. Then every basis for :math:`\VV` contains
    the same number of vectors.


.. index:: Finite dimensional vector space
.. index:: Infinite dimensional vector space
.. index:: Dimension of vector space


.. _def:alg:vector_space_dimension:

.. definition:: 

    A vector space :math:`\VV` is called **finite-dimensional** if it has a basis
    consisting of a finite number of vectors.
    This unique number of vectors in any basis :math:`\mathcal{B}` of the vector space :math:`\VV` 
    is called the **dimension** or **dimensionality** of the vector space. 
    It is denoted as :math:`\dim \VV`. We say:
    
    
    .. math::
          \dim \VV \triangleq |\mathcal{B}|
    
    If :math:`\VV` is not finite-dimensional, then we say that :math:`\VV` is **infinite-dimensional**.




.. example:: Vector space dimensions

    *  Dimension of :math:`\mathrm{F}^N` is :math:`N`.
    *  Dimension of :math:`\mathrm{F}^{M \times N}` is :math:`MN`.
    *  The vector space of polynomials :math:`\mathrm{F}[x]` is 
       infinite dimensional.
    
.. lemma:: 

    Let :math:`\VV` be a vector space with dimension :math:`n`. 

    #. Any finite spanning set for :math:`\VV` contains at least 
       :math:`n` vectors, and a spanning set that contains 
       exactly :math:`n` vectors is a basis for :math:`\VV`.
    #. Any linearly independent subset of :math:`\VV` that contains
       exactly :math:`n` vectors is a basis for :math:`\VV`.
    #. Every linearly independent subset of :math:`\VV` can be 
       extended to a basis for :math:`\VV`.
    

.. index:: Ordered basis

.. _def:alg:ordered_basis:

.. definition:: 

    For a finite dimensional vector space :math:`\VV`, an **ordered basis** for
    :math:`\VV` is a basis for :math:`\VV` with a specific order. In other words,
    it is a finite **sequence** of linearly independent vectors in
    :math:`\VV` that spans :math:`\VV`.



Typically we will write an ordered basis as :math:`\BBB  = \{ v_1, v_2, \dots, v_n\}`
and assume that the basis vectors are ordered in the order they appear.

With the help of an ordered basis, we can define a coordinate vector.

.. index:: Coordinate vector

.. _def:alg:coordinate_vector:

.. definition:: 

    Let :math:`\BBB  = \{ v_1, \dots, v_n\}` be an ordered basis for :math:`\VV`, and
    for :math:`x \in \VV`, let :math:`\alpha_1, \dots, \alpha_n` be unique scalars such that
    
    
    .. math:: 
    
        x = \sum_{i=1}^n \alpha_i v_i.
    
    The **coordinate vector** of :math:`x` relative to :math:`\BBB` is defined as
    
    
    .. math::
        [x]_{\BBB} = \begin{bmatrix}
        \alpha_1\\
        \vdots\\
        \alpha_n
        \end{bmatrix}.
    




 
Subspace
----------------------------------------------------

.. index:: Subspace


.. _def:alg:subspace:

.. definition:: 

    Let :math:`W` be a subset of :math:`\VV`. Then :math:`W` is called a **subspace** if :math:`W` is a vector space in its own 
    right under the same vector addition :math:`+` and scalar multiplication :math:`\cdot` operations. i.e.
    
    
    .. math::
        \begin{aligned}
          + : &\WW \times \WW \to \WW\\
              &(w_1, w_2) \to  w_1 + w_2 \quad w_1, w_2 \in \WW
        \end{aligned}
    
    
    
    .. math::
        \begin{aligned}
          \cdot : &\mathrm{F} \times \WW \to \WW\\
              &(\alpha, w) \to  \alpha \cdot w  \triangleq \alpha w \quad \alpha \in \mathrm{F}; w \in \WW
        \end{aligned}
    
    
    are defined by restricting :math:`+ : \VV \times \VV \to \VV` and :math:`\cdot : \VV \times \VV \to \VV` to :math:`W` and
    :math:`W` is closed under these operations.





.. example:: Subspaces 

    *  :math:`\VV` is a subspace of :math:`\VV`.
    *  :math:`\{0\}` is a subspace of any :math:`\VV`.
    



.. _thm:alg:subspace_verification_condition:

.. theorem:: 

    A subset :math:`\WW \subseteq \VV` is a subspace of :math:`\VV` if and only if 

    *  :math:`0 \in\WW`
    *  :math:`x + y \in\WW` whenever :math:`x, y \in\WW`
    *  :math:`\alpha x \in\WW` whenever 
       :math:`\alpha \in \mathrm{F}` and :math:`x \in\WW`.
    




.. index:: Symmetric matrices

.. _def:alg:symmetric_matrices:

.. example:: Symmetric matrices 

    A matrix :math:`M \in \mathrm{F}^{M \times N}` is **symmetric** if
    
    
    .. math:: 
    
        M^T = M.
     
    The set of symmetric matrices forms a subspace of set of all :math:`M\times N` matrices.



.. index:: Diagonal matrix

.. _def:alg:diagonal_matrix:

.. example:: Diagonal matrices

    A matrix :math:`M` is called a **diagonal** if :math:`M_{ij} = 0` whenever :math:`i \neq j`.

    
    The set of diagonal matrices is a subspace of :math:`\mathrm{F}^{M \times N}`.



.. _thm:alg:intersection_subspaces:

.. theorem:: 

    Any intersection of subspaces of a vector space :math:`\VV` is a subspace of :math:`\VV`.



We note that a union of subspaces is not necessarily a subspace, 
since it is not closed under addition. 



.. theorem:: 

    The span of a set :math:`S \subset \VV` given by :math:`\langle S \rangle` is a subspace of :math:`\VV`.
    
    Moreover any subspace of :math:`\VV` that contains :math:`S` must also contain the span of :math:`S`.


This theorem is quite useful. It allows us to construct subspaces from a given basis.

Let :math:`\mathcal{B}` be a basis of an :math:`n` dimensional space :math:`\VV`. There are :math:`n` vectors
in :math:`\mathcal{B}`. We can create :math:`2^n` distinct subsets of :math:`\mathcal{B}`. Thus we 
can construct :math:`2^n` distinct subspaces of :math:`\VV`.

Choosing some other basis lets us construct another set of subspaces. 

An :math:`n`-dimensional vector space has infinite number of bases. Correspondingly, there are
infinite possible subspaces. 

If :math:`W_1` and :math:`W_2` are two subspaces of :math:`\VV` then we say that :math:`W_1` is smaller than :math:`W_2` 
if :math:`W_1 \subset\WW _2`.



.. theorem:: 

    Let :math:`\WW` be the smallest subspace containing vectors 
    :math:`\{ v_1, \dots, v_p \}`. Then
        
    .. math::
            \WW = \langle v_1, \dots, v_p \rangle.
    
    
    i.e. :math:`\WW` is same as the span of 
    :math:`\{ v_1, \dots, v_p \}`.



.. _thm:alg:subspace_dimension:

.. theorem:: 

    Let :math:`\WW` be a subspace of a finite-dimensional vector space :math:`\VV`. Then :math:`\WW` is
    finite dimensional and 
    
    
    .. math:: 
    
        \dim \WW \leq \dim \VV.
    
    Moreover, if
    
    
    .. math:: 
    
        \dim \WW  = \dim \VV,
    
    then :math:`\WW = \VV`.





.. corollary:: 

    If :math:`\WW` is a subspace for a finite-dimensional vector space :math:`\VV` then any basis for :math:`\WW` can be
    extended to a basis for :math:`\VV`.




.. index:: Codimension

.. _def:alg:subspace_codimension:

.. definition:: 

    Let :math:`\VV` be a finite dimensional vector space and 
    :math:`\WW` be a subspace of :math:`\VV`. The **codimension**
    of :math:`\WW` is defined as
    
    
    .. math::
        \text{codim} \WW = \dim \VV - \dim \WW.
    
    




