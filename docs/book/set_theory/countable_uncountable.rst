
 
Countable and uncountable sets
===================================================


In this section, we deal with questions concerning the *size* of a set.

When do we say that two sets have same number of elements?

If we can find a one-to-one correspondence between two sets :math:`A` and :math:`B` then
we can say that the two sets :math:`A` and :math:`B` have same number of elements.

In other words, if there exists a function :math:`f : A \to B` that is one-to-one
and onto (hence invertible), we say that :math:`A` and :math:`B` have same number of
elements.


.. index:: Equivalent sets
.. index:: Same cardinality

.. _def:set:cardinality_equivalence:

.. definition:: 


    Two sets :math:`A` and :math:`B` are said to be **equivalent** (denoted as :math:`A \sim B`)
    if there exists a function :math:`f : A \to B` that is one-to-one and on to.
    When two sets are equivalent, we say that they have **same cardinality**.


Note that two sets may be equivalent yet not equal to each other. 



.. example:: Equivalent sets

    *  The set of natural numbers :math:`\Nat` is equivalent to the 
       set of integers :math:`\ZZ`.
       Consider the function :math:`f : \Nat \to \ZZ` given by
    
    
       .. math:: 
    
            f (n) = 
             \left\{
                    \begin{array}{ll}
                        (n - 1) / 2 & \mbox{if $n$ is odd};\\
                        -n / 2 & \mbox{if $n$ is even}.
                    \end{array}
                  \right.
    
       It is easy to show that this function is one-one and on-to.
    *  :math:`\Nat` is equivalent to the set of even natural numbers
       :math:`E`.
       Consider the function :math:`f  : \Nat \to E` given by 
       :math:`f(n) = 2n`. This is one-one and onto. 
    *  :math:`\Nat` is equivalent to the set of rational numbers :math:`\QQ`.
    *  The sets :math:`\{a, b, c\}` and :math:`\{1,4, 9\}` are equivalent 
       but not equal.

.. _res:set:equivalence_is_equivalence_relation:

.. theorem:: 


    Let :math:`A, B, C` be sets. Then: 

    #.  :math:`A \sim A`.
    #.  If :math:`A \sim B`, then :math:`B \sim A`.
    #.  If :math:`A \sim B`, and :math:`B \sim C`, then :math:`A \sim C`. 
    
    Thus it is an equivalence relation.



.. proof:: 

    (i). Construct a function :math:`f : A \to A` given by :math:`f (a) = a \Forall a \in A`. This is
    a one-one and onto function. Hence :math:`A \sim A`.
    
    (ii). It is given that :math:`A \sim B`. Thus, there exists a function :math:`f : A \to B` which is
    one-one and onto. Thus, there exists an 
    :ref:`inverse function <def:set:inverse_function>` :math:`g : B \to A` which is one-one 
    and onto. Thus, :math:`B \sim A`.
    
    (iii). It is given that :math:`A \sim B` and :math:`B \sim C`. Thus there exist two one-one and onto
    functions :math:`f : A \to B` and :math:`g : B \to C`. Define a function :math:`h : A \to C` given by
    :math:`h = g \circ f`. Since 
    :ref:`composition of bijective functions is bijective <res:composition_of_one_one_onto_functions>`
    , :math:`h` is one-one and onto. Thus, :math:`A \sim C`.

We now look closely at the set of natural numbers :math:`\Nat = \{1,2,3,\dots\}`.



.. index:: Natural numbers!Segment

.. definition:: 

    Any subset of :math:`\Nat` of the form :math:`\{1,\dots, n\}` is called a
    **segment** of :math:`\Nat`.
    :math:`n` is called the number of elements of the segment.


Clearly, two segments :math:`\{1,\dots,m\}` and :math:`\{1,\dots,n\}` are equivalent
only if :math:`m= n`.

Thus a proper subset of a segment cannot be equivalent to the segment.


.. index:: Finite set

.. definition:: 

    A set that is equivalent to a segment is called a **finite set**.


The number of elements of a set which is equivalent to a segment is
equal to the number of elements in the segment.

The empty set is also considered to be finite with zero elements.


.. index:: Infinite set

.. definition:: 

    A set that is not finite is called an **infinite set**.


It should be noted that so far we have defined number of elements only
for sets which are equivalent to a segment.


.. index:: Countable

.. definition:: 

    A set :math:`A` is called **countable** if it is equivalent to :math:`\Nat`,
    i.e., if there exists a one-to-one correspondence of :math:`\Nat` with the
    elements of :math:`A`.


A countable set :math:`A` is usually written as :math:`A = \{a_1, a_2, \dots\}`
which indicates the one-to-one correspondence of :math:`A` with the set of 
natural numbers :math:`\Nat`.

This notation is also known as the **enumeration** of :math:`A`.


.. index:: Uncountable set

.. definition:: 

    An infinite set which is not countable is called an **uncountable set**.


With the definitions in place, we are now ready to study the connections
between countable, uncountable and finite sets.



.. theorem:: 

    Every infinite set contains a countable subset.




.. proof:: 

    
    Let :math:`A` be an infinite set. Clearly :math:`A \neq \EmptySet`. Pick an element :math:`a_1 \in A`.
    Consider :math:`A_1 = A \setminus \{a_1 \}`. Since :math:`A` is infinite, hence :math:`A_1` is nonempty.
    Pick an element :math:`a_2 \in A_1`. Clearly, :math:`a_2 \neq a_1`. 
    Consider the set :math:`A_2 = A \setminus \{a_1, a_2 \}`. Again, by the same argument, since
    :math:`A` is infinite, :math:`A_2` is non-empty. We can pick :math:`a_3 \in A_2`. Proceeding in the
    same way we construct a set :math:`B = \{a_1, a_2, a_3, \dots \}`. The set is countable and
    by construction it is a subset of :math:`A`.




.. _res:set:well_ordering_principle:

.. theorem:: 


    Every subset of :math:`\Nat` has a least element.



.. _res:set:principle_mathematical_induction:

.. theorem:: 


    If a subset :math:`S` of :math:`\Nat` satisfies the following properties:

    #.  :math:`1 \in S` and
    #.  :math:`n \in S \implies n + 1 \in S`,
    
    then :math:`S = \Nat`.

The principle of mathematical induction is applied as follows.
We consider a set :math:`S = \{ n \in \Nat : n \mbox{ satisfies } P \}` where
:math:`P` is some property that the members of this set satisfy. 
We that show that :math:`1` satisfies the property :math:`P`. Further, we
show that if :math:`n` satisfies property :math:`P`, then :math:`n + 1` also 
has to satisfy :math:`P`. Then applying the principle of mathematical
induction, we claim that :math:`S = \Nat` i.e. every number :math:`n \in \Nat`
satisfies the property :math:`P`.


.. _res:set:subset_of_countable_set:

.. theorem:: 


    Every subset of a countable set is either finite or countable. i.e. if :math:`A` is
    countable and :math:`B \subseteq A`, then either :math:`B` is finite or :math:`B \sim A`.



.. proof:: 

    Let :math:`A` be a countable set and :math:`B \subseteq A`. If :math:`B` is finite, then there is
    nothing to prove. So we consider :math:`B` as infinite and show that it is countable.
    Since :math:`A` is countable, hence :math:`A \sim \Nat`. Thus, :math:`B` is equivalent to a subset
    of :math:`\Nat`. Without loss of generality, let us assume that :math:`B` is a subset of :math:`\Nat`.
    We now construct a mapping :math:`f : \Nat \to B` as follows. Let :math:`b_1` be the
    least element of :math:`B` (which exists due to :ref:`well ordering principle <res:set:well_ordering_principle>`).
    We assign :math:`f(1) = b_1`. Now, let :math:`b_2` be the least element of :math:`B \setminus \{ b_1\}`. We
    assign :math:`f(2) = b_2`. Similarly, assuming that :math:`f(1) = b_1, f(2) = b_2, \dots , f(n) = b_n` has
    been assigned, we assign :math:`f(n+1) =` the least element of :math:`B \setminus \{b_1, \dots, b_n\}`. This
    least element again exists due to :ref:`well ordering principle <res:set:well_ordering_principle>`.
    This completes the definition of :math:`f` using the :ref:`principle of mathematical induction <res:set:principle_mathematical_induction>`. It is easy to show that the function is one-one and onto.  This proves
    that :math:`B \sim \Nat`.


We present different characterizations of a countable set.

.. _res:set:countable_set_characterization:

.. theorem:: 


    Let :math:`A` be an infinite set. The following are equivalent:


    #.  A is countable
    #.  There exists a subset :math:`B` of :math:`\Nat` and a function :math:`f: B \to A` that is on-to.
    #.  There exists a function :math:`g : A \to \Nat` that is one-one.
    



.. proof:: 

    (i):math:`\implies` (ii). Since :math:`A` is countable, there exists a function :math:`f : \Nat \to A` which
    is one-one and on to. Choosing :math:`B = \Nat`, we get the result.
    
    (ii):math:`\implies` (iii). 
    We are given that there exists a subset :math:`B` of :math:`\Nat` and a function :math:`f: B \to A` that is on-to.
    For some :math:`a \in A`, consider :math:`f^{-1}{a} = \{ b \in B : f(b) = a \}`.
    Since :math:`f` is on-to, hence :math:`f^{-1}(a)` is non-empty. Since :math:`f^{-1}(a)` is a set of natural 
    numbers, it has a least element due to :ref:`well ordering principle <res:set:well_ordering_principle>`. 
    Further if :math:`a_1, a_2 \in A` are distinct, then :math:`f^{-1}(a_1)` 
    and :math:`f^{-1}(a_2)` are disjoint and the corresponding least elements are distinct.
    Assign :math:`g(a) = \text{ least element of } f^{-1}(a) \Forall a \in A`. Such a 
    function is well defined by construction. Clearly, the function is one-one.
    
    (iii):math:`\implies` (i). 
    We are given that there exists a function :math:`g : A \to \Nat` that is one-one. 
    Clearly, :math:`A \sim g(A)` where :math:`g(A) \subseteq \Nat`. Since :math:`A` is infinite,
    hence :math:`g(A)` is also infinite. Due to :ref:`here <res:set:subset_of_countable_set>`, 
    :math:`g(A)` is countable implying :math:`g(A) \sim \Nat`. Thus, :math:`A \sim g(A) \sim \Nat` and :math:`A` is countable.



.. _res:set:countable_union_countable_sets:

.. theorem:: 


    Let :math:`\{A_1, A_2, \dots \}` be a countable family of sets where each :math:`A_i` is a countable set. Then
    
    
    .. math:: 
    
        A = \bigcup_{i=1}^{\infty} A_i
    
    is countable.



.. proof:: 

    Let :math:`A_n = \{a_1^n, a_2^n, \dots\} \Forall n \in \Nat`. Further, let 
    :math:`B = \{2^k 3^n : k, n \in \Nat \}`. Note that every element of :math:`B` is a natural number,
    hence :math:`B \subseteq \Nat`. Since :math:`B` is infinite, hence by   :ref:`here <res:set:subset_of_countable_set>`
    :math:`B` is countable, i.e. :math:`B \sim \Nat`. We note that if :math:`b_1 = 2^{k_1} 3^{n_1}` and :math:`b_2 = 2^{k_2} 3^{n_2}`,
    then :math:`b_1 = b_2` if and only if :math:`k_1 = k_2` and :math:`n_1 = n_2`. Now define a mapping :math:`f : B \to A` given by
    :math:`f (2^k 3^n) = a^n_k` (picking :math:`k`-th element from :math:`n`-th set). Clearly, :math:`f` is well defined and on-to.
    Thus, using :ref:`here <res:set:countable_set_characterization>`, :math:`A` is countable.



.. _res:set:finite_cartesian_product_of_countable_sets:

.. theorem:: 


    Let :math:`\{A_1, A_2, \dots, A_n \}` be a finite collection of sets such that each :math:`A_i` is countable.
    Then their Cartesian product :math:`A = A_1 \times A_2 \times \dots \times A_n` is countable.



.. proof:: 

    Let :math:`A_i = \{a_1^i, a_2^i, \dots\} \Forall 1 \leq i \leq n`. Choose :math:`n` distinct prime
    numbers :math:`p_1, p_2, \dots, p_n`. Consider the set 
    :math:`B  = \{p_1^{k_1}p_2^{k_2} \dots p_n^{k_n} : k_1, k_2, \dots, k_n \in \Nat \}`. 
    Clearly, :math:`B \subset \Nat`.
    Define a function :math:`f : A \to \Nat` as 
    
    
    .. math:: 
    
        f (a^1_{k_1}, a^2_{k_2}, \dots, a^n_{k_n}) = p_1^{k_1}p_2^{k_2} \dots p_n^{k_n}.
    
    By fundamental theorem of arithmetic, every natural number has a unique prime factorization. Thus,
    :math:`f` is one-one. Invoking :ref:`here <res:set:countable_set_characterization>`, :math:`A` is countable.



.. _res:set:rationals_countable:

.. theorem:: 


    The set of rational numbers :math:`\QQ` is countable. 



.. proof:: 

    Let :math:`\frac{p}{q}` be a positive rational number with :math:`p > 0` and :math:`q > 0` having no common factor.
    Consider a mapping :math:`f(\frac{p}{q})  = 2^p 3^q`. This is a one-one mapping into natural numbers.
    Hence invoking :ref:`here <res:set:countable_set_characterization>`, the set of positive rational
    numbers is countable. Similarly, the set of negative rational numbers is countable. 
    Invoking :ref:`here <res:set:countable_union_countable_sets>`, :math:`\QQ` is countable.



.. _res:set:finite_subsets_countable:

.. theorem:: 

    The set of all finite subsets of :math:`\Nat` is countable.




.. proof:: 

    Let :math:`F` denote the set of finite subsets of :math:`\Nat`. Let :math:`f \in F`. Then
    we can write :math:`f = \{n_1, \dots, n_k\}` where :math:`k` is the number of elements
    in :math:`f`. Consider the sequence of prime numbers :math:`\{p_n\}` where :math:`p_n` denotes
    :math:`n`-th prime number. Now, define a mapping :math:`g : F \to \Nat` as
    
    
    .. math:: 
    
        g (f ) = \prod_{i=1}^k p_{n_i}.
    
    The mapping :math:`g` is one-one, since the prime decomposition of a natural number
    is unique. Hence invoking :ref:`here <res:set:countable_set_characterization>`, :math:`F` is countable. 



.. _res:set:finite_subsets_of_countable_set_is_countable:

.. corollary:: 


    The set of all finite subsets of a countable set is countable.




.. definition:: 

    We say that :math:`A \preceq B` whenever there exists a one-one function :math:`f : A \to B`.
    In other words, :math:`A` is equivalent to a subset of :math:`B`. 

In this sense, :math:`B` has at least as many elements as :math:`A`.


.. theorem:: 

    The relation :math:`\preceq` satisfies following properties

    #.  :math:`A \preceq A` for all sets :math:`A`.
    #.  If :math:`A \preceq B` and :math:`b \preceq C`, then :math:`A \preceq C`.
    #.  If :math:`A \preceq B` and :math:`B \preceq A`, then :math:`A \sim B`.
    



.. proof:: 

    (i). We can use the identity function :math:`f (a ) = a \Forall a \in A`.
    
    (ii). Straightforward application of the result that
    :ref:`composition of injective functions is injective <res:composition_of_one_one_functions>`.
    
    (iii). Straightforward application of 
    :ref:`Schröder-Bernstein theorem <res:function:schroder_bernstein_theorem>`.



.. _res:set:set_power_set_cardinality:

.. theorem:: 


    If :math:`A` is a set, then :math:`A \preceq \Power (A)` and :math:`A \nsim \Power (A)`.



.. proof:: 

    If :math:`A = \EmptySet`, then :math:`\Power(A) = \{ \EmptySet\}` and the result is trivial.
    So, lets consider non-empty :math:`A`.
    We can choose :math:`f : A \to \Power(A)` given by :math:`f (x) = \{ x\} \Forall x \in A`. This
    is clearly a one-one function leading to :math:`A \preceq \Power (A)`.
    
    Now for the sake of contradiction, lets us assume that :math:`A \sim \Power (A)`. Then,
    there exists a bijective function :math:`g : A \to \Power(A)`. 
    Consider the set :math:`B = \{ a \in A : a \notin g(a) \}`.
    Since :math:`B \subseteq A`, and :math:`g` is bijective, there exists
    :math:`a \in A` such that :math:`g (a) = B`.
    
    Now if :math:`a \in B` then :math:`a \notin g(a) = B`.
    And if :math:`a \notin B`, then :math:`a \in g(a) = B`.
    This is impossible, hence :math:`A \nsim \Power(A)`.



.. index:: Cardinal number
.. index:: Cardinality

.. _def:set:cardinality:

.. definition:: 

    For every set :math:`A` a symbol (playing the role of a number) can be assigned that 
    designates the number of elements in the set. This number is known as **cardinal number**
    of the set and is denoted by \Card{A} or :math:`| A |`. It is also known as **cardinality**.

Note that the cardinal numbers are different from natural numbers, real numbers etc.
If :math:`A` is finite, with :math:`A = \{a_1, a_2, \dots, a_n \}`, then :math:`\Card{A} = n`.
We use the symbol :math:`\aleph_0` to denote the cardinality of :math:`\Nat`. By saying
:math:`A` has the cardinality of :math:`\aleph_0`, we simply mean that :math:`A \sim \Nat`.

If :math:`a` and :math:`b` are two cardinal numbers, then by :math:`a \leq b`, we mean that
there exist two sets :math:`A` and :math:`B` such that :math:`\Card{A} = a`, :math:`\Card{B} = b` and
:math:`A \preceq B`. By :math:`a < b`, we mean that :math:`A \preceq B` 
and :math:`A \nsim B`. :math:`a \leq b` and :math:`b \leq a` guarantees that :math:`a = b`.

It can be shown that :math:`\Power(\Nat) \sim \RR`. The cardinality of :math:`\RR` is denoted by
:math:`\mathfrak{c}`.


.. index:: Infinite cardinal number

.. _def:set:infinite_cardinal_number:

.. definition:: 


    A cardinal number :math:`a` satisfying :math:`\aleph_0 \leq a` is known as **infinite cardinal number**.


.. index:: Cardinality of the continuum

.. _def:set:cardinality_continuum:

.. definition:: 


    The cardinality of :math:`\RR` denoted by :math:`\mathfrak{c}` is known as the **cardinality of the continuum**.




.. theorem:: 

    Let :math:`2 = \{ 0, 1 \}`. Then :math:`2^X \sim \Power (X)` for every set :math:`X`.



.. proof:: 

    :math:`2^X` is the set of all functions :math:`f : X \to 2`. i.e. a function from :math:`X` to :math:`\{ 0, 1 \}` which can
    take only one the two values :math:`0` and :math:`1`.
    
    Define a function :math:`g : \Power (X) \to 2^X` as follows. Let :math:`y \in \Power(X)`. 
    Then :math:`g(y)` is a function :math:`f : X \to \{ 0, 1 \}` given by
    
    
    .. math:: 
    
        f(x) = 
         \left\{
                \begin{array}{ll}
                    1 & \mbox{if $x \in y$};\\
                    0 & \mbox{if $x \notin y$}.
                \end{array}
              \right.
    
    The function :math:`g` is one-one and on-to. Thus :math:`2^X \sim \Power(X)`.


We denote the cardinal number of :math:`\Power(X)` by :math:`2^{\Card{X}}`. Thus, :math:`\mathfrak{c} = 2^{\aleph_0}`.

The following inequalities of cardinal numbers hold:


.. math:: 

    0 < 1 < 2 < \dots < n \dots < \aleph_0 < 2^{\aleph_0} = \mathfrak{c} < 2^ \mathfrak{c} < 2^{2^{ \mathfrak{c}}} \dots.


