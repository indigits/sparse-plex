Inner product spaces
===================================================


 
Inner product
----------------------------------------------------

Inner product is a generalization of the notion of dot product.

.. _def:inner_product:

.. definition:: 


    An *inner product* over a :math:`K`-vector space :math:`V` is any map
    
    
    .. math::
          \begin{aligned}
          \langle, \rangle : &V \times V \to K (\RR \text{ or } \CC )\\
                             & (v_1, v_2) \to \langle v_1, v_2 \rangle
          \end{aligned}
    
    
    satisfying following requirements:
    
    
    *  Positive definiteness
      
    
    .. math::
        :label: eq:inner_product_pd
    
            \langle v, v \rangle \geq 0 \text{  and  } \langle v, v \rangle = 0 \iff v = 0
    *  Conjugate symmetry
        
    
    .. math::
        :label: eq:inner_product_conj_sym
    
            \langle v_1, v_2 \rangle = \overline{\langle v_2, v_1 \rangle} \quad \forall v_1, v_2 \in V
    *  Linearity in the first argument
      
    
    .. math::
        :label: eq:inner_product_conj_linearity
    
            \begin{aligned}
            &\langle \alpha v, w \rangle = \alpha \langle v, w \rangle \quad \forall v, w \in V; \forall \alpha \in K\\
            &\langle v_1 + v_2, w \rangle = \langle v_1, w \rangle + \langle v_2, w \rangle \quad \forall v_1, v_2,w \in V
            \end{aligned}
    
    
    


Remarks


*  Linearity in first argument extends to any arbitrary linear combination:
  

.. math::
        \left \langle \sum \alpha_i v_i, w \right \rangle = \sum \alpha_i \langle v_i, w \rangle
*  Similarly we have conjugate linearity in second argument for any arbitrary linear combination:
  

.. math::
        \left \langle v, \sum \alpha_i w_i \right \rangle = \sum \overline{\alpha_i} \langle v, w_i \rangle




 
Orthogonality
----------------------------------------------------




.. definition:: 

    A set of non-zero vectors :math:`\{v_1, \dots, v_p\}` is called *orthogonal* if
    
    
    .. math::
         \langle v_i, v_j  \rangle = 0  \text{ if } i \neq j \quad \forall 1 \leq i, j \leq p
    




.. definition:: 

    A set of non-zero vectors :math:`\{v_1, \dots, v_p\}` is called *orthonormal* if
    
    
    .. math::
        :label: eq:orthonormality
    
        \begin{aligned}
         &\langle v_i, v_j  \rangle = 0  \text{ if } i \neq j \quad \forall 1 \leq i, j \leq p\\
         &\langle v_i, v_i  \rangle = 1  \quad \forall 1 \leq i \leq p
        \end{aligned}
    
    i.e. :math:`\langle v_i, v_j  \rangle = \delta(i, j)`.


Remarks:


*  A set of orthogonal vectors is linearly independent. Prove!




.. definition:: 

    A :math:`K`-vector space :math:`V` equipped with an inner product :math:`\langle, \rangle : V \times V \to K` is known
    as an *inner product space* or a *pre-Hilbert space*.


 
Norm
----------------------------------------------------
 Norms are a generalization of the notion of length.



.. definition:: 

    A *norm* over a :math:`K`-vector space :math:`V` is any map
    
    
    .. math::
          \begin{aligned}
          \| \| : &V \to \RR \\
                 & v \to \| v\|
          \end{aligned}
    
    
    satisfying following requirements:
    
    
    *  Positive definiteness
      
    
    .. math::
        :label: eq:norm_pd
    
            \| v\| \geq 0 \quad \forall v \in V \text{  and  } \| v\| = 0 \iff v = 0
    *  Scalar multiplication
      
    
    .. math::
            \| \alpha v \| = | \alpha | \| v \| \quad \forall \alpha \in K; \forall v \in V
    *  Triangle inequality
      
    
    .. math::
          \| v_1 + v_2 \| \leq \| v_1 \| + \| v_2 \| \quad \forall v_1, v_2 \in V
    
    
    




.. definition:: 

    A :math:`K`-vector space :math:`V` equipped with a norm :math:`\| \| : V \to \RR` is known
    as a *normed linear space*.



.. _sec:projection_linear_algebra:

 
Projection
----------------------------------------------------

.. index:: Projection

.. _def:projection:

.. definition:: 

    A **projection** is a linear transformation :math:`P` from a vector space :math:`V` to itself such that :math:`P^2=P`. 
    i.e. if :math:`P v = \beta`, then :math:`P \beta = \beta`. Thus whenever :math:`P` is applied twice to any vector, it gives
    the same result as if it was applied once.
    
    Thus :math:`P` is an idempotent operator.





