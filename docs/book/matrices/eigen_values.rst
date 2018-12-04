
 
Eigen values
===================================================

Much of the discussion in this section will be equally applicable to real
as well as complex matrices. We will use the complex notation mostly and
make specific remarks for real matrices wherever needed.

.. index:: Eigen value
.. index:: Eigen vector
.. index:: Characteristic value
.. index:: Proper value
.. index:: Latent value


.. _def:mat:eigen_value:

.. definition:: 

    A scalar :math:`\lambda` is an **eigen value** of an :math:`n \times n` matrix :math:`A = [ a_{ij} ]`
    if there exists a non null vector :math:`x` such that
    
    
    .. math::
        :label: eq:mat:eigen_value
    
        Ax = \lambda x.
    
    A non null vector :math:`x` which satisfies this equation is called an **eigen vector**
    of :math:`A` for the eigen value :math:`\lambda`.
    
    An eigen value is also known as a **characteristic value**, **proper value**
    or a **latent value**.


We note that :eq:`eq:mat:eigen_value` can be written as



.. math::
    Ax  = \lambda I_n x \implies  (A - \lambda I_n) x  = 0.

Thus :math:`\lambda` is an eigen value of :math:`A` if and only if the matrix :math:`A - \lambda I` is
singular.


.. index:: Spectrum of a matrix

.. _def:mat:spectrum:

.. definition:: 


    The set comprising of eigen values of a matrix :math:`A` is known as its **spectrum**.




.. remark:: 

    For each eigen vector :math:`x` for a matrix :math:`A` the corresponding eigen value :math:`\lambda` is
    unique.



.. proof:: 

    Assume that for :math:`x` there are two eigen values :math:`\lambda_1` and :math:`\lambda_2`, then
    
    
    .. math:: 
    
        A x = \lambda_1 x = \lambda_2 x \implies (\lambda_1 - \lambda_2 ) x = 0.
    
    This can happen only when either :math:`x = 0` or :math:`\lambda_1 = \lambda_2`. Since :math:`x` is
    an eigen vector, it cannot be 0. Thus :math:`\lambda_1 = \lambda_2`.




.. remark:: 

    If :math:`x` is an eigen vector for :math:`A`, then the corresponding eigen value is given by
    
    
    .. math::
        \lambda = \frac{x^H A x }{x^H x}.
    



.. proof:: 

    
    
    .. math:: 
    
        A x = \lambda x \implies x^H A x = \lambda x^H x \implies \lambda = \frac{x^H A x }{x^H x}.
    
    since :math:`x` is non-zero.




.. remark:: 

    An eigen vector :math:`x` of :math:`A`  for eigen value :math:`\lambda` belongs to the null space of :math:`A - \lambda I`, 
    i.e.
    
    
    .. math:: 
    
        x \in \NullSpace(A - \lambda I).
    
    In other words :math:`x` is a nontrivial solution to the homogeneous system of linear equations given by
    
    
    .. math:: 
    
        (A - \lambda I) z = 0.
    


.. index:: Eigen space


.. _def:mat:eigen_space:

.. definition:: 

    Let :math:`\lambda` be an eigen value for a square matrix :math:`A`. Then its **eigen space**
    is the null space of :math:`A - \lambda I` i.e. :math:`\NullSpace(A - \lambda I)`. 




.. remark:: 

    The set comprising all the eigen vectors of :math:`A` for an eigen value :math:`\lambda` is
    given by
    
    
    .. math::
        \NullSpace(A - \lambda I) \setminus \{ 0 \}
    
    since :math:`0` cannot be an eigen vector.



.. index:: Geometric multiplicity

.. _def:mat:eigen:geometric_multiplicity:

.. definition:: 


    Let :math:`\lambda` be an eigen value for a square matrix :math:`A`. 
    The dimension of its eigen space :math:`\NullSpace(A - \lambda I)` is known as
    the **geometric multiplicity** of the eigen value :math:`\lambda`.




.. remark:: 

    Clearly
    
    
    .. math:: 
    
        \dim (\NullSpace(A - \lambda I)) = n - \Rank(A - \lambda I).
    




.. remark:: 

    A scalar :math:`\lambda` can be an eigen value of a square matrix :math:`A` if and only if
    
    
    .. math:: 
    
        \det (A - \lambda I) = 0.
    


:math:`\det (A - \lambda I)` is a polynomial in :math:`\lambda` of degree :math:`n`.


.. remark:: 

    
    
    .. math::
        \det (A - \lambda I) = p(\lambda) = \alpha^n \lambda^n + \alpha^{n-1} \lambda^{n-1} + \dots 
        + \alpha^1 \lambda + \alpha_0
    
    where :math:`\alpha_i` depend on entries in :math:`A`.
    
    In this sense, an eigen value of :math:`A` is a root of the equation
    
    
    .. math::
        p(\lambda) = 0.
    
    Its easy to show that :math:`\alpha^n = (-1)^n`.


.. index:: Characteristic polynomial
.. index:: Characteristic equation


.. _def:mat:characteristic_polynomial:

.. definition:: 

    For any square matrix :math:`A`, the polynomial given by :math:`p(\lambda) = \det(A - \lambda I )` 
    is known as its **characteristic polynomial**. The equation give by
    
    
    .. math::
        p(\lambda) = 0
    
    is known as its **characteristic equation**.
    The eigen values of :math:`A` are the roots of its characteristic polynomial or
    solutions of its characteristic equation.




.. lemma:: 

    For real square matrices, if we restrict eigen values to real values, then 
    the characteristic polynomial can be factored as
    
    
    .. math::
        p(\lambda) = (-1)^n (\lambda - \lambda_1)^{r_1} \dots (\lambda - \lambda_k)^{r_k} q(\lambda).
    
    The polynomial has :math:`k` distinct real roots. For each root :math:`\lambda_i`, :math:`r_i` is a positive
    integer indicating how many times the root appears. :math:`q(\lambda)` is a polynomial that
    has no real roots. The following is true
    
    
    .. math::
        r_1 + \dots + r_k + deg(q(\lambda)) = n.
    
    Clearly :math:`k \leq n`.
    
    For complex square matrices where eigen values can be complex (including real square matrices),
    the characteristic polynomial can be factored as
    
    
    .. math::
        p(\lambda) = (-1)^n (\lambda - \lambda_1)^{r_1} \dots (\lambda - \lambda_k)^{r_k}.
    
    The polynomial can be completely factorized into first degree polynomials. There are
    :math:`k` distinct roots or eigen values. The following is true
    
    
    .. math::
        r_1 + \dots + r_k = n.
    
    Thus including the duplicates there are exactly :math:`n` eigen values for a complex square matrix.



.. remark:: 

    It is quite possible that a real square matrix doesn't have any real eigen values.


.. index:: Algebraic multiplicity


.. _def:mat:eigen:algebraic_multiplicity:

.. definition:: 

    The number of times an eigen value appears in the factorization of the characteristic polynomial
    of a square matrix :math:`A` is known as its algebraic multiplicity. In other words
    :math:`r_i` is the algebraic multiplicity for :math:`\lambda_i` in above factorization.




