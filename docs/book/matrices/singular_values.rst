
 
Singular values
===================================================


In previous section we saw diagonalization of square matrices which resulted in an eigen value
decomposition of the matrix. This matrix factorization is very useful yet it is not applicable
in all situations. In particular, the eigen value decomposition is useless if the square matrix
is not diagonalizable or if the matrix is not square at all. Moreover, the decomposition
is particularly useful only for real symmetric or Hermitian matrices where the diagonalizing
matrix is an :math:`\FF`-unitary matrix (see :ref:`here <def:mat:f_unitary_matrix>`). Otherwise, one
has to consider the inverse of the diagonalizing matrix also.

Fortunately there happens to be another decomposition which applies to all matrices and
it involves just :math:`\FF`-unitary matrices.

.. index:: Singular value
.. index:: Left singular vector
.. index:: Right singular vector


.. _def:mat:singular_value:

.. definition:: 

    A non-negative real number :math:`\sigma` is a **singular value** for a matrix :math:`A \in \FF^{m \times n}` if and only if
    there exist unit-length vectors :math:`u \in \FF^m` and :math:`v \in \FF^n` such that
    
    
    .. math::
        A v = \sigma u 
    
    and
    
    
    .. math::
        A^H u = \sigma v
    
    hold.
    The vectors :math:`u` and :math:`v` are called **left-singular** and **right-singular** vectors for :math:`\sigma` respectively.



We first present the basic result of singular value decomposition. We will not prove this
result completely although we will present proofs of some aspects.

.. index:: Singular value

.. _thm:mat:singular_value_decomposition:

.. theorem:: 


    For every :math:`A \in \FF^{m \times n}` with :math:`k = \min(m , n)`, 
    there exist two :math:`\FF`-unitary matrices :math:`U \in \FF^{m \times m}`  
    and :math:`V \in \FF^{n \times n}` and a sequence of real numbers 
    
    
    .. math:: 
    
        \sigma_1 \geq \sigma_2 \geq \dots \geq \sigma_k \geq 0
    
    such that
    
    
    .. math::
        :label: eq:mat:svd:equation_form_1
    
        U^H A V = \Sigma 
    
    where 
    
    
    .. math:: 
    
        \Sigma = \Diag(\sigma_1, \sigma_2, \dots, \sigma_k) \in \FF^{ m \times n}.
    
    The non-negative real numbers :math:`\sigma_i` are the *singular values* of :math:`A` as per :ref:`here <def:mat:singular_value>`.
    
    The sequence of real numbers :math:`\sigma_i` doesn't depend on the particular choice of :math:`U` and :math:`V`.
    

:math:`\Sigma` is rectangular with the same size as :math:`A`. The singular values of :math:`A` lie
on the principle diagonal of :math:`\Sigma`. All other entries in :math:`\Sigma` are zero.

It is certainly possible that some of the singular values are 0 themselves. 


.. remark:: 

    Since :math:`U^H A V = \Sigma` hence
    
    
    .. math::
        :label: eq:mat:svd:equation_form_2
    
        A = U \Sigma V^H.
    


.. index:: Singular value decomposition


.. _def:mat:singular_value_decomposition:

.. definition:: 

    The decomposition of a matrix :math:`A \in \FF^{m \times n}` given by
    
    
    .. math::
        :label: eq:mat:singular_value_decomposition
    
        A = U \Sigma V^H
    
    is known as its **singular value decomposition**.





.. remark:: 

    When :math:`\FF` is :math:`\RR` then the decomposition simplifies to
    
    
    .. math::
        :label: eq:mat:svd:equation_form_3
    
        U^T A V = \Sigma 
    
    and
    
    
    .. math::
        A = U \Sigma V^T.
    




.. remark:: 

    Clearly there can be at most :math:`k= \min(m , n)` distinct singular values of :math:`A`.




.. remark:: 

    We can also write
    
    
    .. math::
        :label: eq:mat:svd:equation_form_4
    
        A V = U \Sigma.
    




.. remark:: 

    Let us expand 
    
    
    .. math:: 
    
        A = U \Sigma V^H
        = 
         \begin{bmatrix}
        u_1 & u_2 & \dots & u_m
        \end{bmatrix}
         \begin{bmatrix}
         \sigma_{ij}
        \end{bmatrix}
         \begin{bmatrix}
        v_1^H \\ v_2^H \\ \vdots \\ v_n^H
        \end{bmatrix}
        =  
        \sum_{i=1}^m \sum_{j=1}^n \sigma_{ij} u_i  v_j^H.
    




.. remark:: 

    Alternatively, let us expand 
    
    
    .. math:: 
    
        \Sigma = U^H AV  
        = 
         \begin{bmatrix}
        u_1^H \\ u_2^H \\ \vdots \\ u_m^H
        \end{bmatrix}
        A
        \begin{bmatrix}
        v_1 & v_2 & \dots & v_m
        \end{bmatrix}
        =  \begin{bmatrix} u_i^H A v_j \end{bmatrix}
    
    This gives us
    
    
    .. math::
        \sigma_{i j} = u_i^H A v_j.
    
    