.. example:: Projection operators

    
    Consider the operator :math:`P : \RR^3 \to \RR^3` defined as
    
    
    .. math::
        P = \begin{bmatrix}
        1 & 0 & 0\\
        0 & 1 & 0 \\
        0 & 0 & 0
        \end{bmatrix}.
    
    
    Then application of :math:`P` on any arbitrary vector is given by
    
    
    .. math::
        P 
        \begin{pmatrix}
        x \\ y \\z 
        \end{pmatrix}
        =
        \begin{pmatrix}
        x \\ y \\ 0
        \end{pmatrix}
    
    
    A second application doesn't change it
    
    
    .. math::
        P 
        \begin{pmatrix}
        x \\ y \\0
        \end{pmatrix}
        =
        \begin{pmatrix}
        x \\ y \\ 0
        \end{pmatrix}
    
    Thus :math:`P` is a projection operator.
    
    Usually we can directly verify the property by computing :math:`P^2` as
    
    
    .. math::
        P^2 = \begin{bmatrix}
        1 & 0 & 0\\
        0 & 1 & 0 \\
        0 & 0 & 0
        \end{bmatrix}
        \begin{bmatrix}
        1 & 0 & 0\\
        0 & 1 & 0 \\
        0 & 0 & 0
        \end{bmatrix}
        = \begin{bmatrix}
        1 & 0 & 0\\
        0 & 1 & 0 \\
        0 & 0 & 0
        \end{bmatrix}
        = P.
    
    


 
Orthogonal projection
----------------------------------------------------


Consider a projection operator :math:`P : V \to V` where :math:`V` is an inner product space.

The range of :math:`P` is given by


.. math::
    \Range(P) = \{v \in V | v =  P x \text{ for some } x \in V \}.


The null space of :math:`P` is given by


.. math::
    \NullSpace(P) = \{ v \in V | P v = 0\}.


.. index:: Orthogonal projection operator

.. _def:orthogonal_projection_operator:

.. definition:: 

    A projection operator :math:`P : V \to V` over an inner product space :math:`V` is called **orthogonal projection operator**
    if its range :math:`\Range(P)` and the null space :math:`\NullSpace(P)` as defined above are orthogonal to each other. i.e.
    
    
    .. math::
        \langle r, n \rangle = 0 \Forall r \in \Range(P) , \Forall n \in \NullSpace(P).
    

.. lemma:: 

    A projection operator is orthogonal if and only if it is self adjoint.





.. example:: Orthogonal projection on a line

    Consider a unit norm vector :math:`u \in \RR^N`.  Thus :math:`u^T u = 1`.
    
    Consider
    
    
    .. math::
        P_u = u u^T.
    
    
    Now 
    
    
    .. math:: 
    
        P_u^2 = (u u^T) (u u^T) = u (u^T u) u^T = u u^T = P.
    
    
    Thus :math:`P` is a projection operator.
    
    Now
    
    
    .. math:: 
    
        P_u^T = (u u^T)^T = u u^T = P_u
    
    
    Thus :math:`P_u` is self-adjoint. Hence :math:`P_u` is an orthogonal projection operator.
    
    Now 
    
    
    .. math:: 
    
        P_u u = (u u^T) u = u (u^T u) = u. 
    
    
    Thus :math:`P_u` leaves :math:`u` intact. i.e. Projection of :math:`u` on to :math:`u` is :math:`u` itself.
    
    Let :math:`v \in u^{\perp}` i.e. :math:`\langle u, v \rangle = 0`. 
    
    Then 
    
    
    .. math:: 
    
        P_u v = (u u^T) v = u (u^T v) = u \langle u, v \rangle = 0.
     
    
    Thus :math:`P_u` annihilates all vectors orthogonal to :math:`u`.
    
    Now any vector :math:`x \in \RR^N` can be broken down into two components 
    
    
    .. math:: 
    
        x = x_{\parallel} + x_{\perp}
    
    such that :math:`\langle u , x_{\perp} \rangle =0` and :math:`x_{\parallel}` is collinear with :math:`u`.
    
    Then 
    
    
    .. math:: 
    
        P_u x = u u^T x_{\parallel} + u u^T x_{\perp} = x_{\parallel}.
    
    
    Thus :math:`P_u` retains the projection of :math:`x` on :math:`u` given by :math:`x_{\parallel}`. 




.. example:: Projections over the column space of a matrix

    
    Let :math:`A \in \RR^{M \times N}`  with :math:`N \leq M` be a matrix given by
    
    
    .. math:: 
    
        A = \begin{bmatrix}
        a_1 & a_2 & \dots & a_N
        \end{bmatrix}
    
    
    where :math:`a_i \in \RR^M` are its columns which are linearly independent. 
    
    The column space of :math:`A` is given by
    
    
    .. math:: 
    
        C(A) = \{ A x \Forall x \in \RR^N \} \subseteq \RR^M.
    
    
    It can be shown that :math:`A^T A` is invertible.
    
    Consider the operator
    
    
    .. math:: 
    
        P_A = A (A^T A)^{-1} A^T.
    
    
    Now
    
    
    .. math:: 
    
        P_A^2 = A (A^T A)^{-1} A^T A (A^T A)^{-1} A^T = A (A^T A)^{-1} A^T = P_A.
    
    
    Thus :math:`P_A` is a projection operator.
    
    
    
    .. math:: 
    
        P_A^T = (A (A^T A)^{-1} A^T)^T = A ((A^T A)^{-1} )^T A^T = A (A^T A)^{-1} A^T = P_A.
    
    
    Thus :math:`P_A` is self-adjoint.
    
    Hence :math:`P_A` is an orthogonal projection operator on the column space of :math:`A`.
    



 