.. remark:: 

    In above the set :math:`\{\lambda_1, \dots, \lambda_k \}` forms the spectrum of :math:`A`.


Let us consider the sum of :math:`r_i` which gives the count of total number of roots
of :math:`p(\lambda)`.


.. math::
    m = \sum_{i=1}^k r_i.




With this there are :math:`m` not-necessarily distinct roots of :math:`p(\lambda)`. 
Let us write :math:`p(\lambda)` as


.. math::
    p(\lambda) = (-1)^n (\lambda - c_1) (\lambda - c_2)\dots (\lambda - c_m)q(\lambda).

where :math:`c_1, c_2, \dots, c_m` are :math:`m` scalars (not necessarily distinct) of which
:math:`r_1` scalars are :math:`\lambda_1`, :math:`r_2` are :math:`\lambda_2` and so on. Obviously for 
the complex case :math:`q(\lambda)=1`.

We will refer to the set (allowing repetitions) 
:math:`\{c_1, c_2, \dots, c_m \}` as the eigen values of the
matrix :math:`A` where :math:`c_i` are not necessarily distinct. In contrast the spectrum
of :math:`A` refers to the set of distinct eigen values of :math:`A`.
The symbol :math:`c` has been chosen based on the other name for eigen values (the characteristic
values).

We can put together eigen vectors of a matrix into another matrix by itself. This
can be very useful tool. We start with a simple idea.



.. lemma:: 

    Let :math:`A` be an :math:`n \times n` matrix.
    Let :math:`u_1, u_2, \dots, u_r` be :math:`r` non-zero vectors from :math:`\FF^n`. Let us construct 
    an :math:`n \times r` matrix
    
    
    .. math:: 
    
        U = \begin{bmatrix} u_1 & u_2 & \dots & u_r \end{bmatrix}.
    
    Then all the :math:`r` vectors are eigen vectors of :math:`A` if and only if
    there exists a diagonal matrix :math:`D = \Diag(d_1, \dots, d_r)` such that
    
    
    .. math::
        A U  = U D.
    



.. proof:: 

    Expanding the equation, we can write
    
    
    .. math:: 
    
        \begin{bmatrix} A u_1 & A u_2 & \dots & A u_r \end{bmatrix}
        =
        \begin{bmatrix} d_1 u_1 & d_2 u_2 & \dots & d_r u_r \end{bmatrix}.
    
    Clearly we want
    
    
    .. math:: 
    
        A u_i = d_i u_i
    
    where :math:`u_i` are non-zero.
    This is possible only when :math:`d_i` is an eigen value of :math:`A` and :math:`u_i` is
    an eigen vector for :math:`d_i`.
    
    Converse: Assume that :math:`u_i` are eigen vectors. Choose :math:`d_i` to be
    corresponding eigen values. Then the equation holds. 




.. lemma:: 

    :math:`0` is an eigen value of a square matrix :math:`A` if and only if :math:`A` is singular.



.. proof:: 

    Let :math:`0` be an eigen value of :math:`A`. Then there exists :math:`u \neq 0` such that
    
    
    .. math:: 
    
        A u = 0 u = 0.
    
    Thus :math:`u` is a non-trivial solution of the homogeneous linear system. Thus :math:`A` is singular.
    
    Converse: Assuming that :math:`A` is singular, there exists :math:`u \neq 0` s.t.
    
    
    .. math:: 
    
        A u = 0 = 0 u.
    
    Thus :math:`0` is an eigen value of :math:`A`.




.. lemma:: 

    If a square matrix :math:`A` is singular, then :math:`\NullSpace(A)` is the eigen space for the eigen value :math:`\lambda = 0`.



.. proof:: 

    This is straight forward from the definition of eigen space (see :ref:`here <def:mat:eigen_space>`).




.. remark:: 

    Clearly the geometric multiplicity of :math:`\lambda=0` equals :math:`\Nullity(A) = n  - \Rank(A)`.




.. lemma:: 

    Let :math:`A` be a square matrix. Then :math:`A` and :math:`A^T` have same eigen values.



.. proof:: 

    The eigen values of :math:`A^T` are given by 
    
    
    .. math:: 
    
        \det (A^T - \lambda I) = 0.
    
    But
    
    
    .. math:: 
    
        A^T - \lambda I = A^T - (\lambda I )^T = (A - \lambda I)^T.
    
    Hence (using :ref:`here <lem:mat:determinant_transpose_rule>`)
    
    
    .. math:: 
    
        \det (A^T - \lambda I)  = \det \left (  (A - \lambda I)^T \right ) = \det (A - \lambda I).
    
    Thus the characteristic polynomials of :math:`A` and :math:`A^T` are same. Hence the eigen values are same.
    In other words the spectrum of :math:`A` and :math:`A^T` are same.







.. remark:: 

    If :math:`x` is an eigen vector with a non-zero eigen value :math:`\lambda` for
    :math:`A` then :math:`Ax` and :math:`x` are collinear.
    
    In other words the angle between :math:`Ax` and :math:`x` is either :math:`0^{\circ}` 
    when :math:`\lambda` is positive and is :math:`180^{\circ}` when :math:`\lambda` is
    negative. Let us look at the inner product:
    
    
    .. math:: 
    
        \langle Ax, x \rangle = x^H A x = x^H \lambda x = \lambda \| x\|_2^2.
    
    Meanwhile
    
    
    .. math:: 
    
        \| A x \|_2 = \| \lambda x \|_2 = |\lambda| \| x \|_2. 
    
    Thus
    
    
    .. math:: 
    
        |\langle Ax, x \rangle |  = \| Ax \|_2 \| x \|_2.
    
    The angle :math:`\theta` between :math:`Ax` and :math:`x` is given by
    
    
    .. math:: 
    
        \cos \theta = \frac{\langle Ax, x \rangle}{\| Ax \|_2 \| x \|_2} 
        = \frac{\lambda \| x\|_2^2}{|\lambda| \| x \|_2^2} = \pm 1.
    



.. _lem:mat:eigen:power_rule:

.. lemma:: 


    Let :math:`A` be a square matrix and :math:`\lambda` be an eigen value of :math:`A`. Let :math:`p \in \Nat`. 
    Then :math:`\lambda^p` is an eigen value of :math:`A^{p}`.



.. proof:: 

    For :math:`p=1` the statement holds trivially since :math:`\lambda^1` is an eigen value of :math:`A^1`.
    Assume that the statement holds for some value of :math:`p`. Thus let :math:`\lambda^p` be an eigen
    value of :math:`A^{p}` and let :math:`u` be corresponding eigen vector. Now
    
    
    .. math:: 
    
        A^{p + 1} u = A^ p ( A u) = A^{p} \lambda u  = \lambda A^{p} u = \lambda \lambda^p u = \lambda^{p + 1} u. 
    
    Thus :math:`\lambda^{p + 1}` is an eigen value for :math:`A^{p + 1}` with the same eigen vector :math:`u`. With the
    principle of mathematical induction, the proof is complete.




