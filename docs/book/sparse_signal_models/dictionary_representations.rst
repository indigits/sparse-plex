Dictionary based representations
========================================

.. highlight:: matlab

Dictionaries
-------------------------


.. index:: Dictionary

    
.. index:: Atom


..  _def:ssm:dictionary:

.. definition:: Dictionary

    
    A **dictionary** for  :math:`\CC^N` is a finite collection  :math:`\mathcal{D}` of unit-norm vectors
    which span the whole space.

    The elements of a dictionary are called **atoms** and they are denoted by  :math:`\phi_{\omega}`
    where  :math:`\omega` is drawn from an index set  :math:`\Omega`.

    The whole dictionary structure is written as 
    
    .. math::

        \mathcal{D} = \{\phi_{\omega} : \omega \in \Omega \}

    where 
    
    .. math::

        \| \phi_{\omega} \|_2 = 1 \Forall \omega \in \Omega

    and 
    
    .. math::

        x = \sum_{\omega \in \Omega} c_{\omega} \phi_{\omega}  \Forall x \in \CC^N.


    We use the letter  :math:`D` to denote the number of elements in the dictionary, i.e.
    
    .. math::

        D = | \Omega |.



This definition is adapted from :cite:`tropp2004greed`.

The indices may have an interpretation, such as the time-frequency or time-scale localization
of an atom, or they may simply be labels without any underlying meaning.


.. note::

    In most cases, the dictionary is a matrix of size :math:`N \times D` 
    where :math:`D` is the number of columns or atoms in the dictionary.
    The index set in this situation is :math:`[1:D]` which is the set
    of integers from 1 to :math:`D`.

.. example:: 

    Let's construct a simple Dirac-DCT dictionary of dimensions :math:`4 \times 8`.

    :: 

        >> A = spx.dict.simple.dirac_dct_mtx(4); A

        A =

            1.0000         0         0         0    0.5000    0.6533    0.5000    0.2706
                 0    1.0000         0         0    0.5000    0.2706   -0.5000   -0.6533
                 0         0    1.0000         0    0.5000   -0.2706   -0.5000    0.6533
                 0         0         0    1.0000    0.5000   -0.6533    0.5000   -0.2706

    This dictionary consists of two parts. The left part is a :math:`4 \times 4`
    identity matrix and the right part is a :math:`4 \times 4` DCT matrix.

    The rank of this dictionary is 4.
    Since the columns come from :math:`\RR^4`, any 5 columns are linearly dependent.

    It is interesting to note that there exists a set of 4 columns in this dictionary
    which is linearly dependent.

    ::

        >> B = A(:, [1, 4, 5, 7]); B

        B =

            1.0000         0    0.5000    0.5000
                 0         0    0.5000   -0.5000
                 0         0    0.5000   -0.5000
                 0    1.0000    0.5000    0.5000

        >> rank(B)

        ans =

             3

    This is a crucial difference between an orthogonal basis and
    an overcomplete dictionary. 
    In an orthogonal basis for :math:`\RR^N`, all :math:`N` vectors are linearly
    independent. As we create overcomplete dictionaries, it is possible
    that there exist some subsets of columns of size :math:`N` or less
    which are linearly dependent. 

    Let's quickly examine the null space of :math:`B`::

        >> c = null(B)

        c =

           -0.5000
           -0.5000
            0.5000
            0.5000

        >> B * c

        ans =

           1.0e-16 *

            0.5551
           -0.2776
           -0.8327
           -0.2776    


Note that the dictionary need not provide a unique representation for any vector  :math:`x \in \CC^N`, but
it provides at least one representation for each  :math:`x \in \CC^N`.