Following lemma verifies that :math:`\Sigma` indeed consists of singular values of :math:`A` 
as per :ref:`here <def:mat:singular_value>`.


.. lemma:: 

    Let :math:`A = U \Sigma V^H` be a singular value decomposition of :math:`A`. Then the main
    diagonal entries of :math:`\Sigma` are singular values. The first :math:`k = \min(m, n)` column vectors in
    :math:`U` and :math:`V` are left and right singular vectors of :math:`A`.



.. proof:: 

    We have
    
    
    .. math:: 
    
        AV = U \Sigma.
    
    Let us expand R.H.S.
    
    
    .. math:: 
    
        U \Sigma = 
        \begin{bmatrix}\sum_{j=1}^m u_{i j} \sigma_{j k} \end{bmatrix}
        = [u_{i k} \sigma_k]
        = \begin{bmatrix}
        \sigma_1 u_1 & \sigma_2 u_2 & \dots \sigma_k u_k & 0 & \dots & 0
        \end{bmatrix}
    
    where :math:`0` columns in the end appear :math:`n - k` times.
    
    Expanding the L.H.S. we get
    
    
    .. math:: 
    
        A V  = \begin{bmatrix}
        A v_1 & A v_2 & \dots & A v_n
        \end{bmatrix}.
    
    Thus by comparing both sides we get
    
    
    .. math:: 
    
        A v_i = \sigma_i u_i \; \text{ for } \; 1 \leq i \leq k
    
    and 
    
    
    .. math:: 
    
        A v_i = 0 \text{ for } k < i \leq n.
    
    
    Now let us start with
    
    
    .. math:: 
    
        A = U \Sigma V^H \implies  A^H = V \Sigma^H U^H \implies  A^H U  = V \Sigma^H.
    
    
    Let us expand R.H.S.
    
    
    .. math:: 
    
        V \Sigma^H = 
        \begin{bmatrix}\sum_{j=1}^n v_{i j} \sigma_{j k} \end{bmatrix}
        = [v_{i k} \sigma_k]
        = \begin{bmatrix}
        \sigma_1 v_1 & \sigma_2 v_2 & \dots \sigma_k v_k & 0 & \dots & 0
        \end{bmatrix}
    
    where :math:`0` columns appear :math:`m - k` times.
    
    Expanding the L.H.S. we get
    
    
    .. math:: 
    
         A^H U   = \begin{bmatrix}
        A^H u_1 & A^H u_2 & \dots & A^H u_m
        \end{bmatrix}.
    
    Thus by comparing both sides we get
    
    
    .. math:: 
    
        A^H u_i = \sigma_i v_i \; \text{ for } \; 1 \leq i \leq k
    
    and 
    
    
    .. math:: 
    
        A^H u_i = 0 \text{ for } k < i \leq m.
    
    
    We now consider the three cases.
    
    For :math:`m = n`, we have :math:`k = m =n`.  And we get
    
    
    .. math:: 
    
        A v_i = \sigma_i u_i,  A^H u_i = \sigma_i v_i \; \text{ for } \; 1 \leq i \leq m
    
    Thus :math:`\sigma_i` is a singular value of :math:`A` and :math:`u_i` is a left singular vector while
    :math:`v_i` is a right singular vector.
    
    For :math:`m < n`, we have :math:`k = m`. We get for first :math:`m` vectors in :math:`V`
    
    
    .. math:: 
    
        A v_i = \sigma_i u_i,  A^H u_i = \sigma_i v_i \; \text{ for } \; 1 \leq i \leq m.
    
    Finally for remaining :math:`n-m` vectors in :math:`V`, we can write
    
    
    .. math:: 
    
        A v_i = 0.
    
    They belong to the null space of :math:`A`.
    
    For :math:`m > n`, we have :math:`k = n`. We get for first :math:`n` vectors in :math:`U`
    
    
    .. math:: 
    
        A v_i = \sigma_i u_i,  A^H u_i = \sigma_i v_i \; \text{ for } \; 1 \leq i \leq n.
    
    Finally for remaining :math:`m - n` vectors in :math:`U`, we can write
    
    
    .. math:: 
    
        A^H u_i = 0.
    




.. lemma:: 

    :math:`\Sigma \Sigma^H` is an :math:`m \times m` matrix given by
    
    
    .. math:: 
    
        \Sigma \Sigma^H =  \Diag(\sigma_1^2, \sigma_2^2, \dots \sigma_k^{2}, 0, 0,\dots 0)
    
    where the number of :math:`0`'s following :math:`\sigma_k^{2}` is :math:`m  - k`.