.. lemma:: 

    Let a square matrix :math:`A` be non singular and let :math:`\lambda \neq 0` be some eigen value of :math:`A`. Then
    :math:`\lambda^{-1}` is an eigen value of :math:`A^{-1}`.
    Moreover, all eigen values of :math:`A^{-1}` are obtained by taking inverses of eigen values of :math:`A` i.e.
    if :math:`\mu \neq 0` is an eigen value of :math:`A^{-1}` then :math:`\frac{1}{\mu}` is an eigen value of :math:`A` also.
    Also, :math:`A` and :math:`A^{-1}` share the same set of eigen vectors.



.. proof:: 

    Let :math:`u \neq 0` be an eigen vector of :math:`A` for the eigen value :math:`\lambda`. Then
    
    
    .. math:: 
    
        A u = \lambda u \implies u = A^{-1} \lambda u \implies \frac{1}{\lambda} u = A^{-1} u.
    
    Thus :math:`u` is also an eigen vector of :math:`A^{-1}`  for the eigen value :math:`\frac{1}{\lambda}`.
    
    Now let :math:`B = A^{-1}`. Then :math:`B^{-1} = A`. Thus if :math:`\mu` is an eigen value of :math:`B` then
    :math:`\frac{1}{\mu}` is an eigen value of :math:`B^{-1} = A`. 
    
    Thus if  :math:`A` is invertible then eigen values of :math:`A` and :math:`A^{-1}` have one to one correspondence.


This result is very useful. Since if it can be shown that a matrix :math:`A` is similar to a
diagonal or a triangular matrix whose eigen values are easy to obtain then determination
of the eigen values of :math:`A` becomes straight forward.

 
Invariant subspaces
----------------------------------------------------


.. index:: Invariant subspace

.. _def:mat:invariant_subspace:

.. definition:: 

    Let :math:`A` be a square :math:`n\times n` matrix and let :math:`\WW` be a subspace
    of :math:`\FF^n` i.e. :math:`\WW \leq \FF`. Then :math:`\WW` is **invariant** relative
    to :math:`A` if 
    
    
    .. math::
        A w \in \WW \Forall w \in \WW.
    
    i.e. :math:`A (W) \subseteq W` or for every vector :math:`w \in \WW` its mapping
    :math:`A w` is also in :math:`\WW`. Thus action of :math:`A` on :math:`\WW` doesn't take us
    outside of :math:`\WW`.
    
    We also say that :math:`\WW` is :math:`A`-invariant.


Eigen vectors are generators of invariant subspaces. 


.. _lem:mat:span_of_eigenvectors_invariant:

.. lemma:: 

    Let :math:`A` be an :math:`n \times n` matrix.
    Let :math:`x_1, x_2, \dots, x_r` be :math:`r` eigen vectors of :math:`A`. 
    Let us construct 
    an :math:`n \times r` matrix
    
    
    .. math:: 
    
        X = \begin{bmatrix} x_1 & x_2 & \dots & r_r \end{bmatrix}.
    
    Then the column space of :math:`X` i.e. :math:`\ColSpace(X)` is invariant relative to :math:`A`.




.. proof:: 

    Let us assume that :math:`c_1, c_2, \dots, c_r` are the eigen values
    corresponding to :math:`x_1, x_2, \dots, x_r` (not necessarily distinct).
    
    Let any vector :math:`x \in \ColSpace(X)` be given by
    
    
    .. math:: 
    
        x = \sum_{i=1}^r \alpha_i x_i.
    
    Then 
    
    
    .. math:: 
    
        A x=  A \sum_{i=1}^r \alpha_i x_i = \sum_{i=1}^r \alpha_i A x_i = \sum_{i=1}^r \alpha_i c_i x_i.
    
    Clearly :math:`Ax` is also a linear combination of :math:`x_i` hence belongs to :math:`\ColSpace(X)`. Thus
    :math:`X` is invariant relative to :math:`A` or :math:`X` is :math:`A`-invariant.


 
Triangular matrices
----------------------------------------------------


.. _lem:mat:eig:triangular_matrix_diagonal:

.. lemma:: 


    Let :math:`A` be an :math:`n\times n` upper or lower triangular matrix. Then its eigen values are the
    entries on its main diagonal.



.. proof:: 

    If :math:`A` is triangular then :math:`A - \lambda I` is also triangular
    with its diagonal entries being :math:`(a_{i i} - \lambda)`. Using 
    :ref:`here <lem:determinant_triangular_matrix_rule>`, we have
    
    
    .. math:: 
    
        p(\lambda) = \det (A - \lambda I) = \prod_{i=1}^n (a_{i i} - \lambda).
    
    Clearly the roots of characteristic polynomial are :math:`a_{i i}`.

Several small results follow from this lemma.


.. corollary:: 

    Let :math:`A = [a_{i j}]` be an :math:`n \times n` triangular matrix.

    a. The characteristic polynomial of :math:`A` is 
       :math:`p(\lambda) = (-1)^n (\lambda - a_{i i})`.
    #. A scalar :math:`\lambda` is an eigen value of 
       :math:`A` iff its one of the diagonal entries of :math:`A`.
    #. The algebraic multiplicity of an eigen value 
       :math:`\lambda` is equal to the number of times
       it appears on the main diagonal of :math:`A`.
    #. The spectrum of :math:`A` is given by the distinct entries 
       on the main diagonal of :math:`A`. 
    


A diagonal matrix is naturally both an upper triangular matrix as well as a lower triangular matrix.
Similar results hold for the eigen values of a diagonal matrix also.

.. _lem:mat:eig:diagonal_matrix_diagonal:

.. lemma:: 


    Let :math:`A = [a_{i j}]` be an :math:`n \times n` diagonal matrix.

    a. Its eigen values are the entries on its main diagonal.
    #. The characteristic polynomial of :math:`A` is 
       :math:`p(\lambda) = (-1)^n (\lambda - a_{i i})`.
    #. A scalar :math:`\lambda` is an eigen value of :math:`A` 
       iff its one of the diagonal entries of :math:`A`.
    #. The algebraic multiplicity of an eigen value :math:`\lambda` is 
       equal to the number of times it appears on the main diagonal 
       of :math:`A`.
    #. The spectrum of :math:`A` is given by the distinct entries on 
       the main diagonal of :math:`A`. 

There is also a result for the geometric multiplicity of eigen values for a diagonal matrix.


.. lemma:: 

    Let :math:`A = [a_{i j}]` be an :math:`n \times n` diagonal matrix.
    The geometric multiplicity of an eigen value :math:`\lambda` is equal to the number of times
    it appears on the main diagonal of :math:`A`.



.. proof:: 

    The unit vectors :math:`e_i` are eigen vectors for :math:`A` since
    
    
    .. math:: 
    
        A e_i = a_{i i } e_i.
    
    They are independent. Thus if a particular eigen value appears :math:`r` number of times, then
    there are :math:`r` linearly independent eigen vectors for the eigen value. Thus its geometric
    multiplicity is equal to the algebraic multiplicity.


 
