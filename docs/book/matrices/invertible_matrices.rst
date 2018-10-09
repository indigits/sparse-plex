
 
Invertible matrices
===================================================


.. index:: Invertible matrix
.. index:: Inverse of a matrix


.. _def:mat:invertible:

.. definition:: 

    A square matrix :math:`A` is called **invertible** if there exists another square matrix :math:`B` of same size such that
    
    
    .. math:: 
    
        AB = BA = I.
    
    The matrix :math:`B` is called the **inverse** of :math:`A` and is denoted as :math:`A^{-1}`.



.. _lem:mat:inverse_of_invertible_matrix:

.. lemma:: 

    If :math:`A` is invertible then its inverse :math:`A^{-1}` is also invertible and 
    the inverse of :math:`A^{-1}` is nothing but :math:`A`.




.. _lem:mat:invertible_identity:

.. lemma:: 

    Identity matrix :math:`I` is invertible.




.. proof:: 

    
    
    .. math:: 
    
        I I = I \implies I^{-1} = I.
    



.. _lem:mat:invertible_linear_independence:

.. lemma:: 


    If :math:`A` is invertible then columns of :math:`A` are linearly independent.



.. proof:: 

    Assume :math:`A` is invertible, then there exists a matrix :math:`B` such that
    
    
    .. math:: 
    
        AB = BA = I.
    
    Assume that columns of :math:`A` are linearly dependent. Then there exists :math:`u \neq 0` such that
    
    
    .. math:: 
    
        A u = 0 \implies BA u = 0 \implies  I u = 0 \implies u = 0
    
    a contradiction. Hence columns of :math:`A` are linearly independent.



.. _lem:invertible_spanning:

.. lemma:: 

    If an :math:`n\times n` matrix  :math:`A` is invertible then columns of :math:`A` span :math:`\FF^n`.




.. proof:: 

    Assume :math:`A` is invertible, then there exists a matrix :math:`B` such that
    
    
    .. math:: 
    
        AB = BA = I.
    
    Now let :math:`x \in \FF^n` be any arbitrary vector. We need to show that there exists :math:`\alpha \in \FF^n` such that
    
    
    .. math:: 
    
        x = A \alpha.
    
    But
    
    
    .. math:: 
    
        x = I x = AB x = A ( B x).
    
    Thus if we choose :math:`\alpha = Bx`, then
    
    
    .. math:: 
    
        x = A \alpha.
    
    Thus columns of :math:`A` span :math:`\FF^n`.



.. _lem:mat:invertible_basis:

.. lemma:: 


    If :math:`A` is invertible, then columns of :math:`A` form a basis for :math:`\FF^n`.



.. proof:: 

    In :math:`\FF^n` a basis is a set of vectors which is linearly independent and spans :math:`\FF^n`. By
    :ref:`here <lem:mat:invertible_linear_independence>` and
    :ref:`here <lem:invertible_spanning>`, columns of an invertible matrix :math:`A` satisfy both conditions.
    Hence they form a basis.



.. _lem:mat:invertible_transpose:

.. lemma:: 

    If :math:`A` is invertible, then :math:`A^T` is invertible.




.. proof:: 

    Assume :math:`A` is invertible, then there exists a matrix :math:`B` such that
    
    
    .. math:: 
    
        AB = BA = I.
    
    Applying transpose on both sides we get
    
    
    .. math:: 
    
        B^T A^T = A^T B^T = I.
    
    Thus :math:`B^T` is inverse of :math:`A^T` and :math:`A^T` is invertible.



.. _lem:mat:invertible_conjugate_transpose:

.. lemma:: 

    If :math:`A` is invertible than :math:`A^H` is invertible.




.. proof:: 

    Assume :math:`A` is invertible, then there exists a matrix :math:`B` such that
    
    
    .. math:: 
    
        AB = BA = I.
    
    Applying conjugate transpose on both sides we get
    
    
    .. math:: 
    
        B^H A^H = A^H B^H = I.
    
    Thus :math:`B^H` is inverse of :math:`A^H` and :math:`A^H` is invertible.




.. _lem:mat:invertible_product:

.. lemma:: 

    If :math:`A` and :math:`B` are invertible then :math:`AB` is invertible.