.. lemma:: 

    :math:`\Sigma^H \Sigma` is an :math:`n \times n` matrix given by
    
    
    .. math:: 
    
        \Sigma^H \Sigma =  \Diag(\sigma_1^2, \sigma_2^2, \dots \sigma_k^{2}, 0, 0,\dots 0)
    
    where the number of :math:`0`'s following :math:`\sigma_k^{2}` is :math:`n  - k`.






.. _lem:mat:singular:rank_svd:

.. lemma:: 


    Let :math:`A \in \FF^{m \times n}` have a singular value decomposition given by
    
    
    .. math:: 
    
        A = U \Sigma V^H.
    
    Then
    
    
    .. math::
        \Rank(A) = \Rank(\Sigma).
    
    In other words, rank of :math:`A` is number of non-zero singular values of :math:`A`.
    Since the singular values are ordered in descending order in :math:`A` hence, 
    the first :math:`r` singular values :math:`\sigma_1, \dots, \sigma_r` are non-zero.



.. proof:: 

    This is a straight forward application of :ref:`here <lem:mat:rank:full_rank_post_multiplier>`
    and :ref:`here <lem:mat:rank:full_rank_pre_multiplier>`. Further
    since only non-zero values in :math:`\Sigma` appear on its main diagonal hence its rank 
    is number of non-zero singular values :math:`\sigma_i`.




.. _cor:mat:singular:svd_block_matrix:

.. corollary:: 


    Let :math:`r = \Rank(A)`. Then :math:`\Sigma` can be split as a block matrix
    
    
    .. math::
        \Sigma = 
        \left [
        \begin{array}{c | c}
        \Sigma_r & 0\\
        \hline
        0 & 0
        \end{array}
        \right ]
    
    where :math:`\Sigma_r` is an :math:`r \times r` diagonal matrix of the non-zero singular values
    :math:`\Diag(\sigma_1, \sigma_2, \dots, \sigma_r)`. All other sub-matrices in :math:`\Sigma` are 0.




.. _lem:mat:singular:aH_a_eigen_values:

.. lemma:: 


    The eigen values of Hermitian matrix :math:`A^H A \in \FF^{n \times n}` are
    :math:`\sigma_1^2, \sigma_2^2, \dots \sigma_k^{2}, 0, 0,\dots 0` with :math:`n - k` :math:`0`'s after :math:`\sigma_k^{2}`.
    Moreover the eigen vectors are the columns of :math:`V`.



.. proof:: 

    
    
    .. math:: 
    
        A^H A = \left ( U \Sigma V^H \right)^H U \Sigma V^H  = V \Sigma^H U^H U \Sigma V^H = V \Sigma^H \Sigma V^H.
    
    We note that :math:`A^H A` is Hermitian. Hence :math:`A^HA` is diagonalized by :math:`V` and the diagonalization of :math:`A^H A`
    is :math:`\Sigma^H \Sigma`. Thus the eigen values of :math:`A^H A`  are :math:`\sigma_1^2, \sigma_2^2, \dots \sigma_k^{2}, 0, 0,\dots 0` with :math:`n - k` :math:`0`'s after :math:`\sigma_k^{2}`.
    
    Clearly
    
    
    .. math:: 
    
        (A^H A) V = V (\Sigma^H \Sigma)
    
    thus columns of :math:`V` are the eigen vectors of :math:`A^H A`.




.. _lem:mat:singular:a_aH_eigen_values:

.. lemma:: 


    The eigen values of Hermitian matrix :math:`A A^H \in \FF^{m \times m}` are
    :math:`\sigma_1^2, \sigma_2^2, \dots \sigma_k^{2}, 0, 0,\dots 0` with :math:`m - k` :math:`0`'s after :math:`\sigma_k^{2}`.
    Moreover the eigen vectors are the columns of :math:`V`.



.. proof:: 

    
    
    .. math:: 
    
        A A^H = U \Sigma V^H \left ( U \Sigma V^H \right)^H   = U \Sigma V^H V \Sigma^H U^H  = U \Sigma \Sigma^H U^H.
    
    We note that :math:`A^H A` is Hermitian. Hence :math:`A^HA` is diagonalized by :math:`V` and the diagonalization of :math:`A^H A`
    is :math:`\Sigma^H \Sigma`. Thus the eigen values of :math:`A^H A`  are :math:`\sigma_1^2, \sigma_2^2, \dots \sigma_k^{2}, 0, 0,\dots 0` with :math:`m - k` :math:`0`'s after :math:`\sigma_k^{2}`.
    
    Clearly
    
    
    .. math:: 
    
        (A A^H) U = U (\Sigma \Sigma^H)
    
    thus columns of :math:`U` are the eigen vectors of :math:`A A^H`.




