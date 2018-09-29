
 
Tools for dictionary analysis
===================================================


In this and following sections we review various properties associated 
with a dictionary  :math:`\mathcal{D}` which are
useful in understanding the behavior and capabilities of a dictionary.


We recall that a dictionary  :math:`\mathcal{D}` consists of a finite number of unit norm vectors in  :math:`\CC^N` called
atoms  which span the signal space  :math:`\CC^N`.
Atoms of the dictionary are indexed by an index set  :math:`\Omega`. i.e.


.. math:: 

    \mathcal{D} = \{ d_{\omega} : \omega \in \Omega \}

with  :math:`|\Omega| = D` and  :math:`N \leq D` 
with  :math:`\| d_{\omega} \|_2 = 1` for all atoms.

The vectors  :math:`x \in \CC^N` can be represented by a synthesis matrix consisting of
the atoms of  :math:`\mathcal{D}` by a vector  :math:`\alpha \in \CC^D` as


.. math:: 

    x = \DDD \alpha.

Note that we are using the same symbol  :math:`\DDD` to represent the dictionary
as a set of atoms as well as the corresponding synthesis matrix.

We can write the matrix  :math:`\DDD` consisting of its columns as


.. math:: 

    \DDD = 
    \begin{bmatrix}
    d_1 & \dots & d_D
    \end{bmatrix}

This shouldn't be causing any confusion in the sequel. When we write the subscript as  :math:`d_{\omega_i}` 
where  :math:`\omega_i \in \Omega` 
we are referring to the atoms of the dictionary  :math:`\mathcal{D}` indexed by the set  :math:`\Omega`, while
when we write the subscript as  :math:`d_i` we are referring to a column of corresponding synthesis matrix.
In this case,  :math:`\Omega` will simply mean the index set  :math:`\{ 1, \dots, D \}`. Obviously  :math:`|\Omega| = D` 
holds still. 

Often, we will be working with a subset of atoms in a dictionary. Usually such a subset
of atoms will be indexed by an index set  :math:`\Lambda \subseteq \Omega`.  :math:`\Lambda` 
will take the form of  :math:`\Lambda \subseteq \{\omega_1, \dots, \omega_D\}` or
 :math:`\Lambda \subseteq \{1, \dots, D\}` depending upon whether we are talking about
the subset of atoms in the dictionary or a subset of columns from the corresponding
synthesis matrix.

We will need the notion of a sub-dictionary :cite:`tropp2006just` described below.

.. _def:ssm:subdictionary:

.. definition:: 

     
    .. index:: Sub-dictionary
    

    
    A sub-dictionary is a linearly independent collection of atoms. 
    Let  :math:`\Lambda \subset \{\omega_1, \dots, \omega_D\}` be the index set for the
    atoms in the sub-dictionary. We denote the sub-dictionary as  :math:`\DDD_{\Lambda}`.
    We also use  :math:`\DDD_{\Lambda}` to denote the corresponding matrix with  :math:`\Lambda \subset \{1, \dots, D\}`.




.. remark:: 

    A subdictionary is full rank.

This is obvious since it is a collection of linearly independent atoms.

For subdictionaries often we will say  :math:`K = | \Lambda |` and  :math:`G = \DDD_{\Lambda}^H \DDD_{\Lambda}` as its
Gram matrix. Sometimes, we will also be considering  
:math:`G^{-1}`.  :math:`G^{-1}` has a useful interpretation
in terms of the  **dual vectors**  for the atoms in  
:math:`\DDD_{\Lambda}` :cite:`tropp2004just`.

Let  :math:`\{ d_{\lambda} \}_{\lambda \in \Lambda}` denote the atoms in  :math:`\DDD_{\Lambda}`. 
Let  :math:`\{ c_{\lambda} \}_{\lambda \in \Lambda}` 
be chosen such that


.. math:: 

    \langle d_{\lambda} , c_{\lambda} \rangle = 1

and


.. math:: 

    \langle d_{\lambda} , c_{\omega} \rangle = 0 \text { for } \lambda, \omega \in \Lambda, \lambda \neq \omega.

Each dual vector  :math:`c_{\lambda}` is orthogonal to atoms in the subdictionary at different indices
and is long enough so that its inner product with  :math:`d_{\lambda}` is one. The dual system somehow
inverts the sub-dictionary. In fact the dual vectors are nothing but the columns of the 
matrix  :math:`B = (\DDD_{\Lambda}^{\dag})^H`. Now, a simple calculation:


.. math:: 

    B^H B = (\DDD_{\Lambda}^{\dag}) (\DDD_{\Lambda}^{\dag})^H = (\DDD_{\Lambda}^H \DDD_{\Lambda})^{-1} \DDD_{\Lambda}^H \DDD_{\Lambda} (\DDD_{\Lambda}^H \DDD_{\Lambda})^{-1} = (\DDD_{\Lambda}^H \DDD_{\Lambda})^{-1} = G^{-1}.

Therefore, the inverse Gram matrix lists the inner products between the dual vectors. 


Sometimes we will be discussing tools which also apply for general matrices. 
We will use
the symbol  :math:`\Phi` for representing general matrices.  Whenever the dictionary is 
an orthonormal basis, we will use the symbol  :math:`\Psi`.






