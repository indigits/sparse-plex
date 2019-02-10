
 
Matrix norms
===================================================


This section reviews various matrix norms on the vector space of 
complex matrices over the field of complex numbers :math:`(\CC^{m \times n}, \CC)`.

We know :math:`(\CC^{m \times n}, \CC)` is a finite dimensional vector space with
dimension :math:`m n`. We will usually refer to it as :math:`\CC^{m \times n}`.

Matrix norms will follow the usual definition of norms for a vector space.

.. index:: Matrix norm

.. _def:mat:matrix_norm:

.. definition:: 


    A function :math:`\| \cdot \| : \CC^{m \times n} \to \RR` is called a **matrix norm** on
    :math:`\CC^{m \times n}` if for all :math:`A, B \in \CC^{m \times n}` and all :math:`\alpha \in \CC`
    it satisfies the following
    
    #. [Positivity] 
    
    
       .. math::     
            \| A \| \geq 0 
    
       with :math:`\| A \| = 0 \iff A  = 0`.
    
    #. [Homogeneity]
    
    
       .. math:: 
            \| \alpha A \| = | \alpha | \| A \|.
    
    #. [Triangle inequality]
    
    
       .. math:: 
            \| A + B \| \leq \| A \| + \| B \|.
    
    
We recall some of the standard results on normed vector spaces.

All matrix norms are equivalent. Let :math:`\| \cdot \|` and :math:`\| \cdot \|'`
be two different matrix norms on  :math:`\CC^{m \times n}`. Then 
there exist two constants :math:`a` and :math:`b` such that the following holds


.. math:: 

    a \| A \| \leq \| A \|' \leq b \|A \|  \Forall A \in \CC^{m \times n}.


A matrix norm is a continuous function :math:`\| \cdot \| : \CC^{m \times n} \to \RR`.

 
Norms like :math:`\ell_p` on complex vector space
----------------------------------------------------

Following norms are quite like :math:`\ell_p` norms on finite dimensional complex vector space :math:`\CC^n`. 
They are developed
by the fact that the matrix vector space :math:`\CC^{m\times n}` has one to one
correspondence with the complex vector space :math:`\CC^{m n}`.

.. index:: Sum norm on matrix

.. _def:mat:sum_norm:

.. definition:: 


    Let :math:`A \in \CC^{m\times n}` and :math:`A  = [a_{ij}]`.
    
    Matrix **sum norm** is defined as
    
    
    .. math::
        \| A \|_S  = \sum_{i=1}^{m} \sum_{j=1}^n | a_{ij} |
    
    


.. index:: Frobenius norm on matrix


.. _def:mat:frobenius_norm:

.. definition:: 


    Let :math:`A \in \CC^{m\times n}` and :math:`A  = [a_{ij}]`.
    
    Matrix **Frobenius norm** is defined as
    
    
    .. math::
        \| A \|_F  = \left ( \sum_{i=1}^{m} \sum_{j=1}^n | a_{ij} |^2 \right )^{\frac{1}{2}}.
    
    

.. index:: Max norm on matrix

.. _def:mat:max_norm:

.. definition:: 


    Let :math:`A \in \CC^{m\times n}` and :math:`A  = [a_{ij}]`.
    
    Matrix **Max norm** is defined as
    
    
    .. math::
        \| A \|_M  = \underset{\substack{
        1 \leq i \leq m \\ 1 \leq j \leq n}}{\max} | a_{ij} |.
    
    


 
Properties of Frobenius norm
----------------------------------------------------

We now prove some elementary properties of Frobenius norm.


.. _lem:mat:frobenius_norm_hermitian_transpose:

.. lemma:: 


    The Frobenius norm of a matrix is equal to the Frobenius norm of its Hermitian transpose.
    
    
    .. math::
        \| A^H \|_F = \| A \|_F.
    




.. proof:: 

    Let 
    
    
    .. math:: 
    
        A = [a_{ij}].
    
    Then
    
    
    .. math:: 
    
        A^H = [\overline{a_{j i}}]
    
    
    
    .. math:: 
    
        \| A^H \|_F^2 = \left ( \sum_{j=1}^n \sum_{i=1}^{m} | \overline{a_{ij}} |^2 \right )
        = \left ( \sum_{i=1}^{m} \\ \sum_{j=1}^n | a_{ij} |^2 \right )
        = \| A \|_F^2.
    
    Now
    
    
    .. math:: 
    
        \| A^H \|_F^2 = \| A \|_F^2 \implies \| A^H \|_F = \| A \|_F
    



.. _lem:mat:frob_norm_column_vectors:

.. lemma:: 


    Let :math:`A \in \CC^{m \times n}` be written as a row of column vectors
    
    
    .. math:: 
    
        A = \begin{bmatrix}
        a_1 & \dots & a_n
        \end{bmatrix}.
    
    Then
    
    
    .. math::
        \| A \|_F^2 = \sum_{j=1}^{n} \| a_j \|_2^2.
    




.. proof:: 

    We note that 
    
    
    .. math:: 
    
        \| a_j \|_2^2 = \sum_{i=1}^m \| a_{i j} \|_2^2.
    
    Now
    
    
    .. math:: 
    
        \| A \|_F^2 = \left ( \sum_{i=1}^{m} \sum_{j=1}^n | a_{ij} |^2 \right )
        = \left ( \sum_{j=1}^n \left ( \sum_{i=1}^{m}  | a_{ij} |^2  \right ) \right )
        = \left (\sum_{j=1}^n  \| a_j \|_2^2 \right).
    


We thus showed that that the square of the Frobenius norm of a matrix
is nothing but the sum of squares of :math:`\ell_2` norms of its columns.


.. _lem:mat:frob_norm_row_vectors:

.. lemma:: 


    Let :math:`A \in \CC^{m \times n}` be written as a column of row vectors
    
    
    .. math:: 
    
        A = \begin{bmatrix}
        \underline{a}^1 \\
        \vdots \\
        \underline{a}^m
        \end{bmatrix}.
    
    Then
    
    
    .. math::
        \| A \|_F^2 = \sum_{i=1}^{m} \| \underline{a}^i \|_2^2.
    




.. proof:: 

    We note that 
    
    
    .. math:: 
    
        \| \underline{a}^i \|_2^2 = \sum_{j=1}^n \| a_{i j} \|_2^2.
    
    Now
    
    
    .. math:: 
    
        \| A \|_F^2 = \left ( \sum_{i=1}^{m} \sum_{j=1}^n | a_{ij} |^2 \right )
        = \sum_{i=1}^{m} \| \underline{a}^i \|_2^2.
    


We now consider how the Frobenius norm is affected with the action of unitary matrices.

Let :math:`A` be any arbitrary matrix in :math:`\CC^{m \times n}`. Let :math:`U` be some unitary matrices in :math:`\CC^{m \times m}`. 
Let :math:`V` be some unitary matrices in :math:`\CC^{n \times n}`.

We present our first result that multiplication with unitary matrices doesn't change Frobenius norm of a matrix.


.. _thm:mat:frobenius_norm_unitary_matrix_invariant:

.. theorem:: 


    The Frobenius norm of a matrix is invariant to pre or post multiplication by a unitary matrix. i.e.
    
    
    
    .. math::
        \| UA \|_F = \| A \|_F
    
    and
    
    
    .. math::
        \| AV \|_F = \| A \|_F.
    
    