.. lemma:: 

    The Gram matrices :math:`A A^H` and :math:`A^H A` share the same eigen values except for some extra zeros.
    Their eigen values are the squares of singular values of :math:`A` and some extra zeros.
    In other words singular values of :math:`A` are the square roots of non-zero eigen values of the Gram matrices
    :math:`A A^H` or :math:`A^H A`.



 
The largest singular value
----------------------------------------------------



.. _lem:mat:singular:largest_singular_value_norm_bound_sigma:

.. lemma:: 


    For all :math:`u \in \FF^n` the following holds
    
    
    .. math::
        \| \Sigma u \|_2 \leq  \sigma_1 \| u \|_2
    
    Moreover for all :math:`u \in \FF^m` the following holds
    
    
    .. math::
        \| \Sigma^H u \|_2 \leq  \sigma_1 \| u \|_2
    




.. proof:: 

    Let us expand the term :math:`\Sigma u`.
    
    
    .. math:: 
    
        \begin{bmatrix}
        \sigma_1 & 0 & \dots & \dots & 0 \\
        0 & \sigma_2 & \dots & \dots & 0 \\
        \vdots & \vdots & \ddots & \dots & 0\\
        0 & \vdots & \sigma_k & \dots & 0 \\
        0 & 0 & \vdots & \dots & 0
        \end{bmatrix}
        \begin{bmatrix}
        u_1 \\
        u_2 \\
        \vdots \\
        u_k \\
        \vdots \\
        u_n
        \end{bmatrix}
        = \begin{bmatrix}
        \sigma_1 u_1 \\
        \sigma_2 u_2 \\
        \vdots \\
        \sigma_k u_k \\
        0 \\
        \vdots \\
        0
        \end{bmatrix}
    
    
    Now since :math:`\sigma_1` is the largest singular value, hence
    
    
    .. math:: 
    
        |\sigma_r u_i| \leq |\sigma_1 u_i| \Forall 1 \leq i \leq k.
    
    Thus
    
    
    .. math:: 
    
        \sum_{i=1}^n |\sigma_1 u_i|^2  \geq \sum_{i=1}^n |\sigma_i u_i|^2
    
    or
    
    
    .. math:: 
    
        \sigma_1^2 \| u \|_2^2 \geq \| \Sigma u \|_2^2.
    
    The result follows. 
    
    A simpler representation of :math:`\Sigma u` can be given using :ref:`here <cor:mat:singular:svd_block_matrix>`.
    Let :math:`r = \Rank(A)`.  Thus
    
    
    .. math:: 
    
        \Sigma = 
        \left [
        \begin{array}{c | c}
        \Sigma_r & 0\\
        \hline
        0 & 0
        \end{array}
        \right ]
    
    
    We split entries in :math:`u` as :math:`u = [(u_1, \dots, u_r )( u_{r + 1} \dots u_n)]^T`.
    Then 
    
    
    .. math:: 
    
        \Sigma u = 
        \left [
        \begin{array}{c}
        \Sigma_r 
        \begin{bmatrix}
        u_1 &
        \dots&
        u_r
        \end{bmatrix}^T\\
        0 \begin{bmatrix}
        u_{r + 1} &
        \dots&
        u_n
        \end{bmatrix}^T
        \end{array}
        \right ]
        = 
        \begin{bmatrix}
        \sigma_1 u_1 & \sigma_2 u_2 & \dots & \sigma_r u_r & 0 & \dots & 0 
        \end{bmatrix}^T
     
    Thus 
    
    
    .. math:: 
    
        \| \Sigma u \|_2^2 = \sum_{i=1}^r |\sigma_i u_i |^2 \leq \sigma_1 \sum_{i=1}^r |u_i |^2 \leq \sigma_1 \|u\|_2^2.
    
    2nd result can also be proven similarly.



.. _lem:mat:singular:largest_singular_value_l2_norm_bound_A_A^H:

.. lemma:: 


    Let :math:`\sigma_1` be the largest singular value of an :math:`m \times n` matrix :math:`A`. Then
    
    
    .. math::
        \| A x \|_2 \leq \sigma_1 \| x \|_2 \Forall x \in \FF^n.
    
    Moreover
    
    
    .. math::
        \| A^H x \|_2 \leq \sigma_1 \| x \|_2 \Forall x \in \FF^m.
    




.. proof:: 

    
    
    .. math:: 
    
        \| A x \|_2 = \|  U \Sigma V^H x \|_2  = \| \Sigma V^H x \|_2
    
    since :math:`U` is unitary. Now from previous lemma we have 
    
    
    .. math:: 
    
        \| \Sigma V^H x \|_2 \leq  \sigma_1 \| V^H x \|_2 =  \sigma_1 \| x \|_2
    
    since :math:`V^H` also unitary. Thus we get the result
    
    
    .. math:: 
    
        \| A x \|_2  \leq \sigma_1 \| x \|_2 \Forall x \in \FF^n.
    
    
    Similarly
    
    
    .. math:: 
    
        \| A^H x \|_2 = \|  V \Sigma^H U^H  x \|_2  = \| \Sigma^H U^H x \|_2
    
    since :math:`V` is unitary. Now from previous lemma we have 
    
    
    .. math:: 
    
        \|  \Sigma^H U^H x \|_2 \leq  \sigma_1 \| U^H x \|_2 =  \sigma_1 \| x \|_2
    
    since :math:`U^H` also unitary. Thus we get the result
    
    
    .. math:: 
    
        \| A^H x \|_2  \leq \sigma_1 \| x \|_2 \Forall x \in \FF^m.
    
    


