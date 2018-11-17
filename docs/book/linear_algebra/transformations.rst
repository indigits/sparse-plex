Linear transformations
===================================================

.. contents:: :local:


In this section, we will be using symbols 
:math:`\VV` and :math:`\WW` to represent arbitrary vector spaces 
over a field :math:`\FF`. 
Unless specified the two vector spaces won't be related in any way.

Following results can be restated for more general situations 
where :math:`\VV` and :math:`\WW` are defined over
different fields, but we will assume that they are defined 
over the same field :math:`\FF` for simplicity
of discourse.


.. index:: Linear transformation
.. index:: Linear map
.. index:: Linear operator

.. _def:alg:linear_transformation:

.. definition:: 

    We call a map :math:`\TT : \VV \to \WW` a **linear transformation** from :math:`\VV` to :math:`\WW`
    if for all :math:`x, y \in \VV` and :math:`\alpha \in \FF`, we  have

    *  :math:`\TT(x + y) = \TT(x) + \TT(y)` and
    *  :math:`\TT(\alpha x) = \alpha \TT(x)`
    
    
    A linear transformation is also known as a **linear map** 
    or a **linear operator**. Usually when the domain (:math:`\VV`) and
    co-domain (:math:`\WW`) for a linear transformation are same, then the
    term linear operator is used.
    

.. remark:: 

    If :math:`\TT` is linear then :math:`\TT(0) = 0`.


This is straightforward since


.. math:: 

    \TT(0 + 0) = \TT(0) + \TT(0) \implies \TT(0) = \TT(0) + \TT(0) \implies \TT(0) = 0.



.. lemma:: 

    :math:`\TT` is linear :math:`\iff \TT(\alpha x + y) = \alpha \TT(x) + \TT(y)  \Forall x, y \in \VV, \alpha \in \FF`




.. proof:: 

    Assuming :math:`\TT` to be linear we have
    
    
    .. math:: 
    
        \TT(\alpha x + y) = \TT(\alpha x) + \TT(y) = \alpha \TT(x) + \TT(y).
    
    
    Now for the converse, assume
    
    
    .. math:: 
    
        \TT(\alpha x + y) = \alpha \TT(x) + \TT(y)  \Forall x, y \in \VV, \alpha \in \FF.
    
    
    Choosing both :math:`x` and :math:`y` to be  0 and :math:`\alpha=1` we get
    
    
    .. math:: 
    
        \TT(0 + 0) = \TT(0) + \TT(0) \implies \TT(0) = 0.
    
    
    Choosing :math:`y=0` we get
    
    
    .. math:: 
    
        \TT(\alpha x + 0) = \alpha \TT(x) + \TT(0) = \alpha \TT(x).
    
    
    Choosing :math:`\alpha = 1` we get
    
    
    .. math:: 
    
        \TT(x + y) = \TT(x) + \TT(y).
    
    Thus :math:`\TT` is a linear transformation.


.. remark:: 

    If :math:`\TT` is linear then :math:`\TT(x - y) = \TT(x) - \TT(y)`



.. math:: 

    \TT(x - y) = \TT(x + (-1)y) = \TT(x) + \TT((-1)y) = \TT(x) +(-1)\TT(y) = \TT(x) - \TT(y).



.. remark:: 

    :math:`\TT` is linear :math:`\iff` for :math:`x_1, \dots, x_n \in \VV` and :math:`\alpha_1, \dots, \alpha_n \in \FF`,
    
    
    .. math:: 
    
        \TT\left (\sum_{i=1}^{n} \alpha_i x_i \right ) =  \sum_{i=1}^{n} \alpha_i  \TT(x_i).
    

We can use mathematical induction to prove this. 

Some special linear transformations need mention.

.. index:: Identity transformation

.. _def:alg:identity_transformation:

.. definition:: 

    The **identity transformation** 
    :math:`\mathrm{I}_{\VV} : \VV \to \VV` is defined as
    
    .. math:: 
    
        \mathrm{I}_{\VV}(x) = x, \Forall x \in \VV.

.. index:: Zero transformation

.. _def:alg:zero_transformation:

.. definition:: 

    The **zero transformation** :math:`\mathrm{0} : \VV \to \WW` is defined as
    
    
    .. math:: 
    
        0(x) = 0, \Forall x \in \VV.
    


In this definition :math:`0` is taking up multiple meanings: 
a linear transformation from
:math:`\VV` to :math:`\WW` which maps every vector 
in :math:`\VV` to the :math:`0` vector in :math:`\WW`.