.. proof:: 

    We can write :math:`A` as
    
    
    
    .. math:: 
    
        A = \begin{bmatrix}
        a_1 & \dots & a_n
        \end{bmatrix}.
    
    
    So 
    
    
    .. math:: 
    
        UA = \begin{bmatrix}
        Ua_1 & \dots & Ua_n
        \end{bmatrix}.
    
    
    Then applying :ref:`here <lem:mat:frob_norm_column_vectors>` clearly
    
    
    .. math:: 
    
        \| UA \|_F^2 =  \sum_{j=1}^{n} \|U a_j \|_2^2.
    
    
    But we know that unitary matrices are norm preserving. Hence
    
    
    .. math:: 
    
        \|U a_j \|_2^2 = \|a_j \|_2^2.
    
    
    Thus
    
    
    .. math:: 
    
        \| UA \|_F^2 = \sum_{j=1}^{n} \|a_j \|_2^2 = \| A \|_F^2
    
    which implies
    
    
    .. math:: 
    
        \| UA \|_F = \| A \|_F.
    
    
    Similarly writing :math:`A` as
    
    
    
    .. math:: 
    
        A = \begin{bmatrix}
        r_1 \\
        \vdots \\
        r_m
        \end{bmatrix}.
    
    
    we have
    
    
    .. math:: 
    
        AV = \begin{bmatrix}
        r_1  V\\
        \vdots \\
        r_m V
        \end{bmatrix}.
    
    
    Then applying :ref:`here <lem:mat:frob_norm_row_vectors>` clearly
    
    
    .. math:: 
    
        \| AV \|_F^2 = \sum_{i=1}^{m} \| r_i V \|_2^2.
    
    
    But we know that unitary matrices are norm preserving. Hence
    
    
    .. math:: 
    
        \|r_i V \|_2^2 = \|r_i \|_2^2.
    
    
    Thus
    
    
    .. math:: 
    
        \| AV \|_F^2 = \sum_{i=1}^{m} \| r_i \|_2^2 =  \| A \|_F^2
    
    which implies
    
    
    .. math:: 
    
        \| AV \|_F = \| A \|_F.
    
    
    An alternative approach for the 2nd part of the proof using the first part is just one line
    
    
    .. math:: 
    
        \| AV \|_F = \| (AV)^H \|_F = \| V^H A^H \|_F = \| A^H \|_F = \| A \|_F.
    
    In above we use :ref:`here <lem:mat:frobenius_norm_hermitian_transpose>` 
    and the fact that :math:`V` is a unitary matrix implies that :math:`V^H` is also a unitary matrix.
    We have already shown that pre multiplication by a unitary matrix preserves Frobenius norm.



.. _thm:mat:frobenius_norm_consistency:

.. theorem:: 


    Let :math:`A \in \CC^{m \times n}` and :math:`B \in \CC^{n \times P}` be two matrices.   Then
    the Frobenius norm of their product is less than or equal to the product of Frobenius norms
    of the matrices themselves. i.e.
    
    
    .. math::
        \| AB \|_F \leq \|A \|_F \| B \|_F.
    




.. proof:: 

    We can write :math:`A` as
    
    
    .. math:: 
    
        A = \begin{bmatrix}
        a_1^T \\
        \vdots \\
        a_m^T
        \end{bmatrix}
    
    where :math:`a_i` are :math:`m` column vectors corresponding to rows of :math:`A`.
    Similarly we can write  B as
    
    
    .. math:: 
    
        B = \begin{bmatrix}
        b_1 &
        \dots &
        b_P
        \end{bmatrix}
    
    where :math:`b_i` are column vectors corresponding to columns of :math:`B`.
    Then 
    
    .. math:: 
    
        A B = 
        \begin{bmatrix}
        a_1^T \\
        \vdots \\
        a_m^T
        \end{bmatrix}
         \begin{bmatrix}
        b_1 &
        \dots &
        b_P
        \end{bmatrix}
        =  \begin{bmatrix}
        a_1^T b_1 & \dots & a_1^T b_P\\
        \vdots  & \ddots & \vdots \\
        a_m^T b_1 & \dots & a_m^T b_P
        \end{bmatrix}
        = \begin{bmatrix}
        a_i^T b_j
        \end{bmatrix}
        .
    
    Now looking carefully
    
    
    .. math:: 
    
        a_i^T b_j = \langle a_i, \overline{b_j} \rangle
    
    Applying the Cauchy-Schwartz inequality we have
    
    
    .. math:: 
    
        | \langle a_i, \overline{b_j} \rangle |^2 \leq \| a_i \|_2^2 \| \overline{b_j} \|_2^2 
         =  \| a_i \|_2^2 \| b_j \|_2^2 
    
    Now
    
    
    .. math:: 
    
        \| A B \|_F^2 &= \sum_{i=1}^{m} \sum_{j=1}^{P} | a_i^T b_j |^2\\
        &\leq \sum_{i=1}^{m} \sum_{j=1}^{P} \| a_i \|_2^2 \| b_j \|_2^2\\
        &= \left ( \sum_{i=1}^{m} \| a_i \|_2^2 \right ) \left ( \sum_{j=1}^{P}  \| b_j \|_2^2\right )\\
        &= \| A \|_F^2  \| B \|_F^2 
    
    which implies
    
    
    .. math:: 
    
        \| A B \|_F \leq \| A \|_F \| B \|_F
    
    by taking square roots on both sides.



.. _cor:mat:frobenius_norm_subordinate_euclidean_norm:

.. corollary:: 


    Let :math:`A \in \CC^{m \times n}` and let :math:`x \in \CC^n`. Then
    
    
    .. math:: 
    
        \| A x \|_2 \leq \| A \|_F \| x \|_2.
    




.. proof:: 

    We note that Frobenius norm for a column matrix is same as :math:`\ell_2` norm for corresponding column vector. i.e.
    
    
    .. math:: 
    
        \| x \|_F = \| x \|_2 \Forall x \in \CC^n.
    
    
    Now applying  :ref:`here <thm:mat:frobenius_norm_consistency>` we have
    
    
    .. math:: 
    
        \| A x \|_2 = \| A x \|_F \leq \| A \|_F \| x \|_F =  \| A \|_F \| x \|_2 \Forall x \in \CC^n.
    


It turns out that Frobenius norm is intimately related to the singular value decomposition 
of a matrix.

.. _res:mat:frobenius_norm_sum_of_singular_values:

.. lemma:: 


    Let :math:`A \in \CC^{m \times n}`. Let the singular value decomposition of :math:`A` be given by
    
    
    .. math:: 
    
        A = U \Sigma V^H.
    
    Let the singular value of :math:`A` be :math:`\sigma_1, \dots, \sigma_n`. Then 
    
    
    .. math::
        \| A \|_F = \sqrt {\sum_{i=1}^n \sigma_i^2}.
    
    



.. proof:: 

    
    
    .. math:: 
    
        A = U \Sigma V^H \implies \|A \|_F = \| U \Sigma V^H \|_F.
    
    
    But
    
    
    .. math:: 
    
         \| U \Sigma V^H \|_F = \| \Sigma V^H \|_F = \| \Sigma \|_F
    
    since :math:`U` and :math:`V` are unitary matrices (see :ref:`here <thm:mat:frobenius_norm_unitary_matrix_invariant>`
    ). 
    
    Now the only non-zero terms in :math:`\Sigma` are the singular values.  Hence
    
    
    .. math:: 
    
        \| A \|_F = \| \Sigma \|_F = \sqrt {\sum_{i=1}^n \sigma_i^2}.
    


 
