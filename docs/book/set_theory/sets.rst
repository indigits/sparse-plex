
Sets
===================================================


In this section we will review basic concepts of set theory. 



.. index:: Set

.. definition:: 

    A **set** is a collection of objects viewed as a single entity.


Actually, it's not a formal definition.  It is just a working definition
which we will use going forward.



*  Sets are denoted by capital letters. 
*  Objects in a set are called **members**, **elements** or **points**. 
*  :math:`x \in A` means that element :math:`x` belongs to set :math:`A`.
*  :math:`x \notin A` means that :math:`x` doesn't belong to set :math:`A`.
*  :math:`\{ a,b,c\}` denotes a set with elements :math:`a`, :math:`b`, 
   and :math:`c`. Their order is not relevant.



.. index:: Singleton

.. definition:: 

    A set with only one element is known as a **singleton** set.

.. definition:: 

    Two sets :math:`A` and :math:`B` are said to be equal (:math:`A=B`) if they have precisely the same elements. i.e.
    if :math:`x \in A` then :math:`x \in B` and vice versa. Otherwise they are not equal (:math:`A \neq B`).



.. index:: Subset

.. definition:: 

    A set :math:`A` is called a **subset** of another set 
    :math:`B` if every element of :math:`A` belongs to :math:`B`.
    This is denoted as :math:`A \subseteq B`. 
    Formally :math:`A \subseteq B \iff (x \in A \implies x \in B)`.


Clearly, :math:`A = B \iff (A \subseteq B \text{ and } B \subseteq A)`.


.. index:: Proper subset

.. definition:: 

    If :math:`A \subseteq B` and :math:`A \neq B` then :math:`A` is called a **proper subset** of :math:`B` denoted by :math:`A \subset B`. 


.. index:: Empty set

.. definition:: 

    A set without any elements is called the **empty** or **void** set. It is denoted by :math:`\EmptySet`.


.. index:: Union

.. index:: Intersection

.. index:: Difference

.. definition:: 

    We define fundamental set operations below
    
    
    *  The **union** :math:`A \cup B` of :math:`A` and :math:`B` is defined as
        
    
    .. math::
                A \cup B  = \{ x : x \in A \text{ or } x \in B\}.
    
    *  The **intersection** :math:`A \cap B` of :math:`A` and :math:`B` is defined as
        
    
    .. math::
                A \cap B  = \{ x : x \in A \text{ and } x \in B\}.
    
    *  The **difference** :math:`A \setminus B` of :math:`A` and :math:`B` is defined as
        
    
    .. math::
                A \setminus B  = \{ x : x \in A \text{ and } x \notin B\}.
    
        
.. index:: Disjoint sets

.. definition:: 

    :math:`A` and :math:`B` are called **disjoint** if :math:`A \cap B = \EmptySet`.



Some useful identities


*  :math:`(A \cup B) \cap C = (A \cup C) \cap (B \cup C)`.
*  :math:`(A \cap B) \cup C = (A \cap C) \cup (B \cap C)`.
*  :math:`(A \cup B) \setminus C = (A \setminus C) \cap (B \setminus C)`.
*  :math:`(A \cap B) \setminus C = (A \setminus C) \cap (B \setminus C)`.



.. index:: Symmetric difference

.. definition:: 

    Symmetric difference between :math:`A` and :math:`B` is defined as
    
    
    .. math::
            A \Delta B = ( A \setminus B) \cup (B \setminus A)
    
    i.e. the elements which are in :math:`A` but not in :math:`B` and the elements which are in :math:`B` but not in :math:`A`.


 
Family of sets
----------------------------------------------------


.. index:: Family of sets
.. index:: Index set