Similar matrices
----------------------------------------------------

Some very useful results are available for similar matrices.


.. _lem:mat:eig:simlar_matrix_spectrum:

.. lemma:: 

    The characteristic polynomial and spectrum of similar matrices is same.




.. proof:: 

    Let :math:`B` be similar to :math:`A`. Thus there exists an invertible matrix :math:`C` such that
    
    
    .. math:: 
    
        B   = C^{-1} A C.
    
    Now
    
    
    .. math:: 
    
        B - \lambda I = C^{-1} A C - \lambda I = C^{-1} A C - \lambda C^{-1} C =   C^{-1}  ( AC - \lambda C) =  C^{-1} (A - \lambda I) C.
    
    Thus :math:`B - \lambda I` is similar to :math:`A - \lambda I`. Hence due to 
    :ref:`here <lem:determinant_simlar_matrix_rule>`, their determinant is equal i.e.
    
    
    .. math:: 
    
        \det(B - \lambda I ) = \det(A - \lambda I ).
    
    This means that the characteristic polynomials of :math:`A` and :math:`B` are same. Since eigen values are nothing but
    roots of the characteristic polynomial, hence they are same too. This means that the spectrum (the set of
    distinct eigen values) is same.




.. corollary:: 

    If :math:`A` and :math:`B` are similar to each other then

    a. An eigen value has same algebraic and geometric multiplicity for 
       both :math:`A` and :math:`B`.
    #. The (not necessarily distinct) eigen values of :math:`A` 
       and :math:`B` are same.

Although the eigen values are same, but the eigen vectors are different.

.. _lem:mat:eig:similar_matrix_eigen_value:

.. lemma:: 

    Let :math:`A` and :math:`B` be similar with 
    
    
    .. math:: 
    
        B   = C^{-1} A C
    
    for some invertible matrix :math:`C`. If :math:`u` is an eigen vector of :math:`A` for an eigen value :math:`\lambda`, then :math:`C^{-1} u` 
    is an eigen vector of :math:`B` for the same eigen value.




.. proof:: 

    :math:`u` is an eigen vector of :math:`A` for an eigen value :math:`\lambda`. Thus we have
    
    
    .. math:: 
    
        A u  = \lambda u.
    
    Thus
    
    
    .. math:: 
    
        B C^{-1} u  = C^{-1} A C  C^{-1} u = C^{-1} A u = C^{-1} \lambda u = \lambda C^{-1} u.
    
    Now :math:`u \neq 0` and :math:`C^{-1}` is non singular. Thus :math:`C^{-1} u \neq 0`. Thus :math:`C^{-1}u` is an eigen vector of :math:`B`.
    




.. _thm:mat:eig_geometric_algebraic_multiplicity:

.. theorem:: 

    Let :math:`\lambda` be an eigen value of a square matrix :math:`A`. Then the geometric multiplicity 
    of :math:`\lambda` is less than or equal to its algebraic multiplicity.






.. corollary:: 

    If an :math:`n \times n` matrix :math:`A` has :math:`n` distinct eigen values, then each of them has a geometric (and algebraic)
    multiplicity of :math:`1`. 



.. proof:: 

    The algebraic multiplicity of an eigen value is greater than or equal to 1. But the sum cannot
    exceed :math:`n`. Since there are :math:`n` distinct eigen values, thus each of them has algebraic multiplicity of :math:`1`.
    Now geometric multiplicity of an eigen value is greater than equal to 1 and less than equal to its algebraic
    multiplicity. 




.. corollary:: 

    Let an :math:`n \times n` matrix :math:`A` has :math:`k` distinct eigen values :math:`\lambda_1, \lambda_2, \dots, \lambda_k` 
    with algebraic multiplicities  :math:`r_1, r_2, \dots, r_k` and geometric multiplicities :math:`g_1, g_2, \dots g_k` 
    respectively. Then
    
    
    .. math:: 
    
        \sum_{i=1}^k g_k \leq \sum_{i=1}^k r_k \leq n. 
    
    Moreover if
    
    
    .. math:: 
    
        \sum_{i=1}^k g_k = \sum_{i=1}^k r_k 
    
    then
    
    
    .. math:: 
    
        g_k = r_k.
    


 
Linear independence of eigen vectors
----------------------------------------------------



.. _thm:mat:eig:independence_distinc_eigen_values:

.. theorem:: 


    Let :math:`A` be an :math:`n\times n` square matrix. Let :math:`x_1, x_2, \dots , x_k` be any :math:`k` eigen vectors
    of :math:`A` for distinct eigen values :math:`\lambda_1, \lambda_2, \dots, \lambda_k` respectively. Then
    :math:`x_1, x_2, \dots , x_k`  are linearly independent.



.. proof:: 

    We first prove the simpler case with 2 eigen vectors :math:`x_1` and :math:`x_2` and corresponding eigen values
    :math:`\lambda_1` and :math:`\lambda_2` respectively.
    
    Let there be a linear relationship between :math:`x_1` and :math:`x_2` given by
    
    
    .. math:: 
    
        \alpha_1 x_1 + \alpha_2 x_2 = 0.
    
    Multiplying both sides with :math:`(A - \lambda_1 I)` we get
    
    
    .. math:: 
    
        \begin{aligned}
        & \alpha_1 (A - \lambda_1 I) x_1 + \alpha_2(A - \lambda_1 I) x_2  = 0\\
        \implies & \alpha_1 (\lambda_1 - \lambda_1) x_1 + \alpha_2(\lambda_1  - \lambda_2) x_2 = 0\\
        \implies & \alpha_2(\lambda_1 - \lambda_2) x_2 = 0.
        \end{aligned}
    
    Since :math:`\lambda_1 \neq \lambda_2` and :math:`x_2 \neq 0` , hence :math:`\alpha_2 = 0`.
    
    Similarly by multiplying with :math:`(A - \lambda_2 I)` on both sides, we can show that :math:`\alpha_1 = 0`.
    Thus :math:`x_1` and :math:`x_2` are linearly independent. 
    
    Now for the general case, consider a linear relationship between :math:`x_1, x_2, \dots , x_k`  given by
    
    
    .. math:: 
    
        \alpha_1 x_1 + \alpha_2 x_2 + \dots \alpha_k x_k = 0.
    
    
    Multiplying by :math:`\prod_{i \neq j, i=1}^k (A - \lambda_i I)` and using the fact that :math:`\lambda_i \neq \lambda_j` if :math:`i \neq j`, 
    we get :math:`\alpha_j = 0`. Thus the only linear relationship is the trivial relationship. This completes the proof.


For eigen values with geometric multiplicity greater than :math:`1` there are multiple eigenvectors corresponding
to the eigen value which are linearly independent. In this context, above theorem can be generalized further.



.. _thm:mat:eig:independence_distinc_eigen_values_general:

.. theorem:: 


    Let :math:`\lambda_1, \lambda_2, \dots, \lambda_k` be :math:`k` distinct eigen values of :math:`A`. 
    Let :math:`\{x_1^j, x_2^j, \dots x_{g_j}^j\}` be any :math:`g_j` linearly independent eigen vectors from 
    the eigen space of :math:`\lambda_j` where :math:`g_j` is the geometric multiplicity of :math:`\lambda_j`. 
    Then the combined set of eigen vectors given by
    :math:`\{x_1^1, \dots x_{g_1}^1, \dots x_1^k, \dots x_{g_k}^k\}` consisting of :math:`\sum_{j=1}^k g_j` 
    eigen vectors is linearly independent.


This result puts an upper limit on the number of linearly independent eigen vectors of a square matrix.


.. lemma:: 

    Let :math:`\{ \lambda_1, \dots, \lambda_k \}` represents the spectrum of an :math:`n \times n` matrix :math:`A`. 
    Let :math:`g_1, \dots, g_k` be the geometric multiplicities of :math:`\lambda_1, \dots \lambda_k` respectively.
    Then the number of linearly independent eigen vectors for :math:`A` is 
    
    
    .. math:: 
    
        \sum_{i=1}^k g_i.
    
    
    Moreover if 
    
    
    .. math:: 
    
        \sum_{i=1}^k g_i = n
    
    then a set of :math:`n` linearly independent eigen vectors of :math:`A` can be found which forms a basis for :math:`\FF^n`.


 
Diagonalization
----------------------------------------------------

Diagonalization is one of the fundamental operations in linear algebra. This section
discusses diagonalization of square matrices in depth.


.. index:: Diagonalizable

.. _def:mat:diagonalizable:

.. definition:: 

    An :math:`n \times n` matrix :math:`A` is said to be 
    **diagonalizable** if it is *similar* to a diagonal matrix.
    In other words there exists an
    :math:`n\times n` non-singular matrix :math:`P` such that 
    :math:`D = P^{-1} A P` is a diagonal matrix. 
    If this happens then we say that :math:`P` 
    **diagonalizes** :math:`A` or :math:`A` is diagonalized
    by :math:`P`. 



.. remark:: 

    
    
    .. math::
        D =  P^{-1} A P \iff P D = A P \iff P D P^{-1} = A.
    

We note that if we restrict to real matrices, then :math:`U` and :math:`D` should also be real.
If :math:`A \in \CC^{n \times n}` (it may still be real) then :math:`P` and :math:`D` can be complex.

The next theorem is the culmination of a variety of results studied so far.


.. _thm:mat:diagonalizable_matrix_properties:

.. theorem:: 

    Let :math:`A` be a diagonalizable matrix with :math:`D = P^{-1} A P` being its diagonalization.
    Let :math:`D =  \Diag(d_1, d_2, \dots, d_n)`.
    Then the following hold

    a. :math:`\Rank(A) = \Rank(D)` which equals the number of 
       non-zero entries on the main diagonal of :math:`D`.
    #. :math:`\det(A) = d_1 d_2 \dots d_n`.
    #. :math:`\Trace(A) = d_1 + d_2 + \dots d_n`.
    #. The characteristic polynomial of :math:`A` is

       .. math:: 
    
            p(\lambda) = (-1)^n (\lambda - d_1) (\lambda -d_2) \dots (\lambda - d_n).

    #. The spectrum of :math:`A` comprises the distinct scalars 
       on the diagonal entries in :math:`D`.
    #. The (not necessarily distinct) eigenvalues of :math:`A` are 
       the diagonal elements of :math:`D`.
    #. The columns of :math:`P` are (linearly independent) eigenvectors 
       of :math:`A`. 
    #. The algebraic and geometric multiplicities of an eigenvalue 
       :math:`\lambda` of :math:`A` equal the number of diagonal elements 
       of :math:`D` that equal :math:`\lambda`.
    
.. proof:: 

    From :ref:`here <def:mat:diagonalizable>` we note that :math:`D` and :math:`A` are similar.
    Due to :ref:`here <lem:determinant_simlar_matrix_rule>`
    
    
    .. math:: 
    
        \det(A) = \det(D).
    
    Due to :ref:`here <lem:determinant_diagonal_matrix_rule>`
    
    
    .. math:: 
    
        \det(D) = \prod_{i=1}^n d_i.
    
    
    
    Now due to :ref:`here <lem:mat:trace_similar_matrices>`
    
    
    .. math:: 
    
        \Trace(A) = \Trace(D) = \sum_{i=1}^n d_i.
    
    Further due to :ref:`here <lem:mat:eig:simlar_matrix_spectrum>`
    the characteristic polynomial and spectrum of :math:`A` and :math:`D` are same.
    Due to :ref:`here <lem:mat:eig:diagonal_matrix_diagonal>` the eigen values of :math:`D`
    are nothing but its diagonal entries. Hence they are also the eigen values of :math:`A`.
    
    
    
    .. math:: 
    
        D = P^{-1} A P \implies A P = P D.
    
    Now writing
    
    
    .. math:: 
    
        P  = \begin{bmatrix}
        p_1 & p_2 & \dots & p_n
        \end{bmatrix}
    
    we have
    
    
    .. math:: 
    
        A P  = \begin{bmatrix}
        A p_1 & A p_2 & \dots & A p_n
        \end{bmatrix}
        =  P D =
        \begin{bmatrix}
        d_1 p_1 & d_2 p_2 & \dots & d_n p_n
        \end{bmatrix}.
    
    Thus :math:`p_i` are eigen vectors of :math:`A`.
    
    Since the characteristic polynomials of :math:`A` and :math:`D` are same, hence the
    algebraic multiplicities of eigen values are same. 
    
    From :ref:`here <lem:mat:eig:similar_matrix_eigen_value>` we get that there is a 
    one to one correspondence between the eigen vectors of :math:`A` and :math:`D` through
    the change of basis given by :math:`P`. Thus the linear independence relationships
    between the eigen vectors remain the same. Hence the geometric multiplicities
    of individual eigenvalues are also the same.
    
    
    This completes the proof.


So far we have verified various results which are available if 
a matrix :math:`A` is diagonalizable. We haven't yet identified the
conditions under which :math:`A` is diagonalizable. We note that
not every matrix is diagonalizable. The following theorem
gives necessary and sufficient conditions under which 
a matrix is diagonalizable. 


.. _thm:mat:eig:necessary_condition_diagonalizability:

.. theorem:: 


    An :math:`n \times n` matrix :math:`A` is diagonalizable by an :math:`n \times n` non-singular matrix
    :math:`P` if and only if the columns of :math:`P` are (linearly independent) eigenvectors
    of :math:`A`.