Consistency of a matrix norm
----------------------------------------------------


.. index:: Consistent matrix norm
.. index:: Sub-multiplicative norm


.. _def:mat:consistent_matrix_norm:

.. definition:: 


    A matrix norm :math:`\| \cdot \|` is called **consistent** on :math:`\CC^{n \times n}` if
    
    
    .. math::
        :label: eq:consistent_matrix_norm_equation
    
        \| A B \| \leq \| A \| \| B \| 
    
    holds true for all :math:`A, B \in \CC^{n \times n}`.
    A matrix norm :math:`\| \cdot \|` is called  **consistent** if it is defined on :math:`\CC^{m \times n}` 
    for all :math:`m, n \in \Nat` and eq :eq:`eq:consistent_matrix_norm_equation` holds for all matrices
    :math:`A, B` for which the product :math:`AB` is defined. 
    
    A  consistent matrix norm is also known as a **sub-multiplicative norm**.

With this definition and results in :ref:`here <thm:mat:frobenius_norm_consistency>` we can
see that Frobenius norm is consistent.





 
Subordinate matrix norm
----------------------------------------------------


A matrix operates on vectors from one space to generate vectors in another space. It is
interesting to explore the connection between the norm of a matrix and norms of vectors
in the domain and co-domain of a matrix.

.. index:: Subordinate matrix norm

.. _def:mat:subordinate_matrix_norm:

.. definition:: 


    Let :math:`m, n \in \Nat` be given. Let :math:`\| \cdot \|_{\alpha}`  be some norm on :math:`\CC^m` and
    :math:`\| \cdot \|_{\beta}`  be some norm on :math:`\CC^n`. Let :math:`\| \cdot \|` be some norm on
    matrices in :math:`\CC^{m \times n}`. We say that :math:`\| \cdot \|` is **subordinate**
    to the vector norms :math:`\| \cdot \|_{\alpha}` and :math:`\| \cdot \|_{\beta}` if 
    
    
    .. math::
        \| A x \|_{\alpha} \leq \| A \| \| x \|_{\beta}
    
    for all :math:`A \in \CC^{m \times n}` and for all :math:`x \in \CC^n`. In other words
    the length of the vector doesn't increase by the operation of :math:`A`
    beyond a factor given by the norm of the matrix itself.
    
    If :math:`\| \cdot \|_{\alpha}` and :math:`\| \cdot \|_{\beta}` are same then we say that
    :math:`\| \cdot \|` is **subordinate** to the vector norm :math:`\| \cdot \|_{\alpha}`.


We have shown earlier in :ref:`here <cor:mat:frobenius_norm_subordinate_euclidean_norm>` 
that Frobenius norm is subordinate to Euclidean norm.



 
Operator norm
----------------------------------------------------

We now consider the maximum factor by which a matrix :math:`A` can increase the
length of a vector.

.. index:: Operator norm

.. _def:mat:operator_norm:

.. definition:: 


    Let :math:`m, n \in \Nat` be given. Let :math:`\| \cdot \|_{\alpha}`  be some norm on :math:`\CC^n` and
    :math:`\| \cdot \|_{\beta}`  be some norm on :math:`\CC^m`. For :math:`A \in \CC^{m \times n}` we
    define 
    
    
    .. math::
        \| A \| \triangleq \| A \|_{\alpha \to \beta} \triangleq \underset{x \neq 0}{\max } \frac{\| A x \|_{\beta}}{\| x \|_{\alpha}}.
    
    :math:`\frac{\| A x \|_{\beta}}{\| x \|_{\alpha}}` represents the factor with which the length of :math:`x` increased by
    operation of :math:`A`. We simply pick up the maximum value of such scaling factor.
    
    The norm as defined above is known as **:math:`(\alpha \to \beta)` operator norm**, the :math:`(\alpha \to \beta)`-norm,
    or simply the :math:`\alpha`-norm if :math:`\alpha = \beta`.


Of course we need to verify that this definition satisfies all properties of a norm.

Clearly if :math:`A= 0` then :math:`A x = 0` always, hence :math:`\| A \| = 0`.

Conversely, if :math:`\| A \| = 0` then :math:`\| A x \|_{\beta} = 0 \Forall x \in \CC^n`. In particular
this is true for the unit vectors :math:`e_i \in \CC^n`. The :math:`i`-th column of :math:`A` is given by
:math:`A e_i` which is 0. Thus each column in :math:`A` is 0. Hence :math:`A = 0`. 

Now consider :math:`c \in \CC`. 


.. math:: 

    \| c A \| = \underset{x \neq 0}{\max } \frac{\| c A x \|_{\beta}}{\| x \|_{\alpha}} 
    = | c | \underset{x \neq 0}{\max } \frac{\| A x \|_{\beta}}{\| x \|_{\alpha}} 
    = | c | \|A \|.



We now present some useful observations on operator norm before we can prove triangle
inequality for operator norm.

For any :math:`x \in \Kernel(A)`, :math:`A x = 0` hence we only need to consider vectors which don't belong
to the kernel of :math:`A`.

Thus we can write


.. math::
    \| A \|_{\alpha \to \beta}  = \underset{x \notin \Kernel(A)} {\max } \frac{\| A x \|_{\beta}}{\| x \|_{\alpha}}.


We also note that 


.. math:: 

    \frac{\| A c x \|_{\beta}}{\| c x \|_{\alpha}} 
    = \frac{| c | \| A x \|_{\beta}}{ | c | \| x \|_{\alpha}}
    = \frac{\| A x \|_{\beta}}{\| x \|_{\alpha}}  
    \Forall c \neq 0,  x \neq 0.

Thus, it is sufficient to find the maximum on unit norm vectors:


.. math:: 

    \| A \|_{\alpha \to \beta}  = \underset{\| x \|_{\alpha} = 1} {\max } \| A x \|_{\beta}.

Note that since :math:`\|x \|_{\alpha} = 1` hence the term in denominator goes away.


.. _lem:mat:operator_norm_subordinate:

.. lemma:: 


    The :math:`(\alpha \to \beta)`-operator norm is subordinate to vector norms :math:`\| \cdot \|_{\alpha}` and
    :math:`\| \cdot \|_{\beta}`. i.e.
    
    
    .. math::
        \| A x \|_{\beta} \leq \| A \|_{\alpha \to \beta } \| x \|_{\alpha}. 
    




.. proof:: 

    For :math:`x = 0` the inequality is trivially satisfied. Now for :math:`x \neq 0` by definition, we have
    
    
    .. math:: 
    
        \| A \|_{\alpha \to \beta } \geq 
        \frac{\| A x \|_{\beta}}{\| x \|_{\alpha}} 
        \implies \| A \|_{\alpha \to \beta } \| x \|_{\alpha} 
        \geq \| A x \|_{\beta}.
    




.. remark:: 

    There exists a vector :math:`x^* \in \CC^{n}` with unit norm (:math:`\| x^* \|_{\alpha} = 1`) such that
    
    
    .. math::
        \| A \|_{\alpha \to \beta} = \| A x^* \|_{\beta}.
    