.. definition:: 

    A **Family of sets** is a nonempty set :math:`\mathcal{F}` whose members are sets by themselves.
    If for each element :math:`i` of a non-empty set :math:`I`, a subset :math:`A_i` of a fixed set :math:`X` is assigned,
    then :math:`\{ A_i\}_{i \in I}` ( or :math:`\{ A_i : i \in I\}` or simply :math:`\{A_i\}`) denotes the family whose members are the sets
    :math:`A_i`. The set :math:`I` is called the **index set** of the family and its members are known
    as indices. 




.. example:: Index sets

    Following are some examples of index sets
    
    *  :math:`\{1,2,3,4\}`: the family consists of only 4 sets.
    *  :math:`\{0,1,2,3\}`: the family consists again of only 4 sets 
       but indices are different.
    *  :math:`\Nat`: The sets in family are indexed by natural numbers. 
       They are countably infinite.
    *  :math:`\ZZ`: The sets in family are indexed by integers. 
       They are countably infinite.
    *  :math:`\QQ`: The sets in family are indexed by rational numbers. 
       They are countably infinite.
    *  :math:`\RR`: There are uncountably infinite sets in the family.
    

If :math:`\mathcal{F}` is a family of sets, then by letting :math:`I=\mathcal{F}` and :math:`A_i = i \quad \forall i \in I`,
we can express :math:`\mathcal{F}` in the form of :math:`\{ A_i\}_{i \in I}`. 



.. definition:: 

    Let :math:`\{ A_i\}_{i \in I}` be a family of sets. 
    
    *  The **union** of the family is defined to be
        
    
       .. math::
                \bigcup_{i\in I} A_i = \{ x : \exists i \in I \text{ such that } x \in A_i\}.
    
    *  The **intersection** of the family is defined to be
        
    
       .. math::
                \bigcap_{i \in I} A_i  = \{ x : x \in A_i \quad \forall i \in I\}.
    
    


We will also use simpler notation :math:`\bigcup A_i`, :math:`\bigcap A_i` for denoting the union and inersection of family.

If :math:`I =\Nat = \{1,2,3,\dots\}` (the set of natural numbers), then we will denote
union and intersection by :math:`\bigcup_{i=1}^{\infty}A_i` and :math:`\bigcap_{i=1}^{\infty}A_i`.


.. index:: Distributive law

We now have the generalized **distributive law**:


.. math::
        &\left ( \bigcup_{i\in I} A_i \right ) \cap B = \bigcup_{i\in I}  \left ( A_i \cap B \right )\\
        &\left ( \bigcap_{i\in I} A_i \right ) \cup B = \bigcap_{i\in I}  \left ( A_i \cup B \right )


.. index:: Pairwise disjoint

.. definition:: 

    A family of sets :math:`\{ A_i\}_{i \in I}` is called **pairwise disjoint** if for each pair :math:`i, j \in I`
    the sets :math:`A_i` and :math:`A_j`  are disjoint i.e. :math:`A_i \cap A_j = \EmptySet`. 


.. index:: Power set


.. definition:: 

    The set of all subsets of a set :math:`A` is called its **power set** and is denoted by
    :math:`\Power (A)`.

In the following :math:`X` is a big fixed set (sort of a frame of reference) and 
we will be considering different subsets of it.

Let :math:`X` be a fixed set. If :math:`P(x)` is a property well defined for all :math:`x \in X`, then
the set of all :math:`x` for which :math:`P(x)` is true is denoted by :math:`\{x \in X : P(x)\}`.


.. index:: Complement of a set

.. definition:: 

    Let :math:`A` be a set. Its **complement** w.r.t. a fixed set :math:`X` is the set  :math:`A^c = X \setminus A`.


We have

*  :math:`(A^c)^c = A`.
*  :math:`A \cap A^c = \EmptySet`.
*  :math:`A \cup A^c = X`.
*  :math:`A\setminus B = A \cap B^c`.
*  :math:`A \subseteq B \iff B^c \subseteq A^c`.
*  :math:`(A \cup B)^c = A^c \cap B^c`.
*  :math:`(A \cap B)^c = A^c \cup B^c`.