.. proof:: 

    We note that 
    
    
    .. math:: 
    
        (AB) (B^{-1}A^{-1}) =  A (B B^{-1})A^{-1} = A I A^{-1} = I.
    
    Similarly
    
    
    .. math:: 
    
        (B^{-1}A^{-1}) (AB)  = B^{-1} (A^{-1} A ) B = B^{-1} I B = I.
    
    Thus :math:`B^{-1}A^{-1}` is the inverse of :math:`AB`.



.. _lem:mat:invertible_group:

.. lemma:: 

    The set of :math:`n \times n` invertible matrices under the matrix multiplication operation form a group.




.. proof:: 

    We verify the properties of a group
    
    * [Closure]  If :math:`A` and :math:`B` are invertible then :math:`AB` is invertible. Hence the set is closed.
    *  [Associativity] Matrix multiplication is associative.
    *  [Identity element] :math:`I` is invertible and :math:`AI = IA = A` for all invertible matrices.
    *  [Inverse element] If :math:`A` is invertible then :math:`A^{-1}` is also invertible. 
    
    Thus the set of invertible matrices is indeed a group under matrix multiplication.



.. _lem:mat:invertible_rank:

.. lemma:: 

    An :math:`n \times n` matrix :math:`A` is invertible if and only if it is full rank i.e.
    
    
    .. math:: 
    
        \Rank(A) = n.
    





.. corollary:: 

    The rank of an invertible matrix  and its inverse are same.






 
Similar matrices
----------------------------------------------------



.. index:: Similar matrices


.. _def:mat:similar_matrix:

.. definition:: 

    An :math:`n \times n` matrix :math:`B` is **similar** to an :math:`n \times n` matrix :math:`A` if there
    exists an :math:`n \times n` non-singular matrix :math:`C` such that
    
    
    .. math:: 
    
        B  = C^{-1} A C.
    




.. lemma:: 

    If :math:`B` is similar to :math:`A` then :math:`A` is similar to :math:`B`. Thus similarity is a symmetric relation.



.. proof:: 

    
    
    .. math:: 
    
        B  = C^{-1} A C \implies A = C B C^{-1} \implies A = (C^{-1})^{-1} B C^{-1}
    
    Thus there exists a matrix :math:`D = C^{-1}` such that
    
    
    .. math:: 
    
        A = D^{-1} B D.
    
    Thus :math:`A` is similar to :math:`B`.



.. _lem:mat:similar_matrix_rank:

.. lemma:: 


    Similar matrices have same rank.




.. proof:: 

    Let :math:`B` be similar to :math:`A`. Thus their exists an invertible matrix :math:`C` such that
    
    
    .. math:: 
    
        B  = C^{-1} A C.
    
    Since :math:`C` is invertible hence we have :math:`\Rank (C) = \Rank(C^{-1}) = n`.
    Now using :ref:`here <lem:mat:rank:full_rank_post_multiplier>` :math:`\Rank (AC) = \Rank (A)`
    and using :ref:`here <lem:mat:rank:full_rank_pre_multiplier>` we have :math:`\Rank(C^{-1} (AC) ) = \Rank (AC) = \Rank(A)`.
    Thus
    
    
    .. math:: 
    
        \Rank(B)  = \Rank(A).
    




.. lemma:: 

    Similarity is an equivalence relation on the set of :math:`n \times n` matrices.




.. proof:: 

    Let :math:`A, B, C` be :math:`n \times n` matrices. :math:`A` is similar to itself through an invertible matrix :math:`I`.
    If :math:`A` is similar to :math:`B` then :math:`B` is similar to :math:`A`. If :math:`B` is similar to :math:`A` via :math:`P` s.t.
    :math:`B = P^{-1}AP` and :math:`C` is similar to :math:`B` via :math:`Q` s.t. :math:`C = Q^{-1} B Q` then
    :math:`C` is similar to :math:`A` via :math:`PQ` such that :math:`C = (PQ)^{-1} A (P Q)`. Thus
    similarity is an equivalence relation on the set of square matrices and if :math:`A` is any
    :math:`n \times n` matrix then the set
    of :math:`n \times n` matrices similar to :math:`A` forms an equivalence class. 


.. _sec:mat:gram_matrix:

 
Gram matrices
----------------------------------------------------

.. index:: Gram matrix of columns of a matrix