.. proof:: 

    Let :math:`x' \neq 0` be some vector which maximizes the expression
    
    
    .. math:: 
    
        \frac{\| A x \|_{\beta}}{\| x \|_{\alpha}}.
    
    Then 
    
    
    .. math:: 
    
        \|  A\|_{\alpha \to \beta} = \frac{\| A x' \|_{\beta}}{\| x' \|_{\alpha}}.
    
    Now consider :math:`x^* = \frac{x'}{\| x' \|_{\alpha}}`. Thus :math:`\| x^* \|_{\alpha} = 1`.
    We know that
    
    
    .. math:: 
    
        \frac{\| A x' \|_{\beta}}{\| x' \|_{\alpha}} = \| A x^* \|_{\beta}.
    
    Hence
    
    
    .. math:: 
    
        \|  A\|_{\alpha \to \beta} =  \| A x^* \|_{\beta}.
    


We are now ready to prove triangle inequality for operator norm.



.. _lem:mat:operator_norm_triangular_inequality:

.. lemma:: 


    Operator norm as defined in :ref:`here <def:mat:operator_norm>` satisfies triangle inequality.




.. proof:: 

    Let :math:`A` and :math:`B` be some matrices in :math:`\CC^{m \times n}`.  Consider the operator norm
    of matrix :math:`A+B`. From previous remarks, there exists some vector :math:`x^* \in \CC^n` with :math:`\| x^* \|_{\alpha} = 1` such that
    
    
    .. math:: 
    
        \| A + B \| = \| (A+B) x^* \|_{\beta}.
    
    Now 
    
    
    .. math:: 
    
        \| (A+B) x^* \|_{\beta} = \| Ax^* + B x^* \|_{\beta} \leq \| Ax^*\|_{\beta} + \| Bx^*\|_{\beta}. 
    
    
    From another remark we have
    
    
    .. math:: 
    
        \| Ax^*\|_{\beta}  \leq \| A \| \|x^*\|_{\alpha} = \|A \|
    
    and
    
    
    .. math:: 
    
        \| Bx^*\|_{\beta}  \leq \| B \| \|x^*\|_{\alpha} = \|B \|
    
    since :math:`\| x^* \|_{\alpha} = 1`.
    
    Hence we have
    
    
    .. math:: 
    
        \| A + B \| \leq \| A \| + \| B \|.
    


It turns out that operator norm is also consistent under certain conditions. 


.. _lem:mat:p_matrix_norms_are_consistent:

.. lemma:: 


    Let :math:`\| \cdot \|_{\alpha}` be defined over all :math:`m \in \Nat`. Let :math:`\| \cdot \|_{\beta} = \| \cdot \|_{\alpha}`. 
    Then the operator norm
    
    
    .. math:: 
    
        \| A \|_{\alpha} = \underset{x \neq 0}{\max } \frac{\| A x \|_{\alpha}}{\| x \|_{\alpha}}
    
    is consistent.




.. proof:: 

    We need to show that
    
    
    .. math:: 
    
        \| A B \|_{\alpha} \leq \| A \|_{\alpha} \| B \|_{\alpha}.
    
    
    Now
    
    
    .. math:: 
    
        \| A B \|_{\alpha}  = \underset{x \neq 0}{\max } \frac{\| A B x \|_{\alpha}}{\| x \|_{\alpha}}.
    
    We note that if :math:`Bx = 0`, then :math:`A B x = 0`. Hence we can rewrite as
    
    
    .. math:: 
    
        \| A B \|_{\alpha}  = \underset{Bx \neq 0}{\max } \frac{\| A B x \|_{\alpha}}{\| x \|_{\alpha}}.
    
    Now if :math:`Bx \neq 0` then :math:`\| Bx \|_{\alpha} \neq 0`. Hence
    
    
    .. math:: 
    
        \frac{\| A B x \|_{\alpha}}{\| x \|_{\alpha}} = \frac{\| A B x \|_{\alpha}}{\|B x \|_{\alpha}} \frac{\| B x \|_{\alpha}}{\| x \|_{\alpha}}
    
    and
    
    
    .. math:: 
    
         \underset{Bx \neq 0}{\max } \frac{\| A B x \|_{\alpha}}{\| x \|_{\alpha}} \leq 
         \underset{Bx \neq 0}{\max }  \frac{\| A B x \|_{\alpha}}{\|B x \|_{\alpha}} 
         \underset{Bx \neq 0}{\max } \frac{\| B x \|_{\alpha}}{\| x \|_{\alpha}}.
    
    Clearly
    
    
    .. math:: 
    
        \| B \|_{\alpha} = \underset{Bx \neq 0}{\max } \frac{\| B x \|_{\alpha}}{\| x \|_{\alpha}}.
    
    Furthermore 
    
    
    .. math:: 
    
         \underset{Bx \neq 0}{\max }  \frac{\| A B x \|_{\alpha}}{\|B x \|_{\alpha}} 
         \leq
          \underset{y \neq 0}{\max }  \frac{\| A y \|_{\alpha}}{\|y \|_{\alpha}} 
          = \|A \|_{\alpha}.
    
    Thus we have 
    
    
    .. math:: 
    
        \| A B \|_{\alpha} \leq \| A \|_{\alpha} \| B \|_{\alpha}.
    


.. _sec:mat:p_norm:
 
p-norm for matrices
----------------------------------------------------

We recall the definition of :math:`\ell_p` norms for vectors :math:`x \in \CC^n` from :eq:`eq:complex_l_p_norm`



.. math:: 

    \| x \|_p = \begin{cases}
    \left ( \sum_{i=1}^{n} | x |_i^p  \right ) ^ {\frac{1}{p}} &  p \in [1, \infty)\\
    \underset{1 \leq i \leq n}{\max} |x_i| &  p = \infty
    \end{cases}.


The operator norms :math:`\| \cdot \|_p` defined from :math:`\ell_p` vector norms are of specific interest.

.. index:: :math:`p`-norm for matrices
.. index:: Matrix :math:`p`-norm


.. _def:mat:p_matrix_norm:

.. definition:: 


    The :math:`p`-norm for a matrix :math:`A \in \CC^{m \times n}` is defined as
    
    
    .. math::
        \| A \|_p \triangleq \underset{x \neq 0}{\max } \frac{\| A x \|_p}{\| x \|_p} 
        = \underset{\| x \|_p = 1}{\max } \| A x \|_p
    
    where :math:`\| x \|_p` is the standard :math:`\ell_p` norm for vectors in :math:`\CC^m` and :math:`\CC^n`.



.. remark:: 

    As per :ref:`here <lem:mat:p_matrix_norms_are_consistent>` :math:`p`-norms for matrices are consistent norms.
    They are also sub-ordinate to :math:`\ell_p` vector norms.


Special cases are considered for :math:`p=1,2`  and :math:`\infty`.


.. index:: Max column sum norm
.. index:: Max row sum norm
.. index:: Spectral norm


.. _thm:mat:closed_form_p_norms:

.. theorem:: 


    Let :math:`A \in \CC^{m \times n}`.
    
    For :math:`p=1` we have
    
    
    .. math::
        \| A \|_1 \triangleq \underset{1\leq j \leq n}{\max} \sum_{i=1}^m | a_{ij}|.
    
    This is also known as **max column sum norm**.
    
    For :math:`p=\infty` we have
    
    
    .. math::
        \| A \|_{\infty} \triangleq \underset{1\leq i \leq m}{\max} \sum_{j=1}^n | a_{ij}|.
    
    This is also known as **max row sum norm**.
    
    Finally for :math:`p=2` we have
    
    
    .. math::
        \| A \|_2 \triangleq \sigma_1
    
    where :math:`\sigma_1` is the largest singular value of :math:`A`.
    This is also known as **spectral norm**.
    




