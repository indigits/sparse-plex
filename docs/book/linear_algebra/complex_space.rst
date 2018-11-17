
.. _sec:complex_space:
 
N dimensional complex space
===================================================

.. contents:: :local:


In this section we review important features of N dimensional
complex vector space :math:`\CC^N`. 



.. definition:: 

    Let :math:`\CC` denote the field of complex numbers. For any positive integer :math:`N`, the set of all :math:`N`-tuples of
    complex numbers forms an :math:`N`-dimensional vector space over :math:`\CC` which 
    is denoted as :math:`\CC^N` and
    sometimes called *complex vector space*.

An element :math:`x` in :math:`\CC^N` is written as 


.. math::
      x  = (x_1, x_2, \ldots, x_N),

where each :math:`x_i` is a complex number.

Vector space operations on :math:`\CC^N` are defined by:


.. math::
      &x + y = (x_1 + y_1, x_2 + y_2, \dots, x_N + y_N), \quad \forall x, y \in \CC^N.\\
      & \alpha x = (\alpha x_1, \alpha x_2, \dots, \alpha x_N) \quad \forall x \in \CC^N, \alpha \in \CC .


:math:`\CC^N` comes with the standard ordered basis :math:`B = \{e_1, e_2, \dots, e_N\}`:


.. math::
    :label: eq:complex_standard_basis

    \begin{aligned}
      & e_1  = (1,0,\dots, 0),\\
      & e_2  = (0,1,\dots, 0),\\
      &\vdots\\
      & e_N  = (0,0,\dots, 1)
    \end{aligned}


We note that the basis is same as the basis for :math:`N` dimensional
real vector space (the Euclidean space).

An arbitrary vector :math:`x\in\CC^N` can be written as


.. math::
      x = \sum_{i=1}^{N}x_i e_i


 
Inner product
----------------------------------------------------

Standard inner product is defined as:


.. math::
      \langle x, y \rangle = \sum_{i=1}^{N} x_i \overline{y_i} = 
      x_1 \overline{y_1} + x_2 \overline{y_2} + \dots + 
      x_N \overline{y_N} \quad \forall x, y \in \CC^N.

where :math:`\overline{y_i}` denotes the complex conjugate.

This makes :math:`\CC^N` an *inner product space*.

This satisfies the inner product rule:



.. math::
      \langle x, y \rangle  = \overline{\langle y, x \rangle}


 
Norm
----------------------------------------------------


The *length* of the vector (a.k.a. :math:`\ell_2` norm) is defined as:


.. math::
      \| x \| = \sqrt{\langle x, x \rangle} 
      = \sqrt{\sum_{i=1}^{N} x_i \overline{x_i} }
      = \sqrt{\sum_{i=1}^{N} |x_i|^2 }
      \quad \forall x \in \CC^N.


This makes :math:`\CC^N`  a *normed linear space*.

 
Distance
----------------------------------------------------


Distance between two vectors is defined as:



.. math::
      d(x,y) = \| x  - y \| = \sqrt{\sum_{i=1}^{N} |x_i - y_i|^2}


This makes  :math:`\CC^N`  a *metric space*.

 
:math:`\ell_p` norms
----------------------------------------------------


In addition to standard Euclidean norm, we define a family of norms indexed by :math:`p \in [1, \infty]` known as
:math:`\ell_p` norms over :math:`\CC^N`.


.. definition:: 

    :math:`\ell_p` norm is defined as:
    
    
    .. math::
        :label: eq:complex_l_p_norm
    
          \| x \|_p = \begin{cases}
           \left ( \sum_{i=1}^{N} | x |_i^p  \right ) ^ {\frac{1}{p}} &  p \in [1, \infty)\\
          \underset{1 \leq i \leq N}{\max} |x_i| &  p = \infty
          \end{cases}
    



So we have:


.. math::
      \| x \| = \| x \|_2



 
:math:`\ell_1` norm
""""""""""""""""""""""""""""""""""""""""""""""""""""""

From above definition we have 


.. math::
      \|x\|_1 = \sum_{i=1}^N |x_i|= |x_1| + |x_2| + \dots  + | x_N|


We use norms as a measure of strength of a signal or size of an error. Different norms signify different
aspects of the signal.

 
Quasi-norms
""""""""""""""""""""""""""""""""""""""""""""""""""""""
In some cases it is useful to extend the notion of 
:math:`\ell_p` norms to the case
where :math:`0 < p < 1`. 

In such cases norm as defined in :eq:`eq:complex_l_p_norm` doesn't 
satisfy triangle inequality, hence it is not
a proper norm function. We call such functions as *quasi-norms*.

 
:math:`\ell_0` "norm"
""""""""""""""""""""""""""""""""""""""""""""""""""""""


Of specific mention is :math:`\ell_0` "norm". It isn't even a quasi-norm. Note the use of quotes around the word
norm to distinguish :math:`\ell_0` "norm" from usual norms.


.. _def:linalg:cplx_l_0_norm:

.. definition:: 

    
    :math:`\ell_0` "norm" is defined as:
    
    
    .. math::
        :label: eq:linalg:cplx:l_0_norm
    
          \| x \|_0 = | \supp(x) |
    
    
    where :math:`\supp(x) = \{ i : x_i \neq 0\}` denotes the support of :math:`x`.



Note that :math:`\| x \|_0` defined above doesn't 
follow the definition in :eq:`eq:complex_l_p_norm`. 

Yet we can show that:


.. math::
      \lim_{p\to 0} \| x \|_p^p = | \supp(x) |


which justifies the notation.

