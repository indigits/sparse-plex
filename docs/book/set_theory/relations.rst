
 
Relations
===================================================



.. index:: Relation


.. definition:: 

    A **binary relation** on a set :math:`X` is defined as a subset :math:`\mathcal{R}` of
    :math:`X \times X`.
    
    If :math:`(x,y) \in \mathcal{R}` then :math:`x` is said to be in relation :math:`\mathcal{R}`
    with :math:`y`. This is denoted by :math:`x \mathcal{R} y`.


The most interesting relations are equivalence relations.


.. index:: Equivalence relation

.. definition:: 

    A relation :math:`\mathcal{R}` on a set :math:`X` is said to be an 
    **equivalence relation** if it satisfies the following properties:
    
    
    *  :math:`x \mathcal{R} x` for each :math:`x \in X` (**reflexivity**).
    *  If :math:`x \mathcal{R} y` then :math:`y \mathcal{R} x` (**symmetry**).
    *  If :math:`x \mathcal{R} y` and :math:`y \mathcal{R} z` then :math:`x \mathcal{R} z` (**transitivity**).
    


We can now introduce equivalence classes on a set.


.. index:: Equivalence class

.. definition:: 

    Let :math:`\mathcal{R}` be an equivalence relation on a set :math:`X`. Then the
    **equivalence class** determined by the element :math:`x \in X` is
    denoted by :math:`[x]` and is defined as 
    
    
    .. math::
        [x]  = \{ y \in X : x \mathcal{R} y\}
    
    i.e. all elements in :math:`X` which are related to :math:`x`.


We can now look at some properties of equivalence classes and relations.



.. lemma:: 

    Any two equivalence classes are either disjoint or else they coincide.




.. example:: Equivalent classes

    Let :math:`X` bet the set of integers :math:`\ZZ`. Let :math:`\mathcal{R}` be defined as
    
    
    .. math:: 
    
        x \mathcal{R} y \iff 2 \mid (x-y)
    
    i.e. :math:`x` and :math:`y` are related if the difference of :math:`x` and :math:`y` given by
    :math:`x-y` is divisible by :math:`2`.
    
    Clearly the set of odd integers and the set of even integers forms two
    disjoint equivalent classes.






.. lemma:: 

    Let :math:`\mathcal{R}` be an equivalence relation on a set :math:`X`.
    Since :math:`x \in [x]` for each :math:`x \in X`, there exists a family
    :math:`\{A_i\}_{i \in I}` of pairwise disjoint sets (a family of 
    equivalence classes) such that :math:`X = \cup_{i \in I} A_i`.



.. index:: Partition

.. definition:: 

    If a set :math:`X` can be represented as a union of a family :math:`\{A_i\}_{i \in I}` of 
    pairwise disjoint sets i.e.
    
    
    .. math:: 
    
        X  = \cup_{i \in I} A_i
    
    then we say that :math:`\{A_i\}_{i \in I}` is a **partition** of 
    :math:`X`.


A partition over a set :math:`X` also defines an equivalence relation on it.





.. lemma:: 

    If there exists a family
    :math:`\{A_i\}_{i \in I}` of pairwise disjoint sets which partitions
    a set :math:`X`, (i.e. :math:`X = \cup_{i \in I} A_i`), then by letting
    
    
    .. math::
        \mathcal{R} = \{(x,y) \in X \times X : \exists i \in I \text{ such that } x, y \in A_i\}
    
    an equivalence relation is defined on :math:`X` whose equivalence classes
    are precisely the sets :math:`A_i`.


In words, the relation :math:`\mathcal{R}` includes only those tuples :math:`(x,y)`
from the Cartesian product :math:`X\times X` for which there exists one
set :math:`A_i` in the family of sets :math:`\{A_i\}_{i \in I}`
such that both :math:`x` and :math:`y` belong to :math:`A_i`.

 
Order
----------------------------------------------------


Another important type of relation is an order relation.


.. index:: Partial order

.. definition:: 

    A relation, denoted by :math:`\leq`, on a set :math:`X` is said to be a 
    **partial order** for :math:`X` (or that :math:`X` is partially ordered by :math:`\leq`)
    if it satisfies the following properties:
    
    *  :math:`x \leq x` holds for every :math:`x \in X` (reflexivity).
    *  If :math:`x \leq y` and :math:`y \leq x`, 
       then :math:`x = y` (antisymmetry).
    *  If :math:`x \leq y` and :math:`y \leq z`, 
       then :math:`x \leq z` (transitivity).
    


An alternative notation for :math:`x \leq y` is :math:`y \geq x`.


.. index:: Partially ordered set

.. definition:: 

    A set equipped with a partial order is known as a **partially ordered set**.