.. proof:: 

    Let
    
    
    .. math:: 
    
        A = \begin{bmatrix}
        a^1 & \dots, & a^n
        \end{bmatrix}.
    
    Then
    
    
    .. math:: 
    
        \begin{aligned}
        \| A x \|_1 
        &= \left \| \sum_{j=1}^n x_j a^j \right \|_1 \\
        &\leq \sum_{j=1}^n \left \|  x_j a^j \right \|_1 \\
        &= \sum_{j=1}^n |x_j|  \left \|   a^j \right \|_1 \\
        &\leq \underset{1 \leq j \leq n}{\max}\| a^j \|_1 \sum_{j=1}^n |x_j| \\
        &= \underset{1 \leq j \leq n}{\max}\| a^j \|_1 \| x \|_1.
        \end{aligned}
    
    Thus,
    
    
    .. math:: 
    
        \| A \|_1 = \underset{x \neq 0}{\max } \frac{\| A x \|_1}{\| x \|_1}
        \leq \underset{1 \leq j \leq n}{\max}\| a^j \|_1
    
    which the maximum column sum. We need to show
    that this upper bound is indeed an equality.
    
    Indeed for any :math:`x=e_j` where :math:`e_j` is a unit vector
    with :math:`1` in :math:`j`-th entry and 0 elsewhere, 
    
    
    .. math:: 
    
        \| A e_j \|_1 = \| a^j \|_1.
    
    Thus
    
    
    .. math:: 
    
        \| A \|_1 \geq \| a^j \|_1 \quad \Forall 1 \leq j \leq n.
     
    Combining the two, we see that
    
    
    .. math:: 
    
        \| A \|_1 = \underset{1 \leq j \leq n}{\max}\| a^j \|_1.
    
    
    For :math:`p=\infty`, we proceed as follows:
    
    
    .. math:: 
    
        \begin{aligned}
        \| A x \|_{\infty} &= \underset{1 \leq i \leq m}{\max}
        \left | \sum_{j=1}^n a_{ij } x_j \right | \\
        & \leq  \underset{1 \leq i \leq m}{\max}
        \sum_{j=1}^n | a_{ij } | | x_j |\\
        & \leq \underset{1 \leq j \leq n}{\max} | x_j | 
        \underset{1 \leq i \leq m}{\max} \sum_{j=1}^n | a_{ij } |\\
        &= \| x \|_{\infty} 
        \underset{1 \leq i \leq m}{\max}\| \underline{a}^i \|_1
        \end{aligned}
    
    where :math:`\underline{a}^i` are the rows of :math:`A`.
    
    This shows that
    
    
    .. math:: 
    
        \| A x \|_{\infty} \leq \underset{1 \leq i \leq m}{\max}\| \underline{a}^i \|_1.
    
    We need to show that this is indeed an equality.
    
    Fix an :math:`i = k` and choose :math:`x` such that
    
    
    .. math:: 
    
        x_j = \sgn (a_{k j}).
    
    Clearly :math:`\| x \|_{\infty} = 1`.
    
    Then
    
    
    .. math:: 
    
        \begin{aligned}
        \| A x \|_{\infty} &= \underset{1 \leq i \leq m}{\max}
        \left | \sum_{j=1}^n a_{ij } x_j \right | \\
        &\geq \left | \sum_{j=1}^n a_{k j } x_j \right | \\
        &= \left |  \sum_{j=1}^n | a_{k j } |   \right | \\
        &= \sum_{j=1}^n | a_{k j } |\\
        &= \| \underline{a}^k \|_1.
        \end{aligned}
    
    Thus, 
    
    
    .. math:: 
    
        \| A \|_{\infty} \geq \underset{1 \leq i \leq m}{\max}\| \underline{a}^i \|_1
    
    
    Combining the two inequalities we get:
    
    
    .. math:: 
    
        \| A \|_{\infty} = \underset{1 \leq i \leq m}{\max}\| \underline{a}^i \|_1.
    
    
    Remaining case is for :math:`p=2`.
    
    For any vector :math:`x` with :math:`\| x \|_2 = 1`,
    
    
    .. math:: 
    
        \| A x \|_2  = \| U \Sigma V^H x \|_2 
        = \| U (\Sigma V^H x )\|_2  = \| \Sigma V^H x \|_2
    
    since :math:`\ell_2` norm is invariant to unitary transformations.
    
    Let :math:`v = V^H x`. Then :math:`\|v\|_2 = \| V^H x \|_2 = \| x \|_2 = 1`.
    
    Now
    
    
    .. math:: 
    
        \begin{aligned}
        \| A x \|_2 &= \| \Sigma v \|_2\\ 
        &= \left ( \sum_{j=1}^n | \sigma_j v_j |^2 \right )^{\frac{1}{2}}\\
        &\leq  \sigma_1 \left ( \sum_{j=1}^n | v_j |^2 \right )^{\frac{1}{2}}\\
        &= \sigma_1 \| v \|_2 = \sigma_1.
        \end{aligned}
    
    This shows that 
    
    
    .. math:: 
    
        \| A \|_2 \leq \sigma_1.
    
    Now consider some vector :math:`x` such that :math:`v = (1, 0, \dots, 0)`. Then
    
    
    .. math:: 
    
        \| A x \|_2 = \| \Sigma v \|_2 = \sigma_1.
    
    Thus
    
    
    .. math:: 
    
        \| A \|_2 \geq \sigma_1.
    
    Combining the two, we get that :math:`\| A \|_2 = \sigma_1`.


 
The 2-norm
----------------------------------------------------

.. _sec:mat:2_norm_matrix:


.. _thm:mat:2_norm_square_matrices:

.. theorem:: 


    Let :math:`A\in \CC^{n \times n}` has singular values
    :math:`\sigma_1 \geq \sigma_2 \geq \dots \geq \sigma_n`. 
    Let the eigen values for :math:`A` be
    :math:`\lambda_1, \lambda_2, \dots, \lambda_n` with :math:`|\lambda_1| \geq |\lambda_2| \geq \dots \geq |\lambda_n|`.
    Then the following hold
    
    
    .. math::
        \| A \|_2 = \sigma_1 
    
    and if :math:`A` is non-singular
    
    
    .. math::
        \| A^{-1} \|_2 = \frac{1}{\sigma_n}. 
    
    
    If :math:`A` is symmetric and positive definite, then
    
    
    .. math::
        \| A \|_2 = \lambda_1 
    
    and if :math:`A` is non-singular
    
    
    .. math::
        \| A^{-1} \|_2 = \frac{1}{\lambda_n}.
    
    If :math:`A` is normal then
    
    
    .. math::
        \| A \|_2 = |\lambda_1|
    
    and if :math:`A` is non-singular
    
    
    .. math::
        \| A^{-1} \|_2 = \frac{1}{|\lambda_n|}.
    




 
Unitary invariant norms
----------------------------------------------------


.. index:: Unitary invariant matrix norm


.. _def:mat:unitary_invariant_matrix_norms:

.. definition:: 


    A matrix norm :math:`\| \cdot \|` on :math:`\CC^{m \times n}` is called **unitary invariant** if
    :math:`\| U A V \| = \|A \|` for any :math:`A \in \CC^{m \times n}` and any unitary matrices
    :math:`U \in \CC^{m \times m}` and :math:`V \in \CC^{n \times n}`.

We have already seen in :ref:`here <thm:mat:frobenius_norm_unitary_matrix_invariant>`
that Frobenius norm is unitary invariant. 

