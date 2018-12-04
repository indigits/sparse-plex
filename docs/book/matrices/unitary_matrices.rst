
 
Unitary and orthogonal matrices
===================================================


 
Orthogonal matrix
----------------------------------------------------


.. index:: Orthogonal matrix

.. _def:mat:orthogonal_matrix:

.. definition:: 


    A real square matrix :math:`U` is called **orthogonal** if the columns of :math:`U` form an orthonormal set. In other words, let
    
    
    .. math:: 
    
        U = \begin{bmatrix}
        u_1 & u_2 & \dots & u_n
        \end{bmatrix}
    
    with :math:`u_i \in \RR^n`. Then we have
    
    
    .. math:: 
    
        u_i \cdot u_j = \delta_{i , j}.
     



.. _lem:mat:orthogonal_transpose_inverse:

.. lemma:: 

    An orthogonal matrix :math:`U` is invertible with :math:`U^T = U^{-1}`.




.. proof:: 

    Let
    
    
    .. math:: 
    
        U = \begin{bmatrix}
        u_1 & u_2 & \dots & u_n
        \end{bmatrix}
    
    be orthogonal with 
    
    
    .. math:: 
    
        U^T = \begin{bmatrix}
        u_1^T \\ u_2^T \\ \vdots \\ u_n^T.
        \end{bmatrix}
    
    Then
    
    
    .. math:: 
    
        U^T U = \begin{bmatrix}
        u_1^T \\ u_2^T \\ \vdots \\ u_n^T.
        \end{bmatrix}
        \begin{bmatrix}
        u_1 & u_2 & \dots & u_n
        \end{bmatrix} 
        = \begin{bmatrix} u_i \cdot u_j \end{bmatrix} = I. 
    
    
    Since columns of :math:`U` are linearly independent and span :math:`\RR^n`, hence :math:`U` is invertible.
    Thus
    
    
    .. math:: 
    
        U^T = U^{-1}.
    



.. _lem:determinant_orthogonal_matrix:

.. lemma:: 

    Determinant of an orthogonal matrix is :math:`\pm 1`. 




.. proof:: 

    Let :math:`U` be an orthogonal matrix. Then
    
    
    .. math:: 
    
        \det (U^T U) = \det (I) \implies \left ( \det (U) \right )^2  = 1
    
    Thus we have
    
    
    .. math:: 
    
        \det(U) = \pm 1.
    




 
Unitary matrix
----------------------------------------------------


.. index:: Unitary matrix


.. _def:mat:unitary_matrix:

.. definition:: 

    A complex square matrix :math:`U` is called **unitary** if the columns of :math:`U` form an orthonormal set. In other words, let
    
    
    .. math:: 
    
        U = \begin{bmatrix}
        u_1 & u_2 & \dots & u_n
        \end{bmatrix}
    
    with :math:`u_i \in \CC^n`. Then we have
    
    
    .. math:: 
    
        u_i \cdot u_j = \langle u_i , u_j \rangle = u_j^H u_i = \delta_{i , j}.
     



.. _lem:mat:unitary_conjugate_transpose_inverse:

.. lemma:: 

    A unitary matrix :math:`U` is invertible with :math:`U^H = U^{-1}`.




.. proof:: 

    Let
    
    
    .. math:: 
    
        U = \begin{bmatrix}
        u_1 & u_2 & \dots & u_n
        \end{bmatrix}
    
    be orthogonal with 
    
    
    .. math:: 
    
        U^H = \begin{bmatrix}
        u_1^H \\ u_2^H \\ \vdots \\ u_n^H.
        \end{bmatrix}
    
    Then
    
    
    .. math:: 
    
        U^H U = \begin{bmatrix}
        u_1^H \\ u_2^H \\ \vdots \\ u_n^H.
        \end{bmatrix}
        \begin{bmatrix}
        u_1 & u_2 & \dots & u_n
        \end{bmatrix} 
        = \begin{bmatrix} u_i^H u_j \end{bmatrix} = I. 
    
    
    Since columns of :math:`U` are linearly independent and span :math:`\CC^n`, hence :math:`U` is invertible.
    Thus
    
    
    .. math:: 
    
        U^H = U^{-1}.
    



.. _lem:determinant_unitary_matrix:

.. lemma:: 

    The magnitude of determinant of a unitary matrix is :math:`1`. 




.. proof:: 

    Let :math:`U` be a unitary matrix. Then
    
    
    .. math:: 
    
        \det (U^H U) = \det (I) \implies \det(U^H) \det(U)  = 1 \implies \overline{\det(U)}{\det(U)} = 1.
    
    Thus we have
    
    
    .. math:: 
    
         |\det(U) |^2 = 1 \implies  |\det(U) |  = 1.
    



 
F unitary matrix
----------------------------------------------------


We provide a common definition for unitary matrices over any field :math:`\FF`. This definition
applies to both real and complex matrices.


.. index:: :math:`\FF` Unitary matrix

.. _def:mat:f_unitary_matrix:

.. definition:: 

    A square matrix :math:`U \in \FF^{n \times n}` is called 
    :math:`\FF`-**unitary** if the columns of :math:`U` form an orthonormal set. In other words, let
    
    
    .. math:: 
    
        U = \begin{bmatrix}
        u_1 & u_2 & \dots & u_n
        \end{bmatrix}
    
    with :math:`u_i \in \FF^n`. Then we have
    
    
    .. math:: 
    
        \langle u_i , u_j \rangle = u_j^H u_i = \delta_{i , j}.
     


We note that a suitable definition of inner product transports the definition appropriately
into orthogonal matrices over :math:`\RR` and unitary matrices over :math:`\CC`.

When we are talking about :math:`\FF` unitary matrices, then we will use the symbol :math:`U^H` to mean
its inverse. In the complex case, it will map to its conjugate transpose, while in real case
it will map to simple transpose. 

This definition helps us simplify some of the discussions in the sequel (like singular value
decomposition).


Following results apply equally to orthogonal matrices for real case and unitary matrices
for complex case.


.. _lem:mat:unitary_norm_preservation:

.. lemma:: 


    :math:`\FF`-unitary matrices preserve norm. i.e.
    
    
    .. math:: 
    
        \| U x \|_2 = \|x \|_2.
    




.. proof:: 

    
    
    .. math:: 
    
        \| U x \|_2^2 = (U x)^H (U x)  = x^H U^H U x = x^H I x = \| x\|_2^2.
    





.. remark:: 

    For the real case we have
    
    
    .. math:: 
    
        \| U x \|_2^2 = (U x)^T (U x)  = x^T U^T U x = x^T I x = \| x\|_2^2.
    



.. _lem:mat:unitary_inner_product_preservation:

.. lemma:: 


    :math:`\FF`-unitary matrices preserve inner product. i.e.
    
    
    .. math:: 
    
        \langle U x, U y \rangle = \langle x, y \rangle.
    




.. proof:: 

    
    
    .. math:: 
    
        \langle U x, U y \rangle = (U y)^H U x = y^H U^H U x = y^H x.
    




.. remark:: 

    For the real case we have
    
    
    .. math:: 
    
        \langle U x, U y \rangle = (U y)^T U x = y^T U^T U x = y^T x.
    

.. disqus::