From the context usually it should be obvious whether 
we are talking about :math:`0 \in \FF` or 
:math:`0 \in \VV` or :math:`0 \in \WW` or 
:math:`0` as a linear transformation 
from :math:`\VV` to :math:`\WW`. 

 
Null space and range
----------------------------------------------------


.. index:: Null space
.. index:: Kernel


.. _def:alg:nullspace:

.. definition:: 

    The **null space** or **kernel** of a linear transformation 
    :math:`\TT : \VV \to \WW` 
    denoted by :math:`\NullSpace(\TT)` or 
    :math:`\Kernel(\TT)` is defined as 
    
    
    .. math::
        \Kernel(\TT) = \NullSpace(\TT) \triangleq \{ x \in \VV : \TT(x) = 0\}
    



.. _thm:nullspace_is_subspace:

.. theorem:: 

    The null space of a linear transformation :math:`\TT : \VV \to \WW`
    is a subspace of :math:`\VV`.





.. proof:: 

    Let :math:`v_1, v_2 \in \Kernel(\TT)`. Then
    
    
    .. math:: 
    
        \TT(\alpha v_1 + v_2) = \alpha \TT(v_1) + \TT(v_2) = \alpha 0 + 0 = 0. 
    
    Thus :math:`\alpha v_1 + v_2 \in \Kernel(\TT)`. Thus :math:`\Kernel(\TT)` is a subspace of :math:`\VV`.


.. index:: Range
.. index:: Image


.. _def:alg:image:

.. definition:: 

    The **range** or **image** of a linear transformation 
    :math:`\TT : \VV \to \WW`
    denoted by :math:`\Range(\TT)` or :math:`\Image(\TT)` is defined as
    
    
    .. math::
        \Range(\TT) = \Image(\TT) \triangleq \{\TT(x) \Forall x \in \VV \}.
    
    We note that :math:`\Image(\TT) \subseteq \WW`.




.. _thm:image_is_subspace:

.. theorem:: 

    The image of a linear transformation :math:`\TT : \VV \to \WW`
    is a subspace of :math:`\WW`.

.. proof:: 

    Let :math:`w_1, w_2 \in \Image(\TT)`. Then there exist :math:`v_1, v_2 \in \VV` such that 
    
    
    .. math:: 
    
        w_1 = \TT(v_1); w_2 = \TT(v_2).
    
    Thus
    
    
    .. math:: 
    
        \alpha w_1 + w_2 = \alpha \TT(v_1) + \TT(v_2) = \TT(\alpha v_1 + v_2).
    
    Thus :math:`\alpha w_1 + w_2 \in \Image(\TT)`. Hence :math:`\Image(\TT)` is a subspace of :math:`\WW`.



.. _thm:basis_image_spans_whole_image:

.. theorem:: 

    Let :math:`\TT : \VV \to \WW` be a linear transformation. 
    Let :math:`\mathcal{B} = \{v_1, v_2, \dots, v_n\}` be some 
    basis of :math:`\VV`. Then 
    
    .. math::
        \Image(\TT) = \langle \TT(\mathcal{B}) \rangle = 
        \langle\{\TT(v_1), \TT(v_2), \dots, \TT(v_n) \} \rangle.
    
    i.e. The image of a basis of :math:`\VV` under a linear transformation :math:`\TT` 
    spans the range of the transformation.

.. proof:: 

    Let :math:`w` be some arbitrary vector in :math:`\Image(\TT)`.
    Then there exists :math:`v \in \VV` such that :math:`w = \TT(v)`.
    Now
    
    
    .. math:: 
    
        v = \sum_{i=1}^n c_i v_i
    
    since :math:`\mathcal{B}` forms a basis for :math:`\VV`.
    
    Thus 

    .. math:: 
    
        w = \TT(v) = \TT(\sum_{i=1}^n c_i v_i)  = \sum_{i=1}^n c_i(\TT(v_i)).
    
    This means that :math:`w \in \langle \TT(\mathcal{B}) \rangle`.

.. index:: Nullity


.. _def:alg:nullity:

.. definition:: 

    For vector spaces :math:`\VV` and :math:`\WW` and 
    linear :math:`\TT : \VV \to \WW` if
    :math:`\Kernel{\TT}` is finite dimensional then 
    **nullity** of :math:`\TT` is
    defined as 
    
    .. math::
        \Nullity(\TT) = \dim \Kernel(\TT)
    
    i.e. the dimension of the null space or kernel of :math:`\TT`.
    
