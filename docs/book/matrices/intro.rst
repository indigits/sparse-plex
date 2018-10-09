Introduction
====================


In this chapter we collect results related to matrix algebra which are 
relevant to this book. 
Some specific topics which are typically not found in standard books 
are also covered here.


Standard notation in this chapter is given here. Matrices are denoted
by capital letters :math:`A`, :math:`B` etc..  They can be rectangular with
:math:`m` rows and :math:`n` columns.
Their **elements** or **entries** are referred to
with small letters :math:`a_{i j}`, :math:`b_{i j}` etc. where :math:`i` denotes the :math:`i`-th
row of matrix and :math:`j` denotes the :math:`j`-th column of matrix. Thus


.. math:: 

    A = \begin{bmatrix}
    a_{1 1} & a_{1 2} & \dots a_{1 n}\\
    a_{2 1} & a_{2 2} & \dots a_{1 n}\\
    \vdots & \vdots & \ddots \vdots\\
    a_{m 1} & a_{m 2} & \dots a_{m n}\\
    \end{bmatrix}
 

Mostly we consider complex matrices belonging to :math:`\CC^{m \times n}`. 
Sometimes we will restrict our attention to real matrices belonging to :math:`\RR^{m \times n}`.


.. index:: Square matrix

.. _def:mat:square_matrix:

.. definition:: 

    An :math:`m \times n` matrix is called **square matrix** if :math:`m = n`.



.. index:: Tall matrix

.. _def:mat:tall_matrix:

.. definition:: 


    An :math:`m \times n` matrix is called **tall matrix** if :math:`m > n` i.e. 
    the number of rows is greater than columns.



.. index:: Wide matrix

.. _def:mat:wide_matrix:

.. definition:: 

    An :math:`m \times n` matrix is called **wide matrix** if :math:`m < n` i.e. 
    the number of columns is greater than rows.


.. index:: Main diagonal
.. index:: Off diagonal


.. _def:mat:main_diagonal:

.. definition:: 

    Let :math:`A= [a_{i j}]` be an :math:`m \times n` matrix. The main diagonal consists of 
    entries :math:`a_{i j}` where :math:`i = j`. i.e. main diagonal is 
    :math:`\{a_{11}, a_{22}, \dots, a_{k k} \}` where :math:`k = \min(m, n)`.
    Main diagonal is also known as 
    **leading diagonal**,
    **major diagonal**
    **primary diagonal** or
    **principal diagonal**.
    The entries of :math:`A` which are not on the main diagonal are known as 
    **off diagonal** entries.



.. index:: Diagonal matrix
.. index:: rectangular diagonal matrix


.. _def:mat:diagonal_matrix:

.. definition:: 

    A **diagonal matrix** is a matrix (usually a square matrix) whose entries outside 
    the main diagonal are zero. 
    
    Whenever we refer to a diagonal matrix which is not square, we will use the term
    **rectangular diagonal matrix**.
    
    A square diagonal matrix :math:`A` is also represented by :math:`\Diag(a_{11}, a_{22}, \dots, a_{n n})`
    which lists only the diagonal (non-zero) entries in :math:`A`.







The transpose of a matrix :math:`A` is denoted by :math:`A^T` while the Hermitian transpose is
denoted by :math:`A^H`. For real matrices :math:`A^T  = A^H`.

When matrices are square, we have the number of rows and columns both equal to :math:`n` and
they belong to :math:`\CC^{n \times n}`. 

If not specified, the square matrices will be of size :math:`n \times n`
and rectangular matrices will be of size :math:`m \times n`. 
If not specified the vectors (column vectors) will be of size :math:`n \times 1` 
and belong to either :math:`\RR^n` or :math:`\CC^n`. Corresponding row vectors
will be of size :math:`1 \times n`.

For statements which are valid both for real and complex matrices, sometimes we might say
that matrices belong to :math:`\FF^{m \times n}` while the scalars belong to :math:`\FF` 
and vectors belong to :math:`\FF^n` where :math:`\FF` refers to either the field of
real numbers or the field of complex numbers. Note that this is not consistently
followed at the moment. Most results are written only for :math:`\CC^{m \times n}` while
still being applicable for :math:`\RR^{m \times n}`.

Identity matrix for :math:`\FF^{n \times n}` is denoted as :math:`I_n` or simply :math:`I` whenever the
size is clear from context. 

Sometimes we will write a matrix in terms of its column vectors. We will use
the notation


.. math:: 

    A  = \begin{bmatrix} a_1 & a_2 & \dots & a_n \end{bmatrix}

indicating :math:`n` columns.

When we write a matrix in terms of its row vectors, we will use the notation


.. math:: 

    A = \begin{bmatrix} a_1^T \\ a_2^T \\ \vdots \\ a_m^T \end{bmatrix}

indicating :math:`m` rows with :math:`a_i` being column vectors whose transposes form the 
rows of :math:`A`.

The rank of a matrix :math:`A` is written as :math:`\Rank(A)`, while the determinant as :math:`\det(A)`
or :math:`|A|`. 

We say that an :math:`m \times n` matrix :math:`A` is **left-invertible** if there exists 
an :math:`n \times m` matrix :math:`B` such that
:math:`B A = I`. 
We say that an :math:`m \times n` matrix :math:`A` is **right-invertible** if there exists 
an :math:`n \times m` matrix :math:`B` such that
:math:`A B= I`. 