.. example:: Non-unique representations

    We will construct a vector in the null space of :math:`A`::

        >> n = zeros(8,1); n([1,4,5,7]) = c; n

        n =

           -0.5000
                 0
                 0
           -0.5000
            0.5000
                 0
            0.5000
                 0

    Consider the vector::

        >> x = [4 ,2,2,5]';

    Following calculation shows two different representations of :math:`x` 
    in :math:`A`::

        >> alpha  = [2, 0, 0, 3, 4, 0, 0, 0]'
        >> A * alpha

        ans =

             4
             2
             2
             5

        >> A * (alpha + n)

        ans =

             4
             2
             2
             5

        >> beta = alpha + n

        beta =

            1.5000
                 0
                 0
            2.5000
            4.5000
                 0
            0.5000
                 0

    Both alpha and beta are valid representations of x in A. 
    While alpha has 3 non-zero entries, beta has 4. In that sense
    alpha is a more sparse representation of x in A. 

    Constructing x from A requires only 3 columns if we choose
    the alpha representation, but it requires 4 columns if we
    choose the beta representation.


When  :math:`D=N` we have a set of unit norm vectors which span the whole of  :math:`\CC^N`. Thus, we have a basis
(not-necessarily an orthonormal basis). A dictionary cannot have  :math:`D < N`. The more interesting case
is when  :math:`D > N`.

.. note::

  There are also applications of undercomplete dictionaries
  where the number of atoms :math:`D` is less than the ambient space
  dimension :math:`N`. However, we will not be considering them
  unless specifically mentioned.


Redundant dictionaries and sparse signals
--------------------------------------------------


With  :math:`D > N`, clearly there are more atoms than necessary to provide a representation of signal  :math:`x \in \CC^N`.
Thus such a dictionary is able provide multiple representations to same vector  :math:`x`. We call such
dictionaries **redundant dictionaries** or **over-complete dictionaries**.

.. index:: Redundant dictionary


.. index:: Over-complete dictionary


In contrast a basis with  :math:`D=N` is called a **complete dictionary**.

.. index:: Complete dictionary

A special class of signals is those signals which have a sparse representation in a given 
dictionary  :math:`\mathcal{D}`.

..  _def:ssm:D_K_sparse_signal:

.. definition::

    A signal  :math:`x \in \CC^N` is called  :math:`(\mathcal{D},K)`-sparse if it can be 
    expressed as a linear combination of at-most  :math:`K` atoms from the dictionary   :math:`\mathcal{D}`
    where  :math:`K \ll D`.
    

It is usually expected that  :math:`K \ll N` also holds.

Let  :math:`\Lambda \subset \Omega` be a subset of indices with  :math:`|\Lambda|=K`.

Let  :math:`x` be any signal in  :math:`\CC^N` such that  :math:`x` can be expressed as
    
.. math::

    x = \sum_{\lambda \in \Lambda} b_{\lambda} \phi_{\lambda} \quad \text{where } b_{\lambda}  \in \CC.


Note that this is not the only possible representation of  :math:`x` in  :math:`\mathcal{D}`. This is
just one of the possible representations of  :math:`x`. The special thing about this representation
is that it is  :math:`K`-sparse i.e. only at most  :math:`K` atoms from the dictionary are being used.

Now there are  :math:`\binom{D}{K}` ways in which we can choose a set of  :math:`K` atoms from the 
dictionary  :math:`\mathcal{D}`. 

Thus the set of  :math:`(\mathcal{D},K)`-sparse signals is given by
    
.. math::

    \Sigma_{(\mathcal{D},K)} = \{x \in \CC^N :  x = \sum_{\lambda \in \Lambda} b_{\lambda} \phi_{\lambda} \}.

for some index set  :math:`\Lambda \subset \Omega` with  :math:`|\Lambda|=K`.

This set  :math:`\Sigma_{(\mathcal{D},K)}` is dependent on the chosen dictionary  :math:`\mathcal{D}`.
In the sequel, we will simply refer to it as  :math:`\Sigma_K`.


.. example:: K-sparse signals for standard basis

    For the special case where  :math:`\mathcal{D}` is nothing but the standard basis of  :math:`\CC^N`, then
        
    .. math::

        \Sigma_K = \{ x : \|x \|_0 \leq K\}

    i.e. the set of signals which has  :math:`K` or less non-zero elements.


.. example:: 

    In contrast if we choose an orthonormal basis  :math:`\Psi` such that every  :math:`x\in\CC^N` can be 
    expressed as
        
    .. math::

        x = \Psi \alpha 

    then with the dictionary  :math:`\mathcal{D} = \Psi`, the set of  :math:`K`-sparse signals is given by
        
    .. math::

        \Sigma_K = \{ x = \Psi \alpha : \| \alpha \|_0 \leq K\}.





