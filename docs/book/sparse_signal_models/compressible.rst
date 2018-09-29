Compressible signals
===================================================


In this section, we first look at some general results and definitions
related to  :math:`K`-term approximations of arbitrary signals  :math:`x \in \CC^N`. We then define
the notion of a compressible signal and study properties related to it.

 
K-term approximation of general signals
----------------------------------------------------



.. _def:ssm:signal_restriction:

.. definition:: 

     
    .. index:: Restriction of a signal on an index set
    

    
    Let  :math:`x \in \CC^N`. Let  :math:`T \subset \{ 1, 2, \dots, N\}` be any index set.Further let
    
    
    .. math:: 
    
        T = \{t_1, t_2, \dots, t_{|T|}\}
    
    such that
    
    
    .. math:: 
    
        t_1 < t_2 < \dots < t_{|T|}.
    
    Let  :math:`x_T \in \CC^{|T|}` be defined as 
    
    
    .. math::
        :label: eq:ssm:signal_restriction
    
        x_T = \begin{pmatrix}
        x_{t_1} & x_{t_2}  & \dots & x_{t_{|T|}}
        \end{pmatrix}.
    
    Then  :math:`x_T` is a  **restriction**  of the signal  :math:`x` on the index set  :math:`T`.
    
    Alternatively let  :math:`x_T \in \CC^N` be defined as
    
    
    .. math::
        :label: eq:ssm:signal_mask
    
        x_{T}(i) = \left\{
                \begin{array}{ll}
                    x(i) & \mbox{if  $i \in T$ };\\
                    0 & \mbox{otherwise}.
                \end{array}
              \right.
    
    In other words,  :math:`x_T \in \CC^N` keeps the entries in  :math:`x` indexed by  :math:`T` while sets all other entries to 0. Then we say
    that  :math:`x_T` is obtained by  **masking**   :math:`x` with  :math:`T`.
    As an abuse of notation, we will use any of the two definitions
    whenever we are referring to  :math:`x_T`. The definition 
    being used should be obvious from the context.




.. example:: Restrictions on index sets

    Let 
    
    
    .. math:: 
    
        x = \begin{pmatrix}
        -1 & 5 & 8 & 0 & 0 & -3 & 0 & 0 & 0 & 0
        \end{pmatrix} \in \CC^{10}.
    
    Let 
    
    
    .. math:: 
    
        T = \{ 1, 3, 7, 8\}.
    
    Then
    
    
    .. math:: 
    
        x_T = \begin{pmatrix}
        -1 & 0 & 8 & 0 & 0 &  0 & 0 & 0 & 0 & 0
        \end{pmatrix} \in \CC^{10}.
    
    Since  :math:`|T| = 4`, sometimes we will also write
    
    
    .. math:: 
    
        x = \begin{pmatrix}
        -1 & 8 & 0 & 0
        \end{pmatrix} \in \CC^4.
    



.. _def:ssm:k_term_signal_approximation:

.. definition:: 

     
    .. index::  :math:`K`-term approximation
    

    
    Let  :math:`x \in \CC^N` be an arbitrary signal.  Consider any index set  :math:`T \subset \{1, \dots, N \}` 
    with  :math:`|T| = K`. Then  :math:`x_T` is a  
    :math:`K`-term approximation  of  :math:`x`.


Clearly for any  :math:`x \in \CC^N` there are  :math:`\binom{N}{K}` possible  :math:`K`-term approximations of  :math:`x`.



.. example::  K-term approximation

    Let 
    
    
    .. math:: 
    
        x = \begin{pmatrix}
        -1 & 5 & 8 & 0 & 0 & -3 & 0 & 0 & 0 & 0
        \end{pmatrix} \in \CC^{10}.
    
    Let  :math:`T= \{ 1, 6 \}`. Then
    
    
    .. math:: 
    
        x_T = \begin{pmatrix}
        -1 & 0 & 0 & 0 & 0 & -3 & 0 & 0 & 0 & 0
        \end{pmatrix}
    
    is a  :math:`2`-term approximation of  :math:`x`. 
    
    If we choose  :math:`T= \{7,8,9,10\}`, the corresponding  :math:`4`-term approximation of  :math:`x` is
    
    
    .. math:: 
    
         \begin{pmatrix}
        0 & 0 & 0 & 0 & 0 & 0 & 0 & 0 & 0 & 0
        \end{pmatrix}.
    



.. _def:ssm:largest_entries_signal:

.. definition:: 

     
    .. index:: Largest entries approximation
    

    
    Let  :math:`x \in \CC^N` be an arbitrary signal. Let  :math:`\lambda_1, \dots, \lambda_N` be
    indices of entries in  :math:`x` such that
    
    
    .. math:: 
    
        | x_{\lambda_1} | \geq | x_{\lambda_2} | \geq \dots \geq | x_{\lambda_N} |.
    
    In case of ties, the order is resolved lexicographically, i.e. if  :math:`|x_i| = |x_j|` 
    and  :math:`i < j` then  :math:`i` will appear first in the sequence  :math:`\lambda_k`.
    
    Consider the index set  :math:`\Lambda_K = \{ \lambda_1, \lambda_2, \dots, \lambda_K\}`. 
    The restriction of  :math:`x` on  :math:`\Lambda_K` given by  :math:`x_{\Lambda_K}` (see  :ref:`above <def:ssm:signal_restriction>`)
    contains the  :math:`K` largest entries  :math:`x` while setting all other entries to 0. This is known
    as the  :math:`K` **largest entries approximation**  of  :math:`x`. 
    
    This signal is denoted henceforth as  :math:`x|_K`. i.e.
    
    .. math::
    
        x|_K = x_{\Lambda_K}
    
    where  :math:`\Lambda_K` is the index set corresponding to  :math:`K` largest entries in  :math:`x` (magnitude wise).




.. example:: Largest entries approximation

    Let 
    
    
    .. math:: 
    
        x  = \begin{pmatrix}
        -1 & 5 & 8 & 0 & 0 & -3 & 0 & 0 & 0 & 0
        \end{pmatrix}.
    
    Then
    
    
    .. math:: 
    
        x|_1 = \begin{pmatrix}
        0 & 0 & 8 & 0 & 0 & 0 & 0 & 0 & 0 & 0
        \end{pmatrix}.
    
    
    
    .. math:: 
    
        x|_2 = \begin{pmatrix}
        0 & 5 & 8 & 0 & 0 & 0 & 0 & 0 & 0 & 0
        \end{pmatrix}.
    
    
    
    .. math:: 
    
        x|_3 = \begin{pmatrix}
        0 & 5 & 8 & 0 & 0 & -3 & 0 & 0 & 0 & 0
        \end{pmatrix}
    
    
    
    .. math:: 
    
        x|_4 = x.
    
    All further  :math:`K` largest entries approximations are same as  :math:`x`.


A pertinent question at this point is: which  
:math:`K`-term approximation of  :math:`x` is the best 
:math:`K`-term approximation? 
Certainly in order to compare two approximations we need
some criterion. 
Let us choose  :math:`l_p` norm as the criterion. The next
lemma gives an interesting result for best  :math:`K`-term approximations in  :math:`l_p` norm sense.


.. _lem:ssm:best_k_term_approximation:
.. lemma:: 

    Let  :math:`x \in \CC^N`. Let the best  :math:`K` term approximation of  :math:`x` be obtained by the following optimization program:
    
    
    .. math::
        :label: eq:best_k_term_approximation_optimization_problem
    
        \begin{aligned}
            & \underset{T \subset \{1, \dots, N\}}{\text{maximize}}
            & & \| x_T \|_p \\
            & \text{subject to}
            & & |T| = K.
        \end{aligned}
    
    where  :math:`p \in [1, \infty]`.
    
    Let an optimal solution for this optimization problem 
    be denoted by :math:`x_{T^*}`. 
    Then  
    
    
    .. math:: 
    
        \| x|_K \|_p = \| x_{T^*} \|_p.
    
    i.e. the  :math:`K`-largest entries approximation of  :math:`x` is an optimal solution to  
    :eq:`eq:best_k_term_approximation_optimization_problem` .



.. proof:: 

    For  :math:`p=\infty`, the result is obvious. In the following, we focus on  :math:`p \in [1, \infty)`.
    
    We note that maximizing  :math:`\| x_T \|_p` is equivalent to maximizing  :math:`\| x_T \|^p_p`.
    
    Let  :math:`\lambda_1, \dots, \lambda_N` be
    indices of entries in  :math:`x` such that
    
    
    .. math:: 
    
        | x_{\lambda_1} | \geq | x_{\lambda_2} | \geq \dots \geq | x_{\lambda_N} |.
    
    
    Further let  :math:`\{ \omega_1, \dots, \omega_N\}` be any permutation of  :math:`\{1, \dots, N \}`.
    
    Clearly
    
    
    .. math:: 
    
        \| x|_K \|_p^{p} = \sum_{i=1}^K |x_{\lambda_i}|^{p}  \geq \sum_{i=1}^K |x_{\omega_i}|^{p}.
    
    
    Thus if  :math:`T^*` corresponds to an optimal solution of  :eq:`eq:best_k_term_approximation_optimization_problem` 
    then 
    
    
    .. math:: 
    
        \| x|_K \|_p^{p}  = \| x_{T^*} \|_p^{p}.
    
    Thus  :math:`x|_K` is an optimal solution to  :eq:`eq:best_k_term_approximation_optimization_problem` .


This lemma helps us establish that whenever we are looking for a best  :math:`K`-term 
approximation of  :math:`x` under any  :math:`l_p` norm, all we have to do is to pickup
the  :math:`K`-largest entries in  :math:`x`.



.. index:: Restriction of a matrix on an index set
.. _def:ssm:matrix_restriction:

.. definition:: 

     
    

    
    Let  :math:`\Phi \in \CC^{M \times N}`. Let  :math:`T \subset \{ 1, 2, \dots, N\}` be any index set.Further let
    
    
    .. math:: 
    
        T = \{t_1, t_2, \dots, t_{|T|}\}
    
    such that
    
    
    .. math:: 
    
        t_1 < t_2 < \dots < t_{|T|}.
    
    Let  :math:`\Phi_T \in \CC^{M \times |T|}` be defined as 
    
    
    .. math::
        :label: eq:ssm:matrix_restriction
    
        \Phi_T = \begin{bmatrix}
        \phi_{t_1} & \phi_{t_2}  & \dots & \phi_{t_{|T|}}
        \end{bmatrix}.
    
    Then  :math:`\Phi_T` is a  **restriction**  of the matrix  :math:`\Phi` on the index set  :math:`T`.
    
    Alternatively let  :math:`\Phi_T \in \CC^{M \times N}` be defined as
    
    
    .. math::
        :label: eq:ssm:matrix_mask
    
        (\Phi_{T})_i = \left\{
                \begin{array}{ll}
                    \phi_i & \mbox{if  $i \in T$ };\\
                    0 & \mbox{otherwise}.
                \end{array}
              \right.
    
    In other words,  :math:`\Phi_T \in \CC^{M \times N}` keeps the columns in  :math:`\Phi` indexed by  :math:`T` while sets all other columns to 0. Then we say
    that  :math:`\Phi_T` is obtained by  **masking**   :math:`\Phi` with  :math:`T`.
    As an abuse of notation, we will use any of the two definitions
    whenever we are referring to  :math:`\Phi_T`. The definition 
    being used should be obvious from the context.



.. _lem:ssm:restriction_simplification_sparse_vector:

.. lemma:: 


    
    Let  :math:`\supp(x) = \Lambda`. Then 
    
    
    .. math::
        \Phi x = \Phi_{\Lambda} x_{\Lambda}.
    



.. proof:: 

    
    
    .. math:: 
    
        \Phi x = \sum_{i=1}^N x_i \phi_i 
        = \sum_{\lambda_i \in \Lambda} x_{\lambda_i} \phi_{\lambda_i}
        = \Phi_{\Lambda} x_{\Lambda}.
    



.. remark:: 

    The lemma remains valid whether we use
    the restriction or the mask version of  :math:`x_{\Lambda}` 
    notation as long as same version is used
    for both  :math:`\Phi` and  :math:`x`.



.. _cor:ssm:matrix_vector_product_disjoint_set_seperation:

.. corollary:: 


    
    Let  :math:`S` and  :math:`T` be two disjoint index sets such that
    for some  :math:`x \in \CC^N` 
    
    
    .. math::
        x = x_T + x_S
    
    using the mask version of  :math:`x_T` notation.
    Then the following holds
    
    
    .. math::
        \Phi x = \Phi_T x_T + \Phi_S x_S.
    



.. proof:: 

    Straightforward application of 
    :ref:`previous result <lem:ssm:restriction_simplification_sparse_vector>`:
    
    
    .. math:: 
    
        \Phi x = \Phi x_T + \Phi x_S = \Phi_T x_T + \Phi_S x_S.
    



.. _lem:ssm:restriction_on_matrix_vector_product:

.. lemma:: 


    
    Let  :math:`T` be any index set. Let  :math:`\Phi \in \CC^{M \times N}` 
    and  :math:`y \in \CC^M`.
    Then
    
    
    .. math::
        [\Phi^H y]_T = \Phi_T^H y.  
    



.. proof:: 

    
    
    .. math:: 
    
        \Phi^H y = 
        \begin{bmatrix}
        \langle \phi_1 , y \rangle\\
        \vdots \\
        \langle \phi_N , y \rangle\\
        \end{bmatrix}
    
    Now let 
    
    
    .. math:: 
    
        T = \{ t_1, \dots, t_K \}.
    
    Then
    
    
    .. math:: 
    
        [\Phi^H y]_T = 
        \begin{bmatrix}
        \langle \phi_{t_1} , y \rangle\\
        \vdots \\
        \langle \phi_{t_K} , y \rangle\\
        \end{bmatrix}
        = \Phi_T^H y.
    



.. remark:: 

    The lemma remains valid whether we use
    the restriction or the mask version of  :math:`\Phi_T` 
    notation.



 
Compressible signals
----------------------------------------------------


We will now define the notion of a compressible signal in terms of the decay rate
of magnitude of its entries when sorted in descending order.


.. index::  :math:`p`-compressible signal
.. _def:ssm:p_compressible_signal:

.. definition:: 

    Let  :math:`x \in \CC^N` be an arbitrary signal. 
    Let  :math:`\lambda_1, \dots, \lambda_N` be
    indices of entries in  :math:`x` such that
        
    .. math:: 
    
        | x_{\lambda_1} | \geq | x_{\lambda_2} | \geq \dots \geq | x_{\lambda_N} |.
    
    In case of ties, the order is resolved lexicographically, i.e. 
    if  :math:`|x_i| = |x_j|` 
    and  :math:`i < j` then  :math:`i` will appear first in the 
    sequence  :math:`\lambda_k`. Define
    
    
    .. math::
        :label: eq:x_sorted_in_magnitude_descending
    
        \widehat{x} = (x_{\lambda_1}, x_{\lambda_2}, \dots, x_{\lambda_N}).
    
    The signal  :math:`x` is called  :math:`p`-**compressible**  with magnitude  :math:`R` if there exists  :math:`p \in (0, 1]` such that
        
    .. math::
        :label: eq:p_compressible_signal_entry
    
        | \widehat{x}_i |\leq R \cdot i^{-\frac{1}{p}} \quad \forall i=1, 2,\dots, N.

.. _lem:ssm:compressible_p_1:

.. lemma:: 


    
    Let  :math:`x` be be  :math:`p`-compressible  with  :math:`p=1`. Then
    
    
    .. math::
        \| x \|_1 \leq R (1 + \ln (N)).
    



.. proof:: 

    Recalling  :math:`\widehat{x}` from 
    :eq:`eq:x_sorted_in_magnitude_descending` 
    it's straightforward to see that
    
    .. math:: 
    
        \|x\|_1 = \|\widehat{x}\|_1
    
    since the  :math:`l_1` norm doesn't depend on the ordering of entries in  :math:`x`.
    
    Now since  :math:`x` is  :math:`1`-compressible, hence from 
    :eq:`eq:p_compressible_signal_entry` we have
    
    .. math:: 
    
        |\widehat{x}_i | \leq R \frac{1}{i}.
    
    This gives us
    
    .. math:: 
    
        \|\widehat{x}\|_1  \leq \sum_{i=1}^N R \frac{1}{i} = R \sum_{i=1}^N \frac{1}{i}.
    
    The sum on the R.H.S. is the  :math:`N`-th Harmonic number (sum of reciprocals of first  :math:`N` natural numbers).
    A simple upper bound on Harmonic numbers is
    
    .. math:: 
    
        H_k \leq 1  + \ln(k).
    
    This completes the proof.


We now demonstrate how a compressible signal is well approximated by a sparse signal.

.. _lem:ssm:compressible_p_sparse_approximation:

.. lemma:: 


    
    Let  :math:`x` be a  :math:`p`-compressible signal and let  :math:`x|_K` be its best  :math:`K`-term approximation. 
    Then the  :math:`l_1` norm of approximation error satisfies 
    
    
    .. math::
        :label: eq:compressible_p_sparse_approximation_error_l1_norm
    
        \| x - x|_K\|_1 \leq C_p \cdot R \cdot K^{1 - \frac{1}{p}}
    
    with 
    
    
    .. math:: 
    
        C_p = \left (\frac{1}{p} - 1 \right)^{-1}.
    
    Moreover the  :math:`l_2` norm of approximation error satisfies
    
    
    .. math::
    
        \| x - x|_K\|_2 \leq D_p \cdot R \cdot K^{1 - \frac{1}{p}}
    
    with 
    
    
    .. math:: 
    
        D_p = \left (\frac{2}{p} - 1 \right )^{-1/2}.
    



.. proof:: 

    
    
    
    .. math:: 
    
        \| x - x|_K\|_1 = \sum_{i=K+1}^N |x_{\lambda_i}| 
        \leq R \sum_{i=K+1}^N i^{-\frac{1}{p}}.
    
    We now approximate the R.H.S. sum with an integral.
    
    
    .. math:: 
    
         \sum_{i=K+1}^N i^{-\frac{1}{p}} 
         \leq \int_{x=K}^N x^{-\frac{1}{p}} d x
         \leq  \int_{x=K}^{\infty} x^{-\frac{1}{p}} d x.
    
    
    Now
    
    
    .. math:: 
    
        \int_{x=K}^{\infty} x^{-\frac{1}{p}} d x = 
        \left [ \frac{x^{1-\frac{1}{p}}}{1-\frac{1}{p}} \right ]_{K}^{\infty}
        = C_p K^{1 - \frac{1}{p}}.
    
    We can similarly show the result for  :math:`l_2` norm.