.. index:: Rank

.. _def:alg:rank:

.. definition:: 

    For vector spaces :math:`\VV` and :math:`\WW` and linear 
    :math:`\TT : \VV \to \WW` if
    :math:`\Image{\TT}` is finite dimensional then 
    **rank** of :math:`\TT` is
    defined as 
    
    .. math::
        \Rank(\TT) = \dim \Image(\TT)
    
    i.e. the dimension of the range or image of :math:`\TT`.


.. index:: Dimension theorem

.. _thm:alg:dimension_theorem:

.. theorem:: 

    For vector spaces :math:`\VV` and :math:`\WW` 
    and linear :math:`\TT : \VV \to \WW` if
    :math:`\VV` is finite dimensional, then
        
    .. math::
        \dim \VV = \Nullity(\TT) + \Rank(\TT).
    
    This is known as **dimension theorem**.

.. _thm:alg:one_one_transformation_nullspace:

.. theorem:: 

    For vector spaces :math:`\VV` and :math:`\WW` and 
    linear :math:`\TT : \VV \to \WW`, :math:`\TT`
    is one-one if and only if :math:`\Kernel(\TT) = \{ 0\}`.

.. proof:: 

    If :math:`\TT` is one-one, then
    
    .. math:: 
    
        v_1 \neq v_2 \implies T(v_1) \neq T(v_2)
    
    Let :math:`v \neq 0`. Now :math:`\TT(0) = 0 \implies \TT(v) \neq 0` since :math:`\TT` is one-one.
    Thus :math:`\Kernel(\TT) = \{ 0\}`.
    
    For converse let us assume that :math:`\Kernel(\TT) = \{ 0\}`. 
    Let :math:`v_1, v_2 \in V` be
    two vectors in :math:`V` such that
    
    
    .. math:: 
    
        &\TT(v_1) = \TT(v_2) \\
        \implies &\TT(v_1 - v_2)   = 0 \\
        \implies &v_1 - v_2 \in \Kernel(\TT)\\
        \implies &v_1 - v_2 = 0 \\
        \implies &v_1 = v_2.
    
    Thus :math:`\TT` is one-one.



.. _thm:alg:one-one-onto-transformation:

.. theorem:: 

    For vector spaces :math:`\VV` and :math:`\WW` of equal finite
    dimensions and linear :math:`\TT : \VV \to \WW`, 
    the following are equivalent.

    a.  :math:`\TT` is one-one.
    #.  :math:`\TT` is onto.
    #.  :math:`\Rank(\TT) = \dim (\VV)`.

.. proof:: 

    From (a) to (b)
    
    Let :math:`\mathcal{B} = \{v_1, v_2, \dots v_n \}` be 
    some basis of :math:`\VV`
    with :math:`\dim \VV = n`.
    
    Let us assume that :math:`\TT(\mathcal{B})` are 
    linearly dependent. Thus there 
    exists a linear relationship
    
    
    .. math:: 
    
        \sum_{i=1}^{n}\alpha_i \TT(v_i) = 0
    
    where :math:`\alpha_i` are not all 0.
    
    Now 
    
    
    .. math:: 
    
        &\sum_{i=1}^{n}\alpha_i \TT(v_i) = 0 \\
        \implies &\TT\left(\sum_{i=1}^{n}\alpha_i v_i\right) = 0\\
        \implies &\sum_{i=1}^{n}\alpha_i v_i \in \Kernel(\TT)\\
        \implies &\sum_{i=1}^{n}\alpha_i v_i = 0
    
    since :math:`\TT` is one-one.
    This means that :math:`v_i` are linearly dependent. 
    This contradicts our assumption that 
    :math:`\mathcal{B}` is a basis for :math:`\VV`.
    
    Thus :math:`\TT(\mathcal{B})` are linearly independent. 
    
    Since :math:`\TT` is one-one, hence all vectors in 
    :math:`\TT(\mathcal{B})` 
    are distinct, hence
    
    .. math:: 
    
        | \TT(\mathcal{B}) | = n.
    
    
    Since :math:`\TT(\mathcal{B})` span :math:`\Image(\TT)` 
    and are linearly independent, hence 
    they form a basis of :math:`\Image(\TT)`.    
    But 
    
    .. math:: 
    
        \dim \VV = \dim \WW = n
    
    and :math:`\TT(\mathcal{B})` are a set of :math:`n` 
    linearly independent vectors in :math:`\WW`.
    
    Hence :math:`\TT(\mathcal{B})` form a basis of :math:`\WW`. Thus
        
    .. math:: 
    
        \Image(\TT)  = \langle \TT(\mathcal{B}) \rangle = \WW.
    
    Thus :math:`\TT` is on-to.
    
    From (b) to (c)
    :math:`\TT` is on-to means :math:`\Image(\TT) = \WW` thus
        
    .. math:: 
    
        \Rank(\TT) = \dim \WW = \dim \VV.
    
    
    From (c) to (a)
    We know that
    
    
    .. math:: 
    
        \dim \VV = \Rank(\TT) + \Nullity(\TT).
    
    But it is given that :math:`\Rank(\TT) = \dim \VV`.
    Thus
    
    
    .. math:: 
    
        \Nullity(\TT) = 0.
    
    Thus :math:`\TT` is one-one.


 