.. proof:: 

    We note that since :math:`P` is non-singular hence columns of :math:`P` have to be linearly independent.
    
    The necessary condition part was proven in :ref:`here <thm:mat:diagonalizable_matrix_properties>`.
    We now show that if :math:`P` consists of :math:`n` linearly independent eigen vectors of :math:`A` then
    :math:`A` is diagonalizable.
    
    Let the columns of :math:`P` be :math:`p_1, p_2, \dots, p_n` and corresponding (not necessarily distinct) eigen values
    be :math:`d_1, d_2, \dots , d_n`. Then
    
    
    .. math:: 
    
        A p_i = d_i p_i.
    
    Thus by letting :math:`D = \Diag (d_1, d_2, \dots, d_n)`, we have
    
    
    .. math:: 
    
        A P = P D.
    
    Now since columns of :math:`P` are linearly independent, hence :math:`P` is invertible. This gives us
    
    
    .. math:: 
    
        D = P^{-1} A P. 
    
    Thus :math:`A` is similar to a diagonal matrix :math:`D`. This validates the sufficient condition.


A corollary follows.


.. corollary:: 

    An :math:`n \times n` matrix is diagonalizable if and only if there exists a linearly
    independent set of :math:`n` eigenvectors of :math:`A`.

Now we know that geometric multiplicities of eigen values of :math:`A` provide us
information about linearly independent eigenvectors of :math:`A`. 


.. corollary:: 

    Let :math:`A` be an :math:`n \times n` matrix. Let :math:`\lambda_1, \lambda_2, \dots, \lambda_k` be
    its :math:`k` distinct eigen values (comprising its spectrum). Let :math:`g_j` be the geometric
    multiplicity of :math:`\lambda_j`.Then :math:`A` is diagonalizable if and only if
    
    
    .. math::
        \sum_{i=1}^n g_i = n.
    



 
Symmetric matrices
----------------------------------------------------

This subsection is focused on real symmetric matrices.

Following is a fundamental property of real symmetric matrices.

.. _thm:mat:eig_real_symmetric_eigenvalue_guarantee:

.. theorem:: 

    Every real symmetric matrix has an eigen value.


The proof of this result is beyond the scope of this book.


.. _thm:mat:eig:symmetric_orthogonal:

.. lemma:: 


    Let :math:`A` be an :math:`n \times n` real symmetric matrix. Let :math:`\lambda_1` and :math:`\lambda_2` be any two distinct
    eigen values of :math:`A` and let :math:`x_1` and :math:`x_2` be any two corresponding eigen vectors. Then :math:`x_1` and
    :math:`x_2` are orthogonal.



.. proof:: 

    By definition we have :math:`A x_1 = \lambda_1 x_1` and :math:`A x_2 = \lambda_2 x_2`. Thus
    
    
    .. math:: 
    
        \begin{aligned}
        & x_2^T A x_1 = \lambda_1 x_2^T x_1\\
        \implies & x_1^T A^T x_2 = \lambda_1 x_1^T x_2 \\
        \implies & x_1^T A x_2 = \lambda_1 x_1^T x_2\\
        \implies & x_1^T \lambda_2 x_2 = \lambda_1 x_1^T x_2\\
        \implies & (\lambda_1 - \lambda_2) x_1^T x_2 = 0 \\
        \implies & x_1^T x_2 = 0.
        \end{aligned}
    
    Thus :math:`x_1` and :math:`x_2` are orthogonal. In between we took transpose on both sides, used the fact that :math:`A= A^T` 
    and :math:`\lambda_1 - \lambda_2 \neq 0`.




.. index:: Orthogonally diagonalizable matrix

.. _def:mat:orthogonally_diagonalizable_matrix:

.. definition:: 

    A real :math:`n \times n` matrix :math:`A` is said to be **orthogonally diagonalizable** if
    there exists an orthogonal matrix :math:`U` which can diagonalize :math:`A`, i.e.
    
    
    .. math:: 
    
        D = U^T A U 
    
    is a real diagonal matrix.




.. lemma:: 

    Every orthogonally diagonalizable matrix :math:`A` is symmetric.



.. proof:: 

    We have a diagonal matrix :math:`D` such that
    
    
    .. math:: 
    
        A = U D U^T. 
    
    Taking transpose on both sides we get
    
    
    .. math:: 
    
        A^T = U D^T U^T = U D U^T = A.
    
    Thus :math:`A` is symmetric.



.. _thm:mat:eig:symmetric_orthogonal_sufficient_condition:

.. theorem:: 

    Every symmetric matrix :math:`A` is orthogonally diagonalizable. 


We skip the proof of this theorem.

 
Hermitian matrices
----------------------------------------------------

Following is a fundamental property of Hermitian matrices.

.. _thm:mat:eig_hermitian_eigenvalue_guarantee:

.. theorem:: 

    Every Hermitian matrix has an eigen value.


The proof of this result is beyond the scope of this book.



.. _lem:mat:eig:hermitian_eigenvalues_real:

.. lemma:: 


    The eigenvalues of a Hermitian matrix are real.



.. proof:: 

    Let :math:`A` be a Hermitian matrix and let :math:`\lambda` be an eigen value of :math:`A`. Let :math:`u`
    be a corresponding eigen vector. Then
    
    
    .. math:: 
    
        \begin{aligned}
        & A u = \lambda u\\
        \implies & u^H A^H = u^H \overline{\lambda} \\
        \implies & u^H A^H u = u^H \overline{\lambda} u\\
        \implies & u^H A u = \overline{\lambda} u^H u \\
        \implies & u^H \lambda u = \overline{\lambda} u^H u \\
        \implies &\|u\|_2^2 (\lambda - \overline{\lambda}) = 0\\
        \implies & \lambda = \overline{\lambda}
        \end{aligned}
    
    thus :math:`\lambda` is real. We used the facts that :math:`A = A^H` and :math:`u \neq 0 \implies \|u\|_2 \neq 0`.




.. _thm:mat:eig:hermitiaan_orthogonal:

.. lemma:: 


    Let :math:`A` be an :math:`n \times n` complex Hermitian matrix. Let :math:`\lambda_1` and :math:`\lambda_2` be any two distinct
    eigen values of :math:`A` and let :math:`x_1` and :math:`x_2` be any two corresponding eigen vectors. Then :math:`x_1` and
    :math:`x_2` are orthogonal.



.. proof:: 

    By definition we have :math:`A x_1 = \lambda_1 x_1` and :math:`A x_2 = \lambda_2 x_2`. Thus
    
    
    .. math:: 
    
        \begin{aligned}
        & x_2^H A x_1 = \lambda_1 x_2^H x_1\\
        \implies & x_1^H A^H x_2 = \lambda_1 x_1^H x_2 \\
        \implies & x_1^H A x_2 = \lambda_1 x_1^H x_2\\
        \implies & x_1^H \lambda_2 x_2 = \lambda_1 x_1^H x_2\\
        \implies & (\lambda_1 - \lambda_2) x_1^H x_2 = 0 \\
        \implies & x_1^H x_2 = 0.
        \end{aligned}
    
    Thus :math:`x_1` and :math:`x_2` are orthogonal. In between we took conjugate transpose on both sides, used the fact that :math:`A= A^H` 
    and :math:`\lambda_1 - \lambda_2 \neq 0`.



.. index:: Unitary diagonalizable matrix


.. _def:mat:unitary_diagonalizable_matrix:

.. definition:: 

    A complex :math:`n \times n` matrix :math:`A` is said to be **unitary diagonalizable** if
    there exists a unitary matrix :math:`U` which can diagonalize :math:`A`, i.e.
    
    
    .. math:: 
    
        D = U^H A U 
    
    is a complex diagonal matrix.





.. lemma:: 

    Let :math:`A` be a unitary diagonalizable matrix whose diagonalization :math:`D` is real. Then :math:`A`
    is Hermitian.



.. proof:: 

    We have a real diagonal matrix :math:`D` such that
    
    
    .. math:: 
    
        A = U D U^H. 
    
    Taking conjugate transpose on both sides we get
    
    
    .. math:: 
    
        A^H = U D^H U^H = U D U^H = A.
    
    Thus :math:`A` is Hermitian. We used the fact that :math:`D^H = D` since :math:`D` is real.



.. _thm:mat:eig:hermitian_unitary_sufficient_condition:

.. theorem:: 

    Every Hermitian matrix :math:`A` is unitary diagonalizable. 


We skip the proof of this theorem. The theorem means that if :math:`A` is Hermitian
then :math:`A = U \Lambda U^H` 

.. index:: Eigen value decomposition of a Hermitian matrix

.. _def:mat:eig:evd_hermitian_matrix:

.. definition:: 

    Let :math:`A` be an :math:`n \times n` Hermitian matrix. Let :math:`\lambda_1, \dots \lambda_n` be its eigen values
    such that :math:`|\lambda_1| \geq |\lambda_2| \geq \dots \geq |\lambda_n |`. Let
    
    
    .. math:: 
    
        \Lambda = \Diag(\lambda_1, \dots, \lambda_n).
    
    Let :math:`U` be a unit matrix consisting of orthonormal eigen vectors corresponding to 
    :math:`\lambda_1, \dots, \lambda_n`. Then The eigen value decomposition of :math:`A` is defined as
    
    
    .. math::
        A = U \Lambda U^H.
    
    If :math:`\lambda_i` are distinct, then the decomposition is unique. If they are not distinct, then 




.. remark:: 

    Let :math:`\Lambda` be a diagonal matrix as in :ref:`here <def:mat:eig:evd_hermitian_matrix>`. Consider some vector :math:`x \in \CC^n`.
    
    
    
    .. math::
        x^H \Lambda x = \sum_{i=1}^n \lambda_i | x_i |^2.
    
    
    Now if :math:`\lambda_i \geq 0` then 
    
    
    .. math:: 
    
        x^H \Lambda x  \leq \lambda_1 \sum_{i=1}^n  | x_i |^2 = \lambda_1 \| x \|_2^2.
    
    Also
    
    
    .. math:: 
    
        x^H \Lambda x  \geq \lambda_n \sum_{i=1}^n | x_i |^2 = \lambda_n \| x \|_2^2.
    
    



.. _lem:mat:eig:hermitian_psd_x_h_a_x_range:

.. lemma:: 


    Let :math:`A` be a Hermitian matrix with non-negative eigen values.  Let :math:`\lambda_1` be its largest
    and :math:`\lambda_n` be its smallest eigen values. 
    
    
    .. math::
        \lambda_n  \| x\|_2^2 \leq x^H A x \leq  \lambda_1  \|x \|_2^2 \Forall  x \in \CC^n.
    



.. proof:: 

    :math:`A` has an eigen value decomposition given by
    
    
    .. math:: 
    
        A = U \Lambda U^H.
    
    Let :math:`x \in \CC^n` and let :math:`v = U^H x`. Clearly :math:`\| x \|_2 = \| v \|_2`.
    Then 
    
    
    .. math:: 
    
        x^H A x = x^H U \Lambda U^H x = v^H \Lambda v.
    
    From previous remark we have
    
    
    .. math:: 
    
        \lambda_n \| v \|_2^2 \leq v^H \Lambda v \leq \lambda_1 \| v \|_2^2.
    
    Thus we get
    
    
    .. math:: 
    
        \lambda_n \| x \|_2^2 \leq x^H A x \leq \lambda_1 \| x \|_2^2.
    


 
Miscellaneous properties
----------------------------------------------------

This subsection lists some miscellaneous properties of eigen values of a square matrix.

.. _lem:mat:eig:lambda_k_sum:

.. lemma:: 

    :math:`\lambda` is an eigen value of :math:`A` if and only if :math:`\lambda + k` is an eigen value
    of :math:`A + k I`. Moreover :math:`A` and :math:`A + kI` share the same eigen vectors.




.. proof:: 

    
    
    .. math::
        \begin{aligned}
        & A x = \lambda x \\
        \iff & A x  + k x = \lambda x + k x \\
        \iff & (A + k I ) x = (\lambda + k) x.
        \end{aligned}
    
    Thus :math:`\lambda` is an eigen value of :math:`A` with an eigen vector :math:`x` if and only if
    :math:`\lambda + k` is an eigen vector of :math:`A + kI` with an eigen vector :math:`x`.


.. _sec:mat:diagonally_dominant_matrix:
 
Diagonally dominant matrices
----------------------------------------------------


.. index:: Diagonally dominant matrix


.. _def:mat:diagonally_dominant_matrix:

.. definition:: 

    Let :math:`A = [a_{ij}]` be a square matrix in :math:`\CC^{n \times n}`. :math:`A` is
    called **diagonally dominant** if 
    
    
    .. math:: 
    
        | a_{ii} | \geq \sum_{j \neq i } |a_{ij}| 
    
    holds true for all :math:`1 \leq i \leq n`. i.e. the absolute value
    of the diagonal element is greater than or equal to the sum of absolute values
    of all the off diagonal elements on that row.

.. index:: Strictly diagonally dominant matrix

.. _def:mat:strictly_diagonally_dominant_matrix:

.. definition:: 

    Let :math:`A = [a_{ij}]` be a square matrix in :math:`\CC^{n \times n}`. :math:`A` is
    called **strictly diagonally dominant** if 
    
    
    .. math:: 
    
        | a_{ii} | > \sum_{j \neq i } |a_{ij}| 
    
    holds true for all :math:`1 \leq i \leq n`. i.e. the absolute value
    of the diagonal element is bigger than the sum of absolute values
    of all the off diagonal elements on that row.




.. example:: Strictly diagonally dominant matrix

    Let us consider
    
    
    .. math:: 
    
        A = \begin{bmatrix}
        -4 & -2 & -1 & 0\\
        -4 & 7 & 2 & 0\\
        3 & -4 & 9 & 1\\
        2 & -1 & -3 & 15
        \end{bmatrix}
    
    We can see that the strict diagonal dominance condition is satisfied for each row as follows:
    
    
    .. math:: 
    
        \begin{aligned}
        & \text{ row 1}: \quad & |-4| > |-2| + |-1| + |0| = 3 \\
        & \text{ row 2}: \quad & |7| > |-4| + |2| + |0| = 6 \\
        & \text{ row 3}: \quad & |9| > |3| + |-4| + |1| = 8 \\
        & \text{ row 4}: \quad & |15| > |2| + |-1| + |-3| = 6
        \end{aligned}
    


