
 
Linear independence, span, rank
===================================================


 
Spaces associated with a matrix
----------------------------------------------------


.. index:: Column space

.. _def:mat:column_space:

.. definition:: 


    The **column space** of a matrix is defined as the vector space spanned by columns of the matrix.
    
    Let :math:`A` be an :math:`m \times n` matrix with
    
    
    .. math:: 
    
        A  = \begin{bmatrix}
        a_1 & a_2 & \dots & a_n
        \end{bmatrix}
    
    Then the column space is given by
    
    
    .. math::
        \ColSpace(A) = \{ x \in \FF^m : x  = \sum_{i=1}^n \alpha_i a_i \; \text{for some }  \alpha_i \in \FF \}.
    



.. index:: Row space


.. _def:mat:column_space:

.. definition:: 

    The **row space** of a matrix is defined as the vector space spanned by rows of the matrix.
    
    Let :math:`A` be an :math:`m \times n` matrix with
    
    
    .. math:: 
    
        A  = \begin{bmatrix}
        a_1^T  \\ a_2^T \\ \vdots \\ a_m^T
        \end{bmatrix}
    
    Then the row space is given by
    
    
    .. math::
        \RowSpace(A) = \{ x \in \FF^n : x  = \sum_{i=1}^m \alpha_i a_i \; \text{for some }  \alpha_i \in \FF \}.
    



 
Rank
----------------------------------------------------


.. index:: Column rank

.. _def:mat:column_rank:

.. definition:: 


    The **column rank** of a matrix is defined as the maximum number of columns which are linearly
    independent. In other words column rank is the dimension of the column space of a matrix.


.. index:: Row rank


.. _def:mat:row_rank:

.. definition:: 

    The **row rank** of a matrix is defined as the maximum number of rows which are linearly
    independent. In other words row rank is the dimension of the row space of a matrix.



.. _thm:mat:row_column_rank:

.. theorem:: 


    The **column rank** and **row rank** of a matrix are equal.


.. index:: Rank

.. _def:mat:rank:

.. definition:: 


    The **rank** of a matrix is defined to be equal to its column rank which is equal to its row rank.




.. lemma:: 

    For an :math:`m \times n` matrix :math:`A`
    
    
    .. math::
        0 \leq \Rank(A) \leq \min(m, n).
    




.. lemma:: 

    The rank of a matrix is 0 if and only if it is a zero matrix.


.. index:: Full rank matrix

.. _def:mat:full_rank_matrix:

.. definition:: 


    An :math:`m \times n` matrix :math:`A` is called **full rank** if
    
    
    .. math:: 
    
        \Rank (A) = \min(m, n).
    
    In other words it is either a full column rank matrix or a full row rank matrix or both.





.. _lem:mat:rank:product:

.. lemma:: 


    Let :math:`A` be an :math:`m \times n` matrix and :math:`B` be an :math:`n \times p` matrix then
    
    
    .. math::
        \Rank(AB) \leq \min (\Rank(A), \Rank(B)).
    



.. _lem:mat:rank:full_rank_post_multiplier:

.. lemma:: 


    Let :math:`A` be an :math:`m \times n` matrix and :math:`B` be an :math:`n \times p` matrix.
    If :math:`B` is of rank :math:`n` then
    
    
    .. math::
        \Rank(AB) = \Rank(A).
    



.. _lem:mat:rank:full_rank_pre_multiplier:

.. lemma:: 


    Let :math:`A` be an :math:`m \times n` matrix and :math:`B` be an :math:`n \times p` matrix.
    If :math:`A` is of rank :math:`n` then
    
    
    .. math::
        \Rank(AB) = \Rank(B).
    





.. _lem:mat:rank_diagonal_matrix:

.. lemma:: 

    The rank of a diagonal matrix is equal to the number of non-zero elements on its main diagonal.




.. proof:: 

    The columns which correspond to diagonal entries which are zero are zero columns. Other columns
    are linearly independent. The number of linearly independent rows is also the same.
    Hence their count gives us the rank of the matrix. 