There is a direct connection between the largest singular value and :math:`2`-norm
of a matrix (see :ref:`here <sec:mat:p_norm>`).


.. corollary:: 

    The largest singular value of :math:`A` is nothing but its :math:`2`-norm. i.e.
    
    
    .. math:: 
    
        \sigma_1 = \underset{\|u \|_2 = 1}{\max} \| A u \|_2.
    



 
SVD and pseudo inverse
----------------------------------------------------



.. _lem:mat:singular:sigma_pseudo_inverse:

.. lemma:: 


    Let :math:`A = U \Sigma V^H` and let :math:`r  = \Rank (A)`. Let :math:`\sigma_1, \dots, \sigma_r` be
    the :math:`r` non-zero singular values of :math:`A`. Then the Moore-Penrose pseudo-inverse of
    :math:`\Sigma` is an :math:`n \times m` matrix :math:`\Sigma^{\dag}` given by
    
    
    .. math::
        \Sigma^{\dag} = 
        \left [
        \begin{array}{c | c}
        \Sigma_r^{-1} & 0\\
        \hline
        0 & 0
        \end{array}
        \right ]
    
    where :math:`\Sigma_r = \Diag(\sigma_1, \dots, \sigma_r)`.
    
    Essentially :math:`\Sigma^{\dag}` is obtained by transposing :math:`\Sigma` and inverting
    all its non-zero (positive real) values.



.. proof:: 

    Straight forward application of 
    :ref:`here <lem:mat:moore_penrose_rectangular_diagonal_pseudo_inverse>`.



.. _cor:mat:sigma_pseudo_inverse_rank:

.. corollary:: 


    The rank of :math:`\Sigma` and its pseudo-inverse :math:`\Sigma^{\dag}` are same. i.e.
    
    
    .. math::
        \Rank (\Sigma) = \Rank(\Sigma^{\dag}).
    



.. proof:: 

    The number of non-zero diagonal entries in :math:`\Sigma` and :math:`\Sigma^{\dag}` are same.






.. _lem:mat:singular:matrix_pseudo_inverse:

.. lemma:: 


    Let :math:`A` be an :math:`m \times n` matrix and let :math:`A = U \Sigma V^H` be its
    singular value decomposition. Let :math:`\Sigma^{\dag}` be the pseudo inverse
    of :math:`\Sigma` as per :ref:`here <lem:mat:singular:sigma_pseudo_inverse>`.
    Then the Moore-Penrose pseudo-inverse of :math:`A` is given by
    
    
    .. math::
        A^{\dag} = V \Sigma^{\dag} U^H.
    



.. proof:: 

    As usual we verify the requirements for a Moore-Penrose pseudo-inverse
    as per :ref:`here <def:mat:moore_penrose_pseudo_inverse>`. We note that
    since :math:`\Sigma^{\dag}` is the pseudo-inverse of :math:`\Sigma` it already 
    satisfies necessary criteria.
    
    First requirement:
    
    
    .. math:: 
    
        A A^{\dag} A = U \Sigma V^H  V \Sigma^{\dag} U^H U \Sigma V^H
        = U \Sigma \Sigma^{\dag} \Sigma V^H = U \Sigma V^H = A.
    
    Second requirement:
    
    
    .. math:: 
    
        A^{\dag} A A^{\dag} = V \Sigma^{\dag} U^H  U \Sigma V^H  V \Sigma^{\dag} U^H
        = V  \Sigma^{\dag} \Sigma \Sigma^{\dag} U^H = V \Sigma^{\dag} U^H = A^{\dag}.
    
    We now consider
    
    
    .. math:: 
    
        A A^{\dag} = U \Sigma V^H  V \Sigma^{\dag} U^H = U \Sigma \Sigma^{\dag} U^H.
    
    Thus
    
    
    .. math:: 
    
        \left ( A A^{\dag} \right )^H = \left ( U \Sigma \Sigma^{\dag} U^H \right )^H
        = U \left ( \Sigma \Sigma^{\dag} \right )^H U^H 
        = U \Sigma \Sigma^{\dag} U^H = A A^{\dag}
    
    since :math:`\Sigma \Sigma^{\dag}` is Hermitian.
    
    Finally we consider
    
    
    .. math:: 
    
        A^{\dag} A = V \Sigma^{\dag} U^H U \Sigma V^H  = V \Sigma^{\dag}  \Sigma V^H.
     
    Thus
    
    
    .. math:: 
    
        \left ( A^{\dag} A  \right )^H = \left ( V \Sigma^{\dag}  \Sigma V^H\right )^H 
        = V \left ( \Sigma^{\dag}  \Sigma \right )^H V^H 
        = V \Sigma^{\dag}  \Sigma V^H = A^{\dag} A
    
    since :math:`\Sigma^{\dag}  \Sigma` is also Hermitian.
    
    This completes the proof.


