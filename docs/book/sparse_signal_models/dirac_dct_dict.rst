
 
Dirac-DCT dictionary
===================================================

.. _sec:dic:dirac_dct_dictionary:


.. _def:dic:dirac_dct_dictionary:

.. definition:: 

     
    .. index:: Dirac-DCT dictionary
    

    
    The Dirac-DCT dictionary is a two-ortho dictionary consisting of 
    the union of the Dirac and the DCT bases. 



This dictionary is suitable for real signals since both Dirac and DCT are
totally real bases  :math:`\in \RR^{N \times N}` . 

The dictionary is obtained by combining the  :math:`N \times N`  identity matrix (Dirac basis)
with the  :math:`N \times N`  DCT matrix for signals in  :math:`\RR^N` .

Let  :math:`\Psi_{\text{DCT}, N}`  denote the DCT matrix for  :math:`\RR^N` . Let  :math:`I_N`  denote the
identity matrix for  :math:`\RR^N` . 
Then


.. math::
    \DD_{\text{DCT}} = \begin{bmatrix}
    I_N & \Psi_{\text{DCT}, N}
    \end{bmatrix}.


Let


.. math:: 

    \Psi_{\text{DCT}, N} = \begin{bmatrix}
    \psi_1 & \psi_2 & \dots & \psi_N
    \end{bmatrix}


The  :math:`k` -th column of  :math:`\Psi_{\text{DCT}, N}`  is given by


.. math::
    :label: eq:dict:dct_matrix_kth_column

    \psi_k(n) = \sqrt{\frac{2}{N}} \Omega_k \cos \left (\frac{\pi}{2 N} (2 n - 1) (k - 1) \right ), n = 1, \dots, N,

with  :math:`\Omega_k = \frac{1}{\sqrt{2}}`  for  :math:`k=1`  and  :math:`\Omega_k = 1`  for  :math:`2 \leq k \leq N` . 

Note that for  :math:`k=1` , the entries become


.. math:: 

    \sqrt{\frac{2}{N}} \frac{1}{\sqrt{2}} \cos 0 = \sqrt{\frac{1}{N}}.

Thus, the  :math:`l_2`  norm of  :math:`\psi_1`  is 1. We can similarly verify the  :math:`l_2`  norm of other columns also.
They are all one.


.. _res:dic:dirac_dct_dictionary_coherence:

.. theorem:: 


     
    The Dirac-DCT dictionary has coherence  :math:`\sqrt{\frac{2}{N}}` .



.. proof:: 

    The coherence of a two ortho basis where one basis is Dirac basis is given by the
    magnitude of the largest entry in the other basis. For  :math:`\Psi_{\text{DCT}, N}` , the
    largest value is obtained when  :math:`\Omega_k = 1`  and the  :math:`\cos`  term evaluates to 1. 
    Clearly, 
    
    
    .. math:: 
    
        \mu (\DD_{\text{DCT}}) = \sqrt{\frac{2}{N}}.
    




.. _res:dic:dirac_dct_dictionary_babel:

.. theorem:: 


    
    The \hyperref[def:proj:babel:p_babel_function_K]{ :math:`p`  Babel function}
    for Dirac-DCT dictionary is given by
    
    
    .. math::
        \mu_p(k) = k^{\frac{1}{p}} \mu \Forall 1\leq k \leq N.
    
    In particular, the standard \hyperref[def:babel_function]{Babel function}
    is given by
    
    
    .. math::
        \mu_1(k) = k\mu
    



.. proof:: 

    TODO prove it.


