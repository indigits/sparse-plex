The Algorithm
=======================


.. figure:: images/algorithm_orthogonal_matching_pursuit.png

    Orthogonal Matching Pursuit



.. example::

    
    Let us consider a synthesis matrix of size :math:`10 \times 20`. 
    Thus :math:`N=10` and :math:`D=20`. In order to fit into the display, we will
    present the matrix in two 10 column parts.
    
    \tiny
    
    
    .. math:: 
    
        \begin{aligned}
        \Phi_a = \frac{1}{\sqrt{10}}
        \begin{bmatrix}
        -1 & -1 & -1 & 1 & -1 & -1 & 1 & 1 & -1 & 1\\
        1 & 1 & 1 & 1 & 1 & -1 & -1 & 1 & -1 & -1\\
        -1 & -1 & -1 & -1 & -1 & 1 & 1 & 1 & 1 & 1\\
        1 & -1 & -1 & 1 & 1 & 1 & -1 & 1 & 1 & 1\\
        1 & 1 & 1 & -1 & -1 & 1 & -1 & -1 & 1 & 1\\
        1 & -1 & 1 & -1 & -1 & -1 & 1 & -1 & 1 & -1\\
        -1 & -1 & 1 & 1 & -1 & -1 & -1 & -1 & 1 & -1\\
        1 & -1 & 1 & 1 & -1 & 1 & -1 & -1 & -1 & 1\\
        -1 & 1 & -1 & 1 & 1 & -1 & -1 & -1 & 1 & 1\\
        1 & 1 & 1 & 1 & -1 & 1 & -1 & 1 & -1 & 1
        \end{bmatrix}\\
        \Phi_b = \frac{1}{\sqrt{10}}
        \begin{bmatrix}
        1 & -1 & -1 & -1 & 1 & 1 & 1 & -1 & -1 & -1\\
        1 & 1 & 1 & -1 & -1 & -1 & -1 & -1 & -1 & 1\\
        -1 & 1 & 1 & 1 & 1 & 1 & -1 & -1 & -1 & -1\\
        1 & -1 & 1 & -1 & 1 & 1 & 1 & -1 & -1 & -1\\
        1 & -1 & -1 & 1 & 1 & 1 & -1 & 1 & 1 & -1\\
        -1 & 1 & 1 & 1 & -1 & 1 & -1 & 1 & -1 & 1\\
        -1 & 1 & 1 & -1 & 1 & -1 & -1 & -1 & 1 & 1\\
        1 & -1 & -1 & 1 & 1 & -1 & -1 & 1 & -1 & 1\\
        1 & 1 & 1 & 1 & -1 & -1 & 1 & 1 & 1 & -1\\
        -1 & -1 & 1 & 1 & -1 & 1 & 1 & -1 & -1 & 1
        \end{bmatrix}
        \end{aligned}
    
    with
    
    
    .. math:: 
    
        \Phi = \begin{bmatrix}\Phi_a & \Phi_b \end{bmatrix}.
    
    
    You may verify that each column is unit norm. 
    
    It is known that :math:`\Rank(\Phi) = 10` and :math:`\spark(\Phi)= 6`. Thus if a signal :math:`y` 
    has a :math:`2` sparse representation in :math:`\Phi` then the representation is necessarily unique.
    
    We now consider a signal :math:`y` given by
    
    
    .. math:: 
    
        \small
        y = \begin{pmatrix}
        4.74342 & -4.74342 & 1.58114 & -4.74342 & -1.58114 \\
        1.58114 & -4.74342 & -1.58114 & -4.74342 & -4.74342
        \end{pmatrix}.
        \normalsize
    
    
    For saving space, we have written it as an n-tuple over two rows. 
    You should treat it as a column vector of size :math:`10 \times 1`.
    
    It is known that the vector has a two sparse representation in :math:`\Phi`. 
    Let us
    go through the steps of OMP and see how it works.
    
    In step 0, :math:`r^0= y`, :math:`x^0 = 0`, and :math:`\Lambda^0  = \EmptySet`. 
    
    We now compute absolute value of inner product of :math:`r^0` with each of the columns.
    They are given by
    
    
    .. math:: 
    
        \small
        \begin{pmatrix}
        4 & 4 & 4 & 7 & 3 & 1 & 11 & 1 & 2 & 1 \\ 
        2 & 1 & 7 & 0 & 2 & 4 & 0 & 2 & 1 & 3
        \end{pmatrix}
        \normalsize
    
    
    We quickly note that the maximum occurs at index 7 with value 11.
    
    We modify our support to :math:`\Lambda^1 = \{ 7 \}`. 
    
    We now solve the least squares problem     
    
    .. math:: 
    
        \text{minimize} \left \| y - [\phi_7] x_7 \right \|_2^2.
    
    
    The solution gives us :math:`x_7 = 11.00`. Thus we get
    
    .. math:: 
    
        x^1 = \begin{pmatrix}
        0 & 0 & 0 & 0 & 0 & 0 & 11 & 0 & 0 & 0 \\
        0 & 0 & 0 & 0 & 0 & 0 & 0 & 0 & 0 & 0
        \end{pmatrix}.
    
    Again note that to save space we have presented 
    :math:`x` over two rows. You
    should consider it as a :math:`20 \times 1` column vector.
    
    
    This leaves us the residual as
    
    .. math:: 
    
        r^1 = y - \Phi x^1 = 
        \begin{pmatrix}
        1.26491 & -1.26491 & -1.89737 & -1.26491 & 1.89737 \\
        -1.89737 & -1.26491 & 1.89737 & -1.26491 & -1.26491
        \end{pmatrix}.
    
    We can cross check that the residual is indeed orthogonal to 
    the columns already selected, for
    
    .. math:: 
    
        \langle r^1 , \phi_7 \rangle  = 0.
    
    
    Next we compute inner product of :math:`r^1` with all 
    the columns in :math:`\Phi` and take absolute values.
    They are given by

    .. math:: 
    
        \begin{pmatrix}
        0.4 & 0.4 & 0.4 & 0.4 & 0.8 & 1.2 & 0 & 1.2 & 2 & 1.2 \\
        2.4 & 3.2 & 4.8 & 0 & 2 & 0.4 & 0 & 2 & 1.2 & 0.8
        \end{pmatrix}
        
    We quickly note that the maximum occurs at index 13 with value :math:`4.8`.
    
    We modify our support to :math:`\Lambda^1 = \{ 7, 13 \}`. 
    
    We now solve the least squares problem 
    
    .. math:: 
    
        \text{minimize} 
        \left \| y - \begin{bmatrix} \phi_7 & \phi_{13} \end{bmatrix}  
        \begin{bmatrix}  x_7  \\ x_{13} \end{bmatrix}  \right \|_2^2.
    
    
    This gives us :math:`x_7 = 10` and :math:`x_{13} = -5`.
    
    Thus we get 
    
    .. math:: 
    
        x^2 = \begin{pmatrix}
        0 & 0 & 0 & 0 & 0 & 0 & 10 & 0 & 0 & 0 \\
        0 & 0 & -5 & 0 & 0 & 0 & 0 & 0 & 0 & 0
        \end{pmatrix}
    
    Finally the residual we get at step 2 is
    
    
    .. math:: 
    
        r^2 = y - \Phi x^2 = 
        10^{-14} \begin{pmatrix}
        0 & 0 & -0.111022 & 0 & 0.111022 \\
        -0.111022 & 0 & 0.111022 & 0 & 0
        \end{pmatrix}
    
    The magnitude of residual is very small.
    We conclude that our OMP algorithm has converged and we have been able
    to recover the exact 2 sparse representation of :math:`y` in :math:`\Phi`.