Finally we can connect the singular values of :math:`A` with the
singular values of its pseudo-inverse. 


.. _cor:mat:singular_matrix_pseudo_inverse_rank:

.. corollary:: 


    The rank of any :math:`m \times n` matrix :math:`A` and its pseudo-inverse :math:`A^{\dag}` are same. i.e.
    
    
    .. math::
        \Rank (A) = \Rank(A^{\dag}).
    



.. proof:: 

    We have :math:`\Rank(A) = \Rank(\Sigma)`. 
    Also its easy to verify that :math:`\Rank(A^{\dag}) = \Rank(\Sigma^{\dag})`.
    So using :ref:`here <cor:mat:sigma_pseudo_inverse_rank>` completes the proof.



.. _lem:mat:singular_pseudo_inverse_singular_values:

.. lemma:: 


    Let :math:`A` be an :math:`m \times n` matrix and let :math:`A^{\dag}`  be its :math:`n \times m` 
    pseudo inverse as per :ref:`here <lem:mat:singular:matrix_pseudo_inverse>`. 
    Let :math:`r = \Rank(A)` Let :math:`k = \min(m, n)` denote the number of singular values
    while :math:`r` denote the number of non-singular values of :math:`A`. Let 
    :math:`\sigma_1, \dots, \sigma_r` be the non-zero singular values of :math:`A`.
    Then the number of singular values of :math:`A^{\dag}` is same as that
    of :math:`A` and the non-zero singular values of :math:`A^{\dag}` are 
    
    
    .. math:: 
    
        \frac{1}{\sigma_1} , \dots, \frac{1}{\sigma_r}
    
    while all other :math:`k - r` singular values of :math:`A^{\dag}` are zero.



.. proof:: 

    :math:`k= \min(m, n)` denotes the number of singular values for both  :math:`A` and  :math:`A^{\dag}`.
    Since rank of :math:`A` and  :math:`A^{\dag}`  are same, hence the number of 
    non-zero singular values
    is same. Now look at 
    
    
    .. math:: 
    
         A^{\dag}  = V \Sigma^{\dag} U^H
    
    where
    
    
    .. math:: 
    
        \Sigma^{\dag} = 
        \left [
        \begin{array}{c | c}
        \Sigma_r^{-1} & 0\\
        \hline
        0 & 0
        \end{array}
        \right ].
    
    Clearly :math:`\Sigma_r^{-1} = \Diag(\frac{1}{\sigma_1} , \dots, \frac{1}{\sigma_r})`.
    
    Thus expanding the R.H.S. we can get
    
    
    .. math:: 
    
         A^{\dag} = \sum_{i=1}^r \frac{1}{\sigma_{i}} v_i  u_i^H
    
    where :math:`v_i` and :math:`u_i` are first :math:`r` columns of :math:`V` and :math:`U` respectively.
    If we reverse the order of first :math:`r` columns of :math:`U` and :math:`V` and reverse
    the first :math:`r` diagonal entries of :math:`\Sigma^{\dag}`
    , the R.H.S. remains the same while we are able to express :math:`A^{\dag}` in 
    the standard singular value decomposition form. Thus
    :math:`\frac{1}{\sigma_1} , \dots, \frac{1}{\sigma_r}` are indeed
    the non-zero singular values of :math:`A^{\dag}`.



.. _sec:mat:sngular:full_column_rank_matrices:
 
Full column rank matrices
----------------------------------------------------

In this subsection we consider some specific results related to 
singular value decomposition of a full column rank matrix. 

We will consider :math:`A` to be an :math:`m \times n` matrix 
in :math:`\FF^{m \times n}` with :math:`m \geq n` 
and  :math:`\Rank(A) = n`. 
Let :math:`A = U \Sigma V^H` be its singular value decomposition. 
From :ref:`here <lem:mat:singular:rank_svd>` we observe that
there are :math:`n` non-zero singular values of :math:`A`.
We will call these singular values as :math:`\sigma_1, \sigma_2, \dots, \sigma_n`. 
We will define 


.. math:: 

    \Sigma_n = \Diag(\sigma_1, \sigma_2, \dots, \sigma_n).

Clearly :math:`\Sigma` is an :math:`2\times 1` block matrix given by


.. math:: 

    \Sigma = 
    \left [
    \begin{array}{c}
    \Sigma_n\\
    \hline
    0
    \end{array}
    \right ]

