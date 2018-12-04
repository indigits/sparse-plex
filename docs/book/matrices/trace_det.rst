
 
Trace and determinant
===================================================


 
Trace
----------------------------------------------------

.. index:: Trace


.. _def:mat:trace:

.. definition:: 

    The **trace** of a square matrix is defined as the sum of the entries on its main diagonal.
    Let :math:`A` be an :math:`n\times n` matrix, then
    
    
    .. math::
        \Trace (A) = \sum_{i=1}^n a_{ii}
    
    where :math:`\Trace(A)` denotes the trace of :math:`A`.




.. lemma:: 

    The trace of a square matrix and its transpose are equal.
    
    
    .. math::
        \Trace(A) = \Trace(A^T).
    




.. lemma:: 

    Trace of sum of two square matrices is equal to the sum of their traces.
    
    
    .. math::
        \Trace(A + B) = \Trace(A) + \Trace(B).
    




.. _lem:mat:trace_product_rule:

.. lemma:: 


    Let :math:`A` be an :math:`m \times n` matrix and :math:`B` be an :math:`n \times m` matrix.
    Then
    
    
    .. math::
        \Trace(AB) = \Trace(BA).
    





.. proof:: 

    Let :math:`AB = C = [c_{ij}]`. Then
    
    
    .. math:: 
    
        c_{ij} = \sum_{k=1}^n a_{i k} b_{k j}.
    
    Thus
    
    
    .. math:: 
    
        c_{ii} = \sum_{k=1}^n a_{i k} b_{k i}.
    
    Now 
    
    
    .. math:: 
    
        \Trace(C)  = \sum_{i=1}^m c_{ii} = \sum_{i=1}^m \sum_{k=1}^n a_{i k} b_{k i} = \sum_{k=1}^n \sum_{i=1}^m a_{i k} b_{k i}
        = \sum_{k=1}^n \sum_{i=1}^m  b_{k i} a_{i k}.
    
    
    Let :math:`BA = D = [d_{ij}]`. Then
    
    
    .. math:: 
    
        d_{ij} = \sum_{k=1}^m b_{i k} a_{k j}.
    
    Thus
    
    
    .. math:: 
    
        d_{ii} = \sum_{k=1}^m b_{i k} a_{k i}.
    
    Hence
    
    
    .. math:: 
    
        \Trace(D) =  \sum_{i=1}^n d_{ii} =  \sum_{i=1}^n \sum_{k=1}^m b_{i k} a_{k i} = \sum_{i=1}^m \sum_{k=1}^n b_{k i} a_{i k}.
    
    This completes the proof.



.. _lem:mat:trace_triple_product_rule:

.. lemma:: 


    Let :math:`A \in \FF^{m \times n}`, :math:`B \in \FF^{n \times p}`, :math:`C \in \FF^{p \times m}` be three matrices. Then
    
    
    .. math::
        \Trace(ABC) = \Trace(BCA) = \Trace(CAB).
    



.. proof:: 

    Let :math:`AB = D`. Then
    
    
    .. math:: 
    
        \Trace(ABC) = \Trace(DC) = \Trace(CD) = \Trace(CAB). 
    
    Similarly the other result can be proved.




.. _lem:mat:trace_similar_matrices:

.. lemma:: 

    Trace of similar matrices is equal.




.. proof:: 

    Let :math:`B` be similar to :math:`A`. Thus
    
    
    .. math:: 
    
        B  = C^{-1} A C 
    
    for some invertible matrix :math:`C`.
    Then
    
    
    .. math:: 
    
        \Trace(B) = \Trace(C^{-1} A C )   = \Trace (C C^{-1} A) = \Trace(A).
    
    We used :ref:`this <lem:mat:trace_product_rule>`.




 
Determinants
----------------------------------------------------


Following are some results on determinant of a square matrix :math:`A`.


.. _lem:mat:determinant_scalar_multiplication_rule:

.. lemma:: 

    
    
    .. math::
        \det(\alpha A) = \alpha^n \det(A). 
    




.. _lem:mat:determinant_transpose_rule:

.. lemma:: 

    Determinant of a square matrix and its transpose are equal.
    
    
    .. math::
        \det(A)  = \det(A^T).
    




.. _lem:mat:determinant_conjugate_transpose_rule:

.. lemma:: 

    Let :math:`A` be a complex square matrix. Then
    
    
    .. math::
        \det(A^H)  = \overline{\det(A)}.
    




.. proof:: 

    
    
    .. math:: 
    
        \det(A^H) = \det(\overline{A}^T) = \det(\overline{A}) = \overline{\det(A)}.
    




.. _lem:mat:determinant_product_rule:

.. lemma:: 

    Let :math:`A` and :math:`B` be two :math:`n\times n` matrices. Then
    
    
    .. math::
        \det (A B) = \det(A) \det(B).
    




.. _lem:mat:determinant_inverse_rule:

.. lemma:: 

    Let :math:`A` be an invertible matrix. Then
    
    
    .. math::
        \det(A^{-1}) = \frac{1}{\det(A)}.
    




.. _lem:mat:determinant_power_rule:

.. lemma:: 

    
    
    .. math::
        \det(A^{p}) = \left(\det(A) \right)^p.
    




.. _lem:determinant_triangular_matrix_rule:

.. lemma:: 

    Determinant of a triangular matrix is the product of its diagonal entries. i.e. if :math:`A` is upper or lower
    triangular matrix then
    
    
    .. math::
        \det(A)  = \prod_{i=1}^n a_{i i}.
    





.. _lem:determinant_diagonal_matrix_rule:

.. lemma:: 

    Determinant of a diagonal matrix is the product of its diagonal entries. i.e. if :math:`A` is 
    a diagonal matrix then
    
    
    .. math::
        \det(A)  = \prod_{i=1}^n a_{i i}.
    




.. _lem:determinant_simlar_matrix_rule:

.. lemma:: 

    Determinant of similar matrices is equal.




.. proof:: 

    Let :math:`B` be similar to :math:`A`.
    Thus
    
    
    .. math:: 
    
        B  = C^{-1} A C 
    
    for some invertible matrix :math:`C`. Hence
    
    
    .. math:: 
    
        \det(B) = \det(C^{-1} A C ) = \det (C^{-1}) \det (A) \det(C).
    
    Now 
    
    
    .. math:: 
    
         \det (C^{-1}) \det (A) \det(C) = \frac{1}{\det(C)} \det (A) \det(C) = \det(A).
    
    We used :ref:`this <lem:mat:determinant_product_rule>` and :ref:`this <lem:mat:determinant_inverse_rule>`.





.. _lem:mat:determinant_inner_product_rule:

.. lemma:: 

    Let :math:`u` and :math:`v` be vectors in :math:`\FF^n`. Then
    
    
    .. math::
        \det(I + u v^T) = 1  + u^T v.
    




.. _lem:mat:determinant_perturbation_rule:

.. lemma:: 

    Let :math:`A` be a square matrix and let :math:`\epsilon \approx 0`. Then 
    
    
    .. math::
        \det(I + \epsilon A ) \approx 1 + \epsilon \Trace(A).
    



.. disqus::