.. example:: Partially ordered set

    Consider a set :math:`A = \{1,2,3\}`.  Consider the power set of :math:`A` which is
    
    
    .. math:: 
    
        X = \{\EmptySet, \{1\}, \{2\}, \{3\}, \{1,2\} , \{2,3\} , \{1,3\}, \{1,2,3\} \}.
    
    
    
    Define a relation :math:`\mathcal{R}` on :math:`X` such that :math:`x \mathcal{R} y` if 
    :math:`x \subseteq y`.
    
    Clearly
    
    
    *  :math:`x \subseteq x \quad \forall x \in X`.
    *  If :math:`x \subseteq y` and :math:`y \subseteq x` then :math:`x =y`. 
    *  If :math:`x \subseteq y` and :math:`y \subseteq z` then :math:`x \subseteq y`.
    
    
    Thus the relation :math:`\mathcal{R}` defines a partial order on the power set :math:`X`.



We can look at how elements are ordered within a set a bit more closely.

.. index:: Chain
.. index:: Totally ordered set

.. _def:set:chain:

.. definition:: 


    A subset :math:`Y` of a partially ordered set :math:`X` 
    is called a **chain** if for every :math:`x, y \in Y`
    either :math:`x \leq y` or :math:`y \leq x` holds.
    
    A chain is also known as a **totally ordered set**.


*  In a partially ordered set :math:`X`, we don't require that
   for every :math:`x,y \in X`, either :math:`x \leq y` or 
   :math:`y \leq x` should hold. 
   Thus there could be elements which are not connected by 
   the order relation.
*  In a totally ordered set :math:`Y`, for every :math:`x,y \in Y` 
   we require that either :math:`x \leq y` or :math:`y \leq x`.
*  If a set is totally ordered, then it is partially ordered also.


.. example:: Chain

    Continuing from previous example consider a subset :math:`Y` of :math:`X` defined by
    
    
    .. math:: 
    
        Y = \{\EmptySet, \{1\}, \{1,2\}, \{1,2,3\} \}.
    
    
    Clearly for every :math:`x, y \in Y`, either :math:`x \subseteq y` or :math:`y \subseteq x` holds.
    
    Hence :math:`Y` is a chain or a totally ordered set within :math:`X`.





.. example:: More ordered sets

    *  The set of natural numbers :math:`\Nat` is totally ordered.
    *  The set of integers :math:`\ZZ` is totally ordered.
    *  The set of real numbers :math:`\RR` is totally ordered.
    *  Suppose we define an order relation in the set of complex numbers
       as follows. Let :math:`x+jy` and :math:`u+jv`  be two complex numbers.
       We say that
    
    
    .. math:: 
    
        x+jy \leq u+jv \iff  x \leq u  \text{ and } y \leq v. 
    
    With this definition, the set of complex numbers :math:`\CC` is partially ordered.

    *  :math:`\RR` is a totally ordered subset of :math:`\CC` since the
       imaginary component is 0 for all real numbers in the complex plane.
    *  In fact any line or a ray or a line segment 
       in the complex plane represents a totally ordered
       set in the complex plane.
    
We can now define the notion of upper bounds in a partially ordered set.


.. index:: Upper bound

.. definition:: 

    If :math:`Y` is a subset of a partially ordered set :math:`X` such that
    :math:`y \leq u` holds for all :math:`y \in Y` and for some :math:`u \in X`, then
    :math:`u` is called an **upper bound** of :math:`Y`.


Note that there can be more than one upper bounds of :math:`Y`. Upper bound
is not required to be unique.


.. index:: Maximal element

.. definition:: 

    An element :math:`m \in X` is called a **maximal element** whenever 
    the relation :math:`m \leq x` implies :math:`x = m`. 


This means that there is no other element in :math:`X` which is greater than
:math:`m`. 

A maximal element need not be unique. A partially ordered set may 
contain more than one maximal element.




.. example:: Maximal elements

    Consider the following set
    
    
    .. math:: 
    
        Z = \{\EmptySet, \{1\}, \{2\}, \{3\}, \{1,2\} , \{2,3\} , \{1,3\} \}.
    
    
    The set is partially ordered w.r.t. the relation :math:`\subseteq`.
    
    There are three maximal elements in this set namely :math:`\{1,2\} , \{2,3\} , \{1,3\}`.
    





.. example:: Ordered sets without a maximal element

    *  The set of natural numbers :math:`\Nat` has no maximal element. 
    
    



What are the conditions under which a maximal element is guaranteed
in a partially ordered set :math:`X`? 


Following statement known as 
Zorn's lemma guarantees the existence of maximal elements in
certain partially ordered sets.



.. index:: Zorn's lemma

.. lemma:: 

    If chain in a partially
    ordered set :math:`X` has an upper bound in :math:`X`, 
    then :math:`X` has a maximal element.


Following is corresponding notion of lower bounds.


.. index:: Lower bound

.. definition:: 

    If :math:`Y` is a subset of a partially ordered set :math:`X` such that
    :math:`u \leq y` holds for all :math:`y \in Y` and for some :math:`u \in X`, then
    :math:`u` is called an **lower bound** of :math:`Y`.




.. index:: Minimal element

.. definition:: 

    An element :math:`m \in X` is called a **minimal element** whenever 
    the relation :math:`x \leq m` implies :math:`x = m`. 


As before there can be more than one minimal elements in a set.