Bracket operator
----------------------------------------------------


Recall the definition of coordinate vector 
from :ref:`here <def:alg:coordinate_vector>`.
Conversion of a given vector to its coordinate vector 
representation can be shown
to be a linear transformation.

.. index:: Bracket operator


.. _def:alg:bracket_operator:

.. definition:: 

    Let :math:`\VV` be a finite dimensional vector space over a field :math:`\FF` where
    :math:`\dim \VV = n`. Let :math:`\BBB  = \{ v_1, \dots, v_n\}` be an ordered basis
    in :math:`\VV`. We define a bracket operator from :math:`\VV` to :math:`\FF^n` as 
    
    
    .. math::
        \begin{aligned}
        \Bracket_{\BBB} : &\VV \to \FF^n\\
        & x \to [x]_{\BBB}\\
        & \triangleq \begin{bmatrix}
        \alpha_1\\
        \vdots\\
        \alpha_n
        \end{bmatrix}
        \end{aligned}
    
    where
    
    
    .. math:: 
    
        x = \sum_{i=1}^n \alpha_i v_i.
    

In other words, the bracket operator takes a vector :math:`v` from a finite dimensional
space :math:`\VV` to its representation in :math:`\FF^n` for a given basis
:math:`\BBB`.

We now show that the bracket operator is linear.


.. _thm:alg:bracket_operator_is_linear:

.. theorem:: 

    Let :math:`\VV` be a finite dimensional vector space over a field :math:`\FF` where
    :math:`\dim \VV = n`. Let :math:`\BBB  = \{ v_1, \dots, v_n\}` be an ordered basis
    in :math:`\VV`.
    The bracket operator :math:`\Bracket_{\BBB} : \VV \to \FF^n`
    as defined :ref:`here <def:alg:bracket_operator>` is a
    linear operator.
    
    Moreover :math:`\Bracket_{\BBB}` is a one-one and onto mapping.
    





.. proof:: 

    Let :math:`x, y \in \VV` such that
    
    
    .. math:: 
    
        x = \sum_{i=1}^n \alpha_i v_i.
    
    and 
    
    
    .. math:: 
    
        y = \sum_{i=1}^n \beta_i v_i.
    
    Then 
    
    
    .. math:: 
    
        c x + y = c \sum_{i=1}^n \alpha_i v_i + \sum_{i=1}^n \beta_i v_i 
        = \sum_{i=1}^n (c \alpha_i + \beta_i ) v_i.
    
    Thus
    
    
    .. math:: 
    
        [c x + y]_{\BBB} =
        \begin{bmatrix}
        c \alpha_1 + \beta_1 \\
        \vdots\\
        c \alpha_n + \beta_n 
        \end{bmatrix} 
        = c 
        \begin{bmatrix}
        \alpha_1 \\
        \vdots\\
        \alpha_n 
        \end{bmatrix} 
        +
        \begin{bmatrix}
        \beta_1 \\
        \vdots\\
        \beta_n 
        \end{bmatrix} 
        = c [x]_{\BBB} + [y]_{\BBB}.
    
    Thus :math:`\Bracket_{\BBB}` is linear.
    
    We can see that by definition :math:`\Bracket_{\BBB}` is one-one. Now since
    :math:`\dim \VV = n = \dim \FF^n` hence :math:`\Bracket_{\BBB}` is on-to 
    due to :ref:`here <thm:alg:one-one-onto-transformation>`.



 
Matrix representations
----------------------------------------------------