Parallelogram identity
----------------------------------------------------



.. _thm:alg:inner_product_paralleologram_identity:

.. theorem:: 


    
    
    .. math::
        2 \| x \|_2^2 + 2 \| y \|_2^2 =  \|x + y \|_2^2 + \| x - y \|_2^2.  \Forall  x, y \in V.
    




.. proof:: 

    
    
    .. math:: 
    
        \| x + y \|_2^2 = \langle x + y, x + y \rangle
        = \langle x, x \rangle + \langle y , y \rangle + \langle x , y \rangle + \langle y , x \rangle. 
    
    
    
    
    
    .. math:: 
    
        \| x - y \|_2^2 = \langle x - y, x - y \rangle
        = \langle x, x \rangle + \langle y , y \rangle - \langle x , y \rangle - \langle y , x \rangle. 
    
    
    Thus
    
    
    .. math:: 
    
        \|x + y \|_2^2 + \| x - y \|_2^2 = 2 (  \langle x, x \rangle + \langle y , y\rangle) 
        = 2 \| x \|_2^2 + 2 \| y \|_2^2.
    
    



When inner product is a real number following identity is quite useful.


.. _thm:alg:inner_product_paralleologram_identity_2:

.. theorem:: 


    
    
    .. math::
        \langle x, y \rangle = \frac{1}{4} \left ( 
        \|x + y \|_2^2 - \| x - y \|_2^2
        \right ).  \Forall  x, y \in V.
    




.. proof:: 

    
    
    .. math:: 
    
        \| x + y \|_2^2 = \langle x + y, x + y \rangle
        = \langle x, x \rangle + \langle y , y \rangle + \langle x , y \rangle + \langle y , x \rangle. 
    
    
    
    
    
    .. math:: 
    
        \| x - y \|_2^2 = \langle x - y, x - y \rangle
        = \langle x, x \rangle + \langle y , y \rangle - \langle x , y \rangle - \langle y , x \rangle. 
    
    
    Thus
    
    
    .. math:: 
    
        \|x + y \|_2^2 - \| x - y \|_2^2 = 2 ( \langle x , y \rangle + \langle y , x \rangle) 
        = 4 \langle x , y \rangle
    
    since for real inner products
    
    
    .. math:: 
    
         \langle x , y \rangle = \langle y , x \rangle.
    


 
Polarization identity
----------------------------------------------------


When inner product is a complex number, polarization identity is quite useful.


.. _thm:alg:inner_product_polarization_identity:

.. theorem:: 

    
    
    .. math::
        \langle x, y \rangle = \frac{1}{4} \left ( 
        \|x + y \|_2^2 - \| x - y \|_2^2 + i \| x + i y \|_2^2 - i \| x -i y \|_2^2
        \right )  \Forall  x, y \in V.
    





.. proof:: 

    
    
    .. math:: 
    
        \| x + y \|_2^2 = \langle x + y, x + y \rangle
        = \langle x, x \rangle + \langle y , y \rangle + \langle x , y \rangle + \langle y , x \rangle. 
    
    
    
    
    
    .. math:: 
    
        \| x - y \|_2^2 = \langle x - y, x - y \rangle
        = \langle x, x \rangle + \langle y , y \rangle - \langle x , y \rangle - \langle y , x \rangle. 
    
    
    
    
    .. math:: 
    
        \| x + i y \|_2^2 = \langle x + i y, x + i y \rangle
        = \langle x, x \rangle + \langle i y , i y \rangle + \langle x , i y \rangle + \langle i y , x \rangle. 
    
    
    
    
    
    .. math:: 
    
        \| x - i y \|_2^2 = \langle x - i y, x - i y \rangle
        = \langle x, x \rangle + \langle i y , i y \rangle - \langle x , i y \rangle - \langle i y , x \rangle. 
    
    
    Thus
    
    
    .. math:: 
    
         \|x + y \|_2^2 - \| x - y \|_2^2 + & i \| x + i y \|_2^2 - i \| x -i y \|_2^2\\
        &= 2 \langle x, y \rangle + 2 \langle y , x \rangle + 2 i  \langle x , i y \rangle + 2 i  \langle ix , y \rangle\\
        &= 2 \langle x, y \rangle + 2 \langle y , x \rangle + 2 \langle x, y \rangle - 2  \langle y , x \rangle\\
        & = 4  \langle x, y \rangle.
    
    