It turns out that spectral norm is also unitary invariant. 


 
More properties of operator norms
----------------------------------------------------

In this section we will focus on operator norms connecting 
normed linear spaces :math:`(\CC^n, \| \cdot \|_{p})` and
:math:`(\CC^m, \| \cdot \|_{q})`. Typical values of :math:`p, q` would be in
:math:`\{1, 2, \infty\}`.

We recall that


.. math::
    \| A \|_{p \to q } = \underset{x \neq 0}{\max} \frac{\| A x \|_q}{\| x \|_p}
    = \underset{ \| x \|_p = 1}{\max} \| A x \|_q  = \underset{\| x \|_p \leq 1}{\max} \| A x \|_q.


The following table (based on :cite:`tropp2004just`)
shows how to compute different :math:`(p, q)` norms. 
Some can be computed easily while others are NP-hard to compute.

.. _tbl:mat:calculation_p_q_operator_norms:

.. list-table:: Typical :math:`(p \to q)` norms
    :header-rows: 1

    * - p
      - q 
      - :math:`\| A \|_{p \to q}` 
      - Calculation
    * - 1
      - 1
      - :math:`\| A \|_{1 }`
      - Maximum :math:`\ell_1` norm of a column
    * - 1
      - 2
      - :math:`\| A \|_{1  \to 2}`
      - Maximum :math:`\ell_2` norm of a column
    * - 1
      - :math:`\infty`
      - :math:`\| A \|_{1  \to \infty}`
      - Maximum absolute entry of a matrix
    * - 2
      - 1
      - :math:`\| A \|_{2 \to 1}`
      - NP hard
    * - 2
      - 2
      - :math:`\| A \|_{2}`
      - Maximum singular value
    * - 2
      - :math:`\infty`
      - :math:`\| A \|_{2  \to \infty}`
      - Maximum :math:`\ell_2` norm of a row
    * - :math:`\infty`
      - 1
      - :math:`\| A \|_{\infty  \to 1}`
      - NP hard
    * - :math:`\infty`
      - 2
      - :math:`\| A \|_{\infty  \to 2}`
      - NP hard
    * - :math:`\infty`
      - :math:`\infty`
      - :math:`\| A \|_{\infty}`
      - Maximum :math:`\ell_1`-norm of a row

The topological dual of the finite dimensional normed linear space :math:`(\CC^n, \| \cdot \|_{p})` 
is the normed linear space :math:`(\CC^n, \| \cdot \|_{p'})` where 