We say that a square matrix :math:`A` is **invertible** when there exists another square matrix
:math:`B` of same size such that :math:`AB = BA = I`. 
A square matrix is invertible iff its both left and right invertible.
Inverse of a square invertible matrix is denoted by :math:`A^{-1}`.

A special left or right inverse is the pseudo inverse, which is denoted by :math:`A^{\dag}`.

Column space of a matrix is denoted by :math:`\ColSpace(A)`, the null space by :math:`\NullSpace(A)`,
and the row space by :math:`\RowSpace(A)`.


We say that a matrix is **symmetric** when :math:`A = A^T`, **conjugate symmetric** or 
**Hermitian** when :math:`A^H =A`.

When a square matrix is not invertible, we say that it is **singular**.  A 
**non-singular** matrix is invertible.

The eigen values of a square matrix are written as :math:`\lambda_1, \lambda_2, \dots`
while the singular values of a rectangular matrix are written as :math:`\sigma_1, \sigma_2, \dots`.

The inner product or dot product of two column / row vectors :math:`u` and :math:`v` belonging to :math:`\RR^n` is defined as


.. math::
    :label: eq:mat:column:inner_product

    u \cdot v = \langle u, v \rangle = \sum_{i=1}^n u_i v_i.


The inner product or dot product of two column / row vectors :math:`u` and :math:`v` belonging to :math:`\CC^n` is defined as


.. math::
    :label: eq:mat:column:inner_product:hermitian

    u \cdot v = \langle u, v \rangle = \sum_{i=1}^n u_i \overline{v_i}.



 
Block matrix
----------------------------------------------------


.. index:: Block matrix
.. index:: Partitioned matrix


.. _def:mat:block_matrix:

.. definition:: 

    A **block matrix** is a matrix whose entries themselves are matrices with following constraints
    
    *  Entries in every row are matrices with same number of rows.
    *  Entries in every column are matrices with same number of columns.
    
    Let :math:`A` be an :math:`m \times n` block matrix. Then
    
    
    .. math::
        A = \begin{bmatrix}
        A_{11} & A_{12} & \dots & A_{1 n}\\
        A_{21} & A_{22} & \dots & A_{2 n}\\
        \vdots & \vdots & \ddots & \vdots\\
        A_{m 1} & A_{m 2} & \dots & A_{m n}\\
        \end{bmatrix}
    
    where :math:`A_{i j}` is a matrix with :math:`r_i` rows and :math:`c_j` columns.
    
    A block matrix is also known as a **partitioned matrix**.




.. example:: 2x2 block matrices

    Quite frequently we will be using :math:`2x2` block matrices.
    
    
    .. math::
        P = \begin{bmatrix}
        P_{11} & P_{12} \\
        P_{21} & P_{22}
        \end{bmatrix}.
    
    An example
    
    
    .. math:: 
    
        P  =
        \left[
        \begin{array}{c c | c}
        a & b & c \\
        d & e & f \\
        \hline
        g & h & i
        \end{array}
        \right]
    
    We have
    
    
    .. math:: 
    
        P_{11} = 
        \begin{bmatrix}
          a & b \\
          d & e
        \end{bmatrix} \;
        P_{12}  = 
        \begin{bmatrix}
          c \\
          f
        \end{bmatrix} \;
        P_{21}  = 
        \begin{bmatrix}
          g &
          h
        \end{bmatrix} \;
        P_{22}  = 
        \begin{bmatrix}
        i
        \end{bmatrix}
    
    
    *  :math:`P_{11}` and :math:`P_{12}` have :math:`2` rows.
    *  :math:`P_{21}` and :math:`P_{22}` have :math:`1` row.
    *  :math:`P_{11}` and :math:`P_{21}` have :math:`2` columns.
    *  :math:`P_{12}` and :math:`P_{22}` have :math:`1` column.
    




.. lemma:: 

    Let :math:`A = [A_{ij}]` be an :math:`m \times n` block matrix with :math:`A_{ij}` being an :math:`r_i \times c_j` matrix. Then
    :math:`A` is an :math:`r \times c` matrix where
    
    
    .. math::
        r = \sum_{i=1}^m r_i
    
    and
    
    
    .. math::
        c = \sum_{j=1}^n c_j.
    




.. remark:: 

    Sometimes it is convenient to think of a regular matrix as a block matrix whose
    entries are :math:`1 \times 1` matrices themselves.


.. index:: Multiplication of block matrices

.. _def:mat:multiplication_block_matrix:

.. definition:: 


    Let :math:`A = [A_{ij}]` be an :math:`m \times n` block matrix with :math:`A_{ij}` being a :math:`p_i \times q_j` matrix.
    Let :math:`B = [B_{jk}]` be an :math:`n \times p` block matrix with :math:`B_{jk}` being a :math:`q_j \times r_k` matrix.
    Then the two block matrices are **compatible** for multiplication and their multiplication 
    is defined by :math:`C = AB = [C_{i k}]` where 
    
    
    .. math::
        C_{i k} = \sum_{j=1}^n A_{i j} B_{j k}
    
    and :math:`C_{i k}` is a :math:`p_i \times r_k` matrix.


.. index:: Block diagonal matrix

.. _def:mat:block_diagonal_matrix:

.. definition:: 


    A **block diagonal matrix** is a block matrix whose off diagonal entries are zero matrices.