where the lower :math:`0` is an :math:`(m - n) \times n` zero matrix.
From here we obtain that :math:`\Sigma^H \Sigma` is an :math:`n \times n` matrix given by


.. math:: 

    \Sigma^H \Sigma = \Sigma_n^2

where


.. math:: 

    \Sigma_n^2 = \Diag(\sigma_1^2, \sigma_2^2, \dots, \sigma_n^2).



.. _lem:mat:singular:full_column_rank_sigma_h_sigma_invertible:

.. lemma:: 


    Let :math:`A` be a full column rank matrix with singular value decomposition :math:`A = U \Sigma V^H`.
    Then :math:`\Sigma^H \Sigma = \Sigma_n^2 = \Diag(\sigma_1^2, \sigma_2^2, \dots, \sigma_n^2)` and
    :math:`\Sigma^H \Sigma` is invertible.



.. proof:: 

    Since all singular values are non-zero hence :math:`\Sigma_n^2` is invertible. Thus
    
    
    .. math::
        \left (\Sigma^H \Sigma \right )^{-1} = \left ( \Sigma_n^2  \right )^{-1} = 
        \Diag\left(\frac{1}{\sigma_1^2}, \frac{1}{\sigma_2^2}, \dots, \frac{1}{\sigma_n^2} \right).
    




.. lemma:: 

    Let :math:`A` be a full column rank matrix with singular value decomposition :math:`A = U \Sigma V^H`. 
    Let :math:`\sigma_1` be its largest singular value and :math:`\sigma_n` be its smallest singular value.
    Then
    
    
    .. math::
        \sigma_n^2 \|x \|_2 \leq \| \Sigma^H \Sigma x \|_2 \leq \sigma_1^2 \|x \|_2  \Forall x \in \FF^n.
    



.. proof:: 

    Let :math:`x \in \FF^n`.
    We have
    
    
    .. math:: 
    
         \| \Sigma^H \Sigma x \|_2^2 = \| \Sigma_n^2 x \|_2^2 = \sum_{i=1}^n |\sigma_i^2 x_i|^2.
    
    Now since 
    
    
    .. math:: 
    
        \sigma_n \leq \sigma_i \leq \sigma_1
    
    hence
    
    
    .. math:: 
    
        \sigma_n^4  \sum_{i=1}^n |x_i|^2 \leq \sum_{i=1}^n |\sigma_i^2 x_i|^2 \leq \sigma_1^4 \sum_{i=1}^n |x_i|^2 
    
    thus
    
    
    .. math:: 
    
        \sigma_n^4 \| x \|_2^2 \leq  \| \Sigma^H \Sigma x \|_2^2 \leq \sigma_1^4 \| x \|_2^2.
    
    Applying square roots, we get
    
    
    .. math:: 
    
        \sigma_n^2 \| x \|_2 \leq  \| \Sigma^H \Sigma x \|_2 \leq \sigma_1^2 \| x \|_2  \Forall x \in \FF^n.
    




We recall from :ref:`here <cor:mat:gram_full_column_rank_invertible>`
that the Gram matrix of its column vectors :math:`G = A^HA` is
full rank and invertible.

.. _lem:mat:singular:full_column_rank_gram_embedding_l2_norm_bound:

.. lemma:: 


    Let :math:`A` be a full column rank matrix with singular value decomposition :math:`A = U \Sigma V^H`. 
    Let :math:`\sigma_1` be its largest singular value and :math:`\sigma_n` be its smallest singular value.
    Then
    
    
    .. math::
        \sigma_n^2 \|x \|_2 \leq \| A^H A x \|_2 \leq \sigma_1^2 \|x \|_2  \Forall x \in \FF^n.
    



.. proof:: 

    
    
    .. math:: 
    
        A^H A = (U \Sigma V^H)^H (U \Sigma V^H) = V \Sigma^H \Sigma V^H. 
    
    Let :math:`x \in \FF^n`. Let
    
    
    .. math:: 
    
        u = V^H x  \implies \| u \|_2 = \|x \|_2.
    
    Let 
    
    
    .. math:: 
    
        r = \Sigma^H \Sigma u.
    
    Then from previous lemma we have
    
    
    .. math:: 
    
        \sigma_n^2 \| u \|_2 \leq  \| \Sigma^H \Sigma u \|_2 = \|r \|_2 \leq \sigma_1^2 \| u \|_2 .
    
    Finally
    
    
    .. math:: 
    
        A^ H A x = V \Sigma^H \Sigma V^H x = V r.
    
    Thus
    
    
    .. math:: 
    
        \| A^ H A x \|_2  = \|r \|_2.
    
    Substituting we get
    
    
    .. math:: 
    
        \sigma_n^2 \|x \|_2 \leq \| A^H A x \|_2 \leq \sigma_1^2 \|x \|_2  \Forall x \in \FF^n.
    


