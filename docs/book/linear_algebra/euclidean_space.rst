
 
The Euclidean space
===================================================

.. _sec:euclidean_space:

In this book we will be generally concerned with the Euclidean space :math:`\RR^N`. This section
summarizes important results for this space.

:math:`\RR^2` (the 2-dimensional plane) and :math:`\RR^3` the 3-dimensional space are the most familiar 
spaces to us.

:math:`\RR^N` is a generalization in :math:`N` dimensions.



.. definition:: 

    Let :math:`\RR` denote the field of real numbers. For any positive integer :math:`N`, the set of all :math:`N`-tuples of
    real numbers forms an :math:`N`-dimensional vector space over :math:`\RR` which is denoted as :math:`\RR^N` and
    sometimes called *real cooordinate space*.


An element :math:`x` in :math:`\RR^N` is written as 


.. math::
      x  = (x_1, x_2, \ldots, x_N),

where each :math:`x_i` is a real number.

Vector space operations on :math:`\RR^N` are defined by:


.. math::
      &x + y = (x_1 + y_1, x_2 + y_2, \dots, x_N + y_N), \quad \forall x, y \in \RR^N.\\
      & \alpha x = (\alpha x_1, \alpha x_2, \dots, \alpha x_N) \quad \forall x \in \RR^N, \alpha \in \RR .


:math:`\RR^N` comes with the standard ordered basis :math:`B = \{e_1, e_2, \dots, e_N\}`:


.. math::
    :label: eq:euclidean_standard_basis

    \begin{aligned}
      & e_1  = (1,0,\dots, 0),\\
      & e_2  = (0,1,\dots, 0),\\
      &\vdots\\
      & e_N  = (0,0,\dots, 1)
    \end{aligned}


An arbitrary vector :math:`x\in\RR^N` can be written as


.. math::
      x = \sum_{i=1}^{N}x_i e_i


 
Inner product
----------------------------------------------------

Standard inner product (a.k.a. dot product) is defined as:


.. math::
      \langle x, y \rangle = \sum_{i=1}^{N} x_i y_i = x_1 y_1 + x_2 y_2 + \dots + x_N y_N \quad \forall x, y \in \RR^N.


This makes :math:`\RR^N` an *inner product space*.

The result is always a real number. Hence we have symmetry:


.. math::
      \langle x, y \rangle  = \langle y, x \rangle


 
Norm
----------------------------------------------------


The *length* of the vector (a.k.a. Euclidean norm or :math:`\ell_2` norm) is defined as:


.. math::
      \| x \| = \sqrt{\langle x, x \rangle} = \sqrt{\sum_{i=1}^{N} x_i^2} \quad \forall x \in \RR^N.


This makes :math:`\RR^N`  a *normed linear space*.

The angle :math:`\theta` between two vectors is given by:


.. math::
      \theta = \cos^{-1} \frac{ \langle x, y \rangle }{\| x \| \| y \|}


 
Distance
----------------------------------------------------


Distance between two vectors is defined as:


.. math::
      d(x,y) = \| x  - y \| = \sqrt{\sum_{i=1}^{N} (x_i - y_i)^2}


This distance function is known as *Euclidean metric*. 

This makes  :math:`\RR^N`  a *metric space*.

 
:math:`\ell_p` norms
----------------------------------------------------


In addition to standard Euclidean norm, we define a family of norms 
indexed by :math:`p \in [1, \infty]` known as
:math:`l_p` norms over :math:`\RR^N`.


.. definition:: 

    :math:`\ell_p` norm is defined as:
    
    
    .. math::
        :label: eq:l_p_norm
    
          \| x \|_p = \begin{cases}
           \left ( \sum_{i=1}^{N} | x |_i^p  \right ) ^ {\frac{1}{p}} &  p \in [1, \infty)\\
          \underset{1 \leq i \leq N}{\max} |x_i| &  p = \infty
          \end{cases}
    


 
:math:`\ell_2` norm
""""""""""""""""""""""""""""""""""""""""""""""""""""""
As we can see from definition, :math:`\ell_2` norm is same as Euclidean norm.
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
In some cases it is useful to extend the notion of :math:`\ell_p` norms to the case
where :math:`0 < p < 1`. 

In such cases norm as defined in :eq:`eq:l_p_norm` doesn't satisfy triangle inequality, hence it is not
a proper norm function. We call such functions as *quasi-norms*.

 
:math:`\ell_0`-"norm"
""""""""""""""""""""""""""""""""""""""""""""""""""""""


Of specific mention is :math:`\ell_0`-"norm". It isn't even a quasi-norm. 
Note the use of quotes around the word
norm to distinguish :math:`\ell_0`-"norm" from usual norms.

.. definition:: 

    
    :math:`\ell_0`-"norm" is defined as:
    
    
    .. math::
          \| x \|_0 = | \supp(x) |
    
    
    where :math:`\supp(x) = \{ i : x_i \neq 0\}` denotes the support of :math:`x`.
    


Note that :math:`\| x \|_0` defined above doesn't follow the definition in 
:eq:`eq:l_p_norm`. 

Yet we can show that:

.. math::
      \lim_{p\to 0} \| x \|_p^p = | \supp(x) |

which justifies the notation.