It is much easier to work with a matrix representation of
a linear transformation. In this section we describe
how matrix representations of a linear transformation are
developed. 

In order to develop a representation for the map
:math:`\TT : \VV \to \WW` we first need to choose
a representation for vectors in :math:`\VV` and :math:`\WW`. 
This can be easily done by choosing a basis in :math:`\VV` and
another in :math:`\WW`. Once the bases are chosen, then we
can represent vectors as coordinate vectors. 

.. index:: Matrix representation of linear operator

.. _def:alg:matrix_representation_linear_operator:

.. definition:: 

    Let :math:`\VV` and :math:`\WW` be finite dimensional vector spaces
    with ordered bases :math:`\BBB = \{v_1, \dots, v_n\}`
    and :math:`\Gamma = \{w_1, \dots,w_m\}` respectively.
    Let :math:`\TT : \VV \to \WW` be a linear transformation.
    For each :math:`v_j \in \BBB` we can find a unique representation
    for :math:`\TT(v_j)` in :math:`\Gamma` given by
    
    
    .. math::
        \TT(v_j) = \sum_{i=1}^{m} a_{ij} w_i \Forall 1 \leq j \leq n.
    
    The :math:`m\times n` matrix :math:`A` defined by :math:`A_{ij} = a_{ij}` is the
    **matrix representation** of :math:`\TT` in the ordered bases
    :math:`\BBB` and :math:`\Gamma`, denoted as 
    
    
    .. math::
        A = [\TT]_{\BBB}^{\Gamma}.
    
    If :math:`\VV = \WW` and :math:`\BBB = \Gamma` then we write
    
    
    .. math::
        A = [\TT]_{\BBB}.
    



The :math:`j`-th column of :math:`A` is the representation of :math:`\TT(v_j)` in
:math:`\Gamma`.

In order to justify the matrix representation of :math:`\TT` we
need to show that application of :math:`\TT` is same as multiplication
by :math:`A`. This is stated formally below.


.. _thm:matrix_representation_justification:

.. theorem:: 

    
    
    .. math::
        [\TT (v)]_{\Gamma} = [\TT]_{\BBB}^{\Gamma} [v]_{\BBB} \Forall v \in \VV.
    




.. proof:: 

    Let 
    
    
    .. math:: 
    
        v = \sum_{j=1}^{n} c_j v_j.
    
    
    Then
    
    
    .. math:: 
    
        [v]_{\BBB}  = 
        \begin{bmatrix}
        c_1\\
        \vdots\\
        c_n
        \end{bmatrix}
    
    Now
    
    
    .. math:: 
    
        \TT(v) &= \TT\left( \sum_{j=1}^{n} c_j v_j \right)\\
        &= \sum_{j=1}^{n} c_j \TT(v_j)\\
        &= \sum_{j=1}^{n} c_j \sum_{i=1}^{m} a_{ij} w_i\\
        &= \sum_{i=1}^{m} \left (  \sum_{j=1}^{n} a_{ij} c_j \right ) w_i\\
    
    Thus
    
    
    .. math:: 
    
        [\TT (v)]_{\Gamma} = \begin{bmatrix}
        \sum_{j=1}^{n} a_{1 j} c_j\\
        \vdots\\
        \sum_{j=1}^{n} a_{m j} c_j
        \end{bmatrix}
        = A \begin{bmatrix}
        c_1\\
        \vdots\\
        c_n
        \end{bmatrix}
        = [\TT]_{\BBB}^{\Gamma} [v]_{\BBB}.
    


 
Vector space of linear transformations
----------------------------------------------------


If we consider the set of linear transformations from :math:`\VV` to :math:`\WW`
we can impose some structure on it and take its advantages.

First of all we will define basic operations like addition and scalar
multiplication on the general set of functions from a vector
space :math:`\VV` to another vector space :math:`\WW`.


.. index:: Addition of linear transformations
.. index:: Scalar multiplication of linear transformation

.. _def:addition_linear_transformations:

.. definition:: 

    Let :math:`\TT` and :math:`\UU` be arbitrary functions from vector space :math:`\VV` 
    to vector space :math:`\WW` over the field :math:`\FF`. 
    Then **addition** of functions is defined as
    
    
    .. math::
        (\TT + \UU)(v) = \TT(v) + \UU(v)  \Forall v \in \VV.
    
    **Scalar multiplication** on a function is defined as
    
    
    .. math::
        (\alpha \TT)(v) = \alpha (\TT (v)) \Forall \alpha \in \FF, v \in \VV.
    