.. math:: 

    \frac{1}{p} + \frac{1}{p'} = 1.

:math:`\ell_2`-norm is dual of :math:`\ell_2`-norm. It is a self dual. 
:math:`\ell_1` norm and :math:`\ell_{\infty}`-norm are dual of each other.

When a matrix :math:`A` maps from the space :math:`(\CC^n, \| \cdot \|_{p})` to
the space :math:`(\CC^m, \| \cdot \|_{q})`, we can view its
conjugate transpose :math:`A^H` as a mapping from the space :math:`(\CC^m, \| \cdot \|_{q'})`
to :math:`(\CC^n, \| \cdot \|_{p'})`.


.. _res:mat:operator_norm_conjugate_transpose:

.. theorem:: 


    Operator norm of a matrix always equals the operator norm of its conjugate transpose. i.e.
    
    
    .. math::
        \| A \|_{p \to q} = \| A^H \|_{q' \to p'}
    
    where
    
    
    .. math:: 
    
        \frac{1}{p} + \frac{1}{p'} = 1, \frac{1}{q} + \frac{1}{q'} = 1.
    

Specific applications of this result are:


.. math::
    \| A \|_2 = \| A^H \|_2.

This is obvious since the maximum singular value of a matrix and its conjugate 
transpose are same.



.. math::
    \| A \|_1 = \| A^H \|_{\infty}, \quad \| A \|_{\infty} = \| A^H \|_1.

This is also obvious since max column sum of :math:`A` is same as
the max row sum norm of :math:`A^H` and vice versa.


.. math::
    \| A \|_{1 \to \infty} = \| A^H \|_{1 \to \infty}.



.. math::
    \| A \|_{1 \to 2} = \| A^H \|_{2 \to \infty}.



.. math::
    \| A \|_{\infty \to 2} = \| A^H \|_{2 \to 1}.

We now need to show the result for the general case (arbitrary :math:`1 \leq p, q \leq \infty`).


.. proof:: 

    TODO






.. _res:mat:1_to_p_operator_norm:

.. theorem:: 


    
    
    .. math::
        \| A \|_{1 \to p} = \underset{1 \leq j \leq n}{\max}\| a^j \|_p.
    
    where
    
    
    .. math:: 
    
        A = \begin{bmatrix}
        a^1 & \dots, & a^n
        \end{bmatrix}.
    



.. proof:: 

    
    
    .. math:: 
    
        \begin{aligned}
        \| A x \|_p 
        &= \left \| \sum_{j=1}^n x_j a^j \right \|_p \\
        &\leq \sum_{j=1}^n \left \|  x_j a^j \right \|_p \\
        &= \sum_{j=1}^n |x_j|  \left \|   a^j \right \|_p \\
        &\leq \underset{1 \leq j \leq n}{\max}\| a^j \|_p \sum_{j=1}^n |x_j| \\
        &= \underset{1 \leq j \leq n}{\max}\| a^j \|_p \| x \|_1.
        \end{aligned}
    
    Thus,
    
    
    .. math:: 
    
        \| A \|_{1 \to p} = \underset{x \neq 0}{\max } 
        \frac{\| A x \|_p}{\| x \|_1}
        \leq \underset{1 \leq j \leq n}{\max}\| a^j \|_p.
    
    We need to show that this upper bound is indeed an equality.
    
    Indeed for any :math:`x=e_j` where :math:`e_j` is a unit vector
    with :math:`1` in :math:`j`-th entry and 0 elsewhere, 
    
    
    .. math:: 
    
        \| A e_j \|_p = \| a^j \|_p.
    
    Thus
    
    
    .. math:: 
    
        \| A \|_{1 \to p} \geq \| a^j \|_p \quad \Forall 1 \leq j \leq n.
     
    Combining the two, we see that
    
    
    .. math:: 
    
        \| A \|_{1 \to p} = \underset{1 \leq j \leq n}{\max}\| a^j \|_p.
    



.. _res:mat:p_to_infty_operator_norm:

.. theorem:: 


    
    
    .. math::
        \| A \|_{p \to \infty} = \underset{1 \leq i \leq m}{\max}\| \underline{a}^i \|_q
    
    where
    
    
    .. math:: 
    
        \frac{1}{p} + \frac{1}{q} = 1.
    



.. proof:: 

    Using :ref:`here <res:mat:operator_norm_conjugate_transpose>`, we
    get 
    
    
    .. math:: 
    
        \| A \|_{p \to \infty} = \| A^H \|_{1 \to q}.
    
    Using :ref:`here <res:mat:1_to_p_operator_norm>`, we get
    
    
    .. math:: 
    
        \| A^H \|_{1 \to q} = \underset{1 \leq i \leq m}{\max}\| \underline{a}^i \|_q.
    
    This completes the proof.




.. _res:mat:p_q_norm_consistency:

.. theorem:: 


    For two matrices :math:`A` and :math:`B` and :math:`p \geq 1`, we have
    
    
    .. math::
        \| A B \|_{p \to q} \leq 
         \| B \|_{p \to s} \| A \|_{s \to q}.
    



.. proof:: 

    We start with
    
    
    .. math:: 
    
        \| A B \|_{p \to q}  = 
        \underset{\| x \|_p = 1}{\max} \| A ( B x) \|_q.
    
    From :ref:`here <lem:mat:operator_norm_subordinate>`, we obtain
    
    
    .. math:: 
    
        \| A ( B x) \|_q \leq 
        \| A \|_{s \to q} \| ( B x) \|_s.
     
    Thus,
    
    
    .. math:: 
    
        \| A B \|_{p \to q}  \leq  \| A \|_{s \to q}
        \underset{\| x \|_p = 1}{\max} \| ( B x) \|_s
        = \| A \|_{s \to q} \| B \|_{p \to s}.
    



.. _res:mat:p_infty_norm_consistency:

.. theorem:: 


    For two matrices :math:`A` and :math:`B` and :math:`p \geq 1`, we have
    
    
    .. math::
        \| A B \|_{p \to \infty} \leq 
        \| A \|_{\infty \to \infty} \| B \|_{p \to \infty}.
    



.. proof:: 

    We start with
    
    
    .. math:: 
    
        \| A B \|_{p \to \infty}  = 
        \underset{\| x \|_p = 1}{\max} \| A ( B x) \|_{\infty}.
    
    From :ref:`here <lem:mat:operator_norm_subordinate>`, we obtain
    
    
    .. math:: 
    
        \| A ( B x) \|_{\infty} \leq 
        \| A \|_{\infty \to \infty} \| ( B x) \|_{\infty}.
     
    Thus,
    
    
    .. math:: 
    
        \| A B \|_{p \to \infty}  \leq  \| A \|_{\infty \to \infty}
        \underset{\| x \|_p = 1}{\max} \| ( B x) \|_{\infty}
        = \| A \|_{\infty \to \infty} \| B \|_{p \to \infty}.
    



.. _res:mat:dominance_p_infty_p_norm:

.. theorem:: 


    
    
    .. math::
        \| A \|_{p \to \infty} \leq \| A \|_{p \to p}.
    
    In particular
    
    
    .. math::
        \| A \|_{1 \to \infty} \leq  \| A \|_{1}.
    
    
    
    .. math::
        \| A \|_{2 \to \infty} \leq  \| A \|_{2}.
    



.. proof:: 

    Choosing :math:`q = \infty` and :math:`s = p` and
    applying :ref:`here <res:mat:p_q_norm_consistency>`
    
    
    .. math:: 
    
        \| I A \|_{p \to \infty} \leq 
         \| A \|_{p \to p} \| I \|_{p \to \infty}.
    
    But :math:`\| I \|_{p \to \infty}` is the maximum :math:`\ell_p`
    norm of any row of :math:`I` which is :math:`1`. Thus
    
    
    .. math:: 
    
        \| A \|_{p \to \infty} \leq  \| A \|_{p \to p}.
    




Consider the expression


.. math::
    \underset{ \substack{z \in \ColSpace(A^H) \\ z \neq 0}}{\min} \frac{\| A z \|_{q}}{\| z \|_p}. 

:math:`z \in  \ColSpace(A^H), z \neq 0` 
means there exists some vector :math:`u \notin \Kernel(A^H)` such that 
:math:`z = A^H u`.

This expression measures the factor by which the non-singular part of :math:`A`
can decrease the length of a vector.


.. _res:mat:bound_range_A_H_p_q_norm_pseudoinverse:

.. theorem:: 


    The following bound holds for every matrix :math:`A`:
    
    
    .. math::
        \underset{\substack{z \in \ColSpace(A^H)  \\ z \neq 0}}{\min} \frac{\| A z \|_{q}}{\| z \|_p}
        \geq \| A^{\dag}\|_{q, p}^{-1}.
    
    If :math:`A` is surjective (onto), then the equality holds. When :math:`A` is bijective (one-one onto, square, invertible),
    then the result implies
    
    
    .. math::
        \underset{\substack{z \in \ColSpace(A^H) \\ z \neq 0}}{\min} \frac{\| A z \|_{q}}{\| z \|_p}
        = \| A^{-1}\|_{q, p}^{-1}.
    



.. proof:: 

    The spaces :math:`\ColSpace(A^H)` and :math:`\ColSpace(A)` 
    have same dimensions given by :math:`\Rank(A)`. 
    We recall that :math:`A^{\dag} A` is a projector onto the column space of :math:`A`. 
     
    
    .. math:: 
    
         w = A z \iff z = A^{\dag} w = A^{\dag} A z \Forall z \in \ColSpace (A^H).
    
    As a result we can write
     
    .. math:: 
    
         \frac{\| z \|_p}{ \| A z \|_q} =  \frac{\| A^{\dag} w \|_p}{ \| w \|_q} 
    
    whenever :math:`z \in \ColSpace(A^H)`. Now
     
    .. math:: 
    
         \left [ \underset{\substack{z \in \ColSpace(A^H)\\z \neq 0}}{\min} \frac{\| A z \|_q}{\| z \|_p}\right ]^{-1}
        = \underset{\substack{z \in \ColSpace(A^H)\\z \neq 0}}{\max} \frac{\| z \|_p}{ \| A z \|_q}
        = \underset{\substack{w \in \ColSpace(A) \\ w \neq 0}}{\max} \frac{\| A^{\dag} w \|_p}{ \| w \|_q} 
        \leq \underset{w \neq 0}{\max} \frac{\| A^{\dag} w \|_p}{ \| w \|_q}.
    
    When :math:`A` is surjective, then :math:`\ColSpace(A) = \CC^m`. Hence
    
    
    .. math:: 
    
        \underset{\substack{w \in \ColSpace(A)\\w \neq 0}}{\max} \frac{\| A^{\dag} w \|_p}{ \| w \|_q} 
        = \underset{w \neq 0}{\max} \frac{\| A^{\dag} w \|_p}{ \| w \|_q}.
    
    Thus, the inequality changes into equality.
    Finally
    
    .. math:: 
    
        \underset{w \neq 0}{\max} \frac{\| A^{\dag} w \|_p}{ \| w \|_q} = \| A^{\dag} \|_{q \to p}
    
    which completes the proof.
    


.. _sec:mat:row_column_norms:
 
Row column norms
----------------------------------------------------


.. index:: Row column norms


.. _def:mat:row_column_norm:

.. definition:: 

    Let :math:`A` be an :math:`m\times n` matrix with rows :math:`\underline{a}^i` as
    
    
    .. math:: 
    
        A = \begin{bmatrix}
        \underline{a}^1\\
        \vdots \\
        \underline{a}^m
        \end{bmatrix}
    
    Then we define
    
    
    .. math::
        \| A \|_{p, \infty} 
        \triangleq \underset{1 \leq i \leq m}{\max} \| \underline{a}^i \|_p
        = \underset{1 \leq i \leq m}{\max} \left ( \sum_{j=1}^n |\underline{a}^i_j |^p \right )^{\frac{1}{p}}
    
    where :math:`1 \leq p < \infty`. i.e. we take :math:`p`-norms of all row vectors
    and then find the maximum.
    
    We define 
    
    
    .. math::
        \| A \|_{\infty, \infty} = \underset{i, j}{\max} |a_{i j}|. 
    
    This is equivalent to taking :math:`\ell_{\infty}` norm on each row and then taking
    the maximum of all the norms.
    
    For :math:`1 \leq p , q < \infty`, we define the norm
    
    
    .. math::
        \| A \|_{p, q} 
        \triangleq \left [ \sum_{i=1}^m \left ( \| \underline{a}^i \|_p \right )^q \right ]^{\frac{1}{q}}.
    
    i.e., we compute :math:`p`-norm of all the row vectors to form another vector
    and then take :math:`q`-norm of that vector.

Note that the norm :math:`\| A \|_{p, \infty}` 
is different from the operator norm :math:`\| A \|_{p \to \infty}`.
Similarly :math:`\| A \|_{p, q}` is different from :math:`\| A \|_{p \to q}`.


.. _res:row_col_norm_p_infty_norm:

.. theorem:: 


    
    
    .. math::
        \| A \|_{p, \infty}  = \| A \|_{q \to \infty}
    
    where 
    
    
    .. math:: 
    
        \frac{1}{p} + \frac{1}{q} = 1.
    



.. proof:: 

    From :ref:`here <res:mat:p_to_infty_operator_norm>` we get
    
    
    .. math:: 
    
        \| A \|_{q \to \infty} = \underset{1 \leq i \leq m}{\max}\| \underline{a}^i \|_p.
    
    This is exactly the definition of :math:`\| A \|_{p, \infty}`.




.. _res:row_col_norm_1_p_norm:

.. theorem:: 


    
    
    .. math::
        \| A \|_{1 \to p} = \| A \|_{p, \infty}. 
    



.. proof:: 

    
    
    .. math:: 
    
        \| A \|_{1 \to p} = \| A^H \|_{q \to \infty}.
    
    From :ref:`here <res:row_col_norm_p_infty_norm>`
    
    
    .. math:: 
    
        \| A^H \|_{q \to \infty} = \| A^H \|_{p, \infty}.
    



.. _res:mat:consistency_p_infty_row_col_norm:

.. theorem:: 


    For any two matrices :math:`A, B`, we have
    
    
    .. math::
        \frac{\|A B \|_{p, \infty}}{\| B\|_{p, \infty}} 
        \leq \| A \|_{\infty \to \infty}.
    



.. proof:: 

    Let :math:`q` be such that :math:`\frac{1}{p} + \frac{1}{q} = 1`.
    From :ref:`here <res:mat:p_infty_norm_consistency>`, we have
    
    
    .. math:: 
    
        \| A B \|_{q \to \infty} \leq 
        \| A \|_{\infty \to \infty} \| B \|_{q \to \infty}.
    
    From :ref:`here <res:row_col_norm_p_infty_norm>`
    
    
    .. math:: 
    
        \| A B \|_{q \to \infty} = \| A B\|_{p, \infty}
    
    and 
    
    
    .. math:: 
    
        \| B \|_{q \to \infty} = \| B\|_{p, \infty}.
    
    Thus
    
    
    .. math:: 
    
        \| A B\|_{p, \infty} \leq \| A \|_{\infty \to \infty} \| B\|_{p, \infty}.
    




.. _res:mat:p_q_p_to_q_relations:

.. theorem:: 


    Relations between :math:`(p, q)` norms and :math:`(p \to q)` norms
    
    
    .. math::
        \| A \|_{1, \infty}  = \| A \|_{\infty \to \infty}
    
    
    
    .. math::
        \| A \|_{2, \infty}  = \| A \|_{2 \to \infty}
    
    
    
    .. math::
        \| A \|_{\infty, \infty}  = \| A \|_{1 \to \infty}
    
    
    
    .. math::
        \| A \|_{1 \to 1} = \| A^H \|_{1, \infty}
    
    
    
    .. math::
        \| A \|_{1 \to 2} = \| A^H \|_{2, \infty}
    
    
    
    .. math::
    
    



.. proof:: 

    The first three are straight forward applications of
    :ref:`here <res:row_col_norm_p_infty_norm>`.
    The next two are applications of :ref:`here <res:row_col_norm_1_p_norm>`.
    See also :ref:`here <tbl:mat:calculation_p_q_operator_norms>`.
    




 
Block diagonally dominant matrices and generalized Gershgorin disc theorem
-----------------------------------------------------------------------------

In :cite:`feingold1962block` the idea of diagonally dominant matrices (see :ref:`here <sec:mat:diagonally_dominant_matrix>`)
has been generalized to block matrices using matrix norms. We consider the specific case with spectral norm. 

.. index:: Block diagonally dominant matrix
.. index:: Block strictly diagonally dominant matrix

.. _def:mat:block_diagonally_dominant_matrix:

.. definition:: 


    Let :math:`A` be a square matrix in :math:`\CC^{n \times n}` which is partitioned in following manner
    
    
    .. math::
        A = \begin{bmatrix}
        A_{11} & A_{12} & \dots & A_{1 k}\\
        A_{21} & A_{22} & \dots & A_{2 k}\\
        \vdots & \vdots & \ddots & \vdots\\
        A_{k 1} & A_{k 2} & \dots & A_{k k}\\
        \end{bmatrix}
    
    where each of the submatrices :math:`A_{i j}` is a square matrix of size :math:`m \times m`. Thus :math:`n = k m`.
    
    :math:`A` is called **block diagonally dominant** if 
    
    
    .. math:: 
    
        \| A_{ii}\|_2 \geq \sum_{j \neq i } \|A_{ij} \|_2. 
    
    holds true for all :math:`1 \leq i \leq n`. 
    If the inequality satisfies strictly for all :math:`i`, then :math:`A` is called
    **block strictly diagonally dominant matrix**.



.. _thm:mat:block_diagonally_dominant_matrix_nonsingular:

.. theorem:: 


    If the partitioned matrix :math:`A` of :ref:`here <def:mat:block_diagonally_dominant_matrix>` is
    block strictly diagonally dominant matrix, then it is nonsingular. 

For proof see :cite:`feingold1962block`.

This leads to the generalized Gershgorin disc theorem.


.. _thm:block_gershgorin_disc_theorem:

.. theorem:: 


    Let :math:`A` be a square matrix in :math:`\CC^{n \times n}` which is partitioned in following manner
    
    
    .. math::
        A = \begin{bmatrix}
        A_{11} & A_{12} & \dots & A_{1 k}\\
        A_{21} & A_{22} & \dots & A_{2 k}\\
        \vdots & \vdots & \ddots & \vdots\\
        A_{k 1} & A_{k 2} & \dots & A_{k k}\\
        \end{bmatrix}
    
    where each of the submatrices :math:`A_{i j}` is a square matrix of size :math:`m \times m`.
    Then each eigenvalue :math:`\lambda` of :math:`A` satisfies 
    
    
    .. math::
        \| \lambda I  - A_{ii}\|_2 \leq \sum_{j\neq i} \|A_{ij} \| \text{ for some } i \in \{1,2, \dots, n \}.
    

For proof see :cite:`feingold1962block`.


Since the :math:`2`-norm of a  positive semidefinite matrix is nothing but its largest eigen value, the theorem
directly applies.



.. _col:block_gershgorin_disc_theorem_psd_matrix:

.. corollary:: 


    Let :math:`A` be a Hermitian positive semidefinite matrix. 
    Let :math:`A` be partitioned as in :ref:`here <thm:block_gershgorin_disc_theorem>`. 
    Then its :math:`2`-norm  :math:`\| A \|_2` satisfies
    
    
    .. math::
         | \| A \|_2  - \|A_{ii}\|_2 | \leq \sum_{j\neq i} \|A_{ij} \| \text{ for some } i \in \{1,2, \dots, n \}.
    


.. disqus::
