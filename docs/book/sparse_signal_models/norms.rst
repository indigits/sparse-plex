
 
p-norms and sparse signals
===================================================


 
l1 ,   l2  and   max  norms
----------------------------------------------------


There are some simple and useful results on relationships between 
different  :math:`p`-norms listed in this section. We also discuss
some interesting properties of  :math:`l_1`-norm specifically.

.. _def:ssm:sign_vector:

.. definition::

     
    .. index:: Sign vector
    

    
    Let  :math:`v \in \CC^N`. Let the entries in  :math:`v` be represented as
    
    .. math::
    
        v_i = r_i \exp (j \theta_i)
    
    where  :math:`r_i = | v_i |` with the convention that  :math:`\theta_i = 0` 
    whenever  :math:`r_i = 0`.
    
    The sign vector for  :math:`v` denoted by  :math:`\sgn(v)` is defined as
    
    .. math::
    
        \sgn(v)  = \begin{bmatrix}\sgn(v_1) \\ \vdots \\ \sgn(v_N)  \end{bmatrix}
    
    where
    
    .. math::
    
        \sgn(v_i) = \left\{
                \begin{array}{ll}
                    \exp (j \theta_i) & \mbox{if  :math:`r_i \neq 0` };\\
                    0 & \mbox{if  :math:`r_i = 0` }.
                \end{array}
              \right.
    


.. _res:ssm:l1_norm_as_inner_product_with_sign_vector:

.. lemma::


    
    For any  :math:`v \in \CC^N` : 
    
    .. math::
    
        \| v \|_1 = \sgn(v)^H v = \langle v , \sgn(v) \rangle.
    


.. proof::

    
    .. math::
    
        \| v \|_1 = \sum_{i=1}^N r_i  = \sum_{i=1}^N \left [r_i e^{j \theta_i} \right ] e^{- j \theta_i} 
        = \sum_{i=1}^N v_i e^{- j \theta_i} = \sgn(v)^H v.
    
    Note that whenever  :math:`v_i = 0`, corresponding  :math:`0` entry in  :math:`\sgn(v)` has no effect on the sum.


.. _lem:ssm:l1_norm_l2_bounds:

.. lemma::


    
    Suppose  :math:`v \in \CC^N`.  Then
    
    .. math::
    
         \| v \|_2 \leq \| v\|_1 \leq \sqrt{N} \| v \|_2.
    



.. proof::

    For the lower bound, we go as follows
    
    .. math::
    
        \| v \|_2^2 = \sum_{i=1}^N | v_i|^2  \leq \left ( \sum_{i=1}^N | v_i|^2  + 2 \sum_{i, j, i \neq j} | v_i | | v_j| \right )
        = \left ( \sum_{i=1}^N | v_i| \right )^2 = \| v \|_1^2.
    
    This gives us
    
    .. math::
    
        \| v \|_2 \leq \| v \|_1.
    
    
    We can write  :math:`l_1` norm as
    
    .. math::
    
        \| v \|_1 = \langle v, \sgn (v) \rangle.
    
    
    By Cauchy-Schwartz inequality we have
    
    .. math::
    
        \langle v, \sgn (v) \rangle \leq  \| v \|_2  \| \sgn (v) \|_2 
     
    
    Since  :math:`\sgn(v)` can have at most  :math:`N` non-zero values, each with magnitude 1,
    
    .. math::
    
        \| \sgn (v) \|_2^2 \leq N \implies \| \sgn (v) \|_2 \leq \sqrt{N}.
    
    Thus, we get
    
    .. math::
    
        \| v \|_1  \leq \sqrt{N} \| v \|_2.
    


.. _res:ssm:l2_upper_bound_max_norm:

.. lemma::


    
    Let  :math:`v \in \CC^N`. Then
    
    .. math::
    
        \| v \|_2 \leq \sqrt{N} \| v \|_{\infty}
    


.. proof::

    
    .. math::
    
        \| v \|_2^2 = \sum_{i=1}^N | v_i |^2 \leq N \underset{1 \leq i \leq N}{\max} ( | v_i |^2) = N \| v \|_{\infty}^2.
    
    Thus
    
    .. math::
    
        \| v \|_2 \leq \sqrt{N} \| v \|_{\infty}.
    

.. _res:ssm:p_q_norm_bounds:

.. lemma::


    
    Let  :math:`v \in \CC^N`. Let  :math:`1 \leq p, q \leq \infty`.
    Then
    
    .. math::
    
        \| v \|_q \leq \| v \|_p \text{ whenever } p \leq q.
    


.. proof::

    TBD


.. _res:ssm:one_vec_l1_norm:

.. lemma::


    
    Let  :math:`\OneVec \in \CC^N` be the vector of all ones i.e.  :math:`\OneVec = (1, \dots, 1)`.
    Let  :math:`v \in \CC^N` be some arbitrary vector. Let  :math:`| v |` denote the vector of
    absolute values of entries in  :math:`v`. i.e.  :math:`|v|_i = |v_i| \Forall 1 \leq i \leq N`. Then
    
    .. math::
    
        \| v \|_1 = \OneVec^T | v | = \OneVec^H | v |.
     


.. proof::

    
    .. math::
    
        \OneVec^T | v | = \sum_{i=1}^N  | v |_i =   \sum_{i=1}^N  | v_i | = \| v \|_1.
    
    Finally since  :math:`\OneVec` consists only of real entries, hence its transpose and Hermitian 
    transpose are same.


.. _res:ssm:ones_matrix_l1_norm:

.. lemma::

    Let  :math:`\OneMat \in \CC^{N \times N}` be a square matrix of all ones. Let  :math:`v \in \CC^N` 
    be some arbitrary vector. Then

    
    
    .. math::
    
        |v|^T \OneMat | v | = \| v \|_1^2.
    


.. proof::

    We know that
    
    .. math::
    
        \OneMat = \OneVec \OneVec^T
    
    Thus,
    
    .. math::
    
        |v|^T \OneMat | v |  = |v|^T  \OneVec \OneVec^T | v |  = (\OneVec^T | v | )^T \OneVec^T | v | =  \| v \|_1 \| v \|_1 = \| v \|_1^2.
    
    We used the fact that  :math:`\| v \|_1 = \OneVec^T | v |`.



.. _res:ssm:k_th_largest_entry_l1_norm:
.. _eq:ssm:k_th_largest_entry_l1_norm:

.. theorem::


    
     :math:`k`-th largest (magnitude) entry in a vector  :math:`x \in \CC^N` denoted by  :math:`x_{(k)}` obeys

    
    .. math::
    
    
        
        | x_{(k)} | \leq  \frac{\| x \|_1}{k}
    


.. proof::

    Let  :math:`n_1, n_2, \dots, n_N` be a permutation of  :math:`\{ 1, 2, \dots, N \}` such that
    
    .. math::
    
        |x_{n_1} | \geq  | x_{n_2} | \geq \dots \geq  | x_{n_N} |.
    
    Thus, the  :math:`k`-th largest entry in  :math:`x` is  :math:`x_{n_k}`. It is clear that
    
    .. math::
    
        \| x \|_1 = \sum_{i=1}^N | x_i | = \sum_{i=1}^N |x_{n_i} |
    
    
    Obviously
    
    .. math::
    
        |x_{n_1} | \leq \sum_{i=1}^N |x_{n_i} | = \| x \|_1.
    
    Similarly
    
    .. math::
    
        k |x_{n_k} | = |x_{n_k} | + \dots + |x_{n_k} |  \leq |x_{n_1} | + \dots + |x_{n_k} | \leq \sum_{i=1}^N |x_{n_i} | \leq  \| x \|_1.
    
    Thus
    
    .. math::
    
        |x_{n_k} |  \leq \frac{\| x \|_1}{k}.
    




 
Sparse signals
----------------------------------------------------

In this section we explore some useful properties of  :math:`\Sigma_K`, the set of  :math:`K`-sparse signals in standard basis
for  :math:`\CC^N`.

We recall that

.. math::

    \Sigma_K  = \{ x \in \CC^N : \| x \|_0 \leq K \}.


We established before that this set is a union of  :math:`\binom{N}{K}` subspaces of  :math:`\CC^N` each of which
is is constructed by an index set  :math:`\Lambda \subset \{1, \dots, N \}` with  :math:`| \Lambda | = K` choosing
:math:`K` specific dimensions of  :math:`\CC^N`. 

We first present some lemmas which connect the  :math:`l_1`,  :math:`l_2` and  :math:`l_{\infty}` norms of vectors
in  :math:`\Sigma_K`.

.. _lem:u_sigma_k_norms:

.. lemma::


    
    Suppose  :math:`u \in \Sigma_K`.  Then
    
    .. math::
    
          \frac{\| u\|_1}{\sqrt{K}} \leq \| u \|_2 \leq \sqrt{K} \| u \|_{\infty}.
    



.. proof::

   We can write  :math:`l_1` norm as
    
    .. math::
    
        \| u \|_1 = \langle u, \sgn (u) \rangle.
    
    
    By Cauchy-Schwartz inequality we have
    
    .. math::
    
        \langle u, \sgn (u) \rangle \leq  \| u \|_2  \| \sgn (u) \|_2 
     
    
    Since  :math:`u \in \Sigma_K`,  :math:`\sgn(u)` can have at most  :math:`K` non-zero values each with magnitude 1.
    Thus, we have
    
    .. math::
    
        \| \sgn (u) \|_2^2 \leq K \implies \| \sgn (u) \|_2 \leq \sqrt{K}
    
    
    Thus we get the lower bound
    
    .. math::
    
        \| u \|_1 \leq \| u \|_2 \sqrt{K}
        \implies \frac{\| u \|_1}{\sqrt{K}} \leq \| u \|_2.
    
    
    Now  :math:`| u_i | \leq \max(| u_i |) = \| u \|_{\infty}`. So we have
      
    .. math::
    
          \| u \|_2^2 = \sum_{i= 1}^{N} | u_i |^2 \leq  K \| u \|_{\infty}^2
    
    since there are only  :math:`K` non-zero terms in the expansion of  :math:`\| u \|_2^2`.
    
    This establishes the upper bound:
    
    .. math::
    
          \| u \|_2 \leq \sqrt{K} \| u \|_{\infty}
    