With these definitions we have


.. math:: 

    (\alpha \TT + \UU)(v) = (\alpha \TT)(v) + \UU(v) = \alpha (\TT (v)) + \UU(v).



We are now ready to show that with the addition and scalar multiplication
as defined above, the set of linear transformations from :math:`\VV` to :math:`\WW` 
actually forms a vector space.


.. _thm:vector_space_linear_transformations:

.. theorem:: 

    Let :math:`\VV` and :math:`\WW` be vector spaces over field :math:`\FF`. 
    Let :math:`\TT` and :math:`\UU` be some linear transformations from :math:`\VV` to
    :math:`\WW`. Let addition and scalar multiplication of linear transformations
    be defined as in :ref:`here <def:addition_linear_transformations>`.
    Then :math:`\alpha \TT + \UU` where :math:`\alpha \in \FF` is a linear transformation.
    
    Moreover the set of linear transformations from :math:`\VV` to :math:`\WW` forms
    a vector space.





.. proof:: 

    We first show that :math:`\alpha \TT + \UU` is linear.
    
    Let :math:`x,y \in \VV` and :math:`\beta \in \FF`. Then we need to show that
    
    
    .. math::
        (\alpha \TT + \UU) (x + y) = (\alpha \TT + \UU) (x) + (\alpha \TT + \UU) (y)\\
        (\alpha \TT + \UU) (\beta x) = \beta ((\alpha \TT + \UU) (x)).
    
    
    Starting with the first one:
    
    
    
    .. math:: 
    
        (\alpha \TT + \UU)(x + y) 
        &= (\alpha \TT)(x + y) + \UU(x + y)\\
        &= \alpha ( \TT (x + y) ) + \UU(x) + \UU(y)\\
        &= \alpha \TT (x) + \alpha \TT(y) + \UU(x) + \UU(y)\\
        &= (\alpha \TT) (x) + \UU (x) + (\alpha \TT)(y) + \UU(y)\\
        &= (\alpha \TT + \UU)(x) + (\alpha \TT + \UU)(y).
    
    
    Now the next one
    
    
    .. math:: 
    
        (\alpha \TT + \UU) (\beta x) 
        &= (\alpha \TT ) (\beta x) + \UU (\beta x)\\
        &= \alpha (\TT(\beta x)) + \beta (\UU (x))\\
        &= \alpha (\beta (\TT (x))) +  \beta (\UU (x))\\
        &= \beta (\alpha (\TT (x))) + \beta (\UU(x))\\
        &= \beta ((\alpha \TT)(x) + \UU(x))\\
        &= \beta((\alpha \TT + \UU)(x)).
    
    
    We can now easily verify that the set of linear transformations
    from :math:`\VV` to :math:`\WW` satisfies all the requirements of a vector space.
    Hence its a vector space (of linear transformations from :math:`\VV` to :math:`\WW`).


.. index:: Vector space of linear transformations

.. _def:alg_linear_transformations_space:

.. definition:: 

    Let :math:`\VV` and :math:`\WW` be vector spaces over field :math:`\FF`. Then
    the **vector space of linear transformations** from :math:`\VV` to :math:`\WW`
    is denoted by :math:`\LinTSpace(\VV, \WW)`.
    
    When :math:`\VV = \WW` then it is simply denoted by :math:`\LinTSpace(\VV)`.



The addition and scalar multiplication as defined in
:ref:`here <def:addition_linear_transformations>` carries 
forward to matrix representations of linear transformations also.

 
.. _thm:alg:lin_trans_matrix_rep_add_scale:

.. theorem:: 

    Let :math:`\VV` and :math:`\WW` be finite dimensional vector spaces over field :math:`\FF`
    with :math:`\BBB` and :math:`\Gamma` being their respective bases. 
    Let :math:`\TT` and :math:`\UU` be some linear transformations from :math:`\VV` to
    :math:`\WW`.
    
    Then the following hold

    *  :math:`[\TT + \UU]_{\BBB}^{\Gamma} = [\TT]_{\BBB}^{\Gamma} + [\UU]_{\BBB}^{\Gamma}`
    *  :math:`[\alpha \TT]_{\BBB}^{\Gamma} = \alpha [\TT]_{\BBB}^{\Gamma} \Forall \alpha \in \FF`
    
    




 
Composition of linear transformations
----------------------------------------------------