.. _def:mat:columns_gram_matrix:

.. definition:: 

    **Gram matrix** of columns of :math:`A` is given by
    
    
    .. math::
        G = A^H A
    


.. index:: Gram matrix of rows of a matrix
.. index:: Frame operator


.. _def:mat:rows_gram_matrix:

.. definition:: 

    **Gram matrix** of rows of :math:`A` is given by
    
    
    .. math::
        G = A A^H
    

    This is also known as the **frame operator** of :math:`A`.



.. remark:: 

    Usually when we talk about Gram matrix of a matrix we are looking at the
    Gram matrix of its column vectors.




.. remark:: 

    For real matrix :math:`A \in \RR^{m \times n}`, the Gram matrix of its column
    vectors is given by :math:`A^T A` and the Gram matrix for its row vectors
    is given by :math:`A A^T`. 

Following results apply equally well for the real case.


.. _lem:mat:gram_dependent_columns:

.. lemma:: 


    The columns of a matrix are linearly dependent if and only if 
    the Gram matrix of its column vectors :math:`A^H A` is not invertible.



.. proof:: 

    Let :math:`A` be an :math:`m\times n` matrix and :math:`G = A^H A` be the Gram matrix of its columns.
    
    If columns of :math:`A` are linearly dependent, then there exists a vector :math:`u \neq 0` such that
    
    
    .. math:: 
    
        A u = 0.
    
    Thus
    
    
    .. math:: 
    
        G u = A^H A u  = 0.
    
    Hence the columns of :math:`G` are also dependent and :math:`G` is not invertible.
    
    Conversely let us assume that :math:`G` is not invertible, thus columns of :math:`G` are dependent
    and there exists a vector :math:`v \neq 0` such that 
    
    
    .. math:: 
    
        G v = 0.
    
    Now 
    
    
    .. math:: 
    
        v^H G v =  v^H A^H A v = (A v)^H (A v) = \| A v \|_2^2.
    
    From previous equation, we have
    
    
    .. math:: 
    
         \| A v \|_2^2 = 0 \implies A v = 0.
    
    Since :math:`v \neq 0` hence columns of :math:`A` are also linearly dependent. 




.. _cor:mat:gram_independent_columns:

.. corollary:: 


    The columns of a matrix are linearly independent if and only if 
    the Gram matrix of its column vectors :math:`A^H A` is invertible.




.. proof:: 

    Columns of :math:`A` can be  dependent only if its Gram matrix is not invertible. Thus if
    the Gram matrix is invertible, then the columns of :math:`A` are linearly independent. 
    
    The Gram matrix is not invertible only if columns of :math:`A` are linearly dependent. 
    Thus if columns of :math:`A` are linearly independent then the Gram matrix is invertible.



.. _cor:mat:gram_full_column_rank_invertible:

.. corollary:: 


    Let :math:`A` be a full column rank matrix. Then :math:`A^H A` is invertible.




.. _lem:mat:column_gram_matrix_null_space:

.. lemma:: 


    The null space of :math:`A` and its Gram matrix :math:`A^HA` coincide. i.e.
    
    
    .. math::
        \NullSpace(A) = \NullSpace(A^H A).
    



.. proof:: 

    Let :math:`u \in \NullSpace(A)`. Then 
    
    
    .. math:: 
    
        A u  = 0 \implies A^H A u = 0.
    
    Thus
    
    
    .. math:: 
    
        u \in \NullSpace(A^HA ) \implies \NullSpace(A) \subseteq \NullSpace(A^H A).
    
    
    Now let :math:`u \in  \NullSpace(A^H A)`. Then
    
    
    .. math:: 
    
        A^H A u = 0 \implies u^H A^H A u = 0 \implies \| A u \|_2^2  = 0 \implies A u = 0.
    
    Thus we have
    
    
    .. math:: 
    
        u \in \NullSpace(A ) \implies \NullSpace(A^H A) \subseteq \NullSpace(A).
    






.. _lem:mat:gram_dependent_rows:

.. lemma:: 


    The rows of a matrix :math:`A` are linearly dependent if and only if the Gram matrix of its
    row vectors :math:`AA^H` is not invertible.