There are bounds for the inverse of Gram matrix also. First let us establish the inverse of Gram matrix.

.. _lem:mat:singular:full_column_rank_inverse_gram_matrix:

.. lemma:: 


    Let :math:`A` be a full column rank matrix with singular value decomposition :math:`A = U \Sigma V^H`. 
    Let the singular values of :math:`A` be :math:`\sigma_1, \dots, \sigma_n`. Let the Gram matrix
    of columns of :math:`A` be :math:`G = A^H A`. Then 
    
    
    .. math:: 
    
        G^{-1} = V \Psi V^H
    
    where
    
    
    .. math:: 
    
        \Psi = \Diag \left(\frac{1}{\sigma_1^2}, \frac{1}{\sigma_2^2}, \dots, \frac{1}{\sigma_n^2} \right).
    



.. proof:: 

    We have 
    
    
    .. math:: 
    
        G = V \Sigma^H \Sigma V^H
    
    Thus
    
    
    .. math:: 
    
        G^{-1} = \left (V \Sigma^H \Sigma V^H \right )^{-1} = \left ( V^H \right )^{-1} \left ( \Sigma^H \Sigma \right )^{-1} V^{-1} 
        = V  \left ( \Sigma^H \Sigma \right )^{-1}  V^H.
    
    From :ref:`here <lem:mat:singular:full_column_rank_sigma_h_sigma_invertible>` we have
    
    
    .. math:: 
    
        \Psi = \left ( \Sigma^H \Sigma \right )^{-1} = \Diag \left (\frac{1}{\sigma_1^2}, \frac{1}{\sigma_2^2}, \dots, \frac{1}{\sigma_n^2} \right).
    
    This completes the proof.


We can now state the bounds:


.. _lem:mat:singular:full_column_rank_inverse_gram_embedding_l2_norm_bound:

.. lemma:: 


    Let :math:`A` be a full column rank matrix with singular value decomposition :math:`A = U \Sigma V^H`. 
    Let :math:`\sigma_1` be its largest singular value and :math:`\sigma_n` be its smallest singular value.
    Then
    
    
    .. math::
        \frac{1}{\sigma_1^2} \|x \|_2 \leq \| \left(A^H A \right)^{-1} x \|_2 \leq \frac{1}{\sigma_n^2} \|x \|_2  \Forall x \in \FF^n.
    



.. proof:: 

    From :ref:`here <lem:mat:singular:full_column_rank_inverse_gram_matrix>` we have
    
    
    .. math:: 
    
        G^{-1} = \left ( A^H A \right)^{-1} = V \Psi V^H
    
    where
    
    
    .. math:: 
    
        \Psi = \Diag \left(\frac{1}{\sigma_1^2}, \frac{1}{\sigma_2^2}, \dots, \frac{1}{\sigma_n^2} \right).
    
    Let :math:`x \in \FF^n`. Let
    
    
    .. math:: 
    
        u = V^H x  \implies \| u \|_2 = \|x \|_2.
    
    Let 
    
    
    .. math:: 
    
        r = \Psi u.
    
    Then 
    
    
    .. math:: 
    
        \| r \|_2^2 = \sum_{i=1}^n \left | \frac{1}{\sigma_i^2} u_i \right |^2.
    
    Thus
    
    
    .. math:: 
    
        \frac{1}{\sigma_1^2} \| u \|_2 \leq  \| \Psi u \|_2 = \|r \|_2 \leq \frac{1}{\sigma_n^2} \| u \|_2 .
    
    Finally
    
    
    .. math:: 
    
        \left (A^ H A \right)^{-1} x = V \Psi V^H x = V r.
    
    Thus
    
    
    .. math:: 
    
        \| \left (A^ H A \right)^{-1} x \|_2  = \|r \|_2.
    
    Substituting we get the result.



.. _sec:mat:low_rank_approximation:
 
Low rank approximation of a matrix
----------------------------------------------------

.. index:: Low rank approximation
.. index:: Low rank matrix

.. _def:mat:low_rank_matrix:

.. definition:: 

    An :math:`m \times n` matrix :math:`A` is called low rank if 
    
    
    .. math::
        \Rank(A) \ll \min (m, n).
    




.. remark:: 

    A matrix is low rank if the number of non-zero singular values for the matrix is much smaller
    than its dimensions.


Following is a simple procedure for making a low rank approximation of a given matrix :math:`A`.

#. Perform the singular value decomposition of :math:`A` given by 
   :math:`A = U \Sigma V^H`.
#. Identify the singular values of :math:`A` in :math:`\Sigma`.
#. Keep the first :math:`r` singular values (where :math:`r \ll \min(m, n)` 
   is the rank of the approximation)
   and set all other singular values to 0 to obtain :math:`\widehat{\Sigma}`.
#. Compute :math:`\widehat{A} = U \widehat{\Sigma} V^H`.