Strictly diagonally dominant matrices have a very special property. They are
always non-singular.

.. _thm:mat:strictly_diagonally_dominant_matrix_nonsingularity:

.. theorem:: 

    Strictly diagonally dominant matrices are non-singular.




.. proof:: 

    Suppose that :math:`A` is diagonally dominant and singular. Then there exists a vector
    :math:`u \in \CC^n` with :math:`u\neq 0` such that 
    
    
    .. math::
        :label: eq:E657C902-E61C-4596-945D-6AB5253059DF
    
        A u = 0.
    
    Let
    
    
    .. math:: 
    
        u = \begin{bmatrix}u_1 & u_2 & \dots & u_n \end{bmatrix}^T.
    
    We first show that every entry in :math:`u` cannot be equal in magnitude.
    Let us assume that this is so. i.e.
    
    
    .. math:: 
    
        c = | u_1 | = | u_2 | = \dots = | u_n|.
    
    Since :math:`u \neq 0` hence :math:`c \neq 0`.
    Now for any row :math:`i` in :eq:`eq:E657C902-E61C-4596-945D-6AB5253059DF` , we have
    
    
    .. math:: 
    
        \begin{aligned}
        & \sum_{j=1}^n a_{ij} u_j = 0\\
        \implies &  \sum_{j=1}^n \pm a_{ij} c = 0\\
        \implies & \sum_{j=1}^n \pm a_{ij} = 0\\
        \implies & \mp a_{ii} = \sum_{j \neq i} \pm a_{ij}\\
        \implies &  |a_{ii}| = | \sum_{j \neq i} \pm a_{ij}|\\
        \implies &  |a_{ii}| \leq \sum_{j \neq i} |a_{ij}| \quad {\text{ using triangle inequality}}
        \end{aligned}
    
    but this contradicts our assumption that :math:`A` is strictly diagonally dominant.
    Thus all entries in :math:`u` are not equal in magnitude. 
    
    Let us now assume that
    the largest entry in :math:`u` lies at index :math:`i` with :math:`|u_i| = c`. 
    Without loss of generality we can scale down :math:`u` by :math:`c` to get
    another vector in which all entries are less than or equal to 1 in magnitude
    while :math:`i`-th entry is :math:`\pm 1`. i.e. :math:`u_i = \pm 1` and :math:`|u_j| \leq 1` for all other 
    entries.
    
    Now from 
    :eq:`eq:E657C902-E61C-4596-945D-6AB5253059DF` we get for the :math:`i`-th row
    
    
    .. math:: 
    
        \begin{aligned}
        & \sum_{j=1}^n a_{ij} u_j = 0\\\
        \implies & \pm a_{ii} = \sum_{j \neq i} u_j a_{ij}\\
        \implies & |a_{ii}| \leq \sum_{j \neq i} |u_j a_{ij}| \leq \sum_{j \neq i} |a_{ij}|
        \end{aligned}
    
    which again contradicts our assumption that :math:`A` is strictly diagonally dominant.
    
    Hence strictly diagonally dominant matrices are non-singular.


 
Gershgorin's theorem
----------------------------------------------------

We are now ready to examine Gershgorin' theorem which provides very useful bounds on the
spectrum of a square matrix.

.. index:: Gershgorin's theorem

.. _thm:mat:gershgorin_circle_theorem:a:

.. theorem:: 


    Every eigen value :math:`\lambda` of a square matrix :math:`A \in \CC^{n\times n}` satisfies 
    
    
    .. math::
        :label: eq:mat:gershgorin_circle_theorem:a
    
        | \lambda - a_{ii}| \leq \sum_{j\neq i} |a_{ij}| \text{ for some } i \in \{1,2, \dots, n \}.
    



.. proof:: 

    The proof is a straight forward application of non-singularity of diagonally dominant matrices.
    
    We know that for an eigen value :math:`\lambda`, :math:`\det(\lambda I  - A) = 0` i.e. 
    the matrix :math:`(\lambda I  - A)` is singular. Hence it cannot be strictly diagonally dominant
    due to :ref:`here <thm:mat:strictly_diagonally_dominant_matrix_nonsingularity>`.
    
    Thus looking at each row :math:`i` of :math:`(\lambda I  - A)` we can say that
    
    
    .. math:: 
    
        | \lambda - a_{ii}| > \sum_{j\neq i} |a_{ij}|
    
    cannot be true for all rows simultaneously. i.e. it must fail at least for one row.
    This means that there exists at least one row :math:`i` for which
    
    
    .. math:: 
    
        | \lambda - a_{ii}| \leq \sum_{j\neq i} |a_{ij}|
    
    holds true.


What this theorem means is pretty simple. Consider a disc in the complex plane
for the :math:`i`-th row of :math:`A` whose center is given by :math:`a_{ii}` and whose 
radius is given by :math:`r = \sum_{j\neq i} |a_{ij}|` i.e. the sum of
magnitudes of all non-diagonal entries in :math:`i`-th row.

There are :math:`n` such discs corresponding to :math:`n` rows in :math:`A`. 
:eq:`eq:mat:gershgorin_circle_theorem:a` means that every eigen value
must lie within the union of these discs. It cannot lie outside.

This idea is crystallized in following definition.

.. index:: Gershgorin's disc

.. _def:mat:gershgorin_disk:

.. definition:: 

    For :math:`i`-th row of matrix :math:`A` we define the radius :math:`r_i = \sum_{j\neq i} |a_{ij}|`
    and the center :math:`c_i = a_{ii}`. Then the set given by
    
    
    .. math:: 
    
        D_i = \{z \in \CC :  | z - a_{ii} | \leq r_i \}
    
    is called the :math:`i`-th **Gershgorin's disc** of :math:`A`.

We note that the definition is equally valid for real as well as complex matrices.
For real matrices, the centers of disks lie on the real line. For complex matrices,
the centers may lie anywhere in the complex plane.

Clearly there is nothing magical about the rows of :math:`A`. We can as well consider 
the columns of :math:`A`.


.. _thm:mat:gershgorin_circle_theorem:b:

.. theorem:: 

    Every eigen value of a matrix :math:`A` must lie in a Gershgorin disc corresponding to the
    columns of :math:`A` where the  Gershgorin disc for :math:`j`-th column is given by
    
    
    .. math:: 
    
        D_j = \{z \in \CC :  | z - a_{jj} | \leq r_j \}
    
    with 
    
    
    .. math:: 
    
        r_j =  \sum_{i \neq j} |a_{ij}|
    




.. proof:: 

    We know that eigen values of :math:`A` are same as eigen values of :math:`A^T` and
    columns of :math:`A` are nothing but rows of :math:`A^T`. Hence eigen values of :math:`A`
    must satisfy conditions in :ref:`here <thm:mat:gershgorin_circle_theorem:a>`
    w.r.t. the matrix :math:`A^T`. This completes the proof.

.. disqus::