.. proof:: 

    Rows of :math:`A` are linearly dependent, if and only if columns of :math:`A^H` are linearly dependent. 
    There exists a vector :math:`v \neq 0` s.t.
    
    
    .. math:: 
    
        A^H v = 0
    
    Thus
    
    
    .. math:: 
    
        G v = A A^H v = 0.
    
    Since :math:`v \neq 0` hence :math:`G` is not invertible.
    
    Converse: assuming that :math:`G` is not invertible, there exists a vector :math:`u \neq 0` s.t.
    
    
    .. math:: 
    
        G u = 0.
    
    Now
    
    
    .. math:: 
    
        u^H G u = u^H A A^H u = (A^H u)^H (A^H u) = \| A^H u \|_2^2 = 0 \implies A^H u =  0.
    
    Since :math:`u \neq 0` hence columns of :math:`A^H` and consequently rows of :math:`A` are linearly dependent.



.. _cor:mat:gram_independent_rows:

.. corollary:: 


    The rows of a matrix :math:`A` are linearly independent if and only if the Gram matrix of its
    row vectors :math:`AA^H` is invertible.


.. _cor:mat:gram_full_row_rank_invertible:

.. corollary:: 


    Let :math:`A` be a full row rank matrix. Then :math:`A A^H` is invertible.



 
Pseudo inverses
----------------------------------------------------


.. index:: Moore-Penrose pseudo-inverse


.. _def:mat:moore_penrose_pseudo_inverse:

.. definition:: 

    Let :math:`A` be an :math:`m \times n` matrix. An  :math:`n\times m` matrix :math:`A^{\dag}` is called its
    Moore-Penrose pseudo-inverse if it satisfies all of the following criteria:
    
    *  :math:`A A^{\dag} A = A`.
    *  :math:`A^{\dag} A A^{\dag} = A^{\dag}`.
    *  :math:`\left(A A^{\dag} \right)^H = A A^{\dag}` i.e. :math:`A A^{\dag}` is Hermitian.
    *  :math:`(A^{\dag} A)^H = A^{\dag} A` i.e. :math:`A^{\dag} A` is Hermitian.
    



.. _thm:mat:existence_uniqueness_moore_penrose_pseudo_inverse:

.. theorem:: 


    For any matrix :math:`A` there exists precisely one matrix :math:`A^{\dag}` which satisfies all the requirements above.


We omit the proof for this. The pseudo-inverse can actually be obtained by the
singular value decomposition of :math:`A`. This is shown :ref:`here <lem:mat:singular:matrix_pseudo_inverse>`.


.. _lem:mat:moore_penrose_square_diagonal_pseudo_inverse:

.. lemma:: 


    Let :math:`D = \Diag(d_1, d_2, \dots, d_n)` be an :math:`n \times n` diagonal matrix. Then
    its Moore-Penrose pseudo-inverse is 
    :math:`D^{\dag} = \Diag(c_1, c_2, \dots, c_n)` where
    
    
    .. math:: 
    
        c_i = \left\{
                \begin{array}{ll}
                    \frac{1}{d_i} & \mbox{if $d_i \neq 0$};\\
                    0 & \mbox{if $d_i = 0$}.
                \end{array}
              \right.
    



.. proof:: 

    We note that :math:`D^{\dag} D = D D^{\dag} = F = \Diag(f_1, f_2, \dots f_n)` where 
    
    
    .. math:: 
    
        f_i = \left\{
                \begin{array}{ll}
                    1 & \mbox{if $d_i \neq 0$};\\
                    0 & \mbox{if $d_i = 0$}.
                \end{array}
              \right.
    
    We now verify the requirements listed :ref:`here <def:mat:moore_penrose_pseudo_inverse>`.
    
    
    .. math:: 
    
        D D^{\dag} D = F D = D.
    
    
    
    .. math:: 
    
        D^{\dag} D D^{\dag} = F D^{\dag} = D^{\dag}
    
    :math:`D^{\dag} D = D D^{\dag} = F` is a diagonal hence Hermitian matrix.




.. _lem:mat:moore_penrose_rectangular_diagonal_pseudo_inverse:

.. lemma:: 


    Let :math:`D = \Diag(d_1, d_2, \dots, d_p)` be an :math:`m \times n` *rectangular* diagonal matrix
    where :math:`p = \min(m, n)`.
    Then
    its Moore-Penrose pseudo-inverse is an :math:`n \times m` rectangular diagonal matrix
    :math:`D^{\dag} = \Diag(c_1, c_2, \dots, c_p)` where
    
    
    .. math:: 
    
        c_i = \left\{
                \begin{array}{ll}
                    \frac{1}{d_i} & \mbox{if $d_i \neq 0$};\\
                    0 & \mbox{if $d_i = 0$}.
                \end{array}
              \right.
    



.. proof:: 

    :math:`F = D^{\dag} D = \Diag(f_1, f_2, \dots f_n)` is an :math:`n \times n` matrix where
    
    
    .. math:: 
    
        f_i = \left\{
                \begin{array}{ll}
                    1 & \mbox{if $d_i \neq 0$};\\
                    0 & \mbox{if $d_i = 0$};\\
                    0 & \mbox{if $i > p$}.
                \end{array}
              \right.
    
    :math:`G = D D^{\dag} = \Diag(g_1, g_2, \dots g_n)` is an :math:`m \times m` matrix where
    
    
    .. math:: 
    
        g_i = \left\{
                \begin{array}{ll}
                    1 & \mbox{if $d_i \neq 0$};\\
                    0 & \mbox{if $d_i = 0$};\\
                    0 & \mbox{if $i > p$}.
                \end{array}
              \right.
    
    
    We now verify the requirements listed :ref:`here <def:mat:moore_penrose_pseudo_inverse>`.
    
    
    .. math:: 
    
        D D^{\dag} D = D F = D.
    
    
    
    .. math:: 
    
        D^{\dag} D D^{\dag} = D^{\dag} G = D^{\dag}
    
    :math:`F = D^{\dag} D` and :math:`G = D D^{\dag}` are both diagonal hence Hermitian matrices.





.. _lem:mat:moore_penrose_left_pseudo_inverse:

.. lemma:: 


    If :math:`A` is full column rank then its Moore-Penrose pseudo-inverse is given by
    
    
    .. math::
        A^{\dag} = (A^H A)^{-1} A^H. 
    
    It is a left inverse of :math:`A`.




.. proof:: 

    By :ref:`here <cor:mat:gram_full_column_rank_invertible>` :math:`A^H A` is invertible.
    
    
    First of all we verify that it is a left inverse.
    
    
    .. math:: 
    
        A^{\dag} A = (A^H A)^{-1} A^H A = I.
    
    We now verify all the properties.
    
    
    .. math:: 
    
        A A^{\dag} A  = A I = A.
    
    
    
    .. math:: 
    
        A^{\dag} A A^{\dag}   = I A^{\dag} = A^{\dag}.
    
    Hermitian properties:
    
    
    .. math:: 
    
        \left(A A^{\dag} \right)^H = \left(A (A^H A)^{-1} A^H \right)^H = \left(A (A^H A)^{-1} A^H \right)
        = A A^{\dag}.
    
    
    
    .. math:: 
    
        (A^{\dag} A)^H = I^H = I = A^{\dag} A.
    



.. _lem:mat:moore_penrose_right_pseudo_inverse:

.. lemma:: 


    If :math:`A` is full row rank then its Moore-Penrose pseudo-inverse is given by
    
    
    .. math::
        A^{\dag} = A^H (A A^H)^{-1} . 
    
    It is a right inverse of :math:`A`.




.. proof:: 

    By :ref:`here <cor:mat:gram_full_row_rank_invertible>` :math:`A A^H` is invertible.
    
    
    First of all we verify that it is a right inverse.
    
    
    .. math:: 
    
        A A^{\dag} =  A  A^H (A A^H)^{-1}= I.
    
    We now verify all the properties.
    
    
    .. math:: 
    
        A A^{\dag} A  = I A = A.
    
    
    
    .. math:: 
    
        A^{\dag} A A^{\dag}   = A^{\dag} I = A^{\dag}.
    
    Hermitian properties:
    
    
    .. math:: 
    
        \left(A A^{\dag} \right)^H =  I^H = I = A A^{\dag}.
    
    
    
    .. math:: 
    
        (A^{\dag} A)^H =  \left (A^H (A A^H)^{-1} A \right )^H =  A^H (A A^H)^{-1} A = A^{\dag} A.
    