We also note that set of vectors  :math:`\{ \alpha_{\lambda} : \lambda \in \Lambda \}` with  :math:`K < N`
form a subspace of  :math:`\CC^N`.

So we have  :math:`\binom{D}{K}` :math:`K`-sparse subspaces contained in the dictionary  :math:`\mathcal{D}`.
And the  :math:`K`-sparse signals lie in the **union of all these subspaces**. 

.. _sec:ssm:sparse_approximation_problem:

Sparse approximation problem
-----------------------------------



.. index:: Sparse approximation

In sparse approximation problem, we attempt to express a given signal  :math:`x \in \CC^N` using
a linear combination of  :math:`K` atoms from the dictionary  :math:`\mathcal{D}` where  :math:`K \ll N` and
typically  :math:`N \ll D` i.e. the number of atoms in a dictionary  :math:`\mathcal{D}` is typically much larger
than the ambient signal space dimension  :math:`N`.

Naturally we wish to obtain a best possible sparse representation of  :math:`x` over the atoms
 :math:`\phi_{\omega} \in \mathcal{D}` which minimizes the approximation error. 


Let  :math:`\Lambda` denote the index set of atoms which are used to create a  :math:`K`-sparse 
representation of  :math:`x` where  :math:`\Lambda \subset \Omega` with  :math:`|\Lambda| = K`.

Let  :math:`x_{\Lambda}` represent an approximation of  :math:`x` over the set of atoms indexed by  :math:`\Lambda`.

Then we can write   :math:`x_{\Lambda}` as
    
.. math::

    x_{\Lambda} = \sum_{\lambda \in \Lambda} b_{\lambda} \phi_{\lambda} \quad \text{where } b_{\lambda}  \in \CC.


We put all complex valued coefficients  :math:`b_{\lambda}` in the sum into a list  :math:`b`.

The approximation error is given by
    
.. math::

    e  = \| x - x_{\Lambda} \|_2.


We would like to minimize the approximation error over all possible choices of  :math:`K` atoms
and corresponding set of coefficients  :math:`b_{\lambda}`.

Thus the sparse approximation problem can be cast as a minimization problem given by
    
.. math::
    :label: eq:ssm:sparse_approximation

    \underset{|\Lambda| = K}{\text{min}} \, \underset{b}{\text{min}} 
    \left \| x -  \sum_{\lambda \in \Lambda} b_{\lambda} \phi_{\lambda} \right \|_2.


If we choose a particular  :math:`\Lambda`, then the inner minimization problem becomes
a straight-forward least squares problem. 
But there are  :math:`\binom{D}{K}` possible choices of  :math:`\Lambda` and solving the
inner least squares problem for each of them becomes prohibitively expensive.

We reemphasize here that in this formulation we are using a *fixed* dictionary  :math:`\mathcal{D}`
while the vector  :math:`x \in \CC^N` is *arbitrary*.

This problem is known as  :math:`(\mathcal{D}, K)`-:textsc:`sparse` approximation problem.

.. index::  Sparse approximation


A related problem is known as  :math:`(\mathcal{D}, K)`-:textsc:`exact-sparse` problem 
where it is known a-priori that  :math:`x` is a linear combination of at-most  :math:`K` atoms
from the given dictionary  :math:`\mathcal{D}` i.e.  :math:`x` is a  :math:`K`-sparse signal as 
defined in previous section for the dictionary  :math:`\mathcal{D}`.




.. index::  Exact-sparse



This formulation simplifies the minimization problem :eq:`eq:ssm:sparse_approximation` since
it is known a priori that for  :math:`K`-sparse signals, a  :math:`0` approximation error can be achieved.
The only problem is to find a set of subspaces from the  :math:`\binom{D}{K}` possible  :math:`K`-sparse
subspaces which are able to provide a  :math:`K`-sparse representation of  :math:`x` and amongst them
choose one. It is imperative to note that even the  :math:`K`-sparse representation need not
be unique.

