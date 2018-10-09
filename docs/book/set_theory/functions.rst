
 
Functions
===================================================



.. index:: Function
.. index:: Function!Domain
.. index:: Function!Range

.. definition:: 

    A **function** from a set :math:`A` to a set :math:`B`, in symbols :math:`f : A \to B` (or :math:`A \xrightarrow{f} B`
    or :math:`x \mapsto f(x)`) is a specific *rule* that assigns to each element :math:`x \in A` a unique element
    :math:`y \in B`.
    
    We say that the element :math:`y` is the **value** of the function :math:`f` at :math:`x` (or the **image**
    of :math:`x` under :math:`f`) and denote as :math:`f(x)`, that is, :math:`y = f(x)`.
    
    We also sometimes say that :math:`y` is the **output** of :math:`f` when the **input** is :math:`x`.
    
    The set :math:`A` is called **domain** of :math:`f`.
    The set :math:`\{y \in B : \exists x \in A \text{ with } y = f(x)\}` is called the
    **range** of :math:`f`.



.. example:: Dirichlet's unruly indicator function for rational numbers

    
    
    .. math:: 
    
        g(x) = 
         \left\{
                \begin{array}{ll}
                    1 & \mbox{if $x \in \QQ$};\\
                    0 & \mbox{if $x \notin \QQ$}.
                \end{array}
              \right.
    
    This function is not continuous anywhere on the real line.




.. example:: Absolute value function

    
    
    .. math:: 
    
        | x | = 
         \left\{
                \begin{array}{ll}
                    x & \mbox{if $x \geq 0$};\\
                    -x & \mbox{if $x < 0$}.
                \end{array}
              \right.
    
    This function is continuous but not differentiable at :math:`x=0`.




.. index:: Function!Equality

.. definition:: 

    Two functions :math:`f : A \to B` and :math:`g : A \to B` are said to be **equal**,
    in symbols :math:`f = g` if :math:`f(x) = g(x) \quad \forall x \in A`. 




.. index:: Function!Surjective

.. definition:: 

    A function :math:`f : A \to B` is called **onto** or **surjective** if the range of :math:`f` is
    all of :math:`B`. i.e. for every :math:`y \in B`, there exists (at least one) :math:`x \in A` such that
    :math:`y = f(x)`.


.. index:: Function!Injective

.. definition:: 

    A function :math:`f : A \to B` is called injective if :math:`x_1 \neq x_2 \implies f(x_1) \neq f(x_2)`.




.. index:: Function!Image


.. definition:: 

    Let :math:`f : X \to Y` be  a function. If :math:`A \subseteq X`, then **image** of :math:`A` under :math:`f`
    denoted as :math:`f(A)` (a subset of :math:`Y`) is defined by
    
    
    .. math::
        	f(A) = \{  y \in Y : \exists x \in A \text{ such that } y = f(x)\}.
    



.. index:: Function!Inverse image

.. _def:set:inverse_image:

.. definition:: 


    If :math:`B` is a subset of :math:`Y` then the **inverse image** :math:`f^{-1}(B)` of :math:`B` under :math:`f` 
    is the subset of :math:`X` defined by
    
    
    .. math::
        	f^{-1} (B) = \{ x \in X : f(x) \in B\}.
    


Let :math:`\{A_i\}_{i \in I}`  be a family of subsets of :math:`X`.

Let :math:`\{B_i\}_{i \in I}` be a family of subsets of :math:`Y`.

Then the following results hold:


.. math::
    & f ( \cup_{i \in I} A_i) = \cup_{i \in I} f(A_i)\\
    & f (\cap_{i \in I} A_i) \subseteq \cap_{i \in I} f(A_i) \\
    & f^{-1} (\cup_{i \in I} B_i) = \cup_{i \in I}f^{-1} (B_i)\\
    & f^{-1} (\cap_{i \in I} B_i) = \cap_{i \in I}f^{-1} (B_i)\\
    & f^{-1}(B^c) = (f^{-1}(B))^c 



.. index:: Composition


.. definition:: 

    Given two functions :math:`f : X \to Y` and :math:`g : Y \to Z`, their **composition** 
    :math:`g \circ f` is the function :math:`g \circ f : X \to Z` defined by 
    
    
    .. math::
        	(g \circ f)(x) = g(f(x)) \quad \forall x \in X.
    


.. _res:composition_of_one_one_functions:

.. theorem:: 


    Given two one-one functions :math:`f : X \to Y` and :math:`g : Y \to Z`, their composition
    :math:`g \circ f` is one-one.



.. proof:: 

    Let :math:`x_1, x_2 \in X`. We need to show that :math:`g(f(x_1)) = g(f(x_2)) \implies x_1 = x_2`.
    Since :math:`g` is one-one, hence  :math:`g(f(x_1)) = g(f(x_2)) \implies f(x_1) = f(x_2)`. 
    Further, since :math:`f` is one-one, hence :math:`f(x_1) = f(x_2) \implies x_1 = x_2`.



.. _res:composition_of_onto_functions:

.. theorem:: 


    Given two onto functions :math:`f : X \to Y` and :math:`g : Y \to Z`, their composition
    :math:`g \circ f` is onto.



.. proof:: 

    Let :math:`z \in Z`. We need to show that there exists :math:`x \in X` such that
    :math:`g(f(x)) = z`. 
    Since :math:`g` is on-to, hence for every :math:`z \in Z`, there exists :math:`y \in Y`
    such that :math:`z = g(y)`. Further, since :math:`f` is onto, for every :math:`y \in Y`, there exists :math:`x \in X`
    such that :math:`y = f(x)`. Combining the two, for every :math:`z \in Z`, there exists :math:`x \in X` such
    that :math:`z = g(f(x))`.



.. _res:composition_of_one_one_onto_functions:

.. theorem:: 


    Given two one-one onto functions :math:`f : X \to Y` and :math:`g : Y \to Z`, their composition
    :math:`g \circ f` is one-one onto.



.. proof:: 

    This is a direct result of combining :ref:`here <res:composition_of_one_one_functions>`
    and :ref:`here <res:composition_of_onto_functions>`.


.. index:: Inverse of a function

.. _def:set:inverse_function:

.. definition:: 


    If a function :math:`f : X \to Y` is one-one and onto, then for every :math:`y \in Y`
    there exists a unique :math:`x \in X` such that :math:`y = f(x)`.  This unique element
    is denoted by :math:`f^{-1}(y)`. Thus a function :math:`f^{-1} : Y \to X` can be defined
    by 
    
    
    .. math::
        f^{-1}(y) = x \text{ whenever } f(x) = y.	
    
    
    The function :math:`f^{-1}` is called the **inverse** of :math:`f`.


We can see that :math:`(f \circ f^{-1})(y) = y` for all :math:`y \in Y`.

Also :math:`(f^{-1} \circ f) (x) = x` for all :math:`x \in X`.


.. index:: Identity function


.. definition:: 

    We define an **identity** function on a set :math:`X` as
    
    
    .. math::
        \begin{aligned}
        	I_X : &X \to X\\
        	      & I_X(x) = x \quad \forall x \in X
        \end{aligned}
    


.. remark:: 

    Identify function is bijective.

Thus we have:


.. math::
    	& f \circ f^{-1} = I_Y.\\
    	& f^{-1} \circ f = I_X.


If :math:`f : X \to Y` is one-one, then we can define a function 
:math:`g : X \to f(Y)` given by :math:`g(x) = f(x)`. This function is 
one-one and onto. Thus :math:`g^{-1}` exists. We will use this
idea to define an inverse function for a one-one function :math:`f` 
as :math:`f^{-1} : f(X) \to X` given by :math:`f^{-1}(y) = x \Forall y \in f(X)`.
Clearly :math:`f^{-1}` so defined is one-one and onto between :math:`X` and :math:`f(X)`.


.. index:: Schroeder-Bernstein Theorem

.. _res:function:schroder_bernstein_theorem:

.. theorem:: 


    Given two one-one functions :math:`f : X \to Y` and :math:`g : Y \to X`, 
    there exists a one-one onto function :math:`h : X \to Y`.



.. proof:: 

    Clearly, we can define a one-one onto function :math:`f^{-1} : f(X) \to X` and
    another one-one onto function :math:`g^{-1} : g(Y) \to Y`. 
    Let the two-sided sequence :math:`C_x` be defined as
    
    
    .. math:: 
    
        \dots, f^{-1} (g^{-1}(x)), g^{-1}(x), x , f(x), g(f(x)), f(g(f(x))), \dots.
    
    Note that the elements in the sequence alternate between :math:`X` and :math:`Y`. On
    the left side, the sequence stops whenever :math:`f^{-1}(y)` or :math:`g^{-1}(x)` is not
    defined. On the right side the sequence goes on infinitely.
    
    We call the sequence as :math:`X` stopper if it stops at an element of :math:`X` or
    as :math:`Y` stopper if it stops at an element of :math:`Y`. If any element in the left
    side repeats, then the sequence on the left will keep on repeating. We call
    the sequence doubly infinite if all the elements (on the left) are distinct, or cyclic
    if the elements repeat. Define :math:`Z = X \cup Y` If an element :math:`z \in Z` occurs
    in two sequences, then the two sequences must be identical by definition.
    Otherwise, the two sequences must be disjoint.  Thus the sequences
    form a partition on :math:`Z`. All elements within one equivalence class of :math:`Z` 
    are reachable from each other through one such sequence. The elements
    from different sequences are not reachable from each other at all. Thus,
    we need to define bijections between elements of :math:`X` and :math:`Y` which belong
    to same sequence separately.
    
    For an :math:`X`-stopper sequence :math:`C`, every element :math:`y \in C \cap Y` is reachable from
    :math:`f`. Hence :math:`f` serves as the bijection between elements of :math:`X` and :math:`Y`.
    For an :math:`Y`-stopper sequence :math:`C`, every element :math:`x \in C \cap X` is reachable from
    :math:`g`. Hence :math:`g` serves as the bijection between elements of :math:`X` and :math:`Y`.
    For a cyclic or doubly infinite sequence :math:`C`, 
    every element :math:`y \in C \cap Y` is reachable from :math:`f` 
    and every element :math:`x \in C \cap X` is reachable from :math:`g`. Thus either of :math:`f`
    and :math:`g` can serve as a bijection.
    
    




 
Sequence
----------------------------------------------------


.. index:: Sequence

.. _def:set:sequence:

.. definition:: 


    Any function :math:`x : \Nat \to X`, where :math:`\Nat = \{1,2,3,\dots\}` is the set of natural numbers,
    is called a **sequence** of :math:`X`.
    
    We say that :math:`x(n)` denoted by :math:`x_n` is the :math:`n^{\text{th}}` **term in the sequence**.
    
    We denote the sequence by :math:`\{ x_n \}`.


Note that sequence may have repeated elements and the order of elements in a sequence is important.


.. index:: Subsequence

.. _def:set:sub_sequence:

.. definition:: 


    A **subsequence** of a sequence :math:`\{ x_n \}` is a sequence 
    :math:`\{ y_n \}` for which there exists a strictly increasing sequence 
    :math:`\{ k_n \}` of natural numbers (i.e. :math:`1 \leq k_1 < k_2  < k_3 < \ldots)` 
    such that :math:`y_n = x_{k_n}` holds for each :math:`n`.

 
Cartesian product
===================================================



.. index:: Cartesian product
.. index:: Choice function
.. index:: Ordered pair

.. definition:: 

    Let :math:`\{ A_i \}_{i \in I}` be a family of sets. Then the
    **Cartesian product** :math:`\prod_{i \in I} A_i` or :math:`\prod A_i` 
    is defined to be the set consisting of all functions 
    :math:`f : I \to \cup_{i \in I}A_i` such that :math:`x_i = f(i) \in A_i`
    for each :math:`i \in I`.
    
    Such a function is called a **choice function** and
    often denoted by :math:`(x_i)_{i \in I}` or simply by :math:`(x_i)`.
    
    If a family consists of two sets, say :math:`A` and :math:`B`, then 
    the Cartesian product of the sets :math:`A` and :math:`B` is designated
    by :math:`A \times B`.  The members of :math:`A \times B` are denoted
    as **ordered pairs**.
    
    
    .. math::
        A \times B  = \{ (a, b) : a \in A \text{  and  } b \in B \}.
    
    
    Similarly the Cartesian product of a finite family of 
    sets :math:`\{ A_1, \dots, A_n\}` is written as 
    :math:`A_1 \times \dots \times A_n` and its members are
    denoted as :math:`n`-tuples, i.e.:
    
    
    .. math::
        A_1 \times \dots \times  A_n = \{(a_1, \dots, a_n) : a_i \in A_i \forall
        i = 1,\dots,n\}.
    
    
    Note that :math:`(a_1,\dots, a_n) = (b_1,\dots,b_n)` if and only if
    :math:`a_i = b_i \forall i = 1,\dots,n`.
    
    If :math:`A_1 = A_2 = \dots = A_n = A`, then it is standard to write
    :math:`A_1 \times \dots \times A_n` as :math:`A^n`.




.. example:: :math:`A^n`

    
    Let :math:`A = \{ 0, +1, -1\}`.
    
    Then :math:`A^2`  is
    
    
    .. math:: 
    
        \{\\
        &(0,0), (0,+1), (0,-1),\\
        &(+1,0), (+1,+1), (+1,-1),\\
        &(-1,0), (-1,+1), (-1,-1)\\
        \}.
    
    
    
    And :math:`A^3` is given by
    
    
    .. math:: 
    
         \{\\
        &(0,0,0), (0,0,+1), (0,0,-1),\\
        &(0,+1,0), (0,+1,+1), (0,+1,-1),\\
        &(0,-1,0), (0,-1,+1), (0,-1,-1),\\
        &(+1,0,0), (+1,0,+1), (+1,0,-1),\\
        &(+1,+1,0), (+1,+1,+1), (+1,+1,-1),\\
        &(+1,-1,0), (+1,-1,+1), (+1,-1,-1),\\
        &(-1,0,0), (-1,0,+1), (-1,0,-1),\\
        &(-1,+1,0), (-1,+1,+1), (-1,+1,-1),\\
        &(-1,-1,0), (-1,-1,+1), (-1,-1,-1)\\
        &\}.  
    
    


If the family of sets :math:`\{A_i\}_{i \in I}` satisfies :math:`A_i = A \forall i \in I`,
then :math:`\prod_{i \in I} A_i` is written as :math:`A^I`.


.. math::
    A^I = \{ f | f : I \to A\}.

i.e. :math:`A^I` is the set of all functions from :math:`I` to :math:`A`.



.. example:: 
    
    *  Let :math:`A = \{0, 1\}`. :math:`A^{\RR}` is a set of all functions 
       on :math:`\RR` which can take only one of the two values 
       :math:`0` or :math:`1`.    
       :math:`A^{\Nat}` is a set of all sequences of zeros and ones.
    *  :math:`\RR^\RR` is a set of all functions from :math:`\RR` to :math:`\RR`.    


 
Axiom of choice
----------------------------------------------------


If a Cartesian product is non-empty, then each :math:`A_i` must be non-empty. 

We can therefore ask: *If each :math:`A_i` is non-empty, is then the 
Cartesian product :math:`\prod A_i` nonempty?*

An affirmative answer cannot be proven within the usual axioms of set
theory.

This requires us to introduce the *axiom of choice*.

 .. index:: Axiom of choice

.. axiom::

    **Axiom of choice**. If :math:`\{A_i\}_{i \in I}` is a 
    nonempty family of sets such that :math:`A_i` is nonempty for each :math:`i \in I`,
    then :math:`\prod A_i` is nonempty.



Another way to state the axiom of choice is:

 .. index:: Axiom of choice

.. axiom::

    If :math:`\{A_i\}_{i \in I}` is a 
    nonempty family of pairwise disjoint sets such that 
    :math:`A_i \neq \EmptySet` for each :math:`i \in I`, then 
    there exists a set :math:`E \subseteq \cup_{i \in I} A_i` such that
    :math:`E \cap A_i` consists of precisely one element for each
    :math:`i \in I`.