Clearly the :textsc:`exact-sparse` problem is simpler than the :textsc:`sparse` approximation problem. Thus
if :textsc:`exact-sparse` problem is NP-Hard then so is the harder :textsc:`sparse`-approximation problem.
It is expected that solving the :textsc:`exact-sparse` problem will provide insights into solving the
:textsc:`sparse` problem.

It would be useful to get some uniqueness conditions 
for general dictionaries which guarantee that the sparse representation
of a vector is unique in the dictionary. 
Such conditions
would help us guarantee the uniqueness of :textsc:`exact-sparse` problem.


Synthesis and analysis
--------------------------------


The atoms of a dictionary  :math:`\mathcal{D}` can be organized into a  :math:`N \times D` matrix as follows:
    
.. math::

    \Phi \triangleq \begin{bmatrix}
    \phi_{\omega_1} & \phi_{\omega_2} & \dots & \phi_{\omega_D}
    \end{bmatrix}.


where  :math:`\Omega = \{\omega_1, \omega_2, \dots, \omega_N\}` is the index set for the atoms
of  :math:`\mathcal{D}`. We remind that  :math:`\phi_{\omega} \in \CC^N`, hence they have a column
vector representation in the standard basis for  :math:`\CC^N`.

The order of columns doesn't matter as long as it remains fixed once chosen.

Thus, in matrix terminology, a representation of  :math:`x \in \CC^N` in the dictionary can
be written as
    
.. math::

    x = \Phi b

where  :math:`b \in \CC^D` is a vector of coefficients to produce a superposition  :math:`x` from the
atoms of dictionary  :math:`\mathcal{D}`. 
Clearly with  :math:`D > N`,  :math:`b` is not unique. Rather for every vector
:math:`z \in \NullSpace(\Phi)`, we have:
    
.. math::

    \Phi (b + z) = \Phi b + \Phi z = x + 0 = x.


.. index:: Synthesis matrix

.. _def:ssm:dictionary:synthesis_matrix:

.. definition::

    
    The matrix  :math:`\Phi` is called a 
    **synthesis matrix** since  
    :math:`x` is synthesized from the columns of
    :math:`\Phi` with the coefficient vector  :math:`b`.


We can also view the synthesis matrix  :math:`\Phi` as a linear operator from  :math:`\CC^D` to  :math:`\CC^N`.

There is another way to look at  :math:`x` through  :math:`\Phi`. 

.. index:: Analysis matrix

.. _def:ssm:dictionary:analysis_matrix:

.. definition:: Analysis matrix

    The conjugate transpose  :math:`\Phi^H` of the synthesis matrix  :math:`\Phi` is called the **analysis matrix**.
    It maps a given vector  :math:`x \in \CC^N` to a list of inner products with the dictionary:
        
    .. math::

        c = \Phi^H x 

    where  :math:`c \in \CC^N`.


.. remark::

    Note that in general  :math:`x \neq \Phi (\Phi^H x)` unless  :math:`\mathcal{D}` is an orthonormal basis.





.. index::  Exact-sparse

.. _def:ssm:d_k_exact_sparse_problem:

.. definition::  D-K exact-sparse problem

    
    With the help of synthesis matrix  :math:`\Phi`, the 
    :math:`(\mathcal{D}, K)`-:textsc:`exact-sparse`
    can now be written as
        
    .. math::
        :label: eq:ssm:d_k_exact_sparse_problem

        \begin{aligned}
          & \underset{\alpha}{\text{minimize}} 
          & &  \| \alpha \|_0 \\
          & \text{subject to}
          & &  x = \Phi \alpha\\
          & \text{and}
          & &  \| \alpha \|_0 \leq K
        \end{aligned}


.. index::  Sparse approximation


.. _def:ssm:d_k_sparse_approximation_problem:

.. definition:: D-K sparse approximation problem

    
    With the help of synthesis matrix  :math:`\Phi`, the 
    :math:`(\mathcal{D}, K)`-:textsc:`sparse` approximation
    can now be written as
        
    .. math::
        :label: eq:ssm:d_k_sparse_approximation_problem

        \begin{aligned}
          & \underset{\alpha}{\text{minimize}} 
          & &  \| x - \Phi \alpha \|_2 \\
          & \text{subject to}
          & &  \| \alpha \|_0 \leq K.
        \end{aligned}



